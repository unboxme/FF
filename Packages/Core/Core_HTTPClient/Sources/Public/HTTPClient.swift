//
//  Created on 21/10/2023
//  Copyright © Pavel Puzyrev. All rights reserved.
//

import Foundation
import Core_Utils

public protocol HTTPClientProtocol: AnyObject {
    var requestModifiersSource: HTTPRequestModifiersSource? { get set }

    func request(_ request: HTTPRequest) async throws -> Data
}

public final class HTTPClient: HTTPClientProtocol {
    // MARK: Public properties
    public weak var requestModifiersSource: HTTPRequestModifiersSource?

    // MARK: Private properties
    private let baseURL: URL
    private let session: URLSession

    // MARK: Init
    public init(session: URLSession, baseURL: URL) {
        self.session = session
        self.baseURL = baseURL
    }

    // MARK: HTTPClientProtocol
    public func request(_ request: HTTPRequest) async throws -> Data {
        let urlRequest = try makeURLRequest(for: request)

        let (data, response) = try await session.data(for: urlRequest)

        guard let response = response as? HTTPURLResponse else {
            throw HTTPRequestError.invalidResponse(response)
        }

        if 200...299 ~= response.statusCode {
            return data
        } else {
            throw HTTPRequestError.requestFailed(statusCode: response.statusCode, data: data)
        }
    }
}

// MARK: - Private methods
extension HTTPClient {
    private func makeURLRequest(for request: HTTPRequest) throws -> URLRequest {
        guard let url = URL(string: request.path, relativeTo: baseURL) else {
            throw HTTPRequestError.invalidRequest(request)
        }

        let requestModifiers = requestModifiersSource?.requestModifiers(request) ?? HTTPRequestModifiers()

        let commonQueryItems = requestModifiers.parameters.asURLQueryItems
        let requestQueryItems = request.parameters.asURLQueryItems
            .filter { queryItem in
                commonQueryItems.contains { $0.name != queryItem.name }
            }

        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = commonQueryItems + requestQueryItems

        var urlRequest = URLRequest(url: baseURL, timeoutInterval: 15)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = requestModifiers.headers
        urlRequest.url = urlComponents?.url

        return urlRequest
    }
}

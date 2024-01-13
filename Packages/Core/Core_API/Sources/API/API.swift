//
//  Created on 30/10/2023
//  Copyright © Pavel Puzyrev. All rights reserved.
//

import Foundation
import Core_Utils
import Core_HTTPClient

public protocol API: AnyObject, HTTPRequestModifiersSource {
    var httpClient: HTTPClientProtocol { get }
    var successResponseDecoder: JSONDecoder? { get }
    var errorResponseDecoder: JSONDecoder? { get }
    var commonHeaders: [String: String] { get }
    var commonParameters: URLQueryItemsConvertible { get }
}

// MARK: - Default implementations
extension API {
    public var successResponseDecoder: JSONDecoder? { nil }
    public var errorResponseDecoder: JSONDecoder? { nil }
    public var commonHeaders: [String: String] { [:] }
    public var commonParameters: URLQueryItemsConvertible { [:] }

    public func request<T: APIRequest>(_ request: T) async throws -> T.SuccessModel {
        assert(httpClient.requestModifiersSource != nil, "HTTPClient.requestModifiersSource is nil")

        typealias APIError = Core_API.APIError<T.ErrorModel>

        do {
            let data = try await httpClient.request(request)

            if let successResponseDecoder {
                return try successResponseDecoder.decode(T.SuccessModel.self, from: data)
            } else if let noneModel = NoneModel() as? T.SuccessModel {
                return noneModel
            } else {
                throw APIError.unknown(nil)
            }
        } catch let error as DecodingError {
            throw APIError.decodingFailed(error)
        } catch let error as HTTPRequestError {
            switch error {
            case .invalidRequest:
                throw APIError.unknown(error)
            case .invalidResponse:
                throw APIError.unknown(error)
            case .networkFailed(let urlError):
                throw APIError.networkFailed(urlError)
            case .requestFailed(let statusCode, let data):
                do {
                    if let errorResponseDecoder {
                        let errorModel = try errorResponseDecoder.decode(T.ErrorModel.self, from: data)
                        throw APIError.requestFailed(statusCode: statusCode, model: errorModel)
                    } else if let noneModel = NoneModel() as? T.ErrorModel {
                        throw APIError.requestFailed(statusCode: statusCode, model: noneModel)
                    } else {
                        throw APIError.unknown(nil)
                    }
                } catch let error as APIError {
                    throw error
                } catch {
                    throw APIError.unknown(error)
                }
            }
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.unknown(error)
        }
    }
}

// MARK: - HTTPRequestModifiersSource
extension API {
    public func requestModifiers(_ request: HTTPRequest) -> HTTPRequestModifiers {
        HTTPRequestModifiers(
            headers: commonHeaders,
            parameters: commonParameters
        )
    }
}

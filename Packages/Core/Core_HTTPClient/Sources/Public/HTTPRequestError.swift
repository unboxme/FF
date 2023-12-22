//
//  Created on 21/10/2023
//  Copyright © Pavel Puzyrev. All rights reserved.
//

import Foundation

public enum HTTPRequestError: LocalizedError {
    case invalidRequest(HTTPRequest)
    case invalidResponse(URLResponse)
    case networkFailed(URLError)
    case requestFailed(statusCode: Int, data: Data)

    public var errorDescription: String? {
        switch self {
        case .invalidRequest:
            return "Invalid request"
        case .invalidResponse:
            return "Invalid response"
        case .networkFailed:
            return "Internet connection check needed"
        case .requestFailed:
            return "Something went wrong"
        }
    }

    public var failureReason: String? {
        switch self {
        case .invalidRequest(let request):
            return "Invalid request with query path \(request.path)"
        case .invalidResponse(let response):
            return "Invalid response with URL \(response.url?.absoluteString ?? "nil")"
        case .networkFailed(let error):
            return "Network failed with code \(error.errorCode)"
        case .requestFailed(let statusCode, _):
            return "Request failed with status code \(statusCode)"
        }
    }
}

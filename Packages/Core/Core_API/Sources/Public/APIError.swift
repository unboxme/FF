//
//  Created on 30/10/2023
//  Copyright © Pavel Puzyrev. All rights reserved.
//

import Foundation

public enum APIError<T>: LocalizedError {
    case networkFailed(URLError)
    case decodingFailed(DecodingError)
    case requestFailed(statusCode: Int, model: T)
    case unknown(Error?)

    public var errorDescription: String? {
        switch self {
        case .networkFailed:
            "Internet connection check needed"
        case .requestFailed, .decodingFailed:
            "Something went wrong"
        case .unknown:
            "Unknown error"
        }
    }

    public var failureReason: String? {
        switch self {
        case .networkFailed(let error):
            return "Network failed with code \(error.errorCode)"
        case .decodingFailed(let error):
            let prefix = "Decoding failed."
            switch error {
            case .typeMismatch(let any, let context):
                let details = context.codingPath.description()
                return "\(prefix) Type mismatch \(type(of: any)):\n\(details)"
            case .valueNotFound(let any, let context):
                let details = context.codingPath.description()
                return "\(prefix) Value not found for type \(type(of: any)):\n\(details)"
            case .keyNotFound(let codingKey, let context):
                let details = (context.codingPath + [codingKey]).description()
                return "\(prefix) Key not found:\n\(details)"
            case .dataCorrupted:
                return "\(prefix) Data corrupted"
            @unknown default:
                return "\(prefix) Unknown"
            }
        case .requestFailed(let statusCode, let model):
            return "Request failed with status code \(statusCode) and model of type \(type(of: model))"
        case .unknown(let error):
            return "Request failed: \(error?.localizedDescription ?? "nil")"
        }
    }
}

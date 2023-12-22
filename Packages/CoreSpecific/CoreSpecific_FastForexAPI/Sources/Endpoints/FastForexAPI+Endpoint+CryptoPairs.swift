//
//  Created on 05/11/2023
//  Copyright © Pavel Puzyrev. All rights reserved.
//

import Foundation
import Core_API
import Core_Utils

extension FastForexAPI.Endpoint {
    public enum CryptoPairs { }
}

// MARK: - Requests
extension FastForexAPI.Endpoint.CryptoPairs {
    public struct GETRequest: APIRequest {
        public typealias SuccessModel = ResponseContainer

        public let method: HTTPMethod = .get
        public let path = "/crypto/pairs"

        public init() { }
    }
}

// MARK: - Responses
extension FastForexAPI.Endpoint.CryptoPairs {
    public struct ResponseContainer: Decodable {
        public struct Pair: Decodable {
            public let quote: String
            public let base: String
        }

        public let pairs: [String: Pair]
        public let ms: Int
    }
}

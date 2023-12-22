//
//  Created on 05/11/2023
//  Copyright © Pavel Puzyrev. All rights reserved.
//

import Foundation
import Core_API
import Core_Utils

extension FastForexAPI.Endpoint {
    public enum CryptoCurrencies { }
}

// MARK: - Requests
extension FastForexAPI.Endpoint.CryptoCurrencies {
    public struct GETRequest: APIRequest {
        public typealias SuccessModel = ResponseContainer

        public let method: HTTPMethod = .get
        public let path = "/crypto/currencies"

        public init() { }
    }
}

// MARK: - Responses
extension FastForexAPI.Endpoint.CryptoCurrencies {
    public struct ResponseContainer: Decodable {
        public let currencies: [String: String]
        public let ms: Int
    }
}

//
//  Created on 05/11/2023
//  Copyright © Pavel Puzyrev. All rights reserved.
//

import Foundation
import Core_API
import Core_Utils

extension FastForexAPI.Endpoint {
    public enum CryptoFetchPrices { }
}

// MARK: - Requests
extension FastForexAPI.Endpoint.CryptoFetchPrices {
    public struct GETRequest: APIRequest {
        public typealias SuccessModel = ResponseContainer

        public let method: HTTPMethod = .get
        public let path = "/crypto/fetch-prices"
        public let parameters: URLQueryItemsConvertible

        public init(pairs: [String]) {
            self.parameters = [
                "pairs": pairs.joined(separator: ",")
            ]
        }
    }
}

// MARK: - Responses
extension FastForexAPI.Endpoint.CryptoFetchPrices {
    public struct ResponseContainer: Decodable {
        public let prices: [String: Decimal]
        public let ms: Int
    }
}

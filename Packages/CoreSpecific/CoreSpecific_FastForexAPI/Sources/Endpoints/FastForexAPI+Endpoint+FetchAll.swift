//
//  Created on 05/11/2023
//  Copyright © Pavel Puzyrev. All rights reserved.
//

import Foundation
import Core_API
import Core_Utils

extension FastForexAPI.Endpoint {
    public enum FetchAll { }
}

// MARK: - Requests
extension FastForexAPI.Endpoint.FetchAll {
    public struct GETRequest: APIRequest {
        public typealias SuccessModel = ResponseContainer

        public let method: HTTPMethod = .get
        public let path = "/fetch-all"
        public let parameters: URLQueryItemsConvertible

        public init(from: String) {
            self.parameters = [
                "from": from
            ]
        }
    }
}

// MARK: - Responses
extension FastForexAPI.Endpoint.FetchAll {
    public struct ResponseContainer: Decodable {
        public let base: String
        public let results: [String: Decimal]
        public let updated: Date
        public let ms: Int
    }
}

//
//  Created on 03/11/2023
//  Copyright © Pavel Puzyrev. All rights reserved.
//

import Foundation
import Core_API
import Core_Utils

extension FastForexAPI.Endpoint {
    public enum Currencies { }
}

// MARK: - Requests
extension FastForexAPI.Endpoint.Currencies {
    public struct GETRequest: APIRequest {
        public typealias SuccessModel = ResponseContainer

        public let method: HTTPMethod = .get
        public let path = "/currencies"

        public init() { }
    }
}

// MARK: - Responses
extension FastForexAPI.Endpoint.Currencies {
    public struct ResponseContainer: Decodable {
        public let currencies: [String: String]
        public let ms: Int
    }
}

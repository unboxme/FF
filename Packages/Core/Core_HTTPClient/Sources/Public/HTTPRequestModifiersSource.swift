//
//  Created on 30/10/2023
//  Copyright © Pavel Puzyrev. All rights reserved.
//

import Core_Utils

public struct HTTPRequestModifiers {
    public let headers: [String: String]
    public let parameters: URLQueryItemsConvertible

    public init(
        headers: [String: String] = [:],
        parameters: URLQueryItemsConvertible = [:]
    ) {
        self.headers = headers
        self.parameters = parameters
    }
}

public protocol HTTPRequestModifiersSource: AnyObject {
    func requestModifiers(_ request: HTTPRequest) -> HTTPRequestModifiers
}

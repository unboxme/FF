//
//  Created on 21/10/2023
//  Copyright © Pavel Puzyrev. All rights reserved.
//

import Foundation
import Core_Utils

public protocol HTTPRequest {
    var method: HTTPMethod { get }
    var path: String { get }
    var headers: [String: String] { get }
    var parameters: URLQueryItemsConvertible { get }
}

// MARK: - Default implementations
extension HTTPRequest {
    public var headers: [String: String] { [:] }
    public var parameters: URLQueryItemsConvertible { [:] }
}

// MARK: - Related types
public enum HTTPMethod: String {
    case get = "GET"
}

//
//  Created on 30/10/2023
//  Copyright © Pavel Puzyrev. All rights reserved.
//

import Foundation

public protocol URLQueryItemsConvertible {
    var asURLQueryItems: [URLQueryItem] { get }
}

extension Dictionary<String, String>: URLQueryItemsConvertible {
    public var asURLQueryItems: [URLQueryItem] {
        self.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}

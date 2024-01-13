//
//  Created on 13/01/2024
//  Copyright © Pavel Puzyrev. All rights reserved.
//

import Foundation

public protocol KeyValueStorageKey {
    var string: String { get }
}

extension String: KeyValueStorageKey {
    public var string: String { self }
}

public protocol KeyValueStorage: AnyObject {
    subscript<T: Codable>(_ key: KeyValueStorageKey) -> T? { get set }
}

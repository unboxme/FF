//
//  Created on 13/01/2024
//  Copyright © Pavel Puzyrev. All rights reserved.
//

import Foundation
import KeychainAccess

public final class SecureStorage: KeyValueStorage {
    // MARK: Private properties
    private let keychain: Keychain

    // MARK: Init
    public init(storageId: String) {
        self.keychain = Keychain(service: storageId)
    }

    // MARK: KeyValueStorage
    public subscript<T: Codable>(key: KeyValueStorageKey) -> T? {
        get {
            guard let data = keychain[data: key.string] else { return nil }

            return try? JSONDecoder().decode(T.self, from: data)
        }
        set {
            keychain[data: key.string] = try? JSONEncoder().encode(newValue)
        }
    }
}

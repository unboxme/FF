//
//  Created on 13/01/2024
//  Copyright © Pavel Puzyrev. All rights reserved.
//

import Foundation
import Core_KeyValueStorage
import CoreSpecific_Primitives

struct APIKeys: Codable {
    let fastForex: String
}

protocol SaveAPIKeysUseCaseProtocol: AnyObject {
    func perform() async throws
}

final class SaveAPIKeysUseCase: SaveAPIKeysUseCaseProtocol {
    private let secureStorage: KeyValueStorage

    init(secureStorage: KeyValueStorage) {
        self.secureStorage = secureStorage
    }

    func perform() async throws {
        let resource = OnDemandResourceMetadata.fastForex

        let request = NSBundleResourceRequest(tags: [resource.tag])
        try await request.beginAccessingResources()

        guard let url = Bundle.main.url(
            forResource: resource.name,
            withExtension: resource.extension
        ) else {
            throw UseCaseError.invalidURL
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let data = try Data(contentsOf: url)
        let value = try decoder.decode(APIKeys.self, from: data)
        secureStorage[SecureStorageKey.apiKeys] = value

        request.endAccessingResources()
    }
}

extension SaveAPIKeysUseCase {
    enum UseCaseError: Error {
        case invalidURL
    }
}

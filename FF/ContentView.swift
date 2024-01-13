//
//  ContentView.swift
//  FF
//
//  Created by Pavel Puzyrev on 20/10/2023.
//

import SwiftUI

struct ContentView: View {
    var dependencies = Dependencies()

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear() {
            Task {
                let request = FastForexAPI.Endpoint.Currencies.GETRequest()
                do {
                    let response = try await dependencies.fastForexAPI.request(request)
                    print(response)
                } catch {
                    print(error)
                }

            }
        }
    }
}

// MARK: - Temporary code goes below

import Core_HTTPClient
import CoreSpecific_FastForexAPI
import Core_Utils
import Core_KeyValueStorage
import CoreSpecific_Primitives

final class Dependencies {
    private(set) lazy var httpClient: HTTPClientProtocol = HTTPClient(
        session: .shared,
        baseURL: URL(string: "https://api.fastforex.io")!
    ) {
        try? await self.saveAPIKeysUseCase.perform()
    }
    private(set) lazy var fastForexAPI: FastForexAPIProtocol = FastForexAPI(
        httpClient: httpClient,
        commonParameters: fastForexAPICommonParameters
    )
    private(set) lazy var fastForexAPICommonParameters: URLQueryItemsConvertible = FastForexAPICommonParameters(
        secureStorage: secureStorage
    )
    private(set) lazy var secureStorage: KeyValueStorage = SecureStorage(storageId: "FF")
    private(set) lazy var saveAPIKeysUseCase: SaveAPIKeysUseCaseProtocol = SaveAPIKeysUseCase(
        secureStorage: secureStorage
    )
}

struct FastForexAPICommonParameters: URLQueryItemsConvertible {
    let secureStorage: KeyValueStorage

    var asURLQueryItems: [URLQueryItem] {
        let apiKeys: APIKeys? = secureStorage[SecureStorageKey.apiKeys]

        return [
            URLQueryItem(name: "api_key", value: apiKeys?.fastForex)
        ]
    }
}

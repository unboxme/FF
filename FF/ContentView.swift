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
                await dependencies.setup()

                do {
                    let baseCode = "RUB"
                    let fiatRates = try await dependencies.fiatAssetsRatesRepository.read(from: .cachePreferred, for: baseCode)

                    let userPortfolio = UserPortfolio(
                        id: UUID().uuidString,
                        name: "Test",
                        assets: [
                            UserPortfolioAsset(
                                id: UUID().uuidString,
                                code: "RUB",
                                type: .fiat,
                                balances: [
                                    UserPortfolioAssetBalance(
                                        id: UUID().uuidString,
                                        amount: 100,
                                        addedAt: .now
                                    )
                                ]
                            ),
                            UserPortfolioAsset(
                                id: UUID().uuidString,
                                code: "RUB",
                                type: .fiat,
                                balances: [
                                    UserPortfolioAssetBalance(
                                        id: UUID().uuidString,
                                        amount: 100,
                                        addedAt: .now
                                    )
                                ]
                            ),
                            UserPortfolioAsset(
                                id: UUID().uuidString,
                                code: "EUR",
                                type: .fiat,
                                balances: [
                                    UserPortfolioAssetBalance(
                                        id: UUID().uuidString,
                                        amount: 1,
                                        addedAt: .now
                                    )
                                ]
                            )
                        ]
                    )
                    let convertedPortfolio = ConvertedUserPortfolioFactory.make(
                        from: userPortfolio,
                        baseAssetCode: baseCode,
                        baseAssetType: .fiat,
                        rates: [.fiat: fiatRates]
                    )

                    let assets = ConvertedUserAssetsFactory.make(from: [convertedPortfolio])

                    print(convertedPortfolio)
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
import DomainSpecific_Balance
import Core_DataBaseStorage
import Domain_Currencies
import Domain_UserPortfolio

final class Dependencies {
    private(set) lazy var httpClient: HTTPClientProtocol = HTTPClient(
        session: .shared,
        baseURL: URL(string: "https://api.fastforex.io")!,
        requestEventHandler: requestEventHandler
    )
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
    private(set) lazy var requestEventHandler: HTTPRequestEventHandler = RequestEventHandler(
        saveAPIKeysUseCase: saveAPIKeysUseCase
    )
    private(set) lazy var fiatAssetsRatesRepository: FiatAssetsRatesRepositoryProtocol = FiatAssetsRatesRepository(
        fastForexAPI: fastForexAPI,
        dataBaseStorage: dataBaseStorage
    )
    private(set) lazy var fiatAssetsRepository: FiatAssetsRepositoryProtocol = FiatAssetsRepository(
        fastForexAPI: fastForexAPI,
        dataBaseStorage: dataBaseStorage
    )
    private(set) var dataBaseStorage: DataBaseStorageProtocol!

    func setup() async {
        dataBaseStorage = await DataBaseStorage()
    }
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

struct RequestEventHandler: HTTPRequestEventHandler {
    let saveAPIKeysUseCase: SaveAPIKeysUseCaseProtocol

    func before() async {
        try? await self.saveAPIKeysUseCase.perform()
    }
}

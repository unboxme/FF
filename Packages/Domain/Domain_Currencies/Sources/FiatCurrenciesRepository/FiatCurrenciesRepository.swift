//
//  Created on 22/10/2023
//  Copyright © Pavel Puzyrev. All rights reserved.
//

import Foundation
import Core_API
import Core_DataBaseStorage
import CoreSpecific_Primitives
import CoreSpecific_FastForexAPI

public protocol FiatCurrenciesRepositoryProtocol {
    func read(from dataSource: RepositoryDataSource) async throws -> [FiatCurrency]
}

public final class FiatCurrenciesRepository: FiatCurrenciesRepositoryProtocol {
    // MARK: Private properties
    private let fastForexAPI: FastForexAPIProtocol
    private let dataBaseStorage: DataBaseStorageProtocol

    // MARK: Init
    public init(
        fastForexAPI: FastForexAPIProtocol,
        dataBaseStorage: DataBaseStorageProtocol
    ) {
        self.fastForexAPI = fastForexAPI
        self.dataBaseStorage = dataBaseStorage
    }

    // MARK: - FiatCurrenciesRepositoryProtocol
    public func read(from dataSource: RepositoryDataSource) async throws -> [FiatCurrency] {
        switch dataSource {
        case .backend:
            let request = FastForexAPI.Endpoint.Currencies.GETRequest()

            do {
                let response = try await fastForexAPI.request(request)
                let fiatCurrencies = FiatCurrenciesFactory.make(from: response)

                await dataBaseStorage.save(fiatCurrencies)

                return fiatCurrencies
            } catch {
                throw RepositoryError(request.castError(error))
            }
        case .cache:
            let fiatCurrencies = await dataBaseStorage.retrieveAll(of: FiatCurrency.self)

            if fiatCurrencies.isEmpty {
                throw RepositoryError.cacheEmpty
            } else {
                return fiatCurrencies
            }
        }
    }
}

// MARK: - Types
extension FiatCurrenciesRepository {
    public enum RepositoryError: Error {
        case networkFailed
        case requestFailed
        case unknown
        case cacheEmpty

        init(_ apiError: APIError<NoneModel>) {
            switch apiError {
            case .networkFailed: self = .networkFailed
            case .requestFailed: self = .requestFailed
            case .decodingFailed, .unknown: self = .unknown
            }
        }
    }
}

//
//  Created on 10/11/2023
//  Copyright © Pavel Puzyrev. All rights reserved.
//

import Foundation
import Core_API
import Core_DataBaseStorage
import CoreSpecific_FastForexAPI
import CoreSpecific_Primitives

public protocol FiatCurrenciesRatesRepositoryProtocol {
    func read(from dataSource: RepositoryDataSource, for baseCode: String) async throws -> FiatCurrenciesRates
}

public final class FiatCurrenciesRatesRepository: FiatCurrenciesRatesRepositoryProtocol {
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
    public func read(from dataSource: RepositoryDataSource, for baseCode: String) async throws -> FiatCurrenciesRates {
        switch dataSource {
        case .backend:
            let request = FastForexAPI.Endpoint.FetchAll.GETRequest(from: baseCode)

            do {
                let response = try await fastForexAPI.request(request)
                let fiatCurrenciesRates = FiatCurrenciesRatesFactory.make(from: response)

                await dataBaseStorage.save(fiatCurrenciesRates)

                return fiatCurrenciesRates
            } catch {
                throw RepositoryError(request.castError(error))
            }
        case .cache:
            let fiatCurrenciesRates = await dataBaseStorage.retrieveAll(of: FiatCurrenciesRates.self) { model in
                model.baseCode == baseCode
            }
            
            if fiatCurrenciesRates.isEmpty {
                throw RepositoryError.cacheEmpty
            } else {
                return fiatCurrenciesRates[0]
            }
        }
    }
}

// MARK: - Types
extension FiatCurrenciesRatesRepository {
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

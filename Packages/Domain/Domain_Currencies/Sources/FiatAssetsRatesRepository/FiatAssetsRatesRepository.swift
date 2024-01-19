//
//  Created on 10/11/2023
//  Copyright © Pavel Puzyrev. All rights reserved.
//

import Foundation
import Core_API
import Core_DataBaseStorage
import CoreSpecific_FastForexAPI
import CoreSpecific_Primitives

public protocol FiatAssetsRatesRepositoryProtocol {
    func read(from dataSource: RepositoryDataSource, for baseCode: String) async throws -> FiatAssetsRates
}

public final class FiatAssetsRatesRepository: FiatAssetsRatesRepositoryProtocol {
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

    // MARK: - FiatAssetsRepositoryProtocol
    public func read(from dataSource: RepositoryDataSource, for baseCode: String) async throws -> FiatAssetsRates {
        switch dataSource {
        case .backend:
            let request = FastForexAPI.Endpoint.FetchAll.GETRequest(from: baseCode)

            do {
                let response = try await fastForexAPI.request(request)
                let fiatCurrenciesRates = FiatAssetsRatesFactory.make(from: response)

                await dataBaseStorage.save(fiatCurrenciesRates)

                return fiatCurrenciesRates
            } catch {
                throw RepositoryError(request.castError(error))
            }
        case .cachePreferred:
            let fiatCurrenciesRates = await dataBaseStorage.retrieveAll(of: FiatAssetsRates.self) { model in
                model.baseCode == baseCode
            }
            
            if fiatCurrenciesRates.isEmpty {
                return try await read(from: .backend, for: baseCode)
            } else {
                return fiatCurrenciesRates[0]
            }
        }
    }
}

// MARK: - Types
extension FiatAssetsRatesRepository {
    public enum RepositoryError: Error {
        case networkFailed
        case requestFailed
        case unknown

        init(_ apiError: APIError<NoneModel>) {
            switch apiError {
            case .networkFailed: self = .networkFailed
            case .requestFailed: self = .requestFailed
            case .decodingFailed, .unknown: self = .unknown
            }
        }
    }
}

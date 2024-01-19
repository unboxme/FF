//
//  Created on 22/10/2023
//  Copyright © Pavel Puzyrev. All rights reserved.
//

import Foundation
import Core_API
import Core_DataBaseStorage
import CoreSpecific_Primitives
import CoreSpecific_FastForexAPI

public protocol FiatAssetsRepositoryProtocol {
    func read(from dataSource: RepositoryDataSource) async throws -> [FiatAsset]
}

public final class FiatAssetsRepository: FiatAssetsRepositoryProtocol {
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
    public func read(from dataSource: RepositoryDataSource) async throws -> [FiatAsset] {
        switch dataSource {
        case .backend:
            let request = FastForexAPI.Endpoint.Currencies.GETRequest()

            do {
                let response = try await fastForexAPI.request(request)
                let fiatCurrencies = FiatAssetsFactory.make(from: response)

                await dataBaseStorage.save(fiatCurrencies)

                return fiatCurrencies
            } catch {
                throw RepositoryError(request.castError(error))
            }
        case .cachePreferred:
            let fiatCurrencies = await dataBaseStorage.retrieveAll(of: FiatAsset.self)

            if fiatCurrencies.isEmpty {
                return try await read(from: .backend)
            } else {
                return fiatCurrencies
            }
        }
    }
}

// MARK: - Types
extension FiatAssetsRepository {
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

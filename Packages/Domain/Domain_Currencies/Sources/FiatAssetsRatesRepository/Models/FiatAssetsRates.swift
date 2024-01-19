//
//  Created on 10/11/2023
//  Copyright © Pavel Puzyrev. All rights reserved.
//

import Foundation
import Core_DataBaseStorage
import CoreSpecific_Primitives

public struct FiatAssetsRates: AssetsRates {
    public let baseCode: String
    public let rates: [AssetRate]
    public let updatedAt: Date
}

public final class FiatAssetsRatesDataBaseModel: Object {
    @Persisted(primaryKey: true)
    public fileprivate(set) var baseCode: String
    @Persisted
    public fileprivate(set) var rates: List<FiatAssetRateDataBaseModel>
    @Persisted
    public fileprivate(set) var updatedAt: Date
}

extension FiatAssetsRates: DataBaseStorable {
    public func makeDataBaseModel() -> FiatAssetsRatesDataBaseModel {
        let model = FiatAssetsRatesDataBaseModel()
        model.baseCode = baseCode
        model.rates.append(objectsIn: rates.compactMap { ($0 as? FiatAssetRate)?.makeDataBaseModel() })
        model.updatedAt = updatedAt
        return model
    }

    public static func make(from model: FiatAssetsRatesDataBaseModel) -> FiatAssetsRates {
        FiatAssetsRates(
            baseCode: model.baseCode,
            rates: model.rates.map { FiatAssetRate.make(from: $0) },
            updatedAt: model.updatedAt
        )
    }
}

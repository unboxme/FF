//
//  Created on 10/11/2023
//  Copyright © Pavel Puzyrev. All rights reserved.
//

import Foundation
import Core_DataBaseStorage

public struct FiatCurrenciesRates {
    public let baseCode: String
    public let rates: [FiatCurrencyRate]
    public let updatedAt: Date
}

public final class FiatCurrenciesRatesDataBaseModel: Object {
    @Persisted(primaryKey: true)
    public fileprivate(set) var baseCode: String
    @Persisted
    public fileprivate(set) var rates: List<FiatCurrencyRateDataBaseModel>
    @Persisted
    public fileprivate(set) var updatedAt: Date
}

extension FiatCurrenciesRates: DataBaseStorable {
    public func makeDataBaseModel() -> FiatCurrenciesRatesDataBaseModel {
        let model = FiatCurrenciesRatesDataBaseModel()
        model.baseCode = baseCode
        model.rates.append(objectsIn: rates.map { $0.makeDataBaseModel() })
        model.updatedAt = updatedAt
        return model
    }

    public static func make(from model: FiatCurrenciesRatesDataBaseModel) -> FiatCurrenciesRates {
        FiatCurrenciesRates(
            baseCode: model.baseCode,
            rates: model.rates.map { FiatCurrencyRate.make(from: $0) },
            updatedAt: model.updatedAt
        )
    }
}

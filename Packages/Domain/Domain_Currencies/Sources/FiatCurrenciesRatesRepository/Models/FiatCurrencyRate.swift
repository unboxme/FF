//
//  Created on 19/11/2023
//  Copyright © Pavel Puzyrev. All rights reserved.
//

import Foundation
import Core_DataBaseStorage

public struct FiatCurrencyRate {
    public let code: String
    public let rate: Decimal
}

public final class FiatCurrencyRateDataBaseModel: Object {
    @Persisted(primaryKey: true)
    public fileprivate(set) var code: String
    @Persisted
    public fileprivate(set) var rate: Decimal128
}

extension FiatCurrencyRate: DataBaseStorable {
    public func makeDataBaseModel() -> FiatCurrencyRateDataBaseModel {
        let model = FiatCurrencyRateDataBaseModel()
        model.code = code
        model.rate = Decimal128(value: rate)
        return model
    }

    public static func make(from model: FiatCurrencyRateDataBaseModel) -> FiatCurrencyRate {
        FiatCurrencyRate(
            code: model.code,
            rate: model.rate.decimalValue
        )
    }
}

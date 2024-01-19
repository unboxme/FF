//
//  Created on 19/11/2023
//  Copyright © Pavel Puzyrev. All rights reserved.
//

import Foundation
import Core_DataBaseStorage
import CoreSpecific_Primitives

public struct FiatAssetRate: AssetRate {
    public let code: String
    public let rate: Decimal
}

public final class FiatAssetRateDataBaseModel: Object {
    @Persisted(primaryKey: true)
    public fileprivate(set) var code: String
    @Persisted
    public fileprivate(set) var rate: Decimal128
}

extension FiatAssetRate: DataBaseStorable {
    public func makeDataBaseModel() -> FiatAssetRateDataBaseModel {
        let model = FiatAssetRateDataBaseModel()
        model.code = code
        model.rate = Decimal128(value: rate)
        return model
    }

    public static func make(from model: FiatAssetRateDataBaseModel) -> FiatAssetRate {
        FiatAssetRate(
            code: model.code,
            rate: model.rate.decimalValue
        )
    }
}

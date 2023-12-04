//
//  Created on 19/11/2023
//  Copyright © Pavel Puzyrev. All rights reserved.
//

import Foundation
import Core_DataBaseStorage

public struct FiatCurrency {
    public let code: String
    public let name: String
}

public final class FiatCurrencyDataBaseModel: Object {
    @Persisted(primaryKey: true)
    public fileprivate(set) var code: String
    @Persisted
    public fileprivate(set) var name: String
}

extension FiatCurrency: DataBaseStorable {
    public func makeDataBaseModel() -> FiatCurrencyDataBaseModel {
        let model = FiatCurrencyDataBaseModel()
        model.code = code
        model.name = name
        return model
    }

    public static func make(from model: FiatCurrencyDataBaseModel) -> FiatCurrency {
        FiatCurrency(
            code: model.code,
            name: model.name
        )
    }
}

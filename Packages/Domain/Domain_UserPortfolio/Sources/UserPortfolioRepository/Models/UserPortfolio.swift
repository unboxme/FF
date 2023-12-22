//
//  Created on 10/11/2023
//  Copyright © Pavel Puzyrev. All rights reserved.
//

import Foundation
import Core_DataBaseStorage
import CoreSpecific_Primitives

public struct UserPortfolio {
    let id: String
    let name: String
    let currencyCode: String
    let currencyType: CurrencyType
    let balance: Decimal
}

public final class UserPortfolioDataBaseModel: Object {
    @Persisted(primaryKey: true)
    public fileprivate(set) var id: String
    @Persisted
    public fileprivate(set) var name: String
    @Persisted
    public fileprivate(set) var currencyCode: String
    @Persisted
    public fileprivate(set) var currencyType: CurrencyType
    @Persisted
    public fileprivate(set) var balance: Decimal128
}

extension UserPortfolio: DataBaseStorable {
    public func makeDataBaseModel() -> UserPortfolioDataBaseModel {
        let model = UserPortfolioDataBaseModel()
        model.id = id
        model.name = name
        model.currencyCode = currencyCode
        model.currencyType = currencyType
        model.balance = Decimal128(value: balance)
        return model
    }

    public static func make(from model: UserPortfolioDataBaseModel) -> UserPortfolio {
        UserPortfolio(
            id: model.id,
            name: model.name,
            currencyCode: model.currencyCode,
            currencyType: model.currencyType,
            balance: model.balance.decimalValue
        )
    }
}

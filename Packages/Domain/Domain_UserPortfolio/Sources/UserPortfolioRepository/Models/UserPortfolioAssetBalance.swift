//
//  Created on 14/01/2024
//  Copyright © Pavel Puzyrev. All rights reserved.
//

import Foundation
import Core_DataBaseStorage

public struct UserPortfolioAssetBalance {
    public let id: String
    public let amount: Decimal
    public let addedAt: Date

    public static var zero: UserPortfolioAssetBalance {
        UserPortfolioAssetBalance(
            id: UUID().uuidString,
            amount: 0,
            addedAt: Date()
        )
    }

    public init(id: String, amount: Decimal, addedAt: Date) {
        self.id = id
        self.amount = amount
        self.addedAt = addedAt
    }
}

public final class UserPortfolioAssetBalanceDataBaseModel: Object {
    @Persisted(primaryKey: true)
    public fileprivate(set) var id: String
    @Persisted
    public fileprivate(set) var amount: Decimal128
    @Persisted
    public fileprivate(set) var addedAt: Date
}

extension UserPortfolioAssetBalance: DataBaseStorable {
    public func makeDataBaseModel() -> UserPortfolioAssetBalanceDataBaseModel {
        let model = UserPortfolioAssetBalanceDataBaseModel()
        model.id = id
        model.amount = Decimal128(value: amount)
        model.addedAt = addedAt
        return model
    }

    public static func make(from model: UserPortfolioAssetBalanceDataBaseModel) -> UserPortfolioAssetBalance {
        UserPortfolioAssetBalance(
            id: model.id,
            amount: model.amount.decimalValue,
            addedAt: model.addedAt
        )
    }
}

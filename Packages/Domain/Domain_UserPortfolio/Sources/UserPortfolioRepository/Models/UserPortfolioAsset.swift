//
//  Created on 16/01/2024
//  Copyright © Pavel Puzyrev. All rights reserved.
//

import Foundation
import Core_DataBaseStorage
import CoreSpecific_Primitives

public struct UserPortfolioAsset {
    public let id: String
    public let code: String
    public let type: AssetType
    public let balances: [UserPortfolioAssetBalance]

    public init(id: String, code: String, type: AssetType, balances: [UserPortfolioAssetBalance]) {
        self.id = id
        self.code = code
        self.type = type
        self.balances = balances
    }
}

public final class UserPortfolioAssetDataBaseModel: Object {
    @Persisted(primaryKey: true)
    public fileprivate(set) var id: String
    @Persisted
    public fileprivate(set) var code: String
    @Persisted
    public fileprivate(set) var type: AssetType
    @Persisted
    public fileprivate(set) var balances: List<UserPortfolioAssetBalanceDataBaseModel>
}

extension UserPortfolioAsset: DataBaseStorable {
    public func makeDataBaseModel() -> UserPortfolioAssetDataBaseModel {
        let model = UserPortfolioAssetDataBaseModel()
        model.id = id
        model.code = code
        model.type = type
        model.balances.append(objectsIn: balances.map { $0.makeDataBaseModel() })
        return model
    }

    public static func make(from model: UserPortfolioAssetDataBaseModel) -> UserPortfolioAsset {
        UserPortfolioAsset(
            id: model.id,
            code: model.code,
            type: model.type,
            balances: model.balances.map { UserPortfolioAssetBalance.make(from: $0) }
        )
    }
}

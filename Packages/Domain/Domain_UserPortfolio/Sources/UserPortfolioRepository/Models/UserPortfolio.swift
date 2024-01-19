//
//  Created on 10/11/2023
//  Copyright © Pavel Puzyrev. All rights reserved.
//

import Foundation
import Core_DataBaseStorage
import CoreSpecific_Primitives

public struct UserPortfolio {
    public let id: String
    public let name: String
    public let assets: [UserPortfolioAsset]

    public init(id: String, name: String, assets: [UserPortfolioAsset]) {
        self.id = id
        self.name = name
        self.assets = assets
    }
}

public final class UserPortfolioDataBaseModel: Object {
    @Persisted(primaryKey: true)
    public fileprivate(set) var id: String
    @Persisted
    public fileprivate(set) var name: String
    @Persisted
    public fileprivate(set) var assets: List<UserPortfolioAssetDataBaseModel>
}

extension UserPortfolio: DataBaseStorable {
    public func makeDataBaseModel() -> UserPortfolioDataBaseModel {
        let model = UserPortfolioDataBaseModel()
        model.id = id
        model.name = name
        model.assets.append(objectsIn: assets.map { $0.makeDataBaseModel() })
        return model
    }

    public static func make(from model: UserPortfolioDataBaseModel) -> UserPortfolio {
        UserPortfolio(
            id: model.id,
            name: model.name,
            assets: model.assets.map { UserPortfolioAsset.make(from: $0) }
        )
    }
}

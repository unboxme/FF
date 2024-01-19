//
//  Created on 19/11/2023
//  Copyright © Pavel Puzyrev. All rights reserved.
//

import Foundation
import Core_DataBaseStorage

public struct FiatAsset {
    public let code: String
    public let name: String
}

public final class FiatAssetDataBaseModel: Object {
    @Persisted(primaryKey: true)
    public fileprivate(set) var code: String
    @Persisted
    public fileprivate(set) var name: String
}

extension FiatAsset: DataBaseStorable {
    public func makeDataBaseModel() -> FiatAssetDataBaseModel {
        let model = FiatAssetDataBaseModel()
        model.code = code
        model.name = name
        return model
    }

    public static func make(from model: FiatAssetDataBaseModel) -> FiatAsset {
        FiatAsset(
            code: model.code,
            name: model.name
        )
    }
}

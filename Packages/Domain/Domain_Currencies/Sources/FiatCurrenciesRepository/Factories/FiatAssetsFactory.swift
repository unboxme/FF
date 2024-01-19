//
//  Created on 05/11/2023
//  Copyright © Pavel Puzyrev. All rights reserved.
//

import CoreSpecific_FastForexAPI

enum FiatAssetsFactory {
    static func make(from response: FastForexAPI.Endpoint.Currencies.ResponseContainer) -> [FiatAsset] {
        response.currencies.map {
            FiatAsset(
                code: $0.key,
                name: $0.value
            )
        }
    }
}

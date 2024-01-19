//
//  Created on 10/11/2023
//  Copyright © Pavel Puzyrev. All rights reserved.
//

import CoreSpecific_FastForexAPI

enum FiatAssetsRatesFactory {
    static func make(from response: FastForexAPI.Endpoint.FetchAll.ResponseContainer) -> FiatAssetsRates {
        FiatAssetsRates(
            baseCode: response.base,
            rates: response.results.map {
                FiatAssetRate(
                    code: $0.key,
                    rate: $0.value
                )
            },
            updatedAt: response.updated
        )
    }
}

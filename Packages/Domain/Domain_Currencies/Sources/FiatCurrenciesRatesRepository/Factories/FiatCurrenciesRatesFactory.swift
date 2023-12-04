//
//  Created on 10/11/2023
//  Copyright © Pavel Puzyrev. All rights reserved.
//

import CoreSpecific_FastForexAPI

enum FiatCurrenciesRatesFactory {
    static func make(from response: FastForexAPI.Endpoint.FetchAll.ResponseContainer) -> FiatCurrenciesRates {
        FiatCurrenciesRates(
            baseCode: response.base,
            rates: response.results.map {
                FiatCurrencyRate(
                    code: $0.key,
                    rate: $0.value
                )
            },
            updatedAt: response.updated
        )
    }
}

//
//  Created on 05/11/2023
//  Copyright © Pavel Puzyrev. All rights reserved.
//

import CoreSpecific_FastForexAPI

enum FiatCurrenciesFactory {
    static func make(from response: FastForexAPI.Endpoint.Currencies.ResponseContainer) -> [FiatCurrency] {
        response.currencies.map {
            FiatCurrency(
                code: $0.key,
                name: $0.value
            )
        }
    }
}

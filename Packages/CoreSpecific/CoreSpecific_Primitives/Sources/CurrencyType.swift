//
//  Created on 22/10/2023
//  Copyright © Pavel Puzyrev. All rights reserved.
//

import Core_DataBaseStorage

public enum CurrencyType: String {
    case fiat
    case crypto
}

extension CurrencyType: PersistableEnum { }


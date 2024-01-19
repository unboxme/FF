//
//  Created on 16/01/2024
//  Copyright © Pavel Puzyrev. All rights reserved.
//

import Foundation

public struct AssetDecimal {
    public let code: String
    public let type: AssetType
    public let value: Decimal

    public init(code: String, type: AssetType, value: Decimal) {
        self.code = code
        self.type = type
        self.value = value
    }
}

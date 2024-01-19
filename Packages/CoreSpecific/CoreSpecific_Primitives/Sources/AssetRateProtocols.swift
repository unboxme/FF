//
//  Created on 16/01/2024
//  Copyright © Pavel Puzyrev & Sergey Ivanov. All rights reserved.
//

import Foundation

public protocol AssetRate {
    var code: String { get }
    var rate: Decimal { get }
}

public protocol AssetsRates {
    var baseCode: String { get }
    var rates: [AssetRate] { get }
    var updatedAt: Date { get }
}

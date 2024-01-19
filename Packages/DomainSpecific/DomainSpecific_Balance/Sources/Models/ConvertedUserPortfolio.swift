//
//  Created on 19/11/2023
//  Copyright © Pavel Puzyrev. All rights reserved.
//

import CoreSpecific_Primitives

public struct ConvertedUserPortfolio {
    public let id: String
    public let name: String
    public let convertedTotal: AssetDecimal
    public let assets: [ConvertedUserAsset]
}

//
//  Created on 16/01/2024
//  Copyright © Pavel Puzyrev & Sergey Ivanov. All rights reserved.
//

import Foundation
import Domain_UserPortfolio
import CoreSpecific_Primitives

public enum ConvertedUserPortfolioFactory {
    public static func make(
        from portfolios: [UserPortfolio],
        baseAssetCode: String,
        baseAssetType: AssetType,
        rates: [AssetType: AssetsRates]
    ) -> [ConvertedUserPortfolio] {
        portfolios.map { portfolio in
            make(
                from: portfolio,
                baseAssetCode: baseAssetCode,
                baseAssetType: baseAssetType,
                rates: rates
            )
        }
    }

    public static func make(
        from portfolio: UserPortfolio,
        baseAssetCode: String,
        baseAssetType: AssetType,
        rates: [AssetType: AssetsRates]
    ) -> ConvertedUserPortfolio {
        let convertedAssets = portfolio.assets.map { asset in
            let originalAssetBalance = asset.balances.last ?? .zero
            let originalAsset = AssetDecimal(
                code: asset.code,
                type: asset.type,
                value: originalAssetBalance.amount
            )

            assert(rates.keys.contains(originalAsset.type))

            let convertedAssetRate = rates[originalAsset.type]?.rates
                .first { $0.code == originalAsset.code }?.rate ?? 0
            let convertedAsset = AssetDecimal(
                code: baseAssetCode,
                type: baseAssetType,
                value: originalAsset.value / convertedAssetRate
            )

            return ConvertedUserAsset(
                originalAsset: originalAsset,
                convertedAsset: convertedAsset
            )
        }

        let convertedTotal = AssetDecimal(
            code: baseAssetCode,
            type: baseAssetType,
            value: convertedAssets.map(\.convertedAsset.value).reduce(0, +)
        )

        return ConvertedUserPortfolio(
            id: portfolio.id,
            name: portfolio.name,
            convertedTotal: convertedTotal,
            assets: convertedAssets
        )
    }
}

//
//  Created on 16/01/2024
//  Copyright © Pavel Puzyrev & Sergey Ivanov. All rights reserved.
//

import CoreSpecific_Primitives

public enum ConvertedUserAssetsFactory {
    public static func make(from convertedUserPortfolios: [ConvertedUserPortfolio]) -> [ConvertedUserAsset] {
        var assets: [String: ConvertedUserAsset] = [:]

        convertedUserPortfolios
            .map(\.assets)
            .flatMap { $0 }
            .forEach { asset in
                var totalAsset = asset
                if let asset = assets[asset.originalAsset.code] {
                    // Assumes that asset code and asset type are the same for each entity
                    totalAsset = totalAsset + asset
                }

                assets[asset.originalAsset.code] = ConvertedUserAsset(
                    originalAsset: totalAsset.originalAsset,
                    convertedAsset: totalAsset.convertedAsset
                )
            }

        return assets.values
            .sorted { $0.convertedAsset.value < $1.convertedAsset.value }
    }
}

extension ConvertedUserAsset {
    fileprivate static func + (lhs: ConvertedUserAsset, rhs: ConvertedUserAsset) -> ConvertedUserAsset {
        ConvertedUserAsset(
            originalAsset: lhs.originalAsset + rhs.originalAsset,
            convertedAsset: lhs.convertedAsset + rhs.convertedAsset
        )
    }
}

extension AssetDecimal {
    fileprivate static func + (lhs: AssetDecimal, rhs: AssetDecimal) -> AssetDecimal {
        guard
            lhs.code == rhs.code,
            lhs.type == rhs.type
        else {
            return AssetDecimal(code: "", type: .fiat, value: 0)
        }

        return AssetDecimal(
            code: lhs.code,
            type: rhs.type,
            value: lhs.value + rhs.value
        )
    }
}


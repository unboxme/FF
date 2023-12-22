// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "Domain_UserPortfolio",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "Domain_UserPortfolio",
            targets: ["Domain_UserPortfolio"]
        )
    ],
    dependencies: [
        .package(path: "CoreSpecific_Primitives"),
        .package(path: "Core_DataBaseStorage")
    ],
    targets: [
        .target(
            name: "Domain_UserPortfolio",
            dependencies: [
                .byName(name: "CoreSpecific_Primitives"),
                .byName(name: "Core_DataBaseStorage")
            ],
            path: "Sources"
        )
    ]
)

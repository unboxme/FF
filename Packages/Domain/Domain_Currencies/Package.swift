// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Domain_Currencies",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "Domain_Currencies",
            targets: ["Domain_Currencies"]
        )
    ],
    dependencies: [
        .package(path: "CoreSpecific_Primitives"),
        .package(path: "Core_API"),
        .package(path: "CoreSpecific_FastForexAPI"),
        .package(path: "Core_DataBaseStorage")
    ],
    targets: [
        .target(
            name: "Domain_Currencies",
            dependencies: [
                .byName(name: "CoreSpecific_Primitives"),
                .byName(name: "Core_API"),
                .byName(name: "CoreSpecific_FastForexAPI"),
                .byName(name: "Core_DataBaseStorage")
            ],
            path: "Sources"
        )
    ]
)

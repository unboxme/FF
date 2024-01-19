// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "DomainSpecific_Balance",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "DomainSpecific_Balance",
            targets: ["DomainSpecific_Balance"]
        )
    ],
    dependencies: [
        .package(path: "Domain_Currencies"),
        .package(path: "Domain_UserPortfolio"),
        .package(path: "CoreSpecific_Primitives")
    ],
    targets: [
        .target(
            name: "DomainSpecific_Balance",
            dependencies: [
                .byName(name: "Domain_Currencies"),
                .byName(name: "Domain_UserPortfolio"),
                .byName(name: "CoreSpecific_Primitives")
            ],
            path: "Sources"
        )
    ]
)

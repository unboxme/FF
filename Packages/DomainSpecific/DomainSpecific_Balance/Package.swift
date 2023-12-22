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
    ],
    targets: [
        .target(
            name: "DomainSpecific_Balance",
            dependencies: [
                // Dependencies ...
            ],
            path: "Sources"
        )
    ]
)

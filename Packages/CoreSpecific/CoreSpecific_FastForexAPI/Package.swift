// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "CoreSpecific_FastForexAPI",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "CoreSpecific_FastForexAPI",
            targets: ["CoreSpecific_FastForexAPI"]
        )
    ],
    dependencies: [
        .package(path: "Core_HTTPClient"),
        .package(path: "Core_API"),
        .package(path: "Core_Utils")
    ],
    targets: [
        .target(
            name: "CoreSpecific_FastForexAPI",
            dependencies: [
                .byName(name: "Core_HTTPClient"),
                .byName(name: "Core_API"),
                .byName(name: "Core_Utils")
            ],
            path: "Sources"
        )
    ]
)

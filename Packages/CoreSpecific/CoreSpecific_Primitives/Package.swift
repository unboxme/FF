// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "CoreSpecific_Primitives",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "CoreSpecific_Primitives",
            targets: ["CoreSpecific_Primitives"]
        )
    ],
    dependencies: [
        .package(path: "Core_DataBaseStorage")
    ],
    targets: [
        .target(
            name: "CoreSpecific_Primitives",
            dependencies: [
                .byName(name: "Core_DataBaseStorage")
            ],
            path: "Sources"
        )
    ]
)

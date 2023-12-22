// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Core_API",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "Core_API",
            targets: ["Core_API"]
        )
    ],
    dependencies: [
        .package(path: "Core_HTTPClient")
    ],
    targets: [
        .target(
            name: "Core_API",
            dependencies: [
                .byName(name: "Core_HTTPClient")
            ],
            path: "Sources"
        )
    ]
)

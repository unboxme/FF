// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Core_HTTPClient",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "Core_HTTPClient",
            targets: ["Core_HTTPClient"]
        )
    ],
    dependencies: [
        .package(path: "Core_Utils")
    ],
    targets: [
        .target(
            name: "Core_HTTPClient",
            dependencies: [
                .byName(name: "Core_Utils")
            ],
            path: "Sources"
        )
    ]
)

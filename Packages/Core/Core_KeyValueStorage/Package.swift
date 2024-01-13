// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Core_KeyValueStorage",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "Core_KeyValueStorage",
            targets: ["Core_KeyValueStorage"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess.git", exact: "4.2.2")
    ],
    targets: [
        .target(
            name: "Core_KeyValueStorage",
            dependencies: [
                .product(name: "KeychainAccess", package: "KeychainAccess")
            ],
            path: "Sources"
        )
    ]
)

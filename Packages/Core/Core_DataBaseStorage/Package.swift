// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Core_DataBaseStorage",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "Core_DataBaseStorage",
            targets: ["Core_DataBaseStorage"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/realm/realm-swift.git", exact: "10.44.0")
    ],
    targets: [
        .target(
            name: "Core_DataBaseStorage",
            dependencies: [
                .product(name: "RealmSwift", package: "realm-swift")
            ],
            path: "Sources"
        )
    ]
)

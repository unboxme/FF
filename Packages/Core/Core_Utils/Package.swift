// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Core_Utils",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "Core_Utils",
            targets: ["Core_Utils"]
        )
    ],
    targets: [
        .target(
            name: "Core_Utils",
            path: "Sources"
        )
    ]
)

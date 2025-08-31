// swift-tools-version:6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GameKitUI",
    platforms: [ .iOS(.v16),
                 .macOS(.v13),
                 .tvOS(.v16),
                 .watchOS(.v6)
    ],
    products: [
        .library(
            name: "GameKitUI",
            targets: ["GameKitUI"])
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "GameKitUI"),
        .testTarget(
            name: "GameKitUITests",
            dependencies: ["GameKitUI"])
    ]
)

// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GameKitUI.swift",
    platforms: [ .iOS(SupportedPlatform.IOSVersion.v13),
                 .macOS(SupportedPlatform.MacOSVersion.v10_15),
                 .tvOS(SupportedPlatform.TVOSVersion.v13),
                 .watchOS(SupportedPlatform.WatchOSVersion.v6)
    ],
    products: [
        .library(
            name: "GameKitUI",
            targets: ["GameKitUI"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "GameKitUI",
            dependencies: []),
        .testTarget(
            name: "GameKitUITests",
            dependencies: ["GameKitUI"]),
    ]
)

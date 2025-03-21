// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Weakable",
    platforms: [.macOS(.v11), .iOS(.v12), .tvOS(.v12), .watchOS(.v4)],
    products: [
        .library(
            name: "Weakable",
            targets: ["Weakable"])
    ],
    targets: [
        .target(
            name: "Weakable"
        ),
        .testTarget(
            name: "WeakableTests",
            dependencies: ["Weakable"]
        ),
    ],
    swiftLanguageModes: [
        .v4,
        .v5,
        .v6
    ]
)

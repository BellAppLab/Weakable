// swift-tools-version:4.1

import PackageDescription

let package = Package(
    name: "Weakable",
    products: [
        .library(name: "Weakable",
                 targets: ["Weakable"]),
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
    swiftLanguageVersions: [3, 4]
)

// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AISpeech",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "AISpeech",
            targets: ["AISpeech"]),
    ],
    dependencies: [
        // Dependencies can be added here
    ],
    targets: [
        .target(
            name: "AISpeech",
            dependencies: [],
            path: "Sources"),
        .testTarget(
            name: "AISpeechTests",
            dependencies: ["AISpeech"],
            path: "Tests"),
    ]
)

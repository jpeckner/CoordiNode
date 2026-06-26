// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "CoordiNode",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(name: "CoordiNode", targets: ["CoordiNode"]),
        .library(name: "CoordiNodeTestComponents", targets: ["CoordiNodeTestComponents"]),
        .executable(name: "CoordiNodeGenerator", targets: ["CoordiNodeGenerator"]),
    ],
    targets: [
        .target(
            name: "CoordiNode",
            path: "CoordiNode",
            exclude: ["Info.plist", "CoordiNode.h"],
            resources: [.copy("Resources/CoordiNodeGenerator")]
        ),
        .target(
            name: "CoordiNodeTestComponents",
            dependencies: ["CoordiNode"],
            path: "CoordiNodeTestComponents",
            exclude: ["Info.plist", "Sourcery"]
        ),
        .executableTarget(
            name: "CoordiNodeGenerator",
            path: "CoordiNodeGenerator",
            exclude: ["Info.plist"]
        ),
        .testTarget(
            name: "CoordiNodeTests",
            dependencies: [
                "CoordiNode",
                "CoordiNodeTestComponents",
            ],
            path: "CoordiNodeTests",
            exclude: ["Info.plist"]
        ),
    ]
)

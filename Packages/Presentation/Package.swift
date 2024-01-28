// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Presentation",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "Presentation",
            targets: ["Presentation"]
        )
    ],
    dependencies: [
        .package(path: "../Domain"),
        .package(url: "https://github.com/codalasolutions/swift-di.git", branch: "main")
    ],
    targets: [
        .target(
            name: "Presentation",
            dependencies: [
                "Domain",
                .product(name: "DI", package: "swift-di")
            ]
        ),
        .testTarget(
            name: "PresentationTests",
            dependencies: ["Presentation"]
        )
    ]
)

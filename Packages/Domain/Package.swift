// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Domain",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "Domain",
            targets: ["Domain"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/codalasolutions/swift-di.git", branch: "main")
    ],
    targets: [
        .target(
            name: "Domain",
            dependencies: [.product(name: "DI", package: "swift-di")]
        ),
        .testTarget(
            name: "DomainTests",
            dependencies: ["Domain"]
        )
    ]
)

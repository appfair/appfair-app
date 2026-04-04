// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "appfair-app",
    defaultLocalization: "en",
    platforms: [.iOS(.v17), .macOS(.v14), .tvOS(.v16), .watchOS(.v9), .macCatalyst(.v16)],
    products: [
        .library(name: "AppFairUI", type: .dynamic, targets: ["AppFairUI"]),
    ],
    dependencies: [
        .package(url: "https://source.skip.tools/skip.git", from: "1.2.23"),
        .package(url: "https://source.skip.tools/skip-kit.git", from: "1.0.0"),
    ],
    targets: [
        .target(name: "AppFairUI", dependencies: [
            .product(name: "SkipKit", package: "skip-kit"),
        ], resources: [.process("Resources")], plugins: [.plugin(name: "skipstone", package: "skip")]),
        .testTarget(name: "AppFairUITests", dependencies: [
            "AppFairUI",
            .product(name: "SkipTest", package: "skip")
        ], resources: [.process("Resources")], plugins: [.plugin(name: "skipstone", package: "skip")]),
    ]
)

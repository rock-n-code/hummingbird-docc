// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: HummingbirdDocC.package,
    platforms: [
        .iOS(.v17),
        .macCatalyst(.v17),
        .macOS(.v14),
        .tvOS(.v17),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: HummingbirdDocC.package,
            targets: [HummingbirdDocC.target]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.4.0"),
        .package(url: "https://github.com/hummingbird-project/hummingbird.git", from: "2.0.0"),
        .package(url: "https://github.com/swiftlang/swift-docc-plugin", from: "1.1.0"),
    ],
    targets: [
        .executableTarget(
            name: HummingbirdDocC.sample,
            dependencies: [
                .byName(name: HummingbirdDocC.target),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ],
            path: "Samples/HummingbirdDocC",
            swiftSettings: [
                // Enable better optimizations when building in Release configuration. Despite the use of
                // the `.unsafeFlags` construct required by SwiftPM, this flag is recommended for Release
                // builds. See <https://github.com/swift-server/guides#building-for-production> for details.
                .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release)),
            ]
        ),
        .target(
            name: HummingbirdDocC.target,
            dependencies: [
                .product(name: "Hummingbird", package: "hummingbird"),
            ],
            path: "Sources/HummingbirdDocC",
            swiftSettings: [.enableExperimentalFeature("StrictConcurrency=complete")]
        ),
        .testTarget(
            name: HummingbirdDocC.test,
            dependencies: [
                .product(name: "HummingbirdTesting", package: "hummingbird"),
                .byName(name: HummingbirdDocC.target)
            ],
            path: "Tests/HummingbirdDocC"
        ),
    ]
)

// MARK: - Constants

enum HummingbirdDocC {
    static let package = "hummingbird-docc"
    static let sample = "\(HummingbirdDocC.target)Sample"
    static let target = "HummingbirdDocC"
    static let test = "\(HummingbirdDocC.target)Test"
}

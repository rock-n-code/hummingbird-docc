// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: DocCMiddleware.package,
    platforms: [
        .iOS(.v17),
        .macCatalyst(.v17),
        .macOS(.v14),
        .tvOS(.v17),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: DocCMiddleware.package,
            targets: [DocCMiddleware.target]
        ),
    ],
    targets: [
        .target(
            name: DocCMiddleware.target,
            path: "Sources/DocCMiddleware",
            swiftSettings: [.enableExperimentalFeature("StrictConcurrency=complete")]
        ),
        .testTarget(
            name: DocCMiddleware.test,
            dependencies: [
                .byName(name: DocCMiddleware.target)
            ],
            path: "Tests/DocCMiddleware"
        ),
    ]
)

// MARK: - Constants

enum DocCMiddleware {
    static let package = "hummingbird-docc-middleware"
    static let target = "DocCMiddleware"
    static let test = "\(DocCMiddleware.target)Tests"
}

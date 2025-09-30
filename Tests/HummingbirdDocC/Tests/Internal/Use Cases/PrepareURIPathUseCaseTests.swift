// ===----------------------------------------------------------------------===
//
// This source file is part of the Hummingbird DocC Middleware open source project
//
// Copyright (c) 2025 Röck+Cöde VoF. and the Hummingbird DocC Middleware project authors
// Licensed under the EUPL 1.2 or later.
//
// See LICENSE for license information
// See CONTRIBUTORS for the list of Hummingbird DocC Middleware project authors
//
// ===----------------------------------------------------------------------===

import Testing

import struct HummingbirdDocC.Resource

@testable import struct HummingbirdDocC.PrepareURIPathUseCase

@Suite("Prepare URI Path Use Case", .tags(.useCase))
struct PrepareURIPathUseCaseTests {
    
    // MARK: Use case tests

#if swift(>=6.2)
    @Test(arguments: zip(
        Input.prepareURIPaths,
        Output.prepareURIPaths
    ))
    func `extract data with URI root not suffixed with forward slash`(
        uri uriPath: String,
        expects result: Resource?
    ) throws {
        try assertData(
            uriRoot: .uriRoot,
            uriPath: uriPath,
            expects: result
        )
    }
    
    @Test(arguments: zip(
        Input.prepareURIPathsSlashed,
        Output.prepareURIPaths
    ))
    func `extract data with URI root suffixed with forward slash`(
        uri uriPath: String,
        expects result: Resource?
    ) throws {
        try assertData(
            uriRoot: .uriRootSlashed,
            uriPath: uriPath,
            expects: result
        )
    }
#else
    @Test("extract data with URI root not suffixed with forward slash", arguments: zip(
        Input.prepareURIPaths,
        Output.prepareURIPaths
    ))
    func data_withURIRoot_notSuffixed_withForwardSlash(
        uri uriPath: String,
        expects result: Resource?
    ) throws {
        try assertData(
            uriRoot: .uriRoot,
            uriPath: uriPath,
            expects: result
        )
    }
    
    @Test("extract data with URI root suffixed with forward slash", arguments: zip(
        Input.prepareURIPathsSlashed,
        Output.prepareURIPaths
    ))
    func data_withURIRoot_suffixed_withForwardSlash(
        uri uriPath: String,
        expects result: Resource?
    ) throws {
        try assertData(
            uriRoot: .uriRootSlashed,
            uriPath: uriPath,
            expects: result
        )
    }
#endif

}

// MARK: - Assertions

private extension PrepareURIPathUseCaseTests {
    
    // MARK: Functions
    
    /// Asserts the data returned by the ``PrepareURIPathUseCase`` use case based on the given `uriRoot` and `uriPath` URI paths plus
    /// an expected result.
    /// - Parameters:
    ///   - uriRoot: A URI path to initialize the use case with.
    ///   - uriPath: A URI path to use with the use case.
    ///   - resource: An expected resource coming out of the use case, if any.
    func assertData(
        uriRoot: String,
        uriPath: String,
        expects resource: Resource?
    ) throws {
        // GIVEN
        let useCase = PrepareURIPathUseCase(uriRoot: uriRoot)

        // WHEN
        let result = useCase(uriPath)

        // THEN
        #expect(result == resource)
    }
    
}

// MARK: - Constants

private extension Input {
    /// A list of URI paths to match against the root URI path not suffixed with a forward slash.
    static let prepareURIPaths: [String] = [.uriRoot, .uriOffset, .uriOther]
    /// A list of URI paths to match against the root URI path suffixed with a forward slash.
    static let prepareURIPathsSlashed: [String] = [.uriRootSlashed, .uriOffsetSlashed, .uriOther]
}

private extension Output {
    /// A list of expected outputs for the URI path samples, regardless their match against suffixed or not suffixed root URI paths.
    static let prepareURIPaths: [Resource?] = [
        .init(archiveName: .empty, relativePath: .Path.forwardSlash),
        .init(archiveName: "SomeArchive", relativePath: "/some/content/path"),
        nil
    ]
}

private extension String {
    /// A root URI path to initialize the use case with.
    static let uriRoot = "/some/path"
    /// A root URI path suffixed with a forward slash to initialize the use case with.
    static let uriRootSlashed = "/some/path/"
    /// A URI path prefixed with a root URI path not suffixed with a forward slash.
    static let uriOffset = .uriRoot + "/SomeArchive/some/content/path"
    /// A URI path prefixed with a root URI path suffixed with a forward slash.
    static let uriOffsetSlashed = .uriRootSlashed + "SomeArchive/some/content/path"
    /// A URI path not related to any root URI path.
    static let uriOther = "/some/other/path"
}

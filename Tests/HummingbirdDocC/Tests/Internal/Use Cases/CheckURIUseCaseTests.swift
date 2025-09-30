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

import struct HummingbirdCore.URI

@testable import struct HummingbirdDocC.CheckURIUseCase

@Suite("Check URI use case", .tags(.useCase))
struct CheckURIUseCaseTests {

    // MARK: Use case tests

    #if swift(>=6.2)
        @Test(
            arguments: zip(
                Input.nonEncodedURIs,
                Output.nonEncodedURIs
            )
        )
        func `check non encoded URIs`(
            uri uriPath: String,
            expects result: String?
        ) {
            assertURI(uriPath, expects: result)
        }

        @Test(
            arguments: zip(
                Input.percentEncodedURIs,
                Output.percentEncodedURIs
            )
        )
        func `check percent-encoded URIs`(
            uri uriPath: String,
            expects result: String?
        ) {
            assertURI(uriPath, expects: result)
        }
    #else
        @Test(
            "check non-encoded URIs",
            arguments: zip(
                Input.nonEncodedURIs,
                Output.nonEncodedURIs
            )
        )
        func check_nonEncodedURIs(
            uri uriPath: String,
            expects result: String?
        ) {
            assertURI(uriPath, expects: result)
        }

        @Test(
            "check percent-encoded URIs",
            arguments: zip(
                Input.percentEncodedURIs,
                Output.percentEncodedURIs
            )
        )
        func check_percentEncodedURIs(
            uri uriPath: String,
            expects result: String?
        ) {
            assertURI(uriPath, expects: result)
        }
    #endif

}

// MARK: - Assertions

extension CheckURIUseCaseTests {

    // MARK: Functions

    /// Asserts a URI path provided by the ``CheckURIPathUseCase`` use case based on a given path and an expected result.
    /// - Parameters:
    ///   - uriPath: A URI path to use with a URI type.
    ///   - uriRoot: A URI path that prefixes the `DocC` documentation resources.
    ///   - result: An expected result coming out of the use case.
    fileprivate func assertURI(
        _ uriPath: String,
        uriRoot: String = .Sample.uriRoot,
        expects result: String?
    ) {
        // GIVEN
        let useCase = CheckURIUseCase(uriRoot: uriRoot)
        let uri = URI(uriPath)

        // WHEN
        let output = useCase(uri)

        // THEN
        #expect(output == result)
    }

}

// MARK: - Constants

extension Input {
    /// A list of non-encoded URI samples.
    fileprivate static let nonEncodedURIs: [String] = [
        .Sample.uriRoot + .empty,
        .Sample.uriRoot + .Path.forwardSlash,
        .Sample.uriRoot + "/some/known/path",
        .Sample.uriRoot + "/some/../path",
        "some/other/root/some/known/path",
    ]
    /// A list of percent-encoded URI samples.
    fileprivate static let percentEncodedURIs: [String] = [
        .Sample.uriRoot + "%2F",
        .Sample.uriRoot + "/some%2Fknown%3Fpath",
        .Sample.uriRoot + "/some/%2E%2E/path",
        "some/other%2Froot/some%2Fknown%3Fpath",
    ]
}

extension Output {
    /// A list of expected outputs for the non-encoded URI samples.
    fileprivate static let nonEncodedURIs: [String?] = [
        .Sample.uriRoot,
        .Sample.uriRoot + .Path.forwardSlash,
        .Sample.uriRoot + "/some/known/path",
        nil,
        nil,
    ]
    /// A list of expected outputs for the percent-encoded URI samples.
    fileprivate static let percentEncodedURIs: [String?] = [
        .Sample.uriRoot + .Path.forwardSlash,
        .Sample.uriRoot + "/some/known?path",
        nil,
        nil,
    ]
}

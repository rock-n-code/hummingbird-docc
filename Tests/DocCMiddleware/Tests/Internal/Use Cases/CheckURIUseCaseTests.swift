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

@testable import struct DocCMiddleware.CheckURIUseCase

@Suite("Check URI use case", .tags(.useCase))
struct CheckURIUseCaseTests {
    
    // MARK: Properties
    
    private let useCase: CheckURIUseCase = .init()
    
    // MARK: Use case tests

#if swift(>=6.2)
    @Test(arguments: zip(
        Input.nonEncodedURIs,
        Output.nonEncodedURIs
    ))
    func `check non encoded URIs`(
        uri uriPath: String,
        expects result: String?
    ) {
        assertURI(uriPath, expects: result)
    }
    
    @Test(arguments: zip(
        Input.percentEncodedURIs,
        Output.percentEncodedURIs
    ))
    func `check percent-encoded URIs`(
        uri uriPath: String,
        expects result: String?
    ) {
        assertURI(uriPath, expects: result)
    }
#else
    @Test("check non-encoded URIs", arguments: zip(
        Input.nonEncodedURIs,
        Output.nonEncodedURIs
    ))
    func check_nonEncodedURIs(
        uri uriPath: String,
        expects result: String?
    ) {
        assertURI(uriPath, expects: result)
    }
    
    @Test("check percent-encoded URIs", arguments: zip(
        Input.percentEncodedURIs,
        Output.percentEncodedURIs
    ))
    func check_percentEncodedURIs(
        uri uriPath: String,
        expects result: String?
    ) {
        assertURI(uriPath, expects: result)
    }
#endif

}

// MARK: - Assertions

private extension CheckURIUseCaseTests {
    
    // MARK: Functions
    
    /// Asserts a URI path provided by the ``CheckURIPathUseCase`` use case based on a given path and an expected result.
    /// - Parameters:
    ///   - uriPath: A URI path to use with a URI type.
    ///   - result: An expected result coming out of the use case.
    func assertURI(
        _ uriPath: String,
        expects result: String?
    ) {
        // GIVEN
        let uri = URI(uriPath)
        
        // WHEN
        let output = useCase(uri)
        
        // THEN
        #expect(output == result)
    }
    
}

// MARK: - Constants

private extension Input {
    /// A list of non-encoded URI samples.
    static let nonEncodedURIs: [String] = ["/", "/some/known/path", "", "/some/../path", "some/other/path"]
    /// A list of percent-encoded URI samples.
    static let percentEncodedURIs: [String] = ["%2F", "/some%2Fknown%3Fpath", "%20", "/some/%2E%2E/path", "some%2Fother%3Fpath"]
}

private extension Output {
    /// A list of expected outputs for the non-encoded URI samples.
    static let nonEncodedURIs: [String?] = ["/", "/some/known/path", "/", nil, nil]
    /// A list of expected outputs for the percent-encoded URI samples.
    static let percentEncodedURIs: [String?] = ["/", "/some/known?path", nil, nil, nil]
}

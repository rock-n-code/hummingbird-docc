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

import struct Hummingbird.HTTPRequest
import struct Hummingbird.HTTPResponse
import struct Hummingbird.Request
import struct Logging.Logger

@testable import HummingbirdDocC

@Suite("Logger Metadata Helpers", .tags(.extension))
struct LoggerMetadata_HelpersTests {
    
    // MARK: Functions tests

#if swift(>=6.2)
    @Test
    func `metadata with HTTP method and status code`() throws {
        assertMetadata(
            method: try randomMethod,
            statusCode: try randomStatusCode
        )
    }
    
    @Test
    func `metadata with HTTP method, status code and redirection URI path`() throws {
        assertMetadata(
            method: try randomMethod,
            statusCode: try randomStatusCode,
            redirect: .Sample.uriRedirection
        )
    }
#else
    @Test("metadata with HTTP method and status code")
    func metadata_withMethod_andStatusCode() throws {
        assertMetadata(
            method: try randomMethod,
            statusCode: try randomStatusCode
        )
    }
    
    @Test("metadata with HTTP method, status code and redirection URI path")
    func metadata_withMethod_statusCode_andRedirection() throws {
        assertMetadata(
            method: try randomMethod,
            statusCode: try randomStatusCode,
            redirect: .uriRedirection
        )
    }
#endif

}

// MARK: - Assertions

private extension LoggerMetadata_HelpersTests {
    
    // MARK: Functions
    
    /// Asserts the generated metadata dictionary based on provided parameters.
    /// - Parameters:
    ///   - method: A HTTP method of the request.
    ///   - statusCode: A status code of the response.
    ///   - redirect: A redirection URI path, if any.
    func assertMetadata(
        method: HTTPRequest.Method,
        statusCode: HTTPResponse.Status,
        redirect: String? = nil
    ) {
        // GIVEN
        let logger: Logger = .test()
        let context: RequestContextMock = .init(logger: logger)
        let request: Request = .test(method: method)
        
        // WHEN
        let metadata: Logger.Metadata = .metadata(
            context: context,
            request: request,
            statusCode: statusCode,
            redirect: redirect
        )
        
        // THEN
        #expect(metadata.keys.count == (redirect == nil ? 4 : 5))
        #expect(metadata["hb.request.id"] == logger[metadataKey: "hb.request.id"])
        #expect(metadata["hb.request.method"] == "\(method.rawValue)")
        #expect(metadata["hb.request.path"] == "/")
        #expect(metadata["hb.request.status"] == "\(statusCode.code)")
        
        if let redirect {
            #expect(metadata["hb.request.redirect"] == "\(redirect)")
        }
    }
    
}

// MARK: - Helpers

private extension LoggerMetadata_HelpersTests {
    
    // MARK: Computed
    
    /// Extracts a random HTTP method of the request from a list of pre-defined values.
    var randomMethod: HTTPRequest.Method {
        get throws {
            try #require([.connect, .delete, .get, .head, .options, .patch, .post, .put, .trace].randomElement())
        }
    }
    
    /// Extracts a random status code of the response from a list of pre-defined values.
    var randomStatusCode: HTTPResponse.Status {
        get throws {
            try #require([.`continue`, .earlyHints, .ok, .accepted, .multipleChoices, .seeOther, .badRequest, .notFound, .internalServerError, .serviceUnavailable].randomElement())
        }
    }
    
}

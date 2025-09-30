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

@testable import struct HummingbirdDocC.Resource

@Suite("Resource", .tags(.model))
struct ResourceTests {
    
    // MARK: Properties tests
    
#if swift(>=6.2)
    @Test
    func `archive path`() {
        assertArchivePath(
            archiveName: "SomeDocument",
            expects: "/SomeDocument.doccarchive"
        )
    }
    
    @Test
    func `archive reference`() {
        assertArchiveReference(
            archiveName: "SomeDocument",
            expects: "somedocument"
        )
    }
#else
    @Test("archive path")
    func archivePath() {
        assertArchivePath(
            archiveName: "SomeDocument",
            expects: "/SomeDocument.doccarchive"
        )
    }
    
    @Test("archive reference")
    func archiveReference() {
        assertArchiveReference(
            archiveName: "SomeDocument",
            expects: "somedocument"
        )
    }
#endif
    
}

// MARK: - Assertions

private extension ResourceTests {
    
    // MARK: Functions
    
    /// Asserts the `archivePath` computed property of a resource.
    /// - Parameters:
    ///   - archiveName: A name of the archive the resource belongs to.
    ///   - archivePath: An expected path to a documentation archive related to a given archive name.
    func assertArchivePath(
        archiveName: String,
        expects archivePath: String
    ) {
        // GIVEN
        var resource = Resource(
            archiveName: archiveName,
            relativePath: .empty
        )

        // WHEN
        let result = resource.archivePath

        // THEN
        #expect(result == archivePath)
    }

    /// Asserts the `archiveReference` computed property of a resource.
    /// - Parameters:
    ///   - archiveName: A name of the archive the resource belongs to.
    ///   - archiveReference: An expected reference related to a given archive name.
    func assertArchiveReference(
        archiveName: String,
        expects archiveReference: String
    ) {
        // GIVEN
        var resource = Resource(
            archiveName: archiveName,
            relativePath: .empty
        )
        
        // WHEN
        let result = resource.archiveReference
        
        // THEN
        #expect(result == archiveReference)
    }
    
}

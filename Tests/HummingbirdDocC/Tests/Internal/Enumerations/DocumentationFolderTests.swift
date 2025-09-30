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

@testable import enum HummingbirdDocC.DocumentationFolder

@Suite("Documentation Type", .tags(.enumeration))
struct DocumentationTypeTests {
    
    // MARK: Properties tests
    
#if swift(>=6.2)
    @Test(arguments: zip(
        DocumentationFolder.allCases,
        Output.documentationFolderPaths
    ))
    func `path`(
        `case`: DocumentationFolder,
        expects result: String
    ) {
        assertPath(`case`, expects: result)
    }
#else
    @Test("path", arguments: zip(
        DocumentationType.allCases,
        Output.documentationTypePaths
    ))
    func path(
        `case`: DocumentationType,
        expects result: String
    ) {
        assertPath(`case`, expects: result)
    }
#endif
    
}

// MARK: - Assertions

private extension DocumentationTypeTests {
    
    // MARK: Functions
    
    /// Asserts the path property based on a given ``DocumentationFolder`` enumeration case and an expected result.
    /// - Parameters:
    ///   - case: A representation of the ``DocumentationFolder`` enumeration
    ///   - result: An expected result coming out of the property.
    func assertPath(
        _ case: DocumentationFolder,
        expects result: String
    ) {
        // GIVEN
        // WHEN
        let output = `case`.path

        // THEN
        #expect(output == result)
    }
    
}

// MARK: - Constants

private extension Output {
    /// A list of expected outputs for the paths of the ``DocumentationFolder`` enumeration cases.
    static let documentationFolderPaths: [String] = ["/documentation", "/tutorials"]
}

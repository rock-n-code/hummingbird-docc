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

@testable import enum DocCMiddleware.AssetFolder

@Suite("Asset Folder", .tags(.enumeration))
struct AssetFolderTests {
    
    // MARK: Properties tests

#if swift(>=6.2)
    @Test(arguments: zip(
        AssetFolder.allCases,
        Output.assetFolderPaths
    ))
    func `path`(
        `case`: AssetFolder,
        expects result: String
    ) {
        assertPath(`case`, expects: result)
    }
#else
    @Test("path", arguments: zip(
        AssetFolder.allCases,
        Output.assetFolderPaths
    ))
    func path(
        `case`: AssetFolder,
        expects result: String
    ) {
        assertPath(`case`, expects: result)
    }
#endif

}

// MARK: - Assertions

private extension AssetFolderTests {
    
    // MARK: Functions
    
    /// Asserts the path property based on a given ``AssetFolder`` enumeration case and an expected result.
    /// - Parameters:
    ///   - case: A representation of the ``AssetFolder`` enumeration
    ///   - result: An expected result coming out of the property.
    func assertPath(
        _ case: AssetFolder,
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
    /// A list of expected outputs for the paths of the ``AssetFolder`` enumeration cases.
    static let assetFolderPaths: [String] = ["/css/", "/data/", "/downloads/", "/images/", "/img/", "/index/", "/js/", "/videos/"]
}

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

@testable import enum HummingbirdDocC.AssetFile

@Suite("Asset File", .tags(.enumeration))
struct AssetFileTests {

    // MARK: Properties tests

#if swift(>=6.2)
    @Test(arguments: zip(
        AssetFile.allCases,
        Output.assetFilePaths
    ))
    func `path`(
        `case`: AssetFile,
        expects result: String
    ) {
        assertPath(`case`, expects: result)
    }
#else
    @Test("path", arguments: zip(
        AssetFile.allCases,
        Output.assetFilePaths
    ))
    func path(
        `case`: AssetFile,
        expects result: String
    ) {
        assertPath(`case`, expects: result)
    }
#endif

}

// MARK: - Assertions

private extension AssetFileTests {
    
    // MARK: Functions
    
    /// Asserts the path property based on a given ``AssetFile`` enumeration case and an expected result.
    /// - Parameters:
    ///   - case: A representation of the ``AssetFile`` enumeration
    ///   - result: An expected result coming out of the property.
    func assertPath(
        _ case: AssetFile,
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
    /// A list of expected outputs for the paths of the ``AssetFile`` enumeration cases.
    static let assetFilePaths: [String] = ["/data/documentation.json", "/favicon.ico", "/favicon.svg", "/theme-settings.json"]
}

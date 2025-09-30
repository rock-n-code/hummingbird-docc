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

@testable import HummingbirdDocC

@Suite("String Helpers", .tags(.extension))
struct String_HelpersTests {
    
    // MARK: Functions tests
    
#if swift(>=6.2)
    @Test(arguments: zip(
        Input.prefixesToSubtract,
        Output.prefixesToSubtract
    ))
    func `subtract`(
        prefix: String,
        expects newString: String?
    ) {
        assertSubtract(
            string: .sample,
            prefix: prefix,
            expects: newString
        )
    }
#else
    @Test("subtract", arguments: zip(
        Input.prefixesToSubtract,
        Output.prefixesToSubtract
    ))
    func subtract(
        prefix: String,
        expects newString: String?
    ) {
        assertSubtract(
            string: .sample,
            prefix: prefix,
            expects: newString
        )
    }
#endif
    
}

// MARK: - Assertions

private extension String_HelpersTests {
    
    // MARK: Functions
    
    /// Asserts a string subtraction.
    /// - Parameters:
    ///   - string: A string from where the subtraction will occur.
    ///   - prefix: A prefix to subtract from a string.
    ///   - newString: An expected new string created out of the subtraction, if any.
    func assertSubtract(
        string: String,
        prefix: String,
        expects newString: String?
    ) {
        // GIVEN
        // WHEN
        let result = string.subtract(prefix)
        
        // THEN
        #expect(result == newString)
    }
    
}

// MARK: - Constants

private extension Input {
    /// A list of prefix strings.
    static let prefixesToSubtract: [String] = ["Some", .sample, "some", "Else"]
}

private extension Output {
    /// A list of outcomes that are expected from subtracting the prefix substrings out of the sample string.
    static let prefixesToSubtract: [String?] = ["thing", .empty, nil, nil]
}

private extension String {
    /// A sample string.
    static let sample = "Something"
}

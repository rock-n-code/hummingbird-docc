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

import RegexBuilder

extension String {
    
    /// Subtracts a prefix from a string.
    /// - Parameters:
    ///   - prefix: A prefix to remove from a string.
    /// - Returns: A new string with a prefix removed, if any.
    func subtract(
        _ prefix: String
    ) -> String? {
        let reference = Reference(String.self)
        let pattern = Regex {
            prefix
            Optionally {
                Capture(as: reference) {
                    OneOrMore(.anyNonNewline)
                } transform: { output in
                    String(output)
                }
            }
        }
        
        guard let matches = self.prefixMatch(of: pattern) else {
            return nil
        }
        guard let subtracted = matches.output.1 else {
            return .empty
        }

        return subtracted
    }
    
}

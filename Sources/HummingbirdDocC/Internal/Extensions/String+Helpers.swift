// ===----------------------------------------------------------------------===
// 
// This source file is part of the Hummingbird DocC open source project
// 
// Copyright (c) 2025 Röck+Cöde VoF. and the Hummingbird DocC project authors
// Licensed under Apache license v2.0
// 
// See LICENSE for license information
// See CONTRIBUTORS for the list of Hummingbird DocC project authors
//
// SPDX-License-Identifier: Apache-2.0
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

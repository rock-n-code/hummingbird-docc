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

import struct Hummingbird.HTTPRequest
import struct Hummingbird.Request
import struct Hummingbird.RequestBody

extension Request {
    
    // MARK: Functions
    
    /// Generates a request that is ready to use in test case.
    /// - Parameters:
    ///   - method: A HTTP method.
    ///   - path: A URI path, if any.
    /// - Returns: A generated request instance to use in test cases.
    static func test(
        method: HTTPRequest.Method,
        path: String? = nil
    ) -> Self {
        .init(
            head: .init(
                method: method,
                scheme: nil,
                authority: nil,
                path: path
            ),
            body: .init(buffer: .init())
        )
    }
    
}

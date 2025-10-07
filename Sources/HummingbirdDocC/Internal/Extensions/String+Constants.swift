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

extension String {
    /// An empty string.
    static let empty = ""
    
    /// A namespace that defines logging values.
    enum Logging {
        /// A name of the middleware that triggered a logging event.
        static let source = "DocCMiddleware"
    }
    
    /// A namespace that defines relative path values.
    enum Path {
        /// A forwarding slash.
        static let forwardSlash = "/"
        /// An indication of a previous folder in a path component.
        static let previousFolder = ".."
    }
}

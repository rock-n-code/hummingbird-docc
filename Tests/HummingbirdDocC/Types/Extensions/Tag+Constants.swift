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

extension Tag {
    
    // MARK: Constants
    
    /// Tag that indicate a test case for an enumeration type.
    @Tag static var enumeration: Self
    /// Tag that indicate a test case for an extended type.
    @Tag static var `extension`: Self
    /// Tag that indicate a test case for a middleware type.
    @Tag static var middleware: Self
    /// Tag that indicate a test case for a model type.
    @Tag static var model: Self
    /// Tag that indicate a test case for a use case type.
    @Tag static var useCase: Self
    
}

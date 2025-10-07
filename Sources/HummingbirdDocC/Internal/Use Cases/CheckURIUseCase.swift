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

import struct HummingbirdCore.URI

/// A use case that checks whether a given URI against a set of conditions, to determine whether the URI could be used by the middleware or not.
struct CheckURIUseCase {
    
    // MARK: Properties
    
    /// A root path that prefixes the documentation resource.
    private let uriRoot: String
    
    // MARK: Initializers
    
    /// Initializes this use case.
    ///
    /// > important: It is assumed that the `uriRoot` parameter is not empty and that it is prefixed by the `/` character.
    ///
    /// - Parameter uriRoot: A root path that prefixes the documentation resource.
    init(uriRoot: String) {
        self.uriRoot = uriRoot
    }

    // MARK: Functions
    
    /// Checks whether a provided URI against a set of conditions, so it could be used by the middleware.
    /// - Parameter uri: A URI to check.
    /// - Returns: A non-encoded URI, which is ready to be used by the middleware.
    func callAsFunction(_ uri: URI) -> String? {
        guard
            let uriPath = uri.path.removingPercentEncoding,
            uriPath.hasPrefix(uriRoot),
            !uriPath.contains(.Path.previousFolder)
        else {
            return nil
        }
        
        return uriPath
    }
    
}

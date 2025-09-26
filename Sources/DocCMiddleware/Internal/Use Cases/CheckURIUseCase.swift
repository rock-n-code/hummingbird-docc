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

import struct HummingbirdCore.URI

/// A use case that checks whether a given URI against a set of conditions, to determine whether the URI could be used by the middleware or not.
struct CheckURIUseCase {

    // MARK: Functions
    
    /// Checks whether a provided URI against a set of conditions, so it could be used by the middleware.
    /// - Parameter uri: A URI to check.
    /// - Returns: A non-encoded URI, which is ready to be used by the middleware.
    func callAsFunction(_ uri: URI) -> String? {
        guard
            let uriPath = uri.path.removingPercentEncoding,
            !uriPath.contains(.Path.previousFolder),
            uriPath.hasPrefix(.Path.forwardSlash)
        else {
            return nil
        }
        
        return uriPath
    }
    
}

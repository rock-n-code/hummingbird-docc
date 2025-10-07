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

import class NIOPosix.NIOThreadPool

/// A type that contains all the parameters to configure the ``DocCMiddleware`` middleware.
public struct DocCConfiguration: Sendable {
    
    // MARK: Properties
    
    /// A path to the physical location where the `DocC` documentation containers are stored.
    let folderRoot: String
    
    /// A URI path that prefixes the `DocC` documentation resources.
    let uriRoot: String
    
    /// A type that define a mechanism to use in case some blocking work needs to be performed for which no non-blocking API exists.
    let threadPool: NIOThreadPool
    
    // MARK: Initializers
    
    /// Initializes this configuration type.
    ///
    /// > important: It is assumed that both the `uriRoot` and the `folderRoot` parameters should not be empty, and that they should be prefixed
    /// with the `/` forward slash character.
    ///
    /// - Parameters:
    ///   - uriRoot: A URI path that prefixes the `DocC` documentation resources.
    ///   - folderRoot: A path to the physical location where the `DocC` documentation containers are stored.
    ///   - threadPool: A type that define a mechanism to use in case some blocking work needs to be performed for which no non-blocking API exists.
    public init(
        uriRoot: String,
        folderRoot: String,
        threadPool: NIOThreadPool = .singleton
    ) {
        self.folderRoot = folderRoot
        self.uriRoot = uriRoot
        self.threadPool = threadPool
    }
    
}

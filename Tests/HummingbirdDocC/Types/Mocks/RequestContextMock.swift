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

import class NIOEmbedded.NIOAsyncTestingChannel

import protocol Hummingbird.RequestContext

import struct Hummingbird.ApplicationRequestContextSource
import struct Hummingbird.CoreRequestContextStorage
import struct Logging.Logger

/// A mock that conforms to the `RequestContext` protocol.
struct RequestContextMock {

    // MARK: Properties
    
    var coreContext: CoreRequestContextStorage
    
    // MARK: Initializers
    
    /// Initializes this mock.
    /// - Parameter logger: A type that interacts with the logging system.
    init(logger: Logger) {
        self.coreContext = .init(source: ApplicationRequestContextSource(
            channel: NIOAsyncTestingChannel(),
            logger: logger
        ))
    }
    
}

// MARK: - RequestContext

extension RequestContextMock: RequestContext {
    
    // MARK: Initializers
    
    init(source: ApplicationRequestContextSource) {
        self.coreContext = .init(source: source)
    }
    
}

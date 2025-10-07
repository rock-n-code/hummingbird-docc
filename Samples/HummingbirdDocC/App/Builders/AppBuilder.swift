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

import class Hummingbird.Router

import protocol Hummingbird.ApplicationProtocol

import struct Hummingbird.Application
import struct Hummingbird.BasicRequestContext
import struct Hummingbird.BindAddress
import struct Hummingbird.LogRequestsMiddleware
import struct HummingbirdDocC.DocCConfiguration
import struct HummingbirdDocC.DocCMiddleware
import struct Logging.Logger

struct AppBuilder {
    
    // MARK: Properties
    
    /// A type that interacts with the logging system.
    private let logger: Logger
    
    // MARK: Initializers
    
    /// Initializes this builder.
    /// - Parameter logger: A type that interacts with the logging system.
    init(logger: Logger) {
        self.logger = logger
    }
    
    // MARK: Functions
    
    func callAsFunction(
        _ arguments: AppArguments
    ) -> some ApplicationProtocol {
        return Application(
            router: router(),
            configuration: .init(
                address: .hostname(
                    arguments.hostname,
                    port: arguments.port
                )
            ),
            logger: logger
        )
    }
    
}

// MARK: - Helpers

private extension AppBuilder {
    
    // MARK: Type aliases
    
    typealias AppRequestContext = BasicRequestContext
    
    // MARK: Functions
    
    func router() -> Router<AppRequestContext> {
        let router = Router()
        
        router.addMiddleware {
            LogRequestsMiddleware(logger.logLevel)
            DocCMiddleware (
                configuration: DocCConfiguration(
                    uriRoot: "/archives",
                    folderRoot: "Samples/HummingbirdDocC/Archives"
                ),
                logger: logger
            )
        }
        
        return router
    }
    
}

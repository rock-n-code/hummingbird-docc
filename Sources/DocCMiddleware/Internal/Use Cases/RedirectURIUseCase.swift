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

import struct Hummingbird.Response
import struct Logging.Logger

/// A use case that produces a redirect response based on a given URI path.
struct RedirectURIUseCase {

    // MARK: Properties
    
    /// A type that interacts with the logging system.
    private let logger: Logger
    
    // MARK: Initializers
    
    /// Initializes this use case.
    /// - Parameter logger: A type that interacts with the logging system.
    init(logger: Logger) {
        self.logger = logger
    }
    
    // MARK: Functions
    
    /// Produces a redirect response based on a given URI path
    /// - Parameters:
    ///   - uriPath: A URI path to use in the redirection.
    ///   - contextualInfo: A pseudo-type that contains data about a request and its related context.
    /// - Returns: A redirection response created out of a given URI path plus contextual information.
    func callAsFunction(
        _ uriPath: String,
        with contextualInfo: ContextualInfo
    ) -> Response {
        defer {
            logger.log(
                level: .debug,
                "The URI path is redirected to this path: \(uriPath)",
                metadata: .metadata(
                    context: contextualInfo.context,
                    request: contextualInfo.request,
                    statusCode: .movedPermanently,
                    redirect: uriPath
                ),
                source: .Logging.source
            )
        }
        
        return .redirect(
            to: uriPath,
            type: .permanent
        )
    }

}

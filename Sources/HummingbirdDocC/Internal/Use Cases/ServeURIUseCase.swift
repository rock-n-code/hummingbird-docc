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

import protocol Hummingbird.FileProvider

import struct Hummingbird.Response
import struct Logging.Logger

/// A use case that serves a resource, defined by its URI path, from a physical location.
struct ServeURIUseCase<Provider: FileProvider> {
    
    // MARK: Properties
    
    /// A type that conforms to a protocol that defines file system interactions.
    private let fileProvider: Provider
    
    /// A type that interacts with the logging system.
    private let logger: Logger
    
    // MARK: Initializers
    
    /// Initializes this use case.
    /// - Parameters:
    ///   - fileProvider: A type that conforms to a protocol that defines file system interactions.
    ///   - logger: A type that interacts with the logging system.
    init(
        fileProvider: Provider,
        logger: Logger
    ) {
        self.fileProvider = fileProvider
        self.logger = logger
    }
    
    // MARK: Functions
    
    /// Serves a certain resource based on a given URI path from a physical location.
    /// - Parameters:
    ///   - uriPath: A URI path that represents a resource to be served.
    ///   - folderPath: A URI path to a physical folder that contains the resource.
    ///   - contextualInfo: A pseudo-type that contains data about a request and its related context.
    /// - Returns: A response that either contains the data of the resource in its body in  case the resource is found, or a not found otherwise.
    /// - Throws: An error in case an issue is encountered while serving the resource.
    func callAsFunction(
        _ uriPath: String,
        at folderPath: String,
        with contextualInfo: ContextualInfo
    ) async throws -> Response {
        let filePath = folderPath + uriPath

        guard let fileIdentifier = fileProvider.getFileIdentifier(filePath) else {
            defer {
                logger.log(
                    level: .error,
                    "The resource \(filePath) has not been found.",
                    metadata: .metadata(
                        context: contextualInfo.context,
                        request: contextualInfo.request,
                        statusCode: .notFound
                    ),
                    source: .Logging.source
                )
            }
            
            return .init(status: .notFound)
        }
        
        let body = try await fileProvider.loadFile(
            id: fileIdentifier,
            context: contextualInfo.context
        )

        defer {
            logger.log(
                level: .debug,
                "The body of the resource \(filePath) has \(body.contentLength ?? 0) bytes.",
                metadata: .metadata(
                    context: contextualInfo.context,
                    request: contextualInfo.request,
                    statusCode: .ok
                ),
                source: .Logging.source
            )
        }
        
        return .init(
            status: .ok,
            body: body
        )
    }
    
}

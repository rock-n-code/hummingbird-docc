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

import protocol Hummingbird.RequestContext

import struct Hummingbird.HTTPResponse
import struct Hummingbird.Request
import struct Logging.Logger

extension Logger.Metadata {
    
    // MARK: Functions
    
    /// Generates a dictionary to use as metadata for events to log into the logging system.
    /// - Parameters:
    ///   - context: A type that contains all the parameters associated with a given request, and that conforms to the `RequestContext` protocol.
    ///   - request: A type that contains all the parameters to process as a request.
    ///   - statusCode: A representation of a response status to provide as a response.
    ///   - redirect: A URI path to use in a redirection event, if any.
    /// - Returns: A generated metadata dictionary for an event to log into the logging system.
    static func metadata(
        context: any RequestContext,
        request: Request,
        statusCode: HTTPResponse.Status,
        redirect: String? = nil
    ) -> Self {
        var metadata: Logger.Metadata = [
            "hb.request.id": "\(context.id)",
            "hb.request.method": "\(request.method.rawValue)",
            "hb.request.path": "\(request.uri.path)",
            "hb.request.status": "\(statusCode.code)"
        ]
        
        if let redirect {
            metadata["hb.request.redirect"] = "\(redirect)"
        }
        
        return metadata
    }
    
}

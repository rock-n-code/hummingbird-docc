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

import Foundation
import Testing

import protocol Logging.LogHandler

import struct Logging.Logger

extension Logger {
    
    // MARK: Functions
    
    /// Generates a logger instance that is ready to use in test cases.
    /// - Parameters:
    ///   - level: A logger level, if any.
    ///   - handler: A custom log handler, if any.
    /// - Returns: A generated logger instance ready to use in test cases.
    static func test(
        level: Logger.Level? = nil,
        handler: (any LogHandler)? = nil
    ) -> Self {
        var logger: Logger = if let handler {
            .init(label: .loggerLabel) { _ in handler }
        } else {
            .init(label: .loggerLabel)
        }

        logger.logLevel = if let level {
            level
        } else {
            try! #require(Logger.Level.allCases.randomElement())
        }

        logger[metadataKey: "hb.request.id"] = "\(UUID().uuidString)"

        return logger
    }
    
}

// MARK: - Constants

private extension String {
    /// A label to assign to a test logger instance.
    static let loggerLabel = "test.hummingbird-docc.logger"
}

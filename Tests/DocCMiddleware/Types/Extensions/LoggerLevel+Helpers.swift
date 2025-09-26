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

import struct Logging.Logger

extension Logger.Level {
    
    // MARK: Functions
    
    /// Extracts a random logging level value out of an inclusive subset of logging levels, arranged by severity.
    /// - Parameter level: A representation of a logging level that defines a subset of values to choose from, if any.
    /// - Returns: A randomized logging value.
    /// - Throws: An error thrown in case an issue is encountered when deciding for a random value.
    static func random(upTo level: Self? = nil) throws -> Self {
        guard let level else {
            return try #require(Self.allCases.randomElement())
        }
        
        let levels: [Self] = switch level {
        case .trace: [.trace]
        case .debug: [.debug, .trace]
        case .info: [.debug, .info, .trace]
        case .notice: [.debug, .info, .notice, .trace]
        case .warning: [.debug, .info, .notice, .trace, .warning]
        case .error: [.debug, .error, .info, .notice, .trace, .warning]
        case .critical: Self.allCases
        }
        
        return try #require(levels.randomElement())
    }
    
    /// /// Extracts a random logging level value out of an exclusive subset of logging levels, arranged by severity.
    /// - Parameter level: A representation of a logging level that defines a subset of values to choose from.
    /// - Returns: A randomized logging value.
    /// - Throws: An error thrown in case an issue is encountered when deciding for a random value.
    static func random(fromExclusive level: Self) throws -> Self {
        let levels: [Self] = switch level {
        case .trace: [.critical, .debug, .error, .info, .notice, .warning]
        case .debug: [.critical, .error, .info, .notice, .warning]
        case .info: [.critical, .error, .notice, .warning]
        case .notice: [.critical, .error, .warning]
        case .warning: [.critical, .error]
        case .error: [.critical]
        case .critical: []
        }
        
        return try #require(levels.randomElement())
    }
    
}

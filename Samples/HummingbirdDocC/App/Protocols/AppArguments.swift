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

import protocol ArgumentParser.ExpressibleByArgument

import struct Logging.Logger

/// A protocol that defines the input arguments the sample executable requires to run.
protocol AppArguments {
    
    // MARK: Properties
    
    /// A label given to the sample app to identify it within a communications channel.
    var hostname: String { get }
    
    /// A port number assigned to the sample app from where the app either sends or receives data.
    var port: Int { get }
    
    /// A log level to configure in a type that interacts with the logging system.
    var logLevel: Logger.Level { get }
    
}

// MARK: - Conformances

/// Extends the `Logger.Level` type so it can be used as an argument.
#if hasFeature(RetroactiveAttribute)
extension Logger.Level: @retroactive ExpressibleByArgument {}
#else
extension Logger.Level: ExpressibleByArgument {}
#endif

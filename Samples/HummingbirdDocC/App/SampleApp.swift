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

import protocol ArgumentParser.AsyncParsableCommand

import struct ArgumentParser.OptionGroup
import struct Logging.Logger

/// A type that implements and runs the sample executable that showcases the `Hummingbird-DocC` middleware.
@main struct SampleApp {
    
    // MARK: Properties
    
    /// A type that contains all the necessary input parameters to run the sample executable.
    @OptionGroup var arguments: Arguments

}

// MARK: - AsyncParsableCommand

extension SampleApp: AsyncParsableCommand {
    
    // MARK: Functions
    
    func run() async throws {
        let builder = AppBuilder(logger: {
            var logger = Logger(label: "sample.hummingbird-docc.logger")
            
            logger.logLevel = arguments.logLevel
            
            return logger
        }())
        
        let application = builder(arguments)

        try await application.run()
    }
    
}

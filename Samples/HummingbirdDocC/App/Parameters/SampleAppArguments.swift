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

import protocol ArgumentParser.ParsableArguments

import struct ArgumentParser.Option
import struct Logging.Logger

extension SampleApp {
    /// A type that conforms to the ``AppArguments`` and the `ParsableArguments` protocols, which contains the input parameters required for the
    /// execution of the sample executable.
    struct Arguments: AppArguments, ParsableArguments {
        
        // MARK: Properties

        @Option(
            name: .shortAndLong,
            help: "A label given to the sample app for the sole purpose of identification within a communications channel."
        )
        var hostname: String = "127.0.0.1"
    
        @Option(
            name: .shortAndLong,
            help: "A port number assigned to the sample app from where the app either sends or receives data."
        )
        var port: Int = 8080
        
        @Option(
            name: .long,
            help: "A log level to configure in a type that interacts with the logging system."
        )
        var logLevel: Logger.Level = .trace
    }
}

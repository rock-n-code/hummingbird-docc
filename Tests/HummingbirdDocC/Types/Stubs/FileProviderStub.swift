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

import Hummingbird

/// A stub that conforms to the `FileProvider` protocol.
struct FileProviderStub {}

// MARK: - FileProvider

extension FileProviderStub: FileProvider {
    
    // MARK: Type aliases
    
    typealias FileAttributes = String
    typealias FileIdentifier = String
    
    // MARK: Functions
    
    func getFileIdentifier(_ path: String) -> String? {
        nil
    }
    
    func getAttributes(id: String) async throws -> String? {
        nil
    }
    
    func loadFile(
        id: String,
        context: some RequestContext
    ) async throws -> ResponseBody {
        .init()
    }
    
    func loadFile(
        id: String,
        range: ClosedRange<Int>,
        context: some RequestContext
    ) async throws -> ResponseBody {
        .init()
    }
    
}


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

import protocol Hummingbird.FileProvider
import protocol Hummingbird.RequestContext

import struct Foundation.Data
import struct Foundation.UUID
import struct Hummingbird.ResponseBody

/// A mock that conforms to the `FileProvider` protocol.
struct FileProviderMock {
    
    // MARK: Properties
    
    /// A type that identifies a sample file.
    private let fileIdentifier: UUID?
    
    /// A flag that indicates whether a file should be loaded or not.
    private let shouldLoadFile: Bool
    
    // MARK: Initializers
    
    /// Initializes this mock.
    /// - Parameters:
    ///   - fileIdentifier: A type that identifies a sample file, if any.
    ///   - shouldLoadFile: A flag that indicates whether a file should be loaded or not.
    init(
        fileIdentifier: UUID? = nil,
        shouldLoadFile: Bool = true
    ) {
        self.fileIdentifier = fileIdentifier
        self.shouldLoadFile = shouldLoadFile
    }
    
}

// MARK: - FileProvider

extension FileProviderMock: FileProvider {

    // MARK: Type aliases

    typealias FileAttributes = String
    typealias FileIdentifier = String
    
    // MARK: Functions

    func getFileIdentifier(_ path: String) -> String? {
        fileIdentifier?.uuidString
    }
    
    func getAttributes(id: String) async throws -> String? {
        nil
    }
    
    func loadFile(
        id: String,
        context: some RequestContext
    ) async throws -> ResponseBody {
        guard shouldLoadFile else {
            throw FileProviderMockError.fileNotLoaded
        }

        guard let content = fileIdentifier?.uuidString else {
            return .init()
        }
        
        return .init(byteBuffer: .init(
            data: .init(content.utf8)
        ))
    }
    
    func loadFile(
        id: String,
        range: ClosedRange<Int>,
        context: some RequestContext
    ) async throws -> ResponseBody {
        try await loadFile(
            id: id,
            context: context
        )
    }
    
}

// MARK: - FileProviderMockError

/// An error type that can only be thrown by the ``FileProviderMock`` mock.
enum FileProviderMockError: Error {
    /// An error encountered while mocking the loading of a file.
    case fileNotLoaded
}

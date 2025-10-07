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

import Foundation
import RegexBuilder

/// A use case that extracts a resource's information from a given URI path, essential for routing the documentation contents.
struct PrepareURIPathUseCase {
    
    // MARK: Properties
    
    /// A root path that prefixes the documentation resource.
    private let uriRoot: String
    
    // MARK: Initializers
    
    /// Initializes this use case.
    ///
    /// > important: It is assumed that the `uriRoot` parameter is not empty and that it is prefixed by the `/` character.
    ///
    /// - Parameter uriRoot: A root path that prefixes the documentation resource.
    init(uriRoot: String) {
        self.uriRoot = uriRoot
    }
    
    // MARK: Functions
    
    /// Extracts resource's information that is essential for documentation contents routing from a given URI path.

    /// > important: It is assumed that the `uriPath` parameter is a URI path that does not contain any percent encoded strings.
    ///
    /// - Parameter uriPath: A URI path to extract the data from.
    /// - Returns: A resource type containing all the relevant information
    func callAsFunction(_ uriPath: String) -> Resource? {
        guard let uriRest = uriRest(from: uriPath) else {
            return nil
        }
        
        let archiveName = archiveName(from: uriRest)

        guard let relativePath = relativePath(from: uriRest, at: archiveName) else {
            return nil
        }

        return .init(
            archiveName: archiveName,
            relativePath: relativePath
        )
    }
    
}

// MARK: - Helpers

private extension PrepareURIPathUseCase {
    
    // MARK: Functions
    
    /// Extracts the archive name from a given URI path.
    ///
    /// > important: It is assumed that a given URI path is a relative URI path is prefixed with the `/` character and that contains the name of a `DocC`
    /// documentation archive in its first component.
    ///
    /// - Parameter uriPath: A relative URI path to extract the archive name from.
    /// - Returns: An archive named extracted from a given URI path.
    func archiveName(from uriPath: String) -> String {
        uriPath
            .split(separator: .Path.forwardSlash)
            .map(String.init)
            .first ?? .empty
    }
    
    /// Extracts the rest of the URI path from a given URI path against a defined URI root path.
    /// - Parameter uriPath: A URI path to get the rest of the URI path from.
    /// - Returns: A rest of the URI path prefixed by the `/`character  in case where there is any offset path after extracting the root path from the given URI path or not. Otherwise, a `nil` value is returned.
    func uriRest(from uriPath: String) -> String? {
        guard let uriRest = uriPath.subtract(uriRoot) else {
            return nil
        }
        guard !uriRest.isEmpty else {
            return uriRest
        }
        guard uriRest.hasPrefix(.Path.forwardSlash) else {
            return .init(format: .Format.Path.root, uriRest)
        }
        
        return uriRest
    }
    
    /// Extracts the relative URI path from a given URI path against the name of a documentation archive.
    /// - Parameters:
    ///   - uriPath: A URI path to get the relative URI path from.
    ///   - archive: An archive name to subtract from a URI path.
    /// - Returns: A relative URI path prefixed by the `/`character  in case where there is any offset path after extracting the root path from the given URI path or not. Otherwise, a `nil` value is returned.
    func relativePath(
        from uriPath: String,
        at archive: String
    ) -> String? {
        guard !archive.isEmpty else {
            return .Path.forwardSlash
        }
        
        let archivePath: String = .init(format: .Format.Path.root, archive)

        guard let relativePath = uriPath.subtract(archivePath) else {
            return nil
        }
        guard relativePath != .empty else {
            return .empty
        }
        
        return relativePath
    }

}

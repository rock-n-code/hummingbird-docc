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
import RegexBuilder

/// A use case that extracts data from a given URI path, essential for routing the documentation contents.
struct PrepareURIPathUseCase {
    
    // MARK: Type aliases
    
    /// A pseudo-type that contains the archive name, reference and URI path, plus the resource URI and relative paths used for routing the documentation contents.
    typealias PreparedURIPaths = (archiveName: String, archiveReference: String, archivePath: String, resourcePath: String)
    
    // MARK: Properties
    
    /// A root path that suffixes the documentation resource.
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
    
    /// Extracts some necessary data essential for documentation contents routing from a given URI path.
    ///
    /// The necessary data to extract from a given URI path is:
    /// 1. the `DocC` documentation archive name;
    /// 2. the `DocC` documentation archive reference;
    /// 3. the `DocC` documentation archive URI path;
    /// 4. the `DocC` documentation resource URI path.
    ///
    /// > important: It is assumed that the `uriPath` parameter is a URI path that does not contain any percent encoded strings.
    ///
    /// - Parameter uriPath: A URI path to extract the data from.
    /// - Returns: A pseudo-type that contains the archive' name, reference and URI path, plus the resource URI paths.
    func callAsFunction(_ uriPath: String) -> PreparedURIPaths? {
        guard let uriRest = restOfURIPath(from: uriPath) else {
            return nil
        }
        
        let archiveName = uriRest
            .split(separator: .Path.forwardSlash)
            .map(String.init)
            .first

        let archiveReference: String = if let archiveName {
            archiveName.lowercased()
        } else {
            .empty
        }
        let archivePath: String = if let archiveName {
            .init(format: .Format.Path.archive, archiveName)
        } else {
            .empty
        }

        return (
            archiveName ?? .empty,
            archiveReference,
            archivePath,
            uriRest
        )
    }
    
}

// MARK: - Helpers

private extension PrepareURIPathUseCase {
    
    // MARK: Functions
    
    /// Extracts the rest of the URI path from a given URI path against a defined URI root path.
    ///
    /// A given URI path is matched against a regular expression, which is generated from a provided URI root path.
    /// So this function would return either a string that represents a partial URI path, or a `nil` instance depending the result of the match between
    /// the URI path and the regular expression:
    /// * A `nil` instance in case there is no match;
    /// * A `/` string in case there is a perfect match;
    /// * A partial URI path prefixed with the `/` character in case there is an offset in the match.
    ///
    /// - Parameter uriPath: A URI path to get the rest of the URI path from.
    /// - Returns: A rest of the URI path prefixed by the `/`character  in case where there is any offset path after extracting the root path from the given URI path or not. Otherwise, a `nil` value is returned.
    func restOfURIPath(from uriPath: String) -> String? {
        let restReference = Reference(String.self)
        let uriPattern = Regex {
            uriRoot
            Optionally {
                Capture(as: restReference) {
                    OneOrMore(.anyNonNewline)
                } transform: { output in
                    String(output)
                }
            }
        }
        
        guard let matches = uriPath.prefixMatch(of: uriPattern) else {
            return nil
        }
        guard let uriRest = matches.output.1 else {
            return .Path.forwardSlash
        }
        guard uriRest.hasPrefix(.Path.forwardSlash) else {
            return .init(format: .Format.Path.root, uriRest)
        }
        return uriRest
    }
    
}

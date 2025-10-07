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

/// A model that encapsulates the information related to a resource in a given `DocC` documentation archive.
struct Resource: Equatable {
    
    // MARK: Properties
    
    /// An archive name in which the resource belongs to.
    let archiveName: String
    
    /// A relative URI path to the resource.
    let relativePath: String
    
    // MARK: Initializers
    
    /// Initializes this resource.
    /// - Parameters:
    ///   - archiveName: An archive name in which the resource belongs to.
    ///   - relativePath: A relative URI path to the resource.
    init(
        archiveName: String,
        relativePath: String
    ) {
        self.archiveName = archiveName
        self.relativePath = relativePath
    }
    
    // MARK: Computed
    
    /// A relative URI path to a documentation archive the resource belongs to.
    var archivePath: String {
        .init(format: .Format.Path.archive, archiveName)
    }
    
    /// A reference name for the documentation archive the resource belongs to.
    var archiveReference: String {
        archiveName.lowercased()
    }
    
}

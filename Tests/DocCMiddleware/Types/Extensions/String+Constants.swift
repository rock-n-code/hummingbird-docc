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

extension String {
    
    // MARK: Constants
    
    /// A namespace that defines sample values.
    enum Sample {
        /// A URI path to use as a documentation root sample.
        static let uriDocument = uriRoot + "/SomeDocument"
        /// A URI path to use as a file sample.
        static let uriFile = uriFolder + uriResource
        /// A URI path to use as a folder sample.
        static let uriFolder = "/some/folder/path"
        /// A URI path to use as a redirection sample.
        static let uriRedirection = "/some/redirect/path"
        /// A URI path to use as a resource sample.
        static let uriResource = "/some/path/to/resource"
        /// A URI path to use as a root sample.
        static let uriRoot = "/some/root/path"
    }
}

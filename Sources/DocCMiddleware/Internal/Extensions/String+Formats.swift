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
    /// A namespace that defines the format patterns used to generate strings.
    enum Format {
        /// A namespace that defines the format patterns used to generate relative path representations.
        enum Path {
            /// A format pattern used to generate relative paths that starts with the `/` string and finishes with the `.doccarchive` string.
            static let archive = "/%@.doccarchive"
            /// A format pattern used to generate relative paths that starts with the `/data` string.
            static let data = "/data/%@"
            /// A format pattern used to generate relative paths that starts with the `/docs` string.
            static let docs = "/docs/%@"
            /// A format pattern used to generate relative paths that finishes with the `/documentation` string.
            static let documentation = "%@documentation"
            /// A format pattern used to generate relative paths for JSON documentation files.
            static let documentationJSON = "/data/documentation/%@.json"
            /// A format pattern used to generate relative paths that starts and finishes with the `/` string.
            static let folder = "/%@/"
            ///A format pattern used to generate relative paths that finishes with the `/` string.
            static let forwardSlash = "%@/"
            /// A format pattern used to generate relative paths for index files.
            static let index = "%@/%@/index.html"
            /// A format pattern used to generate relative paths that starts with the `/` string.
            static let root = "/%@"
        }
    }
}

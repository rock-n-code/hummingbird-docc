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

import protocol Hummingbird.RequestContext

import struct Hummingbird.Request

/// A pseudo-type that contains data about a request and its related context.
typealias ContextualInfo = (request: Request, context: any RequestContext)

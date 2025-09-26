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
import protocol Hummingbird.RouterMiddleware

import struct Hummingbird.LocalFileSystem
import struct Hummingbird.Request
import struct Hummingbird.Response
import struct Logging.Logger

/// A middleware that proxies requests to `DocC` documentation containers within a hosting app.
///
/// This middleware routes the contents of a `DocC` documentation container, defined by its resource URI paths, following these rules:
///
/// 1. *Redirects the URI path `/<ArchiveName>` to the path `/<ArchiveName>/`*;
/// 2. *Redirects the URI path `/<ArchiveName>/` to the path `/<ArchiveName>/documentation`*
/// 3. *Redirects the URI path `/<ArchiveName>/documentation` to the path `/<ArchiveName>/documentation/`*
/// 4. *Redirects the URI path `/<ArchiveName>/tutorials` to the path `/<ArchiveName>/tutorials/`*
/// 5. *Redirects the URI path `/<ArchiveName>/documentation/` to the resource on `/<ArchiveName>.doccarchive/documentation/<ArchiveReference>/index.html`*
/// 6. *Redirects the URI path `/<ArchiveName>/tutorials/` to the resource on `/<ArchiveName>.doccarchive/tutorials/<ArchiveReference>/index.html`*
/// 7. *Redirects the URI path `/<ArchiveName>/data/documentation.json` to the resource on `/<ArchiveName>.doccarchive/data/documentation/<ArchiveReference>.json`*
/// 8. *Redirects the URI path `/<ArchiveName>/favicon.ico` to the resource on `/<ArchiveName>.doccarchive/favicon.ico`*
/// 9. *Redirects the URI path `/<ArchiveName>/favicon.svg` to the resource on `/<ArchiveName>.doccarchive/favicon.svg`*
/// 10. *Redirects the URI path `/<ArchiveName>/theme-settings.json` to the resource on `/<ArchiveName>.doccarchive/theme-settings.json`*
/// 11. *Redirects the URI path `/<ArchiveName>/css/<path/to/file>` to the resource on `/<ArchiveName>.doccarchive/css/<path/to/file>`*
/// 12. *Redirects the URI path `/<ArchiveName>/data/<path/to/file>` to the resource on `/<ArchiveName>.doccarchive/data/<path/to/file>`*
/// 13. *Redirects the URI path `/<ArchiveName>/downloads/<path/to/file>` to the resource on `/<ArchiveName>.doccarchive/downloads/<path/to/file>`*
/// 14. *Redirects the URI path `/<ArchiveName>/images/<path/to/file>` to the resource on `/<ArchiveName>.doccarchive/images/<path/to/file>`*
/// 15. *Redirects the URI path `/<ArchiveName>/img/<path/to/file>` to the resource on `/<ArchiveName>.doccarchive/img/<path/to/file>`*
/// 16. *Redirects the URI path `/<ArchiveName>/index/<path/to/file>` to the resource on `/<ArchiveName>.doccarchive/index/<path/to/file>`*
/// 17. *Redirects the URI path `/<ArchiveName>/js/<path/to/file>` to the resource on `/<ArchiveName>.doccarchive/js/<path/to/file>`*
/// 18. *Redirects the URI path `/<ArchiveName>/videos/<path/to/file>` to the resource on `/<ArchiveName>.doccarchive/videos/<path/to/file>`*
///
public struct DocCMiddleware<FileSystemProvider: FileProvider> {
    
    // MARK: Properties
    
    /// A type that contains the parameters to configure the middleware.
    let configuration: Configuration
    
    /// A type that conforms to a protocol that defines file system interactions.
    let fileProvider: FileSystemProvider
    
    /// A type that interacts with the logging system.
    let logger: Logger
    
    /// A use case that checks whether a received URI could be processed or not.
    private let checkURI: CheckURIUseCase = .init()
    
    /// A use case that extracts data from a given URI path, essential for routing the documentation contents.
    private let prepareURIPath: PrepareURIPathUseCase
    
    /// A use case that produces a redirect response based on a given URI path.
    private let redirectURI: RedirectURIUseCase
    
    /// A use case that serves a resource, defined by its URI path, from a physical location.
    private let serveURI: ServeURIUseCase<FileSystemProvider>
    
    // MARK: Initializers
    
    /// Initializes this middleware.
    /// - Parameters:
    ///   - configuration: A type that contains the parameters to configure the middleware.
    ///   - logger: A type that interacts with the logging system.
    public init(
        configuration: Configuration,
        logger: Logger
    ) where FileSystemProvider == LocalFileSystem {
        self.init(
            configuration: configuration,
            fileProvider: LocalFileSystem(
                rootFolder: configuration.folderRoot,
                threadPool: configuration.threadPool,
                logger: logger
            ),
            logger: logger,
        )
    }
    
    /// Initializes this middleware with a concrete file provider type.
    /// - Parameters:
    ///   - configuration: A type that contains the parameters to configure the middleware.
    ///   - fileProvider: A type that conforms to the protocol that defines file system interactions.
    ///   - logger: A type that interacts with the logging system.
    init(
        configuration: Configuration,
        fileProvider: FileSystemProvider,
        logger: Logger,
    ) {
        self.logger = logger
        self.configuration = configuration
        self.fileProvider = fileProvider
        self.prepareURIPath = .init(uriRoot: configuration.uriRoot)
        self.redirectURI = .init(logger: logger)
        self.serveURI = .init(
            fileProvider: fileProvider,
            logger: logger
        )
    }
    
}

// MARK: - RouterMiddleware

extension DocCMiddleware: RouterMiddleware {
    
    // MARK: Type aliases
    
    public typealias Context = RequestContext
    public typealias Input = Request
    public typealias Output = Response
    
    // MARK: Functions
    
    public func handle(
        _ request: Input,
        context: any Context,
        next: (Input, any Context) async throws -> Output
    ) async throws -> Output {
        guard
            let uriPath = checkURI(request.uri),
            let uriData = prepareURIPath(uriPath)
        else {
            return try await next(request, context)
        }
        
        let rootPaths: [String] = [
            String(format: .Format.Path.root, uriData.archiveName),
            String(format: .Format.Path.folder, uriData.archiveName)
        ]

        if rootPaths.contains(uriData.resourcePath) {
            return redirectURI(
                uriPath.hasSuffix(.Path.forwardSlash)
                    // Rule #2: Redirects the URI path /<ArchiveName>/ to the path /<ArchiveName>/documentation
                    ? String(format: .Format.Path.documentation, uriPath)
                    // Rule #1: Redirects the URI path /<ArchiveName> to the path /<ArchiveName>/
                    : String(format: .Format.Path.forwardSlash, uriPath),
                with: (request, context)
            )
        }

        for assetFile in AssetFile.allCases {
            if uriData.resourcePath.contains(assetFile.path) {
                return try await serveURI(
                    assetFile == .documentation
                        // Rule #7: Redirects the URI path /<ArchiveName>/data/documentation.json to the resource on /<ArchiveName>.doccarchive/data/documentation/<ArchiveReference>.json
                        ? String(format: .Format.Path.documentationJSON, uriData.archiveReference)
                        // Rule #8: Redirects the URI path `/<ArchiveName>/favicon.ico` to the resource on `/<ArchiveName>.doccarchive/favicon.ico`
                        // Rule #9: Redirects the URI path `/<ArchiveName>/favicon.svg` to the resource on `/<ArchiveName>.doccarchive/favicon.svg`
                        // Rule #10: Redirects the URI path `/<ArchiveName>/theme-settings.json` to the resource on `/<ArchiveName>.doccarchive/theme-settings.json`
                        : uriData.resourcePath,
                    at: uriData.archivePath,
                    with: (request, context)
                )
            }
        }
        
        for assetFolder in AssetFolder.allCases {
            if uriData.resourcePath.contains(assetFolder.path) {
                // Rule #11: Redirects the URI path `/<ArchiveName>/css/<path/to/file>` to the resource on `/<ArchiveName>.doccarchive/css/<path/to/file>`
                // Rule #12: Redirects the URI path `/<ArchiveName>/data/<path/to/file>` to the resource on `/<ArchiveName>.doccarchive/data/<path/to/file>`
                // Rule #13: Redirects the URI path `/<ArchiveName>/downloads/<path/to/file>` to the resource on `/<ArchiveName>.doccarchive/downloads/<path/to/file>`
                // Rule #14: Redirects the URI path `/<ArchiveName>/images/<path/to/file>` to the resource on `/<ArchiveName>.doccarchive/images/<path/to/file>`
                // Rule #15: Redirects the URI path `/<ArchiveName>/img/<path/to/file>` to the resource on `/<ArchiveName>.doccarchive/img/<path/to/file>`
                // Rule #16: Redirects the URI path `/<ArchiveName>/index/<path/to/file>` to the resource on `/<ArchiveName>.doccarchive/index/<path/to/file>`
                // Rule #17: Redirects the URI path `/<ArchiveName>/js/<path/to/file>` to the resource on `/<ArchiveName>.doccarchive/js/<path/to/file>`
                // Rule #18: Redirects the URI path `/<ArchiveName>/videos/<path/to/file>` to the resource on `/<ArchiveName>.doccarchive/videos/<path/to/file>`
                return try await serveURI(
                    uriData.resourcePath,
                    at: uriData.archivePath,
                    with: (request, context)
                )
            }
        }
        
        for documentationFolder in DocumentationFolder.allCases {
            if uriData.resourcePath.contains(documentationFolder.path) {
                if uriData.resourcePath.hasSuffix(.Path.forwardSlash) {
                    // Rule #5: Redirects the URI path /<ArchiveName>/documentation/ to the resource on /<ArchiveName>.doccarchive/documentation/<ArchiveReference>/index.html
                    // Rule #6: Redirects the URI path /<ArchiveName>/tutorials/ to the resource on /<ArchiveName>.doccarchive/tutorials/<ArchiveReference>/index.html
                    return try await serveURI(
                        String(format: .Format.Path.index, documentationFolder.path, uriData.archiveReference),
                        at: uriData.archivePath,
                        with: (request, context)
                    )
                } else {
                    // Rule #3: Redirects the URI path /<ArchiveName>/documentation to the path /<ArchiveName>/documentation/
                    // Rule #4: Redirects the URI path /<ArchiveName>/tutorials to the path /<ArchiveName>/tutorials/
                    return redirectURI(
                        String(format: .Format.Path.forwardSlash, uriPath),
                        with: (request, context)
                    )
                }
            }
        }

        return try await next(request, context)
    }
    
}


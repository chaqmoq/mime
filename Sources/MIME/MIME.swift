import Foundation

/// A media type (also known as a Multipurpose Internet Mail Extensions or MIME type) is a standard that indicates the nature and format of a document, file,
/// or assortment of bytes. It is defined and standardized in IETF's [RFC 6838](https://tools.ietf.org/html/rfc6838).
public struct MIME {
    /// A default type which is `application`.
    public static let type: String = "application"

    /// A default subtype which is `octet-stream`.
    public static let subtype: String = "octet-stream"

    /// A type such as `text`, `application`, etc.
    public let type: String

    /// A subtype such as `html`, `css`, etc.
    public let subtype: String

    /// A file extension matching a `type/subtype` value such as `swift`, `js`, etc.
    public let ext: String?

    /// Initializes a new instance with a type, subtype, and file extension as a hint since `MIME` types can have multiple file extensions. For
    /// example, a `MIME` type of `application/java-archive` can have `jar`, `ear`, and `war` file extensions. It falls back to
    /// `application/octet-stream` if the type, subtype or file extension is invalid.
    ///
    /// - Parameters:
    ///   - type: A type such as `text`, `application`, etc. Defaults to `application`.
    ///   - subtype: A subtype such as `html`, `css`, etc. Defaults to `octet-stream`.
    ///   - ext: A file extension matching a `type/subtype` value such as `swift`, `js`, etc. Defaults to `nil`.
    public init(type: String = type, subtype: String = subtype, ext: String? = nil) {
        let mime = "\(type)/\(subtype)"

        if let exts = MIME.map[mime], !exts.isEmpty {
            self.type = type
            self.subtype = subtype

            if let ext = ext {
                if exts.contains(where: { $0 == ext }) {
                    self.ext = ext
                } else {
                    self.ext = exts.first
                }
            } else {
                if type == MIME.type && subtype == MIME.subtype {
                    self.ext = nil
                } else {
                    self.ext = exts.first
                }
            }
        } else {
            self.type = MIME.type
            self.subtype = MIME.subtype
            self.ext = nil
        }
    }

    /// Initializes a new instance with the combination of `type/subtype` and a file extension as a hint since `MIME` types can have multiple file extensions.
    /// For example, a `MIME` type of `application/java-archive` can have `jar`, `ear`, and `war` file extensions. It falls back to
    /// `application/octet-stream` if the combination of `type/subtype` and file extension is invalid.
    ///
    /// - Parameters:
    ///   - mime: A `type/subtype` value.
    ///   - ext: A file extension matching a `type/subtype` value. Defaults to `nil`.
    public init(_ mime: String, ext: String? = nil) {
        let components = mime.components(separatedBy: "/")

        if let type = components.first, let subtype = components.last, components.count == 2 {
            self.init(type: type, subtype: subtype, ext: ext)
        } else {
            self.init()
        }
    }

    /// Initializes a new instance with a file extension. It falls back to `application/octet-stream` if the file extension is invalid.
    ///
    /// - Parameter ext: A file extension.
    public init(ext: String) {
        if let mime = MIME.reverseMap[ext]?.first {
            self.init(mime, ext: ext)
        } else {
            self.init()
        }
    }

    /// Initializes a new instance with a file path. It falls back to `application/octet-stream` if the file path is invalid.
    ///
    /// - Parameter path: A file path.
    public init(path: String) {
        self.init(ext: NSString(string: path).pathExtension)
    }

    /// Initializes a new instance with a file URL. It falls back to `application/octet-stream` if the file URL is invalid.
    ///
    /// - Parameter url: A file URL.
    public init(url: URL) {
        self.init(ext: url.pathExtension)
    }
}

extension MIME: CustomStringConvertible {
    /// See `CustomStringConvertible`.
    public var description: String { "\(type)/\(subtype)" }
}

import Foundation

/// A media type (also known as a Multipurpose Internet Mail Extensions or MIME type) is a standard that indicates the nature and format of a document, file,
/// or assortment of bytes. It is defined and standardized in IETF's [RFC 6838](https://tools.ietf.org/html/rfc6838).
public struct MIMEType {
    /// The default type `application`.
    public static let defaultType: String = "application"

    /// The default subtype `octet-stream`.
    public static let defaultSubtype: String = "octet-stream"

    /// A type such as `text`, `application`, etc.
    public let type: String

    /// A subtype such as `html`, `css`, etc.
    public let subtype: String

    /// A file extension matching the `type/subtype` such as `swift`, `js`, etc.
    public let ext: String?

    /// Initializes a new instance with a type, subtype and file extension as a hint since `MIMEType`s can have multiple file extensions. For
    /// example, a `MIMEType` of `application/java-archive` can have `jar`, `ear` and `war` file extensions. It falls back to
    /// `application/octet-stream` if the type, subtype or file extension is invalid.
    ///
    /// - Parameters:
    ///   - type: A type such as `text`, `application`, etc. Defaults to `application`.
    ///   - subtype: A subtype such as `html`, `css`, etc. Defaults to `octet-stream`.
    ///   - ext: A file extension matching the `type/subtype` such as `swift`, `js`, etc. Defaults to `nil`.
    public init(type: String = defaultType, subtype: String = defaultSubtype, ext: String? = nil) {
        let mimeType = "\(type)/\(subtype)"
        let exts = MIMEType.all.filter({ $0.1 == mimeType })

        if exts.isEmpty {
            self.type = MIMEType.defaultType
            self.subtype = MIMEType.defaultSubtype
            self.ext = nil
        } else {
            self.type = type
            self.subtype = subtype

            if let ext = ext {
                if exts.contains(where: { $0.0 == ext && $0.1 == mimeType }) {
                    self.ext = ext
                } else {
                    self.ext = exts.first?.0
                }
            } else {
                if type == MIMEType.defaultType && subtype == MIMEType.defaultSubtype {
                    self.ext = nil
                } else {
                    self.ext = exts.first?.0
                }
            }
        }
    }

    /// Initializes a new instance with a combination of type and subtype and a file extension as a hint since `MIMEType`s can have multiple file extensions.
    /// For example, a `MIMEType` of `application/java-archive` can have `jar`, `ear` and `war` file extensions. It falls back to
    /// `application/octet-stream` if the combination of type and subtype or file extension is invalid.
    ///
    /// - Parameters:
    ///   - string: A `type/subtype` string.
    ///   - ext: A file extension matching `type/subtype`. Defaults to `nil`.
    public init(_ string: String, ext: String? = nil) {
        let components = string.components(separatedBy: "/")

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
        if let string = MIMEType.all.first(where: { $0.0 == ext })?.1 {
            self.init(string, ext: ext)
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

extension MIMEType: CustomStringConvertible {
    /// See `CustomStringConvertible`.
    public var description: String { "\(type)/\(subtype)" }
}

extension MIMEType {
    static var all: [(String, String)] {
        return [
            ("atom", "application/atom+xml"),
            ("woff", "application/font-woff"),
            ("jar", "application/java-archive"),
            ("ear", "application/java-archive"),
            ("war", "application/java-archive"),
            ("js", "application/javascript"),
            ("json", "application/json"),
            ("hqx", "application/mac-binhex40"),
            ("doc", "application/msword"),
            ("bin", "application/octet-stream"),
            ("deb", "application/octet-stream"),
            ("dll", "application/octet-stream"),
            ("dmg", "application/octet-stream"),
            ("exe", "application/octet-stream"),
            ("img", "application/octet-stream"),
            ("iso", "application/octet-stream"),
            ("msi", "application/octet-stream"),
            ("msm", "application/octet-stream"),
            ("msp", "application/octet-stream"),
            ("pdf", "application/pdf"),
            ("ps", "application/postscript"),
            ("ai", "application/postscript"),
            ("eps", "application/postscript"),
            ("rss", "application/rss+xml"),
            ("rtf", "application/rtf"),
            ("m3u8", "application/vnd.apple.mpegurl"),
            ("kmz", "application/vnd.google-earth.kmz"),
            ("kml", "application/vnd.google-earth.kml+xml"),
            ("xls", "application/vnd.ms-excel"),
            ("eot", "application/vnd.ms-fontobject"),
            ("ppt", "application/vnd.ms-powerpoint"),
            ("wmlc", "application/vnd.wap.wmlc"),
            ("7z", "application/x-7z-compressed"),
            ("cco", "application/x-cocoa"),
            ("jardiff", "application/x-java-archive-diff"),
            ("jnlp", "application/x-java-jnlp-file"),
            ("run", "application/x-makeself"),
            ("pl", "application/x-perl"),
            ("pm", "application/x-perl"),
            ("prc", "application/x-pilot"),
            ("pdb", "application/x-pilot"),
            ("rar", "application/x-rar-compressed"),
            ("rpm", "application/x-redhat-package-manager"),
            ("sea", "application/x-sea"),
            ("swf", "application/x-shockwave-flash"),
            ("sit", "application/x-stuffit"),
            ("tcl", "application/x-tcl"),
            ("tk", "application/x-tcl"),
            ("der", "application/x-x509-ca-cert"),
            ("pem", "application/x-x509-ca-cert"),
            ("crt", "application/x-x509-ca-cert"),
            ("xhtml", "application/xhtml+xml"),
            ("xpi", "application/x-xpinstall"),
            ("xspf", "application/xspf+xml"),
            ("pptx", "application/vnd.openxmlformats-officedocument.presentationml.presentation"),
            ("xlsx", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"),
            ("docx", "application/vnd.openxmlformats-officedocument.wordprocessingml.document"),
            ("zip", "application/zip"),
            ("midi", "audio/midi"),
            ("mid", "audio/midi"),
            ("kar", "audio/midi"),
            ("mp3", "audio/mpeg"),
            ("ogg", "audio/ogg"),
            ("m4a", "audio/x-m4a"),
            ("ra", "audio/x-realaudio"),
            ("gif", "image/gif"),
            ("jpeg", "image/jpeg"),
            ("jpg", "image/jpeg"),
            ("png", "image/png"),
            ("tiff", "image/tiff"),
            ("tif", "image/tiff"),
            ("wbmp", "image/vnd.wap.wbmp"),
            ("ico", "image/x-icon"),
            ("jng", "image/x-jng"),
            ("bmp", "image/x-ms-bmp"),
            ("svg", "image/svg+xml"),
            ("svgz", "image/svg+xml"),
            ("webp", "image/webp"),
            ("css", "text/css"),
            ("html", "text/html"),
            ("htm", "text/html"),
            ("shtml", "text/html"),
            ("mml", "text/mathml"),
            ("txt", "text/plain"),
            ("jad", "text/vnd.sun.j2me.app-descriptor"),
            ("wml", "text/vnd.wap.wml"),
            ("htc", "text/x-component"),
            ("xml", "text/xml"),
            ("3gpp", "video/3gpp"),
            ("3gp", "video/3gpp"),
            ("ts", "video/mp2t"),
            ("mp4", "video/mp4"),
            ("mpeg", "video/mpeg"),
            ("mpg", "video/mpeg"),
            ("mov", "video/quicktime"),
            ("webm", "video/webm"),
            ("flv", "video/x-flv"),
            ("m4v", "video/x-m4v"),
            ("mng", "video/x-mng"),
            ("asf", "video/x-ms-asf"),
            ("asx", "video/x-ms-asf"),
            ("wmv", "video/x-ms-wmv"),
            ("avi", "video/x-msvideo")
        ]
    }
}

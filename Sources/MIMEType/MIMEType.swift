import class Foundation.NSString
import struct Foundation.URL

public struct MIMEType {
    public static let type: String = "application"
    public static let subtype: String = "octet-stream"

    public let type: String
    public let subtype: String
    public let ext: String?

    public init(type: String = type, subtype: String = subtype, ext: String? = nil) {
        let mimeType = "\(type)/\(subtype)"
        let exts = MIMEType.all.filter({ $0.1 == mimeType })

        if exts.isEmpty {
            self.type = MIMEType.type
            self.subtype = MIMEType.subtype
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
                if type == MIMEType.type && subtype == MIMEType.subtype {
                    self.ext = nil
                } else {
                    self.ext = exts.first?.0
                }
            }
        }
    }

    public init(_ string: String, ext: String? = nil) {
        let components = string.components(separatedBy: "/")

        if let type = components.first, let subtype = components.last, components.count == 2 {
            self.init(type: type, subtype: subtype, ext: ext)
        } else {
            self.init()
        }
    }

    public init(ext: String) {
        if let string = MIMEType.all.first(where: { $0.0 == ext })?.1 {
            self.init(string, ext: ext)
        } else {
            self.init()
        }
    }

    public init(path: String) {
        self.init(ext: NSString(string: path).pathExtension)
    }

    public init(url: URL) {
        self.init(ext: url.pathExtension)
    }
}

extension MIMEType: CustomStringConvertible {
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

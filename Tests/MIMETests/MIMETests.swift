@testable import MIME
import XCTest

final class MIMETests: XCTestCase {
    func testInit() {
        // Act
        var mime = MIME()

        // Assert
        XCTAssertEqual(mime.type, "application")
        XCTAssertEqual(mime.subtype, "octet-stream")
        XCTAssertNil(mime.ext)
        XCTAssertEqual("\(mime)", "application/octet-stream")

        // Act
        mime = MIME(type: "invalid-type", subtype: "invalid-subtype")

        // Assert
        XCTAssertEqual(mime.type, "application")
        XCTAssertEqual(mime.subtype, "octet-stream")
        XCTAssertNil(mime.ext)
        XCTAssertEqual("\(mime)", "application/octet-stream")

        // Act
        mime = MIME(type: "text", subtype: "html")

        // Assert
        XCTAssertEqual(mime.type, "text")
        XCTAssertEqual(mime.subtype, "html")
        XCTAssertEqual(mime.ext, "html")
        XCTAssertEqual("\(mime)", "text/html")

        // Act
        mime = MIME(type: "text", subtype: "html", ext: "invalid-ext")

        // Assert
        XCTAssertEqual(mime.type, "text")
        XCTAssertEqual(mime.subtype, "html")
        XCTAssertEqual(mime.ext, "html")
        XCTAssertEqual("\(mime)", "text/html")

        // Act
        mime = MIME(type: "application", subtype: "octet-stream", ext: "iso")

        // Assert
        XCTAssertEqual(mime.type, "application")
        XCTAssertEqual(mime.subtype, "octet-stream")
        XCTAssertEqual(mime.ext, "iso")
        XCTAssertEqual("\(mime)", "application/octet-stream")
    }

    func testInitWithString() {
        // Act
        var mime = MIME("application/java-archive")

        // Assert
        XCTAssertEqual(mime.type, "application")
        XCTAssertEqual(mime.subtype, "java-archive")
        XCTAssertEqual(mime.ext, "jar")
        XCTAssertEqual("\(mime)", "application/java-archive")

        // Act
        mime = MIME("invalid-mime-type")

        // Assert
        XCTAssertEqual(mime.type, "application")
        XCTAssertEqual(mime.subtype, "octet-stream")
        XCTAssertNil(mime.ext)
        XCTAssertEqual("\(mime)", "application/octet-stream")
    }

    func testInitWithExt() {
        // Act
        var mime = MIME(ext: "css")

        // Assert
        XCTAssertEqual(mime.type, "text")
        XCTAssertEqual(mime.subtype, "css")
        XCTAssertEqual(mime.ext, "css")
        XCTAssertEqual("\(mime)", "text/css")

        // Act
        mime = MIME(ext: "invalid-ext")

        // Assert
        XCTAssertEqual(mime.type, "application")
        XCTAssertEqual(mime.subtype, "octet-stream")
        XCTAssertNil(mime.ext)
        XCTAssertEqual("\(mime)", "application/octet-stream")
    }

    func testInitWithPath() {
        // Act
        let mime = MIME(path: "/public/js/main.js")

        // Assert
        XCTAssertEqual(mime.type, "application")
        XCTAssertEqual(mime.subtype, "javascript")
        XCTAssertEqual(mime.ext, "js")
        XCTAssertEqual("\(mime)", "application/javascript")
    }

    func testInitWithURL() {
        // Act
        let mime = MIME(url: URL(string: "https://chaqmoq.dev/public/img/logo.png")!)

        // Assert
        XCTAssertEqual(mime.type, "image")
        XCTAssertEqual(mime.subtype, "png")
        XCTAssertEqual(mime.ext, "png")
        XCTAssertEqual("\(mime)", "image/png")
    }

    func testGuess() {
        // Arrange
        var data = Data(
            [0x50, 0x4B, 0x03, 0x04] +
            Array(repeating: 0x04, count: 26) +
            [
                0x6D, 0x69, 0x6D, 0x65, 0x74, 0x79, 0x70, 0x65, 0x61, 0x70,
                0x70, 0x6C, 0x69, 0x63, 0x61, 0x74, 0x69, 0x6F, 0x6E, 0x2F,
                0x65, 0x70, 0x75, 0x62, 0x2B, 0x7A, 0x69, 0x70
            ]
        )

        // Act
        var mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "application")
        XCTAssertEqual(mime.subtype, "epub+zip")
        XCTAssertEqual(mime.ext, "epub")
        XCTAssertEqual("\(mime)", "application/epub+zip")

        // Arrange
        data = Data([0x4F, 0x54, 0x54, 0x4F, 0x00, 0x00])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "application")
        XCTAssertEqual(mime.subtype, "font-sfnt")
        XCTAssertEqual(mime.ext, "otf")
        XCTAssertEqual("\(mime)", "application/font-sfnt")

        // Arrange
        data = Data([0x00, 0x01, 0x00, 0x00, 0x00, 0x00])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "application")
        XCTAssertEqual(mime.subtype, "font-sfnt")
        XCTAssertEqual(mime.ext, "otf")
        XCTAssertEqual("\(mime)", "application/font-sfnt")

        // Arrange
        data = Data([0x77, 0x4F, 0x46, 0x46, 0x00, 0x01, 0x00, 0x00, 0x00])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "application")
        XCTAssertEqual(mime.subtype, "font-woff")
        XCTAssertEqual(mime.ext, "woff")
        XCTAssertEqual("\(mime)", "application/font-woff")

        // Arrange
        data = Data([0x77, 0x4F, 0x46, 0x46, 0x4F, 0x54, 0x54, 0x4F, 0x4F])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "application")
        XCTAssertEqual(mime.subtype, "font-woff")
        XCTAssertEqual(mime.ext, "woff")
        XCTAssertEqual("\(mime)", "application/font-woff")

        // Arrange
        data = Data([0x77, 0x4F, 0x46,  0x32, 0x00, 0x01, 0x00, 0x00, 0x00])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "application")
        XCTAssertEqual(mime.subtype, "font-woff")
        XCTAssertEqual(mime.ext, "woff2")
        XCTAssertEqual("\(mime)", "application/font-woff")

        // Arrange
        data = Data([0x77, 0x4F, 0x46, 0x32, 0x4F, 0x54, 0x54, 0x4F, 0x4F])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "application")
        XCTAssertEqual(mime.subtype, "font-woff")
        XCTAssertEqual(mime.ext, "woff2")
        XCTAssertEqual("\(mime)", "application/font-woff")

        // Arrange
        data = Data([0x1F, 0x8B, 0x08, 0x08])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "application")
        XCTAssertEqual(mime.subtype, "gzip")
        XCTAssertEqual(mime.ext, "gz")
        XCTAssertEqual("\(mime)", "application/gzip")

        // Arrange
        data = Data([0x06, 0x0E, 0x2B, 0x34, 0x02, 0x05, 0x01, 0x01, 0x0D, 0x01, 0x02, 0x01, 0x01, 0x02, 0x02])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "application")
        XCTAssertEqual(mime.subtype, "mxf")
        XCTAssertEqual(mime.ext, "mxf")
        XCTAssertEqual("\(mime)", "application/mxf")

        // Arrange
        data = Data([0x25, 0x50, 0x44, 0x46, 0x46])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "application")
        XCTAssertEqual(mime.subtype, "pdf")
        XCTAssertEqual(mime.ext, "pdf")
        XCTAssertEqual("\(mime)", "application/pdf")

        // Arrange
        data = Data([0x25, 0x21, 0x21])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "application")
        XCTAssertEqual(mime.subtype, "postscript")
        XCTAssertEqual(mime.ext, "ps")
        XCTAssertEqual("\(mime)", "application/postscript")

        // Arrange
        data = Data([0x7B, 0x5C, 0x72, 0x74, 0x66, 0x66])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "application")
        XCTAssertEqual(mime.subtype, "rtf")
        XCTAssertEqual(mime.ext, "rtf")
        XCTAssertEqual("\(mime)", "application/rtf")

        // Arrange
        data = Data([0x4D, 0x53, 0x43, 0x46, 0x46])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "application")
        XCTAssertEqual(mime.subtype, "vnd.ms-cab-compressed")
        XCTAssertEqual(mime.ext, "cab")
        XCTAssertEqual("\(mime)", "application/vnd.ms-cab-compressed")

        // Arrange
        data = Data([0x49, 0x53, 0x63, 0x28, 0x28])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "application")
        XCTAssertEqual(mime.subtype, "vnd.ms-cab-compressed")
        XCTAssertEqual(mime.ext, "cab")
        XCTAssertEqual("\(mime)", "application/vnd.ms-cab-compressed")

        // Arrange
        data = Data([0x37, 0x7A, 0xBC, 0xAF, 0x27, 0x1C, 0x1C])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "application")
        XCTAssertEqual(mime.subtype, "x-7z-compressed")
        XCTAssertEqual(mime.ext, "7z")
        XCTAssertEqual("\(mime)", "application/x-7z-compressed")

        // Arrange
        data = Data([0x42, 0x5A, 0x68, 0x68])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "application")
        XCTAssertEqual(mime.subtype, "x-bzip2")
        XCTAssertEqual(mime.ext, "bz2")
        XCTAssertEqual("\(mime)", "application/x-bzip2")

        // Arrange
        data = Data([0x1F, 0xA0, 0xA0])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "application")
        XCTAssertEqual(mime.subtype, "x-compress")
        XCTAssertEqual(mime.ext, "Z")
        XCTAssertEqual("\(mime)", "application/x-compress")

        // Arrange
        data = Data([0x1F, 0x9D, 0x9D])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "application")
        XCTAssertEqual(mime.subtype, "x-compress")
        XCTAssertEqual(mime.ext, "Z")
        XCTAssertEqual("\(mime)", "application/x-compress")

        // Arrange
        data = Data([
            0x21, 0x3C, 0x61, 0x72, 0x63, 0x68, 0x3E, 0x0A, 0x64, 0x65, 0x62,
            0x69, 0x61, 0x6E, 0x2D, 0x62, 0x69, 0x6E, 0x61, 0x72, 0x79, 0x79
        ])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "application")
        XCTAssertEqual(mime.subtype, "x-deb")
        XCTAssertEqual(mime.ext, "deb")
        XCTAssertEqual("\(mime)", "application/x-deb")

        // Arrange
        data = Data([0x43, 0x72, 0x32, 0x34, 0x34])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "application")
        XCTAssertEqual(mime.subtype, "x-google-chrome-extension")
        XCTAssertEqual(mime.ext, "crx")
        XCTAssertEqual("\(mime)", "application/x-google-chrome-extension")

        // Arrange
        data = Data([0x4C, 0x5A, 0x49, 0x50, 0x50])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "application")
        XCTAssertEqual(mime.subtype, "x-lzip")
        XCTAssertEqual(mime.ext, "lz")
        XCTAssertEqual("\(mime)", "application/x-lzip")

        // Arrange
        data = Data([0x4D, 0x5A, 0x5A])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "application")
        XCTAssertEqual(mime.subtype, "x-msdownload")
        XCTAssertEqual(mime.ext, "exe")
        XCTAssertEqual("\(mime)", "application/x-msdownload")

        // Arrange
        data = Data([0xD0, 0xCF, 0x11, 0xE0, 0xA1, 0xB1, 0x1A, 0xE1, 0xE1])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "application")
        XCTAssertEqual(mime.subtype, "x-msi")
        XCTAssertEqual(mime.ext, "msi")
        XCTAssertEqual("\(mime)", "application/x-msi")

        // Arrange
        data = Data([0x4E, 0x45, 0x53, 0x1A, 0x1A])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "application")
        XCTAssertEqual(mime.subtype, "x-nintendo-nes-rom")
        XCTAssertEqual(mime.ext, "nes")
        XCTAssertEqual("\(mime)", "application/x-nintendo-nes-rom")

        // Arrange
        data = Data([0x43, 0x57, 0x53, 0x53])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "application")
        XCTAssertEqual(mime.subtype, "x-shockwave-flash")
        XCTAssertEqual(mime.ext, "swf")
        XCTAssertEqual("\(mime)", "application/x-shockwave-flash")

        // Arrange
        data = Data([0x46, 0x57, 0x53, 0x53])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "application")
        XCTAssertEqual(mime.subtype, "x-shockwave-flash")
        XCTAssertEqual(mime.ext, "swf")
        XCTAssertEqual("\(mime)", "application/x-shockwave-flash")

        // Arrange
        data = Data([0x53, 0x51, 0x4C, 0x69])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "application")
        XCTAssertEqual(mime.subtype, "x-sqlite3")
        XCTAssertEqual(mime.ext, "sqlite")
        XCTAssertEqual("\(mime)", "application/x-sqlite3")

        // Arrange
        data = Data(Array(repeating: 0x04, count: 257) + [0x75, 0x73, 0x74, 0x61, 0x72])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "application")
        XCTAssertEqual(mime.subtype, "x-tar")
        XCTAssertEqual(mime.ext, "tar")
        XCTAssertEqual("\(mime)", "application/x-tar")

        // Arrange
        data = Data([0x52, 0x61, 0x72, 0x21, 0x1A, 0x07, 0x0, 0x0])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "application")
        XCTAssertEqual(mime.subtype, "x-rar-compressed")
        XCTAssertEqual(mime.ext, "rar")
        XCTAssertEqual("\(mime)", "application/x-rar-compressed")

        // Arrange
        data = Data([0x52, 0x61, 0x72, 0x21, 0x1A, 0x07, 0x1, 0x1])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "application")
        XCTAssertEqual(mime.subtype, "x-rar-compressed")
        XCTAssertEqual(mime.ext, "rar")
        XCTAssertEqual("\(mime)", "application/x-rar-compressed")

        // Arrange
        data = Data([0xED, 0xAB, 0xEE, 0xDB, 0xDB])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "application")
        XCTAssertEqual(mime.subtype, "x-rpm")
        XCTAssertEqual(mime.ext, "rpm")
        XCTAssertEqual("\(mime)", "application/x-rpm")

        // Arrange
        data = Data([0x21, 0x3C, 0x61, 0x72, 0x63, 0x68, 0x3E, 0x3E])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "application")
        XCTAssertEqual(mime.subtype, "x-unix-archive")
        XCTAssertEqual(mime.ext, "ar")
        XCTAssertEqual("\(mime)", "application/x-unix-archive")

        // Arrange
        data = Data(
            [0x50, 0x4B, 0x03, 0x04] +
            Array(repeating: 0x04, count: 26) +
            [
                0x4D, 0x45, 0x54, 0x41, 0x2D, 0x49, 0x4E, 0x46, 0x2F, 0x6D,
                0x6F, 0x7A, 0x69, 0x6C, 0x6C, 0x61, 0x2E, 0x72, 0x73, 0x61
            ]
        )

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "application")
        XCTAssertEqual(mime.subtype, "x-xpinstall")
        XCTAssertEqual(mime.ext, "xpi")
        XCTAssertEqual("\(mime)", "application/x-xpinstall")

        // Arrange
        data = Data([0xFD, 0x37, 0x7A, 0x58, 0x5A, 0x00, 0x00])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "application")
        XCTAssertEqual(mime.subtype, "x-xz")
        XCTAssertEqual(mime.ext, "xz")
        XCTAssertEqual("\(mime)", "application/x-xz")

        // Arrange
        data = Data([0x50, 0x4B, 0x3, 0x4])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "application")
        XCTAssertEqual(mime.subtype, "zip")
        XCTAssertEqual(mime.ext, "zip")
        XCTAssertEqual("\(mime)", "application/zip")

        // Arrange
        data = Data([0x50, 0x4B, 0x5, 0x6])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "application")
        XCTAssertEqual(mime.subtype, "zip")
        XCTAssertEqual(mime.ext, "zip")
        XCTAssertEqual("\(mime)", "application/zip")

        // Arrange
        data = Data([0x50, 0x4B, 0x7, 0x8])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "application")
        XCTAssertEqual(mime.subtype, "zip")
        XCTAssertEqual(mime.ext, "zip")
        XCTAssertEqual("\(mime)", "application/zip")

        // Arrange
        data = Data([0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "audio")
        XCTAssertEqual(mime.subtype, "amr")
        XCTAssertEqual(mime.ext, "amr")
        XCTAssertEqual("\(mime)", "audio/amr")

        // Arrange
        data = Data([0x4D, 0x34, 0x41, 0x20])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "audio")
        XCTAssertEqual(mime.subtype, "m4a")
        XCTAssertEqual(mime.ext, "m4a")
        XCTAssertEqual("\(mime)", "audio/m4a")

        // Arrange
        data = Data([0x66, 0x66, 0x66, 0x66, 0x66, 0x74, 0x79, 0x70, 0x4D, 0x34, 0x41])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "audio")
        XCTAssertEqual(mime.subtype, "m4a")
        XCTAssertEqual(mime.ext, "m4a")
        XCTAssertEqual("\(mime)", "audio/m4a")

        // Arrange
        data = Data([0x4D, 0x54, 0x68, 0x64])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "audio")
        XCTAssertEqual(mime.subtype, "midi")
        XCTAssertEqual(mime.ext, "midi")
        XCTAssertEqual("\(mime)", "audio/midi")

        // Arrange
        data = Data([0x49, 0x44, 0x33])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "audio")
        XCTAssertEqual(mime.subtype, "mpeg")
        XCTAssertEqual(mime.ext, "mp3")
        XCTAssertEqual("\(mime)", "audio/mpeg")

        // Arrange
        data = Data([0xFF, 0xFB])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "audio")
        XCTAssertEqual(mime.subtype, "mpeg")
        XCTAssertEqual(mime.ext, "mp3")
        XCTAssertEqual("\(mime)", "audio/mpeg")

        // Arrange
        data = Data(Array(repeating: 0x04, count: 28) + [0x4F, 0x70, 0x75, 0x73, 0x48, 0x65, 0x61, 0x64])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "audio")
        XCTAssertEqual(mime.subtype, "opus")
        XCTAssertEqual(mime.ext, "opus")
        XCTAssertEqual("\(mime)", "audio/opus")

        // Arrange
        data = Data([0x4F, 0x67, 0x67, 0x53])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "audio")
        XCTAssertEqual(mime.subtype, "ogg")
        XCTAssertEqual(mime.ext, "ogg")
        XCTAssertEqual("\(mime)", "audio/ogg")

        // Arrange
        data = Data([0x66, 0x4C, 0x61, 0x43])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "audio")
        XCTAssertEqual(mime.subtype, "x-flac")
        XCTAssertEqual(mime.ext, "flac")
        XCTAssertEqual("\(mime)", "audio/x-flac")

        // Arrange
        data = Data([0x52, 0x49, 0x46, 0x46, 0x46, 0x46, 0x46, 0x46, 0x57, 0x41, 0x56, 0x45])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "audio")
        XCTAssertEqual(mime.subtype, "x-wav")
        XCTAssertEqual(mime.ext, "wav")
        XCTAssertEqual("\(mime)", "audio/x-wav")

        // Arrange
        data = Data([0x42, 0x4D])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "image")
        XCTAssertEqual(mime.subtype, "bmp")
        XCTAssertEqual(mime.ext, "bmp")
        XCTAssertEqual("\(mime)", "image/bmp")

        // Arrange
        data = Data([0x46, 0x4C, 0x49, 0x46])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "image")
        XCTAssertEqual(mime.subtype, "flif")
        XCTAssertEqual(mime.ext, "flif")
        XCTAssertEqual("\(mime)", "image/flif")

        // Arrange
        data = Data([0x47, 0x49, 0x46])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "image")
        XCTAssertEqual(mime.subtype, "gif")
        XCTAssertEqual(mime.ext, "gif")
        XCTAssertEqual("\(mime)", "image/gif")

        // Arrange
        data = Data([0xFF, 0xD8, 0xFF])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "image")
        XCTAssertEqual(mime.subtype, "jpeg")
        XCTAssertEqual(mime.ext, "jpeg")
        XCTAssertEqual("\(mime)", "image/jpeg")

        // Arrange
        data = Data([0x89, 0x50, 0x4E, 0x47])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "image")
        XCTAssertEqual(mime.subtype, "png")
        XCTAssertEqual(mime.ext, "png")
        XCTAssertEqual("\(mime)", "image/png")

        // Arrange
        data = Data([0x49, 0x49, 0x2A, 0x00, 0x00, 0x00, 0x00, 0x00, 0x43, 0x52])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "image")
        XCTAssertEqual(mime.subtype, "x-canon-cr2")
        XCTAssertEqual(mime.ext, "cr2")
        XCTAssertEqual("\(mime)", "image/x-canon-cr2")

        // Arrange
        data = Data([0x4D, 0x4D, 0x00, 0x2A])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "image")
        XCTAssertEqual(mime.subtype, "tiff")
        XCTAssertEqual(mime.ext, "tiff")
        XCTAssertEqual("\(mime)", "image/tiff")

        // Arrange
        data = Data([0x38, 0x42, 0x50, 0x53])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "image")
        XCTAssertEqual(mime.subtype, "vnd.adobe.photoshop")
        XCTAssertEqual(mime.ext, "psd")
        XCTAssertEqual("\(mime)", "image/vnd.adobe.photoshop")

        // Arrange
        data = Data([0x49, 0x49, 0xBC])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "image")
        XCTAssertEqual(mime.subtype, "vnd.ms-photo")
        XCTAssertEqual(mime.ext, "jxr")
        XCTAssertEqual("\(mime)", "image/vnd.ms-photo")

        // Arrange
        data = Data([0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x45, 0x42, 0x50])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "image")
        XCTAssertEqual(mime.subtype, "webp")
        XCTAssertEqual(mime.ext, "webp")
        XCTAssertEqual("\(mime)", "image/webp")

        // Arrange
        data = Data([0x00, 0x00, 0x01, 0x00, 0x00])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "image")
        XCTAssertEqual(mime.subtype, "x-icon")
        XCTAssertEqual(mime.ext, "ico")
        XCTAssertEqual("\(mime)", "image/x-icon")

        // Arrange
        data = Data([0x00, 0x00, 0x00, 0x18, 0x66, 0x74, 0x79, 0x70])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "video")
        XCTAssertEqual(mime.subtype, "mp4")
        XCTAssertEqual(mime.ext, "mp4")
        XCTAssertEqual("\(mime)", "video/mp4")

        // Arrange
        data = Data([0x00, 0x00, 0x00, 0x20, 0x66, 0x74, 0x79, 0x70])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "video")
        XCTAssertEqual(mime.subtype, "mp4")
        XCTAssertEqual(mime.ext, "mp4")
        XCTAssertEqual("\(mime)", "video/mp4")

        // Arrange
        data = Data([0x33, 0x67, 0x70, 0x35])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "video")
        XCTAssertEqual(mime.subtype, "mp4")
        XCTAssertEqual(mime.ext, "mp4")
        XCTAssertEqual("\(mime)", "video/mp4")

        // Arrange
        data = Data([
            0x00, 0x00, 0x00, 0x1C, 0x66, 0x74, 0x79, 0x70, 0x6D, 0x70, 0x34, 0x32, 0x32, 0x32,
            0x32, 0x32, 0x6D, 0x70, 0x34, 0x31, 0x6D, 0x70, 0x34, 0x32, 0x69, 0x73, 0x6F, 0x6D
        ])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "video")
        XCTAssertEqual(mime.subtype, "mp4")
        XCTAssertEqual(mime.ext, "mp4")
        XCTAssertEqual("\(mime)", "video/mp4")

        // Arrange
        data = Data([0x00, 0x00, 0x00, 0x1C, 0x66, 0x74, 0x79, 0x70, 0x69, 0x73, 0x6F, 0x6D])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "video")
        XCTAssertEqual(mime.subtype, "mp4")
        XCTAssertEqual(mime.ext, "mp4")
        XCTAssertEqual("\(mime)", "video/mp4")

        // Arrange
        data = Data([0x00, 0x00, 0x00, 0x1C, 0x66, 0x74, 0x79, 0x70, 0x6D, 0x70, 0x34, 0x32, 0x00, 0x00, 0x00, 0x00])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "video")
        XCTAssertEqual(mime.subtype, "mp4")
        XCTAssertEqual(mime.ext, "mp4")
        XCTAssertEqual("\(mime)", "video/mp4")

        // Arrange
        data = Data([0x00, 0x00, 0x01, 0xB0, 0xB0])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "video")
        XCTAssertEqual(mime.subtype, "mpeg")
        XCTAssertEqual(mime.ext, "mpeg")
        XCTAssertEqual("\(mime)", "video/mpeg")

        // Arrange
        data = Data([0x00, 0x00, 0x00, 0x14, 0x66, 0x74, 0x79, 0x70, 0x70])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "video")
        XCTAssertEqual(mime.subtype, "quicktime")
        XCTAssertEqual(mime.ext, "mov")
        XCTAssertEqual("\(mime)", "video/quicktime")

        // Arrange
        data = Data([0x46, 0x4C, 0x56, 0x01, 0x01])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "video")
        XCTAssertEqual(mime.subtype, "x-flv")
        XCTAssertEqual(mime.ext, "flv")
        XCTAssertEqual("\(mime)", "video/x-flv")

        // Arrange
        data = Data([0x00, 0x00, 0x00, 0x1C, 0x66, 0x74, 0x79, 0x70, 0x4D, 0x34, 0x56, 0x56])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "video")
        XCTAssertEqual(mime.subtype, "x-m4v")
        XCTAssertEqual(mime.ext, "m4v")
        XCTAssertEqual("\(mime)", "video/x-m4v")

        // Arrange
        data = Data([0x30, 0x26, 0xB2, 0x75, 0x8E, 0x66, 0xCF, 0x11, 0xA6, 0xD9, 0xD9])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "video")
        XCTAssertEqual(mime.subtype, "x-ms-wmv")
        XCTAssertEqual(mime.ext, "wmv")
        XCTAssertEqual("\(mime)", "video/x-ms-wmv")

        // Arrange
        data = Data([0x52, 0x49, 0x46, 0x46, 0x46, 0x46, 0x46, 0x46, 0x41, 0x56, 0x49])

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "video")
        XCTAssertEqual(mime.subtype, "x-msvideo")
        XCTAssertEqual(mime.ext, "avi")
        XCTAssertEqual("\(mime)", "video/x-msvideo")

        // Arrange
        data = Data()

        // Act
        mime = MIME.guess(from: data)

        // Assert
        XCTAssertEqual(mime.type, "application")
        XCTAssertEqual(mime.subtype, "octet-stream")
        XCTAssertNil(mime.ext)
        XCTAssertEqual("\(mime)", "application/octet-stream")
    }
}

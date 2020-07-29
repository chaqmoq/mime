@testable import MIMEType
import XCTest

final class MIMETypeTests: XCTestCase {
    func testInit() {
        // Act
        var mimeType = MIMEType()

        // Assert
        XCTAssertEqual(mimeType.type, "application")
        XCTAssertEqual(mimeType.subtype, "octet-stream")
        XCTAssertNil(mimeType.ext)
        XCTAssertEqual("\(mimeType)", "application/octet-stream")

        // Act
        mimeType = MIMEType(type: "invalid-type", subtype: "invalid-subtype")

        // Assert
        XCTAssertEqual(mimeType.type, "application")
        XCTAssertEqual(mimeType.subtype, "octet-stream")
        XCTAssertNil(mimeType.ext)
        XCTAssertEqual("\(mimeType)", "application/octet-stream")

        // Act
        mimeType = MIMEType(type: "text", subtype: "html")

        // Assert
        XCTAssertEqual(mimeType.type, "text")
        XCTAssertEqual(mimeType.subtype, "html")
        XCTAssertEqual(mimeType.ext, "html")
        XCTAssertEqual("\(mimeType)", "text/html")

        // Act
        mimeType = MIMEType(type: "text", subtype: "html", ext: "invalid-ext")

        // Assert
        XCTAssertEqual(mimeType.type, "text")
        XCTAssertEqual(mimeType.subtype, "html")
        XCTAssertEqual(mimeType.ext, "html")
        XCTAssertEqual("\(mimeType)", "text/html")

        // Act
        mimeType = MIMEType(type: "application", subtype: "octet-stream", ext: "iso")

        // Assert
        XCTAssertEqual(mimeType.type, "application")
        XCTAssertEqual(mimeType.subtype, "octet-stream")
        XCTAssertEqual(mimeType.ext, "iso")
        XCTAssertEqual("\(mimeType)", "application/octet-stream")
    }

    func testInitWithString() {
        // Act
        var mimeType = MIMEType("application/java-archive")

        // Assert
        XCTAssertEqual(mimeType.type, "application")
        XCTAssertEqual(mimeType.subtype, "java-archive")
        XCTAssertEqual(mimeType.ext, "jar")
        XCTAssertEqual("\(mimeType)", "application/java-archive")

        // Act
        mimeType = MIMEType("invalid-mime-type")

        // Assert
        XCTAssertEqual(mimeType.type, "application")
        XCTAssertEqual(mimeType.subtype, "octet-stream")
        XCTAssertNil(mimeType.ext)
        XCTAssertEqual("\(mimeType)", "application/octet-stream")
    }

    func testInitWithExt() {
        // Act
        var mimeType = MIMEType(ext: "css")

        // Assert
        XCTAssertEqual(mimeType.type, "text")
        XCTAssertEqual(mimeType.subtype, "css")
        XCTAssertEqual(mimeType.ext, "css")
        XCTAssertEqual("\(mimeType)", "text/css")

        // Act
        mimeType = MIMEType(ext: "invalid-ext")

        // Assert
        XCTAssertEqual(mimeType.type, "application")
        XCTAssertEqual(mimeType.subtype, "octet-stream")
        XCTAssertNil(mimeType.ext)
        XCTAssertEqual("\(mimeType)", "application/octet-stream")
    }

    func testInitWithPath() {
        // Act
        let mimeType = MIMEType(path: "/public/js/main.js")

        // Assert
        XCTAssertEqual(mimeType.type, "application")
        XCTAssertEqual(mimeType.subtype, "javascript")
        XCTAssertEqual(mimeType.ext, "js")
        XCTAssertEqual("\(mimeType)", "application/javascript")
    }

    func testInitWithURL() {
        // Act
        let mimeType = MIMEType(url: URL(string: "https://chaqmoq.dev/public/img/logo.png")!)

        // Assert
        XCTAssertEqual(mimeType.type, "image")
        XCTAssertEqual(mimeType.subtype, "png")
        XCTAssertEqual(mimeType.ext, "png")
        XCTAssertEqual("\(mimeType)", "image/png")
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
        var mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "application")
        XCTAssertEqual(mimeType.subtype, "epub+zip")
        XCTAssertEqual(mimeType.ext, "epub")
        XCTAssertEqual("\(mimeType)", "application/epub+zip")

        // Arrange
        data = Data([0x4F, 0x54, 0x54, 0x4F, 0x00, 0x00])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "application")
        XCTAssertEqual(mimeType.subtype, "font-sfnt")
        XCTAssertEqual(mimeType.ext, "otf")
        XCTAssertEqual("\(mimeType)", "application/font-sfnt")

        // Arrange
        data = Data([0x00, 0x01, 0x00, 0x00, 0x00, 0x00])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "application")
        XCTAssertEqual(mimeType.subtype, "font-sfnt")
        XCTAssertEqual(mimeType.ext, "otf")
        XCTAssertEqual("\(mimeType)", "application/font-sfnt")

        // Arrange
        data = Data([0x77, 0x4F, 0x46, 0x46, 0x00, 0x01, 0x00, 0x00, 0x00])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "application")
        XCTAssertEqual(mimeType.subtype, "font-woff")
        XCTAssertEqual(mimeType.ext, "woff")
        XCTAssertEqual("\(mimeType)", "application/font-woff")

        // Arrange
        data = Data([0x77, 0x4F, 0x46, 0x46, 0x4F, 0x54, 0x54, 0x4F, 0x4F])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "application")
        XCTAssertEqual(mimeType.subtype, "font-woff")
        XCTAssertEqual(mimeType.ext, "woff")
        XCTAssertEqual("\(mimeType)", "application/font-woff")

        // Arrange
        data = Data([0x77, 0x4F, 0x46,  0x32, 0x00, 0x01, 0x00, 0x00, 0x00])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "application")
        XCTAssertEqual(mimeType.subtype, "font-woff")
        XCTAssertEqual(mimeType.ext, "woff2")
        XCTAssertEqual("\(mimeType)", "application/font-woff")

        // Arrange
        data = Data([0x77, 0x4F, 0x46,  0x32, 0x4F, 0x54, 0x54, 0x4F, 0x4F])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "application")
        XCTAssertEqual(mimeType.subtype, "font-woff")
        XCTAssertEqual(mimeType.ext, "woff2")
        XCTAssertEqual("\(mimeType)", "application/font-woff")

        // Arrange
        data = Data([0x1F, 0x8B, 0x08, 0x08])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "application")
        XCTAssertEqual(mimeType.subtype, "gzip")
        XCTAssertEqual(mimeType.ext, "gz")
        XCTAssertEqual("\(mimeType)", "application/gzip")

        // Arrange
        data = Data([0x06, 0x0E, 0x2B, 0x34, 0x02, 0x05, 0x01, 0x01, 0x0D, 0x01, 0x02, 0x01, 0x01, 0x02, 0x02])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "application")
        XCTAssertEqual(mimeType.subtype, "mxf")
        XCTAssertEqual(mimeType.ext, "mxf")
        XCTAssertEqual("\(mimeType)", "application/mxf")

        // Arrange
        data = Data([0x25, 0x50, 0x44, 0x46, 0x46])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "application")
        XCTAssertEqual(mimeType.subtype, "pdf")
        XCTAssertEqual(mimeType.ext, "pdf")
        XCTAssertEqual("\(mimeType)", "application/pdf")

        // Arrange
        data = Data([0x25, 0x21, 0x21])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "application")
        XCTAssertEqual(mimeType.subtype, "postscript")
        XCTAssertEqual(mimeType.ext, "ps")
        XCTAssertEqual("\(mimeType)", "application/postscript")

        // Arrange
        data = Data([0x7B, 0x5C, 0x72, 0x74, 0x66, 0x66])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "application")
        XCTAssertEqual(mimeType.subtype, "rtf")
        XCTAssertEqual(mimeType.ext, "rtf")
        XCTAssertEqual("\(mimeType)", "application/rtf")

        // Arrange
        data = Data([0x4D, 0x53, 0x43, 0x46, 0x46])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "application")
        XCTAssertEqual(mimeType.subtype, "vnd.ms-cab-compressed")
        XCTAssertEqual(mimeType.ext, "cab")
        XCTAssertEqual("\(mimeType)", "application/vnd.ms-cab-compressed")

        // Arrange
        data = Data([0x49, 0x53, 0x63, 0x28, 0x28])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "application")
        XCTAssertEqual(mimeType.subtype, "vnd.ms-cab-compressed")
        XCTAssertEqual(mimeType.ext, "cab")
        XCTAssertEqual("\(mimeType)", "application/vnd.ms-cab-compressed")

        // Arrange
        data = Data([0x37, 0x7A, 0xBC, 0xAF, 0x27, 0x1C, 0x1C])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "application")
        XCTAssertEqual(mimeType.subtype, "x-7z-compressed")
        XCTAssertEqual(mimeType.ext, "7z")
        XCTAssertEqual("\(mimeType)", "application/x-7z-compressed")

        // Arrange
        data = Data([0x42, 0x5A, 0x68, 0x68])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "application")
        XCTAssertEqual(mimeType.subtype, "x-bzip2")
        XCTAssertEqual(mimeType.ext, "bz2")
        XCTAssertEqual("\(mimeType)", "application/x-bzip2")

        // Arrange
        data = Data([0x1F, 0xA0, 0xA0])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "application")
        XCTAssertEqual(mimeType.subtype, "x-compress")
        XCTAssertEqual(mimeType.ext, "Z")
        XCTAssertEqual("\(mimeType)", "application/x-compress")

        // Arrange
        data = Data([0x1F, 0x9D, 0x9D])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "application")
        XCTAssertEqual(mimeType.subtype, "x-compress")
        XCTAssertEqual(mimeType.ext, "Z")
        XCTAssertEqual("\(mimeType)", "application/x-compress")

        // Arrange
        data = Data([
            0x21, 0x3C, 0x61, 0x72, 0x63, 0x68, 0x3E, 0x0A, 0x64, 0x65, 0x62,
            0x69, 0x61, 0x6E, 0x2D, 0x62, 0x69, 0x6E, 0x61, 0x72, 0x79, 0x79
        ])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "application")
        XCTAssertEqual(mimeType.subtype, "x-deb")
        XCTAssertEqual(mimeType.ext, "deb")
        XCTAssertEqual("\(mimeType)", "application/x-deb")

        // Arrange
        data = Data([0x43, 0x72, 0x32, 0x34, 0x34])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "application")
        XCTAssertEqual(mimeType.subtype, "x-google-chrome-extension")
        XCTAssertEqual(mimeType.ext, "crx")
        XCTAssertEqual("\(mimeType)", "application/x-google-chrome-extension")

        // Arrange
        data = Data([0x4C, 0x5A, 0x49, 0x50, 0x50])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "application")
        XCTAssertEqual(mimeType.subtype, "x-lzip")
        XCTAssertEqual(mimeType.ext, "lz")
        XCTAssertEqual("\(mimeType)", "application/x-lzip")

        // Arrange
        data = Data([0x4D, 0x5A, 0x5A])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "application")
        XCTAssertEqual(mimeType.subtype, "x-msdownload")
        XCTAssertEqual(mimeType.ext, "exe")
        XCTAssertEqual("\(mimeType)", "application/x-msdownload")

        // Arrange
        data = Data([0xD0, 0xCF, 0x11, 0xE0, 0xA1, 0xB1, 0x1A, 0xE1, 0xE1])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "application")
        XCTAssertEqual(mimeType.subtype, "x-msi")
        XCTAssertEqual(mimeType.ext, "msi")
        XCTAssertEqual("\(mimeType)", "application/x-msi")

        // Arrange
        data = Data([0x4E, 0x45, 0x53, 0x1A, 0x1A])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "application")
        XCTAssertEqual(mimeType.subtype, "x-nintendo-nes-rom")
        XCTAssertEqual(mimeType.ext, "nes")
        XCTAssertEqual("\(mimeType)", "application/x-nintendo-nes-rom")

        // Arrange
        data = Data([0x43, 0x57, 0x53, 0x53])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "application")
        XCTAssertEqual(mimeType.subtype, "x-shockwave-flash")
        XCTAssertEqual(mimeType.ext, "swf")
        XCTAssertEqual("\(mimeType)", "application/x-shockwave-flash")

        // Arrange
        data = Data([0x46, 0x57, 0x53, 0x53])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "application")
        XCTAssertEqual(mimeType.subtype, "x-shockwave-flash")
        XCTAssertEqual(mimeType.ext, "swf")
        XCTAssertEqual("\(mimeType)", "application/x-shockwave-flash")

        // Arrange
        data = Data([0x53, 0x51, 0x4C, 0x69])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "application")
        XCTAssertEqual(mimeType.subtype, "x-sqlite3")
        XCTAssertEqual(mimeType.ext, "sqlite")
        XCTAssertEqual("\(mimeType)", "application/x-sqlite3")

        // Arrange
        data = Data(Array(repeating: 0x04, count: 257) + [0x75, 0x73, 0x74, 0x61, 0x72])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "application")
        XCTAssertEqual(mimeType.subtype, "x-tar")
        XCTAssertEqual(mimeType.ext, "tar")
        XCTAssertEqual("\(mimeType)", "application/x-tar")

        // Arrange
        data = Data([0x52, 0x61, 0x72, 0x21, 0x1A, 0x07, 0x0, 0x0])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "application")
        XCTAssertEqual(mimeType.subtype, "x-rar-compressed")
        XCTAssertEqual(mimeType.ext, "rar")
        XCTAssertEqual("\(mimeType)", "application/x-rar-compressed")

        // Arrange
        data = Data([0x52, 0x61, 0x72, 0x21, 0x1A, 0x07, 0x1, 0x1])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "application")
        XCTAssertEqual(mimeType.subtype, "x-rar-compressed")
        XCTAssertEqual(mimeType.ext, "rar")
        XCTAssertEqual("\(mimeType)", "application/x-rar-compressed")

        // Arrange
        data = Data([0xED, 0xAB, 0xEE, 0xDB, 0xDB])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "application")
        XCTAssertEqual(mimeType.subtype, "x-rpm")
        XCTAssertEqual(mimeType.ext, "rpm")
        XCTAssertEqual("\(mimeType)", "application/x-rpm")

        // Arrange
        data = Data([0x21, 0x3C, 0x61, 0x72, 0x63, 0x68, 0x3E, 0x3E])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "application")
        XCTAssertEqual(mimeType.subtype, "x-unix-archive")
        XCTAssertEqual(mimeType.ext, "ar")
        XCTAssertEqual("\(mimeType)", "application/x-unix-archive")

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
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "application")
        XCTAssertEqual(mimeType.subtype, "x-xpinstall")
        XCTAssertEqual(mimeType.ext, "xpi")
        XCTAssertEqual("\(mimeType)", "application/x-xpinstall")

        // Arrange
        data = Data([0xFD, 0x37, 0x7A, 0x58, 0x5A, 0x00, 0x00])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "application")
        XCTAssertEqual(mimeType.subtype, "x-xz")
        XCTAssertEqual(mimeType.ext, "xz")
        XCTAssertEqual("\(mimeType)", "application/x-xz")

        // Arrange
        data = Data([0x50, 0x4B, 0x3, 0x4])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "application")
        XCTAssertEqual(mimeType.subtype, "zip")
        XCTAssertEqual(mimeType.ext, "zip")
        XCTAssertEqual("\(mimeType)", "application/zip")

        // Arrange
        data = Data([0x50, 0x4B, 0x5, 0x6])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "application")
        XCTAssertEqual(mimeType.subtype, "zip")
        XCTAssertEqual(mimeType.ext, "zip")
        XCTAssertEqual("\(mimeType)", "application/zip")

        // Arrange
        data = Data([0x50, 0x4B, 0x7, 0x8])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "application")
        XCTAssertEqual(mimeType.subtype, "zip")
        XCTAssertEqual(mimeType.ext, "zip")
        XCTAssertEqual("\(mimeType)", "application/zip")

        // Arrange
        data = Data([0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "audio")
        XCTAssertEqual(mimeType.subtype, "amr")
        XCTAssertEqual(mimeType.ext, "amr")
        XCTAssertEqual("\(mimeType)", "audio/amr")

        // Arrange
        data = Data([0x4D, 0x34, 0x41, 0x20])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "audio")
        XCTAssertEqual(mimeType.subtype, "m4a")
        XCTAssertEqual(mimeType.ext, "m4a")
        XCTAssertEqual("\(mimeType)", "audio/m4a")

        // Arrange
        data = Data([0x66, 0x66, 0x66, 0x66, 0x66, 0x74, 0x79, 0x70, 0x4D, 0x34, 0x41])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "audio")
        XCTAssertEqual(mimeType.subtype, "m4a")
        XCTAssertEqual(mimeType.ext, "m4a")
        XCTAssertEqual("\(mimeType)", "audio/m4a")

        // Arrange
        data = Data([0x4D, 0x54, 0x68, 0x64])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "audio")
        XCTAssertEqual(mimeType.subtype, "midi")
        XCTAssertEqual(mimeType.ext, "midi")
        XCTAssertEqual("\(mimeType)", "audio/midi")

        // Arrange
        data = Data([0x49, 0x44, 0x33])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "audio")
        XCTAssertEqual(mimeType.subtype, "mpeg")
        XCTAssertEqual(mimeType.ext, "mp3")
        XCTAssertEqual("\(mimeType)", "audio/mpeg")

        // Arrange
        data = Data([0xFF, 0xFB])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "audio")
        XCTAssertEqual(mimeType.subtype, "mpeg")
        XCTAssertEqual(mimeType.ext, "mp3")
        XCTAssertEqual("\(mimeType)", "audio/mpeg")

        // Arrange
        data = Data(Array(repeating: 0x04, count: 28) + [0x4F, 0x70, 0x75, 0x73, 0x48, 0x65, 0x61, 0x64])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "audio")
        XCTAssertEqual(mimeType.subtype, "opus")
        XCTAssertEqual(mimeType.ext, "opus")
        XCTAssertEqual("\(mimeType)", "audio/opus")

        // Arrange
        data = Data([0x4F, 0x67, 0x67, 0x53])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "audio")
        XCTAssertEqual(mimeType.subtype, "ogg")
        XCTAssertEqual(mimeType.ext, "ogg")
        XCTAssertEqual("\(mimeType)", "audio/ogg")

        // Arrange
        data = Data([0x66, 0x4C, 0x61, 0x43])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "audio")
        XCTAssertEqual(mimeType.subtype, "x-flac")
        XCTAssertEqual(mimeType.ext, "flac")
        XCTAssertEqual("\(mimeType)", "audio/x-flac")

        // Arrange
        data = Data([0x52, 0x49, 0x46, 0x46, 0x46, 0x46, 0x46, 0x46, 0x57, 0x41, 0x56, 0x45])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "audio")
        XCTAssertEqual(mimeType.subtype, "x-wav")
        XCTAssertEqual(mimeType.ext, "wav")
        XCTAssertEqual("\(mimeType)", "audio/x-wav")

        // Arrange
        data = Data([0x42, 0x4D])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "image")
        XCTAssertEqual(mimeType.subtype, "bmp")
        XCTAssertEqual(mimeType.ext, "bmp")
        XCTAssertEqual("\(mimeType)", "image/bmp")

        // Arrange
        data = Data([0x46, 0x4C, 0x49, 0x46])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "image")
        XCTAssertEqual(mimeType.subtype, "flif")
        XCTAssertEqual(mimeType.ext, "flif")
        XCTAssertEqual("\(mimeType)", "image/flif")

        // Arrange
        data = Data([0x47, 0x49, 0x46])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "image")
        XCTAssertEqual(mimeType.subtype, "gif")
        XCTAssertEqual(mimeType.ext, "gif")
        XCTAssertEqual("\(mimeType)", "image/gif")

        // Arrange
        data = Data([0xFF, 0xD8, 0xFF])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "image")
        XCTAssertEqual(mimeType.subtype, "jpeg")
        XCTAssertEqual(mimeType.ext, "jpeg")
        XCTAssertEqual("\(mimeType)", "image/jpeg")

        // Arrange
        data = Data([0x89, 0x50, 0x4E, 0x47])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "image")
        XCTAssertEqual(mimeType.subtype, "png")
        XCTAssertEqual(mimeType.ext, "png")
        XCTAssertEqual("\(mimeType)", "image/png")

        // Arrange
        data = Data([0x49, 0x49, 0x2A, 0x00, 0x00, 0x00, 0x00, 0x00, 0x43, 0x52])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "image")
        XCTAssertEqual(mimeType.subtype, "x-canon-cr2")
        XCTAssertEqual(mimeType.ext, "cr2")
        XCTAssertEqual("\(mimeType)", "image/x-canon-cr2")

        // Arrange
        data = Data([0x4D, 0x4D, 0x00, 0x2A])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "image")
        XCTAssertEqual(mimeType.subtype, "tiff")
        XCTAssertEqual(mimeType.ext, "tiff")
        XCTAssertEqual("\(mimeType)", "image/tiff")

        // Arrange
        data = Data([0x38, 0x42, 0x50, 0x53])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "image")
        XCTAssertEqual(mimeType.subtype, "vnd.adobe.photoshop")
        XCTAssertEqual(mimeType.ext, "psd")
        XCTAssertEqual("\(mimeType)", "image/vnd.adobe.photoshop")

        // Arrange
        data = Data([0x49, 0x49, 0xBC])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "image")
        XCTAssertEqual(mimeType.subtype, "vnd.ms-photo")
        XCTAssertEqual(mimeType.ext, "jxr")
        XCTAssertEqual("\(mimeType)", "image/vnd.ms-photo")

        // Arrange
        data = Data([0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x45, 0x42, 0x50])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "image")
        XCTAssertEqual(mimeType.subtype, "webp")
        XCTAssertEqual(mimeType.ext, "webp")
        XCTAssertEqual("\(mimeType)", "image/webp")

        // Arrange
        data = Data([0x00, 0x00, 0x01, 0x00, 0x00])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "image")
        XCTAssertEqual(mimeType.subtype, "x-icon")
        XCTAssertEqual(mimeType.ext, "ico")
        XCTAssertEqual("\(mimeType)", "image/x-icon")

        // Arrange
        data = Data([0x00, 0x00, 0x00, 0x18, 0x66, 0x74, 0x79, 0x70])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "video")
        XCTAssertEqual(mimeType.subtype, "mp4")
        XCTAssertEqual(mimeType.ext, "mp4")
        XCTAssertEqual("\(mimeType)", "video/mp4")

        // Arrange
        data = Data([0x00, 0x00, 0x00, 0x20, 0x66, 0x74, 0x79, 0x70])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "video")
        XCTAssertEqual(mimeType.subtype, "mp4")
        XCTAssertEqual(mimeType.ext, "mp4")
        XCTAssertEqual("\(mimeType)", "video/mp4")

        // Arrange
        data = Data([0x33, 0x67, 0x70, 0x35])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "video")
        XCTAssertEqual(mimeType.subtype, "mp4")
        XCTAssertEqual(mimeType.ext, "mp4")
        XCTAssertEqual("\(mimeType)", "video/mp4")

        // Arrange
        data = Data([
            0x00, 0x00, 0x00, 0x1C, 0x66, 0x74, 0x79, 0x70, 0x6D, 0x70, 0x34, 0x32, 0x32, 0x32,
            0x32, 0x32, 0x6D, 0x70, 0x34, 0x31, 0x6D, 0x70, 0x34, 0x32, 0x69, 0x73, 0x6F, 0x6D
        ])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "video")
        XCTAssertEqual(mimeType.subtype, "mp4")
        XCTAssertEqual(mimeType.ext, "mp4")
        XCTAssertEqual("\(mimeType)", "video/mp4")

        // Arrange
        data = Data([0x00, 0x00, 0x00, 0x1C, 0x66, 0x74, 0x79, 0x70, 0x69, 0x73, 0x6F, 0x6D])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "video")
        XCTAssertEqual(mimeType.subtype, "mp4")
        XCTAssertEqual(mimeType.ext, "mp4")
        XCTAssertEqual("\(mimeType)", "video/mp4")

        // Arrange
        data = Data([0x00, 0x00, 0x00, 0x1C, 0x66, 0x74, 0x79, 0x70, 0x6D, 0x70, 0x34, 0x32, 0x00, 0x00, 0x00, 0x00])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "video")
        XCTAssertEqual(mimeType.subtype, "mp4")
        XCTAssertEqual(mimeType.ext, "mp4")
        XCTAssertEqual("\(mimeType)", "video/mp4")

        // Arrange
        data = Data([0x00, 0x00, 0x01, 0xB0, 0xB0])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "video")
        XCTAssertEqual(mimeType.subtype, "mpeg")
        XCTAssertEqual(mimeType.ext, "mpeg")
        XCTAssertEqual("\(mimeType)", "video/mpeg")

        // Arrange
        data = Data([0x00, 0x00, 0x00, 0x14, 0x66, 0x74, 0x79, 0x70, 0x70])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "video")
        XCTAssertEqual(mimeType.subtype, "quicktime")
        XCTAssertEqual(mimeType.ext, "mov")
        XCTAssertEqual("\(mimeType)", "video/quicktime")

        // Arrange
        data = Data([0x46, 0x4C, 0x56, 0x01, 0x01])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "video")
        XCTAssertEqual(mimeType.subtype, "x-flv")
        XCTAssertEqual(mimeType.ext, "flv")
        XCTAssertEqual("\(mimeType)", "video/x-flv")

        // Arrange
        data = Data([0x00, 0x00, 0x00, 0x1C, 0x66, 0x74, 0x79, 0x70, 0x4D, 0x34, 0x56, 0x56])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "video")
        XCTAssertEqual(mimeType.subtype, "x-m4v")
        XCTAssertEqual(mimeType.ext, "m4v")
        XCTAssertEqual("\(mimeType)", "video/x-m4v")

        // Arrange
        data = Data([0x30, 0x26, 0xB2, 0x75, 0x8E, 0x66, 0xCF, 0x11, 0xA6, 0xD9, 0xD9])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "video")
        XCTAssertEqual(mimeType.subtype, "x-ms-wmv")
        XCTAssertEqual(mimeType.ext, "wmv")
        XCTAssertEqual("\(mimeType)", "video/x-ms-wmv")

        // Arrange
        data = Data([0x52, 0x49, 0x46, 0x46, 0x46, 0x46, 0x46, 0x46, 0x41, 0x56, 0x49])

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "video")
        XCTAssertEqual(mimeType.subtype, "x-msvideo")
        XCTAssertEqual(mimeType.ext, "avi")
        XCTAssertEqual("\(mimeType)", "video/x-msvideo")

        // Arrange
        data = Data()

        // Act
        mimeType = MIMEType.guess(from: data)

        // Assert
        XCTAssertEqual(mimeType.type, "application")
        XCTAssertEqual(mimeType.subtype, "octet-stream")
        XCTAssertNil(mimeType.ext)
        XCTAssertEqual("\(mimeType)", "application/octet-stream")
    }
}

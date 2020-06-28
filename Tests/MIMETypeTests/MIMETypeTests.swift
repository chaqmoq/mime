import XCTest
@testable import MIMEType

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
        mimeType = MIMEType(type: "application", subtype: "octet-stream", ext: "dmg")

        // Assert
        XCTAssertEqual(mimeType.type, "application")
        XCTAssertEqual(mimeType.subtype, "octet-stream")
        XCTAssertEqual(mimeType.ext, "dmg")
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
}

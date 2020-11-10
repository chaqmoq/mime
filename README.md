# MIME component
[![Swift](https://img.shields.io/badge/swift-5.3-brightgreen.svg)](https://swift.org/download/#releases) [![MIT License](https://img.shields.io/badge/license-MIT-brightgreen.svg)](https://github.com/chaqmoq/mime/blob/master/LICENSE/) [![Actions Status](https://github.com/chaqmoq/mime/workflows/development/badge.svg)](https://github.com/chaqmoq/mime/actions) [![Codacy Badge](https://app.codacy.com/project/badge/Grade/8db2563aade54b95afdefa13fbe8dbb7)](https://www.codacy.com/gh/chaqmoq/mime?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=chaqmoq/mime&amp;utm_campaign=Badge_Grade) [![Contributing](https://img.shields.io/badge/contributing-guide-brightgreen.svg)](https://github.com/chaqmoq/mime/blob/master/CONTRIBUTING.md) [![Twitter](https://img.shields.io/badge/twitter-chaqmoqdev-brightgreen.svg)](https://twitter.com/chaqmoqdev)

## Installation
### Swift
Download and install [Swift](https://swift.org/download)

### Swift Package
```shell
mkdir MyApp
cd MyApp
swift package init --type executable // Creates an executable app named "MyApp"
```

### Package.swift
```swift
// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "MyApp",
    dependencies: [
        .package(url: "https://github.com/chaqmoq/mime.git", .branch("master"))
    ],
    targets: [
        .target(name: "MyApp", dependencies: ["MIME"]),
        .testTarget(name: "MyAppTests", dependencies: ["MyApp"])
    ]
)
```

### Build
```shell
swift build -c release
```

## Usage
### main.swift
```swift
import MIME

var mimeType = MIMEType()
print(mimeType) // "application/octet-stream"
print(mimeType.ext) // nil

mimeType = MIMEType(type: "text", subtype: "html")
print(mimeType) // "text/html"
print(mimeType.ext) // "html"

mimeType = MIMEType("application/java-archive")
print(mimeType) // "application/java-archive"
print(mimeType.ext) // "jar"

mimeType = MIMEType("application/java-archive", ext: "war")
print(mimeType) // "application/java-archive"
print(mimeType.ext) // "war"

mimeType = MIMEType(ext: "css")
print(mimeType) // "text/css"
print(mimeType.ext) // "css"

mimeType = MIMEType(path: "/public/js/main.js")
print(mimeType) // "application/javascript"
print(mimeType.ext) // "js"

mimeType = MIMEType(url: URL(string: "https://chaqmoq.dev/public/img/logo.png")!)
print(mimeType) // "image/png"
print(mimeType.ext) // "png"

let data = Data([0xFF, 0xD8, 0xFF, ...])
mimeType = MIMEType.guess(from: data)
print(mimeType) // "image/jpeg"
print(mimeType.ext) // "jpeg"

let bytes: [UInt8] = [0x47, 0x49, 0x46, ...]
mimeType = MIMEType.guess(from: bytes)
print(mimeType) // "image/gif"
print(mimeType.ext) // "gif"
```

### Run
```shell
swift run
```

### Tests
```shell
swift test --enable-test-discovery --sanitize=thread
```

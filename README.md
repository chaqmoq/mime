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
        .package(name: "chaqmoq-mime", url: "https://github.com/chaqmoq/mime.git", from: "1.0.0"),
    ],
    targets: [
        .target(name: "MyApp", dependencies: [
            .product(name: "MIME", package: "chaqmoq-mime"),
        ]),
        .testTarget(name: "MyAppTests", dependencies: [
            .target(name: "MyApp")
        ])
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

var mime = MIME()
print(mime) // "application/octet-stream"
print(mime.ext) // nil

mime = MIME(type: "text", subtype: "html")
print(mime) // "text/html"
print(mime.ext) // "html"

mime = MIME("application/java-archive")
print(mime) // "application/java-archive"
print(mime.ext) // "jar"

mime = MIME("application/java-archive", ext: "war")
print(mime) // "application/java-archive"
print(mime.ext) // "war"

mime = MIME(ext: "css")
print(mime) // "text/css"
print(mime.ext) // "css"

mime = MIME(path: "/public/js/main.js")
print(mime) // "text/javascript"
print(mime.ext) // "js"

mime = MIME(url: URL(string: "https://chaqmoq.dev/public/img/logo.png")!)
print(mime) // "image/png"
print(mime.ext) // "png"

let data = Data([0xFF, 0xD8, 0xFF, ...])
mime = MIME.guess(from: data)
print(mime) // "image/jpeg"
print(mime.ext) // "jpg"

let bytes: [UInt8] = [0x47, 0x49, 0x46, ...]
mime = MIME.guess(from: bytes)
print(mime) // "image/gif"
print(mime.ext) // "gif"
```

### Run
```shell
swift run
```

### Tests
```shell
swift test --enable-test-discovery --sanitize=thread
```

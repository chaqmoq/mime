# MIMEType component
[![Swift](https://img.shields.io/badge/swift-5.1-brightgreen.svg)](https://swift.org/download/#releases) [![MIT License](https://img.shields.io/badge/license-MIT-brightgreen.svg)](https://github.com/chaqmoq/mime-type/blob/master/LICENSE/) [![Actions Status](https://github.com/chaqmoq/mime-type/workflows/development/badge.svg)](https://github.com/chaqmoq/mime-type/actions) [![Codacy Badge](https://app.codacy.com/project/badge/Grade/8db2563aade54b95afdefa13fbe8dbb7)](https://www.codacy.com/gh/chaqmoq/mime-type?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=chaqmoq/mime-type&amp;utm_campaign=Badge_Grade) [![Contributing](https://img.shields.io/badge/contributing-guide-brightgreen.svg)](https://github.com/chaqmoq/mime-type/blob/master/CONTRIBUTING.md) [![Twitter](https://img.shields.io/badge/twitter-chaqmoqdev-brightgreen.svg)](https://twitter.com/chaqmoqdev)

## Installation
### Swift
Download and install [Swift](https://swift.org/download)

### Swift Package
#### Shell
```shell
mkdir MyApp
cd MyApp
swift package init --type executable // Creates an executable app named "MyApp"
```

#### Package.swift
```swift
// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "MyApp",
    dependencies: [
        .package(url: "https://github.com/chaqmoq/mime-type.git", .branch("master"))
    ],
    targets: [
        .target(name: "MyApp", dependencies: ["MIMEType"]),
        .testTarget(name: "MyAppTests", dependencies: ["MyApp"])
    ]
)
```

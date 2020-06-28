// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "chaqmoq-mime-type",
    products: [
        .library(name: "MIMEType", targets: ["MIMEType"])
    ],
    targets: [
        .target(name: "MIMEType"),
        .testTarget(name: "MIMETypeTests", dependencies: ["MIMEType"])
    ],
    swiftLanguageVersions: [.v5]
)

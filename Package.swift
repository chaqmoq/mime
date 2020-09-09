// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "chaqmoq-mime",
    products: [
        .library(name: "MIME", targets: ["MIME"])
    ],
    targets: [
        .target(name: "MIME"),
        .testTarget(name: "MIMETests", dependencies: ["MIME"])
    ],
    swiftLanguageVersions: [.v5]
)

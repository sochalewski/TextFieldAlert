// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "TextFieldAlert",
    platforms: [
        .iOS(.v13),
        .tvOS(.v13)
    ],
    products: [
        .library(
            name: "TextFieldAlert",
            targets: ["TextFieldAlert"]
        )
    ],
    targets: [
        .target(
            name: "TextFieldAlert",
            dependencies: []
        )
    ]
)

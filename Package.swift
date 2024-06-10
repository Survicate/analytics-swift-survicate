// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SurvicateDestination",
    platforms: [
        .iOS("13.0"),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SurvicateDestination",
            targets: ["SurvicateDestination"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(
            name: "Segment",
            url: "https://github.com/segmentio/analytics-swift.git",
            from: "1.5.2"
        ),
        .package(
            name: "Survicate",
            url: "https://github.com/Survicate/survicate-ios-sdk",
            from: "4.4.0"
        )
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "SurvicateDestination",
            dependencies: ["Segment", "Survicate"]),
        
        // TESTS ARE HANDLED VIA THE EXAMPLE APP.
    ]
)


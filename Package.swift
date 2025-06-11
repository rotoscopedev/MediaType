// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "MediaType",
  defaultLocalization: "en",
  platforms: [
    .macOS(.v11), .iOS(.v14), .tvOS(.v14), .watchOS(.v7), .visionOS(.v1),
  ],
  products: [
    // Products define the executables and libraries a package produces, and make them visible to other packages.
    .library(
      name: "MediaType",
      targets: ["MediaType"]),
  ],
  dependencies: [
    // Dependencies declare other packages that this package depends on.
    .package(url: "https://github.com/rotoscopedev/IANACharset.git", branch: "develop"),
  ],
  targets: [
    // Targets are the basic building blocks of a package. A target can define a module or a test suite.
    // Targets can depend on other targets in this package, and on products in packages this package depends on.
    .target(
      name: "MediaType",
      dependencies: [
        "IANACharset",
      ],
      resources: [
        .process("Resources"),
      ]
    ),
    .testTarget(
      name: "MediaTypeTests",
      dependencies: [
        "MediaType",
      ]
    ),
  ]
)

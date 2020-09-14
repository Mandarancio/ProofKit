// swift-tools-version:4.2

import PackageDescription

let package = Package(
  name: "ProofKit",
  dependencies: [
    .package(url: "https://github.com/damdamo/SwiftKanren.git", .branch("master")),
  ],
  targets: [
    // Targets are the basic building blocks of a package. A target can define a module or a test suite.
    // Targets can depend on other targets in this package, and on products in packages which this package depends on.
    .target(
      name: "ProofKit",
      dependencies: ["SwiftKanren"]),
    .testTarget(
      name: "ProofKitTests",
      dependencies: ["ProofKit"]),
    ]
)

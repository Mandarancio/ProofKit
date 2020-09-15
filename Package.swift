// swift-tools-version:4.2

import PackageDescription

let package = Package(
  name: "ProofKit",
  products: [
    // Products define the executables and libraries produced by a package, and make them visible to other packages.
    .library(
      name: "ProofKit",
      targets: ["ProofKit"]),
  ],
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

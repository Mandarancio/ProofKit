import PackageDescription

let package = Package(
    name: "ProofKit",
    dependencies: [
        .Package(url: "https://github.com/kyouko-taiga/LogicKit",
                 majorVersion: 0),
    ]
)

import PackageDescription

let package = Package(
    name: "ProofKit",
    targets: [
   	  Target(name: "ProofKitLib"),
      Target(name: "PetrinetLib", dependencies: ["ProofKitLib"]),
    ],
    dependencies: [
        .Package(url: "https://github.com/kyouko-taiga/LogicKit",
                 majorVersion: 0),
    ]
)

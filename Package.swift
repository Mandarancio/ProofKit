import PackageDescription

let package = Package(
    name: "ProofKit",
    targets: [
   	  Target(name: "ProofKitLib"),
      Target(name: "ProofKitDemo2", dependencies:["ProofKitLib"]),
 		  Target(name: "ProofKitDemo", dependencies: ["ProofKitLib"]),
 		  Target(name: "EqProofDemo", dependencies: ["ProofKitLib"]),
      Target(name: "ADTDemo", dependencies: ["ProofKitLib"]),
      Target(name: "PetrinetLib", dependencies: ["ProofKitLib"]),
      Target(name: "PetrinetDemo", dependencies: ["ProofKitLib", "PetrinetLib"]),
    ],
    dependencies: [
        .Package(url: "https://github.com/kyouko-taiga/LogicKit",
                 majorVersion: 0),
    ]
)

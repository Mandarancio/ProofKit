import PackageDescription

let package = Package(
    name: "Demo",
    targets: [
   	   Target(name: "GoalDemo"),
 		  Target(name: "ProofKitDemo"),
 		  Target(name: "EqProofDemo"),
      Target(name: "ADTDemo"),
      Target(name: "PetrinetDemo"),
    ],
    dependencies: [
        .Package(url: "https://github.com/kyouko-taiga/LogicKit",
                 majorVersion: 0),
        .Package(url: "https://github.com/Dexter9313/ProofKit.git",
                 majorVersion: 0),
    ]
)

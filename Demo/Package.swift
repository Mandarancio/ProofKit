import PackageDescription

let package = Package(
    name: "Demo",
    targets: [
   	   Target(name: "GoalDemo"),
 		  Target(name: "ProofKitDemo"),
 		  Target(name: "EqProofDemo"),
      Target(name: "ADTDemo"),
    ],
    dependencies: [
        .Package(url: "https://github.com/kyouko-taiga/LogicKit",
                 majorVersion: 0),
        .Package(url: "https://github.com/Mandarancio/ProofKit",
                 majorVersion: 0),
    ]
)

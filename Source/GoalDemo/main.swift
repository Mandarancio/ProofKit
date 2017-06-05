import LogicKit
import ProofKitLib

let x = Variable(named: "x")
let y = Variable(named: "y")
let z = Variable(named: "z")

let op = Nat.lt(Nat.add(x, y), Nat.n(9))
print(ADTm.pprint(op))

// retrive all x,y such that x+y<9
let goal = Nat.belong(x) && Nat.belong(y) && ADTm.geval(operation: op, result: z) && z === Boolean.True()

for sol in solve(goal){
  let rsol = sol.reified()
  print(" ------")
  print(" x: \(ADTm.pprint(rsol[x]))")
  print(" y: \(ADTm.pprint(rsol[y]))")
}

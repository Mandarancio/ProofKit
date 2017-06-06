import LogicKit
import ProofKitLib

let x = Variable(named: "x")
let y = Variable(named: "y")
let z = Variable(named: "z")

let op = Nat.lt(Nat.add(x, y), Nat.n(9))
print(ADTm.pprint(op))

// x,y in Nat such that (x+y) < 9
let goal = Nat.belong(x) && Nat.belong(y) && ADTm.geval(operation: op, result: z) && z === Boolean.True()

var counter = 0
for sol in solve(goal){
  if counter >= 10{
    break
  }
  let rsol = sol.reified()
  print(" --\(counter+1)--")
  print(" x: \(ADTm.pprint(rsol[x]))")
  print(" y: \(ADTm.pprint(rsol[y]))")
  counter += 1

}

// simple test with Set
let sop = Nat.lt(Set.size(x), Nat.n(12))
// x in Set such that size(x)<8
let lgoal = Set.belong(x) && z === Boolean.True() && ADTm.geval(operation: sop, result: z)
counter = 0
print(ADTm.pprint(sop))
for sol in solve(lgoal){
  if counter >= 10{
    break
  }
  let rsol = sol.reified()
  print(" --\(counter+1)--")
  print(" x: \(ADTm.pprint(rsol[x]))")
  counter += 1
}
print("Done")

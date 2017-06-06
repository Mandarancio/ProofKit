import LogicKit
import ProofKitLib

let x = Variable(named: "x")
let y = Variable(named: "y")
let z = Variable(named: "z")



print(" ====== NET ======")
print(ADTm.pprint((x + y) == Nat.n(6) && x < y))
// x,y in Nat such that (x + y) = 6 && x < y
let goal = x ∈ Nat.self &&  y ∈ Nat.self && (x+y) => Nat.n(6) && (x<y) => Boolean.True()
print()
var counter = 0
for sol in solve(goal){
  let rsol = sol.reified()
  print("\(counter+1) >> x: \(ADTm.pprint(rsol[x])), y: \(ADTm.pprint(rsol[y]))")
  counter += 1
  if counter >= 3{
    break
  }
}
print("\n ====== SET ======")
print(ADTm.pprint(Set.size(x) < Nat.n(8)))
// simple test with Set
// x in Set such that size(x)<8
let lgoal = x ∈ Set.self && (Set.size(x) < Nat.n(8)) => Boolean.True()
counter = 0
print()
for sol in solve(lgoal){
  if counter >= 10{
    break
  }
  let rsol = sol.reified()
  print("\(counter+1) >> x: \(ADTm.pprint(rsol[x]))")
  counter += 1
}
print("Done")

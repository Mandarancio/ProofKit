import LogicKit
import ProofKitLib

let x = Variable(named: "x")
let y = Variable(named: "y")

print(" ====== NET ======")
print(ADTm.pprint((x + y) == Nat.n(6) && x < y))
// x,y in Nat such that (x + y) = 6 && x < y
let goal = x ∈ Nat.self &&  y ∈ Nat.self => (x+y) <-> Nat.n(6) && (x<y) <-> Boolean.True()
print()
for sol in solve(goal).prefix(3){
  let rsol = sol.reified()
  print(" >> x: \(ADTm.pprint(rsol[x])), y: \(ADTm.pprint(rsol[y]))")
}
print("\n ====== SET ======")
print(ADTm.pprint(Set.size(x) < Nat.n(8)))
// simple test with Set
// x in Set such that size(x)<8
let lgoal = x ∈ Set.self => (Set.size(x) < Nat.n(8)) <-> Boolean.True()
print()
for sol in solve(lgoal).prefix(8){
  let rsol = sol.reified()
  print(" >> x: \(ADTm.pprint(rsol[x]))")
}
print("Done")

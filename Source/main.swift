import LogicKit

var bool = Boolean()
var nat = Nat()

var l = LList.insert(Nat.n(4),LList.insert(Nat.n(2),LList.empty()))
print(l)
var g = LList.belong(l)
for s in solve(g){
  for (t,v) in s.reified().prefix(10){
      print(" * \(t) \(v)")
  }
}
let x = Variable(named: "x")
let o = nat.o("+")(Nat.n(2), Nat.n(1))
print(o)
g = nat.a("+")[1].applay(o,x)
for s in solve(g){
  for (t,v) in s.reified().prefix(10){
      print(" * \(t) \(v)")
  }
}

import LogicKit

var bool = Boolean()

var nat = Nat()
let x = Variable(named: "x")
let o = nat.o("+")(Nat.n(2), Nat.n(1))
print(o)
let g = nat.a("+")[1].applay(o,x)
for s in solve(g){
  for (t,v) in s.reified().prefix(10){
      print(" * \(t) \(v)")
  }
}

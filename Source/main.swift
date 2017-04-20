import LogicKit



func print_ax(_ ax: [Rule]){
  var i = 0
  for a in ax{
    print(" \(i). \(a.pprint())")
    i += 1
  }
}

let llist = ADTs["llist"]

for o in llist.get_operators(){
  print("\nLList - \(o):")
  print_ax(llist.a(o))
}

let x = Variable(named: "x")
var res : Term

var k = LList.n([Nat.n(2),Nat.n(5),Nat.n(3), Nat.n(1),Nat.n(4)])
var exists = ADTs["llist"]["contains"](k,Nat.n(1))
res = ADTs.eval(exists)//resolve(exists, contains)
print("\n \(ADTs.pprint(exists)) = \(ADTs.pprint(res))")

var l0 = LList.n([Nat.n(1),Nat.n(3), Nat.n(8)])
var l1 = LList.n([Nat.n(7),Nat.n(5)])
var l2 = LList.concat(l1,l0)

res = ADTs.eval(l2)
print(" \(ADTs.pprint(l2)) => \(ADTs.pprint(res))")

l0 = LList.size(LList.n([Nat.n(1),Nat.n(3),Nat.n(4)]))
res = ADTs.eval(l0)
print(" \(ADTs.pprint(l0)) => \(ADTs.pprint(res))")

let o = ADTs["nat"]["+"](Nat.n(2), Nat.n(3))
for i in ADTs["nat"].get_operators(){
  print("\nnat - \(i):")
  print_ax( ADTs["nat"].a(i))
}
res = ADTs.eval(o)
print("\n \(ADTs.pprint(o)) => \(ADTs.pprint(res))")
l0 = ADTs["nat"]["*"](Nat.n(2),Nat.n(3))
res = ADTs.eval(l0)
print(" \(ADTs.pprint(l0)) => \(ADTs.pprint(res))")
print()

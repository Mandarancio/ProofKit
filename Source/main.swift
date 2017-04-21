import LogicKit

func print_ax(_ ax: [Rule]){
  var i = 0
  for a in ax{
    print(" \(i). \(a.pprint())")
    i += 1
  }
}

var res : Term


let a_set = ADTs["set"]
for o in a_set.get_operators(){
  print("\nSet - \(o):")
  print_ax(a_set.a(o))
}

var s0 = ADTs.eval(Set.n([Nat.n(2),Nat.n(4),Nat.n(2),Nat.n(1)]))
var s1 = ADTs.eval(Set.n([Nat.n(4),Nat.n(5),Nat.n(3),Nat.n(0),Nat.n(1)]))
var s3 = Set.union(s0,s1)
var s4 = Set.intersection(s0,s1)
var s5 = Set.diff(s1,s0)
var s6 = Set.subSet(s0, ADTs.eval(s3))

res = ADTs.eval(s3)
print("\n \(ADTs.pprint(s3)) => \(ADTs.pprint(res))")
res = ADTs.eval(s4)
print(" \(ADTs.pprint(s4)) => \(ADTs.pprint(res))")
res = ADTs.eval(s5)
print(" \(ADTs.pprint(s5)) => \(ADTs.pprint(res))")
res = ADTs.eval(s6)
print(" \(ADTs.pprint(s6)) => \(ADTs.pprint(res))")

let llist = ADTs["llist"]

for o in llist.get_operators(){
  print("\nLList - \(o):")
  print_ax(llist.a(o))
}


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
l0 = ADTs["nat"]["+"](ADTs["nat"]["*"](Nat.n(2),Nat.n(3)), o)
res = ADTs.eval(l0)
print(" \(ADTs.pprint(l0)) => \(ADTs.pprint(res))")
print()

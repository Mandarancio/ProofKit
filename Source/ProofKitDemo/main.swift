import LogicKit
import ProofKitLib

func print_ax(_ ax: [Rule]){
  for i in 0...ax.count-1{
    print(" \(i). \(ax[i])")
  }
}

var res : Term
let ADTs = ADTManager.instance()
let multiset = ADTs["multiset"]

for o in multiset.get_operators(){
  print("Multiset - \(o):")
  print_ax(multiset.a(o))
}
var k = Multiset.n([Nat.n(2),Nat.n(5),Nat.n(3), Nat.n(1),Nat.n(4)])
var exists = ADTs["multiset"]["contains"](k,Nat.n(1))
res = ADTs.eval(exists)//resolve(exists, contains)
print("\n \(ADTs.pprint(exists)) = \(ADTs.pprint(res))")

var l0 = Multiset.n([Nat.n(1),Nat.n(3), Nat.n(5), Nat.n(8)])
var l1 = Multiset.n([Nat.n(7),Nat.n(5)])
var l2 = Multiset.concat(l1,l0)

res = ADTs.eval(l2)
print(" \(ADTs.pprint(l2)) => \(ADTs.pprint(res))")

l0 = Multiset.size(l2)
res = ADTs.eval(l0)
print(" \(ADTs.pprint(l0)) => \(ADTs.pprint(res))")

let a_set = ADTs["set"]
for o in a_set.get_operators(){
  print("Set - \(o):")
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


let seq = ADTs["sequence"]
for i in seq.get_operators(){
  print("Sequence - \(i):")
  print_ax( seq.a(i))
}
s0 = ADTs.eval(Sequence.n([Nat.n(2), Nat.n(3), Nat.n(4)]))
s1 = Sequence.getAt(s0, Nat.n(1))
s3 = Sequence.setAt(s0, Nat.n(1), Nat.n(5))
print("\n s0: \(ADTs.pprint(s0))")
res = ADTs.eval(s1)
print(" \(ADTs.pprint(s1)) => \(ADTs.pprint(res))")
res = ADTs.eval(s3)
print(" \(ADTs.pprint(s3)) => \(ADTs.pprint(res))")

let o = ADTs["nat"]["+"](Nat.n(2), Nat.n(3))
for i in ADTs["nat"].get_operators(){
  print("Nat - \(i):")
  print_ax( ADTs["nat"].a(i))
}
res = ADTs.eval(o)
print("\n \(ADTs.pprint(o)) => \(ADTs.pprint(res))")
l0 = ADTs["nat"]["+"](ADTs["nat"]["*"](Nat.n(2),Nat.n(3)), o)
res = ADTs.eval(l0)
print(" \(ADTs.pprint(l0)) => \(ADTs.pprint(res))")
print()

let a = Integer.n(-2)
let b = Integer.n(2)
let c = Integer.add(a,b)
res = ADTs.eval(c)
print("\(ADTs.pprint(c)) => \(ADTs.pprint(res))")

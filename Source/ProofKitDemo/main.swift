import LogicKit
import ProofKitLib
import Foundation

//Date to milliseconds
func mills() -> Int {
    let currentDate = Date()
    let since1970 = currentDate.timeIntervalSince1970
    return Int(since1970 * 1000)
}


func print_ax(_ ax: [Rule]){
  for i in 0...ax.count-1{
    print(" \(i). \(ax[i])")
  }
}

let time = mills()

var res : Term
let multiset = ADTm["multiset"]

for o in multiset.get_operators(){
  print("Multiset - \(o):")
  print_ax(multiset.a(o))
}
var k = Multiset.n([Nat.n(2),Nat.n(5),Nat.n(3), Nat.n(1),Nat.n(4)])
var exists = ADTm["multiset"]["contains"](k,Nat.n(1))
res = ADTm.eval(exists)//resolve(exists, contains)
print("\n \(ADTm.pprint(exists)) = \(ADTm.pprint(res))")

var l0 = Multiset.n([Nat.n(1),Nat.n(3), Nat.n(5), Nat.n(8)])
var l1 = Multiset.n([Nat.n(7),Nat.n(5)])
var l2 = Multiset.concat(l1,l0)

res = ADTm.eval(l2)
print(" \(ADTm.pprint(l2)) => \(ADTm.pprint(res))")

l0 = Multiset.size(l2)
res = ADTm.eval(l0)
print(" \(ADTm.pprint(l0)) => \(ADTm.pprint(res))")

let a_set = ADTm["set"]
for o in a_set.get_operators(){
  print("Set - \(o):")
  print_ax(a_set.a(o))
}

var s0 = ADTm.eval(Set.n([Nat.n(2),Nat.n(4),Nat.n(2),Nat.n(1)]))
var s1 = ADTm.eval(Set.n([Nat.n(4),Nat.n(5),Nat.n(3),Nat.n(0),Nat.n(1)]))
var s3 = Set.union(s0,s1)
var s4 = Set.intersection(s0,s1)
var s5 = Set.diff(s1,s0)
var s6 = Set.subSet(s0, ADTm.eval(s3))

res = ADTm.eval(s3)
print("\n \(ADTm.pprint(s3)) => \(ADTm.pprint(res))")
res = ADTm.eval(s4)
print(" \(ADTm.pprint(s4)) => \(ADTm.pprint(res))")
res = ADTm.eval(s5)
print(" \(ADTm.pprint(s5)) => \(ADTm.pprint(res))")
res = ADTm.eval(s6)
print(" \(ADTm.pprint(s6)) => \(ADTm.pprint(res))")


let seq = ADTm["sequence"]
for i in seq.get_operators(){
  print("Sequence - \(i):")
  print_ax( seq.a(i))
}
s0 = ADTm.eval(Sequence.n([Nat.n(2), Nat.n(3), Nat.n(4)]))
s1 = Sequence.getAt(s0, Nat.n(1))
s3 = Sequence.setAt(s0, Nat.n(1), Nat.n(5))
print("\n s0: \(ADTm.pprint(s0))")
res = ADTm.eval(s1)
print(" \(ADTm.pprint(s1)) => \(ADTm.pprint(res))")
res = ADTm.eval(s3)
print(" \(ADTm.pprint(s3)) => \(ADTm.pprint(res))")

let o = ADTm["nat"]["+"](Nat.n(2), Nat.n(3))
for i in ADTm["nat"].get_operators(){
  print("Nat - \(i):")
  print_ax( ADTm["nat"].a(i))
}
res = ADTm.eval(o)
print("\n \(ADTm.pprint(o)) => \(ADTm.pprint(res))")
l0 = ADTm["nat"]["+"](ADTm["nat"]["*"](Nat.n(2),Nat.n(3)), o)
res = ADTm.eval(l0)
print(" \(ADTm.pprint(l0)) => \(ADTm.pprint(res))")
print()

let a = Integer.n(-2)
let b = Integer.n(2)
let c = Integer.add(a,b)
res = ADTm.eval(c)
print("\(ADTm.pprint(c)) => \(ADTm.pprint(res))")
print("time : \(mills()-time)ms")

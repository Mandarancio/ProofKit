import LogicKit
import ProofKitLib
let adtm = ADTManager.instance()
let a = Integer.n(5)
let b = Integer.n(3)
let c = Integer.add(a,b)
print("\(adtm.pprint(a)) + \(adtm.pprint(b))")
print(adtm.pprint(c))
let r = adtm.eval(c)
print(adtm.pprint(r))
print(r)
var l0 = Multiset.n([Nat.n(1),Nat.n(3), Nat.n(5), Nat.n(8)])
var l1 = Multiset.n([Nat.n(7),Nat.n(5)])
var l2 = Multiset.concat(l1,l0)
print(" \(adtm.pprint(l0))")
var res = adtm.eval(l2)
print(" \(adtm.pprint(l2)) => \(adtm.pprint(res))")
res = adtm.eval(Multiset.size(l2))
print(" \(adtm.pprint(res))")

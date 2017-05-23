import LogicKit
import ProofKitLib
let adtm = ADTManager.instance()
let a = Nat.n(5)
let b = Nat.n(3)
let c = Nat.add(a,b)
print("\(adtm.pprint(a)) + \(adtm.pprint(b))")
print(adtm.pprint(c))
let r = adtm.eval(c)
print(adtm.pprint(r))
print(adtm.tprint(r, " "))

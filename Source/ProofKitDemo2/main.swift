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
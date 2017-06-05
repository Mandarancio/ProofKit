import LogicKit
import ProofKitLib

// How to use your new ADT?
// Simple: you need the instance of the ADTManager class
var adtm = ADTManager.instance()
// Then you add your new adt to the manager
adtm["char"] = Char()
// now you can use it!

// Example:
let a = Char.a()
let b = Char.b()
var op = Char.eq(a, b)
var r = adtm.eval(op)
print("\(adtm.pprint(op)) => \(adtm.pprint(r))")

// Counter-Example:
op = Char.eq(a, a)
r = adtm.eval(op)
print("\(adtm.pprint(op)) => \(adtm.pprint(r))")

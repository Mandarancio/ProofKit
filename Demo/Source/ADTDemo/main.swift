import LogicKit
import ProofKit

// How to use your new ADT?
// Simple: you need the instance of the ADTManager class
// Then you add your new adt to the manager
ADTm["char"] = Char()
// now you can use it!

// Example:
let a = Char.a()
let b = Char.b()
var op = a == b
var r = ADTm.eval(op)
print("\(ADTm.pprint(op)) => \(ADTm.pprint(r))")

// Counter-Example:
op = a ==  a
r = ADTm.eval(op)
print("\(ADTm.pprint(op)) => \(ADTm.pprint(r))")

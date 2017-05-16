import LogicKit
import ProofKitLib

let adtm = ADTManager.instance()

print("Test Equational Proof Demo")


// transitivity
let t0 = Rule(Variable(named: "x"), Boolean.not(Boolean.not(Variable(named:"x"))))
let t1 = Rule(Boolean.not(Boolean.not(Variable(named:"w"))), Variable(named:"w"))
print(t0.pprint())
print(t1.pprint())
let t = Proof.transitivity(t0,t1)
print(t.pprint())
print(equivalence(t.lTerm, t.rTerm))

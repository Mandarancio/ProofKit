import LogicKit
import ProofKitLib

let adtm = ADTManager.instance()

print("Test Equational Proof Demo")


// transitivity
let t0 = Rule(Variable(named: "x"), Boolean.not(Boolean.not(Variable(named:"x"))))
let t1 = Proof.symmetry(t0)


let t = Proof.transitivity(t0,t1)

// AXIOMS
print(t0.pprint())
print(t1.pprint())
print(t.pprint())

// VARIABLES
print(t0.variables())
print(t1.variables())
print(t.variables())

print(equivalence(t.lTerm, t.rTerm))

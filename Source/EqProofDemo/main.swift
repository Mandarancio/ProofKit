import LogicKit
import ProofKitLib

let adtm = ADTManager.instance()

print("Test Equational Proof Demo")


// transitivity
let t0 = Rule(Variable(named: "x"), Boolean.not(Boolean.not(Variable(named:"x"))))
let t1 = Proof.symmetry(t0)


let t = Proof.transitivity(t0,t1)

// AXIOMS
print(t0)
print(t1)
print(t)

// VARIABLES
print(t0.variables())
print(t1.variables())
print(t.variables())

print(equivalence(t.lTerm(), t.rTerm()))

// induction

let ax0 = adtm["nat"].a("+")[0]
let ax1 = adtm["nat"].a("+")[1]

let conj = Rule(
  Nat.add(Nat.succ(x: Nat.zero()), Variable(named:"x")),
  Nat.succ(x: Variable(named: "x"))
)

/// Function for indcutive proof
func zero_proof(t: Rule...)->Rule{
  let ax0 = adtm["nat"].a("+")[0]
  // s(0)+0 = s(0)
  return Proof.substitution(ax0, Variable(named: "x"), Nat.succ(x: Nat.zero()))
}

func succ_proof(t: Rule...)->Rule{
  let ax1 = adtm["nat"].a("+")[1]
  // s(0) + s(y) = s(s(0) + y)
  let t2 = Proof.substitution(ax1, Variable(named: "x"), Nat.succ(x: Nat.zero()))
  // s(s(0) + x) = s(s(x))
  let t3 = Proof.substitutivity (Nat.succ, [t[0]])
  // s(0) + s(y) = s(s(y))
  return Proof.transitivity(t2, t3)
}

do {
  let teo = try Proof.inductive(conj, Variable(named: "x"), adtm["nat"], [
    "zero": zero_proof,
    "succ": succ_proof
  ])
  print("Indcutive result: \(teo)")
}
catch ProofError.InductionFail {
  print("Induction failed!")
}

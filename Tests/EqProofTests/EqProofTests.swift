import XCTest
import LogicKit
@testable import ProofKitLib

extension EqProofTests {
    static var allTests : [(String, (EqProofTests) -> () throws -> Void)] {
        return [
            ("testEquationalProof", testEquationalProof)
        ]
    }
}

class EqProofTests: XCTestCase {

  let adt : ADTManager = ADTManager.instance()

  internal func tassert(_ a: Term,_ b: Term){
    let msg = "\(adt.pprint(a)) == \(adt.pprint(b))"
    print(msg)
    XCTAssertTrue(adt.eval(a).equals(adt.eval(b)), msg)
  }

  internal func TAssert(_ a: Rule, _ b: Rule){
    let msg = "(\(a.pprint())) == (\(b.pprint()))"
    print(msg)
    XCTAssertTrue(a.equals(b),msg)
  }

  internal func FAssert(_ a: Rule, _ b: Rule){
    let msg = "(\(a.pprint())) != (\(b.pprint()))"
    print(msg)
    XCTAssertFalse(a.equals(b),msg)
  }

  override func setUp() {
    super.setUp()
   }

  func testEquationalProof(){
    let a_proof = Rule(Nat.add(Variable(named: "x"), Nat.zero()), Variable(named:"x"))
    let b_proof = Rule(Nat.add(Variable(named: "z"), Nat.zero()), Variable(named:"z"))
    let c_proof = Rule(Nat.add(Variable(named: "z"), Nat.succ(x: Variable(named:"y"))), Nat.succ(x: Nat.add(Variable(named:"z"), Variable(named: "y"))))
    self.TAssert(a_proof, b_proof)
    self.FAssert(a_proof, c_proof)
    // rifexivity
    print("can apply reflexivity")
    var t = Proof.reflexivity(Boolean.not(Variable(named: "x")))
    self.TAssert(t, Rule(Boolean.not(Variable(named: "y")),Boolean.not(Variable(named: "y"))))
    // simmetry
    print("can apply symmetry")
    t = Proof.symmetry(Rule(Boolean.True(), Boolean.not(Boolean.False())))
    self.TAssert(t, Rule(Boolean.not(Boolean.False()), Boolean.True()))
    // transitivity
    let t0 = Rule(Variable(named: "x"), Boolean.not(Boolean.not(Variable(named:"x"))))
    let t1 = Rule(Boolean.not(Boolean.not(Variable(named:"w"))), Variable(named:"w"))
    t = Proof.transitivity(t0,t1)
    print("can apply transitivity")
    self.TAssert(t, Rule(Variable(named:"x"), Variable(named:"x")))

    print("Can applay substitution")
    t = Proof.substitution(adt["nat"].a("+")[0], Variable(named:"x"), Nat.zero())
    self.TAssert(t, Rule(Nat.add(Nat.zero(), Nat.zero()), Nat.zero()))

    print("Can applay substitution")
    t = Proof.substitution(adt["nat"].a("+")[0], Variable(named:"x"), Nat.succ(x:Variable(named: "y")))
    self.TAssert(t, Rule(Nat.add(Nat.succ(x: Variable(named: "y")), Nat.zero()), Nat.succ(x: Variable(named: "y"))))

    print("Can applay substitutivity")
    t = Proof.substitutivity(Nat.add, [Nat.add(Nat.succ(x:Variable(named:"x")), Nat.n(0)),Nat.n(1)], [Nat.succ(x:Variable(named:"x")),Nat.n(1)])
    self.tassert(t.rTerm/t.rvariables(), Nat.add(Nat.succ(x:Variable(named: "x")), Nat.n(1)))
  }

}

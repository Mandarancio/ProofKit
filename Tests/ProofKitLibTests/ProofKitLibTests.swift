import XCTest
import LogicKit
@testable import ProofKitLib

extension ProofKitLibTests {
    static var allTests : [(String, (ProofKitLibTests) -> () throws -> Void)] {
        return [
            ("testBool", testBool),
            ("testNat", testNat),
            ("testEquationalProof", testEquationalProof)
        ]
    }
}

class ProofKitLibTests: XCTestCase {
  let adt : ADTManager = ADTManager.instance()

  internal func TAssert(_ a: Term,_ b: Term){
    let msg = "\(adt.pprint(a)) == \(adt.pprint(b))"
    print(msg)
    XCTAssertTrue(adt.eval(a).equals(adt.eval(b)), msg)
  }

  internal func FAssert(_ a: Term,_ b: Term){
    let msg = "\(adt.pprint(a)) != \(adt.pprint(b))"
    print(msg)
    XCTAssertFalse(adt.eval(a).equals(adt.eval(b)),msg)
  }

  internal func tTAssert(_ a: Rule, _ b: Rule){
    let msg = "(\(a.pprint())) == (\(b.pprint()))"
    print(msg)
    XCTAssertTrue(a.equals(b),msg)
  }

  internal func tFAssert(_ a: Rule, _ b: Rule){
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
    self.tTAssert(a_proof, b_proof)
    self.tFAssert(a_proof, c_proof)
    // rifexivity
    print("can apply reflexivity")
    var t = Proof.reflexivity(Boolean.not(Variable(named: "x")))
    self.tTAssert(t, Rule(Boolean.not(Variable(named: "y")),Boolean.not(Variable(named: "y"))))
    // simmetry
    print("can apply symmetry")
    t = Proof.symmetry(Rule(Boolean.True(), Boolean.not(Boolean.False())))
    self.tTAssert(t, Rule(Boolean.not(Boolean.False()), Boolean.True()))
    // transitivity
    let t0 = Rule(Variable(named: "x"), Boolean.not(Boolean.not(Variable(named:"x"))))
    let t1 = Rule(Boolean.not(Boolean.not(Variable(named:"w"))), Variable(named:"w"))
    t = Proof.transitivity(t0,t1)
    self.tTAssert(t, Rule(Variable(named:"x"), Variable(named:"x")))

  }

  func testBool(){
    // true != false
    self.FAssert(Boolean.True(),Boolean.False())
    // not true == false
    self.TAssert(Boolean.not(Boolean.True()), Boolean.False())
    // not false == true
    self.TAssert(Boolean.not(Boolean.False()), Boolean.True())
    // true and true == true
    self.TAssert(Boolean.and(Boolean.True(), Boolean.True()),Boolean.True())
    // true and false == false
    self.TAssert(Boolean.and(Boolean.True(), Boolean.False()),Boolean.False())
    // false and true == false
    self.TAssert(Boolean.and(Boolean.False(), Boolean.True()),Boolean.False())
    // false and false == false
    self.TAssert(Boolean.and(Boolean.False(), Boolean.False()),Boolean.False())
    // true or true == true
    self.TAssert(Boolean.or(Boolean.True(), Boolean.True()),Boolean.True())
    // true or false == true
    self.TAssert(Boolean.or(Boolean.True(), Boolean.False()),Boolean.True())
    // false or true == true
    self.TAssert(Boolean.or(Boolean.False(), Boolean.True()),Boolean.True())
    // false or false == false
    self.TAssert(Boolean.or(Boolean.False(), Boolean.False()),Boolean.False())
  }

  func testNat() {
    // x + 0 == x
    self.TAssert(Nat.add(Nat.n(5),Nat.zero()),Nat.n(5))
    // 3 + 2 = 5
    self.TAssert(Nat.add(Nat.n(3),Nat.n(2)), Nat.n(5))
    // 3*0 = 0
    self.TAssert(Nat.mul(Nat.n(3),Nat.zero()),Nat.zero())
    // 3*1 = 1
    self.TAssert(Nat.mul(Nat.n(3),Nat.n(1)),Nat.n(3))
    // 3*2 = 6
    self.TAssert(Nat.mul(Nat.n(3),Nat.n(2)),Nat.n(6))
  }

  func testBunch(){
    //////////////
  }
}

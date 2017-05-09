import XCTest
import LogicKit
@testable import ProofKitLib

extension ProofKitLibTests {
    static var allTests : [(String, (ProofKitLibTests) -> () throws -> Void)] {
        return [
            ("testBool", testBool),
            ("testNat", testNat),
            ("testInt", testInt),
            ("testEquationalProof", testEquationalProof),
            ("testMultiset", testMultiset)
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
    // not Fase = True == True
    self.TAssert(Boolean.eq(Boolean.True(), Boolean.not(Boolean.False())),Boolean.True())
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
    // pre(5) = 4
    self.TAssert(Nat.pre(Nat.n(5)),Nat.n(4))
    // 5-2 = 3
    self.TAssert(Nat.sub(Nat.n(5),Nat.n(2)),Nat.n(3))
    // 3<5 = true
    self.TAssert(Nat.lt(Nat.n(3),Nat.n(5)), Boolean.True())
    // 5<3 = false
    self.TAssert(Nat.lt(Nat.n(5),Nat.n(3)), Boolean.False())
    // 3<3 = false
    self.TAssert(Nat.lt(Nat.n(3),Nat.n(3)), Boolean.False())
    // 7>2 = true
    self.TAssert(Nat.gt(Nat.n(7),Nat.n(2)), Boolean.True())
    // 2>7 = false
    self.TAssert(Nat.gt(Nat.n(2),Nat.n(7)), Boolean.False())
    // 7>7 = false
    self.TAssert(Nat.gt(Nat.n(7),Nat.n(7)), Boolean.False())
    // 10==10 = true
    self.TAssert(Nat.eq(Nat.n(10),Nat.n(10)), Boolean.True())
    // 10==9 = false
    self.TAssert(Nat.eq(Nat.n(10),Nat.n(9)), Boolean.False())
    //9==10 = false
    self.TAssert(Nat.eq(Nat.n(9),Nat.n(10)), Boolean.False())
    //mod(20,3) = 2
    self.TAssert(Nat.mod(Nat.n(20),Nat.n(3)), Nat.n(2))
    //mod(0,5) = 0
    self.TAssert(Nat.mod(Nat.n(0),Nat.n(5)), Nat.n(0))
    //gcd(20,0) = 20
    self.TAssert(Nat.gcd(Nat.n(20),Nat.n(0)), Nat.n(20))
    //gcd(20,16) = 4
    self.TAssert(Nat.gcd(Nat.n(20),Nat.n(16)), Nat.n(4))
    //div(10/0) = vFail
    self.TAssert(Nat.div(Nat.n(10),Nat.n(0)), vFail)
    //div(22/5) = 4
    self.TAssert(Nat.div(Nat.n(22),Nat.n(5)), Nat.n(4))
  }

  func testInt(){

  }

  func testMultiset(){
    //////////////
    var b1 = Multiset.n([Nat.n(1), Nat.n(2),Nat.n(4)])
    var b2 = Multiset.n([Nat.n(4), Nat.n(2),Nat.n(1)])
    // [1,2,4] === [4,2,1]
    self.TAssert(Multiset.eq(b1,b2), Boolean.True())
    // [1,2,4] removeOne 1 !== [4,2,1]
    self.FAssert(Multiset.eq(Multiset.removeOne(b1,Nat.n(1)),b2),Boolean.True())
    // [1,2,4] contains 1
    self.TAssert(Multiset.contains(b1, Nat.n(1)),Boolean.True())
    b1 = Multiset.n([Nat.n(1),Nat.n(1),Nat.n(2),Nat.n(4)])
    b2 = Multiset.n([Nat.n(2),Nat.n(4)])
    // [1,1,2,4] removeAll 1 === [2,4]
    self.TAssert(Multiset.removeAll(b1,Nat.n(1)),b2)
  }

}

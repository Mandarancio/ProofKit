import XCTest
import LogicKit
@testable import ProofKitLib

extension ProofKitLibTests {
    static var allTests : [(String, (ProofKitLibTests) -> () throws -> Void)] {
        return [
            ("testBool", testBool),
            ("testNat", testNat)
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


  override func setUp() {
    super.setUp()
   }

  func testBool(){
    /*print(adt.eval(Boolean.not(Boolean.not(Boolean.not(Boolean.True())))))

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
    self.TAssert(Boolean.or(Boolean.False(), Boolean.False()),Boolean.False())*/
  }

  func testNat() {
    let test = adt["nat"]["+"](Boolean.True(),Boolean.False())
    print(test)
    print(adt.eval(test))/*
    // x + 0 == x
    self.TAssert(Nat.add(Nat.n(5),Nat.zero()),Nat.n(5))
    // 3 + 2 = 5
    self.TAssert(Nat.add(Nat.n(3),Nat.n(2)), Nat.n(5))
    // 3*0 = 0
    self.TAssert(Nat.mul(Nat.n(3),Nat.zero()),Nat.zero())
    // 3*1 = 1
    self.TAssert(Nat.mul(Nat.n(3),Nat.n(1)),Nat.n(3))
    // 3*2 = 6
    self.TAssert(Nat.mul(Nat.n(3),Nat.n(2)),Nat.n(6))*/
  }

  func testBunch(){
    //////////////
  }
}

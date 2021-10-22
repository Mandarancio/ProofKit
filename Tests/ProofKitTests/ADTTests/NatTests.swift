import XCTest
import SwiftKanren
import ProofKit

class NatTests: XCTestCase {
  
  internal func TAssert(_ a: Term,_ b: Term){
    let msg = "\(ADTm.pprint(a)) == \(ADTm.pprint(b))"
    print(msg)
    XCTAssertTrue(ADTm.eval(a).equals(ADTm.eval(b)), msg)
  }
  
  internal func FAssert(_ a: Term,_ b: Term){
    let msg = "\(ADTm.pprint(a)) != \(ADTm.pprint(b))"
    print(msg)
    XCTAssertFalse(ADTm.eval(a).equals(ADTm.eval(b)),msg)
  }
  
  func testNatAdd() {
    // 5 + 0 == 5
    self.TAssert(Nat.add(Nat.n(5),Nat.zero()),Nat.n(5))
    // 3 + 2 = 5
    self.TAssert(Nat.add(Nat.n(3),Nat.n(2)), Nat.n(5))
  }
  
  func testNatMul() {
    // 3*0 = 0
    self.TAssert(Nat.mul(Nat.n(3),Nat.zero()),Nat.zero())
    // 3*1 = 1
    self.TAssert(Nat.mul(Nat.n(3),Nat.n(1)),Nat.n(3))
    // 3*2 = 6
    self.TAssert(Nat.mul(Nat.n(3),Nat.n(2)),Nat.n(6))
  }
  
  func testNatSub() {
    // 0-3 = 0
    self.TAssert(Nat.sub(Nat.n(0), Nat.n(3)), Nat.n(0))
    // 5-2 = 3
    self.TAssert(Nat.sub(Nat.n(5),Nat.n(2)),Nat.n(3))
  }
  
  func testNatLt() {
    // 0<0 = false
    self.TAssert(Nat.lt(Nat.n(0),Nat.n(0)), Boolean.False())
    // 3<5 = true
    self.TAssert(Nat.lt(Nat.n(3),Nat.n(5)), Boolean.True())
    // 5<3 = false
    self.TAssert(Nat.lt(Nat.n(5),Nat.n(3)), Boolean.False())
    // 3<3 = false
    self.TAssert(Nat.lt(Nat.n(3),Nat.n(3)), Boolean.False())
  }
  
  func testNatGt() {
    // 0>0 = false
    self.TAssert(Nat.gt(Nat.n(0),Nat.n(0)), Boolean.False())
    // 7>2 = true
    self.TAssert(Nat.gt(Nat.n(7),Nat.n(2)), Boolean.True())
    // 2>7 = false
    self.TAssert(Nat.gt(Nat.n(2),Nat.n(7)), Boolean.False())
    // 7>7 = false
    self.TAssert(Nat.gt(Nat.n(7),Nat.n(7)), Boolean.False())
  }
  
  func testNatEq() {
    // 0 == 0 = true
    self.TAssert(Nat.eq(Nat.n(0),Nat.n(0)), Boolean.True())
    // 10==10 = true
    self.TAssert(Nat.eq(Nat.n(10),Nat.n(10)), Boolean.True())
    // 10==9 = false
    self.TAssert(Nat.eq(Nat.n(10),Nat.n(9)), Boolean.False())
    // 9==10 = false
    self.TAssert(Nat.eq(Nat.n(9),Nat.n(10)), Boolean.False())
  }
  
  func testNatMod() {
    // mod(5,0) = vFail
    self.TAssert(Nat.mod(Nat.n(5),Nat.n(0)), vFail)
    // mod(20,3) = 2
    self.TAssert(Nat.mod(Nat.n(20),Nat.n(3)), Nat.n(2))
    // mod(0,5) = 0
    self.TAssert(Nat.mod(Nat.n(0),Nat.n(5)), Nat.n(0))
  }
  
  func testNatGcd() {
    // gcd(0,5) = 5
    self.TAssert(Nat.gcd(Nat.n(0),Nat.n(5)), vFail)
    // gcd(20,0) = 20
    self.TAssert(Nat.gcd(Nat.n(20),Nat.n(0)), vFail)
    // gcd(20,16) = 4
    self.TAssert(Nat.gcd(Nat.n(20),Nat.n(16)), Nat.n(4))
    // gcd(10,10) = 10
    self.TAssert(Nat.gcd(Nat.n(10), Nat.n(10)), Nat.n(10))
  }
  
  func testNatDiv() {
    // div(5,5) = 1
    self.TAssert(Nat.div(Nat.n(5),Nat.n(5)), Nat.n(1))
    // div(10/0) = vFail
    self.TAssert(Nat.div(Nat.n(10),Nat.n(0)), vFail)
    // div(22/5) = 4
    self.TAssert(Nat.div(Nat.n(22),Nat.n(5)), Nat.n(4))
  }
 
  static var allTests = [
    ("testNatAdd", testNatAdd),
    ("testNatMul", testNatMul),
    ("testNatSub", testNatSub),
    ("testNatLt", testNatLt),
    ("testNatGt", testNatGt),
    ("testNatEq", testNatEq),
    ("testNatMod", testNatMod),
    ("testNatGcd", testNatGcd),
    ("testNatDiv", testNatDiv),
  ]
}

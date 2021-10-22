import XCTest
import SwiftKanren
import ProofKit

class IntTests: XCTestCase {
  
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
  
  func testIntNormalize() {
    //normalize((5,10)) = (0,5)
    var integer1 = Integer.int(Nat.n(5), Nat.n(10))
    let integer2 = Integer.int(Nat.n(2), Nat.n(4))
    self.TAssert(Integer.normalize(integer1), Integer.n(-5))
    //normalize(10,5) = (5,0)
    integer1 = Integer.int(Nat.n(10), Nat.n(5))
    self.TAssert(Integer.normalize(integer1), Integer.n(5))
    //normalize((1,3)*(2,4)) = 4
    integer1 = Integer.int(Nat.n(1), Nat.n(3))
    self.TAssert(Integer.normalize(Integer.mul(integer1, integer2)), Integer.n(4))
  }
  
  func testIntAdd(){
    // (3,0)+(2,0) = (5,0)
    self.TAssert(Integer.add(Integer.n(3),Integer.n(2)), Integer.n(5))
    // (3,0)+(0,5) = (0,2)
    self.TAssert(Integer.normalize(Integer.add(Integer.n(3),Integer.n(-5))), Integer.n(-2))
  }
  
  func testIntSub() {
    //(7,0)-(0,5) = (12,0)
    var integer1 = Integer.int(Nat.n(7), Nat.n(0))
    var integer2 = Integer.int(Nat.n(0), Nat.n(5))
    self.TAssert(Integer.normalize(Integer.sub(integer1, integer2)), Integer.n(12))
    //(3,6)-(2,4) = 4
    integer1 = Integer.int(Nat.n(3), Nat.n(6))
    integer2 = Integer.int(Nat.n(2), Nat.n(4))
    self.TAssert(Integer.normalize(Integer.sub(integer1, integer2)), Integer.n(-1))
  }
 
  func testIntAbs() {
    // abs(3) = 3
    var integer1 = Integer.int(Nat.n(4), Nat.n(1))
    self.TAssert(Integer.abs(integer1), Nat.n(3))
    // abs(-3) = 3
    integer1 = Integer.int(Nat.n(1), Nat.n(4))
    self.TAssert(Integer.abs(integer1), Nat.n(3))
  }
  
  func testIntEq() {
    //((1,0) == (1,0)) = true
    self.TAssert(Integer.eq(Integer.n(1), Integer.n(1)), Boolean.True())
    //((1,0) == (0,1)) = false
    self.TAssert(Integer.eq(Integer.n(1), Integer.n(-1)), Boolean.False())
    //(6,2)==(5,1) = true
    let integer1 = Integer.int(Nat.n(6), Nat.n(2))
    let integer2 = Integer.int(Nat.n(5), Nat.n(1))
    self.TAssert(Integer.eq(integer1, integer2), Boolean.True())
  }
  
  func testIntLt() {
    // (0,0) < (0,0) = false
    self.TAssert(Integer.lt(Integer.n(0), Integer.n(0)), Boolean.False())
    //(7,5) < (4,1) = true
    let integer1 = Integer.int(Nat.n(7), Nat.n(5))
    let integer2 = Integer.int(Nat.n(5), Nat.n(1))
    self.TAssert(Integer.lt(integer1, integer2), Boolean.True())
    //(4,1) < (7,5) = false
    self.TAssert(Integer.lt(integer2, integer1), Boolean.False())
  }
  
  func testIntGt(){
    // (0,0) > (0,0) = false
    self.TAssert(Integer.gt(Integer.n(0), Integer.n(0)), Boolean.False())
    //(7,5) > (4,1) = false
    let integer1 = Integer.int(Nat.n(7), Nat.n(5))
    let integer2 = Integer.int(Nat.n(5), Nat.n(1))
    self.TAssert(Integer.gt(integer1, integer2), Boolean.False())
    //(4,1) > (7,5) = true
    self.TAssert(Integer.gt(integer2, integer1), Boolean.True())
  }
  
  func testIntSign(){
    //sign(0,0) = true
    self.TAssert(Integer.sign(Integer.n(0)), Boolean.True())
    //sign(6,2) = true
    var integer1 = Integer.int(Nat.n(6), Nat.n(2))
    self.TAssert(Integer.sign(integer1), Boolean.True())
    //sign(2,6) = false
    integer1 = Integer.int(Nat.n(2), Nat.n(6))
    self.TAssert(Integer.sign(integer1), Boolean.False())
  }
  
  func testIntDiv() {
    var integer1 = Integer.int(Nat.n(5), Nat.n(5))
    var integer2 = Integer.int(Nat.n(4), Nat.n(2))
    //(5,0) / (5,5) = vFail
    self.TAssert(Integer.div(Integer.n(5), integer1), vFail)
    // (0,0) / (0,10) = (0,0)
    self.TAssert(Integer.div(Integer.n(0), Integer.n(-10)), Integer.n(0))
    //(10,5) / (4,2) = 2
    integer1 = Integer.int(Nat.n(10), Nat.n(5))
    self.TAssert(Integer.div(integer1, integer2), Integer.n(2))
    //(6,2) / (1,4) = (0,1)
    integer1 = Integer.int(Nat.n(6), Nat.n(2))
    integer2 = Integer.int(Nat.n(1), Nat.n(4))
    self.TAssert(Integer.div(integer1, integer2), Integer.n(-1))
  }
  
  static var allTests = [
    ("testIntNormalize", testIntNormalize),
    ("testIntAdd", testIntAdd),
    ("testIntSub", testIntSub),
    ("testIntAbs", testIntAbs),
    ("testIntEq", testIntEq),
    ("testIntLt", testIntLt),
    ("testIntGt", testIntGt),
    ("testIntSign", testIntSign),
    ("testIntDiv", testIntDiv),
  ]
}

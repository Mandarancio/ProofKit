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
    XCTAssertTrue(adt.eval(a).equals(adt.eval(b)))
  }

  internal func FAssert(_ a: Term,_ b: Term){
    XCTAssertFalse(adt.eval(a).equals(adt.eval(b)))
  }


  override func setUp() {
    super.setUp()
   }
  func testBool(){

  }
  func testNat() {
    // 1+1 == 2
    self.TAssert(Nat.add(Nat.n(1),Nat.n(1)),Nat.n(2))
    // (1+2)+1 == 1+(2+1)
    self.TAssert(Nat.add(Nat.add(Nat.n(1),Nat.n(2)),Nat.n(1)), Nat.add(Nat.n(1),Nat.add(Nat.n(2),Nat.n(1))))
    // (1+3) != (1+2)
    self.FAssert(Nat.add(Nat.n(1),Nat.n(3)),Nat.add(Nat.n(1),Nat.n(2)))
  }
}

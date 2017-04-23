import XCTest
import LogicKit
@testable import ProofKitLib

extension ProofKitLibTests {
    static var allTests : [(String, (ProofKitLibTests) -> () throws -> Void)] {
        return [
            ("testNat", testNat)
        ]
    }
}

class ProofKitLibTests: XCTestCase {
//  var adt : ProofKit.ADTManager = ProofKit.ADTs

  override func setUp() {
    super.setUp()

   }

  func testNat() {
  	print(Nat.zero())
  	//print(Nat.add(Nat.n(1),Nat.n(2)))
    // XCTAssertEqual(adt.eval(Nat.add(Nat.n(1),Nat.n(1))),Nat.n(2))
  }
}

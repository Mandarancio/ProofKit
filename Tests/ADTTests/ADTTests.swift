import XCTest
import LogicKit
@testable import ProofKit

class ADTTests : XCTestCase {
    func testExample() {
        let a = Nat.zero()
        let g = a === Variable(named: "x")
        for s in solve(g){
          for (t,v) in s{
            print(" \(t) \(v)")
          }
        }
    }


    static var allTests : [(String, (ADTTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}

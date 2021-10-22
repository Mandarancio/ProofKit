import XCTest
import SwiftKanren
import ProofKit

extension ADTTests {
  static var allTests : [(String, (ADTTests) -> () throws -> Void)] {
    return [
      ("testMultiset", testMultiset)
    ]
  }
}

class ADTTests: XCTestCase {
  
  
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

import XCTest
import SwiftKanren
import ProofKit

class MultiSetTests: XCTestCase {
  
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
  
  func testMultiSetEq() {
    // ({} == {}) = true
    self.TAssert(Multiset.eq(Multiset.empty(), Multiset.empty()), Boolean.True())
    let b1 = Multiset.n([Nat.n(1), Nat.n(2),Nat.n(4), Nat.n(1)])
    var b2 = Multiset.n([Nat.n(4), Nat.n(2),Nat.n(1), Nat.n(1)])
    // [1,1,2,4] === [4,2,1,1]
    self.TAssert(Multiset.eq(b1,b2), Boolean.True())
    b2 = Multiset.n([Nat.n(4), Nat.n(2),Nat.n(1)])
    // ({1,2,4,1} == {4,2,1}) = false
    self.TAssert(Multiset.eq(b1,b2), Boolean.False())
  }
  
  func testMultiSetRemoveOne() {
    let b1 = Multiset.n([Nat.n(1), Nat.n(2),Nat.n(4)])
    var b2 = Multiset.n([Nat.n(4), Nat.n(2),Nat.n(1)])
    // [1,2,4] removeOne 1 !== [4,2,1]
    self.TAssert(Multiset.eq(Multiset.removeOne(b1,Nat.n(1)),b2), Boolean.False())
    b2 = Multiset.n([Nat.n(4), Nat.n(2)])
    // (removeOne({1,2,4},1) == {4,2}) = true
    self.TAssert(Multiset.eq(Multiset.removeOne(b1,Nat.n(1)),b2), Boolean.True())
    // (removeOne({},0) == {}) = true
    self.TAssert(Multiset.eq(Multiset.removeOne(Multiset.empty(), Nat.zero()), Multiset.empty()), Boolean.True())
    // (removeOne({1,2,4},42 == {1,2,4}) = true
    self.TAssert(Multiset.eq(Multiset.removeOne(b1,Nat.n(42)),b1), Boolean.True())
  }
  
  func testMultiSetRemoveAll() {
    let b1 = Multiset.n([Nat.n(1), Nat.n(2),Nat.n(4), Nat.n(1)])
    let b2 = Multiset.n([Nat.n(2),Nat.n(4)])
    // (removeAll({1,2,4,1},1) == {4,2}) = true
    self.TAssert(Multiset.eq(Multiset.removeAll(b1,Nat.n(1)),b2), Boolean.True())
    // (removeAll({1,2,4,1},42) == {1,2,4,1}) = true
    self.TAssert(Multiset.eq(Multiset.removeAll(b1,Nat.n(42)),b1), Boolean.True())
    // (removeAll({},1) == {}) = true
    self.TAssert(Multiset.eq(Multiset.removeAll(Multiset.empty(),Nat.n(1)),Multiset.empty()),Boolean.True())
  }
  
  func testMultiSetContains() {
    let b1 = Multiset.n([Nat.n(1), Nat.n(2),Nat.n(4), Nat.n(1)])
    // contains({1,2,4,1}, 1) = true
    self.TAssert(Multiset.contains(b1, Nat.n(1)), Boolean.True())
    // contains({1,2,4,1}, 2) = true
    self.TAssert(Multiset.contains(b1, Nat.n(2)), Boolean.True())
    // contains({1,2,4,1}, 42) = false
    self.TAssert(Multiset.contains(b1, Nat.n(42)), Boolean.False())
    // contains({}, 1) = false
    self.TAssert(Multiset.contains(Multiset.empty(), Nat.n(1)), Boolean.False())
  }
  
  func testMultiSetConcat() {
    let b1 = Multiset.n([Nat.n(1), Nat.n(2),Nat.n(4)])
    let b2 = Multiset.n([Nat.n(4), Nat.n(2),Nat.n(1), Nat.n(4), Nat.n(2),Nat.n(1)])
    // (concat({1,2,4}, {1,2,4}) == {4,2,1,4,2,1}) = true
    self.TAssert(Multiset.eq(Multiset.concat(b1, b1), b2), Boolean.True())
    // (concat({1,2,4}, {}) == {1,2,4}) = true
    self.TAssert(Multiset.eq(Multiset.concat(b1, Multiset.empty()), b1), Boolean.True())
    // (concat({}, {1,2,4}) == {1,2,4}) = true
    self.TAssert(Multiset.eq(Multiset.concat(Multiset.empty(), b1), b1), Boolean.True())
  }
   
  static var allTests = [
    ("testMultiSetEq", testMultiSetEq),
    ("testMultiSetRemoveOne", testMultiSetRemoveOne),
    ("testMultiSetRemoveAll", testMultiSetRemoveAll),
    ("testMultiSetContains", testMultiSetContains),
    ("testMultiSetConcat", testMultiSetConcat),
  ]
}

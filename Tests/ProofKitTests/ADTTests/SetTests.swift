import XCTest
import SwiftKanren
import ProofKit

class SetTests: XCTestCase {
  
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
  
  // Need to test set equal
  func testSetContains() {
    let s1 = Set.n([Nat.n(1), Nat.n(10)])
    // Contains
    // contains({1,10}, 10) = True
    self.TAssert(Set.contains(s1, Nat.n(10)), Boolean.True())
    // contains({1,10}, 99) = False
    self.TAssert(Set.contains(s1, Nat.n(99)), Boolean.False())
    // contains({}, 4) = False
    self.TAssert(Set.contains(Set.empty(), Nat.n(4)), Boolean.False())
  }
  
  // Need to test set equal
  func testSetRemoveOne() {
    let s1 = Set.n([Nat.n(1), Nat.n(10)])
    let s2 = Set.n([Nat.n(1)])
    // removeOne({1,10}, 10) = {1}
    self.TAssert(Set.removeOne(s1, Nat.n(10)), s2)
    // removeOne({1}, 1) = {}
    self.TAssert(Set.removeOne(s2, Nat.n(1)), Set.empty())
    // removeOne({}, 1) = {}
    self.TAssert(Set.removeOne(Set.empty(), Nat.n(1)), Set.empty())
  }

  // Test operator equal (Need for testSet)
  func testSetEqual(){
    let s1 = Set.n([Nat.n(1), Nat.n(2), Nat.n(10)])
    let s2 = Set.n([Nat.n(1), Nat.n(2)])
    let s3 = Set.n([Nat.n(1), Nat.n(10), Nat.n(2)])
    
    self.TAssert(Set.eq(Set.empty(), s1), Boolean.False())
    self.TAssert(Set.eq(s1, Set.empty()), Boolean.False())
    self.TAssert(Set.eq(s1, s1), Boolean.True())
    self.TAssert(Set.eq(s1, s2), Boolean.False())
    self.TAssert(Set.eq(s1, s3), Boolean.True())
    self.TAssert(Set.eq(Set.empty(), Set.empty()), Boolean.True())
  }
  
  // ------------------------------------------------------------------- //
  // ----- The next tests need that set equal works to be tested ! ------//
  // ------------------------------------------------------------------- //
  
  func testSetInsert() {
    let s1 = Set.n([Nat.n(1), Nat.n(2), Nat.n(4), Nat.n(10)])
    let s2 = Set.n([Nat.n(1), Nat.n(2)])
    // Insert
    // insert(10, {1,2}) = {1, 2, 10}
    self.TAssert(Set.eq(Set.insert(Nat.n(10), s2), Set.n([Nat.n(10), Nat.n(1), Nat.n(2)])), Boolean.True())
    // insert(2, {}) = {2}
    self.TAssert(Set.eq(Set.insert(Nat.n(2), Set.empty()), Set.n([Nat.n(2)])), Boolean.True())
    // insert(10, {1, 2, 4, 10}) = {1, 2, 4, 10}
    self.TAssert(Set.insert(Nat.n(10), s1), s1)
  }
  
  func testSetUnion() {
    let s1 = Set.n([Nat.n(1), Nat.n(2), Nat.n(4), Nat.n(10)])
    let s2 = Set.n([Nat.n(1), Nat.n(2)])
    let s3 = Set.n([Nat.n(20), Nat.n(30)])
    let s4 = Set.n([Nat.n(1), Nat.n(2), Nat.n(20), Nat.n(30)])
    
    // union({}, {1,2}) = {1,2}
    self.TAssert(Set.eq(Set.union(Set.empty(), s2), s2), Boolean.True())
    // union({1,2}, {}) = {1,2}
    self.TAssert(Set.eq(Set.union(s2, Set.empty()), s2), Boolean.True())
    // union({1,2,4,10}, {1,2}) = {1,2,4,10}
    self.TAssert(Set.eq(Set.union(s1,s2), s1), Boolean.True())
    // union({1,2},{20,30}) = {1,2,20,30}
    self.TAssert(Set.eq(Set.union(s2,s3), s4), Boolean.True())
  }
  
  func testSetIntersection() {
    let s1 = Set.n([Nat.n(1), Nat.n(2), Nat.n(4), Nat.n(10)])
    let s2 = Set.n([Nat.n(1), Nat.n(2)])
    let s3 = Set.n([Nat.n(20), Nat.n(30)])
    
    // intersection({},{1,2}) = {}
    self.TAssert(Set.eq(Set.intersection(Set.empty(),s2), Set.empty()), Boolean.True())
    // intersection({1,2},{}) = {}
    self.TAssert(Set.eq(Set.intersection(s2,Set.empty()), Set.empty()), Boolean.True())
    // intersection({1,2,4,10}, {1,2}) = {1,2}
    self.TAssert(Set.eq(Set.intersection(s1,s2), s2), Boolean.True())
    // intersection({1,2},{20,30}) = {}
    self.TAssert(Set.eq(Set.intersection(s2,s3), Set.empty()), Boolean.True())
  }
  
  func testSetDifference() {
    let s1 = Set.n([Nat.n(1), Nat.n(2), Nat.n(4), Nat.n(10)])
    let s2 = Set.n([Nat.n(1), Nat.n(2)])
    let s3 = Set.n([Nat.n(20), Nat.n(30)])
    
    // diff({1,2,4,10}, {1,2}) = {4,10}
    self.TAssert(Set.eq(Set.diff(s1,s2), Set.n([Nat.n(4), Nat.n(10)])), Boolean.True())
    // diff({1,2},{20,30}) = {1,2}
    self.TAssert(Set.eq(Set.diff(s2,s3), s2), Boolean.True())
    // diff({}, {1,2}) = {}
    self.TAssert(Set.eq(Set.diff(Set.empty(), s2), Set.empty()), Boolean.True())
  }
  
  func testSetSubSet() {
    let s1 = Set.n([Nat.n(1), Nat.n(2), Nat.n(4), Nat.n(10)])
    let s2 = Set.n([Nat.n(1), Nat.n(2)])
    
    // subSet({1,2}, {1,2,4,10}) = True
    self.TAssert(Set.subSet(s2,s1), Boolean.True())
    // subSet({},{1,2,4,10}) = True
    self.TAssert(Set.subSet(Set.empty(), s1), Boolean.True())
    // subSet({}, {1,2}) = False
    self.TAssert(Set.subSet(s1, Set.empty()), Boolean.False())
  }
  
  func testSetSize() {
    let s1 = Set.n([Nat.n(1), Nat.n(2)])
    // size({1,2}) = 2
    self.TAssert(Set.size(s1), Nat.n(2))
    // size({}) = 0
    self.TAssert(Set.size(Set.empty()), Nat.zero())
  }
   
  static var allTests = [
    ("testSetContains", testSetContains),
    ("testSetRemoveOne", testSetRemoveOne),
    ("testSetEqual", testSetEqual),
    ("testSetInsert", testSetInsert),
    ("testSetUnion", testSetUnion),
    ("testSetIntersection", testSetIntersection),
    ("testSetDifference", testSetDifference),
    ("testSetSubSet", testSetSubSet),
    ("testSetSize", testSetSize),
  ]
}

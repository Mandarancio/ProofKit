import XCTest
import SwiftKanren
import ProofKit

class SequenceTests: XCTestCase {
  
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
  
  func testSequencePush() {
    let s1 = Sequence.push(Nat.n(42), Sequence.push(Nat.n(10), Sequence.empty()))
    TAssert(s1, Sequence.n([Nat.n(10), Nat.n(42)]))
  }
  
  func testSequenceGetAt() {
    let s1 = Sequence.n([Nat.n(10), Nat.n(42), Nat.n(3)])
    // getAt([10,42,3], 2) = 3
    TAssert(Sequence.getAt(s1, Nat.n(2)), Nat.n(3))
    // getAt([10,42,3], 5) = fail
    TAssert(Sequence.getAt(s1, Nat.n(5)), vFail)
  }
  
  func testSequenceSetAt() {
    let s1 = Sequence.n([Nat.n(10), Nat.n(42), Nat.n(3)])
    let s2 = Sequence.n([Nat.n(10), Nat.n(5), Nat.n(3)])
    TAssert(Sequence.setAt(s1, Nat.n(1), Nat.n(5)), s2)
    TAssert(Sequence.setAt(s1, Nat.n(5), Nat.n(100)), s1)
  }
  
  func testSequenceSize() {
    // size(empty) = 0
    TAssert(Sequence.size(Sequence.empty()), Nat.zero())
    // size(cons(7, 0, cons(42, 1, cons(10, 2, empty)))) = 3
    let s = Sequence.n([Nat.n(7), Nat.n(42), Nat.n(10)])
    TAssert(Sequence.size(s), Nat.n(3))
  }
  
  static var allTests = [
    ("testSequencePush", testSequencePush),
    ("testSequenceGetAt", testSequenceGetAt),
    ("testSequenceSetAt", testSequenceSetAt),
    ("testSequenceSize", testSequenceSize),
  ]
}

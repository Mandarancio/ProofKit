import XCTest
import LogicKit
@testable import ProofKit

extension ADTTests {
  static var allTests : [(String, (ADTTests) -> () throws -> Void)] {
    return [
      ("testBool", testBool),
      ("testNat", testNat),
      ("testInt", testInt),
      ("testSetNeedForEqual", testSetNeedForEqual),
      ("testSetEqual", testSetEqual),
      ("testSet", testSet),
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
  
  
  override func setUp() {
    super.setUp()
  }
  
  func testBool(){
    // true != false
    self.FAssert(Boolean.True(),Boolean.False())
    // not true == false
    self.TAssert(Boolean.not(Boolean.True()), Boolean.False())
    // not Fase = True == True
    self.TAssert(Boolean.eq(Boolean.True(), Boolean.not(Boolean.False())),Boolean.True())
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
    self.TAssert(Boolean.or(Boolean.False(), Boolean.False()),Boolean.False())
  }
  
  func testNat() {
    // x + 0 == x
    self.TAssert(Nat.add(Nat.n(5),Nat.zero()),Nat.n(5))
    // 3 + 2 = 5
    self.TAssert(Nat.add(Nat.n(3),Nat.n(2)), Nat.n(5))
    // 3*0 = 0
    self.TAssert(Nat.mul(Nat.n(3),Nat.zero()),Nat.zero())
    // 3*1 = 1
    self.TAssert(Nat.mul(Nat.n(3),Nat.n(1)),Nat.n(3))
    // 3*2 = 6
    self.TAssert(Nat.mul(Nat.n(3),Nat.n(2)),Nat.n(6))
    // pre(5) = 4
    self.TAssert(Nat.pre(Nat.n(5)),Nat.n(4))
    // 5-2 = 3
    self.TAssert(Nat.sub(Nat.n(5),Nat.n(2)),Nat.n(3))
    // 3<5 = true
    self.TAssert(Nat.lt(Nat.n(3),Nat.n(5)), Boolean.True())
    // 5<3 = false
    self.TAssert(Nat.lt(Nat.n(5),Nat.n(3)), Boolean.False())
    // 3<3 = false
    self.TAssert(Nat.lt(Nat.n(3),Nat.n(3)), Boolean.False())
    // 7>2 = true
    self.TAssert(Nat.gt(Nat.n(7),Nat.n(2)), Boolean.True())
    // 2>7 = false
    self.TAssert(Nat.gt(Nat.n(2),Nat.n(7)), Boolean.False())
    // 7>7 = false
    self.TAssert(Nat.gt(Nat.n(7),Nat.n(7)), Boolean.False())
    // 10==10 = true
    self.TAssert(Nat.eq(Nat.n(10),Nat.n(10)), Boolean.True())
    // 10==9 = false
    self.TAssert(Nat.eq(Nat.n(10),Nat.n(9)), Boolean.False())
    // 9==10 = false
    self.TAssert(Nat.eq(Nat.n(9),Nat.n(10)), Boolean.False())
    // mod(20,3) = 2
    self.TAssert(Nat.mod(Nat.n(20),Nat.n(3)), Nat.n(2))
    // mod(0,5) = 0
    self.TAssert(Nat.mod(Nat.n(0),Nat.n(5)), Nat.n(0))
    // gcd(20,0) = 20
    self.TAssert(Nat.gcd(Nat.n(20),Nat.n(0)), Nat.n(20))
    // gcd(20,16) = 4
    self.TAssert(Nat.gcd(Nat.n(20),Nat.n(16)), Nat.n(4))
    // div(10/0) = vFail
    self.TAssert(Nat.div(Nat.n(10),Nat.n(0)), vFail)
    // div(22/5) = 4
    self.TAssert(Nat.div(Nat.n(22),Nat.n(5)), Nat.n(4))
  }
  
  func testInt(){
    // (3,0)+(2,0) = +5
    self.TAssert(Integer.add(Integer.n(3),Integer.n(2)), Integer.n(5))
    //(3,6)-(2,4) = 4
    var a : Term = Nat.n(3)
    var b : Term = Nat.n(6)
    var c : Term = Nat.n(2)
    var d : Term = Nat.n(4)
    var integer1 = Integer.int(a,b)
    var integer2 = Integer.int(c,d)
    self.TAssert(Integer.normalize(Integer.sub(integer1, integer2)), Integer.n(-1))
    // abs(3) = 3
    a = Nat.n(4)
    b = Nat.n(1)
    integer1 = Integer.int(a, b)
    self.TAssert(Integer.abs(integer1), Nat.n(3))
    // abs(-3) = 3
    a = Nat.n(1)
    b = Nat.n(4)
    integer1 = Integer.int(a, b)
    self.TAssert(Integer.abs(integer1), Nat.n(3))
    //normalize((5,10)) = (0,5)
    a = Nat.n(5)
    b = Nat.n(10)
    integer1 = Integer.int(a,b)
    integer2 = Integer.int(Nat.zero(), a)
    self.TAssert(Integer.normalize(integer1), integer2)
    //normalize((1,3)*(2,4)) = 4
    a = Nat.n(1)
    b = Nat.n(3)
    c = Nat.n(2)
    d = Nat.n(4)
    integer1 = Integer.int(a, b)
    integer2 = Integer.int(c, d)
    self.TAssert(Integer.normalize(Integer.mul(integer1, integer2)), Integer.n(4))
    //(6,2)==(5,1) = true
    a = Nat.n(6)
    b = Nat.n(2)
    c = Nat.n(5)
    d = Nat.n(1)
    integer1 = Integer.int(a, b)
    integer2 = Integer.int(c, d)
    self.TAssert(Integer.eq(integer1, integer2), Boolean.True())
    //(7,5) < (4,1) = true
    a = Nat.n(7)
    b = Nat.n(5)
    c = Nat.n(5)
    d = Nat.n(1)
    integer1 = Integer.int(a, b)
    integer2 = Integer.int(c, d)
    self.TAssert(Integer.lt(integer1, integer2), Boolean.True())
    //(10,5) > (4,1) = true
    a = Nat.n(10)
    b = Nat.n(5)
    c = Nat.n(5)
    d = Nat.n(1)
    integer1 = Integer.int(a, b)
    integer2 = Integer.int(c, d)
    self.TAssert(Integer.gt(integer1, integer2), Boolean.True())
    //(10,5) / (4,2) = 2
    a = Nat.n(10)
    b = Nat.n(5)
    c = Nat.n(4)
    d = Nat.n(2)
    integer1 = Integer.int(a, b)
    integer2 = Integer.int(c, d)
    self.TAssert(Integer.div(integer1, integer2), Integer.n(2))
    //sign(6,2) = true
    a = Nat.n(6)
    b = Nat.n(2)
    integer1 = Integer.int(a,b)
    self.TAssert(Integer.sign(integer1), Boolean.True())
    //sign(2,6) = false
    a = Nat.n(2)
    b = Nat.n(6)
    integer1 = Integer.int(a,b)
    self.TAssert(Integer.sign(integer1), Boolean.False())
    //(6,2) / (1,4) = -1
    a = Nat.n(6)
    b = Nat.n(2)
    c = Nat.n(1)
    d = Nat.n(4)
    integer1 = Integer.int(a, b)
    integer2 = Integer.int(c, d)
    self.TAssert(Integer.div(integer1, integer2), Integer.n(-1))
  }
  
  func testSetNeedForEqual(){
    // Functions are needed for Set.eq
    
    let s1 = Set.n([Nat.n(1), Nat.n(10)])
    let s2 = Set.n([Nat.n(1)])
    
    // Contains
    self.TAssert(Set.contains(s1, Nat.n(10)), Boolean.True())
    self.TAssert(Set.contains(s1, Nat.n(99)), Boolean.False())
    self.TAssert(Set.contains(Set.empty(), Nat.n(4)), Boolean.False())

    //removeOne
    self.TAssert(Set.removeOne(s1, Nat.n(10)), s2)
    self.TAssert(Set.removeOne(s2, Nat.n(1)), Set.empty())
    self.TAssert(Set.removeOne(Set.empty(), Nat.n(1)), Set.empty())
    self.TAssert(Set.removeOne(s1, Set.empty()), s1)
    
  }
  
  func testSetEqual(){
    // Test operator equal for
    
    let s1 = Set.n([Nat.n(1), Nat.n(2), Nat.n(10)])
    let s2 = Set.n([Nat.n(1), Nat.n(2)])
    let s3 = Set.n([Nat.n(1), Nat.n(10), Nat.n(2)])
    
    // Control equal
    self.TAssert(Set.eq(Set.empty(), s1), Boolean.False())
    self.TAssert(Set.eq(s1, Set.empty()), Boolean.False())
    self.TAssert(Set.eq(s1, s1), Boolean.True())
    self.TAssert(Set.eq(s1, s2), Boolean.False())
    self.TAssert(Set.eq(s1, s3), Boolean.True())
    self.TAssert(Set.eq(Set.empty(), Set.empty()), Boolean.True())
    
  }
  
  func testSet(){
    // Need Set.eq to work !
    // We don't mind about order in a Set
    
    let s1 = Set.n([Nat.n(1), Nat.n(2), Nat.n(4), Nat.n(10)])
    let s2 = Set.n([Nat.n(1), Nat.n(2)])
    let s3 = Set.n([Nat.n(20), Nat.n(30)])
    let s4 = Set.n([Nat.n(1), Nat.n(2), Nat.n(20), Nat.n(30)])
    
    // Insert
    // insert(10, {1,2}) = {1, 2, 10}
    self.TAssert(Set.eq(Set.insert(Nat.n(10), s2), Set.n([Nat.n(10), Nat.n(1), Nat.n(2)])), Boolean.True())
    // insert(2, {}) = {2}
    self.TAssert(Set.eq(Set.insert(Nat.n(2), Set.empty()), Set.n([Nat.n(2)])), Boolean.True())
    // insert(10, {1, 2, 4, 10}) = {1, 2, 4, 10}
    self.TAssert(Set.insert(Nat.n(10), s1), s1)

    // Union
    // union({1,2,4,10}, {1,2}) = {1,2,4,10}
    self.TAssert(Set.eq(Set.union(s1,s2), s1), Boolean.True())
    // union({1,2},{20,30}) = {1,2,20,30}
    self.TAssert(Set.eq(Set.union(s2,s3), s4), Boolean.True())
    
    // Intersection
    // intersection({1,2,4,10}, {1,2}) = {1,2}
    self.TAssert(Set.eq(Set.intersection(s1,s2), s2), Boolean.True())
    // intersection({1,2},{20,30}) = {}
    self.TAssert(Set.eq(Set.intersection(s2,s3), Set.empty()), Boolean.True())
    
    // Difference
    // diff({1,2,4,10}, {1,2}) = {4,10}
    self.TAssert(Set.eq(Set.diff(s1,s2), Set.n([Nat.n(4), Nat.n(10)])), Boolean.True())
    // diff({1,2},{20,30}) = {1,2}
    self.TAssert(Set.eq(Set.diff(s2,s3), s2), Boolean.True())
    // diff({}, {1,2}) = {}
    self.TAssert(Set.eq(Set.diff(Set.empty(), s2), Set.empty()), Boolean.True())
    
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

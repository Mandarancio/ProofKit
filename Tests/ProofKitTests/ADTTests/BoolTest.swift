import XCTest
import SwiftKanren
import ProofKit

class BoolTests: XCTestCase {
  
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
  
  func testBoolNot(){
    // true != false
    self.FAssert(Boolean.True(),Boolean.False())
    // not true == false
    self.TAssert(Boolean.not(Boolean.True()), Boolean.False())
    // not false == true
    self.TAssert(Boolean.not(Boolean.False()), Boolean.True())
  }
  
  func testBoolEq() {
    // (True = True) == True
    self.TAssert(Boolean.eq(Boolean.True(), Boolean.True()),Boolean.True())
    // (False = False) == True
    self.TAssert(Boolean.eq(Boolean.False(), Boolean.False()),Boolean.True())
    // (True = False) == False
    self.TAssert(Boolean.eq(Boolean.True(), Boolean.False()),Boolean.False())
    // (False = True) == False
    self.TAssert(Boolean.eq(Boolean.False(), Boolean.True()),Boolean.False())
    // (not(False) = True) == True
    self.TAssert(Boolean.eq(Boolean.True(), Boolean.not(Boolean.False())),Boolean.True())
  }
  
  func testBoolAnd() {
    // true and true == true
    self.TAssert(Boolean.and(Boolean.True(), Boolean.True()),Boolean.True())
    // true and false == false
    self.TAssert(Boolean.and(Boolean.True(), Boolean.False()),Boolean.False())
    // false and true == false
    self.TAssert(Boolean.and(Boolean.False(), Boolean.True()),Boolean.False())
    // false and false == false
    self.TAssert(Boolean.and(Boolean.False(), Boolean.False()),Boolean.False())
  }
  
  func testBoolOr() {
    // true or true == true
    self.TAssert(Boolean.or(Boolean.True(), Boolean.True()),Boolean.True())
    // true or false == true
    self.TAssert(Boolean.or(Boolean.True(), Boolean.False()),Boolean.True())
    // false or true == true
    self.TAssert(Boolean.or(Boolean.False(), Boolean.True()),Boolean.True())
    // false or false == false
    self.TAssert(Boolean.or(Boolean.False(), Boolean.False()),Boolean.False())
  }
  
   
  static var allTests = [
    ("testBoolNot", testBoolNot),
    ("testBoolEq", testBoolEq),
    ("testBoolAnd", testBoolAnd),
    ("testBoolOr", testBoolOr),
  ]
}

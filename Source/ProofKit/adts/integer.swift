import SwiftKanren
import Foundation

public class Integer: ADT{
  public init(){
    super.init("int")
    self.add_generator("int", Integer.int)
    self.add_operator("normalize", Integer.normalize, [
      Rule(
        Integer.normalize(Integer.int(Nat.zero(), Variable(named: "x"))),
        Integer.int(Nat.zero(), Variable(named: "x"))
      ),
      Rule(
        Integer.normalize(Integer.int(Variable(named: "x"), Nat.zero())),
        Integer.int(Variable(named: "x"), Nat.zero())
      ),
      Rule(
        Integer.normalize(Integer.int(Nat.succ(Variable(named: "x")), Nat.succ(Variable(named: "y")))),
        Integer.normalize(Integer.int(Variable(named: "x"), Variable(named: "y")))
      )
    ], ["int"])
    self.add_operator("+", Integer.add, [
      Rule(
        Integer.add(
          Integer.int(Variable(named: "a"),Variable(named: "b")),
          Integer.int(Variable(named: "c"),Variable(named: "d"))
        ),
        Integer.int(
          Nat.add(Variable(named: "a"),Variable(named: "c")),
          Nat.add(Variable(named: "b"),Variable(named: "d"))
        )
      )
    ], ["int", "int"])
    self.add_operator("-", Integer.sub, [
      Rule(
        Integer.sub(
          Integer.int(Variable(named: "a"),Variable(named: "b")),
          Integer.int(Variable(named: "c"),Variable(named: "d"))
        ),
        Integer.int(
          Nat.add(Variable(named: "a"),Variable(named: "d")),
          Nat.add(Variable(named: "b"),Variable(named: "c"))
        )
      )
    ], ["int", "int"])

    self.add_operator("abs", Integer.abs, [
      Rule(
        Integer.abs(
          Integer.int(Variable(named: "a"),Variable(named: "b"))
        ),
        Nat.sub(Variable(named: "b"),Variable(named: "a")),
        Nat.lt(Variable(named: "a"), Variable(named: "b"))
      ),
      Rule(
        Integer.abs(
          Integer.int(Variable(named: "a"),Variable(named: "b"))
        ),
        Nat.sub(Variable(named: "a"),Variable(named: "b"))
      )
    ], ["int"])
    self.add_operator("*", Integer.mul, [
      Rule(
        Integer.mul(
          Integer.int(Variable(named: "a"),Variable(named: "b")),
          Integer.int(Variable(named: "c"),Variable(named: "d"))
        ),
        Integer.int(
          Nat.add(
            Nat.mul(Variable(named: "a"),Variable(named: "c")),
            Nat.mul(Variable(named: "b"),Variable(named: "d"))
          ),
          Nat.add(
            Nat.mul(Variable(named: "a"),Variable(named: "d")),
            Nat.mul(Variable(named: "b"),Variable(named: "c"))
          )
        )
      )
    ], ["int", "int"])
    self.add_operator("==", Integer.eq, [
      Rule(
        Integer.eq(
          Integer.int(Variable(named: "a"),Variable(named: "b")),
          Integer.int(Variable(named: "c"),Variable(named: "d"))
        ),
        Boolean.and(
          Boolean.eq(
            Integer.abs(
              Integer.int(Variable(named: "a"),Variable(named: "b"))
            ),
            Integer.abs(
              Integer.int(Variable(named: "c"),Variable(named: "d"))
            )
          ),
          Boolean.eq(
            Integer.sign(
              Integer.int(Variable(named: "a"),Variable(named: "b"))
            ),
            Integer.sign(
              Integer.int(Variable(named: "c"),Variable(named: "d"))
            )
          )
        )
      )
    ], ["int", "int"])
    self.add_operator("<", Integer.lt, [
      Rule(
        Integer.lt(
          Integer.int(Variable(named: "a"),Variable(named: "b")),
          Integer.int(Variable(named: "c"),Variable(named: "d"))
        ),
        Boolean.eq(
          Nat.lt(
            Nat.add(Variable(named: "a"), Variable(named: "d")),
            Nat.add(Variable(named: "b"), Variable(named: "c"))
          ),
          Boolean.True()
        )
      )
    ], ["int", "int"])
    self.add_operator(">", Integer.gt, [
      Rule(
        Integer.gt(
          Integer.int(Variable(named: "a"),Variable(named: "b")),
          Integer.int(Variable(named: "c"),Variable(named: "d"))
        ),
        Boolean.eq(
          Nat.gt(
            Nat.add(Variable(named: "a"), Variable(named: "d")),
            Nat.add(Variable(named: "b"), Variable(named: "c"))
          ),
          Boolean.True()
        )
      )
    ], ["int", "int"])
    self.add_operator("sign", Integer.sign, [
      Rule(
        Integer.sign(Integer.int(Variable(named: "a"), Variable(named: "a"))),
        Boolean.True()
      ),
      Rule(
        Integer.sign(
          Integer.int(Variable(named: "a"),Variable(named: "b"))
        ),
        Nat.gt(
          Variable(named: "a"),
          Variable(named: "b")
        )
      )
    ], ["int"])
    //Condition for the division is a simple xor which verify
    //a < b xor c < d
    self.add_operator("/", Integer.div, [
      Rule(
        Integer.div(Variable(named: "x"), Variable(named: "y")),
        vFail,
        Integer.eq(Integer.n(0), Integer.normalize(Variable(named: "y")))
      ),
      Rule(
        Integer.div(
          Integer.int(Variable(named: "a"),Variable(named: "b")),
          Integer.int(Variable(named: "c"),Variable(named: "d"))
        ),
        Integer.int(
          Nat.zero(),
          Nat.div(
            Integer.abs(
              Integer.int(
                Variable(named: "a"),
                Variable(named: "b")
              )
            ),
            Integer.abs(
              Integer.int(
                Variable(named: "c"),
                Variable(named: "d")
              )
            )
          )
        ),
        Boolean.and(
          Boolean.or(
            Nat.lt(
              Variable(named: "a"),
              Variable(named: "b")
            ),
            Nat.lt(
              Variable(named: "c"),
              Variable(named: "d")
            )
          ),
          Boolean.not(
            Boolean.and(
              Nat.lt(
                Variable(named: "a"),
                Variable(named: "b")
              ),
              Nat.lt(
                Variable(named: "c"),
                Variable(named: "d")
              )
            )
          )
        )
      ),
      Rule(
        Integer.div(
          Integer.int(Variable(named: "a"),Variable(named: "b")),
          Integer.int(Variable(named: "c"),Variable(named: "d"))
        ),
        Integer.int(
          Nat.div(
            Integer.abs(
              Integer.int(
                Variable(named: "a"),
                Variable(named: "b")
              )
            ),
            Integer.abs(
              Integer.int(
                Variable(named: "c"),
                Variable(named: "d")
              )
            )
          ),
          Nat.zero()
        )
      )
    ], ["int", "int"])
  }

  static public func int(_ x: Term...) -> Term {
    return new_term(Map(["a": x[0], "b":x[1]]),"int")
  }

  static public func n(_ x: Int) -> Term {
    let abs_x = Swift.abs(x)
    if x>0{
      return Integer.int(Nat.n(abs_x),Nat.zero())
    }
    return Integer.int(Nat.zero(),Nat.n(abs_x))
  }

  static public func to_int(_ term:Term) -> Int {
    if let map = (value(term) as? Map){
      if map["a"] != nil && map["b"] != nil {
        let pos = Nat.to_int(map["a"]!)
        let neg = Nat.to_int(map["b"]!)
        return pos-neg
      }
    }
    return 0
  }

  public static func to_string(_ term: Term) -> String {
    if let map = (value(term) as? Map){
      if map["a"] != nil && map["b"] != nil {
        let pos = Nat.to_string(map["a"]!)
        let neg = Nat.to_string(map["b"]!)
        return "Int(+:\(pos), -:\(neg))"
      }
    }
    return ""
  }

  public class override func belong(_ x: Term) -> Goal{
    return (delayed(fresh {y in fresh {z in x === Integer.int(y,z) && Nat.belong(y) && Nat.belong(z)}}))
  }

  public override func pprint(_ term: Term) -> String{
    if let map = (value(term) as? Map) {

      let a : Term = ADTm.eval(map["a"]!)
      let b : Term = ADTm.eval(map["b"]!)
      if type(a)=="nat" && type(b) == "nat"{
        if ADTm.eval(Nat.eq(a,b)).equals(Boolean.True()){
          return "0"
        }
        if ADTm.eval(Nat.gt(a,b)).equals(Boolean.True()){
          return "+\(ADTm.pprint(ADTm.eval(Nat.sub(a,b))))"
        }
        return "-\(ADTm.pprint(ADTm.eval(Nat.sub(b,a))))"
      }
      return "FAIL"
    }
    if let variable = (term as? Variable){
      return variable.description
    }
    return Nat.to_string(term)
  }

  static public func add(_ terms: Term...)->Term{
    return Operator.n("+",terms[0], terms[1])
  }
  static public func sub(_ terms: Term...)->Term{
    return Operator.n("-",terms[0], terms[1])
  }
  static public func abs(_ terms: Term...)->Term{
    return Operator.n("abs",terms[0])
  }
  static public func normalize(_ terms: Term...)->Term{
    return Operator.n("normalize",terms[0])
  }
  static public func mul(_ terms: Term...)->Term{
    return Operator.n("*",terms[0], terms[1])
  }
  static public func eq(_ terms: Term...)->Term{
    return Operator.n("==",terms[0], terms[1])
  }
  public static func lt(_ operands: Term...) -> Term{
    return Operator.n("<", operands[0], operands[1])
  }
  public static func gt(_ operands: Term...) -> Term{
    return Operator.n(">", operands[0], operands[1])
  }
  public static func div(_ operands: Term...) -> Term{
    return Operator.n("/", operands[0], operands[1])
  }
  public static func sign(_ operands: Term...) -> Term{
    return Operator.n("sign", operands[0])
  }

}

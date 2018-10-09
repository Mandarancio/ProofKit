import LogicKit
import Foundation

public class Nat: ADT{
  public init(){
    super.init("Nat")

    self.add_generator("zero", Nat.zero)
    self.add_generator("succ", Nat.succ,arity: 1)

    self.add_operator("+", Nat.add, [
      Rule(Nat.add(Variable(named: "x"), Nat.zero()),
                  Variable(named: "x")),
             Rule(Nat.add(Variable(named: "x"), Nat.succ(x: Variable(named: "y"))),
                  Nat.succ(x: Nat.add(Variable(named: "x"),Variable(named:"y"))))
    ],["nat", "nat"])
    self.add_operator("*", Nat.mul,[
      Rule(
        Nat.mul(Variable(named: "x"), Nat.zero()),
        Nat.zero()
      ),
      Rule(
        Nat.mul(Variable(named: "x"), Nat.succ(x: Variable(named: "y"))),
        Nat.add(Variable(named: "x"), Nat.mul(Variable(named: "x"), Variable(named: "y")))
      )
    ],["nat", "nat"])
    self.add_operator("pre", Nat.pre,[
      Rule(
        Nat.pre(Nat.zero()),
        Nat.zero()
      ),
      Rule(
        Nat.pre(Nat.succ(x: Variable(named: "x"))),
        Variable(named: "x")
      )
    ],["nat"])
    self.add_operator("-", Nat.sub,[
      Rule(
        Nat.sub(Variable(named: "x"), Nat.zero()),
        Variable(named: "x")
      ),
      Rule(
        Nat.sub(Nat.zero(), Variable(named: "x")),
        Nat.zero()
      ),
      Rule(
        Nat.sub(Variable(named: "x"), Nat.succ(x: Variable(named: "y"))),
        Nat.pre(Nat.sub(Variable(named: "x"), Variable(named: "y")))
      )
    ],["nat", "nat"])
    self.add_operator("<", Nat.lt,[
      Rule(
        Nat.lt(Variable(named: "x"), Nat.zero()),
        Boolean.False()
      ),
      Rule(
        Nat.lt(Nat.zero(), Variable(named: "x")),
        Boolean.True()
      ),
      Rule(
        Nat.lt(Nat.succ(x: Variable(named: "x")), Nat.succ(x: Variable(named: "y"))),
        Nat.lt(Variable(named: "x"), Variable(named: "y"))
      )
    ],["nat", "nat"])
    self.add_operator(">", Nat.gt,[
      Rule(
        Nat.gt(Nat.zero(), Variable(named: "x")),
        Boolean.False()
      ),
      Rule(
        Nat.gt(Variable(named: "x"), Nat.zero()),
        Boolean.True()
      ),
      Rule(
        Nat.gt(Nat.succ(x: Variable(named: "x")), Nat.succ(x: Variable(named: "y"))),
        Nat.gt(Variable(named: "x"), Variable(named: "y"))
      )
    ],["nat", "nat"])
    self.add_operator("==", Nat.eq,[
      Rule(
        Nat.eq(Nat.zero(), Nat.zero()),
        Boolean.True()
      ),
      Rule(
        Nat.eq(Variable(named: "x"), Nat.zero()),
        Boolean.False()
      ),
      Rule(
        Nat.eq(Nat.zero(), Variable(named: "x")),
        Boolean.False()
      ),
      Rule(
        Nat.eq(Nat.succ(x: Variable(named: "x")), Nat.succ(x:  Variable(named: "y"))),
        Nat.eq(Variable(named: "x"), Variable(named: "y"))
      )
    ],["nat", "nat"])
    self.add_operator("%", Nat.mod,[
      Rule(
        Nat.mod(Variable(named: "x"), Nat.zero()),
        vFail
      ),
      Rule(
        Nat.mod(Nat.zero(),  Variable(named: "x")),
        Nat.zero()
      ),
      Rule(
        Nat.mod(Variable(named: "x"), Variable(named: "y")),
        Variable(named: "x"),
        Nat.lt(Variable(named: "x"), Variable(named: "y"))
      ),
      Rule(
        Nat.mod(Variable(named: "x"), Variable(named: "y")),
        Nat.mod(Nat.sub(Variable(named: "x"), Variable(named: "y")), Variable(named: "y"))
      )
    ],["nat", "nat"])
    self.add_operator("gcd", Nat.gcd,[
      Rule(
        Nat.gcd(Variable(named: "x"), Variable(named: "y")),
        Variable(named: "x"),
        Nat.eq(Variable(named: "y"), Nat.zero())
      ),
      Rule(
        Nat.gcd(Variable(named: "x"), Variable(named: "y")),
        Variable(named: "y"),
        Nat.eq(Nat.mod(Variable(named: "x"), Variable(named: "y")), Nat.zero())
      ),
      Rule(
        Nat.gcd(Variable(named: "x"), Variable(named: "y")),
        Nat.gcd(Variable(named: "y"), Nat.mod(Variable(named: "x"), Variable(named: "y")))
      )
    ],["nat", "nat"])
    self.add_operator("/", Nat.div,[
      Rule(
        Nat.div(Variable(named: "x"), Nat.zero()),
        vFail
      ),
      Rule(
        Nat.div(Variable(named: "x"), Variable(named: "y")),
        Nat.zero(),
        Nat.lt(Variable(named: "x"), Variable(named: "y"))
      ),
      Rule(
        Nat.div(Variable(named: "x"), Variable(named: "y")),
        Nat.succ(
          x: Nat.div(
            Nat.sub(
              Variable(named: "x"),
              Variable(named: "y")
            ),
              Variable(named: "y")
          )
        ),
        Boolean.or(
          Nat.gt(Variable(named: "x"), Variable(named: "y")),
          Nat.eq(Variable(named: "x"), Variable(named: "y"))
        )

      )
    ],["nat", "nat"])
  }

  //Generator
  static public func zero(_:Term...) -> Term{
    return new_term(Value<Int>(0),"nat")
  }

  static public func succ(x: Term...) -> Term {
    return new_term(Map(["succ": x[0]]),"nat")
  }

  static public func n(_ x: Int) -> Term {
  	if x==0{
  		return Nat.zero()
  	}
    var t = Nat.zero()
  	for _ in 1..<x+1 {
  		t = Nat.succ(x: t)
  	}
    return t
  }

  static public func to_int(_ term:Term) -> Int {
    if let map = (value(term) as? Map){
      if map["succ"] != nil{
        let k = Nat.to_int(map["succ"]!)
        return k+1
      }
    }
    return 0
  }

  public class override func belong(_ x: Term) -> Goal{
    return (x === Nat.zero() || delayed(fresh {y in x === Nat.succ(x:y) && Nat.belong(y)}))
  }

  public override func pprint(_ term: Term) -> String{
    return Nat.to_string(term)
  }


  static public func to_string(_ x: Term) -> String{
   	if x.equals(Nat.zero()){
   		return "0"
   	}
   	if let map = (value(x) as? Map){
      if map["succ"] != nil{
        let k = Nat.to_string(map["succ"]!)
        let f = k.components(separatedBy:"+")
        if f.count == 0{
          return k
        }
        if f.count == 1{
          if let i = Int(k){
            return String(1+i)
          }
          return "succ(\(k))"
        }
        if f[0].count == 0 {
     		   return "succ("+f[1]+")"
        }
        if let i = (Int(f[0])){
          return String(1+i)+" + "+f[1]
        }
        return "succ(\(k))"
      }
      return ADTm.pprint(map)
   	}
    if x is Variable {
      return "+"+ADTm.pprint(x)
    }
   	return ADTm.pprint(x)
  }

  public static func add(_ operands: Term...) -> Term{
      return Operator.n("+",operands[0], operands[1])
  }
  public static func mul(_ operands: Term...)-> Term{
    return Operator.n("*",operands[0], operands[1])
  }
  public static func pre(_ operands: Term...) -> Term{
    return Operator.n("pre", operands[0])
  }
  public static func sub(_ operands: Term...) -> Term{
    return Operator.n("-", operands[0], operands[1])
  }
  public static func div(_ operands: Term...) -> Term{
    return Operator.n("/", operands[0], operands[1])
  }
  public static func mod(_ operands: Term...) -> Term{
    return Operator.n("%", operands[0], operands[1])
  }
  public static func lt(_ operands: Term...) -> Term{
    return Operator.n("<", operands[0], operands[1])
  }
  public static func gt(_ operands: Term...) -> Term{
    return Operator.n(">", operands[0], operands[1])
  }
  public class func eq(_ operands: Term...) -> Term{
    return Operator.n("==", operands[0], operands[1])
  }
  public class func gcd(_ operands: Term...) -> Term{
    return Operator.n("gcd", operands[0], operands[1])
  }
}


public class Integer: ADT{
  public init(){
    super.init("int")
    self.add_generator("int", Integer.int)
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
    self.add_operator("normalize", Integer.normalize, [
      Rule(
        Integer.normalize(
          Integer.int(Variable(named: "a"),Variable(named: "b"))
        ),
        Integer.int(Variable(named: "a"),Variable(named: "b")),
        Boolean.or(
          Nat.eq(Variable(named: "a"), Nat.zero()),
          Nat.eq(Variable(named: "b"), Nat.zero())
        )
      ),
      Rule(
        Integer.normalize(
          Integer.int(Variable(named: "a"),Variable(named: "b"))
        ),
        Integer.normalize(
          Integer.int(
            Nat.pre(Variable(named: "a")), Nat.pre(Variable(named: "b"))
          )
        )
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

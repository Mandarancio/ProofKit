import LogicKit
import Foundation

public class Nat: ADT{
  public init(){
    super.init("Nat")

    self.add_generator("zero", Nat.zero)
    self.add_generator("succ", Nat.succ,arity: 1)

    self.add_operator("+", Nat.add, [
      Rule(Nat.add(Variable(named: "x"), Value(0)),
                  Variable(named: "x")),
             Rule(Nat.add(Variable(named: "x"), Nat.succ(x: Variable(named: "y"))),
                  Nat.succ(x: Nat.add(Variable(named: "x"),Variable(named:"y"))))
    ])
    self.add_operator("*", Nat.mul,[
      Rule(
        Nat.mul(Variable(named: "*.0.$0"), Nat.zero()),
        Nat.zero()
      ),
      Rule(
        Nat.mul(Variable(named: "*.1.$0"), Nat.succ(x: Variable(named: "*.1.$1"))),
        Nat.add(Variable(named: "*.1.$0"), Nat.mul(Variable(named: "*.1.$0"), Variable(named: "*.1.$1")))
      )
    ])
    self.add_operator("pre", Nat.pre,[
      Rule(
        Nat.pre(Nat.zero()),
        Nat.zero()
      ),
      Rule(
        Nat.pre(Nat.succ(x: Variable(named: "pre.1.$0"))),
        Variable(named: "pre.1.$0")
      )
    ])
    self.add_operator("-", Nat.sub,[
      Rule(
        Nat.sub(Variable(named: "-.0.$0"), Nat.zero()),
        Variable(named: "-.0.$0")
      ),
      Rule(
        Nat.sub(Nat.zero(), Variable(named: "-.1.$0")),
        Nat.zero()
      ),
      Rule(
        Nat.sub(Variable(named: "-.2.$0"), Nat.succ(x: Variable(named: "-.2.$1"))),
        Nat.pre(Nat.sub(Variable(named: "-.2.$0"), Variable(named: "-.2.$1")))
      )
    ])
    self.add_operator("<", Nat.lt,[
      Rule(
        Nat.lt(Variable(named: "<.0.$0"), Nat.zero()),
        Boolean.False()
      ),
      Rule(
        Nat.lt(Nat.zero(), Variable(named: "<.1.$0")),
        Boolean.True()
      ),
      Rule(
        Nat.lt(Nat.succ(x: Variable(named: "<.2.$0")), Nat.succ(x: Variable(named: "<.2.$1"))),
        Nat.lt(Variable(named: "<.2.$0"), Variable(named: "<.2.$1"))
      )
    ])
    self.add_operator(">", Nat.gt,[
      Rule(
        Nat.gt(Nat.zero(), Variable(named: ">.0.$0")),
        Boolean.False()
      ),
      Rule(
        Nat.gt(Variable(named: ">.1.$0"), Nat.zero()),
        Boolean.True()
      ),
      Rule(
        Nat.gt(Nat.succ(x: Variable(named: ">.2.$0")), Nat.succ(x: Variable(named: ">.2.$1"))),
        Nat.gt(Variable(named: ">.2.$0"), Variable(named: ">.2.$1"))
      )
    ])
    self.add_operator("N==", Nat.eq,[
      Rule(
        Nat.eq(Nat.zero(), Nat.zero()),
        Boolean.True()
      ),
      Rule(
        Nat.eq(Variable(named: "N==.1.$0"), Nat.zero()),
        Boolean.False()
      ),
      Rule(
        Nat.eq(Nat.zero(), Variable(named: "*N==.2.$0")),
        Boolean.False()
      ),
      Rule(
        Nat.eq(Nat.succ(x: Variable(named: "N==.3.$0")), Nat.succ(x:  Variable(named: "N==.3.$1"))),
        Nat.eq(Variable(named: "N==.3.$0"), Variable(named: "N==.3.$1"))
      )
    ])
    self.add_operator("%", Nat.mod,[
      Rule(
        Nat.mod(Variable(named: "%.0.$0"), Nat.zero()),
        vFail
      ),
      Rule(
        Nat.mod(Nat.zero(),  Variable(named: "%.1.$0")),
        Nat.zero()
      ),
      Rule(
        Nat.mod(Variable(named: "%.2.$0"), Variable(named: "%.2.$1")),
        Variable(named: "%.2.$0"),
        Nat.lt(Variable(named: "%.2.$0"), Variable(named: "%.2.$1"))
      ),
      Rule(
        Nat.mod(Variable(named: "%.3.$0"), Variable(named: "%.3.$1")),
        Nat.mod(Nat.sub(Variable(named: "%.3.$0"), Variable(named: "%.3.$1")), Variable(named: "%.3.$1"))
      )
    ])
    self.add_operator("gcd", Nat.gcd,[
      Rule(
        Nat.gcd(Variable(named: "gcd.0.$0"), Variable(named: "gcd.0.$1")),
        Variable(named: "gcd.0.$0"),
        Nat.eq(Variable(named: "gcd.0.$1"), Nat.zero())
      ),
      Rule(
        Nat.gcd(Variable(named: "gcd.1.$0"), Variable(named: "gcd.1.$1")),
        Variable(named: "gcd.1.$1"),
        Nat.eq(Nat.mod(Variable(named: "gcd.1.$0"), Variable(named: "gcd.1.$1")), Nat.zero())
      ),
      Rule(
        Nat.gcd(Variable(named: "gcd.2.$0"), Variable(named: "gcd.2.$1")),
        Nat.gcd(Variable(named: "gcd.2.$1"), Nat.mod(Variable(named: "gcd.2.$0"), Variable(named: "gcd.2.$1")))
      )
    ])
    self.add_operator("/", Nat.div,[
      Rule(
        Nat.div(Variable(named: "/.0.$0"), Nat.zero()),
        vFail
      ),
      Rule(
        Nat.div(Variable(named: "/.1.$0"), Variable(named: "/.1.$1")),
        Nat.zero(),
        Nat.lt(Variable(named: "/.1.$0"), Variable(named: "/.1.$1"))
      ),
      Rule(
        Nat.div(Variable(named: "/.2.$0"), Variable(named: "/.2.$1")),
        Nat.succ(
          x: Nat.div(
            Nat.sub(
              Variable(named: "/.2.$0"),
              Variable(named: "/.2.$1")
            ),
              Variable(named: "/.2.$1")
          )
        ),
        Boolean.or(
          Nat.gt(Variable(named: "/.2.$0"), Variable(named: "/.2.$1")),
          Nat.eq(Variable(named: "/.2.$0"), Variable(named: "/.2.$1"))
        )

      )
    ])
  }

  //Generator
  static public func zero(_:Term...) -> Term{
    return Value<Int>(0)
  }

  static public func succ(x: Term...) -> Term {
    return Map(["succ": x[0]])
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
  public class override func belong(_ x: Term) -> Goal{
    return (x === Nat.zero() || delayed(fresh {y in x === Nat.succ(x:y) && Nat.belong(y)}))
  }

  public override func pprint(_ term: Term) -> String{
    return Nat.to_string(term)
  }

  public override func check(_ term: Term) -> Bool{
    if term.equals( Nat.zero()){
      return true
    }
    if let m = (term as? Map){
      return m["succ"] != nil
    }
    return false
  }

  public override func eval(_ t: Term) -> Term{
    if t.equals(Nat.zero()){
      return t
    }
    if let m = (t as? Map){
      let data = m["succ"]!
      return Nat.succ(x: ADTs.eval(data))
    }
    return t
  }

  static public func to_string(_ x: Term) -> String{
   	if x.equals(Nat.zero()){
   		return "0"
   	}
   	if let map = (x as? Map){
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
        if f[0].characters.count == 0 {
     		   return "succ("+f[1]+")"
        }
        if let i = (Int(f[0])){
          return String(1+i)+" + "+f[1]
        }
        return "succ(\(k))"
      }
      return ADTs.pprint(map)
   	}
    if x is Variable {
      return "+"+ADTs.pprint(x)
    }
   	return ADTs.pprint(x)
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
    return Operator.n("N==", operands[0], operands[1])
  }
  public class func gcd(_ operands: Term...) -> Term{
    return Operator.n("gcd", operands[0], operands[1])
  }
}


public class Integer: ADT{
  public init(){
    super.init("Integer")
    self.add_generator("int", Integer.int)
    self.add_operator("I+", Integer.add, [
      Rule(
        Integer.add(
          Integer.int(Variable(named: "I+.0.$0"),Variable(named: "I+.0.$1")),
          Integer.int(Variable(named: "I+.0.$2"),Variable(named: "I+.0.$3"))
        ),
        Integer.int(
          Nat.add(Variable(named: "I+.0.$0"),Variable(named: "I+.0.$2")),
          Nat.add(Variable(named: "I+.0.$1"),Variable(named: "I+.0.$3"))
        )
      )
    ])
    self.add_operator("I-", Integer.sub, [
      Rule(
        Integer.sub(
          Integer.int(Variable(named: "I-.0.$0"),Variable(named: "I-.0.$1")),
          Integer.int(Variable(named: "I-.0.$2"),Variable(named: "I-.0.$3"))
        ),
        Integer.int(
          Nat.add(Variable(named: "I-.0.$0"),Variable(named: "I-.0.$3")),
          Nat.add(Variable(named: "I-.0.$1"),Variable(named: "I-.0.$2"))
        )
      )
    ])
    /*self.add_operator("abs", Integer.abs, [
      Rule(
        Integer.abs(
          Integer.int(Variable(named: "abs.0.$0"),Variable(named: "abs.0.$1"))
        ),
        Integer.int(Variable(named: "abs.0.$1"),Variable(named: "abs.0.$0")),
        Nat.lt(Variable(named: "abs.0.$0"), Variable(named: "abs.0.$1"))
      ),
      Rule(
        Integer.abs(
          Integer.int(Variable(named: "abs.1.$0"),Variable(named: "abs.1.$1"))
        ),
        Integer.int(Variable(named: "abs.1.$0"),Variable(named: "abs.1.$1"))
      )
    ])*/
    self.add_operator("abs", Integer.abs, [
      Rule(
        Integer.abs(
          Integer.int(Variable(named: "abs.0.$0"),Variable(named: "abs.0.$1"))
        ),
        Nat.sub(Variable(named: "abs.0.$1"),Variable(named: "abs.0.$0")),
        Nat.lt(Variable(named: "abs.0.$0"), Variable(named: "abs.0.$1"))
      ),
      Rule(
        Integer.abs(
          Integer.int(Variable(named: "abs.1.$0"),Variable(named: "abs.1.$1"))
        ),
        Nat.sub(Variable(named: "abs.1.$0"),Variable(named: "abs.1.$1"))
      )
    ])
    self.add_operator("normalize", Integer.normalize, [
      Rule(
        Integer.normalize(
          Integer.int(Variable(named: "normalize.0.$0"),Variable(named: "normalize.0.$1"))
        ),
        Integer.int(Variable(named: "normalize.0.$0"),Variable(named: "normalize.0.$1")),
        Boolean.or(
          Nat.eq(Variable(named: "normalize.0.$0"), Nat.zero()),
          Nat.eq(Variable(named: "normalize.0.$1"), Nat.zero())
        )
      ),
      Rule(
        Integer.normalize(
          Integer.int(Variable(named: "normalize.1.$0"),Variable(named: "normalize.1.$1"))
        ),
        Integer.normalize(
          Integer.int(
            Nat.pre(Variable(named: "normalize.1.$0")), Nat.pre(Variable(named: "normalize.1.$1"))
          )
        )
      )
    ])
    self.add_operator("I*", Integer.mul, [
      Rule(
        Integer.mul(
          Integer.int(Variable(named: "I*.0.$0"),Variable(named: "I*.0.$1")),
          Integer.int(Variable(named: "I*.0.$2"),Variable(named: "I*.0.$3"))
        ),
        Integer.int(
          Nat.add(
            Nat.mul(Variable(named: "I*.0.$0"),Variable(named: "I*.0.$2")),
            Nat.mul(Variable(named: "I*.0.$1"),Variable(named: "I*.0.$3"))
          ),
          Nat.add(
            Nat.mul(Variable(named: "I*.0.$0"),Variable(named: "I*.0.$3")),
            Nat.mul(Variable(named: "I*.0.$1"),Variable(named: "I*.0.$2"))
          )
        )
      )
    ])
    self.add_operator("I==", Integer.eq, [
      Rule(
        Integer.eq(
          Integer.int(Variable(named: "I==.0.$0"),Variable(named: "I==.0.$1")),
          Integer.int(Variable(named: "I==.0.$2"),Variable(named: "I==.0.$3"))
        ),
        Boolean.and(
          Boolean.eq(
            Integer.abs(
              Integer.int(Variable(named: "I==.0.$0"),Variable(named: "I==.0.$1"))
            ),
            Integer.abs(
              Integer.int(Variable(named: "I==.0.$2"),Variable(named: "I==.0.$3"))
            )
          ),
          Boolean.eq(
            Integer.sign(
              Integer.int(Variable(named: "I==.0.$0"),Variable(named: "I==.0.$1"))
            ),
            Integer.sign(
              Integer.int(Variable(named: "I==.0.$2"),Variable(named: "I==.0.$3"))
            )
          )
        )
      )
    ])
    self.add_operator("I<", Integer.lt, [
      Rule(
        Integer.lt(
          Integer.int(Variable(named: "I<.0.$0"),Variable(named: "I<.0.$1")),
          Integer.int(Variable(named: "I<.0.$2"),Variable(named: "I<.0.$3"))
        ),
        Boolean.eq(
          Nat.lt(
            Nat.add(Variable(named: "I<.0.$0"), Variable(named: "I<.0.$3")),
            Nat.add(Variable(named: "I<.0.$1"), Variable(named: "I<.0.$2"))
          ),
          Boolean.True()
        )
      )
    ])
    self.add_operator("I>", Integer.gt, [
      Rule(
        Integer.gt(
          Integer.int(Variable(named: "I>.0.$0"),Variable(named: "I>.0.$1")),
          Integer.int(Variable(named: "I>.0.$2"),Variable(named: "I>.0.$3"))
        ),
        Boolean.eq(
          Nat.gt(
            Nat.add(Variable(named: "I>.0.$0"), Variable(named: "I>.0.$3")),
            Nat.add(Variable(named: "I>.0.$1"), Variable(named: "I>.0.$2"))
          ),
          Boolean.True()
        )
      )
    ])
    self.add_operator("sign", Integer.sign, [
      Rule(
        Integer.sign(
          Integer.int(Variable(named: "I>.0.$0"),Variable(named: "I>.0.$1"))
        ),
        Nat.gt(
          Variable(named: "I>.0.$0"),
          Variable(named: "I>.0.$1")
        )
      )
    ])
    //Condition for the division is a simple xor which verify
    //a < b xor c < d
    self.add_operator("I/", Integer.div, [
      Rule(
        Integer.div(
          Integer.int(Variable(named: "I/.0.$0"),Variable(named: "I/.0.$1")),
          Integer.int(Variable(named: "I/.0.$2"),Variable(named: "I/.0.$3"))
        ),
        Integer.int(
          Nat.zero(),
          Nat.div(
            Integer.abs(
              Integer.int(
                Variable(named: "I/.0.$0"),
                Variable(named: "I/.0.$1")
              )
            ),
            Integer.abs(
              Integer.int(
                Variable(named: "I/.0.$2"),
                Variable(named: "I/.0.$3")
              )
            )
          )
        ),
        Boolean.and(
          Boolean.or(
            Nat.lt(
              Variable(named: "I/.0.$0"),
              Variable(named: "I/.0.$1")
            ),
            Nat.lt(
              Variable(named: "I/.0.$2"),
              Variable(named: "I/.0.$3")
            )
          ),
          Boolean.not(
            Boolean.and(
              Nat.lt(
                Variable(named: "I/.0.$0"),
                Variable(named: "I/.0.$1")
              ),
              Nat.lt(
                Variable(named: "I/.0.$2"),
                Variable(named: "I/.0.$3")
              )
            )
          )
        )
      ),
      Rule(
        Integer.div(
          Integer.int(Variable(named: "I/.1.$0"),Variable(named: "I/.1.$1")),
          Integer.int(Variable(named: "I/.1.$2"),Variable(named: "I/.1.$3"))
        ),
        Integer.int(
          Nat.div(
            Integer.abs(
              Integer.int(
                Variable(named: "I/.1.$0"),
                Variable(named: "I/.1.$1")
              )
            ),
            Integer.abs(
              Integer.int(
                Variable(named: "I/.1.$2"),
                Variable(named: "I/.1.$3")
              )
            )
          ),
          Nat.zero()
        )
      )
    ])
  }

  static public func int(_ x: Term...) -> Term {
    return Map(["a": x[0], "b":x[1]])
  }

  static public func n(_ x: Int) -> Term {
    let abs_x = Swift.abs(x)
    if x>0{
      return Integer.int(Nat.n(abs_x),Nat.zero())
    }
    return Integer.int(Nat.zero(),Nat.n(abs_x))
  }

  public override func check(_ term: Term) -> Bool{
    if let map = (term as? Map) {
      return map["a"] != nil && map["b"] != nil
    }
    return false
  }

  public class override func belong(_ x: Term) -> Goal{
    return (delayed(fresh {y in fresh {z in x === Integer.int(y,z) && Nat.belong(y) && Nat.belong(z)}}))
  }

  public override func pprint(_ term: Term) -> String{
    if let map = (term as? Map) {
      let a : Term = ADTs.eval(map["a"]!)
      let b : Term = ADTs.eval(map["b"]!)
      if  ADTs["nat"].check(a) && ADTs["nat"].check(b){
        if ADTs.eval(Nat.eq(a,b)).equals(Boolean.True()){
          return "0"
        }
        if ADTs.eval(Nat.gt(a,b)).equals(Boolean.True()){
          return "+\(ADTs.pprint(ADTs.eval(Nat.sub(a,b))))"
        }
        return "-\(ADTs.pprint(ADTs.eval(Nat.sub(b,a))))"
      }
      return "FAIL"
    }
    if let variable = (term as? Variable){
      return variable.description
    }
    return Nat.to_string(term)
  }

  public override func eval(_ t: Term) -> Term{
    if t.equals(Nat.zero()){
      return t
    }
    if let m = (t as? Map){
      let a = m["a"]!
      let b = m["b"]!
      return Integer.int(ADTs.eval(a),ADTs.eval(b))
    }
    return t
  }

  static public func add(_ terms: Term...)->Term{
    return Operator.n("I+",terms[0], terms[1])
  }
  static public func sub(_ terms: Term...)->Term{
    return Operator.n("I-",terms[0], terms[1])
  }
  static public func abs(_ terms: Term...)->Term{
    return Operator.n("abs",terms[0])
  }
  static public func normalize(_ terms: Term...)->Term{
    return Operator.n("normalize",terms[0])
  }
  static public func mul(_ terms: Term...)->Term{
    return Operator.n("I*",terms[0], terms[1])
  }
  static public func eq(_ terms: Term...)->Term{
    return Operator.n("I==",terms[0], terms[1])
  }
  public static func lt(_ operands: Term...) -> Term{
    return Operator.n("I<", operands[0], operands[1])
  }
  public static func gt(_ operands: Term...) -> Term{
    return Operator.n("I>", operands[0], operands[1])
  }
  public static func div(_ operands: Term...) -> Term{
    return Operator.n("I/", operands[0], operands[1])
  }
  public static func sign(_ operands: Term...) -> Term{
    return Operator.n("sign", operands[0])
  }

}

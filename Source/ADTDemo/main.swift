import LogicKit
import ProofKitLib

class Char: ADT{
  public init(){
    super.init("char")
    self.add_generator("a", Char.a)
    self.add_generator("b", Char.b)
    self.add_generator("c", Char.c)
    // .....
    self.add_operator("c==",Char.eq, [
      Rule(Char.eq(Variable(named: "x"),Variable(named: "x")), Boolean.True()),
      Rule(Char.eq(Variable(named: "x"),Variable(named: "y")), Boolean.False())
    ], arity:2)
  }

  static public func a(_ :Term...)-> Term{
    return Value<String>("a")
  }
  static public func b(_ :Term...)-> Term{
    return Value<String>("b")
  }
  static public func c(_ :Term...)-> Term{
    return Value<String>("c")
  }
  // ....

  static public func eq(_ terms: Term...)->Term{
    return Operator.n("c==",terms[0], terms[1])
  }

  public class override func belong(_ term: Term ) -> Goal {
    return term === Char.a() || term === Char.b() || term === Char.c()
  }

  public override func pprint(_ term: Term) -> String{
    if let v = (term as? Value<String>){
      return v.wrapped
    }
    return "?"
  }

  public override func check(_ term: Term) -> Bool{
    return term.equals(Char.a()) || term.equals(Char.b()) || term.equals(Char.c())
  }
}

var adtm = ADTManager.instance()
adtm["char"] = Char()

let a = Char.a()
let b = Char.b()
var op = Char.eq(a, b)
var r = adtm.eval(op)
print("\(adtm.pprint(op)) => \(adtm.pprint(r))")

op = Char.eq(a, a)
r = adtm.eval(op)
print("\(adtm.pprint(op)) => \(adtm.pprint(r))")

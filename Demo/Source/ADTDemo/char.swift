import LogicKit
import ProofKit

// A Simple custom ADT: Char
class Char: ADT{
  // ADT Constructor
  public init(){
    super.init("char") // name of your adt
    // add your generators with its arity (by default 0)
    self.add_generator("a", Char.a)
    self.add_generator("b", Char.b)
    self.add_generator("c", Char.c)
    // .....

    // add your operators, and its axioms and arity (by default 2)
    self.add_operator("c==",Char.eq, [
      Rule(Char.eq(Variable(named: "x"),Variable(named: "x")), Boolean.True()),
      Rule(Char.eq(Variable(named: "x"),Variable(named: "y")), Boolean.False())
    ], ["char", "char"])
  }
  // generator functions always (Term...)->Term
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

  // Simple operator function (alyaws (Term...)->Term)
  static public func eq(_ terms: Term...)->Term{
    return Operator.n("c==",terms[0], terms[1])
  }

  // Goal to know if  a term belong to this adt (Goal result)
  public class override func belong(_ term: Term ) -> Goal {
    return term === Char.a() || term === Char.b() || term === Char.c()
  }

  // Simple check to check if a term is of this adt type (Boolean result)
  public override func check(_ term: Term) -> Bool{
    return term.equals(Char.a()) || term.equals(Char.b()) || term.equals(Char.c())
  }

  // Print nicely your term
  public override func pprint(_ term: Term) -> String{
    if let v = (term as? Value<String>){
      return v.wrapped
    }
    return "?"
  }

}

import LogicKit
public class Boolean : ADT {
    public init(){
      super.init("boolean")
      self.add_generator("true", Boolean.True)
      self.add_generator("false", Boolean.False)
      self.add_operator("not", Boolean.not, [
        Rule(Boolean.not(Boolean.False()),Boolean.True()),
        Rule(Boolean.not(Boolean.True()),Boolean.False())
      ], arity: 1)
      self.add_operator("and", Boolean.and, [
        Rule(Boolean.and(Boolean.False(),Variable(named:"and.0.$1")),Boolean.False()),
        Rule(Boolean.and(Variable(named:"and.1.$1"),Boolean.False()),Boolean.False()),
        Rule(Boolean.and(Boolean.True(),Boolean.True()),Boolean.True())
      ])
      self.add_operator("or", Boolean.or, [
        Rule(Boolean.or(Boolean.True(),Variable(named:"or.0.$1")),Boolean.True()),
        Rule(Boolean.or(Variable(named:"or.1.$1"),Boolean.True()),Boolean.True()),
        Rule(Boolean.or(Boolean.False(),Boolean.False()),Boolean.False())
      ])
      self.add_operator("B==",Boolean.eq, [
        Rule(Boolean.eq(Variable(named:"b.==.0.$0"),Variable(named:"b.==.0.$0")), Boolean.True()),
        Rule(Boolean.eq(Variable(named:"b.==.1.$0"),Variable(named:"b.==.1.$1")), Boolean.False()),
      ])
    }

    public static func True(_:Term...) -> Term{
      return Value<Bool>(true)
    }

    public static func False(_:Term...) -> Term{
      return Value<Bool>(false)
    }

    public static func eq(_ ops: Term...)->Term{
      return Operator.n("B==",ops[0],ops[1])
    }

    ////Helper
    public static func n(_ x: Bool) -> Term{
      return Value<Bool>(x)
    }

    public static func isTrue(_ x: Term) -> Goal {
      return x === Boolean.True()
    }

    public static func isFalse(_ x: Term) -> Goal{
      return x === Boolean.False()
    }

    public static func not(_ operands: Term...)->Term{
      return Operator.n("not", operands[0])
    }

    public static func or(_ operands: Term...)->Term{
      return Operator.n("or",operands[0],operands[1])
    }

    public static func and(_ operands: Term...)->Term{
      return Operator.n("and",operands[0],operands[1])
    }

    public class override func belong(_ term: Term ) -> Goal {
          return term === Boolean.True() || term === Boolean.False()
    }

    public override func pprint(_ term: Term) -> String{
      if term.equals(Boolean.True()){
        return "true"
      }
      if term.equals(Boolean.False()){
        return "false"
      }
      return "?"
    }

    public override func check(_ term: Term) -> Bool{
      return term.equals(Boolean.False()) || term.equals(Boolean.True())
    }
}

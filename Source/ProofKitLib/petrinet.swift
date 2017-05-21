import LogicKit
public class Petrinet : ADT {
    public init(){
      super.init("petrinet")
      self.add_generator("null", Petrinet.null)
      self.add_generator("add_edge", Petrinet.add_edge, arity: 5)
    }

    public static func null(_:Term...) -> Term{
      return Value<Bool>(false)
    }

    public static func add_edge(_ operands: Term...) -> Term{
      return Map(["from":operands[0], "to":operands[1], "isInput":operands[2], "weight":operands[3], "net":operands[4]])
    }

    public class override func belong(_ term: Term ) -> Goal {
          return term === Petrinet.null() || delayed( freshn {
            ops in term === Petrinet.add_edge(ops["0"], ops["1"], ops["2"], ops["3"], ops["4"]) 
              && Nat.belong(ops["0"])
              && Nat.belong(ops["1"])
              && Boolean.belong(ops["2"])
              && Nat.belong(ops["3"])
              && Petrinet.belong(ops["4"]) 
          })
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

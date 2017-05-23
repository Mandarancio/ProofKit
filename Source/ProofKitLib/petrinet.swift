import LogicKit

public class Petrinet : ADT {
    public init(){
      super.init("petrinet")
      self.add_generator("null", Petrinet.null)
      self.add_generator("add_edge", Petrinet.add_edge, arity: 5)
    }

    public static func null(_:Term...) -> Term{
      return new_term(Value<Bool>(false), "petrinet")
    }

    public static func add_edge(_ operands: Term...) -> Term{
      return new_term(Map(["from_place":operands[0], "to_trans":operands[1], "weight":operands[2], "net":operands[3]]), "petrinet")
    }

    public class override func belong(_ term: Term ) -> Goal {
          return term === Petrinet.null() || delayed( freshn {
            ops in term === Petrinet.add_edge(ops["0"], ops["1"], ops["2"], ops["3"], ops["4"])
              && Nat.belong(ops["0"])
              && Nat.belong(ops["1"])
              && Integer.belong(ops["2"])
              && Petrinet.belong(ops["3"])
          })
    }

  public static func to_matrix() -> DynamicMatrix {
    let mat = DynamicMatrix()
    //TODO complete
    return mat
  }
}

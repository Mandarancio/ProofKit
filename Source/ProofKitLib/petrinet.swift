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
      return Map(["from_place":operands[0], "to_trans":operands[1], "weight":operands[2], "net":operands[3]])
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

  public static func to_matrix(_ net: Term) -> DynamicMatrix {
    if let map = (net as? Map) {
      if map["from_place"] != nil && map["to_trans"] != nil && map["weight"] != nil && map["net"] != nil {
        let p = Nat.to_int(map["from_place"]!)
        let t = Nat.to_int(map["to_trans"]!)
        let w = Integer.to_int(map["weight"]!)
        let net_mat = to_matrix(map["net"]!)
        net_mat[(p,t)] = w
        return net_mat
      }
    }
    return DynamicMatrix()
  }

  public static func to_string(_ net: Term) -> String {
    if net.equals(Petrinet.null()) {
        return "null_petrinet"
    }
    else if let map = (net as? Map) {
      if map["from_place"] != nil && map["to_trans"] != nil && map["weight"] != nil && map["net"] != nil {
        let p_str = Nat.to_string(map["from_place"]!)
        let t_str = Nat.to_string(map["to_trans"]!)
        let w_str = Integer.to_string(map["weight"]!)
        let net_str = to_string(map["net"]!)
        return "add_edge(p:\(p_str), t:\(t_str), w:\(w_str), \(net_str))"
      }
    }
    return ""
  }
}

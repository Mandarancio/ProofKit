import LogicKit
import ProofKitLib

public class Marking : ADT {
  public init() {
    super.init("marking")
    self.add_generator("null", Marking.null)
    self.add_generator("next_place", Marking.next_place, arity:2)

    self.add_operator("has_enough", Marking.has_enough, [
      //has_enough(null, [a, b], p) => a == b
      Rule(
      Marking.has_enough(
          Marking.null(),
          Integer.int(Variable(named: "a"), Variable(named: "b")),
          Variable(named: "p")),
        Nat.eq(Variable(named: "a"), Variable(named: "b"))
        ),

      //has_enough(next_place(v, x), [a, b], zero) => v+1 > (a-b)
      Rule(
      Marking.has_enough(
          Marking.next_place(Variable(named: "v"), Variable(named: "x")),
          Integer.int(Variable(named: "a"), Variable(named: "b")),
          Nat.zero()),
        Nat.gt(
                Nat.add(Variable(named: "v"), Nat.succ(x:Nat.zero()) ),
                Nat.sub(Variable(named: "a"), Variable(named: "b"))
              )
        ),

      //has_enough(next_place(v, x), w, succ(y)) => has_enough(x, w, y)
      Rule(
        Marking.has_enough(
          Marking.next_place(Variable(named: "v"), Variable(named: "x")),
          Variable(named: "w"),
          Nat.succ(x:Variable(named: "y"))),
        Marking.has_enough(
          Variable(named: "x"),
          Variable(named: "w"),
          Variable(named: "y")
        )
        )
    ], ["marking", "int", "nat"])

  }

  public static func null(_:Term...) -> Term{
    return new_term(Value<Bool>(false), "marking")
  }

  public static func next_place(_ operands: Term...) -> Term {
    return new_term(Map(["value": operands[0], "rest": operands[1]]), "marking")
  }

    public class override func belong(_ term: Term ) -> Goal {
          return term === Marking.null() || delayed( freshn {
            ops in term === Marking.next_place(ops["0"], ops["1"])
              && Nat.belong(ops["0"])
              && Marking.belong(ops["1"])
          })
    }

    public static func to_array(_ marking: Term) -> [Int] {
      if let map = (value(marking) as? Map) {
        if map["value"] != nil && map["rest"] != nil{
          let val = Nat.to_int(map["value"]!)
          var rest_array = to_array(map["rest"]!)
          rest_array.insert(val, at:0)
          return rest_array
        }
      }
      return []
    }

    public static func to_vector(_ marking: Term) -> DynamicVector {
      return DynamicVector(to_array(marking))
    }

    public static func to_string(_ marking: Term) -> String {
      if let map = (value(marking) as? Map) {
        if map["value"] != nil && map["rest"] != nil{
          let val_str = Nat.to_string(map["value"]!)
          let rest_str = to_string(map["rest"]!)
          return "\(val_str), \(rest_str)"
        }
      }
      return ""
    }

  public static func has_enough(_ operands: Term...) -> Term{
    return Operator.n("has_enough", operands[0], operands[1], operands[2])
  }


  public override func pprint(_ t: Term) -> String{
    return Marking.to_string(t)
  }
}


public class Petrinet : ADT {

    public init(){
      super.init("petrinet")
      self.add_generator("null", Petrinet.null)
      self.add_generator("add_edge", Petrinet.add_edge, arity: 4)
      self.add_operator("is_triggerable", Petrinet.is_triggerable, [
        //is_triggerable(null, t, m) => True
        Rule(Petrinet.is_triggerable(Petrinet.null(), Variable(named: "t"), Variable(named: "m")),
          Boolean.True()
        ),

        //is_triggerable(add_edge(p, t, w, x), t, m) => has_enough(m, w, p) and is_triggerable(x, t, m)
        Rule(
          Petrinet.is_triggerable(
            Petrinet.add_edge(Variable(named: "p"), Variable(named: "t"), Variable(named: "w"), Variable(named: "x")),
            Variable(named: "t"),
            Variable(named: "m")
          ),
          Boolean.and(
            Marking.has_enough(Variable(named: "m"), Variable(named: "w"), Variable(named: "p")),
            Petrinet.is_triggerable(Variable(named: "x"), Variable(named: "t"), Variable(named: "m"))
            )
        ),

        //is_triggerable(add_edge(p, t1, w, x), t2, m) => has_enough(m, w, p) and is_triggerable(x, t, m)
        Rule(
          Petrinet.is_triggerable(
            Petrinet.add_edge(Variable(named: "p"), Variable(named: "t1"), Variable(named: "w"), Variable(named: "x")),
            Variable(named: "t2"),
            Variable(named: "m")
          ),
            Petrinet.is_triggerable(Variable(named: "x"), Variable(named: "t2"), Variable(named: "m"))
        )
        ]
      ,["petrinet", "nat", "marking"])
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

//TODO check belong
    public static func is_p_invariant(net: Term, invariant: Term) -> Goal {
      return Boolean.n(to_matrix(net).is_p_invariant(Marking.to_vector(invariant))) === Boolean.True()
    }

    public static func is_t_invariant(net: Term, invariant: Term) -> Goal {
      return Boolean.n(to_matrix(net).is_t_invariant(Marking.to_vector(invariant))) === Boolean.True()
    }

  public static func to_matrix(_ net: Term) -> DynamicMatrix {
    if let map = (value(net) as? Map) {
      if map["from_place"] != nil && map["to_trans"] != nil && map["weight"] != nil && map["net"] != nil {
        let p = Nat.to_int(map["from_place"]!)
        let t = Nat.to_int(map["to_trans"]!)
        let w = Integer.to_int(map["weight"]!)
        let net_mat = to_matrix(map["net"]!)
        net_mat[(p,t)] = net_mat[(p,t)] - w
        return net_mat
      }
    }
    return DynamicMatrix()
  }

  public static func to_string(_ net: Term) -> String {
    if net.equals(Petrinet.null()) {
        return "null_petrinet"
    }
    else if let map = (value(net) as? Map) {
      if map["from_place"] != nil && map["to_trans"] != nil && map["weight"] != nil && map["net"] != nil {
        let p_str = Nat.to_string(map["from_place"]!)
        let t_str = Nat.to_string(map["to_trans"]!)
        let w = Integer.to_int(map["weight"]!)
        let net_str = to_string(map["net"]!)
        return "add_edge(p:\(p_str), t:\(t_str), w:\(w),\n\(net_str))"
      }
    }
    return ""
  }

  public static func is_triggerable(_ operands: Term...) -> Term{
    return Operator.n("is_triggerable", operands[0], operands[1], operands[2])
  }

  public override func pprint(_ t: Term) -> String{
    return Petrinet.to_string(t)
  }

  public static func to_nice_string_edges(_ net: Term, _ p_indexes:[String:Int], _ t_indexes:[String:Int]) -> String {
    if net.equals(Petrinet.null()) {
        return ""
    }
    else if let map = (value(net) as? Map) {
      if map["from_place"] != nil && map["to_trans"] != nil && map["weight"] != nil && map["net"] != nil {
        let p = Nat.to_int(map["from_place"]!)
        //clumsy
        var p_str = ""
        for (place,i) in p_indexes {
          if i == p {
            p_str = place
            break
          }
        }
        let t = Nat.to_int(map["to_trans"]!)
        //clumsy
        var t_str = ""
        for (transition,i) in t_indexes {
          if i == t {
            t_str = transition
            break
          }
        }
        let w = Integer.to_int(map["weight"]!)
        let net_str = to_nice_string_edges(map["net"]!, p_indexes, t_indexes)
        if w < 0 {
          return "out(p:\(p_str), t:\(t_str), w:\(-1*w))\n\(net_str)"
        }
        if w >= 0 {
          return "int(p:\(p_str), t:\(t_str), w:\(w))\n\(net_str)"
        }
      }
    }
    return ""
  }

  public static func to_nice_string(_ net: Term, _ p_indexes:[String:Int], _ t_indexes:[String:Int]) -> String{
    var str = "Places :\n"
    for (place, _) in p_indexes {
      str += place
      str += ", "
    }
    str += "\nTransitions :\n"
    for (transition, _) in t_indexes {
      str += transition
      str += ", "
    }
    str += "\nEdges :\n"
    str += to_nice_string_edges(net, p_indexes, t_indexes)
    return str
  }
}

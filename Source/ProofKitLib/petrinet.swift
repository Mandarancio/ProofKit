import LogicKit

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
    ])

  }

  public static func null(_:Term...) -> Term{
    return Value<Bool>(false)
  }

  public static func next_place(_ operands: Term...) -> Term {
    return Map(["value": operands[0], "rest": operands[1]])
  }

    public class override func belong(_ term: Term ) -> Goal {
          return term === Marking.null() || delayed( freshn {
            ops in term === Marking.next_place(ops["0"], ops["1"])
              && Nat.belong(ops["0"])
              && Marking.belong(ops["1"])
          })
    }

    public static func to_array(_ marking: Term) -> [Int] {
      if let map = (marking as? Map) {
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
      if let map = (marking as? Map) {
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
}

import LogicKit
//// https://en.wikipedia.org/wiki/Linked_list
//// Linked List
public class LList : ADT {
    public init(){
      super.init("llist")

      self.add_generator("empty", LList.empty)
      self.add_generator("insert", LList.insert, arity:2)
      self.add_operator("concat", LList.concat, [
        Rule(LList.concat(LList.empty(),Variable(named: "concat.0.$0")),Variable(named: "concat.0.$0")),
        Rule(
          LList.concat(LList.insert(Variable(named: "concat.1.$0"), Variable(named: "concat.1.$1")),Variable(named: "concat.1.$2")),
          LList.concat(Variable(named: "concat.1.$1"), LList.insert(Variable(named: "concat.1.$0"), Variable(named: "concat.1.$2"))))
      ])
      self.add_operator("contains", LList.contains, [
        Rule(LList.contains(LList.empty(), Variable(named: "contains.0.$0")), Boolean.False()),
        Rule(
          LList.contains(LList.insert(Variable(named: "contains.1.$0"), Variable(named: "contains.1.$1")), Variable(named: "contains.1.$0")),
          Boolean.True()
        ),
        Rule(
          LList.contains(LList.insert(Variable(named: "contains.2.$0"), Variable(named: "contains.2.$1")), Variable(named: "contains.2.$2")),
          LList.contains(Variable(named: "contains.2.$1"), Variable(named: "contains.2.$2"))
        )
      ])
      self.add_operator("size", LList.size, [
        Rule(LList.size(LList.empty()), Nat.zero()),
        Rule(
          LList.size(LList.insert(Variable(named: "size.1.$0"), Variable(named: "size.1.$1"))),
          Nat.succ(x: LList.size(Variable(named:"size.1.$1")))
        )
      ], arity: 1)
    }

    public static func empty(_ :Term...) -> Term{
      return Value<String>("list.tail")
    }

    public static func insert(_ terms: Term...) -> Term{
      return Map([
        "data": terms[0],
        "next": terms[1]
      ])
    }

    public static func n(_ terms: [Term]) -> Term{
      let n = terms.count
      if n == 0 {
        return LList.empty()
      }
      return LList.insert(terms[0],LList.n(Array<Term>(terms.suffix(n-1))))
    }

    public class override func belong(_ x: Term) -> Goal{
      return (x === LList.empty() || delayed(fresh {y in fresh{w in x === LList.insert(y,w) && LList.belong(w)}}))
    }

    public static func concat(_ terms: Term...)->Term{
      let o =  Operator.n(terms[0], terms[1], "concat")
      return o
    }

    public static func contains(_ terms: Term...)->Term{
      return Operator.n(terms[0], terms[1], "contains")
    }
    public static func size(_ terms: Term...)->Term{
      return Operator.n(Value("nil"), terms[0], "size")
    }

    public override func pprint(_ t: Term) -> String{
      var s : String = "("
      var x = t
      while !x.equals(LList.empty()){
        if let m = (x as? Map){
          ////
          if m["next"] != nil {
            if s != "(" {
              s += ", "
            }
            s += ADTs.pprint(m["data"]!)
            x = m["next"]!
          }else{
            x = LList.empty()
          }
        }else if let m = (x as? Variable){
          if s != "(" {
            s += ", "
          }
          s+="next : \(ADTs.pprint(m))"
          x = LList.empty()
        }
      }
      return s + ")"
    }

    public override func check(_ term: Term) -> Bool{
      if term.equals(LList.empty()){
        return true
      }
      if let m = (term as? Map){
        return m["next"] != nil && m["data"] != nil
      }
      return false
    }
}

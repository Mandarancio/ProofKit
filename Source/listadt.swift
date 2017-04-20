import LogicKit
//// https://en.wikipedia.org/wiki/Linked_list
//// Linked List
public class LList : ADT {
    public init(){
      super.init("llist")

      self.add_generator("empty", LList.empty)
      self.add_generator("cons", LList.cons, arity:2)
      self.add_operator("concat", LList.concat, [
        Rule(LList.concat(LList.empty(),Variable(named: "concat.0.$0")),Variable(named: "concat.0.$0")),
        Rule(
          LList.concat(LList.cons(Variable(named: "concat.1.$0"), Variable(named: "concat.1.$1")),Variable(named: "concat.1.$2")),
          LList.concat(Variable(named: "concat.1.$1"), LList.cons(Variable(named: "concat.1.$0"), Variable(named: "concat.1.$2"))))
      ])
      self.add_operator("contains", LList.contains, [
        Rule(LList.contains(LList.empty(), Variable(named: "contains.0.$0")), Boolean.False()),
        Rule(
          LList.contains(LList.cons(Variable(named: "contains.1.$0"), Variable(named: "contains.1.$1")), Variable(named: "contains.1.$0")),
          Boolean.True()
        ),
        Rule(
          LList.contains(LList.cons(Variable(named: "contains.2.$0"), Variable(named: "contains.2.$1")), Variable(named: "contains.2.$2")),
          LList.contains(Variable(named: "contains.2.$1"), Variable(named: "contains.2.$2"))
        )
      ])
      self.add_operator("size", LList.size, [
        Rule(LList.size(LList.empty()), Nat.zero()),
        Rule(
          LList.size(LList.cons(Variable(named: "size.1.$0"), Variable(named: "size.1.$1"))),
          Nat.succ(x: LList.size(Variable(named:"size.1.$1")))
        )
      ], arity: 1)
      self.add_operator("rest", LList.rest, [
        Rule(LList.rest(LList.empty()), LList.empty()),
        Rule(
          LList.rest(LList.cons(Variable(named: "rest.1.$0"), Variable(named: "rest.1.$1"))),
          Variable(named: "rest.1.$1")
        )
      ], arity:1)
      self.add_operator("first", LList.first, [
        Rule(LList.first(LList.empty()), vNil),
        Rule(
          LList.first(LList.cons(Variable(named: "first.1.$0"), Variable(named: "first.1.$1"))),
          Variable(named: "first.1.$0")
        )
      ], arity:1)
    }

    public static func empty(_ :Term...) -> Term{
      return Value<String>("llist.tail")
    }

    public static func cons(_ terms: Term...) -> Term{
      return Map([
        "first": terms[0],
        "rest": terms[1]
      ])
    }

    public static func n(_ terms: [Term]) -> Term{
      let n = terms.count
      if n == 0 {
        return LList.empty()
      }
      return LList.cons(terms[0],LList.n(Array<Term>(terms.suffix(n-1))))
    }

    public class override func belong(_ x: Term) -> Goal{
      return (x === LList.empty() || delayed(fresh {y in fresh{w in x === LList.cons(y,w) && LList.belong(w)}}))
    }

    public static func concat(_ terms: Term...)->Term{
      let o =  Operator.n(terms[0], terms[1], "concat")
      return o
    }

    public static func contains(_ terms: Term...)->Term{
      return Operator.n(terms[0], terms[1], "contains")
    }
    public static func size(_ terms: Term...)->Term{
      return Operator.n(vNil, terms[0], "size")
    }

    public static func rest(_ terms: Term...)->Term{
      return Operator.n(vNil, terms[0], "rest")
    }

    public static func first(_ terms: Term...)-> Term{
      return Operator.n(vNil, terms[0], "first")
    }

    public override func pprint(_ t: Term) -> String{
      var s : String = "("
      var x = t
      while !x.equals(LList.empty()){
        if let m = (x as? Map){
          ////
          if m["rest"] != nil {
            if s != "(" {
              s += ", "
            }
            s += ADTs.pprint(m["first"]!)
            x = m["rest"]!
          }else{
            x = LList.empty()
          }
        }else if let m = (x as? Variable){
          if s != "(" {
            s += ", "
          }
          s+="rest : \(ADTs.pprint(m))"
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
        return m["rest"] != nil && m["first"] != nil
      }
      return false
    }

    public override func eval(_ t: Term) -> Term{
      if t.equals(LList.empty()){
        return t
      }
      if let m = (t as? Map){
        let first = m["first"]!
        let rest = m["rest"]!
        return LList.cons(ADTs.eval(first), ADTs.eval(rest))
      }
      return t
    }
}


public class AList : ADT {
  public init(){
    super.init("alist")
  }

  public static func empty(_ : Term ...) -> Term{
    return Value("alist.tail")
  }

  public static func append(_ : Term...) -> Term{
    return Value("0")
  }
}

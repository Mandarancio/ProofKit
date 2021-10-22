import SwiftKanren

//// https://en.wikipedia.org/wiki/Linked_list
//// Linked List
public class Multiset : ADT {
    public init(){
      super.init("set")

      self.add_generator("empty", Multiset.empty)
      self.add_generator("cons", Multiset.cons, arity:2)
      self.add_operator("==",Multiset.eq,[
        Rule(
          Multiset.eq(Variable(named:"x"),Variable(named:"x")),
          Boolean.True()
        ),
        Rule(
          Multiset.eq(Multiset.cons(Variable(named:"first"),Variable(named:"rest")),Variable(named:"rhs")),
          Boolean.False(),
          Boolean.or(Boolean.not(Multiset.contains(Variable(named:"rhs"), Variable(named:"first"))), Boolean.not(Nat.eq(Nat.add(Multiset.size(Variable(named:"rest")),Nat.n(1)), Multiset.size(Variable(named:"rhs")))))
        ),
        Rule(
          Multiset.eq(Multiset.cons(Variable(named:"first"),Variable(named:"rest")),Variable(named:"rhs")),
          Multiset.eq(Variable(named:"rest"), Multiset.removeOne(Variable(named:"rhs"), Variable(named:"first"))),
          Boolean.and(Multiset.contains(Variable(named:"rhs"), Variable(named:"first")), Nat.eq(Nat.add(Multiset.size(Variable(named:"rest")),Nat.n(1)), Multiset.size(Variable(named:"rhs"))))
        )
      ], ["multiset", "multiset"])
      self.add_operator("concat", Multiset.concat, [
        Rule(Multiset.concat(Multiset.empty(),Variable(named: "x")),Variable(named: "x")),
        Rule(
          Multiset.concat(Multiset.cons(Variable(named: "x"), Variable(named: "rest")),Variable(named: "z")),
          Multiset.concat(Variable(named: "rest"), Multiset.cons(Variable(named: "x"), Variable(named: "z"))))
      ], ["multiset", "multiset"])
      self.add_operator("contains", Multiset.contains, [
        Rule(Multiset.contains(Multiset.empty(), Variable(named: "x")), Boolean.False()),
        Rule(
          Multiset.contains(Multiset.cons(Variable(named: "x"), Variable(named: "rest")), Variable(named: "x")),
          Boolean.True()
        ),
        Rule(
          Multiset.contains(Multiset.cons(Variable(named: "x"), Variable(named: "rest")), Variable(named: "y")),
          Multiset.contains(Variable(named: "rest"), Variable(named: "y"))
        )
      ], ["multiset", "any"])
      self.add_operator("size", Multiset.size, [
        Rule(Multiset.size(Multiset.empty()), Nat.zero()),
        Rule(
          Multiset.size(Multiset.cons(Variable(named: "x"), Variable(named: "rest"))),
          Nat.succ(Multiset.size(Variable(named:"rest")))
        )
      ], ["multiset"])
      self.add_operator("rest", Multiset.rest, [
        Rule(Multiset.rest(Multiset.empty()), Multiset.empty()),
        Rule(
          Multiset.rest(Multiset.cons(Variable(named: "x"), Variable(named: "rest"))),
          Variable(named: "rest")
        )
      ], ["multiset"])
      self.add_operator("first", Multiset.first, [
        Rule(Multiset.first(Multiset.empty()), vNil),
        Rule(
          Multiset.first(Multiset.cons(Variable(named: "x"), Variable(named: "rest"))),
          Variable(named: "x")
        )
      ], ["multiset"])
      self.add_operator("removeOne", Multiset.removeOne,[
        Rule(
          Multiset.removeOne(Multiset.empty(), Variable(named:"element")),
          Multiset.empty()
        ),
        Rule(
          Multiset.removeOne(Multiset.cons(Variable(named:"element"),Variable(named:"rest")), Variable(named:"element")),
          Variable(named: "rest")
        ),
        Rule(
          Multiset.removeOne(Multiset.cons(Variable(named:"first"),Variable(named:"rest")), Variable(named:"element")),
          Multiset.cons(Variable(named:"first"), Multiset.removeOne(Variable(named:"rest"),Variable(named:"element")))
        )
      ], ["multiset", "any"])
      self.add_operator("removeAll",Multiset.removeAll, [
        Rule(
          Multiset.removeAll(Variable(named:"x"), Multiset.empty()),
          Variable(named:"x")
        ),
        Rule(
          Multiset.removeAll(Variable(named:"set"), Variable(named:"element")),
          Variable(named:"set"),
          Boolean.not(Multiset.contains(Variable(named:"set"), Variable(named:"element")))
        ),
        Rule(
          Multiset.removeAll(Variable(named:"set"), Variable(named:"element")),
          Multiset.removeAll(Multiset.removeOne(Variable(named:"set"),Variable(named:"element")),Variable(named:"element")),
          Multiset.contains(Variable(named:"set"), Variable(named:"element"))
        )
      ], ["multiset", "any"])
    }

    public static func empty(_ :Term...) -> Term{
      return new_term(Value<String>("Multiset.tail"),"multiset")
    }

    public static func cons(_ terms: Term...) -> Term{
      return new_term(Map([
        "first": terms[0],
        "rest": terms[1]
      ]), "multiset")
    }

    public class func n(_ terms: [Term]) -> Term{
      let n = terms.count
      if n == 0 {
        return Multiset.empty()
      }
      return Multiset.cons(terms[0],Multiset.n(Array<Term>(terms.suffix(n-1))))
    }

    public class override func belong(_ x: Term) -> Goal{
      return (x === Multiset.empty() || delayed(fresh {y in fresh{w in x === Multiset.cons(y,w) && Multiset.belong(w)}}))
    }

    public static func concat(_ terms: Term...)->Term{
      let o =  Operator.n("concat", terms[0], terms[1])
      return o
    }
    public static func contains(_ terms: Term...)->Term{
      return Operator.n("contains", terms[0], terms[1] )
    }
    public static func size(_ terms: Term...)->Term{
      return Operator.n("size",terms[0])
    }

    public static func rest(_ terms: Term...)->Term{
      return Operator.n("rest", terms[0])
    }

    public static func first(_ terms: Term...)-> Term{
      return Operator.n("first", terms[0])
    }

    public static func removeOne(_ terms: Term...)->Term{
      return Operator.n("removeOne",terms[0], terms[1])
    }
    public static func removeAll(_ terms: Term...)->Term{
      return Operator.n("removeAll", terms[0],terms[1])
    }

    public class func eq(_ terms: Term...)-> Term{
      return Operator.n("==",terms[0],terms[1])
    }

    public override func pprint(_ t: Term) -> String{
      var s : String = "["
      var x = t
      var i = 0
      while !x.equals(Multiset.empty()){
        if i>0{
          s += ", "
        }
        if let v = (x as? Variable){
          s += v.name
          x = Multiset.empty()
        }
        else if let m = (value(x) as? Map){
          s += ADTm.pprint(m["first"]!)
          x = m["rest"]!
        }else{
          x = Multiset.empty()
        }
        i += 1
      }
      return s + "]"
    }
}

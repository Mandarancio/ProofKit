import LogicKit

//// SET
//// https://en.wikipedia.org/wiki/Set_(abstract_data_type)
public class Set : ADT {
  public init(){
    super.init("set")
    
    self.add_generator("empty", Set.empty)
    self.add_generator("cons", Set.cons, arity:2)
    self.add_operator("contains", Set.contains, [
      Rule(Set.contains(Set.empty(), Variable(named: "x")), Boolean.False()),
      Rule(
        Set.contains(Set.cons(Variable(named: "x"), Variable(named: "rest")), Variable(named: "x")),
        Boolean.True()
      ),
      Rule(
        Set.contains(Set.cons(Variable(named: "x"), Variable(named: "rest")), Variable(named: "y")),
        Set.contains(Variable(named: "rest"), Variable(named: "y"))
      )
      ], ["set", "any"])
    self.add_operator("removeOne", Set.removeOne,[
      Rule(
        Set.removeOne(Variable(named:"x"),Set.empty()),
        Variable(named:"x")
      ),
      Rule(
        Set.removeOne(Set.empty(),Variable(named:"element")),
        Set.empty()
      ),
      Rule(
        Set.removeOne(Set.cons(Variable(named:"element"),Variable(named:"rest")), Variable(named:"element")),
        Variable(named: "rest")
      ),
      Rule(
        Set.removeOne(Set.cons(Variable(named:"first"),Variable(named:"rest")), Variable(named:"element")),
        Set.cons(Variable(named:"first"), Set.removeOne(Variable(named:"rest"),Variable(named:"element")))
      )
      ], ["set", "any"])
    self.add_operator("==", Set.eq,[
      Rule(
        Set.eq(Set.empty(), Set.empty()),
        Boolean.True()
      ),
      Rule(
        Set.eq(Set.cons(Variable(named: "x"), Variable(named: "rest")), Variable(named: "set")),
        Boolean.False(),
        Boolean.not(Set.contains(Variable(named: "set"), Variable(named: "x")))
      ),
      Rule(
        Set.eq(Variable(named: "set"), Set.cons(Variable(named: "x"), Variable(named: "rest"))),
        Boolean.False(),
        Boolean.not(Set.contains(Variable(named: "set"), Variable(named: "x")))
      ),
      Rule(
        Set.eq(Set.cons(Variable(named: "x"), Variable(named: "rest")), Variable(named: "set")),
        Set.eq(Variable(named: "rest"), Set.removeOne(Variable(named: "set"), Variable(named: "x")))
      ),
      ], ["set", "set"])
    self.add_operator("insert", Set.insert, [
      Rule(
        Set.insert(Variable(named: "element"), Set.empty()),
        Set.cons(Variable(named: "element"), Set.empty())
      ),
      Rule(
        Set.insert(Variable(named: "element"), Set.cons(Variable(named: "element"), Variable(named: "rest"))),
        Set.cons(Variable(named: "element"), Variable(named: "rest"))
      ),
      Rule(
        Set.insert(Variable(named: "element"), Set.cons(Variable(named: "first"), Variable(named: "rest"))),
        Set.cons(Variable(named: "first"), Set.insert(Variable(named: "element"), Variable(named: "rest")))
      )
      ], ["any", "set"])
    
    self.add_operator("union", Set.union, [
      Rule(
        Set.union(Set.empty(),Variable(named: "rhs")),
        Variable(named: "rhs")
      ),
      Rule(
        Set.union(Set.cons(Variable(named: "union.1.$0"), Variable(named: "union.1.$1")),Variable(named: "union.1.$2")),
        Set.union(Variable(named: "union.1.$1"), Set.insert(Variable(named: "union.1.$0"), Variable(named: "union.1.$2")))
      )
      ], ["set", "set"])
    self.add_operator("intersection", Set.intersection, [
      Rule(
        Set.intersection(Set.empty(),Variable(named: "intersection.0.$0")),
        Set.empty()
      ),
      Rule(
        Set.intersection(Set.cons(Variable(named: "intersection.1.$0"), Variable(named: "intersection.1.$1")),Variable(named: "intersection.1.$2")),
        Set.insert(Variable(named: "intersection.1.$0"),   Set.intersection(Variable(named: "intersection.1.$1"),Variable(named: "intersection.1.$2"))),
        Set.contains(Variable(named: "intersection.1.$2"),Variable(named: "intersection.1.$0"))
      ),
      Rule(
        Set.intersection(Set.cons(Variable(named: "intersection.2.$0"), Variable(named: "intersection.2.$1")),Variable(named: "intersection.2.$2")),
        Set.intersection(Variable(named: "intersection.2.$1"),Variable(named: "intersection.2.$2")),
        Boolean.not(Set.contains(Variable(named: "intersection.2.$2"),Variable(named: "intersection.2.$0")))
      )
      ], ["set", "set"])
    self.add_operator("diff", Set.diff, [
      Rule(
        Set.diff(Set.empty(),Variable(named: "diff.0.$0")),
        Set.empty()
      ),
      Rule(
        Set.diff(Set.cons(Variable(named: "diff.1.$0"), Variable(named: "diff.1.$1")),Variable(named: "diff.1.$2")),
        Set.diff(Variable(named: "diff.1.$1"),Variable(named: "diff.1.$2")),
        Set.contains(Variable(named: "diff.1.$2"),Variable(named: "diff.1.$0"))
      ),
      Rule(
        Set.diff(Set.cons(Variable(named: "diff.2.$0"), Variable(named: "diff.2.$1")),Variable(named: "diff.2.$2")),
        Set.insert(Variable(named: "diff.2.$0"), Set.diff(Variable(named: "diff.2.$1"),Variable(named: "diff.2.$2"))),
        Boolean.not(Set.contains(Variable(named: "diff.2.$2"),Variable(named: "diff.2.$0")))
      )
      ], ["set", "set"])
    
    self.add_operator("subSet", Set.subSet, [
      Rule(
        Set.subSet(Set.empty(), Variable(named: "subset.0.$0")),
        Boolean.True()
      ),
      Rule(
        Set.subSet(Set.cons(Variable(named: "subset.1.$0"),Variable(named: "subset.1.$1")), Variable(named: "subset.1.$2")),
        Boolean.and(Set.contains(Variable(named: "subset.1.$2"),  Variable(named: "subset.1.$0")),Set.subSet( Variable(named: "subset.1.$1"), Variable(named: "subset.1.$2")))
      )
      ], ["set", "set"])
    self.add_operator("size", Set.size, [
      Rule(Set.size(Set.empty()), Nat.zero()),
      Rule(
        Set.size(Set.cons(Variable(named: "x"), Variable(named: "rest"))),
        Nat.succ(x: Set.size(Variable(named:"rest")))
      )
      ], ["set"])
//    self.add_operator("norm", Set.norm,[
//      Rule(
//        Set.norm(Set.empty()),
//        Set.empty()
//      ),
//      Rule(
//        Set.norm(Set.cons(Variable(named:"sn.1.$0"),Variable(named:"sn.1.$1"))),
//        Set.cons(Variable(named:"sn.1.$0"),Set.removeAll(Variable(named:"sn.1.$1"),Variable(named:"sn.1.$0")))
//      )
//      ], ["set"])
//    self.add_operator("rest", Set.rest, [
//      Rule(Set.rest(Set.empty()), Set.empty()),
//      Rule(
//        Set.rest(Set.cons(Variable(named: "x"), Variable(named: "rest"))),
//        Variable(named: "rest")
//      )
//      ], ["set"])
//    self.add_operator("first", Set.first, [
//      Rule(Set.first(Set.empty()), Value("lol")),
//      Rule(
//        Set.first(Set.cons(Variable(named: "x"), Variable(named: "rest"))),
//        Variable(named: "x")
//      )
//      ], ["set"])
//    self.add_operator("removeAll",Set.removeAll, [
//      Rule(
//        Set.removeAll(Variable(named:"x"), Set.empty()),
//        Variable(named:"x")
//      ),
//      Rule(
//        Set.removeAll(Variable(named:"set"), Variable(named:"element")),
//        Variable(named:"set"),
//        Boolean.not(Set.contains(Variable(named:"set"), Variable(named:"element")))
//      ),
//      Rule(
//        Set.removeAll(Variable(named:"set"), Variable(named:"element")),
//        Set.removeAll(Set.removeOne(Variable(named:"set"),Variable(named:"element")),Variable(named:"element")),
//        Set.contains(Variable(named:"set"), Variable(named:"element"))
//      )
//      ], ["set", "any"])
  }
  public static func empty(_ :Term...) -> Term{
    return new_term(Value<String>("Set.tail"),"set")
  }
  
  public static func cons(_ terms: Term...) -> Term{
    return new_term(Map([
      "first": terms[0],
      "rest": terms[1]
      ]), "set")
  }
  
  public static func contains(_ terms: Term...)->Term{
    return Operator.n("contains", terms[0], terms[1] )
  }
  public static func size(_ terms: Term...)->Term{
    return Operator.n("size",terms[0])
  }
  
  public static func removeOne(_ terms: Term...)->Term{
    return Operator.n("removeOne",terms[0], terms[1])
  }

  public class func eq(_ terms: Term...)-> Term
  {
    return Operator.n("==",terms[0],terms[1])
  }

  public static func insert(_ terms: Term...)->Term{
    return Operator.n("insert",terms[0], terms[1])
  }
  
  public static func union(_ terms: Term...)->Term{
    return Operator.n("union", terms[0], terms[1])
  }
  
  public static func intersection(_ terms: Term...)->Term{
    return Operator.n("intersection", terms[0], terms[1])
  }
  
  public static func diff(_ terms: Term...)->Term{
    return Operator.n("diff", terms[0], terms[1])
  }
  
  public static func subSet(_ terms: Term...)->Term{
    return Operator.n("subSet",terms[0], terms[1])
  }
  
  //  public static func rest(_ terms: Term...)->Term{
  //    return Operator.n("rest", terms[0])
  //  }
  //
  //  public static func first(_ terms: Term...)-> Term{
  //    return Operator.n("first", terms[0])
  //  }
  //  public static func norm(_ terms: Term...)-> Term{
  //    return Operator.n("norm",terms[0])
  //  }
  //  public static func removeAll(_ terms: Term...)->Term{
  //    return Operator.n("removeAll", terms[0],terms[1])
  //  }
  
  public class override func belong(_ x: Term) -> Goal{
    return (x === Set.empty() || delayed(fresh {y in fresh{w in x === Set.cons(y,w) && Set.belong(w)}}))
  }
  
  public class func n(_ terms: [Term]) -> Term{
    let n = terms.count
    if n == 0 {
      return Set.empty()
    }
    return Set.insert(terms[0],Set.n(Array<Term>(terms.suffix(n-1))))
  }
  
  public override func pprint(_ t: Term) -> String{
    var s : String = "{"
    var x = t
    var i = 0
    while !x.equals(Set.empty()){
      if i>0{
        s += ", "
      }
      if let v = (x as? Variable){
        s += v.name
        x = Set.empty()
      }
      else if let m = (value(x) as? Map){
        s += ADTm.pprint(m["first"]!)
        x = m["rest"]!
      }else{
        x = Set.empty()
      }
      i += 1
    }
    return s + "}"
  }
}

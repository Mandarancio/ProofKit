import LogicKit
//// https://en.wikipedia.org/wiki/Linked_list
//// Linked List
public class Bunch : ADT {
    public init(){
      super.init("bunch")

      self.add_generator("empty", Bunch.empty)
      self.add_generator("cons", Bunch.cons, arity:2)
      self.add_operator("concat", Bunch.concat, [
        Rule(Bunch.concat(Bunch.empty(),Variable(named: "concat.0.$0")),Variable(named: "concat.0.$0")),
        Rule(
          Bunch.concat(Bunch.cons(Variable(named: "concat.1.$0"), Variable(named: "concat.1.$1")),Variable(named: "concat.1.$2")),
          Bunch.concat(Variable(named: "concat.1.$1"), Bunch.cons(Variable(named: "concat.1.$0"), Variable(named: "concat.1.$2"))))
      ])
      self.add_operator("contains", Bunch.contains, [
        Rule(Bunch.contains(Bunch.empty(), Variable(named: "contains.0.$0")), Boolean.False()),
        Rule(
          Bunch.contains(Bunch.cons(Variable(named: "contains.1.$0"), Variable(named: "contains.1.$1")), Variable(named: "contains.1.$0")),
          Boolean.True()
        ),
        Rule(
          Bunch.contains(Bunch.cons(Variable(named: "contains.2.$0"), Variable(named: "contains.2.$1")), Variable(named: "contains.2.$2")),
          Bunch.contains(Variable(named: "contains.2.$1"), Variable(named: "contains.2.$2"))
        )
      ])
      self.add_operator("size", Bunch.size, [
        Rule(Bunch.size(Bunch.empty()), Nat.zero()),
        Rule(
          Bunch.size(Bunch.cons(Variable(named: "size.1.$0"), Variable(named: "size.1.$1"))),
          Nat.succ(x: Bunch.size(Variable(named:"size.1.$1")))
        )
      ], arity: 1)
      self.add_operator("rest", Bunch.rest, [
        Rule(Bunch.rest(Bunch.empty()), Bunch.empty()),
        Rule(
          Bunch.rest(Bunch.cons(Variable(named: "rest.1.$0"), Variable(named: "rest.1.$1"))),
          Variable(named: "rest.1.$1")
        )
      ], arity:1)
      self.add_operator("first", Bunch.first, [
        Rule(Bunch.first(Bunch.empty()), vNil),
        Rule(
          Bunch.first(Bunch.cons(Variable(named: "first.1.$0"), Variable(named: "first.1.$1"))),
          Variable(named: "first.1.$0")
        )
      ], arity:1)
      self.add_operator("removeOne", Bunch.removeOne,[
        Rule(
          Bunch.removeOne(Variable(named:"remOne.-1.$0"),Bunch.empty()),
          Variable(named:"remOne.-1.$0")
        ),
        Rule(
          Bunch.removeOne(Bunch.empty(),Variable(named:"remOne.0.$0")),
          Bunch.empty()
        ),
        Rule(
          Bunch.removeOne(Bunch.cons(Variable(named:"remOne.1.$0"),Variable(named:"remOne.1.$1")), Variable(named:"remOne.1.$0")),
          Variable(named: "remOne.1.$1")
        ),
        Rule(
          Bunch.removeOne(Bunch.cons(Variable(named:"remOne.2.$0"),Variable(named:"remOne.2.$1")), Variable(named:"remOne.2.$2")),
          Bunch.cons(Variable(named:"remOne.2.$0"), Bunch.removeOne(Variable(named:"remOne.2.$1"),Variable(named:"remOne.2.$2")))
        )
      ])
      self.add_operator("removeAll",Bunch.removeAll, [
        Rule(
          Bunch.removeAll(Variable(named:"remAll.0.$0"), Bunch.empty()),
          Variable(named:"remAll.0.$0")
        ),
        Rule(
          Bunch.removeAll(Variable(named:"remAll.0.$0"), Variable(named:"remAll.0.$1")),
          Variable(named:"remAll.0.$0"),
          Boolean.not(Bunch.contains(Variable(named:"remAll.0.$0"), Variable(named:"remAll.0.$1")))
        ),
        Rule(
          Bunch.removeAll(Variable(named:"remAll.0.$0"), Variable(named:"remAll.0.$1")),
          Bunch.removeAll(Bunch.removeOne(Variable(named:"remAll.0.$0"),Variable(named:"remAll.0.$1")),Variable(named:"remAll.0.$1")),
          Bunch.contains(Variable(named:"remAll.0.$0"), Variable(named:"remAll.0.$1"))
        )
      ])
      self.add_operator("BU==",Bunch.eq,[
        Rule(
          Bunch.eq(Variable(named:"BU==.0.$0"),Variable(named:"BU==.0.$0")),
          Boolean.True()
        ),
        Rule(
          Bunch.eq(Bunch.cons(Variable(named:"BU==.1.$0"),Variable(named:"BU==.1.$1")),Variable(named:"BU==.1.$2")),
          Boolean.False(),
          Boolean.or(Boolean.not(Bunch.contains(Variable(named:"BU==.1.$2"), Variable(named:"BU==.1.$0"))), Boolean.not(Nat.eq(Nat.add(Bunch.size(Variable(named:"BU==.1.$1")),Nat.n(1)), Bunch.size(Variable(named:"BU==.1.$2")))))
        ),
        Rule(
          Bunch.eq(Bunch.cons(Variable(named:"BU==.1.$0"),Variable(named:"BU==.1.$1")),Variable(named:"BU==.1.$2")),
          Bunch.eq(Variable(named:"BU==.1.$1"), Bunch.removeOne(Variable(named:"BU==.1.$2"), Variable(named:"BU==.1.$0"))),
          Boolean.and(Bunch.contains(Variable(named:"BU==.1.$2"), Variable(named:"BU==.1.$0")), Nat.eq(Nat.add(Bunch.size(Variable(named:"BU==.1.$1")),Nat.n(1)), Bunch.size(Variable(named:"BU==.1.$2"))))
        )
      ])
    }

    public static func empty(_ :Term...) -> Term{
      return Value<String>("Bunch.tail")
    }

    public static func cons(_ terms: Term...) -> Term{
      return Map([
        "first": terms[0],
        "rest": terms[1]
      ])
    }

    public class func n(_ terms: [Term]) -> Term{
      let n = terms.count
      if n == 0 {
        return Bunch.empty()
      }
      return Bunch.cons(terms[0],Bunch.n(Array<Term>(terms.suffix(n-1))))
    }

    public class override func belong(_ x: Term) -> Goal{
      return (x === Bunch.empty() || delayed(fresh {y in fresh{w in x === Bunch.cons(y,w) && Bunch.belong(w)}}))
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
      return Operator.n("removeAll",terms[0],terms[1])
    }

    public class func eq(_ terms: Term...)-> Term{
      return Operator.n("BU==",terms[0],terms[1])
    }

    public override func pprint(_ t: Term) -> String{
      var s : String = "["
      var x = t
      while !x.equals(Bunch.empty()){
        if let m = (x as? Map){
          ////
          if m["rest"] != nil {
            if s != "[" {
              s += ", "
            }
            s += ADTs.pprint(m["first"]!)
            x = m["rest"]!
          }else{
            x = Bunch.empty()
          }
        }else if let m = (x as? Variable){
          if s != "[" {
            s += ", "
          }
          s+="rest : \(ADTs.pprint(m))"
          x = Bunch.empty()
        }
      }
      return s + "]"
    }

    public override func check(_ term: Term) -> Bool{
      if term.equals(Bunch.empty()){
        return true
      }
      if let m = (term as? Map){
        return m["rest"] != nil && m["first"] != nil
      }
      return false
    }

    public override func eval(_ t: Term) -> Term{
      if t.equals(Bunch.empty()){
        return t
      }
      if let m = (t as? Map){
        let first = m["first"]!
        let rest = m["rest"]!
        return Bunch.cons(ADTs.eval(first), ADTs.eval(rest))
      }
      return t
    }
}

//// SET
//// https://en.wikipedia.org/wiki/Set_(abstract_data_type)
public class Set : Bunch {
  public override init(){
    super.init()
    self._name = "set"
    self.remove_operator("concat")
    self.remove_operator("removeOne")
    self.remove_operator("BU==")
    self.add_operator("insert", Set.insert, [
      Rule(
        Set.insert(Variable(named: "insert.0.$0"), Set.empty()),
        Set.cons(Variable(named: "insert.0.$0"), Set.empty())
      ),
      Rule(
        Set.insert(Variable(named: "insert.1.$0"), Set.cons(Variable(named: "insert.1.$0"), Variable(named: "insert.1.$1"))),
        Set.cons(Variable(named: "insert.1.$0"), Variable(named: "insert.1.$1"))
      ),
      Rule(
        Set.insert(Variable(named: "insert.2.$0"), Set.cons(Variable(named: "insert.2.$1"), Variable(named: "insert.2.$2"))),
        Set.cons(Variable(named: "insert.2.$1"), Set.insert(Variable(named: "insert.2.$0"), Variable(named: "insert.2.$2")))
      )
    ])

    self.add_operator("union", Set.union, [
      Rule(
        Set.union(Set.empty(),Variable(named: "union.0.$0")),
        Variable(named: "union.0.$0")
      ),
      Rule(
        Set.union(Set.cons(Variable(named: "union.1.$0"), Variable(named: "union.1.$1")),Variable(named: "union.1.$2")),
        Set.union(Variable(named: "union.1.$1"), Set.insert(Variable(named: "union.1.$0"), Variable(named: "union.1.$2")))
      )
    ])
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
    ])
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
  	])

  	self.add_operator("subSet", Set.subSet, [
  		Rule(
  			Set.subSet(Set.empty(), Variable(named: "subset.0.$0")),
  			Boolean.True()
  		),
  		Rule(
  			Set.subSet(Set.cons(Variable(named: "subset.1.$0"),Variable(named: "subset.1.$1")), Variable(named: "subset.1.$2")),
  			Boolean.and(Set.contains(Variable(named: "subset.1.$2"),  Variable(named: "subset.1.$0")),Set.subSet( Variable(named: "subset.1.$1"), Variable(named: "subset.1.$2")))
  		)
  	])
    self.add_operator("S_norm", Set.norm,[
      Rule(
        Set.norm(Set.empty()),
        Set.empty()
      ),
      Rule(
        Set.norm(Set.cons(Variable(named:"sn.1.$0"),Variable(named:"sn.1.$1"))),
        Set.cons(Variable(named:"sn.1.$0"),Set.removeAll(Variable(named:"sn.1.$1"),Variable(named:"sn.1.$0")))
      )
    ])
    self.add_operator("S==", Set.eq,[
      Rule(
        Set.eq(Variable(named: "S==.0.$0"),Variable(named: "S==.0.$1")),
        Bunch.eq(Set.norm(Variable(named:"S==.0.$0")),Set.norm(Variable(named:"S==.0.$1")))
      )
    ])
  }

  public override class func eq(_ terms: Term...)-> Term
  {
    return Operator.n("S==",terms[0],terms[1])
  }

  public static func norm(_ terms: Term...)-> Term{
    return Operator.n("S_norm",terms[0])
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

  public override func check(_ term: Term) -> Bool{
    if term.equals(Set.empty()){
      return true
    }
    if let m = (term as? Map){
      return m["s.rest"] != nil && m["s.first"] != nil
    }
    return false
  }

  public override func eval(_ t: Term) -> Term{
    if t.equals(Set.empty()){
      return t
    }
    if let m = (t as? Map){
      let first = m["s.first"]!
      let rest = m["s.rest"]!
      return Set.cons(ADTs.eval(first), ADTs.eval(rest))
    }
    return t
  }

  public class override func belong(_ x: Term) -> Goal{
    return (x === Set.empty() || delayed(fresh {y in fresh{w in x === Set.cons(y,w) && Set.belong(w) && ADTs.eval(Set.contains(w,y))===Boolean.False()}}))
  }

  public override class func n(_ terms: [Term]) -> Term{
    let n = terms.count
    if n == 0 {
      return Set.empty()
    }
    return Set.insert(terms[0],Set.n(Array<Term>(terms.suffix(n-1))))
  }
}


public class Sequence : ADT {
  public init(){
    super.init("sequence")
    self.add_generator("empty", Sequence.empty)
    self.add_generator("cons", Sequence.cons, arity:3)
    self.add_operator("push", Sequence.push,[
      Rule(
        Sequence.push(Variable(named:"push.0.$0"), Sequence.empty()),
        Sequence.cons(Variable(named:"push.0.$0"), Nat.zero(), Sequence.empty())
      ),
      Rule(
        Sequence.push(Variable(named:"push.1.$0"), Sequence.cons(Variable(named:"push.1.$1"), Variable(named:"push.1.$2"), Variable(named:"push.1.$3"))),
        Sequence.cons(Variable(named:"push.1.$0"), Nat.succ(x:Variable(named:"push.1.$2")), Sequence.cons(Variable(named:"push.1.$1"), Variable(named:"push.1.$2"), Variable(named:"push.1.$3")))
      )
    ],arity:2)
    self.add_operator("get", Sequence.getAt,[
      Rule(
        Sequence.getAt(Sequence.empty(), Variable(named: "get.0.$0")),
        vNil
      ),
      Rule(
        Sequence.getAt(Sequence.cons(Variable(named: "get.1.$0"), Variable(named: "get.1.$1"), Variable(named: "get.1.$2")), Variable(named: "get.1.$1")),
        Variable(named: "get.1.$0")
      ),
      Rule(
        Sequence.getAt(Sequence.cons(Variable(named: "get.2.$0"), Variable(named: "get.2.$1"), Variable(named: "get.2.$2")), Variable(named: "get.2.$3")),
        Sequence.getAt(Variable(named: "get.2.$2"), Variable(named: "get.2.$3"))
      )
    ], arity:2)
    self.add_operator("set", Sequence.setAt,[
      Rule(
        Sequence.setAt(Sequence.empty(), Variable(named: "set.0.$0"), Variable(named: "set.0.$1")),
        Sequence.empty()
      ),
      Rule(
        Sequence.setAt(Sequence.cons(Variable(named: "set.1.$0"), Variable(named: "set.1.$1"), Variable(named: "set.1.$2")), Variable(named: "set.1.$1"), Variable(named: "set.1.$3")),
        Sequence.cons(Variable(named: "set.1.$3"), Variable(named:"set.1.$1"), Variable(named:"set.1.$2"))
      ),
      Rule(
        Sequence.setAt(Sequence.cons(Variable(named: "set.2.$0"), Variable(named: "set.2.$1"), Variable(named: "set.2.$2")), Variable(named: "set.2.$3"), Variable(named: "set.2.$4")),
        Sequence.cons(Variable(named: "set.2.$0"), Variable(named:"set.2.$1"), Sequence.setAt(Variable(named:"set.2.$2"), Variable(named: "set.2.$3"), Variable(named:"set.2.$4")))
      )
    ],arity:3)
  }

  public static func empty(_:Term...)->Term{
    return Value("seq.empty")
  }

  public static func cons( _ t:Term...)->Term{
    return Map([
      "value" : t[0],
      "index" : t[1],
      "rest" : t[2]
    ])
  }

  public class func n(_ t: [Term])-> Term{
    var r = push(t[0], Sequence.empty())
    for i in 1...t.count-1{
      r = push(t[i], r)
    }
    return r
  }

  public static func push(_ t: Term...)->Term{
    return Operator.n("push",t[0],t[1])
  }

  public static func getAt(_ t: Term...)->Term{
    return Operator.n("get",t[0],t[1])
  }
  public static func setAt(_ t:Term...)->Term{
    return Operator.n("set",t[0],t[1],t[2])
  }

  public class override func belong(_ x: Term) -> Goal{
    return (x === Sequence.empty() || delayed(fresh {y in fresh{w in fresh{z in x === Sequence.cons(y,w,z) && Sequence.belong(z)}}}))
  }

  public override func pprint(_ t: Term) -> String{
    var s : String = "["
    var x = t
    while !x.equals(Sequence.empty()){
      if let m = (x as? Map){
        ////
        if m["rest"] != nil {
          if s != "[" {
            s += ", "
          }
          s += "\(ADTs.pprint(m["index"]!)): \(ADTs.pprint(m["value"]!))"
          x = m["rest"]!
        }else{
          s += ", rest : \(ADTs.pprint(m))"
          x = Sequence.empty()
        }
      }else if let m = (x as? Variable){
        if s != "[" {
          s += ", "
        }
        s+="rest : \(ADTs.pprint(m))"
        x = Sequence.empty()
      }
    }
    return s + "]"
  }

  public override func check(_ term: Term) -> Bool{
    if term.equals(Sequence.empty()){
      return true
    }
    if let m = (term as? Map){
      return m["rest"] != nil && m["value"] != nil && m["index"] != nil
    }
    return false
  }

  public override func eval(_ t: Term) -> Term{

    if t.equals(Sequence.empty()){
      return t
    }

    if let m = (t as? Map){
      let val = m["value"]!
      let ind = m["index"]!
      let rest = m["rest"]!
      return Sequence.cons(ADTs.eval(val), ADTs.eval(ind), ADTs.eval(rest))
    }
    return t
  }
}

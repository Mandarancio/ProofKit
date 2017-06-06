import LogicKit

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
    ],["any", "sequence"])
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
    ], ["sequence", "nat"])
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
    ], ["sequence", "nat", "any"])
  }

  public static func empty(_:Term...)->Term{
    return new_term(Value("empty"),"sequence")
  }

  public static func cons( _ t:Term...)->Term{
    return new_term(Map([
      "data" : t[0],
      "index" : t[1],
      "rest" : t[2]
    ]),"sequence")
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

  public static func size(_ t: Term...)->Term{
    return Operator.n("size",t[0])
  }


  public class override func belong(_ x: Term) -> Goal{
    return (x === Sequence.empty() || delayed(fresh {y in fresh{w in fresh{z in x === Sequence.cons(y,w,z) && Nat.belong(w) && Sequence.belong(z)}}}))
  }

  public override func pprint(_ t: Term) -> String{
    var s : String = "["
    var x = t
    var i = 0
    while !x.equals(Sequence.empty()){
      if i>0{
        s += ", "
      }
      if let v = (x as? Variable){
        s += v.name
        x = Sequence.empty()
      }
      else if let m = (value(x) as? Map){
        s += "\(ADTm.pprint(m["index"]!)): \(ADTm.pprint(m["data"]!))"
        x = m["rest"]!
      }else{
        x = Sequence.empty()
      }
      i += 1
    }
    return s + "]"
  }

  public override func check(_ term: Term) -> Bool{
    if term.equals(Sequence.empty()){
      return true
    }
    if let m = (term as? Map){
      return m["rest"] != nil && m["data"] != nil && m["index"] != nil
    }
    return false
  }

}

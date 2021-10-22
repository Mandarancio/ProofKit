import SwiftKanren

public class Sequence : ADT {
  public init(){
    super.init("sequence")
    self.add_generator("empty", Sequence.empty)
    self.add_generator("cons", Sequence.cons, arity:3)
    self.add_operator("push", Sequence.push,[
      Rule(
        Sequence.push(Variable(named:"n"), Sequence.empty()),
        Sequence.cons(Variable(named:"n"), Nat.zero(), Sequence.empty())
      ),
      Rule(
        Sequence.push(Variable(named:"n1"), Sequence.cons(Variable(named:"n2"), Variable(named:"i1"), Variable(named:"s"))),
        Sequence.cons(Variable(named:"n1"), Nat.succ(Variable(named:"i1")), Sequence.cons(Variable(named:"n2"), Variable(named:"i1"), Variable(named:"s")))
      )
    ],["any", "sequence"])
    self.add_operator("getAt", Sequence.getAt,[
      Rule(
        Sequence.getAt(Sequence.empty(), Variable(named: "n")),
        vFail
      ),
      Rule(
        Sequence.getAt(Sequence.cons(Variable(named: "n"), Variable(named: "i"), Variable(named: "s")), Variable(named: "i")),
        Variable(named: "n")
      ),
      Rule(
        Sequence.getAt(Sequence.cons(Variable(named: "n"), Variable(named: "i1"), Variable(named: "s")), Variable(named: "i2")),
        Sequence.getAt(Variable(named: "s"), Variable(named: "i2")),
        Boolean.not(Nat.eq(Variable(named: "i1"), Variable(named: "i2")))
      )
    ], ["sequence", "nat"])
    self.add_operator("setAt", Sequence.setAt,[
      Rule(
        Sequence.setAt(Sequence.empty(), Variable(named: "i"), Variable(named: "n")),
        Sequence.empty()
      ),
      Rule(
        Sequence.setAt(Sequence.cons(Variable(named: "n1"), Variable(named: "i"), Variable(named: "s")), Variable(named: "i"), Variable(named: "n2")),
        Sequence.cons(Variable(named: "n2"), Variable(named:"i"), Variable(named:"s"))
      ),
      Rule(
        Sequence.setAt(Sequence.cons(Variable(named: "n1"), Variable(named: "i1"), Variable(named: "s")), Variable(named: "i2"), Variable(named: "n2")),
        Sequence.cons(Variable(named: "n1"), Variable(named:"i1"), Sequence.setAt(Variable(named:"s"), Variable(named: "i2"), Variable(named:"n2"))),
        Boolean.not(Nat.eq(Variable(named: "i1"), Variable(named: "i2")))
      )
    ], ["sequence", "nat", "any"])
    self.add_operator("size", Sequence.size, [
      Rule(
        Sequence.size(Sequence.empty()),
        Nat.zero()
      ),
      Rule(
        Sequence.size(Sequence.cons(Variable(named: "v"), Variable(named: "i"), Variable(named: "s"))),
        Nat.succ(Sequence.size(Variable(named: "s")))
      )
      
      ], ["sequence"])
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
    if t.count > 1 {
      for i in 1...t.count-1{
        r = push(t[i], r)
      }
    }
    return r
  }

  public static func push(_ t: Term...)->Term{
    return Operator.n("push",t[0],t[1])
  }

  public static func getAt(_ t: Term...)->Term{
    return Operator.n("getAt",t[0],t[1])
  }
  public static func setAt(_ t:Term...)->Term{
    return Operator.n("setAt",t[0],t[1],t[2])
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

}

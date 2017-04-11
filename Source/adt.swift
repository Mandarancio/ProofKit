import LogicKit

public enum Direction {
  case right
  case left
}

public  let axioms : [String: [Rule]] = [
  "N+": [Rule(NatAdd.n(Variable(named: "x"), Value(0)),
              Variable(named: "x")),
         Rule(NatAdd.n(Variable(named: "x"), Nat.succ(x: Variable(named: "y"))),
              Nat.succ(x: NatAdd.n(Variable(named: "x"),Variable(named:"y"))))]
]

public struct Operator{
  public static func n(_ lhs: Term, _ rhs: Term, _ name: String) -> Map{
    return Map([
      "name" : Value(name),
      "lhs" : lhs,
      "rhs" : rhs
    ])
  }

  public static func resolve(_ t : Term) -> Term {
    if !(t is Map){
      return t
    }
    let oper : Map = t as! Map
    if oper["name"] != nil {
      var t : Term = oper
      let name : String = (oper["name"] as! Value<String>).description
      for ax in axioms[name]! {
        t = (ax as Rule).resolve(t, Direction.left)
      }
      if t is Map {
        var tm : [String:Term] = [:]
        for (k,v) in (t as! Map) {
          if v is Map {
            tm[k] = Operator.resolve(v as! Map)
          }else{
            tm[k] = v
          }
        }
        t = Map(tm)
      }
      return t
    }
    return oper
  }
}
public struct NatAdd{
  public static let name = "N+"
  public static func n(_ l: Term, _ r: Term) -> Map{
    let o =  Operator.n(l, r, NatAdd.name)
    return o
  }
}

public struct Rule {
  init(_ lT : Term,_ rT: Term){
    self.lTerm = lT
    self.rTerm = rT
  }

  public static func replace (_ term : Term,_ variable: Variable,_ value: Term) -> Term{
    if term is Map {
      let m : Map = term as! Map
      var M : [String: Term] = [:]
      for (k,v) in m{
        M[k] = replace(v, variable, value)
      }
      return Map(M)
    }else{
      if term.equals(variable){
        return value
      }else{
        return term
      }
    }
  }

  public static func vmatch(_ x: Term, _ y : Term ) -> Bool{
    if x.equals(y) {return true}
    if x is Variable {return true}
    if y is Variable {return true}
    if x is Map && y is Map{
      let xm : Map = x as! Map
      let ym : Map = y as! Map
      for (k,v) in xm {
        if ym[k] == nil {
          return false
        }
        if !vmatch(v,ym[k]!){
          return false
        }

      }
      return true
    }
    return x.equals(y)
  }

  public func match(_ x: Term, _ d: Direction)->Bool{
    let t : Term = d == Direction.left ? self.lTerm : self.rTerm
    if type(of: t) == type(of: x) {
      return Rule.vmatch(t,x)
    }
    return false
  }

  private static func rep_map(_ x:Term,_ y:Term) -> [Variable : Term]{
    var d : [Variable : Term] = [:]
    if x is Map && y is Map{
      let xm : Map = x as! Map
      let ym : Map = y as! Map
      for (k,v) in xm {
        if v is Variable {
          d[v as! Variable] = ym[k]!
        }
      }
    }
    if x is Variable {
      d[x as! Variable] = y
    }else if y is Variable{
      if x is Map {
        d[y as! Variable] = Nat.succ(x: y)
      }else if !(x is Variable) {
        d[y as! Variable] = x
      }
    }
    return d
  }
  public func resolve(_ x: Term, _ d :Direction)-> Term{
    if self.match(x, d){
      let t : Term = d == Direction.left ? self.lTerm : self.rTerm
      var r : Term = d == Direction.left ? self.rTerm : self.lTerm
      let vs = Rule.rep_map(t, x)

      for (k,v) in vs {
        r = Rule.replace(r,k,v)
      }

      return r
    }
    return x
  }

  fileprivate let lTerm : Term
  fileprivate let rTerm : Term
}

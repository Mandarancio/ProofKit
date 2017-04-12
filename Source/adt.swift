import LogicKit

public enum Direction {
  case right
  case left
}

struct Proof {
  public func subst(_ t: Term, _ x: Term, _ st: Term, _ r: Term)-> Goal{
    return x === st && r === t
  }
}

public  let axioms : [String: [Rule]] = [
  "B!": [
    Rule(Boolean.not(Boolean.False()),Boolean.True()),
    Rule(Boolean.not(Boolean.True()),Boolean.False())
  ],
  "B.or": [
    Rule(Boolean.or(Boolean.True(),Variable(named:"B.or.0.$1")),Boolean.True()),
    Rule(Boolean.or(Variable(named:"B.or.1.$1"),Boolean.True()),Boolean.True()),
    Rule(Boolean.or(Boolean.False(),Boolean.False()),Boolean.False())
  ],
  "B.and":[
    Rule(Boolean.and(Boolean.False(),Variable(named:"B.and.0.$1")),Boolean.False()),
    Rule(Boolean.and(Variable(named:"B.and.1.$1"),Boolean.True()),Boolean.False()),
    Rule(Boolean.and(Boolean.True(),Boolean.True()),Boolean.True())
  ],
  "N+": [Rule(Nat.add(Variable(named: "N+.0.$1"), Value(0)),
              Variable(named: "N+.0.$1")),
         Rule(Nat.add(Variable(named: "N+.1.$1"), Nat.succ(x: Variable(named: "N+.1.$2"))),
              Nat.succ(x: Nat.add(Variable(named: "N+.1.$1"),Variable(named:"N+.1.$2"))))]
]

public struct Operator{
  public static func n(_ lhs: Term, _ rhs: Term, _ name: String) -> Map{
    return Map([
      "name" : Value(name),
      "lhs" : lhs,
      "rhs" : rhs
    ])
  }
}

public struct Rule {
  init(_ lT : Term,_ rT: Term){
    self.lTerm = lT
    self.rTerm = rT
  }

  public func applay(_ t: Term, _ r: Term)->Goal{
    return t === self.lTerm && r === self.rTerm
  }

  public let lTerm : Term
  public let rTerm : Term
}

import LogicKit


//// Proved tehorem and axioms data struct
public struct Rule {
  public init(_ lT : Term,_ rT: Term, _ condition: Term = Boolean.True()){
    self.lTerm = lT
    self.rTerm = rT
    self.condition = condition
  }
  //// Applay axiom to term t and result in r
  public func applay(_ t: Term, _ r: Term)->Goal{
    let x = Variable(named: "r.x")
    let c = get_result(condition === x && self.lTerm === t && self.rTerm === r, x)
    return t === self.lTerm && r === self.rTerm && ADTs.eval(c) === Boolean.True()
  }

  //// Pretty print of the axiom
  public func pprint() -> String{
    if condition.equals(Boolean.True()){
      return "\(ADTs.pprint(self.lTerm)) = \(ADTs.pprint(self.rTerm))"
    }else{
      return "if \(ADTs.pprint(self.condition)) then \n\t\(ADTs.pprint(self.lTerm)) = \(ADTs.pprint(self.rTerm))"
    }
  }

  public func equals(_ r: Rule) -> Bool{
    return equivalence(self.lTerm, r.lTerm) && equivalence(self.rTerm, r.rTerm) && equivalence(self.condition, r.condition)
  }

  public let lTerm : Term
  public let rTerm : Term
  public let condition : Term
}

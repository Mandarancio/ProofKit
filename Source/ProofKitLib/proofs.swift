import LogicKit

//// namespace containing all the operations to prove an axiom
public struct Proof {

  // public static func subst(_ t: Term, _ x: Term, _ st: Term, _ r: Term)-> Goal{
  //   return x === st && r === t
  // }

  public static func reflexivity(_ term: Term)->Rule{
    return Rule(term,term)
  }

  public static func symmetry(_ rule: Rule) -> Rule{
    var r = Rule(rule.urTerm(), rule.ulTerm(), rule.ucondition())
    r.set_variables(rule.variables())
    return r
  }

  public static func transitivity(_ lhs: Rule, _ rhs: Rule) -> Rule{
    if equivalence(lhs.rTerm,rhs.lTerm){
      let condition : Term
      if equivalence(lhs.condition, rhs.condition){
        condition = lhs.ucondition()
      }else{
        condition = Boolean.and(lhs.ucondition(), rhs.ucondition())
      }
      var rule =  Rule(lhs.ulTerm(), rhs.urTerm(), condition)
      rule.set_variables(lhs.variables())
      return rule
    }
    return Rule(vNil,vNil)
  }


  public static func substitutivity(_ operation: ([Term])->Term, _ operands: [Term]...)->Rule{
    // TODO Implement substitutivity
    let lhs  = operation(operands[0])
    let rhs = operation(operands[1])
    return Rule(lhs,rhs)
  }

  public static func substitution(_ rule: Rule, _ variable: Variable, _ replacement: Term)-> Rule{
    let x = Variable(named: "s.x")
    // let y = Variable(named: "s.y")
    let lhs = get_result(rule.ulTerm() === x && variable === replacement, x)
    let rhs = get_result(rule.urTerm() === x && variable === replacement, x)
    let condition = get_result(rule.ucondition() === x && variable === replacement, x)
    var r =  Rule(lhs,rhs,condition)
    r.set_variables(rule.variables())
    return r
  }

  public static func cut(_ rule: Rule, _ replacement: Rule) -> Rule{
    let x = Variable(named: "cut.x")
    let lhs = get_result(rule.ulTerm() === x && rule.ulTerm() === replacement.ulTerm() && rule.urTerm() === replacement.urTerm(),x)
    let rhs = get_result(rule.urTerm() === x && rule.ulTerm() === replacement.ulTerm() && rule.urTerm() === replacement.urTerm(),x)
    let condition = get_result(rule.ucondition() === x && rule.ulTerm() === replacement.ulTerm() && rule.urTerm() === replacement.urTerm(),x)
    var r = Rule(lhs, rhs, condition)
    r.set_variables(rule.variables())
    return r
  }

}

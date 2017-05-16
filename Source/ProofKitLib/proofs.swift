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
    return Rule(rule.rTerm, rule.lTerm, rule.condition)
  }
  public static func transitivity(_ lhs: Rule, _ rhs: Rule) -> Rule{
    if equivalence(lhs.rTerm,rhs.lTerm){
      let x = Variable(named:"t.x")
      let rcondition = get_result(lhs.rTerm === rhs.lTerm && x === rhs.condition,x)
      let rrhs = get_result(lhs.rTerm === rhs.lTerm && x === rhs.rTerm,x)
      print(rrhs)
      let condition : Term
      if equivalence(lhs.condition, rcondition){
        condition = lhs.condition
      }else{
        condition = Boolean.and(lhs.condition, rcondition)
      }
      return Rule(lhs.lTerm, rrhs, condition)
    }
    return Rule(vNil,vNil)
  }


  public static func substitutivity(_ operation: ([Term])->Term, _ operands: [Term]...)->Rule{
    // TODO
    let lhs  = operation(operands[0])
    let rhs = operation(operands[1])
    return Rule(lhs,rhs)
  }

  public static func substitution(_ rule: Rule, _ variable: Variable, _ replacement: Term)-> Rule{
    let x = Variable(named: "s.x")
    // let y = Variable(named: "s.y")
    let lhs = get_result(rule.lTerm === x && variable === replacement, x)
    let rhs = get_result(rule.rTerm === x && variable === replacement, x)
    let condition = get_result(rule.condition === x && variable === replacement, x)
    return Rule(lhs,rhs,condition)
  }

  public static func cut(_ rule: Rule, _ replacement: Rule) -> Rule{
    let x = Variable(named: "cut.x")
    let lhs = get_result(rule.lTerm === x && rule.lTerm === replacement.lTerm && rule.rTerm === replacement.rTerm,x)
    let rhs = get_result(rule.rTerm === x && rule.lTerm === replacement.lTerm && rule.rTerm === replacement.rTerm,x)
    let condition = get_result(rule.condition === x && rule.lTerm === replacement.lTerm && rule.rTerm === replacement.rTerm,x)
    return Rule(lhs,rhs,condition)
  }
  /*
  public  static func identity( _ t: Term, _ s: Rule...)-> Term
  {
    return t
  }

  public static func fail( _ t: Term, _ s: Rule...) -> Term{
    return Value("fail")
  }

  public static func sequence(_ t: Term,_ s: Rule...) -> Term{
    let x = Variable(named: "seq.x")
    var g = s[0].applay(t, x)
    let r = get_result(g,x)
    if r.equals(vNil){
      return Proof.fail(t)
    }
    g = s[1].applay(r,x)
    return get_result(g,x)
  }

  public static func choice(_ t: Term,_ s: Rule ...)-> Term{
    let x = Variable(named: "seq.x")
    var g = s[0].applay(t, x)
    let r = get_result(g,x)
    if !r.equals(vNil){
      return r
    }
    g = s[1].applay(t,x)
    return get_result(g,x)
  }*/

}

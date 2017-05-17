import LogicKit

private func replace(_ term: Term, _ search: Term) ->Term{
  if term is Variable{
    return term
  }
  return term
  // if equivalence(term, search){
  //   let emap = eq_map(term, search, [:])
  //
  // }
  // else{
  // }
}

//// namespace containing all the operations to prove an axiom
public struct Proof {

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


  public static func substitutivity(_ operation: (Term...)->Term, _ rules: [Rule])->Rule{
    //TODO Replace this horrible cast
    typealias Function = ([Term]) -> Term
    let operation_c = unsafeBitCast(operation, to: Function.self)

    var tlhs : [Term] = []
    var trhs : [Term] = []
    for r in rules{
      tlhs.append(r.lTerm)
      trhs.append(r.rTerm)
    }

    let lhs : Term = operation_c(tlhs)
    let rhs : Term = operation_c(trhs)
    var r = Rule(lhs, rhs)
    r.set_variables(rules[0].variables())
    return r
  }

  public static func substitution(_ rule: Rule, _ variable: Variable, _ replacement: Term)-> Rule{
    let v = rule.variables()[variable]
    if v == nil{
      return rule
    }

    let lhs = subst_variable(rule.lTerm, v!, replacement)
    let rhs = subst_variable(rule.rTerm, v!, replacement)
    let condition = subst_variable(rule.condition, v!, replacement)
    var r =  Rule(lhs,rhs,condition)
    r.set_variables(rule.variables())
    return r
  }

  public static func cut(_ rule: Rule, _ replacement: Rule) -> Rule{
    // if c1 ^ u = u' ^ c2 => t = t'
    //    c => u = u'
    // then
    //    c1 ^ c ^ c2 => t = t'

    let x = Variable(named: "cut.x")
    let lhs = get_result(rule.lTerm === x && rule.lTerm === replacement.lTerm && rule.rTerm === replacement.rTerm,x)
    let rhs = get_result(rule.rTerm === x && rule.lTerm === replacement.lTerm && rule.rTerm === replacement.rTerm,x)
    let condition = get_result(rule.condition === x && rule.lTerm === replacement.lTerm && rule.rTerm === replacement.rTerm,x)
    var r = Rule(lhs, rhs, condition)
    r.set_variables(rule.variables())
    return r
  }

}

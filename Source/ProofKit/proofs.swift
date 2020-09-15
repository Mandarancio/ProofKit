import SwiftKanren

//// namespace containing all the operations to prove an axiom
public struct Proof {

  public static func reflexivity(_ term: Term)->Rule{
    return Rule(term,term)
  }

  public static func symmetry(_ rule: Rule) -> Rule{
    return  Rule(rule.rTerm(), rule.lTerm(), rule.condition())/rule.variables()
  }

  public static func transitivity(_ lhs: Rule, _ rhs: Rule) -> Rule{
    if equivalence(lhs.rTerm(),rhs.lTerm()){
      let condition : Term
      if equivalence(lhs.condition(), rhs.condition()){
        condition = lhs.condition()
      }else{
        condition = Boolean.and(lhs.condition(), rhs.condition())
      }
      return  Rule(lhs.lTerm(), rhs.rTerm(), condition)/lhs.variables()
    }
    return Rule(vNil,vNil)
  }

  public static func substitutivity(_ operation: @escaping (Term...)->Term, _ rules: [Rule])->Rule{
    //TODO Replace this horrible cast
    typealias Function = ([Term]) -> Term
    let operation_c = unsafeBitCast(operation, to: Function.self)

    var tlhs : [Term] = []
    var trhs : [Term] = []
    for r in rules{
      tlhs.append(r.lTerm())
      trhs.append(r.rTerm())
    }

    let lhs : Term = operation_c(tlhs)
    let rhs : Term = operation_c(trhs)
    return Rule(lhs, rhs)/rules[0].variables()
  }

  public static func substitution(_ rule: Rule, _ variable: Variable, _ replacement: Term)-> Rule{
    let v = variable

    let lhs = subst_variable(rule.h_lTerm(), v, replacement)
    let rhs = subst_variable(rule.h_rTerm(), v, replacement)
    let condition = subst_variable(rule.h_condition(), v, replacement)

    return Rule(lhs, rhs, condition)
  }

  public static func inductive(_ conjecture: Rule, _ variable: Variable, _ adt: ADT,_ induction: [String:(Rule...)->Rule]) throws ->Rule  {
    for (gen_name, proof) in induction{
      let generator : (Term...)->Term = adt[gen_name]
      let arity = adt.garity(gen_name)
      let subs_term : Term
      if arity == 0{
        subs_term = generator()
      }else{
        subs_term = generator(variable)
      }
      let lhs = Proof.substitution(conjecture, variable, subs_term)
      let nr = proof(conjecture)
      if !lhs.equals(nr){
        throw ProofError.InductionFail
      }
    }
    return conjecture
  }

}

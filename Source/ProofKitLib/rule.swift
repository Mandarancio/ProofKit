import LogicKit

// RULE IDENTIFIER COUNTER
internal var rule_counter = 0;

//// Proved tehorem and axioms data struct
public struct Rule {

  public init(_ lT : Term,_ rT: Term, _ condition: Term = Boolean.True()){
    self.id = "r\(rule_counter)"
    rule_counter += 1

    self._variables = [:]
    var counter = 0
    create_subst_table(lT, self.id, &counter, &self._variables)
    counter = 0
    create_subst_table(rT, self.id,&counter, &self._variables)
    self._r_variables = reverse_subs_table(self._variables)

    self.lTerm = lT/self._variables
    self.rTerm = rT/self._variables

    self.condition = condition/self._variables
  }


  //Get substitution table of the variables
  public func variables() -> [Variable:Variable]{
    return self._variables
  }

  public func rvariables()  -> [Variable:Variable]{
    return self._r_variables
  }

  //Set new names for variables
  public mutating func set_variables(_ vs: [Variable:Variable]){
    let okeys = Array(self._variables.keys)
    let nkeys = Array(vs.keys)
    if okeys.count == 0 {
      return
    }
    var vars : [Variable:Variable] = [:]
    for i in 0...nkeys.count-1{
      vars[nkeys[i]] = self._variables[okeys[i]]
    }
    self._variables = vars
    self._r_variables = reverse_subs_table(self._variables)
  }

  //// Applay axiom to term t and result in r
  public func apply(_ t: Term, _ r: Term)->Goal{
    let x = Variable(named: "r.x")
    let c = get_result(condition === x && self.lTerm === t && self.rTerm === r, x)
    return t === self.lTerm && r === self.rTerm && ADTs.eval(c) === Boolean.True()
  }

  //// Pretty print of the axiom
  public func pprint() -> String{
    let lt =  self.lTerm/self._r_variables
    let rt = self.rTerm/self._r_variables

    if condition.equals(Boolean.True()){
      return "\(ADTs.pprint(lt)) = \(ADTs.pprint(rt))"
    }else{
      let c = self.condition/self._r_variables
      return "if \(ADTs.pprint(c)) then \n\t\(ADTs.pprint(lt)) = \(ADTs.pprint(rt))"
    }
  }

  // equivalence between proofs
  public func equals(_ r: Rule) -> Bool{
    return equivalence(self.lTerm, r.lTerm) && equivalence(self.rTerm, r.rTerm) && equivalence(self.condition, r.condition)
  }

  // universaly formatted left term
  public func ulTerm() -> Term{
    var counter : Int = 0
    var vx : [Variable:Variable] = [:]
    create_subst_table(lTerm, "", &counter, &vx)
    return lTerm/vx
  }

  // universaly formatted right term
  public func urTerm()->Term{
    var counter : Int = 0
    var vx : [Variable:Variable] = [:]
    create_subst_table(lTerm, "", &counter, &vx)
    counter = 0
    create_subst_table(rTerm, "", &counter, &vx)
    return rTerm/vx
  }

  // universaly formatted condition
  public func ucondition() -> Term{
    var counter : Int = 0
    var vx : [Variable:Variable] = [:]
    create_subst_table(lTerm, "", &counter, &vx)
    counter = 0
    create_subst_table(rTerm, "", &counter, &vx)
    return condition/vx
  }

  public let lTerm : Term
  public let rTerm : Term
  public let condition : Term
  public let id : String
  private var _variables : [Variable:Variable]
  private var _r_variables : [Variable:Variable]
}

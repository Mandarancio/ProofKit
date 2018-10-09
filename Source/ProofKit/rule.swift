import LogicKit
// RULE IDENTIFIER COUNTER
internal var rule_counter = 0;

private func uname(_ s: String) -> String{
  let x = s.components(separatedBy: "#")
  if x.count == 2{
    return "#\(x[1])"
  }
  return s
}

internal func uvariables(_ v: [Variable:Variable])->[Variable:Variable]{
  var vx : [Variable:Variable] = [:]
  for (v1,v2) in v{
    vx[Variable(named: uname(v1.name))] = Variable(named: uname(v2.name))
  }
  return vx
}

//// Proved theorem and axioms data struct
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

    self._lTerm = lT/self._variables
    self._rTerm = rT/self._variables

    self._condition = condition/self._variables
  }


  //Get substitution table of the variables
  public func variables() -> [Variable:Variable]{
    return self._variables
  }

  public func rvariables()  -> [Variable:Variable]{
    return self._r_variables
  }

  //Set new names for variables
  public mutating func set_variables(_ varx: [Variable:Variable]){
    var vars : [Variable:Variable] = [:]
    let vs = uvariables(varx)
    for (k, v) in vs{
      if _variables[v] != nil{
        vars[k] = _variables[v]
      }
    }
    for (k, v) in _variables{
      var check = false
      for (_, x) in vs {
        if x == k {
          check = true
        }
      }
      if !check {
        vars[k] = v
      }
    }
    self._variables = vars
    self._r_variables = reverse_subs_table(self._variables)
  }

  //// Apply axiom to term t and result in r
  public func apply(_ t: Term, _ r: Term)->Goal{
    let x = Variable(named: "cond.x")
    let c = get_result(_condition === x && self._lTerm === t && self._rTerm === r, x)
    return t === self._lTerm && r === self._rTerm && ADTm.eval(c) === Boolean.True()
  }

  //// Pretty print of the axiom
  public func pprint() -> String{
    let lt =  self._lTerm/self._r_variables
    let rt = self._rTerm/self._r_variables

    if _condition.equals(Boolean.True()){
      return "\(ADTm.pprint(lt)) = \(ADTm.pprint(rt))"
    }else{
      let c = self._condition/self._r_variables
      return "if \(ADTm.pprint(c)) then \n\t\(ADTm.pprint(lt)) = \(ADTm.pprint(rt))"
    }
  }

  // equivalence between proofs
  public func equals(_ r: Rule) -> Bool{
    return equivalence(self.lTerm(), r.lTerm()) && equivalence(self.rTerm(), r.rTerm()) && equivalence(self.condition(), r.condition())
  }

  // universaly formatted left term
  public func lTerm() -> Term{
    var counter : Int = 0
    var vx : [Variable:Variable] = [:]
    create_subst_table(_lTerm, "", &counter, &vx)
    return _lTerm/vx
  }

  // universaly formatted right term
  public func rTerm()->Term{
    var counter : Int = 0
    var vx : [Variable:Variable] = [:]
    create_subst_table(_lTerm, "", &counter, &vx)
    counter = 0
    create_subst_table(_rTerm, "", &counter, &vx)
    return _rTerm/vx
  }


  // universaly formatted condition
  public func condition() -> Term{
    var counter : Int = 0
    var vx : [Variable:Variable] = [:]
    create_subst_table(_lTerm, "", &counter, &vx)
    counter = 0
    create_subst_table(_rTerm, "", &counter, &vx)
    return _condition/vx
  }

  // human variable names
  public func h_lTerm() -> Term{
    return _lTerm/_r_variables
  }
  // human variable names
  public func h_rTerm() -> Term{
    return _rTerm/_r_variables
  }

  public func h_condition()->Term{
    return _condition/_r_variables
  }

  private let _lTerm : Term
  private let _rTerm : Term
  private let _condition : Term
  public let id : String
  private var _variables : [Variable:Variable]
  private var _r_variables : [Variable:Variable]
}


extension Rule: CustomStringConvertible {
    public var description: String {
      return self.pprint()
    }
}

public func /(left: Rule, right: [Variable:Variable])->Rule{
  var r = Rule(left.lTerm(),left.rTerm(), left.condition())
  r.set_variables(right)
  return r
}

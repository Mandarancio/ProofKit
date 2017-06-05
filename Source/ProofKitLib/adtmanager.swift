import LogicKit

public var ADTm : ADTManager = ADTManager()
public var op_time = 0
public var s_time = 0

//// To be used to store all the ADTs
public struct ADTManager{

  private var adts : [String:ADT] = [:]
  private var opers : [OperatorFootprint:[Rule]] = [:]
  //
  // public static func instance()->ADTManager{
  //   return ADTs
  // }

  fileprivate init(){
    self["nat"] = Nat()
    self["bool"] = Boolean()
    self["multiset"] = Multiset()
    self["set"] = Set()
    self["sequence"] = Sequence()
    self["int"] = Integer()
    // self["petrinet"] = Petrinet()
    // self["marking"] = Marking()
  }

  public subscript ( i : String) -> ADT{
      get{
        return adts[i]!
      }
      set{
        adts[i] = newValue
        for op in newValue.get_operators(){
          self.opers[op] = newValue.a(op)
        }
      }
  }


  public func get_adts() -> [String] {
    return Array(self.adts.keys)
  }

  private func replace(_ t: Term, _ s: Substitution) -> Term{
    if t is Variable{
      return s[t]
    }
    if let m = (t as? Map){
      var nm = m
      for (k,v) in m{
        nm = nm.with(key: k, value: self.replace(v, s))
      }
      return nm
    }
    return t
  }
 /// GOAL Solver
  public func geval (operation: Term, result: Term) -> Goal {
    return inEnvironment { state in
        let x = self.replace(operation, state)
        return self.eval(x) === result
     }
  }

  public func eval(_ term: Term) -> Term {
    if term.equals(vNil){
      return vNil
    }
    if Operator.is_operator(term) {

      if let op = (term as? Map){
        let k : Term = Operator.eval(op)
        let footprint = Operator.get_footprint(k)

        let tk = mills()
        var axioms = self.opers[footprint]

        if axioms == nil {
          axioms = self.find_polyoper(footprint)
        }

        op_time += (mills()-tk)
        if  axioms!.count > 0{
          let tk = mills()
          let res = resolve(k, axioms!)
          s_time += (mills()-tk)
          if res.equals(op){
            return op
          }
          return self.eval(res)
        }
        return k
      }
    }
    return ADT.eval(term)
  }

  private func find_polyoper(_ footprint: OperatorFootprint) -> [Rule]{
    for (k, v) in self.opers{
      if k == footprint{
        return v
      }
    }
    return []
  }


  public func pprint(_ term: Term) -> String{
    if term.equals(vNil){
      return "nil"
    }

    if let v = (term as? Variable) {
      let name = v.name
      let ks = name.components(separatedBy:"$")
      if ks.count == 2{
        return "$"+ks[1]
      }
      return name
    }

    if Operator.is_operator(term){
      return Operator.pprint(term)
    }

    let ty = type(term)
    if ty != "none" && ty != "any"{
      if self.adts[ty] != nil{
        let adt = self.adts[ty]!
        return adt.pprint(term)
      }
    }

    if let op = (term as? Value<Int>){
      return op.description
    }
    if let op = (term as? Value<String>){
      return op.description
    }

    return "?"
  }
}

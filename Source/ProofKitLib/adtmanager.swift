import LogicKit

internal let ADTs : ADTManager = ADTManager()

//// To be used to store all the ADTs
public struct ADTManager{

  private var adts : [String:ADT] = [:]
  private var opers : [OperatorFootprint:[Rule]] = [:]

  public static func instance()->ADTManager{
    return ADTs
  }

  fileprivate init(){
    self["nat"] = Nat()
    self["boolean"] = Boolean()
    self["multiset"] = Multiset()
    // self["set"] = Set()
    // self["sequence"] = Sequence()
    self["int"] = Integer()
    // print(self.opers)
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

  public func eval(_ term: Term) -> Term {
    if term.equals(vNil){
      return vNil
    }
    if Operator.is_operator(term) {
      if let op = (term as? Map){
        let k : Term = Operator.eval(op)
        let footprint = Operator.get_footprint(k)
        if  self.opers[footprint] != nil{
          let axioms = self.opers[footprint]!
          let res = resolve(k, axioms)
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
        return adt.pprint(value(term))
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

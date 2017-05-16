import LogicKit

internal let ADTs : ADTManager = ADTManager()

//// To be used to store all the ADTs
public struct ADTManager{

  public static func instance()->ADTManager{
    return ADTs
  }

  fileprivate init(){
    self["nat"] = Nat()
    self["boolean"] = Boolean()
    self["multiset"] = Multiset()
    self["set"] = Set()
    self["sequence"] = Sequence()
    self["int"] = Integer()
  }

  public subscript ( i : String) -> ADT{
      get{
        return adts[i]!
      }
      set{
        adts[i] = newValue
      }
  }

  private var adts : [String:ADT] = [:]

  public func get_adts() -> [String] {
    return Array(self.adts.keys)
  }

  public func eval(_ term: Term) -> Term {
    if term.equals(vNil){
      return vNil
    }
    for (_,adt) in self.adts{
      if adt.check(term){
        return adt.eval(term)
      }
    }

    if let op = (term as? Map){
      if Operator.is_operator(op) {

        let name = (op["name"] as! Value<String>).description
        let k : Term = Operator.eval(op)
        for (_,adt) in self.adts{
          if adt.get_operators().contains(name) {
            let axioms = adt.a(name)
            let res = resolve(k, axioms)
            if res.equals(op){
              return op
            }
            return self.eval(res)
          }
        }

      }
      return op
    }
    return term
  }

  public func pprint(_ term: Term) -> String{
    if term.equals(vNil){
      return "nil"
    }
    for (_,adt) in self.adts{
      if adt.check(term){
        return adt.pprint(term)
      }
    }
    if let op = (term as? Map){
      if Operator.is_operator(op){
        return Operator.pprint(op)
      }
      return op.description
    }
    if let op = (term as? Value<Int>){
      return op.description
    }
    if let op = (term as? Value<String>){
      return op.description
    }
    if let op = (term as? Variable) {
      let name = op.description
      let ks = name.components(separatedBy:"$")
      if ks.count == 2{
        return "$"+ks[1]
      }
      return name
    }
    return "?"
  }
}

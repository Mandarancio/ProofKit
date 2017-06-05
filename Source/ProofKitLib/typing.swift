import LogicKit

public var ncalls = 0

public struct ADTerm {
    public let type : String
    public let value : Term
    public init(value: Term, type: String){
      self.type = type
      self.value = Term
    }
}

public func new_term(_ term: Term, _ type: String) -> Term{
  return Map([
    "type": Value<String>(type),
    "value": term
  ])
}

public func type(_ term: Term) -> String{
  if let tm = (term as? Map){
    if let tp = (tm["type"] as? Value<String>){
      return tp.description
    }
  }
  return "unknown"
}

public func value(_ term: Term)->Term{
  ncalls += 1
  if let tm = (term as? Map){
    if tm["value"] != nil{
      return tm["value"]!
    }
  }
  return vNil
}

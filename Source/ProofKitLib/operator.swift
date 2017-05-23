import LogicKit

////
public struct OperatorFootprint {
  public let types : [String]
  public let name : String
  public init(_ name: String,_ ts: [String]){
    self.types = ts
    self.name = name
  }

  public func arity() -> Int {
    return types.count
  }
}

extension OperatorFootprint: Hashable {
  public var hashValue: Int {
    var hash = name.hashValue
    for ty in types{
      hash = hash ^ ty.hashValue
    }
    return hash
  }

  public static func == (lhs: OperatorFootprint, rhs: OperatorFootprint) -> Bool {
    return lhs.name == rhs.name && lhs.types == rhs.types
  }
}

//// Basic form of an operator
public struct Operator{
  public static let vType : Value<String> = Value<String>("operator")
  public static func n( _ name: String,_ ops: Term...) -> Map{
    var o : Map = [
      "type": vType,
      "operator" : vType,
      "arity" : Value<Int>(ops.count),
      "name" : Value<String>(name)
    ]
    var i = 0
    for op in ops{
      o = o.with(key: String(i), value: op)
      i += 1
    }
    return o
  }

  public static func n(_ name: String, _ ops: [Term]) -> Map{
    var o : Map = [
      "type": vType,
      "operator" : vType,
      "arity" : Value<Int>(ops.count),
      "name" : Value<String>(name)
    ]
    var i = 0
    for op in ops{
      o = o.with(key: String(i), value: op)
      i += 1
    }
    return o
  }
  public static func get_name(_ t: Term) -> String{
    if let m = (t as? Map){
      return Operator.get_name(m)
    }
    return "?"
  }

  public static func get_name(_ m: Map) -> String{
    if let n = (m["name"] as? Value<String>){
      return n.wrapped
    }
    return "?"
  }
  public static func get_footprint(_ t: Term)-> OperatorFootprint
  {
    if let m=(t as? Map){
      return get_footprint(m)
    }
    return OperatorFootprint("none", [])
  }

  public static func get_footprint(_ m: Map) -> OperatorFootprint{
    let name = Operator.get_name(m)
    var operands : [String] = []
    let arity = Operator.arity(m)
    for i in 0...arity-1{
      operands.append(type(m[String(i)]!))
    }
    return OperatorFootprint(name, operands)
  }

  public static func is_operator(_ t: Term)->Bool{
    if let op = (t as? Map){
      if (op["operator"] != nil){
        return vType.equals(op["operator"]!)
      }
    }
    return false
  }

  public static func arity(_ t: Term)-> Int{
    if let m = (t as? Map){
      return Operator.arity(m)
    }
    return 0
  }

  public static func arity(_ t: Map) -> Int{
    if let v = (t["arity"] as? Value<Int>){
      return v.wrapped
    }
    return 0
  }

  public static func eval(_ t: Term)->Term{
    if let m = (t as? Map){
      var nm = m
      for (k,w) in m{
        nm = nm.with(key:k, value:ADTs.eval(w))
      }
      return nm
    }
    return t
  }

  public static func pprint(_ t: Term)->String{
    if let m = (t as? Map){
      let name: String = (m["name"]! as! Value<String>).description
      if m.keys.count == 4{
        return "(\(ADTs.pprint(m["0"]!)) \(name) \(ADTs.pprint(m["1"]!)))"
      }else{
        let arity = Operator.arity(m)
        var s :String = "\(name)(\(ADTs.pprint(m["0"]!))"
        if arity>1{
          for i in 1...arity-1{
            s+=", \(ADTs.pprint(m[String(i)]!))"
          }
        }
        return s+")"
      }
    }
    return "??"
  }
}

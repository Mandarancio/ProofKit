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

extension OperatorFootprint: CustomStringConvertible {
    public var description: String {
      var s = "\(self.name)(\(self.types[0])"
      if self.types.count > 1{
        for i in 1...self.types.count-1{
          s += ", \(self.types[i])"
        }
      }
      s += ")"
      return s
    }
}

extension OperatorFootprint: Hashable {
  public var hashValue: Int {
    var hash = name.hashValue
    for ty in types{
      if ty != "any"{
        hash = hash ^ ty.hashValue
      }
    }
    return hash
  }

  public static func == (lhs: OperatorFootprint, rhs: OperatorFootprint) -> Bool {
    // print(" - \(lhs)")
    if lhs.name != rhs.name{
      return false
    }
    // print(" -- name passed")
    if lhs.types.count != rhs.types.count{
      return false
    }
    // print(" -- arity passed")
    for i in 0...lhs.types.count-1{
      if lhs.types[i] != rhs.types[i] && (lhs.types[i] != "any" && rhs.types[i] != "any"){
        return false
      }
    }
    // print("\(lhs) == \(rhs)")
    return true
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
        nm = nm.with(key:k, value:ADTm.eval(w))
      }
      return nm
    }
    return t
  }

  public static func pprint(_ t: Term)->String{
    if let m = (t as? Map){
      let name: String = (m["name"]! as! Value<String>).wrapped
      let arity: Int = (m["arity"]! as! Value<Int>).wrapped
      if arity == 2{
        return "(\(ADTm.pprint(m["0"]!)) \(name) \(ADTm.pprint(m["1"]!)))"
      }else{
        var s :String = "\(name)(\(ADTm.pprint(m["0"]!))"
        if arity>1{
          for i in 1...arity-1{
            s+=", \(ADTm.pprint(m[String(i)]!))"
          }
        }
        return s+")"
      }
    }
    return "??"
  }
}

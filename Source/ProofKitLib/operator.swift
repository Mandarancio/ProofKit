import LogicKit

//// Basic form of an operator
public struct Operator{
  public static let vType : Value<String> = Value<String>("operator")
  public static func n( _ name: String,_ ops: Term...) -> Map{
    var o : Map = [
      "type" : Operator.vType,
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
      "type" : Operator.vType,
      "name" : Value<String>(name)
    ]
    var i = 0
    for op in ops{
      o = o.with(key: String(i), value: op)
      i += 1
    }
    return o
  }
  public static func n(_ name: Value<String>, _ ops: [Term]) -> Map{
    var o : Map = [
      "type" : Operator.vType,
      "name" : name
    ]
    var i = 0
    for op in ops{
      o = o.with(key: String(i), value: op)
      i += 1
    }
    return o
  }

  public static func is_operator(_ t: Term)->Bool{
    if let op = (t as? Map){
      return vType.equals(op["type"]!)
    }
    return false
  }

  public static func eval(_ t: Term)->Term{
    if let m = (t as? Map){
      let name: Value<String> = m["name"]! as! Value<String>
      var a : [Term] = []
      for i in 0...m.keys.count-3{
        let tmp : Term = ADTs.eval(m[String(i)]!)
        a.insert(tmp,at: i)

      }
      return Operator.n(name,a)
    }
    return t
  }
  public static func pprint(_ t: Term)->String{
    if let m = (t as? Map){
      let name: String = (m["name"]! as! Value<String>).description
      if m.keys.count == 4{
        return "(\(ADTs.pprint(m["0"]!)) \(name) \(ADTs.pprint(m["1"]!)))"
      }else{
        var s :String = "\(name)(\(ADTs.pprint(m["0"]!))"
        if m.keys.count>3{
          for i in 1...m.keys.count-3{
            s+=", \(ADTs.pprint(m[String(i)]!))"
          }
        }
        return s+")"
      }
    }
    return "??"
  }
}

import LogicKit
import Foundation

//// SINGLETON ADT Manager
public let ADTs = ADTManager()

//// namespace containing all the operations to prove an axiom
struct Proof {
  public func subst(_ t: Term, _ x: Term, _ st: Term, _ r: Term)-> Goal{
    return x === st && r === t
  }
}

//// This base class contains all needed information to define a datatype
public class ADT{
  public let name : String
  private var _axioms : [String:[Rule]]
  private var _operators : [String: (Term ...) ->Term]
  private var _arity : [String: Int]
  private var _generators : [String :  (Term...)->Term]
  private var _gen_arity : [String : Int]

  public init(_ name: String){
    self.name = name
    self._generators = [:]
    self._operators = [:]
    self._axioms = [:]
    self._arity = [:]
    self._gen_arity = [:]
  }

  subscript ( i : String) -> ((Term...)->Term){
      get{
        if _generators[i] != nil{
          return _generators[i]!
        }
        return _operators[i]!
      }
      set{
      }
  }

  //// GOAL To detect if a term belongs to an ADT
  public class func belong(_ term: Term ) -> Goal {
        return Boolean.isTrue(Boolean.True())
  }

  //// Boolean check if a term belongs to an ADT (used by ADTManager)
  public func check(_ term: Term) -> Bool{
    return false
  }

  //// Function to nicely print a TERM belonging to an ADT
  public func pprint(_ term: Term) -> String{
    return ""
  }

  //// Retrive axioms for an operation
  public func get_axioms(_ name: String) -> [Rule]{
    return self._axioms[name]!
  }

  //// Shortcut to retrive axioms
  public func a(_ name: String) -> [Rule] {
    return self.get_axioms(name)
  }


  //// Internal use only
  internal func add_generator(_ name: String, _ generator: @escaping((Term...)->Term), arity: Int = 0){
    self._generators[name] = generator
    self._gen_arity[name] = arity
  }
  //// Internal use only
  internal func add_operator(_ name: String, _ oper: @escaping((Term...)->Term), _ axioms: [Rule], arity: Int = 2){
    self._operators[name] = oper
    self._arity[name] = arity
    self._axioms[name] = axioms
  }

  //// Retrive operator generator
  public func get_operator(_ name: String)-> ((Term...)->Term){
    return  self._operators[name]!
  }

  //// Shortcut to retrive an operator generator
  public func o(_ name: String)-> ((Term...)->Term){
    return self.get_operator(name)
  }

  //// Retrive adt generator
  public func get_generator(_ name: String) -> ((Term...)->Term) {
    return self._generators[name]!
  }

  //// Shortcut for generator
  public func g(_ name: String) -> ((Term...)->Term) {
    return self.get_generator(name)
  }

}

//// To be used to store all the ADTs
public struct ADTManager{
  fileprivate init(){
    self["nat"] = Nat()
    self["boolean"] = Boolean()
    self["llist"] = LList()
  }

  subscript ( i : String) -> ADT{
      get{
        return adts[i]!
      }
      set{
        adts[i] = newValue
      }
  }

  private var adts : [String:ADT] = [:]

  public func pprint(_ term: Term) -> String{
    if term.equals(Value("nil")){
      return ""
    }
    for (_,adt) in self.adts{
      if adt.check(term){
        return adt.pprint(term)
      }
    }
    if let op = (term as? Map){
      if op["name"] != nil && op["lhs"] != nil && op["rhs"] != nil {
        let x = (op["name"] as! Value<String>)
        return self.pprint(op["lhs"]!)+" "+x.description+" "+self.pprint(op["rhs"]!)
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

//// Basic form of an operator
public struct Operator{
  public static func n(_ lhs: Term, _ rhs: Term, _ name: String) -> Map{
    return Map([
      "name" : Value(name),
      "lhs" : lhs,
      "rhs" : rhs
    ])
  }
}

//// Proved tehorem and axioms data struct
public struct Rule {
  init(_ lT : Term,_ rT: Term){
    self.lTerm = lT
    self.rTerm = rT
  }
  //// Applay axiom to term t and result in r
  public func applay(_ t: Term, _ r: Term)->Goal{
    return t === self.lTerm && r === self.rTerm
  }
  //// Pretty print of the axiom
  public func pprint() -> String{
    return ADTs.pprint(self.lTerm)+" = "+ADTs.pprint(self.rTerm)
  }

  public let lTerm : Term
  public let rTerm : Term
}

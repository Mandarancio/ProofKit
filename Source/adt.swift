import LogicKit

public enum Direction {
  case right
  case left
}

struct Proof {
  public func subst(_ t: Term, _ x: Term, _ st: Term, _ r: Term)-> Goal{
    return x === st && r === t
  }
}

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
  
  public class func belong(_ term: Term ) -> Goal {
        return Boolean.isTrue(Boolean.True())
  }

  public func get_axioms(_ name: String) -> [Rule]{
    return self._axioms[name]!
  }
  public func a(_ name: String) -> [Rule] {
    return self.get_axioms(name)
  }
  
  internal func add_generator(_ name: String, _ generator: @escaping((Term...)->Term), arity: Int = 0){
    self._generators[name] = generator
    self._gen_arity[name] = arity
  }
  
  internal func add_operator(_ name: String, _ oper: @escaping((Term...)->Term), _ axioms: [Rule], arity: Int = 2){
    self._operators[name] = oper
    self._arity[name] = arity
    self._axioms[name] = axioms
  }
  
  public func get_operator(_ name: String)-> ((Term...)->Term){
    return  self._operators[name]!
  }
  
  public func o(_ name: String)-> ((Term...)->Term){
    return self.get_operator(name)
  }
  
  public func get_generator(_ name: String) -> ((Term...)->Term) {
    return self._generators[name]!
  }
  
  public func g(_ name: String) -> ((Term...)->Term) {
    return self.get_generator(name)
  }
  
}

public struct ADTManager{
  public init(){
    self.adts = [:]
  }

  public mutating func add_adt(_ name: String, _ adt : ADT){
    self.adts[name]=adt
  }

  public func get_adt(_ name: String) -> ADT?{
    return self.adts[name]
  }

  public func get_axioms(adt : String, op : String) -> [Rule]?{
    return self.adts[adt]?.get_axioms(op)
  }
  private var adts : [String:ADT] = [:]
}

public struct Operator{
  public static func n(_ lhs: Term, _ rhs: Term, _ name: String) -> Map{
    return Map([
      "name" : Value(name),
      "lhs" : lhs,
      "rhs" : rhs
    ])
  }
}

public struct Rule {
  init(_ lT : Term,_ rT: Term){
    self.lTerm = lT
    self.rTerm = rT
  }

  public func applay(_ t: Term, _ r: Term)->Goal{
    return t === self.lTerm && r === self.rTerm
  }

  public let lTerm : Term
  public let rTerm : Term
}

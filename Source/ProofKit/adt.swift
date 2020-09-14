import SwiftKanren

enum MyError : Error {
    case RuntimeError(String)
}

//// This base class contains all needed information to define a datatype
open   class ADT{
  var _name : String
  private var _axioms : [OperatorFootprint:[Rule]]
  private var _operators : [OperatorFootprint: (Term ...) ->Term]
  private var _generators : [String :  (Term...)->Term]
  private var _gen_arity : [String : Int]

  public init(_ name: String){
    self._name = name
    self._generators = [:]
    self._operators = [:]
    self._axioms = [:]
    self._gen_arity = [:]
  }

  public subscript ( i : String) -> ((Term...)->Term)
  {
      get{
        for (o, v) in self._operators{
          if o.name == i{
            return v
          }
        }
        return _generators[i]!
      //  throw MyError.RuntimeError("No operator \(i) found")
      }
      set{
      }
  }

  public func name() -> String {
    return self._name
  }
  // eval operation for each ADT
  public static func eval(_ t: Term)-> Term{
    if let tm = (t as? Map){
        var om = tm
      for (k, v) in tm{
        om = om.with(key: k, value: ADTm.eval(v))
      }
      return om
    }
    return t
  }

  public func get_operators() -> [OperatorFootprint]{
    return Array(self._operators.keys)
  }

  public func get_generators() -> [String]{
    return Array(self._generators.keys)
  }

  //// GOAL To detect if a term belongs to an ADT
  //// TODO Implement in each ADT sub-class
  open class func belong(_ term: Term ) -> Goal {
        return Boolean.isTrue(Boolean.True())
  }

  //// Boolean check if a term belongs to an ADT (used by ADTManager)
  open func check(_ term: Term) -> Bool{
    return type(term) == self._name
  }

  //// Function to nicely print a TERM belonging to an ADT
  //// TODO Implement in each ADT sub-class
  open func pprint(_ term: Term) -> String{
    if let v = (term as? Variable){
      return v.name
    }
    if let v = (term as? Value<String>){
      return v.wrapped
    }
    if let v = (term as? Value<Int>){
      return "\(v.wrapped)"
    }
    if let v = (term as? Map){
      return v.description
    }
    return ""
  }

  //// Retrieve axioms for an operation
  public func get_axioms(_ name: OperatorFootprint) -> [Rule]{
    return self._axioms[name]!
  }

  //// Shortcut to retrieve axioms
  public func a(_ name: OperatorFootprint) -> [Rule] {
    return self.get_axioms(name)
  }

  //// Super shortcut:
  public func a(_ name: String) -> [Rule]{
    for (of,a) in self._axioms{
      if of.name == name{
        return a
      }
    }
    return []
  }

  //// Internal use only
  public func add_generator(_ name: String, _ generator: @escaping((Term...)->Term), arity: Int = 0){
    self._generators[name] = generator
    self._gen_arity[name] = arity
  }

  //// Internal use only
  public func add_operator(_ name: String, _ oper: @escaping((Term...)->Term), _ axioms: [Rule], _ types: [String]){
    let ofoot = OperatorFootprint(name, types)
    self._operators[ofoot] = oper
    self._axioms[ofoot] = axioms
  }

  public func remove_operator(_ name: OperatorFootprint){
    self._operators[name] = nil
  }

  //// Retrieve operator generator
  public func get_operator(_ name: OperatorFootprint)-> ((Term...)->Term){
    return  self._operators[name]!
  }

  //// Shortcut to retrieve an operator generator
  public func o(_ name: OperatorFootprint)-> ((Term...)->Term){
    return self.get_operator(name)
  }

  //// Retrieve adt generator
  public func get_generator(_ name: String) -> ((Term...)->Term) {
    return self._generators[name]!
  }

  //// Shortcut for generator
  public func g(_ name: String) -> ((Term...)->Term) {
    return self.get_generator(name)
  }

  public func garity(_ name: String)-> Int{
    return self._gen_arity[name]!
  }
}

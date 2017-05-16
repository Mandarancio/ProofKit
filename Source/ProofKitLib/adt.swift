import LogicKit


//// This base class contains all needed information to define a datatype
public class ADT{
  var _name : String
  private var _axioms : [String:[Rule]]
  private var _operators : [String: (Term ...) ->Term]
  private var _arity : [String: Int]
  private var _generators : [String :  (Term...)->Term]
  private var _gen_arity : [String : Int]

  public init(_ name: String){
    self._name = name
    self._generators = [:]
    self._operators = [:]
    self._axioms = [:]
    self._arity = [:]
    self._gen_arity = [:]
  }

  public subscript ( i : String) -> ((Term...)->Term){
      get{
        if _generators[i] != nil{
          return _generators[i]!
        }
        return _operators[i]!
      }
      set{
      }
  }

  public func name() -> String {
    return self._name
  }

  public func eval(_ t: Term)-> Term{
    return t
  }

  public func get_operators() -> [String]{
    return Array(self._operators.keys)
  }

  public func get_generators() -> [String]{
    return Array(self._generators.keys)
  }

  //// GOAL To detect if a term belongs to an ADT
  //// TODO Implement in each ADT sub-class
  public class func belong(_ term: Term ) -> Goal {
        return Boolean.isTrue(Boolean.True())
  }

  //// Boolean check if a term belongs to an ADT (used by ADTManager)
  //// TODO Implement in each ADT sub-class
  public func check(_ term: Term) -> Bool{
    return false
  }

  //// Function to nicely print a TERM belonging to an ADT
  //// TODO Implement in each ADT sub-class
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

  internal func remove_operator(_ name: String){
    self._operators[name] = nil
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

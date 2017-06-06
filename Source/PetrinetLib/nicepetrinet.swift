import LogicKit
import ProofKitLib

public class NiceMarking {

  private var onPetrinet : NicePetrinet
  private var tokens : [String:UInt]

  public init(onPetrinet: NicePetrinet){
    self.onPetrinet = onPetrinet
    self.tokens = [:]
  }

  public subscript(str: String) -> UInt? {
    get {
      return tokens[str]
    }
    set {
      tokens[str] = newValue
    }
  }

  public func as_term() -> Term {
    let vec = DynamicVector()

    for (place, tokensNb) in tokens {
      vec[Int(onPetrinet.get_place_index(p:place))] = Int(tokensNb)
    }

    var term = Marking.null()

    for i in 0 ... (onPetrinet.get_places_count() - 1) {
      term = Marking.next_place(Nat.n(vec[i]), term)
    }

    return term
  }

    public func to_array() -> [Int] {
      return Marking.to_array(as_term())
    }

    public func to_vector() -> DynamicVector {
      return DynamicVector(to_array())
    }

    public func to_string() -> String {
    //TODO do better
      return Marking.to_string(as_term())
    }

  public func has_enough(weight:UInt, p:String) -> Bool{
    let res = onPetrinet.adtm.eval(Marking.has_enough(as_term(), Integer.n(Int(weight)), Nat.n(Int(onPetrinet.get_place_index(p:p)))))
    return Boolean.to_bool(res)
  }
}


public class NicePetrinet {

  public var adtm : ADTManager

  private var places_indexes : [String:Int]
  private var transitions_indexes : [String:Int]

  private var term : Term

  public init(adtm:ADTManager){
    self.term = Petrinet.null()
    self.adtm = adtm

    self.places_indexes = [:]
    self.transitions_indexes = [:]
  }

  public func get_places_count() -> Int {
    return places_indexes.count
  }

  public func get_transitions_count() -> Int {
    return transitions_indexes.count
  }

  public func get_place_index(p:String) -> UInt {
    return UInt(places_indexes[p]!)
  }

  public func get_transition_index(t:String) -> UInt? {
    return UInt(transitions_indexes[t]!)
  }

  public func add_place(p:String) -> () {
    places_indexes[p] = places_indexes.count
  }

  public func add_transition(t:String) -> () {
    transitions_indexes[t] = transitions_indexes.count
  }

    public func add_input_edge(p:String, t:String, weight:UInt) -> () {
      term = Petrinet.add_edge(Nat.n(places_indexes[p]!), Nat.n(transitions_indexes[t]!), Integer.n(Int(weight)), term)
    }

    public func add_output_edge(t:String, p:String, weight:UInt) -> () {
      term = Petrinet.add_edge(Nat.n(places_indexes[p]!), Nat.n(transitions_indexes[t]!), Integer.n(0-Int(weight)), term)
    }

    public func is_p_invariant(p_invariant: [Int]) -> Bool {
      return incidence_matrix().is_p_invariant(DynamicVector(p_invariant))
    }

    public func is_t_invariant(t_invariant: [Int]) -> Bool {
      return incidence_matrix().is_t_invariant(DynamicVector(t_invariant))
    }

  public func incidence_matrix() -> DynamicMatrix {
        return Petrinet.to_matrix(term)
  }

  public func as_term() -> Term {
    return self.term
  }

  public func to_string() -> String {
    return Petrinet.to_nice_string(as_term(), places_indexes, transitions_indexes)
  }

  public func is_triggerable(t:String, marking:NiceMarking) -> Bool{
    let res = adtm.eval(Petrinet.is_triggerable(term, Nat.n(transitions_indexes[t]!), marking.as_term()))
    return Boolean.to_bool(res)
  }

}

public struct InputEdge {
  public var p:String
  public var t:String
  public var weight:UInt
  public init(p:String, t:String, weight:UInt) {
    self.p = p
    self.t = t
    self.weight = weight
  }
}

public struct OutputEdge {
  public var t:String
  public var p:String
  public var weight:UInt
  public init(t:String, p:String, weight:UInt) {
    self.t = t
    self.p = p
    self.weight = weight
  }
}

public struct Place {
  public var p_str:String
  public init(_ p:String) {p_str=p}
}

public struct Transition {
  public var t_str:String
  public init(_ t:String) {t_str=t}
}

public func +(_ net:NicePetrinet, _ p:Place) -> NicePetrinet {
  net.add_place(p:p.p_str)
  return net
}

public func +(_ net:NicePetrinet, _ t:Transition) -> NicePetrinet {
  net.add_transition(t:t.t_str)
  return net
}

public func +(_ net:NicePetrinet, _ edge:InputEdge) -> NicePetrinet {
  net.add_input_edge(p:edge.p, t:edge.t, weight:edge.weight)
  return net
}

public func +(_ net:NicePetrinet, _ edge:OutputEdge) -> NicePetrinet {
  net.add_output_edge(t:edge.t, p:edge.p, weight:edge.weight)
  return net
}

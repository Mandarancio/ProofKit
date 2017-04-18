# ProofKit
Proof verifier based on LogicKit

## To compile and run
Few helper script are avaiable:
```bash
./build.sh
./run.sh
```
or 
```bash
./buildandrun.sh
```

## ADT
An ADT is defined as a ```struct``` containing some static public function defining both **generators**, **operations** and a *is_ADTTYPE* function, more over other helper function can be added, for example the *Nat* are defined as:
```swift
public struct Nat{
  /*
  * GENERATORS
  */
  static public func zero() -> Term{
    return Value<Int>(0)
  }

  static public func succ(x: Term) -> Term {
    return Map(["succ": x])
  }

  /**
  * HELPERS
  */
  static public func n(_ x: Int) -> Term {
  	if x==0{
  		return Nat.zero()
  	}

    var t = Nat.zero()
  	for _ in 1..<x+1 {
  		t = Nat.succ(x: t)
  	}
    return t
  }

  // Check if
  static public func is_nat(_ x: Term) -> Goal{
    return (x === Nat.zero() || delayed(fresh {y in x === Nat.succ(x:y) && Nat.is_nat(y)}))
  }

  // Simple helper to print the nat as string
  static public func count(_ x: Term) -> String{
   	if x.equals(Nat.zero()){
   		return "0"
   	}
   	if let map = (x as? Map){
      let k = Nat.count(map["succ"]!)
      let f = k.components(separatedBy:"+")
      if f.count == 1{
        return String(1+Int(k)!)
      }
      if f[0].characters.count == 0 {
   		   return "1+"+f[1]
      }
      return String(1+Int(f[0])!)+"+"+f[1]
   	}
    if x is Variable {
      return "+"+(x as! Variable).description
    }
   	return "+?"
  }

  /*
  * OPERATIONS
  */
  public static func add(_ l: Term, _ r: Term) -> Map{
      let o =  Operator.n(l, r, "N+")
      return o
  }
}
```

### Axioms
For every operation is important to add its relative axioms, for the natural addition:
```
x+0 === 0
x+s(y) === s(x+y)
```
This axioms are stored in form of ```Rule``` an object containing the right and the left part of the axiom in a public list in ```adt.swift``` in this form:

```swift
public  let axioms : [String: [Rule]] = [
  "B!": [
    Rule(Boolean.not(Boolean.False()),Boolean.True()),
    Rule(Boolean.not(Boolean.True()),Boolean.False())
  ],
  "B.or": [
    Rule(Boolean.or(Boolean.True(),Variable(named:"B.or.0.$1")),Boolean.True()),
    Rule(Boolean.or(Variable(named:"B.or.1.$1"),Boolean.True()),Boolean.True()),
    Rule(Boolean.or(Boolean.False(),Boolean.False()),Boolean.False())
  ],
  "B.and":[
    Rule(Boolean.and(Boolean.False(),Variable(named:"B.and.0.$1")),Boolean.False()),
    Rule(Boolean.and(Variable(named:"B.and.1.$1"),Boolean.True()),Boolean.False()),
    Rule(Boolean.and(Boolean.True(),Boolean.True()),Boolean.True())
  ],
  "N+": [Rule(Nat.add(Variable(named: "N+.0.$1"), Value(0)),
              Variable(named: "N+.0.$1")),
         Rule(Nat.add(Variable(named: "N+.1.$1"), Nat.succ(x: Variable(named: "N+.1.$2"))),
              Nat.succ(x: Nat.add(Variable(named: "N+.1.$1"),Variable(named:"N+.1.$2"))))]
]
```

The syntax used for the name of variable is very important to avoid any confusion of variable during futures substitutions.

In the future I suggest to implement some kind of axioms and adt manager, as well as a pre processing for the variables name.

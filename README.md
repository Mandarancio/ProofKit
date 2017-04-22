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

## Current Status
Currently implemented ADT and Operators

|ADT|Base ADT|Generators|Constructor|Operators|
|---|--------|----------|-----------|---------|
|Boolean|ADT|```True() False()```|```n(Bool)```|```not(x) and(x,y) or(x,y)```|
|Nat|ADT|```zero() succ(x)```|```n(Int)```|```add(x,y) mul(x,y)```|
|LinkedList|ADT|```empty() cons(first, rest)```|```n([Terms])```|```first(x) rest(x) contains(x,y) size(x) concat(x,y)```|
|Set|LinkedList|```insert(x,y)```||```union(x,y) subSet(x,y) intersection(x,y) difference```|

## Operator

This *struct* is just an helper to uniform the way operators are implemented. The choosen structure is a **Map** with the operation name and the left and right operands.
To create a generic operator:
```swift
let r : Term = Operator.n(Nat.n(1), Nat.n(2), "+") ////1 + 2
```
However each adts will implement its operator generator (based on this one) for more uniformity.

## Rule
The *struct* **Rule** is the container of **axioms** and future **theorems**. Is composed in left and right components (both Term) and implement both a function to applay the rule and one to *pretty print* it.
To create a rule simply:
```swift
let r = Rule(
  Nat.add(Variable(named: "x"), Nat.zero()), // left component
  Variable(named: "x") // right component
)
```
The to use it:
```swift
// pretty print it
print(r.pprint()) // print => x + 0 = x

// create gaol to applay rule
let g : Goal = r.applay(Nat.add(Nat.n(4),Nat.zero()), Variable(named: x))
let res : Term = get_result(g,x) //function solve goal and return the substitution of x
// res => Nat.n(4)
```

## ADT
All ADTs extend the base *class* **ADT**, this contains both generator, opertors generator and operators axioms as well as some basic helpers such a chek type and a *pretty print* function.

To access to axioms, generators and operators there are always two method a long and a shortcut, e.g. ```get_generator("name")``` and ```g("name")```.

For both **generators** and **operators** is possible to access just using ```["name"]```.

Adding operators and axioms is possible **only internally**.
A simple example is a semplfied version of the boolean adt:
```swift
public class Boolean : ADT {
    public init(){
      super.init("boolean")
      self.add_generator("true", Boolean.True)
      self.add_generator("false", Boolean.False)
      self.add_operator("not", Boolean.not, [
        Rule(Boolean.not(Boolean.False()),Boolean.True()),
        Rule(Boolean.not(Boolean.True()),Boolean.False())
      ], arity: 1)
    }
    public static func True(_:Term...) -> Term{
      return Value<Bool>(true)
    }

    public static func False(_:Term...) -> Term{
      return Value<Bool>(false)
    }

    public static func not(_ operands: Term...)->Term{
      return Operator.n(Value("nil"), operands[0], "not")
    }
}
```

### Evaluator

The ```eval``` method is a simple function to evaluate the generator of the type to be able to evaluate nested operations.

## ADTManager

Finally to manage the *ADT* and have the possibility to mixit togheter in the future we use an **ADTManager**. This is composed by a dictionary of ADT and some helper function (such as the *pretty printer*).

To avoid the creation of multiple ADTManager, there is a single ADTManager (as the constructor is private) instance called **ADTs**.

To get or add an ADT from the instance **ADTs**:
```swift
let nat : ADT = ADTs["nat"] // to get adt
/// or
ADTs["boolean"] = Boolean() // to add adt
```
To pretty print any term:
```swift
let nat : ADT = ADTs["nat"] // to get adt
let t = nat["+"](nat["succ"](nat["zero"]()),nat["succ"](nat["zero"]))
print("\(ADTs.pprit(t))") //// 1 + 1
```

### Universal Evaluator

A simple inner most universal evaluator is implemented. To use it:
```swift
let operation : Term = ADTs["nat"]["*"](Nat.n(2),Nat.n(3))
let result : Term = ADTs.eval(operation)
print(" \(ADTs.pprint(operation)) => \(ADTs.pprint(result))")
//// 2 * 3 => 6
```

To be able to perform any type of computation it trys to solve the inner most operation first using the operation axioms and the generator evaluator.

## Example

A simple example using only the ADTManager and applaying one axiom:

```swift
let o = ADTs["nat"]["+"](Nat.n(2), Nat.n(1))
print(" axiom 1: \(ADTs["nat"].a("+")[1].pprint())")
let g : Goal = ADTs["nat"].a("+")[1].applay(o,x) //applay axiom 1
let res : Term = get_result(g,x) //function solve goal and return the substitution of x
print(" \(ADTs.pprint(o)) => \(ADTs.pprint(res))")
```

results in:
```
axiom 1: $1 + succ($2) = succ($1 + $2)
2 + 1 => succ(2 + 0)
```

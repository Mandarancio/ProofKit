# PetrinetLib

Small Library to manipulate Petri nets based on ProofKit to use ADTs as internal representation for proofs.

## Current Status
Currently implemented ADT and Operators

|ADT|Generators|Operators|
|---|----------|---------|
|Marking|```null() next_place(p, m)```|```has_enough(m, w, p)```|
|Petrinet|```null() add_edge(p,t,w,net)```|```is_triggerable(net, t, m)```|

## Nice Petrinets and Nice Markings

To avoid using directly complex ADTs, the user can use convenient classes : NicePetrinet and NiceMarking.

Declaring a Petrinet this way can be done using the + operator, for example :

```swift
let net = NicePetrinet(adtm:ADTm) +
              Place("P0") + Place("P1") + Place("P2") +
              Transition("T0") + Transition("T1") +
              InputEdge(p:"P0", t:"T0", weight:1) +
              InputEdge(p:"P1", t:"T0", weight:1) +
              InputEdge(p:"P1", t:"T1", weight:1) +
              OutputEdge(t:"T0", p:"P0", weight:2) +
              OutputEdge(t:"T1", p:"P2", weight:2)
```

Markings are related to Petrinets and can be set using a dictionary semantic based on places names defined in the petrinets it's related to :

```swift
 let mark = NiceMarking(onPetrinet:net)
 mark["P0"] = 0
 mark["P1"] = 1
 mark["P2"] = 0
```

When no variables are needed (for now), one can use the methods using the ADT operators without having to use terms directly :

```swift
print(mark.has_enough(weight:1, p:"P1"))

print(net.is_triggerable(t:"T1", marking:mark))
```

##Incidence matrix based tools

Computation on invariants can be done using the incidence matrix of a Petri net.
One can get this matrix by using the method ```incidence_matrix``` on NicePetrinet.

This matrix is from the class DynamicMatrix, which contains these four methods, based on linear algebra on Petri nets and the Farkas algorithm :

```is_p_invariant(inv), is_t_invariant(inv), get_p_invariants(), get_t_invariants()```

These methods consider invariants as Swift arrays of Int and return an array of invariants if needed.

import LogicKit
import ProofKitLib
let adtm = ADTManager.instance()
let a = Integer.n(5)
let b = Integer.n(3)
let c = Integer.add(a,b)
print("\(adtm.pprint(a)) + \(adtm.pprint(b))")
print(adtm.pprint(c))
let r = adtm.eval(c)
print(adtm.pprint(r))
print(r)

/*

[.] places
|.| transitions
-w->  edge with weight w


this example is this net :

[0]-1->|0|<-1-[1]-1->|1|-2->[2]
   <-2-

*/

print("\n--------PETRINET---------\n")

let net = Petrinet.add_edge(Nat.n(0), Nat.n(0), Integer.n(1),
          Petrinet.add_edge(Nat.n(0), Nat.n(0), Integer.n(-2),
          Petrinet.add_edge(Nat.n(1), Nat.n(0), Integer.n(1),
          Petrinet.add_edge(Nat.n(1), Nat.n(1), Integer.n(1),
          Petrinet.add_edge(Nat.n(2), Nat.n(1), Integer.n(-2),
          Petrinet.null()
          )))))

print(Petrinet.to_string(net))

let mat = Petrinet.to_matrix(net)
print(mat.to_string())

let mark = Marking.next_place(Nat.n(1), Marking.next_place(Nat.n(2), Marking.next_place(Nat.n(3), Marking.null())))

print(Marking.to_string(mark))
print(Marking.to_array(mark))

let res = Marking.has_enough(mark, Integer.n(2), Nat.n(0))

print(adtm.pprint(res))

let r2 = adtm.eval(res)

print(r2)

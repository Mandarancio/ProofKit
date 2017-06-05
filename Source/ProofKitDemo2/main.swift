import LogicKit
import ProofKitLib

func print_ax(_ ax: [Rule]){
  for i in 0...ax.count-1{
    print(" \(i). \(ax[i])")
  }
}
let adtm = ADTManager.instance()

/*let a = Integer.n(5)
let b = Integer.n(3)
let c = Integer.add(a,b)
print("\(adtm.pprint(a)) + \(adtm.pprint(b))")
print(adtm.pprint(c))
let r = adtm.eval(c)
print(adtm.pprint(r))
print(r)*/

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

let mark = Marking.next_place(Nat.n(0), Marking.next_place(Nat.n(1), Marking.next_place(Nat.n(0), Marking.null())))

print(Marking.to_string(mark))
print(Marking.to_array(mark))

let res = adtm.eval(Marking.has_enough(mark, Integer.n(1), Nat.n(1)))

print(res)

let res2 = adtm.eval(Petrinet.is_triggerable(net, Nat.n(1), mark))

print(res2)


print("\n ------ FARKAS ------ \n")

let dynMat = DynamicMatrix(
          [
            [-1, 1, 1, -1],
            [1, -1, -1, 1],
            [0, 0, 1, 0],
            [1, 0, 0, -1],
            [-1, 0, 0, 1]
          ])

print(dynMat.get_p_invariants())

import LogicKit
import ProofKitLib
import PetrinetLib

// var adtm = ADTManager.instance()
ADTm["petrinet"] = Petrinet()
ADTm["marking"] = Marking()
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

 let res = ADTm.eval(Marking.has_enough(mark, Integer.n(1), Nat.n(1)))
 print(ADTm.pprint(res))
 let res2 = ADTm.eval(Petrinet.is_triggerable(net, Nat.n(1), mark))
 print(ADTm.pprint(res2))
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

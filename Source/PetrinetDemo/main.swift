import LogicKit
import ProofKitLib
import PetrinetLib

// using petrinets ADTs
ADTm["petrinet"] = Petrinet()
ADTm["marking"] = Marking()
/*
  [.] places
  |.| transitions
  -w->  edge with weight w

  this example is this net :
 [P0]-1->|T0|<-1-[P1]-1->|T1|-2->[P2]
     <-2-
 */

 print("\n--------PETRINET---------\n")

let net = NicePetrinet(adtm:ADTm) +
              Place("P0") + Place("P1") + Place("P2") +
              Transition("T0") + Transition("T1") +
              InputEdge(p:"P0", t:"T0", weight:1) +
              InputEdge(p:"P1", t:"T0", weight:1) +
              InputEdge(p:"P1", t:"T1", weight:1) +
              OutputEdge(t:"T0", p:"P0", weight:2) +
              OutputEdge(t:"T1", p:"P2", weight:2)


 print(nice_net.to_string())
/*
 let mat = Petrinet.to_matrix(net)
 print(mat.to_string())

 let mark = Marking.next_place(Nat.n(0), Marking.next_place(Nat.n(1), Marking.next_place(Nat.n(0), Marking.null())))

 print(Marking.to_string(mark))
 print(Marking.to_array(mark))

 let res = ADTm.eval(Marking.has_enough(mark, Integer.n(1), Nat.n(1)))
 print(ADTm.pprint(res))
 let res2 = ADTm.eval(Petrinet.is_triggerable(net, Nat.n(1), mark))
 print(ADTm.pprint(res2))*/
 print("\n ------ FARKAS ------ \n")

 let dynMat = DynamicMatrix(
           [
             [-1, 1, 1, -1],
             [1, -1, -1, 1],
             [0, 0, 1, 0],
             [1, -1, 1, -1],
             [-1, 1, -1, 1]
           ])

 print(dynMat.get_p_invariants())
 print(dynMat.get_t_invariants())

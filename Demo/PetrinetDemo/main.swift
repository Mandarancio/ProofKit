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


 print(net.to_string())

 let mark = NiceMarking(onPetrinet:net)
 mark["P0"] = 0
 mark["P1"] = 1
 mark["P2"] = 0

print(mark.to_string())

print(mark.has_enough(weight:1, p:"P1"))

print(net.is_triggerable(t:"T1", marking:mark))

let v = Variable(named:"t")
let g = v < Nat.self && Petrinet.is_triggerable(net.as_term(), v, mark.as_term()) <-> Boolean.True()
for s in solve(g).prefix(2) {
  print(ADTm.pprint(s.reified()[v]))
}

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

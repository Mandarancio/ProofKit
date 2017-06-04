import LogicKit
import ProofKitLib

func print_ax(_ ax: [Rule]){
  for i in 0...ax.count-1{
    print(" \(i). \(ax[i])")
  }
}
let adtm = ADTManager.instance()
// print(adtm.pprint(Nat.n(3)))
let multiset = adtm["set"]
for o in multiset.get_operators(){
  print("Set - \(o):")
  print_ax(multiset.a(o))
}

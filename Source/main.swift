import LogicKit

func get_result(_ goal : Goal, _ x : Variable) -> Term{
  var res: Term = Value("nil")
  for s in solve(goal){
    for (t,v) in s.reified().prefix(10){
        if t.equals(x) {
          res = v
        }
    }
  }
  return res
}

let concat_axioms = ADTs["llist"].a("concat")
print("Linked List: Concatenation")
print( "axioms:\n 0. \(concat_axioms[0].pprint())\n 1. \(concat_axioms[1].pprint())\n")
var l0 = LList.insert(Nat.n(1),LList.insert(Nat.n(3),LList.empty()))
var l1 = LList.insert(Nat.n(5),LList.empty())
var l2 = LList.concat(l1,l0)
var res: Term = LList.empty()
let x = Variable(named: "x")
var g = concat_axioms[1].applay(l2,x)

res = get_result(g,x)
var str = " \(ADTs.pprint(l2)) => \(ADTs.pprint(res))"

g = ADTs["llist"].a("concat")[0].applay(res,x)
res = get_result(g,x)
str += " => \(ADTs.pprint(res))"
print("Example: ")
print(str)

let o = ADTs["nat"]["+"](Nat.n(2), Nat.n(1))
g = ADTs["nat"].a("+")[1].applay(o,x)
res = get_result(g,x)
print("\nNatural: Add")
let add_axioms = ADTs["nat"].a("+")
print( "axioms:\n 0. \(add_axioms[0].pprint())\n 1. \(add_axioms[1].pprint())\n")

print(" \(ADTs.pprint(o)) => \(ADTs.pprint(res))")

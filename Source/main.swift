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

func resolve(_ op: Term, _ rules: [Rule]) -> Term{
  let x = Variable(named: "solver.x")
  var curr = op
  var res : Term = Value(0)
  let nilV = Value("nil")
  while !nilV.equals(res){
    res = nilV
    for r in rules{
      res = get_result(r.applay(curr, x),x)
      if !nilV.equals(res){
        curr = res
        break
      }
    }
  }
  return curr
}

func print_ax(_ ax: [Rule]){
  var i = 0
  for a in ax{
    print(" \(i). \(a.pprint())")
    i += 1
  }
}

let llist = ADTs["llist"]

for o in llist.get_operators(){
  print("\nLList - \(o):")
  print_ax(llist.a(o))
}

let x = Variable(named: "x")
var res : Term

let contains = ADTs["llist"].a("contains")
var k = LList.n([Nat.n(2),Nat.n(5),Nat.n(3), Nat.n(1),Nat.n(4)])
var exists = ADTs["llist"]["contains"](k,Nat.n(1))
res = resolve(exists, contains)
print("\n \(ADTs.pprint(exists)) = \(ADTs.pprint(res))\n")

let concat_axioms = ADTs["llist"].a("concat")

var l0 = LList.n([Nat.n(1),Nat.n(3), Nat.n(8)])
var l1 = LList.n([Nat.n(7),Nat.n(5)])
var l2 = LList.concat(l1,l0)

res = resolve(l2, concat_axioms)
var str = " \(ADTs.pprint(l2)) => \(ADTs.pprint(res))"
print(str)

let o = ADTs["nat"]["+"](Nat.n(2), Nat.n(1))
print("\nNatural: Add")
let add_axioms = ADTs["nat"].a("+")
print_ax(add_axioms)

res = resolve(o, add_axioms)

print(" \(ADTs.pprint(o)) => \(ADTs.pprint(res))")

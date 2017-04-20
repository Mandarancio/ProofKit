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

print("Linked List: Contains")
print( "axioms:")


let x = Variable(named: "x")
var res : Term

let contains = ADTs["llist"].a("contains")
print_ax(contains)
var k = LList.insert(Nat.n(2),LList.insert(Nat.n(1),LList.empty()))
var exists = ADTs["llist"]["contains"](k,Nat.n(1))
res = resolve(exists, contains)
print("\n \(ADTs.pprint(exists)) = \(ADTs.pprint(res))\n")

let concat_axioms = ADTs["llist"].a("concat")

print("Linked List: Concatenation")
print( "axioms:\n 0. \(concat_axioms[0].pprint())\n 1. \(concat_axioms[1].pprint())\n")
var l0 = LList.insert(Nat.n(1),LList.insert(Nat.n(3),LList.empty()))
var l1 = LList.insert(Nat.n(5),LList.empty())
var l2 = LList.concat(l1,l0)

res = resolve(l2, concat_axioms)
var str = " \(ADTs.pprint(l2)) => \(ADTs.pprint(res))"

print("Example: ")
print(str)

let o = ADTs["nat"]["+"](Nat.n(2), Nat.n(1))
print("\nNatural: Add")
let add_axioms = ADTs["nat"].a("+")
res = resolve(o, add_axioms)
print( "axioms:\n 0. \(add_axioms[0].pprint())\n 1. \(add_axioms[1].pprint())\n")

print(" \(ADTs.pprint(o)) => \(ADTs.pprint(res))")

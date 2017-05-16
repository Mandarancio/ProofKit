import LogicKit
import ProofKitLib

func replace(_ t: Term,_ x: Variable, _ y: Term)->Term{
  if t.equals(x){
    return y
  }
  if let m = (t as? Map){
    var nm = m
    for (k,v) in m{
      nm = nm.with(key: k,value: replace(v,x,y))
    }
    return nm
  }
  return t
}


func replaceAll(_ t: Term, _ ys: [Variable])->Term{
  let xs = variables(t)
  if xs.count != ys.count {
    return t
  }
  var nt = t
  for i in 0...xs.count-1{
    nt = replace(nt, xs[i],ys[i])
  }
  return nt
}




func variables(_ t: Term)-> [Variable] {
  if t is Variable{
    return [t as! Variable]
  }
  if let m = (t as? Map){
    var vars : [Variable]  = []
    for (_,v) in m{
      for x in variables(v){
        if !vars.contains(x){
          vars.append(x)
        }
      }
    }
    return vars
  }
  return []
}


func equiv(_ a: Term, _ b: Term) -> Bool{
  let goal = a === b
  for s in solve(goal){
    for (k,v) in s{
      print("\(k) - \(v) ")
    }
    return true
  }
  return false
}

func subst(_ l1 : Term, _ l2: Term,_ r1: Term) -> Term{
  let goal = l2 === l1
  var r2  = r1
  for s in solve(goal){
    for (k,v) in s{
      print("\(k) - \(v) ")
      r2 = replace(r2,k,v)
    }
  }
  return r2
}


let x = Variable(named:"X")
let y = Variable(named:"Y")


let le = Nat.add(x,Nat.succ(x: y))
let ri = Nat.succ(x: Nat.add(x,y))
let g = Nat.add(x,Nat.succ(x: Nat.zero()))
print(subst(le,g,ri))
print(le)
print(g)
print(variables(le))
print(variables(g))
print(replaceAll(le,variables(g)))
// print(replace(f,x,y))
print(equiv(le,g))

let s1 = Set.n([Nat.n(1), Nat.n(2)])
let s2 = Set.cons(Nat.n(1), s1)
print(s2)

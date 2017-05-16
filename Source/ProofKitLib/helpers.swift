import LogicKit

public let vNil = Value("nil")
public let vFail = Value("fail")

public func variables(_ a: Term)-> [Variable]{
  var l : [Variable] = []
  if a is Variable{
    return [a as! Variable]
  }
  if let m = (a as? Map){
    for (_,x) in m{
      l +=  variables(x)
    }
  }
  return l
}

public func is_solvable(_ g :Goal)->Bool{
  for _ in  solve(g){
    return true
  }
  return false
}

public func replace_variable(_ a: Term, _ vx: [Variable]) -> Term{
  let vs = variables(a)
  if vs.count != vx.count {
    return a
  }
  if a is Variable{
    return vx[0]
  }
  if let m = (a as? Map){
    // let nm = m
    for (_,_) in m{
      // if v is Variable
      // nm = nm.with(k)
    }
  }
  return a
}

public func equivalence(_ a: Term, _ b: Term) ->Bool{
  //RECURSIVE EQUIVALENCE
  if a.equals(b){
    return true
  }
  if a is Variable && b is Variable{
    return true
  }
  if a is Map && b is Map{
    let am = a as! Map
    let bm = b as! Map
    for (k,v) in am{
      if bm[k] == nil{
        return false
      }
      else{
        if !equivalence(bm[k]!, v) {
          return false;
        }
      }
    }
    for (k,v) in bm{
      if am[k] == nil{
        return false
      }
      else{
        if !equivalence(v, am[k]!) {
          return false;
        }
      }
    }
    return true;
  }
  return false
}


public func get_result(_ goal : Goal, _ x : Variable) -> Term{
  var res: Term = vNil
  for s in solve(goal){
    for (t,v) in s.reified().prefix(10){
        if t.equals(x) {
          res = v
        }
    }
  }
  return res
}

public func resolve(_ op: Term, _ rules: [Rule]) -> Term{
  let x = Variable(named: "resolver.x")
  var curr = op
  var res : Term = op
  while !vNil.equals(res){
    res = vNil
    for r in rules{
      res = get_result(r.applay(curr, x),x)
      if !vNil.equals(res){
        curr = res
        break
      }
    }
  }
  return curr
}

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

internal func create_subst_table(_ l: Term, _ id: String, _ counter: inout Int, _ variables: inout [Variable:Variable]){
  if let lv = (l as? Variable){
    // let name = lv.name
    if variables[lv] == nil{
      variables[lv] = Variable(named: "\(id)#\(counter)")
      counter += 1
    }
  }
  if let lm = (l as? Map){
    for (_, v) in lm {
      create_subst_table(v, id, &counter, &variables)
    }
  }
}

internal func reverse_subs_table(_ st: [Variable:Variable]) -> [Variable:Variable] {
  var res : [Variable:Variable] = [:]
  for (k,v) in st{
    res[v] = k
  }
  return res
}

internal func apply_subst_table(_ a: Term, _ st: [Variable:Variable]) -> Term{
  if let av = (a as? Variable){
    if st[av] != nil {
      return st[av]!
    }
    return av
  }
  if let am = (a as? Map){
    var nm = am
    for (k,v) in am{
      nm = nm.with(key: k, value: apply_subst_table(v, st))
    }
    return nm
  }
  return a
}

public func subst_variable(_ a:Term, _ v: Variable, _ b:Term)->Term{
  if let av = (a as? Variable){
    if av.equals(v){
      return b
    }
    return a
  }
  if let am = (a as? Map){
    var nm = am
    for (k,val) in am{
      nm = nm.with(key: k, value: subst_variable(val, v, b))
    }
    return nm
  }
  return a
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

public func eq_map(_ a:Term, _ b:Term, _ map: [Variable:Variable] ) -> [Variable:Variable]{
  var emap : [Variable:Variable] = map
  if a is Variable && b is Variable{
    let av = a as! Variable
    let bv = b as! Variable
    if emap[av] != nil && emap[av] != bv{
      return [:]
    }
    emap[av] = bv
    return emap
  }
  if a is Map && b is Map {
    let am = a as! Map
    let bm = b as! Map
    for (k,v) in am{
      if bm[k] == nil{
        return [:]
      }
      else{
        for (v1,v2) in eq_map(v,bm[k]!, emap){
          emap[v1] = v2
        }
      }
    }
    return emap
  }
  else if a.equals(b){
    return emap
  }
  return [:]
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
      res = get_result(r.apply(curr, x),x)
      if !vNil.equals(res){
        curr = res
        break
      }
    }
  }
  return curr
}

public func /(left: Term, right: [Variable:Variable])->Term{
  return apply_subst_table(left,right)
}

public func *(left: Term, right: [Variable:Variable])->Term{
  return apply_subst_table(left, reverse_subs_table(right))
}

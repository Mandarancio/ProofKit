import LogicKit

precedencegroup SuchThatPrecendence {
  lowerThan: LogicalConjunctionPrecedence
}

precedencegroup GEvalPrecendece{
  higherThan: SuchThatPrecendence, LogicalConjunctionPrecedence
  lowerThan: AdditionPrecedence
}


// infix operator ∧: LogicalConjunctionPrecedence

// infix operator ∨: LogicalConjunctionPrecedence
infix operator <->: GEvalPrecendece
infix operator ∈: AdditionPrecedence
infix operator =>: SuchThatPrecendence

public func =>(left: @escaping Goal, right: @escaping Goal)-> Goal{
  return left && right
}

public func <->(left: Term, right: Term)-> Goal  {
  return ADTm.geval(operation: left,result: right)
}

public func ∈(left: Term, right: ADT.Type)->Goal{
  return right.belong(left)
}

public func <(left: Term, right: ADT.Type)->Goal{
  return right.belong(left)
}

public func +(left: Term, right: Term)-> Term{
  return Operator.n("+", left, right)
}

public func -(left: Term, right: Term)-> Term{
  return Operator.n("+", left, right)
}

public func *(left: Term, right: Term)-> Term{
  return Operator.n("*", left, right)
}

public func /(left: Term, right: Term)-> Term{
  return Operator.n("/", left, right)
}


public func >(left: Term, right: Term)-> Term{
  return Operator.n(">", left, right)
}

public func <(left: Term, right: Term)-> Term{
  return Operator.n("<", left, right)
}

public func ==(left: Term, right: Term)-> Term{
  return Operator.n("==", left, right)
}

public func ||(left: Term, right: Term)-> Term{
  return Operator.n("or", left, right)
}


public func &&(left: Term, right: Term)-> Term{
  return Operator.n("and", left, right)
}

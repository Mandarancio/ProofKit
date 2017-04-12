import LogicKit
public struct Boolean {
    public static func True() -> Term{
      return Value<Bool>(true)
    }

    public static func False() -> Term{
      return Value<Bool>(false)
    }

    public static func to(_ x: Bool) -> Term{
      return Value<Bool>(x)
    }

    public static func isTrue(_ x: Term) -> Goal {
      return x === Boolean.True()
    }

    public static func isFalse(_ x: Term) -> Goal{
      return x === Boolean.False()
    }

    public static func not(_ x: Term)->Term{
      return Map([
        "name":Value<String>("B!"),
        "rhs": x
      ])
    }

    public static func or(_ lhs: Term, _ rhs: Term)->Term{
      return Operator.n(lhs,rhs,"B.or")
    }

    public static func and(_ lhs: Term, _ rhs: Term)->Term{
      return Operator.n(lhs,rhs,"B.and")
    }
}

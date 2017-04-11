import LogicKit
public struct Boolean {
    public static func True() -> Term{
      return Value<Bool>(true)
    }

    public static func False() -> Term{
      return Value<Bool>(false)
    }

    public static func toBoolean(_ x: Bool) -> Term{
      return Value<Bool>(x)
    }

    public static func isTrue(_ x: Term) -> Goal {
      return x === Boolean.True()
    }

    public static func isFalse(_ x: Term) -> Goal{
      return x === Boolean.False()
    }
}

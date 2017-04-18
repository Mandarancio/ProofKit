import LogicKit
public class LList : ADT {
    public init(){
      super.init("llist")
      
      self.add_generator("empty", LList.empty)
      self.add_generator("insert", LList.insert, arity:2)
    }
    
    public static func empty(_ :Term...) -> Term{
      return Value<String>("tail")
    }
    
    public static func insert(_ terms: Term...)->Term{
      return Map([
        "data": terms[0],
        "next": terms[1]
      ])
    }
    
    public class override func belong(_ x: Term) -> Goal{
      return (x === LList.empty() || delayed(fresh {y in fresh{w in x === LList.insert(y,w) && LList.belong(w)}}))
    }

}

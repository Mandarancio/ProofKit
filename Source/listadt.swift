import LogicKit
//// https://en.wikipedia.org/wiki/Linked_list
//// Linked List
public class LList : ADT {
    public init(){
      super.init("llist")

      self.add_generator("empty", LList.empty)
      self.add_generator("insert", LList.insert, arity:2)
      self.add_operator("concat", LList.concat, [
        Rule(LList.concat(LList.empty(),Variable(named: "concat.0.$0")),Variable(named: "concat.0.$0")),
        Rule(
          LList.concat(LList.insert(Variable(named: "concat.1.$0"), Variable(named: "concat.1.$1")),Variable(named: "concat.1.$2")),
          LList.concat(Variable(named: "concat.1.$1"), LList.insert(Variable(named: "concat.1.$0"), Variable(named: "concat.1.$2"))))
      ])
    }

    public static func empty(_ :Term...) -> Term{
      return Value<String>("list.tail")
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

    public static func concat(_ terms: Term...)->Term{
      let o =  Operator.n(terms[0], terms[1], "concat")
      return o
    }

    public override func pprint(_ t: Term) -> String{
      var s : String = "("
      var x = t
      while !x.equals(LList.empty()){
        if let m = (x as? Map){
          ////
          if m["next"] != nil {
            if s != "(" {
              s += ", "
            }
            s += ADTs.pprint(m["data"]!)
            x = m["next"]!
          }else{
            x = LList.empty()
          }
        }else if let m = (x as? Variable){
          if s != "(" {
            s += ", "
          }
          s+=ADTs.pprint(m)
          x = LList.empty()
        }
      }
      return s+")"
    }

    public override func check(_ term: Term) -> Bool{
      if term.equals(LList.empty()){
        return true
      }
      if let m = (term as? Map){
        return m["next"] != nil && m["data"] != nil
      }
      return false
    }
}

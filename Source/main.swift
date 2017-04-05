import LogicKit

let greet = "hello!"
print(greet)

let x = Variable(named:"x")
let goal = Nat.is_even (x: x)
for substitution in solve (goal) {
     print ("substitution found")
     for (_, value) in substitution.reified() {
     	 let term = Nat.count(value)
         print("* \(term)")
     }
}
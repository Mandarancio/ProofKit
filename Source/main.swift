import LogicKit

let greet = "hello!"
print(greet)

let x = Variable(named:"x")
let goal = Nat.is_even (y: x)
for substitution in solve (goal) {
     print ("substitution found")
     for (_, value) in substitution.reified() {
         print("* \(value)")
     }
}
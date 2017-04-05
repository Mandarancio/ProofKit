import LogicKit

let greet = "hello!"
print(greet)

let x = Nat.n(8)//Variable(named:"x")
print(x)
let goal = Nat.is_even (x: x)
for substitution in solve (goal) {
     print ("substitution found")
     for (_, value) in substitution.reified() {
         print("* \(Nat.count(value))")
     }
}
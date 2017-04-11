import LogicKit

let greet = "hello!"
print(greet)

let x = Nat.n(2)
let y = Nat.n(3)
let z = Variable(named:"x")
print(x)
let goal = operation(z,x,y, Nat.Add.axioms)
for substitution in solve (goal) {
     print ("substitution found")
     for (t, value) in substitution.reified().prefix(100) {
     if (t == z){
         print("* \(t) \(Nat.count(value))")
       }
     }
}

test_petrinets()

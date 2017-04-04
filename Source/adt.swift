//
//  A LogicKit usage example that showcases the use of predicates.
//
//  Created by Dimitri Racordon on 12.02.17.
//  Copyright © 2017 University of Geneva. All rights reserved.
//
import LogicKit



// First, we create an enumeration to represent the different Pokemon.
enum Person: Term {

    case A, B, C, D, E, F, G, H, I

    func equals(_ other: Term) -> Bool {
        return (other is Person) && (other as! Person == self)
    }

}

// We then define a set of predicates on the type of the pokemons.
func is_student(who: Term) -> Goal {
    return  (who === Person.A) ||
            (who === Person.E) ||
            (who === Person.I)
}
//
// func fire(_ pokemon: Term) -> Goal {
//     return  (pokemon ≡ Pokemon.Charmander) ||
//             (pokemon ≡ Pokemon.Vulpix)
// }
//
// func water(_ pokemon: Term) -> Goal {
//     return  (pokemon ≡ Pokemon.Squirtle) ||
//             (pokemon ≡ Pokemon.Psyduck)
// }
//
// // We define another predicate that takes two Pokemon and holds when the first
// // is stronger that ther second (solely based on their type).
// func stronger(_ lhs: Term, _ rhs: Term) -> Goal {
//     return  grass(lhs) && water(rhs) ||
//             fire(lhs) && grass(rhs) ||
//             grass(lhs) && water(rhs)
// }

let zero = Value("0")

func succ(_ x: Term) -> Map {
  return ["succ": x]
}

func is_even(what: Term) -> Goal {
    return (what === zero) ||
           delayed (fresh { x in
             what === succ(succ(x)) &&
             is_even(what:x)
           })
}

let empty = Value("[]")

func cons(_ element: Term, _ list: Term) -> Map
{
  return ["head": element, "rest" : list]
}



func list_size (list: Term, size: Term) -> Goal {
    return (list === empty && size === zero) ||
      delayed (fresh { x in fresh { y in fresh { z in
        (is_student(who: x)) &&
        (list === cons (x,  y)) &&
        (size === succ (z)) &&
        (list_size (list: y, size: z))
      }}})
}


Bunch - first:
 0. first([]) = nil
 1. first([$0, rest : $1]) = $0

Bunch - contains:
 0. ([] contains $0) = false
 1. ([$0, rest : $1] contains $0) = true
 2. ([$0, rest : $1] contains $2) = ($1 contains $2)

Bunch - size:
 0. size([]) = 0
 1. size([$0, rest : $1]) = succ(size($1))

Bunch - rest:
 0. rest([]) = []
 1. rest([$0, rest : $1]) = $1

Bunch - concat:
 0. ([] concat $0) = $0
 1. ([$0, rest : $1] concat $2) = ($1 concat [$0, rest : $2])

 ([2, 5, 3, 1, 4] contains 1) = true
 ([7, 5] concat [1, 3, 5, 8]) => [5, 7, 1, 3, 5, 8]
 size([1, 3, 4]) => 3

Set - subSet:
 0. ([] subSet $0) = true
 1. ([$0, rest : $1] subSet $2) = (($2 contains $0) and ($1 subSet $2))

Set - intersection:
 0. ([] intersection $0) = []
 1. if ($2 contains $0) then 
	([$0, rest : $1] intersection $2) = ($0 insert ($1 intersection $2))
 2. if not(($2 contains $0)) then 
	([$0, rest : $1] intersection $2) = ($1 intersection $2)

Set - diff:
 0. ([] diff $0) = []
 1. if ($2 contains $0) then 
	([$0, rest : $1] diff $2) = ($1 diff $2)
 2. if not(($2 contains $0)) then 
	([$0, rest : $1] diff $2) = ($0 insert ($1 diff $2))

Set - size:
 0. size([]) = 0
 1. size([$0, rest : $1]) = succ(size($1))

Set - first:
 0. first([]) = nil
 1. first([$0, rest : $1]) = $0

Set - contains:
 0. ([] contains $0) = false
 1. ([$0, rest : $1] contains $0) = true
 2. ([$0, rest : $1] contains $2) = ($1 contains $2)

Set - rest:
 0. rest([]) = []
 1. rest([$0, rest : $1]) = $1

Set - insert:
 0. ($0 insert []) = [$0]
 1. ($0 insert [$0, rest : $1]) = [$0, rest : $1]
 2. ($0 insert [$1, rest : $2]) = [$1]

Set - union:
 0. ([] union $0) = $0
 1. ([$0, rest : $1] union $2) = ($1 union ($0 insert $2))

 ([1, 2, 4] union [1, 0, 3, 5, 4]) => [1, 0, 3, 5, 4, 2]
 ([1, 2, 4] intersection [1, 0, 3, 5, 4]) => [4, 1]
 ([1, 0, 3, 5, 4] diff [1, 2, 4]) => [5, 3, 0]
 ([1, 2, 4] subSet [1, 0, 3, 5, 4, 2]) => true

sequence - set:
 0. set([], $0, $1) = []
 1. set([$1: $0, rest : $2], $1, $3) = [$1: $3, rest : $2]
 2. set([$1: $0, rest : $2], $3, $4) = [$1: $0, rest : set($2, $3, $4)]

sequence - push:
 0. ($0 push []) = [0: $0]
 1. ($0 push [$2: $1, rest : $3]) = [succ($2): $0, $2: $1, rest : $3]

sequence - get:
 0. ([] get $0) = nil
 1. ([$1: $0, rest : $2] get $1) = $0
 2. ([$1: $0, rest : $2] get $3) = ($2 get $3)

 s0: [2: 4, 1: 3, 0: 2]
 ([2: 4, 1: 3, 0: 2] get 1) => 3
 set([2: 4, 1: 3, 0: 2], 1, 5) => [2: 4, 1: 5, 0: 2]

nat - *:
 0. ($0 * 0) = 0
 1. ($1 * 1) = $1
 2. ($1 * succ($2)) = ($1 + ($1 * $2))

nat - +:
 0. ($1 + 0) = $1
 1. ($1 + succ($2)) = succ(($1 + $2))

 (2 + 3) => 5
 ((2 * 3) + (2 + 3)) => 11


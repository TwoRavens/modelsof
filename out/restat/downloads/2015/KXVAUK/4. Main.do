

clear all

use ColRepData

eststo clear

eststo: reg c ma   si u p p2  li md w I* i.s i.y if g>7&a>16&a<24 ,  vce(bootstrap, reps(200))

eststo: reg c ma  f b mr  a h fi  si u p p2 li md w I* i.s i.y if g>7&a>16&a<24,  vce(bootstrap, reps(200))


eststo: reg c1 ma  si u p p2 li md w I* i.s i.y if g>7&a>16&a<24 ,  vce(bootstrap, reps(200))

eststo: reg c1 ma  f b mr  a h fi  si u p p2 li md w I* i.s i.y if g>7&a>16&a<24,  vce(bootstrap, reps(200))


eststo: reg c2 ma    si u p p2 li md w I* i.s i.y if g>7&a>16&a<24 ,  vce(bootstrap, reps(200))

eststo: reg c2 ma  f b mr  a h fi  si u p p2 li md w I* i.s i.y if g>7&a>16&a<24,  vce(bootstrap, reps(200))


esttab using collegemain.tex, label replace se keep(ma a f b mr fi h  )  star(* .1 ** .05 *** .01)

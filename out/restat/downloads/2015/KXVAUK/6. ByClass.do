clear all

use ColRepData

set seed 19002014


eststo: reg c ma d f b mr a fi h si  p p2 po u w I* i.s i.y if g>7&a>16&a<24&li==1 ,  vce(bootstrap, reps(1000))

eststo: reg c ma d f b mr a fi h si  p p2  u w I* i.s i.y if g>7&a>16&a<24&md==1&li==0 ,  vce(bootstrap, reps(1000))

eststo: reg c ma d f b mr  a fi h si  p p2  u w I* i.s i.y if g>7&a>16&a<24 &up==0&md==0,  vce(bootstrap, reps(1000))

eststo: reg c ma d f b mr  a  fi h si p p2 a2 ri    u w I* i.s i.y if g>7&a>16&a<24 &up==1 ,  vce(bootstrap, reps(1000))

eststo: reg c ma d f b mr  a  fi h si p p2 a2 ri    u w I* i.s i.y if g>7&wb==1 ,  vce(bootstrap, reps(1000))

eststo: reg c ma d f b mr  a  fi h si p p2 a2 ri    u w I* i.s i.y if g>7&a>16&a<24 &wb==0 ,  vce(bootstrap, reps(1000))


esttab using hetero.tex, label replace se keep(ma)  star(* .1 ** .05 *** .01)


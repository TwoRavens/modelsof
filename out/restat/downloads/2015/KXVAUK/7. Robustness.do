
clear all

use ColRepData
set seed 987659865

*******************************
*Generate the robustness table*
*******************************


eststo clear

eststo: reg c ma f b mr  fi    a  si   p p2 u w li md I* i.s i.y if g>0&a>16&a<23 , vce(bootstrap, reps(200))

eststo: reg c ma f b mr  fi    a  si  p p2 u w li md I* i.s i.y if g>11&a>16&a<24 , vce(bootstrap, reps(200))

eststo: reg c ma f b mr  fi     a  si  p p2 u w li md I* i.s i.y if g>7&a>17&a<22 , vce(bootstrap, reps(200))

eststo: reg c ma f b mr  fi  a  si  p p2 u w li md I* i.s i.y if g>7&a>15&a<23, vce(bootstrap, reps(200))

eststo: reg c ma f b mr  fi     a  si  p p2  u w li md I* i.s i.y if g>7&a>16&a<24&delaware==0&southdakota==0 , vce(bootstrap, reps(200))

eststo: reg c ma f b mr  fi    a  si   p p2  u w li md I* i.s i.y if g>7&a>16&a<24&y>1976 , vce(bootstrap, reps(200))

eststo: reg c ma f b mr  fi    a  si  p p2   u w li md I* i.s i.y if g>7&a>16&a<24 , cluster(s)

eststo: reg c ma f b mr  fi    a  si  p p2  u w li md J* i.s i.y if g>7&a>16&a<24 , vce(bootstrap, reps(200))

eststo: reg c ma f b mr fi h a si  w p p2  li md J*  i.s i.y if a==19, vce(bootstrap, reps(200))

eststo: reg c ma f b mr  a fi  si u p p2 li md  w I* i.ry i.s if g>7&a>16&a<24, vce(bootstrap, reps(1000))


esttab using robustness.tex, label replace se keep(ma)  star(* .1 ** .05 *** .01)

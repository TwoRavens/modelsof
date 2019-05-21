 *housekeeping
tab pid3_00, gen(pid00)
tab pid3_02, gen(pid02)

local first00 age agesq female hs somecoll coll grad i.inc00 i.unemployed00 ne west mid white black hispanic catholic jew main ba
local second00 mod_00 cons_00 homo00 abortion00 econ00 jobs00 feminist00
 
qui xi: reg attend02 pid003 pid002 i.attend00 i.married00 i.children `first00' `second00' [aw=WT04], r
quietly gen insample_full0002=e(sample)

local first02 age agesq female hs somecoll coll grad i.income02 unemployed02 ne west mid white black hispanic catholic jew main ba
local second02 mod_02 cons_02 homo02 abortion00 econ02 jobs02 feminist02 iraq02

qui xi: reg attend04 pid023 pid022 i.attend02 i.married00 i.children `first02' `second02' [aw=WT04], r
quietly gen insample_full0204=e(sample)

g kids_grown=1 if kids==1
replace kids_grown=0 if grown==1

g pid003Xkids= pid003*kids_grown
g pid002Xkids= pid002*kids_grown

g pid023Xkids= pid023*kids_grown
g pid022Xkids= pid022*kids_grown

X

local first00 age agesq female hs somecoll coll grad i.inc00 i.unemployed00 ne west mid white black hispanic catholic jew main ba
local second00 mod_00 cons_00 homo00 abortion00 econ00 jobs00 feminist00

eststo clear
xi: reg attend02 pid003 pid002 i.attend00 if insample_full0002==1 & kids==1 [aw=WT04], r
est store a1
xi: reg attend02 pid003 pid002 i.attend00 `first00' if insample_full0002==1 & kids==1 [aw=WT04], r
est store a2
xi: reg attend02 pid003 pid002 i.attend00 `first00' `second00' if insample_full0002==1 & kids==1 [aw=WT04], r
est store a3
xi: reg attend02 pid003 pid002 i.attend00 if insample_full0002==1 & grown==1 [aw=WT04], r
est store a4
xi: reg attend02 pid003 pid002 i.attend00 `first00' if insample_full0002==1 & grown==1 [aw=WT04], r
est store a5
xi: reg attend02 pid003 pid002 i.attend00 `first00' `second00' if insample_full0002==1 & grown==1 [aw=WT04], r
est store a6
esttab a1 a2 a3 a4 a5 a6 using "church_sub_0002.tex", ///
keep(pid003 pid002 _Iattend00_2  _Iattend00_3 _Iattend00_4 _Iattend00_5 _Iattend00_6 _cons) ///
star(* .10 ** 0.05) obslast nogaps ///
sfmt(4) se(2) b(2) replace booktabs compress label r2 ///
title("Respondents with children at home drive the results")  ///
nomtitles ///
coeflabels( pid003   "Republican" pid002 "Independent" _Iattend00_2 "A few times a year" _Iattend00_3 "Once or twice a month" _Iattend00_4 "Almost every week" _Iattend00_5 "Every week" _Iattend00_6 "More than once per week"  _cons "Intercept") ///
indicate( "demographic controls = *grad*" "attitudinal controls = *econ00*") ///
nonotes


local first00 age agesq female hs somecoll coll grad i.inc00 i.unemployed00 ne west mid white black hispanic catholic jew main ba
local second00 mod_00 cons_00 homo00 abortion00 econ00 jobs00 feminist00
 
xi: reg attend02 pid003 pid002 kids_grown pid003Xkids pid002Xkids i.attend00 if insample_full0002==1 [aw=WT04], r
xi: reg attend02 pid003 pid002 kids_grown pid003Xkids pid002Xkids i.attend00 `first00' if insample_full0002==1 [aw=WT04], r
xi: reg attend02 pid003 pid002 kids_grown pid003Xkids pid002Xkids i.attend00 `first00' `second00' if insample_full0002==1 [aw=WT04], r

*HOUSEKEEPING
tab pid3_00, gen(pid00)
tab pid3_02, gen(pid02)


local first00 age agesq female hs somecoll coll grad i.inc00 i.unemployed00 ne west mid white black hispanic catholic jew main ba
local second00 mod_00 cons_00 homo00 abortion00 econ00 jobs00 feminist00
 
qui xi: reg attend02 pid003 pid002 i.attend00 i.married00 i.children `first00' `second00' [aw=WT04]
quietly gen insample_full0002=e(sample)

local first02 age agesq female hs somecoll coll grad i.income02 unemployed02 ne west mid white black hispanic catholic jew main ba
local second02 mod_02 cons_02 homo02 abortion00 econ02 jobs02 feminist02 iraq02

qui xi: reg attend04 pid023 pid022 i.attend02 i.married00 i.children `first02' `second02' [aw=WT04]
quietly gen insample_full0204=e(sample)

X

**FULL SAMPLE -- 2000 TO 2002

local first00 age agesq female hs somecoll coll grad i.inc00 i.unemployed00 ne west mid white black hispanic catholic jew main ba
local second00 mod_00 cons_00 homo00 abortion00 econ00 jobs00 feminist00
 
eststo clear
xi: reg attend02 pid003 pid002 i.attend00 i.married00 i.children if insample_full0002==1 [aw=WT04], r
est store a1
xi: reg attend02 pid003 pid002 i.attend00 i.married00 i.children `first00' if insample_full0002==1 [aw=WT04], r
est store a2
xi: reg attend02 pid003 pid002 i.attend00 i.married00 i.children `first00' `second00' if insample_full0002==1 [aw=WT04], r
est store a3
esttab a1 a2 a3 using "church_full_0002.tex", ///
keep(pid003 pid002 _Iattend00_2  _Iattend00_3 _Iattend00_4 _Iattend00_5 _Iattend00_6 _cons) ///
star(* .10 ** 0.05) obslast nogaps ///
sfmt(4) se(2) b(2) replace booktabs compress label r2 ///
title("Partisan church attendance diverged after gay marriage became salient")  ///
nomtitles ///
coeflabels( pid003   "Republican" pid002 "Independent" _Iattend00_2 "A few times a year" _Iattend00_3 "Once or twice a month" _Iattend00_4 "Almost every week" _Iattend00_5 "Every week" _Iattend00_6 "More than once per week"  _cons "Intercept") ///
indicate( "demographic controls = *grad*" "attitudinal controls = *econ00*") ///
nonotes


** FULL SAMPLE -- 2002 TO 2004
local first02 age agesq female hs somecoll coll grad i.income02 unemployed02 ne west mid white black hispanic catholic jew main ba
local second02 mod_02 cons_02 homo02 abortion00 econ02 jobs02 feminist02 iraq02

eststo clear
xi: reg attend04 pid023 pid022 i.attend02 i.married00 i.children  if insample_full0204==1 [aw=WT04]
est store a1
xi: reg attend04 pid023 pid022 i.attend02 i.married00 i.children `first02' if insample_full0204==1 [aw=WT04]
est store a2
xi: reg attend04 pid023 pid022 i.attend02 i.married00 i.children `first02' `second02' [aw=WT04]
est store a3
esttab a1 a2 a3 using "church_full_0204.tex", ///
keep(pid023 pid022 _Iattend02_2  _Iattend02_3 _Iattend02_4 _Iattend02_5 _Iattend02_6 _cons) ///
star(* .10 ** 0.05) obslast nogaps ///
sfmt(4) se(2) b(2) replace booktabs compress label r2 ///
title("Partisan church attendance diverged after gay marriage became salient")  ///
nomtitles ///
coeflabels( pid023   "Republican" pid022 "Independent" _Iattend02_2 "A few times a year" _Iattend02_3 "Once or twice a month" _Iattend02_4 "Almost every week" _Iattend02_5 "Every week" _Iattend02_6 "More than once per week"  _cons "Intercept") ///
indicate( "demographic controls = *grad*" "attitudinal controls = *econ02*") ///
nonotes

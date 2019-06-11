
use "Dataset_AER_MS_ 20090823.dta", clear

*Their code to create variables
* create demographic variables for use in Table 1 and later in regressions
g female=(gender==1)
g arts_science=(college==1)
g business=(college==2)
g engineering=(college==3)
g practicing=(practice_religion==1)
g atheist_agnostic=(religion==1)
g christian=(religion==3)
g other_religion=(religion~=1&religion~=3)
g asian=(race==5)
g hispanic=(race==3)
g white=(race==1)
g other_race=~asian&~hispanic&~white
g inc_lt100k=(family_income<=5)
g inc_100_200k=(family_income==6|family_income==7)
g inc_gt200k=(family_income==8|family_income==9)
*Create dummy variables corresponding to the time delay and future value in each time-preference question
g time1=(delay==1)
g time3=(delay==3)
g time7=(delay==7)
g time14=(delay==14)
g time28=(delay==28)
g time56=(delay==56)
g m1134=(fv<15)
g m1831=(fv>15&fv<20)
g m2428=(fv>20&fv<30)
g m3284=(fv>30&fv<40)
g m5171=(fv>40)
*Create variable "dmt," which gives the discount factor (pv/fv) inferred from each time-preference response.  Corresponds to D(m,t) in Table 2 and all figures
g dmt=pv/fv


*Table 2D - Their code - one error in coefficient and s.e.
foreach i of varlist time1 time3 time7 time14 time28 time56 { 
foreach j of varlist m1134 m1831 m2428 m3284 m5171 {
	ttest dmt if `i'==1 & `j'==1, by(treatment) 
	}
	}

*What follows is their code, but doesn't reproduce results
foreach i of varlist time1 time3 time7 time14 time28 time56 { 
	display "difference between treatment and control of discount factor for `i'"
	ttest dmt if `i'==1, by(treatment) 
	}
foreach j of varlist m1134 m1831 m2428 m3284 m5171 {
	display "difference between treatment and control of discount factor for `j'"
	ttest dmt if `j'==1, by(treatment) 
	}
display "difference between treatment and control of discount factor overall"
ttest dmt, by(treatment) 

*In the paper they are reporting mean regressions, but these are individual observations
*Corrected code - matches standard errors, but cannot match reported coefficients
egen idmt = mean(dmt), by(delay id)
egen jdmt = mean(dmt), by(fv id)
egen ijdmt = mean(dmt), by(id)
local c = 30
foreach i of varlist time1 time3 time7 time14 time28 time56 { 
	local c = `c' + 1
	ttest idmt if `i' == 1 & m1134 == 1, by(treatment) 
	}
foreach j of varlist m1134 m1831 m2428 m3284 m5171 {
	local c = `c' + 1
	ttest jdmt if `j'==1 & time1 == 1, by(treatment) 
	}
ttest ijdmt if time1 == 1 & m1134 == 1, by(treatment)

*In sum, cannot consistently match coef. and se. for mean regressions in this table.
*Their reported code is not what they did, but neither is my attempted code what they did
*So, drop from my analysis (this is row & column means) 


*These are individual entries in Table 2D (by and large close, but often small differences)
foreach a of varlist time1 time3 time7 time14 time28 time56 { 
	foreach b of varlist m1134 m1831 m2428 m3284 m5171 {
		regress dmt treatment if `a'==1 & `b'==1
		}
	}


*Table 3 - R2 wrong in about half of specifications, but match coefficients & sample size

xi: reg pv treatment i.fv*i.delay, cluster(id)
xi: reg pv treatment i.fv*i.delay i.college i.female i.race i.religion i.practicing i.family_income, cluster(id)
xi: reg pv treatment i.fv*i.delay i.happiness, cluster(id)
xi: reg pv treatment i.fv*i.delay i.college i.female i.race i.religion i.practicing i.family_income i.happiness, cluster(id)
xi: reg pv treatment i.fv*i.delay if pv<fv, cluster(id)
xi: reg pv treatment i.fv*i.delay i.college i.female i.race i.religion i.practicing i.family_income if pv<fv, cluster(id)
xi: reg pv treatment i.fv*i.delay i.happiness if pv<fv, cluster(id)
xi: reg pv treatment i.fv*i.delay i.college i.female i.race i.religion i.practicing i.family_income i.happiness if pv<fv, cluster(id)

egen Y = group(fv delay), label
tab Y, gen(Y)
tab college, gen(C)
tab female, gen(F)
*One race category will be dropped ("black") because family income is NA for this category and hence it is dropped from all regressions as race & family_income always appear together
tab race if family_income ~= ., gen(R)
tab religion, gen(RL)
tab practicing, gen(P)
tab family_income, gen(FI)
tab happiness, gen(H)
drop C1 F1 R1 RL1 P1 FI1 H1

tab race
tab race if family_income ~= .

foreach condition in "" "if pv<fv" {
	foreach specification in "" "C2-FI8" "H2-H7" "C2-H7" {
		regress pv treatment Y2-Y30 `specification' `condition', cluster(id)
		}
	}

*Code provided by authors to generate sessions
generate Session = 1 if id >= 1000 & id <= 1017
replace Session = 2 if id >= 1040 & id <= 1058
replace Session = 3 if id >= 1059 & id <= 1075
replace Session = 4 if id >= 1086 & id <= 1101
tab Session treatment

save DatIZ, replace


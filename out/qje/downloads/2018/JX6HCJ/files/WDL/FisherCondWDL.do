
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, ]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	`anything' `if' `in', 
	capture testparm `testvars'
	if (_rc == 0) {
		matrix F[$i,1] = r(p), r(drop), e(df_r), $k
		local i = 0
		foreach var in `testvars' {
			matrix B[$j+`i',1] = _b[`var'], _se[`var']
			local i = `i' + 1
			}
		}
global i = $i + 1
global j = $j + $k
end

****************************************
****************************************

use DatWDL, clear

matrix F = J(17,12,.)
matrix B = J(90,2,.)

global j = 1
global i = 1
*Table 1
mycmd (CalInfo CalRef HealthyMenu UnhealthyMenu) regress TotalCal CalInfo CalRef HealthyMenu UnhealthyMenu Age Female AfrAmer if Study2 == 0
mycmd (CalInfo CalRef HealthyMenu UnhealthyMenu) regress TotalCal CalInfo CalRef HealthyMenu UnhealthyMenu Age Female AfrAmer if Study2 == 1
mycmd (CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu) regress TotalCal CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu Age Female AfrAmer Study2 
	
*Table 2 
mycmd (CalInfo CalRef HealthyMenu UnhealthyMenu) regress ChoseLowCalSandwich CalInfo CalRef HealthyMenu UnhealthyMenu Age Female AfrAmer if Study2 == 0
mycmd (CalInfo CalRef HealthyMenu UnhealthyMenu) regress ChoseLowCalSandwich CalInfo CalRef HealthyMenu UnhealthyMenu Age Female AfrAmer if Study2 == 1
mycmd (CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu) regress ChoseLowCalSandwich CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu Age Female AfrAmer Study2 

*Table 3 
mycmd (CalInfo CalRef HealthyMenu UnhealthyMenu) regress NonSandwichCal CalInfo CalRef HealthyMenu UnhealthyMenu Age Female AfrAmer if Study2 == 0
mycmd (CalInfo CalRef HealthyMenu UnhealthyMenu) regress NonSandwichCal CalInfo CalRef HealthyMenu UnhealthyMenu Age Female AfrAmer if Study2 == 1
mycmd (CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu) regress NonSandwichCal CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu Age Female AfrAmer Study2 

*Table 4 
mycmd (CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu) regress EstRecMinusCalRec CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu Age Female AfrAmer Study2 
mycmd (CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu) regress ABSEstRecMinusCalRec CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu Age Female AfrAmer Study2 
mycmd (CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu) regress EstMinusActMealCal CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu Age Female AfrAmer Study2 if EstMinusActMealCal < 1700
mycmd (CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu) regress ABSEstMinusActMealCal CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu Age Female AfrAmer Study2 if EstMinusActMealCal < 1700
mycmd (CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu) regress ConsideredCal CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu Age Female AfrAmer Study2 

*Table 5 
mycmd (CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu) regress TotalCal CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu Age Female AfrAmer Study2 if Overweight == 1
mycmd (CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu) regress ChoseLowCalSandwich CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu Age Female AfrAmer Study2 if Overweight == 1 
mycmd (CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu) regress NonSandwichCal CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu Age Female AfrAmer Study2 if Overweight == 1 
	
sort Study2 SubjectID
generate Order = _n

global i = 0
*Table 1
foreach var in CalInfo CalRef HealthyMenu UnhealthyMenu {
	global i = $i + 1
	local a = "CalInfo CalRef HealthyMenu UnhealthyMenu"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(Study2 `a')
	randcmdc ((`var') regress TotalCal CalInfo CalRef HealthyMenu UnhealthyMenu Age Female AfrAmer if Study2 == 0), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in CalInfo CalRef HealthyMenu UnhealthyMenu {
	global i = $i + 1
	local a = "CalInfo CalRef HealthyMenu UnhealthyMenu"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(Study2 `a')
	randcmdc ((`var') regress TotalCal CalInfo CalRef HealthyMenu UnhealthyMenu Age Female AfrAmer if Study2 == 1), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu {
	global i = $i + 1
	local a = "CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(Study2 `a')
	randcmdc ((`var') regress TotalCal CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu Age Female AfrAmer Study2 ), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

*Table 2
foreach var in CalInfo CalRef HealthyMenu UnhealthyMenu {
	global i = $i + 1
	local a = "CalInfo CalRef HealthyMenu UnhealthyMenu"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(Study2 `a')
	randcmdc ((`var') regress ChoseLowCalSandwich CalInfo CalRef HealthyMenu UnhealthyMenu Age Female AfrAmer if Study2 == 0), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in CalInfo CalRef HealthyMenu UnhealthyMenu {
	global i = $i + 1
	local a = "CalInfo CalRef HealthyMenu UnhealthyMenu"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(Study2 `a')
	randcmdc ((`var') regress ChoseLowCalSandwich CalInfo CalRef HealthyMenu UnhealthyMenu Age Female AfrAmer if Study2 == 1), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu {
	global i = $i + 1
	local a = "CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(Study2 `a')
	randcmdc ((`var') regress ChoseLowCalSandwich CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu Age Female AfrAmer Study2 ), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

*Table 3
foreach var in CalInfo CalRef HealthyMenu UnhealthyMenu {
	global i = $i + 1
	local a = "CalInfo CalRef HealthyMenu UnhealthyMenu"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(Study2 `a')
	randcmdc ((`var') regress NonSandwichCal CalInfo CalRef HealthyMenu UnhealthyMenu Age Female AfrAmer if Study2 == 0), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in CalInfo CalRef HealthyMenu UnhealthyMenu {
	global i = $i + 1
	local a = "CalInfo CalRef HealthyMenu UnhealthyMenu"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(Study2 `a')
	randcmdc ((`var') regress NonSandwichCal CalInfo CalRef HealthyMenu UnhealthyMenu Age Female AfrAmer if Study2 == 1), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu {
	global i = $i + 1
	local a = "CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(Study2 `a')
	randcmdc ((`var') regress NonSandwichCal CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu Age Female AfrAmer Study2 ), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

*Table 4
foreach var in CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu {
	global i = $i + 1
	local a = "CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(Study2 `a')
	randcmdc ((`var') regress EstRecMinusCalRec CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu Age Female AfrAmer Study2 ), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu {
	global i = $i + 1
	local a = "CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(Study2 `a')
	randcmdc ((`var') regress ABSEstRecMinusCalRec CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu Age Female AfrAmer Study2 ), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu {
	global i = $i + 1
	local a = "CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(Study2 `a')
	randcmdc ((`var') regress EstMinusActMealCal CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu Age Female AfrAmer Study2 if EstMinusActMealCal < 1700), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu {
	global i = $i + 1
	local a = "CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(Study2 `a')
	randcmdc ((`var') regress ABSEstMinusActMealCal CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu Age Female AfrAmer Study2 if EstMinusActMealCal < 1700), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu {
	global i = $i + 1
	local a = "CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(Study2 `a')
	randcmdc ((`var') regress ConsideredCal CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu Age Female AfrAmer Study2 ), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

*Table 5
foreach var in CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu {
	global i = $i + 1
	local a = "CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(Study2 `a')
	randcmdc ((`var') regress TotalCal CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu Age Female AfrAmer Study2 if Overweight == 1), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu {
	global i = $i + 1
	local a = "CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(Study2 `a')
	randcmdc ((`var') regress ChoseLowCalSandwich CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu Age Female AfrAmer Study2 if Overweight == 1 ), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach var in CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu {
	global i = $i + 1
	local a = "CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(Study2 `a')
	randcmdc ((`var') regress NonSandwichCal CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu Age Female AfrAmer Study2 if Overweight == 1 ), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}



matrix T = J($i,2,.)
use ip\a1, clear
mkmat __* in 1/1, matrix(a)
drop __*
matrix T[1,1] = a
rename ResB ResB1
rename ResSE ResSE1
rename ResF ResF1
forvalues i = 2/$i {
	merge using ip\a`i'
	mkmat __* in 1/1, matrix(a)
	drop __* _m
	matrix T[`i',1] = a
	rename ResB ResB`i'
	rename ResSE ResSE`i'
	rename ResF ResF`i'
	}
svmat double F
svmat double B
svmat double T
gen N = _n
sort N
compress
aorder
save results\FisherCondWDL, replace



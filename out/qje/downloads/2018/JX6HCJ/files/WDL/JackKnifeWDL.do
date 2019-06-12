

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) robust]
	gettoken testvars anything: anything, match(match)
	`anything' `if' `in', cluster(`cluster') `robust'
	testparm `testvars'
	global k = r(df)
	unab testvars: `testvars'
	mata B = st_matrix("e(b)"); V = st_matrix("e(V)"); V = sqrt(diagonal(V)); BB = B[1,1..$k]',V[1..$k,1]; st_matrix("B",BB)
preserve
	keep if e(sample)
	if ("$cluster" ~= "") egen M = group($cluster)
	if ("$cluster" == "") gen M = _n
	quietly sum M
	global N = r(max)
	mata ResB = J($N,$k,.); ResSE = J($N,$k,.); ResF = J($N,3,.)
	forvalues i = 1/$N {
		if (floor(`i'/50) == `i'/50) display "`i'", _continue
		quietly `anything' if M ~= `i', cluster(`cluster') `robust'
		matrix BB = J($k,2,.)
		local c = 1
		foreach var in `testvars' {
			capture matrix BB[`c',1] = _b[`var'], _se[`var']
			local c = `c' + 1
			}
		capture testparm `testvars'
		if (_rc == 0) mata ResF[`i',1..3] = `r(p)', `r(drop)', `e(df_r)'
		mata BB = st_matrix("BB"); ResB[`i',1..$k] = BB[1..$k,1]'; ResSE[`i',1..$k] = BB[1..$k,2]'
		}
	quietly drop _all
	quietly set obs $N
	global kk = $j + $k - 1
	forvalues i = $j/$kk {
		quietly generate double ResB`i' = .
		}
	forvalues i = $j/$kk {
		quietly generate double ResSE`i' = .
		}
	quietly generate double ResF$i = .
	quietly generate double ResD$i = .
	quietly generate double ResDF$i = .
	mata X = ResB, ResSE, ResF; st_store(.,.,X)
	quietly svmat double B
	quietly rename B2 SE$i
	capture rename B1 B$i
	save ip\JK$i, replace
restore
	global i = $i + 1
	global j = $j + $k
end



*******************

global cluster = ""

use DatWDL, clear

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
	
use ip\JK1, clear
forvalues i = 2/17 {
	merge using ip\JK`i'
	tab _m
	drop _m
	}
quietly sum B1
global k = r(N)
mkmat B1 SE1 in 1/$k, matrix(B)
forvalues i = 2/17 {
	quietly sum B`i'
	global k = r(N)
	mkmat B`i' SE`i' in 1/$k, matrix(BB)
	matrix B = B \ BB
	}
drop B* SE*
svmat double B
aorder
save results\JackKnifeWDL, replace




use DatWDL, clear

*Table 1

global i = 1

regress TotalCal CalInfo CalRef HealthyMenu UnhealthyMenu Age Female AfrAmer if Study2 == 0
	estimates store M$i
	global i = $i + 1

regress TotalCal CalInfo CalRef HealthyMenu UnhealthyMenu Age Female AfrAmer if Study2 == 1
	estimates store M$i
	global i = $i + 1

regress TotalCal CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu Age Female AfrAmer Study2 
	estimates store M$i
	global i = $i + 1


suest M1 M2 M3, robust
test CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu
matrix F = (r(p), r(drop), r(df), r(chi2), 1)

*Table 2 

global i = 1

regress ChoseLowCalSandwich CalInfo CalRef HealthyMenu UnhealthyMenu Age Female AfrAmer if Study2 == 0
	estimates store M$i
	global i = $i + 1

regress ChoseLowCalSandwich CalInfo CalRef HealthyMenu UnhealthyMenu Age Female AfrAmer if Study2 == 1
	estimates store M$i
	global i = $i + 1

regress ChoseLowCalSandwich CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu Age Female AfrAmer Study2 
	estimates store M$i
	global i = $i + 1

suest M1 M2 M3, robust
test CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 2)

*Table 3 

global i = 1

regress NonSandwichCal CalInfo CalRef HealthyMenu UnhealthyMenu Age Female AfrAmer if Study2 == 0
	estimates store M$i
	global i = $i + 1

regress NonSandwichCal CalInfo CalRef HealthyMenu UnhealthyMenu Age Female AfrAmer if Study2 == 1
	estimates store M$i
	global i = $i + 1

regress NonSandwichCal CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu Age Female AfrAmer Study2 
	estimates store M$i
	global i = $i + 1


suest M1 M2 M3, robust
test CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 3)

*Table 4 

global i = 1

regress EstRecMinusCalRec CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu Age Female AfrAmer Study2 
	estimates store M$i
	global i = $i + 1

regress ABSEstRecMinusCalRec CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu Age Female AfrAmer Study2 
	estimates store M$i
	global i = $i + 1

regress EstMinusActMealCal CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu Age Female AfrAmer Study2 if EstMinusActMealCal < 1700
	estimates store M$i
	global i = $i + 1

regress ABSEstMinusActMealCal CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu Age Female AfrAmer Study2 if EstMinusActMealCal < 1700
	estimates store M$i
	global i = $i + 1

regress ConsideredCal CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu Age Female AfrAmer Study2 
	estimates store M$i
	global i = $i + 1


suest M1 M2 M3 M4 M5, robust
test CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 4)

*Table 5 

global i = 1

regress TotalCal CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu Age Female AfrAmer Study2 if Overweight == 1
	estimates store M$i
	global i = $i + 1

regress ChoseLowCalSandwich CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu Age Female AfrAmer Study2 if Overweight == 1 
	estimates store M$i
	global i = $i + 1

regress NonSandwichCal CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu Age Female AfrAmer Study2 if Overweight == 1 
	estimates store M$i
	global i = $i + 1

	
suest M1 M2 M3, robust
test CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 5)
	
sort Study2 SubjectID
mata Y = st_data(.,("CalInfo","CalRef","HealthyMenu","UnhealthyMenu"))
generate Order = _n
generate double U = .

mata ResF = J($reps,25,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() 
	sort Study2 U 
	mata st_store(.,("CalInfo","CalRef","HealthyMenu","UnhealthyMenu"),Y)
	quietly replace StudyHealthyMenu = Study2*HealthyMenu
	quietly replace StudyUnhealthyMenu = Study2*UnhealthyMenu


*Table 1

global i = 1

quietly regress TotalCal CalInfo CalRef HealthyMenu UnhealthyMenu Age Female AfrAmer if Study2 == 0
	estimates store M$i
	global i = $i + 1

quietly regress TotalCal CalInfo CalRef HealthyMenu UnhealthyMenu Age Female AfrAmer if Study2 == 1
	estimates store M$i
	global i = $i + 1

quietly regress TotalCal CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu Age Female AfrAmer Study2 
	estimates store M$i
	global i = $i + 1

capture suest M1 M2 M3, robust
if (_rc == 0) {
	capture test CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu
		if (_rc == 0) {
		mata ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 1)
		}
	}

*Table 2 

global i = 1

quietly regress ChoseLowCalSandwich CalInfo CalRef HealthyMenu UnhealthyMenu Age Female AfrAmer if Study2 == 0
	estimates store M$i
	global i = $i + 1

quietly regress ChoseLowCalSandwich CalInfo CalRef HealthyMenu UnhealthyMenu Age Female AfrAmer if Study2 == 1
	estimates store M$i
	global i = $i + 1

quietly regress ChoseLowCalSandwich CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu Age Female AfrAmer Study2 
	estimates store M$i
	global i = $i + 1

capture suest M1 M2 M3, robust
if (_rc == 0) {
	capture test CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu
		if (_rc == 0) {
		mata ResF[`c',6..10] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 2)
		}
	}

*Table 3 

global i = 1

quietly regress NonSandwichCal CalInfo CalRef HealthyMenu UnhealthyMenu Age Female AfrAmer if Study2 == 0
	estimates store M$i
	global i = $i + 1

quietly regress NonSandwichCal CalInfo CalRef HealthyMenu UnhealthyMenu Age Female AfrAmer if Study2 == 1
	estimates store M$i
	global i = $i + 1

quietly regress NonSandwichCal CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu Age Female AfrAmer Study2 
	estimates store M$i
	global i = $i + 1


capture suest M1 M2 M3, robust
if (_rc == 0) {
	capture test CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu
		if (_rc == 0) {
		mata ResF[`c',11..15] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 3)
		}
	}

*Table 4 

global i = 1

quietly regress EstRecMinusCalRec CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu Age Female AfrAmer Study2 
	estimates store M$i
	global i = $i + 1

quietly regress ABSEstRecMinusCalRec CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu Age Female AfrAmer Study2 
	estimates store M$i
	global i = $i + 1

quietly regress EstMinusActMealCal CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu Age Female AfrAmer Study2 if EstMinusActMealCal < 1700
	estimates store M$i
	global i = $i + 1

quietly regress ABSEstMinusActMealCal CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu Age Female AfrAmer Study2 if EstMinusActMealCal < 1700
	estimates store M$i
	global i = $i + 1

quietly regress ConsideredCal CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu Age Female AfrAmer Study2 
	estimates store M$i
	global i = $i + 1


capture suest M1 M2 M3 M4 M5, robust
if (_rc == 0) {
	capture test CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu
		if (_rc == 0) {
		mata ResF[`c',16..20] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 4)
		}
	}

*Table 5 

global i = 1

quietly regress TotalCal CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu Age Female AfrAmer Study2 if Overweight == 1
	estimates store M$i
	global i = $i + 1

quietly regress ChoseLowCalSandwich CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu Age Female AfrAmer Study2 if Overweight == 1 
	estimates store M$i
	global i = $i + 1

quietly regress NonSandwichCal CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu Age Female AfrAmer Study2 if Overweight == 1 
	estimates store M$i
	global i = $i + 1
	
capture suest M1 M2 M3, robust
if (_rc == 0) {
	capture test CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu
	if (_rc == 0) {
		mata ResF[`c',21..25] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 5)
		}
	}
}

drop _all
set obs $reps
forvalues i = 1/25 {
	quietly generate double ResF`i' = .
	}
mata st_store(.,.,ResF)
svmat double F
gen N = _n
sort N
save results\FisherSuestWDL, replace




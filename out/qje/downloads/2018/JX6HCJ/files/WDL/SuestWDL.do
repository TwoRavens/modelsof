
****************************************
****************************************

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

drop _all
svmat double F
save results/SuestWDL, replace



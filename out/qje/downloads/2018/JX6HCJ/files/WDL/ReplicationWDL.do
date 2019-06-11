

use AEJApp_2008_0129_data.dta, clear

*Table 1 - All okay
regress TotalCal CalInfo CalRef HealthyMenu UnhealthyMenu Age Female AfrAmer if Study2 == 0
regress TotalCal CalInfo CalRef HealthyMenu UnhealthyMenu Age Female AfrAmer if Study2 == 1
regress TotalCal CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu Age Female AfrAmer Study2 

*Table 2 - Assorted rounding errors
regress ChoseLowCalSandwich CalInfo CalRef HealthyMenu UnhealthyMenu Age Female AfrAmer if Study2 == 0
regress ChoseLowCalSandwich CalInfo CalRef HealthyMenu UnhealthyMenu Age Female AfrAmer if Study2 == 1
regress ChoseLowCalSandwich CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu Age Female AfrAmer Study2 

*Table 3 - All okay
regress NonSandwichCal CalInfo CalRef HealthyMenu UnhealthyMenu Age Female AfrAmer if Study2 == 0
regress NonSandwichCal CalInfo CalRef HealthyMenu UnhealthyMenu Age Female AfrAmer if Study2 == 1
regress NonSandwichCal CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu Age Female AfrAmer Study2 


*Table 4 - Big error in coefficient col (1), some minor rounding errors
*do-file code does not provide sample restriction cols (3)-(4) mentioned in table, figured it out, some R2 errors
regress EstRecMinusCalRec CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu Age Female AfrAmer Study2 
regress ABSEstRecMinusCalRec CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu Age Female AfrAmer Study2 
regress EstMinusActMealCal CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu Age Female AfrAmer Study2 if EstMinusActMealCal < 1700
regress ABSEstMinusActMealCal CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu Age Female AfrAmer Study2 if EstMinusActMealCal < 1700
regress ConsideredCal CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu Age Female AfrAmer Study2 

*Table 5 - Assorted rounding errors
regress TotalCal CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu Age Female AfrAmer Study2 if Overweight == 1
regress ChoseLowCalSandwich CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu Age Female AfrAmer Study2 if Overweight == 1 
regress NonSandwichCal CalInfo CalRef HealthyMenu UnhealthyMenu StudyHealthyMenu StudyUnhealthyMenu Age Female AfrAmer Study2 if Overweight == 1 

save DatWDL, replace


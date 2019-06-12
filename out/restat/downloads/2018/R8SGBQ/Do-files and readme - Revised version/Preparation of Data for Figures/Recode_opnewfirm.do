********************************************************************************

********************************************************************************
**THIS DO-FILE PREPARES THE FIRM PANEL DATASET FOR APPENDIX FIGURE A.2 OF THE PAPER 
**NOTE THAT THIS DO-FILE HAS ONLY INFORMATIONAL PURPOSE AS THE UNDERLYING RAW DATA IS NOT MADE AVAILABLE
**Small Firm Death in Developing Countries
**September 5, 2017
**David McKenzie (dmckenzie@worldbank.org) and Anna Luisa Paffhausen (apaffhausen@worldbank.org)
**The analysis was performed with Stata, version 14.2

*Note: 	This do-file prepares the firm panel dataset for appendix figure A.2. 
*		It cannot cannot be used for replication as the underlying raw data is not made available, and is included for informational purposes only.

********************************************************************************

********************************************************************************

********************************************************************************
*SLMS
********************************************************************************
use SLMS1, clear
forvalues i=2/15{
merge 1:1 sheno using SLMS`i', nogenerate
}

quietly: reshape long 	surveyyear wave excrate excratemonth ///
						capitalstock inventories ///
						ownerage female married educyears ownertertiary childunder5 childaged5to12 adult65andover digitspan raven ///
						agefirm retail manuf services ///
						, ///
						i(sheno) j(survey)
		
foreach x in  profits sales hours hoursnormal employees pcexpend {
replace `x'=. if wave!=1
}	

g operatingnewfirm2=newfirmstarted2 if attrit2!=1
*Businesses are coded as operating a new firm in next round if
*they reported to have closed and opened a new business in previous round (survival2=0 & newfirmstart2=1) and are still operating this new business in next round (survival3=1)
*they reported to have closed a business, but not to have opened a new business (survival2=0 & (newfirmstart2=0 | newfirmstart2=.)), in the previous round and say that they are still in the same line of business as in the previous round in the next round (survival3=1)
g operatingnewfirm3=(survival3==1 & survival2==0) |  (survival3==0 & newfirmstarted3==1) if attrit3!=1 & survival3!=.

forvalues i=3/10{
local j=`i'+1
g operatingnewfirm`j'=(operatingnewfirm`i'==1 & survival`j'==1) | (survival`j'==1 & survival`i'==0) | (survival`j'==0 & newfirmstarted`j'==1) if attrit`j'!=1 & survival`j'!=.
}

*Given that in round 12, the reference was the baseline, coding changes here, but since I do not look at such long horizons, I don't do it

*Recode survival, which has so far been coded from round to round so that it gives survival since baseline
*(Given that in round 12, the reference was the baseline, I do not have to recode survival12)
replace survival15=0 if survival12==0 & survival13==0 & survival14==0 & newfirmstarted14==1
replace survival15=0 if survival12==0 & survival13==1 & survival14==0 & newfirmstarted14==1
replace survival15=0 if survival12==1 & survival13==1 & survival14==0 & newfirmstarted14==1
replace survival15=0 if survival12==1 & survival13==1 & survival14==0 & newfirmstarted14==1
replace survival15=0 if survival12==1 & survival13==0 & newfirmstarted13==1
replace survival15=0 if survival12==0 & survival13==0 & newfirmstarted13==1
replace survival15=0 if survival12==0 & survival13==1 & newfirmstarted12==1

replace survival14=0 if survival12==1 & survival13==0 & newfirmstarted13==1
replace survival14=0 if survival12==0 & survival13==0 & newfirmstarted13==1
replace survival14=0 if survival12==0 & survival13==1 & newfirmstarted12==1

replace survival13=0 if survival12==0 & survival13==1 & newfirmstarted12==1

*Given that in round 12, the reference was the baseline, I do not have to recode survival12

replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & newfirmstarted4==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival11=0 if survival2==1 & survival3==0 & newfirmstarted3==1
replace survival11=0 if survival2==0 & survival3==0 & newfirmstarted3==1
replace survival11=0 if survival2==0 & survival3==1 & newfirmstarted2==1

replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & newfirmstarted4==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival10=0 if survival2==1 & survival3==0 & newfirmstarted3==1
replace survival10=0 if survival2==0 & survival3==0 & newfirmstarted3==1
replace survival10=0 if survival2==0 & survival3==1 & newfirmstarted2==1

replace survival9=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==0 & newfirmstarted4==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival9=0 if survival2==1 & survival3==0 & newfirmstarted3==1
replace survival9=0 if survival2==0 & survival3==0 & newfirmstarted3==1
replace survival9=0 if survival2==0 & survival3==1 & newfirmstarted2==1

replace survival8=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival8=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival8=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival8=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival8=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival8=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival8=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival8=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival8=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival8=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival8=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival8=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival8=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival8=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival8=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival8=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival8=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival8=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival8=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival8=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival8=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival8=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival8=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival8=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival8=0 if survival2==0 & survival3==0 & survival4==0 & newfirmstarted4==1
replace survival8=0 if survival2==0 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival8=0 if survival2==1 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival8=0 if survival2==1 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival8=0 if survival2==1 & survival3==0 & newfirmstarted3==1
replace survival8=0 if survival2==0 & survival3==0 & newfirmstarted3==1
replace survival8=0 if survival2==0 & survival3==1 & newfirmstarted2==1

replace survival7=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival7=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival7=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival7=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival7=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival7=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival7=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival7=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival7=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival7=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival7=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival7=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival7=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival7=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival7=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival7=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival7=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival7=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival7=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival7=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival7=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival7=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival7=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival7=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival7=0 if survival2==0 & survival3==0 & survival4==0 & newfirmstarted4==1
replace survival7=0 if survival2==0 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival7=0 if survival2==1 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival7=0 if survival2==1 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival7=0 if survival2==1 & survival3==0 & newfirmstarted3==1
replace survival7=0 if survival2==0 & survival3==0 & newfirmstarted3==1
replace survival7=0 if survival2==0 & survival3==1 & newfirmstarted2==1

replace survival6=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival6=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival6=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival6=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival6=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival6=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival6=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival6=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival6=0 if survival2==0 & survival3==0 & survival4==0 & newfirmstarted4==1
replace survival6=0 if survival2==0 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival6=0 if survival2==1 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival6=0 if survival2==1 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival6=0 if survival2==1 & survival3==0 & newfirmstarted3==1
replace survival6=0 if survival2==0 & survival3==0 & newfirmstarted3==1
replace survival6=0 if survival2==0 & survival3==1 & newfirmstarted2==1

replace survival5=0 if survival2==0 & survival3==0 & survival4==0 & newfirmstarted4==1
replace survival5=0 if survival2==0 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival5=0 if survival2==1 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival5=0 if survival2==1 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival5=0 if survival2==1 & survival3==0 & newfirmstarted3==1
replace survival5=0 if survival2==0 & survival3==0 & newfirmstarted3==1
replace survival5=0 if survival2==0 & survival3==1 & newfirmstarted2==1

replace survival4=0 if survival2==1 & survival3==0 & newfirmstarted3==1
replace survival4=0 if survival2==0 & survival3==0 & newfirmstarted3==1
replace survival4=0 if survival2==0 & survival3==1 & newfirmstarted2==1

replace survival3=0 if survival2==0 & survival3==1 & newfirmstarted2==1

*Only keep if business is operating
forvalues i=2/15{
drop if survival`i'!=1 & wave==`i'
}

foreach x in survival newfirmstarted attrit mainactivity laborincome{
g `x'_3mths=`x'2 if wave==1
drop `x'2
g `x'_6mths=`x'3 if wave==1
drop `x'3
g `x'_9mths=`x'4 if wave==1
drop `x'4
g `x'_1yr=`x'5 if wave==1
drop `x'5
g `x'_1p25yrs=`x'6 if wave==1
drop `x'6
g `x'_18mths=`x'7 if wave==1
drop `x'7
g `x'_1p75yrs=`x'8 if wave==1
drop `x'8
g `x'_2yrs=`x'9 if wave==1
drop `x'9
g `x'_30mths=`x'10 if wave==1
drop `x'10
g `x'_3yrs=`x'11 if wave==1
drop `x'11
g `x'_5p17yrs=`x'12 if wave==1
drop `x'12
g `x'_5p67yrs=`x'13 if wave==1
drop `x'13
g `x'_10p416yrs=`x'14 if wave==1
drop `x'14
g `x'_10p916yrs=`x'15 if wave==1
drop `x'15
}	

foreach x in reasonclosure operatingnewfirm{
g `x'_3mths=`x'2 if wave==1
drop `x'2
g `x'_6mths=`x'3 if wave==1
drop `x'3
g `x'_9mths=`x'4 if wave==1
drop `x'4
g `x'_1yr=`x'5 if wave==1
drop `x'5
g `x'_1p25yrs=`x'6 if wave==1
drop `x'6
g `x'_18mths=`x'7 if wave==1
drop `x'7
g `x'_1p75yrs=`x'8 if wave==1
drop `x'8
g `x'_2yrs=`x'9 if wave==1
drop `x'9
g `x'_30mths=`x'10 if wave==1
drop `x'10
g `x'_3yrs=`x'11 if wave==1
drop `x'11
}

foreach x in hoursnormal subjwell{
g `x'_5p17yrs=`x'12 if wave==1
drop `x'12
g `x'_5p67yrs=`x'13 if wave==1
drop `x'13
g `x'_10p416yrs=`x'14 if wave==1
drop `x'14
g `x'_10p916yrs=`x'15 if wave==1
drop `x'15
}

foreach x in pcexpend{
g `x'_1yr=`x'5 if wave==1
drop `x'5
g `x'_2yrs=`x'9 if wave==1
drop `x'9
g `x'_3yrs=`x'11 if wave==1
drop `x'11
g `x'_10p416yrs=`x'14 if wave==1
drop `x'14
}

foreach x in subjwell9l{
g `x'_6mths=`x'3 if wave==1
drop `x'3
}

replace surveyyear=2005 if wave==1 | wave==2 | wave==3
replace surveyyear=2006 if wave==4 | wave==5 | wave==6 | wave==7
replace surveyyear=2007 if wave==8 | wave==9 | wave==10
replace surveyyear=2008 if wave==11 
replace surveyyear=2010 if wave==12 | wave==13
replace surveyyear=2015 if wave==14  
replace surveyyear=2016 if wave==15  

tostring survey, replace
replace survey="BL-"+string(surveyyear) if wave==1
replace survey="R-"+string(surveyyear)+"-1" if wave==2 
replace survey="R-"+string(surveyyear)+"-2" if wave==3 
replace survey="R-"+string(surveyyear)+"-1" if wave==4
replace survey="R-"+string(surveyyear)+"-2" if wave==5
replace survey="R-"+string(surveyyear)+"-3" if wave==6
replace survey="R-"+string(surveyyear)+"-4" if wave==7
replace survey="R-"+string(surveyyear)+"-1" if wave==8
replace survey="R-"+string(surveyyear)+"-2" if wave==9
replace survey="R-"+string(surveyyear)+"-3" if wave==10
replace survey="R-"+string(surveyyear) if wave==11
replace survey="R-"+string(surveyyear)+"-1" if wave==12
replace survey="R-"+string(surveyyear)+"-2" if wave==13
replace survey="R-"+string(surveyyear) if wave==14
replace survey="L-"+string(surveyyear) if wave==15

g lastround=(wave==15)

*Generate owner, household and business id (which are the same here)
foreach var in ownerid firmid householdid{
egen `var'=group(sheno)
tostring `var', format("%04.0f") replace
replace `var'="SLMS"+"-"+`var'
}

g surveyname="SLMS"

save SLMS_for_opnewfirm,replace

********************************************************************************
*GHANAFLYP
********************************************************************************
set more off
use GHANAFLYP1, clear
forvalues i=2/6{
merge 1:1 SHENO using GHANAFLYP`i', nogenerate
}

*I don't think that the values I am using are in the old currency so I drop them:
drop excrateold*
rename hoursnormal hoursnormal1

quietly: reshape long 	surveyyear wave excrate excratemonth ///
						capitalstock inventories hoursnormal ///
						ownerage female married educyears ownertertiary childunder5 childaged5to12 adult65andover digitspan raven subjwell ///
						agefirm retail manuf services ///
						, ///
						i(sheno) j(survey)
		
foreach x in profits sales hours employees pcexpend competition1 competition2 competition3 {
replace `x'=. if wave!=1
}	

g operatingnewfirm2=newfirmstarted2 if attrit2!=1
*Businesses are coded as operating a new firm in next round if
*they reported to have closed and opened a new business in previous round (survival2=0 & newfirmstart2=1) and are still operating this new business in next round (survival3=1)
*they reported to have closed a business, but not to have opened a new business (survival2=0 & (newfirmstart2=0 | newfirmstart2=.)), in the previous round and say that they are still in the same line of business as in the previous round in the next round (survival3=1)
g operatingnewfirm3=(survival3==1 & survival2==0) |  (survival3==0 & newfirmstarted3==1) if attrit3!=1 & survival3!=.

forvalues i=3/5{
local j=`i'+1
g operatingnewfirm`j'=(operatingnewfirm`i'==1 & survival`j'==1) | (survival`j'==1 & survival`i'==0) | (survival`j'==0 & newfirmstarted`j'==1) if attrit`j'!=1 & survival`j'!=.
}

*Recode survival, so that it gives survival since baseline, assuming that so far it has been coded from round to round
replace survival6=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival6=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival6=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival6=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival6=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival6=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival6=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival6=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival6=0 if survival2==0 & survival3==0 & survival4==0 & newfirmstarted4==1
replace survival6=0 if survival2==0 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival6=0 if survival2==1 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival6=0 if survival2==1 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival6=0 if survival2==1 & survival3==0 & newfirmstarted3==1
replace survival6=0 if survival2==0 & survival3==0 & newfirmstarted3==1
replace survival6=0 if survival2==0 & survival3==1 & newfirmstarted2==1

replace survival5=0 if survival2==0 & survival3==0 & survival4==0 & newfirmstarted4==1
replace survival5=0 if survival2==0 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival5=0 if survival2==1 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival5=0 if survival2==1 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival5=0 if survival2==1 & survival3==0 & newfirmstarted3==1
replace survival5=0 if survival2==0 & survival3==0 & newfirmstarted3==1
replace survival5=0 if survival2==0 & survival3==1 & newfirmstarted2==1

replace survival4=0 if survival2==1 & survival3==0 & newfirmstarted3==1
replace survival4=0 if survival2==0 & survival3==0 & newfirmstarted3==1
replace survival4=0 if survival2==0 & survival3==1 & newfirmstarted2==1

replace survival3=0 if survival2==0 & survival3==1 & newfirmstarted2==1

*Only keep if business is operating
forvalues i=2/6{
drop if survival`i'!=1 & wave==`i'
}

foreach x in survival newfirmstarted operatingnewfirm attrit mainactivity employees pcexpend introduction_10{
g `x'_4mths=`x'2 if wave==1
drop `x'2
g `x'_7mths=`x'3 if wave==1
drop `x'3
g `x'_10mths=`x'4 if wave==1
drop `x'4
g `x'_1p083yrs=`x'5 if wave==1
drop `x'5
g `x'_1p33yrs=`x'6 if wave==1
drop `x'6
}	

tostring survey, replace
replace survey="BL-"+string(surveyyear) if wave==1
replace survey="R-"+string(surveyyear)+"-1" if wave==2 
replace survey="R-"+string(surveyyear)+"-2" if wave==3 
replace survey="R-"+string(surveyyear)+"-3" if wave==4
replace survey="R-"+string(surveyyear)+"-4" if wave==5
replace survey="L-"+string(surveyyear) if wave==6

g lastround=(wave==6)

*Generate owner, household and business id (which are the same here)
foreach var in ownerid firmid householdid{
egen `var'=group(SHENO)
tostring `var', format("%04.0f") replace
replace `var'="GHANAFLYP"+"-"+`var'
}

g surveyname="GHANAFLYP"

save GHANAFLYP_for_opnewfirm,replace

********************************************************************************
*SLLSE
********************************************************************************
use SLLSE1, clear

merge 1:1 respondent_id using "SLLSE/FirmDeathDataSLLSEclean.dta", nogenerate keep(matched)

g treatstatus=(control==0)

forvalues i=2/11{
g excratemonth`i'=string(surveymonth`i') + "-" + string(surveyyear`i')
}

*excrate2 at April 15, 2009:
g excrate2=0.00862
*excrate3 at October 15, 2009:
g excrate3=0.00870
*excrate4 at April 15, 2010:
g excrate4=0.00878
*excrate5 at October 15, 2010:
g excrate5=0.00894
*excrate6 at April 15, 2011:
g excrate6=0.00905
*excrate7 at October 15, 2011:
g excrate7=0.00906
*excrate8 at April 15, 2012:
g excrate8=0.00772
*excrate9 at October 15, 2012:
g excrate9=0.00762
*excrate10 at April 15, 2013:
g excrate10=0.00797
*excrate11 at April 15, 2014:
g excrate11=0.00765

quietly: reshape long 	surveyyear wave excrate excratemonth ///
						ownerage female married educyears ownertertiary childunder5 childaged5to12 adult65andover digitspan raven ///
						agefirm capitalstock inventories retail manuf services othersector sector employees profits sales hours hoursnormal subjwell ///
						competition1 competition2 competition3, ///
						i(respondent_id) j(survey)
						
replace wave=survey

g operatingnewfirm2=newfirmstarted2 if attrit2!=1
*Businesses are coded as operating a new firm in next round if
*they reported to have closed and opened a new business in previous round (survival2=0 & newfirmstart2=1) and are still operating this new business in next round (survival3=1)
*they reported to have closed a business, but not to have opened a new business (survival2=0 & (newfirmstart2=0 | newfirmstart2=.)), in the previous round and say that they are still in the same line of business as in the previous round in the next round (survival3=1)
g operatingnewfirm3=(survival3==1 & survival2==0) |  (survival3==0 & newfirmstarted3==1) if attrit3!=1 & survival3!=.

forvalues i=3/10{
local j=`i'+1
g operatingnewfirm`j'=(operatingnewfirm`i'==1 & survival`j'==1) | (survival`j'==1 & survival`i'==0) | (survival`j'==0 & newfirmstarted`j'==1) if attrit`j'!=1 & survival`j'!=.
}

*Recode survival, which has so far been coded from round to round so that it gives survival since baseline

replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==1 & survival10==0 & newfirmstarted10==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival11=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival11=0 if survival2==0 & survival3==0 & survival4==0 & newfirmstarted4==1
replace survival11=0 if survival2==0 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival11=0 if survival2==1 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival11=0 if survival2==1 & survival3==0 & newfirmstarted3==1
replace survival11=0 if survival2==0 & survival3==0 & newfirmstarted3==1
replace survival11=0 if survival2==0 & survival3==1 & newfirmstarted2==1

replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==1 & survival9==0 & newfirmstarted9==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival10=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival10=0 if survival2==0 & survival3==0 & survival4==0 & newfirmstarted4==1
replace survival10=0 if survival2==0 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival10=0 if survival2==1 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival10=0 if survival2==1 & survival3==0 & newfirmstarted3==1
replace survival10=0 if survival2==0 & survival3==0 & newfirmstarted3==1
replace survival10=0 if survival2==0 & survival3==1 & newfirmstarted2==1

replace survival9=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==1 & survival8==0 & newfirmstarted8==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival9=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival9=0 if survival2==0 & survival3==0 & survival4==0 & newfirmstarted4==1
replace survival9=0 if survival2==0 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival9=0 if survival2==1 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival9=0 if survival2==1 & survival3==0 & newfirmstarted3==1
replace survival9=0 if survival2==0 & survival3==0 & newfirmstarted3==1
replace survival9=0 if survival2==0 & survival3==1 & newfirmstarted2==1

replace survival8=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==1 & survival7==0 & newfirmstarted7==1
replace survival8=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival8=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival8=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival8=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival8=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival8=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival8=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival8=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival8=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival8=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival8=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival8=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival8=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival8=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival8=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival8=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival8=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival8=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival8=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival8=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival8=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival8=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival8=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival8=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival8=0 if survival2==0 & survival3==0 & survival4==0 & newfirmstarted4==1
replace survival8=0 if survival2==0 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival8=0 if survival2==1 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival8=0 if survival2==1 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival8=0 if survival2==1 & survival3==0 & newfirmstarted3==1
replace survival8=0 if survival2==0 & survival3==0 & newfirmstarted3==1
replace survival8=0 if survival2==0 & survival3==1 & newfirmstarted2==1

replace survival7=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival7=0 if survival2==0 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival7=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival7=0 if survival2==0 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival7=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival7=0 if survival2==0 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival7=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival7=0 if survival2==0 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival7=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival7=0 if survival2==1 & survival3==0 & survival4==0 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival7=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival7=0 if survival2==1 & survival3==0 & survival4==1 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival7=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival7=0 if survival2==1 & survival3==1 & survival4==0 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival7=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & survival6==0 & newfirmstarted6==1
replace survival7=0 if survival2==1 & survival3==1 & survival4==1 & survival5==1 & survival6==0 & newfirmstarted6==1
replace survival7=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival7=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival7=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival7=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival7=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival7=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival7=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival7=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival7=0 if survival2==0 & survival3==0 & survival4==0 & newfirmstarted4==1
replace survival7=0 if survival2==0 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival7=0 if survival2==1 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival7=0 if survival2==1 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival7=0 if survival2==1 & survival3==0 & newfirmstarted3==1
replace survival7=0 if survival2==0 & survival3==0 & newfirmstarted3==1
replace survival7=0 if survival2==0 & survival3==1 & newfirmstarted2==1

replace survival6=0 if survival2==0 & survival3==0 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival6=0 if survival2==0 & survival3==0 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival6=0 if survival2==0 & survival3==1 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival6=0 if survival2==0 & survival3==1 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival6=0 if survival2==1 & survival3==0 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival6=0 if survival2==1 & survival3==0 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival6=0 if survival2==1 & survival3==1 & survival4==0 & survival5==0 & newfirmstarted5==1
replace survival6=0 if survival2==1 & survival3==1 & survival4==1 & survival5==0 & newfirmstarted5==1
replace survival6=0 if survival2==0 & survival3==0 & survival4==0 & newfirmstarted4==1
replace survival6=0 if survival2==0 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival6=0 if survival2==1 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival6=0 if survival2==1 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival6=0 if survival2==1 & survival3==0 & newfirmstarted3==1
replace survival6=0 if survival2==0 & survival3==0 & newfirmstarted3==1
replace survival6=0 if survival2==0 & survival3==1 & newfirmstarted2==1

replace survival5=0 if survival2==0 & survival3==0 & survival4==0 & newfirmstarted4==1
replace survival5=0 if survival2==0 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival5=0 if survival2==1 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival5=0 if survival2==1 & survival3==1 & survival4==0 & newfirmstarted4==1
replace survival5=0 if survival2==1 & survival3==0 & newfirmstarted3==1
replace survival5=0 if survival2==0 & survival3==0 & newfirmstarted3==1
replace survival5=0 if survival2==0 & survival3==1 & newfirmstarted2==1

replace survival4=0 if survival2==1 & survival3==0 & newfirmstarted3==1
replace survival4=0 if survival2==0 & survival3==0 & newfirmstarted3==1
replace survival4=0 if survival2==0 & survival3==1 & newfirmstarted2==1

replace survival3=0 if survival2==0 & survival3==1 & newfirmstarted2==1

*Only keep if business is operating
forvalues i=2/11{
drop if survival`i'!=1 & wave==`i'
}

foreach x in survival newfirmstarted operatingnewfirm attrit mainactivity reasonforclosure laborincome{
g `x'_6mths=`x'2 if wave==1
drop `x'2
g `x'_1yr=`x'3 if wave==1
drop `x'3
g `x'_18mths=`x'4 if wave==1
drop `x'4
g `x'_2yrs=`x'5 if wave==1
drop `x'5
g `x'_30mths=`x'6 if wave==1
drop `x'6
g `x'_3yrs=`x'7 if wave==1
drop `x'7
g `x'_3p5yrs=`x'8 if wave==1
drop `x'8
g `x'_4yrs=`x'9 if wave==1
drop `x'9
g `x'_4p5yrs=`x'10 if wave==1
drop `x'10
g `x'_5p5yrs=`x'11 if wave==1
drop `x'11
}	

tostring survey, replace
replace survey="BL-"+string(surveyyear) if wave==1
replace survey="R-"+string(surveyyear) if wave>1 & wave<11 
replace survey="L-"+string(surveyyear) if wave==11

g lastround=(wave==11)

*Generate owner, household and business id (which are the same here)
foreach var in ownerid firmid householdid{
egen `var'=group(respondent_id)
tostring `var', format("%04.0f") replace
replace `var'="SLLSE"+"-"+`var'
}
drop booster surveymonth*

g surveyname="SLLSE"


save SLLSE_for_opnewfirm,replace

********************************************************************************
*SLK FEMALE BUSINESS TRAINING
********************************************************************************
use SLKFEMBUSTRAINING1, clear

merge 1:1 sheno using SLKFEMBUSTRAINING2, nogenerate
merge 1:1 sheno using SLKFEMBUSTRAINING3, nogenerate
merge 1:1 sheno using SLKFEMBUSTRAINING4, nogenerate
merge 1:1 sheno using SLKFEMBUSTRAINING5, nogenerate

keep if BL==1

foreach x in profits sales hours hoursnormal employees {
rename `x'1 `x'
}

quietly: reshape long 	surveyyear excrate excratemonth ///
						capitalstock inventories competition1 ///
						ownerage female married educyears ownertertiary childunder5 childaged5to12 adult65andover digitspan raven ///
						agefirm retail manuf services othersector sector totalworkers ///
						multi, ///
						i(sheno) j(survey)
		
replace wave=survey

foreach x in  profits sales hours hoursnormal employees {
replace `x'=. if wave!=1
}	

g operatingnewfirm2=newfirmstarted2 if attrit2!=1
*Businesses are coded as operating a new firm in next round if
*they reported to have closed and opened a new business in previous round (survival2=0 & newfirmstart2=1) and are still operating this new business in next round (survival3=1)
*they reported to have closed a business, but not to have opened a new business (survival2=0 & (newfirmstart2=0 | newfirmstart2=.)), in the previous round and say that they are still in the same line of business as in the previous round in the next round (survival3=1)
g operatingnewfirm3=(survival3==1 & survival2==0) |  (survival3==0 & newfirmstarted3==1) if attrit3!=1 & survival3!=.

g operatingnewfirm4=(operatingnewfirm3==1 & survival4==1) | (survival4==1 & survival3==0) | (survival4==0 & newfirmstarted4==1) if attrit4!=1 & survival4!=.

*Given that in the last round, the reference was the baseline, and it is over 3 years after baseline, I don't code it

*Recode survival, which has so far been coded from round to round so that it gives survival since baseline
*(Given that in the last round, the reference was the baseline, I do not have to recode survival5)
replace survival4=0 if survival2==1 & survival3==0 & newfirmstarted3==1
replace survival4=0 if survival2==0 & survival3==1 & newfirmstarted2==1
replace survival4=0 if survival2==0 & survival3==0 & newfirmstarted3==1
replace survival3=0 if survival2==0 & survival3==1 & newfirmstarted2==1

*Only keep if business is operating
forvalues i=2/5{
drop if survival`i'!=1 & wave==`i'
}

foreach x in sales profits survival mainactivity newfirmstarted hours hoursnormal laborincome attrit{
g `x'_4mths=`x'2 if wave==1
drop `x'2
g `x'_1yr=`x'3 if wave==1
drop `x'3
g `x'_1p75yrs=`x'4 if wave==1
drop `x'4
g `x'_5p75yrs=`x'5 if wave==1
drop `x'5
}	

foreach x in operatingnewfirm{
g `x'_4mths=`x'2 if wave==1
drop `x'2
g `x'_1yr=`x'3 if wave==1
drop `x'3
g `x'_1p75yrs=`x'4 if wave==1
drop `x'4
}	

foreach x in reasonclosure employees{
g `x'_5p75yrs=`x'5 if wave==1
drop `x'5
}

ds q2_9* q2_12* r6*, has(type numeric)
foreach var of varlist `r(varlist)'{
replace `var'=. if wave!=1
}

tostring survey, replace
replace survey="BL-"+string(surveyyear) if wave==1
replace survey="R-"+string(surveyyear)+"-1" if wave==2 
replace survey="R-"+string(surveyyear)+"-2" if wave==3 
replace survey="R-"+string(surveyyear) if wave==4 
replace survey="L-"+string(surveyyear) if wave==5

g lastround=(wave==5)

*Generate owner, household and business id (which are the same here)
foreach var in ownerid firmid householdid{
egen `var'=group(sheno)
tostring `var', format("%04.0f") replace
replace `var'="SLKFEMBUSTRAINING"+"-"+`var'
}

g control=(treatstatus==0)

g surveyname="SLKFEMBUSTRAINING"

save SLKFEMBUSTRAINING_for_opnewfirm,replace

********************************************************************************
*MALAWI FORMALIZATION
********************************************************************************
use MALAWIFORM_masterfc, clear

*No need to recode it since it is already coded since baseline. I just create the variable called operatingnewfirm=newfirmstarted

foreach x in 1yr 1p833yrs 2p9167yrs 3p5yrs{
g operatingnewfirm_`x'=newfirmstarted_`x'
}

save MALAWIFORM_for_opnewfirm,replace

********************************************************************************
*BENIN FORMALIZATION
********************************************************************************
use BENINFORM1, clear
forvalues i=2/3{
merge 1:1 ID_firm_anonym using BENINFORM`i', nogenerate
}

quietly: reshape long 	surveyyear wave excrate excratemonth ///
						ownerage female educyears ///
						agefirmBeninr agefirm retail manuf services sector ///
						, ///
						i(ID_firm_anonym) j(survey)
							
foreach x in profits sales totalworkers {
replace `x'=. if wave!=1
}	

g operatingnewfirm2=newfirmstarted2 if attrit2!=1 | survival2!=.
*Businesses are coded as operating a new firm in next round if
*they reported to have closed and opened a new business in previous round (survival2=0 & newfirmstart2=1) and are still operating this new business in next round (survival3=1)
*they reported to have closed a business, but not to have opened a new business (survival2=0 & (newfirmstart2=0 | newfirmstart2=.)), in the previous round and say that they are still in the same line of business as in the previous round in the next round (survival3=1)
g operatingnewfirm3=(survival3==1 & survival2==0) |  (survival3==0 & newfirmstarted3==1) if attrit3!=1 | survival3!=.

*Recode survival, so that it gives survival since baseline, assuming that so far it has been coded from round to round
replace survival3=0 if survival2==0 & survival3==1 & newfirmstarted2==1

*Only keep if business is operating
forvalues i=2/3{
drop if survival`i'!=1 & wave==`i'
}

foreach x in survival newfirmstarted attrit totalworkers hours hoursnormal subjwell profits sales died operatingnewfirm{
g `x'_1p083yrs=`x'2 if wave==1
drop `x'2
g `x'_2p167yrs=`x'3 if wave==1
drop `x'3
}	

foreach x in reasonclosure mainactivity wageworker laborincome {
g `x'_2p167yrs=`x'3 if wave==1
drop `x'3
}

*Somehow survey receives a value label which then prevents me from doing the tostring so I work around it this way:
rename survey surveyuseless
g survey=surveyuseless
drop surveyuseless

tostring survey, replace
replace survey="BL-"+string(surveyyear) if wave==1
replace survey="R-"+string(surveyyear) if wave==2 
replace survey="L-"+string(surveyyear) if wave==3 

g lastround=(wave==3)

*Generate owner, household and business id (which are the same here)
foreach var in ownerid firmid householdid{
egen `var'=group(ID_firm_anonym)
tostring `var', format("%04.0f") replace
replace `var'="BENINFORM"+"-"+`var'
}

g surveyname="BENINFORM"

save BENINFORM_for_opnewfirm,replace

********************************************************************************
*NIGERIA YOUWiN
********************************************************************************
*No need since the recoding has been done in the original do-file

********************************************************************************
*KENYA GET AHEAD 
********************************************************************************
use KENYAGETAHEAD1, clear

merge 1:1 respondent_id using "Kenya GET Ahead/KenyaFirmDeathPanel.dta", nogenerate

rename bustraining1 bustraining
rename treatstatus1 treatstatus

g excratemonth2="8-2014"
g excratemonth3="4-2016"

forvalues i=2/3{
replace excrate`i'=1/excrate`i'
}

replace attrit3=(attrit3==0)

foreach var of varlist sales1 sales2 sales3 profits2 profits3 laborincome2 laborincome3{
replace `var'=`var'*(30/7)
}

*Generate main activity after closing business
g mainactivity2=1 if sec3_8_=="1"
replace mainactivity2=2 if sec3_8_=="2"
replace mainactivity2=3 if newfirmstarted2==1
replace mainactivity2=4 if sec3_8_=="3"
replace mainactivity2=5 if sec3_8_=="other"

g mainactivity3=1 if r3_sec3_10==1
replace mainactivity3=2 if r3_sec3_10==2
replace mainactivity3=3 if newfirmstarted3==1
replace mainactivity3=4 if r3_sec3_10==3
replace mainactivity3=5 if r3_sec3_10==4

label define mainactivity 	1 "Working for a wage" ///
							2 "Looking for work" ///
							3 "Operating a different business" ///
							4 "Housework or looking after children" ///
							5 "Other"

label values mainactivity* mainactivity	

quietly: reshape long 	surveyyear wave excrate excratemonth ///
						ownerage female married educyears ownertertiary childunder5 childaged5to12 adult65andover digitspan raven ///
						startreason agefirm capitalstock inventories retail manuf services employees profits sales hours hoursnormal wageworker ///
						competition1, ///
						i(respondent_id) j(survey)
						
replace wave=survey

*Since we are using data from 2 follow-up surveys, I seems that the cases which have newfirmstarted2==1 and survival2==1, survived to the first fu and then closed and opened a new one in the second fu, or closed and opened new firm in fu2 and then were coded as surviving in fu2, because this new business continued to be open
replace survival2=0 if newfirmstarted2==1 & survival2==1

g operatingnewfirm2=newfirmstarted2
*Businesses are coded as operating a new firm in next round if
*they reported to have closed and opened a new business in previous round (survival2=0 & newfirmstart2=1) and are still operating this new business in next round (survival3=1)
*they reported to have closed a business, but not to have opened a new business (survival2=0 & (newfirmstart2=0 | newfirmstart2=.)), in the previous round and say that they are still in the same line of business as in the previous round in the next round (survival3=1)
g operatingnewfirm3=(survival3==1 & survival2==0) |  (survival3==0 & newfirmstarted3==1) 

replace survival3=0 if survival2==0 & survival3==1 & newfirmstarted2==1

*Only keep if business is operating
drop if survival2!=1 & wave==2
drop if survival3!=1 & wave==3

foreach x in survival newfirmstarted operatingnewfirm attrit mainactivity laborincome{
g `x'_1yr=`x'2 if wave==1
drop `x'2
g `x'_30mths=`x'3 if wave==1
drop `x'3
}	
rename laborincome1 laborincome

ds sec3_1_-sec3_17_ r3* startreason laborincome, has(type numeric)
foreach var of varlist `r(varlist)'{
replace `var'=. if wave!=1
}
ds sec3_1_-sec3_17_ r3* startreason laborincome, not(type numeric)
foreach var of varlist `r(varlist)'{
replace `var'="" if wave!=1
}

tostring survey, replace
replace survey="BL-"+string(surveyyear) if surveyyear==2013
replace survey="R-"+string(surveyyear) if surveyyear==2014 
replace survey="L-"+string(surveyyear) if surveyyear==2016

g lastround=(surveyyear==2016)

*Generate owner, household and business id (which are the same here)
foreach var in ownerid firmid householdid{
egen `var'=group(respondent_id)
tostring `var', format("%04.0f") replace
replace `var'="KENYAGETAHEAD"+"-"+`var'
}

g surveyname="KENYAGETAHEAD"

save KENYAGETAHEAD_for_opnewfirm,replace

********************************************************************************
*TTHAI (TOWNSEND THAI PROJECT DATA)
********************************************************************************
use TTHAImasterfc, clear

g operatingnewfirm_1yr=newfirmstarted_1yr
forvalues i=2/17{
g operatingnewfirm_`i'yrs=newfirmstarted_`i'yrs
}

save TTHAImasterfc_for_opnewfirm,replace

********************************************************************************
********************************************************************************
********************************************************************************
*Combine the recoded panels
********************************************************************************
********************************************************************************
********************************************************************************
append using 	KENYAGETAHEAD_for_opnewfirm ///
				BENINFORM_for_opnewfirm ///
				MALAWIFORM_for_opnewfirm ///
				SLKFEMBUSTRAINING_for_opnewfirm ///
				SLLSE_for_opnewfirm ///
				SLMS_for_opnewfirm ///
				GHANAFLYP_for_opnewfirm ///
				NGYOUWIN_masterfc
				
save CombinedMaster_for_opnewfirm, replace				

*Replace agefirm=0 if it is negative
replace agefirm=0 if agefirm<0

*Replace ownerage=. if it is out of range
replace ownerage=. if ownerage==999
*I keep the ones under 15 as for now

*Generate a variable indicating female ownership for single-owner businesses
g female_so=female if mfj!=2

*Replace childunder5 and childaged5to12 to dummy variables
foreach var of varlist childunder5 childaged5to12{
replace `var'=(`var'>0) if `var'!=.
}

*Convert all monetary values into real USD
foreach var of varlist pcexpend* laborincome* expenses* sales* profits* capitalstock* inventories* {
replace `var'=`var'*excrate
}
save CombinedMaster_for_opnewfirm, replace

import excel "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/US_CPIdata.xlsx", sheet("Tabelle1") firstrow clear

reshape long CPI, i(Year) j(month)

g excratemonth=string(month)+"-"+string(Year)
drop month Year

merge 1:m excratemonth using CombinedMaster_for_opnewfirm, keep(using match) nogenerate

g baseCPI=CPI if excratemonth=="1-2015"
su baseCPI
replace baseCPI=`r(max)' if baseCPI==.

foreach var of varlist  pcexpend* laborincome* expenses* sales* profits* capitalstock* inventories* {
replace `var'=`var'*(baseCPI/CPI)
}

save CombinedMaster_for_opnewfirm, replace

*Merge data on per capita GDP
import excel "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/GDPpcdata.xlsx", sheet("Data") firstrow clear
reshape long GDP, i(country) j(surveyyear)

merge 1:m country surveyyear using CombinedMaster_for_opnewfirm, keep(using match) nogenerate

save CombinedMaster_for_opnewfirm, replace

import excel "/Users/Lu/Dropbox/AnnaLuisaProjects/Firm Survival/Data/annualCPI.xlsx", sheet("Tabelle1") firstrow clear

merge 1:m surveyyear using CombinedMaster_for_opnewfirm, keep(using match) nogenerate
 
replace GDP=GDP*(baseCPI/annualCPI)

g baseline=(substr(survey,1,2)=="BL" | (country=="Thailand" & lastround!=1) | (country=="Nigeria" & surveyname=="" & (survey=="R-2011" | survey=="R-2012")))

replace GDP=. if baseline!=1

drop baseline

rename GDP pcGDP

*Replace laborincome to be income from all labor, including the business (except for Kenya GETAHEAD, Sri Lanka, GHANAFLYP, and Egypt, for which this is already the case)
egen laborincomereplace=rowtotal(laborincome profits) if country!="Kenya" & country!="Egypt" & country!="Sri Lanka" & country!="Ghana" & country!="Benin" & country!="Malawi" & country!="Togo" & surveyname!="NGYOUWIN", m
replace laborincome=laborincomereplace if country!="Kenya" & country!="Egypt" & country!="Sri Lanka" & country!="Ghana" & country!="Benin" & country!="Malawi" & country!="Togo" & surveyname!="NGYOUWIN"
drop laborincomereplace

*Generate agegroups for firmage
g stagegroup="under 2 years" if agefirm<2
g agegroup=1 if agefirm<2
replace stagegroup="2 to 5 years" if agefirm<5 & agefirm>=2
replace agegroup=2 if agefirm<5 & agefirm>=2
replace stagegroup="5 to 10 years" if agefirm<10 & agefirm>=5
replace agegroup=3 if agefirm<10 & agefirm>=5
replace stagegroup="10 to 15 years" if agefirm<15 & agefirm>=10
replace agegroup=4 if agefirm<15 & agefirm>=10
replace stagegroup="15 to 20 years" if agefirm>=15 & agefirm<20
replace agegroup=5 if agefirm>=15 & agefirm<20
replace stagegroup="20 to 30 years" if agefirm>=20 & agefirm<30
replace agegroup=6 if agefirm>=20 & agefirm<30
replace stagegroup="30 years and older" if agefirm>=30 & agefirm!=.
replace agegroup=7 if agefirm>=30 & agefirm!=.

label define agegroup       1     "under 2 years" ///
							2     "2 to 4 years" ///
							3     "5 to 9 years" ///
							4  	  "10 to 14 years" ///
							5     "15 to 19 years" ///
							6     "20 to 29 years" ///
							7     "30 years and older"

label values agegroup agegroup

*Generate agegroups for ownerage
g owneragegroup=1 if ownerage>=15 & ownerage<20
replace owneragegroup=2 if ownerage>=20 & ownerage<25
replace owneragegroup=3 if ownerage>=25 & ownerage<30
replace owneragegroup=4 if ownerage>=30 & ownerage<35
replace owneragegroup=5 if ownerage>=35 & ownerage<40
replace owneragegroup=6 if ownerage>=40 & ownerage<45
replace owneragegroup=7 if ownerage>=45 & ownerage<50
replace owneragegroup=8 if ownerage>=50 & ownerage<60
replace owneragegroup=9 if ownerage>=60 & ownerage!=.

*Generate groups for educyears
g educyearsgroup=1 if educyears>=0 & educyears<=13
replace educyearsgroup=2 if educyears>=14 & educyears!=.

label define educyearsgroup     1     "0 to 13 years" ///
								2     "more than 13 years"

label values educyearsgroup educyearsgroup

*Generate a variable indicating whether the firm is in manufacturing, retail, services or any other sector
g sector1234=1 if retail==1
replace sector1234=2 if manuf==1
replace sector1234=3 if services==1
replace sector1234=4 if othersector==1

label define sector 1 retail ///
					2 manufacturing ///
					3 services ///
					4 other
					
label values sector1234 sector		

*Generate profit groups to look at subsistence businesses:
*splitting by US$2 per day or less vs $2-5 vs >$5
*since profits are given for a month, I multiply the values with 3
g subsgroup=1 if profits>0 & profits<30
replace subsgroup=2 if profits>=30 & profits<60
replace subsgroup=3 if profits>=60 & profits<90
replace subsgroup=4 if profits>=90 & profits<120
replace subsgroup=5 if profits>=120 & profits<150
replace subsgroup=6 if profits>=150 & profits<180
replace subsgroup=7 if profits>=180 & profits<210
replace subsgroup=8 if profits>=210 & profits<240
replace subsgroup=9 if profits>=240 & profits<270
replace subsgroup=10 if profits>=270 & profits<300			

label define subsgroup 	1 "less than US$1 per day" ///
						2 "US$1-US$2 per day" ///
						3 "US$2-US$3 per day" ///
						4 "US$3-US$4 per day" ///
						5 "US$4-US$5 per day" ///
						6 "US$5-US$6 per day" ///
						7 "US$6-US$7 per day" ///
						8 "US$7-US$8 per day" ///
						9 "US$8-US$9 per day" ///
						10 "US$9-US$10 per day" 

label values subsgroup subsgroup	

*Generate mfj variable
replace mfj=0 if female==0 & jointbus!=1
replace mfj=1 if female==1 & jointbus!=1
replace mfj=2 if jointbus==1

label define mfj	0 "male" ///
					1 "female" ///
					2 "joint business"

label values mfj mfj
					
save CombinedMaster_for_opnewfirm, replace

*Round horizons over which we observe survival/death to the nearest integer of 0.25 for 0-2 years:
foreach x1 in  4{
foreach x2 in 	attrit survival newfirmstarted operatingnewfirm /// 
				reasonforclosure reasonclosure mainactivity wageworker dead retired laborincome /// 
				sales profits hours hoursnormal employees totalworkers /// 
				subjwell pcexpend_  /// 
				{
capture: sum `x2'_`x1'mths 
	if _rc==111 {
	g `x2'_`x1'mths=.
	}
capture: sum `x2'_3mths 
	if _rc==111 {
	g `x2'_3mths=.
	}	
replace `x2'_3mths = `x2'_`x1'mths if `x2'_3mths==.
drop `x2'_`x1'mths 
}
}
foreach x1 in  4{
foreach x2 in 	introduction_10  {
capture: sum `x2'_`x1'mths 
	if _rc==111 {
	g `x2'_`x1'mths=""
	}
capture: sum `x2'_3mths 
	if _rc==111 {
	g `x2'_3mths=""
	}	
replace `x2'_3mths = `x2'_`x1'mths if `x2'_3mths==""
drop `x2'_`x1'mths 
}
}

foreach x1 in  7{
foreach x2 in 	attrit survival newfirmstarted operatingnewfirm /// 
				reasonforclosure reasonclosure mainactivity wageworker dead retired laborincome /// 
				sales profits hours hoursnormal employees totalworkers /// 
				subjwell pcexpend_  /// 
				{
capture: sum `x2'_`x1'mths 
	if _rc==111 {
	g `x2'_`x1'mths=.
	}
capture: sum `x2'_6mths 
	if _rc==111 {
	g `x2'_6mths=.
	}	
replace `x2'_6mths = `x2'_`x1'mths if `x2'_6mths==.
drop `x2'_`x1'mths 
}
}
foreach x1 in  7{
foreach x2 in 	introduction_10  {
capture: sum `x2'_`x1'mths 
	if _rc==111 {
	g `x2'_`x1'mths=""
	}
capture: sum `x2'_6mths 
	if _rc==111 {
	g `x2'_6mths=""
	}	
replace `x2'_6mths = `x2'_`x1'mths if `x2'_6mths==""
drop `x2'_`x1'mths 
}
}

foreach x1 in  10 {
foreach x2 in 	attrit survival newfirmstarted operatingnewfirm /// 
				reasonforclosure reasonclosure mainactivity wageworker dead retired laborincome /// 
				sales profits hours hoursnormal employees totalworkers /// 
				subjwell pcexpend_  /// 
				{
capture: sum `x2'_`x1'mths 
	if _rc==111 {
	g `x2'_`x1'mths=.
	}
capture: sum `x2'_9mths 
	if _rc==111 {
	g `x2'_9mths=.
	}	
replace `x2'_9mths = `x2'_`x1'mths if `x2'_9mths==.
drop `x2'_`x1'mths 
}
}
foreach x1 in  10{
foreach x2 in 	introduction_10  {
capture: sum `x2'_`x1'mths 
	if _rc==111 {
	g `x2'_`x1'mths=""
	}
capture: sum `x2'_9mths 
	if _rc==111 {
	g `x2'_9mths=""
	}	
replace `x2'_9mths = `x2'_`x1'mths if `x2'_9mths==""
drop `x2'_`x1'mths 
}
}

foreach x1 in  11mths  1p083yrs {
foreach x2 in 	attrit survival newfirmstarted operatingnewfirm /// 
				reasonforclosure reasonclosure mainactivity wageworker dead retired laborincome /// 
				sales profits hours hoursnormal employees totalworkers /// 
				subjwell pcexpend_  /// 
				{
capture: sum `x2'_`x1'
	if _rc==111 {
	g `x2'_`x1'=.
	}
capture: sum `x2'_1yr
	if _rc==111 {
	g `x2'_1yr=.
	}	
replace `x2'_1yr = `x2'_`x1' if `x2'_1yr==.
drop `x2'_`x1'
}
}
foreach x1 in 11mths  1p083yrs{
foreach x2 in 	introduction_10  {
capture: sum `x2'_`x1' 
	if _rc==111 {
	g `x2'_`x1'=""
	}
capture: sum `x2'_1yr
	if _rc==111 {
	g `x2'_1yr=""
	}	
replace `x2'_1yr = `x2'_`x1' if `x2'_1yr==""
drop `x2'_`x1' 
}
}

foreach x1 in  1p167yrs  1p33yrs {
foreach x2 in 	attrit survival newfirmstarted operatingnewfirm /// 
				reasonforclosure reasonclosure mainactivity wageworker dead retired laborincome /// 
				sales profits hours hoursnormal employees totalworkers /// 
				subjwell pcexpend_  /// 
				{
capture: sum `x2'_`x1'
	if _rc==111 {
	g `x2'_`x1'=.
	}
capture: sum `x2'_1p25yrs
	if _rc==111 {
	g `x2'_1p25yrs=.
	}	
replace `x2'_1p25yrs = `x2'_`x1' if `x2'_1p25yrs==.
drop `x2'_`x1'
}
}
foreach x1 in 1p167yrs 1p33yrs{
foreach x2 in 	introduction_10  {
capture: sum `x2'_`x1' 
	if _rc==111 {
	g `x2'_`x1'=""
	}
capture: sum `x2'_1p25yrs
	if _rc==111 {
	g `x2'_1p25yrs=""
	}	
replace `x2'_1p25yrs = `x2'_`x1' if `x2'_1p25yrs==""
drop `x2'_`x1' 
}
}

foreach x1 in  1yr8mths  1p833yrs {
foreach x2 in 	attrit survival newfirmstarted operatingnewfirm /// 
				reasonforclosure reasonclosure mainactivity wageworker dead retired laborincome /// 
				sales profits hours hoursnormal employees totalworkers /// 
				subjwell pcexpend_  /// 
				{
capture: sum `x2'_`x1'
	if _rc==111 {
	g `x2'_`x1'=.
	}
capture: sum `x2'_1p75yrs
	if _rc==111 {
	g `x2'_1p75yrs=.
	}	
replace `x2'_1p75yrs = `x2'_`x1' if `x2'_1p75yrs==.
drop `x2'_`x1'
}
}
foreach x1 in 1yr8mths  1p833yrs{
foreach x2 in 	introduction_10  {
capture: sum `x2'_`x1' 
	if _rc==111 {
	g `x2'_`x1'=""
	}
capture: sum `x2'_1p75yrs
	if _rc==111 {
	g `x2'_1p75yrs=""
	}	
replace `x2'_1p75yrs = `x2'_`x1' if `x2'_1p75yrs==""
drop `x2'_`x1' 
}
}

foreach x1 in  2p167yrs {
foreach x2 in 	attrit survival newfirmstarted operatingnewfirm /// 
				reasonforclosure reasonclosure mainactivity wageworker dead retired laborincome /// 
				sales profits hours hoursnormal employees totalworkers /// 
				subjwell pcexpend_  /// 
				{
capture: sum `x2'_`x1'
	if _rc==111 {
	g `x2'_`x1'=.
	}
capture: sum `x2'_2yrs
	if _rc==111 {
	g `x2'_2yrs=.
	}	
replace `x2'_2yrs = `x2'_`x1' if `x2'_2yrs==.
drop `x2'_`x1'
}
}
foreach x1 in 2p167yrs{
foreach x2 in 	introduction_10  {
capture: sum `x2'_`x1' 
	if _rc==111 {
	g `x2'_`x1'=""
	}
capture: sum `x2'_2yrs
	if _rc==111 {
	g `x2'_2yrs=""
	}	
replace `x2'_2yrs = `x2'_`x1' if `x2'_2yrs==""
drop `x2'_`x1' 
}
}

*Round horizons over which we observe survival/death to the nearest integer of 0.5 for 2-6 years:
foreach x1 in  2p25yrs {
foreach x2 in 	attrit survival newfirmstarted operatingnewfirm /// 
				reasonforclosure reasonclosure mainactivity wageworker dead retired laborincome /// 
				sales profits hours hoursnormal employees totalworkers /// 
				subjwell pcexpend_  /// 
				{
capture: sum `x2'_`x1'
	if _rc==111 {
	g `x2'_`x1'=.
	}
capture: sum `x2'_30mths
	if _rc==111 {
	g `x2'_30mths=.
	}	
replace `x2'_30mths = `x2'_`x1' if `x2'_30mths==.
drop `x2'_`x1'
}
}
foreach x1 in 2p25yrs{
foreach x2 in 	introduction_10  {
capture: sum `x2'_`x1' 
	if _rc==111 {
	g `x2'_`x1'=""
	}
capture: sum `x2'_30mths
	if _rc==111 {
	g `x2'_30mths=""
	}	
replace `x2'_30mths = `x2'_`x1'  if `x2'_30mths==""
drop `x2'_`x1' 
}
}

foreach x1 in  2p833yrs 2p9167yrs {
foreach x2 in 	attrit survival newfirmstarted operatingnewfirm /// 
				reasonforclosure reasonclosure mainactivity wageworker dead retired laborincome /// 
				sales profits hours hoursnormal employees totalworkers /// 
				subjwell pcexpend_  /// 
				{
capture: sum `x2'_`x1'
	if _rc==111 {
	g `x2'_`x1'=.
	}
capture: sum `x2'_3yrs
	if _rc==111 {
	g `x2'_3yrs=.
	}	
replace `x2'_3yrs = `x2'_`x1' if `x2'_3yrs==.
drop `x2'_`x1'
}
}
foreach x1 in 2p833yrs 2p9167yrs{
foreach x2 in 	introduction_10  {
capture: sum `x2'_`x1' 
	if _rc==111 {
	g `x2'_`x1'=""
	}
capture: sum `x2'_3yrs
	if _rc==111 {
	g `x2'_3yrs=""
	}	
replace `x2'_3yrs = `x2'_`x1' if `x2'_3yrs==""
drop `x2'_`x1' 
}
}

foreach x1 in  3p667yrs {
foreach x2 in 	attrit survival newfirmstarted operatingnewfirm /// 
				reasonforclosure reasonclosure mainactivity wageworker dead retired laborincome /// 
				sales profits hours hoursnormal employees totalworkers /// 
				subjwell pcexpend_  /// 
				{
capture: sum `x2'_`x1'
	if _rc==111 {
	g `x2'_`x1'=.
	}
capture: sum `x2'_3p5yrs
	if _rc==111 {
	g `x2'_3p5yrs=.
	}	
replace `x2'_3p5yrs = `x2'_`x1' if `x2'_3p5yrs==.
drop `x2'_`x1'
}
}
foreach x1 in 3p667yrs{
foreach x2 in 	introduction_10  {
capture: sum `x2'_`x1' 
	if _rc==111 {
	g `x2'_`x1'=""
	}
capture: sum `x2'_3p5yrs
	if _rc==111 {
	g `x2'_3p5yrs=""
	}	
replace `x2'_3p5yrs = `x2'_`x1' if `x2'_3p5yrs==""
drop `x2'_`x1' 
}
}

foreach x1 in  5p17yrs {
foreach x2 in 	attrit survival newfirmstarted operatingnewfirm /// 
				reasonforclosure reasonclosure mainactivity wageworker dead retired laborincome /// 
				sales profits hours hoursnormal employees totalworkers /// 
				subjwell pcexpend_  /// 
				{
capture: sum `x2'_`x1'
	if _rc==111 {
	g `x2'_`x1'=.
	}
capture: sum `x2'_5yrs
	if _rc==111 {
	g `x2'_5yrs=.
	}	
replace `x2'_5yrs = `x2'_`x1' if `x2'_5yrs==.
drop `x2'_`x1'
}
}
foreach x1 in 5p17yrs{
foreach x2 in 	introduction_10  {
capture: sum `x2'_`x1' 
	if _rc==111 {
	g `x2'_`x1'=""
	}
capture: sum `x2'_5yrs
	if _rc==111 {
	g `x2'_5yrs=""
	}	
replace `x2'_5yrs = `x2'_`x1' if `x2'_5yrs==""
drop `x2'_`x1' 
}
}

foreach x1 in  5p67yrs {
foreach x2 in 	attrit survival newfirmstarted operatingnewfirm /// 
				reasonforclosure reasonclosure mainactivity wageworker dead retired laborincome /// 
				sales profits hours hoursnormal employees totalworkers /// 
				subjwell pcexpend_  /// 
				{
capture: sum `x2'_`x1'
	if _rc==111 {
	g `x2'_`x1'=.
	}
capture: sum `x2'_5p5yrs
	if _rc==111 {
	g `x2'_5p5yrs=.
	}	
replace `x2'_5p5yrs = `x2'_`x1' if `x2'_5p5yrs==.
drop `x2'_`x1'
}
}
foreach x1 in 5p67yrs{
foreach x2 in 	introduction_10  {
capture: sum `x2'_`x1' 
	if _rc==111 {
	g `x2'_`x1'=""
	}
capture: sum `x2'_5p5yrs
	if _rc==111 {
	g `x2'_5p5yrs=""
	}	
replace `x2'_5p5yrs = `x2'_`x1' if `x2'_5p5yrs==""
drop `x2'_`x1' 
}
}

foreach x1 in  5p75yrs {
foreach x2 in 	attrit survival newfirmstarted operatingnewfirm /// 
				reasonforclosure reasonclosure mainactivity wageworker dead retired laborincome /// 
				sales profits hours hoursnormal employees totalworkers /// 
				subjwell pcexpend_  /// 
				{
capture: sum `x2'_`x1'
	if _rc==111 {
	g `x2'_`x1'=.
	}
capture: sum `x2'_6yrs
	if _rc==111 {
	g `x2'_6yrs=.
	}	
replace `x2'_6yrs = `x2'_`x1' if `x2'_6yrs==.
drop `x2'_`x1'
}
}
foreach x1 in 5p75yrs{
foreach x2 in 	introduction_10  {
capture: sum `x2'_`x1' 
	if _rc==111 {
	g `x2'_`x1'=""
	}
capture: sum `x2'_6yrs
	if _rc==111 {
	g `x2'_6yrs=""
	}	
replace `x2'_6yrs = `x2'_`x1' if `x2'_6yrs==""
drop `x2'_`x1' 
}
}

*Round horizons over which we observe survival/death to the nearest integer of 1 for 6 years and more:
foreach x1 in  7p5yrs {
foreach x2 in 	attrit survival newfirmstarted operatingnewfirm /// 
				reasonforclosure reasonclosure mainactivity wageworker dead retired laborincome /// 
				sales profits hours hoursnormal employees totalworkers /// 
				subjwell pcexpend_  /// 
				{
capture: sum `x2'_`x1'
	if _rc==111 {
	g `x2'_`x1'=.
	}
capture: sum `x2'_8yrs
	if _rc==111 {
	g `x2'_8yrs=.
	}	
replace `x2'_8yrs = `x2'_`x1' if `x2'_8yrs==.
drop `x2'_`x1'
}
}
foreach x1 in 7p5yrs {
foreach x2 in 	introduction_10  {
capture: sum `x2'_`x1' 
	if _rc==111 {
	g `x2'_`x1'=""
	}
capture: sum `x2'_8yrs
	if _rc==111 {
	g `x2'_8yrs=""
	}	
replace `x2'_8yrs = `x2'_`x1' if `x2'_8yrs==""
drop `x2'_`x1' 
}
}

foreach x1 in  10p416yrs {
foreach x2 in 	attrit survival newfirmstarted operatingnewfirm /// 
				reasonforclosure reasonclosure mainactivity wageworker dead retired laborincome /// 
				sales profits hours hoursnormal employees totalworkers /// 
				subjwell pcexpend_  /// 
				{
capture: sum `x2'_`x1'
	if _rc==111 {
	g `x2'_`x1'=.
	}
capture: sum `x2'_10yrs
	if _rc==111 {
	g `x2'_10yrs=.
	}	
replace `x2'_10yrs = `x2'_`x1' if `x2'_10yrs==.
drop `x2'_`x1'
}
}
foreach x1 in 10p416yrs {
foreach x2 in 	introduction_10  {
capture: sum `x2'_`x1' 
	if _rc==111 {
	g `x2'_`x1'=""
	}
capture: sum `x2'_10yrs
	if _rc==111 {
	g `x2'_10yrs=""
	}	
replace `x2'_10yrs = `x2'_`x1'  if `x2'_10yrs==""
drop `x2'_`x1' 
}
}

foreach x1 in  10p916yrs {
foreach x2 in 	attrit survival newfirmstarted operatingnewfirm /// 
				reasonforclosure reasonclosure mainactivity wageworker dead retired laborincome /// 
				sales profits hours hoursnormal employees totalworkers /// 
				subjwell pcexpend_  /// 
				{
capture: sum `x2'_`x1'
	if _rc==111 {
	g `x2'_`x1'=.
	}
capture: sum `x2'_11yrs
	if _rc==111 {
	g `x2'_11yrs=.
	}	
replace `x2'_11yrs = `x2'_`x1' if `x2'_11yrs==.
drop `x2'_`x1'
}
}
foreach x1 in 10p916yrs {
foreach x2 in 	introduction_10  {
capture: sum `x2'_`x1' 
	if _rc==111 {
	g `x2'_`x1'=""
	}
capture: sum `x2'_11yrs
	if _rc==111 {
	g `x2'_11yrs=""
	}	
replace `x2'_11yrs = `x2'_`x1' if `x2'_11yrs==""
drop `x2'_`x1' 
}
}

foreach x1 in  14p5yrs {
foreach x2 in 	attrit survival newfirmstarted operatingnewfirm /// 
				reasonforclosure reasonclosure mainactivity wageworker dead retired laborincome /// 
				sales profits hours hoursnormal employees totalworkers /// 
				subjwell pcexpend_  /// 
				{
capture: sum `x2'_`x1'
	if _rc==111 {
	g `x2'_`x1'=.
	}
capture: sum `x2'_15yrs
	if _rc==111 {
	g `x2'_15yrs=.
	}	
replace `x2'_15yrs = `x2'_`x1' if `x2'_15yrs==.
drop `x2'_`x1'
}
}
foreach x1 in 14p5yrs {
foreach x2 in 	introduction_10  {
capture: sum `x2'_`x1' 
	if _rc==111 {
	g `x2'_`x1'=""
	}
capture: sum `x2'_15yrs
	if _rc==111 {
	g `x2'_15yrs=""
	}	
replace `x2'_15yrs = `x2'_`x1' if `x2'_15yrs==""
drop `x2'_`x1' 
}
}

save CombinedMaster_RH_for_opnewfirm, replace				

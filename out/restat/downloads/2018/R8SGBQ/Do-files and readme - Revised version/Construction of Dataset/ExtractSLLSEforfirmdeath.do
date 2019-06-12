********************************************************************************

********************************************************************************
**THIS DO-FILE PREPARES THE DATA FROM THE SRI LANKA LONGITUDINAL SURVEY OF ENTERPRISES FOR COMBINATION INTO THE MASTER DATASET
**Small Firm Death in Developing Countries
**November 21, 2017
**David McKenzie (dmckenzie@worldbank.org) and Anna Luisa Paffhausen (apaffhausen@worldbank.org)
**The analysis was performed with Stata, version 14.2

*Note:
* This do-file cannot be replicated as part of the underlying raw data needed to replicate this do-file is not (yet) available publicly.

********************************************************************************

********************************************************************************

cd "C:\Users\wb200090\Dropbox\Sri Lanka Annual\Data\Raw Data\Survey Data\Raw NSF Data\"

*** Round 3
use "SLLSE/SLSE NSF Round1 Raw.dta", clear

gen surveymonth2=4
gen surveyyear2=2009

gen respondent_id=SHENO

gen survival2=(q1_1==1|q1_1==3)
gen reasonforclosure2=q1_6
label define closereason 1 "business making a loss" 2 "sickness" 3 "found better wage job" 4 "take care of family" 5 "better business opportunity" 6 "other"
label values reasonforclosure2 closereason
replace survival2=1 if q1_7==1
replace survival2=1 if q1_8==1
gen newfirmstarted2=q1_13==3
gen laborincome2=0
replace laborincome2=x5*(30/7) if x5~=9 & x5~=.
gen employees2=0
replace employees2=employees2+q7_1_1 if q7_1_1~=.
replace employees2=employees2+q7_1_2 if q7_1_2~=.
gen hours2=q7_3 if q7_3<=120

gen sales2=q7_14 if q7_14~=999
replace sales2=0 if sales2==8
gen profits2=q7_18 
replace profits2=. if q7_18==999
replace profits2=0 if q7_18==0
replace laborincome2=laborincome2+profits2 if profits2~=.

gen mainactivity2=q1_13


sort respondent_id
keep respondent_id surveymonth2 surveyyear2 survival2 reasonforclosure2 newfirmstarted2 laborincome2 employees2 hours2 sales2 profits2 mainactivity2
save "C:\Users\wb200090\Box Sync\otherresearch\SriLanka\SLLSE\FirmDeathDataSLLSE.dta", replace

*** Round 4
use "SLSE NSF Round4 Raw.dta", clear

gen surveymonth3=10
gen surveyyear3=2009

gen respondent_id=sheno

gen survival3=(q1_1c==1|q1_1c==3|q1_1c==5|q1_1c==6)
gen reasonforclosure3=q1_6
label define closereason 1 "business making a loss" 2 "sickness" 3 "found better wage job" 4 "take care of family" 5 "better business opportunity" 6 "other"
label values reasonforclosure3 closereason
replace survival3=1 if q1_7==1
replace survival3=1 if q1_8==1
gen newfirmstarted3=q1_13==3|q1_13==5
gen mainactivity3=q1_13
replace mainactivity3=. if q1_13==5

gen laborincome3=0
replace laborincome3=qx_5*(30/7) if qx_5~=9 & qx_5~=.
gen employees3=0
replace employees3=employees3+q7_1_1 if q7_1_1~=.
replace employees3=employees3+q7_1_2 if q7_1_2~=.
gen hours3=q7_3 if q7_3<=130

gen sales3=q7_14 if q7_14~=999
replace sales3=0 if sales3==8
gen profits3=q7_18 
replace profits3=. if q7_18==999
replace profits3=0 if q7_18==0
replace laborincome3=laborincome3+profits3 if profits3~=.

sort respondent_id
keep respondent_id surveymonth3 surveyyear3 survival3 reasonforclosure3 newfirmstarted3 laborincome3 employees3 hours3 sales3 profits3 mainactivity3
merge respondent_id using "C:\Users\wb200090\Box Sync\otherresearch\SriLanka\SLLSE\FirmDeathDataSLLSE.dta"
tab _merge
drop _merge
sort respondent_id
save "C:\Users\wb200090\Box Sync\otherresearch\SriLanka\SLLSE\FirmDeathDataSLLSE.dta", replace

*** Round 5
use "SLSE NSF Round5 Raw.dta", clear

gen surveymonth4=4
gen surveyyear4=2010

gen respondent_id=sheno

gen survival4=(q1_1c==1|q1_1c==3|q1_1c==5|q1_1c==6)
gen reasonforclosure4=q1_6
label define closereason 1 "business making a loss" 2 "sickness" 3 "found better wage job" 4 "take care of family" 5 "better business opportunity" 6 "other"
label values reasonforclosure4 closereason
replace survival4=1 if q1_7==1
replace survival4=1 if q1_8==1
gen newfirmstarted4=q1_13==3|q1_13==5
gen mainactivity4=q1_13
replace mainactivity4=. if q1_13==5

gen laborincome4=0
replace laborincome4=qx_5*(30/7) if qx_5~=9 & qx_5~=. & qx_5~=999
gen employees4=0
replace employees4=employees4+q7_1_1 if q7_1_1~=. & q7_1_1~=999
replace employees4=employees4+q7_1_2 if q7_1_2~=. & q7_1_2~=999
gen hours4=q7_3 if q7_3<=130

gen sales4=q7_14 if q7_14~=999
replace sales4=0 if sales4==8
gen profits4=q7_18 
replace profits4=. if q7_18==999
replace profits4=0 if q7_18==0
replace laborincome4=laborincome4+profits4 if profits4~=.

sort respondent_id
keep respondent_id surveymonth4 surveyyear4 survival4 reasonforclosure4 newfirmstarted4 laborincome4 employees4 hours4 sales4 profits4 mainactivity4
merge respondent_id using "C:\Users\wb200090\Box Sync\otherresearch\SriLanka\SLLSE\FirmDeathDataSLLSE.dta"
tab _merge
drop _merge
sort respondent_id
save "C:\Users\wb200090\Box Sync\otherresearch\SriLanka\SLLSE\FirmDeathDataSLLSE.dta", replace


*** Round 6
use "SLSE NSF Round6 Raw.dta", clear

gen surveymonth5=10
gen surveyyear5=2010

gen respondent_id=sheno

gen survival5=(q1_1c==1|q1_1c==3|q1_1c==5|q1_1c==6)
gen reasonforclosure5=q1_6
label define closereason 1 "business making a loss" 2 "sickness" 3 "found better wage job" 4 "take care of family" 5 "better business opportunity" 6 "other"
label values reasonforclosure5 closereason
replace survival5=1 if q1_7==1
replace survival5=1 if q1_8==1
gen newfirmstarted5=q1_13==3|q1_13==5
gen mainactivity5=q1_13
replace mainactivity5=. if q1_13==5

gen laborincome5=0
replace laborincome5=qx_5*(30/7) if qx_5~=9 & qx_5~=. & qx_5~=999
gen employees5=0
replace employees5=employees5+q7_1a_1 if q7_1a_1~=. & q7_1a_1~=999
replace employees5=employees5+q7_1a_1 if q7_1a_2~=. & q7_1a_2~=999
gen hours5=q7_3 if q7_3<=130

gen sales5=q7_14 if q7_14~=999
replace sales5=0 if sales5==8
gen profits5=q7_18 
replace profits5=. if q7_18==999
replace profits5=0 if q7_18==0
replace laborincome5=laborincome5+profits5 if profits5~=.

sort respondent_id
keep respondent_id surveymonth5 surveyyear5 survival5 reasonforclosure5 newfirmstarted5 laborincome5 employees5 hours5 sales5 profits5 mainactivity5
merge respondent_id using "C:\Users\wb200090\Box Sync\otherresearch\SriLanka\SLLSE\FirmDeathDataSLLSE.dta"
tab _merge
drop _merge
sort respondent_id
save "C:\Users\wb200090\Box Sync\otherresearch\SriLanka\SLLSE\FirmDeathDataSLLSE.dta", replace

*** Round 7
use "SLSE NSF Round7 Raw.dta", clear

gen surveymonth6=4
gen surveyyear6=2011

gen respondent_id=sheno

gen survival6= 1 if (q1_1c==1|q1_1c==3|q1_1c==5|q1_1c==6)
replace survival6=0 if survival6==. & q1_1c~=.
replace survival6=1 if survival6==. & qf4==1|qf4==3|qf4==4
replace survival6=0 if survival6==. & qf4==2
gen reasonforclosure6=q1_6
label define closereason 1 "business making a loss" 2 "sickness" 3 "found better wage job" 4 "take care of family" 5 "better business opportunity" 6 "other"
label values reasonforclosure6 closereason
replace survival6=1 if q1_7==1
replace survival6=1 if q1_8==1
gen newfirmstarted6=q1_13==3|q1_13==5
gen mainactivity6=q1_13
replace mainactivity6=. if q1_13==5
replace mainactivity6=3 if mainactivity6==. & qf5_2==1
replace mainactivity6=1 if mainactivity6==. & qf5_3==1

gen laborincome6=0
replace laborincome6=qx5*(30/7) if qx5~=9 & qx5~=. & qx5~=999
gen employees6=0
replace employees6=employees6+q7_1e_1 if q7_1e_1~=. & q7_1e_1~=999
replace employees6=employees6+q7_1e_2 if q7_1e_2~=. & q7_1e_2~=999
gen hours6=q7_3 if q7_3<=130

gen sales6=q7_14a if q7_14a~=999
replace sales6=0 if sales6==8
gen profits6=q7_18a 
replace profits6=. if q7_18a==999
replace profits6=0 if q7_18a==0
replace laborincome6=laborincome6+profits6 if profits6~=.

sort respondent_id
keep respondent_id surveymonth6 surveyyear6 survival6 reasonforclosure6 newfirmstarted6 laborincome6 employees6 hours6 sales6 profits6 mainactivity6
merge respondent_id using "C:\Users\wb200090\Box Sync\otherresearch\SriLanka\SLLSE\FirmDeathDataSLLSE.dta"
tab _merge
drop _merge
sort respondent_id
save "C:\Users\wb200090\Box Sync\otherresearch\SriLanka\SLLSE\FirmDeathDataSLLSE.dta", replace


*** Round 8
use "SLSE NSF Round8 Raw.dta", clear

gen surveymonth7=10
gen surveyyear7=2011

gen respondent_id=sheno

gen survival7= 1 if (q1_1c==1|q1_1c==3|q1_1c==5|q1_1c==6)
replace survival7=0 if survival7==. & q1_1c~=.
replace survival7=1 if survival7==. & qf4==1|qf4==3|qf4==4
replace survival7=0 if survival7==. & qf4==2
gen reasonforclosure7=q1_6
label define closereason 1 "business making a loss" 2 "sickness" 3 "found better wage job" 4 "take care of family" 5 "better business opportunity" 6 "other"
label values reasonforclosure7 closereason
replace survival7=1 if q1_7==1
replace survival7=1 if q1_8==1
gen newfirmstarted7=q1_13==3|q1_13==5
gen mainactivity7=q1_13
replace mainactivity7=. if q1_13==5
replace mainactivity7=3 if mainactivity7==. & qf5_2==1
replace mainactivity7=1 if mainactivity7==. & qf5_3==1

gen laborincome7=0
replace laborincome7=qx5*(30/7) if qx5~=9 & qx5~=. & qx5~=999
gen employees7=0
replace employees7=employees7+q7_1e_1 if q7_1e_1~=. & q7_1e_1~=999
replace employees7=employees7+q7_1e_2 if q7_1e_2~=. & q7_1e_2~=999
gen hours7=q7_3 if q7_3<=130

gen sales7=q7_14a if q7_14a~=999
replace sales7=0 if sales7==8
gen profits7=q7_18m1
replace profits7=. if q7_18m1==999
replace profits7=0 if q7_18m1==0
replace laborincome7=laborincome7+profits7 if profits7~=.

sort respondent_id
keep respondent_id surveymonth7 surveyyear7 survival7 reasonforclosure7 newfirmstarted7 laborincome7 employees7 hours7 sales7 profits7 mainactivity7
merge respondent_id using "C:\Users\wb200090\Box Sync\otherresearch\SriLanka\SLLSE\FirmDeathDataSLLSE.dta"
tab _merge
drop _merge
sort respondent_id
save "C:\Users\wb200090\Box Sync\otherresearch\SriLanka\SLLSE\FirmDeathDataSLLSE.dta", replace


*** Round 9
use "SLSE NSF Round9 Raw.dta", clear

gen surveymonth8=4
gen surveyyear8=2012

gen respondent_id=sheno

gen survival8= 1 if (q1_1c==1|q1_1c==3|q1_1c==5|q1_1c==6)
replace survival8=0 if survival8==. & q1_1c~=.
replace survival8=1 if survival8==. & qf4==1|qf4==3|qf4==4
replace survival8=0 if survival8==. & qf4==2
gen reasonforclosure8=q1_6
label define closereason 1 "business making a loss" 2 "sickness" 3 "found better wage job" 4 "take care of family" 5 "better business opportunity" 6 "other"
label values reasonforclosure8 closereason
replace survival8=1 if q1_7==1
replace survival8=1 if q1_8==1
gen newfirmstarted8=q1_13==3|q1_13==5
gen mainactivity8=q1_13
replace mainactivity8=. if q1_13==5
replace mainactivity8=3 if mainactivity8==. & qf5_2==1
replace mainactivity8=1 if mainactivity8==. & qf5_3==1

gen laborincome8=0
replace laborincome8=qx5*(30/7) if qx5~=9 & qx5~=. & qx5~=999
gen employees8=0
replace employees8=employees8+q7_1e_1 if q7_1e_1~=. & q7_1e_1~=999
replace employees8=employees8+q7_1e_2 if q7_1e_2~=. & q7_1e_2~=999
gen hours8=q7_3 if q7_3<=130

gen sales8=q7_14a if q7_14a~=999
replace sales8=0 if sales8==8
gen profits8=q7_18_m1
replace profits8=. if q7_18_m1==999
replace profits8=0 if q7_18_m1==0
replace laborincome8=laborincome8+profits8 if profits8~=.

sort respondent_id
keep respondent_id surveymonth8 surveyyear8 survival8 reasonforclosure8 newfirmstarted8 laborincome8 employees8 hours8 sales8 profits8 mainactivity8
merge respondent_id using "C:\Users\wb200090\Box Sync\otherresearch\SriLanka\SLLSE\FirmDeathDataSLLSE.dta"
tab _merge
drop _merge
sort respondent_id
save "C:\Users\wb200090\Box Sync\otherresearch\SriLanka\SLLSE\FirmDeathDataSLLSE.dta", replace


*** Round 10
use "SLSE NSF Round10 Raw.dta", clear

gen surveymonth9=10
gen surveyyear9=2012

gen respondent_id=sheno

gen survival9= 1 if (q1_1c==1|q1_1c==3|q1_1c==5|q1_1c==6)
replace survival9=0 if survival9==. & q1_1c~=.
replace survival9=1 if survival9==. & qf4==1|qf4==3|qf4==4
replace survival9=0 if survival9==. & qf4==2
gen reasonforclosure9=q1_6
label define closereason 1 "business making a loss" 2 "sickness" 3 "found better wage job" 4 "take care of family" 5 "better business opportunity" 6 "other"
label values reasonforclosure9 closereason
replace survival9=1 if q1_7==1
replace survival9=1 if q1_8==1
gen newfirmstarted9=q1_13==3|q1_13==5
gen mainactivity9=q1_13
replace mainactivity9=. if q1_13==5
replace mainactivity9=3 if mainactivity9==. & qf5_2==1
replace mainactivity9=1 if mainactivity9==. & qf5_3==1

gen laborincome9=0
replace laborincome9=qx5*(30/7) if qx5~=9 & qx5~=. & qx5~=999
gen employees9=0
replace employees9=employees9+q7_1e_1 if q7_1e_1~=. & q7_1e_1~=999
replace employees9=employees9+q7_1e_2 if q7_1e_2~=. & q7_1e_2~=999
gen hours9=q7_3 if q7_3<=130

gen sales9=q7_14a if q7_14a~=999
replace sales9=0 if sales9==8
gen profits9=q7_18m1
replace profits9=. if q7_18m1==999
replace profits9=0 if q7_18m1==0
replace laborincome9=laborincome9+profits9 if profits9~=.

sort respondent_id
keep respondent_id surveymonth9 surveyyear9 survival9 reasonforclosure9 newfirmstarted9 laborincome9 employees9 hours9 sales9 profits9 mainactivity9
merge respondent_id using "C:\Users\wb200090\Box Sync\otherresearch\SriLanka\SLLSE\FirmDeathDataSLLSE.dta"
tab _merge
drop _merge
sort respondent_id
save "C:\Users\wb200090\Box Sync\otherresearch\SriLanka\SLLSE\FirmDeathDataSLLSE.dta", replace


*** Round 11
use "SLSE NSF Round11 Raw.dta", clear

gen surveymonth10=4
gen surveyyear10=2013

gen respondent_id=sheno

gen survival10= 1 if (q1_1c==1|q1_1c==3|q1_1c==5|q1_1c==6)
replace survival10=0 if survival10==. & q1_1c~=.
replace survival10=1 if survival10==. & qf4==1|qf4==3|qf4==4
replace survival10=0 if survival10==. & qf4==2
gen reasonforclosure10=q1_6
label define closereason 1 "business making a loss" 2 "sickness" 3 "found better wage job" 4 "take care of family" 5 "better business opportunity" 6 "other"
label values reasonforclosure10 closereason
replace survival10=1 if q1_7==1
replace survival10=1 if q1_8==1
gen newfirmstarted10=q1_13==3|q1_13==5
gen mainactivity10=q1_13
replace mainactivity10=. if q1_13==5
replace mainactivity10=3 if mainactivity10==. & qf5_2==1
replace mainactivity10=1 if mainactivity10==. & qf5_3==1

gen laborincome10=0
replace laborincome10=qx5*(30/7) if qx5~=9 & qx5~=. & qx5~=999
gen employees10=0
replace employees10=employees10+q7_1e_1 if q7_1e_1~=. & q7_1e_1~=999
replace employees10=employees10+q7_1e_2 if q7_1e_2~=. & q7_1e_2~=999
gen hours10=q7_3 if q7_3<=130

gen sales10=q7_14a if q7_14a~=999
replace sales10=0 if sales10==8
gen profits10=q7_18m1
replace profits10=. if q7_18m1==999
replace profits10=0 if q7_18m1==0
replace laborincome10=laborincome10+profits10 if profits10~=.

sort respondent_id
keep respondent_id surveymonth10 surveyyear10 survival10 reasonforclosure10 newfirmstarted10 laborincome10 employees10 hours10 sales10 profits10 mainactivity10
merge respondent_id using "C:\Users\wb200090\Box Sync\otherresearch\SriLanka\SLLSE\FirmDeathDataSLLSE.dta"
tab _merge
drop _merge
sort respondent_id
save "C:\Users\wb200090\Box Sync\otherresearch\SriLanka\SLLSE\FirmDeathDataSLLSE.dta", replace

**** Round 12
use "SLSE NSF Round12 Raw.dta", clear

gen surveymonth11=4
gen surveyyear11=2014

gen respondent_id=sheno

gen survival11= 1 if (q1_1c==1|q1_1c==3|q1_1c==5|q1_1c==6)
replace survival11=0 if survival11==. & q1_1c~=.
replace survival11=1 if survival11==. & qf4==1|qf4==3|qf4==4
replace survival11=0 if survival11==. & qf4==2
gen reasonforclosure11=q1_6
label define closereason 1 "business making a loss" 2 "sickness" 3 "found better wage job" 4 "take care of family" 5 "better business opportunity" 6 "other"
label values reasonforclosure11 closereason
replace survival11=1 if q1_7==1
replace survival11=1 if q1_8==1
gen newfirmstarted11=q1_13==3|q1_13==5
gen mainactivity11=q1_13
replace mainactivity11=. if q1_13==5
replace mainactivity11=3 if mainactivity11==. & qf5_2==1
replace mainactivity11=1 if mainactivity11==. & qf5_3==1

gen laborincome11=0
replace laborincome11=qx5*(30/7) if qx5~=9 & qx5~=. & qx5~=999
gen employees11=0
replace employees11=employees11+q7_1e_1 if q7_1e_1~=. & q7_1e_1~=999
replace employees11=employees11+q7_1e_2 if q7_1e_2~=. & q7_1e_2~=999
gen hours11=q7_3 if q7_3<=130

gen sales11=q7_14a if q7_14a~=999
replace sales11=0 if sales11==8
gen profits11=q7_18m1
replace profits11=. if q7_18m1==999
replace profits11=0 if q7_18m1==0
replace laborincome11=laborincome11+profits11 if profits11~=.

sort respondent_id
keep respondent_id surveymonth11 surveyyear11 survival11 reasonforclosure11 newfirmstarted11 laborincome11 employees11 hours11 sales11 profits11 mainactivity11
merge respondent_id using "C:\Users\wb200090\Box Sync\otherresearch\SriLanka\SLLSE\FirmDeathDataSLLSE.dta"
tab _merge
drop _merge
sort respondent_id
save "C:\Users\wb200090\Box Sync\otherresearch\SriLanka\SLLSE\FirmDeathDataSLLSE.dta", replace




*****************************************
cd "C:\Users\wb200090\Dropbox\Sri Lanka Annual\LaborDropsPaper\Data\"
use "balance1.dta", clear
sort sheno round
merge sheno round using "Sri Lanka Panel Experiment Paper", sort

* bring in take-up data
cap drop _merge
sort sheno round
merge sheno using "EMIPtakeupdata.dta"
cap drop _merge

* bring in new self-employed data
sort sheno round
merge sheno round using "NewSelfemployed.dta"

egen maxtreat=max(treatment), by(sheno)
gen voucheronly=1 if maxtreat==3
replace voucheronly=0 if maxtreat==7
label var voucheronly "Assigned to Wage Subsidy only treatment vs control"

* drop those with no treatment assignment
drop if maxtreat==.

* rename self-employed and changedbiz so use new series
rename selfemployed selfemployed_old
rename selfemployed_new selfemployed
rename changedbiz changedbiz_old
rename changedbiz_new changedbiz

cap drop control
gen control=maxtreat==7
label var control "Control variable"
rename sheno respondent_id

keep respondent_id  round control raven selfemployed changedbiz

sort respondent_id
save "C:\Users\wb200090\Box Sync\otherresearch\SriLanka\SLLSE\FirmDeathDataLaborDrop.dta", replace

gen time=round-1
drop raven round
reshape wide control selfemployed changedbiz, i(respondent_id) j(time)
gen inlabordrop=1
sort respondent_id
merge respondent_id using "C:\Users\wb200090\Box Sync\otherresearch\SriLanka\SLLSE\FirmDeathDataSLLSE.dta"
tab _merge
keep if _merge==3
drop _merge
drop selfemployed0 changedbiz0 control0
for num 2/11: gen attritX=survivalX==.

**** New firm started is cumulative since baseline
replace newfirmstarted3=newfirmstarted2 if newfirmstarted2==1
replace newfirmstarted4=newfirmstarted3 if newfirmstarted3==1
replace newfirmstarted5=newfirmstarted4 if newfirmstarted4==1
replace newfirmstarted6=newfirmstarted5 if newfirmstarted5==1
replace newfirmstarted7=newfirmstarted6 if newfirmstarted6==1
replace newfirmstarted8=newfirmstarted7 if newfirmstarted7==1
replace newfirmstarted9=newfirmstarted8 if newfirmstarted8==1
replace newfirmstarted10=newfirmstarted9 if newfirmstarted9==1
replace newfirmstarted11=newfirmstarted10 if newfirmstarted10==1

drop selfemployed*
drop changedbiz*
drop control2-control11
rename control1 control
drop inlabordrop
sort respondent_id

save "C:\Users\wb200090\Box Sync\otherresearch\SriLanka\SLLSE\FirmDeathDataSLLSE.dta", replace







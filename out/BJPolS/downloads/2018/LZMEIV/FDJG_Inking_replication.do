
* File to replicate results from Ferree et al. "Election Ink and Turnout in a Partial Democracy"
* Feb 2018



clear all 
set more off
cd "~/Desktop/FDJG_BJPS_replication"

use FDJG_Inking_replication, replace

* TABLE 1 STATS
tab treat_groupnum


*TABLE 2: Finger status by treatment group
tab finger_voted treat_group 
tab finger_unmarked treat_group 
tab finger_unclear treat_group 
tab finger_refused treat_group 


* TABLE 3
*average treatment effects, ML, full sample;
* multinomial logit on the original marked finger variable, ambiguous and refused to show grouped;

estsimp mlogit q29_post_simple treatment2 treatment3  parish_1 parish_8 parish_6 parish_2 parish_3 parish_4 parish_5 parish_7 parish_9 if  treatment4 == 0, baseoutcome(3)
setx mean
setx treatment3 0
simqi, fd(pr) changex(treatment2 0 1)

setx treatment2 0
simqi, fd(pr) changex(treatment3 0 1)

drop b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13 b14 b15 b16 b17 b18 b19 b20 b21 b22 b23 b24

* TABLE 4: heterogeneous effects for Ink prime and age
* analysis of subgroups, heterogeneous treatment effects;

estsimp mlogit q29_post_simple treatment2 treatment3  age age_t3 education education_t3  woman woman_t3 pentacostal pentacostal_t3 muganda muganda_t3 parish_1 parish_8 parish_6 parish_2 parish_3 parish_4 parish_5 parish_7 parish_9 if  treatment4 == 0, baseoutcome(3)

setx mean
setx education 1
setx treatment2 0 
simqi, fd(pr) changex(treatment3 0 1 education_t3 0 1)

setx education 8
simqi, fd(pr) changex(treatment3 0 1 education_t3 0 8)

setx mean
setx treatment2 0
setx age 1
simqi, fd(pr) changex(treatment3 0 1 age_t3 0 1)

setx age 8
simqi, fd(pr) changex(treatment3 0 1 age_t3 0 8)

setx mean
setx treatment2 0
setx woman 0
simqi, fd(pr) changex(treatment3 0 1 woman_t3 0 0)

setx woman 1
simqi, fd(pr) changex(treatment3 0 1 woman_t3 0 1)


drop b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13 b14 b15 b16 b17 b18 b19 b20 b21 b22 b23 b24 b25 b26 b27 b28 b29 b30 b31 b32 b33 b34 b35 b36 b37 b38 b39 b40 b41 b42 b43 b44





**** Table A1: BALANCE


cap program drop BalanceTests
program define BalanceTests
quietly {
	forvalues treat_groupnum = 1/3{
	gen g`treat_groupnum' = 0
	replace g`treat_groupnum' = 1 if treat_group==`treat_groupnum'
	}
	matrix BALANCE = J(19,4,990)

	matrix rownames BALANCE = age education woman married children mobilephone campaign_museveni regvoters interview_in_english  party_display housing_informal housing_smallblock housing_fenced housing_standalone housing_smallblock housing_apartment votepres_cand_5 margin2006 turnout 	
	scalar row = 1
	matrix colnames BALANCE = 1=2=3 1=2 2=3 1=3 
	foreach var in age education woman married children mobilephone campaign_museveni regvoters interview_in_english  party_display housing_informal housing_smallblock housing_fenced housing_standalone housing_smallblock housing_apartment votepres_cand_5 margin2006 turnout {
		scalar column = 1
		reg `var' g1 g2 g3 parish_1 parish_2 parish_3 parish_4 parish_5 parish_6 parish_7 parish_8 parish_9 parish_10 if treatment4==0
		
		test g1 = g2 = g3 
		matrix BALANCE[row,column] = r(p)
		scalar column = column+1
	
		test g1 = g2
		matrix BALANCE[row,column] = r(p)
		scalar column = column+1
	
		test g2 = g3
		matrix BALANCE[row,column] = r(p)
		scalar column = column+1
	
		test g1 = g3 
		matrix BALANCE[row,column] = r(p)
		scalar column = column+1
		scalar row = row + 1

	}
	}
	end

drop g1-g3
BalanceTests
outtable using BALANCE, mat(BALANCE) nobox caption("Balance Verification: p-values from equality tests") format(%6.4f) replace


* Table A-2 summary statistics


sum finger_unmarked finger_voted finger_unclear finger_refused treatment2 treatment3 parish_1 parish_2 parish_3 parish_4 parish_5 parish_6 parish_7 parish_8 parish_9
sum age education woman gifts_important nrm_display pentacostal mutoro muganda interview_in_english   married children mobilephone housing_informal housing_smallblock housing_fenced housing_standalone housing_smallblock housing_apartment party_display campaign_museveni catholic CUG muslim


* A4 did treatment 3 change information/beliefs of participants?;

regress neighbors_know treatment2 treatment3 parish_1 parish_2 parish_3 parish_4 parish_5 parish_6 parish_7 parish_8 parish_9 if treatment4 == 0, robust
regress neighbors_know treatment2 treatment3 parish_2 parish_3 parish_4 parish_5  parish_7  parish_9 if treatment4 == 0 & parish_1 == 0 & parish_6 == 0 & parish_8 == 0, robust


*TABLE A-5
mlogit q29_post_simple treatment2 treatment3  parish_1 parish_8 parish_6 parish_2 parish_3 parish_4 parish_5 parish_7 parish_9 if  treatment4 == 0, baseoutcome(3)
mlogit q29_post_simple treatment2 treatment3  age age_t3 education education_t3  woman woman_t3 pentacostal pentacostal_t3 muganda muganda_t3 parish_1 parish_8 parish_6 parish_2 parish_3 parish_4 parish_5 parish_7 parish_9 if  treatment4 == 0, baseoutcome(3)




*Table A-6
* who is a museveni voter?;
regress museveni_voter muganda mutoro munyankole age education woman catholic CUG pentacostal muslim parish_1 parish_2 parish_3 parish_4 parish_5 parish_6 parish_7 parish_8 parish_9 if treatment4 == 0, robust

* attrition

logit attrition treatment2 treatment3 if parish_1 == 0 & parish_8 == 0 & parish_6 == 0 
logit attrition treatment2 treatment3 parish_2 parish_3 parish_4 parish_5  parish_9 if parish_1 == 0 & parish_8 == 0 & parish_6 == 0 


* predictors of concealers
regress conceal  NRM_partisan woman age muganda length_residence mutoro munyankole  education church_attendence married children housing_fenced housing_standalone housing_smallblock housing_apartment housing_informal
estimates store Concealers

coefplot Concealers, drop(_cons) xline(0)
graph save concealers.gph, replace



*TABLE A-8
* heterogeneous ink prime treatment effects for NRM display

estsimp mlogit q29_post_simple treatment2 treatment3  nrm_display nrm_display_t3 parish_1 parish_8 parish_6 parish_2 parish_3 parish_4 parish_5 parish_7 parish_9 if  treatment4 == 0, baseoutcome(3)

setx mean
setx treatment2 0
setx nrm_display 0
simqi, fd(pr) changex(treatment3 0 1 nrm_display_t3 0 0)

setx nrm_display 1
simqi, fd(pr) changex(treatment3 0 1 nrm_display_t3 0 1)
drop b1-b28


* TABLE A-3 expected turnout

use emu_turnout_check, clear

reg ownviolence opposition catholic muslim education electrif employ income newspaper 
reg ownviolence opposition catholic muslim education electrif employ income newspaper i.region

reg turnout opposition catholic muslim education electrif employ income newspaper 
reg turnout opposition catholic muslim education electrif employ income newspaper i.region

* Figure A-2

use "Uganda district turnout 2011", replace

hist turnout


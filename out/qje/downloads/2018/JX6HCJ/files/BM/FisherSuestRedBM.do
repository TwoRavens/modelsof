
****************************************************************************
*Have to drop twostep option on Heckman to do suest

use DatBM, clear

*Table 2
global i = 1
reg ref OPtreat1 OPtreat2 OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtestz<6
	estimates store M$i
	global i = $i + 1

reg ref OPtreat1 FTreat4 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtestz<6
	estimates store M$i
	global i = $i + 1

reg ref OPtestzOPtreat1 OPtestzOPtreat2 OPtestzOPtreat4 OPtestzOPtreat5 OPtreat1 OPtreat2 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtestz<6
	estimates store M$i
	global i = $i + 1

suest M1 M2 M3, robust
test OPtreat1 OPtreat2 OPtreat4 OPtreat5 FTreat4 OPtestzOPtreat1 OPtestzOPtreat2 OPtestzOPtreat4 OPtestzOPtreat5 
matrix F = (r(p), r(drop), r(df), r(chi2), 2)

*Table 3
global i = 1
probit ref OPtreat1 OPtreat2 OPpuzzletypeA sumrefrain anyrain OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4 
	estimates store M$i
	global i = $i + 1

probit ref OPtestzOPtreat1 OPtestzOPtreat2 OPtreat1 OPtreat2 OPpuzzletypeA sumrefrain anyrain OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4 
	estimates store M$i
	global i = $i + 1

heckman OP_coworkers_REFrep OPtreat1 OPtreat2 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4, select (sumrefrain anyrain OPtreat1 OPtreat2 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) difficult iterate(50)
	estimates store M$i
	global i = $i + 1

heckman OP_coworkers_REFrep OPtestzOPtreat1 OPtestzOPtreat2 OPtreat1 OPtreat2 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4, select (sumrefrain anyrain OPtestzOPtreat1 OPtestzOPtreat2 OPtreat1 OPtreat2 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) difficult iterate(50)
	estimates store M$i
	global i = $i + 1

heckman OP_relative_REFrep OPtreat1 OPtreat2 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4, select (sumrefrain anyrain OPtreat1 OPtreat2 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) difficult iterate(50)
	estimates store M$i
	global i = $i + 1

heckman OP_relative_REFrep OPtestzOPtreat1 OPtestzOPtreat2 OPtreat1 OPtreat2 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4, select (sumrefrain anyrain OPtestzOPtreat1 OPtestzOPtreat2 OPtreat1 OPtreat2 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) difficult iterate(50)
	estimates store M$i
	global i = $i + 1

heckman reftestz OPtestzOPtreat1 OPtestzOPtreat2 OPtreat1 OPtreat2 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4, select (sumrefrain anyrain OPtestzOPtreat1 OPtestzOPtreat2 OPtreat1 OPtreat2 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) difficult iterate(50)
	estimates store M$i
	global i = $i + 1

global list = ""
global list = "$list" + "[M1_ref]OPtreat1 [M1_ref]OPtreat2 "
global list = "$list" + "[M2_ref]OPtreat1 [M2_ref]OPtreat2 [M2_ref]OPtestzOPtreat1 [M2_ref]OPtestzOPtreat2 "
global list = "$list" + "[M3_OP_coworkers_REFrep]OPtreat1 [M3_OP_coworkers_REFrep]OPtreat2 [M3_select]OPtreat1 [M3_select]OPtreat2 "
global list = "$list" + "[M4_OP_coworkers_REFrep]OPtreat1 [M4_OP_coworkers_REFrep]OPtreat2 [M4_OP_coworkers_REFrep]OPtestzOPtreat1 [M4_OP_coworkers_REFrep]OPtestzOPtreat2 [M4_select]OPtreat1 [M4_select]OPtreat2 [M4_select]OPtestzOPtreat1 [M4_select]OPtestzOPtreat2 "
global list = "$list" + "[M5_OP_relative_REFrep]OPtreat1 [M5_OP_relative_REFrep]OPtreat2 [M5_select]OPtreat1 [M5_select]OPtreat2 "
global list = "$list" + "[M6_OP_relative_REFrep]OPtreat1 [M6_OP_relative_REFrep]OPtreat2 [M6_OP_relative_REFrep]OPtestzOPtreat1 [M6_OP_relative_REFrep]OPtestzOPtreat2 [M6_select]OPtreat1 [M6_select]OPtreat2 [M6_select]OPtestzOPtreat1 [M6_select]OPtestzOPtreat2 "
global list = "$list" + "[M7_reftestz]OPtreat1 [M7_reftestz]OPtreat2 [M7_reftestz]OPtestzOPtreat1 [M7_reftestz]OPtestzOPtreat2 [M7_select]OPtreat1 [M7_select]OPtreat2 [M7_select]OPtestzOPtreat1 [M7_select]OPtestzOPtreat2"

foreach X in "[M6_OP_relative_REFrep]OPtreat1" "[M6_OP_relative_REFrep]OPtreat2" "[M6_OP_relative_REFrep]OPtestzOPtreat1" "[M5_OP_relative_REFrep]OPtreat2" {
	global list = subinstr("$list","`X'","",1)
	}

suest M1 M2 M3 M4 M5 M6 M7, robust
test $list
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 3)


*Table 4
global i = 1
probit ref OPtreat4 OPtreat5 OPpuzzletypeA sumrefrain anyrain OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7 
	estimates store M$i
	global i = $i + 1

probit ref OPtestzOPtreat4 OPtestzOPtreat5 OPtreat4 OPtreat5 OPpuzzletypeA sumrefrain anyrain OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7 
	estimates store M$i
	global i = $i + 1

heckman OP_coworkers_REFrep OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) difficult iterate(50)
	estimates store M$i
	global i = $i + 1

heckman OP_coworkers_REFrep OPtestzOPtreat4 OPtestzOPtreat5 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtestzOPtreat4 OPtestzOPtreat5 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) difficult iterate(50)
	estimates store M$i
	global i = $i + 1

heckman OP_relative_REFrep OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) difficult iterate(50)
	estimates store M$i
	global i = $i + 1

heckman OP_relative_REFrep OPtestzOPtreat4 OPtestzOPtreat5 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtestzOPtreat4 OPtestzOPtreat5 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) difficult iterate(50)
	estimates store M$i
	global i = $i + 1

suest M1 M2 M3 M4 M5 M6, robust
test OPtreat4 OPtreat5 OPtestzOPtreat4 OPtestzOPtreat5
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 4)

*Table 5
global i = 1
heckman reftestz OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) difficult iterate(50)
	estimates store M$i
	global i = $i + 1

heckman reftestz OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) difficult iterate(50)
	estimates store M$i
	global i = $i + 1

heckman reftestz OPtestzOPtreat4 OPtestzOPtreat5 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtestzOPtreat4 OPtestzOPtreat5 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) difficult iterate(50)
	estimates store M$i
	global i = $i + 1

reg reftestz_e OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7
	estimates store M$i
	global i = $i + 1

reg reftestz_e OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7
	estimates store M$i
	global i = $i + 1

reg reftestz_e OPtestzOPtreat4 OPtestzOPtreat5 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7
	estimates store M$i
	global i = $i + 1

suest M1 M2 M3 M4 M5 M6, robust
test OPtreat4 OPtreat5 OPtestzOPtreat4 OPtestzOPtreat5
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 5)

generate Order = _n
generate double U = .
mata Y = st_data(.,("OPtreat","OPtreat1","OPtreat2","OPtreat3","OPtreat4","OPtreat5","OPtreat6","OPtreat7","OPpuzzletypeA"))

mata ResF = J($reps,20,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform()
	sort U 
	mata st_store(.,("OPtreat","OPtreat1","OPtreat2","OPtreat3","OPtreat4","OPtreat5","OPtreat6","OPtreat7","OPpuzzletypeA"),Y)
	forvalues i = 1/5 {
		quietly replace OPtestzOPtreat`i' = OPtestz*OPtreat`i'
		}
	quietly replace FTreat4 = (OPtreat == 4 & (numcorrect == 3 | numcorrect == 4))

estimates clear
*Table 2
global i = 1
capture reg ref OPtreat1 OPtreat2 OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtestz<6
	if (_rc == 0) estimates store M$i
	global i = $i + 1

capture reg ref OPtreat1 FTreat4 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtestz<6
	if (_rc == 0) estimates store M$i
	global i = $i + 1

capture reg ref OPtestzOPtreat1 OPtestzOPtreat2 OPtestzOPtreat4 OPtestzOPtreat5 OPtreat1 OPtreat2 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtestz<6
	if (_rc == 0) estimates store M$i
	global i = $i + 1

capture suest M1 M2 M3, robust
if (_rc == 0) {
	capture test OPtreat1 OPtreat2 OPtreat4 OPtreat5 FTreat4 OPtestzOPtreat1 OPtestzOPtreat2 OPtestzOPtreat4 OPtestzOPtreat5 
	if (_rc == 0) {
		mata ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 2)
		}
	}

estimates clear
*Table 3
global i = 1
capture probit ref OPtreat1 OPtreat2 OPpuzzletypeA sumrefrain anyrain OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4 
	if (_rc == 0) estimates store M$i
	global i = $i + 1

capture probit ref OPtestzOPtreat1 OPtestzOPtreat2 OPtreat1 OPtreat2 OPpuzzletypeA sumrefrain anyrain OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4 
	if (_rc == 0) estimates store M$i
	global i = $i + 1

capture heckman OP_coworkers_REFrep OPtreat1 OPtreat2 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4, select (sumrefrain anyrain OPtreat1 OPtreat2 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) difficult iterate(50)
	if (_rc == 0) estimates store M$i
	global i = $i + 1

capture heckman OP_coworkers_REFrep OPtestzOPtreat1 OPtestzOPtreat2 OPtreat1 OPtreat2 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4, select (sumrefrain anyrain OPtestzOPtreat1 OPtestzOPtreat2 OPtreat1 OPtreat2 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) difficult iterate(50)
	if (_rc == 0) estimates store M$i
	global i = $i + 1

capture heckman OP_relative_REFrep OPtreat1 OPtreat2 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4, select (sumrefrain anyrain OPtreat1 OPtreat2 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) difficult iterate(50)
	if (_rc == 0) estimates store M$i
	global i = $i + 1

capture heckman OP_relative_REFrep OPtestzOPtreat1 OPtestzOPtreat2 OPtreat1 OPtreat2 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4, select (sumrefrain anyrain OPtestzOPtreat1 OPtestzOPtreat2 OPtreat1 OPtreat2 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) difficult iterate(50)
	if (_rc == 0) estimates store M$i
	global i = $i + 1

capture heckman reftestz OPtestzOPtreat1 OPtestzOPtreat2 OPtreat1 OPtreat2 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4, select (sumrefrain anyrain OPtestzOPtreat1 OPtestzOPtreat2 OPtreat1 OPtreat2 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) difficult iterate(50)
	if (_rc == 0) estimates store M$i
	global i = $i + 1

capture suest M1 M2 M3 M4 M5 M6 M7, robust
if (_rc == 0) {
	capture test $list
	if (_rc == 0) {
		mata ResF[`c',6..10] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 3)
		}
	}


estimates clear
*Table 4
global i = 1
capture probit ref OPtreat4 OPtreat5 OPpuzzletypeA sumrefrain anyrain OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7 
	if (_rc == 0) estimates store M$i
	global i = $i + 1

capture probit ref OPtestzOPtreat4 OPtestzOPtreat5 OPtreat4 OPtreat5 OPpuzzletypeA sumrefrain anyrain OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7 
	if (_rc == 0) estimates store M$i
	global i = $i + 1

capture heckman OP_coworkers_REFrep OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) difficult iterate(50)
	if (_rc == 0) estimates store M$i
	global i = $i + 1

capture heckman OP_coworkers_REFrep OPtestzOPtreat4 OPtestzOPtreat5 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtestzOPtreat4 OPtestzOPtreat5 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) difficult iterate(50)
	if (_rc == 0) estimates store M$i
	global i = $i + 1

capture heckman OP_relative_REFrep OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) difficult iterate(50)
	if (_rc == 0) estimates store M$i
	global i = $i + 1

capture heckman OP_relative_REFrep OPtestzOPtreat4 OPtestzOPtreat5 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtestzOPtreat4 OPtestzOPtreat5 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) difficult iterate(50)
	if (_rc == 0) estimates store M$i
	global i = $i + 1

capture suest M1 M2 M3 M4 M5 M6, robust
if (_rc == 0) {
	capture test OPtreat4 OPtreat5 OPtestzOPtreat4 OPtestzOPtreat5
	if (_rc == 0) {
		mata ResF[`c',11..15] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 4)
		}
	}

estimates clear
*Table 5
global i = 1
capture heckman reftestz OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) difficult iterate(50)
	if (_rc == 0) estimates store M$i
	global i = $i + 1

capture heckman reftestz OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) difficult iterate(50)
	if (_rc == 0) estimates store M$i
	global i = $i + 1

capture heckman reftestz OPtestzOPtreat4 OPtestzOPtreat5 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtestzOPtreat4 OPtestzOPtreat5 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend) difficult iterate(50)
	if (_rc == 0) estimates store M$i
	global i = $i + 1

capture reg reftestz_e OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7
	if (_rc == 0) estimates store M$i
	global i = $i + 1

capture reg reftestz_e OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7
	if (_rc == 0) estimates store M$i
	global i = $i + 1

capture reg reftestz_e OPtestzOPtreat4 OPtestzOPtreat5 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7
	if (_rc == 0) estimates store M$i
	global i = $i + 1

capture suest M1 M2 M3 M4 M5 M6, robust
if (_rc == 0) {
	capture test OPtreat4 OPtreat5 OPtestzOPtreat4 OPtestzOPtreat5
	if (_rc == 0) {
		mata ResF[`c',16..20] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 5)
		}
	}

}


drop _all
set obs $reps
forvalues i = 1/20 {
	quietly generate double ResF`i' = .
	}
mata st_store(.,.,ResF)
svmat double F
gen N = _n
sort N
save results\FisherSuestredBM, replace






capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) select(string)]
	if ($i == 0) {
		global M = ""
		global test = ""
		estimates clear
		capture drop xxx*
		matrix B = J(1,300,.)
		global j = 0
		}
	global i = $i + 1

	gettoken testvars anything: anything, match(match)
	gettoken cmd anything: anything
	gettoken dep anything: anything
	foreach var in `testvars' {
		local anything = subinstr("`anything'","`var'","",1)
		if ("`select'" ~= "") local select = subinstr("`select'","`var'","xxx`var'$i",1)
		}
	local newtestvars = ""
	foreach var in `testvars' {
		quietly gen double xxx`var'$i = `var'
		local newtestvars = "`newtestvars'" + " " + "xxx`var'$i"
		}
	if ("`select'" == "") capture `cmd' `dep' `newtestvars' `anything' [`weight' `exp'] `if' `in', 
	if ("`select'" ~= "") capture `cmd' `dep' `newtestvars' `anything' [`weight' `exp'] `if' `in', select(`select') difficult iterate(50)
	if (_rc == 0) {
		estimates store M$i
		if ("`cmd'" ~= "heckman") {
			foreach var in `newtestvars' {
				global j = $j + 1
				matrix B[1,$j] = _b[`var']
				}
			}
		else {
			foreach var in `newtestvars' {
				global j = $j + 1
				matrix B[1,$j] = _b[`var']
				global j = $j + 1
				matrix B[1,$j] = _b[select:`var']
				}
			}
		}
	global M = "$M" + " " + "M$i"
	if ("`select'" == "") global test = "$test" + " " + "`newtestvars'"
	if ("`select'" ~= "" ) {
		foreach var in `newtestvars' {
			global test = "$test" + " " + "[M" + "$i" + "_`dep']`var'" + " " + "[M" + "$i" + "_select]`var'"
			}
		}

end

****************************************
****************************************

use DatBM, clear
renpfix OPtestzOPtreat OPtestztreat

*Table 2
global i = 0
mycmd (OPtreat1 OPtreat2 OPtreat4 OPtreat5 OPpuzzletypeA) reg ref OPtreat1 OPtreat2 OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtestz<6
mycmd (OPtreat1 FTreat4 OPpuzzletypeA) reg ref OPtreat1 FTreat4 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtestz<6
mycmd (OPtestztreat1 OPtestztreat2 OPtestztreat4 OPtestztreat5 OPtreat1 OPtreat2 OPtreat4 OPtreat5 OPpuzzletypeA) reg ref OPtestztreat1 OPtestztreat2 OPtestztreat4 OPtestztreat5 OPtreat1 OPtreat2 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtestz<6

suest $M, robust
test $test
matrix F = (r(p), r(drop), r(df), r(chi2), 2)
matrix B2 = B[1,1..$j]

*Table 3
global i = 0
mycmd (OPtreat1 OPtreat2 OPpuzzletypeA) probit ref OPtreat1 OPtreat2 OPpuzzletypeA sumrefrain anyrain OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4 
mycmd (OPtestztreat1 OPtestztreat2 OPtreat1 OPtreat2 OPpuzzletypeA) probit ref OPtestztreat1 OPtestztreat2 OPtreat1 OPtreat2 OPpuzzletypeA sumrefrain anyrain OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4 
mycmd (OPtreat1 OPtreat2 OPpuzzletypeA) heckman OP_coworkers_REFrep OPtreat1 OPtreat2 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4, select (sumrefrain anyrain OPtreat1 OPtreat2 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend)
mycmd (OPtestztreat1 OPtestztreat2 OPtreat1 OPtreat2 OPpuzzletypeA) heckman OP_coworkers_REFrep OPtestztreat1 OPtestztreat2 OPtreat1 OPtreat2 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4, select (sumrefrain anyrain OPtestztreat1 OPtestztreat2 OPtreat1 OPtreat2 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend)
mycmd (OPtreat1 OPtreat2 OPpuzzletypeA) heckman OP_relative_REFrep OPtreat1 OPtreat2 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4, select (sumrefrain anyrain OPtreat1 OPtreat2 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend)
mycmd (OPtestztreat1 OPtestztreat2 OPtreat1 OPtreat2 OPpuzzletypeA) heckman OP_relative_REFrep OPtestztreat1 OPtestztreat2 OPtreat1 OPtreat2 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4, select (sumrefrain anyrain OPtestztreat1 OPtestztreat2 OPtreat1 OPtreat2 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend)
mycmd (OPtestztreat1 OPtestztreat2 OPtreat1 OPtreat2 OPpuzzletypeA) heckman reftestz OPtestztreat1 OPtestztreat2 OPtreat1 OPtreat2 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4, select (sumrefrain anyrain OPtestztreat1 OPtestztreat2 OPtreat1 OPtreat2 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend)

local anything = "$test"
global test = ""
matrix B3 = J(1,$j-6,.)
local k = 1
forvalues i = 1/$j {
	gettoken a anything: anything
	if ("`a'" ~= "[M5_OP_relative_REFrep]xxxOPtreat15" & "`a'" ~= "[M5_OP_relative_REFrep]xxxOPtreat25" & "`a'" ~= "[M6_OP_relative_REFrep]xxxOPtreat16" & "`a'" ~= "[M6_OP_relative_REFrep]xxxOPtreat26" & "`a'" ~= "[M6_OP_relative_REFrep]xxxOPpuzzletypeA6" & "`a'" ~= "[M6_OP_relative_REFrep]xxxOPtestztreat16") { 
		global test = "$test" + " " + "`a'"
		matrix B3[1,`k'] = B[1,`i']
		local k = `k' + 1
		}
	}
global j = $j - 6

suest $M, robust
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 3)

*Table 4
global i = 0
mycmd (OPtreat4 OPtreat5 OPpuzzletypeA) probit ref OPtreat4 OPtreat5 OPpuzzletypeA sumrefrain anyrain OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7 
mycmd (OPtestztreat4 OPtestztreat5 OPtreat4 OPtreat5 OPpuzzletypeA) probit ref OPtestztreat4 OPtestztreat5 OPtreat4 OPtreat5 OPpuzzletypeA sumrefrain anyrain OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7 
mycmd (OPtreat4 OPtreat5 OPpuzzletypeA) heckman OP_coworkers_REFrep OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend)
mycmd (OPtestztreat4 OPtestztreat5 OPtreat4 OPtreat5 OPpuzzletypeA) heckman OP_coworkers_REFrep OPtestztreat4 OPtestztreat5 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtestztreat4 OPtestztreat5 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend)
mycmd (OPtreat4 OPtreat5 OPpuzzletypeA) heckman OP_relative_REFrep OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend)
mycmd (OPtestztreat4 OPtestztreat5 OPtreat4 OPtreat5 OPpuzzletypeA) heckman OP_relative_REFrep OPtestztreat4 OPtestztreat5 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtestztreat4 OPtestztreat5 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend)

suest $M, robust
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 4)
matrix B4 = B[1,1..$j]

*Table 5
global i = 0
mycmd (OPtreat4 OPtreat5 OPpuzzletypeA) heckman reftestz OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend)
mycmd (OPtreat4 OPtreat5 OPpuzzletypeA) heckman reftestz OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend)
mycmd (OPtestztreat4 OPtestztreat5 OPtreat4 OPtreat5 OPpuzzletypeA) heckman reftestz OPtestztreat4 OPtestztreat5 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtestztreat4 OPtestztreat5 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend)
mycmd (OPtreat4 OPtreat5 OPpuzzletypeA) reg reftestz_e OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7
mycmd (OPtreat4 OPtreat5 OPpuzzletypeA) reg reftestz_e OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7
mycmd (OPtestztreat4 OPtestztreat5 OPtreat4 OPtreat5 OPpuzzletypeA) reg reftestz_e OPtestztreat4 OPtestztreat5 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7

suest $M, robust
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 5)
matrix B5 = B[1,1..$j]

gen N = _n
sort N
save aa, replace

egen NN = max(N)
keep NN
generate obs = _n
save aaa, replace

mata ResF = J($reps,20,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using aa

*Table 2
global i = 0
mycmd (OPtreat1 OPtreat2 OPtreat4 OPtreat5 OPpuzzletypeA) reg ref OPtreat1 OPtreat2 OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtestz<6
mycmd (OPtreat1 FTreat4 OPpuzzletypeA) reg ref OPtreat1 FTreat4 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtestz<6
mycmd (OPtestztreat1 OPtestztreat2 OPtestztreat4 OPtestztreat5 OPtreat1 OPtreat2 OPtreat4 OPtreat5 OPpuzzletypeA) reg ref OPtestztreat1 OPtestztreat2 OPtestztreat4 OPtestztreat5 OPtreat1 OPtreat2 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtestz<6

capture suest $M, robust
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B2)*invsym(V)*(B[1,1..$j]-B2)'
		mata test = st_matrix("test"); ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', test[1,1], 2)
		}
	}

*Table 3
global i = 0
mycmd (OPtreat1 OPtreat2 OPpuzzletypeA) probit ref OPtreat1 OPtreat2 OPpuzzletypeA sumrefrain anyrain OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4 
mycmd (OPtestztreat1 OPtestztreat2 OPtreat1 OPtreat2 OPpuzzletypeA) probit ref OPtestztreat1 OPtestztreat2 OPtreat1 OPtreat2 OPpuzzletypeA sumrefrain anyrain OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4 
mycmd (OPtreat1 OPtreat2 OPpuzzletypeA) heckman OP_coworkers_REFrep OPtreat1 OPtreat2 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4, select (sumrefrain anyrain OPtreat1 OPtreat2 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend)
mycmd (OPtestztreat1 OPtestztreat2 OPtreat1 OPtreat2 OPpuzzletypeA) heckman OP_coworkers_REFrep OPtestztreat1 OPtestztreat2 OPtreat1 OPtreat2 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4, select (sumrefrain anyrain OPtestztreat1 OPtestztreat2 OPtreat1 OPtreat2 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend)
mycmd (OPtreat1 OPtreat2 OPpuzzletypeA) heckman OP_relative_REFrep OPtreat1 OPtreat2 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4, select (sumrefrain anyrain OPtreat1 OPtreat2 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend)
mycmd (OPtestztreat1 OPtestztreat2 OPtreat1 OPtreat2 OPpuzzletypeA) heckman OP_relative_REFrep OPtestztreat1 OPtestztreat2 OPtreat1 OPtreat2 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4, select (sumrefrain anyrain OPtestztreat1 OPtestztreat2 OPtreat1 OPtreat2 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend)
mycmd (OPtestztreat1 OPtestztreat2 OPtreat1 OPtreat2 OPpuzzletypeA) heckman reftestz OPtestztreat1 OPtestztreat2 OPtreat1 OPtreat2 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat<4, select (sumrefrain anyrain OPtestztreat1 OPtestztreat2 OPtreat1 OPtreat2 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend)

local anything = "$test"
global test = ""
matrix BB = J(1,$j-6,.)
local k = 1
forvalues i = 1/$j {
	gettoken a anything: anything
	if ("`a'" ~= "[M5_OP_relative_REFrep]xxxOPtreat15" & "`a'" ~= "[M5_OP_relative_REFrep]xxxOPtreat25" & "`a'" ~= "[M6_OP_relative_REFrep]xxxOPtreat16" & "`a'" ~= "[M6_OP_relative_REFrep]xxxOPtreat26" & "`a'" ~= "[M6_OP_relative_REFrep]xxxOPpuzzletypeA6" & "`a'" ~= "[M6_OP_relative_REFrep]xxxOPtestztreat16") { 
		global test = "$test" + " " + "`a'"
		matrix BB[1,`k'] = B[1,`i']
		local k = `k' + 1
		}
	}
global j = $j - 6

capture suest $M, robust
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (BB[1,1..$j]-B3)*invsym(V)*(BB[1,1..$j]-B3)'
		mata test = st_matrix("test"); ResF[`c',6..10] = (`r(p)', `r(drop)', `r(df)', test[1,1], 3)
		}
	}

*Table 4
global i = 0
mycmd (OPtreat4 OPtreat5 OPpuzzletypeA) probit ref OPtreat4 OPtreat5 OPpuzzletypeA sumrefrain anyrain OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7 
mycmd (OPtestztreat4 OPtestztreat5 OPtreat4 OPtreat5 OPpuzzletypeA) probit ref OPtestztreat4 OPtestztreat5 OPtreat4 OPtreat5 OPpuzzletypeA sumrefrain anyrain OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7 
mycmd (OPtreat4 OPtreat5 OPpuzzletypeA) heckman OP_coworkers_REFrep OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend)
mycmd (OPtestztreat4 OPtestztreat5 OPtreat4 OPtreat5 OPpuzzletypeA) heckman OP_coworkers_REFrep OPtestztreat4 OPtestztreat5 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtestztreat4 OPtestztreat5 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend)
mycmd (OPtreat4 OPtreat5 OPpuzzletypeA) heckman OP_relative_REFrep OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend)
mycmd (OPtestztreat4 OPtestztreat5 OPtreat4 OPtreat5 OPpuzzletypeA) heckman OP_relative_REFrep OPtestztreat4 OPtestztreat5 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtestztreat4 OPtestztreat5 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend)

capture suest $M, robust
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B4)*invsym(V)*(B[1,1..$j]-B4)'
		mata test = st_matrix("test"); ResF[`c',11..15] = (`r(p)', `r(drop)', `r(df)', test[1,1], 4)
		}
	}

*Table 5
global i = 0
mycmd (OPtreat4 OPtreat5 OPpuzzletypeA) heckman reftestz OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend)
mycmd (OPtreat4 OPtreat5 OPpuzzletypeA) heckman reftestz OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend)
mycmd (OPtestztreat4 OPtestztreat5 OPtreat4 OPtreat5 OPpuzzletypeA) heckman reftestz OPtestztreat4 OPtestztreat5 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7, select (sumrefrain anyrain OPtestztreat4 OPtestztreat5 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend)
mycmd (OPtreat4 OPtreat5 OPpuzzletypeA) reg reftestz_e OPtreat4 OPtreat5 OPpuzzletypeA OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7
mycmd (OPtreat4 OPtreat5 OPpuzzletypeA) reg reftestz_e OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7
mycmd (OPtestztreat4 OPtestztreat5 OPtreat4 OPtreat5 OPpuzzletypeA) reg reftestz_e OPtestztreat4 OPtestztreat5 OPtreat4 OPtreat5 OPpuzzletypeA OPtestz OPAGEGRP2-OPAGEGRP9 OPed_cont ln_income OPravtest OPdigtest WKID2-WKID18 weekend if OPtreat~=6 & OPtreat~=7

capture suest $M, robust
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B5)*invsym(V)*(B[1,1..$j]-B5)'
		mata test = st_matrix("test"); ResF[`c',16..20] = (`r(p)', `r(drop)', `r(df)', test[1,1], 5)
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
save results\OBootstrapSuestBM, replace

capture erase aa.dta
capture erase aaa.dta


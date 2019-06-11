**** set path 
global projectFolder "[path to supplementary folder]/05_supplementary" // <---- set location of supplementary materials folder

**** folder globals
do "$projectFolder/do/_path_Generic"

**** log file
capture log close
set more 1
log using "$logFolder/wildBoot_Exp_Complete_stata.log", replace

**** preliminaries
quietly adopath + "$adoFolder"
estimates clear
mat drop _all
cd "$projectFolder"

**** output parameters
local rewriteTexFiles =0 	// **** set !=0 to re-write tex table files ****
local esttabMatFragment "label nomtitles nonumbers eql(none) collabels(none) nolines booktabs fragment"

**** bootstrap parameters
global BS = 9999				// set the number of bootstraps
global RSEED = 20170306 	// set random number seed

**** numerical optimisation parameters
local stdIntPoints 12
local moreIntPoints 30

**** margin predict types
local pbtPredType "pr"
local mepPredType "mu" // requires Stata 14
local mixPredType "xb"

**** load data
use "$data/stata/efy_dat_exp_1.dta", clear
xtset id period

**** generate additional variables
gen byte coop_r1 = coop if round==1
gen byte coop_rl = coop if round==length
gen byte four = (horizon ==0)
gen byte eight = (horizon ==1)

****
**** Table 3: cooperation rates early versus late supergames
****
preserve
local tabName "table3"
gen secondhalf = 0
replace secondhalf = 1  if match > 15
foreach var of varlist treat_1-treat_4 four eight {
	gen byte `var'Xsecondhalf = `var' * secondhalf
}
local depVarList coop coop_r1 coop_rl first_defect
local clusterVar session
foreach depVar of varlist `depVarList' {
	* general regression specification locals
	local ifCond " "
	if("`depVar'" =="coop_r1") local ifCond "if round ==1"
	if("`depVar'" =="coop_rl") local ifCond "if round ==length"
	if("`depVar'" =="first_defect") local ifCond "if round ==1"
	** treatment breakdown
	local controlVars treat_2 treat_3 treat_4
	local interestVars treat_1Xsecondhalf treat_2Xsecondhalf treat_3Xsecondhalf treat_4Xsecondhalf
	local ninterestvars: word count `interestVars'
	local matName Ps_`tabName'_`depVar'
	mat `matName' = J(`ninterestvars',4,.)
	mat rownames `matName' = `interestVars'
	mat colnames `matName' = "diff" "CR-t" "Bt-t" "RE-t"
	* difference column
	reg `depVar' `controlVars' `interestVars' `ifCond' , cluster(`clusterVar') 
	mat temp = r(table)
	mat temp = temp'
	forvalues ivar =1/`ninterestvars' {
		local testVar: word `ivar' of `interestVars'
		if ("`depVar'" =="first_defect") {
			mat `matName'[`ivar', 1] = temp["`testVar'","b"]
		}
		else {
			mat `matName'[`ivar', 1] = 100 * temp["`testVar'","b"]
		}
	}
	* meprobit and CR-t 
	if ("`depVar'" =="first_defect") {
		mixed `depVar' `controlVars' `interestVars' `ifCond' || id : , vce(cluster `clusterVar')
	}
	else {
		meprobit `depVar' `controlVars' `interestVars' `ifCond' || id: , vce(cluster `clusterVar') intpoints(`stdIntPoints')
	}
	forvalues ivar =1/`ninterestvars' {
		local testVar: word `ivar' of `interestVars'
		test `testVar'
		mat `matName'[`ivar', 2] = r(p)
	}
	* probit and Bt-t
	if ("`depVar'" =="first_defect") {
		reg `depVar' `controlVars' `interestVars' `ifCond' , cluster(`clusterVar') 
	}
	else {
		probit `depVar' `controlVars' `interestVars' `ifCond' , cluster(`clusterVar')
	}
	forvalues ivar =1/`ninterestvars' {
		local testVar: word `ivar' of `interestVars'
		boottest `testVar' , weighttype(web) reps($BS ) seed($RSEED ) noci nograph
		mat `matName'[`ivar', 3] = r(p)
	}
	* multiple REs and RE-t
	if ("`depVar'" == "first_defect") {
		mixed `depVar' `controlVars' `interestVars' `ifCond' || session: || id: 
	}
	else {
		meprobit `depVar' `controlVars' `interestVars' `ifCond' || session: || id: , intpoints(`stdIntPoints')
	}
	forvalues ivar =1/`ninterestvars' {
		local testVar: word `ivar' of `interestVars'
		test `testVar'
		mat `matName'[`ivar', 4] = r(p)
	}
	** horizon break-down
	local controlVars eight
	local interestVars fourXsecondhalf eightXsecondhalf
	local ninterestvars: word count `interestVars'
	local matName Ps_`tabName'_`depVar'_horizon
	mat `matName' = J(`ninterestvars',4,.)
	mat rownames `matName' = `interestVars'
	mat colnames `matName' = "diff" "CR-t" "Bt-t" "RE-t"
	* difference column
	reg `depVar' `controlVars' `interestVars' `ifCond' , cluster(`clusterVar') 
	mat temp = r(table)
	mat temp = temp'
	forvalues ivar =1/`ninterestvars' {
		local testVar: word `ivar' of `interestVars'
		if ("`depVar'" =="first_defect") {
			mat `matName'[`ivar', 1] = temp["`testVar'","b"]
		}
		else {
			mat `matName'[`ivar', 1] = 100 * temp["`testVar'","b"]
		}
	}
	* meprobit and CR-t 
	if ("`depVar'" =="first_defect") {
		mixed `depVar' `controlVars' `interestVars' `ifCond' || id : , vce(cluster `clusterVar')
	}
	else {
		meprobit `depVar' `controlVars' `interestVars' `ifCond' || id: , vce(cluster `clusterVar') intpoints(`stdIntPoints')
	}
	forvalues ivar =1/`ninterestvars' {
		local testVar: word `ivar' of `interestVars'
		test `testVar'
		mat `matName'[`ivar', 2] = r(p)
	}
	* probit and Bt-t
	if ("`depVar'" =="first_defect") {
		reg `depVar' `controlVars' `interestVars' `ifCond' , cluster(`clusterVar') 
	}
	else {
		probit `depVar' `controlVars' `interestVars' `ifCond' , cluster(`clusterVar')
	}
	forvalues ivar =1/`ninterestvars' {
		local testVar: word `ivar' of `interestVars'
		boottest `testVar' , weighttype(web) reps($BS ) seed($RSEED ) noci nograph
		mat `matName'[`ivar', 3] = r(p)
	}
	* multiple REs and RE-t
	if ("`depVar'" == "first_defect") {
		mixed `depVar' `controlVars' `interestVars' `ifCond' || session: || id: , 
	}
	else {
		meprobit `depVar' `controlVars' `interestVars' `ifCond' || session: || id: , intpoints(`stdIntPoints')
	}
	forvalues ivar =1/`ninterestvars' {
		local testVar: word `ivar' of `interestVars'
		test `testVar'
		mat `matName'[`ivar', 4] = r(p)
	}
	** total break-down
	local controlVars " "
	local interestVars secondhalf
	local ninterestvars: word count `interestVars'
	local matName Ps_`tabName'_`depVar'_all
	mat `matName' = J(`ninterestvars',4,.)
	mat rownames `matName' = "All"
	mat colnames `matName' = "diff" "CR-t" "Bt-t" "RE-t"
	* difference column
	reg `depVar' `controlVars' `interestVars' `ifCond' , cluster(`clusterVar') 
	mat temp = r(table)
	mat temp = temp'
	forvalues ivar =1/`ninterestvars' {
		local testVar: word `ivar' of `interestVars'
		if ("`depVar'" =="first_defect") {
			mat `matName'[`ivar', 1] = temp["`testVar'","b"]
		}
		else {
			mat `matName'[`ivar', 1] = 100 * temp["`testVar'","b"]
		}
	}
	* meprobit and CR-t 
	if ("`depVar'" =="first_defect") {
		mixed `depVar' `controlVars' `interestVars' `ifCond' || id : , vce(cluster `clusterVar')
	}
	else {
		meprobit `depVar' `controlVars' `interestVars' `ifCond' || id: , vce(cluster `clusterVar') intpoints(`stdIntPoints')
	}
	forvalues ivar =1/`ninterestvars' {
		local testVar: word `ivar' of `interestVars'
		test `testVar'
		mat `matName'[`ivar', 2] = r(p)
	}
	* probit and Bt-t
	if ("`depVar'" =="first_defect") {
		reg `depVar' `controlVars' `interestVars' `ifCond' , cluster(`clusterVar') 
	}
	else {
		probit `depVar' `controlVars' `interestVars' `ifCond' , cluster(`clusterVar')
	}
	forvalues ivar =1/`ninterestvars' {
		local testVar: word `ivar' of `interestVars'
		boottest `testVar' , weighttype(web) reps($BS ) seed($RSEED ) noci nograph
		mat `matName'[`ivar', 3] = r(p)
	}
	* multiple REs and RE-t
	if ("`depVar'" == "first_defect") {
		mixed `depVar' `controlVars' `interestVars' `ifCond' || session: || id: 
	}
	else {
		meprobit `depVar' `controlVars' `interestVars' `ifCond' || session: || id: , intpoints(`stdIntPoints')
	}
	forvalues ivar =1/`ninterestvars' {
		local testVar: word `ivar' of `interestVars'
		test `testVar'
		mat `matName'[`ivar', 4] = r(p)
	}
}
* report output block
mat Ps_`tabName'_part1 = Ps_`tabName'_coop_r1 , Ps_`tabName'_coop_rl 
mat Ps_`tabName'_part2 = Ps_`tabName'_coop , Ps_`tabName'_first_defect
foreach breakdown in horizon all {
	mat Ps_`tabName'_part1_`breakdown' = Ps_`tabName'_coop_r1_`breakdown' , Ps_`tabName'_coop_rl_`breakdown'
	mat Ps_`tabName'_part2_`breakdown' = Ps_`tabName'_coop_`breakdown' , Ps_`tabName'_first_defect_`breakdown'
}
forvalue i =1/2 {
	mat rownames Ps_`tabName'_part`i' = "D4" "D8" "E4" "E8"
	mat rownames Ps_`tabName'_part`i'_horizon = "4" "8"
	mat rownames Ps_`tabName'_part`i'_all = "All"
	mat list Ps_`tabName'_part`i' , format("%8.3f")	// for log file
	if (`rewriteTexFiles' !=0) {
		esttab matrix(Ps_`tabName'_part`i' , fmt(1 2 2 2)) ///
			using "$tableFolder/WildBoot_Exp_`tabName'_part`i'" ///
			, `esttabMatFragment' replace
	}
	foreach breakdown in horizon all {	
		mat list Ps_`tabName'_part`i'_`breakdown' , format("%8.3f")	// for log file
		if (`rewriteTexFiles' !=0) {
			esttab matrix(Ps_`tabName'_part`i'_`breakdown' , fmt(1 2 2 2)) ///
				using "$tableFolder/WildBoot_Exp_`tabName'_part`i'_`breakdown'" ///
				, `esttabMatFragment' replace
		}
	}
}
restore

****
**** Table 4: cooperation rate for all rounds in supergames 1, 2, 8, 20 and 30
****
local tabName "table4"
preserve
keep if match ==1 | match ==2 | match ==8 | match ==20 | match ==30
** treatment break-down
foreach sg of numlist 1 2 8 20 30 {
	foreach treat of numlist 1 2 3 4 {
		gen byte treat_m`sg'_`treat' = (treat_`treat' ==1 & match ==`sg')
	}
}
local depVar coop
local completeVars treat_m1_1 treat_m2_1 treat_m8_1 treat_m20_1 treat_m30_1 treat_m1_2 treat_m2_2 treat_m8_2 treat_m20_2 treat_m30_2 treat_m1_3 treat_m2_3 treat_m8_3 treat_m20_3 treat_m30_3 treat_m1_4 treat_m2_4 treat_m8_4 treat_m20_4 treat_m30_4
local clusterVar session
* difference column
reg `depVar' `completeVars' , noconstant cluster(`clusterVar') 
estimates store tab4_complete_reg
* meprobit and CR-t
meprobit `depVar' `completeVars' , noconstant || id : , vce(cluster `clusterVar') intpoints(`stdIntPoints')
estimates store tab4_complete_mep_crt
* probit and Bt-t
probit `depVar' `completeVars' , noconstant cluster(`clusterVar')
estimates store tab4_complete_pbt
* multiple REs and RE-t
meprobit  `depVar' `completeVars' , noconstant || session: || id: , intpoints(`stdIntPoints')
estimates store tab4_complete_mep_res
* fill in table matrices
foreach sg of numlist 2 8 20 30 { 
	local controlVars treat_1 treat_2 treat_3 treat_4
	local ifcond "if (match ==1 | match ==`sg')"
	local baseVars treat_m1_1 treat_m1_2 treat_m1_3 treat_m1_4
	local interestVars treat_m`sg'_1 treat_m`sg'_2 treat_m`sg'_3 treat_m`sg'_4
	local ninterestvars: word count `interestVars'
	local matName Ps_`tabName'_`sg'
	mat `matName' = J(`ninterestvars',4,.)
	mat rownames `matName' = `interestVars'
	mat colnames `matName' = "diff" "CR-t" "Bt-t" "RE-t"
	* difference column
	estimates restore tab4_complete_reg
	forvalues ivar =1/`ninterestvars' {
		local testVar1: word `ivar' of `interestVars'
		local testVar2: word `ivar' of `baseVars'
		mat `matName'[`ivar', 1] = 100 * (_b[`testVar1'] - _b[`testVar2'])
	}
	* meprobit and CR-t 
	estimates restore tab4_complete_mep_crt
	forvalues ivar =1/`ninterestvars' {
		local testVar1: word `ivar' of `interestVars'
		local testVar2: word `ivar' of `baseVars'
		test `testVar1' == `testVar2'
		mat `matName'[`ivar', 2] = r(p)
	}
	* probit and Bt-t
	estimates restore tab4_complete_pbt
	forvalues ivar =1/`ninterestvars' {
		local testVar1: word `ivar' of `interestVars'
		local testVar2: word `ivar' of `baseVars'
		boottest `testVar1' == `testVar2' , weighttype(web) reps($BS ) seed($RSEED ) noci nograph
		mat `matName'[`ivar', 3] = r(p)
	}
	* multiple REs and RE-t
	estimates restore tab4_complete_mep_res
	forvalues ivar =1/`ninterestvars' {
		local testVar1: word `ivar' of `interestVars'
		local testVar2: word `ivar' of `baseVars'
		test `testVar1' == `testVar2'
		mat `matName'[`ivar', 4] = r(p)
	}
}
** horizon break-down
foreach sg of numlist 1 2 8 20 30 {
	foreach hor of numlist 4 8 {
		gen byte hor_m`sg'_`hor' = (length ==`hor' & match ==`sg')
	}
}
local depVar coop
local completeVars hor_m1_4 hor_m2_4 hor_m8_4 hor_m20_4 hor_m30_4 hor_m1_8 hor_m2_8 hor_m8_8 hor_m20_8 hor_m30_8
local clusterVar session
* difference column
reg `depVar' `completeVars' , noconstant cluster(`clusterVar') 
estimates store tab4_complete_hor_reg
* meprobit and CR-t
meprobit `depVar' `completeVars' , noconstant || id : , vce(cluster `clusterVar') intpoints(`stdIntPoints')
estimates store tab4_complete_hor_mep_crt
* probit and Bt-t
probit `depVar' `completeVars' , noconstant cluster(`clusterVar')
estimates store tab4_complete_hor_pbt
* multiple REs and RE-t
meprobit  `depVar' `completeVars' , noconstant || session: || id: , intpoints(`stdIntPoints')
estimates store tab4_complete_hor_mep_res
* fill in table matrices
foreach sg of numlist 2 8 20 30 { 
	local controlVars four eight
	local ifcond "if (match ==1 | match ==`sg')"
	local baseVars hor_m1_4 hor_m1_8 
	local interestVars hor_m`sg'_4 hor_m`sg'_8
	local ninterestvars: word count `interestVars'
	local matName Ps_`tabName'_`sg'_horizon
	mat `matName' = J(`ninterestvars',4,.)
	mat rownames `matName' = `interestVars'
	mat colnames `matName' = "diff" "CR-t" "Bt-t" "RE-t"
	* difference column
	estimates restore tab4_complete_hor_reg
	forvalues ivar =1/`ninterestvars' {
		local testVar1: word `ivar' of `interestVars'
		local testVar2: word `ivar' of `baseVars'
		mat `matName'[`ivar', 1] = 100 * (_b[`testVar1'] - _b[`testVar2'])
	}
	* meprobit and CR-t 
	estimates restore tab4_complete_hor_mep_crt
	forvalues ivar =1/`ninterestvars' {
		local testVar1: word `ivar' of `interestVars'
		local testVar2: word `ivar' of `baseVars'
		test `testVar1' == `testVar2'
		mat `matName'[`ivar', 2] = r(p)
	}
	* probit and Bt-t
	estimates restore tab4_complete_hor_pbt
	forvalues ivar =1/`ninterestvars' {
		local testVar1: word `ivar' of `interestVars'
		local testVar2: word `ivar' of `baseVars'
		boottest `testVar1' == `testVar2' , weighttype(web) reps($BS ) seed($RSEED ) noci nograph
		mat `matName'[`ivar', 3] = r(p)
	}
	* multiple REs and RE-t
	estimates restore tab4_complete_hor_mep_res
	forvalues ivar =1/`ninterestvars' {
		local testVar1: word `ivar' of `interestVars'
		local testVar2: word `ivar' of `baseVars'
		test `testVar1' == `testVar2'
		mat `matName'[`ivar', 4] = r(p)
	}
}
** total break-down
foreach sg of numlist 1 2 8 20 30 {
	gen byte all_m`sg' = (match ==`sg')
}
local depVar coop
local completeVars all_m1 all_m2 all_m8 all_m20 all_m30
local clusterVar session
* difference column
reg `depVar' `completeVars' , noconstant cluster(`clusterVar') 
estimates store tab4_complete_all_reg
* meprobit and CR-t
meprobit `depVar' `completeVars' , noconstant || id : , vce(cluster `clusterVar') intpoints(`stdIntPoints')
estimates store tab4_complete_all_mep_crt
* probit and Bt-t
probit `depVar' `completeVars' , noconstant cluster(`clusterVar')
estimates store tab4_complete_all_pbt
* multiple REs and RE-t
meprobit  `depVar' `completeVars' , noconstant || session: || id: , intpoints(`stdIntPoints')
estimates store tab4_complete_all_mep_res
* fill in table matrices
foreach sg of numlist 2 8 20 30 { 
	local controlVars " "
	local ifcond "if (match ==1 | match ==`sg')"
	local baseVars all_m1 
	local interestVars all_m`sg'
	local ninterestvars: word count `interestVars'
	local matName Ps_`tabName'_`sg'_all
	mat `matName' = J(`ninterestvars',4,.)
	mat rownames `matName' = `interestVars'
	mat colnames `matName' = "diff" "CR-t" "Bt-t" "RE-t"
	* difference column
	estimates restore tab4_complete_all_reg
	forvalues ivar =1/`ninterestvars' {
		local testVar1: word `ivar' of `interestVars'
		local testVar2: word `ivar' of `baseVars'
		mat `matName'[`ivar', 1] = 100 * (_b[`testVar1'] - _b[`testVar2'])
	}
	* meprobit and CR-t 
	estimates restore tab4_complete_all_mep_crt
	forvalues ivar =1/`ninterestvars' {
		local testVar1: word `ivar' of `interestVars'
		local testVar2: word `ivar' of `baseVars'
		test `testVar1' == `testVar2'
		mat `matName'[`ivar', 2] = r(p)
	}
	* probit and Bt-t
	estimates restore tab4_complete_all_pbt
	forvalues ivar =1/`ninterestvars' {
		local testVar1: word `ivar' of `interestVars'
		local testVar2: word `ivar' of `baseVars'
		boottest `testVar1' == `testVar2' , weighttype(web) reps($BS ) seed($RSEED ) noci nograph
		mat `matName'[`ivar', 3] = r(p)
	}
	* multiple REs and RE-t
	estimates restore tab4_complete_all_mep_res
	forvalues ivar =1/`ninterestvars' {
		local testVar1: word `ivar' of `interestVars'
		local testVar2: word `ivar' of `baseVars'
		test `testVar1' == `testVar2'
		mat `matName'[`ivar', 4] = r(p)
	}
}	
** report output blocks
mat Ps_`tabName'_part1 = Ps_`tabName'_2 , Ps_`tabName'_8  
mat Ps_`tabName'_part2 = Ps_`tabName'_20 , Ps_`tabName'_30
foreach breakdown in horizon all {
	mat Ps_`tabName'_part1_`breakdown' = Ps_`tabName'_2_`breakdown' , Ps_`tabName'_8_`breakdown'
	mat Ps_`tabName'_part2_`breakdown' = Ps_`tabName'_20_`breakdown' , Ps_`tabName'_30_`breakdown'
}
forvalues i=1/2 {
	mat rownames Ps_`tabName'_part`i' = "D4" "D8" "E4" "E8"
	mat rownames Ps_`tabName'_part`i'_horizon = "4" "8"
	mat rownames Ps_`tabName'_part`i'_all = "All"
	mat list Ps_`tabName'_part`i' , format("%8.3f")	// for log file
	if (`rewriteTexFiles' !=0) {
		esttab matrix(Ps_`tabName'_part`i' , fmt(1 2 2 2)) ///
			using "$tableFolder/WildBoot_Exp_`tabName'_part`i'" ///
			, `esttabMatFragment' replace
	}
	foreach breakdown in horizon all {	
		mat list Ps_`tabName'_part`i'_`breakdown' , format("%8.3f")	// for log file
		if (`rewriteTexFiles' !=0) {
			esttab matrix(Ps_`tabName'_part`i'_`breakdown' , fmt(1 2 2 2)) ///
				using "$tableFolder/WildBoot_Exp_`tabName'_part`i'_`breakdown'" ///
				, `esttabMatFragment' replace
		}
	}
}
restore

****
**** Table A8: pair-wise comparison of measures across treatments
****
preserve
local tabName "tableA8"
gen secondhalf = 0
replace secondhalf = 1  if match > 15
local depVarList coop coop_r1 coop_rl first_defect
local clusterVar session
* run base regressions and cluster-wild bootstrapped t-tests
forvalues sh =0/1 {
	foreach depVar of varlist `depVarList' {
		local ifCond "if secondhalf ==`sh' "
		if("`depVar'" =="coop_r1") local ifCond "if round ==1 & secondhalf ==`sh'"
		if("`depVar'" =="coop_rl") local ifCond "if round ==length & secondhalf ==`sh'"
		if("`depVar'" =="first_defect") local ifCond "if round ==1 & secondhalf ==`sh'"
		* treatment breakdown
		local controlVars " "
		local interestVars treat_1 treat_2 treat_3 treat_4
		local ninterestvars: word count `interestVars'
		local ncomparisons = (`ninterestvars')*(`ninterestvars'-1) / 2
		local matName Ps_`tabName'_sh`sh'_`depVar'
		mat `matName' = J(`ncomparisons',4,.)
		mat colnames `matName' = "diff" "CR-t" "Bt-t" "RE-t"
		* difference column
		reg `depVar' `interestVars' `controlVars' `ifCond' , cluster(`clusterVar') noconstant
		mat temp = r(table)
		mat temp = temp'
		* meprobit and CR-t
		if ("`depVar'" =="first_defect") {
			mixed `depVar' `interestVars' `controlVars' `ifCond' , noconstant || id: , vce(cluster `clusterVar')
		}
		else {
			meprobit `depVar' `interestVars' `controlVars' `ifCond' , noconstant || id: , vce(cluster `clusterVar') intpoints(`stdIntPoints')
		}
		local counter =0
		forvalues ivar1 =1/`ninterestvars' {
			local testVar1: word `ivar1' of `interestVars'
			local upper =`ivar1'+1
			forvalues ivar2 =`upper'/`ninterestvars' {
				local counter = `counter' + 1
				local testVar2: word `ivar2' of `interestVars'
				if ("`depVar'" =="first_defect") {
					mat `matName'[`counter', 1] =  temp["`testVar1'","b"] - temp["`testVar2'","b"] // populate difference column
				}
				else {
					mat `matName'[`counter', 1] = 100 * temp["`testVar1'","b"] - 100 * temp["`testVar2'","b"] // populate difference column
				}
				test `testVar1' = `testVar2' 
				mat `matName'[`counter', 2] = r(p)
			}
		}
		* probit and Bt-t
		if ("`depVar'" =="first_defect") {
			reg `depVar' `interestVars' `controlVars' `ifCond' , cluster(`clusterVar') noconstant
		}
		else{
			probit `depVar' `interestVars' `controlVars' `ifCond' , cluster(`clusterVar') noconstant
		}
		local counter =0
		forvalues ivar1 =1/`ninterestvars' {
			local testVar1: word `ivar1' of `interestVars'
			local upper =`ivar1'+1
			forvalues ivar2 =`upper'/`ninterestvars' {
				local counter = `counter' + 1
				local testVar2: word `ivar2' of `interestVars'
				boottest `testVar1' = `testVar2' , weighttype(web) reps($BS ) seed($RSEED ) noci nograph
				mat `matName'[`counter', 3] = r(p)
			}
		}
		* multiple REs and RE-t
		if ("`depVar'" == "first_defect") {
			mixed `depVar' `interestVars' `controlVars' `ifCond' , noconstant || session: || id:
		}
		else if ("`depVar'" == "coop_r1") & (`sh' ==1) {
			meprobit `depVar' `interestVars' `controlVars' `ifCond' , noconstant || session: || id: , intpoints(`moreIntPoints') // default options does not converge
		}
		else {
			meprobit `depVar' `interestVars' `controlVars' `ifCond' , noconstant || session: || id: , intpoints(`stdIntPoints')
		}
		local counter =0
		forvalues ivar1 =1/`ninterestvars' {
			local testVar1: word `ivar1' of `interestVars'
			local upper =`ivar1'+1
			forvalues ivar2 =`upper'/`ninterestvars' {
				local counter = `counter' + 1
				local testVar2: word `ivar2' of `interestVars'
				test `testVar1' = `testVar2' 
				mat `matName'[`counter', 4] = r(p)
			}
		}
	}
}
** specific test for D8 versus E4 using all supergames
local matName Ps_`tabName'_allsg_`depVar'
mat `matName' = J(1,4,.)
mat colnames `matName' = "diff" "CR-t" "Bt-t" "RE-t" 
mat rownames `matName' = "D8 vs E4"
* difference column
reg coop_r1 treat_1 treat_2 treat_3 treat_4 if round ==1 , cluster(session) noconstant
mat temp = r(table)
mat temp = temp'
local testVar1 treat_2
local testVar2 treat_3
mat `matName'[1, 1] = 100 * temp["`testVar1'","b"] - 100 * temp["`testVar2'","b"]
* meprobit and CR-t
meprobit coop_r1 treat_1 treat_2 treat_3 treat_4 if round ==1 , noconstant || id : , vce(cluster session) intpoints(`stdIntPoints')
test `testVar1' = `testVar2' 
mat `matName'[1, 2] = r(p)
* probit and Bt-t
probit coop_r1 treat_1 treat_2 treat_3 treat_4 if round ==1 , cluster(session) noconstant
boottest `testVar1' = `testVar2' , weighttype(web) reps($BS ) seed($RSEED ) noci nograph
mat `matName'[1, 3] = r(p)
* multiple REs and RE-t
meprobit coop_r1 treat_1 treat_2 treat_3 treat_4 if round ==1 , noconstant || session: || id: , intpoints(`stdIntPoints')
test `testVar1' = `testVar2' 
mat `matName'[1, 4] = r(p)
** report output block
forvalues sh =0/1 {
	mat Ps_`tabName'_part1_sh`sh' = Ps_`tabName'_sh`sh'_coop_r1 , Ps_`tabName'_sh`sh'_coop_rl 
	mat Ps_`tabName'_part2_sh`sh' = Ps_`tabName'_sh`sh'_coop , Ps_`tabName'_sh`sh'_first_defect
	mat rownames Ps_`tabName'_part1_sh`sh' = "D4 vs D8" "D4 vs E4" "D4 vs E8" "D8 vs E4" "D8 vs E8" "E4 vs E8"
	mat rownames Ps_`tabName'_part2_sh`sh' = "D4 vs D8" "D4 vs E4" "D4 vs E8" "D8 vs E4" "D8 vs E8" "E4 vs E8"
	mat list Ps_`tabName'_part1_sh`sh' , format("%8.3f")	// for log file
	if (`rewriteTexFiles' !=0) {
		esttab matrix(Ps_`tabName'_part1_sh`sh' , fmt(1 2 2 2)) ///
			using "$tableFolder/WildBoot_Exp_`tabName'_part1_sh`sh'" ///
			, `esttabMatFragment' replace
	}
	mat list Ps_`tabName'_part2_sh`sh' , format("%8.3f")	// for log file
	if (`rewriteTexFiles' !=0) {
		esttab matrix(Ps_`tabName'_part2_sh`sh' , fmt(1 2 2 2)) ///
			using "$tableFolder/WildBoot_Exp_`tabName'_part2_sh`sh'" ///
			, `esttabMatFragment' replace
	}
}
mat list Ps_`tabName'_allsg_`depVar' , format("%8.3f") // specific test for D8 versus E4 using all supergames
restore

****
**** Table A.5: consistency with threshold strategies
****
* generate perfectthres variable
preserve
gen mcoop = coop *ocoop
gen foo = (mcoop == 0 & coop_m1 == 1 & ocoop_m1 ==1)
replace foo = 0 if round ==1
replace foo = 1 if round ==1 & coop ==0
replace foo = 1 if round ==1 & ocoop ==0
gen baz1 = foo * round
replace baz1 = length +1 if baz1 ==0
egen mfdef = min(baz1), by(id session match)
gen deviation =0
replace deviation =1 if (round >mfdef & coop ==1)
egen totdev = sum(deviation), by(id session match)
gen perfectthres = 0
replace perfectthres = 1 if totdev ==0
* keep only first round data for first and last supergames
keep if round ==1
keep if match == 1 | lastmatch == 1
* combination of g l length parameters
qui gen neg_g = -g
qui gen neg_l = -l
sort length neg_g neg_l
capture drop combination
qui egen int combination = group(length neg_g neg_l)
summ combination
local nComb  = r(max)
capture drop neg_g neg_l
* matrices to store output
local depVar perfectthres
local statList FvL CR_t BT_t RE_t
foreach var in rowlabel rowcounter `statList' {
	capture drop `var'
}
bysort combination: gen int rowcounter = _n
qui gen str rowlabel = "EFY"
foreach var in `statList' {
	qui gen `var' =.
}
mkmat length g l `statList' if rowcounter ==1 , mat(Ps_fvl_`depVar') rownames(rowlabel)
foreach var in rowlabel rowcounter `statList' {
	capture drop `var'
}
* parameter values indicators
forvalues comb = 1/`nComb' {
	gen byte paraComb_`comb' = (combination == `comb')
	gen byte paraCombXlastmatch_`comb' = (combination == `comb' & lastmatch ==1)
}
* regression specification locals
local clusterVar session
local controlVars "paraComb_2 paraComb_3 paraComb_4"
local interestVars "paraCombXlastmatch_1 paraCombXlastmatch_2 paraCombXlastmatch_3 paraCombXlastmatch_4"
local ninterestvars: word count `interestVars'
local matName Ps_fvl_`depVar'
* difference column
reg `depVar' `interestVars' `controlVars' , cluster(`clusterVar')
mat temp = r(table)
mat temp = temp'
forvalues ivar =1/`ninterestvars' {
	local testVar: word `ivar' of `interestVars'
	mat `matName'[`ivar', 4] = temp["`testVar'","b"]
}
* meprobit and CR-t
meprobit `depVar' `interestVars' `controlVars' || id : , vce(cluster `clusterVar') intpoints(`stdIntPoints')
forvalues ivar =1/`ninterestvars' {
	local testVar: word `ivar' of `interestVars'
	test `testVar'
	mat `matName'[`ivar', 5] = r(p)
}
* probit and Bt-t
probit `depVar' `interestVars' `controlVars' , vce(cluster `clusterVar')
forvalues ivar =1/`ninterestvars' {
	local testVar: word `ivar' of `interestVars'
	boottest `testVar' , weighttype(web) reps($BS ) seed($RSEED ) noci nograph
	mat `matName'[`ivar', 6] = r(p)
}
* multiple REs and RE-t
meprobit `depVar' `interestVars' `controlVars' || session: || id : , intpoints(`stdIntPoints')
forvalues ivar =1/`ninterestvars' {
	local testVar: word `ivar' of `interestVars'
	test `testVar'
	mat `matName'[`ivar', 7] = r(p)
}
* total row
local clusterVar session
local matName Ps_fvl_`depVar'_all
mat `matName' = J(1,7,.)
mat rownames `matName' = "EFY All"
mat colnames `matName' = "length" "g" "l" "ME" "CR_t" "BT_t" "RE_t"
local testVar lastmatch
	* difference column
	reg `depVar' `testVar' , cluster(`clusterVar')
	mat temp = r(table)
	mat temp = temp'
	mat `matName'[1, 4] = temp[1,1]
	* meprobit and CR-t
	meprobit `depVar' `testVar' || id : , vce(cluster `clusterVar') intpoints(`stdIntPoints')
	test `testVar'
	mat `matName'[1, 5] = r(p)
	* probit regression and score bootstrap
	probit `depVar' `testVar', cluster(`clusterVar') 		
	boottest `testVar' , weighttype(webb) reps($BS ) seed($RSEED ) noci nograph
	mat `matName'[1, 6] = r(p)
	* multiple REs and RE-t
	meprobit `depVar' `testVar' || session : || id : , intpoints(`stdIntPoints')
	test `testVar'
	mat `matName'[1, 7] = r(p)
* report output block
mat list Ps_fvl_`depVar' , format("%8.3f") // for log file
mat list Ps_fvl_`depVar'_all , format("%8.3f") // for log file
if (`rewriteTexFiles' !=0) {
	esttab matrix(Ps_fvl_`depVar' , fmt(0 2 2 2 2 2 2)) ///
		using "$tableFolder/WildBoot_Exp_fvl_`depVar'" ///
		, `esttabMatFragment' replace
	esttab matrix(Ps_fvl_`depVar'_all , fmt(0 2 2 2 2 2 2)) ///
		using "$tableFolder/WildBoot_Exp_fvl_`depVar'_all" ///
		, `esttabMatFragment' replace
}
restore

**** clean up
quietly adopath - "$adoFolder"
clear
estimates clear
mat drop _all
log close

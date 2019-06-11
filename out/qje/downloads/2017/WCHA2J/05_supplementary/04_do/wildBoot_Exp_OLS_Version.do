**** set path 
global projectFolder "[path to supplementary folder]/05_supplementary" // <---- set location of supplementary materials folder

**** folder globals
do "$projectFolder/do/path/_path_Generic"

**** log file
capture log close
set more 1
log using "$logFolder/wildBoot_Exp_OLS_Version_stata.log", replace

**** preliminaries
quietly adopath + "$adoFolder"
estimates clear
mat drop _all
cd "$projectFolder"

**** output parameters
local rewriteTexFiles =0 	// **** set !=0 to re-write tex table files ****
local esttabMatFragment "label nomtitles nonumbers eql(none) collabels(none) nolines booktabs fragment"

**** bootstrap parameters
global BS = 999			// set the number of bootstraps
global RSEED = 20170306 	// set random number seed
local debugMode = 0			// set to !=0 for additional debug output

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
local tabName "t3_ols"
gen secondhalf = 0
replace secondhalf = 1  if match > 15
foreach var of varlist treat_1-treat_4 four eight {
	gen byte `var'Xsecondhalf = `var' * secondhalf
}
local depVarList coop coop_r1 coop_rl first_defect
local clusterVar session
* run base regressions and cluster-wild bootstrapped t-tests
foreach depVar of varlist `depVarList' {
	local ifCond " "
	if("`depVar'" =="coop_r1") local ifCond "if round ==1"
	if("`depVar'" =="coop_rl") local ifCond "if round ==length"
	if("`depVar'" =="first_defect") local ifCond "if round ==1"
	** treatment breakdown
	local controlVars treat_2 treat_3 treat_4
	local interestVars treat_1Xsecondhalf treat_2Xsecondhalf treat_3Xsecondhalf treat_4Xsecondhalf
	local ninterestvars: word count `interestVars'
	local matName Ps_`tabName'_`depVar'_ols
	mat `matName' = J(`ninterestvars',7,.)
	mat rownames `matName' = `interestVars'
	mat colnames `matName' = "diff" "mep_CR_z" "xtr_CR_z" "xtr_CR_t" "xtr_Bt_t" "ols_CR_t" "ols_Bt_t"
	* difference column and ols regression
	reg `depVar' `controlVars' `interestVars' `ifCond' , cluster(`clusterVar')
	forvalues ivar =1/`ninterestvars' {
		local testVar: word `ivar' of `interestVars'
		if ("`depVar'" =="first_defect") {
			mat `matName'[`ivar', 1] = _b[`testVar'] // difference
		}
		else {
			mat `matName'[`ivar', 1] = 100 * _b[`testVar'] // difference
		}
		test `testVar'
		mat `matName'[`ivar', 6] = r(p) // ols CR-t
		boottest `testVar' , weighttype(webb) reps($BS ) seed($RSEED ) noci nograph 
		mat `matName'[`ivar', 7] = r(p) // ols Bt-t
	}
	* main text regression
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
	* RE GLS regression
	xtrClusterWildBoot , dep("`depVar'") inter("`interestVars'") ///
		cont("`controlVars' `ifCond'") ///
		clust("`clusterVar'") ///
		basespec("t3_`depVar'_xtr") spec("t3_`depVar'_xtr") ///
		bs($BS) rseed($RSEED) debug(`debugMode')
	forvalues ivar =1/`ninterestvars' {
		local testVar: word `ivar' of `interestVars'
		test `testVar'
		mat `matName'[`ivar', 3] = r(p) // xtr CR-z
		mat `matName'[`ivar', 4] = Ps_t3_`depVar'_xtr[`ivar',2] // xtr CR-t
		mat `matName'[`ivar', 5] = Ps_t3_`depVar'_xtr[`ivar',3] // xtr Bt-t
	}	
	** horizon break-down
	local controlVars eight
	local interestVars fourXsecondhalf eightXsecondhalf
	local ninterestvars: word count `interestVars'
	local matName Ps_`tabName'_`depVar'_ols_hor
	mat `matName' = J(`ninterestvars',7,.)
	mat rownames `matName' = `interestVars'
	mat colnames `matName' = "diff" "mep_CR_z" "xtr_CR_z" "xtr_CR_t" "xtr_Bt_t" "ols_CR_t" "ols_Bt_t"
	* difference column and ols regression
	reg `depVar' `controlVars' `interestVars' `ifCond' , cluster(`clusterVar')
	forvalues ivar =1/`ninterestvars' {
		local testVar: word `ivar' of `interestVars'
		if ("`depVar'" =="first_defect") {
			mat `matName'[`ivar', 1] = _b[`testVar'] // difference
		}
		else {
			mat `matName'[`ivar', 1] = 100 * _b[`testVar'] // difference
		}
		test `testVar'
		mat `matName'[`ivar', 6] = r(p) // ols CR-t
		boottest `testVar' , weighttype(webb) reps($BS ) seed($RSEED ) noci nograph 
		mat `matName'[`ivar', 7] = r(p) // ols Bt-t
	}
	* main text regression
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
	* RE GLS regression
	xtrClusterWildBoot , dep("`depVar'") inter("`interestVars'") ///
		cont("`controlVars' `ifCond'") ///
		clust("`clusterVar'") ///
		basespec("t3_`depVar'_xtr_hor") spec("t3_`depVar'_xtr_hor") ///
		bs($BS) rseed($RSEED) debug(`debugMode')
	forvalues ivar =1/`ninterestvars' {
		local testVar: word `ivar' of `interestVars'
		test `testVar'
		mat `matName'[`ivar', 3] = r(p) // xtr CR-z
		mat `matName'[`ivar', 4] = Ps_t3_`depVar'_xtr_hor[`ivar',2] // xtr CR-t
		mat `matName'[`ivar', 5] = Ps_t3_`depVar'_xtr_hor[`ivar',3] // xtr Bt-t
	}
	** total break-down
	local controlVars " "
	local interestVars secondhalf
	local ninterestvars: word count `interestVars'
	local matName Ps_`tabName'_`depVar'_ols_all
	mat `matName' = J(`ninterestvars',7,.)
	mat rownames `matName' = "All"
	mat colnames `matName' = "diff" "mep_CR_z" "xtr_CR_z" "xtr_CR_t" "xtr_Bt_t" "ols_CR_t" "ols_Bt_t"
	* difference column and ols regression
	reg `depVar' `controlVars' `interestVars' `ifCond' , cluster(`clusterVar')
	forvalues ivar =1/`ninterestvars' {
		local testVar: word `ivar' of `interestVars'
		if ("`depVar'" =="first_defect") {
			mat `matName'[`ivar', 1] = _b[`testVar'] // difference
		}
		else {
			mat `matName'[`ivar', 1] = 100 * _b[`testVar'] // difference
		}
		test `testVar'
		mat `matName'[`ivar', 6] = r(p) // ols CR-t
		boottest `testVar' , weighttype(webb) reps($BS ) seed($RSEED ) noci nograph 
		mat `matName'[`ivar', 7] = r(p) // ols Bt-t
	}
	* main text regression
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
	* RE GLS regression
	xtrClusterWildBoot , dep("`depVar'") inter("`interestVars'") ///
		cont("`controlVars' `ifCond'") ///
		clust("`clusterVar'") ///
		basespec("t3_`depVar'_xtr_all") spec("t3_`depVar'_xtr_all") ///
		bs($BS) rseed($RSEED) debug(`debugMode')
	forvalues ivar =1/`ninterestvars' {
		local testVar: word `ivar' of `interestVars'
		test `testVar'
		mat `matName'[`ivar', 3] = r(p) // xtr CR-z
		mat `matName'[`ivar', 4] = Ps_t3_`depVar'_xtr_all[`ivar',2] // xtr CR-t
		mat `matName'[`ivar', 5] = Ps_t3_`depVar'_xtr_all[`ivar',3] // xtr Bt-t
	}
	** report output block
	mat rownames Ps_`tabName'_`depVar'_ols = "D4" "D8" "E4" "E8"
	mat rownames Ps_`tabName'_`depVar'_ols_hor = "4" "8"
	mat rownames Ps_`tabName'_`depVar'_ols_all = "All"
	mat list Ps_`tabName'_`depVar'_ols , format("%8.3f")	// for log file
	if (`rewriteTexFiles' !=0) {
		esttab matrix(Ps_`tabName' , fmt(1 2 2 2 2 2 2)) ///
			using "$tableFolder/WildBoot_Exp_`tabName'_`depVar'" ///
			, `esttabMatFragment' replace
	}
	foreach breakdown in hor all {	
		mat list Ps_`tabName'_`depVar'_ols_`breakdown' , format("%8.3f")	// for log file
		if (`rewriteTexFiles' !=0) {
			esttab matrix(Ps_`tabName'_`breakdown' , fmt(1 2 2 2 2 2 2)) ///
				using "$tableFolder/WildBoot_Exp_`tabName'_`depVar'_`breakdown'" ///
				, `esttabMatFragment' replace
		}
	}
}
restore

****	
**** Table 4: cooperation rate for all rounds in supergames 1, 2, 8, 20 and 30
****
local tabName "t4_ols"
local depVar coop
local ifCond "if sgcolumn <."
local clusterVar session
* run base regressions and cluster-wild bootstrapped t-tests
foreach sg of numlist 2 8 20 30 {
	preserve
	qui gen byte sgcolumn = 0 if match ==1
	qui replace sgcolumn = 1 if match ==`sg'
	foreach var of varlist treat_1-treat_4 four eight {
		qui gen byte `var'Xsgcolumn = `var' * sgcolumn
	}
	** treatment break-down
	local controlVars treat_2 treat_3 treat_4
	local interestVars treat_1Xsgcolumn treat_2Xsgcolumn treat_3Xsgcolumn treat_4Xsgcolumn
	local ninterestvars: word count `interestVars'
	local matName Ps_`tabName'_`sg'
	mat `matName' = J(`ninterestvars',7,.)
	mat rownames `matName' = `interestVars'
	mat colnames `matName' = "diff" "mep_CR_z" "xtr_CR_z" "xtr_CR_t" "xtr_Bt_t" "ols_CR_t" "ols_Bt_t"
	* difference column and ols regression
	reg `depVar' `controlVars' `interestVars' `ifCond' , cluster(`clusterVar')
	forvalues ivar =1/`ninterestvars' {
		local testVar: word `ivar' of `interestVars'
		mat `matName'[`ivar', 1] = 100 * _b[`testVar'] // difference
		test `testVar'
		mat `matName'[`ivar', 6] = r(p) // ols CR-t
		boottest `testVar' , weighttype(webb) reps($BS ) seed($RSEED ) noci nograph 
		mat `matName'[`ivar', 7] = r(p) // ols Bt-t
	}
	* main text regression
	meprobit `depVar' `controlVars' `interestVars' `ifCond' || id: , vce(cluster `clusterVar') intpoints(`stdIntPoints')
	forvalues ivar =1/`ninterestvars' {
		local testVar: word `ivar' of `interestVars'
		test `testVar'
		mat `matName'[`ivar', 2] = r(p)
	}
	* RE GLS regression
	xtrClusterWildBoot , dep("`depVar'") inter("`interestVars'") ///
		cont("`controlVars' `ifCond'") ///
		clust("`clusterVar'") ///
		basespec("t4_`sg'_xtr") spec("t4_`sg'_xtr") ///
		bs($BS) rseed($RSEED) debug(`debugMode')
	forvalues ivar =1/`ninterestvars' {
		local testVar: word `ivar' of `interestVars'
		test `testVar'
		mat `matName'[`ivar', 3] = r(p) // xtr CR-z
		mat `matName'[`ivar', 4] = Ps_t4_`sg'_xtr[`ivar',2] // xtr CR-t
		mat `matName'[`ivar', 5] = Ps_t4_`sg'_xtr[`ivar',3] // xtr Bt-t
	}
	** horizon break-down
	local controlVars eight
	local interestVars fourXsgcolumn eightXsgcolumn
	local ninterestvars: word count `interestVars'
	local matName Ps_`tabName'_`sg'_hor
	mat `matName' = J(`ninterestvars',7,.)
	mat rownames `matName' = `interestVars'
	mat colnames `matName' = "diff" "mep_CR_z" "xtr_CR_z" "xtr_CR_t" "xtr_Bt_t" "ols_CR_t" "ols_Bt_t"
	* difference column and ols regression
	reg `depVar' `controlVars' `interestVars' `ifCond' , cluster(`clusterVar')
	forvalues ivar =1/`ninterestvars' {
		local testVar: word `ivar' of `interestVars'
		mat `matName'[`ivar', 1] = 100 * _b[`testVar'] // difference
		test `testVar'
		mat `matName'[`ivar', 6] = r(p) // ols CR-t
		boottest `testVar' , weighttype(webb) reps($BS ) seed($RSEED ) noci nograph 
		mat `matName'[`ivar', 7] = r(p) // ols Bt-t
	}
	* main text regression
	meprobit `depVar' `controlVars' `interestVars' `ifCond' || id: , vce(cluster `clusterVar') intpoints(`stdIntPoints')
	forvalues ivar =1/`ninterestvars' {
		local testVar: word `ivar' of `interestVars'
		test `testVar'
		mat `matName'[`ivar', 2] = r(p)
	}
	* RE GLS regression
	xtrClusterWildBoot , dep("`depVar'") inter("`interestVars'") ///
		cont("`controlVars' `ifCond'") ///
		clust("`clusterVar'") ///
		basespec("t4_`sg'_xtr_hor") spec("t4_`sg'_xtr_hor") ///
		bs($BS) rseed($RSEED) debug(`debugMode')
	forvalues ivar =1/`ninterestvars' {
		local testVar: word `ivar' of `interestVars'
		test `testVar'
		mat `matName'[`ivar', 3] = r(p) // xtr CR-z
		mat `matName'[`ivar', 4] = Ps_t4_`sg'_xtr_hor[`ivar',2] // xtr CR-t
		mat `matName'[`ivar', 5] = Ps_t4_`sg'_xtr_hor[`ivar',3] // xtr Bt-t
	}	
	** total break-down
	local controlVars " "
	local interestVars sgcolumn
	local ninterestvars: word count `interestVars'
	local matName Ps_`tabName'_`sg'_all
	mat `matName' = J(`ninterestvars',7,.)
	mat rownames `matName' = "All"
	mat colnames `matName' = "diff" "mep_CR_z" "xtr_CR_z" "xtr_CR_t" "xtr_Bt_t" "ols_CR_t" "ols_Bt_t"
	* difference column and ols regression
	reg `depVar' `controlVars' `interestVars' `ifCond' , cluster(`clusterVar')
	forvalues ivar =1/`ninterestvars' {
		local testVar: word `ivar' of `interestVars'
		mat `matName'[`ivar', 1] = 100 * _b[`testVar'] // difference
		test `testVar'
		mat `matName'[`ivar', 6] = r(p) // ols CR-t
		boottest `testVar' , weighttype(webb) reps($BS ) seed($RSEED ) noci nograph 
		mat `matName'[`ivar', 7] = r(p) // ols Bt-t
	}
	* main text regression
	meprobit `depVar' `controlVars' `interestVars' `ifCond' || id: , vce(cluster `clusterVar') intpoints(`stdIntPoints')
	forvalues ivar =1/`ninterestvars' {
		local testVar: word `ivar' of `interestVars'
		test `testVar'
		mat `matName'[`ivar', 2] = r(p)
	}
	* RE GLS regression
	xtrClusterWildBoot , dep("`depVar'") inter("`interestVars'") ///
		cont("`controlVars' `ifCond'") ///
		clust("`clusterVar'") ///
		basespec("t4_`sg'_xtr_hor") spec("t4_`sg'_xtr_hor") ///
		bs($BS) rseed($RSEED) debug(`debugMode')
	forvalues ivar =1/`ninterestvars' {
		local testVar: word `ivar' of `interestVars'
		test `testVar'
		mat `matName'[`ivar', 3] = r(p) // xtr CR-z
		mat `matName'[`ivar', 4] = Ps_t4_`sg'_xtr_hor[`ivar',2] // xtr CR-t
		mat `matName'[`ivar', 5] = Ps_t4_`sg'_xtr_hor[`ivar',3] // xtr Bt-t
	}
	restore
	* report output block
	mat rownames Ps_`tabName'_`sg' = "D4" "D8" "E4" "E8"
	mat rownames Ps_`tabName'_`sg'_hor = "4" "8"
	mat rownames Ps_`tabName'_`sg'_all = "All"
	mat list Ps_`tabName'_`sg' , format("%8.3f")	// for log file
	if (`rewriteTexFiles' !=0) {
		esttab matrix(Ps_`tabName'_`sg' , fmt(1 2 2 2 2 2 2)) ///
			using "$tableFolder/WildBoot_Exp_`tabName'_`sg'" ///
			, `esttabMatFragment' replace
	}
	foreach breakdown in hor all {	
		mat list Ps_`tabName'_`sg'_`breakdown' , format("%8.3f")	// for log file
		if (`rewriteTexFiles' !=0) {
			esttab matrix(Ps_`tabName'_`sg'_`breakdown' , fmt(1 2 2 2 2 2 2)) ///
				using "$tableFolder/WildBoot_Exp_`tabName'_`sg'_`breakdown'" ///
				, `esttabMatFragment' replace
		}
	}
}		
	
**** Table A8: pair-wise comparison of measure across treatments 
preserve
local tabName "tA8_ols"
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
		** treatment breakdown
		local controlVars " "
		local interestVars treat_1 treat_2 treat_3 treat_4
		local ninterestvars: word count `interestVars'
		local ncomparisons = (`ninterestvars')*(`ninterestvars'-1) / 2
		local matName Ps_`tabName'_sh`sh'_`depVar'
		mat `matName' = J(`ncomparisons',7,.)
		mat colnames `matName' = "diff" "mep_CR_z" "xtr_CR_z" "xtr_CR_t" "xtr_Bt_t" "ols_CR_t" "ols_Bt_t"
		* difference column and ols regression
		reg `depVar' `interestVars' `controlVars' `ifCond' , cluster(`clusterVar') noconstant
		local counter =0
		forvalues ivar1 =1/`ninterestvars' {
			local testVar1: word `ivar1' of `interestVars'
			local upper =`ivar1'+1
			forvalues ivar2 =`upper'/`ninterestvars' {
				local counter = `counter' + 1
				local testVar2: word `ivar2' of `interestVars' 
				if ("`depVar'" =="first_defect") {
					mat `matName'[`counter', 1] = _b[`testVar1'] - _b[`testVar2'] // difference
				}
				else {
					mat `matName'[`counter', 1] = 100 * _b[`testVar1'] - 100 * _b[`testVar2'] // difference
				}
				test `testVar1' = `testVar2'
				mat `matName'[`counter', 6] = r(p) // ols CR-t
				boottest `testVar1' = `testVar2' , weighttype(web) reps($BS ) seed($RSEED ) noci nograph
				mat `matName'[`counter', 7] = r(p) // ols Bt-t
			}
		}
		* main text regression
		if("`depVar'" =="first_defect") {
			mixed `depVar' `controlVars' `interestVars' `ifCond' , noconstant || id: , vce(cluster `clusterVar') 
		}
		else {
			meprobit `depVar' `controlVars' `interestVars' `ifCond' , noconstant || id: , vce(cluster `clusterVar') intpoints(`stdIntPoints')
		}
		local counter =0
		forvalues ivar1 =1/`ninterestvars' {
			local testVar1: word `ivar1' of `interestVars'
			local upper =`ivar1'+1
			forvalues ivar2 =`upper'/`ninterestvars' {
				local counter = `counter' + 1
				local testVar2: word `ivar2' of `interestVars'
				test `testVar1' = `testVar2' 
				mat `matName'[`counter', 2] = r(p) // mep CR-z
			}
		}
		* RE GLS regression
		local counter =0
		forvalues ivar1 =1/`ninterestvars' {
			local testVar1: word `ivar1' of `interestVars'
			local upper =`ivar1'+1
			forvalues ivar2 =`upper'/`ninterestvars' {
				local counter = `counter' + 1
				local testVar2: word `ivar2' of `interestVars'
				xtrClusterWildBoot , dep("`depVar'") inter("`testVar2'") ///
					cont("`ifCond' & (`testVar1' ==1 | `testVar2' ==1)") ///
					clust("`clusterVar'") ///
					basespec("tA8_`depVar'_sh`sh'_xtr`counter'") spec("tA8_`depVar'_sh`sh'_xtr`counter'") ///
					bs($BS) rseed($RSEED) debug(`debugMode')
				test `testVar2' 
				mat `matName'[`counter', 3] = r(p) // xtr CR-z
				mat `matName'[`counter', 4] = Ps_tA8_`depVar'_sh`sh'_xtr`counter'[1,2] // xtr CR-t
				mat `matName'[`counter', 5] = Ps_tA8_`depVar'_sh`sh'_xtr`counter'[1,3] // xtr Bt-t
			}
		}
	}
}
* report output block
forvalues sh =0/1 {
	foreach depVar of varlist `depVarList' {
		mat rownames Ps_`tabName'_sh`sh'_`depVar' = "D4 vs D8" "D4 vs E4" "D4 vs E8" "D8 vs E4" "D8 vs E8" "E4 vs E8"
		mat list Ps_`tabName'_sh`sh'_`depVar' , format("%8.3f")	// for log file
		if (`rewriteTexFiles' !=0) {
			esttab matrix(Ps_`tabName'_sh`sh'_`depVar' , fmt(1 2 2 2 2 2 2)) ///
				using "$tableFolder/WildBoot_Exp_`tabName'_sh`sh'_`depVar'" ///
				, `esttabMatFragment' replace
		}
	}
}
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
local statList FvL mep_CR_z xtr_CR_z xtr_CR_t xtr_Bt_t ols_CR_t ols_Bt_t
foreach var in rowlabel rowcounter `statList' {
	capture drop `var'
}
bysort combination: gen int rowcounter = _n
qui gen str rowlabel = "EFY"
foreach var in `statList' {
	qui gen `var' =.
}
mkmat length g l `statList' if rowcounter ==1 , mat(Ps_fvl_`depVar'_ols) rownames(rowlabel)
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
local matName Ps_fvl_`depVar'_ols
* difference column and ols regression
reg `depVar' `interestVars' `controlVars' , cluster(`clusterVar')
mat temp = r(table)
mat temp = temp'
forvalues ivar =1/`ninterestvars' {
	local testVar: word `ivar' of `interestVars'
	mat `matName'[`ivar', 4] = temp["`testVar'","b"]
	test `testVar'
	mat `matName'[`ivar', 9] = r(p) // ols CR-t
	boottest `testVar' , weighttype(webb) reps($BS ) seed($RSEED ) noci nograph 
	mat `matName'[`ivar', 10] = r(p) // ols Bt-t
}
* main text regression
meprobit `depVar' `interestVars' `controlVars' || id : , vce(cluster `clusterVar') intpoints(`stdIntPoints')
forvalues ivar =1/`ninterestvars' {
	local testVar: word `ivar' of `interestVars'
	test `testVar'
	mat `matName'[`ivar', 5] = r(p) // mep CR-z
}
* RE GLS regression
xtrClusterWildBoot , dep("`depVar'") inter("`interestVars'") ///
	cont("`controlVars'") ///
	clust("`clusterVar'") ///
	basespec("fvl_`depVar'_xtr") spec("fvl_`depVar'_xtr") ///
	bs($BS) rseed($RSEED) debug(`debugMode')
forvalues ivar =1/`ninterestvars' {
	local testVar: word `ivar' of `interestVars'
	test `testVar'
	mat `matName'[`ivar', 6] = r(p) // xtr CR-z
	mat `matName'[`ivar', 7] = Ps_fvl_`depVar'_xtr[`ivar',2] // xtr CR-t
	mat `matName'[`ivar', 8] = Ps_fvl_`depVar'_xtr[`ivar',3] // xtr Bt-t
}
* total row
local clusterVar session
local matName Ps_fvl_`depVar'_all_ols
mat `matName' = J(1,10,.)
mat rownames `matName' = "EFY All"
mat colnames `matName' = "length" "g" "l" "FvL" "mep_CR_z" "xtr_CR_z" "xtr_CR_t" "xtr_Bt_t" "ols_CR_t" "ols_Bt_t"
local testVar lastmatch
	* difference column and ols regression
	reg `depVar' `testVar' , cluster(`clusterVar')
	mat temp = r(table)
	mat temp = temp'
	mat `matName'[1, 4] = temp[1,1] // FvL difference
test `testVar'
	mat `matName'[1, 9] = r(p) // ols CR-t
	boottest `testVar' , weighttype(webb) reps($BS ) seed($RSEED ) noci nograph
	mat `matName'[1, 10] = r(p) // ols Bt-t
	* main text regression
	meprobit `depVar' `testVar' || id : , vce(cluster `clusterVar') intpoints(`stdIntPoints')
	test `testVar'
	mat `matName'[1, 5] = r(p) // mep CR-z
	* RE GLS regression
	xtrClusterWildBoot , dep("`depVar'") inter("`testVar'") ///
		cont(" ") ///
		clust("`clusterVar'") ///
		basespec("fvl_`depVar'_xtr_all") spec("fvl_`depVar'_xtr_all") ///
		bs($BS) rseed($RSEED) debug(`debugMode')
	test `testVar'
	mat `matName'[1, 6] = r(p) // xtr CR-z	
	mat `matName'[1, 7] = Ps_fvl_`depVar'_xtr_all[1,2] // xtr CR-t
	mat `matName'[1, 8] = Ps_fvl_`depVar'_xtr_all[1,3] // xtr Bt-t
* report output blocks
mat list Ps_fvl_`depVar'_ols , format("%8.3f") // for log file
mat list Ps_fvl_`depVar'_all_ols , format("%8.3f") // for log file
if (`rewriteTexFiles' !=0) {
	esttab matrix(Ps_fvl_`depVar' , fmt(0 2 2 2 2 2 2 2 2 2)) ///
		using "$tableFolder/WildBoot_Exp_fvl_`depVar'_ols" ///
		, `esttabMatFragment' replace
	esttab matrix(Ps_fvl_`depVar'_all , fmt(0 2 2 2 2 2 2 2 2 2)) ///
		using "$tableFolder/WildBoot_Exp_fvl_`depVar'_all_ols" ///
		, `esttabMatFragment' replace
}
restore

****
**** report all tables in one go
****

**** robustness analysis for table 3
foreach depVar of varlist coop_r1 coop_rl coop first_defect {
	mat list Ps_t3_ols_`depVar'_ols , format("%8.2f")	// for log file
	foreach breakdown in hor all {	
		mat list Ps_t3_ols_`depVar'_ols_`breakdown' , format("%8.2f")	// for log file
	}
}

**** robustness analysis for table 4
foreach sg of numlist 2 8 20 30 {
	mat list Ps_t4_ols_`sg' , format("%8.2f")	// for log file
	foreach breakdown in hor all {	
		mat list Ps_t4_ols_`sg'_`breakdown' , format("%8.2f")	// for log file
	}
}

**** robustness analysis for table A8
forvalues sh =0/1 {
	foreach depVar of varlist coop_r1 coop_rl coop first_defect {
		mat list Ps_tA8_ols_sh`sh'_`depVar' , format("%8.2f")	// for log file
	}
}

**** robustness analysis for table A5
mat list Ps_fvl_perfectthres_ols , format("%8.2f") // for log file
mat list Ps_fvl_perfectthres_all_ols , format("%8.2f") // for log file

****	
**** clean up
****
quietly adopath - "$adoFolder"
clear
estimates clear
mat drop _all
log close

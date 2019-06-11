**** set path 
global projectFolder "[path to supplementary folder]/05_supplementary" // <---- set location of supplementary materials folder

**** folder globals
do "$projectFolder/do/path/_path_Generic"

**** log file
capture log close
set more 1
log using "$logFolder/wildBoot_Meta_Complete_stata.log", replace

**** preliminaries
quietly adopath + "$adoFolder"
estimates clear
mat drop _all
cd "$projectFolder"

**** output parameters
local rewriteTexFiles =0 	// **** set !=0 to re-write tex table files ****
local esttabMatFragment "label nomtitles nonumbers eql(none) collabels(none) nolines booktabs fragment"

**** bootstrap parameters
global BS = 999				// set the number of bootstraps
global RSEED = 20170306 	// set random number seed

**** numerical optimisation parameters
local stdIntPoints 12
local moreIntPoints 30
local runLongReg 0 			// **** set !=0 to run computationally long regression

**** margin predict types
local pbtPredType "pr"
local mepPredType "mu" // requires Stata 14
local mixPredType "xb"

**** load data
use "$data/stata/efy_dat_meta_1.dta" , clear
xtset id period

**** generate additional variables
gen sizebad = l / (length - 1 + l - g)
replace sizebad = 1 if sizebad > 1
egen avg_coop = mean(coop), by(id match)
gen byte coop_r1 = coop if round == 1
gen coop_rl = coop if round == length
gen treat_match2 = treat_match * (length == 2)
gen treat_match4 = treat_match * (length == 4)
gen treat_match8 = treat_match * (length == 8)
gen treat_match10 = treat_match * (length == 10)

****
**** Table A.2: regressions on standard perspecive
****
local tabName "tableA2"
local interestVars g l length
local controlVars "coop_first treat_match2 treat_match4 treat_match8 treat_match10"
local clusterVar paper
local ninterestvars: word count `interestVars'
* first, last and average cooperation rates
local depVarList "coop_r1 coop_rl coop"
foreach depVar of varlist `depVarList' {
	local ifCond " "
	if("`depVar'" == "coop_r1") local ifCond "if round ==1"
	if("`depVar'" == "coop_rl") local ifCond "if round ==length"
	local matName Ps_`tabName'_`depVar'
	mat `matName' = J(`ninterestvars', 7, .)
	mat rownames `matName' = `interestVars'
	mat colnames `matName' = "ME_mep" "CR-t" "ME_nre" "RE-t" "ME_pbt" "CR-t" "Bt-t"
	* meprobit regression (crve-t test on marginal not cooefficient, as in main text; no boot-t tests)
	meprobit `depVar' `interestVars' `controlVars' `ifCond' || id : , vce(cluster `clusterVar') intpoints(`stdIntPoints')
	margins , predict(`mepPredType') dydx(`interestVars')
	mat temp = r(table)
	mat temp = temp'
	forvalues ivar =1/`ninterestvars' {
		local testVar: word `ivar' of `interestVars'
		mat `matName'[`ivar', 1] = temp["`testVar'", "b"]
		test `testVar'
		mat `matName'[`ivar', 2] = r(p) // crve-t test on latent coefficient not marginal, unlike in main text
	}
	* alternative meprobit regression with multiple REs
	if ("`depVar'" == "coop") { // regression with start-value problems
		if (`runLongReg' ==0) { // do not run computationally long regression and use previously estimated parameters
			mat `matName'[1,3] = -0.039
			mat `matName'[1,4] = 0.000
			mat `matName'[2,3] = -0.030
			mat `matName'[2,4] = 0.000
			mat `matName'[3,3] = -0.017
			mat `matName'[3,4] = 0.000
		}
		else {
			meprobit `depVar' `interestVars' `controlVars' `ifCond'  || paper : || session : || id : , intpoints(`stdIntPoints') startvalues(zero) startgrid // default options do not converge; start-values problems
			margins , predict(pr fixedonly) dydx(`interestVars') // paper random-effect estimates produce problems for "mu" marginal estimate
			mat temp = r(table)
			mat temp = temp'
			forvalues ivar =1/`ninterestvars' {
				local testVar: word `ivar' of `interestVars'
				mat `matName'[`ivar', 3] = temp["`testVar'", "b"]
				test `testVar'
				mat `matName'[`ivar', 4] = r(p) // crve-t test on latent coefficient not marginal
			}
		}
	}
	else {
		meprobit `depVar' `interestVars' `controlVars' `ifCond'  || paper : || session : || id : , intpoints(`stdIntPoints')
		margins , predict(pr fixedonly) dydx(`interestVars') // paper random-effect estimates produce problems for "mu" marginal estimate
		mat temp = r(table)
		mat temp = temp'
		forvalues ivar =1/`ninterestvars' {
			local testVar: word `ivar' of `interestVars'
			mat `matName'[`ivar', 3] = temp["`testVar'", "b"]
			test `testVar'
			mat `matName'[`ivar', 4] = r(p) // crve-t test on latent coefficient not marginal
		}
	}
	* probit regression
	probit `depVar' `interestVars' `controlVars' `ifCond' , cluster(`clusterVar')
	margins , predict(`pbtPredType') dydx(_all)
	mat temp = r(table)
	mat temp = temp'
	* score-based bootstrapped p-values
	forvalues ivar =1/`ninterestvars' {
		local testVar: word `ivar' of `interestVars'
		mat `matName'[`ivar', 5] = temp[`ivar', 1]
		test `testVar'
		mat `matName'[`ivar', 6] = r(p)
		boottest `testVar' , weighttype(webb) reps($BS ) seed($RSEED )
		mat `matName'[`ivar', 7] = r(p)
	}
}
* first defect
local depVar first_defect
	local ifCond "if round ==1"
	local matName Ps_`tabName'_`depVar'
	mat `matName' = J(`ninterestvars', 7, .)
	mat rownames `matName' = `interestVars'
	mat colnames `matName' = "ME_mxd" "CR-t" "ME_mre" "RE-t" "ME_ols" "CR-t" "Bt-t"
	* main regression
	mixed `depVar' `interestVars' `controlVars' `ifCond' || id : , vce(cluster `clusterVar')
	margins , predict(`mixPredType') dydx(`interestVars')
	forvalues ivar =1/`ninterestvars' {
		local testVar: word `ivar' of `interestVars'
		mat `matName'[`ivar', 1] = _b[`testVar']
		test `testVar'
		mat `matName'[`ivar', 2] = r(p)
	}
	* alternative mixed regression with multiple REs
	mixed `depVar' `interestVars' `controlVars' `ifCond'  || paper : || session : || id :
	forvalues ivar =1/`ninterestvars' {
		local testVar: word `ivar' of `interestVars'
		mat `matName'[`ivar', 3] = _b[`testVar'] // temp[`ivar', "b"]
		test `testVar'
		mat `matName'[`ivar', 4] = r(p)
	}
	* ols and cluster wild bootstrapped p-value
	reg `depVar' `interestVars' `controlVars' `ifCond' , cluster(`clusterVar')
	forvalues ivar =1/`ninterestvars' {
		local testVar: word `ivar' of `interestVars'
		mat `matName'[`ivar', 5] = _b[`testVar']
		test `testVar'
		mat `matName'[`ivar', 6] = r(p)
		boottest `testVar' , weighttype(webb) reps($BS ) seed($RSEED ) noci nograph
		mat `matName'[`ivar', 7] = r(p)
	}
* report output blocks
foreach depVar of varlist coop_r1 coop_rl coop first_defect {
	mat rownames Ps_`tabName'_`depVar' = "$ g $" "$ \ell $" "Horizon"
	mat list Ps_`tabName'_`depVar' , format("%8.3f") // for log file
	if (`rewriteTexFiles' !=0) {
		esttab matrix(Ps_`tabName'_`depVar' , fmt(2)) ///
			using "$tableFolder/WildBoot_Meta_`tabName'_`depVar'" ///
			, `esttabMatFragment' replace
	}
}
* re-order for text document
mat Ps_`tabName'_part1 = Ps_`tabName'_coop_r1 , Ps_`tabName'_coop_rl
mat rownames Ps_`tabName'_part1 = "$ g $" "$ \ell $" "Horizon"
if (`rewriteTexFiles' !=0) {
	esttab matrix(Ps_`tabName'_part1 , fmt(2)) ///
		using "$tableFolder/WildBoot_Meta_`tabName'_part1" ///
		, `esttabMatFragment' replace
}
mat Ps_`tabName'_part2 = Ps_`tabName'_coop , Ps_`tabName'_first_defect
mat rownames Ps_`tabName'_part2 = "$ g $" "$ \ell $" "Horizon"
if (`rewriteTexFiles' !=0) {
	esttab matrix(Ps_`tabName'_part2 , fmt(2)) ///
			using "$tableFolder/WildBoot_Meta_`tabName'_part2" ///
			, `esttabMatFragment' replace
}

****
**** Table A.4: determinants of round 1 cooperation
****
* keep only round 1 choices; generate previous-other's-round-1-choice variable
preserve
keep if round == 1
bysort id treatment (treat_match): gen ocoop_r1_m1 = ocoop[_n-1]
* generate match x parameter interaction terms
egen param = group(length g l)
qui summ param
local nParam  = r(max)
forvalues i =1/`nParam' {
	gen treat_match_`i' = treat_match * (param == `i')
}
* loop over the two model specifications
local tabName "tableA4"
forvalues spec =1/2 {
	* specificaion setup
	local depVar coop_r1
	local controlVars "ocoop_r1_m1 coop_first treat_match_1-treat_match_`nParam'"
	local clusterVar paper
	if (`spec' ==1) local interestVars g l length
	if (`spec' ==2) local interestVars g l length sizebad
	local ninterestvars: word count `interestVars'
	local matName Ps_`tabName'_spec`spec'
	mat `matName' = J(`ninterestvars', 7, .)
	mat rownames `matName' = `interestVars'
	mat colnames `matName' = "ME_mep" "CR-t" "ME_mre" "RE-t" "ME_pbt" "CR-t" "Bt-t"
	* main meprobit regression (REs for id plus CRVE)
	meprobit `depVar' `interestVars' `controlVars' || id : , vce(cluster `clusterVar') intpoints(`stdIntPoints')
	estimates store `tabName'_spec`spec'_mep
	margins , predict(`mepPredType') dydx(`interestVars')
	mat temp = r(table)
	mat temp = temp'
	forvalues ivar =1/`ninterestvars' {
		local testVar: word `ivar' of `interestVars'
		mat `matName'[`ivar', 1] = temp["`testVar'", "b"]
		test `testVar'
		mat `matName'[`ivar', 2] = r(p) // crve-t test on latent coefficient not marginal, unlike in main text
	}
	* alternative meprobit regression with multiple REs
	meprobit `depVar' `interestVars' `controlVars' || paper : || session : || id : , intpoints(`stdIntPoints')
	margins , predict(pr fixedonly) dydx(`interestVars') // paper random-effect estimates produce problems for "mu" marginal estimate
	mat temp = r(table)
	mat temp = temp'
	forvalues ivar =1/`ninterestvars' {
		local testVar: word `ivar' of `interestVars'
		mat `matName'[`ivar', 3] = temp["`testVar'", "b"]
		test `testVar'
		mat `matName'[`ivar', 4] = r(p) // crve-t test on latent coefficient not marginal
	}
	* probit regression
	probit `depVar' `interestVars' `controlVars' , cluster(`clusterVar')
	estimates store `tabName'_spec`spec'_pbt
	margins , predict(`pbtPredType') dydx(`interestVars')
	mat temp = r(table)
	mat temp = temp'
	* score-based bootstrapped p-values
	forvalues ivar =1/`ninterestvars' {
		local testVar: word `ivar' of `interestVars'
		mat `matName'[`ivar', 5] = temp["`testVar'", "b"]
		test `testVar'
		mat `matName'[`ivar', 6] = r(p)
		boottest `testVar' , weighttype(webb) reps($BS ) seed($RSEED )
		mat `matName'[`ivar', 7] = r(p)
	}
	* report complete output block
	if (`spec'==1) mat rownames `matName' = "$ g $" "$ \ell $" "Horizon"
	if (`spec'==2) mat rownames `matName' = "$ g $" "$ \ell $" "Horizon" "$ sizeBAD $"
	mat list `matName' , format("%8.3f") // for log file
	if (`rewriteTexFiles' !=0) {
		esttab matrix(`matName' , fmt(2)) ///
			using "$tableFolder/WildBoot_Meta_`tabName'_spec`spec'" ///
			, `esttabMatFragment' replace
	}
}
* report complete output block
mat Ps_`tabName'_spec1 = Ps_`tabName'_spec1[1..3, 1...] \ J(1, 7, .)
mat Ps_`tabName' = Ps_`tabName'_spec1 , Ps_`tabName'_spec2
mat rownames Ps_`tabName' = "$ g $" "$ \ell $" "Horizon" "$ sizeBAD $"
mat list Ps_`tabName' , format("%8.3f") // for log file
if (`rewriteTexFiles' !=0) {
	esttab matrix(Ps_`tabName' , fmt(2)) ///
		using "$tableFolder/WildBoot_Meta_`tabName'" ///
		, `esttabMatFragment' replace
}
restore

****
**** Table A.5: consistency with threshold strategies
****
* generate perfectthres and dummy_last variables
preserve
drop if treat_match > 1 & treat_match ~= maxmatch
gen treat_match_mod = treat_match
replace treat_match_mod = 999 if treat_match == maxmatch
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
keep if round ==1
keep if length>2
gen dummy_last = 0
replace dummy_last = 1 if treat_match_mod == 999
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
local paperList DB2005 AM1993 CDFR1996 FO2012 BMR2006
local nPapers: word count `paperList'
qui gen str rowlabel = " "
forvalues iter =1/`nPapers' {
	local ppr: word `iter' of `paperList'
	qui replace rowlabel = "`ppr'" if paper ==`iter'
}
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
	gen byte paraCombXlastmatch_`comb' = (combination == `comb' & dummy_last ==1)
}
* regression specification locals
local clusterVar paper
local controlVars "paraComb_2 paraComb_3 paraComb_4 paraComb_5 paraComb_6 paraComb_7 paraComb_8 paraComb_9"
local interestVars "paraCombXlastmatch_1 paraCombXlastmatch_2 paraCombXlastmatch_3 paraCombXlastmatch_4 paraCombXlastmatch_5 paraCombXlastmatch_6 paraCombXlastmatch_7 paraCombXlastmatch_8 paraCombXlastmatch_9"
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
meprobit `depVar' `interestVars' `controlVars' || paper: || session: || id : , intpoints(`stdIntPoints')
forvalues ivar =1/`ninterestvars' {
	local testVar: word `ivar' of `interestVars'
	test `testVar'
	mat `matName'[`ivar', 7] = r(p)
}
* total row
local clusterVar paper
local matName Ps_fvl_`depVar'_all
mat `matName' = J(1,7,.)
mat rownames `matName' = "Meta All"
mat colnames `matName' = "length" "g" "l" "ME" "CR_t" "BT_t" "RE_t"
	local testVar dummy_last
	* difference column
	reg `depVar' `testVar' , cluster(`clusterVar')
	mat temp = r(table)
	mat temp = temp'
	mat `matName'[1, 4] = temp[1,1]
	* meprobit and CR-t
	meprobit `depVar' `testVar' || id : ,  vce(cluster `clusterVar') intpoints(`stdIntPoints')
	test `testVar'
	mat `matName'[1, 5] = r(p)
	* probit and Bt-t
	probit `depVar' `testVar' , vce(cluster `clusterVar')
	boottest `testVar' , weighttype(webb) reps($BS ) seed($RSEED )
	mat `matName'[1, 6] = r(p)
	* multiple REs and RE-t
	meprobit `depVar' `testVar' || paper: || session : || id : , intpoints(`stdIntPoints')
	test `testVar'
	mat `matName'[1, 7] = r(p) 
* report output block
mat list Ps_fvl_`depVar' , format("%8.3f") // for log file
mat list Ps_fvl_`depVar'_all , format("%8.3f") // for log file
if (`rewriteTexFiles' !=0) {
	esttab matrix(Ps_fvl_`depVar' , fmt(0 2 2 2 2 2 2)) ///
		using "$tableFolder/WildBoot_Meta_fvl_`depVar'" ///
		, `esttabMatFragment' replace
	esttab matrix(Ps_fvl_`depVar'_all , fmt(0 2 2 2 2 2 2)) ///
		using "$tableFolder/WildBoot_Meta_fvl_`depVar'_all" ///
		, `esttabMatFragment' replace
}
restore

**** clean up
quietly adopath - "$adoFolder"
clear
estimates clear
mat drop _all
log close

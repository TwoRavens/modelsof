**** set path 
global projectFolder "[path to supplementary folder]/05_supplementary" // <---- set location of supplementary materials folder

**** folder globals
do "$projectFolder/do/path/_path_Generic"

**** log file
capture log close
set more 1
log using "$logFolder/wildBoot_Meta_OLS_Version_stata.log", replace

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
local debugMode = 0			// set to !=0 for additional debug output

**** numerical optimisation parameters
local stdIntPoints 12
local moreIntPoints 30

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
local tabName "t2_ols"
local interestVars g l length
local controlVars "coop_first treat_match2 treat_match4 treat_match8 treat_match10"
local clusterVar paper
qui egen clusnum = group(`clusterVar') // determine number of clusters
qui summ clusnum
local nClusters  = r(max)
local ndf = `nClusters'-1
qui drop clusnum
local ninterestvars: word count `interestVars'
local depVarList "coop_r1 coop_rl coop first_defect"
foreach depVar of varlist `depVarList' {
	local ifCond " "
	if("`depVar'" == "coop_r1") local ifCond "if round ==1"
	if("`depVar'" == "coop_rl") local ifCond "if round ==length"
	if("`depVar'" == "first_defect") local ifCond "if round ==1"
	local matName Ps_`tabName'_`depVar'
	mat `matName' = J(`ninterestvars', 10, .)
	mat rownames `matName' = `interestVars'	
	mat colnames `matName' = "ME_mep" "CR-z" "CR-t" "ME_xtr" "CR-z" "CR-t" "Bt-t" "ME_ols" "CR-t" "Bt-t"
	* main text regression
	if ("`depVar'" == "first_defect") {
		mixed `depVar' `interestVars' `controlVars' `ifCond' || id : , vce(cluster `clusterVar')
		margins , predict(`mixPredType') dydx(`interestVars') df(`ndf')
	}
	else {
		meprobit `depVar' `interestVars' `controlVars' `ifCond' || id : , vce(cluster `clusterVar') intpoints(`stdIntPoints')
		margins , predict(`mepPredType') dydx(`interestVars') df(`ndf')
	}
	mat temp = r(table)
	mat temp = temp'
	forvalues ivar =1/`ninterestvars' {
		local testVar: word `ivar' of `interestVars'
		mat `matName'[`ivar', 1] = temp["`testVar'", "b"] // ME
		test `testVar'
		mat `matName'[`ivar', 2] = r(p) // CR-z
		mat `matName'[`ivar', 3] = temp["`testVar'", "pvalue"] // CR-t on marginal
	}
	* RE GLS regression
	xtrClusterWildBoot , dep("`depVar'") inter("`interestVars'") ///
		cont("`controlVars'") ///
		clust("`clusterVar'") ///
		basespec("`tabName'_xtr_`depVar'") spec("`tabName'_xtr_`depVar'") ///
		bs($BS) rseed($RSEED) debug(`debugMode')
	forvalues ivar =1/`ninterestvars' {
		local testVar: word `ivar' of `interestVars'
		mat `matName'[`ivar', 4] = Ps_`tabName'_xtr_`depVar'[`ivar',1] // xtr ME
		mat `matName'[`ivar', 6] = Ps_`tabName'_xtr_`depVar'[`ivar',2] // xtr CR-t
		mat `matName'[`ivar', 7] = Ps_`tabName'_xtr_`depVar'[`ivar',3] // xtr Bt-t
		test `testVar'
		mat `matName'[`ivar', 5] = r(p) // CR-z
	}
	* OLS regression
	reg `depVar' `interestVars' `controlVars' `ifCond' , vce(cluster `clusterVar')
	forvalues ivar =1/`ninterestvars' {
		local testVar: word `ivar' of `interestVars'
		mat `matName'[`ivar', 8] = _b[`testVar'] // ME_ols
		test `testVar'
		mat `matName'[`ivar', 9] = r(p) // CR-t
		boottest `testVar' , weighttype(webb) reps($BS ) seed($RSEED ) noci nograph
		mat `matName'[`ivar', 10] = r(p) // Bt-t
	}
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
local tabName "tA4_ols"
forvalues spec =1/2 {	
	* specificaion setup
	local depVar coop_r1
	local controlVars "ocoop_r1_m1 coop_first treat_match_1-treat_match_`nParam'"
	local clusterVar paper
	qui egen clusnum = group(`clusterVar') // determine number of clusters
	qui summ clusnum
	local nClusters  = r(max)
	local ndf = `nClusters'-1
	qui drop clusnum
	if (`spec' ==1) local interestVars g l length
	if (`spec' ==2) local interestVars g l length sizebad 
	local ninterestvars: word count `interestVars'
	local matName Ps_`tabName'_spec`spec'
	mat `matName' =  J(`ninterestvars', 10, .)
	mat rownames `matName' = `interestVars'	
	mat colnames `matName' = "ME_mep" "CR-z" "CR-t" "ME_xtr" "CR-z" "CR-t" "Bt-t" "ME_ols" "CR-t" "Bt-t"
	* main text regression
	meprobit `depVar' `interestVars' `controlVars' || id : , vce(cluster `clusterVar') intpoints(`stdIntPoints')
	margins , predict(`mepPredType') dydx(`interestVars') df(`ndf')
	mat temp = r(table)
	mat temp = temp'
	forvalues ivar =1/`ninterestvars' {
		local testVar: word `ivar' of `interestVars'
		mat `matName'[`ivar', 1] = temp["`testVar'", "b"] // ME
		test `testVar'
		mat `matName'[`ivar', 2] = r(p) // CR-z
		mat `matName'[`ivar', 3] = temp["`testVar'", "pvalue"] // CR-t on marginal
	}
	* RE GLS regression
	xtrClusterWildBoot , dep("`depVar'") inter("`interestVars'") ///
		cont("`controlVars'") ///
		clust("`clusterVar'") ///
		basespec("`tabName'_xtr_spec`spec'") spec("`tabName'_xtr_spec`spec'") ///
		bs($BS) rseed($RSEED) debug(`debugMode')
	forvalues ivar =1/`ninterestvars' {
		mat `matName'[`ivar', 4] = Ps_`tabName'_xtr_spec`spec'[`ivar',1] // xtr ME
		mat `matName'[`ivar', 6] = Ps_`tabName'_xtr_spec`spec'[`ivar',2] // xtr CR-t
		mat `matName'[`ivar', 7] = Ps_`tabName'_xtr_spec`spec'[`ivar',3] // xtr Bt-t
		test `testVar'
		mat `matName'[`ivar', 5] = r(p) // CR-z
	}
	* OLS regression
	reg `depVar' `interestVars' `controlVars' , cluster(`clusterVar')
	mat `matName'_ols = J(`ninterestvars',3,.)	
	mat rownames `matName'_ols = `interestVars'	
	mat colnames `matName'_ols = "ME_ols" "CR-t" "Bt-t"
	forvalues ivar =1/`ninterestvars' {
		local testVar: word `ivar' of `interestVars'
		mat `matName'[`ivar', 8] = _b[`testVar']
		test `testVar'
		mat `matName'[`ivar', 9] = r(p)
		boottest `testVar' , weighttype(webb) reps($BS ) seed($RSEED ) noci nograph
		mat `matName'[`ivar', 10] = r(p)
	}
	* report output block
	mat list `matName' , format("%8.3f") // for log file
	if (`rewriteTexFiles' !=0) {
		esttab matrix(`matName' , fmt(2)) ///
			using "$tableFolder/WildBoot_Meta_`matName'" ///
			, `esttabMatFragment' replace
	}
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
local statList FvL mep_CR_z xtr_CR_z xtr_CR_t xtr_Bt_t ols_CR_t ols_Bt_t
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
mkmat length g l `statList' if rowcounter ==1 , mat(Ps_fvl_`depVar'_ols) rownames(rowlabel)
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
local matName Ps_fvl_`depVar'_ols
* difference column
reg `depVar' `interestVars' `controlVars' , cluster(`clusterVar')
mat temp = r(table)
mat temp = temp'
forvalues ivar =1/`ninterestvars' {
	local testVar: word `ivar' of `interestVars'
	mat `matName'[`ivar', 4] = temp["`testVar'","b"] // FvL difference
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
	test `testVar'
	mat `matName'[`ivar', 6] = r(p) // xtr CR-z
	mat `matName'[`ivar', 7] = Ps_fvl_`depVar'_xtr[`ivar',2] // xtr CR-t
	mat `matName'[`ivar', 8] = Ps_fvl_`depVar'_xtr[`ivar',3] // xtr Bt-t
}
* total row
local clusterVar paper
local matName Ps_fvl_`depVar'_all_ols
mat `matName' = J(1,10,.)
mat rownames `matName' = "Meta All"
mat colnames `matName' = "length" "g" "l" "FvL" "mep_CR_z" "xtr_CR_z" "xtr_CR_t" "xtr_Bt_t" "ols_CR_t" "ols_Bt_t"
	local testVar dummy_last
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
	mat `matName'[1, 7] = Ps_fvl_`depVar'_xtr_all[1,2] // xtr CR-t
	mat `matName'[1, 8] = Ps_fvl_`depVar'_xtr_all[1,3] // xtr Bt-t
	test `testVar'
	mat `matName'[1, 6] = r(p) // xtr CR-z
* report output blocks
mat list Ps_fvl_`depVar'_ols , format("%8.3f") // for log file
mat list Ps_fvl_`depVar'_all_ols , format("%8.3f") // for log file
if (`rewriteTexFiles' !=0) {
	esttab matrix(Ps_fvl_`depVar' , fmt(0 2 2 2 2 2 2 2 2 2)) ///
		using "$tableFolder/WildBoot_Meta_fvl_`depVar'_ols" ///
		, `esttabMatFragment' replace
	esttab matrix(Ps_fvl_`depVar'_all , fmt(0 2 2 2 2 2 2 2 2 2)) ///
		using "$tableFolder/WildBoot_Meta_fvl_`depVar'_all_ols" ///
		, `esttabMatFragment' replace
}
restore

****
**** report all tables in one go
****
   
**** robustness analysis for table A2
mat list Ps_t2_ols_coop_r1 , format("%8.2f") // for log file
mat list Ps_t2_ols_coop_rl , format("%8.2f") // for log file
mat list Ps_t2_ols_coop , format("%8.2f") // for log file
mat list Ps_t2_ols_first_defect , format("%8.2f") // for log file

**** robustness analysis for table A4
mat list Ps_tA4_ols_spec1 , format("%8.2f") // for log file
mat list Ps_tA4_ols_spec2 , format("%8.2f") // for log file

**** robustness analysis for table A5
mat list Ps_fvl_perfectthres_ols , format("%8.2f") // for log file
mat list Ps_fvl_perfectthres_all_ols , format("%8.2f") // for log file
	
**** clean up
quietly adopath - "$adoFolder"
clear
estimates clear
mat drop _all
log close

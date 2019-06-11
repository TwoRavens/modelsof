clear all
set matsize 10000
set maxvar 30000

global root = "C:\users\alwynyoung\Desktop"

*most calculations for paper CMS must be run in Stata 10 in order to reproduce authors' results

foreach paper in AFGH CC1 CC2 CL EGN HS LL IZ KN LMW S VDR A ABHOT ABS AKL AL ALO BBLP BL BM CCF CGTTTV CHKL CILS D DDK DHR DKR DR DR2 ER FG FJP FL FPPR GGY GJKM GKB KL LLLPR MMW MMW2 OT R T WDL KMP GKN GMR GRS MSV {
	local dir = "$root" + "\files\" + "`paper'"
	cd `dir'
	capture mkdir results
	capture mkdir ip
	foreach file in Replication FisherN FisherA FisherCond Fisherred OBootstrap OBootstrapA OBootstrapred Bootstrap Suest Suestred FisherSuest FisherSuestred OBootstrapSuest OBootstrapSuestred JackKnife JackKnifeA Jackknifered OJackknife {
		global reps = 10000
		capture do `file'`paper'
		}
	}

*This part of paper CMS run in Stata13 so as to calculate suest (fishercond doesn't examine regressions which must run in Stata10)

foreach paper in CMS {
	local dir = "$root" + "\files\" + "`paper'"
	cd `dir'
	capture mkdir results
	capture mkdir ip
	foreach file in Suest Suestred FisherSuest FisherSuestred OBootstrapSuest OBootstrapSuestred FisherCond {
		global reps = 10000
		capture do `file'`paper'
		}
	}

do BaseResultsCoef 
do BaseResultsReg 
do BaseResultsTable 
do Leverage 
do MultipleTesting
do Simul

**************************************************
**************************************************

*Comments on multiple testing in Introduction

*Fraction of regressions with more than 1 reported treatment measure
use results\basereg, clear
drop if repeat == 1 & paper ~= "ER"
gen I = (reportedcoef > 1)
collapse (mean) I, by(paper)
sum

*Number of reported coefficients and significant results when sig. result found in a regression
use results\basecoef, clear
merge 1:1 paper CoefNum using results\baseresultscoef, keepusing(p1) nogenerate
drop if repeat == 1 & paper ~= "ER"
keep if reportedcoef > 1
keep if select == 1
gen I = (p1 < .01)
collapse (sum) I select, by(paper RegNum) fast
drop if I == 0
collapse (mean) I select, by(paper)
sum

*Number of reported coefficients and significant results when sig. result found in a table
use results\basetable, clear
merge 1:m paper table using results\basecoef, nogenerate
merge 1:1 paper CoefNum using results\baseresultscoef, keepusing(p1) nogenerate
keep if select == 1
gen I = (p1 < .01)
collapse (sum) I select, by(paper table) fast
drop if I == 0
collapse (mean) I select, by(paper)
sum


**************************************************
**************************************************

*Table I

use results\basetable, clear
gen N = 1
collapse (sum) N, by(paper)
tab N

use results\basecoef, clear
drop if repeat == 1 
gen N = 1
collapse (sum) N select, by(paper)
*3 coefficients that appear in a "repeat" regression but are not reported elsewhere
replace select = select + 3 if paper == "ER"
replace N = N - select
tab select
tab N

*already excluded repeats
use results\Characteristics, clear
gen type = "reg" if cmd == "reg" | cmd == "areg" | cmd == "regress"
replace type = "mle" if cmd == "probit" | cmd == "logit" | cmd == "oprobit" | cmd == "ologit" | cmd == "mlogit" | cmd == "xtprobit" | cmd == "xtmixed" | cmd == "cnreg" | cmd == "intreg" | cmd == "tobit" | cmd == "xtregmle" | cmd == "cameronHet"
replace type = "other" if type == ""
replace vce = "cluster" if vce == "robust"
replace vce = "other" if vce == "brl" | vce == "jackknife" | vce == "hc3"
tab type, gen(I)
tab vce, gen(II)
collapse (mean) I*, by(paper)
sum

**************************************************
**************************************************

*Figure I

use results\JackknifeSensitivity, clear
keep paper CoefNum R5 R6 R7
replace R5 = 1 if R5 == 10
replace R6 = 0 if R6 == -1
rename R5 max
rename R6 min
rename R7 Nclobs
merge 1:1 paper CoefNum using results\baseresultscoef, keepusing(p1) nogenerate
merge 1:1 paper CoefNum using results\basecoef, keepusing(select repeat) nogenerate
keep if select == 1
drop if repeat == 1 & paper ~= "ER"
gen U = (p1 < .01 & max > .01) if p1 < .01
gen D = (p1 > .01 & min < .01) if p1 > .01
gen dif = max - min
preserve
	collapse (mean) U D dif, by(paper) fast
	sum
restore
sort p1
outsheet max min p1 using figure1a, replace
sort Nclobs
outsheet Nclobs dif using figure1b, replace


**************************************************
**************************************************

*Table II

use results\Leverage, clear
keep if select == 1
drop if repeat == 1 & paper ~= "ER"
preserve
	collapse (mean) QQ3-QQ6 QQQ3-QQQ6, by(paper)
	sum QQ*
	merge 1:1 paper using results\highlev, nogenerate
	bysort levgroup: sum QQ*
restore
preserve
	collapse (mean) QQ3-QQ6 QQQ3-QQQ6, by(paper firsttable)
	egen N = count(firsttable), by(paper)
	keep if N == 2
	bysort firsttable: sum QQ*
restore
preserve
	collapse (mean) QQ3-QQ6 QQQ3-QQQ6, by(paper interactions)
	egen N = count(interactions), by(paper)
	keep if N == 2
	bysort interactions: sum QQ*
restore

**************************************************
**************************************************

*Table III

use simul\pvalues, clear
matrix R = J(9,12,.)
local k = 0
foreach file in fixed normal chi2 {
	foreach N in 20 200 2000 {
		local k = `k' + 1
		local i = 0
		foreach spec in "" "a" {
			foreach var in p prt prc pbt pbc pjk {
				local i = `i' + 1
				quietly sum `var' if file == "`spec'`file'" & N == `N' & `var' < .05
				matrix R[`k',`i'] = r(N)/10000
				}
			}
		}
	}
matrix list R

use simul\ipvalues, clear
matrix R = J(9,12,.)
local k = 0
foreach file in ifixed inormal ichi2 {
	foreach N in 20 200 2000 {
		local k = `k' + 1
		local i = 0
		forvalues j = 1/2 {
			foreach var in p prt prc pbt pbc pjk {
				local i = `i' + 1
				capture sum `var'`j' if file == "`file'" & N == `N' & `var'`j' < .05
				if (_rc == 0) matrix R[`k',`i'] = r(N)/10000
				}
			}
		}
	}
matrix list R

**************************************************
**************************************************

*Table IV

use simul\spvalues, clear
foreach var in p prt prc pbt pbc pjk {
	gen double p`var' = `var'1
	forvalues i = 2/10 {
		quietly replace p`var' = min(p`var',`var'`i')
		}
	}
matrix R = J(9,12,.)
local k = 0
foreach file in fixed normal chi2 {
	foreach N in 20 200 2000 {
		local k = `k' + 1
		local i = 0
		foreach spec in "" "a" {
			foreach var in p prt prc pbt pbc pjk {
				local i = `i' + 1
				quietly sum p`var' if file == "`spec'`file'" & N == `N' & p`var' < .005
				matrix R[`k',`i'] = r(N)/10000
				}
			}
		}
	}
matrix list R

use simul\fsuestpvalues, clear
matrix R = J(9,12,.)
local k = 0
foreach file in fixed normal chi2 {
	foreach N in 20 200 2000 {
		local k = `k' + 1
		local i = 0
		foreach spec in "" "a" {
			foreach var in p pr prc pb pbc pjk {		
				local i = `i' + 1
				quietly sum `var' if file == "`spec'`file'" & N == `N' & `var' < .05
				matrix R[`k',`i'] = r(N)/10000
				}
			}
		}
	}
matrix list R

**************************************************
**************************************************
*Discussion of maximal leverage in Tables III and IV
foreach n in 20 200 2000 {
	drop _all
	set obs `n'
	gen x = (_n <= `n'/10)
	quietly reg x
	quietly predict e, resid
	quietly replace e = e^2
	quietly sum e
	quietly replace e = e/r(sum)
	gsort - e
	list e in 1/5
	}
use simul\ilev\ilev2000, clear
sum R5, detail

**************************************************
**************************************************

*Figure III

use simul\pvalues, clear
keep if iteration <= 1000 & (file == "normal" | file == "chi2" | file == "fixed") & (N == 20 | N == 2000)
sort N p
outsheet p prt if N == 20 using figure3a1, replace
outsheet p prt if N == 2000 using figure3a2, replace

use simul\ipvalues, clear
keep if (N == 20 | N == 2000) & iteration <= 1000
sort N p2
outsheet p2 prt2 if N == 20 using figure3b1, replace
outsheet p2 prt2 if N == 2000 using figure3b2, replace

use simul\fsuestpvalues, clear
keep if iteration <= 1000 & (file == "normal" | file == "chi2" | file == "fixed") & (N == 20 | N == 2000)
sort N p
outsheet p pr if N == 20 using figure3c1, replace
outsheet p pr if N == 2000 using figure3c2, replace

use simul\hipvalues, clear
*size
sum p1 if p1 <= .05 & N == 20
sum p1 if p1 <= .05 & N == 2000
sum prt1 if prt1 <= .05 & N == 20
sum prt1 if prt1 <= .05 & N == 2000
matrix size = (1444,2409,1524,1529)/30000
matrix list size
keep if iteration <= 1000 
sort N p1
outsheet p1 prt1 if N == 20 using figure3d1, replace
outsheet p1 prt1 if N == 2000 using figure3d2, replace

**************************************************
**************************************************

*Table V - Significance of Results at Coefficient Level - reported coefficients
use results\BaseResultsCoef, clear
keep p1 prc prt pbc pbt pjk paper CoefNum
foreach var in p1 prc prt pbc pbt pjk {
	gen I`var'1 = (`var' < .01)
	gen I`var'5 = (`var' < .05)
	}
merge 1:1 paper CoefNum using results\basecoef, keepusing(repeat select firsttable interactions) nogenerate
keep if select == 1
drop if repeat == 1 & paper ~= "ER"
preserve
	collapse (mean) I*, by(paper) fast
	merge 1:1 paper using results\HighLev, keepusing(levgroup) nogenerate
	mata R = J(4,8,.)
	local j = 1
	foreach spec in "~=." "==1" "==2" "==3" {
		local i = 1
		foreach var in p1 prt pbt pjk {
			sum I`var'1 if levgroup `spec'
			mata R[`i',`j'] = `r(mean)'
			sum I`var'5 if levgroup `spec'
			mata R[`i',`j'+1] = `r(mean)'
			local i = `i' + 1
			}
		local j = `j' + 2
		}
restore
	mata R[2..4,1...] = R[2..4,1...]:/R[1,1...]; R
preserve
	collapse (mean) I*, by(paper firsttable) fast
	egen N = count(firsttable), by(paper)
	keep if N == 2
	mata R = J(4,8,.)
	local j = 1
	foreach spec in "==1" "==0" {
		local i = 1
		foreach var in p1 prt pbt pjk  {
			sum I`var'1 if firsttable `spec'
			mata R[`i',`j'] = `r(mean)'
			quietly sum I`var'5 if firsttable `spec'
			mata R[`i',`j'+1] = `r(mean)'
			local i = `i' + 1
			}
		local j = `j' + 2
		}
restore
preserve
	collapse (mean) I*, by(paper interactions) fast
	egen N = count(interactions), by(paper)
	keep if N == 2
	foreach spec in "==1" "==0" {
		local i = 1
		foreach var in p1 prt pbt pjk {
			sum I`var'1 if interactions `spec'
			mata R[`i',`j'] = `r(mean)'
			quietly sum I`var'5 if interactions `spec'
			mata R[`i',`j'+1] = `r(mean)'
			local i = `i' + 1
			}
		local j = `j' + 2
		}
restore
	mata R[2..4,1...] = R[2..4,1...]:/R[1,1...]; R

**************************************************
**************************************************

*Table VI - Significance of Results at Regression Level - reported coefficients
use results\BaseResultsCoef, clear
keep paper CoefNum p1
merge 1:1 paper CoefNum using results\basecoef, keepusing(RegNum select) nogenerate
keep if select == 1
collapse (min) p1 (count) N = p1, by(paper RegNum) fast
merge 1:1 paper RegNum using results\BaseResultsReg, keepusing(Fred* f*red) nogenerate
merge 1:1 paper RegNum using results\BaseReg, keepusing(repeat firsttable) nogenerate
merge m:1 paper using results\Highlev, keepusing(levgroup) nogenerate
keep if N > 1 & repeat == 0
foreach var in p1 fred frwred fbwred fjkred {
	gen I`var'1 = (`var' < .01)
	gen I`var'5 = (`var' < .05)
	}
preserve
	collapse (mean) I* levgroup, by(paper) fast
	mata R = J(5,12,.)
	local j = 1
	foreach spec in "~=." "==1" "==2" "==3" {
		local i = 1
		foreach var in p1 fred frwred fbwred fjkred {
			sum I`var'1 if levgroup `spec'
			mata R[`i',`j'] = `r(mean)'
			sum I`var'5 if levgroup `spec'
			mata R[`i',`j'+1] = `r(mean)'
			local i = `i' + 1
			}
		local j = `j' + 2
		}
restore
preserve
	collapse (mean) I*, by(paper firsttable) fast
	egen N = count(firsttable), by(paper)
	keep if N == 2
	foreach spec in "==1" "==0" {
		local i = 1
		foreach var in p1 fred frwred fbwred fjkred {
			sum I`var'1 if firsttable `spec'
			mata R[`i',`j'] = `r(mean)'
			quietly sum I`var'5 if firsttable `spec'
			mata R[`i',`j'+1] = `r(mean)'
			local i = `i' + 1
			}
		local j = `j' + 2
		}
restore
	mata R[3..5,1...] = R[3..5,1...]:/R[2,1...]; R

use results\BHReg, clear
keep if reportedcoef > 1
keep *red paper RegNum reportedcoef
merge m:1 paper using results\HighLev, keepusing(levgroup) keep(match) nogenerate
merge 1:1 paper RegNum using results\BaseReg, keepusing(repeat firsttable) keep(match) nogenerate
foreach var in p1red prtred pbtred pjkred {
	gen I`var'1 = (`var' < .01)
	gen I`var'5 = (`var' < .05)
	}
preserve
	collapse (mean) I* levgroup, by(paper) fast
	mata R = J(6,12,.)
	local j = 1
	foreach spec in "~=." "==1" "==2" "==3" {
		local i = 1
		foreach var in p1red prtred pbtred pjkred {
			sum I`var'1 if levgroup `spec'
			mata R[`i',`j'] = `r(mean)'
			sum I`var'5 if levgroup `spec'
			mata R[`i',`j'+1] = `r(mean)'
			local i = `i' + 1
			}
		local j = `j' + 2
		}
restore
preserve
	collapse (mean) I*, by(paper firsttable) fast
	egen N = count(firsttable), by(paper)
	keep if N == 2
	foreach spec in "==1" "==0" {
		local i = 1
		foreach var in p1red prtred pbtred pjkred {
			sum I`var'1 if firsttable `spec'
			mata R[`i',`j'] = `r(mean)'
			quietly sum I`var'5 if firsttable `spec'
			mata R[`i',`j'+1] = `r(mean)'
			local i = `i' + 1
			}
		local j = `j' + 2
		}
restore

use results\WYReg, clear
merge 1:1 paper RegNum using results\basereg, keepusing(repeat firsttable) nogenerate
merge m:1 paper using results\HighLev, keepusing(levgroup) nogenerate
keep if Nred > 1 & repeat == 0
foreach var in SigRtred SigBtred {
	gen I`var'1 = (`var'3 < .01)
	gen I`var'5 = (`var'3 < .05)
	}
preserve
	collapse (mean) I* levgroup, by(paper) fast
	local j = 1
	foreach spec in "~=." "==1" "==2" "==3" {
		local i = 5
		foreach var in SigRtred SigBtred {
			sum I`var'1 if levgroup `spec'
			mata R[`i',`j'] = `r(mean)'
			sum I`var'5 if levgroup `spec'
			mata R[`i',`j'+1] = `r(mean)'
			local i = `i' + 1
			}
		local j = `j' + 2
		}
restore
preserve
	collapse (mean) I*, by(paper firsttable) fast
	egen N = count(firsttable), by(paper)
	keep if N == 2
	foreach spec in "==1" "==0" {
		local i = 5
		foreach var in SigRtred SigBtred {
			sum I`var'1 if firsttable `spec'
			mata R[`i',`j'] = `r(mean)'
			quietly sum I`var'5 if firsttable `spec'
			mata R[`i',`j'+1] = `r(mean)'
			local i = `i' + 1
			}
		local j = `j' + 2
		}
restore
	mata R[2..6,1...] = R[2..6,1...]:/R[1,1...]; R

**************************************************
**************************************************
*Text discussion, number of reportedcoefs & change in z-value cutoffs on axes for Table VI
use results\BHReg, clear
keep if reportedcoef > 1
merge 1:1 paper RegNum using results\baseresultsreg, keepusing(Fred3) keep(match) nogenerate
gen ztail1 = sqrt(invFtail(1,Fred3,.01))
gen ztail2 = sqrt(invFtail(1,Fred3,.01/reportedcoef))
gen ztail3 = sqrt(reportedcoef*invFtail(reportedcoef,Fred3,.01))
replace ztail1 = sqrt(invchi2tail(1,.01)) if Fred3 == .
replace ztail2 = sqrt(invchi2tail(1,.01/reportedcoef)) if Fred3 == .
replace ztail3 = sqrt(invchi2tail(reportedcoef,.01)) if Fred3 == .
collapse (mean) zt* reported, by(paper) fast
sum 
sum rep, detail
**************************************************
**************************************************
*Same information for tables, discussed later 
*in some cases suest drops some coefficients, so adjust for this in calculations of critical values
use results\basecoef, clear
collapse (sum) select suestselectred, by(paper table) fast
*range of reported coefficients in tables
sum select
gen double ztail1 = sqrt(invchi2tail(1,.01)) 
gen double ztail2 = sqrt(invchi2tail(1,.01/select)) 
gen double ztail3 = sqrt(invchi2tail(suestselectred,.01))
collapse (mean) zt* select suestselectred, by(paper) fast
*adjustment of z-cutoffs bonferroni to wald
sum 
*average number tested
sum select, detail
**************************************************
**************************************************
*Footnote on collinear regressions in tables - discussed later
use results\baseresultstable, clear
merge 1:1 paper table using results\basetable, nogenerate
*Exclude cases where coef > clusters
gen I = 1 if paper == "S"
replace I = 1 if paper == "BL" & table == 4
replace I = 1 if paper == "AL" & table == 7
replace I = 1 if paper == "CGTTTV" & table >= 6 & table <= 7
gen dif = repcoeftable - Fred3 if I ~= 1
*correcting cases where could not test all coefficients because no mle formulation
replace dif = 0 if paper == "ALO" & table == 7
replace dif = 0 if paper == "ABS" & table == 103
replace dif = 0 if paper == "GKN" & table == 4
drop if dif == .
preserve
	gen II = (dif > 0)
	collapse (mean) II, by(paper)
	sum 
restore
preserve
	drop if dif == 0
	replace dif = dif/repcoeftable
	collapse (mean) dif, by(paper)
	sum
restore
**************************************************
**************************************************

*Table VII - Significance of Results at Table Level - reported coefficients
use results\BaseResultsCoef, clear
keep paper CoefNum p1
merge 1:1 paper CoefNum using results\basecoef, keepusing(table suestselectred) nogenerate
keep if suestselectred == 1
collapse (min) p1 (count) N = p1, by(paper table) fast
merge 1:1 paper table using results\basetable, keepusing(firsttable) nogenerate
merge 1:1 paper table using results\BaseResultsTable, keepusing(p*) nogenerate
merge m:1 paper using results\Highlev, keepusing(levgroup) nogenerate
foreach var in p1 pred prwred pbwred pjkred {
	gen I`var'1 = (`var' < .01) if `var' ~= .
	gen I`var'5 = (`var' < .05) if `var' ~= .
	}
mata R = J(4,12,.); RR = J(4,12,.)
local i = 0
foreach var in p1 prwred pbwred pjkred {
	local i = `i' + 1
	preserve
	quietly drop if `var' == .
	collapse (mean) Ipred1 Ipred5 I`var'* levgroup, by(paper) fast
	local j = 1
	foreach spec in "~=." "==1" "==2" "==3" {
		sum I`var'1 if levgroup `spec'
		mata R[`i',`j'] = `r(mean)'
		sum I`var'5 if levgroup `spec'
		mata R[`i',`j'+1] = `r(mean)'
		sum Ipred1 if levgroup `spec'
		mata RR[`i',`j'] =`r(mean)'
		sum Ipred5 if levgroup `spec'
		mata RR[`i',`j'+1] =`r(mean)'
		local j = `j' + 2
		}
	restore
	}
local i = 0
foreach var in p1 prwred pbwred pjkred {
	local i = `i' + 1
	preserve
	quietly drop if `var' == .
	collapse (mean) Ipred1 Ipred5 I`var'* levgroup, by(paper firsttable) fast
	egen N = count(firsttable), by(paper)
	keep if N == 2
	local j = 9
	foreach spec in "==1" "==0" {
		sum I`var'1 if firsttable `spec'
		mata R[`i',`j'] = `r(mean)'
		sum I`var'5 if firsttable `spec'
		mata R[`i',`j'+1] = `r(mean)'
		sum Ipred1 if firsttable `spec'
		mata RR[`i',`j'] =`r(mean)'
		sum Ipred5 if firsttable `spec'
		mata RR[`i',`j'+1] =`r(mean)'
		local j = `j' + 2
		}
	restore
	}

mata R; R[2..4,1...] = R[2..4,1...]:/RR[2..4,1...]; R; RR
mata RRR = R[1,1...] \ RR[1,1...] \ R[2..4,1...]; RRR

use results\BHTable, clear
keep *red paper table
merge m:1 paper using results\HighLev, keepusing(levgroup) nogenerate
merge 1:1 paper table using results\basetable, keepusing(firsttable) nogenerate
foreach var in p1red prtred pbtred pjkred {
	gen I`var'1 = (`var' < .01)
	gen I`var'5 = (`var' < .05)
	}
preserve
	collapse (mean) I* levgroup, by(paper) fast
	mata R = J(6,12,.)
	local j = 1
	foreach spec in "~=." "==1" "==2" "==3" {
		local i = 1
		foreach var in p1red prtred pbtred pjkred {
			sum I`var'1 if levgroup `spec'
			mata R[`i',`j'] = `r(mean)'
			sum I`var'5 if levgroup `spec'
			mata R[`i',`j'+1] = `r(mean)'
			local i = `i' + 1
			}
		local j = `j' + 2
		}
restore
preserve
	collapse (mean) I*, by(paper firsttable) fast
	egen N = count(firsttable), by(paper)
	keep if N == 2
	foreach spec in "==1" "==0" {
		local i = 1
		foreach var in p1red prtred pbtred pjkred {
			sum I`var'1 if firsttable `spec'
			mata R[`i',`j'] = `r(mean)'
			quietly sum I`var'5 if firsttable `spec'
			mata R[`i',`j'+1] = `r(mean)'
			local i = `i' + 1
			}
		local j = `j' + 2
		}
restore

use results\WYTable, clear
merge m:1 paper using results\HighLev, keepusing(levgroup) nogenerate
merge 1:1 paper table using results\basetable, keepusing(firsttable) nogenerate
foreach var in SigRtred SigBtred {
	gen I`var'1 = (`var'3 < .01)
	gen I`var'5 = (`var'3 < .05)
	}
preserve
	collapse (mean) I* levgroup, by(paper) fast
	local j = 1
	foreach spec in "~=." "==1" "==2" "==3" {
		local i = 5
		foreach var in SigRtred SigBtred {
			sum I`var'1 if levgroup `spec'
			mata R[`i',`j'] = `r(mean)'
			sum I`var'5 if levgroup `spec'
			mata R[`i',`j'+1] = `r(mean)'
			local i = `i' + 1
			}
		local j = `j' + 2
		}
restore
preserve
	collapse (mean) I*, by(paper firsttable) fast
	egen N = count(firsttable), by(paper)
	keep if N == 2
	foreach spec in "==1" "==0" {
		local i = 5
		foreach var in SigRtred SigBtred {
			sum I`var'1 if firsttable `spec'
			mata R[`i',`j'] = `r(mean)'
			quietly sum I`var'5 if firsttable `spec'
			mata R[`i',`j'+1] = `r(mean)'
			local i = `i' + 1
			}
		local j = `j' + 2
		}
restore
	mata R; R[2..6,1...] = R[2..6,1...]:/R[1,1...]; R

**************************************************
**************************************************

*Table VIII - How much do pvalues change

use results\BaseResultsCoef, clear
keep p1 prt CoefNum paper
merge 1:1 paper CoefNum using results\basecoef, keepusing(repeat select) nogenerate
keep if select == 1
drop if repeat == 1 & paper ~= "ER"
foreach level in 1 5 {
	preserve
	keep if p1 < `level'/100
	gen I1 = (prt < .01)
	gen I5 = (prt < .05 & prt >= .01)
	gen I10 = (prt < .1 & prt >= .05)
	gen I20 = (prt < .2 & prt >= .1)
	gen I20p = (prt > .2 & prt ~= .)
	collapse (mean) I*, by(paper)
	sum I*
	restore
	}

use results\BaseResultsReg, clear
keep fred frwred paper RegNum
merge 1:1 paper RegNum using results\basereg, keepusing(repeat reportedcoef) nogenerate
keep if reportedcoef > 1 & repeat == 0
foreach level in 1 5 {
	preserve
	keep if fred < `level'/100
	gen I1 = (frwred < .01)
	gen I5 = (frwred < .05 & frwred >= .01)
	gen I10 = (frwred < .1 & frwred >= .05)
	gen I20 = (frwred < .2 & frwred >= .1)
	gen I20p = (frwred > .2 & frwred ~= .)
	collapse (mean) I*, by(paper)
	sum I*
	restore
	}

use results\BHReg, clear
keep p1red prtred paper
drop if p1red == .
foreach level in 1 5 {
	preserve
	keep if p1red < `level'/100
	gen I1 = (prtred < .01)
	gen I5 = (prtred < .05 & prtred >= .01)
	gen I10 = (prtred < .1 & prtred >= .05)
	gen I20 = (prtred < .2 & prtred >= .1)
	gen I20p = (prtred > .2 & prtred ~= .)
	collapse (mean) I*, by(paper)
	sum I*
	restore
	}

use results\BaseResultsTable, clear
keep pred prwred paper
foreach level in 1 5 {
	preserve
	keep if pred < `level'/100
	gen I1 = (prwred < .01)
	gen I5 = (prwred < .05 & prwred >= .01)
	gen I10 = (prwred < .1 & prwred >= .05)
	gen I20 = (prwred < .2 & prwred >= .1)
	gen I20p = (prwred > .2 & prwred ~= .)
	collapse (mean) I*, by(paper)
	sum I*
	restore
	}

use results\BHTable, clear
keep p1red prtred paper
foreach level in 1 5 {
	preserve
	keep if p1red < `level'/100
	gen I1 = (prtred < .01)
	gen I5 = (prtred < .05 & prtred >= .01)
	gen I10 = (prtred < .1 & prtred >= .05)
	gen I20 = (prtred < .2 & prtred >= .1)
	gen I20p = (prtred > .2 & prtred ~= .)
	collapse (mean) I*, by(paper)
	sum I*
	restore
	}

*Text in paper about effect of clustering level
use results\BaseResultsCoef, clear
keep p1 palt1 prt prtalt CoefNum paper
merge 1:1 paper CoefNum using results\basecoef, keepusing(repeat select) nogenerate
keep if select == 1 & prtalt ~= .
foreach level in 1 5 {
	preserve
	keep if p1 < `level'/100
	gen I1 = (prt < .01)
	gen I5 = (prt < .05 & prt >= .01)
	gen I10 = (prt < .1 & prt >= .05)
	gen I20 = (prt < .2 & prt >= .1)
	gen I20p = (prt > .2 & prt ~= .)
	collapse (mean) I*, by(paper)
	sum I*
	restore
	}
foreach level in 1 5 {
	preserve
	keep if palt1 < `level'/100
	gen I1 = (prtalt < .01)
	gen I5 = (prtalt < .05 & prtalt >= .01)
	gen I10 = (prtalt < .1 & prtalt >= .05)
	gen I20 = (prtalt < .2 & prtalt >= .1)
	gen I20p = (prtalt > .2 & prtalt ~= .)
	collapse (mean) I*, by(paper)
	sum I*
	restore
	}

********************************************************
********************************************************

*Figure IV

use results\baseresultscoef, clear
merge 1:1 paper CoefNum using results\basecoef, keepusing(select repeat) nogenerate
keep if select == 1
drop if repeat == 1 & paper ~= "ER"
sort p1
outsheet p1 prt using figureIVa, replace

use results\baseresultsreg, clear
merge 1:1 paper RegNum using results\BaseReg, keepusing(repeat reportedcoef) nogenerate
keep if reportedcoef > 1
keep if repeat == 0
sort fred
outsheet fred frwred using figureIVb, replace

use results\BHReg, clear
merge 1:1 paper RegNum using results\BaseReg, keepusing(repeat reportedcoef) keep(match) nogenerate
keep if reportedcoef > 1
keep if repeat == 0
sort p1red
replace p1red = 1 if p1red > 1
replace prtred = 1 if prtred > 1
outsheet p1red prtred using figureIVc, replace

use results\baseresultstable, clear
sort pred
outsheet pred prwred using figureIVd, replace

use results\BHTable, clear
sort p1red
replace p1red = 1 if p1red > 1
replace prtred = 1 if prtred > 1
outsheet p1red prtred using figureIVe, replace






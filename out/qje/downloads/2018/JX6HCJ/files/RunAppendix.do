*Appendix Table V - Significance of Results at Coefficient Level - reported treatment effects
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
	mata R = J(6,8,.)
	local j = 1
	foreach spec in "~=." "==1" "==2" "==3" {
		local i = 1
		foreach var in p1 prt pbt pjk prc pbc {
			sum I`var'1 if levgroup `spec'
			mata R[`i',`j'] = `r(mean)'
			sum I`var'5 if levgroup `spec'
			mata R[`i',`j'+1] = `r(mean)'
			local i = `i' + 1
			}
		local j = `j' + 2
		}
restore
	mata R[2..6,1...] = R[2..6,1...]:/R[1,1...]; R
preserve
	collapse (mean) I*, by(paper firsttable) fast
	egen N = count(firsttable), by(paper)
	keep if N == 2
	mata R = J(6,8,.)
	local j = 1
	foreach spec in "==1" "==0" {
		local i = 1
		foreach var in p1 prt pbt pjk prc pbc {
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
		foreach var in p1 prt pbt pjk prc pbc {
			sum I`var'1 if interactions `spec'
			mata R[`i',`j'] = `r(mean)'
			quietly sum I`var'5 if interactions `spec'
			mata R[`i',`j'+1] = `r(mean)'
			local i = `i' + 1
			}
		local j = `j' + 2
		}
restore
	mata R[2..6,1...] = R[2..6,1...]:/R[1,1...]; R

*Appendix Table V - Significance of Results at Coefficient Level - all treatment effects
use results\BaseResultsCoef, clear
keep p1 prc prt pbc pbt pjk paper CoefNum
foreach var in p1 prc prt pbc pbt pjk {
	gen I`var'1 = (`var' < .01)
	gen I`var'5 = (`var' < .05)
	}
merge 1:1 paper CoefNum using results\basecoef, keepusing(repeat select firsttable interactions) nogenerate
drop if repeat == 1 
preserve
	collapse (mean) I*, by(paper) fast
	merge 1:1 paper using results\HighLev, keepusing(levgroup) nogenerate
	mata R = J(6,8,.)
	local j = 1
	foreach spec in "~=." "==1" "==2" "==3" {
		local i = 1
		foreach var in p1 prt pbt pjk prc pbc {
			sum I`var'1 if levgroup `spec'
			mata R[`i',`j'] = `r(mean)'
			sum I`var'5 if levgroup `spec'
			mata R[`i',`j'+1] = `r(mean)'
			local i = `i' + 1
			}
		local j = `j' + 2
		}
restore
	mata R[2..6,1...] = R[2..6,1...]:/R[1,1...]; R
preserve
	collapse (mean) I*, by(paper firsttable) fast
	egen N = count(firsttable), by(paper)
	keep if N == 2
	mata R = J(6,8,.)
	local j = 1
	foreach spec in "==1" "==0" {
		local i = 1
		foreach var in p1 prt pbt pjk prc pbc {
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
		foreach var in p1 prt pbt pjk prc pbc {
			sum I`var'1 if interactions `spec'
			mata R[`i',`j'] = `r(mean)'
			quietly sum I`var'5 if interactions `spec'
			mata R[`i',`j'+1] = `r(mean)'
			local i = `i' + 1
			}
		local j = `j' + 2
		}
restore
	mata R[2..6,1...] = R[2..6,1...]:/R[1,1...]; R

*********************************************************************
**********************************************************************

*Appendix Table VI - Significance of Results at Regression Level - reported coefficients
use results\BaseResultsCoef, clear
keep paper CoefNum p1
merge 1:1 paper CoefNum using results\basecoef, keepusing(RegNum select) nogenerate
keep if select == 1
collapse (min) p1 (count) N = p1, by(paper RegNum) fast
merge 1:1 paper RegNum using results\BaseResultsReg, keepusing(Fred* f*red) nogenerate
merge 1:1 paper RegNum using results\BaseReg, keepusing(repeat firsttable) nogenerate
merge m:1 paper using results\Highlev, keepusing(levgroup) nogenerate
keep if N > 1 & repeat == 0
foreach var in p1 fred frwred frcred fbwred fbcred fjkred {
	gen I`var'1 = (`var' < .01)
	gen I`var'5 = (`var' < .05)
	}
preserve
	collapse (mean) I* levgroup, by(paper) fast
	mata R = J(7,12,.)
	local j = 1
	foreach spec in "~=." "==1" "==2" "==3" {
		local i = 1
		foreach var in p1 fred frwred fbwred fjkred frcred fbcred {
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
		foreach var in p1 fred frwred fbwred fjkred frcred fbcred {
			sum I`var'1 if firsttable `spec'
			mata R[`i',`j'] = `r(mean)'
			quietly sum I`var'5 if firsttable `spec'
			mata R[`i',`j'+1] = `r(mean)'
			local i = `i' + 1
			}
		local j = `j' + 2
		}
restore
	mata R[3..7,1...] = R[3..7,1...]:/R[2,1...]; R

use results\BHReg, clear
keep if reportedcoef > 1
keep *red paper RegNum reportedcoef
merge m:1 paper using results\HighLev, keepusing(levgroup) keep(match) nogenerate
merge 1:1 paper RegNum using results\BaseReg, keepusing(repeat firsttable) keep(match) nogenerate
foreach var in p1red prtred pbtred pjkred prcred pbcred {
	gen I`var'1 = (`var' < .01)
	gen I`var'5 = (`var' < .05)
	}
preserve
	collapse (mean) I* levgroup, by(paper) fast
	mata R = J(10,12,.)
	local j = 1
	foreach spec in "~=." "==1" "==2" "==3" {
		local i = 1
		foreach var in p1red prtred pbtred pjkred prcred pbcred {
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
		foreach var in p1red prtred pbtred pjkred prcred pbcred {
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
foreach var in SigRtred SigBtred SigRcred SigBcred {
	gen I`var'1 = (`var'3 < .01)
	gen I`var'5 = (`var'3 < .05)
	}
preserve
	collapse (mean) I* levgroup, by(paper) fast
	local j = 1
	foreach spec in "~=." "==1" "==2" "==3" {
		local i = 7
		foreach var in SigRtred SigBtred SigRcred SigBcred {
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
		local i = 7
		foreach var in SigRtred SigBtred SigRcred SigBcred {
			sum I`var'1 if firsttable `spec'
			mata R[`i',`j'] = `r(mean)'
			quietly sum I`var'5 if firsttable `spec'
			mata R[`i',`j'+1] = `r(mean)'
			local i = `i' + 1
			}
		local j = `j' + 2
		}
restore
	mata R[2..10,1...] = R[2..10,1...]:/R[1,1...]; R



*Appendix Table VI - Significance of Results at Regression Level - all coefficients 
use results\BaseResultsCoef, clear
keep paper CoefNum p1
merge 1:1 paper CoefNum using results\basecoef, keepusing(RegNum) nogenerate
collapse (min) p1 (count) N = p1, by(paper RegNum) fast
merge 1:1 paper RegNum using results\BaseResultsReg, keepusing(F* f*) nogenerate
merge 1:1 paper RegNum using results\BaseReg, keepusing(repeat firsttable) nogenerate
merge m:1 paper using results\Highlev, keepusing(levgroup) nogenerate
keep if N > 1 & repeat == 0
foreach var in p1 f frw frc fbw fbc fjk {
	gen I`var'1 = (`var' < .01)
	gen I`var'5 = (`var' < .05)
	}
preserve
	collapse (mean) I* levgroup, by(paper) fast
	mata R = J(7,12,.)
	local j = 1
	foreach spec in "~=." "==1" "==2" "==3" {
		local i = 1
		foreach var in p1 f frw fbw fjk frc fbc {
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
		foreach var in p1 f frw fbw fjk frc fbc {
			sum I`var'1 if firsttable `spec'
			mata R[`i',`j'] = `r(mean)'
			quietly sum I`var'5 if firsttable `spec'
			mata R[`i',`j'+1] = `r(mean)'
			local i = `i' + 1
			}
		local j = `j' + 2
		}
restore
	mata R[3..7,1...] = R[3..7,1...]:/R[2,1...]; R

use results\BHReg, clear
keep if numbercoefreg > 1
merge m:1 paper using results\HighLev, keepusing(levgroup) keep(match) nogenerate
merge 1:1 paper RegNum using results\BaseReg, keepusing(repeat firsttable) keep(match) nogenerate
tab repeat
foreach var in p1 prt pbt pjk prc pbc {
	gen I`var'1 = (`var' < .01)
	gen I`var'5 = (`var' < .05)
	}
preserve
	collapse (mean) I* levgroup, by(paper) fast
	mata R = J(10,12,.)
	local j = 1
	foreach spec in "~=." "==1" "==2" "==3" {
		local i = 1
		foreach var in p1 prt pbt pjk prc pbc {
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
		foreach var in p1 prt pbt pjk prc pbc {
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
keep if N > 1 & repeat == 0
foreach var in SigRt SigBt SigRc SigBc {
	gen I`var'1 = (`var'3 < .01)
	gen I`var'5 = (`var'3 < .05)
	}
preserve
	collapse (mean) I* levgroup, by(paper) fast
	local j = 1
	foreach spec in "~=." "==1" "==2" "==3" {
		local i = 7
		foreach var in SigRt SigBt SigRc SigBc {
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
		local i = 7
		foreach var in SigRt SigBt SigRc SigBc {
			sum I`var'1 if firsttable `spec'
			mata R[`i',`j'] = `r(mean)'
			quietly sum I`var'5 if firsttable `spec'
			mata R[`i',`j'+1] = `r(mean)'
			local i = `i' + 1
			}
		local j = `j' + 2
		}
restore
	mata R[2..10,1...] = R[2..10,1...]:/R[1,1...]; R


**********************************************************************
**********************************************************************

*Appendix Table VII - Significance of Results at Table Level - reported coefficients
use results\BaseResultsCoef, clear
keep paper CoefNum p1
merge 1:1 paper CoefNum using results\basecoef, keepusing(table suestselectred) nogenerate
keep if suestselectred == 1
collapse (min) p1 (count) N = p1, by(paper table) fast
merge 1:1 paper table using results\basetable, keepusing(firsttable) nogenerate
merge 1:1 paper table using results\BaseResultsTable, keepusing(p*) nogenerate
merge m:1 paper using results\Highlev, keepusing(levgroup) nogenerate
foreach var in p1 pred prwred pbwred pjkred prcred pbcred {
	gen I`var'1 = (`var' < .01) if `var' ~= .
	gen I`var'5 = (`var' < .05) if `var' ~= .
	}
mata R = J(6,12,.); RR = J(6,12,.)
local i = 0
foreach var in p1 prwred pbwred pjkred prcred pbcred {
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
foreach var in p1 prwred pbwred pjkred prcred pbcred {
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

mata R; R[2..6,1...] = R[2..6,1...]:/RR[2..6,1...]; R; RR
mata RRR = R[1,1...] \ RR[2,1...] \ R[2..6,1...]; RRR

use results\BHTable, clear
keep *red paper table
merge m:1 paper using results\HighLev, keepusing(levgroup) nogenerate
merge 1:1 paper table using results\basetable, keepusing(firsttable) nogenerate
foreach var in p1red prtred pbtred pjkred prcred pbcred {
	gen I`var'1 = (`var' < .01)
	gen I`var'5 = (`var' < .05)
	}
preserve
	collapse (mean) I* levgroup, by(paper) fast
	mata R = J(10,12,.)
	local j = 1
	foreach spec in "~=." "==1" "==2" "==3" {
		local i = 1
		foreach var in p1red prtred pbtred pjkred prcred pbcred {
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
		foreach var in p1red prtred pbtred pjkred prcred pbcred {
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
foreach var in SigRtred SigBtred SigRcred SigBcred {
	gen I`var'1 = (`var'3 < .01)
	gen I`var'5 = (`var'3 < .05)
	}
preserve
	collapse (mean) I* levgroup, by(paper) fast
	local j = 1
	foreach spec in "~=." "==1" "==2" "==3" {
		local i = 7
		foreach var in SigRtred SigBtred SigRcred SigBcred {
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
		local i = 7
		foreach var in SigRtred SigBtred SigRcred SigBcred {
			sum I`var'1 if firsttable `spec'
			mata R[`i',`j'] = `r(mean)'
			quietly sum I`var'5 if firsttable `spec'
			mata R[`i',`j'+1] = `r(mean)'
			local i = `i' + 1
			}
		local j = `j' + 2
		}
restore
	mata R; R[2..10,1...] = R[2..10,1...]:/R[1,1...]; R
 

*Appendix Table VII - Significance of Results at Table Level - all coefficients
use results\BaseResultsCoef, clear
keep paper CoefNum p1
merge 1:1 paper CoefNum using results\basecoef, keepusing(table suestselect) nogenerate
keep if suestselect == 1
collapse (min) p1 (count) N = p1, by(paper table) fast
merge 1:1 paper table using results\basetable, keepusing(firsttable) nogenerate
merge 1:1 paper table using results\BaseResultsTable, keepusing(p*) nogenerate
merge m:1 paper using results\Highlev, keepusing(levgroup) nogenerate
rename p1 pmin
foreach var in pmin p prw pbw pjk prc pbc {
	gen I`var'1 = (`var' < .01) if `var' ~= .
	gen I`var'5 = (`var' < .05) if `var' ~= .
	}
mata R = J(6,12,.); RR = J(6,12,.)
local i = 0
foreach var in pmin prw pbw pjk prc pbc {
	local i = `i' + 1
	preserve
	quietly drop if `var' == .
	collapse (mean) Ip1 Ip5 I`var'* levgroup, by(paper) fast
	local j = 1
	foreach spec in "~=." "==1" "==2" "==3" {
		sum I`var'1 if levgroup `spec'
		mata R[`i',`j'] = `r(mean)'
		sum I`var'5 if levgroup `spec'
		mata R[`i',`j'+1] = `r(mean)'
		sum Ip1 if levgroup `spec'
		mata RR[`i',`j'] =`r(mean)'
		sum Ip5 if levgroup `spec'
		mata RR[`i',`j'+1] =`r(mean)'
		local j = `j' + 2
		}
	restore
	}
local i = 0
foreach var in pmin prw pbw pjk prc pbc {
	local i = `i' + 1
	preserve
	quietly drop if `var' == .
	collapse (mean) Ip1 Ip5 I`var'* levgroup, by(paper firsttable) fast
	egen N = count(firsttable), by(paper)
	keep if N == 2
	local j = 9
	foreach spec in "==1" "==0" {
		sum I`var'1 if firsttable `spec'
		mata R[`i',`j'] = `r(mean)'
		sum I`var'5 if firsttable `spec'
		mata R[`i',`j'+1] = `r(mean)'
		sum Ip1 if firsttable `spec'
		mata RR[`i',`j'] =`r(mean)'
		sum Ip5 if firsttable `spec'
		mata RR[`i',`j'+1] =`r(mean)'
		local j = `j' + 2
		}
	restore
	}

mata R[2..6,1...] = R[2..6,1...]:/RR[2..6,1...]; R; RR
mata RRR = R[1,1...] \ RR[2,1...] \ R[2..6,1...]; RRR

use results\BHTable, clear
keep p* paper table
merge m:1 paper using results\HighLev, keepusing(levgroup) nogenerate
merge 1:1 paper table using results\basetable, keepusing(firsttable) nogenerate
foreach var in p1 prt pbt pjk prc pbc {
	gen I`var'1 = (`var' < .01)
	gen I`var'5 = (`var' < .05)
	}
preserve
	collapse (mean) I* levgroup, by(paper) fast
	mata R = J(10,12,.)
	local j = 1
	foreach spec in "~=." "==1" "==2" "==3" {
		local i = 1
		foreach var in p1 prt pbt pjk prc pbc {
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
		foreach var in p1 prt pbt pjk prc pbc {
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
foreach var in SigRt SigBt SigRc SigBc {
	gen I`var'1 = (`var'3 < .01)
	gen I`var'5 = (`var'3 < .05)
	}
preserve
	collapse (mean) I* levgroup, by(paper) fast
	local j = 1
	foreach spec in "~=." "==1" "==2" "==3" {
		local i = 7
		foreach var in SigRt SigBt SigRc SigBc {
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
		local i = 7
		foreach var in SigRt SigBt SigRc SigBc {
			sum I`var'1 if firsttable `spec'
			mata R[`i',`j'] = `r(mean)'
			quietly sum I`var'5 if firsttable `spec'
			mata R[`i',`j'+1] = `r(mean)'
			local i = `i' + 1
			}
		local j = `j' + 2
		}
restore
	mata R[2..10,1...] = R[2..10,1...]:/R[1,1...]; R


**********************************************************************
**********************************************************************

*Table A1:  Alternate clustering

*Papers which systematically clustered above treatment level

use results\baseresultscoef, clear
merge 1:1 paper CoefNum using results\basecoef, keepusing(select repeat) nogenerate
drop if palt1 == .
keep if select == 1
drop if repeat == 1
foreach var in p1 prt pbt pjk prc pbc palt1 prtalt pbtalt pjkalt prcalt pbcalt {
	gen I`var'1 = (`var' < .01)
	gen I`var'5 = (`var' < .05)
	}
collapse (mean) I*, by(paper) fast
mata R = J(6,4,.)
local i = 0
foreach var in p1 prt pbt pjk prc pbc {
	local i = `i' + 1
	quietly sum I`var'1
	mata R[`i',1] = `r(mean)'
	quietly sum I`var'5
	mata R[`i',2] = `r(mean)'
	}
local i = 0
foreach var in palt1 prtalt pbtalt pjkalt prcalt pbcalt {
	local i = `i' + 1
	quietly sum I`var'1
	mata R[`i',3] = `r(mean)'
	quietly sum I`var'5
	mata R[`i',4] = `r(mean)'
	}
mata R[2..6,1..4] = R[2..6,1..4]:/R[1,1..4]; R

use results\baseresultscoef, clear
merge 1:1 paper CoefNum using results\basecoef, keepusing(select repeat) nogenerate
keep if select == 1
drop if repeat == 1 & paper ~= "ER"
replace palt1 = p1 if palt1 == .
foreach var in prt pbt pjk prc pbc {
	replace `var'alt = `var' if `var'alt == .
	}
foreach var in p1 prt pbt pjk prc pbc palt1 prtalt pbtalt pjkalt prcalt pbcalt {
	gen I`var'1 = (`var' < .01)
	gen I`var'5 = (`var' < .05)
	}
collapse (mean) I*, by(paper) fast
mata R = J(6,4,.)
local i = 0
foreach var in p1 prt pbt pjk prc pbc {
	local i = `i' + 1
	quietly sum I`var'1
	mata R[`i',1] = `r(mean)'
	quietly sum I`var'5
	mata R[`i',2] = `r(mean)'
	}
local i = 0
foreach var in palt1 prtalt pbtalt pjkalt prcalt pbcalt {
	local i = `i' + 1
	quietly sum I`var'1
	mata R[`i',3] = `r(mean)'
	quietly sum I`var'5
	mata R[`i',4] = `r(mean)'
	}
mata R[2..6,1..4] = R[2..6,1..4]:/R[1,1..4]; R

**********************************************************************
**********************************************************************

*Table A2:  Alternative methods of calculating the bootstrap

use results\baseresultscoef, clear
merge 1:1 paper CoefNum using results\basecoef, keepusing(select repeat number) nogenerate
preserve
	keep if select == 1 
	drop if repeat == 1 & paper ~= "ER"
	foreach var in p1 pbt pbc pbbt pbbc {
		gen I`var'1 = (`var' < .01)
		gen I`var'5 = (`var' < .05)
		}
	collapse (mean) I*, by(paper) fast
	mata R = J(5,2,.)
	local i = 0
	foreach var in p1 pbt pbc pbbt pbbc {
		local i = `i' + 1
		quietly sum I`var'1
		mata R[`i',1] = `r(mean)'
		quietly sum I`var'5
		mata R[`i',2] = `r(mean)'
		}
	mata R[2..5,1..2] = R[2..5,1..2]:/R[1,1..2]; R
restore
preserve
	keep if repeat == 0
	foreach var in p1 pbt pbc pbbt pbbc {
		gen I`var'1 = (`var' < .01)
		gen I`var'5 = (`var' < .05)
		}
	collapse (mean) I*, by(paper) fast
	mata R = J(5,2,.)
	local i = 0
	foreach var in p1 pbt pbc pbbt pbbc {
		local i = `i' + 1
		quietly sum I`var'1
		mata R[`i',1] = `r(mean)'
		quietly sum I`var'5
		mata R[`i',2] = `r(mean)'
		}
	mata R[2..5,1..2] = R[2..5,1..2]:/R[1,1..2]; R
restore

**********************************************************************
**********************************************************************

*Table A3:  Conditional Randomization P-values

use results\baseresultscoef, clear
merge 1:1 paper CoefNum using results\basecoef, keepusing(select repeat number) nogenerate
sum prt prtcond if select == 1 & number > 1 & (repeat == 0 | paper == "ER")
sum prt prtcond if number > 1 & repeat == 0
gen dift = (abs(rtcond1-rtcond2) > .01) if rtcond1 ~= .
gen difc = (abs(rccond1-rccond2) > .01) if rccond1 ~= .
replace prtcond = . if dift == 1 | difc == 1
sum prt prtcond if select == 1 & number > 1 & (repeat == 0 | paper == "ER")
sum prt prtcond if number > 1 & repeat == 0
preserve
	keep if select == 1 & number > 1 & prtcond ~= . & (repeat == 0 | paper == "ER")
	foreach var in p1 prt prc prtcond prccond {
		gen I`var'1 = (`var' < .01)
		gen I`var'5 = (`var' < .05)
		}
	collapse (mean) I*, by(paper) fast
	mata R = J(5,2,.)
	local i = 0
	foreach var in p1 prt prc prtcond prccond {
		local i = `i' + 1
		quietly sum I`var'1
		mata R[`i',1] = `r(mean)'
		quietly sum I`var'5
		mata R[`i',2] = `r(mean)'
		}
	mata R[2..5,1..2] = R[2..5,1..2]:/R[1,1..2]; R
restore
preserve
	keep if repeat == 0 & number > 1 & prtcond ~= .
	foreach var in p1 prt prc prtcond prccond {
		gen I`var'1 = (`var' < .01)
		gen I`var'5 = (`var' < .05)
		}
	collapse (mean) I*, by(paper) fast
	mata R = J(5,2,.)
	local i = 0
	foreach var in p1 prt prc prtcond prccond {
		local i = `i' + 1
		quietly sum I`var'1
		mata R[`i',1] = `r(mean)'
		quietly sum I`var'5
		mata R[`i',2] = `r(mean)'
		}
	mata R[2..5,1..2] = R[2..5,1..2]:/R[1,1..2]; R
restore	

**********************************************************************
**********************************************************************

*Table A4:  Impact of Alternative Methods on Table VIII's Results

use results\BaseResultsCoef, clear
keep p1 prc prt CoefNum paper
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
foreach level in 1 5 {
	preserve
	keep if p1 < `level'/100
	gen I1 = (prc < .01)
	gen I5 = (prc < .05 & prc >= .01)
	gen I10 = (prc < .1 & prc >= .05)
	gen I20 = (prc < .2 & prc >= .1)
	gen I20p = (prc > .2 & prc ~= .)
	collapse (mean) I*, by(paper)
	sum I*
	restore
	}

use results\BaseResultsCoef, clear
keep p1 prt prtalt CoefNum paper
merge 1:1 paper CoefNum using results\basecoef, keepusing(repeat select) nogenerate
keep if select == 1
drop if repeat == 1 & paper ~= "ER"
drop if prtalt == .
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
	keep if p1 < `level'/100
	gen I1 = (prtalt < .01)
	gen I5 = (prtalt < .05 & prtalt >= .01)
	gen I10 = (prtalt < .1 & prtalt >= .05)
	gen I20 = (prtalt < .2 & prtalt >= .1)
	gen I20p = (prtalt > .2 & prtalt ~= .)
	collapse (mean) I*, by(paper)
	sum I*
	restore
	}

use results\BaseResultsCoef, clear
replace prtcond = . if abs(rtcond1-rtcond2) > .01
replace prtcond = . if abs(rccond1-rccond2) > .01
keep p1 prtcond prt CoefNum paper
merge 1:1 paper CoefNum using results\basecoef, keepusing(repeat select number) nogenerate
keep if select == 1 & prtcond ~= . & number > 1
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
foreach level in 1 5 {
	preserve
	keep if p1 < `level'/100
	gen I1 = (prtcond < .01)
	gen I5 = (prtcond < .05 & prtcond >= .01)
	gen I10 = (prtcond < .1 & prtcond >= .05)
	gen I20 = (prtcond < .2 & prtcond >= .1)
	gen I20p = (prtcond > .2 & prtcond ~= .)
	collapse (mean) I*, by(paper)
	sum I*
	restore
	}

**********************************************************************
**********************************************************************

*Table A5 - Power calculations

matrix Rc = J(5,18,.)
matrix Rr = J(5,18,.)
set seed 1
local k = 1
foreach file in fixed normal chi2 afixed anormal achi2 {
	foreach N in 20 200 2000 {
		local a = "simul\" + "`file'" + "\" + "`file'" + "n" + "`N'"
		display "`a'"
		use `a', clear
		drop if rep > 1000
		capture drop BR1 BR2 JK1 rep
		scalar t = sqrt(invFtail(1,`N'-2,.05))
		gen double critical = scalar(t)*B2 - B1
		gen double critical2 = -scalar(t)*B2 - B1
		matrix xx = (1000000,2500000,5000000,7500000,9000000)
		matrix x = xx
		matrix c = J(1,5,.)
		sort critical
		forvalues i = 1/5 {
			scalar t = 1
			while scalar(t) > 0 {
				scalar t = x[1,`i']
				sum critical2 if critical2 > critical[x[1,`i']]
				matrix x[1,`i'] = xx[1,`i'] - r(N) 
				scalar t = scalar(t) - x[1,`i']
				}
			matrix c[1,`i'] = critical[x[1,`i']]
			}
		drop critical*
		forvalues i = 1/5 {
			gen double t`i' = (B1+c[1,`i'])^2/B2^2
			gen double Rt`i' = (R1 + c[1,`i']*R3)^2/(R2^2+c[1,`i']*R4+R5*c[1,`i']^2)
			gen byte Il`i' = Rt`i' > t`i'*1.000001
			gen byte Iu`i' = Rt`i' > t`i'*.999999
			drop Rt`i'
			}
		collapse (sum) I* (mean) t*, by(iteration) fast
		gen double u = uniform()
		forvalues i = 1/5 {
			gen double p`i' = Ftail(1,`N'-2,t`i')
			gen double rp`i' = (Il`i' + u*(Iu`i'-Il`i'+1))/1001
			quietly sum p`i' if p`i' < .05
			matrix Rc[`i',`k'] = r(N)/10000
			quietly sum rp`i' if rp`i' < .05
			matrix Rr[`i',`k'] = r(N)/10000
			}
		local k = `k' + 1
		}
	}

use simul\pvalues, clear
matrix R = J(2,18,.)
local k = 0
foreach file in fixed normal chi2 afixed anormal achi2 {
	foreach N in 20 200 2000 {
		local k = `k' + 1
		quietly sum p if file == "`file'" & N == `N' & p < .05
		matrix R[1,`k'] = r(N)/10000
		quietly sum prt if file == "`file'" & N == `N' & prt < .05
		matrix R[2,`k'] = r(N)/10000
		}
	}
matrix list R

local k = 1
foreach j in 10 25 50 75 90 {
	forvalues i = 1/18 {
		if (Rc[`k',`i'] ~= `j'/100) {
			matrix Rc[`k',`i'] = .
			matrix Rr[`k',`i'] = .
			}
		}
	local k = `k' + 1
	}

mata Rc = st_matrix("Rc"); Rr = st_matrix("Rr"); R = st_matrix("R")
mata q = Rr:/Rc; q
mata q1 = Rc:/R[1,1...]; q2 = Rr:/R[2,1...]; q = q2:/q1; q
mata q = R[2,1...]:/R[1,1...]; q; R

**********************************************************************
**********************************************************************

*Table A6

*Determinants of differences between conventional and randomization results

drop _all
use results\baseresultscoef
merge 1:1 paper CoefNum using results\leverage, nogenerate
merge 1:1 paper CoefNum using results\basecoef, nogenerate
keep if select == 1
drop if repeat == 1 & paper ~= "ER"
gen I1 = (prt > .01) if p1 < .01
gen I5 = (prt > .05) if p1 < .05
gen nobscl = QQ2

foreach dep in I1 I5 {
	foreach spec in QQ3 nobscl firsttable interactions {
		reg `dep' `spec', cluster(paper)
		areg `dep' `spec', cluster(paper) absorb(paper)
		}
	foreach spec in nobscl firsttable interactions {
		reg `dep' QQ3 `spec', cluster(paper)
		areg `dep' QQ3 `spec', cluster(paper) absorb(paper)
		}
	}



drop _all
use results\baseresultscoef
merge 1:1 paper CoefNum using results\leverage, nogenerate
merge 1:1 paper CoefNum using results\basecoef, nogenerate
drop if repeat == 1 
gen I1 = (prt > .01) if p1 < .01
gen I5 = (prt > .05) if p1 < .05
gen nobscl = QQ2

foreach dep in I1 I5 {
	foreach spec in QQ3 nobscl firsttable interactions {
		reg `dep' `spec', cluster(paper)
		areg `dep' `spec', cluster(paper) absorb(paper)
		}
	foreach spec in nobscl firsttable interactions {
		reg `dep' QQ3 `spec', cluster(paper)
		areg `dep' QQ3 `spec', cluster(paper) absorb(paper)
		}
	}

**********************************************************************
**********************************************************************



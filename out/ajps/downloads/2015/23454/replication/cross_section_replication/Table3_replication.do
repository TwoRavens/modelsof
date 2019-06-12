version 9.2
/*
*the following packages are required
net install ivreg2,replace from(http://fmwww.bc.edu/RePEc/bocode/i)
net install ranktest,replace from(http://fmwww.bc.edu/RePEc/bocode/r)
net install outreg2,replace from(http://fmwww.bc.edu/RePEc/bocode/o)
*/

global title table2
global Table "Table3"
global Title "Table 3: Downballot Races"
global option "average"

global ideolist "ideo1"
global latelist "late1"
global candidlist "cand_ideo_true"
global gaplist "null"

*global samplist "base2 base nonplacebo all db db2 inc placebo"

*global samplist "nonplacebo db db_top db_placebo inc placebo" 

*global samplist "nonplacebo inc placebo" /* Table 1 */

global samplist "db db_placebo db_top" /* Table 3 */

global weightlist "relf"

	global slate1="First + Last"
	global slate2="Median Poll Cutoff"
	global slate4="45 Day Cutoff"
	
	global sideo1="Extremes"
	global sideo2="Intermediate"
	global sideo3="Exhaustive"
	
	global sbase="Baseline"
	global sall="All"
	global svalid "Top Ballot"
	global splacebo="Placebo"
	global snonplacebo="Non-Placebo"
	global sdb "Down-Ballot"
	global sdb2 "DB, Coded"
	global sinc="Incumbents"
	global sdem="Democratic"
	global srep="Republican"
	global sfielddem="Field Dem."
	global sfieldrep="Field Rep."
	global ssusadem="SUSA Dem."
	global ssusarep="SUSA Rep."

cap erase ${Table}.tex
cap erase ${Table}.txt

foreach ideo of global ideolist {
foreach late of global latelist {
foreach candid of global candidlist {
foreach gap of global gaplist {
foreach sample of global samplist {

global late `late'
global ideo `ideo'
global cand_ideo `candid'
global gap `gap'
global sample `sample'

global ctitle " "
*global specs "Ideology","${s${ideo}}","Polls","${s${late}}"
global specs "Sample","${s${sample}}"

do estimator_part2

}
}
}
}
}

capture {
use r1stub, clear
foreach ideo of global ideolist {
foreach late of global latelist {
foreach candid of global candidlist {
foreach gap of global gaplist {
cap append using r1_`ideo'_`late'_`candid'_gap`gap'
cap erase r1_`ideo'_`late'_`candid'_gap`gap'.dta
}
}
}
}
so ideo late cand_ideo gap contest
save results_contest_${title}, replace
cap erase r1stub.dta
}

use r2stub, clear
foreach ideo of global ideolist {
foreach late of global latelist {
foreach candid of global candidlist {
foreach gap of global gaplist {
foreach sample of global samplist {
cap append using r2_`ideo'_`late'_`candid'_gap`gap'_`sample'
*if "`sample'"!="db" {
*cap erase r2_`ideo'_`late'_`candid'_gap`gap'_`sample'.dta
*}
}
}
}
}
}
so ideo late cand_ideo gap sample
save results_sample_${title}, replace
cap erase r2stub.dta

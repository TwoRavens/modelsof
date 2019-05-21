version 9.2
/*
*the following packages are required
net install ivreg2,replace from(http://fmwww.bc.edu/RePEc/bocode/i)
net install ranktest,replace from(http://fmwww.bc.edu/RePEc/bocode/r)
net install outreg2,replace from(http://fmwww.bc.edu/RePEc/bocode/o)
*/
global title table4
global Table "Table2"
global Title "Table 2: Triple Differences"

global ideolist "ideo1"
global latelist "late1"
global candidlist "cand_ideo_true"
global gaplist "whole whole05 third third05"
global samplist "valid"
global weightlist "relf"

	global slate1="First + Last"
	global slate2="Median Poll Cutoff"
	global slate4="45 Day Cutoff"
	
	global sideo1="Extremes"
	global sideo2="Intermediate"
	global sideo3="Exhaustive"
	
	global sbase1="Baseline"
	global sall="All"
	global sfield1="Field"
	global ssusa1="SUSA"
	global splacebo1="Placebo"
	global sdb="Down-Ballot"
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

	global spart "Whole Period"
	if strpos("$gap","third")>0 global spart "First Third"
	if strpos("$gap","half")>0 global spart "First Half"
	global smea "Continuous"
	if strpos("$gap","05")>0 global smea "Cutoff at 0.5"
	if strpos("$gap","07")>0 global smea "Cutoff at 0.7"


global ctitle " "
*global specs "Ideology","${s${ideo}}","Polls","${s${late}}"
*global specs "Sample","${s${sample}}"
global specs "Gap Measure","$smea","Gap Computation Period","$spart"

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
cap erase r2_`ideo'_`late'_`candid'_gap`gap'_`sample'.dta
}
}
}
}
}
so ideo late cand_ideo gap sample
save results_sample_${title}, replace
cap erase r2stub.dta

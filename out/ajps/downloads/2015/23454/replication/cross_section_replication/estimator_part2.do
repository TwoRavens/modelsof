/*This program needs the macros late, ideo, cand_ideo, gap, sample and weight to run*/

/*
global late late1
global ideo ideo1
global cand_ideo cand_ideo_all
global gap "null"
global sample all
global Table Table
global title "Table 1: Baseline Estimates"
global ctitle "Baseline"
global specs "Primaries","Baseline"
*/
****************************************************************************************

use contest_total2, clear
so contest
save contest_total2, replace
use candlist_total, clear
so contest cand
save candlist_total, replace
use pollist_total, clear
so contest poll
save pollist_total, replace


use data_long, clear
so contest poll
merge contest poll using pollist_total, update replace
ta _me
keep if _me>=3
drop _me
so contest cand
merge contest cand using candlist_total, update replace
ta _me
keep if _me>=3
drop _me
so contest
merge contest using contest_total2, update replace
ta _me
keep if _me>=3
drop _me

keep if ${sample}==1
drop if year==2010
/*if "$spart"=="Whole Period" & "$smea"=="Cutoff at 0.7" {
drop if contest==30 
}
*/
collapse (sum) freq, by(contest* dataset year geog office party ${late} ${ideo} ${cand_ideo})
drop if ${ideo}==. | ${cand_ideo}==. | ${late}==.

by contest, so: egen count=count(contest)
drop if count!=8
drop count


so contest
merge contest using contest_total2, update replace
ta _me
keep if _me>=3
drop _me


levelsof contest, local(CON)
global N=wordcount("`CON'")

/*Weights*/
by contest, so: egen sumfreq=total(freq)
su sumfreq
gen relf=round(freq*r(mean)/sumfreq)
replace freq=round(freq)

/*Dummy Variables and Interactions*/

gen interact=${ideo}*${late}
lab var interact "Vote Conservative X Late Poll"

xi i.contest, pref(C_) noomit
foreach var of varlist *_contest_* {
rename `var' `=subinstr("`var'","_contest_","_",1)'
}
xi i.${late}*i.contest, pref(L_) noomit
drop L_contest* L_late* *_0_*
foreach var of varlist *_latXcon_* {
rename `var' `=subinstr("`var'","_latXcon_1_","_",1)'
}
xi i.${ideo}*i.contest, pref(I_) noomit
drop I_contest* I_ideo* *_0_*
foreach var of varlist *_ideXcon_* {
rename `var' `=subinstr("`var'","_ideXcon_1_","_",1)'
}
xi i.interact*i.contest, pref(S_) noomit
drop S_contest* S_interac* *_0_*
foreach var of varlist *_intXcon_* {
rename `var' `=subinstr("`var'","_intXcon_1_","_",1)'
}

	if "${gap}"!="null" {
		foreach var of varlist C_* {
			cap gen `=subinstr("`var'","C","Cg",1)'=`var'*gap${gap}
		}
		foreach var of varlist I_* {
			cap gen `=subinstr("`var'","I","Ig",1)'=`var'*gap${gap}
		}
		foreach var of varlist L_* {
			cap gen `=subinstr("`var'","L","Lg",1)'=`var'*gap${gap}
		}
		cap gen interact_g=interact*gap${gap}
		lab var interact_g "Vote Conservative X Late Poll X Ideology Gap"
	}


/*Estimation*/

if "${sample}"=="all" {
	qui reg ${cand_ideo} S_* C_* I_* L_* [fw=freq], r nocon
	foreach P in S C I L {
		foreach var of varlist `P'_* {
			global b_`var'=_b[`var']
			global se_`var'=_se[`var']
		}
	}
}


qui ivreg2 ${cand_ideo} S_* C_* I_* L_* [fw=freq], r nocon fwl(C_* I_* L_*)
do auxiliary
global b_avg=$b
global se_avg=$V
global b_ms=$b_rms
global se_ms=$V_rms
global P_F=$P

if "$gap"=="null" {

if "$option"=="average" {
su contest
global min=r(min)
rename S_${min} S
lab var S "Average Interaction Coefficient"
foreach var of varlist S_* {
replace `var'=`var'-S
}
replace S=$N*S
qui reg ${cand_ideo} S S_* C_* I_* L_* [fw=freq], r nocon
	outreg2 S using ${Table}.tex, nocon label 10pct ///
	adds("Number of Primaries",$N,"P-value that all interaction coefficients are zero",$P_F) addt("$specs") ///
	title("$Title") ctitle("$ctitle")
}

else if "$option"=="interact" {
qui reg ${cand_ideo} interact C_* I_* L_* [fw=relf], r nocon
	outreg2 interact using ${Table}.tex, nocon label 10pct ///
	adds("Number of Primaries",$N,"P-value that all interaction coefficients are zero",$P_F) addt("$specs") ///
	title("$Title") ctitle("$ctitle")
est tab, keep(interact) se
global b_int=_b[interact]
global se_int=_se[interact]
}
}

else {
levelsof contest if gap${gap}!=., local(CON)
global N=wordcount("`CON'")
levelsof contest if gap${gap}==0, local(PLA)
global NP=wordcount("`PLA'")
qui reg ${cand_ideo} interact interact_g gap${gap} C_* I_* L_* Cg_* Ig_* Lg_* [fw=relf], r nocon
	outreg2 interact_g interact using ${Table}.tex, nocon label 10pct ///
	adds("Number of Primaries",$N,"Number of Placebos",$NP) addt("$specs") ///
	title("$Title") ctitle("$ctitle")

est tab, keep(interact interact_g) se
lincom interact+interact_g
global b_gfull=r(estimate)
global se_gfull=r(se)
global b_gint=_b[interact]
global se_gint=_se[interact]
global b_gap=_b[interact_g]
global se_gap=_se[interact_g]
}


/* Table */
noi {
if "${sample}"=="all" {
keep contest
duplicates drop
levelsof contest, local(CON)
foreach P in S C I L {
foreach q in b se {
gen `q'_`P'=.
foreach c of local CON {
cap replace `q'_`P'=${`q'_`P'_`c'} if contest==`c'
}
}
}
gen late="${late}"
gen ideo="${ideo}"
gen gap="gap${gap}"
gen cand_ideo="${cand_ideo}"
order ideo late cand_ideo gap contest
so contest
merge contest using contest_total2
keep if _me==3
drop _me
so ideo late cand_ideo gap contest*
order contest*
save results_contest_${sample}, replace
}

clear
set obs 1
foreach case in avg ms int gap gint gfull {
foreach q in b se {
cap gen `q'_`case'=${`q'_`case'}
}
}
gen P_F=$P_F
gen late="${late}"
gen ideo="${ideo}"
gen gap="gap${gap}"
gen cand_ideo="${cand_ideo}"
gen sample="${sample}"
order ideo late cand_ideo gap sample
so ideo late cand_ideo gap sample
save r2_${ideo}_${late}_${cand_ideo}_gap${gap}_${sample}, replace
drop if _n>=1
save r2stub, replace
}





 






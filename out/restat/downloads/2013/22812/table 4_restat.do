/* This file makes table 4 - the balance table */
/*Variable Creation is now entirely in the two create extract files*/

log using table4_restat.txt, text replace

set more off
use mergedcleaned04, clear
append using mergedcleaned00

gen dummy04 = year == 2004

/*Limit the results to non-imputed observations & regression sample */
areg allnone offcampus morethantuit getarefund female black asian hisp raceoth parhelp_nonmiss nontuithelp_nonmiss parhelp_miss nontuithelp_miss dummy04 , absorb(uglvl2) robust
keep if e(sample)

gen fourcat = .
replace fourcat = 1 if offcampus == 0 & morethantuit==0
replace fourcat = 2 if offcampus ==0 & morethantuit==1
replace fourcat = 3 if offcampus == 1 & morethantuit==0
replace fourcat = 4 if offcampus == 1 & morethantuit==1
replace fourcat = . if localres==3 | allnone==.

gen highselect = selectcat==1
replace highselect = . if selectcat==.
gen medselect = selectcat==2
replace medselect = . if selectcat==.
gen lowselect = selectcat==3
replace lowselect = . if selectcat==.

/* generate another type_research dummy (because we renamed it earlier) */
gen type_research = 0
replace type_research = 1 if cc2000 ==1 | cc2000==2

/* copy & paste these results into excel directly */
bysort fourcat: sum female black hispanic asian raceoth type_* highselect medselect lowselect smartparent expensiveschool parentshelp highcost highinc abovemedtest highneed hascc ccbalanceyesno uglvl2 efc, separator(0)

/* test significance of the diff-in-diff */

reg female offcampus morethan getarefund, robust
outreg using table4_9903.txt, replace se coefastr 10pct

foreach var of varlist white black hispanic asian raceoth type_* highselect medselect lowselect smartparent expensiveschool parentshelp highcost highinc abovemedtest highneed hascc ccbalanceyesno uglvl2 efc{
	reg `var' offcampus morethan getarefund, robust
	outreg using table4_9903.txt, append se coefastr 10pct

}

log close

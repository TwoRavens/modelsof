/* 
Protest Via the Null Ballot: Analyses - Tables and Figures in paper body and appendices
Version: April 27, 2017
Mollie J. Cohen
*/

*Using Dataset: "PvTNB main data.dta"

***********************
* Paper Body - Tables *
***********************

* Table 2 / Appendix Table B1
svy: mprobit abst_null_vote  c.ing4  newdem22 c.trust_elec c.performance  i.ownecon_worse i.natlecon_worse c.alienate c.knowledge c.interest protest mujer q2 agesq ur ed quintall i.pais, base(2)

*Predicted probabilities
svy: mprobit abst_null_vote  c.ing4  newdem22 c.trust_elec c.performance  i.ownecon_worse i.natlecon_worse c.alienate c.knowledge c.interest protest mujer q2 agesq ur ed quintall pais2 pais3 pais4 pais5 pais6 pais7 pais8 pais9 pais10 pais11 pais12 pais13 pais14, base(2)

prvalue, x(ing4=1) rest(mean) bootstrap reps(100)
prvalue, x(ing4=7) rest(mean) bootstrap reps(100)
prvalue, x(newdem22=1) rest(mean) bootstrap reps(100)
prvalue, x(newdem22=0) rest(mean) bootstrap reps(100)
prvalue, x(trust_elec=1) rest(mean) bootstrap reps(100)
prvalue, x(trust_elec=7) rest(mean) bootstrap reps(100)
prvalue, x(performance=1) rest(mean) bootstrap reps(100)
prvalue, x(performance=7) rest(mean) bootstrap reps(100)
prvalue, x(ownecon_worse =0) rest(mean)bootstrap reps(100)
prvalue, x(ownecon_worse =1) rest(mean) bootstrap reps(100)
prvalue, x(natlecon_worse =0) rest(mean) bootstrap reps(100)
prvalue, x(natlecon_worse =1) rest(mean) bootstrap reps(100) 
prvalue, x(alienate=1) rest(mean) bootstrap reps(100)
prvalue, x(alienate=7) rest(mean) bootstrap reps(100)
prvalue, x(interest=1) rest(mean) bootstrap reps(100)
prvalue, x(interest=4) rest(mean) bootstrap reps(100)
prvalue, x(knowledge=0) rest(mean) bootstrap reps(100)
prvalue, x(knowledge=1) rest(mean) bootstrap reps(100) 
prvalue, x(protest=0) rest(mean) bootstrap reps(100)
prvalue, x(protest=1) rest(mean) bootstrap reps(100)

*Hypothetical Individuals
prvalue, x(performance=1 alienate=7 knowledge=1 interest=1) rest(mean) bootstrap reps(100)
prvalue, x(performance=7 alienate=1 knowledge=0 interest=4) rest(mean) bootstrap reps(100)

*Model Fit
mprobit abst_null_vote mujer q2 agesq ur ed quintall pais2 pais3 pais4 pais5 pais6 pais7 pais8 pais9 pais10 pais11 pais12 pais13 pais14, base(2)
fitstat

mprobit abst_null_vote  c.ing4  newdem22 c.trust_elec c.performance  i.ownecon_worse i.natlecon_worse c.alienate c.knowledge c.interest protest mujer q2 agesq ur ed quintall pais2 pais3 pais4 pais5 pais6 pais7 pais8 pais9 pais10 pais11 pais12 pais13 pais14, base(2)
fitstat

********************************************************
* Hierarchical models - Table 3/ Appendix Table B2 & B3*
********************************************************

*compulsory voting
qui xtmelogit ivvote female q2 agesq ur ed quintall i.compulsory##c.ing4  newdem22 c.trust_elec c.performance  i.ownecon_worse i.natlecon_worse c.alienate c.knowledge c.interest  || pais:
eststo comp1
qui xtmelogit ivabstain female q2 agesq ur ed quintall i.compulsory##c.ing4  newdem22 c.trust_elec c.performance  i.ownecon_worse i.natlecon_worse c.alienate c.knowledge c.interest  || pais:
eststo comp2
qui xtmelogit ivvote female q2 agesq ur ed quintall c.ing4  i.compulsory##newdem22  c.trust_elec c.performance  i.ownecon_worse i.natlecon_worse c.alienate c.knowledge c.interest  || pais:
eststo comp3
qui xtmelogit ivabstain female q2 agesq ur ed quintall c.ing4  i.compulsory##newdem22  c.trust_elec c.performance  i.ownecon_worse i.natlecon_worse c.alienate c.knowledge c.interest || pais:
eststo comp4
qui xtmelogit ivvote female q2 agesq ur ed quintall c.ing4  newdem22 i.compulsory##c.trust_elec c.performance  i.ownecon_worse i.natlecon_worse c.alienate c.knowledge c.interest  || pais:
eststo comp5
qui xtmelogit ivabstain female q2 agesq ur ed quintall c.ing4  newdem22 i.compulsory##c.trust_elec c.performance  i.ownecon_worse i.natlecon_worse c.alienate c.knowledge c.interest || pais:
eststo comp6
qui xtmelogit ivvote female q2 agesq ur ed quintall c.ing4  newdem22 c.trust_elec i.compulsory##c.performance  i.ownecon_worse i.natlecon_worse c.alienate c.knowledge c.interest  || pais:
eststo comp7
qui xtmelogit ivabstain female q2 agesq ur ed quintall c.ing4  newdem22 c.trust_elec i.compulsory##c.performance  i.ownecon_worse i.natlecon_worse c.alienate c.knowledge c.interest || pais:
eststo comp8
qui xtmelogit ivvote female q2 agesq ur ed quintall c.ing4  newdem22 c.trust_elec c.performance  i.compulsory##i.ownecon_worse i.natlecon_worse c.alienate c.knowledge c.interest || pais:
eststo comp9
qui xtmelogit ivabstain female q2 agesq ur ed quintall c.ing4  newdem22 c.trust_elec c.performance  i.compulsory##i.ownecon_worse i.natlecon_worse c.alienate c.knowledge c.interest || pais:
eststo comp10
qui xtmelogit ivvote female q2 agesq ur ed quintall c.ing4  newdem22 c.trust_elec c.performance  i.ownecon_worse i.compulsory##i.natlecon_worse c.alienate c.knowledge c.interest || pais:
eststo comp11
qui xtmelogit ivabstain female q2 agesq ur ed quintall c.ing4  newdem22 c.trust_elec c.performance  i.ownecon_worse i.compulsory##i.natlecon_worse c.alienate c.knowledge c.interest || pais:
eststo comp12
qui xtmelogit ivvote female q2 agesq ur ed quintall c.ing4  newdem22 c.trust_elec c.performance  i.ownecon_worse i.natlecon_worse i.compulsory##c.alienate c.knowledge c.interest || pais:
eststo comp13
qui xtmelogit ivabstain female q2 agesq ur ed quintall c.ing4  newdem22 c.trust_elec c.performance  i.ownecon_worse i.natlecon_worse i.compulsory##c.alienate c.knowledge c.interest || pais:
eststo comp14
qui xtmelogit ivvote female q2 agesq ur ed quintall c.ing4  newdem22 c.trust_elec c.performance  i.ownecon_worse i.natlecon_worse c.alienate i.compulsory##c.knowledge c.interest || pais:
eststo comp15
qui xtmelogit ivabstain female q2 agesq ur ed quintall c.ing4  newdem22 c.trust_elec c.performance  i.ownecon_worse i.natlecon_worse c.alienate i.compulsory##c.knowledge c.interest || pais:
eststo comp16
qui xtmelogit ivvote female q2 agesq ur ed quintall c.ing4  newdem22 c.trust_elec c.performance  i.ownecon_worse i.natlecon_worse c.alienate c.knowledge i.compulsory##c.interest || pais:
eststo comp17
qui xtmelogit ivabstain female q2 agesq ur ed quintall c.ing4  newdem22 c.trust_elec c.performance  i.ownecon_worse i.natlecon_worse c.alienate c.knowledge i.compulsory##c.interest || pais:
eststo comp18

estout comp1 comp2 comp3 comp4 comp5 comp6 comp7 comp8 comp9 comp10 comp11 comp12 comp13 comp14 comp15 comp16 comp17 comp18 using compulsory.xls, ///
			cells(b(star fmt(%9.3f)) se(par))                ///
             stats(r2_a N, fmt(2) labels( N))      ///
             legend label collabels(none) varlabels(_cons Constant) replace 

estout comp9 comp10 comp11 comp12 comp13 comp14 comp15 comp16 comp17 comp18 using compulsory2.xls, ///
			cells(b(star fmt(%9.3f)) se(par))                ///
             stats(r2_a N, fmt(2) labels( N))      ///
             legend label collabels(none) varlabels(_cons Constant) replace 
			 			 
			 
*second round
qui xtmelogit ivvote female q2 agesq ur ed quintall i.secondrd##c.ing4  newdem22 c.trust_elec c.performance  i.ownecon_worse i.natlecon_worse c.alienate c.knowledge c.interest  compulsory|| pais:
eststo secondrd1
qui xtmelogit ivabstain female q2 agesq ur ed quintall i.secondrd##c.ing4  newdem22 c.trust_elec c.performance  i.ownecon_worse i.natlecon_worse c.alienate c.knowledge c.interest  compulsory|| pais:
eststo secondrd2
qui xtmelogit ivvote female q2 agesq ur ed quintall c.ing4  i.secondrd##newdem22  c.trust_elec c.performance  i.ownecon_worse i.natlecon_worse c.alienate c.knowledge c.interest  compulsory|| pais:
eststo secondrd3
qui xtmelogit ivabstain female q2 agesq ur ed quintall c.ing4  i.secondrd##newdem22  c.trust_elec c.performance  i.ownecon_worse i.natlecon_worse c.alienate c.knowledge c.interest  compulsory|| pais:
eststo secondrd4
qui xtmelogit ivvote female q2 agesq ur ed quintall c.ing4  newdem22 i.secondrd##c.trust_elec c.performance  i.ownecon_worse i.natlecon_worse c.alienate c.knowledge c.interest  compulsory|| pais:
eststo secondrd5
qui xtmelogit ivabstain female q2 agesq ur ed quintall c.ing4  newdem22 i.secondrd##c.trust_elec c.performance  i.ownecon_worse i.natlecon_worse c.alienate c.knowledge c.interest  compulsory|| pais:
eststo secondrd6
qui xtmelogit ivvote female q2 agesq ur ed quintall c.ing4  newdem22 c.trust_elec i.secondrd##c.performance  i.ownecon_worse i.natlecon_worse c.alienate c.knowledge c.interest  compulsory|| pais:
eststo secondrd7
qui xtmelogit ivabstain female q2 agesq ur ed quintall c.ing4  newdem22 c.trust_elec i.secondrd##c.performance  i.ownecon_worse i.natlecon_worse c.alienate c.knowledge c.interest  compulsory|| pais:
eststo secondrd8
qui xtmelogit ivvote female q2 agesq ur ed quintall c.ing4  newdem22 c.trust_elec c.performance  i.secondrd##i.ownecon_worse i.natlecon_worse c.alienate c.knowledge c.interest  compulsory|| pais:
eststo secondrd9
qui xtmelogit ivabstain female q2 agesq ur ed quintall c.ing4  newdem22 c.trust_elec c.performance  i.secondrd##i.ownecon_worse i.natlecon_worse c.alienate c.knowledge c.interest  compulsory|| pais:
eststo secondrd10
qui xtmelogit ivvote female q2 agesq ur ed quintall c.ing4  newdem22 c.trust_elec c.performance  i.ownecon_worse i.secondrd##i.natlecon_worse c.alienate c.knowledge c.interest  compulsory|| pais:
eststo secondrd11
qui xtmelogit ivabstain female q2 agesq ur ed quintall c.ing4  newdem22 c.trust_elec c.performance  i.ownecon_worse i.secondrd##i.natlecon_worse c.alienate c.knowledge c.interest  compulsory|| pais:
eststo secondrd12
qui xtmelogit ivvote female q2 agesq ur ed quintall c.ing4  newdem22 c.trust_elec c.performance  i.ownecon_worse i.natlecon_worse i.secondrd##c.alienate c.knowledge c.interest  compulsory|| pais:
eststo secondrd13
qui xtmelogit ivabstain female q2 agesq ur ed quintall c.ing4  newdem22 c.trust_elec c.performance  i.ownecon_worse i.natlecon_worse i.secondrd##c.alienate c.knowledge c.interest  compulsory|| pais:
eststo secondrd14
qui xtmelogit ivvote female q2 agesq ur ed quintall c.ing4  newdem22 c.trust_elec c.performance  i.ownecon_worse i.natlecon_worse c.alienate i.secondrd##c.knowledge c.interest  compulsory|| pais:
eststo secondrd15
qui xtmelogit ivabstain female q2 agesq ur ed quintall c.ing4  newdem22 c.trust_elec c.performance  i.ownecon_worse i.natlecon_worse c.alienate i.secondrd##c.knowledge c.interest  compulsory|| pais:
eststo secondrd16
qui xtmelogit ivvote female q2 agesq ur ed quintall c.ing4  newdem22 c.trust_elec c.performance  i.ownecon_worse i.natlecon_worse c.alienate c.knowledge i.secondrd##c.interest  compulsory|| pais:
eststo secondrd17
qui xtmelogit ivabstain female q2 agesq ur ed quintall c.ing4  newdem22 c.trust_elec c.performance  i.ownecon_worse i.natlecon_worse c.alienate c.knowledge i.secondrd##c.interest  compulsory|| pais:
eststo secondrd18

estout secondrd1 secondrd2 secondrd3 secondrd4 secondrd5 secondrd6 secondrd7 secondrd8 secondrd9 secondrd10 secondrd11 secondrd12 secondrd13 secondrd14 secondrd15 secondrd16 secondrd17 secondrd18 using secondrd.xls, ///
			cells(b(star fmt(%9.3f)) se(par))                ///
             stats(r2_a N, fmt(2) labels( N))      ///
             legend label collabels(none) varlabels(_cons Constant) replace 

estout secondrd9 secondrd10 secondrd11 secondrd12 secondrd13 secondrd14 secondrd15 secondrd16 secondrd17 secondrd18 using secondrd2.xls, ///
			cells(b(star fmt(%9.3f)) se(par))                ///
             stats(r2_a N, fmt(2) labels( N))      ///
             legend label collabels(none) varlabels(_cons Constant) replace 
			 
 
*****************
*	FIGURE 1	*
*****************
*Figure generated in R using the following data:
svy: mean invalid2 if abst_null_vote>1
lincom _b[invalid] - .0544
			 
*****************
*	FIGURE 2	*
*****************
			 
svy: mprobit abst_null_vote  ing4 newdem22  trust_elec performance ownecon_worse natlecon_worse alienate  interest knowledge protest female q2 agesq ur ed quintall pais2 pais3 pais4 pais5 pais6 pais7 pais8 pais9 pais10 pais11 pais12 pais13 pais14, base(2)
local modN = string(e(N),"%9.0f")
local text3 "N = `modN'"

*identify the pathway telling STATA where to save the margins (end of line)
margins, at(protest=(1 0))  at(knowledge=(1 0)) at(interest=(4 1)) at(alienate=(7 1)) at(natlecon_worse=(1 0)) at(ownecon_worse=(1 0)) at(performance=(7 1)) at(trust_elec=(7 1))   at(newdem22=(1 0)) at(ing4=(7 1))  predict(outcome(2)) atmeans contrast(atcontrast(a(1(2)20)._at)) vce(unconditional) saving("/newprotestmargins.dta", replace)

local n=1
foreach var of varlist protest interest knowledge alienate natlecon_worse ownecon_worse  performance trust_elec newdem22 ing4  {
    local lab`n' : var lab `var'
    local n=`n'+1
    }
	
preserve
clear
* identify the same pathway as above
use "/newprotestmargins.dta"
local ygraph= _N
 gen str name=""
 local i=1
 while `i'<=`ygraph' {
     replace name = "`lab`i''" in `i'
     local i = `i'+1
     }


gen yaxis=_n
labmask yaxis, values(name)

#delimit;
graph twoway rcap _ci_lb _ci_ub yaxis, horiz lcolor(black)
        || sc yaxis _margin ,
         xlab(#6,format(%4.2f) labsize(small) nogrid angle(horizontal) valuelabel)
         xline(0,lcolor("230 103 62")) ytit("")
         ylab(1(1)`ygraph', nogrid labsize(small) angle(horizontal) valuelabel)
        scheme(s1color) graphregion(fcolor(white) margin(small)) plotregion(lwidth(none))
         legend(size(small) order(1) label(1 "95% Confidence Interval (Design-Effect Based)") region(style(none) margin(zero)))
        caption("`text3'" , size(small) pos(1) ring(0))
        note("Source: `=char(0169)' AmericasBarometer by LAPOP", margin(small) size(small) span) ;

restore;

#delimit cr
	 
			 
*****************
*	FIGURE 3	*
*****************

*panel 1

recode abst_null_vote (1=.)(2=1)(3=0), gen(invalidvote)

qui xtmelogit invalidvote female q2 agesq ur ed quintall c.ing4  newdem22 c.trust_elec c.performance  i.ownecon_worse i.natlecon_worse i.compulsory##c.alienate c.knowledge c.interest || pais:
margins, at(alienate=(1 (1) 7) compulsory =(0 1) ) predict(mu fixedonly)
marginsplot, x(alienate) ytitle("Invalid Vote (pct)") recast(line) yline(0) scheme(s1mono)

*panel 2
recode abst_null_vote (1=0)(2=1)(3=.), gen(invalidabst)

qui xtmelogit invalidabst female q2 agesq ur ed quintall c.ing4  newdem22 c.trust_elec c.performance  i.ownecon_worse i.natlecon_worse c.alienate c.knowledge i.compulsory##c.interest || pais:
margins, at(interest=(1(1)4) compulsory =(0 1) ) predict(mu fixedonly)
marginsplot, x(interest) ytitle("Invalid Vote (pct)") recast(line) yline(0) scheme(s1mono)


*****************
*	APPENDIX	*
*****************

*Using the same data file as for the body

*Table A3
corr invalid ing4 newdem22  trust_elec performance ownecon_worse natlecon_worse alienate interest

*Table C2
recode abst_null_vote(1=.)(2=1)(3=0), gen(invalid)
svy: mean invalid, over(pais)

recode vb20(1=.)(2/3=0)(4=1), gen(hypnull)
svy: mean hypnull, over(pais)

*Table C3
*Merge second level data using "secondlevel_formerge.dta" file
drop _merge

gen meaninvalid=.
forvalues i = 2/7 {
	summ invalid if pais == `i'
	replace meaninvalid=r(mean) if pais==`i'
}

forvalues i = 9/14 {
	summ invalid if pais == `i'
	replace meaninvalid=r(mean) if pais==`i'
}

forvalues i = 16/17 {
	summ invalid if pais == `i'
	replace meaninvalid=r(mean) if pais==`i'
}

gen nmeaninvalid=meaninvalid*100
gen diffinvalid=linvalid-nmeaninvalid

preserve 
collapse diffinvalid nmeaninvalid compulsory secondrd efncand linvalid, by(pais)
pcorr nmeaninvalid compulsory secondrd efncand
pcorr diffinvalid compulsory secondrd efncand
restore 

*Table D1
*Generated using "protest motivations data.dta" file
tab vb101, gen(motivations)

local m="motivations1 motivations2 motivations3 motivations4 motivations5 motivations6 motivations7"
foreach x of local m{
probit `x'  c.ing4  newdem22 c.trust_elec c.performance  i.ownecon_worse i.natlecon_worse c.alienate c.knowledge c.interest mujer q2 agesq ur ed quintall i.pais if pais<20
outreg2 using "motivations.doc", append
}

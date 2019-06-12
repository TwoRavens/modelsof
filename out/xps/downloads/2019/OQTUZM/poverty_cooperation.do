*-------------------------------------------------------------------------------------------------------------------------------------------*

// Replication code for "Does poverty undermine cooperation in multiethnic settings? Evidence from a cooperative investment experiment."
// Authors: Max Schaub, Johanna Gereke, Delia Baldassarri
// Publication: Journal of Experimental Political Science
// Date: 25 March 2019

*-------------------------------------------------------------------------------------------------------------------------------------------*

clear all
set more off


*cd // Folder containing do-file (poverty_cooperation.do) and datasets (pc.dta and pc_nt.dta)

log using poverty_cooperation, name(poverty_cooperation) text replace


*------------------------------------*
*-- Coding and subsetting --*
*------------------------------------*

use "pc.dta", clear
save "poverty_cooperation.dta", replace
use "pc.dta", clear
drop if black==1
save "poverty_cooperation_nb.dta", replace
use "pc_nt.dta", clear
save "poverty_cooperation_nt.dta", replace


local filelist poverty_cooperation poverty_cooperation_nb poverty_cooperation_nt

foreach f of local filelist {

use `f', clear

egen agecat = cut(age), at(0 27 33 42 75) icodes // age quartiles
label define agecat 0 "18-26" 1 "27-32" 2 "33-41" 3 "42+", replace
label values agecat agecat

label variable whitepartner "Partner white"  // race dummy
recode whitepartner 0=1 1=0, gen(blackpartner) 
label variable blackpartner "Partner Black"

recode edu 1=1 2=1 3=1 4=1 5=1 6=2 7=2 8=3 9=3 10=3, gen(educat) // education
label define educat 1 "High school" 2 "College degree" 3 "Master's or further", replace
label values educat educat
label variable educat "Education"


recode noccupation 4=7 3=7 5=2, gen(occucat) // occupation
label define occucat 1 "Housework" 2 "Full- or part-time work" 6 "Retired" 7 "Unemployed/in education/other", replace
label values occucat occucat
label variable occucat Occupation

recode nrace (4=1) (7=2) (5=3) (3=4) (1 2 8 6 = 5), gen(race_simpl) // ethnicity
label define race_simpl 5 "Other" 4 "Asian" 1 "Black/African American" 3 "Hispanic" 2 "White", replace
label values race_simpl race_simpl

gen dictatorgiving1 = dictatorgiving/100 // DG 
label variable dictatorgiving1 "Amount sent in DG"

egen inccat = cut(income), at(0 4 6 10) // income
label define inccat 0 "LOW" 4 "MIDDLE" 6 "HIGH", replace
label values inccat inccat

gen income_est = income
recode income_est 0=0 1=.5 2=1.5 3=2.5 4=3.5 5=5 6=7 7=9 8=13
label variable income_est "Annual HH income in $10,000"

drop if doubt_real==1 // drop if doubts that partner was real

save `f', replace

}



//////////////
// Tables ///
////////////

local controls i.female ib1.agecat ib2.race_simpl ib2.educat income hhsize parent ib2.occucat investfirst 


*------------------------------------*
*-- Treatment conditions (Table 1) --*
*------------------------------------*

use "poverty_cooperation.dta", clear

tab highinc whitepartner

*-------------------------------------------*
*-- Results CIG (reported in Table 3, A3) --*
*-------------------------------------------*

use "poverty_cooperation.dta", clear

reg invested highinc, cluster(nsessioncode)
eststo cig_plain
reg invested blackpartner, cluster(nsessioncode)
eststo cig_plain_black
reg invested highinc `controls', cluster(nsessioncode)
eststo cig_controls
reg invested blackpartner `controls', cluster(nsessioncode)
eststo cig_controls_black
reg invested highinc `controls' dictatorgiving , cluster(nsessioncode)
eststo cig_controls_dg
reg invested ib1.highinc#ib1.whitepartner `controls', cluster(nsessioncode)
eststo cig_race
reg invested highinc `controls' if inccat==0, cluster(nsessioncode)
eststo cig_inc_low
reg invested highinc `controls' if inccat==4, cluster(nsessioncode)
eststo cig_inc_middle
reg invested highinc `controls' if inccat==6, cluster(nsessioncode)
eststo cig_inc_high

esttab cig_plain_black cig_controls_black cig_plain cig_controls cig_controls_dg cig_race cig_inc_low cig_inc_middle cig_inc_high, ///
title(Regression of investment behavior on treatment conditions) 


*-------------------------------------------*
*-- 			APPENDIX				  --*
*-------------------------------------------*


*-------------------------------------------*
*-- Results DG (reported in Tables A1, A2) --*
*-------------------------------------------*

reg dictatorgiving1 highinc, cluster(nsessioncode)
eststo dg_plain
reg dictatorgiving1 blackpartner, cluster(nsessioncode)
eststo dg_plain_black
reg dictatorgiving1 highinc `controls', cluster(nsessioncode)
eststo dg_controls
reg dictatorgiving1 blackpartner `controls', cluster(nsessioncode)
eststo dg_controls_black
reg dictatorgiving1 highinc `controls' invested , cluster(nsessioncode)
eststo dg_controls_dg
reg dictatorgiving1 ib1.highinc#ib1.whitepartner `controls', cluster(nsessioncode)
eststo dg_race
reg dictatorgiving1 highinc `controls' if inccat==0, cluster(nsessioncode)
eststo dg_inc_low
reg dictatorgiving1 highinc `controls' if inccat==4, cluster(nsessioncode)
eststo dg_inc_middle
reg dictatorgiving1 highinc `controls' if inccat==6, cluster(nsessioncode)
eststo dg_inc_high

esttab dg_plain_black dg_controls_black dg_plain dg_controls dg_controls_dg dg_race dg_inc_low dg_inc_middle dg_inc_high, ///
title(Regression of dictator game donation on treatment conditions) 




*------------------------------------------------------------------------------*
*-- Results CIG, DG, excluding Black participants (reported in Tables A4, A5) --*
*------------------------------------------------------------------------------*

use "poverty_cooperation_nb.dta", clear

reg invested highinc, cluster(nsessioncode)
eststo nb_cig_plain
reg invested blackpartner, cluster(nsessioncode)
eststo nb_cig_plain_black
reg invested highinc `controls', cluster(nsessioncode)
eststo nb_cig_controls
reg invested blackpartner `controls', cluster(nsessioncode)
eststo nb_cig_controls_black
reg invested highinc `controls' dictatorgiving , cluster(nsessioncode)
eststo nb_cig_controls_dg
reg invested ib1.highinc#ib1.whitepartner `controls', cluster(nsessioncode)
eststo nb_cig_race
reg invested highinc `controls' if inccat==0, cluster(nsessioncode)
eststo nb_cig_inc_low
reg invested highinc `controls' if inccat==4, cluster(nsessioncode)
eststo nb_cig_inc_middle
reg invested highinc `controls' if inccat==6, cluster(nsessioncode)
eststo nb_cig_inc_high

esttab nb_cig_plain_black nb_cig_controls_black nb_cig_plain nb_cig_controls nb_cig_controls_dg nb_cig_race nb_cig_inc_low nb_cig_inc_middle nb_cig_inc_high, ///
title(Regression of investment behavior on treatment conditions, non-Black respondents only) 


reg dictatorgiving1 highinc, cluster(nsessioncode)
eststo nb_dg_plain
reg dictatorgiving1 blackpartner, cluster(nsessioncode)
eststo nb_dg_plain_black
reg dictatorgiving1 highinc `controls', cluster(nsessioncode)
eststo nb_dg_controls
reg dictatorgiving1 blackpartner `controls', cluster(nsessioncode)
eststo nb_dg_controls_black
reg dictatorgiving1 highinc `controls' invested , cluster(nsessioncode)
eststo nb_dg_controls_dg
reg dictatorgiving1 ib1.highinc#ib1.whitepartner `controls', cluster(nsessioncode)
eststo nb_dg_race
reg dictatorgiving1 highinc `controls' if inccat==0, cluster(nsessioncode)
eststo nb_dg_inc_low
reg dictatorgiving1 highinc `controls' if inccat==4, cluster(nsessioncode)
eststo nb_dg_inc_middle
reg dictatorgiving1 highinc `controls' if inccat==6, cluster(nsessioncode)
eststo nb_dg_inc_high

esttab nb_dg_plain_black nb_dg_controls_black nb_dg_plain nb_dg_controls nb_dg_controls_dg nb_dg_race nb_dg_inc_low nb_dg_inc_middle nb_dg_inc_high, ///
title(Regression of dictator game donation on treatment conditions, non-Black respondents only) 



*------------------------------------------------------------------------*
*-- Results CIG, DG, without time dimension (reported in Tables A6, A7) --*
*------------------------------------------------------------------------*

// Excluding time dimension
use "poverty_cooperation_nt.dta", clear

reg invested highinc, cluster(nsessioncode)
eststo nt_cig_plain
reg invested blackpartner, cluster(nsessioncode)
eststo nt_cig_plain_black
reg invested highinc `controls', cluster(nsessioncode)
eststo nt_cig_controls
reg invested blackpartner `controls', cluster(nsessioncode)
eststo nt_cig_controls_black
reg invested highinc `controls' dictatorgiving , cluster(nsessioncode)
eststo nt_cig_controls_dg
reg invested ib1.highinc#ib1.whitepartner `controls', cluster(nsessioncode)
eststo nt_cig_race
reg invested highinc `controls' if inccat==0, cluster(nsessioncode)
eststo nt_cig_inc_low
reg invested highinc `controls' if inccat==4, cluster(nsessioncode)
eststo nt_cig_inc_middle
reg invested highinc `controls' if inccat==6, cluster(nsessioncode)
eststo nt_cig_inc_high

esttab nt_cig_plain_black nt_cig_controls_black nt_cig_plain nt_cig_controls nt_cig_controls_dg nt_cig_race nt_cig_inc_low nt_cig_inc_middle nt_cig_inc_high, ///
title(Regression of investment behavior on treatment conditions, no time dimension) 


reg dictatorgiving1 highinc, cluster(nsessioncode)
eststo nt_dg_plain
reg dictatorgiving1 blackpartner, cluster(nsessioncode)
eststo nt_dg_plain_black
reg dictatorgiving1 highinc `controls', cluster(nsessioncode)
eststo nt_dg_controls
reg dictatorgiving1 blackpartner `controls', cluster(nsessioncode)
eststo nt_dg_controls_black
reg dictatorgiving1 highinc `controls' invested , cluster(nsessioncode)
eststo nt_dg_controls_dg
reg dictatorgiving1 ib1.highinc#ib1.whitepartner `controls', cluster(nsessioncode)
eststo nt_dg_race
reg dictatorgiving1 highinc `controls' if inccat==0, cluster(nsessioncode)
eststo nt_dg_inc_low
reg dictatorgiving1 highinc `controls' if inccat==4, cluster(nsessioncode)
eststo nt_dg_inc_middle
reg dictatorgiving1 highinc `controls' if inccat==6, cluster(nsessioncode)
eststo nt_dg_inc_high

esttab nt_dg_plain_black nt_dg_controls_black nt_dg_plain nt_dg_controls nt_dg_controls_dg nt_dg_race nt_dg_inc_low nt_dg_inc_middle nt_dg_inc_high, ///
title(Regression of dictator game donation on treatment conditions, no time dimension)




*---------------------------------------------------------------*
*-- Results CIG, race of partner as IV (reported in Table A8) --*
*---------------------------------------------------------------*

use "poverty_cooperation", clear

reg invested ib1.highinc#ib1.whitepartner `controls', cluster(nsessioncode)
eststo cig_race
reg invested whitepartner `controls' if inccat==0, cluster(nsessioncode)
eststo cig_white_low
reg invested whitepartner `controls' if inccat==4, cluster(nsessioncode)
eststo cig_white_middle
reg invested whitepartner `controls' if inccat==6, cluster(nsessioncode)
eststo cig_white_high

esttab cig_race cig_white_low cig_white_middle cig_white_high, ///
title(Regression of investment behavior on race of partner, by income category of the participant) 


*--------------------------*
*-- C Summary statistics --*
*--------------------------*

estpost summarize invested dictatorgiving1 female age educat income_est parent hhsize highinc whitepartner investfirst
esttab ., cells("mean(fmt(2)) sd(fmt(2)) min(fmt(2)) max(fmt(2)) count(fmt(0))") nonumber varwidth(35) wrap replace label noobs 




//////////////
// Figures //
////////////



*----------------------------*
*-- CIG overall (Figure 2) --*
*----------------------------*

reg invested highinc##whitepartner `controls', cluster(nsessioncode)
margins highinc##whitepartner, pwcompare(cimargins effects)


*---------------------------------------------------------------------*
*-- Heterogeneous treatment effects by income of partner (Figure 3) --*
*---------------------------------------------------------------------*

reg invested i.highinc `controls' if inccat==0, cluster(nsessioncode)
* MARGINS LOW INCOME
margins highinc, pwcompare(cimargins effects)
reg invested i.highinc `controls' if inccat==4, cluster(nsessioncode)
* MARGINS MIDDLE INCOME
margins highinc, pwcompare(cimargins effects)
reg invested i.highinc `controls' if inccat==6, cluster(nsessioncode)
* MARGINS HIGH INCOME
margins highinc, pwcompare(cimargins effects)


*------------------------------------------------------------------------------*
*-- Appendix: Heterogeneous treatment effects by race of partner (Figure A1) --*
*------------------------------------------------------------------------------*


// Investment behaviour conditional on partner's economic status 

reg invested i.whitepartner `controls' if inccat==0, cluster(nsessioncode)
* MARGINS LOW INCOME
margins whitepartner, pwcompare(cimargins effects)
reg invested i.whitepartner `controls' if inccat==4, cluster(nsessioncode)
* MARGINS MIDDLE INCOME
margins whitepartner, pwcompare(cimargins effects)
reg invested i.whitepartner `controls' if inccat==6, cluster(nsessioncode)
* MARGINS HIGH INCOME
margins whitepartner, pwcompare(cimargins effects)


*--------------------------------------------------*
*-- Sensitivity analysis for margins (Figure A2) --*
*--------------------------------------------------*

cap drop income_alt
recode income 0=1, gen(income_alt)
label define income_alt 1 "$10k" 2 "$20k" 3 "$30k" 4 "$40k" 5 "$60k" 6 "$80k" 7 "$100k" 8 "$100k+"
label values income_alt income_alt
reg invested highinc##income_alt i.female ib1.agecat ib2.race_simpl ib2.educat hhsize parent ib2.occucat investfirst, cluster(nsessioncode)
margins highinc, at(income_alt=(1 (1) 8))
marginsplot, level(90) title("") ytitle("Proportion of participants who invested in CIG") xtitle("Annual HH income") 



log close poverty_cooperation


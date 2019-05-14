cd ".../replication"


*** MAIN TEXT
*** TABLE 1

use analysis_main.dta, clear 



xtset blocks_p

xtreg prejudice_1 treated fem vocational highschool college roma, fe r 
outreg2 treated using aanal1a.xls, bdec(3) sdec(3) br 

xtreg prejudice_2 treated fem vocational highschool college roma, fe r 
outreg2 treated using aanal1a.xls, bdec(3) sdec(3) br append


xtreg prejudice_1 treated fem vocational highschool college roma if outcome_in_both==1 , fe r 
outreg2 treated using aanal1a.xls, bdec(3) sdec(3) br append

xtreg prejudice_2 treated fem vocational highschool college roma if outcome_in_both==1 , fe r 
outreg2 treated using aanal1a.xls, bdec(3) sdec(3) br append

xtreg jobbi treated fem vocational highschool college roma , fe r 
outreg2 treated using aanal1a.xls, bdec(3) sdec(3) br append



*** SUPPORTING INFORMATION




*** Table B1 - Compare analyis sample to sampling frame

** Add back pre-treatment information for those in the sampling frame

use analysis_main.dta, clear 
merge 1:1 sor using pretreatment_covariates.dta


** HLCS, baseline (column 1)

sum age fem roma prejudice_0 o [w=suly]

** Sampling frame (column 2)

sum age fem roma prejudice_0 o if frame==1

** Opted in to study  (column 3)


sum age fem roma prejudice_0 o if started_wave_1==1

** Finished study  (column 4)

sum age fem roma prejudice_0 o if missing_prejudice_wave_2 ==0


*** Table B2 - Compare analyis sample to general pop in terms of prejudice

clear
use heps_individual_outcomes.dta, clear
sum prej_* [w=weight]
use wave0_individual_outcomes.dta,clear
sum prej_* [w=weight]
use  wave1_individual_outcomes.dta, clear
sum prej_* [w=weight]


********
** Predictors of attrition

*** Table C1 - Predicting attrition

replace missing_prejudice_wave_1= missing_prejudice_wave_1*100
replace missing_prejudice_wave_2= missing_prejudice_wave_2*100

gen age_25=age-25

global X prejudice_0 o female age_25 college highschool capital city 

qui foreach x in $X {
	gen treatedX`x'=treated*`x'
}


qui reg missing_prejudice_wave_1 $X if treated==1, robust
 outreg2 using attrition_regressions_gk, word se bdec(3) bracket replace ctitle(1 treated)
qui reg missing_prejudice_wave_1 $X if treated==0, robust
 outreg2 using attrition_regressions_gk, word se bdec(3) bracket append ctitle(1 control)
qui reg missing_prejudice_wave_1 $X treated treatedX* , robust
 outreg2 using attrition_regressions_gk, word se bdec(3) bracket append ctitle(1 pooled)

qui reg missing_prejudice_wave_2 $X if treated==1, robust
 outreg2 using attrition_regressions_gk, word se bdec(3) bracket append ctitle(2 treated)
qui reg missing_prejudice_wave_2 $X if treated==0, robust
 outreg2 using attrition_regressions_gk, word se bdec(3) bracket append ctitle(2 control)
qui reg missing_prejudice_wave_2 $X treated treatedX* , robust
 outreg2 using attrition_regressions_gk, word se bdec(3) bracket append ctitle(2 pooled)


***************************************************************************
***************************************************************************
** ATE estimates assuming attrition on observables
** Table C2
keep if treated==1 | treated==0

cap gen age_25=age-25
global X prejudice_0 o female age_25 college highschool capital city 

qui foreach x in $X {
	cap gen treatedX`x'=treated*`x'
}
qui foreach x in $X {
	sum `x'
	cap gen md_`x'=`x'-r(mean)
	cap gen md_tX`x'=treated*md_`x'
}


** MULTIPLE IMPUTATION
mi set wide
mi register imputed prejudice_1 prejudice_2 jobbik
mi impute chained (regress) prejudice_1 prejudice_2 jobbik = $X treated treatedX*, add(10) 

mi estimate: areg prejudice_1 treated md*, robust absorb(blocks)
 *outreg2 using regs_mi, replace se bdec(3) bra
mi estimate: areg prejudice_2 treated md*, robust absorb(blocks)
 *outreg2 using regs_mi, append se bdec(3) bra
mi estimate: areg jobbik treated md*, robust absorb(blocks)
 *outreg2 using regs_mi, append se bdec(3) bra

** INVERSE PRIBABILITY WEIGHTS

cap gen finished_wave1=1-missing_prejudice_wave_1
cap gen finished_wave2=1-missing_prejudice_wave_2
qui logit finished_wave1 treated $X treatedX*
 qui predict p1
 gen ipw_1=1/p1
qui logit finished_wave2 treated treated $X treatedX*
 qui predict p2
 qui gen ipw_2=1/p2

** weighted regressions
areg prejudice_1 treated md_* [w=ipw_1], r a(blocks)
 outreg2 using regs_ipw, replace se bdec(3) bra
areg prejudice_2 treated md_* [w=ipw_2], r a(blocks)
 outreg2 using regs_ipw, append se bdec(3) bra
areg jobb treated md_* [w=ipw_2], r a(blocks)
 outreg2 using regs_ipw, append se bdec(3) bra
 

** unweighted regressions
foreach Y in prejudice_1 prejudice_2 jobbik {
	areg `Y' treated md*, absorb(blocks) robust
	outreg2 using regs_controls, append se bdec(3) bra
} 

***************************************************************************
** ATE for never-attriters: Loo bound estimates 
** Table C3

** LEE BOUNDS no tightening

leebounds prejudice_1 treated, cie vce(bootstrap)
leebounds prejudice_2 treated, cie vce(bootstrap)
leebounds jobb treated, cie vce(bootstrap)

** LEE BOUNDS tightening with randomization blocks

leebounds prejudice_1 treated, cie vce(bootstrap) tight(blocks)
leebounds prejudice_2 treated, cie vce(bootstrap) tight(blocks)
leebounds jobb treated, cie vce(bootstrap) tight(blocks)

********



*** Table D1 - Transfer effects

 
xtreg ft_home treated fem vocational highschool college roma, fe r 
outreg2  using trans.xls, bdec(1) sdec(1) br 

xtreg ft_refugee treated fem vocational highschool college roma, fe r 
outreg2  using trans.xls, bdec(1) sdec(1) br append

xtreg ft_roma treated fem vocational highschool college roma, fe r 
outreg2  using trans.xls, bdec(1) sdec(1) br append


xtreg ft_old treated fem vocational highschool college roma, fe r 
outreg2  using trans.xls, bdec(1) sdec(1) br append

xtreg ft_pol treated fem vocational highschool college roma, fe r 
outreg2  using trans.xls, bdec(1) sdec(1) br append

xtreg ft_doctor treated fem vocational highschool college roma, fe r 
outreg2  using trans.xls, bdec(1) sdec(1) br append


*** Table D2 - Bivariate regressions


reg prejudice_1 treat, r
outreg2  using araw.xls, bdec(1) sdec(1) br noaster
reg prejudice_2 treat, r
outreg2  using araw.xls, bdec(1) sdec(1) br noaster append
reg ft_homeless treat, r
outreg2  using araw.xls, bdec(1) sdec(1) br noaster append
reg ft_ref treat, r
outreg2  using araw.xls, bdec(1) sdec(1) br noaster append
reg ft_rom treat, r
outreg2  using araw.xls, bdec(1) sdec(1) br noaster append
reg ft_old treat, r
outreg2  using araw.xls, bdec(1) sdec(1) br noaster append
reg ft_pol treat, r
outreg2  using araw.xls, bdec(1) sdec(1) br noaster append
reg ft_doc treat, r
outreg2  using araw.xls, bdec(1) sdec(1) br noaster append

*** Table D3 - Compliance and observed outcomes


tab started_game if treat==1
tab started_game if treat==1 & missing_prejudice_wave_1 ==0
tab started_game if treat==1 & missing_prejudice_wave_2 ==0

*** CACE analysis (discussed in SI, section D)

xtivreg prejudice_2 (started_game =treated) fem vocational highschool college roma, fe 

*** Performance in the placebo game (discussed in SI, section D)

xtreg empathy treated fem vocational highschool college roma, fe r
reg empathy , r


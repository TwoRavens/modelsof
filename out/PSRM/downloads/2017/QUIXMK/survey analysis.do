
*****************************************
*Name: Martin Vinæs Larsen, Derek Beach and Kasper Møller Hansen*
*Date: September 2016*
*Purpose: Replication do-file for analyses in "How campaigns enhance European issues voting during European Parliament elections"*
*Data: survey.dta, survey data*
*Machine: Work Desktop*
*Version 13*
******************************************



* Dependencies: you will need the following packages to run this file
* estout.ado

use  "survey.dta", clear


capture log close
log using survey_results.log, replace



*generating temporary files
tempfile temp1
tempfile temp2
tempfile temp3
tempfile temp4
tempfile temp5

*************************************
*ANALYSIS PART 0: Index construction*
*************************************

* looking at reliability of the two questions comprising the variable "integration"
alpha int_leaveorstay int_advantage

*analyzing straight lining - 14 resp doing this
ta dk_sl

************************
*ANALYSIS PART 1: H1-H3*
************************

* Setting 12 weeks out as baseline
fvset base 12 wave

**Figure 3/Row 1 of table 1
eststo b: reg int_eu int_dk i.wave i.ny_udd i.parlvote c.age i.male , r
margins, over(wave) 
marginsplot, xscale(reverse) ymtick(60(1)70) ylabel(60(2)70, labsize(large)) level(90) ///
 graphregion(col(white)) scheme(s2mono) ytitle("Interest in EU (0-100)" " ", size(large) ) ///
 xtitle(" " "Weeks before the election", size(large)) ///
title(" ") saving(`temp1')

*Figure 4/Row 2 of table 1*
eststo c: reg dk i.wave i.ny_udd i.parlvote c.age i.male, r
margins, over(wave)
marginsplot, xscale(reverse) ymtick(82(1.5)98) ylabel(82(3)98, labsize(large)) level(90) ///
 graphregion(col(white)) scheme(s2mono) ytitle("Average percent informed" " ", size(large)) ///
 xtitle(" " "Weeks before the election", size(large)) ///
 title(" " " ", size(large)) saving(`temp2')

*Figure 5/Row 3 of table 1*
eststo a: reg patent_cor i.wave i.ny_udd i.parlvote c.age i.male, r
margins, over(wave)
marginsplot, xscale(reverse) ylabel(60(5)90, labsize(large)) ymtick(60(2.5)90) level(90) ///
 graphregion(col(white)) scheme(s2mono) xlabel(,labsize(large)) ytitle("Average percent correct" " ", size(large) ) ///
 xtitle(" " "Weeks before the election", size(large)) ///
 title(" ") saving(`temp3')



**Exporting table 1 
esttab b c a  using tabel1.rtf, replace stats(N r2 rmse, label("Observation" "R squared" "RMSE") fmt(%9.0f %9.2f %9.2f) ) ///
keep(1.male age 10.wave 8.wave 6.wave 4.wave 0.wave 2.wave 2.ny_udd 3.ny_udd 4.ny_udd 5.ny_udd 6.ny_udd 7.ny_udd) label ///
varlabel(1.male "Male (ref: Female)" age "Age (years)" 10.wave "10 weeks out (ref: election week)" ///
8.wave "8 weeks out" 6.wave "6 weeks out" 4.wave "4 weeks out" 2.wave "2 weeks out" ///
2.ny_udd "High School (ref: Primary school)" 3.ny_udd "Vocational high school" 4.ny_udd "Vocational school" ///
5.ny_udd "Shorter tertiary education" 6.ny_udd "Tertiary education" 7.ny_udd "Longer tertiary education") ///
star("+" 0.1 "*" 0.05) se b(%9.2f) varwidth(40) title("Table 1. Campaign effects on interest, information and knowledge")

**Exporting figures 4-6
graph use `temp1'
graph export figur3.eps, replace
graph use `temp2'
graph export figur4.eps, replace
graph use `temp3'
graph export figur5.eps, replace


*********************
*ANALYSIS PART 2: H4*
*********************

*changing wave variable to foster easier intepretation
replace wave=12-wave

*saving estimates for table 2
eststo a1: logit gov c.wave##(c.eval) c.econ c.integration c.ideology##c.ideology i.ny_udd i.lgov i.lparty_pro c.age i.male  
eststo b1: logit party_pro c.wave##(c.integration) c.eval c.econ c.ideology##c.ideology i.ny_udd i.lgov i.lparty_pro c.age i.male


**Writing table 2*
esttab a1 b1 using tabel2.rtf, replace stats(N r2_p ll, label("Observation" "Pseudo R squared" "Log likelihood") fmt(%9.0f %9.2f %9.0f) ) ///
keep(ideology econ c.ideology#c.ideology 1.lgov 1.lparty_pro c.wave#c.integration integration eval c.wave#c.eval 1.male age wave 2.ny_udd 3.ny_udd 4.ny_udd 5.ny_udd 6.ny_udd 7.ny_udd) label ///
varlabel(1.male "Male (ref: Female)" age "Age (years)" wave "Time in weeks" c.wave#c.integration "Weeks X Pro-integration" c.wave#c.integration "Weeks X Goverment"   ///
integration "Pro-integration attitude" eval "Pro-government attitude" ///
2.ny_udd "High School (ref: Primary school)" 3.ny_udd "Vocational high school" 4.ny_udd "Vocational school" ///
5.ny_udd "Shorter tertiary education" 6.ny_udd "Tertiary education" 7.ny_udd "Longer tertiary education") ///
star("*" 0.05) se b(%9.2f) varwidth(40) title("Table 2. The degree to which EU attitudes and national politics matter for voters") ///
order(wave   eval integration c.wave#c.eval  c.wave#c.integration econ ideology c.ideology#c.ideology 2.ny_udd 3.ny_udd 4.ny_udd 5.ny_udd 6.ny_udd 7.ny_udd 1.lgov 1.lparty_pro age 1.male)


*changing wave back to draw the figures
replace wave=12-wave


*Left panel of figure 6
logit gov c.wave##(c.eval) c.econ c.integration c.ideology##c.ideology i.ny_udd i.lgov i.lparty_pro c.age i.male 
margins, dydx(eval) at(wave=(0(2)12)) post coeflegend
marginsplot, xscale(reverse) ylabel(, labsize(large)) level(90) ///
 graphregion(col(white)) scheme(s2mono) ytitle("Effect of pro-government attitude" "on voting for governing party" " ", size(large) ) ///
 xtitle(" " "Weeks before the election", size(large)) ///
 name(eval, replace) title( " ") ymtick(0(0.015)0.15) ylab(0.0(0.03)0.15, labsize(large))

 *Wald test for equality of marginal effects - pro-gov; reported in paper
 test _b[1bn._at]==_b[7._at]

*Right panel of figure 6
logit party_pro c.wave##(c.integration) c.eval c.econ c.ideology##c.ideology i.ny_udd i.lgov i.lparty_pro c.age i.male
margins, dydx(integration) at(wave=(0(2)12)) post
marginsplot, xscale(reverse) ylabel(, labsize(large)) level(90) ///
 graphregion(col(white)) scheme(s2mono) ytitle("Effect of pro-integration attitudes" "on voting for pro-EU party" " ", size(large) ) ///
 xtitle(" " "Weeks before the election", size(large)) ///
 name(integrate, replace) title( " ") ymtick(0(0.015)0.15) ylab(0.0(0.03)0.15, labsize(large))

  *Wald test for equality of marginal effects - pro-EU; reported in paper
 test _b[1bn._at]==_b[7._at]
  
  
  
*Exporting figure 6
graph combine eval integrate, xsize(16) ysize(7) scheme(s1mono) 
graph export figure6.eps, replace


 *****************************************
 *ANALYSIS PART 3: Supplementary material*
 *****************************************

*Figure S1
*Placebo test for ideology - government
logit gov c.wave##(c.ideology) c.integration c.eval c.econ  i.ny_udd i.lgov i.lparty_pro c.age i.male 
margins, dydx(ideology) at(wave=(0(2)12))
marginsplot, xscale(reverse) ylabel(, labsize(large)) level(90) ///
 graphregion(col(white)) scheme(s2mono) ytitle("Effect of ideology (Governing parties)" " ", size(large) ) ///
 xtitle(" " "Weeks before the election", size(large)) ///
 name(ideo1, replace) title( " ")   ylab(-0.02(0.01)0.05, labsize(large))


*Placebo test for ideology - party_pro 
logit party_pro c.wave##(c.ideology) c.eval c.integration c.econ i.ny_udd i.lgov i.lparty_pro c.age i.male
margins, dydx(ideology) at(wave=(0(2)12))
marginsplot, xscale(reverse) ylabel(, labsize(large)) level(90) ///
 graphregion(col(white)) scheme(s2mono) ytitle("Effect of ideology (pro-EU)" " ", size(large) ) ///
 xtitle(" " "Weeks before the election", size(large)) ///
 name(ideo2, replace) title( " ") ylab(-0.02(0.01)0.05, labsize(large))

*Exporting figure S1
graph combine ideo1 ideo2, xsize(16) ysize(7) scheme(s1mono) 
graph export s1fig.eps, replace
 
 
*Figure S2
*Alternative independent variable 
logit gov c.wave##(c.econ)  c.ideology##c.ideology  c.integration i.ny_udd i.lgov i.lparty_pro c.age i.male
margins, dydx(econ) at(wave=(0(2)12)) post
marginsplot, xscale(reverse) ylabel(, labsize(large)) level(90) ///
 graphregion(col(white)) scheme(s2mono) yline(0) ytitle("Effect of economic evaluations" "on voting for governing party" " ", size(large) ) ///
 xtitle(" " "Weeks before the election", size(large)) ///
title( " ") ylab(-0.1(0.1)0.3, labsize(large))

 *Exporting figure S2
graph export s2fig.eps, replace
 
*Wald test for equality of marginal effects
test _b[1bn._at]==_b[2._at]==_b[3._at]==_b[4._at]==_b[5._at]==_b[6._at]==_b[7._at]

  
*Table of descriptive statistics (table S1)

*Generating  dummy variables
 tab ny_udd, gen(udd)
 ta wave, gen(waves)
 
 la var udd1 "Primary education"
 la var udd2 "Secondary school"
 la var udd3 "Vocational secondary school"
 la var udd4 "Vocational school"
 la var udd5 "Short tertiary education"
 la var udd6 "Long tertiary education"
 la var udd7 "Longer tertiary education"
 
 la var waves1 "0 weeks out"
 la var waves2 "2 weeks out"
 la var waves3 "4 weeks out"
 la var waves4 "6 weeks out"
 la var waves5 "8 weeks out"
 la var waves6 "10 weeks out"
 la var waves7 "12 weeks out"


 
*Writing table
file open anyname using tabels1.txt, write text replace
file write anyname  _newline  _col(5)  "Table S1: Descriptive statistics" _newline
file write anyname  _newline  _col(5) "Variable" _col(80) "MEAN" _col(90) "STD DEV" _col(100) "MIN" _col(110) "MAX" _col(120) "N"  _newline
 foreach x of varlist eval int_dk int_eu dk patent_cor integration party_pro gov lparty_pro lgov ideology econ male age  udd* waves* {
 su `x', d
 file write anyname  _col(5) `"`: var label `x''"'  _col(80) %9.2f (r(mean)) _col(90) %9.2f (r(sd)) _col(100) %9.2f (r(min)) _col(110) %9.2f  (r(max)) _col(120) (r(N))  _newline
 }
 file close anyname

 *Representativity (table S2, row 2) 
 
 *recoding education variable to match up with data from tatistics Denmark.
 recode ny_udd (1=1 "Elementary") (2 3=2 "Lower Secondary") (4=4 "Vocational") (5=5 "Short tertiary") (6=6 "Medium tertiary") (7=7 "Longer tertiary") , gen(recoded_udd)
 
*defining labels for representativty variables 
label define region  1 "Capital"  2 "Sealand"  3 "Southern Denmark" 4 "Mid-Jutland" 5 "North-Jutland"

label values region region

label define agegrp 1 "18-39" 2 "40-59" 3 "60+"

label values agegrp agegrp region

 
 *numbers to match with table S2
 ta region
 ta male
 ta agegrp
 ta recoded_udd
 
 log close	


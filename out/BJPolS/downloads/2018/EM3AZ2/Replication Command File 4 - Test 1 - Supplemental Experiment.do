***** Replication code for Aarøe & Petersen (2018) "Cognitive Biases and Communication Strength in Social Networks: The Case of Episodic Frames ****

***** replication dofile number 4 ****

/* This do file reproduces analyses related to the supplemental experimental study reported in Test 1 in the main text
and in Online Appendix A3.
* Use the following replication data set: "Replication Data #4 - Test 1 - Supplemental Experiment"
* See the main text and the Online Appendix for details on question wording and coding of the measures */

set more off

*****************************************************************************
* Recodings 
*****************************************************************************

gen epikond=.
replace epikond = optælkond2 if split==1 
replace epikond = optælkond4 if split==3 

gen temkond=.
replace temkond = optælkond1 if split==2 
replace temkond = optælkond3 if split==4

gen recall =.
replace recall = epikond if recall ==.
replace recall = temkond if recall ==.


gen pro =.
replace pro = 1 if split ==1
replace pro = 1 if split ==2
replace pro = 0 if split ==3
replace pro = 0 if split ==4
ta pro

gen epi =.
replace epi = 1 if split ==1
replace epi = 0 if split ==2
replace epi = 1 if split ==3
replace epi = 0 if split ==4

gen epi_rc =1-epi
cor epi_rc epi


gen hold01= q1/6
ta hold01

gen edu = education
recode edu (1=1) (2=3) (3=3) (4=2) (5=4) (6=5) (7=6) (else=.)
gen edu01 = (edu-1)/5
sum edu01

ta household_income
gen nyhousehold_income = household_income
replace nyhousehold_income = . if household_income > 11
gen income01= (nyhousehold_income-1)/10
sum income01

gen female=.
replace female = 1 if gender ==1
replace female = 0 if gender ==2
sum female

*************************************************

*Sample descriptives 
ta female
sum age
ta edu
ta household_income

sum edu01
sum income01

******************************************************************
* Main text: Are episodic frames transmitted more than thematic? *
******************************************************************

* Main text

ttest recall, by(epi)
esize twosample recall, by(epi_rc)

* Footnote 21

ttest wordcount, by(epi)
esize twosample wordcount, by(epi_rc)

****************************************
* Supplemental analyses reproted in A3 *
****************************************

* A3.2

sum epikond temkond
bys epi: sum wordcount

* Figure A7, Panel A

regress recall i.epi, robust
margins i.epi
marginsplot,recast(bar) ciopts(recast(rcap) graphregion(color(white)) lcolor(black)) xscale(range(-.5 1.5)) ///
yscale(range(0 (.05) .25)) ylabel(0(.05).25)  xlabel(1 "Episodic" 0 "Thematic") ///
xtitle("")ytitle("Correct recollection (proportion)") title("") scheme(s1mono) name(recall, replace) 

* Figure A7, Panel B

regress wordcount i.epi, robust
margins i.epi
marginsplot,recast(bar) ciopts(recast(rcap) graphregion(color(white)) lcolor(black)) xscale(range(-.5 1.5)) ///
yscale(range(0 (10) 50)) ylabel(0(10)50)  xlabel(1 "Episodic" 0 "Thematic") ///
 xtitle("")ytitle("Total number of words recollected") title("") scheme(s1mono) name(words, replace) 

* Table A9

eststo clear
eststo: regress recall i.epi, robust
eststo: regress recall i.epi edu01 female age, robust
eststo: regress wordcount i.epi, robust
eststo: regress wordcount i.epi edu01 female age, robust
esttab, b(%5.2f) se(%5.2f), using tableA9.rtf, replace onecell star(* 0.05 ** 0.01 *** 0.001) wide constant r2
eststo clear

* Table A10

eststo clear
eststo: regress recallstem i.epi, robust
eststo: regress recallstem i.epi edu01 female age, robust
esttab, b(%5.2f) se(%5.2f), using TableA10.rtf, replace onecell star(* 0.05 ** 0.01 *** 0.001) wide constant r2
eststo clear

* Table A11

eststo clear
eststo: regress recall i.epi##i.pro, robust
eststo: regress recall i.epi##i.pro edu01 female age, robust
eststo: regress wordcount i.epi##i.pro, robust
eststo: regress wordcount i.epi##i.pro edu01 female age, robust
esttab, b(%5.2f) se(%5.2f), using TableA11.rtf, replace onecell star(* 0.05 ** 0.01 *** 0.001) wide constant r2
eststo clear

* Table A12

eststo clear
eststo: regress recallstem i.epi##i.pro, robust
eststo: regress recallstem i.epi##i.pro edu01 female age, robust
esttab, b(%5.2f) se(%5.2f), using TableA12.rtf, replace onecell star(* 0.05 ** 0.01 *** 0.001) wide constant r2
eststo clear

* Table A13

ttest hold01, by(pro)
bys pro: esize twosample hold01, by(epi_rc)

eststo clear
eststo: regress hold01 i.epi if pro ==1, robust
eststo: regress hold01 i.epi if pro ==0, robust
eststo: regress hold01 i.epi edu01 female age if pro ==1 , robust
eststo: regress hold01 i.epi edu01 female age if pro ==0 , robust
esttab, b(%5.2f) se(%5.2f), using TableA13.rtf, replace onecell star(* 0.05 ** 0.01 *** 0.001) wide constant r2
eststo clear

* Equivalence tests for performed in SPSS

//SUMMARY:  This do file replicates the results for Ballard-Rosa, Martin & Scheve (2016) "The Structure of American Income Tax Policy Preferences"

clear all
set more off

*  ENTER YOUR FILE PATH HERE:
	global dropboxpath = "C:YOUR COMPUTER/FILEPATH"

//To get survey data:
	cd "$dropboxpath/Final version/Data"

//Use dataset created in 01_recode_p.do
	use "us_fullsurvey_taxplan_level.dta", clear

//Identify the survey weigts
	svyset ID [pweight=weight]

//We shorten the labels on the revenue values to compress figure output:
label define short_rev_label 1 ">125%" 2 "105-125%" 3 "95-105%" 4 "75-95%" 5 "<75%"
label values taxrev short_rev_label
//This sets the output scheme used for figures
set scheme s1mono

//Main analysis focuses on individuals who saw revenue levels:
gl rev_condition "saw_revenue == 1"


********************************************************************************

***************			PRIMARY ANALYSIS							

********************************************************************************


//FIGURE 1:  BASELINE RESULTS
//Using survey weights:
reg chose_plan i.taxrate1 i.taxrate2 i.taxrate3 i.taxrate4 i.taxrate5 i.taxrate6 ib5.taxrev if $rev_condition [pweight=weight], cluster(ID)
estimate store baseline_w
local n_baseline = e(N)

coefplot baseline_w, mcolor(black) ciopts(lcolor(black) lwidth(thin)) xlabel(-.3(.1).3) drop(_cons) omitted base xline(0) headings(1.taxrate1 = "{bf:<10k}" 1.taxrate2 = "{bf:10-35k}" 1.taxrate3 = "{bf:35-85k}" 1.taxrate4 = "{bf:85-175k}" 1.taxrate5 = "{bf:175-375k}" 1.taxrate6 = "{bf:>375k}" 1.taxrev = "{bf:Revenue}")  ///
	ylabel(, labsize(medlarge)) xtitle("Change in Pr(Tax Plan Selected)") ytitle("") xsize(5) ysize(7) scale(.6)
graph export "$dropboxpath\Final version\Figures\Baseline results.pdf", as(pdf) replace


//FIGURE 2:  INEQUITY AVERSION
reg chose_plan i.taxrate1 i.taxrate2 i.taxrate3 i.taxrate4 i.taxrate5 i.taxrate6 ib5.taxrev if $rev_condition & ineq_averse_dum == 0 [pweight=weight], cluster(ID)
estimate store not_ineq_averse_w
local n_not_ineq_averse = e(N)
reg chose_plan i.taxrate1 i.taxrate2 i.taxrate3 i.taxrate4 i.taxrate5 i.taxrate6 ib5.taxrev if $rev_condition & ineq_averse_dum == 1 [pweight=weight], cluster(ID)
estimate store ineq_averse_w
local n_ineq_averse = e(N)

coefplot (ineq_averse_w, label(Inequity averse (n=`n_not_ineq_averse')) mcolor(black) ciopts(lcolor(black)) xlabel(-.3(.1).3)) (not_ineq_averse_w, label(Not ineq. averse (n=`n_ineq_averse')) msymbol(circle_hollow) mcolor(black) ciopts(lcolor(black)) xlabel(-.3(.1).3)), ///
	drop(_cons) omitted base xline(0) headings(1.taxrate1 = "{bf:<10k}" 1.taxrate2 = "{bf:10-35k}" 1.taxrate3 = "{bf:35-85k}" 1.taxrate4 = "{bf:85-175k}" 1.taxrate5 = "{bf:175-375k}" 1.taxrate6 = "{bf:>375k}" 1.taxrev = "{bf:Revenue}")  ///
	ylabel(, labsize(medlarge)) xtitle(" Change in Pr(Tax Plan Selected)") ytitle("") xsize(5) ysize(7) scale(.6)
graph export "$dropboxpath\Final version\Figures\Ineq aversion.pdf", as(pdf) replace


//FIGURE 3:  RESULTS BY INCOME GROUP
reg chose_plan i.taxrate1 i.taxrate2 i.taxrate3 i.taxrate4 i.taxrate5 i.taxrate6 ib5.taxrev if $rev_condition & hh_inc == 1 [pweight=weight], cluster(ID)
estimate store hhincome_lt10k
reg chose_plan i.taxrate1 i.taxrate2 i.taxrate3 i.taxrate4 i.taxrate5 i.taxrate6 ib5.taxrev if $rev_condition & (hh_inc == 2 | hh_inc == 3) [pweight=weight], cluster(ID)
estimate store hhincome_10_35k
reg chose_plan i.taxrate1 i.taxrate2 i.taxrate3 i.taxrate4 i.taxrate5 i.taxrate6 ib5.taxrev if $rev_condition & (hh_inc == 4 | hh_inc == 5 | hh_inc == 6) [pweight=weight], cluster(ID)
estimate store hhincome_35_85k
reg chose_plan i.taxrate1 i.taxrate2 i.taxrate3 i.taxrate4 i.taxrate5 i.taxrate6 ib5.taxrev if $rev_condition & (hh_inc == 7 | hh_inc == 8 | hh_inc == 9) [pweight=weight], cluster(ID)
estimate store hhincome_85_175k
reg chose_plan i.taxrate1 i.taxrate2 i.taxrate3 i.taxrate4 i.taxrate5 i.taxrate6 ib5.taxrev if $rev_condition & (hh_inc == 10 | hh_inc == 11 | hh_inc == 12) [pweight=weight], cluster(ID)
estimate store hhincome_175_375k
reg chose_plan i.taxrate1 i.taxrate2 i.taxrate3 i.taxrate4 i.taxrate5 i.taxrate6 ib5.taxrev if $rev_condition & hh_inc == 13 [pweight=weight], cluster(ID)
estimate store hhincome_gt375k

//TO PUT ALL INCOME GROUPS ON SAME GRAPH (CREATES 3 FIGURES):
coefplot(hhincome_lt10k, label(<10K) msymbol(circle_hollow) mcolor(black) msize(large) ciopts(lcolor(black)) lwidth(thin) xlabel(-.3(.1).3)) (hhincome_10_35k, label(10-35K) msymbol(circle) mcolor(gs13) msize(large) ciopts(lcolor(black)) lwidth(thin) xlabel(-.3(.1).3)) ///
	(hhincome_35_85k, label(35-85K) msymbol(circle) mcolor(gs9) msize(large) ciopts(lcolor(black)) lwidth(thin) xlabel(-.3(.1).3)) (hhincome_85_175k, label(85-175K) msymbol(circle) mcolor(gs5) msize(large) ciopts(lcolor(black)) lwidth(thin) xlabel(-.3(.1).3)) ///
	(hhincome_175_375k, label(175-375K) msymbol(circle) mcolor(black) msize(large) ciopts(lcolor(black)) lwidth(thin) xlabel(-.3(.1).3)), ///
	drop(_cons 1.taxrev 2.taxrev 3.taxrev 4.taxrev 5.taxrev 1.taxrate3 2.taxrate3 3.taxrate3 4.taxrate3 1.taxrate4 2.taxrate4 3.taxrate4 4.taxrate4 1.taxrate5 2.taxrate5 3.taxrate5 4.taxrate5 5.taxrate5 1.taxrate6 2.taxrate6 3.taxrate6 4.taxrate6 5.taxrate6 6.taxrate6) omitted base xline(0) headings(1.taxrate1 = "{bf:<10k}" 1.taxrate2 = "{bf:10-35k}" 1.taxrate3 = "{bf:35-85k}" 1.taxrate4 = "{bf:85-175k}" 1.taxrate5 = "{bf:175-375k}" 1.taxrate6 = "{bf:>375k}" 1.taxrev = "{bf:Revenue}")  ///
	ylabel(, labsize(medlarge)) xtitle(" Change in Pr(Tax Plan Selected)") ytitle("") xsize(2.5) ysize(5) scale(.75)
graph export "$dropboxpath\Final version\Figures\Lower 2 tax brackets (by own income).pdf", as(pdf) replace

coefplot(hhincome_lt10k, label(<10K) msymbol(circle_hollow) mcolor(black) msize(large) ciopts(lcolor(black)) lwidth(thin) xlabel(-.3(.1).3)) (hhincome_10_35k, label(10-35K) msymbol(circle) mcolor(gs13) msize(large) ciopts(lcolor(black)) lwidth(thin) xlabel(-.3(.1).3)) ///
	(hhincome_35_85k, label(35-85K) msymbol(circle) mcolor(gs9) msize(large) ciopts(lcolor(black)) lwidth(thin) xlabel(-.3(.1).3)) (hhincome_85_175k, label(85-175K) msymbol(circle) mcolor(gs5) msize(large) ciopts(lcolor(black)) lwidth(thin) xlabel(-.3(.1).3)) ///
	(hhincome_175_375k, label(175-375K) msymbol(circle) mcolor(black) msize(large) ciopts(lcolor(black)) lwidth(thin) xlabel(-.3(.1).3)) , ///
	drop(_cons 1.taxrev 2.taxrev 3.taxrev 4.taxrev 5.taxrev 1.taxrate1 2.taxrate1 3.taxrate1 4.taxrate1 1.taxrate2 2.taxrate2 3.taxrate2 4.taxrate2 1.taxrate5 2.taxrate5 3.taxrate5 4.taxrate5 5.taxrate5 1.taxrate6 2.taxrate6 3.taxrate6 4.taxrate6 5.taxrate6 6.taxrate6) omitted base xline(0) headings(1.taxrate1 = "{bf:<10k}" 1.taxrate2 = "{bf:10-35k}" 1.taxrate3 = "{bf:35-85k}" 1.taxrate4 = "{bf:85-175k}" 1.taxrate5 = "{bf:175-375k}" 1.taxrate6 = "{bf:>375k}" 1.taxrev = "{bf:Revenue}")  ///
	ylabel(, labsize(medlarge)) xtitle(" Change in Pr(Tax Plan Selected)") ytitle("") xsize(2.5) ysize(5) scale(.75)
graph export "$dropboxpath\Final version\Figures\Middle 2 tax brackets (by own income).pdf", as(pdf) replace

coefplot(hhincome_lt10k, label(<10K) msymbol(circle_hollow) mcolor(black) msize(large) ciopts(lcolor(black)) lwidth(thin) xlabel(-.3(.1).3)) (hhincome_10_35k, label(10-35K) msymbol(circle) mcolor(gs13) msize(large) ciopts(lcolor(black)) lwidth(thin) xlabel(-.3(.1).3)) ///
	(hhincome_35_85k, label(35-85K) msymbol(circle) mcolor(gs9) msize(large) ciopts(lcolor(black)) lwidth(thin) xlabel(-.3(.1).3)) (hhincome_85_175k, label(85-175K) msymbol(circle) mcolor(gs5) msize(large) ciopts(lcolor(black)) lwidth(thin) xlabel(-.3(.1).3)) ///
	(hhincome_175_375k, label(175-375K) msymbol(circle) mcolor(black) msize(large) ciopts(lcolor(black)) lwidth(thin) xlabel(-.3(.1).3)) , ///
	drop(_cons 1.taxrev 2.taxrev 3.taxrev 4.taxrev 5.taxrev 1.taxrate1 2.taxrate1 3.taxrate1 4.taxrate1 1.taxrate2 2.taxrate2 3.taxrate2 4.taxrate2 1.taxrate3 2.taxrate3 3.taxrate3 4.taxrate3 1.taxrate4 2.taxrate4 3.taxrate4 4.taxrate4) omitted base xline(0) headings(1.taxrate1 = "{bf:<10k}" 1.taxrate2 = "{bf:10-35k}" 1.taxrate3 = "{bf:35-85k}" 1.taxrate4 = "{bf:85-175k}" 1.taxrate5 = "{bf:175-375k}" 1.taxrate6 = "{bf:>375k}" 1.taxrev = "{bf:Revenue}")  ///
	ylabel(, labsize(medlarge)) xtitle(" Change in Pr(Tax Plan Selected)") ytitle("") xsize(2.5) ysize(5) scale(.75)
graph export "$dropboxpath\Final version\Figures\Top 2 tax brackets (by own income).pdf", as(pdf) replace


//FIGURE 4:  TAX EFFICIENCY
reg chose_plan i.taxrate1 i.taxrate2 i.taxrate3 i.taxrate4 i.taxrate5 i.taxrate6 ib5.taxrev if $rev_condition & taxes_harm == 1 [pweight=weight], cluster(ID)
est store taxes_help_w
local n_taxes_help = e(N)
reg chose_plan i.taxrate1 i.taxrate2 i.taxrate3 i.taxrate4 i.taxrate5 i.taxrate6 ib5.taxrev if $rev_condition & taxes_harm == 2 [pweight=weight], cluster(ID)
est store taxes_hurt_w
local n_taxes_hurt = e(N)
reg chose_plan i.taxrate1 i.taxrate2 i.taxrate3 i.taxrate4 i.taxrate5 i.taxrate6 ib5.taxrev if $rev_condition & taxes_harm == 3 [pweight=weight], cluster(ID)
est store taxes_noeff_w
local n_taxes_noeff = e(N)

coefplot (taxes_help_w, label(Taxes help (n=`n_taxes_help')) mcolor(black) ciopts(lcolor(black)) xlabel(-.3(.1).3)) (taxes_hurt_w, label(Taxes harm (n=`n_taxes_hurt')) msymbol(circle_hollow) mcolor(black) ciopts(lcolor(black)) xlabel(-.3(.1).3)), ///
	drop(_cons) omitted base xline(0) headings(1.taxrate1 = "{bf:<10k}" 1.taxrate2 = "{bf:10-35k}" 1.taxrate3 = "{bf:35-85k}" 1.taxrate4 = "{bf:85-175k}" 1.taxrate5 = "{bf:175-375k}" 1.taxrate6 = "{bf:>375k}" 1.taxrev = "{bf:Revenue}")  ///
	ylabel(, labsize(medlarge)) xtitle(" Change in Pr(Tax Plan Selected)") ytitle("") xsize(5) ysize(7) scale(.6)
graph export "$dropboxpath\Final version\Figures\Tax help or hurt.pdf", as(pdf) replace

	
//FIGURE 5:  FAIRNESS & PARTISANSHIP
//NOTE:  THIS FIGURE CONSTRUCTED FROM 3 SUB-FIGURES, EACH GENERATED BELOW:

//FIGURE 5A: HARD WORK VS LUCK
reg chose_plan i.taxrate1 i.taxrate2 i.taxrate3 i.taxrate4 i.taxrate5 i.taxrate6 ib5.taxrev if $rev_condition & (work_vs_luck == 2 | work_vs_luck == 3) [pweight=weight], cluster(ID)
est store luck_w
local n_luck = e(N)
reg chose_plan i.taxrate1 i.taxrate2 i.taxrate3 i.taxrate4 i.taxrate5 i.taxrate6 ib5.taxrev if $rev_condition & work_vs_luck == 1 [pweight=weight], cluster(ID)
est store hard_work_w
local n_hard_work = e(N)

coefplot (hard_work_w, label(Hard work (n=`n_hard_work')) mcolor(black) msize(large) ciopts(lcolor(black)) xlabel(-.3(.1).3)) (luck_w, label(Luck (n=`n_luck')) msymbol(circle_hollow) mcolor(black) msize(large) ciopts(lcolor(black)) xlabel(-.3(.1).3)), ///
	drop(_cons) omitted base xline(0) headings(1.taxrate1 = "{bf:<10k}" 1.taxrate2 = "{bf:10-35k}" 1.taxrate3 = "{bf:35-85k}" 1.taxrate4 = "{bf:85-175k}" 1.taxrate5 = "{bf:175-375k}" 1.taxrate6 = "{bf:>375k}" 1.taxrev = "{bf:Revenue}")  ///
	ylabel(, labsize(medlarge)) xtitle(" Change in Pr(Tax Plan Selected)") ytitle("") xsize(2.5) ysize(5) scale(.75)
graph export "$dropboxpath\Final version\Figures\Luck vs hard work (thin).pdf", as(pdf) replace

//FIGURE 5B:  RACIAL RESENTMENT
reg chose_plan i.taxrate1 i.taxrate2 i.taxrate3 i.taxrate4 i.taxrate5 i.taxrate6 ib5.taxrev if $rev_condition & race == 1 & above_avg_racial == 0  [pweight=weight], cluster(ID)
est store low_resent_w
local n_low_resent = e(N)
reg chose_plan i.taxrate1 i.taxrate2 i.taxrate3 i.taxrate4 i.taxrate5 i.taxrate6 ib5.taxrev if $rev_condition & race == 1 & above_avg_racial == 1  [pweight=weight], cluster(ID)
est store high_resent_w
local n_high_resent = e(N)

coefplot (low_resent_w, label(Low resent. (n=`n_low_resent')) mcolor(black) msize(large) ciopts(lcolor(black)) xlabel(-.3(.1).3)) (high_resent_w, label(High resent. (n=`n_high_resent')) msymbol(circle_hollow) mcolor(black) msize(large) ciopts(lcolor(black)) xlabel(-.3(.1).3)), ///
	drop(_cons) omitted base xline(0) headings(1.taxrate1 = "{bf:<10k}" 1.taxrate2 = "{bf:10-35k}" 1.taxrate3 = "{bf:35-85k}" 1.taxrate4 = "{bf:85-175k}" 1.taxrate5 = "{bf:175-375k}" 1.taxrate6 = "{bf:>375k}" 1.taxrev = "{bf:Revenue}")  ///
	ylabel(, labsize(medlarge)) xtitle(" Change in Pr(Tax Plan Selected)") ytitle("") xsize(2.5) ysize(5) scale(.75)
graph export "$dropboxpath\Final version\Figures\Racial resentment (thin).pdf", as(pdf) replace

//FIGURE 5C:  PARTISANSHIP
reg chose_plan i.taxrate1 i.taxrate2 i.taxrate3 i.taxrate4 i.taxrate5 i.taxrate6 ib5.taxrev if $rev_condition & repub_7pt == 1 [pweight=weight], cluster(ID)
estimate store repub_w
local n_repub = e(N)
reg chose_plan i.taxrate1 i.taxrate2 i.taxrate3 i.taxrate4 i.taxrate5 i.taxrate6 ib5.taxrev if $rev_condition & democ_7pt == 1 [pweight=weight], cluster(ID)
estimate store democ_w
local n_democ = e(N)
reg chose_plan i.taxrate1 i.taxrate2 i.taxrate3 i.taxrate4 i.taxrate5 i.taxrate6 ib5.taxrev if $rev_condition & indep_7pt == 1 [pweight=weight], cluster(ID)
estimate store indep_w
local n_indep = e(N)

coefplot (repub_w, label(Repub. (n=`n_repub')) mcolor(black) ciopts(lcolor(black)) xlabel(-.3(.1).3)) (democ_w, label(Democ. (n=`n_democ')) msymbol(circle_hollow) mcolor(black) ciopts(lcolor(black)) xlabel(-.3(.1).3)), ///
	drop(_cons) omitted base xline(0) headings(1.taxrate1 = "{bf:<10k}" 1.taxrate2 = "{bf:10-35k}" 1.taxrate3 = "{bf:35-85k}" 1.taxrate4 = "{bf:85-175k}" 1.taxrate5 = "{bf:175-375k}" 1.taxrate6 = "{bf:>375k}" 1.taxrev = "{bf:Revenue}")  ///
	ylabel(, labsize(medlarge)) xtitle(" Change in Pr(Tax Plan Selected)") ytitle("") xsize(2.5) ysize(5) scale(.75)
graph export "$dropboxpath\Final version\Figures\Dem vs Rep (thin).pdf", as(pdf) replace

********************************************************************************
********************************************************************************

* Replication code for Stefanie Reher, "Mind This Gap, Too: Political Orientations 
* of People with Disabilities in Europe", forthcoming in Political Behavior 

********************************************************************************
********************************************************************************

* The dataset "dataset_ESScombined.dta" is constructed by combining data from Rounds 
* 1-7 of the European Social Survey (ESS) (see citations at the end of the script). 
* The original data along with questionnaires and codebooks can be obtained from 
* https://www.europeansocialsurvey.org/data/.

********************************************************************************

* to run the code, save the dataset "dataset_ESScombined.dta" in a folder 
* and insert the path to the folder below:
global folder "..."

* load DTA file (code below) or import CSV file
use $folder\Reher_PoBe2018.dta, clear

* generate normalised versions of all continuous dependent variables (range=0-1)
foreach v in inefficacy exefficacy poltrust {
gen `v'_c = `v'/10
}
gen polinterest_c = polinterest/3

* sample identifier including observations with no missing values on the key control 
* variables, resources and discrimination measures
gen sample=0
replace sample=1 if age!=. & female!=. & immigbg!=. & eduyears!=. & income!=. & workplace!=. & meet!=. & church!=. & disab_discrim!=.

egen countrytag=tag(country)

* Below, the code for the models reported in the tables and the figures is provided 
* in the order of appearance in the article.

********************************************************************************
********************************************************************************

*** Figure 1: Percentage of respondents indicating a disability by country

tabstat disability2, by(country), [aweight=pspwght]

********************************************************************************
********************************************************************************

*** Figure 2: Disability gaps in political orientations by country

gen inef_coef=.
gen inef_se=.
foreach c in 2 3 5 7 8 9 11 12 13 14 17 18 22 25 26 27 28 31 32  {
qui regress inefficacy_c c.age##c.age female immigbg disability2 i.year [pweight=pspwght] if country==`c' & sample==1
replace inef_coef = _b[disability2] if country==`c' 
replace inef_se = _se[disability2] if country==`c' 
}
gen exef_coef=.
gen exef_se=.
foreach c in 2 3 5 7 8 9 11 12 13 14 17 18 22 25 26 27 28 31 32 {
qui regress exefficacy_c c.age##c.age female immigbg disability2 i.year [pweight=pspwght] if country==`c' & sample==1
replace exef_coef = _b[disability2] if country==`c' 
replace exef_se = _se[disability2] if country==`c' 
}
gen trust_coef=.
gen trust_se=.
foreach c in 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 20 21 22 23 24 25 26 27 28 29 31 32 33 {
qui regress poltrust_c c.age##c.age female immigbg disability2 i.year [pweight=pspwght] if country==`c' & sample==1
replace trust_coef = _b[disability2] if country==`c' 
replace trust_se = _se[disability2] if country==`c' 
}
gen interest_coef=.
gen interest_se=.
foreach c in 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 20 21 22 23 24 25 26 27 28 29 31 32 33 {
qui regress polinterest_c c.age##c.age female immigbg disability2 i.year [pweight=pspwght] if country==`c' & sample==1
replace interest_coef = _b[disability2] if country==`c' 
replace interest_se = _se[disability2] if country==`c' 
}
gen turnout_coef=.
gen turnout_se=.
foreach c in 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 20 21 22 23 24 25 26 27 28 29 31 32 33 {
qui logit turnout c.age##c.age female immigbg disability2 i.year [pweight=pspwght] if country==`c' & sample==1
replace turnout_coef = _b[disability2] if country==`c' 
replace turnout_se = _se[disability2] if country==`c' 
}

foreach v in inef exef interest trust turnout {
cap drop cilo_`v' cihi_`v' `v'_avcoef rank_`v'
gen cilo_`v'=`v'_coef-(1.96*`v'_se)
gen cihi_`v'=`v'_coef+(1.96*`v'_se)
egen `v'_avcoef=mean(`v'_coef) if countrytag==1 
egen rank_`v'=rank(`v'_coef) if countrytag==1 
}

sum inef_avcoef 
eclplot inef_coef cilo_inef cihi_inef rank_inef, hor rplot(rspike) estopts(color(black)) ciopts(color(black)) ///
	legend(off) title("Internal efficacy", size(vlarge) color(black)) xtitle("Coefficient of disability") ///
	ytitle(" ") ylabel(none) xlabel(-0.1(.05).05) graphr(color(white)) plotr(color(white)) xline(0, lc(black)) ///
	xline(-.0291509, lp(dash) lc(black)) addplot(scatter rank_inef cilo_inef, msym(none) mlabcol(black) mlabpos(9) ///
	mlab(country)) name(ineffplot, replace)
	
sum exef_avcoef
eclplot exef_coef cilo_exef cihi_exef rank_exef, hor rplot(rspike) estopts(color(black)) ciopts(color(black)) ///
	legend(off) title("External efficacy", size(vlarge) color(black)) xtitle("Coefficient of disability") ///
	ytitle(" ") ylabel(none) xlabel(-0.1(.05).05) graphr(color(white)) plotr(color(white)) xline(0, lc(black)) ///
	xline(-.030465, lp(dash) lc(black)) addplot(scatter rank_exef cilo_exef, msym(none) mlabcol(black) mlabpos(9) /// 
	mlab(country)) name(exeffplot, replace)

sum trust_avcoef
eclplot trust_coef cilo_trust cihi_trust rank_trust, hor rplot(rspike) estopts(color(black)) ciopts(color(black)) ///
	legend(off) title("Political trust", size(vlarge) color(black)) xtitle("Coefficient of disability") ///
	ytitle(" ") ylabel(none) xlabel(-0.1(.05).05) graphr(color(white)) plotr(color(white)) xline(0, lc(black)) ///
	xline(-.0281525, lp(dash) lc(black)) addplot(scatter rank_trust cilo_trust, msym(none) mlabcol(black) mlabpos(9) ///
	mlab(country)) name(trustplot, replace)

sum interest_avcoef
eclplot interest_coef cilo_interest cihi_interest rank_interest, hor rplot(rspike) estopts(color(black)) ciopts(color(black)) ///
	legend(off) title("Political interest", size(vlarge) color(black)) xtitle("Coefficient of disability") ///
	ytitle(" ") ylabel(none) xlabel(-0.1(.05).05) graphr(color(white)) plotr(color(white)) xline(0, lc(black)) ///
	xline(-.026878, lp(dash) lc(black)) addplot(scatter rank_interest cilo_interest, msym(none) mlabcol(black) mlabpos(9) ///
	mlab(country)) name(interestplot, replace)

sum turnout_avcoef
eclplot turnout_coef cilo_turnout cihi_turnout rank_turnout, hor rplot(rspike) estopts(color(black)) ciopts(color(black)) ///
	legend(off) title("Turnout", size(vlarge) color(black)) xtitle("Coefficient of disability") ytitle(" ") ylabel(none) ///
	xlabel(-1.5(.5)0.5) graphr(color(white)) plotr(color(white)) xline(0, lc(black)) xline(-.3313628, lp(dash) lc(black)) ///
	addplot(scatter rank_turnout cilo_turnout, msym(none) mlabcol(black) mlabpos(9) mlab(country)) name(turnoutplot, replace)

* Difference in predicted probability of turnout
gen turnout_pred=.
gen cilo_turnout_pred=.
gen cihi_turnout_pred=.
gen agesq=age*age

sum year1-year14 if country==2 & sample==1
qui logit turnout age agesq female disability2 year4 year6 year13 year14 [pweight=pspwght] if country==2 & sample==1
qui prvalue, x(disability2=0) rest(mean) save
prvalue, x(disability2=1) rest(mean) dif 
replace turnout_pred=-0.0526 			if country==2
replace cilo_turnout_pred= -0.0816			if country==2
replace cihi_turnout_pred= -0.0236			if country==2

sum year1-year14 if country==3 & sample==1
qui logit turnout age agesq female disability2 year2-year11 year13 year14 [pweight=pspwght] if country==3 & sample==1
qui prvalue, x(disability2=0) rest(mean) save
prvalue, x(disability2=1) rest(mean) dif 
replace turnout_pred=-0.0247  		if country==3
replace cilo_turnout_pred= -0.0406			if country==3
replace cihi_turnout_pred= -0.0088    	if country==3

sum year1-year14 if country==4 & sample==1
qui logit turnout age agesq female disability2 year9 year10 year12 [pweight=pspwght] if country==4 & sample==1
qui prvalue, x(disability2=0) rest(mean) save
prvalue, x(disability2=1) rest(mean) dif 
replace turnout_pred=-0.0517 	if country==4
replace cilo_turnout_pred= -0.0905	if country==4
replace cihi_turnout_pred= -0.0129	if country==4

sum year1-year14 if country==5 & sample==1
qui logit turnout age agesq female disability2 year2-year14 [pweight=pspwght] if country==5 & sample==1
qui prvalue, x(disability2=0) rest(mean) save
prvalue, x(disability2=1) rest(mean) dif 
replace turnout_pred=-0.0743  	if country==5
replace cilo_turnout_pred= 	-0.1048		if country==5
replace cihi_turnout_pred= 	-0.0439		if country==5

sum year1-year14 if country==6 & sample==1
qui logit turnout age agesq female disability2 year10-year12 [pweight=pspwght] if country==6 & sample==1
qui prvalue, x(disability2=0) rest(mean) save
prvalue, x(disability2=1) rest(mean) dif 
replace turnout_pred=-0.0160  		if country==6
replace cilo_turnout_pred=	-0.0617		if country==6
replace cihi_turnout_pred= 	0.0297		if country==6

sum year1-year14 if country==7 & sample==1
qui logit turnout age agesq female disability2 year2 year3 year8 year10 year12-year14 [pweight=pspwght] if country==7 & sample==1
qui prvalue, x(disability2=0) rest(mean) save
prvalue, x(disability2=1) rest(mean) dif 
replace turnout_pred=-0.0449			if country==7
replace cilo_turnout_pred= 	-0.0764		if country==7
replace cihi_turnout_pred= 	-0.0134		if country==7

sum year1-year14 if country==8 & sample==1
qui logit turnout age agesq female disability2 year2-year14 [pweight=pspwght] if country==8 & sample==1
qui prvalue, x(disability2=0) rest(mean) save
prvalue, x(disability2=1) rest(mean) dif 
replace turnout_pred= -0.0583  			if country==8
replace cilo_turnout_pred= 	-0.0763		if country==8
replace cihi_turnout_pred= -0.0403		if country==8

sum year1-year14 if country==9 & sample==1
qui logit turnout age agesq female disability2 year2-year10 year12-year14 [pweight=pspwght] if country==9 & sample==1
qui prvalue, x(disability2=0) rest(mean) save
prvalue, x(disability2=1) rest(mean) dif 
replace turnout_pred=-0.0298 		if country==9
replace cilo_turnout_pred= 	-0.0433		if country==9
replace cihi_turnout_pred= 	-0.0162		if country==9

sum year1-year14 if country==10 & sample==1
qui logit turnout age agesq female disability2 year8 year9 year11 year12 [pweight=pspwght] if country==10 & sample==1
qui prvalue, x(disability2=0) rest(mean) save
prvalue, x(disability2=1) rest(mean) dif 
replace turnout_pred=-0.0594 			if country==10
replace cilo_turnout_pred=	-0.0945		if country==10
replace cihi_turnout_pred= 	-0.0244	if country==10

sum year1-year14 if country==11 & sample==1
qui logit turnout age agesq female disability2 year2-year7 year10 year12 year14 [pweight=pspwght] if country==11 & sample==1
qui prvalue, x(disability2=0) rest(mean) save
prvalue, x(disability2=1) rest(mean) dif 
replace turnout_pred=-0.0708  	if country==11
replace cilo_turnout_pred= 	-0.1004		if country==11
replace cihi_turnout_pred= -0.0412		if country==11

sum year1-year14 if country==12 & sample==1
qui logit turnout age agesq female disability2 year3 year5 year7-year9 year11-year14 [pweight=pspwght] if country==12 & sample==1
qui prvalue, x(disability2=0) rest(mean) save
prvalue, x(disability2=1) rest(mean) dif 
replace turnout_pred=-0.0506  	if country==12
replace cilo_turnout_pred= 	-0.0677	if country==12
replace cihi_turnout_pred= 	-0.0334	if country==12

sum year1-year14 if country==13 & sample==1
qui logit turnout age agesq female disability2 year4-year10 year12-year14 [pweight=pspwght] if country==13 & sample==1
qui prvalue, x(disability2=0) rest(mean) save
prvalue, x(disability2=1) rest(mean) dif 
replace turnout_pred=-0.0597  	if country==13
replace cilo_turnout_pred= 	-0.0882	if country==13
replace cihi_turnout_pred= 	-0.0312	if country==13

sum year1-year14 if country==14 & sample==1
qui logit turnout age agesq female disability2 year2-year14 [pweight=pspwght] if country==14 & sample==1
qui prvalue, x(disability2=0) rest(mean) save
prvalue, x(disability2=1) rest(mean) dif 
replace turnout_pred= -0.0571  	if country==14
replace cilo_turnout_pred= 	-0.0813	if country==14
replace cihi_turnout_pred= -0.0329	if country==14

sum year1-year14 if country==15 & sample==1
qui logit turnout age agesq female disability2 year4 year8 year10  [pweight=pspwght] if country==15 & sample==1
qui prvalue, x(disability2=0) rest(mean) save
prvalue, x(disability2=1) rest(mean) dif 
replace turnout_pred=-0.0033  	if country==15
replace cilo_turnout_pred= 	-0.0269	if country==15
replace cihi_turnout_pred= 	0.0203	if country==15

sum year1-year14 if country==16 & sample==1
qui logit turnout age agesq female disability2 year8-year10 [pweight=pspwght] if country==16 & sample==1
qui prvalue, x(disability2=0) rest(mean) save
prvalue, x(disability2=1) rest(mean) dif 
replace turnout_pred=-0.0743	if country==16
replace cilo_turnout_pred= 	-0.1333	if country==16
replace cihi_turnout_pred= 	-0.0152	if country==16

sum year1-year14 if country==17 & sample==1
qui logit turnout age agesq female disability2 year8 year9 year11 year12 year14 [pweight=pspwght] if country==17 & sample==1
qui prvalue, x(disability2=0) rest(mean) save
prvalue, x(disability2=1) rest(mean) dif 
replace turnout_pred=-0.0603 	if country==17
replace cilo_turnout_pred= -0.0930	if country==17
replace cihi_turnout_pred= -0.0276	if country==17

sum year1-year14 if country==18 & sample==1
qui logit turnout age agesq female disability2 year5 year6 year8-year14 [pweight=pspwght] if country==18 & sample==1
qui prvalue, x(disability2=0) rest(mean) save
prvalue, x(disability2=1) rest(mean) dif 
replace turnout_pred=-0.0397   	if country==18
replace cilo_turnout_pred= 	-0.0672	if country==18
replace cihi_turnout_pred= 	-0.0122	if country==18

sum year1-year14 if country==20 & sample==1
qui logit turnout age agesq female disability2 year11 year12 [pweight=pspwght] if country==20 & sample==1
qui prvalue, x(disability2=0) rest(mean) save
prvalue, x(disability2=1) rest(mean) dif 
replace turnout_pred=-0.0410    	if country==20
replace cilo_turnout_pred= 	-0.0898	if country==20
replace cihi_turnout_pred= 	0.0078	if country==20

sum year1-year14 if country==21 & sample==1
qui logit turnout age agesq female disability2 year12 [pweight=pspwght] if country==21 & sample==1
qui prvalue, x(disability2=0) rest(mean) save
prvalue, x(disability2=1) rest(mean) dif 
replace turnout_pred=-0.0600  	if country==21
replace cilo_turnout_pred= 	-0.1273	if country==21
replace cihi_turnout_pred=	0.0072	if country==21

sum year1-year14 if country==22 & sample==1
qui logit turnout age agesq female disability2 year12 year14 [pweight=pspwght] if country==22 & sample==1
qui prvalue, x(disability2=0) rest(mean) save
prvalue, x(disability2=1) rest(mean) dif 
replace turnout_pred=-0.0532  	if country==22
replace cilo_turnout_pred= -0.1043 if country==22
replace cihi_turnout_pred=-0.0022		if country==22

sum year1-year14 if country==23 & sample==1
qui logit turnout age agesq female disability2 year3 year4 [pweight=pspwght] if country==23 & sample==1
qui prvalue, x(disability2=0) rest(mean) save
prvalue, x(disability2=1) rest(mean) dif 
replace turnout_pred= -0.0859  	if country==23
replace cilo_turnout_pred= -0.1644 if country==23
replace cihi_turnout_pred=-0.0074		if country==23

sum year1-year14 if country==24 & sample==1
qui logit turnout age agesq female disability2 [pweight=pspwght] if country==24 & sample==1
qui prvalue, x(disability2=0) rest(mean) save
prvalue, x(disability2=1) rest(mean) dif 
replace turnout_pred=-0.0556    	if country==24
replace cilo_turnout_pred=-0.1239 		if country==24
replace cihi_turnout_pred=0.0127	if country==24

sum year1-year14 if country==25 & sample==1
qui logit turnout age agesq female disability2 year2-year14 [pweight=pspwght] if country==25 & sample==1
qui prvalue, x(disability2=0) rest(mean) save
prvalue, x(disability2=1) rest(mean) dif 
replace turnout_pred=-0.0565   	if country==25
replace cilo_turnout_pred= -0.0741		if country==25
replace cihi_turnout_pred=-0.0389	if country==25

sum year1-year14 if country==26 & sample==1
qui logit turnout age agesq female disability2 year2-year5 year7-year13 [pweight=pspwght] if country==26 & sample==1
qui prvalue, x(disability2=0) rest(mean) save
prvalue, x(disability2=1) rest(mean) dif 
replace turnout_pred=-0.0527   	if country==26
replace cilo_turnout_pred=-0.0722		if country==26
replace cihi_turnout_pred=-0.0333		if country==26

sum year1-year14 if country==27 & sample==1
qui logit turnout age agesq female disability2 year3 year5 year7-year12 year14 [pweight=pspwght] if country==27 & sample==1
qui prvalue, x(disability2=0) rest(mean) save
prvalue, x(disability2=1) rest(mean) dif 
replace turnout_pred=-0.0483   	if country==27
replace cilo_turnout_pred= -0.0729		if country==27
replace cihi_turnout_pred=-0.0238	if country==27

sum year1-year14 if country==28 & sample==1
qui logit turnout age agesq female disability2 year2-year8 year11 year12 year14 [pweight=pspwght] if country==28 & sample==1
qui prvalue, x(disability2=0) rest(mean) save
prvalue, x(disability2=1) rest(mean) dif 
replace turnout_pred=-0.0510 	if country==28
replace cilo_turnout_pred= -0.0895	if country==28
replace cihi_turnout_pred=-0.0126	if country==28

sum year1-year14 if country==29 & sample==1
qui logit turnout age agesq female disability2 year8 [pweight=pspwght] if country==29 & sample==1
qui prvalue, x(disability2=0) rest(mean) save
prvalue, x(disability2=1) rest(mean) dif 
replace turnout_pred=-0.0628  	if country==29
replace cilo_turnout_pred= -0.1415		if country==29
replace cihi_turnout_pred=	0.0160	if country==29

sum year1-year14 if country==31 & sample==1
qui logit turnout age agesq female disability2 year3-year14 [pweight=pspwght] if country==31 & sample==1
qui prvalue, x(disability2=0) rest(mean) save
prvalue, x(disability2=1) rest(mean) dif 
replace turnout_pred=-0.0197   	if country==31
replace cilo_turnout_pred= -0.0323		if country==31
replace cihi_turnout_pred=	-0.0071	if country==31

sum year1-year14 if country==32 & sample==1
qui logit turnout age agesq female disability2 year3 year5 year7-year11 year13 year14 [pweight=pspwght] if country==32 & sample==1
qui prvalue, x(disability2=0) rest(mean) save
prvalue, x(disability2=1) rest(mean) dif 
replace turnout_pred=-0.0489  	if country==32
replace cilo_turnout_pred=-0.0757 		if country==32
replace cihi_turnout_pred=-0.0222	if country==32

sum year1-year14 if country==33 & sample==1
qui logit turnout age agesq female disability2 year5 year6 year9-year12 [pweight=pspwght] if country==33 & sample==1
qui prvalue, x(disability2=0) rest(mean) save
prvalue, x(disability2=1) rest(mean) dif 
replace turnout_pred=-0.0339    	if country==33
replace cilo_turnout_pred=-0.0715 	if country==33
replace cihi_turnout_pred=0.0038	if country==33

cap drop turnout_pred_avcoef rank_turnout_pred
egen turnout_pred_avcoef=mean(turnout_pred) if countrytag==1 
egen rank_turnout_pred = rank(turnout_pred) if countrytag==1

sum turnout_pred_avcoef
eclplot turnout_pred cilo_turnout_pred cihi_turnout_pred rank_turnout_pred, hor rplot(rspike) ///
	estopts(color(black)) ciopts(color(black)) legend(off) title("Turnout", size(vlarge) color(black)) ///
	xtitle("Difference in predicted probability") ytitle(" ") ylabel(none) xlabel(-0.15(.05)0) ///
	graphr(color(white)) plotr(color(white)) xline(0, lc(black)) xline(-.0499, lp(dash) lc(black)) ///
	addplot(scatter rank_turnout_pred cilo_turnout_pred, msym(none) mlabcol(black) mlabpos(9) mlab(country)) ///
	name(turnoutpredplot, replace)

graph combine ineffplot exeffplot trustplot interestplot turnoutplot turnoutpredplot, col(3) ///
	graphregion(fcolor(white) ilcolor(white) lcolor(white)) xsize(6) ysize(3) 
graph save Graph $folder\Figure2.gph, replace
graph export "C:\Users\srb17203\Dropbox\Disability-study\Data\plots\Plots_PoBe_final\Figure2.png", replace width(5000)

********************************************************************************
********************************************************************************

*** Figure 3: Disability gap in resources

foreach c in 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 20 21 22 23 24 25 26 27 28 29 31 32 33 {
gen country`c'=1 if country==`c'
}
svyset [pweight=pspwght]
foreach i in eduyears income workplace meet church {
cap drop `i'_diff `i'_diffse
gen `i'_diff=.
gen `i'_diffse=.

foreach c in 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 20 21 22 23 24 25 26 27 28 29 31 32 33 {
qui svy, subpop(country`c'): mean `i', over(disability2), if sample==1
quietly lincom [`i']Yes - [`i']No
replace `i'_diff=r(estimate) if country==`c'
replace `i'_diffse=r(se) if country==`c'
}
cap drop cilo`i' cihi`i' rank_`i'
gen cilo`i'=`i'_diff-(1.96*`i'_diffse)
gen cihi`i'=`i'_diff+(1.96*`i'_diffse)
egen rank_`i' = rank(`i'_diff) if countrytag==1 
}
sum eduyears_diff if countrytag==1
eclplot eduyears_diff ciloeduyears cihieduyears rank_eduyears, hor rplot(rspike) estopts(color(black)) ///
	ciopts(color(black)) legend(off) title("Education", size(vlarge) color(black)) xtitle(" ") ytitle(" ") ///
	ylabel(none) xlabel(-5(1)0) graphr(color(white)) plotr(color(white)) xline(0, lc(black)) ///
	xline(-1.812, lp(dash) lc(black)) addplot(scatter rank_eduyears ciloeduyears, msym(none) mlabcol(black) ///
	mlabpos(9) mlab(country)) name(eduplot, replace)

sum income_diff if countrytag==1
eclplot income_diff ciloincome cihiincome rank_income, hor rplot(rspike) estopts(color(black)) ///
	ciopts(color(black)) legend(off) title("Income", size(vlarge) color(black)) xtitle(" ") ytitle(" ") ///
	ylabel(none) xlabel(-2(1)0) graphr(color(white)) plotr(color(white)) xline(0, lc(black)) ///
	xline(-1.296, lp(dash) lc(black)) addplot(scatter rank_income ciloincome, msym(none) mlabcol(black) ///
	mlabpos(9) mlab(country)) name(incomeplot, replace)

sum workplace_diff if countrytag==1
eclplot workplace_diff ciloworkplace cihiworkplace rank_workplace, hor rplot(rspike) estopts(color(black)) ///
	ciopts(color(black)) legend(off) title("Workplace", size(vlarge) color(black)) xtitle(" ") ytitle(" ") ///
	ylabel(none) xlabel(-.5(.1)0) graphr(color(white)) plotr(color(white)) xline(0, lc(black)) ///
	xline(-.3487, lp(dash) lc(black)) addplot(scatter rank_workplace ciloworkplace, msym(none) mlabcol(black) ///
	mlabpos(9) mlab(country)) name(workplot, replace)

sum meet_diff if countrytag==1
eclplot meet_diff cilomeet cihimeet rank_meet, hor rplot(rspike) estopts(color(black)) ciopts(color(black)) ///
	legend(off) title("Social integration", size(large) color(black)) xtitle(" ") ytitle(" ") ylabel(none) ///
	xlabel(-1(.5)0) graphr(color(white)) plotr(color(white)) xline(0, lc(black)) xline(-.44514, lp(dash) ///
	lc(black)) addplot(scatter rank_meet cilomeet, msym(none) mlabcol(black) mlabpos(9) mlab(country)) ///
	name(meetplot, replace)

sum church_diff if countrytag==1
eclplot church_diff cilochurch cihichurch rank_church, hor rplot(rspike) estopts(color(black)) ciopts(color(black)) ///
	legend(off) title("Religious service attendance", size(large) color(black)) xtitle(" ") ytitle(" ") ///
	ylabel(none) xlabel(0(.1).2) graphr(color(white)) plotr(color(white)) xline(0, lc(black)) ///
	xline(0.0575766, lp(dash) lc(black)) addplot(scatter rank_church cilochurch, msym(none) mlabcol(black) mlabpos(9) ///
	mlab(country)) name(churchplot, replace)

graph combine eduplot incomeplot workplot meetplot churchplot, col(3) ///
	graphregion(fcolor(white) ilcolor(white) lcolor(white)) xsize(6) ysize(3) 
graph save Graph $folder\Figure3.gph, replace
graph export $folder\Figure3.png, replace width(5000)


********************************************************************************
********************************************************************************

*** Table 1: Multilevel linear regression of internal and external efficacy on disability and controls

* M1a
mixed inefficacy_c disability2 c.age##c.age female immigbg i.year [pweight=pspwght] if sample==1 || country: 
est store inefficacy1
* M1b
mixed inefficacy_c disability2 c.age##c.age female immigbg eduyears income workplace meet church i.year [pweight=pspwght] if sample==1 || country: 
est store inefficacy2
* M1c
mixed inefficacy_c i.disab_discrim c.age##c.age female immigbg i.year [pweight=pspwght] if sample==1 || country:
est store inefficacy3
	* reference category for discrimination = 1:
	mixed inefficacy_c ib1.disab_discrim c.age##c.age female immigbg i.year [pweight=pspwght] if sample==1 || country:
* M1d
mixed inefficacy_c i.disab_discrim c.age##c.age female immigbg eduyears income workplace meet church i.year [pweight=pspwght] if sample==1 || country:
est store inefficacy4
	mixed inefficacy_c ib1.disab_discrim c.age##c.age female immigbg eduyears income workplace meet church i.year [pweight=pspwght] if sample==1 || country:

* M2a
mixed exefficacy_c disability2 c.age##c.age female immigbg i.year [pweight=pspwght] if sample==1 || country: 
est store exefficacy1
* M2b
mixed exefficacy_c disability2 c.age##c.age female immigbg eduyears income workplace meet church i.year [pweight=pspwght] if sample==1 || country: 
est store exefficacy2
* M2c
mixed exefficacy_c i.disab_discrim c.age##c.age female immigbg i.year [pweight=pspwght] if sample==1 || country:
est store exefficacy3
	mixed exefficacy_c ib1.disab_discrim c.age##c.age female immigbg i.year [pweight=pspwght] if sample==1 || country:
* M2d
mixed exefficacy_c i.disab_discrim c.age##c.age female immigbg eduyears income workplace meet church i.year [pweight=pspwght] if sample==1 || country:
est store exefficacy4
	mixed exefficacy_c ib1.disab_discrim c.age##c.age female immigbg eduyears income workplace meet church i.year [pweight=pspwght] if sample==1 || country:

esttab inefficacy1 inefficacy2 inefficacy3 inefficacy4 exefficacy1 exefficacy2 exefficacy3 exefficacy4 ///
	using $folder\Table1.rtf, replace b(%10.3f) se bic obslast star(* 0.05 ** 0.01 *** 0.001) ///
	mtitles ("(a)" "(b)" "(c)" "(d)" "(a)" "(b)" "(c)" "(d)") label	nogaps compress  nonumbers /// 
	order(disability2 disab_discrim age age#age female immigbg eduyears income workplace meet church) ///
	coeflabels(disability2 "Disability" age "Age" age#age "Age squared" female "Female" immigbg "Immigration backgound" ///
	eduyears "Education" income "Income" workplace "Workplace" meet "Social integration" church "Religious attendance") nonotes

* One resource included at a time:
mixed inefficacy_c disability2 c.age##c.age female immigbg eduyears i.year [pweight=pspwght] if sample==1 || country: 
mixed inefficacy_c disability2 c.age##c.age female immigbg  income i.year [pweight=pspwght] if sample==1 || country: 
mixed inefficacy_c disability2 c.age##c.age female immigbg  workplace  i.year [pweight=pspwght] if sample==1 || country: 
mixed inefficacy_c disability2 c.age##c.age female immigbg  meet  i.year [pweight=pspwght] if sample==1 || country: 
mixed inefficacy_c disability2 c.age##c.age female immigbg church i.year [pweight=pspwght] if sample==1 || country: 

mixed exefficacy_c disability2 c.age##c.age female immigbg eduyears i.year [pweight=pspwght] if sample==1 || country: 
mixed exefficacy_c disability2 c.age##c.age female immigbg  income i.year [pweight=pspwght] if sample==1 || country: 
mixed exefficacy_c disability2 c.age##c.age female immigbg  workplace  i.year [pweight=pspwght] if sample==1 || country: 
mixed exefficacy_c disability2 c.age##c.age female immigbg  meet  i.year [pweight=pspwght] if sample==1 || country: 
mixed exefficacy_c disability2 c.age##c.age female immigbg church i.year [pweight=pspwght] if sample==1 || country: 
	
********************************************************************************
********************************************************************************

*** Table 2: Multilevel linear regression of political trust and interest on disability and controls

* M3a
mixed poltrust_c disability2 c.age##c.age female immigbg i.year [pweight=pspwght] if sample==1 || country: 
est store trust1
* M3b
mixed poltrust_c disability2 c.age##c.age female immigbg eduyears income workplace meet church i.year [pweight=pspwght] if sample==1 || country: 
est store trust2
* M3c
mixed poltrust_c i.disab_discrim c.age##c.age female immigbg i.year [pweight=pspwght] if sample==1 || country:
est store trust3
	* diff ref cat:
	mixed poltrust_c ib1.disab_discrim c.age##c.age female immigbg i.year [pweight=pspwght] if sample==1 || country:
* M3d
mixed poltrust_c i.disab_discrim c.age##c.age female immigbg eduyears income workplace meet church i.year [pweight=pspwght] if sample==1 || country:
est store trust4
	* diff ref cat
	mixed poltrust_c ib1.disab_discrim c.age##c.age female immigbg eduyears income workplace meet church i.year [pweight=pspwght] if sample==1 || country:
* M3e
mixed poltrust_c i.disab_discrim c.age##c.age female immigbg eduyears income workplace meet church exefficacy_c i.year [pweight=pspwght] if sample==1 || country: 
est store trust5
	* diff ref cat
	mixed poltrust_c ib1.disab_discrim c.age##c.age female immigbg eduyears income workplace meet church exefficacy_c i.year [pweight=pspwght] if sample==1 || country:

* M4a
mixed polinterest_c disability2 c.age##c.age female immigbg i.year [pweight=pspwght] if sample==1 || country: 
est store polint1
* M4b
mixed polinterest_c disability2 c.age##c.age female immigbg eduyears income workplace meet church i.year [pweight=pspwght] if sample==1 || country: 
est store polint2
* M4c
mixed polinterest_c i.disab_discrim c.age##c.age female immigbg i.year [pweight=pspwght] if sample==1 || country:
est store polint3
	* diff ref cat
	mixed polinterest_c ib1.disab_discrim c.age##c.age female immigbg i.year [pweight=pspwght] if sample==1 || country:
* M4d
mixed polinterest_c i.disab_discrim c.age##c.age female immigbg eduyears income workplace meet church i.year [pweight=pspwght] if sample==1 || country:
est store polint4
	* diff ref cat
	mixed polinterest_c ib1.disab_discrim c.age##c.age female immigbg eduyears income workplace meet church i.year [pweight=pspwght] if sample==1 || country:

esttab trust1 trust2 trust3 trust4 trust5 polint1 polint2 polint3 polint4 ///
	using $folder\Table2.rtf, replace b(%10.3f) se bic obslast star(* 0.05 ** 0.01 *** 0.001) ///
	mtitles ("(a)" "(b)" "(c)" "(d)" "(e)" "(a)" "(b)" "(c)" "(d)") label	nogaps compress  nonumbers /// 
	order(disability2 disab_discrim age age#age female immigbg eduyears income workplace meet church) ///
	coeflabels(disability2 "Disability" age "Age" age#age "Age squared" female "Female" immigbg "Immigration backgound" ///
	eduyears "Education" income "Income" workplace "Workplace" meet "Social integration" church "Religious attendance") nonotes

	* Comparing M3d (external efficacy) with M3c using the same sample
mixed poltrust_c i.disab_discrim c.age##c.age female immigbg eduyears income workplace meet church i.year [pweight=pspwght] ///
	if sample==1 & exefficacy_c!=. || country: 
	* diff ref cat
	mixed poltrust_c ib1.disab_discrim c.age##c.age female immigbg eduyears income workplace meet church i.year [pweight=pspwght] ///
	if sample==1 & exefficacy_c!=. || country:

* One resource at a time:
mixed poltrust_c disability2 c.age##c.age female immigbg eduyears i.year [pweight=pspwght] if sample==1 || country: 
mixed poltrust_c disability2 c.age##c.age female immigbg  income i.year [pweight=pspwght] if sample==1 || country: 
mixed poltrust_c disability2 c.age##c.age female immigbg  workplace  i.year [pweight=pspwght] if sample==1 || country: 
mixed poltrust_c disability2 c.age##c.age female immigbg  meet  i.year [pweight=pspwght] if sample==1 || country: 
mixed poltrust_c disability2 c.age##c.age female immigbg church i.year [pweight=pspwght] if sample==1 || country: 

mixed polinterest_c disability2 c.age##c.age female immigbg eduyears i.year [pweight=pspwght] if sample==1 || country: 
mixed polinterest_c disability2 c.age##c.age female immigbg  income i.year [pweight=pspwght] if sample==1 || country: 
mixed polinterest_c disability2 c.age##c.age female immigbg  workplace  i.year [pweight=pspwght] if sample==1 || country: 
mixed polinterest_c disability2 c.age##c.age female immigbg  meet  i.year [pweight=pspwght] if sample==1 || country: 
mixed polinterest_c disability2 c.age##c.age female immigbg church i.year [pweight=pspwght] if sample==1 || country: 

********************************************************************************
********************************************************************************

*** Table 3: Multilevel logistic regression of turnrout on disability and controls
*** Table 4: Predicted probabilities of turnout among voters with and without disabilities

* M5a
melogit turnout disability2 c.age##c.age female immigbg i.year [pweight=pspwght] if sample==1 || country: 
est store turnout1 
margins, at(disability2==(0 1))
* M5b
melogit turnout disability2 c.age##c.age female immigbg eduyears income workplace meet church i.year [pweight=pspwght] if sample==1 || country: 
est store turnout2
margins, at(disability2==(0 1))
* M5c
melogit turnout i.disab_discrim c.age##c.age female immigbg i.year [pweight=pspwght] if sample==1 || country:
est store turnout3
margins, at(disab_discrim==(0 1 2))
	* diff ref cat
	melogit turnout ib1.disab_discrim c.age##c.age female immigbg i.year [pweight=pspwght] if sample==1 || country:
* M5d
melogit turnout i.disab_discrim c.age##c.age female immigbg eduyears income workplace meet church i.year [pweight=pspwght] if sample==1 || country:
est store turnout4
margins, at(disab_discrim==(0 1 2))
	* diff ref cat
	melogit turnout ib1.disab_discrim c.age##c.age female immigbg eduyears income workplace meet church i.year [pweight=pspwght] if sample==1 || country:
* M5e
melogit turnout i.disab_discrim c.age##c.age female immigbg eduyears income workplace meet church polinterest pid5 i.year [pweight=pspwght] if sample==1 || country:
est store turnout5
margins, at(disab_discrim==(0 1 2))
	* diff ref cat
	melogit turnout ib1.disab_discrim c.age##c.age female immigbg eduyears income workplace meet church polinterest pid5 i.year [pweight=pspwght] if sample==1 || country:

esttab turnout1 turnout2 turnout3 turnout4 turnout5 ///
	using $folder\Table3.rtf, replace b(%10.3f) se bic obslast star(* 0.05 ** 0.01 *** 0.001) ///
	mtitles ("(a)" "(b)" "(c)" "(d)" "(e)") label	nogaps compress  nonumbers /// 
	order(disability2 age age#age female immigbg eduyears income workplace meet church) ///
	coeflabels(disability2 "Disability" age "Age" age#age "Age squared" female "Female" immigbg "Immigration backgound" ///
	eduyears "Education" income "Income" workplace "Workplace" meet "Social integration" church "Religious attendance") nonotes

	
********************************************************************************
********************************************************************************
********************************************************************************

*** SUPPLEMENTARY INFORMATION

*** Table A1: descriptives
svyset [pweight=pspwght]
svy: mean inefficacy_c exefficacy_c poltrust_c polinterest_c turnout disability2 disab_discrim ///
	age female immigbg eduyears income workplace meet church pid5
sum inefficacy_c exefficacy_c poltrust_c polinterest_c turnout disability2 disab_discrim ///
	age female immigbg eduyears income workplace meet church pid5
foreach v in inefficacy_c exefficacy_c poltrust_c polinterest_c turnout disability2 disab_discrim ///
	age female immigbg eduyears income workplace meet church pid5 {
	codebook country if `v'!=.
}

********************************************************************************
*** Table B1: interest and turnout by age group
svyset [pweight=pspwght]
foreach v in polinterest_c turnout {
svy: mean `v', over(disability2), if sample==1 & age<31
lincom [`v']No - [`v']Yes
svy: mean `v', over(disability2), if sample==1 & age>30 & age<46
lincom [`v']No - [`v']Yes
svy: mean `v', over(disability2), if sample==1 & age>45 & age<66
lincom [`v']No - [`v']Yes
svy,: mean `v', over(disability2), if sample==1 & age>65
lincom [`v']No - [`v']Yes
}

********************************************************************************
*** Table C1

mixed inefficacy_c disability2 i.year [pweight=pspwght] if sample==1 || country: 
est store model1 
mixed exefficacy_c disability2 i.year [pweight=pspwght] if sample==1 || country: 
est store model2
mixed poltrust_c disability2 i.year [pweight=pspwght] if sample==1 || country: 
est store model3
mixed polinterest_c disability2 i.year [pweight=pspwght] if sample==1 || country: 
est store model4
melogit turnout disability2 i.year [pweight=pspwght] if sample==1 || country: 
est store model5

esttab model1 model2 model3 model4 model5	using $folder\TableC1.rtf, replace  ///
	b(%10.3f) se bic obslast star(* 0.05 ** 0.01 *** 0.001) ///
	mtitles ("Internal efficacy" "External efficacy" "Political trust" "Political interest" "Turnout") ///
	label nogaps compress nonumbers coeflabels(disability2 "Disability") nonotes
		
********************************************************************************
*** Table C2

meologit polinterest disability2 c.age##c.age female immigbg i.year [pweight=pspwght] if sample==1 || country: 
est store polint1
meologit polinterest disability2 c.age##c.age female immigbg eduyears income workplace meet church i.year [pweight=pspwght] if sample==1 || country: 
est store polint2
meologit polinterest i.disab_discrim c.age##c.age female immigbg i.year [pweight=pspwght] if sample==1 || country:
est store polint3
meologit polinterest ib1.disab_discrim c.age##c.age female immigbg i.year [pweight=pspwght] if sample==1 || country:
est store polint3a
meologit polinterest i.disab_discrim c.age##c.age female immigbg eduyears income workplace meet church i.year [pweight=pspwght] if sample==1 || country:
est store polint4
meologit polinterest ib1.disab_discrim c.age##c.age female immigbg eduyears income workplace meet church i.year [pweight=pspwght] if sample==1 || country:
est store polint4a

esttab polint1 polint2 polint3 polint4 using $folder\TableC2.rtf, replace b(%10.3f) ///
	se bic obslast star(* 0.05 ** 0.01 *** 0.001) mtitles ("(a)" "(b)" "(c)" "(d)" "(e)") ///
	label nogaps compress  nonumbers order(disability2 age age#age female immigbg eduyears workplace meet church) ///
	coeflabels(disability2 "Disability" age "Age" age#age "Age squared" female "Female" immigbg "Immigration backgound" ///
	eduyears "Education" income "Income" workplace "Workplace" meet "Social integration" church "Religious attendance") nonotes
	
********************************************************************************
*** Table C3

regress inefficacy_c disability2 c.age##c.age female immigbg i.year i.country [pweight=pspwght] if sample==1 , cluster(country)
est store inefficacy1
regress inefficacy_c disability2 c.age##c.age female immigbg eduyears income workplace meet church i.year i.country [pweight=pspwght] if sample==1 , cluster(country)
est store inefficacy2
regress inefficacy_c i.disab_discrim c.age##c.age female immigbg i.year i.country [pweight=pspwght] if sample==1 , cluster(country)
est store inefficacy3
regress inefficacy_c ib1.disab_discrim c.age##c.age female immigbg i.year i.country [pweight=pspwght] if sample==1 , cluster(country)
est store inefficacy3a
regress inefficacy_c i.disab_discrim c.age##c.age female immigbg eduyears income workplace meet church i.year i.country [pweight=pspwght] if sample==1 , cluster(country)
est store inefficacy4
regress inefficacy_c ib1.disab_discrim c.age##c.age female immigbg eduyears income workplace meet church i.year i.country [pweight=pspwght] if sample==1 , cluster(country)
est store inefficacy4a

regress exefficacy_c disability2 c.age##c.age female immigbg i.year i.country [pweight=pspwght] if sample==1 , cluster(country)
est store exefficacy1
regress exefficacy_c disability2 c.age##c.age female immigbg eduyears income workplace meet church i.year i.country [pweight=pspwght] if sample==1 , cluster(country)
est store exefficacy2
regress exefficacy_c i.disab_discrim c.age##c.age female immigbg i.year i.country [pweight=pspwght] if sample==1 , cluster(country)
est store exefficacy3
regress exefficacy_c ib1.disab_discrim c.age##c.age female immigbg i.year i.country [pweight=pspwght] if sample==1 , cluster(country)
est store exefficacy3a
regress exefficacy_c i.disab_discrim c.age##c.age female immigbg eduyears income workplace meet church  i.year i.country [pweight=pspwght] if sample==1 , cluster(country)
est store exefficacy4
regress exefficacy_c ib1.disab_discrim c.age##c.age female immigbg eduyears income workplace meet church  i.year i.country [pweight=pspwght] if sample==1 , cluster(country)
est store exefficacy4a

esttab inefficacy1 inefficacy2 inefficacy3 inefficacy4 exefficacy1 exefficacy2 exefficacy3 exefficacy4 ///
	using $folder\TableC3.rtf, replace b(%10.3f) se r2 obslast star(* 0.05 ** 0.01 *** 0.001) ///
	mtitles ("(a)" "(b)" "(c)" "(d)" "(a)" "(b)" "(c)" "(d)") label	nogaps compress  nonumbers /// 
	order(disability2 age age#age female immigbg eduyears income workplace meet church) ///
	coeflabels(disability2 "Disability" age "Age" age#age "Age squared" female "Female" immigbg "Immigration backgound" ///
	eduyears "Education" income "Income" workplace "Workplace" meet "Social integration" church "Religious attendance") nonotes

********************************************************************************
*** Table C4

regress poltrust_c disability2 c.age##c.age female immigbg i.year i.country [pweight=pspwght] if sample==1 , cluster(country)
est store trust1
regress poltrust_c disability2 c.age##c.age female immigbg eduyears income workplace meet church i.year i.country [pweight=pspwght] if sample==1 , cluster(country)
est store trust2
regress poltrust_c i.disab_discrim c.age##c.age female immigbg eduyears income workplace meet church i.year i.country [pweight=pspwght] if sample==1 , cluster(country)
est store trust3
regress poltrust_c ib1.disab_discrim c.age##c.age female immigbg  i.year i.country [pweight=pspwght] if sample==1 , cluster(country)
est store trust3a
regress poltrust_c i.disab_discrim c.age##c.age female immigbg  i.year i.country [pweight=pspwght] if sample==1 , cluster(country)
est store trust4
regress poltrust_c ib1.disab_discrim c.age##c.age female immigbg eduyears income workplace meet church i.year i.country [pweight=pspwght] if sample==1 , cluster(country)
est store trust4a
regress poltrust_c i.disab_discrim c.age##c.age female immigbg eduyears income workplace meet church exefficacy_c i.year i.country [pweight=pspwght] if sample==1 , cluster(country)
est store trust5
regress poltrust_c ib1.disab_discrim c.age##c.age female immigbg eduyears income workplace meet church exefficacy_c i.year i.country [pweight=pspwght] if sample==1 , cluster(country)
est store trust5a

regress polinterest_c disability2 i.year i.country [pweight=pspwght] if sample==1, cluster(country)
regress polinterest_c disability2 c.age##c.age female immigbg i.year i.country [pweight=pspwght] if sample==1 , cluster(country)
est store interest1
regress polinterest_c disability2 c.age##c.age female immigbg eduyears income workplace meet church i.year i.country [pweight=pspwght] if sample==1 , cluster(country)
est store interest2
regress polinterest_c i.disab_discrim c.age##c.age female immigbg  i.year i.country [pweight=pspwght] if sample==1 , cluster(country)
est store interest3
regress polinterest_c ib1.disab_discrim c.age##c.age female immigbg i.year i.country [pweight=pspwght] if sample==1 , cluster(country)
est store interest3a
regress polinterest_c i.disab_discrim c.age##c.age female immigbg eduyears income workplace meet church i.year i.country [pweight=pspwght] if sample==1 , cluster(country)
est store interest4
regress polinterest_c ib1.disab_discrim c.age##c.age female immigbg eduyears income workplace meet church i.year i.country [pweight=pspwght] if sample==1 , cluster(country)
est store interest4a

esttab trust1 trust2 trust3 trust4 trust5 interest1 interest2 interest3 interest4 ///
	using $folder\TableC4.rtf, replace b(%10.3f) se r2 obslast star(* 0.05 ** 0.01 *** 0.001) ///
	mtitles ("(a)" "(b)" "(c)" "(d)" "(e)" "(a)" "(b)" "(c)" "(d)") label	nogaps compress  nonumbers /// 
	order(disability2 age age#age female immigbg eduyears income workplace meet church) ///
	coeflabels(disability2 "Disability" age "Age" age#age "Age squared" female "Female" immigbg "Immigration backgound" ///
	eduyears "Education" income "Income" workplace "Workplace" meet "Social integration" church "Religious attendance") nonotes

********************************************************************************
*** Table C5

logit turnout disability2 c.age##c.age female immigbg i.year i.country [pweight=pspwght] if sample==1 , cluster(country)
est store turnout1
logit turnout disability2 c.age##c.age female immigbg eduyears income workplace meet church i.year i.country [pweight=pspwght] if sample==1 , cluster(country)
est store turnout2
logit turnout i.disab_discrim c.age##c.age female immigbg  i.year i.country [pweight=pspwght] if sample==1 , cluster(country)
est store turnout3
logit turnout ib1.disab_discrim c.age##c.age female immigbg  i.year i.country [pweight=pspwght] if sample==1 , cluster(country)
est store turnout3a
logit turnout i.disab_discrim c.age##c.age female immigbg eduyears income workplace meet church  i.year i.country [pweight=pspwght] if sample==1 , cluster(country)
est store turnout4
logit turnout ib1.disab_discrim c.age##c.age female immigbg eduyears income workplace meet church  i.year i.country [pweight=pspwght] if sample==1 , cluster(country)
est store turnout4a
logit turnout i.disab_discrim c.age##c.age female immigbg eduyears income workplace meet church  polinterest_c pid5 i.year i.country [pweight=pspwght] if sample==1 , cluster(country)
est store turnout5
logit turnout ib1.disab_discrim c.age##c.age female immigbg eduyears income workplace meet church  polinterest_c pid5 i.year i.country [pweight=pspwght] if sample==1 , cluster(country)
est store turnout5a

esttab turnout1 turnout2 turnout3 turnout4 turnout5 ///
	using $folder\TableC5.rtf, replace b(%10.3f) se bic obslast star(* 0.05 ** 0.01 *** 0.001) ///
	mtitles ("(a)" "(b)" "(c)" "(d)" "(e)") label	nogaps compress  nonumbers /// 
	order(disability2 age age#age female immigbg eduyears income workplace meet church) ///
	coeflabels(disability2 "Disability" age "Age" age#age "Age squared" female "Female" immigbg "Immigration backgound" ///
	eduyears "Education" income "Income" workplace "Workplace" meet "Social integration" church "Religious attendance") nonotes

********************************************************************************
*** Table C6

foreach v in trust_parliament trust_politicians trust_parties {
gen `v'_c = `v'/10
}
mixed trust_parliament_c disability2 c.age##c.age female immigbg i.year [pweight=pspwght] if sample==1 || country: 
est store trust1
mixed trust_parliament_c i.disab_discrim c.age##c.age female immigbg eduyears income workplace meet church i.year [pweight=pspwght] if sample==1 || country: 
est store trust2
mixed trust_parliament_c ib1.disab_discrim c.age##c.age female immigbg eduyears income workplace meet church i.year [pweight=pspwght] if sample==1 || country: 
est store trust2a
mixed trust_parliament_c i.disab_discrim c.age##c.age female immigbg eduyears income workplace meet church exefficacy_c i.year [pweight=pspwght] if sample==1 || country: 
est store trust3
mixed trust_parliament_c ib1.disab_discrim c.age##c.age female immigbg eduyears income workplace meet church exefficacy_c i.year [pweight=pspwght] if sample==1 || country: 
est store trust3a
mixed trust_politicians_c disability2 c.age##c.age female immigbg i.year [pweight=pspwght] if sample==1 || country: 
est store trust4
mixed trust_politicians_c i.disab_discrim c.age##c.age female immigbg eduyears income workplace meet church i.year [pweight=pspwght] if sample==1 || country: 
est store trust5
mixed trust_politicians_c ib1.disab_discrim c.age##c.age female immigbg eduyears income workplace meet church i.year [pweight=pspwght] if sample==1 || country: 
est store trust5a
mixed trust_politicians_c i.disab_discrim c.age##c.age female immigbg eduyears income workplace meet church exefficacy_c i.year [pweight=pspwght] if sample==1 || country: 
est store trust6
mixed trust_politicians_c ib1.disab_discrim c.age##c.age female immigbg eduyears income workplace meet church exefficacy_c i.year [pweight=pspwght] if sample==1 || country: 
est store trust6a
mixed trust_parties_c disability2 c.age##c.age female immigbg i.year [pweight=pspwght] if sample==1 || country: 
est store trust7
mixed trust_parties_c i.disab_discrim c.age##c.age female immigbg eduyears income workplace meet church i.year [pweight=pspwght] if sample==1 || country: 
est store trust8
mixed trust_parties_c ib1.disab_discrim c.age##c.age female immigbg eduyears income workplace meet church i.year [pweight=pspwght] if sample==1 || country: 
est store trust8a
mixed trust_parties_c i.disab_discrim c.age##c.age female immigbg eduyears income workplace meet church exefficacy_c i.year [pweight=pspwght] if sample==1 || country: 
est store trust9
mixed trust_parties_c ib1.disab_discrim c.age##c.age female immigbg eduyears income workplace meet church exefficacy_c i.year [pweight=pspwght] if sample==1 || country: 
est store trust9a

esttab trust1 trust2 trust3 trust4 trust5 trust6 trust7 trust8 trust9  ///
	using $folder\TableC6.rtf, replace b(%10.3f) se bic obslast star(* 0.05 ** 0.01 *** 0.001) ///
	mtitles ("(a)" "(d)" "(e)" "(a)" "(d)" "(e)" "(a)" "(d)" "(e)") label	nogaps compress  nonumbers /// 
	order(disability2 age age#age female immigbg eduyears income workplace meet church) ///
	coeflabels(disability2 "Disability" age "Age" age#age "Age squared" female "Female" immigbg "Immigration backgound" ///
	eduyears "Education" income "Income" workplace "Workplace" meet "Social integration" church "Religious attendance") nonotes
	
********************************************************************************
*** Figure D1

* Political trust
* a
forval r=1/7 {
mixed poltrust_c disability2 c.age##c.age female immigbg [pweight=pspwght] if sample==1 & essround==`r' || country: 
est store Round`r'
}
coefplot Round1 || Round2 || Round3 || Round4 || Round5 || Round6 || Round7 , keep(disability2) bycoef xline(0) ///
	title("(a)", size(vlarge)) ylabel(,labsize(large)) xlabel(-.05(.05).05,labsize(large)) scheme(s2mono) graphregion(color(white)) ///
	mcolor(black) msize(small)  ciopts(lcolor(black)) grid(glpattern(dot)) name(g1, replace)
* b
forval r=1/7 {
mixed poltrust_c disability2 c.age##c.age female immigbg eduyears income workplace meet church [pweight=pspwght] if sample==1 & essround==`r' || country: 
est store Round`r'
}
coefplot Round1 || Round2 || Round3 || Round4 || Round5 || Round6 || Round7 , keep(disability2) bycoef xline(0) ///
	title("(b)", size(vlarge)) ylabel(,labsize(large)) xlabel(-.05(.05).05,labsize(large)) scheme(s2mono) graphregion(color(white)) ///
	mcolor(black) msize(small)  ciopts(lcolor(black)) grid(glpattern(dot)) name(g2, replace)
* c
forval r=1/7 {
mixed poltrust_c i.disab_discrim c.age##c.age female immigbg [pweight=pspwght] if sample==1 & essround==`r' || country: 
est store Round`r'
}
coefplot Round1 || Round2 || Round3 || Round4 || Round5 || Round6 || Round7 , keep(1.disab_discrim) bycoef xline(0) ///
	title("(c)", size(vlarge)) ylabel(,labsize(large)) xlabel(-.05(.05).05,labsize(large)) scheme(s2mono) graphregion(color(white)) ///
	mcolor(black) msize(small)  ciopts(lcolor(black)) grid(glpattern(dot)) name(g3, replace)
* d
forval r=1/7 {
mixed poltrust_c i.disab_discrim c.age##c.age female immigbg eduyears income workplace meet church [pweight=pspwght] if sample==1 & essround==`r' || country: 
est store Round`r'
}
coefplot Round1 || Round2 || Round3 || Round4 || Round5 || Round6 || Round7 , keep(1.disab_discrim) bycoef xline(0) ///
	title("(d)", size(vlarge)) ylabel(,labsize(large)) xlabel(-.05(.05).05,labsize(large)) scheme(s2mono) graphregion(color(white)) ///
	mcolor(black) msize(small)  ciopts(lcolor(black)) grid(glpattern(dot)) name(g4, replace)
* Political interest
* a
forval r=1/7 {
mixed polinterest_c disability2 c.age##c.age female immigbg [pweight=pspwght] if sample==1 & essround==`r' || country: 
est store Round`r'
}
coefplot Round1 || Round2 || Round3 || Round4 || Round5 || Round6 || Round7 , keep(disability2) bycoef xline(0) ///
	title("(a)", size(vlarge)) ylabel(,labsize(large)) xlabel(-.05(.05).05,labsize(large)) scheme(s2mono) graphregion(color(white)) ///
	mcolor(black) msize(small)  ciopts(lcolor(black)) grid(glpattern(dot)) name(g5, replace)
* b
forval r=1/7 {
mixed polinterest_c disability2 c.age##c.age female immigbg eduyears income workplace meet church [pweight=pspwght] if sample==1 & essround==`r' || country: 
est store Round`r'
}
coefplot Round1 || Round2 || Round3 || Round4 || Round5 || Round6 || Round7 , keep(disability2) bycoef xline(0) ///
	title("(b)", size(vlarge)) ylabel(,labsize(large)) xlabel(-.05(.05).05,labsize(large)) scheme(s2mono) graphregion(color(white)) ///
	mcolor(black) msize(small)  ciopts(lcolor(black)) grid(glpattern(dot)) name(g6, replace)
* c
forval r=1/7 {
mixed polinterest_c i.disab_discrim c.age##c.age female immigbg [pweight=pspwght] if sample==1 & essround==`r' || country: 
est store Round`r'
}
coefplot Round1 || Round2 || Round3 || Round4 || Round5 || Round6 || Round7 , keep(1.disab_discrim) bycoef xline(0) ///
	title("(c)", size(vlarge)) ylabel(,labsize(large)) xlabel(-.05(.05).05,labsize(large)) scheme(s2mono) graphregion(color(white)) ///
	mcolor(black) msize(small)  ciopts(lcolor(black)) grid(glpattern(dot)) name(g7, replace)
* d
forval r=1/7 {
mixed polinterest_c i.disab_discrim c.age##c.age female immigbg eduyears income workplace meet church [pweight=pspwght] if sample==1 & essround==`r' || country: 
est store Round`r'
}
coefplot Round1 || Round2 || Round3 || Round4 || Round5 || Round6 || Round7 , keep(1.disab_discrim) bycoef xline(0) ///
	title("(d)", size(vlarge)) ylabel(,labsize(large)) xlabel(-.05(.05).05,labsize(large)) scheme(s2mono) graphregion(color(white)) ///
	mcolor(black) msize(small)  ciopts(lcolor(black)) grid(glpattern(dot)) name(g8, replace)
* Turnout
* a
forval r=1/7 {
melogit turnout disability2 c.age##c.age female immigbg [pweight=pspwght] if sample==1 & essround==`r' || country: 
est store Round`r'
}
coefplot Round1 || Round2 || Round3 || Round4 || Round5 || Round6 || Round7 , keep(disability2) bycoef xline(0) ///
	title("(a)", size(vlarge)) ylabel(,labsize(large)) xlabel(-.5(.2).1,labsize(large)) scheme(s2mono) graphregion(color(white)) ///
	mcolor(black) msize(small)  ciopts(lcolor(black)) grid(glpattern(dot)) name(g9, replace)
* b
forval r=1/7 {
melogit turnout disability2 c.age##c.age female immigbg eduyears income workplace meet church [pweight=pspwght] if sample==1 & essround==`r' || country: 
est store Round`r'
}
coefplot Round1 || Round2 || Round3 || Round4 || Round5 || Round6 || Round7 , keep(disability2) bycoef xline(0) ///
	title("(b)", size(vlarge)) ylabel(,labsize(large)) xlabel(-.6(.2).1,labsize(large)) scheme(s2mono) graphregion(color(white)) ///
	mcolor(black) msize(small)  ciopts(lcolor(black)) grid(glpattern(dot)) name(g10, replace)
* c
forval r=1/7 {
melogit turnout i.disab_discrim c.age##c.age female immigbg  [pweight=pspwght] if sample==1 & essround==`r' || country: 
est store Round`r'
}
coefplot Round1 || Round2 || Round3 || Round4 || Round5 || Round6 || Round7 , keep(1.disab_discrim) bycoef xline(0) ///
	title("(c)", size(vlarge)) ylabel(,labsize(large)) xlabel(-.6(.2).1,labsize(large)) scheme(s2mono) graphregion(color(white)) ///
	mcolor(black) msize(small)  ciopts(lcolor(black)) grid(glpattern(dot)) name(g11, replace)
* d
forval r=1/7 {
melogit turnout i.disab_discrim c.age##c.age female immigbg eduyears income workplace meet church [pweight=pspwght] if sample==1 & essround==`r' || country: 
est store Round`r'
}
coefplot Round1 || Round2 || Round3 || Round4 || Round5 || Round6 || Round7 , keep(1.disab_discrim) bycoef xline(0) ///
	title("(c)", size(vlarge)) ylabel(,labsize(large)) xlabel(-.6(.2).1,labsize(large)) scheme(s2mono) graphregion(color(white)) ///
	mcolor(black) msize(small)  ciopts(lcolor(black)) grid(glpattern(dot)) name(g12, replace)

graph combine g1 g2 g3 g4 g5 g6 g7 g8 g9 g10 g11 g12, col(4) graphregion(fcolor(white) ilcolor(white) lcolor(white)) xsize(7) ysize(3) 
graph save Graph $folder\FigureD1.gph, replace
graph export $folder\FigureD1.png, replace width(5000)




*********************************************************
*** References to original datasets:

* ESS Round 7: European Social Survey Round 7 Data (2014). Data file edition 2.1. NSD - Norwegian Centre for Research Data, Norway – Data Archive and distributor of ESS data for ESS ERIC.
* ESS Round 6: European Social Survey Round 6 Data (2012). Data file edition 2.3. NSD - Norwegian Centre for Research Data, Norway – Data Archive and distributor of ESS data for ESS ERIC.
* ESS Round 5: European Social Survey Round 5 Data (2010). Data file edition 3.3. NSD - Norwegian Centre for Research Data, Norway – Data Archive and distributor of ESS data for ESS ERIC.
* ESS Round 4: European Social Survey Round 4 Data (2008). Data file edition 4.4. NSD - Norwegian Centre for Research Data, Norway – Data Archive and distributor of ESS data for ESS ERIC.
* ESS Round 3: European Social Survey Round 3 Data (2006). Data file edition 3.6. NSD - Norwegian Centre for Research Data, Norway – Data Archive and distributor of ESS data for ESS ERIC.
* ESS Round 2: European Social Survey Round 2 Data (2004). Data file edition 3.5. NSD - Norwegian Centre for Research Data, Norway – Data Archive and distributor of ESS data for ESS ERIC.
* ESS Round 1: European Social Survey Round 1 Data (2002). Data file edition 6.5. NSD - Norwegian Centre for Research Data, Norway – Data Archive and distributor of ESS data for ESS ERIC.

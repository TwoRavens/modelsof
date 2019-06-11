/*
Clerics and Scripture: Experimentally Disentangling the Influence of Religious Authority in Afghanistan
(Condra, Isaqzadeh, and Linardi)
British Journal of Political Science

Note: code replicates tables and figures in BJPS final submission
*/


clear

use data-replic.dta, clear

*******************************

* Table 1: Summary Statistics on Demographics (All Treatments)

sum age  marital_status lang_count  pashtun noedu formal_edu education_koranic timeofoccupationyear daysofworklastweek poor monthlyincome 

*Table 2: Contribution Summary Statistics by Treatment Condition
sort treat
bysort treat: sum notzero amtifpos amount  

* Table 3. Summary of Treatment Effects
* PANEL A - Effect of Cleric on Civilian (no controls)
reg notzero cleric  if civilian | cleric , cl(daysession)
outreg2 using table3.xls, dec(2) excel  replace	

reg amtifpos cleric  if civilian | cleric , cl(daysession)
outreg2 using table3.xls, dec(2) excel append	

reg amount cleric  if civilian | cleric , cl(daysession)
outreg2 using table3.xls, dec(2) excel  append	

* PANEL A - Effect of Scripture on Cleric (no controls)
reg notzero scripture if cleric | scripture, cl(daysession)
outreg2 using table3.xls, dec(2) excel   append	

reg amtifpos scripture  if cleric | scripture , cl(daysession)
outreg2 using table3.xls, dec(2) excel   append	

reg amount scripture  if cleric | scripture , cl(daysession)
outreg2 using table3.xls, dec(2) excel  append	

* PANEL B - Effect of Cleric on Civilian (with controls)
reg notzero cleric moreincome formal_edu rich  ///
pashtun  age lang_count marital_status education_koranic daricomposition time_taken session i.interviewercode /// 
	if (civilian | cleric)  , cl(daysession)
	outreg2 using table3.xls, dec(2) excel append

reg amtifpos cleric moreincome formal_edu rich ///
pashtun  age lang_count marital_status education_koranic daricomposition time_taken session i.interviewercode /// 
  if (civilian | cleric)  , cl(daysession)
outreg2 using table3.xls, dec(2) excel append

reg amount cleric moreincome formal_edu rich ///
pashtun  age lang_count marital_status education_koranic daricomposition time_taken session i.interviewercode /// 
  if (civilian | cleric)  , cl(daysession)
outreg2 using table3.xls, dec(2) excel append

* PANEL B - Effect of Scripture on Cleric (with controls)
reg notzero scripture moreincome formal_edu rich ///
pashtun  age lang_count marital_status education_koranic daricomposition time_taken session i.interviewercode /// 
 if (cleric | scripture)  , cl(daysession)
outreg2 using table3.xls, dec(2) excel append

reg amtifpos scripture moreincome formal_edu rich ///
pashtun  age lang_count marital_status education_koranic daricomposition time_taken session i.interviewercode /// 
  if (cleric | scripture)  , cl(daysession)
outreg2 using table3.xls, dec(2) excel append

reg amount scripture moreincome formal_edu rich ///
pashtun  age lang_count marital_status education_koranic daricomposition time_taken session i.interviewercode /// 
 if (cleric | scripture)  , cl(daysession)
outreg2 using table3.xls, dec(2) excel append


*Appendix Table A1. Session Averages and Wilcoxon rank-sum test
sort treat
bysort treat: sum notzero amtifpos amount  

* Session averages (Robustness)
sort daysession
quietly by daysession:  gen duplicate = cond(_N==1,0,_n)
		
egen s_notzero = mean(notzero), by(daysession)
egen s_amtifpos = mean(amtifpos), by(daysession)
egen s_amount = mean(amount), by(daysession)
gen large = amount>20
gen minimal = amount==10
egen s_minimal = mean(minimal), by(daysession)
egen s_large = mean(large), by(daysession)

bysort treat: sum s_notzero if duplicate==1
bysort treat: sum s_amtifpos if duplicate==1
bysort treat: sum s_amount if duplicate==1
bysort treat: sum s_minimal if duplicate==1
bysort treat: sum s_large if duplicate==1

ranksum s_notzero if !scripture & duplicate==1, by(treat) 
ranksum s_notzero if !civilian & duplicate==1, by(treat) 
ranksum s_amtifpos if !scripture & duplicate==1, by(treat) 
ranksum s_amtifpos if !civilian & duplicate==1, by(treat) 
ranksum s_amount if !scripture & duplicate==1, by(treat) 
ranksum s_amount if !civilian & duplicate==1, by(treat) 
ranksum s_minimal if !scripture & duplicate==1, by(treat) 
ranksum s_minimal if !civilian & duplicate==1, by(treat) 
ranksum s_large if !scripture & duplicate==1, by(treat) 
ranksum s_large if !civilian & duplicate==1, by(treat) 

median s_notzero if !scripture & duplicate==1, by(treat) 
median s_notzero if !civilian & duplicate==1, by(treat) 
median s_amtifpos if !scripture & duplicate==1, by(treat) 
median s_amtifpos if !civilian & duplicate==1, by(treat) 
median s_amount if !scripture & duplicate==1, by(treat) 
median s_amount if !civilian & duplicate==1, by(treat) 


* Appendix Tables A2a-2c. Full Results on Cleric and Cleric+Scripture Treatment Effects (Main and Heterogeneous)

 * interactions

gen clericrich = cleric * rich
gen scripturerich = scripture * rich
gen clericmoreincome = cleric * moreincome
gen scripturemoreincome = scripture * moreincome
gen clericformal_edu = cleric * formal_edu
gen scriptureformal_edu = scripture * formal_edu

	*Table A2a - Contribute
reg notzero cleric  scripture , cl(daysession)
outreg2 using tableA2.xls, dec(2) excel  replace	

reg notzero cleric scripture moreincome formal_edu  rich ///
pashtun  age lang_count marital_status education_koranic daricomposition time_taken session i.interviewercode   , cl(daysession)
outreg2 using tableA2.xls, dec(2) excel append
	
reg notzero cleric scripture  moreincome formal_edu rich clericmoreincome scripturemoreincome ///
pashtun  age lang_count marital_status education_koranic daricomposition time_taken session i.interviewercode   , cl(daysession)
*lincom cleric+clericmoreincome
*lincom scripture+scripturemoreincome
outreg2 using tableA2.xls, dec(2) excel append

reg notzero cleric scripture  moreincome formal_edu rich clericformal_edu scriptureformal_edu ///
pashtun  age lang_count marital_status education_koranic daricomposition time_taken session i.interviewercode   , cl(daysession)
*lincom cleric+clericformal_edu
*lincom scripture+scriptureformal_edu
outreg2 using tableA2.xls, dec(2) excel append

reg notzero cleric scripture  moreincome formal_edu rich clericrich scripturerich ///
pashtun  age lang_count marital_status education_koranic daricomposition time_taken session i.interviewercode   , cl(daysession)
*lincom cleric+clericrich
*lincom scripture+scripturerich
outreg2 using tableA2.xls, dec(2) excel append

	*Table A2b - Conditional Amount
reg amtifpos cleric  scripture , cl(daysession)
outreg2 using tableA2.xls, dec(2) excel  append

reg amtifpos cleric scripture moreincome formal_edu rich ///
pashtun  age lang_count marital_status education_koranic daricomposition time_taken session i.interviewercode   , cl(daysession)
outreg2 using tableA2.xls, dec(2) excel append
	
reg amtifpos cleric scripture  moreincome formal_edu rich clericmoreincome scripturemoreincome ///
pashtun  age lang_count marital_status education_koranic daricomposition time_taken session i.interviewercode   , cl(daysession)
outreg2 using tableA2.xls, dec(2) excel append

reg amtifpos cleric scripture  moreincome formal_edu rich clericformal_edu scriptureformal_edu ///
pashtun  age lang_count marital_status education_koranic daricomposition time_taken session i.interviewercode   , cl(daysession)
outreg2 using tableA2.xls, dec(2) excel append

reg amtifpos cleric scripture  moreincome formal_edu rich clericrich scripturerich ///
pashtun  age lang_count marital_status education_koranic daricomposition time_taken session i.interviewercode   , cl(daysession)
outreg2 using tableA2.xls, dec(2) excel append

	*Table A2c - Average
reg amount cleric  scripture , cl(daysession)
outreg2 using tableA2.xls, dec(2) excel  append

reg amount cleric scripture moreincome formal_edu rich  ///
pashtun  age lang_count marital_status education_koranic daricomposition time_taken session i.interviewercode   , cl(daysession)
outreg2 using tableA2.xls, dec(2) excel append
	
reg amount cleric scripture  moreincome formal_edu rich clericmoreincome scripturemoreincome ///
pashtun  age lang_count marital_status education_koranic daricomposition time_taken session i.interviewercode   , cl(daysession)
outreg2 using tableA2.xls, dec(2) excel append

reg amount cleric scripture  moreincome formal_edu rich clericformal_edu scriptureformal_edu ///
pashtun  age lang_count marital_status education_koranic daricomposition time_taken session i.interviewercode   , cl(daysession)
outreg2 using tableA2.xls, dec(2) excel append

reg amount cleric scripture  moreincome formal_edu rich clericrich scripturerich ///
pashtun  age lang_count marital_status education_koranic daricomposition time_taken session i.interviewercode   , cl(daysession)
outreg2 using tableA2.xls, dec(2) excel append


*Appendix Table A3. Full Results on Cleric Treatment Effects (Main and Heterogeneous) (see code for Tables 3-4)

*Appendix Table A4. Full Results on Cleric+Scripture Treatment Effects (Main and Heterogeneous) (see code for Tables 3-4)

*Appendix Table A5. Prediction Errors in the Civilian, Cleric, and Cleric+Scripture Treatment Conditions

	*Full controls specification from Table 3
reg amount moreincome formal_edu rich pashtun age lang_count marital_status education_koranic daricomposition time_taken session i.interviewercode /// 
	if civilian, cl(daysession)
	
predict amt
gen predError = amount-amt

sort cleric
bysort cleric: sum amount amt predError if !scripture
	*All subjects - civilian
ttest amt==0 if civilian
ttest amount==0 if civilian
ttest predError==0 if civilian

	*All subjects - cleric
ttest amt==0 if cleric
ttest amount==0 if cleric
ttest predError==0 if cleric

	*Civ and Cleric:low motivation
by cleric: sum predError if amt<10 & !scripture
ttest amt==0 if civilian & amt<10
ttest amount==0 if civilian & amt<10
ttest amt==0 if cleric & amt<10
ttest amount==0 if cleric & amt<10

ttest predError==0 if civilian & amt<10 
ttest predError==0 if cleric & amt<10 

	*Civ and Cleric:high motivation
by cleric: sum predError if amt>=10 & !scripture
ttest amt==0 if civilian & amt>=10
ttest amount==0 if civilian & amt>=10
ttest amt==0 if cleric & amt>=10
ttest amount==0 if cleric & amt>=10

ttest predError==0 if civilian & amt>=10 
ttest predError==0 if cleric & amt>=10 

	*Civ and Cleric: predictions for top/bottom  income, low motivation
by cleric: sum predError if amt<10 & !scripture & !moreincome
by cleric: sum predError if amt<10 & !scripture & moreincome
ttest predError==0 if amt<10 & civilian & !moreincome
ttest predError==0 if amt<10 & civilian & moreincome
ttest predError==0 if amt<10 & cleric & !moreincome
ttest predError==0 if amt<10 & cleric & moreincome

	*Civ and Cleric: predictions for top/bottom 30 income, high motivation
by cleric: sum predError if amt>=10 & !scripture & !moreincome
by cleric: sum predError if amt>=10 & !scripture & moreincome
ttest predError==0 if amt>=10 & civilian & !moreincome
ttest predError==0 if amt>=10 & civilian & moreincome
ttest predError==0 if amt>=10 & cleric & !moreincome
ttest predError==0 if amt>=10 & cleric & moreincome


	*Civ and Cleric: predictions for do not feel poor, low motivation
by cleric: sum predError if amt<10 & !scripture & !rich
by cleric: sum predError if amt<10 & !scripture & rich
ttest predError==0 if amt<10 & civilian & !rich
ttest predError==0 if amt<10 & civilian & rich
ttest predError==0 if amt<10 & cleric & !rich
ttest predError==0 if amt<10 & cleric & rich

	*Civ and Cleric: predictions for do not feel poor, high motivation
by cleric: sum predError if amt>10 & !scripture & !rich
by cleric: sum predError if amt>10 & !scripture & rich
ttest predError==0 if amt>=10 & civilian & !rich
ttest predError==0 if amt>=10 & civilian & rich
ttest predError==0 if amt>=10 & cleric & !rich
ttest predError==0 if amt>=10 & cleric & rich

	*Civ and Cleric: predictions for formal education, low motivation
by cleric: sum predError if amt<10 & !scripture & !formal_edu
by cleric: sum predError if amt<10 & !scripture & formal_edu
ttest predError==0 if amt<10 & civilian & !formal_edu
ttest predError==0 if amt<10 & civilian & formal_edu
ttest predError==0 if amt<10 & cleric & !formal_edu
ttest predError==0 if amt<10 & cleric & formal_edu

	*Civ and Cleric: predictions for formal education, high motivation
by cleric: sum predError if amt>10 & !scripture & !formal_edu
by cleric: sum predError if amt>10 & !scripture & formal_edu
ttest predError==0 if amt>=10 & civilian & !formal_edu
ttest predError==0 if amt>=10 & civilian & formal_edu
ttest predError==0 if amt>=10 & cleric & !formal_edu
ttest predError==0 if amt>=10 & cleric & formal_edu

	*Scripture: all subjects
sort scripture
sum amount amt predError if scripture
ttest amt==0 if scripture
ttest amount==0 if scripture
ttest predError==0 if scripture

	*Scripture: low motivation
sum predError if amt<10 & scripture
ttest amt==0 if scripture & amt<10
ttest amount==0 if scripture & amt<10
ttest predError==0 if scripture & amt<10

	*Scripture: high motivation
sum predError if amt>=10 & scripture
ttest amt==0 if scripture & amt>=10
ttest amount==0 if scripture & amt>=10
ttest predError==0 if scripture & amt>=10

	*Scripture: low motivation, by more income
ttest predError==0 if scripture & amt<10 & !moreincome
ttest predError==0 if scripture & amt<10 & moreincome
ttest predError if scripture & amt<10,  by(moreincome)

	*Scripture: high motivation, by more income
ttest predError==0 if scripture & amt>=10 & !moreincome
ttest predError==0 if scripture & amt>=10 & moreincome
ttest predError if scripture & amt>=10,  by(moreincome)

	*Scripture: low motivation, by do not feel poor
ttest predError==0 if scripture & amt<10 & !rich
ttest predError==0 if scripture & amt<10 & rich
ttest predError if scripture & amt<10,  by(rich)

	*Scripture: high motivation, by do not feel poor
ttest predError==0 if scripture & amt>=10 & !rich
ttest predError==0 if scripture & amt>=10 & rich
ttest predError if scripture & amt>=10,  by(rich)

	*Scripture: low motivation, by formal education
ttest predError==0 if scripture & amt<10 & !formal_edu
ttest predError==0 if scripture & amt<10 & formal_edu
ttest predError if scripture & amt<10,  by(formal_edu)

	*Scripture: high motivation, by formal education
ttest predError==0 if scripture & amt>=10 & !formal_edu
ttest predError==0 if scripture & amt>=10 & formal_edu
ttest predError if scripture & amt>=10,  by(formal_edu)

*Table A6. Heterogeneity in Treatment Effects
* PANEL A - Effect of Cleric on Civilian (Income)
reg notzero cleric moreincome formal_edu rich clericmoreincome ///
pashtun  age lang_count marital_status education_koranic daricomposition time_taken session i.interviewercode /// 
  if (civilian | cleric)  , cl(daysession)
lincom cleric+clericmoreincome
outreg2 using tableA6.xls, dec(2) excel replace

reg amtifpos cleric moreincome formal_edu rich clericmoreincome ///
pashtun  age lang_count marital_status education_koranic daricomposition time_taken session i.interviewercode /// 
  if (civilian | cleric)  , cl(daysession)
lincom cleric+clericmoreincome
outreg2 using tableA6.xls, dec(2) excel append

reg amount cleric moreincome formal_edu rich clericmoreincome ///
pashtun  age lang_count marital_status education_koranic daricomposition time_taken session i.interviewercode /// 
  if (civilian | cleric)  , cl(daysession)
lincom cleric+clericmoreincome
outreg2 using tableA6.xls, dec(2) excel append

* PANEL A - Effect of Scripture on Cleric (Income)
reg notzero scripture moreincome rich formal_edu scripturemoreincome ///
pashtun  age lang_count marital_status education_koranic daricomposition time_taken session i.interviewercode /// 
 if (cleric | scripture)  , cl(daysession)
lincom scripture+scripturemoreincome
outreg2 using tableA6.xls, dec(2) excel append

reg amtifpos scripture moreincome formal_edu rich scripturemoreincome ///
pashtun  age lang_count marital_status education_koranic daricomposition time_taken session i.interviewercode /// 
  if (cleric | scripture)  , cl(daysession)
lincom scripture+scripturemoreincome
outreg2 using tableA6.xls, dec(2) excel append

reg amount scripture moreincome formal_edu rich scripturemoreincome ///
pashtun  age lang_count marital_status education_koranic daricomposition time_taken session i.interviewercode /// 
  if (cleric | scripture)  , cl(daysession)
lincom scripture+scripturemoreincome
outreg2 using tableA6.xls, dec(2) excel append

* PANEL B - Effect of Cleric on Civilian (Do Not Feel Poor)
reg notzero cleric moreincome formal_edu rich clericrich ///
pashtun  age lang_count marital_status education_koranic daricomposition time_taken session i.interviewercode /// 
  if (civilian | cleric)  , cl(daysession)
lincom cleric+clericrich
outreg2 using tableA6.xls, dec(2) excel append

reg amtifpos cleric moreincome formal_edu rich clericrich ///
pashtun  age lang_count marital_status education_koranic daricomposition time_taken session i.interviewercode /// 
  if (civilian | cleric)  , cl(daysession)
lincom cleric+clericrich
outreg2 using tableA6.xls, dec(2) excel append

reg amount cleric moreincome formal_edu rich clericrich ///
pashtun  age lang_count marital_status education_koranic daricomposition time_taken session i.interviewercode /// 
  if (civilian | cleric)  , cl(daysession)
lincom cleric+clericrich
outreg2 using tableA6.xls, dec(2) excel append

* PANEL B - Effect of Scripture on Cleric (Do Not Feel Poor)
reg notzero scripture moreincome formal_edu rich scripturerich ///
pashtun  age lang_count marital_status education_koranic daricomposition time_taken session i.interviewercode /// 
 if (cleric | scripture)  , cl(daysession)
lincom scripture+scripturerich
outreg2 using tableA6.xls, dec(2) excel append

reg amtifpos scripture moreincome formal_edu rich scripturerich ///
pashtun  age lang_count marital_status education_koranic daricomposition time_taken session i.interviewercode /// 
 if (cleric | scripture)  , cl(daysession)
lincom scripture+scripturerich
outreg2 using tableA6.xls, dec(2) excel append

reg amount scripture moreincome formal_edu rich scripturerich ///
pashtun  age lang_count marital_status education_koranic daricomposition time_taken session i.interviewercode /// 
 if (cleric | scripture)  , cl(daysession)
lincom scripture+scripturerich
outreg2 using tableA6.xls, dec(2) excel append

* PANEL C - Effect of Cleric on Civilian (Education)
reg notzero cleric moreincome formal_edu rich clericformal_edu ///
pashtun  age lang_count marital_status education_koranic daricomposition time_taken session i.interviewercode /// 
 if (civilian | cleric)  , cl(daysession)
lincom cleric+clericformal_edu
outreg2 using tableA6.xls, dec(2) excel append

reg amtifpos cleric moreincome formal_edu rich clericformal_edu ///
pashtun  age lang_count marital_status education_koranic daricomposition time_taken session i.interviewercode /// 
 if (civilian | cleric)  , cl(daysession)
lincom cleric+clericformal_edu
outreg2 using tableA6.xls, dec(2) excel append

reg amount cleric moreincome formal_edu rich clericformal_edu ///
pashtun  age lang_count marital_status education_koranic daricomposition time_taken session i.interviewercode /// 
  if (civilian | cleric)  , cl(daysession)
lincom cleric+clericformal_edu
outreg2 using tableA6.xls, dec(2) excel append

* PANEL C - Effect of Scripture on Cleric (Education)
reg notzero scripture moreincome formal_edu rich scriptureformal_edu ///
pashtun  age lang_count marital_status education_koranic daricomposition time_taken session i.interviewercode /// 
  if (cleric | scripture)  , cl(daysession)
lincom scripture+scriptureformal_edu
outreg2 using tableA6.xls, dec(2) excel append

reg amtifpos scripture moreincome formal_edu rich scriptureformal_edu ///
pashtun  age lang_count marital_status education_koranic daricomposition time_taken session i.interviewercode /// 
  if (cleric | scripture)  , cl(daysession)
lincom scripture+scriptureformal_edu
outreg2 using tableA6.xls, dec(2) excel append

reg amount scripture moreincome formal_edu rich scriptureformal_edu ///
pashtun  age lang_count marital_status education_koranic daricomposition time_taken session i.interviewercode /// 
 if (cleric | scripture)  , cl(daysession)
lincom scripture+scriptureformal_edu
outreg2 using tableA6.xls, dec(2) excel append


*Figure 1. Amount Given to EMERGENCY Hospital (All Subjects)


*creating amount2
gen amount2 = 0 if amount==0
replace amount2 = 1 if amount==10
replace amount2 = 2 if amount==20
replace amount2 = 3 if amount >20
gen level0=amount2==0
gen level1=amount2==1
gen level2=amount2==2
gen level3=amount2==3
save beforecollapse.dta, replace
*use the collapse command to make the mean and standard deviation by treatment
collapse (mean) meandensity= level0 (sd) sddensity=level0 (count) n=level0, by(treat)
*make the upper and lower values of the confidence interval
generate hidensity= meandensity + invttail(n-1,0.025)*(sddensity / sqrt(n))
generate lowdensity = meandensity - invttail(n-1,0.025)*(sddensity / sqrt(n))
*adding back amount2 and save the collapsed data
gen amount2=0
save collapsed0.dta, replace
*collapse for density of level1 donation
use beforecollapse.dta, clear
collapse (mean) meandensity= level1 (sd) sddensity=level1 (count) n=level1, by(treat)
generate hidensity= meandensity + invttail(n-1,0.025)*(sddensity / sqrt(n))
generate lowdensity = meandensity - invttail(n-1,0.025)*(sddensity / sqrt(n))
gen amount2=1
save collapsed1.dta, replace
*collapse for density of level2 donation
use beforecollapse.dta, clear
collapse (mean) meandensity= level2 (sd) sddensity=level2 (count) n=level2, by(treat)
generate hidensity= meandensity + invttail(n-1,0.025)*(sddensity / sqrt(n))
generate lowdensity = meandensity - invttail(n-1,0.025)*(sddensity / sqrt(n))
gen amount2=2
save collapsed2.dta,replace
*collapse for density of level3 donation
use beforecollapse.dta, clear
collapse (mean) meandensity= level3 (sd) sddensity=level3 (count) n=level3, by(treat)
generate hidensity= meandensity + invttail(n-1,0.025)*(sddensity / sqrt(n))
generate lowdensity = meandensity - invttail(n-1,0.025)*(sddensity / sqrt(n))
gen amount2=3
save collapsed3.dta, replace
*combine the collapsed files into one
append using collapsed0 collapsed1 collapsed2
save collapsed.dta, replace
*now the data is already collapsed for density of donations
*meandensity is the mean of donation in each category, hidensity and lodensity indicate 95% confident interval for the mean
replace treat=1 if treat==11
replace treat=2 if treat==111
replace treat=3 if treat==211
generate amounttreat = treat    if amount2 == 0
replace  amounttreat = treat+4    if amount2 == 1
replace  amounttreat = treat+8    if amount2 == 2
replace  amounttreat = treat+12    if amount2 == 3
sort amounttreat
twoway (bar meandensity amounttreat if treat==1, color(gs0)) (bar meandensity amounttreat if treat==2,color(gs6)) (bar meandensity amounttreat if treat==3,color(gs12)) (rcap hidensity lowdensity amounttreat, lcolor(gs6) lwidth(vthin)), graphregion(color(white)) legend(row(1) order(1 "Civilian" 2 "Cleric" 3 "Cleric+Scripture") )  xlabel( 2 "0" 6 "10" 10 "20" 14 ">20", noticks) xtitle("Amount of Contribution") ytitle("Density")


*FIGURE A1. Prediction Errors (mean and 95% CI) on amount given.  All subjects.

use data-replic.dta, clear

qui reg amount moreincome formal_edu rich pashtun age lang_count marital_status education_koranic ///
	daricomposition time_taken session i.interviewercode if civilian, cl(daysession)

predict amt
generate predError = amount-amt

generate group = 0 if amt<=10 
replace group = 1 if amt>10 

gen amounttreat = group*4+treat2 
sort amounttreat

collapse (mean) meandensity= predError (sd) sddensity=predError (count) n=predError if !education_koranic, by(amounttreat)

* make the upper and lower values of the confidence interval
generate hidensity= meandensity + invttail(n-1,0.025)*(sddensity / sqrt(n))
generate lowdensity = meandensity - invttail(n-1,0.025)*(sddensity / sqrt(n))

* greyscaled
twoway (bar meandensity amounttreat if amounttreat==1 | amounttreat==5, color(gs0)) ///
(bar meandensity amounttreat if amounttreat==2 | amounttreat==6,color(gs6)) ///
(bar meandensity amounttreat if amounttreat==3 | amounttreat==7,color(gs12)) ///
(rcap hidensity lowdensity amounttreat, lcolor(gs6) lwidth(vthin)), ///
graphregion(color(white)) legend(row(1) order(1 "Civilian" 2 "Cleric" 3 "Cleric+Scripture") ) ///
xlabel( 2 "Low Motivation" 6 "High Motivation", noticks) ///
xtitle("                ") ytitle("Treatment Effect")


* FIGURE A2. No Formal Education and Formal Education
use data-replic.dta, clear

qui reg amount moreincome formal_edu rich pashtun age lang_count marital_status education_koranic ///
	daricomposition time_taken session i.interviewercode if civilian, cl(daysession)

predict amt
generate predError = amount-amt

gen group = 0 if amt<10 & !formal_edu
replace group = 1 if amt>=10 & !formal_edu
replace group = 2 if amt<10 & formal_edu
replace group = 3 if amt>=10 & formal_edu

generate amounttreat = group*4+treat2 
sort amounttreat

collapse (mean) meandensity= predError (sd) sddensity=predError (count) n=predError, by(amounttreat)
generate hidensity= meandensity + invttail(n-1,0.025)*(sddensity / sqrt(n))
generate lowdensity = meandensity - invttail(n-1,0.025)*(sddensity / sqrt(n))

* greyscaled
twoway (bar meandensity amounttreat if amounttreat==1|amounttreat==5|amounttreat==9|amounttreat==13, color(gs0)) ///
(bar meandensity amounttreat if amounttreat==2|amounttreat==6|amounttreat==10|amounttreat==14,color(gs6)) ///
(bar meandensity amounttreat if amounttreat==3|amounttreat==7|amounttreat==11|amounttreat==15,color(gs12)) ///
(rcap hidensity lowdensity amounttreat, lcolor(gs6) lwidth(vthin)), ///
graphregion(color(white)) legend(row(1) order(1 "Civilian" 2 "Cleric" 3 "Cleric+Scripture") ) ///
xlabel(2 "Low Motivation" 6 "High Motivation" 10 "Low Motivation" 14 "High Motivation", noticks) ///
xtitle("               ") ytitle("Treatment Effect") ///
text(30 4 "No Formal Education", place(c) box just(center) margin(l+1 t+1 b+1) width(33) fcolor(white)) ///
text(30 12 "Formal Education", place(c) box just(center) margin(l+1 t+1 b+1) width(28) fcolor(white))


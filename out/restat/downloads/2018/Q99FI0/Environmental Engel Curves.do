/* #delimit ; */
clear

/* Environmental Engel Curves.do

This is the main file for running the analyses in Environmental Engel Curves.  It combines the
	fmly and mtbi CEX files and creates the figures and tables used in the manuscript.

NOTE: data are adjusted for inflation in earlier programs.

NOTES about the FMLY data:
CEX changed sampling frame in 1986, 1996, and 2005.  As a result, the following quarters of data are either not available or should not be used:
	1985Q3, 1985Q4, 1995Q3, 1995Q4, 2004Q3, 2004Q4.
The following quarters also have very low response: 1998Q2-4, 2005Q1.
	
Observations should not be used if fullyr!=1, respstat!=1, or cutenure==6 (student). 
	
Observations are reweighted (calculations in this file, below) to exclude those variables.  Weights are calculated so that they match the full
	sample weights for an age/rent-own bin.  This procedures is based on the procedure used for the NBER CEX extracts (http://www.nber.org/data/ces_cbo.html).

Income reporting is based on the 5th quarterly interview.	

A Note about *scale*: The supporting .do files report pollution intensity coefficeints
as pollution (tons) per million dollars.  This program (code below) rescales
pollution per household to be measured in pounds, rather than tons, to make the regression
coefficients more manageable.

Note: this program utilizes the user-written programs grc1leg and postrcspline in Stata
*/


/* Set the location where the data are programs are located. */
cd "C:\EnvironmentalEngelCurves\REStat Data Request and Final Programs"	
	
/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! */
/*Preliminary .do files need to be run into order to import and clean the raw data.
These take a long time to run.  After running once, this section can be commented out.
The "Compiled Data" folder already contains the output from these files, so they only
need to be re-run if you want to reimport the raw data.

do "Supporting Stata Programs\Import CPI data.do"
do "Supporting Stata Programs\Create UCC-IO pollution coefficients NEI.do"
do "Supporting Stata Programs\Import CEX fmly files BLS.do"
do "Supporting Stata Programs\Import CEX fmly files ICPSR.do"
do "Supporting Stata Programs\Import CEX mtbi files BLS.do"
do "Supporting Stata Programs\Import CEX mtbi files ICPSR.do"
do "Supporting Stata Programs\Nursing Homes.do"
*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/


/* Append and prepare the FMLY files */
use "Compiled Data Files\BLS_compiledfmly_all.dta", clear
append using "Compiled Data Files\ICPSR_compiledfmly_all.dta"

/* create adjusted weights */
gen age_group = 1 if age_ref<25
replace age_group = 2 if age_ref>=25&age_ref<35
replace age_group = 3 if age_ref>=35&age_ref<45
replace age_group = 4 if age_ref>=45&age_ref<55
replace age_group = 5 if age_ref>=55&age_ref<65
replace age_group = 6 if age_ref>=65

gen own = 1 if cutenure==1|cutenure==2|cutenure==3
replace own = 0 if cutenure==4|cutenure==5

egen totwt =  total(finlwt21), by(age_group own year quarter)
egen oldwt = total(finlwt21*(fullyr==1&respstat==1&cutenure!=6)), by(age_group own year quarter)
gen adjwt_factor = totwt/oldwt
gen adjwt = finlwt21*adjwt_factor*(fullyr==1&respstat==1&cutenure!=6) /* This is the original quarterly weight. */
replace adjwt=0 if year==1985&quarter==3
replace adjwt=0 if year==1985&quarter==4
replace adjwt=0 if year==1995&quarter==3
replace adjwt=0 if year==1995&quarter==4
replace adjwt=0 if year==2004&quarter==3
replace adjwt=0 if year==2004&quarter==4

gen adjwt2 = adjwt/4 /* this is an annual weight */
replace adjwt2 = adjwt/2 if year==1985|year==1995|year==2004

save "Compiled Data Files\combined_compiledfmly_all.dta", replace

/* Use and append the mtbi files */
use "Compiled Data Files\BLS_compiledmtbi_all.dta", clear
append using "Compiled Data Files\ICPSR_compiledmtbi_all.dta"
save "Compiled Data Files\combined_compiledmtbi_all.dta", replace

/* Now combine the fmli and the mtbi files together */
/* Note: cuid is not unique across survey rounds, hence the need to merge by quarter and year as well */
use "Compiled Data Files\combined_compiledfmly_all.dta", clear
merge 1:1 cuid quarter year using "Compiled Data Files\combined_compiledmtbi_all.dta"
drop _merge

rename totexp consumption
rename fincbtax income
rename fincatax aftertax_income
gen count = 1

/* To match other analyses based on TEAM model, only use PM10-PRI */
drop totalPM10fil totalPMcon totalPMfil totalPMpri
rename totalPM10pri totalPM10


/* Note: The original coefficients were tons/$million.  These were used to calculate
the actual number of tons per household in the mtbi import .do files (i.e. I divided
by $1million there).  Now I am converting to pounds per household, since the numbers
were so small.  This is mainly to make the regression coefficients more manageable */
/* Rescale pollution per houshold to pounds, not tons */
replace totalPM10 = totalPM10*2000
replace totalCO = totalCO*2000
replace totalVOC = totalVOC*2000
replace totalNOx = totalNOx*2000
replace totalSO2 = totalSO2*2000


/* Drop CU's that have any nursing home expenditure */
merge 1:1 cuid quarter year using "Compiled Data Files\combined_nursing_all.dta"
/* nursinghomes.dta was created based on individual itemized mtbi files from BLS and ICPSR.  It is a list
	of all CUs that have any expenditure on nursing homes. There are 1291 CUs overall in the 1984-2012
	period with nursing home expenditure.  Note: CEX does not include institutional residents. */
drop if _merge==3
drop _merge

/* Only need this if you plan on re-running and don't want to clean the data
every time:
save "Compiled Data Files\CEXmicrodata_combined_allyears.dta", replace
*/

/* Trimming based on after-tax income */
/* Trimming the top and bottom 1% of each quater/year (not trimming overall pooled sample, trimming by each quarter/year file */
egen group=group(quarter year)
quietly sum group
local num_groups = `r(max)'
di `num_groups'

forval i=1/`num_groups' {
	di _N
	quietly sum aftertax_income if group==`i', detail
	drop if (aftertax_income<`r(p1)'|aftertax_income>`r(p99)')&group==`i'
	di _N
	di `i'
	} /* closes the loop */

	
/* Dropping households that don't satisfy inclusion criteria.  Note: these households already 
	have an adjwt of 0 */
drop if fullyr!=1|respstat!=1|cutenure==6

/* Only need this if you plan on re-running and don't want to clean the data
every time:
save "Compiled Data Files\CEXmicrodata_combined_allyears_trimmed.dta", replace
*/

/* Set data as survey in Stata */
svyset [pw=adjwt2], strata(year)

/* rescale income */
replace income = income/10000
gen income2 = income^2
gen income3 = income^3

replace aftertax_income = aftertax_income/10000
gen aftertax_income2 = aftertax_income^2
gen aftertax_income3 = aftertax_income^3
gen aftertax_income4 = aftertax_income^4
gen lnaftertax_income = ln(aftertax_income)

foreach pol in PM10 VOC NOx SO2 CO {
gen ln`pol'= ln(total`pol')
}

replace consumption = consumption/10000
gen consumption2 = consumption^2
gen consumption3 = consumption^3

rename fam_size famsize
gen famsize2 = famsize^2
drop age2
rename age_ref age
gen age2 = age^2


gen married = (marital==1)
gen rural = (urban==0)
gen northeast = (region==1)
gen midwest = (region==2)
gen south =  (region==3)
gen west = (region==4)


rename ref_race race
gen race_white = (race==1)
gen race_black = (race==2)
gen race_other = (race==3|race==5|race==6)
gen race_asian = (race==4)


/* generate education dummies */
rename educ_ref education

	gen edu_elementary = (education==1|education==2|education==7)&year<1996
	gen edu_high = (education==3)&year<1996
	gen edu_somecoll = (education==4)&year<1996
	gen edu_college = (education==5)&year<1996
	gen edu_grad = (education==6)&year<1996

	replace edu_elementary = 1 if (education<12|education==38)&year>=1996
	replace edu_high = 1 if(education==39|education==12)&year>=1996
	replace edu_somecoll = 1 if ((education>=40&education<=42)|education==13|education==14)&year>=1996
	replace edu_college = 1 if (education==43|education==15)&year>=1996
	replace edu_grad = 1 if(education>43|education==16|education==17)&year>=1996
	
/* set control variables for regressions */	
local final_controls famsize famsize2 age age2 married ///
	race_black race_asian race_other edu_high edu_somecoll edu_college edu_grad ///
	midwest south west rural



/* TABLES
--------------------------------------------------------------------*/

/* TABLE 1: Summary Statistics for select years 1984, 2012 */
/* note: you rescaled income to measure $10,000 */ 	
gen one=1
foreach i of numlist 1984 2012 {
	svy: mean totalPM10 totalVOC totalNOx totalSO2 totalCO aftertax_income aftertax_income2 famsize famsize2 age age2 married /*
		*/ race_white race_black race_asian race_other edu_elementary edu_high edu_somecoll edu_college edu_grad /*
		*/ northeast midwest south west	rural if year==`i'
	if `i'==1984 outreg2 using "Output Files\Table 1 sumstats", replace excel noaster ctitle(`i') 
	else outreg2 using "Output Files\Table 1 sumstats", append excel noaster ctitle(`i') 
	
	svy: total one if year==`i'
	if `i'==1984 outreg2 using "Output Files\Table 1 population", replace excel noaster ctitle(`i') dec(0)
	else outreg2 using "Output Files\Table 1 population", append excel noaster ctitle(`i') dec(0)
}

svy: mean totalPM10 if year==1984|year==2012, over(year)
test [totalPM10]1984=[totalPM10]2012




/* TABLE 2: Parametric regressions of PM10 on income and demographics, annual */
/* find percentiles of 1984 income distribution (for calculating elasticities) */
sum aftertax_income if year==1984, det
local Q1 = r(p25)
local Q2 = r(p50)
local Q3 = r(p75)

/* 1984 just aftertax income */
reg totalPM10 c.aftertax_income##c.aftertax_income [pw=adjwt2] if year==1984, robust
testparm c.aftertax_income##c.aftertax_income

outreg2 using "Output Files\Table 2", excel replace ctitle(1984) addstat("F-test income", r(F),"P-value of F-test",r(p)) addnote("Margins are calculated at the annual median value of aftertax_income.  All other variables at annual means.") noaster
margins if year==1984, eyex(aftertax_income) at( (mean) _all (median) aftertax_income)  post
outreg2 using "Output Files\Table 2", excel append ctitle(margins1984)  noaster

/* All years, aftertax income, all variables */
foreach i of numlist 1984(1)2012 {
reg totalPM10 c.aftertax_income##c.aftertax_income  `final_controls' [pw=adjwt2] if year==`i', robust
testparm c.aftertax_income##c.aftertax_income
outreg2 using "Output Files\Table 2", addstat("F-test income",r(F),"P-value of F-test",r(p)) excel append ctitle(`i') noaster
margins if year==`i', eyex(aftertax_income)  at( (mean) _all (median) aftertax_income) post
outreg2 using "Output Files\Table 2", excel append ctitle(margins`i') noaster
}




/* TABLES 3 and 4 are created inside the same loop (over pollutants) */
foreach var of varlist totalPM10 totalVOC totalNOx totalSO2 totalCO {
/*TABLE 3: Parametric regressions for other pollutants in 1984 and 2012 */
	/*The OLS regressions */
	reg `var' c.aftertax_income##c.aftertax_income `final_controls' [pw=adjwt2] if year==1984, robust
	testparm c.aftertax_income##c.aftertax_income
	if `var'==totalPM10 outreg2 using "Output Files\Table 3", addstat("F-test income",r(F),"P-value of F-test",r(p)) excel replace ctitle(`var') noaster addnote("Margins are calculated at the annual median value of aftertax_income.  All other variables at annual means.")
	else outreg2 using "Output Files\Table 3", addstat("F-test income",r(F),"P-value of F-test",r(p)) excel append ctitle(`var') noaster
	margins if year==1984, eyex(aftertax_income) at( (mean) _all (median) aftertax_income) post
	outreg2 using "Output Files\Table 3", excel append ctitle(margins`var') noaster
	
	reg `var' c.aftertax_income##c.aftertax_income `final_controls' [pw=adjwt2] if year==2012, robust
	testparm c.aftertax_income##c.aftertax_income
	if `var'==totalPM10 outreg2 using "Output Files\Table 3", addstat("F-test income",r(F),"P-value of F-test",r(p)) excel replace ctitle(`var') noaster  addnote("Margins are calculated at the annual median value of aftertax_income.  All other variables at annual means.")
	else outreg2 using "Output Files\Table 3", addstat("F-test income",r(F),"P-value of F-test",r(p)) excel append ctitle(`var') noaster
	margins if year==2012, eyex(aftertax_income)  at( (mean) _all (median) aftertax_income)  post
	outreg2 using "Output Files\Table 3", excel append ctitle(margins`var')  noaster
	
/* TABLE 4: Oaxaca decompositions */
	/* NOTE: reverse the signs when reporting the Oaxaca-Blinder output */
	oaxaca `var' aftertax_income aftertax_income2 `final_controls' [pw=adjwt2] if year==1984|year==2012, by(year) vce(robust) detail weight(1)
	test [explained]race_black [explained]race_asian [explained]race_other
	test [explained]edu_high [explained]edu_somecoll [explained]edu_college [explained]edu_grad
	test [explained]midwest [explained]south [explained]west
	test [explained]race_black+[explained]race_asian +[explained]race_other +[explained]edu_high+ [explained]edu_somecoll +[explained]edu_college +[explained]edu_grad +[explained]midwest +[explained]south +[explained]west=0
	
	if `var'==totalPM10 outreg2 using "Output Files\Table 4", excel replace noaster
	else outreg2 using "Output Files\Table 4", excel append noaster
	
}

/* TABLE 5: Summary of Effects:
This table is calculated in Excel based on the annual sample means for all variables and the OLS coeffifients
	for each pollutant in 1984 */


	

/* FIGURES
--------------------------------------------------------------------*/
*Code for level bins, based on 1984 (whole year) percentile cutoffs;
local number_bins = 50	/*set the number of bins to use for aggregating income */
local base_year=1984	/* this sets the reference year as 1984 */


/* FIGURE 1: Non-Parametric EECs for PM10 based on aftertax income */
/* Create bins based on aftertax income */
_pctile aftertax_income if year==`base_year' [pweight=adjwt2], nq(`number_bins')
gen at_bin = .
gen at_incomebin=.
forvalues i=1/`number_bins' {
	if `i'==1 {
		replace at_bin = `i' if aftertax_income<=r(r`i')
		replace at_incomebin = r(r`i') if aftertax_income<=r(r`i')
		}
	else {
		local j=`i'-1
		replace at_bin = `i' if aftertax_income>r(r`j')&aftertax_income<=r(r`i')
		replace at_incomebin = r(r`i') if aftertax_income>r(r`j')&aftertax_income<=r(r`i')
		if `i'==`number_bins' {
			replace at_bin=`i' if aftertax_income>r(r`i')
			local rbin = r(r`j')
			quietly sum aftertax_income if year==`base_year'
			replace at_incomebin=(`rbin'+r(max))/2 if aftertax_income>`rbin'
			}
			}
} /* closes the forvalues i->number_bins loop */


*Aggregating data into bins ( account for weights)
preserve
collapse (sum) num_hh = count (mean) av_PM10 = totalPM10 av_inc=income av_cons=consumption av_aftertax_inc=aftertax_income ///
	fullyr respstat (median) med_inc=income med_aftertax_inc=aftertax_income med_cons=consumption  [pw=adjwt2], by(year at_bin at_incomebin)
format _all %14.0g
twoway 	(scatter av_PM10 av_aftertax_inc  if year==1984, color(navy) msize(medium) msymbol(Oh)) ///
		(scatter  av_PM10 av_aftertax_inc if year==2012, color(maroon) m(t) msize(medium) ) ///
		(lowess av_PM10 av_aftertax_inc  if year==2012, lpattern(dash) lwidth(medium) color(maroon) ) ///
		(lowess   av_PM10 av_aftertax_inc if year==1984, lpattern(dash) lwidth(medium) color(navy) ),	///
		xtitle("Average After-Tax Income (10,000 2002 $)") xlabel(,format(%9.0fc))  ytitle("Average PM10 per Household (pounds)") ///
		legend(region(lcolor(white)) ring(0) pos(4) cols(1) order( 1  "1984" 2 "2012" ))	name("PM10aftertax_income", replace) ///
		/*note("Income and consumption are adjusted for inflation using the core CPI.  Food, fuel, gasoline," ///
			 "and electricity are adjusted seperately using the corresponding CPI.  Income is expressed in" ///
			 "real 2002 dollars and adjusted using the CPI for all items and all urban consumers.") */    /// 
		graphregion(color(white)) bgcolor(white) plotregion(style(none) fcolor(white))
graph export  "Output Files\Figure 1.png", as(png) replace width(1000)

/* Appendix Figure A.12: Share of HH in each bin, 1984 and 2012 */
egen total_hh=total(num_hh), by(year)
gen share_hh = num_hh/total_hh

keep if year==1984|year==2012
keep num_hh share_hh year at_bin

reshape wide num_hh share_hh, i(at_bin) j(year)

gen at_bin1 = at_bin-.25
gen at_bin2 = at_bin+.25
graph twoway (bar share_hh1984 at_bin1, color(gray) barw(0.5) ) (bar share_hh2012 at_bin2, color(maroon) barw(0.5) ), ///
		xtitle("After-Tax Income Bin") ytitle("Percent of Households") ///
		legend(region(lcolor(white)) ring(0) pos(10) cols(1) order( 1  "1984" 2 "2012" ))	name("inc_dist", replace) ///
		graphregion(color(white)) bgcolor(white) plotregion(style(none) fcolor(white))
graph export  "Output Files\Appendix Figure A12.png", as(png) replace width(1000)

/* Number of households in bottom quintile: */
gen quintile = 1 if at_bin<=10
replace quintile = 2 if at_bin<=20&quintile==.
replace quintile = 3 if at_bin<=30&quintile==.
replace quintile = 4 if at_bin<=40&quintile==.
replace quintile = 5 if at_bin<=50&quintile==.

collapse (sum) num_hh* share_hh*, by(quintile)
/* Num and Share of households per quintile of 1984 distribution:
quintile	num_hh1984	num_hh2012	share_hh1984	share_hh2012
1	17314772.4795	20657273.1887	.2000612	.169804
2	17316241.3553	24487181.9673	.2000782	.2012861
3	17308557.6058	21659610.6191	.1999894	.1780433
4	17305130.956	21996502.2612	.1999498	.1808125
5	17302683.5337	32853066.9797	.1999215	.2700541
*/
restore


/* FIGURE 2: Nonparametric EECs for Other Pollutants; after-tax income */
preserve
collapse (mean) av_PM10 = totalPM10 av_CO=totalCO av_SO2=totalSO2 av_NOx=totalNOx av_VOC=totalVOC ///
		av_aftertax_inc=aftertax_income [pw=adjwt2], by(year at_bin at_incomebin )
format _all %14.0g
twoway 	(scatter av_CO av_aftertax_inc  if year==1984, color(navy) msize(medium) msymbol(Oh)) ///
		(scatter  av_CO av_aftertax_inc if year==2012, color(maroon) m(t) msize(medium) ) ///
		(lowess av_CO av_aftertax_inc  if year==2012, lpattern(dash) lwidth(medium) color(maroon) ) ///
		(lowess   av_CO av_aftertax_inc if year==1984, lpattern(dash) lwidth(medium) color(navy) ),	///
		legend(region(lcolor(white)) ring(0) pos(4) cols(1) order( 1  "1984" 2 "2012" ))	name("COaftertax_income", replace) ///
		graphregion(color(white)) bgcolor(white) plotregion(style(none) fcolor(white)) ///
		title("CO")  xtitle("") ylabel(#4) nodraw 

twoway 	(scatter av_NOx av_aftertax_inc  if year==1984, color(navy) msize(medium) msymbol(Oh)) ///
		(scatter  av_NOx av_aftertax_inc if year==2012, color(maroon) m(t) msize(medium) ) ///
		(lowess av_NOx av_aftertax_inc  if year==2012, lpattern(dash) lwidth(medium) color(maroon) ) ///
		(lowess   av_NOx av_aftertax_inc if year==1984, lpattern(dash) lwidth(medium) color(navy) ),	///
		legend(region(lcolor(white)) ring(0) pos(4) cols(1) order( 1  "1984" 2 "2012" ))	name("NOxaftertax_income", replace) ///
		graphregion(color(white)) bgcolor(white) plotregion(style(none) fcolor(white)) ///
		title("NOx") xtitle("") ylabel(#4) nodraw 
		
twoway 	(scatter av_SO2 av_aftertax_inc  if year==1984, color(navy) msize(medium) msymbol(Oh)) ///
		(scatter  av_SO2 av_aftertax_inc if year==2012, color(maroon) m(t) msize(medium) ) ///
		(lowess av_SO2 av_aftertax_inc  if year==2012, lpattern(dash) lwidth(medium) color(maroon) ) ///
		(lowess   av_SO2 av_aftertax_inc if year==1984, lpattern(dash) lwidth(medium) color(navy) ),	///
		legend(region(lcolor(white)) ring(0) pos(4) cols(1) order( 1  "1984" 2 "2012" ))	name("SO2aftertax_income", replace) ///
		graphregion(color(white)) bgcolor(white) plotregion(style(none) fcolor(white)) ///
		title("SO2") xtitle("") ylabel(#4) nodraw 
		
twoway 	(scatter av_VOC av_aftertax_inc  if year==1984, color(navy) msize(medium) msymbol(Oh)) ///
		(scatter  av_VOC av_aftertax_inc if year==2012, color(maroon) m(t) msize(medium) ) ///
		(lowess av_VOC av_aftertax_inc  if year==2012, lpattern(dash) lwidth(medium) color(maroon) ) ///
		(lowess   av_VOC av_aftertax_inc if year==1984, lpattern(dash) lwidth(medium) color(navy) ),	///
		legend(region(lcolor(white)) ring(0) pos(4) cols(1) order( 1  "1984" 2 "2012" ))	name("VOCaftertax_income", replace) ///
		graphregion(color(white)) bgcolor(white) plotregion(style(none) fcolor(white)) ///
		title("VOC") xtitle("") ylabel(#4) nodraw 

graph combine VOCaftertax_income NOxaftertax_income SO2aftertax_income  COaftertax_income, ///
	l1("Average Pollution per Household (pounds)") b1("Average After-Tax Income (10,000 2002 $)") ///
	graphregion(color(white))  plotregion(style(none) fcolor(white)) name("Figure2", replace)
restore
graph export  "Output Files\Figure 2.png", as(png) replace width(1000)




/* Appendix Figure A.15: Non-Parametric EECs based on pre-tax income */
/* Create bins based on total income */
_pctile income if year==`base_year'  [pweight=adjwt2], nq(`number_bins')
gen i_bin = .
gen incomebin=.
forvalues i=1/`number_bins' {
	if `i'==1 {
		replace i_bin = `i' if income<=r(r`i')
		replace incomebin = r(r`i') if income<=r(r`i')
		}
	else {
		local j=`i'-1
		replace i_bin = `i' if income>r(r`j')&income<=r(r`i')
		replace incomebin = r(r`i') if income>r(r`j')&income<=r(r`i')
		if `i'==`number_bins' {
			replace i_bin=`i' if income>r(r`i')
			local rbin = r(r`j')
			quietly sum income if year==`base_year'
			replace incomebin=(`rbin'+r(max))/2 if income>`rbin'
			}
			}
} /* closes the forvalues i->number_bins loop */


*Aggregating data into bins ( account for weights)
preserve
collapse (sum) num_hh = count (mean) av_PM10 = totalPM10 av_inc=income av_cons=consumption av_aftertax_inc=aftertax_income ///
	fullyr respstat (median) med_inc=income med_aftertax_inc=aftertax_income med_cons=consumption [pw=adjwt2], by(year i_bin )
format _all %14.0g

twoway 	(scatter av_PM10 av_inc  if year==1984, color(navy) msize(medium) msymbol(Oh)) ///
		(scatter av_PM10 av_inc if year==2012, color(maroon) m(t) msize(medium) ) ///
		(lowess av_PM10 av_inc  if year==2012, lpattern(dash) lwidth(medium) color(maroon) ) ///
		(lowess av_PM10 av_inc if year==1984, lpattern(dash) lwidth(medium) color(navy) ),	///
		xtitle("Average Pre-Tax Income (10,000 2002 $)") xlabel(,format(%9.0fc))  ytitle("Average PM10 per Household (pounds)") ///
		legend(region(lcolor(white)) ring(0) pos(4) cols(1) order( 1  "1984" 2 "2012" ))	name("PM10pretax_income", replace) ///
		/*note("Income and consumption are adjusted for inflation using the core CPI.  Food, fuel, gasoline," ///
			 "and electricity are adjusted seperately using the corresponding CPI.  Income is expressed in" ///
			 "real 2002 dollars and adjusted using the CPI for all items and all urban consumers.") */    /// 
		graphregion(color(white)) bgcolor(white) plotregion(style(none) fcolor(white))
restore
graph export  "Output Files\Appendix Figure A15.png", as(png) replace width(1000)


/* Appendix Figure A.8 and A.9: Non-Parametric EECs based on total consumption expenditure */
/* Create bins based on total income */
_pctile consumption if year==`base_year' [pweight=adjwt2], nq(`number_bins')
gen c_bin = .
gen consumptionbin=.
forvalues i=1/`number_bins' {
	if `i'==1 {
		replace c_bin = `i' if consumption<=r(r`i')
		replace consumptionbin = r(r`i') if consumption<=r(r`i')
		}
	else {
		local j=`i'-1
		replace c_bin = `i' if consumption>r(r`j')&consumption<=r(r`i')
		replace consumptionbin = r(r`i') if consumption>r(r`j')&consumption<=r(r`i')
		if `i'==`number_bins' {
			replace c_bin=`i' if income>r(r`i')
			local rbin = r(r`j')
			quietly sum income if year==`base_year'
			replace consumptionbin=(`rbin'+r(max))/2 if consumption>`rbin'
			}
			}
} /* closes the forvalues i->number_bins loop */


*Aggregating data into bins ( account for weights)
preserve
collapse (sum) num_hh = count (mean) av_PM10 = totalPM10 av_inc=income av_cons=consumption av_aftertax_inc=aftertax_income ///
	fullyr respstat (median) med_inc=income med_aftertax_inc=aftertax_income med_cons=consumption [pw=adjwt2], by(year c_bin )
format _all %14.0g

twoway 	(scatter av_PM10 av_cons  if year==1984, color(navy) msize(medium) msymbol(Oh)) ///
		(scatter  av_PM10 av_cons if year==2012, color(maroon) m(t) msize(medium) ) ///
		(lowess av_PM10 av_cons  if year==2012, lpattern(dash) lwidth(medium) color(maroon) ) ///
		(lowess   av_PM10 av_cons if year==1984, lpattern(dash) lwidth(medium) color(navy) ),	///
		xtitle("Average Total Expenditure (10,000 2002 $)") xlabel(,format(%9.0fc))  ytitle("Average PM10 per Household (pounds)") ///
		legend(region(lcolor(white)) ring(0) pos(4) cols(1) order( 1  "1984" 2 "2012" ))	name("Appendix_Fig_A8", replace) ///
		/*note("Income and consumption are adjusted for inflation using the core CPI.  Food, fuel, gasoline," ///
			 "and electricity are adjusted seperately using the corresponding CPI.  Income is expressed in" ///
			 "real 2002 dollars and adjusted using the CPI for all items and all urban consumers.") */    /// 
		graphregion(color(white)) bgcolor(white) plotregion(style(none) fcolor(white))
restore
graph export  "Output Files\Appendix Figure A8.png", as(png) replace width(1000)

preserve
collapse (mean) av_PM10 = totalPM10 av_CO=totalCO av_SO2=totalSO2 av_NOx=totalNOx av_VOC=totalVOC ///
		av_aftertax_inc=aftertax_income  av_cons=consumption [pw=adjwt2], by(year c_bin consumptionbin /*quarter*/)
format _all %14.0g
twoway 	(scatter av_CO av_cons  if year==1984, color(navy) msize(medium) msymbol(Oh)) ///
		(scatter  av_CO av_cons if year==2012, color(maroon) m(t) msize(medium) ) ///
		(lowess av_CO av_cons  if year==2012, lpattern(dash) lwidth(medium) color(maroon) ) ///
		(lowess   av_CO av_cons if year==1984, lpattern(dash) lwidth(medium) color(navy) ),	///
		legend(region(lcolor(white)) ring(0) pos(4) cols(2) order( 1  "1984" 2 "2012" ))	name("COconsumption", replace) ///
		graphregion(color(white)) bgcolor(white) plotregion(style(none) fcolor(white)) ///
		title("CO")  xtitle("") nodraw 

twoway 	(scatter av_NOx av_cons  if year==1984, color(navy) msize(medium) msymbol(Oh)) ///
		(scatter  av_NOx av_cons if year==2012, color(maroon) m(t) msize(medium) ) ///
		(lowess av_NOx av_cons  if year==2012, lpattern(dash) lwidth(medium) color(maroon) ) ///
		(lowess   av_NOx av_cons if year==1984, lpattern(dash) lwidth(medium) color(navy) ),	///
		legend(region(lcolor(white)) ring(0) pos(4) cols(2) order( 1  "1984" 2 "2012" ))	name("NOxconsumption", replace) ///
		graphregion(color(white)) bgcolor(white) plotregion(style(none) fcolor(white)) ///
		title("NOx") xtitle("") nodraw 
		
twoway 	(scatter av_SO2 av_cons  if year==1984, color(navy) msize(medium) msymbol(Oh)) ///
		(scatter  av_SO2 av_cons if year==2012, color(maroon) m(t) msize(medium) ) ///
		(lowess av_SO2 av_cons  if year==2012, lpattern(dash) lwidth(medium) color(maroon) ) ///
		(lowess   av_SO2 av_cons if year==1984, lpattern(dash) lwidth(medium) color(navy) ),	///
		legend(region(lcolor(white)) ring(0) pos(4) cols(2) order( 1  "1984" 2 "2012" ))	name("SO2consumption", replace) ///
		graphregion(color(white)) bgcolor(white) plotregion(style(none) fcolor(white)) ///
		title("SO2") xtitle("") nodraw 
		
twoway 	(scatter av_VOC av_cons  if year==1984, color(navy) msize(medium) msymbol(Oh)) ///
		(scatter  av_VOC av_cons if year==2012, color(maroon) m(t) msize(medium) ) ///
		(lowess av_VOC av_cons  if year==2012, lpattern(dash) lwidth(medium) color(maroon) ) ///
		(lowess   av_VOC av_cons if year==1984, lpattern(dash) lwidth(medium) color(navy) ),	///
		legend(region(lcolor(white)) ring(0) pos(4) cols(2) order( 1  "1984" 2 "2012" ))	name("VOCconsumption", replace) ///
		graphregion(color(white)) bgcolor(white) plotregion(style(none) fcolor(white)) ///
		title("VOC") xtitle("") nodraw 
		
grc1leg  VOCconsumption NOxconsumption SO2consumption  COconsumption, ///
	b1("Average Total Expenditure (10,000 2002 $)")  ///
	l1("Average Pollution per Household (pounds)") ///
    graphregion(color(white))  plotregion(style(none) fcolor(white)) name("Appendix_Fig_A9", replace)
restore
graph export  "Output Files\Appendix Figure A9.png", as(png) replace width(1000)



/* FIGURE 3: PM10 EECs based on parametric estimates */
reg totalPM10 aftertax_income aftertax_income2 [pw=adjwt2] if year==1984, robust
predict yhat1984_nodemos if year==1984

reg totalPM10 aftertax_income aftertax_income2 `final_controls' [pw=adjwt2] if year==1984, robust
adjust `final_controls' if year==1984, gen(yhat1984 se1984) se
gen cilow1984 = yhat1984-1.96*se1984
gen cihigh1984 = yhat1984+1.96*se1984

reg totalPM10 aftertax_income aftertax_income2 [pw=adjwt2] if year==2012, robust
predict yhat2012_nodemos if year==2012

reg totalPM10 aftertax_income aftertax_income2 `final_controls' [pw=adjwt2] if year==2012, robust
adjust `final_controls' if year==2012, gen(yhat2012 se2012) se
gen cilow2012 = yhat2012-1.96*se2012 if year==2012
ge cihigh2012 = yhat2012+1.96*se2012 if year==2012

sort aftertax_income
twoway  (rarea cilow1984 cihigh1984 aftertax_income if year==1984, fi(25) lwidth(vvthin) lstyle( ) lcolor(navy*0)  lpattern(shortdash)  ) ///
		(rarea cilow2012 cihigh2012 aftertax_income if year==2012, fi(25) lwidth(vvthin) lstyle() lcolor(maroon*0)  lpattern(shortdash) ) ///
		(line yhat1984_nodemos aftertax_income if year==1984, lpattern(solid)  color(black)   ) ///
		(line yhat1984 aftertax_income if year==1984, lpattern(solid) lwidth(thick) color(navy)) ///
		(line yhat2012_nodemos aftertax_income if year==2012, lpattern(dash)  color(black) ) ///
		(line yhat2012 aftertax_income if year==2012, lpattern(dash) lwidth(thick) color(maroon)) ///
		, ///
		legend(region(lcolor(white)) ring(0) pos(4) cols(1) order( 3 "1984 - income and income squared" 4 "1984 with covariates" 5 "2012 - income and income squared" 6 "2012 with covariates" )  symxsize(5) ) ///
		xtitle("Average After-Tax Income (10,000 2002 $)") xlabel(,format(%9.0fc)) ///
		ytitle("Average PM10 per Household (pounds)") name(Fig3, replace) ///
		graphregion(color(white))  plotregion(style(none) fcolor(white))
graph export  "Output Files\Figure 3.png", as(png) replace width(1000)


/* Appendix Figure A.16: EECs based on parametric estimates for other pollutants */
foreach var in VOC NOx SO2 CO {

reg total`var' aftertax_income aftertax_income2 [pw=adjwt2] if year==1984, robust
predict `var'hat1984_nodemos if year==1984

reg total`var' aftertax_income aftertax_income2 `final_controls' [pw=adjwt2] if year==1984, robust
adjust `final_controls' if year==1984, gen(`var'hat1984 `var'se1984) se
gen `var'cilow1984 = `var'hat1984-1.96*`var'se1984 if year==1984
gen `var'cihigh1984 = `var'hat1984+1.96*`var'se1984 if year==1984

reg total`var' aftertax_income aftertax_income2 [pw=adjwt2] if year==2012, robust
predict `var'hat2012_nodemos if year==2012

reg total`var' aftertax_income aftertax_income2 `final_controls' [pw=adjwt2] if year==2012, robust
adjust `final_controls' if year==2012, gen(`var'hat2012 `var'se2012) se
gen `var'cilow2012 = `var'hat2012-1.96*`var'se2012 if year==2012
gen `var'cihigh2012 = `var'hat2012+1.96*`var'se2012 if year==2012

sort aftertax_income
twoway  (rarea `var'cilow1984 `var'cihigh1984 aftertax_income if year==1984, fi(25) lwidth(vvthin) lstyle( ) lcolor(navy*0)  lpattern(shortdash)  ) ///
		(rarea `var'cilow2012 `var'cihigh2012 aftertax_income if year==2012, fi(25) lwidth(vvthin) lstyle() lcolor(maroon*0)  lpattern(shortdash)  ) ///
		(line `var'hat1984_nodemos aftertax_income if year==1984, lpattern(solid)  color(black)   ) ///
		(line `var'hat1984 aftertax_income if year==1984, lpattern(solid) lwidth(thick) color(navy)) ///
		(line `var'hat2012_nodemos aftertax_income if year==2012, lpattern(dash)  color(black) ) ///
		(line `var'hat2012 aftertax_income if year==2012, lpattern(dash) lwidth(thick) color(maroon)) ///
			, ///
		legend(region(lcolor(white)) ring(0) pos(4) cols(2) order( 3 "1984 - income and income squared" 4 "1984 with covariates" 5 "2012 - income and income squared" 6 "2012 with covariates" )  symxsize(5) ) ///
		xtitle("") xlabel(,format(%9.0fc)) ///
		ytitle("") ylabel(#4)  name("`var'", replace) ///
		title("`var'") graphregion(color(white))  plotregion(style(none) fcolor(white)) nodraw  
}

grc1leg VOC NOx SO2 CO, ///
	b1("Average After-Tax Income (10,000 2002 $)")  ///
	l1("Average Pollution per Household (pounds)") ///
   graphregion(color(white))  plotregion(style(none) fcolor(white)) name("Figure_A16", replace) xcommon ///
  
graph export  "Output Files\Appendix Figure A16.png", as(png) replace width(1000)


/* FIGURE 4: Breakdown of effects over time */
/* This figure will be calculated in Excel, but sample means for each year are needed.  These are (manually) combined
	with the parametric estimates calculated above (combined in Excel)  */
preserve
collapse (mean) totalPM10 totalVOC totalNOx totalSO2 totalCO income income2 aftertax_income aftertax_income2 consumption consumption2 ///
		famsize famsize2 age age2 married race_white race_black race_asian race_other ///
		edu_elementary edu_high edu_somecoll edu_college edu_grad northeast midwest south west ///
		rural (sum) num_hh=count [pw=adjwt2] , by(year)
format num_hh %14.0g
export excel using "Output Files\Figure 4 supporting table", firstrow(variables) replace
restore


/* Appendix Figure A.10: Adding Income and Income squared ONLY curve to Figure 4 */
foreach var of varlist totalPM10 totalVOC totalNOx totalSO2 totalCO {
	/*OLS with only income and income squared */
	reg `var' aftertax_income aftertax_income2 [pw=adjwt2] if year==1984, robust
	test aftertax_income aftertax_income2
	if `var'==totalPM10 outreg2 using "Output Files\Appendix Figure A10 supporting table", addstat("F-test income",r(F)) excel replace ctitle(`var')
	else outreg2 using "Output Files\Appendix Figure A10 supporting table", addstat("F-test income",r(F)) excel append ctitle(`var')
}


/* Appendix Table A.2: Parametric EECs Including State Fixed Effects */
/* Adding State Fixed Effects (1993 onwards) */
/* State questions appear in the 1992 files, but are not present in all 4 quarters until 93 */
local fe_controls famsize famsize2 age age2 married race_black race_asian race_other edu_high edu_somecoll edu_college edu_grad rural

xi: reg totalPM10 c.aftertax_income##c.aftertax_income i.state [pw=adjwt2] if year==1993, robust
testparm c.aftertax_income##c.aftertax_income
outreg2 using "Output Files\Appendix Table A2", addstat("F-test income",r(F),"P-value of F-test",r(p)) excel replace ctitle(PM101993) alpha(.05) noaster /*symbol(*)*/
margins if year==1993, eyex(aftertax_income) at( (mean) _all (median) aftertax_income) post
outreg2 using "Output Files\Appendix Table A2",  excel append ctitle(PM101993_elast)  noaster

foreach pol in PM10 VOC NOx SO2 CO {
foreach i of numlist 1993 2005 2012 {
xi: reg total`pol' c.aftertax_income##c.aftertax_income `fe_controls' i.state [pw=adjwt2] if year==`i', robust
testparm c.aftertax_income##c.aftertax_income
outreg2 using "Output Files\Appendix Table A2", addstat("F-test income",r(F),"P-value of F-test",r(p)) excel append ctitle(`pol'`i') alpha(.05) noaster /*symbol(*)*/
margins if year==`i', eyex(aftertax_income) at( (mean) _all (median) aftertax_income) post
outreg2 using "Output Files\Appendix Table A2",  excel append ctitle(`pol'`i'_elast)  noaster
}
}

/* Appendix Figure A.13 and A.14 */
/* Estimating EECs using restricted cubic splines (over income) */
/* restricted cubic spline for PM10 */
mkspline2 rc1984=aftertax_income if year==1984, cubic displayknots
reg totalPM10 rc1984* `final_controls' [pw=adjwt2] if year==1984, robust
test rc19842 rc19843 rc19844
*outreg2 using "Output Files\Spline Coefficients", addstat("F-test for non-linearity",r(F),"P-value of F-test",r(p)) excel replace ctitle("PM10 1984") /*noaster*/
adjustrcspline, gen(PMhat1984_spline PMspline1984_low PMspline1984_high)

mkspline2 rc2012=aftertax_income if year==2012, cubic displayknots
reg totalPM10 rc2012* `final_controls' [pw=adjwt2] if year==2012, robust
test rc20122 rc20123 rc20124
*outreg2 using "Output Files\Spline Coefficients", addstat("F-test for non-linearity",r(F),"P-value of F-test",r(p)) excel append ctitle("PM10 2012") /*noaster*/
adjustrcspline, gen(PMhat2012_spline PMspline2012_low PMspline2012_high)

sort aftertax_income
twoway  (rarea PMspline1984_low PMspline1984_high aftertax_income if year==1984, fi(25) lwidth(vvthin) lstyle( ) lcolor(navy*0)  lpattern(shortdash)  ) ///
		(rarea PMspline2012_low PMspline2012_high aftertax_income if year==2012, fi(25) lwidth(vvthin) lstyle() lcolor(maroon*0)  lpattern(shortdash)  ) ///
		(line PMhat1984_spline aftertax_income if year==1984, lpattern(solid) lwidth(thick) color(navy)) ///
		(line PMhat2012_spline aftertax_income if year==2012, lpattern(dash) lwidth(thick) color(maroon)) ///
		, ///
		legend(region(lcolor(white)) ring(0) pos(4) cols(1) order( 3  "1984" 4 "2012" )  symxsize(5) ) ///
		xtitle("Average After-Tax Income (10,000 2002 $)") xlabel(,format(%9.0fc)) ///
		ytitle("Average PM10 per Household (pounds)") name(PMSpline, replace) ///
		graphregion(color(white))  plotregion(style(none) fcolor(white))
graph export  "Output Files\Appendix Figure A13.png", as(png) replace width(1000)

/* restricted cubic spline for other pollutants */
foreach var in VOC NOx SO2 CO {
drop rc*
mkspline2 rc1984=aftertax_income if year==1984, cubic displayknots
reg total`var' rc1984* `final_controls' [pw=adjwt2] if year==1984, robust
test rc19842 rc19843 rc19844
*outreg2 using "Output Files\Spline Coefficients", addstat("F-test for non-linearity",r(F),"P-value of F-test",r(p)) excel append ctitle("`var' 1984") /*noaster*/
adjustrcspline, gen(`var'hat1984_spline `var'spline1984_low `var'spline1984_high)

mkspline2 rc2012=aftertax_income if year==2012, cubic displayknots
reg total`var' rc2012* `final_controls' [pw=adjwt2] if year==2012, robust
test rc20122 rc20123 rc20124
*outreg2 using "Output Files\Spline Coefficients", addstat("F-test for non-linearity",r(F),"P-value of F-test",r(p)) excel append ctitle("`var' 2012") /*noaster*/
adjustrcspline, gen(`var'hat2012_spline `var'spline2012_low `var'spline2012_high)

sort aftertax_income
twoway  (rarea `var'spline1984_low `var'spline1984_high aftertax_income if year==1984, fi(25) lwidth(vvthin) lstyle( ) lcolor(navy*0)  lpattern(shortdash)  ) ///
		(rarea `var'spline2012_low `var'spline2012_high aftertax_income if year==2012, fi(25) lwidth(vvthin) lstyle() lcolor(maroon*0)  lpattern(shortdash)  ) ///
		(line `var'hat1984_spline aftertax_income if year==1984, lpattern(solid) lwidth(thick) color(navy)) ///
		(line `var'hat2012_spline aftertax_income if year==2012, lpattern(dash) lwidth(thick) color(maroon)) ///
		, ///
		legend(region(lcolor(white)) ring(0) pos(4) cols(1) order( 3  "1984" 4 "2012" )  symxsize(5) ) ///
		xtitle("") xlabel(,format(%9.0fc)) ///
		ytitle("") name("`var'", replace) ///
		title("`var'") graphregion(color(white))  plotregion(style(none) fcolor(white)) nodraw  
		
		
reg total`var' aftertax_income aftertax_income2 `final_controls' [pw=adjwt2] if year==1984, robust
adjust `final_controls' if year==1984, gen(`var'1984_sp)

reg total`var' aftertax_income aftertax_income2 `final_controls' [pw=adjwt2] if year==2012, robust
adjust `final_controls' if year==2012, gen(`var'2012_sp )

twoway  (rarea `var'spline1984_low `var'spline1984_high aftertax_income if year==1984, fi(25) lwidth(vvthin) lstyle( ) lcolor(navy*0)  lpattern(shortdash)  ) ///
		(rarea `var'spline2012_low `var'spline2012_high aftertax_income if year==2012, fi(25) lwidth(vvthin) lstyle() lcolor(maroon*0)  lpattern(shortdash)  ) ///
		(line `var'hat1984_spline aftertax_income if year==1984, lpattern(solid) lwidth(thick) color(navy)) ///
		(line `var'hat2012_spline aftertax_income if year==2012, lpattern(dash) lwidth(thick) color(maroon)) ///
		(line `var'1984_sp aftertax_income if year==1984, lpattern(dash) /*lwidth(thin)*/ color(black) ) ///
		(line `var'2012_sp aftertax_income if year==2012, lpattern(dash) /*lwidth(thin)*/ color(black) ) ///
		, ///
		legend(symplacement(center) region(lcolor(white)) ring(0) pos(4) rows(2) order( 3  "1984 Res. Cubic Spline" 4 "2012 Res. Cubic Spline" 5 "Quadratic Polynomials" )  symxsize(5) ) ///
		xtitle("") xlabel(,format(%9.0fc)) ///
		ytitle("") name(`var'Spline_Quad, replace) ///
		graphregion(color(white))  plotregion(style(none) fcolor(white)) nodraw  title("`var'")
}

grc1leg VOC NOx SO2 CO, ///
	b1("Average After-Tax Income (10,000 2002 $)")  ///
	l1("Average Pollution per Household (pounds)") ///
   graphregion(color(white))  plotregion(style(none) fcolor(white)) name("OtherSpline", replace)
graph export  "Output Files\Appendix Figure A14.png", as(png) replace width(1000)


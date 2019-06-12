*GENERAL INFO
	* Project: Political Competition and Public Goods Provision
	* Created by: Jessica Gottlieb
	* Date created: February 2018
	* Last updated: July 13, 2018
	* Last updated by: Jessica Gottlieb 
* DO FILE INFO
	* This .do file analyzes cross-country data for Gottlieb & Kosec APSR 

* HOUSEKEEPING
	clear
	set more off
* SET WORKING DIRECTORY
	*JG:
	capture cd "Dropbox\Research\Mali audit"		
	*KK:
	capture cd "C:\Users\KKOSEC\Dropbox (IFPRI)\Mali"
	*CH
	capture cd "C:\Users\Owner\Dropbox\Mali"
	
****************************************************	
	
***Start with merged file
use ".\Data\Cross-country data\CrossCountryMerge", clear

***Clean independent variable
su herf, d

***Declare panel data
encode iso, gen(ison)
xtset ison year, yearly

***Create moderating variables

///Party Institutionalization measure (v2xps_party) comes from VDEM dataset: 
/// Aggregation: The index is formed by adding the indicators for party organizations
/// (v2psorgs), party branches (v2psprbrch), party linkages (v2psprlnks), distinct party
/// platforms (v2psplats), and legislative party cohesion (v2pscohesv), after
///standardization. The index was then converted to its CDF in order to range from 0 to 1.

bysort ison: egen partysys=mean(v2xps_party)
xtile partysys2=partysys, nquantiles(2)

*Create a three-level indicator that distinguishes between more and less transparent countries
bysort ison: egen corruption=min( e_ti_cpi)
xtile corruption2=corruption, nquantiles(2)
gen triple=.
replace triple=0 if partysys2==1
replace triple=1 if partysys2==2 & corruption2==1
replace triple=2 if partysys2==2 & corruption2==2
label define triple 0 "Low PSI" 1 "High PSI, Low Transparency" 2 "High PSI, High Transparency"
label values triple triple

***Outliers
*Drop Zimbabwe (ison=181) given implausibly higher (>99th percentile) values on outcome variable and advice received from SPEED database manager Tewodaj Mogues in February 2018
drop if ison==181

**Recale population variable
replace population=population/100000
label var population "Population of country (100,000s)"


***Look at relative effect of changes in competition on pro-poor public goods outcomes (specific focuses: education, health, and social protection)

*Make global time trend

gen timetrend=year-1974

*Create a variable that contains the initial period values of outcomes with a time trend, then interact these with a trend (so we can enter them manually):

foreach x in gdpeducation_ppp gdphealth_ppp gdpsp_ppp	popeducation_ppp pophealth_ppp popsp_ppp	toteducation_ppp tothealth_ppp totsp_ppp	education_us health_us sp_us	electricity adjusted births health_expenditure immunization improved_water primary {
gen yearnonmiss=year if `x'!=.
egen firstyear = min(yearnonmiss), by(ison)
gen temp_`x'=`x' if year==firstyear
bysort ison: egen init_`x'=min(temp_`x')
drop yearnonmiss firstyear temp_`x'
label var init_`x' "Initial period value of `x' (time invariant)"
gen t_init_`x'=timetrend*init_`x'
label var t_init_`x' "Initial period value of `x' interacted with a time trend"
}


*Construct GDP per capita in constant 2005 dollars variable:

gen gdppc2005=(GDPCon/population)*0.897896
notes: gdppc2005 if we multiply every number for ever year and country by 0.897896, we change it from 2010 dollars to 2005 dollars (use December numbers found here: www.bls.gov/cpi/tables/historical-cpi-u-201712.pdf)
label var gdppc2005 "GDP per capita (constant 2005 US$)"

*Label variables
label var herf "Herfindahl Index"

*Create standardized variables

center herf, st gen(herfstd)
label var herfstd "Herfindahl Index (std.)"
center gdpeducation_ppp, st gen(educationstd)
label var educationstd "Education Expenditure as %GDP (std.)"



***************************
****APPENDIX TABLE A.18****
***************************

*Make list of countries of each type

xtreg immunization i.partysys2#c.herf herf t_init_immunization i.year population, fe cluster(ison)
gen immun_reg=(e(sample)==1)
label var immun_reg "Dummy - obs. present in reg of immunization rate on HHI and HHI x PSI"
bysort ison: egen cntryin_immun_reg=max(immun_reg)
label var cntryin_immun_reg "Dummy - country present in reg of immunization rate on HHI and HHI x PSI"

xtreg primary i.partysys2#c.herf herf t_init_primary i.year population, fe cluster(ison)
gen primary_reg=(e(sample)==1)
label var primary_reg "Dummy - obs. present in reg of primary completion on HHI and HHI x PSI"
bysort ison: egen cntryin_primary_reg=max(primary_reg)
label var cntryin_primary_reg "Dummy - country present in reg of primary completion on HHI and HHI x PSI"

xtreg gdphealth_ppp i.partysys2#c.herf herf t_init_gdphealth_ppp i.year population, fe cluster(ison)
gen healthexpend_reg=(e(sample)==1)
label var healthexpend_reg "Dummy - obs. present in reg of health expend per GDP on HHI and HHI x PSI"
bysort ison: egen cntryin_healthexpend_reg=max(healthexpend_reg)
label var cntryin_healthexpend_reg "Dummy - country present in reg of health expend per GDP on HHI and HHI x PSI"

xtreg gdpeducation_ppp i.partysys2#c.herf herf t_init_gdpeducation_ppp i.year population, fe cluster(ison)
gen edexpend_reg=(e(sample)==1)
label var edexpend_reg "Dummy - obs. present in reg of educ expend per GDP on HHI and HHI x PSI"
bysort ison: egen cntryin_edexpend_reg=max(edexpend_reg)
label var cntryin_edexpend_reg "Dummy - country present in reg of educ expend per GDP on HHI and HHI x PSI"

gen controls_nonmiss=1
replace controls_nonmiss=0 if population==.|herf==.|partysys2==.
label var controls_nonmiss "RHS variables are non-missing"

*These are all of the countries with low PSI that appear in at least one of the two regs (education expend as a share of GDP reg or primary completion rate reg):
tab countryname if partysys2==1 & (edexpend_reg==1|primary_reg==1)
*These are all of the countries with high PSI that appear in at least one of the two regs (education expend as a share of GDP reg or primary completion rate reg):
tab countryname if partysys2==2 & (edexpend_reg==1|primary_reg==1)

*These are countries with low PSI that are only in the education expend as a share of GDP reg (and not in the primary completion rate reg):
tab countryname if partysys2==1 & cntryin_edexpend_reg==1 & cntryin_primary_reg==0 /*no observations*/
*These are countries with low PSI that are only in the primary completion rate reg (and not in the education expend as a share of GDP reg):
tab countryname if partysys2==1 & cntryin_edexpend_reg==0 & cntryin_primary_reg==1
*These are countries with high PSI that are only in the education expend as a share of GDP reg (and not in the primary completion rate reg):
tab countryname if partysys2==2 & cntryin_edexpend_reg==1 & cntryin_primary_reg==0
*These are countries with high PSI that are only in the primary completion rate reg (and not in the education expend as a share of GDP reg):
tab countryname if partysys2==2 & cntryin_edexpend_reg==0 & cntryin_primary_reg==1

*Below command confirms that every country in health expenditure reg is in ed expenditure reg, and vice versa. So, we can ignore cntryin_healthexpend_reg and only focus on cntryin_edexpend_reg
tab cntryin_healthexpend_reg cntryin_edexpend_reg

*The below two commands show that if a country is non-missing for education expenditures (or for primary completion), it is also non-missing for immunization rate. 
count if cntryin_immun_reg==0 & cntryin_edexpend_reg==1
*0
count if cntryin_immun_reg==0 & cntryin_primary_reg==1
*0

*These are countries only in immunization regs:
tab countryname if partysys2==1 & cntryin_immun_reg==1 & cntryin_edexpend_reg==0 & cntryin_primary_reg==0

*                           Country Name |      Freq.     Percent        Cum.
*----------------------------------------+-----------------------------------
*                                Somalia |         41       89.13       89.13
*                            South Sudan |          5       10.87      100.00
*----------------------------------------+-----------------------------------
*                                  Total |         46      100.00

tab countryname if partysys2==2 & cntryin_immun_reg==1 & cntryin_edexpend_reg==0 & cntryin_primary_reg==0

*                           Country Name |      Freq.     Percent        Cum.
*----------------------------------------+-----------------------------------
*                            Bosnia-Herz |         41       50.00       50.00
*                           Turkmenistan |         41       50.00      100.00
*----------------------------------------+-----------------------------------
*                                  Total |         82      100.00


***************************
****APPENDIX TABLE A.19****
***************************

*Summarize all outcomes over the full sample for which the outcome is non-missing (reflects the sample actually used for each of these outcomes, in the regs):
forvalues y=1/2 {
foreach x in gdpeducation_ppp gdphealth_ppp popeducation_ppp pophealth_ppp primary immunization {
sum `x' if controls_nonmiss==1 & partysys2==`y'
}
}

forvalues y=1/2 {
foreach x in herf population partysys corruption corruption2 {
sum `x' if edexpend_reg==1 & partysys2==`y'
}
}



***************************
****APPENDIX TABLE A.20****
***************************

*6 basic regressions (partysys2 as moderator):

xtreg gdpeducation_ppp i.partysys2#c.herf herf t_init_gdpeducation_ppp i.year population, fe cluster(ison)
estimates store model1
xtreg gdphealth_ppp i.partysys2#c.herf herf t_init_gdphealth_ppp i.year population, fe cluster(ison)
estimates store model2

xtreg popeducation_ppp i.partysys2#c.herf herf t_init_popeducation_ppp i.year population, fe cluster(ison)
estimates store model3
xtreg pophealth_ppp i.partysys2#c.herf herf t_init_pophealth_ppp i.year population, fe cluster(ison)
estimates store model4

xtreg primary i.partysys2#c.herf herf t_init_primary i.year population, fe cluster(ison)
estimates store model5
xtreg immunization i.partysys2#c.herf herf t_init_immunization i.year population, fe cluster(ison)
estimates store model6

esttab model1 model2 model3 model4 model5 model6 /// 
	using ".\Tables\crosscountry_partysys2.tex", star(* 0.10 ** 0.05 *** 0.01) se b(3) se(3) r2(2) label booktabs alignment(D{.}{.}{-1}) replace ///
	stats(N,layout("\multicolumn{1}{c}{@}") labels("Observations") f(0))  ///
	title(Effect of HHI on Public Goods Provision by Party System Institutionalization \label{tab:crosscountry_partysys2})  ///
	mtitles("Education" "Health" "Education" "Health" "Primary" "Immunization") ///
	sub("\begin{table}[htbp]" "\begin{table}[htbp] \setlength{\tabcolsep}{-1pt} ") ///
	nonotes  nobaselevels  nogaps  ///
	addnote("OLS models with standard errors clustered at the country level. $^* p<0.10$, $^{**} p<0.05$, $^{***} p<0.01$")

	
*6 additional regressions, looking at whether accounting for transparency helps by crossing high PSI with high vs. low transparency (base group is low PSI):

xtreg gdpeducation_ppp i.triple#c.herf herf t_init_gdpeducation_ppp i.year population, fe cluster(ison)
estimates store model11
xtreg gdphealth_ppp i.triple#c.herf herf t_init_gdphealth_ppp i.year population, fe cluster(ison)
estimates store model22

xtreg popeducation_ppp i.triple#c.herf herf t_init_popeducation_ppp i.year population, fe cluster(ison)
estimates store model33
xtreg pophealth_ppp i.triple#c.herf herf t_init_pophealth_ppp i.year population, fe cluster(ison)
estimates store model44

xtreg primary i.triple#c.herf herf t_init_primary i.year population, fe cluster(ison)
estimates store model55
xtreg immunization i.triple#c.herf herf t_init_immunization i.year population, fe cluster(ison)
estimates store model66

esttab model11 model22 model33 model44 model55 model66 /// 
	using ".\Tables\crosscountry_triple.tex", star(* 0.10 ** 0.05 *** 0.01) se b(3) se(3) r2(2) label booktabs alignment(D{.}{.}{-1}) replace ///
	stats(N,layout("\multicolumn{1}{c}{@}") labels("Observations") f(0))  ///
	title(Effect of HHI on Public Goods Provision \label{tab:crosscountry_triple})  ///
	mtitles("share GDP" "share GDP" "per capita" "per capita" "completion" "(measles)") ///
	sub("\begin{table}[htbp]" "\begin{table}[htbp] \setlength{\tabcolsep}{-1pt} ") ///
	nonotes  nobaselevels  nogaps  ///
	addnote("OLS models with standard errors clustered at the country level. $^* p<0.10$, $^{**} p<0.05$, $^{***} p<0.01$")



****************
****FIGURE 5****
****************

*Plotting marginal effects by PSI
label define partysys2 1 "Low PSI" 2 "High PSI"
label values partysys2 partysys2

estimates restore model1
*Are the marginal effects significantly different even though the CIs appear to cross? Yes!
margins, at(partysys2 =(1 2)) dydx(herf) post
 test _b[1bn._at] = _b[2._at]

estimates restore model1
margins, dydx(herf) by(partysys2)
marginsplot, plotopts(connect(none)) name(gdped, replace) title(Effects on Education Expenditure as Percent of GDP) scheme(plotplainblind) yline(0, lcolor(red))	///
xlabel(, valuelabel) xmtick(.5(1)2.5, grid gmin gmax) xsc(range(.5(1)2.5)) ytitle("") xtitle("")

estimates restore model5
*Are the marginal effects significantly different even though the CIs appear to cross? Yes!
margins, at(partysys2 =(1 2)) dydx(herf) post
 test _b[1bn._at] = _b[2._at]

estimates restore model5
margins, dydx(herf) by(partysys2)
marginsplot, plotopts(connect(none)) name(primary, replace) title(Effects on Primary School Completion Rate) scheme(plotplainblind) yline(0, lcolor(red))	///
xlabel(, valuelabel) xmtick(.5(1)2.5, grid gmin gmax) xsc(range(.5(1)2.5)) ytitle("") xtitle("")

estimates restore model2
margins, dydx(herf) by(partysys2)
marginsplot, plotopts(connect(none)) name(gdphealth, replace) title(Effects on Health Expenditure as Percent of GDP) scheme(plotplainblind) yline(0, lcolor(red))	///
xlabel(, valuelabel) xmtick(.5(1)2.5, grid gmin gmax) xsc(range(.5(1)2.5)) ytitle("") xtitle("")

estimates restore model6
*Are the marginal effects significantly different even though the CIs appear to cross? No.
margins, at(partysys2 =(1 2)) dydx(herf) post
 test _b[1bn._at] = _b[2._at]

estimates restore model6
margins, dydx(herf) by(partysys2)
marginsplot, plotopts(connect(none)) name(immunization, replace) title(Effects on Immunization Rate) scheme(plotplainblind) yline(0, lcolor(red))	///
xlabel(, valuelabel) xmtick(.5(1)2.5, grid gmin gmax) xsc(range(.5(1)2.5)) ytitle("") xtitle("")

graph combine gdped gdphealth primary immunization, graphregion(fcolor(white) ilcolor(white) lcolor(white)) cols(2) name(graph, replace) ///
l1(Marginal Effect of Herfindahl Index with 95% CIs) b1(Party System Institutionalization)
graph export "Figures\CrossCountry\MarginalEffects.pdf", as(pdf) replace


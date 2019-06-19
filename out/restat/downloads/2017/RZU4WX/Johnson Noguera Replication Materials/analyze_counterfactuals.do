*************************************
**Format Counterfactuals for Analysis
*************************************

insheet using ".\data\simulation_country_list.csv", clear
ren v1 cnum
ren v2 ccode
gen matnum=_n
sort matnum
local new = _N + 1
set obs `new'
replace ccode="ROW" if ccode==""
replace matnum=matnum[_n-1]+1 if ccode=="ROW"
sort matnum
save ".\data\templist", replace

insheet using ".\data\trade.txt", clear
ren v1 ematnum
ren v2 imatnum
ren v3 sector
ren v4 year
ren v5 exports
ren v6 vaexports
drop v7
save ".\data\temp", replace

**Load counterfactuals for endogenous capital model
clear
gen ematnum=.
gen imatnum=.
gen sector=.
gen year=.
save ".\simulation_output\counterfactuals", replace
foreach sim in prod prod_tc prod_iofg manuf_final manuf_input nonmanuf_final nonmanuf_input rta rtasplit rtaphasein {
	clear
	gen blank=.
	save ".\simulation_output\appenddata.dta", replace
	forvalues year=1971/2009 {
		local nextyear=`year'+1
		insheet using "./simulation_output/simresults_`sim'_`year'.txt", clear
		ren v1 ematnum
		ren v2 imatnum
		ren v3 sector
		ren v4 v`sim'
		ren v5 e`sim'
		drop v6
		gen year=`year'
		append using ".\simulation_output\appenddata.dta"
		save ".\simulation_output\appenddata.dta", replace
	}
	drop blank
	merge 1:1 ematnum imatnum sector year using ".\simulation_output\counterfactuals", nogenerate
	drop if ematnum==. & imatnum==.
	save ".\simulation_output\counterfactuals", replace
}

ren eprod exports_baseline
ren vprod vaexports_baseline
ren eprod_tc exports_tc
ren vprod_tc vaexports_tc
ren eprod_iofg exports_iofg
ren vprod_iofg vaexports_iofg
ren emanuf_final exports_manuf_final 
ren vmanuf_final vaexports_manuf_final
ren emanuf_input exports_manuf_input
ren vmanuf_input vaexports_manuf_input
ren enonmanuf_final exports_nonmanuf_final
ren vnonmanuf_final vaexports_nonmanuf_final
ren enonmanuf_input exports_nonmanuf_input
ren vnonmanuf_input vaexports_nonmanuf_input
ren erta exports_rta 
ren vrta vaexports_rta
ren ertasplit exports_split
ren vrtasplit vaexports_split
ren ertaphasein exports_phasein
ren vrtaphasein vaexports_phasein

erase ".\simulation_output\appenddata.dta"

**Merge on "true" data
merge 1:1 ematnum imatnum sector year using ".\data\temp", nogenerate
erase ".\data\temp.dta"

**Merge on names
ren ematnum matnum
sort matnum
merge matnum using ".\data\templist"
keep if _merge==3
drop _merge
ren matnum ematnum
ren ccode ecode
ren cnum enum
ren imatnum matnum
sort matnum
merge matnum using ".\data\templist"
keep if _merge==3
drop _merge
ren matnum imatnum
ren ccode icode
ren cnum inum
erase ".\data\templist.dta"

**Deal with 1970 and ROW
foreach tag in baseline tc iofg manuf_final manuf_input nonmanuf_final nonmanuf_input rta split phasein {
replace vaexports_`tag'=vaexports if year==1970
replace exports_`tag'=exports if year==1970
} 

**Clean up
drop if ecode=="ROW" | icode=="ROW"
drop ematnum imatnum 
sort ecode icode sector year
drop if ecode==icode
gen panel=1 if year==1970 | year==1975 | year==1980 | year==1985 | year==1990 | year==1995 | year==2000 | year==2005 | year==2009
save ".\simulation_output\counterfactuals", replace

*********************
**Figure 6: World VAX
*********************
use ".\simulation_output\counterfactuals", clear
collapse (sum) vaexports* exports*, by(year)
keep year vaexports exports *baseline *tc *iofg
gen vax=vaexports/exports
foreach tag in baseline tc iofg {
gen vax_`tag'=vaexports_`tag'/exports_`tag'
}

#d ;
line vax_baseline vax_iofg vax_tc vax year,
	lwidth(medium medium medium medthick) lcolor(navy navy navy black) lpattern(shortdash shortdash_dot longdash solid)
	legend(label(1 "Baseline") label(2 "IO & FG Expenditure Weights") label(3 "Trade Frictions") label(4 "Data") position(8) ring(0) col(1) region(color(none)))
	ylabel(.68(.02).82) plotregion(style(none)) graphregion(fcolor(white) lwidth(none) ilwidth(none) margin());
graph export ".\figures_and_tables\world_simulation.pdf", replace;

#d cr
**********************
**Figure 7: Sector VAX
**********************
use ".\simulation_output\counterfactuals", clear
collapse (sum) vaexports* exports*, by(sector year)
keep sector year vaexports exports *baseline *tc *iofg
gen vax=vaexports/exports
foreach tag in baseline tc iofg {
gen vax_`tag'=vaexports_`tag'/exports_`tag'
}

#d ;
line vax_baseline vax_iofg vax_tc vax year if sector==1, ytitle("VAX Ratio")
	lwidth(medium medium medium medthick) lcolor(navy navy navy black) lpattern(shortdash shortdash_dot longdash solid)
	legend(label(1 "Baseline") label(2 "IO & FG Expenditure Weights") label(3 "Trade Frictions") label(4 "Data") position(11) ring(0) col(1) region(color(none)))
	ylabel(1(.1)1.6) plotregion(style(none)) graphregion(fcolor(white) lwidth(none) ilwidth(none) margin());
graph export ".\figures_and_tables\world_nonmanuf_simulation.pdf", replace;	

#d ;
line vax_baseline vax_iofg vax_tc vax year if sector==2, ytitle("VAX Ratio")
	lwidth(medium medium medium medthick) lcolor(navy navy navy black) lpattern(shortdash shortdash_dot longdash solid)
	legend(label(1 "Baseline") label(2 "IO & FG Expenditure Weights") label(3 "Trade Frictions") label(4 "Data") position(7) ring(0) col(1) region(color(none)))
	ylabel(.35(.05).55) plotregion(style(none)) graphregion(fcolor(white) lwidth(none) ilwidth(none) margin());
graph export ".\figures_and_tables\world_manuf_simulation.pdf", replace;

#d cr
**********************************
**Figure 8: VAX changes by country
**********************************
use ".\simulation_output\counterfactuals", clear
collapse (sum) vaexports* exports*, by(ecode year)
keep ecode year vaexports exports *baseline *tc *iofg
gen vax=vaexports/exports
foreach tag in baseline tc iofg {
gen vax_`tag'=vaexports_`tag'/exports_`tag'
}

keep if year==1970 | year==2008
egen yr=group(year)
egen id=group(ecode)
tsset id yr
foreach tag in baseline tc iofg  {
gen change_`tag'=vax_`tag'-L.vax_`tag'
gen exratio_`tag'=exports_`tag'/L.exports_`tag'
}
gen change=vax-L.vax
drop if year==1970

#d ;
graph twoway function y=x, range(change) color(black) || scatter change_baseline change,
	mlabel(ecode) mlabposition(0) msymbol(none) mlabcolor(black)
	xlabel(-.3(.1).1) ylabel(-.3(.1).1)
	ytitle("Simulated Change") xtitle("Data") legend(off)
	plotregion(style(none)) graphregion(fcolor(white) lwidth(none) ilwidth(none) margin());
graph export ".\figures_and_tables\country_simulation_baseline.pdf", replace;	

graph twoway function y=x, range(change) color(black) || scatter change_iofg change,
	mlabel(ecode) mlabposition(0) msymbol(none) mlabcolor(black)
	xlabel(-.3(.1).1) ylabel(-.3(.1).1)
	ytitle("Simulated Change") xtitle("Data") legend(off)
	plotregion(style(none)) graphregion(fcolor(white) lwidth(none) ilwidth(none) margin());
graph export ".\figures_and_tables\country_simulation_iofg.pdf", replace;	

graph twoway function y=x, range(change) color(black) || scatter change_tc change,
	mlabel(ecode) mlabposition(0) msymbol(none) mlabcolor(black)
	xlabel(-.3(.1).1) ylabel(-.3(.1).1)
	ytitle("Simulated Change") xtitle("Data") legend(off)
	plotregion(style(none)) graphregion(fcolor(white) lwidth(none) ilwidth(none) margin());
graph export ".\figures_and_tables\country_simulation_tc.pdf", replace;	

#d cr
**Statistics on fit
log using ".\figures_and_tables\country_counterfactual_fit", replace text
**Correlations
correl change_baseline change_iofg change_tc change

**Mean deviation and mean absolute deviation
gen diff_baseline=change_baseline-change
gen diff_iofg=change_iofg-change
gen diff_tc=change_tc-change
gen abs_diff_baseline=abs(change_baseline-change)
gen abs_diff_iofg=abs(change_iofg-change)
gen abs_diff_tc=abs(change_tc-change)
sum diff* abs_diff*

**MSE
gen mse_baseline=(change_baseline-change)^2
gen mse_iofg=(change_iofg-change)^2
gen mse_tc=(change_tc-change)^2
collapse (mean) mse*
gen root_mse_baseline=sqrt(mse_baseline)
gen root_mse_iofg=sqrt(mse_iofg)
gen root_mse_tc=sqrt(mse_tc)
list
log close

******************************************
**Prep data for Distance & RTA Regressions
******************************************
use ".\simulation_output\counterfactuals", clear
collapse (sum) exports* vaexports*, by(ecode icode year panel)
keep ecode icode year vaexports exports *baseline *tc *iofg *rta *split *phasein panel
gen vax=vaexports/exports
foreach sim in baseline tc iofg rta split phasein {
	gen vax_`sim'=vaexports_`sim'/exports_`sim'
	}

**Merge on EIA data
merge 1:1 ecode icode year using ".\data\EIAdata"
keep if _merge==3
drop _merge
replace eia="0" if eia=="NoCty" /*These are wierd Thailand 1970-1974 pre-revolution observations*/
destring eia, replace
gen rta=(eia>=3)

**Merge with Distance
replace ecode="ROM" if ecode=="ROU"
replace icode="ROM" if icode=="ROU"
merge m:1 ecode icode using ".\data\distance.dta", keepusing(dist)
keep if _merge==3
drop _merge
replace ecode="ROU" if ecode=="ROM"
replace icode="ROU" if icode=="ROM"
gen logdist=log(dist)

**Define sample
gen sample=0
replace sample=1 if exports>1 & vax<10
keep if panel==1 & sample==1
egen pair=group(ecode icode)
save ".\simulation_output\temp", replace
	
**************************************************************************
**Table 2 (Panels A1, B1, C1): Distance Regressions in Counterfactual Data
**************************************************************************
use ".\simulation_output\temp", clear
keep if year==1975 | year==2005 
egen yr=group(year)
tsset pair yr

gen logvaxdiff=log(vax)-log(L.vax)
gen logexpdiff=log(exports)-log(L.exports)
gen logvaexpdiff=log(vaexports)-log(L.vaexports)
foreach sim in baseline tc iofg {
	gen logvaxdiff_`sim'=log(vax_`sim')-log(L.vax_`sim')
	gen logexpdiff_`sim'=log(exports_`sim')-log(L.exports_`sim')
	gen logvaexpdiff_`sim'=log(vaexports_`sim')-log(L.vaexports_`sim')
}

keep if year==2005

foreach var in logvaxdiff logexpdiff logvaexpdiff {
	est drop _all
	eststo: qui xi: reg `var' i.ecode i.icode logdist
	est store col1
	eststo: qui xi: reg `var'_baseline i.ecode i.icode logdist
	est store col2
	eststo: qui xi: reg `var'_iofg i.ecode i.icode logdist
	est store col3
	eststo: qui xi: reg `var'_tc i.ecode i.icode logdist
	est store col4
	#d ;
	estout col1 col2 col3 col4 using ".\figures_and_tables\counterfactual_`var'_distance_regression.txt",
	keep(logdist)
	stats(r2 N,fmt(%9.2f %9.0f) labels(R-squared)) 
	cells(b(star fmt(%9.3f)) se(par fmt(%9.3f %9.3f))) 
	varlabels(_cons Constant) varwidth(16) modelwidth(12) delimiter("") collabels(, none)
	starlevels(* 0.10 ** 0.05 *** 0.01) replace;
	#d cr
}

*********************************************************************************
**Table 2 (Panels A2, B2, C2) and Table 4: RTA Regressions in Counterfactual Data
*********************************************************************************
use ".\simulation_output\temp", clear
set matsize 10000
egen yr=group(year)
tsset pair yr

**Define Phase In
gen temp=yr if rta==1 & L.rta==0
by pair, sort: egen adoptionyear=median(temp)
gen yrsafterrta=yr-adoptionyear
replace yrsafterrta=-99 if yrsafterrta==.
gen one=yrsafterrta==0
gen two=yrsafterrta==1
gen three=yrsafterrta==2
gen fourmore=yrsafterrta>=3

gen logvax=log(vax)
gen logexp=log(exports)
gen logvaexp=log(vaexports)
foreach sim in baseline tc iofg rta split phasein {
	gen logvax_`sim'=log(vax_`sim')
	gen logexp_`sim'=log(exports_`sim')
	gen logvaexp_`sim'=log(vaexports_`sim')
}

foreach var in logvax logexp logvaexp {

est drop _all

**Levels with pair fixed effects
xi i.ecode*i.year i.icode*i.year
eststo: qui areg `var' _I* rta, absorb(pair) vce(cluster pair)
eststo: qui areg `var'_baseline _I* rta, absorb(pair) vce(cluster pair)
eststo: qui areg `var'_iofg _I* rta, absorb(pair) vce(cluster pair)
eststo: qui areg `var'_tc _I* rta, absorb(pair) vce(cluster pair)
eststo: qui areg `var'_rta _I* rta, absorb(pair) vce(cluster pair)
eststo: qui areg `var'_split _I* rta, absorb(pair) vce(cluster pair)
eststo: qui areg `var'_phasein _I* rta, absorb(pair) vce(cluster pair)
drop _I*

******************
**Tabulate results
******************
#d ;
estout est* using ".\figures_and_tables\counterfactual_`var'_rta_regression.txt",	
	keep(rta)
	stats(r2 N,fmt(%9.2f %9.0f) labels(R-squared)) 
	cells(b(star fmt(%9.3f)) se(par fmt(%9.3f %9.3f))) 
	varlabels(_cons Constant) varwidth(16) modelwidth(12) collabels(, none)
	starlevels(* 0.10 ** 0.05 *** 0.01) replace;

#d cr	
}

*********************
**Figure 9: World VAX
*********************
use ".\simulation_output\counterfactuals", clear
collapse (sum) vaexports* exports*, by(year)
keep year vaexports exports *baseline *tc *manuf* *nonmanuf*
gen vax=vaexports/exports
foreach tag in baseline tc manuf_final manuf_input nonmanuf_final nonmanuf_input {
gen vax_`tag'=vaexports_`tag'/exports_`tag'
}

#d ;
line vax_nonmanuf_final vax_nonmanuf_input vax_manuf_final vax_manuf_input vax_tc year,
	lwidth(medium medium medium medium medthick) lcolor(navy navy navy navy black) lpattern(shortdash dash "_ -" longdash solid)
	legend(label(1 "Final Non-Manufacturing") label(2 "Input Non-Manufacturing") label(3 "Final Manufacturing") label(4 "Input Manufacturing") label(5 "Trade Frictions") position(8) ring(0) col(1) region(color(none)))
	ylabel(.68(.02).82) plotregion(style(none)) graphregion(fcolor(white) lwidth(none) ilwidth(none) margin());
graph export ".\figures_and_tables\world_simulation_tradefrictions.pdf", replace;

#d cr
***********************
**Figure 10: Sector VAX
***********************
use ".\simulation_output\counterfactuals", clear
collapse (sum) vaexports* exports*, by(sector year)
keep sector year vaexports exports *baseline *tc *manuf* *nonmanuf*
gen vax=vaexports/exports
foreach tag in baseline tc manuf_final manuf_input nonmanuf_final nonmanuf_input {
gen vax_`tag'=vaexports_`tag'/exports_`tag'
}

#d ;
line vax_nonmanuf_final vax_nonmanuf_input vax_manuf_final vax_manuf_input vax_tc year if sector==1, ytitle("VAX Ratio")
	lwidth(medium medium medium medium medthick) lcolor(navy navy navy navy black) lpattern(shortdash dash "_ -" longdash solid)
	legend(label(1 "Final Non-Manufacturing") label(2 "Input Non-Manufacturing") label(3 "Final Manufacturing") label(4 "Input Manufacturing") label(5 "Trade Frictions") position(11) ring(0) col(1) region(color(none)))
	ylabel(1(.1)1.6) plotregion(style(none)) graphregion(fcolor(white) lwidth(none) ilwidth(none) margin());
graph export ".\figures_and_tables\world_nonmanuf_tradefrictions.pdf", replace;	

#d ;
line vax_nonmanuf_final vax_nonmanuf_input vax_manuf_final vax_manuf_input vax_tc year if sector==2, ytitle("VAX Ratio")
	lwidth(medium medium medium medium medthick) lcolor(navy navy navy navy black) lpattern(shortdash dash "_ -" longdash solid)
	legend(label(1 "Final Non-Manufacturing") label(2 "Input Non-Manufacturing") label(3 "Final Manufacturing") label(4 "Input Manufacturing") label(5 "Trade Frictions") position(7) ring(0) col(1) region(color(none)))
	ylabel(.4(.05).55)  plotregion(style(none)) graphregion(fcolor(white) lwidth(none) ilwidth(none) margin());
	graph export ".\figures_and_tables\world_manuf_tradefrictions.pdf", replace;

#d cr
********************************************************
**Table 3: Within vs. Between Sectors at the World Level
********************************************************
use ".\simulation_output\counterfactuals", clear
collapse (sum) exports vaexports *tc *input *final, by(sector year)
ren exports exports_data
ren vaexports vaexports_data

foreach var in data tc nonmanuf_final nonmanuf_input manuf_final manuf_input {
by year, sort: egen total=total(exports_`var')
gen xsh_`var'=exports_`var'/total
gen vax=vaexports_`var'/exports_`var'
tsset sector year
gen ave_xsh_`var'=(.5*xsh_`var'+.5*L.xsh_`var')
gen withinterm_`var'=(.5*xsh_`var'+.5*L.xsh_`var')*(vax-L.vax)
gen betweenterm_`var'=(.5*vax+.5*L.vax)*(xsh_`var'-L.xsh_`var')
drop total vax
}

collapse (sum) exports* vaexports* withinterm* betweenterm*, by(year)
tsset year
foreach var in data tc nonmanuf_final nonmanuf_input manuf_final manuf_input {
	gen vaxch_`var'=vaexports_`var'/exports_`var'-L.vaexports_`var'/L.exports_`var'
	}
collapse (sum) vaxch* withinterm* betweenterm*
outsheet using ".\figures_and_tables\world_betweeen_within.csv", comma replace

**********************************************************************************************************
**Counterfactual World VAX Removing RTAs for text in discussion of "The Role of Regional Trade Agreements"
**********************************************************************************************************
use ".\simulation_output\counterfactuals", clear
collapse (sum) vaexports* exports*, by(year)
keep year vaexports exports vaexports_phasein vaexports_split vaexports_rta exports_phasein exports_split exports_rta
gen vax=vaexports/exports
foreach tag in phasein split rta {
gen vax_`tag'=vaexports_`tag'/exports_`tag'
}
keep vax* year
order year vax vax_rta vax_split vax_phasein
outsheet using ".\figures_and_tables\RTA_world_counterfactual.csv", comma 


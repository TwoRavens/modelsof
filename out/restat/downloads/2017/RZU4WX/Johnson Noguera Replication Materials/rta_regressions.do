**************
**Prepare data
**************
use "./data/VAdataset.dta", clear
drop if ecode==icode
collapse (sum) vaexports exports, by(ecode enum icode inum year)
drop if ecode=="ROW" | icode=="ROW"
sort ecode icode
merge m:1 ecode icode using "./data/distance.dta"
keep if _merge==3
drop _merge
keep ecode enum icode inum year vaexports exports dist
replace ecode="ROU" if ecode=="ROM"
replace icode="ROU" if icode=="ROM"
keep if year==1970 | year==1975 | year==1980 | year==1985 | year==1990 | year==1995 | year==2000 | year==2005

*****************************
**Merge with RTA data (September 2015 version)
*****************************
sort ecode icode year
merge 1:m ecode icode year using "./data/EIAdata.dta"
keep if _merge==3
drop _merge
replace eia="0" if eia=="NoCty"
destring eia, replace

**************
**Define Panel
**************
egen pair=group(ecode icode)
egen yr=group(year)
tsset pair yr

**********************
**Define LHS Variables
**********************
gen vax=vaexports/exports
gen logvax=ln(vax)
gen logvaexports=ln(vaexports)
gen logexports=ln(exports)

**Define sample
gen sample=0
replace sample=1 if exports>1 & vax<10
keep if sample==1

**Create differences
gen logvaxdiff=logvax-L.logvax
gen logexportsdiff=logexports-L.logexports
gen logvaexportsdiff=logvaexports-L.logvaexports

****************************
**Define RTAs and Agreements
****************************
gen rta=eia>=3
gen pta=eia==1 | eia==2
gen fta=eia==3
gen cucmeu=eia==4 | eia==5 | eia==6

**Form first differences (for 5-year intervals)
foreach var in rta pta fta cucmeu {
	gen `var'diff=`var'-L.`var'
}

**Define Phase In
gen temp=yr if rta==1 & L.rta==0
by pair, sort: egen adoptionyear=median(temp)
gen yrsafterrta=yr-adoptionyear
replace yrsafterrta=-99 if yrsafterrta==.
gen one=yrsafterrta==0
gen two=yrsafterrta==1
gen three=yrsafterrta==2
gen fourmore=yrsafterrta>=3
foreach var in one two three fourmore {
	gen `var'diff=`var'-L.`var'
}

********************
**Levels Regressions
********************
set matsize 10000
foreach var in logvax logexports logvaexports {

est drop _all

**Levels with pair fixed effects
xi i.ecode*i.year i.icode*i.year i.pair
eststo: qui reg `var' _I* rta, vce(cluster pair)
drop _I*

**Levels with pair fixed effects and linear trends
xi i.ecode*i.year i.icode*i.year i.pair*yr
eststo: qui reg `var' _I* rta, vce(cluster pair)
drop _I*

**Levels with pair fixed effects and agreement types
xi i.ecode*i.year i.icode*i.year i.pair
eststo: qui reg `var' _I* pta fta cucmeu, vce(cluster pair)
drop _I*

**Levels with pair fixed effects, agreement types, and linear trends
xi i.ecode*i.year i.icode*i.year i.pair*yr
eststo: qui reg `var' _I* pta fta cucmeu, vce(cluster pair)
drop _I*

**Levels with pair fixed effects and phase in
xi i.ecode*i.year i.icode*i.year i.pair
eststo: qui reg `var' _I* one two three fourmore, vce(cluster pair)
drop _I*
 
**Levels with pair fixed effects, phase in, and linear trends
xi i.ecode*i.year i.icode*i.year i.pair*yr
eststo: qui reg `var' _I* one two three fourmore, vce(cluster pair)
drop _I*

**************************************
**Table 1: Panel Regressions with RTAs
**************************************
#d ;
estout est* using "./figures_and_tables/table_`var'_levelreg_clustered.txt",	
	keep(rta pta fta cucmeu one two three fourmore)
	stats(r2 N,fmt(%9.2f %9.0f) labels(R-squared)) 
	cells(b(star fmt(%9.3f)) se(par fmt(%9.3f %9.3f))) 
	varlabels(_cons Constant) varwidth(16) modelwidth(12) collabels(, none)
	starlevels(* 0.10 ** 0.05 *** 0.01) replace;
#d cr	
}

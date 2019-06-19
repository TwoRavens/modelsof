
clear all
set more off
capture log close
set mat 5000

cd "C:\Users\rujia\Dropbox\coalmine\restat"

use  Coalmine.dta, clear
drop if native==.
drop if leader_id==.


label var prod0 "Output"

gen ln_output=log(prod0)
label var ln_output "ln Output"


bysort prov_id: egen pre_deathrate=mean(deathrate) if year<1998

bysort prov_id: egen m_pre_deathrate=mean(pre_deathrate) 

gen pre_year=m_pre_deathrate*year

merge 1:1 prov_id year  using TrafficPanel.dta

drop _m

merge 1:1 prov_id year using LocalCoalmine.dta


drop _m
merge 1:1 prov_id year using Population.dta

gen trafficper=mortality*10/popu

tabu year
gen decentralized=(year>=1998 & year<=2000)

gen prod0_2= prod0/1000

tabu prov_id, gen (pdummy)
forvalues i=1(1)22{
gen prov_year`i'=pdummy`i'*year
}
*
gen ln_wage=log(indwage)
gen tenure=year-startyear+1
gen ln_gdpper=log(gdpper)
gen ln_electricity=log(eleconsum)
gen ln_disbeijing=log(1+dis_beijing)


gen ln_output_sq=ln_output * ln_output

label var decentralized "Decentralization"
label var ln_output "ln Output"
label var ln_output_sq "ln Output squared"

#delimit ;
/* Clear any regression results kept in memory */
eststo clear;

/* Clear any regression results kept in memory */

eststo: regress deathrate decentralized i.prov_id;
estadd local pfe "Y";
estadd scalar nobs=e(N);
estadd scalar rsq=e(r2);



eststo: regress deathrate decentralized i.prov_id prov_year*;
estadd local pfe "Y";
estadd local ptrend "Y";

estadd scalar nobs=e(N);
estadd scalar rsq=e(r2);



eststo: regress deathrate decentralized ln_output i.prov_id prov_year* ;
estadd local pfe "Y";
estadd local ptrend "Y";

estadd scalar nobs=e(N);
estadd scalar rsq=e(r2);



eststo:  regress deathrate decentralized  i.prov_id prov_year* ln_output ln_output_sq;
estadd local pfe "Y";
estadd local ptrend "Y";

estadd scalar nobs=e(N);
estadd scalar rsq=e(r2);

esttab using draft/DecentralizedEffect.tex, replace
	width(\hsize) 
	nomtitles
	b(3)
	se(3)
	noconstant
	star(* 0.10 ** 0.05 *** 0.01)
	keep(
   decentralized
  ln_output
  ln_output_sq
		)
	label
	stats(
		pfe 
	    ptrend
		nobs
		rsq
		, 
		labels(
			"Province FE" 
		    "Provincial Trends"
			"\# observations"
			"R-Squared"
			) 
		fmt(0 0 0 2)
		layout(@)
		)
	nonotes
	addnotes(
	)
	;



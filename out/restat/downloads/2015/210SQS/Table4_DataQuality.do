

clear all
set more off
capture log close
set mat 5000

cd "C:\Users\rujia\Dropbox\coalmine\restat"

use  CoalMine.dta, clear
drop if native==.
drop if leader_id==.

gen ln_output = log(prod0)

gen prod0_normalized=prod0/10000
label var prod0_normalized "Output"


label var ln_output "ln Output"


bysort prov_id: egen pre_deathrate=mean(deathrate) if year<1998
bysort prov_id: egen m_pre_deathrate=mean(pre_deathrate) 
gen pre_year=m_pre_deathrate*year
gen decentralized=(year>=1998 & year<=2000)

tabu prov_id, gen (pdummy)
forvalues i=1(1)22{
gen prov_year`i'=pdummy`i'*year
}

gen period=1 if year<1998
replace period=2 if year>=1998 & year<=2000
replace period=3 if year>2000 & year<=2005

egen clusterg=group(prov_id period)

gen decentralized_native=decentralized*native

gen ln_wage=log(indwage)
gen tenure=year-startyear+1
gen ln_gdpper=log(gdpper)
gen ln_electricity=log(eleconsum)
gen ln_disbeijing=log(1+dis_beijing)



local controls "ln_output ln_wage tenure age ln_gdpper ln_electricity gov_native s_native ln_disbeijing"


foreach var in ln_output ln_wage tenure age ln_gdpper ln_electricity gov_native s_native ln_disbeijing{
gen decentralized_`var'=decentralized*`var'
}

merge 1:1 prov_id year  using TrafficPanel.dta

drop _m

merge 1:1 prov_id year using LocalCoalmine.dta

drop _m

merge 1:1 prov_id year using Population.dta


gen trafficper=mortality*10/popu

gen ln_traffic=log(mortality)

gen ln_death_l=log(death_l)

gen native_decentralized=native*decentralized

label var native_decentralized "Decentralization * Native"

#delimit ;

eststo clear;

eststo: xi:areg trafficper native_decentralized    deathrate  native i.prov_id i.year, absorb(leader_id) cluster (clusterg);
estadd local pfe "Y";
estadd local yfe "Y";
estadd local rfe "Y";

estadd scalar nobs=e(N);
estadd scalar rsq=e(r2);


eststo: xi:areg  trafficper native_decentralized  deathrate  `controls'  native i.prov_id i.year, absorb(leader_id) cluster (clusterg);
estadd local pfe "Y";
estadd local yfe "Y";
estadd local rfe "Y";
estadd local controls "Y";

estadd scalar nobs=e(N);
estadd scalar rsq=e(r2);

eststo: xi:areg trafficper native_decentralized deathrate  `controls'  decentralized_*  native i.prov_id i.year, absorb(leader_id) cluster (clusterg);
estadd local pfe "Y";
estadd local yfe "Y";
estadd local rfe "Y";
estadd local controls "Y";
estadd local controls_d "Y";

estadd scalar nobs=e(N);
estadd scalar rsq=e(r2);



eststo: xi:areg deathrate_l native_decentralized  deathrate native i.prov_id i.year, absorb(leader_id) cluster (clusterg);
estadd local pfe "Y";
estadd local yfe "Y";
estadd local rfe "Y";

estadd scalar nobs=e(N);
estadd scalar rsq=e(r2);

eststo: xi:areg deathrate_l native_decentralized  deathrate  `controls'  native i.prov_id i.year, absorb(leader_id) cluster (clusterg);
estadd local pfe "Y";
estadd local yfe "Y";
estadd local rfe "Y";
estadd local controls "Y";

estadd scalar nobs=e(N);
estadd scalar rsq=e(r2);

eststo: xi:areg deathrate_l native_decentralized   deathrate `controls' decentralized_* native i.prov_id i.year, absorb(leader_id) cluster (clusterg);
estadd local pfe "Y";
estadd local yfe "Y";
estadd local rfe "Y";
estadd local controls "Y";
estadd local controls_d "Y";

estadd scalar nobs=e(N);
estadd scalar rsq=e(r2);


esttab using draft/Placebos.tex, replace
	width(\hsize) 
	mlabel (, notitles)
	b(3)
	se(3)
	noconstant
	star(* 0.10 ** 0.05 *** 0.01)
	keep(
 native_decentralized

		)
	label
	stats(
		pfe 
		yfe
		rfe
		controls
		controls_d
	 
		nobs
		rsq
		, 
		labels(
			"Province FE" 
			"Year FE"
			"Regulator FE"
			"Controls"
			"Decentralization * Controls"
		   
			"\# observations"
			"R-Squared"
			) 
		fmt(0 0 0 0 0 0  2)
		layout(@)
		)
	nonotes
	addnotes(
	)
	;



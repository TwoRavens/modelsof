

	******************************************************************
	**
	**
	**		NAME:		Francisco Garfias
	**		DATE: 		November 28, 2017
	**		PROYJECT: 	Elite Competition and State Capacity 
	**					Development: Theory and Evidence from 
	**					Post-Revolutionary Mexico
	**
	**		DETAILS: 	This code prepares Table 3: Commodity Shocks
	**					and Local Bureaucrats (1940)
	**					
	**					
	** 
	**
	**				
	**		Version: 	Stata MP 12.1
	**
	******************************************************************
	
	



		

			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* Prepare data
*-------------------------------------------------------------------------------


local datadir $data
use "`datadir'DPanel_Mun1940.dta", clear
tsset cve_geoest year




		


			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* Table 3: 	Commodity Shocks and Local Bureaucrats (1940)
*-------------------------------------------------------------------------------


* Clear
eststo clear
set more off

* Estimate each column
eststo: reg aplocper1000 Llogwmean_shockma10 Dwmean_shockma10 				///
	if hac1930==1 & year==1940, r
egen aplocper1000_mean=mean(aplocper1000) if e(sample)==1
egen aplocper1000_sd=sd(aplocper1000) if e(sample)==1
qui sum aplocper1000_mean
estadd scalar mean=`r(mean)': est1
qui sum aplocper1000_sd
estadd scalar sd=`r(mean)': est1
drop aplocper1000_mean aplocper1000_sd
estadd local regfe "No": est1

eststo: reg aplocper1000 Llogwmean_shockma10 Dwmean_shockma10 apper1930 	///
	logarea loc_ha1930 logpop1930 prpop_agr1930 prpop_ciudad1930 			///
	if hac1930==1 & year==1940, r
egen aplocper1000_mean=mean(aplocper1000) if e(sample)==1
egen aplocper1000_sd=sd(aplocper1000) if e(sample)==1
qui sum aplocper1000_mean
estadd scalar mean=`r(mean)': est2
qui sum aplocper1000_sd
estadd scalar sd=`r(mean)': est2
drop aplocper1000_mean aplocper1000_sd
estadd local regfe "No": est2

eststo: reg apper1000 Llogwmean_shockma10 Dwmean_shockma10 					///
	if hac1930==1 & year==1940, r
egen apper1000_mean=mean(apper1000) if e(sample)==1
egen apper1000_sd=sd(apper1000) if e(sample)==1
qui sum apper1000_mean
estadd scalar mean=`r(mean)': est3
qui sum apper1000_sd
estadd scalar sd=`r(mean)': est3
drop apper1000_mean apper1000_sd
estadd local regfe "No": est3

eststo: reg apper1000 Llogwmean_shockma10 Dwmean_shockma10 apper1930	 	///
	logarea loc_ha1930 logpop1930 prpop_agr1930 prpop_ciudad1930 			///
	if hac1930==1 & year==1940, r
egen apper1000_mean=mean(apper1000) if e(sample)==1
egen apper1000_sd=sd(apper1000) if e(sample)==1
qui sum apper1000_mean
estadd scalar mean=`r(mean)': est4
qui sum apper1000_sd
estadd scalar sd=`r(mean)': est4
drop apper1000_mean apper1000_sd
estadd local regfe "No": est4

eststo: reg repartoriegocum Llogwmean_shockma10 Dwmean_shockma10 			///
	repartoriegocum1930 													///
	if hac1930==1 & year==1940, r
egen repartoriegocum_mean=mean(repartoriegocum) if e(sample)==1
egen repartoriegocum_sd=sd(repartoriegocum) if e(sample)==1
qui sum repartoriegocum_mean
estadd scalar mean=`r(mean)': est5
qui sum repartoriegocum_sd
estadd scalar sd=`r(mean)': est5
drop repartoriegocum_mean repartoriegocum_sd
estadd local regfe "No": est5

eststo: reg repartoriegocum Llogwmean_shockma10 Dwmean_shockma10 logarea 	///
	loc_ha1930 logpop1930 prpop_agr1930 prpop_ciudad1930 					///
	repartoriegocum1930 													///
	if hac1930==1 & year==1940, r
egen repartoriegocum_mean=mean(repartoriegocum) if e(sample)==1
egen repartoriegocum_sd=sd(repartoriegocum) if e(sample)==1
qui sum repartoriegocum_mean
estadd scalar mean=`r(mean)': est6
qui sum repartoriegocum_sd
estadd scalar sd=`r(mean)': est6
drop repartoriegocum_mean repartoriegocum_sd
estadd local regfe "No": est6


* Export fragment
local titl = "\specialcellc{Bureaucrats\\per 1000\\people}"
local titloc = "\specialcellc{Local\\bureaucrats\\per 1000\\people}"
local titland = "\specialcellc{Land\\redistribution\\(grants)}"
#delimit;
local tablesdir $tables;
esttab using "`tablesdir'7_Table3.tex",
b(a2) replace keep(Llogwmean_shockma10 Dwmean_shockma10 logpop1930 			///
	apper1930 logarea loc_ha1930 prpop_agr1930 prpop_ciudad1930 			///
	repartoriegocum1930) 
order(Llogwmean_shockma10 Dwmean_shockma10 logpop1930 apper1930 logarea 	///
	loc_ha1930 prpop_agr1930 prpop_ciudad1930 apper1930 repartoriegocum1930) 
gaps compress se bookt nodepvars star(* 0.10 ** 0.05 *** 0.01) fragment label 
mtitles("`titloc'" "`titloc'" "`titl'" "`titl'" "`titland'" "`titland'")
stats(mean sd r2 N, 
labels("Mean of DV" "SD of DV" "R sq." "Number of municipios")); 
#delimit cr
drop _est_*

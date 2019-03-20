

	******************************************************************
	**
	**
	**		NAME:		Francisco Garfias
	**		DATE: 		November 28, 2017
	**		PROYJECT: 	Elite Competition and State Capacity 
	**					Development: Theory and Evidence from 
	**					Post-Revolutionary Mexico
	**
	**		DETAILS: 	This code prepares Table C.3: Commodity 
	**					Shocks and Local Bureaucrats (1940)
	**					Alternative Measures
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
* Table C.3: Commodity Shocks and Local Bureaucrats (1940)
*			 Alternative Measures
*-------------------------------------------------------------------------------


* Clear
eststo clear
set more off

* Estimate each column
eststo: reg logaploc Llogwmean_shockma10 Dwmean_shockma10 					///
	if hac1930==1 & year==1940, r
egen logaploc_mean=mean(logaploc) if e(sample)==1
egen logaploc_sd=sd(logaploc) if e(sample)==1
qui sum logaploc_mean
estadd scalar mean=`r(mean)': est1
qui sum logaploc_sd
estadd scalar sd=`r(mean)': est1
drop logaploc_mean logaploc_sd
estadd local regfe "No": est1

eststo: reg logaploc Llogwmean_shockma10 Dwmean_shockma10 apper1930 logarea ///
	loc_ha1930 logpop1930 prpop_agr1930 prpop_ciudad1930 					///
	if hac1930==1 & year==1940, r
egen logaploc_mean=mean(logaploc) if e(sample)==1
egen logaploc_sd=sd(logaploc) if e(sample)==1
qui sum logaploc_mean
estadd scalar mean=`r(mean)': est2
qui sum logaploc_sd
estadd scalar sd=`r(mean)': est2
drop logaploc_mean logaploc_sd
estadd local regfe "No": est2

eststo: reg logap Llogwmean_shockma10 Dwmean_shockma10 						///
	if hac1930==1 & year==1940, r
egen logap_mean=mean(logap) if e(sample)==1
egen logap_sd=sd(logap) if e(sample)==1
qui sum logap_mean
estadd scalar mean=`r(mean)': est3
qui sum logap_sd
estadd scalar sd=`r(mean)': est3
drop logap_mean logap_sd
estadd local regfe "No": est3

eststo: reg logap Llogwmean_shockma10 Dwmean_shockma10 apper1930 logarea 	///
	loc_ha1930 logpop1930 prpop_agr1930 prpop_ciudad1930 					///
	if hac1930==1 & year==1940, r
egen logap_mean=mean(logap) if e(sample)==1
egen logap_sd=sd(logap) if e(sample)==1
qui sum logap_mean
estadd scalar mean=`r(mean)': est4
qui sum logap_sd
estadd scalar sd=`r(mean)': est4
drop logap_mean logap_sd
estadd local regfe "No": est4

eststo: reg prriego Llogwmean_shockma10 Dwmean_shockma10 prriegocum1930 	///
	if hac1930==1 & year==1940, r
egen prriego_mean=mean(prriego) if e(sample)==1
egen prriego_sd=sd(prriego) if e(sample)==1
qui sum prriego_mean
estadd scalar mean=`r(mean)': est5
qui sum prriego_sd
estadd scalar sd=`r(mean)': est5
drop prriego_mean prriego_sd
estadd local regfe "No": est5

eststo: reg prriego Llogwmean_shockma10 Dwmean_shockma10 logarea loc_ha1930 ///
	logpop1930 prpop_agr1930 prpop_ciudad1930 prriegocum1930 				///
	if hac1930==1 & year==1940, r
egen prriego_mean=mean(prriego) if e(sample)==1
egen prriego_sd=sd(prriego) if e(sample)==1
qui sum prriego_mean
estadd scalar mean=`r(mean)': est6
qui sum prriego_sd
estadd scalar sd=`r(mean)': est6
drop prriego_mean prriego_sd
estadd local regfe "No": est6


* Export fragment
local titl = "\specialcellc{Number of\\bureaucrats\\(log)}"
local titloc = "\specialcellc{Number of\\local bureaucrats\\(log)}"
local titland = "\specialcellc{Land\\reform\\(\% of mun.)}"

#delimit;
local tablesdir $tables;
esttab using "`tablesdir'21_TableC3.tex",
b(a2) replace keep(Llogwmean_shockma10 Dwmean_shockma10 logpop1930 			///
	apper1930 logarea loc_ha1930 prpop_agr1930 prpop_ciudad1930 prriegocum1930) 
order(Llogwmean_shockma10 Dwmean_shockma10 logpop1930 apper1930 logarea 	///
	loc_ha1930 prpop_agr1930 prpop_ciudad1930 apper1930 prriegocum1930) 
gaps compress se bookt nodepvars star(* 0.10 ** 0.05 *** 0.01) fragment label 
mtitles("`titloc'" "`titloc'" "`titl'" "`titl'" "`titland'" "`titland'")
stats(mean sd r2 N, 
labels("Mean of DV" "SD of DV" "R sq." "Number of municipios")); 
#delimit cr
drop _est_*


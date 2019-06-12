



	******************************************************************
	**
	**
	**		NAME:		Francisco Garfias
	**		DATE: 		November 28, 2017
	**		PROYJECT: 	Elite Competition and State Capacity 
	**					Development: Theory and Evidence from 
	**					Post-Revolutionary Mexico
	**
	**		DETAILS: 	This code prepares Table C.11: Commodity 
	**					Shocks and Long Term Local State Capacity
	**					Excluding Commodity Potential (1920s)
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
* Table C.11: Commodity Shocks and Long Term Local State Capacity
*			  Excluding Commodity Potential (1920s)
*-------------------------------------------------------------------------------


* Clear
eststo clear
local clear
set more off

* Estimate each column
eststo: reg ap2000per1000 Dwmean_shockma10 logpop1930 						///
	apper1930 logarea loc_ha1930 prpop_agr1930 prpop_ciudad1930 			///
	if hac1930==1 & year==1940, r
egen ap2000per1000_mean=mean(ap2000per1000) if e(sample)==1
egen ap2000per1000_sd=sd(ap2000per1000) if e(sample)==1
qui sum ap2000per1000_mean
estadd scalar mean=`r(mean)': est1
qui sum ap2000per1000_sd
estadd scalar sd=`r(mean)': est1
drop ap2000per1000_mean ap2000per1000_sd


eststo: xi: reg ap2000per1000 Dwmean_shockma10 								///
	logpop1930 apper1930 logarea loc_ha1930 prpop_agr1930 prpop_ciudad1930 	///
	logpib logtransf if hac1930==1 & year==1940, r
egen ap2000per1000_mean=mean(ap2000per1000) if e(sample)==1
egen ap2000per1000_sd=sd(ap2000per1000) if e(sample)==1
qui sum ap2000per1000_mean
estadd scalar mean=`r(mean)': est2
qui sum ap2000per1000_sd
estadd scalar sd=`r(mean)': est2
drop ap2000per1000_mean ap2000per1000_sd


eststo: reg prtax Dwmean_shockma10 logpop1930 								///
	apper1930 logarea loc_ha1930 prpop_agr1930 prpop_ciudad1930 			///
	if hac1930==1 & year==1940, r
egen prtax_mean=mean(prtax) if e(sample)==1
egen prtax_sd=sd(prtax) if e(sample)==1
qui sum prtax_mean
estadd scalar mean=`r(mean)': est3
qui sum prtax_sd
estadd scalar sd=`r(mean)': est3
drop prtax_mean prtax_sd


eststo: xi: reg prtax Dwmean_shockma10 logpop1930 							///
	apper1930 logarea loc_ha1930 prpop_agr1930 prpop_ciudad1930 logpib 		///
	logtransf if hac1930==1 & year==1940, r
egen prtax_mean=mean(prtax) if e(sample)==1
egen prtax_sd=sd(prtax) if e(sample)==1
qui sum prtax_mean
estadd scalar mean=`r(mean)': est4
qui sum prtax_sd
estadd scalar sd=`r(mean)': est4
drop prtax_mean prtax_sd


*Fragment
local titl = "\specialcellc{Bureaucrats\\per 1000 people\\(2000)}"
local titl2 = "\specialcellc{Local taxes\\(\% of mun. GDP)\\Avg. 1989-2013}"
#delimit;
local tablesdir $tables;
esttab using "`tablesdir'30_TableC11.tex",
b(a2) replace keep(Dwmean_shockma10 logpop1930 apper1930 
	logarea loc_ha1930 prpop_agr1930 prpop_ciudad1930 logpib logtransf) 
order(Dwmean_shockma10 logpop1930 apper1930 logarea 
	loc_ha1930 prpop_agr1930 prpop_ciudad1930 logpib logtransf) 
gaps compress se bookt nodepvars star(* 0.10 ** 0.05 *** 0.01) fragment label 
mtitles("`titl'" "`titl'" "`titl2'" "`titl2'")
stats(mean sd r2 N, 
labels("Mean of DV" "SD of DV" "R sq." "Number of municipios")); 
#delimit cr
drop _est_*




	******************************************************************
	**
	**
	**		NAME:		Francisco Garfias
	**		DATE: 		November 28, 2017
	**		PROYJECT: 	Elite Competition and State Capacity 
	**					Development: Theory and Evidence from 
	**					Post-Revolutionary Mexico
	**
	**		DETAILS: 	This code prepares Table C.4: Commodity 
	**					Shocks and Long Term Local State Capacity
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
* Table C.4: Commodity Shocks and Long Term Local State Capacity
*			 Alternative Measures
*-------------------------------------------------------------------------------


* Clear
eststo clear
local clear
set more off

* Estimate each column
qui reg logap2000 Llogwmean_shockma10 Dwmean_shockma10 logpop1930 			///
	apper1930 logarea loc_ha1930 prpop_agr1930 prpop_ciudad1930 logpop2000	///
	if hac1930==1 & year==1940, r
eststo: reg logap2000 Llogwmean_shockma10 Dwmean_shockma10 logpop2000		///
	if hac1930==1 & year==1940 & e(sample)==1, r
egen ap2000per1000_mean=mean(ap2000per1000) if e(sample)==1
egen ap2000per1000_sd=sd(ap2000per1000) if e(sample)==1
qui sum ap2000per1000_mean
estadd scalar mean=`r(mean)': est1
qui sum ap2000per1000_sd
estadd scalar sd=`r(mean)': est1
drop ap2000per1000_mean ap2000per1000_sd


eststo: reg logap2000 Llogwmean_shockma10 Dwmean_shockma10 logpop1930 		///
	apper1930 logarea loc_ha1930 prpop_agr1930 prpop_ciudad1930 logpop2000	///
	if hac1930==1 & year==1940, r
egen ap2000per1000_mean=mean(ap2000per1000) if e(sample)==1
egen ap2000per1000_sd=sd(ap2000per1000) if e(sample)==1
qui sum ap2000per1000_mean
estadd scalar mean=`r(mean)': est2
qui sum ap2000per1000_sd
estadd scalar sd=`r(mean)': est2
drop ap2000per1000_mean ap2000per1000_sd


eststo: xi: reg logap2000 Llogwmean_shockma10 Dwmean_shockma10 			///
	logpop1930 apper1930 logarea loc_ha1930 prpop_agr1930 prpop_ciudad1930 	///
	logpib logtransf logpop2000 if hac1930==1 & year==1940, r
egen ap2000per1000_mean=mean(ap2000per1000) if e(sample)==1
egen ap2000per1000_sd=sd(ap2000per1000) if e(sample)==1
qui sum ap2000per1000_mean
estadd scalar mean=`r(mean)': est3
qui sum ap2000per1000_sd
estadd scalar sd=`r(mean)': est3
drop ap2000per1000_mean ap2000per1000_sd


qui reg logtax Llogwmean_shockma10 Dwmean_shockma10 logpop1930 				///
	apper1930 logarea loc_ha1930 prpop_agr1930 prpop_ciudad1930 logpib		///
	if hac1930==1 & year==1940, r
eststo: reg logtax Llogwmean_shockma10 Dwmean_shockma10 logpib				///
	if hac1930==1 & year==1940 & e(sample)==1, r
egen prtax_mean=mean(prtax) if e(sample)==1
egen prtax_sd=sd(prtax) if e(sample)==1
qui sum prtax_mean
estadd scalar mean=`r(mean)': est4
qui sum prtax_sd
estadd scalar sd=`r(mean)': est4
drop prtax_mean prtax_sd


eststo: reg logtax Llogwmean_shockma10 Dwmean_shockma10 logpop1930 			///
	apper1930 logarea loc_ha1930 prpop_agr1930 prpop_ciudad1930 logpib		///
	if hac1930==1 & year==1940, r
egen prtax_mean=mean(prtax) if e(sample)==1
egen prtax_sd=sd(prtax) if e(sample)==1
qui sum prtax_mean
estadd scalar mean=`r(mean)': est5
qui sum prtax_sd
estadd scalar sd=`r(mean)': est5
drop prtax_mean prtax_sd


eststo: xi: reg logtax Llogwmean_shockma10 Dwmean_shockma10 logpop1930 		///
	apper1930 logarea loc_ha1930 prpop_agr1930 prpop_ciudad1930 logpib 		///
	logtransf if hac1930==1 & year==1940, r
egen prtax_mean=mean(prtax) if e(sample)==1
egen prtax_sd=sd(prtax) if e(sample)==1
qui sum prtax_mean
estadd scalar mean=`r(mean)': est6
qui sum prtax_sd
estadd scalar sd=`r(mean)': est6
drop prtax_mean prtax_sd


*Fragment
local titl = "\specialcellc{Bureaucrats\\(log)\\(2000)}"
local titl2 = "\specialcellc{Local taxes\\(log)\\Avg.\\1989-2013}"

#delimit;
local tablesdir $tables;
esttab using "`tablesdir'22_TableC4.tex",
b(a2) replace 
keep(Llogwmean_shockma10 Dwmean_shockma10 logpop1930 apper1930 logarea
	loc_ha1930 prpop_agr1930 prpop_ciudad1930 logpib logtransf logpop2000) 
order(Llogwmean_shockma10 Dwmean_shockma10 logpop1930 apper1930 logarea 
	loc_ha1930 prpop_agr1930 prpop_ciudad1930 logpib logtransf logpop2000) 
gaps compress se bookt nodepvars star(* 0.10 ** 0.05 *** 0.01) fragment label 
mtitles("`titl'" "`titl'" "`titl'" "`titl2'" "`titl2'" "`titl2'")
stats(mean sd r2 N, 
labels("Mean of DV" "SD of DV" "R sq." "Number of municipios")); 
#delimit cr
drop _est_*


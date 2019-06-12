

	******************************************************************
	**
	**
	**		NAME:		Francisco Garfias
	**		DATE: 		November 28, 2017
	**		PROYJECT: 	Elite Competition and State Capacity 
	**					Development: Theory and Evidence from 
	**					Post-Revolutionary Mexico
	**
	**		DETAILS: 	This code prepares Table A.1: Commodity Shocks 
	**					and Future National-Level Politicians
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
* Table A.1: Commodity Shocks and Future National-Level Politicians
*-------------------------------------------------------------------------------


* Clear
eststo clear
local clear
set more off

* Estimate each column
eststo: reg nalgov_long Llogwmean_shockma10 Dwmean_shockma10 logpop1930 	///
	if hac1930==1 & year==1940, r
egen nalgov_long_mean=mean(nalgov_long) if e(sample)==1
egen nalgov_long_sd=sd(nalgov_long) if e(sample)==1
qui sum nalgov_long_mean
estadd scalar mean=`r(mean)': est1
qui sum nalgov_long_sd
estadd scalar sd=`r(mean)': est1
drop nalgov_long_mean nalgov_long_sd

eststo: reg nalgov_long Llogwmean_shockma10 Dwmean_shockma10 apper1930 		///
	logarea loc_ha1930 logpop1930 prpop_agr1930 prpop_ciudad1930 			///
	if hac1930==1 & year==1940, r
egen nalgov_long_mean=mean(nalgov_long) if e(sample)==1
egen nalgov_long_sd=sd(nalgov_long) if e(sample)==1
qui sum nalgov_long_mean
estadd scalar mean=`r(mean)': est2
qui sum nalgov_long_sd
estadd scalar sd=`r(mean)': est2
drop nalgov_long_mean nalgov_long_sd

eststo: reg nalelected_long Llogwmean_shockma10 Dwmean_shockma10 			///
	logpop1930 if hac1930==1 & year==1940, r
egen nalelected_long_mean=mean(nalelected_long) if e(sample)==1
egen nalelected_long_sd=sd(nalelected_long) if e(sample)==1
qui sum nalelected_long_mean
estadd scalar mean=`r(mean)': est3
qui sum nalelected_long_sd
estadd scalar sd=`r(mean)': est3
drop nalelected_long_mean nalelected_long_sd

eststo: reg nalelected_long Llogwmean_shockma10 Dwmean_shockma10 apper1930 	///
	logarea loc_ha1930 logpop1930 prpop_agr1930 prpop_ciudad1930 			///
	if hac1930==1 & year==1940, r
egen nalelected_long_mean=mean(nalelected_long) if e(sample)==1
egen nalelected_long_sd=sd(nalelected_long) if e(sample)==1
qui sum nalelected_long_mean
estadd scalar mean=`r(mean)': est4
qui sum nalelected_long_sd
estadd scalar sd=`r(mean)': est4
drop nalelected_long_mean nalelected_long_sd


*Fragment
local titlgov="\specialcellc{Federal government\\cabinet members\\(1940-1970)}"
local titlelected="\specialcellc{National-level\\legislators\\(1940-1970)}"

#delimit;
local tablesdir $tables;
esttab using "`tablesdir'9_TableA1.tex",
b(a2) replace keep(Llogwmean_shockma10 Dwmean_shockma10 logpop1930 apper1930 
	logarea loc_ha1930 prpop_agr1930 prpop_ciudad1930) 
order(Llogwmean_shockma10 Dwmean_shockma10 logpop1930 apper1930 logarea 
	loc_ha1930 prpop_agr1930 prpop_ciudad1930 apper1930) 
gaps compress se bookt nodepvars star(* 0.10 ** 0.05 *** 0.01) fragment label 
mtitles("`titlgov'" "`titlgov'" "`titlelected'" "`titlelected'")
stats(mean sd r2 N, 
labels("Mean of DV" "SD of DV" "R sq." "Number of municipios")); 
#delimit cr
drop _est_*

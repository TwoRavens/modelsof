

	******************************************************************
	**
	**
	**		NAME:		Francisco Garfias
	**		DATE: 		November 28, 2017
	**		PROYJECT: 	Elite Competition and State Capacity 
	**					Development: Theory and Evidence from 
	**					Post-Revolutionary Mexico
	**
	**		DETAILS: 	This code prepares Table C.8: Commodity 
	**					Shocks and Bureaucrats
	**					Alternative Estimation Strategies
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


* Generate entropy balance weights
*---------------------------------
set more off
areg apper1000 logwmean_shockma10 y1940 y1940logarea y1940logpop1930 		///
	y1940loc_ha1930 y1940prpop_agr1930 y1940prpop_ciudad1930 				///
	y1940logwmean_shockma10_1930 if hac1930==1, cl(cve_geoest) a(cve_geoest)
	
gen treat_pre=0 if e(sample)==1 & year==1930 
su Dwmean_shockma10 if year==1940 & e(sample)==1, d
replace treat_pre=1 														///
	if e(sample)==1 & year==1930 & F10.Dwmean_shockma10>`r(mean)'
gen treat=0 if e(sample)==1
by cve_geoest: replace treat=treat_pre[_n-1] 								///
	if treat_pre[_n-1]==1 & year==1940

set more off
ebalance treat_pre logwmean_shockma10 logarea logpop1930 loc_ha1930 		///
	prpop_agr1930 prpop_ciudad1930 apper1930 repartoriegocum1930 			///
	if year==1930 & e(sample)==1, gen(w)
by cve_geoest: egen we=max(w)
drop w


* Label dichotomous shock variable and lagged DVs
*------------------------------------------------
label var treat																///
	"\% Shock to \\Commodity Potential\\(Dichotomous: Above Avg.)"
gen Lapper1000=L10.apper1000
label var Lapper1000														///
	"Bureaucrats\\per 1000 people\\(Lagged)"





	

			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* Table C.8: Commodity Shocks and Bureaucrats
*			 Alternative Estimation Strategies
*-------------------------------------------------------------------------------


* Clear
eststo clear
set more off

* Estimate each column
areg apper1000 logwmean_shockma10 y1940 y1940logarea y1940logpop1930 		///
	y1940loc_ha1930 y1940prpop_agr1930 y1940prpop_ciudad1930 				///
	y1940logwmean_shockma10_1930  											///
	if hac1930==1, cl(cve_geoest) a(cve_geoest)
eststo: areg apper1000 logwmean_shockma10 y1940 							///
	if hac1930==1 & e(sample)==1 [aw=we], cl(cve_geoest) a(cve_geoest)
estadd scalar nloc=`e(N_clust)': est1
egen apper1000_mean=mean(apper1000) if e(sample)==1, by(cve_geoest)
egen apper1000_sd=sd(apper1000) if e(sample)==1, by(cve_geoest)
qui sum apper1000_mean
estadd scalar mean=`r(mean)': est1
qui sum apper1000_sd
estadd scalar sd=`r(mean)': est1
drop apper1000_mean apper1000_sd
estadd local munfe "Yes": est1
estadd local yfe "Yes": est1
estadd local ebal "Yes": est1

eststo: areg apper1000 logwmean_shockma10 y1940 y1940logarea				/// 
	y1940logpop1930 y1940loc_ha1930 y1940prpop_agr1930 						///
	y1940prpop_ciudad1930 y1940logwmean_shockma10_1930  					///
	if hac1930==1 [aw=we], cl(cve_geoest) a(cve_geoest)
estadd scalar nloc=`e(N_clust)': est2
egen apper1000_mean=mean(apper1000) if e(sample)==1, by(cve_geoest)
egen apper1000_sd=sd(apper1000) if e(sample)==1, by(cve_geoest)
qui sum apper1000_mean
estadd scalar mean=`r(mean)': est2
qui sum apper1000_sd
estadd scalar sd=`r(mean)': est2
drop apper1000_mean apper1000_sd
estadd local munfe "Yes": est2
estadd local yfe "Yes": est2
estadd local ebal "Yes": est2

eststo: areg apper1000 treat y1940				 							///
	if hac1930==1 & e(sample)==1 [aw=we], cl(cve_geoest) a(cve_geoest)
estadd scalar nloc=`e(N_clust)': est3
egen apper1000_mean=mean(apper1000) if e(sample)==1, by(cve_geoest)
egen apper1000_sd=sd(apper1000) if e(sample)==1, by(cve_geoest)
qui sum apper1000_mean
estadd scalar mean=`r(mean)': est3
qui sum apper1000_sd
estadd scalar sd=`r(mean)': est3
drop apper1000_mean apper1000_sd
estadd local munfe "Yes": est3
estadd local yfe "Yes": est3
estadd local ebal "Yes": est3

eststo: areg apper1000 treat y1940 y1940logarea y1940logpop1930				/// 
	y1940loc_ha1930 y1940prpop_agr1930 y1940prpop_ciudad1930 				///
	y1940logwmean_shockma10_1930  											///
	if hac1930==1 [aw=we], cl(cve_geoest) a(cve_geoest)
estadd scalar nloc=`e(N_clust)': est4
egen apper1000_mean=mean(apper1000) if e(sample)==1, by(cve_geoest)
egen apper1000_sd=sd(apper1000) if e(sample)==1, by(cve_geoest)
qui sum apper1000_mean
estadd scalar mean=`r(mean)': est4
qui sum apper1000_sd
estadd scalar sd=`r(mean)': est4
drop apper1000_mean apper1000_sd
estadd local munfe "Yes": est4
estadd local yfe "Yes": est4
estadd local ebal "Yes": est4

qui reg apper1000 Lapper1000 logwmean_shockma10 y1940logarea				/// 
	y1940logpop1930 y1940loc_ha1930 y1940prpop_agr1930 						///
	y1940prpop_ciudad1930 y1940logwmean_shockma10_1930  					///
	if hac1930==1 & year==1940, cl(cve_geoest) 
eststo: reg apper1000 Lapper1000 logwmean_shockma10						 	///
	if hac1930==1 & year==1940 & e(sample)==1, cl(cve_geoest) 
estadd scalar nloc=`e(N_clust)': est5
egen apper1000_mean=mean(apper1000) if e(sample)==1
egen apper1000_sd=sd(apper1000) if e(sample)==1
qui sum apper1000_mean
estadd scalar cs_mean=`r(mean)': est5
qui sum apper1000_sd
estadd scalar cs_sd=`r(mean)': est5
drop apper1000_mean apper1000_sd
estadd local munfe "No": est5
estadd local yfe "No": est5
estadd local ebal "No": est5

eststo: reg apper1000 Lapper1000 logwmean_shockma10 y1940logarea			/// 
	y1940logpop1930 y1940loc_ha1930 y1940prpop_agr1930 						///
	y1940prpop_ciudad1930 y1940logwmean_shockma10_1930  					///
	if hac1930==1 & year==1940, cl(cve_geoest) 
estadd scalar nloc=`e(N_clust)': est6
egen apper1000_mean=mean(apper1000) if e(sample)==1
egen apper1000_sd=sd(apper1000) if e(sample)==1
qui sum apper1000_mean
estadd scalar cs_mean=`r(mean)': est6
qui sum apper1000_sd
estadd scalar cs_sd=`r(mean)': est6
drop apper1000_mean apper1000_sd
estadd local munfe "No": est6
estadd local yfe "No": est6
estadd local ebal "No": est6


* Export Tex Fragment
local titl = "\specialcellc{Bureaucrats\\per 1K p.}"
#delimit;
local tablesdir $tables;
esttab using "`tablesdir'27_TableC8.tex",
b(a2) replace keep(logwmean_shockma10 treat Lapper1000 y1940logpop1930 
	y1940logarea y1940loc_ha1930 y1940prpop_agr1930 y1940prpop_ciudad1930 
	y1940logwmean_shockma10_1930) 
order(logwmean_shockma10 treat Lapper1000 y1940logpop1930 y1940logarea 
	y1940loc_ha1930 y1940prpop_agr1930 y1940prpop_ciudad1930 
	y1940logwmean_shockma10_1930) 
gaps compress se bookt nodepvars star(* 0.10 ** 0.05 *** 0.01) fragment label 
mtitles("`titl'" "`titl'" "`titl'" "`titl'" "`titl'" "`titl'")
stats(ebal yfe munfe mean sd cs_mean cs_sd r2 N nloc, 
labels("Entropy Balance Weights" "Year FE" "Municipality FE" 
	"Within-\textit{Municipio} Mean of DV" "Within-\textit{Municipio} SD of DV" 
	"Mean of DV" "SD of DV" "R sq." "Observations" "Number of municipios")); 
#delimit cr
drop _est_*

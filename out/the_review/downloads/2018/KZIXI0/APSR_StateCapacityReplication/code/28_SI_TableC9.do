

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
gen Lrepartoriego=L10.repartoriego
label var Lrepartoriego														///
	"Land reform, grants\\(Lagged)"




	


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
areg repartoriego logwmean_shockma10 y1940 y1940logarea y1940logpop1930 	///
	y1940loc_ha1930 y1940prpop_agr1930 y1940prpop_ciudad1930 				///
	y1940logwmean_shockma10_1930 y1940repartoriegocum1930 					///
	if hac1930==1, cl(cve_geoest) a(cve_geoest)
eststo: areg repartoriego logwmean_shockma10 y1940 							///
	if hac1930==1 & e(sample)==1 [aw=we], cl(cve_geoest) a(cve_geoest)
estadd scalar nloc=`e(N_clust)': est1
egen repartoriego_mean=mean(repartoriego) if e(sample)==1, by(cve_geoest)
egen repartoriego_sd=sd(repartoriego) if e(sample)==1, by(cve_geoest)
qui sum repartoriego_mean
estadd scalar mean=`r(mean)': est1
qui sum repartoriego_sd
estadd scalar sd=`r(mean)': est1
drop repartoriego_mean repartoriego_sd
estadd local munfe "Yes": est1
estadd local yfe "Yes": est1
estadd local ebal "Yes": est1

eststo: areg repartoriego logwmean_shockma10 y1940 y1940logarea				/// 
	y1940logpop1930 y1940loc_ha1930 y1940prpop_agr1930		 				///
	y1940prpop_ciudad1930 y1940logwmean_shockma10_1930 						///
	y1940repartoriegocum1930												///
	if hac1930==1 [aw=we], cl(cve_geoest) a(cve_geoest)
estadd scalar nloc=`e(N_clust)': est2
egen repartoriego_mean=mean(repartoriego) if e(sample)==1, by(cve_geoest)
egen repartoriego_sd=sd(repartoriego) if e(sample)==1, by(cve_geoest)
qui sum repartoriego_mean
estadd scalar mean=`r(mean)': est2
qui sum repartoriego_sd
estadd scalar sd=`r(mean)': est2
drop repartoriego_mean repartoriego_sd
estadd local munfe "Yes": est2
estadd local yfe "Yes": est2
estadd local ebal "Yes": est2

eststo: areg repartoriego treat y1940				 						///
	if hac1930==1 & e(sample)==1 [aw=we], cl(cve_geoest) a(cve_geoest)
estadd scalar nloc=`e(N_clust)': est3
egen repartoriego_mean=mean(repartoriego) if e(sample)==1, by(cve_geoest)
egen repartoriego_sd=sd(repartoriego) if e(sample)==1, by(cve_geoest)
qui sum repartoriego_mean
estadd scalar mean=`r(mean)': est3
qui sum repartoriego_sd
estadd scalar sd=`r(mean)': est3
drop repartoriego_mean repartoriego_sd
estadd local munfe "Yes": est3
estadd local yfe "Yes": est3
estadd local ebal "Yes": est3

eststo: areg repartoriego treat y1940 y1940logarea y1940logpop1930			/// 
	y1940loc_ha1930 y1940prpop_agr1930 y1940prpop_ciudad1930 				///
	y1940logwmean_shockma10_1930 y1940repartoriegocum1930 					///
	if hac1930==1 [aw=we], cl(cve_geoest) a(cve_geoest)
estadd scalar nloc=`e(N_clust)': est4
egen repartoriego_mean=mean(repartoriego) if e(sample)==1, by(cve_geoest)
egen repartoriego_sd=sd(repartoriego) if e(sample)==1, by(cve_geoest)
qui sum repartoriego_mean
estadd scalar mean=`r(mean)': est4
qui sum repartoriego_sd
estadd scalar sd=`r(mean)': est4
drop repartoriego_mean repartoriego_sd
estadd local munfe "Yes": est4
estadd local yfe "Yes": est4
estadd local ebal "Yes": est4

qui reg repartoriego Lrepartoriego logwmean_shockma10 y1940logarea			/// 
	y1940logpop1930 y1940loc_ha1930 y1940prpop_agr1930 						///
	y1940prpop_ciudad1930 y1940logwmean_shockma10_1930			 			///
	y1940repartoriegocum1930												///
	if hac1930==1 & year==1940, cl(cve_geoest) 
eststo: reg repartoriego Lrepartoriego logwmean_shockma10					///
	if hac1930==1 & year==1940 & e(sample)==1, cl(cve_geoest) 
estadd scalar nloc=`e(N_clust)': est5
egen repartoriego_mean=mean(repartoriego) if e(sample)==1
egen repartoriego_sd=sd(repartoriego) if e(sample)==1
qui sum repartoriego_mean
estadd scalar cs_mean=`r(mean)': est5
qui sum repartoriego_sd
estadd scalar cs_sd=`r(mean)': est5
drop repartoriego_mean repartoriego_sd
estadd local munfe "No": est5
estadd local yfe "No": est5
estadd local ebal "No": est5

eststo: reg repartoriego Lrepartoriego logwmean_shockma10 y1940logarea		/// 
	y1940logpop1930 y1940loc_ha1930 y1940prpop_agr1930 						///
	y1940prpop_ciudad1930 y1940logwmean_shockma10_1930			 			///
	y1940repartoriegocum1930												///
	if hac1930==1 & year==1940, cl(cve_geoest) 
estadd scalar nloc=`e(N_clust)': est6
egen repartoriego_mean=mean(repartoriego) if e(sample)==1
egen repartoriego_sd=sd(repartoriego) if e(sample)==1
qui sum repartoriego_mean
estadd scalar cs_mean=`r(mean)': est6
qui sum repartoriego_sd
estadd scalar cs_sd=`r(mean)': est6
drop repartoriego_mean repartoriego_sd
estadd local munfe "No": est6
estadd local yfe "No": est6
estadd local ebal "No": est6


* Export Tex Fragment
local titl = "\specialcellc{Land\\reform,\\grants}"
#delimit;
local tablesdir $tables;
esttab using "`tablesdir'28_TableC9.tex",
b(a2) replace keep(logwmean_shockma10 treat Lrepartoriego y1940logpop1930 
	y1940logarea y1940loc_ha1930 y1940prpop_agr1930 y1940prpop_ciudad1930 
	y1940logwmean_shockma10_1930 y1940repartoriegocum1930) 
order(logwmean_shockma10 treat Lrepartoriego y1940logpop1930 y1940logarea 
	y1940loc_ha1930 y1940prpop_agr1930 y1940prpop_ciudad1930 
	y1940logwmean_shockma10_1930 y1940repartoriegocum1930) 
gaps compress se bookt nodepvars star(* 0.10 ** 0.05 *** 0.01) fragment label 
mtitles("`titl'" "`titl'" "`titl'" "`titl'" "`titl'" "`titl'")
stats(ebal yfe munfe mean sd cs_mean cs_sd r2 N nloc, 
labels("Entropy Balance Weights" "Year FE" "Municipality FE" 
	"Within-\textit{Municipio} Mean of DV" "Within-\textit{Municipio} SD of DV" 
	"Mean of DV" "SD of DV" "R sq." "Observations" "Number of municipios")); 
#delimit cr
drop _est_*

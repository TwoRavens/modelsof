

	******************************************************************
	**
	**
	**		NAME:		Francisco Garfias
	**		DATE: 		November 28, 2017
	**		PROYJECT: 	Elite Competition and State Capacity 
	**					Development: Theory and Evidence from 
	**					Post-Revolutionary Mexico
	**
	**		DETAILS: 	This code prepares Table 2: Commodity Shocks
	**					and Land Redistribution
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
* Table 2: 	Commodity Shocks and Bureaucrats/Land Redistribution
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
	if hac1930==1 & e(sample)==1, cl(cve_geoest) a(cve_geoest)
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

eststo: areg repartoriego logwmean_shockma10 y1940 y1940logarea				/// 
	y1940logpop1930 y1940loc_ha1930 y1940prpop_agr1930 						///
	y1940prpop_ciudad1930 y1940logwmean_shockma10_1930 						///
	y1940repartoriegocum1930 												///
	if hac1930==1, cl(cve_geoest) a(cve_geoest)
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

eststo: areg repartoriego logwmean_shockma10 y1940 y1940logarea			 	///
	y1940logpop1930 y1940loc_ha1930 y1940prpop_agr1930 						///
	y1940prpop_ciudad1930 y1940logwmean_shockma10_1930 						///
	y1940repartoriegocum1930 												///
	if hac1930==0, cl(cve_geoest) a(cve_geoest)
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

eststo: areg repartoriego logwmean_shockforma10 y1940 y1940logarea 			///
	y1940logpop1930 y1940loc_ha1930 y1940prpop_agr1930 						///
	y1940prpop_ciudad1930 y1940logwmean_shockma10_1930			 			///
	y1940repartoriegocum1930 												///
	if hac1930==1, cl(cve_geoest) a(cve_geoest)
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


* Export Tex Fragment
local titl = "\specialcellc{Land reform,\\grants\\(Haciendas)}"
local titl2 = "\specialcellc{Land reform,\\grants\\(No haciendas)}"
#delimit;
local tablesdir $tables;
esttab using "`tablesdir'5_Table2.tex",
b(a2) replace keep(logwmean_shockma10 logwmean_shockforma10 y1940logpop1930 
	y1940logarea y1940loc_ha1930 y1940prpop_agr1930 y1940prpop_ciudad1930 
	y1940logwmean_shockma10_1930 "y1940repartoriegocum1930") 
order(logwmean_shockma10 logwmean_shockforma10 y1940logpop1930 y1940logarea 
	y1940loc_ha1930 y1940prpop_agr1930 y1940prpop_ciudad1930 
	y1940logwmean_shockma10_1930 "y1940repartoriegocum1930") 
gaps compress se bookt nodepvars star(* 0.10 ** 0.05 *** 0.01) fragment label 
mtitles("`titl'" "`titl'" "`titl2'" "`titl'")
stats(yfe munfe mean sd r2 N nloc, 
labels("Year FE" "Municipality FE" "Within-\textit{Municipio} Mean of DV" 
	"Within-\textit{Municipio} SD of DV" "R sq." "Observations" 
	"Number of municipios")); 
#delimit cr
drop _est_*

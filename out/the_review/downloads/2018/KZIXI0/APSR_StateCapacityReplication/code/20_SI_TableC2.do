

	******************************************************************
	**
	**
	**		NAME:		Francisco Garfias
	**		DATE: 		November 28, 2017
	**		PROYJECT: 	Elite Competition and State Capacity 
	**					Development: Theory and Evidence from 
	**					Post-Revolutionary Mexico
	**
	**		DETAILS: 	This code prepares Table C.2: Commodity 
	**					Shocks and Land Redistribution
	**					Alternative Land Redistribution Per 
	**					Capita Measure
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

* Generate grants per 1000 people
gen repartoriegopc=(repartoriego/tot_hab)*1000
label var repartoriegopc 													///
	"\specialcellc{Land reform, \\grants \\per 1000 people}"




		


			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* Table C.2: Commodity Shocks and Land Redistribution
*			 Alternative Land Redistribution Per Capita Measure
*-------------------------------------------------------------------------------

* Clear
eststo clear
set more off

* Estimate each column
local contrlr = "y1940repartoriegocum1930"
areg repartoriegopc logwmean_shockma10 y1940 y1940logarea y1940logpop1930 	///
	y1940loc_ha1930 y1940prpop_agr1930 y1940prpop_ciudad1930 				///
	y1940logwmean_shockma10_1930 `contrlr' 									///
	if hac1930==1, cl(cve_geoest) a(cve_geoest)
eststo: areg repartoriegopc logwmean_shockma10 y1940 						///
	if hac1930==1 & e(sample)==1, cl(cve_geoest) a(cve_geoest)
estadd scalar nloc=`e(N_clust)': est1
egen repartoriegopc_mean=mean(repartoriegopc) if e(sample)==1, by(cve_geoest)
egen repartoriegopc_sd=sd(repartoriegopc) if e(sample)==1, by(cve_geoest)
qui sum repartoriegopc_mean
estadd scalar mean=`r(mean)': est1
qui sum repartoriegopc_sd
estadd scalar sd=`r(mean)': est1
drop repartoriegopc_mean repartoriegopc_sd
estadd local munfe "Yes": est1
estadd local yfe "Yes": est1

eststo: areg repartoriegopc logwmean_shockma10 y1940 y1940logarea			/// 
	y1940logpop1930 y1940loc_ha1930 y1940prpop_agr1930 						///
	y1940prpop_ciudad1930 y1940logwmean_shockma10_1930 `contrlr' 			///
			if hac1930==1, cl(cve_geoest) a(cve_geoest)
estadd scalar nloc=`e(N_clust)': est2
egen repartoriegopc_mean=mean(repartoriegopc) if e(sample)==1, by(cve_geoest)
egen repartoriegopc_sd=sd(repartoriegopc) if e(sample)==1, by(cve_geoest)
qui sum repartoriegopc_mean
estadd scalar mean=`r(mean)': est2
qui sum repartoriegopc_sd
estadd scalar sd=`r(mean)': est2
drop repartoriegopc_mean repartoriegopc_sd
estadd local munfe "Yes": est2
estadd local yfe "Yes": est2

eststo: areg repartoriegopc logwmean_shockma10 y1940 y1940logarea		 	///
	y1940logpop1930 y1940loc_ha1930 y1940prpop_agr1930 						///
	y1940prpop_ciudad1930 y1940logwmean_shockma10_1930 `contrlr' 			///
	if hac1930==0, cl(cve_geoest) a(cve_geoest)
estadd scalar nloc=`e(N_clust)': est3
egen repartoriegopc_mean=mean(repartoriegopc) if e(sample)==1, by(cve_geoest)
egen repartoriegopc_sd=sd(repartoriegopc) if e(sample)==1, by(cve_geoest)
qui sum repartoriegopc_mean
estadd scalar mean=`r(mean)': est3
qui sum repartoriegopc_sd
estadd scalar sd=`r(mean)': est3
drop repartoriegopc_mean repartoriegopc_sd
estadd local munfe "Yes": est3
estadd local yfe "Yes": est3

eststo: areg repartoriegopc logwmean_shockforma10 y1940 y1940logarea 		///
	y1940logpop1930 y1940loc_ha1930 y1940prpop_agr1930 						///
	y1940prpop_ciudad1930 y1940logwmean_shockma10_1930 `contrlr' 			///
	if hac1930==1, cl(cve_geoest) a(cve_geoest)
estadd scalar nloc=`e(N_clust)': est4
egen repartoriegopc_mean=mean(repartoriegopc) if e(sample)==1, by(cve_geoest)
egen repartoriegopc_sd=sd(repartoriegopc) if e(sample)==1, by(cve_geoest)
qui sum repartoriegopc_mean
estadd scalar mean=`r(mean)': est4
qui sum repartoriegopc_sd
estadd scalar sd=`r(mean)': est4
drop repartoriegopc_mean repartoriegopc_sd
estadd local munfe "Yes": est4
estadd local yfe "Yes": est4


* Export Tex Fragment
local titl "\specialcellc{Land reform,\\grants\\per 1000 people\\(Haciendas)}"
local titl2 = 																///
	"\specialcellc{Land reform,\\grants\\per 1000 people\\(No haciendas)}"
#delimit;
local tablesdir $tables;
esttab using "`tablesdir'20_TableC2.tex",
b(a2) replace keep(logwmean_shockma10 logwmean_shockforma10 y1940logpop1930 
	y1940logarea y1940loc_ha1930 y1940prpop_agr1930 y1940prpop_ciudad1930 
	y1940logwmean_shockma10_1930 "`contrlr'") 
order(logwmean_shockma10 logwmean_shockforma10 y1940logpop1930 y1940logarea 
	y1940loc_ha1930 y1940prpop_agr1930 y1940prpop_ciudad1930 
	y1940logwmean_shockma10_1930 "`contrlr'") 
gaps compress se bookt nodepvars star(* 0.10 ** 0.05 *** 0.01) fragment label 
mtitles("`titl'" "`titl'" "`titl2'" "`titl'")
stats(yfe munfe mean sd r2 N nloc, 
labels("Year FE" "Municipality FE" "Within-\textit{Municipio} Mean of DV" 
	"Within-\textit{Municipio} SD of DV" "R sq." "Observations" 
	"Number of municipios")); 
#delimit cr
drop _est_*




	******************************************************************
	**
	**
	**		NAME:		Francisco Garfias
	**		DATE: 		November 28, 2017
	**		PROYJECT: 	Elite Competition and State Capacity 
	**					Development: Theory and Evidence from 
	**					Post-Revolutionary Mexico
	**
	**		DETAILS: 	This code prepares Table C.1: Commodity 
	**					Shocks, Bureaucrats, and Land Redistribution
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
* Table C.1: Commodity Shocks, Bureaucrats, and Land Redistribution
*			 Alternative Measures
*-------------------------------------------------------------------------------


* Clear
eststo clear
set more off

* Estimate each column
areg logap logwmean_shockma10 y1940 y1940logarea y1940logpop1930 			///
	y1940loc_ha1930 y1940prpop_agr1930 y1940prpop_ciudad1930 				///
	y1940logwmean_shockma10_1930 if hac1930==1, cl(cve_geoest) a(cve_geoest)
eststo: areg logap logwmean_shockma10 y1940 								///
	if hac1930==1 & e(sample)==1, cl(cve_geoest) a(cve_geoest)
estadd scalar nloc=`e(N_clust)': est1
egen logap_mean=mean(logap) if e(sample)==1, by(cve_geoest)
egen logap_sd=sd(logap) if e(sample)==1, by(cve_geoest)
qui sum logap_mean
estadd scalar mean=`r(mean)': est1
qui sum logap_sd
estadd scalar sd=`r(mean)': est1
drop logap_mean logap_sd
estadd local munfe "Yes": est1
estadd local yfe "Yes": est1

eststo: areg logap logwmean_shockma10 y1940 y1940logarea y1940logpop1930 	///
	y1940loc_ha1930 y1940prpop_agr1930 y1940prpop_ciudad1930 				///
	y1940logwmean_shockma10_1930 if hac1930==1, cl(cve_geoest) a(cve_geoest)
estadd scalar nloc=`e(N_clust)': est2
egen logap_mean=mean(logap) if e(sample)==1, by(cve_geoest)
egen logap_sd=sd(logap) if e(sample)==1, by(cve_geoest)
qui sum logap_mean
estadd scalar mean=`r(mean)': est2
qui sum logap_sd
estadd scalar sd=`r(mean)': est2
drop logap_mean logap_sd
estadd local munfe "Yes": est2
estadd local yfe "Yes": est2

eststo: areg logap logwmean_shockma10 y1940 y1940logarea y1940logpop1930 	///
	y1940loc_ha1930 y1940prpop_agr1930 y1940prpop_ciudad1930 				///
	y1940logwmean_shockma10_1930 if hac1930==0, cl(cve_geoest) a(cve_geoest)
estadd scalar nloc=`e(N_clust)': est3
egen logap_mean=mean(logap) if e(sample)==1, by(cve_geoest)
egen logap_sd=sd(logap) if e(sample)==1, by(cve_geoest)
qui sum logap_mean
estadd scalar mean=`r(mean)': est3
qui sum logap_sd
estadd scalar sd=`r(mean)': est3
drop logap_mean logap_sd
estadd local munfe "Yes": est3
estadd local yfe "Yes": est3

areg prriego logwmean_shockma10 y1940 y1940logarea y1940logpop1930 			///
	y1940loc_ha1930 y1940prpop_agr1930 y1940prpop_ciudad1930 				///
	y1940logwmean_shockma10_1930 y1940prriegocum1930 						///
	if hac1930==1, cl(cve_geoest) a(cve_geoest)
eststo: areg prriego logwmean_shockma10 y1940 								///
	if hac1930==1 & e(sample)==1, cl(cve_geoest) a(cve_geoest)
estadd scalar nloc=`e(N_clust)': est4
egen prriego_mean=mean(prriego) if e(sample)==1, by(cve_geoest)
egen prriego_sd=sd(prriego) if e(sample)==1, by(cve_geoest)
qui sum prriego_mean
estadd scalar mean=`r(mean)': est4
qui sum prriego_sd
estadd scalar sd=`r(mean)': est4
drop prriego_mean prriego_sd
estadd local munfe "Yes": est4
estadd local yfe "Yes": est4

eststo: areg prriego logwmean_shockma10 y1940 y1940logarea y1940logpop1930 	///
	y1940loc_ha1930 y1940prpop_agr1930 y1940prpop_ciudad1930 				///
	y1940logwmean_shockma10_1930 y1940prriegocum1930 						///
	if hac1930==1, cl(cve_geoest) a(cve_geoest)
estadd scalar nloc=`e(N_clust)': est5
egen prriego_mean=mean(prriego) if e(sample)==1, by(cve_geoest)
egen prriego_sd=sd(prriego) if e(sample)==1, by(cve_geoest)
qui sum prriego_mean
estadd scalar mean=`r(mean)': est5
qui sum prriego_sd
estadd scalar sd=`r(mean)': est5
drop prriego_mean prriego_sd
estadd local munfe "Yes": est5
estadd local yfe "Yes": est5

eststo: areg prriego logwmean_shockma10 y1940 y1940logarea y1940logpop1930 	///
	y1940loc_ha1930 y1940prpop_agr1930 y1940prpop_ciudad1930 				///
	y1940logwmean_shockma10_1930 y1940prriegocum1930 						///
	if hac1930==0, cl(cve_geoest) a(cve_geoest)
estadd scalar nloc=`e(N_clust)': est6
egen prriego_mean=mean(prriego) if e(sample)==1, by(cve_geoest)
egen prriego_sd=sd(prriego) if e(sample)==1, by(cve_geoest)
qui sum prriego_mean
estadd scalar mean=`r(mean)': est6
qui sum prriego_sd
estadd scalar sd=`r(mean)': est6
drop prriego_mean prriego_sd
estadd local munfe "Yes": est6
estadd local yfe "Yes": est6


* Export fragment
local titl = "\specialcellc{Bureaucrats\\(log)\\(Haciendas)}"
local titl2 = "\specialcellc{Bureaucrats\\(log)\\(No haciendas)}"
local titl_lr = "\specialcellc{Land\\reform\\(\% of mun.)\\(Haciendas)}"
local titl_lr2 = "\specialcellc{Land\\reform\\(\% of mun.)\\(No haciendas)}"
#delimit;
local tablesdir $tables;
esttab using "`tablesdir'19_TableC1.tex",
b(a2) replace keep(logwmean_shockma10 y1940logpop1930 y1940logarea 
	y1940loc_ha1930 y1940prpop_agr1930 y1940prpop_ciudad1930 
	y1940logwmean_shockma10_1930 y1940prriegocum1930) 
order(logwmean_shockma10 y1940logpop1930 y1940logarea y1940loc_ha1930 
	y1940prpop_agr1930 y1940prpop_ciudad1930 y1940logwmean_shockma10_1930 
	y1940prriegocum1930) 
gaps compress se bookt nodepvars star(* 0.10 ** 0.05 *** 0.01) fragment label 
mtitles("`titl'" "`titl'" "`titl2'" "`titl_lr'" "`titl_lr'" "`titl_lr2'")
stats(yfe munfe mean sd r2 N nloc, 
labels("Year FE" "Municipality FE" "Within-\textit{Municipio} Mean of DV" 
	"Within-\textit{Municipio} SD of DV" "R sq." "Observations" 
	"Number of municipios")); 
#delimit cr
drop _est_*

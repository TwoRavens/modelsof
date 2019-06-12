



	******************************************************************
	**
	**
	**		NAME:		Francisco Garfias
	**		DATE: 		November 28, 2017
	**		PROYJECT: 	Elite Competition and State Capacity 
	**					Development: Theory and Evidence from 
	**					Post-Revolutionary Mexico
	**
	**		DETAILS: 	This code prepares Table C.13: Commodity 
	**					Shocks and Bureaucrats
	**					Conditioning on State-Level Access to Land
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
tostring cve_geoest, gen(cve_mun)
replace cve_mun="0"+cve_mun if length(cve_mun)==4
gen cve_ent=substr(cve_mun,1,2)

merge m:1 cve_ent using "`datadir'LandAccess_byState_1930.dta"
tsset cve_geoest year

* State-level variables
gen y1940pr_rurent=y1940*(pob_rural/pob_total)*100
label var y1940pr_rurent 													///
	"\specialcell{State rural\\population 1930\\(\%) $\times$ 1940}"
gen y1940pr_familias_prop_rural=y1940*pr_familias_prop_rural*100
label var y1940pr_familias_prop_rural 										///
"\specialcell{State-level families\\w/rural land in 1930\\(\%) $\times$ 1940}"







			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* Table C.13: Commodity Shocks and Bureaucrats
*			  Conditioning on State-Level Access to Land
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
	if hac1930==1 & e(sample)==1, cl(cve_geoest) a(cve_geoest)
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

eststo: areg apper1000 logwmean_shockma10 y1940 y1940logarea				/// 
	y1940logpop1930 y1940loc_ha1930 y1940prpop_agr1930		 				///
	y1940prpop_ciudad1930 y1940logwmean_shockma10_1930 y1940pr_rurent  		///
	y1940pr_familias_prop_rural												///
	if hac1930==1, cl(cve_geoest) a(cve_geoest)
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

eststo: areg apper1000 logwmean_shockma10 y1940 y1940logarea 				///
	y1940logpop1930 y1940loc_ha1930 y1940prpop_agr1930 						///
	y1940prpop_ciudad1930  y1940logwmean_shockma10_1930 y1940pr_rurent 		///
	y1940pr_familias_prop_rural												///	
	if hac1930==0, cl(cve_geoest) a(cve_geoest)
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

eststo: areg apper1000 logwmean_shockforma10 y1940 y1940logarea 			///
	y1940logpop1930 y1940loc_ha1930 y1940prpop_agr1930 						///
	y1940prpop_ciudad1930 y1940logwmean_shockma10_1930  					///
		y1940pr_rurent y1940pr_familias_prop_rural							///
		if hac1930==1, cl(cve_geoest) a(cve_geoest)
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


* Export Tex Fragment
local titl = "\specialcellc{Bureaucrats\\per 1000 people\\(Haciendas)}"
local titl2 = "\specialcellc{Bureaucrats\\per 1000 people\\(No haciendas)}"
#delimit;
local tablesdir $tables;
esttab using "`tablesdir'32_TableC13.tex",
b(a2) replace keep(logwmean_shockma10 logwmean_shockforma10 y1940logpop1930 
	y1940logarea y1940loc_ha1930 y1940prpop_agr1930 y1940prpop_ciudad1930 
	y1940logwmean_shockma10_1930 y1940pr_rurent y1940pr_familias_prop_rural) 
order(logwmean_shockma10 logwmean_shockforma10 y1940logpop1930 y1940logarea 
	y1940loc_ha1930 y1940prpop_agr1930 y1940prpop_ciudad1930 
	y1940logwmean_shockma10_1930 y1940pr_rurent y1940pr_familias_prop_rural) 
gaps compress se bookt nodepvars star(* 0.10 ** 0.05 *** 0.01) fragment label 
mtitles("`titl'" "`titl'" "`titl2'" "`titl'")
stats(yfe munfe mean sd r2 N nloc, 
labels("Year FE" "Municipality FE" "Within-\textit{Municipio} Mean of DV" 
	"Within-\textit{Municipio} SD of DV" "R sq." "Observations" 
	"Number of municipios")); 
#delimit cr
drop _est_*

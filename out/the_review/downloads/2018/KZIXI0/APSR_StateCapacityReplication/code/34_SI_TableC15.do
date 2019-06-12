

	******************************************************************
	**
	**
	**		NAME:		Francisco Garfias
	**		DATE: 		November 28, 2017
	**		PROYJECT: 	Elite Competition and State Capacity 
	**					Development: Theory and Evidence from 
	**					Post-Revolutionary Mexico
	**
	**		DETAILS: 	This code prepares Table C.15: Rate of 
	**					Positive Land Reform Presidential Resolutions
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
* Table C.15: Rate of Positive Land Reform Presidential Resolutions
*-------------------------------------------------------------------------------


* Clear
eststo clear
set more off

* Estimate each column
eststo: areg positive logwmean_shockma10 y1940 								///
	if hac1930==1, cl(cve_geoest) a(cve_geoest)
estadd scalar nloc=`e(N_clust)': est1
egen positive_mean=mean(positive) if e(sample)==1, by(cve_geoest)
egen positive_sd=sd(positive) if e(sample)==1, by(cve_geoest)
qui sum positive_mean
estadd scalar mean=`r(mean)': est1
sum positive_sd
estadd scalar sd=`r(mean)': est1
drop positive_mean positive_sd
estadd local munfe "Yes": est1
estadd local yfe "Yes": est1

eststo: areg positive logwmean_shockma10 y1940 y1940logarea 				///
	y1940logpop1930 y1940loc_ha1930 y1940prpop_agr1930 						///
	y1940prpop_ciudad1930 y1940logwmean_shockma10_1930 						///
	y1940repartoriegocum1930 if hac1930==1, cl(cve_geoest) a(cve_geoest)
estadd scalar nloc=`e(N_clust)': est2
egen positive_mean=mean(positive) if e(sample)==1, by(cve_geoest)
egen positive_sd=sd(positive) if e(sample)==1, by(cve_geoest)
qui sum positive_mean
estadd scalar mean=`r(mean)': est2
qui sum positive_sd
estadd scalar sd=`r(mean)': est2
drop positive_mean positive_sd
estadd local munfe "Yes": est2
estadd local yfe "Yes": est2

eststo: areg positive logwmean_shockma10 y1940 y1940logarea 				///
	y1940logpop1930 y1940loc_ha1930 y1940prpop_agr1930 						///
	y1940prpop_ciudad1930 y1940logwmean_shockma10_1930 						///
	y1940repartoriegocum1930 if hac1930==0, cl(cve_geoest) a(cve_geoest)
estadd scalar nloc=`e(N_clust)': est3
egen positive_mean=mean(positive) if e(sample)==1, by(cve_geoest)
egen positive_sd=sd(positive) if e(sample)==1, by(cve_geoest)
qui sum positive_mean
estadd scalar mean=`r(mean)': est3
qui sum positive_sd
estadd scalar sd=`r(mean)': est3
drop positive_mean positive_sd
estadd local munfe "Yes": est3
estadd local yfe "Yes": est3


*Fragment
#delimit;
local tablesdir $tables;
esttab using "`tablesdir'34_TableC15.tex",
b(a2) replace keep(logwmean_shockma10 y1940logpop1930 y1940logarea 
	y1940loc_ha1930 y1940prpop_agr1930 y1940prpop_ciudad1930 
	y1940logwmean_shockma10_1930 y1940repartoriegocum1930) 
order(logwmean_shockma10 y1940logpop1930 y1940logarea y1940loc_ha1930 
	y1940prpop_agr1930 y1940prpop_ciudad1930
		y1940logwmean_shockma10_1930 y1940repartoriegocum1930) 
gaps compress se bookt nodepvars star(* 0.10 ** 0.05 *** 0.01) fragment label 
mtitles("\specialcellc{Positive\\Land Grant\\Resolutions (\%)\\(Haciendas)}" 
	"\specialcellc{Positive\\Land Grant\\Resolutions (\%)\\(Haciendas)}" 
	"\specialcellc{Positive\\Land Grant\\Resolutions (\%)\\(No Haciendas)}")
stats(yfe munfe mean sd r2 N nloc, 
labels("Year FE" "Municipality FE" "Within-\textit{Municipio} Mean of DV" 
	"Within-\textit{Municipio} SD of DV" "R sq." "Observations" 
	"Number of municipios")); 
#delimit cr
drop _est_*

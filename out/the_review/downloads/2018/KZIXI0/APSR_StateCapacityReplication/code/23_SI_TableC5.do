

	******************************************************************
	**
	**
	**		NAME:		Francisco Garfias
	**		DATE: 		November 28, 2017
	**		PROYJECT: 	Elite Competition and State Capacity 
	**					Development: Theory and Evidence from 
	**					Post-Revolutionary Mexico
	**
	**		DETAILS: 	This code prepares Table C.5: Pre-Depression 
	**					Parallel Trends
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
use "`datadir'DPanel_Mun1900.dta", clear
tsset id_1900 year




		


			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* Table C.5: Pre-Depression Parallel Trends
*-------------------------------------------------------------------------------


* Clear
eststo clear
local clear
set more off

* Estimate each column
* Bureaucrats
areg apper1000 logwmean_shockma10 y1940 y1940logarea y1940logpop1930 		///
	y1940loc_ha1930 y1940prpop_agr1930 y1940prpop_ciudad1930 				///
	y1940logwmean_shockma10_1930 if hac1930==1, cl(id_1900) a(id_1900)
eststo: areg apper1000 logwmean_shockma10 y1940 							///
	if hac1930==1 & e(sample)==1, cl(id_1900) a(id_1900)
estadd scalar nloc=`e(N_clust)': est1
egen apper1000_mean=mean(apper1000) if e(sample)==1, by(id_1900)
egen apper1000_sd=sd(apper1000) if e(sample)==1, by(id_1900)
qui sum apper1000_mean
estadd scalar mean=`r(mean)': est1
qui sum apper1000_sd
estadd scalar sd=`r(mean)': est1
drop apper1000_mean apper1000_sd
estadd scalar num=`r(N)': est1
estadd local munfe "Yes": est1
estadd local yfe "Yes": est1

eststo: areg apper1000 logwmean_shockma10 y1940 y1940logarea 				///
	y1940logpop1930 y1940loc_ha1930 y1940prpop_agr1930 						/// 
	y1940prpop_ciudad1930 y1940logwmean_shockma10_1930  					///
	if hac1930==1, cl(id_1900) a(id_1900)
estadd scalar nloc=`e(N_clust)': est2
egen apper1000_mean=mean(apper1000) if e(sample)==1, by(id_1900)
egen apper1000_sd=sd(apper1000) if e(sample)==1, by(id_1900)
qui sum apper1000_mean
estadd scalar mean=`r(mean)': est2
qui sum apper1000_sd
estadd scalar sd=`r(mean)': est2
drop apper1000_mean apper1000_sd
estadd scalar num=`r(N)': est2
estadd local munfe "Yes": est2
estadd local yfe "Yes": est2


* Lagged Bureaucrats
by id_1900: gen Lapper1000=L10.apper1000 if year==1940
by id_1900: replace Lapper1000=L30.apper1000 if year==1930

areg Lapper1000 logwmean_shockma10 y1940 y1940logarea y1940logpop1930 		///
	y1940loc_ha1930 y1940prpop_agr1930 y1940prpop_ciudad1930 				///
	y1940logwmean_shockma10_1930						 	 				///
	if hac1930==1, cl(id_1900) a(id_1900)
eststo: areg Lapper1000 logwmean_shockma10 y1940  							///
	if hac1930==1 & e(sample)==1, cl(id_1900) a(id_1900)
estadd scalar nloc=`e(N_clust)': est3
egen Lapper1000_mean=mean(Lapper1000) if e(sample)==1, by(id_1900)
egen Lapper1000_sd=sd(Lapper1000) if e(sample)==1, by(id_1900)
qui sum Lapper1000_mean
estadd scalar mean=`r(mean)': est3
qui sum Lapper1000_sd
estadd scalar sd=`r(mean)': est3
drop Lapper1000_mean Lapper1000_sd
estadd scalar num=`r(N)': est3
estadd local munfe "Yes": est3
estadd local yfe "Yes": est3

eststo: areg Lapper1000 logwmean_shockma10 y1940 y1940logarea  				///
	y1940logpop1930 y1940loc_ha1930 y1940prpop_agr1930  					///
	y1940prpop_ciudad1930								  					///
	y1940logwmean_shockma10_1930 if hac1930==1, cl(id_1900) a(id_1900)
estadd scalar nloc=`e(N_clust)': est4
egen Lapper1000_mean=mean(Lapper1000) if e(sample)==1, by(id_1900)
egen Lapper1000_sd=sd(Lapper1000) if e(sample)==1, by(id_1900)
qui sum Lapper1000_mean
estadd scalar mean=`r(mean)': est4
qui sum Lapper1000_sd
estadd scalar sd=`r(mean)': est4
drop Lapper1000_mean Lapper1000_sd
estadd scalar num=`r(N)': est4
estadd local munfe "Yes": est4
estadd local yfe "Yes": est4

preserve
local datadir $data
use "`datadir'DPanel_Mun1940.dta", clear
tsset cve_geoest year

* Current Land Reform
areg repartoriego logwmean_shockma10 y1940 y1940logarea y1940logpop1930 	///
	y1940loc_ha1930 y1940prpop_agr1930 y1940prpop_ciudad1930 				///
	y1940logwmean_shockma10_1930 y1940repartoriegocum1930 	 				///
	if hac1930==1, cl(cve_geoest) a(cve_geoest)
eststo: areg repartoriego logwmean_shockma10 y1940  						///
	if hac1930==1 & e(sample)==1, cl(cve_geoest) a(cve_geoest)
estadd scalar nloc=`e(N_clust)': est5
egen repartoriego_mean=mean(repartoriego) if e(sample)==1, by(cve_geoest)
egen repartoriego_sd=sd(repartoriego) if e(sample)==1, by(cve_geoest)
qui sum repartoriego_mean
estadd scalar mean=`r(mean)': est5
qui sum repartoriego_sd
estadd scalar sd=`r(mean)': est5
drop repartoriego_mean repartoriego_sd
estadd scalar num=`r(N)': est5
estadd local munfe "Yes": est5
estadd local yfe "Yes": est5

eststo: areg repartoriego logwmean_shockma10 y1940 y1940logarea  			///
	y1940logpop1930 y1940loc_ha1930 y1940prpop_agr1930  					///
	y1940prpop_ciudad1930 y1940logwmean_shockma10_1930  					///
	y1940repartoriegocum1930 if hac1930==1, cl(cve_geoest) a(cve_geoest)
estadd scalar nloc=`e(N_clust)': est6
egen repartoriego_mean=mean(repartoriego) if e(sample)==1, by(cve_geoest)
egen repartoriego_sd=sd(repartoriego) if e(sample)==1, by(cve_geoest)
qui sum repartoriego_mean
estadd scalar mean=`r(mean)': est6
qui sum repartoriego_sd
estadd scalar sd=`r(mean)': est6
drop repartoriego_mean repartoriego_sd
estadd scalar num=`r(N)': est6
estadd local munfe "Yes": est6
estadd local yfe "Yes": est6

* Lagged Land Reform
by cve_geoest: gen Lrepartoriego=repartoriego_1920
by cve_geoest: replace Lrepartoriego=L10.repartoriego if year==1940

areg Lrepartoriego logwmean_shockma10 y1940 y1940logarea y1940logpop1930 	///
	y1940loc_ha1930 y1940prpop_agr1930 y1940prpop_ciudad1930 				///
	y1940logwmean_shockma10_1930 y1940repartoriegocum1930 	 				///
	if hac1930==1, cl(cve_geoest) a(cve_geoest)
eststo: areg Lrepartoriego logwmean_shockma10 y1940  						///
	if hac1930==1 & e(sample)==1, cl(cve_geoest) a(cve_geoest)
estadd scalar nloc=`e(N_clust)': est7
egen repartoriego_mean=mean(repartoriego) if e(sample)==1, by(cve_geoest)
egen repartoriego_sd=sd(repartoriego) if e(sample)==1, by(cve_geoest)
qui sum repartoriego_mean
estadd scalar mean=`r(mean)': est7
qui sum repartoriego_sd
estadd scalar sd=`r(mean)': est7
drop repartoriego_mean repartoriego_sd
estadd scalar num=`r(N)': est7
estadd local munfe "Yes": est7
estadd local yfe "Yes": est7

eststo: areg Lrepartoriego logwmean_shockma10 y1940 y1940logarea  			///
	y1940logpop1930 y1940loc_ha1930 y1940prpop_agr1930  					///
	y1940prpop_ciudad1930 y1940logwmean_shockma10_1930  					///
	y1940repartoriegocum1930 if hac1930==1, cl(cve_geoest) a(cve_geoest)
estadd scalar nloc=`e(N_clust)': est8
egen repartoriego_mean=mean(repartoriego) if e(sample)==1, by(cve_geoest)
egen repartoriego_sd=sd(repartoriego) if e(sample)==1, by(cve_geoest)
qui sum repartoriego_mean
estadd scalar mean=`r(mean)': est8
qui sum repartoriego_sd
estadd scalar sd=`r(mean)': est8
drop repartoriego_mean repartoriego_sd
estadd scalar num=`r(N)': est8
estadd local munfe "Yes": est8
estadd local yfe "Yes": est8
restore


*Fragment
local titl = "\specialcellc{Bureaucrats\\per 1000 people\\(1930-1940)}"
local titl2 = 																///
	"\specialcellc{Bureaucrats\\per 1000 people\\(Pre-Depression,\\1900-1930)}"
local titl3 = "\specialcellc{Land reform,\\grants\\(1930-1940)}"
local titl4 = 																///
	"\specialcellc{Land reform,\\grants\\(Pre-Depression,\\1920-1930)}"
#delimit;
local tablesdir $tables;
esttab using "`tablesdir'23_TableC5.tex",
b(a2) replace keep(logwmean_shockma10 
y1940logpop1930 y1940logarea y1940loc_ha1930 y1940prpop_agr1930 
y1940prpop_ciudad1930 y1940logwmean_shockma10_1930 y1940repartoriegocum1930) 
order(logwmean_shockma10 y1940logpop1930 y1940logarea y1940loc_ha1930 
y1940prpop_agr1930 y1940prpop_ciudad1930 
y1940logwmean_shockma10_1930 y1940repartoriegocum1930) 
gaps compress se bookt nodepvars star(* 0.10 ** 0.05 *** 0.01) fragment label 
nomtitles mgroups("`titl'" "`titl2'" "`titl3'" "`titl4'", 
pattern(1 0 1 0 1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) 
span erepeat(\cmidrule(lr){@span}))
stats(yfe munfe mean sd r2 num nloc, 
labels("Year FE" "Municipality FE" "Within-\textit{Municipio} Mean of DV" 
"Within-\textit{Municipio} SD of DV" "R sq." 
"Observations" "Number of municipios")); 
#delimit cr
drop _est_*




	******************************************************************
	**
	**
	**		NAME:		Francisco Garfias
	**		DATE: 		November 28, 2017
	**		PROYJECT: 	Elite Competition and State Capacity 
	**					Development: Theory and Evidence from 
	**					Post-Revolutionary Mexico
	**
	**		DETAILS: 	This code prepares Table B.2: Descriptive
	**					Statistics
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
* Table B.2: Descriptive Statistics
*-------------------------------------------------------------------------------


* Eliminate obs. in 1940 for <some variables> to get the right number of obs.
replace prtax=. if year==1940
replace ap2000per1000=. if year==1940
replace logpib=. if year==1940
replace logtransf=. if year==1940
replace hac1930=. if year==1940
replace logpop1930=. if year==1940
replace prpop_agr1930=. if year==1940
replace loc_ha1930=. if year==1940
replace logarea=. if year==1940
replace prpop_ciudad1930=. if year==1940

qui areg apper1000 logwmean_shockma10 logpop prpop_agr i.year, 				///
	cl(cve_geoest) a(cve_geoest)

* Generate table
eststo clear
set more off
#delimit;
estpost tabstat apper1000 logap aplocper1000 logaploc repartoriego prriego 
	hac1930 logwmean_shockma10 logwmean_shockforma10 logpop1930 prpop_agr1930 
	loc_ha1930 logarea prpop_ciudad1930 prtax ap2000per1000 logpib logtransf 
	nalgov_ nalelected_ if e(sample)==1, 
stats(n mean sd min p25 p50 p75 max) columns(stats);
#delimit cr


* Export table
local opts `"count(fmt(a1)) mean(fmt(a2)) sd(fmt(a2)) min(fmt(a2))p25(fmt(a2))"'
local opts `"`opts' p50(fmt(a2)) p75(fmt(a2)) max(fmt(a2))"'
di `"`opts'"'
local tablesdir $tables
esttab using "`tablesdir'11_TableB2.tex",									///
	varwidth(10) wrap cells(`"`opts'"') t(a2) label nomtitles nodepvars		///
	noobs nonum bookt fragment replace

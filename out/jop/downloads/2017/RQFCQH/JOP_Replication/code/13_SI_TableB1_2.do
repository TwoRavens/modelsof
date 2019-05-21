

	******************************************************************
	**
	**
	**		NAME:		Francisco Garfias
	**		DATE: 		December 10, 2017
	**		PROJECT: 	Elite Coalitions, Limited Government, and 
	**					Fiscal Capacity Development: Evidence from 
	**					Bourbon Mexico
	** 	
	**		DETAILS: 	This code produces Table B.1.2: Parallel 
	**					Trends in Civil Administration and Tax 
	**					Revenue from Trade and Agriculture (1714-1776)
	**					
	**
	** 
	**
	**				
	**		Versi—n: 	Stata MP 12.1
	**
	******************************************************************
	
	



		

			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* Data
*-------------------------------------------------------------------------------



clear all
local datadir $data
use "`datadir'NuevaEspana_cajas_Bourbon.dta", clear




		


			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* Table B.1.2: 	Parallel Trends in Civil Administration and Tax Revenue 
*				from Trade and Agriculture (1714-1776)
*-------------------------------------------------------------------------------



set more off		
eststo: xi: reg prRec 														///
			evertribunal 													///
			if year<1777, cl(cajacode)
qui sum prRec if e(sample)==1
estadd scalar mean=`r(mean)': est1
qui sum prRec if e(sample)==1
estadd scalar sd=`r(sd)': est1
estadd scalar num=`e(N_clust)': est1
estadd local yfe "No": est1
estadd local cfe "No": est1
estadd local irev "No": est1
estadd local contr "No": est1

qui reg prRec evertribunal if year<1777
bysort caja: egen m_prRec=mean(prRec) if e(sample)==1
gen dm_prRec=prRec-m_prRec
eststo: xi: reg dm_prRec 													///
			i.year evertribunal 											///
			if year<1777, cl(cajacode)
qui sum dm_prRec if e(sample)==1
estadd scalar mean=`r(mean)': est2
qui sum dm_prRec if e(sample)==1
estadd scalar sd=`r(sd)': est2
estadd scalar num=`e(N_clust)': est2
estadd local yfe "Yes": est2
estadd local cfe "No": est2
estadd local irev "No": est2
estadd local contr "No": est2

eststo: xi: reg dm_prRec 													///
			i.year i.year*inilogtotal_c										///
			near_tabasco near_zimapan near_rosario							///			
			near_bolanos near_carmen near_arispe near_chihuahua 			///
			near_saltillo near_michoacan near_puebla near_oaxaca			///
			evertribunal 													///
			if year<1777, cl(cajacode)
qui sum dm_prRec if e(sample)==1
estadd scalar mean=`r(mean)': est3
qui sum dm_prRec if e(sample)==1
estadd scalar sd=`r(sd)': est3
estadd scalar num=`e(N_clust)': est3
estadd local yfe "Yes": est3
estadd local cfe "No": est3
estadd local irev "Yes": est3
estadd local contr "Yes": est3
drop m_prRec dm_prRec


eststo: xi: reg logComTax 													///
			evertribunal 													///
			if year<1777, cl(cajacode)
egen logComTax_mean=mean(logComTax) if e(sample)==1
egen logComTax_sd=sd(logComTax) if e(sample)==1
qui sum logComTax if e(sample)==1
estadd scalar mean=`r(mean)': est4
qui sum logComTax if e(sample)==1
estadd scalar sd=`r(sd)': est4
estadd scalar num=`e(N_clust)': est4
estadd local yfe "No": est4
estadd local cfe "No": est4
estadd local irev "No": est4
estadd local contr "No": est4

qui reg logComTax evertribunal if year<1777
bysort caja: egen m_logComTax=mean(logComTax) if e(sample)==1
gen dm_logComTax=logComTax-m_logComTax
eststo: xi: reg dm_logComTax 												///
			i.year evertribunal												///
			if year<1777, cl(cajacode)
qui sum dm_logComTax if e(sample)==1
estadd scalar mean=`r(mean)': est5
qui sum dm_logComTax if e(sample)==1
estadd scalar sd=`r(sd)': est5
estadd scalar num=`e(N_clust)': est5
estadd local yfe "Yes": est5
estadd local cfe "No": est5
estadd local irev "No": est5
estadd local contr "No": est5

eststo: xi: reg dm_logComTax 												///
			i.year i.year*inilogtotal_c										///
			near_tabasco near_zimapan near_rosario							///			
			near_bolanos near_carmen near_arispe near_chihuahua 			///
			near_saltillo near_michoacan near_puebla near_oaxaca			///
			evertribunal 													///
			if year<1777, cl(cajacode)
qui sum dm_logComTax if e(sample)==1
estadd scalar mean=`r(mean)': est6
qui sum dm_logComTax if e(sample)==1
estadd scalar sd=`r(sd)': est6
estadd scalar num=`e(N_clust)': est6
estadd local yfe "Yes": est6
estadd local cfe "No": est6
estadd local irev "Yes": est6
estadd local contr "Yes": est6
drop m_logComTax dm_logComTax

#delimit;
local tablesdir $tables;
esttab using "`tablesdir'TableB1_2.tex",
b(a2) replace keep(evertribunal) 
coeflabels(evertribunal "Mining District")
gaps compress se bookt nodepvars star(* 0.10 ** 0.05 *** 0.01) fragment label 
mtitles("" "" "" "" "" "")
substitute(\_ _)
stats(yfe cfe irev contr mean sd r2 N num, 
labels("Year Intercepts" "Treasury Intercepts" 
"Initial Revenue (log pesos)\\ \$\times$ Year Intercepts"
"Nearby New Treasury Control"
"Mean of DV" "SD of DV" "R sq." 
"Observations" "Number of Royal Treasuries")); 
#delimit cr
drop _est_*



		
		



			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	
						** end of do file **		




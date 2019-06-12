

	******************************************************************
	**
	**
	**		NAME:		Francisco Garfias
	**		DATE: 		December 10, 2017
	**		PROJECT: 	Elite Coalitions, Limited Government, and 
	**					Fiscal Capacity Development: Evidence from 
	**					Bourbon Mexico
	** 	
	**		DETAILS: 	This code produces Table 2: The Effect of 
	**					the Mining Tribunal on Tax Revenue from 
	**					Trade and Agriculture (1759-1786)
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
set mat 11000
local datadir $data
use "`datadir'NuevaEspana_cajas.dta", clear




		


			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* Table 2: 	The Effect of the Mining Tribunal on Tax Revenue from Trade 
*			and Agriculture (1759-1786)
*-------------------------------------------------------------------------------



set more off
sort cajacode year		
eststo: xi: areg logComTax 													///
			i.year 															///
			tribunal, a(cajacode) cl(cajacode)
by cajacode: egen logComTax_mean=mean(logComTax) if e(sample)==1
by cajacode: egen logComTax_sd=sd(logComTax) if e(sample)==1
qui sum logComTax_mean
estadd scalar mean=`r(mean)': est1
qui sum logComTax_sd
estadd scalar sd=`r(mean)': est1
drop logComTax_mean logComTax_sd
estadd scalar num=`e(N_clust)': est1
estadd local yfe "Yes": est1
estadd local ctr "No": est1
estadd local ctrsq "No": est1
estadd local cfe "Yes": est1
estadd local irev "No": est1
estadd local contr "No": est1

eststo: xi: areg logComTax 													///
			i.year i.year*inilogtotal_c										///
			near_tabasco near_zimapan near_rosario							///			
			near_bolanos near_carmen near_arispe near_chihuahua 			///
			near_saltillo near_michoacan near_puebla near_oaxaca			///
			tribunal, a(cajacode) cl(cajacode)
by cajacode: egen logComTax_mean=mean(logComTax) if e(sample)==1
by cajacode: egen logComTax_sd=sd(logComTax) if e(sample)==1
qui sum logComTax_mean
estadd scalar mean=`r(mean)': est2
qui sum logComTax_sd
estadd scalar sd=`r(mean)': est2
drop logComTax_mean logComTax_sd
estadd scalar num=`e(N_clust)': est2
estadd local yfe "Yes": est2
estadd local ctr "No": est2
estadd local ctrsq "No": est2
estadd local cfe "Yes": est2
estadd local irev "Yes": est2
estadd local contr "Yes": est2

eststo: xi: reg logComTax 													///
			i.year i.year*inilogtotal_c i.cajacode i.cajacode*year			///
			near_tabasco near_zimapan near_rosario							///				
			near_bolanos near_carmen near_arispe near_chihuahua 			///
			near_saltillo near_michoacan near_puebla near_oaxaca			///
			tribunal, cl(cajacode)
by cajacode: egen logComTax_mean=mean(logComTax) if e(sample)==1
by cajacode: egen logComTax_sd=sd(logComTax) if e(sample)==1
qui sum logComTax_mean
estadd scalar mean=`r(mean)': est3
qui sum logComTax_sd
estadd scalar sd=`r(mean)': est3
drop logComTax_mean logComTax_sd
estadd scalar num=`e(N_clust)': est3
estadd local yfe "Yes": est3
estadd local ctr "Yes": est3
estadd local ctrsq "No": est3
estadd local cfe "Yes": est3
estadd local irev "Yes": est3
estadd local contr "Yes": est3

eststo: xi: reg logComTax 													///
			i.year i.year*inilogtotal_c i.cajacode 							///
			i.cajacode*year i.cajacode*yrsq 								///
			near_tabasco near_zimapan near_rosario							///			
			near_bolanos near_carmen near_arispe near_chihuahua 			///
			near_saltillo near_michoacan near_puebla near_oaxaca			///
			tribunal, cl(cajacode)	
by cajacode: egen logComTax_mean=mean(logComTax) if e(sample)==1
by cajacode: egen logComTax_sd=sd(logComTax) if e(sample)==1
qui sum logComTax_mean
estadd scalar mean=`r(mean)': est4
qui sum logComTax_sd
estadd scalar sd=`r(mean)': est4
drop logComTax_mean logComTax_sd
estadd scalar num=`e(N_clust)': est4
estadd local yfe "Yes": est4
estadd local ctr "Yes": est4
estadd local ctrsq "Yes": est4
estadd local cfe "Yes": est4
estadd local irev "Yes": est4
estadd local contr "Yes": est4

eststo: xi: reg logComTax 													///
			i.year i.cajacode												///
			F4switchtrib F3switchtrib F2switchtrib 							///
			Fswitchtrib switchtrib Lswitchtrib L2switchtrib 				///
			L3switchtrib  L4tribunalm, cl(cajacode)
by cajacode: egen logComTax_mean=mean(logComTax) if e(sample)==1
by cajacode: egen logComTax_sd=sd(logComTax) if e(sample)==1
qui sum logComTax_mean
estadd scalar mean=`r(mean)': est5
qui sum logComTax_sd
estadd scalar sd=`r(mean)': est5
drop logComTax_mean logComTax_sd
estadd scalar num=`e(N_clust)': est5
estadd local yfe "Yes": est5
estadd local ctr "No": est5
estadd local ctrsq "No": est5
estadd local cfe "Yes": est5
estadd local irev "No": est5
estadd local contr "No": est5

eststo: xi: reg logComTax													/// 
			i.year i.year*inilogtotal_c	i.cajacode							///
			near_tabasco near_zimapan near_rosario							///				
			near_bolanos near_carmen near_arispe near_chihuahua 			///
			near_saltillo near_michoacan near_puebla near_oaxaca			///
			F4switchtrib F3switchtrib F2switchtrib 							///
			Fswitchtrib switchtrib Lswitchtrib L2switchtrib 				///
			L3switchtrib  L4tribunalm, cl(cajacode)
by cajacode: egen logComTax_mean=mean(logComTax) if e(sample)==1
by cajacode: egen logComTax_sd=sd(logComTax) if e(sample)==1
qui sum logComTax_mean
estadd scalar mean=`r(mean)': est6
qui sum logComTax_sd
estadd scalar sd=`r(mean)': est6
drop logComTax_mean logComTax_sd
estadd scalar num=`e(N_clust)': est6
estadd local yfe "Yes": est6
estadd local ctr "No": est6
estadd local ctrsq "No": est6
estadd local cfe "Yes": est6
estadd local irev "Yes": est6
estadd local contr "Yes": est6


* Export
*-------
#delimit;
local tablesdir $tables;
esttab using "`tablesdir'Table2.tex",
b(a2) replace keep(tribunalm  F4switchtrib
	F3switchtrib F2switchtrib Fswitchtrib switchtrib Lswitchtrib
	L2switchtrib L3switchtrib  L4tribunalm) 
order(tribunalm  F4switchtrib 
	F3switchtrib F2switchtrib Fswitchtrib switchtrib Lswitchtrib
	L2switchtrib L3switchtrib  L4tribunalm) 
coeflabels(tribunalm "Mining Tribunal" 
	F4switchtrib "Implied Tribunal leads and lags:\\Mining Tribunal\$\_{t+4}$" 
	F3switchtrib "Mining Tribunal\$\_{t+3}$" 
	F2switchtrib "Mining Tribunal\$\_{t+2}$"
	Fswitchtrib "Mining Tribunal\$\_{t+1}$" 
	switchtrib "Mining Tribunal\$\_{t0}$" 
	Lswitchtrib "Mining Tribunal\$\_{t-1}$" 
	L2switchtrib "Mining Tribunal\$\_{t-2}$"
	L3switchtrib "Mining Tribunal\$\_{t-3}$" 
	L4tribunalm "Mining Tribunal\$\_{t-4\;forward}$")
gaps compress se bookt nodepvars star(* 0.10 ** 0.05 *** 0.01) fragment label 
mtitles("" "" "" "" "" "")
substitute(\_ _)
stats(yfe ctr ctrsq cfe irev contr mean sd r2 N num, 
labels("Year Intercepts" "Treasury \$\times$ Time Trend" 
"Treasury \$\times$ Time Trend Squared"  "Treasury Intercepts" 
"Initial Revenue (log pesos)\\ \$\times$ Year Intercepts"
"Nearby New Treasury Control"
"Within-Treasury Mean of DV" "Within-Treasury SD of DV" "R sq." 
"Observations" "Number of Royal Treasuries")); 
#delimit cr
drop _est_*



		
		



			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	
						** end of do file **		




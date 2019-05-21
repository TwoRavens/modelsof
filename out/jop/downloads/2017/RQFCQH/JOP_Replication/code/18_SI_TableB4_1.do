

	******************************************************************
	**
	**
	**		NAME:		Francisco Garfias
	**		DATE: 		December 10, 2017
	**		PROJECT: 	Elite Coalitions, Limited Government, and 
	**					Fiscal Capacity Development: Evidence from 
	**					Bourbon Mexico
	** 	
	**		DETAILS: 	This code produces Table B.4.1: The Effect 
	**					of the Mining Tribunal on Civil Administration 
	**					(1759-1786), Excluding Mexico City or 
	**					Coding it as Mining Treasury
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
use "`datadir'NuevaEspana_cajas.dta", clear







			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* Table B.4.1: 	The Effect of the Mining Tribunal on Civil Administration 
*				(1759-1786), Excluding Mexico City/Coding it as Mining Treasury
*-------------------------------------------------------------------------------



* Change Mexico City to be included as a mining Caja
*---------------------------------------------------
gen tribCDMX=tribunal
replace tribCDMX=1 if cajacode=="MX" & year>=1777 & year!=.
sort cajacode year

set more off		
eststo: xi: areg prRec 														///
			i.year 															///
			tribCDMX if cajacode!="MX", 									///
			a(cajacode) cl(cajacode)
by cajacode: egen prRec_mean=mean(prRec) if e(sample)==1
by cajacode: egen prRec_sd=sd(prRec) if e(sample)==1
qui sum prRec_mean
estadd scalar mean=`r(mean)': est1
qui sum prRec_sd
estadd scalar sd=`r(mean)': est1
drop prRec_mean prRec_sd
estadd scalar num=`e(N_clust)': est1
estadd local yfe "Yes": est1
estadd local ctr "No": est1
estadd local ctrsq "No": est1
estadd local cfe "Yes": est1
estadd local irev "No": est1
estadd local contr "No": est1

eststo: xi: areg prRec 														///
			i.year i.year*inilogtotal_c										///
			near_tabasco near_zimapan near_rosario							///			
			near_bolanos near_carmen near_arispe near_chihuahua 			///
			near_saltillo near_michoacan near_puebla near_oaxaca			///
			tribCDMX if cajacode!="MX",										///
			a(cajacode) cl(cajacode)
by cajacode: egen prRec_mean=mean(prRec) if e(sample)==1
by cajacode: egen prRec_sd=sd(prRec) if e(sample)==1
qui sum prRec_mean
estadd scalar mean=`r(mean)': est2
qui sum prRec_sd
estadd scalar sd=`r(mean)': est2
drop prRec_mean prRec_sd
estadd scalar num=`e(N_clust)': est2
estadd local yfe "Yes": est2
estadd local ctr "No": est2
estadd local ctrsq "No": est2
estadd local cfe "Yes": est2
estadd local irev "Yes": est2
estadd local contr "Yes": est2
		
eststo: xi: areg logComTax 													///
			i.year 															///
			tribCDMX if cajacode!="MX", 									///
			a(cajacode) cl(cajacode)
by cajacode: egen logComTax_mean=mean(logComTax) if e(sample)==1
by cajacode: egen logComTax_sd=sd(logComTax) if e(sample)==1
qui sum logComTax_mean
estadd scalar mean=`r(mean)': est3
qui sum logComTax_sd
estadd scalar sd=`r(mean)': est3
drop logComTax_mean logComTax_sd
estadd scalar num=`e(N_clust)': est3
estadd local yfe "Yes": est3
estadd local ctr "No": est3
estadd local ctrsq "No": est3
estadd local cfe "Yes": est3
estadd local irev "No": est3
estadd local contr "No": est3

eststo: xi: areg logComTax 													///
			i.year i.year*inilogtotal_c										///
			near_tabasco near_zimapan near_rosario							///			
			near_bolanos near_carmen near_arispe near_chihuahua 			///
			near_saltillo near_michoacan near_puebla near_oaxaca			///
			tribCDMX if cajacode!="MX",										///
			 a(cajacode) cl(cajacode)
by cajacode: egen logComTax_mean=mean(logComTax) if e(sample)==1
by cajacode: egen logComTax_sd=sd(logComTax) if e(sample)==1
qui sum logComTax_mean
estadd scalar mean=`r(mean)': est4
qui sum logComTax_sd
estadd scalar sd=`r(mean)': est4
drop logComTax_mean logComTax_sd
estadd scalar num=`e(N_clust)': est4
estadd local yfe "Yes": est4
estadd local ctr "No": est4
estadd local ctrsq "No": est4
estadd local cfe "Yes": est4
estadd local irev "Yes": est4
estadd local contr "Yes": est4

eststo: xi: areg prRec 														///
			i.year 															///
			tribCDMX, a(cajacode) cl(cajacode)
by cajacode: egen prRec_mean=mean(prRec) if e(sample)==1
by cajacode: egen prRec_sd=sd(prRec) if e(sample)==1
qui sum prRec_mean
estadd scalar mean=`r(mean)': est5
qui sum prRec_sd
estadd scalar sd=`r(mean)': est5
drop prRec_mean prRec_sd
estadd scalar num=`e(N_clust)': est5
estadd local yfe "Yes": est5
estadd local ctr "No": est5
estadd local ctrsq "No": est5
estadd local cfe "Yes": est5
estadd local irev "No": est5
estadd local contr "No": est5

eststo: xi: areg prRec 														///
			i.year i.year*inilogtotal_c										///
			near_tabasco near_zimapan near_rosario							///			
			near_bolanos near_carmen near_arispe near_chihuahua 			///
			near_saltillo near_michoacan near_puebla near_oaxaca			///
			tribCDMX, a(cajacode) cl(cajacode)
by cajacode: egen prRec_mean=mean(prRec) if e(sample)==1
by cajacode: egen prRec_sd=sd(prRec) if e(sample)==1
qui sum prRec_mean
estadd scalar mean=`r(mean)': est6
qui sum prRec_sd
estadd scalar sd=`r(mean)': est6
drop prRec_mean prRec_sd
estadd scalar num=`e(N_clust)': est6
estadd local yfe "Yes": est6
estadd local ctr "No": est6
estadd local ctrsq "No": est6
estadd local cfe "Yes": est6
estadd local irev "Yes": est6
estadd local contr "Yes": est6


set more off		
eststo: xi: areg logComTax 													///
			i.year 															///
			tribCDMX, a(cajacode) cl(cajacode)
by cajacode: egen logComTax_mean=mean(logComTax) if e(sample)==1
by cajacode: egen logComTax_sd=sd(logComTax) if e(sample)==1
qui sum logComTax_mean
estadd scalar mean=`r(mean)': est7
qui sum logComTax_sd
estadd scalar sd=`r(mean)': est7
drop logComTax_mean logComTax_sd
estadd scalar num=`e(N_clust)': est7
estadd local yfe "Yes": est7
estadd local ctr "No": est7
estadd local ctrsq "No": est7
estadd local cfe "Yes": est7
estadd local irev "No": est7
estadd local contr "No": est7

eststo: xi: areg logComTax 													///
			i.year i.year*inilogtotal_c										///
			near_tabasco near_zimapan near_rosario							///			
			near_bolanos near_carmen near_arispe near_chihuahua 			///
			near_saltillo near_michoacan near_puebla near_oaxaca			///
			tribCDMX, a(cajacode) cl(cajacode)
by cajacode: egen logComTax_mean=mean(logComTax) if e(sample)==1
by cajacode: egen logComTax_sd=sd(logComTax) if e(sample)==1
qui sum logComTax_mean
estadd scalar mean=`r(mean)': est8
qui sum logComTax_sd
estadd scalar sd=`r(mean)': est8
drop logComTax_mean logComTax_sd
estadd scalar num=`e(N_clust)': est8
estadd local yfe "Yes": est8
estadd local ctr "No": est8
estadd local ctrsq "No": est8
estadd local cfe "Yes": est8
estadd local irev "Yes": est8
estadd local contr "Yes": est8


#delimit;
local tablesdir $tables;
esttab using "`tablesdir'TableB4_1.tex",
b(a2) replace keep(tribCDMX) 
coeflabels(tribCDMX "Mining Tribunal")
gaps compress se bookt nodepvars star(* 0.10 ** 0.05 *** 0.01) fragment label 
mtitles("" "" "" "" "" "" "" "")
substitute(\_ _)
stats(yfe ctr ctrsq cfe irev contr mean sd r2 N num, 
labels("Year Intercepts" "Treasury \$\times$ Time Trend" 
"Treasury \$\times$ Time Trend Squared" "Treasury Intercepts" 
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




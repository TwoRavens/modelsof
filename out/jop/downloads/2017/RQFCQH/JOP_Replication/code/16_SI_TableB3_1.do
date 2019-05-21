

	******************************************************************
	**
	**
	**		NAME:		Francisco Garfias
	**		DATE: 		December 10, 2017
	**		PROJECT: 	Elite Coalitions, Limited Government, and 
	**					Fiscal Capacity Development: Evidence from 
	**					Bourbon Mexico
	** 	
	**		DETAILS: 	This code produces Table B.3.1: The Effect 
	**					of the Mining Tribunal on Civil 
	**					Administration (1714-1810)
	**					Entropy Balance Weights
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
* Table B.3.1: 	The Effect of the Mining Tribunal on Civil Administration 
*				(1714-1810), Entropy Balance Weights
*-------------------------------------------------------------------------------



* Estimate weights
*-----------------
set more off
preserve
qui reg prRec evertribunal if year<1777
keep if e(sample)==1
keep prRec evertribunal logtotal_c cajacode year
reshape wide prRec logtotal_c, i(cajacode) j(year)
ebalance evertribunal prRec1756 prRec1764 prRec1772 prRec1775
keep cajacode _w
save "`datadir'ebal_weights.dta", replace
restore

merge m:1 cajacode using "`datadir'ebal_weights.dta"


* Estimations with basic controls for both periods
*-------------------------------------------------
sort cajacode year
eststo: xi: areg prRec 														///
			i.year i.year*inilogtotal_c										///
			near_tabasco near_zimapan near_rosario							///	
			near_bolanos near_carmen near_arispe near_chihuahua 			///
			near_saltillo near_michoacan near_puebla near_oaxaca			///
			tribunal 														///
			if CarlosIIIReign==1 [pw=_webal], a(cajacode) cl(cajacode)
by cajacode: egen prRec_mean=mean(prRec) if e(sample)==1
by cajacode: egen prRec_sd=sd(prRec) if e(sample)==1
qui sum prRec_mean
estadd scalar mean=`r(mean)': est1
qui sum prRec_sd
estadd scalar sd=`r(mean)': est1
drop prRec_mean prRec_sd
estadd scalar num=`e(N_clust)': est1
estadd local yfe "Yes": est1
estadd local cfe "Yes": est1
estadd local irev "Yes": est1
estadd local contr "Yes": est1

eststo: xi: areg prRec 														///
			i.year i.year*inilogtotal_c										///
			near_tabasco near_zimapan near_rosario							///	
			near_bolanos near_carmen near_arispe near_chihuahua 			///
			near_saltillo near_michoacan near_puebla near_oaxaca			///
			tribunal [pw=_webal], a(cajacode) cl(cajacode)
by cajacode: egen prRec_mean=mean(prRec) if e(sample)==1
by cajacode: egen prRec_sd=sd(prRec) if e(sample)==1
qui sum prRec_mean
estadd scalar mean=`r(mean)': est2
qui sum prRec_sd
estadd scalar sd=`r(mean)': est2
drop prRec_mean prRec_sd
estadd scalar num=`e(N_clust)': est2
estadd local yfe "Yes": est2
estadd local cfe "Yes": est2
estadd local irev "Yes": est2
estadd local contr "Yes": est2

eststo: xi: areg logComTax 													///
			i.year i.year*inilogtotal_c										///
			near_tabasco near_zimapan near_rosario							///	
			near_bolanos near_carmen near_arispe near_chihuahua 			///
			near_saltillo near_michoacan near_puebla near_oaxaca			///
			tribunal 														///
			if CarlosIIIReign==1 [pw=_webal], a(cajacode) cl(cajacode)
by cajacode: egen logComTax_mean=mean(logComTax) if e(sample)==1
by cajacode: egen logComTax_sd=sd(logComTax) if e(sample)==1
qui sum logComTax_mean
estadd scalar mean=`r(mean)': est3
qui sum logComTax_sd
estadd scalar sd=`r(mean)': est3
drop logComTax_mean logComTax_sd
estadd scalar num=`e(N_clust)': est3
estadd local yfe "Yes": est3
estadd local cfe "Yes": est3
estadd local irev "Yes": est3
estadd local contr "Yes": est3

eststo: xi: areg logComTax 													///
			i.year i.year*inilogtotal_c										///
			near_tabasco near_zimapan near_rosario							///	
			near_bolanos near_carmen near_arispe near_chihuahua 			///
			near_saltillo near_michoacan near_puebla near_oaxaca			///
			tribunal [pw=_webal], a(cajacode) cl(cajacode)
by cajacode: egen logComTax_mean=mean(logComTax) if e(sample)==1
by cajacode: egen logComTax_sd=sd(logComTax) if e(sample)==1
qui sum logComTax_mean
estadd scalar mean=`r(mean)': est4
qui sum logComTax_sd
estadd scalar sd=`r(mean)': est4
drop logComTax_mean logComTax_sd
estadd scalar num=`e(N_clust)': est4
estadd local yfe "Yes": est4
estadd local cfe "Yes": est4
estadd local irev "Yes": est4
estadd local contr "Yes": est4


#delimit;
local tablesdir $tables;
esttab using "`tablesdir'TableB3_1.tex",
b(a2) replace keep(tribunalm ) 
order(tribunalm ) 
coeflabels(tribunalm "Mining Tribunal")
gaps compress se bookt nodepvars star(* 0.10 ** 0.05 *** 0.01) fragment label 
mtitles("" "" "" "" "" "")
substitute(\_ _)
stats(yfe cfe irev contr mean sd r2 N num, 
labels("Year Intercepts" "Treasury Intercepts" 
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




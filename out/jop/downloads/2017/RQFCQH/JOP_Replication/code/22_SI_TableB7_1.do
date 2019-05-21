

	******************************************************************
	**
	**
	**		NAME:		Francisco Garfias
	**		DATE: 		December 10, 2017
	**		PROJECT: 	Elite Coalitions, Limited Government, and 
	**					Fiscal Capacity Development: Evidence from 
	**					Bourbon Mexico
	** 	
	**		DETAILS: 	This code produces Table B.7.1: The Effect 
	**					of the Mining Tribunal on Civil
	**					Administration, by the Size of the pre-1777
	**					Non-Mining Sector (1759-1786)
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
* Table B.7.1: 	The Effect of the Mining Tribunal on Civil Administration
*				by the Size of the pre-1777 Non-Mining Sector (1759-1786)
*-------------------------------------------------------------------------------


* Above-median tribute revenue prior to the Mining Tribunal (1758-1775)
*----------------------------------------------------------------------
gen Hnon_elite_=0
bysort cajacode: egen avg_p_Tributo_=mean(p_Tributo) if year<1777
replace avg_p_Tributo_=0 if avg_p_Tributo_==. & year<1777
bysort cajacode: egen avg_p_Mineria_=mean(p_Mineria) if year<1777
replace avg_p_Mineria_=0 if avg_p_Mineria_==. & year<1777
egen tot_=rsum(avg_p_Tributo_ avg_p_Mineria_)
gen avg_ratio_=avg_p_Tributo_/tot

qui su avg_ratio_ if year==1775 & evertribunal==1, d
replace Hnon_elite_=1 if avg_ratio_>=`r(p50)' & avg_ratio_~=.

qui areg prRec i.year tribunal, a(cajacode) cl(cajacode)
bysort cajacode: egen Hnon_elite=max(Hnon_elite_) if e(sample)==1
bysort cajacode: egen avg_ratio=max(avg_ratio_) if e(sample)==1
drop Hnon_elite_ avg_p_Tributo_ avg_ratio_

gen tribunalmXHnon_elite=tribunalm*Hnon_elite
gen tribunalmXavg_ratio=tribunalm*avg_ratio


set more off
sort cajacode year
eststo: xi: areg prRec 														///
			i.year 															///
			tribunalm tribunalmXHnon_elite, a(cajacode) cl(cajacode)
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
			tribunalm tribunalmXHnon_elite, a(cajacode) cl(cajacode)
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

eststo: xi: reg prRec 														///
			i.year i.year*inilogtotal_c i.cajacode i.cajacode*year 			///
			near_tabasco near_zimapan near_rosario							///						
			near_bolanos near_carmen near_arispe near_chihuahua 			///
			near_saltillo near_michoacan near_puebla near_oaxaca			///
			tribunalm tribunalmXHnon_elite, cl(cajacode)
by cajacode: egen prRec_mean=mean(prRec) if e(sample)==1
by cajacode: egen prRec_sd=sd(prRec) if e(sample)==1
qui sum prRec_mean
estadd scalar mean=`r(mean)': est3
qui sum prRec_sd
estadd scalar sd=`r(mean)': est3
drop prRec_mean prRec_sd
estadd scalar num=`e(N_clust)': est3
estadd local yfe "Yes": est3
estadd local ctr "Yes": est3
estadd local ctrsq "No": est3
estadd local cfe "Yes": est3
estadd local irev "Yes": est3
estadd local contr "Yes": est3

eststo: xi: reg prRec 														///
			i.year i.year*inilogtotal_c i.cajacode 							///
			i.cajacode*year i.cajacode*yrsq 								///
			near_tabasco near_zimapan near_rosario							///			
			near_bolanos near_carmen near_arispe near_chihuahua 			///
			near_saltillo near_michoacan near_puebla near_oaxaca			///
			tribunalm tribunalmXHnon_elite, cl(cajacode)
by cajacode: egen prRec_mean=mean(prRec) if e(sample)==1
by cajacode: egen prRec_sd=sd(prRec) if e(sample)==1
qui sum prRec_mean
estadd scalar mean=`r(mean)': est4
qui sum prRec_sd
estadd scalar sd=`r(mean)': est4
drop prRec_mean prRec_sd
estadd scalar num=`e(N_clust)': est4
estadd local yfe "Yes": est4
estadd local ctr "Yes": est4
estadd local ctrsq "Yes": est4
estadd local cfe "Yes": est4
estadd local irev "Yes": est4
estadd local contr "Yes": est4

eststo: xi: areg prRec 														///
			i.year 															///
			tribunalm tribunalmXavg_ratio, a(cajacode) cl(cajacode)
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
			tribunalm tribunalmXavg_ratio, a(cajacode) cl(cajacode)
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

eststo: xi: reg prRec 														///
			i.year i.year*inilogtotal_c i.cajacode i.cajacode*year 			///
			near_tabasco near_zimapan near_rosario							///						
			near_bolanos near_carmen near_arispe near_chihuahua 			///
			near_saltillo near_michoacan near_puebla near_oaxaca			///
			tribunalm tribunalmXavg_ratio, cl(cajacode)
by cajacode: egen prRec_mean=mean(prRec) if e(sample)==1
by cajacode: egen prRec_sd=sd(prRec) if e(sample)==1
qui sum prRec_mean
estadd scalar mean=`r(mean)': est7
qui sum prRec_sd
estadd scalar sd=`r(mean)': est7
drop prRec_mean prRec_sd
estadd scalar num=`e(N_clust)': est7
estadd local yfe "Yes": est7
estadd local ctr "Yes": est7
estadd local ctrsq "No": est7
estadd local cfe "Yes": est7
estadd local irev "Yes": est7
estadd local contr "Yes": est7

eststo: xi: reg prRec 														///
			i.year i.year*inilogtotal_c i.cajacode 							///
			i.cajacode*year i.cajacode*yrsq 								///
			near_tabasco near_zimapan near_rosario							///			
			near_bolanos near_carmen near_arispe near_chihuahua 			///
			near_saltillo near_michoacan near_puebla near_oaxaca			///
			tribunalm tribunalmXavg_ratio, cl(cajacode)
by cajacode: egen prRec_mean=mean(prRec) if e(sample)==1
by cajacode: egen prRec_sd=sd(prRec) if e(sample)==1
qui sum prRec_mean
estadd scalar mean=`r(mean)': est8
qui sum prRec_sd
estadd scalar sd=`r(mean)': est8
drop prRec_mean prRec_sd
estadd scalar num=`e(N_clust)': est8
estadd local yfe "Yes": est8
estadd local ctr "Yes": est8
estadd local ctrsq "Yes": est8
estadd local cfe "Yes": est8
estadd local irev "Yes": est8
estadd local contr "Yes": est8


* Export
*-------
#delimit;
local tablesdir $tables;
esttab using "`tablesdir'TableB7_1.tex",
b(a2) replace 
keep(tribunalm space1 tribunalmXHnon_elite tribunalmXavg_ratio) 
order(tribunalm space1 tribunalmXHnon_elite tribunalmXavg_ratio) 
coeflabels(tribunalm "Mining Tribunal" 
	space1 "Mining Tribunal $\times$"
	tribunalmXHnon_elite 
"\hspace{.5cm}\specialcell{Pre-1777 Avg. Poll Tax\\Dominance, Above Median\\Among Mining Treasuries}"
	tribunalmXavg_ratio 
"\hspace{.5cm}\specialcell{Pre-1777 Avg. Poll Tax\\Dominance (\%)}")
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




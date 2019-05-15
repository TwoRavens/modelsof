*GENERAL INFO
	* Project: Political Competition and Public Goods Provision
	* Created by: Jessica Gottlieb
	* Date created: June 2016
	* Last updated: July 25, 2018
	* Last updated by: Katrina Kosec
* DO FILE INFO
	* 1) This .do file performs analyses on panel elections and pg data from Mali. It mentions two other dofiles that can produce results not in thise file 
	* 2) You need to download gsa2 ado file from Prof. Harada's website: http://www3.grips.ac.jp/~m-harada/docs/research.html#gsa2 . After doing so, here are instructions on how to save ado file on computer: https://www.stata.com/manuals13/u17.pdf
	* 3) The final dataset was created using two separate .do files along with additional code commented out at the bottom of this .do file:
		* a) DV_2008_2013_6-23
		* b) construct_PI_vars_6-15

* HOUSEKEEPING
	clear
	set more off
* LAY OUT ECONOMETRIC FRAMEOWRK TO BE EMPLOYED
*(y_2 - y_1) = (x_2 - x_1)\beta1 + y_1\beta2 + \epsilon 
*(First differences with lagged dependent variable)

	
****************************************************************

***Import final dataset 
use MaliCommune_data.dta, clear

*************
***TABLE 1***
*************

* TABLE 1, PANEL A: HHI

global controls1 pop_dif pavedroads08 electricity08 proj_2008  
global controls2 pop_dif pavedroads_dif electricity_dif proj_dif

regress anderson4_dif seats_HHI_2009_dif anderson4_2008, vce(cluster cercle_int)
estimates store model1
regress anderson4_dif seats_HHI_2009_dif PI_c2_seats_2009_dif anderson4_2008, vce(cluster cercle_int)
estimates store model2
regress anderson4_dif seats_HHI_2009_dif PI_c2_seats_2009_dif $controls1 anderson4_2008, vce(cluster cercle_int)
estimates store model3
regress anderson4_dif seats_HHI_2009_dif PI_c2_seats_2009_dif $controls2 anderson4_2008 , vce(cluster cercle_int)
estimates store model4
regress anderson4_dif c.seats_HHI_2009_dif##majseats09 PI_c2_seats_2009_dif $controls1 anderson4_2008, vce(cluster cercle_int)
estimates store model5
esttab model1 model2 model3 model4 model5 /// 
	using "../Tables/Anderson_HHI.tex", star(+ 0.1 * 0.05 ** 0.01 *** 0.001) se b(3) se(3) r2(2) label booktabs alignment(D{.}{.}{-1}) replace ///
	stats(N,layout("\multicolumn{1}{c}{@}") labels("Observations") f(0))  ///
	title(Effect of Change in HHI (2004-2009) on Change in Public Goods Index (2008-2013) \label{tab:Anderson_HHI})  ///
	varlabels (_cons Constant) ///
	sub("\begin{table}[htbp]" "\begin{table}[htbp] \setlength{\tabcolsep}{-1pt} " "Party=1" "Party") ///
	nonotes  nobaselevels  nogaps nomtitles ///
	addnote("OLS models with standard errors clustered at the cercle level. $^+ p<0.10$, $^{*} p<0.05$, $^{**} p<0.01$, $^{***} p<0.001$")

*corr(seats_HHI_2009_dif banzhaf_index_2009_dif) if e(sample)==1
*(obs=660)
*
*             | seats_.. banzha..
*-------------+------------------
*s~I_2009_dif |   1.0000
*banzhaf_in~f |   0.6086   1.0000


* TABLE 1, PANEL B: Vote margin

global controls1 pop_dif pavedroads08 electricity08 proj_2008  
global controls2 pop_dif pavedroads_dif electricity_dif proj_dif

regress anderson4_dif seats_margin_2009_dif anderson4_2008, vce(cluster cercle_int)
estimates store model1
regress anderson4_dif seats_margin_2009_dif PI_c2_seats_2009_dif anderson4_2008, vce(cluster cercle_int)
estimates store model2
regress anderson4_dif seats_margin_2009_dif PI_c2_seats_2009_dif $controls1 anderson4_2008, vce(cluster cercle_int)
estimates store model3
regress anderson4_dif seats_margin_2009_dif PI_c2_seats_2009_dif $controls2 anderson4_2008, vce(cluster cercle_int)
estimates store model4
regress anderson4_dif c.seats_margin_2009_dif##majseats09 PI_c2_seats_2009_dif $controls1 anderson4_2008, vce(cluster cercle_int)
estimates store model5
esttab model1 model2 model3 model4 model5 /// 
	using "../Tables/Anderson_mv.tex", star(+ 0.1 * 0.05 ** 0.01 *** 0.001) se b(3) se(3) r2(2) label booktabs alignment(D{.}{.}{-1}) replace ///
	stats(N,layout("\multicolumn{1}{c}{@}") labels("Observations") f(0))  ///
	title(Effect of Change in Margin of Victory (2004-2009) on Change in Public Goods Index (2008-2013) \label{tab:Anderson_mv})  ///
	varlabels (_cons Constant) ///
	sub("\begin{table}[htbp]" "\begin{table}[htbp] \setlength{\tabcolsep}{-1pt} " "Party=1" "Party") ///
	nonotes  nobaselevels  nogaps nomtitles ///
	addnote("OLS models with standard errors clustered at the cercle level. $^+ p<0.10$, $^{*} p<0.05$, $^{**} p<0.01$, $^{***} p<0.001$")

*corr(seats_margin_2009_dif banzhaf_margin_2009_dif) if e(sample)==1
*(obs=631)
*
*             | seats_.. banzha..
*-------------+------------------
*s~n_2009_dif |   1.0000
*banzhaf_ma~f |   0.6677   1.0000



****************
***FIGURE A.3***
****************

**SUB-FIGURE A - Sensitivity analysis for HHI

*Comment out if gsa2 ado file is not yet installed.
preserve
gsa2 anderson4_dif seats_HHI_2009_dif PI_c2_seats_2009_dif $controls1 anderson4_2008, save(HHI_gsa) vce(cluster cercle_int) tau(0.1055) yfamily(gaussian) ylink(identity) tfamily(gaussian) tlink(identity) seed(835321)
restore

**Make Imbens Plot Where we Consider control sets separately (1 - national government and NGO PG, 2 - population, 3 - volatility) to make plot:

*Take difference in R-squared values for gsa2 command:

*national government and NGO PG:
regress anderson4_dif seats_HHI_2009_dif PI_c2_seats_2009_dif pop_dif anderson4_2008, vce(cluster cercle_int)
*R-squared: 0.1016
regress anderson4_dif seats_HHI_2009_dif PI_c2_seats_2009_dif pop_dif pavedroads08 electricity08 proj_2008 anderson4_2008, vce(cluster cercle_int)
*R-squared: 0.1108

regress seats_HHI_2009_dif PI_c2_seats_2009_dif pop_dif anderson4_2008, vce(cluster cercle_int)
*R-squared: 0.0465
regress seats_HHI_2009_dif PI_c2_seats_2009_dif pop_dif pavedroads08 electricity08 proj_2008 anderson4_2008, vce(cluster cercle_int)
*R-squared: 0.0509

*Pop:
regress anderson4_dif seats_HHI_2009_dif PI_c2_seats_2009_dif pavedroads08 electricity08 proj_2008 anderson4_2008, vce(cluster cercle_int)
*R-squared: 0.1102
regress anderson4_dif seats_HHI_2009_dif PI_c2_seats_2009_dif pop_dif pavedroads08 electricity08 proj_2008 anderson4_2008, vce(cluster cercle_int)
*R-squared: 0.1108

regress seats_HHI_2009_dif PI_c2_seats_2009_dif pavedroads08 electricity08 proj_2008 anderson4_2008, vce(cluster cercle_int)
*R-squared: 0.0507
regress seats_HHI_2009_dif PI_c2_seats_2009_dif pop_dif pavedroads08 electricity08 proj_2008 anderson4_2008, vce(cluster cercle_int)
*R-squared: 0.0509

*Volatility:
regress anderson4_dif seats_HHI_2009_dif pop_dif pavedroads08 electricity08 proj_2008 anderson4_2008, vce(cluster cercle_int)
*R-squared: 0.1098
regress anderson4_dif seats_HHI_2009_dif PI_c2_seats_2009_dif pop_dif pavedroads08 electricity08 proj_2008 anderson4_2008, vce(cluster cercle_int)
*R-squared: 0.1108

regress seats_HHI_2009_dif pop_dif pavedroads08 electricity08 proj_2008 anderson4_2008, vce(cluster cercle_int)
*R-squared: 0.0212
regress seats_HHI_2009_dif PI_c2_seats_2009_dif pop_dif pavedroads08 electricity08 proj_2008 anderson4_2008, vce(cluster cercle_int)
*R-squared: 0.0509

preserve
use "HHI_gsa.dta", clear
label var gsa_par_rsq_y "Additional variation in outcome explained by covariate"
label var gsa_par_rsq_t "Additional variation in political concentration explained by covariate"
scatter gsa_par_rsq_y gsa_par_rsq_t || scatteri 0.0092 0.0044 (12) "Center/NGO"  || scatteri 0.0006 0.0002 (6) "Pop." || scatteri 0.001 0.0297 (3) "Volatility", ytitle("Additional variation in outcome explained by covariate") xtitle("Additional variation in political concentration explained by covariate")  legend(off) graphregion(color(white))
graph export "Imbens_HHI_3Groups.png", replace
restore

**SUB-FIGURE B - Sensitivity analysis for margin of victory

***Sensitivity analysis. Comment out if gsa2 ado file is not yet installed
preserve
gsa2 anderson4_dif seats_margin_2009_dif PI_c2_seats_2009_dif $controls1 anderson4_2008, save(margin_gsa) vce(cluster cercle_int) tau(0.098) yfamily(gaussian) ylink(identity) tfamily(gaussian) tlink(identity) seed(835321)
restore

***Make Imbens Plot Where we Consider control sets separately (1 - national government and NGO PG, 2 - population, 3 - volatility) to make plot:

*Take difference in R-squared values for gsa2 command:

*national government and NGO PG:
regress anderson4_dif seats_margin_2009_dif PI_c2_seats_2009_dif pop_dif anderson4_2008, vce(cluster cercle_int)
*R-squared: 0.1053
regress anderson4_dif seats_margin_2009_dif PI_c2_seats_2009_dif pop_dif pavedroads08 electricity08 proj_2008 anderson4_2008, vce(cluster cercle_int)
*R-squared: 0.1146

regress seats_margin_2009_dif PI_c2_seats_2009_dif pop_dif anderson4_2008, vce(cluster cercle_int)
*R-squared: 0.0381
regress seats_margin_2009_dif PI_c2_seats_2009_dif pop_dif pavedroads08 electricity08 proj_2008 anderson4_2008, vce(cluster cercle_int)
*R-squared: 0.0401

*Pop:
regress anderson4_dif seats_margin_2009_dif PI_c2_seats_2009_dif pavedroads08 electricity08 proj_2008 anderson4_2008, vce(cluster cercle_int)
*R-squared: 0.1140
regress anderson4_dif seats_margin_2009_dif PI_c2_seats_2009_dif pop_dif pavedroads08 electricity08 proj_2008 anderson4_2008, vce(cluster cercle_int)
*R-squared: 0.1146

regress seats_margin_2009_dif PI_c2_seats_2009_dif pavedroads08 electricity08 proj_2008 anderson4_2008, vce(cluster cercle_int)
*R-squared: 0.0399
regress seats_margin_2009_dif PI_c2_seats_2009_dif pop_dif pavedroads08 electricity08 proj_2008 anderson4_2008, vce(cluster cercle_int)
*R-squared: 0.0401

*Volatility:
regress anderson4_dif seats_margin_2009_dif pop_dif pavedroads08 electricity08 proj_2008 anderson4_2008, vce(cluster cercle_int)
*R-squared: 0.1122
regress anderson4_dif seats_margin_2009_dif PI_c2_seats_2009_dif pop_dif pavedroads08 electricity08 proj_2008 anderson4_2008, vce(cluster cercle_int)
*R-squared: 0.1146

regress seats_margin_2009_dif pop_dif pavedroads08 electricity08 proj_2008 anderson4_2008, vce(cluster cercle_int)
*R-squared: 0.0112
regress seats_margin_2009_dif PI_c2_seats_2009_dif pop_dif pavedroads08 electricity08 proj_2008 anderson4_2008, vce(cluster cercle_int)
*R-squared: 0.0401

preserve
use "margin_gsa.dta", clear
label var gsa_par_rsq_y "Additional variation in outcome explained by covariate"
label var gsa_par_rsq_t "Additional variation in political concentration explained by covariate"
scatter gsa_par_rsq_y gsa_par_rsq_t || scatteri 0.0093 0.002 (12) "Center/NGO"  || scatteri 0.0006 0.0002 (6) "Pop." || scatteri 0.0024 0.0289 (3) "Volatility", ytitle("Additional variation in outcome explained by covariate") xtitle("Additional variation in political competition explained by covariate")  legend(off) graphregion(color(white))
graph export "Imbens_margin_3Groups.png", replace
restore



**************
***FIGURE 1***
**************
 
* FIGURE 1, LEFT PANEL: Heterogeneous effects by whether there is a majority party on the council, HHI

*Create marginal effects plot
regress anderson4_dif c.seats_HHI_2009_dif##i.majseats09 PI_c2_seats_2009_dif anderson4_2008 $controls1, vce(cluster cercle_int)
margins, dydx(seats_HHI_2009_dif) by(majseats09) atmeans
marginsplot, plotopts(connect(none)) name(herf, replace) title("") scheme(plotplainblind) yline(0, lcolor(red))	///
xmtick(-.5(1)1.5, grid gmin gmax) xsc(range(-.5(1)1.5)) ytitle("Marginal Effect of {&Delta} HHI with 95% CIs") xtitle(Majority Party)

margins, at(majseats09 =(0 1)) dydx(seats_HHI_2009_dif) post // Tests if marginal effects are the same in each group
 test _b[1bn._at] = _b[2._at]  // Can only reject null with p=.12
 
 
* FIGURE 1, RIGHT PANEL: heterogeneous effects by whether there is a majority party on the council, margin of victory

*Create marginal effects plot
regress anderson4_dif c.seats_margin_2009_dif##i.majseats09 PI_c2_seats_2009_dif anderson4_2008 $controls1, vce(cluster cercle_int)
margins, dydx(seats_margin_2009_dif) by(majseats09) atmeans
marginsplot, plotopts(connect(none)) name(mov, replace) title("") scheme(plotplainblind) yline(0, lcolor(red))	///
xmtick(-.5(1)1.5, grid gmin gmax) xsc(range(-.5(1)1.5)) ytitle("Marginal Effect of {&Delta} Margin of Victory with 95% CIs") xtitle(Majority Party)

margins, at(majseats09 =(0 1)) dydx(seats_margin_2009_dif) post // Tests if marginal effects are the same in each group
 test _b[1bn._at] = _b[2._at]  // Can only reject null with p=.14

 
* FIGURE 1, BOTH PANELS COMBINED:
 
graph combine herf mov, graphregion(fcolor(white) ilcolor(white) lcolor(white)) ycommon cols(2) name(graph, replace)
graph display graph, xsize(10) ysize(5) scale(1.2)
graph export "../Figures/MarginalEffectByMajority.pdf", replace



**************************************
***FIGURE 2 AND APPENDIX TABLE A.13***
**************************************

* Examine correlations with ELF and geographic dispersion

pwcorr ELF seats_margin_2009 seats_HHI_2009 seats_margin_2009_dif seats_HHI_2009_dif, sig
pwcorr geodensity popdensity seats_margin_2009 seats_HHI_2009 seats_margin_2009_dif seats_HHI_2009_dif, sig

* Examine correlations with preference fractionalization

*prefindexall is the prefence fractionalization index generated from all 3 priorities mentioned in the AB data R2-4 (N=232)
*The creation of this variable is in ABprefindex_GK_Replication.do

*Results hold if we limit to 231 communes (but HHI no longer significant)
regress anderson4_dif c.seats_HHI_2009_dif  PI_c2_seats_2009_dif $controls1 anderson4_2008 if prefindexall!=., vce(cluster cercle_int)
estimates store model1
regress anderson4_dif c.seats_margin_2009_dif  PI_c2_seats_2009_dif $controls1 anderson4_2008 if prefindexall!=., vce(cluster cercle_int)
estimates store model11

*Controlling for pref frac doesn't undermine finding
regress anderson4_dif c.seats_HHI_2009_dif prefindexall PI_c2_seats_2009_dif $controls1 anderson4_2008 , vce(cluster cercle_int)
estimates store model2
regress anderson4_dif c.seats_margin_2009_dif prefindexall PI_c2_seats_2009_dif $controls1 anderson4_2008 , vce(cluster cercle_int)
estimates store model22

*Conditioning on pref frac significant
regress anderson4_dif c.seats_HHI_2009_dif##c.prefindexall PI_c2_seats_2009_dif $controls1 anderson4_2008, vce(cluster cercle_int)
estimates store model3
margins, dydx(seats_HHI_2009_dif) at(prefindexall=(.58(.05).84)) atmeans
marginsplot, name(herf, replace) title("") scheme(plotplainblind) yline(0, lcolor(red))	/// 
ytitle("Marginal Effect of {&Delta} HHI with 95% CIs") xtitle(Preference Fractionalization)

interflex anderson4_dif seats_HHI_2009_dif prefindexall PI_c2_seats_2009_dif $controls1 anderson4_2008, vce(robust) cluster(cercle_int) ///
ylabel({&Delta} Public Goods Index (2008-2013)) dlabel({&Delta} HHI (2004-2009)) xlabel(Preference Fractionalization) 
addplot: ,yline(0, lcolor(red)) 
graph rename herfi, replace
*Wald test: p=.2.

regress anderson4_dif c.seats_margin_2009_dif##c.prefindexall PI_c2_seats_2009_dif $controls1 anderson4_2008, vce(cluster cercle_int)
estimates store model33
margins, dydx(seats_margin_2009_dif) at(prefindexall=(.58(.05).84)) atmeans
marginsplot, name(mov, replace) title("") scheme(plotplainblind) yline(0, lcolor(red))	/// 
ytitle("Marginal Effect of {&Delta} Margin of Victory with 95% CIs") xtitle(Preference Fractionalization)

interflex anderson4_dif seats_margin_2009_dif prefindexall PI_c2_seats_2009_dif $controls1 anderson4_2008, vce(robust) cluster(cercle_int) ///
ylabel({&Delta} Public Goods Index (2008-2013)) dlabel({&Delta} MoV (2004-2009)) xlabel(Preference Fractionalization) 
addplot: ,yline(0, lcolor(red)) 
graph rename movi, replace
*Wald test: p=.1. Can almost reject the NULL hypothesis that the linear interaction model and the three-bin model are statisticallyequivalent

graph combine herfi movi, graphregion(fcolor(white) ilcolor(white) lcolor(white)) ycommon cols(2) name(graph, replace)
graph display graph, xsize(10) ysize(5) scale(1.2)
graph export "../Figures/MarginalEffectByPrefindexI.pdf", replace

esttab model1 model11 model2 model22 model3 model33 /// 
	using "../Tables/prefindex.tex", star(+ 0.1 * 0.05 ** 0.01 *** 0.001) se b(3) se(3) r2(2) label booktabs alignment(D{.}{.}{-1}) replace ///
	stats(N,layout("\multicolumn{1}{c}{@}") labels("Observations") f(0))  ///
	title(Effect of Change in Herfindahl Index (2004-2009) on Change in Public Goods Index (2008-2013), by Preference Fractionalization \label{tab:preffrac})  ///
	varlabels (_cons Constant) ///
	order(seats_HHI_2009_dif seats_margin_2009_dif prefindexall c.seats_HHI_2009_dif#c.prefindexall c.seats_margin_2009_dif#c.prefindexall) ///
	sub("\begin{table}[htbp]" "\begin{table}[htbp] \setlength{\tabcolsep}{-2pt} " ) ///
	nonotes  nobaselevels  nogaps nomtitles ///
	addnote("OLS models with standard errors clustered at the cercle level. $^+ p<0.10$, $^{*} p<0.05$, $^{**} p<0.01$, $^{***} p<0.001$")


**************************************
***FIGURE 3 AND APPENDIX TABLE A.14***
**************************************

*compute mean and SD of each variable for only those 660 obs that appear in SUR specification, and generate normalized (N(0,1)) variants of outcomes
summ school_2013 if PI_c2_seats_2009_dif!=. & pop_dif!=. & pavedroads08!=. & electricity08!=.    
gen n_school_2013=(school_2013-15.3197)/11.45378
replace n_school_2013=. if PI_c2_seats_2009_dif==. | pop_dif==. | pavedroads08==. | electricity08==.  

summ clinic_2013 if PI_c2_seats_2009_dif!=. & pop_dif!=. & pavedroads08!=. & electricity08!=.  
gen n_clinic_2013=(clinic_2013-3.818182)/3.384823
replace n_clinic_2013=. if PI_c2_seats_2009_dif==. | pop_dif==. | pavedroads08==. | electricity08==.  

summ boreh_2013 if PI_c2_seats_2009_dif!=. & pop_dif!=. & pavedroads08!=. & electricity08!=.    
gen n_boreh_2013=(boreh_2013-16.95)/18.4942
replace n_boreh_2013=. if PI_c2_seats_2009_dif==. | pop_dif==. | pavedroads08==. | electricity08==.  

summ road_2013 if PI_c2_seats_2009_dif!=. & pop_dif!=. & pavedroads08!=. & electricity08!=.  
gen n_road_2013=(road_2013-121.9603)/130.6625
replace n_road_2013=. if PI_c2_seats_2009_dif==. | pop_dif==. | pavedroads08==. | electricity08==.  

summ school_2008 if PI_c2_seats_2009_dif!=. & pop_dif!=. & pavedroads08!=. & electricity08!=.    
gen n_school_2008=(school_2008-13.43137)/10.75239
replace n_school_2008=. if PI_c2_seats_2009_dif==. | pop_dif==. | pavedroads08==. | electricity08==.  

summ clinic_2008 if PI_c2_seats_2009_dif!=. & pop_dif!=. & pavedroads08!=. & electricity08!=.  
gen n_clinic_2008=(clinic_2008-3.33805)/2.795474
replace n_clinic_2008=. if PI_c2_seats_2009_dif==. | pop_dif==. | pavedroads08==. | electricity08==.  

summ boreh_2008 if PI_c2_seats_2009_dif!=. & pop_dif!=. & pavedroads08!=. & electricity08!=. 
gen n_boreh_2008=(boreh_2008-15.80275)/17.12791
replace n_boreh_2008=. if PI_c2_seats_2009_dif==. | pop_dif==. | pavedroads08==. | electricity08==.  

summ road_2008 if PI_c2_seats_2009_dif!=. & pop_dif!=. & pavedroads08!=. & electricity08!=.  
gen n_road_2008=(road_2008-105.3081)/184.546
replace n_road_2008=. if PI_c2_seats_2009_dif==. | pop_dif==. | pavedroads08==. | electricity08==.  

summ n_school_2013 n_clinic_2013 n_boreh_2013 n_road_2013 n_school_2008 n_clinic_2008 n_boreh_2008 n_road_2008
*above confirms all mean 0, SD 1

*construct 2008-2013 change in normalized (N(0,1)) outcomes
gen n_school_dif=n_school_2013-n_school_2008
gen n_clinic_dif=n_clinic_2013-n_clinic_2008
gen n_boreh_dif=n_boreh_2013-n_boreh_2008
gen n_road_dif=n_road_2013-n_road_2008

**Comment out the three lines of code immediately below this comment to run regressions with non-normalized variants of our # of infrastructure variables (roads, clinics, schools, and boreholes) and thus obtain the numbers of additional clinics and schools associated with a change in political competition which are reported in Section 5 (around p. 30)
foreach x in school_2013 clinic_2013 boreh_2013 road_2013 school_2008 clinic_2008 boreh_2008 road_2008 school_dif clinic_dif boreh_dif road_dif {
replace `x'=n_`x'
}

*Create macros for running SUR regressions
global outcomes boreh clinic road school 
global var2008 boreh_2008 clinic_2008 road_2008 school_2008
global var2013 boreh_2013 clinic_2013 road_2013 school_2013
global vardif boreh_dif clinic_dif road_dif school_dif


* APPENDIX TABLE A.14, PANEL A: Effect of HHI on individual goods
	
*Use seemingly unrelated regressions to test effect of competition on individual goods
foreach y in $outcomes {
reg `y'_dif seats_HHI_2009_dif PI_c2_seats_2009_dif `y'_2008 $controls1
est sto `y'_dif
}

suest $vardif, cformat(%9.3f) vce(cluster cercle_int)
estimates store SUR_HHI
test seats_HHI_2009_dif

*Create regression table
esttab SUR_HHI ///
	using "../Tables/SUR_HHI.tex", unstack star(+ 0.1 * 0.05 ** 0.01 *** 0.001) se b(3) se(3) r2(2) label booktabs alignment(D{.}{.}{-1}) replace ///
	keep(boreh_dif_mean: clinic_dif_mean: road_dif_mean: school_dif_mean:) stats(N,layout("\multicolumn{1}{c}{@}") labels("Observations") f(0))  ///
	title(Effect of Change in HHI (2004-2009) on Change in Public Goods (2008-2013) \label{tab:SUR_HHI})  ///
	varlabels (_cons Constant) ///
	sub("\begin{table}[htbp]" "\begin{table}[htbp] \setlength{\tabcolsep}{-1pt} ") ///
	nonotes  nobaselevels nogaps nomtitles nonum eqlabels("\multicolumn{1}{c}{Boreholes}" "\multicolumn{1}{c}{Clinics}" "\multicolumn{1}{c}{Roads}" "\multicolumn{1}{c}{Schools}") ///
	addnote("Pooled seemingly unrelated regression analyses with standard errors clustered at the cercle level." "$^+ p<0.10$, $^{*} p<0.05$, $^{**} p<0.01$, $^{***} p<0.001$")


* APPENDIX TABLE A.14, PANEL B: Effect of HHI on individual goods, with majority party interaction term
	
*Use seemingly unrelated regressions to test effect of competition on individual goods
foreach y in $outcomes {
reg `y'_dif c.seats_HHI_2009_dif##majseats09 PI_c2_seats_2009_dif `y'_2008 $controls1
est sto `y'_dif
}

suest $vardif, cformat(%9.3f) vce(cluster cercle_int)
estimates store SUR_HHI
test seats_HHI_2009_dif

*Create regression table
esttab SUR_HHI ///
	using "../Tables/SUR_HHI_maj.tex", unstack star(+ 0.1 * 0.05 ** 0.01 *** 0.001) se b(3) se(3) r2(2) label booktabs alignment(D{.}{.}{-1}) replace ///
	keep(boreh_dif_mean: clinic_dif_mean: road_dif_mean: school_dif_mean:) stats(N,layout("\multicolumn{1}{c}{@}") labels("Observations") f(0))  ///
	title(Effect of Change in HHI (2004-2009) on Change in Public Goods (2008-2013) \label{tab:SUR_HHI_maj})  ///
	varlabels (_cons Constant) ///
	sub("\begin{table}[htbp]" "\begin{table}[htbp] \setlength{\tabcolsep}{-1pt} " "Party=1" "Party") ///
	nonotes  nobaselevels nogaps nomtitles nonum eqlabels("\multicolumn{1}{c}{Boreholes}" "\multicolumn{1}{c}{Clinics}" "\multicolumn{1}{c}{Roads}" "\multicolumn{1}{c}{Schools}") ///
	addnote("Pooled seemingly unrelated regression analyses with standard errors clustered at the cercle level." "$^+ p<0.10$, $^{*} p<0.05$, $^{**} p<0.01$, $^{***} p<0.001$")

* Figure 3, HHI measure: MARGINAL EFFECTS PLOTS FOR SUR TESTS

*Create marginal effects plots for HHI
foreach y in $outcomes{
margins, predict(equation(`y'_dif_mean)) dydx(seats_HHI_2009_dif) by(majseats09) atmeans
marginsplot, plotopts(connect(none)) name(`y'herf, replace) title("") scheme(plotplainblind) yline(0, lcolor(red))	///
xmtick(-.5(1)1.5, grid gmin gmax) xsc(range(-.5(1)1.5)) ytitle("") xtitle("")
}	


* TABLE A.14, PANEL C: Effect of margin of victory on individual goods

*Use seemingly unrelated regressions to test effect of competition on individual goods
foreach y in $outcomes {
reg `y'_dif seats_margin_2009_dif PI_c2_seats_2009_dif `y'_2008 $controls1
est sto `y'_dif
}

suest $vardif, cformat(%9.3f) vce(cluster cercle_int)
estimates store SUR_margin
test seats_margin_2009_dif

*create regression table
esttab SUR_margin ///
	using "../Tables/SUR_margin.tex", unstack star(+ 0.1 * 0.05 ** 0.01 *** 0.001) se b(3) se(3) r2(2) label booktabs alignment(D{.}{.}{-1}) replace ///
	keep(school_dif_mean: clinic_dif_mean: boreh_dif_mean: road_dif_mean:) stats(N,layout("\multicolumn{1}{c}{@}") labels("Observations") f(0))  ///
	title(Effect of Change in Margin of Victory (2004-2009) on Change in Public Goods (2008-2013) \label{tab:SUR_margin})  ///
	varlabels (_cons Constant) ///
	sub("\begin{table}[htbp]" "\begin{table}[htbp] \setlength{\tabcolsep}{-1pt} ") ///
	nonotes  nobaselevels  nogaps nomtitles nonum eqlabels("\multicolumn{1}{c}{Boreholes}" "\multicolumn{1}{c}{Clinics}" "\multicolumn{1}{c}{Roads}" "\multicolumn{1}{c}{Schools}") ///
	addnote("Pooled seemingly unrelated regression analyses with standard errors clustered at the cercle level." "$^+ p<0.10$, $^{*} p<0.05$, $^{**} p<0.01$, $^{***} p<0.001$")


* TABLE A.14, PANEL D: Effect of margin of victory on individual goods, with majority party interaction term

*Use seemingly unrelated regressions to test effect of competition on individual goods
foreach y in $outcomes {
reg `y'_dif c.seats_margin_2009_dif##majseats09 PI_c2_seats_2009_dif `y'_2008 $controls1
est sto `y'_dif
}

suest $vardif, cformat(%9.3f) vce(cluster cercle_int)
estimates store SUR_margin
test seats_margin_2009_dif

*create regression table
esttab SUR_margin ///
	using "../Tables/SUR_margin_maj.tex", unstack star(+ 0.1 * 0.05 ** 0.01 *** 0.001) se b(3) se(3) r2(2) label booktabs alignment(D{.}{.}{-1}) replace ///
	keep(school_dif_mean: clinic_dif_mean: boreh_dif_mean: road_dif_mean:) stats(N,layout("\multicolumn{1}{c}{@}") labels("Observations") f(0))  ///
	title(Effect of Change in Margin of Victory (2004-2009) on Change in Public Goods (2008-2013) \label{tab:SUR_margin_maj})  ///
	varlabels (_cons Constant) ///
	sub("\begin{table}[htbp]" "\begin{table}[htbp] \setlength{\tabcolsep}{-1pt} " "Party=1" "Party") ///
	nonotes  nobaselevels  nogaps nomtitles nonum eqlabels("\multicolumn{1}{c}{Boreholes}" "\multicolumn{1}{c}{Clinics}" "\multicolumn{1}{c}{Roads}" "\multicolumn{1}{c}{Schools}") ///
	addnote("Pooled seemingly unrelated regression analyses with standard errors clustered at the cercle level." "$^+ p<0.10$, $^{*} p<0.05$, $^{**} p<0.01$, $^{***} p<0.001$")
	
	
* Figure 3 (continued), margin of victory measure: MARGINAL EFFECTS PLOTS FOR SUR TESTS

*Create marginal effects plots for margin of victory
foreach y in $outcomes{
margins, predict(equation(`y'_dif_mean)) dydx(seats_margin_2009_dif) by(majseats09) atmeans
marginsplot, plotopts(connect(none)) name(`y'margin, replace) title("") scheme(plotplainblind) yline(0, lcolor(red))	///
xmtick(-.5(1)1.5, grid gmin gmax) xsc(range(-.5(1)1.5)) ytitle("") xtitle("")
}	

* Figure 3, combine all subgraphs to create final figure:

graph combine borehherf clinicherf roadherf schoolherf borehmargin clinicmargin roadmargin schoolmargin, ///
graphregion(fcolor(white) ilcolor(white) lcolor(white)) ycommon rows(2) name(graph, replace) ///
l1title("{&Delta} Margin of Victory                   {&Delta} HHI") ///
b1title(Majority Party) subtitle("    Boreholes                               Clinics                             Roads                              Schools")
graph display graph, xsize(10) ysize(5) scale(1.2)
graph export "../Figures/MarginalEffectByMajority_SUR.pdf", replace



***TABLE 3 AND APPENDIX FIGURES 1 AND 2(CONSTITUENT SPENDING ANALYSIS) ARE IN ANOTHER DOFILE: pre-election_analyses_Replication.do


***FIGURE 5 AND APPENDIX TABLES A.18, A.19, and A.20 (A TEST OF GENERALIZABILITY USING CROSS-COUNTRY DATA) ARE IN ANOTHER DOFILE: AnalyzeCrossCountry_Replication.do


*****************************************
***APPENDIX B (DESCRIPTIVE STATISTICS)***
*****************************************

* Summary statistics

label var seats_HHI_2004 "Concentration, HHI (2004)"
label var seats_HHI_2009 "Concentration, HHI (2009)"
label var seats_margin_2004 "Concentration, Margin (2004)"
label var seats_margin_2009 "Concentration, Margin (2009)"

label var boreh_2013 "Boreholes (2013)"
label var clinic_2013 "Clinics (2013)" 
label var road_2013 "Rural Roads (2013)" 
label var school_2013 "Schools (2013)" 

global ivs seats_HHI_2009_dif seats_margin_2009_dif seats_HHI_2009 seats_margin_2009 seats_HHI_2004 seats_margin_2004 prefindexall
global allcontrols PI_c2_seats_2009_dif  PI_c2_seats_2004 anderson4_2008 PCA4_2008 pop_dif paved_2008 electr_2008 
global dvs anderson4_dif PCA4_dif boreh_2013 clinic_2013 road_2013 school_2013 boreh_2008 clinic_2008 road_2008 school_2008 
global allvars $dvs $ivs $allcontrols 

*latex tables
foreach v of varlist $allvars {
	label variable `v' `"\hspace{0.1cm} `: variable label `v''"'
	}

set more off
estpost su $allvars 
esttab . using "../Tables/summ1.tex", replace booktabs ///
		collabels("\textbf{Mean}" "\textbf{SD}" "\textbf{Min}" "\textbf{Max}"  "\textbf{N}")  ///
		cells("mean(fmt(2)) sd(fmt(2)) min(fmt(2)) max(fmt(2)) count(fmt(0))") label  nonum  gaps  noobs ///
   		refcat(anderson4_dif "\textbf{Dependent Variables}" seats_HHI_2009_dif "\textbf{Independent Variables}" PI_c2_seats_2009_dif "\textbf{Controls}", nolabel)


		
************************
***APPENDIX TABLE A.2***
************************

* PANEL A: Show robustness of HHI results to adding region dummies (allow regions to be on different trends)

global controls1 pop_dif pavedroads08 electricity08 proj_2008  
global controls2 pop_dif pavedroads_dif electricity_dif proj_dif

*Hand create region FE, so that we can make Koulikoro -- the region that saw the greatest increased in the Anderson index over 2008-13 -- the base group 
tab region_int, gen(regionFE)
drop regionFE2
label var regionFE1 "Kayes"
label var regionFE3 "Sikasso"
label var regionFE4 "Segou"
label var regionFE5 "Mopti"
label var regionFE6 "Tombouctou"
label var regionFE7 "Gao"
label var regionFE8 "Kidal"

regress anderson4_dif seats_HHI_2009_dif anderson4_2008 regionFE*, vce(cluster cercle_int)
estimates store model1
regress anderson4_dif seats_HHI_2009_dif PI_c2_seats_2009_dif anderson4_2008 regionFE*, vce(cluster cercle_int)
estimates store model2
regress anderson4_dif seats_HHI_2009_dif PI_c2_seats_2009_dif $controls1 anderson4_2008 regionFE*, vce(cluster cercle_int)
estimates store model3
regress anderson4_dif seats_HHI_2009_dif PI_c2_seats_2009_dif $controls2 anderson4_2008 regionFE*, vce(cluster cercle_int)
estimates store model4
regress anderson4_dif c.seats_HHI_2009_dif##majseats09 PI_c2_seats_2009_dif $controls1 anderson4_2008 regionFE*, vce(cluster cercle_int)
estimates store model5
esttab model1 model2 model3 model4 model5 /// 
	using "../Tables/Anderson_HHI_regtrend.tex", star(+ 0.1 * 0.05 ** 0.01 *** 0.001) se b(3) se(3) r2(2) label booktabs alignment(D{.}{.}{-1}) replace ///
	stats(N,layout("\multicolumn{1}{c}{@}") labels("Observations") f(0))  ///
	title(Effect of Change in HHI (2004-2009) on Change in Public Goods Index (2008-2013) \label{tab:Anderson_HHI_regtrend})  ///
	varlabels (_cons Constant) ///
	sub("\begin{table}[htbp]" "\begin{table}[htbp] \setlength{\tabcolsep}{-1pt} " "Party=1" "Party") ///
	nonotes  nobaselevels  nogaps nomtitles ///
	addnote("OLS models with standard errors clustered at the cercle level. $^+ p<0.10$, $^{*} p<0.05$, $^{**} p<0.01$, $^{***} p<0.001$")


* PANEL B: Show robustness of margin of victory results to adding region dummies (allow regions to be on different trends)

global controls1 pop_dif pavedroads08 electricity08 proj_2008  
global controls2 pop_dif pavedroads_dif electricity_dif proj_dif

regress anderson4_dif seats_margin_2009_dif anderson4_2008 regionFE*, vce(cluster cercle_int)
estimates store model1
regress anderson4_dif seats_margin_2009_dif PI_c2_seats_2009_dif anderson4_2008 regionFE*, vce(cluster cercle_int)
estimates store model2
regress anderson4_dif seats_margin_2009_dif PI_c2_seats_2009_dif $controls1 anderson4_2008 regionFE*, vce(cluster cercle_int)
estimates store model3
regress anderson4_dif seats_margin_2009_dif PI_c2_seats_2009_dif $controls2 anderson4_2008 regionFE*, vce(cluster cercle_int)
estimates store model4
regress anderson4_dif c.seats_margin_2009_dif##majseats09 PI_c2_seats_2009_dif $controls1 anderson4_2008 regionFE*, vce(cluster cercle_int)
estimates store model5
esttab model1 model2 model3 model4 model5 /// 
	using "../Tables/Anderson_mv_regtrend.tex", star(+ 0.1 * 0.05 ** 0.01 *** 0.001) se b(3) se(3) r2(2) label booktabs alignment(D{.}{.}{-1}) replace ///
	stats(N,layout("\multicolumn{1}{c}{@}") labels("Observations") f(0))  ///
	title(Effect of Change in Margin of Victory (2004-2009) on Change in Public Goods Index (2008-2013) \label{tab:Anderson_mv_regtrend})  ///
	varlabels (_cons Constant) ///
	sub("\begin{table}[htbp]" "\begin{table}[htbp] \setlength{\tabcolsep}{-1pt} " "Party=1" "Party") ///
	nonotes  nobaselevels  nogaps nomtitles ///
	addnote("OLS models with standard errors clustered at the cercle level. $^+ p<0.10$, $^{*} p<0.05$, $^{**} p<0.01$, $^{***} p<0.001$")		


	
************************
***APPENDIX TABLE A.3***
************************
	
* PANEL A: Show robustness of HHI results to dropping baseline level of dependent variable

global controls1 pop_dif pavedroads08 electricity08 proj_2008  
global controls2 pop_dif pavedroads_dif electricity_dif proj_dif

regress anderson4_dif seats_HHI_2009_dif, vce(cluster cercle_int)
estimates store model1
regress anderson4_dif seats_HHI_2009_dif PI_c2_seats_2009_dif, vce(cluster cercle_int)
estimates store model2
regress anderson4_dif seats_HHI_2009_dif PI_c2_seats_2009_dif $controls1, vce(cluster cercle_int)
estimates store model3
regress anderson4_dif seats_HHI_2009_dif PI_c2_seats_2009_dif $controls2, vce(cluster cercle_int)
estimates store model4
regress anderson4_dif c.seats_HHI_2009_dif##majseats09 PI_c2_seats_2009_dif $controls1, vce(cluster cercle_int)
estimates store model5
esttab model1 model2 model3 model4 model5 /// 
	using "../Tables/Anderson_HHI_dropinit.tex", star(+ 0.1 * 0.05 ** 0.01 *** 0.001) se b(3) se(3) r2(2) label booktabs alignment(D{.}{.}{-1}) replace ///
	stats(N,layout("\multicolumn{1}{c}{@}") labels("Observations") f(0))  ///
	title(Effect of Change in HHI (2004-2009) on Change in Public Goods Index (2008-2013) \label{tab:Anderson_HHI_dropinit})  ///
	varlabels (_cons Constant) ///
	sub("\begin{table}[htbp]" "\begin{table}[htbp] \setlength{\tabcolsep}{-1pt} " "Party=1" "Party") ///
	nonotes  nobaselevels  nogaps nomtitles ///
	addnote("OLS models with standard errors clustered at the cercle level. $^+ p<0.10$, $^{*} p<0.05$, $^{**} p<0.01$, $^{***} p<0.001$")


* PANEL B: Show robustness of vote margin results to dropping baseline level of dependent variable

global controls1 pop_dif pavedroads08 electricity08 proj_2008  
global controls2 pop_dif pavedroads_dif electricity_dif proj_dif

regress anderson4_dif seats_margin_2009_dif, vce(cluster cercle_int)
estimates store model1
regress anderson4_dif seats_margin_2009_dif PI_c2_seats_2009_dif, vce(cluster cercle_int)
estimates store model2
regress anderson4_dif seats_margin_2009_dif PI_c2_seats_2009_dif $controls1, vce(cluster cercle_int)
estimates store model3
regress anderson4_dif seats_margin_2009_dif PI_c2_seats_2009_dif $controls2, vce(cluster cercle_int)
estimates store model4
regress anderson4_dif c.seats_margin_2009_dif##majseats09 PI_c2_seats_2009_dif $controls1, vce(cluster cercle_int)
estimates store model5
esttab model1 model2 model3 model4 model5 /// 
	using "../Tables/Anderson_mv_dropinit.tex", star(+ 0.1 * 0.05 ** 0.01 *** 0.001) se b(3) se(3) r2(2) label booktabs alignment(D{.}{.}{-1}) replace ///
	stats(N,layout("\multicolumn{1}{c}{@}") labels("Observations") f(0))  ///
	title(Effect of Change in Margin of Victory (2004-2009) on Change in Public Goods Index (2008-2013) \label{tab:Anderson_mv_dropinit})  ///
	varlabels (_cons Constant) ///
	sub("\begin{table}[htbp]" "\begin{table}[htbp] \setlength{\tabcolsep}{-1pt} " "Party=1" "Party") ///
	nonotes  nobaselevels  nogaps nomtitles ///
	addnote("OLS models with standard errors clustered at the cercle level. $^+ p<0.10$, $^{*} p<0.05$, $^{**} p<0.01$, $^{***} p<0.001$")
	
	
			
************************
***APPENDIX TABLE A.7***
************************

gen seats_margin_2009_dif_n_maj= seats_margin_2009_dif_n * majseats09
label var seats_margin_2009_dif_n_maj "Majority Party $\times$ Difference in Margin $\times$ No. Parties"

label var seats_margin_2009_dif_n "Difference in Margin $\times$ No. Parties "

regress anderson4_dif seats_margin_2009_dif_n anderson4_2008, vce(cluster cercle_int)
estimates store model1
regress anderson4_dif seats_margin_2009_dif_n PI_c2_seats_2009_dif anderson4_2008, vce(cluster cercle_int)
estimates store model2
regress anderson4_dif seats_margin_2009_dif_n PI_c2_seats_2009_dif anderson4_2008 $controls1, vce(cluster cercle_int)
estimates store model3
regress anderson4_dif seats_margin_2009_dif_n PI_c2_seats_2009_dif anderson4_2008 $controls2, vce(cluster cercle_int)
estimates store model4
regress anderson4_dif seats_margin_2009_dif_n majseats09 seats_margin_2009_dif_n_maj PI_c2_seats_2009_dif $controls1 anderson4_2008, vce(cluster cercle_int)
estimates store model5
esttab model1 model2 model3 model4 model5 /// 
	using "../Tables/Anderson_mv_n.tex", star(+ 0.1 * 0.05 ** 0.01 *** 0.001) se b(3) se(3) r2(2) label booktabs alignment(D{.}{.}{-1}) replace ///
	stats(N,layout("\multicolumn{1}{c}{@}") labels("Observations") f(0))  ///
	title(Effect of Change in Margin of Victory Multiplied by Number of Parties Competing (2004-2009) on Change in Public Goods Index (2008-2013) \label{tab:Anderson_mv_n})  ///
	varlabels (_cons Constant) ///
	sub("\begin{table}[htbp]" "\begin{table}[htbp] \setlength{\tabcolsep}{-1pt} ") ///
	nonotes  nobaselevels  nogaps nomtitles ///
	addnote("OLS models with standard errors clustered at the cercle level. $^+ p<0.10$, $^{*} p<0.05$, $^{**} p<0.01$, $^{***} p<0.001$")


	
************************
***APPENDIX TABLE A.8***
************************

gen seatshare_sd_2009_dif = seatshare_sd_2009-seatshare_sd_2004
label var seatshare_sd_2009_dif "Difference in SD Seat Shares (2009-2004)" 	

gen seatshare_sd_2009_dif_maj= seatshare_sd_2009_dif * majseats09
label var seatshare_sd_2009_dif_maj "Majority Party $\times$ Difference in SD Seat Shares"

regress anderson4_dif seatshare_sd_2009_dif anderson4_2008, vce(cluster cercle_int)
estimates store model1
regress anderson4_dif seatshare_sd_2009_dif PI_c2_seats_2009_dif anderson4_2008, vce(cluster cercle_int)
estimates store model2
regress anderson4_dif seatshare_sd_2009_dif PI_c2_seats_2009_dif anderson4_2008 $controls1, vce(cluster cercle_int)
estimates store model3
regress anderson4_dif seatshare_sd_2009_dif PI_c2_seats_2009_dif anderson4_2008 $controls2, vce(cluster cercle_int)
estimates store model4
regress anderson4_dif seatshare_sd_2009_dif majseats09 seatshare_sd_2009_dif_maj PI_c2_seats_2009_dif anderson4_2008 $controls1, vce(cluster cercle_int)
estimates store model5
esttab model1 model2 model3 model4 model5 /// 
	using "../Tables/Anderson_sd_seatshare.tex", star(+ 0.1 * 0.05 ** 0.01 *** 0.001) se b(3) se(3) r2(2) label booktabs alignment(D{.}{.}{-1}) replace ///
	stats(N,layout("\multicolumn{1}{c}{@}") labels("Observations") f(0))  ///
	title(Effect of Change in Standard Deviation of Seat Shares (2004-2009) on Change in Public Goods Index (2008-2013) \label{tab:Anderson_sd_seatshare})  ///
	varlabels (_cons Constant) ///
	sub("\begin{table}[htbp]" "\begin{table}[htbp] \setlength{\tabcolsep}{-1pt} ") ///
	nonotes  nobaselevels  nogaps nomtitles ///
	addnote("OLS models with standard errors clustered at the cercle level. $^+ p<0.10$, $^{*} p<0.05$, $^{**} p<0.01$, $^{***} p<0.001$")


	
************************
***APPENDIX TABLE A.4***
************************

gen banzhaf_index_2009_dif = banzhaf_index_2009-banzhaf_index_2004
label var banzhaf_index_2009_dif "Difference in Banzhaf Index (2009-2004)" 	

gen banzhaf_index_2009_dif_maj=banzhaf_index_2009_dif * majseats09
label var banzhaf_index_2009_dif_maj "Majority Party $\times$ Difference in Banzhaf Index"

regress anderson4_dif banzhaf_index_2009_dif anderson4_2008, vce(cluster cercle_int)
estimates store model1
regress anderson4_dif banzhaf_index_2009_dif PI_c2_seats_2009_dif anderson4_2008, vce(cluster cercle_int)
estimates store model2
regress anderson4_dif banzhaf_index_2009_dif PI_c2_seats_2009_dif anderson4_2008 $controls1, vce(cluster cercle_int)
estimates store model3
regress anderson4_dif banzhaf_index_2009_dif PI_c2_seats_2009_dif anderson4_2008 $controls2, vce(cluster cercle_int)
estimates store model4
regress anderson4_dif banzhaf_index_2009_dif majseats09 banzhaf_index_2009_dif_maj PI_c2_seats_2009_dif anderson4_2008 $controls1, vce(cluster cercle_int)
estimates store model5
esttab model1 model2 model3 model4 model5 /// 
	using "../Tables/Anderson_banzhaf.tex", star(+ 0.1 * 0.05 ** 0.01 *** 0.001) se b(3) se(3) r2(2) label booktabs alignment(D{.}{.}{-1}) replace ///
	stats(N,layout("\multicolumn{1}{c}{@}") labels("Observations") f(0))  ///
	title(Effect of Change in Banzhaf Index (2004-2009) on Change in Public Goods Index (2008-2013) \label{tab:Anderson_banzhaf})  ///
	varlabels (_cons Constant) ///
	sub("\begin{table}[htbp]" "\begin{table}[htbp] \setlength{\tabcolsep}{-1pt} ") ///
	nonotes  nobaselevels  nogaps nomtitles ///
	addnote("OLS models with standard errors clustered at the cercle level. $^+ p<0.10$, $^{*} p<0.05$, $^{**} p<0.01$, $^{***} p<0.001$")


	
************************
***APPENDIX TABLE A.5***
************************

gen banzhaf_margin_2009_dif = banzhaf_margin_2009 - banzhaf_margin_2004
label var banzhaf_margin_2009_dif "Difference in Banzhaf Margin (2009-2004)"

gen banzhaf_margin_2009_dif_maj = banzhaf_margin_2009_dif * majseats09
label var banzhaf_margin_2009_dif_maj "Majority Party $\times$ Difference in Banzhaf Margin"

regress anderson4_dif banzhaf_margin_2009_dif anderson4_2008, vce(cluster cercle_int)
estimates store model1
regress anderson4_dif banzhaf_margin_2009_dif PI_c2_seats_2009_dif anderson4_2008, vce(cluster cercle_int)
estimates store model2
regress anderson4_dif banzhaf_margin_2009_dif PI_c2_seats_2009_dif anderson4_2008 $controls1, vce(cluster cercle_int)
estimates store model3
regress anderson4_dif banzhaf_margin_2009_dif PI_c2_seats_2009_dif anderson4_2008 $controls2, vce(cluster cercle_int)
estimates store model4
regress anderson4_dif banzhaf_margin_2009_dif majseats09 banzhaf_margin_2009_dif_maj PI_c2_seats_2009_dif anderson4_2008 $controls1, vce(cluster cercle_int)
estimates store model5
esttab model1 model2 model3 model4 model5 /// 
	using "../Tables/Anderson_mv_banzhaf.tex", star(+ 0.1 * 0.05 ** 0.01 *** 0.001) se b(3) se(3) r2(2) label booktabs alignment(D{.}{.}{-1}) replace ///
	stats(N,layout("\multicolumn{1}{c}{@}") labels("Observations") f(0))  ///
	title(Effect of Change in Margin of Banzhaf Scores of Top Two Parties (2004-2009) on Change in Public Goods Index (2008-2013) \label{tab:Anderson_mv_banzhaf})  ///
	varlabels (_cons Constant) ///
	sub("\begin{table}[htbp]" "\begin{table}[htbp] \setlength{\tabcolsep}{-1pt} ") ///
	nonotes  nobaselevels  nogaps nomtitles ///
	addnote("OLS models with standard errors clustered at the cercle level. $^+ p<0.10$, $^{*} p<0.05$, $^{**} p<0.01$, $^{***} p<0.001$")

	
	
************************
***APPENDIX TABLE A.6***
************************

gen banzhaf_sd_2009_dif = banzhaf_sd_2009 - banzhaf_sd_2004
label var banzhaf_sd_2009_dif "Difference in Banzhaf SD (2009-2004)" 	

gen banzhaf_sd_2009_dif_maj= banzhaf_sd_2009_dif * majseats09
label var banzhaf_sd_2009_dif_maj "Majority Party $\times$ Difference in Banzhaf SD"

regress anderson4_dif banzhaf_sd_2009_dif anderson4_2008, vce(cluster cercle_int)
estimates store model1
regress anderson4_dif banzhaf_sd_2009_dif PI_c2_seats_2009_dif anderson4_2008, vce(cluster cercle_int)
estimates store model2
regress anderson4_dif banzhaf_sd_2009_dif PI_c2_seats_2009_dif anderson4_2008 $controls1, vce(cluster cercle_int)
estimates store model3
regress anderson4_dif banzhaf_sd_2009_dif PI_c2_seats_2009_dif anderson4_2008 $controls2, vce(cluster cercle_int)
estimates store model4
regress anderson4_dif banzhaf_sd_2009_dif majseats09 banzhaf_sd_2009_dif_maj PI_c2_seats_2009_dif anderson4_2008 $controls1, vce(cluster cercle_int)
estimates store model5
esttab model1 model2 model3 model4 model5 /// 
	using "../Tables/Anderson_sd_banzhaf.tex", star(+ 0.1 * 0.05 ** 0.01 *** 0.001) se b(3) se(3) r2(2) label booktabs alignment(D{.}{.}{-1}) replace ///
	stats(N,layout("\multicolumn{1}{c}{@}") labels("Observations") f(0))  ///
	title(Effect of Change in Standard Deviation of Banzhaf Index (2004-2009) on Change in Public Goods Index (2008-2013) \label{tab:Anderson_sd_banzhaf})  ///
	varlabels (_cons Constant) ///
	sub("\begin{table}[htbp]" "\begin{table}[htbp] \setlength{\tabcolsep}{-1pt} ") ///
	nonotes  nobaselevels  nogaps nomtitles ///
	addnote("OLS models with standard errors clustered at the cercle level. $^+ p<0.10$, $^{*} p<0.05$, $^{**} p<0.01$, $^{***} p<0.001$")

	
	
************************
***APPENDIX TABLE A.9***
************************

*Note: missing values replaced with cercle median

* PANEL A: HHI

global controls1 pop_dif pavedroads08 electricity08 proj_2008  
global controls2 pop_dif pavedroads_dif electricity_dif proj_dif

gen seats_HHI_2009_dif_maj= seats_HHI_2009_dif * majseats09
label var seats_HHI_2009_dif_maj "Majority Party $\times$ Difference in HHI"

regress PCA4_dif_nm seats_HHI_2009_dif PCA4_2008_nm, vce(cluster cercle_int)
estimates store model1
regress PCA4_dif_nm seats_HHI_2009_dif PI_c2_seats_2009_dif PCA4_2008_nm, vce(cluster cercle_int)
estimates store model2
regress PCA4_dif_nm seats_HHI_2009_dif PI_c2_seats_2009_dif PCA4_2008_nm $controls1, vce(cluster cercle_int)
estimates store model3
regress PCA4_dif_nm seats_HHI_2009_dif PI_c2_seats_2009_dif PCA4_2008_nm $controls2, vce(cluster cercle_int)
estimates store model4
regress PCA4_dif_nm seats_HHI_2009_dif majseats09 seats_HHI_2009_dif_maj PI_c2_seats_2009_dif PCA4_2008_nm $controls1, vce(cluster cercle_int)
estimates store model5
esttab model1 model2 model3 model4 model5 /// 
	using "../Tables/PCA_nm_HHI.tex", star(+ 0.1 * 0.05 ** 0.01 *** 0.001) se b(3) se(3) r2(2) label booktabs alignment(D{.}{.}{-1}) replace ///
	stats(N,layout("\multicolumn{1}{c}{@}") labels("Observations") f(0))  ///
	title(Effect of Change in HHI (2004-2009) on Change in Public Goods Index, PCA (2008-2013) \label{tab:PCA_nm_HHI})  ///
	varlabels (_cons Constant) ///
	sub("\begin{table}[htbp]" "\begin{table}[htbp] \setlength{\tabcolsep}{-1pt} ") ///
	nonotes  nobaselevels  nogaps nomtitles ///
	addnote("OLS models with standard errors clustered at the cercle level. $^+ p<0.10$, $^{*} p<0.05$, $^{**} p<0.01$, $^{***} p<0.001$")

	
* PANEL B: Margin of victory

gen seats_margin_2009_dif_maj= seats_margin_2009_dif * majseats09
label var seats_margin_2009_dif_maj "Majority Party $\times$ Difference in Margin"

regress PCA4_dif_nm seats_margin_2009_dif PCA4_2008_nm, vce(cluster cercle_int)
estimates store model1
regress PCA4_dif_nm seats_margin_2009_dif PI_c2_seats_2009_dif PCA4_2008_nm, vce(cluster cercle_int)
estimates store model2
regress PCA4_dif_nm seats_margin_2009_dif PI_c2_seats_2009_dif PCA4_2008_nm $controls1, vce(cluster cercle_int)
estimates store model3
regress PCA4_dif_nm seats_margin_2009_dif PI_c2_seats_2009_dif PCA4_2008_nm $controls2, vce(cluster cercle_int)
estimates store model4
regress PCA4_dif_nm seats_margin_2009_dif majseats09 seats_margin_2009_dif_maj PI_c2_seats_2009_dif PCA4_2008_nm $controls1, vce(cluster cercle_int)
estimates store model5
esttab model1 model2 model3 model4 model5 /// 
	using "../Tables/PCA_nm_mv.tex", star(+ 0.1 * 0.05 ** 0.01 *** 0.001) se b(3) se(3) r2(2) label booktabs alignment(D{.}{.}{-1}) replace ///
	stats(N,layout("\multicolumn{1}{c}{@}") labels("Observations") f(0))  ///
	title(Effect of Change in Margin of Victory (2004-2009) on Change in Public Goods Index, PCA (2008-2013) \label{tab:PCA_nm_mv})  ///
	varlabels (_cons Constant) ///
	sub("\begin{table}[htbp]" "\begin{table}[htbp] \setlength{\tabcolsep}{-1pt} ") ///
	nonotes  nobaselevels  nogaps nomtitles ///
	addnote("OLS models with standard errors clustered at the cercle level. $^+ p<0.10$, $^{*} p<0.05$, $^{**} p<0.01$, $^{***} p<0.001$")

	
		
*************************
***APPENDIX TABLE A.10***
*************************

* PANEL A: Placebo test, paved roads, using HHI

global controls pop_dif

regress pavedroads_dif seats_HHI_2009_dif pavedroads08, vce(cluster cercle_int)
estimates store model1
regress pavedroads_dif seats_HHI_2009_dif PI_c2_seats_2009_dif pavedroads08, vce(cluster cercle_int)
estimates store model2
regress pavedroads_dif seats_HHI_2009_dif PI_c2_seats_2009_dif pavedroads08 $controls, vce(cluster cercle_int)
estimates store model3
regress pavedroads_dif seats_HHI_2009_dif majseats09 seats_HHI_2009_dif_maj PI_c2_seats_2009_dif pavedroads08 $controls, vce(cluster cercle_int)
estimates store model4
esttab model1 model2 model3 model4 /// 
	using "../Tables/placebo_pavedroads_HHI.tex", star(+ 0.1 * 0.05 ** 0.01 *** 0.001) se b(3) se(3) r2(2) label booktabs alignment(D{.}{.}{-1}) replace ///
	stats(N,layout("\multicolumn{1}{c}{@}") labels("Observations") f(0))  ///
	title(Placebo Test: Effect of Change in HHI (2004-2009) on Change in Kilometers of Paved Roads in (2008-2013) \label{tab:placebo_pavedroads_HHI})  ///
	varlabels (_cons Constant) ///
	sub("\begin{table}[htbp]" "\begin{table}[htbp] \setlength{\tabcolsep}{-1pt} ") ///
	nonotes  nobaselevels  nogaps nomtitles ///
	addnote("OLS models with standard errors clustered at the cercle level. $^+ p<0.10$, $^{*} p<0.05$, $^{**} p<0.01$, $^{***} p<0.001$")

	
* PANEL B: Placebo test, paved roads, using margin of victory

regress pavedroads_dif seats_margin_2009_dif pavedroads08, vce(cluster cercle_int)
estimates store model1
regress pavedroads_dif seats_margin_2009_dif PI_c2_seats_2009_dif pavedroads08, vce(cluster cercle_int)
estimates store model2
regress pavedroads_dif seats_margin_2009_dif PI_c2_seats_2009_dif pavedroads08 $controls, vce(cluster cercle_int)
estimates store model3
regress pavedroads_dif seats_margin_2009_dif majseats09 seats_margin_2009_dif_maj PI_c2_seats_2009_dif pavedroads08 $controls, vce(cluster cercle_int)
estimates store model4
esttab model1 model2 model3 model4 /// 
	using "../Tables/placebo_pavedroads_mv.tex", star(+ 0.1 * 0.05 ** 0.01 *** 0.001) se b(3) se(3) r2(2) label booktabs alignment(D{.}{.}{-1}) replace ///
	stats(N,layout("\multicolumn{1}{c}{@}") labels("Observations") f(0))  ///
	title(Placebo Test: Effect of Change in Margin of Victory (2004-2009) on Change in Kilometers of Paved Roads in (2008-2013) \label{tab:placebo_pavedroads_mv})  ///
	varlabels (_cons Constant) ///
	sub("\begin{table}[htbp]" "\begin{table}[htbp] \setlength{\tabcolsep}{-1pt} ") ///
	nonotes  nobaselevels  nogaps nomtitles ///
	addnote("OLS models with standard errors clustered at the cercle level. $^+ p<0.10$, $^{*} p<0.05$, $^{**} p<0.01$, $^{***} p<0.001$")
	
	
* PANEL C: Placebo test, national electricity, using HHI

regress electricity_dif seats_HHI_2009_dif electricity08, vce(cluster cercle_int)
estimates store model1
regress electricity_dif seats_HHI_2009_dif PI_c2_seats_2009_dif electricity08, vce(cluster cercle_int)
estimates store model2
regress electricity_dif seats_HHI_2009_dif PI_c2_seats_2009_dif electricity08 $controls, vce(cluster cercle_int)
estimates store model3
regress electricity_dif seats_HHI_2009_dif majseats09 seats_HHI_2009_dif_maj PI_c2_seats_2009_dif electricity08 $controls, vce(cluster cercle_int)
estimates store model4
esttab model1 model2 model3 model4 /// 
	using "../Tables/placebo_electricity_HHI.tex", star(+ 0.1 * 0.05 ** 0.01 *** 0.001) se b(3) se(3) r2(2) label booktabs alignment(D{.}{.}{-1}) replace ///
	stats(N,layout("\multicolumn{1}{c}{@}") labels("Observations") f(0))  ///
	title(Placebo Test: Effect of Change in HHI (2004-2009) on Change in Number of Sources of National Electricity in (2008-2013) \label{tab:placebo_electricity_HHI})  ///
	varlabels (_cons Constant) ///
	sub("\begin{table}[htbp]" "\begin{table}[htbp] \setlength{\tabcolsep}{-1pt} ") ///
	nonotes  nobaselevels  nogaps nomtitles ///
	addnote("OLS models with standard errors clustered at the cercle level. $^+ p<0.10$, $^{*} p<0.05$, $^{**} p<0.01$, $^{***} p<0.001$")

	
* PANEL D: Placebo test, national electricity, using margin of victory

regress electricity_dif seats_margin_2009_dif electricity08, vce(cluster cercle_int)
estimates store model1
regress electricity_dif seats_margin_2009_dif PI_c2_seats_2009_dif electricity08, vce(cluster cercle_int)
estimates store model2
regress electricity_dif seats_margin_2009_dif PI_c2_seats_2009_dif electricity08 $controls, vce(cluster cercle_int)
estimates store model3
regress electricity_dif seats_margin_2009_dif majseats09 seats_margin_2009_dif_maj PI_c2_seats_2009_dif electricity08 $controls, vce(cluster cercle_int)
estimates store model4
esttab model1 model2 model3 model4 /// 
	using "../Tables/placebo_electricity_mv.tex", star(+ 0.1 * 0.05 ** 0.01 *** 0.001) se b(3) se(3) r2(2) label booktabs alignment(D{.}{.}{-1}) replace ///
	stats(N,layout("\multicolumn{1}{c}{@}") labels("Observations") f(0))  ///
	title(Placebo Test: Effect of Change in Margin of Victory (2004-2009) on Change in Number of Sources of National Electricity in (2008-2013) \label{tab:placebo_electricity_mv})  ///
	varlabels (_cons Constant) ///
	sub("\begin{table}[htbp]" "\begin{table}[htbp] \setlength{\tabcolsep}{-1pt} ") ///
	nonotes  nobaselevels  nogaps nomtitles ///
	addnote("OLS models with standard errors clustered at the cercle level. $^+ p<0.10$, $^{*} p<0.05$, $^{**} p<0.01$, $^{***} p<0.001$")

	
	

*************************
***APPENDIX TABLE A.11***
*************************	
	
* Robustness check for pre-trends, HHI, use of data from an earlier period (only 2 goods - boreholes and clinics)

global controls1 pop_dif pavedroads08 electricity08 proj_2008  
global controls2 pop_dif pavedroads_dif electricity_dif proj_dif

regress anderson2_0306 seats_HHI_2009_dif anderson4_2008, vce(cluster cercle_int)
estimates store model1
regress anderson2_0306 seats_HHI_2009_dif PI_c2_seats_2009_dif anderson4_2008, vce(cluster cercle_int)
estimates store model2
regress anderson2_0306 seats_HHI_2009_dif PI_c2_seats_2009_dif $controls1 anderson4_2008, vce(cluster cercle_int)
estimates store model3
regress anderson2_0306 seats_HHI_2009_dif PI_c2_seats_2009_dif $controls2 anderson4_2008, vce(cluster cercle_int)
estimates store model4
regress anderson2_0306 c.seats_HHI_2009_dif##majseats09 PI_c2_seats_2009_dif $controls1 anderson4_2008, vce(cluster cercle_int)
estimates store model5
esttab model1 model2 model3 model4 model5 /// 
	using "../Tables/Anderson_falsification_HHI.tex", star(+ 0.1 * 0.05 ** 0.01 *** 0.001) se b(3) se(3) r2(2) label booktabs alignment(D{.}{.}{-1}) replace ///
	stats(N,layout("\multicolumn{1}{c}{@}") labels("Observations") f(0))  ///
	title(Effect of Change in HHI (2004-2009) on Change in Public Goods Index (2003-2006)  \label{tab:Anderson_falsification_HHI})  ///
	varlabels (_cons Constant) ///
	sub("\begin{table}[htbp]" "\begin{table}[htbp] \setlength{\tabcolsep}{-1pt} " "Party=1" "Party") ///
	nonotes  nobaselevels  nogaps nomtitles ///
	addnote("OLS models with standard errors clustered at the cercle level. $^+ p<0.10$, $^{*} p<0.05$, $^{**} p<0.01$, $^{***} p<0.001$")


*************************
***APPENDIX TABLE A.12***
*************************	
	
* Robustness check for pre-trends, margin of victory, use of data from an earlier period (only 2 goods - boreholes and clinics)

global controls1 pop_dif pavedroads08 electricity08 proj_2008  
global controls2 pop_dif pavedroads_dif electricity_dif proj_dif

regress anderson2_0306 seats_margin_2009_dif anderson4_2008, vce(cluster cercle_int)
estimates store model1
regress anderson2_0306 seats_margin_2009_dif PI_c2_seats_2009_dif anderson4_2008, vce(cluster cercle_int)
estimates store model2
regress anderson2_0306 seats_margin_2009_dif PI_c2_seats_2009_dif $controls1 anderson4_2008, vce(cluster cercle_int)
estimates store model3
regress anderson2_0306 seats_margin_2009_dif PI_c2_seats_2009_dif $controls2 anderson4_2008, vce(cluster cercle_int)
estimates store model4
regress anderson2_0306 c.seats_margin_2009_dif##majseats09 PI_c2_seats_2009_dif $controls1 anderson4_2008, vce(cluster cercle_int)
estimates store model5
esttab model1 model2 model3 model4 model5 /// 
	using "../Tables/Anderson_falsification_mv.tex", star(+ 0.1 * 0.05 ** 0.01 *** 0.001) se b(3) se(3) r2(2) label booktabs alignment(D{.}{.}{-1}) replace ///
	stats(N,layout("\multicolumn{1}{c}{@}") labels("Observations") f(0))  ///
	title(Effect of Change in Margin of Victory (2004-2009) on Change in Public Goods Index (2003-2006)  \label{tab:Anderson_falsification_mv})  ///
	varlabels (_cons Constant) ///
	sub("\begin{table}[htbp]" "\begin{table}[htbp] \setlength{\tabcolsep}{-1pt} " "Party=1" "Party") ///
	nonotes  nobaselevels  nogaps nomtitles ///
	addnote("OLS models with standard errors clustered at the cercle level. $^+ p<0.10$, $^{*} p<0.05$, $^{**} p<0.01$, $^{***} p<0.001$")
	
	
	
**********************************************
***APPENDIX TABLEs A.15 - A.17 and FIGURE 4***
**********************************************	

* Effects of public goods expenditure on public goods production with population and initial period value controls and only including cases of non-0 tranfers 

*Coding up, normalizing, and labeling variables

foreach var in school clinic boreh {
cap generate `var'_dif2008 = `var'_2008 - `var'_2006
}
label var school_dif2008 "Schools Built (2006-08)"
label var clinic_dif2008 "Clinics Built (2006-08)"
label var boreh_dif2008 "Boreholes Built (2006-08)"

label var transfer_school_total "School Expenditures (2006-08)"
label var transfer_clinic_total "Clinic Expenditures (2006-08)"
rename transfer_water_total transfer_boreh_total
label var transfer_boreh_total "Borehole Expenditures (2006-08)"

label var school_2006 "Schools in 2006"
label var clinic_2006 "Clinics in 2006"
label var boreh_2006 "Boreholes in 2006"

*Rescale total transfers variable for two main ones (schools and boreh)
foreach var in school boreh {
replace transfer_`var'_total = transfer_`var'_total/1000000
}

foreach var in school {
replace transfer_`var'2006 = transfer_`var'2006/1000000
replace transfer_`var'2008 = transfer_`var'2008/1000000
gen transfer_`var'_dif=transfer_`var'2008-transfer_`var'2006
}

label var transfer_school2006 "School Expenditures (2006)"
label var transfer_school2008 "School Expenditures (2008)"
label var transfer_school_dif "School Expenditures (2008-2006)"
 
label var seats_margin_2004_dif "Diff in Margin (2004-1999)"
label var seats_HHI_2004_dif "Diff in HHI (2004-1999)"
label var seats_margin_2004 "Margin (2004)"
label var seats_HHI_2004 "HHI (2004)"
label var seatshare_sd_2004 "SD seat shares (2004)"
label var log1998pop "Logged Population (1998)"

capture tab cercle_int, gen(cercleFE)

sum school_dif2008
sum clinic_dif2008
sum boreh_dif2008

regress school_dif2008 transfer_school_total log1998pop cercleFE* if transfer_school_total!=0, vce(cluster cercle_int)
count if e(sample)==1
regress clinic_dif2008 transfer_clinic_total log1998pop cercleFE* if transfer_clinic_total!=0, vce(cluster cercle_int)
count if e(sample)==1
regress boreh_dif2008 transfer_boreh_total log1998pop cercleFE* if transfer_boreh_total!=0, vce(cluster cercle_int)
count if e(sample)==1

foreach var in school clinic boreh {
regress `var'_dif2008 transfer_`var'_total log1998pop cercleFE* if transfer_`var'_total!=0, vce(cluster cercle_int)
count if e(sample)==1
su `var'_dif2008 if e(sample)==1
local `var'_dif2008_mean = `r(mean)'
local `var'_dif2008_SD = `r(sd)'
gen `var'_dif2008_norm=(`var'_dif2008-``var'_dif2008_mean')/``var'_dif2008_SD'
sum `var'_dif2008_norm if e(sample)==1
*Above confirms it's a N(0,1) variable now for the sample that matters (i.e. the sample size shown in the Tables).
}

preserve

foreach var in school clinic boreh {
replace `var'_dif2008 = `var'_dif2008_norm
}
replace transfer_clinic_total = transfer_clinic_total/1000000

*Tables A.15-A.17 

set more off
foreach var in school clinic boreh {
eststo clear
local vtext1 : variable label `var'_dif2008 
local vtext2 : variable label transfer_`var'_total 
su seats_HHI_2004 if transfer_`var'_total!=0, d
local HHI_d_median = `r(p50)' 
su seats_margin_2004 if transfer_`var'_total!=0, d
local margin_d_median = `r(p50)'
regress `var'_dif2008 c.transfer_`var'_total##c.seats_HHI_2004 log1998pop regionFE* if transfer_`var'_total!=0 & majseats09==0, vce(cluster cercle_int)
estimates store m1
regress `var'_dif2008 c.transfer_`var'_total##c.seats_HHI_2004 log1998pop regionFE* if transfer_`var'_total!=0 & majseats09==1, vce(cluster cercle_int)
estimates store m2
regress `var'_dif2008 c.transfer_`var'_total##c.seats_HHI_2004 log1998pop regionFE* if transfer_`var'_total!=0, vce(cluster cercle_int)
estimates store m3
regress `var'_dif2008 c.transfer_`var'_total##c.seats_margin_2004 log1998pop regionFE* if transfer_`var'_total!=0 & majseats09==0, vce(cluster cercle_int)
estimates store m4
regress `var'_dif2008 c.transfer_`var'_total##c.seats_margin_2004 log1998pop regionFE* if transfer_`var'_total!=0 & majseats09==1, vce(cluster cercle_int)
estimates store m5
regress `var'_dif2008 c.transfer_`var'_total##c.seats_margin_2004 log1998pop regionFE* if transfer_`var'_total!=0, vce(cluster cercle_int)
estimates store m6
esttab m3 m1 m2 m6 m4 m5 ///  
	using "../Tables/`var'_transfer_level_cFE_noinitial_novolat.tex", star(+ 0.1 * 0.05 ** 0.01 *** 0.001) se b(3) se(3) r2(2) label booktabs alignment(D{.}{.}{-1}) replace ///
	stats(N,layout("\multicolumn{1}{c}{@}") labels("Observations") f(0))  ///
	title(Effect of `"`vtext2'"' on `"`vtext1'"' By Level of Political Competition \label{tab:`var'_transfer_level_cFE_noinitial_novolat})  ///
	mtitles("Full Sample" "No majority" "Majority" "Full Sample" "No majority" "Majority") ///
	varlabels (_cons Constant) ///
	drop(regionFE*) ///	
	sub("\begin{table}[htbp]" "\begin{table}[htbp] \setlength{\tabcolsep}{0pt} \small") ///
	nonotes  nobaselevels  nogaps nonumbers ///
	addnote("OLS models with region fixed effects and standard errors clustered at the cercle level. $^+ p<0.10$, $^{*} p<0.05$, $^{**} p<0.01$, $^{***} p<0.001$")

*Figure 4
	
estimates restore m3
su seats_HHI_2004 if e(sample), d
local HHI_min = `r(min)' 
local HHI_max = `r(max)'
margins, dydx(transfer_`var'_total) at(seats_HHI_2004=(`HHI_min'(.2)`HHI_max')) atmeans
marginsplot, ///
	title ("") ytitle("Effects on Linear Prediction with 95% CI's") xtitle("Level of HHI (2004)") ///
	plotopts(mcolor(black) lcolor(black) ) ci1opts(lcolor(black) msiz(0)) yline(0, lcolor(red))  ///
	graphregion(fcolor(white) ilcolor(white) lcolor(white)) xlabel(, format(%9.2f)) ///
	addplot(hist seats_HHI_2004 if seats_HHI_2004>=`HHI_min' & seats_HHI_2004<=`HHI_max', freq bcolor(gs16)  blcolor(black) yaxis(2) yscale(alt axis(2) range(0 400)) ylabel(0(50)100, axis(2) ) below legend(off)) 
	graph export "../Figures/HHI_`var'_level_cFE_noinitial_novolat.pdf", replace
	
estimates restore m6
su seats_margin_2004 if e(sample), d
local margin_min = `r(min)'
local margin_max = `r(max)'
margins, dydx(transfer_`var'_total) at(seats_margin_2004=(`margin_min'(.2)`margin_max')) atmeans
marginsplot, ///
	title("") ytitle("Effects on Linear Prediction with 95% CI's") xtitle("Level of Margin of Victory (2004)") ///
	plotopts(mcolor(black) lcolor(black) ) ci1opts(lcolor(black) msiz(0)) yline(0, lcolor(red))    ///
	graphregion(fcolor(white) ilcolor(white) lcolor(white)) xlabel(, format(%9.2f)) ///
	addplot(hist seats_margin_2004 if seats_margin_2004>=`margin_min' & seats_margin_2004<=`margin_max', freq bcolor(gs16) blcolor(black) yaxis(2) yscale(alt axis(2) range(0 500)) below legend(off)) 
	graph export "../Figures/margin_`var'_level_cFE_noinitial_novolat.pdf", replace
}
restore

*Use interflex command to test whether a non-linear interaction model is superior
interflex school_dif2008_norm transfer_school_total seats_HHI_2004 log1998pop cercleFE* if transfer_school_total!=0, cluster(cercle_int)
*p value of Wald is .22
interflex school_dif2008_norm transfer_school_total seats_margin_2004 log1998pop cercleFE* if transfer_school_total!=0, cluster(cercle_int)
*p value of Wald is .33
interflex clinic_dif2008_norm transfer_clinic_total seats_HHI_2004 log1998pop cercleFE* if transfer_clinic_total!=0, cluster(cercle_int)
*p value of Wald is .66
interflex clinic_dif2008_norm transfer_clinic_total seats_margin_2004 log1998pop cercleFE* if transfer_clinic_total!=0, cluster(cercle_int)
*p value of Wald is .09
interflex boreh_dif2008_norm transfer_boreh_total seats_HHI_2004 log1998pop cercleFE* if transfer_boreh_total!=0, cluster(cercle_int)
*p value of Wald is .02
interflex boreh_dif2008_norm transfer_boreh_total seats_margin_2004 log1998pop cercleFE* if transfer_boreh_total!=0, cluster(cercle_int)
*p value of Wald is .00

/*
**************************************
***BACKGROUND FOR VARIABLE CREATION***
**************************************

****ADDITIONAL VARIABLE CONSTRUCTION FOR ANALYSIS

gen		log1998pop = ln(pop1998)
lab var log1998pop "ln(pop 1998)"
gen		log2009pop = ln(pop2009)
lab var log2009pop "ln(pop 2009)"
gen		pop_dif = ln(pop2009)	-	ln(pop1998)
lab var pop_dif  "ln(pop2009)	-	ln(pop1998)"

** Variable construction for alternative PCA indices

pca 	school_2008 clinic_2008 boreh_2008 road_2008, components(1)
predict PCA4_2008_check , score
lab var PCA4_2008_check "Public Goods Index, PCA, 2008 (4 items)"

pca 	school_2013 clinic_2013 boreh_2013 road_2013, components(1)
predict PCA4_2013_check , score
lab var PCA4_2013_check "Public Goods Index, PCA, 2013 (4 items)"

gen		PCA4_dif_check =PCA4_2013_check	-	PCA4_2008_check
lab var PCA4_dif_check "Change in Public Goods Index, PCA, 2008-2013 (4 items)"

*Compute PCA that is always non-missing by replacing missing values of the four individual components (schools, clinics, boreholes, and roads) with their cercle medians

*Below replaces missing values with the cercle median in a new variant of each infrastructure variable, with suffix _nm (never missing)
foreach x in school_2008 school_2013 clinic_2008 clinic_2013 boreh_2008 boreh_2013 road_2008 road_2013 {
sort cercle_int
by cercle_int: egen `x'_cm=median(`x') 
gen `x'_nm=`x'
replace `x'_nm=`x'_cm if `x'_nm==. 
drop `x'_cm
label var `x'_nm "`x' (replaced with cercle-level median if `x' is missing)"
}

*Below computes the never-missing PCA (for each year, and the difference in the two PCAs)
pca 	school_2008_nm clinic_2008_nm boreh_2008_nm road_2008_nm, components(1)
predict PCA4_2008_nm , score
lab var PCA4_2008_nm "Public Goods Index, PCA, 2008 (4 items)"
note PCA4_2008_nm: Variable is always non-missing (replacements with cercle median)

pca 	school_2013_nm clinic_2013_nm boreh_2013_nm road_2013_nm, components(1)
predict PCA4_2013_nm , score
lab var PCA4_2013_nm "Public Goods Index, PCA, 2013 (4 items)"
note PCA4_2013_nm: Variable is always non-missing (replacements with cercle median)

gen		PCA4_dif_nm =PCA4_2013_nm	-	PCA4_2008_nm
lab var PCA4_dif_nm "Change in Public Goods Index, PCA, 2008-2013 (4 items)"
note PCA4_dif_nm: Variable is always non-missing (replacements with cercle median)

**Construct interactions of development variables (levels and differences, electricity and paved roads) with political competition measures

foreach x in pavedroads08 electricity08 pavedroads_dif electricity_dif {
gen HHI_`x'= seats_HHI_2009_dif*`x'
label var HHI_`x' "Change in HHI * `x'"
gen margin_`x'= seats_margin_2009_dif*`x' 
label var margin_`x' "Change in vote margin * `x'"
}

**Construct PCA indices using both paved roads and electricity (try both levels and differences)

pca 	pavedroads08 electricity08, components(1)
predict developindex08 , score
lab var developindex08 "Development Index, 2008"

pca 	pavedroads_dif electricity_dif, components(1)
predict developindex_dif , score
lab var developindex_dif "Growth in Development Index (2013-2008)"

**Construction interactions of development indices (and dummy for above-median development in 2008) with political competition measures and other controls

foreach x in developindex08 developindex_dif {
gen HHI_`x'= seats_HHI_2009_dif*`x'
label var HHI_`x' "Change in HHI * `x'"
gen margin_`x'= seats_margin_2009_dif*`x' 
label var margin_`x' "Change in vote margin * `x'"

gen PI_`x'= PI_c2_seats_2009_dif*`x'
label var PI_`x' "Change in Pederson Index * `x'"
gen AI08_`x'= anderson4_2008*`x' 
label var AI08_`x' "Change in 2008 Anderson Index * `x'"
gen pop_dif_`x'= pop_dif*`x' 
label var pop_dif_`x' "Change in Population Difference * `x'"  
}

***Create a few variables

gen lnPOP2006=ln(POP2006)
label var lnPOP2006 "Logged Population (2006)"

gen proj_dif=proj_2013-proj_2008
label var proj_dif "Change in NGO/Dev. Projects (2008-2013)"
label var proj_2008 "NGO/Development Projects 2008"
label var proj_2013 "NGO/Development Projects 2013"

*Create variable normalizing margin variable by # parties
gen seats_margin_2009_dif_n=(seats_margin_2009*nparties2009)-(seats_margin_2004*nparties2004)
label var seats_margin_2009_dif_n "Difference in Concentration, Margin (2009-2004)"

***Create interactions with majority party dummy

generate maj_HHIdif=majseats09*seats_HHI_2009_dif
label var maj_HHIdif "Difference in Concentration, HHI $\times$ Majority Party"

generate maj_margindif=majseats09*seats_margin_2009_dif
label var maj_margindif "Difference in Concentration, Margin $\times$ Majority Party"

generate maj_volatilitydif=majseats09*PI_c2_seats_2009_dif
label var maj_volatilitydif "Difference in Volatility $\times$ Majority Party"

generate maj_anderson08=majseats09*anderson4_2008
label var maj_anderson08 "Public Goods Index 2008 $\times$ Majority Party"

generate maj_popdif=majseats09*pop_dif
label var maj_popdif "Difference in Logged Population $\times$ Majority Party"

generate maj_pavedroads08=majseats09*pavedroads08
label var maj_pavedroads08 "Kilometers Paved Roads 2008 $\times$ Majority Party"

generate maj_electricity08=majseats09*electricity08
label var maj_electricity08 "Sources of Electricity 2008 $\times$ Majority Party"

generate geodensity=a2/a9
generate popdensity=POP2006/a9
gen lnpop98=ln(1+pop1998)

* Create indices using 2003 data

do "..\genindex.do"

genindex boreh_2003 health_2003, nv(anderson2_2003)
rename anderson2_2003A anderson2_2003

genindex boreh_2006 clinic_2006, nv(anderson2_06)
rename anderson2_06A anderson2_06

label var anderson2_2003 "Public Goods Index (2003)"

gen anderson2_0306=anderson2_06 - anderson2_2003
label var anderson2_0306 "Difference in public goods index (2003-2006)"

gen boreh_0306=boreh_2006 - boreh_2003
label var boreh_0306 "Difference in number of boreholes (2003-2006)"

gen clinic_0306=clinic_2006 - clinic_2003
label var clinic_0306 "Difference in number of clinics (2003-2006)"*/

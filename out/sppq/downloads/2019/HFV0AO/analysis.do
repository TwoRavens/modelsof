************************************************************************************
******** 	Replication files for Bromley, Holman, and Sandoval 	****************
******** 	Hot districts, cool legislation 						****************
********	State politics and policy quarterly						****************
************************************************************************************


clear 
set more off 

**Install estout package (requieres Stata 8.2 or newer)

ssc install estout, replace

*** Set working directory to folder with files **** 

use "hot districts replication data.dta"

eststo clear 

*** Variable set-up - we are setting up the global variable set for all the analyses ****
*** See the codebook for a description of each of these variables *** 

global district_controls z_p_urban_percentage_2010 z_obama12 z_hhd_income_median_2011_15 z_resource_depend z_p_total_2010
global chamber_controls distance partycontrol
global state_controls z_worried_st z_sierra2012  z_elazar z_professionalism 
global state_controls2 z_worried_st z_sierra2012  z_elazar z_professionalism z_state_policies2010 
global climate_controls z_pdsi z_phdi z_pcp z_extreme_events z_wildfire
global industries_controls z_p_urban_percentage_2010 z_obama12 z_hhd_income_median_2011_15 z_p_total_2010 z_agriculture_2015 z_minning_2015 z_logging_2015


**** Table 1 describes the variables and contains no statistical information **** 		

eststo clear 

***** Results to produce table 2 and figures 2 and 3 ***** 

**** Table 2 column 1: all legislators ****
eststo pro: melogit pro_climate2 democrat independent  anom_counthot  anom_countcold i.time ///
	$district_controls $chamber_controls $state_controls2 senate ///
	|| st_fips:, intpoints(30) difficult
estat ic
eststo marginspro: margins, dydx(*) post


*** Table 2 column 2: Only democrat subset
eststo pro_dem: melogit pro_climate2  anom_counthot anom_countcold i.time ///
	 $district_controls $chamber_controls $state_controls2 senate  ///
	 if democrat == 1 ///
	 || st_fips:, intpoints(30) difficult
estat ic
eststo marginspro_dem: margins, dydx(*) post


*** Table 2 column 3: Republican legislators subset only
eststo pro_rep: melogit pro_climate2 anom_counthot anom_countcold i.time ///
	  $district_controls $chamber_controls $state_controls2 senate ///  
	  if republican == 1 ///
	  || st_fips:, intpoints(30) difficult
estat ic
eststo marginspro_rep:  margins, dydx(*) post


	  
 *********************Generate figures: 2 & 3 ************************************
 
 ***** Figure 2 *****
 
 coefplot (marginspro, label (Pro climate change)) ///
	||, drop(_cons *.time) format(%9.2f) mlabposition(12) mlabgap(*1.2) ///
	mlabsize(vsmall) byopts(xrescale) legend(size(small)) xline(0) ///
	legend(pos(6)) legend (off) levels(95 90) title(,size(vsmall))
	
	graph save Graph "figure 1", replace
	graph export figure1.png, replace width(1800)
	
***** Figure 3 *****

coefplot (marginspro_dem), bylabel (Democrats) ///
	||(marginspro_rep) , bylabel(Republican) ///
	||, drop(_cons *.time) format(%9.2f) mlabposition(12) mlabgap(*1.2) ///
	mlabsize(vsmall) byopts(xrescale) legend(size(small)) xline(0) ///
	legend(pos(6)) legend (row(1)) levels(95 90)
	
	graph save Graph "figure2", replace
	graph export figure2.png, replace width(1800)

# delimit ;
esttab pro pro_dem pro_rep using table2.rtf, /// 
	nogap starlevels(^ .10 * .05 ** .01 *** .001) se(3) b(3) aic bic ///
	title("Pro climate change bill sponsorship" )
	 label
	//addnote("Dependent variable")//
	compress replace;
 #delimit cr
 
**** Robustness checks mentioned in text **** 

*** Estimating models with different quadrature points **** 


eststo point2: melogit pro_climate2 democrat independent  anom_counthot  anom_countcold i.time ///
	$district_controls $chamber_controls $state_controls2 senate ///
	|| st_fips:, intpoints(2) difficult
estat ic
eststo point5: melogit pro_climate2 democrat independent  anom_counthot  anom_countcold i.time ///
	$district_controls $chamber_controls $state_controls2 senate ///
	|| st_fips:, intpoints(5) difficult
estat ic
eststo point10: melogit pro_climate2 democrat independent  anom_counthot  anom_countcold i.time ///
	$district_controls $chamber_controls $state_controls2 senate ///
	|| st_fips:, intpoints(10) difficult
estat ic

******************************* Appendix ***************************************

**** Appendix Figure A: Simple models without controls *** 

eststo prosimple: melogit pro_climate2 democrat independent anom_counthot anom_countcold i.time ///
	|| st_fips:
eststo pro_simplemargins: margins , dydx(*) post

**** Appendix Figure B: Simple models without controls *** 
eststo pro_demsimple: melogit pro_climate2 anom_counthot anom_countcold i.time ///
	if democrat == 1 ///
	|| st_fips:
eststo pro_demsimplemargins:	margins , dydx(*) post

eststo pro_repsimple: melogit pro_climate2 anom_counthot anom_countcold i.time ///
	if republican == 1 ///
	|| st_fips:
eststo pro_repsimplemargins: margins , dydx(*) post


*** Appendix Figure C: Independents legislators subset only - simple models *** 
eststo pro_ind: melogit pro_climate2 democrat anom_counthot ///
	  $district_controls $chamber_controls $state_controls senate ///
	  if independent == 1 ///
	  || st_fips:, difficult
eststo marginspro_ind: margins, dydx(*) post


*** Appendix Figure D: Resource industries separate *** 

eststo proindustries: melogit pro_climate2 democrat independent  anom_counthot anom_countcold i.time ///
	$industries_controls $chamber_controls $state_controls senate ///
	|| st_fips:
eststo margins_proindustries: margins, dydx(*) post


**** Appendix Figure E: controlling for other climate events **** 

melogit pro_climate2 democrat independent  anom_counthot anom_countcold i.time ///
	$climate_controls $district_controls $chamber_controls $state_controls2 senate ///
	|| st_fips:
eststo margins_other_climate: margins, dydx(*) post


********************** Appendix Figures*****************************************

coefplot (pro_simplemargins) ///
	||, drop(_cons *.time) format(%9.2f) mlabposition(12) mlabgap(*1.2) mlabsize(vsmall) byopts(xrescale) ///
	legend(size(small)) xline(0) legend(pos(6)) legend (row(1)) levels(95 90)
graph save Graph "appendix_simple", replace
graph export appendix_simple.png, replace width(1800)

coefplot (pro_demsimplemargins, label(Democrats))(pro_repsimplemargins, label(Republican)) ///
	||, drop(_cons *.time) format(%9.2f) mlabposition(12) mlabgap(*1.2) mlabsize(vsmall) byopts(xrescale) ///
	legend(size(small)) xline(0) legend(pos(6)) legend (row(1)) levels(95 90)
graph save Graph "appendix_simple_pid", replace
graph export appendix_simple_pid.png, replace width(1800)


coefplot (margins_proindustries, label(Pro Climate Change Bill Sponsorship)) ///
	||, drop(_cons *.time) format(%9.2f) mlabposition(12) mlabgap(*1.2) mlabsize(vsmall) byopts(xrescale) ///
	legend(size(small)) xline(0) legend(pos(6)) legend (row(1)) levels(95 90)
graph save Graph "industries", replace
graph export appendix_simple_industry.png, replace width(1800)

*** Independents subset only

coefplot (marginspro_ind, label (Independents)) ///
	||, drop(_cons *.time) format(%9.2f) mlabposition(12) mlabgap(*1.2) mlabsize(vsmall) byopts(xrescale) ///
	legend(size(small)) xline(0) legend(pos(6))
graph save Graph "independents", replace
graph export independents.png, replace width(1800)

**** w other climate controls **** 

coefplot (margins_other_climate) ///
	||, drop(_cons *.time) format(%9.2f) mlabposition(12) mlabgap(*1.2) mlabsize(vsmall) byopts(xrescale) ///
	legend(size(small)) xline(0) legend(off) legend (row(1)) levels(95 90)
graph save Graph "other_climate", replace
graph export other_climate.png, replace width(1800)




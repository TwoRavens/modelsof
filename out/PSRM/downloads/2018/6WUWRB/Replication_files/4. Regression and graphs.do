log using "Output/logfile.txt", text replace
*****************************************************************
* Reproducing figures, regression results and postestimation	*
* in "Government instability and the state"						*
* 																*
* Daniel Walther, Johan Hellström								*
*****************************************************************

set more off


**************
*  Figure 1  *
**************

net install scheme_tufte.pkg
set scheme tufte
import delimited "Data/QoG_data.csv", delimiter(";") clear
gen region=1 if (ccode==100 | ccode==203 | ccode==233 | ccode==348 | ccode==428 | ccode==440 | ccode==642 | ccode==703)
recode region .=0
lab def region 1 "East" 0 "West"
lab val region region
destring icrg_qog, replace force
gen icrg_qog010=icrg_qog*10
separate icrg_qog010, by(region)
graph bar (mean) icrg_qog0100 (mean) icrg_qog0101, over(country, sort(icrg_qog010) label(angle(forty_five) labsize(small))) nofill bar(1, fcolor(black)) ///
bar(2, fcolor(gs6)) ytitle(State capacity level) ylabel(0(2.5)10)  legend(on order(1 "West" 2 "East") ///
title(Region, size(medsmall)) row(1))
graph save "Output/figure_1.gph", replace


**************
*  Figure 2  *
**************


use "Data/ERD_termination_small.dta", clear
decode country, gen(country2)
separate discretionary_survival, by(east)
graph bar (mean) discretionary_survival0 (mean) discretionary_survival1 if year>1989 & country!=19, over(country2, sort(discretionary_survival) label(angle(forty_five) labsize(small))) ///
 nofill bar(1, fcolor(black)) bar(2, fcolor(gs6)) ytitle(Share of early terminations) ylabel(0(.25)0.8)  legend(on order(1 "West" 2 "East") ///
 rows(1) title(Region, size(medsmall)))
graph save "Output/figure_2.gph", replace

 
*************
*  Table 1  *
*************
import delimited "Data/erd_merge.csv", delimiter(";") clear
 gen log_time_left = log(time_left)
 gen log_years_democracy = log(years_democracy )

* Multinomial model without interaction
mlogit termtype_precise icrg_qog unempquarterlychange infl_final log_time_left gdplevel major_cab polarization pm_disspower eff_numb_parties log_years_democracy, rrr vce(cluster country)

* Mulinomial model with interaction
mlogit termtype_precise c.icrg_qog##c.unempquarterlychange infl_final log_time_left gdplevel major_cab  polarization pm_disspower eff_numb_parties log_years_democracy, rrr vce(cluster country)

** View the number of observations:
bysort cab_code (year_quarter ): gen temp_obs=1 if _n == _N
tab termtype_precise if temp_obs ==1
drop temp_obs


*************
*  Table 2  *
*************

/* To display the individual output for the model, please delete the first word "qui" (quietly)*/
qui: mlogit termtype_precise c.icrg_qog##c.unempquarterlychange infl_final log_time_left gdplevel major_cab polarization pm_disspower eff_numb_parties log_years_democracy, rrr vce(cluster country)
margins, dydx(unempquarterlychange) at(icrg_qog =(6(1)10)) predict(outcome(2))

**************
*  Figure 3  *
**************

marginsplot, plot1opts(lcolor(gs6)) graphregion(color(white)) xtitle("State capacity") ytitle("Marginal effect") title("") yline(0, lpattern(dash))
graph save "Output/figure_3.gph", replace



******************
***  APPENDIX  ***
******************

* A: Figure - Changes in state capacity levels, as measured by our state capacity index, over time
import delimited "Data/QoG_data.csv", delimiter(";") clear
destring icrg_qog, replace force
twoway (line icrg_qog year, sort lwidth(vthick)), ytitle(QoG value) xtitle(Year) by(country, note("")) xlabel(,grid)
graph save "output/Appendix_figure_A.gph", replace

* B: Figure - Early elections and replacements since 1989
net install grc1leg.pkg
use "Data/ERD_termination_small.dta", clear
separate early_elect, by(east)
separate replacement, by(east)
decode country, gen(country2)
graph bar (mean) early_elect0 (mean) early_elect1 if year>1988, over(country2, sort(discretionary_survival) label(angle(forty_five) labsize(small))) ///
 nofill bar(1, fcolor(black)) bar(2, fcolor(gs6)) ylabel(0(.2)0.6)  legend(off) title("Early elections")
graph save "Output/ee.gph", replace
graph bar (mean) replacement0 (mean) replacement1 if year>1988, over(country2, sort(discretionary_survival) label(angle(forty_five) labsize(small))) ///
 nofill bar(1, fcolor(black)) bar(2, fcolor(gs6)) ylabel(0(.2)0.6)  legend(on order(1 "West" 2 "East") title(Region, size(medsmall)) rows(1)) title("Replacements")
graph save "Output/rep.gph", replace
grc1leg "Output/ee.gph" "Output/rep.gph", xcom ycom  c(1) legendfrom("Output/rep.gph")
graph save "Output/Appendix_figure_B.gph", replace

* C: Table - Regression result when corruption is removed from the measure of state capacity
import delimited "Data/erd_merge.csv", delimiter(";") clear
 gen log_time_left = log(time_left)
 gen log_years_democracy = log(years_democracy )
mlogit termtype_precise qognocorruption unempquarterlychange infl_final log_time_left gdplevel major_cab polarization pm_disspower eff_numb_parties log_years_democracy, rrr vce(cluster country)
mlogit termtype_precise c.qognocorruption##c.unempquarterlychange infl_final log_time_left gdplevel major_cab  polarization pm_disspower eff_numb_parties log_years_democracy, rrr vce(cluster country)

**Show the number of observations:
bysort cab_code (year_quarter ): gen temp_obs=1 if _n == _N
tab termtype_precise if temp_obs ==1
drop temp_obs

* D: Table. Marginal effects when corruption is removed from the measure of state capacity 
margins, dydx(unempquarterlychange) at(qognocorruption =(6(1)10)) predict(outcome(2))



log close

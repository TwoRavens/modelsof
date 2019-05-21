clear

*install needed packages
* clarify
net install clarify, from("https://gking.harvard.edu/clarify")

*estout
ssc install estout, replace

* esta distributed as part of the replication archive, but must be manually installed before running this code. 

* To reproduce estimates, tables, and figures presented in the paper, run this analysis.do and then figures.r. 

* The code below reproduces all estimates that are presented in the paper and that are used to construct the the figures. In the case of Figure3, Figure4a, Figure4b, Figure5b, Figure5c, Figure13, and Figure14, the output below has been manually copied and pasted into the appropriate CSV in the ./Results/ directory. The output in the RDH2016.log can be compared against these the ./Results/Figure*.csv files to verify that the figures are based on the estimates below. The figures.R code reads the ./Results/Figure*.csv files in order to construct the figures that are presented in the paper.  


capture log close
log using RDH2016.log, replace

set seed 1111111 

******************************************************************************
******************************************************************************
******************************************************************************
******************************************************************************
*
* Analysis for tables and figures in the Paper 
*
******************************************************************************
******************************************************************************
******************************************************************************
******************************************************************************


******************************************************************************
* Table 1: Recap of terminology and hypotheses
* No replication code
******************************************************************************


******************************************************************************
* Figure 1: Design of Study 1
* No replication code 
******************************************************************************


******************************************************************************
* Figure 2
* Replication code is in figures.R file
******************************************************************************



******************************************************************************
* Figure 3:  Leader-Specific Reputations
* Code to produce figure using estimates generated below is in figures.R
*******************************************************************************
clear
use "MTURKdata-AllWaves.dta", replace

* the following code uses CLARIFY to estimate the substantive effect of the same leader condition
estsimp reg resolveA histXlead stoodfirm sameleader powercondition age male race income education republican ideology milassert if highinfluence==1
setx (age income ideology milassert education) mean
setx (race republican) median
setx sameleader 0
setx histXlead 0
setx stoodfirm 0
simqi, fd(ev) changex(stoodfirm 0 1)
setx sameleader 1
simqi, fd(ev) changex(stoodfirm 0 1 histXlead 0 1)


*******************************************************************************
* Figure 4:  Influence Specific Reputations
* Code to produce figure using estimates generated below is in figures.R
*******************************************************************************
clear
use "MTURKdata-AllWaves.dta", replace


* the following code uses CLARIFY to estimate the substantive effect of same leader interacted with the influence condition.
estsimp reg resolveA inflXhistXlead histXlead influenceXlead influenceXhist highinfluence sameleader historycondition powercondition age male race income college somecollege highschool noHS_degree ideology republican milassert mturkexper
* theta same leader, high influence
setx highinfluence 1
setx sameleader 1
setx inflXhistXlead 0
simqi, fd(ev) changex(historycondition 0 1 inflXhistXlead 0 1 histXlead 0 1 influenceXhist 0 1)


* theta different leader, high influence
setx powercondition mean
setx highinfluence 1
setx sameleader 0
setx histXlead 0
setx influenceXlead 0
setx inflXhistXlead 0
simqi, fd(ev) changex(historycondition 0 1 influenceXhist 0 1)

* theta same leader, low influence
setx sameleader 1
setx highinfluence 0
setx inflXhistXlead 0
setx influenceXlead 0
setx influenceXhist 0
simqi, fd(ev) changex(historycondition 0 1 histXlead 0 1)

* theta different leader, low influence
setx sameleader 0
setx highinfluence 0
setx inflXhistXlead 0
setx histXlead 0
setx influenceXlead 0
setx influenceXhist 0
simqi, fd(ev) changex(historycondition 0 1 )


*******************************************************************************
* Figure 5: Iran Scenario Results
* Code to produce figure using estimates generated below is in figures.R
*******************************************************************************

* Figure 5a
* Replication code is in figures.R file


*Estimates for Figure 5b and 5c


clear
use "MTURKdata-IranAllWaves.dta", replace
destring mturkexper, replace force
* the following code uses CLARIFY to estimate the substantive effect of same leader interacted with the influence condition.
estsimp reg resolveA inflXhistXlead histXlead influenceXlead influenceXhist highinfluence sameleader stoodfirm powercondition age male race income college somecollege highschool noHS_degree ideology republican milassert mturkexper
setx mean
* theta same leader, high influence
setx highinfluence 1
setx sameleader 1
setx influenceXlead 1
simqi, fd(ev) changex(stoodfirm 0 1 inflXhistXlead 0 1 histXlead 0 1 influenceXhist 0 1)

setx mean
* theta different leader, high influence
setx highinfluence 1
setx sameleader 0
setx histXlead 0
setx influenceXlead 0
setx inflXhistXlead 0
simqi, fd(ev) changex(stoodfirm 0 1 influenceXhist 0 1)

* theta same leader, low influence
setx sameleader 1
setx highinfluence 0
setx inflXhistXlead 0
setx influenceXlead 0
setx influenceXhist 0
simqi, fd(ev) changex(stoodfirm 0 1 histXlead 0 1)

* theta different leader, low influence
setx sameleader 0
setx highinfluence 0
setx inflXhistXlead 0
setx histXlead 0
setx influenceXlead 0
setx influenceXhist 0
simqi, fd(ev) changex(stoodfirm 0 1 )


******************************************************************************
******************************************************************************
******************************************************************************
******************************************************************************
*
* Analysis for tables and figures in the Appendix 
*
******************************************************************************
******************************************************************************
******************************************************************************
******************************************************************************



******************************************************************************
* Appendix B, Figure 6: Coercion Stage-Game
* No replication code. 
******************************************************************************

******************************************************************************
* Appendix B, Figure 7:  Values of qt+1 that make MB indifferent.
* No replication code. 
******************************************************************************


******************************************************************************
* Appendix C Confounding
******************************************************************************

* Table 2
clear
* the following code implements the confounding analysis with a series of linear regression models.
use "MTURKdata-AllWaves.dta", replace
reg placebo_democracy stoodfirm 
estimates store m1a
reg placebo_democracy sameleader 
estimates store m2a
reg placebo_democracy highinfluence
estimates store m3a
reg placebo_democracy powercondition 
estimates store m4a
clear
use "MTURKdata-IranAllWaves.dta", replace
reg placebo_democracy stoodfirm 
estimates store m1b
reg placebo_democracy sameleader 
estimates store m2b
reg placebo_democracy highinfluence
estimates store m3b
reg placebo_democracy powercondition 
estimates store m4b

esta m1a m1b m2a m2b m3a m3b m4a m4b using "table_2.tex", replace fragment star( + 0.10 * 0.05 ** 0.01) label nomtitles stats(N) se style(tex)  

********************************************************************************
* Appendix D Demographics
* All code to replicate figures in Appendix D is in figures.R
********************************************************************************


********************************************************************************
* Appendix I Main Results
********************************************************************************

* Table 3
use "MTURKdata-AllWaves.dta", replace

reg resolveA stoodfirm
estimates store m1a
reg resolveA stoodfirm powercondition age male race income education republican ideology milassert mturkexper
estimates store m1b
reg resolveA histXlead stoodfirm sameleader
estimates store m2a
reg resolveA histXlead stoodfirm sameleader powercondition age male race income education republican ideology milassert mturkexper
estimates store m2b
reg resolveA inflXhistXlead histXlead influenceXlead influenceXhist stoodfirm highinfluence sameleader powercondition
estimates store m3a
reg resolveA inflXhistXlead histXlead influenceXlead influenceXhist stoodfirm highinfluence sameleader powercondition age male race income education republican ideology milassert mturkexper
estimates store m3b

use "MTURKdata-IranAllWaves.dta", replace
destring mturkexper, replace force
reg resolveA stoodfirm
estimates store m1c
reg resolveA stoodfirm powercondition age male race income education republican ideology milassert mturkexper
estimates store m1d
reg resolveA histXlead stoodfirm sameleader
estimates store m2c
reg resolveA histXlead stoodfirm sameleader powercondition age male race income education republican ideology milassert mturkexper 
estimates store m2d
reg resolveA inflXhistXlead histXlead influenceXlead influenceXhist stoodfirm highinfluence sameleader powercondition
estimates store m3c
reg resolveA inflXhistXlead histXlead influenceXlead influenceXhist stoodfirm highinfluence sameleader powercondition age male race income education republican ideology milassert mturkexper 
estimates store m3d

esta m1a m1b m1c m1d m2a m2b m2c m2d m3a m3b m3c m3d using "table_3.tex", replace fragment star( + 0.10 * 0.05 ** 0.01) label nomtitles stats(N) se style(tex) 


********************************************************************************
* Appendix J Results by Power Condition
********************************************************************************
* Table 4
clear
use "MTURKdata-AllWaves.dta", replace

reg resolveA historycondition
estimates store m1a
reg resolveA historycondition age male race income education republican ideology milassert mturkexper
estimates store m1b
reg resolveA historycondition if powercondition==-1
estimates store m2a
reg resolveA historycondition age male race income education republican ideology milassert mturkexper if powercondition==-1
estimates store m2b
reg resolveA historycondition if powercondition==0
estimates store m3a
reg resolveA historycondition age male race income education republican ideology milassert mturkexper if powercondition==0
estimates store m3b
reg resolveA historycondition if powercondition==1
estimates store m4a
reg resolveA historycondition age male race income education republican ideology milassert mturkexper if powercondition==1
estimates store m4b
esta m1a m1b m2a m2b m3a m3b m4a m4b using "table_4.tex", replace fragment star( + 0.10 * 0.05 ** 0.01) label nomtitles stats(N) se style(tex) 


********************************************************************************
* Appendix J Results by Power Condition
* Code to produce figure using estimates generated below is in figures.R
********************************************************************************
*Figure 13: Effect of Past Actions (with controls)
clear
* the following uses clarify to estimate the substantive effects of past actions.
use "MTURKdata-AllWaves.dta", replace
estsimp reg resolveA historycondition powercondition age male race income education ideology republican milassert mturkexper
setx (age income ideology milassert mturkexper education) mean
setx (race republican) median
setx historycondition 0
simqi, ev 
setx historycondition 1
simqi, ev 


*Figure 14:  Country-Specific Reputation (with con- trols)
clear
use "MTURKdata-AllWaves.dta", replace
* the following uses clarify to estimate the substantive effects of country-specific reputation.
estsimp reg resolveA histXlead stoodfirm sameleader powercondition age male race income education republican ideology milassert 
setx (age income ideology milassert education) mean
setx (race republican) median
setx sameleader 0
setx histXlead 0
setx stoodfirm 0
simqi, ev 
setx stoodfirm 1
simqi, ev 


log close


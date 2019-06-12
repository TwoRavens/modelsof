* ============================================================================================================
* Replication Do-File for BJPS-Article "Setting the party agenda: Interest groups, voters and issue attention"
* by Heike Klüver, 28.12.2017
* ============================================================================================================





* ====================================================
* Table 1
* ====================================================

* set working directory
cd "C:\Users\klueverh\Dropbox\Dokumente\Papers\Party interest group paper\Replication\"

* Log file
log using "Kluever_BJPS_Settingthepartyagenda.smcl", replace

* load data
use "Kluever_BJPS_Settingthepartyagenda.dta" 


* Model 1
* =======
regress salience lag_salience lag_prev_ig_rel lag_prev_mip_voter lag_prev_finmin_rel lag_pervote extreme gov lag_system_salience unemploy unific,  beta
regress salience lag_salience lag_prev_ig_rel lag_prev_mip_voter lag_prev_finmin_rel lag_pervote extreme gov lag_system_salience unemploy unific, vce(cluster party_issue)
estat ic
estimates store m1


* Model 2
* =======
regress salience lag_prev_ig_rel lag_prev_mip_voter lag_prev_ig_mip_voter  lag_prev_finmin_rel lag_pervote extreme gov lag_system_salience unemploy unific lag_salience, vce (cluster party_issue)
estat ic
estimates store m2


esttab m1 m2, b(%9.3f) se(%9.3f) r2(2) label star(* 0.1 ** 0.05 *** 0.01)  parentheses  replace plain
esttab m1 m2 using models1&2.csv , b(%9.3f) se(%9.3f) r2(2) label star(* 0.1 ** 0.05 *** 0.01)  parentheses  replace plain





* =========================
* FIGURES
* =========================

* ============================
* Figure 1 
* ============================
use "Kluever_BJPS_Settingthepartyagenda.dta" 


* Model 2
regress salience lag_prev_ig_rel lag_prev_mip_voter lag_prev_ig_mip_voter  lag_prev_finmin_rel lag_pervote extreme gov lag_system_salience unemploy unific lag_salience, vce (cluster party_issue)

* extract variance-covariance matrix from last model estimated
matrix V=e(V)
svmat V, names(vvector)
* save variance-covariance matrix locally as csv file
outsheet vvector* using varcov_m1.csv, comma replace

* extract vector of coefficients from last model estimated
matrix b=e(b) 
svmat b, names(fixeff)
* save coefficients locally as csv file
outsheet fixeff* using fixeff_m1.csv, comma replace

* retain only those observations used in last analysis
drop if e(sample) == 0

* drop unnecessary variables
keep salience lag_salience lag_prev_ig_rel lag_prev_mip_voter lag_prev_finmin_rel lag_pervote extreme gov unemploy unific party_issue lag_system_salience lag_prev_ig_mip_voter

saveold data_m1.dta, replace



* ============================
* Figure 2
* ============================
use "Kluever_BJPS_Settingthepartyagenda.dta" 


* Model 2
regress salience lag_prev_ig_rel lag_prev_mip_voter lag_prev_ig_mip_voter  lag_prev_finmin_rel lag_pervote extreme gov lag_system_salience unemploy unific lag_salience, vce (cluster party_issue)


* Generate values for voter issue attention for which to calculate the marginal effects of interest group attention
gen MV = _n - 1
replace MV=. if _n>21


* Grab elements of the coefficients and variance-covariance matrix
matrix b=e(b)
matrix V=e(V)

scalar b1=b[1,1]
scalar b3=b[1,3]

scalar varb1=V[1,1]
scalar varb3=V[3,3]

scalar covb1b3=V[1,3]


scalar list b1 b3 varb1 varb3 covb1b3

gen conbx = b1 + b3 * MV   if MV <= 20
gen consx = sqrt(varb1 + varb3*(MV^2) + 2*covb1b3*MV) if MV <= 20 


* Generate 95% confidence intervals
gen a = 1.96 *consx
gen upper = conbx + a
gen lower = conbx - a


* Computing the graph
#delimit ;
graph twoway line conb   MV, clwidth(medium) clcolor(blue) clcolor(black)
        ||   line upper  MV, clpattern(dash) clwidth(thin) clcolor(black)
        ||   line lower  MV, clpattern(dash) clwidth(thin) clcolor(black)
        ||   ,   

             legend(col(1) order(1 2) size(vsmall) label(1 "Marginal effect of interest group attention as voter attention varies") 
                                      label(2 "95% Confidence Interval"))                            
             xtitle("Voter issue attention", size(3)  )
             xsca(titlegap(2))
             ysca(titlegap(2))
			 xscale(r(-.902 3.3298))
             ytitle("Marginal effect of interest group attention at t-1", size(3))
             scheme(lean2)  graphregion(fcolor(white)) ylabel(, nogrid) legend(position(6));
#delimit cr


keep if MV ~= .
keep  MV-lower

saveold "figure2.dta", replace






* =================
* APPENDIX MODELS
* =================

set more off

* set working directory
cd "C:\Users\klueverh\Dropbox\Dokumente\Papers\Party interest group paper\Replication\"

* load data
use "Kluever_BJPS_Settingthepartyagenda.dta" 


* ================================
* Table A.1: Descriptives
* ================================

quietly regress salience lag_salience lag_prev_ig_rel lag_prev_mip_voter lag_prev_finmin_rel lag_pervote extreme gov lag_system_salience unemploy unific, vce(cluster party_issue)
sum salience lag_salience lag_prev_ig_rel lag_prev_mip_voter lag_prev_finmin_rel lag_pervote extreme gov lag_system_salience unemploy unific if e(sample) == 1 


* ================================
* Table A.3: All voters
* ================================


* Model 3
* =======
regress salience lag_salience lag_prev_ig_rel lag_prev_mip_all lag_prev_finmin_rel lag_pervote extreme gov unemploy unific lag_system_salience, vce(cluster party_issue) 
estat ic
estimates store m3


* Model 4
* =======
regress salience lag_prev_ig_rel lag_prev_mip_all lag_prev_ig_mip_all  lag_prev_finmin_rel lag_pervote extreme gov unemploy unific lag_salience lag_system_salience, vce (cluster party_issue)
estat ic
estimates store m4

esttab m3 m4, b(%9.3f) se(%9.3f) r2(2) label star(* 0.1 ** 0.05 *** 0.01)  parentheses  replace plain



* ======================================
* Table A.4: Current ig mobilization 
* ======================================


* Model 5
* =======
regress salience lag_salience ig_rel mip_voter extreme gov lag_system_salience lag_prev_finmin_rel lag_pervote  unemploy unific, vce(cluster party_issue) 
estat ic
estimates store m5


* Model 6
* =======
gen ig_mip_voter = ig_rel * mip_voter

regress salience ig_rel mip_voter ig_mip_voter extreme gov  lag_system_salience lag_prev_finmin_rel lag_pervote unemploy unific lag_salience, vce (cluster party_issue)
estat ic
estimates store m6

esttab m5 m6, b(%9.3f) se(%9.3f) r2(2) label star(* 0.1 ** 0.05 *** 0.01)  parentheses  replace plain



* ==============================================================
* Table A.5: Average ig mobilization over past legislative term
* ==============================================================


* Model 7
* =======
regress salience lag_salience mean_ig_rel  mean_mip lag_pervote extreme gov  lag_system_salience lag_prev_finmin_rel  unemploy unific, vce(cluster party_issue) 
estat ic
estimates store m7


* Model 8
* =======
gen mean_ig_mip_voter = mean_ig_rel *  mean_mip 

regress salience mean_ig_rel mean_mip  mean_ig_mip_voter lag_pervote extreme gov  lag_system_salience  lag_prev_finmin_rel  unemploy unific lag_salience, vce (cluster party_issue)
estat ic
estimates store m8

esttab m7 m8, b(%9.3f) se(%9.3f) r2(2) label star(* 0.1 ** 0.05 *** 0.01)  parentheses  replace plain



* =======================================================
* Table A.6: Voter issue attention at t-1 and t-2
* =======================================================


* Model 9
* =======
regress salience  lag_prev_ig_rel lag_prev_mip_all  lag2_prev_mip_all lag_pervote extreme gov  lag_system_salience  lag_prev_finmin_rel unemploy unific lag_salience, vce(cluster party_issue) 
estat ic
estimates store m9


* Model 10
* =======
gen lag2_prev_ig_mip_voter = lag2_prev_mip_all * lag_prev_ig_rel

regress salience lag_prev_ig_rel lag_prev_mip_all  lag2_prev_mip_all lag_prev_ig_mip_voter lag2_prev_ig_mip_voter lag_pervote extreme gov  lag_system_salience  lag_prev_finmin_rel unemploy unific lag_salience, vce (cluster party_issue)
estat ic
estimates store m10

esttab m9 m10, b(%9.3f) se(%9.3f) r2(2) label star(* 0.1 ** 0.05 *** 0.01)  parentheses  replace plain



* ======================================
* Table A.7: Fixed effects for parties
* ======================================


* Model 11
* =======
regress salience lag_prev_ig_rel lag_prev_mip_voter lag_pervote extreme gov  lag_system_salience lag_prev_finmin_rel  unemploy unific lag_salience  i.party, vce(cluster party_issue) 
estat ic
estimates store m11


* Model 12
* =======
regress salience lag_prev_ig_rel lag_prev_mip_voter lag_prev_ig_mip_voter lag_pervote extreme gov lag_system_salience lag_prev_finmin_rel unemploy unific lag_salience i.party, vce (cluster party_issue)
estat ic
estimates store m12

esttab m11 m12, b(%9.3f) se(%9.3f) r2(2) label star(* 0.1 ** 0.05 *** 0.01)  parentheses  replace plain



* =======================================
* Table A.8: Fixed effects for elections
* =======================================


* Model 13
* =======
regress salience  lag_prev_ig_rel lag_prev_mip_voter lag_pervote extreme gov  lag_system_salience lag_prev_finmin_rel unemploy unific i.date lag_salience, vce(cluster party_issue) 
estat ic
estimates store m13


* Model 14
* =======
regress salience lag_prev_ig_rel lag_prev_mip_voter lag_prev_ig_mip_voter lag_pervote extreme gov  lag_system_salience lag_prev_finmin_rel unemploy unific lag_salience i.date, vce (cluster party_issue)
estat ic
estimates store m14

esttab m13 m14, b(%9.3f) se(%9.3f) r2(2) label star(* 0.1 ** 0.05 *** 0.01)  parentheses  replace plain



* ====================================================
* Table A.9: Models without party-specific controls
* ====================================================


* Model 15
* ========
regress salience lag_salience lag_prev_ig_rel lag_prev_mip_voter lag_prev_finmin_rel  lag_system_salience unemploy unific, vce(cluster party_issue) 
estat ic
estimates store m15


* Model 16
* ========
regress salience lag_prev_ig_rel lag_prev_mip_voter lag_prev_ig_mip_voter  lag_prev_finmin_rel lag_system_salience unemploy unific lag_salience, vce (cluster party_issue)
estat ic
estimates store m16

esttab m15 m16, b(%9.3f) se(%9.3f) r2(2) label star(* 0.1 ** 0.05 *** 0.01)  parentheses  replace plain




* =====================================================================
* TABLE A.10: Interaction effcts for party supporter issue attention
* =====================================================================
gen lag_pervote_mip = lag_pervote * lag_prev_mip_voter
gen gov_mip = gov * lag_prev_mip_voter
gen extreme_mip = extreme * lag_prev_mip_voter


regress salience lag_salience lag_prev_ig_rel lag_prev_mip_voter lag_prev_finmin_rel lag_pervote extreme gov lag_system_salience unemploy unific lag_pervote_mip gov_mip extreme_mip, vce(cluster party_issue) 
estat ic
estimates store m17

regress salience lag_prev_ig_rel lag_prev_mip_voter lag_prev_ig_mip_voter  lag_prev_finmin_rel lag_pervote extreme gov lag_system_salience unemploy unific lag_salience lag_pervote_mip gov_mip extreme_mip, vce (cluster party_issue)
estat ic
estimates store m18

esttab m17 m18, b(%9.3f) se(%9.3f) r2(2) label star(* 0.1 ** 0.05 *** 0.01)  parentheses  replace plain




* ====================================================
* Table A.11: Interaction effects for ig mobilization
* ====================================================
gen lag_pervote_ig = lag_pervote * lag_prev_ig_rel
gen gov_ig = gov * lag_prev_ig_rel
gen extreme_ig = extreme * lag_prev_ig_rel

regress salience lag_salience lag_prev_ig_rel lag_prev_mip_voter lag_prev_finmin_rel lag_pervote extreme gov lag_system_salience unemploy unific lag_pervote_ig gov_ig extreme_ig, vce(cluster party_issue) 
estat ic
estimates store m19

regress salience lag_prev_ig_rel lag_prev_mip_voter lag_prev_ig_mip_voter  lag_prev_finmin_rel lag_pervote extreme gov lag_system_salience unemploy unific lag_salience lag_pervote_ig gov_ig extreme_ig, vce (cluster party_issue)
estat ic
estimates store m20

esttab m19 m20, b(%9.3f) se(%9.3f) r2(2) label star(* 0.1 ** 0.05 *** 0.01)  parentheses  replace plain




* =======================================================================================
* Table A.12 Exploring the relationship between interest groups and government spending 
* =======================================================================================

* Model 21
* =======
regress ig_rel_issue lag_prev_ig_rel lag_prev_finmin_rel , vce(cluster party_issue) 
estat ic
estimates store m21


* Model 22
* =======
regress exp_finmin_rel_issue lag_prev_ig_rel lag_prev_finmin_rel , vce(cluster party_issue) 
estat ic
estimates store m22

esttab m21 m22, b(%9.3f) se(%9.3f) r2(2) label star(* 0.1 ** 0.05 *** 0.01)  parentheses  replace plain


log close


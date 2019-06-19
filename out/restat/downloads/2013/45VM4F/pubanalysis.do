* This script contains the code for the publication analysis in Kelchtermans, S. and R. Veugelers (2013). Top Research Productivity and Its Persistence: Gender as a Double-Edged Sword. The Review of Economics and Statistics.

version 11.2
pause on
set more off
set mem 50m
set matsize 1000
cap log close
log using pubanalysis.log, replace

use pubdata.dta, clear

stset end, origin(time max(zapdate,d(01oct1992))) failure(h2y==1) id(persnr) time0(begin) scale(365.25) exit(finalobs==1)
replace _t0=round(_t0)
replace _t=round(_t)

stcox male age maind_B maind_C maind_E maind_G maind_H maind_I maind_M maind_N maind_P maind_R maind_Z fac_wet fac_twt fac_lbw fac_gen fac_far r_doc1 r_hdoc1 r_hl1 r_rest1 yrsrank headuni1 zapaft92 yrszap tchload cumGOAlag1 cumOTlag1 avgco avgcom fulltiun if prefirst2y==1 & pubm_pre92h==0, robust cluster(persnr) /* first top: table 2, model 1 */
		
stcox male age maind_B maind_C maind_E maind_G maind_H maind_I maind_M maind_N maind_P maind_R maind_Z fac_wet fac_twt fac_lbw fac_gen fac_far r_doc1 r_hdoc1 r_hl1 r_rest1 yrsrank headuni1 zapaft92 yrszap tchload cumGOAlag1 cumOTlag1 avgco avgcom pubm_pre92h pasttop2y pasttop2ym fulltiun, robust cluster(persnr) /* repeated top: table 2, model 2 */

stcox male age maind_B maind_C maind_E maind_G maind_H maind_I maind_M maind_N maind_P maind_R maind_Z fac_wet fac_twt fac_lbw fac_gen fac_far r_doc1 r_hdoc1 r_hl1 r_rest1 yrsrank headuni1 zapaft92 yrszap tchload cumGOAlag1 cumOTlag1 avgco avgcom pubm_pre92h pasttop2y pasttop2ym fulltiun, shared(persnr) /* repeated top with frailty: table 2, model 3 */

log close


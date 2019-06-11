* =============================================================================================================================
* Sagarzazu/Klüver (PSRM): Coalition governments and party competition: Political communication strategies of coalition parties
* Replication Do File
* 11.05.2015
* =============================================================================================================================


*cd "~/Dropbox/Kluver&Sagarzazu/PSRM Submission/Replication materials/"
cd "C:\Users\Heike.Kluever\Dropbox\Kluver&Sagarzazu\PSRM Submission\Replication materials"
set more off
log using "SagarzazuKluever_ReplicationLogFile.smcl", replace


*****************************************************************************************************************************************************************
*****************************************************************************************************************************************************************
*****************************************************************************************************************************************************************


* ==================
* Figure 1 
* ==================

use "SagarzazuKluever_ReplicationData1.dta", clear

tsset issue ym
gen ln_ed = ln(ed_p_)
tssmooth ma ma_ed = ed_p_, window(6)


** a) Economy 

preserve
keep if issue == 2
tsline ma_ed, /*
*/ ytitle("Issue diversity") xtitle("") title("") scheme(s2mono) graphregion(fcolor(white)) ylabel(, nogrid) plotregion(fcolor(white)) /*
*/ xline(512 548 596,  lpattern(dash))  /*
*/ xlabel(496.5 "Schroeder I" 530.5 "Schroeder II" 572 "Merkel I" 603.5 "Merkel II")
graph export "figure1a.png", as(png) replace
restore



** b) Environment

preserve
keep if issue == 4
tsline ma_ed, /*
*/ ytitle("Issue diversity") xtitle("") title("") scheme(s2mono) graphregion(fcolor(white)) ylabel(, nogrid) plotregion(fcolor(white)) /*
*/ xline(512 548 596,  lpattern(dash))  /*
*/ xlabel(496.5 "Schroeder I" 530.5 "Schroeder II" 572 "Merkel I" 603.5 "Merkel II")
graph export "figure1b.png", as(png) replace
restore





*****************************************************************************************************************************************************************
*****************************************************************************************************************************************************************
*****************************************************************************************************************************************************************


* ==================
* Table 1 
* ==================

cd "C:\Users\Heike.Kluever\Dropbox\Kluver&Sagarzazu\PSRM Submission\Replication materials"
use "SagarzazuKluever_ReplicationData1.dta", clear

xtset issue id


** Model 1
** =======
quietly: xtpcse log_ed_p  months2election months_sq ep_election reg_election mip unempl  bse cdu_crisis terror afghan flood worldcup crisis l.log_ed_p i.issue 
est store model1


** Model 2
** =======
quietly: xtpcse log_ed_p  months2election months_sq ep_election reg_election mip unempl  bse cdu_crisis terror afghan flood worldcup crisis i.coalition l.log_ed_p    i.issue 
est store model2


* Display results
estout model1 model2, cells(b(fmt(3) star) se(par fmt(3))) stats(N r2 , fmt(4)) label


* Saving and exporting results for figure 2 (R code)
gen lag_dv = l.log_ed_p
tabulate issue, gen(issue_dum)

xtpcse log_ed_p  months2election months_sq ep_election reg_election mip unempl  bse cdu_crisis terror afghan flood worldcup crisis lag_dv issue_dum2 issue_dum3 issue_dum4 issue_dum5 issue_dum6 issue_dum7 issue_dum8 issue_dum9 issue_dum10 issue_dum11 issue_dum12 issue_dum13 issue_dum14 issue_dum15 issue_dum16 issue_dum17 issue_dum18 issue_dum19 issue_dum20 


drop if e(sample) ~= 1
saveold Rdata, replace

matrix V=e(V)
svmat V, names(vvector)
outsheet vvector* using varcov.csv, comma replace

matrix b=e(b) 
svmat b, names(fixeff)
outsheet fixeff* using fixeff.csv, comma replace






*****************************************************************************************************************************************************************
*****************************************************************************************************************************************************************
*****************************************************************************************************************************************************************

* ============
* Appendix
* ============


/*** Figure A.1 ***/

use "SagarzazuKluever_ReplicationData2.dta", clear


*** a) SPD-GREENS
		  
graph bar c_4 c_9 c_13 if party=="SPD" | party=="GREENS" & pm<3, /*
*/ asy over(party) scheme(lean2) legend(label(1 "Environment") label(2 "Employment/Social") label(3 "International") pos(6) cols(3))		 
graph export "figureA1a.png", as(png) replace
		  
*** b) CDU/CSU-SPD
 
graph bar c_2 c_9 c_20 if party=="SPD" | party=="CDU/CSU" & pm==3, /*
*/ asy over(party) scheme(lean2) legend(label(1 "Economy") label(2 "Employment/Social") label(3 "Family") pos(6) cols(3))
graph export "figureA1b.png", as(png) replace

*** c) CDU-FDP
			
graph bar c_2 c_7 c_20 if party=="FDP" | party=="CDU/CSU" & pm==4, /*
*/ asy over(party) scheme(lean2) legend(label(1 "Economy") label(2 "Legal affairs") label(3 "Family") pos(6) cols(3))
graph export "figureA1c.png", as(png) replace

 


*****************************************************************************************************************************************************************

/*** Figure A.2 ***/

use "SagarzazuKluever_ReplicationData1.dta", clear

tsset issue ym

tssmooth ma ma_sr_ = p_sr_, window(6)
tssmooth ma ma_jr_ = p_jr_, window(6)


** a) Economy 

preserve
keep if issue == 2

tsline ma_sr_ ma_jr_ , /*
*/ ytitle("Issue attention(MA)") xtitle("") title("") scheme(s2mono) graphregion(fcolor(white)) ylabel(, nogrid) plotregion(fcolor(white)) /*
*/ xline(512 548 596,  lpattern(dash))  legend(label(1 "Senior partner") label(2 "Junior partner"))/*
*/ xlabel(496.5 "Schroeder I" 530.5 "Schroeder II" 572 "Merkel I" 603.5 "Merkel II")
graph export "figureA2a.png", as(png) replace
restore


** b) Environment

preserve
keep if issue == 4

tsline ma_sr_ ma_jr_ , /*
*/ ytitle("Issue attention(MA)") xtitle("") title("") scheme(s2mono) graphregion(fcolor(white)) ylabel(, nogrid) plotregion(fcolor(white)) /*
*/ xline(512 548 596,  lpattern(dash))  legend(label(1 "Senior partner") label(2 "Junior partner"))/*
*/ xlabel(496.5 "Schroeder I" 530.5 "Schroeder II" 572 "Merkel I" 603.5 "Merkel II")
graph export "figureA2b.png", as(png) replace
restore






*****************************************************************************************************************************************************************

/*** Table A.2 ***/

use SagarzazuKluever_ReplicationData2.dta, clear

/* Table: Press Releases Party x Year */

tab year party if year>=2000 & year<=2010




*****************************************************************************************************************************************************************

/*** Table A.4 ***/

use "SagarzazuKluever_ReplicationData1.dta", clear

** Model 3

quietly: xtpcse log_ed_p  months2election months_sq ep_election reg_elect mip unempl conflict bse cdu_crisis terror afghan flood worldcup crisis  l.log_ed_p i.issue if period==2
est store model3

** Model 4
quietly: xtpcse log_ed_p  months2election months_sq ep_election reg_elect mip unempl conflict bse cdu_crisis terror afghan flood worldcup crisis i.coalition l.log_ed_p i.issue if period==2
est store model4


** Display results
estout model3 model4 , cells(b(fmt(3) star) se(par fmt(3))) stats(N r2 , fmt(4)) label




*****************************************************************************************************************************************************************

/*** Table A.6 ***/


use "SagarzazuKluever_ReplicationData1.dta", clear

keep ym tcd  months2election  months_sq ep_election reg_elect unempl bse cdu_crisis terror afghan flood worldcup crisis coalition  

duplicates drop

tsset ym 

quietly: rreg tcd  months2election  months_sq ep_election reg_elect unempl bse cdu_crisis terror afghan flood worldcup crisis i.coalition l.tcd
est store model5


estout model5 , cells(b(fmt(4) star) se(par fmt(3))) stats(N r2 , fmt(4)) label




*****************************************************************************************************************************************************************

/*** Table A.7 ***/


use "SagarzazuKluever_ReplicationData1.dta", clear

xtset issue id

gen lag_ed_p=l.ed_p_

quietly: betafit ed_p_, mu( months2election months_sq ep_election reg_elect mip unempl  bse cdu_crisis terror afghan flood worldcup crisis i.coalition  lag_ed_p )

est store model6

estout model6 , cells(b(fmt(3) star) se(par fmt(3))) stats(N r2 , fmt(4)) label



*****************************************************************************************************************************************************************

log close

********************************************************************************
*                                                                              *
*                               REGRESSIONS                                    *
*                                                                              *
********************************************************************************

cd U:\  // Set directory
use "NVM_20002014.dta", clear

global baseline = 1      // Estimate the baseline specifications
global adjustment = 0    // Allow for estimation of adjustment effect

set matsize 1000

global house dlogsize drooms dmaintgood dcentralheating dlisted 
global neighbourhood dlogincome dlogpopdens dshforeign dshyoung dshold dhhsize dluinfr dluind dluopens dluwater
global year dyear*

g weight = 0
global dT = 2.5
global c = 7.3

tostring pc4, g(pc2)
replace pc2 = substr(pc2,1,3)
destring pc2, force replace 

g nofe = 1
global fe pc4
global se pc4

xtset $fe

if $baseline == 1 {

	/******************************************************************************/
	/*                     Step 1: Effects on house prices                        */
	/******************************************************************************/
		
	local h3 = 4.3117545 // Obtained from the bandwidth do-file
	local h4 = 3.2287644
	local h5 = 4.6001775
	local h6 = 3.4186368
	
	quietly regress dlogpricesqm dkw $year,  cluster($se), if (inkw == 1 | kwdist > $dT)
	estimates store r1
	quietly regress dlogpricesqm dkw $house $year,  cluster($se), if (inkw == 1 | kwdist > $dT)
	estimates store r2
	quietly regress dlogpricesqm dkw $house $year,  cluster($se), if (inkw == 1 | kwdist > $dT) & (zscore > $c - `h3') & (zscore < $c + `h3') & kwexcl == 0
	estimates store r3
	quietly ivreg2 dlogpricesqm (dkw=dscorerule) $house $year,  cluster($se) endog(dkw), if (inkw == 1 | kwdist > $dT) & (zscore > $c - `h4') & (zscore < $c + `h4')
	estimates store r4
	quietly ivreg2 dlogpricesqm (dkw=dscorerule) $house $year,  cluster($se) endog(dkw), if (inkw == 1 | kwdist > $dT) & (zscore > $c - `h5') & (zscore < $c + `h5') & beforeafter == 0
	estimates store r5
	quietly ivreg2 dlogpricesqm (dkw=dscorerule) $house $neighbourhood $year,  cluster($se) endog(dkw), if (inkw == 1 | kwdist > $dT) & (zscore > $c - `h6') & (zscore < $c + `h6') & beforeafter == 0
	estimates store r6

	quietly regress dkw dscorerule $house $year,  cluster($se) , if (inkw == 1 | kwdist > $dT) & (zscore > $c - `h4') & (zscore < $c + `h4')
	estimates store f1 
	quietly regress dkw dscorerule $house $year, cluster($se) , if (inkw == 1 | kwdist > $dT) & (zscore > $c - `h5') & (zscore < $c + `h5') & beforeafter == 0
	estimates store f2
	quietly regress dkw dscorerule $house $neighbourhood $year, cluster($se) , if (inkw == 1 | kwdist > $dT) & (zscore > $c - `h6') & (zscore < $c + `h6') & beforeafter == 0
	estimates store f3


	/******************************************************************************/
	/*                           Step 3: Export results                           */
	/******************************************************************************/
	
	estimates table f1 f2 f3 , b(%8.3f) se(%8.3f) p(%8.3f) stats(r2 N) keep(dscorerule $house $neighbourhood) title(table 1 - dkw - first stage)
	estimates table r1 r2 r3 r4 r5 r6, b(%8.3f) se(%8.3f) p(%8.3f) stats(r2 N widstat) keep(dkw $house $neighbourhood) title(table 2 - dlogpricesqm)
	*estimates table r7 r8 r9 r10 r11 r12, b(%8.3f) se(%8.3f) p(%8.3f) stats(r2 N widstat) keep(dkw $house $neighbourhood) title(table 2 - dlogdaysonmarket)

	estimates restore r1
	outreg2 using "Results\Table 2", label aster replace word title(Baseline results - first-differences) ctitle(OLS - FD) nocon alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) keep(dkw $house)
	estimates restore r2
	outreg2 using "Results\Table 2", append label aster word ctitle(OLS - FD) nocon alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) keep(dkw $house) 
	estimates restore r3
	outreg2 using "Results\Table 2", append label aster word ctitle(OLS - FD) nocon alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) keep(dkw $house) 
	estimates restore r4
	outreg2 using "Results\Table 2", append label aster nor2 addstat("Kleibergen-Paap F", e(widstat)) word ctitle(IV - FD) nocon alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) keep(dkw $house)  
	estimates restore r5
	outreg2 using "Results\Table 2", append label aster nor2 word ctitle(IV - FD) nocon addstat("Kleibergen-Paap F", e(widstat)) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) keep(dkw $house)   
	estimates restore r6
	outreg2 using "Results\Table 2", append label aster nor2 word ctitle(IV - FD) nocon addstat("Kleibergen-Paap F", e(widstat)) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) keep(dkw $house $neighbourhood )    

	estimates restore f1
	outreg2 using "Results\Table B4", label aster replace word title(Baseline results - first-differences) ctitle(OLS - FD) nocon alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) keep(dscorerule $house)
	estimates restore f2
	outreg2 using "Results\Table B4", append label aster word ctitle(OLS - FD) nocon alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) keep(dscorerule $house)   
	estimates restore f3
	outreg2 using "Results\Table B4", append label aster word ctitle(OLS - FD) nocon alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) keep(dscorerule $house $neighbourhood )     
	
}

if $adjustment == 1 {
	
	
	
	/******************************************************************************/
	/*                     Step 1: Effects on house prices                        */
	/******************************************************************************/
	
	local ha1 = 3.2416011
	local ha2 = 3.25676
	local ha3 = 3.2871129 
	
	ivreg2 dlogpricesqm (dkw ddaysinv=dscorerule ddaysinv_sc) $house $year,  cluster($se) endog(dkw), if (inkw == 1 | kwdist > $dT) & (zscore > $c - `ha1') & (zscore < $c + `ha1')
	estimates store r1
	nlcom (eq0: _b[dkw]+_b[ddaysinv]*0) (eq0_1: _b[dkw]+_b[ddaysinv]*0.1) (eq0_2: _b[dkw]+_b[ddaysinv]*0.2) (eq0_3: _b[dkw]+_b[ddaysinv]*0.3) (eq0_4: _b[dkw]+_b[ddaysinv]*0.4) (eq0_5: _b[dkw]+_b[ddaysinv]*0.5) (eq0_6: _b[dkw]+_b[ddaysinv]*0.6) (eq0_7: _b[dkw]+_b[ddaysinv]*0.7) (eq0_8: _b[dkw]+_b[ddaysinv]*0.8) (eq0_9: _b[dkw]+_b[ddaysinv]*0.9) (eq1: _b[dkw]+_b[ddaysinv]*1) (eq1_1: _b[dkw]+_b[ddaysinv]*1.1) (eq1_2: _b[dkw]+_b[ddaysinv]*1.2) (eq1_3: _b[dkw]+_b[ddaysinv]*1.3) (eq1_4: _b[dkw]+_b[ddaysinv]*1.4) (eq1_5: _b[dkw]+_b[ddaysinv]*1.5) (eq1_6: _b[dkw]+_b[ddaysinv]*1.6) (eq1_7: _b[dkw]+_b[ddaysinv]*1.7) (eq1_8: _b[dkw]+_b[ddaysinv]*1.8) (eq1_9: _b[dkw]+_b[ddaysinv]*1.9) (eq2: _b[dkw]+_b[ddaysinv]*2) (eq2_1: _b[dkw]+_b[ddaysinv]*2.1) (eq2_2: _b[dkw]+_b[ddaysinv]*2.2) (eq2_3: _b[dkw]+_b[ddaysinv]*2.3) (eq2_4: _b[dkw]+_b[ddaysinv]*2.4) (eq2_5: _b[dkw]+_b[ddaysinv]*2.5) (eq2_6: _b[dkw]+_b[ddaysinv]*2.6) (eq2_7: _b[dkw]+_b[ddaysinv]*2.7) (eq2_8: _b[dkw]+_b[ddaysinv]*2.8) (eq2_9: _b[dkw]+_b[ddaysinv]*2.9) (eq3: _b[dkw]+_b[ddaysinv]*3) (eq3_1: _b[dkw]+_b[ddaysinv]*3.1) (eq3_2: _b[dkw]+_b[ddaysinv]*3.2) (eq3_3: _b[dkw]+_b[ddaysinv]*3.3) (eq3_4: _b[dkw]+_b[ddaysinv]*3.4) (eq3_5: _b[dkw]+_b[ddaysinv]*3.5) (eq3_6: _b[dkw]+_b[ddaysinv]*3.6) (eq3_7: _b[dkw]+_b[ddaysinv]*3.7) (eq3_8: _b[dkw]+_b[ddaysinv]*3.8) (eq3_9: _b[dkw]+_b[ddaysinv]*3.9) (eq4: _b[dkw]+_b[ddaysinv]*4) (eq4_1: _b[dkw]+_b[ddaysinv]*4.1) (eq4_2: _b[dkw]+_b[ddaysinv]*4.2) (eq4_3: _b[dkw]+_b[ddaysinv]*4.3) (eq4_4: _b[dkw]+_b[ddaysinv]*4.4) (eq4_5: _b[dkw]+_b[ddaysinv]*4.5) (eq4_6: _b[dkw]+_b[ddaysinv]*4.6) (eq4_7: _b[dkw]+_b[ddaysinv]*4.7) (eq4_8: _b[dkw]+_b[ddaysinv]*4.8) (eq4_9: _b[dkw]+_b[ddaysinv]*4.9) (eq5: _b[dkw]+_b[ddaysinv]*5) (eq5_1: _b[dkw]+_b[ddaysinv]*5.1) (eq5_2: _b[dkw]+_b[ddaysinv]*5.2) (eq5_3: _b[dkw]+_b[ddaysinv]*5.3) (eq5_4: _b[dkw]+_b[ddaysinv]*5.4) (eq5_5: _b[dkw]+_b[ddaysinv]*5.5) (eq5_6: _b[dkw]+_b[ddaysinv]*5.6) (eq5_7: _b[dkw]+_b[ddaysinv]*5.7) (eq5_8: _b[dkw]+_b[ddaysinv]*5.8) (eq5_9: _b[dkw]+_b[ddaysinv]*5.9) (eq6: _b[dkw]+_b[ddaysinv]*6) (eq6_1: _b[dkw]+_b[ddaysinv]*6.1) (eq6_2: _b[dkw]+_b[ddaysinv]*6.2) (eq6_3: _b[dkw]+_b[ddaysinv]*6.3) (eq6_4: _b[dkw]+_b[ddaysinv]*6.4) (eq6_5: _b[dkw]+_b[ddaysinv]*6.5) (eq6_6: _b[dkw]+_b[ddaysinv]*6.6) (eq6_7: _b[dkw]+_b[ddaysinv]*6.7) (eq6_8: _b[dkw]+_b[ddaysinv]*6.8) (eq6_9: _b[dkw]+_b[ddaysinv]*6.9) (eq7: _b[dkw]+_b[ddaysinv]*7) (eq7_1: _b[dkw]+_b[ddaysinv]*7.1) (eq7_2: _b[dkw]+_b[ddaysinv]*7.2) (eq7_3: _b[dkw]+_b[ddaysinv]*7.3) (eq7_4: _b[dkw]+_b[ddaysinv]*7.4) (eq7_5: _b[dkw]+_b[ddaysinv]*7.5), post
	estimates store a1
	
	ivreg2 dlogpricesqm (dkw ddaysinv ddaysinv2=dscorerule ddaysinv_sc ddaysinv2_sc) $house $year,  cluster($se) endog(dkw), if (inkw == 1 | kwdist > $dT) & (zscore > $c - `ha2') & (zscore < $c + `ha2')
	estimates store r2
	nlcom (eq0: _b[dkw]+_b[ddaysinv]*0+_b[ddaysinv2]*0) (eq0_1: _b[dkw]+_b[ddaysinv]*0.1+_b[ddaysinv2]*0.01) (eq0_2: _b[dkw]+_b[ddaysinv]*0.2+_b[ddaysinv2]*0.04) (eq0_3: _b[dkw]+_b[ddaysinv]*0.3+_b[ddaysinv2]*0.09) (eq0_4: _b[dkw]+_b[ddaysinv]*0.4+_b[ddaysinv2]*0.16) (eq0_5: _b[dkw]+_b[ddaysinv]*0.5+_b[ddaysinv2]*0.25) (eq0_6: _b[dkw]+_b[ddaysinv]*0.6+_b[ddaysinv2]*0.36) (eq0_7: _b[dkw]+_b[ddaysinv]*0.7+_b[ddaysinv2]*0.49) (eq0_8: _b[dkw]+_b[ddaysinv]*0.8+_b[ddaysinv2]*0.64) (eq0_9: _b[dkw]+_b[ddaysinv]*0.9+_b[ddaysinv2]*0.81) (eq1: _b[dkw]+_b[ddaysinv]*1+_b[ddaysinv2]*1) (eq1_1: _b[dkw]+_b[ddaysinv]*1.1+_b[ddaysinv2]*1.21) (eq1_2: _b[dkw]+_b[ddaysinv]*1.2+_b[ddaysinv2]*1.44) (eq1_3: _b[dkw]+_b[ddaysinv]*1.3+_b[ddaysinv2]*1.69) (eq1_4: _b[dkw]+_b[ddaysinv]*1.4+_b[ddaysinv2]*1.96) (eq1_5: _b[dkw]+_b[ddaysinv]*1.5+_b[ddaysinv2]*2.25) (eq1_6: _b[dkw]+_b[ddaysinv]*1.6+_b[ddaysinv2]*2.56) (eq1_7: _b[dkw]+_b[ddaysinv]*1.7+_b[ddaysinv2]*2.89) (eq1_8: _b[dkw]+_b[ddaysinv]*1.8+_b[ddaysinv2]*3.24) (eq1_9: _b[dkw]+_b[ddaysinv]*1.9+_b[ddaysinv2]*3.61) (eq2: _b[dkw]+_b[ddaysinv]*2+_b[ddaysinv2]*4) (eq2_1: _b[dkw]+_b[ddaysinv]*2.1+_b[ddaysinv2]*4.41) (eq2_2: _b[dkw]+_b[ddaysinv]*2.2+_b[ddaysinv2]*4.84) (eq2_3: _b[dkw]+_b[ddaysinv]*2.3+_b[ddaysinv2]*5.29) (eq2_4: _b[dkw]+_b[ddaysinv]*2.4+_b[ddaysinv2]*5.76) (eq2_5: _b[dkw]+_b[ddaysinv]*2.5+_b[ddaysinv2]*6.25) (eq2_6: _b[dkw]+_b[ddaysinv]*2.6+_b[ddaysinv2]*6.76) (eq2_7: _b[dkw]+_b[ddaysinv]*2.7+_b[ddaysinv2]*7.29) (eq2_8: _b[dkw]+_b[ddaysinv]*2.8+_b[ddaysinv2]*7.84) (eq2_9: _b[dkw]+_b[ddaysinv]*2.9+_b[ddaysinv2]*8.41) (eq3: _b[dkw]+_b[ddaysinv]*3+_b[ddaysinv2]*9) (eq3_1: _b[dkw]+_b[ddaysinv]*3.1+_b[ddaysinv2]*9.61) (eq3_2: _b[dkw]+_b[ddaysinv]*3.2+_b[ddaysinv2]*10.24) (eq3_3: _b[dkw]+_b[ddaysinv]*3.3+_b[ddaysinv2]*10.89) (eq3_4: _b[dkw]+_b[ddaysinv]*3.4+_b[ddaysinv2]*11.56) (eq3_5: _b[dkw]+_b[ddaysinv]*3.5+_b[ddaysinv2]*12.25) (eq3_6: _b[dkw]+_b[ddaysinv]*3.6+_b[ddaysinv2]*12.96) (eq3_7: _b[dkw]+_b[ddaysinv]*3.7+_b[ddaysinv2]*13.69) (eq3_8: _b[dkw]+_b[ddaysinv]*3.8+_b[ddaysinv2]*14.44) (eq3_9: _b[dkw]+_b[ddaysinv]*3.9+_b[ddaysinv2]*15.21) (eq4: _b[dkw]+_b[ddaysinv]*4+_b[ddaysinv2]*16) (eq4_1: _b[dkw]+_b[ddaysinv]*4.1+_b[ddaysinv2]*16.81) (eq4_2: _b[dkw]+_b[ddaysinv]*4.2+_b[ddaysinv2]*17.64) (eq4_3: _b[dkw]+_b[ddaysinv]*4.3+_b[ddaysinv2]*18.49) (eq4_4: _b[dkw]+_b[ddaysinv]*4.4+_b[ddaysinv2]*19.36) (eq4_5: _b[dkw]+_b[ddaysinv]*4.5+_b[ddaysinv2]*20.25) (eq4_6: _b[dkw]+_b[ddaysinv]*4.6+_b[ddaysinv2]*21.16) (eq4_7: _b[dkw]+_b[ddaysinv]*4.7+_b[ddaysinv2]*22.09) (eq4_8: _b[dkw]+_b[ddaysinv]*4.8+_b[ddaysinv2]*23.04) (eq4_9: _b[dkw]+_b[ddaysinv]*4.9+_b[ddaysinv2]*24.01) (eq5: _b[dkw]+_b[ddaysinv]*5+_b[ddaysinv2]*25) (eq5_1: _b[dkw]+_b[ddaysinv]*5.1+_b[ddaysinv2]*26.01) (eq5_2: _b[dkw]+_b[ddaysinv]*5.2+_b[ddaysinv2]*27.04) (eq5_3: _b[dkw]+_b[ddaysinv]*5.3+_b[ddaysinv2]*28.09) (eq5_4: _b[dkw]+_b[ddaysinv]*5.4+_b[ddaysinv2]*29.16) (eq5_5: _b[dkw]+_b[ddaysinv]*5.5+_b[ddaysinv2]*30.25) (eq5_6: _b[dkw]+_b[ddaysinv]*5.6+_b[ddaysinv2]*31.36) (eq5_7: _b[dkw]+_b[ddaysinv]*5.7+_b[ddaysinv2]*32.49) (eq5_8: _b[dkw]+_b[ddaysinv]*5.8+_b[ddaysinv2]*33.64) (eq5_9: _b[dkw]+_b[ddaysinv]*5.9+_b[ddaysinv2]*34.81) (eq6: _b[dkw]+_b[ddaysinv]*6+_b[ddaysinv2]*36) (eq6_1: _b[dkw]+_b[ddaysinv]*6.1+_b[ddaysinv2]*37.21) (eq6_2: _b[dkw]+_b[ddaysinv]*6.2+_b[ddaysinv2]*38.44) (eq6_3: _b[dkw]+_b[ddaysinv]*6.3+_b[ddaysinv2]*39.69) (eq6_4: _b[dkw]+_b[ddaysinv]*6.4+_b[ddaysinv2]*40.96) (eq6_5: _b[dkw]+_b[ddaysinv]*6.5+_b[ddaysinv2]*42.25) (eq6_6: _b[dkw]+_b[ddaysinv]*6.6+_b[ddaysinv2]*43.56) (eq6_7: _b[dkw]+_b[ddaysinv]*6.7+_b[ddaysinv2]*44.89) (eq6_8: _b[dkw]+_b[ddaysinv]*6.8+_b[ddaysinv2]*46.24) (eq6_9: _b[dkw]+_b[ddaysinv]*6.9+_b[ddaysinv2]*47.61) (eq7: _b[dkw]+_b[ddaysinv]*7+_b[ddaysinv2]*49) (eq7_1: _b[dkw]+_b[ddaysinv]*7.1+_b[ddaysinv2]*50.41) (eq7_2: _b[dkw]+_b[ddaysinv]*7.2+_b[ddaysinv2]*51.84) (eq7_3: _b[dkw]+_b[ddaysinv]*7.3+_b[ddaysinv2]*53.29) (eq7_4: _b[dkw]+_b[ddaysinv]*7.4+_b[ddaysinv2]*54.76) (eq7_5: _b[dkw]+_b[ddaysinv]*7.5+_b[ddaysinv2]*56.25), post
	estimates store a2
	
	ivreg2 dlogpricesqm (dkw_y*= dscorerule_y*) $house $year,  cluster($se), if (inkw == 1 | kwdist > $dT) & (zscore > $c - `ha3') & (zscore < $c + `ha3')
	estimates store r3
	
	*ivreg2 dlogpricesqm (dkw ddaysinv ddaysinv2 ddaysinv3=dscorerule ddaysinv_sc ddaysinv2_sc ddaysinv3_sc) $house $year,  cluster($se) endog(dkw), if (inkw == 1 | kwdist > $dT) & (zscore > $c - `ha3') & (zscore < $c + `ha3')
	*estimates store r2
	*nlcom (eq0: _b[dkw]+_b[ddaysinv]*0+_b[ddaysinv2]*0+_b[ddaysinv3]*0) (eq0_1: _b[dkw]+_b[ddaysinv]*0.1+_b[ddaysinv2]*0.01+_b[ddaysinv3]*0.001) (eq0_2: _b[dkw]+_b[ddaysinv]*0.2+_b[ddaysinv2]*0.04+_b[ddaysinv3]*0.008) (eq0_3: _b[dkw]+_b[ddaysinv]*0.3+_b[ddaysinv2]*0.09+_b[ddaysinv3]*0.027) (eq0_4: _b[dkw]+_b[ddaysinv]*0.4+_b[ddaysinv2]*0.16+_b[ddaysinv3]*0.064) (eq0_5: _b[dkw]+_b[ddaysinv]*0.5+_b[ddaysinv2]*0.25+_b[ddaysinv3]*0.125) (eq0_6: _b[dkw]+_b[ddaysinv]*0.6+_b[ddaysinv2]*0.36+_b[ddaysinv3]*0.216) (eq0_7: _b[dkw]+_b[ddaysinv]*0.7+_b[ddaysinv2]*0.49+_b[ddaysinv3]*0.343) (eq0_8: _b[dkw]+_b[ddaysinv]*0.8+_b[ddaysinv2]*0.64+_b[ddaysinv3]*0.512) (eq0_9: _b[dkw]+_b[ddaysinv]*0.9+_b[ddaysinv2]*0.81+_b[ddaysinv3]*0.729) (eq1: _b[dkw]+_b[ddaysinv]*1+_b[ddaysinv2]*1+_b[ddaysinv3]*1) (eq1_1: _b[dkw]+_b[ddaysinv]*1.1+_b[ddaysinv2]*1.21+_b[ddaysinv3]*1.331) (eq1_2: _b[dkw]+_b[ddaysinv]*1.2+_b[ddaysinv2]*1.44+_b[ddaysinv3]*1.728) (eq1_3: _b[dkw]+_b[ddaysinv]*1.3+_b[ddaysinv2]*1.69+_b[ddaysinv3]*2.197) (eq1_4: _b[dkw]+_b[ddaysinv]*1.4+_b[ddaysinv2]*1.96+_b[ddaysinv3]*2.744) (eq1_5: _b[dkw]+_b[ddaysinv]*1.5+_b[ddaysinv2]*2.25+_b[ddaysinv3]*3.375) (eq1_6: _b[dkw]+_b[ddaysinv]*1.6+_b[ddaysinv2]*2.56+_b[ddaysinv3]*4.096) (eq1_7: _b[dkw]+_b[ddaysinv]*1.7+_b[ddaysinv2]*2.89+_b[ddaysinv3]*4.913) (eq1_8: _b[dkw]+_b[ddaysinv]*1.8+_b[ddaysinv2]*3.24+_b[ddaysinv3]*5.832) (eq1_9: _b[dkw]+_b[ddaysinv]*1.9+_b[ddaysinv2]*3.61+_b[ddaysinv3]*6.859) (eq2: _b[dkw]+_b[ddaysinv]*2+_b[ddaysinv2]*4+_b[ddaysinv3]*8) (eq2_1: _b[dkw]+_b[ddaysinv]*2.1+_b[ddaysinv2]*4.41+_b[ddaysinv3]*9.261) (eq2_2: _b[dkw]+_b[ddaysinv]*2.2+_b[ddaysinv2]*4.84+_b[ddaysinv3]*10.648) (eq2_3: _b[dkw]+_b[ddaysinv]*2.3+_b[ddaysinv2]*5.29+_b[ddaysinv3]*12.167) (eq2_4: _b[dkw]+_b[ddaysinv]*2.4+_b[ddaysinv2]*5.76+_b[ddaysinv3]*13.824) (eq2_5: _b[dkw]+_b[ddaysinv]*2.5+_b[ddaysinv2]*6.25+_b[ddaysinv3]*15.625) (eq2_6: _b[dkw]+_b[ddaysinv]*2.6+_b[ddaysinv2]*6.76+_b[ddaysinv3]*17.576) (eq2_7: _b[dkw]+_b[ddaysinv]*2.7+_b[ddaysinv2]*7.29+_b[ddaysinv3]*19.683) (eq2_8: _b[dkw]+_b[ddaysinv]*2.8+_b[ddaysinv2]*7.84+_b[ddaysinv3]*21.952) (eq2_9: _b[dkw]+_b[ddaysinv]*2.9+_b[ddaysinv2]*8.41+_b[ddaysinv3]*24.389) (eq3: _b[dkw]+_b[ddaysinv]*3+_b[ddaysinv2]*9+_b[ddaysinv3]*27) (eq3_1: _b[dkw]+_b[ddaysinv]*3.1+_b[ddaysinv2]*9.61+_b[ddaysinv3]*29.791) (eq3_2: _b[dkw]+_b[ddaysinv]*3.2+_b[ddaysinv2]*10.24+_b[ddaysinv3]*32.768) (eq3_3: _b[dkw]+_b[ddaysinv]*3.3+_b[ddaysinv2]*10.89+_b[ddaysinv3]*35.937) (eq3_4: _b[dkw]+_b[ddaysinv]*3.4+_b[ddaysinv2]*11.56+_b[ddaysinv3]*39.304) (eq3_5: _b[dkw]+_b[ddaysinv]*3.5+_b[ddaysinv2]*12.25+_b[ddaysinv3]*42.875) (eq3_6: _b[dkw]+_b[ddaysinv]*3.6+_b[ddaysinv2]*12.96+_b[ddaysinv3]*46.656) (eq3_7: _b[dkw]+_b[ddaysinv]*3.7+_b[ddaysinv2]*13.69+_b[ddaysinv3]*50.653) (eq3_8: _b[dkw]+_b[ddaysinv]*3.8+_b[ddaysinv2]*14.44+_b[ddaysinv3]*54.872) (eq3_9: _b[dkw]+_b[ddaysinv]*3.9+_b[ddaysinv2]*15.21+_b[ddaysinv3]*59.319) (eq4: _b[dkw]+_b[ddaysinv]*4+_b[ddaysinv2]*16+_b[ddaysinv3]*64) (eq4_1: _b[dkw]+_b[ddaysinv]*4.1+_b[ddaysinv2]*16.81+_b[ddaysinv3]*68.921) (eq4_2: _b[dkw]+_b[ddaysinv]*4.2+_b[ddaysinv2]*17.64+_b[ddaysinv3]*74.088) (eq4_3: _b[dkw]+_b[ddaysinv]*4.3+_b[ddaysinv2]*18.49+_b[ddaysinv3]*79.507) (eq4_4: _b[dkw]+_b[ddaysinv]*4.4+_b[ddaysinv2]*19.36+_b[ddaysinv3]*85.184) (eq4_5: _b[dkw]+_b[ddaysinv]*4.5+_b[ddaysinv2]*20.25+_b[ddaysinv3]*91.125) (eq4_6: _b[dkw]+_b[ddaysinv]*4.6+_b[ddaysinv2]*21.16+_b[ddaysinv3]*97.336) (eq4_7: _b[dkw]+_b[ddaysinv]*4.7+_b[ddaysinv2]*22.09+_b[ddaysinv3]*103.823) (eq4_8: _b[dkw]+_b[ddaysinv]*4.8+_b[ddaysinv2]*23.04+_b[ddaysinv3]*110.592) (eq4_9: _b[dkw]+_b[ddaysinv]*4.9+_b[ddaysinv2]*24.01+_b[ddaysinv3]*117.649) (eq5: _b[dkw]+_b[ddaysinv]*5+_b[ddaysinv2]*25+_b[ddaysinv3]*125) (eq5_1: _b[dkw]+_b[ddaysinv]*5.1+_b[ddaysinv2]*26.01+_b[ddaysinv3]*132.651) (eq5_2: _b[dkw]+_b[ddaysinv]*5.2+_b[ddaysinv2]*27.04+_b[ddaysinv3]*140.608) (eq5_3: _b[dkw]+_b[ddaysinv]*5.3+_b[ddaysinv2]*28.09+_b[ddaysinv3]*148.877) (eq5_4: _b[dkw]+_b[ddaysinv]*5.4+_b[ddaysinv2]*29.16+_b[ddaysinv3]*157.464) (eq5_5: _b[dkw]+_b[ddaysinv]*5.5+_b[ddaysinv2]*30.25+_b[ddaysinv3]*166.375) (eq5_6: _b[dkw]+_b[ddaysinv]*5.6+_b[ddaysinv2]*31.36+_b[ddaysinv3]*175.616) (eq5_7: _b[dkw]+_b[ddaysinv]*5.7+_b[ddaysinv2]*32.49+_b[ddaysinv3]*185.193) (eq5_8: _b[dkw]+_b[ddaysinv]*5.8+_b[ddaysinv2]*33.64+_b[ddaysinv3]*195.112) (eq5_9: _b[dkw]+_b[ddaysinv]*5.9+_b[ddaysinv2]*34.81+_b[ddaysinv3]*205.379) (eq6: _b[dkw]+_b[ddaysinv]*6+_b[ddaysinv2]*36+_b[ddaysinv3]*216) (eq6_1: _b[dkw]+_b[ddaysinv]*6.1+_b[ddaysinv2]*37.21+_b[ddaysinv3]*226.981) (eq6_2: _b[dkw]+_b[ddaysinv]*6.2+_b[ddaysinv2]*38.44+_b[ddaysinv3]*238.328) (eq6_3: _b[dkw]+_b[ddaysinv]*6.3+_b[ddaysinv2]*39.69+_b[ddaysinv3]*250.047) (eq6_4: _b[dkw]+_b[ddaysinv]*6.4+_b[ddaysinv2]*40.96+_b[ddaysinv3]*262.144) (eq6_5: _b[dkw]+_b[ddaysinv]*6.5+_b[ddaysinv2]*42.25+_b[ddaysinv3]*274.625) (eq6_6: _b[dkw]+_b[ddaysinv]*6.6+_b[ddaysinv2]*43.56+_b[ddaysinv3]*287.496) (eq6_7: _b[dkw]+_b[ddaysinv]*6.7+_b[ddaysinv2]*44.89+_b[ddaysinv3]*300.763) (eq6_8: _b[dkw]+_b[ddaysinv]*6.8+_b[ddaysinv2]*46.24+_b[ddaysinv3]*314.432) (eq6_9: _b[dkw]+_b[ddaysinv]*6.9+_b[ddaysinv2]*47.61+_b[ddaysinv3]*328.509) (eq7: _b[dkw]+_b[ddaysinv]*7+_b[ddaysinv2]*49+_b[ddaysinv3]*343) (eq7_1: _b[dkw]+_b[ddaysinv]*7.1+_b[ddaysinv2]*50.41+_b[ddaysinv3]*357.911) (eq7_2: _b[dkw]+_b[ddaysinv]*7.2+_b[ddaysinv2]*51.84+_b[ddaysinv3]*373.248) (eq7_3: _b[dkw]+_b[ddaysinv]*7.3+_b[ddaysinv2]*53.29+_b[ddaysinv3]*389.017) (eq7_4: _b[dkw]+_b[ddaysinv]*7.4+_b[ddaysinv2]*54.76+_b[ddaysinv3]*405.224) (eq7_5: _b[dkw]+_b[ddaysinv]*7.5+_b[ddaysinv2]*56.25+_b[ddaysinv3]*421.875), post
	*estimates store a3
	
	/******************************************************************************/
	/*                   Step 2: Effects on days on the market                    */
	/******************************************************************************/
	
	local ha1 = 6.2193224
	local ha2 = 6.2114959
	local ha3 = 6.1443208 
	
	ivreg2 dlogdaysonmarket (dkw ddaysinv=dscorerule ddaysinv_sc) $house $year,  cluster($se) endog(dkw), if (inkw == 1 | kwdist > $dT) & (zscore > $c - `ha1') & (zscore < $c + `ha1')
	estimates store r4
	nlcom (eq0: _b[dkw]+_b[ddaysinv]*0) (eq0_1: _b[dkw]+_b[ddaysinv]*0.1) (eq0_2: _b[dkw]+_b[ddaysinv]*0.2) (eq0_3: _b[dkw]+_b[ddaysinv]*0.3) (eq0_4: _b[dkw]+_b[ddaysinv]*0.4) (eq0_5: _b[dkw]+_b[ddaysinv]*0.5) (eq0_6: _b[dkw]+_b[ddaysinv]*0.6) (eq0_7: _b[dkw]+_b[ddaysinv]*0.7) (eq0_8: _b[dkw]+_b[ddaysinv]*0.8) (eq0_9: _b[dkw]+_b[ddaysinv]*0.9) (eq1: _b[dkw]+_b[ddaysinv]*1) (eq1_1: _b[dkw]+_b[ddaysinv]*1.1) (eq1_2: _b[dkw]+_b[ddaysinv]*1.2) (eq1_3: _b[dkw]+_b[ddaysinv]*1.3) (eq1_4: _b[dkw]+_b[ddaysinv]*1.4) (eq1_5: _b[dkw]+_b[ddaysinv]*1.5) (eq1_6: _b[dkw]+_b[ddaysinv]*1.6) (eq1_7: _b[dkw]+_b[ddaysinv]*1.7) (eq1_8: _b[dkw]+_b[ddaysinv]*1.8) (eq1_9: _b[dkw]+_b[ddaysinv]*1.9) (eq2: _b[dkw]+_b[ddaysinv]*2) (eq2_1: _b[dkw]+_b[ddaysinv]*2.1) (eq2_2: _b[dkw]+_b[ddaysinv]*2.2) (eq2_3: _b[dkw]+_b[ddaysinv]*2.3) (eq2_4: _b[dkw]+_b[ddaysinv]*2.4) (eq2_5: _b[dkw]+_b[ddaysinv]*2.5) (eq2_6: _b[dkw]+_b[ddaysinv]*2.6) (eq2_7: _b[dkw]+_b[ddaysinv]*2.7) (eq2_8: _b[dkw]+_b[ddaysinv]*2.8) (eq2_9: _b[dkw]+_b[ddaysinv]*2.9) (eq3: _b[dkw]+_b[ddaysinv]*3) (eq3_1: _b[dkw]+_b[ddaysinv]*3.1) (eq3_2: _b[dkw]+_b[ddaysinv]*3.2) (eq3_3: _b[dkw]+_b[ddaysinv]*3.3) (eq3_4: _b[dkw]+_b[ddaysinv]*3.4) (eq3_5: _b[dkw]+_b[ddaysinv]*3.5) (eq3_6: _b[dkw]+_b[ddaysinv]*3.6) (eq3_7: _b[dkw]+_b[ddaysinv]*3.7) (eq3_8: _b[dkw]+_b[ddaysinv]*3.8) (eq3_9: _b[dkw]+_b[ddaysinv]*3.9) (eq4: _b[dkw]+_b[ddaysinv]*4) (eq4_1: _b[dkw]+_b[ddaysinv]*4.1) (eq4_2: _b[dkw]+_b[ddaysinv]*4.2) (eq4_3: _b[dkw]+_b[ddaysinv]*4.3) (eq4_4: _b[dkw]+_b[ddaysinv]*4.4) (eq4_5: _b[dkw]+_b[ddaysinv]*4.5) (eq4_6: _b[dkw]+_b[ddaysinv]*4.6) (eq4_7: _b[dkw]+_b[ddaysinv]*4.7) (eq4_8: _b[dkw]+_b[ddaysinv]*4.8) (eq4_9: _b[dkw]+_b[ddaysinv]*4.9) (eq5: _b[dkw]+_b[ddaysinv]*5) (eq5_1: _b[dkw]+_b[ddaysinv]*5.1) (eq5_2: _b[dkw]+_b[ddaysinv]*5.2) (eq5_3: _b[dkw]+_b[ddaysinv]*5.3) (eq5_4: _b[dkw]+_b[ddaysinv]*5.4) (eq5_5: _b[dkw]+_b[ddaysinv]*5.5) (eq5_6: _b[dkw]+_b[ddaysinv]*5.6) (eq5_7: _b[dkw]+_b[ddaysinv]*5.7) (eq5_8: _b[dkw]+_b[ddaysinv]*5.8) (eq5_9: _b[dkw]+_b[ddaysinv]*5.9) (eq6: _b[dkw]+_b[ddaysinv]*6) (eq6_1: _b[dkw]+_b[ddaysinv]*6.1) (eq6_2: _b[dkw]+_b[ddaysinv]*6.2) (eq6_3: _b[dkw]+_b[ddaysinv]*6.3) (eq6_4: _b[dkw]+_b[ddaysinv]*6.4) (eq6_5: _b[dkw]+_b[ddaysinv]*6.5) (eq6_6: _b[dkw]+_b[ddaysinv]*6.6) (eq6_7: _b[dkw]+_b[ddaysinv]*6.7) (eq6_8: _b[dkw]+_b[ddaysinv]*6.8) (eq6_9: _b[dkw]+_b[ddaysinv]*6.9) (eq7: _b[dkw]+_b[ddaysinv]*7) (eq7_1: _b[dkw]+_b[ddaysinv]*7.1) (eq7_2: _b[dkw]+_b[ddaysinv]*7.2) (eq7_3: _b[dkw]+_b[ddaysinv]*7.3) (eq7_4: _b[dkw]+_b[ddaysinv]*7.4) (eq7_5: _b[dkw]+_b[ddaysinv]*7.5), post
	estimates store a4
	
	ivreg2 dlogdaysonmarket (dkw ddaysinv ddaysinv2=dscorerule ddaysinv_sc ddaysinv2_sc) $house $year,  cluster($se) endog(dkw), if (inkw == 1 | kwdist > $dT) & (zscore > $c - `ha2') & (zscore < $c + `ha2')
	estimates store r5
	nlcom (eq0: _b[dkw]+_b[ddaysinv]*0+_b[ddaysinv2]*0) (eq0_1: _b[dkw]+_b[ddaysinv]*0.1+_b[ddaysinv2]*0.01) (eq0_2: _b[dkw]+_b[ddaysinv]*0.2+_b[ddaysinv2]*0.04) (eq0_3: _b[dkw]+_b[ddaysinv]*0.3+_b[ddaysinv2]*0.09) (eq0_4: _b[dkw]+_b[ddaysinv]*0.4+_b[ddaysinv2]*0.16) (eq0_5: _b[dkw]+_b[ddaysinv]*0.5+_b[ddaysinv2]*0.25) (eq0_6: _b[dkw]+_b[ddaysinv]*0.6+_b[ddaysinv2]*0.36) (eq0_7: _b[dkw]+_b[ddaysinv]*0.7+_b[ddaysinv2]*0.49) (eq0_8: _b[dkw]+_b[ddaysinv]*0.8+_b[ddaysinv2]*0.64) (eq0_9: _b[dkw]+_b[ddaysinv]*0.9+_b[ddaysinv2]*0.81) (eq1: _b[dkw]+_b[ddaysinv]*1+_b[ddaysinv2]*1) (eq1_1: _b[dkw]+_b[ddaysinv]*1.1+_b[ddaysinv2]*1.21) (eq1_2: _b[dkw]+_b[ddaysinv]*1.2+_b[ddaysinv2]*1.44) (eq1_3: _b[dkw]+_b[ddaysinv]*1.3+_b[ddaysinv2]*1.69) (eq1_4: _b[dkw]+_b[ddaysinv]*1.4+_b[ddaysinv2]*1.96) (eq1_5: _b[dkw]+_b[ddaysinv]*1.5+_b[ddaysinv2]*2.25) (eq1_6: _b[dkw]+_b[ddaysinv]*1.6+_b[ddaysinv2]*2.56) (eq1_7: _b[dkw]+_b[ddaysinv]*1.7+_b[ddaysinv2]*2.89) (eq1_8: _b[dkw]+_b[ddaysinv]*1.8+_b[ddaysinv2]*3.24) (eq1_9: _b[dkw]+_b[ddaysinv]*1.9+_b[ddaysinv2]*3.61) (eq2: _b[dkw]+_b[ddaysinv]*2+_b[ddaysinv2]*4) (eq2_1: _b[dkw]+_b[ddaysinv]*2.1+_b[ddaysinv2]*4.41) (eq2_2: _b[dkw]+_b[ddaysinv]*2.2+_b[ddaysinv2]*4.84) (eq2_3: _b[dkw]+_b[ddaysinv]*2.3+_b[ddaysinv2]*5.29) (eq2_4: _b[dkw]+_b[ddaysinv]*2.4+_b[ddaysinv2]*5.76) (eq2_5: _b[dkw]+_b[ddaysinv]*2.5+_b[ddaysinv2]*6.25) (eq2_6: _b[dkw]+_b[ddaysinv]*2.6+_b[ddaysinv2]*6.76) (eq2_7: _b[dkw]+_b[ddaysinv]*2.7+_b[ddaysinv2]*7.29) (eq2_8: _b[dkw]+_b[ddaysinv]*2.8+_b[ddaysinv2]*7.84) (eq2_9: _b[dkw]+_b[ddaysinv]*2.9+_b[ddaysinv2]*8.41) (eq3: _b[dkw]+_b[ddaysinv]*3+_b[ddaysinv2]*9) (eq3_1: _b[dkw]+_b[ddaysinv]*3.1+_b[ddaysinv2]*9.61) (eq3_2: _b[dkw]+_b[ddaysinv]*3.2+_b[ddaysinv2]*10.24) (eq3_3: _b[dkw]+_b[ddaysinv]*3.3+_b[ddaysinv2]*10.89) (eq3_4: _b[dkw]+_b[ddaysinv]*3.4+_b[ddaysinv2]*11.56) (eq3_5: _b[dkw]+_b[ddaysinv]*3.5+_b[ddaysinv2]*12.25) (eq3_6: _b[dkw]+_b[ddaysinv]*3.6+_b[ddaysinv2]*12.96) (eq3_7: _b[dkw]+_b[ddaysinv]*3.7+_b[ddaysinv2]*13.69) (eq3_8: _b[dkw]+_b[ddaysinv]*3.8+_b[ddaysinv2]*14.44) (eq3_9: _b[dkw]+_b[ddaysinv]*3.9+_b[ddaysinv2]*15.21) (eq4: _b[dkw]+_b[ddaysinv]*4+_b[ddaysinv2]*16) (eq4_1: _b[dkw]+_b[ddaysinv]*4.1+_b[ddaysinv2]*16.81) (eq4_2: _b[dkw]+_b[ddaysinv]*4.2+_b[ddaysinv2]*17.64) (eq4_3: _b[dkw]+_b[ddaysinv]*4.3+_b[ddaysinv2]*18.49) (eq4_4: _b[dkw]+_b[ddaysinv]*4.4+_b[ddaysinv2]*19.36) (eq4_5: _b[dkw]+_b[ddaysinv]*4.5+_b[ddaysinv2]*20.25) (eq4_6: _b[dkw]+_b[ddaysinv]*4.6+_b[ddaysinv2]*21.16) (eq4_7: _b[dkw]+_b[ddaysinv]*4.7+_b[ddaysinv2]*22.09) (eq4_8: _b[dkw]+_b[ddaysinv]*4.8+_b[ddaysinv2]*23.04) (eq4_9: _b[dkw]+_b[ddaysinv]*4.9+_b[ddaysinv2]*24.01) (eq5: _b[dkw]+_b[ddaysinv]*5+_b[ddaysinv2]*25) (eq5_1: _b[dkw]+_b[ddaysinv]*5.1+_b[ddaysinv2]*26.01) (eq5_2: _b[dkw]+_b[ddaysinv]*5.2+_b[ddaysinv2]*27.04) (eq5_3: _b[dkw]+_b[ddaysinv]*5.3+_b[ddaysinv2]*28.09) (eq5_4: _b[dkw]+_b[ddaysinv]*5.4+_b[ddaysinv2]*29.16) (eq5_5: _b[dkw]+_b[ddaysinv]*5.5+_b[ddaysinv2]*30.25) (eq5_6: _b[dkw]+_b[ddaysinv]*5.6+_b[ddaysinv2]*31.36) (eq5_7: _b[dkw]+_b[ddaysinv]*5.7+_b[ddaysinv2]*32.49) (eq5_8: _b[dkw]+_b[ddaysinv]*5.8+_b[ddaysinv2]*33.64) (eq5_9: _b[dkw]+_b[ddaysinv]*5.9+_b[ddaysinv2]*34.81) (eq6: _b[dkw]+_b[ddaysinv]*6+_b[ddaysinv2]*36) (eq6_1: _b[dkw]+_b[ddaysinv]*6.1+_b[ddaysinv2]*37.21) (eq6_2: _b[dkw]+_b[ddaysinv]*6.2+_b[ddaysinv2]*38.44) (eq6_3: _b[dkw]+_b[ddaysinv]*6.3+_b[ddaysinv2]*39.69) (eq6_4: _b[dkw]+_b[ddaysinv]*6.4+_b[ddaysinv2]*40.96) (eq6_5: _b[dkw]+_b[ddaysinv]*6.5+_b[ddaysinv2]*42.25) (eq6_6: _b[dkw]+_b[ddaysinv]*6.6+_b[ddaysinv2]*43.56) (eq6_7: _b[dkw]+_b[ddaysinv]*6.7+_b[ddaysinv2]*44.89) (eq6_8: _b[dkw]+_b[ddaysinv]*6.8+_b[ddaysinv2]*46.24) (eq6_9: _b[dkw]+_b[ddaysinv]*6.9+_b[ddaysinv2]*47.61) (eq7: _b[dkw]+_b[ddaysinv]*7+_b[ddaysinv2]*49) (eq7_1: _b[dkw]+_b[ddaysinv]*7.1+_b[ddaysinv2]*50.41) (eq7_2: _b[dkw]+_b[ddaysinv]*7.2+_b[ddaysinv2]*51.84) (eq7_3: _b[dkw]+_b[ddaysinv]*7.3+_b[ddaysinv2]*53.29) (eq7_4: _b[dkw]+_b[ddaysinv]*7.4+_b[ddaysinv2]*54.76) (eq7_5: _b[dkw]+_b[ddaysinv]*7.5+_b[ddaysinv2]*56.25), post
	estimates store a5
	
	ivreg2 dlogdaysonmarket (dkw_y*= dscorerule_y*) $house $year,  cluster($se), if (inkw == 1 | kwdist > $dT) & (zscore > $c - `ha3') & (zscore < $c + `ha3')
	estimates store r6
	
	*ivreg2 dlogdaysonmarket (dkw ddaysinv ddaysinv2 ddaysinv3=dscorerule ddaysinv_sc ddaysinv2_sc ddaysinv3_sc) $house $year,  cluster($se) endog(dkw), if (inkw == 1 | kwdist > $dT) & (zscore > $c - `ha3') & (zscore < $c + `ha3')
	*estimates store r6
	*nlcom (eq0: _b[dkw]+_b[ddaysinv]*0+_b[ddaysinv2]*0+_b[ddaysinv3]*0) (eq0_1: _b[dkw]+_b[ddaysinv]*0.1+_b[ddaysinv2]*0.01+_b[ddaysinv3]*0.001) (eq0_2: _b[dkw]+_b[ddaysinv]*0.2+_b[ddaysinv2]*0.04+_b[ddaysinv3]*0.008) (eq0_3: _b[dkw]+_b[ddaysinv]*0.3+_b[ddaysinv2]*0.09+_b[ddaysinv3]*0.027) (eq0_4: _b[dkw]+_b[ddaysinv]*0.4+_b[ddaysinv2]*0.16+_b[ddaysinv3]*0.064) (eq0_5: _b[dkw]+_b[ddaysinv]*0.5+_b[ddaysinv2]*0.25+_b[ddaysinv3]*0.125) (eq0_6: _b[dkw]+_b[ddaysinv]*0.6+_b[ddaysinv2]*0.36+_b[ddaysinv3]*0.216) (eq0_7: _b[dkw]+_b[ddaysinv]*0.7+_b[ddaysinv2]*0.49+_b[ddaysinv3]*0.343) (eq0_8: _b[dkw]+_b[ddaysinv]*0.8+_b[ddaysinv2]*0.64+_b[ddaysinv3]*0.512) (eq0_9: _b[dkw]+_b[ddaysinv]*0.9+_b[ddaysinv2]*0.81+_b[ddaysinv3]*0.729) (eq1: _b[dkw]+_b[ddaysinv]*1+_b[ddaysinv2]*1+_b[ddaysinv3]*1) (eq1_1: _b[dkw]+_b[ddaysinv]*1.1+_b[ddaysinv2]*1.21+_b[ddaysinv3]*1.331) (eq1_2: _b[dkw]+_b[ddaysinv]*1.2+_b[ddaysinv2]*1.44+_b[ddaysinv3]*1.728) (eq1_3: _b[dkw]+_b[ddaysinv]*1.3+_b[ddaysinv2]*1.69+_b[ddaysinv3]*2.197) (eq1_4: _b[dkw]+_b[ddaysinv]*1.4+_b[ddaysinv2]*1.96+_b[ddaysinv3]*2.744) (eq1_5: _b[dkw]+_b[ddaysinv]*1.5+_b[ddaysinv2]*2.25+_b[ddaysinv3]*3.375) (eq1_6: _b[dkw]+_b[ddaysinv]*1.6+_b[ddaysinv2]*2.56+_b[ddaysinv3]*4.096) (eq1_7: _b[dkw]+_b[ddaysinv]*1.7+_b[ddaysinv2]*2.89+_b[ddaysinv3]*4.913) (eq1_8: _b[dkw]+_b[ddaysinv]*1.8+_b[ddaysinv2]*3.24+_b[ddaysinv3]*5.832) (eq1_9: _b[dkw]+_b[ddaysinv]*1.9+_b[ddaysinv2]*3.61+_b[ddaysinv3]*6.859) (eq2: _b[dkw]+_b[ddaysinv]*2+_b[ddaysinv2]*4+_b[ddaysinv3]*8) (eq2_1: _b[dkw]+_b[ddaysinv]*2.1+_b[ddaysinv2]*4.41+_b[ddaysinv3]*9.261) (eq2_2: _b[dkw]+_b[ddaysinv]*2.2+_b[ddaysinv2]*4.84+_b[ddaysinv3]*10.648) (eq2_3: _b[dkw]+_b[ddaysinv]*2.3+_b[ddaysinv2]*5.29+_b[ddaysinv3]*12.167) (eq2_4: _b[dkw]+_b[ddaysinv]*2.4+_b[ddaysinv2]*5.76+_b[ddaysinv3]*13.824) (eq2_5: _b[dkw]+_b[ddaysinv]*2.5+_b[ddaysinv2]*6.25+_b[ddaysinv3]*15.625) (eq2_6: _b[dkw]+_b[ddaysinv]*2.6+_b[ddaysinv2]*6.76+_b[ddaysinv3]*17.576) (eq2_7: _b[dkw]+_b[ddaysinv]*2.7+_b[ddaysinv2]*7.29+_b[ddaysinv3]*19.683) (eq2_8: _b[dkw]+_b[ddaysinv]*2.8+_b[ddaysinv2]*7.84+_b[ddaysinv3]*21.952) (eq2_9: _b[dkw]+_b[ddaysinv]*2.9+_b[ddaysinv2]*8.41+_b[ddaysinv3]*24.389) (eq3: _b[dkw]+_b[ddaysinv]*3+_b[ddaysinv2]*9+_b[ddaysinv3]*27) (eq3_1: _b[dkw]+_b[ddaysinv]*3.1+_b[ddaysinv2]*9.61+_b[ddaysinv3]*29.791) (eq3_2: _b[dkw]+_b[ddaysinv]*3.2+_b[ddaysinv2]*10.24+_b[ddaysinv3]*32.768) (eq3_3: _b[dkw]+_b[ddaysinv]*3.3+_b[ddaysinv2]*10.89+_b[ddaysinv3]*35.937) (eq3_4: _b[dkw]+_b[ddaysinv]*3.4+_b[ddaysinv2]*11.56+_b[ddaysinv3]*39.304) (eq3_5: _b[dkw]+_b[ddaysinv]*3.5+_b[ddaysinv2]*12.25+_b[ddaysinv3]*42.875) (eq3_6: _b[dkw]+_b[ddaysinv]*3.6+_b[ddaysinv2]*12.96+_b[ddaysinv3]*46.656) (eq3_7: _b[dkw]+_b[ddaysinv]*3.7+_b[ddaysinv2]*13.69+_b[ddaysinv3]*50.653) (eq3_8: _b[dkw]+_b[ddaysinv]*3.8+_b[ddaysinv2]*14.44+_b[ddaysinv3]*54.872) (eq3_9: _b[dkw]+_b[ddaysinv]*3.9+_b[ddaysinv2]*15.21+_b[ddaysinv3]*59.319) (eq4: _b[dkw]+_b[ddaysinv]*4+_b[ddaysinv2]*16+_b[ddaysinv3]*64) (eq4_1: _b[dkw]+_b[ddaysinv]*4.1+_b[ddaysinv2]*16.81+_b[ddaysinv3]*68.921) (eq4_2: _b[dkw]+_b[ddaysinv]*4.2+_b[ddaysinv2]*17.64+_b[ddaysinv3]*74.088) (eq4_3: _b[dkw]+_b[ddaysinv]*4.3+_b[ddaysinv2]*18.49+_b[ddaysinv3]*79.507) (eq4_4: _b[dkw]+_b[ddaysinv]*4.4+_b[ddaysinv2]*19.36+_b[ddaysinv3]*85.184) (eq4_5: _b[dkw]+_b[ddaysinv]*4.5+_b[ddaysinv2]*20.25+_b[ddaysinv3]*91.125) (eq4_6: _b[dkw]+_b[ddaysinv]*4.6+_b[ddaysinv2]*21.16+_b[ddaysinv3]*97.336) (eq4_7: _b[dkw]+_b[ddaysinv]*4.7+_b[ddaysinv2]*22.09+_b[ddaysinv3]*103.823) (eq4_8: _b[dkw]+_b[ddaysinv]*4.8+_b[ddaysinv2]*23.04+_b[ddaysinv3]*110.592) (eq4_9: _b[dkw]+_b[ddaysinv]*4.9+_b[ddaysinv2]*24.01+_b[ddaysinv3]*117.649) (eq5: _b[dkw]+_b[ddaysinv]*5+_b[ddaysinv2]*25+_b[ddaysinv3]*125) (eq5_1: _b[dkw]+_b[ddaysinv]*5.1+_b[ddaysinv2]*26.01+_b[ddaysinv3]*132.651) (eq5_2: _b[dkw]+_b[ddaysinv]*5.2+_b[ddaysinv2]*27.04+_b[ddaysinv3]*140.608) (eq5_3: _b[dkw]+_b[ddaysinv]*5.3+_b[ddaysinv2]*28.09+_b[ddaysinv3]*148.877) (eq5_4: _b[dkw]+_b[ddaysinv]*5.4+_b[ddaysinv2]*29.16+_b[ddaysinv3]*157.464) (eq5_5: _b[dkw]+_b[ddaysinv]*5.5+_b[ddaysinv2]*30.25+_b[ddaysinv3]*166.375) (eq5_6: _b[dkw]+_b[ddaysinv]*5.6+_b[ddaysinv2]*31.36+_b[ddaysinv3]*175.616) (eq5_7: _b[dkw]+_b[ddaysinv]*5.7+_b[ddaysinv2]*32.49+_b[ddaysinv3]*185.193) (eq5_8: _b[dkw]+_b[ddaysinv]*5.8+_b[ddaysinv2]*33.64+_b[ddaysinv3]*195.112) (eq5_9: _b[dkw]+_b[ddaysinv]*5.9+_b[ddaysinv2]*34.81+_b[ddaysinv3]*205.379) (eq6: _b[dkw]+_b[ddaysinv]*6+_b[ddaysinv2]*36+_b[ddaysinv3]*216) (eq6_1: _b[dkw]+_b[ddaysinv]*6.1+_b[ddaysinv2]*37.21+_b[ddaysinv3]*226.981) (eq6_2: _b[dkw]+_b[ddaysinv]*6.2+_b[ddaysinv2]*38.44+_b[ddaysinv3]*238.328) (eq6_3: _b[dkw]+_b[ddaysinv]*6.3+_b[ddaysinv2]*39.69+_b[ddaysinv3]*250.047) (eq6_4: _b[dkw]+_b[ddaysinv]*6.4+_b[ddaysinv2]*40.96+_b[ddaysinv3]*262.144) (eq6_5: _b[dkw]+_b[ddaysinv]*6.5+_b[ddaysinv2]*42.25+_b[ddaysinv3]*274.625) (eq6_6: _b[dkw]+_b[ddaysinv]*6.6+_b[ddaysinv2]*43.56+_b[ddaysinv3]*287.496) (eq6_7: _b[dkw]+_b[ddaysinv]*6.7+_b[ddaysinv2]*44.89+_b[ddaysinv3]*300.763) (eq6_8: _b[dkw]+_b[ddaysinv]*6.8+_b[ddaysinv2]*46.24+_b[ddaysinv3]*314.432) (eq6_9: _b[dkw]+_b[ddaysinv]*6.9+_b[ddaysinv2]*47.61+_b[ddaysinv3]*328.509) (eq7: _b[dkw]+_b[ddaysinv]*7+_b[ddaysinv2]*49+_b[ddaysinv3]*343) (eq7_1: _b[dkw]+_b[ddaysinv]*7.1+_b[ddaysinv2]*50.41+_b[ddaysinv3]*357.911) (eq7_2: _b[dkw]+_b[ddaysinv]*7.2+_b[ddaysinv2]*51.84+_b[ddaysinv3]*373.248) (eq7_3: _b[dkw]+_b[ddaysinv]*7.3+_b[ddaysinv2]*53.29+_b[ddaysinv3]*389.017) (eq7_4: _b[dkw]+_b[ddaysinv]*7.4+_b[ddaysinv2]*54.76+_b[ddaysinv3]*405.224) (eq7_5: _b[dkw]+_b[ddaysinv]*7.5+_b[ddaysinv2]*56.25+_b[ddaysinv3]*421.875), post
	*estimates store a6
	
	/******************************************************************************/
	/*                           Step 3: Export results                           */
	/******************************************************************************/
	
	estimates table r1 r2 r3 r4 r5 r6, b(%8.3f) se(%8.3f) p(%8.3f) stats(r2 N widstat) keep(dkw* ddaysinv*) title(table 5)

	estimates restore r1
	outreg2 using "Current projects\Probleemwijken\Results\Table 4", label aster replace nor2 word title(Adjustment effects - first-differences) ctitle(IV - FD) nocon alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +)  keep(dkw* ddaysinv*) addstat("Kleibergen-Paap F", e(widstat)) 
	estimates restore r2
	outreg2 using "Current projects\Probleemwijken\Results\Table 4", append label aster nor2 word ctitle(IV - FD) nocon addstat("Kleibergen-Paap F", e(widstat)) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) keep(dkw* ddaysinv*)  
	estimates restore r3
	outreg2 using "Current projects\Probleemwijken\Results\Table 4", append label aster nor2 word ctitle(IV - FD) nocon addstat("Kleibergen-Paap F", e(widstat)) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +)  keep(dkw* ddaysinv*)  
	estimates restore r4
	outreg2 using "Current projects\Probleemwijken\Results\Table 4", append label aster nor2 word ctitle(IV - FD) nocon addstat("Kleibergen-Paap F", e(widstat)) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +)  keep(dkw* ddaysinv*)  
	estimates restore r5
	outreg2 using "Current projects\Probleemwijken\Results\Table 4", append label aster nor2 word ctitle(IV - FD) nocon addstat("Kleibergen-Paap F", e(widstat)) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +)  keep(dkw* ddaysinv*)  
	estimates restore r6
	outreg2 using "Current projects\Probleemwijken\Results\Table 4", append label aster nor2 word ctitle(IV - FD) nocon addstat("Kleibergen-Paap F", e(widstat)) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +)  keep(dkw* ddaysinv*)  
	
	estimates restore a1
	estimates restore a2
	estimates restore a4
	estimates restore a5
	
}

********************************************************************************
*                                                                              *
*                               REGRESSIONS                                    *
*                                                                              *
********************************************************************************

cd U:\  // open directory
use "NVM_20002014.dta", clear

// Set options
global heterogeneity = 0   // Test for heterogeneity of the price effect
global placebo = 0         // Allow for placebo regressions
global salestimes = 0      // Allow for sales times regressions
global trends = 0          // Allow for regressions based 
global spatial = 0         // Allow for estimation of spatial spillovers
global sorting = 0         // Allow for estimation of sorting effects
global cityspecific = 0    // City-specific results
global fullsample = 0      // Use full sample
global RDDlevels = 0	   // On levels, using full sample
global psm = 0             // Allow for propensity score matching
global bandwidth = 0       // Allow for different bandwidths
global date = 0            // Allow for checks on starting date
global rentalh = 0         // Allow for checks regarding social housing
global demographicsrev = 0 // Instrument for endogenous neighbourhood characteristics

set matsize 1000

global house dlogsize drooms dmaintgood dcentralheating dlisted 
global neighbourhood dlogincome dlogpopdens dshforeign dshyoung dshold dhhsize dluinfr dluind dluopens dluwater
global year dyear*
global score zscorescrule_* zscorenscrule_*

global tyear = 2007 // threshold year 
global tmonth = 7 // threshold month
global tday = 14 // threshold day
global minyear = 2000
global maxyear = 2014

global dT = 2.5
global c = 7.3
tostring pc4, g(pc2)
replace pc2 = substr(pc2,1,3)
destring pc2, force replace 

g nofe = 1
global fe pc4
global se pc4

global dependent1 dlogpricesqm
global dependent2 dlogdaysonmarket
global dependent3 dpercask

xtset $fe


if $heterogeneity == 1 {
	qui replace dkwinvpp = dkwinvpp/324.3131048
	qui replace ddaysinvpp  = ddaysinvpp/324.3131048
	qui g dkwXkwinvpp = dkw*kwinvpp
	qui g dkwXkwinvpsqm = dkw*kwinvpsqm
	qui g dkwXkwinvpsqm2 = dkw*kwinvpsqm^2 
	g kwrankadj = (kwrank-41.5)/83*2
	replace kwrankadj = 0 if inkw == 0
	qui g dkwXkwrank = dkw*kwrankadj
	qui g dscoreruleXzscorerank = dscorerule*zscorerank
	
	global interactions dkwXlogincome dkwXlogpopdens dkwXshforeign dkwXshyoung dkwXshold dkwXhhsize
	global interactionsinstr dscoreruleXlogincome dscoreruleXlogpopdens dscoreruleXshforeign dscoreruleXshyoung dscoreruleXshold dscoreruleXhhsize
	
	foreach var of varlist logincome logpopdens shforeign shyoung shold hhsize {
		g dkwX`var' = .
		g dscoreruleX`var' = .
	}
	
	local h1 = 4.2478554
	local h2 = 3.3453361
	local h3 = 3.2587074
	local h4 = 3.5129899
	local h5 = 9.3207775
	local h6 = 9.3439212
	
	
	foreach var of varlist logincome logpopdens shforeign shyoung shold hhsize {
		su `var' if (inkw == 1 | kwdist > $dT) & (zscore > $c - `h2') & (zscore < $c + `h2') & beforeafter == 0
		replace dkwX`var' = dkw*(`var'-r(mean))
		replace dscoreruleX`var' = dscorerule*(`var'-r(mean))
	}

	ivreg2 dlogpricesqm (dkw dkwXkwrank=dscorerule dscoreruleXzscorerank) $house $neighbourhood $year,  cluster($se) , if (inkw == 1 | kwdist > $dT) & (zscore > $c - `h1') & (zscore < $c + `h1') & beforeafter == 0
	qui estimates store r1
	ivreg2 dlogpricesqm (dkw $interactions = dscorerule $interactionsinstr ) $house $neighbourhood $year,  cluster($se) , if (inkw == 1 | kwdist > $dT) & (zscore > $c - `h2') & (zscore < $c + `h2') & beforeafter == 0
	qui estimates store r2
	ivreg2 dlogpricesqm dkwXkwinvpsqm dkwXkwinvpsqm2 $house $neighbourhood $year,  cluster($se), if (inkw == 1 | kwdist > $dT) & (zscore > $c - `h3') & (zscore < $c + `h3') & beforeafter == 0 & kwexcl == 0
	qui estimates store r3
	


	
	foreach var of varlist logincome logpopdens shforeign shyoung shold hhsize {
		su `var' if (inkw == 1 | kwdist > $dT) & (zscore > $c - `h5') & (zscore < $c + `h5') & beforeafter == 0
		replace dkwX`var' = dkw*(`var'-r(mean))
		replace dscoreruleX`var' = dscorerule*(`var'-r(mean))
	}
	
	ivreg2 dlogdaysonmarket (dkw ddaysinv dkwXkwrank=dscorerule ddaysinv_sc dscoreruleXzscorerank) $house $neighbourhood $year,  cluster($se) , if (inkw == 1 | kwdist > $dT) & (zscore > $c - `h4') & (zscore < $c + `h4') & beforeafter == 0
	qui estimates store r4
	ivreg2 dlogdaysonmarket (dkw ddaysinv $interactions =dscorerule ddaysinv_sc $interactionsinstr ) $house $neighbourhood $year,  cluster($se) , if (inkw == 1 | kwdist > $dT) & (zscore > $c - `h5') & (zscore < $c + `h5') & beforeafter == 0
	qui estimates store r5
	ivreg2 dlogdaysonmarket dkwXkwinvpsqm ddaysinvpsqm dkwXkwinvpsqm2 $house $neighbourhood $year,  cluster($se), if (inkw == 1 | kwdist > $dT) & (zscore > $c - `h6') & (zscore < $c + `h6') & beforeafter == 0 & kwexcl == 0
	qui estimates store r6
	
	estimates restore r1
	outreg2 using "Results\Table 7", label aster replace word title(Baseline results - first-differences) ctitle(OLS - FD) nocon alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) keep(dkw* ddays*) nor2 addstat("Kleibergen-Paap F", e(widstat)) 
	estimates restore r2
	outreg2 using "Results\Table 7", append label aster word ctitle(OLS - FD) nocon alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) keep(dkw* ddays*) nor2 addstat("Kleibergen-Paap F", e(widstat)) 
	estimates restore r3
	outreg2 using "Results\Table 7", append label aster word ctitle(OLS - FD) nocon alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) keep(dkw* ddays*)
	estimates restore r4
	outreg2 using "Results\Table 7", append label aster word ctitle(OLS - FD) nocon alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) keep(dkw* ddays*) nor2 addstat("Kleibergen-Paap F", e(widstat)) 
	estimates restore r5
	outreg2 using "Results\Table 7", append label aster word ctitle(OLS - FD) nocon alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) keep(dkw* ddays*) nor2 addstat("Kleibergen-Paap F", e(widstat)) 
	estimates restore r6
	outreg2 using "Results\Table 7", append label aster word ctitle(OLS - FD) nocon alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) keep(dkw* ddays*)
	
	estimates restore r3
	nlcom (eq0: _b[dkwXkwinvpsqm]*0+_b[dkwXkwinvpsqm2]*0) (eq0_1: _b[dkwXkwinvpsqm]*0.1+_b[dkwXkwinvpsqm2]*0.01) (eq0_2: _b[dkwXkwinvpsqm]*0.2+_b[dkwXkwinvpsqm2]*0.04) (eq0_3: _b[dkwXkwinvpsqm]*0.3+_b[dkwXkwinvpsqm2]*0.09) (eq0_4: _b[dkwXkwinvpsqm]*0.4+_b[dkwXkwinvpsqm2]*0.16) (eq0_5: _b[dkwXkwinvpsqm]*0.5+_b[dkwXkwinvpsqm2]*0.25) (eq0_6: _b[dkwXkwinvpsqm]*0.6+_b[dkwXkwinvpsqm2]*0.36) (eq0_7: _b[dkwXkwinvpsqm]*0.7+_b[dkwXkwinvpsqm2]*0.49) (eq0_8: _b[dkwXkwinvpsqm]*0.8+_b[dkwXkwinvpsqm2]*0.64) (eq0_9: _b[dkwXkwinvpsqm]*0.9+_b[dkwXkwinvpsqm2]*0.81) (eq1: _b[dkwXkwinvpsqm]*1+_b[dkwXkwinvpsqm2]*1) (eq1_1: _b[dkwXkwinvpsqm]*1.1+_b[dkwXkwinvpsqm2]*1.21) (eq1_2: _b[dkwXkwinvpsqm]*1.2+_b[dkwXkwinvpsqm2]*1.44) (eq1_3: _b[dkwXkwinvpsqm]*1.3+_b[dkwXkwinvpsqm2]*1.69) (eq1_4: _b[dkwXkwinvpsqm]*1.4+_b[dkwXkwinvpsqm2]*1.96) (eq1_5: _b[dkwXkwinvpsqm]*1.5+_b[dkwXkwinvpsqm2]*2.25) (eq1_6: _b[dkwXkwinvpsqm]*1.6+_b[dkwXkwinvpsqm2]*2.56) (eq1_7: _b[dkwXkwinvpsqm]*1.7+_b[dkwXkwinvpsqm2]*2.89) (eq1_8: _b[dkwXkwinvpsqm]*1.8+_b[dkwXkwinvpsqm2]*3.24) (eq1_9: _b[dkwXkwinvpsqm]*1.9+_b[dkwXkwinvpsqm2]*3.61) (eq2: _b[dkwXkwinvpsqm]*2+_b[dkwXkwinvpsqm2]*4) (eq2_1: _b[dkwXkwinvpsqm]*2.1+_b[dkwXkwinvpsqm2]*4.41) (eq2_2: _b[dkwXkwinvpsqm]*2.2+_b[dkwXkwinvpsqm2]*4.84) (eq2_3: _b[dkwXkwinvpsqm]*2.3+_b[dkwXkwinvpsqm2]*5.29) (eq2_4: _b[dkwXkwinvpsqm]*2.4+_b[dkwXkwinvpsqm2]*5.76) (eq2_5: _b[dkwXkwinvpsqm]*2.5+_b[dkwXkwinvpsqm2]*6.25) (eq2_6: _b[dkwXkwinvpsqm]*2.6+_b[dkwXkwinvpsqm2]*6.76) (eq2_7: _b[dkwXkwinvpsqm]*2.7+_b[dkwXkwinvpsqm2]*7.29) (eq2_8: _b[dkwXkwinvpsqm]*2.8+_b[dkwXkwinvpsqm2]*7.84) (eq2_9: _b[dkwXkwinvpsqm]*2.9+_b[dkwXkwinvpsqm2]*8.41) (eq3: _b[dkwXkwinvpsqm]*3+_b[dkwXkwinvpsqm2]*9) (eq3_1: _b[dkwXkwinvpsqm]*3.1+_b[dkwXkwinvpsqm2]*9.61) (eq3_2: _b[dkwXkwinvpsqm]*3.2+_b[dkwXkwinvpsqm2]*10.24) (eq3_3: _b[dkwXkwinvpsqm]*3.3+_b[dkwXkwinvpsqm2]*10.89) (eq3_4: _b[dkwXkwinvpsqm]*3.4+_b[dkwXkwinvpsqm2]*11.56) (eq3_5: _b[dkwXkwinvpsqm]*3.5+_b[dkwXkwinvpsqm2]*12.25) (eq3_6: _b[dkwXkwinvpsqm]*3.6+_b[dkwXkwinvpsqm2]*12.96) (eq3_7: _b[dkwXkwinvpsqm]*3.7+_b[dkwXkwinvpsqm2]*13.69) (eq3_8: _b[dkwXkwinvpsqm]*3.8+_b[dkwXkwinvpsqm2]*14.44) (eq3_9: _b[dkwXkwinvpsqm]*3.9+_b[dkwXkwinvpsqm2]*15.21) (eq4: _b[dkwXkwinvpsqm]*4+_b[dkwXkwinvpsqm2]*16) (eq4_1: _b[dkwXkwinvpsqm]*4.1+_b[dkwXkwinvpsqm2]*16.81) (eq4_2: _b[dkwXkwinvpsqm]*4.2+_b[dkwXkwinvpsqm2]*17.64) (eq4_3: _b[dkwXkwinvpsqm]*4.3+_b[dkwXkwinvpsqm2]*18.49) (eq4_4: _b[dkwXkwinvpsqm]*4.4+_b[dkwXkwinvpsqm2]*19.36) (eq4_5: _b[dkwXkwinvpsqm]*4.5+_b[dkwXkwinvpsqm2]*20.25) (eq4_6: _b[dkwXkwinvpsqm]*4.6+_b[dkwXkwinvpsqm2]*21.16) (eq4_7: _b[dkwXkwinvpsqm]*4.7+_b[dkwXkwinvpsqm2]*22.09) (eq4_8: _b[dkwXkwinvpsqm]*4.8+_b[dkwXkwinvpsqm2]*23.04) (eq4_9: _b[dkwXkwinvpsqm]*4.9+_b[dkwXkwinvpsqm2]*24.01) (eq5: _b[dkwXkwinvpsqm]*5+_b[dkwXkwinvpsqm2]*25) (eq5_1: _b[dkwXkwinvpsqm]*5.1+_b[dkwXkwinvpsqm2]*26.01) (eq5_2: _b[dkwXkwinvpsqm]*5.2+_b[dkwXkwinvpsqm2]*27.04) (eq5_3: _b[dkwXkwinvpsqm]*5.3+_b[dkwXkwinvpsqm2]*28.09) (eq5_4: _b[dkwXkwinvpsqm]*5.4+_b[dkwXkwinvpsqm2]*29.16) (eq5_5: _b[dkwXkwinvpsqm]*5.5+_b[dkwXkwinvpsqm2]*30.25) (eq5_6: _b[dkwXkwinvpsqm]*5.6+_b[dkwXkwinvpsqm2]*31.36) (eq5_7: _b[dkwXkwinvpsqm]*5.7+_b[dkwXkwinvpsqm2]*32.49) (eq5_8: _b[dkwXkwinvpsqm]*5.8+_b[dkwXkwinvpsqm2]*33.64) (eq5_9: _b[dkwXkwinvpsqm]*5.9+_b[dkwXkwinvpsqm2]*34.81) (eq6: _b[dkwXkwinvpsqm]*6+_b[dkwXkwinvpsqm2]*36) (eq6_1: _b[dkwXkwinvpsqm]*6.1+_b[dkwXkwinvpsqm2]*37.21) (eq6_2: _b[dkwXkwinvpsqm]*6.2+_b[dkwXkwinvpsqm2]*38.44) (eq6_3: _b[dkwXkwinvpsqm]*6.3+_b[dkwXkwinvpsqm2]*39.69) (eq6_4: _b[dkwXkwinvpsqm]*6.4+_b[dkwXkwinvpsqm2]*40.96) (eq6_5: _b[dkwXkwinvpsqm]*6.5+_b[dkwXkwinvpsqm2]*42.25) (eq6_6: _b[dkwXkwinvpsqm]*6.6+_b[dkwXkwinvpsqm2]*43.56) (eq6_7: _b[dkwXkwinvpsqm]*6.7+_b[dkwXkwinvpsqm2]*44.89) (eq6_8: _b[dkwXkwinvpsqm]*6.8+_b[dkwXkwinvpsqm2]*46.24) (eq6_9: _b[dkwXkwinvpsqm]*6.9+_b[dkwXkwinvpsqm2]*47.61) (eq7: _b[dkwXkwinvpsqm]*7+_b[dkwXkwinvpsqm2]*49)
	estimates restore r6
	nlcom (eq0: _b[dkwXkwinvpsqm]*0+_b[dkwXkwinvpsqm2]*0) (eq0_1: _b[dkwXkwinvpsqm]*0.1+_b[dkwXkwinvpsqm2]*0.01) (eq0_2: _b[dkwXkwinvpsqm]*0.2+_b[dkwXkwinvpsqm2]*0.04) (eq0_3: _b[dkwXkwinvpsqm]*0.3+_b[dkwXkwinvpsqm2]*0.09) (eq0_4: _b[dkwXkwinvpsqm]*0.4+_b[dkwXkwinvpsqm2]*0.16) (eq0_5: _b[dkwXkwinvpsqm]*0.5+_b[dkwXkwinvpsqm2]*0.25) (eq0_6: _b[dkwXkwinvpsqm]*0.6+_b[dkwXkwinvpsqm2]*0.36) (eq0_7: _b[dkwXkwinvpsqm]*0.7+_b[dkwXkwinvpsqm2]*0.49) (eq0_8: _b[dkwXkwinvpsqm]*0.8+_b[dkwXkwinvpsqm2]*0.64) (eq0_9: _b[dkwXkwinvpsqm]*0.9+_b[dkwXkwinvpsqm2]*0.81) (eq1: _b[dkwXkwinvpsqm]*1+_b[dkwXkwinvpsqm2]*1) (eq1_1: _b[dkwXkwinvpsqm]*1.1+_b[dkwXkwinvpsqm2]*1.21) (eq1_2: _b[dkwXkwinvpsqm]*1.2+_b[dkwXkwinvpsqm2]*1.44) (eq1_3: _b[dkwXkwinvpsqm]*1.3+_b[dkwXkwinvpsqm2]*1.69) (eq1_4: _b[dkwXkwinvpsqm]*1.4+_b[dkwXkwinvpsqm2]*1.96) (eq1_5: _b[dkwXkwinvpsqm]*1.5+_b[dkwXkwinvpsqm2]*2.25) (eq1_6: _b[dkwXkwinvpsqm]*1.6+_b[dkwXkwinvpsqm2]*2.56) (eq1_7: _b[dkwXkwinvpsqm]*1.7+_b[dkwXkwinvpsqm2]*2.89) (eq1_8: _b[dkwXkwinvpsqm]*1.8+_b[dkwXkwinvpsqm2]*3.24) (eq1_9: _b[dkwXkwinvpsqm]*1.9+_b[dkwXkwinvpsqm2]*3.61) (eq2: _b[dkwXkwinvpsqm]*2+_b[dkwXkwinvpsqm2]*4) (eq2_1: _b[dkwXkwinvpsqm]*2.1+_b[dkwXkwinvpsqm2]*4.41) (eq2_2: _b[dkwXkwinvpsqm]*2.2+_b[dkwXkwinvpsqm2]*4.84) (eq2_3: _b[dkwXkwinvpsqm]*2.3+_b[dkwXkwinvpsqm2]*5.29) (eq2_4: _b[dkwXkwinvpsqm]*2.4+_b[dkwXkwinvpsqm2]*5.76) (eq2_5: _b[dkwXkwinvpsqm]*2.5+_b[dkwXkwinvpsqm2]*6.25) (eq2_6: _b[dkwXkwinvpsqm]*2.6+_b[dkwXkwinvpsqm2]*6.76) (eq2_7: _b[dkwXkwinvpsqm]*2.7+_b[dkwXkwinvpsqm2]*7.29) (eq2_8: _b[dkwXkwinvpsqm]*2.8+_b[dkwXkwinvpsqm2]*7.84) (eq2_9: _b[dkwXkwinvpsqm]*2.9+_b[dkwXkwinvpsqm2]*8.41) (eq3: _b[dkwXkwinvpsqm]*3+_b[dkwXkwinvpsqm2]*9) (eq3_1: _b[dkwXkwinvpsqm]*3.1+_b[dkwXkwinvpsqm2]*9.61) (eq3_2: _b[dkwXkwinvpsqm]*3.2+_b[dkwXkwinvpsqm2]*10.24) (eq3_3: _b[dkwXkwinvpsqm]*3.3+_b[dkwXkwinvpsqm2]*10.89) (eq3_4: _b[dkwXkwinvpsqm]*3.4+_b[dkwXkwinvpsqm2]*11.56) (eq3_5: _b[dkwXkwinvpsqm]*3.5+_b[dkwXkwinvpsqm2]*12.25) (eq3_6: _b[dkwXkwinvpsqm]*3.6+_b[dkwXkwinvpsqm2]*12.96) (eq3_7: _b[dkwXkwinvpsqm]*3.7+_b[dkwXkwinvpsqm2]*13.69) (eq3_8: _b[dkwXkwinvpsqm]*3.8+_b[dkwXkwinvpsqm2]*14.44) (eq3_9: _b[dkwXkwinvpsqm]*3.9+_b[dkwXkwinvpsqm2]*15.21) (eq4: _b[dkwXkwinvpsqm]*4+_b[dkwXkwinvpsqm2]*16) (eq4_1: _b[dkwXkwinvpsqm]*4.1+_b[dkwXkwinvpsqm2]*16.81) (eq4_2: _b[dkwXkwinvpsqm]*4.2+_b[dkwXkwinvpsqm2]*17.64) (eq4_3: _b[dkwXkwinvpsqm]*4.3+_b[dkwXkwinvpsqm2]*18.49) (eq4_4: _b[dkwXkwinvpsqm]*4.4+_b[dkwXkwinvpsqm2]*19.36) (eq4_5: _b[dkwXkwinvpsqm]*4.5+_b[dkwXkwinvpsqm2]*20.25) (eq4_6: _b[dkwXkwinvpsqm]*4.6+_b[dkwXkwinvpsqm2]*21.16) (eq4_7: _b[dkwXkwinvpsqm]*4.7+_b[dkwXkwinvpsqm2]*22.09) (eq4_8: _b[dkwXkwinvpsqm]*4.8+_b[dkwXkwinvpsqm2]*23.04) (eq4_9: _b[dkwXkwinvpsqm]*4.9+_b[dkwXkwinvpsqm2]*24.01) (eq5: _b[dkwXkwinvpsqm]*5+_b[dkwXkwinvpsqm2]*25) (eq5_1: _b[dkwXkwinvpsqm]*5.1+_b[dkwXkwinvpsqm2]*26.01) (eq5_2: _b[dkwXkwinvpsqm]*5.2+_b[dkwXkwinvpsqm2]*27.04) (eq5_3: _b[dkwXkwinvpsqm]*5.3+_b[dkwXkwinvpsqm2]*28.09) (eq5_4: _b[dkwXkwinvpsqm]*5.4+_b[dkwXkwinvpsqm2]*29.16) (eq5_5: _b[dkwXkwinvpsqm]*5.5+_b[dkwXkwinvpsqm2]*30.25) (eq5_6: _b[dkwXkwinvpsqm]*5.6+_b[dkwXkwinvpsqm2]*31.36) (eq5_7: _b[dkwXkwinvpsqm]*5.7+_b[dkwXkwinvpsqm2]*32.49) (eq5_8: _b[dkwXkwinvpsqm]*5.8+_b[dkwXkwinvpsqm2]*33.64) (eq5_9: _b[dkwXkwinvpsqm]*5.9+_b[dkwXkwinvpsqm2]*34.81) (eq6: _b[dkwXkwinvpsqm]*6+_b[dkwXkwinvpsqm2]*36) (eq6_1: _b[dkwXkwinvpsqm]*6.1+_b[dkwXkwinvpsqm2]*37.21) (eq6_2: _b[dkwXkwinvpsqm]*6.2+_b[dkwXkwinvpsqm2]*38.44) (eq6_3: _b[dkwXkwinvpsqm]*6.3+_b[dkwXkwinvpsqm2]*39.69) (eq6_4: _b[dkwXkwinvpsqm]*6.4+_b[dkwXkwinvpsqm2]*40.96) (eq6_5: _b[dkwXkwinvpsqm]*6.5+_b[dkwXkwinvpsqm2]*42.25) (eq6_6: _b[dkwXkwinvpsqm]*6.6+_b[dkwXkwinvpsqm2]*43.56) (eq6_7: _b[dkwXkwinvpsqm]*6.7+_b[dkwXkwinvpsqm2]*44.89) (eq6_8: _b[dkwXkwinvpsqm]*6.8+_b[dkwXkwinvpsqm2]*46.24) (eq6_9: _b[dkwXkwinvpsqm]*6.9+_b[dkwXkwinvpsqm2]*47.61) (eq7: _b[dkwXkwinvpsqm]*7+_b[dkwXkwinvpsqm2]*49)

	

	local h1 = 5.5567548
	local h2 = 3.3830078
	local h3 = 3.5055372
	local h4 = 3.6753323
	local h5 = 3.4076738
	local h6 = 3.6084384 
	
	local hn = 1
	
	foreach var of varlist logincome logpopdens shforeign shyoung shold hhsize {
		su `var' if (inkw == 1 | kwdist > $dT) & (zscore > $c - `h`hn'') & (zscore < $c + `h`hn'') & beforeafter == 0
		replace dkwX`var' = dkw*(`var'-r(mean))
		replace dscoreruleX`var' = dscorerule*(`var'-r(mean))
		local hn = `hn'+1
	}
	
	ivreg2 dlogpricesqm (dkw dkwXlogincome = dscorerule dscoreruleXlogincome) $house $neighbourhood $year,  cluster($se) , if (inkw == 1 | kwdist > $dT) & (zscore > $c - `h2') & (zscore < $c + `h2') & beforeafter == 0
	qui estimates store r1
	ivreg2 dlogpricesqm (dkw dkwXlogpopdens = dscorerule dscoreruleXlogpopdens) $house $neighbourhood $year,  cluster($se) , if (inkw == 1 | kwdist > $dT) & (zscore > $c - `h2') & (zscore < $c + `h2') & beforeafter == 0
	qui estimates store r2
	ivreg2 dlogpricesqm (dkw dkwXshforeign = dscorerule dscoreruleXshforeign) $house $neighbourhood $year,  cluster($se) , if (inkw == 1 | kwdist > $dT) & (zscore > $c - `h2') & (zscore < $c + `h2') & beforeafter == 0
	qui estimates store r3
	ivreg2 dlogpricesqm (dkw dkwXshyoung = dscorerule dscoreruleXshyoung) $house $neighbourhood $year,  cluster($se) , if (inkw == 1 | kwdist > $dT) & (zscore > $c - `h2') & (zscore < $c + `h2') & beforeafter == 0
	qui estimates store r4
	ivreg2 dlogpricesqm (dkw dkwXshold = dscorerule dscoreruleXshold) $house $neighbourhood $year,  cluster($se) , if (inkw == 1 | kwdist > $dT) & (zscore > $c - `h2') & (zscore < $c + `h2') & beforeafter == 0
	qui estimates store r5
	ivreg2 dlogpricesqm (dkw dkwXhhsize = dscorerule dscoreruleXhhsize) $house $neighbourhood $year,  cluster($se) , if (inkw == 1 | kwdist > $dT) & (zscore > $c - `h2') & (zscore < $c + `h2') & beforeafter == 0
	qui estimates store r6
	
	estimates restore r1
	outreg2 using "Results\Table C2", label aster replace word title(Baseline results - first-differences) ctitle(OLS - FD) nocon alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) keep(dkw* ddays*) nor2 addstat("Kleibergen-Paap F", e(widstat)) 
	estimates restore r2
	outreg2 using "Results\Table C2", append label aster word ctitle(OLS - FD) nocon alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) keep(dkw* ddays*) nor2 addstat("Kleibergen-Paap F", e(widstat)) 
	estimates restore r3
	outreg2 using "Results\Table C2", append label aster word ctitle(OLS - FD) nocon alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) keep(dkw* ddays*)
	estimates restore r4
	outreg2 using "Results\Table C2", append label aster word ctitle(OLS - FD) nocon alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) keep(dkw* ddays*) nor2 addstat("Kleibergen-Paap F", e(widstat)) 
	estimates restore r5
	outreg2 using "Results\Table C2", append label aster word ctitle(OLS - FD) nocon alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) keep(dkw* ddays*) nor2 addstat("Kleibergen-Paap F", e(widstat)) 
	estimates restore r6
	outreg2 using "Results\Table C2", append label aster word ctitle(OLS - FD) nocon alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) keep(dkw* ddays*)
	
	
}
	
if $salestimes == 1 {
	
	local h3 = 5.2099097 // Obtained from the bandwidth do-file
	local h4 = 6.2193224
	local h5 = 6.2209125
	local h6 = 8.9725396
	
	quietly ivreg2 dlogdaysonmarket dkw ddaysinv $year,  cluster($se), if (inkw == 1 | kwdist > $dT)
	estimates store r7
	quietly ivreg2 dlogdaysonmarket dkw ddaysinv $house $year,  cluster($se), if (inkw == 1 | kwdist > $dT)
	estimates store r8
	quietly ivreg2 dlogdaysonmarket dkw ddaysinv $house $year,  cluster($se), if (inkw == 1 | kwdist > $dT) & (zscore > $c - `h3') & (zscore < $c + `h3') & kwexcl == 0
	estimates store r9
	quietly ivreg2 dlogdaysonmarket (dkw ddaysinv=dscorerule ddaysinv_sc) $house $year,  cluster($se) endog(dkw), if (inkw == 1 | kwdist > $dT) & (zscore > $c - `h4') & (zscore < $c + `h4')
	estimates store r10
	quietly ivreg2 dlogdaysonmarket (dkw ddaysinv=dscorerule ddaysinv_sc) $house $year,  cluster($se) endog(dkw), if (inkw == 1 | kwdist > $dT) & (zscore > $c - `h5') & (zscore < $c + `h5') & beforeafter == 0
	estimates store r11
	quietly ivreg2 dlogdaysonmarket (dkw ddaysinv=dscorerule ddaysinv_sc) $house $neighbourhood $year,  cluster($se) endog(dkw), if (inkw == 1 | kwdist > $dT) & (zscore > $c - `h6') & (zscore < $c + `h6') & beforeafter == 0
	estimates store r12
		
	estimates restore r7
	outreg2 using "Results\Table C1", label aster replace word title(Baseline results - first-differences) ctitle(OLS - FD) nocon alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) keep(dkw ddaysinv)
	estimates restore r8
	outreg2 using "Results\Table C1", append label aster word ctitle(OLS - FD) nocon alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) keep(dkw ddaysinv) 
	estimates restore r9
	outreg2 using "Results\Table C1", append label aster word ctitle(OLS - FD) nocon alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) keep(dkw ddaysinv) 
	estimates restore r10
	outreg2 using "Results\Table C1", append label aster nor2 word ctitle(IV - FD) nocon addstat("Kleibergen-Paap F", e(widstat)) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) keep(dkw ddaysinv)  
	estimates restore r11
	outreg2 using "Results\Table C1", append label aster nor2 word ctitle(IV - FD) nocon addstat("Kleibergen-Paap F", e(widstat)) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) keep(dkw ddaysinv)   
	estimates restore r12
	outreg2 using "Results\Table C1", append label aster nor2 word ctitle(IV - FD) nocon addstat("Kleibergen-Paap F", e(widstat)) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) keep(dkw ddaysinv)    

}

	
if $placebo == 1 {
	
	regress dlogpricesqm dpbo_winsemius $house $year, cluster($se) , if kwdist > $dT  & (winsemius == 1 | winsemiusdist > $dT)
	estimates store r1
	regress dlogpricesqm dpbo_kamp $house $year, cluster($se) , if kwdist > $dT & (kamp == 1 | kampdist > $dT) & yearmin > 2003
	estimates store r2
	regress dlogpricesqm dpbo_gsb $house $year, cluster($se) , if kwdist > $dT & (gsbneighbourhood == 1 | gsbdist > $dT) 
	estimates store r3
	regress dlogdaysonmarket dpbo_winsemius* $house $year, cluster($se) , if kwdist > $dT  & (winsemius == 1 | winsemiusdist > $dT)
	estimates store r4
	regress dlogdaysonmarket dpbo_kamp* $house $year, cluster($se) , if kwdist > $dT & (kamp == 1 | kampdist > $dT) & yearmin > 2003
	estimates store r5
	regress dlogdaysonmarket dpbo_gsb* $house $year, cluster($se) , if kwdist > $dT & (gsbneighbourhood == 1 | gsbdist > $dT) 
	estimates store r6

	estimates restore r1
	outreg2 using "Results\Table C3", label aster replace word title(Baseline results - first-differences) ctitle(OLS - FD) nocon alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) keep(dpbo_*)
	estimates restore r2
	outreg2 using "Results\Table C3", append label aster word ctitle(OLS - FD) nocon alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) keep(dpbo_*)
	estimates restore r3
	outreg2 using "Results\Table C3", append label aster word ctitle(OLS - FD) nocon alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) keep(dpbo_*)
	estimates restore r4
	outreg2 using "Results\Table C3", append label aster word ctitle(OLS - FD) nocon alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) keep(dpbo_*)
	estimates restore r5
	outreg2 using "Results\Table C3", append label aster word ctitle(OLS - FD) nocon alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) keep(dpbo_*)
	estimates restore r6
	outreg2 using "Results\Table C3", append label aster word ctitle(OLS - FD) nocon alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) keep(dpbo_*)

}

if $trends == 1 {
	local h1 = 2.9977259
	local h2 = 2.6262247
	local h3 = 5.5049328
	local h4 = 6.3295959
	local h5 = 4.7574531
	local h6 = 6.0849339
	g distcbd2 = distcbd^2
	g distcbd3 = distcbd^3
			
	qui ivreg2 dlogpricesqm (dkw=dscorerule) distcbd $house $year,  cluster($se) endog(dkw), if (inkw == 1 | kwdist > $dT) & (zscore > $c - `h1') & (zscore < $c + `h1')
	qui estimates store r1
	qui ivreg2 dlogpricesqm (dkw=dscorerule) distcbd* i.mun $house $year,  cluster($se) endog(dkw), if (inkw == 1 | kwdist > $dT) & (zscore > $c - `h2') & (zscore < $c + `h2')
	qui estimates store r2
	qui ivreg2 dlogpricesqm (dkw=dscorerule) $house $year,  cluster($se) endog(dkw), if (inkw == 1 | kwdist > $dT) & (zscore > $c - `h3') & (zscore < $c + `h3') & ((yearmin<2005 | yearmin>2011) & (year>2011 | year <2005))
	qui estimates store r3
	qui ivreg2 dlogdaysonmarket (dkw ddaysinv=dscorerule ddaysinv_sc) distcbd $house $year,  cluster($se) endog(dkw), if (inkw == 1 | kwdist > $dT) & (zscore > $c - `h4') & (zscore < $c + `h4')
	qui estimates store r4
	qui ivreg2 dlogdaysonmarket (dkw ddaysinv=dscorerule ddaysinv_sc) distcbd* i.mun $house $year,  cluster($se) endog(dkw), if (inkw == 1 | kwdist > $dT) & (zscore > $c - `h5') & (zscore < $c + `h5')
	qui estimates store r5
	qui ivreg2 dlogdaysonmarket (dkw ddaysinv=dscorerule ddaysinv_sc) $house $year,  cluster($se) endog(dkw), if (inkw == 1 | kwdist > $dT) & (zscore > $c - `h6') & (zscore < $c + `h6') & ((yearmin<2005 | yearmin>2011) & (year>2011 | year <2005))
	qui estimates store r6

	estimates restore r1
	outreg2 using "Results\Table C4", keep(dkw* ddays* distcbd) label aster nor2 replace word title(Baseline results - first-differences) ctitle(IV - FD) nocon addstat("Kleibergen-Paap F", e(widstat))  alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +)
	estimates restore r2
	outreg2 using "Results\Table C4", keep(dkw* ddays* distcbd) append label aster nor2 word ctitle(IV - FD) nocon addstat("Kleibergen-Paap F", e(widstat)) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +)   
	estimates restore r3
	outreg2 using "Results\Table C4", keep(dkw* ddays* distcbd) append label aster nor2 word ctitle(IV - FD) nocon addstat("Kleibergen-Paap F", e(widstat)) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +)
    estimates restore r4
	outreg2 using "Results\Table C4", keep(dkw* ddays* distcbd) append label aster nor2 word ctitle(IV - FD) nocon addstat("Kleibergen-Paap F", e(widstat)) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +)   
	estimates restore r5
	outreg2 using "Results\Table C4", keep(dkw* ddays* distcbd) append label aster nor2 word ctitle(IV - FD) nocon addstat("Kleibergen-Paap F", e(widstat)) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +)   
	estimates restore r6
	outreg2 using "Results\Table C4", keep(dkw* ddays* distcbd) append label aster nor2 word ctitle(IV - FD) nocon addstat("Kleibergen-Paap F", e(widstat)) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +)  
	
}

if $spatial == 1 { 
	global spatialvar2 dkw dkw0_500 dkw500_1000 dkw1000_1500 dkw1500_2000 dkw2000_2500
	global spatialvar1 dscorerule dsrule0_500 dsrule500_1000 dsrule1000_1500 dsrule1500_2000 dsrule2000_2500
	
	g dkw0_2500 = dkw0_500+dkw500_1000+dkw1000_1500+dkw1500_2000+dkw2000_2500
	g dsrule0_2500 = dsrule0_500+dsrule500_1000+dsrule1000_1500+dsrule1500_2000+dsrule2000_2500
		
	local h1 = 3.3836076
	local h2 = 3.3833341
	local h3 = 3.3833341
	local h4 = 6.9448405
	local h5 = 6.9500155
	local h6 = 6.9500155
	
	ivreg2 dlogpricesqm (dkw dkwadjacent=dscorerule dscoreruleadjacent) $house $year,  cluster($se) endog(dkw), if (zscore > $c - `h1') & (zscore < $c + `h1')
	estimates store r1
	ivreg2 dlogpricesqm (dkw dkw0_2500=dscorerule dsrule0_2500) $house $year,  cluster($se) endog(dkw), if (zscore > $c - `h2') & (zscore < $c + `h2')
	estimates store r2
	ivreg2 dlogpricesqm ($spatialvar2 = $spatialvar1) $house $year,  cluster($se) endog(dkw), if (zscore > $c - `h3') & (zscore < $c + `h3')
	estimates store r3

	ivreg2 dlogdaysonmarket (dkw dkwadjacent ddaysinv=dscorerule dscoreruleadjacent ddaysinv_sc) $house $year,  cluster($se) endog(dkw), if (zscore > $c - `h1') & (zscore < $c + `h1')
	estimates store r1
	ivreg2 dlogpricesqm (dkw dkw0_2500 ddaysinv=dscorerule dsrule0_2500 ddaysinv_sc) $house $year,  cluster($se) endog(dkw), if (zscore > $c - `h2') & (zscore < $c + `h2')
	estimates store r2
	ivreg2 dlogpricesqm ($spatialvar2 ddaysinv = $spatialvar1 ddaysinv_sc) $house $year,  cluster($se) endog(dkw), if (zscore > $c - `h3') & (zscore < $c + `h3')
	estimates store r3
	
	estimates restore r1
	outreg2 using "Results\Table C5", keep(dkw*) label aster nor2 replace word title(Baseline results - first-differences) ctitle(IV - FD) nocon addstat("Kleibergen-Paap F", e(widstat)) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) 
	estimates restore r2
	outreg2 using "Results\Table C5", keep(dkw*) append label aster nor2 word ctitle(IV - FD) nocon addstat("Kleibergen-Paap F", e(widstat)) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +)   
	estimates restore r3
	outreg2 using "Results\Table C5", keep(dkw*) append label aster nor2 word ctitle(IV - FD) nocon addstat("Kleibergen-Paap F", e(widstat)) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +)    
	estimates restore r4
	outreg2 using "Results\Table C5", keep(dkw* ddays*) append label aster nor2 word ctitle(IV - FD) nocon addstat("Kleibergen-Paap F", e(widstat)) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +)    
	estimates restore r5
	outreg2 using "Results\Table C5", keep(dkw* ddays*) append label aster nor2 word ctitle(IV - FD) nocon addstat("Kleibergen-Paap F", e(widstat)) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +)    
	estimates restore r6
	outreg2 using "Results\Table C5", keep(dkw* ddays*) append label aster nor2 word ctitle(IV - FD) nocon addstat("Kleibergen-Paap F", e(widstat)) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +)    

}

if $sorting == 1 {
	use "pc4data.dta", clear
	merge m:1 pc4 year using "Data\ABF\pc4_income.dta", nogenerate keep(1 3)
	merge 1:1 pc4 year using "pc4_housingunits.dta", nogenerate keep(1 3)
	g logincome = ln(income)
	merge m:1 pc4 using "kw_pc4.dta",  nogenerate keepusing(zscore kw kwadjacent kwdistcentroid winsemius) keep(3)
	drop if year < 2000 | year > 2014 | year == 2007 | kwadjacent == 1
	g scorerule = (zscore>=7.3)
	g logpopdens = ln(popdens)
	order logpopdens, after(popdens)

	forvalues i = $minyear(1)$maxyear {
		g year_`i' = (`i'==year)
	}
	
	g inkw = kw
	g inscorerule = scorerule
	replace scorerule = 0 if year < 2007
	replace kw = 0 if year < 2007
	
	forvalues i = 1(1)3 {
		g zscore_`i' = zscore^`i'
		g zscorekw_`i' = zscore_`i'*(inkw==0)
		g zscorenkw_`i' = zscore_`i'*(inkw!=0)
		g zscorescrule_`i' = zscore_`i'*(zscore>=7.3)
		g zscorenscrule_`i' = zscore_`i'*(zscore<7.3)
		label variable zscore_`i' "z-score ^ `i'"
	}
	
	foreach var of varlist kw scorerule logincome logpopdens shforeign shyoung shold hhsize year_* shsocialrent shwsocialrent shprivrent shwprivrent shownocc shwownocc {
		egen temp = mean(`var'), by(pc4)
		generate dm`var' = `var'-temp
		drop temp
	}
	
	sort pc4 year
	save "pc4regression.dta", replace
	
	g weight = 0
	global dT = 1
	global zD = 2
	global zMAX = 7.3+$zD
	global zMIN = 7.3-$zD
	*replace weight = (1-((abs(zscore-7.3))/$zD)^4)^4 if abs(zscore-7.3)<$zD
	replace weight = 1 if abs(zscore-7.3)<$zD

	local h1 = 5.4986987
	local h2 = 3.896833
	local h3 = 3.6567252
	local h4 = 2.6661548
	local h5 = 2.6841432
	local h6 = 4.0430213
	
	local h7 = 6.4649154
	local h8 = 6.5250269
	local h9 = 5.9108287
	local h10 = 5.844283
	
	xtivreg2 logincome (kw=scorerule) year_*, i(pc4) fe cluster(pc4) endog(kw) partial(year_*), if (inkw==1 | kwdistcentroid>2.5) & (zscore > $c - `h1') & (zscore < $c + `h1') 
	estimates store r1
	xtivreg2 logpopdens (kw=scorerule) year_*, i(pc4) fe cluster(pc4) endog(kw) partial(year_*), if (inkw==1 | kwdistcentroid>2.5) & (zscore > $c - `h2') & (zscore < $c + `h2') 
	estimates store r2
	xtivreg2 shforeign (kw=scorerule) year_*, i(pc4) fe cluster(pc4) endog(kw) partial(year_*), if (inkw==1 | kwdistcentroid>2.5) & (zscore > $c - `h3') & (zscore < $c + `h3') 
	estimates store r3
	xtivreg2 shyoung (kw=scorerule) year_*, i(pc4) fe cluster(pc4) endog(kw) partial(year_*), if (inkw==1 | kwdistcentroid>2.5) & (zscore > $c - `h4') & (zscore < $c + `h4') 
	estimates store r4
	xtivreg2 shold (kw=scorerule) year_*, i(pc4) fe cluster(pc4) endog(kw) partial(year_*), if (inkw==1 | kwdistcentroid>2.5) & (zscore > $c - `h5') & (zscore < $c + `h5') 
	estimates store r5
	xtivreg2 hhsize (kw=scorerule) year_*, i(pc4) fe cluster(pc4) endog(kw) partial(year_*), if (inkw==1 | kwdistcentroid>2.5) & (zscore > $c - `h6') & (zscore < $c + `h6') 
	estimates store r6
	
	xtivreg2 shsocialrent (kw=scorerule) year_*, i(pc4) fe cluster(pc4) endog(kw) partial(year_*), if (inkw==1 | kwdistcentroid>2.5) & (zscore > $c - `h7') & (zscore < $c + `h7') 
	estimates store r7
	xtivreg2 shwsocialrent (kw=scorerule) year_*, i(pc4) fe cluster(pc4) endog(kw) partial(year_*), if (inkw==1 | kwdistcentroid>2.5) & (zscore > $c - `h8') & (zscore < $c + `h8') 
	estimates store r8
	xtivreg2 shownocc (kw=scorerule) year_*, i(pc4) fe cluster(pc4) endog(kw) partial(year_*), if (inkw==1 | kwdistcentroid>2.5) & (zscore > $c - `h9') & (zscore < $c + `h9') 
	estimates store r9
	xtivreg2 shwownocc  (kw=scorerule) year_*, i(pc4) fe cluster(pc4) endog(kw) partial(year_*), if (inkw==1 | kwdistcentroid>2.5) & (zscore > $c - `h10') & (zscore < $c + `h10') 
	estimates store r10
	
	estimates restore r1
	outreg2 using "Results\Table B7", keep(kw*) label aster nor2 replace word title(Baseline results - first-differences) ctitle(IV - FD) nocon addstat("Kleibergen-Paap F", e(widstat))  alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +)
	estimates restore r2
	outreg2 using "Results\Table B7", keep(kw*) append label aster nor2 word ctitle(IV - FD) nocon addstat("Kleibergen-Paap F", e(widstat))  alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +)
	estimates restore r3
	outreg2 using "Results\Table B7", keep(kw*) append label aster nor2 word ctitle(IV - FD) nocon addstat("Kleibergen-Paap F", e(widstat))  alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +)
	estimates restore r4
	outreg2 using "Results\Table B7", keep(kw*) append label aster nor2 word ctitle(IV - FD) nocon addstat("Kleibergen-Paap F", e(widstat))  alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +)
	estimates restore r5
	outreg2 using "Results\Table B7", keep(kw*) append label aster nor2 word ctitle(IV - FD) nocon addstat("Kleibergen-Paap F", e(widstat))  alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +)
	estimates restore r6
	outreg2 using "Results\Table B7", keep(kw*) append label aster nor2 word ctitle(IV - FD) nocon addstat("Kleibergen-Paap F", e(widstat))  alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +)
	
	estimates restore r7
	outreg2 using "Results\Table B8", keep(kw*) label aster nor2 replace word title(Baseline results - first-differences) ctitle(IV - FD) nocon addstat("Kleibergen-Paap F", e(widstat))  alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +)
	estimates restore r8
	outreg2 using "Results\Table B8", keep(kw*) append label aster nor2 word ctitle(IV - FD) nocon addstat("Kleibergen-Paap F", e(widstat))  alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +)
	estimates restore r9
	outreg2 using "Results\Table B8", keep(kw*) append label aster nor2 word ctitle(IV - FD) nocon addstat("Kleibergen-Paap F", e(widstat))  alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +)
	estimates restore r10
	outreg2 using "Results\Table B8", keep(kw*) append label aster nor2 word ctitle(IV - FD) nocon addstat("Kleibergen-Paap F", e(widstat))  alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +)


	
}


if $cityspecific == 1 {
	local h1 = 1.1285361
	local h2 = 4.7395141
	local h3 = 1.9088183
	local h4 = 1.9496294
	local h5 = 7.1082425
	local h6 = 4.1290317
	
	ivreg2 dlogpricesqm dkw $house $year,  cluster($se), if (inkw == 1 | kwdist > $dT) & (zscore > $c - `h1') & (zscore < $c + `h1') & kwexcl == 0 
	
	quietly ivreg2 dlogpricesqm dkw $house $year,  cluster($se), if (inkw == 1 | kwdist > $dT) & (zscore > $c - `h1') & (zscore < $c + `h1') & kwexcl == 0 & mun == 363
	estimates store r1
	quietly ivreg2 dlogpricesqm dkw $house $year,  cluster($se), if (inkw == 1 | kwdist > $dT) & (zscore > $c - `h2') & (zscore < $c + `h2') & kwexcl == 0 & mun == 599
	estimates store r2
	quietly ivreg2 dlogpricesqm dkw $house $year,  cluster($se), if (inkw == 1 | kwdist > $dT) & (zscore > $c - `h3') & (zscore < $c + `h3') & kwexcl == 0 & mun == 514
	estimates store r3
	quietly ivreg2 dlogdaysonmarket dkw ddaysinv $house $year,  cluster($se), if (inkw == 1 | kwdist > $dT) & (zscore > $c - `h4') & (zscore < $c + `h4') & kwexcl == 0 & mun == 363
	estimates store r4
	quietly ivreg2 dlogdaysonmarket dkw ddaysinv $house $year,  cluster($se), if (inkw == 1 | kwdist > $dT) & (zscore > $c - `h5') & (zscore < $c + `h5') & kwexcl == 0 & mun == 599
	estimates store r5
	quietly ivreg2 dlogdaysonmarket dkw ddaysinv $house $year,  cluster($se), if (inkw == 1 | kwdist > $dT) & (zscore > $c - `h6') & (zscore < $c + `h6') & kwexcl == 0 & mun == 514
	estimates store r6
	
	estimates restore r1
	outreg2 using "Results\Table C6", label aster replace word title(Baseline results - first-differences) ctitle(OLS - FD) nocon alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) keep(dkw* dday*)
	estimates restore r2
	outreg2 using "Results\Table C6", append label aster word ctitle(OLS - FD) nocon alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) keep(dkw* dday*)
	estimates restore r3
	outreg2 using "Results\Table C6", append label aster word ctitle(OLS - FD) nocon alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) keep(dkw* dday*)
	estimates restore r4
	outreg2 using "Results\Table C6", append label aster word ctitle(OLS - FD) nocon alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) keep(dkw* dday*)
	estimates restore r5
	outreg2 using "Results\Table C6", append label aster word ctitle(OLS - FD) nocon alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) keep(dkw* dday*)
	estimates restore r6
	outreg2 using "Results\Table C6", append label aster word ctitle(OLS - FD) nocon alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) keep(dkw* dday*)
}
	
if $rentalh ==1 {
	
	local h1 = 5.3010251
	local h2 = 5.1488446
	local h3 = 5.1994219
	local h4 = 6.5567861
	local h5 = 5.6519791
	local h6 = 6.0170594
	
	ivreg2 dlogpricesqm (dkw=dscorerule) $house $neighbourhood $year,  cluster($se) , if (inkw == 1 | kwdist > $dT) & (zscore > $c - `h1') & (zscore < $c + `h1') & beforeafter==0
	qui estimates store r1
	ivreg2 dlogpricesqm (dkw=dscorerule) dshprivrent dshownocc $house $neighbourhood $year,  cluster($se) , if (inkw == 1 | kwdist > $dT) & (zscore > $c - `h1') & (zscore < $c + `h1') & beforeafter==0
	qui estimates store r2
	ivreg2 dlogpricesqm (dkw=dscorerule) dshwprivrent dshwownocc $house $neighbourhood $year,  cluster($se) , if (inkw == 1 | kwdist > $dT) & (zscore > $c - `h1') & (zscore < $c + `h1') & beforeafter==0
	qui estimates store r3
	ivreg2 dlogdaysonmarket (dkw=dscorerule) ddaysinv $house $neighbourhood $year,  cluster($se) , if (inkw == 1 | kwdist > $dT) & (zscore > $c - `h1') & (zscore < $c + `h1') & beforeafter==0
	qui estimates store r4	
	ivreg2 dlogdaysonmarket (dkw=dscorerule) ddaysinv dshprivrent dshownocc $house $neighbourhood $year,  cluster($se) , if (inkw == 1 | kwdist > $dT) & (zscore > $c - `h1') & (zscore < $c + `h1') & beforeafter==0
	qui estimates store r5	
	ivreg2 dlogdaysonmarket (dkw=dscorerule) ddaysinv dshwprivrent dshwownocc $house $neighbourhood $year,  cluster($se) , if (inkw == 1 | kwdist > $dT) & (zscore > $c - `h1') & (zscore < $c + `h1') & beforeafter==0
	qui estimates store r6
	
	estimates restore r1
	outreg2 using "Results\Table C7", label aster replace word title(Baseline results - first-differences) ctitle(OLS - FD) nocon keep(dkw ddaysinv dsh*) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) nor2 addstat("Kleibergen-Paap F", e(widstat))
	estimates restore r2
	outreg2 using "Results\Table C7", append label aster word ctitle(OLS - FD) nocon keep(dkw ddaysinv dsh*) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) nor2 addstat("Kleibergen-Paap F", e(widstat))
	estimates restore r3
	outreg2 using "Results\Table C7", append label aster word ctitle(OLS - FD) nocon keep(dkw ddaysinv dsh*) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) nor2 addstat("Kleibergen-Paap F", e(widstat))
	estimates restore r4
	outreg2 using "Results\Table C7", append label aster word ctitle(OLS - FD) nocon keep(dkw ddaysinv dsh*) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) nor2 addstat("Kleibergen-Paap F", e(widstat))
	estimates restore r5
	outreg2 using "Results\Table C7", append label aster word ctitle(OLS - FD) nocon keep(dkw ddaysinv dsh*) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) nor2 addstat("Kleibergen-Paap F", e(widstat))
	estimates restore r6
	outreg2 using "Results\Table C7", append label aster word ctitle(OLS - FD) nocon keep(dkw ddaysinv dsh*) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) nor2 addstat("Kleibergen-Paap F", e(widstat))
		
}

	
	
if $date == 1 {
	local h1 = 3.2283022
	local h2 = 3.2325402
	local h3 = 3.5400716
	local h4 = 6.2524981
	local h5 = 6.2814572
	local h6 = 7.9626131
	
	ivreg2 dlogpricesqm (dkw_alt1=dscorerule_date1) $house $neighbourhood $year,  cluster($se) endog(dkw_alt1), if (inkw == 1 | kwdist > $dT) & (zscore > $c - `h1') & (zscore < $c + `h1') 
	estimates store r1
	ivreg2 dlogpricesqm (dkw_alt2=dscorerule_date2) $house $neighbourhood $year,  cluster($se) endog(dkw_alt2), if (inkw == 1 | kwdist > $dT) & (zscore > $c - `h2') & (zscore < $c + `h2')
	estimates store r2
	ivreg2 dlogpricesqm (dkw=dscorerule) $house $neighbourhood $year,  cluster($se) endog(dkw), if (inkw == 1 | kwdist > $dT) & (zscore > $c - `h3') & (zscore < $c + `h3') & (year!=2007 & yearmin!=2007)
	estimates store r3
	ivreg2 dlogdaysonmarket (dkw_alt1 ddaysinv=dscorerule_date1 ddaysinv_sc) $house $neighbourhood $year,  cluster($se) endog(dkw_alt1), if (inkw == 1 | kwdist > $dT) & (zscore > $c - `h4') & (zscore < $c + `h4') 
	estimates store r4
	ivreg2 dlogdaysonmarket (dkw_alt2 ddaysinv=dscorerule_date2  ddaysinv_sc) $house $neighbourhood $year,  cluster($se) endog(dkw_alt2), if (inkw == 1 | kwdist > $dT) & (zscore > $c - `h5') & (zscore < $c + `h5')
	estimates store r5
	ivreg2 dlogdaysonmarket (dkw ddaysinv=dscorerule ddaysinv_sc) $house $neighbourhood $year,  cluster($se) endog(dkw), if (inkw == 1 | kwdist > $dT) & (zscore > $c - `h6') & (zscore < $c + `h6') & (year!=2007 & yearmin!=2007)
	estimates store r6
	
	estimates restore r1
	outreg2 using "Results\Table C8", keep(dkw*) label aster nor2 replace word title(Baseline results - first-differences) ctitle(IV - FD) nocon addstat("Kleibergen-Paap F", e(widstat)) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) 
	estimates restore r2
	outreg2 using "Results\Table C8", keep(dkw*) append label aster nor2 word ctitle(IV - FD) nocon addstat("Kleibergen-Paap F", e(widstat)) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +)   
	estimates restore r3
	outreg2 using "Results\Table C8", keep(dkw*) append label aster nor2 word ctitle(IV - FD) nocon addstat("Kleibergen-Paap F", e(widstat)) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +)  
	estimates restore r4
	outreg2 using "Results\Table C8", keep(dkw* ddays*) append label aster nor2 word ctitle(IV - FD) nocon addstat("Kleibergen-Paap F", e(widstat)) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +)   
	estimates restore r5
	outreg2 using "Results\Table C8", keep(dkw*  ddays*) append label aster nor2 word ctitle(IV - FD) nocon addstat("Kleibergen-Paap F", e(widstat)) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +)  
	estimates restore r6
	outreg2 using "Results\Table C8", keep(dkw*  ddays*) append label aster nor2 word ctitle(IV - FD) nocon addstat("Kleibergen-Paap F", e(widstat)) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +)  

}

if $bandwidth == 1 {
	local h1 = 3.2287644
	local h2 = 6.2193224
	
	ivreg2 dlogpricesqm (dkw=dscorerule) $house $year zscorescrule_* zscorenscrule_*,  cluster($se) endog(dkw), if (inkw == 1 | kwdist > $dT)
	estimates store r1
	ivreg2 dlogpricesqm (dkw=dscorerule) $house $year,  cluster($se) endog(dkw), if (inkw == 1 | kwdist > $dT) & (zscore > $c - `h1'/2) & (zscore < $c + `h1'/2)
	estimates store r2
	ivreg2 dlogpricesqm (dkw=dscorerule) $house $year,  cluster($se) endog(dkw), if (inkw == 1 | kwdist > $dT) & (zscore > $c - `h1'*2) & (zscore < $c + `h1'*2)
	estimates store r3
	ivreg2 dlogdaysonmarket (dkw ddaysinv=dscorerule ddaysinv_sc) $house $year zscorescrule_* zscorenscrule_*,  cluster($se) endog(dkw), if (inkw == 1 | kwdist > $dT)
	estimates store r4
	ivreg2 dlogdaysonmarket (dkw ddaysinv=dscorerule ddaysinv_sc) $house $year,  cluster($se) endog(dkw), if (inkw == 1 | kwdist > $dT) & (zscore > $c - `h2'/2) & (zscore < $c + `h2'/2)
	estimates store r5
	ivreg2 dlogdaysonmarket (dkw ddaysinv=dscorerule ddaysinv_sc) $house $year,  cluster($se) endog(dkw), if (inkw == 1 | kwdist > $dT) & (zscore > $c - `h2'*2) & (zscore < $c + `h2'*2)
	estimates store r6

	estimates restore r1
	outreg2 using "Results\Table C9", keep(dkw* ddays*) label aster nor2 replace word title(Baseline results - first-differences) ctitle(IV - FD) nocon addstat("Kleibergen-Paap F", e(widstat)) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) 
	estimates restore r2
	outreg2 using "Results\Table C9", keep(dkw* ddays*) append label aster nor2 word ctitle(IV - FD) nocon addstat("Kleibergen-Paap F", e(widstat)) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +)   
	estimates restore r3
	outreg2 using "Results\Table C9", keep(dkw* ddays*) append label aster nor2 word ctitle(IV - FD) nocon addstat("Kleibergen-Paap F", e(widstat)) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +)    
	estimates restore r4
	outreg2 using "Results\Table C9", keep(dkw* ddays*) append label aster nor2 word ctitle(IV - FD) nocon addstat("Kleibergen-Paap F", e(widstat)) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) 
	estimates restore r5
	outreg2 using "Results\Table C9", keep(dkw* ddays*) append label aster nor2 word ctitle(IV - FD) nocon addstat("Kleibergen-Paap F", e(widstat)) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) 
	estimates restore r6
	outreg2 using "Results\Table C9", keep(dkw* ddays*) append label aster nor2 word ctitle(IV - FD) nocon addstat("Kleibergen-Paap F", e(widstat)) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) 
}



if $fullsample == 1 {
	
	use "NVM_20002014_full.dta", clear

	global house logsize rooms maintgood centralheating listed terraced semidetached detached garage garden constr19451959 constr19601970 constr19711980 constr19811990 constr19912000 constrgt2000
	global neighbourhood logpopdens shforeign shyoung shold hhsize 
	global landuse luinfr luind luopens luwater 
	
	global dmhouse dmlogsize dmrooms dmmaintgood dmcentralheating dmlisted dmterraced dmsemidetached dmdetached dmgarage dmgarden dmconstr19451959 dmconstr19601970 dmconstr19711980 dmconstr19811990 dmconstr19912000 dmconstrgt2000
	global dmneighbourhood dmlogpopdens dmshforeign dmshyoung dmshold dmhhsize 
	global dmlanduse dmluinfr dmluind dmluopens dmluwater 

	
	g weight = 0
	global dT = 2.5
	global zD = 2
	global zMAX = 7.3+$zD
	global zMIN = 7.3-$zD
	*replace weight = (1-((abs(zscore-7.3))/$zD)^4)^4 if abs(zscore-7.3)<$zD
	replace weight = 1 if abs(zscore-7.3)<$zD

	tostring pc4, g(pc2)
	replace pc2 = substr(pc2,1,3)
	destring pc2, force replace 

	g nofe = 1
	global fe pc6
	global se pc4
		
	xtset pc6

	*xi: areg logpricesqm kw $house i.year, cluster($se) absorb($fe)
	*estimates store r1
	*xi: areg logdaysonmarket kw $house i.year, cluster($se) absorb($fe)
	*estimates store r4
	
	local h1 = 3.1756895
	local h2 = 3.1777779
	local h3 = 6.1756316
	local h4 = 6.1975228

	regress dmlogpricesqm dmkw $dmhouse dmyear_*, cluster($se), if (kwdist == 0 | kwdist > $dT)
	estimates store r1	
	ivreg2 dmlogpricesqm (dmkw=dmscorerule) $dmhouse dmyear_*, cluster($se), if (kwdist == 0 | kwdist > $dT) & (zscore > $c - `h1') & (zscore < $c + `h1')
	estimates store r2
	ivreg2 dmlogpricesqm (dmkw=dmscorerule) $dmhouse $dmneighbourhood $dmlanduse dmyear_*, cluster($se), if (kwdist == 0 | kwdist > $dT) & (zscore > $c - `h2') & (zscore < $c + `h2')
	estimates store r3
	regress dmlogdaysonmarket dmkw dmdaysinv $dmhouse dmyear_*, cluster($se), if (kwdist == 0 | kwdist > $dT)
	estimates store r4
	ivreg2 dmlogdaysonmarket (dmkw dmdaysinv =dmscorerule dmdaysinv1_sc) $dmhouse dmyear_*, cluster($se), if (kwdist == 0 | kwdist > $dT) & (zscore > $c - `h3') & (zscore < $c + `h3') 
	estimates store r5
	ivreg2 dmlogdaysonmarket (dmkw dmdaysinv =dmscorerule dmdaysinv1_sc) $dmhouse $dmneighbourhood $dmlanduse dmyear_*, cluster($se), if (kwdist == 0 | kwdist > $dT) & (zscore > $c - `h4') & (zscore < $c + `h4')
	estimates store r6
	
	estimates restore r1
	outreg2 using "Results\Table C10", label aster replace word title(Baseline results - first-differences) ctitle(OLS - FD) nocon keep(dmkw) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +)
	estimates restore r2
	outreg2 using "Results\Table C10", append label aster nor2 word ctitle(IV - FD) nocon addstat("Kleibergen-Paap F", e(widstat)) keep(dmkw) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +)  
	estimates restore r3
	outreg2 using "Results\Table C10", append label aster nor2 word ctitle(IV - FD) nocon addstat("Kleibergen-Paap F", e(widstat)) keep(dmkw) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +)  
	estimates restore r4
	outreg2 using "Results\Table C10", append label aster word ctitle(OLS - FD) nocon keep(dmkw dmdays*) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) 
	estimates restore r5
	outreg2 using "Results\Table C10", append label aster nor2 word ctitle(IV - FD) nocon addstat("Kleibergen-Paap F", e(widstat)) keep(dmkw dmdays*) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +)  
	estimates restore r6
	outreg2 using "Results\Table C10", append label aster nor2 word ctitle(IV - FD) nocon addstat("Kleibergen-Paap F", e(widstat))  keep(dmkw dmdays*) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +)  

	}


if $RDDlevels == 1 {
	
	use "NVM_20002014_full.dta", clear
	g after = year > 2008
	//1-1*(year < $tyear | (year == $tyear & month < $tmonth) | (year == $tyear & month == $tmonth & day <= $tday))
	g inscoringrule = (zscore>=7.3)
	g kwexcl = ((zscore>=7.3 & inkw == 0) | (zscore<7.3 & inkw == 1))
	
	global house logsize rooms maintgood centralheating listed terraced semidetached detached garage garden constr19451959 constr19601970 constr19711980 constr19811990 constr19912000 constrgt2000
	global neighbourhood logincome logpopdens shforeign shyoung shold hhsize 
	global landuse luinfr luind luopens luwater 
	
	global dmhouse dmlogsize dmrooms dmmaintgood dmcentralheating dmlisted dmterraced dmsemidetached dmdetached dmgarage dmgarden dmconstr19451959 dmconstr19601970 dmconstr19711980 dmconstr19811990 dmconstr19912000 dmconstrgt2000
	global dmneighbourhood dmlogincome dmlogpopdens dmshforeign dmshyoung dmshold dmhhsize 
	global dmlanduse dmluinfr dmluind dmluopens dmluwater 
	
	g weight = 0
	global dT = 2.5
	global zD = 2
	global zMAX = 7.3+$zD
	global zMIN = 7.3-$zD
	*replace weight = (1-((abs(zscore-7.3))/$zD)^4)^4 if abs(zscore-7.3)<$zD
	replace weight = 1 if abs(zscore-7.3)<$zD

	tostring pc4, g(pc2)
	replace pc2 = substr(pc2,1,3)
	destring pc2, force replace 

	g nofe = 1
	global fe pc6
	global se pc4
		
	xtset pc6

	local h1 = 1.1119629
	local h2 = 1.1595652
	local h3 = 1.1216639
	local h4 = 5.803746
	local h5 = 6.0083555
	local h6 = 4.3996033
	
	
	regress logpricesqm kw $house year_*, cluster($se), if (kwdist == 0 | kwdist > $dT) & ((zscore > $c - `h1') & (zscore < $c + `h1')) & after == 1 & kwexcl == 0
	estimates store r1	
	ivreg2 logpricesqm (kw=scorerule) $house year_*, cluster($se), if (kwdist == 0 | kwdist > $dT) & ((zscore > $c - `h2') & (zscore < $c + `h2')) & after == 1
	estimates store r2
	ivreg2 logpricesqm (kw=scorerule) $house $neighbourhood $landuse year_*, cluster($se), if (kwdist == 0 | kwdist > $dT) & ((zscore > $c - `h3') & (zscore < $c + `h3')) & after == 1 
	estimates store r3
	regress logdaysonmarket kw $house year_*, cluster($se), if (kwdist == 0 | kwdist > $dT) & ((zscore > $c - `h4') & (zscore < $c + `h4')) & after == 1 & kwexcl == 0
	estimates store r4
	ivreg2 logdaysonmarket (kw=scorerule) $house year_*, cluster($se), if (kwdist == 0 | kwdist > $dT) & ((zscore > $c - `h5') & (zscore < $c + `h5')) & after == 1
	estimates store r5
	ivreg2 logdaysonmarket (kw=scorerule) $house $neighbourhood $landuse year_*, cluster($se), if (kwdist == 0 | kwdist > $dT) & ((zscore > $c - `h6') & (zscore < $c + `h6')) & after == 1 
	estimates store r6
	
	regress logpricesqm inkw $house year_*, cluster($se), if (kwdist == 0 | kwdist > $dT) & ((zscore > $c - `h1') & (zscore < $c + `h1')) & after == 0 & kwexcl == 0
	estimates store r7	
	ivreg2 logpricesqm (inkw =inscoringrule) $house year_*, cluster($se), if (kwdist == 0 | kwdist > $dT) & ((zscore > $c - `h2') & (zscore < $c + `h2')) & after == 0
	estimates store r8
	ivreg2 logpricesqm (inkw =inscoringrule) $house $neighbourhood $landuse year_*, cluster($se), if (kwdist == 0 | kwdist > $dT) & ((zscore > $c - `h3') & (zscore < $c + `h3')) & after == 0 
	estimates store r9
	regress logdaysonmarket inkw  $house year_*, cluster($se), if (kwdist == 0 | kwdist > $dT) & ((zscore > $c - `h4') & (zscore < $c + `h4')) & after == 0 & kwexcl == 0
	estimates store r10
	ivreg2 logdaysonmarket (inkw=inscoringrule) $house year_*, cluster($se), if (kwdist == 0 | kwdist > $dT) & ((zscore > $c - `h5') & (zscore < $c + `h5')) & after == 0 
	estimates store r11
	ivreg2 logdaysonmarket (inkw=inscoringrule) $house $neighbourhood $landuse year_*, cluster($se), if (kwdist == 0 | kwdist > $dT) & ((zscore > $c - `h6') & (zscore < $c + `h6')) & after == 0 
	estimates store r12
	
	estimates restore r1
	outreg2 using "Results\Table C11", label aster replace word title(Baseline results - first-differences) ctitle(OLS - FD) nocon alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) keep(kw) nor2 
	estimates restore r2
	outreg2 using "Results\Table C11", append label aster nor2 word ctitle(IV - FD) nocon addstat("Kleibergen-Paap F", e(widstat)) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) keep(kw)  
	estimates restore r3
	outreg2 using "Results\Table C11", append label aster nor2 word ctitle(IV - FD) nocon addstat("Kleibergen-Paap F", e(widstat)) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) keep(kw)  
	estimates restore r4
	outreg2 using "Results\Table C11", append label aster word ctitle(OLS - FD) nocon alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) keep(kw) 
	estimates restore r5
	outreg2 using "Results\Table C11", append label aster nor2 word ctitle(IV - FD) nocon addstat("Kleibergen-Paap F", e(widstat)) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) keep(kw)  
	estimates restore r6
	outreg2 using "Results\Table C11", append label aster nor2 word ctitle(IV - FD) nocon addstat("Kleibergen-Paap F", e(widstat)) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) keep(kw)  

	estimates restore r7
	outreg2 using "Results\Table C11b", label aster replace word title(Baseline results - first-differences) ctitle(OLS - FD) nocon alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) keep(inkw) nor2 
	estimates restore r8
	outreg2 using "Results\Table C11b", append label aster nor2 word ctitle(IV - FD) nocon addstat("Kleibergen-Paap F", e(widstat)) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) keep(inkw)  
	estimates restore r9
	outreg2 using "Results\Table C11b", append label aster nor2 word ctitle(IV - FD) nocon addstat("Kleibergen-Paap F", e(widstat)) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) keep(inkw)  
	estimates restore r10
	outreg2 using "Results\Table C11b", append label aster word ctitle(OLS - FD) nocon alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) keep(inkw) 
	estimates restore r11
	outreg2 using "Results\Table C11b", append label aster nor2 word ctitle(IV - FD) nocon addstat("Kleibergen-Paap F", e(widstat)) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) keep(inkw)  
	estimates restore r12
	outreg2 using "Results\Table C11b", append label aster nor2 word ctitle(IV - FD) nocon addstat("Kleibergen-Paap F", e(widstat)) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) keep(inkw)  
	
}
	


if $psm == 1 {

	quietly regress dlogpricesqm dkw $house $neighbourhood $year, cluster($se), if (kwdist == 0 | kwdist > $dT) & psm_c == 1
	estimates store r1
	quietly regress dlogpricesqm dkw $house $neighbourhood $year, cluster($se), if (kwdist == 0 | kwdist > $dT) & psm_nnwor == 1
	estimates store r2
	quietly regress dlogpricesqm dkw $house $neighbourhood $year, cluster($se), if (kwdist == 0 | kwdist > $dT) & psm_nnwr == 1
	estimates store r3
	quietly regress dlogdaysonmarket dkw ddaysinv $house $neighbourhood $year, cluster($se), if (kwdist == 0 | kwdist > $dT) & psm_c == 1
	estimates store r4
	quietly regress dlogdaysonmarket dkw ddaysinv $house $neighbourhood $year, cluster($se), if (kwdist == 0 | kwdist > $dT) & psm_nnwor == 1	
	estimates store r5
	quietly regress dlogdaysonmarket dkw ddaysinv $house $neighbourhood $year, cluster($se), if (kwdist == 0 | kwdist > $dT) & psm_nnwr == 1
	estimates store r6

	estimates restore r1
	outreg2 using "Results\Table C12", label aster replace word title(Baseline results - first-differences) ctitle(OLS - FD) nocon keep(dkw ddaysinv) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +)
	estimates restore r2
	outreg2 using "Results\Table C12", append label aster word ctitle(OLS - FD) nocon keep(dkw ddaysinv) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +)
	estimates restore r3
	outreg2 using "Results\Table C12", append label aster word ctitle(OLS - FD) nocon keep(dkw ddaysinv) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +)
	estimates restore r4
	outreg2 using "Results\Table C12", append label aster word ctitle(OLS - FD) nocon keep(dkw ddaysinv) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +)
	estimates restore r5
	outreg2 using "Results\Table C12", append label aster word ctitle(OLS - FD) nocon keep(dkw ddaysinv) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +)
	estimates restore r6
	outreg2 using "Results\Table C12", append label aster word ctitle(OLS - FD) nocon keep(dkw ddaysinv) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +)
	
}

if $demographicsrev {
	local h1 = 3.6656511
	local h2 = 3.8714645
	local h3 = 3.7096246
	local h4 = 3.0121421
	local h5 = 3.1606134
	
	local h6 = 9.7285954
	local h7 = 5.9284943
	local h8 = 8.172599
	local h9 = 9.0712438
	local h10 = 8.6180716
	
	ivreg2 dlogpricesqm (dkw = dscorerule) $house dlogincome dlogpopdens dshyoung dshforeign dshold dhhsize $year,  cluster($se) endog(dkw), if (inkw == 1 | kwdist > $dT) & (zscore > $c - `h1') & (zscore < $c + `h1') & beforeafter == 0
	estimates store r1
	ivreg2 dlogpricesqm (dkw = dscorerule) $house dluinfr dluind dluopens dluwater  $year,  cluster($se) endog(dkw), if (inkw == 1 | kwdist > $dT) & (zscore > $c - `h2') & (zscore < $c + `h2') & beforeafter == 0
	estimates store r2
	ivreg2 dlogpricesqm (dkw dshforeign = dscorerule dshforeignpred) $house dlogincome dlogpopdens dshyoung dshold dhhsize dluinfr dluind dluopens dluwater $neighbourhoodex $year,  cluster($se) endog(dkw), if (inkw == 1 | kwdist > $dT) & (zscore > $c - `h3') & (zscore < $c + `h3') & beforeafter == 0
	estimates store r3
	ivreg2 dlogpricesqm (dkw dshold = dscorerule dsholdnpred) $house dlogincome dlogpopdens dshforeign dshyoung dhhsize dluinfr dluind dluopens dluwater $neighbourhoodex $year,  cluster($se) endog(dkw), if (inkw == 1 | kwdist > $dT) & (zscore > $c - `h4') & (zscore < $c + `h4') & beforeafter == 0
	estimates store r4
	ivreg2 dlogpricesqm (dkw dshforeign dshold = dscorerule dshforeignpred dsholdnpred) $house dlogincome dlogpopdens dshyoung dhhsize dluinfr dluind dluopens dluwater $neighbourhoodex $year,  cluster($se) endog(dkw), if (inkw == 1 | kwdist > $dT) & (zscore > $c - `h5') & (zscore < $c + `h5') & beforeafter == 0
	estimates store r5
	
	ivreg2 dlogdaysonmarket (dkw ddaysinv = dscorerule ddaysinv_sc) $house dlogincome dlogpopdens dshyoung dshforeign dshold dhhsize $year,  cluster($se) endog(dkw), if (inkw == 1 | kwdist > $dT) & (zscore > $c - `h6') & (zscore < $c + `h6') & beforeafter == 0
	estimates store r6
	ivreg2 dlogdaysonmarket (dkw ddaysinv = dscorerule ddaysinv_sc) $house dluinfr dluind dluopens dluwater $year,  cluster($se) endog(dkw), if (inkw == 1 | kwdist > $dT) & (zscore > $c - `h7') & (zscore < $c + `h7') & beforeafter == 0
	estimates store r7
	ivreg2 dlogdaysonmarket (dkw ddaysinv dshforeign = dscorerule ddaysinv_sc dshforeignpred) $house dlogincome dlogpopdens dshyoung dshold dhhsize dluinfr dluind dluopens dluwater $neighbourhoodex $year,  cluster($se) endog(dkw), if (inkw == 1 | kwdist > $dT) & (zscore > $c - `h8') & (zscore < $c + `h8') & beforeafter == 0
	estimates store r8
	ivreg2 dlogdaysonmarket (dkw ddaysinv dshold = dscorerule ddaysinv_sc dsholdnpred) $house dlogincome dlogpopdens dshforeign dshyoung dhhsize dluinfr dluind dluopens dluwater $neighbourhoodex $year,  cluster($se) endog(dkw), if (inkw == 1 | kwdist > $dT) & (zscore > $c - `h9') & (zscore < $c + `h9') & beforeafter == 0
	estimates store r9
	ivreg2 dlogdaysonmarket (dkw ddaysinv dshforeign dshold = dscorerule ddaysinv_sc dshforeignpred dsholdnpred) $house dlogincome dlogpopdens dshyoung dhhsize dluinfr dluind dluopens dluwater $neighbourhoodex $year,  cluster($se) endog(dkw), if (inkw == 1 | kwdist > $dT) & (zscore > $c - `h10') & (zscore < $c + `h10') & beforeafter == 0
	estimates store r10
	
	
	estimates restore r1
	outreg2 using "Results\Table C13", label aster replace word title(Baseline results - first-differences) ctitle(OLS - FD) nocon keep(dkw ddaysinv $neighbourhood) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) nor2 addstat("Kleibergen-Paap F", e(widstat))
	estimates restore r2
	outreg2 using "Results\Table C13", append label aster word ctitle(OLS - FD) nocon keep(dkw ddaysinv $neighbourhood) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) nor2 addstat("Kleibergen-Paap F", e(widstat))
	estimates restore r3
	outreg2 using "Results\Table C13", append label aster word ctitle(OLS - FD) nocon keep(dkw ddaysinv $neighbourhood) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) nor2 addstat("Kleibergen-Paap F", e(widstat))
	estimates restore r4
	outreg2 using "Results\Table C13", append label aster word ctitle(OLS - FD) nocon keep(dkw ddaysinv $neighbourhood) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) nor2 addstat("Kleibergen-Paap F", e(widstat))
	estimates restore r5
	outreg2 using "Results\Table C13", append label aster word ctitle(OLS - FD) nocon keep(dkw ddaysinv $neighbourhood) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) nor2 addstat("Kleibergen-Paap F", e(widstat))
	estimates restore r6
	outreg2 using "Results\Table C13", append label aster word ctitle(OLS - FD) nocon keep(dkw ddaysinv $neighbourhood) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) nor2 addstat("Kleibergen-Paap F", e(widstat))
	estimates restore r7
	outreg2 using "Results\Table C13", append label aster word ctitle(OLS - FD) nocon keep(dkw ddaysinv $neighbourhood) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) nor2 addstat("Kleibergen-Paap F", e(widstat))
	estimates restore r8
	outreg2 using "Results\Table C13", append label aster word ctitle(OLS - FD) nocon keep(dkw ddaysinv $neighbourhood) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) nor2 addstat("Kleibergen-Paap F", e(widstat))
	estimates restore r9
	outreg2 using "Results\Table C13", append label aster word ctitle(OLS - FD) nocon keep(dkw ddaysinv $neighbourhood) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) nor2 addstat("Kleibergen-Paap F", e(widstat))
	estimates restore r10
	outreg2 using "Results\Table C13", append label aster word ctitle(OLS - FD) nocon keep(dkw ddaysinv $neighbourhood) alpha(0.01, 0.05, 0.10, 0.15) symbol(***, **, *, +) nor2 addstat("Kleibergen-Paap F", e(widstat))


}


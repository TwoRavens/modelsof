**********************************************
*	REPLICATION DO-FILE
*	"The fiscal benefits of repeated cooperation", Journal of Public Policy
*	David Weisstanner, david.weisstanner@ipw.unibe.ch
**********************************************

version 14.0
set more off, perm
capture log close
set scheme s1mono
cd "H:\PAPERS\MA_english\FINAL revised submission JPP"	// Set working directory

*	BASIC DATA SET FOR ANNUAL TSCS ANALYSIS:
use Data_TSCS_Annual.dta, clear
*	BASIC DATA SET FOR GOVERNMENT-CENTERED ANALYSIS:
use Data_Government_Centered.dta, clear

**********************************************
*	FIGURE 1: PROSPECTIVE COOPERATION AND DEBT RATIOS, 1960-2013
**********************************************

use Data_TSCS_Annual.dta, clear
replace debt_hist = 200 if country == "Bulgaria" & year == 1993
twoway area debt_hist year, yaxis(1) ytitle("Debt ratio (grey shade)") color(gs10) ///
	ylab(0(50)200,angle(hor) axis(1) format(%9.0f) nogrid) ///
	|| line procoop year, lcol(gs0) yaxis(2) ylab(0(0.25)1,angle(hor) axis(2) grid) ///
	|| , by(country, cols(6) iscale(0.5) legend(off) r2title("Prospective cooperation of coalitions (black line)")) ///
	ysize(10) xsize(12) yscale(r(0 1)) xlab(1960(10)2000 2013, angle(45)) ///
	xtitle("Year")

**********************************************
*	FIGURE 2: GROUP DIFFERENCE BETWEEN COALITION AND SINGLE-PARTY GOVERNMENTS
**********************************************
	
postfile coalition_M4 ///
procoop_value SR_coalition_b SR_coalition_se SR_coalition_p ///
coalition_b coalition_se coalition_p ///
using postfile_coalition_M4, replace

forvalues i = 0.1(0.02)1.02 {
use Data_TSCS_Annual.dta, clear
		qui xtpcse D.debt_hist L.D.debt_hist L.debt_hist realgdpgr unemp D.unemp debtservice coalition L.coalition survival L.survival ///
		procoop L.procoop electionyear L.electionyear minority govleft1 pres fed bic time time2 time3, pairwise
					qui lincom coalition - procoop * (1 - `i')
						scalar SR_coalition_b = r(estimate)
						scalar SR_coalition_se = r(se)
						qui test coalition - procoop * (1 - `i') = 0
						scalar SR_coalition_p = r(p)
		qui xtpcse D.D.debt_hist L.D.debt_hist L.debt_hist realgdpgr unemp D.unemp debtservice coalition D.coalition survival D.survival ///
		procoop D.procoop electionyear D.electionyear minority govleft1 pres fed bic time time2 time3, pairwise
			predict deltaYhat4
		qui xtpcse D.debt_hist deltaYhat4 L.debt_hist realgdpgr unemp D.unemp debtservice coalition D.coalition survival D.survival ///
		procoop D.procoop electionyear D.electionyear minority govleft1 pres fed bic time time2 time3, pairwise
					qui lincom coalition - procoop * (1 - `i')
						scalar coalition_b = r(estimate)
						scalar coalition_se = r(se)
						qui test coalition - procoop * (1 - `i') = 0
						scalar coalition_p = r(p)
					scalar procoop_value = `i'
					
post coalition_M4 ///
(procoop_value) (SR_coalition_b) (SR_coalition_se) (SR_coalition_p) ///
(coalition_b) (coalition_se) (coalition_p)
}
postclose coalition_M4

use postfile_coalition_M4, clear
gen procoop_freq = .
replace procoop_freq = 9 if procoop_value >= 0.1 & procoop_value <= 0.2
replace procoop_freq = 17 if procoop_value > 0.2 & procoop_value <= 0.3
replace procoop_freq = 24 if procoop_value > 0.3 & procoop_value <= 0.4
replace procoop_freq = 48 if procoop_value > 0.4 & procoop_value <= 0.5
replace procoop_freq = 74 if procoop_value > 0.5 & procoop_value <= 0.6
replace procoop_freq = 116 if procoop_value > 0.6 & procoop_value <= 0.7
replace procoop_freq = 136 if procoop_value > 0.7 & procoop_value <= 0.8
replace procoop_freq = 137 if procoop_value > 0.8 & procoop_value <= 0.9
replace procoop_freq = 178 if procoop_value > 0.9 & procoop_value <= 1

replace procoop_freq = procoop_freq / 35	// rescaling the bars
gen coalition_LB = coalition_b - 1.96*coalition_se
gen coalition_UB = coalition_b + 1.96*coalition_se
gen SR_coalition_LB = SR_coalition_b - 1.96*SR_coalition_se
gen SR_coalition_UB = SR_coalition_b + 1.96*SR_coalition_se
sort procoop_value
***	Short run
twoway spike procoop_freq procoop_value, base(0) lcol(gs12) || line SR_coalition_LB SR_coalition_b SR_coalition_UB procoop_value, lcol(gs0 gs0 gs0) lpatt(dash solid dash) ///
	lwidth(medium medium medium) yline(0) ytitle("Coalition effect",size(large)) xtitle("Prospective cooperation",size(large)) legend(off) ylab(6(1)-3,labsize(large)) ///
	xlab(,labsize(large)) title("Short-run effect of coalition government")
***	Long run
twoway spike procoop_freq procoop_value, base(0) lcol(gs12) || line coalition_LB coalition_b coalition_UB procoop_value, lcol(gs0 gs0 gs0) lpatt(dash solid dash) ///
	lwidth(medium medium medium) yline(0) ytitle("Coalition effect",size(large)) xtitle("Prospective cooperation",size(large)) legend(off) ylab(6(1)-3,labsize(large)) ///
	xlab(,labsize(large)) title("Long-run effect of coalition government")

**********************************************
*	TABLE 1: ADL REGRESSIONS OF ANNUAL DEBT CHANGES
*	TABLE 3: CONDITIONAL EFFECTS OF PROSPECTIVE COOPERATION (through lincom commands)
**********************************************

***		MODEL 1: BASIC ECONOMIC MODEL
	use Data_TSCS_Annual.dta, clear
		xtpcse D.debt_hist L.D.debt_hist L.debt_hist realgdpgr unemp D.unemp debtservice time time2 time3, pairwise

***		MODEL 2: BASIC ECONOMIC MODEL AND COALITION EFFECT
	use Data_TSCS_Annual.dta, clear
		*	SHORT-RUN EFFECTS (T0):
		xtpcse D.debt_hist L.D.debt_hist L.debt_hist realgdpgr unemp D.unemp debtservice coalition L.coalition time time2 time3, pairwise
				lincom coalition
		*	LONG-RUN EFFECTS (LRM):
		xtpcse D.D.debt_hist L.D.debt_hist 	L.debt_hist realgdpgr unemp D.unemp debtservice coalition D.coalition time time2 time3, pairwise
			predict deltaYhat2
		xtpcse D.debt_hist deltaYhat2 		L.debt_hist realgdpgr unemp D.unemp debtservice coalition D.coalition time time2 time3, pairwise
				lincom coalition

***		MODEL 3: BASIC ECONOMIC MODEL, COALITION EFFECT PLUS COOPERATION EFFECT
	use Data_TSCS_Annual.dta, clear
		*	SHORT-RUN EFFECTS (T0):
		xtpcse D.debt_hist L.D.debt_hist L.debt_hist realgdpgr unemp D.unemp debtservice coalition L.coalition procoop L.procoop time time2 time3, pairwise
		*	LONG-RUN EFFECTS (LRM):
		xtpcse D.D.debt_hist L.D.debt_hist 	L.debt_hist realgdpgr unemp D.unemp debtservice coalition D.coalition procoop D.procoop time time2 time3, pairwise
			predict deltaYhat3
		xtpcse D.debt_hist deltaYhat3 		L.debt_hist realgdpgr unemp D.unemp debtservice coalition D.coalition procoop D.procoop time time2 time3, pairwise
				lincom procoop

***		MODEL 4: MODEL WITH ALL POLITICAL VARIABLES, NO INTERACTIONS
	use Data_TSCS_Annual.dta, clear
		*	SHORT-RUN EFFECTS (T0):
		xtpcse D.debt_hist L.D.debt_hist L.debt_hist realgdpgr unemp D.unemp debtservice coalition L.coalition survival L.survival ///
		procoop L.procoop electionyear L.electionyear minority govleft1 pres fed bic time time2 time3, pairwise
		*	Short-run effect of coalition (by procoop):
					lincom coalition - procoop * (1 - 1)			// for procoop = 1
					lincom coalition - procoop * (1 - 0.666)		// for procoop = 0.666
					lincom coalition - procoop * (1 - 0.333)		// for procoop = 0.333
		*	Short-run effect of procoop:
					lincom procoop
		*	Short-run effect of electionyear:
					lincom electionyear		
		*	LONG-RUN EFFECTS (LRM):
		xtpcse D.D.debt_hist L.D.debt_hist 	L.debt_hist realgdpgr unemp D.unemp debtservice coalition D.coalition survival D.survival ///
		procoop D.procoop electionyear D.electionyear minority govleft1 pres fed bic time time2 time3, pairwise
			predict deltaYhat4
		xtpcse D.debt_hist deltaYhat4 	L.debt_hist realgdpgr unemp D.unemp debtservice coalition D.coalition survival D.survival ///
		procoop D.procoop electionyear D.electionyear minority govleft1 pres fed bic time time2 time3, pairwise
		*	Long-run effect of coalition (by procoop):
					lincom coalition - procoop * (1 - 1)			// for procoop = 1
					lincom coalition - procoop * (1 - 0.666)		// for procoop = 0.666
					lincom coalition - procoop * (1 - 0.333)		// for procoop = 0.333
		*	Long-run effect of procoop:
					lincom procoop
		*	Long-run effect of electionyear
					lincom electionyear
		***	SUMMARY STATISTICS ***
		tabstat debt_hist_ch debt_hist_l1 realgdpgr unemp unemp_ch debtservice coalition survival ///
		procoop electionyear minority govleft1 pres fed bic time time2 time3 if e(sample), stat(count mean sd max min) col(stat)

**********************************************
*	TABLE 2: ADL REGRESSIONS OF ANNUAL DEBT CHANGES
*	TABLE 3: CONDITIONAL EFFECTS OF PROSPECTIVE COOPERATION (through lincom commands)
**********************************************

***		MODEL 5: INTERACTION BETWEEN COOPERATION AND ELECTIONYEAR
	use Data_TSCS_Annual.dta, clear
		*	SHORT-RUN EFFECTS (T0):
		xtpcse D.debt_hist L.D.debt_hist L.debt_hist realgdpgr unemp D.unemp debtservice coalition L.coalition survival L.survival ///
		c.procoop##c.electionyear c.L.procoop##c.L.electionyear minority govleft1 pres fed bic time time2 time3, pairwise
		*	Short-run effect of coalition (by procoop):
					lincom coalition - procoop * (1 - 1)			// for procoop = 1
					lincom coalition - procoop * (1 - 0.666)		// for procoop = 0.666
					lincom coalition - procoop * (1 - 0.333)		// for procoop = 0.333
		*	Short-run interaction between procoop and electionyear?
					lincom c.procoop#c.electionyear
		*	Short-run effect of procoop (by electionyear):
					lincom procoop								// for electionyear = 0
					lincom procoop + c.procoop#c.electionyear	// for electionyear = 1
		*	Short-run effect of electionyear (by procoop):
					lincom electionyear + c.procoop#c.electionyear * 1 		// for procoop = 1
					lincom electionyear + c.procoop#c.electionyear * 0.666	// for procoop = 0.666
					lincom electionyear + c.procoop#c.electionyear * 0.333	// for procoop = 0.333
		*	LONG-RUN EFFECTS (LRM):
		gen procoopXelectionyear = procoop * electionyear
		xtpcse D.D.debt_hist L.D.debt_hist L.debt_hist realgdpgr unemp D.unemp debtservice coalition D.coalition survival D.survival ///
		procoop electionyear procoopXelectionyear D.procoop D.electionyear D.procoopXelectionyear minority govleft1 pres fed bic time time2 time3, pairwise
			predict deltaYhat5
		xtpcse D.debt_hist deltaYhat5 L.debt_hist realgdpgr unemp D.unemp debtservice coalition D.coalition survival D.survival ///
		procoop electionyear procoopXelectionyear D.procoop D.electionyear D.procoopXelectionyear minority govleft1 pres fed bic time time2 time3, pairwise
		*	Long-run effect of procoop (by electionyear):
					lincom procoop									// for electionyear = 0
					lincom procoop + procoopXelectionyear * 1 	// for electionyear = 1
		*	Long-run effect of coalition (by procoop):
					lincom coalition - procoop * (1 - 1)			// for procoop = 1
					lincom coalition - procoop * (1 - 0.666)		// for procoop = 0.666
					lincom coalition - procoop * (1 - 0.333)		// for procoop = 0.333
		*	Long-run interaction between procoop and electionyear?
					lincom procoopXelectionyear
		*	Long-run effect of electionyear (by procoop):
					lincom electionyear + procoopXelectionyear * 1 		// for procoop = 1
					lincom electionyear + procoopXelectionyear * 0.666	// for procoop = 0.666
					lincom electionyear + procoopXelectionyear * 0.333	// for procoop = 0.333

***		MODEL 6: INTERACTION BETWEEN COOPERATION AND FISCAL PRESSURE	
	use Data_TSCS_Annual.dta, clear
		*	SHORT-RUN EFFECTS (T0):
		xtpcse D.debt_hist L.D.debt_hist L.debt_hist realgdpgr unemp D.unemp electionyear L.electionyear coalition L.coalition survival L.survival ///
		c.procoop##c.debtservice c.L.procoop##c.L.debtservice minority govleft1 pres fed bic time time2 time3, pairwise
		*	Short-run effect of procoop (by debtservice):
					su debtservice if e(sample), d
					lincom procoop + c.procoop#c.debtservice*-94.47266	// for debtservice = -94.47266 (25percentile)
					lincom procoop + c.procoop#c.debtservice*-.1407627	// for debtservice = -.1407627 (Median)
					lincom procoop + c.procoop#c.debtservice*118.6778		// for debtservice = 118.6778 (75percentile)
		*	LONG-RUN EFFECTS (LRM):
		gen procoopXdebtservice = procoop * debtservice
		xtpcse D.D.debt_hist L.D.debt_hist L.debt_hist realgdpgr unemp D.unemp electionyear D.electionyear coalition D.coalition survival D.survival ///
		procoop debtservice procoopXdebtservice D.procoop D.debtservice D.procoopXdebtservice minority govleft1 pres fed bic time time2 time3, pairwise
			predict deltaYhat6
		xtpcse D.debt_hist deltaYhat6 L.debt_hist realgdpgr unemp D.unemp electionyear D.electionyear coalition D.coalition survival D.survival ///
		procoop debtservice procoopXdebtservice D.procoop D.debtservice D.procoopXdebtservice minority govleft1 pres fed bic time time2 time3, pairwise
		*	Long-run effect of procoop (by debtservice):
					lincom procoop + procoopXdebtservice*-94.47266	// for debtservice = -94.47266 (25percentile)
					lincom procoop + procoopXdebtservice*-.1407627	// for debtservice = -.1407627 (Median)
					lincom procoop + procoopXdebtservice*118.6778		// for debtservice = 118.6778 (75percentile)
		*	Long-run effect of coalition (by procoop):
					* For debtservice = -280:
					lincom coalition + (procoop + procoopXdebtservice*-280) * (1 - 1)			// for procoop = 1
					lincom coalition + (procoop + procoopXdebtservice*-280) * (0.666 - 1)		// for procoop = 0.666
					lincom coalition + (procoop + procoopXdebtservice*-280) * (0.333 - 1)		// for procoop = 0.333
					* For debtservice = 0:
					lincom coalition + (procoop + procoopXdebtservice*0) * (1 - 1)			// for procoop = 1
					lincom coalition + (procoop + procoopXdebtservice*0) * (0.666 - 1)		// for procoop = 0.666
					lincom coalition + (procoop + procoopXdebtservice*0) * (0.333 - 1)		// for procoop = 0.333
					* For debtservice = 200:
					lincom coalition + (procoop + procoopXdebtservice*200) * (1 - 1)			// for procoop = 1
					lincom coalition + (procoop + procoopXdebtservice*200) * (0.666 - 1)		// for procoop = 0.666
					lincom coalition + (procoop + procoopXdebtservice*200) * (0.333 - 1)		// for procoop = 0.333
					* For debtservice = -280:
					lincom coalition + (procoop + procoopXdebtservice*423) * (1 - 1)			// for procoop = 1
					lincom coalition + (procoop + procoopXdebtservice*423) * (0.666 - 1)		// for procoop = 0.666
					lincom coalition + (procoop + procoopXdebtservice*423) * (0.333 - 1)		// for procoop = 0.333
		*	Long-run interaction between procoop and electionyear?
					lincom procoopXdebtservice
		*	Long-run effect of debtservice (by procoop):
					lincom debtservice + procoopXdebtservice * 1 		// for procoop = 1
					lincom debtservice + procoopXdebtservice * 0.666 	// for procoop = 0.666
					lincom debtservice + procoopXdebtservice * 0.333 	// for procoop = 0.333

***		MODEL 7: INTERACTION BETWEEN COOPERATION AND CENTRALIZED BUDGET PROCESS (DELEGATION)			
	use Data_TSCS_Annual.dta, clear
		*	SHORT-RUN EFFECTS (T0):
		xtpcse D.debt_hist L.D.debt_hist L.debt_hist realgdpgr unemp D.unemp debtservice coalition L.coalition survival L.survival ///
		c.procoop##c.delegation_index c.L.procoop##c.L.delegation_index electionyear L.electionyear minority govleft1 pres fed bic time time2 time3, pairwise
					lincom procoop + c.procoop#c.delegation_index * 0.9		//Max
					lincom procoop + c.procoop#c.delegation_index * 0.54		//Median
					lincom procoop + c.procoop#c.delegation_index * 0.23		//Min
		*	LONG-RUN EFFECTS (T0):
		gen procoopXdelegation = procoop * delegation_index
		xtpcse D.D.debt_hist L.D.debt_hist L.debt_hist realgdpgr unemp D.unemp debtservice coalition D.coalition survival D.survival ///
		procoop delegation_index procoopXdelegation D.procoop D.delegation_index D.procoopXdelegation electionyear D.electionyear minority govleft1 pres fed bic time time2 time3, pairwise
			predict deltaYhat7
		xtpcse D.debt_hist deltaYhat7 L.debt_hist realgdpgr unemp D.unemp debtservice coalition D.coalition survival D.survival ///
		procoop delegation_index procoopXdelegation D.procoop D.delegation_index D.procoopXdelegation electionyear D.electionyear minority govleft1 pres fed bic time time2 time3, pairwise
					lincom procoop + procoopXdelegation * 0.9		//Max
					lincom procoop + procoopXdelegation * 0.54	//Median
					lincom procoop + procoopXdelegation * 0.23	//Min

********************************************************************************
*	Table 4: TIME-VARYING EFFECTS OF PROSPECTIVE COOPERATION
********************************************************************************

***	PARAMETER HETEROGENEITY FOR COOPERATION (OVERALL EFFECT Model 4):
		use Data_TSCS_Annual.dta, clear
		xtset countryn year
					*	Pre-oil shock (1960-1972)
					gen period6072 = year >= 1960 & year <= 1972
					*	Post-oil shock until pre-1990s variance (1973-1989)
					gen period7389 = year >= 1973 & year <= 1989
					*	1990s, Maastricht-era (1990-1998)
					gen period9098 = year >= 1990 & year <= 1998
					*	Euro pre-crisis era (1999-2007)
					gen period9907 = year >= 1999 & year <= 2007
					*	Economic crisis era (2008-2012)
					gen period0813 = year >= 2008 & year <= 2013
***	SHORT-RUN EFFECTS (T0):
		xtpcse D.debt_hist L.D.debt_hist L.debt_hist realgdpgr unemp D.unemp debtservice coalition L.coalition survival L.survival ///
		c.procoop#1.period6072 L.c.procoop#1.L.period6072 c.procoop#1.period7389 L.c.procoop#1.L.period7389 c.procoop#1.period9098 L.c.procoop#1.L.period9098 ///
		c.procoop#1.period9907 L.c.procoop#1.L.period9907 c.procoop#1.period0813 L.c.procoop#1.L.period0813 ///
		electionyear L.electionyear minority govleft1 pres fed bic time time2 time3, pairwise
				gen procoop_6072 = c.procoop#1.period6072
				gen procoop_7389 = c.procoop#1.period7389
				gen procoop_9098 = c.procoop#1.period9098
				gen procoop_9907 = c.procoop#1.period9907
				gen procoop_0813 = c.procoop#1.period0813
***	LONG-RUN EFFECTS (T0):
		xtpcse D.D.debt_hist L.D.debt_hist L.debt_hist realgdpgr unemp D.unemp debtservice coalition D.coalition survival D.survival ///
		procoop_6072 D.procoop_6072 procoop_7389 D.procoop_7389 procoop_9098 D.procoop_9098 ///
		procoop_9907 D.procoop_9907 procoop_0813 D.procoop_0813 ///
		electionyear D.electionyear minority govleft1 pres fed bic time time2 time3, pairwise
			
			*	Standardized coefficients
			egen sd_debt_hist_ch = sd(debt_hist_ch) if e(sample)
			egen sd_procoop_6072 = sd(procoop_6072) if e(sample)
			egen sd_procoop_7389 = sd(procoop_7389) if e(sample)
			egen sd_procoop_9098 = sd(procoop_9098) if e(sample)
			egen sd_procoop_9907 = sd(procoop_9907) if e(sample)
			egen sd_procoop_0813 = sd(procoop_0813) if e(sample)
			
			gen beta_procoop_6072 = _b[procoop_6072] * (sd_procoop_6072 / sd_debt_hist_ch)
			gen beta_procoop_7389 = _b[procoop_7389] * (sd_procoop_7389 / sd_debt_hist_ch)
			gen beta_procoop_9098 = _b[procoop_9098] * (sd_procoop_9098 / sd_debt_hist_ch)
			gen beta_procoop_9907 = _b[procoop_9907] * (sd_procoop_9907 / sd_debt_hist_ch)
			gen beta_procoop_0813 = _b[procoop_0813] * (sd_procoop_0813 / sd_debt_hist_ch)

			gen se_procoop_6072 = _se[procoop_6072] * (sd_procoop_6072 / sd_debt_hist_ch)
			gen se_procoop_7389 = _se[procoop_7389] * (sd_procoop_7389 / sd_debt_hist_ch)
			gen se_procoop_9098 = _se[procoop_9098] * (sd_procoop_9098 / sd_debt_hist_ch)
			gen se_procoop_9907 = _se[procoop_9907] * (sd_procoop_9907 / sd_debt_hist_ch)
			gen se_procoop_0813 = _se[procoop_0813] * (sd_procoop_0813 / sd_debt_hist_ch)

			su beta_procoop_6072 - beta_procoop_0813 se_procoop_6072 - se_procoop_0813

***	PARAMETER HETEROGENEITY FOR procoop, BY ELECTIONYEAR (Model 5):			
*------------------------------------------------------------------------------		
		use Data_TSCS_Annual.dta, clear
		xtset countryn year
					*	Pre-oil shock (1960-1972)
					gen period6072 = year >= 1960 & year <= 1972
					gen procoop6072 = procoop * period6072
					gen electionyear6072 = electionyear * period6072
					*	Post-oil shock until pre-1990s variance (1973-1989)
					gen period7389 = year >= 1973 & year <= 1989
					gen procoop7389 = procoop * period7389
					gen electionyear7389 = electionyear * period7389
					*	1990s, Maastricht-era (1990-1998)
					gen period9098 = year >= 1990 & year <= 1998
					gen procoop9098 = procoop * period9098
					gen electionyear9098 = electionyear * period9098
					*	Euro pre-crisis era (1999-2007)
					gen period9907 = year >= 1999 & year <= 2007
					gen procoop9907 = procoop * period9907
					gen electionyear9907 = electionyear * period9907
					*	Economic crisis era (2008-2013)
					gen period0813 = year >= 2008 & year <= 2013
					gen procoop0813 = procoop * period0813
					gen electionyear0813 = electionyear * period0813
***	SHORT-RUN EFFECTS (T0):
		xtpcse D.debt_hist L.D.debt_hist L.debt_hist realgdpgr unemp D.unemp debtservice coalition L.coalition survival L.survival ///
			c.procoop6072##i.electionyear6072 c.L.procoop6072##i.L.electionyear6072 c.procoop7389##i.electionyear7389 c.L.procoop7389##i.L.electionyear7389 ///
			c.procoop9098##i.electionyear9098 c.L.procoop9098##i.L.electionyear9098 c.procoop9907##i.electionyear9907 c.L.procoop9907##i.L.electionyear9907 ///
			c.procoop0813##i.electionyear0813 c.L.procoop0813##i.L.electionyear0813 ///
			minority govleft1 pres fed bic time time2 time3, pairwise

***	LONG-RUN EFFECTS (T0):
					gen procoop6072Xelection = procoop6072 * electionyear6072
					gen procoop7389Xelection = procoop7389 * electionyear7389
					gen procoop9098Xelection = procoop9098 * electionyear9098
					gen procoop9907Xelection = procoop9907 * electionyear9907
					gen procoop0813Xelection = procoop0813 * electionyear0813
		xtpcse D.D.debt_hist L.D.debt_hist L.debt_hist realgdpgr unemp D.unemp debtservice coalition D.coalition survival D.survival ///
			procoop6072 electionyear6072 procoop6072Xelection D.procoop6072 D.electionyear6072 D.procoop6072Xelection ///
			procoop7389 electionyear7389 procoop7389Xelection D.procoop7389 D.electionyear7389 D.procoop7389Xelection ///
			procoop9098 electionyear9098 procoop9098Xelection D.procoop9098 D.electionyear9098 D.procoop9098Xelection ///
			procoop9907 electionyear9907 procoop9907Xelection D.procoop9907 D.electionyear9907 D.procoop9907Xelection ///
			procoop0813 electionyear0813 procoop0813Xelection D.procoop0813 D.electionyear0813 D.procoop0813Xelection ///
			minority govleft1 pres fed bic time time2 time3, pairwise
		*	Long-run effect of procoop (by electionyear):
					lincom procoop6072									// for electionyear = 0
					lincom procoop6072 + procoop6072Xelection * 1 	// for electionyear = 1
					lincom procoop7389									// for electionyear = 0
					lincom procoop7389 + procoop7389Xelection * 1 	// for electionyear = 1
					lincom procoop9098									// for electionyear = 0
					lincom procoop9098 + procoop9098Xelection * 1 	// for electionyear = 1
					lincom procoop9907									// for electionyear = 0
					lincom procoop9907 + procoop9907Xelection * 1 	// for electionyear = 1
					lincom procoop0813									// for electionyear = 0
					lincom procoop0813 + procoop0813Xelection * 1 	// for electionyear = 1

			*	Standardized coefficients
			egen sd_debt_hist_ch = sd(debt_hist_ch) if e(sample)
			egen sd_procoop6072 = sd(procoop6072) if e(sample)
			egen sd_procoop7389 = sd(procoop7389) if e(sample)
			egen sd_procoop9098 = sd(procoop9098) if e(sample)
			egen sd_procoop9907 = sd(procoop9907) if e(sample)
			egen sd_procoop0813 = sd(procoop0813) if e(sample)
			
			egen sd_procoop_X_election6072 = sd(procoop6072 + procoop6072Xelection) if e(sample)
			egen sd_procoop_X_election7389 = sd(procoop7389 + procoop7389Xelection) if e(sample)
			egen sd_procoop_X_election9098 = sd(procoop9098 + procoop9098Xelection) if e(sample)
			egen sd_procoop_X_election9907 = sd(procoop9907 + procoop9907Xelection) if e(sample)
			egen sd_procoop_X_election0813 = sd(procoop0813 + procoop0813Xelection) if e(sample)
			
			gen beta_procoop6072 = _b[procoop6072] * (sd_procoop6072 / sd_debt_hist_ch)
			gen beta_procoop7389 = _b[procoop7389] * (sd_procoop7389 / sd_debt_hist_ch)
			gen beta_procoop9098 = _b[procoop9098] * (sd_procoop9098 / sd_debt_hist_ch)
			gen beta_procoop9907 = _b[procoop9907] * (sd_procoop9907 / sd_debt_hist_ch)
			gen beta_procoop0813 = _b[procoop0813] * (sd_procoop0813 / sd_debt_hist_ch)

			gen betaprocoop_Xelection6072 = (_b[procoop6072] + _b[procoop6072Xelection]) * (sd_procoop_X_election6072 / sd_debt_hist_ch)
			gen betaprocoop_Xelection7389 = (_b[procoop7389] + _b[procoop7389Xelection]) * (sd_procoop_X_election7389 / sd_debt_hist_ch)
			gen betaprocoop_Xelection9098 = (_b[procoop9098] + _b[procoop9098Xelection]) * (sd_procoop_X_election9098 / sd_debt_hist_ch)
			gen betaprocoop_Xelection9907 = (_b[procoop9907] + _b[procoop9907Xelection]) * (sd_procoop_X_election9907 / sd_debt_hist_ch)
			gen betaprocoop_Xelection0813 = (_b[procoop0813] + _b[procoop0813Xelection]) * (sd_procoop_X_election0813 / sd_debt_hist_ch)

			gen se_procoop6072 = _se[procoop6072] * (sd_procoop6072 / sd_debt_hist_ch)
			gen se_procoop7389 = _se[procoop7389] * (sd_procoop7389 / sd_debt_hist_ch)
			gen se_procoop9098 = _se[procoop9098] * (sd_procoop9098 / sd_debt_hist_ch)
			gen se_procoop9907 = _se[procoop9907] * (sd_procoop9907 / sd_debt_hist_ch)
			gen se_procoop0813 = _se[procoop0813] * (sd_procoop0813 / sd_debt_hist_ch)
			
			gen seprocoop_Xelection6072 = (sqrt(_se[procoop6072]^2 + _se[procoop6072Xelection]^2)) * (sd_procoop_X_election6072 / sd_debt_hist_ch)
			gen seprocoop_Xelection7389 = (sqrt(_se[procoop7389]^2 + _se[procoop7389Xelection]^2)) * (sd_procoop_X_election7389 / sd_debt_hist_ch)
			gen seprocoop_Xelection9098 = (sqrt(_se[procoop9098]^2 + _se[procoop9098Xelection]^2)) * (sd_procoop_X_election9098 / sd_debt_hist_ch)
			gen seprocoop_Xelection9907 = (sqrt(_se[procoop9907]^2 + _se[procoop9907Xelection]^2)) * (sd_procoop_X_election9907 / sd_debt_hist_ch)
			gen seprocoop_Xelection0813 = (sqrt(_se[procoop0813]^2 + _se[procoop0813Xelection]^2)) * (sd_procoop_X_election0813 / sd_debt_hist_ch)
			
			su beta_procoop6072 - betaprocoop_Xelection0813 se_procoop6072 - seprocoop_Xelection0813

********************************************************************************
*	Table 5: REGRESSIONS OF AVERAGE DEBT CHANGES PER GOVERNMENT
********************************************************************************

use Data_Government_Centered.dta, clear
xtset countryn govnr
set more off

***	MODEL 8
xtpcse debt_hist_ch_avg L.debt_hist_ch_avg L.debt_hist_avg realgdpgr_avg unemp_avg unemp_ch_avg debtservice_avg days ///
	coalition procoop survival minority govleft1 pres fed bic time time2 time3, pairwise

***	MODEL 9
xtpcse debt_hist_ch_avg L.debt_hist_avg realgdpgr_avg unemp_avg unemp_ch_avg debtservice_avg days ///
	coalition procoop survival minority govleft1 pres fed bic time time2 time3, pairwise

***	MODEL 10
xtpcse debt_hist_ch_avg L.debt_hist_avg debt_hist_ch_var realgdpgr_avg unemp_avg unemp_ch_avg debtservice_avg days ///
	coalition procoop survival minority govleft1 pres fed bic time time2 time3, pairwise

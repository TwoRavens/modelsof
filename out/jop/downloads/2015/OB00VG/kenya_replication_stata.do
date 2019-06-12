***
* Full replications (main text and appendix).
* Excludes the Polywog work, which is in the .R files.
***

use kenya_replication_stata.dta, clear


***
* SUMMARY STATS
***
* Generates a marker variable so that the sample in the summary stats conforms to the effective sample in the regressions.
gen marker = 0
qui probit kenyatta male age5pt urban catholic protestant monthnum if ICCperiod==1
replace marker = 1 if e(sample)
quietly probit kenyatta male age5pt urban catholic protestant monthnum if ICCperiod==2
replace marker = 1 if e(sample)

sutex kenyatta ruto odinga male age5pt urban catholic protestant if marker==1
foreach i in 12 13 18 19 20 22 {
	di "monthnum == `i'"
	sutex kenyatta ruto odinga male age5pt urban catholic protestant if marker==1 & monthnum==`i'
	}
tab region if marker==1
foreach i in 12 13 18 19 20 22 {
	di "monthnum == `i'"
	tab region if marker==1 & monthnum==`i'
	}
*

***
* KENYATTA APPROVAL RATES BY REGION, DATE
***
bysort monthnum region: egen test_xx=mean(kenyatta)
forvalues i = 1(1)8 {
	gen kenyatta_reg`i'_xx = .
	replace kenyatta_reg`i'_xx = test_xx if region==`i'
	bysort monthnum: egen kenyatta_reg`i' = min(kenyatta_reg`i'_xx)
	}
drop *_xx
gen monthnum2=monthnum-12

*** Figure 4, Main text
* Shorter timeframe, just -2 |1| +4
local reg "kenyatta_reg1 kenyatta_reg2 kenyatta_reg3 kenyatta_reg4 kenyatta_reg5 kenyatta_reg6 kenyatta_reg7 kenyatta_reg8"
local leg "legend(order(1 "Nairobi" 2 "Coast" 3 "N. Eastern" 4 "Eastern" 5 "Central" 6 "Rift Valley" 7 "Western" 8 "Nyanza"))"
local leg2 xlabel(0 "Dec 10" 1 "Jan 11" 6 "Jun 11" 7 "Jul 11" 8 "Aug 11" 10 "Oct 11") text(0.55 3.3 "ICC Summonses")
twoway connect `reg'  monthnum2 if monthnum2<=10, xline(2) `leg' xtitle("Month") ytitle("Approval") `leg2'

*** Other figures that weren't used
/*
* Shorter timeframe, just -2 |1| +4, without North Eastern
local reg "kenyatta_reg1 kenyatta_reg2 kenyatta_reg4 kenyatta_reg5 kenyatta_reg6 kenyatta_reg7 kenyatta_reg8"
local leg "legend(order(1 "Nairobi" 2 "Coast" 3 "Eastern" 4 "Central" 5 "Rift Valley" 6 "Western" 7 "Nyanza"))"
local leg2 xlabel(0 "Dec 10" 1 "Jan 11" 6 "Jun 11" 7 "Jul 11" 8 "Aug 11" 10 "Oct 11") text(0.55 3.3 "ICC Summonses")
twoway connect `reg'  monthnum2 if monthnum2<=10, xline(2 13) `leg' xtitle("Month") ytitle("Approval") `leg2'


* Full set of surveys
local reg "kenyatta_reg1 kenyatta_reg2 kenyatta_reg3 kenyatta_reg4 kenyatta_reg5 kenyatta_reg6 kenyatta_reg7 kenyatta_reg8"
local leg "legend(order(1 "Nairobi" 2 "Coast" 3 "N. Eastern" 4 "Eastern" 5 "Central" 6 "Rift Valley" 7 "Western" 8 "Nyanza"))"
twoway connect `reg'  monthnum2, xline(2 13) `leg' xtitle("Month") ytitle("Approval")

*/





***
* PRE/POST SUMMONSES ANALYSIS FOR KENYATTA
***
use kenya_replication_stata.dta, clear
keep if monthnum <=22


* Creating the regional time trends
forvalues i = 1(1)8 {
	gen monthnum_reg_`i' = monthnum*reg_`i'
	}
*

* Estimating the pre-event probit model
***	Table 2, Appendix: Probit results from pre-summonses regression
qui probit kenyatta reg_* male age5pt urban catholic protestant monthnum_reg_* if ICCperiod==1
	*est2vec probitresults, vars(male age5pt urban catholic protestant reg_1 reg_2 reg_3 reg_4 reg_5 reg_6 reg_7 reg_8 monthnum_reg_1 monthnum_reg_2 monthnum_reg_3 monthnum_reg_4 monthnum_reg_5 monthnum_reg_6 monthnum_reg_7 monthnum_reg_8) replace
	*est2tex probitresults, preserve path("[dir]") mark(stars) fancy replace

* Constructing the "residuals"
	predict xb_ev1_m5_ken, xb
	gen r_ev1_m5_ken = .
	replace r_ev1_m5_ken = normal(xb_ev1_m5_ken)-kenyatta

*** FIGURE 5, Main text
lowess r_ev1_m5_ken xb_ev1_m5_ken if ICCperiod==2, bw(.1) adjust ytitle("Difference") xtitle("Predicted Support") title("")
	graph save allfour.gph, replace

*** FIGURE 6, Main text, No Nairobi, one month window
lowess r_ev1_m5_ken xb_ev1_m5_ken if monthnum==18 & region!=1, bw(.03) adjust ytitle("Difference") xtitle("Predicted Support") title("")


*** Appendix Figures (1-3), three, two, one post-event surveys, all regions
lowess r_ev1_m5_ken xb_ev1_m5_ken if monthnum==18 | monthnum==19 | monthnum==20, bw(.02) adjust ytitle("Difference") xtitle("Predicted Support") title("")
	graph save justthree.gph, replace
lowess r_ev1_m5_ken xb_ev1_m5_ken if monthnum==18 | monthnum==19, bw(.02) adjust ytitle("Difference") xtitle("Predicted Support") title("")
	graph save justtwo.gph, replace
lowess r_ev1_m5_ken xb_ev1_m5_ken if monthnum==18, bw(.03) adjust ytitle("Difference") xtitle("Predicted Support") title("")
		graph save justone.gph, replace

		
*** Appendix Figures (4), Figure 5 with Other Bandwidths
lowess r_ev1_m5_ken xb_ev1_m5_ken if ICCperiod==2, bw(.05) adjust ytitle("Difference") xtitle("Predicted Support") title("")
	graph save fig5alt1.gph, replace
lowess r_ev1_m5_ken xb_ev1_m5_ken if ICCperiod==2, bw(.03) adjust ytitle("Difference") xtitle("Predicted Support") title("")
	graph save fig5alt2.gph, replace
lowess r_ev1_m5_ken xb_ev1_m5_ken if ICCperiod==2, bw(.13) adjust ytitle("Difference") xtitle("Predicted Support") title("")
	graph save fig5alt3.gph, replace
lowess r_ev1_m5_ken xb_ev1_m5_ken if ICCperiod==2, bw(.15) adjust ytitle("Difference") xtitle("Predicted Support") title("")
	graph save fig5alt4.gph, replace
		graph combine fig5alt1.gph fig5alt2.gph fig5alt3.gph fig5alt4.gph, ycomm xcomm

*** Appendix Figures (5), Figure 6 with Other Bandwidths
lowess r_ev1_m5_ken xb_ev1_m5_ken if monthnum==18 & region!=1, bw(.01) adjust ytitle("Difference") xtitle("Predicted Support") title("")
	graph save fig6alt1.gph, replace
lowess r_ev1_m5_ken xb_ev1_m5_ken if monthnum==18 & region!=1, bw(.02) adjust ytitle("Difference") xtitle("Predicted Support") title("")
	graph save fig6alt2.gph, replace
lowess r_ev1_m5_ken xb_ev1_m5_ken if monthnum==18 & region!=1, bw(.1) adjust ytitle("Difference") xtitle("Predicted Support") title("")
	graph save fig6alt3.gph, replace
lowess r_ev1_m5_ken xb_ev1_m5_ken if monthnum==18 & region!=1, bw(.7) adjust ytitle("Difference") xtitle("Predicted Support") title("")
	graph save fig6alt4.gph, replace
		graph combine fig6alt1.gph fig6alt2.gph fig6alt3.gph fig6alt4.gph, ycomm xcomm


		
*** LOGIT ROBUSTNESS CHECKS
* Difference in predicted probabilities
***	Table 4, Appendix: Logit results from pre-summonses regression
qui logit kenyatta reg_* male age5pt urban catholic protestant monthnum_reg_* if ICCperiod==1
	predict prken_pre
		*est2vec logitresults, vars(male age5pt urban catholic protestant reg_1 reg_2 reg_3 reg_4 reg_5 reg_6 reg_7 reg_8 monthnum_reg_1 monthnum_reg_2 monthnum_reg_3 monthnum_reg_4 monthnum_reg_5 monthnum_reg_6 monthnum_reg_7 monthnum_reg_8) replace
qui logit kenyatta reg_* male age5pt urban catholic protestant monthnum_reg_* if ICCperiod==2
		*est2vec logititresults2, addto(logitresults) name(logtwo)
		*est2tex logitresults, preserve path("[dir]") mark(stars) fancy replace
	predict prken_post
	gen diff = prken_pre-prken_post

*** Figure 7: (Constructed in R)
	
*** Figure 8: Logit Robustness
lowess diff prken_pre if ICCperiod==2, bw(.001) adjust ytitle("Difference in Prob.") xtitle("Predicted Support") title("")

*** Appendix Figures (8-10): Logit Robustness, zoom in's
lowess diff prken_pre if monthnum==18 | monthnum==19 | monthnum==20, bw(.001) adjust ytitle("Difference in Prob.") xtitle("Predicted Support") title("")

lowess diff prken_pre if monthnum==18 | monthnum==19, bw(.001) adjust ytitle("Difference in Prob.") xtitle("Predicted Support") title("")

lowess diff prken_pre if monthnum==18, bw(.005) adjust ytitle("Difference in Prob.") xtitle("Predicted Support") title("")

		
*** Appendix Figure (11): Logit Placebo Test
qui logit kenyatta reg_* male age5pt urban catholic protestant monthnum_reg_* if monthnum==18 | monthnum==19
	predict prken_pre_plac
qui logit kenyatta reg_* male age5pt urban catholic protestant monthnum_reg_* if monthnum==20 | monthnum==22
	predict prken_post_plac
gen diff_plac = prken_pre_plac-prken_post_plac

lowess diff_plac prken_pre_plac if ICCperiod==2, bw(.5) adjust ytitle("Difference in Prob.") xtitle("Predicted Support") title("")


*** Appendix Figure (12), Probit Placebo Test
qui probit kenyatta reg_* male age5pt urban catholic protestant monthnum_reg_* if monthnum==18 | monthnum==19
	predict xb_prob_plac, xb
	gen r_prob_plac = .
	replace r_prob_plac = normal(xb_prob_plac)-kenyatta
lowess r_prob_plac xb_prob_plac if monthnum==20 | monthnum==22, bw(.1) adjust ytitle("Difference") xtitle("Predicted Support") title("")


		

		

		
		
***
* Odinga Analysis
***
use kenya_replication_stata.dta, clear

bysort monthnum region: egen test_xx=mean(odinga)
forvalues i = 1(1)8 {
	gen odinga_reg`i'_xx = .
	replace odinga_reg`i'_xx = test_xx if region==`i'
	bysort monthnum: egen odinga_reg`i' = min(odinga_reg`i'_xx)
	}
drop *_xx

gen monthnum2=monthnum-12

*** Appendix Figure (13), Odinga support by region
local reg "odinga_reg1 odinga_reg2 odinga_reg3 odinga_reg4 odinga_reg5 odinga_reg6 odinga_reg7 odinga_reg8"
local leg "legend(order(1 "Nairobi" 2 "Coast" 3 "N. Eastern" 4 "Eastern" 5 "Central" 6 "Rift Valley" 7 "Western" 8 "Nyanza"))"
local leg2 xlabel(0 "Dec 10" 1 "Jan 11" 6 "Jun 11" 7 "Jul 11" 8 "Aug 11" 10 "Oct 11")
twoway connect `reg'  monthnum2 if monthnum2<=10, xline(2) `leg' xtitle("Month") ytitle("Approval") `leg2'


*** Odinga Residuals Analysis
use kenya_replication_stata.dta, clear
keep if monthnum <=22

* Training model, regional time trends
forvalues i = 1(1)8 {
	gen monthnum_reg_`i' = monthnum*reg_`i'
	}
*
qui probit odinga reg_* male age5pt urban catholic protestant monthnum_reg_* if ICCperiod==1
	predict xb_od, xb
	gen r_od = .
	replace r_od = odinga-normal(xb_od)
* Appendix Figure (14): Figure 5 (for Odinga)
lowess r_od xb_od if ICCperiod==2, bw(.1) adjust ytitle("Difference") xtitle("Predicted Support") title("")
	graph save allfourod.gph, replace

* Appendix Figure (15): Figure 5 (for Odinga), 3 post event surveys
lowess r_od xb_od if monthnum==18 | monthnum==19 | monthnum==20, bw(.1) adjust ytitle("Difference") xtitle("Predicted Support") title("")

* Appendix Figure (16): Figure 5 (for Odinga), 2 post event surveys
lowess r_od xb_od if monthnum==18 | monthnum==19, bw(.1) adjust ytitle("Difference") xtitle("Predicted Support") title("")

* Appendix Figure (17): Figure 5 (for Odinga), 1 post event survey
lowess r_od xb_od if monthnum==18, bw(.1) adjust ytitle("Difference") xtitle("Predicted Support") title("")

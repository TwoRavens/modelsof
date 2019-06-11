* Replication File for "Capability, Credibility, and Extended General Deterrence"
* 09/30/2014
* save do-file and data sets in the same directory/folder
* set working directory to source file location

clear
log using "JohnsonLeedsWuIIrep.smcl", replace
use "JohnsonLeedsWuIIrep.dta", clear
set more off

**************************************
*** Tables included in the Article ***
**************************************

*** Table 1

* H1

	probit dispute allytarg_win pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3

* H2

	probit dispute allies_s pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3

* H3

	probit dispute allytarg_win allies_s allytarg_winXallies_s pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3

* H4

	probit dispute milinst pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3

* Combined

	probit dispute allytarg_win allies_s allytarg_winXallies_s milinst pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3
	
	
********************************************************************************

*** Table 2

	gen ally_winXallies_s=ally_win*allies_s

* All Observations

	probit dispute ally_win allies_s ally_winXallies_s milinst pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3

* Target's Probability of Winning < .5
	
	probit dispute ally_win allies_s ally_winXallies_s milinst pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3 if t_win<.5

* Target's Probability of Winning < .25

	probit dispute ally_win allies_s ally_winXallies_s milinst pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3 if t_win<.25

	drop ally_winXallies_s

	
************************************	
*** Substantive effects: Table 1 ***
************************************

* H1 substantive effect (footnote 23)
	set seed 117952

	estsimp probit dispute allytarg_win pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3 
	
	setx mean 
	setx pchaloff 0 pchalneu 0 jdem 0 
	simqi
	setx allytarg_win .74

	simqi, prval(1) genpr (weak)
	
	setx mean 
	setx pchaloff 0 pchalneu 0 jdem 0 
	setx allytarg_win .91

	simqi, prval(1) genpr (strong)

	gen percent_change = ((strong-weak)/weak)*100
	sum percent_change
	_pctile percent_change, p(2.5,50,97.5)
	gen changelow=r(r1) 
	gen changepoint=r(r2) 
	gen changehigh=r(r3)
	
	sum changelow changepoint changehigh
	
	drop percent_change changelow changepoint changehigh weak strong

	drop b*
	
	
* H2 substantive effect (footnote 24)
	set seed 11729490

	estsimp probit dispute allies_s pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3

	setx mean 
	setx pchaloff 0 pchalneu 0 jdem 0 
	simqi
	setx allies_s .76

	simqi, prval(1) genpr (weak)
	
	setx mean 
	setx pchaloff 0 pchalneu 0 jdem 0 
	setx allies_s .91

	simqi, prval(1) genpr (strong)

	gen percent_change = ((strong-weak)/weak)*100
	sum percent_change
	_pctile percent_change, p(2.5,50,97.5)
	gen changelow=r(r1) 
	gen changepoint=r(r2) 
	gen changehigh=r(r3)
	
	sum changelow changepoint changehigh
	
	drop percent_change changelow changepoint changehigh weak strong

	drop b*

* H3 substantive effect: See Table A18b	

* H4 substantive effect

	set seed 37483950
	estsimp probit dispute milinst pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3 
	
	setx mean 
	setx pchaloff 0 pchalneu 0 jdem 0 
	simqi
	setx milinst 1

	simqi, prval(1) genpr (weak)
	
	setx mean 
	setx pchaloff 0 pchalneu 0 jdem 0 
	setx milinst 3

	simqi, prval(1) genpr (strong)

	gen percent_change = ((strong-weak)/weak)*100
	sum percent_change
	_pctile percent_change, p(2.5,50,97.5)
	gen changelow=r(r1) 
	gen changepoint=r(r2) 
	gen changehigh=r(r3)
	
	sum changelow changepoint changehigh
	
	drop percent_change changelow changepoint changehigh weak strong

	drop b*

	
***********************************************
***** Tables included in the Web Appendix *****
***********************************************

*** Table A1: Descriptive Statistics

	sum dispute allytarg_win allies_s milinst pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs if allies_s~=.

********************************************************************************

*** Table A2: drop ongoing dispute years

* H1

	probit dispute allytarg_win pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3 if mzongo==0

* H2

	probit dispute allies_s pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3 if mzongo==0

* H3
	
	probit dispute allytarg_win allies_s allytarg_winXallies_s pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3  if mzongo==0

* H4

	probit dispute milinst pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3  if mzongo==0

* Combined

	probit dispute allytarg_win allies_s allytarg_winXallies_s milinst pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3  if mzongo==0


********************************************************************************

*** Table A3: drop alliances formed in year of dispute

	gen alliance_entry=0
	replace alliance_entry=1 if entry_dum==1 & dispute==1

* H1

	probit dispute allytarg_win pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3 if alliance_entry==0

* H2

	probit dispute allies_s pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3 if alliance_entry==0

* H3
	
	probit dispute allytarg_win allies_s allytarg_winXallies_s pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3 if alliance_entry==0

* H4

	probit dispute milinst pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3 if alliance_entry==0

* Combined

	probit dispute allytarg_win allies_s allytarg_winXallies_s milinst pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3 if alliance_entry==0

	drop alliance_entry
	
********************************************************************************

*** Table A4: excluding observations where the potential target is a member of NATO

* H1

	probit dispute allytarg_win pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3 if nato_member==0

* H2

	probit dispute allies_s pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3 if nato_member==0

* H3

	probit dispute allytarg_win allies_s allytarg_winXallies_s pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3 if nato_member==0

* H4

	probit dispute milinst pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3 if nato_member==0

* Combined

	probit dispute allytarg_win allies_s allytarg_winXallies_s milinst pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3 if nato_member==0

	
********************************************************************************

*** Table A5: drop all cases in which challenger and target share a defense pact with one another 

* H1

	probit dispute allytarg_win pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3 if pchaldef==0

* H2

	probit dispute allies_s pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3 if pchaldef==0

* H3

	probit dispute allytarg_win allies_s allytarg_winXallies_s pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3  if pchaldef==0

* H4

	probit dispute milinst pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3  if pchaldef==0

* Combined

	probit dispute allytarg_win allies_s allytarg_winXallies_s milinst pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3  if pchaldef==0

	
********************************************************************************

*** Table A6: excluding allies that are allied to the challenger 

* H1

	probit dispute allytarg_win_challenger pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3

* H2

	probit dispute allies_s_challenger pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3

* H3
	
	gen allytarg_win_cXallies_s=allytarg_win_challenger*allies_s_challenger
	probit dispute allytarg_win_challenger allies_s_challenger allytarg_win_cXallies_s pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3

* H4

	probit dispute milinst_challenger pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3

* Combined

	probit dispute allytarg_win_challenger allies_s_challenger allytarg_win_cXallies_s milinst_challenger pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3

	drop allytarg_win_cXallies_s
		
********************************************************************************

*** Table A7: squared and cubed term of the capabilities measure 

	gen allytarg_sq=(allytarg_win)^2
	gen allytarg_cb=(allytarg_win)^3


* H1

	probit dispute allytarg_win allytarg_sq allytarg_cb pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3

* H3

	probit dispute allytarg_win allytarg_sq allytarg_cb allies_s allytarg_winXallies_s pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3

* Combined

	probit dispute allytarg_win allytarg_sq allytarg_cb allies_s allytarg_winXallies_s milinst pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3

	drop allytarg_sq allytarg_cb
	
********************************************************************************
	
*** Table A8: capabilities of the strongest alliance 

* H1

	probit dispute allytarg_win_strongest pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3

* H3

	gen allytarg_win_sXallies_s=allytarg_win_strongest*allies_s
	probit dispute allytarg_win_strongest allies_s allytarg_win_sXallies_s pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3

* Combined
	
	probit dispute allytarg_win_strongest allies_s allytarg_win_sXallies_s milinst pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3

	drop allytarg_win_sXallies_s
	
********************************************************************************

*** Table A9: capabilities of the strongest ally 

* H1

	probit dispute allytarg_win_strongest_ally pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3

* H3

	gen allytarg_win_saXallies_s=allytarg_win_strongest_ally*allies_s
	probit dispute allytarg_win_strongest_ally allies_s allytarg_win_saXallies_s pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3

* Combined

	probit dispute allytarg_win_strongest_ally allies_s allytarg_win_saXallies_s milinst pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3

	drop allytarg_win_saXallies_s

********************************************************************************
	
*** Table A10: including capabilities of the potential challenger's offensive allies 

* H1

	probit dispute off_allytarg_win pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3

* H3

	gen allytarg_win_offXallies_s=off_allytarg_win*allies_s
	probit dispute off_allytarg_win allies_s allytarg_win_offXallies_s pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3

* Combined

	probit dispute off_allytarg_win allies_s allytarg_win_offXallies_s milinst pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3
		
	drop allytarg_win_offXallies_s
	
********************************************************************************
	
*** Table A11: the natural log of the capabilities measure 

	gen ln_allytarg_win=ln(allytarg_win+1)

* H1

	probit dispute ln_allytarg_win pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3

* H3

	gen allytarg_win_lnXallies_s=ln_allytarg_win*allies_s
	probit dispute ln_allytarg_win allies_s allytarg_win_lnXallies_s pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3

* Combined

	probit dispute ln_allytarg_win allies_s allytarg_win_lnXallies_s milinst pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3

	drop allytarg_win_lnXallies_s ln_allytarg_win
	
********************************************************************************
	
*** Table A12: adjusted capabilities by distance to the target 

* H1

	probit dispute allytarg_win_adj pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3

* H3

	gen allytarg_win_adjXallies_s=allytarg_win_adj*allies_s
	probit dispute allytarg_win_adj allies_s allytarg_win_adjXallies_s pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3

* Combined

	probit dispute allytarg_win_adj allies_s allytarg_win_adjXallies_s milinst pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3
	
	drop allytarg_win_adjXallies_s
	
********************************************************************************
	
*** Table A13: average s-score of the strongest alliance 

* H2

	probit dispute allies_s_strongest pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3

* H3

	gen allytarg_winXallies_s_s=allytarg_win*allies_s_strongest
	probit dispute allytarg_win allies_s_strongest allytarg_winXallies_s_s pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3	
	
* Combined

	probit dispute allytarg_win allies_s_strongest allytarg_winXallies_s_s milinst pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3	

	drop allytarg_winXallies_s_s
	
********************************************************************************
	
*** Table A14: S calculation with UN voting data 

* H2

	probit dispute allies_UN pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3
	
* H3

	gen allytarg_winXallies_s_un=allytarg_win*allies_UN
	probit dispute allytarg_win allies_UN allytarg_winXallies_s_un pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3

* Combined

	probit dispute allytarg_win allies_UN allytarg_winXallies_s_un milinst pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3

	drop allytarg_winXallies_s_un

********************************************************************************
	
*** Table A15: S calculation with Cohen's Kappa and alliance data 

* H2

	probit dispute allies_k1 pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3
	
* H3

	gen allytarg_winXallies_s_k1=allytarg_win*allies_k1
	probit dispute allytarg_win allies_k1 allytarg_winXallies_s_k1 pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3

* Combined

	probit dispute allytarg_win allies_k1 allytarg_winXallies_s_k1 milinst pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3
	
	drop allytarg_winXallies_s_k1
	
********************************************************************************

*** Table A16: military coordination level of the strongest alliance 	

* H4

	probit dispute milinst_strongest pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3

* Combined

	probit dispute allytarg_win allies_s allytarg_winXallies_s milinst_strongest pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3	
	
********************************************************************************

*** Table A17a: peacetime military coordination as a factor variable

* H4

	probit dispute i.milinst pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3

* Combined

	probit dispute allytarg_win allies_s allytarg_winXallies_s i.milinst pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3

********************************************************************************
	
*** Table A17b: predicted probability of dispute initiation for different levels of the peacetime military coordination variable

preserve
	keep if milinst~=.
	
	gen milinst_m=(milinst==2) if milinst~=.
	gen milinst_h=(milinst==3) if milinst~=.
	
	tab milinst_m
	tab milinst_h
	
	set seed 117952

	estsimp probit dispute milinst_m milinst_h allytarg_win allies_s allytarg_winXallies_s pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3

		setx mean
		setx pchaloff 0 pchalneu 0 jdem 0
		
		setx milinst_m 0 milinst_h 0
		simqi, prval(1) genpr(pi1)

		setx milinst_m 1 milinst_h 0
		simqi, prval(1) genpr(pi2)
		
		setx milinst_m 0 milinst_h 1
		simqi, prval(1) genpr(pi3)
restore

********************************************************************************

*** Table A18a: AIC comparison

* H3 without the interaction term

	probit dispute allytarg_win allies_s pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3
	fitstat /* AIC = 12962.8 */

* H3 with the interaction term

	probit dispute allytarg_win allies_s allytarg_winXallies_s pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3
	fitstat /* AIC = 12952.5 */
	
********************************************************************************
	
*** Table A18b: first and second differences when we include the interaction term (codes taken from Berry, DeMeritt, and Esarey 2010)
	
* H3

	probit dispute allytarg_win allies_s allytarg_winXallies_s pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3

** with regards to credibility

	set seed 284738390

	estsimp probit dispute allytarg_win allies_s allytarg_winXallies_s pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3
	
		setx mean
		setx pchaloff 0 pchalneu 0 jdem 0
		
		setx allytarg_win 0.91 allies_s 1 allytarg_winXallies_s 0.91
		simqi, prval(1) genpr(pi1)

		setx allytarg_win .74 allies_s 1 allytarg_winXallies_s .74
		simqi, prval(1) genpr(pi2)

		setx allytarg_win .91 allies_s .76 allytarg_winXallies_s .6916
		simqi, prval(1) genpr(pi3)

		setx allytarg_win .74 allies_s .76 allytarg_winXallies_s .5624
		simqi, prval(1) genpr(pi4)

	gen diff1 = pi3 - pi4
	gen diff2 = pi1 - pi2

	gen percent_change = ((pi3-pi4)/pi4)*100
	sum percent_change
	_pctile percent_change, p(2.5,50,97.5)
	gen changelow=r(r1) 
	gen changepoint=r(r2) 
	gen changehigh=r(r3)
	
	/* the probability of winning changes from .74 to .91 when the average S-score is .76 */
	sum changelow changepoint changehigh /* -32% [-36%, -27%] */

	gen percent_change1 = ((pi1-pi2)/pi2)*100
	sum percent_change1
	_pctile percent_change1, p(2.5,50,97.5)
	gen changelow1=r(r1) 
	gen changepoint1=r(r2) 
	gen changehigh1=r(r3)
	
	/* the probability of winning changes from .74 to .91 when the average S-score is 1 */
	sum changelow1 changepoint1 changehigh1	/* -24% [-28%, -19%] */
	
	gen second_diff1 = diff2 - diff1
	
	/* the first row of Table A18b */
	sumqi diff1 diff2 second_diff1 
	
	drop percent* pi* b1-b12 diff* changelow* changepoint* changehigh*

** with regards to credibility
	set seed 284738390

	estsimp probit dispute allytarg_win allies_s allytarg_winXallies_s pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3
	
		setx mean
		setx pchaloff 0 pchalneu 0 jdem 0
		
		setx allytarg_win .99 allies_s .91 allytarg_winXallies_s 0.9009
		simqi, prval(1) genpr(pi1)

		setx allytarg_win .99 allies_s .76 allytarg_winXallies_s .7524
		simqi, prval(1) genpr(pi2)

		setx allytarg_win .74 allies_s .91 allytarg_winXallies_s .6734
		simqi, prval(1) genpr(pi3)

		setx allytarg_win .74 allies_s .76 allytarg_winXallies_s .5624
		simqi, prval(1) genpr(pi4)

	gen diff1 = pi3 - pi4
	gen diff2 = pi1 - pi2

	gen percent_change = ((pi3-pi4)/pi4)*100
	sum percent_change
	_pctile percent_change, p(2.5,50,97.5)
	gen changelow=r(r1) 
	gen changepoint=r(r2) 
	gen changehigh=r(r3)
	
	/* the average S-score changes from .76 to .91 when the average S-score is .74 */
	sum changelow changepoint changehigh /* -37% [-40%, -32%] */

	gen percent_change1 = ((pi1-pi2)/pi2)*100
	sum percent_change1
	_pctile percent_change1, p(2.5,50,97.5)
	gen changelow1=r(r1) 
	gen changepoint1=r(r2) 
	gen changehigh1=r(r3)
	
	/* the average S-score changes from .76 to .91 when the average S-score is .99 */
	sum changelow1 changepoint1 changehigh1	 /* -29% [-34%, -25%] */
	gen second_diff2 = diff2 - diff1
	
	/* the second row of Table A18b */
	sumqi diff1 diff2 second_diff2
	drop percent* pi* b1-b12 diff* changelow* changepoint* changehigh*
	
********************************************************************************

*** Table A18c: first and second differences when we exclude the interaction term 

	set seed 284738390

** with regards to capability
	estsimp probit dispute allytarg_win allies_s pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3
	
		setx mean
		setx pchaloff 0 pchalneu 0 jdem 0
		
		setx allytarg_win 0.91 allies_s 1 
		simqi, prval(1) genpr(pi1)

		setx allytarg_win .74 allies_s 1 
		simqi, prval(1) genpr(pi2)

		setx allytarg_win .91 allies_s .76
		simqi, prval(1) genpr(pi3)

		setx allytarg_win .74 allies_s .76 
		simqi, prval(1) genpr(pi4)

	gen diff1 = pi3 - pi4
	gen diff2 = pi1 - pi2

	gen percent_change = ((pi3-pi4)/pi4)*100
	sum percent_change
	_pctile percent_change, p(2.5,50,97.5)
	gen changelow=r(r1) 
	gen changepoint=r(r2) 
	gen changehigh=r(r3)
	
	sum changelow changepoint changehigh

	gen percent_change1 = ((pi1-pi2)/pi2)*100
	sum percent_change1
	_pctile percent_change1, p(2.5,50,97.5)
	gen changelow1=r(r1) 
	gen changepoint1=r(r2) 
	gen changehigh1=r(r3)
	
	sum changelow1 changepoint1 changehigh1	
	gen second_diff3 = diff2 - diff1
	
	/* the first row of Table A18c */
	sumqi diff1 diff2 second_diff3
	
	drop percent* pi* b1-b11 diff* changelow* changepoint* changehigh*

** with regards to credibility
	set seed 284738390

	estsimp probit dispute allytarg_win allies_s pchaloff pchalneu ln_distance jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3
	
		setx mean
		setx pchaloff 0 pchalneu 0 jdem 0
		
		setx allytarg_win .99 allies_s .91
		simqi, prval(1) genpr(pi1)

		setx allytarg_win .99 allies_s .76
		simqi, prval(1) genpr(pi2)

		setx allytarg_win .74 allies_s .91
		simqi, prval(1) genpr(pi3)

		setx allytarg_win .74 allies_s .76 
		simqi, prval(1) genpr(pi4)

	gen diff1 = pi3 - pi4
	gen diff2 = pi1 - pi2

	gen percent_change = ((pi3-pi4)/pi4)*100
	sum percent_change
	_pctile percent_change, p(2.5,50,97.5)
	gen changelow=r(r1) 
	gen changepoint=r(r2) 
	gen changehigh=r(r3)
	
	sum changelow changepoint changehigh

	gen percent_change1 = ((pi1-pi2)/pi2)*100
	sum percent_change1
	_pctile percent_change1, p(2.5,50,97.5)
	gen changelow1=r(r1) 
	gen changepoint1=r(r2) 
	gen changehigh1=r(r3)
	
	sum changelow1 changepoint1 changehigh1	
	gen second_diff4 = diff2 - diff1
	
	/* the second row of Table A18c */
	sumqi diff1 diff2 second_diff4
	

* compare second differences

gen diff_diff1=second_diff1-second_diff3
gen diff_diff2=second_diff2-second_diff4

ttest diff_diff1==0 /* comparison of (1) and (3) in the appendix, Table A18b and Table A18c */
ttest diff_diff2==0 /* comparison of (2) and (4) in the appendix, Table A18b and Table A18c */

	
*** Table A19: lower joint democracy threshold (>=5)	
	
* H1

	probit dispute allytarg_win pchaloff pchalneu ln_distance jdem_5 s_un_glo peaceyrs peaceyrs2 peaceyrs3

* H2

	probit dispute allies_s pchaloff pchalneu ln_distance jdem_5 s_un_glo peaceyrs peaceyrs2 peaceyrs3

* H3

	probit dispute allytarg_win allies_s allytarg_winXallies_s pchaloff pchalneu ln_distance jdem_5 s_un_glo peaceyrs peaceyrs2 peaceyrs3

* H4

	probit dispute milinst pchaloff pchalneu ln_distance jdem_5 s_un_glo peaceyrs peaceyrs2 peaceyrs3

* Combined

	probit dispute allytarg_win allies_s allytarg_winXallies_s milinst pchaloff pchalneu ln_distance jdem_5 s_un_glo peaceyrs peaceyrs2 peaceyrs3

	
*************************************
*** Results included in footnotes ***
*************************************

*** Footnote 4: the mean and median age of an alliance at the time of a dispute
preserve
keep if dispute==1
sum average_time, d /* mean = 16.75 and median = 12.5 */
restore


*******************************************************************************

*** Footnote 18: the correlation between the S-score and sharing a defense pact

clear
use "footnote18.dta" 
corr defense_pact s_un_glo /* 0.2409 */

log close

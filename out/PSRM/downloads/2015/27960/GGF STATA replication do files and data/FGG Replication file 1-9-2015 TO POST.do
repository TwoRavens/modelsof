/*
Replication data and code for:
Benjamin A.T. Graham, Erik Gartzke and Christopher J. Fariss
"Allying to Win: Regime Type, Alliance Size, and Victory"
last updated: 12-22-2014
*/

clear
clear matrix
cap cd "/Users/Chris/Documents/R1"
cap cd "/Users/bengraham1/Dropbox/Collaborative Research/Chris and Erik/do files, R code, and data"
pause on
set more off
cap log close
log using psrm_replication_log_main, replace

use "FGG Replication Data", clear

/*******************************************
This code generatea binary variables for probit and bivariate probit models 
Note that the binary variable for ALLY takes a value of 1 if there are
at least 2 allies, i.e. a total of at least two allies IN ADDITION to the 
state in question.

The binary variable for WIN takes a value of 0 for ties.
*********************************************/

gen WIN = 0
replace WIN = 1 if win3_1 ==2

gen partners = .
replace partners = noside1-1

gen ALLY = 0 if partners != .
replace ALLY = 1 if partners > 2 & partners != .

gen ln_partners = ln(partners + 1)
gen ln_cinc = ln(cinc)
gen ln_cinc2sum = ln(cinc2sum)

gen postcw = 0
replace postcw = 1 if year > 1989
label var postcw "Post Cold-War"

gen postwwii = 0
replace postwwii = 1 if year > 1945
label var postwwii "Post World War II"

gen partners_postcw = partners*postcw
label var partners_postcw "Partners * Post Cold War"

gen partners_postwwii = partners*postwwii
label var partners_postwwii "Partners * Post WWII"

gen polity_postcw = polity*postcw
label var polity_postcw "Democracy [Polity] * Post Cold War"

gen polity_postwwii = polity*postwwii
label var polity_postwwii "Democracy [Polity] * Post WWII"


gen democracy_postcw = democracy*postcw
label var democracy_postcw "Democracy [Boix et al.] * Post Cold War"

gen democracy_postwwii = democracy*postwwii
label var democracy_postwwii "Democracy [Boix et al.] * Post WWII"

gen democracy_initiator = democracy* initiator
label var democracy_initiator "Democracy * Initiator"

gen polity_initiator = polity * initiator
label var polity_initiator "Polity * Initiator"

label var initiator "Initiator"

/*
kdensity ln_cinc
pause
kdensity ln_partners
pause
*/

label var allycinc "Partner(s)' CINC score"

gen opartners6 = 0 if partners == 0
replace opartners6 = 1 if partners == 1
replace opartners6 = 2 if partners == 2
replace opartners6 = 3 if partners == 3 | partners == 4
replace opartners6 = 4 if partners > 4 & partners < 10
replace opartners6 = 5 if partners > 9 & partners != .
tab opartners6

gen opartners3 = 0 if partners == 0
replace opartners3 = 1 if partners == 1 | partners == 2
replace opartners3 = 2 if partners > 2 & partners != . 

gen opartners4 = 0 if partners == 0
replace opartners4 = 1 if partners == 1 | partners == 2
replace opartners4 = 2 if partners > 2 & partners <6 
replace opartners4 = 3 if partners > 5 & partners != .
tab opartners4

gen opartners4a = 0 if partners == 0
replace opartners4a = 1 if partners == 1 
replace opartners4a = 2 if partners ==2
replace opartners4a = 3 if partners > 2 & partners != .
tab opartners4a

gen opartners5 = 0 if partners == 0
replace opartners5 = 1 if partners == 1 
replace opartners5 = 2 if partners == 2
replace opartners5 = 3 if partners > 2 & partners <6 
replace opartners5 = 4 if partners > 5 & partners != .
tab opartners5

gen opartnerslog = 0 if ln_partners == 0
replace opartnerslog = 1 if ln_partners > 0 & ln_partners <=1
replace opartnerslog = 2 if ln_partners > 1 & ln_partners <=2
replace opartnerslog = 3 if ln_partners > 2 & ln_partners <=3
replace opartnerslog = 4 if ln_partners > 3 
tab opartnerslog

gen oallycinc4 = 0 if allycinc == 0
replace oallycinc4 = 1 if allycinc > 0 & allycinc <= .05
replace oallycinc4 = 2 if allycinc > .05 & allycinc <= .2
replace oallycinc4 = 3 if allycinc > .2 
tab oallycinc4

gen oallycinc3 = 0 if allycinc == 0
replace oallycinc3 = 1 if allycinc > 0 & allycinc <= .1
replace oallycinc3 = 2 if allycinc > .1 
tab oallycinc3


/* label variables */
label var polity "Democracy [Polity IV]"
label var democracy "Democracy [Boix et al.]"
label var partners "Number of Partners"
label var cinc "CINC score"
label var cinc2sum "Opponent(s)' CINC score"
label var xb "Dyad MID Propensity"
label var ln_partners "Number of Partners (logged)"
label var ln_cinc2sum "Opponent(s)' CINC score (logged)"
label var ln_cinc "CINC score (logged)"
label var troopqual_adj "Troop Quality"

capture: drop ALLYPOWER
gen ALLYPOWER1 = 0 if allycinc != .
replace ALLYPOWER1 = 1 if allycinc >= .3 & allycinc != .

label var ALLYPOWER1 "PARTNER POWER"



/*****************
Final Tables for PSRM
******************/

/*********************
We first give the code for all tables
using regime type to predict coalition size
**************************/

/*************************************
TABLE 1: Body of the Paper
Negative binomial regression models 
 for number of allies count dependent variable
******************************************/
eststo clear
nbreg partners polity if war == 1, vce(cluster dispute_side_id)
eststo: nbreg partners polity cinc cinc2sum if war == 1, vce(cluster dispute_side_id)
eststo: nbreg partners democracy cinc cinc2sum if war == 1, vce(cluster dispute_side_id)
*mfx 
*pause

eststo: nbreg partners polity cinc cinc2sum if hihost >=3, vce(cluster dispute_side_id) 
eststo: nbreg partners democracy cinc cinc2sum if hihost >=3, vce(cluster dispute_side_id) 
*mfx
esttab
/* create LaTeX TABLE 1 */
esttab using alliesregimenb_log.tex, replace label mtitles("Wars Only" "Wars Only" "MIDs (3-5)" "MIDs (3-5)") nonumbers title("Number of Coalition Partners") /*
*/ b(a2) se(a2) r2(a3) star(* 0.10 ** 0.05 *** .01) addnotes("Specification: Negative Binomial regression with errors clustered on dispute-side.") order(polity democracy cinc)


/*****************************
TABLE 3: Body of the Paper
OLS regression models for ally-power continuous dependent variable 
********************************/
eststo clear
reg allycinc polity if war == 1, vce(cluster dispute_side_id)
eststo: reg allycinc polity cinc cinc2sum if war == 1, vce(cluster dispute_side_id)
eststo: reg allycinc democracy cinc cinc2sum if war == 1, vce(cluster dispute_side_id)
*mfx 
*pause
reg allycinc polity if hihost >=3, vce(cluster dispute_side_id)
eststo: reg allycinc polity cinc cinc2sum if hihost >=3, vce(cluster dispute_side_id)
eststo: reg allycinc democracy cinc cinc2sum if hihost >=3, vce(cluster dispute_side_id) 
esttab
*mfx
*pause
/* create LaTeX TABLE 1A */
esttab using allycincregime.tex, replace label mtitles("Wars Only" "Wars Only" "MIDs (3-5)" "MIDs (3-5)") nonumbers title("Partners' Summed CINC Scores") /*
*/ b(a2) se(a2) r2(a3) star(* 0.10 ** 0.05 *** .01) addnotes("Specification: OLS with errors clustered on dispute-side.") order(polity democracy cinc)




/*****************************
Table 1 in the Appendix
Negative binomial regression models for number of allies count dependent variable
logging number of partners
*******************************/
eststo clear
nbreg partners polity if war == 1, vce(cluster dispute_side_id)
eststo: nbreg ln_partners polity cinc cinc2sum if war == 1, vce(cluster dispute_side_id)
eststo: poisson ln_partners polity cinc cinc2sum if war == 1, vce(cluster dispute_side_id)
*mfx

nbreg ln_partners polity if hihost >=3, vce(cluster dispute_side_id)
eststo: nbreg ln_partners polity cinc cinc2sum if hihost >=3, vce(cluster dispute_side_id) 
eststo: nbreg ln_partners democracy cinc cinc2sum if hihost >=3, vce(cluster dispute_side_id) 
*mfx
esttab
/* create LaTeX TABLE 1A */
esttab using alliesregimenb_log.tex, replace label mtitles("Wars Only" "Wars Only" "MIDs (3-5)" "MIDs (3-5)") nonumbers title("Regime Type and Number of Coalition Partners (logged)") /*
*/ b(a2) se(a2) r2(a3) star(* 0.10 ** 0.05 *** .01) addnotes("Specification: Negative Binomial regression with errors clustered on dispute-side.") order(polity democracy cinc)



/******************
Table 10 in the appendix 
negative binomial regression models for number of allies count dependent variable
This logs the CINC controls
*******************/
eststo clear
nbreg partners polity if war == 1, vce(cluster dispute_side_id)
eststo: nbreg partners polity ln_cinc ln_cinc2sum if war == 1, vce(cluster dispute_side_id)
eststo: nbreg partners democracy ln_cinc ln_cinc2sum if war == 1, vce(cluster dispute_side_id)
*mfx 
*pause
nbreg ln_partners polity if hihost >=3, vce(cluster dispute_side_id)
eststo: nbreg partners polity ln_cinc ln_cinc2sum if hihost >=3, vce(cluster dispute_side_id) 
eststo: nbreg partners democracy ln_cinc ln_cinc2sum if hihost >=3, vce(cluster dispute_side_id) 
*mfx
esttab
/* create LaTeX TABLE 8A */
esttab using alliesregimenb_log.tex, replace label mtitles("Wars Only" "Wars Only" "MIDs (3-5)" "MIDs (3-5)") nonumbers title("Number of Coalition Partners") /*
*/ b(a2) se(a2) r2(a3) star(* 0.10 ** 0.05 *** .01) addnotes("Specification: Negative Binomial regression with errors clustered on dispute-side.") order(polity democracy ln_cinc)

*/

/************************************* 
TABLE 14 in the appendix
Negative binomial regression models for number of allies count dependent variable
adding system level control variable and time sensitivity
*****************************************/
eststo clear
nbreg partners polity if war == 1, vce(cluster dispute_side_id)
eststo: nbreg partners polity cinc cinc2sum democracy_share postwwii polity_postwwii postcw polity_postcw if war == 1, vce(cluster dispute_side_id)
eststo: nbreg partners democracy cinc cinc2sum democracy_share  postwwii  democracy_postwwii postcw democracy_postcw if war == 1, vce(cluster dispute_side_id)
esttab

nbreg ln_partners polity if hihost >=3, vce(cluster dispute_side_id)
eststo: nbreg partners polity cinc cinc2sum democracy_share postcw polity_postcw postwwii polity_postwwii  if hihost >=3, vce(cluster dispute_side_id) 
eststo: nbreg partners democracy cinc cinc2sum democracy_share  postcw  democracy_postcw postwwii democracy_postwwii if hihost >=3, vce(cluster dispute_side_id) 

esttab
/* create LaTeX TABLE 12A */
esttab using alliesregimenb_log.tex, replace label mtitles("Wars Only" "Wars Only" "MIDs (3-5)" "MIDs (3-5)") nonumbers title("Number of Coalition Partners") /*
*/ b(a2) se(a2) r2(a3) star(* 0.10 ** 0.05 *** .01) addnotes("Specification: Negative Binomial regression with errors clustered on dispute-side.") order(polity democracy cinc)
*/


/*******************************
Table 18 in the appendix
negative binomial regression models for number of allies count dependent variable -- controlling for intiator
**********************************/
eststo clear
nbreg partners polity if war == 1, vce(cluster dispute_side_id)
eststo: nbreg partners polity cinc cinc2sum initiator if war == 1, vce(cluster dispute_side_id)
eststo: nbreg partners polity cinc cinc2sum initiator polity_initiator if war == 1, vce(cluster dispute_side_id)
eststo: nbreg partners democracy cinc cinc2sum initiator if war == 1, vce(cluster dispute_side_id)
eststo: nbreg partners democracy cinc cinc2sum democracy_initiator if war == 1, vce(cluster dispute_side_id)

*mfx 
*pause
nbreg ln_partners polity if hihost >=3, vce(cluster dispute_side_id)
eststo: nbreg partners polity cinc cinc2sum initiator if hihost >=3, vce(cluster dispute_side_id) 
eststo: nbreg partners polity cinc cinc2sum initiator polity_initiator if hihost >=3, vce(cluster dispute_side_id) 
eststo: nbreg partners democracy cinc cinc2sum initiator if hihost >=3, vce(cluster dispute_side_id)
eststo: nbreg partners democracy cinc cinc2sum initiator democracy_initiator if hihost >=3, vce(cluster dispute_side_id)
 
*mfx
esttab
/* create LaTeX TABLE 1 */
esttab using alliesregimenb.tex, replace label mtitles("Wars Only" "Wars Only"  "Wars Only" "Wars Only" "MIDs (3-5)" "MIDs (3-5)" "MIDs (3-5)" "MIDs (3-5)") nonumbers title("Number of Coalition Partners") /*
*/ b(a2) se(a2) r2(a3) star(* 0.10 ** 0.05 *** .01) addnotes("Specification: Negative Binomial regression with errors clustered on dispute-side.") order(polity democracy initiator polity_initiator democracy_initiator cinc)




/*************************************
TABLE 27: appendix
Negative binomial regression models 
For number of allies count dependent variable
Looking at joiners only 
******************************************/

eststo clear
nbreg partners polity if war == 1 & joiner == 1, vce(cluster dispute_side_id)
eststo: nbreg partners polity cinc cinc2sum if war == 1 & joiner == 1, vce(cluster dispute_side_id)
eststo: nbreg partners democracy cinc cinc2sum if war == 1 & joiner == 1, vce(cluster dispute_side_id)
*mfx 
*pause
nbreg ln_partners polity if hihost >=3 & joiner == 1, vce(cluster dispute_side_id)
eststo: nbreg partners polity cinc cinc2sum if hihost >=3 & joiner == 1, vce(cluster dispute_side_id) 
eststo: nbreg partners democracy cinc cinc2sum if hihost >=3 & joiner == 1, vce(cluster dispute_side_id) 
*mfx
esttab
/* create LaTeX TABLE 26 */
esttab using alliesregimenb_log.tex, replace label mtitles("Wars Only" "Wars Only" "MIDs (3-5)" "MIDs (3-5)") nonumbers title("Number of Coalition Partners") /*
*/ b(a2) se(a2) r2(a3) star(* 0.10 ** 0.05 *** .01) addnotes("Specification: Negative Binomial regression with errors clustered on dispute-side.") order(polity democracy cinc)


/*************************************
TABLE 29: appendix
Negative binomial regression models 
For number of allies count dependent variable
Looking at original participants only 
******************************************/

eststo clear
nbreg partners polity if war == 1 & joiner == 0, vce(cluster dispute_side_id)
eststo: nbreg partners polity cinc cinc2sum if war == 1 & joiner == 0, vce(cluster dispute_side_id)
eststo: nbreg partners democracy cinc cinc2sum if war == 1 & joiner == 0, vce(cluster dispute_side_id)
*mfx 
*pause
nbreg ln_partners polity if hihost >=3 & joiner == 0, vce(cluster dispute_side_id)
eststo: nbreg partners polity cinc cinc2sum if hihost >=3 & joiner == 0, vce(cluster dispute_side_id) 
eststo: nbreg partners democracy cinc cinc2sum if hihost >=3 & joiner == 0, vce(cluster dispute_side_id) 
*mfx
esttab
/* create LaTeX TABLE 26 */
esttab using alliesregimenb_log.tex, replace label mtitles("Wars Only" "Wars Only" "MIDs (3-5)" "MIDs (3-5)") nonumbers title("Number of Coalition Partners") /*
*/ b(a2) se(a2) r2(a3) star(* 0.10 ** 0.05 *** .01) addnotes("Specification: Negative Binomial regression with errors clustered on dispute-side.") order(polity democracy cinc)





/*******************
Next is the code for models in which 
coalition size is used to predict victory
********************/


/****************************
 TABLE 2 in the body of the paper
 ordinal probit regression models for ordinal victory variable (victory=2, draw=1, loss=0) 
Includes troop quality.  Also, uses prchange to calculate marginal effects.
***************************************/
eststo clear
eststo: oprobit win3_1 partners cinc cinc2sum xb troopqual_adj polity if hihost >= 3 & war == 1, robust cluster(dispute_side_id)
prchange
*pause
eststo: oprobit win3_1 partners cinc cinc2sum xb troopqual_adj democracy if hihost >= 3 & war == 1, robust cluster(dispute_side_id)

eststo: oprobit win3_1 partners cinc cinc2sum xb troopqual_adj polity if hihost >= 3, robust cluster(dispute_side_id)
prchange 
*pause
eststo: oprobit win3_1 partners cinc cinc2sum xb troopqual_adj democracy if hihost >= 3, robust cluster(dispute_side_id)

esttab

/* create LaTeX TABLE 2 */
esttab using orderedWIN.tex, replace label se mtitles("Wars Only" "Wars Only" "MIDs (3-5)" "MIDs (3-5)") /*
*/ title("Probability of Victory") b(a2) se(a2) star(* 0.10 ** 0.05 *** 0.01) addnotes("Specification: Ordered Probit with errors clustered on dispute-side.") order(partners polity democracy)


/************************************* 
Table 4 in the body of the paper
ordinal probit regression models for ordinal victory variable (victory=2, draw=1, loss=0) 
Allies CINC scores -- also adding in troop quality
******************************************/
eststo clear
eststo: oprobit win3_1 allycinc cinc cinc2sum xb troopqual_adj polity if hihost >= 3 & war == 1, robust cluster(dispute_side_id)
eststo: oprobit win3_1 allycinc cinc cinc2sum xb troopqual_adj democracy if hihost >= 3 & war == 1, robust cluster(dispute_side_id)

eststo: oprobit win3_1 allycinc cinc cinc2sum xb troopqual_adj polity if hihost >= 3, robust cluster(dispute_side_id)
eststo: oprobit win3_1 allycinc cinc cinc2sum xb troopqual_adj democracy if hihost >= 3, robust cluster(dispute_side_id)

esttab

/* create LaTeX TABLE 4 */
esttab using orderedwin_allycinc.tex, replace label se mtitles("Wars Only" "Wars Only" "MIDs (3-5)" "MIDs (3-5)") /*
*/ title("Probability of Victory") b(a2) se(a2) star(* 0.10 ** 0.05 *** 0.01) addnotes("Specification: Ordered Probit with errors clustered on dispute-side.") order(allycinc polity democracy)


/***********************************
 TABLE 1 in the appendix
 ordinal probit regression models for ordinal victory variable (victory=2, draw=1, loss=0) 
Logging partners -- also adding in troop quality
*************************************/
eststo clear
eststo: oprobit win3_1 ln_partners cinc cinc2sum xb troopqual_adj polity if hihost >= 3 & war == 1, robust cluster(dispute_side_id)
eststo: oprobit win3_1 ln_partners cinc cinc2sum xb troopqual_adj democracy if hihost >= 3 & war == 1, robust cluster(dispute_side_id)

eststo: oprobit win3_1 ln_partners cinc cinc2sum xb troopqual_adj polity if hihost >= 3, robust cluster(dispute_side_id)
eststo: oprobit win3_1 ln_partners cinc cinc2sum xb troopqual_adj democracy if hihost >= 3, robust cluster(dispute_side_id)

esttab

/* create LaTeX TABLE 1A  */
esttab using orderedWIN.tex, replace label se mtitles("Wars Only" "Wars Only" "MIDs (3-5)" "MIDs (3-5)") /*
*/ title("Probability of Victory") b(a2) se(a2) star(* 0.10 ** 0.05 *** 0.01) addnotes("Specification: Ordered Probit with errors clustered on dispute-side.") order(ln_partners polity democracy)





/****************************************
TABLE 11 in the appendix
ordinal probit regression models for ordinal victory variable (victory=2, draw=1, loss=0) 
Adding in troop quality.  Logging the CINC variables.  For appendix
******************************************/

eststo clear
eststo: oprobit win3_1 partners ln_cinc ln_cinc2sum xb troopqual_adj polity if hihost >= 3 & war == 1, robust cluster(dispute_side_id)
eststo: oprobit win3_1 partners ln_cinc ln_cinc2sum xb troopqual_adj democracy if hihost >= 3 & war == 1, robust cluster(dispute_side_id)

eststo: oprobit win3_1 partners ln_cinc ln_cinc2sum xb troopqual_adj polity if hihost >= 3, robust cluster(dispute_side_id)
eststo: oprobit win3_1 partners ln_cinc ln_cinc2sum xb troopqual_adj democracy if hihost >= 3, robust cluster(dispute_side_id)

esttab

/* create LaTeX TABLE 9 */
esttab using orderedWIN.tex, replace label se mtitles("Wars Only" "Wars Only" "MIDs (3-5)" "MIDs (3-5)") /*
*/ title("Probability of Victory") b(a2) se(a2) star(* 0.10 ** 0.05 *** 0.01) addnotes("Specification: Ordered Probit with errors clustered on dispute-side.") order(partners polity democracy)
*/

/********************************************
TABLE 15 in the appendix
 ordinal probit regression models for ordinal victory variable (victory=2, draw=1, loss=0) 
Adding in troop quality AND SYSTEM LEVEL DEMOCRACY. 
***********************************************/

eststo clear
eststo: oprobit win3_1 partners cinc cinc2sum xb troopqual_adj polity  democracy_share postwwii  postcw partners_postwwii partners_postcw if hihost >= 3 & war == 1, robust cluster(dispute_side_id)

eststo: oprobit win3_1 partners cinc cinc2sum xb troopqual_adj democracy democracy_share postwwii partners_postwwii postcw  partners_postcw if hihost >= 3 & war == 1, robust cluster(dispute_side_id)

eststo: oprobit win3_1 partners cinc cinc2sum xb troopqual_adj polity democracy_share  postcw partners_postcw postwwii partners_postwwii if  hihost >= 3, robust cluster(dispute_side_id)

eststo: oprobit win3_1 partners cinc cinc2sum xb troopqual_adj democracy democracy_share postcw  partners_postcw postwwii partners_postwwii if hihost >= 3, robust cluster(dispute_side_id)

esttab

/* create LaTeX TABLE 15 */
esttab using orderedWIN.tex, replace label se mtitles("Wars Only" "Wars Only" "MIDs (3-5)" "MIDs (3-5)") /*
*/ title("Probability of Victory") b(a2) se(a2) star(* 0.10 ** 0.05 *** 0.01) addnotes("Specification: Ordered Probit with errors clustered on dispute-side.") order(partners polity democracy)

*/


/************************************
TABLE 19 in the appendix
Ordinal probit regression models for ordinal victory variable (victory=2, draw=1, loss=0) 
Adding in troop quality.  Also, using prchange to calculate marginal effects
Add in initiator and democracy/initiator interaction
*************************************/


eststo clear
eststo: oprobit win3_1 partners cinc cinc2sum xb troopqual_adj polity initiator if hihost >= 3 & war == 1, robust cluster(dispute_side_id)
eststo: oprobit win3_1 partners cinc cinc2sum xb troopqual_adj polity initiator polity_initiator if hihost >= 3 & war == 1, robust cluster(dispute_side_id)

*prchange
*pause
eststo: oprobit win3_1 partners cinc cinc2sum xb troopqual_adj democracy initiator if hihost >= 3 & war == 1, robust cluster(dispute_side_id)
eststo: oprobit win3_1 partners cinc cinc2sum xb troopqual_adj democracy initiator democracy_initiator if hihost >= 3 & war == 1, robust cluster(dispute_side_id)

eststo: oprobit win3_1 partners cinc cinc2sum xb troopqual_adj polity initiator if hihost >= 3, robust cluster(dispute_side_id)
eststo: oprobit win3_1 partners cinc cinc2sum xb troopqual_adj polity initiator polity_initiator if hihost >= 3, robust cluster(dispute_side_id)

*prchange 
*pause
eststo: oprobit win3_1 partners cinc cinc2sum xb troopqual_adj democracy initiator if hihost >= 3, robust cluster(dispute_side_id)
eststo: oprobit win3_1 partners cinc cinc2sum xb troopqual_adj democracy initiator democracy_initiator if hihost >= 3, robust cluster(dispute_side_id)

esttab, order(partners polity democracy initiator polity_initiator democracy_initiator)

/* create LaTeX TABLE 2F */
esttab using orderedWIN.tex, replace label se mtitles("Wars Only" "Wars Only" "Wars Only" "MIDs (3-5)" "MIDs (3-5)" "MIDs (3-5)") /*
*/ title("Probability of Victory") b(a2) se(a2) star(* 0.10 ** 0.05 *** 0.01) addnotes("Specification: Ordered Probit with errors clustered on dispute-side.") order(partners polity democracy initiator polity_initiator democracy_initiator)


*/


/******************
NOT IN THE APPENDIX, BUT ROBUST TO THIS
Here we simply rerun table 2 from the body of the paper
without controlling for dyad mid propensity
********************/

eststo clear
eststo: oprobit win3_1 partners cinc cinc2sum  troopqual_adj polity if hihost >= 3 & war == 1, robust cluster(dispute_side_id)
*prchange
*pause
eststo: oprobit win3_1 partners cinc cinc2sum  troopqual_adj democracy if hihost >= 3 & war == 1, robust cluster(dispute_side_id)

eststo: oprobit win3_1 partners cinc cinc2sum  troopqual_adj polity if hihost >= 3, robust cluster(dispute_side_id)
*prchange 
*pause
eststo: oprobit win3_1 partners cinc cinc2sum  troopqual_adj democracy if hihost >= 3, robust cluster(dispute_side_id)

esttab

/* create LaTeX TABLE ? */
esttab using orderedWIN.tex, replace label se mtitles("Wars Only" "Wars Only" "MIDs (3-5)" "MIDs (3-5)") /*
*/ title("Probability of Victory") b(a2) se(a2) star(* 0.10 ** 0.05 *** 0.01) addnotes("Specification: Ordered Probit with errors clustered on dispute-side.") order(partners polity democracy)



/******************
NOT IN THE APPENDIX, BUT ROBUST TO THIS
Here we simply rerun table 4 from the body of the paper
without controlling for dyad mid propensity
********************/
eststo clear
eststo: oprobit win3_1 allycinc cinc cinc2sum troopqual_adj polity if hihost >= 3 & war == 1, robust cluster(dispute_side_id)
eststo: oprobit win3_1 allycinc cinc cinc2sum  troopqual_adj democracy if hihost >= 3 & war == 1, robust cluster(dispute_side_id)

eststo: oprobit win3_1 allycinc cinc cinc2sum  troopqual_adj polity if hihost >= 3, robust cluster(dispute_side_id)
eststo: oprobit win3_1 allycinc cinc cinc2sum  troopqual_adj democracy if hihost >= 3, robust cluster(dispute_side_id)

esttab

/* create LaTeX TABLE 24 */
esttab using orderedwin_allycinc.tex, replace label se mtitles("Wars Only" "Wars Only" "MIDs (3-5)" "MIDs (3-5)") /*
*/ title("Probability of Victory") b(a2) se(a2) star(* 0.10 ** 0.05 *** 0.01) addnotes("Specification: Ordered Probit with errors clustered on dispute-side.") order(allycinc polity democracy)



/****************************
 NOT IN APPENDIX BUT ROBUST TO THIS
 ordinal probit regression models for ordinal victory variable (victory=2, draw=1, loss=0) 
Includes troop quality.  
limiting to joiners only
***************************************/
eststo clear
eststo: oprobit win3_1 partners cinc cinc2sum xb troopqual_adj polity if hihost >= 3 & war == 1 & joiner == 1, robust cluster(dispute_side_id)

eststo: oprobit win3_1 partners cinc cinc2sum xb troopqual_adj democracy if hihost >= 3 & war == 1 & joiner == 1, robust cluster(dispute_side_id)

eststo: oprobit win3_1 partners cinc cinc2sum xb troopqual_adj polity if hihost >= 3 & joiner == 1, robust cluster(dispute_side_id)

eststo: oprobit win3_1 partners cinc cinc2sum xb troopqual_adj democracy if hihost >= 3 & joiner == 1, robust cluster(dispute_side_id)

esttab

/* create LaTeX TABLE 27 */
esttab using orderedWIN.tex, replace label se mtitles("Wars Only" "Wars Only" "MIDs (3-5)" "MIDs (3-5)") /*
*/ title("Probability of Victory") b(a2) se(a2) star(* 0.10 ** 0.05 *** 0.01) addnotes("Specification: Ordered Probit with errors clustered on dispute-side.") order(partners polity democracy)


/****************************
 NOT IN APPENDIX BUT ROBUST TO THIS
 ordinal probit regression models for ordinal victory variable (victory=2, draw=1, loss=0) 
Includes troop quality.  
omitting joiners
***************************************/
eststo clear
eststo: oprobit win3_1 partners cinc cinc2sum xb troopqual_adj polity if hihost >= 3 & war == 1 & joiner == 0, robust cluster(dispute_side_id)

eststo: oprobit win3_1 partners cinc cinc2sum xb troopqual_adj democracy if hihost >= 3 & war == 1 & joiner == 0, robust cluster(dispute_side_id)

eststo: oprobit win3_1 partners cinc cinc2sum xb troopqual_adj polity if hihost >= 3 & joiner == 0, robust cluster(dispute_side_id)

eststo: oprobit win3_1 partners cinc cinc2sum xb troopqual_adj democracy if hihost >= 3 & joiner == 0, robust cluster(dispute_side_id)

esttab

/* create LaTeX TABLE 27 */
esttab using orderedWIN.tex, replace label se mtitles("Wars Only" "Wars Only" "MIDs (3-5)" "MIDs (3-5)") /*
*/ title("Probability of Victory") b(a2) se(a2) star(* 0.10 ** 0.05 *** 0.01) addnotes("Specification: Ordered Probit with errors clustered on dispute-side.") order(partners polity democracy)




/*******************
Now the tables that jointly 
model regime type and victory
*********************/



/************************************* 
Table 4 in the body of the paper
ordinal probit regression models for ordinal victory variable (victory=2, draw=1, loss=0) 
Allies CINC scores -- also adding in troop quality
******************************************/
eststo clear
eststo: oprobit win3_1 allycinc cinc cinc2sum xb troopqual_adj polity if hihost >= 3 & war == 1  & joiner == 1, robust cluster(dispute_side_id)
eststo: oprobit win3_1 allycinc cinc cinc2sum xb troopqual_adj democracy if hihost >= 3 & war == 1  & joiner == 1, robust cluster(dispute_side_id)

eststo: oprobit win3_1 allycinc cinc cinc2sum xb troopqual_adj polity if hihost >= 3  & joiner == 1, robust cluster(dispute_side_id)
eststo: oprobit win3_1 allycinc cinc cinc2sum xb troopqual_adj democracy if hihost >= 3  & joiner == 1, robust cluster(dispute_side_id)

esttab

/* create LaTeX TABLE 4 */
esttab using orderedwin_allycinc.tex, replace label se mtitles("Wars Only" "Wars Only" "MIDs (3-5)" "MIDs (3-5)") /*
*/ title("Probability of Victory") b(a2) se(a2) star(* 0.10 ** 0.05 *** 0.01) addnotes("Specification: Ordered Probit with errors clustered on dispute-side.") order(allycinc polity democracy)



/*******************************
TABLE 5 in the body of the paper 
bivariate probit model where ALLY is allies >2
********************************/
eststo clear

eststo: biprobit (ALLY = polity cinc cinc2sum xb) (WIN = partners polity cinc cinc2sum troopqual_adj xb) if hihost >=3 & war == 1, robust cluster(dispute_side_id) 
eststo: biprobit (ALLY = democracy cinc cinc2sum xb) (WIN = partners democracy cinc cinc2sum troopqual_adj xb) if hihost >=3 & war == 1, robust cluster(dispute_side_id) 

eststo: biprobit (ALLY = polity cinc cinc2sum xb) (WIN = partners polity cinc cinc2sum troopqual_adj xb) if hihost >=3, robust cluster(dispute_side_id) 
eststo: biprobit (ALLY = democracy cinc cinc2sum xb) (WIN = partners democracy cinc cinc2sum troopqual_adj xb) if hihost >=3, robust cluster(dispute_side_id) 
esttab

/* create LaTeX TABLE 5 */
esttab using biprobit_allies.tex, replace label se mtitles("Wars Only" "Wars Only" "MIDs (3-5)" "MIDs (3-5)") /*
*/ title("Joint Probability of Partners and Victory: Bivariate Probit") b(a2) se(a2) star(* 0.10 ** 0.05 *** 0.01) 



/********************************
TABLE 6 in the body of the paper
 bivariate probit model where ALLYPOWER is allycinc > .1 (which turns out to be in top 10% of distribution, similar to 3 or more allies)
Note: The label in the paper reads "Partner Power" rather than "Ally Power." 
 ***********************************/
 eststo clear

eststo: biprobit (ALLYPOWER1 = polity cinc cinc2sum xb) (WIN = allycinc polity cinc cinc2sum troopqual_adj xb) if hihost >=3 & war == 1, robust cluster(dispute_side_id) 
eststo: biprobit (ALLYPOWER1 = democracy cinc cinc2sum xb) (WIN = allycinc democracy cinc cinc2sum troopqual_adj xb) if hihost >=3 & war == 1, robust cluster(dispute_side_id) 



eststo: biprobit (ALLYPOWER1 = polity cinc cinc2sum xb) (WIN = allycinc polity cinc cinc2sum troopqual_adj xb) if hihost >=3, robust cluster(dispute_side_id) 
eststo: biprobit (ALLYPOWER1 = democracy cinc cinc2sum xb) (WIN = allycinc democracy cinc cinc2sum troopqual_adj xb) if hihost >=3, robust cluster(dispute_side_id) 

esttab

/* create LaTeX TABLE 3A */
esttab using alliescinc.tex, replace label se mtitles("Wars Only" "Wars Only" "MIDs (3-5)" "MIDs (3-5)") /*
*/ title("Joint Probability of Allies and Victory") b(a2) se(a2) star(* 0.10 ** 0.05 *** 0.01) /*
*/ addnotes("Specification: Bivariate Probit with errors clustered on dispute-side.")


/****************************
Table 3 in the appendix 
bivariate probit model where ALLY is allies >2, using logged partners
*****************************/
eststo clear

eststo: biprobit (ALLY = polity cinc cinc2sum xb) (WIN = ln_partners polity cinc cinc2sum troopqual_adj xb) if hihost >=3 & war == 1, robust cluster(dispute_side_id) 

eststo: biprobit (ALLY = democracy cinc cinc2sum xb) (WIN = ln_partners democracy cinc cinc2sum troopqual_adj xb) if hihost >=3 & war == 1, robust cluster(dispute_side_id) 

eststo: biprobit (ALLY = polity cinc cinc2sum xb) (WIN = ln_partners polity cinc cinc2sum troopqual_adj xb) if hihost >=3, robust cluster(dispute_side_id) 
eststo: biprobit (ALLY = democracy cinc cinc2sum xb) (WIN = ln_partners democracy cinc cinc2sum troopqual_adj xb) if hihost >=3, robust cluster(dispute_side_id) 

/* create LaTeX TABLE 3 */
esttab using allies.tex, replace label se mtitles("Wars Only" "Wars Only" "MIDs (3-5)" "MIDs (3-5)") /*
*/ title("Joint Probability of Partners and Victory") b(a2) se(a2) star(* 0.10 ** 0.05 *** 0.01) 

*/




/*******************************
TABLE 12 in the appendix
 bivariate probit model where ALLY is allies >2
Logging the CINC variables
**********************************/
eststo clear

eststo: biprobit (ALLY = polity ln_cinc ln_cinc2sum xb) (WIN = partners polity ln_cinc ln_cinc2sum troopqual_adj xb) if hihost >=3 & war == 1, robust cluster(dispute_side_id) 
eststo: biprobit (ALLY = democracy ln_cinc ln_cinc2sum xb) (WIN = partners democracy ln_cinc ln_cinc2sum troopqual_adj xb) if hihost >=3 & war == 1, robust cluster(dispute_side_id) 


eststo: biprobit (ALLY = polity ln_cinc ln_cinc2sum xb) (WIN = partners polity ln_cinc ln_cinc2sum troopqual_adj xb) if hihost >=3, robust cluster(dispute_side_id) 
eststo: biprobit (ALLY = democracy ln_cinc ln_cinc2sum xb) (WIN = partners democracy ln_cinc ln_cinc2sum troopqual_adj xb) if hihost >=3, robust cluster(dispute_side_id) 
esttab

/* create LaTeX TABLE 10A */
esttab using biprobit_allies.tex, replace label se mtitles("Wars Only" "Wars Only" "MIDs (3-5)" "MIDs (3-5)") /*
*/ title("Joint Probability of Partners and Victory: Bivariate Probit") b(a2) se(a2) star(* 0.10 ** 0.05 *** 0.01) 



/*********************************
TABLE 16 in the appendix
bivariate probit model where ALLY is allies >2
Controlling for systlem level democracy etc.
**********************************/

eststo clear
*eststo: biprobit (ALLY = polity cinc cinc2sum xb democracy_share postwwii  postcw polity_postwwii polity_postcw) (WIN = partners polity cinc cinc2sum troopqual_adj xb democracy_share postwwii postcw partners_postwwii partners_postcw ) if hihost >=3 & war == 1, robust cluster(dispute_side_id) 
*eststo: biprobit (ALLY = democracy cinc cinc2sum xb democracy_share  postwwii democracy_postwwii postcw  democracy_postcw) (WIN = partners democracy cinc cinc2sum troopqual_adj xb democracy_share  postwwii partners_postwwii postcw  partners_postcw ) if hihost >=3 & war == 1, robust cluster(dispute_side_id) 
*These first two models won't converge.
*pause
eststo: biprobit (ALLY = polity cinc cinc2sum xb democracy_share postwwii postcw polity_postwwii polity_postcw  ) (WIN = partners polity cinc cinc2sum troopqual_adj xb democracy_share postwwii postcw partners_postwwii  partners_postcw postwwii partners_postwwii) if hihost >=3, robust cluster(dispute_side_id) 
eststo: biprobit (ALLY = democracy cinc cinc2sum xb democracy_share postwwii democracy_postwwii postcw  democracy_postcw) (WIN = partners democracy cinc cinc2sum troopqual_adj xb democracy_share postwwii partners_postwwii postcw  partners_postcw) if hihost >=3, robust cluster(dispute_side_id) 
esttab

/* create LaTeX TABLE 3E */
esttab using biprobit_allies.tex, replace label se mtitles("MIDs (3-5)" "MIDs (3-5)") /*
*/ title("Joint Probability of Partners and Victory: Bivariate Probit") b(a2) se(a2) star(* 0.10 ** 0.05 *** 0.01) order(partners polity democracy) wide


*/


/*********************************
Table 18 in the appendix
bivariate probit model where ALLY is allies >2
Adding in initiator and initiator*democracy interaction*/
***********************************/
eststo clear

eststo: biprobit (ALLY = polity cinc cinc2sum xb initiator) (WIN = partners polity cinc cinc2sum troopqual_adj xb initiator) if hihost >=3 & war == 1, robust cluster(dispute_side_id) 
eststo: biprobit (ALLY = polity cinc cinc2sum xb initiator polity_initiator) (WIN = partners polity cinc cinc2sum troopqual_adj xb initiator polity_initiator) if hihost >=3 & war == 1, robust cluster(dispute_side_id) 

eststo: biprobit (ALLY = democracy cinc cinc2sum xb initiator) (WIN = partners democracy cinc cinc2sum troopqual_adj xb initiator) if hihost >=3 & war == 1, robust cluster(dispute_side_id) 
eststo: biprobit (ALLY = democracy cinc cinc2sum xb initiator democracy_initiator) (WIN = partners democracy cinc cinc2sum troopqual_adj xb initiator democracy_initiator) if hihost >=3 & war == 1, robust cluster(dispute_side_id) 

eststo: biprobit (ALLY = polity cinc cinc2sum xb initiator) (WIN = partners polity cinc cinc2sum troopqual_adj xb initiator) if hihost >=3, robust cluster(dispute_side_id) 
eststo: biprobit (ALLY = polity cinc cinc2sum xb initiator polity_initiator) (WIN = partners polity cinc cinc2sum troopqual_adj xb initiator polity_initiator) if hihost >=3, robust cluster(dispute_side_id) 

eststo: biprobit (ALLY = democracy cinc cinc2sum xb initiator) (WIN = partners democracy cinc cinc2sum troopqual_adj xb initiator) if hihost >=3, robust cluster(dispute_side_id) 
eststo: biprobit (ALLY = democracy cinc cinc2sum xb initiator democracy_initiator) (WIN = partners democracy cinc cinc2sum troopqual_adj xb initiator democracy_initiator) if hihost >=3, robust cluster(dispute_side_id) 

esttab

/* create LaTeX TABLE ? */
esttab using biprobit_allies.tex, replace label se mtitles("Sample = Wars Only" "Sample = MIDs (3-5)" ) /*
*/ title("Joint Probability of Partners and Victory: Bivariate Probit") b(a2) se(a2) star(* 0.10 ** 0.05 *** 0.01) order(polity democracy initiator polity_initiator democracy_initiator)


/*********************************
Table 21  in the appendix
bivariate probit model where where ALLYPOWER is allycinc > .1 (which turns out to be in top 10% of distribution, similar to 3 or more allies)
Adding in initiator and initiator*democracy interaction*/
***********************************/
eststo clear

eststo: biprobit (ALLYPOWER1 = polity cinc cinc2sum xb initiator) (WIN = allycinc polity cinc cinc2sum troopqual_adj xb initiator) if hihost >=3 & war == 1, robust cluster(dispute_side_id) 
eststo: biprobit (ALLYPOWER1 = polity cinc cinc2sum xb initiator polity_initiator) (WIN = allycinc polity cinc cinc2sum troopqual_adj xb initiator polity_initiator) if hihost >=3 & war == 1, robust cluster(dispute_side_id) 

eststo: biprobit (ALLYPOWER1 = democracy cinc cinc2sum xb initiator) (WIN = allycinc democracy cinc cinc2sum troopqual_adj xb initiator) if hihost >=3 & war == 1, robust cluster(dispute_side_id) 
eststo: biprobit (ALLYPOWER1 = democracy cinc cinc2sum xb initiator democracy_initiator) (WIN = allycinc democracy cinc cinc2sum troopqual_adj xb initiator democracy_initiator) if hihost >=3 & war == 1, robust cluster(dispute_side_id) 


eststo: biprobit (ALLYPOWER1 = polity cinc cinc2sum xb initiator) (WIN = allycinc polity cinc cinc2sum troopqual_adj xb initiator) if hihost >=3, robust cluster(dispute_side_id) 
eststo: biprobit (ALLYPOWER1 = polity cinc cinc2sum xb initiator polity_initiator) (WIN = allycinc polity cinc cinc2sum troopqual_adj xb initiator polity_initiator) if hihost >=3, robust cluster(dispute_side_id) 

eststo: biprobit (ALLYPOWER1 = democracy cinc cinc2sum xb initiator) (WIN = allycinc democracy cinc cinc2sum troopqual_adj xb initiator) if hihost >=3, robust cluster(dispute_side_id) 
eststo: biprobit (ALLYPOWER1 = democracy cinc cinc2sum xb initiator democracy_initiator) (WIN = allycinc democracy cinc cinc2sum troopqual_adj xb initiator democracy_initiator) if hihost >=3, robust cluster(dispute_side_id) 

esttab

/* create LaTeX TABLE ? */
esttab using biprobit_allies.tex, replace label se mtitles("Sample = Wars Only" "Sample = MIDs (3-5)" ) /*
*/ title("Joint Probability of Partners and Victory: Bivariate Probit") b(a2) se(a2) star(* 0.10 ** 0.05 *** 0.01) order(polity democracy initiator polity_initiator democracy_initiator)






/*******************************
TABLE 25 in the appendix
bivariate probit model where ALLY is allies >2
But now omitting the control for Dyad MID propensity
********************************/
eststo clear

eststo: biprobit (ALLY = polity cinc cinc2sum) (WIN = partners polity cinc cinc2sum troopqual_adj) if hihost >=3 & war == 1, robust cluster(dispute_side_id) 
eststo: biprobit (ALLY = democracy cinc cinc2sum) (WIN = partners democracy cinc cinc2sum troopqual_adj) if hihost >=3 & war == 1, robust cluster(dispute_side_id) 

eststo: biprobit (ALLY = polity cinc cinc2sum) (WIN = partners polity cinc cinc2sum troopqual_adj) if hihost >=3, robust cluster(dispute_side_id) 
eststo: biprobit (ALLY = democracy cinc cinc2sum) (WIN = partners democracy cinc cinc2sum troopqual_adj) if hihost >=3, robust cluster(dispute_side_id) 
esttab

/* create LaTeX TABLE 23 */
esttab using biprobit_allies.tex, replace label se mtitles("Wars Only" "Wars Only" "MIDs (3-5)" "MIDs (3-5)") /*
*/ title("Joint Probability of Partners and Victory: Bivariate Probit") b(a2) se(a2) star(* 0.10 ** 0.05 *** 0.01) 




/********************************
TABLE 26 in the appendix
 bivariate probit model where ALLYPOWER is allycinc > .1 (which turns out to be in top 10% of distribution, similar to 3 or more allies)
Note: The label in the paper reads "Partner Power" rather than "Ally Power." 
Omitting dyad mid propensity
 ***********************************/
 eststo clear

eststo: biprobit (ALLYPOWER1 = polity cinc cinc2sum) (WIN = allycinc polity cinc cinc2sum troopqual_adj) if hihost >=3 & war == 1, robust cluster(dispute_side_id) 
eststo: biprobit (ALLYPOWER1 = democracy cinc cinc2sum ) (WIN = allycinc democracy cinc cinc2sum troopqual_adj ) if hihost >=3 & war == 1, robust cluster(dispute_side_id) 



eststo: biprobit (ALLYPOWER1 = polity cinc cinc2sum ) (WIN = allycinc polity cinc cinc2sum troopqual_adj ) if hihost >=3, robust cluster(dispute_side_id) 
eststo: biprobit (ALLYPOWER1 = democracy cinc cinc2sum ) (WIN = allycinc democracy cinc cinc2sum troopqual_adj ) if hihost >=3, robust cluster(dispute_side_id) 

esttab

/* create LaTeX TABLE 25 */
esttab using alliescinc.tex, replace label se mtitles("Wars Only" "Wars Only" "MIDs (3-5)" "MIDs (3-5)") /*
*/ title("Joint Probability of Allies and Victory") b(a2) se(a2) star(* 0.10 ** 0.05 *** 0.01) /*
*/ addnotes("Specification: Bivariate Probit with errors clustered on dispute-side.")


/*******************************
TABLE 27 in the appendix 
bivariate probit model where ALLY is allies >2
limiting the sample to joiners only
********************************/
eststo clear

eststo: biprobit (ALLY = polity cinc cinc2sum xb) (WIN = partners polity cinc cinc2sum troopqual_adj xb) if hihost >=3 & war == 1 & joiner == 1, robust cluster(dispute_side_id) 
eststo: biprobit (ALLY = democracy cinc cinc2sum xb) (WIN = partners democracy cinc cinc2sum troopqual_adj xb) if hihost >=3 & war == 1 & joiner == 1, robust cluster(dispute_side_id) 


eststo: biprobit (ALLY = polity cinc cinc2sum xb) (WIN = partners polity cinc cinc2sum troopqual_adj xb) if hihost >=3 & joiner == 1, robust cluster(dispute_side_id) 
eststo: biprobit (ALLY = democracy cinc cinc2sum xb) (WIN = partners democracy cinc cinc2sum troopqual_adj xb) if hihost >=3 & joiner == 1, robust cluster(dispute_side_id) 
esttab

/* create LaTeX TABLE 28 */
esttab using biprobit_allies.tex, replace label se mtitles("Wars Only" "Wars Only" "MIDs (3-5)" "MIDs (3-5)") /*
*/ title("Joint Probability of Partners and Victory: Bivariate Probit") b(a2) se(a2) star(* 0.10 ** 0.05 *** 0.01) 



/*******************************
TABLE 29 in the appendix 
bivariate probit model where ALLY is allies >2
omitting the joiners
********************************/
eststo clear

eststo: biprobit (ALLY = polity cinc cinc2sum xb) (WIN = partners polity cinc cinc2sum troopqual_adj xb) if hihost >=3 & war == 1 & joiner == 0, robust cluster(dispute_side_id) 
eststo: biprobit (ALLY = democracy cinc cinc2sum xb) (WIN = partners democracy cinc cinc2sum troopqual_adj xb) if hihost >=3 & war == 1 & joiner == 0, robust cluster(dispute_side_id) 


eststo: biprobit (ALLY = polity cinc cinc2sum xb) (WIN = partners polity cinc cinc2sum troopqual_adj xb) if hihost >=3 & joiner == 0, robust cluster(dispute_side_id) 
eststo: biprobit (ALLY = democracy cinc cinc2sum xb) (WIN = partners democracy cinc cinc2sum troopqual_adj xb) if hihost >=3 & joiner == 0, robust cluster(dispute_side_id) 
esttab

/* create LaTeX TABLE 31 */
esttab using biprobit_allies.tex, replace label se mtitles("Wars Only" "Wars Only" "MIDs (3-5)" "MIDs (3-5)") /*
*/ title("Joint Probability of Partners and Victory: Bivariate Probit") b(a2) se(a2) star(* 0.10 ** 0.05 *** 0.01) 


/*******************************
TABLE 28 in the appendix 
bivariate probit model where ALLYPOWER1 is allycinc > .1 (which turns out to be in top 10% of distribution, similar to 3 or more allies)
restricting to joiners only
********************************/

 eststo clear

eststo: biprobit (ALLYPOWER1 = polity cinc cinc2sum xb) (WIN = allycinc polity cinc cinc2sum troopqual_adj xb) if hihost >=3 & war == 1 & joiner == 1, robust cluster(dispute_side_id) 
eststo: biprobit (ALLYPOWER1 = democracy cinc cinc2sum xb) (WIN = allycinc democracy cinc cinc2sum troopqual_adj xb) if hihost >=3 & war == 1 & joiner == 1, robust cluster(dispute_side_id) 



eststo: biprobit (ALLYPOWER1 = polity cinc cinc2sum xb) (WIN = allycinc polity cinc cinc2sum troopqual_adj xb) if hihost >=3 & joiner == 1, robust cluster(dispute_side_id) 
eststo: biprobit (ALLYPOWER1 = democracy cinc cinc2sum xb) (WIN = allycinc democracy cinc cinc2sum troopqual_adj xb) if hihost >=3 & joiner == 1, robust cluster(dispute_side_id) 

esttab

/* create LaTeX TABLE 3A */
esttab using alliescinc.tex, replace label se mtitles("Wars Only" "Wars Only" "MIDs (3-5)" "MIDs (3-5)") /*
*/ title("Joint Probability of Allies and Victory") b(a2) se(a2) star(* 0.10 ** 0.05 *** 0.01) /*
*/ addnotes("Specification: Bivariate Probit with errors clustered on dispute-side.")


/*******************************
TABLE 30 in the appendix 
bivariate probit model where ALLYPOWER1 is allycinc > .1 (which turns out to be in top 10% of distribution, similar to 3 or more allies)
omitting the joiners
********************************/

 eststo clear

eststo: biprobit (ALLYPOWER1 = polity cinc cinc2sum xb) (WIN = allycinc polity cinc cinc2sum troopqual_adj xb) if hihost >=3 & war == 1 & joiner == 0, robust cluster(dispute_side_id) 
eststo: biprobit (ALLYPOWER1 = democracy cinc cinc2sum xb) (WIN = allycinc democracy cinc cinc2sum troopqual_adj xb) if hihost >=3 & war == 1 & joiner == 0, robust cluster(dispute_side_id) 


eststo: biprobit (ALLYPOWER1 = polity cinc cinc2sum xb) (WIN = allycinc polity cinc cinc2sum troopqual_adj xb) if hihost >=3 & joiner == 0, robust cluster(dispute_side_id) 
eststo: biprobit (ALLYPOWER1 = democracy cinc cinc2sum xb) (WIN = allycinc democracy cinc cinc2sum troopqual_adj xb) if hihost >=3 & joiner == 0, robust cluster(dispute_side_id) 

esttab

/* create LaTeX TABLE 3A */
esttab using alliescinc.tex, replace label se mtitles("Wars Only" "Wars Only" "MIDs (3-5)" "MIDs (3-5)") /*
*/ title("Joint Probability of Allies and Victory") b(a2) se(a2) star(* 0.10 ** 0.05 *** 0.01) /*
*/ addnotes("Specification: Bivariate Probit with errors clustered on dispute-side.")





/*******************
Below here are bivariate ordered probit models
**********************/

/************************
Table 4 in the appendix
Now bioprobit version with raw partners
*************************/
eststo clear 
eststo: bioprobit (opartners3 = polity cinc cinc2sum xb) (win3_1 = partners polity cinc cinc2sum troopqual_adj xb) if hihost >=3 & war == 1, robust cluster(dispute_side_id) 
eststo: bioprobit (opartners3 = democracy cinc cinc2sum xb) (win3_1 = partners democracy cinc cinc2sum troopqual_adj xb) if hihost >=3 & war == 1, robust cluster(dispute_side_id) 

*pause
eststo: bioprobit (opartners3 = polity cinc cinc2sum xb) (win3_1 = partners polity cinc cinc2sum troopqual_adj xb) if hihost >=3, robust cluster(dispute_side_id) 
eststo: bioprobit (opartners3 = democracy cinc cinc2sum xb) (win3_1 = partners democracy cinc cinc2sum troopqual_adj xb) if hihost >=3, robust cluster(dispute_side_id) 
esttab

/* create LaTeX TABLE 4A */
esttab using bioprobit.tex, replace label se mtitles("Wars Only" "Wars Only" "MIDs (3-5)" "MIDs (3-5)") /*
*/ title("Joint Probability of Partners and Victory: Bivariate Ordered Probit") b(a2) se(a2) star(* 0.10 ** 0.05 *** 0.01) 



/************************
Table 5 in the appendix
Now bioprobit version with logged partners
*************************/
/*TABLE 4B bivariate ordered probit model with logged partners and ordered partners3*/
eststo clear
*eststo: bioprobit (opartners3 = polity) (win3_1 = partners polity) if hihost >=3 & war == 1, robust cluster(dispute_side_id) 
eststo: bioprobit (opartners3 = polity cinc cinc2sum xb) (win3_1 = ln_partners polity cinc cinc2sum troopqual_adj xb) if hihost >=3 & war == 1, robust cluster(dispute_side_id) 
eststo: bioprobit (opartners3 = democracy cinc cinc2sum xb) (win3_1 = ln_partners democracy cinc cinc2sum troopqual_adj xb) if hihost >=3 & war == 1, robust cluster(dispute_side_id) 

*pause
*eststo: bioprobit (opartners3 = polity) (win3_1 = partners polity) if hihost >=3,  robust cluster(dispute_side_id) 
eststo: bioprobit (opartners3 = polity cinc cinc2sum xb) (win3_1 = ln_partners polity cinc cinc2sum troopqual_adj xb) if hihost >=3, robust cluster(dispute_side_id) 
eststo: bioprobit (opartners3 = democracy cinc cinc2sum xb) (win3_1 = ln_partners democracy cinc cinc2sum troopqual_adj xb) if hihost >=3, robust cluster(dispute_side_id) 
esttab

/* create LaTeX TABLE 5A */
esttab using bioprobit.tex, replace label se mtitles("Wars Only" "Wars Only" "MIDs (3-5)" "MIDs (3-5)") /*
*/ title("Joint Probability of Partners and Victory: Bivariate Ordered Probit") b(a2) se(a2) star(* 0.10 ** 0.05 *** 0.01) 




/************************
Table 6 in the appendix
Now bioprobit version with Allycinc 
*************************/
eststo clear
*eststo: bioprobit (oallycinc3 = polity) (win3_1 = allycinc polity) if hihost >=3 & war == 1, robust cluster(dispute_side_id) 
eststo: bioprobit (oallycinc3 = polity cinc cinc2sum xb) (win3_1 = allycinc polity cinc cinc2sum troopqual_adj xb) if hihost >=3 & war == 1, robust cluster(dispute_side_id) 
eststo: bioprobit (oallycinc3 = democracy cinc cinc2sum xb) (win3_1 = allycinc democracy cinc cinc2sum troopqual_adj xb) if hihost >=3 & war == 1, robust cluster(dispute_side_id) 

*pause
*eststo: bioprobit (oallycinc3 = polity) (win3_1 = allycinc polity) if hihost >=3,  robust cluster(dispute_side_id) 
eststo: bioprobit (oallycinc3 = polity cinc cinc2sum xb) (win3_1 = allycinc polity cinc cinc2sum troopqual_adj xb) if hihost >=3, robust cluster(dispute_side_id) 
eststo: bioprobit (oallycinc3 = democracy cinc cinc2sum xb) (win3_1 = allycinc democracy cinc cinc2sum troopqual_adj xb) if hihost >=3, robust cluster(dispute_side_id) 

esttab, se 

/* create LaTeX TABLE 6A */
esttab using bioprobit.tex, replace label se mtitles("Wars Only" "Wars Only" "MIDs (3-5)" "MIDs (3-5)") /*
*/ title("Joint Probability of Partners and Victory: Bivariate Ordered Probit") b(a2) se(a2) star(* 0.10 ** 0.05 *** 0.01) 



/************************
Table 13 in the appendix
Now bioprobit version with raw partners
and logged CINC scores
*************************/
eststo clear
*eststo: bioprobit (opartners3 = polity) (win3_1 = partners polity) if hihost >=3 & war == 1, robust cluster(dispute_side_id) 
eststo: bioprobit (opartners3 = polity ln_cinc ln_cinc2sum xb) (win3_1 = partners polity ln_cinc ln_cinc2sum troopqual_adj xb) if hihost >=3 & war == 1, robust cluster(dispute_side_id) 
eststo: bioprobit (opartners3 = democracy ln_cinc ln_cinc2sum xb) (win3_1 = partners democracy ln_cinc ln_cinc2sum troopqual_adj xb) if hihost >=3 & war == 1, robust cluster(dispute_side_id) 

*pause
*eststo: bioprobit (opartners3 = polity) (win3_1 = partners polity) if hihost >=3,  robust cluster(dispute_side_id) 
eststo: bioprobit (opartners3 = polity ln_cinc ln_cinc2sum xb) (win3_1 = partners polity ln_cinc ln_cinc2sum troopqual_adj xb) if hihost >=3, robust cluster(dispute_side_id) 
eststo: bioprobit (opartners3 = democracy ln_cinc ln_cinc2sum xb) (win3_1 = partners democracy ln_cinc ln_cinc2sum troopqual_adj xb) if hihost >=3, robust cluster(dispute_side_id) 
esttab

/* create LaTeX TABLE 11a */
esttab using bioprobit.tex, replace label se mtitles("Wars Only" "Wars Only" "MIDs (3-5)" "MIDs (3-5)") /*
*/ title("Joint Probability of Partners and Victory: Bivariate Ordered Probit") b(a2) se(a2) star(* 0.10 ** 0.05 *** 0.01) 




cap log close
exit


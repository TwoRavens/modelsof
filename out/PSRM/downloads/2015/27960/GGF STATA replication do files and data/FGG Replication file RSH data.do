/*
Replication data and code for:
Christopher J. Fariss, Erik Gartzke and Benjamin A.T. Graham
"Allying to Win: Regime Type, Alliance Size, and Victory"
University of California, San Diego
last updated: 12-22-2014
This replicates the analysis in the appendix that re-tests our main 
models using the new data on wars from Reiter, Stam and Horowitz.
*/

clear
clear matrix
*cd "/Users/Chris/Documents/R1"
cd "/Users/bengraham1/Dropbox/Collaborative Research/Chris and Erik/do files, R code, and data"
pause on
set more off

cap log close
log using GGF_psrm_replication_log_rsh, replace

use "RSH_Wars_directed_dyads_FGG", clear

/* generate binary variables for probit and bivariate probit models 
Note that the binary variable for ALLY takes a value of 1 if there are
at least 2 allies, i.e. a total of at least two allies IN ADDITION to the 
state in question.

The binary variable for WIN takes a value of 0 for ties.
*/

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

gen democracy_postwwii = polity*postwwii
label var democracy_postwwii "Democracy [Boix et al.] * Post WWII"



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
The following code producesTables 22, 23, and 24
in the appendix, 
******************/

/* TABLE 22 negative binomial regression models for number of allies count dependent variable & OLS regression models for ally-power continuous dependent variable
 */
eststo clear
nbreg partners polity if war == 1, vce(cluster dispute_side_id)
eststo: nbreg partners polity cinc cinc2sum if war == 1, vce(cluster dispute_side_id)
eststo: nbreg partners democracy cinc cinc2sum if war == 1, vce(cluster dispute_side_id)

eststo: reg allycinc polity cinc cinc2sum if war == 1, vce(cluster dispute_side_id)
eststo: reg allycinc democracy cinc cinc2sum if war == 1, vce(cluster dispute_side_id)
esttab
/* create LaTeX TABLE 1 */
esttab using alliesregimenb_log.tex, replace label mtitles("DV=Count" "DV=Count" "DV=Power" "DV=Power") nonumbers title("Number of Coalition Partners: RSH Wars") /*
*/ b(a2) se(a2) r2(a3) star(* 0.10 ** 0.05 *** .01) addnotes("Models 1 \& 2: Negative Binomial regression with errors clustered on dispute-side." "Models 3 \& 4: OLS with errors clustered on dispute-side." ) order(polity democracy cinc)




/* TABLE 23 ordinal probit regression models for ordinal victory variable (victory=2, draw=1, loss=0) 
Adding in troop quality.  Also, using prchange to calculate marginal effects*/

eststo clear
eststo: oprobit win3_1 partners cinc cinc2sum xb troopqual_adj polity if  war == 1, robust cluster(dispute_side_id)
prchange
*pause
eststo: oprobit win3_1 partners cinc cinc2sum xb troopqual_adj democracy if  war == 1, robust cluster(dispute_side_id)

eststo: oprobit win3_1 allycinc cinc cinc2sum xb troopqual_adj polity if war == 1, robust cluster(dispute_side_id)
eststo: oprobit win3_1 allycinc cinc cinc2sum xb troopqual_adj democracy if war == 1, robust cluster(dispute_side_id)

esttab


/* create LaTeX TABLE 2 */
esttab using orderedWIN.tex, replace label se mtitles("Count" "Count" "Power" "Power") /*
*/ title("Probability of Victory: RSH Wars") b(a2) se(a2) star(* 0.10 ** 0.05 *** 0.01) addnotes("Specification: Ordered Probit with errors clustered on dispute-side.") order(partners allycinc polity democracy)



/*TABLE 24 bivariate probit model where ALLY is allies >2*/
eststo clear
*eststo: biprobit (ALLY = polity) (WIN = partners polity) if war == 1, robust cluster(dispute_side_id) 
eststo: biprobit (ALLY = polity cinc cinc2sum xb) (WIN = partners polity cinc cinc2sum troopqual_adj xb) if  war == 1, robust cluster(dispute_side_id) 
eststo: biprobit (ALLY = democracy cinc cinc2sum xb) (WIN = partners democracy cinc cinc2sum troopqual_adj xb) if  war == 1, robust cluster(dispute_side_id) 

eststo: biprobit (ALLYPOWER1 = polity cinc cinc2sum xb) (WIN = allycinc polity cinc cinc2sum troopqual_adj xb) if war == 1, robust cluster(dispute_side_id) 
eststo: biprobit (ALLYPOWER1 = democracy cinc cinc2sum xb) (WIN = allycinc democracy cinc cinc2sum troopqual_adj xb) if war == 1, robust cluster(dispute_side_id) 

esttab
/* create LaTeX TABLE 3 */
esttab using biprobit_allies.tex, replace label se mtitles("Partners" "Partners" "Power" "Power") /*
*/ title("Joint Probability of Partners and Victory: Bivariate Probit") b(a2) se(a2) star(* 0.10 ** 0.05 *** 0.01) 

*/


cap log close
exit





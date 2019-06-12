clear
set more off

if regexm(c(os),"Mac") == 1 {
	cd "~/Dropbox/Corporate Returns to Campaign Contributions/JOP/qpq_replication"
	}
	else if regexm(c(os),"Windows") == 1 {
	cd "~\Dropbox\Corporate Returns to Campaign Contributions\JOP/qpq_replication"
}

********************************************************************************
********* APPENDIX FIGURE A.1: BETTING PRICES THE DAY BEFORE THE ELECTION ******
********************************************************************************

use "qpq_intrade", clear

* Analysis of betting price the day before the election versus actual voteshare

* Remove a race with a Rep vs libertarian (IN 06), as complementary bet price
* does not correspond to the Dem candidate (inexistent). Also SD 10, as Rep
* was unchallenged. CT 06 is also dropped, as Lierbeman (Dem) lost 
* the primary but formed his own party and won. VT 06 Sanders was independent

drop if state == "IN" & cycle == 2006
drop if state == "SD" & cycle == 2010
drop if state == "CT" & cycle == 2006
drop if state == "VT" & cycle == 2006


* Keep observations pertaining to the day before the election
keep if diff == 1 
keep cycle state dem_voteshare dem_price rep_price diff
sort cycle state
egen cyst = group(cycle state diff)
sort cyst
drop if cyst == cyst[_n - 1]

* Transform betting price to implied winning probability
gen dem_prob = dem_price/100

scatter dem_prob dem_voteshare, graphregion(color(white)) bgcolor(white) 


********************************************************************************
********* APPENDIX FIGURE A.2: PROPORTION OF MONEY TO DEM BY FIRM-RACE *********
********************************************************************************

use "qpq_contributions", clear

hist propdem, graphregion(color(white)) bgcolor(white)

********************************************************************************
************ APPENDIX FIGURE A.3: VOTE SHARE HISTOGRAM *************************
********************************************************************************

use "qpq_main_dataset", clear

hist voteshare, start(0) width(.01) xline(.5) graphregion(color(white)) bgcolor(white)

********************************************************************************
************ APPENDIX FIGURE A.4: INCUMBENTS AND CHALLENGERS *******************
********************************************************************************

use "qpq_main_dataset", clear

* First, remove all observations where the incumbent was not challenged or where 
* there was only one candidate
drop if voteshare == 0
drop if voteshare == 1

g incumbent = dem == 1 & deminc == 1
replace incumbent = 1 if dem == 0 & repinc == 1

* Histogram of voteshare - Incumbents vs Challengers

twoway (histogram voteshare if incumbent==0, xline(0.5) start(0) width(0.02) frequency color(red) ///
        graphregion(color(white)) bgcolor(white)) ///
       (histogram voteshare if incumbent==1, xline(0.5) start(0) width(0.02) frequency ///
	    fcolor(none) lcolor(black) graphregion(color(white)) bgcolor(white)), ///
		xtitle (Two-Party Vote Share of Favored Candidate) graphregion(color(white)) bgcolor(white) ///
		legend(order( 1 "Challengers" 2 "Incumbents"))


********************************************************************************
************ APPENDIX FIGURE A.5: VOTE SHARE OF RECIPIENT  *********************
********************************************************************************

use "qpq_main_dataset", clear

* First, remove all observations where the incumbent was not challenged or where
* there was only one candidate
drop if voteshare == 0
drop if voteshare == 1

DCdensity_noCI voteshare, breakpoint(0.5) generate(Xj Yj r0 fhat se_fhat) b(.005) h(.025)  

************** PERMUTATION TEST FOR VOTESHARE *********************************

keep cycle cid voteshare permco election election_firm firm firm_cycle party_cycle rv

di r(theta) 
local actual_theta = r(theta) 
* Actual discontinuity estimate: 0.0998 

set seed 222

tempname perm_voteshare
postfile `perm_voteshare' thet using perm_voteshare, replace
qui {
forvalues i = 1/5000 {

gen ran = floor((1 + 1)*runiform())
* Assign a 0 or a 1 to each race. If a 1 is assigned, flip voteshares
sort election, stable
bysort election: replace ran = ran[1]
preserve
replace voteshare = 1 - voteshare if ran == 1
replace rv = -rv if ran == 1

DCdensity voteshare, breakpoint(0.5) generate(Xj Yj r0 fhat se_fhat) b(.005) h(.025) 

* Save the theta discontinuity estimates
scalar thet       = r(theta)

restore

post `perm_voteshare' (thet) 
drop ran  
}
}
postclose `perm_voteshare'

use perm_voteshare, clear
gen flag = 0
replace flag = 1 if abs(thet) > .0998 
egen sum_flag = sum(flag)
gen frac_above = sum_flag/_N
di frac_above
* 40.7 percent


********************************************************************************
************ APPENDIX FIGURE A.6: VOTE SHARE OF DEMOCRAT ***********************
********************************************************************************

use "qpq_main_dataset", clear

* "dem_voteshare" gives the voteshare obtained by the Democrat candidate
* in a race-donation observation, regardless of whether the donation is received by
* the Democrat or the Republican. 

gen dem_voteshare = 0
replace dem_voteshare = voteshare if dem == 1
replace dem_voteshare = 1 - voteshare if dem == 0
gen dem_rv = 0
replace dem_rv = dem_voteshare - 0.5

* First, remove all observations where the incumbent was not challenged
drop if dem_voteshare == 0
drop if dem_voteshare == 1

DCdensity_noCI dem_voteshare, breakpoint(0.5) generate(xj yj R0 Fhat SE_Fhat) b(.005) h(.025) 
* Actual discontinuity estimate: 0.00195 

keep cycle cid voteshare permco election election_firm firm firm_cycle party_cycle dem_voteshare dem_rv rv

di r(theta) 
local actual_theta = r(theta) 

set seed 222

tempname perm_dem_voteshare
postfile `perm_dem_voteshare' thet using perm_dem_voteshare, replace
qui {
forvalues i = 1/5000 {

gen ran = floor((1 + 1)*runiform())
* Assign a 0 or a 1 to each race. If a 1 is assigned, flip voteshares
sort election, stable
bysort election: replace ran = ran[1]
preserve
replace dem_voteshare = 1 - dem_voteshare if ran == 1
replace dem_rv = -dem_rv if ran == 1

DCdensity dem_voteshare, breakpoint(0.5) generate(Xj Yj r0 fhat se_fhat) b(.005) h(.025)

* Save the theta discontinuity estimates
scalar thet       = r(theta)

restore

post `perm_dem_voteshare' (thet) 
drop ran  
}
}
postclose `perm_dem_voteshare'

use perm_dem_voteshare, clear
gen flag = 0
replace flag = 1 if abs(thet) > .00195 
egen sum_flag = sum(flag)
gen frac_above = sum_flag/_N
di frac_above
* 99.32 percent

**********************************************************************
************ APPENDIX FIGURE A.7: POWER CURVE ************************
**********************************************************************

* Placebo regressions with and without "treatment"

use "power_dataset", clear

*drop if abs(rv) > 0.05

gen constant = 1

egen win_cand_supported = sum(wins), by(year firm)
egen cand_supp = sum(constant), by(year firm)
gen net_win = win_cand_supported - (cand_supp - win_cand_supported)


* Generate a variable CAR_minus1_1 so that it can be replaced in each iteration
gen CAR_minus1_1 = 1

set seed 1231

* No fixed effects and cycle clustering

tempname power_simulations
postfile `power_simulations' vic_b_0 vic_se_0 vic_b_1 vic_se_1 vic_b_2 vic_se_2 vic_b_3 vic_se_3 vic_b_4 vic_se_4 ///
vic_b_5 vic_se_5 vic_b_6 vic_se_6 vic_b_7 vic_se_7 vic_b_8 vic_se_8 vic_b_9 vic_se_9 ///
vic_b_10 vic_se_10 vic_b_11 vic_se_11 vic_b_12 vic_se_12 vic_b_13 vic_se_13 vic_b_14 vic_se_14 ///
vic_b_15 vic_se_15 vic_b_16 vic_se_16 vic_b_17 vic_se_17 vic_b_18 vic_se_18 vic_b_19 vic_se_19 ///
vic_b_20 vic_se_20 using power_simulations, replace

qui {
forvalues i = 1/1000 {
* generate ui = floor((b–a+1)*runiform() + a)
* Randomly draw from {1, 2, ,...., 180} trading days. Just making sure we are never inside -5 trading days before election window
gen ran = floor((180 - 1 + 1)*runiform() + 1)

* Assign a number to each year. This number will determine the placebo day of the election at that year,
* and it will be that number of trading days after the first Tuesday after the first Monday of February
sort year, stable
bysort year: replace ran = ran[1]
* Make a loop over different values of the "treatment" multiplied by net close-winners supported in year
forvalues q = 0/20 {
preserve
forval j = 1/180 {
local m = `j' - 1
local p = `j' + 1
* The "treatment" is added; it goes from 0 to 0.5 percent effect, multiplied by the
* net number of close-winners supported by the firm in a year (0 to 1 percent in
* the regression, given that the "treatment" also applies in the reverse direction,
* i.e. when the favored candidate loses)
replace AR_mc`j' = AR_mc`j' + ((`q')/4000)*net_win if ran == `j' 
replace CAR_minus1_1 = (1 + AR_mc`m')*(1 + AR_mc`j')*(1 + AR_mc`p') if ran == `j'
}

replace CAR_minus1_1 = CAR_minus1_1 - 1
reghdfe CAR_minus1_1 victory rv rv_victory, absorb(constant) cluster(cycle)
* Save the betas associated to victory
scalar vic_b_`q'       = _b[victory]
scalar vic_se_`q'      = _se[victory]
restore
}

post `power_simulations' (vic_b_0) (vic_se_0) (vic_b_1) (vic_se_1) (vic_b_2) (vic_se_2) (vic_b_3) (vic_se_3) (vic_b_4) (vic_se_4) ///
(vic_b_5) (vic_se_5) (vic_b_6) (vic_se_6) (vic_b_7) (vic_se_7) (vic_b_8) (vic_se_8) (vic_b_9) (vic_se_9) (vic_b_10) (vic_se_10) ///
(vic_b_11) (vic_se_11) (vic_b_12) (vic_se_12) (vic_b_13) (vic_se_13) (vic_b_14) (vic_se_14) (vic_b_15) (vic_se_15) (vic_b_16) ///
(vic_se_16) (vic_b_17) (vic_se_17) (vic_b_18) (vic_se_18) (vic_b_19) (vic_se_19) (vic_b_20) (vic_se_20) 

drop ran
}
}
postclose `power_simulations'

**********************************************************************
************ APPENDIX FIGURE A.7: POWER CURVE ************************
**********************************************************************

use power_simulations, clear

* We are clustering se's by cycle (16), so dof is 15
gen dof = 15


forvalues i = 0/20 {
gen t_`i'         = vic_b_`i'/vic_se_`i'
gen pval_`i'      = 2*ttail(dof,abs(t_`i'))
gen flag_`i'      = pval_`i' < 0.05
egen tot_flag_`i' = sum(flag_`i')
* Number of iterations denoted by _N
gen rej_rate_`i'  = (tot_flag_`i')/_N 

}

gen id = _n
reshape long rej_rate_, i(id) j(effect)
sort effect

sort effect
drop if effect == effect[_n - 1]

* Put effect in percentage terms 
replace effect = effect/20
rename effect Effect
rename rej_rate_ Rejection_rate

keep Effect Rejection_rate

scatter Rejection_rate Effect, graphregion(color(white)) bgcolor(white)
graph twoway (connected Rejection_rate Effect), graphregion(color(white)) bgcolor(white)

********************************************************************************
************ APPENDIX FIGURE A.8: PLACEBO **************************************
********************************************************************************

use power_simulations, clear

keep vic_b_0

* Calculate fraction of estimates that are bigger than -.00062 (main result) in absolute value
gen flag = abs(vic_b_0) > 0.00062
tab flag
* 54.20 percent

* Turn estimates into percentage terms
replace vic_b_0 = 100*vic_b_0

* -.0006 is the beta obtained in the main specification
hist vic_b_0, xtitle (Estimated Effect (in percentage terms)) xline(-.0006) graphregion(color(white)) bgcolor(white)


********************************************************************************
************ APPENDIX FIGURE A.9: PERMUTATION  *********************************
********************************************************************************


* First run the permutation simulations

use "qpq_main_dataset", clear

* Restrict sample to close elections (margin of victory lower or equal to 10 percentage points)
drop if abs(rv) > .05
keep cycle cid voteshare permco election election_firm firm firm_cycle party_cycle totaldem totalrep propdem ///
total_donation dem CAR_minus1_1

gen constant = 1

set seed 222

tempname qpq_perm
postfile `qpq_perm' vic_b vic_se using qpq_perm, replace
qui {
forvalues i = 1/10000 {
gen ran = floor((1 + 1)*runiform())
* Assign a 0 or a 1 to each race. If a 1 is assigned, flip voteshares
sort election, stable
bysort election: replace ran = ran[1]
preserve
replace voteshare = 1 - voteshare if ran == 1
g rv = voteshare - .5
g victory = rv > 0
g rv_victory = rv*victory

* Calculate discontinuity
reghdfe CAR_minus1_1 victory rv rv_victory, absorb(constant) vce(cluster cycle) 

* Save the betas associated to victory
scalar vic_b       = _b[victory]
scalar vic_se      = _se[victory]
restore

post `qpq_perm' (vic_b) (vic_se) 
drop ran
}
}
postclose `qpq_perm'

* Then use the resulting dataset

use "qpq_perm", clear

* Calculate fraction of estimates that are bigger than -.00062 (main result) in absolute value
gen flag = abs(vic_b) > 0.00062
tab flag
* 59.3 percent

gen tstat = abs(vic_b/vic_se)
* 2.13 is the critical value, due to clustering by election cycle
gen rej = tstat > 2.13
tab rej
* The rejection rate is 6.2 percent, very close to 5 percent

* Turn estimates into percentage terms to plot the histogram
replace vic_b = 100*vic_b

* Histogram of the betas of each of the permutations
* -.0006 is the beta obtained in the main specification
hist vic_b, graphregion(color(white)) bgcolor(white) xtitle (Estimated Effect) xline(-.0006) 

*******************************************************************************
************ APPENDIX FIGURE A.10: VA 06 CASE STUDY  ***************************
********************************************************************************

use "VA_06_data", clear

graph twoway (line demprob days, yaxis(1)) (scatter poll days, yaxis(2)) if days > -150, xline(-88) xline(-12) xline(0) 

gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .style.editstyle margin(vsmall) boxstyle(shadestyle(color(white)) linestyle(color(white))) editcopy
gr_edit .xaxis1.title.text = {}
gr_edit .xaxis1.title.text.Arrpush Days before Election
gr_edit .yaxis1.title.text = {}
gr_edit .yaxis1.title.text.Arrpush Betting Market Beliefs
gr_edit .plotregion1.plot1.style.editstyle line(color(black) width(thick)) editcopy
gr_edit .yaxis1.style.editstyle majorstyle(gridstyle(linestyle(color(white)))) editcopy
gr_edit .plotregion2.plot2.style.editstyle marker(size(small) fillcolor(gs8) linestyle(color(gs8))) editcopy
gr_edit .yaxis2.title.style.editstyle color(gs8) editcopy
gr_edit .yaxis2.style.editstyle majorstyle(tickstyle(textstyle(color(gs8)))) editcopy
gr_edit .yaxis2.title.text = {}
gr_edit .yaxis2.title.text.Arrpush Poll Results
gr_edit .yaxis2.reset_rule .4 .6 .05 , tickset(major) ruletype(range) 
gr_edit .plotregion2._xylines[1].style.editstyle linestyle(color(black) pattern(dash)) editcopy
gr_edit .plotregion2._xylines[2].style.editstyle linestyle(color(black) pattern(dash)) editcopy
gr_edit .plotregion2._xylines[3].style.editstyle linestyle(color(black) pattern(dash)) editcopy
gr_edit .plotregion2.AddTextBox added_text editor .425 -3.7
gr_edit .plotregion2.added_text_new = 1
gr_edit .plotregion2.added_text_rec = 1
gr_edit .plotregion2.added_text[1].style.editstyle  angle(default) size(vsmall) color(black) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
gr_edit .plotregion2.added_text[1]._set_orientation vertical
gr_edit .plotregion2.added_text[1].text = {}
gr_edit .plotregion2.added_text[1].text.Arrpush Election Day
gr_edit .plotregion2.AddTextBox added_text editor .57 -91.7
gr_edit .plotregion2.added_text_new = 2
gr_edit .plotregion2.added_text_rec = 2
gr_edit .plotregion2.added_text[2].style.editstyle  angle(default) size(vsmall) color(black) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
gr_edit .plotregion2.added_text[2]._set_orientation vertical
gr_edit .plotregion2.added_text[2].text = {}
gr_edit .plotregion2.added_text[2].text.Arrpush Macaca gaffe
gr_edit .plotregion2.AddTextBox added_text editor .57 -15.7
gr_edit .plotregion2.added_text_new = 3
gr_edit .plotregion2.added_text_rec = 3
gr_edit .plotregion2.added_text[3].style.editstyle  angle(default) size(vsmall) color(black) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
gr_edit .plotregion2.added_text[3]._set_orientation vertical
gr_edit .plotregion2.added_text[3].text = {}
gr_edit .plotregion2.added_text[3].text.Arrpush scrutiny of Webb novels

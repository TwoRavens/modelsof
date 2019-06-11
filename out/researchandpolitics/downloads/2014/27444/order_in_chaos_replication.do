************************************************
*REPLICATION FOE: ORDER IN CHAOS (26/09/2014)
*************************************************

clear all

*change this to you own directory

cd //INSERT PATH HERE

*opening data

use "order_in_chaos_replication.dta", clear

*************************
*MISC
*************************

capture drop log_number_of_candidates
gen log_number_of_candidates = log(number_of_candidates)


capture drop log_number_of_candidates
gen log_number_of_candidates = log(number_of_candidates)


***************************************
*FIGURE 1
****************************************


lowess votes_pct ballot_number_pct, ///
msymbol(smcircle_hollow) scheme(sj) graphregion(color(white)) ///
title("Lowess Smoother", size(medium)) xtitle("Ballot Position (pct.)", size(medium) margin(medium)) ytitle("Pct. of Votes", size(medium) margin(medium)) ///
xlabel(,labsize(small)) ylabel(,labsize(small)) note("") ///
saving(lowess_w_kabul.gph, replace) nodraw

lowess votes_pct ballot_number_pct if province != "Kabul", ///
msymbol(smcircle_hollow) scheme(sj) graphregion(color(white)) ///
title("Lowess Smoother (without Kabul)", size(medium)) xtitle("Ballot Position (pct.)", size(medium) margin(medium)) ytitle("Pct. of Votes", size(medium) margin(medium)) ///
xlabel(,labsize(small)) ylabel(,labsize(small)) note("") ///
saving(lowess_wo_kabul.gph, replace) nodraw


qui sum number_of_candidates, d

lowess votes_pct ballot_number_pct if number_of_candidates < `r(p50)' , ///
msymbol(smcircle_hollow) scheme(sj) graphregion(color(white)) ///
title("Lowess Smoother (ballot length < median)", size(medium)) xtitle("Ballot Position (pct.)", size(medium) margin(medium)) ytitle("Pct. of Votes", size(medium) margin(medium)) ///
xlabel(,labsize(small)) ylabel(,labsize(small)) note("") ///
saving(lowess_w_kabul_und_med.gph, replace) nodraw


qui reg votes_pct log_ballot_number log_number_of_candidates, vce(cluster province)

avplot log_ballot_number, ///
msymbol(smcircle_hollow) scheme(sj) graphregion(color(white)) ///
title("Controlled for Logged Ballot Length)", size(medium)) xtitle("Residualized Ballot Position (log)", size(medium) margin(medium)) ytitle("Residualized Pct. of Votes", size(medium) margin(medium)) ///
xlabel(,labsize(small)) ylabel(,labsize(small)) note("") ///
saving(lowess_w_kabul_avplot.gph, replace) nodraw


graph combine lowess_w_kabul.gph lowess_wo_kabul.gph lowess_w_kabul_und_med.gph lowess_w_kabul_avplot.gph, ///
graphregion(color(white)) title("Figure 1: Ballot Position and Vote Shares", size(medium)) ///
scheme(sj)

graph export combo_ballot.eps, fontface(times)  replace


****************************************
*MODELS REPORTED IN ANALYSIS
****************************************

*full sample

reg votes_pct ballot_number_pct , vce(cluster province)


*excluding Kabul

reg votes_pct ballot_number_pct if province != "Kabul", vce(cluster province)


*districts with ballot length below median

reg votes_pct ballot_number_pct  if number_of_candidates < 46, vce(cluster province)


*controlling for logged ballot length

reg votes_pct ballot_number_pct log_number_of_candidates, vce(cluster province)


*first candidates

reg votes_pct first log_number_of_candidates, vce(cluster province)


*top five

capture drop top_five
gen top_five = 0 if ballot_number != .
replace top_five = 1 if ballot_number <= 5

reg votes_pct top_five log_number_of_candidates, vce(cluster province)


*top ten

capture drop top_ten
gen top_ten = 0 if ballot_number != .
replace top_ten = 1 if ballot_number <= 10

reg votes_pct top_ten log_number_of_candidates, vce(cluster province)


**********************************************
*TESTING FOR MANIPULATION OF BALLOT POSITION
*********************************************

*men vs. women

reg ballot_number woman, vce(cluster province)



*the 24 missing winning candidates come from Nangerhar and Kuchi
*Kuchi is discarded from all models and for Nangerhar we couldn't find data on incumbency status

*elected incumbents vs. election non-incumbents

reg ballot_number incumbent, vce(cluster province)


***************************
*MAIN MODELS RUN AS TOBITS
***************************

*full sample

tobit votes_pct ballot_number_pct , vce(cluster province) ll(0) ul(100)



*excluding Kabul

tobit  votes_pct ballot_number_pct if province != "Kabul", vce(cluster province) ll(0) ul(100)



*districts with ballot length below median

tobit votes_pct ballot_number_pct  if number_of_candidates < 46, vce(cluster province) ll(0) ul(100)



*controlling for logged ballot length

tobit votes_pct ballot_number_pct log_number_of_candidates, vce(cluster province) ll(0) ul(100)


*first candidate

tobit  votes_pct first log_number_of_candidates, vce(cluster province) ll(0) ul(100)



*top five

capture drop top_five
gen top_five = 0 if ballot_number != .
replace top_five = 1 if ballot_number <= 5

tobit  votes_pct top_five log_number_of_candidates, vce(cluster province) ll(0) ul(100)



*top ten

capture drop top_ten
gen top_ten = 0 if ballot_number != .
replace top_ten = 1 if ballot_number <= 10

tobit  votes_pct top_ten log_number_of_candidates, vce(cluster province) ll(0) ul(100)




*************************
*ADDITIONAL TESTS
*************************

*logging vote share and including province fixed effects

capture drop province_num
encode province, gen(province_num)

capture drop votes_pct_log
gen votes_pct_log = ln(votes_pct)


reg votes_pct_log ballot_number_pct log_number_of_candidates i.province_num, vce(cluster province)
tobit votes_pct_log ballot_number_pct log_number_of_candidates i.province_num, vce(cluster province) ll(0) ul(100)

*dummies for each decile of the relative ballot position-variable

forvalues x = 10(10)100 {

	local y = `x'-10

	capture drop ballot_number_pct_dum_`y'_`x'
	qui gen ballot_number_pct_dum_`y'_`x' = .
	qui replace ballot_number_pct_dum_`y'_`x' = 1 if ballot_number_pct > `y' & ballot_number_pct <= `x'
	qui replace ballot_number_pct_dum_`y'_`x' = 0 if ballot_number_pct <= `y' | ballot_number_pct > `x'
	qui replace ballot_number_pct_dum_`y'_`x' = . if ballot_number_pct == .


}


reg votes_pct ballot_number_pct_dum_10_20 ballot_number_pct_dum_20_30 ballot_number_pct_dum_30_40 ///
ballot_number_pct_dum_40_50 ballot_number_pct_dum_50_60 ballot_number_pct_dum_60_70 ballot_number_pct_dum_70_80 ///
ballot_number_pct_dum_80_90 ballot_number_pct_dum_90_100  ///
log_number_of_candidates , vce(cluster province)

*as tobit

tobit votes_pct ballot_number_pct_dum_10_20 ballot_number_pct_dum_20_30 ballot_number_pct_dum_30_40 ///
ballot_number_pct_dum_40_50 ballot_number_pct_dum_50_60 ballot_number_pct_dum_60_70 ballot_number_pct_dum_70_80 ///
ballot_number_pct_dum_80_90 ballot_number_pct_dum_90_100  ///
log_number_of_candidates , vce(cluster province) ll(0) ul(100)


*with province fixed effects

reg votes_pct ballot_number_pct_dum_10_20 ballot_number_pct_dum_20_30 ballot_number_pct_dum_30_40 ///
ballot_number_pct_dum_40_50 ballot_number_pct_dum_50_60 ballot_number_pct_dum_60_70 ballot_number_pct_dum_70_80 ///
ballot_number_pct_dum_80_90 ballot_number_pct_dum_90_100  ///
log_number_of_candidates i.province_num, vce(cluster province)

*as tobit

tobit votes_pct ballot_number_pct_dum_10_20 ballot_number_pct_dum_20_30 ballot_number_pct_dum_30_40 ///
ballot_number_pct_dum_40_50 ballot_number_pct_dum_50_60 ballot_number_pct_dum_60_70 ballot_number_pct_dum_70_80 ///
ballot_number_pct_dum_80_90 ballot_number_pct_dum_90_100  ///
log_number_of_candidates i.province_num, vce(cluster province) ll(0) ul(100)


*with logged vote share

reg votes_pct_log ballot_number_pct_dum_10_20 ballot_number_pct_dum_20_30 ballot_number_pct_dum_30_40 ///
ballot_number_pct_dum_40_50 ballot_number_pct_dum_50_60 ballot_number_pct_dum_60_70 ballot_number_pct_dum_70_80 ///
ballot_number_pct_dum_80_90 ballot_number_pct_dum_90_100  ///
log_number_of_candidates i.province_num, vce(cluster province)


*as tobit

tobit votes_pct_log ballot_number_pct_dum_10_20 ballot_number_pct_dum_20_30 ballot_number_pct_dum_30_40 ///
ballot_number_pct_dum_40_50 ballot_number_pct_dum_50_60 ballot_number_pct_dum_60_70 ballot_number_pct_dum_70_80 ///
ballot_number_pct_dum_80_90 ballot_number_pct_dum_90_100  ///
log_number_of_candidates i.province_num, vce(cluster province) ll(0) ul(100)



*influential observationss for top ten-effect

capture drop top_ten
qui gen top_ten = 0 if ballot_number != .
qui replace top_ten = 1 if ballot_number <= 10

qui reg votes_pct top_ten log_number_of_candidates
capture drop top_ten_dfb
qui dfbeta top_ten, stub("top_ten_dfb")

*removing the 2 most influential obs.

*negatively 

sort top_ten_dfb
reg votes_pct top_ten log_number_of_candidates if _n > 2, vce(cluster province)


*positively 

gsort -top_ten_dfb
reg votes_pct top_ten log_number_of_candidates if _n > 2, vce(cluster province)


*interaction between ballot length and ballot position

*clean length

reg votes_pct c.ballot_number_pct##c.number_of_candidates, vce(cluster province)
tobit votes_pct c.ballot_number_pct##c.number_of_candidates, vce(cluster province) ll(0) ul(100)


*logged length

reg votes_pct c.ballot_number_pct##c.log_number_of_candidates, vce(cluster province)
tobit votes_pct c.ballot_number_pct##c.log_number_of_candidates, vce(cluster province) ll(0) ul(100)

*** Open dataset to replicate the experimental results [note: you should adjust the working directory appropriately]
capture cd "D:\Dropbox\Mexico Information Acquisition\Replication\"

use "ENCUP_Survey_Data.dta", clear



*** Table A6: Balance tests for upcoming local elections over 22 individual and municipal-level variables [balance test for political network scale is computed below over the imputed datasets]

eststo clear
quietly foreach y of varlist female indigenous_lang	 catholic age edu voted_since_2000_mayor media_in_muni PAN_gov PRI_gov PRD_gov {
	eststo, title("`y'") : areg `y' election i.year, cluster(state) a(state)
	sum `y' if e(sample)
	estadd scalar Outcome_Mean=`r(mean)'
	sum election if e(sample)
	estadd scalar Treatment_Mean=`r(mean)'
}
estout, cells(b(star fmt(3)) se(par)) stats(N r2 Outcome_Mean Treatment_Mean, fmt(0 2 2 2) label("Observations" "R$ ^2$" "Outcome mean" "Local election mean")) ///
	legend starlevels(* 0.1 ** 0.05 *** 0.01) keep(election) label varlabel(election "Upcoming local election")
estout, style(tex) cells(b(star fmt(3)) se(par)) stats(N r2 Outcome_Mean Treatment_Mean, fmt(0 2 2 2) label("Observations" "R$ ^2$" "Outcome mean" "Local election mean")) ///
	legend starlevels(* 0.1 ** 0.05 *** 0.01) keep(election) label varlabel(election "Upcoming local election")

eststo clear
quietly foreach y of varlist PAN_inc PRI_inc PRD_inc win_margin incumbent_win_lag mun_incumbent_vote_share_lag enpv_muni_lag mun_listanominal_lag total_muni_spending police_per_voter_lag homicides_year_ave {
	eststo, title("`y'") : areg `y' election i.year, cluster(state) a(state)
	sum `y' if e(sample)
	estadd scalar Outcome_Mean=`r(mean)'
	sum election if e(sample)
	estadd scalar Treatment_Mean=`r(mean)'
}
estout, cells(b(star fmt(3)) se(par)) stats(N r2 Outcome_Mean Treatment_Mean, fmt(0 2 2 2) label("Observations" "R$ ^2$" "Outcome mean" "Local election mean")) ///
	legend starlevels(* 0.1 ** 0.05 *** 0.01) keep(election) label varlabel(election "Upcoming local election")
estout, style(tex) cells(b(star fmt(3)) se(par)) stats(N r2 Outcome_Mean Treatment_Mean, fmt(0 2 2 2) label("Observations" "R$ ^2$" "Outcome mean" "Local election mean")) ///
	legend starlevels(* 0.1 ** 0.05 *** 0.01) keep(election) label varlabel(election "Upcoming local election")

  

*** Table A7: Predictors of municipalities included in each survey wave

preserve
use "Homicides 1990-2013 by month and municipality.dta", clear
g date = ym(year,month)
xtset uniqueid date, monthly
g homicides_lag = L1.homicides
g homicides_lag_2 = L2.homicides
g homicides_lead = F1.homicides
g homicides_lead_2 = F2.homicides
egen homicides_year_ave = filter(homicides), lags(2/12)
replace homicides_year_ave = homicides_year_ave / 11
egen homicides_3year_ave = filter(homicides), lags(2/36)
replace homicides_3year_ave = homicides_3year_ave / 35
save "merge.dta", replace
restore

preserve
drop if election==.
keep year state election
duplicates drop
save "Election.dta", replace
restore

preserve
drop election
duplicates drop uniqueid year, force
bysort uniqueid : g total = _N
g t = 1
replace t = 2 if year==2003
replace t = 3 if year==2005
replace t = 4 if year==2012
drop if year==2008
xtset uniqueid t
g surveyed = 1
tsfill, full
replace surveyed = 0 if state==.
replace year = 2001 if t==1
replace year = 2003 if t==2
replace year = 2005 if t==3
replace year = 2012 if t==4
replace month = 12 if t==1
replace month = 2 if t==2
replace month = 12 if t==3
replace month = 8 if t==4
merge m:1 uniqueid year month using "merge.dta", keepusing(homicides homicides_lag homicides_lag_2 homicides_lead homicides_lead_2 homicides_year_ave homicides_3year_ave) update
drop if _merge==2
drop _merge
replace some = homicides>0 | homicides_lag>0 if homicides!=. & homicides_lag!=.
replace state = floor(uniqueid/1000) if state==.
merge m:1 state year using "Election.dta"
drop _merge
eststo clear
foreach x of varlist election some homicides_year_ave homicides_3year_ave {
	eststo, title("surveyed") : areg surveyed `x' i.year, cluster(state) a(uniqueid)
	sum surveyed if e(sample)
	estadd scalar Outcome_Mean=`r(mean)'
}
estout, cells(b(star fmt(3)) se(par)) stats(N r2 Outcome_Mean, fmt(0 2 2)  label("Observations" "R$ ^2$" "Surveyed mean")) ///
	legend starlevels(* 0.1 ** 0.05 *** 0.01) keep(election some homicides_year_ave homicides_3year_ave) label ///
	varlabel(election "Upcoming local election" some "Homicide in last month" homicides_year_ave "Homicides per month (last year)" homicides_3year_ave "Homicides per month (last 3 years)")
estout, style(tex) cells(b(star fmt(3)) se(par)) stats(N r2 Outcome_Mean, fmt(0 2 2) label("Observations" "R$ ^2$" "Surveyed mean")) ///
	legend starlevels(* 0.1 ** 0.05 *** 0.01) keep(election some homicides_year_ave homicides_3year_ave) label ///
	varlabel(election "Upcoming local election" some "Homicide in last month" homicides_year_ave "Homicides per month (last year)" homicides_3year_ave "Homicides per month (last 3 years)")
restore

erase "Election.dta"
erase "merge.dta"


  
*** Table 4: Difference-in-differences estimates of the effect of upcoming local elections on information acquisition, by political network engagement
*** Table 5: Robustness and alternative interpretation checks of difference-in-differences estimates
*** Table A8: Difference-in-differences estimates of the effect of upcoming local elections on news consumption intensity, by political network engagement
*** Table A9: Difference-in-differences estimates of the effect of upcoming local elections on information acquisition, by quadratic political network engagement

* Note: to replicate the paper's results, the seed below must be the first set during the user's Stata session (although differences across imputations are minor)

** DD interaction with political organization participation (imputed political network scale) - consumption outcomes
preserve
set matsize 10000
drop if listen_watch_politics_ever==.
mi set wide
mi xtset, clear
* Impute variables to create politically-oriented networks index
mi register imputed talk_comm_problems cooperative_org party_org
xi: mi impute mvn talk_comm_problems cooperative_org party_org = i.year i.uniqueid female age indigenous catholic, add(10) force rseed(123456789)
mi passive: egen number_political = rowtotal(political_org party_org cooperative_org)
mi passive: egen meetings_political = rowtotal(political_or_party_meeting comm_coop_meeting)
foreach x of varlist number_political meetings_political talk_comm_problems {
	mi passive : egen `x'_std = std(`x')
	drop `x'
	rename `x'_std `x'
}
mi passive : g political_network_scale = (number_political + meetings_political + talk_comm_problems)/3
mi passive : egen political_network_scale_std = std(political_network_scale)
drop political_network_scale
rename political_network_scale_std political_network_scale
sum political_network_scale
label var political_network_scale "Political network scale"
* Balance test in subsample
mi estimate : areg political_network_scale election i.year, cluster(state) a(state)
* Tables 4 and A8 (half the point estimates; more in the next loop)
eststo clear
quietly foreach y in listen_watch_politics_ever listen_watch_politics_monthly listen_watch_politics_weekly listen_watch_politics_daily listen_watch_politics_scale {
	eststo, title("`y'") : mi estimate, post : areg `y' election##c.political_network_scale i.year, cluster(state) a(state)
	sum `y'
	estadd scalar Outcome_Mean=`r(mean)'
	estadd scalar Outcome_SD=`r(sd)'
	sum election
	estadd scalar Election_Mean=`r(mean)'
	sum political_network_scale
	estadd scalar Network_Mean=`r(mean)'
	estadd scalar Network_SD=`r(sd)'
	matrix A = e(V)
	twoway (function y = _b[1.election] + _b[1.election#c.political_network_scale] * x, range(-0.99 4.02) lcolor(black) lwidth(thick)) ///
		(function y = _b[1.election] + _b[1.election#c.political_network_scale] * x + 1.96 * (A[2,2] + A[5,5] * x^2 + A[2,5] * 2 * x)^0.5, range(-0.99 4.02) lwidth(medthick) lcolor(black) lpattern(dash) ) ///
		(function y = _b[1.election] + _b[1.election#c.political_network_scale] * x - 1.96 * (A[2,2] + A[5,5] * x^2 + A[2,5] * 2 * x)^0.5, range(-0.99 4.02) lwidth(medthick) lcolor(black) lpattern(dash)) ///
		, yline(0, lpattern(dash) lcolor(black)) legend(off) ylabel(, nogrid) ytitle("Marginal effect") title("`y'", color(black)) ///
		xtitle("Political network scale") subtitle(, color(black) fcolor(white) lcolor(white)) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
	graph save Graph "g_`y'.gph", replace
}
* Outout for Table A8
estout, cells(b(star fmt(3)) se(par)) stats(N Outcome_Mean Outcome_SD Election_Mean Network_Mean Network_SD, fmt(0 2 2 2 2 2 2)  label("Observations" "Outcome mean" "Outcome std. dev." "Upcoming local election mean" ///
	"Political network scale mean" "Political network scale std. dev.")) legend starlevels(* 0.1 ** 0.05 *** 0.01) keep(1.election* political_network_scale) label ///
	varlabel(1.election "Upcoming local election" political_network_scale "Political network scale" 1.election#c.political_network_scale "Upcoming local election $ \times$ Political network scale")
estout, style(tex) cells(b(star fmt(3)) se(par)) stats(N Outcome_Mean Outcome_SD Election_Mean Network_Mean Network_SD, fmt(0 2 2 2 2 2 2)  label("Observations" "Outcome mean" "Outcome std. dev." "Upcoming local election mean" ///
	"Political network scale mean" "Political network scale std. dev.")) legend starlevels(* 0.1 ** 0.05 *** 0.01) keep(1.election* political_network_scale) label ///
	varlabel(1.election "Upcoming local election" political_network_scale "Political network scale" 1.election#c.political_network_scale "Upcoming local election $ \times$ Political network scale")
* Table 5 panel A (half the point estimates; more in the next loop)
foreach y in listen_watch_politics_ever listen_watch_politics_scale {
	mi estimate : areg `y' election##c.political_network_scale c.year##i.state, cluster(state) a(state)
}
* Table 5 panel B (half the point estimates; more in the next loop)
foreach y in listen_watch_politics_ever listen_watch_politics_scale {
	mi estimate : areg `y' election##c.political_network_scale c.year##i.state##c.political_network_scale, cluster(state) a(state)
}
* Table 5 panels D-H (half the point estimates; more in the next loop)
foreach y in listen_watch_politics_ever listen_watch_politics_scale {
	foreach x in win_margin_lag enpv_muni_lag edu voted_since_2000_mayor media_in_muni {
		mi estimate : areg `y' election##c.political_network_scale election##c.`x' i.year, cluster(state) a(state)
	}
}
* Table 5 panel I (half the point estimates; more in the next loop)
foreach y in listen_watch_politics_ever listen_watch_politics_scale {
	mi estimate : areg `y' election##c.political_network_scale i.year if party_org==0 & political_org==0, cluster(state) a(state)
}
* Table A9 Column (1)
mi estimate : areg listen_watch_politics_scale election##c.political_network_scale##c.political_network_scale i.year, cluster(state) a(state)
* Summary statistics
sum win_margin_lag enpv_muni_lag voted_since_2000_mayor media_in_muni female age if listen_watch_politics_scale!=.
restore


** DD interaction with political organization participation (imputed political network scale) - political knowledge outcomes
preserve
set matsize 10000
mi set wide
mi xtset, clear
* Impute variables to create politically-oriented networks index
mi register imputed talk_comm_problems cooperative_org party_org
xi: mi impute mvn talk_comm_problems cooperative_org party_org = i.year i.uniqueid female age catholic indigenous, add(10) force rseed(123456789)
mi passive: egen number_political = rowtotal(political_org party_org cooperative_org)
mi passive: egen meetings_political = rowtotal(political_or_party_meeting comm_coop_meeting)
foreach x of varlist number_political meetings_political talk_comm_problems {
	egen `x'_std = std(`x')
	drop `x'
	rename `x'_std `x'
}
mi passive : g political_network_scale = (number_political + meetings_political + talk_comm_problems)/3
mi passive : egen political_network_scale_std = std(political_network_scale)
drop political_network_scale
rename political_network_scale_std political_network_scale
sum political_network_scale
label var political_network_scale "Political network scale"
* Balance test for Table A6
mi estimate : areg political_network_scale election i.year, cluster(state) a(state)
* Tables 4 (half the point estimates; more in the previous loop)
foreach y in info_topical info_inst {
	mi estimate, post : areg `y' election##c.political_network_scale i.year, cluster(state) a(state)
	matrix A = e(V)
	twoway (function y = _b[1.election] + _b[1.election#c.political_network_scale] * x, range(-0.82 4.63) lcolor(black) lwidth(thick)) ///
		(function y = _b[1.election] + _b[1.election#c.political_network_scale] * x + 1.96 * (A[2,2] + A[5,5] * x^2 + A[2,5] * 2 * x)^0.5, range(-0.82 4.63) lwidth(medthick) lcolor(black) lpattern(dash) ) ///
		(function y = _b[1.election] + _b[1.election#c.political_network_scale] * x - 1.96 * (A[2,2] + A[5,5] * x^2 + A[2,5] * 2 * x)^0.5, range(-0.82 4.63) lwidth(medthick) lcolor(black) lpattern(dash)) ///
		, yline(0, lpattern(dash) lcolor(black)) legend(off) ylabel(, nogrid) ytitle("Marginal effect") title("`y'", color(black)) ///
		xtitle("Political network scale") subtitle(, color(black) fcolor(white) lcolor(white)) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
	graph save Graph "g_`y'.gph", replace
}
* Table 5 panel A (half the point estimates; more in the previous loop)
mi estimate : areg info_topical election##c.political_network_scale c.year##i.state, cluster(state) a(state)
* Table 5 panel B (half the point estimates; more in the previous loop)
mi estimate : areg info_topical election##c.political_network_scale c.year##i.state##c.political_network_scale, cluster(state) a(state)
* Table 5 panels D-H (half the point estimates; more in the previous loop)
foreach x in win_margin_lag enpv_muni_lag edu voted_since_2000_mayor media_in_muni {
	mi estimate : areg info_topical election##c.political_network_scale election##c.`x' i.year, cluster(state) a(state)
}
* Table 5 panel I (half the point estimates; more in the previous loop)
mi estimate : areg info_topical election##c.political_network_scale i.year if party_org==0 & political_org==0, cluster(state) a(state)
* Table A9 Column (2)
mi estimate : areg info_topical election##c.political_network_scale##c.political_network_scale i.year, cluster(state) a(state)
* Summary statistics
sum win_margin_lag enpv_muni_lag voted_since_2000_mayor media_in_muni female age if info_topical!=.
restore



*** Figure 1: Marginal effect of upcoming local elections on information acquisition, by political network engagement

graph combine "g_listen_watch_politics_ever" "g_listen_watch_politics_scale" "g_info_topical" "g_info_inst", rows(2) cols(2) subtitle(, color(black) fcolor(white) lcolor(white)) ///
	graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
erase "g_listen_watch_politics_ever.gph"
erase "g_listen_watch_politics_monthly.gph"
erase "g_listen_watch_politics_weekly.gph"
erase "g_listen_watch_politics_daily.gph"
erase "g_listen_watch_politics_scale.gph"
erase "g_info_topical.gph"
erase "g_info_inst.gph"



*** Table 5: Robustness and alternative interpretation checks of difference-in-differences estimates --- panel C only

egen number_civic = rowtotal(pensioners_org professional_org social_org voluntary_org religion_org neighbor_org cultural_org sport_org parents_org)
egen meetings_civic = rowtotal(help_meeting parents_assoc_meeting religious_meeting festival_org_meeting savings_meeting local_meeting)
alpha meetings_civic number_civic, g(civic_network_scale_unstd) std
egen civic_network_scale = std(civic_network_scale_unstd)
drop civic_network_scale_unstd
label var civic_network_scale "Civic network scale"
eststo clear
quietly foreach y in listen_watch_politics_ever listen_watch_politics_scale info_topical {
	eststo, title("`y'"): areg `y' election##c.civic_network_scale i.year, cluster(uniqueid) a(state)
	sum `y' if e(sample)
	estadd scalar Outcome_Mean=`r(mean)'
	sum election if e(sample)
	estadd scalar Treatment_Mean=`r(mean)'
	sum civic_network_scale if e(sample)
	estadd scalar Treatment2_Mean=`r(mean)'
	estadd scalar Treatment2_SD=`r(sd)'
}
estout, cells(b(star fmt(3)) se(par)) stats(N r2 Outcome_Mean Treatment_Mean Treatment2_Mean Treatment2_SD, fmt(0 2 2 2 2 2) label("Observations" "R$ ^2$" "Outcome mean" "Local election mean" "Civic network scale mean" "Civic network scale standard deviation")) ///
	legend starlevels(* 0.1 ** 0.05 *** 0.01) keep(1.election 1.election#c.civic_network_scale civic_network_scale) label varlabel(1.election "Upcoming local election" civic_network_scale "Civic network scale" 1.election#c.civic_network_scale "Local election $ \times$ Civic network scale")
estout, style(tex) cells(b(star fmt(3)) se(par)) stats(N r2 Outcome_Mean Treatment_Mean Treatment2_Mean Treatment2_SD, fmt(0 2 2 2 2 2) label("Observations" "R$ ^2$" "Outcome mean" "Local election mean" "Civic network scale mean" "Civic network scale standard deviation")) ///
	legend starlevels(* 0.1 ** 0.05 *** 0.01) keep(1.election 1.election#c.civic_network_scale civic_network_scale) label varlabel(1.election "Upcoming local election" civic_network_scale "Civic network scale" 1.election#c.civic_network_scale "Local election $ \times$ Civic network scale")

  

*** Table A10: Sensitivity of difference-in-differences estimates to definition of upcoming local election

* Panels A and B
preserve
set matsize 10000
drop if listen_watch_politics_ever==.
mi set wide
mi xtset, clear
mi register imputed talk_comm_problems cooperative_org party_org
xi: mi impute mvn talk_comm_problems cooperative_org party_org = i.year i.uniqueid female age indigenous catholic, add(10) force rseed(123456789)
mi passive: egen number_political = rowtotal(political_org party_org cooperative_org)
mi passive: egen meetings_political = rowtotal(political_or_party_meeting comm_coop_meeting)
foreach x of varlist number_political meetings_political talk_comm_problems {
	mi passive : egen `x'_std = std(`x')
	drop `x'
	rename `x'_std `x'
}
mi passive : g political_network_scale = (number_political + meetings_political + talk_comm_problems)/3
mi passive : egen political_network_scale_std = std(political_network_scale)
drop political_network_scale
rename political_network_scale_std political_network_scale
quietly foreach y of varlist listen_watch_politics_ever listen_watch_politics_scale {
	eststo clear
	eststo, title("`y'") : mi estimate, post : areg `y' c.months_til_election##c.political_network_scale i.year, cluster(state) a(state)
	foreach n of numlist 1/10 {
		g dummy = months<=`n' if months!=.
		eststo, title("`y'") : mi estimate, post : areg `y' dummy##c.political_network_scale i.year, cluster(state) a(state)
		drop dummy
	}
	di "*********** Outcome = `y' *************"
	noisily estout, cells(b(star fmt(3)) se(par)) stats(N, fmt(0 2 2 2 2 2 2)  label("Observations")) legend starlevels(* 0.1 ** 0.05 *** 0.01) keep(1.dummy* *months_til_election* political_network_scale) label ///
		varlabel(1.dummy "Upcoming local election measure" political_network_scale "Political network scale" 1.dummy#c.political_network_scale "Upcoming local election measure $ \times$ Political network scale" ///
		months_til_election "Months until election" c.months_til_election#c.political_network_scale "Months until election $ \times$ Political network scale")
	noisily estout, style(tex) cells(b(star fmt(3)) se(par)) stats(N, fmt(0 2 2 2 2 2 2)  label("Observations")) legend starlevels(* 0.1 ** 0.05 *** 0.01) keep(1.dummy* *months_til_election* political_network_scale) label ///
		varlabel(1.dummy "Upcoming local election measure" political_network_scale "Political network scale" 1.dummy#c.political_network_scale "Upcoming local election measure $ \times$ Political network scale" ///
		months_til_election "Months until election" c.months_til_election#c.political_network_scale "Months until election $ \times$ Political network scale")
}
restore

* Panel C
preserve
set matsize 10000
mi set wide
mi xtset, clear
mi register imputed talk_comm_problems cooperative_org party_org
xi: mi impute mvn talk_comm_problems cooperative_org party_org = i.year i.uniqueid female age indigenous catholic, add(10) force rseed(123456789)
mi passive: egen number_political = rowtotal(political_org party_org cooperative_org)
mi passive: egen meetings_political = rowtotal(political_or_party_meeting comm_coop_meeting)
foreach x of varlist number_political meetings_political talk_comm_problems {
	mi passive : egen `x'_std = std(`x')
	drop `x'
	rename `x'_std `x'
}
mi passive : g political_network_scale = (number_political + meetings_political + talk_comm_problems)/3
mi passive : egen political_network_scale_std = std(political_network_scale)
drop political_network_scale
rename political_network_scale_std political_network_scale
quietly {
	eststo clear
	eststo, title("info_topical") : mi estimate, post : areg info_topical c.months_til_election##c.political_network_scale i.year, cluster(state) a(state)
	foreach n of numlist 1/10 {
		g dummy = months<=`n' if months!=.
		eststo, title("info_topical") : mi estimate, post : areg info_topical dummy##c.political_network_scale i.year, cluster(state) a(state)
		drop dummy
	}
}
di "*********** Outcome = info_topical *************"
noisily estout, cells(b(star fmt(3)) se(par)) stats(N, fmt(0 2 2 2 2 2 2)  label("Observations")) legend starlevels(* 0.1 ** 0.05 *** 0.01) keep(1.dummy* *months_til_election* political_network_scale) label ///
	varlabel(1.dummy "Upcoming local election measure" political_network_scale "Political network scale" 1.dummy#c.political_network_scale "Upcoming local election measure $ \times$ Political network scale" ///
	months_til_election "Months until election" c.months_til_election#c.political_network_scale "Months until election $ \times$ Political network scale")
noisily estout, style(tex) cells(b(star fmt(3)) se(par)) stats(N, fmt(0 2 2 2 2 2 2)  label("Observations")) legend starlevels(* 0.1 ** 0.05 *** 0.01) keep(1.dummy* *months_til_election* political_network_scale) label ///
	varlabel(1.dummy "Upcoming local election measure" political_network_scale "Political network scale" 1.dummy#c.political_network_scale "Upcoming local election measure $ \times$ Political network scale" ///
	months_til_election "Months until election" c.months_til_election#c.political_network_scale "Months until election $ \times$ Political network scale")
restore
  

  
log close

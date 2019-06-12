clear
log using "log.txt", text replace

***Table 1***
clear
set more off
use "CatalistCleaned.dta"
areg voted2012 battleground [fw = pop] if bg_sample == 1, a(mediamarket) cluster(state)
xi:areg voted2012 battleground male female white black asian hispanic i.income [fw = pop] if bg_sample == 1, a(mediamarket) cluster(state)
xi:areg voted2012 battleground voted2010 male female white black asian hispanic i.income [fw = pop] if bg_sample == 1, a(mediamarket) cluster(state)
areg voted2012 tier1 tier2 tier3 [fw = pop] if tier_sample == 1, a(mediamarket) cluster(state)
xi:areg voted2012 tier1 tier2 tier3 male female white black asian hispanic i.income [fw = pop] if tier_sample == 1, a(mediamarket) cluster(state)
xi:areg voted2012 tier1 tier2 tier3 voted2010 male female white black asian hispanic i.income [fw = pop] if tier_sample == 1, a(mediamarket) cluster(state)
areg voted2012 romney_effort [fw = pop] if re_sample == 1, a(mediamarket) cluster(state)
xi:areg voted2012 romney_effort male female white black asian hispanic i.income [fw = pop] if re_sample == 1, a(mediamarket) cluster(state)
xi:areg voted2012 romney_effort voted2010 male female white black asian hispanic i.income [fw = pop] if re_sample == 1, a(mediamarket) cluster(state)
*extra robustness tests (not in Table 1 but described in text)
*controlling for toss-up senatorial or gubernatorial race
g senate_guber = state == "IN" | state == "MA" | state == "MT" | state == "NV" | state == "ND" | state == "VA" | state == "WI" | state == "WA"
xi:areg voted2012 romney_effort senate_guber [fw = pop] if re_sample == 1, a(mediamarket) cluster(state)
*controlling for voting laws
g votemethods = 0
replace votemethods = 1 if state == "WA" | state == "OR" | state == "CO"
replace votemethods = 2 if state == "MN"
replace votemethods = 3 if state == "TX" | state == "LA" | state == "AR" | state == "TN" | state == "WV" | state == "IN"
replace votemethods = 4 if state == "MS" | state == "AL" | state == "SC" | state == "VA" | state == "KY" | state == "MO" ///
| state == "MI" | state == "PA" | state == "DE" | state == "MA" | state == "NH" | state == "CT" | state == "RI" ///
| state == "NY"
xi:areg voted2012 romney_effort i.votemethods [fw = pop] if re_sample == 1, a(mediamarket) cluster(state)


***estimating the number of individuals mobilized***
clear
set more off
use "VEP.dta"
sort state
merge state using "RomneyEffort.dta"
tab _merge
drop _merge
g mobilized = .078*romney_effort*vep
sum mobilized
disp r(sum)


***Figure 2*** 
clear
set more off
use "CatalistCleaned.dta"
keep if re_sample == 1
g state_mediamarket = state + "_" + mediamarket
g votes = voted2012*pop
egen totalvotes = sum(votes), by(state_mediamarket)
egen totalpop = sum(pop), by(state_mediamarket)
g turnout = totalvotes/totalpop
keep state mediamarket state_mediamarket turnout totalpop romney_effort
sort state_mediamarket
drop if state_mediamarket == state_mediamarket[_n-1]
drop state_mediamarket
sort mediamarket romney_effort state
forvalues i = 1/3 {
g dyad`i' = state + "_" + state[_n+`i'] + "_" + mediamarket if mediamarket == mediamarket[_n+`i'] & romney_effort != romney_effort[_n+`i']
g effort_difference`i' = romney_effort[_n+`i'] - romney_effort if dyad`i' != ""
g turnout_difference`i' = turnout[_n+`i'] - turnout if dyad`i' != ""
g minpop`i' = min(totalpop, totalpop[_n+`i']) if dyad`i' != ""
}
keep *1 *2 *3
drop if dyad1 == "" & dyad2 == "" & dyad3 == ""
g id = _n
reshape long dyad effort_difference turnout_difference minpop, i(id) j(series)
drop if dyad == ""
drop id series
g states = substr(dyad, 1, 5)
g negminpop = -minpop
sort negminpop
graph twoway (scatter turnout_difference effort_difference [w = minpop]) (lfit turnout_difference effort_difference [aw = minpop]) (lpoly turnout_difference effort_difference [aw = minpop], bw(.12)) 
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .xaxis1.title.text = {}
gr_edit .xaxis1.title.text.Arrpush Effort Differential
gr_edit .yaxis1.title.text = {}
gr_edit .yaxis1.title.text.Arrpush Turnout Differential
gr_edit .style.editstyle margin(vsmall) editcopy
gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit .style.editstyle boxstyle(linestyle(color(white))) editcopy
gr_edit .yaxis1.style.editstyle majorstyle(gridstyle(linestyle(color(white)))) editcopy
gr_edit .plotregion1.plot1.style.editstyle marker(size(vsmall)) editcopy
gr_edit .plotregion1.plot1.style.editstyle marker(fillcolor(white)) editcopy
gr_edit .plotregion1.plot1.style.editstyle marker(linestyle(color(black))) editcopy
gr_edit .plotregion1.plot1.style.editstyle marker(linestyle(width(medthick))) editcopy
gr_edit .plotregion1.plot2.style.editstyle line(color(black)) editcopy
gr_edit .plotregion1.plot2.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(color(black)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(medthick)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(pattern(dash)) editcopy
gr_edit .yaxis1.style.editstyle majorstyle(tickangle(horizontal)) editcopy
gr_edit .xaxis1.title.style.editstyle margin(vsmall) editcopy
graph save "Figure2.gph", replace


***Figure 3***
clear
set more off
use "CatalistCleaned.dta"
sum p_party [fw = pop], d
g p_party_category = 1 
replace p_party_category = 2 if p_party > r(p10)
replace p_party_category = 3 if p_party > r(p25)
replace p_party_category = 4 if p_party >= r(p50)
replace p_party_category = 5 if p_party >= r(p75)
replace p_party_category = 6 if p_party >= r(p90)
matrix B = J(6, 4, .)
forvalues i = 1/6 {
areg voted2012 romney_effort [fw = pop] if p_party_category == `i', a(mediamarket) cluster(mediamarket)
matrix B[`i',1] = _b[romney_effort]
matrix B[`i',2] = _b[romney_effort] + 1.96*_se[romney_effort]
matrix B[`i',3] = _b[romney_effort] - 1.96*_se[romney_effort]
matrix B[`i',4] = `i'
}
svmat B
graph twoway line B*
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .xaxis1.title.text = {}
gr_edit .xaxis1.title.text.Arrpush Predicted Partisanship
gr_edit .style.editstyle margin(tiny) editcopy
gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit .style.editstyle boxstyle(linestyle(color(white))) editcopy
gr_edit .yaxis1.title.text = {}
gr_edit .yaxis1.title.text.Arrpush RomneyEffort Coefficient
gr_edit .yaxis1.style.editstyle majorstyle(gridstyle(linestyle(color(white)))) editcopy
gr_edit .plotregion1.plot1.style.editstyle line(color(black)) editcopy
gr_edit .plotregion1.plot1.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot2.style.editstyle line(color(black)) editcopy
gr_edit .plotregion1.plot2.style.editstyle line(pattern(dot)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(color(black)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(pattern(dot)) editcopy
gr_edit .yaxis1.reset_rule 0 .15 .05 , tickset(major) ruletype(range) 
gr_edit .xaxis1.add_ticks 1 `"<.36"', tickset(major)
gr_edit .xaxis1.add_ticks 2 `".36-.45"', tickset(major)
gr_edit .xaxis1.add_ticks 3 `".45-.52"', tickset(major)
gr_edit .xaxis1.add_ticks 4 `".52-.54"', tickset(major)
gr_edit .xaxis1.add_ticks 5 `".54-.73"', tickset(major)
gr_edit .xaxis1.add_ticks 6 `">.73"', tickset(major)
gr_edit .xaxis1.plotregion.xscale.curmax = 6.1
gr_edit .yaxis1.style.editstyle majorstyle(tickangle(horizontal)) editcopy
gr_edit .xaxis1.title.style.editstyle margin(vsmall) editcopy
graph save "Figure3.gph", replace


***Figure 4***
clear
set more off
use "HistoricalAnalysis_1980_2012.dta"
replace turnout = turnout/100
*identify 5 most pivotal states in each election
sort year voteshare
g cumulative = ev if year != year[_n-1]
replace cumulative = cumulative[_n-1] + ev if year == year[_n-1]
g cutpoint = cumulative > 269
g pivotal = cutpoint == 1 & cutpoint[_n-1] == 0
replace pivotal = 1 if cutpoint[_n-1] == 1 & cutpoint[_n-2] == 0
replace pivotal = 1 if cutpoint[_n-2] == 1 & cutpoint[_n-3] == 0
replace pivotal = 1 if cutpoint[_n+1] == 1 & cutpoint == 0
replace pivotal = 1 if cutpoint[_n+2] == 1 & cutpoint[_n+1] == 0
drop cumulative cutpoint
forvalues i = 1980(4)2012 {
g pivotal_`i' = 0
replace pivotal_`i' = 1 if pivotal == 1 & year == `i'
}
xi:areg turnout pivotal_* i.year, a(state) cluster(state)
matrix B = J(9, 4, .)
forvalues i = 1980(4)2012 {
local j = (`i' - 1976)/4
matrix B[`j',1] = _b[pivotal_`i']
matrix B[`j',2] = _b[pivotal_`i'] + 1.96*_se[pivotal_`i']
matrix B[`j',3] = _b[pivotal_`i'] - 1.96*_se[pivotal_`i']
matrix B[`j',4] = `i'
}
svmat B
graph twoway line B*
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .xaxis1.title.text = {}
gr_edit .xaxis1.title.text.Arrpush Year
gr_edit .style.editstyle margin(tiny) editcopy
gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit .style.editstyle boxstyle(linestyle(color(white))) editcopy
gr_edit .yaxis1.title.text = {}
gr_edit .yaxis1.title.text.Arrpush Estimated Campaign Effect
gr_edit .yaxis1.style.editstyle majorstyle(gridstyle(linestyle(color(white)))) editcopy
gr_edit .plotregion1.plot1.style.editstyle line(color(black)) editcopy
gr_edit .plotregion1.plot1.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot2.style.editstyle line(color(black)) editcopy
gr_edit .plotregion1.plot2.style.editstyle line(pattern(dot)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(color(black)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(pattern(dot)) editcopy
gr_edit .yaxis1.reset_rule -.02 .08 .02 , tickset(major) ruletype(range) 
gr_edit .xaxis1.reset_rule 1980 2012 4, tickset(major) ruletype(range)
gr_edit .xaxis1.plotregion.xscale.curmax = 2012.5
gr_edit .yaxis1.style.editstyle majorstyle(tickangle(horizontal)) editcopy
gr_edit .xaxis1.title.style.editstyle margin(vsmall) editcopy
graph save "Figure4.gph", replace


***Table A2***
clear
set more off
use "CatalistCleaned.dta"
g senate2010 = state == "CA" | state == "CO" | state == "IL" | state == "NV" | state == "PA" | state == "WA" | state == "WV"
g guber2010 = state == "CO" | state == "CT" | state == "FL" | state == "HI" | state == "IL" | state == "MA" ///
| state == "MN" | state == "OH" | state == "OR" | state == "RI" | state == "VT" 
g sen_gov_2010 = max(senate2010, guber2010)
areg voted2010 battleground [fw = pop] if bg_sample == 1, a(mediamarket) cluster(state)
xi:areg voted2010 battleground male female white black asian hispanic i.income [fw = pop] if bg_sample == 1, a(mediamarket) cluster(state)
xi:areg voted2010 battleground male female white black asian hispanic i.income sen_gov_2010 [fw = pop] if bg_sample == 1, a(mediamarket) cluster(state)
areg voted2010 tier1 tier2 tier3 [fw = pop] if tier_sample == 1, a(mediamarket) cluster(state)
xi:areg voted2010 tier1 tier2 tier3 male female white black asian hispanic i.income [fw = pop] if tier_sample == 1, a(mediamarket) cluster(state)
xi:areg voted2010 tier1 tier2 tier3 male female white black asian hispanic i.income sen_gov_2010 [fw = pop] if tier_sample == 1, a(mediamarket) cluster(state)
areg voted2010 romney_effort [fw = pop] if re_sample == 1, a(mediamarket) cluster(state)
xi:areg voted2010 romney_effort male female white black asian hispanic i.income [fw = pop] if re_sample == 1, a(mediamarket) cluster(state)
xi:areg voted2010 romney_effort male female white black asian hispanic i.income sen_gov_2010 [fw = pop] if re_sample == 1, a(mediamarket) cluster(state)


***Tables A3, A4, and A5***
clear
set more off
use "CCAP2012.dta"
egen week = group(period)
rename inputstate state
keep if week <= 16
g age = 2012 - birthyr
replace race = 5 if race > 5
g female = gender == 2
g battleground = state == 8 | state == 12 | state == 19 | state == 32 | state == 33 | state == 37 | state == 39 | state == 51 | state == 55
rename state statecode
sort statecode
merge statecode using "Statecodes_CCAP.dta"
tab _merge
drop _merge
sort state
merge state using "RomneyEffort.dta"
tab _merge
drop _merge
g tier1 = state == "CO" | state == "IA" | state == "NV" | state == "NH" | state == "OH" | state == "VA"
g tier2 = state == "PA" | state == "FL" | state == "NC"
g tier3 = state == "WI" | state == "MN" | state == "WA" | state == "OR" | state == "MI" | state == "NM" 
g earlyprimary = state == "IA" | state == "NH" | state == "SC" | state == "FL" | state == "NV" | state == "CO" ///
| state == "MO" | state == "MN" | state == "ME" | state == "AZ" | state == "MI" | state == "WY" | state == "WA"
g interest = pp_polinterest == 1
g willnotvote = pp_vote_generic == 5
g plan_dem_rep = pp_vote_generic == 1 | pp_vote_generic == 2
keep state battleground tier* interest willnotvote plan_dem_rep week female race age earlyprimary romney_effort
*Table A3
areg interest battleground, a(week) cluster(state)
xi:areg interest battleground female i.race i.age, a(week) cluster(state)
xi:areg interest battleground earlyprimary female i.race i.age, a(week) cluster(state)
areg interest tier*, a(week) cluster(state)
xi:areg interest tier* female i.race i.age, a(week) cluster(state)
xi:areg interest tier* earlyprimary female i.race i.age, a(week) cluster(state)
areg interest romney_effort, a(week) cluster(state)
xi:areg interest romney_effort female i.race i.age, a(week) cluster(state)
xi:areg interest romney_effort earlyprimary female i.race i.age, a(week) cluster(state)
*Table A4
areg willnotvote battleground, a(week) cluster(state)
xi:areg willnotvote battleground female i.race i.age, a(week) cluster(state)
xi:areg willnotvote battleground earlyprimary female i.race i.age, a(week) cluster(state)
areg willnotvote tier*, a(week) cluster(state)
xi:areg willnotvote tier* female i.race i.age, a(week) cluster(state)
xi:areg willnotvote tier* earlyprimary female i.race i.age, a(week) cluster(state)
areg willnotvote romney_effort, a(week) cluster(state)
xi:areg willnotvote romney_effort female i.race i.age, a(week) cluster(state)
xi:areg willnotvote romney_effort earlyprimary female i.race i.age, a(week) cluster(state)
*Table A5
areg plan_dem_rep battleground, a(week) cluster(state)
xi:areg plan_dem_rep battleground female i.race i.age, a(week) cluster(state)
xi:areg plan_dem_rep battleground earlyprimary female i.race i.age, a(week) cluster(state)
areg plan_dem_rep tier*, a(week) cluster(state)
xi:areg plan_dem_rep tier* female i.race i.age, a(week) cluster(state)
xi:areg plan_dem_rep tier* earlyprimary female i.race i.age, a(week) cluster(state)
areg plan_dem_rep romney_effort, a(week) cluster(state)
xi:areg plan_dem_rep romney_effort female i.race i.age, a(week) cluster(state)
xi:areg plan_dem_rep romney_effort earlyprimary female i.race i.age, a(week) cluster(state)


***Table A6***
clear
set more off
use "CatalistCleaned.dta"
g income100 = income >= 100
g income40 = income >= 40
g income20 = income >= 20
egen id = group(male female white black asian hispanic income)
egen totalpop = sum(pop), by(id)
g votes = voted2012*pop
egen totalvotes = sum(votes), by(id)
g votepropensity = totalvotes/totalpop
areg female romney_effort [fw = pop] if re_sample == 1, a(mediamarket) cluster(state)
areg white romney_effort [fw = pop] if re_sample == 1, a(mediamarket) cluster(state)
areg black romney_effort [fw = pop] if re_sample == 1, a(mediamarket) cluster(state)
areg hispanic romney_effort [fw = pop] if re_sample == 1, a(mediamarket) cluster(state)
areg asian romney_effort [fw = pop] if re_sample == 1, a(mediamarket) cluster(state)
areg income20 romney_effort [fw = pop] if re_sample == 1, a(mediamarket) cluster(state)
areg income40 romney_effort [fw = pop] if re_sample == 1, a(mediamarket) cluster(state)
areg income100 romney_effort [fw = pop] if re_sample == 1, a(mediamarket) cluster(state)
areg votepropensity romney_effort [fw = pop] if re_sample == 1, a(mediamarket) cluster(state)


***Table A8***
clear
set more off
use "CatalistCleaned.dta"
sort state
merge state using "ObamaDigital.dta"
replace digital_costs = 0 if digital_costs == .
rename digital_costs digital
areg voted2012 romney_effort digital [fw = pop] if re_sample == 1, a(mediamarket) cluster(state)
xi:areg voted2012 romney_effort digital male female white black asian hispanic i.income [fw = pop] if re_sample == 1, a(mediamarket) cluster(state)
xi:areg voted2012 romney_effort digital voted2010 male female white black asian hispanic i.income [fw = pop] if re_sample == 1, a(mediamarket) cluster(state)


***Table A9***
clear
set more off
use "KrasnoGreenReplication.dta"
areg voted2012 battleground [fw = pop], a(state) cluster(mediamarket)
xi:areg voted2012 battleground male female i.age i.income white black asian hispanic [fw = pop], a(state) cluster(mediamarket)
xi:areg voted2012 battleground voted2010 male female i.age i.income white black asian hispanic [fw = pop], a(state) cluster(mediamarket)
areg voted2012 ads [fw = pop], a(state) cluster(mediamarket)
xi:areg voted2012 ads male female i.age i.income white black asian hispanic [fw = pop], a(state) cluster(mediamarket)
xi:areg voted2012 ads voted2010 male female i.age i.income white black asian hispanic [fw = pop], a(state) cluster(mediamarket)
areg voted2012 dollars [fw = pop], a(state) cluster(mediamarket)
xi:areg voted2012 dollars male female i.age i.income white black asian hispanic [fw = pop], a(state) cluster(mediamarket)
xi:areg voted2012 dollars voted2010 male female i.age i.income white black asian hispanic [fw = pop], a(state) cluster(mediamarket)


***Table A10***
clear
set more off
use "TV_Battleground.dta"
*First Stage
xi:reg ads battleground i.state [fw = pop], cluster(mediamarket)
test battleground
xi:reg ads battleground male female i.age i.income white black asian hispanic i.state [fw = pop], cluster(mediamarket)
test battleground
xi:reg ads battleground voted2010 male female i.age i.income white black asian hispanic i.state [fw = pop], cluster(mediamarket)
test battleground
xi:reg dollars battleground i.state [fw = pop], cluster(mediamarket)
test battleground
xi:reg dollars battleground male female i.age i.income white black asian hispanic i.state [fw = pop], cluster(mediamarket)
test battleground
xi:reg dollars battleground voted2010 male female i.age i.income white black asian hispanic i.state [fw = pop], cluster(mediamarket)
test battleground
*Second Stage
xi:ivregress 2sls voted2012 (ads = battleground) i.state [fw = pop], cluster(mediamarket)
xi:ivregress 2sls voted2012 (ads = battleground) male female i.age i.income white black asian hispanic i.state [fw = pop], cluster(mediamarket)
xi:ivregress 2sls voted2012 (ads = battleground) voted2010 male female i.age i.income white black asian hispanic i.state [fw = pop], cluster(mediamarket)
xi:ivregress 2sls voted2012 (dollars = battleground) i.state [fw = pop], cluster(mediamarket)
xi:ivregress 2sls voted2012 (dollars = battleground) male female i.age i.income white black asian hispanic i.state [fw = pop], cluster(mediamarket)
xi:ivregress 2sls voted2012 (dollars = battleground) voted2010 male female i.age i.income white black asian hispanic i.state [fw = pop], cluster(mediamarket)


***Table A11***
*Battleground
clear
set more off
use "CatalistCleaned.dta"
keep voted2012 battleground tier* romney_effort pop *_sample mediamarket state male female white black asian hispanic income 
preserve
replace pop = pop*voted2012
replace voted2012 = 1
save "voted.dta", replace
restore
replace pop = pop*(1 - voted2012)
replace voted2012 = 0
append using "voted.dta"
replace pop = round(pop)
drop if pop == 0
keep if bg_sample == 1
egen mmid = group(mediamarket)
sum mmid
local nmm = r(max)
forvalues i = 2/`nmm' {
g mm_`i' = mmid == `i'
}
*OLS
areg voted2012 battleground [fw = pop], a(mediamarket) cluster(state)
xi:areg voted2012 battleground male female white black asian hispanic i.income [fw = pop], a(mediamarket) cluster(state)
*Logit
logit voted2012 battleground mm_* [fw = pop], cluster(state) 
preserve
replace battleground = 1
predict p1
replace battleground = 0
predict p0
g diff = p1 - p0
sum diff [fw = pop]
restore
xi:logit voted2012 battleground mm_* male female white black asian hispanic i.income [fw = pop], cluster(state) 
preserve
replace battleground = 1
predict p1
replace battleground = 0
predict p0
g diff = p1 - p0
sum diff [fw = pop]
restore
*Romney Effort
clear
set more off
use "CatalistCleaned.dta"
keep voted2012 battleground tier* romney_effort pop *_sample mediamarket state male female white black asian hispanic income 
preserve
replace pop = pop*voted2012
replace voted2012 = 1
save "voted.dta", replace
restore
replace pop = pop*(1 - voted2012)
replace voted2012 = 0
append using "voted.dta"
replace pop = round(pop)
drop if pop == 0
keep if re_sample == 1
egen mmid = group(mediamarket)
sum mmid
local nmm = r(max)
forvalues i = 2/`nmm' {
g mm_`i' = mmid == `i'
}
*OLS
areg voted2012 romney_effort [fw = pop], a(mediamarket) cluster(state)
xi:areg voted2012 romney_effort male female white black asian hispanic i.income [fw = pop], a(mediamarket) cluster(state)
*Logit
logit voted2012 romney_effort mm_* [fw = pop], cluster(state) 
preserve
replace romney_effort = 1
predict p1
replace romney_effort = 0
predict p0
g diff = p1 - p0
sum diff [fw = pop]
restore
xi:logit voted2012 romney_effort mm_* male female white black asian hispanic i.income [fw = pop], cluster(state) 
preserve
replace romney_effort = 1
predict p1
replace romney_effort = 0
predict p0
g diff = p1 - p0
sum diff [fw = pop]
restore

log close

*modify the line below as needed
cd "~/Dropbox/Fowler-Hall/Sharks/FowlerHall_Sharks_ReplicationData"

***Tables 1, 2, and A1; Figures 3 and A1***
clear
set more off
use "SharkAttacksElectionsCleaned.dta"

*** generate various variables we need
** these will be used to make various fixed effects
egen state_year = group(state year)
egen countyid = group(state county note)
g period = ceil((year - 1872)/20)
replace period = 1 if period == 0
egen county_period = group(countyid period)
** attack variables
g attack = attacks > 0
g attack_incparty = attack*incparty
g eyattack = electionyearattacks > 0
g eyattack_incparty = eyattack*incparty
g attack_incumbency = attack*incumbency
g attacks_incparty = attacks*incparty
g reelection = incumbency != 0
g attack_reelection = attack*reelection
g attack_reelection_incparty = attack*reelection*incparty
g eyattack_reelection = eyattack*reelection
g eyattack_reelection_incparty = eyattack*reelection*incparty
egen attackinstate = max(attack), by(state_year)
g cattack = attackinstate*coastal
g cattack_incparty = cattack*incparty
egen attacksinstate = sum(attacks), by(state_year)
g cattacks = attacksinstate*coastal
g cattacks_incparty = cattacks*incparty
egen eyattackinstate = max(eyattack), by(state_year)
g ceyattack = eyattackinstate*coastal
g ceyattack_incparty = ceyattack*incparty
g cattack_reelection = cattack*reelection
g cattack_reelection_incparty = cattack_reelection*incparty
g ceyattack_reelection = ceyattack*reelection
g ceyattack_reelection_incparty = ceyattack_reelection*incparty
drop attackinstate attacksinstate eyattackinstate
egen state_coastal = group(state coastal)


***Table 1***
*baseline
reghdfe voteshare attack attack_incparty, a(state_year county_period) cluster(countyid)
outreg2 using Table1, replace nocons dec(3) alpha(.01, .05) symbol(**, *)
*continuous number of attacks?
reghdfe voteshare attacks attacks_incparty, a(state_year county_period) cluster(countyid)
outreg2 using Table1, append nocons dec(3) alpha(.01, .05) symbol(**, *)
*election-year attacks only?
reghdfe voteshare eyattack eyattack_incparty, a(state_year county_period) cluster(countyid)
outreg2 using Table1, append nocons dec(3) alpha(.01, .05) symbol(**, *)
*only matters when incumbent seeking reeelction?
reghdfe voteshare attack_reelection attack_reelection_incparty, a(state_year county_period) cluster(countyid)
outreg2 using Table1, append nocons dec(3) alpha(.01, .05) symbol(**, *)
*only matters when incumbent seeking reelection and attack in election year?
reghdfe voteshare eyattack_reelection eyattack_reelection_incparty, a(state_year county_period) cluster(countyid)
outreg2 using Table1, append nocons dec(3) alpha(.01, .05) symbol(**, *)
***Table 2***
*baseline
reghdfe voteshare cattack cattack_incparty, a(state_year county_period) cluster(state_coastal)
outreg2 using Table2, replace nocons dec(3) alpha(.01, .05) symbol(**, *)
*continuous number of attacks?
reghdfe voteshare cattacks cattacks_incparty, a(state_year county_period) cluster(state_coastal)
outreg2 using Table2, append nocons dec(3) alpha(.01, .05) symbol(**, *)
*election-year attacks only?
reghdfe voteshare ceyattack ceyattack_incparty, a(state_year county_period) cluster(state_coastal)
outreg2 using Table2, append nocons dec(3) alpha(.01, .05) symbol(**, *)
*only matters when incumbent seeking reeelction?
reghdfe voteshare cattack_reelection cattack_reelection_incparty, a(state_year county_period) cluster(state_coastal)
outreg2 using Table2, append nocons dec(3) alpha(.01, .05) symbol(**, *)
*only matters when incumbent seeking reelection and attack in election year?
reghdfe voteshare ceyattack_reelection ceyattack_reelection_incparty, a(state_year county_period) cluster(state_coastal)
outreg2 using Table2, append nocons dec(3) alpha(.01, .05) symbol(**, *)


*Figure 3
preserve
gen voteshare_3 = voteshare
replace voteshare_3 = dem1912_3party if year == 1912
g beach = state == "NJ" & (county == "ATLANTIC" | county == "CAPE MAY" | county == "MONMOUTH" | county == "OCEAN")
postfile Beach twoparty threeparty year using "Beach.dta", replace
forvalues i = 1900(4)1928 {
reg voteshare beach if state == "NJ" & year == `i'
post Beach (_b[beach]) (.) (`i')
}
reg dem1912_3party beach if state == "NJ" & year == 1912
post Beach (.) (_b[beach]) (1912)
postclose Beach
clear
use "Beach.dta"
graph twoway scatter twoparty threeparty year
gr_edit .style.editstyle margin(vsmall) boxstyle(shadestyle(color(white)) linestyle(color(white))) editcopy
gr_edit .yaxis1.style.editstyle majorstyle(gridstyle(linestyle(color(white)))) editcopy
gr_edit .xaxis1.reset_rule 1900 1928 4 , tickset(major) ruletype(range)
gr_edit .xaxis1.title.text = {}
gr_edit .xaxis1.title.text.Arrpush Election
gr_edit .yaxis1.title.text = {}
gr_edit .yaxis1.title.text.Arrpush Difference between Beach and Non-Beach Counties
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot1.style.editstyle marker(fillcolor(black) linestyle(color(black))) editcopy
gr_edit .plotregion1.plot2.EditCustomStyle , j(9) style(marker(fillcolor(gs8) linestyle(color(gs8))))
gr_edit .plotregion1.AddTextBox added_text editor -.0554122628991009 1918.228799316632
gr_edit .plotregion1.added_text_new = 1
gr_edit .plotregion1.added_text_rec = 1
gr_edit .plotregion1.added_text[1].style.editstyle  angle(default) size(vsmall) color(black) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
gr_edit .plotregion1.added_text[1].text = {}
gr_edit .plotregion1.added_text[1].text.Arrpush two-party Democratic vote share
gr_edit .plotregion1.added_text[1].DragBy .0558796403715668 -5.799653188095445
gr_edit .plotregion1.AddTextBox added_text editor -.0238494770188972 1912.452818182366
gr_edit .plotregion1.added_text_new = 2
gr_edit .plotregion1.added_text_rec = 2
gr_edit .plotregion1.added_text[2].style.editstyle  angle(default) size(vsmall) color(gs8) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
gr_edit .plotregion1.added_text[2].text = {}
gr_edit .plotregion1.added_text[2].text.Arrpush three-party Democratic vote share
gr_edit .plotregion1.added_text[2].style.editstyle color(gs8) editcopy
gr_edit .xaxis1.plotregion.xscale.curmax = 1929
gr_edit .yaxis1.style.editstyle majorstyle(gridstyle(linestyle(color(gs15) width(thin)))) editcopy
gr_edit .xaxis1.style.editstyle draw_major_grid(yes) editcopy
gr_edit .xaxis1.style.editstyle majorstyle(gridstyle(linestyle(color(gs15) width(thin)))) editcopy
graph save "Beach.gph", replace
graph export "Beach.tif", replace as(tif)
restore


***Figure A1***
preserve
postfile Results coef sterr elections cutoff using "Results.dta", replace
forvalues j = 2/20 {
forvalues i = 1/`j' {
quietly {
g period_`j'_`i' = ceil((year - (1868 + `i'*4))/(`j'*4))
egen cp_`j'_`i' = group(countyid period_`j'_`i')
reghdfe voteshare attack attack_incparty, a(state_year cp_`j'_`i') cluster(countyid)
post Results (_b[attack_incparty]) (_se[attack_incparty]) (`j') (`i')
}
disp `j' " " `i'
}
}
postclose Results
clear
use "Results.dta"
g tstat = coef/sterr
hist coef, start(-.015) width(.001875) fraction
gr_edit .style.editstyle margin(vsmall) boxstyle(shadestyle(color(white)) linestyle(color(white))) editcopy
gr_edit .xaxis1.title.text = {}
gr_edit .xaxis1.title.text.Arrpush coefficients
gr_edit .plotregion1.plot1.style.editstyle area(shadestyle(color(white)) linestyle(color(black))) editcopy
gr_edit .xaxis1.reset_rule -.015 .015 .015, tickset(major) ruletype(range) 
gr_edit .yaxis1.style.editstyle majorstyle(gridstyle(linestyle(color(white)))) editcopy
gr_edit .xaxis1.plotregion.xscale.curmax = .016
gr_edit .style.editstyle declared_ysize(3) editcopy
graph save "countyperiod_coef.gph", replace
hist tstat, start(-1.96) width(.245) fraction
gr_edit .style.editstyle margin(vsmall) boxstyle(shadestyle(color(white)) linestyle(color(white))) editcopy
gr_edit .xaxis1.title.text = {}
gr_edit .xaxis1.title.text.Arrpush t-statistics
gr_edit .plotregion1.plot1.style.editstyle area(shadestyle(color(white)) linestyle(color(black))) editcopy
gr_edit .xaxis1.reset_rule -1.96 1.96 1.96, tickset(major) ruletype(range) 
gr_edit .yaxis1.style.editstyle majorstyle(gridstyle(linestyle(color(white)))) editcopy
gr_edit .xaxis1.plotregion.xscale.curmax = 2.01
gr_edit .style.editstyle declared_ysize(3) editcopy
graph save "countyperiod_tstat.gph", replace
graph combine "countyperiod_coef.gph" "countyperiod_tstat.gph", col(1)
gr_edit .style.editstyle margin(zero) boxstyle(shadestyle(color(white)) linestyle(color(white))) editcopy
gr_edit .style.editstyle declared_ysize(6) editcopy
graph save "FigureA1.gph", replace
graph export "FigureA1.tif", replace as(tif)
restore


***Table A1***
*state-year and county-period fixed effects
reghdfe voteshare attack attack_incparty, a(state_year county_period) cluster(countyid)
outreg2 using TableA1, replace nocons dec(3) alpha(.01, .05) symbol(**, *)
*state-year and county fixed effects
reghdfe voteshare attack attack_incparty, a(state_year countyid) cluster(countyid)
outreg2 using TableA1, append nocons dec(3) alpha(.01, .05) symbol(**, *)
*year and county fixed effects
reghdfe voteshare attack attack_incparty, a(year countyid) cluster(countyid)
outreg2 using TableA1, append nocons dec(3) alpha(.01, .05) symbol(**, *)
*year fixed effects only
reghdfe voteshare attack attack_incparty, a(year) cluster(countyid)
outreg2 using TableA1, append nocons dec(3) alpha(.01, .05) symbol(**, *)
*county fixed effects only
reghdfe voteshare attack attack_incparty incparty, a(countyid) cluster(countyid)
outreg2 using TableA1, append nocons dec(3) alpha(.01, .05) symbol(**, *)
*no fixed effects
reg voteshare attack attack_incparty incparty, cluster(countyid)
outreg2 using TableA1, append nocons dec(3) alpha(.01, .05) symbol(**, *)


***Table 3***
clear
set more off
use "NJ_CountyData.dta"
*A&B's specification
reg wilson1916 beach machine wilson1912 if county != "ESSEX"
outreg2 using Table3, replace dec(3) alpha(.01, .05) symbol(**, *)
*don't drop Essex
reg wilson1916 beach machine wilson1912
outreg2 using Table3, append dec(3) alpha(.01, .05) symbol(**, *)
*use attacks instead of beach counties
reg wilson1916 attack machine wilson1912 if county != "ESSEX"
outreg2 using Table3, append dec(3) alpha(.01, .05) symbol(**, *)
*use all coastal counties
reg wilson1916 coastal machine wilson1912 if county != "ESSEX"
outreg2 using Table3, append dec(3) alpha(.01, .05) symbol(**, *)
*don't control for machine
reg wilson1916 beach wilson1912 if county != "ESSEX"
outreg2 using Table3, append dec(3) alpha(.01, .05) symbol(**, *)
*use Mayhew's coding of machine counties
reg wilson1916 beach mayhew wilson1912 if county != "ESSEX"
outreg2 using Table3, append dec(3) alpha(.01, .05) symbol(**, *)


***Figure 1***
clear
set more off
use "NJ_CountyData.dta"
egen countyid = group(county)
preserve
keep countyid county
sort countyid
drop if countyid == countyid[_n-1]
sort countyid
save "counties.dta", replace
restore
g nocontrol = 0
g change = wilson1916 - wilson1912
* A&B Specification
reg wilson1916 beach machine wilson1912 if county != "ESSEX"
scalar ab_coef = _b[beach]
local ab_coef = _b[beach]
scalar ab_pval = 2*ttail(e(df_r),abs(_b[beach]/_se[beach]))
local ab_pval = 2*ttail(e(df_r),abs(_b[beach]/_se[beach]))
postfile Specifications coef upper lower pval machine county affected diff using "Specifications.dta", replace
scalar machinecounter = 0
* loop through specifications
foreach k in nocontrol machine mayhew {
	scalar machinecounter = machinecounter + 1
	scalar countycounter = 0
	forvalues j = 1/22 {
		scalar countycounter = countycounter + 1
		scalar affectedcounter = 0
		foreach i in beach attack coastal {
			scalar affectedcounter = affectedcounter + 1
			qui:reg wilson1916 `i' `k' wilson1912 if countyid != `j'
			post Specifications (_b[`i']) (_b[`i'] + _se[`i']*invttail(e(df_r),.025)) (_b[`i'] - _se[`i']*invttail(e(df_r),.025)) (2*ttail(e(df_r),abs(_b[`i']/_se[`i']))) (machinecounter) (countycounter) (affectedcounter) (0) 
			qui:reg change `i' `k' if countyid != `j'
			post Specifications (_b[`i']) (_b[`i'] + _se[`i']*invttail(e(df_r),.025)) (_b[`i'] - _se[`i']*invttail(e(df_r),.025)) (2*ttail(e(df_r),abs(_b[`i']/_se[`i']))) (machinecounter) (countycounter) (affectedcounter) (1) 
		}
	}
}
postclose Specifications
clear
use "Specifications.dta"
browse
g control = "none" if machine == 1
replace control = "machine" if machine == 2
replace control = "mayhew" if machine == 3
drop machine
g aff = "beach" if affected == 1
replace aff = "attack" if affected == 2
replace aff = "coastal" if affected == 3
drop affected
rename aff affected
g specification = "lag dv" if diff == 0
replace specification = "first diff" if diff == 1
drop diff
rename county countyid
sort countyid
merge countyid using "counties.dta"
tab _merge
replace county = "none" if county == ""
drop _merge countyid
rename county droppedcounty
sort pval
hist coef, xline(-.03228836) bin(100)
gr_edit .style.editstyle margin(vsmall) boxstyle(shadestyle(color(white)) linestyle(color(white))) editcopy
gr_edit .xaxis1.title.text = {}
gr_edit .xaxis1.title.text.Arrpush Point Estimates
gr_edit .plotregion1.plot1.style.editstyle area(shadestyle(color(white)) linestyle(color(black))) editcopy
gr_edit .yaxis1.style.editstyle majorstyle(gridstyle(linestyle(color(white)))) editcopy
gr_edit .plotregion1._xylines[1].style.editstyle linestyle(color(black) pattern(dash)) editcopy
gr_edit .style.editstyle declared_ysize(3) editcopy
graph save "CountyCoefficients.gph", replace
hist pval, xline(.00483919) bin(100)
gr_edit .style.editstyle margin(vsmall) boxstyle(shadestyle(color(white)) linestyle(color(white))) editcopy
gr_edit .xaxis1.title.text = {}
gr_edit .xaxis1.title.text.Arrpush p-values
gr_edit .plotregion1.plot1.style.editstyle area(shadestyle(color(white)) linestyle(color(black))) editcopy
gr_edit .xaxis1.reset_rule 0 .8 .2 , tickset(major) ruletype(range) 
gr_edit .yaxis1.style.editstyle majorstyle(gridstyle(linestyle(color(white)))) editcopy
gr_edit .plotregion1._xylines[1].style.editstyle linestyle(color(black) pattern(dash)) editcopy
gr_edit .style.editstyle declared_ysize(3) editcopy
graph save "CountyPvalues.gph", replace
graph combine "CountyCoefficients.gph" "CountyPvalues.gph", col(1)
gr_edit .style.editstyle margin(zero) boxstyle(shadestyle(color(white)) linestyle(color(white))) editcopy
gr_edit .style.editstyle declared_ysize(6) editcopy
graph save "Figure1.gph", replace
graph export "Figure1.tif", replace as(tif)


***Table 4***
clear
set more off
use "NJ_TownData.dta"
*Atlantic Highlands, Highlands, and Middletown all exchanged territory and are all aruably "near beach", so we create a hybrid town
g ahhm = 0
replace ahhm = 1 if county == "Monmouth" & town == "Atlantic Highlands"
replace ahhm = 1 if county == "Monmouth" & town == "Highlands"
replace ahhm = 1 if county == "Monmouth" & town == "Middletown"
foreach i of varlist taft1912-wilson1916 {
	egen tot_`i' = sum(`i'), by(ahhm)
	replace `i' = tot_`i' if ahhm == 1
	drop tot_`i'
}
drop if ahhm == 1 & town == "Highlands"
drop if ahhm == 1 & town == "Middletown"
replace town = "Atlantic Highlands + Highlands + Middletown" if ahhm == 1
drop ahhm
g vote1916 = wilson1916/(hughes1916 + wilson1916)
g vote1912 = wilson1912/(taft1912 + roosevelt1912 + wilson1912)
g total1916 = hughes1916 + wilson1916
g total1912 = taft1912 + roosevelt1912 + wilson1912
g abspopchange = abs((total1916 - total1912)/total1912)
g votechange = vote1916 - vote1912
g boundarychange = 0
replace boundarychange = 1 if county == "Ocean" & town == "Berkeley"
replace boundarychange = 1 if county == "Ocean" & town == "Dover"
replace boundarychange = 1 if county == "Ocean" & town == "Beach Haven"
replace boundarychange = 1 if county == "Ocean" & town == "Long Beach"
replace boundarychange = 1 if county == "Cape May" & town == "Middle"

*baseline
reg votechange beach [aw = total1916] if county == "Ocean" & abspopchange < .25 & beach + nearbeach + both == 1 & town != "Sea Side Park"
outreg2 using Table4, replace dec(3) alpha(.01, .05) symbol(**, *)
*include Sea Side Park
reg votechange beach [aw = total1916] if county == "Ocean" & abspopchange < .25 & beach + nearbeach + both == 1
outreg2 using Table4, append dec(3) alpha(.01, .05) symbol(**, *)
*drop cases of boundary changes
reg votechange beach [aw = total1916] if county == "Ocean" & abspopchange < .25 & beach + nearbeach + both == 1 & boundarychange == 0
outreg2 using Table4, append dec(3) alpha(.01, .05) symbol(**, *)
*combine Long Beach and Beach Haven into one hybrid town
g longhaven = town == "Long Beach" | town == "Beach Haven"
egen tot12 = sum(total1912), by(longhaven)
egen totwilson12 = sum(wilson1912), by(longhaven)
egen tot16 = sum(total1916), by(longhaven)
egen totwilson16 = sum(wilson1916), by(longhaven)
replace votechange = (totwilson16/tot16) - (totwilson12/tot12) if longhaven == 1
replace abspopchange = abs((tot16 - tot12)/tot12) if longhaven == 1
replace total1916 = tot16 if longhaven == 1
foreach i of varlist taft1912-vote1912 total1912 {
replace `i' = . if longhaven == 1
}
drop if town == "Long Beach"
replace town = "Long Beach + Beach Haven" if longhaven == 1
replace boundarychange = 0 if longhaven == 1
drop longhaven-totwilson16
reg votechange beach [aw = total1916] if county == "Ocean" & abspopchange < .25 & beach + nearbeach + both == 1 & boundarychange == 0
outreg2 using Table4, append dec(3) alpha(.01, .05) symbol(**, *)
*don't drop counties based on population/turnout changes
reg votechange beach [aw = total1916] if county == "Ocean" & beach + nearbeach + both == 1 & boundarychange == 0
outreg2 using Table4, append dec(3) alpha(.01, .05) symbol(**, *)
*include all beach counties
xi:reg votechange beach i.county [aw = total1916] if beach + nearbeach + both == 1 & boundarychange == 0
outreg2 using Table4, append dec(3) alpha(.01, .05) symbol(**, *)


***Figure 2***
** makes data file for R to use
use NJ_CountyData, clear
reg wilson1916 machine
predict wilson1916_beach if beach == 1, residual
predict wilson1916_nobeach if beach == 0, residual
reg wilson1912 machine
predict wilson1912res, residual
save NJ_CountyData_RGraph, replace


***Figure 5***
** make data file for R to use
save NJ_TownData_RGraph, replace


***Figure 4***
clear
set more off
postfile Specifications coef upper lower pval county droppedtown boundary popchange diff hybridtowns using "Specifications.dta", replace
*no hybrid towns
clear
use "NJ_TownData.dta"
g vote1916 = wilson1916/(hughes1916 + wilson1916)
g vote1912 = wilson1912/(taft1912 + roosevelt1912 + wilson1912)
g total1916 = hughes1916 + wilson1916
g total1912 = taft1912 + roosevelt1912 + wilson1912
g abspopchange = abs((total1916 - total1912)/total1912)
g votechange = vote1916 - vote1912
g boundarychange = 0
replace boundarychange = 1 if county == "Ocean" & town == "Berkeley"
replace boundarychange = 1 if county == "Ocean" & town == "Dover"
replace boundarychange = 1 if county == "Ocean" & town == "Beach Haven"
replace boundarychange = 1 if county == "Ocean" & town == "Long Beach"
replace boundarychange = 1 if county == "Cape May" & town == "Middle"
replace boundarychange = 1 if county == "Monmouth" & town == "Atlantic Highlands"
replace boundarychange = 1 if county == "Monmouth" & town == "Highlands"
replace boundarychange = 1 if county == "Monmouth" & town == "Middletown"
keep if beach + nearbeach + both == 1
egen countyid = group(county)
sum countyid
local ncounties = r(max)
local ncountiesplus1 = r(max) + 1
forvalues i = 1/`ncounties' {
g county`i' = countyid == `i'
}
g county`ncountiesplus1' = 1
egen townid = group(county town)
sum townid
local ntowns = r(max)
local ntownsplus1 = r(max) + 1
forvalues i = 1/`ntowns' {
g town`i' = townid != `i'
}
g town`ntownsplus1' = 1
g boundary1 = boundarychange == 0
g boundary2 = 1
g popchange1 = abspopchange < .25
g popchange2 = 1
*A&B Specification
reg votechange beach [aw = total1916] if county == "Ocean" & town != "Sea Side Park" & abspopchange < .25
scalar ab_coef = _b[beach]
scalar ab_pval = 2*ttail(e(df_r),abs(_b[beach]/_se[beach]))
forvalues l = 1/2 {
forvalues k = 1/2 {
forvalues j = 1/`ntownsplus1' {
forvalues i = 1/5 {
*first difference
qui:areg votechange beach [aw = total1916] if county`i' == 1 & town`j' == 1 & boundary`k' == 1 & popchange`l' == 1, a(countyid)
post Specifications (_b[beach]) (_b[beach] + _se[beach]*invttail(e(df_r),.025)) (_b[beach] - _se[beach]*invttail(e(df_r),.025)) (2*ttail(e(df_r),abs(_b[beach]/_se[beach]))) (`i') (`j') (`k') (`l') (1) (0)
*lag dv
qui:areg vote1916 beach vote1912 [aw = total1916] if county`i' == 1 & town`j' == 1 & boundary`k' == 1 & popchange`l' == 1, a(countyid)
post Specifications (_b[beach]) (_b[beach] + _se[beach]*invttail(e(df_r),.025)) (_b[beach] - _se[beach]*invttail(e(df_r),.025)) (2*ttail(e(df_r),abs(_b[beach]/_se[beach]))) (`i') (`j') (`k') (`l') (0) (0)
}
}
}
}
*hybrid towns
clear
use "NJ_TownData.dta"
**combine hybrid towns
*Atlantic Highlands, Highlands, and Middletown all exchanged territory and are all aruably "near beach", so let's create a hybrid town
g ahhm = 0
replace ahhm = 1 if county == "Monmouth" & town == "Atlantic Highlands"
replace ahhm = 1 if county == "Monmouth" & town == "Highlands"
replace ahhm = 1 if county == "Monmouth" & town == "Middletown"
foreach i of varlist taft1912-wilson1916 {
egen tot_`i' = sum(`i'), by(ahhm)
replace `i' = tot_`i' if ahhm == 1
drop tot_`i'
}
drop if ahhm == 1 & town == "Highlands"
drop if ahhm == 1 & town == "Middletown"
replace town = "Atlantic Highlands + Highlands + Middletown" if ahhm == 1
drop ahhm
*combine Long Beach and Beach Haven into one hybrid town
g longhaven = town == "Long Beach" | town == "Beach Haven"
foreach i of varlist taft1912-wilson1916 {
egen tot_`i' = sum(`i'), by(longhaven)
replace `i' = tot_`i' if longhaven == 1
drop tot_`i'
}
drop if longhaven == 1 & town == "Long Beach"
replace town = "Long Beach + Beach Haven" if longhaven == 1
drop longhaven
g vote1916 = wilson1916/(hughes1916 + wilson1916)
g vote1912 = wilson1912/(taft1912 + roosevelt1912 + wilson1912)
g total1916 = hughes1916 + wilson1916
g total1912 = taft1912 + roosevelt1912 + wilson1912
g abspopchange = abs((total1916 - total1912)/total1912)
g votechange = vote1916 - vote1912
g boundarychange = 0
replace boundarychange = 1 if county == "Ocean" & town == "Berkeley"
replace boundarychange = 1 if county == "Ocean" & town == "Dover"
replace boundarychange = 1 if county == "Cape May" & town == "Middle"
keep if beach + nearbeach + both == 1
egen countyid = group(county)
sum countyid
local ncounties = r(max)
local ncountiesplus1 = r(max) + 1
forvalues i = 1/`ncounties' {
g county`i' = countyid == `i'
}
g county`ncountiesplus1' = 1
egen townid = group(county town)
sum townid
local ntowns = r(max)
local ntownsplus1 = r(max) + 1
forvalues i = 1/`ntowns' {
g town`i' = townid != `i'
}
g town`ntownsplus1' = 1
g boundary1 = boundarychange == 0
g boundary2 = 1
g popchange1 = abspopchange < .25
g popchange2 = 1
forvalues l = 1/2 {
forvalues k = 1/2 {
forvalues j = 1/`ntownsplus1' {
forvalues i = 1/5 {
*first difference
qui:areg votechange beach [aw = total1916] if county`i' == 1 & town`j' == 1 & boundary`k' == 1 & popchange`l' == 1, a(countyid)
post Specifications (_b[beach]) (_b[beach] + _se[beach]*invttail(e(df_r),.025)) (_b[beach] - _se[beach]*invttail(e(df_r),.025)) (2*ttail(e(df_r),abs(_b[beach]/_se[beach]))) (`i') (`j') (`k') (`l') (1) (1)
*lag dv
qui:areg vote1916 beach vote1912 [aw = total1916] if county`i' == 1 & town`j' == 1 & boundary`k' == 1 & popchange`l' == 1, a(countyid)
post Specifications (_b[beach]) (_b[beach] + _se[beach]*invttail(e(df_r),.025)) (_b[beach] - _se[beach]*invttail(e(df_r),.025)) (2*ttail(e(df_r),abs(_b[beach]/_se[beach]))) (`i') (`j') (`k') (`l') (0) (1)
}
}
}
}
postclose Specifications
clear
use "Specifications.dta"
browse
sort coef pval
drop if coef == coef[_n-1] & pval == pval[_n-1]
hist coef, xline(-.1276369) bin(100)
gr_edit .style.editstyle margin(vsmall) boxstyle(shadestyle(color(white)) linestyle(color(white))) editcopy
gr_edit .xaxis1.title.text = {}
gr_edit .xaxis1.title.text.Arrpush Point Estimates
gr_edit .plotregion1.plot1.style.editstyle area(shadestyle(color(white)) linestyle(color(black))) editcopy
*gr_edit .xaxis1.reset_rule -.2 .2 .1 , tickset(major) ruletype(range) 
*gr_edit .yaxis1.reset_rule 0 15 5 , tickset(major) ruletype(range) 
gr_edit .yaxis1.style.editstyle majorstyle(gridstyle(linestyle(color(white)))) editcopy
gr_edit .plotregion1._xylines[1].style.editstyle linestyle(color(black) pattern(dash)) editcopy
gr_edit .style.editstyle declared_ysize(3) editcopy
graph save "TownCoefficients.gph", replace
hist pval, xline(.0134043) bin(100)
gr_edit .style.editstyle margin(vsmall) boxstyle(shadestyle(color(white)) linestyle(color(white))) editcopy
gr_edit .xaxis1.title.text = {}
gr_edit .xaxis1.title.text.Arrpush p-values
gr_edit .plotregion1.plot1.style.editstyle area(shadestyle(color(white)) linestyle(color(black))) editcopy
gr_edit .xaxis1.reset_rule 0 1 .2 , tickset(major) ruletype(range) 
*gr_edit .yaxis1.reset_rule 0 15 5 , tickset(major) ruletype(range) 
gr_edit .yaxis1.style.editstyle majorstyle(gridstyle(linestyle(color(white)))) editcopy
gr_edit .plotregion1._xylines[1].style.editstyle linestyle(color(black) pattern(dash)) editcopy
gr_edit .style.editstyle declared_ysize(3) editcopy
graph save "TownPvalues.gph", replace
graph combine "TownCoefficients.gph" "TownPvalues.gph", col(1)
gr_edit .style.editstyle margin(zero) boxstyle(shadestyle(color(white)) linestyle(color(white))) editcopy
gr_edit .style.editstyle declared_ysize(6) editcopy
graph save "Figure4.gph", replace
graph export "Figure4.tif", replace as(tif)


***Figure 6***
clear
set matsize 1000
set more off
use "SharkAttacksElectionsCleaned_AllStates.dta"
*drop all states with either no coastal counties or all coastal counties
egen meancoastal = mean(coastal), by(state)
drop if meancoastal == 0 | meancoastal == 1
drop meancoastal
egen countyid = group(state county note)
egen state_year = group(state year)
*drop if there was an attack in this or the last election cycle
preserve
g attack = attacks > 0
egen attackinstate = max(attack), by(state_year)
sort state_year
drop if state_year == state_year[_n-1]
keep state year attackinstate
sort state year
g lagattackinstate = attackinstate[_n-1] if state == state[_n-1] & year == year[_n-1] + 4
sort state year
save "lagattacks.dta", replace
restore
sort state year
merge state year using "lagattacks.dta"
tab _merge
keep if _merge == 3
drop _merge
sort countyid year
g lagvoteshare = voteshare[_n-1] if countyid == countyid[_n-1] & year == year[_n-1] + 4
drop if attackinstate == 1 | lagattackinstate == 1 | lagvoteshare == . | voteshare == .
keep state countyid year voteshare lagvoteshare coastal
egen state_year = group(state year)
sum state_year
local nstateyears = r(max)
matrix B = J(`nstateyears', 2, .)
forvalues i = 1/`nstateyears' {
qui:reg voteshare coastal lagvoteshare if state_year == `i'
matrix B[`i', 1] = _b[coastal]
matrix B[`i', 2] = 2*ttail(e(df_r),abs(_b[coastal]/_se[coastal]))
}
clear
svmat B
drop if B1 == 0
hist B1, start(-.248) width(.004) xline(.032) xline(-.032)
gr_edit .style.editstyle margin(vsmall) boxstyle(shadestyle(color(white)) linestyle(color(white))) editcopy
gr_edit .xaxis1.title.text = {}
gr_edit .xaxis1.title.text.Arrpush Placebo Point Estimates
gr_edit .plotregion1.plot1.style.editstyle area(shadestyle(color(white)) linestyle(color(black))) editcopy
gr_edit .xaxis1.reset_rule -.2 .2 .1 , tickset(major) ruletype(range) 
gr_edit .yaxis1.reset_rule 0 15 5 , tickset(major) ruletype(range) 
gr_edit .yaxis1.style.editstyle majorstyle(gridstyle(linestyle(color(white)))) editcopy
gr_edit .plotregion1._xylines[1].style.editstyle linestyle(color(black) pattern(dash)) editcopy
gr_edit .plotregion1._xylines[2].style.editstyle linestyle(color(black) pattern(dash)) editcopy
gr_edit .style.editstyle declared_ysize(3) editcopy
graph save "PointEstimates.gph", replace
g bigger = abs(B1) >= .032
tab bigger
hist B2, start(0) width(.01) xline(.05)
gr_edit .style.editstyle margin(vsmall) boxstyle(shadestyle(color(white)) linestyle(color(white))) editcopy
gr_edit .xaxis1.title.text = {}
gr_edit .xaxis1.title.text.Arrpush Placebo p-values
gr_edit .plotregion1.plot1.style.editstyle area(shadestyle(color(white)) linestyle(color(black))) editcopy
gr_edit .xaxis1.reset_rule 0 1 .1 , tickset(major) ruletype(range) 
gr_edit .yaxis1.reset_rule 0 15 5 , tickset(major) ruletype(range) 
gr_edit .yaxis1.style.editstyle majorstyle(gridstyle(linestyle(color(white)))) editcopy
gr_edit .plotregion1._xylines[1].style.editstyle linestyle(color(black) pattern(dash)) editcopy
gr_edit .style.editstyle declared_ysize(3) editcopy
graph save "PValues.gph", replace
g significant = B2 < .05
tab significant
graph combine "PointEstimates.gph" "PValues.gph", col(1)
gr_edit .style.editstyle margin(zero) boxstyle(shadestyle(color(white)) linestyle(color(white))) editcopy
gr_edit .style.editstyle declared_ysize(6) editcopy
graph save "Figure6.gph", replace
graph export "Figure6.tif", replace as(tif)

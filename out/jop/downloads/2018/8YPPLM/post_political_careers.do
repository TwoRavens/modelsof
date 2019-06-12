
// Save all data sets in "/data" folder
// Create a folder "/figs" for all output

//ssc install blindschemes
//ssc install parmest
//ssc install labutil
//ssc install eclplot
set scheme plottig

global age_cutoff = 80
global final_year = 2014

************************************************************
*	Figure 1: Corporate Board and Lobbying Participation Rates
************************************************************

use data/ppc_officials_by_position, clear
collapse (max) on_a_board boards_per_year lobbied, by(official_id category cat)
collapse (mean) on_a_board boards_per_year lobbied (count) n=official_id, by(category cat)
replace on_a_board = on_a_board
replace lobbied = lobbied
replace category = "House" if cat=="house"
replace category = "Senate" if cat=="sen"
replace category = "Ambassador" if cat=="amb20"
replace category = "Exec." if cat=="exec"
graph bar (mean) on_a_board lobbied, over(category, ///
	relabel(1 `" "Ambassador" "(n=117)" "'  ///
	2 `" "Cabinet" "(n=84)" "'  ///
	3 `" "Exec." "(n=73)" "'  ///
	4 `" "Governor" "(n=158)" "'  ///
	5 `" "House" "(n=738)" "'  ///
	6 `" "Senate" "(n=131)" "') label(labsize(medium))) ///
	legend(ring(0) bplacement(ne) label(1 "Share On a Board") label(2 "Share Lobbied") size(medium)) ///
	ylabel(0(.1).6, labels gextend labsize(medium)) ymtick(0(.05)0.60, nolabels grid) ///
	yscale(fextend range(0 .6)) ///
	 blabel(bar, size(medium) format(%9.2f) justification(left))
graph export "figs/figure1_board_lobbying_comparison.pdf", replace
capture window manage close graph

*********************************************************
*	Figure 2: Time to First Corporate Board or Lobbying Report
*********************************************************

use data/ppc_officials_by_position, clear
keep if year(end_dt)>=2000 & on_a_board==1
gen years_to_first_board = board_first_year-year(end_dt)
tab years_to_first_board
//keep if position_id==n_positions
preserve
	collapse (min) years_to_first_board, by(official_id) 
	gen n_cat = _N
	collapse (count) n = official_id, by(n_cat years_to_first_board)
	gen pct = n/n_cat
	gen cat = "all"
	gen category = "All Officials"
	tempfile t
	save `t', replace
restore
bys cat: gen n_cat = _N
collapse (count) n = official_id, by(cat category n_cat years_to_first_board)
gen pct = n/n_cat
append using `t'

sort cat years
drop category n_cat n
reshape wide pct, i(years) j(cat) string
foreach v of varlist pct* {
	replace `v' = 0 if `v'==.
}
drop if years>10
graph twoway (line pctall years, lpattern(solid) lcolor(black) lwidth(medthick)) ///
			 (line pctsen years, lpattern(dash) lwidth(medthick)) ///
			 (line pcthouse years, lpattern(dot) lwidth(medthick)) ///
			 (line pctgov years, lpattern(shortdash) lwidth(medthick)) ///
			 (line pctcab years, lpattern(vshortdash) lwidth(medthick)), ///
	xlabel(0(1)9,labsize(medium)) yscale(range(0 .6)) ylabel(0(.1).6, labsize(medium)) ///
	 ytitle(Share Joining First Board, size(medium)) xtitle(Years Elapsed Since Leaving Office, size(medium)) ///
	legend(ring(0) bplacement(ne) order(1 "All Officials" 2 "Senators" 3 "Representatives" 4 "Governors" 5 "Cabinet") size(medium)) //text(.15 2  "All Officials",size(vsmall))
graph export "figs/figure2a_time_to_first_board.pdf", replace
capture window manage close graph

// Years to first lobbing position
use data/ppc_officials_by_position, clear
keep if year(end_dt)>=2000 & lobbied==1
gen years_to_first_lob = lobbying_first_year-year(end_dt)
tab years_to_first_lob
preserve
	collapse (min) years_to_first_lob, by(official_id) 
	gen n_cat = _N
	collapse (count) n = official_id, by(n_cat years_to_first_lob)
	gen pct = n/n_cat
	gen cat = "all"
	gen category = "All Officials"
	tempfile t
	save `t', replace
restore
bys cat: gen n_cat = _N
collapse (count) n = official_id, by(cat category n_cat years_to_first_lob)
gen pct = n/n_cat
append using `t'

sort cat years
keep if inlist(cat, "all", "sen", "house")
drop category n_cat n
reshape wide pct, i(years) j(cat) string
foreach v of varlist pct* {
	replace `v' = 0 if `v'==.
}
drop if years>10
graph twoway (line pctall years, lpattern(solid) lcolor(black) lwidth(medthick)) ///
			 (line pctsen years, lpattern(dash) lwidth(medthick)) ///
			 (line pcthouse years, lpattern(shortdash) lwidth(medthick)), ///
	xlabel(0(1)9,labsize(medium)) yscale(range(0 .6)) ylabel(0(.1).6,labsize(medium)) ///
	 ytitle(Share on First Lobbying Report,size(medium)) xtitle(Years Elapsed Since Leaving Office,size(medium)) ///
	legend(ring(0) bplacement(ne) order(1 "All Officials" 2 "Senators" 3 "Representatives") size(medium)) //text(.15 2  "All Officials",size(vsmall))
graph export "figs/figure2b_time_to_first_lobbying_report.pdf", replace
capture window manage close graph

************************************************************
*	Table 2: Relationship Between Board Service and Lobbying
************************************************************

use data/ppc_officials_by_position, clear
corr on_a_board lobbied
gen board_and_lobbied = on_a_board*lobbied
gen board_if_lobbied = on_a_board
replace board_if_lobbied = . if lobbied==0
gen lobbied_if_board = lobbied
replace lobbied_if_board = . if on_a_board==0
preserve
	collapse (max)  on_a_board lobbied board_and_lobbied *_if_*, by(official_id)
	collapse (mean) on_a_board lobbied board_and_lobbied *_if_* (count) n=official_id
	gen category = "\midrule All Officials"
	tempfile t
	save `t', replace
restore
gen n = 1
collapse (max) on_a_board lobbied board_and_lobbied *_if_* n, by(official_id category)
collapse (mean) on_a_board lobbied board_and_lobbied *_if_* (count) n, by(category)
append using `t'
gen jaccard = board_and_lobbied/(on_a_board + lobbied - board_and_lobbied)
format %04.3f *board* *lob* jaccard
order n, after(category)
listtex category n on_a_board lobbied board_and_lobbied jaccard using "figs/table2_board_and_lobbying_relationship.tex", ///
	delimiter(" & ") end(" \\") replace

************************************************************
*	Sample description for Appendix A
************************************************************

use data/ppc_officials_by_position, clear
disp _N // Total offices
bys official_id: keep if _n==1
disp _N // Total unique officials
count if boardex_match==1!=.
disp r(N)/_N // Pct matched to Boardex
count if opensecretslobbyingid!=""
disp r(N)/_N // Pct matched to Open Secrets
	
************************************************************
*	Table A1: Board Service and Lobbying by Office Type
************************************************************

use data/ppc_officials_by_position, clear
collapse (max) on_a_board boards_per_year lobbied, by(official_id)
collapse (mean) on_a_board boards_per_year lobbied (count) n=official_id
gen category = "\midrule All Officials"
tempfile t
save `t', replace
use data/ppc_officials_by_position, clear
collapse (max) on_a_board boards_per_year lobbied, by(official_id category)
collapse (mean) on_a_board boards_per_year lobbied (count) n=official_id, by(category)
append using `t'
format %04.3f on_a_board boards_per_year lobbied
listtex category n on_a_board boards_per_year lobbied using "figs/tableA1_results_by_category_main.tex", ///
	delimiter(" & ") end(" \\") replace
	
************************************************************
*	Table A2: Board Service and Lobbying by Office Type, Officials Leaving Office After 1999
************************************************************

use data/ppc_officials_by_position, clear
drop if end_dt<=mdy(1,1,2000)
collapse (max) on_a_board boards_per_year lobbied, by(official_id)
collapse (mean) on_a_board boards_per_year lobbied (count) n=official_id
gen category = "\midrule All Officials"
tempfile t
save `t', replace
use data/ppc_officials_by_position, clear
drop if end_dt<=mdy(1,1,2000)
collapse (max) on_a_board boards_per_year lobbied, by(official_id category)
collapse (mean) on_a_board boards_per_year lobbied (count) n=official_id, by(category)
append using `t'
format %04.3f on_a_board boards_per_year lobbied
listtex category n on_a_board boards_per_year lobbied using "figs/tableA2_results_by_category_post_2000.tex", ///
	delimiter(" & ") end(" \\") replace

************************************************************
*	Table A3: Board Service by Ambassadorship
************************************************************

use data/ppc_officials_by_position, clear
keep if cat=="amb20"
collapse (max) on_a_board boards_per_year lobbied, by(official_id)
collapse (mean) on_a_board boards_per_year lobbied (count) n=official_id
gen country = "\midrule All Ambassadors"
tempfile t
save `t', replace
use data/ppc_officials_by_position, clear
keep if cat=="amb20"
collapse (mean) on_a_board boards_per_year lobbied (count) n=position_id, by(ambassadortype)
gsort ambassadortype
ren ambassadortype country
replace country = "\midrule " + country in 1
append using `t'
save `t', replace
use data/ppc_officials_by_position, clear
keep if cat=="amb20"
replace country = "France" if strpos(country, "France")!=0
replace country = "Russia" if strpos(country, "Russia")!=0
collapse (mean) on_a_board boards_per_year lobbied (count) n=position_id, by(country)
gsort -on_a_board -boards_per country
append using `t'
format %04.3f on_a_board boards_per_year lobbied
listtex country n on_a_board boards_per_year lobbied using "figs/tableA3_amb_results.tex", ///
	delimiter(" & ") end(" \\") replace

************************************************************
*	Table A4: Board Service by Cabinet Position
************************************************************

use data/ppc_officials_by_position, clear
keep if cat=="cab"
collapse (max) on_a_board boards_per_year lobbied, by(official_id)
collapse (mean) on_a_board boards_per_year lobbied (count) n=official_id
gen office = "\midrule All Officials"
tempfile t
save `t', replace
use data/ppc_officials_by_position, clear
keep if cat=="cab"
collapse (mean) on_a_board boards_per_year lobbied (count) n=position_id, by(office)
format %04.3f on_a_board boards_per_year lobbied
gsort -on_a_board -boards_per office
append using `t'
replace office = subinstr(office, "Secretary", "Sec.", 1)
replace office = subinstr(office, "Development", "Dev.", 1)
replace office = subinstr(office, "Services", "Serv.", 1)
listtex office n on_a_board boards_per_year lobbied using "figs/tableA4_cab_results_by_office.tex", ///
	delimiter(" & ") end(" \\") replace

************************************************************
*	Table A5: Board Service by Executive Branch Officials
************************************************************

use data/ppc_officials_by_position, clear
keep if cat=="exec"
collapse (max) on_a_board boards_per_year lobbied, by(official_id)
collapse (mean) on_a_board boards_per_year lobbied (count) n=official_id
gen office = "\midrule All Officials"
tempfile t
save `t', replace
use data/ppc_officials_by_position, clear
keep if cat=="exec"
collapse (mean) on_a_board boards_per_year lobbied (count) n=position_id, by(cat2)
ren cat2 office
format %04.3f on_a_board boards_per_year lobbied
gsort -on_a_board -boards_per office
drop if n<=2
append using `t'
replace office = subinstr(office, "Director", "Dir.", 1)
replace office = subinstr(office, "Representative", "Rep.", 1)
listtex office n on_a_board boards_per_year lobbied using "figs/tableA5_exec_results_by_office.tex", ///
		delimiter(" & ") end(" \\") replace

************************************************************
*	Table B1: Partisan Differences in Board Service and Lobbying
************************************************************

use data/ppc_officials_by_position, clear
tab party
replace party = substr(party, -1, 1)
keep if inlist(party, "D", "R")
gen repub = party=="R"

tempfile t

capture postclose party_diff
postfile party_diff str12 variable str5 cat n_dem pct_dem n_rep pct_rep mean z p n using `t', replace
foreach v in on_a_board lobbied {
	foreach c in amb20 cab exec gov house sen {
		sum `v' if cat=="`c'" & repub==0
		local n_dem = r(N)
		local pct_dem = r(mean)
		sum `v' if cat=="`c'" & repub==1
		local n_rep = r(N)
		local pct_rep = r(mean)
		prtest `v' if cat=="`c'", by(repub)
		local mean = r(P_1)-r(P_2)
		local n = r(N_1)+r(N_2)
		local z = r(z)
		local p = 2*(1-normal(abs(`z')))
		post party_diff ("`v'") ("`c'") (`n_dem') (`pct_dem') (`n_rep') (`pct_rep') (`mean') (`z') (`p') (`n')
	}
	sum `v' if repub==0
	local n_dem = r(N)
	local pct_dem = r(mean)
	sum `v' if repub==1
	local n_rep = r(N)
	local pct_rep = r(mean)
	prtest `v', by(repub)
	local mean = r(P_1)-r(P_2)
		local n = r(N_1)+r(N_2)
		local z = r(z)
		local p = 2*(1-normal(abs(`z')))
	post party_diff ("`v'") ("`c'") (`n_dem') (`pct_dem') (`n_rep') (`pct_rep') (`mean') (`z') (`p') (`n')
}
postclose party_diff	

keep cat category
duplicates drop
merge 1:m cat using `t', nogen
drop cat
replace category = "All" if category==""
sort variable category
gen s = _n
replace s = 100 if category=="All"
sort variable s
drop s
replace category = "\midrule " + category if category=="All"
format %04.3f pct* mean z p
tostring p, gen(ps) format("%04.3f") force
replace ps = "\textbf{"+ps+"}" if p<.05
listtex category n_dem pct_dem n_rep pct_rep mean z ps ///
	using "figs/tableB1_party_differences_z_tests_boards.tex" if variable=="on_a_board", ///
	delimiter(" & ") end(" \\") replace
listtex category n_dem pct_dem n_rep pct_rep mean z ps ///
	using "figs/tableB1_party_differences_z_tests_lobbying.tex" if variable=="lobbied", ///
	delimiter(" & ") end(" \\") replace

************************************************************
*	Figure B1: Board Service Rates by Year
************************************************************

// First, determine who served on a board in each year
use data/officials_with_public_company_positions, clear

gen board_start_yr = year(board_start_dt)
gen board_end_yr = year(board_end_dt)

forvalues y=2000/$final_year {
	gen on_board_`y' = board_start_yr<=`y' & board_end_yr>`y'
	replace on_board_`y' = 0 if (death_dt!=. & year(death_dt)<=`y') | (`y'-year(birth_dt)>$age_cutoff)
	gen board_`y' = on_board_`y'
}
collapse (max) on_board_???? (sum) board_????, by(official_id position_id cat)
tempfile t
save `t', replace

// Determine eligibility for each year, and merge with actual board service
use data/ppc_officials_by_position, clear
forvalues y=2000/$final_year {
	gen eligible_`y' = year(end_dt)<=`y'
	replace eligible_`y' = 0 if (death_dt!=. & year(death_dt)<=`y') | (`y'-year(birth_dt)>$age_cutoff)
}
merge 1:1 official_id position_id using `t', keep(matched master)
foreach v of varlist board_???? on_board_???? {
	replace `v' = 0 if `v'==.
}
// Get results by category
preserve
	collapse (sum) eligible_???? on_board_???? board_????, by(cat)
	tempfile t
	save `t', replace
restore
// Get results for everyone (first collapse to individuals to avoid duplicates)
collapse (max) eligible_???? on_board_???? board_????, by(official_id)
collapse (sum) eligible_???? on_board_???? board_????
gen cat = "all"
append using `t'
forvalues y=2000/$final_year {
	gen pct_`y' = on_board_`y'/eligible_`y'
}
tempfile t
save `t', replace

// Make Graph
keep cat pct*
reshape long pct_, i(cat) j(year)
reshape wide pct_, i(year) j(cat) string
ren pct_* *
graph twoway line all year, lwidth(medthick) || ///
	line sen year, lwidth(medthick) || ///
	line house year, lwidth(medthick) || ///
	line gov year, lwidth(medthick) || ///
	line cab year, lwidth(medthick) ///
	ytitle("Share on a Board") xtitle("") ///
	xlabel(2000(2)$final_year) xscale(range(2000 2016.1)) legend(off) ///
	text(.190 2014.1 "All", placement(3)) ///
	text(.330 2014.1 "Senate", placement(3)) ///
	text(.063 2014.1 "House", placement(3)) ///
	text(.290 2014.1 "Governors", placement(3)) ///
	text(.456 2014.1 "Cabinet", placement(3))
	
graph export "figs/figureB1_board_participation_by_year.pdf", replace
capture window manage close graph

// Stats on board service over time
use `t', clear
keep if cat=="all"
total eligible_2000 on_board_2000 board_2000
disp _b[on_board_2000]/_b[eligible_2000]
disp _b[board_2000]/_b[on_board_2000]

total eligible_2013 on_board_2013 board_2013
disp _b[on_board_2013]/_b[eligible_2013]
disp _b[board_2013]/_b[on_board_2013]

************************************************************
*	Table 2, C1, and C2
************************************************************

use data/ppc_officials_by_position, clear
keep if year(end_dt)>=2000 & year(end_dt)<2013
gen age_limit = mdy(month(birth_dt), day(birth_dt), year(birth_dt) + $age_cutoff)
format age_limit  %td

rename end_dt eligible
rename death_dt death

gen age_at_eligible = (eligible - birth_dt) / 365.25

gen lobbying_start_dt_first = mdy(12, 31, lobbying_first_year)
format lobbying_start_dt_first %td

keep eligible death board_first_year lobbying_first_year cat age_limit age_at_eligible gender party name *first *last state official_id position_id

gen treated = year(eligible)>=2008
gen sen = (cat=="sen")

gen post = "Post" if treated==1
replace post = "Pre" if treated==0

gen year_eligible = year(eligible)

gen female = gender == "F"

gen dem = party == "D"

egen state_n = group(state)

label var dem "Democrat"
label var female "Female"
label var treated "Post HLOGA"
label var sen "Senate"
label var age_at_eligible "Age" 

gen postHLOGAxSenate = treated * sen
label var postHLOGAxSenate "Post HLOGA $\times$ Senate"

// BOARDS

gen enter = max(date("1/1/1993","MDY"),eligible)
gen exit = min(death,board_start_dt_first,date("12/31/2014","MDY"))
format enter exit %td

replace board_start_dt_first = eligible + 1 if board_start_dt_first <= eligible & !missing(eligible) & !missing(board_start_dt_first)

stset exit, failure(board_start_dt_first) enter(time enter) origin(time eligible) scale(365.25)

gen early_exit = enter + 365.25*2 if year(enter)!=2007
gen early_board_start_dt_first = board_start_dt_first if board_start_dt_first<=early_exit & early_exit!=.
replace early_exit = early_board_start_dt if early_board_start_dt!=.

format early* %td

stset early_exit, failure(early_board_start_dt_first) enter(time enter) origin(time eligible) exit(time early_exit) scale(365.25)

stcox sen postHLOGAxSenate i.state_n i.year_eligible if inlist(cat,"house","sen"), cluster(year_eligible)
estimates store breg1

stcox sen postHLOGAxSenate female dem age_at_eligible i.state_n i.year_eligible if inlist(cat,"house","sen"), cluster(year_eligible)
estimates store breg2

gen board2 = ((board_start_dt_first - eligible) / 365.25) <= 2
replace board2 = . if enter< date("1/1/1993","MDY") | year(enter)==2007
label var board2 "Board w/in 2 Years"

reg board2 sen postHLOGAxSenate i.state_n i.year_eligible if inlist(cat,"house","sen"), cluster(year_eligible)
estimates store breg3

reg board2 sen postHLOGAxSenate female dem age_at_eligible i.state_n i.year_eligible if inlist(cat,"house","sen"), cluster(year_eligible)
estimates store breg4

esttab breg* using "figs/tableC2_board_fe.tex", drop(_cons  ) nobaselevels interaction(" $\times$ ") star(* 0.10 ** 0.05 *** 0.01) se label compress nonotes booktabs /// eform(1 1 0 0) ///
mgroups("Join Board Log Hazard Ratio" "Join Board Indicator", pattern(1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) indicate("State FEs = *state_n" "Year Left Office FEs = *year_eligible") nomtitles ///
addnotes("Standard Errors, clustered by year of eligibility, are in parentheses." "* p $<$ 0.10, ** p $<$ 0.05, *** p $<$ 0.01." "Models 1 and 2 estimate Cox model; Models 3 and 4 estimated with least squares." "Individuals Leaving Office in 2007 are omitted from sample.") ///
title("Effects of HLOGA on Post-Office Employment on Boards \label{board-fe}" ) replace

// LOBBYING

replace enter = max(date("1/1/1998","MDY"),eligible)
replace exit = min(death,lobbying_start_dt_first,date("12/31/2014","MDY"))

stset exit, failure(lobbying_start_dt_first) enter(time enter) origin(time eligible) scale(365.25)

gen cat2 = proper(cat) + " " + post
sts graph if inlist(cat,"house","sen"), by(cat2) title("") ///		
ytitle("Share Not Lobbying") xtitle("Years After Leaving Office") ///		
xlabel(,labsize(medium)) ylabel(1(.25)0, labsize(medium)) ///	
legend(ring(0) bplacement(se) size(medium)) ///
plot1opts(lpattern(solid)) plot2opts(lpattern(dot) lcolor(black)) plot3opts(lpattern(dash) lcolor(red)) plot4opts(lpattern(dash_dot) lcolor(red))
graph export "figs/figureC1_survival_pre_post_lobby.pdf", replace
capture window manage close graph

gen early_lobbying_start_dt_first = lobbying_start_dt_first if lobbying_start_dt_first<=early_exit & early_exit!=.
replace early_exit = early_lobbying_start_dt if early_lobbying_start_dt!=.

format early* %td

stset early_exit, failure(early_lobbying_start_dt_first) enter(time enter) origin(time eligible) exit(time early_exit) scale(365.25)

stcox sen postHLOGAxSenate i.state_n i.year_eligible if inlist(cat,"house","sen"), cluster(year_eligible)
estimates store lreg1

stcox sen postHLOGAxSenate female dem age_at_eligible i.state_n i.year_eligible if inlist(cat,"house","sen"), cluster(year_eligible)
estimates store lreg2

gen lobby2 = ((lobbying_start_dt_first - eligible) / 365.25) <= 2
replace lobby2 = . if enter< date("1/1/1999","MDY") | year(enter)==2007
label var lobby2 "Lobby w/in 2 Years"

reg lobby2 sen postHLOGAxSenate i.state_n i.year_eligible if inlist(cat,"house","sen"), cluster(year_eligible)
estimates store lreg3

reg lobby2 sen postHLOGAxSenate female dem age_at_eligible i.state_n i.year_eligible if inlist(cat,"house","sen"), cluster(year_eligible)
estimates store lreg4

esttab lreg1 lreg2 lreg3 lreg4 using "figs/tableC1_lobby_fe.tex", drop(_cons  ) nobaselevels interaction(" $\times$ ") star(* 0.10 ** 0.05 *** 0.01) se label compress nonotes booktabs /// eform(1 1 0 0) ///
mgroups("Lobby Log Hazard Ratio" "Lobby Indicator", pattern(1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) indicate("State FEs = *state_n" "Year Left Office FEs = *year_eligible") nomtitles ///
addnotes("Standard Errors, clustered by year of eligibility, are in parentheses." "* p $<$ 0.10, ** p $<$ 0.05, *** p $<$ 0.01." "Models 1 and 2 estimate Cox model; Models 3 and 4 estimated with least squares." "Individuals Leaving Office in 2007 are omitted from sample.") ///
title("Effects of HLOGA on Post-Office Employment on Lobbying \label{lobby-fe}") replace

esttab lreg3 lreg4 breg3 breg4 using "figs/table1_lobby_boards_ols_fe.tex", drop(_cons  ) nobaselevels interaction(" $\times$ ") star(* 0.10 ** 0.05 *** 0.01) se label compress nonotes booktabs /// eform(1 1 0 0) ///
mgroups("Lobbied" "Joined Board", pattern(1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) indicate("State FEs = *state_n" "Year Left Office FEs = *year_eligible") nomtitles ///
addnotes("Standard Errors, clustered by year of eligibility, are in parentheses." "* p $<$ 0.10, ** p $<$ 0.05, *** p $<$ 0.01." "Individuals Leaving Office in 2007 are omitted from sample.") ///
title("Effects of HLOGA on Post-Office Employment on Lobbying \label{lobby-boards-ols-fe}") replace

************************************************************
*	Figure C2: Retirements by Year
************************************************************

use "data/opensecrets_retirements", clear

gen share = retire/100 if chamber=="sen"

replace share = retire/435 if chamber == "house"

replace year = year + 1

twoway (line share year if chamber=="house") (line share year if chamber=="sen"), ///
title("") ///
ytitle("Share of Chamber Retiring") xtitle("Year of Retirement") ///
xlabel(,labsize(medium)) ylabel(, labsize(medium)) ///
legend(order(1 "Representatives" 2 "Senators") ring(0) bplacement(se) size(medium)) xline(2007.8)

graph export "figs/figureC2_cong_retire.pdf", replace
capture window manage close graph

************************************************************
*	Appendix D
************************************************************

use data/members_of_congress_with_covariates, clear

tempfile temp1 temp2 temp3 temp4 temp5 temp6
	
reg on_a_board committee_leader party_leader female dem over65 business law military, robust
parmest, label ylabel escal(N r2) list(parm estimate min* max* p) saving(`temp5', replace)

reg lobbied committee_leader party_leader female dem over65 business law military, robust
parmest, label ylabel escal(N r2) list(parm estimate min* max* p) saving(`temp6', replace)

reg on_a_board committee_leader party_leader female dem over65 business law military if cat=="house", robust
parmest, label ylabel escal(N r2) list(parm estimate min* max* p) saving(`temp1', replace)

reg on_a_board committee_leader party_leader female dem over65 business law military if cat=="sen", robust
parmest, label ylabel escal(N r2) list(parm estimate min* max* p) saving(`temp2', replace)

reg lobbied committee_leader party_leader female dem over65 business law military if cat=="house", robust
parmest, label ylabel escal(N r2) list(parm estimate min* max* p) saving(`temp3', replace)

reg lobbied committee_leader party_leader female dem over65 business law military if cat=="sen", robust
parmest, label ylabel escal(N r2) list(parm estimate min* max* p) saving(`temp4', replace)

use `temp1', clear

append using `temp3'

gen cat = "House"

append using `temp2'

append using `temp4'

replace cat = "Senate" if cat ==""

append using `temp5'

append using `temp6'

replace cat = "Both" if cat ==""

drop if parm == "_cons" | p==.

local n = 1
gen parmn = .
foreach item in "committee_leader" "party_leader" "female" "dem" "over65" "business" "law" "military" {
replace parmn = `n' if parm == "`item'"
local n = `n' + 1
}

labmask parmn, values(label)

count
local N = r(N)/6

eclplot estimate min95 max95 parmn if cat == "House", hori supby(ylabel, spaceby(.20) offset(-.10)) ytitle("") estopts1(msymbol(D) mcolor(black)) estopts2(msymbol(S) mcolor(black)) ciopts(lcolor(black)) xtitle("Pr(Joined)",size("small")) xlabel(-1(1)1,labsize(small)) ylabel(#`N',labsize(small)) xline(0) ytitle("")
graph export "figs/figureD1_house_desc_reg.pdf", replace
capture window manage close graph

eclplot estimate min95 max95 parmn if cat == "Senate", hori supby(ylabel, spaceby(.20) offset(-.10)) ytitle("") estopts1(msymbol(D) mcolor(black)) estopts2(msymbol(S) mcolor(black)) ciopts(lcolor(black)) xtitle("Pr(Joined)",size("small")) xlabel(-1(1)1,labsize(small)) ylabel(#`N',labsize(small)) xline(0) ytitle("")
graph export "figs/figureD1_sen_desc_reg.pdf", replace
capture window manage close graph

eclplot estimate min95 max95 parmn if cat == "Both", hori supby(ylabel, spaceby(.20) offset(-.10)) ytitle("") estopts1(msymbol(D) mcolor(black)) estopts2(msymbol(S) mcolor(black)) ciopts(lcolor(black)) xtitle("Pr(Joined)",size("small")) xlabel(-1(1)1,labsize(small)) ylabel(#`N',labsize(small)) xline(0) ytitle("")
graph export "figs/figureD1_desc_reg.pdf", replace
capture window manage close graph

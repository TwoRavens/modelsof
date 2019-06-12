************************************************************************
***************SETUP CODE HEADER FOR ALL PROGRAMS***********************
***************									 ***********************
************************************************************************
clear
clear matrix
clear mata
cap log close

global root ~/dropbox/Reservations_Candidacy_ReplicationBackup
include "$root/2progs/00_Set_paths.do"
************************************************************************
************************************************************************
**bring in candidate histories data
import excel "$data/candidate_histories/histories_formerge.xlsx", sheet("Sheet1") firstrow clear case(lower) allstring
keep slno candidatename state constituency priorlocalgovt priorhighergovt family
destring priorlocalgovt priorhighergovt family, replace
g year=2009
tempfile tempinfo
save `tempinfo'

import excel "$do/merge/clean_LS_parties.xlsx", sheet("Sheet1") firstrow clear case(lower) allstring
tempfile partytemp
save `partytemp'

use "$work/LSmatchedset", clear

merge m:1 slno candidatename state constituency year using `tempinfo', assert(1 3) nogen
merge m:1 party using `partytemp', assert(3) nogen keepusing(major)


g district = constituency
destring voter_turnout votes_polled, replace
g start = .
g count = 1
g female_candidate = gender=="F"
g female_votes = female_candidate*votes_polled
gsort year state constituency -votes_polled
bys year state constituency : g winner = _n==1
bys year state constituency : g finish = _n
bys year state constituency : g total_cand = _N
g finish_pctile = 1-((finish-1)/total_cand)
drop total_cand
g top3 = finish<=3
g top5 = finish<=5
g top10th = finish_pctile>=.9
g top30th = finish_pctile>=.7
g top50th = finish_pctile>=.5
g prior_local =  priorlocalgovt==1 if gender=="F" & year==2009
g prior_higher = priorhighergovt==1 if gender=="F" & year==2009
g political_family =  family==1 if gender=="F" & year==2009
g no_backgr_info =  political_family==0 & prior_local==0 & prior_higher==0 if gender=="F" & year==2009
foreach i in 3 5 10th 30th 50th {
g female_finish_top`i' = female_candidate*top`i'
}
g female_winner=winner*female_candidate
g winmargin = votes_polled-votes_polled[_n+1] if winner==1 & state==state[_n+1] & constituency == constituency[_n+1]

**add in major party and margin info
g majorparty = major=="1"
g female_candidate_majorparty = female_candidate*major=="1"
g female_candidate_independent = female_candidate*trim(party)=="IND"
g female_candidate_minorparty = female_candidate*(major!="1" & trim(party)!="IND")
g majorparty_votes = votes_polled*major=="1"

g majorparty_votes_hifemale = votes_polled if inlist(party,"INC","SP","BJP")
g majorparty_votes_lofemale = votes_polled if inlist(party,"JP","JD","BSP")
g minorparty_votes = votes_polled if !inlist(party,"INC","SP","BJP","JP","JD","BSP","IND")
g independent_votes = votes_polled if inlist(party,"IND")


** MAR 2016 : add in whether incumbent is running; add in margin in previous if incumbent
replace id_final = "2009_"+string(id2009) if !mi(id2009) & year==2004 //push the IDs forward
gsort id_final + year
g incumbent_run = id_final==id_final[_n-1] & winner[_n-1]==1
g incumbent_win = incumbent_run*winner
g incumbent_prev_win_margin = incumbent_run*winmargin[_n-1]
g incumbent_majorparty = incumbent_run*majorparty

g end=.


***Summary stats on F participation/candidacy***********************
tab year gender
tab year gender if winner
gsort candidatename_final district +year
bys candidatename_final district: g candidate_runs=_n
bys candidatename_final district: g candidate_wins=sum(winner)
g repeat_run= candidatename_final == candidatename_final[_n-1] & year >year[_n-1]
g any_prev_run = candidate_runs>1
g any_prev_win = candidate_wins>1
g female_candidate_prev_run = gender=="F"*any_prev_run 
g female_candidate_prev_win = gender=="F"*any_prev_win
***
order female_candidate_prev_run female_candidate_prev_win, before(end)
g _10_state_sample = state=="ANDHRA PRADESH" | state=="BIHAR" | state=="GUJARAT" | state=="HARYANA" | state=="KERALA" | state=="MAHARASHTRA" | state=="ORISSA" | state=="PUNJAB" | state=="RAJASTHAN" | state=="WEST BENGAL"

preserve
g candidates = 1
//keep if _10_state
drop if mi(gender) //this is from a patched-in state from a source that doesnt have gender info
collapse (sum) candidates repeat_run votes_polled , by(year gender constituency)
collapse (sum) candidates repeat_run (mean) votes_polled , by(year gender)
reshape wide candidates repeat_run votes_polled, i(year) j(gender) string
g share_candF = candidatesF/(candidatesF+candidatesM)
g repeat_rateF = repeat_runF/candidatesF
g repeat_rateM = repeat_runM/candidatesM
reshape long candidates repeat_run votes_polled share_cand repeat_rate, i(year) j(gender) string
renvars candidates repeat_run votes_polled share_cand repeat_rate \ _candidates _repeat_run _votes_polled _share_cand _repeat_rate 
reshape long _, i(year gender) j(var) string
reshape wide _, i(gender var) j(year)

drop if var=="share_cand" & gender=="M"

replace gender = ", men" if gender=="M"
replace gender = ", women" if gender=="F"

g order = 1
replace order = 2 if var=="share_cand"
replace order = 3 if var=="repeat_run"
replace order = 4 if var=="repeat_rate"
replace order = 5 if var=="votes_polled"
replace var = "Num. candidates" if order ==1
replace var = "Share of candidates" if var=="share_cand"
replace var = "Repeat contest" if var=="repeat_run"
replace var = "Frac. repeat contestors" if var=="repeat_rate"
replace var = "Avg. vote share" if var=="votes_polled"

gsort order +gender
rename var Measure
replace Measure = Measure+gender
drop gender order
restore
*********************************************************************end sumstats
preserve
keep if year==2009
tab gender winner, mi //for summary stats table
tab gender any_prev_run, mi //for summary stats table
merge 1:1 id_final candidatename state constituency using "$work/female_cand_state_assembly", assert(1 3) nogen
order f_ran_state_assembly f_won_state_assembly, before(end)
tab  f_ran_state_assembly f_won_state_assembly, mi //for summary stats table
collapse (sum) start-end , by( state constituency voter_turnout)
g female_share_candidates = female_candidate/ count
g any_female_cand = female_candidate!=0
g any_female_cand_prev_run = female_candidate_prev_run>0
g any_female_cand_prev_win = female_candidate_prev_win>0
g any_female_cand_prev_assly_run = f_ran_state_assembly>0
drop start end

//for summary table
count
sum count female_candidate any_female_cand female_winner female_votes
sum female_winner if any_female_cand == 1
//end for summary table

save "$work/candidacy_info_by_constituency", replace
restore


preserve
//keep if year==2009
tab gender winner, mi //for summary stats table
tab gender any_prev_run, mi //for summary stats table
collapse (sum) start-end , by( state constituency year)
g female_share_candidates = female_candidate/ count
g any_female_cand = female_candidate!=0
drop start end

//for summary table
count
sum count female_candidate any_female_cand female_winner female_votes
sum female_winner if any_female_cand == 1
//end for summary table

save "$work/candidacy_info_by_constituency_year", replace
restore


preserve
keep if year==1991
collapse (sum) start-end , by( state constituency voter_turnout)
g female_share_candidates_1991 = female_candidate/ count
g any_female_candidate_1991 = female_candidate!=0
g any_female_cand_prev_run_1991 = female_candidate_prev_run>0
g any_female_cand_prev_win_1991 = female_candidate_prev_win>0
drop start end female_candidate count female_candidate_prev_run female_candidate_prev_win
save "$work/candidacy_info_by_constituency_1991", replace
restore

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
use "$work/candidate_info_by_ACconstituency", clear //this is the dataset to do candidate matching across
preserve
keep state Year
duplicates drop
gsort state -Year
bys state: g election_index=_n
g _10_state_sample = state=="ANDHRA PRADESH" | state=="BIHAR" | state=="GUJARAT" | state=="HARYANA" | state=="KERALA" | state=="MAHARASHTRA" | state=="ORISSA" | state=="PUNJAB" | state=="RAJASTHAN" | state=="WEST BENGAL"
tab state _10
tempfile temp	
save `temp'
restore
merge m:1 state Year using `temp' , assert(3) nogen
save "$work/candidate_info_by_ACconstituency_indexed", replace

/* this section does a long string matching procedure -- only run when need to regenerate the underlying file
preserve
keep if election_index==2
g id_target = orig_cand_index
tempfile prev
save `prev', replace
restore
preserve
keep if election_index==1
g id_current = orig_cand_index
reclink Cand AC state gender using `prev', wmatch(20 20 1 1 ) idm(id_current) idu(id_target) required(state gender) gen(score)
g match =""
bys id_current: g current_cand_rank=_N
bys id_target: g target_cand_rank=_N
order id_current id_target id_current id_target score Cand	UCand match	state AC
gsort -_10_state_sample -score
outsheet using "$work/SA candidate matching_2_1.csv", comma names replace
restore
*/

insheet using "$work/SA candidate matching_2_1.csv", comma names clear
keep if score==1
keep id_current id_target cand ucand score
tempfile temp
save `temp'
insheet using "$data/mturk_sheets/match_state_assembly_names_1_2.csv", comma names clear
keep input* answer*
keep if answer=="SAME" | inputmatch=="Y"
drop if  inputmatch=="N"
drop inputmatch answer 
rename input* *
append using `temp'
duplicates drop
gsort id_current -score
bys id_current: g rank=_N
bys id_current: g rank2=_n
drop if rank==2 & rank2==2 //some duplicates in the rolls; these are otherwise exact matches so indicator of rerun valid either way
bys id_current: assert _N==1
drop rank*
gsort id_target -score
bys id_target: g rank=_N
bys id_target: g rank2=_n
//this is a temp fix; some of these need to be cleaned out manually previously due to bad mturker matching; see file "clean_mturk_matches_manually.csv" in the mturk_sheets folder
drop if rank>1 & rank2>1 //some duplicates in the rolls; these are otherwise exact matches so indicator of rerun valid either way
drop rank*
bys id_target: assert _N==1
drop score
renvars cand ucand \ Cand_mturk  Ucand_mturk
save `temp', replace


use "$work/candidate_info_by_ACconstituency_indexed", clear //this is the dataset to do candidate matching across
g id_current = orig_cand_index
bys  orig_cand_index: assert _N==1
keep if election_index==1
merge 1:1 id_current using `temp', assert(1 3) nogen
assert Cand_mturk ==Cand if !mi(Cand_mturk) 
drop *_mturk
//bring in previous finish information
rename orig_cand_index orig_cand_index_orig
g orig_cand_index = id_target
preserve
keep if !mi(orig_cand_index)
merge 1:1 orig_cand_index using "$work/candidate_info_by_ACconstituency", keepusing(cand_index) keep(1 3) nogen
tempfile matches
save `matches'
restore
keep if mi(orig_cand_index)
append using `matches'
drop orig_cand_index
rename cand_index prev_run_finish_position
rename orig_cand_index_orig  orig_cand_index

count if Sex=="F" & _10_state_sample & Year>2003 ///female candidates in the sample

save "$work/candidate_info_by_ACconstituency_indexed_matched", replace
erase "$work/candidate_info_by_ACconstituency_indexed.dta"


***construct measures
***construct measures
***create variables
replace Percent = "." if Percent=="NA" | Percent==""
replace Percent = subinstr(Percent,",",".",.)
replace Percent = subinstr(Percent,"%","",.)
destring Votes Percent, replace
g start = .
g count = 1
g female_candidate = Sex=="F"
g female_votes = female_candidate*Percent
gsort Year state AC -Percent
bys Year state AC : g winner = _n==1
bys Year state AC : g finish = _n
bys Year state AC : g total_cand = _N
g finish_pctile = 1-((finish-1)/total_cand)
drop total_cand
g top3 = finish<=3
g top5 = finish<=5
g top10th = finish_pctile>=.9
g top30th = finish_pctile>=.7
g top50th = finish_pctile>=.5
foreach i in 3 5 10th 30th 50th {
g female_finish_top`i' = female_candidate*top`i'
}
g female_winner=winner*female_candidate
g winmargin = Percent- Percent[_n+1] if winner==1 & state==state[_n+1] & AC == AC[_n+1]


g end=.

***Summary stats on F participation/candidacy***********************
tab Year Sex
tab Year Sex if winner
gsort Cand AC +Year
g any_prev_run = !mi(id_target)
g any_prev_win = prev_run_finish_position==1
g female_candidate_prev_run = Sex=="F"*any_prev_run 
g female_candidate_prev_win = Sex=="F"*any_prev_win
***
order female_candidate_prev_run female_candidate_prev_win, before(end)


//bring in Uppal's female turnout data
preserve
use "$data/Uppal_turnoutData/TurnoutData.dta", clear
replace state_name="BIHAR" if state_name=="Bihar (includes Jharkhand)"
replace state_name="MADHYA PRADESH" if state_name=="Madhya Pradesh (incl Chhattisgarh)"
replace state_name="UTTAR PRADESH" if state_name=="Uttar Pradesh (excludes Uttarakhand post-2000)"
replace state_name = upper(trim(state_name))
tab year
gsort  state_name year ac_id
bys state_name year ac_id: g rank = _N
tab rank
drop rank
rename ac_id AC_no
rename year Year
replace Year = 2005.5 if state_name=="BIHAR" & month==10
tempfile temp
save `temp'
restore

decode State_name, gen(state_name)
replace state_name = upper(trim(state_name))
merge m:1 state_name Year AC_no using `temp', keepusing(fturnout mturnout) keep(1 3) nogen


preserve
*select down
tab gender winner, mi //for summary table
tab gender any_prev_run, mi //for summary table
tab state Year
collapse (sum) start-end , by( state Year AC Turnout fturnout mturnout)
bys state AC: g rank=_N
tab rank
drop if rank>1 //these are constituencies in state with same name??!?! fix this later. difficult with mapfile because of merge on name so will have to be matched manually
g female_share_candidates = female_candidate/ count
g any_female_candidate = female_candidate!=0
g any_female_candidate_prev_run = female_candidate_prev_run>0
g any_female_candidate_prev_win = female_candidate_prev_win>0

//for summary table
count
sum count female_candidate any_female_candidate female_winner female_votes
sum female_winner if any_female_candidate == 1
//end for summary table



save "$work/candidacy_info_by_ACconstituency", replace
restore


keep if Year>=1989 & Year<=1992
tab State_name Year

collapse (sum) female_candidate count , by( state Year AC Turnout)
bys state AC: g rank=_N
tab rank
drop if rank>1 //these are constituencies in state with same name??!?! fix this later. difficult with mapfile because of merge on name so will have to be matched manually
g female_share_cand_prepolicy = female_candidate/ count
drop female_candidate count
save "$work/candidacy_info_by_ACconstituency_early", replace

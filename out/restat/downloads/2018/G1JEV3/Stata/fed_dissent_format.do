// 1.0 format 1993-2013 data
set more off
use "$pathF2\\FED_votes93_13f.dta", clear
drop date
bysort  role: tab vote  // Chairman (C) and Vice-Chairman never vote Against, neither are they Absent and Not Voting (ANV)
tab reason
g vote_policy = 0
replace vote_policy = 1 if reason=="MA"
replace vote_policy = -1 if reason=="LA"
g dissent = (vote_policy!=0)
g dissent_ma = (vote_policy==1)
g dissent_la = (vote_policy==-1)
sum diss*
bysort FOMC_p: sum diss*
bysort id_member: egen id_d = total(dissent)
bysort id_member: egen id_ma = total(dissent_ma)
bysort id_member: egen id_la = total(dissent_la)
foreach v of varlist id_d id_ma id_la { 
replace `v' = `v'/ nr_votes
}
save "$pathF2\\FED_dissent93_13f.dta", replace


// 1.1 Dissent behavior by individual governors (some do a substantial lot of dissent!)
use "$pathF2\\FED_dissent93_13f.dta", clear
collapse nr_votes id_d id_ma id_la, by(id_member members)
g dissent_one_or_more = (id_d>0)
tab dissent_one_or_more
tab id_d if dissent_one_or_more==1
tab id_ma if id_ma>0
tab id_la if id_la>0
sum id_d id_ma id_la if id_d>0, d
pwcorr id_d id_ma id_la nr_votes
pwcorr id_d id_ma id_la nr_votes if id_d>0
g nr_votes2 = nr_votes^2
probit dissent_one_or_more nr_votes nr_votes2
tobit id_d nr_votes nr_votes2, ll(0.00001)
tobit id_ma nr_votes nr_votes2, ll(0.00001)
tobit id_la nr_votes nr_votes2, ll(0.00001)
kdensity nr_votes if dissent_one_or_more==0
kdensity nr_votes if dissent_one_or_more==1
sum nr_votes if id_d>=0.10, d
sum nr_votes if id_d>=0.15, d
sum nr_votes if id_d>=0.25, d
sum nr_votes if id_d>=0.50, d
sum nr_votes if id_d>=0.60, d
save "$pathF2\\FED_dissent_governors.dta", replace
save "$path1\\FED_dissent_governors.dta", replace


// 1.2 - Create Dissent behavior by day of vote and by governor
use "$pathF2\\FED_dissent93_13f.dta", clear
tab  dissent_ma dissent_la // LA and MA never happen at same time
bysort date_day: egen nr_dissents = total(dissent)
bysort date_day: egen nr_dissents_ma = total(dissent_ma)
bysort date_day: egen nr_dissents_la = total(dissent_la)
sort date_day
egen date_FOMC = group(date_day)
sum date_FOMC //sum date_day
local d1=r(min)
local d2=r(max)
sum id_member
local i1=r(min)
local i2=r(max)
/* // For governors in first date, add past experience
// it seems an adj_v between 1.45 and 1.78 or 1.89 is reasonable for the first governors: I choose 1.615 
// which is the mean of 1.45 and 1.78
local adj_v = 1.615
display "`adj_v'"
replace nr_votes = ceil(nr_votes*`adj_v') if first_gov==1  */
local adj_v = 1.615
g exp_votes_all = .
g exp_votes_dissents = .
g exp_NO_dissents = .
quietly {
forv d=`d1'/`d2' {
g v_temp_diss = dissent if date_FOMC<`d'
replace v_temp_diss= 0 if v_temp_diss==. & date_FOMC<=`d'
g v_temp = id_member if date_FOMC<=`d'
bysort id_member: egen exp_votes_all0 = count(v_temp)
bysort id_member: egen v_temp_diss0 = max(dissent)
drop v_temp v_temp_diss
g v_temp = id_member if date_FOMC<=`d' & dissent==1
bysort id_member: egen exp_NO_dissents0 = count(v_temp)

replace exp_votes_all = exp_votes_all0 if date_FOMC==`d' 
replace exp_votes_dissents = exp_votes_all0 if date_FOMC==`d' & v_temp_diss0==1 // dissent==1
replace exp_NO_dissents = exp_NO_dissents0 if date_FOMC==`d' & v_temp_diss0==1 //  dissent==1
drop exp_votes_all0 exp_NO_dissents0 v_temp v_temp_diss0
*forv i=`i1'/`i2' {    *}
}
replace exp_votes_all = ceil(exp_votes_all*`adj_v') if first_gov==1
replace exp_votes_dissents = ceil(exp_votes_dissents*`adj_v') if first_gov==1
replace exp_NO_dissents = ceil(exp_NO_dissents*`adj_v') if first_gov==1
bysort date_day: egen exp_all_FOMC = total(exp_votes_all)
bysort date_day: egen exp_dissents_FOMC = total(exp_votes_dissents)
bysort date_day: egen exp_NO_FOMC = total(exp_NO_diss)
}
*xtset id_member date_day
xtset id_member date_FOMC
logit dissent exp_votes_all exp_all_FOMC exp_dissents_FOMC
xtlogit dissent exp_votes_all exp_all_FOMC exp_dissents_FOMC, re
clogit dissent exp_votes_all exp_all_FOMC exp_dissents_FOMC, group(id_member)
clogit dissent exp_all_FOMC exp_dissents_FOMC, group(id_member)
order date_day date_FOMC day month year quarter FOMC_* id_member ffr_nr, first
save "$pathF2\\FED_dissent_date_governors.dta", replace
save "$path1\\FED_dissent_date_governors.dta", replace //  // //

// 1.3 - Create Dissent behavior by day of vote
use "$pathF2\\FED_dissent_date_governors.dta", clear
collapse (max) dissen* nr_dissen* (mean) exp_* ffr_nr, by(date_day date_FOMC day month year quarter FOMC_*)
foreach v of varlist dissent dissent_ma dissent_la nr_dissents nr_dissents_ma nr_dissents_la { 
tab `v' 
bysort FOMC_p: tab `v' 
}
quietly {
sort date_day
tsset date_FOMC
g period_past_dissent = .
g period_total_dissent = .
g dissent_FW = F.dissent
g dissent_lag = L.dissent
forv d=`d1'/`d2' {
local d0=`d'-1
g v_temp = dissent if date_FOMC<=`d' & dissent==1
if `d'>1 {
forv dt=`d1'/`d0' {
g dissent_FW_temp = dissent_FW if date_FOMC>=`dt' & date_FOMC<`d'
egen dissent_FW_min = min(dissent_FW_temp) 
replace v_temp = . if date_FOMC==`dt' & dissent_FW_min==0
drop dissent_FW_temp dissent_FW_min
}
}
//  //  //
egen v_temp0 = count(v_temp)
replace period_past_dissent = v_temp0 if date_FOMC==`d' & dissent==1
replace period_total_dissent = v_temp0 if date_FOMC==`d' & dissent==1 & dissent_FW==0
drop v_tem* 
}
replace period_total_dissent = period_past_dissent if date_FOMC==`d2' & dissent==1
replace dissent_lag = 0 if dissent_lag==.
drop dissent_FW //dissent_lag
}
tab dissent
tab nr_dissents
tab dissent_ma
tab nr_dissents_ma
tab dissent_la
tab nr_dissents_la
sum period_past_dissent, d
tab period_total_dissent
sum period_total_dissent, d
tab period_total_dissent
save "$pathF2\\FED_dissent_date.dta", replace
save "$path1\\FED_dissent_date.dta", replace

clear
import excel "$pathF\\fed_votes_data\FED_votes_2018_1990.xlsx", sheet("data from 1990 until 2002") firstrow case(lower) //FED_votes_November2017.xlsx
g dummy_obs = 0 if members==""
replace dummy_obs =1 if dummy_obs==.
drop if dummy_obs==0
replace dummy_obs = 0 if date==""
generate date_day = date(date, "MDY")
sum dummy_obs
local No = r(N)
local k0 = 1
g obs_nr = _n
quietly {
forv k1=1/`No' {
sum date_day if obs_nr>=`k0' & obs_nr<=`k1' & dummy_obs==1
replace date_day = r(min) if date_day==. & obs_nr==`k1'
}
}
drop dummy_obs obs_nr
g FOMC_public_vote = 0
format %td date_day
g day = day(date_day)
g month = month(date_day)
g year = year(date_day)
g quarter = ceil(month/3)
sum month year day quarter date_day
egen id_member0 = group(members)
bysort id_member0: egen nr_votes = count(id_member0)
// For governors in first date, add past experience
g first_date0 = 0
g last_date0 = 0
sum date_day
replace first_date0 = 1 if date_day==r(min)
replace last_date0 = 1 if date_day==r(max)  
bysort id_member0: egen first_gov = max(first_date0)
bysort id_member0: egen last_gov = max(last_date0)
bysort id_member0: egen last_date = max(date_day)
sum nr_votes if first_gov==1 & date_day==last_date, d
local adj_v = r(median)
sum nr_votes if first_gov!=1 & date_day==last_date, d
local adj_v = min(2, max(1, r(median)/ `adj_v') )
quietly {
foreach num of numlist 5 10 25 {
sum nr_votes if first_gov==1 & date_day==last_date, d
local adj_v0 = r(p`num')
sum nr_votes if first_gov!=1 & date_day==last_date, d
local adj_v0 = min(2, max(1, r(p`num')/ `adj_v0') )                
local adj_v = max( `adj_v', `adj_v0'  )				
}
sum nr_votes if date_day==last_date & last_gov!=1, d
local n1 = r(p25)
local n2 = r(p75)
foreach num of numlist 10 25 50 {
sum nr_votes if first_gov==1 & date_day==last_date & nr_votes>=`n1' & nr_votes<=`n2', d
local adj_v0 = r(p`num')
sum nr_votes if first_gov!=1 & last_gov!=1 & date_day==last_date & nr_votes>=`n1' & nr_votes<=`n2', d
local adj_v0 = min(2, max(1, r(p`num')/ `adj_v0') )                
local adj_v = max( `adj_v', `adj_v0'  )				
}
sum nr_votes if date_day==last_date & last_gov!=1, d
local n1 = r(p10)
local n2 = r(p90)
foreach num of numlist 50 {
sum nr_votes if first_gov==1 & date_day==last_date & nr_votes>=`n1' & nr_votes<=`n2', d
local adj_v0 = r(p`num')
sum nr_votes if first_gov!=1 & last_gov!=1 & date_day==last_date & nr_votes>=`n1' & nr_votes<=`n2', d
local adj_v0 = min(2, max(1, r(p`num')/ `adj_v0') )                
local adj_v = max( `adj_v', `adj_v0'  )				
}
}
display "`adj_v'"
// it seems an adj_v between 1.45 and 1.78 or 1.89 is reasonable for the first governors: I choose 1.615 
// which is the mean of 1.45 and 1.78
local adj_v = 1.615
replace nr_votes = ceil(nr_votes*`adj_v') if first_gov==1
drop first_date0 last_date0  last_date
//  //  //  //
replace nr_votes = -nr_votes
sort nr_votes id_member0
egen id_member = group(nr_votes id_member0)
replace nr_votes = -nr_votes
drop id_member0

sort date_day id_member

g ffr_nr = ffr
replace ffr_nr = regexr(ffr_nr,"percent","")
g ffr_nr0 = substr(ffr_nr,1,1)
destring ffr_nr0, replace force
g ffr_nr12 = substr(ffr_nr,2,.)
g ffr_nr13 = substr(ffr_nr12,1,2)
replace ffr_nr13 = regexr(ffr_nr13,"/","")
replace ffr_nr13 = regexr(ffr_nr13,"-","")
g ffr_nr14 = substr(ffr_nr12,4,4)
destring ffr_nr13 ffr_nr14, replace force
g ffr_nr1 = ffr_nr13/ffr_nr14
drop ffr_nr
egen ffr_nr2 = rowtotal(ffr_nr0 ffr_nr1) if ffr_nr0<.
bysort date_day: egen ffr_nr = mean(ffr_nr2) 
drop  ffr_nr0-ffr_nr1 ffr_nr2 
order  date date_day day month year quarter FOMC_*, first
drop if year>=1994
save "$pathF2\FED_votes90_94.dta", replace

// 1.0 format 1993-2013 data
set more off
use "$pathF2\\FED_votes90_94.dta", clear
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
save "$pathF2\\FED_dissent90_94.dta", replace
save "$path1\\FED_dissent90_94.dta", replace

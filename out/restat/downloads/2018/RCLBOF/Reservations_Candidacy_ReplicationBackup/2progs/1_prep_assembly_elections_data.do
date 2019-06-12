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

use "$data/Jensenius_data/Jensenius_India_state_elections", clear

foreach i in Cand Sex Party Votes Percent {
	forval j = 1/301 {
		local vartype: type `i'`j'
		dis "`vartype'"
		if substr("`vartype'",1,3)!="str" { 
			local checklabel: value label `i'`j'
		    if !mi("`checklabel'"){
				decode `i'`j', g(temp)
				drop `i'`j'
				rename temp `i'`j'
			} 
			else {
			cap tostring `i'`j', replace
			}
		}
	}
}

reshape long Cand Sex Party Votes Percent , i(State_code2001 State_name Year AC_no AC_name AC_type Electors Voters Valid_votes Turnout) j(cand_index)

count
drop if Cand=="" | Cand=="NA"
count
save "$work/AC_cands_long", replace
*/
use "$work/AC_cands_long", clear
g orig_cand_index=_n //this defines a candidate index that will be used later. if processing above this line changes in any way; this will throw off other processes
la var orig_cand_index "Candidate-constituency-election unique ID. Created by SOC"
keep if Year>=1985
drop if Year==2005.5 //come back to this later when figuring out what is 2005.5
replace Year = 2005 if Year==2005.5

***this section contains minor cleaning that might improve the general usability of the data
***remove the reservation info out of AC name when it is there
tab State_name, mi
decode State_name, g(state)
replace state= upper(trim(state))
decode AC_name, g(AC)
replace AC= upper(trim(AC))
replace AC = trim(subinstr(AC, "(SC)","",.))
replace AC = trim(subinstr(AC, "(ST)","",.))
replace state = "GOA" if state=="GOA, DAMAN AND DIU" //just a reporting difference; not material
replace state = "UTTARANCHAL" if state=="UTTARAKHAND" //name change after state created; not material
*****end minor cleaning

***checking constituency NAME consistency over time
preserve
g cand = 1
collapse (sum) cand, by(state AC Year)
reshape wide cand, i(state AC) j(Year)
gsort state AC
outsheet using "$work/check_ACconst_over_time.csv", comma names replace
restore
***end constituency check


***implement constituency spelling standardization
preserve
insheet using "$work/check_ACconst_over_time_checked.csv", clear case
keep if !mi(spellingcorrection)
keep state AC spellingcorrection
tempfile spelling
save `spelling'
restore
merge m:1 state AC using `spelling', assert(1 3) nogen
replace AC = trim(spellingcorrection) if !mi(spellingcorrection)
drop spellingcorrection
tempfile AC
save `AC'

preserve
keep state AC Year
duplicates drop
tempfile temp
save `temp'
restore
***end constituency spelling standardization


**bring mismatch cleaning list back in and clean the AC names into map names
import excel using "$do/merge/clean_mapACconstituencies_for_ACelectionsdata_merge.xlsx", sheet("Sheet1") firstrow clear
keep if _merge =="using only (2)" //adjustments to the AC constituency names are identified by using rows from merge above
drop if constituency_replace==""
drop _m
tempfile temp2
save `temp2'

use `AC', clear
merge m:1 state AC using `temp2', assert (1 3) nogen
replace AC = constituency_replace if !mi(constituency_replace)
drop constituency_replace
g gender=Sex
*clean gender var
replace gender = "M" if gender!="F"
*clean state cars
replace state = "NCT OF DELHI" if state=="NATIONAL CAPITAL TERRITORY OF DELHI"
replace state = "UTTARAKHAND" if state=="UTTARANCHAL"
replace state = "JAMMU & KASHMIR" if state=="JAMMU AND KASHMIR"
*clean Candidate names
replace Cand = subinstr(Cand,"'","",.)
replace Cand = subinstr(Cand,"_","",.)
replace Cand = subinstr(Cand,"`","",.)
replace Cand = subinstr(Cand,`"""',"",.)
replace Cand = subinstr(Cand,"&quot;","",.)
replace Cand = subinstr(Cand,"(","",.)
replace Cand = subinstr(Cand,")","",.)
replace Cand = upper(trim(Cand))
save "$work/candidate_info_by_ACconstituency", replace //this is the dataset to do candidate matching across

***end standardized constituency name mapping to shapefile names

**constituencies now standardized conditional on making changes in map files for state cleaning***

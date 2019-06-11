
	cd "$directory"

	//previous see VA_BALLOTS_initialize
	//each line a year, precinct, race, candidate
	clear all
	use "virginia_pct_results_1997-2005.dta"
	
	//capture split precints
	collapse (sum) votes  , by(candidate year locality new_precinct_name new_location_code office registered_voters total_ballots party house_district sen_district perc_black_vap) 
	collapse (sum) votes registered_voters total_ballots, by(candidate year locality new_precinct_name new_location_code office party house_district sen_district perc_black_vap) 

	//find multiple cand's from same party on ballot 
	sort  year new_location_code office party  house_district sen_district  new_precinct_name candidate
	gen cand_num = 1 if year!=year[_n-1] | new_location_code !=new_location_code[_n-1] | office!=office[_n-1] | party!=party[_n-1] | house_district!=house_district[_n-1] | sen_district!=sen_district[_n-1] |  new_precinct_name!= new_precinct_name[_n-1] | candidate!=candidate[_n-1]
	replace cand_num = cand_num[_n-1]+1 if  new_location_code==new_location_code[_n-1] & office==office[_n-1] & party==party[_n-1] & house_district==house_district[_n-1] & sen_district==sen_district[_n-1] & new_precinct_name == new_precinct_name[_n-1] 

	//combine them
	replace candidate = candidate[_n-1] + " and " + candidate if cand_num > 1
	replace votes = votes + votes[_n-1] if cand_num > 1
	gen to_drop = .
	replace to_drop = 1 if cand_num[_n+1] > 1
	drop if to_drop == 1
	drop to_drop cand_num 
		drop if office == .
	//make wide, identify partisan variables, each line now year, precinct, race
	qui reshape wide candidate votes, i( year locality new_precinct_name new_location_code office registered_voters total_ballots sen_district house_district perc_black_vap) j( party) str

	//consolidate third parties and independents
	egen votesO = rsum(votesC votesG votesI votesL votesW votesV)
	drop votesC votesG votesI votesL votesW votesV
	drop candidateC candidateG candidateI candidateL candidateW candidateV

	//deal with duplicate races
	sort year new_location_code office  house_district sen_district candidateD
	gen race_num = 1 if year!=year[_n-1] | new_location_code !=new_location_code[_n-1] | office!=office[_n-1] | house_district!=house_district[_n-1] | sen_district!=sen_district[_n-1] 
	replace race_num= race_num[_n-1]+1 if year==year[_n-1] & new_location_code ==new_location_code[_n-1] & office==office[_n-1] & house_district==house_district[_n-1] & sen_district==sen_district[_n-1] 
	sort year new_location_code office new_precinct_name
	replace race_num= race_num[_n-1]+1 if year==year[_n-1] & new_location_code ==new_location_code[_n-1] & office==office[_n-1] & new_precinct_name==new_precinct_name[_n-1]

	//consolidate the district variable (this information is in "office" var
	tostring house_district, replace
	tostring sen_district, replace
	rename house_district district
	replace district = sen_district if office == 7
	replace district = "00"+district
	replace district = substr(district,-3,.)
	replace district = trim(district)

	keep if  office == 1 | office == 3 | office == 4 | office == 7 | office == 8

	//make office name a string so it can be used as a `j' in qui reshape
	gen office_name =""
	replace office_name = "_PRZ" if office == 1
	replace office_name = "_GOV" if office == 3
	replace office_name = "_LTG" if office == 4
	replace office_name = "_SEN" if office == 7 
	replace office_name = "_HOU" if office == 8 
	replace office_name = "_SEN" + string(race_num) if office == 7 & new_precinct_name != "conditional votes" & new_precinct_name != "central absentee precinct"
	replace office_name = "_HOU" + string(race_num) if office == 8 & new_precinct_name != "conditional votes" & new_precinct_name != "central absentee precinct"
	replace new_location_code = new_location_code+"_"+string(race_num) if new_precinct_name == "conditional votes" | new_precinct_name == "central absentee precinct"
    replace office_name = "_HOU1" if office == 8 & (new_precinct_name == "conditional votes" | new_precinct_name == "central absentee precinct")
    replace office_name = "_SEN1" if office == 7 & (new_precinct_name == "conditional votes" | new_precinct_name == "central absentee precinct")
	
	drop office
	drop race_num

	drop sen_district
replace district = "" if office == "_GOV" | office == "_LTG" | office == "_PRZ"
//qui reshape, each line now a precinct-year
qui reshape wide candidate* votes* registered_voters total_ballots district, i( year locality new_precinct_name new_location_code perc_black_vap) j(office_name) str


//generate total number of votes from data
local office = "HOU1 HOU2 HOU3 HOU4 SEN1 SEN2"
local party = "D R O"
local variable = "registered_voters total_ballots"
foreach temp of local office {
foreach temp2 of local party  {
egen temp = rsum(votes`temp2'_`temp'*)
drop votes`temp2'_`temp'*
rename temp votes`temp2'_`temp'
}
egen total_votes_`temp' = rsum(votesD_`temp' votesR_`temp' votesO_`temp')
foreach temp3 of local variable {
egen temp = rsum(`temp3'_`temp'*)
drop `temp3'_`temp'*
rename temp `temp3'_`temp'
}
}

egen total_votes_LTG = rsum(votesD_LTG votesR_LTG votesO_LTG)
egen total_votes_PRZ = rsum(votesD_PRZ votesR_PRZ votesO_PRZ)
egen total_votes_GOV = rsum(votesD_GOV votesR_GOV votesO_GOV)

foreach i of numlist 1/4{
gen roll_off_HOU`i' = 1-(total_votes_HOU`i'/total_ballots_HOU`i')
}
foreach i of numlist 1/2{
gen roll_off_SEN`i' = 1-(total_votes_SEN`i'/total_ballots_SEN`i')
}
gen roll_off_GOV = 1-(total_votes_GOV/total_ballots_GOV)
gen roll_off_LTG = 1-(total_votes_LTG/total_ballots_LTG)

//determine if race is contested
foreach i of numlist 1/4{
gen contested_HOU`i' = 0 
replace contested_HOU`i' = 1 if candidateR_HOU`i' !="" & candidateD_HOU`i' !=""
}

forvalues i = 1(1) 2 {
gen contested_SEN`i' = 0 
replace contested_SEN`i' = 1 if candidateR_SEN`i' !="" & candidateD_SEN`i' !=""
}

//Establish what is in the sample
//eventually, we only want contested races, without extreme swings due to redistricting

forvalues i = 1(1) 4 {
gen insample_HOU`i' = contested_HOU`i'
}
forvalues i = 1(1) 2 {
gen insample_SEN`i' = contested_SEN`i'
}

drop contested*

//convert year to string to add as `j' for qui reshape
tostring year, replace
replace year = "_"+year

//rehape, now each line is a precinct
 qui reshape wide /*
 */	votesR*	/*
*/	votesO*	/*
*/	votesD*	/*
*/	total_ballots*	/*
*/	total_votes*	/*
*/	roll_off*	/*
*/	registered_voters*	/*
*/	insample*	/*
*/	district*	/*
*/	candidateR*	/*
*/	candidateD*	/*
*/perc_black_vap/*
*/, i(locality new_precinct_name new_location_code) j(year) str
//find any precinct that was in a different district in 99/01/03


forvalues i = 1(1)4{
gen redistricted_HOU`i' = 1 if district_HOU`i'_1999 != district_HOU`i'_2001
} 


forvalues i = 1(1)2{
gen redistricted_SEN`i' = 1 if district_SEN`i'_1999 != district_SEN`i'_2003
}

//create sample for precints that were competitive in both
gen temp=0
forvalues i = 1(1) 4 {
replace temp = 0
replace temp = 1 if insample_HOU`i'_1999 == 1 & insample_HOU`i'_2001 == 1 
//replace temp = 1 if insample_HOU`i'_1999 == 1 & insample_HOU`i'_2003 == 1
drop insample_HOU`i'*
rename temp insample_HOU`i'
gen temp = 0
}

forvalues i = 1(1) 2 {
replace temp = 0
replace temp = 1 if insample_SEN`i'_1999 == 1 & insample_SEN`i'_2003 == 1 
drop insample_SEN`i'*
rename temp insample_SEN`i'
gen temp = 0
}
drop temp

gen insample_GOV = 1
gen insample_LTG = 1

gen temp = registered_voters_HOU1_2001/registered_voters_HOU1_1999
//hist temp
forvalues i = 1(1) 4 {
replace insample_HOU`i' = 0 if ((temp > 1.5) | (temp < 1 / 1.5)) 
}
replace insample_GOV = 0 if ((temp >1.5) | (temp < 1 / 1.5))  
replace insample_LTG = 0 if ((temp >1.5) | (temp < 1 / 1.5))  
drop temp

gen temp = registered_voters_SEN1_2003/registered_voters_SEN1_1999
//hist temp
forvalues i = 1(1) 2 {
replace insample_SEN`i' = 0 if ((temp > 1.5) | (temp < 1 / 1.5)) 
}
drop temp

gen gopprezvoteshare = votesR_PRZ_2000 /(votesD_PRZ_2000 + votesR_PRZ_2000)

//create a subsample of the Governor and Lt. Governor races for the later HOU and SEN samples

gen insamp2_HxG_GOV = 0
replace insamp2_HxG_GOV = 1 if insample_HOU1 == 1
replace insamp2_HxG_GOV = 0 if total_votes_GOV_1997 ==.

gen insamp2_HxL_LTG = 0
replace insamp2_HxL_LTG = 1 if insample_HOU1 == 1
replace insamp2_HxL_LTG = 0 if total_votes_LTG_1997 ==.

gen insamp2_SxG_GOV = 0
replace insamp2_SxG_GOV = 1 if insample_SEN1 == 1
replace insamp2_SxG_GOV = 0 if total_votes_GOV_1997 ==.

gen insamp2_SxL_LTG = 0
replace insamp2_SxL_LTG = 1 if insample_SEN1 == 1
replace insamp2_SxL_LTG  = 0 if total_votes_LTG_1997 ==.

//clean up any races that miss the 1997 gov or lt. gov races
local office = "HOU1 HOU2 HOU3 HOU4 SEN1 SEN2 GOV LTG"
foreach temp of local office {
replace insample_`temp' = 0 if total_votes_GOV_1997 == .
replace insample_`temp' = 0 if total_votes_LTG_1997 == .
}
//drop useless variables
drop district_PRZ* district_LTG* district_GOV* 

gen share_black = perc_black_vap_2000
drop perc_black*

qui reshape long /*
*/	candidateD_GOV_@	/*
*/	candidateD_HOU1_@	/*
*/	candidateD_HOU2_@	/*
*/	candidateD_HOU3_@	/*
*/	candidateD_HOU4_@	/*
*/	candidateD_LTG_@	/*
*/	candidateD_PRZ_@	/*
*/	candidateD_SEN1_@	/*
*/	candidateD_SEN2_@	/*
*/	candidateD_SEN3_@	/*
*/	candidateR_GOV_@	/*
*/	candidateR_HOU1_@	/*
*/	candidateR_HOU2_@	/*
*/	candidateR_HOU3_@	/*
*/	candidateR_HOU4_@	/*
*/	candidateR_LTG_@	/*
*/	candidateR_PRZ_@	/*
*/	candidateR_SEN1_@	/*
*/	candidateR_SEN2_@	/*
*/	candidateR_SEN3_@	/*
*/	district_HOU1_@	/*
*/	district_HOU2_@	/*
*/	district_HOU3_@	/*
*/	district_HOU4_@	/*
*/	district_SEN1_@	/*
*/	district_SEN2_@	/*
*/	district_SEN3_@	/*
*/	registered_voters_GOV_@	/*
*/	registered_voters_HOU1_@	/*
*/	registered_voters_HOU2_@	/*
*/	registered_voters_HOU3_@	/*
*/	registered_voters_HOU4_@	/*
*/	registered_voters_LTG_@	/*
*/	registered_voters_PRZ_@	/*
*/	registered_voters_SEN1_@	/*
*/	registered_voters_SEN2_@	/*
*/	registered_voters_SEN3_@	/*
*/	roll_off_GOV_@	/*
*/	roll_off_HOU4_@	/*
*/	roll_off_HOU1_@	/*
*/	roll_off_HOU2_@	/*
*/	roll_off_HOU3_@	/*
*/	roll_off_LTG_@	/*
*/	roll_off_SEN1_@	/*
*/	roll_off_SEN2_@	/*
*/	total_ballots_GOV_@	/*
*/	total_ballots_HOU1_@	/*
*/	total_ballots_HOU2_@	/*
*/	total_ballots_HOU3_@	/*
*/	total_ballots_HOU4_@	/*
*/	total_ballots_LTG_@	/*
*/	total_ballots_PRZ_@	/*
*/	total_ballots_SEN1_@	/*
*/	total_ballots_SEN2_@	/*
*/	total_ballots_SEN3_@	/*
*/	total_votes_GOV_@	/*
*/	total_votes_HOU1_@	/*
*/	total_votes_HOU2_@	/*
*/	total_votes_HOU3_@	/*
*/	total_votes_HOU4_@	/*
*/	total_votes_LTG_@	/*
*/	total_votes_PRZ_@	/*
*/	total_votes_SEN1_@	/*
*/	total_votes_SEN2_@	/*
*/	total_votes_SEN3_@	/*
*/	votesD_GOV_@	/*
*/	votesD_HOU1_@	/*
*/	votesD_HOU2_@	/*
*/	votesD_HOU3_@	/*
*/	votesD_HOU4_@	/*
*/	votesD_LTG_@	/*
*/	votesD_PRZ_@	/*
*/	votesD_SEN1_@	/*
*/	votesD_SEN2_@	/*
*/	votesD_SEN3_@	/*
*/	votesO_GOV_@	/*
*/	votesO_HOU1_@	/*
*/	votesO_HOU2_@	/*
*/	votesO_HOU3_@	/*
*/	votesO_HOU4_@	/*
*/	votesO_SEN1_@	/*
*/	votesO_SEN2_@	/*
*/	votesO_SEN3_@	/*
*/	votesO_LTG_@	/*
*/	votesO_PRZ_@	/*
*/	votesR_GOV_@	/*
*/	votesR_HOU1_@	/*
*/	votesR_HOU2_@	/*
*/	votesR_HOU3_@	/*
*/	votesR_HOU4_@	/*
*/	votesR_SEN1_@	/*
*/	votesR_SEN2_@	/*
*/	votesR_SEN3_@	/*
*/	votesR_LTG_@	/*
*/	votesR_PRZ_@	/*
*/, i(new_precinct_name locality new_location_code share_black gopprezvoteshare) j(year) str

//convert year back to float
destring year, replace

//fix names that got messed up in the reshapes
run 06_30_14_p3_namefix.do
drop *_SEN3*
qui reshape long /*
*/	candidateD@		/*
*/	candidateR@		/*
*/	district@		/*
*/	insample@		/*
*/	redistricted@		/*
*/	registered_voters@		/*
*/	roll_off@		/*
*/	total_votes@		/*
*/	total_ballots@		/*
*/	votesD@		/*
*/	votesO@		/*
*/	votesR@		/*
*/	insamp2_SxL@		/*
*/	insamp2_HxG@		/*
*/	insamp2_HxL@		/*
*/	insamp2_SxG@		/*
*/,i( year new_location_code new_precinct_name share_black gopprezvoteshare) j(office_name) str

save "virginia_pct_results_1997-2005_3_2001.dta", replace
//this is a large file >140mb, contact agarlick@sas.upenn.edu for a copy.

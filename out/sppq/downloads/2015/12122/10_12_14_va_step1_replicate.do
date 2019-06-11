/*
NB: Set this global directory, it is called at the top of each do file
*/

global directory "/Users/AG/Desktop/REP-DATA-SPPQ/"

/*
1 - 1999
*/

cd "$directory"

clear all
insheet using "Results-SEN-and-HOD-Nov99-Gen.csv"

gen year = 1999

rename pct_name precinct_name

//generate the location codes

//prep localities
rename loc_code locality_code
tostring locality_code, replace
replace locality_code = "00"+locality_code
replace locality_code = substr(locality_code,-3,.)
replace locality_code = trim(locality_code)

//prep precints - this should capture the conditional votes too
rename pct_code precinct_code
replace precinct_code = "000"+precinct_code
replace precinct_code = substr(precinct_code,-4,.)

//gen the loc-code
gen location_code = ""
replace location_code = locality_code + "-" + precinct_code

rename offisscode office

gen house_district = dist_code if office == 8
gen sen_district = dist_code if office == 7
rename reg_voters registered_voters
rename tot_voting total_ballots

rename cand_issue candidate
split candidate, p("(")
replace candidate2 = "W" if candidate == "WRITE INS"
replace candidate2 = substr(candidate2,1,1)
rename candidate2 party
replace candidate1 = trim(candidate1)
drop candidate
rename candidate1 candidate

rename votes_rcvd votes

keep year locality locality_code precinct_name precinct_code location_code office total_ballots candidate party votes house_district sen_district registered_voters

save "virginia_pct_results_1999.dta", replace


/*
2 - 2001
*/
clear all
insheet using "ElectionResults-Nov2001.csv"

gen year = 2001 

rename pct_name precinct_name

//generate the location codes

//prep localities
rename loc_code locality_code
tostring locality_code, replace
replace locality_code = "00"+locality_code
replace locality_code = substr(locality_code,-3,.)
replace locality_code = trim(locality_code)

//prep precints - this should capture the conditional votes too
rename pct_code precinct_code
replace precinct_code = "000"+precinct_code
replace precinct_code = substr(precinct_code,-4,.)

//gen the loc-code
gen location_code = ""
replace location_code = locality_code + "-" + precinct_code

rename offisscode office

gen house_district = dist_code if office == 8
gen sen_district = dist_code if office == 7
rename regvoters registered_voters
rename totalvoting total_ballots

rename cand_issue candidate
split candidate, p("(")
replace candidate2 = "W" if candidate == "WRITE INS"
replace candidate2 = substr(candidate2,1,1)
rename candidate2 party
replace candidate1 = trim(candidate1)
drop candidate
rename candidate1 candidate

rename votes_rcvd votes

keep year locality locality_code precinct_name precinct_code location_code office total_ballots candidate party votes house_district sen_district registered_voters

save "virginia_pct_results_2001.dta", replace


/*
3 - 2003
*/

clear all
insheet using "ElectionResults-Nov2003.csv"

gen year = 2003 

//locality 

//generate the location codes

//prep localities
rename localitycode locality_code
tostring locality_code, replace
replace locality_code = "00"+locality_code
replace locality_code = substr(locality_code,-3,.)
replace locality_code = trim(locality_code)

//prep precints - this should capture the conditional votes too

rename precinctname precinct_name
rename precinctcode precinct_code
replace precinct_code = "000"+precinct_code
replace precinct_code = substr(precinct_code,-4,.)

//gen the loc-code
gen location_code = ""
replace location_code = locality_code + "-" + precinct_code

rename officecode office

gen house_district = districtcode if office == 8
gen sen_district = districtcode if office == 7
rename totalregisteredvoters registered_voters
rename totalvoting total_ballots

split candidate, p("(")
replace candidate2 = "W" if candidate == "WRITE INS"
replace candidate2 = substr(candidate2,1,1)
rename candidate2 party
replace candidate1 = trim(candidate1)
drop candidate
rename candidate1 candidate

rename votesreceived votes
destring house_district, replace
destring sen_district, replace
keep year locality locality_code precinct_name precinct_code location_code office total_ballots candidate party votes house_district sen_district registered_voters

save "virginia_pct_results_2003.dta", replace


/*
4 - 2005
*/

clear all
insheet using "ElectionResults-Nov-8-2005.csv"

gen year = 2005 

rename pct_name precinct_name

//generate the location codes

//prep localities
rename loc_code locality_code
tostring locality_code, replace
replace locality_code = "00"+locality_code
replace locality_code = substr(locality_code,-3,.)
replace locality_code = trim(locality_code)

//prep precints - this should capture the conditional votes too
rename pct_code precinct_code
replace precinct_code = "000"+precinct_code
replace precinct_code = substr(precinct_code,-4,.)

//gen the loc-code
gen location_code = ""
replace location_code = locality_code + "-" + precinct_code

rename offisscode office

gen house_district = dist_code if office == 8
gen sen_district = dist_code if office == 7
rename reg_voters registered_voters
rename tot_voting total_ballots

rename cand_issue candidate
split candidate, p("(")
replace candidate2 = "W" if candidate == "WRITE INS"
replace candidate2 = substr(candidate2,1,1)
rename candidate2 party
replace party = "R" if party == "C"
replace candidate1 = trim(candidate1)
drop candidate
rename candidate1 candidate

rename votes_rcvd votes

keep year locality locality_code precinct_name precinct_code location_code office total_ballots candidate party votes house_district sen_district registered_voters

save "virginia_pct_results_2005.dta", replace

/*
5A
*/
clear all
insheet using "VA.csv"
rename preccode precinct_code
rename precname precinct_name
rename locname locality
split precinct_code, parse(,)
split precinct_name, p(/)
foreach i of numlist 1/4{
qui replace precinct_name`i' = subinstr(precinct_name`i', "(", "",.) 
qui replace precinct_name`i' = subinstr(precinct_name`i', ")", " ",.) 
qui replace precinct_name`i' = subinstr(precinct_name`i', "1", "",.) 
qui replace precinct_name`i' = subinstr(precinct_name`i', "2", "",.) 
qui replace precinct_name`i' = subinstr(precinct_name`i', "3", "",.) 
qui replace precinct_name`i' = subinstr(precinct_name`i', "4", "",.) 
qui replace precinct_name`i' = subinstr(precinct_name`i', "5", "",.) 
qui replace precinct_name`i' = subinstr(precinct_name`i', "6", "",.) 
qui replace precinct_name`i' = subinstr(precinct_name`i', "7", " ",.) 
qui replace precinct_name`i' = subinstr(precinct_name`i', "8", "",.) 
qui replace precinct_name`i' = subinstr(precinct_name`i', "9", "",.) 
qui replace precinct_name`i' = subinstr(precinct_name`i', "*", "",.)
qui replace precinct_name`i' = subinstr(precinct_name`i', "0", "",.)  
qui replace precinct_name`i' = upper(precinct_name`i')
qui replace precinct_name`i' = trim(precinct_name`i')
}

replace precinct_name1 = "2-1" if prcnmcen == "Precinct 2-1 (201)/Precinct 3-1 (301)"
replace precinct_name2 = "3-1" if prcnmcen == "Precinct 2-1 (201)/Precinct 3-1 (301)"
replace precinct_name2 = "HOWARD 4TH GRADE CENTER" if prcnmcen == "HOWARD TH GRADE CENTER"

expand 2 if precinct_name3 != "",gen(three_dupes)
expand 2 if precinct_name2 != "",gen(two_dupes)

replace precinct_name = precinct_name3 if two_dupes == 0 & three_dupes == 1  
replace precinct_name = precinct_name2 if two_dupes == 1 & three_dupes == 0
replace precinct_name = precinct_name1 if two_dupes == 0 & three_dupes == 0 & precinct_name2 != ""
replace precinct_name = precinct_name3 if two_dupes == 1 & three_dupes == 1  
replace precinct_name = precinct_name4 if two_dupes == 1 & three_dupes == 1 & precinct_name4 != ""
replace precinct_name = subinstr(precinct_name, "'", "",.) 

replace precinct_code = precinct_code3 if two_dupes == 0 & three_dupes == 1  
replace precinct_code = precinct_code2 if two_dupes == 1 & three_dupes == 0
replace precinct_code = precinct_code1 if two_dupes == 0 & three_dupes == 0 & precinct_code2 != ""
replace precinct_code = precinct_code3 if two_dupes == 1 & three_dupes == 1  
replace precinct_code = precinct_code4 if two_dupes == 1 & three_dupes == 1 & precinct_code4 != ""
drop if two_dupes == 1 & three_dupes == 1 & precinct_code4 == ""
replace precinct_code = trim(precinct_code)
replace precinct_code = "000"+precinct_code
replace precinct_code = substr(precinct_code,-4,.)

duplicates tag locality precinct_name, gen(doubletrouble)
drop if doubletrouble == 1 & prcnmcen == "."
drop if dup > 0 & prcnmcen == "."
drop if prcnmcen == "."

/* hard-coding fixes from the _merge
*/
replace precinct_name = "PRECINCT 2-1" if locality == "COVINGTON CITY" & precinct_code == "0201"
replace precinct_name = "PRECINCT 3-1" if locality == "COVINGTON CITY" & precinct_code == "0301"
replace precinct_name = "HIWASSEE" if locality == "PULASKI COUNTY" & precinct_code == "0302"
replace precinct_name = "WEST ONE PRECINCT" if locality == "RADFORD CITY" & precinct_code == "0002"
replace precinct_name = "WEST TWO PRECINCT" if locality == "RADFORD CITY" & precinct_code == "0003"
replace precinct_name = "HOWARD NINTH GRADE CENTER" if locality == "ALEXANDRIA CITY" & precinct_code == "0206"
replace precinct_name = "SECOND PRESBYTERIAN CHURCH" if locality == "ALEXANDRIA CITY" & precinct_code == "0205"
replace precinct_name = "FORKS OF JOHNS CREEK" if locality == "CRAIG COUNTY" & precinct_code == "0404"
replace precinct_name = "SOUTH SALEM NO. 2" if locality == "SALEM CITY" & precinct_code == "0007"
replace precinct_name = "RHEA VALLEY" if locality == "WASHINGTON COUNTY" & precinct_code == "0501"
replace precinct_name = "THIRTY EIGHT" if locality == "PORTSMOUTH CITY" & precinct_code == "0038"
replace precinct_name = "WILLIAMSON ROAD 3" if locality == "ROANOKE CITY" & precinct_code == "0012"
/* END HARD CODING
*/

drop precinct_name1-precinct_name4 precinct_code1-precinct_code4 *dupes doubletrouble

tostring locfips, force gen(locality_code)
replace locality_code = "00"+locality_code
replace locality_code = substr(locality_code,-3,.)

local groups "poptot popwht popblk popamind popasian pophawpi popoth popmulti pophisp pophwht pophblk pophoth vaptot vapwht vapblk vapamind vapasian vaphawpi vapoth vapmulti vaphisp vaphwht vaphblk vaphoth"
foreach l of local groups{
qui destring `l', ignore(,) force replace
}

gen perc_black_pop = popblk/poptot
gen perc_black_vap = vapblk/vaptot
save "virginia_2000_demographics.dta", replace

gen year = 2000

keep locality_code precinct_code locality precinct_name perc_black_pop perc_black_vap year
drop if precinct_name == "CENTRAL ABSENTEE PRECINCT" | precinct_name == "CONDITIONAL VOTES"

save "virginia_demographics_import.dta", replace

use "virginia_2000_demographics.dta", replace

collapse (sum) poptot- vaphoth, by(locality locality_code)
//replace poptot = popwht + popblk +  popamind +  popasian  + pophawpi  + popoth  + popmulti  + pophisp  + pophwht  +  pophblk  + pophoth if poptot == 0
//replace vaptot = vapwht + vapblk +  vapamind +  vapasian +  vaphawpi +  vapoth  + vapmulti  + vaphisp  + vaphwht +  vaphblk  + vaphoth if vaptot == 0
gen perc_black_pop = popblk/ poptot
gen perc_black_vap = vapblk/ vaptot

expand 2, gen(dupes)
gen precinct_name = "CENTRAL ABSENTEE PRECINCT" if dupes == 0
replace precinct_name = "CONDITIONAL VOTES" if dupes == 1
gen precinct_code = "00AB" if precinct_name == "CENTRAL ABSENTEE PRECINCT"
replace precinct_code = "00CV" if precinct_name == "CONDITIONAL VOTES"
gen year = 2000
keep locality_code precinct_code locality precinct_name perc_black_pop perc_black_vap year
append using "virginia_demographics_import.dta"
save "virginia_demographics_import.dta", replace
/*
5b - 2000
*/

clear all
insheet using "VA_2000-04combo.csv"
replace precinctname = upper(precinctname)
rename localitycode locality_code
rename precinctcode precinct_code
rename precinctname precinct_name

split candidate, p("[")
replace candidate2 = "W" if candidate == "WRITE INS"
replace candidate2 = substr(candidate2,1,1)
rename candidate2 party
replace candidate1 = trim(candidate1)
drop candidate
rename candidate1 candidate

gen total_ballots = .
gen house_district = .
gen sen_district = .
gen registered_voters = .
tostring locality_code, replace
destring votes, ignore(,) replace
keep year locality locality_code precinct_name precinct_code location_code office total_ballots candidate party votes house_district sen_district registered_voters

save "virginia_pct_results_2000-2004.dta", replace
clear all
use "virginia_pct_results_2000-2004.dta"
merge m:m locality precinct_name using "virginia_demographics_import.dta"
drop _merge
save "virginia_pct_results_2000-2004.dta", replace
/*
6 - 1997
*/

clear all
insheet using "ElectionResults-Nov1997.csv"
gen year = 1997
drop id

rename localitycode locality_code
tostring locality_code, replace
replace locality_code = "00"+locality_code
replace locality_code = substr(locality_code,-3,.)
replace locality_code = trim(locality_code)


rename localityname  locality
rename precinctcode precinct_code
tostring precinct_code, replace
replace precinct_code = "000"+precinct_code
replace precinct_code = substr(precinct_code,-4,.)

//gen the loc-code
gen location_code = ""
replace location_code = locality_code + "-" + precinct_code

rename precinctname precinct_name

rename democrat votes_D
rename republican votes_R
rename v votes_V
rename writeins votes_W

destring votes_D, ignore(,) replace
destring votes_R, ignore(,) replace

drop govtotal

reshape long votes_@, i( office locality_code locality precinct_code precinct_name) j(party) str
rename votes_ votes

//tostring office, replace
gen candidate = ""
replace candidate = "D S BEYER JR" if party == "D" & office == 3
replace candidate = "L F PAYNE JR" if party == "D" & office == 4

replace candidate = "J S GILMORE III" if party == "R" & office == 3
replace candidate = "J H HAGER" if party == "R" & office == 4

replace candidate = "S H DEBAUCHE" if party == "V" & office == 3
replace candidate = "B E EVANS" if party == "V" & office == 4

replace candidate = "WRITE INS" if party == "W"


gen total_ballots = .
gen house_district = .
gen sen_district = .
gen registered_voters = .

keep year locality locality_code precinct_name precinct_code location_code office total_ballots candidate party votes house_district sen_district registered_voters

save "virginia_pct_results_1997.dta", replace


/*
7 - Append them together
*/

clear all
use "virginia_pct_results_1997.dta"
append using "virginia_pct_results_2000-2004.dta"
append using "virginia_pct_results_2005.dta"
append using "virginia_pct_results_2003.dta"
append using "virginia_pct_results_2001.dta"
append using "virginia_pct_results_1999.dta"
replace candidate = trim(candidate)
replace party = "R" if candidate == "J J WELCH"
compress
saveold "virginia_pct_results_1997-2005_combined.dta", replace


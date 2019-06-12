
	cd "$directory"

	use "virginia_pct_results_1997-2005_3_2001", clear
	replace redistricted = 0 if redistricted == .
foreach i of numlist 2/4{
drop if office_name == "_HOU`i'" &  votesD == 0 & votesR == 0 & votesO == 0 & total_votes == 0 
}	

drop if office_name == "_SEN2" &  votesD == 0 & votesR == 0 & votesO == 0 & total_votes == 0 
	
gen office_name2 = office_name
	
	forvalues i = 1(1) 4 {
replace office_name2 = "_HOU" if office_name == "_HOU`i'"
replace office_name2 = "_SEN" if office_name == "_SEN`i'"
}

drop office_name
rename office_name2 office_name
	
//Prepare location_code for the fixed effects specification
encode new_location_code, gen(location_code_n)

//get voteshare varaibles including Normal Presidential vote per precinct.
gen gopvoteshare = votesR / (votesR + votesD)

//create the interaction terms for the diff-in-diff
gen post2000 =0
replace post2000 = 1 if year >2000
gen gopprezshareXpost2000 = gopprezvoteshare*post2000

//label the variables
label var gopprezshareXpost2000 "/%Bush2000xPost2000"
label var post2000 "Post2000"
label var gopvoteshare "GOP Voteshare"
label var gopvoteshare "2000 GOP Presidential Voteshare"
label var gopprezvoteshare "%Bush2000"

	//generate the samples -- currently all contested precints are in.


	replace insample = 0 if office_name == "_GOV" & year != 1997 & year != 2001
	replace insample = 0 if office_name == "_LTG" & year != 1997 & year != 2001
	replace insample = 0 if office_name == "_SEN" & year != 1999 & year != 2003
	replace insample = 0 if office_name == "_HOU" & year != 1999 & year != 2003
	replace insamp2_HxG = 0 if year != 1997 & year != 2001
	replace insamp2_HxL = 0 if year != 1997 & year != 2001
	replace insamp2_SxG = 0 if year != 1997 & year != 2001
	replace insamp2_SxL = 0 if year != 1997 & year != 2001
	gen insamp3_HOU = 0
	gen insamp3_SEN = 0
	replace insamp3_HOU = 1 if (year == 1999 & office_name == "_HOU" & candidateD != "" & candidateR !="") | (year == 2003 & office_name == "_HOU" & candidateD != "" & candidateR !="") 
	replace insamp3_SEN = 1 if (year == 1999 & office_name == "_SEN" & candidateD != "" & candidateR !="") | (year == 2003 & office_name == "_SEN" & candidateD != "" & candidateR !="") 

//	cd "/Users/AG/Dropbox/PhD - Third Year/Ballot Labels/STATA Code/october reboot/rr2"
	//2003
	//va house
	eststo clear

	eststo: qui xtreg gopvoteshare gopprezshareXpost2000 post2000  ///
	if office_name=="_HOU" & insample==1, i(location_code_n) fe robust
	
	eststo: qui xtreg gopvoteshare gopprezshareXpost2000 post2000  ///
	if office_name=="_HOU" & insample==1 & redistrict != 1, i(location_code_n) fe robust

	esttab, se label ///
title(SPPQ TABLE 5 COLUMNS 4-5) ///
mtitles( "FX:Pre" "redist") ///
b(3) se(3) ///
nodepv ///
star(* 0.05 ** 0.01) 

rename share_black perc_black_vap

replace perc_black_vap = 0 if perc_black_vap == .
gen perc_black_vapXpost2000 = post2000 * perc_black_vap


//OLS
eststo clear
eststo: qui reg roll_off post2000 if insamp3_HOU == 1 & office_name == "_HOU", robust
eststo: qui reg roll_off post2000 if insample == 1 & office_name == "_HOU", robust
eststo: qui reg roll_off post2000 perc_black_vap perc_black_vapXpost2000  if insamp3_HOU == 1 & office_name == "_HOU", robust
esttab , se label ///
title(SPPQ TABLE 3 COLUMNS 9-11) ///
	mtitles("HOU" "both" "hou") ///
	b(3) se(3) ///
	star(^ 0.10 * 0.05 ** 0.01) ///
	nodepv



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
tempfile main

***input and clean up 2014
foreach j in 2014 2009 2004 1999 1998 1996 1991 1989 {
import excel "$data/empoweringindia/empoweringindia_`j'.xlsx",sheet("Sheet1") allstring case(lower) firstrow clear
if `j'== 1996 {
preserve
import excel "$data/empoweringindia/empoweringindia_`j'_addl.xlsx",sheet("Sheet1") allstring case(lower) firstrow clear
bys state: tab constituency if candidatename=="missing"
tempfile extra
save `extra'
restore
append using `extra'
preserve
*******************************THIS SECTION BRINGS IN DATA FOR ORISSA IN 1996. NOTE NO GENDER INFO
import excel "$data/indiavotes-scrape-notebook/full_set/output.xlsx", sheet("General") firstrow case(lower) clear
keep if year=="1996"
keep if state=="Orissa"
keep area
replace area = trim(upper(area))
tempfile O1996
save `O1996'

import excel "$data/indiavotes-scrape-notebook/full_set/output.xlsx", sheet("Candidates") firstrow case(lower) clear
keep if year=="1996"
replace area = trim(upper(area))
merge m:1 area using `O1996', keep(3) nogen
g state = "ORISSA"
destring year, replace
renvars area name votes f \ constituency candidatename votes_count votes_polled
drop year
replace votes_polled = subinstr(votes_polled, "%","",.)
replace votes_polled = subinstr(votes_polled, ",","",.)
drop position
save `O1996', replace
******************************
restore
append using `O1996'
}
g id`j'=_n
g year = `j'
replace gender = "O" if gender=="0"
replace candidatename=upper(trim(candidatename))
replace candidatename=subinstr(candidatename,`"""',"",.)
foreach i in "DR. " "PROF. " "SHRIMATI " "SMTI. " "SMTI " "SHRI. " "SHRI " "(" ")" "." "," "'"{
replace candidatename=subinstr(candidatename,"`i'","",.)
}
foreach i in candidatename state constituency  gender {
replace `i'=upper(trim(`i'))
}
save "$work/LScand`j'clean", replace
}


****************************************
***fuzzy name matching 2009-2014
****************************************
use "$work/LScand2009clean", clear
count
reclink candidatename state constituency using "$work/LScand2014clean", wmatch(20 1 1 ) idm(id2009) idu(id2014) required(state  constituency ) gen(score)
drop _merge
count
bys candidatename state constituency: g count = _N
gsort -score candidatename
order score count
drop if score==. //nonmatches

***bring in other fields to compare
renvars gender age total_asset \ genderM ageM total_assetM
merge m:1 id2014 using "$work/LScand2014clean", keepusing(gender age total_asset) keep(1 3) 
assert _m==3
drop _m
order score count *candidatename age* total_asset* gender*
gsort -score candidatename
preserve
keep if score==1 //perfect matches --output
drop if gender!=genderM //a couple perfects on name but different genders
bys candidatename state constituency: keep if _n==1 //some dupe entries; visual inspection this is ok no matter the sort
count
assert _N==561
outsheet using "$work/reclink_2014to2009_perfect.csv", comma names replace
restore
drop if score==1
assert _N==1692
outsheet using "$work/reclink_2014to2009.csv", comma names replace //set to clean

***bring in cleaned stuff 2009-2014
insheet using "$work/reclink_2014to2009_perfect.csv", comma names clear
tempfile temp1
save `temp1'
insheet using "$work/reclink_2014to2009_checked.csv", comma names clear
drop if match=="N"
drop match
append using `temp1'
save `temp1', replace
bys id2014: assert _N==1
keep id2009 id2014 
g id_final = "2009_"+string(id2009)
save "$work/matches20142009", replace

use "$work/LScand2009clean", clear
assert slno == string(id2009)
g id_final = "2009_"+string(id2009)
tempfile temp
save `temp'

use "$work/LScand2014clean", clear
assert slno == string(id2014)
merge 1:1 id2014 using "$work/matches20142009", assert(1 3) nogen
append using `temp'
save "$work/LSmatchedset", replace //this will just be the active dataset to match to
******************end 2009-2014

****************************************
***fuzzy name matching 2009-2004
****************************************
use "$work/LScand2009clean", clear
preserve
keep state constituency
duplicates drop
tempfile const2009
save `const2009'
restore
***quick check that constituency names match perfectly
use "$work/LScand2004clean", clear
preserve
keep state constituency
duplicates drop
merge 1:1 state constituency using `const2009'
restore

***now do matching
use "$work/LScand2009clean", clear
count
reclink candidatename state using "$work/LScand2004clean", wmatch(20 1  ) idm(id2009) idu(id2004) required(state  ) gen(score)
drop _merge
count
bys candidatename state constituency: g count = _N
gsort -score candidatename
order score count
drop if score==. //nonmatches
***bring in other fields to compare
renvars gender age total_asset constituency \ genderM ageM total_assetM constituencyM
merge m:1 id2004 using "$work/LScand2004clean", keepusing(gender age total_asset constituency) keep(1 3) 
assert _m==3
drop _m
order score count *candidatename age* total_asset* constituency* gender*
gsort -score candidatename
preserve
keep if score==1 //perfect matches --output
drop if gender!=genderM //a couple perfects on name but different genders
*bys candidatename state constituency: keep if _n==1 //some dupe entries; visual inspection this is ok no matter the sort
count
assert _N==736
outsheet using "$work/reclink_2004to2009_perfect.csv", comma names replace
restore
drop if score==1
count
assert _N==4747
tab gender genderM, mi
drop if gender!=genderM //a couple on name but different genders
drop if score<.9
destring age ageM, replace
drop if (ageM-age <1 | ageM-age >8) & !mi(ageM) & !mi(age)
outsheet using "$work/reclink_2004to2009.csv", comma names replace //set to clean


***bring in cleaned stuff 2009-2004
insheet using "$work/reclink_2004to2009_perfect.csv", comma names clear
tempfile temp1
save `temp1'
insheet using "$work/reclink_2004to2009_checked.csv", comma names clear
drop if match=="N"
drop match
append using `temp1'
save `temp1', replace

*remove multiple perfect matches
insheet using "$do/merge/clean_empoweringindia_perfectmatches_drops.csv", comma names clear
keep drop id2004 id2009
tempfile temp2
save `temp2'
use `temp1'
merge 1:1 id2004 id2009 using `temp2', nogen keep(1 3)
drop if drop==1
drop drop
drop if candidatename=="OM PRAKASH"
bys id2004: assert _N==1
keep id2009 id2004
g id_final = "2009_"+string(id2009)
save "$work/matches20042009", replace

use "$work/LScand2004clean", clear
assert slno == string(id2004)
merge 1:1 id2004 using "$work/matches20042009", assert(1 3) nogen
append using "$work/LSmatchedset"
save "$work/LSmatchedset", replace //this will just be the active dataset to match to
******************end 2009-2004


****************************************
***fuzzy name matching 1999-2004
****************************************
use "$work/LScand2004clean", clear
preserve
keep state constituency
duplicates drop
tempfile const2004
save `const2004'
restore

***quick check that constituency names match perfectly
insheet using "$do/merge/helpers/clean_1999_states.csv", comma names clear
tempfile statesclean
save `statesclean'

use "$work/LScand1999clean", clear
*fix state splits -- backwards
merge m:1 state constituency using `statesclean', assert(1 3) nogen
replace state = state_final if !mi(state_final)
drop state_final
***clean a couple constituency spellings
replace constituency = "TIRUCHIRAPPALLI" if constituency =="TRIUCHIRAPPALLI"
replace constituency = "THANE" if constituency =="THANA"
replace constituency = "DAVANGERE" if constituency =="DAVNGERE"
replace constituency = "KANAKAPURA" if constituency =="KANAKAPUR"
replace constituency = "PALAMU" if constituency =="PALAMAU"
replace constituency = "DHANBAD" if constituency =="BOKARO"
replace constituency = "DAMAN AND DIU" if constituency =="DAMAN & DIU"
save "$work/LScand1999clean_adj", replace
keep state constituency
duplicates drop
merge 1:1 state constituency using `const2004', assert (3) nogen
clear


***now do matching
use "$work/LScand2004clean", clear
count
reclink candidatename state constituency using "$work/LScand1999clean_adj", wmatch(20 1 1) idm(id2004) idu(id1999) required(state  constituency ) gen(score)
drop _merge
count
bys candidatename state constituency: g count = _N
gsort -score candidatename
order score count
drop if score==. //nonmatches
***bring in other fields to compare
renvars gender age total_asset constituency \ genderM ageM total_assetM constituencyM
merge m:1 id1999 using "$work/LScand1999clean_adj", keepusing(gender age total_asset constituency) keep(1 3) 
assert _m==3
drop _m
order score count *candidatename age* total_asset* constituency* gender*
gsort -score candidatename
preserve
keep if score==1 //perfect matches --output
drop if gender!=genderM //a couple perfects on name but different genders
count
assert _N==457
outsheet using "$work/reclink_2004to1999_perfect.csv", comma names replace
restore
drop if score==1
count
assert _N==971
tab gender genderM, mi
drop if gender!=genderM //a couple on name but different genders
drop if score<.9
destring age ageM, replace
*drop if (ageM-age <1 | ageM-age >8) & !mi(ageM) & !mi(age) NO MORE AGE ADJUSTMENT -- AGE FIELD NOT AVAILABLE
outsheet using "$work/reclink_1999to2004.csv", comma names replace //set to clean


***bring in cleaned stuff 2009-2004
insheet using "$work/reclink_2004to1999_perfect.csv", comma names clear
drop if candidatename=="AJIT KUMAR PANJA"|candidatename=="NEPAL CHANDRA DAS" |candidatename=="RAM SAGAR"|candidatename=="MD SALIM"
tempfile temp1
save `temp1'
insheet using "$work/reclink_1999to2004_checked.csv", comma names clear
drop if match=="N"
drop match
append using `temp1'
save `temp1', replace

bys id1999: assert _N==1
keep id1999 id2004
count
bys id2004: assert _N==1
save "$work/matches20041999", replace

use "$work/LScand1999clean_adj", clear
assert slno == string(id1999)
merge 1:1 id1999 using "$work/matches20041999", assert(1 3) nogen
merge m:1 id2004 using "$work/matches20042009", keep(1 3) keepusing(id_final) nogen //bring in those match to 2004 and also in 2009
append using "$work/LSmatchedset"
save "$work/LSmatchedset", replace //this will just be the active dataset to match to
******************end 1999-2004

****************************************
***fuzzy name matching 1998-1999
****************************************
***quick check that constituency names match perfectly
insheet using "$do/merge/helpers/clean_1999_states.csv", comma names clear
tempfile statesclean
save `statesclean'


use "$work/LScand1999clean_adj", clear
preserve
keep state constituency
duplicates drop
tempfile const2004
save `const2004'
restore


use "$work/LScand1998clean", clear
*fix state splits -- backwards
merge m:1 state constituency using `statesclean', assert(1 3) nogen
replace state = state_final if !mi(state_final)
drop state_final
***clean a couple constituency spellings
replace constituency = "TIRUCHIRAPPALLI" if constituency =="TRIUCHIRAPPALLI"
replace constituency = "THANE" if constituency =="THANA"
replace constituency = "DAVANGERE" if constituency =="DAVNGERE"
replace constituency = "KANAKAPURA" if constituency =="KANAKAPUR"
replace constituency = "PALAMU" if constituency =="PALAMAU"
replace constituency = "DHANBAD" if constituency =="BOKARO"
replace constituency = "DAMAN AND DIU" if constituency =="DAMAN & DIU"
save "$work/LScand1998clean_adj", replace
keep state constituency
duplicates drop
merge 1:1 state constituency using `const2004', assert (3) nogen
clear


***now do matching
use "$work/LScand1999clean_adj", clear
count
reclink candidatename state constituency using "$work/LScand1998clean_adj", wmatch(20 1 1) idm(id1999) idu(id1998) required(state  constituency ) gen(score)
drop _merge
count
bys candidatename state constituency: g count = _N
gsort -score candidatename
order score count
drop if score==. //nonmatches
***bring in other fields to compare
renvars gender age total_asset constituency \ genderM ageM total_assetM constituencyM
merge m:1 id1998 using "$work/LScand1998clean_adj", keepusing(gender age total_asset constituency) keep(1 3) 
assert _m==3
drop _m
order score count *candidatename age* total_asset* constituency* gender*
gsort -score candidatename
preserve
keep if score==1 //perfect matches --output
drop if gender!=genderM //a couple perfects on name but different genders
count
*assert _N==457
outsheet using "$work/reclink_1999to1998_perfect.csv", comma names replace
restore
drop if score==1
count
*assert _N==971
tab gender genderM, mi
drop if gender!=genderM //a couple on name but different genders
drop if score<.9
destring age ageM, replace
*drop if (ageM-age <1 | ageM-age >8) & !mi(ageM) & !mi(age) NO MORE AGE ADJUSTMENT -- AGE FIELD NOT AVAILABLE
outsheet using "$work/reclink_1999to1998.csv", comma names replace //set to clean

***bring in cleaned stuff 2009-2004
insheet using "$work/reclink_1999to1998_perfect.csv", comma names clear
drop if candidatename=="NEPAL CHANDRA DAS" | candidatename=="JASWANT SINGH YADAV" | candidatename=="OM PRAKASH"
tempfile temp1
save `temp1'
insheet using "$work/reclink_1999to1998_checked.csv", comma names clear
drop if match=="N"
drop match
append using `temp1'
save `temp1', replace

bys id1998: assert _N==1
keep id1998 id1999
count
bys id1999: assert _N==1
save "$work/matches19981999", replace

use "$work/LScand1998clean_adj", clear
assert slno == string(id1998)
merge 1:1 id1998 using "$work/matches19981999", assert(1 3) nogen
merge m:1 id1999 using "$work/matches20041999", keep(1 3) keepusing(id2004) nogen
merge m:1 id2004 using "$work/matches20042009", keep(1 3) keepusing(id_final) nogen //bring in those match to 2004 and also in 2009
append using "$work/LSmatchedset"
save "$work/LSmatchedset", replace //this will just be the active dataset to match to
******************end 1999-1998



****************************************
***fuzzy name matching 1996-1998
****************************************
***quick check that constituency names match perfectly
insheet using "$do/merge/helpers/clean_1999_states.csv", comma names clear
tempfile statesclean
save `statesclean'


use "$work/LScand1998clean_adj", clear
preserve
keep state constituency
duplicates drop
tempfile const1998
save `const1998'
restore

use "$work/LScand1996clean", clear
*fix state splits -- backwards
merge m:1 state constituency using `statesclean', assert(1 3) nogen
replace state = state_final if !mi(state_final)
drop state_final
***clean a couple constituency spellings
replace constituency = "TIRUCHIRAPPALLI" if constituency =="TRIUCHIRAPPALLI"
replace constituency = "THANE" if constituency =="THANA"
replace constituency = "DAVANGERE" if constituency =="DAVNGERE" 
replace constituency = "KANAKAPURA" if constituency =="KANAKAPUR" 
replace constituency = "PALAMU" if constituency =="PALAMAU"
replace constituency = "DHANBAD" if constituency =="BOKARO"
replace constituency = "DAMAN AND DIU" if constituency =="DAMAN & DIU"
save "$work/LScand1996clean_adj", replace
keep state constituency
duplicates drop
merge 1:1 state constituency using `const1998', assert(3) nogen
clear

***now do matching
use "$work/LScand1998clean_adj", clear
count
reclink candidatename state constituency using "$work/LScand1996clean_adj", wmatch(20 1 1) idm(id1998) idu(id1996) required(state  constituency ) gen(score)
drop _merge
count
bys candidatename state constituency: g count = _N
gsort -score candidatename
order score count
drop if score==. //nonmatches
***bring in other fields to compare
renvars gender age total_asset constituency party \ genderM ageM total_assetM constituencyM partyM
merge m:1 id1996 using "$work/LScand1996clean_adj", keepusing(gender age total_asset constituency party) keep(1 3) 
assert _m==3
drop _m
order score count *candidatename age* total_asset* constituency* gender*
gsort -score candidatename
preserve
keep if score==1 //perfect matches --output
drop if gender!=genderM //a couple perfects on name but different genders
count
*assert _N==457
outsheet using "$work/reclink_1998to1996_perfect.csv", comma names replace
restore
drop if score==1
count
*assert _N==971
tab gender genderM, mi
drop if gender!=genderM //a couple on name but different genders
drop if score<.9
destring age ageM, replace
outsheet using "$work/reclink_1998to1996.csv", comma names replace //set to clean

***bring in cleaned stuff
insheet using "$work/reclink_1998to1996_perfect.csv", comma names clear
tempfile temp1
save `temp1'
insheet using "$work/reclink_1998to1996_checked.csv", comma names clear
drop if match=="N"
drop match
append using `temp1'
save `temp1', replace

bys id1996: assert _N==1
keep id1996 id1998
count
bys id1998: assert _N==1
save "$work/matches19961998", replace

use "$work/LScand1996clean_adj", clear
*assert slno == string(id1996) //this no longer holds with the state patching
merge 1:1 id1996 using "$work/matches19961998", assert(1 3) nogen
merge m:1 id1998 using "$work/matches19981999", keep(1 3) keepusing(id1999) nogen
merge m:1 id1999 using "$work/matches20041999", keep(1 3) keepusing(id2004) nogen
merge m:1 id2004 using "$work/matches20042009", keep(1 3) keepusing(id_final) nogen //bring in those match to 2004 and also in 2009
append using "$work/LSmatchedset"
save "$work/LSmatchedset", replace //this will just be the active dataset to match to
******************end 1999-1998



****************************************
***fuzzy name matching 1991-1996
****************************************
***quick check that constituency names match perfectly
insheet using "$do/merge/helpers/clean_1999_states.csv", comma names clear
tempfile statesclean
save `statesclean'


use "$work/LScand1996clean_adj", clear
preserve
keep state constituency
duplicates drop
tempfile const1996
save `const1996'
restore

use "$work/LScand1991clean", clear
drop if candidatename=="MANI SHANKAR AIYAR" & category=="SC" //this is a weird dupe
*fix state splits -- backwards
merge m:1 state constituency using `statesclean', assert(1 3) nogen
replace state = state_final if !mi(state_final)
drop state_final
***clean a couple constituency spellings
replace constituency = "TIRUCHIRAPPALLI" if constituency =="TRIUCHIRAPPALLI"
replace constituency = "THANE" if constituency =="THANA"
replace constituency = "DAVANGERE" if constituency =="DAVNGERE" 
replace constituency = "KANAKAPURA" if constituency =="KANAKAPUR" 
replace constituency = "PALAMU" if constituency =="PALAMAU"
replace constituency = "DHANBAD" if constituency =="BOKARO"
replace constituency = "DAMAN AND DIU" if constituency =="DAMAN & DIU"
save "$work/LScand1991clean_adj", replace
keep state constituency
duplicates drop
merge 1:1 state constituency using `const1996'
drop if _m==2 // missings: Bihar (purnea, patna), J&K (all), UP (meerut)
assert _m==3
drop _m
clear

***now do matching
use "$work/LScand1996clean_adj", clear
count
reclink candidatename state constituency using "$work/LScand1991clean_adj", wmatch(20 1 1) idm(id1996) idu(id1991) required(state  constituency ) gen(score)
drop _merge
count
bys candidatename state constituency: g count = _N
gsort -score candidatename
order score count
drop if score==. //nonmatches
***bring in other fields to compare
renvars gender age total_asset constituency party \ genderM ageM total_assetM constituencyM partyM
merge m:1 id1991 using "$work/LScand1991clean_adj", keepusing(gender age total_asset constituency party) keep(1 3) 
assert _m==3
drop _m
order score count *candidatename age* total_asset* constituency* gender* party*
gsort -score candidatename
preserve
keep if score==1 //perfect matches --output
drop if gender!=genderM //a couple perfects on name but different genders
count
*assert _N==457
outsheet using "$work/reclink_1996to1991_perfect.csv", comma names replace
restore
drop if score==1
count
*assert _N==971
tab gender genderM, mi
drop if gender!=genderM //a couple on name but different genders
drop if score<.9
destring age ageM, replace
outsheet using "$work/reclink_1996to1991.csv", comma names replace //set to clean

***bring in cleaned stuff
insheet using "$work/reclink_1996to1991_perfect.csv", comma names clear
drop if candidatename=="NARAYAN CHANDRA DAS" & partym=="IND"
drop if candidatename=="DATTA PATIL" & partym=="IND"
tostring sno, replace
tempfile temp1
save `temp1'
insheet using "$work/reclink_1996to1991_checked.csv", comma names clear
drop if match=="N"
drop match
append using `temp1'
save `temp1', replace

bys id1991: assert _N==1
bys id1996: assert _N==1
keep id1991 id1996
count
save "$work/matches19911996", replace

use "$work/LScand1991clean_adj", clear
assert slno == string(id1991) 
merge 1:1 id1991 using "$work/matches19911996", assert(1 3) nogen
merge m:1 id1996 using "$work/matches19961998", keep(1 3) keepusing(id1998) nogen
merge m:1 id1998 using "$work/matches19981999", keep(1 3) keepusing(id1999) nogen
merge m:1 id1999 using "$work/matches20041999", keep(1 3) keepusing(id2004) nogen
merge m:1 id2004 using "$work/matches20042009", keep(1 3) keepusing(id_final) nogen //bring in those match to 2004 and also in 2009
append using "$work/LSmatchedset"
save "$work/LSmatchedset", replace //this will just be the active dataset to match to
******************end 1999-1998


***fix ids to be constant when matched across
cap drop id_final
g id_final=""
replace id_final = "2009_"+string(id2009) if year==2009
assert !mi(id_final) if year==2009
replace id_final = "2009_"+string(id2009) if id_final=="" & year==2014 & id2009!=.
replace id_final = "2014_"+string(id2014) if id_final=="" & year==2014
replace id_final = "2004_"+string(id2004) if (id_final=="" & year==2004 ) | (id_final=="" & id2004!=. & year<2004 )
replace id_final = "1999_"+string(id1999) if (id_final=="" & year==1999 ) | (id_final=="" & id1999!=. & year<1999 )
replace id_final = "1998_"+string(id1998) if (id_final=="" & year==1998 ) | (id_final=="" & id1998!=. & year<1998 )
replace id_final = "1996_"+string(id1996) if (id_final=="" & year==1996 ) | (id_final=="" & id1996!=. & year<1996 )
replace id_final = "1991_"+string(id1991) if (id_final=="" & year==1991 ) 
assert !mi(id_final)

preserve
keep if string(year) == substr(id_final,1,4)
bys id_final: assert _N==1
keep id_final candidatename
rename candidatename candidatename_final
tempfile names
save `names'
restore
merge m:1 id_final using `names', assert(3) nogen

preserve
keep id_final candidatename_final
duplicates drop
bys id_final: assert _N==1
restore

replace gender = "M" if gender=="O"
save "$work/LSmatchedset", replace //Final dataset
destring votes_polled, replace
gsort year state constituency -votes_polled
g margin_on_next = votes_polled-votes_polled[_n+1] if constituency==constituency[_n+1] & state==state[_n+1] & year==year[_n+1]
by  year state constituency: keep if _n==1
g candidate_place = candidatename+" ("+constituency+")"
g candidate_place_panel = candidatename_final+" ("+constituency+")"
saveold "$work/LSmatchedset_LSmembers_winners", replace //Final elected officials dataset



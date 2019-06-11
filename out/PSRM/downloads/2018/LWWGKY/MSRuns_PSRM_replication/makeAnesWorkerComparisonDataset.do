clear *

// ANES for coder demographic comparison
use rawData/anes2016

gen _first = .
order V160001, last 	// put at end so we keep it
gen dataset = 2
gen double anesWeight = V160101
gen coderFemale = V161342==2 if inrange(V161342,1,2)

egen cAgeSum = cut(V161267) if V161267>=0, at(18,25,35,45,55,99) 

gen coderRaceCollapsed = .
replace coderRaceCollapsed = 1 if V161310a==1 // white  --> white
replace coderRaceCollapsed = 2 if V161310b==1 // black  --> black/aa
replace coderRaceCollapsed = 8 if V161310c==1 // Indian/Alaska native --> other
replace coderRaceCollapsed = 4 if V161310d==1 // Asian --> asian
replace coderRaceCollapsed = 8 if V161310e==1 // Hawaiian, pacific islander --> other
replace coderRaceCollapsed = 8 if V161310f==1 // other --> other

replace coderRaceCollapsed = 1 if V161310g==1  // other spec as white
replace coderRaceCollapsed = 2 if V161310g==2  // other spec as black
replace coderRaceCollapsed = 4 if V161310g==4  // other spec as Asian
replace coderRaceCollapsed = 7 if V161310g==7  // other spec as Hispanic
replace coderRaceCollapsed = 7 if V161309==1   // other spec as Hispanic

gen nRace = 0
foreach l in a b c d e f {
	replace nRace=nRace+1 if V161310`l'==1
}

replace coderRaceCollapsed = 9 if nRace>1 & nRace<. // specified > 1
replace coderRaceCollapsed = 9 if inlist(V161310g,12,13,17,27)  // various mixed
replace coderRaceCollapsed = 10 if mi(coderRaceCollapsed)

recode V161270 (1/8=1) (9 90=2) (10=3) (11/12=4) (13=5) (14/16=6) (*=.), gen(coderEd2)

gen coderStudent = V161277==8 if !mi(V161277)

recode V161361x (1/6=1) (7/12=2) (13/20=3) (21/28=4) (*=.), gen(coderIncome)

recode V161155 (1=3) (2=1) (3 5 0=2) (*=.), gen(coderPid3)

gen _last = .
keep _first-_last
compress

save dataSets/anes16_forCoderComparison, replace

// mTurkers
// get list of workers who actually coded any ads
use dataSets/hitlevel_work1
keep if coderType==1 
keep workerId  
by workerId, sort: keep if _n==1
sort workerId
save dataSets/mTurkersWhoCoded, replace

use rawData/workerInfo
keep if coderType==1 	// mTurk workers
sort workerId
merge 1:1 workerId using dataSets/mTurkersWhoCoded
drop if _merge!=3

gen dataset = 1 
la de dataset 1 "mTurk coders" 2 "2016 \textsc{anes}"
la val dataset dataset 

gen double anesWeight = 1 // mTurker worker data unweighted

// labelling
la var coderFemale "Gender"
la de coderFemale 0 "Male" 1 "Female"
la val coderFemale coderFemale

la de coderStudent 0 "Non-student" 1 "Student"
la val coderStudent coderStudent
la var coderStudent "Student status"

la var coderPid3 "Party Identification"

egen cAgeSum = cut(coderAge), at(18,25,35,45,55,90) 
la de cAgeSum 18 "18-24" 25 "25-34" 35 "35-44" 45 "45-54" 55 "55+"
la val cAgeSum cAgeSum
la var cAgeSum "Age"

gen coderEd2 = coderEducation
replace coderEd2 = 6 if coderEducation==7
la copy `: value label coderEducation' coderEd2
la de coderEd2 1 "Less than HS" 2 "High school graduate or GED" 6 "Graduate degree", modify
la val coderEd2 coderEd2
la var coderEd2 "Education"

la var coderIncome "Family Income"

gen coderRaceSum = .
forval i=1/7 {
	replace coderRaceSum = `i' if coderRace_`i'==1
}
replace coderRaceSum = 8 if coderRace_other!="0"
egen nRaces = rowtotal(coderRace_?)
replace nRaces = nRaces+(coderRace_other!="0")
replace coderRaceSum = 9 if nRaces>1
replace coderRaceSum = 10 if nRaces==0

#delimit ;
	la de coderRaceSum 
	1 "White"
	2 "Black or African-American"
	3 "American Indian or Alaska Native"
	4 "Asian"
	5 "Middle Eastern"
	6 "Native Hawaiian or Pacific Islander"
	7 "Hispanic, Latino, or Spanish"
	8 "Other"
	9 "Multiple or mixed race"
	10 "(not specified)"
	;
#delimit cr
la val coderRaceSum coderRaceSum

clonevar coderRaceCollapsed = coderRaceSum
replace coderRaceCollapsed = 8 if inlist(coderRaceSum,3,5,6)
la var coderRaceCollapsed "Coder racial/ethnic identification"

compress
save dataSets/coderInfo_forRandR, replace

append using dataSets/anes16_forCoderComparison
svyset [pw=anesWeight]
save dataSets/coderAndANES_forRandR, replace


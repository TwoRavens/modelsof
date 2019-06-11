*! makeHitLevelData.do
*! Constructs hit-level datasets:
*!    hitlevel_work1      : one obseration per coder per ad
*!    hitlevel_metacoders : one observation per metaCoder per ad

// -----------------------------------
// get video timing var from CMAG d/s
// -----------------------------------
clear
use datasets/cmag_adcoding2010_withideology
keep creative wmp_l
sort creative
gen year=2010
save "dataSets/cmag_timings2010", replace


// -----------------------------------
// get raw coding dataset & create analysis variables
// -----------------------------------
clear
use rawData/rawCodingData

merge m:1 workerId using "rawData/workerInfo.dta"
assert inlist(_merge,1,3)
assert _merge==3 if coderType==1 
drop _merge

// utility variables about ads & timing
gen adYear  = substr(vidFile,index(vidFile,"videos/")+7,4)
gen adName  = substr(vidFile,index(vidFile,"videos/")+12,.)
gen adState = substr(adName,index(adName,"_")+1,2)
gen adLevel = substr(adName,1,index(adName,"_")-1)
drop vidFile

gen creative     = subinstr(adName,".mp4","",.)
replace creative = subinstr(creative,"HOUSE_","HOUSE/",.)
replace creative = subinstr(creative,"USSEN_","USSEN/",.)
replace creative = subinstr(creative,"_"," ",.)
merge m:1 creative using dataSets/cmag_timings2010.dta, keep(match master)
assert _merge==3
drop _merge

// flag speeders (ads coded faster than 90% of length of ad (because some vids cut off a few seconds)
// -- but give credit for quick resubmissions for handful of HITs due to (Amazon) web page error
gen time    = (submitdate-startdate)/1000
gen speeder = time < (wmp_l*0.9)
la var speeder "Coded faster than ad length"
by adName worker (submitdate), sort: replace speeder=0 if _N==2 & speeder[1]==0
by adName worker (submitdate), sort: keep if _n==_N		// keeping resubmission for analysis

// recode all coding variables as 0-1
foreach var of varlist em* {
	replace `var' = 1-((`var'-1)/2)
}
la de emot 0 "No appeal" 1 "Strong appeal"
la val em* emot

foreach var of varlist ideology* {
	replace `var' = `var'/100
}
la de ideology 0 "Very liberal" 1 "Very conservative"
la val ideology* ideology

// dichotomized emotion 
foreach var of varlist em*  {
	local newvar : subinstr local var    "em"      "em1"
	gen `newvar' = ceil(`var')
	la var `newvar' `"`: variable label `var'' (dichot)"'
	local newlist `newlist' `newvar'
}
order `newlist', after(ideologyOc)

// number of ads coded by this coder:
by workerId (submitdate), sort: gen coderNAdsCoded = _N
by workerId (submitdate), sort: gen coderSeq = _n
la var coderNAdsCoded "Total number of ads coded by worker (including speeders)"
la var coderSeq "Ad code sequence by worker (including speeders)"

// total codings for this ad
by adName, sort: gen adNcoders = _N
la var adNcoders "Number of times ad was coded"

// ------------------------------------------------------
// Categorize into metaCoders (i.e., groups of 5 coders)
// ------------------------------------------------------
drop if speeder==1
by codingType adName (submitdate), sort: gen metaGroupNum = floor((_n-1)/5)+1	// groups of 5 of same type [mTurk/RA] of coder
by codingType adName metaGroupNum, sort: gen metaGroupSize = _N
replace metaGroupNum = . if metaGroupSize<5				// eliminate partial meta-coders
replace metaGroupNum = . if mi(codingType)
ta metaGroupNum
drop metaGroupSize

// ------------------------------------------------------
// Coder characteristics
// ------------------------------------------------------
recode coderEducation (1/2=1 "Coder’s education: High school or less") (3=2 "Coder’s education: Some college") (4=3 "Coder’s education: Associate degree") (5=4 "Coder’s education: Bachelor degree") (6/7=5 "Coder’s education: Graduate degree"), gen(coderEd2)
la var coderEd2 "Coder Education"

gen coderBlack = coderRace_2==1 if !mi(coderRace_2)
la var coderBlack "African American Coder"

gen coderAsian = coderRace_4==1 if !mi(coderRace_4)
la var coderAsian "Asian American Coder"

gen coderLatinx = coderRace_7==1 if !mi(coderRace_7)
la var coderLatinx "Latinx Coder"

recode coderNAdsCoded (1/10=1 "Coded 10 or fewer ads overall") (11/49=2 "Coded 11-49 ads overall") (50/99=3 "Coded 50-99 ads overall") (100/2000=4 "Coded 100+ ads overall"), gen(coderNAdsGroup)
la var coderNAdsGroup "Total ads for coder"

recode coderSeq (1/10=1 "First 10 ads") (11/49=2 "Ads 11-49") (50/99=3 "Ads 50-99") (100/199=4 "Ads 100-199") (200/2000=5 "Ads 200+"), gen(coderSeqGroup)
la var coderNAdsGroup "Total ads for coder"
la save coderSeqGroup using auxSyntax/Label_coderSeqGroup.do, replace

gen coderSeqGroup2 = coderSeqGroup
replace coderSeqGroup2 = 5 if coderNAdsCoded>=200 & !mi(coderNAdsCoded)
la de coderSeqGroup2 ///
	1 `""First" "10""' ///
	2 `""Ads" "11-49""' ///
	3 `""Ads" "50-99""' ///
	4 `""Ads" "100-199""' ///
	5 `""Ads" "200+""'
la val coderSeqGroup coderSeqGroup2


recode coderAge (18/25=1 "Coder age 18-25") (26/30=2 "Coder age 26-30") (31/35=3 "Coder age 31-35") (36/40=4 "Coder age 36-40") (41/50=5 "Coder age 41-50") (51/99=6 "Coder age 51+"), gen(coderAgeGroup)
la var coderAgeGroup "Coder age (grouped)"

la de Cpid3 1 "Republican coder" 2 "Independent coder" 3 "Democratic coder"
la val coderPid3 Cpid3

la var coderFemale "Female coder"
la var coderAge "Coder’s age"
la var coderKnow "Coder’s political knowledge"
la var coderStudent "Coder is student"

la de Cincome 1 "Coder’s income: <20k" 2 "Coder’s income: 20k-40k" 3 "Coder’s income: 40k-80k" 4 "Coder’s income: 80k+"
la val coderIncome Cincome

la var time "Time to code ad (seconds)"
recode time  ///
	(30/39=1 `""Time 30-39" "(1st quartile)""')         ///
	(40/54=2 `""Time 40-54" "(second quartile)""')      ///
	(55/85=3 `""Time 55-85" "(third quartile)""')       ///
	(86/132=4 `""Time 86-132" "(75th-90th pctile)""')   ///
	(133/1000=5 `""Time > 134" "(90th-100th pctile)""') ///
	, gen(timeGroup)

la de timeG2                           ///
	1 `""30-39" "[Q1]""'               ///
	2 `""40-54" "[Q2]""'               ///
	3 `""55-85" "[Q3]""'               ///
	4 `""86-132" "[75-90" "pctile]" "' ///
	5 `""> 134" "[90+" "pctile]""' 
la val timeGroup timeG2

capture la de timeGnoQt                               ///
           1 "Time 30-39 (1st quartile)"      ///
           2 "Time 40-54 (second quartile)"   ///
           3 "Time 55-85 (third quartile)"    ///
           4 "Time 86-132 (75th-90th pctile)" ///
           5 "Time > 134 (90th-100th pctile)"
la save timeGnoQt using auxSyntax/Label_timeGnoQt, replace

encode adLevel, gen(SadLevel)
la de SadLevel 1 "House race" 2 "Senate race", modify
la val SadLevel SadLevel

egen wTag = tag(workerId)

// specify per-variable weights for reliability analyses
do setPervarWeightChars.do

// -------------------
// save codingType label for reapplication
// -------------------
la de codingType 10 "mTurk workers", add
la de codingType 20 "Research assistants", add
la de codingType 100 "mTurk meta-coders", add
la de codingType 110 "mTurk workers (on meta subset)", add
la de codingType 120 "Research assistants (on meta subset)", add
label save codingType using auxSyntax/codingTypeLabel.do, replace

compress
save dataSets/hitlevel_work1, replace

// ------------------------------------------
// Create dataset of hitlevel meta-coders
// ------------------------------------------
use dataSets/hitlevel_work1, clear
preserve
	keep if !mi(metaGroupNum)
	// get list of coding variables 
	local codevl $codevl 

	collapse `codevl' wmp_l speeder adNcoders coderType, by(codingType adName metaGroupNum)
	// specify per-variable weights for reliability analyses
	do setPervarWeightChars.do
	gen workerId = "meta_cT" + string(codingType) + "_" + string(metaGroupNum,"%03.0f")
	replace codingType = codingType + 100
	by adName, sort: gen adNmetacoders = _N

	compress

	// unrounded version for MSE analysis
	save dataSets/hitlevel_metacoders_unrounded, replace

	// ROUND results b/c Kappa needs categorical
	local l2 flag mention1Fc mention1Oc ecAppeal etPositive etNegative ///
				em1Enthusiasm em1Fear em1Anger em1Disgust              ///
				tFcComp tFcLeader tFcInteg tFcEmpathy                  ///
				tOcComp tOcLeader tOcInteg tOcEmpathy
	local l3 emEnthusiasm emFear emAnger emDisgust
	local l100 ideology*
	foreach var of varlist `l2' {
		replace `var' = round(`var',1)
	}
	foreach var of varlist `l3' {
		replace `var' = round(`var',.5)
	}
	foreach var of varlist `l100' {
		replace `var' = round(`var',0.01)
	}

	compress
	save dataSets/hitlevel_metacoders, replace
restore


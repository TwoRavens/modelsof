*! Replicates miscellaneous numbers reported in text

capture log close moreNumbers
log using latexOutput/additionalNumbersInText.smcl, smcl replace name(moreNumbers)

clear *
*******************************************************
* Main Text
*******************************************************
// They were aired just over 1.5 million times.
capture use $CMAGDataFile
if !_rc {
	count if spanish==0
}

// on behalf of 662 different candidates.
use dataSets/validity_dataset_full, clear
egen candTag = tag(stcd2 candname)
ta candTag

// This includes 4,357 unique advertisements (3,016 House and 1,341 Senate) ... 
use dataSets/hitlevel_work1, clear
egen adTag = tag(creative)
ta SadLevel if adTag

// Overall, 526 mTurk workers coded at least one ad for us. 
ta wTag coderType

// The average worker coded 53 ads,
sum coderNAdsCoded if wTag & coderType==1

//  ... many dropped out after a few, some coded dozens, and a few coded hundreds.  
ta coderNAdsGroup if wTag & coderType==1


// ... all but 65 ads were coded by five or more mTurk workers; 
// of those 198 were coded by at least 20 mTurk workers 
// ... 1,512 ads were also coded by research assistants,
// with 300 double-coded by two RAs and 85 by all six. 
by adName coderType, sort: gen tagAdCoderType      = _n==1
by adName coderType, sort: gen nCodersOfType = _N
recode nCodersOfType (1/4=1 "1-4 coders") (5/19=2 "5-19") (20/50=3 "20+"), gen(nCodersOfTypeGroup)

tab nCodersOfType coderType if tagAdCoderType
tab nCodersOfTypeGroup  coderType if tagAdCoderType

*******************************************************
* Appendix Text
*******************************************************
// Overall, 1,235 mTurk workers took our qualification survey; all but eight were classified as eligible
use rawData/allWorkers, clear
ta coderQuiz

// Of these, 526 went on to code at least one ad. Workers each coded an average of 53 ads, 
// << SEE ABOVE >>

// (median 7; range 1–1,159; standard deviation of 121).
use dataSets/hitlevel_work1, clear
sum coderNAdsCoded if wTag & coderType==1, detail

// Seventy-five individuals completed 80 percent of the 27,335 ads coded by online workers. 
keep if coderType==1
gen nAds = 1
collapse (sum) nAds, by(workerId)
gsort -nAds
gen sumNAds = sum(nAds)
gen cumPct = sumNAds/sumNAds[_N]
list in 85
list in L


// political knowledge battery ...  median coder scored 0.875 on a zero-to-one scale.
use rawData/workerInfo, clear
sum coderKnow, detail

// About three quarters reported conducting at least some content coding in the past.
ta coderPastcoding

log close moreNumbers
translate latexOutput/additionalNumbersInText.smcl latexOutput/additionalNumbersInText.pdf, replace


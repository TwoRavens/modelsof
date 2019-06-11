version 13.1

cd "/Users/awindsor/Dropbox/Minerva Initiative (Alistair)/Arab Spring Project/"

/*
uses R. Newsoms multproc.
ssc install smileplot

will produce SubmitFigure1.pdf, SubmitFigure2.pdf SubmitOutput2.xlsx SubmitOutput3.xlsx
in the directory in which it is run 
*/


use Submit.dta, clear

local liwcPronouns we shehe they
local liwcAffect posemo negemo anx anger
local liwcCogProc tentat certain
local liwcDrives reward risk

local liwcInterest sad cause achieve power focuspast focuspresent focusfuture ///
  relig death 

local liwcFocusVar  `liwcPronouns' `liwcAffect' `liwcCogProc' `liwcDrives' zhonesty_2015

local liwcAdd  adj compare male bio health

sort leader country

gen long id = _n 

levelsof country, local(countries)

scalar numVars = wordcount("`liwcFocusVar'")

// Table 2 Means of LIWC Focus Variables by Leader

putexcel set "SubmitOutput2.xlsx", replace

local header = `""Leader" "Country" "We" "She/He" "They" "Positive Emotion" "' ///
  + `" "Negative Emotion" "Anxious" "Anger" "Tentative" "Certain" "Reward" "Risk""'

local col = 1
foreach entry of local header {
	excelcol `col'
	local colname `r(column)'
	putexcel `colname'1 = ("`entry'")
	local ++col
	}

local row = 2
foreach country of local countries {
	// Retrieve the leader associated with the country
	su id if country == "`country'", meanonly 
	local leader = leader[r(min)]
	putexcel A`row' = ("`leader'") B`row'=("`country'")
	local col = 3
	foreach var of local liwcFocusVar {
		excelcol `col'
		local colname `r(column)'
		sum `var' [fweight=wc] if country=="`country'", meanonly
		putexcel `colname'`row' = (r(mean)/100)
		local ++col
		}
	local ++row
	}

// Table 3 Linguistic Variable Means by Leader Survival

// We exclude the honesty variable from the multiple comparison
// correction

local header = `" "Leader" "Country" "We" "She/He" "They" "Positive Emotion""' ///
  + `""Negative Emotion" "Anxious" "Anger" "Tentative" "Certain" "Reward" "Risk""'

matrix define pValues=J(numVars-1,1,0)

putexcel set "SubmitOutput3.xlsx", replace

putexcel A1=("Variable") B1=("Pred. if Lose Power") C1=("Pred. if Retain Power") ///
  D1=("Diff. of Means") E1=("P. Value") F1=("Reject Null Hyp.") 

local row  2
foreach entry of local header {
	putexcel A`row' = ("`entry'")
	local ++row
	}
local row  1

foreach var of varlist `liwcFocusVar' {
	qui: reg `var' survive if full, cluster(ccode)
	scalar p = 2*ttail(e(df_r),abs(_b[survive]/_se[survive]))
	// We convert LIWCs percentages into proportions and then format as percentage in Excel.
	if "`var'" != "zhonesty_2015" {
		matrix pValues[`row',1]=p
		putexcel B`row'=(_b[_cons]/100) C`row'=((_b[_cons]+_b[survive])/100) ///
		  D`row'=(_b[survive]/100) E`row'=(p)
		}
	// Honesty is a standardized variable and does not need conversion.
	else putexcel B`row'=(_b[_cons]) C`row'=(_b[_cons]+_b[survive]) ///
	  D`row'=(_b[survive]) E`row'=(p)
	local ++row
	}

// The multproc command takes a table of pvalues stored in the data. We preserve the data
// before calling the svmat to convert our stored matrix into data. 

preserve
svmat pValues
keep if pValues1
drop if pValues1 == .
multproc ,method(holm) reject(rHolm) pvalue(pValues1)
scalar pcor=r(pcor)
mkmat rHolm
putexcel F2=matrix(rHolm)
putexcel A`row'=("Holm-Sidak Critcal Value:") D`row'=(pcor)

// restore the data after multproc processing. 

restore

/* Table 4 Additional Variables of Interest

Note that the LIWC percentages are converted to proportions so that they will
display correctly once they are formatted as percentages in Excel. */

putexcel set "SubmitOutput4.xlsx", replace


putexcel A1=("Variable") B1=("Pred. if Lose Power") C1=(" Pred if Retain Power") ///
  D1=("Diff. of Means") E1=("P. Value")  
local row  1

foreach var of varlist `liwcAdd' {
	qui: reg `var' survive if full, cluster(ccode)
	scalar p = 2*ttail(e(df_r),abs(_b[survive]/_se[survive]))
	local ++row
	putexcel A`row'=("`var'") B`row'=(_b[_cons]/100) C`row'=((_b[_cons]+_b[survive])/100) ///
	  D`row'=(_b[survive]/100) E`row'=(p) 
	}



// This block produced the figures. 


// Figure 1
graph drop _all
graph bar (mean) death, over(country,label(angle(vertical)) ) ///
  over(survive, relabel(1 "Lost" 2 "Retained")) nofill ///
  ytitle("Death") graphregion(color(white)) plotregion(color(white)) bgcolor(white)
graph rename Death, replace
graph bar (mean) zhonesty_2015, over(country, label(angle(vertical))) ///
  over(survive, relabel(1 "Lost" 2 "Retained")) nofill ///
  ytitle("Honesty") graphregion(color(white)) plotregion(color(white)) bgcolor(white)
graph rename Honesty, replace
graph bar (mean) anger, over(country, label(angle(vertical))) ///
  over(survive, relabel(1 "Lost" 2 "Retained")) nofill ///
  ytitle("Anger") graphregion(color(white)) plotregion(color(white)) bgcolor(white)
graph rename Anger, replace
graph combine Death Anger Honesty, ///
  rows(1) graphregion(color(white)) plotregion(color(white)) imargin(zero)
graph export "SubmitFigure1.pdf", replace

// Figure 2
graph bar (mean) anx, over(country,label(angle(vertical)) ) ///
  over(survive, relabel(1 "Lost" 2 "Retained")) nofill ///
  ytitle("Anxiety") graphregion(color(white)) plotregion(color(white)) bgcolor(white)
graph rename anx, replace
graph bar (mean) shehe, over(country, label(angle(vertical))) ///
  over(survive, relabel(1 "Lost" 2 "Retained")) nofill ///
  ytitle("She/He") graphregion(color(white)) plotregion(color(white)) bgcolor(white)
graph rename shehe, replace
graph bar (mean) negemo, over(country, label(angle(vertical))) ///
  over(survive, relabel(1 "Lost" 2 "Retained")) nofill ///
  ytitle("Neg. Emotion") graphregion(color(white)) plotregion(color(white)) bgcolor(white)
graph rename negemo, replace
graph bar (mean) certain, over(country, label(angle(vertical))) ///
  over(survive, relabel(1 "Lost" 2 "Retained")) nofill ///
  ytitle("Certainty") graphregion(color(white)) plotregion(color(white)) bgcolor(white)
graph rename certain, replace
graph combine anx shehe negemo certain, ///
  rows(2) graphregion(color(white)) plotregion(color(white)) imargin(zero)
graph export "SubmitFigure2.pdf", replace


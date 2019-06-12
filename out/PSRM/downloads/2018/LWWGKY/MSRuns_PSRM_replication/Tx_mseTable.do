clear *
args tlog flog tloga floga

local textwidth 6.5

use dataSets/codelevel_work1

// Keep only Vars needed
gen tokeep = 0
foreach vv in 1 4 5 6 7 8 9 10 15 16 17 18 19 20 21 22 27 28 29 30 31 32 33 34 {
	qui replace tokeep =1 if Var==`vv'
}
keep if tokeep
drop tokeep

// flag meta-coded ads
merge m:1 adName using dataSets/metaAdNames, gen(hasmeta)

// Create metacoder stats
preserve
	keep if coderType==1 & mIt5_metaTag==1 & hasmeta==3
	collapse mIt5_e2 , by(coderType Var)
	gen mIt5_sd = sqrt(mIt5_e2)
	drop *e2
	sort Var coderType

	tempfile metamse
	save "`metamse'", replace
restore

// Create individual stats on metacoder subset
preserve
	keep if hasmeta==3
	collapse mIt1_e2 , by(coderType Var)
	gen mIt2_sd = sqrt(mIt1_e2)
	drop *e2
	sort Var coderType

	merge 1:1 Var coderType using "`metamse'", gen(_merge2)
	drop _merge2

	tempfile metamse2
	save "`metamse2'", replace
restore

// collapse to get averages & take square root
collapse mIt1_e2 , by(coderType Var)
gen mIt1_sd = sqrt(mIt1_e2)
drop *e2

merge 1:1 Var coderType using "`metamse2'"
drop _merge

rename mIt1_sd msd_1
rename mIt2_sd msd_2
rename mIt5_sd msd_5

reshape long msd_ , i(Var coderType) j(meta)
la de meta 1 "individual coder" 2 "individual coder (on meta subset of ads)" 5 "metacoder"
la val meta meta

reshape wide msd_, i(coderType meta) j(Var)
egen msd_201 = rowmean(msd_4  msd_5)	// economic tone
egen msd_202 = rowmean(msd_7 -msd_10)	// 3-way emotion
egen msd_203 = rowmean(msd_29-msd_32)	// dichot emotion
egen msd_204 = rowmean(msd_33 msd_34)	// dichot candidate appears at all
egen msd_205 = rowmean(msd_15-msd_18)	// Fc traits
egen msd_206 = rowmean(msd_19-msd_22)	// Oc traits
egen msd_207 = rowmean(msd_27 msd_28) 	// ideology
reshape long

reshape wide msd_, i(Var coderType) j(meta)

reshape wide msd_1 msd_2 msd_5, i(Var) j(coderType)
la var msd_11 "mTurk workers"
la var msd_13 "Research assistants"

la var msd_51 "mTurk meta-coders"
la var msd_53 "RA meta \textsc{rmse}"

la var msd_21 "mTurk workers (on meta subset)"
la var msd_23 "Research assistants (on meta subset)"

format msd* %4.3f
do auxSyntax/vllabel.do		// created by T1_kappaTable

merge m:1 Var using rawData/TableSortOrder, keep(match master)
assert _merge==3
drop _merge
sort sort

gen forsumtable = inlist(Var,1,201,6,202,203,204,205,206,207)
gen forsumtable_noflag = forsumtable
replace forsumtable_noflag = 0 if Var==6


local eq  msd_11 - msd_13
gen msd_diff = `eq'
gen Smsd_diff = cond(!mi(`eq'),    cond(`eq'>0,"+","-")+string(`eq',"%4.3f") , "---")	// generates double-equal-sign for negatives
la var Smsd_diff "mTurk vs. RA"

local eq (msd_diff/msd_13)*100
gen msd_diff_pct = `eq'
gen Smsd_diff_pct = cond(!mi(`eq'),    cond(`eq'>0,"+","-")+string(`eq',"%3.0f")+"\%" , "---")	// generates double-equal-sign for negatives
la var Smsd_diff_pct "mTurk vs. RA (\%)"


// meta_gain ( mturkMeta - mturk_on_meta_subset)
local var meta_gain
local eq  msd_51 - msd_21
gen `var' = `eq'
gen S`var' = cond(!mi(`eq'), cond(`eq'>0,"+","-")+string(`eq',"%4.3f") , "---")	// generates double-equal-sign for negatives
la var S`var' "Difference: meta-coder gain"

// meta_vs_ra  ( mturkMeta - RA_on_meta_subset)
local var meta_vs_ra
local eq  msd_51 - msd_23
gen `var' = `eq'
gen S`var' = cond(!mi(`eq'), cond(`eq'>0,"+","-")+string(`eq',"%4.3f") , "---")	// generates double-equal-sign for negatives
la var S`var' "meta-mTurk vs. RA"

local eq (`var'/msd_23)*100
gen `var'_pct = `eq'
gen S`var'_pct = cond(!mi(`eq'),    cond(`eq'>0,"+","-")+string(`eq',"%3.0f")+"\%" , "---")	// generates double-equal-sign for negatives
la var S`var'_pct "meta-mTurk vs. RA (\%)"

foreach var of varlist msd_13 msd_11 msd_21 msd_51 msd_23 {
	gen S`var' = string(`var',"%3.2f")
	la var S`var' "`: variable label `var''"
}


// add bold and spacing for detail table
label copy vllabel vllabelX
foreach i in 1 201 6 202 203 204 205 206 207 {
	la de vllabelX `i' `"{\bfseries `: label vllabelX `i''}"', modify
}
foreach i in 1 7 29 13 15 19 27 33 {
	la de vllabelX `i' "\addlinespace `: label vllabelX `i''", modify
}
la val Var vllabelX

foreach var of varlist  Smsd_13 Smsd_11 Smsd_21 Smsd_51 Smsd_23 Smsd_diff Smsd_diff_pct Smeta_vs_ra Smeta_vs_ra_pct {
	replace `var' = "{\bfseries "+`var'+"}" if forsumtable 
	replace `var' = subinstr(`var',"{\bfseries \addlinespace","\addlinespace {\bfseries",.)
}


****************
* MAKE TABLES
****************
//detail table (within-wave truth)
local caption Inter-coder reliability by item (\textsc{rmse})
local varlist Smsd_13 Smsd_11 Smsd_diff Smsd_diff_pct
local width 		4.25in
local univ		/*sdType==*/1
local notes 		\item \hspace{-1em}Entries are root mean squared error among coding decision, calculated as described in the text.

makeltparts `varlist', caption(`caption') width(`width') notes(`notes')
listtab Var `varlist' if `univ', type rstyle(tabular) head(`"`headline'"') foot(`"`footline'"') appendto(`tloga')

// detail (metacoders) [within wave truth]
local caption 	Reliability gains due to meta-coders by item (\textsc{rmse}) 
local varlist 	Smsd_21 Smsd_51 Smeta_gain Smsd_23 Smeta_vs_ra Smeta_vs_ra_pct 
local width 	5.25in
local univ 	/*sdType==1 & */Var!=6

makeltparts `varlist', caption(`caption') width(`width') notes(`notes')
listtab Var `varlist' if `univ', type rstyle(tabular) head(`"`headline'"') foot(`"`footline'"') appendto(`tloga')

 

clear *
args tlog flog tloga floga

local textwidth 6.5
local wgtopt wgt(pervar)
local typeopt type(conger)

local skipcalcs     $calculateReliability
local skipmeta      $calculateReliability
local skipIndivMeta $calculateReliability

local stat conger
local statF Conger’s $\kappa$
local dvlist flag mention* ecAppeal etPositive etNegative em* tFc* tOc* ideologyFc ideologyOc
local weightform with ordinal weights for three-point emotion items and quadratic weights for 101-point ideology items

******************
* Calculate reliability
******************
// Aggregate -- Individual Coders
use dataSets/hitlevel_work1

replace codingType = 10 if inrange(codingType,1,4) 
replace codingType = 20 if inrange(codingType,5,6) 

local fn `stat's_agg_mturk
`skipcalcs' collectkappa `dvlist' if codingType==10 using auxds/`fn', replace note("Aggregate mTurk") `wgtopt' `typeopt' vnlabfile(auxSyntax/vnlabel.do)
local flist `flist' auxds/`fn'

local fn `stat's_agg_ra
`skipcalcs' collectkappa `dvlist' if codingType==20 using auxds/`fn', replace note("Aggregate RAs") `wgtopt' `typeopt' vnlabfile(auxSyntax/vnlabel.do)
local flist `flist' auxds/`fn'

******* Aggregate -- metacoders
clear
use dataSets/hitlevel_metacoders

keep if coderType==1		// only mTurkers
by adName, sort: gen nMturkMetaCoders = _N
keep if nMturkMetaCoders>1

// single codingType so we include all possible metacoders
replace codingType = 100
`skipmeta' collectkappa `dvlist' if codingType==100 using auxds/`stat's_metaMturk, `wgtopt' `typeopt' replace note("mTurk metacoders") vnlabfile(auxSyntax/vnlabel.do)
local flist `flist' auxds/`stat's_metaMturk


******* individual coders on ads with metacoders
clear
use dataSets/hitlevel_work1
// Aggregate -- Individual Coders
replace codingType = 110 if inrange(codingType,1,4)  // mTurk workers (on meta subset)
replace codingType = 120 if inrange(codingType,5,6)  // Research assistants (on meta subset)

sort adName
merge m:1 adName using dataSets/metaAdNames
assert _merge==3 | _merge==1
keep if _merge==3

local fn `stat's_agg_mturk_subset
`skipIndivMeta' collectkappa `dvlist' if codingType==110 using auxds/`fn', replace note("mTurk (on meta subset)") `wgtopt' `typeopt' vnlabfile(auxSyntax/vnlabel.do)
local flist `flist' auxds/`fn'

local fn `stat's_agg_ra_subset
`skipIndivMeta' collectkappa `dvlist' if codingType==120 using auxds/`fn', replace note("RA (on meta subset)") `wgtopt' `typeopt' vnlabfile(auxSyntax/vnlabel.do)
local flist `flist' auxds/`fn'


**************************
* PULL DATASETS TOGETHER
*************************
clear
gen file = ""
local nf : word count `flist'
forval i=`nf'(-1)1 {
	local ds : word `i' of `flist'
	append using `ds'
	replace file = "`ds'" if mi(file)
}

do auxSyntax/codingTypeLabel
label values codingType codingType
save auxds/`stat'DataWaves, replace

// create averages for sets of items
drop *Nads* wgtexp
reshape wide `stat' , i(codingType) j(Var)
aorder
do auxSyntax/vnlabel.do
egen `stat'201 = rowmean(`stat'4 `stat'5)		// economic tone
egen `stat'202 = rowmean(`stat'7-`stat'10)		// 3-way emotion
egen `stat'203 = rowmean(`stat'29-`stat'32)		// dichot emotion
egen `stat'204 = rowmean(`stat'33 `stat'34)		// dichot candidate appears at all
egen `stat'205 = rowmean(`stat'15-`stat'18)	// Fc traits
egen `stat'206 = rowmean(`stat'19-`stat'22)	// Oc traits
egen `stat'207 = rowmean(`stat'27 `stat'28)	// ideology
reshape long

// reshape and better labels
format %3.2f `stat'
drop file coderType note 
reshape wide `stat'  , i(Var) j(codingType)

do auxSyntax/codingTypeLabel
do auxSyntax/vllabel
la val Var vllabel
foreach var of varlist `stat'* {
	local num : subinstr local var "`stat'" "", all
	la var `var' "`: label codingType `num''"
}
order Var `stat'*

// add bold and spacing for detail table
label copy vllabel vllabelX
foreach i in 1 201 6 202 203 204 205 206 207 {
	la de vllabelX `i' `"{\bfseries `: label vllabelX `i''}"', modify
}
foreach i in 1 7 29 13 15 19 27 33 {
	la de vllabelX `i' "\addlinespace `: label vllabelX `i''", modify
}
la val Var vllabelX

merge 1:1 Var using rawData/TableSortOrder, keep(match master)
drop _merge
sort sort

**************
* Comparisons
**************
la val Var vllabel
local eq `stat'10-`stat'20
gen `stat'_agg_diff = `eq'
gen S`stat'_agg_diff = cond(!mi(`eq'),    cond(`eq'>0,"+","-")+string(`stat'_agg_diff,"%3.2f") , "---")	// generates double-equal-sign for negatives
la var S`stat'_agg_diff "mTurk vs. RA"

local eq (`stat'_agg_diff/`stat'20)*100
gen `stat'_agg_pct = `eq'
gen S`stat'_agg_pct = cond(!mi(`eq'),    cond(`eq'>0,"+","-")+string(`stat'_agg_pct,"%3.0f")+"\%" , "---")	// generates double-equal-sign for negatives
la var S`stat'_agg_pct "mTurk vs. RA (\%)"
format `stat'_* %3.2f

local eq `stat'100-`stat'110
gen metagain = `eq'
gen Smetagain = cond(!mi(`eq'),    cond(`eq'>0,"+","-")+string(metagain,"%3.2f") , "---")	// generates double-equal-sign for negatives
la var Smetagain "Difference: meta-coder gain"

local eq `stat'100-`stat'120
gen metaVsRA = `eq'
gen SmetaVsRA = cond(!mi(`eq'),    cond(`eq'>0,"+","-")+string(metaVsRA,"%3.2f") , "---")	// generates double-equal-sign for negatives
la var metaVsRA "meta-mTurk vs. RA"
la var SmetaVsRA "meta-mTurk vs. RA"

local eq (metaVsRA/`stat'120)*100
gen metaVsRApct = `eq'
gen SmetaVsRApct = cond(!mi(`eq'),    cond(`eq'>0,"+","-")+string(metaVsRApct,"%3.0f")+"\%" , "---")	// generates double-equal-sign for negatives
la var metaVsRApct "meta-mTurk vs. RA (\%)"
la var SmetaVsRApct "meta-mTurk vs. RA (\%)"

foreach var of varlist `stat'20 `stat'10 `stat'110 `stat'100 `stat'120 {
	gen S`var' = string(`var',"%3.2f")
	la var S`var' "`: variable label `var''"
}

gen forsumtable = inlist(Var,1,201,6,202,203,204,205,206,207)
**************************
* Make tables
**************************
local tablenotes "\item \hspace{-1em}Entries are `statF' for multiple raters; `weightform', averaged across individual items. Coefficients calculated by Stata add-on \texttt{kappaetc} (Klein 2017)."
local tablenotesA "\item \hspace{-1em}Rows in boldface correspond to those in the summary tables in the main paper."
local tablenotesD "\item \hspace{-1em}$^{1}$ Emotion coding is on a three-point scale (strong, weak, none); dichotomized versions collapse strong and weak."
local tablenotesM "\item \hspace{-1em}Meta-coders are created by averaging five randomly-selected mTurk coders, and then rounding the result to generate a categorical code. Analysis restricted to ads for which we have more than one meta-coder."


* SET UP DETAILED TABLES
la val Var vllabelX
// make string versions of all variables & bold summary rows
foreach var of varlist  S`stat'20 S`stat'10 S`stat'_agg_diff S`stat'_agg_pct S`stat'110 S`stat'100 Smetagain S`stat'120 SmetaVsRA SmetaVsRApct {
	replace `var' = "{\bfseries "+`var'+"}" if forsumtable 
	replace `var' = subinstr(`var',"{\bfseries \addlinespace","\addlinespace {\bfseries",.)
}

// Detailed table --> appendix
local caption 		Inter-coder reliability statistics by item (`statF')
local `stat'list 	S`stat'20 S`stat'10 S`stat'_agg_diff S`stat'_agg_pct
local width 		4.25in
local univ		!inlist(Var,11,12,13,14,23,25)
local notes 		`tablenotes'`tablenotesD'`tablenotesA'

makeltparts  ``stat'list', caption(`caption') width(`width') notes(`notes')
listtab Var ``stat'list' if `univ', type rstyle(tabular) head(`"`headline'"') foot(`"`footline'"') appendto(`tloga')


// Detailed table: metacoders
local caption 		Reliability gains from aggregation, by item (`statF')
local `stat'list 	S`stat'110 S`stat'100 Smetagain S`stat'120 SmetaVsRA SmetaVsRApct
local width 		5.25in
local univ		!inlist(Var,11,12,13,14,23,25) & !(Var==6)
local notes 		`tablenotes'`tablenotesM'`tablenotesD'`tablenotesA'

makeltparts  ``stat'list', caption(`caption') width(`width') notes(`notes')
listtab Var ``stat'list' if `univ', type rstyle(tabular) head(`"`headline'"') foot(`"`footline'"') appendto(`tloga')


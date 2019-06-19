/*
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
*/

	version 12
	
	project, doinfo
	local pdir "`r(pdir)'"							// the project's main dir.
	local dofile "`r(dofile)'"						// do-file's stub name


* Example 1

	project, original("`pdir'/data/stata/hbp2.dta")
	use "`pdir'/data/stata/hbp2.dta"
	
	// we don't want the do-file to stop so we capture the error
	capture noisily regress hbp sex race age_grp
	
	encode sex, gen(gender)
	
	regress hbp gender race age_grp


* Example 2

	list sex gender in 1/4
	
	list sex gender in 1/4, nolabel
	
	label list gender
	

* Example 3

	use "`pdir'/data/stata/hbp2.dta", clear
	
	describe
	
	encode sex, generate(gender)
	
	list sex gender in 1/5
	
	drop sex
	rename gender sex
	compress
	describe
	
	
	// technical note
	use "`pdir'/data/stata/hbp2.dta", clear

	label define gender 0 "female"
	encode sex, gen(gender)
	
	label define sexlbl 0 "female"
	encode sex, gen(gender2) label(sexlbl)
	
	list sex gender gender2 in 1/5
	list sex gender gender2 in 1/5, nolabel


* Example 4

	project, original("`pdir'/data/stata/hbp3.dta")
	use "`pdir'/data/stata/hbp3.dta"
	
	describe female
	
	label list sexlbl
	
	tabulate female
	
	decode female, gen(sex)
	
	describe sex
	
	list female sex in 1/4
	
	list female sex in 1/4, nolabel
	

* Example 5

	clear
	input str2 state2 n1
	"AL" 1
	"CA" 2
	"NY" 3
	end
	
	encode state2, gen(state)
	list
	list , nolabel
	
	keep state n1
	tempfile first
	save "`first'"
	
	clear
	input str2 state2 n2
	"AL" 4
	"AK" 5
	"CA" 6
	"NY" 7
	end
	
	encode state2, gen(state)
	list
	list , nolabel
	
	keep state n2
	tempfile second
	save "`second'"
	
	clear
	use "`first'"
	decode state, gen(st)
	drop state
	sort st
	save "`first'", replace
	use "`second'"
	decode state, gen(st)
	drop state
	sort st
	merge 1:1 st using "`first'"
	
	list

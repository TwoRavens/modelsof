/*
	Loads CEX for 2004-2015 from unzipped files, collapses it to the UCC*person*year level
	Sample stats: https://www.bls.gov/cex/sampling-methods.pdf
*/

global root "D:\Dropbox\unequal_gains\QJE revision plan\analysis\CEX"
cd "$root/Raw/CEX/Data"

forvalues year = 2015(-1)2004 { 

	// Set up folders
	local nyear = `year'+1
	local yr = string(mod(`year',100),"%02.0f")
	local nyr = string(mod(`year'+1,100),"%02.0f")
	unzipfile intrvw`yr'.zip
	unzipfile diary`yr'.zip

	if inrange(`year',1997,1998) local ifolder = "intrvw`yr'/intrvw`yr'/"
		else if (`year'==1999) local ifolder = ""
		else local ifolder = "intrvw`yr'/"

	if inrange(`year',2013,2015) local dfolder = "diary`yr'/"
		else local dfolder = "diary`yr'/diary`yr'/"

	
	// Prepare data on panelists
	clear
	foreach f in `yr'1x `yr'2 `yr'3 `yr'4 `nyr'1  {
		append using "`ifolder'fmli`f'"
		cap gen quarter = ""
		replace quarter = "`f'" if mi(quarter)
	} 
	gen survey="I"
	foreach f in `yr'1 `yr'2 `yr'3 `yr'4 {
		append using "`dfolder'fmld`f'"
		replace quarter = "`f'" if mi(quarter)
	}
	replace survey="D" if missing(survey) 
	
	cap gen income = fincbtxm if survey=="I"
	cap gen income = fincbefx if survey=="I" // in early years same var in I as in D in later years; inclass=10 is strange (e.g. in 2000)
	if `year'>2005 replace income = fincbefx if survey=="D"  // all of these vars are mostly consistent with inclass
    if `year'<2006 replace income = fincbefm if survey=="D" // variable name is slightly different in 2004-2005
	
	keep survey newid educ_ref educa2 inclass income cutenure bls_urbn region state fam_type fam_size earncomp age_ref age2 sex_ref sex2 quarter 
	// Can add occupation: occucod1/2 for interviews, but need to go to MEMD for diaries

	gen year = `year'
	
	destring educ_ref, replace
	drop if missing(educ_ref) | missing(inclass)
	gen educ="some college"
	gen educ_num=2
	replace educ="college" if educ_ref>14
	replace educ_num=3 if educ_ref>14
	replace educ="no college" if educ_ref<13
	replace educ_num=1 if educ_ref<13
	
	gen college = educ_num==3 if !mi(educ_num)
	drop educ_ref
	
	destring inclass bls_urbn cutenure earncomp fam_type region state sex_ref sex2, replace
	
	gen college_spouse = real(educa2)>14 if !mi(educa2)
	egen mean_college = rowmean(college college_spouse)
	drop educa2 college_spouse
	
	recode income (-10000000/4999.99 = 1) (5000/9999.99 = 2) (10000/14999.99 = 3) (15000/19999.99 = 4) (20000/29999.99 = 5) (30000/39999.99 = 6) (40000/49999.99 = 7) ///
		(50000/69999.99 = 8) (70000/3000000 = 9), gen(inclass_repl)

	drop if income < 5000 // Like in Nielsen, drop these
	recode income (-10000000/4999.99 = .) (5000/10000 = 2) (10000/20000 = 3) (20000/30000 = 4) (30000/40000 = 5) (40000/50000 = 6) ///
		(50000/60000 = 7) (60000/75000 = 8) (75000/90000 = 9) (90000/110000 = 10) (110000/150000 = 11) (150000/3000000 = 12), gen(income_bin)
	recode income_bin (2 = 7.5) (3 = 15) (4 = 25) (5 = 35) (6 = 45) (7 = 55) (8 = 67.5) (9 = 82.5) (10 = 100) (11 = 130) (12 = 218), gen(income_bin_midpoint)
	
	egen mean_age = rowmean(age_ref age2)
	drop age_ref age2
	
	gen sex = sex_ref if mi(sex2) | sex_ref==sex2 // 1 = male only, 2 = female only
	replace sex = 3 if sex_ref+sex2==3  // 3 = both
	drop sex_ref sex2
	
	cap tostring newid, replace
	gen cuid = substr(newid,1,length(newid)-1)
	destring cuid, replace
	save "$root/Temp/cex_panelists_`year'.dta", replace
		
	// Prepare spending files
	foreach f in `yr'1x `yr'2 `yr'3 `yr'4 `nyr'1 {
		use "`ifolder'mtbi`f'", clear
		gen survey="I"
		merge m:1 newid using "`ifolder'fmli`f'", keepusing(finlwt21 qintrvmo qintrvyr) keep(3) nogen
		merge m:1 ucc survey using "$root/Processed/CEX/Codebook/csxintstub`year'"
		tab _merge 
		tab _merge if pubflag=="2"
		assert _merge!=2 if pubflag=="2"
		keep if (_m==3 & consumption==1)
		drop _m 
		gen year = `year'
		gen quarter="`f'"
		cap tostring newid, replace
		gen cuid=substr(newid,1,length(newid)-1)
		tempfile ifile`f'
		save `ifile`f''
	}

	foreach f in `yr'1 `yr'2 `yr'3 `yr'4 {
		use "`dfolder'expd`f'", clear
		gen survey="D"
		merge m:1 newid using "`dfolder'fmld`f'", keepusing(finlwt21) keep(3) nogen
		merge m:1 ucc survey using "$root/Processed/CEX/Codebook/csxintstub`year'"
		tab _merge 
		rename pub_flag pubflag
		tab _merge if pubflag=="2"
		assert _merge!=2 if pubflag=="2"
		tab _merge
		keep if (_m==3 & consumption==1)
		drop _m 
		gen year = `year'
		gen quarter="`f'"
		cap tostring newid, replace
		gen cuid=substr(newid,1,length(newid)-1)
		tempfile dfile`f'
		save `dfile`f''
	}

	* Note: the match rate if perfect conditional on puflag==2 (which is the UCCs part of the public statistics)
	* there is no match if UCC is different from quarters 

	clear
	append using `ifile`yr'1x'
	append using `ifile`yr'2'
	append using `ifile`yr'3'
	append using `ifile`yr'4'
	append using `ifile`nyr'1'
	append using `dfile`yr'1'
	append using `dfile`yr'2'
	append using `dfile`yr'3' 
	append using `dfile`yr'4'

	* B. Rescale appropriately 

	* create mo_scope variable to adjust consumer spending in interview file, following BLS:
	gen mo_scope=.
	replace mo_scope=0 if qintrvmo=="01" & qintrvyr=="`year'"
	replace mo_scope=1/3 if qintrvmo=="02" & qintrvyr=="`year'"
	replace mo_scope=2/3 if qintrvmo=="03" & qintrvyr=="`year'"
	replace mo_scope=1 if real(qintrvmo)>3 & qintrvyr=="`year'"
	replace mo_scope=1 if qintrvmo=="01" & qintrvyr=="`nyear'"
	replace mo_scope=2/3 if qintrvmo=="02" & qintrvyr=="`nyear'"
	replace mo_scope=1/3 if qintrvmo=="03" & qintrvyr=="`nyear'"

	* adjust some codes
	replace cost=cost/12 if ucc=="910103" // annual imputed value of vacation home
	replace cost=-cost if uccgroup=="MORTGAGE" // principal reduction is recorded as assets, with a negative

	replace cost=cost*52/4 if survey=="D" // convert week to quarterly spending
	replace cost=cost*mo_scope if survey=="I"

	* collapse by newid
	collapse (sum) cost, by(newid ucc uccname uccgroup uccclass survey finlwt21 mo_scope) fast // drop category lettergroup lettergroupname to save space
	* note: the weights finlwt21 sum up to the full population in each quarter

	merge m:1 newid survey using "$root/Temp/cex_panelists_`year'"
	keep if _merge==3
	drop _merge 
	*replace category="Housing" if category=="Imputed rents"

	compress
	save "$root/Temp/merged_int_diary_`year'.dta", replace

	distinct ucc
}

clear
forvalues year = 2015(-1)2004 {
	append using "$root/Temp/merged_int_diary_`year'.dta"
}
drop if cost<=0
save "$root/Processed/CEX/merged_int_all_years", replace

forvalues year = 2015(-1)2004 {
	erase "$root/Temp/merged_int_diary_`year'.dta"
}

clear
forvalues year = 2015(-1)2004 {
	append using "$root/Temp/cex_panelists_`year'.dta"
}
save "$root/Processed/CEX/cex_panelists_all_years", replace

forvalues year = 2015(-1)2004 {
	erase "$root/Temp/cex_panelists_`year'.dta"
}

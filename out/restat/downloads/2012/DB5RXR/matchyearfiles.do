version 8
clear
set memory 700m
capture log close
log using ${pap4log}matchyearfiles, text replace
set more off

***09.11.2005***RBal**************************************************
* Use matchpanel.dta from matchpanel.do and split it in separate
* year files merging in info from both industry data and register
* data. Must be rerun to pick other variables from REG_DIR, but 
* additional vars from industry data can be added later
* Save as matchYYYY.dta-files
***********************************************************************

* Create temporary year files from foumerge_mob.dta: keep only 
* relevant variables
forvalues t=1989/2000 {
	use ${industri}foumerge_mob.dta, clear
	keep if aar==`t'
	#delimit ;
	keep aar bnr naering v13 v15 v38 totutenl indirutenl;
	#delimit cr
	sort bnr
	compress	
	save ${pap4data}ind`t', replace
}


* Create temporary year files from registerdata keep only 
* selected variables
forvalues t=1989/2000 {
	use ${REG_DIR}adssb`t', clear
	rename plant bnr
	rename yr aar
	keep aar bnr pid sex citz eduy edudt edut89 edut00 hrs jstart jstop pearn ltoearn njobs isic5 age
	sort pid
	compress
	save ${pap4data}reg`t', replace
}


* Merge info from year files of ind and reg data to matchpanel
forvalues t=1989/2000 {
	use ${pap4data}matchpanel.dta, clear
	keep if aar==`t'
	sort bnr
	save ${pap4data}sort.dta, replace
	merge bnr using ${pap4data}ind`t'
	drop if _merge==2
	drop _merge
	sort pid
	save ${pap4data}sort.dta, replace
	merge pid using ${pap4data}reg`t'
	assert _merge==1 if pid==.
	drop if _merge==2
	drop _merge
	sum
	compress
	save ${pap4data}match`t'.dta, replace
}


* erase ind and reg year files 
	forvalues t=1989/2000 {
		erase ${pap4data}ind`t'.dta
		erase ${pap4data}reg`t'.dta
	}
	erase ${pap4data}sort.dta
capture log close 
exit






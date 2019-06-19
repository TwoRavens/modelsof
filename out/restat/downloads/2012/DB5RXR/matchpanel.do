version 8
clear
set memory 900m
capture log close
set more off

* 1. 
* Merge registerdata and industry data files
* 2. 
* Some basic checks of the data
* 4. 
* Drop plants that never get a match
* 5.
* Generate a matched panel containing all individuals working in
* matched manufacturing plants, and information (=pid year) for 
* individuals 1 year before and 1 year after they are observed in a
* manufacturing plant from inddta.
***********************************************************************

* 1. Merge industry data onto individual data
* First make year files of industry data in industripanel1.dta. This is 
* the main industry panel used in paper2
	

forvalues t=1989/2000 {
	use ${industri}foumerge.dta, clear
	keep if aar==`t'
	keep aar bnr naering v13 v38
	egen totv13=sum(v13)
	label var totv13 "total no of employees in manufacturing year t"
	gen wage=(v38/v13)*1000
	label var wage "plant level average wage"
	compress	
	sort bnr
	save ${pap4data}ind`t', replace
}

* Merge plant information onto individual information in registerdata
* and save the year files
forvalues t=1989/2000 {
	use ${REG_DIR}adssb`t', clear
	rename plant bnr
	rename yr aar
	keep aar bnr pid pearn njobs
	compress
	sort bnr
	save ${pap4data}reg`t', replace 
	merge bnr using ${pap4data}ind`t'
	display " tab merge in year `t'"
	tab _merge
	drop if _merge==1
	save ${pap4data}match`t', replace
}

* Drop temporary ind. and reg. files
forvalues t=1989/2000 {
	erase ${pap4data}ind`t'.dta
	erase ${pap4data}reg`t'.dta
}


* 2.
* Check that each ind is observed only once per year,
* Check correspondence between reg. data manuf employed and tot empl from inddta
* Check correspondence in terms of employment per plant
* Check correspondenc in terms of average wage per plant

forvalues t=1989/2000 {
	use ${pap4data}match`t', clear
	bys pid: gen N=_N
	assert N==1 if _merge!=2
	drop N
	display " the number of unmatched plants in year `t' is:"
	count if _merge==2
	quietly count if _merge==3
	quietly gen empl=r(N)
	quietly gen x=empl/totv13  
	egen y=min(x)
	display "Industry empl in regdta relative to ind empl in inddta in `t'"
	list y in 1
	display "Distribution of the no. of secondary jobs in year `t'"
	tab njobs if _merge==3
	drop x y empl
	bys bnr: gen N=_N
	assert N!=.
	quietly gen empl=N if _merge==3
	quietly gen x=empl/v13 if _merge==3
	display "Summary of empl per plant according to reg data"
	display "relative to empl per plant according to ind.dta: year `t'"
	sum x, det
	bys bnr: gen n=_n
	display "No. of plants with exact correspondence of v13 and empl from reg data"
	count if empl==v13 & n==1
	drop x
	bys bnr: egen wagecost=sum(pearn)
	quietly gen regwage=wagecost/N if _merge==3
	quietly gen x=regwage/wage
	display "Summary of average wage per empl according to reg data"
	display "relative to average wage per empl  according to ind.dta: year `t'"
	sum x, det
	display "No. of plants with wage correspondence +/-10%"
	count if x>0.9 & x<1.1 & n==1
	display "Total no. of plants with match in year `t'"
	count if n==1 & _merge==3
	keep aar pid bnr _merge
	label var _merge "Indicator from merging of indstat and regdata"
	sort pid
	save ${pap4data}match`t'.dta, replace
}


* 3.
* Make a panel of the merged year files 
use ${pap4data}match1989.dta, clear
forvalues t=1990/2000 {
		append using ${pap4data}match`t'.dta
	compress
	
}

* 4.
* Drop plants that never got a match
	bys bnr: egen x=max(_merge)
	bys bnr: egen y=min(_merge)
	assert x==2 | x==3
	assert y==2 | y==3
	drop if x==y & x==2
	tab _merge	
	keep aar pid bnr _merge 
	assert bnr!=. 
* Save matchpanel.dta: contains pid for individuals only for the years when they 
* work in plants found in inddta. and bnr year for plants where we did not
*  find any individuals in regdir (these obs have _merge==2)
	sort pid aar
	save ${pap4data}matchpanel.dta, replace

* 5.
* Generate a matched panel containing all individuals working in
* matched manufacturing plants, and information (=pid year) for 
* individuals 1 year before and 1 year after they are observed in a
* manufacturing plant from inddta.
	* keep only obs with pid
	keep if _merge==3
 	keep pid aar bnr
	* fill in pid they years they are not observed in manuf.
	fillin pid aar
	drop if pid==.
	* Keep only the filled in obs the year before and after
	* being employed in manufacturing
	tsset pid aar
	sort pid aar
	gen x=1
	while x<15 {
		bys pid: gen n=_n
		bys pid: gen N=_N
		sort pid aar
		drop if bnr==. & F.bnr==. & n==1
		drop if bnr==. & L.bnr==. & N==n
		drop n N
		replace x=x+1
	}
	count
	sort pid aar
	merge pid aar using ${pap4data}matchpanel.dta, _merge(mer)
	tab mer
	tab _merge
	assert _fillin==1 if mer==1
	tab mer _merge
	
* Save the resulting panel, it has missing pid for 5000 plants
* for which we found no employees in regdata, and has missing 
* bnr for the years just before and just after we observe an
* individual working in a plant from the industrydata
	keep pid aar bnr 
	compress
	save ${pap4data}matchpanel.dta, replace
* Erase the year files of match data
forvalues t=1989/2000 {
	erase ${pap4data}match`t'.dta
}
capture log close
exit

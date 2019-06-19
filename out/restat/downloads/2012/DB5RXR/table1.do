version 8
clear
set memory 500m
capture log close
set more off

***21.11.2005***RBal***********************************************
* generate a table with info of number of plants, and full time 
* workers by MNE-type. 
* 90% of all workers are full time workers.  
* 1. Export as table1.tex (using wagereg1temp.dta/industripanel1.dta)
* 2. or as table1_all.tex (using matches from foumerge.dta)
* The main difference betw table1 and _all lies in the # of nonMNEs,
* (the double in _all), their size (smaller in _all) and tot employees
* (a bit higher in nonMNEs in _all).
***Rev 03.04.2006 * take out very low wages ***********************
***Rev 05.04.2006 * Make table1_all ********************************



* 1. Make table based on cleaned plant data in industripanel1

* Make the relevant panel 
	use ${pap4data}wagereg1temp.dta, clear
	* this panel has only full-time workers 
	* and is based on industripanel1,
* Clean with respect to very low wages, less than 1% of sample dropped
	keep if aar>=1990
	count
	drop if realwage<12000
	gen MNE=2 if dommne==1
	replace MNE=1 if formne==1
	replace MNE=0 if MNE==.
	keep aar bnr pid  MNE
	save ${pap4data}panel.dta, replace

* Make a table that distinguishes between local 
* domestic firms and domestic and foreign multinationals

* Make columns with no of plants per year
	set more off
	bys aar bnr: gen N=_N
	bys aar bnr: gen n=_n
	keep if n==1
	collapse (mean) N (count) bnr, by(aar MNE)
	sort aar MNE
	mkmat bnr if MNE==0, matrix(A)
	matrix colname A="DomP"
	matrix rownames A="1990" "1991" "1992" "1993" "1994" "1995" "1996" "1997" "1998" "1999" "2000" 
	mkmat bnr if MNE==1, matrix(B)
	matrix colname B="forMNE"
	mkmat bnr if MNE==2, matrix(C)
	matrix colname C="domMNE"

* Make column with average number of full time worker matches 
	mkmat N if MNE==0, matrix(D)
	matrix colname D="SizeD"
	mkmat N if MNE==1, matrix(E)
	matrix colname E="forMNE"
	mkmat N if MNE==2, matrix(F)
	matrix colname F="domMNE"

* Make columns with number of full time workers per year for dom and foreign
	use ${pap4data}panel.dta, clear
	collapse (count) pid, by(aar MNE)
	sort aar MNE
	mkmat pid if MNE==0, matrix(G1)
	matrix colname G1="FulltimeD"
	mkmat pid if MNE==1, matrix(G2)
	matrix colname G2="forMNE"
	mkmat pid if MNE==2, matrix(G3)
	matrix colname G3="domMNE"


* Put the matrices togehter into "table1"
	matrix H=A,B,C,D,E,F,G1,G2,G3
	matrix list H

* Export as table
	outtable using ${pap4tab}table1, mat(H) nobox center f(%6.0f) replace caption("Foreign and domestic plants and workers")

	matrix drop _all

* 2.
* Make same table as above, but based on the matched panel using foumerge.dta

	forvalues t=1990/2000 {
		use ${pap4data}match`t', clear
		quietly keep if pid!=.
		quietly keep if bnr!=.
		sort bnr aar
		merge bnr aar using ${industri}foumerge_mob.dta, keep(v13)
		quietly keep if _merge==3
		drop _merge
		quietly keep if hrs==3
	* define real monthly wage, base year 2001
		sort aar
		merge aar using ${pap4data}kpi.dta, keep(kpi)
		quietly gen realwage=(pearn/12)*(100/kpi)
		quietly keep if _merge==3
		keep aar bnr pid v13 realwage
		save ${pap4data}ratio`t'.dta, replace
	}

	use ${pap4data}ratio1990.dta, clear
	forvalues t=1991/2000 {
		append using ${pap4data}ratio`t'.dta
	}

* Merge in indicators for foreign and domestic MNEs
	sort bnr aar
	merge bnr aar using ${industri}mne.dta
	drop if aar==2001
	tab _merge
	drop if _merge==2
	drop _merge	
	drop if realwage<12000
	keep if aar>=1990
	gen MNE=2 if dommne==1
	replace MNE=1 if formne==1
	replace MNE=0 if MNE==.
	keep aar bnr pid  MNE

* Save temporary data file
	compress
	save ${pap4data}panel.dta, replace

* Erase constructed year files
	forvalues t=1990/2000 {
		erase ${pap4data}ratio`t'.dta
	}

* Make a table that distinguishes between local 
* domestic firms and domestic and foreign multinationals

* Make columns with no of plants per year
	use ${pap4data}panel.dta, clear
	set more off
	bys aar bnr: gen N=_N
	bys aar bnr: gen n=_n
	keep if n==1
	collapse (mean) N (count) bnr, by(aar MNE)
	sort aar MNE
	mkmat bnr if MNE==0, matrix(A)
	matrix colname A="DomP"
	matrix rownames A="1990" "1991" "1992" "1993" "1994" "1995" "1996" "1997" "1998" "1999" "2000" 
	mkmat bnr if MNE==1, matrix(B)
	matrix colname B="forMNE"
	mkmat bnr if MNE==2, matrix(C)
	matrix colname C="domMNE"

* Make column with average number of full time worker matches 
	mkmat N if MNE==0, matrix(D)
	matrix colname D="SizeD"
	mkmat N if MNE==1, matrix(E)
	matrix colname E="forMNE"
	mkmat N if MNE==2, matrix(F)
	matrix colname F="domMNE"

* Make columns with number of full time workers per year for dom and foreign
	use ${pap4data}panel.dta, clear
	collapse (count) pid, by(aar MNE)
	sort aar MNE
	mkmat pid if MNE==0, matrix(G1)
	matrix colname G1="FulltimeD"
	mkmat pid if MNE==1, matrix(G2)
	matrix colname G2="forMNE"
	mkmat pid if MNE==2, matrix(G3)
	matrix colname G3="domMNE"


* Put the matrices togehter into "table1_all"
	matrix H=A,B,C,D,E,F,G1,G2,G3
	matrix list H

* Export as table
	outtable using ${pap4tab}table1_all, mat(H) nobox center f(%6.0f) replace caption("Foreign and domestic plants and workers")


	erase ${pap4data}panel.dta
	matrix drop _all

capture log close 
exit






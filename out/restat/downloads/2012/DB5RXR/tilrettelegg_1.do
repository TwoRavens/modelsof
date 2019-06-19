clear
version 10
set memory 400m
set more off


****RB 27.01.2009 **************************
* Use delivered files about outgoing investment 
* from Norway, and construct a panel 
* of Norwegian based MNEs. keep only variables 
* on ownership shares abroad
********************************************


* use original files from Statistics Norway
	insheet using ${mne}utg1998.csv, delimit(";")
	quietly destring, replace
	quietly gen aar=1998	
	destring eierandel stemmeandel indirekte_eierandel indirekte_stemmeandel,  replace dpcomma force
	quietly save ${rep}utginv1998.dta, replace
		

* Read in csv files, generate year variable and append the data
	forvalues t=1990/1997 {
		clear
		insheet using ${mne}utg`t'.csv, delimit(";")
		quietly destring, replace
		quietly gen aar=`t'
		drop iso	
		quietly save ${rep}utginv`t'.dta, replace
	}
	forvalues t=1999/2005 {
		clear
		insheet using ${mne}utg`t'.csv, delimit(";")
		quietly destring, replace
		quietly gen aar=`t'
		destring eanddir stemdir eandind stemind utbpr_dir utbpr_ind,  replace dpcomma force
		drop kprisdir
		quietly save ${rep}utginv`t'.dta, replace
	}

	use ${rep}utginv1990.dta, clear
	
	forvalues t=1991/2005{
		append using ${rep}utginv`t'.dta
		erase ${rep}utginv`t'.dta
	}
	
	erase ${rep}utginv1990.dta

* Name and id number of norwegian firm in Norway
	replace orgnr=identitet if orgnr==. & identitet!=.
	count if orgnr==.
	drop if orgnr==.
	label var orgnr "Plant code Norwegian firm"
	

* Name and id number of norw.-owned firm abroad
	replace lopenr=lopnr if aar==1998
	drop lopnr
	assert objektnr==v6 if v6!=.
	assert objektnr==v32 if v32!=.
	drop v6 v32
	replace objektnr=lopenr if aar>=1998
	assert objektnr!=.
	label var objektnr "Firm identification foreign affiliate"
	

	replace nace=nace1 if aar<1998
	drop nace1
	label var nace "Industrial classification for Norwgian firm (Nace)"
	label var sektor "Economic sector Norwegian firm"
	

* Variables concerning direct and inderect ownership- and voting- shares
* name  and data type change in 1999
	des eierandel eanddir stemmeandel stemdir indirekte_eierandel eandind indirekte_stemmeandel stemind
	replace eanddir=eierandel if aar<1999
	replace stemdir=stemmeandel if aar<1999
	replace eandind=indirekte_eierandel if aar<1999
	replace stemind=indirekte_stemmeandel if aar<1999
	label var eanddir "Direct ownership in foreign affiliate (percentage)"
	label var stemdir	"Direct voting right in foregn affiliate (percentage)"
	label var eandind	"Indirect ownership in foreign affiliate (percentage)"
	label var stemind	"Indirect voting right in foregn affiliate (percentage)"
	drop eierandel stemmeandel indirekte_eierandel indirekte_stemmeandel
	* 2 obs have stemind>100 (same firm), I assumme the comma was 
	* placed wrong in the original files and divide by 100
		count if stemind>100 & stemind!=.
		replace stemind=stemind/100 if stemind>100
	* some missing obs, but only from 1999, replace these with zero
	foreach t in eanddir stemdir eandind stemind {
		replace `t'=0 if `t'==.
		assert `t'>=0 & `t'<=100
	}
	

	sort orgnr aar
	keep aar orgnr objektnr nace sektor eanddir stemdir eandind stemind 
	save ${rep}mnepanel.dta, replace

 
exit




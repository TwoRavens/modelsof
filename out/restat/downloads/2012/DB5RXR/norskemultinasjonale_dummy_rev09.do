
version 10
clear
capture program drop _all
capture log close
set more off
set memory 200m

******************************************
* Saves mne.dta which is a panel of manufacturing plants with 
* dummy for foreign and domestic MNE status is included
* These dummies are based on the SIFON register and register of
* outward FDI, prepared in the previous 3 dofiles.
****************************************************

* 1.

	use ${pap4data}mnepanel.dta, clear
	drop if orgnr==.
* Possible definitions of a multinational
* Associate a dummy with each orgnr each year
* Must have one foreign object with a minimun ownershare; say 10%
* What about indirect ownership?
	sum eanddir stemdir eandind stemind, det
	count if eanddir==.
	count if eandind==.
	count if eanddir==stemdir
	count if eandind==stemind
	count if eanddir<20 & eanddir!=0
* Make a dummy=1 if direct ownership is above10%
	count if eanddir>=10 & eanddir!=.
	count if eanddir>=20 & eanddir!=.
	gen x=1 if eanddir>=10 & eanddir!=.
	replace x=0 if x==.
	bys aar orgnr: egen y=sum(x)	
	bysort aar orgnr: gen N=_N
	bysort aar orgnr: gen n=_n
	tab n if n==N
	tab y if n==N
	gen norskmne10=1 if y>=1
	replace norskmne10=0 if norskmne10==.
	drop x y 
* Make a dummy=1 if direct ownership is above 20%
	gen x=1 if eanddir>=20 & eanddir!=.
	replace x=0 if x==.
	bys aar orgnr: egen y=sum(x)	
	gen norskmne20=1 if y>=1
	replace norskmne20=0 if norskmne20==.
	drop x y 

* Make a dummy if indirect ownership is above 50%
	count if eandind>=20 & eandind!=.
	count if eandind>=50 & eandind!=.
	gen x=1 if eandind>=50 & eandind!=.
	replace x=0 if x==.
	bys aar orgnr: egen y=sum(x)
	tab y if n==N
	gen ind50=1 if y>=1
	replace ind50=0 if ind50==.
	drop x y 
* Make a dummy if indirect ownership is above 20%
	gen x=1 if eandind>=20 & eandind!=.
	replace x=0 if x==.
	bys aar orgnr: egen y=sum(x)
	gen ind20=1 if y>=1
	replace ind20=0 if ind20==.
	drop x y 


* Keep one obs of each org nr each year
	keep if n==1
	count
	* most orgnr that have some indirect owned object, also have some
	* directly owned objects the same year
	count if norskmne10==1
	count if norskmne20==1
	count if ind50==1
	count if ind20==1 
	count if norskmne10==ind50 & norskmne10==1
	count if norskmne10==ind20 & norskmne10==1
	count if norskmne20==ind20 & norskmne20==1
	count if norskmne20==ind50 & norskmne20==1

* save data for merging onto industripanel
	keep aar orgnr ind* norskmne*  nace sektor
	sort orgnr aar
	drop if orgnr==.
	save ${pap4data}mnedummy.dta, replace


* 2.
* Extend the orgnr in 1993-1996 to the years 1990-1992
	clear
	set mem 250m
	use ${industri}foumerge.dta, clear
	keep if aar>=1990
	keep aar indorgnr fnr bnr totutenl indirutenl utenl naering nace v13 v104
	rename indorgnr orgnr
	tab aar if orgnr!=.
	tab aar
	sort bnr aar
	replace orgnr=orgnr[_n+2] if aar==1992 & orgnr[_n+2]!=. & bnr==bnr[_n+2] & fnr==fnr[_n+2] & orgnr==.
	replace orgnr=orgnr[_n+1] if aar==1992 & orgnr[_n+1]!=. & bnr==bnr[_n+1] & fnr==fnr[_n+1] & orgnr==.
	replace orgnr=orgnr[_n+2] if aar==1991 & orgnr[_n+2]!=. & bnr==bnr[_n+2] & fnr==fnr[_n+2] & orgnr==.
	replace orgnr=orgnr[_n+1] if aar==1991 & orgnr[_n+1]!=. & bnr==bnr[_n+1] & fnr==fnr[_n+1] & orgnr==.
	replace orgnr=orgnr[_n+2] if aar==1990 & orgnr[_n+2]!=. & bnr==bnr[_n+2] & fnr==fnr[_n+2] & orgnr==.
	replace orgnr=orgnr[_n+1] if aar==1990 & orgnr[_n+1]!=. & bnr==bnr[_n+1] & fnr==fnr[_n+1] & orgnr==.
	tab aar if orgnr!=. & aar<1993
	tab aar if aar<1993

* 3
* Merge dummy onto foumerge.dta
	rename nace naceind
	sort orgnr aar
	save ${industri}indtemp.dta, replace
	merge orgnr aar using ${pap4data}mnedummy

	tab _merge
	tab aar if _merge==3
	drop if _merge==2

	tab norskmne10 if _merge==3
	tab norskmne20 if _merge==3
	tab ind20 if _merge==3
	tab ind50 if _merge==3
	tab norskmne10 norskmne20
	list aar bnr naering totutenl v13 ind* if norskmne10==1 & norskmne20==0
	* correspondence between indicator for norskmne and ind

	* is so good that I stick to the direct ownership definition:
	* in both cases below only 2 plant observ. during the 10 years
	* would be a norw MNE with the indirect def but not according to
	* the direct definition
		tab norskmne10 ind50 if _merge==3
		tab norskmne20 ind20 if _merge==3
		*drop ind20 ind50
* And only 40 plant obs during 1990-2000 is a norw mne according to the 10%
* definition but not according to the 20% definition

* Overview of correspondence norskmne and foreign ownership
	tab utenl if _merge==3 & norskmne10==1
	tab indirutenl if _merge==3 & norskmne10==1
	tab totutenl if _merge==3 & norskmne10==1
	tab utenl if _merge==3 & norskmne20==1
	tab indirutenl if _merge==3 & norskmne20==1
	tab totutenl if _merge==3 & norskmne20==1
	drop if totutenl==.
* Generate dummies for domestic and foreign mnes
* Domestic mne if orgnr owns things abroad and 
* has less than 50%foreign ownership (dir and indir)
	gen dommne=1 if norskmne20==1 & totutenl!=1
* ny rev 2009: indirekte eireskap også
	replace dommne=1 if dommne==. & totutenl!=1 & ind50==1
* Foreign mne if more than 20% foreign ownership and not defined as
* domestic mne
	gen formne=1 if totutenl>0 & dommne!=1
	tab dommne
	tab formne
	replace dommne=0 if dommne==.
	replace formne=0 if formne==.
* Differences domestic and foreign mnes versus mnes and local domestic
	assert dommne!=1 if formne==1
	assert formne!=1 if dommne==1
	
	sum v13 v104 if dommne==1 & aar>=1990
	sum v13 v104 if formne==1 & aar>=1990
	sum v13 v104 if dommne!=1 & formne!=1 & aar>=1990

* save data with dom and foreign mne dummies
	keep aar bnr dommne formne totutenl
	foreach t in dommne formne totutenl {
	assert `t'!=.
	}
	label var dommne "Dummy=1 if plant is part of a Norwegian/domestic MNE"
	label var formne "Dummy=1 if plant is part of a foreign MNE"
	sort bnr aar
	save ${pap4data}mne.dta, replace
	tab aar

	erase ${industri}indtemp.dta
	erase ${pap4data}mnedummy.dta

exit

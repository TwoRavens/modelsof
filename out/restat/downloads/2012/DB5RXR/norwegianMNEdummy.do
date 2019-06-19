
version 10
clear
capture program drop _all
capture log close
log using ${empdecomp}norwegianMNEdummy, text replace
set more off
set memory 200m

* 06.05.2008******************************************
* Based on 2 dofiles from mobility paper, with additional 
* do file from Sissel Jensen which includes new year files
* Turns out nothing new in the files from 2003-2005
* The do file here only saves an MNE dummy that can be
* merged onto the panel used in the emp-decomp paper

* Thus the parts of the original do-files that keeps
* and labels all variables are dropped from this do-file
*************************************************************
	insheet using ${mne}utg1998.csv, delimit(";")
	quietly destring, replace
	quietly gen aar=1998	
	foreach t in  eierandel stemmeandel indirekte_eierandel indirekte_stemmeandel {
		destring `t',  replace ignore(", .")
		replace `t'=`t'/100
		format `t' %9.0g
	}
		quietly save ${mne}utginv1998.dta, replace
		


* Read in csv files, generate year variable and append the data
	forvalues t=1990/1997 {
		clear
		insheet using ${mne}utg`t'.csv, delimit(";")
		quietly destring, replace
		quietly gen aar=`t'
		rename indirekte_stemmeadel indirekte_stemmeandel	
		quietly save ${mne}utginv`t'.dta, replace
	}
	forvalues t=1999/2002 {
		clear
		insheet using ${mne}utg`t'.csv, delimit(";")
		quietly destring, replace
		foreach x in eanddir stemdir eandind stemind {
			destring `x',  replace ignore(", .")
			replace `x'=`x'/100
			format `x' %9.0g
			count if  `x'>100  & `x'!=.
		}
		quietly gen aar=`t'	
		quietly save ${mne}utginv`t'.dta, replace
	}
		clear
		insheet using ${mne}utg2003.csv, delimit(";")
		quietly destring, replace
		foreach x in stemdir  stemind {
			destring `x',  replace ignore(", .")
			replace `x'=`x'/100
			format `x' %9.0g
		}
		foreach x in eanddir stemdir eandind stemind {
			count if  `x'>100  & `x'!=.
		}
		quietly gen aar=2003	
		quietly save ${mne}utginv2003.dta, replace

	forvalues t=2004/2005 {
		clear
		insheet using ${mne}utg`t'.csv, delimit(";")
		quietly destring, replace
		foreach x in eanddir stemdir eandind stemind {
			assert  `x'<=100 | `x'>=0 if `x'!=.
		}
		quietly gen aar=`t'	
		quietly save ${mne}utginv`t'.dta, replace
	}
	use ${mne}utginv1990.dta, clear
	forvalues t=1991/2005{
		append using ${mne}utginv`t'.dta
		erase ${mne}utginv`t'.dta
	}
	erase ${mne}utginv1990.dta
	order aar
	sort aar
	tab aar
* drop empty vars
	des v7* v80 v65-v69 v45-v56
	sum v7* v80 v65-v69 v45-v56
	drop v7* v80 v65-v69 v45-v56
	sum 
	des

* Year variable
	assert v31==regnskapsaar if v31!=. & regnskapsaar!=.
	assert regnskapsaar==aar if regnskapsaar!=.
	label var aar "regnskapsaar"
	assert regn_per==aar if regn_per!=.
	drop regn_per v31 regnskapsaar
* Name and id number of norwegian firm in Norway
	replace orgnr=identitet if orgnr==. & identitet!=.
	count if orgnr==.
	drop if orgnr==.
	replace navn=investor if aar>=1999
	drop identitet investor
	label var orgnr "organisasjonsnr. norsk foretak"
	format orgnr %14.0g
	label var navn "navn paa norsk foretak"
* Name and id number of norw.-owned firm abroad
	drop ojektnr
	replace lopenr=lopnr if aar==1998
	drop lopnr
	assert objektnr==v6 if v6!=.
	assert objektnr==v32 if v32!=.
	drop v6 v32
	replace objektnr=lopenr if aar>=1998
	assert objektnr!=.
	label var objektnr "loepenr for utenlandsk foretak"
	label var v4 "navn paa utenlandsk foretak"
	rename v4 utlnavn
	replace utlnavn=objekt if aar>=1999
	drop objekt lopenr
* Country and country code of the norwegian-owned foreign firm
	label var land "navn paa land som utgaaende FDI er i"
	label var landkode "landkode 3 siffer"
	replace land=landnavn if aar>=1999
	drop iso landnavn
* drop empty variables or mainly empty variables or 
* mainly undefined variables
	drop adr1 utenlandskorgnr adresse bransje
	label var hakt "hovedaktivitet utland"
	replace nace=nace1 if aar<=1998
	drop nace1
	label var nace "Nace for eier i norge"
	label var sektor "sektor for eier i norge"
	order aar orgnr navn nace sektor kommune utlnavn objektnr land landkode

* The remaining variables are in 3 categories: 
* A: about ownership shares, 
* B: about transactions between norway and foreign object
* C: about the foreign object. 
* All these variables change names in 1999, combine the two 
* variables into one.


* Variables concerning direct and inderect ownership- and voting- shares
* name  and data type change in 1999
	sum eierandel eanddir stemmeandel stemdir indirekte_eierandel eandind indirekte_stemmeandel stemind
	* 2 obs have stemind>100 (same firm), I assumme the comma was 
	* placed wrong in the original files and divide by 100
		count if stemind>100 & stemind!=.
		list aar stemind eandind stemdir eanddir if stemind>100 & stemind!=.
		replace stemind=stemind/100 if stemind>100

	replace eanddir=eierandel if aar<1999
	replace stemdir=stemmeandel if aar<1999
	replace eandind=indirekte_eierandel if aar<1999
	replace stemind=indirekte_stemmeandel if aar<1999
	label var eanddir "direkte eierandel i utenlandsk foretak"
	label var stemdir	"direkte stemmeandel"
	label var eandind	"indirekte eierandel i utenlandsk foretak"
	label var stemind	"indirekte stemmeandel"
	sum eand* stem*, det
	drop eierandel stemmeandel indirekte_eierandel indirekte_stemmeandel
	* some missing obs, but only from 1999, replace these with zero
	foreach t in eanddir stemdir eandind stemind {
		replace `t'=0 if `t'==.
		assert `t'>=0 & `t'<=100
	}


	sort orgnr aar
	keep aar orgnr navn utlnavn objektnr land landkode eanddir stemdir eandind stemind nace sektor 
	drop if orgnr==.
* Possible definitions of a multinational
* Associate a dummy with each orgnr each year
* Must have one foreign object with a minimun ownershare; say 10%
* What about indirect ownership?
	sum eanddir stemdir eandind stemind, det
	count if eanddir==stemdir
	count if eandind==stemind
	count if eanddir<20 & eanddir!=0
* Make a dummy=1 if direct ownership is above 20%
* Use the ownership share variable, and not the vote share variable
	gen x=1 if eanddir>=20 & eanddir!=.
	replace x=0 if x==.
	bys aar orgnr: egen y=sum(x)	
	gen norskmne20=1 if y>=1
	bysort aar orgnr: gen N=_N
	bysort aar orgnr: gen n=_n
	tab n if n==N
	tab y if n==N
	replace norskmne20=0 if norskmne20==.
	drop x y 
* Make a dummy=1 if direct ownership is above 50%
* Use the ownership share variable, and not the vote share variable
	gen x=1 if eanddir>=50 & eanddir!=.
	replace x=0 if x==.
	bys aar orgnr: egen y=sum(x)	
	gen norskmne50=1 if y>=1
	tab n if n==N
	tab y if n==N
	replace norskmne50=0 if norskmne50==.
	drop x y 

* Make a dummy if indirect ownership is above 20%
	gen x=1 if eandind>=20 & eandind!=.
	replace x=0 if x==.
	bys aar orgnr: egen y=sum(x)
	gen ind20=1 if y>=1
	replace ind20=0 if ind20==.
	drop x y 
* Make a dummy if indirect ownership is above 50%
	gen x=1 if eandind>=50 & eandind!=.
	replace x=0 if x==.
	bys aar orgnr: egen y=sum(x)
	gen ind50=1 if y>=1
	replace ind50=0 if ind50==.
	drop x y 


* Keep one obs of each org nr each year	
	keep if n==1
	count
	* most orgnr that have some indirect owned object, also have some
	* directly owned objects the same year
	count if norskmne20==1
	count if ind20==1 
	count if norskmne20==ind20 & norskmne20==1

* MNE dummy =1 if direct or indirect ownership is above 20%
	gen MNE20=1 if norskmne20==1
	replace MNE20=1 if ind20==1
	replace MNE20=0 if MNE20==.
* MNE dummy =1 if direct or indirect ownership is above 50%
	gen MNE50=1 if norskmne50==1
	replace MNE50=1 if ind50==1
	replace MNE50=0 if MNE50==.

* save data for merging onto industripanel
	keep aar orgnr nace sektor MNE20 MNE50
	drop if orgnr==.
	label var MNE20 "=1 if norwegian firm owns object abroad >20%, dir and indirect"
	label var MNE50 "=1 if norwegian firm owns object abroad >50%, dir and indirect"
	keep if MNE20==1 
	keep aar orgnr MNE20 MNE50
	tab aar
	sort orgnr aar
	save ${empdecomp}mnedummy.dta, replace


* Merge this onto empdecomppanel

* 06.05.2008******************************************
* Use MNEdummy data made in norwegianMNEdummy, and merge
* onto the  panel for empdecomp analysis: 
* ${industri}empdecomppanel1_update.dta, make dummies for
* foreign and domestic mnes, 

	use ${industri}empdecomppanel1_update.dta, clear 

* Extend the orgnr in 1993-1996 to the years 1990-1992
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

* Merge dummy onto panel, Merge=3 will give all MNE20s as 
* defined from the outgoing FDI data, as MNE20=1 for all obs in
* the mnedummy.dta
	sort orgnr aar
	save ${empdecomp}indtemp.dta, replace
	merge orgnr aar using ${empdecomp}mnedummy
	assert MNE20==1 if _merge==3
	tab _merge
	tab aar if _merge==3
	drop if _merge==2

* Overview of correspondence mnedummy and foreign ownership
	rename larutenl totstor
	tab totutenl if _merge==3 
	tab totstor if _merge==3 
	tab  aar totutenl if _merge==3 
	tab totstor if _merge==3 
	drop _merge

* Generate dummies for domestic and foreign mnes
* Domestic mne if orgnr owns things abroad and 
* has less than 50%foreign ownership (dir and indir)
	gen dommne=1 if MNE20==1 & totutenl!=1
	gen dommne50=1 if MNE50==1 & totutenl!=1
	labe var dommne50 "=1 if plant is part of domestic MNE that owns >50% of entity abroad"
* Foreign mne if more than 20% foreign ownership and not defined as
* domestic mne
	gen formne=1 if totutenl>0 & dommne!=1
	tab dommne
	tab formne
	replace dommne=0 if dommne==.
	replace formne=0 if formne==.
	assert dommne!=1 if formne==1
	assert formne!=1 if dommne==1
	label var dommne "Dummy=1 if plant is part of a Norwegian/domestic MNE"
	label var formne "Dummy=1 if plant is part of a foreign MNE"
	
* Definitions according to totstor
	gen dommne_stor=1 if MNE20==1 & totstor!=1
	gen formne_stor=1 if totstor>0 & dommne_stor!=1
	tab dommne_stor
	tab formne_stor
	replace dommne_stor=0 if dommne_stor==.
	replace formne_stor=0 if formne_stor==.
	assert dommne_stor!=1 if formne_stor==1
	assert formne_stor!=1 if dommne_stor==1
	label var dommne_stor "Dummy=1 Norwegian/domestic MNE, based on storstor def of foreign"
	label var formne_stor "Dummy=1 foreign MNE, based on storstor def of foreign"


* Correspondence between x3 and dommne
	tab dommne formne

* Correspondence between x4 and dommne_stor
	tab dommne_stor formne_stor

	tab dommne dommne_stor
	* these definitions correspond almost entirely
	save ${industri}empdecomppanel1_update.dta, replace

	erase ${empdecomp}mnedummy.dta

	erase ${empdecomp}indtemp.dta



capture log close
exit


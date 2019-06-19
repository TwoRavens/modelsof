clear
set mem 500m
version 10
***19.02.2009***************************************
* Here prepare a regression panel that I save for further use
* Need to merge in experience indicators in regression do-files 
********************************************************

* Use plants from panel of individuals, and merge in
* empdecomppanel1_update.dta, keep only plants with _merge==3

use ${pap4data}wagereg1temp.dta, clear

	replace eduy=9 if eduy==.
	replace eduy=9 if eduy==0
	bys bnr aar: egen ed=mean(eduy)
	gen experience=max(0,age-eduy-7)
	replace experience=15 if experience>15 & experience!=.
	bys bnr aar: egen er=mean(experience)
	assert ed!=.
	assert er!=.
	sum ed
	sum er
	bys bnr aar: egen meanwage=mean(realwage)
	assert meanwage!=.
	keep aar bnr pid ed er dommne formne skillshare femshare plantwagedef plantwagenom meanwage
	sort pid aar 
	merge pid aar using ${pap4data}twowayfixed.dta, keep(person1 person2 person4)
	tab _merge
	rename _merge twowmerge
	replace person1=person1+2
	replace person2=person2+2
	replace person4=person4+2
	bys bnr aar: egen pf1=mean(person1)
	bys bnr aar: egen pf2=mean(person2)
	bys bnr aar: egen pf4=mean(person4)
	label var pf4 "mean person fixed effects in the plant, a2reg no FD and gender dummy"
	label var pf2 "mean person fixed effects in the plant, a2reg no FD dummy"
	label var pf1 "mean person fixed effects in the plant, a2reg with FD dummy"
	drop person*
	bys bnr aar: gen n=_n
	keep if n==1
	drop n pid
	label var er "mean years of experience in plant"
	label var ed "mean years of education in plant"
	rename dommne dommne1
	rename formne formne1
	sort bnr aar
	merge bnr aar using ${industri}empdecomppanel1_update.dta
	drop if aar>2000
	tab aar _merge
	sum v13 v108 if _merge==2
	tab totutenl if _merge==2

	keep if _merge==3
	tab totutenl
	assert dommne==dommne1
	assert formne==formne1
* Drop variables clearly not going to be used
	#delimit ;
	drop formne1 dommne1 _merge  uhhat2 uehat2 uehatD1 
	u3hat vahat storb v14 v32 v34 v42 v40 v39 orgnr 
	entry1 exit1 V46 V47 VAdef 
	totwagecost isic3 Qtot totstor v38 v108 Qi Mi Q3 
	ms3 tfp2 tfp2crs tfp_harrk3_emp x4 x5 x6 ;
	#delimit cr
* generate logs of inputs, output and investment
* h : hours based worker measure, l=employee based worker measure
* both include rented labour
	quietly gen q=ln(Qidef)
	quietly gen k=ln(k3)
	quietly gen m=ln(Midef)
	quietly gen h=ln(Li_h)
	quietly gen l=ln(Li_e)
	drop Qidef Midef Li_e k3
	rename naering isic5
	sort isic5 aar
	merge isic5 aar using ${industri}forpresdata3, keep(FP)
	keep if _merge==3 
	drop _merge 
	rename FP fp	
	sort isic5 aar
	merge isic5 aar using ${industri}entryrates5, keep(cr5 erf erd xrf xrd)
	keep if _merge==3
	drop _merge
* Turbulence: sum of total entry pluss exit rate
 	gen turb=erf+erd+xrf+xrd
	drop erf erd xrf xrd
	gen MNE=1 if dommne==1
	replace MNE=1 if formne==1
	replace MNE=0 if MNE==.
	sort bnr aar
	bys bnr: egen maxutl=max(MNE)
	drop MNE
	gen age=aar-entry
	drop entry exit
* - generate multiplant dummy
	sort aar fnr bnr
      bys aar fnr: egen fN=count(bnr)
      quietly gen multiplant=1 if fN>1
      quietly replace multiplant=0 if multiplant==.
	drop fN fnr
	compress
	sort bnr aar		

	tsset bnr aar
	*gen lturnover=L.turnover
	gen lms5=L.ms5
	gen lturb=L.turb
	rename profitmargin pm
	gen lpm=L.pm
	compress

* tatt ut merge sekvenser for data lagt i tidligere do filer med MNEexperience
* De ligger foreløbig etter exit
	sort bnr aar
	save ${pap4data}regpanel.dta, replace
exit



version 8
clear
set memory 600m
capture log close
capture program drop _all
set more off
set matsize 80
*****************************************************
*  1. Make panel with necessary variables :wagereg1temp.dta
*  For use in wage regressions. 
*  2. Make figures comparing foreign and domestic wages over time
*  3. Make education dummy variable**07.02.2006
***Rev 28.02.06 ****************************************************

* Make a panel with necessary variables and save as temp file

	forvalues t=1990/2000 {
		use ${pap4data}match`t', clear
		quietly keep if pid!=.
		quietly keep if bnr!=.
		sort bnr aar
		merge bnr aar using ${industri}empdecompanel1_update, keep(Ki_1 Qi Qidef)
		keep if _merge==3
		drop _merge
		keep aar bnr pid pearn totutenl hrs v13 naering Ki_1 Qi Qidef sex eduy edut89 edut00 jstart jstop njobs edudt age
		quietly gen isic3=int(naering/100)
		quietly gen isic2=int(naering/1000)
		drop naering
		quietly gen kint=log(Ki_1/Qi)
		quietly gen lp=log(Qidef/v13)
		quietly gen KINT=Ki_1/Qi
		quietly gen LPROD=Qidef/v13
		quietly gen size=log(v13)
		label var kint "log capital intensity: per unit of output"
		label var size "log number of employees from industry data"
		label var lp " log realoutput per employee from industrydata"
		drop Qidef Ki_1 Qi 
		sort aar
		merge aar using ${pap4data}kpi.dta, keep(kpi)
		quietly gen realwage=(pearn/12)*(100/kpi)
		quietly gen wagedef=log(realwage)
		quietly keep if _merge==3
		quietly gen wagenom=log(pearn/12)
		label var realwage "real monthly earnings; from reg.data"
		label var wagedef "log real monthly earnings; from reg.data"
		label var wagenom "log nominal monthly earnings; from reg data"
		quietly gen x=1 if eduy>=12
		quietly bys bnr: gen N=_N
		quietly bys bnr: egen high=sum(x)
		quietly gen skillshare=high/N
		label var skillshare "share of plant workforce with more than 12 years education"
		drop x high
		quietly gen x=1 if sex==2
		quietly bys bnr: egen f=sum(x)
		quietly gen femshare=f/N
		label var femshare "share of plant workforce that is female"
		drop x N f
		quietly keep if hrs==3
		drop hrs
		bys bnr: egen x=mean(realwage)
		quietly gen plantwagedef=log(x)
		bys bnr: egen y=mean(pearn/12)
		quietly gen plantwagenom=log(y)
		drop kpi _merge x y 
		label var plantwagedef "log of average plant wage: deflated"
		label var plantwagenom "log of average plant wage: nominal"
		save ${pap4data}ratio`t'.dta, replace
	}

	use ${pap4data}ratio1990.dta, clear
	forvalues t=1991/2000 {
		append using ${pap4data}ratio`t'.dta
	}
* Definition of foreign plant 20%
	gen FD=1 if totutenl>=1 & totutenl!=.
	tab aar if totutenl==.
	replace FD=0 if FD==.
	label var FD "Dummy=1 if foreign ownership is above 20%"
	sort aar
	tsset pid aar
* Generate variable for date of registration in the year files
	gen regdate=mdy(5,25,1990) if aar==1990
	foreach t in 1991 1992 1993 1994 {
	replace regdate=mdy(5,25,`t') if aar==`t'
	}
	forvalues t=1995/2000 {		
	replace regdate=mdy(11,25,`t') if aar==`t'
	}
* Drop individuals with negative jobstart; ie jobstart before 1959
* around 9000 observations in total dropped
	count if jstart<0
	bys pid: gen n=_n
	bys pid: gen N=_N
	gen w=1 if jstart<0
	bys pid: egen negstart=sum(w)
	tab negstart if n==N
	drop if negstart>0
	drop negstart w
* Indicator for persons always in the same plant z=0
* should have same jstart all years	
	quietly bys pid: egen z=sd(bnr)
	quietly replace z=0 if N==1
	quietly bys pid: egen sdjstart=sd(jstart)
	quietly replace sdjstart=0 if N==1
* Count and indicate persons always in the same plant
* but not with same jstart
	count if n==N & z==0 & sdjstart>0
	gen y=1 if z==0 & sdjstart>0
* Replace jstart for these with jobstart first year
	gen newstart=jstart if y==1 & n==1
	bys pid: egen new=mean(newstart) if y==1
	assert new==jstart if n==1 & y==1
	replace jstart=new if y==1
	drop new newstart y sdjstart
	quietly bys pid: egen sdjstart=sd(jstart)
	quietly replace sdjstart=0 if N==1
	assert sdjstart==0 if  z==0 & jstart!=.
	count if regdate<jstart & z==0 & jstart!=.
	* have looked at these and it seems to be that regdate and jstart differ
	* just by a few months, it is always the first obs of pid that has this problem
	* replace tenure in this case with zero
* Generate variable for tenure in the current job
	gen x=regdate-jstart
	replace x=0 if x<0
	gen tenure=x/30
	gen t2=(tenure)^2
	label var tenure "in months in current job"
	label var t2 " tenure squared"
	drop x regdate jstart sdjstart n N z

* Merge in indicators for foreign and domestic MNEs
	sort bnr aar
	merge bnr aar using ${industri}mne.dta
	drop if aar==2001
	tab _merge
	* merge=1 950k merge=2=4k, part of the problem is 
	* missing orgnr in 1990-1996 that made the link between
	* outward FDI info and industry plants not perfect. Then dropping
	* non fulltime workers may have dropped some plants
	drop if _merge==2
	drop _merge	

* Save wagereg data file
	compress
	save ${pap4data}wagereg1temp.dta, replace

* Erase constructed year files
	forvalues t=1990/2000 {
		erase ${pap4data}ratio`t'.dta
	}


* 2.
* Figures Compare foreign to domestic mean wages
* Generate mean wage for workers in foreign versus domestic plants
	use ${pap4data}wagereg1temp.dta, clear
	* clean out very high and very small wages
	drop if realwage<12000
	drop if realwage>90000
	sort aar
	merge aar using ${pap4data}kpi.dta, keep(kpi)
	keep if _merge==3
	drop _merge
	gen x=pearn*(100/kpi)
	assert bnr!=.
	assert pid!=.
	save ${pap4data}comptemp.dta, replace
	collapse (mean)x, by(aar FD)
	assert x!=.
	bys aar: egen y=mean(x) if FD==0
	bys aar: egen domwage=mean(y)
	bys aar: egen z=mean(x) if FD==1
	bys aar: egen forwage=mean(z)
	assert forwage==x if FD==1
	assert domwage==x if FD==0
	bys aar: gen n=_n
	keep if n==1
	keep aar domwage forwage
	sort aar
	save ${pap4data}compwage.dta, replace
* Generate mean wage for workers in foreign versus domestic MNEs
	use ${pap4data}comptemp.dta, clear
	keep if aar>=1990	
	replace dommne=0 if dommne==.
	replace formne=0 if formne==.
	assert formne==0 if FD==0
	assert formne!=1 if dommne==1
	gen mne=2 if dommne==1
	replace mne=1 if formne==1
	replace mne=0 if FD==0 & dommne!=1
	assert mne!=.
	collapse (mean)x, by(aar mne)
	assert x!=.
	bys aar: egen y=mean(x) if mne==0
	bys aar: egen dom=mean(y)
	bys aar: egen z=mean(x) if mne==1
	bys aar: egen formne=mean(z)
	bys aar: egen w=mean(x) if mne==2
	bys aar: egen dommne=mean(w)
	bys aar: gen n=_n
	keep if n==1
	sort aar
	merge aar using ${pap4data}compwage.dta
	sort aar	


* Figure that plots foreign and domestic wages
* over time: 
	foreach t in dom dommne formne domwage forwage {
		replace `t'=`t'/1000
	}
#delimit ;
	line forwage aar, clp(solid) clc(black) clw(thin)
	|| line domwage aar, clp(dash) clc(black) clw(thin) ||,
	xlabel(1990(5)2000) ylabel(240(40)320) ytitle(" ") xtitle(" ") 
	legend(label(1 "Foreign owned plants") label(2 "Domestic plants") col(1) region(lstyle(none)))
	subtitle("Mean annual wages for full-time workers: 1000 NOK", span)
	graphregion(fcolor(gs16)); 
	graph export ${pap4fig}foreignwagepremium.eps, replace;

	line dom aar, clp(solid) clc(black) clw(thin)
	|| line formne aar, clp(solid) clc(black) clw(thick)
	|| line dommne aar, clp(dash) clc(black) clw(thin) ||,
	xlabel(1990(5)2000) ylabel(240(40)320) ytitle(" ") xtitle(" ") 
	legend(label(1 "Domestic non-MNEs") label(2 "Foreign MNEs") 
		label(3 "Domestic MNEs") col(1) region(lstyle(none)))
	subtitle("Mean annual wages for full-time workers: 1000 NOK", span)
	graphregion(fcolor(gs16)); 
	graph export ${pap4fig}MNEpremium.eps, replace;
#delimit cr
* Difference in wages is between 10-15% each year

		erase ${pap4data}comptemp.dta
		erase ${pap4data}compwage.dta

* 3.
* Make a dummy variable /indicator variable for
* some educational groups; based on edut89 and edut00
	use ${pap4data}wagereg1temp.dta, clear
	
	gen edut892=int(edut89/10000)
	gen edut002=int(edut00/10000)
* Lav utdanning: bare grunnskole og 1. års grunnkurs
* pluss uoppgitt utdanning
	gen education=0 if edut892<40 & aar<2000
	replace education=0 if edut892>=90 & aar<2000
	replace education=0 if edut002<40 & aar==2000
	replace education=0 if edut002>=90 & aar==2000
* Videregående, ikke teknisk utdanning og første nivå på 
* høyskole/universitet uten teknisk innretning
	replace education=1 if edut892>=40 & edut892<=50 & edut892!=45 & aar<2000
	replace education=1 if edut892>=50 & edut892<=60 & edut892!=55 & aar<2000
	replace education=1 if edut002>=40 & edut002<=50 & edut002!=45 & aar==2000
	replace education=1 if edut002>=50 & edut002<=60 & edut002!=55 & aar==2000
* videregående teknisk utdanning
	replace education=2 if edut892==45 | edut892==55 & aar<2000
	replace education=2 if edut002==45 | edut002==55 & aar==2000
* Teknisk og økonomisk administrativ utdanning på universitetsnivå
	replace education=3 if edut892==64 | edut892==65 | edut892==74 | edut892==75 | edut892==84 | edut892==85 & aar<2000
	replace education=3 if edut002==64 | edut002==65 | edut002==74 | edut002==75 | edut002==84 | edut002==85 & aar==2000
* Annen utdanning på universitetsnivå
	replace education=4 if edut892>=60 & edut892<90 & education==. & aar<2000
	replace education=4 if edut002>=60 & edut002<90 & education==. & aar==2000
	label var education "0=grunnsk+1aar VK, 1=VK+1aar ikke teknisk, 2=teknisk VK+1 aar, 3=tekn+oek/adm U, 4=annet U"
	drop edut892 edut002
	sort pid aar
	save ${pap4data}wagereg1temp.dta, replace

capture log close 
exit




****************************************************************************
**		File name:	country level measures and histograms
**		Authors: 	Liran Harsgor, Orit Kedar, Raz Sheinerman
**		Date: 		Final version: June 8 2015
**		Purpose: 	1. Generate country-level measures for subsequent analyses					 							
**					2. Generate DM histograms
**					3. Save country-level dataset
**		input:		PDL_21C_ready.dta
**		Ouput: 		cmeasures.dta	                                                                 
*****************************************************************************

use "PDL_21C_ready.dta", clear
capture log using "cntry.log", replace

****************************************************************************************************
*** 1. Calculate RI index for each country.  This is identical to the calculation conducted in 
**  within country descriptive.do.  See explanations in that code.  
****************************************************************************************************

gen dpvs=votes/tvc
gen dpss=seats/tsc
label var dpvs "district-party vote share"
label var dpss "district-party seat share"

* When dpss=0, CR equals zero, so to differentiate among different cases
* turn dpss to 0.0000001. Needed for future analyses only. 
replace dpss=0.0000001 if dpss==0

* calculate conversion ratio (CR=seat-share/vote-share)
gen cr = dpss/dpvs
label var cr "Conversion Ratio"

*** Preparation for plotting the curve
* for each country sort cr in ascending order 
sort country_c cr
* Calculate cumulative district-party vote-share (dpvs) within each country 
by country_c (cr), sort: gen cdpvs=sum(dpvs)
* Calculate cumulative district-party seat-share (dpss) within each country
by country_c (cr), sort: gen cdpss=sum(dpss)

label var cdpvs "cumulative district-party vote share"
label var cdpss "cumulative district-party seat share"
 
* (1) Calculate the area under the "belly"
* Calculate the area of the trapezoid between each two data points (see fig. above)
sort country_c cr
	by country_c: gen area = (cdpss[_n]+cdpss[_n-1])/2*(cdpvs[_n]-cdpvs[_n-1])  
	replace area = cdpss*cdpvs/2 if area == . /* for first trianlge*/

* Calculate the sum of all trapezoids
egen lorenzshadow= total (area), by (country_c)

* (2) Calculate RI = (2*"belly area")
gen gini= 2*(0.5 - lorenzshadow)

label var gini "RI index"

*****************************
***** 2. Calculate malapportionment
*****************************

*** Eligible voters
* calculate eligible voters district (rvd) out of eligible voters in country (rvc)
sort country_c district_unique
by country_c: egen rvc= total(rvd) if district_unique==1
label var rvc "registered voters at the country level"
gen rvs = rvd/rvc
label var rvs "district registered voters share of total registered voters in country"

*** Seats
* calculate sare of seats in district (dm) out of total seats in parliament (tsc)
gen dms = dm/tsc
label var dms "district magnitude share of total seats in parliament"

*  malapportionment: 0.5*sum |dms-rvs| (Samuels & Snyder 2001)
gen tmal = abs(dms-rvs)
by country_c, sort: egen tmal2 = total(tmal) if district_u==1 
gen malap = 0.5*tmal2

drop tmal tmal2
label var malap "country malapportionment"


******************************
*** 3. indicators of DM distribution in country 
******************************

keep if district_unique==1

by country_c: egen avgdm = mean(dm)
by country_c: egen meddm = median(dm)
by country_c: egen mindm = min(dm) 
by country_c: egen maxdm = max(dm) 

gen lndm=ln(dm)
by country_c: sum lndm, detail 
by country_c: egen avglndm = mean(lndm)
by country_c: egen medlndm = median(lndm) 
by country_c: egen minlndm = min(lndm) 
by country_c: egen maxlndm = max(lndm) 

gen lnavgdm = ln(avgdm)
gen lnmeddm = ln(meddm)


*** Calculate the magnitude of the district electing the median legislator (medleg) ***
sort country_c dm, stable
by country_c: gen maxhalf=(tsc+1)/2 /* identify the median legislator in parliament */
by country_c: gen cdm=sum(dm) 		/* calculate cumulative DM by country */

* we are interested in the district for which pre_medleg equals zero 
* or has the smallest positive value
* pre_medleg is negative when cdm is smaller than the medain legislator
* pre_medleg equals zero or is positive when cdm is bigger than the medain legislator
gen pre_medleg = cdm-maxhalf 		

* artificially enlarge negative values of pre_medleg, so that we are able to 
* identify the minimum value among the non-negative ones.  
replace pre_medleg = pre_medleg +1000 if pre_medleg<0

* identify the minimum of pre_medleg
by country_c: egen mpmedleg = min(pre_medleg)

* insert dm into medleg placeholder for the relevant observation 
by country_c: gen medleg = dm if pre_medleg== mpmedleg 

* replicate the value of medleg for all districts 
replace medleg=0 if medleg==.
by country_c: egen  tmp=max(medleg)
by country_c: replace medleg= tmp
drop maxhalf pre_medleg cdm tmp

**  lnmedleg ***
by country_c: gen lnmedleg=ln(medleg)

***percentage legislators elected in dm<X **
sort country_c dm 
*percentage legislators elected in dm<7 (pdmst7)**
by country_c: egen tdm7=total(dm) if dm<7
gen pdmst7=tdm7/tsc
replace pdmst7=0 if pdmst7==.

*percentage legislators elected in dm<5 (pdmst5)**
by country_c: egen tdm5=total(dm) if dm<5 
gen pdmst5=tdm5/tsc
replace pdmst5=0 if pdmst5==.

*percentage legislators elected in dm<3 (pdmst3)**
by country_c: egen tdm3=total(dm) if dm<3 
gen pdmst3=tdm3/tsc
replace pdmst3=0 if pdmst3==.

*** For Robustness analysis, calculate additional thresholds ***
**percentage legislators elected in dm<2(pdmst2)**
by country_c: egen tdm2=total(dm) if dm<2 
gen pdmst2=tdm2/tsc
replace pdmst2=0 if pdmst2==.

**percentage legislators elected in dm<4(pdmst4)**
by country_c: egen tdm4=total(dm) if dm<4 
gen pdmst4=tdm4/tsc
replace pdmst4=0 if pdmst4==.

**percentage legislators elected in dm<6(pdmst6)**
by country_c: egen tdm6=total(dm) if dm<6 
gen pdmst6=tdm6/tsc
replace pdmst6=0 if pdmst6==.

**percentage legislators elected in dm<8(pdmst8)**
by country_c: egen tdm8=total(dm) if dm<8 
gen pdmst8=tdm8/tsc
replace pdmst8=0 if pdmst8==.

**percentage legislators elected in dm<9(pdmst9)**
by country_c: egen tdm9=total(dm) if dm<9 
gen pdmst9=tdm9/tsc
replace pdmst9=0 if pdmst9==.

**percentage legislators elected in dm<10(pdmst10)**
by country_c: egen tdm10=total(dm) if dm<10 
gen pdmst10=tdm10/tsc
replace pdmst10=0 if pdmst10==.

**percentage legislators elected in dm<11 (pdmst11)**
by country_c: egen tdm11=total(dm) if dm<11 
gen pdmst11=tdm11/tsc
replace pdmst11=0 if pdmst11==.

**percentage legislators elected in dm<12(pdmst12)**
by country_c: egen tdm12=total(dm) if dm<12 
gen pdmst12=tdm12/tsc
replace pdmst12=0 if pdmst12==.


******************************
*** 4. Fig. 4 DM histograms (and vertical line at 5) conutry-by-country *********
******************************
* apply pdmst5 for all districts in conutry
by country_c, sort: sum pdmst5, detail
by country_c: egen  tpdmst5=max(pdmst5)
by country_c: replace pdmst5= tpdmst5
drop tpdmst5

gen pdmst5_100 = pdmst5 * 100
replace pdmst5_100 = int(pdmst5_100)+1 if abs(pdmst5_100-int(pdmst5_100)) > abs(pdmst5_100-(int(pdmst5_100)+1))
replace pdmst5_100 = int(pdmst5_100)


** Ireland **
levelsof pdmst5_100 if country_c==108, local(pdmst_5) clean
	twoway hist dm if country_c==108, discrete frequency fintensity(inten0) title("Ireland") xlabel(0(10)50) ///
	lcolor(gs10) lwidth(vvthin) legend(off) note((`pdmst_5'%), size(4) position(1)) ///
	|| scatteri 0 5 22 5, recast(line) lcolor(black) lwidth(medthick) graphregion(fcolor(white)) yla(,nogrid) ///
	xtitle("District magnitude", size(3)) ytitle("Frequency", size(3))
	graph save "hist_108", replace
	
** Greece **
levelsof pdmst5_100 if country_c==106, local(pdmst_5) clean
	twoway hist dm if country_c==106, discrete frequency fintensity(inten0) title("Greece") xlabel(0(10)50) ///
	lcolor(gs10) lwidth(vvthin) legend(off) note((`pdmst_5'%), size(4) position(1)) ///
	|| scatteri 0 5 15 5, recast(line) lcolor(black) lwidth(medthick) graphregion(fcolor(white)) yla(,nogrid) ///
	xtitle("District magnitude", size(3)) ytitle("Frequency", size(3))
	graph save "hist_106", replace

** Spain **
levelsof pdmst5_100 if country_c==113, local(pdmst_5) clean
	twoway hist dm if country_c==113, discrete frequency fintensity(inten0) title("Spain") xlabel(0(10)50) ///
	lcolor(gs10) lwidth(vvthin) legend(off) note((`pdmst_5'%), size(4) position(1)) ///
	|| scatteri 0 5 11 5, recast(line) lcolor(black) lwidth(medthick) graphregion(fcolor(white)) yla(,nogrid) ///
	xtitle("District magnitude", size(3)) ytitle("Frequency", size(3))
	graph save "hist_113", replace
	
** Switzerland **
levelsof pdmst5_100 if country_c==115, local(pdmst_5) clean
	twoway hist dm if country_c==115, discrete frequency fintensity(inten0) title("Switzerland") xlabel(0(10)50) ///
	lcolor(gs10) lwidth(vvthin) legend(off) note((`pdmst_5'%), size(4) position(1)) ///
	|| scatteri 0 5 5.3 5, recast(line) lcolor(black) lwidth(medthick) graphregion(fcolor(white)) yla(,nogrid) ///
	xtitle("District magnitude", size(3)) ytitle("Frequency", size(3))
	graph save "hist_115", replace
	
** Norway **
levelsof pdmst5_100 if country_c==111, local(pdmst_5) clean
	twoway hist dm if country_c==111, discrete frequency fintensity(inten0) title("Norway") xlabel(0(10)50) ///
	lcolor(gs10) lwidth(vvthin) legend(off) note((`pdmst_5'%), size(4) position(1)) ///
	|| scatteri 0 5 3.2 5, recast(line) lcolor(black) lwidth(medthick) graphregion(fcolor(white)) yla(,nogrid) ///
	xtitle("District magnitude", size(3)) ytitle("Frequency", size(3))
	graph save "hist_111", replace
	
** Portugal **
levelsof pdmst5_100 if country_c==112, local(pdmst_5) clean
	twoway hist dm if country_c==112, discrete frequency fintensity(inten0) title("Portugal") xlabel(0(10)50) ///
	lcolor(gs10) lwidth(vvthin) legend(off) note((`pdmst_5'%), size(4) position(1)) ///
	|| scatteri 0 5 3.2 5, recast(line) lcolor(black) lwidth(medthick) graphregion(fcolor(white)) yla(,nogrid) ///
	xtitle("District magnitude", size(3)) ytitle("Frequency", size(3))
	graph save "hist_112", replace

** Iceland **
levelsof pdmst5_100 if country_c==107, local(pdmst_5) clean
	twoway hist dm if country_c==107, discrete frequency fintensity(inten0) title("Iceland") xlabel(0(10)50) ///
	lcolor(gs10) lwidth(vvthin) legend(off) note((`pdmst_5'%), size(4) position(1)) ///
	|| scatteri 0 5 4.2 5, recast(line) lcolor(black) lwidth(medthick) graphregion(fcolor(white)) yla(,nogrid) ///
	xtitle("District magnitude", size(3)) ytitle("Frequency", size(3))
	graph save "hist_107", replace
	
** Denmark **
levelsof pdmst5_100 if country_c==103, local(pdmst_5) clean
	twoway hist dm if country_c==103, discrete frequency fintensity(inten0) title("Denmark") xlabel(0(10)50) ///
	lcolor(gs10) lwidth(vvthin) legend(off) note((`pdmst_5'%), size(4) position(1)) ///
	|| scatteri 0 5 2.2 5, recast(line) lcolor(black) lwidth(medthick) graphregion(fcolor(white)) yla(,nogrid) ///
	ylabel(0 1 2) xtitle("District magnitude", size(3)) ytitle("Frequency", size(3))
	graph save "hist_103", replace
	
** Sweden **
levelsof pdmst5_100 if country_c==114, local(pdmst_5) clean
	twoway hist dm if country_c==114, discrete frequency fintensity(inten0) title("Sweden") xlabel(0(10)50) ///
	lcolor(gs10) lwidth(vvthin) legend(off) note((`pdmst_5'%), size(4) position(1)) ///
	|| scatteri 0 5 6.2 5, recast(line) lcolor(black) lwidth(medthick) graphregion(fcolor(white)) yla(,nogrid) ///
	xtitle("District magnitude", size(3)) ytitle("Frequency", size(3))
	graph save "hist_114", replace

** Finland **
levelsof pdmst5_100 if country_c==104, local(pdmst_5) clean
	twoway hist dm if country_c==104, discrete frequency fintensity(inten0) title("Finland") xlabel(0(10)50) ///
	lcolor(gs10) lwidth(vvthin) legend(off) note((`pdmst_5'%), size(4) position(1)) ///
	|| scatteri 0 5 2.2 5, recast(line) lcolor(black) lwidth(medthick) graphregion(fcolor(white)) yla(,nogrid) ///
	ylabel(0 1 2) xtitle("District magnitude", size(3)) ytitle("Frequency", size(3))
	graph save "hist_104", replace
	
** Belgium **
levelsof pdmst5_100 if country_c==102, local(pdmst_5) clean
	twoway hist dm if country_c==102, discrete frequency fintensity(inten0) title("Belgium") xlabel(0(10)50) ///
	lcolor(gs10) lwidth(vvthin) legend(off) note((`pdmst_5'%), size(4) position(1)) ///
	|| scatteri 0 5 1.05 5, recast(line) lcolor(black) lwidth(medthick) graphregion(fcolor(white)) yla(,nogrid) ///
	ylabel(0 1) xtitle("District magnitude", size(3)) ytitle("Frequency", size(3))
	graph save "hist_102", replace
	
** Luxemburg **
levelsof pdmst5_100 if country_c==110, local(pdmst_5) clean
	twoway hist dm if country_c==110, discrete frequency fintensity(inten0) title("Luxemburg") xlabel(0(10)50) ///
	lcolor(gs10) lwidth(vvthin) legend(off) note((`pdmst_5'%), size(4) position(1)) ///
	|| scatteri 0 5 1.05 5, recast(line) lcolor(black) lwidth(medthick) graphregion(fcolor(white)) yla(,nogrid) ///
	ylabel(0 1) xtitle("District magnitude", size(3)) ytitle("Frequency", size(3))
	graph save "hist_110", replace

** Italy **
levelsof pdmst5_100 if country_c==109, local(pdmst_5) clean
	twoway hist dm if country_c==109, discrete frequency fintensity(inten0) title("Italy") xlabel(0(10)50) ///
	lcolor(gs10) lwidth(vvthin) legend(off) note((`pdmst_5'%), size(4) position(1)) ///
	|| scatteri 0 5 2.2 5, recast(line) lcolor(black) lwidth(medthick) graphregion(fcolor(white)) yla(,nogrid) ///
	ylabel(0 1 2) xtitle("District magnitude", size(3)) ytitle("Frequency", size(3))
	graph save "hist_109", replace

***
graph combine "hist_108" "hist_106" "hist_113" "hist_115" ///
"hist_111" "hist_112" "hist_107" "hist_103" ///
"hist_114" "hist_104" "hist_102" "hist_110" "hist_109", ///
col(3) xsize(3.5) ysize(5) scheme(s2mono) graphregion(fcolor(white)) 
graph save "Figure4.gph", replace


*********
** 5. Gererate electoral-formula variable and save country-level dataset
**********

keep if country_unique==1
drop party_c party district dm votes seats district_c tvd dvs dpvs dpss cr cdpvs cdpss  ///
	 party_unique district_unique country_unique dms pdmst5_100 
		
** adding electoral formula per country manually:
/*
formulas: largest remider: Hare (01), hagenbach-bischoff/Droop (02)
		  largest Average: d'Hondt (03), sainte-lague (04), modified sainte-lague (05) 
		  others:			stv (06) , smd/plurality (07)
countries 	formula					code
Belgium		LR-Hare  				01
Canada		smd						07
Denmark 	modified sainte-lague 	05	
Finland		d'Hondt					03
Germany		sainte-lague			04
Greece		hagenbach-bischoff		02
Iceland		LR-Hare					01
Ireland		stv						06
Israel		d'Hondt					03
Italy		LR-Hare					01
Luxembourg	hagenbach-bischoff		02
Malta		stv						06
Netherlands	d'Hondt					03
NZ 93		smd						07
NZ 96		sainte-lague			04
NZ 08		sainte-lague			04
Norway		modified sainte-lague	05
Portugal	d'Hondt					03
Spain		d'Hondt					03
Sweden		modified sainte-lague	05
UK			smd						07
*/	

* Electoral formula
gen ef = 0
replace ef = 01 if country_c== 102 | country_c== 107 | country_c== 109
replace ef = 02 if country_c== 106 | country_c== 110 | country_c== 115
replace ef = 03 if country_c== 104 | country_c== 119 | country_c== 121 | country_c== 112 | country_c== 113
replace ef = 04 if country_c== 105 | country_c== 142 | country_c== 122 
replace ef = 05 if country_c== 103 | country_c== 111 | country_c== 114
replace ef = 06 if country_c== 108 | country_c== 120 
replace ef = 07 if country_c== 123 | country_c== 132 | country_c== 117

label var ef "electoral formula"
label define eflabels 01 "Hare" 02 "HB-Droop" ///
				03 "dHondt" 04 "SL" 05 "MSL" ///
				06 "STV" 07 "SMD"
label val ef eflabels 
				
save "cmeasures.dta", replace

log close

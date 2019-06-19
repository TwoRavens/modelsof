cd /Users/jeff/Documents/Academic/Research/Innovation.2008/

/* ~/Documents/Academic/Research/Innovation.2008/do/newwork-clean.do *//* This file uses IPUMS extracts from 1980-2000 to create cleaned files	for analysis, for "Innovation, Cities and New Work" *//* Jeffrey Lin *//* Created March 31, 2009 *//* Inputs:	1. a. 2000 1% unweighted IPUMS (identifies both occ and puma)	   b. 1990 1% unweighted IPUMS	2. a. 1990/2000 occupation code changes (COC Indexes, 5-digit level)	   b. 1980/1990 occupation code changes (DOT 77/91, 5-digit level)	   c. 1970/1980 occupation code changes (DOT 65/77, 5-digit level)	   d. 1970/1980 occupation code changes (Census TP, 3-digit level)	   e. 1960/1970 occupation code changes (Census TP, 3-digit level)	3. City and county data books (for aggregate county-level data)	4. IPUMS samples (for aggregate PUMA-level data)	5. Census summary files 4 (for aggregate county-level data)*//* Output:	   Regression-ready files containing worker level data matched		to new occupation codes and consistent PUMA-level aggregate data*//* PREAMBLE *//* Some programs useful for data processing */* Sample selection and geoidcapture program drop sselectprogram define sselectgen byte occid=occ>=`1' & occ<=`2'keep if occid==1keep if age>15 & age<71keep if gq==1|gq==2drop gqcapture drop hhwtdrop if statefip==2 /* Alaska */sort conspumamerge conspuma using tmp/xw-conspuma-cbsa-wk2.dta, nokreplace geoid = conspuma if geoid==.tab _mdrop _mend* Basic variablescapture program drop recbasicprogram define recbasictab region, gen(reg_)gen byte hhead = relate==1gen byte male = sex==1gen byte marr = marst==1|marst==2gen byte blck = race==2gen byte asia = race==4|race==5|race==6gen byte othr = race==3|race==7|race==8|race==9gen byte fb = bpl>120 if bpl < 999gen byte hisp = hispan!=0gen byte eduatt=. if educrec==0replace eduatt=0 if educrec==1replace eduatt=(1+4)/2 if educrec==2replace eduatt=(5+8)/2 if educrec==3replace eduatt=9 if educrec==4replace eduatt=10 if educrec==5replace eduatt=11 if educrec==6replace eduatt=12 if educrec==7replace eduatt=14 if educrec==8replace eduatt=16 if educrec==9gen byte hs = educrec==7 if educrec!=0gen byte sc = educrec==8 if educrec!=0gen byte col = educrec==9 if educrec!=0
gen byte educat = 2 if hs==1
replace educat = 3 if sc==1
replace educat = 4 if col==1
replace educat = 1 if educat==. & educrec!=0gen byte agr1 = (age>15 & age<22)gen byte agr2 = (age>21 & age<26)gen byte agr3 = (age>25 & age<30)gen byte agr4 = (age>29 & age<34)gen byte agr5 = (age>33 & age<38)gen byte agr6 = (age>37 & age<42)gen byte agr7 = (age>41 & age<45)gen byte agr8 = (age>44 & age<49)gen byte agr9 = (age>48 & age<52)gen byte agr10 = (age>51 & age<56)gen byte agr11 = (age>55 & age<60)gen byte agr12 = (age>59 & age<71)gen potx = age - eduatt - 6replace potx = 0 if potx<0gen potx2 = potx*potx/1000gen byte lf = empstat!=3 if empstat!=0
gen ind_mfg=ind1990>=100 & ind1990<=392
gen ind_tcu=ind1990>=400 & ind1990<=472
gen ind_trd=ind1990>=500 & ind1990<=691
gen ind_svc=ind1990>=700 & ind1990<=893
gen ind_pub=ind1990>=900 & ind1990<=932
gen occ_mpr=occ1990>=003 & occ1990<=200
gen occ_tsa=occ1990>=203 & occ1990<=389
gen occ_svc=occ1990>=405 & occ1990<=469
gen occ_pcr=occ1990>=503 & occ1990<=699
gen occ_ofl=occ1990>=703 & occ1990<=889

gen byte self = .replace self = 1 if classwk>=10 & classwk<=14replace self = 0 if classwk>=20 & classwk<=28gen occflag=qocc!=0gen weeks = wkswork1gen uhours = uhrsworkgen tothrs = weeks*uhoursgen wage = incwage/(weeks*uhours)qui sum wage, dreplace wage = . if wage<.01 | wage>r(p99)gen lnw = ln(wage)ren tothrs hoursgen tr=.replace tr=0 if ind1990>=10 & ind1990<=932/* Wholesale trade, transport, *//* finance/insurance, prof svcs, mgmt, higher ed, a&e */replace tr=0.5 if (ind1990>=400 & ind1990<=432) | ///
	(ind1990>=500 & ind1990<=571) | (ind1990>=700 & ind1990<=711) | ///
	ind1990==800 | (ind1990>=812 & ind1990<=893)/* Mfg or Communication */replace tr=1 if (ind1990>=100 & ind1990<=392) | (ind1990>=440 & ind1990<=442)capture drop hrswork1 hrswork2 wkswork1 wkswork2 uhrswork weeks uhours incwage ///
	inctot relate sex marst race hispan citizen yrimmig yrsusa2 educrec ///
	empstat labforce classwk qocc
capture drop educ99
capture drop higradedcompress
end* Program to create migration dummy* based on change in PUMA for IPUMS 1990 and 2000* (variable in IPUMS is "migpuma")capture program drop migrate/* Source: http://usa.ipums.org/usa/volii/00migpuma.shtml */program define migrate	gen statepuma = statefip*100000+(int(puma/100))*100	gen migstatepuma = migplac5*100000+migpuma*100	gen byte mig = statepuma!=migstatepuma	replace mig = 0 if migpuma==0	replace mig = 0 if statepuma==0100300 & migstatepuma==0100200	replace mig = 0 if statepuma==0102300 & migstatepuma==0102200	replace mig = 0 if statepuma==0501000 & migstatepuma==0500900	replace mig = 0 if statepuma==0601500 & migstatepuma>=0601400	replace mig = 0 if statepuma==0602000 & migstatepuma==0601900	replace mig = 0 if statepuma==0602600 & migstatepuma==0602500	replace mig = 0 if statepuma==0603000 & migstatepuma==0602900	replace mig = 0 if statepuma==0603400 & migstatepuma==0603300	replace mig = 0 if statepuma==0603900 & migstatepuma==0603800	replace mig = 0 if (statepuma>=0604000 & statepuma<=0604400) & migstatepuma==0604000	replace mig = 0 if (statepuma>=0604500 & statepuma<=0606100) & migstatepuma==0604500	replace mig = 0 if (statepuma>=0606200 & statepuma<=0606600) & migstatepuma==0606200	replace mig = 0 if (statepuma>=0606800 & statepuma<=0607600) & migstatepuma==0606800	replace mig = 0 if (statepuma>=0607700 & statepuma<=0608000) & migstatepuma==0607700	replace mig = 0 if statepuma==0800200 & migstatepuma==0800100	replace mig = 0 if statepuma==1203900 & migstatepuma==1203800	replace mig = 0 if statepuma==1303500 & migstatepuma==1303400	replace mig = 0 if statepuma==1600700 & migstatepuma==1600600	replace mig = 0 if statepuma==1701400 & migstatepuma==1701300	replace mig = 0 if statepuma==1701800 & migstatepuma==1701700	replace mig = 0 if statepuma==1702900 & migstatepuma==1702800	replace mig = 0 if statepuma==1703500 & migstatepuma==1703400	replace mig = 0 if statepuma==1800200 & migstatepuma==1800100	replace mig = 0 if statepuma==1800600 & migstatepuma==1800500	replace mig = 0 if statepuma==1803800 & migstatepuma==1803700	replace mig = 0 if statepuma==1901500 & migstatepuma==1901400	replace mig = 0 if statepuma==2001400 & migstatepuma==2001300	replace mig = 0 if statepuma==2201100 & migstatepuma==2201000	replace mig = 0 if statepuma==2201500 & migstatepuma==2201400	replace mig = 0 if statepuma==2601400 & migstatepuma==2601300	replace mig = 0 if (statepuma>=2601800 & statepuma<=2602000) & migstatepuma==2601800	replace mig = 0 if statepuma==2602300 & migstatepuma==2602200	replace mig = 0 if statepuma==2603300 & migstatepuma==2603200	replace mig = 0 if (statepuma>=2603600 & statepuma<=2603800) & migstatepuma==2603600	replace mig = 0 if (statepuma>=2603900 & statepuma<=2604100) & migstatepuma==2603900	replace mig = 0 if statepuma==2701400 & migstatepuma==2701300	replace mig = 0 if statepuma==2701600 & migstatepuma==2701500	replace mig = 0 if statepuma==2801500 & migstatepuma==2801400	replace mig = 0 if (statepuma>=2900800 & statepuma<=2901100) & migstatepuma==2900800	replace mig = 0 if statepuma==2902500 & migstatepuma==2902400	replace mig = 0 if statepuma==3200200 & migstatepuma==3200100	replace mig = 0 if statepuma==3400500 & migstatepuma==3400400	replace mig = 0 if statepuma==3400700 & migstatepuma==3400600	replace mig = 0 if statepuma==3401400 & migstatepuma==3401300	replace mig = 0 if statepuma==3401900 & migstatepuma==3401800	replace mig = 0 if statepuma==3600800 & migstatepuma==3600700	replace mig = 0 if statepuma==3601600 & migstatepuma==3601400	replace mig = 0 if statepuma==3603500 & migstatepuma==3603400	replace mig = 0 if statepuma==3701000 & migstatepuma==3700900	replace mig = 0 if statepuma==3701700 & migstatepuma==3701600	replace mig = 0 if statepuma==3701900 & migstatepuma==3701800	replace mig = 0 if (statepuma>=3702600 & statepuma<=3702800) & migstatepuma==3702600	replace mig = 0 if statepuma==3703700 & migstatepuma==3703600	replace mig = 0 if statepuma==3900300 & migstatepuma==3900200	replace mig = 0 if statepuma==3901200 & migstatepuma==3901100	replace mig = 0 if statepuma==3904100 & migstatepuma==3904000	replace mig = 0 if statepuma==3904500 & migstatepuma==3904400	replace mig = 0 if (statepuma>=4001000 & statepuma<=4001200) & migstatepuma==4000600	replace mig = 0 if (statepuma>=4001300 & statepuma<=4001700) & migstatepuma==4001300	replace mig = 0 if statepuma==4200200 & migstatepuma==4200100	replace mig = 0 if statepuma==4201800 & migstatepuma==4201700	replace mig = 0 if statepuma==4203700 & migstatepuma==4203600	replace mig = 0 if (statepuma>=4501000 & statepuma<=4501200) & migstatepuma==4501000	replace mig = 0 if statepuma==4600700 & migstatepuma==4600600	replace mig = 0 if statepuma==4701400 & migstatepuma==4701300	replace mig = 0 if (statepuma>=4701800 & statepuma<=4702000) & migstatepuma==4701800	replace mig = 0 if statepuma==4703200 & migstatepuma==4703100	replace mig = 0 if statepuma==4804400 & migstatepuma==4804300	replace mig = 0 if statepuma==4805400 & migstatepuma==4805300	replace mig = 0 if (statepuma>=4806300 & statepuma<=4806500) & migstatepuma==4806300	replace mig = 0 if statepuma==4806700 & migstatepuma==4806600	replace mig = 0 if statepuma==4806900 & migstatepuma==4806800	replace mig = 0 if statepuma==5300600 & migstatepuma==5300500	replace mig = 0 if statepuma==5301400 & migstatepuma==5301300	replace mig = 0 if (statepuma>=5301800 & statepuma<=5302000) & migstatepuma==5301800	replace mig = 0 if statepuma==5302200 & migstatepuma==5302100	replace mig = 0 if statepuma==5500300 & migstatepuma==5500200	replace mig = 0 if statepuma==5501200 & migstatepuma==5501100	replace mig = 0 if (statepuma>=5502000 & statepuma<=5502300) & migstatepuma==5502000	drop migrat5d migplac5 migpuma movedin migstatepuma migmet5end

* Program to create migration dummy* based on change in CNTYGP98 for IPUMS 1980capture program drop migrate98program define migrate98
	gen statecntygp = statefip*100+cntygp98
	gen migstatecntygp = migplac5*100+migcogrp if migplac5>=1 & migplac5<=56
	gen byte mig=statecntygp!=migstatecntygp if migstatecntygp!=.
	replace mig=0 if migcogrp==999
	drop migrat5d migplac5 migmet5 migcogrp migstatecntygp
end

* FINAL MERGE
capture program drop finalmerge
program define finalmerge
use dta/ipums/`1'/`1'-wk1.dta, clearsort occmerge occ using tmp/new`1'-wk.dta, noktab _mergedrop _merge/*
sort geoidmerge geoid using tmp/geo`2'-final.dtatab _mergedrop _merge
*/
/*
sort geoid educat
merge geoid educat using tmp/geo-ed`1'.dta, nok
tab _merge
drop _merge
*/compress
* This is work file ready for regressionssave dta/ipums/`1'/`1'-wk2, replace
end


/* NEW OCCUPATION CODES PROCESSING */* Clean new work 2000 file
* This change to new work file accommodates 5% IPUMS occ codesuse dta/new00-wk.dta, clearren occ00 occsort occmerge occ using dta/ipums/2000/xwalk-occ1p5ptab _mdrop _mreplace occ5=occ if occ5==.collapse (rawsum) rec (mean) new_* [w=rec], by(occ5)ren occ5 occ
xtile recq = rec, n(5)
xtile nwq = new_lin, n(5)sort occsave tmp/new2000-wk.dta, replace

* Clean new work 1991 file
insheet using "/Users/jeff/Documents/Academic/Research/Data/Census Occupation Codes/IPUMS Crosswalks/occ1990_xwalk.txt", clear
keep v7 v6
ren v7 occ1990
ren v6 occ1980
destring occ1990, replace force
destring occ1980, replace force
drop if occ1990==. | occ1980==.
sort occ1980
save tmp/xw-occ90-occ80.dta, replace

use dta/new91-wk.dta, clear
ren occ occ1980
sort occ1980
merge occ1980 using tmp/xw-occ90-occ80.dta, nok
tab _m
drop _m
replace occ1990=865 if occ1980==864
ren occ1990 occ
collapse (sum) dot91_titles new_dlu78 new_convt new_convt91 (mean) newtsh* [w=dot91_titles], by(occ)
xtile recq = dot91_titles, n(5)
xtile nwq = new_convt, n(5)
sort occ
save tmp/new1990-wk.dta, replace

* Clean new work 1977 file
use dta/new77-wk.dta, clear
collapse (sum) dot77_titles new newmaster (mean) new*tsh [w=dot77_titles], by(occ)
xtile recq = dot77_titles, n(5)
xtile nwq = newmaster_tsh, n(5)
sort occ
save tmp/new1980-wk.dta, replace


/* GEO PROCESSING */
*do do/newwork-geoid.do

/* IPUMS EXTRACTS PROCESSING */
cd /Users/jeff/Documents/Academic/Research/Innovation.2008/
log using log/newwork-clean.log, replace

use dta/ipums/2000/2000-raw.dta, clearsselect 1 975recbasicmigratecompresssave dta/ipums/2000/2000-wk1.dta, replacesumuse dta/ipums/1990/1990-raw.dta, clearsselect 3 889recbasicmigratecompresssave dta/ipums/1990/1990-wk1.dta, replacesum

use dta/ipums/1980/1980-raw.dta, clearsselect 3 889
recbasic
migrate98
compress
save dta/ipums/1980/1980-wk1.dta, replace
sum

/* MERGE FINAL FILES */finalmerge 2000 1990
finalmerge 1990 1980
finalmerge 1980 1970

/*

/* CREATE POOLED FILE */
use dta/ipums/2000/2000-wk2
append using dta/ipums/1990/1990-wk2
append using dta/ipums/1980/1980-wk2
compress
save dta/ipums/pooled-wk1, replace

*//* ALL DONE! */

log close
clear

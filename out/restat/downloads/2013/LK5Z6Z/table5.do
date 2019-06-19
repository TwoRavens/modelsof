clear all
set more off
set matsize 600
set maxvar 5000

*** insert location of directory containing files in place of DIRECTORY here:
cd "DIRECTORY"

log using table5.txt, text replace

*** This .do file produces the results in Table 5 of the paper.
*** The data set used is produced by gen_natality_data.do.

use natality.dta

*** merge in weather data
gen temp=fipsres/1000
gen state=int(temp)
drop temp

*** crosswalk of state FIPS codes
replace state=3 if state==4
replace state=4 if state==5
replace state=5 if state==6
replace state=6 if state==8
replace state=7 if state==9
replace state=8 if state==10
replace state=9 if state==11
replace state=10 if state==12
replace state=11 if state==13
replace state=12 if state==15
replace state=13 if state==16
replace state=14 if state==17
replace state=15 if state==18
replace state=16 if state==19
replace state=17 if state==20
replace state=18 if state==21
replace state=19 if state==22
replace state=20 if state==23
replace state=21 if state==24
replace state=22 if state==25
replace state=23 if state==26
replace state=24 if state==27
replace state=25 if state==28
replace state=26 if state==29
replace state=27 if state==30
replace state=28 if state==31
replace state=29 if state==32
replace state=30 if state==33
replace state=31 if state==34
replace state=32 if state==35
replace state=33 if state==36
replace state=34 if state==37
replace state=35 if state==38
replace state=36 if state==39
replace state=37 if state==40
replace state=38 if state==41
replace state=39 if state==42
replace state=40 if state==44
replace state=41 if state==45
replace state=42 if state==46
replace state=43 if state==47
replace state=44 if state==48
replace state=45 if state==49
replace state=46 if state==50
replace state=47 if state==51
replace state=48 if state==53
replace state=49 if state==54
replace state=50 if state==55
replace state=51 if state==56

*** calculate month of conception
rename dgestat gestage
drop if state>51
gen concepmo=birthmon+3
replace concepmo=1 if concepmo==13
replace concepmo=2 if concepmo==14
replace concepmo=3 if concepmo==15
replace concepmo=concepmo+1 if gestage<36
replace concepmo=1 if concepmo==13
replace concepmo=concepmo+2 if gestage<32
replace concepmo=1 if concepmo==13
replace concepmo=2 if concepmo==14
replace concepmo=concepmo+3 if gestage<28
replace concepmo=1 if concepmo==13
replace concepmo=2 if concepmo==14
replace concepmo=3 if concepmo==15
replace concepmo=concepmo+4 if gestage<24
replace concepmo=1 if concepmo==13
replace concepmo=2 if concepmo==14
replace concepmo=3 if concepmo==15
replace concepmo=4 if concepmo==16
replace concepmo=concepmo+5 if gestage<20
replace concepmo=1 if concepmo==13
replace concepmo=2 if concepmo==14
replace concepmo=3 if concepmo==15
replace concepmo=4 if concepmo==16
replace concepmo=5 if concepmo==17
replace concepmo=concepmo-1 if gestage>40
replace concepmo=12 if concepmo==0
replace concepmo=concepmo-2 if gestage>44
replace concepmo=12 if concepmo==0
replace concepmo=11 if concepmo==-1
gen concepyr=year
replace concepyr=concepyr-1 if concepmo>birthmo
gen nbirths=1

keep year state fipsres birthmon gestage married momwhite teenmom momHS concepmo concepyr nbirths
count

*** add in weather for FIPS of residence
sort fipsres concepyr concepmo
merge fipsres concepyr concepmo using alltemps1.dta
tab _merge
drop if _merge==2
drop _merge

*** add om weather for state capital if FIPS weather missing
sort state concepyr concepmo
merge state concepyr concepmo using capital.dta, update
tab _merge
drop if _merge==2
drop _merge

** collapse to FIPS/birth month/year level
collapse state gestage-teenmom MNTM-MMXT (count) nbirths, by(fipsres year birthmon) 

drop if nbirths==0

xi i.birthmon i.fipsres

gen t=((year-1988)*12)+birthmon
gen tsq=t^2
gen tcu=t^3

*** create weather at conception and expected weather at birth
tsset fipsres t
foreach var in DPNT DT90 MMXT MNTM MMNT {
	gen F`var' = F9.`var'
	gen L`var' = L3.`var'
	}


egen nomiss=rowmiss(married birthmon t nbirths fipsres DT90 MMXT MNTM DPNT MMNT DPNT LDT90 LMMXT LMNTM LMMNT)

*** do the Gelbach decomposition, using .ado file from Jonah Gelbach
qui do jonah.ado
b1x2 married [aw=nbirths] if nomiss==0, x1all(_Ib* t tsq tcu) x2all(_If* DPNT DT90 MMXT MNTM MMNT LDPNT LDT90 LMMXT LMNTM LMMNT) x2delta(g1 = _If* : g2= DPNT DT90 MMXT MNTM MMNT : g3=LDPNT LDT90 LMMXT LMNTM LMMNT) nofull cluster(fipsres)

* get full estimate:
areg married _Ib* DPNT DT90 MMXT MNTM MMNT LDPNT LDT90 LMMXT LMNTM LMMNT t tsq tcu [aw=nbirths], absorb(fipsres) cluster(fipsres)

log close

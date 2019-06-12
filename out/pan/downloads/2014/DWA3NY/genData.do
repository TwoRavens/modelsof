
*
* 1__genData1.do
* 
* This file generates the main data set from raw 
* British Household Panel data
*
* BHPS data is freely accessible, but you have to register at
* https://www.iser.essex.ac.uk/bhps/acquiring-the-data to get them
*
*
* NOTE: this code assumes that BHPS data files are in the subdirectory
* bhps_data. If you placed them somewhere else, adjust the "use" statements below
* (Windows user may need to adjust paths as well)



clear all
set more off

set logtype text
log using genData, replace


* ========================================
* = extract variables from raw bhps data =
* ========================================

* Main individual variables
local waves = "a c e g j n q"
foreach i of local waves {
	use "bhps_data/`i'indresp"
	keep `i'sex `i'isced `i'jbgold `i'jlgold `i'tenure `i'region `i'qfedhi `i'qfvoc `i'qfachi `i'fimn `i'fiyr  `i'age `i'hid  `i'jbsemp `i'jbmngr `i'jbisco `i'jlisco `i'jssize `i'tuin1  pid `i'opsoce `i'hoh `i'jbft `i'jbstat `i'jbhas `i'jboff `i'mastat `i'mlstat
	gen wave = "`i'"
	sort pid
	renpfix `i'
	save _`i', replace
}

use _a
append using _c _e _g _j _n _q
sort pid wave
egen waven = group(wave)

save __main, replace


* Union member
* waves j and n: question not asked, using values from previous wave
local waves = "a c e g i m q"

foreach i of local waves {
	use "bhps_data/`i'indresp"
	keep  pid `i'orgmb
	gen wave = "`i'"
	sort pid
	renpfix `i'
	save _`i', replace
}
use _a
append using _c _e _g _i _m _q
sort pid wave
egen waven = group(wave)

save __union, replace

use __main
merge 1:1 pid waven using __union
gen unionmerge = _merge
drop _merge
save __main, replace


* HH data
local waves = "a c e g j n q"

foreach i of local waves {
	use "bhps_data/`i'hhresp"
	keep `i'hid `i'fieqfca `i'fieqfcb `i'fihhmn `i'fihhyr `i'hhsize `i'nkids `i'hsval `i'nch02 `i'nch34 `i'nch511 `i'nch1215 `i'npens `i'nwage
	gen wave = "`i'"
	renpfix `i'
	sort hid
	save _hh`i', replace
}

use _hha
append using _hhc _hhe _hhg _hhj _hhn _hhq
sort hid wave
egen waven = group(wave)

save __hh, replace


use __main
merge m:1 hid using __hh
fre _merge
drop if _merge==2
drop _merge

save __main, replace



* add CPI index
import excel "CPI.xlsx", sheet("cpi") firstrow clear
sort waven
drop if missing(waven)
save __cpi, replace

use __main
merge m:1 waven using __cpi
drop _merge
save __main, replace



* merge in constant person and HH information 

use "bhps_data/xwaveid"
sort pid
save __waveid, replace

use __main
count
merge m:1 pid using __waveid
drop if _merge!=3
drop _merge
count
save __main, replace


use "bhps_data/xwlsten"
sort pid
save __wlsten, replace

use __main
merge m:1 pid using __wlsten
drop if _merge!=3
drop _merge
count
save __main, replace


use "bhps_data/xwavedat"
sort pid
save __wdat, replace

use __main
merge m:1 pid using __wdat
drop if _merge!=3
drop _merge
save __main, replace





* ========================================
* =        gen pid x time file 
* ========================================

codebook pid

* Select 'Essex' sample
* only original sample members
fre memorig 

drop if memorig != 1
* drop temporary sample members
fre mstat
drop if mstat==2

* no wales scotland respondents
drop if region == 17 | region ==18 

codebook pid


keep pid
gen cons=1
collapse cons, by(pid)
drop cons
expand 7
sort pid
bys pid: gen time = _n -1
bys pid: gen waven = _n

merge m:1 pid waven using __main, gen(_timeXpid_merge)
fre _timeXpid_merge
drop if _timeXpid_merge!=3
drop _timeXpid_merge
drop wave

sort pid waven

codebook pid




* ========================================
* =     select sample
* ========================================

* age 16 + to retirement age (men/women)
bys pid: gen ageat1 = age[_n==1]
bys pid: egen ageat1m = mean(ageat1)
drop if ageat1m<16
drop if missing(ageat1m)

bys pid: egen maxage = max(age)
drop if maxage > 64 & sex==1
drop if maxage > 59 & sex==2

* drop those self classified as retired or full-time students
bys pid: gen jbstat1 = jbstat[_n==1]
bys pid: egen jbstat1m = mean(jbstat1)
drop if jbstat1m==4 | jbstat1m==6


codebook pid




* =======================================================
* =           recode covariate values                   =
* =======================================================

* Female
* I recode -7 (proxy resp) to . - all of them entered the panel in wave p q
drop if sex==-9 | sex==-7
recode sex (1=0) (2=1), gen(female)
drop sex
	
* Goldthorpe classes (values analog to esec)
recode jbgold (-9 -8 =.) (1=1)(2=2)(3=3)(5 6 7=4)(8=5)(4=6)(9=7)(10 11=8), gen(gold)

* Goldthorpe Mother and Father 	
recode pagold (-9 -8 =.) (1 2=5 srv) (3 4=3 rnm) (5 6 7=4 sempl) (8 9=2 skwrk) (10 11 = 1 unskwrk), gen(pagold2)
recode magold (-9 -8 =.) (1 2=5 srv) (3 4=3 rnm) (5 6 7=4 sempl) (8 9=2 skwrk) (10 11 = 1 unskwrk), gen(magold2)
egen zgold = rowmax(pagold2 magold2)


* union membership
recode orgmb (-9 -7 =.), gen(union)

* birth cohort
drop if doby==-9
gen cohort = (doby-1940)/10

* summary nonwhite dummy
gen nonwhite = 0
replace nonwhite =1 if race != 1
replace nonwhite =1 if racel > 5

* housing owner-occupier dummy:
recode tenure (-9=.) (1 2=1 owner) (else=0), gen(ownocc)

*house value
recode hsval (-9 -8 = .)
gen hsequi = hsval*invcpi/100000
recode hsequi (.=0)


* Household income:
* equivalized
gen hhinc = (fihhyr*fieqfcb*invcpi)/10000 
* Respondent income share of HH
gen incshr =  fiyr/fihhyr
* Permanent and transitory income
bys pid: egen perminc = mean(hhinc)
bys pid: gen transinc =  hhinc - perminc

* Household size
recode hhsize (8/14=8)


* simple divorce dummy and divorce event ('delta' variable)
recode mastat (-1 0 7=.) (4 = 1 divorced) (else = 0) , gen(div)
gen ddiv = 0
bys pid: replace ddiv = 1 if div[_n]==1 & div[_n-1]==0

* part time employment dummy
recode jbft (-9 -8 -7=.)

* unemployment dummy and delta unempl
recode jbstat (-9 -7 -1=.) (3=1 unempl) (else=0), gen(uempl)
gen duempl = 0
bys pid: replace duempl = 1 if uempl[_n]==1 & uempl[_n-1]==0

*Age
replace age = age/10

*Region
recode region (-9=.)


* Education
*1. higher and further education, which includes first and higher degrees, nursing and other higher qualifications; 2. A-Levels or Abitur (upper school); 3. GCSE/O-Levels or Real Schule (lower school); and 4. low or no qualifications, which is used as reference group.

recode qfachi (-9 -7 =.) (1 2 3 =1 degree) (4 =2 alevel) (5 6 = 3 olevel) (7=4 none), gen(eduqual) 

* Calc highest education achieved
bys pid: egen edu = max(eduqual)
tab edu, gen(edu)
ren edu1 degree
ren edu2 alvl
ren edu3 olvl
drop edu4



* DV: redistribution (gov resp jobs)
tab opsoce
recode opsoce (-9/-1 =.) 
vreverse opsoce, gen(govjobs)
lab drop govjobs
tab govjobs
ren govjobs y
* 3 cat coding starting at zero
recode y (1 2= 0) (3=1) (4 5 =2)



* Initial condition variables

* region at t0
bys pid: gen _tmp = region[_n==1]
bys pid: egen region0 = mean(_tmp)
drop _tmp
recode region0 (1 2 =1)(.=.)(else=0), gen(london)
drop region0

*zgold (parental background) at t0
bys pid: gen _tmp = zgold[_n==1]
drop zgold
bys pid: egen zgold = mode(_tmp), maxmode
drop _tmp




* =======================================================
* =       DROP MISSINGS , SELECT VALID RESPONSES        =
* =======================================================

codebook pid

*missing data
gen test=0
replace test=1 if missing(zgold, female, y, ownocc, incshr, div, uempl, degree, alvl, olvl,union)
drop if test!=0
drop test

codebook pid

* select responses to all seven waves
bys pid: egen validresp = count(y)
fre validresp
tabstat validresp ,stat(p50)
drop if validresp < 7

codebook pid


keep pid waven y female age nonwhite div ddiv uempl duempl degree alvl olvl nkids ownocc hhinc incshr perminc transinc hsequi zgold hhsize london region union eduqual
compress

saveold data1full, replace


* 66 % subsample (used in estimation)
* sample is drawn from persons (pid)
gsample 66, wor per cluster(pid)

sort pid waven

saveold data1samp, replace





* remove temporart files
rm __union.dta
rm _i.dta
rm _m.dta
rm __cpi.dta
rm __hh.dta
rm __main.dta
rm __waveid.dta
rm __wdat.dta
rm __wlsten.dta
rm _a.dta
rm _c.dta
rm _e.dta
rm _g.dta
rm _hha.dta
rm _hhc.dta
rm _hhe.dta
rm _hhg.dta
rm _hhj.dta
rm _hhn.dta
rm _hhq.dta
rm _j.dta
rm _n.dta
rm _q.dta



log close




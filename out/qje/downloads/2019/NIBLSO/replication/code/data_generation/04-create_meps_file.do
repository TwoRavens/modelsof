/*****************************************************************************************
AUTHORS: David Chan and Michael Dickstein, QJE (2019), "Industry Input in Policymaking: 
Evidence from Medicare"

PURPOSE: Generate bins of patient characteristics based on MEPS

INPUTS:
- See lines 32-34 for raw files from MEPS website
- icd9_mdc_xwalk.txt
- mdc_dx_allyrs.dta

OUTPUTS:
- meps_file.dta

NOTES:
- See MEPS website for more information on how each file is constructed.
- Used to scale up frequencies in MarketScan data.
- Bins are identified by sex and age (from consolidated household files), CCC (from 
  medical conditions files), insurance type (from person round plan files), and year.
- Raw data not included in replication package (can be downloaded from MEPS website);
  only output of this file (meps_file.dta) is included.
*****************************************************************************************/

if "${dir}"!="" cd "${dir}"
	// Can set global macro for root directory of replication package ending with
	// "/replication". Otherwise, ensure that Stata is in the root directory.
assert regexm("`c(pwd)'","replication$")
clear all
program drop _all
adopath + ado

*** Import MEPS data *********************************************************************
// Variables to keep from MEPS data
local hhcons_keepers DUPERSID SEX DOBYY PERWT*
local medcond_keepers DUPERSID ICD9* CCCODEX *NUM
local insplan_keepers DUPERSID TYPEFLAG

// List the file names (not included in package; can be downloaded from MEPS website)
local hhcons_files 20 28 38 50 60 70 79 89 97 105 113 121 129 138 147 155
local medcond_files 18 27 37 52 61 69 78 87 96 104 112 120 128 137 146 154
local insplan_files 47f1 47f2 47f3 47f4 57 66 76 88 95 103 111 119 127 136 145 153


* 1 | REPEAT THE PROCESS FOR EACH MODULE

foreach i in hhcons medcond insplan {


* 2 | DECLARE APPROPRIATE CD

  cd data/raw/MEPS/`i'


* 3 | INITIALIZE TEMPFILE AND COUNTER
  
  tempfile `i'
  local b=0


* 4 | LOOP THRU THE TEXT FILES
  
  foreach j in ``i'_files' {
  
    * 4-1. call the infix statements provided by MEPS
    quietly do "./h`j'stu.txt", nostop
	
    * 4-2. fix inconsistencies in weight name when needed
    capture rename WTDPER* PERWT*F
	capture rename PERWT PERWT
	
	* 4-3. keep list of variables declared above
    keep ``i'_keepers'
	
	* 4-4. record the file name
	gen year=1997+`b'
	
	* 4-5. stack up the different years
    if `b' {
      append using ``i''
    }
    save ``i'', replace
    local ++b
  }


* 5 | OUTPUT ABRIDGED FILES TO SEPARATE FOLDER
  
  save "data/intermediate/`i'.dta", replace
}

*** Process MEPS data ********************************************************************

* 1 | PREPARE CONSOLIDATED HOUSEHOLD FILE

* 1-1. create a simple age variable and gender dummy
use "data/intermediate/hhcons.dta", clear
gen female=(SEX==2)
gen age=year-DOBYY

* 1-2. organize and save
rename (DUPERSID PERWT) (id weight)
keep id year female age weight
order id year female age weight
sort id year
tempfile hhcons
save `hhcons', replace


* 2 | PREPARE MEDICAL CONDITIONS FILE

* 2-1. remove missings and pharmacy-treated or untreated conditions
use "data/intermediate/medcond.dta", clear
drop if real(ICD9CODX)<0
egen doc_encounter=rowmax(HHNUM IPNUM OPNUM OBNUM ERNUM DNNUM HSNUM)
drop if ! doc_encounter
drop doc_encounter *NUM

* 2-2. create and join ICD-MDC bridge
preserve
infix str ICD9CODX 1-3 str mdc_ 7-8 ///
  using "data/crosswalks/icd9_mdc_xwalk.txt", clear
keep ICD9CODX mdc_
duplicates drop
sort ICD9CODX mdc_
bysort ICD9CODX: gen j=_n
reshape wide mdc_, i(ICD9CODX) j(j)
egen mdc=concat(mdc_*)
drop mdc_*
sort ICD9CODX
tempfile mdc_bridge
save `mdc_bridge', replace
restore
sort ICD9CODX
merge m:1 ICD9CODX using `mdc_bridge', assert(2 3) keep(3) nogen

* 2-2. organize and save
rename (DUPERSID ICD9CODX) (id icd)
order id year icd
sort id year
tempfile medcond
save `medcond', replace


* 3 | PREPARE INSURANCE PLANS FILE

* 3-1. create employer-based indicator
use "data/intermediate/insplan.dta", clear
gen empbased=(TYPEFLAG==1)

* 3-2. collapse to person level
collapse (max) empbased, by(DUPERSID year)

* 3-3. organize and save
rename DUPERSID id
order id year empbased
sort id year
tempfile insplan
save `insplan', replace


* 4 | MERGE THE COMPONENTS

* 4-1. join modules
use `hhcons', clear
merge 1:m id year using `medcond', nogen assert(1 3)
merge m:1 id year using `insplan', nogen keep(1 3)
replace empbased=0 if missing(empbased)

* 4-2. remove duplicates
collapse (firstnm) female age empbased weight, by(year id icd)
replace icd="ZZZ" if missing(icd)

* 4-3. output final dataset
label variable id "person id (DUPERSID)"
label variable year "year of survey"
label variable female "=1 if female"
label variable age "age (year-DOBYY)"
label variable empbased "=1 if having employer insurance"
label variable icd "icd9 diagnosis code (first 3)"
label variable weight "person weight (PERWTYYF)"
order year id female age icd weight


* 5 | INCORPORATE MARKETSCAN PROBABILITIES

* 5-1. match age format
replace age=cond(age<=17,1,cond(age<=34,2,cond(age<=44,3,cond(age<=54,4,cond(age<=64,5,6)))))
label define fage 1 "17 & under" 2 "18-34" 3 "35-44" 4 "45-54" 5 "55-64" 6 "65 & over"
label values age fage

* 5-2. pull frequencies and generate probabilities
preserve
use "data/intermediate/mdc_dx_allyrs", clear
drop if year==1996 | year==2013
rename (dx_3dig freq_cnt) (icd freq)
bysort year icd: egen total=sum(freq)
gen prob=freq/total
sort year icd
tempfile mktscan_probs
save `mktscan_probs'
restore

* 5-3. merge probabilities and output unmatched
joinby year icd using `mktscan_probs', unmatched(both)
drop if _merge==2
drop _merge
replace mdc="ZZ" if icd=="ZZZ"
replace prob=1 if icd=="ZZZ"
replace mdc="18" if year==1999 & icd=="V08"
replace prob=1 if year==1999 & icd=="V08"
replace mdc="23" if year==1999 & icd=="V69"
replace prob=1 if year==1999 & icd=="V69"
sort year female age empbased icd mdc
order year female age empbased icd mdc
label variable mdc "major diagnostic category"


* 6 | RESHAPE TO ALLOW FOR DIFFERENT WEIGHT VARIANTS

drop total
bysort year id female age empbased weight mdc: gen pivot=_n
reshape wide icd freq prob, i(year id female age empbased weight mdc) j(pivot)


* 7 | CREATE SOME WEIGHT VARIANTS (FOR COPIED MDCS)

egen max_stat=rowmax(prob*)
egen sum_stat=rowtotal(prob*)
replace sum_stat=1 if sum_stat>1
gen prd_stat=1
foreach i of varlist prob* {
  replace prd_stat=prd_stat*(1-`i') if ! missing(`i')
}
replace prd_stat=1-prd_stat
label variable max_stat "max probability within mdc"
label variable sum_stat "summed probability within mdc"
label variable prd_stat "comp of product of comp probs within mdc"
order year id
order *_stat, after(weight)


* 8 | AGGREGATE OVER ID FOR SCALING

foreach i in max sum prd {
  replace `i'_stat=weight*`i'_stat
}
collapse (sum) *_stat, by(year female age empbased mdc)
label variable max_stat "max probability within mdc"
label variable sum_stat "summed probability within mdc"
label variable prd_stat "comp of product of comp probs within mdc"


* 9 | ADD SMOOTHED WEIGHTS

* 9-1. shift employer variable to separate column
foreach i in max sum prd {
  gen `i'_stat_emp=`i'_stat if empbased
  rename `i'_stat `i'_stat_all
}
collapse (sum) *stat*, by(year female age mdc)
tempfile stats
sort year female age mdc
save `stats', replace

* 9-2. create template of all possible combos
tempfile template
foreach i of varlist mdc age female year {
  preserve
  keep `i'
  duplicates drop
  if "`i'"!="mdc" {
    cross using `template'
  }
  save `template', replace
  restore
}
use `template', clear
sort year female age mdc

* 9-3. merge realized stats onto template
merge 1:1 year female age mdc using `stats', assert(1 3) nogen
sort female age mdc year

* 9-4. create rectangularly and triangularly smoothed weights
reshape wide *_stat_*, i(female age mdc) j(year)
local s=3
foreach i in max_stat_all sum_stat_all prd_stat_all ///
             max_stat_emp sum_stat_emp prd_stat_emp  {
  forval j=1994/1996 {
    gen `i'`j'=.
  }
  forval j=2013/2015 {
    gen `i'`j'=.
  }
  forval j=1997/2012 {
    local ___j   =`j'-3
	local  __j   =`j'-2
	local   _j   =`j'-1
	local    j_  =`j'+1
	local    j__ =`j'+2
	local    j___=`j'+3
	egen `i'_rect`j'=rowmean(`i'`_j' `i'`j' `i'`j_')
	gen wt`___j'=1*(1/(`s'+1)) if ! missing(`i'`___j')
	gen wt`__j'=2*(1/(`s'+1)) if ! missing(`i'`__j')
	gen wt`_j'=3*(1/(`s'+1)) if ! missing(`i'`_j')
	gen wt`j'=1 if !missing(`i'`j')
	gen wt`j___'=1*(1/(`s'+1)) if ! missing(`i'`j_')
	gen wt`j__'=2*(1/(`s'+1)) if ! missing(`i'`j__')
	gen wt`j_'=3*(1/(`s'+1)) if ! missing(`i'`j___')
	egen denom=rowtotal(wt*)
	replace wt`___j'=wt`___j'*`i'`___j'
	replace wt`__j'=wt`__j'*`i'`__j'
	replace wt`_j'=wt`_j'*`i'`_j'
	replace wt`j'=wt`j'*`i'`j'
	replace wt`j_'=wt`j_'*`i'`j_'
	replace wt`j__'=wt`j__'*`i'`j__'
	replace wt`j___'=wt`j___'*`i'`j___'
    egen numer=rowtotal(wt*)
	gen `i'_trig`j'=numer/denom
	drop numer denom wt*
  }
}
drop *94 *95 *96 *13 *14 *15

* 9-5. reshape and save result
reshape long max_stat_all      sum_stat_all      prd_stat_all ///
             max_stat_all_trig sum_stat_all_trig prd_stat_all_trig ///
			 max_stat_all_rect sum_stat_all_rect prd_stat_all_rect ///
             max_stat_emp      sum_stat_emp      prd_stat_emp ///
			 max_stat_emp_trig sum_stat_emp_trig prd_stat_emp_trig ///
			 max_stat_emp_rect sum_stat_emp_rect prd_stat_emp_rect ///
			 , i(female age mdc) j(year)
foreach i of varlist *_stat_* {
  label variable `i'
}
order max_stat_all* sum_stat_all* prd_stat_all* ///
      max_stat_emp* sum_stat_emp* prd_stat_emp*, last
order year
sort year female age mdc
label data "binned and smoothed diagnoses (year-sex-age-MDC)"
save data/intermediate/meps_file, replace

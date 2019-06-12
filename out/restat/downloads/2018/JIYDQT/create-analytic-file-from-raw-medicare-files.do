
set more off
global index "${cohort}${pct}_indx"
global indexdemo "${cohort}${pct}_indxdemo"
global medpar "${cohort}${pct}_medparclms"
global como "${cohort}${pct}_medpar_cc"
global indexcost "${cohort}${pct}_indexcost"
global indexamb "${cohort}${pct}_ambindx"


global rsmr_ver = "082314"
global fe "rzip"
global analysisdata "../data/"
global amb_keep "linepmt lalowchg coinamt mtus_ind mtus_cnt  hcpcs_cd diag_id tax_num icd_dgns_cd1 mdfr_cd1"
global nondef "038 162 197 410 431 433 434 435 482 486 507 518 530 531 532 557 558 560 599 728 780 807 808 820 823 824 959 965 969"
global ami "41000 41001 41010 41011 41020 41021 41030 41031 41040 41041 41050 41051 41060 41061 41070 41071 41080 41081 41090 41091"
global hf "40201 40211 40291 40401 40403 40411 40413 40491 40493 4280 4281 42820 42821 42822 42823 42830 42831 42832 42833 42840 42841 42842 42843 4289"
global pn "4800 4801 4802 4803 4808 4809 481 4820 4821 4822 48230 48231 48232 48239 48240 48241 48249 48281 48282 48283 48284 48289 4829 4830 4831 4838 485 486 4870"
do "./sub-files/planned.do"

  * Ambulance Claims 
  use ${opExt}/${cohort}${pct}_ambclms.dta, clear
  rename icd_dgns_cd1 amb_diag
  rename mdfr_cd1 amb_origdest
  rename provider amb_id
  sort diag_id hcpcs_cd
  bys diag_id : gen j=_n

  keep hcpcs_cd pmt_amt amb_diag amb_origdest amb_id diag_id j
  reshape wide hcpcs_cd pmt_amt amb_diag amb_origdest amb_id , i(diag_id) j(j)
  
  gen amb_miles = .
  gen amb_origdest = amb_origdest1
  gen amb_extra_miles = .
  gen amb_als = 0
  gen amb_emergency = 0
  gen amb_nonemergency = 0
  
  gen amb_iv = 0
  gen amb_intubate = 0
  gen amb_pmt = 0
  gen amb_id = amb_id1
  gen amb_diag = amb_diag1
  
  forval j = 1/5 {
    replace amb_als = 1 if hcpcs_cd`j'=="A0390"|hcpcs_cd`j'=="A0392"|hcpcs_cd`j'=="A0394"|hcpcs_cd`j'=="A0396"|hcpcs_cd`j'=="A0398"|hcpcs_cd`j'=="A0427"|hcpcs_cd`j'=="A0433"
    replace amb_emergency = 1 if hcpcs_cd`j'=="A0427"|hcpcs_cd`j'=="A0429"
    replace amb_nonemergency = 1 if hcpcs_cd`j'=="A0426"|hcpcs_cd`j'=="A0428"
    replace amb_iv = 1 if hcpcs_cd`j'=="A0394"
    replace amb_intubate = 1 if hcpcs_cd`j'=="A0396"
    replace amb_pmt = amb_pmt + pmt_amt`j' if pmt_amt`j'!=.
  }
  
  drop if amb_id ==""
  keep diag_id amb_miles amb_extra_miles amb_als amb_emergency amb_nonemergency amb_iv amb_intubate amb_pmt amb_id amb_diag amb_origdest
  gen amb_file = "op"
  tempfile amb_op
  save `amb_op', replace

  
  use ${carExt}/${cohort}${pct}_ambclms.dta ,clear
  keep $amb_keep
  rename icd_dgns_cd1 amb_diag
  rename mdfr_cd1 amb_origdest
  gsort diag_id -mtus_cnt hcpcs_cd
  bys diag_id : gen j=_n
  keep if j<=10
  reshape wide hcpcs_cd mtus_ind coinamt lalowchg linepmt mtus_cnt tax_num amb_diag amb_origdest , i(diag_id) j(j)
  gen amb_miles = mtus_cnt1
  gen amb_origdest = amb_origdest1
  gen amb_extra_miles = 0
  gen amb_als = 0
  gen amb_emergency = 0
  gen amb_nonemergency = 0
  gen amb_iv = 0
  gen amb_intubate = 0
  gen amb_pmt = 0
  gen amb_id = tax_num1
  gen amb_diag = amb_diag1
  
  forval j = 1/10 {
    replace amb_extra_miles = mtus_cnt`j' if hcpcs_cd`j'=="A0888" & mtus_ind`j'=="3"
    replace amb_als = 1 if hcpcs_cd`j'=="A0390"|hcpcs_cd`j'=="A0392"|hcpcs_cd`j'=="A0394"|hcpcs_cd`j'=="A0396"|hcpcs_cd`j'=="A0398"|hcpcs_cd`j'=="A0427"|hcpcs_cd`j'=="A0433"
    replace amb_emergency = 1 if hcpcs_cd`j'=="A0427"|hcpcs_cd`j'=="A0429"
    replace amb_nonemergency = 1 if hcpcs_cd`j'=="A0426"|hcpcs_cd`j'=="A0428"
    replace amb_iv = 1 if hcpcs_cd`j'=="A0394"
    replace amb_intubate = 1 if hcpcs_cd`j'=="A0396"
    replace amb_pmt = amb_pmt + linepmt`j' if linepmt`j'!=.
  }
  
  drop if amb_id ==""
  keep diag_id amb_miles amb_extra_miles amb_als amb_emergency amb_nonemergency amb_iv amb_intubate amb_pmt amb_id amb_diag amb_origdest
  gen amb_file = "car"
  append using `amb_op'
  su amb_miles
  replace amb_miles  = r(mean) if amb_miles==.
  su amb_extra_miles
  replace amb_extra_miles = r(mean) if amb_extra_miles==.
  bys diag_id: keep if _n==1
  tempfile amb
  save `amb', replace


  * Hospital Level
  use /disk/agebulk1/medicare.work/wise-DUA16702/daltonm/preprocessed/pos/posmaster_clean, clear
  gsort -fileyear
  tab fileyear
  keep if hsanum!=.
  bys prvnumgrp: keep if _n==1
  preserve
  keep prvnumgrp hsanum hrrnum 
  tempfile dartimpute
  save `dartimpute'
  restore
  keep prvnumgrp hsanum hrrnum zipcode
  rename zipcode hosp_zipcode
  rename hsanum hosp_hsanum
  rename hrrnum hosp_hrrnum
  tempfile hosp
  save `hosp', replace

  * ZIP Geocodes
  use zip latitude longitude using /disk/agebulk2/medicare.work/doyle-DUA18266/gravesj/spending/geography/zip_latlong, clear
  preserve
  rename zip zip_med
  rename latitude bene_y
  rename longitude bene_x
  tempfile clm_xy
  save `clm_xy', replace
  restore
  rename zip hosp_zipcode
  rename latitude hosp_y
  rename longitude hosp_x
  tempfile hosp_xy
  save `hosp_xy', replace

**********************
  * Index Events
**********************
use ${indexExt}/${indexdemo}, clear
joinby diag_id diag_year using ${comorbid}/${como}

destring race, replace
gen white = race==1
gen black = race==2
gen race_other = race>2

tab diag_year, gen(year)

gen idx_ami = 0
gen idx_pn = 0
gen idx_hf = 0
gen idx_cmp = 1

foreach xx of global ami {
  replace idx_ami = 1 if strpos(dICD9_indx,"`xx'")>0
}
foreach xx of global pn {
  replace idx_pn = 1 if strpos(dICD9_indx,"`xx'")>0
}
foreach xx of global hf {
  replace idx_hf = 1 if strpos(dICD9_indx,"`xx'")>0
}

if "$cohort" == "cms" keep if idx_ami ==1 | idx_pn==1 | idx_hf==1
count 
global count1 : di %20.0fc r(N)
notes: Initial Index Sample: $count1

su $XXnoamb

joinby diag_id using ${indexExt}/${indexamb}

count 
global count1 : di %20.0fc r(N)
notes: Initial Ambulance Sample: $count1

tempfile indxamb
save `indxamb', replace

**********************
  * Medpar Claims
***********************
use ${medExt}/${medpar}, clear
gen indxdt = dschrgdt if flagindx ==1
replace indxdt = indxdt[_n-1] if indxdt==. & diag_id==diag_id[_n-1]
keep if indxdt!=.
format indxdt %d
joinby diag_id using `indxamb'

joinby prvnumgrp using `dartimpute', unmatched(both) update
tab _merge
drop _merge
tab fileyear if hsanum==.

gen planned_admit = 0
gen acute_complication = 0

forval c = 1/1 {
  foreach cx of global acute_complication {
    replace acute_complication = 1 if dgnscd`c'=="`cx'"
  }
}

forval p = 1/6 {
  foreach px of global planned {
    replace planned_admit = 1 if prcdrcd`p'=="`px'" & acute_complication==0
  }
}

gen readmit30X = admsndt>indxdt & admsndt-indxdt <=30 & planned_admit==0 & (is_shorthosp==1 | is_cah==1)
egen readmit30 = max(readmit30X), by(diag_id)

gen snf30X = admsndt>indxdt & admsndt-indxdt <=30 & is_snf==1
egen snf30 = max(snf30X), by(diag_id)

keep if flagindx==1

count
cap drop _merge
joinby prvnumgrp using `hosp', unmatched(master)
tab _merge
drop _merge

duplicates drop
bys diag_id: keep if _n==_N

count
global count1 : di %20.0fc r(N)
notes: Delete Duplicates: $count1

joinby diag_id using `amb'
count
global count1 : di %20.0fc r(N)
notes: Has Ambulance Data: $count1

keep if src_adms!="4" & src_adms!="6"
count
global count1 : di %20.0fc r(N)
notes: Exclude Transfers

gen amb_op = amb_file=="op"

gen surv_1 = ((sdod- dgn_date))>=1
gen surv_2yr = ((sdod- dgn_date))>=730
cap drop survival
gen survival = max(0,sdod-dgn_date)

gen death30 = 1-surv_30
gen death1 = 1-surv_1
gen death7 = 1-surv_7
gen death365 = 1-surv_365
gen death2yr = 1-surv_2yr
gen deathip = sdod!=. & sdod<=dschrgdt

gen hh30 = snf30==0 & readmit30==0 & death30==0

gen prin3 = substr(dgnscd1,1,3)
tab prin3, gen(dx)

pause on
pause here
d dx*, full varlist
global dx1 = r(varlist)
global diag ""
foreach xx of global dx1 {
  qui count if `xx'==1
  local nn = r(N)
  if `nn' > 1000 {
    global diag "$diag `xx'"
  }
}

gen amb_origscene = amb_origdest == "SH"
gen amb_orignurse = amb_origdest == "NH"
gen amb_origother = amb_origdest !="RH" & amb_origdest!="SH" & amb_origdest!="NH"
gen amb_orighome = amb_origdest=="RH"

// Sample Filters

keep if diag_year>=2008

drop if state_med=="40"|state_med=="48"
keep if zip_med!=""
keep if zip_med!="00000"
cap drop _merge
joinby zip_med using `clm_xy', unmatched(master) _merge(merbenezip)
count
global count1 : di %20.0fc r(N)
notes: Has ZIP x,y data: $count1
joinby hosp_zipcode using `hosp_xy', unmatched(master)  _merge(merhospzip)
count
global count1 : di %20.0fc r(N)
notes: Has Hospital XY Data: $count1
gen distance = acos(cos(((90-hosp_y) / (180/_pi))) * cos(((90-bene_y) / (180/_pi))) + sin(((90-hosp_y) / (180/_pi)))* sin(((90-bene_y) / (180/_pi)))   *  cos(((hosp_x-bene_x) / (180/_pi))))*3958.756
keep if distance <100
*count
*global count1 : di %20.0fc r(N)
*notes: Filter: Contentital US & <100 miles distance to hospital: $count1
keep if amb_id!=""
keep if !inlist(amb_id,"0","00000000","000000000")
count
global count1 : di %20.0fc r(N)
notes: Has Ambulance ID: $count1
egen hcnt=count(1), by(prvnumgrp)
keep if hcnt>30
count
global count1 : di %20.0fc r(N)
notes: Hospital Has >30 Observations: $count1
egen ambcnt = count(1) , by(amb_id)
keep if ambcnt>20
count
global count1 : di %20.0fc r(N)
notes: Ambulance has >20 observations: $count1
keep if death365~=.
count
global count1 : di %20.0fc r(N)
notes: Non-Missing Death Information: $count1

save ../data/${cohort}${pct}-analysis-file-ver-${version}.dta, replace  

use  ../data/${cohort}${pct}-analysis-file-ver-${version}.dta, clear

global Y "death365 death1 deathip death7 death30 death2yr hh30 readmit30 survival"
global demo "ag70t74 ag75t79 ag80t84 ag85t89 ag90t94 ag95p male black race_other ageAtdiag"
d year*, fullnames varlist
global year = r(varlist)
global amb "amb_miles amb_als amb_emergency amb_iv amb_intubate amb_op amb_pmt"
global comox "como_hyper como_stroke como_cervas como_renal como_dialysis como_COPD como_pnuemo como_diabetes como_protein como_dementia como_FDLsDis como_periph como_metaCancer como_trauma como_subs como_mPsych como_cLiver"
global covars "$year $demo $amb $comox $diag idx_ami idx_hf idx_pn"

gen num_comorbid = 0

foreach cc of global comox {
  replace num_comorbid = num_comorbid + 1 if `cc' ==1
}
d zip_med hrrnum hsanum $covars prvnumgrp amb_id $Y amb_orighome amb_origscene $year  , full

sort bene_id diag_year
keep bene_id zip_med diag_year hrrnum hsanum $covars prvnumgrp amb_id $Y amb_orighome amb_origscene $year num_comorbid
saveold ../data/${cohort}${pct}-analysis-small-file-ver-${version}.dta, replace
*/
/* Note: There is some additional generation commands at the beginning of 2main_results.do within the create_analytic_sample section
which creates variables for the original paper */




/*
****
** Geocoded ZIP Data
****
use zip latitude longitude using ../data/zip_latlong, clear
preserve
rename zip zip_clm
rename latitude bene_y
rename longitude bene_x
tempfile clm_xy
save `clm_xy', replace
restore
rename zip hosp_zipcode
rename latitude hosp_y
rename longitude hosp_x
tempfile hosp_xy
save `hosp_xy', replace

****
** Ambulance Claims
****
use ${opExt}/${cohort}${pct}_opambclaims.dta, clear
rename dgnscd1 amb_diag
rename mdfr_cd1 amb_origdest
rename provider amb_id
sort diag_id hcpcs_cd
bys diag_id : gen j=_n
keep hcpcs_cd pmt_amt amb_diag amb_origdest amb_id diag_id j
reshape wide hcpcs_cd pmt_amt amb_diag amb_origdest amb_id , i(diag_id) j(j)

gen amb_miles = .
gen amb_origdest = amb_origdest1
gen amb_extra_miles = .
gen amb_als = 0
gen amb_emergency = 0
gen amb_nonemergency = 0
gen amb_iv = 0
gen amb_intubate = 0
gen amb_pmt = 0
gen amb_id = amb_id1
gen amb_diag = amb_diag1

* Generate Ambulance-Related Covariates
forval j = 1/5 {
  replace amb_als = 1 if hcpcs_cd`j'=="A0390"|hcpcs_cd`j'=="A0392"|hcpcs_cd`j'=="A0394"|hcpcs_cd`j'=="A0396"|hcpcs_cd`j'=="A0398"|hcpcs_cd`j'=="A0427"|hcpcs_cd`j'=="A0433"
  replace amb_emergency = 1 if hcpcs_cd`j'=="A0427"|hcpcs_cd`j'=="A0429"
  replace amb_nonemergency = 1 if hcpcs_cd`j'=="A0426"|hcpcs_cd`j'=="A0428"
  replace amb_iv = 1 if hcpcs_cd`j'=="A0394"
  replace amb_intubate = 1 if hcpcs_cd`j'=="A0396"
  replace amb_pmt = amb_pmt + pmt_amt`j' if pmt_amt`j'!=.
}

drop if amb_id ==""
keep diag_id amb_miles amb_extra_miles amb_als amb_emergency amb_nonemergency amb_iv amb_intubate amb_pmt amb_id amb_diag amb_origdest
gen amb_file = "op"
tempfile amb_op
save `amb_op', replace

use ${carExt}/${cohort}${pct}_ambclaims.dta ,clear
keep $amb_keep
rename dgns_cd1 amb_diag
rename mdfr_cd1 amb_origdest
gsort diag_id -mtus_cnt hcpcs_cd
bys diag_id : gen j=_n
keep if j<=10
reshape wide hcpcs_cd mtus_ind coinamt lalowchg linepmt mtus_cnt tax_num amb_diag amb_origdest , i(diag_id) j(j)
gen amb_miles = mtus_cnt1
gen amb_origdest = amb_origdest1
gen amb_extra_miles = 0
gen amb_als = 0
gen amb_emergency = 0
gen amb_nonemergency = 0
gen amb_iv = 0
gen amb_intubate = 0
gen amb_pmt = 0
gen amb_id = tax_num1
gen amb_diag = amb_diag1

forval j = 1/10 {
  replace amb_extra_miles = mtus_cnt`j' if hcpcs_cd`j'=="A0888" & mtus_ind`j'=="3"
  replace amb_als = 1 if hcpcs_cd`j'=="A0390"|hcpcs_cd`j'=="A0392"|hcpcs_cd`j'=="A0394"|hcpcs_cd`j'=="A0396"|hcpcs_cd`j'=="A0398"|hcpcs_cd`j'=="A0427"|hcpcs_cd`j'=="A0433"
  replace amb_emergency = 1 if hcpcs_cd`j'=="A0427"|hcpcs_cd`j'=="A0429"
  replace amb_nonemergency = 1 if hcpcs_cd`j'=="A0426"|hcpcs_cd`j'=="A0428"
  replace amb_iv = 1 if hcpcs_cd`j'=="A0394"
  replace amb_intubate = 1 if hcpcs_cd`j'=="A0396"
  replace amb_pmt = amb_pmt + linepmt`j' if linepmt`j'!=.
}

drop if amb_id ==""
keep diag_id amb_miles amb_extra_miles amb_als amb_emergency amb_nonemergency amb_iv amb_intubate amb_pmt amb_id amb_diag amb_origdest
gen amb_file = "car"
append using `amb_op'
su amb_miles
replace amb_miles  = r(mean) if amb_miles==.
su amb_extra_miles
replace amb_extra_miles = r(mean) if amb_extra_miles==.
tempfile amb
save `amb', replace

****
** Total Spending For Inpatient Admission
****
use ${costs}/${indexcost}
foreach   type    in   dochosp car hosp snf medpar shosp lhosp   cah rehabh psychh op {
  replace `type'_d365 = 0 if `type'_d365==.
  rename `type'_d365 `type'_index
}
keep diag_id *_index 
tempfile costs
save `costs', replace

****
** Comorbidities
****
use ${comorbid}/${como}, clear
sort bene_id
local comos "hyper stroke cervas renal dialysis COPD pneumo diabetes protein dementia FDLsDis periph metaCancer trauma subs mPsych cLiver"
tempfile como
save `como', replace


****
** Demographics + Patient ZIP Dartmouth
****
use ${indexExt}/${indexdemo}
tempfile demo
save `demo', replace


****
** Index Visit Date
****
use ${indexExt}/${index}, clear
rename dgn_date admsndt
tempfile index
save `index', replace
count


****
** Provider of Service File and Dartmouth HRR / HSA Data
****
use /disk/agebulk1/medicare.work/wise-DUA16702/daltonm/preprocessed/pos/posmaster_clean, clear
gsort -fileyear
bys prvnumgrp: keep if _n==1
keep prvnumgrp hsa* hrr* zipcode 
rename zipcode hosp_zipcode
tempfile hosp
save `hosp', replace


****
** MEDPAR
****
use ${medExt}/${medpar}, clear
sort bene_id diag_id dgn_date admsndt dschrgdt

sort bene_id diag_id dgn_date admsndt dschrgdt

* Readmission Measure
foreach d in 30 60 90 {
  gen readmit`d' = 0
  forval c = 1/20 {
    replace readmit`d' = 1 if is_shorthosp==1 & admsndt[_n+`c']>dschrgdt & is_shorthosp[_n+`c']==1 & admsndt[_n+`c']-dgn_date<=`d' & bene_id==bene_id[_n+`c']
  }
}

* SNF Admission and Discharge Measures
gen snf_id = ""
gen disch_snf = 0
forval i = 1/20 {
  replace snf_id = prvnumgrp[_n+`i'] if is_snf[_n+`i'==1] & admsndt[_n+`i'] == dschrgdt & bene_id == bene_id[_n+`i'] & is_shorthosp==1
  replace disch_snf  = 1 if is_snf[_n+`i'==1] & admsndt[_n+`i'] == dschrgdt & bene_id == bene_id[_n+`i'] & is_shorthosp==1
}
keep if is_shorthosp==1

sort bene_id diag_id admsndt
bys bene_id: gen visit_num = _n

joinby prvnumgrp using `hosp'

egen tag = tag(prvnumgrp hsanum fileyear)
egen hsaN= sum(tag), by(hsanum fileyear)

joinby diag_id bene_id admsndt using `index'
sort diag_id admsndt

count
global count1 : di %20.0fc r(N)
notes: Initial Index Sample: $count1

// join on doc and hospital costs
joinby diag_id using `costs'
count
global count1 : di %20.0fc r(N)
notes: After Merging on Cost Data: $count1

sort diag_id admsndt dschrgdt src_adms
gen trans_orig = transfer
replace transfer = 1 if src_adms=="6" | src_adms=="4"
bys diag_id: keep if _n==_N

count
global count1 : di %20.0fc r(N)
notes: Delete Duplicates: $count1

joinby zip_clm using `clm_xy'
count
global count1 : di %20.0fc r(N)
notes: Has ZIP x,y data: $count1

joinby hosp_zipcode using `hosp_xy'
count
global count1 : di %20.0fc r(N)
notes: Has Hospital XY Data: $count1

* Merge on comorbidities and demographics
joinby diag_id using `como'
count
global count1 : di %20.0fc r(N)
notes: Has Comorbidity Data: $count1

joinby diag_id using `demo', unmatched(both)

tab _merge
keep if _merge==3
count
global count1 : di %20.0fc r(N)
notes: Has Demographic Data: $count1

drop _merge
joinby diag_id using `amb', unmatched(both)
tab _merge
keep if _merge==3
count
global count1 : di %20.0fc r(N)
notes: Has Ambulance Data: $count1
drop _merge

****
** Create Additional Covariates and Outcome Measures
****
  
gen amb_op = amb_file=="op"

gen surv_1 = ((sdod- dgn_date))>=1
gen surv_2yr = ((sdod- dgn_date))>=730

gen death30 = 1-surv_30
gen death1 = 1-surv_1
gen death7 = 1-surv_7
gen death365 = 1-surv_365
gen death2yr = 1-surv_2yr
gen deathip = sdod!=. & sdod<=dschrgdt

destring race, replace
gen white = race==1
gen black = race==2
gen race_other = race>2

tab diag_year, gen(year)

local i = 1
gen nondef=0
foreach d of global nondef {
gen idiag`i' = substr(dgnscd1,1,3)=="`d'"
replace nondef = 1 if idiag`i'==1
local i = `i'+1
}

egen zipcode = group(zip_clm)
gen distance = acos(cos(((90-hosp_y) / (180/_pi))) * cos(((90-bene_y) / (180/_pi))) + sin(((90-hosp_y) / (180/_pi)))* sin(((90-bene_y) / (180/_pi)))   *  cos(((hosp_x-bene_x) / (180/_pi))))*3958.756

gen nondeferrable = 0
foreach x of global nondef {
  replace nondeferrable = 1 if substr(dgnscd1,1,3)=="`x'"
}
// Keep just the nondeferrable cases


gen amb_orighome = amb_origdest =="RH"
gen amb_origscene = amb_origdest == "SH"
gen amb_orignurse = amb_origdest == "NH"
gen amb_origother = amb_origdest !="RH" & amb_origdest!="SH" & amb_origdest!="NH"

replace amb_diag=substr(amb_diag,1,3)
icd9 check amb_diag, gen(invalid)
replace   amb_diag = "" if invalid>0
icd9 gen amb_diag_desc = amb_diag, description
gen dow = dow(dgn_date)

gen amb_nondeferrable = 0
local i = 1
foreach x of global amb_nondef {
  gen iadiag`i' = amb_diag=="`x'"
  replace amb_nondeferrable = 1 if amb_diag=="`x'"
  local i = `i'+1
}


keep if nondeferrable==1
count
global count1 : di %20.0fc r(N)
notes: Has Non-Deferrable Condition: $count1

// Sample Filters
drop if state_clm=="40"|state_clm=="48"
keep if zip_clm!=""
keep if zip_clm!="00000"
count
global count1 : di %20.0fc r(N)
notes: Has Continental US ZIP Code: $count1

keep if amb_id!=""

keep if !inlist(amb_id,"0","00000000","000000000")
count
global count1 : di %20.0fc r(N)
notes: Has Ambulance ID: $count1

egen hcnt=count(1), by(prvnumgrp)
keep if hcnt>30
count
global count1 : di %20.0fc r(N)
notes: Hospital Has >30 Observations: $count1

egen ambcnt = count(1) , by(amb_id)
*  egen ambcnt2 = count(1) , by(amb_id diag_year)  
*  keep if ambcnt2>20 //| amb_type=="op"
keep if ambcnt>20
count
global count1 : di %20.0fc r(N)
notes: Ambulance has >20 observations: $count1

keep if death365~=.
count
global count1 : di %20.0fc r(N)
notes: Non-Missing Death Information: $count1

keep if distance<100
count
global count1 : di %20.0fc r(N)
notes: Distance <100: $count1

gen year = fileyear

save ../data/${cohort}${pct}-analysis-file-ver-${version}.dta, replace

clear
insheet using ~/Quality/county_census_compilation.csv , comma
tostring fips_county, format(%03.0f) replace
rename fips_county county_clm
rename fips_state state_clm 
compress
xtile ctypopquart = population2012estimate, nq(4)
xtile homog_race = whitealone2012 , nq(4)
replace homog_race = 5-homog_race
xtile landquart = landareainsquaremiles2010 , nq(4)
xtile incquart = medianhouseholdincome20082012 , nq(5)
keep county_clm state_clm ctypopquart homog_race landquart incquart 
tempfile county_chars
save `county_chars', replace

local s = "ndss"

use ../data/${cohort}${pct}-analysis-file-ver-${version}.dta , clear
destring zip_clm, gen(zip)
tostring zip , format(%05.0f) replace

drop hrr* hsa*
gen diagyear = diag_year
joinby zip diagyear using ~/Quality/zip_to_dartmouth
count
global count1 : di %20.0fc r(N)
notes: Dartmouth ZIP Information Missing: $count1

count
distinct zip
gen prindiag = dgnscd1
icd9 clean prindiag, dots
foreach d in ami pnx sep fem uti chf {
  gen diag_`d' = 0
  foreach a of global `d' {
    if inlist("`d'","sep","fem","uti") replace diag_`d' =  1 if strpos(prindiag,"`a'")>0
    if inlist("`d'","ami","chf","pnx") replace diag_`d' = 1 if prindiag=="`a'"
  }
}

distinct zip
  if "`s'"=="ndss" {
    keep if nondeferrable==1 
  }
  count
distinct zip

gen dx = substr(dgnscd1,1,3)

joinby prvnumgrp diag_year using /homes/nber/gravesj/spending/data/1PrimaryExtract/indx/rsmr/rsmr_082314/ndef100_pooled_ebayes_082314_rsmr.dta, unmatched(master) _merge(rsmrmerpool)
joinby prvnumgrp diag_year using /homes/nber/gravesj/spending/data/1PrimaryExtract/indx/rsmr/rsmr_${rsmr_ver}/ndef100_comp10_ebayes_${rsmr_ver}_rsmr.dta, unmatched(master) _merge(rsmrmer1)


  count
  global count1 : di %20.0fc r(N)
  notes: Has Empirical Bayes Quality Measures (by hospital id and year): $count1

  cap drop _merge


  joinby prvnumgrp diag_year dx using /homes/nber/gravesj/spending/data/1PrimaryExtract/indx/rsmr/rsmr_${rsmr_ver}/ndef100_rsmr_ebayes_${rsmr_ver}, unmatched(master) _merge(rsmrmer2)

joinby prvnumgrp diag_year using /homes/nber/gravesj/spending/data/1PrimaryExtract/indx/rsmr/rsmr_082314/ndef100_rsmr_ebayes_pnx_082314.dta, unmatched(master) _merge(rsmrmerpnx)
joinby prvnumgrp diag_year using /homes/nber/gravesj/spending/data/1PrimaryExtract/indx/rsmr/rsmr_082314/ndef100_rsmr_ebayes_ami_082314.dta, unmatched(master) _merge(rsmrmerami)
preserve
gen patients =1
collapse (sum)  patients, by(prvnumgrp zip_clm)
bys zip_clm: keep if _N>1
keep zip_clm
duplicates drop
tempfile multi_hosp_zips
save `multi_hosp_zips', replace
restore
count



count
* JG NOOTE 1/5/15: Added DME, HHA, and HOS costs; these are in home_health.do and merged into the cost file (which is then stored in *_full.dta).
* OLD VERSION *joinby diag_id using /homes/nber/gravesj/spending/data/2SecondManiOut/costs/ambip20_alldcost.dta 
joinby diag_id using /homes/nber/gravesj/spending/data/2SecondManiOut/costs/ambip20_alldcost_full.dta

  count
  global count1 : di %20.0fc r(N)
  notes: Has 365 Day Cost Data: $count1

count
replace op_d365=0 if op_d365==.
gen loneyear = log(medpar_d365 + op_d365 + car_d365+hos_d365 + hha_d365 + dme_d365 + .01)
gen oneyear = medpar_d365 + op_d365 + car_d365 + hos_d365 + hha_d365 + dme_d365
gen diag = substr(dgnscd1,1,3)
qui tab diag, gen(dgs)

local N = r(r)
forval n = 2/`N' {
  global Xreg7 "$Xreg7 dgs`n'"
}

// Inpatient Spending
gen spend_tot = dochosp_index+pmt_amt+op_index
gen lspend_tot = log(max(0,spend_tot)+.01)
su spend_tot
gen ipspend = lspend_tot

// Post-Acute Care Spending
gen paspend_tot = car_d365 + medpar_d365 + op_d365 - dochosp_index - pmt_amt - op_index + hos_d365 + hha_d365 + dme_d365

su paspend_tot
gen paspend = log(max(0,paspend)+0.01)
foreach day in 30 60 90 365 {
  foreach v in docof_d`day' hosp_d`day' dochosp_d`day' dochosp_index snf_d`day' op_d`day' other_d`day' ambulance_d`day' labs_d`day' er_d`day' hos_d`day' dme_d`day' hha_d`day' {
    replace `v' = 0 if `v'==.
  }
}
gen padoc = docof_d365
gen pahosp = hosp_d365 + dochosp_d365-dochosp_index - pmt_amt - ambulance_d365
gen pasnf = snf_d365
gen paop = op_d365 - op_index
gen paoth = other_d365
gen paer = er_d365
gen palabs = labs_d365
gen paamb = ambulance_d365

foreach day in 30 60 90 365 {
  gen paspend_t`day' = car_d`day' + medpar_d`day' + op_d`day' - min(dochosp_d`day',dochosp_index) - min(pmt_amt,medpar_d`day') - min(op_d`day',op_index) - ambulance_d`day' + hos_d`day' + hha_d`day'  + dme_d`day' // JG removing other spending
  gen paspend`day' = log(max(0,paspend_t`day')+.01)
  gen padoc`day' = docof_d`day'
  gen pahosp`day' = hosp_d`day'+ dochosp_d`day'-min(dochosp_index,dochosp_d`day') - min(pmt_amt ,hosp_d`day')
  gen pasnf`day' = snf_d`day'
  gen paop`day' = op_d`day' - min(op_index, op_d`day')
  gen paoth`day' = other_d`day'
  gen paer`day' = er_d`day'
  gen palabs`day' = labs_d`day'
  gen paamb`day' = ambulance_d`day'
  gen pahos`day' = hos_d`day'
  gen pahha`day' = hha_d`day'
  gen padme`day' = dme_d`day'
}
egen county = group(state_clm county_clm)
gen zip3 = substr(zip_clm,1,3)

egen rzip = group(zip)

xtreg ipspend paspend $Xreg7, i(${fe}) fe
xtreg death365 , i(${fe}) fe
keep if e(sample)
  count
  global count1 : di %20.0fc r(N)
  notes: NOn-Missing Regression Variables (spending and all controls in ZIP fixed effect): $count1

bys amb_id: gen N=_N

// Sample Filter
keep if hsanum!=.
  count
  global count1 : di %20.0fc r(N)
  notes: Non-Missign HSA: $count1

gen hh30 = death30==0 & readmit30==0

global Yvar "hh30 readmit30 death30 death365"

global qualvar ""

// Spending Measures
joinby prvnumgrp using ~/Quality/dartmouth_chronic_eol0307.dta
  count
  global count1 : di %20.0fc r(N)
  notes: Hospital Has Dartmouth End of Life Measurement : $count1


destring zip3, replace
replace paspend_tot = paspend_tot - paamb
drop oneyear
gen oneyear = log(max(spend_tot + paspend_tot + 1,0))
gen temp_paspend = paspend_tot
gen papsend_rest = paspend_tot
gen paspend_noh = paspend_tot - pahosp   
gen tothosp = spend_tot  - amb_pmt
gen tothosp30 = spend_tot + pahosp30 - amb_pmt
gen tothosp90 = spend_tot + pahosp90 - amb_pmt
gen tothosp365 = spend_tot + pahosp90 - amb_pmt

gen spend365 = spend_tot + paspend_tot
gen spend90 = spend_tot + paspend_t90
gen spend30 = spend_tot + paspend_t30

*gen pahosp365 = pahosp

foreach day in 30 60 90 365 {
  gen paspend_noh`day' = paspend_t`day'  - pahosp`day' 
}
drop paspend
gen paspend = log(paspend_tot+1)

global byjkf ""

global spend "tothosp"


foreach t of global spend {
  gen `t'i = .
  gen `t'im = .  
  foreach y in 2002 2003 2004 2005 2006 2007 2008 2009 {
    cap drop temp
    gen temp = `t' if diag_year==`y'
    inflate temp, index(CPI) from(`y') to(2012)
    replace `t'i = temp if diag_year==`y'
    drop temp
    gen temp = `t' if diag_year==`y'
    inflate temp, index(CPI_U_MED) from(`y') to(2012)
    replace `t'im = temp if diag_year==`y'
    drop temp
    
  }
}


regress cmort365_eb $Xreg7
*keep if e(sample)
  count
  global count1 : di %20.0fc r(N)
  notes: Non-Missing Quality (1-Year Mortality Empirical Bayes): $count1

save ../data/${cohort}${pct}-analysis-file-ver-${version}.dta, replace    

use  ../data/${cohort}${pct}-analysis-file-ver-${version}.dta, clear
global Y "death365 death1 deathip death7 death30 death2yr hh30 readmit30"
global demo "ag70t74 ag75t79 ag80t84 ag85t89 ag90t94 ag95p male black race_other"
global year "year2 year3 year4 year5 year6 year7 year8"
forval i = 2/28 {
   global diag "$diag dgs`i'"
}
global amb "amb_miles amb_als amb_emergency amb_iv amb_intubate amb_op"
#d ;
global comox "como_hyper como_stroke como_cervas como_renal como_dialysis como_COPD como_pnuemo como_diabetes
como_protein como_dementia como_FDLsDis como_periph como_metaCancer como_trauma  como_subs como_mPsych como_cLiver";
#d cr

global covars "$year $demo $amb $comox $diag"

d zip_clm $covars prvnumgrp amb_id $Y amb_orighome amb_origscene year  , full

keep zip_clm $covars prvnumgrp amb_id $Y amb_orighome amb_origscene year
saveold ../data/${cohort}${pct}-analysis-small-file-ver-${version}.dta, replace
*/
/* Note: There is some additional generation commands at the beginning of 2main_results.do within the create_analytic_sample section
which creates variables for the original paper */

********************************
** AIDS AND HUMAN CAPITAL    	**
** analysis.do                **
** Fortson                    **
** DATA FROM: measuredhs.com	**
********************************

set more off
set mem 1000m
set matsize 2000

cd "C:\Documents and Settings\jfortson\My Documents\Work\AIDS HC\Data"
use cleaned.dta

log using "C:\Documents and Settings\jfortson\My Documents\Work\AIDS HC\Data\analysis.log", replace

*** FILEPATH FOR OUTREG FILES ***

global filepath "C:\Documents and Settings\jfortson\My Documents\Work\AIDS HC\Data\Output\"

*** OUTREG SETTINGS ****

global options "bdec(3) comma se sigsymb(*,*) coefastr replace"

*** GRAPH FONT SETTINGS ***

graph set eps fontface Garamond

*** SWITCHES ***

local table1 1
local table2 1
local table3 1
local table4 1
local table5 1
local table6 1
local table7 1
local figure1 1
local figure2 1
local figure3 1
local calculations 1
  local nocontrols 1
  local percentagechange 1 
  local topcode 1
  local men 1
  local trends 1
  local orphans 1
  local circumcision 1
  local assets 1
  local changeingenderdiff 1
  local nonresponse 1
  local migration 1

*** REGRESSION ANALYSIS ***

** TABLE I: SUMMARY STATISTICS

if `table1' == 1 {

log close
log using "C:\Documents and Settings\jfortson\My Documents\Work\AIDS HC\Data\Output\table1.log", replace

* Table I.A: Local HIV Rate, Summary Stats

egen tag = tag(x_country x_region) 
bysort x_country x_region: egen x_regionweight = total(x_hhweight)

gen table1_weight = .
foreach country in bf cm ci et gh gn ke ls mw ml ni rw sn tz zm {
  sum x_regionweight if x_`country' == 1
  replace table1_weight = (x_regionweight) * (x_population / r(sum)) if x_`country' == 1
  sum table1_weight if x_`country' == 1
  return list
}

foreach country in bf cm ci et gh gn ke ls mw ml ni rw sn tz zm {
  sum x_hiv_local if tag == 1 & x_`country' == 1 [aw=x_regionweight], detail
}
sum x_hiv_local if tag == 1 [aw = table1_weight], detail

* Table I.B

replace include = 0
replace include = 1 if x_age >= 7 & x_age<=14 

sum x_hiv_local x_behind x_yob x_female x_rural x_bf x_cm x_ci x_et x_gh x_gn x_ke x_ls x_mw x_ml x_ni x_rw x_sn x_tz x_zm [aw=new_weight] if include == 1

* Table I.C

replace include = 0
replace include = 1 if x_age >= 15 & x_age<50 

sum x_hiv_local x_educ x_educ_positive x_educ_primary x_yob x_female x_rural x_bf x_cm x_ci x_et x_gh x_gn x_ke x_ls x_mw x_ml x_ni x_rw x_sn x_tz x_zm [aw=new_weight] if include == 1

log close
log using "C:\Documents and Settings\jfortson\My Documents\Work\AIDS HC\Data\analysis.log", append

}

** TABLE II: D-in-D, POOLED

if `table2' == 1 {

replace include = 0
replace include = 1 if x_age>=15 & x_age<50 

areg x_educ x_interact x_rural x_female x_yobdummies_* [pw=new_weight] if include == 1, cluster(x_cluster) absorb(x_fe)
outreg x_interact x_rural x_female using "${filepath}table2.out", $options

foreach outcome in x_educ_positive x_educ_primary {
  areg `outcome' x_interact x_rural x_female x_yobdummies_* [pw=new_weight] if include == 1, cluster(x_cluster) absorb(x_fe)
  outreg x_interact x_rural x_female using "${filepath}table2.out", $options append
}

}


** TABLE III: ALTERNATE TIME PATHS

if `table3' == 1 {

* Intermediate (1971-1984) Cohorts Excluded

replace include = 0
replace include = 1 if x_age>=15 & x_age<50

gen x_post_new = 0 if x_age >=15 & x_age < 50 & x_yob <=1970
replace x_post_new = 1 if x_yob >= 1985 & x_yob != . & x_age>=15 & x_age < 50

gen x_interact_new = x_hiv_local * x_post_new

areg x_educ x_interact_new x_rural x_female x_yobdummies_* [pw=new_weight] if include == 1, cluster(x_cluster) absorb(x_fe)
outreg x_interact_new x_rural x_female using "${filepath}table3.out", $options 

* Oster

clear 
use "C:\Documents and Settings\jfortson\My Documents\Work\AIDS HC\Data\Oster\oster.dta"
keep x_country latest_hiv 
egen tag = tag(x_country)
keep if tag == 1
drop tag
sort x_country
save oster_temp1.dta, replace

clear
use "C:\Documents and Settings\jfortson\My Documents\Work\AIDS HC\Data\Oster\oster.dta"
keep x_country year x_hiv_national_oster
sort x_country year
save oster_temp2.dta, replace

use cleaned.dta
drop _merge
sort x_country 
merge x_country using oster_temp1.dta
gen ratio = x_hiv_local / latest_hiv
tab _merge
drop _merge

gen year = x_yob + 10
sort x_country year
merge x_country year using oster_temp2.dta
tab _merge
drop _merge

gen x_hiv_local_oster = ratio * x_hiv_national_oster

tab x_yob if x_hiv_local_oster != .

replace include = 0 
replace include = 1 if x_age >=15 & x_age<50

areg x_educ x_hiv_local_oster x_rural x_female x_yobdummies_* [pw=new_weight] if include == 1, cluster(x_cluster) absorb(x_fe)
outreg x_hiv_local_oster x_rural x_female using "${filepath}table3.out", $options append

tab x_yob if include == 1 & x_hiv_local_oster ! = .
tab x_country if include == 1 & x_hiv_local_oster != .
tab x_fe if include == 1 & x_hiv_local_oster != .

erase oster_temp1.dta
erase oster_temp2.dta

* UNAIDS

clear 
use "C:\Documents and Settings\jfortson\My Documents\Work\AIDS HC\Data\UNAIDS\unaids.dta"

gen temp = 1
replace temp = 2 if x_country == 15 & year == 2001
expand temp
drop temp

replace year = 2001.5 if _n == _N
replace x_hiv_national_unaids = 15.3 if _n == _N
replace x_country = 15 if _n == _N

rename year x_hivsurveyyear
sort x_country x_hivsurveyyear

save unaids_temp1.dta, replace

clear
use "C:\Documents and Settings\jfortson\My Documents\Work\AIDS HC\Data\UNAIDS\unaids.dta"
sort x_country year
save unaids_temp2.dta, replace

use cleaned.dta
cap drop _merge
sort x_country x_hivsurveyyear
merge x_country x_hivsurveyyear using unaids_temp1.dta
tab _merge

drop if _merge == 2
rename x_hiv_national_unaids matched_hiv
gen ratio = x_hiv_local / matched_hiv
drop _merge

gen year = x_yob + 10
sort x_country year
merge x_country year using unaids_temp2.dta
tab _merge
drop if _merge == 2
drop _merge

gen x_hiv_local_unaids = ratio * x_hiv_national_unaids

replace include = 0 
replace include = 1 if x_age >=15 & x_age<50

areg x_educ x_hiv_local_unaids x_rural x_female x_yobdummies_* [pw=new_weight] if include == 1, cluster(x_cluster) absorb(x_fe)
outreg x_hiv_local_unaids x_rural x_female using "${filepath}table3.out", $options append

tab x_yob if include == 1 & x_hiv_local_unaids ! = .
tab x_country if include == 1 & x_hiv_local_unaids != .
tab x_fe if include == 1 & x_hiv_local_unaids != .

erase unaids_temp1.dta
erase unaids_temp2.dta

}

** TABLE IV: ROBUSTNESS CHECK: DIFFERENCES PRIOR TO AFFECTED TIME PERIOD

if `table4' == 1 {

replace include = 0
replace include = 1 if x_age >= 15 & x_age<50 & x_yob <=1979

capture drop x_hiv_interact*

gen temp = 1 if x_yob >= 1970 & x_yob != .
replace temp = 0 if x_yob < 1970

gen x_hiv_interact = x_hiv_local * temp

areg x_educ x_hiv_interact x_rural x_female x_yobdummies_* [pw=new_weight] if include == 1, cluster(x_cluster) absorb(x_fe)
outreg x_hiv_interact x_rural x_female using "${filepath}table4", $options 
areg x_educ_positive x_hiv_interact x_rural x_female x_yobdummies_* [pw=new_weight] if include == 1, cluster(x_cluster) absorb(x_fe)
outreg x_hiv_interact x_rural x_female using "${filepath}table4", $options append 
areg x_educ_primary x_hiv_interact x_rural x_female x_yobdummies_* [pw=new_weight] if include == 1, cluster(x_cluster) absorb(x_fe)
outreg x_hiv_interact x_rural x_female using "${filepath}table4", $options append 

}

** TABLE V: ROBUSTNESS CHECK: MIGRATION AND MORTALITY

if `table5' == 1 {

clear
use allwaves_merged.dta

tab wave, gen(wave_)

gen x_interact = x_post * x_hiv_compregion

cap gen include = .
replace include = 0
replace include = 1 if x_age>=15 & x_age<=25

areg x_educ x_interact x_rural x_female x_yobdummies_* wave_* [pw=new_weight] if include == 1, cluster(x_compfe) absorb(x_compfe)
outreg x_interact x_rural x_female using "${filepath}table5.out", $options

foreach outcome in x_educ_positive x_educ_primary {
  areg `outcome' x_interact x_rural x_female x_yobdummies_* wave_* [pw=new_weight] if include == 1, cluster(x_compfe) absorb(x_compfe)
  outreg x_interact x_rural x_female using "${filepath}table5.out", $options append
}

clear
use cleaned.dta

}

** TABLE VI: ORPHANHOOD AND CARETAKING REQUIREMENTS

if `table6' == 1 {

bysort x_country: tab x_age if x_momalive != .
* countries for which we have data through age 17: (x_ci == 1 | x_ls == 1 | x_mw == 1 | x_rw == 1 | x_tz == 1)

** Original Sample

replace include = 0 
replace include = 1 if x_age >= 7 & x_age<=14 & (x_momalive !=. & x_dadalive != .) 

areg x_behind new_hiv x_rural x_female x_yobdummies_* x_agedummies_* [pw=new_weight] if include == 1, cluster(x_cluster) absorb(x_fe)
outreg new_hiv x_rural x_female using "${filepath}table6.out", $options

** Only Both Parents Alive

replace include = 0
replace include = 1 if x_age >= 7 & x_age<=14 & x_momalive == 1 & x_dadalive == 1

areg x_behind new_hiv x_rural x_female x_yobdummies_* x_agedummies_* [pw=new_weight] if include == 1, cluster(x_cluster) absorb(x_fe)
outreg new_hiv x_rural x_female using "${filepath}table6.out", $options append

** Only Tested Households, Not Mali or Zambia

bysort v000 v001 shconces v002 shstruct: egen x_infection = total(x_hiv)
bysort v000 v001 shconces v002 shstruct: egen x_nonmissing = count(x_hiv)

tab v000 if x_infection != . & x_age >=7 & x_age <=14 
tab v000 if x_nonmissing != . & x_age >=7 & x_age <=14

gen x_hivweight_temp  = x_hivweight if x_hivweight != 0
bysort v000 v001: egen min_temp = min(x_hivweight_temp)
bysort v000 v001: egen max_temp = max(x_hivweight_temp)
gen x_clusterweight = min_temp * max_temp
drop x_hivweight_temp min_temp max_temp

replace x_infection = . if x_nonmissing == 0

foreach wave in BF4 CM4 CI5 ET4 GH4 GN4 KE4 LS4 MW4 NI5 RW4 SN4 TZ5 { 
  sum x_clusterweight if x_age>= 7 & x_age<=14 & x_momalive == 1 & x_dadalive == 1 & x_infection != . & x_ml != 1 & x_zm != 1 & v000 == "`wave'"
  replace x_clusterweight = x_clusterweight / r(mean) if v000 == "`wave'"
}

gen x_specialweight = .
foreach country in bf cm ci et gh gn ke ls mw ni rw sn tz {
  sum x_clusterweight if x_`country' == 1
  replace x_specialweight = (x_clusterweight) * (x_population / r(sum)) if x_`country' == 1
  sum x_specialweight if x_`country' == 1
  return list
}

replace include = 0
replace include = 1 if x_age >= 7 & x_age<=14 & x_momalive == 1 & x_dadalive == 1 & x_infection != . & x_ml != 1 & x_zm != 1

areg x_behind new_hiv x_rural x_female x_yobdummies_* x_agedummies_* [pw=x_specialweight] if include == 1, cluster(x_cluster) absorb(x_fe)
outreg new_hiv x_rural x_female using "${filepath}table6.out", $options append

** Only HIV-Negative Households, Not Mali or Zambia

replace include = 0
replace include = 1 if x_age >= 7 & x_age<=14 & x_momalive == 1 & x_dadalive == 1 & x_infection == 0 & x_ml != 1 & x_zm != 1

areg x_behind new_hiv x_rural x_female x_yobdummies_* x_agedummies_* [pw=x_specialweight] if include == 1, cluster(x_cluster) absorb(x_fe)
outreg new_hiv x_rural x_female using "${filepath}table6.out", $options append

}

** TABLE VII: SEX DIFFERENTIAL

if `table7' == 1 {

replace include = 0
replace include = 1 if x_age >= 15 & x_age<50 

gen x_male = 1 if x_female == 0
replace x_male = 0 if x_female == 1
gen x_differential = x_interact * x_male

areg x_educ x_differential x_interact x_rural x_yobdummies_* x_female [pw=new_weight] if include == 1, absorb(x_fe) cluster(x_cluster)
outreg x_differential x_interact x_rural x_female using "${filepath}table7.out", $options 

foreach outcome in x_educ_positive x_educ_primary {
  areg `outcome' x_differential x_interact x_rural x_yobdummies_* x_female [pw=new_weight] if include == 1, absorb(x_fe) cluster(x_cluster)
  outreg x_differential x_interact x_rural x_female using "${filepath}table7.out", $options append
}

}

** FIGURE 1: BAR GRAPH

if `figure1' == 1 {

gen educ_avg = .
forvalues i = 1/15 {
  forvalues j = 0/1 {
    sum x_educ [aw=new_weight] if x_age >=15 & x_age <=49 & x_country == `i' & x_post == `j'
    replace educ_avg = r(mean) if x_country == `i' & x_post == `j'
  }
}

capture drop tag 
egen tag = tag(x_country x_post)
keep if tag == 1
drop tag

keep x_country x_post educ_avg

reshape wide educ_avg, i(x_country) j(x_post)

label variable educ_avg0 "Pre-1980 Birth Cohorts"
label variable educ_avg1 "Post-1980 Birth Cohorts"

gen order = .
replace order = 6 if x_country == 1
replace order = 10 if x_country == 2
replace order = 9 if x_country == 3
replace order = 3 if x_country == 4
replace order = 7 if x_country == 5
replace order = 4 if x_country == 6
replace order = 11 if x_country == 7
replace order = 15 if x_country == 8
replace order = 13 if x_country == 9
replace order = 5 if x_country == 10
replace order = 2 if x_country == 11
replace order = 8 if x_country == 12
replace order = 1 if x_country == 13
replace order = 12 if x_country == 14
replace order = 14 if x_country == 15

#d ;
label define order 
1 "Senegal" 
2 "Niger" 
3 "Ethiopia"
4 "Guinea"
5 "Mali"
6 "Burkina Faso"
7 "Ghana"
8 "Rwanda"
9 "Cote d'Ivoire"
10 "Cameroon"
11 "Kenya"
12 "Tanzania"
13 "Malawi"
14 "Zambia"
15 "Lesotho"
;
#d cr
label values order order

#d ;
graph bar (asis) educ_avg0 educ_avg1, 
	over(order, label(angle(90))) 
	ytitle("Mean Completed Years of Schooling") 
	bar(1,color(gs6)) bar(2,color(12))
	graphregion(fcolor(white) icolor(white) ifcolor(white) lcolor(white))
      legend(ring(0) position(11) col(1) symxsize(5))
      graphregion(margin(b=24))
      ysize(3.8) xsize(6.7)
;
#d cr
save "${filepath}figure1.gph", replace
graph export "${filepath}figure1.wmf", replace
graph export "${filepath}figure1.eps", replace

clear
use cleaned.dta

}

** FIGURE 2: SCATTERPLOT

if `figure2' == 1 {

replace include = 0
replace include = 1 if x_age<=49 & x_age>=15

gen x_educ_pre = .
gen x_educ_post = .

foreach country in bf cm ci et gh gn ke ls mw ml ni rw sn tz zm {
  local i = 1
  qui sum x_region if x_`country'==1
  scalar temp = r(max)
  while `i' <= temp {
    qui sum x_educ [aw=x_hhweight] if x_yob < 1980 & include == 1 & x_`country'==1 & x_region == `i' 
    qui replace x_educ_pre = r(mean) if x_`country'==1 & x_region == `i' 
    qui sum x_educ [aw=x_hhweight] if x_yob >= 1980 & include == 1 & x_`country'==1 & x_region == `i' 
    qui replace x_educ_post = r(mean) if x_`country'==1 & x_region == `i' 
    local i = `i' + 1
  }
}

gen x_diff = x_educ_post - x_educ_pre

foreach country in bf cm ci et gh gn ke ls mw ml ni rw sn tz zm {
  gen x_diff_`country' = x_diff if x_`country' == 1
}

label var x_diff_bf "Burkina Faso"
label var x_diff_cm "Cameroon"
label var x_diff_ci "Cote d'Ivoire"
label var x_diff_et "Ethiopia"
label var x_diff_gh "Ghana"
label var x_diff_gn "Guinea"
label var x_diff_ke "Kenya"
label var x_diff_ls "Lesotho"
label var x_diff_mw "Malawi"
label var x_diff_ml "Mali"
label var x_diff_ni "Niger"
label var x_diff_rw "Rwanda"
label var x_diff_sn "Senegal"
label var x_diff_tz "Tanzania"
label var x_diff_zm "Zambia"

egen scatter_group = tag(x_country x_region)
bysort x_country x_region: egen x_regionweight = total(x_hhweight)

gen x_regressionweight = .
foreach country in bf cm ci et gh gn ke ls mw ml ni rw sn tz zm {
  sum x_regionweight if x_`country' == 1
  replace x_regressionweight = (x_regionweight) * (x_population / r(sum)) if x_`country' == 1
  sum x_regressionweight if x_`country' == 1
  return list
}

reg x_diff x_hiv_local if scatter_group == 1 [pw=x_regressionweight]
predict x_diff_line if scatter_group == 1

twoway scatter x_diff_bf x_diff_cm x_diff_ci x_diff_et x_diff_gh x_diff_gn x_diff_ke x_diff_ls x_diff_mw x_diff_ml x_diff_ni x_diff_rw x_diff_sn x_diff_tz x_diff_zm x_diff_line x_hiv_local if scatter_group == 1, msymbol(O O O O O O O O O O O O O O O i) connect(i i i i i i i i i i i i i i i l) ylabel(-3(1)3) mcolor(black black black black black black black black black black black black black black black black) lcolor(black black black black black black black black black black black black black black black black) xtitle("Regional HIV Prevalence (Survey Year)") ytitle("Mean Years of Schooling (Post-1980 Birth Cohorts)" "- Mean Years of Schooling (Pre-1980 Birth Cohorts)") saving("${filepath}figure2.gph", replace) graphregion(fcolor(white) icolor(white) ifcolor(white) lcolor(white)) ysize(3.8) xsize(6.7) ylabel(-4(1)4) legend(off) 

graph export "${filepath}figure2.eps", replace
graph export "${filepath}figure2.wmf", replace

twoway scatter x_diff_bf x_diff_cm x_diff_ci x_diff_et x_diff_gh x_diff_gn x_diff_ke x_diff_ls x_diff_mw x_diff_ml x_diff_ni x_diff_rw x_diff_sn x_diff_tz x_diff_zm x_diff_line x_hiv_local if scatter_group == 1, msymbol(O O O O O O O O O O O O O O O i) connect(i i i i i i i i i i i i i i i l) ylabel(-3(1)3) lcolor(black black black black black black black black black black black black black black black black) xtitle("Regional HIV Prevalence (Survey Year)") ytitle("Mean Years of Schooling (Post-1980 Birth Cohorts)" "- Mean Years of Schooling (Pre-1980 Birth Cohorts)") saving("${filepath}figure2forpres.gph", replace) graphregion(fcolor(white) icolor(white) ifcolor(white) lcolor(white)) ysize(3.8) xsize(6.7) ylabel(-4(1)4) legend(colfirst order(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15) position(2) ring(0) cols(3)) 

graph set eps fontface Helvetica

graph export "${filepath}figure2forpres.eps", replace

}

** FIGURE 3

if `figure3' == 1 {

gen cohort = 0 if x_yob >=1950 & x_yob <=1959
replace cohort = 1 if x_yob >=1960 & x_yob <=1969
replace cohort = 2 if x_yob >=1970 & x_yob <=1979

gen educ_avg = .
forvalues i = 1/15 {
  forvalues j = 0/2 {
    sum x_educ [aw=new_weight] if x_country == `i' & cohort == `j'
    replace educ_avg = r(mean) if x_country == `i' & cohort == `j'
  }
}

capture drop tag 
egen tag = tag(x_country cohort)
keep if tag == 1
drop tag

keep x_country cohort educ_avg

reshape wide educ_avg, i(x_country) j(cohort)

label variable educ_avg0 "1950-1959 Birth Cohorts"
label variable educ_avg1 "1960-1969 Birth Cohorts"
label variable educ_avg2 "1970-1979 Birth Cohorts"

gen order = .
replace order = 6 if x_country == 1
replace order = 10 if x_country == 2
replace order = 9 if x_country == 3
replace order = 3 if x_country == 4
replace order = 7 if x_country == 5
replace order = 4 if x_country == 6
replace order = 11 if x_country == 7
replace order = 15 if x_country == 8
replace order = 13 if x_country == 9
replace order = 5 if x_country == 10
replace order = 2 if x_country == 11
replace order = 8 if x_country == 12
replace order = 1 if x_country == 13
replace order = 12 if x_country == 14
replace order = 14 if x_country == 15

#d ;
label define order 
1 "Senegal" 
2 "Niger" 
3 "Ethiopia"
4 "Guinea"
5 "Mali"
6 "Burkina Faso"
7 "Ghana"
8 "Rwanda"
9 "Cote d'Ivoire"
10 "Cameroon"
11 "Kenya"
12 "Tanzania"
13 "Malawi"
14 "Zambia"
15 "Lesotho"
;
#d cr
label values order order

#d ;
graph bar (asis) educ_avg0 educ_avg1 educ_avg2, 
	over(order, label(angle(90))) 
	ytitle("Mean Completed Years of Schooling") 
	bar(1,color(gs10)) bar(2,color(gs6)) bar(3,color(12))
	graphregion(fcolor(white) icolor(white) ifcolor(white) lcolor(white))
      ysize(3.8) xsize(6.7)
      legend(ring(0) position(11) col(1) symxsize(5))
      graphregion(margin(b=24))
;
#d cr
save "${filepath}figure3.gph", replace 
graph set eps fontface Garamond
graph export "${filepath}figure3.wmf", replace
graph export "${filepath}figure3.eps", replace

clear
use cleaned.dta

}

** CALCULATIONS FOR TEXT

if `calculations' == 1 {

if `nocontrols' == 1 {

replace include = 0
replace include = 1 if x_age >= 15 & x_age<50

foreach outcome in x_educ x_educ_positive x_educ_primary {
  reg `outcome' x_interact x_hiv_local x_post [pw=new_weight] if include == 1, cluster(x_cluster) 
}

}

if `percentagechange' == 1 {

  * percentage change

  replace include = 0
  replace include = 1 if x_age >= 15 & x_age<50

  foreach outcome in x_educ x_educ_positive x_educ_primary {
    areg `outcome' x_interact x_rural x_female x_yobdummies_* [pw=new_weight] if include == 1, cluster(x_cluster) absorb(x_fe)
    predict `outcome'_predicted
    gen `outcome'_diff = `outcome'_predicted - _b[x_interact]*x_interact
    sum `outcome'_diff [aw=new_weight] if include == 1
    di _b[x_interact]*10/r(mean)
  }

  sum x_educ if include == 1 & x_post == 0 [aw=new_weight]
  sum x_educ if include == 1 & x_post == 1 [aw=new_weight]

}

if `topcode' == 1 {

  * percentage of adults 25-49 with more than 10 years of schooling

  tab x_educ if x_age>=25 & x_age<=49 [aw=new_weight]

  * topcoding education

  gen x_educ_temp = x_educ
  replace x_educ_temp = 10 if x_educ >= 10 & x_educ != .

  replace include = 0
  replace include = 1 if x_age >= 15 & x_age<50

  areg x_educ_temp x_interact x_rural x_female x_yobdummies_* [pw = new_weight] if include == 1, cluster(x_cluster) absorb(x_fe)

}

if `men' == 1 {

  * men are X percent more likely to attend school

  replace include = 0
  replace include = 1 if x_age >= 15 & x_age<50

  sum x_educ_positive [aw = new_weight] if x_female == 0 & include == 1
  sum x_educ_positive [aw = new_weight] if x_female == 1 & include == 1

  di (.6951211-.5466982)/.5466982
}

if `trends' == 1 {

  * was educ on the rise elsewhere?

  replace include = 0
  replace include = 1 if x_age >= 15 & x_age<50

  sum x_educ [aw = new_weight] if x_post == 0 & include == 1 & x_hiv_local < 2
  sum x_educ [aw = new_weight] if x_post == 1 & include == 1 & x_hiv_local < 2

  sum x_educ [aw = new_weight] if x_post == 0 & include == 1 & x_hiv_local < 4
  sum x_educ [aw = new_weight] if x_post == 1 & include == 1 & x_hiv_local < 4

  sum x_educ [aw = new_weight] if x_post == 0 & include == 1 & x_hiv_local > 10 & x_hiv_local != .
  sum x_educ [aw = new_weight] if x_post == 1 & include == 1 & x_hiv_local > 10 & x_hiv_local != .

  sum x_educ [aw = new_weight] if x_post == 0 & include == 1 & x_hiv_local > 6 & x_hiv_local != .
  sum x_educ [aw = new_weight] if x_post == 1 & include == 1 & x_hiv_local > 6 & x_hiv_local != .

}

if `orphans' == 1 {

* restrict sample to orphans

replace include = 0
replace include = 1 if x_age >= 7 & x_age<=14 & (x_momalive == 0 | x_dadalive == 0)

areg x_behind new_hiv x_rural x_female x_yobdummies_* x_agedummies_* [pw=new_weight] if include == 1, cluster(x_cluster) absorb(x_fe)

}

if `circumcision' == 1 {

drop _merge
sort x_country x_region
merge x_country x_region using circumcision.dta
tab _merge
drop _merge

egen tag = tag(x_country x_region)

cap drop temp
cap drop x_regionweight
bysort x_country x_region: egen temp = total(x_hhweight)

gen x_regionweight = .
forvalues i = 1/15 {
  sum temp if x_country == `i'
  replace x_regionweight = temp * (x_population / r(sum)) if x_country == `i'
  sum x_regionweight if x_country == `i'
  return list
}

reg x_hiv_local x_circum_regional if tag == 1 [pw=x_regionweight]

replace include = 0
replace include = 1 if x_age >= 15 & x_age<50 

gen circ = x_circum_regional
gen circ_interact = circ * x_post

areg x_interact circ_interact x_rural x_female x_yobdummies_* [pw=new_weight] if include == 1, cluster(x_cluster) absorb(x_fe)

tab x_fe, gen(x_regiondummies_)

foreach outcome in x_educ x_educ_positive x_educ_primary {
  ivreg `outcome' (x_interact = circ_interact) x_rural x_female x_yobdummies_* x_regiondummies_* [pw=new_weight] if include == 1, cluster(x_cluster) 
}

}

if `assets' == 1 {

clear
use allwaves_merged.dta

tab wave, gen(wave_)

cap gen include = .
replace include = 0
replace include = 1 if x_age>=15 & x_age<=49 

tab wave if x_surveyyear <= 1994 & include == 1

* we tag because otherwise we are double-counting households (if there is more than one adult)

replace shstruct = 0 if shstruct == .
replace shmenage = 0 if shmenage == .

egen hhld_tag = tag(wave v001 v002 shstruct shmenage)
egen newcluster=group(x_country x_compregion)

reg x_assets_fraction x_hiv_compregion [pw=new_weight] if hhld_tag == 1 & include == 1 & x_surveyyear <= 1994, cluster(newcluster)

clear
use cleaned.dta

}

if `changeingenderdiff' == 1 {


replace include = 0
replace include = 1 if x_age >= 15 & x_age<50 

gen x_male = 1 if x_female == 0
replace x_male = 0 if x_female == 1
gen x_differential = x_interact * x_male

areg x_educ_positive x_differential x_interact x_rural x_yobdummies_* x_female [pw=new_weight] if include == 1, absorb(x_fe) cluster(x_cluster)

replace include = 0
replace include = 1 if x_age >= 7 & x_age<=14

gen x_differential2 = new_hiv * x_male

areg x_educ_positive x_differential2 new_hiv x_rural x_yobdummies_* x_female [pw=new_weight] if include == 1, absorb(x_fe) cluster(x_cluster)

}

if `nonresponse' == 1 {

clear 
use cleaned.dta

replace x_region = 8 if x_region == 12 & x_et == 1
replace x_region = 9 if x_region == 13 & x_et == 1
replace x_region = 10 if x_region == 14 & x_et == 1
replace x_region = 11 if x_region == 15 & x_et == 1

replace include = 0
replace include = 1 if x_age >=15 & x_age <=49 & x_ml != 1 & x_zm != 1

gen x_result = 1 if x_hiv != .
replace x_result = 0 if x_hiv == .

* run probit

gen predicted_result_prob = .
foreach country in bf cm ci et gh gn ke ls mw ni rw sn tz {
  local i = 1
  sum x_region if x_`country' == 1
  scalar temp_max = r(max)
  while `i' <= temp_max {
    capture drop temp
    probit x_result x_female x_rural x_educ x_age_1-x_age_7 [pw=x_hhweight] if include == 1 & x_`country' == 1 & x_region == `i'
    predict temp if x_`country' == 1 & x_region == `i' & include == 1
    replace predicted_result_prob = temp if x_`country' == 1 & x_region == `i' & include == 1
    local i = `i'+1
  }
}

gen x_hivweight_nr = x_hivweight / predicted_result_prob

gen x_hiv_local_nr = .
foreach country in bf cm ci et gh gn ke ls mw ni rw sn tz {
  local i = 1
  sum x_region if x_`country' == 1
  scalar temp_max_2 = r(max)
  while `i' <= temp_max_2 {
    di "`i'"
    sum x_hiv [aw=x_hivweight_nr] if include == 1 & x_`country' == 1 & x_region == `i'
    replace x_hiv_local_nr = r(mean)*100 if x_`country' == 1 & x_region == `i'
    local i = `i'+1
    di "`i'"
  }
}

replace x_hiv_local_nr = x_hiv_local if x_ml == 1 | x_zm == 1
gen x_interact_nr = x_hiv_local_nr * x_post


replace include = 0
replace include = 1 if x_age>=15 & x_age<50 

foreach outcome in x_educ x_educ_positive x_educ_primary {
  areg `outcome' x_interact_nr x_rural x_female x_yobdummies_* [pw=new_weight] if include == 1, cluster(x_cluster) absorb(x_fe)
}

clear
use cleaned.dta

}

if `migration' == 1 {

rename vidx v003
rename shconces smconces
rename shstruct smstruct
cap drop _merge
sort v000 v001 v002 v003 smconces smstruct 
merge v000 v001 v002 v003 smconces smstruct using migration.dta
tab _merge

tab x_nomoves if x_age >=15 & x_age<=25 [aw=new_weight]
tab x_nomoves if x_age >=26 & x_age<=49 [aw=new_weight]

tab x_agemovedtocurrent if x_nomoves == 0 & x_age >= 15 & x_age<=25 [aw=new_weight]
tab x_agemovedtocurrent if x_nomoves == 0 & x_age >= 26 & x_age<=49 [aw=new_weight]

sum x_agemovedtocurrent if x_nomoves == 0 & x_age >= 15 & x_age<=25 [aw=new_weight], detail
sum x_agemovedtocurrent if x_nomoves == 0 & x_age >= 26 & x_age<=49 [aw=new_weight], detail

clear
use cleaned.dta

}


}

log close

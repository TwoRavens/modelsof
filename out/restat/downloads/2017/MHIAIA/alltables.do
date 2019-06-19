** Replication of all the tables in the paper

*************** Create table 1

use "$datatemp/birthplace_codes.dta", clear
sort Birthplace_code
save "$datatemp/birthplace_codes.dta", replace


use "$datatemp/women_age_census_1979_all_urb.dta", clear
sort Birthplace_code
merge (Birthplace_code) using "$datatemp/birthplace_codes.dta"
keep if _merge==3
drop _merge
collapse (sum) women_num women_urb_num women_rur_num numbirth, by(loc age_num)

*** Row: 15 to 44 among women
summarize women_num if age_num>=15 & age_num<=44 & loc==1
scalar define loc1_1 = `r(sum)'
summarize women_num if loc==1
scalar define loc1_2 = `r(sum)'
scalar define loc1_3 = loc1_1*100/loc1_2
* Displays share of 15 to 44 among women of all ages in early beneficiaries
di loc1_3

summarize women_num if age_num>=15 & age_num<=44 & loc==2
scalar define loc2_1 = `r(sum)'
summarize women_num if loc==2
scalar define loc2_2 = `r(sum)'
scalar define loc2_3 = loc2_1*100/loc2_2
* Displays share of 15 to 44 among women of all ages in late beneficiaries
di loc2_3

*** Row: in rural areas among women ages 15 to 44
summarize women_rur_num if age_num>=15 & age_num<=44 & loc==1
scalar define loc1_1 = `r(sum)'
summarize women_num if age_num>=15 & age_num<=44 & loc==1
scalar define loc1_2 = `r(sum)'
scalar define loc1_3 = loc1_1*100/loc1_2
* Displays share in rural areas among women ages 15 to 44 in early beneficiaries
di loc1_3

summarize women_rur_num if age_num>=15 & age_num<=44 & loc==2
scalar define loc2_1 = `r(sum)'
summarize women_num if age_num>=15 & age_num<=44 & loc==2
scalar define loc2_2 = `r(sum)'
scalar define loc2_3 = loc2_1*100/loc2_2
* Displays share in rural areas among women ages 15 to 44 late beneficiaries
di loc2_3

*** Row: 65 years and older among women
summarize women_num if age_num>=65 & loc==1
scalar define loc1_1 = `r(sum)'
summarize women_num if loc==1
scalar define loc1_2 = `r(sum)'
scalar define loc1_3 = loc1_1*100/loc1_2
* Displays share 65 years and older among women in early beneficiaries
di loc1_3

summarize women_num if age_num>=65 & loc==2
scalar define loc2_1 = `r(sum)'
summarize women_num if loc==2
scalar define loc2_2 = `r(sum)'
scalar define loc2_3 = loc2_1*100/loc2_2
* Displays share 65 years and older among women in late beneficiaries
di loc2_3

*** Row: Share population living in oblasts
sum numbirth if loc==1
scalar define loc1_1 = `r(sum)'
sum numbirth if loc==2
scalar define loc2_1 = `r(sum)'
scalar define loc1_2 = loc1_1/(loc1_1+loc2_1)
* Displays for early beneficiaries
di loc1_2
scalar define loc2_2 = loc2_1/(loc1_1+loc2_1)
* Displays for late beneficiaries
di loc2_2

use "$datatemp/rosstat_allvars.dta", clear
keep if Year==1980
collapse (sum) numbir numwomen_1544, by(loc Year)
gen gfr_official = numbir*1000/numwomen_1544
keep gfr_official Year loc

*** Row: General Fertility Rate in 1980
sum gfr_official if loc==1
scalar define loc1_1 = `r(sum)'
* Displays for early beneficiaries
di `r(sum)'
sum gfr_official if loc==2
* Displays for late beneficiaries
di `r(sum)'

use "$datatemp/gfr_adjusted.dta", clear
*** Row: Higher parity fertility rate in 1980
sum gfr_2nd_adj if Year==1980 & loc==1 [w=numwomen_1544] 
scalar define loc1_1 = `r(mean)'
* Displays for early beneficiaries
di loc1_1
sum gfr_2nd_adj if Year==1980 & loc==2 [w=numwomen_1544] 
scalar define loc2_1 = `r(mean)'
* Displays for late beneficiaries
di loc2_1

import excel using "$data/educ1979_oblast.xlsx", clear firstrow sheet("Sheet2") cellrange(B4:J92)
drop vysshee_srednee
sort Birthplace_code
merge (Birthplace_code) using "$datatemp/birthplace_codes.dta"
keep if _merge==3
drop _merge
gen college = vysshee
gen lths = nepolnoesrednee+nachalnoe
gen total_ind = vysshee+nezakonchennoevysshee+sredneespetsialnoe+sredneeobshee+nepolnoesrednee+nachalnoe
collapse (sum) college lths total_ind, by(loc)
gen college_per = college*100/total_ind
gen lths_per = lths*100/total_ind

*** Row: with college degree among employed
sum college_per if loc==1
scalar define loc1_1 = `r(mean)'
* Displays for early beneficiares
di loc1_1
sum college_per if loc==2
scalar define loc2_1 = `r(mean)'
* Displays for late beneficiaries
di loc2_1

*** Row: with less than high school among employed
sum lths_per if loc==1
scalar define loc1_1 = `r(mean)'
* Displays for early beneficiares
di loc1_1
sum lths_per if loc==2
scalar define loc2_1 = `r(mean)'
* Displays for late beneficiaries
di loc2_1

* Import preschool data
import excel using "$data/preschool_79.xlsx", clear firstrow sheet("Sheet1") cellrange(A3:D76)
sort Birthplace_code
save "$datatemp/preschool_79.dta", replace
* Create number of children younger than 7
use "$datatemp/women_age_census_1979_all_urb.dta", clear
sort Birthplace_code
merge (Birthplace_code) using "$datatemp/birthplace_codes.dta"
keep if _merge==3
drop _merge
keep Birthplace_code age_num numbirth
keep if age_num<=6 & age_num>=0
collapse (sum) numbirth, by(Birthplace_code)
sort Birthplace_code
merge (Birthplace_code) using "$datatemp/preschool_79.dta"
keep if _merge==3
drop _merge
* Create number of children in nurseries (Jasli) and kindergardens (Detsad); numbers given in thousands
gen preschool = (Jasli_79+Detsad_79)*1000 
collapse (sum) preschool numbirth, by(loc)
gen preschool_per = preschool*100/numbirth

*** Row: in preschool among children younger than 7
sum preschool_per if loc==1
scalar define loc1_1 = `r(mean)'
* Displays for early beneficiares
di loc1_1
sum preschool_per if loc==2
scalar define loc2_1 = `r(mean)'
* Displays for late beneficiaries
di loc2_1

* Import employment of women data
import excel using "$data/employment_women79.xlsx", clear firstrow sheet("Sheet1") cellrange(A5:D93)

*** Row: employed among women ages 15 to 54
sum Employed_wom if loc==1
scalar define loc1_1 = `r(sum)'
sum workage_wom if loc==1
scalar define loc1_2 = `r(sum)'
scalar define loc1_3 = loc1_1*100/loc1_2
* Displays for early beneficiaries
di loc1_3

sum Employed_wom if loc==2
scalar define loc2_1 = `r(sum)'
sum workage_wom if loc==2
scalar define loc2_2 = `r(sum)'
scalar define loc2_3 = loc2_1*100/loc2_2
* Displays for late beneficiaries
di loc2_3

************** Create table 2 
set more off 
import excel using "$data/wage80.xlsx", clear firstrow sheet("Sheet1") cellrange(A1:C82)
sort Birthplace_code
save "$datatemp/wage80.dta", replace

* Creates columns (1) to (2) in table 2
use "$datatemp/rosstat_allvars.dta", clear
gen numwom1 = numwomen_1544 if Year==1979
bysort Birthplace_code: egen numwomen_79=max(numwom1)

gen pre = (Year>=1974 & Year<=1979)
gen post1 = (Year==1981)
gen post2 = (Year==1982)
gen post3 = (Year>=1983 & Year<=1986)
gen treat = (loc==1)
gen pre_treat = pre*treat
gen post1_treat = post1*treat
gen post2_treat = post2*treat
gen post3_treat = post3*treat


set more off
local r replace
local X1 "pre_treat post1_treat post2_treat post3_treat pre post1 post2 post3 _IBirthplac*"
local X2 "`X1' concrete brick meat timber canned trade"
xi i.Birthplace_code
forvalues i=1/2 {
regress gfr_official `X`i'' if Year>=1975 & Year<=1986 [w=numwomen_79], vce(cluster Birthplace_code)
sum gfr_official [w=numwomen_79] if e(sample) & Year==1980 & treat==1
outreg2 using "$output/table2_cols1to2.xls", `r' addstat(Dep var mean, r(mean), Num oblasts, e(N_clust)) addtext(Name, "`var'") bracket noaster ctitle(`e(cmdline)')
local r append
}


* Create column (3) in table 2
set more off
use "$datatemp/rosstat_allvars.dta", clear
sort Birthplace_code
merge (Birthplace_code) using "$datatemp/wage80.dta"
keep if _merge==3
gen numwom1 = numwomen_1544 if Year==1979
bysort Birthplace_code: egen numwomen_79=max(numwom1)
gen wage_fem80 = ((wage80*2)/1.7)*0.7
gen wage_repl80=(6.25+50)*100/wage_fem80 if loc==1
replace wage_repl80=(35+6.25)*100/wage_fem80 if loc==2
** Indicator for oblasts where only have wage for 1980
gen only80= (Birthplace_code==130 | Birthplace_code==720 | Birthplace_code==740)

** Short-Run Analysis
gen treat = (loc==1)
gen treat_wage80=treat*wage_repl80
gen treat_wage = treat*wage_repl
char Year[omit] 1980
xi i.Year*treat_wage80 i.Birthplace_code
regress gfr_official _IYeaXtre* _IYear* wage_repl80 _IBirthplac* concrete brick meat timber canned trade if Year>=1974 & Year<=1986 [w=numwomen_79], vce(cluster Birthplace_code)

gen year0 = (Year>=1975 & Year<=1979)
gen year1 = (Year==1981)
gen year2 = (Year==1982)
gen year3 = (Year>=1983 & Year<=1986)

forvalues j=0/3 {
gen year`j'_tr_wage80 = year`j'*treat*wage_repl80
}
local r replace
xi i.Year i.Birthplace_code
regress gfr_official year0_tr_wage80 year1_tr_wage80 year2_tr_wage80 year3_tr_wage80 wage_repl80 _IYear* _IBirthplac* concrete brick meat timber canned trade if Year>=1975 & Year<=1986 [w=numwomen_79], vce(cluster Birthplace_code)
outreg2 using "$output/table2_col3.xls", `r' addstat(Num oblasts, e(N_clust)) addtext(Name, "`var'") bracket noaster ctitle(`e(cmdline)')

***************** Create table 3
use "$datatemp/gfr_adjusted.dta", clear
sort Birthplace Year
merge (Birthplace Year) using "$datatemp/covars_oblast.dta"
keep if _merge==3

gen pre = (Year>=1975 & Year<=1979)
gen post1 = (Year==1981)
gen post2 = (Year==1982)
gen post3 = (Year>=1983 & Year<=1986)
gen treat = (loc==1)
gen pre_treat = pre*treat
gen post1_treat = post1*treat
gen post2_treat = post2*treat
gen post3_treat = post3*treat
set more off
set matsize 5000
local r replace
local X "pre_treat post1_treat post2_treat post3_treat pre post1 post2 post3 _IBirthplac* _IBirthmon* _IBirXBir* concrete brick meat timber canned trade"
xi i.Birthmonth*i.Birthplace_code

regress gfr_2nd_adj `X' if Year>=1975 & Year<=1986 [w=numwomen_79], vce(cluster Birthplace_code)
sum gfr_2nd_adj [w=numwomen_79] if e(sample) & Year==1980 & treat==1
outreg2 using "$output/table3.xls", `r' addstat(Dep var mean, r(mean), Num oblasts, e(N_clust)) addtext(Name, "`var'") bracket noaster ctitle(`e(cmdline)')

local r append
regress gfr_1st_adj `X' if Year>=1975 & Year<=1986 [w=numwomen_79], vce(cluster Birthplace_code)
sum gfr_1st_adj [w=numwomen_79] if e(sample) & Year==1980 & treat==1
outreg2 using "$output/table3.xls", `r' addstat(Dep var mean, r(mean), Num oblasts, e(N_clust)) addtext(Name, "`var'") bracket noaster ctitle(`e(cmdline)')

***************** Create table 4
*** See code for it in table4.do
*** This do-file uses data that cannot be publicly accessed. 

***************** Create Table 5 
* Create column (1) in the paper
use "$datatemp/rosstat_allvars.dta", clear
gen numwom1 = numwomen_1544 if Year==1979
bysort Birthplace_code: egen numwomen_79=max(numwom1)

gen treat = (loc==1)
gen year_treat = 1980 if treat==1
replace year_treat = 1981 if treat==0
gen Texp = Year-year_treat

gen Texp_group = 1 if Texp==-6
replace Texp_group = 2 if (Texp<0 & Texp>=-5)
replace Texp_group = 3 if Texp==1
replace Texp_group = 4 if (Texp>=2 & Texp<=4)
replace Texp_group = 5 if (Texp>=5 & Texp<=7)
replace Texp_group = 6 if (Texp>=8 & Texp<=10)
replace Texp_group = 7 if Texp==11
replace Texp_group = 0 if Texp==0

set more off
local r replace
char Texp_group [omit]0
xi i.Texp_group i.Year i.Birthplace_code
local X1 "_ITexp* _IYear* _IBirthplac* meat canned trade"
forvalues i=1/1 {
regress gfr_official `X`i'' if Year>=1975 & Year<=1992 [w=numwomen_79], vce(cluster Birthplace_code)
sum gfr_official [w=numwomen_79] if e(sample) & Texp==0
outreg2 using "$output/table5_col1.xls", `r' addstat(Dep var mean, r(mean), Num oblasts, e(N_clust)) addtext(Name, "`var'") bracket noaster ctitle(`e(cmdline)')
local r append
}

* Create column (2) in the paper
set more off
use "$datatemp/gfr_adjusted.dta", clear
sort Birthplace Year
merge (Birthplace Year) using "$datatemp/covars_oblast.dta"
keep if _merge==3

gen year_treat = 1980 if loc==1
replace year_treat = 1981 if loc==2
gen Texp = Year-year_treat
gen Texp_group = 1 if Texp==-6
replace Texp_group = 2 if (Texp<0 & Texp>=-5)
replace Texp_group = 3 if Texp==1
replace Texp_group = 4 if (Texp>=2 & Texp<=4)
replace Texp_group = 5 if (Texp>=5 & Texp<=7)
replace Texp_group = 6 if (Texp>=8 & Texp<=10)
replace Texp_group = 7 if Texp==11
replace Texp_group = 0 if Texp==0

char Texp_group [omit] 0
xi i.Year i.Texp_group i.Birthplace_code i.Birthmonth*i.Birthplace_code
local r replace
local X "_ITexp* _IYear* _IBirthmon* _IBirthplac* _IBirXBir* meat canned trade"
regress gfr_2nd_adj `X' if Year>=1975 & Year<=1992 [w=numwomen_79], vce(cluster Birthplace_code)
sum gfr_2nd_adj [w=numwomen_79] if e(sample) & Texp==0
outreg2 using "$output/table5_col2.xls", `r' addstat(Dep var mean, r(mean), Num oblasts, e(N_clust)) addtext(Name, "`var'") bracket noaster ctitle(`e(cmdline)')

************** Create table 6

use "$datatemp/outcomes_2010_oblast.dta", clear
gen treat = 1 if loc==1
replace treat= 0 if loc==2
gen year81 = (Birthyear==1981)
gen year81_treat = year81*treat
gen year82 = (Birthyear==1982)
gen year82_treat = year82*treat

local r replace
xi i.Birthyear i.Birthplace_code*Birthyear 
set more off

foreach var of varlist college_more_per educ_yrs empl_man_per empl_wom_per posob10_per married_per teen_mom numkid_ave {
regress `var' year81_treat year82_treat _IBirthyear* _IBirthplac* _IBirXBir* if Birthyear>=1976 & Birthyear<=1982 [aw=educ_denom], vce(cluster Birthplace_code)
summ `var' if e(sample) & treat==1 & Birthyear==1979
outreg2 year81_treat year82_treat  using "$output/table6.xls", `r' addstat(Dep var mean, `r(mean)') bracket noaster title(`e(depvar)') ctitle(`e(cmdline)')
local r append
}

*************** Create table B1

set more off
use "$datatemp/rosstat_allvars.dta", clear
gen numwom1 = numwomen_1544 if Year==1979
bysort Birthplace_code: egen numwomen_79=max(numwom1)

gen treat = (loc==1)
gen year_treat = 1980 if treat==1
replace year_treat = 1981 if treat==0
gen Texp = Year-year_treat

gen Texp_group = 1 if Texp==-6
replace Texp_group = 2 if (Texp<0 & Texp>=-5)
replace Texp_group = 3 if Texp==1
replace Texp_group = 4 if (Texp>=2 & Texp<=4)
replace Texp_group = 5 if (Texp>=5 & Texp<=7)
replace Texp_group = 6 if (Texp>=8 & Texp<=10)
replace Texp_group = 7 if Texp==11
replace Texp_group = 0 if Texp==0

gen numwom_rur79=women_rur_79*100/(women_rur_79+women_urb_79)
local r replace
char Texp_group [omit]0
xi i.Texp_group*numwom_rur79 i.Year i.Birthplace_code
local X1 "_ITexXnumwo* _IYear* _IBirthplac* numwom_rur79"
local X2 "`X1' meat canned trade"
forvalues i=1/2 {
regress gfr_official `X`i'' if Year>=1975 & Year<=1992 [w=numwomen_79], vce(cluster Birthplace_code)
outreg2 _ITexXnumwo* using "$output/tableb1.xls", `r' addstat(Num oblasts, e(N_clust)) addtext(Name, "`var'") bracket noaster ctitle(`e(cmdline)')
local r append
}

gen lths_per = ( elem + hs_inc)*100/( elem+hs_inc+College+ College_inc +hs_spec+ hs_gen)
char Texp_group [omit]0
xi i.Texp_group*lths_per i.Year i.Birthplace_code
local X1 "_ITexXlths* _IYear* _IBirthplac* lths_per"
local X2 "`X1' meat canned trade"
local r append
forvalues i=1/2 {
regress gfr_official `X`i'' if Year>=1975 & Year<=1992 [w=numwomen_79], vce(cluster Birthplace_code)
outreg2 _ITexXlths* using "$output/tableb1.xls", `r' addstat(Num oblasts, e(N_clust)) addtext(Name, "`var'") bracket noaster ctitle(`e(cmdline)')
}


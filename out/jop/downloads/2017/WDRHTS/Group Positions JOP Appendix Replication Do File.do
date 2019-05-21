clear all
set more off

/// Combining Datasets
cd  "Analysis Files"
use "ANES_POST_FACTOR_1972.dta"
append using  "ANES_POST_FACTOR_1976.dta"
append using  "ANES_POST_FACTOR_1980.dta"
append using  "ANES_POST_FACTOR_1984.dta"
append using  "ANES_POST_FACTOR_1988.dta"
append using  "ANES_POST_FACTOR_1992.dta"
append using  "ANES_POST_FACTOR_1996.dta"
append using  "ANES_POST_FACTOR_2000.dta"
append using  "ANES_POST_FACTOR_2004.dta"
append using  "ANES_POST_FACTOR_2008.dta"
append using  "ANES_POST_FACTOR_2012.dta"

rename VCF0107 Hisp_origin_type
rename VCF0109 Ethnicity
rename VCF0111 Urbanism
rename VCF0128a Religion_7cat
rename VCF0128b Religion_8cat
rename VCF0303 PID_fsum
rename VCF0704 presvote_major





keep year vcf0010x age age_group age_cohort gender race_2cat race_3cat race_6cat Hisp_origin_type Hisp_origin Ethnicity Education_4cat dem_raceeth_x ///
Urbanism Census_region Political_South Income Union religion Religion_7cat Religion_8cat education_6cat education_7cat PID_7 PID_fsum presvote_major weekly_church Pres_Vote F1_Adj F2_Adj

gen White=0
replace White=1 if race_6cat==1
replace White=1 if year==2012 & dem_raceeth_x==1
gen Female = 0
replace Female=1 if gender ==2
gen Latino =0 
replace Latino=1 if race_6cat==5
replace Latino=1 if year==2012 & dem_raceeth_x==3
gen Black =0 
replace Black=1 if race_6cat==2
replace Black=1 if year==2012 & dem_raceeth_x==2
gen nonwhite =0
replace nonwhite = 1 if race_3cat==3 | race_3cat==2
replace nonwhite = 1 if year==2012 & dem_raceeth_x>=2
gen Asian = 0
replace Asian = 1 if race_6cat==3
replace Asian = 1 if year==2012 & dem_raceeth_x==4
gen demvote=0
replace demvote=1 if Pres_Vote == 1
gen DemID =0
replace DemID =1 if PID_fsum == 1
gen IncTopThird = 0
replace IncTopThird = 1 if Income == 5 | Income ==4
gen IncBottomThird = 0
replace IncBottomThird = 1 if Income == 1 | Income ==2
gen South = 0
replace South = 1 if Census_region == 3
gen white_southerner = 0
replace white_southerner = 1 if Census_region == 3 & race_3cat==1
replace white_southerner = 1 if year==2012 & dem_raceeth_x==1 & Census_region==3
gen collegegrad =0 
replace collegegrad = 1 if education_6cat==6
gen unionmember=0
replace unionmember =1 if Union==1
gen Jew = 0
replace Jew =1 if religion==3
gen Catholic =0
replace Catholic =1 if religion==2 & nonwhite==0
gen urban =0
replace urban=1 if Urbanism==1
gen rural=0
replace rural=1 if Urbanism==3
gen Boomers=0
replace Boomers=1 if age_cohort==4
gen GenX=0
replace GenX=1 if age_cohort==3
gen GenY=0
replace GenY=1 if age_cohort==2
gen weeklychurch=0
replace weeklychurch=1 if weekly_church==1
gen nonreligious=0
replace nonreligious=1 if religion==4
gen GreatestGen = 0 
replace GreatestGen=1 if age_cohort==6
gen Preboomers =0
replace Preboomers=1 if age_cohort==5
gen Protestant=0
replace Protestant=1 if religion==1 & nonwhite==0

sort year






save "ANES_POST_FACTOR_All_Years.dta", replace

/// African Americans

tempname blacks1
postfile `blacks1' N_F1_Adj mean_F1_Adj sd_F1_Adj median_F1_Adj W_N_F1_Adj using "Blacks1.dta", replace
local i = 1972
while `i' < 2013{
fsum F1_Adj  if Black==1 & year==`i' [aw=vcf0010x], stats(p50)
return list
post `blacks1' (`r(N)[F1_Adj]') (`r(mean)[F1_Adj]') (`r(sd)[F1_Adj]') (`r(p50)[F1_Adj]') (`r(sum_w)[F1_Adj]') 
local i = `i'+4 
}
postclose `blacks1' 

tempname blacks2
postfile `blacks2' N_F2_Adj mean_F2_Adj sd_F2_Adj median_F2_Adj W_N_F2_Adj  using "Blacks2.dta", replace 
local i = 1972
while `i' < 2013{
fsum F2_Adj  if Black==1 & year==`i' [aw=vcf0010x], stats(p50)
return list
post `blacks2' (`r(N)[F1_Adj]') (`r(mean)[F1_Adj]') (`r(sd)[F1_Adj]') (`r(p50)[F1_Adj]') (`r(sum_w)[F1_Adj]')
local i = `i'+4 
}
postclose `blacks2'

clear

use "Blacks1.dta"
merge using "Blacks2.dta"
label variable mean_F1_Adj "Black"
drop _merge N_F2_Adj 
egen year = fill(1972(4)2012) 
sort year
save "Blacks1.dta", replace

/// Southern Whites 

clear 
set more off

use "ANES_POST_FACTOR_All_Years.dta"

tempname Latino1
postfile `Latino1' N_F1_Adj mean_F1_Adj sd_F1_Adj median_F1_Adj W_N_F1_Adj using "Latino21.dta", replace
local i = 1972
while `i' <2013{
fsum F1_Adj  if Latino==1 &  year==`i' [aw=vcf0010x], stats(p50)
return list
post `Latino1' (`r(N)[F1_Adj]') (`r(mean)[F1_Adj]') (`r(sd)[F1_Adj]') (`r(p50)[F1_Adj]') (`r(sum_w)[F1_Adj]')
local i = `i'+4 
}
postclose `Latino1' 

tempname Latino2
postfile `Latino2' N_F2_Adj mean_F2_Adj sd_F2_Adj median_F2_Adj W_N_F2_Adj  using "Latino22.dta", replace
local i = 1972
while `i' <2013{
fsum F2_Adj  if Latino==1 & year==`i' [aw=vcf0010x], stats(p50)
return list
post `Latino2' (`r(N)[F1_Adj]') (`r(mean)[F1_Adj]') (`r(sd)[F1_Adj]') (`r(p50)[F1_Adj]') (`r(sum_w)[F1_Adj]')
local i = `i'+4 
}
postclose `Latino2'

clear

use "Latino21.dta"
merge using "Latino22.dta"
label variable mean_F1_Adj "Latino"
drop _merge N_F2_Adj 
egen year = fill(1972(4)2012) 
sort year
save "Latinos1.dta", replace



clear 
set more off

use "ANES_POST_FACTOR_All_Years.dta"

tempname Asian1
postfile `Asian1' N_F1_Adj mean_F1_Adj sd_F1_Adj median_F1_Adj W_N_F1_Adj using "Asian1.dta", replace
local i = 1972
while `i' <2013{
fsum F1_Adj  if Asian==1 & year==`i' [aw=vcf0010x], stats(p50)
return list
post `Asian1' (`r(N)[F1_Adj]') (`r(mean)[F1_Adj]') (`r(sd)[F1_Adj]') (`r(p50)[F1_Adj]') (`r(sum_w)[F1_Adj]')
local i = `i'+4 
}
postclose `Asian1' 

tempname Asian2
postfile `Asian2' N_F2_Adj mean_F2_Adj sd_F2_Adj median_F2_Adj W_N_F2_Adj  using "Asian2.dta", replace
local i = 1972
while `i' <2013{
fsum F2_Adj  if Asian==1 & year==`i' [aw=vcf0010x], stats(p50)
return list
post `Asian2' (`r(N)[F1_Adj]') (`r(mean)[F1_Adj]') (`r(sd)[F1_Adj]') (`r(p50)[F1_Adj]') (`r(sum_w)[F1_Adj]')
local i = `i'+4 
}
postclose `Asian2'

clear

use "Asian1.dta"
merge using "Asian2.dta"
label variable mean_F1_Adj "Asian"
drop _merge N_F2_Adj 
egen year = fill(1972(4)2012)
sort year 
save "Asian1.dta", replace



clear 
set more off

use "ANES_POST_FACTOR_All_Years.dta"

tempname Female1
postfile `Female1' N_F1_Adj mean_F1_Adj sd_F1_Adj median_F1_Adj W_N_F1_Adj using "Female1.dta", replace
local i = 1972
while `i' <2013{
fsum F1_Adj  if Female==1 & year==`i' [aw=vcf0010x], stats(p50)
return list
post `Female1' (`r(N)[F1_Adj]') (`r(mean)[F1_Adj]') (`r(sd)[F1_Adj]') (`r(p50)[F1_Adj]') (`r(sum_w)[F1_Adj]')
local i = `i'+4 
}
postclose `Female1' 

tempname Female2
postfile `Female2' N_F2_Adj mean_F2_Adj sd_F2_Adj median_F2_Adj W_N_F2_Adj  using "Female2.dta", replace
local i = 1972
while `i' <2013{
fsum F2_Adj  if Female==1 & year==`i' [aw=vcf0010x], stats(p50)
return list
post `Female2' (`r(N)[F1_Adj]') (`r(mean)[F1_Adj]') (`r(sd)[F1_Adj]') (`r(p50)[F1_Adj]') (`r(sum_w)[F1_Adj]')
local i = `i'+4 
}
postclose `Female2'

clear

use "Female1.dta"
merge using "Female2.dta"


label variable mean_F1_Adj "Female"
drop _merge N_F2_Adj
egen year = fill(1972(4)2012) 
sort year 
save "Female1.dta", replace



clear 
set more off

use "ANES_POST_FACTOR_All_Years.dta"

tempname IncTopThird1
postfile `IncTopThird1' N_F1_Adj mean_F1_Adj sd_F1_Adj median_F1_Adj W_N_F1_Adj using "IncTopThird1.dta", replace
local i = 1972
while `i' <2013{
fsum F1_Adj  if IncTopThird==1 & year==`i' [aw=vcf0010x], stats(p50)
return list
post `IncTopThird1' (`r(N)[F1_Adj]') (`r(mean)[F1_Adj]') (`r(sd)[F1_Adj]') (`r(p50)[F1_Adj]') (`r(sum_w)[F1_Adj]')
local i = `i'+4 
}
postclose `IncTopThird1' 

tempname IncTopThird2
postfile `IncTopThird2' N_F2_Adj mean_F2_Adj sd_F2_Adj median_F2_Adj W_N_F2_Adj  using "IncTopThird2.dta", replace
local i = 1972
while `i' <2013{
fsum F2_Adj  if IncTopThird==1 & year==`i' [aw=vcf0010x], stats(p50)
return list
post `IncTopThird2' (`r(N)[F1_Adj]') (`r(mean)[F1_Adj]') (`r(sd)[F1_Adj]') (`r(p50)[F1_Adj]') (`r(sum_w)[F1_Adj]')
local i = `i'+4 
}
postclose `IncTopThird2'

clear

use "IncTopThird1.dta"
merge using "IncTopThird2.dta"
label variable mean_F1_Adj "Inc Top 1/3"
drop _merge N_F2_Adj 
egen year = fill(1972(4)2012)
sort year 
save "IncTopThird1.dta", replace



clear 
set more off

use "ANES_POST_FACTOR_All_Years.dta"

tempname IncBottomThird1
postfile `IncBottomThird1' N_F1_Adj mean_F1_Adj sd_F1_Adj median_F1_Adj W_N_F1_Adj using "IncBottomThird1.dta", replace
local i = 1972
while `i' <2013{
fsum F1_Adj  if IncBottomThird==1 & year==`i' [aw=vcf0010x], stats(p50)
return list
post `IncBottomThird1' (`r(N)[F1_Adj]') (`r(mean)[F1_Adj]') (`r(sd)[F1_Adj]') (`r(p50)[F1_Adj]') (`r(sum_w)[F1_Adj]')
local i = `i'+4 
}
postclose `IncBottomThird1' 

tempname IncBottomThird2
postfile `IncBottomThird2' N_F2_Adj mean_F2_Adj sd_F2_Adj median_F2_Adj W_N_F2_Adj  using "IncBottomThird2.dta", replace
local i = 1972
while `i' <2013{
fsum F2_Adj  if IncBottomThird==1 & year==`i' [aw=vcf0010x], stats(p50)
return list
post `IncBottomThird2' (`r(N)[F1_Adj]') (`r(mean)[F1_Adj]') (`r(sd)[F1_Adj]') (`r(p50)[F1_Adj]') (`r(sum_w)[F1_Adj]')
local i = `i'+4 
}
postclose `IncBottomThird2'

clear

use "IncBottomThird1.dta"
merge using "IncBottomThird2.dta"
label variable mean_F1_Adj "Inc Bottom 1/3"
drop _merge N_F2_Adj 
egen year = fill(1972(4)2012)
sort year 
save "IncBottomThird1.dta", replace



clear 
set more off

use "ANES_POST_FACTOR_All_Years.dta"

tempname SW1
postfile `SW1' N_F1_Adj mean_F1_Adj sd_F1_Adj median_F1_Adj W_N_F1_Adj using "SW1.dta", replace
local i = 1972
while `i' <2013{
fsum F1_Adj  if white==1 & Political_South==1 & year==`i' [aw=vcf0010x], stats(p50)
return list
post `SW1' (`r(N)[F1_Adj]') (`r(mean)[F1_Adj]') (`r(sd)[F1_Adj]') (`r(p50)[F1_Adj]') (`r(sum_w)[F1_Adj]')
local i = `i'+4 
}
postclose `SW1' 

tempname SW2
postfile `SW2' N_F2_Adj mean_F2_Adj sd_F2_Adj median_F2_Adj W_N_F2_Adj  using "SW2.dta", replace
local i = 1972
while `i' <2013{
fsum F2_Adj  if white==1 & Political_South==1 & year==`i' [aw=vcf0010x], stats(p50)
return list
post `SW2' (`r(N)[F1_Adj]') (`r(mean)[F1_Adj]') (`r(sd)[F1_Adj]') (`r(p50)[F1_Adj]') (`r(sum_w)[F1_Adj]')
local i = `i'+4 
}
postclose `SW2'

clear

use "SW1.dta"
merge using "SW2.dta"

label variable mean_F1_Adj "Southern Whites"
drop _merge N_F2_Adj 
egen year = fill(1972(4)2012)
sort year 
save "SW1.dta", replace


clear 
set more off

use "ANES_POST_FACTOR_All_Years.dta"

tempname collegegrad1
postfile `collegegrad1' N_F1_Adj mean_F1_Adj sd_F1_Adj median_F1_Adj W_N_F1_Adj using "collegegrad1.dta", replace
local i = 1972
while `i' <2013{
fsum F1_Adj  if collegegrad==1 & year==`i' [aw=vcf0010x], stats(p50)
return list
post `collegegrad1' (`r(N)[F1_Adj]') (`r(mean)[F1_Adj]') (`r(sd)[F1_Adj]') (`r(p50)[F1_Adj]') (`r(sum_w)[F1_Adj]')
local i = `i'+4 
}
postclose `collegegrad1' 

tempname collegegrad2
postfile `collegegrad2' N_F2_Adj mean_F2_Adj sd_F2_Adj median_F2_Adj W_N_F2_Adj  using "collegegrad2.dta", replace
local i = 1972
while `i' <2013{
fsum F2_Adj  if collegegrad==1 & year==`i' [aw=vcf0010x], stats(p50)
return list
post `collegegrad2' (`r(N)[F1_Adj]') (`r(mean)[F1_Adj]') (`r(sd)[F1_Adj]') (`r(p50)[F1_Adj]') (`r(sum_w)[F1_Adj]')
local i = `i'+4 
}
postclose `collegegrad2'

clear

use "collegegrad1.dta"
merge using "collegegrad2.dta"
label variable mean_F1_Adj "College Graduates"
drop _merge N_F2_Adj 
egen year = fill(1972(4)2012) 
sort year
save "collegegrad1.dta", replace




clear 
set more off
use "ANES_POST_FACTOR_All_Years.dta"

tempname unionmember1
postfile `unionmember1' N_F1_Adj mean_F1_Adj sd_F1_Adj median_F1_Adj W_N_F1_Adj using "unionmember1.dta", replace
local i = 1972
while `i' <2013{
fsum F1_Adj  if unionmember==1 & year==`i' [aw=vcf0010x], stats(p50)
return list
post `unionmember1' (`r(N)[F1_Adj]') (`r(mean)[F1_Adj]') (`r(sd)[F1_Adj]') (`r(p50)[F1_Adj]') (`r(sum_w)[F1_Adj]')
local i = `i'+4 
}
postclose `unionmember1' 

tempname unionmember2
postfile `unionmember2' N_F2_Adj mean_F2_Adj sd_F2_Adj median_F2_Adj W_N_F2_Adj  using "unionmember2.dta", replace
local i = 1972
while `i' <2013{
fsum F2_Adj  if unionmember==1 & year==`i' [aw=vcf0010x], stats(p50)
return list
post `unionmember2' (`r(N)[F1_Adj]') (`r(mean)[F1_Adj]') (`r(sd)[F1_Adj]') (`r(p50)[F1_Adj]') (`r(sum_w)[F1_Adj]')
local i = `i'+4 
}
postclose `unionmember2'

clear

use "unionmember1.dta"
merge using "unionmember2.dta"
label variable mean_F1_Adj "Union Member"
drop _merge N_F2_Adj 
egen year = fill(1972(4)2012) 
sort year
save "unionmember1.dta", replace



clear 
set more off

use "ANES_POST_FACTOR_All_Years.dta"

tempname Jew1
postfile `Jew1' N_F1_Adj mean_F1_Adj sd_F1_Adj median_F1_Adj W_N_F1_Adj using "Jew1.dta", replace
local i = 1972
while `i' <2013{
fsum F1_Adj  if Jew==1 & year==`i' [aw=vcf0010x], stats(p50)
return list
post `Jew1' (`r(N)[F1_Adj]') (`r(mean)[F1_Adj]') (`r(sd)[F1_Adj]') (`r(p50)[F1_Adj]') (`r(sum_w)[F1_Adj]')
local i = `i'+4 
}
postclose `Jew1' 

tempname Jew2
postfile `Jew2' N_F2_Adj mean_F2_Adj sd_F2_Adj median_F2_Adj W_N_F2_Adj  using "Jew2.dta", replace
local i = 1972
while `i' <2013{
fsum F2_Adj  if Jew==1 & year==`i' [aw=vcf0010x], stats(p50)
return list
post `Jew2' (`r(N)[F1_Adj]') (`r(mean)[F1_Adj]') (`r(sd)[F1_Adj]') (`r(p50)[F1_Adj]') (`r(sum_w)[F1_Adj]')
local i = `i'+4 
}
postclose `Jew2'

clear

use "Jew1.dta"
merge using "Jew2.dta"
label variable mean_F1_Adj "Jews"
drop _merge N_F2_Adj 
egen year = fill(1972(4)2012)
sort year 
save "Jew1.dta", replace



clear 
set more off

use "ANES_POST_FACTOR_All_Years.dta"

tempname Catholic1
postfile `Catholic1' N_F1_Adj mean_F1_Adj sd_F1_Adj median_F1_Adj W_N_F1_Adj using "Catholic1.dta", replace
local i = 1972
while `i' <2013{
fsum F1_Adj  if Catholic==1 & White==1 & year==`i' [aw=vcf0010x], stats(p50)
return list
post `Catholic1' (`r(N)[F1_Adj]') (`r(mean)[F1_Adj]') (`r(sd)[F1_Adj]') (`r(p50)[F1_Adj]') (`r(sum_w)[F1_Adj]')
local i = `i'+4 
}
postclose `Catholic1' 

tempname Catholic2
postfile `Catholic2' N_F2_Adj mean_F2_Adj sd_F2_Adj median_F2_Adj W_N_F2_Adj  using "Catholic2.dta", replace
local i = 1972
while `i' <2013{
fsum F2_Adj  if Catholic==1 & White==1 & year==`i' [aw=vcf0010x], stats(p50)
return list
post `Catholic2' (`r(N)[F1_Adj]') (`r(mean)[F1_Adj]') (`r(sd)[F1_Adj]') (`r(p50)[F1_Adj]') (`r(sum_w)[F1_Adj]')
local i = `i'+4 
}
postclose `Catholic2'

clear

use "Catholic1.dta"
merge using "Catholic2.dta"

label variable mean_F1_Adj "Catholic"
drop _merge N_F2_Adj 
egen year = fill(1972(4)2012)
sort year 
save "Catholic1.dta", replace


clear 
set more off

use "ANES_POST_FACTOR_All_Years.dta"

tempname weeklychurch1
postfile `weeklychurch1' N_F1_Adj mean_F1_Adj sd_F1_Adj median_F1_Adj W_N_F1_Adj using "weeklychurch1.dta", replace
local i = 1972
while `i' <2013{
fsum F1_Adj  if weeklychurch==1 & year==`i' [aw=vcf0010x], stats(p50)
return list
post `weeklychurch1' (`r(N)[F1_Adj]') (`r(mean)[F1_Adj]') (`r(sd)[F1_Adj]') (`r(p50)[F1_Adj]') (`r(sum_w)[F1_Adj]')
local i = `i'+4 
}
postclose `weeklychurch1' 

tempname weeklychurch2
postfile `weeklychurch2' N_F2_Adj mean_F2_Adj sd_F2_Adj median_F2_Adj W_N_F2_Adj  using "weeklychurch2.dta", replace
local i = 1972
while `i' <2013{
fsum F2_Adj  if weeklychurch==1 & year==`i' [aw=vcf0010x], stats(p50)
return list
post `weeklychurch2' (`r(N)[F1_Adj]') (`r(mean)[F1_Adj]') (`r(sd)[F1_Adj]') (`r(p50)[F1_Adj]') (`r(sum_w)[F1_Adj]')
local i = `i'+4 
}
postclose `weeklychurch2'

clear

use "weeklychurch1.dta"
merge using "weeklychurch2.dta"

label variable mean_F1_Adj "Weekly Church Attnd."
drop _merge N_F2_Adj 
egen year = fill(1972(4)2012)
sort year 
save "weeklychurch1.dta", replace



clear 
set more off

use "ANES_POST_FACTOR_All_Years.dta"

tempname nonreligious1
postfile `nonreligious1' N_F1_Adj mean_F1_Adj sd_F1_Adj median_F1_Adj W_N_F1_Adj using "nonreligious1.dta", replace
local i = 1972
while `i' <2013{
fsum F1_Adj  if nonreligious==1 & year==`i' [aw=vcf0010x], stats(p50)
return list
post `nonreligious1' (`r(N)[F1_Adj]') (`r(mean)[F1_Adj]') (`r(sd)[F1_Adj]') (`r(p50)[F1_Adj]') (`r(sum_w)[F1_Adj]')
local i = `i'+4 
}
postclose `nonreligious1' 

tempname nonreligious2
postfile `nonreligious2' N_F2_Adj mean_F2_Adj sd_F2_Adj median_F2_Adj W_N_F2_Adj  using "nonreligious2.dta", replace
local i = 1972
while `i' <2013{
fsum F2_Adj  if nonreligious==1 & year==`i' [aw=vcf0010x], stats(p50)
return list
post `nonreligious2' (`r(N)[F1_Adj]') (`r(mean)[F1_Adj]') (`r(sd)[F1_Adj]') (`r(p50)[F1_Adj]') (`r(sum_w)[F1_Adj]')
local i = `i'+4 
}
postclose `nonreligious2'

clear

use "nonreligious1.dta"
merge using "nonreligious2.dta"

label variable mean_F1_Adj "Non-Religious"
drop _merge N_F2_Adj 
egen year = fill(1972(4)2012) 
sort year
save "nonreligious1.dta", replace


clear 
set more off

use "ANES_POST_FACTOR_All_Years.dta"

tempname urban1
postfile `urban1' N_F1_Adj mean_F1_Adj sd_F1_Adj median_F1_Adj W_N_F1_Adj using "urban1.dta", replace
local i = 1972
while `i' <2001{
fsum F1_Adj  if urban==1 & year==`i' [aw=vcf0010x], stats(p50)
return list
post `urban1' (`r(N)[F1_Adj]') (`r(mean)[F1_Adj]') (`r(sd)[F1_Adj]') (`r(p50)[F1_Adj]') (`r(sum_w)[F1_Adj]')
local i = `i'+4 
}
postclose `urban1' 

tempname urban2
postfile `urban2' N_F2_Adj mean_F2_Adj sd_F2_Adj median_F2_Adj W_N_F2_Adj  using "urban2.dta", replace
local i = 1972
while `i' <2001{
fsum F2_Adj  if urban==1 & year==`i' [aw=vcf0010x], stats(p50)
return list
post `urban2' (`r(N)[F1_Adj]') (`r(mean)[F1_Adj]') (`r(sd)[F1_Adj]') (`r(p50)[F1_Adj]') (`r(sum_w)[F1_Adj]')
local i = `i'+4 
}
postclose `urban2'

clear

use "urban1.dta"
merge using "urban2.dta"

label variable mean_F1_Adj "Urban"
drop _merge N_F2_Adj 
egen year = fill(1972(4)2000)
sort year
save "urban1.dta", replace


clear 
set more off

use "ANES_POST_FACTOR_All_Years.dta"

tempname rural1
postfile `rural1' N_F1_Adj mean_F1_Adj sd_F1_Adj median_F1_Adj W_N_F1_Adj using "rural1.dta", replace
local i = 1972
while `i' <2001{
fsum F1_Adj  if rural==1 & year==`i' [aw=vcf0010x], stats(p50)
return list
post `rural1' (`r(N)[F1_Adj]') (`r(mean)[F1_Adj]') (`r(sd)[F1_Adj]') (`r(p50)[F1_Adj]') (`r(sum_w)[F1_Adj]')
local i = `i'+4 
}
postclose `rural1' 

tempname rural2
postfile `rural2' N_F2_Adj mean_F2_Adj sd_F2_Adj median_F2_Adj W_N_F2_Adj  using "rural2.dta", replace
local i = 1972
while `i' <2001{
fsum F2_Adj  if rural==1 & year==`i' [aw=vcf0010x], stats(p50)
return list
post `rural2' (`r(N)[F1_Adj]') (`r(mean)[F1_Adj]') (`r(sd)[F1_Adj]') (`r(p50)[F1_Adj]') (`r(sum_w)[F1_Adj]')
local i = `i'+4 
}
postclose `rural2'

clear

use "rural1.dta"
merge using "rural2.dta"

label variable mean_F1_Adj "Rural"
drop _merge N_F2_Adj 
egen year = fill(1972(4)2000)
sort year
save "rural1.dta", replace


clear 
set more off

use "ANES_POST_FACTOR_All_Years.dta"

tempname Male1
postfile `Male1' N_F1_Adj mean_F1_Adj sd_F1_Adj median_F1_Adj W_N_F1_Adj using "Male1.dta", replace
local i = 1972
while `i' <2013{
fsum F1_Adj  if Female==0 & year==`i' [aw=vcf0010x], stats(p50)
return list
post `Male1' (`r(N)[F1_Adj]') (`r(mean)[F1_Adj]') (`r(sd)[F1_Adj]') (`r(p50)[F1_Adj]') (`r(sum_w)[F1_Adj]')
local i = `i'+4 
}
postclose `Male1' 

tempname Male2
postfile `Male2' N_F2_Adj mean_F2_Adj sd_F2_Adj median_F2_Adj W_N_F2_Adj  using "Male2.dta", replace
local i = 1972
while `i' <2013{
fsum F2_Adj  if Female==0 & year==`i' [aw=vcf0010x], stats(p50)
return list
post `Male2' (`r(N)[F1_Adj]') (`r(mean)[F1_Adj]') (`r(sd)[F1_Adj]') (`r(p50)[F1_Adj]') (`r(sum_w)[F1_Adj]')
local i = `i'+4 
}
postclose `Male2'

clear

use "Male1.dta"
merge using "Male2.dta"


label variable mean_F1_Adj "Male"
drop _merge N_F2_Adj 
egen year = fill(1972(4)2012) 
sort year
save "Male1.dta", replace



clear 
set more off

use "ANES_POST_FACTOR_All_Years.dta"

tempname Protestant1
postfile `Protestant1' N_F1_Adj mean_F1_Adj sd_F1_Adj median_F1_Adj W_N_F1_Adj using "Protestant1.dta", replace
local i = 1972
while `i' <2013{
fsum F1_Adj  if Protestant==1 & White==1 & year==`i' [aw=vcf0010x], stats(p50)
return list
post `Protestant1' (`r(N)[F1_Adj]') (`r(mean)[F1_Adj]') (`r(sd)[F1_Adj]') (`r(p50)[F1_Adj]') (`r(sum_w)[F1_Adj]')
local i = `i'+4 
}
postclose `Protestant1' 

tempname Protestant2
postfile `Protestant2' N_F2_Adj mean_F2_Adj sd_F2_Adj median_F2_Adj W_N_F2_Adj  using "Protestant2.dta", replace
local i = 1972
while `i' <2013{
fsum F2_Adj  if Protestant==1 & White==1 & year==`i' [aw=vcf0010x], stats(p50)
return list
post `Protestant2' (`r(N)[F1_Adj]') (`r(mean)[F1_Adj]') (`r(sd)[F1_Adj]') (`r(p50)[F1_Adj]') (`r(sum_w)[F1_Adj]')
local i = `i'+4 
}
postclose `Protestant2'




clear

use "Protestant1.dta"
merge using "Protestant2.dta"

label variable mean_F1_Adj "Protestant"
drop _merge N_F2_Adj 
egen year = fill(1972(4)2012) 
sort year
save "Protestant1.dta", replace


clear 
set more off

use "ANES_POST_FACTOR_All_Years.dta"

tempname White1
postfile `White1' N_F1_Adj mean_F1_Adj sd_F1_Adj median_F1_Adj W_N_F1_Adj using "White1.dta", replace
local i = 1972
while `i' <2013{
fsum F1_Adj  if White==1 & year==`i' [aw=vcf0010x], stats(p50)
return list
post `White1' (`r(N)[F1_Adj]') (`r(mean)[F1_Adj]') (`r(sd)[F1_Adj]') (`r(p50)[F1_Adj]') (`r(sum_w)[F1_Adj]')
local i = `i'+4 
}
postclose `White1' 

tempname White2
postfile `White2' N_F2_Adj mean_F2_Adj sd_F2_Adj median_F2_Adj W_N_F2_Adj  using "White2.dta", replace
local i = 1972
while `i' <2013{
fsum F2_Adj  if White==1  & year==`i' [aw=vcf0010x], stats(p50)
return list
post `White2' (`r(N)[F1_Adj]') (`r(mean)[F1_Adj]') (`r(sd)[F1_Adj]') (`r(p50)[F1_Adj]') (`r(sum_w)[F1_Adj]')
local i = `i'+4 
}
postclose `White2'


clear



use "White1.dta"
merge using "White2.dta"
label variable mean_F1_Adj "White"
egen year = fill(1972(4)2012)
sort year 
drop _merge N_F2_Adj 
save "White1.dta", replace


clear 
set more off

use "ANES_POST_FACTOR_All_Years.dta"

tempname All1
postfile `All1' N_F1_Adj mean_F1_Adj sd_F1_Adj median_F1_Adj W_N_F1_Adj using "All1.dta", replace
local i = 1972
while `i' <2013{
fsum F1_Adj  if year==`i' [aw=vcf0010x], stats(p50)
return list
post `All1' (`r(N)[F1_Adj]') (`r(mean)[F1_Adj]') (`r(sd)[F1_Adj]') (`r(p50)[F1_Adj]') (`r(sum_w)[F1_Adj]')
local i = `i'+4 
}
postclose `All1'

tempname All2
postfile `All2' N_F2_Adj mean_F2_Adj sd_F2_Adj median_F2_Adj W_N_F2_Adj  using "All2.dta", replace
local i = 1972
while `i' <2013{
fsum F2_Adj  if year==`i' [aw=vcf0010x], stats(p50)
return list
post `All2' (`r(N)[F1_Adj]') (`r(mean)[F1_Adj]') (`r(sd)[F1_Adj]') (`r(p50)[F1_Adj]') (`r(sum_w)[F1_Adj]')
local i = `i'+4 
}
postclose `All2'

clear 
use "All1.dta"
merge using "All2.dta"
label variable mean_F1_Adj "All"
drop _merge N_F2_Adj 
egen year = fill(1972(4)2012) 
sort year
save "All1.dta", replace

clear

set more off

use "ANES_POST_FACTOR_All_Years.dta"

tempname NW1
postfile `NW1' N_F1_Adj mean_F1_Adj sd_F1_Adj median_F1_Adj W_N_F1_Adj using "NW1.dta", replace
local i = 1972
while `i' <2013{
fsum F1_Adj  if year==`i' & White~=1 [aw=vcf0010x], stats(p50)
return list
post `NW1' (`r(N)[F1_Adj]') (`r(mean)[F1_Adj]') (`r(sd)[F1_Adj]') (`r(p50)[F1_Adj]') (`r(sum_w)[F1_Adj]')
local i = `i'+4 
}
postclose `NW1'

tempname NW2
postfile `NW2' N_F2_Adj mean_F2_Adj sd_F2_Adj median_F2_Adj W_N_F2_Adj  using "Nw2.dta", replace
local i = 1972
while `i' <2013{
fsum F2_Adj  if year==`i' & White~=1 [aw=vcf0010x], stats(p50)
return list
post `NW2' (`r(N)[F1_Adj]') (`r(mean)[F1_Adj]') (`r(sd)[F1_Adj]') (`r(p50)[F1_Adj]') (`r(sum_w)[F1_Adj]')
local i = `i'+4 
}
postclose `NW2'


clear

use "NW1.dta"
merge using "Nw2.dta"
label variable mean_F1_Adj "NW"
drop _merge N_F2_Adj 
egen year = fill(1972(4)2012) 
sort year
save "Nw1.dta", replace



clear 
use "Blacks1.dta"
append using "Latinos1.dta" 
append using "Asian1.dta"
append  using "Female1.dta"
append  using "IncTopThird1.dta"
append  using "IncBottomThird1.dta"
append using "SW1.dta"
append  using "collegegrad1.dta"
append  using "unionmember1.dta"
append  using "Jew1.dta"
append  using "Catholic1.dta"
append  using "weeklychurch1.dta"
append using "nonreligious1.dta"
append  using "urban1.dta"
append using "rural1.dta"
append  using "Male1.dta"
append using "Protestant1.dta"
append using "White1.dta"
append using "All1.dta"
append using "NW1.dta"


gen Label = "African Americans" in 1/11
replace Label = "Latino" in 12/22
replace Label = "Asian" in 23/33
replace Label = "Female" in 34/44
replace Label = "Inc Top 1/3" in 45/55
replace Label = "Inc Bottom 1/3" in 56/66
replace Label = "Southern Whites" in 67/77
replace Label = "College Grads" in 78/88
replace Label = "Union Member" in 89/99
replace Label = "Jews" in 100/110
replace Label = "Catholics" in 111/121
replace Label = "Weekly Church" in 122/132
replace Label = "Non-Religious" in 133/143
replace Label = "Urban" in 144/151
replace Label = "Rural" in 152/159
replace Label = "Male" in 160/170
replace Label = "Protestant" in 171/181
replace Label = "White" in 182/192
replace Label = "All" in 193/203
replace Label = "Non White" in 204/214

gen median_F1 = median_F1_Adj if Label=="All"
sort year
by year: egen Median_F1 = total(median_F1)
replace median_F1_Adj = median_F1_Adj-Median_F1 if Label~="wgt_Med 1972"
gen median_F2 = median_F2_Adj if Label=="All"
sort year
by year: egen Median_F2 = total(median_F2)
replace median_F2_Adj = median_F2_Adj-Median_F2 if Label~="wgt_Med 1972"




sort year
by year: gen total_resp = W_N_F1_Adj if Label=="All"
by year: egen Total_Resp = total(total_resp)
gen group_proportion = W_N_F1_Adj/Total_Resp

/// Adjusted Mean and Median, First Dimension
gen AWhite_Mean = mean_F1_Adj if Label=="White"
gen ANon_White_Mean = mean_F1_Adj if Label=="Non White"
by year: egen White_Mean = total(AWhite_Mean)
by year: egen NW_Mean = total(ANon_White_Mean)

gen Adj_Mean = (White_Mean*.876)+(NW_Mean*.123)
gen Adj_Dist = mean_F1_Adj-Adj_Mean

gen AWhite_median = median_F1_Adj if Label=="White"
gen ANon_White_median = median_F1_Adj if Label=="Non White"
by year: egen White_median = total(AWhite_median)
by year: egen NW_median = total(ANon_White_median)

gen Adj_median = (White_median*.876)+(NW_median*.123)
gen Adj_DistM = median_F1_Adj-Adj_median

/// Adjusted Mean and Median, Second Dimension

gen AWhite_Mean2 = mean_F2_Adj if Label=="White"
gen ANon_White_Mean2 = mean_F2_Adj if Label=="Non White"
by year: egen White_Mean2 = total(AWhite_Mean2)
by year: egen NW_Mean2 = total(ANon_White_Mean2)

gen Adj_Mean2 = (White_Mean2*.876)+(NW_Mean2*.123)
gen Adj_Dist2 = mean_F2_Adj-Adj_Mean2

gen AWhite_median2 = median_F2_Adj if Label=="White"
gen ANon_White_median2 = median_F2_Adj if Label=="Non White"
by year: egen White_median2 = total(AWhite_median2)
by year: egen NW_median2 = total(ANon_White_median2)

gen Adj_median2 = (White_median2*.876)+(NW_median2*.123)
gen Adj_DistM2 = median_F2_Adj-Adj_median2


/// Appendix Figure A7
/// Reweighted Distance from the Median--First Dimension
twoway connected Adj_DistM year if Label=="White" || connected median_F1_Adj year if Label=="White", xlabel(1972(8)2012) ytitle(Distance from Overall Median) xtitle(Year) title(Economic)  legend(cols(1) label(2 "Actual") label(1 "Weighted using 1972 Demographics"))
graph save "Adusted White Distance Econ.gph", replace
/// Second Dimension
twoway connected Adj_DistM2 year if Label=="White" || connected median_F2_Adj year if Label=="White", xlabel(1972(8)2012) ytitle(Distance from Overall Median) xtitle(Year) title(Social) legend(cols(1) label(2 "Actual") label(1 "Weighted using 1972 Demographics"))
graph save "Adusted White Distance Soc.gph", replace
graph combine "Adusted White Distance Econ.gph" "Adusted White Distance Soc.gph", xsize(8.5) ysize(5) 
graph export "Figure 6A.pdf", replace 


save "Mean Group Positions1.dta", replace 
 
rename  median_F2_Adj F2
rename median_F1_Adj F1
sort Label year




/// Standard Error of the Group Medians
gen MED_SE1 = (1.253*(sd_F1_Adj/(sqrt(W_N_F1_Adj))))
gen MED_SE2 = (1.253*(sd_F2_Adj/(sqrt(W_N_F2_Adj))))
/// 95% Confidence intervals
gen CI_F1 = MED_SE1*1.95
gen CI_F2 = MED_SE2*1.95
gen F1_Upper = F1+CI_F1
gen F1_Lower = F1-CI_F1
gen F2_Upper = F2+CI_F2
gen F2_Lower = F2-CI_F2

order Label year F1_Lower F1 F1_Upper F2_Lower F2 F2_Upper



drop if Label=="Union Member"
drop if Label=="Urban"
drop if Label=="Rural"
drop if Label=="Protestant"
drop if Label=="Non White"
drop if Label=="Catholics"
drop if Label=="All"
drop if Label=="Asian"

/// Appendix Figures A5 and A6
twoway scatter F1 year,  yline(0) msize(small) ylabel(-1.5(.5)1) xtitle("") xlabel(1972(8)2012) by(Label, legend(off) note("")) || rcap F1_Upper F1_Lower year
graph export "First Dimension Medians.pdf", replace 
twoway scatter F2 year,  yline(0) msize(small) ylabel(-1.5(.5)1) xtitle("") xlabel(1972(8)2012) by(Label, legend(off) note("")) || rcap F2_Upper F2_Lower year
graph export "Second Dimension Medians.pdf", replace 

scatter F2 F1 if year ==2012, mlabel(Label) msize(vsmall) yline(0) xline(0) title(2012) mlabsize(tiny) xtitle(Economic Dimension L-R) ytitle(Social Dimension L-R) xsize(5) ysize(4) xlabel(-1.5(.5)1) ylabel(-1.5(.5)1)
graph save Graph "Group Positions 2012.gph", replace
scatter F2 F1 if year ==2008, mlabel(Label) msize(vsmall) yline(0) xline(0) title(2008) mlabsize(tiny) xtitle(Economic Dimension L-R) ytitle(Social Dimension L-R) xsize(5) ysize(4) xlabel(-1.5(.5)1) ylabel(-1.5(.5)1)
graph save Graph "Group Positions 2008.gph", replace
scatter F2 F1 if year ==2004, mlabel(Label) msize(vsmall)  yline(0) xline(0) title(2004) mlabsize(tiny) xtitle(Economic Dimension L-R) ytitle(Social Dimension L-R) xsize(5) ysize(4) xlabel(-1.5(.5)1) ylabel(-1.5(.5)1)
graph save Graph "Group Positions 2004.gph", replace
scatter F2 F1 if year ==2000, mlabel(Label) msize(vsmall)  yline(0) xline(0) title(2000) mlabsize(tiny) xtitle(Economic Dimension L-R) ytitle(Social Dimension L-R) xsize(5) ysize(4) xlabel(-1.5(.5)1) ylabel(-1.5(.5)1)
graph save Graph "Group Positions 2000.gph", replace
scatter F2 F1 if year ==1996, mlabel(Label) msize(vsmall) yline(0) xline(0) title(1996) mlabsize(tiny) xtitle(Economic Dimension L-R) ytitle(Social Dimension L-R) xsize(5) ysize(4) xlabel(-1.5(.5)1) ylabel(-1.5(.5)1)
graph save Graph "Group Positions 1996.gph", replace
scatter F2 F1 if year ==1992, mlabel(Label) msize(vsmall)  yline(0) xline(0) title(1992) mlabsize(tiny) xtitle(Economic Dimension L-R) ytitle(Social Dimension L-R) xsize(5) ysize(4) xlabel(-1.5(.5)1) ylabel(-1.5(.5)1)
graph save Graph "Group Positions 1992.gph", replace
scatter F2 F1 if year ==1988, mlabel(Label) msize(vsmall)  yline(0) xline(0) title(1988) mlabsize(tiny) xtitle(Economic Dimension L-R) ytitle(Social Dimension L-R) xsize(5) ysize(4) xlabel(-1.5(.5)1) ylabel(-1.5(.5)1)
graph save Graph "Group Positions 1988.gph", replace
scatter F2 F1 if year ==1984, mlabel(Label) msize(vsmall)  yline(0) xline(0) title(1984) mlabsize(tiny) xtitle(Economic Dimension L-R) ytitle(Social Dimension L-R) xsize(5) ysize(4) xlabel(-1.5(.5)1) ylabel(-1.5(.5)1)
graph save Graph "Group Positions 1984.gph", replace
scatter F2 F1 if year ==1980, mlabel(Label) msize(vsmall) yline(0) xline(0) title(1980) mlabsize(tiny) xtitle(Economic Dimension L-R) ytitle(Social Dimension L-R) xsize(5) ysize(4) xlabel(-1.5(.5)1) ylabel(-1.5(.5)1)
graph save Graph "Group Positions 1980.gph", replace
scatter F2 F1 if year ==1976, mlabel(Label) msize(vsmall)  yline(0) xline(0) title(1976) mlabsize(tiny) xtitle(Economic Dimension L-R) ytitle(Social Dimension L-R) xsize(5) ysize(4) xlabel(-1.5(.5)1) ylabel(-1.5(.5)1)
graph save Graph "Group Positions 1976.gph", replace
scatter F2 F1 if year ==1972, mlabel(Label) msize(vsmall)  yline(0) xline(0) title(1972) mlabsize(tiny) xtitle(Economic Dimension L-R) ytitle(Social Dimension L-R) xsize(5) ysize(4) xlabel(-1.5(.5)1) ylabel(-1.5(.5)1)
graph save Graph "Group Positions 1972.gph", replace


/// Appendix Figure 4

graph combine "Group Positions 1972.gph" ///
"Group Positions 1988.gph" ///
"Group Positions 2000.gph" ///
"Group Positions 2012.gph", ysize(6) xsize(8)
graph export "Figure A4.pdf", replace

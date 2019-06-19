
clear

pause on


cd "C:\RESTAT"


use OTRI_TH0_AEfinal.dta, clear
keep ccode sector  otri_t2008 otri_t2009  MFNotri_t2008 MFNotri_t2009
keep if sector=="ALL"
drop sector
rename  otri_t2008 otri_ae08
rename  otri_t2009 otri_ae09
rename  MFNotri_t2008 otri_m08
rename  MFNotri_t2009 otri_m09
drop  otri_ae09
gen otri_b08=otri_ae08
sort ccode
save otri_charts, replace

use OTRI_TH0_BEfinal.dta, clear
keep  ccode sector otri_t2008 otri_t2009 incotri_t0809
keep if sector=="ALL"
drop sector
rename otri_t2008 otri_be08
rename otri_t2009 otri_be09
sort ccode
merge ccode using otri_charts
tab _m
drop _m
sort ccode
save otri_charts, replace

use OTRI_TH0_BEfinal_AD.dta, clear
keep  ccode sector incotri_t0809
rename  incotri_t0809 incotri_t0809AD
keep if sector=="ALL"
drop sector
sort ccode 
merge ccode using otri_charts
tab _m

gen  changeinotri_t=incotri_t0809 if _m==2
replace  changeinotri_t= incotri_t0809AD if _m==3
replace changeinotri_t=incotri_t0809AD+(otri_m09-otri_m08) if ccode=="CHL"
replace changeinotri_t=incotri_t0809AD+(otri_m09-otri_m08) if ccode=="IND"
replace changeinotri_t=incotri_t0809AD+(otri_m09-otri_m08) if ccode=="JPN"

drop _m
drop incotri_t0809AD incotri_t0809
order ccode  otri_be08 otri_ae08 otri_m08 changeinotri_t otri_be09 otri_m09 otri_b08
sort ccode
save otri_charts, replace


use otri_charts, clear
des
rename ccode code
gen otri_ad09=otri_be08+changeinotri_t
replace otri_ad09=otri_m08+changeinotri_t if otri_be09==.
replace otri_be08=otri_m08 if otri_be09==.

gen x=1
replace x=0.25
replace x=. if code~="AFG"
replace x=0 if code=="ARG"

drop if code=="FJI"

gen pos=12
replace pos=9 if code=="JPN"
replace pos=10 if code=="SAU"
replace pos=11 if code=="QAT"
replace pos=10 if code=="ARE"
replace pos=9 if code=="USA"
replace pos=10 if code=="CAN"
replace pos=10 if code=="ARE"
replace pos=10 if code=="TUR"

replace code="" if changeinotri_t<=0 & change~=.
label var otri_ad09 "OTRI_2009"
label var otri_be08 "OTRI_2008"
set scheme s2color
twoway  (scatter otri_ad09 otri_be08, mlabel("code") mlabv(pos) msize(small) mlabsize(tiny) msymbol(circle_hollow)) (line x x), title(OTRI in 2008 vs. 2009) legend(off) ytitle("OTRI_2009") xtitle("OTRI_2008") graphregion(color(white))




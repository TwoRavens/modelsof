

set more off


*****ROBUSTTESTER

use /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/cohorts_87_92_tempcost1.dta, clear
rename annuity_skatt askatt 
rename annuity_benefits abenefits 
rename annuity_disp_faminc  adisp_faminc 
rename annuity_disp_faminc_ext2 adisp_faminc_ext2 


/*Baseline estimates: +-3 months, linear RD with triangular weights*/

****Analysis

*****regressions


rename days_ days
*symmetric 3 month window. 

*87-reform: 1.05.1987. 
gen reform87=1 if fodtaar>=mdy(5,1,1987) & fodtaar<mdy(8,1,1987)
replace reform87=0 if fodtaar<mdy(5,1,1987)& fodtaar>=mdy(2,1,1987)
tab b_month if reform87==1
tab b_month if reform87==0

*88-reform: 1.juli
gen reform88=1 if fodtaar>=mdy(7,1,1988) & fodtaar<mdy(10,1,1988)
replace reform88=0 if fodtaar<mdy(7,1,1988) & fodtaar>=mdy(4,1,1988)

tab b_month if reform88==1
tab b_month if reform88==0

*89-reform: 1.april
gen reform89=1 if fodtaar>=mdy(4,1,1989) & fodtaar<mdy(7,1,1989)
replace reform89=0 if fodtaar<mdy(4,1,1989) & fodtaar>=mdy(1,1,1989)
tab b_month if reform89==1
tab b_month if reform89==0


*90-reform: 1.5.1990: 
gen reform90=1 if fodtaar>=mdy(5,1,1990) & fodtaar<mdy(8,1,1990)
replace reform90=0 if fodtaar< mdy(5,1,1990)  & fodtaar>=mdy(2,1,1990)

tab b_month if reform90==1
tab b_month if reform90==0

*91-reform: 1.7.1991: 
gen reform91=1 if  fodtaar>=mdy(7,1,1991) & fodtaar<mdy(10,1,1991)
replace reform91=0 if fodtaar<mdy(7,1,1991) & fodtaar>=mdy(4,1,1991)
tab b_month if reform91==1
tab b_month if reform91==0


*92-reform: 1.4.1992: 
gen reform92=1 if fodtaar>=mdy(4,1,1992) & fodtaar<mdy(7,1,1992)
replace reform92=0 if fodtaar< mdy(4,1,1992) & fodtaar>=mdy(1,1,1992)
tab b_month if reform92==1
tab b_month if reform92==0


*93 reform: 1.april
gen reform93=1 if fodtaar>=mdy(4,1,1993) & fodtaar<mdy(7,1,1993)
replace reform93=0 if fodtaar<mdy(4,1,1993) & fodtaar>=mdy(1,1,1993)







foreach t in 87 88 89 90 91 92 93  {
gen nreform`t'=1 if reform`t'==0
replace nreform`t'=0 if reform`t'==1
}

***generate linear slopes
sum fodtaar if fodtaar==mdy(5,1,1987)
local threshold87=r(mean)
display `threshold87'

sum fodtaar if fodtaar==mdy(7,1,1988)
local threshold88=r(mean)
display `threshold88'


sum fodtaar if fodtaar==mdy(4,1,1989)
local threshold89=r(mean)
display `threshold89'

sum fodtaar if fodtaar==mdy(5,1,1990)
local threshold90=r(mean)
display `threshold90'

sum fodtaar if fodtaar==mdy(7,1,1991)
local threshold91=r(mean)
display `threshold91'


sum fodtaar if fodtaar==mdy(4,1,1992)
local threshold92=r(mean)
display `threshold92'

sum fodtaar if fodtaar==mdy(4,1,1993)
local threshold93=r(mean)
display `threshold93'


*1 week donout thresholds

gen donut87_minus=`threshold87'-7 
gen donut87_plus=`threshold87'+7 
tab donut87_minus
tab donut87_plus


gen donut88_minus=`threshold88'-7
gen donut88_plus=`threshold88'+7 
tab donut88_minus
tab donut88_plus

gen donut89_minus=`threshold89'-7 
gen donut89_plus=`threshold89'+7 
tab donut89_minus
tab donut89_plus




gen donut90_minus=`threshold90'-7 
gen donut90_plus=`threshold90'+7 
tab donut90_minus
tab donut90_plus


gen donut91_minus=`threshold91'-7 
gen donut91_plus=`threshold91'+7 
tab donut91_minus
tab donut91_plus

gen donut92_minus=`threshold92'-7 
gen donut92_plus=`threshold92'+7 
tab donut92_minus
tab donut92_plus

gen donut93_minus=`threshold93'-7 
gen donut93_plus=`threshold93'+7 
tab donut93_minus
tab donut93_plus





*days
foreach t in 87 88 89 90 91 92 93{

gen dslope`t'=fodtaar-`threshold`t'' if reform`t'!=. 
gen dslope`t'_1= dslope`t'* reform`t'
gen dslope`t'_2=dslope`t'*nreform`t' 
gen dslope`t'_12= dslope`t'_1* dslope`t'_1 
gen dslope`t'_22= dslope`t'_2* dslope`t'_2
gen dslope`t'_13= dslope`t'_1* dslope`t'_1* dslope`t'_1
gen dslope`t'_23= dslope`t'_2* dslope`t'_2* dslope`t'_2


}

***triangular weights



gen triw87=1-abs((fodtaar-`threshold87')/92) if reform87!=.
replace triw87=1/92 if triw87==0 & reform87!=.

gen triw88=1-abs((fodtaar-`threshold88')/92) if reform88!=.
replace triw88=1/92 if triw88==0 & reform88!=.

gen triw89=1-abs((fodtaar-`threshold89')/92) if reform89!=.
replace triw89=1/92 if triw89==0 & reform89!=.



gen triw90=1-abs((fodtaar-`threshold90')/92) if reform90!=.
replace triw90=1/92 if triw90==0 & reform90!=.

gen triw91=1-abs((fodtaar-`threshold91')/92) if reform91!=.
replace triw91=1/92 if triw91==0 & reform91!=.


gen triw92=1-abs((fodtaar-`threshold92')/92) if reform92!=.
replace triw92=1/92 if triw92==0 & reform92!=.

gen triw93=1-abs((fodtaar-`threshold93')/92) if reform93!=.
replace triw93=1/92 if triw93==0 & reform93!=.



*unpaid and total leave in days instead of months
gen mluptot_wk=mluptot*4*7






* eligible var
drop eligible
gen eligible=.

forvalues t=1986/1995 {
replace eligible=eligible`t' if b_year==`t'
}





*married year before, married 14 years after
gen marryb_14=1 if marcfyb==1 & marrchf14==1
replace marryb_14=0 if marcfyb==1 & marrchf14==0


*not married year before, married 14 years after
gen not_marryb_14=1 if marcfyb==0 & marrchf14==1
replace not_marryb_14=0 if marcfyb==0 & marrchf14==0

gen mluptot_days=mluptot*7*4

label var mluptot_days "days of unpaid leave"
gen divorce=1-marryb_14

gen mageb2=mageb*mageb
gen fageb2=fageb*fageb


*Table 1: all outcomes vertically and the different specifications horizontally


foreach t in  92 {
clear matrix

*foreach c in mluptot_days skraver memp2 memptot minctot femptot finctot ggemptot gginctot divorce marryb_14 nchild14 cost_direct skatt_tot benefits_tot {

xi: reg `c' reform`t' dslope`t'_1 dslope`t'_2 mageb mageb2 fageb fageb2 meduyb feduyb marcfyb i.countybb i.kjonn [pw=triw`t'] if eligible==1
eststo `c'_baseline


xi: reg `c' reform`t' dslope`t'_1 dslope`t'_2 [pw=triw`t'] if eligible==1
eststo `c'_nocontrol

xi: reg `c' reform`t' dslope`t'_1 dslope`t'_2 dslope`t'_22 dslope`t'_12 mageb mageb2 fageb fageb2 meduyb feduyb marcfyb i.countybb i.kjonn [pw=triw`t'] if eligible==1
eststo `c'_quadratic

 

}

}


foreach c in  mluptot_days skraver memp2 memptot minctot femptot finctot ggemptot gginctot divorce marryb_14 nchild14 cost_direct skatt_tot benefits_tot {

esttab `c'_baseline  `c'_nocontrol `c'_quadratic using "/ssb/ovibos/a1/swp/kav/wk24/allreforms/table/robust_reg_`c'_`t'.tex",  label keep(reform`t') se cells(b(star fmt(3)) se(par fmt(3))) nonumbers prehead("\centering\begin{tabular}{lcccccccc}\\ \hline &\multicolumn{1}{c}{Baseline}&\multicolumn{1}{c}{No Controls}&\multicolumn{1}{c}{Quadratic trends}&\multicolumn{1}{c}{Cluster on day of birth}&\multicolumn{1}{c}{Two week donut}\\ \hline") postfoot("\end{tabular}") varlabels(reform`t' "`t'") nomtitles starlevels (* 0.1 ** 0.05 *** 0.01) replace





}


foreach t in  92 {
clear matrix

*foreach c in mluptot_days skraver memp2 memptot minctot femptot finctot ggemptot gginctot divorce marryb_14 nchild14 cost_direct skatt_tot benefits_tot {


* 1 week donut
preserve
sum fodtaar
drop if fodtaar>=donut`t'_minus & fodtaar<donut`t'_plus
sum fodtaar
xi: reg `c' reform`t' dslope`t'_1 dslope`t'_2 mageb mageb2 fageb fageb2 meduyb feduyb marcfyb i.countybb i.kjonn [pw=triw`t'] if eligible==1
eststo `c'1wkdonut

esttab `c'1wkdonut using "/ssb/ovibos/a1/swp/kav/wk24/allreforms/table/robust_reg_`cÕ1wkdonut_`t'.tex",  label keep(reform`t') se cells(b(star fmt(3)) se(par fmt(3))) nonumbers prehead("\centering\begin{tabular}{lcccccccc}\\ \hline &\multicolumn{1}{c}{Baseline}&\multicolumn{1}{c}{No Controls}&\multicolumn{1}{c}{Quadratic trends}&\multicolumn{1}{c}{Cluster on day of birth}&\multicolumn{1}{c}{Two week donut}\\ \hline") postfoot("\end{tabular}") varlabels(reform`t' "`t'") nomtitles starlevels (* 0.1 ** 0.05 *** 0.01) replace


restore

}
}


*********table 2:experiment with window: baseline (90 days), 120 days, 60 days

set more off


forvalues t=92/92 {

drop  dslope`t' dslope`t'_1 dslope`t'_2 dslope`t'_12 dslope`t'_22 dslope`t'_23 dslope`t'_13 

}



*92-reform: 1.4.1992: 
gen window120_reform92=1 if fodtaar>=mdy(4,1,1992) & fodtaar<mdy(8,1,1992)
replace window120_reform92=0 if fodtaar< mdy(4,1,1992) & fodtaar>=mdy(12,1,1991)

gen window90_reform92=1 if fodtaar>=mdy(4,1,1992) & fodtaar<mdy(7,1,1992)
replace window90_reform92=0 if fodtaar< mdy(4,1,1992) & fodtaar>=mdy(1,1,1992)

gen window60_reform92=1 if fodtaar>=mdy(4,1,1992) & fodtaar<mdy(6,1,1992)
replace window60_reform92=0 if fodtaar< mdy(4,1,1992) & fodtaar>=mdy(2,1,1992)



tab b_month if reform92==1
tab b_month if reform92==0



foreach t in 92 {


gen window120_nreform`t'=1 if window120_reform`t'==0
replace window120_nreform`t'=0 if window120_reform`t'==1

}





***generate linear slopes


set more off
*days
foreach t in  92 {

gen dslope`t'=fodtaar-mdy(4,1,1992) if window120_reform`t'!=. 
gen dslope`t'_1= dslope`t'*window120_reform`t'
gen dslope`t'_2=dslope`t'*window120_nreform`t' 
gen dslope`t'_12= dslope`t'_1* dslope`t'_1 
gen dslope`t'_22= dslope`t'_2* dslope`t'_2
gen dslope`t'_13= dslope`t'_1* dslope`t'_1* dslope`t'_1
gen dslope`t'_23= dslope`t'_2* dslope`t'_2* dslope`t'_2


}





forvalues t=92/92 {
clear matrix

foreach c in mluptot_days skraver memp2  memptot minctot femptot finctot ggemptot gginctot divorce marryb_14 nchild14 cost_direct skatt_tot benefits_tot {

preserve
*120 days
drop reform`t'
rename window120_reform`t' reform`t'
*window120_reform92
drop triw`t'
gen triw`t'=1-abs((fodtaar-`threshold`t'')/120) if reform`t'!=.
replace triw`t'=1/120 if triw`t'==0 & reform`t'!=.


xi: reg `c' reform`t' dslope`t'_1 dslope`t'_2 mageb mageb2 fageb fageb2 meduyb feduyb marcfyb i.countybb i.kjonn [pw=triw`t'] if eligible==1
eststo `c'_120dys

*baseline 90 days
drop reform`t'

keep if window90_reform`t'!=.
tab b_month 

rename window90_reform`t' reform`t'


drop triw`t'

gen triw`t'=1-abs((fodtaar-mdy(4,1,1992))/92) if reform`t'!=.
replace triw`t'=1/92 if triw`t'==0 & reform`t'!=.


xi: reg `c' reform`t' dslope`t'_1 dslope`t'_2 mageb mageb2 fageb fageb2 meduyb feduyb marcfyb i.countybb i.kjonn [pw=triw`t'] if eligible==1
eststo `c'_90dys

drop reform`t'

*60 days:
keep if window60_reform`t'!=.
rename window60_reform`t' reform`t'
tab b_month if reform`t'!=.

drop triw`t'

gen triw`t'=1-abs((fodtaar-`threshold`t'')/60) if reform`t'!=.
replace triw`t'=1/60 if triw`t'==0 & reform`t'!=.


xi: reg `c' reform`t' dslope`t'_1 dslope`t'_2 mageb mageb2 fageb fageb2 meduyb feduyb marcfyb i.countybb i.kjonn [pw=triw`t'] if eligible==1

eststo `c'_60dys



esttab  `c'_90dys `c'_120dys `c'_60dys using "/ssb/ovibos/a1/swp/kav/wk24/allreforms/table/robust_reg_window_`c'_`t'.tex",  label  se cells(b(star fmt(3)) se(par fmt(3))) nonumbers prehead("\centering\begin{tabular}{lcccccccc}\\ \hline &\multicolumn{1}{c}{90 days (baseline)}&\multicolumn{1}{c}{120 days}&\multicolumn{1}{c}{60 days}&\\ \hline") postfoot("\end{tabular}") varlabels(reform`t' "`t'") nomtitles starlevels (* 0.1 ** 0.05 *** 0.01) replace


restore
}

}











**************************************
****llr for 92*************

set more off

log using /ssb/ovibos/a1/swp/kav/wk24/allreforms/reg_92_llr.log,replace
use /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/cohorts_87_92_tempcost1.dta, clear
rename annuity_skatt askatt 
rename annuity_benefits abenefits 
rename annuity_disp_faminc  adisp_faminc 

rename annuity_disp_faminc_ext2 adisp_faminc_ext2 

*prøv flere bandwiths: , 30, 60 

*92-reform: 1.4.1992: 
gen reform92=1 if fodtaar>=mdy(4,1,1992) & fodtaar<mdy(7,1,1992)
replace reform92=0 if fodtaar< mdy(4,1,1992) & fodtaar>=mdy(1,1,1992)
tab b_month if reform92==1
tab b_month if reform92==0

* eligible var
drop eligible
gen eligible=.

forvalues t=1987/1992 {
replace eligible=eligible`t' if b_year==`t'
}





program katrine30, rclass
version 10
syntax [varlist(min=2 max=2)] [, *]
tokenize `varlist'
tempvar z f0 f1
qui g `z'=0 in 1
local opt "at(`z') nogr rec deg(1) bw(30) `options'"
lpoly `1'  `2' if `2'>=0, gen (`f0') `opt'
lpoly `1'  `2' if `2'<0, gen (`f1') `opt'
return scalar d=`=`f0'[1]-`f1'[1]'
di as txt "Estimate: " as res `f0'[1]-`f1'[1] 
eret clear
end



program katrine60, rclass
version 10
syntax [varlist(min=2 max=2)] [, *]
tokenize `varlist'
tempvar z f0 f1
qui g `z'=0 in 1
local opt "at(`z') nogr rec deg(1) bw(60) `options'"
lpoly `1'  `2' if `2'>=0, gen (`f0') `opt'
lpoly `1'  `2' if `2'<0, gen (`f1') `opt'
return scalar d=`=`f0'[1]-`f1'[1]'
di as txt "Estimate: " as res `f0'[1]-`f1'[1] 
eret clear
end


foreach c in mluptot_days skraver memp2  memptot minctot femptot finctot ggemptot gginctot divorce marryb_14 nchild14 cost_direct skatt_tot benefits_tot {

clear matrix

preserve
replace fodtaar=fodtaar-mdy(4,1,1992)
keep if eligible==1 & reform92!=. & `c'!=.

bootstrap r(d), reps(2000): katrine30 `c' fodtaar
eststo `c'_bw30

bootstrap r(d), reps(2000): katrine60 `c' fodtaar
eststo `c'_bw60

esttab  `c'_bw30 `c'_bw60 using "/ssb/ovibos/a1/swp/kav/wk24/allreforms/table/`c'_robust_llr_92.tex",  label se cells(b(star fmt(3)) se(par fmt(3))) nonumbers prehead("\centering\begin{tabular}{lcccccccc}\\ \hline &\multicolumn{1}{c}{Llr, bw=2 days}&\multicolumn{1}{c}{Llr, bw=30 days}&\multicolumn{1}{c}{Llr, bw=60 days}&\multicolumn{1}{c}{Llr, bw=30 days}&\multicolumn{1}{c}{llr, bw=60 days}\\ \hline") postfoot("\end{tabular}") varlabels(reform`t' "`t'") nomtitles starlevels (* 0.1 ** 0.05 *** 0.01) replace

restore

}



log close





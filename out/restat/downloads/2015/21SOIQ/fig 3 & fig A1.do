clear
set more off
set mem 5000m 
set matsize 500 
capture log close


*use /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/fodtaar.dta
use "P:\PROSJEKT\Maternity leave\fodtaar.dta", clear


*87-reform: 1.05.1987. 
gen reform87=1 if fodtaar>=mdy(5,1,1987) & fodtaar<mdy(8,8,1987)
replace reform87=0 if fodtaar<mdy(5,1,1987)& fodtaar>=mdy(1,30,1987)
tab b_month if reform87==1
tab b_month if reform87==0

*88-reform: 1.juli
gen reform88=1 if fodtaar>=mdy(7,1,1988) & fodtaar<mdy(10,1,1988)
replace reform88=0 if fodtaar<mdy(7,1,1988) & fodtaar>=mdy(4,1,1988)

tab b_month if reform88==1
tab b_month if reform88==0

*89-reform: 1.april
gen reform89=1 if fodtaar>=mdy(4,1,1989) & fodtaar<mdy(7,9,1989)
replace reform89=0 if fodtaar<mdy(4,1,1989) & fodtaar>=mdy(12,31,1988)
tab b_month if reform89==1
tab b_month if reform89==0


*90-reform: 1.5.1990: 
gen reform90=1 if fodtaar>=mdy(5,1,1990) & fodtaar<mdy(8,8,1990)
replace reform90=0 if fodtaar< mdy(5,1,1990)  & fodtaar>=mdy(1,29,1990)

tab b_month if reform90==1
tab b_month if reform90==0

*91-reform: 1.7.1991: 
gen reform91=1 if  fodtaar>=mdy(7,1,1991) & fodtaar<mdy(10,8,1991)
replace reform91=0 if fodtaar<mdy(7,1,1991) & fodtaar>=mdy(4,1,1991)
tab b_month if reform91==1
tab b_month if reform91==0


*92-reform: 1.4.1992: 
gen reform92=1 if fodtaar>=mdy(4,1,1992) & fodtaar<mdy(7,9,1992)
replace reform92=0 if fodtaar< mdy(4,1,1992) & fodtaar>=mdy(1,1,1992)
tab b_month if reform92==1
tab b_month if reform92==0


*93 reform: 1.april
gen reform93=1 if fodtaar>=mdy(4,1,1993) & fodtaar<mdy(7,9,1993)
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







***fertility:

set scheme s2mono
 forvalues t=87/87 {
 preserve
 clear matrix

keep if reform`t'!=.
 
replace fodtaar=fodtaar-`threshold`t''
 
 
gen week2=.
 forvalues i=-91(7)-7{
 replace week2=`i' if fodtaar>=`i' & fodtaar<`i'+7
 }
 forvalues i=0(7)91{
 replace week2=`i' if fodtaar>=`i' & fodtaar<`i'+7
 }
 


 tab week2
 sort week2



twoway (hist week2, density start(-91) width(7) fcolor(none) lcolor(black)), ylabel(0(0.001)0.01, angle(horisontal)) xlabel(-91 -77 -63 -49 -35 -21 -7 0 7 21 35 49 63 77 91 ) xtick(-91(7)91) xline(0, lpattern(shortdash)) xtitle("day of birth")  ytitle("density") legend(off)
graph export /ssb/ovibos/a1/swp/kav/wk24/allreforms/graph/fertility_reform`t'.eps,replace
 

 clear matrix
restore
 }

 **88


set scheme s2mono
 forvalues t=87/87 {
 clear matrix
preserve
keep if reform`t'!=.
 
replace fodtaar=fodtaar-`threshold`t''
 
 
gen week2=.
 forvalues i=-91(7)-7{
 replace week2=`i' if fodtaar>=`i' & fodtaar<`i'+7
 }
 forvalues i=0(7)350{
 replace week2=`i' if fodtaar>=`i' & fodtaar<`i'+7
 }

 tab week2
 sort week2


twoway (hist week2, density start(-91) width(7)  fcolor(none) lcolor(black)), ylabel(0(0.001)0.01, angle(horisontal)) xlabel(-91 -77 -63 -49 -35 -21 -7 0 7 21 35 49 63 77 91 ) xtick(-91(7)91) xline(0, lpattern(shortdash)) xtitle("day of birth")  ytitle("density") legend(off)
graph export /ssb/ovibos/a1/swp/kav/wk24/allreforms/graph/fertility_reform`t'.eps,replace
 
restore
 clear matrix

 }


set scheme s2mono
 forvalues t=88/88 {
 clear matrix
preserve
keep if reform`t'!=.
 
replace fodtaar=fodtaar-`threshold`t''
 
 
gen week2=.
 forvalues i=-91(7)-7{
 replace week2=`i' if fodtaar>=`i' & fodtaar<`i'+7
 }
 forvalues i=0(7)98{
 replace week2=`i' if fodtaar>=`i' & fodtaar<`i'+7
 }

 tab week2
 sort week2


twoway (hist week2, density start(-91) width(7)  fcolor(none) lcolor(black)), ylabel(0(0.001)0.01, angle(horisontal)) xlabel(-91 -77 -63 -49 -35 -21 -7 0 7 21 35 49 63 77 91 ) xtick(-91(7)98) xline(0, lpattern(shortdash)) xtitle("day of birth")  ytitle("density") legend(off)
graph export /ssb/ovibos/a1/swp/kav/wk24/allreforms/graph/fertility_reform`t'.eps,replace
 

 restore
 }



set scheme s2mono
 forvalues t=88/88 {
 clear matrix
preserve
keep if reform`t'!=.
 
replace fodtaar=fodtaar-`threshold`t''
 
 
gen week2=.
 forvalues i=-91(7)-7{
 replace week2=`i' if fodtaar>=`i' & fodtaar<`i'+7
 }
 forvalues i=0(7)98{
 replace week2=`i' if fodtaar>=`i' & fodtaar<`i'+7
 }

 tab week2
 sort week2


twoway (hist week2, density start(-91) width(7)  fcolor(none) lcolor(black)), ylabel(0(0.001)0.01, angle(horisontal)) xlabel(-91 -77 -63 -49 -35 -21 -7 0 7 21 35 49 63 77 91 ) xtick(-91(7)98) xline(0, lpattern(shortdash)) xtitle("day of birth")  ytitle("density") legend(off)
graph export /ssb/ovibos/a1/swp/kav/wk24/allreforms/graph/fertility_reform`t'.eps,replace
 

restore

 }



set scheme s2mono
 forvalues t=89/89 {
 clear matrix
preserve
keep if reform`t'!=.
 
replace fodtaar=fodtaar-`threshold`t''
 
 
gen week2=.
 forvalues i=-91(7)-7{
 replace week2=`i' if fodtaar>=`i' & fodtaar<`i'+7
 }
 forvalues i=0(7)98{
 replace week2=`i' if fodtaar>=`i' & fodtaar<`i'+7
 }

 tab week2
 sort week2


twoway (hist week2, density start(-91) width(7)  fcolor(none) lcolor(black)), ylabel(0(0.001)0.01, angle(horisontal)) xlabel(-91 -77 -63 -49 -35 -21 -7 0 7 21 35 49 63 77 91) xtick(-91(7)98) xline(0, lpattern(shortdash)) xtitle("day of birth")  ytitle("density") legend(off)
graph export /ssb/ovibos/a1/swp/kav/wk24/allreforms/graph/fertility_reform`t'.eps,replace
 

restore
 }




set scheme s2mono
 forvalues t=90/90 {
 clear matrix
preserve
keep if reform`t'!=.
 
replace fodtaar=fodtaar-`threshold`t''
 
 
gen week2=.
 forvalues i=-91(7)-7{
 replace week2=`i' if fodtaar>=`i' & fodtaar<`i'+7
 }
 forvalues i=0(7)98{
 replace week2=`i' if fodtaar>=`i' & fodtaar<`i'+7
 }

 tab week2
 sort week2


twoway (hist week2, density start(-91) width(7)  fcolor(none) lcolor(black)), ylabel(0(0.001)0.01, angle(horisontal)) xlabel(-91 -77 -63 -49 -35 -21 -7 0 7 21 35 49 63 77 91) xtick(-91(7)98) xline(0, lpattern(shortdash)) xtitle("day of birth")  ytitle("density") legend(off)
graph export /ssb/ovibos/a1/swp/kav/wk24/allreforms/graph/fertility_reform`t'.eps,replace
 
restore
 }






set scheme s2mono
 forvalues t=91/91 {
 clear matrix
preserve
keep if reform`t'!=.
 
replace fodtaar=fodtaar-`threshold`t''
 
 
gen week2=.
 forvalues i=-91(7)-7{
 replace week2=`i' if fodtaar>=`i' & fodtaar<`i'+7
 }
 forvalues i=0(7)98{
 replace week2=`i' if fodtaar>=`i' & fodtaar<`i'+7
 }

 tab week2
 sort week2


twoway (hist week2, density start(-91) width(7)  fcolor(none) lcolor(black)), ylabel(0(0.001)0.01, angle(horisontal)) xlabel(-91 -77 -63 -49 -35 -21 -7 0 7 21 35 49 63 77 91) xtick(-91(7)98) xline(0, lpattern(shortdash)) xtitle("day of birth")  ytitle("density") legend(off)
graph export /ssb/ovibos/a1/swp/kav/wk24/allreforms/graph/fertility_reform`t'.eps,replace
restore

 }

set scheme s2mono
 forvalues t=92/92 {
 clear matrix
preserve
keep if reform`t'!=.
 
replace fodtaar=fodtaar-`threshold`t''
 
 
gen week2=.
 forvalues i=-91(7)-7{
 replace week2=`i' if fodtaar>=`i' & fodtaar<`i'+7
 }
 forvalues i=0(7)98{
 replace week2=`i' if fodtaar>=`i' & fodtaar<`i'+7
 }

 tab week2
 sort week2


twoway (hist week2, density start(-91) width(7)  fcolor(none) lcolor(black)), ylabel(0(0.001)0.01, angle(horisontal)) xlabel(-91 -77 -63 -49 -35 -21 -7 0 7 21 35 49 63 77 91) xtick(-91(7)98) xline(0, lpattern(shortdash)) xtitle("day of birth")  ytitle("density") legend(off)
graph export /ssb/ovibos/a1/swp/kav/wk24/allreforms/graph/fertility_reform`t'.eps,replace
 
restore
 }
















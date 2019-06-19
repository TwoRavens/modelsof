clear
set more off
set mem 5000m 
set matsize 500 
capture log close

/*forst test ut forskjellige spesifikasjoner paa 2 utfall: GPA (skriftlig) og 14-diskontert mors inntekt. Test paa reform 90, 91,92*/
log using /ssb/ovibos/a1/swp/kav/wk24/allreforms/grphs_87_93reformd_2_inc_14.log, replace

use /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/cohorts_87_92_tempcost1.dta, clear
rename annuity_skatt askatt 
rename annuity_benefits abenefits 
rename annuity_disp_faminc  adisp_faminc 




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




*days
foreach t in 87 88 89 90 91 92 93{

gen dslope`t'=fodtaar-`threshold`t'' if reform`t'!=. 
gen dslope`t'_1= dslope`t'* reform`t'
gen dslope`t'_2=dslope`t'*nreform`t' 



}

***triangular weights (divide by number of days in window. 3 month window=about 92 days)



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

* eligible var
gen eligible=.

forvalues t=1986/1995 {
replace eligible= eligible`t' if b_year==`t'
}



*married year before, married 14 years after
gen marryb_14=1 if marcfyb==1 & marrchf14==1
replace marryb_14=0 if marcfyb==1 & marrchf14==0


*not married year before, married 14 years after
gen not_marryb_14=1 if marcfyb==0 & marrchf14==1
replace not_marryb_14=0 if marcfyb==0 & marrchf14==0

gen divorce=1-not_marryb_14




*var labels


label var marryb_14 "fraction married"
label var divorce “fraction divorced”
label var eligible "fraction eligible"


label var dropout "dropout rates"
label var skraver "exam scores"

label var memp2 "fraction employed"
label var memptot " years of employment"
label var minctot "income in USD”

label var femptot "total employment"

label var finctot "income in USD”

label var ggemptot "gender gap "

label var gginctot "gender gap "


label var askatt "Annuity of taxes in USD"
label var abenefits "Annuity of benefits in USD"

label var cost_direct “Program expenditure in USD”









set scheme s2mono

forvalues t=87/92 {

preserve

drop if reform`t'==.

count

replace fodtaar=fodtaar-`threshold`t''


gen week2=.
forvalues i=-357(7)-7{
replace week2=`i' if fodtaar>=`i' & fodtaar<`i'+7
}				
forvalues i=0(7)357{
replace week2=`i' if fodtaar>=`i' & fodtaar<`i'+7
}
tab week2
sort week2
by week2: gen obs=_N

sum obs
by week2: egen mfodtaar=mean(fodtaar) 

gen g2=fodtaar if fodtaar<0
gen g3=fodtaar if fodtaar>=0

foreach c in eligible {

local varlabel: var label `c'


egen a=mean(`c')
egen b=sd(`c')
gen max=a+(0.5*b)
gen min=a-(0.5*b)
sum max min

sort mfodtaar
by mfodtaar: egen m`c'=mean(`c')

sort week2



sort fodtaar
sum m`c'

local miny=round(min,.1)
local maxy=round(max,.1)
sum week2
sort week2

twoway (scatter m`c' week2, msize(vsmall) msymbol(circle) mcolor(gs9))  (lfit `c' g2 [pw=triw`t'], lpattern(solid)) (lfit `c' g3 [pw=triw`t'], lpattern(solid)), graphregion(fcolor(white) lcolor(white)) ylabel(`miny’(.5)`maxy', nogrid angle(horisontal)) xlabel(-91 -77 -63 -49 -35 -21 -7 0 7 21 35 49 63 77 91) xtick(-91(7)91) xline(0, lpattern(shortdash)) xtitle(day of birth)  ytitle("`varlabel'") legend(off)
graph export /ssb/ovibos/h1/kvs/table/`c'_reform`t'.png,replace
graph save /ssb/ovibos/h1/kvs/table/`c'_reform`t'.gph, replace
drop a b max min 
clear matrix
}
restore

}



*****


set scheme s2mono

forvalues t=87/92 {

preserve

drop if reform`t'==.
keep if eligible==1
count

replace fodtaar=fodtaar-`threshold`t''


gen week2=.
forvalues i=-357(7)-7{
replace week2=`i' if fodtaar>=`i' & fodtaar<`i'+7
}				
forvalues i=0(7)357{
replace week2=`i' if fodtaar>=`i' & fodtaar<`i'+7
}
tab week2
sort week2
by week2: gen obs=_N

sum obs
by week2: egen mfodtaar=mean(fodtaar) 

gen g2=fodtaar if fodtaar<0
gen g3=fodtaar if fodtaar>=0

foreach c in skraver {

local varlabel: var label `c'


egen a=mean(`c')
egen b=sd(`c')
gen max=a+(0.5*b)
gen min=a-(0.5*b)
sum max min

sort mfodtaar
by mfodtaar: egen m`c'=mean(`c')

sort week2



sort fodtaar
sum m`c'

local miny=round(min,.1)
local maxy=round(max,.1)
sum week2
sort week2

twoway (scatter m`c' week2, msize(vsmall) msymbol(circle) mcolor(gs9))  (lfit `c' g2 [pw=triw`t'], lpattern(solid)) (lfit `c' g3 [pw=triw`t'], lpattern(solid)), graphregion(fcolor(white) lcolor(white)) ylabel(`miny’(.1)`maxy', nogrid angle(horisontal)) xlabel(-91 -77 -63 -49 -35 -21 -7 0 7 21 35 49 63 77 91) xtick(-91(7)91) xline(0, lpattern(shortdash)) xtitle(day of birth)  ytitle("`varlabel'") legend(off)
graph export /ssb/ovibos/h1/kvs/table/`c'_reform`t'.png,replace
graph save /ssb/ovibos/h1/kvs/table/`c'_reform`t'.gph, replace
drop a b max min 
clear matrix
}
restore

}

**********

set scheme s2mono

forvalues t=87/91 {

preserve

drop if reform`t'==.
keep if eligible==1
count

replace fodtaar=fodtaar-`threshold`t''


gen week2=.
forvalues i=-357(7)-7{
replace week2=`i' if fodtaar>=`i' & fodtaar<`i'+7
}				
forvalues i=0(7)357{
replace week2=`i' if fodtaar>=`i' & fodtaar<`i'+7
}
tab week2
sort week2
by week2: gen obs=_N

sum obs
by week2: egen mfodtaar=mean(fodtaar) 

gen g2=fodtaar if fodtaar<0
gen g3=fodtaar if fodtaar>=0

foreach c in dropout {

local varlabel: var label `c'


egen a=mean(`c')
egen b=sd(`c')
gen max=a+(0.5*b)
gen min=a-(0.5*b)
sum max min

sort mfodtaar
by mfodtaar: egen m`c'=mean(`c')

sort week2



sort fodtaar
sum m`c'

local miny=round(min,.01)
local maxy=round(max,.01)
sum week2
sort week2

twoway (scatter m`c' week2, msize(vsmall) msymbol(circle) mcolor(gs9))  (lfit `c' g2 [pw=triw`t'], lpattern(solid)) (lfit `c' g3 [pw=triw`t'], lpattern(solid)), graphregion(fcolor(white) lcolor(white)) ylabel(`miny’(.5)`maxy', nogrid angle(horisontal)) xlabel(-91 -77 -63 -49 -35 -21 -7 0 7 21 35 49 63 77 91) xtick(-91(7)91) xline(0, lpattern(shortdash)) xtitle(day of birth)  ytitle("`varlabel'") legend(off)
graph export /ssb/ovibos/h1/kvs/table/`c'_reform`t'.png,replace
graph save /ssb/ovibos/h1/kvs/table/`c'_reform`t'.gph, replace
drop a b max min 
clear matrix
}
restore

}







***********
set scheme s2mono

forvalues t=87/92 {

preserve

drop if reform`t'==.
keep if eligible==1
count

replace fodtaar=fodtaar-`threshold`t''


gen week2=.
forvalues i=-357(7)-7{
replace week2=`i' if fodtaar>=`i' & fodtaar<`i'+7
}				
forvalues i=0(7)357{
replace week2=`i' if fodtaar>=`i' & fodtaar<`i'+7
}
tab week2
sort week2
by week2: gen obs=_N

sum obs
by week2: egen mfodtaar=mean(fodtaar) 

gen g2=fodtaar if fodtaar<0
gen g3=fodtaar if fodtaar>=0

foreach c in memp2 {

local varlabel: var label `c'


egen a=mean(`c')
egen b=sd(`c')
gen max=a+(0.5*b)
gen min=a-(0.5*b)
sum max min

sort mfodtaar
by mfodtaar: egen m`c'=mean(`c')

sort week2



sort fodtaar
sum m`c'

local miny=round(min,.01)
local maxy=round(max,.01)
sum week2
sort week2

twoway (scatter m`c' week2, msize(vsmall) msymbol(circle) mcolor(gs9))  (lfit `c' g2 [pw=triw`t'], lpattern(solid)) (lfit `c' g3 [pw=triw`t'], lpattern(solid)), graphregion(fcolor(white) lcolor(white)) ylabel(`miny'(.4)`maxy', nogrid angle(horisontal)) xlabel(-91 -77 -63 -49 -35 -21 -7 0 7 21 35 49 63 77 91) xtick(-91(7)91) xline(0, lpattern(shortdash)) xtitle(day of birth)  ytitle("`varlabel'") legend(off)
graph export /ssb/ovibos/h1/kvs/table/`c'_reform`t'.png,replace
graph save /ssb/ovibos/h1/kvs/table/`c'_reform`t'.gph, replace
drop a b max min 
clear matrix
}
restore

}



********************
set scheme s2mono

forvalues t=87/92 {

preserve

drop if reform`t'==.
keep if eligible==1
count

replace fodtaar=fodtaar-`threshold`t''


gen week2=.
forvalues i=-357(7)-7{
replace week2=`i' if fodtaar>=`i' & fodtaar<`i'+7
}				
forvalues i=0(7)357{
replace week2=`i' if fodtaar>=`i' & fodtaar<`i'+7
}
tab week2
sort week2
by week2: gen obs=_N

sum obs
by week2: egen mfodtaar=mean(fodtaar) 

gen g2=fodtaar if fodtaar<0
gen g3=fodtaar if fodtaar>=0

foreach c in memptot {

local varlabel: var label `c'


egen a=mean(`c')
egen b=sd(`c')
gen max=a+(0.5*b)
gen min=a-(0.5*b)
sum max min

sort mfodtaar
by mfodtaar: egen m`c'=mean(`c')

sort week2



sort fodtaar
sum m`c'

local miny=round(min,.1)
local maxy=round(max,.1)
sum week2
sort week2

twoway (scatter m`c' week2, msize(vsmall) msymbol(circle) mcolor(gs9))  (lfit `c' g2 [pw=triw`t'], lpattern(solid)) (lfit `c' g3 [pw=triw`t'], lpattern(solid)), graphregion(fcolor(white) lcolor(white)) ylabel(`miny'(.4)`maxy', nogrid angle(horisontal)) xlabel(-91 -77 -63 -49 -35 -21 -7 0 7 21 35 49 63 77 91) xtick(-91(7)91) xline(0, lpattern(shortdash)) xtitle(day of birth)  ytitle("`varlabel'") legend(off)
graph export /ssb/ovibos/h1/kvs/table/`c'_reform`t'.png,replace
graph save /ssb/ovibos/h1/kvs/table/`c'_reform`t'.gph, replace
drop a b max min 
clear matrix
}
restore

}

****
















forvalues t=87/92 {

preserve

drop if reform`t'==.
keep if eligible==1
count

replace fodtaar=fodtaar-`threshold`t''


gen week2=.
forvalues i=-357(7)-7{
replace week2=`i' if fodtaar>=`i' & fodtaar<`i'+7
}				
forvalues i=0(7)357{
replace week2=`i' if fodtaar>=`i' & fodtaar<`i'+7
}
tab week2
sort week2
by week2: gen obs=_N

sum obs
by week2: egen mfodtaar=mean(fodtaar) 

gen g2=fodtaar if fodtaar<0
gen g3=fodtaar if fodtaar>=0

foreach c in femptot {

local varlabel: var label `c'


egen a=mean(`c')
egen b=sd(`c')
gen max=a+(0.5*b)
gen min=a-(0.5*b)
sum max min

sort mfodtaar
by mfodtaar: egen m`c'=mean(`c')

sort week2



sort fodtaar
sum m`c'

local miny=round(min,.1)
local maxy=round(max,.1)
sum week2
sort week2

twoway (scatter m`c' week2, msize(vsmall) msymbol(circle) mcolor(gs9))  (lfit `c' g2 [pw=triw`t'], lpattern(solid)) (lfit `c' g3 [pw=triw`t'], lpattern(solid)), graphregion(fcolor(white) lcolor(white)) ylabel(`miny'(.2)`maxy', nogrid angle(horisontal)) xlabel(-91 -77 -63 -49 -35 -21 -7 0 7 21 35 49 63 77 91) xtick(-91(7)91) xline(0, lpattern(shortdash)) xtitle(day of birth)  ytitle("`varlabel'") legend(off)
graph export /ssb/ovibos/h1/kvs/table/`c'_reform`t'.png,replace
graph save /ssb/ovibos/h1/kvs/table/`c'_reform`t'.gph,replace
drop a b max min 
clear matrix
}
restore

}








forvalues t=87/92 {

preserve

drop if reform`t'==.
keep if eligible==1
count

replace fodtaar=fodtaar-`threshold`t''


gen week2=.
forvalues i=-357(7)-7{
replace week2=`i' if fodtaar>=`i' & fodtaar<`i'+7
}				
forvalues i=0(7)357{
replace week2=`i' if fodtaar>=`i' & fodtaar<`i'+7
}
tab week2
sort week2
by week2: gen obs=_N

sum obs
by week2: egen mfodtaar=mean(fodtaar) 

gen g2=fodtaar if fodtaar<0
gen g3=fodtaar if fodtaar>=0

foreach c in minctot{


local varlabel: var label `c'


egen a=mean(`c')
egen b=sd(`c')
gen max=a+(0.5*b)
gen min=a-(0.5*b)
sum max min

sort mfodtaar
by mfodtaar: egen m`c'=mean(`c')

sort week2



sort fodtaar
sum m`c'

local miny=round(min,1000)
local maxy=round(max,1000)
sum week2
sort week2
twoway (scatter m`c' week2, msize(vsmall) msymbol(circle) mcolor(gs9))  (lfit `c' g2 [pw=triw`t'], lpattern(solid)) (lfit `c' g3 [pw=triw`t'], lpattern(solid)), graphregion(fcolor(white) lcolor(white)) ylabel(`miny'(2000)`maxy', nogrid angle(horisontal)) xlabel(-91 -77 -63 -49 -35 -21 -7 0 7 21 35 49 63 77 91) xtick(-91(7)91) xline(0, lpattern(shortdash)) xtitle(day of birth)  ytitle("`varlabel'") legend(off)
graph export /ssb/ovibos/h1/kvs/table/`c'_reform`t'.png,replace
graph save /ssb/ovibos/h1/kvs/table/`c'_reform`t'.gph,replace
drop a b max min 
clear matrix
}
restore

}











forvalues t=87/92 {

preserve

drop if reform`t'==.
keep if eligible==1
count

replace fodtaar=fodtaar-`threshold`t''


gen week2=.
forvalues i=-357(7)-7{
replace week2=`i' if fodtaar>=`i' & fodtaar<`i'+7
}				
forvalues i=0(7)357{
replace week2=`i' if fodtaar>=`i' & fodtaar<`i'+7
}
tab week2
sort week2
by week2: gen obs=_N

sum obs
by week2: egen mfodtaar=mean(fodtaar) 

gen g2=fodtaar if fodtaar<0
gen g3=fodtaar if fodtaar>=0

foreach c in  finctot{


local varlabel: var label `c'


egen a=mean(`c')
egen b=sd(`c')
gen max=a+(0.5*b)
gen min=a-(0.5*b)
sum max min

sort mfodtaar
by mfodtaar: egen m`c'=mean(`c')

sort week2



sort fodtaar
sum m`c'

local miny=round(min,1000)
local maxy=round(max,1000)
sum week2
sort week2
twoway (scatter m`c' week2, msize(vsmall) msymbol(circle) mcolor(gs9))  (lfit `c' g2 [pw=triw`t'], lpattern(solid)) (lfit `c' g3 [pw=triw`t'], lpattern(solid)), graphregion(fcolor(white) lcolor(white)) ylabel(`miny'(4000)`maxy', nogrid angle(horisontal)) xlabel(-91 -77 -63 -49 -35 -21 -7 0 7 21 35 49 63 77 91) xtick(-91(7)91) xline(0, lpattern(shortdash)) xtitle(day of birth)  ytitle("`varlabel'") legend(off)
graph export /ssb/ovibos/h1/kvs/table/`c'_reform`t'.png,replace
graph save /ssb/ovibos/h1/kvs/table/`c'_reform`t'.gph,replace

drop a b max min 
clear matrix
}
restore

}




 




forvalues t=87/92 {

preserve

drop if reform`t'==.
keep if eligible==1
count

replace fodtaar=fodtaar-`threshold`t''


gen week2=.
forvalues i=-357(7)-7{
replace week2=`i' if fodtaar>=`i' & fodtaar<`i'+7
}				
forvalues i=0(7)357{
replace week2=`i' if fodtaar>=`i' & fodtaar<`i'+7
}
tab week2
sort week2
by week2: gen obs=_N

sum obs
by week2: egen mfodtaar=mean(fodtaar) 

gen g2=fodtaar if fodtaar<0
gen g3=fodtaar if fodtaar>=0

foreach c in ggemptot  {


local varlabel: var label `c'


egen a=mean(`c')
egen b=sd(`c')
gen max=a+(0.5*b)
gen min=a-(0.5*b)
sum max min

sort mfodtaar
by mfodtaar: egen m`c'=mean(`c')

sort week2



sort fodtaar
sum m`c'

local miny=round(min,.01)
local maxy=round(max,.01)
sum week2
sort week2
twoway (scatter m`c' week2, msize(vsmall) msymbol(circle) mcolor(gs9))  (lfit `c' g2 [pw=triw`t'], lpattern(solid)) (lfit `c' g3 [pw=triw`t'], lpattern(solid)), graphregion(fcolor(white) lcolor(white)) ylabel(`miny'(.01)`maxy', nogrid angle(horisontal)) xlabel(-91 -77 -63 -49 -35 -21 -7 0 7 21 35 49 63 77 91) xtick(-91(7)91) xline(0, lpattern(shortdash)) xtitle(day of birth)  ytitle("`varlabel'") legend(off)
graph export /ssb/ovibos/h1/kvs/table/`c'_reform`t'.png,replace
graph save /ssb/ovibos/h1/kvs/table/`c'_reform`t'.gph,replace
drop a b max min 
clear matrix
}
restore

}












forvalues t=87/92 {

preserve

drop if reform`t'==.
keep if eligible==1
count

replace fodtaar=fodtaar-`threshold`t''


gen week2=.
forvalues i=-357(7)-7{
replace week2=`i' if fodtaar>=`i' & fodtaar<`i'+7
}				
forvalues i=0(7)357{
replace week2=`i' if fodtaar>=`i' & fodtaar<`i'+7
}
tab week2
sort week2
by week2: gen obs=_N

sum obs
by week2: egen mfodtaar=mean(fodtaar) 

gen g2=fodtaar if fodtaar<0
gen g3=fodtaar if fodtaar>=0

foreach c in gginctot {


local varlabel: var label `c'


egen a=mean(`c')
egen b=sd(`c')
gen max=a+(0.5*b)
gen min=a-(0.5*b)
sum max min

sort mfodtaar
by mfodtaar: egen m`c'=mean(`c')

sort week2



sort fodtaar
sum m`c'

local miny=round(min,.01)
local maxy=round(max,.01)
sum week2
sort week2
twoway (scatter m`c' week2, msize(vsmall) msymbol(circle) mcolor(gs9))  (lfit `c' g2 [pw=triw`t'], lpattern(solid)) (lfit `c' g3 [pw=triw`t'], lpattern(solid)), graphregion(fcolor(white) lcolor(white)) ylabel(`miny'(.02)`maxy', nogrid angle(horisontal)) xlabel(-91 -77 -63 -49 -35 -21 -7 0 7 21 35 49 63 77 91) xtick(-91(7)91) xline(0, lpattern(shortdash)) xtitle(day of birth)  ytitle("`varlabel'") legend(off)
graph export /ssb/ovibos/h1/kvs/table/`c'_reform`t'.png,replace
graph save /ssb/ovibos/h1/kvs/table/`c'_reform`t'.gph,replace
drop a b max min 
clear matrix
}
restore

}



***************

forvalues t=87/92 {

preserve

drop if reform`t'==.
keep if eligible==1
count

replace fodtaar=fodtaar-`threshold`t''


gen week2=.
forvalues i=-357(7)-7{
replace week2=`i' if fodtaar>=`i' & fodtaar<`i'+7
}				
forvalues i=0(7)357{
replace week2=`i' if fodtaar>=`i' & fodtaar<`i'+7
}
tab week2
sort week2
by week2: gen obs=_N

sum obs
by week2: egen mfodtaar=mean(fodtaar) 

gen g2=fodtaar if fodtaar<0
gen g3=fodtaar if fodtaar>=0

foreach c in nchild14 {


local varlabel: var label `c'


egen a=mean(`c')
egen b=sd(`c')
gen max=a+(0.5*b)
gen min=a-(0.5*b)
sum max min

sort mfodtaar
by mfodtaar: egen m`c'=mean(`c')

sort week2



sort fodtaar
sum m`c'

local miny=round(min,.01)
local maxy=round(max,.01)
sum week2
sort week2
twoway (scatter m`c' week2, msize(vsmall) msymbol(circle) mcolor(gs9))  (lfit `c' g2 [pw=triw`t'], lpattern(solid)) (lfit `c' g3 [pw=triw`t'], lpattern(solid)), graphregion(fcolor(white) lcolor(white)) ylabel(`miny’(.1)`maxy', nogrid angle(horisontal)) xlabel(-91 -77 -63 -49 -35 -21 -7 0 7 21 35 49 63 77 91) xtick(-91(7)91) xline(0, lpattern(shortdash)) xtitle(day of birth)  ytitle("`varlabel'") legend(off)
graph export /ssb/ovibos/h1/kvs/table/`c'_reform`t'.png,replace
graph save /ssb/ovibos/h1/kvs/table/`c'_reform`t'.gph,replace
drop a b max min 
clear matrix
}
restore

}

***************





forvalues t=87/92 {

preserve

drop if reform`t'==.
keep if eligible==1
count

replace fodtaar=fodtaar-`threshold`t''


gen week2=.
forvalues i=-357(7)-7{
replace week2=`i' if fodtaar>=`i' & fodtaar<`i'+7
}				
forvalues i=0(7)357{
replace week2=`i' if fodtaar>=`i' & fodtaar<`i'+7
}
tab week2
sort week2
by week2: gen obs=_N

sum obs
by week2: egen mfodtaar=mean(fodtaar) 

gen g2=fodtaar if fodtaar<0
gen g3=fodtaar if fodtaar>=0

foreach c in abenefits {


local varlabel: var label `c'


egen a=mean(`c')
egen b=sd(`c')
gen max=a+(0.5*b)
gen min=a-(0.5*b)
sum max min

sort mfodtaar
by mfodtaar: egen m`c'=mean(`c')

sort week2



sort fodtaar
sum m`c'
local miny=round(min,1000)
local maxy=round(max,1000)

sum week2
sort week2
twoway (scatter m`c' week2, msize(vsmall) msymbol(circle) mcolor(gs9))  (lfit `c' g2 [pw=triw`t'], lpattern(solid)) (lfit `c' g3 [pw=triw`t'], lpattern(solid)), graphregion(fcolor(white) lcolor(white)) ylabel(`miny'(500)`maxy', nogrid angle(horisontal)) xlabel(-91 -77 -63 -49 -35 -21 -7 0 7 21 35 49 63 77 91) xtick(-91(7)91) xline(0, lpattern(shortdash)) xtitle(day of birth)  ytitle("`varlabel'") legend(off)
graph export /ssb/ovibos/h1/kvs/table/`c'_reform`t'.png,replace
graph save /ssb/ovibos/h1/kvs/table/`c'_reform`t'.gph,replace
drop a b max min 
clear matrix
}
restore

}






forvalues t=87/92 {

preserve

drop if reform`t'==.
keep if eligible==1
count

replace fodtaar=fodtaar-`threshold`t''


gen week2=.
forvalues i=-357(7)-7{
replace week2=`i' if fodtaar>=`i' & fodtaar<`i'+7
}				
forvalues i=0(7)357{
replace week2=`i' if fodtaar>=`i' & fodtaar<`i'+7
}
tab week2
sort week2
by week2: gen obs=_N

sum obs
by week2: egen mfodtaar=mean(fodtaar) 

gen g2=fodtaar if fodtaar<0
gen g3=fodtaar if fodtaar>=0

foreach c in askatt {


local varlabel: var label `c'


egen a=mean(`c')
egen b=sd(`c')
gen max=a+(0.5*b)
gen min=a-(0.5*b)
sum max min

sort mfodtaar
by mfodtaar: egen m`c'=mean(`c')

sort week2



sort fodtaar
sum m`c'
local miny=round(min,1000)
local maxy=round(max,1000)

sum week2
sort week2
twoway (scatter m`c' week2, msize(vsmall) msymbol(circle) mcolor(gs9))  (lfit `c' g2 [pw=triw`t'], lpattern(solid)) (lfit `c' g3 [pw=triw`t'], lpattern(solid)), graphregion(fcolor(white) lcolor(white)) ylabel(`miny'(2500)`maxy', nogrid angle(horisontal)) xlabel(-91 -77 -63 -49 -35 -21 -7 0 7 21 35 49 63 77 91) xtick(-91(7)91) xline(0, lpattern(shortdash)) xtitle(day of birth)  ytitle("`varlabel'") legend(off)
graph export /ssb/ovibos/h1/kvs/table/`c'_reform`t'.png,replace
graph save /ssb/ovibos/h1/kvs/table/`c'_reform`t'.gph,replace
drop a b max min 
clear matrix
}
restore

}

*********COST DIRECT*****

forvalues t=87/92 {

preserve

drop if reform`t'==.
keep if eligible==1
count

replace fodtaar=fodtaar-`threshold`t''


gen week2=.
forvalues i=-357(7)-7{
replace week2=`i' if fodtaar>=`i' & fodtaar<`i'+7
}				
forvalues i=0(7)357{
replace week2=`i' if fodtaar>=`i' & fodtaar<`i'+7
}
tab week2
sort week2
by week2: gen obs=_N

sum obs
by week2: egen mfodtaar=mean(fodtaar) 

gen g2=fodtaar if fodtaar<0
gen g3=fodtaar if fodtaar>=0

foreach c in cost_direct {


local varlabel: var label `c'


egen a=mean(`c')
egen b=sd(`c')
gen max=a+(0.5*b)
gen min=a-(0.5*b)
sum max min

sort mfodtaar
by mfodtaar: egen m`c'=mean(`c')

sort week2



sort fodtaar
sum m`c'
local miny=round(min,1000)
local maxy=round(max,1000)

sum week2
sort week2
twoway (scatter m`c' week2, msize(vsmall) msymbol(circle) mcolor(gs9))  (lfit `c' g2 [pw=triw`t'], lpattern(solid)) (lfit `c' g3 [pw=triw`t'], lpattern(solid)), graphregion(fcolor(white) lcolor(white)) ylabel(`miny’(1000)`maxy', nogrid angle(horisontal)) xlabel(-91 -77 -63 -49 -35 -21 -7 0 7 21 35 49 63 77 91) xtick(-91(7)91) xline(0, lpattern(shortdash)) xtitle(day of birth)  ytitle("`varlabel'") legend(off)
graph export /ssb/ovibos/h1/kvs/table/`c'_reform`t'.png,replace
graph save /ssb/ovibos/h1/kvs/table/`c'_reform`t'.gph,replace
drop a b max min 
clear matrix
}
restore

}




*********


forvalues t=87/92 {

preserve

drop if reform`t'==.
keep if eligible==1
count

replace fodtaar=fodtaar-`threshold`t''


gen week2=.
forvalues i=-357(7)-7{
replace week2=`i' if fodtaar>=`i' & fodtaar<`i'+7
}				
forvalues i=0(7)357{
replace week2=`i' if fodtaar>=`i' & fodtaar<`i'+7
}
tab week2
sort week2
by week2: gen obs=_N

sum obs
by week2: egen mfodtaar=mean(fodtaar) 

gen g2=fodtaar if fodtaar<0
gen g3=fodtaar if fodtaar>=0

foreach c in divorce {


local varlabel: var label `c'


egen a=mean(`c')
egen b=sd(`c')
gen max=a+(0.5*b)
gen min=a-(0.5*b)
sum max min

sort mfodtaar
by mfodtaar: egen m`c'=mean(`c')

sort week2



sort fodtaar
sum m`c'
local miny=round(min,.01)
local maxy=round(max,.01)

sum week2
sort week2
twoway (scatter m`c' week2, msize(vsmall) msymbol(circle) mcolor(gs9))  (lfit `c' g2 [pw=triw`t'], lpattern(solid)) (lfit `c' g3 [pw=triw`t'], lpattern(solid)), graphregion(fcolor(white) lcolor(white)) ylabel(`miny’(0.04)`maxy', nogrid angle(horisontal)) xlabel(-91 -77 -63 -49 -35 -21 -7 0 7 21 35 49 63 77 91) xtick(-91(7)91) xline(0, lpattern(shortdash)) xtitle(day of birth)  ytitle("`varlabel'") legend(off)
graph export /ssb/ovibos/h1/kvs/table/`c'_reform`t'.png,replace
graph save /ssb/ovibos/h1/kvs/table/`c'_reform`t'.gph,replace
drop a b max min 
clear matrix
}
restore

}


forvalues t=87/92 {

preserve

drop if reform`t'==.
keep if eligible==1
count

replace fodtaar=fodtaar-`threshold`t''


gen week2=.
forvalues i=-357(7)-7{
replace week2=`i' if fodtaar>=`i' & fodtaar<`i'+7
}				
forvalues i=0(7)357{
replace week2=`i' if fodtaar>=`i' & fodtaar<`i'+7
}
tab week2
sort week2
by week2: gen obs=_N

sum obs
by week2: egen mfodtaar=mean(fodtaar) 

gen g2=fodtaar if fodtaar<0
gen g3=fodtaar if fodtaar>=0

foreach c in marryb_14 {


local varlabel: var label `c'


egen a=mean(`c')
egen b=sd(`c')
gen max=a+(0.5*b)
gen min=a-(0.5*b)
sum max min

sort mfodtaar
by mfodtaar: egen m`c'=mean(`c')

sort week2



sort fodtaar
sum m`c'
local miny=round(min,.01)
local maxy=round(max,.01)

sum week2
sort week2
twoway (scatter m`c' week2, msize(vsmall) msymbol(circle) mcolor(gs9))  (lfit `c' g2 [pw=triw`t'], lpattern(solid)) (lfit `c' g3 [pw=triw`t'], lpattern(solid)), graphregion(fcolor(white) lcolor(white)) ylabel(`miny’(0.05)`maxy', nogrid angle(horisontal)) xlabel(-91 -77 -63 -49 -35 -21 -7 0 7 21 35 49 63 77 91) xtick(-91(7)91) xline(0, lpattern(shortdash)) xtitle(day of birth)  ytitle("`varlabel'") legend(off)
graph export /ssb/ovibos/h1/kvs/table/`c'_reform`t'.png,replace
graph save /ssb/ovibos/h1/kvs/table/`c'_reform`t'.gph,replace
drop a b max min 
clear matrix
}
restore

}




***unpaid leave 92, days

gen mluptot_wk=mluptot*4*7


label var mluptot_wk “days of unpaid leave"


forvalues t=92/92 {

preserve

drop if reform`t'==.
keep if eligible==1
count

replace fodtaar=fodtaar-`threshold`t''


gen week2=.
forvalues i=-357(7)-7{
replace week2=`i' if fodtaar>=`i' & fodtaar<`i'+7
}				
forvalues i=0(7)357{
replace week2=`i' if fodtaar>=`i' & fodtaar<`i'+7
}
tab week2
sort week2
by week2: gen obs=_N

sum obs
by week2: egen mfodtaar=mean(fodtaar) 

gen g2=fodtaar if fodtaar<0
gen g3=fodtaar if fodtaar>=0

foreach c in mluptot_wk{


local varlabel: var label `c'


egen a=mean(`c')
egen b=sd(`c')
gen max=a+(0.5*b)
gen min=a-(0.5*b)
sum max min

sort mfodtaar
by mfodtaar: egen m`c'=mean(`c')

sort week2



sort fodtaar
sum m`c'

local miny=round(min,1)
local maxy=round(max,1)
sum week2
sort week2
twoway (scatter m`c' week2, msize(vsmall) msymbol(circle) mcolor(gs9))  (lfit `c' g2 [pw=triw`t'], lpattern(solid)) (lfit `c' g3 [pw=triw`t'], lpattern(solid)), graphregion(fcolor(white) lcolor(white)) ytick(`miny'(10)`maxy') ylabel(`miny'(1)`maxy', angle(horisontal)) xlabel(-91 -77 -63 -49 -35 -21 -7 0 7 21 35 49 63 77 91) xtick(-91(7)91) xline(0, lpattern(shortdash)) xtitle(day of birth)  ytitle("`varlabel'") legend(off)
graph export /ssb/ovibos/a1/swp/kav/wk24/allreforms/graph/`c'_reform`t'.png,replace

drop a b max min 
clear matrix
}
restore

}




log close






















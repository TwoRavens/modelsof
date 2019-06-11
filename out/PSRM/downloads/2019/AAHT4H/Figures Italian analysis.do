
 use "italian_municipal.dta"


 rename comune Municipality

 rename anno Year
 
 *Dropping dublications in master*
sort Municipality Year
quietly by Municipality Year:  gen dup = cond(_N==1,0,_n)
drop if dup!=0

merge 1:m Municipality Year using "italian_municipal_turnout.dta"



*Generation of numerical identification for municipalities and regions*
encode Municipality, gen (id_comune)
rename codente id_codente

*diff-in-disc sample selection:
drop if Year<1999|Year>2004
drop if popcens<3500|popcens>7000


*generatation of analysis variables (From Grembi et al. (2016):
gen treatment_t=(popcens<5000&Year>2000&Year<2005) if Year!=.|popcens!=.
gen treatment_t_int1=(popcens-5000) if popcens!=.&treatment_t!=. 
replace treatment_t_int1=0 if treatment_t==0
gen treatment_t_int2=treatment_t_int1*treatment_t_int1
gen treatment_t_int3=treatment_t_int1*treatment_t_int1*treatment_t_int1
gen treatment_t_int4= treatment_t_int1*treatment_t_int1*treatment_t_int1*treatment_t_int1
gen treatment_t_int5=treatment_t_int1*treatment_t_int1*treatment_t_int1*treatment_t_int1*treatment_t_int1
gen postper=(Year>2000&Year<2005) if Year!=.
gen postper_int1=(popcens-5000) if popcens!=.&postper!=. 
replace postper_int1=0 if postper==0
gen postper_int2=postper_int1*postper_int1
gen postper_int3=postper_int1*postper_int1*postper_int1
gen postper_int4= postper_int1*postper_int1*postper_int1*postper_int1
gen postper_int5=postper_int1*postper_int1*postper_int1*postper_int1*postper_int1
g pop5000=popcens-5000
g t5000=0 & popcens!=.
replace t5000=1 if popcens<5000
g t5000_int1=t5000*pop5000
gen t5000_int4=t5000_int1*t5000_int1*t5000_int1*t5000_int1
gen t5000_int5=t5000_int1*t5000_int1*t5000_int1*t5000_int1*t5000_int1
gen pop5000_4=pop5000*pop5000*pop5000*pop5000 
gen pop5000_5=pop5000*pop5000*pop5000*pop5000*pop5000
g pop5000_2= pop5000^2
g t5000_int2=t5000*pop5000_2
g pop5000_3= pop5000^3
g t5000_int3=t5000*pop5000_3


*Generation of datasets with municpal differences in turnout across the analyzed years*
g pluto=popcens if Year==2001
egen paperino=max(pluto),by(id_codente)
drop popcens pluto
rename paperino popcens

forvalues i=2001(1)2004{

preserve
keep if Year==1999|Year==`i'

collapse Turnout popcens,by(id_codente postper)
sort id_codente postper
bysort id_codente: g N=_N
keep if N==2
bysort id_codente: g diff_turnout=Turnout-Turnout[_n-1]

bysort id_codente: g n=_n
keep if n==2

save data_diff_1999_`i'.dta,replace
restore
}

forvalues i=2001(1)2004{

preserve
keep if Year==2000|Year==`i'

collapse Turnout popcens ,by(id_codente postper)
sort id_codente postper
bysort id_codente: g N=_N
keep if N==2
bysort id_codente: g diff_turnout=Turnout-Turnout[_n-1]
bysort id_codente: g n=_n
keep if n==2

save data_diff_2000_`i'.dta,replace
restore
}


use data_diff_2000_2004,clear
append using data_diff_2000_2003.dta
append using data_diff_2000_2002.dta
append using data_diff_2000_2001.dta
append using data_diff_1999_2004.dta
append using data_diff_1999_2003.dta
append using data_diff_1999_2002.dta
append using data_diff_1999_2001.dta

g pop5000=popcens-5000
g t5000=0
replace t5000=1 if popcens>=5000
g t5000_int1=t5000*pop5000
gen t5000_int4=t5000_int1*t5000_int1*t5000_int1*t5000_int1
gen t5000_int5=t5000_int1*t5000_int1*t5000_int1*t5000_int1*t5000_int1
gen pop5000_4=pop5000*pop5000*pop5000*pop5000
gen pop5000_5=pop5000*pop5000*pop5000*pop5000*pop5000
g pop5000_2= pop5000^2
g t5000_int2=t5000*pop5000_2
g pop5000_3= pop5000^3
g t5000_int3=t5000*pop5000_3


*Figure 3. Manuel generation of figure excluding outlier and 90 percent confidence intervals*
reg diff_turnout pop5000 pop5000_2 pop5000_3 if pop5000<0& diff_turnout>-0.6
predict yhat_left2 if pop5000& diff_turnout>-0.6
predict SE_left2 if pop5000<0& diff_turnout>-0.6, stdp
gen low_left2 = yhat_left2 - 1.645*(SE_left2)
gen high_left2 = yhat_left2 + 1.645*(SE_left2)

reg diff_turnout pop5000 pop5000_2 pop5000_3 if pop5000>=0& diff_turnout<0.6
predict yhat_right2 if pop5000>0& diff_turnout<0.6
predict SE_right2 if pop5000>0& diff_turnout <0.6, stdp
gen low_right2 = yhat_right2 - 1.645*(SE_right2)
gen high_right2 = yhat_right2 + 1.645*(SE_right2)

twoway (scatter diff_turnout pop5000  if pop5000<1500&pop5000>-1500 & diff_turnout<0.6,msymbol(circle_hollow) mcolor(gray)) (line yhat_left2 low_left2 high_left2 pop5000 if pop5000<0&pop5000>-1500,  lcolor(black) pstyle(p p3 p3) sort)(line yhat_right2 low_right2 high_right2 pop5000 if pop5000>0&pop5000<1500, lcolor(black) pstyle (p p3 p3) sort) , ytitle("Difference in turnout",margin(medsmall)) xtitle("Distance to threshold",margin(medsmall)) graphregion(color(white)) bgcolor(white) legend(off) xline(0, lcolor(black)) xlabel(-1500 0 1500) 
graph export figure3.tif


*Figure G1: Manual generation of figure with 90 percent confidence intervals*
reg diff_turnout pop5000 pop5000_2 pop5000_3 if pop5000<0
predict yhat_left3 if pop5000& diff_turnout>-500
predict SE_left3 if pop5000<0& diff_turnout>-500, stdp
gen low_left3 = yhat_left3 - 1.645*(SE_left3)
gen high_left3 = yhat_left3 + 1.645*(SE_left3)

reg diff_turnout pop5000 pop5000_2 pop5000_3 if pop5000>=0
predict yhat_right3 if pop5000>0& diff_turnout<500
predict SE_right3 if pop5000>0& diff_turnout <500, stdp
gen low_right3 = yhat_right3 - 1.645*(SE_right3)
gen high_right3 = yhat_right3 + 1.645*(SE_right3)

twoway (scatter diff_turnout pop5000 if pop5000<1500&pop5000>-1500,msymbol(circle_hollow) mcolor(gray)) (line yhat_left3 low_left3 high_left3 pop5000 if pop5000<0&pop5000>-1500,  lcolor(black) pstyle(p p3 p3) sort)(line yhat_right3 low_right3 high_right3 pop5000 if pop5000>0&pop5000<1500, lcolor(black) pstyle (p p3 p3) sort) , ytitle("Difference in turnout",margin(medsmall)) xtitle("Distance to threshold",margin(medsmall)) graphregion(color(white)) bgcolor(white) legend(off) xline(0, lcolor(black)) xlabel(-1500 0 1500) 
graph export figureg1.tif



*Figures with 95 percent confidence intervals*

*Manual generation of figure*
reg diff_turnout pop5000 pop5000_2 pop5000_3 if pop5000<0
predict yhat_left if pop5000& diff_turnout>-500
predict SE_left if pop5000<0& diff_turnout>-500, stdp
gen low_left = yhat_left - 1.96*(SE_left)
gen high_left = yhat_left + 1.96*(SE_left)

reg diff_turnout pop5000 pop5000_2 pop5000_3 if pop5000>=0
predict yhat_right if pop5000>0& diff_turnout<500
predict SE_right if pop5000>0& diff_turnout <500, stdp
gen low_right = yhat_right - 1.96*(SE_right)
gen high_right = yhat_right + 1.96*(SE_right)

twoway (scatter diff_turnout pop5000 if pop5000<1500&pop5000>-1500,msymbol(circle_hollow) mcolor(gray)) (line yhat_left low_left high_left pop5000 if pop5000<0&pop5000>-1500,  lcolor(black) pstyle(p p3 p3) sort)(line yhat_right low_right high_right pop5000 if pop5000>0&pop5000<1500, lcolor(black) pstyle (p p3 p3) sort) , ytitle("Difference in turnout",margin(medsmall)) xtitle("Distance to threshold",margin(medsmall)) graphregion(color(white)) bgcolor(white) legend(off) xline(0, lcolor(black)) xlabel(-1500 0 1500) 

* Manuel generation of figure excluding outlier*
reg diff_turnout pop5000 pop5000_2 pop5000_3 if pop5000<0& diff_turnout>-0.6
predict yhat_left1 if pop5000& diff_turnout>-0.6
predict SE_left1 if pop5000<0& diff_turnout>-0.05, stdp
gen low_left1 = yhat_left1 - 1.96*(SE_left1)
gen high_left1 = yhat_left1 + 1.96*(SE_left1)

reg diff_turnout pop5000 pop5000_2 pop5000_3 if pop5000>=0& diff_turnout<0.6
predict yhat_right1 if pop5000>0& diff_turnout<0.6
predict SE_right1 if pop5000>0& diff_turnout <0.6, stdp
gen low_right1 = yhat_right1 - 1.96*(SE_right1)
gen high_right1 = yhat_right1 + 1.96*(SE_right1)

twoway (scatter diff_turnout pop5000 if pop5000<1500&pop5000>-1500& diff_turnout<0.6 ,msymbol(circle_hollow) mcolor(gray)) (line yhat_left1 low_left1 high_left1 pop5000 if pop5000<0&pop5000>-1500,  lcolor(black) pstyle(p p3 p3) sort)(line yhat_right1 low_right1 high_right1 pop5000 if pop5000>0&pop5000<1500, lcolor(black) pstyle (p p3 p3) sort) , ytitle("Difference in turnout",margin(medsmall)) xtitle("Distance to threshold",margin(medsmall)) graphregion(color(white)) bgcolor(white) legend(off) xline(0, lcolor(black)) xlabel(-1500 0 1500) 


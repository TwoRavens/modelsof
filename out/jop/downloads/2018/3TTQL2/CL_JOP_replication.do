/*
Code for replicating results in:
"Casual Physical Contact and Out-group Bias: Experimental Evidence from Afghanistan"
Journal of Politics
Luke N. Condra and Sera Linardi
*/

use CL_JOP_replication.dta, clear


** nonpashtun giving to nonpashtun (Ingroup)
gen ingroup = treat==0
** nonpashtun giving to pashtun (out-group abstract)
gen outabstract= treat==1
** nonpashtun and pashtuns (in a mixed group) giving to pashtun (out group real)
gen outreal = treat==11
*** experimental treatments 
replace treat=. if pashtun /* this ensures no pashtuns are included when we use treat */
gen treat2=treat
replace treat2=2 if treat==11

* young, speakpashto
gen speakpashto = native==1 | otherlanguagea==1 | otherlanguageb==1
*gen speakdari = nativelanguage==2 | otherlanguagea == 2 | otherlanguageb == 2
sum age, detail
*gen young = age<30
gen edu_years = specificeducationlevel
replace edu_years = 0 if specificeducationlevel==. 
gen notmarried = !marital_status

gen monthlyk = monthlyincome/1000
*gen amtifgive = amount if amount>0

gen daysession = day*100+session


* Demographics across Treatments  - Table 1 and Appendix Table 1

*Table 1. Descriptive statistics on demographics and giving
sort treat
*Table 1.Panel A
sum amount age lang_count marital_status education_none specificeducationlevel monthlyincome timeofoccupationyear if !pashtun

*Table 1.Panel B,C,D, E
bysort treat: sum amount age lang_count marital_status education_none specificeducationlevel monthlyincome timeofoccupationyear 

* Appendix Table A1: Balance table

ttest age if   !outreal, by(treat)
ttest age if   !outabstract, by(treat)
ttest age if   !ingroup, by(treat)
ttest age if outreal, by(pashtun)

ttest lang_count if   !outreal, by(treat)
ttest lang_count if   !outabstract, by(treat)
ttest lang_count if   !ingroup, by(treat)
ttest lang_count if outreal, by(pashtun)

ttest marital_status if   !outreal, by(treat)
ttest marital_status  if   !outabstract, by(treat)
ttest marital_status  if   !ingroup, by(treat)
ttest marital_status if outreal, by(pashtun)

ttest education_none if   !outreal, by(treat)
ttest education_none if   !outabstract, by(treat)
ttest education_none if   !ingroup, by(treat)
ttest education_none if outreal, by(pashtun)

ttest specificeducationlevel if   !outreal, by(treat)
ttest specificeducationlevel if   !outabstract, by(treat)
ttest specificeducationlevel if   !ingroup, by(treat)
ttest specificeducationlevel if outreal, by(pashtun)

ttest monthlyincome if   !outreal, by(treat)
ttest monthlyincome if   !outabstract, by(treat)
ttest monthlyincome if   !ingroup, by(treat)
ttest monthlyincome if outreal, by(pashtun)

ttest timeofoccupationyear  if !outreal, by(treat)
ttest timeofoccupationyear  if !outabstract, by(treat)
ttest timeofoccupationyear  if !ingroup, by(treat)
ttest timeofoccupationyear if outreal, by(pashtun)

************************************************************************************
*Figure 1-Kernel Density Plots of non-Pashtun minorities’ Contributions to EMERGENCY Hospital across all treatments
twoway kdensity amount if treat==0 || kdensity amount if treat==1 || kdensity amount if treat==11, bwidth(5) legend(order(1 "In-NoContact" 2 "Out-NoContact" 3 "Out-Contact")) xtitle("Amount given (including 0)") graphregion(color(white)) 

* Table 2: Session averages (robustness)
quietly bysort daysession pashtun:  gen duplicate = _n if !pashtun
egen s_amount = mean(amount) if !pashtun, by(daysession)
bysort treat: sum s_amount if duplicate==1

* Calculating pashtun giving in out-contact at session level
gen nonpashtun = !pashtun
quietly bysort daysession nonpashtun:  gen duplicate2 = _n if pashtun
egen s_amount2 = mean(amount) if pashtun, by(daysession)
bysort treat: sum s_amount2 if duplicate2==1
replace s_amount = s_amount2 if duplicate2==1
replace duplicate = duplicate2 if duplicate2==1

* Individual level tests
ranksum amount if !outreal, by(treat)
ranksum amount if !outabstract, by(treat)
ranksum amount if !ingroup, by(treat)
ranksum amount if outreal, by(pashtun)
/* Addressing freeriding
 or the right comparison for pashtun giving might be non-pashtun giving to pashtun in the Out sessions */
ranksum amount if (outreal & pashtun) | (outabstract), by(pashtun)

* Session level tests
*In-NoContact vs Out-NoContact
ranksum s_amount if !outreal & duplicate==1, by(treat) 
*In-NoContact vs Out-Contact
ranksum s_amount if !outabstract & duplicate==1, by(treat) 
*Out-NoContact vs Out-Contact
ranksum s_amount if !ingroup & duplicate==1, by(treat) 

ranksum s_amount if outreal & duplicate==1, by(pashtun) 
/* Addressing freeriding
 or the right comparison for pashtun giving might be non-pashtun giving to pashtun in the Out sessions */
ranksum s_amount if ((outreal & pashtun) | (outabstract)) & duplicate==1, by(pashtun)


**************************************************************************************

* splitting sessions into early and late
sum session, detail
sum session if day==1, detail  
sum session if day==2, detail
 
* last half of day 1 and day 2
gen late2 = (session >8.5 & outreal) | (session > 11 & !outreal)


**********************************************************************************************

drop if pashtun

*Figure 2a -Average Contributions of Early vs. Late Sessions
preserve
gen treat2group = treat2+late2*4
collapse (mean) meansrate= amount (sd) sdsrate = amount (count) n=amount, by(treat2group)
generate hisrate = meansrate + invttail(n-1,0.025)*(sdsrate / sqrt(n))
generate losrate = meansrate - invttail(n-1,0.025)*(sdsrate / sqrt(n))

/*
treatgroup2 = treat2 + late2*4 =
0 In-NoContact Early
1 Out-NoContact Early
2 Out-Contact Early
4 In-NoContact Late
5 Out-NoContact Late
6 Out-Contact Late
*/
twoway (bar meansrate treat2group if treat2group==0 | treat2group==4, color(gs0)) ///
(bar meansrate treat2group if treat2group==1 | treat2group==5,color(gs6)) ///
(bar meansrate treat2group if treat2group==2 | treat2group==6,color(gs12)) ///
(rcap hisrate losrate treat2group) ///
, graphregion(color(white)) legend(row(1)  order(1 "In-NoContact" 2 "Out-NoContact" 3 "Out-Contact") ) ///
xlabel( 1 "Early" 5 "Late", noticks) ///
xtitle(" ") ytitle("Amount (AFN)")
restore 


*Figure 2b Average Contributions of Non-Pashtuns (by ability to Speak Pashto)	 
preserve
gen treat2group = treat2+speakpashto*4
collapse (mean) meansrate= amount (sd) sdsrate = amount (count) n=amount, by(treat2group)
generate hisrate = meansrate + invttail(n-1,0.025)*(sdsrate / sqrt(n))
generate losrate = meansrate - invttail(n-1,0.025)*(sdsrate / sqrt(n))

/*
treatgroup2 = treat2 + late2*4 =
0 In-NoContact Do not speak
1 Out-NoContact Do not speak
2 Out-Contact Do not speak
4 In-NoContact Speak
5 Out-NoContact Speak
6 Out-Contact Speak
*/

twoway (bar meansrate treat2group if treat2group==0 | treat2group==4, color(gs0)) ///
(bar meansrate treat2group if treat2group==1 | treat2group==5,color(gs6)) ///
(bar meansrate treat2group if treat2group==2 | treat2group==6,color(gs12)) ///
(rcap hisrate losrate treat2group) ///
, graphregion(color(white)) legend(row(1)  order(1 "In-NoContact" 2 "Out-NoContact" 3 "Out-Contact") ) ///
xlabel( 1 "Do not speak Pashto" 5 "Speak Pashto", noticks) ///
xtitle(" ") ytitle("Amount (AFN)")
restore

* Table 3 (and SI Table 2). Effects of NoContact vs. Contact with Out-group on Contributions (and Appendix Table A4)
gen outabstract_pashto = outabstract*speakpashto
gen outreal_pashto = outreal*speakpashto

tobit amount outabstract outreal session i.interviewercode , cl(daysession) ll(0)
outreg2 using table3.xls, dec(2) excel replace 

tobit amount outabstract outreal session age lang_count notmarried edu_years ///
monthlyk timeofoccupationyear   i.interviewercode , cl(daysession) ll(0)
outreg2 using table3.xls, dec(2) excel append 

test age lang_count notmarried edu_years monthlyk timeofoccupationyear

*early 
tobit amount outabstract outreal session  age lang_count notmarried edu_years ///
monthlyk timeofoccupationyear   i.interviewercode if !late2 , cl(daysession) ll(0)
outreg2 using table3.xls, dec(2) excel append 

* late
tobit amount outabstract outreal session  age lang_count notmarried edu_years ///
monthlyk timeofoccupationyear   i.interviewercode if late2 , cl(daysession) ll(0)
outreg2 using table3.xls, dec(2) excel append 


** SI Table 3 (OLS version of Table 3)
reg amount outabstract outreal session i.interviewercode , cl(daysession)  
outreg2 using table3ols.xls, dec(2) excel replace 

reg amount outabstract outreal session age lang_count notmarried edu_years ///
monthlyk timeofoccupationyear   i.interviewercode , cl(daysession)  
outreg2 using table3ols.xls, dec(2) excel append 

*early 
reg amount outabstract outreal session  age lang_count notmarried edu_years ///
monthlyk timeofoccupationyear   i.interviewercode if !late2 , cl(daysession)  
outreg2 using table3ols.xls, dec(2) excel append 

* late
reg amount outabstract outreal session  age lang_count notmarried edu_years ///
monthlyk timeofoccupationyear   i.interviewercode if late2 , cl(daysession)  
outreg2 using table3ols.xls, dec(2) excel append 
 
 
*** Table 4 (and SI Table 4)

tobit amount outabstract outreal outabstract_pashto outreal_pashto session young speakpashto notmarried edu_years ///
monthlyincome timeofoccupationyear   i.interviewercode , cl(daysession) ll(0)
outreg2 using table4.xls, dec(2) excel replace
lincom outabstract+outabstract_pashto
lincom outreal+outreal_pashto

*early 
tobit amount outabstract outreal outabstract_pashto outreal_pashto session young speakpashto notmarried edu_years ///
monthlyincome timeofoccupationyear   i.interviewercode if !late2, cl(daysession)  ll(0)
outreg2 using table4.xls, dec(2) excel append
lincom outabstract+outabstract_pashto
lincom outreal+outreal_pashto

* late
tobit amount outabstract outreal outabstract_pashto outreal_pashto session young speakpashto notmarried edu_years ///
monthlyincome timeofoccupationyear   i.interviewercode if late2, cl(daysession)  ll(0)
outreg2 using table4.xls, dec(2) excel append
lincom outabstract+outabstract_pashto
lincom outreal+outreal_pashto


**SI Table 5 (OLS version of SI Table 4)
reg amount outabstract outreal outabstract_pashto outreal_pashto session young speakpashto notmarried edu_years ///
monthlyincome timeofoccupationyear   i.interviewercode , cl(daysession)  
outreg2 using table4ols.xls, dec(2) excel replace
lincom outabstract+outabstract_pashto
lincom outreal+outreal_pashto

*early 
reg amount outabstract outreal outabstract_pashto outreal_pashto session young speakpashto notmarried edu_years ///
monthlyincome timeofoccupationyear   i.interviewercode if !late2, cl(daysession)   
outreg2 using table4ols.xls, dec(2) excel append
lincom outabstract+outabstract_pashto
lincom outreal+outreal_pashto

* late
reg amount outabstract outreal outabstract_pashto outreal_pashto session young speakpashto notmarried edu_years ///
monthlyincome timeofoccupationyear   i.interviewercode if late2, cl(daysession)   
outreg2 using table4ols.xls, dec(2) excel append
lincom outabstract+outabstract_pashto
lincom outreal+outreal_pashto


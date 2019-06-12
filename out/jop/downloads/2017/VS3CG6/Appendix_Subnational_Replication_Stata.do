
*****************************************************
** Appendix
*****************************************************

clear
set more off

use "~SubnationalData.dta"

xtset mid
global controls singlebirth gender moth_age moth_agesq prevsib24 birthorder birthordersq

*****************************************************
** Section C: Summary Statistics
*****************************************************

gen male = 1 if gender == 1
replace male = 0 if gender == 2

***** Table C2 *****
estpost summarize infantmort childmort singlebirth male moth_age moth_agesq prevsib24 birthorder birthordersq if Country=="Malawi"
esttab using "Analysis/tables/summarystatsMalawi.tex", cells("mean(fmt(2)) sd(fmt(2)) min(fmt(2)) max(fmt(2))") noobs nonumber label title("Summary statistics") replace

***** Table C3 *****
estpost summarize infantmort childmort singlebirth male moth_age moth_agesq prevsib24 birthorder birthordersq if Country=="Nigeria"
esttab using "Analysis/tables/summarystatsNigeria.tex", cells("mean(fmt(2)) sd(fmt(2)) min(fmt(2)) max(fmt(2))") noobs nonumber label title("Summary statistics") replace

***** Table C4 *****
estpost summarize infantmort childmort singlebirth male moth_age moth_agesq prevsib24 birthorder birthordersq if Country=="Uganda"
esttab using "Analysis/tables/summarystatsUganda.tex", cells("mean(fmt(2)) sd(fmt(2)) min(fmt(2)) max(fmt(2))") noobs nonumber label title("Summary statistics") replace

*****************************************************
** Section E: Sub-national analysis
*****************************************************

***** Table E3 *****

** Summary Stats **
* First wave of splits in 1998 in Malawi, so use this for baseline
estpost summarize anyantenatal numantenatal mdnurse vitaminA iron bloodpressure urinesamp bloodsample malaria if (year==1998 & Country=="Malawi")
esttab using "Analysis/tables/summarystatsMalawiMech.tex", cells("mean(fmt(2)) sd(fmt(2))") noobs nonumber label title("Summary statistics Malawi") replace

* First wave of splits in 1997 in Uganda, so use this for baseline
estpost summarize anyantenatal numantenatal mdnurse vitaminA breastfeed iron bloodpressure urinesamp bloodsample malaria if (year==1997 & Country=="Uganda")
esttab using "Analysis/tables/summarystatsUgandaMech.tex", cells("mean(fmt(2)) sd(fmt(2))") noobs nonumber label title("Summary statistics Uganda") replace


** Mechanism Regressions **

foreach y in  anyantenatal numantenatal mdnurse vitaminA iron bloodpressure urinesamp bloodsample malaria  {

xtreg  `y' i.year i.TR if (split2!=1 & Country=="Malawi"), fe
est store mechMM_`y'

xtreg  `y' i.year i.TR_M if (TRS!=1 & Country=="Uganda"), fe
est store mechUM_`y'
}

***** Table E4 *****

** Summary Stats **
* First wave of splits in 1998 in Malawi, so use this for baseline
estpost summarize anyantenatal numantenatal mdnurse vitaminA iron bloodpressure urinesamp bloodsample malaria if (year==1998 & Country=="Malawi")
esttab using "Analysis/tables/summarystatsMalawiMech.tex", cells("mean(fmt(2)) sd(fmt(2))") noobs nonumber label title("Summary statistics Malawi") replace

* First wave of splits in 1997 in Uganda, so use this for baseline
estpost summarize anyantenatal numantenatal mdnurse vitaminA iron bloodpressure urinesamp bloodsample malaria if (year==1997 & Country=="Uganda")
esttab using "Analysis/tables/summarystatsUgandaMech.tex", cells("mean(fmt(2)) sd(fmt(2))") noobs nonumber label title("Summary statistics Uganda") replace

foreach y in  anyantenatal numantenatal mdnurse vitaminA iron bloodpressure urinesamp bloodsample malaria  {

xtreg  `y' i.year i.TR if (split2!=2 & Country=="Malawi"), fe
est store mechMM_`y'

xtreg  `y' i.year i.TR_S if (TRM!=2 & Country=="Uganda"), fe
est store mechUM_`y'
}

***** Table E5 *****
preserve

keep if Country=="Malawi"
drop if Splinter==.
xtset mid

* Create false splits for 5-10 years prior to actual split
* Malawi had 2 waves of splits in 1998 and 2003. Thus, we drop districts that split
* in 2003, and all years post 1998
drop if (Splinter==2003 | Mother ==2003)
drop if year>= 1998

gen TR_S5=0 
replace TR_S5=1 if (split1==1 & year>=1992)

gen TR_S6=0 
replace TR_S6=1 if (split1==1 & year>=1991)

gen TR_S7=0 
replace TR_S7=1 if (split1==1 & year>=1990)

gen TR_S8=0 
replace TR_S8=1 if (split1==1 & year>=1989)

gen TR_S9=0 
replace TR_S9=1 if (split1==1 & year>=1988)

gen TR_S10=0 
replace TR_S10=1 if (split1==1 & year>=1987)

foreach y in  infantmort childmort {
xtreg `y' $controls i.year TR_S5 if split2!=2, fe  vce (cluster mid)
est store falsM5_`y'
xtreg `y' $controls i.year TR_S6 if split2!=2, fe  vce (cluster mid)
est store falsM6_`y'
xtreg `y' $controls i.year TR_S7 if split2!=2, fe  vce (cluster mid)
est store falsM7_`y'
xtreg `y' $controls i.year TR_S8 if split2!=2, fe  vce (cluster mid)
est store falsM8_`y'
xtreg `y' $controls i.year TR_S9 if split2!=2, fe  vce (cluster mid)
est store falsM9_`y'
xtreg `y' $controls i.year TR_S10 if split2!=2, fe  vce (cluster mid)
est store falsM10_`y'
}

restore



***** Table E6 *****
preserve
keep if Country=="Nigeria"
drop if Splinter==.

* Create false splits for 5-10 years prior to actual split
* Nigeria had multiple waves of splits. Based on our data, we drop all years after
* 1987 [first split where we have data] and all districts that split later on in time
drop if (Splinter>1987 | Mother>1987)
drop if year>= 1987

gen TR_S5=0 
replace TR_S5=1 if (split1==1 & year>=1981)

gen TR_S6=0 
replace TR_S6=1 if (split1==1 & year>=1980)

gen TR_S7=0 
replace TR_S7=1 if (split1==1 & year>=1979)

gen TR_S8=0 
replace TR_S8=1 if (split1==1 & year>=1978)

gen TR_S9=0 
replace TR_S9=1 if (split1==1 & year>=1977)

gen TR_S10=0 
replace TR_S10=1 if (split1==1 & year>=1976)

foreach y in  infantmort childmort {
xtreg `y' $controls i.year TR_S5 if split2!=2, fe  vce (cluster mid)
est store falsN5_`y'
xtreg `y' $controls i.year TR_S6 if split2!=2, fe  vce (cluster mid)
est store falsN6_`y'
xtreg `y' $controls i.year TR_S7 if split2!=2, fe  vce (cluster mid)
est store falsN7_`y'
xtreg `y' $controls i.year TR_S8 if split2!=2, fe  vce (cluster mid)
est store falsN8_`y'
xtreg `y' $controls i.year TR_S9 if split2!=2, fe  vce (cluster mid)
est store falsN9_`y'
xtreg `y' $controls i.year TR_S10 if split2!=2, fe  vce (cluster mid)
est store falsN10_`y'
}
restore

***** Table E7 *****
preserve
keep if Country=="Uganda"
drop if wave1==.

* create indicator for splinter for false splits 5 to 10 years prior to first actual split
* First wave of splits in 1997 in Uganda, so use this for baseline
drop if year>= 1997
drop if (wave2>0 |wave3 >0 | wave4 >0)

gen TR_S5=0 
replace TR_S5=1 if (wave1==1 & year >=1991)

gen TR_S6=0 
replace TR_S6=1 if (wave1==1 & year >=1990)

gen TR_S7=0 
replace TR_S7=1 if (wave1==1 & year >=1989)

gen TR_S8=0 
replace TR_S8=1 if (wave1==1 & year >=1988)

gen TR_S9=0 
replace TR_S9=1 if (wave1==1 & year >=1987)

gen TR_S10=0 
replace TR_S10=1 if (wave1==1 & year >=1986)


*FE regressions - all splits included, all mechanisms, individual year effects

foreach y in  infantmort childmort {
xtreg `y' $controls i.year TR_S5 if TRM!=1, fe  vce (cluster mid)
est store falsU5_`y'
xtreg `y' $controls i.year TR_S6 if TRM!=1, fe  vce (cluster mid)
est store falsU6_`y'
xtreg `y' $controls i.year TR_S7 if TRM!=1, fe  vce (cluster mid)
est store falsU7_`y'
xtreg `y' $controls i.year TR_S8 if TRM!=1, fe  vce (cluster mid)
est store falsU8_`y'
xtreg `y' $controls i.year TR_S9 if TRM!=1, fe  vce (cluster mid)
est store falsU9_`y'
xtreg `y' $controls i.year TR_S10 if TRM!=1, fe  vce (cluster mid)
est store falsU10_`y'
}

restore

***** Figure E5 *****

preserve

egen uniqueid = concat(motherid DHSYEAR birthorder)
egen id=group(uniqueid)

xtset id year
keep if (year > 1980)


*** Infant Mortality ***
egen averageimw0 = mean(infantmort) if (initialsplit==0), by(year Country)
egen averageimw1 = mean(infantmort) if (initialsplit==1), by(year Country)
egen averageimw2 = mean(infantmort) if (initialsplit==2), by(year Country)

*** Child Mortality ***
egen averagecmw0 = mean(childmort) if (initialsplit==0), by(year Country)
egen averagecmw1 = mean(childmort) if (initialsplit==1), by(year Country)
egen averagecmw2 = mean(childmort) if (initialsplit==2), by(year Country)

*** Malawi ***
#delimit;
graph twoway (lowess averageimw0 year if Country=="Malawi", bwidth(2)) 
(lowess averageimw1 year  if Country=="Malawi", bwidth(2) lpattern(dash)) 
(lowess averageimw2 year if Country=="Malawi", bwidth(2) lpattern(shortdash_dot)),  name (MalawiIM)
tline(1998, lwidth(medium) lcolor(red)) tline(2003, lwidth(medium) lcolor(red)) 
title(Infant Mortality) subtitle(Lowess Fit)
xtitle (Year of Birth) ytitle(Infant Mortality) ylab(, grid) 
legend(ring(0) pos(8) lab(1 "Non-Splitting Districts") lab(2 "Splinter Districts") lab(3 "Mother Districts")) scheme(s1mono);
#delimit cr

#delimit;
graph twoway (lowess averagecmw0 year if Country=="Malawi", bwidth(2)) 
(lowess averagecmw1 year if Country=="Malawi", bwidth(2) lpattern(dash)) 
(lowess averagecmw2 year if Country=="Malawi", bwidth(2) lpattern(shortdash_dot)),  name(MalawiCM)
tline(1998, lwidth(medium) lcolor(red)) tline(2003, lwidth(medium) lcolor(red)) 
title(Child Mortality) subtitle(Lowess Fit)
xtitle (Year of Birth) ytitle(Child Mortality) ylab(, grid) 
legend(ring(0) pos(8) lab(1 "Non-Splitting Districts") lab(2 "Splinter Districts") lab(3 "Mother Districts")) scheme(s1mono);
#delimit cr


*** Nigeria ***

#delimit;
graph twoway (lowess averageimw0 year if Country=="Nigeria", bwidth(2)) 
(lowess averageimw1 year if Country=="Nigeria", bwidth(2) lpattern(dash)) 
(lowess averageimw2 year if Country=="Nigeria", bwidth(2) lpattern(shortdash_dot)),    name (NigeriaIM)
tline(1987, lwidth(medium) lcolor(red)) tline(1991, lwidth(medium) lcolor(red)) tline(1996, lwidth(medium) lcolor(red)) 
title(Infant Mortality) subtitle(Lowess Fit)
xtitle (Year of Birth) ytitle(Infant Mortality) ylab(, grid) 
legend(ring(0) pos(8) lab(1 "Non-Splitting Districts") lab(2 "Splinter Districts") lab(3 "Mother Districts")) scheme(s1mono);
#delimit cr


#delimit;
graph twoway (lowess averagecmw0 year if Country=="Nigeria", bwidth(2)) 
(lowess averagecmw1 year if Country=="Nigeria", bwidth(2) lpattern(dash)) 
(lowess averagecmw2 year if Country=="Nigeria", bwidth(2) lpattern(shortdash_dot)),  (NigeriaCM)
tline(1987, lwidth(medium) lcolor(red)) tline(1991, lwidth(medium) lcolor(red)) tline(1996, lwidth(medium) lcolor(red)) 
title(Child Mortality) subtitle(Lowess Fit)
xtitle (Year of Birth) ytitle(Child Mortality) ylab(, grid) 
legend(ring(0) pos(8) lab(1 "Non-Splitting Districts") lab(2 "Splinter Districts") lab(3 "Mother Districts")) scheme(s1mono);
#delimit cr


***Uganda ***

#delimit;
graph twoway (lowess averageimw0 year if Country=="Uganda", bwidth(2)) 
(lowess averageimw1 year if Country=="Uganda", bwidth(2) lpattern(dash)) 
(lowess averageimw2 year if Country=="Uganda", bwidth(2) lpattern(shortdash_dot)),  name (UgandaIM)
tline(1997, lwidth(medium) lcolor(red)) tline(2000, lwidth(medium) lcolor(red)) tline(2005, lwidth(medium) lcolor(red)) tline(2009, lwidth(medium) lcolor(red)) 
title(Infant Mortality) subtitle(Lowess Fit)
xtitle (Year of Birth) ytitle(Infant Mortality) ylab(, grid) 
legend(ring(0) pos(8) lab(1 "Non-Splitting Districts") lab(2 "Splinter Districts") lab(3 "Mother Districts")) scheme(s1mono);
#delimit cr


#delimit;
graph twoway (lowess averagecmw0 year if Country=="Uganda", bwidth(2)) 
(lowess averagecmw1 year if Country=="Uganda", bwidth(2) lpattern(dash)) 
(lowess averagecmw2 year if Country=="Uganda", bwidth(2) lpattern(shortdash_dot)), name (UgandaIM)
tline(1987, lwidth(medium) lcolor(red)) tline(1991, lwidth(medium) lcolor(red)) tline(1996, lwidth(medium) lcolor(red)) 
title(Child Mortality) subtitle(Lowess Fit)
xtitle (Year of Birth) ytitle(Child Mortality) ylab(, grid) 
legend(ring(0) pos(8) lab(1 "Non-Splitting Districts") lab(2 "Splinter Districts") lab(3 "Mother Districts")) scheme(s1mono);
#delimit cr


graph combine MalawiIM NigeriaIM UgandaIM MalawiCM NigeriaCM UgandaCM
restore

***** Table E8 *****

*** Malawi ***
foreach y in  infantmort childmort {

xtreg `y' $controls i.year i.TR if (split1!=1 & Country=="Malawi") , fe vce (cluster mid)
xtreg `y' $controls i.year time_mother if (split1!=1 & Country=="Malawi") , fe vce (cluster mid)
*Drop all years post 2003 [the second wave of splits begins in 2003]
xtreg `y' $controls i.year i.TR if (split1!=1 & Country=="Malawi" & year<2003) , fe vce (cluster mid)

*** Nigeria ***
xtreg `y' $controls i.year i.TR if (split1!=1 & Country=="Nigeria") , fe vce (cluster mid)
xtreg `y' $controls i.year time_mother if (split1!=1 & Country=="Nigeria") , fe vce (cluster mid)
*Drop all years post 1996 [there were 2 splits in 1987 and then a wave of splits in 1991, followed by a waves of splits in 1996]
xtreg `y' $controls i.year i.TR if (split1!=1 & Country=="Nigeria" & year<1996) , fe vce (cluster mid)

*** Uganda ***
xtreg `y' $controls i.year i.TR_M if (TR_S!=1 & Country=="Uganda") , fe  vce (cluster mid)
xtreg `y' $controls i.year time_mother  if (TR_S~=1 & Country=="Uganda"), fe vce (cluster mid)
*Drop all years post 2005 [the third wave of splits begins in 2005]
xtreg `y' $controls i.year i.TR_M if (TR_S!=1 & Country=="Uganda" & year<2005), fe   vce (cluster mid)
}


***** Table E10 *****
preserve
keep if Country=="Malawi"

* Create time trend variable [2010 is the last year in the sample]
gen yeartrend = 2010-year

* REGRESSIONS

foreach y in  infantmort childmort {
*FE regressions - all splits included, child and infant mortality, individual year effects
xtreg `y' $controls yeartrend i.TR if split1!=2, fe vce (cluster mid)
est store M1_`y'
*FE regressions - all splits included, child and infant mortality, individual year effects with year FEs
xtreg `y' $controls  yeartrend i.year i.TR if split1!=2 , fe  vce (cluster mid)
est store M2_`y'
*FE regressions - using time since split as treatment variable, individual year effects
xtreg `y' $controls yeartrend time_splinter  if split1!=2, fe vce (cluster mid)
est store M3_`y'
*FE  - using time since split as treatment variable, individual year effects with year FEs
xtreg `y' $controls yeartrend i.year time_splinter if split1!=2, fe vce (cluster mid)
est store M4_`y'
}

** Compare to other districts that splinter later **
*Drop all years post 2003 [the first wave of splits occurs in 1998, the second occurs in 2003]
drop if year>=2003
keep if (Splinter==1998 | Mother==1998 | Splinter ==2003 | Mother==2003)
gen TR_S2 = 0 
replace TR_S2=1 if (split2==1 )

*FE regressions - only look at first two waves of splits, child and infant mortality , individual year effects
foreach y in  infantmort childmort {
xtreg `y' $controls i.year i.TR_S2 if split1!=2 , fe   vce (cluster mid)
est store M5_`y'
}
restore

preserve
keep if Country=="Nigeria"
* Create time trend variable [2011 is the last year in the sample]
gen yeartrend = 2011-year

foreach y in  infantmort childmort {
*FE regressions - all splits included, child and infant mortality, individual year effects
xtreg `y' $controls yeartrend i.TR if split1!=2, fe vce (cluster mid)
est store N1_`y'
*FE regressions - all splits included, child and infant mortality, individual year effects with year FEs
xtreg `y' $controls  yeartrend i.year i.TR if split1!=2 , fe  vce (cluster mid)
est store N2_`y'
*FE regressions - using time since split as treatment variable, individual year effects
xtreg `y' $controls yeartrend time_splinter  if split1!=2, fe vce (cluster mid)
est store N3_`y'
*FE  - using time since split as treatment variable, individual year effects with year FEs
xtreg `y' $controls yeartrend i.year time_splinter if split1!=2, fe vce (cluster mid)
est store N4_`y'
}

*Drop all years post 1991 [the second wave of splits begins in 1996]
drop if year>=1991
keep if (Splinter==1987 | Mother==1987 | Splinter ==1991 | Mother==1991 | Splinter==1996 | Mother ==1996)
gen TR_S2 = 0 
replace TR_S2=1 if (split2==1 )

*FE and RE regressions - only look at first two waves of splits, child and infant mortality , individual year effects
foreach y in  infantmort childmort {
xtreg `y' $controls i.year i.TR_S2 if split1!=2 , fe   vce (cluster mid)
est store N5_`y'
}
restore

preserve
keep if Country=="Uganda"
* Create time trend variable [2011 is the last year in the sample]
gen yeartrend = 2011-year

foreach y in  infantmort childmort {
*FE regressions - all splits included, child and infant mortality, individual year effects
xtreg `y' $controls yeartrend i.TR_S if TRM!=1, fe vce (cluster mid)
est store U1_`y'
*FE regressions - all splits included, child and infant mortality, individual year effects with year FEs
xtreg `y' $controls  yeartrend i.year i.TR_S if TRM!=1 , fe  vce (cluster mid)
est store U2_`y'
*FE regressions - using time since split as treatment variable, individual year effects
xtreg `y' $controls yeartrend time_splinter  if TRM!=1, fe vce (cluster mid)
est store U3_`y'
*FE  - using time since split as treatment variable, individual year effects with year FEs
xtreg `y' $controls yeartrend i.year time_splinter if TRM!=1, fe vce (cluster mid)
est store U4_`y'
}


*Drop all years post 2005 [the third wave of splits begins in 2005]
drop if year>=2005
keep if (wave1>0 |  wave3>0 | wave4>0)
gen TR_S2 = 0 
replace TR_S2=1 if (wave1>0 & TR_S==1)

*FE and RE regressions - only look at first two waves of splits, child and infant mortality , individual year effects
foreach y in  infantmort childmort {
xtreg `y' $controls i.year i.TR_S2 if TRM!=1 , fe   vce (cluster mid)
est store U5_`y'
}
restore

***** Table E11 *****
preserve
keep if Country=="Malawi"

* Create time trend variable [2010 is the last year in the sample]
gen yeartrend = 2010-year

* REGRESSIONS

foreach y in  infantmort childmort {
*FE regressions - all splits included, child and infant mortality, individual year effects
xtreg `y' $controls yeartrend i.TR if split1!=1, fe vce (cluster mid)
est store M1_`y'
*FE regressions - all splits included, child and infant mortality, individual year effects with year FEs
xtreg `y' $controls  yeartrend i.year i.TR if split1!=1 , fe  vce (cluster mid)
est store M2_`y'
*FE regressions - using time since split as treatment variable, individual year effects
xtreg `y' $controls yeartrend time_mother  if split1!=1, fe vce (cluster mid)
est store M3_`y'
*FE  - using time since split as treatment variable, individual year effects with year FEs
xtreg `y' $controls yeartrend i.year time_mother if split1!=1, fe vce (cluster mid)
est store M4_`y'
}

** Compare to other districts that splinter later **
*Drop all years post 2003 [the first wave of splits occurs in 1998, the second occurs in 2003]
drop if year>=2003
keep if (Splinter==1998 | Mother==1998 | Splinter ==2003 | Mother==2003)
gen TR_M2 = 0
replace TR_M2=1 if (split2==2 )

*FE regressions - only look at first two waves of splits, child and infant mortality , individual year effects
foreach y in  infantmort childmort {
xtreg `y' $controls i.year i.TR_M2 if split1!=1 , fe   vce (cluster mid)
est store M5_`y'
}
restore

preserve
keep if Country=="Nigeria"
* Create time trend variable [2011 is the last year in the sample]
gen yeartrend = 2011-year

foreach y in  infantmort childmort {
*FE regressions - all splits included, child and infant mortality, individual year effects
xtreg `y' $controls yeartrend i.TR if split1!=1, fe vce (cluster mid)
est store N1_`y'
*FE regressions - all splits included, child and infant mortality, individual year effects with year FEs
xtreg `y' $controls  yeartrend i.year i.TR if split1!=1 , fe  vce (cluster mid)
est store N2_`y'
*FE regressions - using time since split as treatment variable, individual year effects
xtreg `y' $controls yeartrend time_mother  if split1!=1, fe vce (cluster mid)
est store N3_`y'
*FE  - using time since split as treatment variable, individual year effects with year FEs
xtreg `y' $controls yeartrend i.year time_mother if split1!=1, fe vce (cluster mid)
est store N4_`y'
}

*Drop all years post 1991 [the second wave of splits begins in 1996]
drop if year>=1991
keep if (Splinter==1987 | Mother==1987 | Splinter ==1991 | Mother==1991 | Splinter==1996 | Mother ==1996)
gen TR_M2 = 0 
replace TR_M2=1 if (split2==2 )

*FE and RE regressions - only look at first two waves of splits, child and infant mortality , individual year effects
foreach y in  infantmort childmort {
xtreg `y' $controls i.year i.TR_M2 if split1!=1 , fe   vce (cluster mid)
est store N5_`y'
}
restore

preserve
keep if Country=="Uganda"
* Create time trend variable [2011 is the last year in the sample]
gen yeartrend = 2011-year

foreach y in  infantmort childmort {
*FE regressions - all splits included, child and infant mortality, individual year effects
xtreg `y' $controls yeartrend i.TR_M if TRS!=1, fe vce (cluster mid)
est store U1_`y'
*FE regressions - all splits included, child and infant mortality, individual year effects with year FEs
xtreg `y' $controls  yeartrend i.year i.TR_M if TRS!=1 , fe  vce (cluster mid)
est store U2_`y'
*FE regressions - using time since split as treatment variable, individual year effects
xtreg `y' $controls yeartrend time_mother  if TRS!=1, fe vce (cluster mid)
est store U3_`y'
*FE  - using time since split as treatment variable, individual year effects with year FEs
xtreg `y' $controls yeartrend i.year time_mother if TRS!=1, fe vce (cluster mid)
est store U4_`y'
}


*Drop all years post 2005 [the third wave of splits begins in 2005]
drop if year>=2005
keep if (wave1>0 |  wave3>0 | wave4>0)
gen TR_M2 = 0 
replace TR_M2=1 if (wave1>0 & TR_M==1)

*FE and RE regressions - only look at first two waves of splits, child and infant mortality , individual year effects
foreach y in  infantmort childmort {
xtreg `y' $controls i.year i.TR_M2 if TRS!=1 , fe   vce (cluster mid)
est store U5_`y'
}
restore

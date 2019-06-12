version 9.2
set more off
clear
set mem 100m

use "FILEPATH\Watchdog", clear

recode medfree (1 2 =1) ( 3 4 = 0) (0 8 9 999 = .), gen(Dmedfree)
*create dichotomous variable for media freedom where 1 is free media and 0 is notfree media

generate int PMF=polity2*Dmedfree

*create interaction between media freedom and polity2
generate CConflict=0
replace CConflict = 1 if T3Conflict==1|T4Conflict==1
*because T4Conflict was not significant and Conflict is not main focus, I collapsed 
*these two categories of conflict into one: CConflict--meaning internal conflict which may or 
*may not involve international intervention

generate lnrgdp=ln(rgdpch)
* creates logged gdp variable
generate lnpop=ln(pop)
*creates logged population variable

gen physint_tm1 = physint[_n-1]

replace physint_tm1 = . if ccode ~= ccode[_n-1]
*this is to generate a lagged variable for the dependent variable and to avoid the lag crossing cases


recode polity2(-10/-4=0) (-3/0=1) (1/7=2) (8/9=3) (10=4), generate (FivePol)

generate FPolMF= FivePol*Dmedfree



sort ccode year
tsset ccode year, yearly

*to create table 2(without interaction)

xtpcse physint physint_tm1 Dmedfree, correlation (ar1)
xtpcse physint physint_tm1 Dmedfree FivePol, correlation (ar1)
xtpcse physint physint_tm1 Dmedfree FivePol lnrgdp, correlation (ar1)
xtpcse physint physint_tm1 Dmedfree FivePol lnrgdp lnpop, correlation (ar1)
xtpcse physint physint_tm1 Dmedfree FivePol lnrgdp lnpop T2Conflict CConflict, correlation (ar1)

xtpcse physint physint_tm1 Dmedfree polity2 lnrgdp lnpop T2Conflict CConflict, correlation (ar1)
xtpcse physint Dmedfree FivePol lnrgdp lnpop T2Conflict CConflict, correlation (ar1)


*To create Table 3 (with interaction)
xtpcse physint physint_tm1 Dmedfree, correlation (ar1)
xtpcse physint physint_tm1 Dmedfree FivePol, correlation (ar1)
xtpcse physint physint_tm1 Dmedfree FivePol FPolMF, correlation (ar1)
xtpcse physint physint_tm1 Dmedfree FivePol FPolMF lnrgdp, correlation (ar1)
xtpcse physint physint_tm1 Dmedfree FivePol FPolMF lnrgdp lnpop, correlation (ar1)
xtpcse physint physint_tm1 Dmedfree FivePol FPolMF lnrgdp lnpop T2Conflict CConflict, correlation (ar1)
xtpcse physint physint_tm1 Dmedfree polity2 PMF lnrgdp lnpop T2Conflict CConflict, correlation (ar1)
xtpcse physint Dmedfree FivePol FPolMF lnrgdp lnpop T2Conflict CConflict, correlation (ar1)



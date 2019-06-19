set more off
pause off

local ph0 "C:\RESTAT\"

cd `ph0'

clear
set obs 1
gen year=.
save "TRADE EFFECT_BE_AD.dta", replace


#delimit ;
global ppp "
ARG
AUS
BRA
CAN
CHL
CHN
COL
EUN
IDN
IND
JPN
MEX
PER
TUR
USA
";

#delimit cr
foreach p of global ppp {

use "TT_`p'.dta", clear
display "***************************************************************************`p'"
drop if year==.
drop if pcode=="WLD"
egen var=max(year)
if var==2008 {
		preserve
		replace year=2009
		replace yrtrf=2009
		save temp, replace
		restore
		append using temp
		drop var
}
else {
		drop var
}
sort ccode pcode year hs6
merge ccode pcode year hs6 using "final`p'.dta"
rename flag2 flag3
tab _m
drop if _m==2
replace trade=trade2 if _m==3
drop trade2
drop _m
egen flag2=mean(flag), by(ccode pcode hs6)
tab flag
tab flag2
tab year if flag2~=.
preserve
keep if flag2~=.&year==2008
replace flag=1
save temp, replace
restore 
replace flag=2 if flag2~=.&year==2008
append using temp
drop flag2
if ccode=="" {
	display "*********************************************no data"	
}
else {
sort ccode hs6
tab  year yrtrf
tab year
egen a=mean(yrtrf), by(year)
replace yrtrf=a if yrtrf==.
drop a
tab  year yrtrf
sum
sort ccode pcode hs6
merge ccode pcode hs6 using "Bilelast_`p'"
tab _m
tab _m if pcode~="WLD"
gen wld_dummy=0
replace wld_dummy=1 if pcode=="WLD"
display "******************************IMPORTANT CHECK(1)"
sum OK_elas_fit if wld_dummy==0
egen xx=mean( meanelas), by (hs6 wld_dummy)
replace  OK_elas_fit=xx if  OK_elas_fit==.
drop if _merge==2
replace OK_elas_fit=-3 if OK_elas_fit==.&wld_dummy==1
drop if trade==.
drop  xx _merge meanelas 
sort ccode year
ren  OK_elas_fit elas
display "******************************IMPORTANT CHECK(1)"
sum elas if wld_dummy==0

replace ADduty=-(1/elas) if year==2009&flag3==1&flag==2&ADduty==.
*replace ADduty=-(1/elas) if year==2009&flag==2
drop flag3

gen t=totarif
replace t=totarif2 if pcode=="WLD"

gen t2=t
replace t2=0.000001 if t2==0
egen sx=sum(t2), by(ccode year wld_dummy)
drop if sx==0
drop t2 sx


display "*********************************************COUNT OF MISSING TARIFF RELATIVE TO AVAILABLE DATA***************************
tab ccode
tab ccode if t==.

egen tt=rsum(t ADduty)

drop  totarif totarif2  yrtrf yrtr t ADduty

drop if tt==.
drop if elas==.

egen max=max(year)
egen min=min(year)
if min==max {
		gen a=1
		collapse a, by(ccode)
		drop a
		gen wld_dummy=0
		gen sector="AG" 
		save temp, replace
		replace sector="MF"
		append using temp
		save temp, replace
}
else {
gen a= trade if year==2009& flag~=.
egen b=mean( a), by(ccode pcode hs6 flag)
replace  trade=b if flag~=.
drop a b
reshape wide  tt elas trade, i( ccode pcode hs6 wld_dummy flag) j(year)
drop  trade2009
rename  trade2008 trade
drop elas2009
rename elas2008 elas
gen effect=( tt2009- tt2008)* trade* elas
replace effect=-trade  if  effect<- trade

*COMMAND FOR THE EUN FILE
tab ccode
gen var="`p'"
replace ccode="EUN" if var=="EUN"
tab ccode
drop var

gen sector="AG"
replace sector="MF" if hs6>"249999"

collapse (sum)  effect, by( ccode wld_dummy sector)
}
append using "TRADE EFFECT_BE_AD.dta"
save "TRADE EFFECT_BE_AD.dta", replace
}
}

use "TRADE EFFECT_BE_AD.dta", clear
drop if ccode==""
drop year
save temp2, replace
collapse (sum) effect, by(ccode wld_dummy)
gen sector="ALL"
append using temp2
reshape wide effect, i(ccode sector) j(wld_dummy)
rename effect0 BILeffect
cap rename effect1 MFNeffect
gen order=1 if sector=="ALL"
replace order =2 if sector=="MF"
replace order =3 if sector=="AG"
sort order ccode
save "TRADE EFFECT_BE_AD.dta", replace

erase temp.dta
erase temp2.dta

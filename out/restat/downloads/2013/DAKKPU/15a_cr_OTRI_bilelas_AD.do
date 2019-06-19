set more off
pause off

local ph0 "C:\RESTAT\"

local countrynames "`ph0'countrynames"

cd `ph0'


clear
set obs 1
gen year=.
save "OTRI_TH0_BE_AD.dta", replace


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
tab _m
drop if _m==2
replace trade=trade2 if _m==3
drop trade2
drop _m
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

replace ADduty=-(1/elas) if year==2009&flag2==1&flag==2&ADduty==.
*replace ADduty=-(1/elas) if year==2009&flag==2

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
gen n3= trade* elas* tt
gen d3= trade* elas

*COMMAND FOR THE EUN FILE
tab ccode
gen var="`p'"
replace ccode="EUN" if var=="EUN"
replace yrtr=2008 if yrtr==2007&var=="EUN"
tab ccode
drop var


display "******************************************************************************************************"
************************************************************************************** DECOMPOSITION TERMS - START

egen a=sum(trade) if elas~=., by(ccode year wld_dummy)
gen impshare=trade/a
drop a
gen a=impshare*tt
egen ttwa=sum(a), by(ccode year wld_dummy)
drop a
gen a=impshare*elas
egen b=sum(a), by(ccode year wld_dummy)
gen elasterm=elas/b
drop a b
gen a=impshare*(tt-ttwa)*(elasterm-1)
egen cov=sum(a), by(ccode year wld_dummy)
drop a elasterm impshare
gen a=trade*elas
egen sumimpsbyelast=sum(a), by(ccode year wld_dummy)
drop a
*********************************************************by sector
gen sector="AG"
replace sector="MF" if hs6>"249999"

egen a=sum(trade) if elas~=., by(ccode year sector wld_dummy)
gen impshare=trade/a
drop a
gen a=impshare*tt
egen ttwa2=sum(a), by(ccode year sector wld_dummy)
drop a
gen a=impshare*elas
egen b=sum(a), by(ccode year sector wld_dummy)
gen elasterm=elas/b
drop a b
gen a=impshare*(tt-ttwa2)*(elasterm-1)
egen cov2=sum(a), by(ccode year sector wld_dummy)
drop a elasterm impshare
gen a=trade*elas
egen sumimpsbyelast2=sum(a), by(ccode year sector wld_dummy)
drop a

************************************************************************************** DECOMPOSITION TERMS - END


preserve

collapse sumimpsbyelast ttwa cov (sum) trade n3 d3 , by (ccode year wld_dummy yrtrf yrtr)
gen otri_t=n3/d3
keep ccode year wld_dummy otri_t yrtrf yrtr sumimpsbyelast ttwa cov trade 
gen sector="ALL"

append using "OTRI_TH0_BE_AD.dta"
save "OTRI_TH0_BE_AD.dta", replace

restore
collapse sumimpsbyelast2 ttwa2 cov2  (sum) trade n3 d3 , by (ccode year wld_dummy sector yrtrf yrtr)
gen otri_t=n3/d3
keep ccode year wld_dummy otri_t  sector yrtrf yrtr sumimpsbyelast2 ttwa2 cov2 trade
rename sumimpsbyelast2 sumimpsbyelast
rename ttwa2 ttwa
rename cov2 cov
append using "OTRI_TH0_BE_AD.dta"
save "OTRI_TH0_BE_AD.dta", replace
}
}

use "OTRI_TH0_BE_AD.dta", clear
drop if year==.
drop year 
tab ccode if yrtrf==2007
replace yrtrf=2008 if yrtrf==2007
reshape wide  otri_t ttwa cov sumimpsbyelast trade , i( ccode sector yrtr wld_dummy) j(yrtrf)
drop sumimpsbyelast2009 
rename  sumimpsbyelast2008 sumimpsbyelast
drop trade2009
rename trade2008 trade
gen incotri_t0809=otri_t2009-otri_t2008
gen incttwa0809=ttwa2009-ttwa2008
gen inccov0809=cov2009-cov2008
gen effectontrade=incotri_t0809*sumimpsbyelast
*drop sumimpsbyelast
sort ccode sector wld_dummy 
save "OTRI_TH0_BEfinal_AD.dta", replace

keep if wld_dummy==1
order  ccode sector otri_t2008 otri_t2009 incotri_t0809 ttwa2008 ttwa2009 incttwa0809 cov2008 cov2009 inccov0809 effectontrade
rename otri_t2008 MFNotri_t2008 
rename otri_t2009 MFNotri_t2009 
rename incotri_t0809 MFNincotri_t0809 
rename ttwa2008 MFNttwa2008
rename ttwa2009 MFNttwa2009
rename incttwa0809 MFNincttwa0809
rename cov2008 MFNcov2008
rename cov2009 MFNcov2009
rename inccov0809 MFNinccov0809
rename effectontrade MFNeffectontrade
rename sumimpsbyelast MFNsumimpsbyelast
drop yrtr  wld_dummy  trade 
sort ccode sector
save test, replace

use "OTRI_TH0_BEfinal_AD.dta", clear
drop if wld_dummy==1
merge ccode sector using test
tab _m
drop _m
gen order=1 if sector=="ALL"
replace order =2 if sector=="MF"
replace order =3 if sector=="AG"
drop trade wld_dummy
sort ccode
merge ccode using `countrynames'
tab _m
drop if _m==2
drop _m
order  ccode name sector  otri_t2008 otri_t2009 incotri_t0809  ttwa2008 ttwa2009 incttwa0809 cov2008 cov2009 inccov0809 effectontrade MFNotri_t2008 MFNotri_t2009 MFNincotri_t0809 MFNttwa2008 MFNttwa2009 MFNincttwa0809 MFNcov2008 MFNcov2009 MFNinccov0809 MFNeffectontrade  yrtr
sort order ccode 
save "OTRI_TH0_BEfinal_AD.dta", replace


erase "OTRI_TH0_BE_AD.dta"

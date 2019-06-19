****Construction of individual variables***

use individualdata.dta, clear
gen codeprovsect=province*100+sector
label var codeprovs "province-sector code"
tab codeprovs, gen (dprovsect)

gen age2=age^2
label var age2 "age*age"

gen dnq=0 
replace dnq=1 if schooly<9
label var dnq "1= unqualified worker (schooly<9), 0 otherwise"

gen communist=0
replace communist=1 if Communist==1 
label var communist "1=member of communist party, 0 otherwise"

gen lnpop1997=ln(pop1997)
label var lnpop1997 "ln(city population in 1997)"

***wage data***
gen basewage=wages - allowance
label var basewage "Annual earnings"
gen basewageh=basewage/((49*daysweek-daysunemp)*hoursday)
label var basewageh "wage per hour"
gen lnbasewage=ln(basewage)
label var lnbasewage "ln(Annual earnings)"
gen lnbasewageh=ln(basewageh)
label var lnbasewageh "dep var: ln(wage per hour)"

gen wage_alt1=wages-a55-allowance
label var wage_alt1 "Basic salary - other allowances"
gen lnwageh_alt1=ln(wage_alt1/((49*daysweek-daysunemp)*hoursday))
label var lnwageh_alt1 "ln(Basic salary - other allowances (per hour))"

gen wage_alt2=(wages-allowance+a62-a63)
label var wage_alt2 "Basic salary +bonus+sub+ other incomes "

gen lnwageh_alt2=ln(wage_alt2/((49*daysweek-daysunemp)*hoursday))
label var lnwageh_alt2 "ln(Basic salary+bonus+sub+ other incomes (per hour))" 

gen wagehour= wages/((49*daysweek-daysunemp)*hoursday)
label var wagehour "Basic salary +bonus+sub+allowances(job) (per hour)"

gen lnwageh_alt3=ln(wagehour)
label var lnwageh_alt3 "ln(Basic salary+bonuses+subsidies+allowances(job) (per hour))" 

***Interaction between firm ownership and market access

gen MAPrivate=lnMA*ownprivate
gen MAState=lnMA*ownstate
gen MAColl=lnMA*ownucoll
gen MAForeign=lnMA*ownforeign
gen MALocal=lnMA*ownlocal
gen MASinoforeign=lnMA*ownsinoforegin
gen MAAllothers=lnMA*ownallothers

label var MAPriv "lnMA*ownprivate"
label var MAState "lnMA*ownstate"
label var MAColl "lnMA*ownucoll"
label var MAForeign "lnMA*ownforeign"
label var MALocal "lnMA*ownlocal"
label var MASinofo "lnMA*ownsinoforegin"
label var MAAllothers "lnMA*ownallothers"


***Variables for the Heckman selection equation***

gen female=0
replace female = 1 if sex ==2
label var female "1=woman, 0 otherwise"

gen male=0
replace male = 1 if sex ==1
label var male "1=man, 0 otherwise"

gen married=0
replace married=1 if martialstatus==1
label var married "1=married, 0 otherwise"

gen married_male=married*male
label var married_male "married*male"

gen married_female=married*female
label var married_female "married*female"

gen noworkincome=a71+a76+a85+a89
label var noworkincom "Income from other sources than work"

gen hhwealth=h1+h9+h10+h11+h12-h13
label var hhwealth "Household wealth"

save final_2010.dta, replace

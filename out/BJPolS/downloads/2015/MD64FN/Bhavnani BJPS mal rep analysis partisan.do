*Replication code for Bhavnani, Rikhil R. Forthcoming. "The Effects of Malapportionment on 
*Cabinet Inclusion: Subnational Evidence from India." British Journal of Political Science. 

*This file contains the code to replicate Table 3. 

clear
set matsize 800
set more off

********
*PROGRAM
********
capture program drop calcbias
program define calcbias

global state=st_name[1] 
scalar year=year[1]
global stateyear=stateyear[1]

*******************************
*identify total number of seats
*******************************
gsort -ac_no
scalar totalseats=ac_no[1]

*****************
*identify winners
*****************
replace totvotpoll=totvotpoll*-1
sort stateac totvotpoll
by stateac: gen n=_n
replace totvotpoll=totvotpoll*-1
rename n winner
replace winner=0 if winner~=1

**************************
*total vootes in each cons
**************************
egen turnout=total(totvotpoll), by(ac_no)
order totvotpoll turnout

**************
*percent votes
**************
gen propvotes=(totvotpoll/turnout)*100

********************************************
*identify winning and runner up party, seats 
********************************************
preserve
	collapse (sum) winner, by(partyname)
	gsort -winner
	l, sep(0)

	*the winning party is...
	global winningparty=partyname[1]
	scalar seats1=winner[1]

	*the runner up party is...
	global runnerupparty=partyname[2]
	scalar seats2=winner[2]

	display "$winningparty" seats1
	display "$runnerupparty" seats2
restore

*****************************************************
*calculate votes won by winning and runner up parties
*calculate uniform swing
*****************************************************
preserve
	collapse (sum) totvotpoll, by(partyname)
	gsort -totvotpoll
	egen turnout=total(totvotpoll)
	gen percentvotes=totvotpoll/turnout*100
	l, sep(0)

	summ percentvotes if partyname=="$winningparty"
	scalar vote1=r(mean)
	display vote1

	summ percentvotes if partyname=="$runnerupparty"
	scalar vote2=r(mean)
	display vote2

	*calculate uniform swing
	scalar addsub=(vote1-vote2)/2
	display addsub

	display "$winningparty"
	display "$runnerupparty"
restore

***********************
*applying uniform swing
***********************
gen Apropvotes=propvotes
replace Apropvotes=propvotes-addsub if partyname=="$winningparty"
replace Apropvotes=propvotes+addsub if partyname=="$runnerupparty"
order propvotes Apropvotes partyname
drop winner

************************************************
*identify winners with and without uniform swing
************************************************
replace Apropvotes=Apropvotes*-1
sort ac_no Apropvotes
by ac_no: gen n1=_n
gen Awinners=1 if n1==1
replace Awinners=0 if n1~=1
replace Apropvotes=Apropvotes*-1

replace propvotes=propvotes*-1
sort ac_no propvotes
by ac_no: gen n2=_n
gen winners=1 if n2==1
replace winners=0 if n2~=1
replace propvotes=propvotes*-1

order ac_no propvotes winners Apropvotes Awinners partyname

*********************
*calculate x, y, bias
*********************
preserve
	collapse (sum) winners Awinners (mean) propvotes Apropvotes, by(partyname)
	gsort -winners
	scalar xcons=Awinners[1]
	scalar ycons=Awinners[2]
	scalar bias=xcons-ycons
	display xcons
	display ycons
	display bias
	l, sep(0)
restore

*********************
*calculate b, f, R, S
*********************
drop if partyname~="$winningparty" & partyname~="$runnerupparty"
drop Awinners n1

*identify winners 
replace Apropvotes=Apropvotes*-1
sort ac_no Apropvotes
by ac_no: gen n1=_n
gen Awinners=1 if n1==1
replace Awinners=0 if n1~=1
replace Apropvotes=Apropvotes*-1
keep if Awinners==1

gen electorate=electors
gen n=1
collapse (sum) n (mean) electorate, by(partyname)
	
preserve
	keep if partyname=="$winningparty"
	scalar bcons=n
	scalar Rcons=electorate
	l
restore

preserve
	keep if partyname=="$runnerupparty"
	scalar fcons=n
	scalar Scons=electorate
	l
restore

display bias 
display bcons
display fcons
display Rcons
display Scons

************
*calculate E
************
scalar Econs=((fcons*(Scons/Rcons-1)) - (bcons*(Rcons/Scons-1)))/2
display Econs

***********
*write file
***********
drop _all
set obs 1
scalar list _all
gen state="$state"
gen year=year
gen stateyear="$stateyear"
gen party1="$winningparty"
gen party2="$runnerupparty"
gen seats1=seats1
gen seats2=seats2
gen votes1=vote1
gen votes2=vote2
gen unifsw=addsub
gen xcons=xcons
gen ycons=ycons
gen bias=bias
gen bcons=bcons
gen fcons=fcons
gen Rcons=Rcons
gen Scons=Scons
gen Econs=Econs
gen totalseats=totalseats

save temp.dta, replace
	
end





*claculate partisan bias for last state-years in the data 
global lastSY AndhraPradesh2004 Assam2006 Bihar2000 Gujarat2007 Haryana2005 HimachalPradesh2007 Jammu&Kashmir2002 Karnataka2004 Kerala2006 MadhyaPradesh1998 Maharashtra2004 Orissa2004 Punjab2007 Rajasthan2003 TamilNadu2006 UttarPradesh1996 WestBengal2006
tokenize $lastSY

use "Bhavnani BJPS mal rep data partisan.dta", clear
keep if stateyear=="AndhraPradesh2004"
qui calcbias
save "partisantable.dta", replace 

use "Bhavnani BJPS mal rep data partisan.dta", clear
local i=2
while "``i''" != "" {
	display "``i''"
	keep if stateyear=="``i''"
	qui calcbias
	sleep 2000
	append using "partisantable.dta"
	save "partisantable.dta", replace
	local i=`i'+1
	use "Bhavnani BJPS mal rep data partisan.dta", clear
}
drop _all
erase temp.dta
use "partisantable.dta", clear

gen Pmalbias=Econs/totalseats*100
gen Pseats1=seats1/totalseats*100
gen Pseats2=seats2/totalseats*100

sort state year
keep state year party1 Pmalbias
order state year party1 Pmalbias 
sort state year
format Pmalbias %9.1f
l, sep(0)
save "partisantable.dta", replace

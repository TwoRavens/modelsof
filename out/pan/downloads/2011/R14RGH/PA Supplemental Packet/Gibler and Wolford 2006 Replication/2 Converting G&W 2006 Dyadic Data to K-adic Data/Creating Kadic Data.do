clear all
set more off
set mem 400m

cd "C:\Users\Paul\Desktop\PA Supplemental Packet\Gibler and Wolford 2006 Replication\Converting G&W 2006 Dyadic Data to K-adic Data\"

tempfile jcrdata2 year2 allyform zeros jcrdatav2 nodupdyad states nodupstate allyformation allystates allyform tempally allystates nodupdyad2 onesk_ads zeroes_store zeros_temp zeros_temp1

/* Create required datasets out of Gibler and Wolford 2006 */
*** Reformat Gibler and Wolford
use "jcr2006 data", clear
rename ccode1 statea
rename ccode2 stateb
format statea stateb year %8.0f
sort statea stateb year
drop if year==.
rename statea statea2 
rename stateb stateb2
gen statea=min(statea2, stateb2)
gen stateb=max(statea2, stateb2)
drop statea2 stateb2
sort statea stateb year
save `jcrdata2', replace

*** Create a data set listing all the available years in Gibler and Wolford
keep year 
drop if year==.
duplicates drop year, force
save `year2', replace

*** Create a data set listing all the alliance codes found in Gibler and Wolford
use `jcrdata2', clear
keep if allyform==1
keep allynum year
duplicates drop allynum, force
sort allynum
save `allyform', replace

*** Create a data set with all dyad-years that did not form an alliance
use `jcrdata2', clear
keep if allyform==0
keep statea stateb year CoW3alliedlag pol5 poldif jtrel jtlin jteth mid10ab jtenmid jtmdct10 sqrtdist mpctdum lrnnewd
save `zeros', replace

*** Create a data set listing all dyad-years that did form an alliance
use `jcrdata2', replace
duplicates drop allynum dyad, force
keep allynum statea stateb year
sort allynum
gen ally=0
replace ally=1 if allynum~=.
sort statea stateb year
save `jcrdatav2', replace
capture save `nodupdyad', replace


/* Drop redundant dyads (since Gibler used directed dyads)*/
clear all
gen id=1
gen statea=1
gen stateb=1
drop if statea==1
save `nodupdyad', replace

*** Create a list of all states in the data set
use `jcrdatav2', clear
stack statea stateb, into(state) clear
keep state
duplicates drop state, force
save `states', replace
levels state, local(st)

*** Loop that 
foreach s in `st' {
di `s'
qui {
use `jcrdatav2', clear
capture keep if (stateb>`s' & statea==`s') | (stateb==`s' & statea>`s')
capture gen statenewa =stateb if stateb==`s'
capture gen statenewb =statea if stateb==`s'
capture replace statenewa=statea if statea==`s'
capture replace statenewb =stateb if statea==`s'
capture drop statea stateb
capture rename statenewa statea
capture rename statenewb stateb
capture duplicates drop statea stateb, force
capture gen id = `s'
capture save `nodupstate', replace
capture use `nodupdyad', clear
capture append using `nodupstate'
capture save `nodupdyad', replace
}
}

/* Create "Year of Formation" allynum (allynumform).  Note: this is to ensure that I do not include joiners.*/
use `jcrdatav2', clear
sort allynum year
duplicates drop allynum, force
egen allynumform=concat(allynum year) if allynum~=., p(_)
sort allynum year
save `allyformation', replace

use `jcrdatav2', clear
sort allynum year
merge allynum year using `allyformation', nokeep keep(allynumform)
drop _merge
split allynumform, p(_)
rename allynumform2 ally_form_year
drop allynumform1
destring ally_form_year, replace
gen formation_year = 0
replace formation_year = 1 if ally_form_year==year
drop ally_form_year
drop allynumform
replace allynum=. if formation_year==0
sort statea stateb year
save `jcrdatav2', replace

/* Obtain all "Ones" Observations*/
set more off
use `nodupdyad', clear
cross using `year2'
sort statea stateb  year
merge statea stateb year using `jcrdatav2', nokeep keep(allynum ally)
save `nodupdyad', replace
keep allynum statea stateb year
save `nodupdyad2', replace
clear all
gen nummem=1 
gen allynum =1
drop if allynum==1
save `allystates', replace

use `nodupdyad2', clear
duplicates drop allynum, force
sort allynum
levels allynum, local(al)
foreach a in `al' {
di in white `a'
qui {
use `nodupdyad2', clear
keep if allynum==`a'
stack statea stateb, into(state) clear
duplicates drop state, force
levels state, local(s)
local i 1
}
foreach s in `s' {
di in yellow `s' 
qui gen mem`i' = `s'
local i = `i' + 1
}
local k = `i' - 1
gen nummem = `k'
qui {
drop state _stack
gen allynum=`a'
duplicates drop allynum, force
sort allynum
merge allynum using `allyform', nokeep keep(year)
drop _merge
save `tempally', replace
use `allystates', clear
append using `tempally'
save `allystates', replace
}
}
gen ally=1
save `onesk_ads', replace

/* Obtain Random Sample of Zeros */
set more off
use `zeros', clear
clear all
gen statea=1
drop if statea==1
save `zeroes_store', replace

use `onesk_ads', replace
save "k-ads", replace
sort nummem
keep nummem
levels nummem, local(num)

foreach n in `num' {
di in white `n'
use `onesk_ads', clear
sum nummem if nummem==`n'
local freq = (r(N)*8)
di in red `freq'
local h 1
while `h' <=(`freq') {
di in yellow `h'
use `zeros', clear
gen rannum = uniform()
sort rannum
gen id= _n
keep if id<=(1)
keep statea stateb year
save `zeros_temp', replace
sum statea 
local sa = r(mean)
sum year
local yr = r(mean)
sum stateb
local sb = r(mean)
local j 2
while `j'<(`n') {
di in green `j'
use `zeros', clear
keep if statea==`sa'
keep if year==`yr'
drop if stateb==`sb'
gen rannum = uniform()
sort rannum
gen id= _n
keep if id<=(1)
drop rannum id
rename stateb stateb`j'
rename year year`j'
sort statea
save `zeros_temp1', replace
use `zeros_temp', clear
sort statea
merge statea using `zeros_temp1', nokeep keep(stateb`j')
drop _merge 
sum stateb`j'
local sb = r(mean)
save `zeros_temp', replace
local j = `j' + 1
}
use `zeroes_store', clear
append using `zeros_temp'
save `zeroes_store', replace
local h = `h' + 1
}
}

*local h 16
/* Save Choice Based Sample Dataset*/
set more off
use `zeroes_store', clear
rename statea mem1
rename stateb mem2
local i 2
local g = `h' - 2
di `g'
while `i'<=(`g') {
local j = `i' + 1
rename stateb`i' mem`j'
local i = `i' + 1
}

order year mem*
save `zeroes_store', replace

use "k-ads", clear
append using `zeroes_store'
replace ally=0 if ally==.
save "k-ads", replace

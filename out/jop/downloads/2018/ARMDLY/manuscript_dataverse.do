clear
clear matrix
set mem 100000
cd "~\Data"

**************
** FIGURE 2 **
**************

* State legislature
use data_onepartystates, clear
bys year state: keep if _n == 1 // one obs per state/year

g southdem = 1 if inlist(state,"Alabama","Arkansas","Tennessee","Georgia","Florida")
replace southdem = 1 if inlist(state,"Mississippi","Virginia","North Carolina","South Carolina","Texas","Louisiana")

g plainsrep = 1 if inlist(state, "Wisconsin", "Minnesota", "North Dakota", "South Dakota", "Iowa", "Kansas", "Nebraska")

g coastalrep = 1 if inlist(state, "California", "Washington", "Oregon") 

for any plainsrep coastalrep: egen pctX = mean(legrep2pty) if X==1, by(year)
egen pctsouthdem = mean(legdem2pty) if southdem==1, by(year)

sort year
tw connected pctplainsrep pctcoastalrep pctsouthdem year

* Congressional delegation
use data_onepartystates, clear

g southdem = 1 if (inlist(state,"Alabama","Arkansas","Tennessee","Georgia","Florida")| inlist(state,"Mississippi","Virginia","North Carolina","South Carolina","Texas","Louisiana")) & dem==1
replace southdem = 0 if (inlist(state,"Alabama","Arkansas","Tennessee","Georgia","Florida")| inlist(state,"Mississippi","Virginia","North Carolina","South Carolina","Texas","Louisiana")) & dem==0

g plainsrep = 1 if inlist(state, "Wisconsin", "Minnesota", "North Dakota", "South Dakota", "Iowa", "Kansas", "Nebraska") & rep==1
replace plainsrep = 0 if inlist(state, "Wisconsin", "Minnesota", "North Dakota", "South Dakota", "Iowa", "Kansas", "Nebraska") & rep==0

g coastalrep = 1 if inlist(state, "California", "Washington", "Oregon") & rep==1
replace coastalrep = 0 if inlist(state, "California", "Washington", "Oregon") & rep==0

for any coastalrep plainsrep southdem: egen pctX = mean(X), by(cong)

tw connected pctcoastalrep pctplainsrep pctsouthdem cong

************************
** FIGURE 3 & TABLE 1 **
************************

use data_onepartystates, clear


* Make rolling cutoff *
forvalues i=51(1)99{

for any rep dem: gen X`i'v = 1 if inrange(rollXvs,`i', 100) & X==1
for any rep dem: replace X`i'v = 0 if inrange(rollXvs,100-`i' + .000001, `i'-.000001) & X==1

for any rep dem: gen X`i'l = 1 if inrange(rollXleg,`i', 100) & X==1
for any rep dem: replace X`i'l = 0 if inrange(rollXleg,100-`i' + .000001, `i'-.000001) & X==1

for any rep dem: gen X`i'd = 1 if inrange(percent1,`i',100) & X==1
for any rep dem: replace X`i'd = 0 if inrange(percent1,0,`i'-.000001) & X==1

for any rep dem: gen X`i'dl = 1 if X`i'd == 1 & X`i'l==1 & X==1
for any rep dem: replace X`i'dl = 0 if X`i'd==0 & X`i'l==0 & X==1

}


* Table 1 *

* Republicans
foreach x in v l d dl{
forvalues i=70(10)90{

reg dwnom1 rep`i'`x' i.year if rep==1, cluster(idno)

}
}

* Democrats
foreach x in v l d dl{
forvalues i=70(10)90{

reg dwnom1 dem`i'`x' i.year if dem==1, cluster(idno)

}
}


* Figure 3 *

* Republicans
foreach x in v l d dl{
forvalues i=51(1)99{

reg dwnom1 rep`i'`x' i.st i.year reppct if rep==1, cluster(idno)
}
}

* Democrats
foreach x in v l d dl{
forvalues i=51(1)99{

reg dwnom1 dem`i'`x' i.st i.year dempct if dem==1, cluster(idno)

}

**************
** FIGURE 4 **
**************

use data_onepartystates_1994to2016_commonspace, clear // NOMINATE does not vary by Congress after 113th congress; downloaded from voteview.com in october 2017

* Without controls *

* Republicans
foreach x in v l d dl{
forvalues i=70(10)90{

reg dwnom1 rep`i'`x' i.year i.st if rep==1, cluster(idno)

}
}

* Democrats
foreach x in v l d dl{
forvalues i=70(10)90{

reg dwnom1 dem`i'`x' i.year i.st if dem==1, cluster(idno)

}
}


* With controls *

use data_onepartystates_1994to2016_commonspace, clear

* Republicans
foreach x in v l d dl{
forvalues i=70(10)90{

reg dwnom1 rep`i'`x' pctblack pcturban prez_dem pctmfg_all i.year i.st if rep==1, cluster(idno)

}
}

* Democrats
foreach x in v l d dl{
forvalues i=70(10)90{

reg dwnom1 dem`i'`x' pctblack pcturban prez_dem pctmfg_all i.year i.st if dem==1, cluster(idno)

}
}


**************
** FIGURE 6 **
**************

use data_onepartystates, clear

for any dem rep: egen dwX = mean(dwnom1) if X==1, by(year)

* Make graph with dominant party *

forvalues i=70(10)90{
gen over`i'd = 1 if inrange(percent1,`i',100)
replace over`i'd = 0 if inrange(percent1,0,`i'-.00001)

gen over`i'l = 1 if inrange(rolldemleg,`i',100) & party==100
replace over`i'l = 1 if inrange(rollrepleg,`i',100) & party==200
replace over`i'l = 0 if inrange(rolldemleg,0,`i'-.00001) & party==100
replace over`i'l = 0 if inrange(rollrepleg,0,`i' - .00001) & party==200


gen over`i'v = 1 if inrange(rolldemvs,`i',100) & party==100
replace over`i'v = 1 if inrange(rollrepvs,`i',100) & party==200
replace over`i'v = 0 if inrange(rolldemvs,0,`i'-.00001) & party==100
replace over`i'v = 0 if inrange(rollrepvs,0,`i' - .00001) & party==200


gen over`i'dl = 1 if inrange(rolldemleg,`i',100) & inrange(percent1,`i',100) & party==100
replace over`i'dl = 1 if inrange(rollrepleg,`i',100) & inrange(percent1,`i',100) & party==200
replace over`i'dl = 0 if over`i'dl!=1 

}

for any 70 80 90: egen congXl = mean(overXl), by(year)
for any 70 80 90: egen congXd = mean(overXd), by(year)
for any 70 80 90: egen congXv = mean(overXv), by(year)
for any 70 80 90: egen congXdl = mean(overXdl), by(year)

collapse cong* dwrep dwdem, by(year)
gen polar = dwrep - dwdem

tw connected cong90l cong90dl cong90v year



**************
** TABLE 2 ***
**************


* Column 1 & 2

use data_onepartystates_table3, clear // district pvote from david brady

foreach x in rep70l dem70l {
reg dwnom1 prez_dem i.st i.year if `x'==1, cluster(idno)
}


* Column 3 & 4
use onepartymeasures_dwnominate_dist_demos_1876to1910, clear // mfg per capita data and district pvote from Jenkins, Carson and Schickler 2004

foreach x in rep70l dem70l{
reg dwnom1 mfg i.year i.st if `x'==1, cluster(idno)
}

* Column 5 & 6
use data_onepartystates, clear

forvalues i=70(10)90{

for any rep dem: gen X`i'v = 1 if inrange(rollXvs,`i', 100) & X==1
for any rep dem: replace X`i'v = 0 if inrange(rollXvs,100-`i' + .000001, `i'-.000001) & X==1

for any rep dem: gen X`i'l = 1 if inrange(rollXleg,`i', 100) & X==1
for any rep dem: replace X`i'l = 0 if inrange(rollXleg,100-`i' + .000001, `i'-.000001) & X==1

for any rep dem: gen X`i'd = 1 if inrange(percent1,`i',100) & X==1
for any rep dem: replace X`i'd = 0 if inrange(percent1,0,`i'-.000001) & X==1

for any rep dem: gen X`i'dl = 1 if X`i'd == 1 & X`i'l==1 & X==1
for any rep dem: replace X`i'dl = 0 if X`i'd==0 & X`i'l==0 & X==1

}

gen prezyear = 1 if year == 1876
forvalues i = 1880(4)2012{
replace prezyear = 1 if year==`i'
}

keep if prezyear==1

for any DCONG RCONG dempct reppct: replace X = X/100

gen demhet = DCONG - dempct if dem==1
gen rephet = RCONG - reppct if rep==1

gen rh = 1 if inrange(rephet,.00001,1) & rep==1
replace rh = 0 if inrange(rephet,-1,0) &  rep==1

gen dh = 1 if inrange(demhet,.00001,1) &  dem==1
replace dh = 0 if inrange(demhet,-1,0) &  dem==1

foreach x in dem70v{
gen idh`x' = `x'*dh
}

foreach x in rep70v{
gen irh`x' = `x'*rh
}

foreach x in dem70v{
reg unity `x' dh idh`x'  i.year i.st if dem==1 & prezyear==1, cluster(idno)
}


foreach x in rep70v {
reg unity `x' rh irh`x'  i.year i.st if rep==1 & prezyear==1, cluster(idno)
}


**************
** TABLE 3 ***
**************


* Columns 1 & 2
use data_onepartystates_table3, clear

foreach y in rep dem{
forvalues i = 70(10)90{
foreach x in `y'`i'l `y'`i'v `y'`i'd `y'`i'dl{

reg dwnom1 `x' `y'_margin dem_minority `y'pct if `y'==1, cluster(idno)
}
}
}

foreach y in rep dem{
forvalues i = 70(10)90{
foreach x in `y'`i'l `y'`i'v `y'`i'd `y'`i'dl{
reg dwnom1 `x' partyshift dem_minority `y'pct if `y'==1, cluster(idno)
}
}
}

* Columns 3 & 4

use data_onepartystates_table3, replace

foreach y in rep dem{
forvalues i = 70(10)90{
foreach x in `y'`i'l `y'`i'v `y'`i'd `y'`i'dl{
reg dwnom1 `x' ptreat `y'pct i.year i.st if `y'==1, cluster(idno)
}
}
}

foreach y in rep dem{
forvalues i = 70(10)90{
foreach x in `y'`i'l `y'`i'v `y'`i'd `y'`i'dl{
reg dwnom1 `x' openprimary `y'pct i.year i.st if `y'==1, cluster(idno)
}
}
}

* Column 5

use data_onepartystates_table3, clear

foreach y in rep dem {
forvalues i = 70(10)90{
foreach x in `y'`i'l `y'`i'v `y'`i'd `y'`i'dl{

reg dwnom1 `x' `y'pctspend `y'pct i.year i.st if `y'==1, cluster(idno)

}
}
}

* Column 6

use data_onepartystates_table3, replace

foreach y in rep dem {
forvalues i = 70(10)90{
foreach x in `y'`i'l `y'`i'v `y'`i'd `y'`i'dl{

reg dwnom1 `x'  `y'leg `y'pct i.year i.st if `y'==1, cluster(idno)

}
}
}

* Column 7

use data_onepartystates_table3, clear

foreach y in rep dem{
forvalues i = 70(10)90{
foreach x in `y'`i'l {

reg dwnom1 `x' incumbent term `y'pct i.year i.st if `y'==1, cluster(idno)

}
}
}

* Column 8
use onepartymeasures_dwnominate_dist_demos_1876to1910, clear // data from carson, jenkins and schickler 2004

foreach y in rep dem {
forvalues i = 70(10)90{
foreach x in `y'`i'l{

reg dwnom1 `x' mfg prez_dem i.year i.st if `y'==1, cluster(idno)

}
}
}

* Column 9
use data_onepartystates_table3, clear // pvote from david brady, updated


foreach y in rep dem{
forvalues i = 70(10)90{
foreach x in `y'`i'l {

reg dwnom1 `x' pctblack pctmfg_all pcturban prez_dem i.year i.st if `y'==1, cluster(idno)

}
}
}


* Column 10
foreach y in rep dem{
forvalues i = 70(10)90{
foreach x in `y'`i'l {

reg dwnom1 `x' prez_dem i.year i.st if `y'==1, cluster(idno)


}
}
}




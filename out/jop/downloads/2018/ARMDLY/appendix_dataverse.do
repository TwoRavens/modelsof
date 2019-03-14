set more off 
clear
clear mata
clear matrix
set mem 100000
cd "C:\Users\nobrian\Box Sync\JOP Dataverse\Data"


* Figure A1.1 * 
use data_onepartystates, clear

forvalues i=56(1)99{

for any rep dem: gen X`i'v = 1 if inrange(rollXvs,`i', 100) & X==1
for any rep dem: replace X`i'v = 0 if inrange(rollXvs,45,55) & X==1

for any rep dem: gen X`i'l = 1 if inrange(rollXleg,`i', 100) & X==1
for any rep dem: replace X`i'l = 0 if inrange(rollXleg,45,55) & X==1

for any rep dem: gen X`i'd = 1 if inrange(percent1,`i',100) & X==1
for any rep dem: replace X`i'd = 0 if inrange(percent1,45,55) & X==1

for any rep dem: gen X`i'dl = 1 if X`i'd == 1 & X`i'l==1 & X==1
for any rep dem: replace X`i'dl = 0 if X`i'd==0 & X`i'l==0 & X==1

}

* Republicans
foreach x in v l d dl{
forvalues i=56(1)99{


preserve
reg dwnom1 rep`i'`x' i.year i.st reppct if rep==1, cluster(idno)
restore
}
}

* Democrats
foreach x in v l d dl{
forvalues i=56(1)99{


preserve
reg dwnom1 dem`i'`x' i.year i.st dempct if dem==1, cluster(idno)
restore
}
}


* Figure A1.2 *
use data_onepartystates, clear

forvalues i=51(1)99{

for any rep dem: gen X`i'v = 1 if inrange(rollXvs,`i', 100) & X==1
for any rep dem: replace X`i'v = 0 if inrange(rollXvs,0, `i'-.000001) & X==1

for any rep dem: gen X`i'l = 1 if inrange(rollXleg,`i', 100) & X==1
for any rep dem: replace X`i'l = 0 if inrange(rollXleg,0, `i'-.000001) & X==1

for any rep dem: gen X`i'd = 1 if inrange(percent1,`i',100) & X==1
for any rep dem: replace X`i'd = 0 if inrange(percent1,0,`i'-.000001) & X==1

for any rep dem: gen X`i'dl = 1 if X`i'd == 1 & X`i'l==1 & X==1
for any rep dem: replace X`i'dl = 0 if X`i'd==0 & X`i'l==0 & X==1

}

* Republicans
foreach x in v l d dl{
forvalues i=51(1)99{

reg dwnom1 rep`i'`x' i.year i.st reppct if rep==1, cluster(idno)

}
}

* Democrats
foreach x in v l d dl{
forvalues i=51(1)99{

reg dwnom1 dem`i'`x' i.year i.st dempct if dem==1, cluster(idno)

}
}


* Figure A2 *
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

foreach x in l v d dl{
for any rep dem: gen w2X70`x' = 1 if X70`x'==1 & X==1
for any rep dem: replace w2X70`x' = 0 if w2X70`x'!=1 & X==1

for any rep dem: gen w2X80`x' = 1 if X80`x'==1 & X==1
for any rep dem: replace w2X80`x' = 0 if w2X80`x'!=1 & X==1

}

foreach x in l v d dl{
for any rep dem: egen wX70`x' = mean(w2X70`x'), by(cong)
for any rep dem: egen wX80`x' = mean(w2X80`x'), by(cong)

}


foreach x in rep dem{
gen `x'holder = 1 if `x'==1
egen rank`x' = rank(dwnom1) if `x'==1, by(cong)
egen total`x' = total(`x'holder) if `x'==1, by(cong)
gen pctile_`x' = rank`x' / total`x'
}
replace pctile_rep = pctile_rep + .5
replace pctile_dem = pctile_dem - .5


foreach x in v l d dl{
forvalues i=70(10)90{
for any rep dem: egen pctile_X`i'`x' = mean(pctile_X) if X`i'`x'==1, by(cong)
}
}

foreach x in l d dl{
sc pctile_rep70`x' year [weight=wrep70`x'], msize(tiny)
sc pctile_dem70`x' year [weight=wdem70`x'], msize(tiny)

}


* Table A4.1 and A4.2 *
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
forvalues i = 70(10)90{
rename dem`i'l d`i'l
rename dem`i'v d`i'v
rename dem`i'd d`i'd
rename dem`i'dl d`i'dl

rename rep`i'l r`i'l
rename rep`i'v r`i'v
rename rep`i'd r`i'd
rename rep`i'dl r`i'dl


}

foreach x in d70l d80l d90l d70v d80v d90v d70dl d80dl d90dl {

reg dwnom1 `x'  i.year if dem==1, cluster(idno)
reg unity `x'  i.year if dem==1, cluster(idno)
reg w1adj `x'  i.year if dem==1, cluster(idno)
reg adjustedada `x'  i.year if dem==1, cluster(idno)
reg baileyadj `x' i.year if dem==1, cluster(idno)
reg wnompctile `x' i.year if dem==1 , cluster(idno)


}

 

foreach x in r70l r80l r90l r70v r80v r90v r70dl r80dl r90dl {

reg dwnom1 `x'  i.year if rep==1, cluster(idno)
reg unity `x'  i.year if rep==1, cluster(idno)
reg w1adj `x'  i.year if rep==1, cluster(idno)
reg adjustedada `x' i.year if rep==1, cluster(idno)
reg baileyadj `x'  i.year if rep==1, cluster(idno)
reg wnompctile `x' i.year if rep==1, cluster(idno)


}



* Table A4.3 and A4.4 *
eststo clear // clear out esttab

foreach x in d70l d80l d90l d70v d80v d90v d70d d80d d90d d70dl d80dl d90dl {

reg dwnom1 `x' dempct i.st i.year, cluster(idno)
reg unity `x' dempct i.st i.year, cluster(idno)
reg w1adj `x' dempct i.st i.year, cluster(idno)
reg adjustedada `x' dempct i.st i.year, cluster(idno)
reg baileyadj `x' dempct i.st i.year, cluster(idno)
reg wnompctile `x' dempct i.st i.year, cluster(idno)


}



foreach x in r70l r80l r90l r70v r80v r90v r70d r80d r90d r70dl r80dl r90dl {

reg dwnom1 `x' reppct i.st i.year, cluster(idno)
reg unity `x' reppct i.st i.year, cluster(idno)
reg w1adj `x' reppct i.st i.year, cluster(idno)
reg adjustedada `x' reppct i.st i.year, cluster(idno)
reg baileyadj `x' reppct i.st i.year, cluster(idno)
reg wnompctile `x' reppct i.st i.year, cluster(idno)


}




* Table A5.1 and A5.2 *
eststo clear

foreach x in d70l d80l d90l d70v d80v d90v d70d d80d d90d d70dl d80dl d90dl {

reg dwnom1 `x' dempct i.st i.year if year>=1896, cluster(idno)
reg dwnom1 `x' dempct i.st i.year if year>=1932, cluster(idno)

}

foreach x in r70l r80l r90l r70v r80v r90v r70d r80d r90d r70dl r80dl r90dl
 {

reg dwnom1 `x' reppct i.st i.year if year>=1896, cluster(idno)
reg dwnom1 `x' reppct i.st i.year if year>=1932, cluster(idno)

}


* Table A6 *
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

forvalues i = 70(10)90{
rename dem`i'l d`i'l
rename dem`i'v d`i'v
rename dem`i'd d`i'd
rename dem`i'dl d`i'dl

rename rep`i'l r`i'l
rename rep`i'v r`i'v
rename rep`i'd r`i'd
rename rep`i'dl r`i'dl
}

foreach x in d70l d80l d90l d70v d80v d90v d70d d80d d90d d70dl d80dl d90dl {

reg dwnom1 dwnom2 `x' dempct i.st i.year if inrange(year,1932,1994), cluster(idno)


}


* Table 7.1 *
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

foreach x in l v d dl{
forvalues i = 70(10)90{
rename dem`i'`x' d`i'`x'
rename rep`i'`x' r`i'`x'
}
}



for any  70 80 90: gen mrXl = 1 if party==200 & inrange(rolldemleg, X, 100)
for any  70 80 90: replace mrXl = 0 if party==200 & rXl==0

for any 70 80 90: gen mdXl = 1 if party==100 & inrange(rollrepleg, X, 100)
for any  70 80 90: replace mdXl = 0 if party==100 & dXl==0

for any  70 80 90: gen mrXv = 1 if party==200 & inrange(rolldemvs, X, 100)
for any  70 80 90: replace mrXv = 0 if party==200 & rXv==0

for any  70 80 90: gen mdXv = 1 if party==100 & inrange(rollrepvs, X, 100)
for any  70 80 90: replace mdXv = 0 if party==100 & dXv==0

for any  70 80 90: gen mrXdl = 1 if party==200 & inrange(rolldemleg, X, 100) & inrange(percent1,X,100)
for any  70 80 90: replace mrXdl = 0 if party==200 & rXdl==0

for any  70 80 90: gen mdXdl = 1  if party==100 & inrange(rollrepleg,X,100) & inrange(percent1,X,100)
for any  70 80 90: replace mdXdl = 0 if party==100 & dXdl==0

* One party MC in majority or minority

for any 70 80 90: gen allrXl = 1 if (mrXl==1 | rXl==1)
for any 70 80 90: replace allrXl = 0 if rXl==0

for any 70 80 90: gen alldXl = 1 if (mdXl==1 | dXl==1)
for any 70 80 90: replace alldXl = 0 if dXl==0

for any 70 80 90: gen allrXv = 1 if (mrXv==1 | rXv==1)
for any 70 80 90: replace allrXv = 0 if rXv==0

for any 70 80 90: gen alldXv = 1 if (mdXv==1 | dXv==1)
for any 70 80 90: replace alldXv = 0 if dXv==0

for any 70 80 90: gen allrXdl = 1 if (mrXdl==1 | rXdl==1)
for any 70 80 90: replace allrXdl = 0 if rXdl==0

for any 70 80 90: gen alldXdl = 1 if (mdXdl==1 | dXdl==1)
for any 70 80 90: replace alldXdl = 0 if dXdl==0


foreach x in allr70l allr80l allr90l allr70v allr80v allr90v allr70dl allr80dl allr90dl{

reg dwnom1 `x' reppct i.year i.st, cluster(idno)
} 

foreach x in alld70l alld80l alld90l alld70v alld80v alld90v alld70dl alld80dl alld90dl{

areg dwnom1 `x' dempct i.st, absorb(year) cluster(idno)

} 



* Table 7.2 *
eststo clear
foreach x in mr70l mr80l mr90l mr70v mr80v mr90v mr70dl mr80dl mr90dl{

areg dwnom1 `x' reppct i.st, absorb(year) cluster(idno)

} 

foreach x in md70l md80l md90l md70v md80v md90v md70dl md80dl md90dl{

areg dwnom1 `x' dempct i.st, absorb(year) cluster(idno)

} 


* Figure 7.3 *

gen r = party==200
gen d = party==100

foreach x in l v d dl{
for any r d: gen mw2X70`x' = 1 if mX70`x'==1 & X==1
for any r d : replace mw2X70`x' = 0 if mw2X70`x'!=1 & X==1

for any r d: gen mw2X80`x' = 1 if mX80`x'==1 & X==1
for any r d: replace mw2X80`x' = 0 if mw2X80`x'!=1 & X==1

}

foreach x in l v d dl{
for any r d: egen mwX70`x' = mean(mw2X70`x'), by(cong)
for any r d: egen mwX80`x' = mean(mw2X80`x'), by(cong)

}


foreach x in r d{
gen `x'holder = 1 if `x'==1
egen rank`x' = rank(dwnom1) if `x'==1, by(cong)
egen total`x' = total(`x'holder) if `x'==1, by(cong)
gen pctile_`x' = rank`x' / total`x'
}
replace pctile_r = pctile_r + .5
replace pctile_d = pctile_d - .5


foreach x in v l d dl{
forvalues i=70(10)90{
for any r d: egen pctile_mX`i'`x' = mean(pctile_X) if mX`i'`x'==1, by(cong)
}
}

* Table 12.1 *

use data_onepartystates_table3, clear
keep if inrange(year,1876,2012)

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

collapse cong70l cong80l cong90l cong70v cong80v cong90v cong70d cong80d cong90d cong70dl cong80dl cong90dl dwrep dwdem, by(year)
gen polar = dwrep - dwdem

merge 1:1 year using institutional_points
keep if _merge==3


for any cong70l cong80l cong90l cong70v cong80v cong90v cong70dl cong80dl cong90dl: corr polar X
for any cong70l cong80l cong90l cong70v cong80v cong90v cong70dl cong80dl cong90dl: pcorr polar chambermargin X
for any cong70l cong80l cong90l cong70v cong80v cong90v cong70dl cong80dl cong90dl: pcorr polar partyshift X


* Table 12.2 *
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



*Make Graph including minority members

forvalues i=70(10)90{
gen over`i'd = 1 if inrange(percent1,`i',100)
replace over`i'd = 0 if inrange(percent1,0,`i'-.00001)

gen over`i'l = 1 if inrange(rolldemleg,`i',100)
replace over`i'l = 1 if inrange(rollrepleg,`i',100)
replace over`i'l = 0 if over`i'l!=1 & rolldemleg!=. & rollrepleg!=.


gen over`i'v = 1 if inrange(rolldemvs,`i',100)
replace over`i'v = 1 if inrange(rollrepvs,`i',100) 
replace over`i'v = 0 if over`i'v!=1 & rollrepvs!=. & rolldemvs!=.


gen over`i'dl = 1 if inrange(rolldemleg,`i',100) & inrange(percent1,`i',100) 
replace over`i'dl = 1 if inrange(rollrepleg,`i',100) & inrange(percent1,`i',100) 
replace over`i'dl = 0 if over`i'dl!=1  & rolldemleg!=. & rollrepleg!=. & percent1!=.

}

for any 70 80 90: egen congXl = mean(overXl), by(year)
for any 70 80 90: egen congXd = mean(overXd), by(year)
for any 70 80 90: egen congXv = mean(overXv), by(year)
for any 70 80 90: egen congXdl = mean(overXdl), by(year)

for any rep dem: egen dwX = mean(dwnom1) if X==1, by(year)


collapse cong70l cong80l cong90l cong70v cong80v cong90v cong70d cong80d cong90d cong70dl cong80dl cong90dl dwrep dwdem, by(year)
gen polar = dwrep - dwdem
merge 1:1 year using institutional_points
keep if _merge==3

for any cong70l cong80l cong90l cong70v cong80v cong90v cong70dl cong80dl cong90dl: corr polar X
for any cong70l cong80l cong90l cong70v cong80v cong90v cong70dl cong80dl cong90dl: pcorr polar chambermargin X
for any cong70l cong80l cong90l cong70v cong80v cong90v cong70dl cong80dl cong90dl: pcorr polar partyshift X







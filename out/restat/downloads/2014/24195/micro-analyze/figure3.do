*** Creates Numbers for Figure 3

clear
set mem 2000m

capture log close
log using figure3.log, replace text

******** A. Create Wage Information Using Selected Sample *************

clear
use ../censusmicro/census80
gen perwt=1
gen year = 1980
keep altmsa perwt Dedu *samp year size_a lincwgb
egen swgt = sum(perwt)
replace perwt = perwt/swgt
drop swgt
append using ../censusmicro/census90
keep altmsa perwt Dedu *samp year size_a lincwgb
replace year = 1990 if year==.
egen swgt = sum(perwt)
replace perwt = perwt/swgt
drop swgt
append using ../censusmicro/census00
keep altmsa perwt Dedu *samp year size_a lincwgb
replace year = 2000 if year==.
egen swgt = sum(perwt)
replace perwt = perwt/swgt
drop swgt
append using ../censusmicro/census07
keep altmsa perwt Dedu *samp year size_a lincwgb
replace year = 2007 if year>2000
egen swgt = sum(perwt)
replace perwt = perwt/swgt
drop swgt

gen scol = Dedu==3
gen col = Dedu==4|Dedu==5
gen lhs = Dedu==1
gen hs = Dedu==1|Dedu==2

*** Figure 3, Panel A: Prices Using Select Sample
table size_a year [aw=perwt] if hoursamp==1 & col==1, contents(mean lincwgb)
table size_a year [aw=perwt] if hoursamp==1 & col==0, contents(mean lincwgb)

*** Additional Info
*Quantities but for selected primeage FTFY white men sample
table size_a year [aw=perwt] if edusamp==1, contents(mean col)
table year [aw=perwt] if edusamp==1, contents(mean lhs mean hs mean scol mean col)
table size_a year  [aw=perwt] if edusamp==1, contents(mean lhs) 
table size_a year [aw=perwt] if edusamp==1, contents(mean hs)



*********** B. Quantities Based on Complete Labor Supply Info ***************

clear
use ../cenmicro-all/census80
gen year = 1980
gen perwt = 1
keep perwt Dedu year size_a perwt wkswork1 uhrswork
append using ../cenmicro-all/census90
keep perwt Dedu year size_a wkswork1 uhrswork
replace year = 1990 if year==.
append using ../cenmicro-all/census00
keep perwt Dedu year size_a wkswork1 uhrswork
replace year = 2000 if year==.
append using ../cenmicro-all/census07
keep perwt Dedu year size_a wkswork1 uhrswork
replace year = 2007 if year>2000
egen swgt = sum(perwt*uhrswork*wkswork1), by(year)
replace perwt = perwt*uhrswork*wkswork1/swgt
drop swgt uhrswork wkswork1

gen scol = Dedu==3
gen col = Dedu==4|Dedu==5
gen lhs = Dedu==1
gen hs = Dedu==1|Dedu==2

*** Figure 3, Panel B: Fraction College
table size_a year [aw=perwt], contents(mean col)


*** Additional stats
table size_a year [aw=perwt], contents(mean hs)
table size_a year [aw=perwt], contents(mean lhs)
table size_a year, contents(sum perwt)


clear
log close


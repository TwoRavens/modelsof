clear
set mem 400m
cd D:\data\cps\data\
foreach num in 3 6 7 {
use "raw\cpsmar0`num'",clear
	drop if a_age <15
	drop if pemlr==0
ren a_age age
ren a_maritl marstat
ren a_sex sex
ren a_hga edu
ren prdtrace race 
ren prdthsp origin
ren gestfips state
	keep pearnval sex marstat age edu race origin state pemlr htotval hearnval a_fnlwgt
ren pearnval income
gen female=sex==2
gen divor=marstat==5
gen elder=age>60
gen hs=edu==39
gen college=edu>39
gen unemp=(pemlr==3|pemlr==4)
*1=white,2=black,3=hispanic,4=indian,5=asian,6=other
recode race 3=4 4=5 5/21=6
replace race=3 if origin>=1 & origin<=5
gen black=race==2
gen indian=race==4
*(updated on Feb 9 2011)
replace income=0 if income<0 
gen inc2=htotval 
gen inc3=hearnval 
collapse income female divor elder hs college black indian (median) inc2 inc3 [pw=a_fnlwgt], by (state)
gen year=2000+`num'
sort state year
save temp\tm`num',replace
	} 
foreach num in 3 6 {
	append using temp\tm`num'
	}
sort state year
cd D:\backup\20100707\research\cps
save tmar2,replace

/*
use D:\backup\Cig_YrlyMktSeries.dta,clear
keep cbsa year ppp
cd D:\backup\20100707\research\cps
sort cbsa year
save pscan2,replace
sort cbsa
merge cbsa using D:\backup\20100707\research\cps\cbsa.dta 
keep if _merge==3
drop _merge
keep msa ppp year
cd D:\backup\20100707\research\cps
sort msa year
save pscan,replace

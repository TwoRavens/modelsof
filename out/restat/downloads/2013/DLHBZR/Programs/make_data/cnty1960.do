set more 1
clear
set mem 20m

insheet using ${RAW}/LAfipscnty_county.csv
sort county
tempfile temp
save `temp'

clear
infix using ${DO}\make_data\cnty1960.dct, using(${RAW}\data_cnty1960.dat)

/*
perurban6 68-72
	poptot6	49-56
	poppernw6 81-84
	numfam	140-146
	medinctot6	147-151
	inclt30006	152-156
	agginc 162-168
	
*/
foreach var in perurban poptot poppernw numfam medinctot perinc aggrinc pertv perphone percar1 percar2 perplumb {
	replace `var'=. if `var'==-9
	*replace `var'=. if `var'==1
	}

gen percapinc6=1000000*aggrinc/poptot
drop aggrinc

foreach var in perinclt3000 poppernw perurban pertv perphone percar1 percar2 perplumb{
	replace `var'=`var'/1000
	replace `var'=. if `var'>1
	}

recode medinc 0=.

gen popwh6=poptot6*(1-poppernw)/100
gen popnw6=poptot-popwh
drop poppernw
compress
drop if cencnty==-9

gen lowinc6=perincl

recode perurban .=0
sort county
keep if icprst==45

sort county
merge county using `temp'
tab _merge
drop _merge
sort fipscnty
save ${DTA}\LAcnty1960, replace

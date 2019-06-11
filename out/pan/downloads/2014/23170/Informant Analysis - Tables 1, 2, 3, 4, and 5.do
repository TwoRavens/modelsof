
*Working Directory
cd "D:\Informant Paper\political_analysis\Replication Materials"

***************
***FUNCTIONS***
***************

*Ensuring that the same number of districts are used for each group
capture program drop districtns
program define districtns
	use "2010 Delegate Data", clear
	keep if year==2010
	collapse (count) `1', by(district)
	drop if `1'==0
	tab district 
	save temp1, replace
	use "2010 YouGov Data", clear
	keep if year==2010
	collapse (count) `1', by(district)
	drop if `1'==0
	tab district 
	save temp2, replace
	if ("`2'"=="CCES") use "CCES Data", clear
	if ("`2'"=="CCES") collapse (count) `1', by(district)
	if ("`2'"=="CCES") drop if `1'==0
	if ("`2'"=="CCES") tab district 
	if ("`2'"=="CCES") save temp3, replace
	use temp1, clear
	merge 1:1 district using temp2
	drop if _merge!=3
	drop _merge
	if ("`2'"=="CCES") merge 1:1 district using temp3
	if ("`2'"=="CCES") drop if _merge!=3
	if ("`2'"=="CCES") drop _merge `1'
	save temp_`1', replace
end

*Mean squared error calculation
capture program drop  mse
program define mse
	merge m:1 district using temp_`1'
	drop if _merge!=3
	drop _merge
	recode01 `1'
	recode01 `2'
	replace `1'=`1'*10
	replace `2'=`2'*10
	reg `2' `1' 
	predict `1'e, resid
	replace `1'e=(`1'e)^2
	sum `1'e
end

*Reliability and correlation calculation
capture program drop relcor
program define relcor
	merge m:1 district using temp_`1'
	drop if _merge!=3
	drop _merge
	loneway `1' district
	collapse `1' `2', by(district)
	cor `1' `2'
end

*Recode to Range from 0 to 1
capture program drop recode01 
program define recode01
	sum `1'
	replace `1'=((`1'-(r(min)))/((r(max)-(r(min)))))
end

*Recode to Mean 0 and Standard Deviation of 1
capture program drop standardize
program define standardize
	sum `1'
	replace `1'=(`1'-r(mean))/r(sd)
end

*Error Equation for Expertise Measure
capture program drop errorcalc 
program define errorcalc
	quietly recode01 `1'
	quietly recode01 `2'
	quietly reg `2' `1' 
	quietly predict `1'e, resid
	quietly replace `1'e=(`1'e)^2
	quietly sum `1'e
	quietly standardize `1'e
end

**********************************
***2009 AND 2010 INFORMANT DATA***
**********************************

*Data
use "Informant Data", clear

*District Data
merge m:1 district using "District-Level Data.dta"
keep if _merge==3
drop _merge

*Variables
g inclc=rlc if repinc10==1
replace inclc=dlc if deminc10==1

*Temporary file
save temp, replace

*2010 Delegate and YouGov Datasets
keep if inftype==1&year==2010
save "2010 YouGov Data", replace
use temp, clear
keep if inftype==2&year==2010
save "2010 Delegate Data", replace

*2009 Delegate and YouGov Datasets
use temp, clear
keep if inftype==1&year==2009
save "2009 YouGov Data", replace
use temp, clear
keep if inftype==2&year==2009
save "2009 Delegate Data", replace

**************************************
***TABLE 1 - DESCRIPTIVE STATISTICS***
**************************************

*Data
use "Informant Data", clear

*Collapse
g n=1

collapse (count) n, by(district year inftype)

*Summary Stats
bysort year inftype: sum n

*Tabulate
bysort year inftype: tab n

**************************************************
***TABLE 2 - INDIVIDUAL-LEVEL MEAN SQUARE ERROR***
**************************************************

*Incumbent ideology
districtns inclc CCES
use "2010 Delegate Data", clear
mse inclc nominate10 
use "2010 YouGov Data", clear
mse inclc nominate10 
use "CCES Data", clear
mse inclc nominate10 

*Senator 1 Ideology
districtns sen1lc  CCES
use "2010 Delegate Data", clear
mse sen1lc nominate10_senator1 
use "2010 YouGov Data", clear
mse sen1lc nominate10_senator1 
use "CCES Data", clear
mse sen1lc nominate10_senator1 

*Senator 2 Ideology
districtns sen2lc CCES
use "2010 Delegate Data", clear
mse sen2lc nominate10_senator2 
use "2010 YouGov Data", clear
mse sen2lc nominate10_senator2 
use "CCES Data", clear
mse sen2lc nominate10_senator2 

*Predicted Winner
districtns winnerpredict
use "2010 Delegate Data", clear
mse winnerpredict demvote10
use "2010 YouGov Data", clear
mse winnerpredict demvote10

*Presidential Vote Share
districtns ivotepres08
use "2010 Delegate Data", clear
mse ivotepres08 dpresvote08
use "2010 YouGov Data", clear
mse ivotepres08 dpresvote08

*******************************************************
***TABLE 3 - DISTRICT-LEVEL RELIABILITY AND VALIDITY***
*******************************************************

*Incumbent ideology
districtns inclc CCES
use "2010 Delegate Data", clear
relcor inclc nominate10 
use "2010 YouGov Data", clear
relcor inclc nominate10 
use "CCES Data", clear
relcor inclc nominate10 

*Senator 1 Ideology
districtns sen1lc  CCES
use "2010 Delegate Data", clear
relcor sen1lc nominate10_senator1 
use "2010 YouGov Data", clear
relcor sen1lc nominate10_senator1 
use "CCES Data", clear
relcor sen1lc nominate10_senator1 

*Senator 2 Ideology
districtns sen2lc CCES
use "2010 Delegate Data", clear
relcor sen2lc nominate10_senator2 
use "2010 YouGov Data", clear
relcor sen2lc nominate10_senator2 
use "CCES Data", clear
relcor sen2lc nominate10_senator2 

*Predicted Winner
districtns winnerpredict
use "2010 Delegate Data", clear
relcor winnerpredict demvote10
use "2010 YouGov Data", clear
relcor winnerpredict demvote10

*Presidential Vote Share
districtns ivotepres08
use "2010 Delegate Data", clear
relcor ivotepres08 dpresvote08
use "2010 YouGov Data", clear
relcor ivotepres08 dpresvote08

*********************************************
***TABLE 4 - EXPLAINING VARIATION IN ERROR***
*********************************************

*Expert Data
use "Informant Data", clear
keep if year==2010

*District Data
merge m:1 district using "District-Level Data.dta"
keep if _merge==3
drop _merge

*Variables
g inclc=rlc if repinc10==1
replace inclc=dlc if deminc10==1

*Number of delegates
recode inftype 1=0 2=1, g(delegate)
egen delegaten=total(delegate), by(district)

*N indicator
g n=1

*District-level measures
collapse (count) n (sd) inclcsd=inclc (mean) inclc absnominate absdistpartymedian nominate10 nominate10se  distcomp term111 chspend repinc10,  by(district inftype)

*Dropping districts without delegates
egen x=count(n), by(district)
drop if x==1

*Error
reg inclc nominate10
predict lcerror, resid
g sqlcerror=abs(lcerror)^2

*Delegate indicator
recode inftype 2=1 1=0, g(delegate)
recode delegate 1=0 0=1, g(yougov)

*Interactions
foreach var of varlist absnominate absdistpartymedian nominate10se  distcomp term111 n chspend repinc10 {
	local l`var' : variable label `var'
	sum `var'
	replace `var'=`var'-r(mean)
	g delX`var'=delegate*`var'
	lab var delX`var'"Delegate Pool X `l`var''"
}

*Model
xtmixed sqlcerror absnominate absdistpartymedian nominate10se chspend distcomp term111 delegate  || district:
xtmixed sqlcerror absnominate absdistpartymedian nominate10se chspend distcomp term111 n delegate  || district:
xtmixed sqlcerror absnominate absdistpartymedian nominate10se chspend distcomp term111 n delegate delXabsnominate delXabsdistpartymediannominate delXnominate10se delXchspend delXdistcomp delXterm111 delXn || district:

*******************************************************
***TABLE 5a - EXPLAING VOTE SHARE WITH DELEGATE DATA***
*******************************************************

*2010 Data
use "2010 Delegate Data", clear

*Estimated Mean Square Error for Expertise Measure
errorcalc sen1lc nominate10_senator1 
errorcalc sen2lc nominate10_senator2
errorcalc winnerpredict demvote10
errorcalc ivotepres08 dpresvote08

*Expertise
alpha sen1lce sen2lce winnerpredicte ivotepres08e if year==2010, g(expertise10)
sum expertise10
replace expertise10=((-1*expertise10)+r(max))/(r(max)-r(min))*99+1
drop if expertise10==.

*Purging
recode ipid 1/3=-1 4=0 5/7=1 *=., g(pid_3)
foreach var of varlist rlc dlc {
	xtmixed `var' pid_3 ||district: pid_3  
	predict pid3_`var' intercept3_`var' , reffects
	g `var'_p=`var'-(_b[pid_3]+pid3_`var')*pid_3 
	drop pid3_`var' intercept3_`var' 
}

*Incumbent Ideology - Purged
g inclc_p=rlc_p if repinc10==1
replace inclc_p=dlc_p if deminc10==1
drop if inclc_p==.

*Alphas
g expertise2=expertise10^2
g expertise4=expertise10^4

*Constructing Weighted Measure
egen sumexpertise2=sum(expertise2), by(district)
egen sumexpertise4=sum(expertise4), by(district)
egen inclc_wp2=sum(expertise2/sumexpertise2*inclc_p), by(district)
egen inclc_wp4=sum(expertise4/sumexpertise4*inclc_p), by(district)

*Saving ideological extremity
collapse inclc*, by(district)
keep inclc*  district
save 2010_data_temp, replace

*2009 Data
use "2009 Delegate Data", clear
keep if year==2009

*Estimated Mean Square Error for Expertise Measure
errorcalc sen1lc nominate10_senator1
errorcalc sen2lc nominate10_senator2
errorcalc distvotehouse10 winvote10  
errorcalc distvotepres08 dpresvote08  

*Expertise
alpha sen1lce sen2lce distvotehouse10e distvotepres08e if year==2009, g(expertise09)
sum expertise09
replace expertise09=((-1*expertise09)+r(max))/(r(max)-r(min))*99+1
drop if expertise09==.

*Incumbent Prospects
recode incwingen 1=7 2=6 3=5 4=4 5=3 6=2 7=1
recode ipid 1/3=-1 4=0 5/7=1 *=., g(pid_3)
replace pid_3=pid_3*-1 if pty111==1


*Purging
foreach var of varlist incwingen {
	xtmixed `var' pid_3 ||district: pid_3  
	predict pid3_`var' intercept3_`var' , reffects
	g `var'_p=`var'-(_b[pid_3]+pid3_`var')*pid_3 

	drop  pid3_`var' intercept3_`var' 
}
drop if incwingen_p==.

*Alphas
g expertise2=expertise09^2
g expertise4=expertise09^4

*Constructing Weighted Measure
egen sumexpertise2=sum(expertise2), by(district)
egen incwingen_wp2=sum(expertise2/sumexpertise2*incwingen_p), by(district)
egen sumexpertise4=sum(expertise4), by(district)
egen incwingen_wp4=sum(expertise4/sumexpertise4*incwingen_p), by(district)

*Equal N's
drop if incwingen==.
drop if incwingen_p==.
drop if incwingen_wp2==.
drop if incwingen_wp4==.

*Saving Prospects Data
collapse incwingen* (count) n=incwingen, by(district)
keep incwingen* district
save 2009_data_temp, replace

*District Data 
use "District-Level Data.dta", clear

*Merging 2010 Informant Data 
merge 1:1 district using 2010_data_temp
drop _merge

*Merging 2009 Informant Data 
merge 1:1 district using 2009_data_temp
drop _merge

*Incumbent Ideological Extremity
g inclcext=abs(inclc-4)
g inclcext_p=abs(inclc_p-4)
g inclcext_wp2=abs(inclc_wp2-4)
g inclcext_wp4=abs(inclc_wp4-4)

*Standardizing
foreach var of varlist inclcext* incwingen* {
	sum `var'
	replace `var'=(`var'-r(mean))/r(sd)
}

*Vote Share Model
eststo clear
eststo: reg incvote10 inclcext  incwingen incvote06 incpresvote incspenddiff repinc10
eststo: reg incvote10 inclcext_p  incwingen_p incvote06 incpresvote incspenddiff repinc10
eststo: reg incvote10 inclcext_wp2  incwingen_wp2 incvote06 incpresvote incspenddiff repinc10
eststo: reg incvote10 inclcext_wp4  incwingen_wp4 incvote06 incpresvote incspenddiff repinc10
csvtable 

*Setting Consistent Districts
keep if e(sample)==1
keep district
save districttemp, replace

*****************************************************
***TABLE 5b - EXPLAING VOTE SHARE WITH YOUGOV DATA***
*****************************************************

*Data
use "2010 YouGov Data", clear

*Estimated Mean Square Error for Expertise Measure
errorcalc sen1lc nominate10_senator1 
errorcalc sen2lc nominate10_senator2
errorcalc winnerpredict demvote10
errorcalc ivotepres08 dpresvote08

*Expertise
alpha sen1lce sen2lce winnerpredicte ivotepres08e if year==2010, g(expertise10)
sum expertise10
replace expertise10=((-1*expertise10)+r(max))/(r(max)-r(min))*99+1
drop if expertise10==.

*Purging
recode ipid 1/3=-1 4=0 5/7=1 *=., g(pid_3)
foreach var of varlist rlc dlc {
	xtmixed `var' pid_3 ||district: pid_3  
	predict pid3_`var' intercept3_`var' , reffects
	g `var'_p=`var'-(_b[pid_3]+pid3_`var')*pid_3 
	drop pid3_`var' intercept3_`var' 
}

*Incumbent Ideology - Purged
g inclc_p=rlc_p if repinc10==1
replace inclc_p=dlc_p if deminc10==1
drop if inclc_p==.

*Alphas
g expertise2=expertise10^2
g expertise4=expertise10^4

*Constructing Weighted Measure
egen sumexpertise2=sum(expertise2), by(district)
egen sumexpertise4=sum(expertise4), by(district)
egen inclc_wp2=sum(expertise2/sumexpertise2*inclc_p), by(district)
egen inclc_wp4=sum(expertise4/sumexpertise4*inclc_p), by(district)

*Saving Ideological extremity
collapse inclc*, by(district)
keep inclc*  district
save 2010_data_temp, replace

*Data
use "2009 YouGov Data", clear
keep if year==2009

*Estimated Mean Square Error for Expertise Measure
errorcalc sen1lc nominate10_senator1
errorcalc sen2lc nominate10_senator2
errorcalc distvotehouse10 winvote10  
errorcalc distvotepres08 dpresvote08  

*Expertise
alpha sen1lce sen2lce distvotehouse10e distvotepres08e if year==2009, g(expertise09)
sum expertise09
replace expertise09=((-1*expertise09)+r(max))/(r(max)-r(min))*99+1
drop if expertise09==.

*Incumbent Prospects
recode incwingen 1=7 2=6 3=5 4=4 5=3 6=2 7=1
recode ipid 1/3=-1 4=0 5/7=1 *=., g(pid_3)
replace pid_3=pid_3*-1 if pty111==1


*Purging
foreach var of varlist incwingen {
	xtmixed `var' pid_3 ||district: pid_3  
	predict pid3_`var' intercept3_`var' , reffects
	g `var'_p=`var'-(_b[pid_3]+pid3_`var')*pid_3 

	drop  pid3_`var' intercept3_`var' 
}
drop if incwingen_p==.

*Alphas
g expertise2=expertise09^2
g expertise4=expertise09^4

*Constructing Weighted Measure
egen sumexpertise2=sum(expertise2), by(district)
egen incwingen_wp2=sum(expertise2/sumexpertise2*incwingen_p), by(district)
egen sumexpertise4=sum(expertise4), by(district)
egen incwingen_wp4=sum(expertise4/sumexpertise4*incwingen_p), by(district)

*Equal N's
drop if incwingen==.
drop if incwingen_p==.
drop if incwingen_wp2==.
drop if incwingen_wp4==.

*Saving Prospects Data
collapse incwingen* (count) n=incwingen, by(district)
keep incwingen* district
save 2009_data_temp, replace

*District Data 
use "District-Level Data.dta", clear

*Merging 2010 Informant Data 
merge 1:1 district using 2010_data_temp
drop _merge

*Merging 2009 Informant Data 
merge 1:1 district using 2009_data_temp
drop _merge

*Setting Consisitent Districts
merge 1:1 district using districttemp
drop if _merge!=3

*Incumbent Ideological Extremity
g inclcext=abs(inclc-4)
g inclcext_p=abs(inclc_p-4)
g inclcext_wp2=abs(inclc_wp2-4)
g inclcext_wp4=abs(inclc_wp4-4)

*Standardizing
foreach var of varlist inclcext* incwingen* {
	sum `var'
	replace `var'=(`var'-r(mean))/r(sd)
}

*Vote Share Model
eststo clear
eststo: reg incvote10 inclcext  incwingen incvote06 incpresvote incspenddiff repinc10
eststo: reg incvote10 inclcext_p  incwingen_p incvote06 incpresvote incspenddiff repinc10
eststo: reg incvote10 inclcext_wp2  incwingen_wp2 incvote06 incpresvote incspenddiff repinc10
eststo: reg incvote10 inclcext_wp4  incwingen_wp4 incvote06 incpresvote incspenddiff repinc10
csvtable 
*Cleaning Up Folder
! erase *temp*.dta




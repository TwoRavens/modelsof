*********************************************************************************************************
********This code loads CRSP data as well as Fama/French factors, keeps what is needed and saves as dta
*********************************************************************************************************

clear all
set mem 900000
set more off


************************************************************************************
****Set the directory here and create subdirectories as described in dataprep.docx 
************************************************************************************
global dir "Z:\Projekte\HFCN\Analysen\eb_labor_demand\ReStat\test\dataprep3"


global data ${dir}/data
global output ${dir}/output
global do ${dir}/do

************************************************************************************
***CRSP prep
************************************************************************************
***import crsp
import delimited $data/crsp_full.csv

***keep what we need
keep permno date prc shrout ret

**destring ret, all .a etc. also replaced by missing
destring ret, force replace

***save
save "$data\returns.dta", replace

************************************************************************************
***Fama/French prep
************************************************************************************
clear all

***import fama french
import delimited $data/fama_french_factors.csv

***change name of date var
ren dateff date

save "$data\famafrench.dta", replace



************************************************************************************
***CRSP and Fama/French merge
************************************************************************************

clear all

****prepare return Data
use "$data\returns.dta", clear

***sort data
sort date permno

***merge with fama french
merge m:1 date using "$data\famafrench.dta"

***drop few month not available in fama french (before 7/1926)
drop if _merge==1
drop _merge

***keep whats needed
keep permno date ret mktrf rf

**drop all missings
dropmiss, obs any


***create vars

***return minus rf
gen exret=ret-rf
**gen firm ids k from 1 to K,
sort permno
egen id=group(permno)

**gen dates t from 1 to T, 
sort date
egen t=group(date)

***one obs for each id in each month July 1926-December2015; 1074 months, 89.5 years
collapse (firstnm) date ret exret rf mktrf, by(t id)

***drop ids if only observable 1 or 2month 
duplicates tag id, gen(dup)
drop if dup==0 | dup==1


save "$data\final_merged.dta", replace

*************************************************************************************
*****Select and save Period 1931-1965
*************************************************************************************
clear all

use "$data\final_merged.dta", clear

keep if t>54 & t<475
***gen firm ids k from 1 to K,
sort id
ren id idold
egen id=group(idold)

***gen dates t from 1 to T, 
sort t
ren t told
egen t=group(told)


***t id
preserve
sort t id
keep t id
outsheet using "$output\period1\IT.csv", delimiter(";") nonames replace
restore


***returns
preserve
sort t id
keep ret
outsheet using "$output\period1\ret.csv", delimiter(";") nonames replace
restore

***excess returns
preserve
sort t id
keep exret
outsheet using "$output\period1\exret.csv", delimiter(";") nonames replace
restore

***risk free
preserve
sort t id
keep rf
outsheet using "$output\period1\rf.csv", delimiter(";") nonames replace
restore

***risk free
preserve
sort t id
keep mktrf
outsheet using "$output\period1\mktrf.csv", delimiter(";") nonames replace
restore




*************************************************************************************
*****Select and save Period 2009-2015
*************************************************************************************
clear all

use "$data\final_merged.dta", clear

keep if t>990
**gen firm ids k from 1 to K,
sort id
ren id idold
egen id=group(idold)

**gen dates t from 1 to T, 
sort t
ren t told
egen t=group(told)


***t id
preserve
sort t id
keep t id
outsheet using "$output\period2\IT.csv", delimiter(";") nonames replace
restore


***returns
preserve
sort t id
keep ret
outsheet using "$output\period2\ret.csv", delimiter(";") nonames replace
restore

***excess returns
preserve
sort t id
keep exret
outsheet using "$output\period2\exret.csv", delimiter(";") nonames replace
restore

***risk free
preserve
sort t id
keep rf
outsheet using "$output\period2\rf.csv", delimiter(";") nonames replace
restore

***risk free
preserve
sort t id
keep mktrf
outsheet using "$output\period2\mktrf.csv", delimiter(";") nonames replace
restore




*************************************************************************************
*****Select and save Period 2011-2015
*************************************************************************************
clear all

use "$data\final_merged.dta", clear

keep if t>1014
**gen firm ids k from 1 to K,
sort id
ren id idold
egen id=group(idold)

**gen dates t from 1 to T, 
sort t
ren t told
egen t=group(told)


***t id
preserve
sort t id
keep t id
outsheet using "$output\period3\IT.csv", delimiter(";") nonames replace
restore


***returns
preserve
sort t id
keep ret
outsheet using "$output\period3\ret.csv", delimiter(";") nonames replace
restore

***excess returns
preserve
sort t id
keep exret
outsheet using "$output\period3\exret.csv", delimiter(";") nonames replace
restore

***risk free
preserve
sort t id
keep rf
outsheet using "$output\period3\rf.csv", delimiter(";") nonames replace
restore

***risk free
preserve
sort t id
keep mktrf
outsheet using "$output\period3\mktrf.csv", delimiter(";") nonames replace
restore












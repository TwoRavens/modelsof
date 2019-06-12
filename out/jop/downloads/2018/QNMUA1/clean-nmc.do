/* 
NAME: cleanNMC.do
USING .dta file(s): NMC_original.dta
USING .do file(s): none

DESCRIPTION: This program cleans the COW National Military Capabilities data (accessed 3.24.10).  
	Variables are renamed and the data is sorted for merging.
	Data documentation do not indicate whether data is coded for a particular date within a calendar year.
	

AUTHOR: Doug Rice, (updated) Burcin Tamer
ORIGIN DATE: 3.24.10
LAST UPDATE: 1.10.12
*/

**BEGIN**
use nmc-original, clear

rename ccode cowcode
keep cowcode year milex milper
recode milex milper (-9=.)
rename milex nmc_milex
rename milper nmc_milper
gen nmc_logmilex = log(1+nmc_milex)

label var nmc_milex "Military Expenditures (thousands of current year US$); calendar year (NMC)"
label var nmc_logmilex "Log Military Expenditures (thousands of current year US$); calendar year (NMC)"
label var nmc_milper "Military Personnel (thousands); calendar year (NMC)"
drop if cow==678 &year>=1991
replace cow = 678 if cow==679 & year>=1991

sort cowcode year


*clean out the sample to match the global sample		/**/
merge cowcode year using  gwf-original
tab _merge
keep if _merge~=1
drop _merge

sort cowcode year

save nmc-merge, replace
**END**

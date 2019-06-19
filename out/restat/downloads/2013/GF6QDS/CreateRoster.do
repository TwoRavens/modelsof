use  "${Input}\mhd1_dta\mhdlh1.dta" 
sort case 
save ${Output}\Roster, replace


use case treatmnt using "${Input}\mhd1_dta\mhdcvr1.dta" 
sort case
save ${Output}\Cover, replace

/* Merge Roster and Cover */ 
use case person lh01 lh03 lh13 lh14 lh09 lh16 lh18a lh12* lh20 lh21 lh25 lh26 using ${Output}\Roster.dta
sort case 
merge case using ${Output}\Cover.dta, nokeep
drop _merge
sort case person
save ${Output}\Roster, replace
save ${Output}\MainFile, replace

/****************************************************************************/

use case treatmnt bari_num using "${Input}\mhd1_dta\mhdcvr1.dta"
sort case 
save junk, replace

use MainFile
sort case
merge case using junk, nokeep
drop _merge
save ${Output}\MainFile, replace

erase  ${Output}\Cover.dta


use  "${Input}\mhd3_dta\mhdpar1.dta" 
sort case person
save  ${Output}\Parents, replace

use ${Output}\MainFile
sort case person
merge case person using  ${Output}\Parents, nokeep
rename _merge _mergeParents
count
save ${Output}\MainFile, replace


/****** Add age of living fathers from roster ************/ 
use lh12y case person using "${Input}\mhd1_dta\mhdlh1.dta" 
rename lh12y FaAgeR
rename person lh13
sort case lh13 
save c:\Matlab\Cousins\FatherAge, replace

clear
use ${Output}\MainFile
sort case lh13
merge case lh13 using c:\Matlab\Cousins\FatherAge, nokeep
rename _merge _mergeFaAge
save ${Output}\MainFile, replace 

erase ${Output}\FatherAge.dta

use case person check_f check_m par04_f par04_m par05_f par06_f par15b_f par15b_m par16u_f par16a_f par17_f par05_m par06_m par15a_f par15a_m par16u_m par16a_m par17_m par19* par23* using "${Input}\mhd3_dta\mhdpar1.dta" 
rename person lh16
sort case lh16
for var par05_f par06_f par15a_f par15a_m par15b_f par15b_m par16u_f par16a_f par17_f par05_m par06_m par16u_m par16a_m par17_m par19* par23* : rename X SpX
save ${Output}\SpParents, replace

use ${Output}\MainFile
sort case lh16
merge case lh16 using  ${Output}\SpParents, nokeep
rename _merge _mergeSpParents
save ${Output}\MainFile, replace

/***********************************************/

use mg03a mg05b mg15a_1 case person using "C:\Matlab\data2\mhd3_dta\mhdmg1.dta"

sort case person 
save ${Output}\FirstMigration, replace 

use ${Output}\MainFile
sort case person
merge case person using  ${Output}\FirstMigration, nokeep
drop _merge
save ${Output}\MainFile, replace


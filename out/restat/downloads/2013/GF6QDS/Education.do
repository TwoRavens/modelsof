use  "${Input}\mhd1_dta\mhdlh1.dta" 
sort case 
save ${Output}\Roster, replace

/********** MOTHER'S EDUCATION ***********************/ 
use case person lh20 lh21 lh26 using  ${Output}\Roster
rename person lh14
rename lh26 Molh26
rename lh20 Molh20
rename lh21 Molh21
sort case lh14
save  ${Output}\junk, replace

use ${Output}\MainFile
sort case lh14
merge case lh14 using  ${Output}\junk, nokeep
drop _merge
save ${Output}\MainFile, replace

use case person  ed01 ed02* ed03   ed07 ed08a using "${Input}\mhd3_dta\mhded1.dta" 
for var ed01 ed02* ed03   ed07 ed08a: rename X MoX
generate lh14=person
drop person
sort case lh14
save ${Output}\Education, replace

use ${Output}\MainFile
sort case lh14
merge case lh14 using ${Output}\Education, nokeep
rename _merge _mergeMoEd
save ${Output}\MainFile, replace

/***** FATHER'S EDUCATION ***************/ 

use case person lh20 lh21 lh26 using  ${Output}\Roster
rename person lh13
rename lh26 Falh26
rename lh20 Falh20
rename lh21 Falh21
sort case lh13
save junk, replace

use ${Output}\MainFile
sort case lh13
merge case lh13 using  ${Output}\junk, nokeep
drop _merge
save ${Output}\MainFile, replace

use case person  ed01 ed02* ed03   ed07 ed08a using "${Input}\mhd3_dta\mhded1.dta" 
for var ed01 ed02* ed03   ed07 ed08a: rename X FaX
generate lh13=person
drop person
sort case lh13
save ${Output}\Education, replace

use ${Output}\MainFile
sort case lh13
merge case lh13 using ${Output}\Education, nokeep
rename _merge _mergeFaEd
save ${Output}\MainFile, replace

/*********** OWN EDUCATION *****************/ 
use case person  ed01 ed02* ed03   ed07 ed08a using "${Input}\mhd3_dta\mhded1.dta" 
sort case person
save ${Output}\Education, replace

use ${Output}\MainFile
sort case person
merge case person using ${Output}\Education, nokeep
rename _merge _mergeEd
save ${Output}\MainFile, replace

erase ${Output}\Education.dta
erase ${Output}\junk.dta
erase ${Output}\Roster.dta


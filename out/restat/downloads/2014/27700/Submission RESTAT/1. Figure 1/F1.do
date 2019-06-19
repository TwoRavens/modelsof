clear all
cd "H:\Superstars\Submission RESTAT"

use "1. Figure 1\input\SSvaluesbytype.dta", clear
g shnr1=sumSSnr1/total
keep country year sh*
collapse (mean) shnr1 , by(country)
rename sh shnr1_tot
sort country
save "1. Figure 1\input\share_tot.dta", replace
* share manuf at CY

use "1. Figure 1\input\SSvaluesbytype_manuf.dta", clear
g shnr1=sumSSnr1/total
keep country year sh*
collapse (mean) shnr1, by(country)
rename shnr1 shnr1_manuf
merge 1:1 country using "1. Figure 1\input\share_tot.dta"
drop _
egen mean_manuf=mean(shnr1_manuf)
egen mean_tot=mean(shnr1_tot)
save "1. Figure 1\F1.dta", replace

erase "1. Figure 1\input\share_tot.dta"

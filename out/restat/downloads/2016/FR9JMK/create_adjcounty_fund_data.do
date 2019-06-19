clear all
set mem 500m
set more off
cd "C:\Users\Andrea\Desktop\AHA Data\Stata"

/* strip off hb fund by county from main AHA data set

clear 
use aha_county1 
keep fcounty1 year hbfund_tot
destring fcounty1, replace
sort fcounty1 year
save hb_bycounty, replace


/* now use contiguous county data set from ICPSR, US Dept of Commerce Bureau of the Census */

use contigcounties, clear
drop if basefips==var1
drop if var2!="A"
/* want to match on whether adj county had funding so rename this variable as fcounty to merge on */
rename var1 fcounty1
/* copy each observation for all years we have data for */
expand 27
sort basefips fcounty1 
by basefips fcounty: gen year=_n
replace year=(year-1)+1948
sort fcounty1 year
/* merge */
merge fcounty1 year using hb_bycounty
drop if _merge!=3
sort basefips year
drop base1contig2 contigstate contigcounty var2
rename fcounty1 contigfcounty
/* sum over the basefips the amount of adjacent hb funding */
collapse (sum)hbfund_tot, by(basefips year)
rename hbfund_tot hbfund_adjcnty
rename basefips fcounty1

gen yrfund=year if hbfund_adj>0
egen yrfundmin=min(yrfund), by(fcounty1)
drop yrfund
gen hbfund_adj_firsttreat=1 if yrfundmin==year
replace hbfund_adj_firsttreat=0 if missing(hbfund_adj_first)
drop yrfundmin

sort fcounty year year
save adjcounty_fund, replace


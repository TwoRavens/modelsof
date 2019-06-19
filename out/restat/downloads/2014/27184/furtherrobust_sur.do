****do-file to perform robustness check "SUR Model" in Table 7

*executed on Stata 11.2

use basefile.dta

gen w = ln(wage)

*******ALL SECTORS******
*****restricted sample
gen sample = missing(k,l,m)
replace sample = 1-sample
keep if sample == 1


quietly: xi: sureg (av l k trainlshare i.year i.nace2) (w trainlshare i.year i.nace2)
esttab , keep(l k trainlshare) se r2
testnl ([av]trainlshare/[av]l)=[w]trainlshare


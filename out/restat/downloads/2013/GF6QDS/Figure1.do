clear
use MainFile_PR if Female==1
generate Cousin=(MarrCousin==1) 
generate Relative=(MarrRelative==1)
generate PaidDowry=(Dowry==1)
replace YearMarried=1900+YearMarried
drop if YearMarried>1996

collapse (mean) Cousin Relative PaidDowry, by(YearMarried)
drop if YearMarried<1940
kernreg1 Cousin YearMarried, kercode(1) npoint(150) nog gen(mhvar gridvar)
rename mhvar NCousin
rename gridvar YearMarried2
kernreg1 PaidDowry YearMarried, kercode(1) npoint(150) gen(mhvar gridvar)
rename mhvar NDowry
rename gridvar YearMarried4
twoway (line NCousin YearMarried) (line NDowry YearMarried4, yaxis(2) lpattern("-")), ytitle("Fraction of Consanguinous Marriages") ytitle("Fraction of Marriages with Dowry", axis(2)) xtitle(Year of Marriage) xtitle(, size(medium) margin(medsmall)) ytitle(, size(medium) margin(medium)) ytitle(, size(medium) margin(medium) axis(2)) legend(off)  yscale(range(0 .5) axis(2))
graph export Figure1.png, replace
graph export C:\Matlab\Cousins\NewGraphsSept07\Figure1.png, replace





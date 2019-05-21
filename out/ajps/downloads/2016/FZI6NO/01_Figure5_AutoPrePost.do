clear all
cd "~/Dropbox/EconNationalism_Union/UnionInformation/ReplicationPackage"
use "UnionInformation_ReplicationData.dta"

keep if auto==1

gen postyear = 0
replace postyear = 1 if year ==2011 
label var postyear "Post-Shift"

gen trade_reduction = 0 if trade4 == 1 | trade4 == 2 | trade4 == 3
replace trade_reduction = 1 if trade4 == 4 | trade4 == 5
bysort union_name: egen d_trade_reduction = mean(trade_reduction) 

collapse (mean) y = trade_reduction (semean) se_y = trade_reduction, by(postyear union_member)

sort  union_member postyear
gen x = _n

gen yu = y + 1.96*se_y
gen yl = y - 1.96*se_y

label define x 1  "Pre-Shift"  2 "Post-Shift" 3 "Pre-Shift"  4 "Post-Shift" 
label value x x

twoway (scatter y x if x<=2, msymbol(S) ) ///
       (rcap yu  yl x if x<=2) (line y x if x<=2) ///
       (scatter y x if x>=3, msymbol(S) ) ///
       (rcap yu  yl x if x>=3) (line y x if x>=3), ///
  	   xlabel(1(1)2 3(1)4, valuelabel) xtitle(" ") ///
	   ytitle("Mean (Support for Reducing Trade Levels)") legend(off) scheme(s2mono) graphregion(color(white) margin(large)) 

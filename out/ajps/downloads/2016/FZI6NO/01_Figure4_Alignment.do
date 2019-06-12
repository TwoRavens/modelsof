clear all
cd "~/Dropbox/EconNationalism_Union/UnionInformation/ReplicationPackage"
use "UnionInformation_ReplicationData.dta"

* Creating Upper Three Figures in Figure 4 (By Union)

drop if union_name=="Bakery, Confectionery Tobacco Workers (BCTGM)"

gen trade_self = 0 if trade1 == 1| trade1 == 2 | trade1 == 3
replace trade_self = 1 if trade1 == 4 | trade1 == 5
bysort union_name: egen d_trade_self = mean(trade_self) 

gen trade_us = 0 if trade3 == 1 | trade3 == 2 | trade3 == 3
replace trade_us = 1 if trade3 == 4 | trade3 == 5
bysort union_name: egen d_trade_us = mean(trade_us) 

gen trade_reduction = 0 if trade4 == 1 | trade4 == 2 | trade4 == 3
replace trade_reduction = 1 if trade4 == 4 | trade4 == 5
bysort union_name: egen d_trade_reduction = mean(trade_reduction) 

drop if union_score ==.
duplicates drop union_name, force

keep union_name union_score d_trade_reduction d_trade_self d_trade_us

twoway (scatter d_trade_reduction union_score, m(circle) mc(black)) (lfit  d_trade_reduction union_score), graphregion(color(white))  scheme(s2mono) ytitle(Trade Levels (%)) xtitle(Union's Protectionism Score) legend(off) yscale(range(0.1 0.6)) ylabel(0.1(0.1)0.6) ysize(2) xsize(2)
graph save "AlignmentTradeLevel.gph", replace

twoway (scatter d_trade_self union_score, m(circle) mc(black)) (lfit  d_trade_self union_score), graphregion(color(white))  scheme(s2mono) ytitle(Trade on Self (%)) xtitle(Union's Protectionism Score) legend(off) yscale(range(0.1 0.6)) ylabel(0.1(0.1)0.6) ysize(2) xsize(2) 
graph save "AlignmentTradeSelf.gph", replace

twoway (scatter d_trade_us union_score, m(circle) mc(black)) (lfit  d_trade_us union_score), graphregion(color(white))  scheme(s2mono) ytitle(Trade on US (%)) xtitle(Union's Protectionism Score) legend(off) yscale(range(0.1 0.6)) ylabel(0.1(0.1)0.6) ysize(2) xsize(2) 
graph save "AlignmentTradeUS.gph", replace

* Creating Lower Three Figures in Figure 4 (By Industry)

clear all
use "UnionInformation_ReplicationData.dta"

bysort naics: egen average_score = mean(union_score) if naics!=523 & naics!=518 & naics!=334
label var average_score "Industry Average Protectionism Score"

gen trade_reduction = 0 if trade4 == 1 | trade4 == 2 | trade4 == 3
replace trade_reduction = 1 if trade4 == 4 | trade4 == 5
bysort union_member naics: egen d_trade_reduction = mean(trade_reduction) 

gen trade_self = 0 if trade1 == 1| trade1 == 2 | trade1 == 3
replace trade_self = 1 if trade1 == 4 | trade1 == 5
bysort union_member naics: egen d_trade_self = mean(trade_self) 

gen trade_us = 0 if trade3 == 1 | trade3 == 2 | trade3 == 3
replace trade_us = 1 if trade3 == 4 | trade3 == 5
bysort union_member naics: egen d_trade_us = mean(trade_us) 

duplicates drop naics union_member, force

drop if average_score ==.

twoway (scatter d_trade_reduction average_score if union_member==1, m(circle) mc(black)) (lfit  d_trade_reduction average_score if union_member==1, lcolor(black) lpattern(dash) ytitle(Support for Trade Reduction (%)) yscale(range(0.1 0.6)) ylabel(0.1(0.1)0.6)) (scatter d_trade_reduction average_score if union_member==0, msymbol(circle_hollow) mc(black)) (lfit  d_trade_reduction average_score if union_member==0, lcolor(gs7) lpattern(dot) scheme(s2mono) yscale(range(0.1 0.6)) ylabel(0.1(0.1)0.6)), graphregion(color(white)) legend(off) ysize(2) xsize(2)
graph save Graph "AlignmentTradeLevel_Union.gph", replace

twoway (scatter d_trade_self average_score if union_member==1, m(circle) mc(black))  (lfit  d_trade_self average_score if union_member==1, lcolor(black) lpattern(dash) ytitle(Trade Bad for Self/Family (%)) yscale(range(0.1 0.6)) ylabel(0.1(0.1)0.6)) (scatter d_trade_self average_score if union_member==0, msymbol(circle_hollow) mc(black))  (lfit  d_trade_self average_score if union_member==0, lcolor(gs7) lpattern(dot) scheme(s2mono) yscale(range(0.1 0.6)) ylabel(0.1(0.1)0.6)), graphregion(color(white)) legend(off) ysize(2) xsize(2)
graph save Graph "AlignmentTradeSelf_Union.gph", replace

twoway (scatter d_trade_us average_score if union_member==1, m(circle) mc(black)) (lfit d_trade_us average_score if union_member==1, lcolor(black) lpattern(dash) ytitle(Trade Bad for the US (%)) yscale(range(0.1 0.6)) ylabel(0.1(0.1)0.6)) (scatter d_trade_us average_score if union_member==0, msymbol(circle_hollow) mc(black)) (lfit d_trade_us average_score if union_member==0, lcolor(gs7) lpattern(dot) scheme(s2mono) yscale(range(0.1 0.6)) ylabel(0.1(0.1)0.6)), graphregion(color(white)) ysize(2) xsize(2) legend(off)
graph save Graph "AlignmentTradeUS_Union.gph", replace 

* Combining All Six Figures

graph combine AlignmentTradeLevel.gph AlignmentTradeSelf.gph AlignmentTradeUS.gph AlignmentTradeLevel_Union.gph AlignmentTradeSelf_Union.gph AlignmentTradeUS_Union.gph, graphregion(color(white)) 



clear all
cd "D:\Dropbox\princeling\"



*Table 3A*
use price.dta, clear
tabstat lnprice princeling quality lnarea, stat(n mean)
tab salemethod
tabstat lnprice princeling quality lnarea if near1500==1, stat(n mean)
tab salemethod if near1500==1
tabstat lnprice princeling quality lnarea if near500==1, stat(n mean)
tab salemethod if near500==1

*Table 3B*
use province_panel.dta, clear
tab promote if ps==1
tab promote if ps==0
tabstat princeling discount lnarea ties gdpgrowth lngdppc lnpop revgrowth age age2 eduyear if ps==1, stat(n mean sd)
tabstat princeling discount lnarea ties gdpgrowth lngdppc lnpop revgrowth age age2 eduyear if ps==0, stat(n mean sd)

use prefecture_panel.dta, clear
tab promote if ps==1
tab promote if ps==0
tabstat princeling discount lnarea ties gdpgrowth lngdppc lnpop revgrowth age age2 eduyear if ps==1, stat(n mean sd)
tabstat princeling discount lnarea ties gdpgrowth lngdppc lnpop revgrowth age age2 eduyear if ps==0, stat(n mean sd)


**REGRESSIONS**

use price.dta, clear
*Table 5*
eststo clear
eststo: xi: reghdfe lnprice princeling quality lnarea, ab(cityyearusage ind month salemethod state size) cluster(provid firmid) keepsin
eststo: xi: reghdfe lnprice princeling quality lnarea if near1500==1, ab(cityyearusage ind month salemethod state size) cluster(provid firmid) keepsin
eststo: xi: reghdfe lnprice princeling quality lnarea if near500==1, ab(cityyearusage ind month salemethod state size) cluster(provid firmid) keepsin
eststo: xi: reghdfe lnprice princeling pscm quality lnarea, ab(cityyearusage ind month salemethod state size) cluster(provid firmid) keepsin
eststo: xi: reghdfe lnprice princeling pscm quality lnarea if near1500==1, ab(cityyearusage ind month salemethod state size) cluster(provid firmid) keepsin
eststo: xi: reghdfe lnprice princeling pscm quality lnarea if near500==1, ab(cityyearusage ind month salemethod state size) cluster(provid firmid) keepsin
eststo: xi: reghdfe lnprice princeling retired quality lnarea, ab(cityyearusage ind month salemethod state size) cluster(provid firmid) keepsin
eststo: xi: reghdfe lnprice princeling retired quality lnarea if near1500==1, ab(cityyearusage ind month salemethod state size) cluster(provid firmid) keepsin
eststo: xi: reghdfe lnprice princeling retired quality lnarea if near500==1, ab(cityyearusage ind month salemethod state size) cluster(provid firmid) keepsin
esttab using table5.csv, b(%12.3fc) se ar2 nogap replace label order(princeling pscm retired) drop(quality lnarea) 



*Table 6*
use firm_panel.dta, clear
eststo clear
eststo: xi: reghdfe lnarea princeling, ab(year state size) cluster(firmid) keepsin 
eststo: xi: reghdfe lnarea princeling pscm, ab(year state size) cluster(firmid) keepsin 
eststo: xi: reghdfe lnarea princeling retired, ab(year state size) cluster(firmid) keepsin 
esttab using table6.csv, b(%12.3fc) se ar2 nogap replace label order(princeling pscm retired)


*Table 7*
use province_panel.dta, clear
eststo clear
eststo: xi: oprobit promote princeling i.year i.provid if year>=2004 & ps==1
eststo: xi: oprobit promote princeling ties gdpgrowth lngdppc lnpop revgrowth lnpop age age2 eduyear i.year i.provid if year>=2004 & ps==1
eststo: xi: reg promote1 princeling ties gdpgrowth lngdppc lnpop revgrowth  age age2 eduyear i.year i.provid if year>=2004 & ps==1
eststo: xi: oprobit promote discount ties gdpgrowth lngdppc lnpop revgrowth age age2 eduyear i.year i.provid if year>=2004 & ps==1
eststo: xi: oprobit promote lnarea ties gdpgrowth lngdppc lnpop revgrowth age age2 eduyear i.year i.provid if year>=2004 & ps==1
eststo: xi: oprobit promote princeling i.year i.provid if year>=2004 & ps==0
eststo: xi: oprobit promote princeling ties gdpgrowth lngdppc lnpop revgrowth age age2 eduyear i.year i.provid if year>=2004 & ps==0
eststo: xi: reg promote1 princeling ties gdpgrowth lngdppc lnpop revgrowth age age2 eduyear i.year i.provid if year>=2004 & ps==0
eststo: xi: oprobit promote discount ties gdpgrowth lngdppc lnpop revgrowth age age2 eduyear i.year i.provid if year>=2004 & ps==0
eststo: xi: oprobit promote lnarea ties gdpgrowth lngdppc lnpop revgrowth age age2 eduyear i.year i.provid if year>=2004 & ps==0
esttab using table7.csv, b(%12.3fc) se ar2 nogap star(* 0.10 ** 0.05 *** 0.01) replace label order(princeling discount lnarea ties gdpgrowth) drop(_Iyear_* _Iprovid_* lngdppc lnpop age age2 eduyear _cons) 


*Table 8*
use prefecture_panel.dta, clear
eststo clear
eststo: xi: oprobit promote princeling i.year i.prefid if year>=2004 & ps==1
eststo: xi: oprobit promote princeling ties gdpgrowth lngdppc lnpop revgrowth lnpop age age2 eduyear i.year i.prefid if year>=2004 & ps==1
eststo: xi: reg promote1 princeling ties gdpgrowth lngdppc lnpop revgrowth  age age2 eduyear i.year i.prefid if year>=2004 & ps==1
eststo: xi: oprobit promote discount ties gdpgrowth lngdppc lnpop revgrowth age age2 eduyear i.year i.prefid if year>=2004 & ps==1
eststo: xi: oprobit promote lnarea ties gdpgrowth lngdppc lnpop revgrowth age age2 eduyear i.year i.prefid if year>=2004 & ps==1
eststo: xi: oprobit promote princeling i.year i.prefid if year>=2004 & ps==0
eststo: xi: oprobit promote princeling ties gdpgrowth lngdppc lnpop revgrowth age age2 eduyear i.year i.prefid if year>=2004 & ps==0
eststo: xi: reg promote1 princeling ties gdpgrowth lngdppc lnpop revgrowth age age2 eduyear i.year i.prefid if year>=2004 & ps==0
eststo: xi: oprobit promote discount ties gdpgrowth lngdppc lnpop revgrowth age age2 eduyear i.year i.prefid if year>=2004 & ps==0
eststo: xi: oprobit promote lnarea ties gdpgrowth lngdppc lnpop revgrowth age age2 eduyear i.year i.prefid if year>=2004 & ps==0
esttab using table8.csv, b(%12.3fc) se ar2 nogap star(* 0.10 ** 0.05 *** 0.01) replace label order(princeling discount lnarea ties gdpgrowth) drop(_Iyear_* _Iprefid_* lngdppc lnpop age age2 eduyear _cons) 


*Table 9*
use price.dta, clear
eststo clear
eststo: xi: reghdfe lnprice princeling pp1 quality lnarea, ab(cityyearusage ind month salemethod state size) cluster(provid firmid) keepsin
eststo: xi: reghdfe lnprice princeling pp1 quality lnarea if near500==1, ab(cityyearusage ind month salemethod state size) cluster(provid firmid) keepsin
eststo: xi: reghdfe lnprice princeling pp2 quality lnarea, ab(cityyearusage ind month salemethod state size) cluster(provid firmid) keepsin
eststo: xi: reghdfe lnprice princeling pp2 quality lnarea if near500==1, ab(cityyearusage ind month salemethod state size) cluster(provid firmid) keepsin
eststo: xi: reghdfe lnprice princeling pp3 quality lnarea, ab(cityyearusage ind month salemethod state size) cluster(provid firmid) keepsin
eststo: xi: reghdfe lnprice princeling pp3 quality lnarea if near500==1, ab(cityyearusage ind month salemethod state size) cluster(provid firmid) keepsin
eststo: xi: reghdfe lnprice princeling pp1 pp2 pp3 quality lnarea, ab(cityyearusage ind month salemethod state size) cluster(provid firmid) keepsin
eststo: xi: reghdfe lnprice princeling pp1 pp2 pp3 quality lnarea if near500==1, ab(cityyearusage ind month salemethod state size) cluster(provid firmid) keepsin
eststo: xi: reghdfe lnprice princeling pp4 quality lnarea, ab(cityyearusage ind month salemethod state size) cluster(provid firmid) keepsin
eststo: xi: reghdfe lnprice princeling pp4 quality lnarea if near500==1, ab(cityyearusage ind month salemethod state size) cluster(provid firmid) keepsin
esttab using table9.csv, b(%12.3fc) se ar2 nogap replace label order(princeling pp1 pp2 pp3 pp4) drop(quality lnarea) 


*Table 10*
use firm_prov_panel.dta, clear
eststo clear
eststo: xi: reghdfe lnarea princeling pp1, ab(provid year state size) cluster(provid firmid) keepsin 
eststo: xi: reghdfe lnarea princeling inspection pp2, ab(provid year state size) cluster(provid firmid) keepsin 
eststo: xi: reghdfe lnarea princeling xi pp3, ab(provid year state size) cluster(provid firmid) keepsin 
eststo: xi: reghdfe lnarea princeling pp1 inspection pp2 xi pp3, ab(provid year state size) cluster(provid firmid) keepsin 
esttab using table10.csv, b(%12.3fc) se ar2 nogap replace label order(princeling pp1 inspection pp2 xi pp3)


*Table 11*
eststo clear
use province_panel.dta, clear
eststo: xi: oprobit promote princeling post2012 pp1 ties gdpgrowth lngdppc lnpop revgrowth age age2 eduyear i.year i.provid if year>=2004 & ps==1
eststo: xi: oprobit promote princeling inspection pp2 ties gdpgrowth lngdppc lnpop revgrowth age age2 eduyear i.year i.provid if year>=2004 & ps==1
use prefecture_panel.dta, clear
eststo: xi: oprobit promote princeling post2012 pp1 ties gdpgrowth lngdppc lnpop revgrowth age age2 eduyear i.year i.pref if year>=2004 & ps==1
eststo: xi: oprobit promote princeling inspection pp2 ties gdpgrowth lngdppc lnpop revgrowth age age2 eduyear i.year i.pref if year>=2004 & ps==1
use province_panel.dta, clear
eststo: xi: oprobit promote discount post2012 pd1 ties gdpgrowth lngdppc lnpop revgrowth age age2 eduyear i.year i.provid if year>=2004 & ps==1
eststo: xi: oprobit promote discount inspection pd2 ties gdpgrowth lngdppc lnpop revgrowth age age2 eduyear i.year i.provid if year>=2004 & ps==1
use prefecture_panel.dta, clear
eststo: xi: oprobit promote discount post2012 pd1 ties gdpgrowth lngdppc lnpop revgrowth age age2 eduyear i.year i.pref if year>=2004 & ps==1
eststo: xi: oprobit promote discount inspection pd2 ties gdpgrowth lngdppc lnpop revgrowth age age2 eduyear i.year i.pref if year>=2004 & ps==1
use province_panel.dta, clear
eststo: xi: oprobit promote lnarea post2012 alp1 ties gdpgrowth lngdppc lnpop revgrowth age age2 eduyear i.year i.provid if year>=2004 & ps==1
eststo: xi: oprobit promote lnarea post2012 alp2 ties gdpgrowth lngdppc lnpop revgrowth age age2 eduyear i.year i.provid if year>=2004 & ps==1
use prefecture_panel.dta, clear
eststo: xi: oprobit promote lnarea post2012 alp1 gdpgrowth lngdppc lnpop revgrowth age age2 eduyear i.year i.pref if year>=2004 & ps==1
eststo: xi: oprobit promote lnarea post2012 alp2 ties gdpgrowth lngdppc lnpop revgrowth age age2 eduyear i.year i.pref if year>=2004 & ps==1
esttab using table11.csv, b(%12.3fc) se ar2 nogap star(* 0.10 ** 0.05 *** 0.01) label replace order(princeling pp1 pp2 discount pd1 pd2 lnarea alp1 alp2) drop(post2012 inspection ties gdpgrowth lngdppc revgrowth lnpop age age2 eduyear _Iyear_* _Iprefid_*  _Iprovid_* _cons) 


**Figure**

*Figure 4*
use figure4.dta, clear
gen l45=lnprice

twoway (scatter lnpricenear500 lnprice, col(gray) msize(vsmall)) (line l45 lnprice, lcol(black) lwidth(thin)  lpattern(dash)), ///
   graphregion(color(white)) xsize(4) ///
   ytitle("Average Land Price within 500-Meters Radius") ///
   legend(size(small) label(1 "Princeling Land Price") label(2 "45 Degree Line"))
graph save Graph "figure4.gph"


*Figure 5*
use price.dta, replace

tab year, gen(t)
forvalue x=1/13 {
gen pt`x'=princeling*t`x'
}
label var pt3 "2006"
label var pt4 "2007"
label var pt5 "2008"
label var pt6 "2009"
label var pt7 "2010"
label var pt8 "2011"
label var pt9 "2012"
label var pt10 "2013"
label var pt11 "2014"
label var pt12 "2015"
label var pt13 "2016"

eststo: xi: reghdfe lnprice pt3-pt13, ab(cityyearusage ind month salemethod state size) cluster(provid firmid) keepsin
 
coefplot, drop(_con) recast(connected) vertical ciopts(recast(rcap)lcol(black))  /// 
   lpattern(solild) mcolor(black) lcolor(black black) lwidth(thin thin) yline(0, lcol(black)) ///
   graphregion(color(white)) ylabel(-1.2(0.2)0.2) legend(label(1 "Coefficient/95% Confidence Interval")) ///
   ytitle("Price Differences between Princeling vs. Non-Princeling" "Land Transactions")
graph save Graph "figure5.gph"


*Figure 6*
use firm_panel.dta, replace

tab year, gen(t)
forvalue x=1/13 {
gen pt`x'=princeling*t`x'
}
label var pt3 "2006"
label var pt4 "2007"
label var pt5 "2008"
label var pt6 "2009"
label var pt7 "2010"
label var pt8 "2011"
label var pt9 "2012"
label var pt10 "2013"
label var pt11 "2014"
label var pt12 "2015"
label var pt13 "2016"

eststo: xi: reghdfe lnarea pt3-pt13, ab(year state size) cluster(firmid) keepsin 

coefplot, drop(_con) recast(connected) vertical ciopts(recast(rcap)lcol(black))  /// 
   lpattern(solild) mcolor(black) lcolor(black black) lwidth(thin thin) yline(0, lcol(black)) ///
   graphregion(color(white)) legend(label(1 "Coefficient/95% Confidence Interval")) ///
   ytitle("Quantity Differences between Princeling vs. Non-Princeling" "Firms' Land Purchase")
graph save Graph "figure6.gph"   


*Figure 7*
use figure7.dta, replace

twoway (area gap no, color(gray) lcolor(white))(line princeling_price near_price no, lcolor(gray black)), ///
   xlabel(1 "20131001" 11 "20131011" 21 "20131021" 31 "20131031" 41 "20131110" 51 "20131120" 61 "20131130" ///
   71 "20131210" 81 "20131220" 91 "20131230" 101 "20140109" 111 "20140119" 121 "20140129"  ///
   , angle(45)) xtitle("Date") ylabel(-2000(1000)3000, angle(horizontal)) ///
   ytitle("Average Land Price") graphregion(color(white))  xline(62, lcol(black)) ///
   legend(cols(2) label(1 "Price Gap") label(2 "Princelings") label(3 "Non-Princelings (Matched Sample, 500m Radius)")) ///
   title("Panel A: Average Land Prices/Gap", color(black))
graph save Graph "figure7a.gph", replace

twoway (area near_area princeling_area no, color(gray black) lcolor(white black)), ///
   xlabel(1 "20131001" 11 "20131011" 21 "20131021" 31 "20131031" 41 "20131110" 51 "20131120" 61 "20131130" ///
   71 "20131210" 81 "20131220" 91 "20131230" 101 "20140109" 111 "20140119" 121 "20140129"  ///
   , angle(45)) xtitle("Date") ylabel(0(2)6, angle(horizontal)) ///
   ytitle("Average Quantity of Land Purchased") graphregion(color(white))  xline(62, lcol(black)) ///
   legend(cols(1) label(1 "Non-Princelings (Matched Sample, 500m Radius)") label(2 "Princelings")) ///
   title("Panel B: Quantity of Land Purchased", color(black))
graph save Graph "figure7b.gph", replace

graph combine "figure7a.gph" "figure7b.gph", row(2) graphregion(color(white)) ysize(8)
graph save Graph "figure7.gph", replace



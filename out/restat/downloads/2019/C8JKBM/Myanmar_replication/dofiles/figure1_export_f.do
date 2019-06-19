
****** Apparel export of HS61 and HS62 products to Japan ********************************
set more off
clear all
cd "$root"
import excel "comtrade_trade_dataMyanmar2015hs6162.xlsx", firstrow
rename Period year 
rename Reporter co
rename TradeValue value
rename CommodityDescription comdesc
rename CommodityCode comcode

keep year co value comdesc comcode 

gen nk = 0 
replace nk = 1 if comcode == "H1-62" | comcode == "H2-62" | comcode == "H3-62" | comcode == "H4-62"

replace value = value/1000000
sort year nk
graph set window fontface "Times New Roman"

graph twoway (line value year if nk==1 & year>=2000, lcolor(black)) (line value year if nk==0 & year>=2000, lpattern(dash) lcolor(black)), ///
legend(label(1 "Woven apparel (HS62)") label(2 "Knitted apparel (HS61)")) ytitle("Trade Value (million USD)") xtitle("Year") ///
xlabel(2000(1)2015, angle(45)) saving("$results/Graph_export6162_JP", replace) graphregion(color(white))
graph export "$results/Graph_export6162_JP.png", replace 
graph export "$results/Graph_export6162_JP.pdf", replace 

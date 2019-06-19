*****************************************************************************
* table_5_figure_3.do
* Byrne, Kovak, and Michaels - REStat
* Quality-Adjusted Price Measurement
*
* Calculates price indexes in Table 5 and Figure 3.
*
*****************************************************************************

set more off
capture log close
clear
clear matrix

log using table_5_figure_3.txt, text replace

*************************************
* Compute mean prices by cell (quarter, location, wafer, line)

use wafer, clear
collapse (mean) ppw=priceperwafer [aw=waferspurchased], by(loc wafer line quarter)
sort loc wafer line quarter

sort loc wafer line quarter
merge 1:1 loc wafer line quarter using isuppli_shipments
keep if _merge == 3 // all observations have weight (no problem to have weight without observations)
drop _merge

sort loc wafer line quarter
save wafer_collapse, replace

*************************************
* Matched-model index

use wafer_collapse, clear
keep if inlist(loc,1,6,8) // switch to keep only china, singapore, and taiwan
sort quarter loc wafer line
order quarter loc wafer line

egen model = group(loc wafer line)
xtset model quarter

* Paasche
gen num_item_paasche = ppw*shipments
gen den_item_paasche = l.ppw*shipments
gen bothpd_paasche = (num_item_paasche < .) & (den_item_paasche < .)
bysort quarter: egen num_paasche = sum(num_item_paasche) if bothpd_paasche
by quarter: egen den_paasche = sum(den_item_paasche) if bothpd_paasche
gen paasche = num_paasche/den_paasche

* Laspeyres
sort model quarter
gen num_item_lasp = ppw*l.shipments
gen den_item_lasp = l.ppw*l.shipments
gen bothpd_lasp = (num_item_lasp < .) & (den_item_lasp < .)
bysort quarter: egen num_lasp = sum(num_item_lasp) if bothpd_lasp
by quarter: egen den_lasp = sum(den_item_lasp) if bothpd_lasp
gen lasp = num_lasp/den_lasp

collapse (mean) paasche lasp, by(quarter) // should be no variation within quarter

* Fscher
gen fisher = sqrt(paasche*lasp)

* Index numbers
tsset quarter 
gen index_p = 100 if quarter == 1
gen index_l = 100 if quarter == 1
gen index_f = 100 if quarter == 1
forvalues t = 2/28 {
  replace index_p = l.index_p*paasche if quarter == `t'
  replace index_l = l.index_p*lasp if quarter == `t'
  replace index_f = l.index_p*fisher if quarter == `t'
}

*** Matched-model series in Table 5 and Figure 3
list quarter index*, clean

*************************************
* Quality-adjusted unit value index

use wafer_collapse, clear
keep if inlist(loc,1,6,8) // switch to keep only china, singapore, and taiwan
sort quarter loc wafer line
order quarter loc wafer line

******************
* Average-prices each technology x quarter, accounting for
* long-run price gap adjustments.

gen double    qual_adj = 1      if loc==8 // no adjustment for Taiwan
replace qual_adj = 0.9147 if loc==1 // quality-adjust Chinese prices
replace qual_adj = 0.9558 if loc==6 // quality-adjust Singapore prices
gen unitnum_element = shipments * ppw
gen unitden_element = qual_adj * shipments
collapse (sum) unitnum=unitnum_element unitden=unitden_element shipments, ///
         by(quarter wafer line)
gen unitprice = unitnum / unitden
gen expend = unitnum
gen unitshipments = unitden

egen model = group(wafer line)
xtset model quarter

* Paasche
gen num_item_paasche = unitprice*unitshipments
gen den_item_paasche = l.unitprice*unitshipments
gen bothpd_paasche = (num_item_paasche < .) & (den_item_paasche < .)
bysort quarter: egen num_paasche = sum(num_item_paasche) if bothpd_paasche
by quarter: egen den_paasche = sum(den_item_paasche) if bothpd_paasche
gen paasche = num_paasche/den_paasche

* Laspeyres
sort model quarter
gen num_item_lasp = unitprice*l.unitshipments
gen den_item_lasp = l.unitprice*l.unitshipments
gen bothpd_lasp = (num_item_lasp < .) & (den_item_lasp < .)
bysort quarter: egen num_lasp = sum(num_item_lasp) if bothpd_lasp
by quarter: egen den_lasp = sum(den_item_lasp) if bothpd_lasp
gen lasp = num_lasp/den_lasp

collapse (mean) paasche lasp, by(quarter) // should be no variation within quarter

* Fscher
gen fisher = sqrt(paasche*lasp)

* Index numbers
tsset quarter 
gen index_p = 100 if quarter == 1
gen index_l = 100 if quarter == 1
gen index_f = 100 if quarter == 1
forvalues t = 2/28 {
  replace index_p = l.index_p*paasche if quarter == `t'
  replace index_l = l.index_p*lasp if quarter == `t'
  replace index_f = l.index_p*fisher if quarter == `t'
}

*** Quality-adjusted series in Table 5 and Figure 3
list quarter index*, clean

log close


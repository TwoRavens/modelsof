

set more off

use temp/refi2009_response_50pct.dta, clear // from 1_build_refi_response_data.do

keep if inrange(month_vs_refi ,-5,12)
collapse carpurch carpurch_bal ficov5   (count) nid, by(month_vs_refi everco) fast

replace carpurch = carpurch*100
reshape wide carpurch-nid, i(month_vs_refi ) j(everco)

line carpurch? month_vs_refi, ytitle("Prob(new car loan), in %") xtitle("Distance from refinance (months)") xlabel(-4(2)12) legend(order(1 "Non-cash-out refinance" 2 "Cash-out refinance")) xline(0)




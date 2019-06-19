***********************************************************************************
*SCRIPT: Compare Kernels of Distributions
***********************************************************************************

use ${dir_results}\kernel_main_${sales}_${database}.dta, clear
append using ${dir_results}\kernel_main_${sales}_weekly_average_${sales}_${database}.dta
append using ${dir_results}\kernel_main_${sales}_cpi_bppcat_${sales}_${database}.dta
append using ${dir_results}\kernel_main_${sales}_cpi_url_${sales}_${database}.dta

line d x if id=="main" || line d x if id=="weekly_average" , ytitle(Density) xtitle("Size  Price Change (%)") legend(on order( 1 "Online Data" 2 "Weekly Averages" ))  xlabel(-50(10)50)
graph export ${dir_graphs}\distributionchanges3_KERNELS_weekly_${sales}_${database}.png, replace

line d x if id=="main" || line d x if id=="weekly_average" || line d x if id=="cpi_bppcat" || line d x if id=="cpi_url", ytitle(Density) xtitle("Size  Price Change (%)") legend(on order( 1 "Online Data" 2 "Weekly Averages" 3 "Cell-relative Broad Category"  4 "Cell-relative Narrow Category"))
graph export ${dir_graphs}\distributionchanges3_KERNELS_${sales}_${database}.png, replace

**THIS ONE IS USED IN THE PAPER FOR CPI DATA - USA_ALL

line d x if id=="main" || line d x if id=="cpi_url", ytitle(Density) xtitle("Size  Price Change (%)") legend(on order( 1 "Online Data" 2 "CPI Imputation (URL)")) xlabel(-50(10)50)
graph export ${dir_graphs}\distributionchanges3_KERNELS_main_cpi_url_${sales}_${database}.png, replace

***Add Calvo from NS code simulation. The txt file contains simulated log prices using the original NS code except for the frequency of changes (monthly frequency matches online data) and the size of the idiosyncratic shock. 

import delimited "${dir_rawdata}\calvo.txt", clear 
ren v1 price
gen date=1
replace date=date[_n-1]+1 if _n!=1

tsset date
gen mprice=price

*Calculate change in price, both with and without sales, as well as growth rates. Note that the calvo.txt file contains logged prices, so the change is just the difference. 
gen d_mprice=d.mprice
gen gr_mprice=100*d_mprice
format gr_mprice %9.2f

*Keep those that have a change.
keep if abs(d_mprice)>0.00000001
sum gr_mprice
gen abs_gr_mprice=abs(gr_mprice)
sum abs_gr_mprice

******************
*See outliers 
count if gr_mprice!=.
count if gr_mprice>100 & gr_mprice!=.
count if gr_mprice>200 & gr_mprice!=.
count if gr_mprice>500 & gr_mprice!=.
count if gr_mprice>1000 & gr_mprice!=.
count if gr_mprice>1500 & gr_mprice!=.
count if gr_mprice<-90 & gr_mprice!=.

*remove them
replace gr_mprice=. if gr_mprice>120 & gr_mprice!=.
replace gr_mprice=. if gr_mprice<-70 & gr_mprice!=.
*********************

*Binary indicator of change in prices
gen c_mprice=0 if gr_mprice==0
replace c_mprice=1 if gr_mprice!=0 & gr_mprice!=.

*Binary indicator of increase in prices
gen inc_mprice=c_mprice
replace inc_mprice=0 if gr_mprice<0

*Binary indicator of decrease in prices
gen dec_mprice=c_mprice
replace dec_mprice=0 if gr_mprice>0 & gr_mprice!=.

*Binary indicator if there a price change could have been recorded for that id that day (to later know how many ids were included that day, week, etc, taking into account only those cases where there was also a price for the previous day). 
gen c_pricefound=1 if gr_mprice!=.

save "${dir_temp}\temp_calvo.dta", replace
 
histogram gr_mprice, percent width(1)  kdensity scale(1)  ytitle(% of changes) xtitle(Size of price change (%)) title(Distribution of Price Changes) xlabel(-50(10)50)
kdensity gr_mprice if gr_mprice>=-50 & gr_mprice<=50, bwidth(1) normal recast(line) generate(x d)   xlabel(-50(10)50)

keep x d
drop if x==.
gen id="calvo"
save ${dir_results}\kernel_main_calvo.dta, replace
 
 
**************Now make graph for the paper
***for usa, compare to scanner data

clear
use ${dir_results}\kernel_main_${sales}_usa1.dta, clear
replace id="online"
append using ${dir_results}\kernel_main_${sales}_usa_scanner.dta
append using ${dir_results}\kernel_main_${sales}_weekly_average_${sales}_usa1.dta
append using ${dir_results}\kernel_main_${sales}_cpi_bppcat_${sales}_usa1.dta
append using ${dir_results}\kernel_main_${sales}_cpi_url_${sales}_usa1.dta
append using ${dir_results}\kernel_main_calvo.dta
append using ${dir_results}\kernel_main_${sales}_usa_scanner_corrected.dta
append using ${dir_results}\kernel_main_${sales}_weekly_average_correction_${sales}_usa1.dta

line d x if id=="online" || line d x if id=="scanner" , ytitle(Density) xtitle("Size  Price Change (%)") legend(on order( 1 "Online Data" 2 "Scanner Data" ))
graph export ${dir_graphs}\distributionchanges3_KERNELS_scanner_${sales}_usa.png, replace


*For the referee who asked about "correcting" the data. 
line d x if id=="online" || line d x if id=="scanner" || line d x if id=="main", ytitle(Density) xtitle("Size  Price Change (%)") legend(on order( 1 "Online Data" 2 "Scanner Data" 3 "Scanner Data - prices ending with 5 or 9"))
graph export ${dir_graphs}\distributionchanges3_KERNELS_scanner_corrected_${sales}_usa.png, replace


line d x if id=="online" || line d x if id=="scanner" || line d x if id=="weekly_average_corrected" || line d x if id=="main" , ytitle(Density) xtitle("Size  Price Change (%)") legend(on order( 1 "Online Data" 2 "Scanner Data" 3 "Scanner Data - no fractional" 4 "Scanner Data - end 5 or 9"))
graph export ${dir_graphs}\distributionchanges3_KERNELS_scanner_correctednew_${sales}_usa.png, replace


**THIS ONE IS USED IN THE PAPER FOR SCANNER DATA - USA
line d x if id=="online" || line d x if id=="scanner"  || line d x if id=="weekly_average" , ytitle(Density) xtitle("Size of Price Change (%)") legend(on order( 1 "Online Data" 2 "Scanner Data" 3 "Weekly Average" ) rows(1))   xlabel(-50(10)50)
graph export ${dir_graphs}\distributionchanges3_KERNELS_scannerandweekly_${sales}_usa.png, replace


line d x if id=="online" || line d x if id=="scanner"  || line d x if id=="weekly_average" ||(line d x if id=="calvo", lpattern(dot)) , ytitle(Density) xtitle("Size of Price Change (%)") legend(on order( 1 "Online Data" 2 "Scanner Data" 3 "Weekly Average" 4 "Calvo Model") rows(2))   xlabel(-50(10)50)
graph export ${dir_graphs}\distributionchanges3_KERNELS_scannerandweekly_${sales}_usa.png, replace

********************************************************************************
* To accompany Knittel and Metaxoglou
********************************************************************************
clear all
set memo 5000m
set type double
set more off
capture log close

********************************************************************************
* Define globals for paths and files
********************************************************************************
global root     = "C:/DB/Dropbox/RCOptim/ReStat/RESTAT Codes"
global root1    = "$root/2014.06.04 BLP"
global root2    = "$root/2014.06.04 BLP tight inner"
global paper    = "$root/2014.06.04 BLP paper"
global figures  = "$paper/Figures"
global tables   = "$paper/Figures"
global logs     = "$paper/Logs"
global temp     = "$paper/Temp"	

global path_opt1 = "$root1/Optimization results"
global path_opt2 = "$root2/Optimization results"

global path_mkt1 = "$root1/Market power results"
global path_mkt2 = "$root2/Merger results"

global graph_options = "graphregion(fcolor(white) color(white) icolor(white)) plotregion()"

set scheme sj, permanently

graph set window fontface "Times New Roman"
graph set eps    fontface "Times New Roman"

global product_largest = 268
global product_median  = 3772

********************************************************************************
* Median or largest products from optimization
********************************************************************************
import excel using "$root2/Merger results/elast_boot.xlsx", clear sheet("Sheet1") firstrow case(lower)
sort id
save "$temp/blp_elast_own_boot.dta", replace

use "$figures/blp_merger_stats_product_focus.dta", clear
preserve
	keep if flag_largest==1
	keep optmethod_str stvalue id elast_own fval flag_best flag_local
	gen draw=0	
	save "$temp/blp_merger_stats_product_focus_largest.dta", replace	
restore
preserve
	keep if flag_median==1
        keep optmethod_str stvalue id elast_own fval flag_best flag_local
        gen draw=0
	save "$temp/blp_merger_stats_product_focus_median.dta", replace	
restore

********************************************************************************
* Largest product
********************************************************************************
use          "$temp/blp_merger_stats_product_focus_largest.dta", clear
append using "$temp/blp_elast_own_boot.dta"

replace draw=1 if draw>0
keep  if id==268

replace fval=9999 if draw==1
gsort   fval

global elast_own_fval_min=elast_own in 1

gen fval_round=round(fval,0.01)

global myvar elast_own
drop if draw==0 & elast_own>0

* make sure we use the same obs with histogram of figure 2
count if draw==0

kdensity $myvar           , nograph generate(x fx)
kdensity $myvar if draw==0, nograph generate(fx0) at(x)
kdensity $myvar if draw==1, nograph generate(fx1) at(x)

kdensity $myvar if draw==0, nograph generate(x00 fx00) 
kdensity $myvar if draw==1, nograph generate(x11 fx11) 
				
label var fx0 "Optimization Variation"
label var fx1 "Sample Variation"

line fx1 fx0 x, sort $graph_options ///
xtitle("Own-Price Elasticity",margin(medium)) xlabel(-4(0.5)0, format(%5.1f) nogrid)                    ///
ytitle("Density",margin(medium)) yscale(range(0 1.5)) ylabel(0(0.15)1.5, format(%5.2f) nogrid angle(h)) ///
legend(ring(0) pos(2) cols(1)) scale(0.7) 

graph export "$figures/fig_blp_kdens_elast_boot_largest.pdf", replace
graph export "$figures/fig_blp_kdens_elast_boot_largest.eps", replace

line fx1 fx0 x, sort $graph_options ///
xtitle("Own-Price Elasticity",margin(medium)) xlabel(-4(0.5)0, format(%5.1f) nogrid)                    ///
ytitle("Density",margin(medium)) yscale(range(0 1.5)) ylabel(0(0.15)1.5, format(%5.2f) nogrid angle(h)) ///
legend(ring(0) pos(11) cols(1)) scale(1.0) 

graph export "$figures/fig_blp_kdens_elast_boot_largest_beam.pdf", replace
graph export "$figures/fig_blp_kdens_elast_boot_largest_beam.eps", replace

save         "$figures/fig_blp_kdens_elast_boot_largest.dta", replace

********************************************************************************
* Median product
********************************************************************************
use          "$temp/blp_merger_stats_product_focus_median.dta", clear
append using "$temp/blp_elast_own_boot.dta"
replace draw=1 if draw>0
keep  if id==3772

replace fval=9999 if draw==1
gsort   fval

global elast_own_med_fval_min=elast_own in 1

gen fval_round=round(fval,0.01)

sum elast_own if draw==0, detail
return list
global p5=r(p5)

drop if draw==0 & elast_own<$p5

* make sure we use the same obs with histogram of figure 2
count if draw==0

global myvar elast_own

kdensity $myvar           , nograph generate(x fx)
kdensity $myvar if draw==0, nograph generate(fx0) at(x)
kdensity $myvar if draw==1, nograph generate(fx1) at(x)

kdensity $myvar if draw==0, nograph generate(x00 fx00) 
kdensity $myvar if draw==1, nograph generate(x11 fx11) 
				
label var fx0 "Optimization Variation"
label var fx1 "Sample Variation"

line fx1 fx0 x, sort $graph_options  xtitle("Own-Price Elasticity",margin(medium)) /// 
xlabel(-6(0.5)0, format(%5.1f) nogrid) ytitle("Density",margin(medium)) yscale(range(0 1.2)) ylabel(0(0.1)1.2, format(%5.1f) nogrid angle(h)) ///
 legend(ring(0) pos(2) cols(1)) scale(0.7)
 
graph export "$figures/fig_blp_kdens_elast_boot_median.pdf", replace
graph export "$figures/fig_blp_kdens_elast_boot_median.eps", replace

line fx1 fx0 x, sort $graph_options  xtitle("Own-Price Elasticity",margin(medium)) /// 
xlabel(-6(0.5)0, format(%5.1f) nogrid) ytitle("Density",margin(medium)) yscale(range(0 1.2)) ylabel(0(0.1)1.2, format(%5.1f) nogrid angle(h)) ///
 legend(ring(0) pos(2) cols(1)) scale(1.0)

graph export "$figures/fig_blp_kdens_elast_boot_median_beam.pdf", replace
graph export "$figures/fig_blp_kdens_elast_boot_median_beam.eps", replace

save         "$figures/fig_blp_kdens_elast_boot_median.dta", replace

*EOF

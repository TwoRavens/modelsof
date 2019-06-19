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
global root1    = "$root/2014.06.04 NEVO"
global root2    = "$root/2014.06.04 NEVO tight inner"
global paper    = "$root/2014.06.04 NEVO paper"
global figures  = "$paper/Figures"
global tables   = "$paper/Figures"
global logs     = "$paper/Logs"
global temp     = "$paper/Temp"

global path1     = "$root1/Summary"
global path2     = "$root2/Summary"

global path_opt1 = "$root1/Optimization results"
global path_opt2 = "$root2/Optimization results"

global path_mkt1 = "$root1/Market power results"
global path_mkt2 = "$root2/Merger results"

global graph_options = "graphregion(fcolor(white) color(white) icolor(white)) plotregion()"

set scheme sj, permanently

graph set window fontface "Times New Roman"
graph set eps    fontface "Times New Roman"

********************************************************************************
* Analysis at the product level
* Keep observations of interest
********************************************************************************
qui log using "$figures/Nevo merger.log", replace

use "$root1/Merger results/nevo_merger_results03.dta", clear

keep if stvalue==1

egen id = group(brand market)

gsort -share_obs

global product_largest = id in 1
global product_median  = id in 1128

use "$temp/nevo_merger_stats_product.dta", clear

egen id = group(brand market)

* Clean 1. Keep tight NFP and converged
keep if tol_tight==1 & converged==1

gen  share_post_miss     = mi(share_post)
egen share_post_miss_max = max(share_post_miss), by(tol_tight optmethod_str stvalue)

gen  share_post_1        = share_post>1
egen share_post_1_max    = max(share_post_1)   , by(tol_tight optmethod_str stvalue)

gen  share_pre_miss      = mi(share_pre)
egen share_pre_miss_max  = max(share_pre_miss) ,  by(tol_tight optmethod_str stvalue)

gen  share_pre_1         = share_pre>1
egen share_pre_1_max     = max(share_pre_1)    ,  by(tol_tight optmethod_str stvalue)

* Clean 2. Exclude based on market shares
drop if share_post_miss_max>0
drop if  share_pre_miss_max>0
drop if     share_pre_1_max>0
drop if    share_post_1_max>0

* Clean 3. Exclude saddle points
*drop if hess_posdef==0 & flag_local==1
*drop if hess_posdef==0 & flag_best ==1

preserve
	keep fval
	duplicates drop
	sum fval, detail
	qui return  list

	global fval_upper = r(p75)
	global fval_min   = r(min)
restore	

* Clean 4. Exclude based on fval
keep if fval<=$fval_upper

* Mean own elasticity for product with largest market share when fval = fval_min under tight tolerance
sum    elast_own if id == $product_largest & fval == $fval_min
global elast_own_fval_min = r(mean)

* Mean own elasticity for product with median market share  when fval = fval_min under tight tolerance
sum    elast_own if id == $product_median  & fval == $fval_min
global elast_own_med_fval_min = r(mean)

gen flag_largest = id == $product_largest
gen flag_median  = id == $product_median

drop share_post_miss share_post_miss_max share_post_1 share_post_1_max share_pre_miss share_pre_miss_max share_pre_1_max

compress

save "$figures/nevo_merger_stats_product_focus.dta", replace

********************************************************************************
* Median or largest products only
********************************************************************************
use "$figures/nevo_merger_stats_product_focus.dta", clear

keep if id == $product_largest | id==$product_median

tab  brand   if flag_largest==1
tab  brand   if  flag_median==1

table market if flag_largest==1, c(count share_obs mean share_obs )
table market if  flag_median==1, c(count share_obs mean share_obs )

format elast_own %8.3f

********************************************************************************
* Own price elasticity all
********************************************************************************
sum elast_own if id==$product_largest, detail
sum elast_own if id==$product_median , detail

sum       elast_own if id==$product_largest
histogram elast_own if id==$product_largest, $graph_options fraction xline($elast_own_fval_min) xtitle("Own-Price Elasticity",margin(medium)) xlabel(-2.5(0.1)-1.5, format(%5.1f) nogrid) ytitle("Fraction",margin(medium)) yscale(range(0 0.5)) ylabel(0(0.1)0.7, format(%5.2f) nogrid angle(h)) scale(0.7) 
graph export  "$figures/fig_nevo_elast_own_largest.eps", replace
graph export  "$figures/fig_nevo_elast_own_largest.emf", replace

sum       elast_own if id==$product_largest
histogram elast_own if id==$product_largest, $graph_options fraction xline($elast_own_fval_min) xtitle("Own-Price Elasticity",margin(medium)) xlabel(-2.5(0.1)-1.5, format(%5.1f) nogrid) ytitle("Fraction",margin(medium)) yscale(range(0 0.5)) ylabel(0(0.1)0.7, format(%5.2f) nogrid angle(h)) scale(1.0) 
graph export  "$figures/fig_nevo_elast_own_largest_beam.eps", replace
graph export  "$figures/fig_nevo_elast_own_largest_beam.emf", replace


sum       elast_own if id==$product_median
histogram elast_own if id==$product_median, $graph_options fraction xline($elast_own_med_fval_min) xtitle("Own-Price Elasticity",margin(medium)) xlabel(-6(0.5)-2, format(%5.1f) nogrid) ytitle("Fraction",margin(medium)) yscale(range(0 0.45)) ylabel(0(0.05)0.45, format(%5.2f) nogrid angle(h)) scale(0.7) 
graph export  "$figures/fig_nevo_elast_own_median.eps", replace
graph export  "$figures/fig_nevo_elast_own_median.emf", replace


sum       elast_own if id==$product_median
histogram elast_own if id==$product_median, $graph_options fraction xline($elast_own_med_fval_min) xtitle("Own-Price Elasticity",margin(medium)) xlabel(-6(0.5)-2, format(%5.1f) nogrid) ytitle("Fraction",margin(medium)) yscale(range(0 0.45)) ylabel(0(0.05)0.45, format(%5.2f) nogrid angle(h)) scale(1.0) 
graph export  "$figures/fig_nevo_elast_own_median_beam.eps", replace
graph export  "$figures/fig_nevo_elast_own_median_beam.emf", replace

********************************************************************************
* Coefficient of variation all
********************************************************************************
use "$figures/nevo_merger_stats_product_focus.dta", clear

egen elast_own_mean = mean(elast_own), by(id)
egen elast_own_sd   = sd(elast_own)  , by(id)
gen elast_own_cv    = elast_own_sd/abs(elast_own_mean)

collapse (mean) elast_own_cv, by(id)

sum elast_own_cv, detail
global p95=r(p95)

sum  elast_own_cv if elast_own_cv<=$p95
hist elast_own_cv if elast_own_cv<=$p95, $graph_options fraction xtitle("Own-Price Elasticity Coefficient of Variation",margin(medium)) xlabel(0(0.02)0.2, format(%5.2f) nogrid) ytitle("Fraction",margin(medium)) yscale(range(0 0.065)) ylabel(0(0.005)0.065, format(%5.3f) nogrid angle(h)) scale(0.7) 

graph export  "$figures/fig_nevo_elast_own_cv_all.eps", replace
graph export  "$figures/fig_nevo_elast_own_cv_all.emf", replace

sum  elast_own_cv if elast_own_cv<=$p95
hist elast_own_cv if elast_own_cv<=$p95, $graph_options fraction xtitle("Own-Price Elasticity Coefficient of Variation",margin(medium)) xlabel(0(0.02)0.2, format(%5.2f) nogrid) ytitle("Fraction",margin(medium)) yscale(range(0 0.065)) ylabel(0(0.005)0.065, format(%5.3f) nogrid angle(h)) scale(1.0) 

graph export  "$figures/fig_nevo_elast_own_cv_all_beam.eps", replace
graph export  "$figures/fig_nevo_elast_own_cv_all_beam.emf", replace

********************************************************************************
* Distribution of own-price elasticity across local minima
********************************************************************************
* no variation to justify histograms

********************************************************************************
* Analysis at the market level, the price in Nevo 2001 ECTA is cents/serving
* We see mean prices at about 0.12, therefore expressed in dollars 
********************************************************************************
use "$figures/nevo_merger_stats_product_focus.dta", clear

capture drop margin_pre margin_pre_pct margin_post margin_post_pct

global vars_to_collapse tol_tight optmethod optmethod_str stvalue flag_best flag_local converged hess_posdef fval

gen rev_pre         = price_pre*share_pre*mkt_size
gen rev_post        = price_post*share_post*mkt_size

gen margin_pre      = (price_pre-mc)*share_pre*mkt_size
gen margin_post     = (price_post-mc)*share_post*mkt_size

gen margin_pre_pct  =  margin_pre/price_pre
gen margin_post_pct =  margin_post/price_post

collapse (sum) profit_pre profit_post profit_agg quantity share_pre share_post share_agg rev_pre rev_post margin_pre margin_post margin_pre_pct margin_post_pct (mean) mean_CV elast_agg mkt_size, by($vars_to_collapse market)

gen price_pre            =  rev_pre/(share_pre*mkt_size)
gen price_post           = rev_post/(share_post*mkt_size)

replace margin_pre       =  margin_pre/(share_pre*mkt_size)
replace margin_post      = margin_post/(share_post*mkt_size)

replace margin_pre_pct   =  margin_pre_pct/(share_pre*mkt_size)
replace margin_post_pct  = margin_post_pct/(share_post*mkt_size)

gen     profit_chng      = profit_post - profit_pre
gen     profit_agg_chng  = profit_agg -  profit_pre
gen     elast_agg2       = (share_agg-share_pre)/(0.5*share_agg+0.5*share_pre)*100

keep  $vars_to_collapse market quantity mkt_size share_pre share_post share_agg price_pre price_post margin_pre margin_post margin_pre_pct margin_post_pct rev_pre rev_post profit_pre profit_post profit_agg profit_chng profit_agg_chng mean_CV elast_agg elast_agg2 

order $vars_to_collapse market quantity mkt_size share_pre share_post share_agg price_pre price_post margin_pre margin_post margin_pre_pct margin_post_pct rev_pre rev_post profit_pre profit_post profit_agg profit_chng profit_agg_chng mean_CV elast_agg elast_agg2 

format quantity mkt_size  profit_* rev_* mean_CV            %12.4fc
format share_* price_* elast_ag* elast_* margin_*  fval     %12.4fc

sort market fval tol_tight optmethod optmethod_str stvalue 

save "$figures/nevo_merger_stats_focus.dta", replace

********************************************************************************
* Analysis at the market level
********************************************************************************
use "$figures/nevo_merger_stats_focus.dta", clear

sum price*
sum quantity 
sum mkt_size*

global vars_to_collapse tol_tight optmethod optmethod_str stvalue fval flag_local converged hess_posdef

gen     fval_round = round(fval,.02)
*replace fval=fval_round 

preserve
	keep if market==52
	
	collapse (mean) mean_CV profit_post profit_chng elast_agg (min) converged (min) hess_posdef [w=quantity], by(fval optmethod_str flag_local flag_best)

	* quantities were expressed in servings per day
	replace mean_CV     = mean_CV*365
	replace profit_chng = profit_chng*365
	format hess_posdef           %5.0f
	
	save "$tables/nevo_merger_largest.dta", replace
restore

collapse (mean) mean_CV profit_post profit_chng elast_agg (min) converged (min) hess_posdef [w=quantity], by(fval optmethod_str flag_local flag_best)

* quantities were expressed in servings per day
replace mean_CV     = mean_CV*365
replace profit_chng = profit_chng*365

format hess_posdef           %5.0f

********************************************************************************
* Mean Market Compensating Variation
********************************************************************************
global y mean_CV
sum $y, detail
qui return list
global low=r(p5)
global upp=r(p95)

sum $y if fval<5, detail
qui return list
global y_fval_min=r(mean)

global y_low=0
global y_gri=0.05
global y_upp=0.50

global x_low=-1000
global x_gri=50
global x_upp=-400

global xtitle="Compensating Variation"
global ytitle="Fraction"

sum       $y
histogram $y ,  $graph_options fraction xtitle("$xtitle",margin(medium)) ytitle("$ytitle",margin(medium)) yscale(range($y_low $y_upp)) ylabel($y_low($y_gri)$y_upp, format(%5.2f) angle(h) nogrid) xlabel($x_low($x_gri)$x_upp, format(%6.0fc) angle(h)) xline($y_fval_min) scale(0.7)

graph export  "$figures/fig_nevo_CV.eps", replace
graph export  "$figures/fig_nevo_CV.emf", replace

histogram $y ,  $graph_options fraction xtitle("$xtitle",margin(medium)) ytitle("$ytitle",margin(medium)) yscale(range($y_low $y_upp)) ylabel($y_low($y_gri)$y_upp, format(%5.2f) angle(h) nogrid) xlabel($x_low($x_gri)$x_upp, format(%6.0fc) angle(h)) xline($y_fval_min) scale(1.0)

graph export  "$figures/fig_nevo_CV_beam.eps", replace
graph export  "$figures/fig_nevo_CV_beam.emf", replace

sum mean_CV if flag_best==1 | flag_local==1, detail

********************************************************************************
* Mean Market Profit Change
********************************************************************************
global y profit_chng
sum $y, detail
qui return list
global low=r(p5)
global upp=r(p95)

sum $y if fval<5, detail
qui return list
global y_fval_min=r(mean)

global y_low=0
global y_gri=0.05
global y_upp=0.55

global x_low=0.0
global x_gri=20
global x_upp=240

global xtitle="Profit Change"
global ytitle="Fraction"

sum       $y
histogram $y, $graph_options fraction xtitle("$xtitle",margin(medium)) ytitle("$ytitle",margin(medium)) yscale(range($y_low $y_upp)) ylabel($y_low($y_gri)$y_upp, format(%5.2f) angle(h) nogrid) xlabel($x_low($x_gri)$x_upp, format(%6.0fc) angle(h)) xline($y_fval_min) scale(0.7)

graph export  "$figures/fig_nevo_profit_chng.eps", replace
graph export  "$figures/fig_nevo_profit_chng.emf", replace

histogram $y, $graph_options fraction xtitle("$xtitle",margin(medium)) ytitle("$ytitle",margin(medium)) yscale(range($y_low $y_upp)) ylabel($y_low($y_gri)$y_upp, format(%5.2f) angle(h) nogrid) xlabel($x_low($x_gri)$x_upp, format(%6.0fc) angle(h)) xline($y_fval_min) scale(1.0)

graph export  "$figures/fig_nevo_profit_chng_beam.eps", replace
graph export  "$figures/fig_nevo_profit_chng_beam.emf", replace

sum profit_chng if flag_best==1 | flag_local==1, detail

********************************************************************************
* Mean Market Agg. Elasticity
********************************************************************************
global y elast_agg
sum $y, detail
qui return list
global low=r(p5)
global upp=r(p95)

sum $y if fval<5, detail
qui return list
global y_fval_min=r(mean)

global y_low=0
global y_gri=0.1
global y_upp=0.7

global x_low=-1.8
global x_gri= 0.1
global x_upp=-0.8

global xtitle="Aggregate Elasticity"
global ytitle="Fraction"

sum       $y
histogram $y, $graph_options fraction xtitle("$xtitle",margin(medium)) ytitle("$ytitle",margin(medium)) yscale(range($y_low $y_upp)) ylabel($y_low($y_gri)$y_upp, format(%5.2f) angle(h) nogrid) xlabel($x_low($x_gri)$x_upp, format(%6.1fc) angle(h)) xline($y_fval_min) scale(0.7)

graph export  "$figures/fig_nevo_agg_elast.eps", replace
graph export  "$figures/fig_nevo_agg_elast.emf", replace

histogram $y, $graph_options fraction xtitle("$xtitle",margin(medium)) ytitle("$ytitle",margin(medium)) yscale(range($y_low $y_upp)) ylabel($y_low($y_gri)$y_upp, format(%5.2f) angle(h) nogrid) xlabel($x_low($x_gri)$x_upp, format(%6.1fc) angle(h)) xline($y_fval_min) scale(1.0)

graph export  "$figures/fig_nevo_agg_elast_beam.eps", replace
graph export  "$figures/fig_nevo_agg_elast_beam.emf", replace

qui window manage close graph 

sum elast_agg if flag_best==1 | flag_local==1, detail

compress

save           "$tables/nevo_merger.dta", replace

********************************************************************************
* Best
********************************************************************************
preserve
	keep if flag_best==1
	sum mean_CV profit_chng elast_agg, detail
	sort optmethod_str 
    save               "$tables/nevo_merger_best.dta", replace	
	export excel using "$tables/nevo_merger.xlsx"  , sheetreplace firstrow(variables) sheet("Best")
restore

********************************************************************************
* Local
********************************************************************************
preserve
	keep if flag_local==1
	sum mean_CV profit_chng elast_agg, detail
	sort optmethod_str
	
    save               "$tables/nevo_merger_local.dta", replace
	export excel using "$tables/nevo_merger.xlsx"  , sheetreplace firstrow(variables) sheet("local")
restore
qui log close
*EOF

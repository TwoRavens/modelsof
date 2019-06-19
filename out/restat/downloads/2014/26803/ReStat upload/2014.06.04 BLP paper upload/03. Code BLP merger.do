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

********************************************************************************
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

qui log using "$logs/blp_merger.log", replace

********************************************************************************
* Variables of interest: product level
********************************************************************************

use "$root1/Merger results/Adtnl info.dta", clear

gsort -quantity

global product_largest = id in 1
global product_median  = id in 1109

use "$temp/blp_merger_stats_product.dta", clear

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

preserve
	keep fval
	duplicates drop
	sum fval, detail
	qui return  list

	global fval_upper = r(p95)
	global fval_min   = r(min)
	
	gsort  fval
	global fval_min = fval in 1
restore	

disp "fval upper: $fval_upper"
disp "fval_min  : $fval_min"

* Clean 3. Exclude based on fval
keep if fval<=$fval_upper

* Mean own elasticity for product with largest market share 
sum    elast_own if id == $product_largest & fval <= 157.7864
global elast_own_fval_min = r(mean)

* Mean own elasticity for product with median market share
sum    elast_own if id == $product_median  & fval <= 157.7864
global elast_own_med_fval_min = r(mean)

gen flag_largest = id == $product_largest
gen flag_median  = id == $product_median

drop share_post_miss share_post_miss_max share_post_1 share_post_1_max share_pre_miss share_pre_miss_max share_pre_1_max

compress

save "$figures/blp_merger_stats_product_focus.dta", replace

********************************************************************************
* variables of interest: market level
********************************************************************************
use "$figures/blp_merger_stats_product_focus.dta", clear

capture drop margin_pre margin_pre_pct margin_post margin_post_pct

global vars_to_collapse tol_tight optmethod optmethod_str stvalue flag_best flag_local converged hess_posdef fval

gen rev_pre         = price_pre*share_pre*mkt_size
gen rev_post        = price_post*share_post*mkt_size

gen margin_pre      = (price_pre-mc)*share_pre*mkt_size
gen margin_post     = (price_post-mc)*share_post*mkt_size

gen margin_pre_pct  =  margin_pre/price_pre
gen margin_post_pct =  margin_post/price_post

#delimit ;
collapse (sum) profit_pre profit_post profit_agg quantity share_pre share_post share_agg 
rev_pre rev_post margin_pre margin_post margin_pre_pct margin_post_pct 
(mean) mean_CV elast_agg mkt_size, by($vars_to_collapse market);
#delimit cr

gen price_pre            =  rev_pre/(share_pre*mkt_size)
gen price_post           = rev_post/(share_post*mkt_size)

replace margin_pre       =  margin_pre/(share_pre*mkt_size)
replace margin_post      = margin_post/(share_post*mkt_size)

replace margin_pre_pct   =  margin_pre_pct/(share_pre*mkt_size)
replace margin_post_pct  = margin_post_pct/(share_post*mkt_size)

gen     profit_chng      = profit_post - profit_pre
gen     profit_agg_chng  = profit_agg -  profit_pre
gen     elast_agg2       = (share_agg-share_pre)/(0.5*share_agg+0.5*share_pre)*100

#delimit ;
keep  $vars_to_collapse market quantity mkt_size share_pre share_post share_agg 
price_pre price_post margin_pre margin_post margin_pre_pct margin_post_pct 
rev_pre rev_post profit_pre profit_post profit_agg profit_chng profit_agg_chng 
mean_CV elast_agg elast_agg2;
#delimit cr

#delimit ;
order $vars_to_collapse market quantity mkt_size share_pre share_post share_agg 
price_pre price_post margin_pre margin_post margin_pre_pct margin_post_pct 
rev_pre rev_post profit_pre profit_post profit_agg profit_chng profit_agg_chng 
mean_CV elast_agg elast_agg2;
#delimit cr

format quantity mkt_size  profit_* rev_* mean_CV            %12.0fc
format share_* price_* elast_ag* elast_* margin_*  fval     %12.4fc

sort market fval tol_tight optmethod optmethod_str stvalue 

save "$figures/blp_merger_stats_focus.dta", replace

********************************************************************************
* Median or largest products only
********************************************************************************
use "$figures/blp_merger_stats_product_focus.dta", clear

keep if flag_largest==1 | flag_median==1

tab newmodv  if flag_largest==1
tab newmodv  if  flag_median==1

table market if flag_largest==1, c(count share_obs mean share_obs )
table market if  flag_median==1, c(count share_obs mean share_obs )

format elast_own %8.3f

********************************************************************************
* Own price elasticity largest
********************************************************************************
sum elast_own if flag_largest==1               , detail format
sum elast_own if flag_largest==1 & elast_own<0 , detail format

#delimit ;
histogram elast_own if flag_largest==1 & elast_own<0, $graph_options fraction xline($elast_own_fval_min) 
xtitle("Own-Price Elasticity",margin(medium)) xlabel(-4(0.5)0, format(%5.1f) nogrid) ytitle("Fraction",margin(medium)) 
yscale(range(0 0.40)) ylabel(0(0.05)0.40, format(%5.2f) nogrid angle(h)) scale(0.7);
#delimit cr

graph export  "$figures/fig_blp_elast_own_largest.eps", replace
graph export  "$figures/fig_blp_elast_own_largest.pdf", replace

#delimit ;
histogram elast_own if flag_largest==1 & elast_own<0, $graph_options fraction xline($elast_own_fval_min) 
xtitle("Own-Price Elasticity",margin(medium)) xlabel(-4(0.5)0, format(%5.1f) nogrid) ytitle("Fraction",margin(medium)) 
yscale(range(0 0.40)) ylabel(0(0.05)0.40, format(%5.2f) nogrid angle(h)) scale(1.0);
#delimit cr

graph export  "$figures/fig_blp_elast_own_largest_beam.eps", replace
graph export  "$figures/fig_blp_elast_own_largest_beam.pdf", replace

********************************************************************************
* Own price elasticity median
********************************************************************************
sum elast_own if flag_median==1,  detail format
return list
global p5=r(p5)

sum elast_own if flag_median==1 & elast_own>=$p5, detail format

#delimit ;
histogram elast_own if flag_median==1 & elast_own>=$p5, $graph_options fraction xline($elast_own_med_fval_min) 
xtitle("Own-Price Elasticity",margin(medium)) xlabel(-4(0.5)0, format(%5.1f) nogrid) ytitle("Fraction",margin(medium)) 
yscale(range(0 0.35)) ylabel(0(0.05)0.35, format(%5.2f) nogrid angle(h)) scale(0.7); 
#delimit cr

graph export  "$figures/fig_blp_elast_own_median.eps", replace
graph export  "$figures/fig_blp_elast_own_median.pdf", replace

#delimit ;
histogram elast_own if flag_median==1 & elast_own>=$p5, $graph_options fraction xline($elast_own_med_fval_min) 
xtitle("Own-Price Elasticity",margin(medium)) xlabel(-4(0.5)0, format(%5.1f) nogrid) ytitle("Fraction",margin(medium)) 
yscale(range(0 0.35)) ylabel(0(0.05)0.35, format(%5.2f) nogrid angle(h)) scale(1.0); 
#delimit cr

graph export  "$figures/fig_blp_elast_own_median_beam.eps", replace
graph export  "$figures/fig_blp_elast_own_median_beam.pdf", replace

********************************************************************************
* Coefficient of variation all
********************************************************************************
use "$figures/blp_merger_stats_product_focus.dta", clear

egen elast_own_mean = mean(elast_own), by(id)
egen elast_own_sd   = sd(elast_own)  , by(id)
gen elast_own_cv    = elast_own_sd/abs(elast_own_mean)
gen obs             = 1

collapse (mean) elast_own_cv (sum) obs, by(id)

* number of obs used to construct cv
tab obs

sum elast_own_cv, detail
global   p5=r(p5)
global p95=r(p95)

sum  elast_own_cv if elast_own_cv<=$p95

#delimit ;
hist elast_own_cv if elast_own_cv<=$p95, $graph_options fraction 
xtitle("Own-Price Elasticity Coefficient of Variation",margin(medium)) 
xlabel(0.1(0.05)0.7, format(%5.2f) nogrid) ytitle("Fraction",margin(medium)) 
yscale(range(0 0.2)) ylabel(0(0.02)0.2, format(%5.2f) nogrid angle(h)) scale(0.7);
#delimit cr 

graph export  "$figures/fig_blp_elast_own_cv_all.eps", replace
graph export  "$figures/fig_blp_elast_own_cv_all.pdf", replace

sum  elast_own_cv if elast_own_cv<=$p95

#delimit ;
hist elast_own_cv if elast_own_cv<=$p95, $graph_options fraction 
xtitle("Own-Price Elasticity Coefficient of Variation",margin(medium)) 
xlabel(0.1(0.05)0.7, format(%5.2f) nogrid) ytitle("Fraction",margin(medium)) 
yscale(range(0 0.2)) ylabel(0(0.02)0.2, format(%5.2f) nogrid angle(h)) scale(1.0); 
#delimit cr 

graph export  "$figures/fig_blp_elast_own_cv_all_beam.eps", replace
graph export  "$figures/fig_blp_elast_own_cv_all_beam.pdf", replace

********************************************************************************
* Distribution of own-price elasticity across local minima
********************************************************************************
use "$figures/blp_merger_stats_product_focus.dta", clear

keep if flag_local==1

replace fval = round(fval,.1)

qui sum elast_own, detail

global elast_own_p5 = r(p5)

tostring fval, replace force
sort optmethod_str stvalue id
egen flag_first = tag(id fval)

keep if flag_first==1

tab fval

sum elast_own if fval == "157.8" & flag_first == 1 & elast_own < 0 & elast_own >= $elast_own_p5
sum elast_own if fval == "167.6" & flag_first == 1 & elast_own < 0 & elast_own >= $elast_own_p5
sum elast_own if fval == "204.6" & flag_first == 1 & elast_own < 0 & elast_own >= $elast_own_p5
sum elast_own if fval == "211.4" & flag_first == 1 & elast_own < 0 & elast_own >= $elast_own_p5
sum elast_own if fval == "218.6" & flag_first == 1 & elast_own < 0 & elast_own >= $elast_own_p5
sum elast_own if fval == "226.6" & flag_first == 1 & elast_own < 0 & elast_own >= $elast_own_p5
sum elast_own if fval == "248.1" & flag_first == 1 & elast_own < 0 & elast_own >= $elast_own_p5

********************************************************************************
* Analysis at the market level
********************************************************************************
use "$figures/blp_merger_stats_focus.dta", clear

sum price*
sum quantity 
sum mkt_size*

global vars_to_collapse tol_tight optmethod optmethod_str stvalue fval flag_local converged hess_posdef

collapse (mean) mean_CV profit_post profit_chng elast_agg (min) converged (min) hess_posdef [w=quantity], by(fval optmethod_str flag_local flag_best)

format mean_CV profit_post   %12.4fc
format profit_chng elast_agg %12.4fc
format fval                   %5.3f
format hess_posdef            %5.0f

list fval if fval<157.7864

********************************************************************************
* Mean Market Agg. Elasticity
********************************************************************************
global y elast_agg
sum $y, detail
qui return list
global low=r(p5)
global upp=r(p95)

sum $y if fval<157.7864, detail
qui return list
global y_fval_min=r(mean)

global y_low=0
global y_gri=0.05
global y_upp=0.35

global x_low=-2
global x_gri=0.2
global x_upp=-0.4

global xtitle="Aggregate Elasticity"
global ytitle="Fraction"

sum       $y
#delimit ;
histogram $y, $graph_options fraction xtitle("$xtitle",margin(medium)) 
ytitle("$ytitle",margin(medium)) yscale(range($y_low $y_upp)) 
ylabel($y_low($y_gri)$y_upp, format(%5.2f) angle(h) nogrid) 
xlabel($x_low($x_gri)$x_upp, format(%6.1fc) angle(h)) xline($y_fval_min) scale(0.7);
#delimit cr

graph export  "$figures/fig_blp_agg_elast.eps", replace
graph export  "$figures/fig_blp_agg_elast.pdf", replace

sum       $y
#delimit ;
histogram $y, $graph_options fraction xtitle("$xtitle",margin(medium)) 
ytitle("$ytitle",margin(medium)) yscale(range($y_low $y_upp)) 
ylabel($y_low($y_gri)$y_upp, format(%5.2f) angle(h) nogrid) 
xlabel($x_low($x_gri)$x_upp, format(%6.1fc) angle(h)) xline($y_fval_min) scale(1.0);
#delimit cr

graph export  "$figures/fig_blp_agg_elast_beam.eps", replace
graph export  "$figures/fig_blp_agg_elast_beam.pdf", replace

qui window manage close graph 

********************************************************************************
* Mean Market Profit Change
********************************************************************************
global y profit_chng
sum $y, detail
qui return list
global low=r(p10)
global upp=r(p95)

sum $y if fval<157.7864, detail
qui return list
global y_fval_min=r(mean)

global y_low=0
global y_gri=0.05
global y_upp=0.50

global x_low=0
global x_gri=250
global x_upp=3000

global xtitle="Profit Change"
global ytitle="Fraction"

sum $y if $y>=$low & $y<=$upp , detail

sum       $y if $y >= $low & $y<=$upp

#delimit ;
histogram $y if $y >= $low & $y<=$upp, $graph_options fraction xtitle("$xtitle",margin(medium)) 
ytitle("$ytitle",margin(medium)) yscale(range($y_low $y_upp)) 
ylabel($y_low($y_gri)$y_upp, format(%5.2f) angle(h) nogrid) 
xlabel($x_low($x_gri)$x_upp, format(%6.0fc) angle(h)) xline($y_fval_min) scale(0.7);
#delimit cr

graph export  "$figures/fig_blp_profit_chng.eps", replace
graph export  "$figures/fig_blp_profit_chng.pdf", replace

sum       $y if $y >= $low & $y<=$upp

#delimit ;
histogram $y if $y >= $low & $y<=$upp, $graph_options fraction xtitle("$xtitle",margin(medium)) 
ytitle("$ytitle",margin(medium)) yscale(range($y_low $y_upp)) 
ylabel($y_low($y_gri)$y_upp, format(%5.2f) angle(h) nogrid) 
xlabel($x_low($x_gri)$x_upp, format(%6.0fc) angle(h)) xline($y_fval_min) scale(1.0);
#delimit cr

graph export  "$figures/fig_blp_profit_chng_beam.eps", replace
graph export  "$figures/fig_blp_profit_chng_beam.pdf", replace

********************************************************************************
* Mean Market Compensating Variation
********************************************************************************
global y mean_CV
sum $y, detail
qui return list
global low=r(p5)
global upp=r(p95)

sum $y if fval<157.7864, detail
qui return list
global y_fval_min=r(mean)

global y_low=0
global y_gri=0.05
global y_upp=0.40

global x_low=-6000
global x_gri=500
global x_upp=-500

global xtitle="Compensating Variation"
global ytitle="Fraction"

sum $y if $y>=$low & $y<=$upp , detail

sum       $y if $y >= $low & $y < 0

#delimit ;
histogram $y if $y >= $low & $y < 0 , $graph_options fraction xtitle("$xtitle",margin(medium)) 
ytitle("$ytitle",margin(medium)) yscale(range($y_low $y_upp)) ylabel($y_low($y_gri)$y_upp, format(%5.2f) angle(h) nogrid) 
xlabel($x_low($x_gri)$x_upp, format(%6.0fc) angle(h)) xline($y_fval_min) scale(0.7);
#delimit cr

graph export  "$figures/fig_blp_CV.eps", replace
graph export  "$figures/fig_blp_CV.pdf", replace

sum       $y if $y >= $low & $y < 0
#delimit ;
histogram $y if $y >= $low & $y < 0 , $graph_options fraction xtitle("$xtitle",margin(medium)) 
ytitle("$ytitle",margin(medium)) yscale(range($y_low $y_upp)) ylabel($y_low($y_gri)$y_upp, format(%5.2f) angle(h) nogrid) 
xlabel($x_low($x_gri)$x_upp, format(%6.0fc) angle(h)) xline($y_fval_min) scale(1.0);
#delimit cr

graph export  "$figures/fig_blp_CV_beam.eps", replace
graph export  "$figures/fig_blp_CV_beam.pdf", replace

compress

save "$tables/blp_merger.dta", replace

********************************************************************************
* Best
********************************************************************************
preserve
	keep if flag_best==1
    sum mean_CV profit_chng elast_agg, detail
	sort optmethod_str 
    save "$tables/blp_merger_best.dta", replace
	
restore

********************************************************************************
* Local
********************************************************************************
preserve
	keep if flag_local==1
	sum mean_CV profit_chng elast_agg, detail
	sort optmethod_str	
    save "$tables/blp_merger_local.dta", replace	
restore
qui log close
*EOF

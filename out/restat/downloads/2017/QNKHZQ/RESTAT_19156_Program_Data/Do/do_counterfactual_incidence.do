* Paper: "The Economics of Attribute-Based Regulation: Theory and Evidence from Fuel-Economy Standards"
* Authors: Koichiro Ito and James Sallee 
* Also see "readme.txt" file 

*********************
*** Analysis 
*********************

loc filename counterfactual_rc1
foreach x in Flat ABR Efficient {
if "`x'"=="Flat" use $temp/results_flat_`filename',clear
if "`x'"~="Flat" use $temp/results_abr_`filename',clear
if "`x'"~="Flat"  g payoff_ABR = g_func_dollar
if "`x'"=="Efficient" {
drop payoff_Efficient
g payoff_Efficient = payoff_with_trading_Efficient
}
replace payoff_`x' = - payoff_`x'
collapse payoff_`x',by(firmcode)
g ratio_`x' = payoff_`x'/payoff_`x'[1]
list ratio_`x'
save $temp/temp`x',replace
}
use $temp/tempFlat,clear
append using $temp/tempABR $temp/tempEfficient 

set scheme s1mono,perm
twoway connected payoff_Flat firmcode || connected payoff_ABR firmcode,ms(T)  ||  connected payoff_Efficient firmcode,ms(D) lp(solid) || ///
,xlabel(1 "Daihatsu" 2 "Honda" 3 "Toyota" 4 "Mazda" 5 "Mitsubishi" 6 "Nissan" 7 "Subaru" 8 "Suzuki") ///
legend(pos(6) ring(0) r(3) order(1 "Flat" 2 "ABR" 3 "Efficient")) ytitle("Average compliance cost per car ($)") xtitle("") ylabel(-4000(2000)8000,grid) 
graph export $figure/incidence_with_trade.pdf,replace

*** END


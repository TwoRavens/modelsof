/*************************************************************************************************************
This .do file makes figure 3 in Chodorow-Reich, Coglianese, and Karabarbounis, "The Macro Effects of Unemployment Benefit Extensions"
*************************************************************************************************************/

clear all
set more off
discard

/*************************************************************************************************************
Load data
*************************************************************************************************************/
use $monthlydataset, clear
lab var u_revised `"Change in Unemployment Rate (PP)"'
cap lab var v `"Change in Log Vacancies"'
local modelnote `"`"Model: UI increases {it:u} by"' `"3.1 p.p. in Great Recession"'"'

local yline = 0.1365514
local_projection u_revised if baseline_sample, filename(fig3a) figure rhs(epsilon) leads(0(1)8) controls(L(1/12).u_revised) hdfe vce(cluster(state_n monthly)) absorb(state_n monthly) list restore noembed yvalues(-.05(0.05)0.15) yscale(r(-0.085 0.17) titlegap(4.00)) yformat(%9.2f) yline(`yline') arrow((pcarrowi `=0.85*`yline'' 4 `=0.95*`yline'' 4, msize(small) barbsize(small) mcolor(black) lcolor(black))) ttext(`=0.8*`yline'' 4 `modelnote', size(labsize) color(black) placement(6)) ci(90)	
local yline = -0.0439185
local_projection v if v_sample, filename(fig3b) figure rhs(epsilon) leads(0(1)8) controls(L(1/12).u_revised) hdfe vce(cluster(state_n monthly)) absorb(state_n monthly) list restore noembed yvalues(-0.05(0.025)0.025) yscale(r(-0.06 0.03) titlegap(4.00)) yformat(%9.3f) yline(`yline') arrow((pcarrowi `=0.85*`yline'' 4 `=0.95*`yline'' 4, msize(small) barbsize(small) mcolor(black) lcolor(black))) ttext(`=0.8*`yline'' 4 `modelnote', size(labsize) color(black) placement(12)) ci(90)				



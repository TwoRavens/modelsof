/*************************************************************************************************************
This .do file makes figure 2 in Chodorow-Reich, Coglianese, and Karabarbounis, "The Macro Effects of Unemployment Benefit Extensions"
*************************************************************************************************************/

clear all
set more off
discard

/*************************************************************************************************************
Load data
*************************************************************************************************************/
use $monthlydataset, clear
lab var epsilon `"​Innovation in UI Duration Error"'
lab var T_hat `"Change in UI Duration Error"'

local_projection epsilon if baseline_sample, filename(fig2a) figure rhs(epsilon) leads(0(1)8) controls(L(1/12).u_revised) hdfe vce(cluster(state_n monthly)) absorb(state_n monthly) list restore noembed yvalues(-0.2(0.2)1.2) yscale(titlegap(4.00)) yformat(%9.1f) ci(90)				
local_projection T_hat if baseline_sample, filename(fig2b) figure rhs(epsilon) leads(0(1)8) controls(L(1/12).u_revised) hdfe vce(cluster(state_n monthly)) absorb(state_n monthly) list restore noembed yvalues(-0.2(0.2)1.2) yscale(titlegap(4.00)) yformat(%9.1f) ci(90)				

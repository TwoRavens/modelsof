/*************************************************************************************************************
This .do file makes figure 6 in Chodorow-Reich, Coglianese, and Karabarbounis, "The Macro Effects of Unemployment Benefit Extensions"
*************************************************************************************************************/

clear all
set more off
discard

/*************************************************************************************************************
Load data
*************************************************************************************************************/
use $monthlydataset, clear
lab var u_revised `"Change in Unemployment Rate (PP)"'
lab var phi `"Change in Fraction Receiving UI (PP)"'

local_projection u_revised if baseline_sample, filename(fig6a) figure rhs(iurepsilon) leads(0(1)8) controls(L(1/12).u_revised) hdfe vce(cluster(state_n monthly)) absorb(state_n monthly) list restore noembed yvalues(-.05(0.05)0.15) yscale(r(-0.085 0.17) titlegap(4.00)) yformat(%9.2f) ci(90)				
local_projection phi if baseline_sample & !inlist(monthly,tm(2010m4),tm(2003m1)), filename(fig6b) figure rhs(iurepsilon) leads(0(1)8) controls(L(1/12).u_revised) hdfe vce(cluster(state_n monthly)) absorb(state_n monthly) list restore noembed yvalues(-1(0.5)1.5) yscale(r(-1 1.1) titlegap(4.00)) yformat(%9.1f) ci(90)				



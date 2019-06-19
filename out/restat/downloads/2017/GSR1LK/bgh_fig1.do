/*This file simulates earnings used to produce Figure 1 in Bitler, Gelbach, and 
Hoynes (2016) "Can Variation in Subgroups' Average Treatment Effects Explain 
Treatment Effect Heterogeneity? Evidence from a Social Experiment" */

** Pull back data;
use data-final.dta, clear

********************************************************************************
****** Figure 1: Conditional QTE using education and earnings prior to RA ******
***************************** to define subgroups  *****************************
********************************************************************************

** Figure 1a Education: Subgroup QTE
graphsubqte ernq e if quarter>=1 & quarter<=7, vars(gtehsged nohsged) ///
	path(graphs)  namegraph(fig1a) titl(Education) legnd1(HS grad.) ///
	legnd2(HS DO) 

** Figure 1b Earnings 7Q pre-RA: Subgroup QTE
graphsubqte ernq e if quarter>=1 & quarter<=7, vars(ernpq7hi ernpq7lo ///
	noernpq7) path(graphs)  namegraph(fig1b) ///
	titl(Earnings 7th Q pre-RA) legnd1(High) legnd2(Low) legnd3(Zero)

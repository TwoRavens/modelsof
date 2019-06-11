*****************************************
*Name: Martin Vinæs Larsen, Derek Beach and Kasper Møller Hansen*
*Date: September 2016*
*Purpose: Replication do-file for analyses in "How campaigns enhance European issues voting during European Parliament elections"*
*Data: content.dta, content analysis data*
*Machine: Work Desktop*
*Version 13*
******************************************



use "content.dta", clear


*opening log
capture log close
log using content_results.log, replace


**Drawing figure 2 
reg eptopic i.date
margins, over(date)
marginsplot, scheme(s2mono) graphregion(color(white)) ///
title(" ") xscale(reverse) ytitle("Proportion of news stories" "mentioning the EP campaign" " ", size(large)) ///
xtitle(" ""Weeks untill election day", size(large)) ylabe(0(0.1)0.6) ///
ymtick(0(0.05)0.6) xlabel(0 "0" 14 "2"  28 "4" 42 "6" 56 "8")   yline(0)

graph export figure2.eps, replace

*looking at fraction of EU tories which featured different national political actors
ta actor //0=others, parties and government represented roughly 40 pct.
ta mep //roughly 25 pct. featured MEPS

*Looking at distribution of political actors in stories about the EU which mentioned national political actors
ta actor if actor!=0 

*adding up frequencies for anti-EU parties
di 2.07 + 16.36 + 7.04 + 3.11 

log close


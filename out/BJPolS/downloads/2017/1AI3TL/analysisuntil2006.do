drop _all
*change into your working directory:
cd "/Users//`=c(username)'/"
use "/BW_replicationuntil2006.dta"

*OVerview of measurements:
label variable adams "Adams et al."
label variable bischof "Nicheness (Bischof)"
label variable laverhunt "activist orientation"
label variable OffPolMR "policy-seeking"
label variable vshift "public opinion shift"
label variable pshiftt12 "previous policy shift"
label variable votec1 "previous change in votes"
label variable pvoteshift "previous policy shift * previous change in votes"
label variable pshift2 "party policy shift"
label variable adams "Adams et al."
label variable bischof "Nicheness (Bischof)"
label variable laverhunt "activist orientation"
label variable OffPolMR "policy-seeking"
label variable vshift "public opinion shift"
label variable pshiftt12 "previous policy shift"
label variable votec1 "previous change in votes"
label variable pvoteshift "previous policy shift \$\times\$ previous change in votes"


/*****************************/
/******** Descriptives ************/
/*****************************/

*summary table
sutex adams bischof laverhunt OffPolMR pshift2 vshift pshiftt12 votec1, labels minmax
 
*scatter matrix
graph matrix adams bischof OffPolMR laverhunt, ms(Oh) 
corr adams bischof OffPolMR laverhunt 

*nicheness overview
bysort parfam: egen median=median(bischof)
graph hbox bischof, over(parfam, sort(median))
drop median

/*****************************/
/******** Analysis ************/
/*****************************/

tsset partnum electnum

*First step, no interaction:
*Adams
regress pshift2 adams vshift pshiftt12 votec1 pvoteshift ///
Italy Britain Greece Luxembourg Denmark Netherlands Spain, cluster(clnum)
keep if e(sample)

*Bischof
regress pshift2 bischof vshift pshiftt12 votec1 pvoteshift ///
Italy Britain Greece Luxembourg Denmark Netherlands Spain, cluster(clnum)

/***************************************************************************************/
/******** Figure 1: Replication of table 1 in Adams (2006) across the 3 measures ************/
/***************************************************************************************/

*Niche + Laver & Hunt
*write programe to report number of clusters
program estadd_cluster, eclass
	ereturn scalar cluster = e(N_clust)
	end
*change labels to make them LaTeX compatible:
*OVerview of measurements:


*estimate 1 set of models: baseline interactions	
eststo clear
eststo: regress pshift2 i.adams##c.vshift pshiftt12 votec1 pvoteshift Italy Britain Greece Luxembourg Denmark Netherlands Spain, cluster(clnum)
eststo: regress pshift2 c.OffPolMR##c.vshift pshiftt12 votec1 pvoteshift Italy Britain Greece Luxembourg Denmark Netherlands Spain, cluster(clnum)
eststo: regress pshift2 c.laverhunt##c.vshift pshiftt12 votec1 pvoteshift Italy Britain Greece Luxembourg Denmark Netherlands Spain, cluster(clnum)
eststo: regress pshift2 c.bischof##c.vshift pshiftt12 votec1 pvoteshift Italy Britain Greece Luxembourg Denmark Netherlands Spain, cluster(clnum)
estadd cluster : *
esttab using tab1.tex, replace se nobaselevels ///
stats(r2 cluster N) drop(Italy Britain Greece Luxembourg Denmark Netherlands Spain) label ///
title("Party characteristics \& positional shifts") ///
mtitles("Adams" "Office-seeking" "Party organization" "Bischof")  ///
note("Clustered standard errors by election;} \\ \multicolumn{5}{l}{\footnotesize all models include country fixed effect omitted from table") 

*estimate 2 set of models: bischof*vshift + other interactions	
eststo clear
eststo: regress pshift2 pshiftt12 votec1 pvoteshift c.vshift##c.bischof c.laverhunt Italy Britain Greece Luxembourg Denmark Netherlands Spain, cluster(clnum)
eststo: regress pshift2 pshiftt12 votec1 pvoteshift c.vshift##c.bischof c.vshift##c.laverhunt Italy Britain Greece Luxembourg Denmark Netherlands Spain, cluster(clnum)
eststo: regress pshift2 pshiftt12 votec1 pvoteshift c.vshift##c.bischof c.OffPolMR Italy Britain Greece Luxembourg Denmark Netherlands Spain, cluster(clnum)
eststo: regress pshift2 pshiftt12 votec1 pvoteshift c.vshift##c.bischof c.vshift##c.OffPolMR  Italy Britain Greece Luxembourg Denmark Netherlands Spain, cluster(clnum)
eststo: regress pshift2 pshiftt12 votec1 pvoteshift c.vshift##c.bischof i.adams  Italy Britain Greece Luxembourg Denmark Netherlands Spain, cluster(clnum)
eststo: regress pshift2 pshiftt12 votec1 pvoteshift c.vshift##c.bischof c.vshift##i.adams  Italy Britain Greece Luxembourg Denmark Netherlands Spain, cluster(clnum)
estadd cluster : *
esttab using tab2.tex, replace se nobaselevels ///
stats(r2 cluster N) drop(Italy Britain Greece Luxembourg Denmark Netherlands Spain) label ///
title("Does Nicheness matter? Yes") ///
mtitles("Bischof + Activists" "Bischof $\times$ Activists" "Bischof + Office" "Bischof $\times$ Office" "Bischof + Adams" "Bischof $\times$ Adams")  ///
note("Clustered standard errors by election;} \\ \multicolumn{5}{l}{\footnotesize all models include country fixed effect omitted from table") 
program drop estadd_cluster

/*****************************/
/******** Figure 2: Marginal effects across the 4 measures ************
X axis: niche 
*****************************/
gen yaxis=0
*
regress pshift2 i.adams##c.vshift pshiftt12 votec1 pvoteshift ///
Italy Britain Greece Luxembourg Denmark Netherlands Spain, cluster(clnum)
*MARGINS:
margins, dydx(vshift) at(adams=(0 1)) atmeans asbalanced post 
coefplot, vertical ytitle("Effects on linear prediction") ///
title("{bf:Adams et al.}") yline(0, lpattern(shortdash) lcolor(plr1)) ///
xlabel(,nolabels noticks) ///
mlabels(1._at = 3 "mainstream" 2._at =  3 "niche") ciopts(lwidth(medthick)) name(adams)
*Bischof
regress pshift2 c.bischof##c.vshift pshiftt12 votec1 pvoteshift ///
Italy Britain Greece Luxembourg Denmark Netherlands Spain, cluster(clnum)
*
margins, dydx(vshift) at(bischof=(0.13(.01)1.5)) atmeans asbalanced 
marginsplot, recast(line) plot1opts(lcolor(538b) lwidth(medthick)) recastci(rline)  ciopts(lpattern(tight_dot) lwidth(medthick) lcolor(538b)) yline(0, lpattern(shortdash) lcolor(plr1)) ///
 title("{bf:Bischof}") ytitle("Effects on linear prediction")  xtitle("nicheness") xlabel(0 0.2 0.4 0.6 0.8 1.0 1.2 1.4) ///
 addplot( ///
scatter yaxis bischof, ///
mcolor(gs9) msize(vsmall) xlabel(0 0.2 0.4 0.6 0.8 1.0 1.2 1.4)) legend(off) name(bischof)

*Laver & Hunt OffPolMR
regress pshift2 c.vshift##c.OffPolMR pshiftt12 votec1 pvoteshift Italy Britain Greece Luxembourg Denmark Netherlands Spain, cluster(clnum)
*
margins, dydx(vshift) at(OffPolMR=(2.2(.1)17.33)) atmeans asbalanced 
marginsplot, recast(line) plot1opts(lcolor(538b) lwidth(medthick)) recastci(rline)  ciopts(lpattern(tight_dot) lwidth(medium) lcolor(538b)) yline(0, lpattern(shortdash) lcolor(plr1)) ///
 title("{bf:Policy-seeking}") ytitle("Effects on linear prediction")  xtitle("policy-seeking") xlabel(2 6  10 14 18) ///
 addplot( ///
scatter yaxis OffPolMR, ///
mcolor(gs9) msize(vsmall) xlabel(2 6  10 14 18)) legend(off) name(office)

*Laver & Hunt: Policy seeking
regress pshift2 c.vshift##c.laverhunt pshiftt12 votec1 pvoteshift Italy Britain Greece Luxembourg Denmark Netherlands, cluster(clnum)
*
margins, dydx(vshift) at(laverhunt=(-15(.1)7.4)) atmeans asbalanced 
marginsplot, recast(line) plot1opts(lcolor(538b) lwidth(medthick)) recastci(rline)  ciopts(lpattern(tight_dot) lwidth(medium) lcolor(538b)) yline(0, lpattern(shortdash) lcolor(plr1)) ///
 title("{bf:Party organisation}") ytitle("Effects on linear prediction")  xtitle("Party organisation") xlabel(1 5 10 15 20) ///
 addplot( ///
scatter yaxis laverhunt, ///
mcolor(gs9) msize(vsmall) xlabel(-15 -10 -5 0 5 10)) legend(off) name(policy)

graph combine adams bischof office policy, rows(2)
graph drop _all

*appendix stuff:
*Bischof split:
eststo clear
program estadd_cluster, eclass
	ereturn scalar cluster = e(N_clust)
	end
eststo: regress pshift2 c.vshift##c.specialization_stand pshiftt12 votec1 pvoteshift ///
Italy Britain Greece Luxembourg Denmark Netherlands Spain, cluster(clnum)
eststo: regress pshift2 c.vshift##c.nicheness_stand pshiftt12 votec1 pvoteshift ///
Italy Britain Greece Luxembourg Denmark Netherlands Spain, cluster(clnum)
eststo: regress pshift2 c.vshift##c.nicheness_stand c.vshift##c.specialization_stand pshiftt12 votec1 pvoteshift ///
Italy Britain Greece Luxembourg Denmark Netherlands Spain, cluster(clnum)
eststo: regress pshift2 c.laverhunt##c.OffPolMR##c.vshift pshiftt12 votec1 pvoteshift Italy Britain Greece Luxembourg Denmark Netherlands Spain, cluster(clnum)
estadd cluster : *

esttab using tabappendix.tex, replace se nobaselevels ///
stats(r2 cluster N) drop(Italy Britain Greece Luxembourg Denmark Netherlands Spain) label ///
title("Splitting Bischof's index") ///
nonumbers mtitles("Specialication" "Nicheness" "Specialization + Nicheness" "Activist $\times$ Office")  ///
note("Clustered standard errors by election;} \\ \multicolumn{4}{l}{\footnotesize all models include country fixed effect omitted from table")
program drop estadd_cluster 







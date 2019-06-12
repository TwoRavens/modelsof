// Replication Code 
// Bolleyer, Nicole and Ruth, Saskia
// Conceptualizing and Measuring Party Institutionalization in New Democracies
// Journal of Politics

********************************************************************************
*
* STATA 14 Code
*
* Data Sources: Democratic Accountability & Linkages Project (Kitschelt 2013)
*               Polity IV Data (Marschall, Jaggers, and Gurr 2013)
*               Latin American Regulation of Political Parties (Molenaar 2012)
*               www.rulers.org; www.ipu.org/parline/
*
********************************************************************************

use PILA_2017.dta, clear

// Figure 1
scatter valueinf routinization, legend(off) xtitle("Routinization") ytitle("Value Infusion") ///
	xline(.5, lp(dash) lc(black)) yline(.5, lp(dash) lc(black)) mcolor(none) ///
	xscale(range(0 1)) xtick(0 (0.2) 1) xlabel(0 (0.2) 1) ///
	yscale(range(0 1)) ytick(0 (0.2) 1) ylabel(0 (0.2) 1, nogrid) 


// Figure 2: Dimensions of PI in LA
twoway scatter valueinf routinization, mlabel(ptyid) mlabsize(vsmall) msiz(small) mc(black) ///
|| lfit valueinf routinization, legend(off) lc(black) lp(solid) ///
	xtitle("Routinization") ytitle("Value Infusion") ///
	xline(.5, lp(shortdash) lc(gs10)) yline(.5, lp(shortdash) lc(gs10)) ///
	xscale(range(0 1)) xtick(0 (0.2) 1) xlabel(0 (0.2) 1) ///
	yscale(range(0 1)) ytick(0 (0.2) 1) ylabel(0 (0.2) 1, nogrid) 

pwcorr valueinf routinization, sig

// Table 1: Results of OLS Regression Models
global x1 polar enpp subsid legisoff execoff formation group page
global x2 zpolar zenpp zsubsid zlegisoff zexecoff zformation zgroup zpage

* ROUTINIZATION
reg routinization $x1, cluster(country)
est sto rout_reg1
reg routinization $x2, cluster(country)
est sto rout_reg2

* VALUE INFUSION	
reg valueinf $x1, cluster(country)
est sto value_reg1
reg valueinf $x2, cluster(country)
est sto value_reg2

esttab rout_reg1 rout_reg2 value_reg1 value_reg2 using table1.rtf, replace ///
	nogaps nodepvars compress se stats(N r2 r2_a df_r F) ///
	star(+ 0.10 * 0.05 ** 0.01 *** 0.001) b(2)
	
// Figure 3: Predictive Margins of Party System Characteristics

* ROUTINIZATION
quietly: reg routinization $x1, cluster(country)
margins, at(enpp=(2 (2) 9))
marginsplot, recast(line) xtitle("Fragmentation (mean, 1998-2008)") recastci(rline) ciopts(lpattern(dash)) name(enpp, replace)

* VALUE INFUSION
quietly: reg valueinf $x1, cluster(country)
margins, at(polar=(0 (2) 14))
marginsplot, recast(line) xtitle("Polarization") recastci(rline) ciopts(lpattern(dash)) name(pola, replace)

graph combine pola enpp, row(1)

// Figure 4: Predictive Margins of Access to Legislative and Executive Office

* ROUTINIZATION
quietly: reg routinization $x1, cluster(country)
margins, at(legisoff=(0 (10) 60))
marginsplot, recast(line) xtitle("Legislative Office (seat share, %)") recastci(rline) ciopts(lpattern(dash)) name(legis, replace)

* VALUE INFUSION
quietly: reg valueinf $x1, cluster(country)
margins, at(execoff=(0 (.5) 3))
marginsplot, recast(line) xtitle("Executive Office (logged years)") recastci(rline) ciopts(lpattern(dash)) name(exec, replace)

graph combine legis exec, row(1)

// Figure 5: Predictive Margins of Group Ties

* ROUTINIZATION
quietly: reg routinization $x1, cluster(country)
margins, at(group=(0 (.05) 1)) 
marginsplot, recast(line) xtitle("Group Ties") recastci(rline) ciopts(lpattern(dash)) name(group1, replace)

* VALUE INFUSION
quietly: reg valueinf $x1, cluster(country)
margins, at(group=(0 (.05) 1)) 
marginsplot, recast(line) xtitle("Group Ties") recastci(rline) ciopts(lpattern(dash)) name(group2, replace)

graph combine group1 group2, row(1)

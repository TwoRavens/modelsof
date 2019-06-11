
* GENERAL INFO
	* Title: Ethnic Diversity, Segregation, and Ethnocentric Trust in Africa
    * Journal: British Journal of Political Science
	* Created by: Amanda Lea Robinson 
* DO FILE INFO
	* This .do file produces all graphs included in the manuscript.
    * Run after the analysis file (Robinson_SegTrust.do).
    * Requires the data file: Robinson_SegTrust.dta

*********************************************************************************************************************

set more off

* Figure 1 *

scatter  elf_country ef if ctag==1, mlabel(country) mlabs(2.5) ///
	scheme(s2mono) graphregion(fcolor(white)) ///
	msize(0) mlabp(0) mcolor(white) ///
	legend(off)   xlabel(,format(%9.1fc))  ylabel(,format(%9.1fc)) ///
    xtitle("Ethnolinguistic Fractionalization, Fearon (2003)", size(3)) ///
    ytitle("Ethnolinguistic Fractionalization, Afrobarometer", size(3))

* Figure 2 *
scatter elf_reg elf_reg_i if rtag==1, mlabel(country) mlabs(2.5) ///
	scheme(s2mono) graphregion(fcolor(white)) ///
	msize(0) mlabp(0) mcolor(white) ///
	legend(off)   xlabel(,format(%9.1fc))  ylabel(,format(%9.1fc)) ///
    xtitle("Ethnolinguistic Fractionalization, Census", size(3)) ///
    ytitle("Ethnolinguistic Fractionalization, Afrobarometer", size(3))

* Figure 3 *
scatter  elf_dis elfdist if dtag==1, mlabel(district) mlabs(2.5) ///
	scheme(s2mono) graphregion(fcolor(white)) ///
	msize(0) mlabp(0) mcolor(white) ///
	legend(off)   xlabel(,format(%9.1fc))  ylabel(,format(%9.1fc)) ///
    xtitle("Ethnolinguistic Fractionalization, Census", size(3)) ///
    ytitle("Ethnolinguistic Fractionalization, Afrobarometer", size(3))

* Figure 4 *
scatter avg_elf_reg elf_country if ctag==1, mlabel(country) mlabs(2.5) mlabposition(1) ///
	scheme(s2mono) graphregion(fcolor(white))  ///
	msize(0)  mcolor(white) ///
	legend(off)  xlabel(0.3(0.1)1.0,format(%9.1fc)) ///
    xtitle("Ethnolinguistic Fractionalization, Country-Level", size(3)) ///
    ytitle("Average Region-Level Ethnolinguistic Fractionalization", size(3))
	

* Figure 5 *

est res si1
qui: margins, dydx(elf_country) at(dseg_dis =(0 (0.1) 1)) vsquish 
marginsplot, level(90) ///
	title("") xtitle("Ethnic Segregation", size(medsmall)) ///
	ytitle ("Marginal Effect of National-Level Ethnic Fractionalization" "on the Coethnic Trust Premium", size(medsmall)) ///
	plot1opts(msymbol(O) mcolor(black) lcolor(black) msize(small))  /// 
	recast(line) ciopts(lcolor(gs9)recast(. rcap)) ///
	ylabel(, nogrid)  xlabel(,format(%9.1fc)) ///
	graphregion(fcolor(white) ilcolor(white) lcolor(white))  ///
		yline(0, lcolor(gs13)) ///
	legend (region(lcolor(white)) )

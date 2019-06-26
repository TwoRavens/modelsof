/*	****************************************************************	*/
/*	File Name: Oil Export and Civil War (Woo_JPR).do							*/
/*	Date:	January 23, 2017								*/
/*	Author: Jungmoo Woo							*/
/*	Purpose: This file replicates the regression results for 		*/
/*	Woo, Jungmoo (forthcoming). 'Oil Export, Prewar Intervention, 	*/
/*	and Onset of Civil War.' Journal of Peace Research.		*/
/*	Input File: Oil Export and Civil War (Woo_JPR).dta						*/
/*	Version: Stata 13 or above.							*/
/*	****************************************************************	*/

/*Table II*/
/*Model 1*/
logit target_gov lnoilexport lnoil_income_pc lnrgdppc lagxpolity lmtnest ethfrac relfrac laglogpop alliances total peaceyear1 peaceyear2 peaceyear3, cluster(ccode) robust nolog
estat gof, group(10)
lroc, nograph

/*Model 2*/
logit target_gov nrmoutdeg lnoil_income_pc lnrgdppc lagxpolity lmtnest ethfrac relfrac laglogpop alliances total peaceyear1 peaceyear2 peaceyear3, cluster(ccode) robust nolog
estat gof, group(10)
lroc, nograph

/*Model 3*/
logit target_gov outcloseness lnoil_income_pc lnrgdppc lagxpolity lmtnest ethfrac relfrac laglogpop alliances total peaceyear1 peaceyear2 peaceyear3, cluster(ccode) robust nolog
estat gof, group(10)
lroc, nograph

/*Model 4*/
logit target_gov closeness_d lnoil_income_pc lnrgdppc lagxpolity lmtnest ethfrac relfrac laglogpop alliances total peaceyear1 peaceyear2 peaceyear3, cluster(ccode) robust nolog
estat gof, group(10)
lroc, nograph

/*Model 5*/
logit target_gov wclose lnoil_income_pc lnrgdppc lagxpolity lmtnest ethfrac relfrac laglogpop alliances total peaceyear1 peaceyear2 peaceyear3, cluster(ccode) robust nolog
estat gof, group(10)
lroc, nograph



/*Figure 1*/
estsimp logit target_gov wclose lnoil_income_pc lnrgdppc lagxpolity lmtnest ethfrac relfrac laglogpop alliances total peaceyear1 peaceyear2 peaceyear3, cluster(ccode) robust nolog
setx (wclose lnoil_income_pc lnrgdppc lagxpolity lmtnest ethfrac relfrac laglogpop alliances total peaceyear1 peaceyear2 peaceyear3) mean
plotfds, cont(wclose lnoil_income_pc lnrgdppc lagxpolity lmtnest ethfrac relfrac laglogpop alliances total) changex(p25 p75) clevel(95) xline(0) scheme(s1mono) title("") msymbol(diamond) mcolor(black) label sort(wclose lnoil_income_pc lnrgdppc lagxpolity lmtnest ethfrac relfrac laglogpop alliances total)



/*Table III*/
/*Model 6*/
logit onset wclose intervention lnoil_income_pc lnrgdppc lagxpolity lmtnest ethfrac relfrac laglogpop alliances total peaceyear1 peaceyear2 peaceyear3, cluster(ccode) robust nolog
estat gof, group(10)
lroc, nograph

/*Model 7*/
logit onset wclose target_gov target_neu target_reb lnoil_income_pc lnrgdppc lagxpolity lmtnest ethfrac relfrac laglogpop alliances total peaceyear1 peaceyear2 peaceyear3, cluster(ccode) robust nolog
estat gof, group(10)
lroc, nograph

/*Model 8*/
logit onset c.wclose##target_gov target_neu target_reb lnoil_income_pc lnrgdppc lagxpolity lmtnest ethfrac relfrac laglogpop alliances total peaceyear1 peaceyear2 peaceyear3, cluster(ccode) robust nolog
estat gof, group(10)
lroc, nograph


/*Figure 2*/
logit onset c.wclose##target_gov target_neu target_reb lnoil_income_pc lnrgdppc lagxpolity lmtnest ethfrac relfrac laglogpop alliances total peaceyear1 peaceyear2 peaceyear3, cluster(ccode) robust nolog
margins target_gov, at(wclose=(0(.5)7))
marginsplot, title("Marginal Effect of Weighted Oil Market Power") ytitle("Pr(Civil War)") xtitle("Weighted Oil Market Power") scheme(s1mono) recast(line) yline(0) l(95)


/*Appendix A*/
/*Model A (Economic Growth)*/
logit target_gov wclose lnoil_income_pc econgrowth lnrgdppc lagxpolity lmtnest ethfrac relfrac laglogpop alliances total peaceyear1 peaceyear2 peaceyear3, cluster(ccode) robust nolog
/*Model B (On_ and Offshore)*/
logit target_gov wclose lnoil_income_pc onoilp offoilp lnrgdppc lagxpolity lmtnest ethfrac relfrac laglogpop alliances total peaceyear1 peaceyear2 peaceyear3, cluster(ccode) robust nolog
/*Model C (Excluding Saudi Arabia)*/
logit target_gov wclose lnoil_income_pc lnrgdppc lagxpolity lmtnest ethfrac relfrac laglogpop alliances total peaceyear1 peaceyear2 peaceyear3 if ccode~=670, cluster(ccode) robust nolog
/*Model D (Excluding Russia)*/
logit target_gov wclose lnoil_income_pc lnrgdppc lagxpolity lmtnest ethfrac relfrac laglogpop alliances total peaceyear1 peaceyear2 peaceyear3 if ccode~=365, cluster(ccode) robust nolog
/*Model E (Reduced Model)*/
logit target_gov wclose lnoil_income_pc peaceyear1 peaceyear2 peaceyear3, cluster(ccode) robust nolog



/*Appendix B*/
/*Model F (Economic Growth)*/
logit onset c.wclose##target_gov target_neu target_reb lnoil_income_pc econgrowth lnrgdppc lagxpolity lmtnest ethfrac relfrac laglogpop alliances total peaceyear1 peaceyear2 peaceyear3, cluster(ccode) robust nolog
/*Model G (On_ and Offshore)*/
logit onset c.wclose##target_gov target_neu target_reb lnoil_income_pc onoilp offoilp lnrgdppc lagxpolity lmtnest ethfrac relfrac laglogpop alliances total peaceyear1 peaceyear2 peaceyear3, cluster(ccode) robust nolog
/*Model H (Territorial Conflict)*/
logit terri_con c.wclose##target_gov target_neu target_reb lnoil_income_pc lnrgdppc lagxpolity lmtnest ethfrac relfrac laglogpop alliances total peaceyear1 peaceyear2 peaceyear3, cluster(ccode) robust nolog
/*Model I (Governmental Conflict)*/
logit gov_con c.wclose##target_gov target_neu target_reb lnoil_income_pc lnrgdppc lagxpolity lmtnest ethfrac relfrac laglogpop alliances total peaceyear1 peaceyear2 peaceyear3, cluster(ccode) robust nolog
/*Model J (Reduced Model)*/
logit onset c.wclose##target_gov target_neu target_reb lnoil_income_pc peaceyear1 peaceyear2 peaceyear3, cluster(ccode) robust nolog

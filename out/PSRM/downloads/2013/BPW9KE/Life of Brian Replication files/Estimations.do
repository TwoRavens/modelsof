/***********************************************************
************************************************************
** Alexander Baturo and Slava Mikhaylov (2013). "Life of Brian Revisited: Assessing Informational and Non-Informational Leadership Tools." Political Science Research and Methods, 2013, 1(1): 139-157.
** Replication files
************************************************************
**  Main estimation
************************************************************
************************************************************/


use Leaders_Leadership, clear


xtset reg2 year

/* Model 1 */

xtreg score_nof c.media c.premium1 i.putin_appoint  i.medvednice  i.year, fe vce(cluster reg2)

est store Model1


/* Model 2 */

xtreg score_nof c.media c.premium1 i.putin_appoint  i.medvednice aftermedved taxspend i.demback i.elected90s i.year, fe vce(cluster reg2)

est store Model2

/* Model 3 */

xtreg score_nof c.media##c.premium1 c.media#putin_appoint c.media#medvednice i.putin_appoint  i.medvednice i.year, fe vce(cluster reg2)

est store Model3

/* Model 4 */
xtreg score_nof c.media##c.premium1 c.media#putin_appoint c.media#medvednice i.putin_appoint  i.medvednice aftermedved taxspend i.demback i.elected90s i.year, fe vce(cluster reg2)

est store Model4

gen pipe = "|"
gen where = -.45

margins, dydx(media) at(premium1=(-31(5)44))

*summarize premium, d

marginsplot, recast(line) recastci(rline) ciopts(lpattern(dash)) addplot((scatter where premium1, xlab(-31 0 7.6 19.52 44) msymbol(none) mlabel(pipe) mlabposition(0)), below)  scheme(s1color) xtitle(Redistribution premium) yline(0, lcolor(red)) title(Average Marginal Effects of Media Publicity with 95% CIs) legend(off)

graph export Figure3.pdf, replace 


estout Model1 Model2 Model3 Model4, cells(b(star fmt(%9.3f)) se(par fmt(%9.3f)))  style(tex) legend label varlabels(_cons Constant) stats(N N_clust r2_o rmse, fmt(0 0 2 3) label(N Nregions OverallR-squared RMSE)) starlevels(+ 0.10 ** 0.05 *** 0.001) modelwidth(4) drop(2009* 2010* 2011*)



/*testing for residual autocorrelation*/
tab reg2, gen(temp)
gen inter1=media*premium1
gen inter2= media*putin_appoint
gen inter3 = media*medvednice
xtserial score_nof media premium1 inter1 putin_appoint inter2 medvednice inter3 aftermedved taxspend demback elected90s year10 year11 temp*, output




/****** Supplementary Materials **********/


* Selection Model *



/*Model 1*/
heckman score_nof media premium1  medvednice  year09 year10, select(medved_appoint=age  demback elected90s el_perform year09 year10)  twostep
estimates store m1

/*Model 2*/
heckman score_nof media premium1  medvednice  year09 year10, select(putin_appoint=age silovik elected90s el_perform year09 year10)  twostep
estimates store m2

estout m1 m2, cells(b(star fmt(%9.3f)) se(par fmt(%9.3f)))  style(tex) legend label varlabels(_cons Constant) stats(N N_cens, fmt(0 0) label(N CensoredObs)) starlevels(+ 0.10 ** 0.05 *** 0.001) modelwidth(4) drop(year09 year10)




/******** Robustness Studies ********/

/* Dropping fixed effects for robustness studies */


/* Model 1 */

reg score_nof c.media c.premium1 i.putin_appoint  i.medvednice, vce(cluster reg2)

est store altModel1


/* Model 2 */

reg score_nof c.media c.premium1 i.putin_appoint  i.medvednice aftermedved taxspend i.demback i.elected90s, vce(cluster reg2)

est store altModel2

/* Model 3 */

reg score_nof c.media##c.premium1 c.media#putin_appoint c.media#medvednice i.putin_appoint  i.medvednice, vce(cluster reg2)

est store altModel3

/* Model 4 */
reg score_nof c.media##c.premium1 c.media#putin_appoint c.media#medvednice i.putin_appoint  i.medvednice aftermedved taxspend i.demback i.elected90s, vce(cluster reg2)

est store altModel4

gen where2 = -.45

margins, dydx(media) at(premium1=(-31(5)44))

marginsplot, recast(line) recastci(rline) ciopts(lpattern(dash)) addplot((scatter where2 premium1, xlab(-31 0 44) msymbol(none) mlabel(pipe) mlabposition(0)), below)  scheme(s1color) xtitle(Redistribution premium) yline(0, lcolor(red)) title(Average Marginal Effects of Media Publicity with 95% CIs) legend(off)

graph export Figure3-alternative.pdf, replace 


estout altModel1 altModel2 altModel3 altModel4, cells(b(star fmt(%9.3f)) se(par fmt(%9.3f)))  style(tex) legend label varlabels(_cons Constant) stats(N N_clust r2_a rmse, fmt(0 0 2 3) label(N Nregions AdjR-squared RMSE)) starlevels(+ 0.10 ** 0.05 *** 0.001) modelwidth(4) 




/****** Optimal lag selection ******/


/*media lag: quarterly variable*/

xtreg score_nof c.media##c.premium1  c.media2 c.media2#c.premium1 c.media#putin_appoint c.media2#putin_appoint c.media#medvednice c.media2#medvednice i.putin_appoint  i.medvednice aftermedved taxspend i.demback i.elected90s i.year, fe vce(cluster reg2)

estat ic

xtreg score_nof c.media##c.premium1 c.media#putin_appoint c.media#medvednice i.putin_appoint  i.medvednice aftermedved taxspend i.demback i.elected90s i.year, fe vce(cluster reg2)

estat ic


/*Redistribution premium: monthly*/

/*6 months*/

xtreg score_nof c.media##c.premium1 c.media#c.premium2 c.premium2 c.media#c.premium3 c.premium3 c.media#c.premium4 c.premium4 c.media#c.premium5 c.premium5 c.media#c.premium6 c.premium6 c.media#putin_appoint c.media#medvednice i.putin_appoint  i.medvednice aftermedved taxspend i.demback i.elected90s i.year, fe vce(cluster reg2)

estat ic

/*5 months*/

xtreg score_nof c.media##c.premium1 c.media#c.premium2 c.premium2 c.media#c.premium3 c.premium3 c.media#c.premium4 c.premium4 c.media#c.premium5 c.premium5 c.media#putin_appoint c.media#medvednice i.putin_appoint  i.medvednice aftermedved taxspend i.demback i.elected90s i.year, fe vce(cluster reg2)

estat ic


/*4 months*/

xtreg score_nof c.media##c.premium1 c.media#c.premium2 c.premium2 c.media#c.premium3 c.premium3 c.media#c.premium4 c.premium4 c.media#putin_appoint c.media#medvednice i.putin_appoint  i.medvednice aftermedved taxspend i.demback i.elected90s i.year, fe vce(cluster reg2)

estat ic

/*3 months*/

xtreg score_nof c.media##c.premium1 c.media#c.premium2 c.premium2 c.media#c.premium3 c.premium3  c.media#putin_appoint c.media#medvednice i.putin_appoint  i.medvednice aftermedved taxspend i.demback i.elected90s i.year, fe vce(cluster reg2)

estat ic

/*2 months*/

xtreg score_nof c.media##c.premium1 c.media#c.premium2 c.premium2 c.media#putin_appoint c.media#medvednice i.putin_appoint  i.medvednice aftermedved taxspend i.demback i.elected90s i.year, fe vce(cluster reg2)

estat ic

/*1 month*/

xtreg score_nof c.media##c.premium1 c.media#putin_appoint c.media#medvednice i.putin_appoint  i.medvednice aftermedved taxspend i.demback i.elected90s i.year, fe vce(cluster reg2)

estat ic

/* Moving average*/

xtreg score_nof c.media##c.premiumMA c.media#putin_appoint c.media#medvednice i.putin_appoint  i.medvednice aftermedved taxspend i.demback i.elected90s i.year, fe vce(cluster reg2)

estat ic

/*2quarter lag on media*/

xtreg score_nof c.media##c.premiumMA  c.media2 c.media2#c.premiumMA c.media#putin_appoint c.media2#putin_appoint c.media#medvednice c.media2#medvednice i.putin_appoint  i.medvednice aftermedved taxspend i.demback i.elected90s i.year, fe vce(cluster reg2)

estat ic





/* Table for alternative specifications with moving average */


/* Model 1 */

xtreg score_nof c.media c.premiumMA i.putin_appoint  i.medvednice  i.year, fe vce(cluster reg2)

est store Model1MA


/* Model 2 */

xtreg score_nof c.media c.premiumMA i.putin_appoint  i.medvednice aftermedved taxspend i.demback i.elected90s i.year, fe vce(cluster reg2)

est store Model2MA

/* Model 3 */

xtreg score_nof c.media##c.premiumMA c.media#putin_appoint c.media#medvednice i.putin_appoint  i.medvednice i.year, fe vce(cluster reg2)

est store Model3MA



/*Model4*/
xtreg score_nof c.media##c.premiumMA c.media#putin_appoint c.media#medvednice i.putin_appoint  i.medvednice aftermedved taxspend i.demback i.elected90s i.year, fe vce(cluster reg2)

est store Model4MA

gen where3 = -.5

margins, dydx(media) at(premiumMA=(-31(5)44))

marginsplot, recast(line) recastci(rline) ciopts(lpattern(dash)) addplot((scatter where3 premiumMA, xlab(-32 0 45) msymbol(none) mlabel(pipe) mlabposition(0)), below)  scheme(s1color) xtitle(Redistribution premium (moving average)) yline(0, lcolor(red)) title(Average Marginal Effects of Media Publicity with 95% CIs) legend(off)

graph export premiumMA.pdf, replace 


estout Model1MA Model2MA Model3MA Model4MA, cells(b(star fmt(%9.3f)) se(par fmt(%9.3f)))  style(tex) legend label varlabels(_cons Constant) stats(N N_clust r2_o rmse, fmt(0 0 2 3) label(N Nregions OverallR-squared RMSE)) starlevels(+ 0.10 ** 0.05 *** 0.001) modelwidth(4) drop(2009* 2010* 2011*)



/* Summary statistics*/

xtreg score_nof c.media##c.premium1 c.media#putin_appoint c.media#medvednice i.putin_appoint  i.medvednice aftermedved taxspend i.demback i.elected90s i.year, fe vce(cluster reg2)

sutex score_nof media premium1 putin_appoint medvednice aftermedved taxspend el_perform demback elected90s age silovik if e(sample), labels minmax






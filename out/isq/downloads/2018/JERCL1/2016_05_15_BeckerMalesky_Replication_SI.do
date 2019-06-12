/*******************************************************
*Jordan Becker and Edmund Malesky
May 16, 2016
STATA Version 14
*******************************************************/

********************************
* Standard Stata Configuration *
********************************
clear all
set mem 999m
capture log close
set logtype text
cap cd "C:\Users\ejm5\Google Drive\2015_Research\ISQ_RnR\Final_Docs\replication"
cap cd "C:\Users\Jordan.Becker\Desktop\GD\2016_Research\ISQ_RnR"
cap cd "\\usnatonetapp01.eur.state.sbu\profiles\beckerjm\Desktop\2016_Research\ISQ_RnR"
set more off

********************
* Analyze the Data *
********************

use "2016_01_06_StratCult", clear

*SUPPLEMENTARY TABLE G: Descriptive Statistics of Variables Used in Main Analyses*
# delimit;
sum  milburden operating personnel equipment infrastructure atlanticism idv uai biehl_orientation2 idealpoint_prox 
ln_full ln_pop1 sandler_strategic ln_threat ln_prox terrorism_humancost years_nato years_nato_sq atlanticism_change nato_strat_change ln_troops
trade_us_gdp right dpi_checks usld;

*SUPPLEMENTARY Table B: Replication of Sandler and Hartley (1999) Using Error Correction Model and Disaggregated Expenditures*
#delimit;
xtset ccode year;
*milburden*
#delimit;
reg d.nato_milburden l.nato_milburden l.ln_full d.ln_full l.ln_spillins  d.ln_spillins
l.sandler_strategic d.sandler_strategic l.ln_threat d.ln_threat, cluster(ccode);
outreg2 using SupTableB_Sandler_ECM, bdec(3) tdec(3) e(rmse) replace;

*operating*
#delimit;
reg d.operating l.operating l.ln_full d.ln_full l.ln_spillins  d.ln_spillins
l.sandler_strategic d.sandler_strategic l.ln_threat d.ln_threat, cluster(ccode);
outreg2 using SupTableB_Sandler_ECM, bdec(3) tdec(3) e(rmse); 

*equipment*
#delimit;
reg d.equipment l.equipment l.ln_full d.ln_full l.ln_spillins  d.ln_spillins
l.sandler_strategic d.sandler_strategic l.ln_threat d.ln_threat, cluster(ccode);
outreg2 using SupTableB_Sandler_ECM, bdec(3) tdec(3) e(rmse);

*personnel*
#delimit;
reg d.personnel l.personnel l.ln_full d.ln_full l.ln_spillins  d.ln_spillins
l.sandler_strategic d.sandler_strategic l.ln_threat d.ln_threat, cluster(ccode);
outreg2 using SupTableB_Sandler_ECM, bdec(3) tdec(3) e(rmse);

*infrastructure*
#delimit;
reg d.infrastructure l.infrastructure l.ln_full d.ln_full l.ln_spillins  d.ln_spillins
l.sandler_strategic d.sandler_strategic l.ln_threat d.ln_threat, cluster(ccode);
outreg2 using SupTableB_Sandler_ECM, bdec(3) tdec(3) e(rmse) excel;

*Supplementary Figure C: Atlanticism and Expenditures for France, UK, and Germany over Time*

*Bivariate Scatter for Big 3 Year Labels*
  #delimit;
use "2016_01_06_StratCult", clear;
twoway (lfit operating europeanism  if year>1999  & samp_big3==1) 
		(scatter operating europeanism  if year>1999  & countryname=="United Kingdom", msymbol(circle) mcolor(navy) msize(medsmall) mlabsize(vsmall) 
		mlabcolor(black) mlabel(year))
		(scatter operating europeanism  if year>1999  & countryname=="France", msymbol(square) mcolor(maroon) msize(medsmall) mlabsize(vsmall) 
		mlabcolor(black) mlabel(year))
		(scatter operating europeanism  if year>1999  & countryname=="Germany", msymbol(diamond) mcolor(green) msize(medsmall) mlabsize(vsmall) 
		mlabcolor(black) mlabel(year)),
xtitle("")
ytitle("Share of GDP Spent on Operations (%)", size(medium) margin(medsmall))
legend(off);
graph save Big3_Bivariate_ops.gph, replace;

twoway (lfit personnel europeanism  if year>1999  & samp_big3==1) 
		(scatter personnel  europeanism  if year>1999  & countryname=="United Kingdom", msymbol(circle) mcolor(navy) msize(medsmall) mlabsize(vsmall) 
		mlabcolor(black) mlabel(year))
		(scatter personnel  europeanism  if year>1999  & countryname=="France", msymbol(square) mcolor(maroon) msize(medsmall) mlabsize(vsmall) 
		mlabcolor(black) mlabel(year))
		(scatter personnel  europeanism  if year>1999  & countryname=="Germany", msymbol(diamond) mcolor(green) msize(medsmall) mlabsize(vsmall) 
		mlabcolor(black) mlabel(year)),
xtitle("")
ytitle("Share of GDP Spent on Personnel (%)", size(medium) margin(medsmall))
legend(rows(4) size(small) position(5) ring(0) label(1 Fitted) label(2 "United Kingdom") label(3 "France") label(4 "Germany"));
graph save Big3_Bivariate_pers.gph, replace;

#delimit;
graph combine Big3_Bivariate_ops.gph  Big3_Bivariate_pers.gph, xcommon ycommon imargin(tiny) 
title("Word Score: Atlanticist=100; Europeanist=0",  margin(medsmall) position(6) size(medium) color(black));

*Summarize Big 3*
#delimit;
use "2016_01_06_StratCult", clear;
# delimit;
sum  milburden operating personnel equipment infrastructure atlanticism biehl_orientation2 idealpoint_prox 
ln_full ln_pop1 sandler_strategic ln_threat ln_prox terrorism_humancost years_nato years_nato_sq atlanticism_change nato_strat_change ln_troops
trade_us_gdp right dpi_checks usld if countryname=="United Kingdom" & year>1999 & atlanticism!=.;
 
sum  milburden operating personnel equipment infrastructure atlanticism biehl_orientation2 idealpoint_prox 
ln_full ln_pop1 sandler_strategic ln_threat ln_prox terrorism_humancost years_nato years_nato_sq atlanticism_change nato_strat_change ln_troops
trade_us_gdp right dpi_checks usld  if countryname=="France" & year>1999 & atlanticism!=.;

sum  milburden operating personnel equipment infrastructure atlanticism biehl_orientation2 idealpoint_prox 
ln_full ln_pop1 sandler_strategic ln_threat ln_prox terrorism_humancost years_nato years_nato_sq atlanticism_change nato_strat_change ln_troops
trade_us_gdp right dpi_checks usld  if countryname=="Germany" & year>1999 & atlanticism!=.;
 
tabstat milburden operating personnel equipment infrastructure atlanticism biehl_orientation2 idealpoint_prox 
ln_full ln_pop1 sandler_strategic ln_threat ln_prox terrorism_humancost years_nato years_nato_sq atlanticism_change nato_strat_change ln_troops
trade_us_gdp right dpi_checks usld if countryname=="United Kingdom" & year>1999 & atlanticism!=., by(countryname) stat (semean);
 
tabstat milburden operating personnel equipment infrastructure atlanticism biehl_orientation2 idealpoint_prox 
ln_full ln_pop1 sandler_strategic ln_threat ln_prox terrorism_humancost years_nato years_nato_sq atlanticism_change nato_strat_change ln_troops
trade_us_gdp right dpi_checks usld if countryname=="France" & year>1999  & atlanticism!=., by (countryname) stat (semean);
 
tabstat milburden operating personnel equipment infrastructure atlanticism biehl_orientation2 idealpoint_prox 
ln_full ln_pop1 sandler_strategic ln_threat ln_prox terrorism_humancost years_nato years_nato_sq atlanticism_change nato_strat_change ln_troops
trade_us_gdp right dpi_checks usld if countryname=="Germany" & year>1999 &atlanticism!=., by(countryname) stat (semean);


*SUPPLEMENTARY Figure D1: Scatterplot of Atlanticism and Ideal Point Proximity (Bailey et al. 2013)*
#delimit;
twoway (lfit idealpoint_prox atlanticism) 
(scatter idealpoint_prox atlanticism, msymbol(diamond) mcolor(navy) msize(medsmall) mlabsize(vsmall) mlabcolor(black)),
xtitle("Word Score: Europeanist=0; Atlanticist=100 (Mean 1999-2013)", size(medsmall) margin(medsmall))
ytitle("Ideal Point Proximity", size(medium) margin(medsmall))
legend(rows(2) size(vsmall) position(2) ring(0) label(1 Fitted) label(2 Observed));
graph save app_atlanticism_idealpoint.gph, replace;


*SUPPLEMENTARY Figure D2: Scatterplot of Atlanticism and Hofstede Measures of National Culture in 2010*

#delimit;
twoway (lfit pdi atlanticism) 
(scatter pdi atlanticism, msymbol(diamond) mcolor(navy) msize(medsmall) mlabsize(vsmall) mlabcolor(black) mlabel(countryname)),
xtitle("Atlanticism", size(medsmall) margin(medsmall))
ytitle("Hofstede Power Distance", size(medium) margin(medsmall))
legend(rows(2) size(vsmall) position(5) ring(0) label(1 Fitted) label(2 Observed))
title("Atlanticism and Hofstede's Power Distance");
graph save SUP_FIG_D2_atlanticism_pdi.gph, replace;


#delimit;
twoway (lfit idv atlanticism) 
(scatter idv atlanticism, msymbol(diamond) mcolor(navy) msize(medsmall) mlabsize(vsmall) mlabcolor(black) mlabel(countryname)),
xtitle("Atlanticism", size(medsmall) margin(medsmall))
ytitle("Hofstede Individualism", size(medium) margin(medsmall))
legend(rows(2) size(vsmall) position(5) ring(0) label(1 Fitted) label(2 Observed))
title("Atlanticism and Hofstede's Individualism");
graph save SUP_FIG_D2_atlanticism_idv.gph, replace;

#delimit;
twoway (lfit uai atlanticism) 
(scatter uai atlanticism, msymbol(diamond) mcolor(navy) msize(medsmall) mlabsize(vsmall) mlabcolor(black) mlabel(countryname)),
xtitle("Atlanticism", size(medsmall) margin(medsmall))
ytitle("Hofstede Uncertainty Avoidance", size(medium) margin(medsmall))
legend(rows(2) size(vsmall) position(5) ring(0) label(1 Fitted) label(2 Observed))
title("Atlanticism and Hofstede's Uncertainty Avoidance");
graph save SUP_FIG_D2_atlanticism_uai.gph, replace;


*SUPPLEMENTARY Table I: Robustness of Table 2 to Dropping of France, then UK, then both*
#delimit;
use "2016_01_06_StratCult", clear;

sort countryname year;
merge 1:1 countryname year using "belUK.dta";
drop if ccode==.;
xtset ccode year;
by ccode, sort: replace bel_uk = l.bel_uk if  bel_uk==. & l.bel_uk!=.;


/*Bel_UK*/
sum bel_uk;
generate bel_uk_rescale=100*((bel_uk-r(min))/(r(max)-r(min)));
sum bel_uk_rescale, detail;
replace bel_uk =bel_uk_rescale ;
drop bel_uk ;
 


xtset ccode year;
///****WITHOUT FRANCE****///
/*milburden*/

#delimit ;
set more off;
reg d.milburden l.milburden d.atlanticism l.atlanticism d.ln_full l.ln_full d.ln_pop l.ln_pop ln_prox d.ln_threat l.ln_threat d.terrorism_human l.terrorism_human 
l.sandler_strategic   d.right l.right d.dpi_checks l.dpi_checks i.year if countryname !="France", robust cluster (ccode);
outreg2 using SupTableD_Correlates_NoFranceNoUK, bdec(3) tdec(3) e(rmse) replace;

/*operating*/
#delimit ;
reg d.operating l.operating d.atlanticism l.atlanticism d.ln_full l.ln_full d.ln_pop l.ln_pop ln_prox d.ln_threat l.ln_threat d.terrorism_human l.terrorism_human 
l.sandler_strategic   d.right l.right d.dpi_checks l.dpi_checks i.year if countryname !="France", robust cluster (ccode);
outreg2 using SupTableD_Correlates_NoFranceNoUK, bdec(3) tdec(3) e(rmse) ;

#delimit ;
reg d.personnel l.personnel d.atlanticism l.atlanticism d.ln_full l.ln_full d.ln_pop l.ln_pop ln_prox d.ln_threat l.ln_threat d.terrorism_human l.terrorism_human 
l.sandler_strategic   d.right l.right d.dpi_checks l.dpi_checks i.year if countryname !="France", robust cluster (ccode);
outreg2 using SupTableD_Correlates_NoFranceNoUK, bdec(3) tdec(3) e(rmse) ;

///****WITHOUT UK****///
/*milburden*/
#delimit ;
reg d.milburden l.milburden d.atlanticism l.atlanticism d.ln_full l.ln_full d.ln_pop l.ln_pop ln_prox d.ln_threat l.ln_threat d.terrorism_human l.terrorism_human 
l.sandler_strategic   d.right l.right d.dpi_checks l.dpi_checks i.year if countryname !="United Kingdom", robust cluster (ccode);
outreg2 using SupTableD_Correlates_NoFranceNoUK, bdec(3) tdec(3) e(rmse) ;

/*operating*/
#delimit ;
reg d.operating l.operating d.atlanticism l.atlanticism d.ln_full l.ln_full d.ln_pop l.ln_pop ln_prox d.ln_threat l.ln_threat d.terrorism_human l.terrorism_human 
l.sandler_strategic   d.right l.right d.dpi_checks l.dpi_checks i.year if countryname !="United Kingdom", robust cluster (ccode);
outreg2 using SupTableD_Correlates_NoFranceNoUK, bdec(3) tdec(3) e(rmse) ;

#delimit ;
reg d.personnel l.personnel d.atlanticism l.atlanticism d.ln_full l.ln_full d.ln_pop l.ln_pop ln_prox d.ln_threat l.ln_threat d.terrorism_human l.terrorism_human 
l.sandler_strategic   d.right l.right d.dpi_checks l.dpi_checks i.year if countryname !="United Kingdom", robust cluster (ccode);
outreg2 using SupTableD_Correlates_NoFranceNoUK, bdec(3) tdec(3) e(rmse) ;

///****WITHOUT FRANCE OR UK****///
/*milburden*/
#delimit ;
reg d.milburden l.milburden d.atlanticism l.atlanticism d.ln_full l.ln_full d.ln_pop l.ln_pop ln_prox d.ln_threat l.ln_threat d.terrorism_human l.terrorism_human 
l.sandler_strategic   d.right l.right d.dpi_checks l.dpi_checks i.year if countryname !="United Kingdom"|countryname!="France", robust cluster (ccode);
outreg2 using SupTableD_Correlates_NoFranceNoUK, bdec(3) tdec(3) e(rmse) ;

/*operating*/
#delimit ;
reg d.operating l.operating d.atlanticism l.atlanticism d.ln_full l.ln_full d.ln_pop l.ln_pop ln_prox d.ln_threat l.ln_threat d.terrorism_human l.terrorism_human 
l.sandler_strategic   d.right l.right d.dpi_checks l.dpi_checks i.year if countryname !="United Kingdom" |countryname!="France", robust cluster (ccode);
outreg2 using SupTableD_Correlates_NoFranceNoUK, bdec(3) tdec(3) e(rmse) excel;

#delimit ;
reg d.personnel l.personnel d.atlanticism l.atlanticism d.ln_full l.ln_full d.ln_pop l.ln_pop ln_prox d.ln_threat l.ln_threat d.terrorism_human l.terrorism_human 
l.sandler_strategic   d.right l.right d.dpi_checks l.dpi_checks i.year if countryname !="United Kingdom" |countryname!="France", robust cluster (ccode);
outreg2 using SupTableD_Correlates_NoFranceNoUK, bdec(3) tdec(3) e(rmse);




///****DIFFERENT ANCHORS****///

*BELGIUM and UK*
/*milburden*/
#delimit ;
set more off;
reg d.milburden l.milburden d.bel_uk l.bel_uk d.ln_full l.ln_full d.ln_pop l.ln_pop ln_prox d.ln_threat l.ln_threat d.terrorism_human l.terrorism_human 
l.sandler_strategic   d.right l.right d.dpi_checks l.dpi_checks i.year , robust cluster (ccode);
outreg2 using SupTableD_Correlates_NoFranceNoUK, bdec(3) tdec(3) e(rmse) ;

/*operating*/
#delimit ;
reg d.operating l.operating d.bel_uk l.bel_uk d.ln_full l.ln_full d.ln_pop l.ln_pop ln_prox d.ln_threat l.ln_threat d.terrorism_human l.terrorism_human 
l.sandler_strategic   d.right l.right d.dpi_checks l.dpi_checks i.year, robust cluster (ccode);
outreg2 using SupTableD_Correlates_NoFranceNoUK, bdec(3) tdec(3) e(rmse) ;

/*personnel*/
#delimit ;
reg d.personnel l.personnel d.bel_uk l.bel_uk d.ln_full l.ln_full d.ln_pop l.ln_pop ln_prox d.ln_threat l.ln_threat d.terrorism_human l.terrorism_human 
l.sandler_strategic   d.right l.right d.dpi_checks l.dpi_checks i.year, robust cluster (ccode);
outreg2 using SupTableD_Correlates_NoFranceNoUK, bdec(3) tdec(3) e(rmse) excel ;

/*Additional Anales using Suggestions of Reviewers*/
*france94_uk98*
/*milburden*/
#delimit ;
set more off;
reg d.milburden l.milburden d.france94_uk98 l.france94_uk98 d.ln_full l.ln_full d.ln_pop l.ln_pop ln_prox d.ln_threat l.ln_threat d.terrorism_human l.terrorism_human 
l.sandler_strategic   d.right l.right d.dpi_checks l.dpi_checks i.year , robust cluster (ccode);
outreg2 using SupTableD_Correlates_france94_uk98, bdec(3) tdec(3) e(rmse) replace;

/*operating*/
#delimit ;
reg d.operating l.operating d.france94_uk98 l.france94_uk98 d.ln_full l.ln_full d.ln_pop l.ln_pop ln_prox d.ln_threat l.ln_threat d.terrorism_human l.terrorism_human 
l.sandler_strategic   d.right l.right d.dpi_checks l.dpi_checks i.year, robust cluster (ccode);
outreg2 using SupTableD_Correlates_france94_uk98, bdec(3) tdec(3) e(rmse) ;

/*personnel*/
#delimit ;
reg d.personnel l.personnel d.france94_uk98 l.france94_uk98 d.ln_full l.ln_full d.ln_pop l.ln_pop ln_prox d.ln_threat l.ln_threat d.terrorism_human l.terrorism_human 
l.sandler_strategic   d.right l.right d.dpi_checks l.dpi_checks i.year, robust cluster (ccode);
outreg2 using SupTableD_Correlates_france94_uk98, bdec(3) tdec(3) e(rmse) excel ;

*Greece and Turkey*
/*milburden*/
#delimit ;
set more off;
reg d.milburden l.milburden d.greece97_turkey00 l.greece97_turkey00 d.ln_full l.ln_full d.ln_pop l.ln_pop ln_prox d.ln_threat l.ln_threat d.terrorism_human l.terrorism_human 
l.sandler_strategic   d.right l.right d.dpi_checks l.dpi_checks i.year , robust cluster (ccode);
outreg2 using SupTableD_Correlates_greece97_turkey00, bdec(3) tdec(3) e(rmse) replace;

/*operating*/
#delimit ;
reg d.operating l.operating d.greece97_turkey00 l.greece97_turkey00 d.ln_full l.ln_full d.ln_pop l.ln_pop ln_prox d.ln_threat l.ln_threat d.terrorism_human l.terrorism_human 
l.sandler_strategic   d.right l.right d.dpi_checks l.dpi_checks i.year, robust cluster (ccode);
outreg2 using SupTableD_Correlates_greece97_turkey00, bdec(3) tdec(3) e(rmse) ;

/*personnel*/
#delimit ;
reg d.personnel l.personnel d.greece97_turkey00 l.greece97_turkey00 d.ln_full l.ln_full d.ln_pop l.ln_pop ln_prox d.ln_threat l.ln_threat d.terrorism_human l.terrorism_human 
l.sandler_strategic   d.right l.right d.dpi_checks l.dpi_checks i.year, robust cluster (ccode);
outreg2 using SupTableD_Correlates_greece97_turkey00, bdec(3) tdec(3) e(rmse) excel ;


*SUPPLEMENTARY Table H: Robustness to Additional Controls*
/*Conscription*/
#delimit ;
reg d.operating l.operating l.atlanticism d.atlanticism l.ln_full d.ln_full l.ln_pop  d.ln_pop l.ln_threat d.ln_threat 
l.terrorism_human d.terrorism_human l.sandler_strategic  ln_prox l.right d.right l.dpi_checks d.dpi_checks d.avf_shock l.avf_shock
, cluster(ccode);
outreg2 using SupTableH1_Robust, bdec(3) tdec(3) e(rmse) replace;

#delimit ;
set more off;
reg d.operating l.operating l.atlanticism d.atlanticism  l.ln_full d.ln_full l.ln_pop  d.ln_pop l.ln_threat d.ln_threat l.terrorism_human d.terrorism_human 
l.sandler_strategic  ln_prox l.right d.right l.dpi_checks d.dpi_checks l.ln_troops d.ln_troops i.year , cluster(ccode);
outreg2 using SupTableH1_Robust, bdec(3) tdec(3) e(rmse);

#delimit ;
reg d.operating l.operating l.atlanticism d.atlanticism  l.ln_full d.ln_full l.ln_pop  d.ln_pop l.ln_threat d.ln_threat l.terrorism_human d.terrorism_human 
l.sandler_strategic  ln_prox l.right d.right l.dpi_checks d.dpi_checks l.trade_us_gdp d.trade_us_gdp  i.year , cluster(ccode);
outreg2 using SupTableH1_Robust, bdec(3) tdec(3) e(rmse);

#delimit ;
reg d.operating l.operating l.atlanticism d.atlanticism  l.ln_full d.ln_full l.ln_pop  d.ln_pop l.ln_threat d.ln_threat l.terrorism_human d.terrorism_human 
l.sandler_strategic  ln_prox l.right d.right l.dpi_checks d.dpi_checks  l.nato_strat_change d.nato_strat_change  i.year , cluster(ccode);
outreg2 using SupTableH1_Robust, bdec(3) tdec(3) e(rmse) ;

#delimit ;
reg d.operating l.operating l.atlanticism d.atlanticism  l.ln_full d.ln_full l.ln_pop  d.ln_pop l.terrorism_human d.terrorism_human 
l.sandler_strategic  l.right d.right l.dpi_checks d.dpi_checks  l.nato_strat_change d.nato_strat_change eu_dummy_year i.year , cluster(ccode);
outreg2 using SupTableH1_Robust, bdec(3) tdec(3) e(rmse) ;

#delimit ;
reg d.operating l.operating l.atlanticism d.atlanticism  l.ln_full d.ln_full l.ln_pop  d.ln_pop l.terrorism_human d.terrorism_human 
l.sandler_strategic  l.right d.right l.dpi_checks d.dpi_checks  l.nato_strat_change d.nato_strat_change samp_warsaw i.year , cluster(ccode);
outreg2 using SupTableH1_Robust, bdec(3) tdec(3) e(rmse) ;


#delimit ;
reg d.personnel l.personnel l.atlanticism d.atlanticism l.ln_full d.ln_full l.ln_pop  d.ln_pop l.ln_threat d.ln_threat 
l.terrorism_human d.terrorism_human l.sandler_strategic  ln_prox l.right d.right l.dpi_checks d.dpi_checks d.avf_shock l.avf_shock
, cluster(ccode);
outreg2 using SupTableH1_Robust, bdec(3) tdec(3) e(rmse) ;


#delimit ;
reg d.personnel l.personnel l.atlanticism d.atlanticism  l.ln_full d.ln_full l.ln_pop  d.ln_pop l.ln_threat d.ln_threat l.terrorism_human d.terrorism_human 
l.sandler_strategic  ln_prox l.right d.right l.dpi_checks d.dpi_checks l.ln_troops d.ln_troops i.year , cluster(ccode);
outreg2 using SupTableH1_Robust, bdec(3) tdec(3) e(rmse) ;

#delimit ;
reg d.personnel l.personnel l.atlanticism d.atlanticism  l.ln_full d.ln_full l.ln_pop  d.ln_pop l.ln_threat d.ln_threat l.terrorism_human d.terrorism_human 
l.sandler_strategic  ln_prox l.right d.right l.dpi_checks d.dpi_checks l.trade_us_gdp d.trade_us_gdp  i.year , cluster(ccode);
outreg2 using SupTableH1_Robust, bdec(3) tdec(3) e(rmse);

#delimit ;
reg d.personnel l.personnel l.atlanticism d.atlanticism  l.ln_full d.ln_full l.ln_pop  d.ln_pop l.ln_threat d.ln_threat l.terrorism_human d.terrorism_human 
l.sandler_strategic  ln_prox l.right d.right l.dpi_checks d.dpi_checks  l.nato_strat_change d.nato_strat_change  i.year , cluster(ccode);
outreg2 using SupTableH1_Robust, bdec(3) tdec(3) e(rmse);

#delimit ;
reg d.personnel l.personnel l.atlanticism d.atlanticism  l.ln_full d.ln_full l.ln_pop  d.ln_pop l.terrorism_human d.terrorism_human 
l.sandler_strategic  l.right d.right l.dpi_checks d.dpi_checks  l.nato_strat_change d.nato_strat_change eu_dummy_year i.year , cluster(ccode);
outreg2 using SupTableH1_Robust, bdec(3) tdec(3) e(rmse) ;

#delimit ;
reg d.personnel l.personnel l.atlanticism d.atlanticism  l.ln_full d.ln_full l.ln_pop  d.ln_pop l.terrorism_human d.terrorism_human 
l.sandler_strategic  l.right d.right l.dpi_checks d.dpi_checks  l.nato_strat_change d.nato_strat_change samp_warsaw i.year , cluster(ccode);
outreg2 using SupTableH1_Robust, bdec(3) tdec(3) e(rmse) excel ;


*SUPPLEMENTARY Table F: Robustness of Table 2 to Standardization by GDP*
#delimit;
use "2016_01_06_StratCult", clear;
xtset ccode year;

/*milburden*/

/*Baseline*/
#delimit;
reg d.milburden l.milburden l.atlanticism  d.atlanticism , cluster(ccode); 
outreg2 using SUPTableF_RobustGDP, bdec(3) tdec(3) e(rmse) replace;

/*Public Good*/

reg d.milburden l.milburden d.atlanticism l.atlanticism d.ln_full l.ln_full d.ln_pop l.ln_pop, cluster(ccode);
outreg2 using SUPTableF_RobustGDP, bdec(3) tdec(3) e(rmse) excel;


/*Threat*/
#delimit ;
reg d.milburden l.milburden d.atlanticism l.atlanticism d.ln_full l.ln_full d.ln_pop l.ln_pop ln_prox d.ln_threat l.ln_threat d.terrorism_human l.terrorism_human 
l.sandler_strategic  , cluster(ccode);
outreg2 using SUPTableF_RobustGDP, bdec(3) tdec(3) e(rmse);


#delimit ;
reg d.milburden l.milburden d.atlanticism l.atlanticism d.ln_full l.ln_full d.ln_pop l.ln_pop ln_prox d.ln_threat l.ln_threat d.terrorism_human l.terrorism_human 
l.sandler_strategic   d.right l.right d.dpi_checks l.dpi_checks , cluster(ccode);
outreg2 using SUPTableF_RobustGDP, bdec(3) tdec(3) e(rmse);

#delimit ;
reg d.milburden l.milburden d.atlanticism l.atlanticism d.ln_full l.ln_full d.ln_pop l.ln_pop ln_prox d.ln_threat l.ln_threat d.terrorism_human l.terrorism_human 
l.sandler_strategic   d.right l.right d.dpi_checks l.dpi_checks i.year;
outreg2 using SUPTableF_RobustGDP, bdec(3) tdec(3) e(rmse) ;

/**********************************************************************************************/

/*operating_gdp*/
/*Baseline*/
#delimit;
reg d.operating_gdp l.operating_gdp l.atlanticism  d.atlanticism , cluster(ccode) ;
outreg2 using SUPTableF_RobustGDP, bdec(3) tdec(3) e(rmse);

/*Public Good*/

reg d.operating_gdp l.operating_gdp d.atlanticism l.atlanticism d.ln_full l.ln_full d.ln_pop l.ln_pop, cluster(ccode);
outreg2 using SUPTableF_RobustGDP, bdec(3) tdec(3) e(rmse);

/*Threat*/
#delimit ;
reg d.operating_gdp l.operating_gdp d.atlanticism l.atlanticism d.ln_full l.ln_full d.ln_pop l.ln_pop ln_prox d.ln_threat l.ln_threat d.terrorism_human l.terrorism_human 
l.sandler_strategic  , cluster(ccode);
outreg2 using SUPTableF_RobustGDP, bdec(3) tdec(3) e(rmse);


/*Domestic Politics*/
#delimit ;
reg d.operating_gdp l.operating_gdp d.atlanticism l.atlanticism d.ln_full l.ln_full d.ln_pop l.ln_pop ln_prox d.ln_threat l.ln_threat d.terrorism_human l.terrorism_human 
l.sandler_strategic   d.right l.right d.dpi_checks l.dpi_checks , cluster(ccode);
outreg2 using SUPTableF_RobustGDP, bdec(3) tdec(3) e(rmse);


/*Year FE*/
#delimit ;
reg d.operating_gdp l.operating_gdp d.atlanticism l.atlanticism d.ln_full l.ln_full d.ln_pop l.ln_pop ln_prox d.ln_threat l.ln_threat d.terrorism_human l.terrorism_human 
l.sandler_strategic   d.right l.right d.dpi_checks l.dpi_checks i.year , cluster(ccode);
outreg2 using SUPTableF_RobustGDP, bdec(3) tdec(3) e(rmse);

*Full Spec Personnel*
#delimit ;
reg d.personnel l.personnel d.atlanticism l.atlanticism d.ln_full l.ln_full d.ln_pop l.ln_pop ln_prox d.ln_threat l.ln_threat d.terrorism_human l.terrorism_human 
l.sandler_strategic   d.right l.right d.dpi_checks l.dpi_checks i.year , cluster(ccode);
outreg2 using SUPTableF_RobustGDP, bdec(3) tdec(3) e(rmse);

*Full Spec Equipment*
#delimit ;
reg d.equipment l.equipment d.atlanticism l.atlanticism d.ln_full l.ln_full d.ln_pop l.ln_pop ln_prox d.ln_threat l.ln_threat d.terrorism_human l.terrorism_human 
l.sandler_strategic   d.right l.right d.dpi_checks l.dpi_checks i.year , cluster(ccode);
outreg2 using SUPTableF_RobustGDP, bdec(3) tdec(3) e(rmse);

*Full Spec Infrastructure*
#delimit ;
reg d.infrastructure l.infrastructure d.atlanticism l.atlanticism d.ln_full l.ln_full d.ln_pop l.ln_pop ln_prox d.ln_threat l.ln_threat d.terrorism_human l.terrorism_human 
l.sandler_strategic   d.right l.right d.dpi_checks l.dpi_checks i.year , cluster(ccode);
outreg2 using SUPTableF_RobustGDP, bdec(3) tdec(3) e(rmse) excel;

*SUPPLEMENTARY Table D: Replication using Biehl et al. Measure of Atlanticism*
#delimit;

generate biehl_orientation3=4-biehl_orientation2;

#delimit;
xtpcse milburden l.biehl_orientation3, correlation(psar1);
outreg2 using SupTableD_BiehlRobust, bdec(3) tdec(3) e(rmse) replace;
xtpcse milburden l.biehl_orientation3 l.ln_full l.ln_pop l.ln_threat 
l.terrorism_human l.sandler_strategic  ln_prox l.right  l.dpi_checks i.year,  correlation(psar1);
outreg2 using SupTableD_BiehlRobust, bdec(3) tdec(3) e(rmse);

xtpcse operating l.biehl_orientation3, pairwise correlation(psar1);
outreg2 using SupTableD_BiehlRobust, bdec(3) tdec(3) e(rmse);
xtpcse operating l.biehl_orientation3 l.ln_full l.ln_pop l.ln_threat 
l.terrorism_human l.sandler_strategic  ln_prox l.right  l.dpi_checks i.year,  correlation(psar1);
outreg2 using SupTableD_BiehlRobust, bdec(3) tdec(3) e(rmse);

xtpcse personnel l.biehl_orientation3, pairwise correlation(psar1);
outreg2 using SupTableD_BiehlRobust, bdec(3) tdec(3) e(rmse);
xtpcse personnel l.biehl_orientation3 l.ln_full l.ln_pop l.ln_threat 
l.terrorism_human l.sandler_strategic  ln_prox l.right  l.dpi_checks i.year,  correlation(psar1);
outreg2 using SupTableD_BiehlRobust, bdec(3) tdec(3) e(rmse) excel;


*SUPPLEMENTARY FIGURE J: CIBAR Personnel*
#delimit;
clear;
use "2016_01_06_StratCult", clear;
sum atlanticism, detail;
sum atlanticism if year==2007, detail;
gen atlanticist_dummy=1 if atlanticism>24.18;
replace atlanticist_dummy=0 if atlanticism<=24.18;
by ccode, sort: gen personnel_growth_07_15=((personnel-l7.personnel)/l7.personnel)*100;
#delimit;
label var atlanticist_dummy "Greater than mean Atlanticism=1";
label value atlanticist_dummy atlanticist_dummy;
label define atlanticist_dummy 0 "Europeanist Allies" 1 "Atlanticist Allies";
cibar personnel_growth_07_15, over1(atlanticist_dummy) graphopts(ytitle("Mean Growth in Personnel Expenditures (%), 2007-2012", size(small)) 
legend(label(1 "Atlanticist Allies") label(2 "Europeanist Allies")));
graph save SupFigureJ_cibarpersonnel, replace;

*SUPPLEMENTARY FIGURE G1/G2: TSLINE ATLANTICISM OPERATING PERSONNEL*
#delimit;
tsline operating personnel if year>=1999, by(countryname) legend(rows(1) label(1 Operating/Budget) label(2 Personnel/Budget) size(vsmall)) note("") xtitle("") ylab(0(20)80, labsize(vsmall));
graph save SupFigureKa_tslineoperatingpersonnel, replace;

#delimit;
tsline atlanticism if year>=1999 & atlanticism !=., by(countryname) ytitle("Atlanticism", size(medium)) xtitle("") ylab(0(20)100, labsize(vsmall));
graph save SupFigureKb_tslineoperatingpersonnel, replace;


*SUPPLEMENTARY TABLE J: Test of models using standard panel estimation, analysis with a lag dependent variable, and with panel corrected errors*
#delimit ;
set more off;
xtreg operating l.operating  i.year, cluster(ccode);
outreg2 using xtrobust, bdec(3) tdec(3) e(all) replace;

#delimit ;
xtreg operating l.operating  atlanticism  l.ln_full  l.ln_pop ln_prox l.ln_threat l.terrorism_human l.sandler_strategic l.right l.dpi_checks i.year, cluster(ccode);
outreg2 using xtrobust, bdec(3) tdec(3) e(all) ;

#delimit ;
xtpcse operating l.operating  atlanticism  l.ln_full  l.ln_pop ln_prox l.ln_threat l.terrorism_human l.sandler_strategic l.right l.dpi_checks i.year , correlation(psar1);
outreg2 using xtrobust, bdec(3) tdec(3) e(all);


#delimit ;
xtreg personnel l.personnel  i.year, cluster(ccode);
outreg2 using xtrobust, bdec(3) tdec(3) e(all);

#delimit ;
xtreg personnel l.personnel  atlanticism  l.ln_full  l.ln_pop ln_prox l.ln_threat l.terrorism_human l.sandler_strategic l.right l.dpi_checks i.year, cluster(ccode);
outreg2 using xtrobust, bdec(3) tdec(3) e(all);

#delimit ;
xtpcse personnel l.personnel atlanticism  l.ln_full  l.ln_pop ln_prox l.ln_threat l.terrorism_human l.sandler_strategic l.right l.dpi_checks i.year , correlation(psar1);
outreg2 using xtrobust, bdec(3) tdec(3) e(all) excel;

*SUPPLEMENTARY TABLE E: PWOORR FOR OTHER INDICATORS OF OPERATIONAL BURDEN SHARING*
#delimit;
pwcorr operating eda_deployed_gdp isaf_troops_capita deployed_personnel l2.equipment, star(5);


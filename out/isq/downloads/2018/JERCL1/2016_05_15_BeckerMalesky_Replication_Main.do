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
log using ISQ.smcl, replace
set more off


use "2015_07_10_GrandLarge", clear
set more off
sort ccode year

*Merge New Word Scores*
merge 1:1 ccode year using "2015_12_29_wordscores"
drop _merge
merge 1:1 ccode year using "2016_01_17_wordscores_us_eu"
drop _merge

*Merge Force Ratios*
merge 1:1 ccode year using "BlagdenMenonCOWccode"
drop _merge

*Merge EDA Data*
merge 1:1 ccode year using "eda"
drop _merge

*merge QOG data*
 merge 1:1 ccode year using "freetrade"
drop _merge

*Merge Welfare Generosity data*
merge 1:1 ccode year using "welfare_generosity"
drop _merge
saveold "2016_01_06_StratCult", replace

*Fill missing Word Score Values*
#delimit;
tsset ccode year;
replace france03_uk02 = L.france03_uk02 if france03_uk02==.;
replace france03_uk03 = L.france03_uk03 if france03_uk03==.;
replace france94_uk98 = L.france94_uk98 if france94_uk98==.;
replace greece97_turkey00 = L.greece97_turkey00 if greece97_turkey00==.;
replace austria01_uk02 = L.austria01_uk02 if austria01_uk02==.;
replace uk02_france03 = L.uk02_france03 if uk02_france03==.;
replace germany11_us10 = L.germany11_us10 if germany11_us10==.;
replace eu_03_us02 = L.eu_03_us02 if eu_03_us02==.;
replace france02_us02 = L.france02_us02 if france02_us02==.;
saveold "2016_01_06_StratCult", replace;
#delimit cr

*Rescale Atlanticism*
sum atlanticism
generate atlanticism_rescale=100*((atlanticism-r(min))/(r(max)-r(min)))
sum atlanticism_rescale, detail
reg d.operating l.operating d.atlanticism l.atlanticism d.ln_full l.ln_full d.ln_pop l.ln_pop, cluster(ccode)
reg d.operating l.operating d.atlanticism_rescale l.atlanticism_rescale d.ln_full l.ln_full d.ln_pop l.ln_pop, cluster(ccode)
replace atlanticism=atlanticism_rescale
drop atlanticism_rescale
 

keep if samp_nato_europe==1 & year>=1999 & operating!=. 
saveold "2016_01_06_StratCult", replace
xtset ccode year
# delimit;
order milburden operating personnel equipment infrastructure atlanticism idv uai biehl_orientation2 idealpoint_prox ln_full ln_pop1 
sandler_strategic ln_threat  terrorism_humancost years_nato years_nato_sq atlanticism_change nato_strat_change ln_troops 
trade_us_gdp right dpi_checks usld isaf_troops group, after (ccode);


*FIGURE 1: DOT PLOT DEPICTION OF WORD SCORES METHODOLOGY*
#delimit;
use "AvE.dta", clear;
rename var1 word;
rename var2 score;
sort word;
replace word = "counter-terrorism" in 18;
replace word = "*_capable" in 90;
replace word = "*_operations" in 91;
replace word = "berlin_plus" in 89;
replace word = "professionalisation" in 67;
replace word = "operations_*" in 60;
replace word = "nato_*" in 56;
set seed 1974;
sample 80;
replace score=100-score;
#delimit;
graph dot (asis) score, over(word, sort(score) label(labsize(tiny))) ylabel(0(5)100, 
labels labsize(vsmall)) dots(mcolor(black) msize(vsmall) msymbol(point)) 
marker(1, mcolor(gs4) msize(vsmall) msymbol(diamond)) dots(mcolor(gs12) msize(vsmall) msymbol(point)) ylabel(, labels) ytitle("") scheme(s1mono);
graph save Figure1_WordScores.gph, replace;
graph export Figure1_WordScores.pdf, as(pdf) replace;

*TABLE 1: PAIRWISE BIVARIATE CORRELATIONS*
# delimit;
use "2016_01_06_StratCult", clear;
pwcorr  milburden operating personnel equipment infrastructure atlanticism idv uai biehl_orientation2 idealpoint_prox 
ln_full ln_pop1 sandler_strategic ln_threat ln_prox terrorism_humancost years_nato years_nato_sq atlanticism_change nato_strat_change ln_troops
trade_us_gdp right dpi_checks usld, star(5);

*FIGURE 2: TIME SERIES TRANSATLANTIC BURDEN SHARING*
#delimit;
use "2015_04_02_historical_burden_all", clear;
xtset usamilex year;
sort year;
sum usamilex;
xtset usaoperating year;
sum usaoperating;
generate us_mean=r(mean);
xtset europemilex year;
sort year;
sum europemilex;
xtset europeoperating year;
sum europeoperating;
generate euro_mean=r(mean);
twoway(tsline usamilex, lwidth(thick) lcolor(black))
	  (tsline usaoperating, lwidth(thick) lcolor(gs8))
	  (tsline usagdp, lwidth(thin) lcolor(black) lpattern(dash))
	  (tsline us_mean , lpattern(shortdash) lcolor(black) lwidth(medium))
	  (tsline europemilex, lwidth(thick) lcolor(gs12))
	  (tsline europeoperating, lwidth(thick) lcolor(gs14))
	  (tsline europegdp, lwidth(thick) lcolor(gs12) lpattern(dash))
	  (tsline euro_mean , lpattern(shortdash) lcolor(gs12) lwidth(medium)), 
	  xtitle("") xlab(1971(2)2012, labsize(tiny) angle(45)) ylab(0(5)85, 
	  labsize(small)) ytitle("Share of NATO Total (%)", size(medsmall) margin(medium))
	  legend(rows(2) size(tiny) label(1 US MILEX)  label (2 US Operating) label(3 US GDP) label(4 US Mean MILEX Share) label(5 Europe MILEX) label(6 Europe Operating) label(7 Europe GDP)
	  label(8 Europe Mean MILEX Share) ring(0) position(7)) scheme(s1mono);
graph save Figure2_NATO_CostShare.gph, replace;
graph export Figure2_NATO_CostShare.pdf, as(pdf) replace;
#delimit cr
pause
#delimit cr

*FIGURE 3 MILEX/GDP BAR GRAPH BY CATEGORIES*
#delimit;
use "2016_01_06_StratCult", clear;
#delimit;
preserve;
keep if year==2012;
graph bar (mean) operating_gdp (mean) personnel_gdp (mean) equipment_gdp (mean) infrastructure_gdp if samp_allnato==1, over(countryname, label(labcolor(black) 
angle(forty_five) labsize(vsmall))) stack yline(2, lcolor(black) lpattern(dash) lwidth(medthick)) 
ytitle("Expenditures/GDP (%), by Mil. Category (2012)", size(medsmall) margin(medium)) legend(rows(1) position(6)  size(vsmall) 
label (1 "O&M") label (2 "Personnel") label (3 "Equipment")  label (4 "Infrastructure")) ysize (10) ylab(0(.5)3, labsize(vsmall)) scheme(s1mono);
graph save Figure3disagg_all.gph, replace;
graph export Figure3disagg.pdf, as(pdf) replace;
restore;

*FIGURE 4: BIVARIATE CORRELATION BETWEEN O&M AND ISAF CONTRIBUTIONS/CAPITA*
#delimit;
pwcorr operating isaf_troops_capita isaf_troops_gdp, star(1);

reg operating isaf_troops_capita;

reg operating isaf_troops_gdp;

xi:xtpcse operating isaf_troops_capita , pairwise rhotype(dw);
outreg2 using Figure4_isaf, bdec(3) tdec(3) e(rmse) replace;


#delimit;
preserve;
collapse milburden operating personnel equipment infrastructure europeanism atlanticism biehl_orientation2 idealpoint_prox 
ln_full ln_pop1 sandler_strategic ln_threat  terrorism_humancost nato_dummy years_nato years_nato_sq ln_troops
trade_us_gdp right dpi_checks isaf_troops_capita isaf_troops_gdp, by(countryname);

twoway (lfit isaf_troops_capita operating) 
(scatter isaf_troops_capita operating, msymbol(diamond) mcolor(gs6) msize(vsmall) mlabsize(vsmall) mlabcolor(black) mlabel(countryname) mlabposition(9)),
xtitle("Operating Expenditures (%Milex)", size(medsmall) margin(medsmall))
ytitle("ISAF Troop Contribution (per thousand citizens)", size(medium) margin(medsmall))
legend(rows(2) size(vsmall) position(10) ring(0) label(1 Fitted) label(2 Observed))
note(r=0.54*, position(5) ring(0)) scheme(s1mono);
graph save Figure4_operating_isaf.gph, replace;
graph export Figure4_operating_isaf.pdf, as(pdf) replace;
restore;
#delimit cr


/*Cointegration Test*/
#delimit;
tsset ccode year;
xtwest operating atlanticism, lags(1);

/*Stationarity Test*/
#delimit;
xtunitroot fisher atlanticism, dfuller lags(1) demean;

*TABLE 2: ECM CORRELATES*
#delimit;
use "2016_01_06_StratCult", clear;
xtset ccode year;

/*milburden*/

/*Baseline*/
#delimit;
reg d.milburden l.milburden l.atlanticism  d.atlanticism , cluster(ccode); 
outreg2 using Table2_Correlates, bdec(3) tdec(3) e(rmse) replace;

/*Public Good*/

reg d.milburden l.milburden d.atlanticism l.atlanticism d.ln_full l.ln_full d.ln_pop l.ln_pop, cluster(ccode);
outreg2 using Table2_Correlates, bdec(3) tdec(3) e(rmse) excel;


/*Threat*/
#delimit ;
reg d.milburden l.milburden d.atlanticism l.atlanticism d.ln_full l.ln_full d.ln_pop l.ln_pop ln_prox d.ln_threat l.ln_threat d.terrorism_human l.terrorism_human 
l.sandler_strategic  , cluster(ccode);
outreg2 using Table2_Correlates, bdec(3) tdec(3) e(rmse);


#delimit ;
reg d.milburden l.milburden d.atlanticism l.atlanticism d.ln_full l.ln_full d.ln_pop l.ln_pop ln_prox d.ln_threat l.ln_threat d.terrorism_human l.terrorism_human 
l.sandler_strategic   d.right l.right d.dpi_checks l.dpi_checks , cluster(ccode);
outreg2 using Table2_Correlates, bdec(3) tdec(3) e(rmse);

#delimit ;
reg d.milburden l.milburden d.atlanticism l.atlanticism d.ln_full l.ln_full d.ln_pop l.ln_pop ln_prox d.ln_threat l.ln_threat d.terrorism_human l.terrorism_human 
l.sandler_strategic   d.right l.right d.dpi_checks l.dpi_checks i.year;
outreg2 using Table2_Correlates, bdec(3) tdec(3) e(rmse) ;

/**********************************************************************************************/

/*operating*/
/*Baseline*/
#delimit;
reg d.operating l.operating l.atlanticism  d.atlanticism , cluster(ccode) ;
outreg2 using Table2_Correlates, bdec(3) tdec(3) e(rmse);

/*Public Good*/

reg d.operating l.operating d.atlanticism l.atlanticism d.ln_full l.ln_full d.ln_pop l.ln_pop, cluster(ccode);
outreg2 using Table2_Correlates, bdec(3) tdec(3) e(rmse);

/*Threat*/
#delimit ;
reg d.operating l.operating d.atlanticism l.atlanticism d.ln_full l.ln_full d.ln_pop l.ln_pop ln_prox d.ln_threat l.ln_threat d.terrorism_human l.terrorism_human 
l.sandler_strategic  , cluster(ccode);
outreg2 using Table2_Correlates, bdec(3) tdec(3) e(rmse);


/*Domestic Politics*/
#delimit ;
reg d.operating l.operating d.atlanticism l.atlanticism d.ln_full l.ln_full d.ln_pop l.ln_pop ln_prox d.ln_threat l.ln_threat d.terrorism_human l.terrorism_human 
l.sandler_strategic   d.right l.right d.dpi_checks l.dpi_checks , cluster(ccode);
outreg2 using Table2_Correlates, bdec(3) tdec(3) e(rmse);


/*Year FE*/
#delimit ;
reg d.operating l.operating d.atlanticism l.atlanticism d.ln_full l.ln_full d.ln_pop l.ln_pop ln_prox d.ln_threat l.ln_threat d.terrorism_human l.terrorism_human 
l.sandler_strategic   d.right l.right d.dpi_checks l.dpi_checks i.year , cluster(ccode);
outreg2 using Table2_Correlates, bdec(3) tdec(3) e(rmse);


*Full Spec Personnel*
#delimit ;
reg d.personnel l.personnel d.atlanticism l.atlanticism d.ln_full l.ln_full d.ln_pop l.ln_pop ln_prox d.ln_threat l.ln_threat d.terrorism_human l.terrorism_human 
l.sandler_strategic   d.right l.right d.dpi_checks l.dpi_checks i.year , cluster(ccode);
outreg2 using Table2_Correlates, bdec(3) tdec(3) e(rmse);

*Full Spec Equipment*
#delimit ;
reg d.equipment l.equipment d.atlanticism l.atlanticism d.ln_full l.ln_full d.ln_pop l.ln_pop ln_prox d.ln_threat l.ln_threat d.terrorism_human l.terrorism_human 
l.sandler_strategic   d.right l.right d.dpi_checks l.dpi_checks i.year , cluster(ccode);
outreg2 using Table2_Correlates, bdec(3) tdec(3) e(rmse);

*Full Spec Infrastructure*
#delimit ;
reg d.infrastructure l.infrastructure d.atlanticism l.atlanticism d.ln_full l.ln_full d.ln_pop l.ln_pop ln_prox d.ln_threat l.ln_threat d.terrorism_human l.terrorism_human 
l.sandler_strategic   d.right l.right d.dpi_checks l.dpi_checks i.year , cluster(ccode);
outreg2 using Table2_Correlates, bdec(3) tdec(3) e(rmse) excel;




/**************************************************************************************************/


*FIGURE 5: BIVARIATE CORRELATION BETWEEN ATLANTICISM AND OPERATING EXPENDITURES*
#delimit;
use "2016_01_06_StratCult", clear;
preserve;

#delimit cr
split countryname, generate(abbrev) parse(a b c d e f g h i j k l m n o p q r s t u v w x y z) limit(20) notrim
drop abbrev2 abbrev2 abbrev3 abbrev4 abbrev5 abbrev7 abbrev8 abbrev9 abbrev11
tab abbrev1
tab country
replace abbrev1="UK" if abbrev1=="U"
replace abbrev1="Be" if country=="Belgium"
replace abbrev1="Bu" if country=="Bulgaria"
replace abbrev1="Cz" if country=="Czech Republic"
replace abbrev1="Cr" if country=="Croatia"
replace abbrev1="Ge" if country=="Germany"
replace abbrev1="Gr" if country=="Greece"
replace abbrev1="La" if country=="Latvia"
replace abbrev1="La" if country=="Latvia"
replace abbrev1="Li" if country=="Lithuania"
replace abbrev1="Lu" if country=="Luxembourg"
replace abbrev1="Pl" if country=="Poland"
replace abbrev1="Pr" if country=="Portugal"
replace abbrev1="Sla" if country=="Slovakia"
replace abbrev1="Sle" if country=="Slovenia"



#delimit;
twoway (lfit operating atlanticism) 
(scatter operating atlanticism, mlab(abbrev1) mlabsize(vsmall) mlabcolor(black) msymbol(diamond) mlabposition(9) mcolor(gs6) msize(medsmall)),
xtitle("", size(medsmall) margin(medsmall))
ytitle("", size(medium) margin(medsmall))
legend(rows(2) size(vsmall) position(2) ring(0) label(1 Fitted) label(2 Observed))
title("A: All Country-Years", size(medlarge)) scheme(s1mono);
graph save Figure5A_FullSample.gph, replace;

*2011*
#delimit;
twoway (lfit operating atlanticism  if year==2011) 
(scatter operating atlanticism  if year==2011, msymbol(diamond) mcolor(gs6) msize(medsmall) mlabsize(vsmall) mlabposition(9) mlabcolor(black) mlabel(countryname)),
xtitle("", size(medsmall) margin(medsmall))
ytitle("", size(medium) margin(medsmall))
legend(off)
title("B: 2011 Cross-Section", size(medlarge)) scheme(s1mono);
graph save Figure5B_2011.gph, replace;



*Mean*
#delimit;
collapse operating atlanticism usld, by (countryname);

#delimit;
twoway (lfit operating atlanticism) 
(scatter operating atlanticism, msymbol(diamond) mcolor(gs6) mlabposition(9) msize(medsmall) mlabsize(vsmall) mlabcolor(black) mlabel(countryname)),
xtitle("", size(medsmall) margin(medsmall))
ytitle("", size(medium) margin(medsmall))
legend(off)
title("C: Mean 1999-2012", size(medlarge)) scheme(s1mono);

graph save Figure5C_Mean.gph, replace;

#delimit;
graph combine Figure5A_FullSample.gph Figure5B_2011.gph Figure5C_Mean.gph, 
cols(3) ycommon iscale(tiny) imargin(tiny)
title("Word Score: Europeanist=0; Atlanticist=100", size(medlarge) margin(medsmall) color(black) position(6))
subtitle("Share of GDP Spent on Operations (%)", size(medarge) position(9) orientation(vertical) margin(medsmall) color(black)) scheme(s1mono);
graph save Figure5_Bivariate_Atlanticism_Operating, replace;
graph export Figure5_Bivariate_Atlanticism_Operating.pdf, as(pdf) replace;
restore;





*FIGURE 6: LONG-RUN EFFECTS OF CHANGES IN FOREIGN POLICY*
#delimit ;
sort ccode year;
reg d.operating l.operating l.atlanticism d.atlanticism  d.ln_full l.ln_full d.ln_pop l.ln_pop ln_prox d.ln_threat l.ln_threat d.terrorism_human l.terrorism_human 
l.sandler_strategic   d.right l.right d.dpi_checks l.dpi_checks i.year , cluster(ccode);


generate time=2014-year;
replace time=. if time>14;
generate sr=_b[d.atlanticism];
generate lrm=-(_b[l.atlanticism]+_b[d.atlanticism])/(_b[l.operating]-1);

#delimit;
generate TotEff=sr+lrm;

#delimit;
gen total_effects_pos= 12.5*(TotEff*[1-(1+_b[l.operating])^(time-1)]);
replace total_effects_pos=0 if year==0;

gen
 total_effects_neg= -12.5*(TotEff*[1-(1+_b[l.operating])^(time-1)]);
replace total_effects_neg=0 if year==0;

#delimit ;
reg d.personnel l.personnel l.atlanticism d.atlanticism  d.ln_full l.ln_full d.ln_pop l.ln_pop ln_prox d.ln_threat l.ln_threat d.terrorism_human l.terrorism_human 
l.sandler_strategic   d.right l.right d.dpi_checks l.dpi_checks i.year , cluster(ccode);

generate sr2=_b[d.atlanticism];
generate lrm2=-(_b[l.atlanticism]+_b[d.atlanticism])/(_b[l.personnel]-1);

#delimit;
generate TotEff2=sr2+lrm2;

#delimit;
gen total_effects_neg2= 12.5*(TotEff*[1-(1+_b[l.personnel])^(time-1)]);
replace total_effects_neg2=0 if year==0;

gen total_effects_pos2= -12.5*(TotEff*[1-(1+_b[l.personnel])^(time-1)]);
replace total_effects_pos2=0 if year==0;



#delimit;
twoway(lowess total_effects_pos time, lpattern(solid) lwidth(thick)) 
(lowess total_effects_neg time, lpattern(dash) lwidth(thick)), 
ytitle("Total Effect on Expenditures (%GDP)", margin(medium)) xtitle("Years Since Orientation Change", margin(medium))  
xlab(0(2)14) legend (size(vsmall) rows(2) position(11) ring(0) label(1 "Convergence toward Atlanticism") label(2 "Divergence from Atlanticism")) 
title("Operations") scheme(s1mono);

graph save pred_operations.gph, replace;

#delimit;
twoway(lowess total_effects_pos2 time, lpattern(solid) lwidth(thick)) 
(lowess total_effects_neg2 time, lpattern(dash) lwidth(thick)), 
ytitle("Total Effect on Expenditures (%GDP)", margin(medium)) xtitle("Years Since Orientation Change", margin(medium))  
xlab(0(2)14) legend (size(vsmall) rows(2) position(11) ring(0) label(1 "Convergence toward Atlanticism") label(2 "Divergence from Atlanticism")) 
title("Personnel") legend(off) scheme(s1mono);

graph save pred_personnel.gph, replace;

graph combine pred_operations.gph pred_personnel.gph, xcommon ycommon scheme(s1mono);
graph save Figure6.gph, replace;
graph export Figure6.pdf, as(pdf) replace;


*****************************************************************************************
*** This do file creates the database for  												*/
*** Integrating Equality
***  -Globalization, Women’s Rights, and Human Trafficking                              */
*** Cho, Seo-Young, 2013. International Studies Quarterly 57, pp. 683-697   		    */								
*****************************************************************************************
tsset id yid          

** correlation matrix **
corr trade  log_fdistock informationflows personalcontact culturalproximity

** Granger causality, wecon and wosoc **
xtreg trade L.trade L.wecon i.year, fe cluster (id)
test L.wecon
xtreg  log_fdistock L.log_fdistock L.wecon i.year, fe cluster (id)
test L.wecon
xtreg informationflows L.informationflows L.wecon i.year, fe cluster (id)  
test L.wecon
xtreg personalcontact L.personalcontact L.wecon i.year, fe cluster (id)  
test L.wecon
xtreg culturalproximity L.culturalproximity L.wecon i.year, fe cluster (id)
test L.wecon

xtreg trade L.trade L.wosoc i.year, fe cluster (id)
test L.wosoc
xtreg  log_fdistock L.log_fdistock L.wosoc i.year, fe cluster (id)
test L.wosoc
xtreg informationflows L.informationflows L.wosoc i.year, fe cluster (id)
test L.wosoc
xtreg personalcontact L.personalcontact L.wosoc i.year, fe cluster (id)     
test L.wosoc
xtreg culturalproximity L.culturalproximity L.wosoc i.year, fe cluster (id)
test L.wosoc

xtreg trade L.trade L.wopol i.year, fe cluster (id)
test L.wopol
xtreg  log_fdistock L.log_fdistock L.wopol i.year, fe cluster (id)
test L.wopol
xtreg informationflows L.informationflows L.wopol i.year, fe cluster (id)
test L.wopol
xtreg personalcontact L.personalcontact L.wopol i.year, fe cluster (id)     
test L.wopol
xtreg culturalproximity L.culturalproximity L.wopol i.year, fe cluster (id)
test L.wopol

* from globalization to women's rights *
oprobit wecon L.trade L.wecon i.year, cl(id)
test L.trade
oprobit wecon L.log_fdistock  L.wecon i.year, cl(id)  
test L.log_fdistock 
oprobit wecon L.informationflows L.wecon i.year, cl(id)
test L.informationflows
oprobit wecon L.personalcontact L.wecon i.year, cl(id)
test L.personalcontact
oprobit wecon L.culturalproximity L.wecon i.year, cl(id)
test L.culturalproximity

oprobit wosoc L.trade L.wosoc i.year, cl(id) 
test L.trade
oprobit wosoc L.log_fdistock  L.wosoc i.year, cl(id)  
test L.log_fdistock
oprobit wosoc L.informationflows L.wosoc i.year, cl(id)
test L.informationflows
oprobit wosoc L.personalcontact L.wosoc i.year, cl(id)
test L.personalcontact
oprobit wosoc L.culturalproximity L.wosoc i.year, cl(id)
test L.culturalproximity

oprobit wopol L.trade L.wopol i.year, cl(id) 
test L.trade
oprobit wopol L.log_fdistock  L.wosoc i.year, cl(id)  
test L.log_fdistock
oprobit wopol L.informationflows L.wopol i.year, cl(id)
test L.informationflows
oprobit wopol L.personalcontact L.wopol i.year, cl(id)
test L.personalcontact
oprobit wopol L.culturalproximity L.wopol i.year, cl(id)
test L.culturalproximity


* Women's Rights, orderd probit *
oprobit  wecon  trade  log_fdistock L.wecon democracy_polity2 log_income muslim oecd e_asia_pacific europecasia l_america_caribbean mena n_america sasia ss_africa i.year, cl(id)
oprobit  wecon  trade  log_fdistock L5.informationflows L.wecon democracy_polity2 log_income muslim oecd e_asia_pacific europecasia l_america_caribbean mena n_america sasia ss_africa i.year, cl(id)
oprobit  wecon  trade  log_fdistock L5.personalcontact L.wecon democracy_polity2 log_income muslim oecd e_asia_pacific europecasia l_america_caribbean mena n_america sasia ss_africa i.year, cl(id)
oprobit  wecon  trade  log_fdistock L5.culturalproximity L.wecon democracy_polity2 log_income muslim oecd e_asia_pacific europecasia l_america_caribbean mena n_america sasia ss_africa i.year, cl(id)

oprobit  wosoc  trade  fdistock L.wosoc democracy_polity2 log_income muslim oecd e_asia_pacific europecasia l_america_caribbean mena n_america sasia ss_africa i.year, cl(id)
oprobit  wosoc  trade  fdistock informationflows L.wosoc democracy_polity2 log_income muslim oecd e_asia_pacific europecasia l_america_caribbean mena n_america sasia ss_africa i.year, cl(id)
oprobit  wosoc  trade  fdistock personalcontact L.wosoc democracy_polity2  log_income muslim oecd e_asia_pacific europecasia l_america_caribbean mena n_america sasia ss_africa i.year, cl(id)
oprobit  wosoc  trade  fdistock culturalproximity L.wosoc democracy_polity2  log_income muslim oecd e_asia_pacific europecasia l_america_caribbean mena n_america sasia ss_africa i.year, cl(id)

oprobit  wopol  trade  log_fdistock L.wopol democracy_polity2 log_income muslim oecd e_asia_pacific europecasia l_america_caribbean mena n_america sasia ss_africa i.year, cl(id)
oprobit  wopol  trade  log_fdistock informationflows L.wopol democracy_polity2 log_income muslim oecd e_asia_pacific europecasia l_america_caribbean mena n_america sasia ss_africa i.year, cl(id)
oprobit  wopol  trade  log_fdistock personalcontact L.wopol democracy_polity2 log_income muslim oecd e_asia_pacific europecasia l_america_caribbean mena n_america sasia ss_africa i.year, cl(id)
oprobit  wopol  trade  log_fdistock culturalproximity L.wopol democracy_polity2 log_income muslim oecd e_asia_pacific europecasia l_america_caribbean mena n_america sasia ss_africa i.year, cl(id)
oprobit  wopol  trade  log_fdistock informationflows  personalcontact culturalproximity civil_liberty L.wopol democracy_polity2 log_income muslim oecd e_asia_pacific europecasia l_america_caribbean mena n_america sasia ss_africa i.year, cl(id)


** Women's rights, 2SLS and Oprobit IV ****
xi: ivreg2  wecon trade  fdi_gdp L.wecon democracy_polity2 log_income i.id i.yid (informationflows = inlinethusa restrictions_trade_capital), ffirst
outreg2 using "aiv", excel

xtreg informationflows trade inlinethusa restrictions_trade_capital log_fdigdp L.wecon democracy_polity2 log_income i.year, fe cl(id)
predict p1
bootstrap, reps(100): oprobit wecon p1 trade  fdi_gdp wecon2 democracy_polity2 log_income i.year, r

xi: ivreg2  wecon trade  fdi_gdp L.wecon democracy_polity2 log_income i.id i.yid (personalcontact = McDonald restrictions_trade_capital inlinethg7), ffirst
outreg2 using "aiv", excel

xtreg personalcontact McDonald restrictions_trade_capital inlinethg7 trade  fdi_gdp L.wecon democracy_polity2 log_income i.year , fe cl(id)
predict p2
bootstrap, reps(100): oprobit wecon p2 trade  fdi_gdp wecon2 democracy_polity2 log_income i.year, r

xi: ivreg2  wosoc trade log_fdigdp L.wosoc democracy_polity2 log_income i.id i.yid (personalcontact = McDonald restrictions_trade_capital inlinethg7), ffirst
outreg2 using "aiv", excel

xtreg personalcontact McDonald restrictions_trade_capital inlinethg7 trade  fdi_gdp L.wecon democracy_polity2 log_income i.year , fe cl(id)
predict p3
bootstrap, reps(100): oprobit wosoc p3 trade  fdi_gdp wosoc2 democracy_polity2 log_income i.year, r

*** Human Trafficking ***
drop if year > 1995
collapse  wecon - log_income_2, by (wdi)
oprobit human_trafficking  trade  fdi_gdp informationflows wosoc corruption log_pop log_income oecd  catholic e_asia_pacific europecasia l_america_caribbean mena n_america sasia ss_africa, cl(wdi)
outreg2 using "da", excel
oprobit human_trafficking  trade  fdi_gdp personalcontact wosoc corruption log_pop log_income catholic oecd  e_asia_pacific europecasia l_america_caribbean mena n_america sasia ss_africa, cl(wdi)
outreg2 using "da", excel
oprobit human_trafficking  trade  fdi_gdp culturalproximity wosoc corruption log_pop log_income catholic oecd e_asia_pacific europecasia l_america_caribbean mena n_america sasia ss_africa, cl(wdi)
outreg2 using "da", excel
clear
use "P:\Snoopy Sister\My Papers\Women_GLO\STATA data\Women and GLO09102010.dta", clear
tsset id yid
probit HT_destination trade  fdi_gdp informationflows wosoc corruption log_pop log_income catholic oecd  e_asia_pacific europecasia l_america_caribbean mena n_america sasia ss_africa i.year, cl(id)
outreg2 using "da", excel
probit HT_destination trade  fdi_gdp personalcontact wosoc corruption log_pop log_income catholic oecd  e_asia_pacific europecasia l_america_caribbean mena n_america sasia ss_africa i.year, cl(id)
outreg2 using "da", excel
probit HT_destination trade  fdi_gdp culturalproximity wosoc corruption log_pop log_income catholic oecd e_asia_pacific europecasia l_america_caribbean mena n_america sasia ss_africa i.year, cl(id)
outreg2 using "da", excel
xtprobit HT_destination trade  fdi_gdp informationflows wosoc corruption log_pop log_income catholic oecd  e_asia_pacific europecasia l_america_caribbean mena n_america sasia ss_africa i.year, re
outreg2 using "da", excel
xtprobit HT_destination trade  fdi_gdp personalcontact wosoc corruption log_pop log_income catholic  i.year  oecd e_asia_pacific europecasia l_america_caribbean mena n_america sasia ss_africa, re
outreg2 using "da", excel
xtprobit HT_destination trade  fdi_gdp culturalproximity wosoc corruption log_pop log_income catholic oecd e_asia_pacific europecasia l_america_caribbean mena n_america sasia ss_africa i.year, re
outreg2 using "da", excel

** robustness check: controlling migration seperately **
oprobit human_trafficking  trade  fdi_gdp informationflows migration wosoc corruption log_pop log_income catholic oecd  e_asia_pacific europecasia l_america_caribbean mena n_america sasia ss_africa, cl(wdi)
oprobit human_trafficking  trade  fdi_gdp personalcontact migration wosoc corruption log_pop log_income catholic oecd  e_asia_pacific europecasia l_america_caribbean mena n_america sasia ss_africa, cl(wdi)
oprobit human_trafficking  trade  fdi_gdp culturalproximity migration wosoc corruption log_pop log_income catholic oecd  e_asia_pacific europecasia l_america_caribbean mena n_america sasia ss_africa, cl(wdi)

* Marginal Effects, Women's Economic and Social Rights *
oprobit  wecon  trade  fdi_gdp personalcontact L.wecon democracy_polity2 log_income muslim oecd e_asia_pacific europecasia l_america_caribbean mena n_america sasia ss_africa i.year, cl(id)
meoprobit, nodiscrete stats(p) exp
oprobit  wosoc  trade  fdi_gdp informationflows L.wosoc democracy_polity2 log_income muslim oecd e_asia_pacific europecasia l_america_caribbean mena n_america sasia ss_africa i.year, cl(id)
meoprobit, nodiscrete stats(p) exp
clear

** Marginal effect, human trafficking **
oprobit human_trafficking  trade  fdi_gdp personalcontact migration wosoc corruption log_pop log_income catholic oecd  e_asia_pacific europecasia l_america_caribbean mena n_america sasia ss_africa, cl(wdi)
meoprobit, nodiscrete stats(p) exp
oprobit human_trafficking  trade  fdi_gdp informationflows migration wosoc corruption log_pop log_income catholic oecd  e_asia_pacific europecasia l_america_caribbean mena n_america sasia ss_africa, cl(wdi)
meoprobit, nodiscrete stats(p) exp
oprobit human_trafficking  trade  fdi_gdp culturalproximity migration wosoc corruption log_pop log_income catholic oecd  e_asia_pacific europecasia l_america_caribbean mena n_america sasia ss_africa, cl(wdi)
meoprobit, nodiscrete stats(p) exp


** transmission mechanism: Globalization and Civl Liberty ***
oprobit civil_liberty econGLO socialGLO democracy_polity2 log_income muslim oecd e_asia_pacific europecasia l_america_caribbean mena n_america sasia ss_africa, cl(wdi)
oprobit civil_liberty econGLO socialGLO log_income muslim oecd e_asia_pacific europecasia l_america_caribbean mena n_america sasia ss_africa, cl(wdi)

*** Descriptive Statistics

oprobit  wecon  trade  fdi_gdp L.wecon democracy_polity2 log_income muslim oecd e_asia_pacific europecasia l_america_caribbean mena n_america sasia ss_africa i.year, cl(id)

fsum 	 ///
		 if e(sample), l /* to view on screen */

log close		


** figure ***
graph pie totalnumberofcountries, over(indexranking)  ///
plabel(_all percent, color(black) size(medlarge) format(%5.0g)) title(Figure 1. UNODC Index on Human Trafficking Inflows, size(large) color(black) span) ///
subtitle((Distribution of Ranking by Countries, 1996-2003, 161 countries)) caption(, span) note(score 0: no flows; score 1: very low; score 2: low; score 3: medium; score 4: high; score 5: very high flows, color(black) span)

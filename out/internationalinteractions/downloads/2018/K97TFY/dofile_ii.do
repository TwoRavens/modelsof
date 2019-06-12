

**Eric Keels**
**International Interactions**

**Table I**
**Model 1 & Figure I**
streg elect_implem, robust cluster(ccodecow) dist(weibull) nohr
stcurve, survival at(elect_implem=0) at(elect_implem=1) at(elect_implem=2) at(elect_implem=3)
outreg2 using myreg.doc, replace ctitle(Model 1) auto(2) label

**Figure II: Logit with Temporal Splines**
logit failure elect_implem _spline1 _spline2 _spline3, robust cluster(ccodecow)
margins, at(elect_implem=(0 1 2 3))
marginsplot,  recast(line) ciopts(recast(rline) lpattern(dash))


**Model 2**
streg elect_implem first_elect DDR_av powtran_implem lngdppc CumInt recurring elect_time lnaid wardur incomp_govt p_polity2 pkopres ethnic, robust cluster(ccodecow) dist(weibull) nohr
outreg2 using myreg.doc, append ctitle(Model 2) auto(2) label

**Model 3**
streg elect_implem reform_election4 first_elect DDR_av powtran_implem lngdppc CumInt wardur recurring elect_time lnaid incomp_govt p_polity2 pkopres ethnic, robust cluster(ccodecow) dist(weibull) nohr
outreg2 using myreg.doc, append ctitle(Model 3) auto(2) label

**Marginal Effects for electoral reform**
display exp(-1.686)-1
display exp(-1.686*2)-1
display exp(-1.686*3)-1
display exp(-6.09)-1

**Online Appendix Models**

**Appendix B: Selection Issues**
probit failure pkopres CumInt gle_gdp ethnic p_polity2 rebelmaj t1 t2 t3, robust cluster(ccodecow)
outreg2 using myrec.doc, replace ctitle(Model 1) label

**Selection Model**
biprobit (failure elect_implem gle_gdp wardur CumInt pkopre ethnic p_polity2 t1 t2 t3) (ElectoralReform pkopres CumInt gle_gdp ethnic p_polity2 rebelmaj t1 t2 t3), robust cluster(ccodecow)
outreg2 using myrec.doc, replace ctitle(Model 1) label

**Appendix C: Inclusion of Electoral Reform Provision without implementing**
streg Intarmy DDR gle_gdp CumInt wardur incomp_govt p_polity2 pkopres Shagov first_elect ElectoralReform ethnic, robust cluster(ccodecow) dist(weibull) nohr
outreg2 using myrec.doc, replace ctitle(Model 1) label

**Robustness Check: DDR_Index**
streg DDR_av powtran_implem lngdppc CumInt wardur incomp_govt p_polity2 pkopres first_elect elect_implem elect_time recurring reform_election4 ethnic aid, robust cluster(ccodecow) dist(weibull) nohr
outreg2 using myrec.doc, replace ctitle(Model 1) label

**Robustness Check: Electoral Reform that is NOT Implemented**
streg DDR_index powtran_implem CumInt lngdppc wardur ethnic pastdemoc p_polity2 elect_zero elect_implem reform_election4, robust cluster(ccodecow) dist(weibull) nohr
outreg2 using myreg.doc, replace ctitle(Model 1) label

**Robustness Check: Different Types of Electoral Reform**
streg DDR_index powtran_implem lngdppc CumInt wardur p_polity2 pkopres vote ethnic, robust cluster(ccodecow) dist(weibull) nohr
outreg2 using myrec.doc, replace ctitle(Model 1) label
streg DDR_index powtran_implem lngdppc CumInt wardur p_polity2 pkopres party ethnic, robust cluster(ccodecow) dist(weibull) nohr
outreg2 using myrec.doc, append ctitle(Model 1) label
streg DDR_index powtran_implem lngdppc CumInt wardur p_polity2 pkopres elect_system ethnic, robust cluster(ccodecow) dist(weibull) nohr
outreg2 using myrec.doc, append ctitle(Model 1) label

**Electoral System Changes**
streg DDR_index powtran_implem lngdppc CumInt wardur p_polity2 pkopres smd_change pr_change ethnic, robust cluster(ccodecow) dist(weibull) nohr
outreg2 using myrec.doc, replace ctitle(Model 1) label

**Robustness Check: Electoral Reform as a binary outcome**
streg DDR_index powtran_implem lngdppc CumInt wardur p_polity2 pkopres elect_zero elect_full ethnic, robust cluster(ccodecow) dist(weibull) nohr
outreg2 using myreg.doc, replace ctitle(Model 1) label

**Robustness Check: Democracy at end of Civil War**
label var democratic_start "Democracy at War's End"
streg DDR_index powtran_implem lngdppc CumInt wardur incomp_govt p_polity2 pkopres first_elect elect_implem reform_election4 ethnic democratic_start, robust cluster(ccodecow) dist(weibull) nohr
outreg2 using myreg.doc, replace ctitle(Model 1) label

**Robustness Check: Just Secessionist Conflicts
streg DDR_index powtran_implem lngdppc CumInt wardur p_polity2 pkopres first_elect elect_implem ethnic if incomp_govt==0, robust cluster(ccodecow) dist(weibull) nohr
outreg2 using myreg.doc, replace ctitle(Model 1) label

**Robustness Check: Using a Cox Proportional Hazard Model**
stcox Intarmy DDR gle_gdp CumInt wardur incomp_govt p_polity2 pkopres Shagov first_elect elect_implem reform_election ethnic, robust cluster(ccodecow) sch(sch*) sca(sca*)
estat phtest,d
drop sch1 sch2 sch3 sch4 sch5 sch6 sch7 sch8 sch9 sch10 sch11 sch12 sch13 sca1 sca2 sca3 sca4 sca5 sca6 sca7 sca8 sca9 sca10 sca11 sca12 sca13

**Robustness Check: Using a Log Logistic Regression
streg Intarmy DDR gle_gdp CumInt wardur incomp_govt p_polity2 pkopres Shagov first_elect elect_implem ethnic, robust cluster(ccodecow) dist(loglogistic)
outreg2 using myreg.doc, replace ctitle(Model 1) label



set more off
set matsize 750

/*Figure 1 Average physical integrity rights respect across different levels of de facto judicial independence 1981Ð2010*/
sum  physintlead if defactojudicialindependence==0
sum  physintlead if defactojudicialindependence==1
sum  physintlead if defactojudicialindependence==2

graph bar (mean) physintlead, over(defactojudicialindependence) title("Average Physical Integrity Rights") subtitle("Across different levels of judicial independence 1981-2010") ytitle("Physical Integrity Rights Respect") 
                
/*Table 2 Defacto Judicial Independence Physical Integrity Rights 1981-2010 Camp Keith Measure All Countries*/
reg physintlead  defactojudicialindependence gdppc gdpchng  newdemocscore logpop trdgdp popdnsty iccpr interstateintensity civilwarintensity   year, robust cluster(ccode)
*outreg2 using table2, word stats(coef se) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, ^) nolabel ti(Table 2: De Facto Judicial Independence and Its Impact on Physical Integrity Rights 1981-2010, All Countries) ct(OLS Regression CIRI Physical Integrity Rights Index) replace
margins, dydx(defactojudicialindependence)
margins, at (defactojudicialindependence=0) 
margins, at (defactojudicialindependence=1)
margins, at (defactojudicialindependence=2)

ivregress liml  physintlead gdppc gdpchng  newdemocscore logpop trdgdp popdnsty iccpr interstateintensity civilwarintensity   year  (defactojudicialindependence = avelf catho80 muslim80 legor_so legor_fr legor_ge legor_sc lat_abst), vce (robust)
*outreg2 using table2, word stats(coef se) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, ^) nolabel ti(Table 2: De Facto Judicial Independence and Its Impact on Physical Integrity Rights 1981-2010, All Countries) ct(LIML Two Stage Least Squares Regression CIRI Physical Integrity Rights Index) append
estat firststage , all forcenonrobust
margins, dydx(defactojudicialindependence)
margins, at (defactojudicialindependence=0) 
margins, at (defactojudicialindependence=1)
margins, at (defactojudicialindependence=2)

/*Appendix A Descriptive Statistics*/
sum  physintlead ptsaverageleadinv amnestyleadinv state_deptleadinv  defactojudicialindependence dejurejudicalindependence  gdppc gdpchng  newdemocscore logpop trdgdp popdnsty iccpr interstateintensity civilwarintensity   year   avelf catho80 muslim80 legor_so legor_fr legor_ge legor_sc lat_abst
*outreg2 using appendixa, replace eqkeep(max min) see word nolabel ti(Appendix A: Descriptive Statistics)

/*Appendix B First Stage & Second Stage Correlations Amongst All Variables */
corr avelf catho80 muslim80 legor_so legor_fr legor_ge legor_sc lat_abst
corr defactojudicialindependence dejurejudicalindependence  gdppc gdpchng  newdemocscore logpop trdgdp popdnsty iccpr interstateintensity civilwarintensity year   

/*VIF Tests Amongst Control variables*/
collin avelf catho80 muslim80 legor_so legor_fr legor_ge legor_sc lat_abst
collin gdppc gdpchng  newdemocscore logpop trdgdp popdnsty iccpr interstateintensity civilwarintensity year

/*Appendix C Predictors of De Facto Judicial Independence Summary of First Stage Results: 1981-2010*/
ivregress liml  physintlead gdppc gdpchng  newdemocscore logpop trdgdp popdnsty iccpr interstateintensity civilwarintensity   year  (defactojudicialindependence = avelf catho80 muslim80 legor_so legor_fr legor_ge legor_sc lat_abst), vce (robust) first

/*Appendix D Robustness Tests Defacto Judicial Independence Physical Integrity Rights 1981-2010 Camp Keith Measure All Countries Bioprobit*/
bioprobit (physintlead = defactojudicialindependence gdppc gdpchng  newdemocscore logpop trdgdp popdnsty iccpr interstateintensity civilwarintensity   year)  (defactojudicialindependence = avelf catho80 muslim80 legor_so legor_fr legor_ge legor_sc lat_abst)
*outreg2 using AppendixD, word stats(coef se) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, ^) nolabel ti(Appendix D: Bivariate Order Probit Models De Facto Judicial Independence and Its Impact on Physical Integrity Rights 1981-2010, All Countries) ct(CIRI Physical Integrity Rights Index) replace

/*Appendix D Robustness Tests Defacto Judicial Independence Physical Integrity Rights 1981-2010 Camp Keith Measure All Countries Bioprobit*/
* Note this was not displayed in the article
bioprobit (ptsaverageleadinv = defactojudicialindependence gdppc gdpchng  newdemocscore logpop trdgdp popdnsty iccpr interstateintensity civilwarintensity   year)  (defactojudicialindependence = avelf catho80 muslim80 legor_so legor_fr legor_ge legor_sc lat_abst)
*outreg2 using AppendixD, word stats(coef se) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, ^) nolabel ti(Appendix D: Bivariate Order Probit Models De Facto Judicial Independence and Its Impact on Physical Integrity Rights 1981-2010, All Countries) ct(PTS Average Index) append

/*Appendix D Robustness Tests Defacto Judicial Independence Physical Integrity Rights 1981-2010 Camp Keith Measure All Countries Bioprobit*/
* Note this was not displayed in the article
bioprobit (amnestyleadinv = defactojudicialindependence gdppc gdpchng  newdemocscore logpop trdgdp popdnsty iccpr interstateintensity civilwarintensity   year)  (defactojudicialindependence = avelf catho80 muslim80 legor_so legor_fr legor_ge legor_sc lat_abst)
*outreg2 using AppendixD, word stats(coef se) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, ^) nolabel ti(Appendix D: Bivariate Order Probit Models De Facto Judicial Independence and Its Impact on Physical Integrity Rights 1981-2010, All Countries) ct(PTS Amnesty International Index) append

/*Appendix D Robustness Tests Defacto Judicial Independence Physical Integrity Rights 1981-2010 Camp Keith Measure All Countries Bioprobit*/
* Note this was not displayed in the article
bioprobit (state_deptleadinv = defactojudicialindependence gdppc gdpchng  newdemocscore logpop trdgdp popdnsty iccpr interstateintensity civilwarintensity   year)  (defactojudicialindependence = avelf catho80 muslim80 legor_so legor_fr legor_ge legor_sc lat_abst)
*outreg2 using AppendixD, word stats(coef se) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, ^) nolabel ti(Appendix D: Bivariate Order Probit Models De Facto Judicial Independence and Its Impact on Physical Integrity Rights 1981-2010, All Countries) ct(PTS State Department Index) append

/*Appendix E Robustness Tests Defacto & De Jure Judicial Independence Physical Integrity Rights 1981-2010 Camp Keith Measure All Countries*/
ivregress liml  physintlead  dejurejudicalindependence gdppc gdpchng  newdemocscore logpop trdgdp popdnsty iccpr interstateintensity civilwarintensity   year  (defactojudicialindependence = avelf catho80 muslim80 legor_so legor_fr legor_ge legor_sc lat_abst), vce (robust)
*outreg2 using AppendixE, word stats(coef se) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, ^) nolabel ti(Appendix E: De Facto & De Jure Judicial Independence and Its Impact on Physical Integrity Rights 1981-2010, All Countries) ct(LIML Two Stage Least Squares Regression CIRI Physical Integrity Rights Index) append
estat firststage , all forcenonrobust

/*Appendix F Robustness Tests Defacto Judicial Independence PTS Average Measure 1981-2010 Camp Keith Measure All Countries*/
ivregress liml  ptsaverageleadinv gdppc gdpchng  newdemocscore logpop trdgdp popdnsty iccpr interstateintensity civilwarintensity   year  (defactojudicialindependence = avelf catho80 muslim80 legor_so legor_fr legor_ge legor_sc lat_abst) if year>1980, vce (robust) 
*outreg2 using AppendixF, word stats(coef se) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, ^) nolabel ti(Appendix F: De Facto Judicial Independence and Its Impact on Physical Integrity Rights 1981-2010, All Countries) ct(LIML Two Stage Least Squares Regression PTS Average Index) replace
estat firststage , all forcenonrobust

/*Appendix F Robustness Tests Defacto Judicial Independence PTS Amnesty Measure 1981-2010 Camp Keith Measure All Countries*/
ivregress liml  amnestyleadinv gdppc gdpchng  newdemocscore logpop trdgdp popdnsty iccpr interstateintensity civilwarintensity   year  (defactojudicialindependence = avelf catho80 muslim80 legor_so legor_fr legor_ge legor_sc lat_abst) if year>1980, vce (robust) 
*outreg2 using AppendixF, word stats(coef se) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, ^) nolabel ti(Appendix F: De Facto Judicial Independence and Its Impact on Physical Integrity Rights 1981-2010, All Countries) ct(LIML Two Stage Least Squares Regression PTS Amnesty International Index) append
estat firststage , all forcenonrobust

/*Appendix F Robustness Tests Defacto Judicial Independence PTS State Dept Measure 1981-2010 Camp Keith Measure All Countries*/
ivregress liml  state_deptleadinv gdppc gdpchng  newdemocscore logpop trdgdp popdnsty iccpr interstateintensity civilwarintensity   year  (defactojudicialindependence = avelf catho80 muslim80 legor_so legor_fr legor_ge legor_sc lat_abst) if year>1980, vce (robust)
*outreg2 using AppendixF, word stats(coef se) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, ^) nolabel ti(Appendix F: De Facto Judicial Independence and Its Impact on Physical Integrity Rights 1981-2010, All Countries) ct(LIML Two Stage Least Squares Regression PTS State Department Index) append

/*Appendix G Robustness Tests Defacto Judicial Independence Physical Integrity Rights Democracy Dummy 4 and above = democracy 1981-2010 Camp Keith Measure All Countries*/
ivregress liml  physintlead gdppc gdpchng  newdemocscoredm logpop trdgdp popdnsty iccpr interstateintensity civilwarintensity   year  (defactojudicialindependence = avelf catho80 muslim80 legor_so legor_fr legor_ge legor_sc lat_abst), vce (robust)
*outreg2 using AppendixG, word stats(coef se) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, ^) nolabel ti(Appendix G: De Facto Judicial Independence and Its Impact on Physical Integrity Rights 1981-2010, All Countries) ct(LIML Two Stage Least Squares Regression CIRI Physical Integrity Rights Index) replace
estat firststage , all forcenonrobust

/*Appendix G Robustness Tests Defacto Judicial Independence Physical Integrity Rights Democracy Dummy high threshold 5 and above = democracy 1981-2010 Camp Keith Measure All Countries*/
ivregress liml  physintlead gdppc gdpchng  newdemocscoredmht logpop trdgdp popdnsty iccpr interstateintensity civilwarintensity   year  (defactojudicialindependence = avelf catho80 muslim80 legor_so legor_fr legor_ge legor_sc lat_abst), vce (robust)
*outreg2 using AppendixG, word stats(coef se) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, ^) nolabel ti(Appendix G: De Facto Judicial Independence and Its Impact on Physical Integrity Rights 1981-2010, All Countries) ct(LIML Two Stage Least Squares Regression CIRI Physical Integrity Rights Index) append
estat firststage , all forcenonrobust





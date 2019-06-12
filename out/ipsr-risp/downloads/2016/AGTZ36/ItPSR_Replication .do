********************************************************************************
** TITLE: REPLICATION PUNISHING LOCAL INCUMBENTS FOR THE LOCAL ECONOMY        **
** JOURNAL: ITALIAN POLITICAL SCIENCE REVIEW 1/2016 						  **
** DATE: NOVEMBER 2015 														  **
** AUTHORS: Dassonneville - Claes - Lewis-Beck 								  **
********************************************************************************


** load dataset [change path if necessary]
use "/Users/ruthdassonneville/Desktop/ItPSR_Punishing Local Incumbents_replication.dta", clear


** REPLICATE TABLE 1 - VOTE FOR INCUMBENT LIST **

* FULL MODEL UNEMPLOYMENT (M1 IN TABLE)

eststo M1: xtmelogit IncumbencyCoalition LaggedCoalition Age Female French HighEdu ///
 Years_municipality  Left_right Terms ENP ///
 Unempl_change_10_11 ///
 || Municipality_code:, var 

xtmrho
estat ic

* NULL MODEL
xtmelogit IncumbencyCoalition ///
 || Municipality_code: , var 

xtmrho
estat ic

* FULL MODEL INCOME TAX (M2 IN TABLE)

eststo M2: xtmelogit IncumbencyCoalition LaggedCoalition Age Female French HighEdu ///
 Years_municipality  Left_right Terms ENP ///
 apb2012 ///
 || Municipality_code:, var 

xtmrho
estat ic

* FULL MODEL PROPERTY TAX (M3 IN TABLE)

eststo M3: xtmelogit IncumbencyCoalition LaggedCoalition Age Female French HighEdu ///
 Years_municipality  Left_right Terms ENP ///
 LPT_2012 ///
 || Municipality_code:, var 

xtmrho
estat ic

* GENERATE TABLE
esttab M1 M2 M3 using ItPSR_Table1.rtf, ///
star(* 0.1 ** 0.02 *** 0.002) se(3) b(3)  pr2 stats(rho1  ll) nogap replace


** REPLICATE TABLE 2 - VOTE FOR INCUMBENT MAYOR **

* FULL MODEL UNEMPLOYMENT (M1 IN TABLE 2)

eststo M1: xtmelogit IncumbencyMayor LaggedMayor Age Female French HighEdu ///
 Years_municipality  Left_right Terms ENP ///
 Unempl_change_10_11 ///
 || Municipality_code:, var 

xtmrho
estat ic


* NULL MODEL
xtmelogit IncumbencyMayor ///
 || Municipality_code: if e(sample)==1, var 

xtmrho
estat ic


* FULL MODEL INCOME TAX (M2 IN TABLE 2)

eststo M2: xtmelogit IncumbencyMayor LaggedMayor Age Female French HighEdu ///
 Years_municipality  Left_right Terms ENP ///
 apb2012 ///
 || Municipality_code:, var 

xtmrho
estat ic

* FULL MODEL PROPERTY TAX (M3 IN TABLE 2)

eststo M3: xtmelogit IncumbencyMayor LaggedMayor Age Female French HighEdu ///
 Years_municipality  Left_right Terms ENP ///
 LPT_2012 ///
 || Municipality_code:, var 

xtmrho
estat ic

* GENERATE TABLE

esttab M1 M2 M3 using ItPSR_Table2.rtf, ///
star(* 0.1 ** 0.02 *** 0.002) se(3) b(3)  pr2 stats(rho1  ll) nogap replace


** TABLE 3 - INTERACTION EDUCATION*ECONOMIC INDICATOR **


* INTERACTION MODEL UNEMPLOYMENT (M1 IN TABLE 3)

eststo MI1: xtmelogit IncumbencyCoalition LaggedCoalition Age Female French HighEdu ///
 Years_municipality  Left_right Terms ENP ///
 Unempl_change_10_11 HighEduUnempl ///
 || Municipality_code:HighEdu, var 

xtmrho
estat ic

* INTERACTION MODEL LIT (M2 IN TABLE 3)
eststo MI2: xtmelogit IncumbencyCoalition LaggedCoalition Age Female French HighEdu ///
 Years_municipality  Left_right Terms ENP ///
 apb2012 HighEduapb ///
 || Municipality_code:HighEdu, var 

xtmrho
estat ic

* INTERACTION MODEL LPT (M3 IN TABLE 3)

eststo MI3: xtmelogit IncumbencyCoalition LaggedCoalition Age Female French HighEdu ///
 Years_municipality  Left_right Terms ENP ///
 LPT_2012 HighEduLPT ///
 || Municipality_code:HighEdu, var 

xtmrho
estat ic

* GENERATE TABLE

esttab MI1 MI2 MI3 using ItPSR_Table3.rtf, ///
star(* 0.1 ** 0.02 *** 0.002) se(3) b(3)  pr2 stats(rho1  ll) nogap replace


** APPENDIX 1 **

* DESCRIPTIVE STATISTICS

* individual-level
sum Age Female French HighEdu Left_right Years_municipality 

* aggregate-level
collapse (mean) LaggedCoalition LaggedMayor Unempl_change_10_11 LPT_2012 apb2012 Terms ENP, by(Municipality_code)
sum LaggedCoalition LaggedMayor Unempl_change_10_11 LPT_2012 apb2012 Terms ENP


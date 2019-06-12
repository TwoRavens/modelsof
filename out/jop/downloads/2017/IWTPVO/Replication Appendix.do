
**********************************************************************************
****Replication Code: Pav‹o, Nara. "Why We DonÕt Just Throw The Rascals Out" *****
**********************************************************************************

**************
** APPENDIX **
**************

***************************************************************************************
* APPENDIX C: Country Analyses
*Table 1: CHOICE OPTIONS REGARDING CORRUPTION, THE ECONOMY, AND SOCIAL ISSUES
***************************************************************************************

    ***********************
	*** CSES Third Wave ***
	***********************

* Model 1C
xtmelogit noneonly i.problem age education income male politicalinformation closeparty  if polityIV>6  || C1003: , 
eststo
esttab using 4.tex, star(+ 0.10 * 0.05 ** 0.01 *** 0.001) se(3)
eststo clear

margins, at(problem=(1 2 3)) atmeans predict(mu fixedonly) vsquish

* Model 2C
xtmelogit nonerec i.problem age education income male politicalinformation closeparty if polityIV>6  || C1003: , 
eststo
esttab using 3.tex, star(* 0.05 ** 0.01 *** 0.001) se(3)
eststo clear




********************************************************************************
* APPENDIX F: Robustness Checks on the Relationship Between Corruption and Cynicism
*Table 1: THE DETERMINANTS OF CYNICISM - ALTERNATIVE MODELS USING V-DEM MEASURE OF CORRUPTION
********************************************************************************

    ***************
	** V-DEM **
	***************


***Alternative Measure of Corruption - V-dem
xtmelogit noneonly vdem_corr  age income male partyage regimeage presidential if problem==1 & polityIV>6  || C1003:  ,
eststo
xtmelogit noneonly vdem_corr education politicalinformation closeparty  polarization  age income male partyage regimeage presidential if problem==1 & polityIV>6  || C1003:  ,
eststo
esttab using 3.tex, star(* 0.05 ** 0.01 *** 0.001) se(3)
eststo clear


***Alternative Models - The Global Corruption Barometer (GCB)




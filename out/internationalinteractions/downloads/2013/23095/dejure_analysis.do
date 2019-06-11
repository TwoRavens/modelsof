******************************************************************************************
* Unionization and the Political Economy of Restrictions on Foreign Direct Investment
* Erica Owen
* International International Replication 
* Analysis of Formal restrictions
* Recreate Tables 1 and 2 in paper; Tables A4 and A5 in Supplemental Appendix
******************************************************************************************

version 12.0
use "/dejure_analysis.dta"

*--------------- Results Table 1 ------------------------*

reg restriction logskillratio permembers contprime labtotmil air yr2-yr4, cluster(golubcorr)
fitstat
estimates store model1_1
sum permembers if e(sample), detail
lincom _b[permembers]*`r(sd)'


reg restriction  hs5 permembers contprime labtotmil air yr2-yr4, cluster(golubcorr)
fitstat
estimates store model1_2

reg restriction logassoc permembers contprime labtotmil air yr2-yr4, cluster(golubcorr)
fitstat
estimates store model1_3

reg restriction logskillsc5 permembers contprime labtotmil air yr2-yr4, cluster(golubcorr)
fitstat
estimates store model1_4

* Model 5: Regression averaging over all years in the sample
reg col_restriction col_logskill col_permembers col_cont col_lab air ///
	if year==1981, vce(hc3)
fitstat
estimates store model1_5

*-------------- Results Table 2 ------------------------*


reg restriction logskillratio permembers contprime labtotmil security, cluster(golubcorr)
fitstat
estimates store model2_1

reg restriction logskillratio permembers contprime labtotmil security if industry~="Air transport", cluster(golubcorr)
fitstat
estimates store model2_2

reg restriction logskillratio permembers contprime labtotmil security manufacturing, cluster(golubcorr)
fitstat
estimates store model2_3

reg restriction logskillratio permembers contprime labtotmil security manufacturing demcongress, cluster(golubcorr)
estimates store model2_4


reg restriction logskillratio c.permembers##i.demcongress manufacturing contprime labtotmil security, cluster(golubcorr) 
fitstat
estimates store model2_5

reg restriction logskillratio permembers contprime labtotmil security manufacturing bits, cluster(golubcorr)
fitstat 
estimates store model2_6

reg restriction logskillratio permembers contprime labtotmil security manufacturing tradebalrealbil if year>1981, cluster(golubcorr)
fitstat
estimates store model2_7

reg restriction logskillratio permembers contprime labtotmil security manufacturing tradebalrealbil lnoutflow, cluster(golubcorr)
fitstat
estimates store model2_8

/*------------- Results Table A4 -----------------------------------
	 Same as Models 1-5 in Table 1 above. Model 6 uses random effects */

xtreg restriction logskillratio permembers contprime labtotmil yr2-yr4, re	 

*------------- Results Table A5 (Exclusion by industry) -----------* 

forvalues i=1/13{
quietly reg restriction logskillratio permembers contprime labtotmil air yr2-yr4 if id~=`i', cluster(golubcorr)
estimates store modela`i'
}




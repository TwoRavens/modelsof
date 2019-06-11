********************************************************************************
***             This file generates the analysis for the TCG-paper           ***
***                     by Katharina & Axel Michaelowa                       ***
********************************************************************************

* Note: Running this file requires the installation of the regression tabulating 
*       commands used below via "ssc install estout"


*cd "C:\michaelowa\Climate\Liliana TCG\Axel&Katja\_Submitted version\Revision\2nd revision"
use TCGcomplete.dta,clear
capture log using TCGanalysis.log, replace
set more off

drop if NoTCG_1==1 /* no real TCG initiatives according to our reassessment (by any measure, and mostly no data available) */
gen ElectionYear0=ElectionDate0>0

* Summary of quality measures
sum Q_*

************
* Figure 1 *
************
histogram Q_Quality1, discrete percent /*addlabel*/


****************************************************************************
* Generating an overview over the development of TCG-Initiatives over time *
****************************************************************************

by year, sort: egen no_annual=count(InitiativeID) if year!=.
browse year no_annual
sum year if  Axel_new==0  /* check completeness --> initial dataset covers years -2010, now until 2015 */

* Annual sums (mean for Q_Quality1)
by year, sort: egen no_Q_Quality1=mean(Q_Quality1) if year!=. /* here not sum since original variable is already a sum */
by year, sort: egen no_Q_Quality2=count(InitiativeID) if Q_Quality2 & year!=.
by year, sort: egen no_Q_Quality3=count(InitiativeID) if Q_Quality3 & year!=.
browse year no_* 
* Note: For year=. this generates missing sums which in turn creates strange interpolations in the graphs. Hence missings in the annual sum (= no initiative) are set to zero.
* In fact, a "tab" shows that these years do not even exist yet in the dataset and first need to be created:
local new = _N + 6
        set obs `new'
replace year = 1995 in 110
replace year = 1996 in 111
foreach i in no_Q_Quality1 no_Q_Quality2 no_Q_Quality3 no_annual {
replace `i'=0 if year==1995 | year==1996
}
* For some reason, when there is no initiative with in the respective category in a given year, this is coded missing for the respective initiative 
* (rather than as the sum for all observations). This creates problems for the graph, when all values are turned to missings becauase all are 0 in a given year
by year, sort: sum no_Q_Quality1 no_Q_Quality2 no_Q_Quality3
* Correction here just for no_Q_Quality2 and 3
by year, sort: sum no_Q_Quality2 no_Q_Quality3
* replacing fully missing years by zeros (not all missings for the two no_Q_* variables can be filled by 0 because egen(count) keeps "." for observations whose initial values were 0!) 
replace no_Q_Quality2=0 if year==1991 | year==1992 | year==1993 | year==1997 | year==1998 | year==2001 | year==2006 | year==2012 | year==2013 | year==2015
replace no_Q_Quality3=0 if year==1991 | year==1992 | year==1993 | year==1994 | year==1997 | year==1998 | year==2001 | year==2002 | year==2006 | year==2009 | year==2011 | year==2012 | year==2013 | year==2015



************
* Figure 2 *
************
twoway (line no_annual year, sort lcolor(black) lwidth(medthick) lpattern(solid)) /*
*/     (line no_Q_Quality2 year, sort lcolor(red) lwidth(medthick) lpattern(longdash)) /*
*/     (line no_Q_Quality3 year, sort lcolor(blue) lwidth(medthick) lpattern(tight_dot)) if year!=2015



************
* Table 1  *
************

tab  Character

tab  C_Network
tab  C_Standard
tab  C_CarbonFund
tab  C_Technology
tab  C_Adaptation


sum  Q_Quality1 if  C_Standard
sum  Q_Quality1 if  C_CarbonFund
sum  Q_Quality1 if  C_Network
sum  Q_Quality1 if  C_Network==0 & C_Technology==0 & C_Adaptation==0 & C_CarbonFund==0 & C_Standard==0
sum  Q_Quality1 if  C_Adaptation
sum  Q_Quality1 if  C_Technology



****************************
* Multivariate estimations *
****************************

* generate all relevant interaction terms 
*(This manual procedure is required for the creation of tables with estout & esttab)

gen CXP=CtryTarget0*Private_L
gen CXPa=CtryTarget0*Partnered_L 
gen CXE= CtryTarget0*Entrepreneurial_L 
gen CXT= CtryTarget0*Transgov_L

gen KXP=Kyoto_committed*Private_L
gen KXPa=Kyoto_committed*Partnered_L 
gen KXE= Kyoto_committed*Entrepreneurial_L 
gen KXT= Kyoto_committed*Transgov_L

gen KXR=Kyoto_committed*A_RegGovInst
gen KXM=Kyoto_committed*A_Municipalities 
gen KXN= Kyoto_committed*A_NGO 
gen KXPS= Kyoto_committed*A_PrivateSector

gen CXR=CtryTarget0*A_RegGovInst
gen CXM=CtryTarget0*A_Municipalities 
gen CXN=CtryTarget0*A_NGO 
gen CXPS=CtryTarget0*A_PrivateSector

gen pCXP=P_postCopenhagen*Private_L
gen pCXPa=P_postCopenhagen*Partnered_L 
gen pCXE=P_postCopenhagen*Entrepreneurial_L 
gen pCXT=P_postCopenhagen*Transgov_L

gen pKXP=P_KyotoOperational*Private_L
gen pKXPa=P_KyotoOperational*Partnered_L 
gen pKXE=P_KyotoOperational*Entrepreneurial_L 
gen pKXT=P_KyotoOperational*Transgov_L

gen pCXR=P_postCopenhagen*A_RegGovInst
gen pCXM=P_postCopenhagen*A_Municipalities 
gen pCXN=P_postCopenhagen*A_NGO 
gen pCXPS=P_postCopenhagen*A_PrivateSector

gen pKXR=P_KyotoOperational*A_RegGovInst
gen pKXM=P_KyotoOperational*A_Municipalities 
gen pKXN=P_KyotoOperational*A_NGO 
gen pKXPS=P_KyotoOperational*A_PrivateSector

gen pCXO=P_postCopenhagen*Orchestration_L
gen pCXS=P_postCopenhagen*Shaping_L 
gen pCXI=P_postCopenhagen*Initiating_L
gen pCXWB=P_postCopenhagen*WB 
gen pCXdGA=P_postCopenhagen*DepGovAction 

gen pKXO=P_KyotoOperational*Orchestration_L
gen pKXS=P_KyotoOperational*Shaping_L
gen pKXI=P_KyotoOperational*Initiating_L 
gen pKXWB=P_KyotoOperational*WB 
gen pKXdGA=P_KyotoOperational*DepGovAction 



*** Table 2  ***

foreach i in Q_Quality1 Q_Quality2 Q_Quality3 Q_MitigationTarget Q_Incentives Q_Baseline Q_MRV {
regress `i' DepGovAction  CtryTarget0 Structure C_Adaptation Entrepreneurial_L CXE Transgov_L CXT  A_NGO CXN  EU WB INT year, robust cluster(country)
eststo
}
esttab _all using "Table2.txt", obslast /*
	*/	tab  nogaps starl(* .1 ** .05 *** .01) replace ar2(2) b(2) p(2) /*
	*/	nonotes addnotes("p-values in parentheses based on robust standard errors; ***, ** and * indicate significance at the 1%-, 5%- and 10%-level respectively.")
/* => Results point at compensation, indeed (but not for entrepreneurial, for which, as opposed to the above individual regressions, coefs are insignificant). */
estimates drop _all


** Table 3 **

foreach i in Q_Quality1 Q_Quality2 Q_Quality3 Q_MitigationTarget Q_Incentives Q_Baseline Q_MRV {
regress `i' DepGovAction  CtryTarget0 Structure C_Adaptation P_KyotoOperational P_postCopenhagen Entrepreneurial_L pKXE pCXE Transgov_L pKXT pCXT A_NGO pKXN pCXN EU WB INT year, robust cluster(country)
eststo
}
esttab _all using "Table3.txt", obslast /*
	*/	tab  nogaps starl(* .1 ** .05 *** .01) replace ar2(2) b(2) p(2) /*
	*/	nonotes addnotes("p-values in parentheses based on robust standard errors; ***, ** and * indicate significance at the 1%-, 5%- and 10%-level respectively.")
/* => Entrepreneurial is very clearly comlementary, Transgov is compensating (nothing sign for NGOs). */
estimates drop _all


*** Table 4  ***

foreach i in Q_Quality1 Q_Quality2 Q_Quality3 Q_MitigationTarget Q_Incentives Q_Baseline Q_MRV {
regress `i' DepGovAction  CtryTarget0 Structure C_Adaptation P_KyotoOperational P_postCopenhagen Shaping_L pKXS pCXS  pKXWB pCXWB EU WB INT year, robust cluster(country)
eststo
}
esttab _all using "Table4.txt", obslast /*
	*/	tab  nogaps starl(* .1 ** .05 *** .01) replace ar2(2) b(2) p(2) /*
	*/	nonotes addnotes("p-values in parentheses based on robust standard errors; ***, ** and * indicate significance at the 1%-, 5%- and 10%-level respectively.")
/* => Initiating is not specially significant. Change of effect of DepGovAction not very clear. hence both are left out here. */
estimates drop _all

*********************************************************************************************************************************************************************************************

* Adding additional controls (Tables for Annex A)

*** Table A2   ***

foreach i in Q_Quality1 Q_Quality2 Q_Quality3 Q_MitigationTarget Q_Incentives Q_Baseline Q_MRV {
regress `i' DepGovAction  CtryTarget0 Structure C_Adaptation Entrepreneurial_L CXE Transgov_L CXT  A_NGO CXN  /*
*/ GCF0  Energy_efficiency0 Emissions_total_pc0 ElectionYear0 no_annual EU WB INT year, robust cluster(country) 
eststo
}
esttab _all using "TableA2.txt", obslast /*
	*/	tab  nogaps starl(* .1 ** .05 *** .01) replace ar2(2) b(2) p(2) /*
	*/	nonotes addnotes("p-values in parentheses based on robust standard errors; ***, ** and * indicate significance at the 1%-, 5%- and 10%-level respectively.")
/* => Results point at compensation, indeed (but not for entrepreneurial, for which there is one sign. coef that points at complementarity). */
estimates drop _all


*** Table A3 ***

foreach i in Q_Quality1 Q_Quality2 Q_Quality3 Q_MitigationTarget Q_Incentives Q_Baseline Q_MRV {
regress `i' DepGovAction  CtryTarget0 Structure C_Adaptation P_KyotoOperational P_postCopenhagen Entrepreneurial_L pKXE pCXE Transgov_L pKXT pCXT A_NGO pKXN pCXN /*
*/ GCF0  Energy_efficiency0 Emissions_total_pc0 ElectionYear0 no_annual EU WB INT year, robust cluster(country)
eststo
}
esttab _all using "TableA3.txt", obslast /*
	*/	tab  nogaps starl(* .1 ** .05 *** .01) replace ar2(2) b(2) p(2) /*
	*/	nonotes addnotes("p-values in parentheses based on robust standard errors; ***, ** and * indicate significance at the 1%-, 5%- and 10%-level respectively.")
/* => Entrepreneurial is very clearly comlementary, Transgov is compensating (nothing sign for NGOs). */
estimates drop _all


*** Table A4  ***

foreach i in Q_Quality1 Q_Quality2 Q_Quality3 Q_MitigationTarget Q_Incentives Q_Baseline Q_MRV {
regress `i' DepGovAction  CtryTarget0 Structure C_Adaptation P_KyotoOperational P_postCopenhagen Shaping_L pKXS pCXS  pKXWB pCXWB /*
*/ GCF0  Energy_efficiency0 Emissions_total_pc0 ElectionYear0 no_annual EU WB INT year, robust cluster(country)
eststo
}
esttab _all using "TableA4.txt", obslast /*
	*/	tab  nogaps starl(* .1 ** .05 *** .01) replace ar2(2) b(2) p(2) /*
	*/	nonotes addnotes("p-values in parentheses based on robust standard errors (heteroscedasticity consistent and clustered by country); ***, ** and * indicate significance at the 1%-, 5%- and 10%-level respectively. ")
/* => Initiating is not specially significant. Change of effect of DepGovAction not very clear. hence both are left out here. */
estimates drop _all

*********************************************************************************************************************************************************************************************

***********************************************************************************************************************
* Further testing (partially mentioned in the text in the "Methods" section, but without tables presented in the text)*
***********************************************************************************************************************

* Use Quality1 measure with only 3 categories (given that there is only one TCG initiative that meets all four criteria)
gen Q_Quality1b=Q_Quality1
replace Q_Quality1b=3 if Q_Quality1==4
regress Q_Quality1b DepGovAction  CtryTarget0 Structure C_Adaptation Entrepreneurial_L CXE Transgov_L CXT  A_NGO CXN  EU WB INT year, robust cluster(country)
regress Q_Quality1b DepGovAction  CtryTarget0 Structure C_Adaptation P_KyotoOperational P_postCopenhagen Entrepreneurial_L pKXE pCXE Transgov_L pKXT pCXT A_NGO pKXN pCXN EU WB INT year, robust cluster(country)
regress Q_Quality1b DepGovAction  CtryTarget0 Structure C_Adaptation P_KyotoOperational P_postCopenhagen Shaping_L pKXS pCXS  pKXWB pCXWB EU WB INT year, robust cluster(country)
* =>  No major changes in either size or significance.


* Ordered Probit to check distance of thresholds
regress Q_Quality1 DepGovAction  CtryTarget0 Structure C_Adaptation Entrepreneurial_L CXE Transgov_L CXT  A_NGO CXN  EU WB INT year, robust cluster(country) /* for comparison */

oprobit Q_Quality1 DepGovAction  CtryTarget0 Structure C_Adaptation Entrepreneurial_L CXE Transgov_L CXT  A_NGO CXN  EU WB INT year, robust cluster(country)
oprobit Q_Quality1 DepGovAction  CtryTarget0 Structure C_Adaptation P_KyotoOperational P_postCopenhagen Entrepreneurial_L pKXE pCXE Transgov_L pKXT pCXT A_NGO pKXN pCXN EU WB INT year, robust cluster(country)
oprobit Q_Quality1 DepGovAction  CtryTarget0 Structure C_Adaptation P_KyotoOperational P_postCopenhagen Shaping_L pKXS pCXS  pKXWB pCXWB EU WB INT year, robust cluster(country)

oprobit Q_Quality1b DepGovAction  CtryTarget0 Structure C_Adaptation Entrepreneurial_L CXE Transgov_L CXT  A_NGO CXN  EU WB INT year, robust cluster(country)
oprobit Q_Quality1b DepGovAction  CtryTarget0 Structure C_Adaptation P_KyotoOperational P_postCopenhagen Entrepreneurial_L pKXE pCXE Transgov_L pKXT pCXT A_NGO pKXN pCXN EU WB INT year, robust cluster(country)
oprobit Q_Quality1b DepGovAction  CtryTarget0 Structure C_Adaptation P_KyotoOperational P_postCopenhagen Shaping_L pKXS pCXS  pKXWB pCXWB EU WB INT year, robust cluster(country)

* At least for Q_Quality1b the distance between categories is clearly very similar.
* Given the above result that using Q_Quality1 or Q_Quality1b does not make a difference for the OLS regressions, we conclude that using OLS regressions is ok.
 
 

* Omitting adaptation-oriented initiatives

*** Table 2 without adaptation initiatives ***
foreach i in Q_Quality1 Q_Quality2 Q_Quality3 Q_MitigationTarget Q_Incentives Q_Baseline Q_MRV {
regress `i' DepGovAction  CtryTarget0 Structure Entrepreneurial_L CXE Transgov_L CXT  A_NGO CXN  EU WB INT year if C_Adaptation!=1, robust cluster(country)
eststo
}
esttab _all using "Table2b.txt", obslast /*
	*/	tab  nogaps starl(* .1 ** .05 *** .01) replace ar2(2) b(2) p(2) /*
	*/	nonotes addnotes("p-values in parentheses based on robust standard errors; ***, ** and * indicate significance at the 1%-, 5%- and 10%-level respectively.")
estimates drop _all

*** Table 3 without adaptation initiatives ***
foreach i in Q_Quality1 Q_Quality2 Q_Quality3 Q_MitigationTarget Q_Incentives Q_Baseline Q_MRV {
regress `i' DepGovAction  CtryTarget0 Structure P_KyotoOperational P_postCopenhagen Entrepreneurial_L pKXE pCXE Transgov_L pKXT pCXT A_NGO pKXN pCXN EU WB INT year if C_Adaptation!=1, robust cluster(country)
eststo
}
esttab _all using "Table3b.txt", obslast /*
	*/	tab  nogaps starl(* .1 ** .05 *** .01) replace ar2(2) b(2) p(2) /*
	*/	nonotes addnotes("p-values in parentheses based on robust standard errors; ***, ** and * indicate significance at the 1%-, 5%- and 10%-level respectively.")
estimates drop _all

*** Table 4 without adaptation initiatives  ***
foreach i in Q_Quality1 Q_Quality2 Q_Quality3 Q_MitigationTarget Q_Incentives Q_Baseline Q_MRV {
regress `i' DepGovAction  CtryTarget0 Structure P_KyotoOperational P_postCopenhagen Shaping_L pKXS pCXS  pKXWB pCXWB EU WB INT year if C_Adaptation!=1, robust cluster(country)
eststo
}
esttab _all using "Table4b.txt", obslast /*
	*/	tab  nogaps starl(* .1 ** .05 *** .01) replace ar2(2) b(2) p(2) /*
	*/	nonotes addnotes("p-values in parentheses based on robust standard errors; ***, ** and * indicate significance at the 1%-, 5%- and 10%-level respectively.")
estimates drop _all

* => No major changes, either.



*********************************************************************************************************************************************************************************************

**************************************************
*  Descriptive statistics for relevant variables *
**************************************************

*******************************************
* Annex Table A1 for variable description *
*******************************************

gen ElectionYear=ElectionYear0
replace ElectionYear=. if country=="WB" | country=="EU" | country=="INT"

sum Q_Quality1 Q_Quality2 Q_Quality3 Q_MitigationTarget Q_Incentives Q_Baseline Q_MRV DepGovAction  CtryTarget Structure C_Adaptation Entrepreneurial_L Transgov_L A_NGO  /*
*/ Shaping_L P_KyotoOperational P_postCopenhagen GCF Energy_efficiency Emissions_total_pc ElectionYear no_annual EU WB INT year
descr Q_Quality1 Q_Quality2 Q_Quality3 Q_MitigationTarget Q_Incentives Q_Baseline Q_MRV DepGovAction  CtryTarget Structure C_Adaptation Entrepreneurial_L Transgov_L A_NGO  /*
*/ Shaping_L P_KyotoOperational P_postCopenhagen GCF Energy_efficiency Emissions_total_pc ElectionYear no_annual EU WB INT year /* Note: Description in Word table is slightly more complete */


*********************************************************************************************************************************************************************************************
capture log close

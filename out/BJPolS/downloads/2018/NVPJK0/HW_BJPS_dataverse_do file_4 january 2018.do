
******************************************************************************
*** Replication do file for "When Do You Get Economists as Policy Makers?" ***
********************** Mark Hallerberg & Joachim Wehner **********************
******************** British Journal of Political Science ********************
************************ Last update: 4 January 2018 *************************
********** Stata/SE 14.2 for Mac (64-bit Intel), Revision 4 May 2017 *********
******************************************************************************


************************
*** Main regressions ***
************************

* Table 1, panel A: FM main results

set more off
reg econdegreefm2 i.lvbankingall c.rlpartypm_s i.decade70 i.decade80 i.decade90 i.country2 if fmsample==1, cluster(country2)
reg econphdfm i.lvbankingall c.rlpartypm_s i.decade70 i.decade80 i.decade90 i.country2 if fmsample==1, cluster(country2)
reg econproffm2 i.lvbankingall c.rlpartypm_s i.decade70 i.decade80 i.decade90 i.country2 if fmsample==1, cluster(country2)
reg centralbankerfm2 i.lvbankingall c.rlpartypm_s i.decade70 i.decade80 i.decade90 i.country2 if fmsample==1, cluster(country2)
reg privatefinancefm i.lvbankingall c.rlpartypm_s i.decade70 i.decade80 i.decade90 i.country2 if fmsample==1, cluster(country2)

* Table 1, panel B: CB main results

set more off
reg econdegreecb2 i.lvbankingall c.rlpartypm_s i.decade70 i.decade80 i.decade90 i.country2 if cbsample==1, cluster(country2)
reg econphdcb i.lvbankingall c.rlpartypm_s i.decade70 i.decade80 i.decade90 i.country2 if cbsample==1, cluster(country2)
reg econprofcb2 i.lvbankingall c.rlpartypm_s i.decade70 i.decade80 i.decade90 i.country2 if cbsample==1, cluster(country2)
reg centralbankercb2 i.lvbankingall c.rlpartypm_s i.decade70 i.decade80 i.decade90 i.country2 if cbsample==1, cluster(country2)
reg privatefinancecb i.lvbankingall c.rlpartypm_s i.decade70 i.decade80 i.decade90 i.country2 if cbsample==1, cluster(country2)


****************
*** Appendix ***
****************

* Table A1, pane A: FM logit

set more off
clogit econdegreefm2 i.lvbankingall c.rlpartypm_s i.decade70 i.decade80 i.decade90 if fmsample==1, group(country2) cluster(country2)
clogit econphdfm i.lvbankingall c.rlpartypm_s i.decade70 i.decade80 i.decade90 if fmsample==1, group(country2) cluster(country2)
clogit econproffm2 i.lvbankingall c.rlpartypm_s i.decade70 i.decade80 i.decade90 if fmsample==1, group(country2) cluster(country2)
clogit centralbankerfm2 i.lvbankingall c.rlpartypm_s i.decade70 i.decade80 i.decade90 if fmsample==1, group(country2) cluster(country2)
clogit privatefinancefm i.lvbankingall c.rlpartypm_s i.decade70 i.decade80 i.decade90 if fmsample==1, group(country2) cluster(country2)

* Table A1, panel B: CB logit

set more off
clogit econdegreecb2 i.lvbankingall c.rlpartypm_s i.decade70 i.decade80 i.decade90 if cbsample==1, group(country2) cluster(country2)
clogit econphdcb i.lvbankingall c.rlpartypm_s i.decade70 i.decade80 i.decade90 if cbsample==1, group(country2) cluster(country2)
clogit econprofcb2 i.lvbankingall c.rlpartypm_s i.decade70 i.decade80 i.decade90 if cbsample==1, group(country2) cluster(country2)
clogit centralbankercb2 i.lvbankingall c.rlpartypm_s i.decade70 i.decade80 i.decade90 if cbsample==1, group(country2) cluster(country2)
clogit privatefinancecb i.lvbankingall c.rlpartypm_s i.decade70 i.decade80 i.decade90 if cbsample==1, group(country2) cluster(country2)

* Table A2, panel A: FM with RR banking crises data

set more off
reg econdegreefm2 i.rrbankingcrisis c.rlpartypm_s i.decade70 i.decade80 i.decade90 i.country2 if fmsample==1, cluster(country2)
reg econphdfm i.rrbankingcrisis c.rlpartypm_s i.decade70 i.decade80 i.decade90 i.country2 if fmsample==1, cluster(country2)
reg econproffm2 i.rrbankingcrisis c.rlpartypm_s i.decade70 i.decade80 i.decade90 i.country2 if fmsample==1, cluster(country2)
reg centralbankerfm2 i.rrbankingcrisis c.rlpartypm_s i.decade70 i.decade80 i.decade90 i.country2 if fmsample==1, cluster(country2)
reg privatefinancefm i.rrbankingcrisis c.rlpartypm_s i.decade70 i.decade80 i.decade90 i.country2 if fmsample==1, cluster(country2)

* Table A2, panel B: CB with RR banking crises data

set more off
reg econdegreecb2 i.rrbankingcrisis c.rlpartypm_s i.decade70 i.decade80 i.decade90 i.country2 if cbsample==1, cluster(country2)
reg econphdcb i.rrbankingcrisis c.rlpartypm_s i.decade70 i.decade80 i.decade90 i.country2 if cbsample==1, cluster(country2)
reg econprofcb2 i.rrbankingcrisis c.rlpartypm_s i.decade70 i.decade80 i.decade90 i.country2 if cbsample==1, cluster(country2)
reg centralbankercb2 i.rrbankingcrisis c.rlpartypm_s i.decade70 i.decade80 i.decade90 i.country2 if cbsample==1, cluster(country2)
reg privatefinancecb i.rrbankingcrisis c.rlpartypm_s i.decade70 i.decade80 i.decade90 i.country2 if cbsample==1, cluster(country2)

* Table A3, panel A: FM with LV broad crisis measure

set more off
reg econdegreefm2 i.lvanycrisis c.rlpartypm_s i.decade70 i.decade80 i.decade90 i.country2 if fmsample==1, cluster(country2)
reg econphdfm i.lvanycrisis c.rlpartypm_s i.decade70 i.decade80 i.decade90 i.country2 if fmsample==1, cluster(country2)
reg econproffm2 i.lvanycrisis c.rlpartypm_s i.decade70 i.decade80 i.decade90 i.country2 if fmsample==1, cluster(country2)
reg centralbankerfm2 i.lvanycrisis c.rlpartypm_s i.decade70 i.decade80 i.decade90 i.country2 if fmsample==1, cluster(country2)
reg privatefinancefm i.lvanycrisis c.rlpartypm_s i.decade70 i.decade80 i.decade90 i.country2 if fmsample==1, cluster(country2)

* Table A3, panel B: CB with LV broad crisis measure

set more off
reg econdegreecb2 i.lvanycrisis c.rlpartypm_s i.decade70 i.decade80 i.decade90 i.country2 if cbsample==1, cluster(country2)
reg econphdcb i.lvanycrisis c.rlpartypm_s i.decade70 i.decade80 i.decade90 i.country2 if cbsample==1, cluster(country2)
reg econprofcb2 i.lvanycrisis c.rlpartypm_s i.decade70 i.decade80 i.decade90 i.country2 if cbsample==1, cluster(country2)
reg centralbankercb2 i.lvanycrisis c.rlpartypm_s i.decade70 i.decade80 i.decade90 i.country2 if cbsample==1, cluster(country2)
reg privatefinancecb i.lvanycrisis c.rlpartypm_s i.decade70 i.decade80 i.decade90 i.country2 if cbsample==1, cluster(country2)

* Table A4, panel A: FM interactions

set more off
reg econdegreefm2 i.lvbankingall c.rlpartypm_s c.rlpm_bc2 i.decade70 i.decade80 i.decade90 i.country2 if fmsample==1, cluster(country2)
lincom _b[rlpartypm_s] + _b[rlpm_bc2]
reg econphdfm i.lvbankingall c.rlpartypm_s c.rlpm_bc2 i.decade70 i.decade80 i.decade90 i.country2 if fmsample==1, cluster(country2)
lincom _b[rlpartypm_s] + _b[rlpm_bc2]
reg econproffm2 i.lvbankingall c.rlpartypm_s c.rlpm_bc2 i.decade70 i.decade80 i.decade90 i.country2 if fmsample==1, cluster(country2)
lincom _b[rlpartypm_s] + _b[rlpm_bc2]
reg centralbankerfm2 i.lvbankingall c.rlpartypm_s c.rlpm_bc2 i.decade70 i.decade80 i.decade90 i.country2 if fmsample==1, cluster(country2)
lincom _b[rlpartypm_s] + _b[rlpm_bc2]
reg privatefinancefm i.lvbankingall c.rlpartypm_s c.rlpm_bc2 i.decade70 i.decade80 i.decade90 i.country2 if fmsample==1, cluster(country2)
lincom _b[rlpartypm_s] + _b[rlpm_bc2]

* Table A4, panel B: CB interactions

set more off
reg econdegreecb2 i.lvbankingall c.rlpartypm_s c.rlpm_bc2 i.decade70 i.decade80 i.decade90 i.country2 if cbsample==1, cluster(country2)
lincom _b[rlpartypm_s] + _b[rlpm_bc2]
reg econphdcb i.lvbankingall c.rlpartypm_s c.rlpm_bc2 i.decade70 i.decade80 i.decade90 i.country2 if cbsample==1, cluster(country2)
lincom _b[rlpartypm_s] + _b[rlpm_bc2]
reg econprofcb2 i.lvbankingall c.rlpartypm_s c.rlpm_bc2 i.decade70 i.decade80 i.decade90 i.country2 if cbsample==1, cluster(country2)
lincom _b[rlpartypm_s] + _b[rlpm_bc2]
reg centralbankercb2 i.lvbankingall c.rlpartypm_s c.rlpm_bc2 i.decade70 i.decade80 i.decade90 i.country2 if cbsample==1, cluster(country2)
lincom _b[rlpartypm_s] + _b[rlpm_bc2]
reg privatefinancecb i.lvbankingall c.rlpartypm_s c.rlpm_bc2 i.decade70 i.decade80 i.decade90 i.country2 if cbsample==1, cluster(country2)
lincom _b[rlpartypm_s] + _b[rlpm_bc2]

* Table A5: FM regressions with expanded set of controls

set more off
reg econdegreefm2 i.lvbankingall c.rlpartypm_s c.imfpublicdebtgdp c.CBIweighted i.coalition c.polconiii c.bureauquality c.ka_open i.decade70 i.decade80 i.decade90 i.country2 if fmsample==1, cluster(country2)
reg econphdfm i.lvbankingall c.rlpartypm_s c.imfpublicdebtgdp c.CBIweighted i.coalition c.polconiii c.bureauquality c.ka_open i.decade70 i.decade80 i.decade90 i.country2 if fmsample==1, cluster(country2)
reg econproffm2 i.lvbankingall c.rlpartypm_s c.imfpublicdebtgdp c.CBIweighted i.coalition c.polconiii c.bureauquality c.ka_open i.decade70 i.decade80 i.decade90 i.country2 if fmsample==1, cluster(country2)
reg centralbankerfm2 i.lvbankingall c.rlpartypm_s c.imfpublicdebtgdp c.CBIweighted i.coalition c.polconiii c.bureauquality c.ka_open i.decade70 i.decade80 i.decade90 i.country2 if fmsample==1, cluster(country2)
reg privatefinancefm i.lvbankingall c.rlpartypm_s c.imfpublicdebtgdp c.CBIweighted i.coalition c.polconiii c.bureauquality c.ka_open i.decade70 i.decade80 i.decade90 i.country2 if fmsample==1, cluster(country2)

* Table A6: CB regressions with expanded set of controls

set more off
reg econdegreecb2 i.lvbankingall c.rlpartypm_s c.imfpublicdebtgdp c.CBIweighted i.coalition c.polconiii c.bureauquality c.ka_open i.decade70 i.decade80 i.decade90 i.country2 if cbsample==1, cluster(country2)
reg econphdcb i.lvbankingall c.rlpartypm_s c.imfpublicdebtgdp c.CBIweighted i.coalition c.polconiii c.bureauquality c.ka_open i.decade70 i.decade80 i.decade90 i.country2 if cbsample==1, cluster(country2)
reg econprofcb2 i.lvbankingall c.rlpartypm_s c.imfpublicdebtgdp c.CBIweighted i.coalition c.polconiii c.bureauquality c.ka_open i.decade70 i.decade80 i.decade90 i.country2 if cbsample==1, cluster(country2)
reg centralbankercb2 i.lvbankingall c.rlpartypm_s c.imfpublicdebtgdp c.CBIweighted i.coalition c.polconiii c.bureauquality c.ka_open i.decade70 i.decade80 i.decade90 i.country2 if cbsample==1, cluster(country2)
reg privatefinancecb i.lvbankingall c.rlpartypm_s c.imfpublicdebtgdp c.CBIweighted i.coalition c.polconiii c.bureauquality c.ka_open i.decade70 i.decade80 i.decade90 i.country2 if cbsample==1, cluster(country2)

* Table A7, panel A: FM regressions with reduced country sample

set more off
reg econdegreefm2 i.lvbankingall c.rlpartypm_s i.decade70 i.decade80 i.decade90 i.country2 if fmsample==1 & developed==1, cluster(country2)
reg econphdfm i.lvbankingall c.rlpartypm_s i.decade70 i.decade80 i.decade90 i.country2 if fmsample==1 & developed==1, cluster(country2)
reg econproffm2 i.lvbankingall c.rlpartypm_s i.decade70 i.decade80 i.decade90 i.country2 if fmsample==1 & developed==1, cluster(country2)
reg centralbankerfm2 i.lvbankingall c.rlpartypm_s i.decade70 i.decade80 i.decade90 i.country2 if fmsample==1 & developed==1, cluster(country2)
reg privatefinancefm i.lvbankingall c.rlpartypm_s i.decade70 i.decade80 i.decade90 i.country2 if fmsample==1 & developed==1, cluster(country2)

* Table A7, panel B: CB regressions with reduced country sample

set more off
reg econdegreecb2 i.lvbankingall c.rlpartypm_s i.decade70 i.decade80 i.decade90 i.country2 if cbsample==1 & developed==1, cluster(country2)
reg econphdcb i.lvbankingall c.rlpartypm_s i.decade70 i.decade80 i.decade90 i.country2 if cbsample==1 & developed==1, cluster(country2)
reg econprofcb2 i.lvbankingall c.rlpartypm_s i.decade70 i.decade80 i.decade90 i.country2 if cbsample==1 & developed==1, cluster(country2)
reg centralbankercb2 i.lvbankingall c.rlpartypm_s i.decade70 i.decade80 i.decade90 i.country2 if cbsample==1 & developed==1, cluster(country2)
reg privatefinancecb i.lvbankingall c.rlpartypm_s i.decade70 i.decade80 i.decade90 i.country2 if cbsample==1 & developed==1, cluster(country2)

* Table A8, panel A: FM regressions with interaction partisanship and debt

set more off
reg econdegreefm2 i.lvbankingall c.rlpartypm_s c.imfpublicdebtgdp c.rlpm_debt i.decade70 i.decade80 i.decade90 i.country2 if fmsample==1, cluster(country2)
lincom _b[rlpartypm_s] + _b[rlpm_debt]
reg econphdfm i.lvbankingall c.rlpartypm_s c.imfpublicdebtgdp c.rlpm_debt i.decade70 i.decade80 i.decade90 i.country2 if fmsample==1, cluster(country2)
lincom _b[rlpartypm_s] + _b[rlpm_debt]
reg econproffm2 i.lvbankingall c.rlpartypm_s c.imfpublicdebtgdp c.rlpm_debt i.decade70 i.decade80 i.decade90 i.country2 if fmsample==1, cluster(country2)
lincom _b[rlpartypm_s] + _b[rlpm_debt]
reg centralbankerfm2 i.lvbankingall c.rlpartypm_s c.imfpublicdebtgdp c.rlpm_debt i.decade70 i.decade80 i.decade90 i.country2 if fmsample==1, cluster(country2)
lincom _b[rlpartypm_s] + _b[rlpm_debt]
reg privatefinancefm i.lvbankingall c.rlpartypm_s c.imfpublicdebtgdp c.rlpm_debt i.decade70 i.decade80 i.decade90 i.country2 if fmsample==1, cluster(country2)
lincom _b[rlpartypm_s] + _b[rlpm_debt]

* Table A8, panel B: CB regressions with interaction partisanship and debt

set more off
reg econdegreecb2 i.lvbankingall c.rlpartypm_s c.imfpublicdebtgdp c.rlpm_debt i.decade70 i.decade80 i.decade90 i.country2 if cbsample==1, cluster(country2)
lincom _b[rlpartypm_s] + _b[rlpm_debt]
reg econphdcb i.lvbankingall c.rlpartypm_s c.imfpublicdebtgdp c.rlpm_debt i.decade70 i.decade80 i.decade90 i.country2 if cbsample==1, cluster(country2)
lincom _b[rlpartypm_s] + _b[rlpm_debt]
reg econprofcb2 i.lvbankingall c.rlpartypm_s c.imfpublicdebtgdp c.rlpm_debt i.decade70 i.decade80 i.decade90 i.country2 if cbsample==1, cluster(country2)
lincom _b[rlpartypm_s] + _b[rlpm_debt]
reg centralbankercb2 i.lvbankingall c.rlpartypm_s c.imfpublicdebtgdp c.rlpm_debt i.decade70 i.decade80 i.decade90 i.country2 if cbsample==1, cluster(country2)
lincom _b[rlpartypm_s] + _b[rlpm_debt]
reg privatefinancecb i.lvbankingall c.rlpartypm_s c.imfpublicdebtgdp c.rlpm_debt i.decade70 i.decade80 i.decade90 i.country2 if cbsample==1, cluster(country2)
lincom _b[rlpartypm_s] + _b[rlpm_debt]

* Table A9, panel A: FM regressions with interaction partisanship and political constraints

set more off
reg econdegreefm2 i.lvbankingall c.rlpartypm_s c.polconiii c.rlpm_polcon i.decade70 i.decade80 i.decade90 i.country2 if fmsample==1, cluster(country2)
lincom _b[rlpartypm_s] + _b[rlpm_polcon]
reg econphdfm i.lvbankingall c.rlpartypm_s c.polconiii c.rlpm_polcon i.decade70 i.decade80 i.decade90 i.country2 if fmsample==1, cluster(country2)
lincom _b[rlpartypm_s] + _b[rlpm_polcon]
reg econproffm2 i.lvbankingall c.rlpartypm_s c.polconiii c.rlpm_polcon i.decade70 i.decade80 i.decade90 i.country2 if fmsample==1, cluster(country2)
lincom _b[rlpartypm_s] + _b[rlpm_polcon]
reg centralbankerfm2 i.lvbankingall c.rlpartypm_s c.polconiii c.rlpm_polcon i.decade70 i.decade80 i.decade90 i.country2 if fmsample==1, cluster(country2)
lincom _b[rlpartypm_s] + _b[rlpm_polcon]
reg privatefinancefm i.lvbankingall c.rlpartypm_s c.polconiii c.rlpm_polcon i.decade70 i.decade80 i.decade90 i.country2 if fmsample==1, cluster(country2)
lincom _b[rlpartypm_s] + _b[rlpm_polcon]

* Table A9, panel B: CB regressions with interaction partisanship and political constraints

set more off
reg econdegreecb2 i.lvbankingall c.rlpartypm_s c.polconiii c.rlpm_polcon i.decade70 i.decade80 i.decade90 i.country2 if cbsample==1, cluster(country2)
lincom _b[rlpartypm_s] + _b[rlpm_polcon]
reg econphdcb i.lvbankingall c.rlpartypm_s c.polconiii c.rlpm_polcon i.decade70 i.decade80 i.decade90 i.country2 if cbsample==1, cluster(country2)
lincom _b[rlpartypm_s] + _b[rlpm_polcon]
reg econprofcb2 i.lvbankingall c.rlpartypm_s c.polconiii c.rlpm_polcon i.decade70 i.decade80 i.decade90 i.country2 if cbsample==1, cluster(country2)
lincom _b[rlpartypm_s] + _b[rlpm_polcon]
reg centralbankercb2 i.lvbankingall c.rlpartypm_s c.polconiii c.rlpm_polcon i.decade70 i.decade80 i.decade90 i.country2 if cbsample==1, cluster(country2)
lincom _b[rlpartypm_s] + _b[rlpm_polcon]
reg privatefinancecb i.lvbankingall c.rlpartypm_s c.polconiii c.rlpm_polcon i.decade70 i.decade80 i.decade90 i.country2 if cbsample==1, cluster(country2)
lincom _b[rlpartypm_s] + _b[rlpm_polcon]

* Table A10, panel A: FM regressions with PM and CB advanced econ degree

set more off
reg econdegreefm2 i.lvbankingall c.rlpartypm_s i.econdegreepm2 i.econdegreecb2 i.decade70 i.decade80 i.decade90 i.country2 if fmsample==1, cluster(country2)
reg econphdfm i.lvbankingall c.rlpartypm_s i.econdegreepm2 i.econdegreecb2 i.decade70 i.decade80 i.decade90 i.country2 if fmsample==1, cluster(country2)
reg econproffm2 i.lvbankingall c.rlpartypm_s i.econdegreepm2 i.econdegreecb2 i.decade70 i.decade80 i.decade90 i.country2 if fmsample==1, cluster(country2)
reg centralbankerfm2 i.lvbankingall c.rlpartypm_s i.econdegreepm2 i.econdegreecb2 i.decade70 i.decade80 i.decade90 i.country2 if fmsample==1, cluster(country2)
reg privatefinancefm i.lvbankingall c.rlpartypm_s i.econdegreepm2 i.econdegreecb2 i.decade70 i.decade80 i.decade90 i.country2 if fmsample==1, cluster(country2)

* Table A10, panel B: CB regressions with PM and FM advanced econ degree

set more off
reg econdegreecb2 i.lvbankingall c.rlpartypm_s i.econdegreepm2 i.econdegreefm2 i.decade70 i.decade80 i.decade90 i.country2 if cbsample==1, cluster(country2)
reg econphdcb i.lvbankingall c.rlpartypm_s i.econdegreepm2 i.econdegreefm2 i.decade70 i.decade80 i.decade90 i.country2 if cbsample==1, cluster(country2)
reg econprofcb2 i.lvbankingall c.rlpartypm_s i.econdegreepm2 i.econdegreefm2 i.decade70 i.decade80 i.decade90 i.country2 if cbsample==1, cluster(country2)
reg centralbankercb2 i.lvbankingall c.rlpartypm_s i.econdegreepm2 i.econdegreefm2 i.decade70 i.decade80 i.decade90 i.country2 if cbsample==1, cluster(country2)
reg privatefinancecb i.lvbankingall c.rlpartypm_s i.econdegreepm2 i.econdegreefm2 i.decade70 i.decade80 i.decade90 i.country2 if cbsample==1, cluster(country2)


***************************************************
** Figure 1: economics training of PM, FM and CB **
***************************************************

** Summary stats and correlations **

sum econphdpm econdegreepm2 econdegreepm if pmsample2 == 1
sum econphdfm econdegreefm2 econdegreefm if fmsample2 == 1
sum econphdcb econdegreecb2 econdegreecb if cbsample2 == 1

cor econphdpm econdegreepm2 econdegreepm if pmsample2 == 1
cor econphdfm econdegreefm2 econdegreefm if fmsample2 == 1
cor econphdcb econdegreecb2 econdegreecb if cbsample2 == 1

** Country averages **

by country2: egen avg2_econphdpm = mean(econphdpm) if pmsample2 == 1
by country2: egen avg2_econdegreepm2 = mean(econdegreepm2) if pmsample2 == 1
by country2: egen avg2_econdegreepm = mean(econdegreepm) if pmsample2 == 1

by country2: egen avg2_econphdfm = mean(econphdfm) if fmsample2 == 1
by country2: egen avg2_econdegreefm2 = mean(econdegreefm2) if fmsample2 == 1
by country2: egen avg2_econdegreefm = mean(econdegreefm) if fmsample2 == 1

by country2: egen avg2_econphdcb = mean(econphdcb) if cbsample2 == 1
by country2: egen avg2_econdegreecb2 = mean(econdegreecb2) if cbsample2 == 1
by country2: egen avg2_econdegreecb = mean(econdegreecb) if cbsample2 == 1

list country2 avg2_econphdpm avg2_econdegreepm2 avg2_econdegreepm if pmsample2 == 1
list country2 avg2_econphdfm avg2_econdegreefm2 avg2_econdegreefm if fmsample2 == 1
list country2 avg2_econphdcb avg2_econdegreecb2 avg2_econdegreecb if cbsample2 == 1

** Graph **

graph dot econphdpm econdegreepm2 econdegreepm if pmsample2 == 1, /*
*/ over(country, sort(rank_pmi) label(labsize(vsmall))) /*
*/ title("(a) Leaders", size(small) margin(medium)) /*
*/ marker(1, msymbol(O) mcolor(cranberry) msize(medsmall)) /*
*/ marker(2, msymbol(T) mcolor(navy) msize(medsmall)) /*
*/ marker(3, msymbol(S) mcolor(eltgreen) msize(medsmall)) /*
*/ legend(label(1 "Econ Doctorate or PhD") /*
*/ label(2 "Advanced Econ Degree") /*
*/ label(3 "Any Econ Degree") position(6) rows(1)) /*
*/ legend(size(vsmall) region(lcolor(white))) linetype(line) lines(lwidth(thin) /*
*/ lcolor(gs12)) graphregion(color(white)) scheme(lean2) ytitle("", /*
*/ size(vsmall)) ylabel(0 .1 .2 .3 .4 .5 .6 .7 .8 .9 1, labsize(vsmall)) /*
*/ xsize(1) ysize(1) name(competence1i, replace)

graph dot econphdfm econdegreefm2 econdegreefm if fmsample2 == 1, /*
*/ over(country, sort(rank_fmi) label(labsize(vsmall))) /*
*/ title("(b) Finance Ministers", size(small) margin(medium)) /*
*/ marker(1, msymbol(O) mcolor(cranberry) msize(medsmall)) /*
*/ marker(2, msymbol(T) mcolor(navy) msize(medsmall)) /*
*/ marker(3, msymbol(S) mcolor(eltgreen) msize(medsmall)) /*
*/ legend(label(1 "Econ Doctorate or PhD") /*
*/ label(2 "Advanced Econ Degree") /*
*/ label(3 "Any Econ Degree") position(6) rows(1)) /*
*/ legend(size(vsmall) region(lcolor(white))) linetype(line) lines(lwidth(thin) /*
*/ lcolor(gs12)) graphregion(color(white)) scheme(lean2) ytitle("", /*
*/ size(vsmall)) ylabel(0 .1 .2 .3 .4 .5 .6 .7 .8 .9 1, labsize(vsmall)) /*
*/ xsize(1) ysize(1) name(competence2i, replace)

graph dot econphdcb econdegreecb2 econdegreecb  if cbsample2 == 1, /*
*/ over(country, sort(rank_cbi) label(labsize(vsmall))) /*
*/ title("(c) Central Bankers", size(small) margin(medium)) /*
*/ marker(1, msymbol(O) mcolor(cranberry) msize(medsmall)) /*
*/ marker(2, msymbol(T) mcolor(navy) msize(medsmall)) /*
*/ marker(3, msymbol(S) mcolor(eltgreen) msize(medsmall)) /*
*/ legend(label(1 "Econ Doctorate or PhD") /*
*/ label(2 "Advanced Econ Degree") /*
*/ label(3 "Any Econ Degree") position(6) rows(1)) /*
*/ legend(size(vsmall) region(lcolor(white))) linetype(line) lines(lwidth(thin) /*
*/ lcolor(gs12)) graphregion(color(white)) scheme(lean2) ytitle("", /*
*/ size(vsmall)) ylabel(0 .1 .2 .3 .4 .5 .6 .7 .8 .9 1, labsize(vsmall)) /*
*/ xsize(1) ysize(1) name(competence3i, replace)

grc1leg competence1i competence2i competence3i, legendfrom(competence1i) position(6) ring(100) /*
*/ imargin(wide) scheme(s2mono) graphregion(color(white)) rows(1) name(competence4i, replace) /*
*/ note("Share of Individuals in Office, 1973-2010 (Democratic Period Only)", size(vsmall) position(6) ring(30)) scale(1.1)

** Graph (black and white version) **

graph dot econphdpm econdegreepm2 econdegreepm if pmsample2 == 1, /*
*/ over(country, sort(rank_pmi) label(labsize(vsmall))) /*
*/ title("(a) Leaders", size(small) margin(medium)) /*
*/ marker(1, msymbol(o) mcolor(gs0) msize(medsmall)) /*
*/ marker(2, msymbol(+) mcolor(gs6) msize(medsmall)) /*
*/ marker(3, msymbol(s) mcolor(gs12) msize(medsmall)) /*
*/ legend(label(1 "Econ Doctorate or PhD") /*
*/ label(2 "Advanced Econ Degree") /*
*/ label(3 "Any Econ Degree") position(6) rows(1)) /*
*/ legend(size(vsmall) region(lcolor(white))) linetype(line) lines(lwidth(thin) /*
*/ lcolor(gs12)) graphregion(color(white)) scheme(lean2) ytitle("", /*
*/ size(vsmall)) ylabel(0 .1 .2 .3 .4 .5 .6 .7 .8 .9 1, labsize(vsmall)) /*
*/ xsize(1) ysize(1) name(competence1i_bw, replace)

graph dot econphdfm econdegreefm2 econdegreefm if fmsample2 == 1, /*
*/ over(country, sort(rank_fmi) label(labsize(vsmall))) /*
*/ title("(b) Finance Ministers", size(small) margin(medium)) /*
*/ marker(1, msymbol(o) mcolor(gs0) msize(medsmall)) /*
*/ marker(2, msymbol(+) mcolor(gs6) msize(medsmall)) /*
*/ marker(3, msymbol(s) mcolor(gs12) msize(medsmall)) /*
*/ legend(label(1 "Econ Doctorate or PhD") /*
*/ label(2 "Advanced Econ Degree") /*
*/ label(3 "Any Econ Degree") position(6) rows(1)) /*
*/ legend(size(vsmall) region(lcolor(white))) linetype(line) lines(lwidth(thin) /*
*/ lcolor(gs12)) graphregion(color(white)) scheme(lean2) ytitle("", /*
*/ size(vsmall)) ylabel(0 .1 .2 .3 .4 .5 .6 .7 .8 .9 1, labsize(vsmall)) /*
*/ xsize(1) ysize(1) name(competence2i_bw, replace)

graph dot econphdcb econdegreecb2 econdegreecb  if cbsample2 == 1, /*
*/ over(country, sort(rank_cbi) label(labsize(vsmall))) /*
*/ title("(c) Central Bankers", size(small) margin(medium)) /*
*/ marker(1, msymbol(o) mcolor(gs0) msize(medsmall)) /*
*/ marker(2, msymbol(+) mcolor(gs6) msize(medsmall)) /*
*/ marker(3, msymbol(s) mcolor(gs12) msize(medsmall)) /*
*/ legend(label(1 "Econ Doctorate or PhD") /*
*/ label(2 "Advanced Econ Degree") /*
*/ label(3 "Any Econ Degree") position(6) rows(1)) /*
*/ legend(size(vsmall) region(lcolor(white))) linetype(line) lines(lwidth(thin) /*
*/ lcolor(gs12)) graphregion(color(white)) scheme(lean2) ytitle("", /*
*/ size(vsmall)) ylabel(0 .1 .2 .3 .4 .5 .6 .7 .8 .9 1, labsize(vsmall)) /*
*/ xsize(1) ysize(1) name(competence3i_bw, replace)

grc1leg competence1i_bw competence2i_bw competence3i_bw, legendfrom(competence1i_bw) position(6) ring(100) /*
*/ imargin(wide) scheme(s2mono) graphregion(color(white)) rows(1) name(competence4i_bw, replace) /*
*/ note("Share of Individuals in Office, 1973-2010 (Democratic Period Only)", size(vsmall) position(6) ring(30)) scale(1.1)


********************************************************
** Figure 2: occupational background of PM, FM and CB **
********************************************************

** Summary stats and correlations **

sum econprofpm2 centralbankerpm2 privatefinancepm if pmsample2 == 1
sum econproffm2 centralbankerfm2 privatefinancefm if fmsample2 == 1
sum econprofcb2 centralbankercb2 privatefinancecb if cbsample2 == 1

cor econprofpm2 centralbankerpm2 privatefinancepm if pmsample2 == 1
cor econproffm2 centralbankerfm2 privatefinancefm if fmsample2 == 1
cor econprofcb2 centralbankercb2 privatefinancecb if cbsample2 == 1

** Graph **

graph dot econprofpm2 centralbankerpm2 privatefinancepm if pmsample2 == 1, /*
*/ over(country, sort(rank_pmip) label(labsize(vsmall))) /*
*/ title("(a) Leaders", size(small) margin(medium)) /*
*/ marker(1, msymbol(O) mcolor(cranberry) msize(medsmall)) /*
*/ marker(2, msymbol(T) mcolor(navy) msize(medsmall)) /*
*/ marker(3, msymbol(S) mcolor(eltgreen) msize(medsmall)) /*
*/ legend(label(1 "Economics Professor") /*
*/ label(2 "Central Banking") /*
*/ label(3 "Financial Services") position(6) rows(1)) /*
*/ legend(size(vsmall) region(lcolor(white))) linetype(line) lines(lwidth(thin) /*
*/ lcolor(gs12)) graphregion(color(white)) scheme(lean2) ytitle("", /*
*/ size(vsmall)) ylabel(0 .1 .2 .3 .4 .5 .6 .7 .8 .9 1, labsize(vsmall)) /*
*/ xsize(1) ysize(1) name(competence1ip, replace)

graph dot econproffm2 centralbankerfm2 privatefinancefm if fmsample2 == 1, /*
*/ over(country, sort(rank_fmip) label(labsize(vsmall))) /*
*/ title("(b) Finance Ministers", size(small) margin(medium)) /*
*/ marker(1, msymbol(O) mcolor(cranberry) msize(medsmall)) /*
*/ marker(2, msymbol(T) mcolor(navy) msize(medsmall)) /*
*/ marker(3, msymbol(S) mcolor(eltgreen) msize(medsmall)) /*
*/ legend(label(1 "Economics Professor") /*
*/ label(2 "Central Banking") /*
*/ label(3 "Financial Services") position(6) rows(1)) /*
*/ legend(size(vsmall) region(lcolor(white))) linetype(line) lines(lwidth(thin) /*
*/ lcolor(gs12)) graphregion(color(white)) scheme(lean2) ytitle("", /*
*/ size(vsmall)) ylabel(0 .1 .2 .3 .4 .5 .6 .7 .8 .9 1, labsize(vsmall)) /*
*/ xsize(1) ysize(1) name(competence2ip, replace)

graph dot econprofcb2 centralbankercb2 privatefinancecb if cbsample2 == 1, /*
*/ over(country, sort(rank_cbip) label(labsize(vsmall))) /*
*/ title("(c) Central Bankers", size(small) margin(medium)) /*
*/ marker(1, msymbol(O) mcolor(cranberry) msize(medsmall)) /*
*/ marker(2, msymbol(T) mcolor(navy) msize(medsmall)) /*
*/ marker(3, msymbol(S) mcolor(eltgreen) msize(medsmall)) /*
*/ legend(label(1 "Economics Professor") /*
*/ label(2 "Central Banking") /*
*/ label(3 "Financial Services") position(6) rows(1)) /*
*/ legend(size(vsmall) region(lcolor(white))) linetype(line) lines(lwidth(thin) /*
*/ lcolor(gs12)) graphregion(color(white)) scheme(lean2) ytitle("", /*
*/ size(vsmall)) ylabel(0 .1 .2 .3 .4 .5 .6 .7 .8 .9 1, labsize(vsmall)) /*
*/ xsize(1) ysize(1) name(competence3ip, replace)

grc1leg competence1ip competence2ip competence3ip, legendfrom(competence1ip) position(6) ring(100) /*
*/ imargin(wide) scheme(s2mono) graphregion(color(white)) rows(1) name(competence4ip, replace) /*
*/ note("Share of Individuals in Office, 1973-2010 (Democratic Period Only)", size(vsmall) position(6) ring(30)) scale(1.1)

** Graph (black and white version) **

graph dot econprofpm2 centralbankerpm2 privatefinancepm if pmsample2 == 1, /*
*/ over(country, sort(rank_pmip) label(labsize(vsmall))) /*
*/ title("(a) Leaders", size(small) margin(medium)) /*
*/ marker(1, msymbol(o) mcolor(gs0) msize(medsmall)) /*
*/ marker(2, msymbol(+) mcolor(gs6) msize(medsmall)) /*
*/ marker(3, msymbol(s) mcolor(gs12) msize(medsmall)) /*
*/ legend(label(1 "Economics Professor") /*
*/ label(2 "Central Banking") /*
*/ label(3 "Financial Services") position(6) rows(1)) /*
*/ legend(size(vsmall) region(lcolor(white))) linetype(line) lines(lwidth(thin) /*
*/ lcolor(gs12)) graphregion(color(white)) scheme(lean2) ytitle("", /*
*/ size(vsmall)) ylabel(0 .1 .2 .3 .4 .5 .6 .7 .8 .9 1, labsize(vsmall)) /*
*/ xsize(1) ysize(1) name(competence1ip_bw, replace)

graph dot econproffm2 centralbankerfm2 privatefinancefm if fmsample2 == 1, /*
*/ over(country, sort(rank_fmip) label(labsize(vsmall))) /*
*/ title("(b) Finance Ministers", size(small) margin(medium)) /*
*/ marker(1, msymbol(o) mcolor(gs0) msize(medsmall)) /*
*/ marker(2, msymbol(+) mcolor(gs6) msize(medsmall)) /*
*/ marker(3, msymbol(s) mcolor(gs12) msize(medsmall)) /*
*/ legend(label(1 "Economics Professor") /*
*/ label(2 "Central Banking") /*
*/ label(3 "Financial Services") position(6) rows(1)) /*
*/ legend(size(vsmall) region(lcolor(white))) linetype(line) lines(lwidth(thin) /*
*/ lcolor(gs12)) graphregion(color(white)) scheme(lean2) ytitle("", /*
*/ size(vsmall)) ylabel(0 .1 .2 .3 .4 .5 .6 .7 .8 .9 1, labsize(vsmall)) /*
*/ xsize(1) ysize(1) name(competence2ip_bw, replace)

graph dot econprofcb2 centralbankercb2 privatefinancecb if cbsample2 == 1, /*
*/ over(country, sort(rank_cbip) label(labsize(vsmall))) /*
*/ title("(c) Central Bankers", size(small) margin(medium)) /*
*/ marker(1, msymbol(o) mcolor(gs0) msize(medsmall)) /*
*/ marker(2, msymbol(+) mcolor(gs6) msize(medsmall)) /*
*/ marker(3, msymbol(s) mcolor(gs12) msize(medsmall)) /*
*/ legend(label(1 "Economics Professor") /*
*/ label(2 "Central Banking") /*
*/ label(3 "Financial Services") position(6) rows(1)) /*
*/ legend(size(vsmall) region(lcolor(white))) linetype(line) lines(lwidth(thin) /*
*/ lcolor(gs12)) graphregion(color(white)) scheme(lean2) ytitle("", /*
*/ size(vsmall)) ylabel(0 .1 .2 .3 .4 .5 .6 .7 .8 .9 1, labsize(vsmall)) /*
*/ xsize(1) ysize(1) name(competence3ip_bw, replace)

grc1leg competence1ip_bw competence2ip_bw competence3ip_bw, legendfrom(competence1ip_bw) position(6) ring(100) /*
*/ imargin(wide) scheme(s2mono) graphregion(color(white)) rows(1) name(competence4ip, replace) /*
*/ note("Share of Individuals in Office, 1973-2010 (Democratic Period Only)", size(vsmall) position(6) ring(30)) scale(1.1)


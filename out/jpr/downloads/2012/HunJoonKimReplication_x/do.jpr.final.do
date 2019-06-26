set more off
use k:\jpr\jpr.data.final.dta, clear

*** Declare survival dataset
stset t2, failure(trt==1) id(cowid) exit(t2=27)

*** Check for multicollinearity
corr rupt lhrngo unpko rrprecl reg2precl ///
	polity2 pol2t2 sdnew inthrcom legbrit ppros laleng fhclp coup lpcoup altmeas lgdppc gdpgrth

*** Summary statistics
sum t2 rupt lhrngo unpko rrprecl reg2precl ///
	polity2 pol2t2 sdnew inthrcom legbrit ppros laleng fhclp coup lpcoup altmeas lgdppc gdpgrth

de t2 rupt lhrngo unpko rrprecl reg2precl ///
	polity2 pol2t2 sdnew inthrcom legbrit ppros laleng fhclp coup lpcoup altmeas lgdppc gdpgrth

*** Check PH assumption
quietly stcox rupt lhrngo unpko rrprecl reg2precl ///
	polity2 pol2t2 sdnew inthrcom legbrit ppros laleng fhclp ///
	coup lpcoup altmeas lgdppc gdpgrth, efron nolog cluster(cowid) strata(sequence) ///
	mgale(mg) schoenfeld(sc*) scale(ssc*)
linktest, efron cluster(cowid) strata(sequence) nolog
stphtest, detail

*** Analysis
*** Model 1
stcox rupt lhrngo unpko rrprecl reg2precl ///
	polity2 pol2t2 sdnew inthrcom legbrit ppros laleng fhclp ///
	coup lpcoup altmeas lgdppc gdpgrth, efron nolog nohr cluster(cowid) strata(sequence)

*** Model 2 
stcox rupt ruptt lhrngo unpko rrprecl reg2precl ///
	polity2 pol2t2 sdnew inthrcom legbrit ppros laleng fhclp ///
	coup lpcoup altmeas lgdppc gdpgrth, efron nolog nohr cluster(cowid) strata(sequence)

*** Model 3
stset t2, failure(hitrt==1) id(cowid) exit(t2=27)
stcox rupt lhrngo unpko rrprecl reg2precl ///
	polity2 pol2t2 sdnew inthrcom legbrit ppros laleng fhclp ///
	coup lpcoup altmeas lgdppc gdpgrth, efron nolog nohr cluster(cowid) strata(hisequence)

*** Model 4
stset t2, failure(lotrt==1) id(cowid) exit(t2=27)
stcox rupt lhrngo unpko rrprecl reg2precl ///
	polity2 pol2t2 sdnew inthrcom legbrit ppros laleng fhclp ///
	coup lpcoup altmeas lgdppc gdpgrth, efron nolog nohr cluster(cowid) strata(losequence)

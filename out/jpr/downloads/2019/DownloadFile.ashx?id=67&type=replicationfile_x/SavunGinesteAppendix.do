use "SavunGinesteFinal.dta"


*** A1: Descriptive Statistics ***
summarize killedbin sexualvbin torturebin beatingbin shootingbin forcedremovalbin extortionbin destconfiscbin harassbin


*** A2: Ordered Logistic: Gov Violence against Refugees *** 
ologit prevalencefinal transnationalterrorism physintimpute lngdppc icrg_bq_l lnrefpopties percentrefpop 


*** A3: Rare-events Logistic: State Lethal Violence against Refugees *** 
relogit killedbin transnationalterrorism lngdppc democracybin lnrefpopexcluded icrg_bq_l percentrefpop, cluster(ccode)


*** A4: Ordered Logistic: State Violence against Refugees *** 
ologit indexviolence transnationalterrorism lngdppc democracybin lnrefpopexcluded icrg_bq_l percentrefpop, cluster(ccode)


*** A5: Ordered Logistic: State Violence against Refugees *** 
ologit prevalencefinal transnationalterrorism ethnicfrac changerefugee ///
	nafme asia ssafrica lamerica eeurop ///
	lngdppc democracybin lnrefpopexcluded icrg_bq_l percentrefpop treaty, cluster(ccode)

	
*** A6: Ordered Logistic: State Violence against Refugees *** 
ologit  prevalencefinal transnationalterrorism templag prevalencefinallag ///
	lngdppc democracybin unemployment lnrefpopexcluded icrg_bq_l percentrefpop, cluster(ccode)
	

*** A7: Ordered Logistic: State Violence against Refugees *** 
ologit  prevalencefinal transnationalterrorism templag prevalencefinallag terrorismneighbor ///
	lngdppc democracybin unemployment lnrefpopexcluded icrg_bq_l percentrefpop, cluster(ccode)

	
*** A8: Ordered Logistic: State Violence against Refugees *** 
ologit prevalencefinal transnationalterrorism refrivalperc100 ///
	lngdppc democracybin lnrefpopexcluded icrg_bq_l percentrefpop, cluster(ccode)
	
	
clear

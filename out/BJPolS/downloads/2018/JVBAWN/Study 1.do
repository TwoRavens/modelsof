********************************************************************************
********************************************************************************
******** Are All "Birthers" Conspiracy Theorists?: On the Relationship ********* 
********** Between Conspiratorial Thinking and Political Orientations **********
********************************************************************************
********************************************************************************
************ Adam M. Enders, Steven M. Smallpage, Robert N. Lupton *************
********************************************************************************
********************************************************************************

* Replication file for Study 1

* Open "2012 ANES.dta"


********************************************************************************

*** Cleaning data and creating relevant variables ***

* Case ID
gen id = caseid


* Survey mode (1=internet)
gen internet = mode - 1


* Was Obama born in the U.S.?
gen born = nonmain_born - 1 
replace born = . if born < 0


* Does Obamacare authorize death panels?
gen endlife = nonmain_endlife
replace endlife = . if endlife < 1
recode endlife (1=3) (2=2) (3=1) (4=0)


* Did government officials know about September 11, 2001 before it happened?
gen gov911 = nonmain_govt911
replace gov911 = . if gov911 < 1
recode gov911 (1=3) (2=2) (3=1) (4=0)


* Did government intentionally breach flood levees during Katrina?
gen levees = nonmain_hurric
replace levees = . if levees < 1
recode levees (1=3) (2=2) (3=1) (4=0)


* Party identification pid_self
gen pid = pid_x - 4
replace pid = . if pid < -3

gen rep = 1 if pid > 0
replace rep = 0 if pid < 0


* President feeling thermometers
gen obamatherm = ft_dpc
replace obamatherm = . if obamatherm < 0

gen bushtherm = ft_gwb
replace bushtherm = . if bushtherm < 0


********************************************************************************		
				
*** Empirical analyses ***

* Examine distributions (Figure 1)
twoway (hist born if rep == 1) (hist born if rep == 0)
twoway (hist endlife if rep == 1) (hist endlife if rep == 0)
twoway (hist gov911 if rep == 1) (hist gov911 if rep == 0)
twoway (hist levees if rep == 1) (hist levees if rep == 0)


* Confirmatory factor analysis (Table 1)
sem (Con PMR -> born endlife gov911 levees) ///
	(PMR -> pid@1 bushtherm obamatherm), ///
	latent(Con PMR) standardized nocapslatent cov(PMR*Con@0 ///
	e.obamatherm*e.bushtherm e.obamatherm*e.pid e.bushtherm*e.pid)
estat gof, stats(all)


********************************************************************************		

*** Supplemental Appendix ***

* Correlations between conspiracy belief questions (Table A1)
pwcorr born-levees, sig

* Exploratory factor analysis using IPF (Table A2)
factor born-levees, ipf
scree	

 



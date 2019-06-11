* Replication File for "Defense Pacts:  A Prescription for Peace?"
* 07/13/10

use "E:\Jesse's Documents\Defense Pacts\FPA\Johnson Leeds 2010 FPA rep\Johnson and Leeds 2010 FPA.dta", clear

set more off

******************************
*** Descriptive Statistics ***
******************************

tab dispute

tab ptargdef
tab pchalally
tab pchaloff
tab pchalneu

tab ptargdef_secr if dispute==1

tab targ_resist if dispute==1
tab war if dispute==1

***************
*** Table 1 ***
***************

probit dispute ptargdef pchalally pchaloff pchalneu ln_distance capprop jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3 

*********************************
*** Table 1 Robustness Checks ***
*********************************
	
	* Including Secret Alliances
		
		probit dispute ptargdef_secr pchalally pchaloff pchalneu ln_distance contig capprop jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3

	* Dropping directed dyads in which both states are members of the same defensive alliance from the sample
	
		probit dispute ptargdef pchalally pchaloff pchalneu ln_distance capprop jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3 if defense_ally==0

	* Coding all directed dyads in which both states are members of the same defensive alliance as having no allies committed to defending them
	
		gen n_ptargdef=ptargdef
		recode n_ptargdef(1=0) if defense_ally==1

		probit dispute n_ptargdef pchalally pchaloff pchalneu ln_distance capprop jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3

		capture drop n_ptargdef
		
	* Controlling for shared defensive alliance membership

		probit dispute ptargdef pchalally pchaloff pchalneu ln_distance capprop jdem s_un_glo defense_ally peaceyrs peaceyrs2 peaceyrs3

	* Evaluating Post-Treatment Bias
	
		probit dispute pchalally ln_distance capprop jdem peaceyrs peaceyrs2 peaceyrs3
		
		probit dispute pchalally ln_distance jdem peaceyrs peaceyrs2 peaceyrs3
	
		probit dispute pchalally ln_distance peaceyrs peaceyrs2 peaceyrs3
		
		probit dispute pchalally peaceyrs peaceyrs2 peaceyrs3

	* Evaluating the effect of "large alliances"
	
		capture drop exclude
		gen exclude=0

		* NATO
			replace exclude=1 if  t_def_atopid1>3180 & t_def_atopid1<3181 & t_def_atopid2==.

		* Arab Collective Defense

			replace exclude=1 if t_def_atopid1==3205 & t_def_atopid2==.

		* OAS

			replace exclude=1 if t_def_atopid1==3150 & t_def_atopid2==.
		
		* Rio Pact

			replace exclude=1 if t_def_atopid1==3075 & t_def_atopid2==.
			
		* OAS & Rio Pact

			replace exclude=1 if t_def_atopid1==3075 & t_def_atopid2==3150 & t_def_atopid3==.
			
		* Excluding "large" alliances
		
			probit dispute ptargdef pchalally pchaloff pchalneu ln_distance capprop jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3 if exclude==0

			capture drop exclude

	* Including contiguity
	
		probit dispute ptargdef pchalally pchaloff pchalneu ln_distance contig capprop jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3
		
***************
*** Table 2 ***
***************

heckprob targ_resist ptargdef_secr pchaloff pchalneu capprop, select(dispute=ptargdef pchaloff pchalneu pchalally ln_distance capprop jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3)

*********************************
*** Table 2 Robustness Checks ***
*********************************

	* Removing secret alliances
	
		heckprob targ_resist ptargdef pchaloff pchalneu capprop, select(dispute=ptargdef pchaloff pchalneu pchalally ln_distance capprop jdem s_un_glo peaceyrs 		peaceyrs2 peaceyrs3)

	* Including each identifying variable in turn
	
		heckprob targ_resist ptargdef_secr pchaloff pchalneu capprop pchalally, select(dispute=ptargdef pchaloff pchalneu pchalally ln_distance capprop jdem s_un_glo peaceyrs 		peaceyrs2 peaceyrs3)

		heckprob targ_resist ptargdef_secr pchaloff pchalneu capprop ln_distance, select(dispute=ptargdef pchaloff pchalneu pchalally ln_distance capprop jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3)

		heckprob targ_resist ptargdef_secr pchaloff pchalneu capprop s_un_glo, select(dispute=ptargdef pchaloff pchalneu pchalally ln_distance capprop jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3)

		heckprob targ_resist ptargdef_secr pchaloff pchalneu capprop jdem, select(dispute=ptargdef pchaloff pchalneu pchalally ln_distance capprop jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3)
	
***************
*** Table 3 ***
***************

heckprob war ptargdef_secr pchaloff pchalneu capprop, select(dispute=ptargdef pchaloff pchalneu pchalally ln_distance capprop jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3)

*********************************
*** Table 3 Robustness Checks ***
*********************************

	* Removing secret alliances
	
		heckprob war ptargdef pchaloff pchalneu capprop, select(dispute=ptargdef pchaloff pchalneu pchalally ln_distance capprop jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3)
	
	* Including each identifying variable in turn
	
		heckprob war ptargdef_secr pchaloff pchalneu capprop pchalally, select(dispute=ptargdef pchaloff pchalneu pchalally ln_distance capprop jdem s_un_glo peaceyrs 		peaceyrs2 peaceyrs3)

		heckprob war ptargdef_secr pchaloff pchalneu capprop ln_distance, select(dispute=ptargdef pchaloff pchalneu pchalally ln_distance capprop jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3)

		heckprob war ptargdef_secr pchaloff pchalneu capprop s_un_glo, select(dispute=ptargdef pchaloff pchalneu pchalally ln_distance capprop jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3)

		heckprob war ptargdef_secr pchaloff pchalneu capprop jdem, select(dispute=ptargdef pchaloff pchalneu pchalally ln_distance capprop jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3)
		
		exit
		
****************
*** Figure 1 ***
****************

estsimp probit dispute ptargdef pchaloff pchalneu pchalally ln_distance capprop jdem s_un_glo peaceyrs peaceyrs2 peaceyrs3

	setx mean if ptargdef==0
	setx ptargdef 0

	simqi, prval(1) genpr (nodef)
	
	_pctile nodef, p(7.5,97.5)
	replace nodef =. if nodef < r(r1) | nodef > r(r2)
	summarize nodef

	setx mean if ptargdef==0
	setx ptargdef 1

	simqi, prval(1) genpr (def)
	
	_pctile def, p(7.5,97.5)
	replace def =. if def < r(r1) | def > r(r2)
	summarize def

	gen def_change = ((def-nodef)/nodef)*100
	sum def_change
	
	twoway hist def, frequency ||hist nodef, ysc(on) frequency xlabel(0 .0005 .001) xtitle("Pr(Dispute Initiation)") ylabel(0 20 40 60) ytitle(Frequency) scheme(s2mono) 
	
	capture drop def nodef def_change

******************************************
*** Capability Ratio Percentage Change ***
******************************************

	setx mean if capprop==.5
	setx capprop .25

	simqi, prval(1) genpr (weak)


	setx mean if capprop==.5
	setx capprop .5

	simqi, prval(1) genpr (strong)

	
	gen cap_change = ((weak-strong)/strong)*100
	sum cap_change
	
	drop cap_change weak strong

	
*****************************************
*** Joint Democracy Percentage Change ***
*****************************************

	setx mean if jdem==0
	setx jdem 0

	simqi, prval(1) genpr (nojdem)


	setx mean if jdem==0
	setx jdem 1

	simqi, prval(1) genpr (yesjdem)

	
	gen dem_change = ((yesjdem-nojdem)/nojdem)*100
	sum dem_change
	
	drop dem_change nojdem yesjdem
	

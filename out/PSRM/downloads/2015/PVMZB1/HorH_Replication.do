
program drop _all
capture log close
set more off
clear mata
clear matrix
clear


/*log command: change directory and input date as appropriate*/
log using "D:\Projects\FallingOutofFavor\FOOF P(Fail)\PSRMRnR\Replication\Logs\HorH_Replication_11_24_14.log", append

set matsize 1000
set maxvar 10000
set scheme s1mono

/*directory command:  change directory path as appropriate*/
cd "D:\Projects\FallingOutofFavor\FOOF P(Fail)\PSRMRnR\Replication"

*PURPOSE:	This file will replicate the tables of stratified Cox models, and Figures 1-4
*			from "Hazards or Hassles: the Effect of Sanctions on Leader Survival."
*AUTHOR:	Amanda A. Licht, Binghamton University
*MACHINE:	LICHTBINGOFFICE, lenovo desktop running StataMP13									
*DATE:		11/20/14	
*	MODIFIED:									
*DATA:		HorH_ReplicationData.dta	
*	SOURCES:	Bond et al. 2003, Integrated Data for Events Analysis
*			Goemans et al. 2009, Archigos
*			Licht 2014, Regular Turnover Details 
*			Haege 2011, Foreign Policy Similarity
*			Henisz 2000, 2002, POLCON III and V
*			Beck et al. 2000, Database of Political Institutions
*			Morgan et al. 2009, TIES
*			Wright 2008, Authoritarian legislatures and Geddes regime types
*			Barbieri and Keck 2010, COW Trade
*			Gleditsch, Expanded trade and GDP
*			Ghosn, Palmer and Bremer 2004, MID310
*			Wallensteen et al. 2010, Uppsala/PRIO Armed Conflict
*			Shatterbelt Regional Data, Hensel and Diehl (1994) 
*           PolityIV, Marshall and Jaggers (2009)                            
*           Polyarchy Data, Vanhanen (2000)  
*           Logic of Political Survival, BDM2S2     (2004) 
*			oil and gas data, Humphries 
*			COW Alliances 4.0, Gibler
*			Authoritarian Breakdown, Geddes, Wright and Franz 	
*			Assassinations, Iqbal and Zorn (2008)					
*FILE:	HorH_Replication.do										
*LOG:	HorH_Replication_MM_DD_YY.log								
*OUTPUT:	
*	Data:	HorH_ReplicationAnalysisData.dta	- Original ReplicationData plus calculated 
*												survivor probabilities and combined coefficients
*
*	Graphs:	Fig 1 Matched Observation by Regime Type 	
*						- box plots of balance on lagged linear 
*						  index of Wfail and MID targeting with 
*						  a panel for each regime type 
*			Fig 2 Recovered Baseline Hazards by Subclass and Targeting
*						- Survivor curves plotted across six 
*						  panels by regime type and target
*			Fig 3 Combined Coefficient of Sanctions over Tenure and Oil Production
*						- scatter plot, lowess smoothed curves, and rug plot of density for
*						  combined coefficients generated using lincom utility over lag
*						  of oil production and 5 values of tenure for autocratic leaders
*			Fig 4 Comparing Risks of Targeted Leaders by Type of Disputes
*						- dot plot of combined coefficients generated using lincom utiltiy
*						  comparing the effect of sanctions and threats that arise due to 
*						  trade to those that arise due to more "strategic" issues, such as 
*						  military/political alignment. Three panels, one for each regime type.
*
*	Tables:	Table5.txt		- stratified cox models for dems matched on Lxb and MID
*										three models:  stripped down, with controls, with subregime
*										interactions with sanction and threat
*			Table6.txt		- stratified cox models for mixed matched on Lxb 
*										two models:  stripped down, with controls
*			Table7.txt		- stratified cox models for autos matched on Lxb and Alliance Ties
*										three models:  stripped down, with controls, with oil
*										interacted with sanction and threat		
*			TableA17		- stratified cox models across regime type interacting threat and 
*								sanction with dummies that differentiate years where issues over 
*								which the leader is sanctioned/threatened are all trade-based
*								(alltrade) or never trade-based (notrade). These dummies are
*								inherently interactions with sanction/threat indicators, and so
*								indicate the difference in effect when the slate of issues is
*								all trade or no trade compared to cases where it is mixed. 	



use Data/HorH_ReplicationData.dta, clear




**************************************************
*Box plots to illustrate balance in matched sets
**************************************************

#delimit ;
graph box Lxb if Dems_subclass~=., 
	over(MIDtopsanctionerever, relabel(1 "No MID" 2 "MID") 
		label(labcolor(black) labsize(vsmall)))  
	over(target, relabel(1 "No" 2 "Yes") 
		label(labcolor(black) labsize(vsmall) angle(forty_five))) 
	over(Dems_subclass, relabel(1 "Subclass: 1" 2 "2" 3 "3")
		label(labsize(tiny)  angle(forty_five)))
	ytitle("Linear Index of Ex Ante P(Failure)") 
	title("Democratic Leaders", size(small))
legend(cols(1) symxsize(small) symysize(small) 
		 size(vsmall) ring(0) pos(11))
name(demsp2, replace)	;

#delimit ;
graph box Lxb defenseweight if Autos_Ally_subclass~=., 
	over(target, relabel(1 "No" 2 "Yes") 
		label(labcolor(black) labsize(vsmall) angle(forty_five))) 
	over(Autos_Ally_subclass, relabel(1 "Subclass: 1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "6")
		label(labsize(tiny)  angle(forty_five)))  
	ytitle("Linear Index of Ex Ante P(Failure)/Defense Pact Weight") 
	title("Autocratic Leaders", size(small))
	legend(order(1 "Ex Ante P(fail)" 2 "Defense Pacts Index") cols(1) symxsize(small) symysize(small) 
			size(vsmall) ring(0) pos(5))
name(autsp2, replace);	


#delimit ;
graph box Lxb if Anos_subclass~=., 
	over(target, relabel(1 "No" 2 "Yes") 
		label(labcolor(black) labsize(vsmall) angle(forty_five))) 
	over(Anos_Justxb_subclass,relabel(1 "Subclass: 1" 2 "2" 3 "3" 4 "4" 5 "5")
		label(labsize(tiny)  angle(forty_five) ))  
	ytitle("Linear Index of Ex Ante P(Failure)") 
	title("Anocratic Leaders", size(small))
legend(off)	
name(anosp2, replace);

#delimit ;
graph combine demsp2 autsp2 anosp2, title("Figure 1. Matched Observations by Regime Type", size(medium)) rows(1)
	note("NOTE:  Observations matched using the scheme which best balanced on ex ante risks. For democrats this includes an interaction with history"
		"of conflict with top sanctioning states; for autocrats, an interaction with dfense ties to top sanctioners; for mixed regimes, no interactions."
		"For all panels above 'no' indicates control cases and 'yes' cases which were targeted with sanctions or threats. All matching performed using"
		"nearest neighbor, subclassification via MatchIt (Ho et al. 2011). Regime type classified by cutpoints in polity2:  democratic, greater than 5;"
		"mixed, 5 to -5; autocratic, less than -5. ", size(vsmall) span)	
saving("Graphs/Fig1 Box Plots of Matched Cases Lxb.gph", replace);
#delimit cr


********************************************
********************************************
*Display leaders across subclasses for 
*selected countries, as listed in Table 4
********************************************
********************************************


tab leader Autos_Ally_subclass  if country=="UAE"
tab leader Autos_Ally_subclass 	if country=="Argentina"
tab leader Autos_Ally_subclass  if country=="Nigeria"
tab leader Autos_Ally_subclass 	if country=="China"
tab leader Autos_Ally_subclass  if country=="Turkey"
tab leader Autos_Ally_subclass 	if country=="Germany East"


********************************************
********************************************
*Run Models of Democratic Leaders
********************************************
********************************************

keep if Dems_subclass~=.

stset sumten, fail(wfail2) id(numid)

#delimit ;
stcox sanction threat 
	parliamentarydem 
	LMIDtarget ,
	bases(Sdems)  strata(Dems_subclass)
	cluster(ccode) nohr;
outreg2 using Tables/Table5.txt, dec(3) stats(coef se) alpha(.01, .05, .10) replace;
#delimit cr	


#delimit ;
stcox sanction threat 
	parliamentarydem 
	LMIDtarget 
	LGrgdpch Lrgdpch Llimports 
	demos strikes partyfrac_sc 
	infinter lnt_infinter,
	strata(Dems_subclass)
	robust nohr;
outreg2 using Tables/Table5.txt, dec(3) stats(coef se) alpha(.01, .05, .10) append;
#delimit cr	
	

#delimit ;
stcox sanction threat 
	parliamentarydem parl_sanction parl_threat
	LMIDtarget 
	LGrgdpch Lrgdpch Llimports 
	demos strikes partyfrac_sc 
	infinter lnt_infinter,
	strata(Dems_subclass)
	cluster(ccode) nohr;
outreg2 using Tables/Table5.txt, dec(3) stats(coef se) alpha(.01, .05, .10) append;
#delimit cr	


*Graph recovered surivor curves.

sum yearsinoffice, detail

#delimit ;
twoway (line Sdems yearsinoffice if Dems_subclass==1&yearsinoffice<=15, sort lcolor(black) lp(tight_dot))
		(line Sdems yearsinoffice if Dems_subclass==2&yearsinoffice<=15, sort lcolor(gs4) lp(shortdash_dot))
		(line Sdems yearsinoffice if Dems_subclass==3&yearsinoffice<=15, sort lcolor(gs6) lp(solid)),
			xtitle("Years in Office")
			ytitle("Probability of Survival")
		by(target,	title("Democratic Sample", size(medium))
			legend(off)
			note("") )
name(demS, replace);
#delimit cr

save Data/HorH_ReplicationAnalysisData.dta, replace



********************************************
********************************************
*Run Models of Anocratic Leaders
********************************************
********************************************


use Data/HorH_ReplicationData.dta, clear

keep if Anos_subclass~=.

stset sumten, fail(wfail2) id(numid)

#delimit;
stcox sanction threat,
	bases(Sanos)  strata(Anos_Justxb_subclass)
	nohr robust;
outreg2 using Tables/Table6.txt, dec(3) stats(coef se) alpha(.01, .05, .10) replace;	
#delimit cr


#delimit;
stcox sanction threat
	LMIDtarget
	LGrgdpch Lrgdpch Llimports 
	demobin strikebin
	L_PRODUCTION,
	strata(Anos_Justxb_subclass)
	nohr cluster(ccode);
outreg2 using Tables/Table6.txt, dec(3) stats(coef se) alpha(.01, .05, .10) append;	
#delimit cr

sum yearsinoffice, detail
#delimit ;
twoway (line Sanos yearsinoffice if Anos_Justxb_subclass==1&yearsinoffice<=20, sort lcolor(black) lp(tight_dot))
		(line Sanos yearsinoffice if Anos_Justxb_subclass==2&yearsinoffice<=20, sort lcolor(gs4) lp(shortdash_dot))
		(line Sanos yearsinoffice if Anos_Justxb_subclass==3&yearsinoffice<=20, sort lcolor(gs6) lp(solid))
		(line Sanos yearsinoffice if Anos_Justxb_subclass==4&yearsinoffice<=20, sort lcolor(gs8) lp(dash))
		(line Sanos yearsinoffice if Anos_Justxb_subclass==5&yearsinoffice<=20, sort lcolor(gs10) lp(vshortdash)),
			xtitle("Years in Office")
			ytitle("")
		by(target,	title("Mixed Regime Sample", size(medium))
			legend(off)
			note("" ))
name(anoS, replace);
#delimit cr

append using Data/HorH_ReplicationAnalysisData.dta
save Data/HorH_ReplicationAnalysisData.dta, replace



********************************************
********************************************
*Run Models of Autocratic Leaders
********************************************
********************************************

use Data/HorH_ReplicationData.dta, clear

keep if Autos_Ally_subclass~=.

stset sumten, fail(wfail2) id(numid)

	
#delimit ;
stcox sanction threat 
	LMIDtarget ,
	 strata(Autos_Ally_subclass)
	cluster(ccode) nohr;
outreg2 using Tables/Table7.txt, dec(3) stats(coef se) alpha(.01, .05, .10) replace;
#delimit cr	


#delimit ;
stcox  sanction lnt_sanction L_PROD_sanction L_PROD2_sanction threat
	geddes_personal 
	LMIDtarget 
	Lrgdpch LrgdpchOil Llimports Llimports2
	demobin Lcoupsucc
	L_PRODUCTION  L_PRODUCTION2 L_DIAMONDS,
	bases(Sautos) strata(Autos_Ally_subclass)
	cluster(ccode) nohr;
outreg2 using Tables/Table7.txt, dec(3) stats(coef se) alpha(.01, .05, .10) append;	
#delimit cr		

*Graph Survivor Curves
sum yearsinoffice, detail
#delimit ;
twoway (line Sautos yearsinoffice if Autos_Ally_subclass==1&yearsinoffice<=20, sort lcolor(black) lp(tight_dot))
		(line Sautos yearsinoffice if Autos_Ally_subclass==2&yearsinoffice<=20, sort lcolor(gs4) lp(shortdash_dot))
		(line Sautos yearsinoffice if Autos_Ally_subclass==3&yearsinoffice<=20, sort lcolor(gs6) lp(solid))
		(line Sautos yearsinoffice if Autos_Ally_subclass==4&yearsinoffice<=20, sort lcolor(gs8) lp(dash))
		(line Sautos yearsinoffice if Autos_Ally_subclass==5&yearsinoffice<=20, sort lcolor(gs10) lp(vshortdash))
		(line Sautos yearsinoffice if Autos_Ally_subclass==6&yearsinoffice<=20, sort lcolor(gs12) lp(solid)),
			xtitle("Years in Office")
			ytitle("")
		by(target,	title("Autocratic Sample", size(medium))
			legend(off)
			note("") )
name(autoS, replace);


*Combine all three survivor plots to form Figure2 2
#delimit ;
graph combine demS anoS autoS, rows(1)
	title("Figure 2. Recovered Baseline Hazards" "by Subclass and Targeting", size(medium))
	note("NOTE: Subclass rank increases as shade of gray lightens.Survivor functions derived via the stratified Cox models reported in Tables 5-7.",
		size(vsmall) span)
		scheme(s1mono)
saving("Graphs/Figure 2 Recovered Basline Hazards across Regime Types.gph", replace);
#delimit cr


*Generate combined coefficient of sanctions across tenure and oil production

gen CC_Sanction2 	= _b[sanction]*sanction + _b[lnt_sanction]*lnt + _b[L_PROD_sanction]*L_PRODUCTION + _b[L_PROD2_sanction]*L_PRODUCTION2


mat def V = e(V)	/*preserve variance matrix so that next command can call up its elements*/


*Calculate standard error of the combined coefficient
#delimit ;
gen CC_Sanction2_se 	=sqrt(V[1,1] + V[2,2]*lnt^2 + V[3,3]*L_PRODUCTION2 + V[4,4]*L_PRODUCTION2^2 
									+ 2*lnt*V[1,2] + 2*L_PRODUCTION*V[1,3] + 2*L_PRODUCTION2*V[1,4]);
#delimit cr

*Generate 95% CIs around the combined coefficient
gen CC_Sanction2_lo = CC_Sanction2 - 1.96*CC_Sanction2_se
gen CC_Sanction2_hi = CC_Sanction2 + 1.96*CC_Sanction2_se
	
	

gen pipe = "|"					/*make symbol for rug plot*/
gen where = -220				/*make yaxis location for rug plot*/


*generate and describe quintiles of autocratic time in office
xtile LNTQUINT = lnt, n(5)
bysort LNTQUINT: sum yearsinoffice
	lab def LNTDEF 1 "Up to 4 Years" 2 "Up to 7 Years" 3 "Up to 12 Years" 4 "Up to 19 Years" 5 "Up to 45 Years"
	lab val LNTQUINT LNTDEF

	*label everything associated with this graph
	lab var CC_Sanction2 "Combined Coef of Sanction from model w/quadratic interaction"
	lab var where "Placer for rug plot on CC_Sanction2 graph"
	lab var pipe "Rug plot symbol"

	
*Graph combined coefficient across quintiles of survival time and oil production
#delimit ;
twoway 	(scatter CC_Sanction2 L_PRODUCTION, sort ms(oh) msize(medium) mc(gs8))
		(lowess CC_Sanction2 L_PRODUCTION, sort lc(black) lw(thin)
				yline(0, lc(gs8) lp(dash)))
		(lowess CC_Sanction2_lo L_PRODUCTION, sort lc(gs10) lw(vthin))
		(lowess CC_Sanction2_hi L_PRODUCTION, sort lc(gs10) lw(vthin))
		(scatter where L_PRODUCTION, ms(none) mla(pipe) mlabpos(0)),
	by(LNTQUINT, rows(1) legend(off)
		title("Combined Coefficient of Sanctions over Tenure and Oil Production", size(medium))
	note("NOTE: Black curve gives estimate; grey curves give 95% confidence intervals calculated using the formula for the variance of a sum of random"
		"numbers.Lowess smoother applied across all cases in sample within each quintile of leader tenure to ease viewing of trend. Upper value of quintiles,"
		"listed in panel titles, have been rounded to nearest whole number of years. Grey circles give point estimates for each case in sample. Rug plot at "
		"bottom gives frequency of each value of lagged oil production.", size(vsmall) span) )	
saving("Graphs/Fig 3 Combined Coefficient of Sanctions over Oil Production and Autocratic Tenure.gph", replace)	;
#delimit cr


*stick autocratic set onto the Analysis dataset and save
append using Data/HorH_ReplicationAnalysisData.dta
save Data/HorH_ReplicationAnalysisData.dta, replace



*************************************************************
*************************************************************
*Run models which differentiate by type of dispute
*************************************************************
*************************************************************


use Data/HorH_ReplicationAnalysisData.dta, clear

*run model for democratic leaders with interactions between dummies that indicate
*whether all of the disputes against a state in this year center on trade issues, 
*or none of the disputes against a state in this year center on trade issues.

#delimit ;
stcox sanction threat 
	alltrade alltrade_threat 
	notrade notrade_threat
	parliamentarydem 
	LMIDtarget 
	LGrgdpch Lrgdpch 
	Llimports
	demos strikes partyfrac_sc 
	infinter,
	strata(Dems_subclass)
	cluster(ccode) nohr;
outreg2 using Tables/TableA17.txt, dec(3) stats(coef se) alpha(.01, .05, .10) replace;	
#delimit cr



*Use series of lincom commands to determine whether there is a statistically significant difference between
*the risks of leaders under all, no, or mixed trade disputes


gen CC_dummy 	= .					/*make a place to store the combined coefficients*/
gen CC_dummy_se = .					/*and their standard errors*/

	label var CC_dummy "Combined Coefs comparing types of sanctioned leaders, from lincom"
	label var CC_dummy_se "Delta method se for CC_dummy, from lincom"
	
gen DummyAx 	= .					/*make a variable to hold the labels for the Yaxis*/
gen DummyReg 	= .					/*make a variable to separate out the regime types*/
	
	matrix def V = e(V)				/*preserve the variance matrix to grab standard errors for cases where the coefficient 
									indicates the appropriate comparison (e.g. alltrade and notrade)*/

	*Define labels for the Yaxis and regime type indicator and attach them to the variables
		#delimit ;
		label def DummyAx	1 "Threats No Trade/Threats Mix" 2 "Threats All Trade/Threats Mix" 3 "Threats All Trade/Threats No Trade" 
							4 "Sanctions No Trade/Sanctions Mix" 5 "Sanctions All Trade/Sanctions Mix" 6 "Sanctions All Trade/Sanctions No Trade";
		#delimit cr
		
		label def DummyReg 1 "Democratic Leaders" 2 "Autocratic Leaders" 3 "Anocratic Leaders"
		
			label val DummyAx DummyAx
			label val DummyReg DummyReg

			
			
*Get quantities to compare sanctioned democratic leaders to other types of sanctioned democratic leaders

lincom alltrade - notrade								/*compare all trade to no trade*/
	replace CC_dummy	= r(estimate) in 1				/*fill in CC in row 1*/
	replace CC_dummy_se = r(se) in 1					/*fill in se in row 1*/
	
	replace DummyAx 	= 6 in 1						/*attach label of comparison in row 1*/
	replace DummyReg 	= 1 in 1						/*attach regime type indicator in row 1*/
	
	replace CC_dummy	= _b[alltrade] in 2				/*alltrade's coefficient compares alltrade sanctions to the mix, fill in row 2*/
	replace CC_dummy_se = sqrt(V[3,3]) in 2				/*fill in se in row 2*/
	
	replace DummyAx 	= 5 in 2						/*attach label of comparison in row 2*/
	replace DummyReg 	= 1 in 2						/*attach regime type indicator in row 2*/
	
	replace CC_dummy	= _b[notrade] in 3				/*notrade's coefficient compares alltrade to the mix, fill in row 3*/
	replace CC_dummy_se = sqrt(V[5,5]) in 3				/*fill in se in row 3*/
	
	replace DummyAx 	= 4 in 3						/*attach label of comparison in row 3*/
	replace DummyReg 	= 1 in 3						/*attach regime type indicator in row 3*/
	

lincom alltrade_threat - notrade_threat					/*compare alltrade threats to no trade threats*/
	replace CC_dummy	= r(estimate) in 4				/*fill in CC in row 4*/
	replace CC_dummy_se = r(se) in 4					/*fill in se in row 4*/
	
	replace DummyAx 	= 3 in 4						/*attach label of comparison in row 4*/
	replace DummyReg 	= 1 in 4						/*attach regime type indicator in row 4*/
	
	
	replace CC_dummy	= _b[alltrade_threat] in 5		/*alltrade_threat's coefficient compares alltrade threats to the mix, fill in row 5*/	
	replace CC_dummy_se = sqrt(V[4,4]) in 5				/*fill in se in row 5*/
	
	replace DummyAx 	= 2 in 5						/*attach label of comparison in row 5*/
	replace DummyReg 	= 1 in 5						/*attach regime type indicator in row 5*/
	
	replace CC_dummy	= _b[notrade_threat] in 6		/*notrade_threat's coefficient compares alltrade to the mix, fill in row 6*/
	replace CC_dummy_se = sqrt(V[6,6]) in 6				/*fill in se in row 6*/
	
	replace DummyAx 	= 1 in 6						/*attach label of comparison in row 6*/
	replace DummyReg 	= 1 in 6						/*attach regime type indicator in row 6*/
	

	
*Repeat process for comparing different types of sanction to not being sanctioned, since it is possible that these risks are different
*from each other, but still not significant when compared to unsanctioned leaders. I attach fewer comments below, though the process 
*is the same as above

gen CC_dummy2 		= .
gen CC_dummy2_se	=.

	label var CC_dummy "Combined Coefs comparing types of sanctioned leaders to nonsanctioned leaders, from lincom"
	label var CC_dummy_se "Delta method se for CC_dummy2, from lincom"
	
gen DummyAx2	 = .
gen DummyReg2	 = .

			#delimit ;
			label def DummyAx2 1 "Mixed Threats/No Threat" 2 "No Trade Threats/No Threat" 3 "All Trade Threats/No Threat" 4 "Mixed Sanctions/No Sanction"
								5 "No Trade Sanction/No Sanction" 6 "All Trade Sanction/No Sanction";
			#delimit cr
			
			label val DummyAx2 DummyAx2
			label val DummyReg2 DummyReg	
	
	
*Get combined coefficients for comparing sanction types to not being sanctioned

		replace CC_dummy2 		= _b[threat] in 1 
		replace CC_dummy2_se 	= sqrt(V[2,2]) in 1
		
		replace DummyAx2	= 1 in 1
		replace DummyReg2	= 1 in 1
		
		
	lincom threat + notrade_threat
		replace CC_dummy2		= r(estimate) in 2
		replace CC_dummy2_se 	= r(se) in 2
		
		replace DummyAx2	= 2 in 2
		replace DummyReg2	= 1 in 2
		
	lincom threat + alltrade_threat
		replace CC_dummy2		= r(estimate) in 3
		replace CC_dummy2_se 	= r(se) in 3
		
		replace DummyAx2	= 3 in 3
		replace DummyReg2	= 1 in 3
		
		replace CC_dummy2		= _b[sanction] in 4
		replace CC_dummy2_se	= sqrt(V[1,1]) in 4
		
		replace DummyAx2	= 4 in 4
		replace DummyReg2 	= 1 in 4
		
	lincom sanction + notrade
		replace CC_dummy2		= r(estimate) in 5
		replace CC_dummy2_se 	= r(se) in 5
		
		replace DummyAx2	= 5 in 5
		replace DummyReg2	= 1 in 5
		
	lincom sanction + alltrade
		replace CC_dummy2		= r(estimate) in 6
		replace CC_dummy2_se 	= r(se) in 6
		
		replace DummyAx2	= 6 in 6
		replace DummyReg2	= 1 in 6		


		
*******************************		
*Repeat for Autocratic Leaders
*******************************

*the data contain insufficient information to test whether alltrade_threat differs from mixed:
tab wfail2 if alltrade==1&REG2==3&threat==1
		*So, the autocratic model does not include an interaction b/n alltrade and threat



#delimit ;
stcox sanction threat
	alltrade  
	notrade notrade_threat
	lnt_sanction L_PROD_sanction L_PROD2_sanction 
	geddes_personal 
	LMIDtarget 
	Lrgdpch LrgdpchOil Llimports Llimports2
	demobin Lcoupsucc
	L_PRODUCTION  L_PRODUCTION2 L_DIAMONDS,
	strata(Autos_Ally_subclass)
	cluster(ccode) nohr;
outreg2 using Tables/TableA17.txt, dec(3) stats(coef se) alpha(.01, .05, .10) append;	
#delimit cr		

mat def V = e(V)	/*preserve variance matrix*/

			
*Get quantities for autocratic Leaders

lincom alltrade - notrade
	replace CC_dummy	= r(estimate) in 7
	replace CC_dummy_se = r(se) in 7
	
	replace DummyAx 	= 6 in 7
	replace DummyReg 	= 2 in 7
	
	replace CC_dummy	= _b[alltrade] in 8
	replace CC_dummy_se = sqrt(V[3,3]) in 8
	
	replace DummyAx 	= 5 in 8
	replace DummyReg 	= 2 in 8
	
	replace CC_dummy	= _b[notrade] in 9
	replace CC_dummy_se = sqrt(V[4,4]) in 9
	
	replace DummyAx 	= 4 in 9
	replace DummyReg 	= 2 in 9

	replace CC_dummy 	= . in 10					/*no interactions with alltrade_threat possible*/
	replace DummyAx 	= 3 in 10
	replace DummyReg 	= 2 in 10
			
	replace CC_dummy 	= . in 11					/*no interactions with alltrade_threat possible*/				
	replace DummyReg 	= 2 in 11
	replace DummyAx 	= 2 in 11
	
	replace CC_dummy	= _b[notrade_threat] in 12
	replace CC_dummy_se = sqrt(V[5,5]) in 12
	
	replace DummyAx 	= 1 in 12
	replace DummyReg 	= 2 in 12

	
*get combined coefs for comparing to not being sanctioned	
	
		replace CC_dummy2 		= _b[threat] in 7 
		replace CC_dummy2_se 	= sqrt(V[2,2]) in 7
		
		replace DummyAx2	= 1 in 7
		replace DummyReg2	= 2 in 7
		
		
	lincom threat + notrade_threat
		replace CC_dummy2		= r(estimate) in 8
		replace CC_dummy2_se 	= r(se) in 8
		
		replace DummyAx2	= 2 in 8
		replace DummyReg2	= 2 in 8
		
		replace  CC_dummy2		= . in 9					/*no alltrade_threat interactions*/
		replace CC_dummy2_se 	= . in 9
		
		replace DummyAx2	= 3 in 9
		replace DummyReg2	= 2 in 9
	
	lincom sanction + lnt_sanction*8.019765	
		replace CC_dummy2		= r(estimate) in 10
		replace CC_dummy2_se	= r(se) in 10
		
		replace DummyAx2	= 4 in 10
		replace DummyReg2 	= 2 in 10
		
	lincom sanction + notrade + lnt_sanction*8.019765	
		replace CC_dummy2		= r(estimate) in 11
		replace CC_dummy2_se 	= r(se) in 11
		
		replace DummyAx2	= 5 in 11
		replace DummyReg2	= 2 in 11
		
	lincom sanction + alltrade + lnt_sanction*8.019765	
		replace CC_dummy2		= r(estimate) in 12
		replace CC_dummy2_se 	= r(se) in 12
		
		replace DummyAx2	= 6 in 12
		replace DummyReg2	= 2 in 12		
	
	
	
*When comparing to not being sanctioned, it's also reasonable to look at this effect across the level
*of oil production for autocratic leaders. In the comparison between types of disputes, the terms 
*interacted with oil production would cancel out in the hazard ratio. The code below uses lincom to 
*calculate the combined coefficients to compare being sanctioned over different types of issues to not
*being sanctioned at all across level of oil production


		gen CC_dummy2_Oil 	= .
		gen CC_dummy2_Oil_se=.
		
				label var CC_dummy2_Oil "Combined coef comparing type of dispute to not being sanctioned across Oil Prod, from lincom"
				label var CC_dummy2_Oil_se	"Delta Method standard error for CC_dummy2_Oil, from lincom"
				
		gen OilDummy2Axis 	= .
		gen OilLevDum2		= .
				
			
			#delimit ;
			label def OilDummy2Axis 1 "Mixed Threats/No Threat" 2 "No Trade Threats/No Threat" 3 "Mixed Sanctions/No Sanction"
								4 "No Trade Sanction/No Sanction" 5 "All Trade Sanction/No Sanction";
			#delimit cr
			label val OilDummy2Axis OilDummy2Axis
			
			label val OilLevDum2 OilLev

*get quantities for no oil production:	median level
		replace CC_dummy2_Oil 		= _b[threat] in 1 
		replace CC_dummy2_Oil_se 	= sqrt(V[2,2]) in 1
		
		replace OilDummy2Axis	= 1 in 1
		replace OilLevDum2	= 1 in 1
		
		
	lincom threat + notrade_threat
		replace CC_dummy2_Oil		= r(estimate) in 2
		replace CC_dummy2_Oil_se 	= r(se) in 2
		
		replace OilDummy2Axis	= 2 in 2
		replace OilLevDum2	= 1 in 2
		
	lincom sanction + lnt_sanction*8.019765	+ lnt_sanction*8.019765 + L_PROD_sanction*1.0015+ L_PROD2_sanction*1.0030023
		replace CC_dummy2_Oil		= r(estimate) in 3
		replace CC_dummy2_Oil_se	= r(se) in 3
		
		replace OilDummy2Axis	= 3 in 3
		replace OilLevDum2	= 1 in 3
		
		
	lincom sanction + notrade + lnt_sanction*8.019765	+ lnt_sanction*8.019765 + L_PROD_sanction*1.0015+ L_PROD2_sanction*1.0030023
		replace CC_dummy2_Oil		= r(estimate) in 4
		replace CC_dummy2_Oil_se 	= r(se) in 3
		
		replace OilDummy2Axis	= 3 in 3
		replace OilLevDum2	= 1 in 3
		
	lincom sanction + alltrade + lnt_sanction*8.019765	+ lnt_sanction*8.019765 + L_PROD_sanction*1.0015+ L_PROD2_sanction*1.0030023
		replace CC_dummy2_Oil		= r(estimate) in 5
		replace CC_dummy2_Oil_se 	= r(se) in 5
		
		replace OilDummy2Axis	= 5 in 5
		replace OilLevDum2	= 1 in 5
	
	
*Now for 75th percentile of oil production	
	lincom sanction + lnt_sanction*8.019765	+ L_PROD_sanction*1.0015+ L_PROD2_sanction*1.0030023
		replace CC_dummy2_Oil		= r(estimate) in 6
		replace CC_dummy2_Oil_se	= r(se) in 6
		
		replace OilDummy2Axis	= 3 in 6
		replace OilLevDum2 	= 2 in 6
		
	lincom sanction + notrade + lnt_sanction*8.019765 + L_PROD_sanction*1.0015+ L_PROD2_sanction*1.0030023
		replace CC_dummy2_Oil		= r(estimate) in 7
		replace CC_dummy2_Oil_se 	= r(se) in 7
		
		replace OilDummy2Axis	= 4 in 7
		replace OilLevDum2	= 2 in 7
		
	lincom sanction + alltrade + lnt_sanction*8.019765	+ L_PROD_sanction*1.0015+ L_PROD2_sanction*1.0030023
		replace CC_dummy2_Oil		= r(estimate) in 8
		replace CC_dummy2_Oil_se 	= r(se) in 8
		
		replace OilDummy2Axis	= 5 in 8
		replace OilLevDum2	= 2 in 8
		

*Now for high level of oil production	
	lincom sanction + lnt_sanction*8.019765	+ L_PROD_sanction*3.035322 5+ L_PROD2_sanction*9.2131796
		replace CC_dummy2_Oil		= r(estimate) in 9
		replace CC_dummy2_Oil_se	= r(se) in 9
		
		replace OilDummy2Axis	= 3 in 9
		replace OilLevDum2 	= 3 in 9
		
	lincom sanction + notrade + lnt_sanction*8.019765	+ L_PROD_sanction*3.035322 5+ L_PROD2_sanction*9.2131796
		replace CC_dummy2_Oil		= r(estimate) in 10
		replace CC_dummy2_Oil_se 	= r(se) in 10
		
		replace OilDummy2Axis	= 4 in 10
		replace OilLevDum2	= 3 in 10
		
	lincom sanction + alltrade + lnt_sanction*8.019765	+ L_PROD_sanction*3.035322 5+ L_PROD2_sanction*9.2131796
		replace CC_dummy2_Oil		= r(estimate) in 11
		replace CC_dummy2_Oil_se 	= r(se) in 11
		
		replace OilDummy2Axis	= 5 in 11
		replace OilLevDum2	= 3 in 11	
		
		
*Generate 95% confidence intervals
	gen CC_dummy2_Oil_hi = CC_dummy2_Oil + 1.96*CC_dummy2_Oil_se
	gen CC_dummy2_Oil_lo = CC_dummy2_Oil - 1.96*CC_dummy2_Oil_se	

*Make graph 	
#delimit ;
twoway (rcap CC_dummy2_Oil_hi CC_dummy2_Oil_lo OilDummy2Axis , sort horiz)
	(scatter OilDummy2Axis CC_dummy2_Oil , sort mcolor(black) msymbol(oh) msize(small)), 
	ytitle("")
	ylabel(1(1)5, labels labsize(small) angle(horizontal) labgap(tiny) valuelabel) 
	ymtic(.25(5)5.25)
	xlabel(#6)
	xtitle("Combined Coefficient")
	xline(0, lcolor(gs12) lpattern(vshortdash))
	xsize(3) ysize(2)
by(OilLevDum2,	rows(1) title("Comparing Risks of Targeted and Untargeted Autocratic Leaders Across Oil Production", size(medium))
legend(off) 
note("NOTE: Figures plotted are combined coefficients from stratified Cox models including trade ratio and its interaction with threats. Bars give 95%" 
	"confidence bounds calculated using the Delta method via Stata's lincom utility.", size(vsmall) span))
name(oil2, replace);
#delimit cr	


	
*******************************	
*Repeat for Anocratic Leaders	
*******************************

#delimit;
stcox sanction threat
	alltrade alltrade_threat 
	notrade notrade_threat
	LMIDtarget
	LGrgdpch Lrgdpch 
	Llimports
	demobin strikebin
	L_PRODUCTION,
	strata(Anos_Justxb_subclass)
	nohr cluster(ccode);
outreg2 using Tables/TableA17.txt, dec(3) stats(coef se) alpha(.01, .05, .10) append;	
#delimit cr

mat def V = e(V)	/*preserve variance matrix*/

			
*lincom commands for mixed regime leaders

lincom alltrade - notrade
	replace CC_dummy	= r(estimate) in 13
	replace CC_dummy_se = r(se) in 13
	
	replace DummyAx 	= 6 in 13
	replace DummyReg 	= 3 in 13
	
	replace CC_dummy	= _b[alltrade] in 14
	replace CC_dummy_se = sqrt(V[3,3]) in 14
	
	replace DummyAx 	= 5 in 14
	replace DummyReg 	= 3 in 14
	
	replace CC_dummy	= _b[notrade] in 15
	replace CC_dummy_se = sqrt(V[5,5]) in 15
	
	replace DummyAx 	= 4 in 15
	replace DummyReg 	= 3 in 15
	

lincom alltrade_threat - notrade_threat
	replace CC_dummy	= r(estimate) in 16
	replace CC_dummy_se = r(se) in 16
	
	replace DummyAx 	= 3 in 16
	replace DummyReg 	= 3 in 16
	
	
	replace CC_dummy	= _b[alltrade_threat] in 17
	replace CC_dummy_se = sqrt(V[4,4]) in 17
	
	replace DummyAx 	= 2 in 17
	replace DummyReg 	= 3 in 17
	
	replace CC_dummy	= _b[notrade_threat] in 18
	replace CC_dummy_se = sqrt(V[6,6]) in 18
	
	replace DummyAx 	= 1 in 18
	replace DummyReg 	= 3 in 18

	
*lincom commands to compare to not being sanctioned	
	
		replace CC_dummy2 		= _b[threat] in 13 
		replace CC_dummy2_se 	= sqrt(V[2,2]) in 13
		
		replace DummyAx2	= 1 in 13
		replace DummyReg2	= 3 in 13
		
		
	lincom threat + notrade_threat
		replace CC_dummy2		= r(estimate) in 14
		replace CC_dummy2_se 	= r(se) in 14
		
		replace DummyAx2	= 2 in 14
		replace DummyReg2	= 3 in 14
		
	lincom threat + alltrade_threat
		replace CC_dummy2		= r(estimate) in 15
		replace CC_dummy2_se 	= r(se) in 15
		
		replace DummyAx2	= 3 in 15
		replace DummyReg2	= 3 in 15
		
		replace CC_dummy2		= _b[sanction] in 16
		replace CC_dummy2_se	= sqrt(V[1,1]) in 16
		
		replace DummyAx2	= 4 in 16
		replace DummyReg2 	= 3 in 16
		
	lincom sanction + notrade
		replace CC_dummy2		= r(estimate) in 17
		replace CC_dummy2_se 	= r(se) in 17
		
		replace DummyAx2	= 5 in 17
		replace DummyReg2	= 3 in 17
		
	lincom sanction + alltrade
		replace CC_dummy2		= r(estimate) in 18
		replace CC_dummy2_se 	= r(se) in 18
		
		replace DummyAx2	= 6 in 18
		replace DummyReg2	= 3 in 18		
		
*Calculate CIs
foreach x in dummy dummy2	{
	gen CC_`x'_lo = CC_`x' - 1.96*CC_`x'_se
	gen CC_`x'_hi = CC_`x' + 1.96*CC_`x'_se
							}
*Convert to HRs for substantive interpretation
foreach x in dummy dummy_lo dummy_hi dummy2 dummy2_lo dummy2_hi	{
	gen HR_`x' = exp(CC_`x')
										}
										
										
								
*Graph comparison across types of sanctions:
#delimit ;
twoway (rcap  CC_dummy_lo CC_dummy_hi DummyAx , sort horiz)
	(scatter DummyAx CC_dummy , sort mcolor(black) msymbol(oh) msize(small)), 
	ytitle("")
	ylabel(1(1)6, labels labsize(small) angle(horizontal) labgap(tiny) valuelabel) 
	ymtic(.5(1.5)6.5)
	xlabel(#6)
	xtitle("Combined Coefficient")
	xline(0, lcolor(gs12) lpattern(vshortdash))
	xsize(3) ysize(2)
by(DummyReg,	rows(1) title("Figure 4. Comparing Risks of Targeted Leaders by Type of Disputes", size(medium))
legend(off) 
note("NOTE: Figures plotted are combined coefficients from stratified Cox models including all trade and no trade dummies and their interaction with threats, reported" 
"in Table A17 of the online appendix. Bars give 95% confidence bounds calculated using the Delta method via Stata's lincom utility. Condition ahead of slash is"
 "compared to that behind. Positive coefficients indicate heightened risks; negative, lowered. Exponentiating gives the hazard ratio. Autocratic survival time set" 
 "to mean, oil production to zero for this calculation.", size(vsmall) span))
name(sigt2, replace)
saving("Graphs/Fig 4 Combined Coefficients from Trade Dummies.gph", replace);

								
*Graph comparison across types of sanctions by each regime type separately for increased readability
#delimit ;
twoway (rcap  CC_dummy_lo CC_dummy_hi DummyAx , sort horiz)
	(scatter DummyAx CC_dummy , sort mcolor(black) msymbol(oh) msize(small)) if DummyReg==1, 
	ytitle("")
	ylabel(1(1)6, labels labsize(small) angle(horizontal) labgap(tiny) valuelabel) 
	ymtic(.5(5)6.5)
	xlabel(#6)
	xtitle("Combined Coefficient")
	title("Democratic Leaders", size(medium))
	xline(0, lcolor(gs12) lpattern(vshortdash))
	fxsize(85) 
	name(demDum, replace)
	legend(off);
	
#delimit ;
twoway (rcap  CC_dummy_lo CC_dummy_hi DummyAx , sort horiz)
	(scatter DummyAx CC_dummy , sort mcolor(black) msymbol(oh) msize(small)) if DummyReg==2, 
	ytitle("")
	ylabel(none) 
	ymtic(.5(5)6.5)
	xlabel(#6)
	xtitle("Combined Coefficient")
	title("Autocratic Leaders", size(medium))
	xline(0, lcolor(gs12) lpattern(vshortdash))
	fxsize(40) 
	name(autDum, replace)
	legend(off);	
#delimit cr


save Data/HorH_ReplicationAnalysisData.dta, replace

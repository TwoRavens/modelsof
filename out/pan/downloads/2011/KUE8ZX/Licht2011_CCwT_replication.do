clear
capture log close
clear matrix
program drop _all

set mem 1000M
set matsize 800
set more off

cd "D:\NPH Interpretation\Licht2011_CCwT_Replication\DataverseDL" /*Sets directory, change as neccessary*/


log using Licht2011_CCwT_Replication.log, replace


*PURPOSE: 	This file replicates the analysis and interpretation reported in "Change Comes With	
*		Time" (Licht 2011). This includes replicating the results of the authors cited in 	
*		the sources selection below.										
*AUTHOR:  	Amanda A. Licht, University of Iowa									
*DATE:	719/2010													
*	MODIFIED: 7/2010, 11/2010, 4/2011									
*DATA:	GolubEUPdata.dta, BLE&J2008rep.dta, Meinke2005rep.dta	
*SOURCES:  Golub, Jonathan. 2007. "Survival Analysis and EU Decision Making". EUP, 53(4):733.	
*		Balch-Lindsay, Dylan, Andrew Enterline and Kyle Joyce. 2008. "Third-Party 		
*			Intervention and the Civil War Process." Journal of Peace Research, 45(3):345.
*		Meinke, Scott R. 2005. "Long-Term Change and Stability in House Voting Decisions: 	
*			the Case of the Minimum Wage." Legislative Studies Quarterly, 30(1):103.	
*FILE:	Licht2011_CCwT_Replication.do										
*LOG:	Licht2011_CCwT_Replication										
*OUTPUT:	
*	DATA:	mcCIgetdata.dta			- Monte Carlo dataset of percentiles of combined coef. and rel.hazards	
*			mcCIgetdata_collapse.dta- mcCIgetdata.dta collapsed to percentiles, means, and standard deviations											 	
*			G&Sinterp.dta			- GolubEUPdata.dta w/combined coef. and rel.hazards calculated
*			G&S_t					- dataset of values of time for the first-differences program for G&S QMV interpretation
*			G&S1stdiff.dta			- set of simulated sample of differences in hazard for G&S QMV interpretation
*			G&S1stdiff_CIs.dta		- 2.5th, 50th, and 97.5th percentiles of G&S1stdiff.dta by time
*			G&S2007_t.dta			- dataset of values of time by their percentiles in the actual data for backlog interp.
*			G&S_backlog.dta			- simulated sample of backlog interp. variables
*			G&S_backlog_CIs.dta		- 2.5th, 50th, and 97.5th percentiles of G&S_backlog.dta by time and backlog value
*			survival_GovWin_intgov	- data for survival plot from Balch-Lindsay, et. al Government Win equation
*			survival_OppWin_intgov	- data for survival plot from Balch-Lindsay, et. al Opposition Win equation
*			survival_negotiate_intgov-data for survival plot from Balch-Lindsay, et. al Negotiated Settlement equation
*			BLEJFig1rep.dta			- three previous files appended together to make Figure 5
*			Meinke_interp.dta		- Meinke 2005 replication data with combined coef. and rel.hazards calculated
*			Meinke_voteshareCCRelhaz.dta - simulated sample of combined coef. and rel.hazard across values of voteshare
*			Meinke_voteshareCCRelhaz_CIs.dta - 2.5th, 50th, and 97.5th percentiles of simulted sample by time and values of voteshare
*			voteinterpvars.dta		- independent variables set at constant values for first differences interp. of voteshare
*			Meinke_1stdiff.dta		- simulated sample of first-differences in hazard rate by values of voteshare
*			Meinke_1stdiff_CIs.dta	- 2.5th, 50th, and 97.5th percentiles of simulted sample of differences by time and values of voteshare
*	GRAPHS:	Licht2011_CIM_Fig1.gph	- compare dist. of combined coef. and rel.hazard	
*			Licht2011_CIM_FigA1.gph	- compare CIs from multiple methods				
*			Licht2011_CIM_Fig2.gph 	- comparison of rel.hazard and first diff of QMV	
*			Licht2011_CIM_Fig3.gph 	- rel.hazard of legislative backlog				
*			Licht2011_CIM_Fig4.gph 	- combined coef of govt. intervention			
*			Licht2011_CIM_Fig5.gph	- replication of Balch-Lindsay, et al. Figure 1		
*			Licht2011_CIM_Fig6.gph	- rel.hazard of white house loss from Meinke
*			Licht2011_CIM_Fig7.gph 	- rel.hazard of voteshare across its values
*			Licht2011_CIM_Fig8.gph	- first difference in hazard rate across values of voteshare
		

/********************************************/
/*0. Illustrate feasibility of CI method	*/
/********************************************/



mat def V = [.04, -.001\-.001, .02]

mat def m = [.5,-.2]

mat list V

clear
set obs 10


drawnorm x2, mean(1.7) sds(1) seed(5678)


expand 10000

drawnorm b1 b2, means(m) cov(V)

sum

gen LI = b1 +b2*x2

gen eLI = exp(LI)


sum LI, detail
sum eLI, detail


#delimit ;
twoway scatter eLI LI if LI<=1, sort msize(medium) msymbol(oh) mcolor(black)
					yline( .7014258, lcolor(gs10) lpattern(dash) lwidth(medium)) 
					yline( 1.314247,lcolor(gs10) lpattern(dash) lwidth(medium))  
					yline( 2.294451, lcolor(gs10) lpattern(dash) lwidth(medium))  
					xline( -.3546402,lcolor(gs10) lpattern(dash) lwidth(medium)) 
					xline( .2732641, lcolor(gs10) lpattern(dash) lwidth(medium)) 
					xline( .8304934,lcolor(gs10) lpattern(dash) lwidth(medium)) 
	title("Figure 1. Relationship between Distribution of" "Combined Coefficient and Relative Hazard")
	xtitle("Combined Coefficient") ytitle("Relative Hazard")
	ylabel(,tstyle(none)) xlabel(,tstyle(none))
	note("NOTE:  Simulated data with draw of 200 pairs of beta1 and beta2 from a normal distribution with mean vector [.5, -.2]" 
	"and variance matrix [.04, -.001\-.001, .02].", size(vsmall))
	scheme(s1manual)
	name(Fig1, replace) saving(Licht2011_CIM_Fig1.gph, replace);
#delimit cr


/*Compare variance of single draw versus monte carlo'd estimates*/

gen double var = V[1,1] + x2^2*V[2,2] + 2*x2*V[1,2]

gen LIsingledraw = .5 -.2*x2
gen LIsingedraw_p5 = LIsingledraw - 1.6449*sqrt(var)
gen LIsingledraw_p95 = LIsingledraw + 1.6449*sqrt(var)

sum var
sum LI*

label data "MC data of LI and eLI"
save mcCIgetdata.dta, replace


collapse (mean) eLI LI LIsingledraw LIsingedraw_p5 LIsingledraw_p95 (p5) LI_p5 = LI eLI_p5=eLI (p95) LI_p95=LI eLI_p95=eLI (p50) eLI_p50=eLI (sd) sd=LI, by(x2)


gen LI_lo = LI - 1.6449*sd
gen LI_hi = LI + 1.6449*sd

gen eLI_lo = exp(LI_lo)
gen eLI_hi = exp(LI_hi)
sum

#delimit ;
twoway rarea eLI_lo eLI_hi x2, sort color(gs12) fi(70)
	||rcap eLI_p5 eLI_p95 x2, sort blcolor(black)
	||line eLI eLI_p50 x2, sort lcolor(black black) lpattern(dash dash_3dot) lwidth(medthick medthick)
		title("Comparison of Methods for Obtaining Confidence Intervals" "around Relative Hazard", size(medlarge)) 
		xtitle("Modifying Variable") ytitle("Relative Hazard")
		legend(order(3 "Hazard Ratio from Exponentiated Mean Combined Coefficient" 4 "Hazard Ratio from Median of Simulated Distribution"
			1 "90% CI from Exponentiated Combined Coefficient" 2 "90% CI from Simulated Distribution") size(vsmall)
			cols(1) position(1) ring(0)) scheme(s1manual) saving(Licht2011_CIM_FigA1.gph, replace);
#delimit cr
label data "Mean, Median and CIs of mcCIgetdata.dta"
save mcCIgetdata_collapse.dta, replace 


/*******************************************/
/*1. Golub and Steunenberg 2007 replication*/
/*******************************************/

insheet using GolubEUPdata.tab, tab clear

des

stset end, id(caseno) failure(event)
stcox qmv qmvpostsea qmvpostteu coop codec eu9 eu10 eu12 eu15 thatcher agenda backlog, efron nohr tvc(qmv qmvpostsea coop codec thatcher backlog) texp(ln(_t))

mat def b=e(b)
mat def V=e(V)

mat list b
mat list V


sum _t

			/************************/
			/*  QMV INTERPRETATION	*/
			/************************/


	/*Combined Coefficients*/

gen combcoef_qmv = b[1,1] + ln(_t)*b[1,13]

gen se_combcoef_qmv = sqrt(V[1,1] + (ln(_t))^2*V[13,13] + 2*ln(_t)*V[1,13])


gen combcoef_qmv_lo = combcoef_qmv - 1.96*se_combcoef_qmv
gen combcoef_qmv_hi = combcoef_qmv + 1.96*se_combcoef_qmv

sum combcoef*


gen combcoef_qmvpostsea= b[1,2]+ ln(_t)*b[1,14]

gen se_combcoef_qmvpostsea = sqrt(V[2,2] + (ln(_t))^2*V[14,14] + 2*ln(_t)*V[2,14])


gen combcoef_qmvpostsea_lo = combcoef_qmvpostsea - 1.96*se_combcoef_qmvpostsea 
gen combcoef_qmvpostsea_hi = combcoef_qmvpostsea + 1.96*se_combcoef_qmvpostsea 

sum combcoef*

#delimit ;
twoway line combcoef_qmv combcoef_qmv_lo combcoef_qmv_hi combcoef_qmvpostsea combcoef_qmvpostsea_lo combcoef_qmvpostsea_hi _t if _t>80&_t<2000, sort
	lcolor(black black black gs10 gs10 gs10) lwidth(thick thin thin thick thin thin) legend(order(1 "QMV pre-SEA" 4 "QMV post_SEA"))
	title("Graphical Representation of Combined Coefficient") saving(G&S_LI, replace) name(coef, replace);
#delimit cr


	/*Hazard Ratios*/

gen relhaz_qmv = exp(combcoef_qmv)


gen relhaz_qmv_lo = exp(combcoef_qmv_lo)
gen relhaz_qmv_hi = exp(combcoef_qmv_hi)


gen relhaz_qmvpostsea= exp(combcoef_qmvpostsea)

gen relhaz_qmvpostsea_lo = exp(combcoef_qmvpostsea_lo)
gen relhaz_qmvpostsea_hi = exp(combcoef_qmvpostsea_hi)


#delimit ;
twoway line relhaz_qmv relhaz_qmv_lo relhaz_qmv_hi relhaz_qmvpostsea relhaz_qmvpostsea_lo relhaz_qmvpostsea_hi _t if _t>80&_t<2000, sort
	lcolor(black black black gs10 gs10 gs10) lwidth(thick thin thin thick thin thin) legend(order(1 "QMV pre-SEA" 4 "QMV post_SEA"))
	title("Replication of Golub & Steunenberg 2007 Figure 1") saving(G&S_relhaz, replace) name(relhaz, replace);
#delimit cr


keep _t qmv qmvpostsea relhaz_qmv relhaz_qmv_lo relhaz_qmv_hi relhaz_qmvpostsea relhaz_qmvpostsea_lo relhaz_qmvpostsea_hi backlog
sort _t qmv

save G&Sinterp.dta, replace


sum _t

collapse (mean) _t (min) tmin = _t (max) tmax=_t

expand 200

replace _t = tmax - (tmax - tmin)*(_n/_n)

sum _t
save G&S_t.dta, replace

*	program drop firstdiff
	program define firstdiff,
	
		use G&S_t.dta, clear

		drawnorm b1-b18, means(b) cov(V)

	
		gen Dqmv = exp(b1 + ln(_t)*b13) - 1 

		gen Dqmv_pct = Dqmv*100

		gen Dpost = exp(b2 + ln(_t)*b14) - 1 
	
		gen Dpost_pct = Dpost*100

		keep Dqmv Dpost Dqmv_pct Dpost_pct _t 

		append using G&S1stdiff.dta

		save G&S1stdiff.dta, replace

		end

clear

save G&S1stdiff.dta, emptyok replace


simulate, reps(1000): firstdiff


clear
save G&S1stdiff_CIs.dta, replace emptyok /*Make a place to store the estimates of the confidence bounds*/


/*Use statsby to get the percentiles that we will use as 95% confidence bounds*/
use G&S1stdiff.dta, clear

sum

foreach var of varlist Dqmv Dpost Dqmv_pct Dpost_pct 	{	
	use G&S1stdiff.dta, clear
	
	statsby `var'_lo = r(r1) `var'_m= r(r2) `var'_hi=r(r3), by(_t):  _pctile `var', p(2.5, 50, 97.5)
		
	append using G&S1stdiff_CIs.dta
	save G&S1stdiff_CIs.dta, replace
									}
#delimit cr


sum

sort _t

merge _t using G&Sinterp.dta

sort _t


#delimit ;
twoway line relhaz_qmv relhaz_qmv_lo relhaz_qmv_hi relhaz_qmvpostsea relhaz_qmvpostsea_lo relhaz_qmvpostsea_hi _t if _t>80&_t<2000, sort
	lcolor(black black black gs10 gs10 gs10) lwidth(thick thin thin thick thin thin) 
	ytitle("Relative Hazard") xtitle("Time in Days") ylabel(, grid)
	legend(order(1 "Pre-Single European Act" 4 "Post-Single European Act") col(1) position(1) ring(0) size(vsmall)) 
	scheme(s1manual)
	name(relhaz, replace);

#delimit ;
twoway line Dpost_m Dqmv_m _t if _t>80&_t<2000, sort lcolor(gs10 black) lwidth(thick thick)
	||lowess Dqmv_lo _t if _t>80&_t<2000, sort lwidth(thin) lcolor(black)
	||lowess Dqmv_hi _t if _t>80&_t<2000, sort lwidth(thin) lcolor(black)
	||lowess Dpost_lo _t if _t>80&_t<2000, sort lwidth(thin) lcolor(gs10)
	||lowess Dpost_hi _t if _t>80&_t<2000, sort lwidth(thin) lcolor(gs10)    
	ytitle("First Difference", color(black)) ylabel(, grid)
	 xtitle("Time in Days") 
	legend(off) scheme(s1manual)
	name(dif, replace);


graph combine relhaz dif, ycommon 
	title("Figure 2. Effect of Qualified Majority Voting", color(black)) 
	note("NOTE: First difference reported is the difference in hazard of adoption given a switch from no QMV to QMV either pre- or post-SEA," 
	"adjusted by the risk with no QMV and multiplied by 100 to create percentages. The mean calculation from 1000 made using draws from the"
	"variance covariance matrix of NPH Cox model in Table 1 is reported, with dashed lines indicating 95% confidence intervals based on that sample.",
	size(vsmall)) scheme(s1manual)
saving(Licht2011_CIM_Fig2.gph,replace);
#delimit cr


			/************************/
			/*BACKLOG INTERPRETATION*/
			/************************/

insheet using GolubEUPdata.tab, tab clear

sum backlog 

stset end, id(caseno) failure(event)

xtile time = _t, n(100)


collapse (mean) _t, by(time)


expand 1000

gen lnt = ln(_t)

sum
save G&S2007_t.dta, replace


*	program drop backloginterp
	program define backloginterp
	
		syntax, num(real)
	
			use G&S2007_t.dta, clear
	
			drawnorm b1-b18, means(b) cov(V)
	
			gen combcoef_backlog = `num'*b12 + `num'*lnt*b18
	
			gen relhaz_backlog = exp(combcoef_backlog)
	
			gen backlog = `num'
	
			append using G&S_backlog.dta
	
			save G&S_backlog.dta, replace
	
		end

clear 
save G&S_backlog.dta, replace emptyok

forvalues num = 40(40)200 {

	simulate, reps(10): backloginterp, num(`num')
					}				


use G&S_backlog, clear


sum

tab backlog

#delimit ;
statsby relhaz_lo=r(r1) relhaz_med=r(r2) relhaz_hi=r(r3), by(_t backlog) 	
	saving(G&S_backlog_CIs.dta, replace):
	_pctile relhaz_backlog, p(2.5, 50, 97.5);
#delimit cr

use G&S_backlog_CIs.dta, clear
sum
tab backlog
mat list b

/*Generate the measure used by G&S for comparison*/

gen cc_1 = b[1,12] + ln(_t)*b[1,18]
gen se_cc1 = sqrt(V[12,12] + ln(_t)^2*V[18,18] + 2*ln(_t)*V[12,18])
gen cc1_lo = cc_1 - 1.96*se_cc1
gen cc1_hi = cc_1 + 1.96*se_cc1

gen relhaz_cc_1 = exp(cc_1)
gen relhaz_cc1_lo = exp(cc1_lo)
gen relhaz_cc1_hi = exp(cc1_hi)

sum cc* relhaz_cc*
save G&S_backlog_CIs.dta, replace



use G&S_backlog_CIs.dta, clear


/*display point of flip*/

di exp(abs(b[1,12])/abs(b[1,18]))


#delimit ;	
twoway rarea relhaz_lo relhaz_hi _t if backlog==200&_t<400, sort color(gs13) 
	||rarea relhaz_lo relhaz_hi _t if backlog==180&_t<400, sort color(gs11) 
	||rarea relhaz_lo relhaz_hi _t if backlog==160&_t<400, sort color(gs9) 
	||rarea relhaz_lo relhaz_hi _t if backlog==120&_t<400, sort color(gs7)
	||rarea relhaz_lo relhaz_hi _t if backlog==80&_t<400, sort color(gs4)
	||rarea relhaz_lo relhaz_hi _t if backlog==40&_t<400, sort color(black)
	||connect relhaz_cc_1 _t if _t<400, sort color(black )lpattern(solid) lwidth(medium) msymbol(dh) mcolor(black) 
	title("Effect Prior to 400 Days", color(black))
	xtitle("Time in Days") ytitle("Relative Hazard")
	legend(order(7 "1" 6 "40" 5 "80" 4 "120" 3 "160" 2 "180" 1 "200") 
	col(7) stack symplacement(center) symxsize(small) symysize(small) textwidth(vsmall)
	keygap(minuscule) rowgap(zero) colgap(small)  forcesize
	position(1) ring(0)
	title("Number of Backlogged Items", color(black) size(small)))
	scheme(s1manual)
	name(smlt, replace);

#delimit ;
twoway rarea relhaz_lo relhaz_hi _t if backlog==200&_t>=1200, sort color(gs13) 
	||rarea relhaz_lo relhaz_hi _t if backlog==180&_t>=1200, sort color(gs11) 
	||rarea relhaz_lo relhaz_hi _t if backlog==160&_t>=1200, sort color(gs9) 
	||rarea relhaz_lo relhaz_hi _t if backlog==120&_t>=1200, sort color(gs7)
	||rarea relhaz_lo relhaz_hi _t if backlog==80&_t>=1200, sort color(gs4)
	||rarea relhaz_lo relhaz_hi _t if backlog==40&_t>=1200, sort color(black)
	||connect relhaz_cc_1 _t if _t>=1200, sort color(black ) lpattern(solid) lwidth(medium) msymbol(dh) mcolor(black) 
	title("Effect After 1200 Days", color(black))
	xtitle("Time in Days") ytitle("Relative Hazard")
	xlabel(1200(1200)7200)
	legend(off)
	scheme(s1manual)
	name(bigt, replace);

#delimit ;
graph combine smlt bigt, scheme(s1manual)
	title("Figure 4. Relative Hazard of Legislative Backlog" "Across its range and Over Time", color(black))
	note("NOTE: Shaded bars represent the 95% confidence intervals based on ten draws of 1000 coefficient estimates for each value of" 
	"legislative backlog and time.  The mean number of backlogged items is 169, minimum 37 and max	of 229. Black diamonds mark the"
	"effect with one backlogged item, which is that evaluated by Golub and Steunenberg (2007). During the period between day 300 and " 
	"day 1400 effects at all values are statistically insignificant.  The majority	of this range is omitted to ease observation" 
	"of the effect while it is significant.", size(vsmall))
	saving(CIM2011_CIM_Fig3.gph, replace);
#delimit cr
save G&S_backlog_CIs.dta, replace


/***************************************************/
/*2. Balch-Lindsay, Enterline and Joyce Replication*/
/***************************************************/

insheet using BLE&J2008rep.tab, tab clear

	stset end, origin(start) fail(govwin) id(cwarnum)		
			/*tells stata the format of duration data*/


/*Run NPH Cox*/

#delimit ;
	stcox intgov intgovxlntime_gw intopp intbalanced separatist separatistxlntime_gw warcosts_pc warcosts_pcxlntime_gw
	govreputation econdevelopment econdevelopmentxlntime_gw lagpolity_b, 
	efron cluster(cwarnum) robust nohr nolog; 
#delimit cr

mat def b = e(b)
mat def V = e(V)
gen lnt = ln(_t)


/*Calculate combined coefficient and graph it*/ 


	gen LI= _b[intgov]+_b[intgovxlntime_gw]*lnt				/*Generate combined coefficient*/

sum LI

	gen se_LI= sqrt(V[1,1] + lnt^2*V[2,2]+2*lnt*V[1,2])			/*Generate standard error of combined coefficient*/

sum se_LI



	gen LI_lo= LI-1.6449*se_LI								/*Generate 90% confidence intervals*/

	gen LI_hi=LI+1.6449*se_LI


sum LI*

gen years = _t/365
sum years

/*Graph combined coefficient measure*/

#delimit ;
line  LI LI_lo LI_hi years, lcolor(black black black) lwidth(thick thin thin) sort
	||kdensity years, yaxis(2) lcolor(gs12) lpattern(vshortdash)
		xline(.78356164, lcolor(gs5) lwidth(vvthin)) 
		yline(0, lcolor(gs5) lwidth(vvthin))
		title("Government Victory", size(msmall))
		xtitle("Time") ytitle("Combined Coefficient") ytitle("", axis(2))
		legend(off)
		name(LIGW, replace)
		scheme(s1manual);
#delimit cr


/*Repeat for negotiated settlement outcome*/

stset end, origin(start) fail(negotiat) id(cwarnum)

#delimit ;
stcox intgov intgovxlntime_n intopp intbalanced separatist separatistxlntime_n warcosts_pc warcosts_pcxlntime_n 
	govreputation econdevelopment econdevelopmentxlntime_n lagpolity_b, 
	efron cluster(cwarnum) robust nohr nolog basesurv(surv_negotiate) basehc(hazard_negotiate);
#delimit cr


mat def b = e(b)
mat def V = e(V)

replace lnt = ln(_t)


	gen LIn= _b[intgov]+_b[intgovxlntime_n]*lnt				/*Generate combined coefficient*/

sum LIn

	gen se_LIn= sqrt(V[1,1] + lnt^2*V[2,2]+2*lnt*V[1,2])			/*Generate standard error of combined coefficient*/

sum se_LIn



	gen LIn_lo= LIn-1.6449*se_LIn								/*Generate 90% confidence intervals*/

	gen LIn_hi=LIn+1.6449*se_LIn


sum LI*

replace years= _t/365

/*Graph combined coefficient measure*/

#delimit ;
line  LIn LIn_lo LIn_hi years, lcolor(black black black) lwidth(thick thin thin) sort
	||kdensity years, yaxis(2) lcolor(gs12) lpattern(vshortdash)
		yline(0, lcolor(gs5) lwidth(vvthin))
		title("Negotiatied Settlement", size(msmall))
		xtitle("Time") ytitle("Combined Coefficient") ytitle("", axis(2))
		legend(off)
		scheme(s1manual)
		name(LINS, replace);
#delimit cr

/*Combine graphs for final figure*/
#delimit;
graph combine LIGW LINS, title("Figure 4. Combined Coefficient of Pro-Government Intervention", color(black) size(medlarge))
	note("NOTE: Thick line charts the combined coefficient from the appropriate equation of the competing risks NPH Cox Model reported"
	"in Table 2.  Thin lines mark 90% confidence intervals and dashed curve gives distribution of civil war durations.  The thin vertical"
	"gray line in the Government Victory graph marks 286 days, the point when the effect becomes significant.  85% of civil wars endure"
	"beyond this point in time.", size(vsmall))
	scheme(s1manual)
	saving(Licht_CIM_Fig4.gph, replace) name(fig4, replace);



		/*Replicate Balch-Lindsay, Enterline and Joyce 2008 Figure 1*/

stset end, origin(start) fail(govwin) id(cwarnum);


stcox intgov intgovxlntime_gw intopp intbalanced separatist separatistxlntime_gw warcosts_pc warcosts_pcxlntime_gw
	govreputation econdevelopment econdevelopmentxlntime_gw lagpolity_b, 
	efron cluster(cwarnum) robust nohr nolog basesurv(surv_GovWin) basehc(haz_GovWin);

stcurve, survival at(intgov=1 intopp=0 intbalanced=0 separatist=0 lagpolity_b=0) 
	outfile("survival_GovWin_intgov", replace);



stset end, origin(start) fail(oppwin) id(cwarnum);

stcox intgov intgovxlntime_ow intopp intbalanced separatist separatistxlntime_ow warcosts_pc warcosts_pcxlntime_ow
	govreputation econdevelopment econdevelopmentxlntime_ow lagpolity_b, 
	efron cluster(cwarnum) robust nohr nolog basesurv(surv_OppWin) basehc(haz_OppWin);

stcurve, survival at(intgov=1 intopp=0 intbalanced=0 separatist=0 lagpolity_b=0) 
	outfile("survival_OppWin_intgov", replace);




stset end, origin(start) fail(negotiat) id(cwarnum);

stcox intgov intgovxlntime_n intopp intbalanced separatist separatistxlntime_n warcosts_pc warcosts_pcxlntime_n
	govreputation econdevelopment econdevelopmentxlntime_n lagpolity_b, 
	efron cluster(cwarnum) robust nohr nolog basesurv(surv_neg) basehc(haz_neg);

stcurve, survival at(intgov=1 intopp=0 intbalanced=0 separatist=0 lagpolity_b=0) 
	outfile("survival_negotiate_intgov", replace);


use survival_GovWin_intgov, clear;
rename surv1 surv_GovWin;
sort _t;
save, replace;

use survival_OppWin_intgov, clear;
rename surv1 surv_OppWin;
sort _t;
save, replace;

use survival_negotiate_intgov, clear;
rename surv1 surv_neg;
sort _t;
save, replace;


append using survival_GovWin_intgov.dta;

append using survival_OppWin_intgov.dta;

save BLEJFig1rep.dta, replace;


#delimit ; 
twoway line surv_GovWin surv_neg surv_OppWin _t, 
	sort clpattern(solid dot dash) clcolor(gs4 black gs8) clwidth(medium thick medium) 
	title("Figure 2. Survival Probability Plots for Civil War Outcomes" "Given External Assistance to Government", size(medlarge))
	xtitle("Time in Days") ytitle("Probability of Survival") 
	ylabel(, labs(small))
	legend(order(1 "Government Victory" 2 "Negotiated Settlement" 3 "Opposition Victory") rows(3) position(1) ring(0))
	note("NOTE:Replication of Figure 1 from Balch-Lindsay et al. (2008) using replication files provided by the authors. Each survival" 
	"curve was derived from a separate NPH Cox model with dependent variable recoded for competing risks.", span size(vsmall))
	scheme(s1manual)
	saving(Licht2011_CIM_Fig5.gph, replace);
#delimit cr



/***********************/
/*3. Meinke Replication*/
/***********************/

insheet using Meinke2007rep.tab, tab clear

sum
drop t1-_t0
stset etimeend, fail(vchg) id(icpsr) exit(time .) origin(time 1) time0(etimest)

stcox party crospres whgain whlost unionmcr wgcgadj vtshrmcr lnwhlst lnvtshr, nohr efron robust strata(str)

mat def b=e(b)
mat def V=e(V)

mat list b
mat list V


/********************************************************************/
/*	a) generate relative hazard of white house loss for figure 6	*/
/********************************************************************/

gen lnt = ln(etimeend)

	gen dLI_whlost = _b[whlost] + lnt*_b[lnwhlst]  
	gen dLI_whlost_se = sqrt(V[4,4] + lnt^2*V[8,8] + 2*lnt*V[4,8])
	gen dLI_whlost_lo = dLI_whlost - 1.96*dLI_whlost_se
	gen dLI_whlost_hi = dLI_whlost + 1.96*dLI_whlost_se

	gen eLI_whlost = exp(_b[whlost] + lnt*_b[lnwhlst])  
	gen eLI_whlost_lo = exp(dLI_whlost_lo)
	gen eLI_whlost_hi = exp(dLI_whlost_hi) 

#delimit ;
twoway line eLI_whlost eLI_whlost_lo eLI_whlost_hi etimeend, sort lpattern(solid solid solid) lcolor(black black black) lwidth(thick thin thin)
	title("Figure 6. Relative Hazard of White House Loss") 
	yline(1, lcolor(gs5))
	xtitle("Time in Office") ytitle("Relative Hazard")
	xlabel(1(2)9)
	legend(off)
	scheme(s1manual)
	note("NOTE: Thick line marks the relative hazard.  Thin lines indictate 95% confidence intervals.  The effect is insignificant when"
	"the confidence intervals include 1, which occurs between 2 and 3 years in office.  67% of cases experience a significant positive"
	"effect on the likelihood of switching votes when their party loses the White House.", size(vsmall) span)
	name(WH2, replace) saving(Licht2011_CIM_Fig6.gph, replace); 
#delimit cr


sort etimeend
save Meinke_interp.dta, replace


/************************************************************************************************************/
/*	b) Generate Combined Coefficient and Relative Hazard of <vtshrmcr>, the continuous NPH variable		*/
/************************************************************************************************************/

/* This program doesn't need to run every time.  If it is the firt time running, un-comment this block of code.*/

clear
save Meinke_voteshareCCRelhaz.dta, replace emptyok
			
*	program drop voteshare1
	program define voteshare1
		syntax, vote(real)
	
			clear 
	
			set obs 10
				
			gen t =_n
	
			drawnorm b1-b9, means(b) cov(V)
	
			gen dvoteshare =  (b7+b9*ln(t))*`vote'
		
			gen relhazvoteshare = exp(dvoteshare)
				
			gen voteshare = `vote' + .6937063
	
			gen mcrvote = `vote'
	
			append using Meinke_voteshareCCRelhaz.dta
	
			save Meinke_voteshareCCRelhaz.dta, replace

		end


foreach vote of numlist -.64 -.59 -.44 .06 .16 .3 	{
	
simulate, reps(1000):  voteshare1, vote(`vote')
									}										


/*Now, use statsby to get 95% bounds*/

use Meinke_voteshareCCRelhaz.dta, clear

tab mcrvote	 /*this wil make collapsing to percentiles difficult, so I create an index variable, <voteblock>*/

gen voteblock = 1 if mcrvote<=-.6

	replace voteblock = 2 if mcrvote<=-.5&mcrvote>-.6
	
	replace voteblock = 3 if mcrvote<=-.3&mcrvote>-.5
	
	replace voteblock = 4 if mcrvote<=.01&mcrvote>0
	
	replace voteblock = 5 if mcrvote<=.06&mcrvote>.01
	
	replace voteblock = 6 if mcrvote<=.2&mcrvote>.1
	
	replace voteblock = 7 if mcrvote>=.3

tab voteblock mcrvote, m

tab voteblock voteshare

label def votefmt 1 "5%" 2 "10%" 3 "25%" 4 "70%" 5 "75%" 6 "85%" 7 "99%"

lab val voteblock votefmt

tab voteblock

#delimit ;
statsby relhaz_95lo=r(r1) relhaz_90lo=r(r2) relhaz_median=r(r3) relhaz_90hi=r(r4) relhaz_95hi=r(r5), by(t voteblock) 
	saving(Meinke_voteshareCCRelhaz_CIs.dta, replace):
	 _pctile relhazvoteshare, p(2.5, 5, 50, 95, 97.5);
#delimit cr	

use Meinke_voteshareCCRelhaz_CIs.dta, clear		

#delimit ;
twoway rarea  relhaz_90lo relhaz_90hi t if voteblock==1&t<=4, sort fcolor(gs4) lcolor(gs2) lwidth(vthin)
         ||rarea relhaz_90lo relhaz_90hi t if voteblock==3&t<=4, sort fcolor(gs7) lcolor(gs2) lwidth(vthin)
         ||rarea relhaz_90lo  relhaz_90hi t if voteblock==5&t<=4, sort fcolor(gs10) lcolor(gs2) lwidth(vthin)
         ||rarea relhaz_90lo  relhaz_90hi t if voteblock==7&t<=4, sort fcolor(gs13) lcolor(gs2) lwidth(vthin)
         yline(1, lcolor(black) lwidth(medium) lpattern(vshortdash)) 
                 title("Figure 7. Relative Hazard of Vote Share", color(black))
                 xtitle("Years in Office") ytitle("Relative Hazard")
         legend(order(1 "5%" 2 "25%" 3 "75%" 4 "99%") title("Margin of Victory", size(small) color(black)) 
                 col(4) stack rowgap(0) colgap(small) keygap(minuscule) symp(center) symysize(medium) symxsize(medium) textw(small))
                 note("NOTE: Shaded bars represent 90% confidence intervals around the median estimate from 1000 draws from the parameter matrix of"
                 "the NPH Cox model in Table 3. Vote share averages 69.4%, with minimum of 0 and maximum of 100%.  Mean centered variable used"
                 "in estimation and calculation.  The effect is significant when its confidence intervals do not include 1.",
                 size(vsmall) span )  
         scheme(s1manual) saving(Licht2011_CIM_Fig7.gph, replace);
#delimit cr





/******************************************************************************************************/
/*	c) First Differences program for the continuous NPH variable <vtshrmcr>, 				*/
/******************************************************************************************************/


/*THE CODE BELOW RUNS THE MODEL AND PERFORMS A PROGRAM AND LOOPS TO GENERATE MULTIPLE DIFFERENCES, 
AND OBTAIN THE CIS, SAVING TO A NEW FILE. THE WHOLE CAN TAKE ABOUT 1.5 HOURS TO RUN ON STANDARD LAPTOPS */

insheet using Meinke2007rep.tab, tab clear


collapse (mean) vtshrmcr (min) vtshrmcr_min=vtshrmcr (max) vtshrmcr_max=vtshrmcr (sd) sd=vtshrmcr

expand 10

gen t = _n

gen lnt= ln(t)
gen vtshrmcr_p1sd = 	vtshrmcr + sd
gen vtshrmcr_n1sd = 	vtshrmcr - sd
gen vtshrmcr_n2sd =	vtshrmcr -2*sd
sum


compress
save voteinterpvars.dta, replace


*	program drop voteinterp2	
	program define voteinterp2
					
		use voteinterpvars.dta, clear 
	
		drawnorm b1-b9, means(b) cov(V)
		


			gen D_psd_min = (exp((vtshrmcr_p1sd + vtshrmcr_min)*(b7 + b9*lnt)) - 1)*100 
		
			gen D_psd_nsd = (exp((vtshrmcr_p1sd + vtshrmcr_n1sd )*(b7+b9*lnt))-1)*100

			gen D_psd_n2sd = (exp((vtshrmcr_p1sd + vtshrmcr_n2sd )*(b7+b9*lnt))-1)*100

			gen D_max_psd = (exp((vtshrmcr_max - vtshrmcr_p1sd)*(b7 + b9*lnt)) - 1)*100 

			gen D_max_n2sd  = (exp((vtshrmcr_max + vtshrmcr_n2sd)*(b7 + b9*lnt)) - 1)*100 

			gen D_max_min  = (exp((vtshrmcr_max + vtshrmcr_min)*(b7 + b9*lnt)) - 1)*100 


/*smaller values of voteshare are added here to avoid adding negative terms*/
			

			append using Meinke_1stdiff.dta
			
			save Meinke_1stdiff.dta, replace
			
		
		end 


clear
save Meinke_1stdiff.dta, emptyok replace 		/*make dataset for results*/

/*Run simulation*/

simulate, reps(1000): voteinterp2

clear
save Meinke_1stdiff_CIs.dta, replace emptyok	/*Make dataset for confidence bounds*/

use Meinke_1stdiff.dta, clear
sum

	/*Use statsby to get confidence bounds*/

	foreach diff of varlist D_psd_min D_psd_nsd D_psd_n2sd D_max_psd D_max_n2sd D_max_min	{
		use Meinke_1stdiff.dta, clear
		sum
		
	
		statsby `diff'_lo=r(r1) `diff'_med=r(r2) `diff'_hi=r(r3), by(t): _pctile `diff', p(2.5, 50, 97.5)
	
		append using Meinke_1stdiff_CIs.dta
		save Meinke_1stdiff_CIs.dta, replace

										}
										
#delimit ;
twoway line D_psd_n2sd* t if t<=2, sort lcolor(gs12 gs12 gs12) 
                  lwidth(thin medthick thin)    lpattern(dash solid dash)
         ||line D_max_psd*  t if t<=2, sort lcolor(black black black) 
         lwidth(thin medthick thin) lpattern(dash solid dash)
         title("Fig 8. First-Differences Summary of Vote Share's Effect", color(black))
         ytitle("Percent Change in Hazard Ratio", size(small))
         xtitle("Years in Office")
         legend(order(5 "Increase Margin from Comfortable to Uncontested" 
                         2 "Decrease Margin from Comfortable to Plurality") 
                                 cols(1) keygap(minuscule) symxsize(medium) symysize(medium))
         note("NOTE: Thin lines indicate 90% confidence interval around the median calculated change based on a draw of 1000 estimates"
                 "from the variance-covariance matrix of NPH Cox model in Table 3. Vote share averages 69.4%, with minimum of 0 and maximum "
                 "of 100%. 'Comfortable' here is one standard deviation about the mean, or a vote share of 85.3% of the vote.  The max of 100%, "
				 "indicates an uncontested race. 'Plurality' is two standard deviations below the mean, a share of 37.3%. Mean-centered"
                 "variable used in estimation and calculation.  The effect is significant when confidence intervals do not include 0.", size(vsmall) span)  
         scheme(s1manual) saving(Licht2011_CIM_Fig8.gph, replace);
#delimit cr


log close


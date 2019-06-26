version 13.1										/*preliminaries: version control and clearing memory*/
clear
capture log close
program drop _all
clear matrix
clear mata
set scheme s1mono
set maxvar 9000
set matsize 10000

/*sets directory for Stata to location of data files. UPDATE TO YOUR LOCATION
BEFORE RUNNING FILE!*/
cd D:\Projects\DecayRateofRepression\RepressDelta\R&R\ReplicationFiles 


/*Open log*/
log using Licht_and_Allen_JPR_AnalysisReplication.log, replace

*PURPOSE:	This file replicates the main analysis reported in Licht and Allen's
*			"Repressing for Reputation", including Table I and Figures 1-3. Please
*			see "Requires" field below for datasets and packages necessary to run.
*			For replication materials pertaining to robustness checks displayed in
*			the Online Appendix, contact the corresponding author.
*AUTHOR:	Amanda A. Licht, Binghamton University, aalicht@gmail.com
*MACHINE:	LICHTBINGOFFICE, Lenovo ThinkStation, running StataMP 13	
*DATE:		12/15/2017
*FILE:		Licht_and_Allen_JPR_AnalysisReplication.do
*LOG:		Licht_and_Allen_JPR_AnalysisReplication.log
*REQUIRES:	Licht_and_Allen_Replication_Data.dta,  replication dataset in leader
*													months
*			IVsforSim.dta, analysis variables at mean and modal values 
*			outreg2, Stata package for writing tables
*DATA:		Licht_and_Allen_Replication_Data
*	SOURCES: 	Archigos 2.1, Goemans, Gkeditsch and Chiozza 2009
*				Integrated Data for Events Analysis, Bond et al 2003
*				Regular Turnover Details, Licht 2014
*				Expanded Trade and GDP, Gleditsch 2004
* 				Quality of Government Data, Teorrell et al 2011
*				Database of Political Institutions, Keefer 2009
*				Polity IV, Marshall, Gurr and Jaggers 2016
*				Oil and Gas Data, Ross 2013
*				NELDA, Hyde and Marinov 2012
*OUTPUT:
*	Data:		Yhat.dta	- simulated sampling distribution of the predicted
*							change in repression intensity (i.e. Yhat), k=1000
*	Graphs:		Fig 1 Marginal Effect Of Tenure on Repression Intensity
*				Fig 2 Predicted Change in Repression Intensity
*				Fig 3 Challenger Transition Coefficients across Time-frames
*	Tables:		Table I Regression on Change in Repression Intensity

*Open data:
use Licht_and_Allen_Replication_Data.dta, clear

*Run model including leaders characterized as neutral
*and save the first column of Table I:
#delimit ;/
reg D1wrepressSix_abs 	trans3 transheir3 transneither3
						heir_t heir_t2
						neither_t neither_t2
						t t2
						heirtopower 
						neither
						L1wrepressSix_abs
						LD1wrepressSix_abs
						L1diss3_abs
						LD1diss3_abs
						LDmilperpct 
						DLlrealgdp
						DLlpop
						LDloil_gas_value_2000
						ln_timetilnextelec
						Lpolity2
						Lseatdiffs_prop, cluster(leader);
outreg2 using "Table I Regression on Change in Repression Intensity.txt", text 
	replace stats(coef se) ctit(All Types) 
	e(r2_a r2 rmse F N N_clust)  dec(3) sym(***,**,*) ;						
#delimit cr
	
	*Preserve parameter matrices
	mat def b1= e(b)
	mat def V1 = e(V)
			
*Calculate marginal effects of transition using lincom:
	lincom trans3 + transheir3
	lincom trans3 + transneither3
	
	
*Calculate Marginal Effects of tenure using lincom		

		*First, make placeholder variables for the combined coefficients
		gen CC3_heirt 	= .				/*for tenure, given heir to power*/
		gen CC3_breakt 	= .				/*for tenure, given challenger (i.e. break with prior)*/
		gen CC3_neithert	= .			/*for tenure, given neither*/

		*make placenholder variables for the standard errors of the estimates:
		gen CC3_heirt_se 	= .
		gen CC3_breakt_se 	= .
		gen CC3_neithert_se	= .
		
		*Sort dataset by the X-axis variable holding values of tenure:
		sort X_t
		
		set more off
		*Loop over the lincoms across tenure values:
		forvalues loop = 1(1)584	{
		
			local t	= X_t in `loop'
			
			*Lincom commands, saving the estimates and standard errors:
			lincom heir_t + 2*heir_t2*`t' 
				replace CC3_heirt 	= `r(estimate)' in `loop'
				replace CC3_heirt_se = `r(se)' in `loop'
			
			lincom neither_t + 2*neither_t2*`t'
				replace CC3_neithert 	= `r(estimate)' in `loop'
				replace CC3_neithert_se = `r(se)' in `loop'
				
			lincom t + 2*t2*`t' 
				replace CC3_breakt 	= `r(estimate)' in `loop'
				replace CC3_breakt_se= `r(se)' in `loop'		
				
								}
								
*get CIs on the marginal effect:
		foreach typ in heir break neither	{
			gen CC3_`typ't_lo90	= CC3_`typ't - 1.64*CC3_`typ't_se
			gen CC3_`typ't_hi90 = CC3_`typ't + 1.64*CC3_`typ't_se
			gen CC3_`typ't_lo95	= CC3_`typ't - 1.96*CC3_`typ't_se
			gen CC3_`typ't_hi95 = CC3_`typ't + 1.96*CC3_`typ't_se
				label var CC3_`typ't "t*2*t2*t, for `typ'"

											}
*Graph each panel separately:											
#delimit ;
twoway 	(line CC3_heirt CC3_heirt_lo95 CC3_heirt_hi95 X_t, sort 
			lc(black black black) lw(medium thin thin)	
			yline(0, lc(cyan) lw(vthin))) ,
	title("Heirs", size(small))
	xtitle("Years in Office")
	ytitle("Marginal Effect")
	legend(off)
name(heir_mod3, replace);
			
twoway	(line CC3_breakt CC3_breakt_lo95 CC3_breakt_hi95 X_t, sort 
			lc(black black black) lw(medium thin thin)
			yline(0, lc(cyan) lw(vthin))) ,
	title("Challengers", size(small))
	xtitle("Years in Office")	
	ytitle("")
	legend(off)
name(break_mod3, replace);
#delimit ;	
twoway	(line CC3_neithert CC3_neithert_lo95 CC3_neithert_hi95 X_t, sort 
			lc(black black black) lw(medium thin thin)
			yline(0, lc(cyan) lw(vthin))) ,
	title("Neithers", size(small))
	xtitle("Years in Office")	
	ytitle("")
	legend(off)
name(neither_mod3, replace);

*Combine three panels into single graph:
#delimit ;
graph combine heir_mod3 break_mod3 neither_mod3,  rows(1)
	title("Marginal Effect of Tenure across Transition Types", size(medium))
	note("NOTE: 95% CIs from lincom via Delta Method", size(vsmall) span)
name(CCt_mod3, replace)
saving("Fig 1 Marginal Effect Of Tenure on Repression Intensity.gph", replace);
#delimit cr	
	
	
*Run model excluding neutrals and save second column of Table I:	
#delimit ;
reg D1wrepressSix_abs 	trans3 
						transheir3 
						heir_t heir_t2
						t t2
						heirtopower
						L1wrepressSix_abs
						LD1wrepressSix_abs
						L1diss3_abs
						LD1diss3_abs
						LDmilperpct 
						DLlrealgdp
						DLlpop
						LDloil_gas_value_2000
						ln_timetilnextelec
						Lpolity2
						Lseatdiffs_prop if neither==0, cluster(leader);
outreg2 using "Table I Regression on Change in Repression Intensity", text 
	append stats(coef se) ctit(Excluding Neutral Transitions) 
	e(r2_a r2 rmse F N N_clust)  dec(3) sym(***,**,*) ;						
#delimit cr	



*********************************************************
*********************************************************
*Program to calculate Predicted Changes in Repression
*********************************************************
*********************************************************

*This program will open up a dataset of analysis variables at mean/modal
*value across the range of tenure time, draw a random vector of coefficients
*from the matrices b1 and V1, calculate predicted values of change in 
*repression intensity, and save the results to a new dataset. 


program define Yhat		/*open the program*/

		*open up Datasetsset of means and times:
		use IVsforSims.dta, clear

		*Draw beta vector from parameter matrices:			
		drawnorm double b1-b23, means(b1) cov(V1)
			
		*Calculate Yhat as XB for each transition type:	
		#delimit ;
		gen XB_transbreak	= b1*TransAxis 
							+b8*Taxis
							+b9*Taxis^2
							+b12*mean_L1wrepressSix_abs
							+b13*mean_LD1wrepressSix_abs
							+b14*mean_L1diss3_abs
							+b15*mean_LD1diss3_abs
							+b16*mean_LDmilperpct 
							+b17*mean_DLlrealgdp
							+b18*mean_DLlpop
							+b19*mean_LDloil_gas_value_2000
							+b20*mean_ln_timetilnextelec
							+b21*mean_Lpolity2
							+b22*mean_Lseatdiffs_prop
							+b23;


							
		gen XB_transheir	=  b1*TransAxis 
							+b2*TransAxis 
							+b4*Taxis
							+b5*Taxis^2
							+b8*Taxis
							+b9*Taxis^2
							+b10 
							+b12*mean_L1wrepressSix_abs
							+b13*mean_LD1wrepressSix_abs
							+b14*mean_L1diss3_abs
							+b15*mean_LD1diss3_abs
							+b16*mean_LDmilperpct 
							+b17*mean_DLlrealgdp
							+b18*mean_DLlpop
							+b19*mean_LDloil_gas_value_2000
							+b20*mean_ln_timetilnextelec
							+b21*mean_Lpolity2
							+b22*mean_Lseatdiffs_prop
							+b23;

		gen XB_transneither	= b1*TransAxis 
							+b3*TransAxis
							+b6*Taxis
							+b7*Taxis^2
							+b8*Taxis
							+b9*Taxis^2
							+b11
							+b12*mean_L1wrepressSix_abs
							+b13*mean_LD1wrepressSix_abs
							+b14*mean_L1diss3_abs
							+b15*mean_LD1diss3_abs
							+b16*mean_LDmilperpct 
							+b17*mean_DLlrealgdp
							+b18*mean_DLlpop
							+b19*mean_LDloil_gas_value_2000
							+b20*mean_ln_timetilnextelec
							+b21*mean_Lpolity2
							+b22*mean_Lseatdiffs_prop
							+b23;
		#delimit cr

		
		*Drop all extraneous info:
		keep Taxis XB_trans*

			
		*Save results:
		append using Yhat.dta
		save Yhat.dta, replace
end								/*close program*/


*Make empty dataset to store results from program
clear
save Yhat.dta, replace emptyok



*Run program 1K times:
set more off
simulate, reps(1000): Yhat


*Get CIs by collapsing the simulated sampling distribution of Yhat to its
*mean and standard deviation and applying the Normality Assumption:

use Yhat.dta, clear				/*open simulated results*/
sum

*Collapse: 
#delimit ;
collapse (mean)  XB_transheir XB_transbreak XB_transneither	
		(sd)	sd_XB_transheir=XB_transheir 
				sd_XB_transbreak=XB_transbreak
				sd_XB_transneither=XB_transneither, by(Taxis);
#delimit cr

*Apply Normality Assumption/formula for 90 and 95% CIs:
foreach var in heir break neither	{
	gen XB_trans`var'_lo90 = XB_trans`var' - 1.64*sd_XB_trans`var'
	gen XB_trans`var'_hi90 = XB_trans`var' + 1.64*sd_XB_trans`var'
	gen XB_trans`var'_lo95 = XB_trans`var' - 1.96*sd_XB_trans`var'
	gen XB_trans`var'_hi95 = XB_trans`var' + 1.96*sd_XB_trans`var'
					}
					
*make variable to hold labels for time:
gen Tlabels = 1 if Taxis <.01
	replace Tlabels = 2 if Taxis>.01&Taxis<.07
	replace Tlabels = 3 if Taxis>.07&Taxis<.10
	replace Tlabels = 4 if Taxis>.10&Taxis<.25
	replace Tlabels = 5 if Taxis==1
	replace Tlabels = 6 if Taxis==2
	replace Tlabels = 7 if Taxis==3
	replace Tlabels = 8 if Taxis==5
	replace Tlabels = 9 if Taxis==7
	replace Tlabels = 10 if Taxis==10
	tab Tlabels
		
		
label def tfmt 1 "One Day" 2 "One Week" 3 "One Month"  4 "Three Months"	5 "One Year" 6  "Two Years"  7 "Three Years" 8 "Five Years"  9 	"Seven Years"  10 "Ten Years"
 lab val Tlabels tfmt
 tab Tlabels
 	
	
************************
*Graph the Results:
************************
	
*Make a second Tenure axis that is "jittered" over to ease viewing of results:	
gen Taxis2= Taxis+.25

*graph
#delimit ;
twoway rspike XB_transbreak_lo95 XB_transbreak_hi95 Taxis if Tlabels==1|Tlabels>=5, sort bc(red)
		||scatter XB_transbreak Taxis if Tlabels==1|Tlabels>=5, sort msym(X) mc(red)
		||rspike XB_transheir_lo95 XB_transheir_hi95 Taxis2 if Tlabels==1|Tlabels>=5, sort bc(black)
		||scatter XB_transheir Taxis2 if Tlabels==1|Tlabels>=5, sort msym(oh) mc(black)
			title("Predicted Change in Repression Levels over Tenure" "by type of leader transition", size(medium))
			xtitle("Years in Office") xlabel(0(1)10)
			ytitle("Change in Repression Intensity")
	legend(order(2 "Challenger" 4 "Heir") title("Type of Transition", size(small)) rows(2) size(small) ring(0) pos(1))
	note("NOTE: Symbols indicate the average and spikes the 95% confidence bounds from a simulated sampling distribution of 1000 draws"
		"from the parameter matrices of the OLS regression reported as Model # in Table #. The difference between predicted changes"
		"during and after transition is significant at the 95% level for challenger transitions, but not for heir transitions. Similarly, the"
		"marginal effect of tenure is significant and negative for challengers for all time periods shown here, but never for leaders who enter" 
		"as heirs to power.", size(vsmall) span)
scheme(s1mono)
saving("Fig 2 Predicted Change in Repression Intensity.gph", replace)
name(XBtCI, replace);
#delimit cr	


*******************************************************************
*******************************************************************
*Examine effect of transitions measured using longer time-frames
*******************************************************************
*******************************************************************

*open up analysis data again:

use Licht_and_Allen_Replication_Data.dta, clear

 
*This loop will run the model across alternative time-frames for defining
*the transition period, 4, 5, 6, 12, 18, and 24 months, using the 
*naming convention for transitions as a means of automating:

set more off
foreach num in 4 5 6 12 18 24	{		/*define loop*/
#delimit ;
reg D1wrepressSix_abs 	trans`num' transheir`num' transneither`num'
						t t2
						heir_t heir_t2 
						neither_t neither_t2
						heirtopower 
						neither
						L1wrepressSix_abs
						LD1wrepressSix_abs
						L1diss3_abs
						LD1diss3_abs
						LDmilperpct 
						DLlrealgdp
						DLlpop
						LDloil_gas_value_2000
						ln_timetilnextelec
						Lpolity2
						Lseatdiffs_prop, cluster(leader);	
#delimit cr

	mat V = e(V)	/*preserve variance-covariance matrix*/
	
		*generate variables to hold the beta estimates and CIs:
		gen betatrans`num' 		= _b[trans`num']
		gen betatrans`num'_lo 	= _b[trans`num'] - 1.96*sqrt(V[1,1])
		gen betatrans`num'_hi 	= _b[trans`num'] + 1.96*sqrt(V[1,1])

		gen betatransheir`num'		= _b[trans`num'] + _b[transheir`num']
		gen betatransheir`num'_lo	= betatransheir`num' - 1.96*(sqrt(V[1,1] + V[2,2] + 2*V[1,2]))
		gen betatransheir`num'_hi	= betatransheir`num' + 1.96*(sqrt(V[1,1] + V[2,2] + 2*V[1,2]))

		gen betaneither`num'	= _b[trans`num'] + _b[transneither`num']
		gen betatransneither`num'_lo	= betaneither`num' - 1.96*(sqrt(V[1,1] + V[3,3] + 2*V[1,3]))
		gen betatransneither`num'_hi	= betaneither`num' + 1.96*(sqrt(V[1,1] + V[3,3] + 2*V[1,3]))

									}	/*close loop*/
									
									
*Create a variable that will serve as an X-axis that's the number of months.

gen Xmonths = 1 in 1

	replace Xmonths = Xmonths[_n-1]+1 if _n>1&_n<=7	
	
	*make label to hold value of transition definitions:
	label def xmfmt 1 "3" 2 "4" 3 "5" 4 "6" 5 "12" 6 "18" 7 "24"
	label val Xmonths xmfmt
	tab Xmonths
	
*Graph the results:	
#delimit ;
twoway (rspike betatrans3_lo betatrans3_hi Xmonths if Xmonths==1, sort
			lc(black) xtitle("Months Tagged as Transition") xlabel(1(1)7, valuelabel) 
			ytitle("Effect of Transition (95% CI)"))
		(rspike betatrans4_lo betatrans4_hi Xmonths if Xmonths==2, sort
			lc(black))	
		(rspike betatrans5_lo betatrans5_hi Xmonths if Xmonths==3, sort
			lc(black))	
		(rspike betatrans6_lo betatrans6_hi Xmonths if Xmonths==4, sort
			lc(black))	
		(rspike betatrans12_lo betatrans12_hi Xmonths if Xmonths==5, sort
			lc(black))	
		(rspike betatrans18_lo betatrans18_hi Xmonths if Xmonths==6, sort
			lc(black))
		(rspike betatrans24_lo betatrans24_hi Xmonths if Xmonths==7, sort
			lc(black))
			
		(scatter betatrans3 Xmonths if Xmonths==1, sort
			mc(black) msym(x) 
			xtitle("Months Tagged as Transition") xlabel(1(1)7, valuelabel) 
			ytitle("Effect of Transition (95% CI)"))
		(scatter betatrans4 Xmonths if Xmonths==2, sort
			mc(black) msym(x))	
		(scatter betatrans5 Xmonths if Xmonths==3, sort
			mc(black) msym(x))
		(scatter betatrans6 Xmonths if Xmonths==4, sort
			mc(black) msym(x))	
		(scatter betatrans12 Xmonths if Xmonths==5, sort
			mc(black) msym(x))	
		(scatter betatrans18 Xmonths if Xmonths==6, sort
			mc(black) msym(x))
		(scatter betatrans24 Xmonths if Xmonths==7, sort
			mc(black) msym(x))	,
title("Estimated Effect of Challenger Transitions across Alternative Time-Frames", size(medium))
legend(off)
name(brktransb, replace)
saving("Fig 3 Challenger Transition Coefficients across Time-frames.gph", replace);		;
#delimit cr

log close

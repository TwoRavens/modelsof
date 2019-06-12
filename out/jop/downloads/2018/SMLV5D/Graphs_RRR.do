  

	******************************************************************
	**
	**
	**		NAME:		RACHEL BRULE
	**		DATE: 		13 September, 2018
	**		PROJECT: 	"Reform, Representation & Resistance"
	**
	**		DETAILS: 	This file analyzes the impact of a father's treatment
	**					by reservations for households surveyed in REDS 2006/9.
	**					Output for article graphs and figures is provided here.
	**					All individual- and village-level identifiers have been
	**					randomly generated to protect human subjects' privacy.
	**
	**				
	**		Version: 	Stata SE 14
	**
	******************************************************************
	



clear
clear mata
clear matrix


set more off
set maxvar 32767
set matsize 10000
set max_memory .


*==============================================================================*
****** Specify "mainpath", the location where this replication package is saved.	
****** Then uncomment the remaining global variables to add your file locations.
	

global mainpath 	""


*global datapath 	"$mainpath/Data/source_datasets"
*global dopath		"$mainpath/Do_files/Analysis"
*global analysispath "$mainpath/Data/analysis_datasets"
*global outputpath 	"$mainpath/output"
*==============================================================================*
	
	
	

* Set directory for main data
*----------------------------	
	
****** Uncomment below if using a global variable here:
*cd "$analysispath"

use "analysis_individuals_deidentified.dta", clear



* Specify controls for regression analysis
*-----------------------------------------
global controls castedum_1 castedum_2 castedum_3 castedum_4 childT ///
				wealthy west sibF sibM

		

* Change directory for output
*----------------------------

****** Uncomment below if using a global variable here:
*cd "$outputpath/figures"	
	
	
	
*-------------------------------------------------------------------------------
* MAIN FIGURES
*-------------------------------------------------------------------------------
					
	
*-------------------------------------------------------------------------------
* FIGURE 1a. Reservations Impact: Women's Inheritance, father died pre-reform
*-------------------------------------------------------------------------------
			


preserve


* Set sample: Table 1. Column 3 Specification
*--------------------------------------------
keep if (fem == 1 & Hindu1 == 1 & landed == 1 & t < 0 & birthyr > 1956 & ///
		 nr_short != 1 & da_diedpost == 0)

#delimit;

twoway (lpolyci Tiland_any res_fdyr if dres1 == 0 & ///
	    res_fdyr > -40 & res_fdyr < 20,
	    lcolor(gs13) lpattern(shortdash) ciplot(rline) lwidth(thin))

	   (lpoly Tiland_any res_fdyr if dres1 == 0 & ///
	    res_fdyr > -40 & res_fdyr < 20,  
	    lcolor(gs10))

	   (lpolyci Tiland_any res_fdyr if dres1 == 1 & ///
	    res_fdyr > -40 & res_fdyr < 20,
	    lcolor(gs8) lpattern(shortdash) ciplot(rline) lwidth(thin))
	   
	   (lpoly Tiland_any res_fdyr if dres1 == 1 & ///
	    res_fdyr > -40 & res_fdyr < 20,
	    lcolor(black)),
		
graphregion(fcolor(white) lcolor(white) margin(zero))

plotregion(fcolor(white) lstyle(none) lcolor(white) ilstyle(none))

xsize(7) ysize(5)

ytitle("Likelihood of inheritance", size(med))

yscale(lcolor(none))

ylabel(0(.2)1, labsize(small) glcolor(white) angle(horizontal))

xtitle("Father dies t years after reservations") 

xscale(lcolor(none))

xlabel(-40(5)20, labsize(small)) 

xline(0)

legend(order(3 "Control: Father died pre-reservations" 
             6 "Treat: Father died post reservations") 

ring(0) pos(11) size(small) cols(1)

symxsize(*.5) region(lcolor(white)) rowgap(*.5))

note(, size(vsmall));
	
graph export "Figure1a.png", replace;

	
#delimit cr

restore		


			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**		

	

*-------------------------------------------------------------------------------
* FIGURE 1b. Reservations' Impact: Women's Inheritance, father died post-reform
*-------------------------------------------------------------------------------
			


preserve

* Set sample: Table 1. Column 3 Specification
*--------------------------------------------
keep if (fem == 1 & Hindu1 == 1 & landed == 1 & t < 0 & birthyr > 1956 & ///
		 nr_short != 1 & da_diedpost == 1)


#delimit;

twoway (lpolyci Tiland_any res_fdyr if dres1 == 0 & ///
	    res_fdyr > -10 & res_fdyr < 20,
	    lcolor(gs13) lpattern(shortdash) ciplot(rline) lwidth(thin))

	   (lpoly Tiland_any res_fdyr if dres1 == 0 & ///
	    res_fdyr > -10 & res_fdyr < 20,  
	    lcolor(gs10))

	   (lpolyci Tiland_any res_fdyr if dres1 == 1 & ///
	    res_fdyr > -10 & res_fdyr < 20,
	    lcolor(gs8) lpattern(shortdash) ciplot(rline) lwidth(thin))
	   
	   (lpoly Tiland_any res_fdyr if dres1 == 1 & ///
	    res_fdyr > -10 & res_fdyr < 20,
	    lcolor(black)),
		
graphregion(fcolor(white) lcolor(white) margin(zero))

plotregion(fcolor(white) lstyle(none) lcolor(white) ilstyle(none))

xsize(7) ysize(5)

ytitle("Likelihood of inheritance", size(med))

yscale(lcolor(none))

ylabel(0(.2)1, labsize(small) glcolor(white) angle(horizontal))

xtitle("Father dies t years after reservations") 

xscale(lcolor(none))

xlabel(-10(5)20, labsize(small)) 

xline(0)

legend(order(3 "Control: Father died pre-reservations" 
             6 "Treat: Father died post reservations") 

ring(0) pos(11) size(small) cols(1)

symxsize(*.5) region(lcolor(white)) rowgap(*.5))

note(, size(vsmall));
	
graph export "Figure1b.png", replace;
	
#delimit cr

restore		


			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**		
	
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**		

	
					
	
*-------------------------------------------------------------------------------
* APPENDIX FIGURES
*-------------------------------------------------------------------------------
			
	
	
*-------------------------------------------------------------------------------
* FIGURE A2. Distribution of reservations across villages
*-------------------------------------------------------------------------------

preserve

* Keep unique village-level observations
*---------------------------------------
bysort villageid: gen key1 = _n

drop if key1 > 1

count

la var vwreserv_cont "Number of women's reservations (Past 3 elections)"

hist vwreserv_cont, percent color(black) ///
	 graphregion(fcolor(white)) ///
	 plotregion(fcolor(white) lstyle(none) lcolor(white) ilstyle(none))


* Output
*-------
graph export "FigureA2.png", replace

restore 



			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**		
	
			
		
	
		
*-------------------------------------------------------------------------------
* FIGURE A5. Reservations' Impact on Women's Land Inheritance (acres)
*-------------------------------------------------------------------------------

clear 


* Change directory to access plot-level data
*-------------------------------------------
****** Uncomment below if using a global variable here:
*cd "$analysispath"

use "plot_level_deidentified.dta", clear


* Change directory for output
*----------------------------
****** Uncomment below if using a global variable here:
*cd "$outputpath/figures"


* Set sample: Appendix Table A18. Column 3 Specification 
*-------------------------------------------------------
keep if (Hindu1 == 1 & landed == 1 & t < 0 & birthyr > 1956 & nr_short == 0)

#delimit;

twoway (lpolyci acqA_resyr acq_res if da_diedpost == 0 &
		mode_acq == 2 & fem == 1 &
		acq_res > -25 & acq_res < 25,
	    lcolor(gs13) lpattern(shortdash) ciplot(rline) lwidth(thin))

	   (lpoly acqA_resyr acq_res if da_diedpost == 0 &
		mode_acq == 2 & fem == 1  &
		acq_res > -25 & acq_res < 25,  
	    lcolor(gs10))

	   (lpolyci acqA_resyr acq_res if da_diedpost == 1 &
		mode_acq == 2 & fem == 1 &
		acq_res > -25 & acq_res < 25,
	    lcolor(gs8) lpattern(shortdash) ciplot(rline) lwidth(thin))
	   
	   (lpoly acqA_resyr acq_res if da_diedpost == 1 &
		mode_acq == 2 & fem == 1  &
		acq_res > -25 & acq_res < 25,
	    lcolor(black)),
		
graphregion(fcolor(white) lcolor(white) margin(zero))

plotregion(fcolor(white) lstyle(none) lcolor(white) ilstyle(none))

xsize(7) ysize(5)

ytitle("Land (acres) acquired", size(med))

yscale(lcolor(none))

ylabel(, labsize(small) glcolor(white) angle(horizontal))

xtitle("Acquisition year relative to reservation year") 

xscale(lcolor(none))

xlabel(-25(5)25, labsize(small)) 

xline(0) 

legend(order(3 "Ineligible: Father died pre-reform" 
             6 "Eligible: Father died post reform") 

ring(0) pos(2) size(small) cols(1)

symxsize(*.5) region(lcolor(white)) rowgap(*.5))
 
note(, size(vsmall));
	
graph export "FigureA5.png", replace;		
		

		
#delimit cr

eststo clear


			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**	
			

		
*-------------------------------------------------------------------------------
* Figure A7. Cumulative marriage age statistics
*-------------------------------------------------------------------------------
	
	
* Change directory to reopen individual-level data
*-------------------------------------------------
****** Uncomment below if using a global variable here:
*cd "$analysispath"

use "analysis_individuals_deidentified.dta", clear

* Change directory for output
*----------------------------
****** Uncomment below if using a global variable here:
*cd "$outputpath/figures"


preserve 

* Create cumulative distribution variable for female marriage age
*----------------------------------------------------------------
cumul marriageage if fem == 1, gen(cumul_mage) 
la var cumul_mage "Cumulative distribution, marriage age of women"

collapse (mean) cumul_mage, by(marriageage)


#delimit;

twoway (lpolyci cumul_mage marriageage,
	    lcolor(gs13) lpattern(shortdash) ciplot(rline) lwidth(thin))

	   (lpoly cumul_mage marriageage,  
	    lcolor(gs10)),
		
graphregion(fcolor(white) lcolor(white) margin(zero))

plotregion(fcolor(white) lstyle(none) lcolor(white) ilstyle(none))

xsize(7) ysize(5)

ytitle("Percentage of women", size(med))

yscale(lcolor(none))

ylabel(0(0.1)1, labsize(small) glcolor(white) angle(horizontal))


xtitle("Age at marriage") 

xline(20)

yline(0.75)

xscale(lcolor(none))

xlabel(0(5)80, labsize(small)) 

legend(order(3 "Cumulative distribution") 

ring(0) pos(5) size(small) cols(1)

symxsize(*.5) region(lcolor(white)) rowgap(*.5));
		
graph export "FigureA7.png", replace;
	
#delimit cr

		
restore

			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**	

			
*---------------------------------------------------------------------------
* FIGURES A10a, A11 Preparation (associated with Table 1, Column 3. analysis)
*---------------------------------------------------------------------------


* Create global variables for calculating net effect sizes 

* Effect of exposure to reservations
*-----------------------------------
global reserv_postref "dres1 + da_postXdres1"

global reserv_preref "dres1"

* Effect of exposure to reform
*-----------------------------
global reform_postres "da_diedpost + da_postXdres1"

global reform_preres "da_diedpost"

* Net Effect
*-----------
global total_eff "dres1 + da_diedpost + da_postXdres1"


preserve 

eststo clear

		 
* Set sample
*-----------
keep if (fem == 1 & t < 0 & birthyr > 1956)

* column 2 - only landed hindus, controls, state & year FE, state trends			
			
eststo: qui reg Tiland_any treat_age120 dres1 ///
			da_diedpost dtreat_age120Xpost ///
			da_postXdres1 treat_age120Xdres1  ///
			dtreat_age120XpostXdres1  ///
			$controls stdum* yrdum* sttrend* ///
			if (Hindu1 == 1 & landed == 1), cl(villageid)

est store T1_LH


* Column 3 - controls, St & Yr FE & St trends, Target - non-random implementers
eststo: qui reg Tiland_any dres1 da_diedpost da_postXdres1 ///
			$controls stdum* yrdum* sttrend* ///
			if (Hindu1 == 1 & landed == 1 & nr_short != 1), cl(villageid)

* store estimates for landed Hinus excluding non-random implementers
est store T1_LH_NR


* run estimates w/ lincomest: create figures for effect sizes						
est restore T1_LH_NR
lincomest $reserv_preref 
est store T1_W_ResPreref

est restore T1_LH_NR
lincomest $reserv_postref 
est store T1_W_ResPostref

est restore T1_LH_NR
lincomest $reform_preres 
est store T1_W_RefPreres

est restore T1_LH_NR
lincomest $reform_postres
est store T1_W_RefPostres

est restore T1_LH_NR
lincomest $total_eff
est store T1_W_Total	


restore	
	

*-------------------------------------------------------------------------------
* Figure A10a. Coefficient Plot (Table 1, col. 3)
*-------------------------------------------------------------------------------

* Create coefficient plots

coefplot (T1_LH, label(Target)) ///
		 (T1_LH_NR, label(Target - Non-Random)), ///
		 scheme(s1mono) ///
		 graphregion(margin(l=10 b=5)) ///
		 xsize(10) ysize(11) ///
		 ylabel(, labsize(vsmall)) ///
		 xtitle("Women's Probability of Land Inheritance", ///
		 size(vsmall) justification(center) margin(t=2 b=2)) ///
		 drop(_cons) xline(0) ///
		 keep(da_diedpost dres1 da_postXdres1) ///
		 coeflabel(da_diedpost = `""Father died" "post reform""' ///
		 dres1 = `""Father died post" "reservation""' ///
		 da_postXdres1 = `""Father died post" "reservations and reform""') ///
		 levels(90 95) ciopts(recast(rcap rcap))  legend(rows(2) size(tiny) pos(4)) ///

* Output
*-------		 
graph export "FigureA10a.png", replace	


			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	
		  
			
*-------------------------------------------------------------------------------
* Figure A11. Net Effect Plot (Table 1, col. 3)
*-------------------------------------------------------------------------------

coefplot (T1_W_ResPreref, label(Reservations Pre-Reform)) ///
		 (T1_W_ResPostref, label(Reservations Post-Reform)) ///
		 (T1_W_RefPreres, label(Reform Pre-Reservations)) ///
		 (T1_W_RefPostres, label(Reform Post-Reservations)) ///
		 (T1_W_Total, label(Total)), ///
		 scheme(s1mono) ///
		 graphregion(margin(l=10 b=5)) ///
		 xsize(10) ysize(11) ///
		 ylabel(, labsize(vsmall)) ///
		 coeflabel((1) = "Effect sizes") ///
		 xline(0) ///
		 levels(90 95) ciopts(recast(rcap rcap)) legend(rows(5) size(tiny) pos(4)) ///

* Output
*-------		
graph export "FigureA11.png", replace			  


			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	
				
			
*---------------------------------------------------------------------------
* FIGURES A6, A10b Preparation (associated with Table 1, Column 6. analysis)
*---------------------------------------------------------------------------
	
	
****** Set calculations for net effects
				
* Total effect for high treatment group (<20 at reform)		
global total_hightr "da_diedpost + treat_age120 + dtreat_age120Xpost + dres1 + treat_age120Xdres1 + da_postXdres1 + dtreat_age120XpostXdres1"

* Total effect for low treatment group (20+ at reform)
global total_lowtr "da_diedpost + dres1 + da_postXdres1"


* Effect of exposure to reservations 
*-----------------------------------

* Aged <20 at reform
* DD1TH1 - effect of reservations on pr(inheritance) for someone <20 at reform & father death post reform
global DD1TH1 "dres1 + da_postXdres1 + treat_age120Xdres1 + dtreat_age120XpostXdres1"

* DD0TH1 - effect of reservations on pr(inheritance) for someone <20 at refomr & father death pre-reform
global DD0TH1 "dres1 + treat_age120Xdres1"


* Aged 20+ at reform
* DD0TH0 - effect of reservations on pr(inheritance) for someone 20+ at reform & father death pre-reform
global DD0TH0 "dres1"

* DD1TH0 - effect of reservations on pr(inheritance) for someone 20+ at reform & father death post-reform
global DD1TH0 "dres1 + da_postXdres1"


* Effect of father death post reform 
*-----------------------------------

* Aged <20 at reform 
* DR1TH1 - Effect of father death post-reform on pr(inheritance) for someone 
* aged <20 and father dying post-reservations
global DR1TH1 "da_diedpost + da_postXdres1 +  dtreat_age120Xpost +  dtreat_age120XpostXdres1"

* DR0TH1 - Effect of father dying post-reform on pr(inheritance) for someone 
* aged <20 and father dying pre-reservations
global DR0TH1 "da_diedpost +  dtreat_age120Xpost"


* Aged 20+ at reform
* DR1TH0 - Effect of father dying post-reform on pr(inheritance) for someone 
* aged 20+ and father dying post-reservations
global DR1TH0 "da_diedpost +  da_postXdres1"

* DR0TH0 - Effect of father dying post-reform on pr(inheritance) for someone 
* aged 20+ and father dying pre-reservations
global DR0TH0 "da_diedpost"


* Effect of being <20 at reform
*------------------------------

* DR1DD1 - Effect of high exposure on pr(inheritance) for those whose father
* dies post-reservations and post-reform
global DR1DD1 "treat_age120 +  treat_age120Xdres1 +  dtreat_age120XpostXdres1"

* DR1DD0 - Effect of high exposure on pr(inheritance) for those whose father
* dies post-reservations and pre-reform
global DR1DD0 "treat_age120 + treat_age120Xdres1"

* DR0DD1 - Effect of high exposure on pr(inheritance) for those whose father
* dies pre-reservations and post-reform
global DR0DD1 "treat_age120 + dtreat_age120Xpost"

* DR0DD0 - Effect of high exposure on pr(inheritance) for those whose father
* dies pre-reservations and pre-reform
global DR0DD0 "treat_age120"


* Reform & Reservations' combined impact
*---------------------------------------

* Reform & Reservations' combined impact for 20+ at reform group
global refres20 "dres1 + da_diedpost + da_postXdres1"

* Reform & Reservations' combined impact for <20 group at reform
global refres120 "dres1 + da_diedpost + da_postXdres1 + dtreat_age120Xpost + treat_age120Xdres1 + dtreat_age120XpostXdres1"


preserve 

*Set appropriate sample
*----------------------
keep if (fem == 1 & t < 0 & birthyr > 1956)


* column 2 - only landed hindus, controls, state & year FE, state trends			
			
eststo: quietly reg Tiland_any treat_age120 dres1 ///
			da_diedpost dtreat_age120Xpost ///
			da_postXdres1 treat_age120Xdres1  ///
			dtreat_age120XpostXdres1  ///
			$controls stdum* yrdum* sttrend* ///
			if (Hindu1 == 1 & landed == 1), cl(villageid)

est store T2_LH


* column 3 - only landed hindus, controls, state & year FE, state tr - not rand			
			
eststo: quietly reg Tiland_any treat_age120 dres1 ///
			da_diedpost dtreat_age120Xpost ///
			da_postXdres1 treat_age120Xdres1  ///
			dtreat_age120XpostXdres1  ///
			$controls stdum* yrdum* sttrend* ///
			if (Hindu1 == 1 & landed == 1 & nr_short != 1), cl(villageid)

est store T2_LH_NR	


* Store estimates for figure

*<20 at reform
est restore T2_LH_NR
lincomest $DD0TH1 
est store T_Hi_Res_NoRef

est restore T2_LH_NR
lincomest $DD1TH1
est store T_Hi_Res_Ref

est restore T2_LH_NR
lincomest ($DD1TH1 ) - ( $DD0TH1 )
est store T_Hi_ResDif

est restore T2_LH_NR
lincomest $DR0TH1 
est store T_Hi_Ref_NoRes

est restore T2_LH_NR
lincomest $DR1TH1
est store T_Hi_Ref_Res

est restore T2_LH_NR
lincomest ($DR1TH1 ) - ( $DR0TH1 )
est store T_Hi_RefDif

*20+ at reform
est restore T2_LH_NR
lincomest $DD0TH0 
est store T_Lo_Res_NoRef

est restore T2_LH_NR
lincomest $DD1TH0
est store T_Lo_Res_Ref

est restore T2_LH_NR
lincomest  ($DD1TH0 ) - ( $DD0TH0 )
est store T_Lo_ResDif

est restore T2_LH_NR
lincomest $DR0TH0 
est store T_Lo_Ref_NoRes

est restore T2_LH_NR
lincomest $DR1TH0
est store T_Lo_Ref_Res

est restore T2_LH_NR
lincomest  ($DR1TH0 ) - ( $DR0TH0 )
est store T_Lo_RefDif



*-------------------------------------------------------------------------------
* Figure A6. Net Effect Plots (Table 1, col. 7)
*-------------------------------------------------------------------------------
		
* Figure A6a. Net effects for reform amongst women aged <20 @ reform

coefplot (T_Hi_Ref_Res, label(`""Reform: net impact" "if father died post reservations""')) /// 
		 (T_Hi_Ref_NoRes, label(`""Reform: net impact" "if father died pre-reservations""')) ///
		 (T_Hi_RefDif, label(`""Reform: net impact" "treated by reservations vs. not""')), ///
		 scheme(s1mono) ///
		 graphregion(margin(l=10 b=5)) ///
		 xsize(10) ysize(11) ///
		 ylabel(, labsize(small)) ///
		 drop(_cons) xline(0) ///
		 coeflabel((1) = "Net effects") ///
		 levels(90 95) ciopts(recast(rcap rcap)) ///
		 legend(rows(10) size(vsmall) pos(4)) ///
		 
* Output
*-------		  
graph export "FigureA6a.png", replace

			  
* Figure A6b: Net effects for reform amongst women aged 20+ @ reform 

coefplot (T_Lo_Ref_Res, label(`""Reform: net impact" "if father died post reservations""')) ///
		 (T_Lo_Ref_NoRes, label(`""Reform: net impact" "if father died pre-reservations""')) ///
		 (T_Lo_RefDif, label(`""Reform: net impact" "treated by reservations vs. not""')), ///
		 scheme(s1mono) ///
		 graphregion(margin(l=10 b=5)) ///
		 xsize(10) ysize(11) ///
		 ylabel(, labsize(small)) ///
		 drop(_cons) xline(0) ///
		  coeflabel((1) = "Net effects") ///
		 levels(90 95) ciopts(recast(rcap rcap))  legend(rows(10) size(vsmall) pos(4)) ///

* Output
*-------			 
graph export "FigureA6b.png", replace


			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**


*-------------------------------------------------------------------------------
* Figure A10b. Coefficient Plot (Table 1, col. 7)
*-------------------------------------------------------------------------------

coefplot (T2_LH, label(Target)) ///
		 (T2_LH_NR, label(Target - Non-Random)), ///
		 scheme(s1mono) ///
		 graphregion(margin(l=10 b=5)) ///
		 xsize(10) ysize(11) ///
		 ylabel(, labsize(vsmall)) ///
		 xlabel(-.4(.2).4, labsize(small)) ///
		 xtitle("Women's Probability of Land Inheritance", ///
		 size(vsmall) justification(center) margin(t=2 b=2)) ///
		 drop(_cons) xline(0) ///
		 keep(treat_age120 dres1 ///
			da_diedpost dtreat_age120Xpost ///
			da_postXdres1 treat_age120Xdres1  ///
			dtreat_age120XpostXdres1 ) ///
		 order(treat_age120 dres1 ///
			da_diedpost dtreat_age120Xpost ///
			da_postXdres1 treat_age120Xdres1  ///
			dtreat_age120XpostXdres1 ) ///
		 coeflabel(treat_age120 = "Aged <20 at reform" ///
		 dres1 = `""Father dies post" "reservation""' ///
		 treat_age120Xdres1 = `""Aged <20 at reform" "* reservation""' ///
		 da_diedpost = "Father dies post-reform" ///
		 da_postXdres1 = `""Father dies post-reform" "* reservation""' ///
		 dtreat_age120Xpost = `""Aged <20 at reform" "* father dies post reform""'  ///
		 dtreat_age120XpostXdres1 = `""Aged <20 at reform" "* father dies post reform" "& reservation""') ///
		 levels(90 95) ciopts(recast(rcap rcap)) legend(rows(2) size(tiny) pos(4)) ///

* Output
*-------
graph export "FigureA10b.png", replace

restore 

eststo clear

			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**	

		
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			

		
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			


*-----------------------------------------------------------------
* FIGURE 12 Preparation (associated with Table 3. col. 3 analysis) 
*-----------------------------------------------------------------
			
		
* Total effects for high treatment group - <20 @ reform
global total_hightr "da_diedpost + treat_age120 + dtreat_age120Xpost + dres1 + treat_age120Xdres1 + da_postXdres1 + dtreat_age120XpostXdres1"
* Total effects for low treatment group - 20+ @ reform
global total_lowtr "da_diedpost + dres1 + da_postXdres1"

* Effect of exposure to reservations 
*-----------------------------------

* Aged <20 at reform
* DD1TH1 - effect of reservations on pr(inheritance) for someone <20 at reform & father dies post reform
global DD1TH1 "dres1 + da_postXdres1 + treat_age120Xdres1 + dtreat_age120XpostXdres1"

* DD0TH1 - effect of reservations on pr(inheritance) for someone <20 at refomr & father dies pre-reform
global DD0TH1 "dres1 + treat_age120Xdres1"

* Aged 20+ at reform
* DD0TH0 - effect of reservations on pr(inheritance) for someone 20+ at reform & father dies pre-reform
global DD0TH0 "dres1"

* DD1TH0 - effect of reservations on pr(inheritance) for someone 20+ at reform & father dies post-reform
global DD1TH0 "dres1 + da_postXdres1"


* Effect of father dies post reform 
*----------------------------------

* Aged <20 at reform 
* DR1TH1 - Effect of father dying post-reform on pr(inheritance) for someone 
* aged <20 and father dying post-reservations
global DR1TH1 "da_diedpost + da_postXdres1 +  dtreat_age120Xpost +  dtreat_age120XpostXdres1"

* DR0TH1 - Effect of father dying post-reform on pr(inheritance) for someone 
* aged <20 and father dying pre-reservations
global DR0TH1 "da_diedpost +  dtreat_age120Xpost"


* Aged 20+ at reform
* DR1TH0 - Effect of father dying post-reform on pr(inheritance) for someone 
* aged 20+ and father dying post-reservations
global DR1TH0 "da_diedpost +  da_postXdres1"

* DR0TH0 - Effect of father dying post-reform on pr(inheritance) for someone 
* aged 20+ and father dying pre-reservations
global DR0TH0 "da_diedpost"


* Effect of being <20 at reform
*-------------------------------

* DR1DD1 - Effect of high exposure on pr(inheritance) for those whose father
* dies post-reservations and post-reform
global DR1DD1 "treat_age120 +  treat_age120Xdres1 +  dtreat_age120XpostXdres1"

* DR1DD0 - Effect of high exposure on pr(inheritance) for those whose father
* dies post-reservations and pre-reform
global DR1DD0 "treat_age120 + treat_age120Xdres1"

* DR0DD1 - Effect of high exposure on pr(inheritance) for those whose father
* dies pre-reservations and post-reform
global DR0DD1 "treat_age120 + dtreat_age120Xpost"

* DR0DD0 - Effect of high exposure on pr(inheritance) for those whose father
* dies pre-reservations and pre-reform
global DR0DD0 "treat_age120"

* Reform & Reservations' combined impact
*---------------------------------------

* Reform & Reservations' combined impact for 20+ at reform group
global refres20 "dres1 + da_diedpost + da_postXdres1"

* Reform & Reservations' combined impact for <20 group at reform
global refres120 "dres1 + da_diedpost + da_postXdres1 + dtreat_age120Xpost + treat_age120Xdres1 + dtreat_age120XpostXdres1"


preserve 

eststo clear


* Set appropriate sample
*-----------------------
keep if (fem == 1 & t < 0 & birthyr > 1956)

eststo clear


* column 3 - C1 excluding non-random implementers
eststo: qui reg any_dowry_given treat_age120 dres1 ///
			da_diedpost dtreat_age120Xpost ///
			da_postXdres1 treat_age120Xdres1  ///
			dtreat_age120XpostXdres1 ///
			$controls stdum* yrdum* sttrend* ///
			if (Hindu1 == 1 & landed == 1 & nr_short != 1), cl(villageid)
			
est store Dowry_LH_NR


* Store estimates for figure
est restore Dowry_LH_NR
lincomest $DD0TH1 
est store Dowry_Hi_Res_NoRef

est restore Dowry_LH_NR
lincomest $DD1TH1
est store Dowry_Hi_Res_Ref

est restore Dowry_LH_NR
lincomest ($DD1TH1 ) - ( $DD0TH1 )
est store Dowry_Hi_ResDif


est restore Dowry_LH_NR
lincomest $DD0TH0 
est store Dowry_Lo_Res_NoRef

est restore Dowry_LH_NR
lincomest $DD1TH0
est store Dowry_Lo_Res_Ref

est restore Dowry_LH_NR
lincomest  ($DD1TH0 ) - ( $DD0TH0 )
est store Dowry_Lo_ResDif		
		
			
restore

eststo clear			

	
*-------------------------------------------------------------------------------
* FIGURE A12: NET EFFECT PLOTS
*-------------------------------------------------------------------------------	
	
* Figure A12a: Impact of representation & reform for women aged <20 at reform

coefplot (Dowry_Hi_Res_Ref, label(`""Reservations: net impact" "if father died post-reform""')) /// 
		 (Dowry_Hi_Res_NoRef, label(`""Reservations: net impact" "if father died pre-reform""')) ///
		 (Dowry_Hi_ResDif, label(`""Reservations: net impact" "eligible for reform vs. not""')), ///
		 scheme(s1mono) ///
		 graphregion(margin(l=10 b=5)) ///
		 xsize(10) ysize(11) ///
		 ylabel(, labsize(vsmall)) ///
		 drop(_cons) xline(0) ///
		  coeflabel((1) = "Effect sizes") ///
		 levels(90 95) ciopts(recast(rcap rcap))  legend(rows(10) size(vsmall) pos(4)) ///

* Output
*-------
graph export "FigureA12a.png", replace
			  
			  
			  
* Figure A12b: Impact of representation & reform for women aged 20+ at reform

coefplot (Dowry_Lo_Res_Ref, label(`""Reservations: net impact" "if father died post-reform""')) ///
		 (Dowry_Lo_Res_NoRef, label(`""Reservations: net implact" "if father died pre-reform""')) ///
		 (Dowry_Lo_ResDif, label(`""Reservations: net impact" "eligible for reform vs. not""')), ///
		 scheme(s1mono) ///
		 graphregion(margin(l=10 b=5)) ///
		 xsize(10) ysize(11) ///
		 ylabel(, labsize(vsmall)) ///
		 xtitle("Women's Probability of Receiving Dowry", ///
		 size(vsmall) justification(center) margin(t=2 b=2)) ///
		 drop(_cons) xline(0) ///
		  coeflabel((1) = "Net effects") ///
		 levels(90 95) ciopts(recast(rcap rcap))  legend(rows(10) size(vsmall) pos(4)) ///

* Output
*-------					  
graph export "FigureA12b.png", replace


			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**	
			  		
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**	
	

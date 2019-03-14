/* 	26 February 2018
	Mallory Compton
	Replication do-file FINALv
	*/
	
clear
cap log close
set more off
local date="$S_DATE"
local time="$S_TIME"
version 14.1

/* Insert your file path here  */
cd "~/JOP_151040_replication"

log using "JOP_151040_replication_`date'_`time'.log", replace

display "$S_TIME  $S_DATE"
****************************************************

clear

	use "JOP_151040_replication.dta", clear

	
	global controls "hinc_decile education age female unempspouse unioncurrent selfemployed publicemployee rog2006survey"


*******************************
*******Main Paper Table********
*******************************

*Table 1, 'Additive' Model

		logit unempspend01 occunemp_ma3 natunemp_ma3 ourinsecurity $controls , vce(r) 
			
			est store linear
			

*Table 2, 'Interactive' Model			
		logit unempspend01 occunemp_ma3 natunemp_ma3 ourinsecurity  /*
			*/ c.occunemp_ma3#c.natunemp_ma3 c.natunemp_ma3#c.ourinsecurity /*
			*/ c.occunemp_ma3#c.ourinsecurity /*
			*/ $controls , vce(r)
			
			est store interactive
			
			estout linear interactive  using "JOP_151040_table1_v${S_DATE}.txt", /*
					*/ replace cells(b(star fmt(3)) se( fmt(3) par))  /*
					*/ legend  label  omitted stat(N chi2) style(tex)/*
					*/ order(occunemp_ma3 natunemp_ma3 ourinsecurity $controls  /*
					*/  _cons "Constant")
	
	
			
			
*******************************
*******Appendix Tables*********
*******************************

*******Table A1: Additional Specications of Models of Individual 
*******Support for Increased Spending on Unemployment Benefits

	*Delta:
		logit unempspend01 occunemp_ma3 dnatunemp ourinsecurity  /*
			*/ c.occunemp_ma3#c.dnatunemp c.dnatunemp#c.ourinsecurity /*
			*/ c.occunemp_ma3#c.ourinsecurity /*
			*/ $controls , vce(r)

	*Delta & 3 yr ma
		logit unempspend01 occunemp_ma3 dnatunemp_ma3 ourinsecurity  /*
			*/ c.occunemp_ma3#c.dnatunemp_ma3 c.dnatunemp_ma3#c.ourinsecurity /*
			*/ c.occunemp_ma3#c.ourinsecurity /*
			*/ $controls , vce(r)

	*OCC IQR						
		logit unempspend01 occunemp_ma3 occ_iqr ourinsecurity  /*
			*/ c.occunemp_ma3#c.occ_iqr c.occ_iqr#c.ourinsecurity /*
			*/ c.occunemp_ma3#c.ourinsecurity /*
			*/ $controls , vce(r)

	*Wealth
		logit unempspend01 occunemp_ma3 gdppcreal ourinsecurity  /*
			*/ c.occunemp_ma3#c.gdppcreal c.gdppcreal#c.ourinsecurity /*
			*/ c.occunemp_ma3#c.ourinsecurity /*
			*/ $controls , vce(r)
					est store mta1_d
								
						
*******Table A2: Lagged and Differenced Insecurity Models

	*Main Model					
		logit unempspend01 occunemp_ma3 natunemp_ma3 ourinsecurity $controls , vce(r)

	*Lagged
		logit unempspend01 locc_unemp lnatunemp  ourinsecurity  /*
			*/ $controls , vce(r)

	*5 yr MA
		logit unempspend01 occunemp_ma5 natunemp_ma5 ourinsecurity  /*
			*/ $controls , vce(r)

	* lag & Delta
		logit unempspend01 locc_unemp lnatunemp dnatunemp ourinsecurity  /*
			*/ $controls , vce(r)

	*lag & delta, 3 yr ma
		logit unempspend01 occunemp_ma3 natunemp_ma3 dnatunemp_ma3 ourinsecurity  /*
			*/ $controls , vce(r)
	


*******Table A3: Models with Support Measured using Alternative Cutpoint

		gen unempspendcut = .
			replace unempspendcut = 1 if unempspend>=2 & unempspend!=.
			replace unempspendcut = 0 if unempspend<2 

	*Additive
		logit unempspendcut occunemp_ma3 natunemp_ma3 ourinsecurity $controls , vce(r)
			
	*Interactive		
		logit unempspendcut occunemp_ma3 natunemp_ma3 ourinsecurity  /*
			*/ c.occunemp_ma3#c.natunemp_ma3 c.natunemp_ma3#c.ourinsecurity /*
			*/ c.occunemp_ma3#c.ourinsecurity /*
			*/ $controls , vce(r)
			
		

*******Table A4: Ordered Logit Models

	*Additive
		ologit unempspend occunemp_ma3 natunemp_ma3 ourinsecurity  /*
			*/ $controls , vce(r)

	*Interactive
		ologit unempspend occunemp_ma3 natunemp_ma3 ourinsecurity  /*
			*/ c.occunemp_ma3#c.natunemp_ma3 c.natunemp_ma3#c.ourinsecurity /*
			*/ c.occunemp_ma3#c.ourinsecurity /*
			*/ $controls , vce(r)



*******Table A5: Alternative Specifications
	
	*Random effects, linear	
		melogit unempspend01 occunemp_ma3 natunemp_ma3 ourinsecurity  /*
			*/ $controls || _all: R.v6


	*Random effects, interactive
		melogit unempspend01 occunemp_ma3 natunemp_ma3 ourinsecurity  /*
			*/ c.occunemp_ma3#c.natunemp_ma3 c.natunemp_ma3#c.ourinsecurity /*
			*/ c.occunemp_ma3#c.ourinsecurity /*
			*/ $controls ||  _all: R.v6
	
	*Country fixed effects, linear
		melogit unempspend01 occunemp_ma3 natunemp_ma3 ourinsecurity  /*
			*/ $controls i.v6
	
	*Country fixed effects, interactive
		melogit unempspend01 occunemp_ma3 natunemp_ma3 ourinsecurity  /*
			*/ c.occunemp_ma3#c.natunemp_ma3 c.natunemp_ma3#c.ourinsecurity /*
			*/ c.occunemp_ma3#c.ourinsecurity /*
			*/ $controls i.v6
		

*******Table A6: Ordered Logit, Alternative Specifications


	*Random effects, linear, ordered logit
		meologit unempspend occunemp_ma3 natunemp_ma3 ourinsecurity  /*
			*/ $controls || _all: R.v6
	
	*Random effects, interactive, ordered logit
		meologit unempspend occunemp_ma3 natunemp_ma3 ourinsecurity  /*
			*/ c.occunemp_ma3#c.natunemp_ma3 c.natunemp_ma3#c.ourinsecurity /*
			*/ c.occunemp_ma3#c.ourinsecurity /*
			*/ $controls ||  _all: R.v6
	
	*Country fixed effects, linear, ordered logit
		meologit unempspend occunemp_ma3 natunemp_ma3 ourinsecurity  /*
			*/ $controls i.v6
	
	*Country fixed effects, interactive, ordered logit
		meologit unempspend occunemp_ma3 natunemp_ma3 ourinsecurity  /*
			*/ c.occunemp_ma3#c.natunemp_ma3 c.natunemp_ma3#c.ourinsecurity /*
			*/ c.occunemp_ma3#c.ourinsecurity /*
			*/ $controls i.v6
	

*******Table 7: Original Model Specification with Wealth and Culture Controls

	*Wealth included, linear
		logit unempspend01 occunemp_ma3 natunemp_ma3 ourinsecurity $controls /*
			*/ gdppcreal, vce(r)
				
	*Wealth included, intearctive
		logit unempspend01 occunemp_ma3 natunemp_ma3 ourinsecurity  /*
			*/ c.occunemp_ma3#c.natunemp_ma3 c.natunemp_ma3#c.ourinsecurity /*
			*/ c.occunemp_ma3#c.ourinsecurity /*
			*/ $controls gdppcreal, vce(r)
		
	*Language fixed effects, linear
		logit unempspend01 occunemp_ma3 natunemp_ma3 ourinsecurity $controls /*
			*/ gdppcreal lang_germ lang_slav lang_roma lang_ural /*
			*/ lang_balt lang_japn lang_isrl, vce(r)
			
	*Language fixed effects, interactive
		logit unempspend01 occunemp_ma3 natunemp_ma3 ourinsecurity  /*
			*/ c.occunemp_ma3#c.natunemp_ma3 c.natunemp_ma3#c.ourinsecurity /*
			*/ c.occunemp_ma3#c.ourinsecurity /*
			*/ $controls gdppcreal lang_germ lang_slav lang_roma lang_ural /*
			*/ lang_balt lang_japn lang_isrl , vce(r)
	


*******Table 8: Ordered Logit Models with Wealth and Culture Controls
	
	*Wealth included, linear, ordered logit
		ologit unempspend occunemp_ma3 natunemp_ma3 ourinsecurity $controls /*
			*/ gdppcreal, vce(r)
			
	*Wealth included, interactive, ordered logit
		ologit unempspend occunemp_ma3 natunemp_ma3 ourinsecurity  /*
			*/ c.occunemp_ma3#c.natunemp_ma3 c.natunemp_ma3#c.ourinsecurity /*
			*/ c.occunemp_ma3#c.ourinsecurity /*
			*/ $controls gdppcreal, vce(r)
		
	*Language fixed effects, linear, ordered logit
		ologit unempspend occunemp_ma3 natunemp_ma3  ourinsecurity $controls /*
			*/ gdppcreal gdppcreal lang_germ lang_slav lang_roma lang_ural /*
			*/ lang_balt lang_japn lang_isrl, vce(r)
			
	*Language fixed effects, interactive, ordered logit
		ologit unempspend occunemp_ma3 natunemp_ma3 ourinsecurity  /*
			*/ c.occunemp_ma3#c.natunemp_ma3 c.natunemp_ma3#c.ourinsecurity /*
			*/ c.occunemp_ma3#c.ourinsecurity /*
			*/ $controls gdppcreal lang_germ lang_slav lang_roma lang_ural /*
			*/ lang_balt lang_japn lang_isrl, vce(r)
						

*******Table A9: Pairwise Correlations

	pwcorr occunemp_ma3 natunemp_ma3 coeff_nat_unempilo, sig


*******Table A10: Models of Policy Preferences, with Insecurity Elasticity

	*Linear	
		logit unempspend01 occunemp_ma3 natunemp_ma3 ourinsecurity coeff_nat_unempilo /*
			*/ $controls , vce(r)

	*Interactive
		logit unempspend01 occunemp_ma3 natunemp_ma3 ourinsecurity /*
			*/ c.occunemp_ma3#c.natunemp_ma3 c.natunemp_ma3#c.ourinsecurity c.occunemp_ma3#c.ourinsecurity /* 
			*/ coeff_nat_unempilo c.coeff_nat_unempilo#c.natunemp_ma3 c.coeff_nat_unempilo#c.occunemp_ma3   /*
			*/ $controls , vce(r)
			est store inter_corr1
					
	
	
			
									
				
*******************************
*******Main Paper Figures******
*******************************
		
		program drop _all
		program define marginsextract
			matrix a = e(b)
			matrix ai = a'
			svmat ai, name(${scenario}_pr)
			matrix rv = e(V)
			matrix rvdiag = vecdiag(rv)
			matrix rvdiagi = rvdiag'
			svmat rvdiagi, name(${scenario}_er)
			replace ${scenario}_er =  sqrt(${scenario}_er)
			matrix drop a ai rv rvdiag rvdiagi
			
			gen ${scenario}_lower = ${scenario}_pr - (1.96*${scenario}_er1)
			gen ${scenario}_upper = ${scenario}_pr + (1.96*${scenario}_er1)
			matrix drop _all
		end
		
		
		est restore interactive
		est
				est store marginsmodel
				
		sum natunemp_ma3 if e(sample)==1 & rogyear==1996, det
		global natmean = r(mean)

		sum ourinsecurity if e(sample)==1 & rogyear==1996, det
		global instmean = r(mean)
		
		sum occunemp_ma3 if e(sample)==1 & rogyear==1996, det
		global occmean = r(mean)		
			
			
		est restore marginsmodel

		sum occunemp_ma3 if e(sample)==1, det 
		global occmin = r(min)
		global occmean = r(mean)
		global occmax = r(max)
		global occhi = r(mean)+(1.96*r(sd))
		global occlo=r(mean)-(1.96*r(sd))
		global occintv = ($occmax-$occmin)/10
		sum natunemp_ma3 if e(sample)==1, det
		global natmin = r(min)
		global natmean = r(mean)
		global natmax = r(max)
		global nathi =  r(mean)+(1.96*r(sd))
		global natlo=r(mean)-(1.96*r(sd))
		global natintv = ($natmax-$natmin)/10
		sum ourinsecurity if e(sample)==1, det
		global instmin = r(min)
		global instmean = r(mean)
		global instmax = r(max)
		global insthi = r(mean)+(1.96*r(sd))
		global instlo= r(mean)-(1.96*r(sd))
		global instintv = ($instmax-$instmin)/10
	

		**********************FIGURE ONE
		est restore marginsmodel
		margins, dydx(c.occunemp_ma3) at(natunemp_ma3=($natmin($natintv)$natmax) ) 

		marginsplot, recast(line) recastci(rline) ciopts(lpattern(dash)) plotopts(lwidth(medthick)) ///
			   ytitle(Marginal Effect of Individual Insecurity, size(medium)) ///
			   ylabel(-.01(.01).03, grid glw(medium) labsize(medium) glcolor(gs12)) ///
			   xlabel(4(2)20, labsize(medium) glcolor(gs12))  graphregion(c(white)) /// 
			   xtitle(Collective Insecurity, size(medium)) xlabel(, labsize(medium)) ///
			   xsize(15) ysize(10) scheme(s2mono) title("") yline(0)
				graph save  repf1, replace

		**********************FIGURE TWO
		est restore marginsmodel
		margins, dydx(c.occunemp_ma3) at(ourinsecurity=($instmin($instintv)$instmax) ) 

		marginsplot, recast(line) recastci(rline) ciopts(lpattern(dash)) plotopts(lwidth(medthick))  ///
			   ytitle(Marginal Effect of Individual Insecurity , size(medium)) ///
			   ylabel(-.01(.01).03, grid glw(medium) labsize(medium) glcolor(gs12)) ///
			   xlabel(.05(.1).75, labsize(medium) glcolor(gs12))  graphregion(c(white)) /// 
			   xtitle(Institutional Insecurity, size(medium)) xlabel(, labsize(medium)) ///
			   xsize(15) ysize(10) scheme(s2mono)  title("") yline(0)
				graph save  repf2, replace

		**********************FIGURE THREE
		est restore marginsmodel
		margins, dydx(c.natunemp_ma3)  at(ourinsecurity=($instmin($instintv)$instmax) ) 

		marginsplot, recast(line) recastci(rline) ciopts(lpattern(dash)) plotopts(lwidth(medthick))  ///
			   ytitle(Marginal Effect of Collective Insecurity, size(medium)) ///
			   ylabel(0(.01).03, grid glw(medium) labsize(medium) glcolor(gs12)) ///
			   xlabel(.05(.1).75, labsize(medium) glcolor(gs12))  graphregion(c(white)) /// 
			   xtitle(Institutional Insecurity, size(medium)) xlabel(, labsize(medium)) ///
			   xsize(15) ysize(10) scheme(s2mono)  title("") yline(0)
				graph save  repf4, replace


		**********************FIGURE FOUR
	
			/* Germany, Canada, Japan, Slovenia */
			sum occunemp_ma3 natunemp_ma3 ourinsecurity if rog2006survey==1 & c_name=="Germany" 
			sum occunemp_ma3 natunemp_ma3 ourinsecurity if rog2006survey==1  &  c_name=="Canada"
			sum occunemp_ma3 natunemp_ma3 ourinsecurity if rog2006survey==1  &  c_name=="Japan"
			sum occunemp_ma3 natunemp_ma3 ourinsecurity if rog2006survey==1 & c_name== "Slovenia"
	
			**********************SCENARIO ONE - Low Institutional insecurity - Germany and Slovenia
			/*Germany*/
			est restore marginsmodel
			margins,   at(occunemp_ma3=($occmin($occintv)$occmax) natunemp_ma3=(10.4) ourinsecurity=(.1975))   post
			global scenario "deu"
			marginsextract
	
	
			/*Slovenia*/
			est restore marginsmodel
			margins,   at(occunemp_ma3=($occmin($occintv)$occmax) natunemp_ma3=(6.1) ourinsecurity=(.16))   post
			global scenario "slo"
			marginsextract
		
			**********************SCENARIO TWO - Low Institutional insecurity - Canada and Japan
			/*Canada*/
			est restore marginsmodel
			margins,   at(occunemp_ma3=($occmin($occintv)$occmax) natunemp_ma3=(7) ourinsecurity=(.494))   post
			global scenario "can"
			marginsextract
	
	
			/*Japan*/
			est restore marginsmodel
			margins,   at(occunemp_ma3=($occmin($occintv)$occmax) natunemp_ma3=(3) ourinsecurity=(.42))   post
			global scenario "jap"
			marginsextract
	
			egen occu_axis = fill(${occmin}(${occintv})${occmax}) 
			replace occu_axis = . if occu_axis>$occmax+1
			 
			 
			 twoway (rline slo_lower slo_upper occu_axis, lcolor(gs6) lpattern(dash)) ///
				   (rline deu_lower deu_upper occu_axis, lcolor(black) lpattern(solid)), ///	
				   title("Low Institutional Insecurity", size(large)) ///
				   ytitle(Predicted Probability of Support, size(medium)) ///
				   ylabel(, grid glw(medium) labsize(medium) glcolor(gs12)) ///
				   xlabel(, labsize(medium) glcolor(gs12))  graphregion(c(white)) /// 
				   xtitle(Individual Insecurity, size(medium)) xlabel(, labsize(medium)) ///
				   legend(cols(1) order(1 "Slovenia, Low Collective Insecurity " ///
						  2 "Germany, High Collective Insecurity") ///
						  size(small) lcolor(black) ring(0) position(5)) ///	   
				   xsize(15) ysize(10) scheme(s2mono) ///
				   name(deu_slo, replace)
				   graph save repsim1, replace
			twoway (rline jap_lower jap_upper occu_axis, lcolor(gs6) lpattern(dash)) ///
				   (rline can_lower can_upper  occu_axis, lcolor(black) lpattern(solid)), ///	
				   title("High Institutional Insecurity", size(large)) ///
				   ytitle(Predicted Probability of Support, size(medium)) ///
				   ylabel(, grid glw(medium) labsize(medium) glcolor(gs12)) ///
				   xlabel(, labsize(medium) glcolor(gs12))  graphregion(c(white)) /// 
				   xtitle(Individual Insecurity, size(medium)) xlabel(, labsize(medium)) ///
				   legend(cols(1) order(1 "Canada, Low Collective Insecurity" ///
						  2 "Japan, High Collective Insecurity") ///
						  size(small) lcolor(black)  ring(0) position(5)) ///	   
				   xsize(15) ysize(10) scheme(s2mono) ///
				   name(pol_aus, replace)
				   graph save repsim2, replace
	




*******************************
********Appendix Figures*******
*******************************

		**********************APPENDIX FIGURE ONE
		est restore marginsmodel
		margins, dydx(c.natunemp_ma3) at(occunemp_ma3=($occmin($occintv)$occmax) ) 

		marginsplot, recast(line) recastci(rline) ciopts(lpattern(dash)) plotopts(lwidth(medthick))  ///
			   ytitle(Marginal Effect of Collective Insecurity, size(medium)) ///
			   ylabel(0(.01).03, grid glw(medium) labsize(medium) glcolor(gs12)) ///
			   xlabel(2(2)22, labsize(medium) glcolor(gs12))  graphregion(c(white)) /// 
			   xtitle(Individual Economic Insecurity, size(medium)) xlabel(, labsize(medium)) ///
			   xsize(15) ysize(10) scheme(s2mono)  title("") yline(0)

		**********************APPENDIX FIGURE TWO
		est restore marginsmodel
		margins, dydx(c.ourinsecurity) at(natunemp_ma3=($natmin($natintv)$natmax) ) 

		marginsplot, recast(line) recastci(rline) ciopts(lpattern(dash)) plotopts(lwidth(medthick)) ///
			   ytitle(Marginal Effect of Institutional Insecurity, size(medium)) ///
			   ylabel(-.9(.3).9, grid glw(medium) labsize(medium) glcolor(gs12)) ///
			   xlabel(4(2)20, labsize(medium) glcolor(gs12))  graphregion(c(white)) /// 
			   xtitle(Collective Insecurity, size(medium)) xlabel(, labsize(medium)) ///
			   xsize(15) ysize(10) scheme(s2mono) title("") yline(0)

		**********************APPENDIX FIGURE THREE
		est restore marginsmodel
		margins, dydx(c.ourinsecurity) at(occunemp_ma3=($occmin($occintv)$occmax) ) 

		marginsplot, recast(line) recastci(rline) ciopts(lpattern(dash)) plotopts(lwidth(medthick))  ///
			   ytitle(Marginal Effect of Institutional Insecurity , size(medium)) ///
			   ylabel(-.9(.3).9, grid glw(medium) labsize(medium) glcolor(gs12)) ///
			   xlabel(2(2)22, labsize(medium) glcolor(gs12))  graphregion(c(white)) /// 
			   xtitle(Individual Insecurity, size(medium)) xlabel(, labsize(medium)) ///
			   xsize(15) ysize(10) scheme(s2mono)  title("") yline(0)
				
		**********************APPENDIX FIGURE FOUR-NINE
		
						ologit unempspend occunemp_ma3 natunemp_ma3 ourinsecurity  /*
							*/ c.occunemp_ma3#c.natunemp_ma3 c.natunemp_ma3#c.ourinsecurity /*
							*/ c.occunemp_ma3#c.ourinsecurity /*
							*/ $controls , vce(r)
							est store themodel
				sum occunemp_ma3 if e(sample)==1, det 
						global occmin = r(min)
						global occmean = r(mean)
						global occmax = r(max)
						global occhi = r(mean)+(1.96*r(sd))
						global occlo=r(mean)-(1.96*r(sd))
						global occintv = ($occmax-$occmin)/10
						sum natunemp_ma3 if e(sample)==1, det
						global natmin = r(min)
						global natmean = r(mean)
						global natmax = r(max)
						global nathi =  r(mean)+(1.96*r(sd))
						global natlo=r(mean)-(1.96*r(sd))
						global natintv = ($natmax-$natmin)/10
						sum ourinsecurity if e(sample)==1, det
						global instmin = r(min)
						global instmean = r(mean)
						global instmax = r(max)
						global insthi = r(mean)+(1.96*r(sd))
						global instlo= r(mean)-(1.96*r(sd))
						global instintv = ($instmax-$instmin)/10
				
				set graph on
				forval i = 0/4 {
				global I = `i'
				
				* Fig 1 equivalent
				est restore themodel
					margins, dydx(c.occunemp_ma3) pr(outcome(`i')) at(natunemp_ma3=($natmin($natintv)$natmax) ) 
					marginsplot, recast(line) recastci(rline) ciopts(lpattern(dash)) plotopts(lwidth(medthick)) ///
							   ytitle("") ///
							   ylabel(, grid glw(medium) labsize(medium) glcolor(gs12)) ///
							   xlabel(4(2)20, labsize(medium) glcolor(gs12))  graphregion(c(white) margin(tiny)) plotregion(margin(tiny)) /// 
							   xtitle(Collective Insecurity, size(medium)) xlabel(, labsize(medium)) ///
							   xsize(15) ysize(10) scheme(s2mono) title("Policy Support = `i'") yline(0)
					graph save fig1_o`i', replace
				
				* Fig 2 equivalent
				est restore themodel
						margins, dydx(c.occunemp_ma3) pr(outcome(`i')) at(ourinsecurity=($instmin($instintv)$instmax) ) 
						marginsplot, recast(line) recastci(rline) ciopts(lpattern(dash)) plotopts(lwidth(medthick))  ///
							   ytitle("") ///
							   ylabel(, grid glw(medium) labsize(medium) glcolor(gs12)) ///
							   xlabel(.05(.1).75, labsize(medium) glcolor(gs12))  graphregion(c(white) margin(tiny)) plotregion(margin(tiny)) /// 
							   xtitle(Institutional Insecurity, size(medium)) xlabel(, labsize(medium)) ///
							   xsize(15) ysize(10) scheme(s2mono)  title("Policy Support = `i'") yline(0)
					graph save fig2_o`i', replace
								
				* Fig 3 equivalent
				est restore themodel
						margins, dydx(c.natunemp_ma3) pr(outcome(`i')) at(occunemp_ma3=($occmin($occintv)$occmax) ) 
						marginsplot, recast(line) recastci(rline) ciopts(lpattern(dash)) plotopts(lwidth(medthick))  ///
							   ytitle("") ///
							   ylabel(, grid glw(medium) labsize(medium) glcolor(gs12)) ///
							   xlabel(2(2)22, labsize(medium) glcolor(gs12))  graphregion(c(white) margin(tiny)) plotregion(margin(tiny)) /// 
							   xtitle(Individual Economic Insecurity, size(medium)) xlabel(, labsize(medium)) ///
							   xsize(15) ysize(10) scheme(s2mono)  title("Policy Support = `i'") yline(0)
					graph save fig3_o`i', replace
				
				* Fig 4 equivalent
				est restore themodel
						margins, dydx(c.natunemp_ma3) pr(outcome(`i'))  at(ourinsecurity=($instmin($instintv)$instmax) ) 
						marginsplot, recast(line) recastci(rline) ciopts(lpattern(dash)) plotopts(lwidth(medthick))  ///
							   ytitle("") ///
							   ylabel(, grid glw(medium) labsize(medium) glcolor(gs12)) ///
							   xlabel(.05(.1).75, labsize(medium) glcolor(gs12))  graphregion(c(white) margin(tiny)) plotregion(margin(tiny)) /// 
							   xtitle(Institutional Insecurity, size(medium)) xlabel(, labsize(medium)) ///
							   xsize(15) ysize(10) scheme(s2mono)  title("Policy Support = `i'") yline(0)
					graph save fig4_o`i', replace
				
				* Fig A1 equivalent
				est restore themodel
						margins, dydx(c.ourinsecurity) pr(outcome(`i')) at(natunemp_ma3=($natmin($natintv)$natmax) ) 
						marginsplot, recast(line) recastci(rline) ciopts(lpattern(dash)) plotopts(lwidth(medthick)) ///
							   ytitle("") ///
							   ylabel(, grid glw(medium) labsize(medium) glcolor(gs12)) ///
							   xlabel(4(2)20, labsize(medium) glcolor(gs12))  graphregion(c(white) margin(tiny)) plotregion(margin(tiny)) /// 
							   xtitle(Collective Insecurity, size(medium)) xlabel(, labsize(medium)) ///
							   xsize(15) ysize(10) scheme(s2mono) title("Policy Support = `i'") yline(0)
					graph save figA1_o`i', replace
				
				* Fig A2 equivalent
				est restore themodel
						margins, dydx(c.ourinsecurity) pr(outcome(`i')) at(occunemp_ma3=($occmin($occintv)$occmax) ) 
						marginsplot, recast(line) recastci(rline) ciopts(lpattern(dash)) plotopts(lwidth(medthick))  ///
							   ytitle("") ///
							   ylabel(, grid glw(medium) labsize(medium) glcolor(gs12)) ///
							   xlabel(2(2)22, labsize(medium) glcolor(gs12))  graphregion(c(white) margin(tiny)) plotregion(margin(tiny)) /// 
							   xtitle(Individual Insecurity, size(medium)) xlabel(, labsize(medium)) ///
							   xsize(15) ysize(10) scheme(s2mono)  title("Policy Support = `i'") yline(0)
					graph save figA2_o`i', replace
				}
								
				foreach i in 1 2 3 4 A1 A2 {
					graph combine fig`i'_o0.gph fig`i'_o1.gph fig`i'_o2.gph fig`i'_o3.gph fig`i'_o4.gph /*
					*/  , c(1) xsize(8) ysize(20) title("") scheme(s2mono)  graphregion(c(white) margin(tiny)) plotregion(margin(tiny)) /*
					*/	ycommon iscale(1.05) 
					graph save Fig`i'_ologit, replace
					}
													
		
		**********************APPENDIX FIGURE TEN
			logit unempspend01 occunemp_ma3 natunemp_ma3 ourinsecurity  /*
				*/ c.occunemp_ma3#c.natunemp_ma3 c.natunemp_ma3#c.ourinsecurity /*
				*/ c.occunemp_ma3#c.ourinsecurity /*
				*/ $controls , vce(r)			
			
					predict XiB_main, xb
					predict PP_main, pr
					
					sum XiB_main, det
					sum PP_main, det
					
					sum occunemp_ma3, det
					
					egen occunemp_ma3_p50=pctile(occunemp_ma3), p(50)
					egen occunemp_ma3_p25=pctile(occunemp_ma3), p(25)
					egen occunemp_ma3_p75=pctile(occunemp_ma3), p(75)
					
					gen indrisk_top50=.
					replace indrisk_top50=1 if occunemp_ma3>=occunemp_ma3_p50
					replace indrisk_top50=0 if occunemp_ma3<occunemp_ma3_p50				
					tab indrisk_top50
					twoway kdensity XiB_main if indrisk_top50==1 || /*
						*/ kdensity XiB_main if indrisk_top50==0 || /*
						*/ function y=(exp(x)/(1+exp(x))), range(-3.5 3.5) || /*
						*/ , legend(label(1 "x{sub:i}{&beta} for individual risk at or above median") /*
						*/ label(2 "x{sub:i}{&beta} for individual risk below median") /*
						*/ label(3 "Predicted Probability") cols(1)) /*
						*/ xtitle("x{sub:i}{&beta}") ytitle("Predicted Probability of Supporting" "Increased Spending on Unemployment") /*
						*/    xsize(15) ysize(10) scheme(s2mono) graphregion(c(white))
		
	
	
		**********************APPENDIX FIGURE ELEVEN-EIGHTEEN	
						est restore inter_corr1
							est store marginsmodel
								
					sum coeff_nat_unempilo if e(sample)==1, det 
					global coemin = r(min)
					global coemean = r(mean)
					global coemax = r(max)
					global coehi = r(mean)+(1.96*r(sd))
					global coelo=r(mean)-(1.96*r(sd))
					global coeintv = ($coemax-$coemin)/10
					sum natunemp_ma3 if e(sample)==1, det
					global natmin = r(min)
					global natmean = r(mean)
					global natmax = r(max)
					global nathi =  r(mean)+(1.96*r(sd))
					global natlo=r(mean)-(1.96*r(sd))
					global natintv = ($natmax-$natmin)/10
					sum occunemp_ma3 if e(sample)==1, det
					global occmin = r(min)
					global occmean = r(mean)
					global occmax = r(max)
					global occhi = r(mean)+(1.96*r(sd))
					global occlo= r(mean)-(1.96*r(sd))
					global occintv = ($occmax-$occmin)/10
					sum ourinsecurity if e(sample)==1, det
					global instmin = r(min)
					global instmean = r(mean)
					global instmax = r(max)
					global insthi = r(mean)+(1.96*r(sd))
					global instlo= r(mean)-(1.96*r(sd))
					global instintv = (${instmax}-${instmin})/10
				
			*FIGURE ELEVEN	
				est restore marginsmodel
				margins, dydx(c.natunemp_ma3) at(occunemp_ma3=($occmin($occintv)$occmax) ) 
		
				marginsplot, recast(line) recastci(rline) ciopts(lpattern(dash)) plotopts(lwidth(medthick))  ///
					   ytitle(Marginal Effect of Collective Insecurity, size(medium)) ///
					   ylabel(0(.01).03, grid glw(medium) labsize(medium) glcolor(gs12)) ///
					   xlabel(2(2)22, labsize(medium) glcolor(gs12))  graphregion(c(white)) /// 
					   xtitle(Individual Economic Insecurity, size(medium)) xlabel(, labsize(medium)) ///
					   xsize(15) ysize(10) scheme(s2mono)  title("") yline(0)
						
			*FIGURE TWELVE	
				est restore marginsmodel
				margins, dydx(c.natunemp_ma3)  at(ourinsecurity=($instmin($instintv)$instmax) ) 
		
				marginsplot, recast(line) recastci(rline) ciopts(lpattern(dash)) plotopts(lwidth(medthick))  ///
					   ytitle(Marginal Effect of Collective Insecurity, size(medium)) ///
					   ylabel(0(.01).03, grid glw(medium) labsize(medium) glcolor(gs12)) ///
					   xlabel(.05(.1).75, labsize(medium) glcolor(gs12))  graphregion(c(white)) /// 
					   xtitle(Institutional Insecurity, size(medium)) xlabel(, labsize(medium)) ///
					   xsize(15) ysize(10) scheme(s2mono)  title("") yline(0)

			*FIGURE THIRTEEN
					est restore marginsmodel
					margins, dydx(c.natunemp_ma3) at(coeff_nat_unempilo =($coemin($coeintv)$coemax) ) 
			
					marginsplot, recast(line) recastci(rline) ciopts(lpattern(dash)) plotopts(lwidth(medthick))  ///
						   ytitle(Marginal Effect of Collective Insecurity, size(medium)) ///
						   ylabel(, grid glw(medium) labsize(medium) glcolor(gs12)) ///
						   xlabel(, labsize(medium) glcolor(gs12))  graphregion(c(white)) /// 
						   xtitle(Regression Coefficient, size(medium)) xlabel(, labsize(medium)) ///
						   xsize(15) ysize(10) scheme(s2mono)  title("")  
		
			*FIGURE FOURTEEN
					est restore marginsmodel
					margins, dydx(c.occunemp_ma3) at(natunemp_ma3=($natmin($natintv)$natmax) ) 
			
					marginsplot, recast(line) recastci(rline) ciopts(lpattern(dash)) plotopts(lwidth(medthick)) ///
						   ytitle(Marginal Effect of Individual Insecurity, size(medium)) ///
						   ylabel(-.01(.01).03, grid glw(medium) labsize(medium) glcolor(gs12)) ///
						   xlabel(4(2)20, labsize(medium) glcolor(gs12))  graphregion(c(white)) /// 
						   xtitle(Collective Insecurity, size(medium)) xlabel(, labsize(medium)) ///
						   xsize(15) yline(0) ysize(10) scheme(s2mono) title("") legend(off) 

			*FIGURE FIFTEEN
					est restore marginsmodel
					margins, dydx(c.occunemp_ma3) at(ourinsecurity=($instmin($instintv)$instmax) ) 
			
					marginsplot, recast(line) recastci(rline) ciopts(lpattern(dash)) plotopts(lwidth(medthick))  ///
						   ytitle(Marginal Effect of Individual Insecurity , size(medium)) ///
						   ylabel(-.01(.01).03, grid glw(medium) labsize(medium) glcolor(gs12)) ///
						   xlabel(.05(.1).75, labsize(medium) glcolor(gs12))  graphregion(c(white)) /// 
						   xtitle(Institutional Insecurity, size(medium)) xlabel(, labsize(medium)) ///
						   xsize(15) ysize(10) scheme(s2mono)  title("") yline(0)
		
			*FIGURE SIXTEEN		
					est restore marginsmodel
					margins, dydx(c.occunemp_ma3) at(c.coeff_nat_unempilo =($coemin($coeintv)$coemax) ) 
			
					marginsplot, recast(line) recastci(rline) ciopts(lpattern(dash)) plotopts(lwidth(medthick))  ///
						   ytitle(Marginal Effect of Individual Insecurity, size(medium)) ///
						   ylabel(, grid glw(medium) labsize(medium) glcolor(gs12)) ///
						   xlabel(, labsize(medium) glcolor(gs12))  graphregion(c(white)) /// 
						   xtitle(Regression Coefficient, size(medium)) xlabel(, labsize(medium)) ///
						   xsize(15) ysize(10) scheme(s2mono)  title("") yline(0)

			*FIGURE SEVENTEEN
					est restore marginsmodel
					margins, dydx(c.ourinsecurity) at(occunemp_ma3=($occmin($occintv)$occmax) ) 
			
					marginsplot, recast(line) recastci(rline) ciopts(lpattern(dash)) plotopts(lwidth(medthick))  ///
						   ytitle(Marginal Effect of Institutional Insecurity , size(medium)) ///
						   ylabel(-.9(.3).9, grid glw(medium) labsize(medium) glcolor(gs12)) ///
						   xlabel(2(2)22, labsize(medium) glcolor(gs12))  graphregion(c(white)) /// 
						   xtitle(Individual Insecurity, size(medium)) xlabel(, labsize(medium)) ///
						   xsize(15) ysize(10) scheme(s2mono)  title("") yline(0)
	
			*FIGURE EIGHTEEN
					est restore marginsmodel
					margins, dydx(c.ourinsecurity) at(natunemp_ma3=($natmin($natintv)$natmax) ) 
			
					marginsplot, recast(line) recastci(rline) ciopts(lpattern(dash)) plotopts(lwidth(medthick)) ///
						   ytitle(Marginal Effect of Institutional Insecurity, size(medium)) ///
						   ylabel(-.9(.3).9, grid glw(medium) labsize(medium) glcolor(gs12)) ///
						   xlabel(4(2)20, labsize(medium) glcolor(gs12))  graphregion(c(white)) /// 
						   xtitle(Collective Insecurity, size(medium)) xlabel(, labsize(medium)) ///
						   xsize(15) ysize(10) scheme(s2mono) title("") yline(0)


	
		**********************APPENDIX FIGURE NINETEEN
					sum occunemp_ma3 natunemp_ma3 ourinsecurity coeff_nat_unempilo if rog2006survey==1 & c_name=="Germany" 
					sum occunemp_ma3 natunemp_ma3 ourinsecurity coeff_nat_unempilo if rog2006survey==1  &  c_name=="Canada"
					sum occunemp_ma3 natunemp_ma3 ourinsecurity coeff_nat_unempilo if rog2006survey==1  &  c_name=="Japan"
					sum occunemp_ma3 natunemp_ma3 ourinsecurity coeff_nat_unempilo if rog2006survey==1 & c_name== "Slovenia"
						
					**********************SCENARIO ONE - Low Institutional insecurity - Germany and Slovenia
					/*Germany*/
					est restore marginsmodel
					margins,   at(occunemp_ma3=($occmin($occintv)$occmax) natunemp_ma3=(10.4) ourinsecurity=(.1975) coeff_nat_unempilo=(.93))   post
					global scenario "deu2"
					marginsextract
			
					/*Slovenia*/
					est restore marginsmodel
					margins,   at(occunemp_ma3=($occmin($occintv)$occmax) natunemp_ma3=(6.1) ourinsecurity=(.16) coeff_nat_unempilo=(.9))   post
					global scenario "slo2"
					marginsextract			
			
					**********************SCENARIO TWO - Low Institutional insecurity - Canada and Japan
					/*Canada*/
					est restore marginsmodel
					margins,   at(occunemp_ma3=($occmin($occintv)$occmax) natunemp_ma3=(7) ourinsecurity=(.494) coeff_nat_unempilo=(.74))   post
					global scenario "can2"
					marginsextract
			
					/*Japan*/
					est restore marginsmodel
					margins,   at(occunemp_ma3=($occmin($occintv)$occmax) natunemp_ma3=(3) ourinsecurity=(.42) coeff_nat_unempilo=(1.06))   post
					global scenario "jap2"
					marginsextract
			
					egen occu_axis2 = fill(${occmin}(${occintv})${occmax}) 
					replace occu_axis2 = . if occu_axis2>$occmax+1
					 
					twoway (rline slo2_lower slo2_upper occu_axis2, lcolor(gs6) lpattern(dash)) ///
						   (rline deu2_lower deu2_upper occu_axis2, lcolor(black) lpattern(solid)), ///	
						   title("Low Institutional Insecurity", size(large)) ///
						   ytitle(Predicted Probability of Support, size(medium)) ///
						   ylabel(, grid glw(medium) labsize(medium) glcolor(gs12)) ///
						   xlabel(, labsize(medium) glcolor(gs12))  graphregion(c(white)) /// 
						   xtitle(Individual Insecurity, size(medium)) xlabel(, labsize(medium)) ///
						   legend(cols(1) order(1 "Slovenia, Low Collective Insecurity " ///
								  2 "Germany, High Collective Insecurity") ///
								  size(small) lcolor(black) ring(0) position(5)) ///	   
						   xsize(15) ysize(10) scheme(s2mono) ///
						   name(deu_slo2, replace)
						   graph save sim2a, replace
					twoway (rline jap2_lower jap2_upper occu_axis2, lcolor(gs6) lpattern(dash)) ///
						   (rline can2_lower can2_upper  occu_axis2, lcolor(black) lpattern(solid)), ///	
						   title("High Institutional Insecurity", size(large)) ///
						   ytitle(Predicted Probability of Support, size(medium)) ///
						   ylabel(, grid glw(medium) labsize(medium) glcolor(gs12)) ///
						   xlabel(, labsize(medium) glcolor(gs12))  graphregion(c(white)) /// 
						   xtitle(Individual Insecurity, size(medium)) xlabel(, labsize(medium)) ///
						   legend(cols(1) order(1 "Canada, Low Collective Insecurity" ///
								  2 "Japan, High Collective Insecurity") ///
								  size(small) lcolor(black)  ring(0) position(5)) ///	   
						   xsize(15) ysize(10) scheme(s2mono) ///
						   name(pol_aus, replace)
						   graph save sim2b, replace
			
					graph combine sim2a.gph sim2b.gph, ycommon c(2) scheme(s2mono)  graphregion(c(white))  ysize(15) xsize(20)  

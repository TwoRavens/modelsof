clear matrix
			clear
			set matsize 800
			set mem 500m
			
			
*** note: substitute directory location of file on local drive ***
			cd "C:\Users\dmk38\Documents\scholarship\res_note_AOT"
	
		
		
			use OSI.dta
			
			log using results, replace
				
		
		*** form left_right outlook scale-- labeled "conservrepub" here but "Left_right" in paper ****
		
		alpha libcon dem_repub, s i ge(left_right)
		zscore left_right
		replace conservrepub=z_left_right
		
		*** center scale so that Moderate/Independent = 0 ***
				
		 replace conservrepub =conservrepub+.2
		 
		 
		 	 *** values of "Left_right" for Liberal Democrat, Conservative Republican & Moderate Independent, respectively ***
		 
		 su  conservrepub if libcon ==2  & dem_repub==2
		 su conservrepub if libcon ==4 & dem_repub == 6
		 su conservrepub if libcon ==3 & dem_repub==3
		 
		*** form AOT scale ***  
		
alpha Contrary Chr Revise Weakling Intuition Ignore Search, s i ge(AOT)

		 
		 zscore AOT
		 replace AOT=z_AOT
		
		 *** create median split for conservrepub ****
		 				 
					 set seed 040706
	su conservrepub, d
	g select=uniform() if conservrepub==r(p50)
	gen ld=.
	replace ld=1 if conservrepub<=r(p50)
	replace ld=0 if conservrepub>r(p50) & conservrepub<4
	
replace ld=0 if conservrepub==r(p50) & select<.93
	
	sort select
	su select
	tab conservrepub ld
	
*** correlations for AOT, left_right, and belief in climate change ***
	
	pwcorr AOT WHYWARMER_c conservrepub
	
	**** proportion of climate change believers/nonbelivers at >= +1 SD on AOT
	
	tab WHYWARMER_c if AOT >=1
	
	**** proportion of left-of-center subjects at >= +1 SD on AOT
	
	tab ld if AOT >=1

*** generate cross product interaction variable

ge crxaot=conservrepub*AOT




*** regression analysis, Table 1***

logit WHYWARMER_c conservrepub AOT crxaot

*** pseudo R^2***

predict yhat
pwcorr yhat WHYWARMER_c, sig
di 0.573^2


**** monte carlo simulation for predicted values & figure 3 ***

*** note: for details on Monte Carlo analysis, 
*** see King, G., Tomz, M. & Wittenberg., J. Making the Most of Statistical Analyses: Improving Interpretation and Presentation. Am. J. Pol. Sci 44, 347-361 (2000).


estsimp logit WHYWARMER_c conservrepub AOT crxaot



gen ldlower=.
gen ldupper=.
gen crlower=.
gen crupper=.

ge  aotaxis = _n in 1/26 
set more off
local a = 1
while `a' <= 26 {
local m = (`a'-1)*(.04*5)+-3
setx AOT `m'
setx conservrepub -1 crxaot -.74*`m' /// simulate predicted values at 26 points on x axis for liberal democrat

simqi, genpr(MR)
replace MR=1-MR
_pctile MR, p(2.5,97.5)
replace ldlower = r(r1) if aotaxis==`a' /// save lower point of 0.95 CI

replace ldupper = r(r2) if aotaxis==`a'  /// save upper point of 0.95 CI

drop  MR

setx conservrepub 1.25 crxaot `m' /// simulate predicted values at 26 points on x axis for liberal democrat

simqi, genpr(MR)
replace MR=1-MR
_pctile MR, p(2.5,97.5)
replace crlower = r(r1) if aotaxis==`a' /// save lower point of 0.95 CI

replace crupper = r(r2) if aotaxis==`a'  /// save upper point of 0.95 CI


drop MR

local a = `a' + 1
}



*** generate Figure 3 monte carlo output ***



replace aotaxis=-3+(_n-1)*.04*5 in 1/26
sort aotaxis
ge aotaxis2=aotaxis+.02
summarize aotaxis

twoway (rspike crlower crupper aotaxis2,  ylabel(0(.25)1, nogrid angle( 0)) ///
xtitle("AOT", height(5)) xlabel(-3/2)  scale(1.3) lwidth(thick) ///
lcolor(red) title("")    graphregion( color(white))) ///
(rspike ldlower ldupper aotaxis, lwidth(thick) lcolor(blue) legend(off))


*** generated predicted probabilities for liberal democrat & conservarive republican at low & high AOT ***

*** conservative repubican high
setx mean
setx conservrepub 1.25 AOT 1 crxaot  1.25
simqi, genpr(tval)
ge crhi=1-tval
drop tval


**** conservative republican low
setx mean
setx conservrepub  1.25 AOT -1 crxaot -1.25
simqi, genpr(tval)
ge crlo=1-tval
drop tval


***** liberal democat high
setx mean
setx conservrepub -.74 AOT 1 crxaot -.74
simqi, genpr(tval)
ge ldhi=1-tval
drop tval


***** liberal democrat low
setx mean
setx conservrepub -.74 AOT -1 crxaot .74
simqi, genpr(tval)
ge ldlo=1-tval
drop tval	


*** specify values ***

su ldlo ldhi crlo crhi

**** calculate degree of polarization at low and high AOT

*** polarization at low AOT
ge loval=ldlo-crlo

*** polarization at high AOT
ge hival=ldhi-crhi


*** specify values ****
su loval hival


*** view log of results ***

view results.smcl
log close


*** create .pdf of log ***

translate results.smcl log_results.pdf



		

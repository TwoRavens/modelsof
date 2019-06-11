******************************************************************************************
***********************************  REPLICATION FILE  ***********************************
******************************************************************************************
***                   Term Limits and Collaboration Across the Aisle                   ***
***------------------------------------------------------------------------------------*** 								
***									Clint S. Swift									   ***
*** 							 Katheryn VanderMolen								   ***
***------------------------------------------------------------------------------------*** 								
***Created: 9/23/15										    						   ***
***Modified:											    						   ***
***   Any questions or concerns regarding this code or the accompanying data can be    ***
***   sent to Clint Swift (email: csswift@mizzou.edu).                                 ***
****************************************************************************************/*

The data accompanying this file (SVM2015_ReplicationData.dta) contains the folling variables
needed for the analysis:
---------------------------------------------------------------------------------------------
Variable			Label												Source
---------------------------------------------------------------------------------------------st					State Name											***postal				State Postal Abbrev.								***lchamb				Lower Chamber										***smarg				Average Party Cosponsorship Margin					Calculated by the Authors based on data from various sources. See manuscript.bipart				Proportion of Bills with Bipartisan Cosponsorship	Calculated by the Authors based on data from various sources. See manuscript.prof				Professionalization (Squire Index)					Squire (2012)tl					Term Limits											NCSL (http://www.ncsl.org/research/about-state-legislatures/chart-of-term-limits-states.aspx)t					Average Tenure										Collected by authors; see manuscript for details.t2					Average Tenure Squared								Collected by authors; see manuscript for details.t3					Average Tenure Cubed								Collected by authors; see manuscript for details.seats				Chamber Size										Book of the Statespdiv				Partisan Seat Gap									Book of the Statessmppol				Polarization										Shor 2014 (http://dx.doi.org/10.7910/DVN/26799)initiative			Initiative											Initiative and Referndum Institute (http://www.iandrinstitute.org/statewide_i%26r.htm)referenda			Referenda											Initiative and Referndum Institute (http://www.iandrinstitute.org/statewide_i%26r.htm)n_bills				Bills (1000s) Introduced							LegiScandiv					Out Chamber											Book of the Statesdiv_leg				Divided Legislature									Book of the Statesdiv_gov				Opposition Governor									Book of the Stateshvd					Electoral Party Competition (Holbrook & VanDunk)	Klarner 2013 (https://dataverse.harvard.edu/dataset.xhtml?persistentId=hdl:1902.1/22519)pp					Naive Probability									Calculated by the Authors based on data from the Book of the States; see footnote 12.tlXprof				Prof. X Term Limits									***
---------------------------------------------------------------------------------------------
*/
clear all
cd "/Users/skinnybean/Desktop"   /*set the directory*/
use "SVM2015_ReplicationData.dta", clear

******************************************************************************************
*Figure 1: Distribution of the Dependent Variables										 *
******************************************************************************************
qui sort lchamb bipart
qui by lchamb: gen order=_n 

qui twoway 	(scatter order bipart if  lchamb==1, yaxis(1) mc(none) mlab(postal) mlabp(0) mlabc(gs7) mlabs(vsmall) yscale(off)) ///
		(kdensity bipart if lchamb==1, bw(.05) yaxis(2) lcol(gs6)) ///
		, legend(off) xtitle("Proportion of Bills" "Receiving Bipartisan Cosponsorship" " ") ytitle("") ytitle(" " "Kernel Density", axis(2)) ///
		subtitle("Lower Chambers" " ") ysize(9) xsize(4) graphr(col(none)) plotr(style(none)) ///
		name(bipart1, replace) ylab(0(1)3, axis(2)) nodraw

qui twoway 	(kdensity bipart if lchamb==0, bw(.05) lcol(gs6)) ///
		(scatter order bipart if  lchamb==0, yaxis(2) yscale(off axis(2)) mc(none) mlab(postal) mlabp(0) mlabc(gs7) mlabs(vsmall)) ///
		, legend(off) xtitle("Proportion of Bills" "Receiving Bipartisan Cosponsorship" " ") ytitle("", axis(1)) ///
		subtitle("Upper Chambers" " ") ysize(9) xsize(4) graphr(col(none)) plotr(style(none)) ///
		name(bipart2, replace) ylab(0(1)3) nodraw

graph combine bipart1 bipart2, ///
	imargin(tiny) name(g1, replace) nodraw

qui drop order
qui sort lchamb smarg
qui by lchamb: gen order=_n 

qui twoway 	(scatter order smarg if  lchamb==1, yaxis(1) mc(none) mlab(postal) mlabp(0) mlabc(gs7) mlabs(vsmall) yscale(off)) ///
		(kdensity smarg if lchamb==1, bw(.05) yaxis(2) lcol(gs6)) ///
		, legend(off) xtitle("Average Cosponsorship Margin" " ") ytitle("") ytitle(" " "Kernel Density", axis(2)) ///
		subtitle("Lower Chambers" " ") ysize(9) xsize(4) graphr(col(none)) plotr(style(none)) ///
		name(smarg1, replace) ylab(0(1)4, axis(2)) nodraw
		
qui twoway 	(kdensity smarg if lchamb==0, bw(.05) lcol(gs6)) ///
		(scatter order smarg if  lchamb==0, yaxis(2) yscale(off axis(2)) mc(none) mlab(postal) mlabp(0) mlabc(gs7) mlabs(vsmall)) ///
		, legend(off) xtitle("Average Cosponsorship Margin" " ") ytitle("", axis(1)) ///
		subtitle("Upper Chambers" " ") ysize(9) xsize(4) graphr(col(none)) plotr(style(none)) ///
		name(smarg2, replace) ylab(0(1)4) nodraw

qui graph combine smarg1 smarg2, ///
	imargin(tiny) name(g2, replace) nodraw	
	
graph combine g1 g2, imargin(zero) iscale(.8) row(2) xsize(10) ysize(12) name(fig1, replace)
qui drop order

******************************************************************************************
*Table 1: Term Limits, Legislative Tenure and Bipartisan Bill Cosponsorship in the States*
******************************************************************************************
qui reg bipart tl prof hvd seats lchamb n_bills pdiv smppol initiative referenda div_leg div_gov div pp , r
est sto m1a
qui reg bipart tl prof t t2 t3 hvd seats lchamb n_bills pdiv smppol initiative referenda div_leg div_gov div pp , r 
est sto m2a
qui reg smarg tl prof hvd seats lchamb n_bills pdiv smppol initiative referenda div_leg div_gov div pp , r
est sto m1b
qui reg smarg tl prof t t2 t3 hvd seats lchamb n_bills pdiv smppol initiative referenda div_leg div_gov div pp , r
est sto m2b

esttab m1a m2a m1b m2b, l cells(b(star fmt(%9.3f)) se(par)) starl(* .1 ** .05 *** .01) ///
stats(r2_a rmse N, fmt(%9.3f %9.3f %9.0g) labels("Adj. $R^2$" "Root MSE")) ///
note("*p<.1; **p<.05; ***p<.01") mtitles("Model 1a" "Model 1b" "Model 2a" "Model 2b")  ///
title("Table 1") 

******************************************************************************************
*Figure 2: Professionalization and Bipartisan Cosponsorship in Term Limited and			 **                               Non-Term Limited States									 *
******************************************************************************************
qui twoway 	(scatter bipart prof if  lchamb==1,  by(tl, note("") legend(off)) mc(none) mlab(postal) mlabsize(vsmall) mlabc(gs1)) ///
		(scatter bipart prof if  lchamb==0,  by(tl, note("") ) mc(none) mlab(postal) mlabsize(vsmall) mlabc(gs8)) ///
		(lfit bipart prof , range(.02 .78) legend(off) by(tl)) ///
		, legend(off) xlab(0(.2).8) ylab(0(.2).8, nogrid) xtitle("Legislative Professionalization""(Squire Index)") ///
		ytitle("Proportion of Bills" "With Bipartisan Cosponsorship") name(bipart, replace) nodraw
		
qui twoway 	(scatter smarg prof if  lchamb==1,  by(tl, note("") legend(off)) mc(none) mlab(postal) mlabsize(vsmall) mlabc(gs1)) ///
		(scatter smarg prof if  lchamb==0,  by(tl, note("") ) mc(none) mlab(postal) mlabsize(vsmall) mlabc(gs8)) ///
		(lfit smarg prof , range(.02 .78) legend(off) by(tl)) ///
		, legend(off) xlab(0(.2).8) ylab(.5(.25)1, nogrid) xtitle("Legislative Professionalization""(Squire Index)") ///
		ytitle("Average Party" "Cosponsorship Margin") name(smarg, replace) nodraw
		
graph combine bipart smarg, c(1) ysize(9) xsize(6.5) name(fig2, replace)

******************************************************************************************
*Table 2: The Interactive Effects of Term Limits and Legislative Professionalization on  *
*                         Bipartisan Bill Cosponsorship									 *
******************************************************************************************
qui reg bipart tl prof tlXprof t t2 t3 hvd seats lchamb n_bills pdiv smppol initiative referenda div_leg div_gov div pp , r
est sto m3a
qui reg smarg tl prof tlXprof t t2 t3 hvd seats lchamb n_bills pdiv smppol initiative referenda div_leg div_gov div pp , r
est sto m3b

esttab m3a m3b, l cells(b(star fmt(%9.3f)) se(par)) starl(* .1 ** .05 *** .01) ///
stats(r2_a rmse N, fmt(%9.3f %9.3f %9.0g) labels("Adj. $R^2$" "Root MSE")) ///
note("*p<.1; **p<.05; ***p<.01") mtitles("Model 3a" "Model 3b" "Model 4a" "Model 4b")  ///
title("Table 2")

*******************************************************************************************
*Figure 3: Marginal Effects of Term Limits on Bipartisan Cosponsorship at Differing Levels* 
*			       		of Legislative Professionlaization.								  *
*******************************************************************************************
preserve
qui reg bipart seats lchamb n_bills pdiv smppol initiative referenda c.prof##c.tl c.t##c.t##c.t hvd pp div div_leg div_gov , r
qui margins, dydx(tl) at(prof==(0(.05).8))
qui mat x=r(table)
qui mat b=x[1..6,1..17]
qui mat m=b'
qui svmat m, names(col)
qui egen at=fill(0(.05).8)
qui replace at=round(at, .001)
qui replace at=. if _n>17

qui twoway	(rarea ul ll at, fc(gs13) lc(gs14) yline(0, lp(dot))) ///
		(scatteri  0 0 0 .8, recast(line) lpat(dot) lcol(black)) ///
		(line b at, lcol(gs5)) ///
		, legend(off) ytitle(" ") ///
		 name(me1, replace) xlab(none) ///
		 xtitle(" ") xscale(off) ylab(-1(.5).5)  plotr(sty(none)) ///
		subtitle("Proportion of Bills Receiving Bipartisan Cosponsorship" "(Model 3a)", ring(0)) ///
		ytitle("Marginal Effect") nodraw

qui reg smarg seats lchamb n_bills pdiv smppol initiative referenda c.prof##c.tl c.t##c.t##c.t hvd pp div div_leg div_gov , r
qui margins, dydx(tl) at(prof==(0(.05).8))
qui mat x=r(table)
qui mat b=x[1..6,1..17]
qui mat m=b'
qui svmat m, names(matcol)	
		
qui twoway	(rarea mul mll at, fc(gs13) lc(gs14) yline(0, lp(dot))) ///
		(scatteri  0 0 0 .8, recast(line) lpat(dot) lcol(black)) ///
		(line mb at, lcol(gs5)) ///
		, legend(off) ytitle(" ") ///
		name(me2, replace) xlab(none) ///
		xtitle(" ") xscale(off) nodraw ylab(-.25(.25).75) plotr(sty(none)) ///
		subtitle("Average Party Cosponsorship Margin" "(Model 3b)", ring(0)) ///
		ytitle("Marginal Effect")

qui twoway 	(hist prof, col(gs12) lc(gs10) w(.03)) ///
		(kdensity prof, lcol(gs3)) ///
		, legend(off) plotr(sty(none)) ///
		ytitle("") name(dist, replace) ylab(none) ///
		xlab(0(.2).8) fysize(22) yscale(outergap(9.5) noline) nodraw ///
		xtitle("Legislative Professionalization" "(Squire Index)")  

qui graph combine me1 me2, c(1) xsize(6) ysize(6) imargin(0 0 0 5) xcom name(me, replace) iscale(*1.3) nodraw
graph combine me dist, c(1) xsize(6) ysize(7) imargin(zero) xcom name(fig3, replace)
restore

**********************************************************************************************
*Table 3: Marginal Effects of Professionalization in Term Limited and Non-Term Limited States*
**********************************************************************************************
foreach var of varlist bipart smarg{
	qui reg `var' c.tl##c.prof t t2 t3 hvd seats lchamb n_bills pdiv smppol initiative referenda div_leg div_gov div pp , r
	margins, dydx(prof) at(tl==(0 1))
}

*******************************************************************************************
*Figure 4: Marginal Effects of Average Tenure on the Proportion of Bills with Bipartisan  **            Cosponsorship and the Average Party Cosponsorship Margin				      *
*******************************************************************************************
preserve
qui reg bipart seats lchamb n_bills pdiv smppol initiative referenda c.prof##c.tl c.t##c.t##c.t hvd pp div div_leg div_gov , r
qui margins, dydx(t) at(t==(0(.5)15))
qui mat x=r(table)
qui mat b=x[1..6,1..31]
qui mat m=b'
qui svmat m, names(col)
qui egen at=fill(0(.5)15)
qui replace at=round(at, .001)
qui replace at=. if _n>31

qui twoway	(rarea ul ll at, fc(gs13) lc(gs14) yline(0, lp(dot))) ///
		(scatteri  0 0 0 15, recast(line) lpat(dot) lcol(black)) ///
		(line b at, lcol(gs5)) ///
		, legend(off) ytitle(" ") ///
		 name(me1, replace) xlab(none) xscale(off) ///
		 xtitle(" ") ylab(-.1(.1).1) nodraw plotr(sty(none)) ///
		subtitle("Proportion of Bills Receving Bipartisan Cosponsorship" "(Model 3a)", ring(0)) ///
		ytitle("Marginal Effect of Tenure") 

qui reg smarg seats lchamb n_bills pdiv smppol initiative referenda c.prof##c.tl c.t##c.t##c.t hvd pp div div_leg div_gov , r
qui margins, dydx(t) at(t==(0(.5)15))
qui mat x=r(table)
qui mat b=x[1..6,1..31]
qui mat m=b'
qui svmat m, names(matcol)	
		
qui twoway	(rarea mul mll at, fc(gs13) lc(gs14) yline(0, lp(dot))) ///
		(scatteri  0 0 0 15, recast(line) lpat(dot) lcol(black)) ///
		(line mb at, lcol(gs5)) ///
		, legend(off) ytitle(" ") ///
		name(me2, replace) xlab(none) ///
		xtitle(" ") xscale(off) nodraw ylab(-.1(.1).1) plotr(sty(none)) ///
		subtitle("Average Party Cosponsorship Margin" "(Model 3b)", ring(0)) ///
		ytitle("Marginal Effect of Tenure")


qui twoway 	(hist t, col(gs12) lc(gs10) w(.4)) ///
		(kdensity t, lcol(gs3)) ///
		, legend(off) plotr(sty(none)) ///
		ytitle("") name(dist, replace) ylab(none) ///
		xlab(0(5)15) fysize(22) yscale(outergap(9.5) noline) nodraw ///
		xtitle("Average Tenure" "(Years)")  

qui graph combine me1 me2, c(1) xsize(6) ysize(6) imargin(0 0 0 5) xcom name(me, replace) iscale(*1.3) nodraw
graph combine me dist, c(1) xsize(6) ysize(7) imargin(zero) xcom name(fig4, replace)
restore
*******************************************************************************************
*Figure 5: Substantive Effects of Term Limits and Professionalization					  *
*******************************************************************************************
preserve
	qui estsimp reg bipart seats lchamb n_bills pdiv smppol initiative referenda tl prof tlXprof t t2 t3 hvd pp div div_leg div_gov , r
	tempfile subeff_bipart
	postfile ev prof tl mn se low hi using `subeff_bipart', replace

	qui foreach i of numlist 0(.01)1 {		// i numlist corresponds to values of PROF
		foreach v of numlist 0 1{		// v numlist is values of tl	  
		qui setx seats mean lchamb 1 n_bills mean pdiv mean smppol mean initiative 0 referenda 0  tl `v'  prof `i' tlXprof `v'*`i' t 6.5 t2 6.5*6.5 t3 6.5*6.5*6.5 hvd 39.84 pp mean div 0 div_leg 0 div_gov 0
		qui simqi, ev genev(ebipart)       // This is the Clarify command for the random generation based on parameter estimates and the estimated covariance matrix 
		qui _pctile ebipart, p(2.5,97.5)
		qui local low = r(r1)
		qui local hi = r(r2)
		qui sum ebipart
		qui local mn = `r(mean)'
		qui local se = `r(sd)'
		qui drop ebipart
		qui post ev (`i') (`v') (`mn') (`se') (`low') (`hi')
	}
	}
postclose ev
restore
preserve
	qui use `subeff_bipart', clear
	qui lab def tl 0 "No Term Limits" 1 "Term Limits"
	qui lab val tl tl
	qui replace low=-.11 if low<-.11
	qui replace hi=1.1 if hi>1.1
	qui gen sig=0
	qui local n=1
	qui local m=2
	qui local i=1
	qui while `i'<= 201 {
		replace sig=1 in `n' if lo[`n']>hi[`m']
		replace sig=1 in `m' if lo[`n']>hi[`m']
		local n=`n'+1
		local m=`m'+1
		local i=`i'+1
	}
	qui twoway 	(rarea low hi prof if prof<=.81, fc(gs13) lc(gs14)) ///
		(line mn prof if prof<=.81, lcol(gs6) by(tl, note("")  legend(off) )) ///
		(line mn prof if prof<=.81 & sig==1, lcol(black) lw(thick) by(tl, note(""))) ///
	   	,  xscale(range(0 .8)) xlabel(0(.2).8) yscale(r(-.11 1.1)) ylabel(0(.5)1 0, nogrid) ///
	   	ytitle("Predicted Proportion" "of Bills w/ Bipartisan Cosponsorship") ///
	   	xtitle("Legislative Professionalization" "(Squire Index)") ///
	   	 name(tl, replace) legend( order()) nodraw
restore

preserve
	estsimp reg smarg seats lchamb n_bills pdiv smppol initiative referenda tl prof tlXprof t t2 t3 hvd pp div div_leg div_gov , r
	tempfile subeff_smarg
	postfile ev prof tl mn se low hi using `subeff_smarg', replace
	foreach i of numlist 0(.01)1 {		// i numlist corresponds to values of PROF
	foreach v of numlist 0 1{		// v numlist is values of tl	  
		setx seats mean lchamb 1 n_bills mean pdiv mean smppol mean initiative 0 referenda 0  tl `v'  prof `i' tlXprof `v'*`i' t 6.5 t2 6.5*6.5 t3 6.5*6.5*6.5 hvd 39.84 pp mean div 0 div_leg 0 div_gov 0
		simqi, ev genev(ebipart)       // This is the Clarify command for the random generation based on parameter estimates and the estimated covariance matrix 
		_pctile ebipart, p(2.5,97.5)
		local low = r(r1)
		local hi = r(r2)	
		qui sum ebipart
		local mn = `r(mean)'
		local se = `r(sd)'	
		drop ebipart	
		post ev (`i') (`v') (`mn') (`se') (`low') (`hi')
	}
	}
	postclose ev
restore

preserve
	qui use `subeff_smarg', clear
	qui lab def tl 0 "No Term Limits" 1 "Term Limits"
	qui lab val tl tl
	qui replace low=.5 if low<0.5
	qui replace hi=1.1 if hi>1.1
	qui gen sig=0
	qui local n=1
	qui local m=2
	qui local i=1
	qui while `i'<= 201 {
		replace sig=1 in `n' if hi[`n']<lo[`m']
		replace sig=1 in `m' if hi[`n']<lo[`m']
		local n=`n'+1
		local m=`m'+1
		local i=`i'+1
		}
		 
	qui twoway 	(rarea low hi prof if prof<=.81, fc(gs13) lc(gs14)) ///
		(line mn prof if prof<=.81, lcol(gs6) by(tl, note("")  legend(off) )) ///
		(line mn prof if prof<=.81 & sig==1, lcol(black) lw(thick) by(tl, note(""))) ///
	   	,  xlabel(0(.2).8) ylabel(1 .5, nogrid) yscale(r(.5 1.1)) ///
	   	ytitle("Predicted Average" "Party Cosponsorship Margin") ///
	   	xtitle("Legislative Professionalization" "(Squire Index)") ///
	   	 name(tl0, replace) legend( order()) nodraw
restore
graph combine tl tl0, c(1) ysize(7.5) xsize(5.3) imargin(1 1 .1 .1) name(fig5, replace)

*******************************************************************************************
*Figure 6: Substantive Effects of Average Tenure   										  *
*******************************************************************************************
preserve
	qui estsimp reg bipart seats lchamb n_bills pdiv smppol initiative referenda tl prof tlXprof t t2 t3 , r
	qui tempfile subeff_tenure1
	qui postfile ev tenure mn se low hi using `subeff_tenure1', replace
	qui foreach i of numlist 0(1)15 {		// i numlist corresponds to values of tenure	  
		setx seats mean lchamb 1 n_bills mean pdiv mean smppol mean initiative 0 referenda 0  tl 0  prof mean tlXprof 0 t `i' t2 `i'*`i' t3 `i'*`i'*`i'
		simqi, ev genev(ebipart)       // This is the Clarify command for the random generation based on parameter estimates and the estimated covariance matrix 
		_pctile ebipart, p(2.5,97.5)
		local low = r(r1)
		local hi = r(r2)
		qui sum ebipart
		local mn = `r(mean)'
		local se = `r(sd)'
		drop ebipart	
		post ev (`i') (`mn') (`se') (`low') (`hi')
	}
	postclose ev
restore

preserve
	use `subeff_tenure1', clear
	gen by=0
	save, replace
restore

preserve
	qui estsimp reg smarg seats lchamb n_bills pdiv smppol initiative referenda tl prof tlXprof t t2 t3 , r
	qui tempfile subeff_tenure2
	qui postfile ev tenure mn se low hi using `subeff_tenure2', replace
	qui foreach i of numlist 0(1)15 {		// i numlist corresponds to values of tenure	  
		setx seats mean lchamb 1 n_bills mean pdiv mean smppol mean initiative 0 referenda 0  tl 0  prof mean tlXprof 0 t `i' t2 `i'*`i' t3 `i'*`i'*`i'
		simqi, ev genev(ebipart)       // This is the Clarify command for the random generation based on parameter estimates and the estimated covariance matrix
		_pctile ebipart, p(2.5,97.5)
		local low = r(r1)
		local hi = r(r2)
		qui sum ebipart
		local mn = `r(mean)'
		local se = `r(sd)'
		drop ebipart
		post ev (`i') (`mn') (`se') (`low') (`hi')
	}
	postclose ev
restore

preserve
	use `subeff_tenure2', clear
	qui gen by=1
	qui append using `subeff_tenure1'
	qui lab def by 0 `" "Proportion Bipartisan" "(Model 3a)" "' 1 `" "Average Cosponsorship Margin" "(Model 3b)" "'
	qui lab val by by
	qui twoway 	(rarea hi low tenure, fc(gs13) lc(gs14)) ///
		(line mn tenure, lcol(gs6) by(by, note("")  legend(off) )) ///
	   	,  xlabel(0(5)15) ylabel(0(.5)1 0, nogrid) ///
	   	ytitle("Predicted Value") ///
	   	xtitle("Average Legislator Tenure") ///
	   	 name(fig6, replace) legend( order()) 
restore

*******************************************************************************************
*Figure 7: Aggregate Effects of Term Limits and Professionalization on the Percentage of  *
*                  Bills Receiving Bipartisan Cosponsorship								  *
*******************************************************************************************
/*
A basemap file that defines the shapes of the states is required to generate the maps in 
Stata (help spmaps). Here we reproduce the values used in the maps in figure 7 in table format.
*/
preserve
gen tl_orig=tl
gen prof_orig=prof
qui sum prof 
gen sd=2*r(sd)
qui reg bipart seats lchamb n_bills pdiv smppol initiative referenda  c.tl##c.prof c.t##c.t##c.t hvd pp div div_leg div_gov , r
replace prof=prof+sd
replace tl=0
predict map1, xb
replace tl=tl_orig
replace prof=prof_orig
qui reg bipart seats lchamb n_bills pdiv smppol initiative referenda  c.tl##c.prof c.t##c.t##c.t hvd pp div div_leg div_gov , r
replace prof=prof+sd
predict map2, xb
replace tl=tl_orig
replace prof=prof_orig
qui reg bipart seats lchamb n_bills pdiv smppol initiative referenda  c.tl##c.prof c.t##c.t##c.t hvd pp div div_leg div_gov , r
replace prof=prof+sd
replace tl=1
predict map3, xb
replace tl=tl_orig
replace prof=prof_orig
qui reg bipart seats lchamb n_bills pdiv smppol initiative referenda  c.tl##c.prof c.t##c.t##c.t hvd pp div div_leg div_gov , r
replace tl=0
predict map4, xb
replace tl=tl_orig
replace prof=prof_orig
qui reg bipart seats lchamb n_bills pdiv smppol initiative referenda  c.tl##c.prof c.t##c.t##c.t hvd pp div div_leg div_gov , r
replace tl=1
predict map6, xb
replace tl=tl_orig
replace prof=prof_orig
qui reg bipart seats lchamb n_bills pdiv smppol initiative referenda  c.tl##c.prof c.t##c.t##c.t hvd pp div div_leg div_gov , r
replace prof=prof-sd
replace tl=0
predict map7, xb
replace tl=tl_orig
replace prof=prof_orig
qui reg bipart seats lchamb n_bills pdiv smppol initiative referenda  c.tl##c.prof c.t##c.t##c.t hvd pp div div_leg div_gov , r
replace prof=prof-sd
predict map8, xb
replace tl=tl_orig
replace prof=prof_orig
qui reg bipart seats lchamb n_bills pdiv smppol initiative referenda  c.tl##c.prof c.t##c.t##c.t hvd pp div div_leg div_gov , r
replace prof=prof-sd
replace tl=1
predict map9, xb
replace tl=tl_orig
replace prof=prof_orig
gen map5=bipart
mean map* , vce(bootstrap)
mat mean = e(b)'
mat dis = J(9,9,.)
foreach c of numlist 1/9{
	foreach r of numlist 1/9{
		local row = mean[`r',1]
		local col = mean[`c',1]
		mat dis[`r',`c']= abs(`row'-`col')	
	}
} 
mat li dis
pwcorr map*
foreach n of numlist 1(1)9{
	replace map`n'=0 if map`n'<0
	replace map`n'=1 if map`n'>1
	}
	
table st if lchamb==1, c(mean map1 mean map2 mean map3 mean map4 mean map5)
table st if lchamb==1, c(mean map6 mean map7 mean map8 mean map9)
restore

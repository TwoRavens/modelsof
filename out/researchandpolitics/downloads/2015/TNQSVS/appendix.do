* "Vintage Errors" Replication Material (Appendix)
* appendix.do
* This do-file allows the reproduction in order of appearance of all figures
* and tables in the online appendix to Kayser and Leininger (2015) "Vintage Errors"
* Replication material for online appendix in seperate file
* Author contact: Arndt Leininger, a.leininger@phd.hertie-school.org
* Last updated: 2 May 2015

* cd //set your working directory here.

* adjust settings
set more off
set scheme s1mono

********************************************************************************
* Figure 1
********************************************************************************

/*
Figure 1: Absolute forecasting error against vintage number. Regression slope based on model
in Table 1 in the main paper. Statistically significant coefficients (p < .05) indicated by solid
line).
*/

*******************
* Lewis-Beck & Tien
*******************

use "data.dta"

* Create the variables to hold the predicted popular vote share obtained with 
* different vintages
forvalues vintage=1984(1)2014{
	gen yhat_lbt_v`vintage'=.
	gen e_lbt_v`vintage'=.
	gen eabs_lbt_v`vintage'=.
	gen diff_eabs_lbt_v`vintage'=.
}

gen r2_vp=.

* Loop through elections 1984 (id=10) to 2012 (id=17) and vintages 84 to 2012 for 
* out-of-sample-forecasts
forvalues loopid=10/17 { //loop through elections

	forvalues vintage=1984(1)2014 { //loop through vintages 
																											 //for a given election
			quietly reg vote july_popularity gndp_change_v`vintage' if id<`loopid'
			replace r2_vp = e(r2) if id==`loopid' & year==`vintage'
			quietly predict yhat_temp 
			quietly replace yhat_lbt_v`vintage'=yhat_temp if id==`loopid'
			quietly replace e_lbt_v`vintage'=yhat_lbt_v`vintage'-vote
			quietly replace eabs_lbt_v`vintage'=abs(e_lbt_v`vintage')
			display `vintage' " " `loopid' ": " "eabs_lbt_v`=1944+4*`loopid''"
			replace diff_eabs_lbt_v`vintage' = eabs_lbt_v`vintage' - eabs_lbt_v`=1944+4*`loopid'' if id==`loopid'
			quietly drop yhat_temp
			display `vintage' " " `loopid'
	}
	
} //we now have forecast for election 1984-2012 using vintages election year-2012

* keep only year and prediction errors
keep year eabs_lbt_v* diff_eabs_lbt_v*

*reshape to long format
reshape long eabs_lbt_v diff_eabs_lbt_v, i(year) j(vintage)

drop if eabs_lbt_v==.

gen lag=vintage-year

sort lag

reg diff_eabs_lbt_v lag if diff_eabs_lbt_v!=0, noconstant cluster(year)

local Msize "msize(large)"
twoway (scatter eabs_lbt_v lag if year == 1984, msymbol(o) `Msize') ///
	(scatter eabs_lbt_v lag if year == 1988, msymbol(d) `Msize') ///
	(scatter eabs_lbt_v lag if year == 1992, msymbol(t) `Msize') ///
	(scatter eabs_lbt_v lag if year == 1996, msymbol(s) `Msize') ///
	(scatter eabs_lbt_v lag if year == 2000, msymbol(oh) `Msize') ///
	(scatter eabs_lbt_v lag if year == 2004, msymbol(dh) `Msize') ///
	(scatter eabs_lbt_v lag if year == 2008, msymbol(th) `Msize') ///
	(scatter eabs_lbt_v lag if year == 2012, msymbol(sh) `Msize') ///
	(function y=1.8+_b[lag]*x, range(1 30) lcolor(black) lwidth(medthick)) ///
	|| , xscale(range(0(4)30)) xlabel(0(4)30, labsize(large)) ///
	xtitle(Vintage Number, size(large)) yscale(range(0 7)) ///
  ytitle(Absolute Prediction error, size(large)) ylabel(,labsize(large)) ///
  title("Lewis-Beck and Tien's core model", size(huge)) ///
	legend(label(1 "1984") label(2 "1988") label(3 "1992") ///
		label(4 "1996") label(5 "2000") label(6 "2004") ///
		label(7 "2008") label(8 "2012") cols(4) order(1 2 3 4 5 6 7 8) ///
		region(lwidth(none)) ring(0) position(1) colgap(*.5)) ///
		name(fig2lbt)	


clear


************
* Abramowitz
************

use "data.dta"

* Create the variables to hold the predicted popular vote share obtained 
* with different vintages
foreach vintage in 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 00 01 02 ///
	03 04 05 06 07 08 09 10 11 12 13 14 {
	gen yhat_a_v`vintage'=.
	gen e_a_v`vintage'=.
	gen eabs_a_v`vintage'=.
	gen diff_eabs_a_v`vintage'=.
}

gen r2_vp=.

forvalues loopid=10/17 { //loop through elections

	foreach vintage in 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 00 01 02 ///
	03 04 05 06 07 08 09 10 11 12 13 14 { //loop through vintages for a given election
			quietly reg vote netapp rgndpQ2gr`vintage'_agr term1inc if id<`loopid'
			replace r2_vp = e(r2) if id==`loopid' & vintage=="v`vintage'"
			quietly predict yhat_temp 
			quietly replace yhat_a_v`vintage'=yhat_temp if id==`loopid'
			quietly replace e_a_v`vintage'=yhat_a_v`vintage'-vote
			quietly replace eabs_a_v`vintage'=abs(e_a_v`vintage')
			if `loopid' < 14 replace diff_eabs_a_v`vintage' = eabs_a_v`vintage' - eabs_a_v`=44+4*`loopid'' if id==`loopid'
			if `loopid' == 14 replace diff_eabs_a_v`vintage' = eabs_a_v`vintage' - eabs_a_v00 if id==`loopid'
			if `loopid' > 14 & `loopid' < 17 replace diff_eabs_a_v`vintage' = eabs_a_v`vintage' - eabs_a_v0`=44+4*`loopid'-100' if id==`loopid'
			if `loopid' == 17 replace diff_eabs_a_v`vintage' = eabs_a_v`vintage' - eabs_a_v`=44+4*`loopid'-100' if id==`loopid'
			quietly drop yhat_temp
			display `vintage' " " `loopid'
	}
	
}  // we now have forecast for election 1984-2012 using 
   // vintages election year-2012 and real-time data

* keep only year and prediction errors
keep year eabs_a_v* diff_eabs_a_v*

* prepare data for reshaping
forvalues vintage=84(1)99 {
	rename eabs_a_v`vintage' eabs_a_v19`vintage'
	rename diff_eabs_a_v`vintage' diff_eabs_a_v19`vintage'
} //switch to long format years for reshape to recognize as numbers

foreach vintage in 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 {
	rename eabs_a_v`vintage' eabs_a_v20`vintage'
	rename diff_eabs_a_v`vintage' diff_eabs_a_v20`vintage'
} //switch to long format years for reshape to recognize as numbers

*reshape to long format
reshape long eabs_a_v diff_eabs_a_v, i(year) j(vintage)

drop if eabs_a_v==.

gen lag=vintage-year

sort lag

reg diff_eabs_a_v lag if diff_eabs_a_v!=0, noconstant cluster(year)

local Msize "msize(large)"
twoway (scatter eabs_a_v lag if year == 1984, msymbol(o) `Msize') ///
	(scatter eabs_a_v lag if year == 1988, msymbol(d) `Msize') ///
	(scatter eabs_a_v lag if year == 1992, msymbol(t) `Msize') ///
	(scatter eabs_a_v lag if year == 1996, msymbol(s) `Msize') ///
	(scatter eabs_a_v lag if year == 2000, msymbol(oh) `Msize') ///
	(scatter eabs_a_v lag if year == 2004, msymbol(dh) `Msize') ///
	(scatter eabs_a_v lag if year == 2008, msymbol(th) `Msize') ///
	(scatter eabs_a_v lag if year == 2012, msymbol(sh) `Msize') ///
	(function y=2.2+_b[lag]*x, range(1 30) lpattern(dash) lcolor(black) lwidth(medthick)) ///
	|| , xscale(range(0(4)30)) xlabel(0(4)30, labsize(large)) ///
	xtitle(Vintage number, size(large)) yscale(range(0(1)8)) ylabel(0(2)8, labsize(large)) ///
  ytitle(Absolute Prediction error, size(large)) ///
	title("Abramowitz's Time for Change model", size(huge)) ///
	legend(label(1 "1984") label(2 "1988") label(3 "1992") ///
		label(4 "1996") label(5 "2000") label(6 "2004") ///
		label(7 "2008") label(8 "2012") cols(4) order(1 2 3 4 5 6 7 8) ///
		region(lwidth(none)) ring(0) position(1) colgap(*.5)) ///
		name(fig2a)
		
clear

**********
* Campbell
**********

use "data.dta"

* Create Campbell Style vintage growth variable
foreach vintage in 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 00 01 02 ///
	03 04 05 06 07 08 09 10 11 12 13 14 {
	gen c_rgndpQ2gr`vintage'_agr=(rgndpQ2gr`vintage'_agr-2.5)*incweight
}

* Create the variables to hold the predicted popular vote share obtained 
* with different vintages
foreach vintage in 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 00 01 02 ///
	03 04 05 06 07 08 09 10 11 12 13 14 {
	gen yhat_c_v`vintage'=.
	gen e_c_v`vintage'=.
	gen eabs_c_v`vintage'=.
	gen diff_eabs_c_v`vintage'=.
}

gen r2_vp=.

* Loop through elections 1984 (id=10) to 2012 (id=17) and vintages 84 to 2012 for 
* out-of-sample-forecasts
forvalues loopid=10/17 { //loop through elections

	foreach vintage in 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 00 01 02 ///
	03 04 05 06 07 08 09 10 11 12 13 14 { //loop through vintages for a given election
			quietly reg vote earlyseptemberpoll c_rgndpQ2gr`vintage'_agr if id<`loopid'
			replace r2_vp = e(r2) if id==`loopid' & vintage=="v`vintage'"
			quietly predict yhat_temp 
			quietly replace yhat_c_v`vintage'=yhat_temp if id==`loopid'
			quietly replace e_c_v`vintage'=yhat_c_v`vintage'-vote
			quietly replace eabs_c_v`vintage'=abs(e_c_v`vintage')
			display `vintage' " " `loopid' ": " "eabs_c_v`=44+4*`loopid''"
			if `loopid' < 14 replace diff_eabs_c_v`vintage' = eabs_c_v`vintage' - eabs_c_v`=44+4*`loopid'' if id==`loopid'
			if `loopid' == 14 replace diff_eabs_c_v`vintage' = eabs_c_v`vintage' - eabs_c_v00 if id==`loopid'
			if `loopid' > 14 & `loopid' < 17 replace diff_eabs_c_v`vintage' = eabs_c_v`vintage' - eabs_c_v0`=44+4*`loopid'-100' if id==`loopid'
			if `loopid' == 17 replace diff_eabs_c_v`vintage' = eabs_c_v`vintage' - eabs_c_v`=44+4*`loopid'-100' if id==`loopid'
			quietly drop yhat_temp
			display `vintage' `loopid'
	}
	
} //we now have forecast for election 1984-2012 using vintages election year-2012

* keep only year and prediction errors
keep year eabs_c_v* diff_eabs_c_v*

*reshape to long format

forvalues vintage=84(1)99 {
	rename eabs_c_v`vintage' eabs_c_v19`vintage'
	rename diff_eabs_c_v`vintage' diff_eabs_c_v19`vintage'
} //switch to long format years for reshape to recognize as numbers

foreach vintage in 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 {
	rename eabs_c_v`vintage' eabs_c_v20`vintage'
	rename diff_eabs_c_v`vintage' diff_eabs_c_v20`vintage'
} //switch to long format years for reshape to recognize as numbers

reshape long eabs_c_v diff_eabs_c_v, i(year) j(vintage)

drop if eabs_c_v==.

gen lag=vintage-year

sort lag

reg diff_eabs_c_v lag if diff_eabs_c_v!=0, noconstant cluster(year)

local Msize "msize(large)"
twoway (scatter eabs_c_v lag if year == 1984, msymbol(o) `Msize') ///
	(scatter eabs_c_v lag if year == 1988, msymbol(d) `Msize') ///
	(scatter eabs_c_v lag if year == 1992, msymbol(t) `Msize') ///
	(scatter eabs_c_v lag if year == 1996, msymbol(s) `Msize') ///
	(scatter eabs_c_v lag if year == 2000, msymbol(oh) `Msize') ///
	(scatter eabs_c_v lag if year == 2004, msymbol(dh) `Msize') ///
	(scatter eabs_c_v lag if year == 2008, msymbol(th) `Msize') ///
	(scatter eabs_c_v lag if year == 2012, msymbol(sh) `Msize') ///
	(function y=2.5+_b[lag]*x, range(1 30) lcolor(black) lwidth(thick)) /// ///
	|| , xscale(range(0(4)30)) xlabel(0(4)30, labsize(large)) ///
	xtitle(Vintage Number, size(large)) ylabel(, labsize(large)) ///
  ytitle(Absolute Prediction error, size(large)) ///
	title("Campbell's Trial-Heat model", size(huge)) ///
	legend(label(1 "1984") label(2 "1988") label(3 "1992") ///
		label(4 "1996") label(5 "2000") label(6 "2004") ///
		label(7 "2008") label(8 "2012") cols(4) order(1 2 3 4 5 6 7 8) ///
		region(lwidth(none)) ring(0) position(3) colgap(*.5)) ///
		name(fig2c)

clear
		

***************
* End-heuristic
***************

use "data.dta"

* Create the variables to hold the predicted popular vote share obtained with 
* different vintages
forvalues vintage=1984(1)2014{
	gen yhat_kl_v`vintage'=.
	gen e_kl_v`vintage'=.
	gen eabs_kl_v`vintage'=.
	gen diff_eabs_kl_v`vintage'=.
}

gen r2_vp=.

* Loop through elections 1984 (id=10) to 2012 (id=17) and vintages 84 to 2012 for 
* out-of-sample-forecasts
forvalues loopid=10/17 { //loop through elections

	forvalues vintage=1984(1)2014 { //loop through vintages 
																											 //for a given election
			quietly reg vote  july_popularity wgr2_1_v`vintage' if id<`loopid'
			quietly replace r2_vp = e(r2) if id==`loopid' & `vintage'==year[`loopid']
			quietly predict yhat_temp 
			quietly replace yhat_kl_v`vintage'=yhat_temp if id==`loopid'
			quietly replace e_kl_v`vintage'=yhat_kl_v`vintage'-vote
			quietly replace eabs_kl_v`vintage'=abs(e_kl_v`vintage')
			display `vintage' " " `loopid' ": " "eabs_kl_v`=1944+4*`loopid''"
			replace diff_eabs_kl_v`vintage' = eabs_kl_v`vintage' - eabs_kl_v`=1944+4*`loopid'' if id==`loopid'
			quietly drop yhat_temp
			
	}
	
} //we now have forecast for election 1984-2012 using vintages election year-2012


* keep only year and prediction errors
keep year eabs_kl_v* diff_eabs_kl_v*

*reshape to long format
reshape long eabs_kl_v diff_eabs_kl_v, i(year) j(vintage)

drop if eabs_kl_v==.

gen lag=vintage-year

sort lag

reg diff_eabs_kl_v lag if diff_eabs_kl_v!=0, noconstant cluster(year)

local Msize "msize(large)"
twoway (scatter eabs_kl_v lag if year == 1984, msymbol(o) `Msize') ///
	(scatter eabs_kl_v lag if year == 1988, msymbol(d) `Msize') ///
	(scatter eabs_kl_v lag if year == 1992, msymbol(t) `Msize') ///
	(scatter eabs_kl_v lag if year == 1996, msymbol(s) `Msize') ///
	(scatter eabs_kl_v lag if year == 2000, msymbol(oh) `Msize') ///
	(scatter eabs_kl_v lag if year == 2004, msymbol(dh) `Msize') ///
	(scatter eabs_kl_v lag if year == 2008, msymbol(th) `Msize') ///
	(scatter eabs_kl_v lag if year == 2012, msymbol(sh) `Msize') ///
	(function y=1.6+_b[lag]*x, range(1 30) lcolor(black) lwidth(medthick)) ///
	|| , xscale(range(0(4)30)) xlabel(0(4)30, labsize(large)) ///
	xtitle(Vintage Number, size(large)) ylabel(, labsize(large)) ///
  ytitle(Absolute Prediction error, size(large)) ///
	title("End-heuristic model", size(huge)) ///
	legend(label(1 "1984") label(2 "1988") label(3 "1992") ///
		label(4 "1996") label(5 "2000") label(6 "2004") ///
		label(7 "2008") label(8 "2012") cols(4) order(1 2 3 4 5 6 7 8) ///
		region(lwidth(none)) ring(0) position(1) colgap(*.5)) ///
		name(fig2kl)
		
* display all four graphs
* graph combine fig2lbt fig2a fig2c fig2kl		

clear


********************************************************************************
* Table 1
********************************************************************************

/*
Table 1: Coefficient estimates for real-time growth estimates and difference between most-
recent vintage and real-time growth estimates.
*/

use "data.dta"

************************
* 1 Create new variables
************************

*
* Lewis-Beck and Tien model
*

forvalues vintage=1984(4)2012 {
	gen lbt_diff_v`vintage' = gndp_change_v`vintage' - rt_gndp_change_ext
}



*
* Abramowitz model
*
foreach vintage in 84 88 92 96 00 04 08 12 {
	gen a_diff_v`vintage' = rgndpQ2gr`vintage'_agr - rt_gndpq2agr_ext
}

*
* Campbell model
*

* Create Campbell Style vintage growth variable
foreach vintage in 84 88 92 96 00 04 08 12 14 {
	gen c_rgndpQ2gr`vintage'_agr=(rgndpQ2gr`vintage'_agr-2.5)*incweight
}

* Create Campbell Style real-time growth variable
gen c_rt_rgndpq2agr=(rt_rgndpq2agr-2.5)*incweight 
gen c_rt_gndpq2agr_ext=(rt_gndpq2agr_ext-2.5)*incweight

foreach vintage in 84 88 92 96 00 04 08 12 {
	gen c_diff_v`vintage' = c_rgndpQ2gr`vintage'_agr - c_rt_gndpq2agr_ext
}

*
* End-heuristic model
*
forvalues vintage=1984(4)2012 {
	gen kl_diff_v`vintage' = wgr2_1_v`vintage' - wgr2_1_rtext
}

*******************
* 2 Estimate models
*******************

*
* Lewis-Beck and Tien model
*

forvalues vintage=1984(4)2012 {
	eststo lbt_diff_`vintage': quiet  reg vote july_popularity rt_gndp_change_ext lbt_diff_v`vintage' if year < `vintage' 
}
esttab lbt_diff*, p compress wide 

*
* Abramowitz model
*

forvalues loopid=10/17 {
local vintage = y[`loopid']
eststo a_diff_`vintage': quiet reg vote netapp rt_gndpq2agr_ext term1inc a_diff_v`vintage' if _n < `loopid'
}
esttab a_diff*, p compress wide

*
* Campbell model
*

forvalues loopid=10/17 {
local vintage = y[`loopid']
eststo c_diff_`vintage': quiet reg vote earlyseptemberpoll c_rt_gndpq2agr_ext c_diff_v`vintage' if _n < `loopid' 
}
esttab c_diff*, p compress wide

*
* End-heuristic model
*

forvalues vintage=1984(4)2012 {
eststo kl_diff_`vintage': quiet reg vote  july_popularity wgr2_1_rtext kl_diff_v`vintage' if year < 2012
}
esttab kl_diff*, p compress wide

* Table 1 of the appendix has been manually compiled from the output generated
* by the code above.

clear


********************************************************************************
* Table 2
********************************************************************************

/*
Table 2: Quarterly and annual growth rates for 1991 and 1992 (ony pre-election quarters).
August 2014 vintage against real-time growth estimates.
*/	

* Values manually collected from ALFRED dataset.


********************************************************************************
* Table 3
********************************************************************************

/*
Table 3: Mean Errors across models and vintages.
*/

use "data.dta"

* Create the variables to hold the predicted popular vote share obtained with 
* different vintages and real-time data
forvalues vintage=1984(4)2012{
	gen r2_lbt_v`vintage'=. 
	gen yhat_lbt_v`vintage'=.
	gen e_lbt_v`vintage'=.
	gen eabs_lbt_v`vintage'=.
}
* and 2014
gen r2_lbt_v2014=.
gen yhat_lbt_v2014=.
gen e_lbt_v2014=.
gen eabs_lbt_v2014=.


gen yhat_lbt_rt=.
gen e_lbt_rt=.
gen eabs_lbt_rt=.
gen yhat_lbt_rtext=.
gen e_lbt_rtext=.
gen eabs_lbt_rtext=.

gen r2_vp=.
gen r2_rtext=.

* Loop through elections 1984 (id=10) to 2012 (id=17) and vintages 84 to 2012 for 
* out-of-sample-forecasts
forvalues loopid=10/17 { //loop through elections

	foreach vintage in 1984 1988 1992 1996 2000 2004 2008 2012 2014 { //loop through vintages 
																											 //for a given election
			quietly reg vote gndp_change_v`vintage' if id<`loopid'
			quietly replace r2_vp = e(r2) if id==`loopid' & year==`vintage'
			quietly replace r2_lbt_v`vintage'= e(r2) if id ==`loopid'
			quietly predict yhat_temp 
			quietly replace yhat_lbt_v`vintage'=yhat_temp if id==`loopid'
			quietly replace e_lbt_v`vintage'=yhat_lbt_v`vintage'-vote
			quietly replace eabs_lbt_v`vintage'=abs(e_lbt_v`vintage')
			quietly drop yhat_temp
			display `vintage' " " `loopid'
	}
	
} //we now have forecast for election 1984-2012 using vintages election year-2012

* Loop through elections 1984 (id=10) to 2012 (id=17) for out-of-sample-forecasts
* using real-time data
forvalues loopid=10/17 { //loop through elections

	* real-time real gnp/gdp
	quietly reg vote rt_rgndp_change if id<`loopid'

	quietly predict yhat_temp 
	quietly replace yhat_lbt_rt=yhat_temp if id==`loopid'
	quietly replace e_lbt_rt=yhat_lbt_rt-vote
	quietly replace eabs_lbt_rt=abs(e_lbt_rt)
	quietly drop yhat_temp
	
	* real-time extended ts
	quietly reg vote rt_gndp_change_ext if id<`loopid'
	quietly replace r2_rtext = e(r2) if id==`loopid'
	quietly predict yhat_temp 
	quietly replace yhat_lbt_rtext=yhat_temp if id==`loopid'
	quietly replace e_lbt_rtext=yhat_lbt_rtext-vote
	quietly replace eabs_lbt_rtext=abs(e_lbt_rtext)
	quietly drop yhat_temp
}

gen yhat_lbt_`vintage'=.

* create variables that hold predictions and prediction errors for a given year, 
* obs are different vintages
forvalues vintage=1984(4)2012 {
	gen yhat_lbt_`vintage'=.	/* contains forecasts for the same election \
														(year: `vintage') obtained 
														for `vintage' observation into one variable for plotting*/
	gen eabs_lbt_`vintage'=. 	//analogous to above but contains absolute prediction errors
}

* and 2014
set obs 18
replace id = 18 if _n == 18
replace year = 2014 if _n == 18

forvalues loopid=10/17 { //loop through elections

	local election=year[`loopid'] //sets election year
	di `election'
	
	forvalues vintage=1984(4)2012 { //loop through vintages for 
																							 //a given election
	
		replace yhat_lbt_`election'=yhat_lbt_v`vintage'[`loopid'] if year==`vintage' 
		/*writes data from election year observation into variable yht_lbt_`election', 
		obs of this variable are vintages*/
		
		
		replace eabs_lbt_`election'=eabs_lbt_v`vintage'[`loopid'] if year==`vintage'	
		//ananlogous for error
		
		
		capture label variable eabs_lbt_`vintage' "`vintage'"
	}
} 	/* we now have variables containing the forecasts for elections 1984 through 2012,
	     observations for these variables are the different vintages used to predict 
			 vote share */
* For 2014
forvalues loopid=10/17 {
	local election=year[`loopid'] //sets election year
	replace yhat_lbt_`election'=yhat_lbt_v2014[`loopid'] if year==2014 // 2014
	replace eabs_lbt_`election'=eabs_lbt_v2014[`loopid'] if year==2014	// 2014 
}	
			 
* Create variables necessary for plotting
gen yhat_lbt_vp=. // variable to hold forecast for an election obtained with data 
									// vintage available shortly before election
gen e_lbt_vp=. // will contain vote-yhat_vp
gen eabs_lbt_vp=. // will contain abs(vote-yhat_vp)


forvalues loopid=10/17 { // loops through obs
		local vintage=year[`loopid']
		replace yhat_lbt_vp=yhat_lbt_v`vintage' if id==`loopid'
		replace e_lbt_vp=e_lbt_v`vintage' if id==`loopid'
		replace eabs_lbt_vp=eabs_lbt_v`vintage' if id==`loopid'
}
* e_lbt_rtext

gen differ_rt=eabs_lbt_rt-eabs_lbt_vp  // difference to prediction using vintage data
gen differ_rtext=eabs_lbt_rtext-eabs_lbt_vp  // see above

* Calculate the squared error
capture gen	eabs_lbt_v2012_squared = eabs_lbt_v2012^2
capture gen eabs_lbt_vp_squared = eabs_lbt_vp^2
capture gen eabs_lbt_rt_squared = eabs_lbt_rt^2
capture gen eabs_lbt_rtext_squared = eabs_lbt_rtext^2 

* create weights
gen numobs=.
gen df=.
gen tvalue=.
forvalues i=1/8 {
 replace numobs=8+`i' if year==1980+`i'*4
 replace df=5+`i' if year==1980+`i'*4
 replace tvalue=round(invttail(5+`i',0.025), .01) if year==1980+`i'*4
}
gen rec_tvalue=1/tvalue

quietly sum numobs
gen nweight=numobs/r(sum)
quietly sum df
gen dfweight=df/r(sum)
quietly sum rec_tvalue
gen rectvalweight=rec_tvalue/r(sum)

* Calculate average errors and write them into a matrix
mat define Errors = J(4,8,.)
mat rownames Errors = "2012~vintage " "Most~recent~vintage" "Real-time" "Real-time~extended"
mat colnames Errors = "MAE" "RMSE" "MAE~(n)" "RMSE~(n)" "MAE~(df)" "RMSE~(df)" "MAE~(1/t)" "RMSE~(1/t)" 

local n=0
foreach ts in v2012 vp rt rtext {
	* MAE unweighted
	local n `n'+1
	sum eabs_lbt_`ts'
  mat Errors[`n',1] = r(mean)
	
	* RMSE unweighted
	sum eabs_lbt_`ts'_squared
  mat Errors[`n',2] = sqrt(r(mean))
	
	* MAE weighted by N
	scalar MAE_N_`ts'=0
	forvalues i=1/8 {
		scalar MAE_N_`ts' = MAE_N_`ts' + nweight[9+`i']*eabs_lbt_`ts'[9+`i']
	}
	mat Errors[`n',3] = MAE_N_`ts'
	
	scalar RMSE_N_`ts'=0
	forvalues i=1/8 {
		scalar RMSE_N_`ts' = RMSE_N_`ts' + nweight[9+`i']*(eabs_lbt_`ts'[9+`i']^2)
	}
	scalar RMSE_N_`ts' = sqrt(RMSE_N_`ts')
	mat Errors[`n',4] = RMSE_N_`ts'
	
	* MAE weighted by df
	scalar MAE_df_`ts'=0
	forvalues i=1/8 {
		scalar MAE_df_`ts' = MAE_df_`ts' + dfweight[9+`i']*eabs_lbt_`ts'[9+`i']
	}
	mat Errors[`n',5] = MAE_df_`ts'
	
	*RMSE weighted by df
	scalar RMSE_df_`ts'=0
	forvalues i=1/8 {
		scalar RMSE_df_`ts' = RMSE_df_`ts' + dfweight[9+`i']*(eabs_lbt_`ts'[9+`i']^2)
	}
	scalar RMSE_df_`ts' = sqrt(RMSE_df_`ts')
	mat Errors[`n',6] = RMSE_df_`ts'
	
	* MAE weighted by 1/t
	scalar MAE_rectval_`ts'=0
	forvalues i=1/8 {
		scalar MAE_rectval_`ts' = MAE_rectval_`ts' + rectvalweight[9+`i']*eabs_lbt_`ts'[9+`i']
	}
	mat Errors[`n',7] = MAE_rectval_`ts'
	
	*RMSE weighted by rectval
	scalar RMSE_rectval_`ts'=0
	forvalues i=1/8 {
		scalar RMSE_rectval_`ts' = RMSE_rectval_`ts' + rectvalweight[9+`i']*(eabs_lbt_`ts'[9+`i']^2)
	}
	scalar RMSE_rectval_`ts' = sqrt(RMSE_rectval_`ts')
	mat Errors[`n',8] = RMSE_rectval_`ts'
	
}

mat define ErrorsRounded = J(4,8,.)
mat rownames ErrorsRounded = "2012~vintage " "Most~recent~vintage" "Real-time" "Real-time~extended"
mat colnames ErrorsRounded = "MAE" "RMSE" "MAE~(n)" "RMSE~(n)" "MAE~(df)" "RMSE~(df)" "MAE~(1/t)" "RMSE~(1/t)" 

forvalues i=1/4 {
	forvalues j=1/8 {
			mat ErrorsRounded[`i',`j'] = round(Errors[`i',`j'], .01)
		}
}

mat list ErrorsRounded

mat ErrorsLBT = (ErrorsRounded[1..2,1..2] \ ErrorsRounded[4,1..2]), (ErrorsRounded[1..2,5..6] \ ErrorsRounded[4,5..6])
mat rownames ErrorsLBT = "2002 vintage" "Most recent vintage" "Real-time"
mat colnames ErrorsLBT = "MAE" "RMSE" "MAE (df)" "RMSE (df)"
mat list ErrorsLBT

clear


************
* Abramowitz
************

use "data.dta"

* Create the variables to hold the predicted popular vote share obtained 
* with different vintages
foreach vintage in 84 88 92 96 00 04 08 12 14 {
	gen r2_a_v`vintage'=.
	gen yhat_a_v`vintage'=.
	gen e_a_v`vintage'=.
	gen eabs_a_v`vintage'=.
}

gen yhat_a_rt=.
gen e_a_rt=.
gen eabs_a_rt=.

gen yhat_a_rtext=.
gen e_a_rtext=.
gen eabs_a_rtext=.

gen r2_vp=.
gen r2_rtext=.

* Loop through elections 1984 (id=10) to 2012 (id=17) and vintages 84 to 2012 for 
* out-of-sample-forecasts
forvalues loopid=10/17 { //loop through elections

	foreach vintage in 84 88 92 96 00 04 08 12 14 { //loop through vintages for a given election
			quietly reg vote rgndpQ2gr`vintage'_agr if id<`loopid'
			quietly replace r2_vp = e(r2) if id==`loopid' & vintage=="v`vintage'"
			quietly replace r2_a_v`vintage' = e(r2) if id==`loopid'
			quietly predict yhat_temp 
			quietly replace yhat_a_v`vintage'=yhat_temp if id==`loopid'
			quietly replace e_a_v`vintage'=yhat_a_v`vintage'-vote
			quietly replace eabs_a_v`vintage'=abs(e_a_v`vintage')
			quietly drop yhat_temp
			display `vintage' `loopid'
	}
	
}  // we now have forecast for election 1984-2012 using 
   // vintages election year-2012 and real-time data
	 
* Loop through elections 1984 (id=10) to 2012 (id=17) for out-of-sample-forecasts
* using real-time data

forvalues loopid=10/17 { //loop through elections
	quietly reg vote rt_rgndpq2agr if id<`loopid' //real-time real gnp/gdp
	
	quietly predict yhat_temp 
	quietly replace yhat_a_rt=yhat_temp if id==`loopid'
	quietly replace e_a_rt=yhat_a_rt-vote
	quietly replace eabs_a_rt=abs(e_a_rt)
	quietly drop yhat_temp
	
	
	quietly reg vote rt_gndpq2agr_ext if id<`loopid' //real-time extended ts
	replace r2_rtext = e(r2) if id==`loopid'
	quietly predict yhat_temp 
	quietly replace yhat_a_rtext=yhat_temp if id==`loopid'
	quietly replace e_a_rtext=yhat_a_rtext-vote
	quietly replace eabs_a_rtext=abs(e_a_rtext)
	quietly drop yhat_temp
}

* create variables that hold predictions and prediction errors for a given year, 
* obs are different vintages
foreach vintage in 84 88 92 96 00 04 08 12 14 {
	gen yhat_a_`vintage'=.	/* contains forecasts for the same election \
														(year: `vintage') obtained 
														with different data vintages (1984-2012)*/
														/*puts values for yhat_v84 to yhat_v12 variables 
														for `vintage' observation into one variable for plotting*/
	gen eabs_a_`vintage'=. 	//analogous to above but contains absolute prediction errors
}

* and 2014
set obs 18
replace id = 18 if _n == 18
replace year = 2014 if _n == 18

forvalues loopid=10/17 { //loop through elections

	local election=y[`loopid'] //sets election year
	di `election'
	
	foreach vintage in 84 88 92 96 00 04 08 12 { //loop through vintages for 
																							 //a given election
	
		replace yhat_a_`election'=yhat_a_v`vintage'[`loopid'] if y=="`vintage'" 
		/*writes data from election year observation into variable yht_a_`election', 
		obs of this variable are vintages*/
		
		replace eabs_a_`election'=eabs_a_v`vintage'[`loopid'] if y=="`vintage'"	
		//ananlogous for error
		
		capture label variable eabs_a_`vintage' "`vintage'"
	}
} 	/* we now have variables containing the forecasts for elections 1984 through 2012,
	     observations for these variables are the different vintages used to predict 
			 vote share */
* For 2014
forvalues loopid=10/17 {
	local election=y[`loopid'] //sets election year
	replace yhat_a_`election'=yhat_a_v14[`loopid'] if year==2014 // 2014
	replace eabs_a_`election'=eabs_a_v14[`loopid'] if year==2014	// 2014 
}					 
			 
			 
* Create variables necessary for plotting
gen yhat_a_vp=. // variable to hold forecast for an election obtained with data 
									// vintage available shortly before election
gen e_a_vp=. // will contain vote-yhat_vp
gen eabs_a_vp=. // will contain abs(vote-yhat_vp)

forvalues loopid=10/17 { // loops through obs
		local vintage=y[`loopid']
		replace yhat_a_vp=yhat_a_v`vintage' if id==`loopid'
		replace e_a_vp=e_a_v`vintage' if id==`loopid'
		replace eabs_a_vp=eabs_a_v`vintage' if id==`loopid'
}

gen differ_rt=eabs_a_rt-eabs_a_vp  // difference to prediction using vintage data
gen differ_rtext=eabs_a_rtext-eabs_a_vp  // see above

* Calculate the squared error
capture gen	eabs_a_v12_squared = eabs_a_v12^2
capture gen eabs_a_vp_squared = eabs_a_vp^2
capture gen eabs_a_rt_squared = eabs_a_rt^2
capture gen eabs_a_rtext_squared = eabs_a_rtext^2 


* create weights
gen numobs=.
gen df=.
gen tvalue=.
forvalues i=1/8 {
 replace numobs=8+`i' if year==1980+`i'*4
 replace df=4+`i' if year==1980+`i'*4
 replace tvalue=round(invttail(5+`i',0.025), .01) if year==1980+`i'*4
}
gen rec_tvalue=1/tvalue

quietly sum numobs
gen nweight=numobs/r(sum)
quietly sum df
gen dfweight=df/r(sum)
quietly sum rec_tvalue
gen rectvalweight=rec_tvalue/r(sum)

* Calculate average errors and write them into a matrix
mat define Errors = J(4,8,.)
mat rownames Errors = "2012~vintage " "Most~recent~vintage" "Real-time" "Real-time~extended"
mat colnames Errors = "MAE" "RMSE" "MAE~(n)" "RMSE~(n)" "MAE~(df)" "RMSE~(df)" "MAE~(1/t)" "RMSE~(1/t)" 

local n=0
foreach ts in v12 vp rt rtext {
	* MAE unweighted
	local n `n'+1
	sum eabs_a_`ts'
  mat Errors[`n',1] = r(mean)
	
	* RMSE unweighted
	sum eabs_a_`ts'_squared
  mat Errors[`n',2] = sqrt(r(mean))
	
	* MAE weighted by N
	scalar MAE_N_`ts'=0
	forvalues i=1/8 {
		scalar MAE_N_`ts' = MAE_N_`ts' + nweight[9+`i']*eabs_a_`ts'[9+`i']
	}
	mat Errors[`n',3] = MAE_N_`ts'
	
	scalar RMSE_N_`ts'=0
	forvalues i=1/8 {
		scalar RMSE_N_`ts' = RMSE_N_`ts' + nweight[9+`i']*(eabs_a_`ts'[9+`i']^2)
	}
	scalar RMSE_N_`ts' = sqrt(RMSE_N_`ts')
	mat Errors[`n',4] = RMSE_N_`ts'
	
	* MAE weighted by df
	scalar MAE_df_`ts'=0
	forvalues i=1/8 {
		scalar MAE_df_`ts' = MAE_df_`ts' + dfweight[9+`i']*eabs_a_`ts'[9+`i']
	}
	mat Errors[`n',5] = MAE_df_`ts'
	
	*RMSE weighted by df
	scalar RMSE_df_`ts'=0
	forvalues i=1/8 {
		scalar RMSE_df_`ts' = RMSE_df_`ts' + dfweight[9+`i']*(eabs_a_`ts'[9+`i']^2)
	}
	scalar RMSE_df_`ts' = sqrt(RMSE_df_`ts')
	mat Errors[`n',6] = RMSE_df_`ts'
	
	* MAE weighted by 1/t
	scalar MAE_rectval_`ts'=0
	forvalues i=1/8 {
		scalar MAE_rectval_`ts' = MAE_rectval_`ts' + rectvalweight[9+`i']*eabs_a_`ts'[9+`i']
	}
	mat Errors[`n',7] = MAE_rectval_`ts'
	
	*RMSE weighted by rectval
	scalar RMSE_rectval_`ts'=0
	forvalues i=1/8 {
		scalar RMSE_rectval_`ts' = RMSE_rectval_`ts' + rectvalweight[9+`i']*(eabs_a_`ts'[9+`i']^2)
	}
	scalar RMSE_rectval_`ts' = sqrt(RMSE_rectval_`ts')
	mat Errors[`n',8] = RMSE_rectval_`ts'
	
}
mat list Errors

mat define ErrorsRounded = J(4,8,.)
mat rownames ErrorsRounded = "2012~vintage " "Most~recent~vintage" "Real-time" "Real-time~extended"
mat colnames ErrorsRounded = "MAE" "RMSE" "MAE~(n)" "RMSE~(n)" "MAE~(df)" "RMSE~(df)" "MAE~(1/t)" "RMSE~(1/t)" 

forvalues i=1/4 {
	forvalues j=1/8 {
			mat ErrorsRounded[`i',`j'] = round(Errors[`i',`j'], .01)
		}
}

mat list ErrorsRounded

mat ErrorsA = (ErrorsRounded[1..2,1..2] \ ErrorsRounded[4,1..2]), (ErrorsRounded[1..2,5..6] \ ErrorsRounded[4,5..6])
mat rownames ErrorsA = "2002 vintage" "Most recent vintage" "Real-time"
mat colnames ErrorsA = "MAE" "RMSE" "MAE (df)" "RMSE (df)"
mat list ErrorsA

clear


**********
* Campbell
**********

use "data.dta"

* Create Campbell Style vintage growth variable
foreach vintage in 84 88 92 96 00 04 08 12 14 {
	gen c_rgndpQ2gr`vintage'_agr=(rgndpQ2gr`vintage'_agr-2.5)*incweight
}

* Create Campbell Style real-time growth variable
gen c_rt_rgndpq2agr=(rt_rgndpq2agr-2.5)*incweight 
gen c_rt_gndpq2agr_ext=(rt_gndpq2agr_ext-2.5)*incweight

* Create the variables to hold the predicted popular vote share obtained 
* with different vintages
foreach vintage in 84 88 92 96 00 04 08 12 14 {
	gen r2_c_`vintage'=.
	gen yhat_c_v`vintage'=.
	gen e_c_v`vintage'=.
	gen eabs_c_v`vintage'=.
}

gen yhat_c_rt=.
gen e_c_rt=.
gen eabs_c_rt=.

gen yhat_c_rtext=.
gen e_c_rtext=.
gen eabs_c_rtext=.

gen r2_vp=.
gen r2_rtext=.


* Loop through elections 1984 (id=10) to 2012 (id=17) and vintages 84 to 2012 for 
* out-of-sample-forecasts
forvalues loopid=10/17 { //loop through elections

	foreach vintage in 84 88 92 96 00 04 08 12 14 { //loop through vintages for a given election
			quietly reg vote c_rgndpQ2gr`vintage'_agr if id<`loopid'
			replace r2_vp = e(r2) if id==`loopid' & vintage=="v`vintage'"
			replace r2_c_`vintage' = e(r2) if id==`loopid'
			quietly predict yhat_temp 
			quietly replace yhat_c_v`vintage'=yhat_temp if id==`loopid'
			quietly replace e_c_v`vintage'=yhat_c_v`vintage'-vote
			quietly replace eabs_c_v`vintage'=abs(e_c_v`vintage')
			quietly drop yhat_temp
			display `vintage' `loopid'
	}
	
} //we now have forecast for election 1984-2012 using vintages election year-2012


* Loop through elections 1984 (id=10) to 2012 (id=17) for out-of-sample-forecasts
* using real-time data
forvalues loopid=10/17 { //loop through elections
	quietly reg vote c_rt_rgndpq2agr if id<`loopid' //real-time real gnp/gdp
	
	quietly predict yhat_temp 
	quietly replace yhat_c_rt=yhat_temp if id==`loopid'
	quietly replace e_c_rt=yhat_c_rt-vote
	quietly replace eabs_c_rt=abs(e_c_rt)
	quietly drop yhat_temp
	
	quietly reg vote c_rt_gndpq2agr_ext if id<`loopid' //real-time extended ts
	replace r2_rtext = e(r2) if id==`loopid'
	quietly predict yhat_temp 
	quietly replace yhat_c_rtext=yhat_temp if id==`loopid'
	quietly replace e_c_rtext=yhat_c_rtext-vote
	quietly replace eabs_c_rtext=abs(e_c_rtext)
	quietly drop yhat_temp
}

* create variables that hold predictions and prediction errors for a given year, 
* obs are different vintages
foreach vintage in 84 88 92 96 00 04 08 12 {
	gen yhat_c_`vintage'=.	/* contains forecasts for the same election \
														(year: `vintage') obtained 
														with different data vintages (1984-2012)*/
														/*puts values for yhat_v84 to yhat_v12 variables 
														for `vintage' observation into one variable for plotting*/
	gen eabs_c_`vintage'=. 	//analogous to above but contains absolute prediction errors
}

* and 2014
set obs 18
replace id = 18 if _n == 18
replace year = 2014 if _n == 18

forvalues loopid=10/17 { //loop through elections

	local election=y[`loopid'] //sets election year
	di `election'
	
	foreach vintage in 84 88 92 96 00 04 08 12 { //loop through vintages for 
																							 //a given election
	
		replace yhat_c_`election'=yhat_c_v`vintage'[`loopid'] if y=="`vintage'" 
		/*writes data from election year observation into variable yht_c_`election', 
		obs of this variable are vintages*/
		
		replace eabs_c_`election'=eabs_c_v`vintage'[`loopid'] if y=="`vintage'"	
		//ananlogous for error
		
		capture label variable eabs_c_`vintage' "`vintage'"
	}
} 	/* we now have variables containing the forecasts for elections 1984 through 2012,
	     observations for these variables are the different vintages used to predict 
			 vote share */
forvalues loopid=10/17 {
	local election=y[`loopid'] //sets election year
	replace yhat_c_`election'=yhat_c_v14[`loopid'] if year==2014 // 2014
	replace eabs_c_`election'=eabs_c_v14[`loopid'] if year==2014	// 2014 
}	
			 
* Create variables necessary for plotting
gen yhat_c_vp=. // variable to hold forecast for an election obtained with data 
									// vintage available shortly before election
gen e_c_vp=. // will contain abs(vote-yhat_vp)
gen eabs_c_vp=. // will contain abs(vote-yhat_vp)

forvalues loopid=10/17 { // loops through obs
		local vintage=y[`loopid']
		replace yhat_c_vp=yhat_c_v`vintage' if id==`loopid'
		replace e_c_vp=e_c_v`vintage' if id==`loopid'
		replace eabs_c_vp=eabs_c_v`vintage' if id==`loopid'
}

gen differ_rt=eabs_c_rt-eabs_c_vp  // difference to prediction using vintage data
gen differ_rtext=eabs_c_rtext-eabs_c_vp  // see above

* Calculate the squared error
capture gen	eabs_c_v12_squared = eabs_c_v12^2
capture gen eabs_c_vp_squared = eabs_c_vp^2
capture gen eabs_c_rt_squared = eabs_c_rt^2
capture gen eabs_c_rtext_squared = eabs_c_rtext^2 


* create weights
gen numobs=.
gen df=.
gen tvalue=.
forvalues i=1/8 {
 replace numobs=8+`i' if year==1980+`i'*4
 replace df=5+`i' if year==1980+`i'*4
 replace tvalue=round(invttail(5+`i',0.025), .01) if year==1980+`i'*4
}
gen rec_tvalue=1/tvalue

quietly sum numobs
gen nweight=numobs/r(sum)
quietly sum df
gen dfweight=df/r(sum)
quietly sum rec_tvalue
gen rectvalweight=rec_tvalue/r(sum)

* Calculate average errors and write them into a matrix
mat define Errors = J(4,8,.)
mat rownames Errors = "2012~vintage " "Most~recent~vintage" "Real-time" "Real-time~extended"
mat colnames Errors = "MAE" "RMSE" "MAE~(n)" "RMSE~(n)" "MAE~(df)" "RMSE~(df)" "MAE~(1/t)" "RMSE~(1/t)" 

local n=0
foreach ts in v12 vp rt rtext {
	* MAE unweighted
	local n `n'+1
	sum eabs_c_`ts'
  mat Errors[`n',1] = r(mean)
	
	* RMSE unweighted
	sum eabs_c_`ts'_squared
  mat Errors[`n',2] = sqrt(r(mean))
	
	* MAE weighted by N
	scalar MAE_N_`ts'=0
	forvalues i=1/8 {
		scalar MAE_N_`ts' = MAE_N_`ts' + nweight[9+`i']*eabs_c_`ts'[9+`i']
	}
	mat Errors[`n',3] = MAE_N_`ts'
	
	scalar RMSE_N_`ts'=0
	forvalues i=1/8 {
		scalar RMSE_N_`ts' = RMSE_N_`ts' + nweight[9+`i']*(eabs_c_`ts'[9+`i']^2)
	}
	scalar RMSE_N_`ts' = sqrt(RMSE_N_`ts')
	mat Errors[`n',4] = RMSE_N_`ts'
	
	* MAE weighted by df
	scalar MAE_df_`ts'=0
	forvalues i=1/8 {
		scalar MAE_df_`ts' = MAE_df_`ts' + dfweight[9+`i']*eabs_c_`ts'[9+`i']
	}
	mat Errors[`n',5] = MAE_df_`ts'
	
	*RMSE weighted by df
	scalar RMSE_df_`ts'=0
	forvalues i=1/8 {
		scalar RMSE_df_`ts' = RMSE_df_`ts' + dfweight[9+`i']*(eabs_c_`ts'[9+`i']^2)
	}
	scalar RMSE_df_`ts' = sqrt(RMSE_df_`ts')
	mat Errors[`n',6] = RMSE_df_`ts'
	
	* MAE weighted by 1/t
	scalar MAE_rectval_`ts'=0
	forvalues i=1/8 {
		scalar MAE_rectval_`ts' = MAE_rectval_`ts' + rectvalweight[9+`i']*eabs_c_`ts'[9+`i']
	}
	mat Errors[`n',7] = MAE_rectval_`ts'
	
	*RMSE weighted by rectval
	scalar RMSE_rectval_`ts'=0
	forvalues i=1/8 {
		scalar RMSE_rectval_`ts' = RMSE_rectval_`ts' + rectvalweight[9+`i']*(eabs_c_`ts'[9+`i']^2)
	}
	scalar RMSE_rectval_`ts' = sqrt(RMSE_rectval_`ts')
	mat Errors[`n',8] = RMSE_rectval_`ts'
	
}
mat list Errors

mat define ErrorsRounded = J(4,8,.)
mat rownames ErrorsRounded = "2012~vintage " "Most~recent~vintage" "Real-time" "Real-time~extended"
mat colnames ErrorsRounded = "MAE" "RMSE" "MAE~(n)" "RMSE~(n)" "MAE~(df)" "RMSE~(df)" "MAE~(1/t)" "RMSE~(1/t)" 

forvalues i=1/4 {
	forvalues j=1/8 {
			mat ErrorsRounded[`i',`j'] = round(Errors[`i',`j'], .01)
		}
}

mat list ErrorsRounded

mat ErrorsC = (ErrorsRounded[1..2,1..2] \ ErrorsRounded[4,1..2]), (ErrorsRounded[1..2,5..6] \ ErrorsRounded[4,5..6])
mat rownames ErrorsC = "2002 vintage" "Most recent vintage" "Real-time"
mat colnames ErrorsC = "MAE" "RMSE" "MAE (df)" "RMSE (df)"
mat list ErrorsC

clear


***************
* End-heuristic
***************

use "data.dta"

* Create the variables to hold the predicted popular vote share obtained with 
* different vintages and real-time data
forvalues vintage=1984(4)2012{
	gen r2_kl_v`vintage'=.
	gen yhat_kl_v`vintage'=.
	gen e_kl_v`vintage'=.
	gen eabs_kl_v`vintage'=.
}

* and 2014
gen r2_kl_v2014=.
gen yhat_kl_v2014=.
gen e_kl_v2014=.
gen eabs_kl_v2014=.

gen yhat_kl_rt=.
gen e_kl_rt=.
gen eabs_kl_rt=.
gen yhat_kl_rtext=.
gen e_kl_rtext=.
gen eabs_kl_rtext=.

gen r2_vp=.
gen r2_rtext=.

* Loop through elections 1984 (id=10) to 2012 (id=17) and vintages 84 to 2012 for 
* out-of-sample-forecasts
forvalues loopid=10/17 { //loop through elections

	foreach vintage in 1984 1988 1992 1996 2000 2004 2008 2012 2014 { //loop through vintages 
																											 //for a given election
			quietly reg vote wgr2_1_v`vintage' if id<`loopid'
			replace r2_vp = e(r2) if id==`loopid' & `vintage'==year[`loopid']
			replace r2_kl_v`vintage' = e(r2) if id==`loopid'
			quietly predict yhat_temp 
			quietly replace yhat_kl_v`vintage'=yhat_temp if id==`loopid'
			quietly replace e_kl_v`vintage'=yhat_kl_v`vintage'-vote
			quietly replace eabs_kl_v`vintage'=abs(e_kl_v`vintage')
			quietly drop yhat_temp
			display `vintage' " " `loopid'
	}
	
} //we now have forecast for election 1984-2012 using vintages election year-2012

* Loop through elections 1984 (id=10) to 2012 (id=17) for out-of-sample-forecasts
* using real-time data
forvalues loopid=10/17 { //loop through elections

	* real-time real gnp/gdp
	reg vote wgr2_1_rt if id<`loopid'
	
	quietly predict yhat_temp 
	quietly replace yhat_kl_rt=yhat_temp if id==`loopid'
	quietly replace e_kl_rt=yhat_kl_rt-vote
	quietly replace eabs_kl_rt=abs(e_kl_rt)
	quietly drop yhat_temp
	
	* real-time extended
	reg vote wgr2_1_rtext if id<`loopid'
	replace r2_rtext = e(r2) if id==`loopid'
	quietly predict yhat_temp 
	quietly replace yhat_kl_rtext=yhat_temp if id==`loopid'
	quietly replace e_kl_rtext=yhat_kl_rtext-vote
	quietly replace eabs_kl_rtext=abs(e_kl_rtext)
	quietly drop yhat_temp
	
}

* create variables that hold predictions and prediction errors for a given year, 
* obs are different vintages
forvalues vintage=1984(4)2012 {
	gen yhat_kl_`vintage'=.	/* contains forecasts for the same election \
														(year: `vintage') obtained 
														with different data vintages (1984-2012)*/
														/*puts values for yhat_v84 to yhat_v12 variables 
														for `vintage' observation into one variable for plotting*/
	gen eabs_kl_`vintage'=. 	//analogous to above but contains absolute prediction errors
}

* and 2014
set obs 18
replace id = 18 if _n == 18
replace year = 2014 if _n == 18

forvalues loopid=10/17 { //loop through elections

	local election=year[`loopid'] //sets election year
	di `election'
	
	forvalues vintage=1984(4)2012 { //loop through vintages for 
																							 //a given election
	
		replace yhat_kl_`election'=yhat_kl_v`vintage'[`loopid'] if year==`vintage' 
		/*writes data from election year observation into variable yht_kl_`election', 
		obs of this variable are vintages*/
		
		replace eabs_kl_`election'=eabs_kl_v`vintage'[`loopid'] if year==`vintage'
		//ananlogous for error
		
		capture label variable eabs_kl_`vintage' "`vintage'"
	}
} 	/* we now have variables containing the forecasts for elections 1984 through 2012,
	     observations for these variables are the different vintages used to predict 
			 vote share */
* For 2014
forvalues loopid=10/17 {
	local election=year[`loopid'] //sets election year
	replace yhat_kl_`election'=yhat_kl_v2014[`loopid'] if year==2014 // 2014
	replace eabs_kl_`election'=eabs_kl_v2014[`loopid'] if year==2014	// 2014 
}				 
			 
* Create variables necessary for plotting
gen yhat_kl_vp=. // variable to hold forecast for an election obtained with data 
									// vintage available shortly before election
gen e_kl_vp=. // will contain vote-yhat_vp
gen eabs_kl_vp=. // will contain abs(vote-yhat_vp)

forvalues loopid=10/17 { // loops through obs
		local vintage=year[`loopid']
		replace yhat_kl_vp=yhat_kl_v`vintage' if id==`loopid'
		replace e_kl_vp=e_kl_v`vintage' if id==`loopid'
		replace eabs_kl_vp=eabs_kl_v`vintage' if id==`loopid'
}

gen differ_rt=eabs_kl_rt-eabs_kl_vp  // difference to prediction using vintage data
gen differ_rtext=eabs_kl_rtext-eabs_kl_vp  // extended
gen eabs_kl_2012_squared = eabs_kl_v2012^2
gen eabs_kl_vp_squared = eabs_kl_vp^2
gen eabs_kl_rtext_squared = eabs_kl_rtext^2

* Calculate the squared error
capture gen	eabs_kl_v2012_squared = eabs_kl_v2012^2
capture gen eabs_kl_vp_squared = eabs_kl_vp^2
capture gen eabs_kl_rt_squared = eabs_kl_rt^2

* create weights
gen numobs=.
gen df=.
gen tvalue=.
forvalues i=1/8 {
 replace numobs=8+`i' if year==1980+`i'*4
 replace df=5+`i' if year==1980+`i'*4
 replace tvalue=round(invttail(5+`i',0.025), .01) if year==1980+`i'*4
}
gen rec_tvalue=1/tvalue

quietly sum numobs
gen nweight=numobs/r(sum)
quietly sum df
gen dfweight=df/r(sum)
quietly sum rec_tvalue
gen rectvalweight=rec_tvalue/r(sum)

* Calculate average errors and write them into a matrix
mat define Errors = J(3,8,.)
mat rownames Errors = "2012~vintage " "Most~recent~vintage" "Real-time"
mat colnames Errors = "MAE" "RMSE" "MAE~(n)" "RMSE~(n)" "MAE~(df)" "RMSE~(df)" "MAE~(1/t)" "RMSE~(1/t)" 

local n=0
foreach ts in v2012 vp rt {
	* MAE unweighted
	local n `n'+1
	sum eabs_kl_`ts'
  mat Errors[`n',1] = r(mean)
	
	* RMSE unweighted
	sum eabs_kl_`ts'_squared
  mat Errors[`n',2] = sqrt(r(mean))
	
	* MAE weighted by N
	scalar MAE_N_`ts'=0
	forvalues i=1/8 {
		scalar MAE_N_`ts' = MAE_N_`ts' + nweight[9+`i']*eabs_kl_`ts'[9+`i']
	}
	mat Errors[`n',3] = MAE_N_`ts'
	
	scalar RMSE_N_`ts'=0
	forvalues i=1/8 {
		scalar RMSE_N_`ts' = RMSE_N_`ts' + nweight[9+`i']*(eabs_kl_`ts'[9+`i']^2)
	}
	scalar RMSE_N_`ts' = sqrt(RMSE_N_`ts')
	mat Errors[`n',4] = RMSE_N_`ts'
	
	* MAE weighted by df
	scalar MAE_df_`ts'=0
	forvalues i=1/8 {
		scalar MAE_df_`ts' = MAE_df_`ts' + dfweight[9+`i']*eabs_kl_`ts'[9+`i']
	}
	mat Errors[`n',5] = MAE_df_`ts'
	
	*RMSE weighted by df
	scalar RMSE_df_`ts'=0
	forvalues i=1/8 {
		scalar RMSE_df_`ts' = RMSE_df_`ts' + dfweight[9+`i']*(eabs_kl_`ts'[9+`i']^2)
	}
	scalar RMSE_df_`ts' = sqrt(RMSE_df_`ts')
	mat Errors[`n',6] = RMSE_df_`ts'
	
	* MAE weighted by 1/t
	scalar MAE_rectval_`ts'=0
	forvalues i=1/8 {
		scalar MAE_rectval_`ts' = MAE_rectval_`ts' + rectvalweight[9+`i']*eabs_kl_`ts'[9+`i']
	}
	mat Errors[`n',7] = MAE_rectval_`ts'
	
	*RMSE weighted by rectval
	scalar RMSE_rectval_`ts'=0
	forvalues i=1/8 {
		scalar RMSE_rectval_`ts' = RMSE_rectval_`ts' + rectvalweight[9+`i']*(eabs_kl_`ts'[9+`i']^2)
	}
	scalar RMSE_rectval_`ts' = sqrt(RMSE_rectval_`ts')
	mat Errors[`n',8] = RMSE_rectval_`ts'
	
}

mat define ErrorsRounded = J(4,8,.)
mat rownames ErrorsRounded = "2012~vintage " "Most~recent~vintage" "Real-time" "Real-time~extended"
mat colnames ErrorsRounded = "MAE" "RMSE" "MAE~(n)" "RMSE~(n)" "MAE~(df)" "RMSE~(df)" "MAE~(1/t)" "RMSE~(1/t)" 

forvalues i=1/3 {
	forvalues j=1/8 {
			mat ErrorsRounded[`i',`j'] = round(Errors[`i',`j'], .01)
		}
}

mat list ErrorsRounded

mat ErrorsKL = ErrorsRounded[1..3,1..2] , ErrorsRounded[1..3,5..6]
mat rownames ErrorsKL = "2002 vintage" "Most recent vintage" "Real-time"
mat colnames ErrorsKL = "MAE" "RMSE" "MAE (df)" "RMSE (df)"
mat list ErrorsKL

* display all matrices

mat list ErrorsLBT
mat list ErrorsA
mat list ErrorsC
mat list ErrorsKL

* Table has been compiled manualy from above matrices.

clear


********************************************************************************
* Figure 2
********************************************************************************

/*
Figure 2: b=.0547; t=4.25
*/

use "GNDP", clear

**************
* prepare data
**************

rename GNPC96_* GNDP_*
rename GDPC1_* GNDP_*

gen rowid = _n
order rowid, before(observation_date)
tsset rowid

foreach var of varlist GNDP_* {
	gen g`var' = 400 * (ln(`var') - ln(l.`var'))
}
 drop GNDP*

gen year = year(observation_date)
order year, after(observation_date)
gen quarter = quarter(observation_date)
order quarter, after(year)
gen elecyear = (year == 1948 | year == 1952 | year == 1956 | year == 1960 | ///
	year == 1964 | year == 1968 | year == 1972 | year == 1976 | year == 1980 | ///
	year == 1984 | year == 1988 | year == 1992 | year == 1996 | year == 2000 | ///
	year == 2004 | year == 2008 | year == 2012) 
order elecyear, after(quarter)

keep if elecyear == 1 & quarter == 2 & year > 1959
	
********************************
* reshape data from wide to long
********************************

reshape long gGNDP_, i(year) j(vintage) string

replace vintage = substr(vintage, 1, 8)
gen vintage2 = date(vintage, "YMD")
format vintage2 %td

********************************
* create vintage number variable
********************************

gen firstvintage = date("19600823", "YMD") if year == 1960
replace firstvintage = date("19640716", "YMD") if year == 1964
replace firstvintage = date("19680718", "YMD") if year == 1968
replace firstvintage = date("19720721", "YMD") if year == 1972
replace firstvintage = date("19760720", "YMD") if year == 1976
replace firstvintage = date("19800718", "YMD") if year == 1980
replace firstvintage = date("19840723", "YMD") if year == 1984
replace firstvintage = date("19880727", "YMD") if year == 1988
replace firstvintage = date("19920730", "YMD") if year == 1992
replace firstvintage = date("19960801", "YMD") if year == 1996
replace firstvintage = date("20000728", "YMD") if year == 2000
replace firstvintage = date("20040730", "YMD") if year == 2004
replace firstvintage = date("20080731", "YMD") if year == 2008
replace firstvintage = date("20120727", "YMD") if year == 2012
format firstvintage %td

gen vintagenumber = (vintage2 - firstvintage) / 365

***************************
* create deviation variable
***************************

* create variable that contains first estimate for any given year
gen firstestimate = gGNDP_ if vintage == "19600823" & year == 1960
replace firstestimate = gGNDP_ if vintage == "19640716" & year == 1964
replace firstestimate = gGNDP_ if vintage == "19680718" & year == 1968
replace firstestimate = gGNDP_ if vintage == "19720721" & year == 1972
replace firstestimate = gGNDP_ if vintage == "19760720" & year == 1976
replace firstestimate = gGNDP_ if vintage == "19800718" & year == 1980
replace firstestimate = gGNDP_ if vintage == "19840723" & year == 1984
replace firstestimate = gGNDP_ if vintage == "19880727" & year == 1988
replace firstestimate = gGNDP_ if vintage == "19920730" & year == 1992
replace firstestimate = gGNDP_ if vintage == "19960801" & year == 1996
replace firstestimate = gGNDP_ if vintage == "20000728" & year == 2000
replace firstestimate = gGNDP_ if vintage == "20040730" & year == 2004
replace firstestimate = gGNDP_ if vintage == "20080731" & year == 2008
replace firstestimate = gGNDP_ if vintage == "20120727" & year == 2012


* copy down the value of first estimate within years
by year (vintage2), sort: replace firstestimate = firstestimate[_n-1] if firstestimate >= .

* create deviation
gen deviation = gGNDP_ - firstestimate

* drop vintagenumber for bos that contain no deviation
replace vintagenumber = . if deviation == .

************************************
* create absolute deviation variable
************************************

gen absdeviation = abs(deviation)

**************************
* plot absolute deviations
**************************

reg absdeviation vintagenumber, cluster(year) nocons
estimates store absdev
predict yhat
tw scatter absdeviation vintagenumber, msymbol(oh) || line yhat vintagenumber, ///
	xscale(range(0 50)) legend(off) xtitle("Vintage number (years)") ///
	ytitle("Absolute deviations (%-points)")

esttab absdev

clear


********************************************************************************
* Figure 3
********************************************************************************

/*
Figure 3: Weighting of annualized quarterly growth rates. Weights assigned to quarters
depicted as relative to the weight of the 14th quarter of the electoral cycle - i.e. the second
quarter of the election year used in all forecasting models presented in our paper.
*/

* Create dataset
set obs 16
gen id = _n
egen year = seq(), from(1) to(4) block(4)
egen quarter = seq(), from(1) to(4) block(1)
gsort - id

* Hibbs Weighting
gen hWeight = .9^(_n-2)
replace hWeight = 0 if _n == 1
replace hWeight = .333334 if _n == 2
gen chWeight = hWeight / .9 if id <= 14

* Wlezien weighting
gen wWeight = 1 / (1 + exp(-id+7.5)) if id <= 14
gen cwWeight = wWeight / wWeight[3]


* End-heuristic weighting
gen klWeight = 0 if id < 15
replace klWeight = 32 if id == 14
replace klWeight = 16 if id == 13
replace klWeight = 8 if id == 12
replace klWeight = 4 if id == 11
replace klWeight = 2 if id == 10
replace klWeight = 1 if id == 9
gen cklWeight = klWeight / 32

* Plot Hibbs' weighting

tw line chWeight id if id <= 14, xscale(range(1 16)) xlabel(4(4)16) ///
	xtitle(Quarter of Election Cycle) ytitle(Weight) ///
	title(Hibbs' weighting)	name(fig4h)

* Plot Wlezien's weighting

tw line cwWeight id, xscale(range(1 16)) xlabel(4(4)16) ///
	xtitle(Quarter of Election Cycle) ytitle(Weight) ///
	title(Wlezien's weighting) name(fig4w)
	
* Plot end-heuristic weighting
	
tw line cklWeight id, xscale(range(1 16)) xlabel(4(4)16) ///
	xtitle(Quarter of Election Cycle) ytitle(Weight) ///
	title(End-heuristic weighting)	name(fig4e)
	
* display all three graphs
* graph comine fig4h fig4w fig4e	
	
clear	


********************************************************************************
* Figure 4
********************************************************************************

/*
Figure 4: 2012 vintage plotted against real-time growth estimates. The 45 o line indicates
perfect correspondence between vintage and real-time estimates. Points above the line indi-
cate that newer estimates have revised growth estimates upwards from the original estimate.
*/

use "data.dta"

* Hibbs' weighting

corr hGNDP_2012 hGNDP_rt
local r = round(r(rho),.01)
tw (scatter hGNDP_2012 hGNDP_rt, mlabel(year) mlabsize(vsmall)) ///
	(function y = x, range(0 6)), ///
	title(Hibbs' weighting, size(medlarge)) legend(off) ///
	text(6 0 "r=`r'", place(e) size(medsmall)) ///
	xtitle(Real-Time) ytitle(Vintage) scale(1.5) name(fig5h)

* Wlezien's weighting

corr wGNDP_2012 wGNDP_rt
local r = round(r(rho),.01)
tw (scatter wGNDP_2012 wGNDP_rt, mlabel(year) mlabsize(vsmall)) ///
	(function y = x, range(0 6)), ///
	title(Wlezien's weighting, size(medlarge)) legend(off) ///
	text(6 0 "r=`r'", place(e) size(medsmall)) ///
	xtitle(Real-Time) ytitle(Vintage) scale(1.5) name(fig5w)

* display both graphs
* graph combine fig5h fig5w

clear


********************************************************************************
* Table 4
********************************************************************************

/*
Table 4: Mean Errors across models and vintages.
*/

*******
* Hibbs
*******

use "data.dta"

* Create the variables to hold the predicted popular vote share obtained with 
* different vintages and real-time data
forvalues vintage=1984(4)2012{
	gen r2_hw_v`vintage'=.
	gen yhat_hw_v`vintage'=.
	gen e_hw_v`vintage'=.
	gen eabs_hw_v`vintage'=.
}

* and 2014
gen r2_hw_v2014=.
gen yhat_hw_v2014=.
gen e_hw_v2014=.
gen eabs_hw_v2014=.

gen yhat_hw_rt=.
gen e_hw_rt=.
gen eabs_hw_rt=.
gen yhat_hw_rtext=.
gen e_hw_rtext=.
gen eabs_hw_rtext=.

cap gen r2_vp=.
cap gen r2_rtext=.	

* Loop through elections 1984 (id=10) to 2012 (id=17) and vintages 84 to 2012 for 
* out-of-sample-forecasts
forvalues loopid=10/17 { //loop through elections

	foreach vintage in 1984 1988 1992 1996 2000 2004 2008 2012 2014 { //loop through vintages 
																											 //for a given election
			quietly reg vote  july_popularity hGNDP_`vintage' if id<`loopid'
			replace r2_vp = e(r2) if id==`loopid' & `vintage'==year[`loopid']
			replace r2_hw_v`vintage' = e(r2) if id==`loopid'
			quietly predict yhat_temp 
			quietly replace yhat_hw_v`vintage'=yhat_temp if id==`loopid'
			quietly replace e_hw_v`vintage'=yhat_hw_v`vintage'-vote
			quietly replace eabs_hw_v`vintage'=abs(e_hw_v`vintage')
			quietly drop yhat_temp
			display `vintage' " " `loopid'
	}
	
} //we now have forecast for election 1984-2012 using vintages election year-2012

* Loop through elections 1984 (id=10) to 2012 (id=17) for out-of-sample-forecasts
* using real-time data
forvalues loopid=10/17 { //loop through elections

	* real-time real gnp/gdp
	reg vote  july_popularity hGNDP_rt if id<`loopid'
	
	quietly predict yhat_temp 
	quietly replace yhat_hw_rt=yhat_temp if id==`loopid'
	quietly replace e_hw_rt=yhat_hw_rt-vote
	quietly replace eabs_hw_rt=abs(e_hw_rt)
	quietly drop yhat_temp
	
}


* create variables that hold predictions and prediction errors for a given year, 
* obs are different vintages
forvalues vintage=1984(4)2012 {
	gen yhat_hw_`vintage'=.	/* contains forecasts for the same election \
														(year: `vintage') obtained 
														with different data vintages (1984-2012)*/
														/*puts values for yhat_v84 to yhat_v12 variables 
														for `vintage' observation into one variable for plotting*/
	gen eabs_hw_`vintage'=. 	//analogous to above but contains absolute prediction errors
}

* and 2014
set obs 18
replace id = 18 if _n == 18
replace year = 2014 if _n == 18

forvalues loopid=10/17 { //loop through elections

	local election=year[`loopid'] //sets election year
	di `election'
	
	forvalues vintage=1984(4)2012 { //loop through vintages for 
																							 //a given election
	
		replace yhat_hw_`election'=yhat_hw_v`vintage'[`loopid'] if year==`vintage' 
		/*writes data from election year observation into variable yht_hw_`election', 
		obs of this variable are vintages*/
		
		replace eabs_hw_`election'=eabs_hw_v`vintage'[`loopid'] if year==`vintage'
		//ananlogous for error
		
		capture label variable eabs_hw_`vintage' "`vintage'"
	}
} 	/* we now have variables containing the forecasts for elections 1984 through 2012,
	     observations for these variables are the different vintages used to predict 
			 vote share */
* For 2014
forvalues loopid=10/17 {
	local election=year[`loopid'] //sets election year
	replace yhat_hw_`election'=yhat_hw_v2014[`loopid'] if year==2014 // 2014
	replace eabs_hw_`election'=eabs_hw_v2014[`loopid'] if year==2014	// 2014 
}

* Create variables necessary for plotting
gen yhat_hw_vp=. // variable to hold forecast for an election obtained with data 
									// vintage available shortly before election
gen e_hw_vp=. // will contain vote-yhat_vp
gen eabs_hw_vp=. // will contain abs(vote-yhat_vp)

forvalues loopid=10/17 { // loops through obs
		local vintage=year[`loopid']
		replace yhat_hw_vp=yhat_hw_v`vintage' if id==`loopid'
		replace e_hw_vp=e_hw_v`vintage' if id==`loopid'
		replace eabs_hw_vp=eabs_hw_v`vintage' if id==`loopid'
}

gen differ_rt=eabs_hw_rt-eabs_hw_vp  // difference to prediction using vintage data
gen eabs_hw_2012_squared = eabs_hw_v2012^2
gen eabs_hw_vp_squared = eabs_hw_vp^2

* Calculate the squared error
capture gen	eabs_hw_v2012_squared = eabs_hw_v2012^2
capture gen eabs_hw_vp_squared = eabs_hw_vp^2
capture gen eabs_hw_rt_squared = eabs_hw_rt^2

* create weights
gen numobs=.
gen df=.
gen tvalue=.
forvalues i=1/8 {
 replace numobs=8+`i' if year==1980+`i'*4
 replace df=5+`i' if year==1980+`i'*4
 replace tvalue=round(invttail(5+`i',0.025), .01) if year==1980+`i'*4
}
gen rec_tvalue=1/tvalue

quietly sum numobs
gen nweight=numobs/r(sum)
quietly sum df
gen dfweight=df/r(sum)
quietly sum rec_tvalue
gen rectvalweight=rec_tvalue/r(sum)

* Calculate average errors and write them into a matrix
mat define Errors = J(3,8,.)
mat rownames Errors = "2012~vintage " "Most~recent~vintage" "Real-time"
mat colnames Errors = "MAE" "RMSE" "MAE~(n)" "RMSE~(n)" "MAE~(df)" "RMSE~(df)" "MAE~(1/t)" "RMSE~(1/t)" 

local n=0
foreach ts in v2012 vp rt {
	* MAE unweighted
	local n `n'+1
	sum eabs_hw_`ts'
  mat Errors[`n',1] = r(mean)
	
	* RMSE unweighted
	sum eabs_hw_`ts'_squared
  mat Errors[`n',2] = sqrt(r(mean))
	
	* MAE weighted by N
	scalar MAE_N_`ts'=0
	forvalues i=1/8 {
		scalar MAE_N_`ts' = MAE_N_`ts' + nweight[9+`i']*eabs_hw_`ts'[9+`i']
	}
	mat Errors[`n',3] = MAE_N_`ts'
	
	scalar RMSE_N_`ts'=0
	forvalues i=1/8 {
		scalar RMSE_N_`ts' = RMSE_N_`ts' + nweight[9+`i']*(eabs_hw_`ts'[9+`i']^2)
	}
	scalar RMSE_N_`ts' = sqrt(RMSE_N_`ts')
	mat Errors[`n',4] = RMSE_N_`ts'
	
	* MAE weighted by df
	scalar MAE_df_`ts'=0
	forvalues i=1/8 {
		scalar MAE_df_`ts' = MAE_df_`ts' + dfweight[9+`i']*eabs_hw_`ts'[9+`i']
	}
	mat Errors[`n',5] = MAE_df_`ts'
	
	*RMSE weighted by df
	scalar RMSE_df_`ts'=0
	forvalues i=1/8 {
		scalar RMSE_df_`ts' = RMSE_df_`ts' + dfweight[9+`i']*(eabs_hw_`ts'[9+`i']^2)
	}
	scalar RMSE_df_`ts' = sqrt(RMSE_df_`ts')
	mat Errors[`n',6] = RMSE_df_`ts'
	
	* MAE weighted by 1/t
	scalar MAE_rectval_`ts'=0
	forvalues i=1/8 {
		scalar MAE_rectval_`ts' = MAE_rectval_`ts' + rectvalweight[9+`i']*eabs_hw_`ts'[9+`i']
	}
	mat Errors[`n',7] = MAE_rectval_`ts'
	
	*RMSE weighted by rectval
	scalar RMSE_rectval_`ts'=0
	forvalues i=1/8 {
		scalar RMSE_rectval_`ts' = RMSE_rectval_`ts' + rectvalweight[9+`i']*(eabs_hw_`ts'[9+`i']^2)
	}
	scalar RMSE_rectval_`ts' = sqrt(RMSE_rectval_`ts')
	mat Errors[`n',8] = RMSE_rectval_`ts'
	
}

mat define ErrorsRounded = J(4,8,.)
mat rownames ErrorsRounded = "2012~vintage " "Most~recent~vintage" "Real-time" "Real-time~extended"
mat colnames ErrorsRounded = "MAE" "RMSE" "MAE~(n)" "RMSE~(n)" "MAE~(df)" "RMSE~(df)" "MAE~(1/t)" "RMSE~(1/t)" 

forvalues i=1/3 {
	forvalues j=1/8 {
			mat ErrorsRounded[`i',`j'] = round(Errors[`i',`j'], .01)
		}
}

mat list ErrorsRounded

mat Errorshw = ErrorsRounded[1..3,1..2] , ErrorsRounded[1..3,5..6]
mat rownames Errorshw = "2002 vintage" "Most recent vintage" "Real-time"
mat colnames Errorshw = "MAE" "RMSE" "MAE (df)" "RMSE (df)"
mat list Errorshw

clear


*********
* Wlezien
*********

use "data.dta"

* Create the variables to hold the predicted popular vote share obtained with 
* different vintages and real-time data
forvalues vintage=1984(4)2012{
	gen r2_ww_v`vintage'=.
	gen yhat_ww_v`vintage'=.
	gen e_ww_v`vintage'=.
	gen eabs_ww_v`vintage'=.
}

* and 2014
gen r2_ww_v2014=.
gen yhat_ww_v2014=.
gen e_ww_v2014=.
gen eabs_ww_v2014=.

gen yhat_ww_rt=.
gen e_ww_rt=.
gen eabs_ww_rt=.
gen yhat_ww_rtext=.
gen e_ww_rtext=.
gen eabs_ww_rtext=.

cap gen r2_vp=.
cap gen r2_rtext=.	

* Loop through elections 1984 (id=10) to 2012 (id=17) and vintages 84 to 2012 for 
* out-of-sample-forecasts
forvalues loopid=10/17 { //loop through elections

	foreach vintage in 1984 1988 1992 1996 2000 2004 2008 2012 2014 { //loop through vintages 
																											 //for a given election
			quietly reg vote  july_popularity wGNDP_`vintage' if id<`loopid'
			replace r2_vp = e(r2) if id==`loopid' & `vintage'==year[`loopid']
			replace r2_ww_v`vintage' = e(r2) if id==`loopid'
			quietly predict yhat_temp 
			quietly replace yhat_ww_v`vintage'=yhat_temp if id==`loopid'
			quietly replace e_ww_v`vintage'=yhat_ww_v`vintage'-vote
			quietly replace eabs_ww_v`vintage'=abs(e_ww_v`vintage')
			quietly drop yhat_temp
			display `vintage' " " `loopid'
	}
	
} //we now have forecast for election 1984-2012 using vintages election year-2012

* Loop through elections 1984 (id=10) to 2012 (id=17) for out-of-sample-forecasts
* using real-time data
forvalues loopid=10/17 { //loop through elections

	* real-time real gnp/gdp
	reg vote  july_popularity hGNDP_rt if id<`loopid'
	
	quietly predict yhat_temp 
	quietly replace yhat_ww_rt=yhat_temp if id==`loopid'
	quietly replace e_ww_rt=yhat_ww_rt-vote
	quietly replace eabs_ww_rt=abs(e_ww_rt)
	quietly drop yhat_temp
	
}


* create variables that hold predictions and prediction errors for a given year, 
* obs are different vintages
forvalues vintage=1984(4)2012 {
	gen yhat_ww_`vintage'=.	/* contains forecasts for the same election \
														(year: `vintage') obtained 
														with different data vintages (1984-2012)*/
														/*puts values for yhat_v84 to yhat_v12 variables 
														for `vintage' observation into one variable for plotting*/
	gen eabs_ww_`vintage'=. 	//analogous to above but contains absolute prediction errors
}

* and 2014
set obs 18
replace id = 18 if _n == 18
replace year = 2014 if _n == 18

forvalues loopid=10/17 { //loop through elections

	local election=year[`loopid'] //sets election year
	di `election'
	
	forvalues vintage=1984(4)2012 { //loop through vintages for 
																							 //a given election
	
		replace yhat_ww_`election'=yhat_ww_v`vintage'[`loopid'] if year==`vintage' 
		/*writes data from election year observation into variable yht_ww_`election', 
		obs of this variable are vintages*/
		
		replace eabs_ww_`election'=eabs_ww_v`vintage'[`loopid'] if year==`vintage'
		//ananlogous for error
		
		capture label variable eabs_ww_`vintage' "`vintage'"
	}
} 	/* we now have variables containing the forecasts for elections 1984 through 2012,
	     observations for these variables are the different vintages used to predict 
			 vote share */
* For 2014
forvalues loopid=10/17 {
	local election=year[`loopid'] //sets election year
	replace yhat_ww_`election'=yhat_ww_v2014[`loopid'] if year==2014 // 2014
	replace eabs_ww_`election'=eabs_ww_v2014[`loopid'] if year==2014	// 2014 
}

* Create variables necessary for plotting
gen yhat_ww_vp=. // variable to hold forecast for an election obtained with data 
									// vintage available shortly before election
gen e_ww_vp=. // will contain vote-yhat_vp
gen eabs_ww_vp=. // will contain abs(vote-yhat_vp)

forvalues loopid=10/17 { // loops through obs
		local vintage=year[`loopid']
		replace yhat_ww_vp=yhat_ww_v`vintage' if id==`loopid'
		replace e_ww_vp=e_ww_v`vintage' if id==`loopid'
		replace eabs_ww_vp=eabs_ww_v`vintage' if id==`loopid'
}

gen differ_rt=eabs_ww_rt-eabs_ww_vp  // difference to prediction using vintage data
gen eabs_ww_2012_squared = eabs_ww_v2012^2
gen eabs_ww_vp_squared = eabs_ww_vp^2

* Calculate the squared error
capture gen	eabs_ww_v2012_squared = eabs_ww_v2012^2
capture gen eabs_ww_vp_squared = eabs_ww_vp^2
capture gen eabs_ww_rt_squared = eabs_ww_rt^2

* create weights
gen numobs=.
gen df=.
gen tvalue=.
forvalues i=1/8 {
 replace numobs=8+`i' if year==1980+`i'*4
 replace df=5+`i' if year==1980+`i'*4
 replace tvalue=round(invttail(5+`i',0.025), .01) if year==1980+`i'*4
}
gen rec_tvalue=1/tvalue

quietly sum numobs
gen nweight=numobs/r(sum)
quietly sum df
gen dfweight=df/r(sum)
quietly sum rec_tvalue
gen rectvalweight=rec_tvalue/r(sum)

* Calculate average errors and write them into a matrix
mat define Errors = J(3,8,.)
mat rownames Errors = "2012~vintage " "Most~recent~vintage" "Real-time"
mat colnames Errors = "MAE" "RMSE" "MAE~(n)" "RMSE~(n)" "MAE~(df)" "RMSE~(df)" "MAE~(1/t)" "RMSE~(1/t)" 

local n=0
foreach ts in v2012 vp rt {
	* MAE unweighted
	local n `n'+1
	sum eabs_ww_`ts'
  mat Errors[`n',1] = r(mean)
	
	* RMSE unweighted
	sum eabs_ww_`ts'_squared
  mat Errors[`n',2] = sqrt(r(mean))
	
	* MAE weighted by N
	scalar MAE_N_`ts'=0
	forvalues i=1/8 {
		scalar MAE_N_`ts' = MAE_N_`ts' + nweight[9+`i']*eabs_ww_`ts'[9+`i']
	}
	mat Errors[`n',3] = MAE_N_`ts'
	
	scalar RMSE_N_`ts'=0
	forvalues i=1/8 {
		scalar RMSE_N_`ts' = RMSE_N_`ts' + nweight[9+`i']*(eabs_ww_`ts'[9+`i']^2)
	}
	scalar RMSE_N_`ts' = sqrt(RMSE_N_`ts')
	mat Errors[`n',4] = RMSE_N_`ts'
	
	* MAE weighted by df
	scalar MAE_df_`ts'=0
	forvalues i=1/8 {
		scalar MAE_df_`ts' = MAE_df_`ts' + dfweight[9+`i']*eabs_ww_`ts'[9+`i']
	}
	mat Errors[`n',5] = MAE_df_`ts'
	
	*RMSE weighted by df
	scalar RMSE_df_`ts'=0
	forvalues i=1/8 {
		scalar RMSE_df_`ts' = RMSE_df_`ts' + dfweight[9+`i']*(eabs_ww_`ts'[9+`i']^2)
	}
	scalar RMSE_df_`ts' = sqrt(RMSE_df_`ts')
	mat Errors[`n',6] = RMSE_df_`ts'
	
	* MAE weighted by 1/t
	scalar MAE_rectval_`ts'=0
	forvalues i=1/8 {
		scalar MAE_rectval_`ts' = MAE_rectval_`ts' + rectvalweight[9+`i']*eabs_ww_`ts'[9+`i']
	}
	mat Errors[`n',7] = MAE_rectval_`ts'
	
	*RMSE weighted by rectval
	scalar RMSE_rectval_`ts'=0
	forvalues i=1/8 {
		scalar RMSE_rectval_`ts' = RMSE_rectval_`ts' + rectvalweight[9+`i']*(eabs_ww_`ts'[9+`i']^2)
	}
	scalar RMSE_rectval_`ts' = sqrt(RMSE_rectval_`ts')
	mat Errors[`n',8] = RMSE_rectval_`ts'
	
}

mat define ErrorsRounded = J(4,8,.)
mat rownames ErrorsRounded = "2012~vintage " "Most~recent~vintage" "Real-time" "Real-time~extended"
mat colnames ErrorsRounded = "MAE" "RMSE" "MAE~(n)" "RMSE~(n)" "MAE~(df)" "RMSE~(df)" "MAE~(1/t)" "RMSE~(1/t)" 

forvalues i=1/3 {
	forvalues j=1/8 {
			mat ErrorsRounded[`i',`j'] = round(Errors[`i',`j'], .01)
		}
}

mat list ErrorsRounded

mat Errorsww = ErrorsRounded[1..3,1..2] , ErrorsRounded[1..3,5..6]
mat rownames Errorsww = "2002 vintage" "Most recent vintage" "Real-time"
mat colnames Errorsww = "MAE" "RMSE" "MAE (df)" "RMSE (df)"
mat list Errorsww

* both Errors Matrices

mat list Errorshw
mat list Errorsww

clear


********************************************************************************
* Figure 5
********************************************************************************

/*
Figure 5: Real-time vs. vintage data: Forecasting Errors in Comparison. Difference in
forecasting error between out-of-sample forecasts using election year vintage data and real-
time data for elections 1984 - 2012. Negative values indicate greater error in forecasts based
on most-recent-vintage data (actual practice). Regression line based on bivariate OLS model
(significant coefficients indicated by solid line).
*/

*******
* Hibbs
*******

use "data.dta"

* Create the variables to hold the predicted popular vote share obtained with 
* different vintages and real-time data
forvalues vintage=1984(4)2012{
	gen r2_hw_v`vintage'=.
	gen yhat_hw_v`vintage'=.
	gen e_hw_v`vintage'=.
	gen eabs_hw_v`vintage'=.
}

* and 2014
gen r2_hw_v2014=.
gen yhat_hw_v2014=.
gen e_hw_v2014=.
gen eabs_hw_v2014=.

gen yhat_hw_rt=.
gen e_hw_rt=.
gen eabs_hw_rt=.
gen yhat_hw_rtext=.
gen e_hw_rtext=.
gen eabs_hw_rtext=.

cap gen r2_vp=.
cap gen r2_rtext=.	

* Loop through elections 1984 (id=10) to 2012 (id=17) and vintages 84 to 2012 for 
* out-of-sample-forecasts
forvalues loopid=10/17 { //loop through elections

	foreach vintage in 1984 1988 1992 1996 2000 2004 2008 2012 2014 { //loop through vintages 
																											 //for a given election
			quietly reg vote  july_popularity hGNDP_`vintage' if id<`loopid'
			replace r2_vp = e(r2) if id==`loopid' & `vintage'==year[`loopid']
			replace r2_hw_v`vintage' = e(r2) if id==`loopid'
			quietly predict yhat_temp 
			quietly replace yhat_hw_v`vintage'=yhat_temp if id==`loopid'
			quietly replace e_hw_v`vintage'=yhat_hw_v`vintage'-vote
			quietly replace eabs_hw_v`vintage'=abs(e_hw_v`vintage')
			quietly drop yhat_temp
			display `vintage' " " `loopid'
	}
	
} //we now have forecast for election 1984-2012 using vintages election year-2012

* Loop through elections 1984 (id=10) to 2012 (id=17) for out-of-sample-forecasts
* using real-time data
forvalues loopid=10/17 { //loop through elections

	* real-time real gnp/gdp
	reg vote  july_popularity hGNDP_rt if id<`loopid'
	
	quietly predict yhat_temp 
	quietly replace yhat_hw_rt=yhat_temp if id==`loopid'
	quietly replace e_hw_rt=yhat_hw_rt-vote
	quietly replace eabs_hw_rt=abs(e_hw_rt)
	quietly drop yhat_temp
	
}


* create variables that hold predictions and prediction errors for a given year, 
* obs are different vintages
forvalues vintage=1984(4)2012 {
	gen yhat_hw_`vintage'=.	/* contains forecasts for the same election \
														(year: `vintage') obtained 
														with different data vintages (1984-2012)*/
														/*puts values for yhat_v84 to yhat_v12 variables 
														for `vintage' observation into one variable for plotting*/
	gen eabs_hw_`vintage'=. 	//analogous to above but contains absolute prediction errors
}

* and 2014
set obs 18
replace id = 18 if _n == 18
replace year = 2014 if _n == 18

forvalues loopid=10/17 { //loop through elections

	local election=year[`loopid'] //sets election year
	di `election'
	
	forvalues vintage=1984(4)2012 { //loop through vintages for 
																							 //a given election
	
		replace yhat_hw_`election'=yhat_hw_v`vintage'[`loopid'] if year==`vintage' 
		/*writes data from election year observation into variable yht_hw_`election', 
		obs of this variable are vintages*/
		
		replace eabs_hw_`election'=eabs_hw_v`vintage'[`loopid'] if year==`vintage'
		//ananlogous for error
		
		capture label variable eabs_hw_`vintage' "`vintage'"
	}
} 	/* we now have variables containing the forecasts for elections 1984 through 2012,
	     observations for these variables are the different vintages used to predict 
			 vote share */
* For 2014
forvalues loopid=10/17 {
	local election=year[`loopid'] //sets election year
	replace yhat_hw_`election'=yhat_hw_v2014[`loopid'] if year==2014 // 2014
	replace eabs_hw_`election'=eabs_hw_v2014[`loopid'] if year==2014	// 2014 
}

* Create variables necessary for plotting
gen yhat_hw_vp=. // variable to hold forecast for an election obtained with data 
									// vintage available shortly before election
gen e_hw_vp=. // will contain vote-yhat_vp
gen eabs_hw_vp=. // will contain abs(vote-yhat_vp)

forvalues loopid=10/17 { // loops through obs
		local vintage=year[`loopid']
		replace yhat_hw_vp=yhat_hw_v`vintage' if id==`loopid'
		replace e_hw_vp=e_hw_v`vintage' if id==`loopid'
		replace eabs_hw_vp=eabs_hw_v`vintage' if id==`loopid'
}

gen differ_rt=eabs_hw_rt-eabs_hw_vp  // difference to prediction using vintage data
gen eabs_hw_2012_squared = eabs_hw_v2012^2
gen eabs_hw_vp_squared = eabs_hw_vp^2


* Plot comparison of most recent vintage vs. real-time data for elections '84-'12

reg differ_rt year
estimates store diffhw

twoway (scatter differ_rt year, msymbol(circle) mcolor(black)) ///
	(function y=_b[_cons]+_b[year]*x, range(1984 2012) lcolor(black) lwidth(medthick) lpattern(dash)) ///
								 || if year >=1984, ///
									yline(0) title("Hibbs' weighting", size(medlarge)) ///
									xtitle("") ytitle("") xlabel(1984(4)2012) ///
									legend(off) scale(1.5) name(fig6h)
							
clear


*********
* Wlezien
*********

use "data.dta"

* Create the variables to hold the predicted popular vote share obtained with 
* different vintages and real-time data
forvalues vintage=1984(4)2012{
	gen r2_ww_v`vintage'=.
	gen yhat_ww_v`vintage'=.
	gen e_ww_v`vintage'=.
	gen eabs_ww_v`vintage'=.
}

* and 2014
gen r2_ww_v2014=.
gen yhat_ww_v2014=.
gen e_ww_v2014=.
gen eabs_ww_v2014=.

gen yhat_ww_rt=.
gen e_ww_rt=.
gen eabs_ww_rt=.
gen yhat_ww_rtext=.
gen e_ww_rtext=.
gen eabs_ww_rtext=.

cap gen r2_vp=.
cap gen r2_rtext=.	

* Loop through elections 1984 (id=10) to 2012 (id=17) and vintages 84 to 2012 for 
* out-of-sample-forecasts
forvalues loopid=10/17 { //loop through elections

	foreach vintage in 1984 1988 1992 1996 2000 2004 2008 2012 2014 { //loop through vintages 
																											 //for a given election
			quietly reg vote  july_popularity wGNDP_`vintage' if id<`loopid'
			replace r2_vp = e(r2) if id==`loopid' & `vintage'==year[`loopid']
			replace r2_ww_v`vintage' = e(r2) if id==`loopid'
			quietly predict yhat_temp 
			quietly replace yhat_ww_v`vintage'=yhat_temp if id==`loopid'
			quietly replace e_ww_v`vintage'=yhat_ww_v`vintage'-vote
			quietly replace eabs_ww_v`vintage'=abs(e_ww_v`vintage')
			quietly drop yhat_temp
			display `vintage' " " `loopid'
	}
	
} //we now have forecast for election 1984-2012 using vintages election year-2012

* Loop through elections 1984 (id=10) to 2012 (id=17) for out-of-sample-forecasts
* using real-time data
forvalues loopid=10/17 { //loop through elections

	* real-time real gnp/gdp
	reg vote  july_popularity hGNDP_rt if id<`loopid'
	
	quietly predict yhat_temp 
	quietly replace yhat_ww_rt=yhat_temp if id==`loopid'
	quietly replace e_ww_rt=yhat_ww_rt-vote
	quietly replace eabs_ww_rt=abs(e_ww_rt)
	quietly drop yhat_temp
	
}


* create variables that hold predictions and prediction errors for a given year, 
* obs are different vintages
forvalues vintage=1984(4)2012 {
	gen yhat_ww_`vintage'=.	/* contains forecasts for the same election \
														(year: `vintage') obtained 
														with different data vintages (1984-2012)*/
														/*puts values for yhat_v84 to yhat_v12 variables 
														for `vintage' observation into one variable for plotting*/
	gen eabs_ww_`vintage'=. 	//analogous to above but contains absolute prediction errors
}

* and 2014
set obs 18
replace id = 18 if _n == 18
replace year = 2014 if _n == 18

forvalues loopid=10/17 { //loop through elections

	local election=year[`loopid'] //sets election year
	di `election'
	
	forvalues vintage=1984(4)2012 { //loop through vintages for 
																							 //a given election
	
		replace yhat_ww_`election'=yhat_ww_v`vintage'[`loopid'] if year==`vintage' 
		/*writes data from election year observation into variable yht_ww_`election', 
		obs of this variable are vintages*/
		
		replace eabs_ww_`election'=eabs_ww_v`vintage'[`loopid'] if year==`vintage'
		//ananlogous for error
		
		capture label variable eabs_ww_`vintage' "`vintage'"
	}
} 	/* we now have variables containing the forecasts for elections 1984 through 2012,
	     observations for these variables are the different vintages used to predict 
			 vote share */
* For 2014
forvalues loopid=10/17 {
	local election=year[`loopid'] //sets election year
	replace yhat_ww_`election'=yhat_ww_v2014[`loopid'] if year==2014 // 2014
	replace eabs_ww_`election'=eabs_ww_v2014[`loopid'] if year==2014	// 2014 
}

* Create variables necessary for plotting
gen yhat_ww_vp=. // variable to hold forecast for an election obtained with data 
									// vintage available shortly before election
gen e_ww_vp=. // will contain vote-yhat_vp
gen eabs_ww_vp=. // will contain abs(vote-yhat_vp)

forvalues loopid=10/17 { // loops through obs
		local vintage=year[`loopid']
		replace yhat_ww_vp=yhat_ww_v`vintage' if id==`loopid'
		replace e_ww_vp=e_ww_v`vintage' if id==`loopid'
		replace eabs_ww_vp=eabs_ww_v`vintage' if id==`loopid'
}

gen differ_rt=eabs_ww_rt-eabs_ww_vp  // difference to prediction using vintage data
gen eabs_ww_2012_squared = eabs_ww_v2012^2
gen eabs_ww_vp_squared = eabs_ww_vp^2

* Plot comparison of most recent vintage vs. real-time data for elections '84-'12	

reg differ_rt year
estimates store diffww

twoway (scatter differ_rt year, msymbol(circle) mcolor(black)) ///
	(function y=_b[_cons]+_b[year]*x, range(1984 2012) lcolor(black) lwidth(medthick) lpattern(dash)) ///
								 || if year >=1984, ///
									yline(0) title("Wlezien's weighting", size(medlarge)) ///
									xtitle("") ytitle("") xlabel(1984(4)2012) ///
									legend(off) scale(1.5) name(fig6w)							

* display both graphs
* graph combine fig6h fig6w

clear


********************************************************************************
* Table 5
********************************************************************************

/*
Table 5: Comparison of predictions obtained with most-recent vintage and real-time data.
*/

*******************
* Lewis-Beck & Tien
*******************

use "data.dta"

* Create the variables to hold the predicted popular vote share obtained with 
* different vintages and real-time data
forvalues vintage=1984(4)2012{
	gen r2_lbt_v`vintage'=. 
	gen yhat_lbt_v`vintage'=.
	gen e_lbt_v`vintage'=.
	gen eabs_lbt_v`vintage'=.
}
* and 2014
gen r2_lbt_v2014=.
gen yhat_lbt_v2014=.
gen e_lbt_v2014=.
gen eabs_lbt_v2014=.


gen yhat_lbt_rt=.
gen e_lbt_rt=.
gen eabs_lbt_rt=.
gen yhat_lbt_rtext=.
gen e_lbt_rtext=.
gen eabs_lbt_rtext=.

cap gen r2_vp=.
cap gen r2_rtext=.

* Loop through elections 1984 (id=10) to 2012 (id=17) and vintages 84 to 2012 for 
* out-of-sample-forecasts
forvalues loopid=10/17 { //loop through elections

	foreach vintage in 1984 1988 1992 1996 2000 2004 2008 2012 2014 { //loop through vintages 
																											 //for a given election
			quietly reg vote july_popularity gndp_change_v`vintage' if id<`loopid'
			quietly replace r2_vp = e(r2) if id==`loopid' & year==`vintage'
			quietly replace r2_lbt_v`vintage'= e(r2) if id ==`loopid'
			quietly predict yhat_temp 
			quietly replace yhat_lbt_v`vintage'=yhat_temp if id==`loopid'
			quietly replace e_lbt_v`vintage'=yhat_lbt_v`vintage'-vote
			quietly replace eabs_lbt_v`vintage'=abs(e_lbt_v`vintage')
			quietly drop yhat_temp
			display `vintage' " " `loopid'
	}
	
} //we now have forecast for election 1984-2012 using vintages election year-2012

* Loop through elections 1984 (id=10) to 2012 (id=17) for out-of-sample-forecasts
* using real-time data
forvalues loopid=10/17 { //loop through elections

	* real-time real gnp/gdp
	quietly reg vote july_popularity rt_rgndp_change if id<`loopid'

	quietly predict yhat_temp 
	quietly replace yhat_lbt_rt=yhat_temp if id==`loopid'
	quietly replace e_lbt_rt=yhat_lbt_rt-vote
	quietly replace eabs_lbt_rt=abs(e_lbt_rt)
	quietly drop yhat_temp
	
	* real-time extended ts
	quietly reg vote july_popularity rt_gndp_change_ext if id<`loopid'
	quietly replace r2_rtext = e(r2) if id==`loopid'
	quietly predict yhat_temp 
	quietly replace yhat_lbt_rtext=yhat_temp if id==`loopid'
	quietly replace e_lbt_rtext=yhat_lbt_rtext-vote
	quietly replace eabs_lbt_rtext=abs(e_lbt_rtext)
	quietly drop yhat_temp
}

gen yhat_lbt_`vintage'=.

* create variables that hold predictions and prediction errors for a given year, 
* obs are different vintages
forvalues vintage=1984(4)2012 {
	gen yhat_lbt_`vintage'=.	/* contains forecasts for the same election \
														(year: `vintage') obtained 
														with different data vintages (1984-2012)*/
														/*puts values for yhat_v84 to yhat_v12 variables 
														for `vintage' observation into one variable for plotting*/
	gen eabs_lbt_`vintage'=. 	//analogous to above but contains absolute prediction errors
}

* and 2014
set obs 18
replace id = 18 if _n == 18
replace year = 2014 if _n == 18

forvalues loopid=10/17 { //loop through elections

	local election=year[`loopid'] //sets election year
	di `election'
	
	forvalues vintage=1984(4)2012 { //loop through vintages for 
																							 //a given election
	
		replace yhat_lbt_`election'=yhat_lbt_v`vintage'[`loopid'] if year==`vintage' 
		/*writes data from election year observation into variable yht_lbt_`election', 
		obs of this variable are vintages*/
		
		
		replace eabs_lbt_`election'=eabs_lbt_v`vintage'[`loopid'] if year==`vintage'	
		//ananlogous for error
		
		
		capture label variable eabs_lbt_`vintage' "`vintage'"
	}
} 	/* we now have variables containing the forecasts for elections 1984 through 2012,
	     observations for these variables are the different vintages used to predict 
			 vote share */
* For 2014
forvalues loopid=10/17 {
	local election=year[`loopid'] //sets election year
	replace yhat_lbt_`election'=yhat_lbt_v2014[`loopid'] if year==2014 // 2014
	replace eabs_lbt_`election'=eabs_lbt_v2014[`loopid'] if year==2014	// 2014 
}	
			 
* Create variables necessary for plotting
gen yhat_lbt_vp=. // variable to hold forecast for an election obtained with data 
									// vintage available shortly before election
gen e_lbt_vp=. // will contain vote-yhat_vp
gen eabs_lbt_vp=. // will contain abs(vote-yhat_vp)


forvalues loopid=10/17 { // loops through obs
		local vintage=year[`loopid']
		replace yhat_lbt_vp=yhat_lbt_v`vintage' if id==`loopid'
		replace e_lbt_vp=e_lbt_v`vintage' if id==`loopid'
		replace eabs_lbt_vp=eabs_lbt_v`vintage' if id==`loopid'
}
* e_lbt_rtext

gen differ_rt=eabs_lbt_rt-eabs_lbt_vp  // difference to prediction using vintage data
gen differ_rtext=eabs_lbt_rtext-eabs_lbt_vp  // see above

* put most recent vintage predictions in one variable
gen yhat_lbt_v = .

forvalues loopid=10/17 {
local vintage = year[`loopid']
replace yhat_lbt_v = yhat_lbt_v`vintage' if _n == `loopid'
}

gen diffwinner = (yhat_lbt_v > 50 & yhat_lbt_rtext < 50) | (yhat_lbt_v < 50 & yhat_lbt_rtext > 50)

list year yhat_lbt_v yhat_lbt_rtext diffwinner

clear


************
* Abramowitz
************

use "data.dta"

* Create the variables to hold the predicted popular vote share obtained 
* with different vintages
foreach vintage in 84 88 92 96 00 04 08 12 14 {
	gen r2_a_v`vintage'=.
	gen yhat_a_v`vintage'=.
	gen e_a_v`vintage'=.
	gen eabs_a_v`vintage'=.
}

gen yhat_a_rt=.
gen e_a_rt=.
gen eabs_a_rt=.

gen yhat_a_rtext=.
gen e_a_rtext=.
gen eabs_a_rtext=.

cap gen r2_vp=.
cap gen r2_rtext=.

* Loop through elections 1984 (id=10) to 2012 (id=17) and vintages 84 to 2012 for 
* out-of-sample-forecasts
forvalues loopid=10/17 { //loop through elections

	foreach vintage in 84 88 92 96 00 04 08 12 14 { //loop through vintages for a given election
			quietly reg vote netapp rgndpQ2gr`vintage'_agr term1inc if id<`loopid'
			quietly replace r2_vp = e(r2) if id==`loopid' & vintage=="v`vintage'"
			quietly replace r2_a_v`vintage' = e(r2) if id==`loopid'
			quietly predict yhat_temp 
			quietly replace yhat_a_v`vintage'=yhat_temp if id==`loopid'
			quietly replace e_a_v`vintage'=yhat_a_v`vintage'-vote
			quietly replace eabs_a_v`vintage'=abs(e_a_v`vintage')
			quietly drop yhat_temp
			display `vintage' `loopid'
	}
	
}  // we now have forecast for election 1984-2012 using 
   // vintages election year-2012 and real-time data
	 
* Loop through elections 1984 (id=10) to 2012 (id=17) for out-of-sample-forecasts
* using real-time data

forvalues loopid=10/17 { //loop through elections
	quietly reg vote netapp rt_rgndpq2agr term1inc if id<`loopid' //real-time real gnp/gdp
	
	quietly predict yhat_temp 
	quietly replace yhat_a_rt=yhat_temp if id==`loopid'
	quietly replace e_a_rt=yhat_a_rt-vote
	quietly replace eabs_a_rt=abs(e_a_rt)
	quietly drop yhat_temp
	
	
	quietly reg vote netapp rt_gndpq2agr_ext term1inc if id<`loopid' //real-time extended ts
	replace r2_rtext = e(r2) if id==`loopid'
	quietly predict yhat_temp 
	quietly replace yhat_a_rtext=yhat_temp if id==`loopid'
	quietly replace e_a_rtext=yhat_a_rtext-vote
	quietly replace eabs_a_rtext=abs(e_a_rtext)
	quietly drop yhat_temp
}

* create variables that hold predictions and prediction errors for a given year, 
* obs are different vintages
foreach vintage in 84 88 92 96 00 04 08 12 14 {
	gen yhat_a_`vintage'=.	/* contains forecasts for the same election \
														(year: `vintage') obtained 
														with different data vintages (1984-2012)*/
														/*puts values for yhat_v84 to yhat_v12 variables 
														for `vintage' observation into one variable for plotting*/
	gen eabs_a_`vintage'=. 	//analogous to above but contains absolute prediction errors
}

* and 2014
set obs 18
replace id = 18 if _n == 18
replace year = 2014 if _n == 18

forvalues loopid=10/17 { //loop through elections

	local election=y[`loopid'] //sets election year
	di `election'
	
	foreach vintage in 84 88 92 96 00 04 08 12 { //loop through vintages for 
																							 //a given election
	
		replace yhat_a_`election'=yhat_a_v`vintage'[`loopid'] if y=="`vintage'" 
		/*writes data from election year observation into variable yht_a_`election', 
		obs of this variable are vintages*/
		
		replace eabs_a_`election'=eabs_a_v`vintage'[`loopid'] if y=="`vintage'"	
		//ananlogous for error
		
		capture label variable eabs_a_`vintage' "`vintage'"
	}
} 	/* we now have variables containing the forecasts for elections 1984 through 2012,
	     observations for these variables are the different vintages used to predict 
			 vote share */
* For 2014
forvalues loopid=10/17 {
	local election=y[`loopid'] //sets election year
	replace yhat_a_`election'=yhat_a_v14[`loopid'] if year==2014 // 2014
	replace eabs_a_`election'=eabs_a_v14[`loopid'] if year==2014	// 2014 
}					 
			 
			 
* Create variables necessary for plotting
gen yhat_a_vp=. // variable to hold forecast for an election obtained with data 
									// vintage available shortly before election
gen e_a_vp=. // will contain vote-yhat_vp
gen eabs_a_vp=. // will contain abs(vote-yhat_vp)

forvalues loopid=10/17 { // loops through obs
		local vintage=y[`loopid']
		replace yhat_a_vp=yhat_a_v`vintage' if id==`loopid'
		replace e_a_vp=e_a_v`vintage' if id==`loopid'
		replace eabs_a_vp=eabs_a_v`vintage' if id==`loopid'
}

gen differ_rt=eabs_a_rt-eabs_a_vp  // difference to prediction using vintage data
gen differ_rtext=eabs_a_rtext-eabs_a_vp  // see above


* put most recent vintage predictions in one variable
gen yhat_a_v = .

forvalues loopid=10/17 {
local vintage = y[`loopid']
replace yhat_a_v = yhat_a_v`vintage' if _n == `loopid'
}

gen diffwinner = (yhat_a_v > 50 & yhat_a_rtext < 50) | (yhat_a_v < 50 & yhat_a_rtext > 50)

list year yhat_a_v yhat_a_rtext diffwinner

clear


**********
* Campbell
**********

use "data.dta"

* Create Campbell Style vintage growth variable
foreach vintage in 84 88 92 96 00 04 08 12 14 {
	gen c_rgndpQ2gr`vintage'_agr=(rgndpQ2gr`vintage'_agr-2.5)*incweight
}

* Create Campbell Style real-time growth variable
gen c_rt_rgndpq2agr=(rt_rgndpq2agr-2.5)*incweight 
gen c_rt_gndpq2agr_ext=(rt_gndpq2agr_ext-2.5)*incweight

* Out of sample forecasts for 1984 to 2012 using 84 to 2012 vintages and real-time * 

* Create the variables to hold the predicted popular vote share obtained 
* with different vintages
foreach vintage in 84 88 92 96 00 04 08 12 14 {
	gen r2_c_`vintage'=.
	gen yhat_c_v`vintage'=.
	gen e_c_v`vintage'=.
	gen eabs_c_v`vintage'=.
}

gen yhat_c_rt=.
gen e_c_rt=.
gen eabs_c_rt=.

gen yhat_c_rtext=.
gen e_c_rtext=.
gen eabs_c_rtext=.

cap gen r2_vp=.
cap gen r2_rtext=.


* Loop through elections 1984 (id=10) to 2012 (id=17) and vintages 84 to 2012 for 
* out-of-sample-forecasts
forvalues loopid=10/17 { //loop through elections

	foreach vintage in 84 88 92 96 00 04 08 12 14 { //loop through vintages for a given election
			quietly reg vote earlyseptemberpoll c_rgndpQ2gr`vintage'_agr if id<`loopid'
			replace r2_vp = e(r2) if id==`loopid' & vintage=="v`vintage'"
			replace r2_c_`vintage' = e(r2) if id==`loopid'
			quietly predict yhat_temp 
			quietly replace yhat_c_v`vintage'=yhat_temp if id==`loopid'
			quietly replace e_c_v`vintage'=yhat_c_v`vintage'-vote
			quietly replace eabs_c_v`vintage'=abs(e_c_v`vintage')
			quietly drop yhat_temp
			display `vintage' `loopid'
	}
	
} //we now have forecast for election 1984-2012 using vintages election year-2012


* Loop through elections 1984 (id=10) to 2012 (id=17) for out-of-sample-forecasts
* using real-time data
forvalues loopid=10/17 { //loop through elections
	quietly reg vote earlyseptemberpoll c_rt_rgndpq2agr if id<`loopid' //real-time real gnp/gdp
	
	quietly predict yhat_temp 
	quietly replace yhat_c_rt=yhat_temp if id==`loopid'
	quietly replace e_c_rt=yhat_c_rt-vote
	quietly replace eabs_c_rt=abs(e_c_rt)
	quietly drop yhat_temp
	
	quietly reg vote earlyseptemberpoll c_rt_gndpq2agr_ext if id<`loopid' //real-time extended ts
	replace r2_rtext = e(r2) if id==`loopid'
	quietly predict yhat_temp 
	quietly replace yhat_c_rtext=yhat_temp if id==`loopid'
	quietly replace e_c_rtext=yhat_c_rtext-vote
	quietly replace eabs_c_rtext=abs(e_c_rtext)
	quietly drop yhat_temp
}

* create variables that hold predictions and prediction errors for a given year, 
* obs are different vintages
foreach vintage in 84 88 92 96 00 04 08 12 {
	gen yhat_c_`vintage'=.	/* contains forecasts for the same election \
														(year: `vintage') obtained 
														with different data vintages (1984-2012)*/
														/*puts values for yhat_v84 to yhat_v12 variables 
														for `vintage' observation into one variable for plotting*/
	gen eabs_c_`vintage'=. 	//analogous to above but contains absolute prediction errors
}

* and 2014
set obs 18
replace id = 18 if _n == 18
replace year = 2014 if _n == 18

forvalues loopid=10/17 { //loop through elections

	local election=y[`loopid'] //sets election year
	di `election'
	
	foreach vintage in 84 88 92 96 00 04 08 12 { //loop through vintages for 
																							 //a given election
	
		replace yhat_c_`election'=yhat_c_v`vintage'[`loopid'] if y=="`vintage'" 
		/*writes data from election year observation into variable yht_c_`election', 
		obs of this variable are vintages*/
		
		replace eabs_c_`election'=eabs_c_v`vintage'[`loopid'] if y=="`vintage'"	
		//ananlogous for error
		
		capture label variable eabs_c_`vintage' "`vintage'"
	}
} 	/* we now have variables containing the forecasts for elections 1984 through 2012,
	     observations for these variables are the different vintages used to predict 
			 vote share */
forvalues loopid=10/17 {
	local election=y[`loopid'] //sets election year
	replace yhat_c_`election'=yhat_c_v14[`loopid'] if year==2014 // 2014
	replace eabs_c_`election'=eabs_c_v14[`loopid'] if year==2014	// 2014 
}	
			 
* Create variables necessary for plotting
gen yhat_c_vp=. // variable to hold forecast for an election obtained with data 
									// vintage available shortly before election
gen e_c_vp=. // will contain abs(vote-yhat_vp)
gen eabs_c_vp=. // will contain abs(vote-yhat_vp)

forvalues loopid=10/17 { // loops through obs
		local vintage=y[`loopid']
		replace yhat_c_vp=yhat_c_v`vintage' if id==`loopid'
		replace e_c_vp=e_c_v`vintage' if id==`loopid'
		replace eabs_c_vp=eabs_c_v`vintage' if id==`loopid'
}

gen differ_rt=eabs_c_rt-eabs_c_vp  // difference to prediction using vintage data
gen differ_rtext=eabs_c_rtext-eabs_c_vp  // see above

* put most recent vintage predictions in one variable
gen yhat_c_v = .

forvalues loopid=10/17 {
local vintage = y[`loopid']
replace yhat_c_v = yhat_c_v`vintage' if _n == `loopid'
}

gen diffwinner = (yhat_c_v > 50 & yhat_c_rtext < 50) | (yhat_c_v < 50 & yhat_c_rtext > 50)

list year yhat_c_v yhat_c_rtext diffwinner

clear


***************
* End-heuristic
***************

use "data.dta"

* Create the variables to hold the predicted popular vote share obtained with 
* different vintages and real-time data
forvalues vintage=1984(4)2012{
	gen r2_kl_v`vintage'=.
	gen yhat_kl_v`vintage'=.
	gen e_kl_v`vintage'=.
	gen eabs_kl_v`vintage'=.
}

* and 2014
gen r2_kl_v2014=.
gen yhat_kl_v2014=.
gen e_kl_v2014=.
gen eabs_kl_v2014=.

gen yhat_kl_rt=.
gen e_kl_rt=.
gen eabs_kl_rt=.
gen yhat_kl_rtext=.
gen e_kl_rtext=.
gen eabs_kl_rtext=.

cap gen r2_vp=.
cap gen r2_rtext=.

* Loop through elections 1984 (id=10) to 2012 (id=17) and vintages 84 to 2012 for 
* out-of-sample-forecasts
forvalues loopid=10/17 { //loop through elections

	foreach vintage in 1984 1988 1992 1996 2000 2004 2008 2012 2014 { //loop through vintages 
																											 //for a given election
			quietly reg vote  july_popularity wgr2_1_v`vintage' if id<`loopid'
			replace r2_vp = e(r2) if id==`loopid' & `vintage'==year[`loopid']
			replace r2_kl_v`vintage' = e(r2) if id==`loopid'
			quietly predict yhat_temp 
			quietly replace yhat_kl_v`vintage'=yhat_temp if id==`loopid'
			quietly replace e_kl_v`vintage'=yhat_kl_v`vintage'-vote
			quietly replace eabs_kl_v`vintage'=abs(e_kl_v`vintage')
			quietly drop yhat_temp
			display `vintage' " " `loopid'
	}
	
} //we now have forecast for election 1984-2012 using vintages election year-2012

* Loop through elections 1984 (id=10) to 2012 (id=17) for out-of-sample-forecasts
* using real-time data
forvalues loopid=10/17 { //loop through elections

	* real-time real gnp/gdp
	reg vote july_popularity wgr2_1_rt if id<`loopid'
	
	quietly predict yhat_temp 
	quietly replace yhat_kl_rt=yhat_temp if id==`loopid'
	quietly replace e_kl_rt=yhat_kl_rt-vote
	quietly replace eabs_kl_rt=abs(e_kl_rt)
	quietly drop yhat_temp
	
	* real-time extended
	reg vote  july_popularity wgr2_1_rtext if id<`loopid'
	replace r2_rtext = e(r2) if id==`loopid'
	quietly predict yhat_temp 
	quietly replace yhat_kl_rtext=yhat_temp if id==`loopid'
	quietly replace e_kl_rtext=yhat_kl_rtext-vote
	quietly replace eabs_kl_rtext=abs(e_kl_rtext)
	quietly drop yhat_temp
	
}

* create variables that hold predictions and prediction errors for a given year, 
* obs are different vintages
forvalues vintage=1984(4)2012 {
	gen yhat_kl_`vintage'=.	/* contains forecasts for the same election \
														(year: `vintage') obtained 
														with different data vintages (1984-2012)*/
														/*puts values for yhat_v84 to yhat_v12 variables 
														for `vintage' observation into one variable for plotting*/
	gen eabs_kl_`vintage'=. 	//analogous to above but contains absolute prediction errors
}

* and 2014
set obs 18
replace id = 18 if _n == 18
replace year = 2014 if _n == 18

forvalues loopid=10/17 { //loop through elections

	local election=year[`loopid'] //sets election year
	di `election'
	
	forvalues vintage=1984(4)2012 { //loop through vintages for 
																							 //a given election
	
		replace yhat_kl_`election'=yhat_kl_v`vintage'[`loopid'] if year==`vintage' 
		/*writes data from election year observation into variable yht_kl_`election', 
		obs of this variable are vintages*/
		
		replace eabs_kl_`election'=eabs_kl_v`vintage'[`loopid'] if year==`vintage'
		//ananlogous for error
		
		capture label variable eabs_kl_`vintage' "`vintage'"
	}
} 	/* we now have variables containing the forecasts for elections 1984 through 2012,
	     observations for these variables are the different vintages used to predict 
			 vote share */
* For 2014
forvalues loopid=10/17 {
	local election=year[`loopid'] //sets election year
	replace yhat_kl_`election'=yhat_kl_v2014[`loopid'] if year==2014 // 2014
	replace eabs_kl_`election'=eabs_kl_v2014[`loopid'] if year==2014	// 2014 
}				 
			 
* Create variables necessary for plotting
gen yhat_kl_vp=. // variable to hold forecast for an election obtained with data 
									// vintage available shortly before election
gen e_kl_vp=. // will contain vote-yhat_vp
gen eabs_kl_vp=. // will contain abs(vote-yhat_vp)

forvalues loopid=10/17 { // loops through obs
		local vintage=year[`loopid']
		replace yhat_kl_vp=yhat_kl_v`vintage' if id==`loopid'
		replace e_kl_vp=e_kl_v`vintage' if id==`loopid'
		replace eabs_kl_vp=eabs_kl_v`vintage' if id==`loopid'
}

gen differ_rt=eabs_kl_rt-eabs_kl_vp  // difference to prediction using vintage data
gen differ_rtext=eabs_kl_rtext-eabs_kl_vp  // extended
gen eabs_kl_2012_squared = eabs_kl_v2012^2
gen eabs_kl_vp_squared = eabs_kl_vp^2
gen eabs_kl_rtext_squared = eabs_kl_rtext^2

* put most recent vintage predictions in one variable
gen yhat_kl_v = .

forvalues loopid=10/17 {
local vintage = year[`loopid']
replace yhat_kl_v = yhat_kl_v`vintage' if _n == `loopid'
}

gen diffwinner = (yhat_kl_v > 50 & yhat_kl_rtext < 50) | (yhat_kl_v < 50 & yhat_kl_rtext > 50)

list year yhat_kl_v yhat_kl_rtext diffwinner

clear

* Table was manually compiled from output generated by above code.

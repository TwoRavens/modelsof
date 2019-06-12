* "Vintage Errors" Replication Material (Paper)
* paper.do
* This do-file allows the reproduction in order of appearance of all figures
* and tables in the paper of Kayser and Leininger (2015) "Vintage Errors"
* Replication material for online appendix in seperate file
* Author contact: Arndt Leininger, a.leininger@phd.hertie-school.org
* Last updated: 3 May 2015

* cd //set your working directory here.

* adjust settings
set more off
set scheme s1mono


********************************************************************************
* Figure 1
********************************************************************************

/*
Figure 1: Revisions in Growth Rate Estimate for 1992 Q2. The figure plots all 
monthly vintages of the quarter-on-quarter growth rate for the second quarter of 
1992 since the release of the first estimate in August 1992
*/

use realGNP_alfred.dta

tsset nob

keep nob year quarter GNPC96_19920827 GNPC96_19920924 GNPC96_19921125 GNPC96_19921222 GNPC96_19930326 GNPC96_19930528 GNPC96_19930623 GNPC96_19930831 GNPC96_19930929 GNPC96_19931201 GNPC96_19931222 GNPC96_19940331 GNPC96_19940527 GNPC96_19940629 GNPC96_19940729 GNPC96_19940826 GNPC96_19940929 GNPC96_19941130 GNPC96_19941222 GNPC96_19950331 GNPC96_19950531 GNPC96_19950630 GNPC96_19950830 GNPC96_19950929 GNPC96_19960119 GNPC96_19960223 GNPC96_19960402 GNPC96_19960530 GNPC96_19960628 GNPC96_19960801 GNPC96_19960829 GNPC96_19960927 GNPC96_19961127 GNPC96_19961220 GNPC96_19970328 GNPC96_19970430 GNPC96_19970507 GNPC96_19970515 GNPC96_19970530 GNPC96_19970627 GNPC96_19970731 GNPC96_19970828 GNPC96_19970926 GNPC96_19971126 GNPC96_19971223 GNPC96_19980326 GNPC96_19980528 GNPC96_19980625 GNPC96_19980731 GNPC96_19980827 GNPC96_19980924 GNPC96_19981124 GNPC96_19981223 GNPC96_19990331 GNPC96_19990527 GNPC96_19990625 GNPC96_19990826 GNPC96_19990930 GNPC96_19991028 GNPC96_19991030 GNPC96_19991124 GNPC96_19991222 GNPC96_20000330 GNPC96_20000403 GNPC96_20000427 GNPC96_20000525 GNPC96_20000629 GNPC96_20000728 GNPC96_20000825 GNPC96_20000928 GNPC96_20001129 GNPC96_20001221 GNPC96_20010329 GNPC96_20010525 GNPC96_20010629 GNPC96_20010727 GNPC96_20010829 GNPC96_20010928 GNPC96_20011130 GNPC96_20011221 GNPC96_20020328 GNPC96_20020524 GNPC96_20020627 GNPC96_20020731 GNPC96_20020829 GNPC96_20020927 GNPC96_20021126 GNPC96_20021220 GNPC96_20030327 GNPC96_20030529 GNPC96_20030626 GNPC96_20030828 GNPC96_20030926 GNPC96_20031125 GNPC96_20031210 GNPC96_20031223 GNPC96_20040123 GNPC96_20040325 GNPC96_20040527 GNPC96_20040625 GNPC96_20040730 GNPC96_20040827 GNPC96_20040929 GNPC96_20041130 GNPC96_20041222 GNPC96_20050330 GNPC96_20050526 GNPC96_20050629 GNPC96_20050729 GNPC96_20050831 GNPC96_20050929 GNPC96_20051130 GNPC96_20051221 GNPC96_20060330 GNPC96_20060525 GNPC96_20060629 GNPC96_20060728 GNPC96_20060830 GNPC96_20060928 GNPC96_20061129 GNPC96_20061221 GNPC96_20070329 GNPC96_20070531 GNPC96_20070628 GNPC96_20070727 GNPC96_20070830 GNPC96_20070927 GNPC96_20071129 GNPC96_20071220 GNPC96_20080327 GNPC96_20080529 GNPC96_20080626 GNPC96_20080731 GNPC96_20080828 GNPC96_20080926 GNPC96_20081125 GNPC96_20081223 GNPC96_20090326 GNPC96_20090529 GNPC96_20090625 GNPC96_20090731 GNPC96_20090817 GNPC96_20090827 GNPC96_20090930 GNPC96_20091124 GNPC96_20091222 GNPC96_20100326 GNPC96_20100527 GNPC96_20100625 GNPC96_20100730 GNPC96_20100827 GNPC96_20100930 GNPC96_20101123 GNPC96_20101222 GNPC96_20110325 GNPC96_20110526 GNPC96_20110624 GNPC96_20110729 GNPC96_20110826 GNPC96_20110929 GNPC96_20111122 GNPC96_20111222 GNPC96_20120329 GNPC96_20120531 GNPC96_20120628 GNPC96_20120727 GNPC96_20120829 GNPC96_20120927 GNPC96_20121129 GNPC96_20121220 GNPC96_20130328 GNPC96_20130530 GNPC96_20130626 GNPC96_20130731 GNPC96_20130829 GNPC96_20130926 GNPC96_20131205 GNPC96_20131220 GNPC96_20140327

foreach vintage of varlist GNPC96_19920827-GNPC96_20140327 {
	gen gr_`vintage' = round(400 * (ln(`vintage')-ln(l.`vintage')),.01) 
}

drop GNPC96_19920827-GNPC96_20140327

keep if year == 1992 & quarter == 2

reshape long gr_GNPC96_, i(nob) j(vintage) string

drop nob year quarter
rename gr_GNPC96_ gr1992Q2

gen year = substr(vintage, 1, 4)
gen month = substr(vintage, 5, 2)
gen day = substr(vintage, 7, 2)

destring year month day, replace

gen date = mdy(month,day,year)

line gr1992Q2 date, lwidth(medium) lcolor(black) ///
	xtitle(Vintage, size(medium)) ///
	ytitle(Quarter on Quarter Growth Rate (%), size(medium)) ///
	xlabel(, labsize(medium) format(%tdCCYY)) ///
	ylabel(,labsize(medium) ) scale(1.1)

clear


********************************************************************************
* Figure 2
********************************************************************************

/*
Figure 2: Four models. Forecasting error (in percentage points) for each model in each
election, 1984-2012. i.e. the difference between out-of-sample forecast and election result,
for out-of-sample forecasts of the 1984 - 2012 elections using August 2012 economic data
vintage.
*/

use "data.dta"

*********************
* Lewis-Beck and Tien
*********************

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

* Plot errors for most recent vintage																	   * 
		
gen eabs_lbt_vp_squared = eabs_lbt_vp^2

quietly sum r2_vp
local r2 = round(r(mean),.01)

quietly sum eabs_lbt_vp_squared
local rmse = round(sqrt(r(mean)),.01)

tw (scatter e_lbt_vp year, msymbol(circle) mcolor(black))  ///
	|| if year >=1984, ///
	yline(0) title("Lewis-Beck and Tien's core model", size(medlarge)) ///
	xtitle("") ytitle("") xlabel(1984(4)2012) ///
	text(5.7 1984 "R� = `r2'", place(e)) text(5.7 2012 "RMSE = `rmse'", place(w)) ///
	legend(off)  scale(1.5) name(fig2lbt)

	
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

* Plot errors for most recent vintage																	   * 
			
gen eabs_a_vp_squared = eabs_a_vp^2

quietly sum r2_vp
local r2 = round(r(mean),.01)

quietly sum eabs_a_vp_squared
local rmse = round(sqrt(r(mean)),.01)

tw (scatter e_a_vp year, msymbol(circle) mcolor(black))  ///
	|| if year >=1984, ///
	yline(0) title("Abramowitz's Time for Change model", size(medlarge)) ///
	xtitle("") ytitle("") xlabel(1984(4)2012) ///
	text(5.7 1984 "R� = `r2'", place(e)) text(5.7 2012 "RMSE = `rmse'", place(w)) ///
	legend(off) scale(1.5) name(fig2a)
	
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
			quietly reg vote earlyseptemberpoll c_rgndpQ2gr`vintage'_agr if id<`loopid'
			replace r2_vp = e(r2) if id==`loopid' & vintage=="v`vintage'"
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

* Plot errors for most recent vintage																	   * 
			
gen eabs_c_vp_squared = eabs_c_vp^2

quietly sum r2_vp
local r2 = string(round(r(mean),.01))

quietly sum eabs_c_vp_squared
local rmse = round(sqrt(r(mean)),.01)

tw (scatter e_c_vp year, msymbol(circle) mcolor(black))  ///
	|| if year >=1984, ///
	yline(0) title("Campbell's Trial-Heat model", size(medlarge)) ///
	xtitle("") ytitle("") xlabel(1984(4)2012) ///
	text(8.1 1984 "R� = `r2'", place(e)) text(8.1 2012 "RMSE = `rmse'", place(w)) ///
	legend(off) scale(1.5) name(fig2c)
	
clear

***************
* End-Heuristic
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
	reg vote  july_popularity wgr2_1_rt if id<`loopid'
	
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

* Plot errors for most recent vintage																	   * 
			

quietly sum r2_vp
local r2 = string(round(r(mean),.1))

quietly sum eabs_kl_vp_squared
local rmse = round(sqrt(r(mean)),.1)

tw (scatter e_kl_vp year, msymbol(circle) mcolor(black))  ///
	|| if year >=1984, ///
	yline(0) title("End-Heuristic model", size(medlarge)) ///
	xtitle("") ytitle("") xlabel(1984(4)2012) ///
	text(6 1984 "R� = `r2'", place(e)) text(6 2012 "RMSE = `rmse'", place(w)) ///
	legend(off) scale(1.5)  name(fig2kl)
		
* Display all four graphs
* graph combine fig2lbt fig2a fig2c fig2kl	

clear


********************************************************************************
* Figure 3
********************************************************************************

/*
Figure 3: Four models. 2012 vintage plotted against real-time growth estimates. The 45 o line
indicates perfect correspondence between vintage and real-time estimates. Points above the
line indicate that newer estimates have revised growth estimates upwards from the original
estimate.
*/

use "data.dta"

* Lewis-Beck and Tien

corr gndp_change_v2012 rt_gndp_change_ext
local r = round(r(rho),.01)
tw (scatter gndp_change_v2012 rt_gndp_change_ext, mlabel(year) mlabsize(vsmall)) ///
	(function y = x, range(-2 5)), ///
	title(Lewis-Beck and Tien's core model, size(medlarge)) legend(off) ///
	text(6 -2 "r=`r'", place(e) size(medsmall)) ///
	xtitle(Real-Time) ytitle(Vintage) scale(1.5) name(fig3lbt)


* Abramowitz

corr rgndpQ2gr12_agr rt_gndpq2agr_ext
local r = round(r(rho),.01)
tw (scatter rgndpQ2gr12_agr rt_gndpq2agr_ext, mlabel(year) mlabsize(vsmall)) ///
	(function y = x, range(-10 10)), ///
	title(Abramowitz's Time for change basic model, size(medlarge)) legend(off) ///
	text(10 -10 "r=`r'", place(e) size(medsmall)) ///
	xtitle(Real-Time) ytitle(Vintage) scale(1.5) name(fig3a)		


* Campbell

* Create Campbell Style vintage growth variable
gen c_rgndpQ2gr12_agr=(rgndpQ2gr12_agr-2.5)*incweight

* Create Campbell Style real-time growth variable
gen c_rt_gndpq2agr_ext=(rt_gndpq2agr_ext-2.5)*incweight

corr c_rgndpQ2gr12_agr c_rt_gndpq2agr_ext
local r = round(r(rho),.01)
tw (scatter c_rgndpQ2gr12_agr c_rt_gndpq2agr_ext, mlabel(year) mlabsize(vsmall)) ///
	(function y = x, range(-10 10)), ///
	title(Campbell's Trial-heat model, size(medlarge)) legend(off) ///
	text(10 -11.5 "r=`r'", place(e) size(medsmall)) ///
	xtitle(Real-Time) ytitle(Vintage) scale(1.5) name(fig3c) 	


* End-heuristic

corr wgr2_1_v2012 wgr2_1_rtext
local r = round(r(rho),.01)
tw (scatter wgr2_1_v2012 wgr2_1_rtext, mlabel(year) mlabsize(vsmall)) ///
	(function y = x, range(-5 10)), ///
	title(End-heuristic model, size(medlarge)) legend(off) ///
	text(10 -5 "r=`r'", place(e) size(medsmall)) ///
	xtitle(Real-Time) ytitle(Vintage) scale(1.5) name(fig3kl) 

* show all four graphs
* graph combine fig3lbt fig3a fig3c fig3kl

clear


********************************************************************************
* Table 1
********************************************************************************

/*
Table 1: OLS model estimates using real-time and 2012 vintage data for each forecasting
model. The percentage differences in the Growth coefficients represent the change from the
2012 vintage data to real-time data. The Growth variable is operationalized differently for
each of the four models, as explained in Section 3 of the manuscript. Standard errors in
parentheses. * p < 0.05, ** p < 0.01, *** p < 0.001
*/

use "data.dta"

* Create Campbell Style vintage growth variable
foreach vintage in 84 88 92 96 00 04 08 12 14 {
	gen c_rgndpQ2gr`vintage'_agr=(rgndpQ2gr`vintage'_agr-2.5)*incweight
}

* Create Campbell Style real-time growth variable
gen c_rt_rgndpq2agr=(rt_rgndpq2agr-2.5)*incweight 
gen c_rt_gndpq2agr_ext=(rt_gndpq2agr_ext-2.5)*incweight

*LBT 
quiet reg vote july_popularity gndp_change_v2012 if year < 2012  // 2012 vintage
estimates store lbt_12
quietly reg vote july_popularity rt_gndp_change_ext if year < 2012 // rt
estimates store lbt_rt

* Abramowitz
quietly reg vote netapp rgndpQ2gr12_agr term1inc if year < 2012
estimates store a_12
quietly reg vote netapp rt_gndpq2agr_ext term1inc if year < 2012
estimates store a_rt

* Campbell
quietly reg vote earlyseptemberpoll c_rgndpQ2gr12_agr if year < 2012
estimates store c_12
quietly reg vote earlyseptemberpoll c_rt_gndpq2agr_ext if year < 2012
estimates store c_rt

* End-heuristic
quietly reg vote  july_popularity wgr2_1_v2012 if year < 2012
estimates store kl_12
reg vote  july_popularity wgr2_1_rtext if year < 2012
estimates store kl_rt


esttab lbt* a* c* kl*, r2 coef(july_popularity "July Popularity" _cons "Constant" ///
	gndp_change_v2012 "Econ. Growth" rt_gndp_change_ext "Econ. Growth" ///
	netapp "NetApproval" term1inc "Term1Incumb." ///
	rgndpQ2gr12_agr "Econ. Growth" rt_gndpq2agr_ext "Econ. Growth" ///
	earlyseptemberpoll "EarlySeptPoll" ///
	c_rgndpQ2gr12_agr "Econ. Growth" c_rt_gndpq2agr_ext "Econ. Growth" ///
	wgr2_1_v2012 "Econ. Growth" wgr2_1_rtext "Econ. Growth") ///
	order(_cons july_popularity netapp term1inc earlyseptemberpoll gndp_change_v2012 ///
	rt_gndp_change_ext rgndpQ2gr12_agr rt_gndpq2agr_ext c_rgndpQ2gr12_agr ///
	rt_gndpq2agr_ext wgr2_1_v2012 wgr2_1_rtext) ///
	mtitles("LBT V" "LBT RT" "A V" "A RT" "C V" "C RT" "EH V" "EH RT")

* Further formatting of table was done manually.

clear


********************************************************************************
* Figure 4
********************************************************************************

/*
Figure 4: Absolute forecasting error across different vintages. The first observation in each
series represents real-time data.
*/

use "data.dta"

*******************
* Lewis-Beck & Tien
*******************

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

* Graph

gen x2015 = 2015

gen fig2pos = eabs_lbt_v2014
replace fig2pos = fig2pos +.08 if year ==1988
replace fig2pos = fig2pos +.04 if year ==1992
replace fig2pos = fig2pos -.08 if year ==2004
replace fig2pos = fig2pos -.09 if year ==2008
replace fig2pos = fig2pos +.09 if year ==2012

twoway 	(connected eabs_lbt_1984 year) (connected eabs_lbt_1988 year) ///
				(connected eabs_lbt_1992 year) (connected eabs_lbt_1996 year) ///
				(connected eabs_lbt_2000 year) (connected eabs_lbt_2004 year) ///
				(connected eabs_lbt_2008 year) (connected eabs_lbt_2012 year) ///
				(scatter fig2pos x2015, msymbol(none) mlabel(year) 				///
				mlabs(vsmall)	mlabpos(0)) || if year>=1984 							///
				|| , title(Lewis-Beck and Tien's core model) xtitle("") 	///
				ytitle("") xlabel(1984(4)2012 2014, angle(30)) legend(off) scale(1.2)								/// 
				plotregion(lwidth(none)) name(fig4lbt)

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

* Graphic

gen x2015 = 2015

gen fig2pos = eabs_a_v14
replace fig2pos = fig2pos + .09 if year == 2008
replace fig2pos = fig2pos - .08 if year == 2000
replace fig2pos = fig2pos + .02 if year == 1996
replace fig2pos = fig2pos - .01 if year == 2004 
replace fig2pos = fig2pos - .06 if year == 2012 

twoway 	(connected eabs_a_84 year) (connected eabs_a_88 year) ///
				(connected eabs_a_92 year) (connected eabs_a_96 year) ///
				(connected eabs_a_00 year) (connected eabs_a_04 year) ///
				(connected eabs_a_08 year) (connected eabs_a_12 year) ///
				(scatter fig2pos x2015, msymbol(none) mlabel(year) 		///
				mlabs(small) mlabpos(3) mlabgap(-2)) || if year>=1984 					///
				||, title(Abramowitz's Time for Change model) xtitle("") 				///
				ytitle("") xlabel(1984(4)2012 2014, angle(30)) legend(off) ///
				plotregion(lwidth(none)) scale(1.3) name(fig4a)

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

* Graphic


gen x2015 = 2015

gen fig2pos = eabs_c_v14
replace fig2pos = fig2pos + .23 if year == 1984
replace fig2pos = fig2pos + .11 if year == 1996
replace fig2pos = fig2pos - .11 if year == 2000
replace fig2pos = fig2pos - .31 if year == 2004

twoway 	(connected eabs_c_84 year) (connected eabs_c_88 year) ///
				(connected eabs_c_92 year) (connected eabs_c_96 year) ///
				(connected eabs_c_00 year) (connected eabs_c_04 year) ///
				(connected eabs_c_08 year) (connected eabs_c_12 year) ///
				(scatter fig2pos x2015, msymbol(none) mlabel(year) 		///
				mlabs(small)	mlabpos(3) mlabgap(-2)) || if year>=1984 					///
				||, title(Campbell's Trial-Heat model) xtitle("") ytitle("") 		///
				xlabel(1984(4)2012 2014, angle(30)) legend(off) plotregion(lwidth(none)) ///
				scale(1.3) name(fig4c)

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

* Graphic

gen x2015 = 2015

gen fig2pos = eabs_kl_v2014
replace fig2pos = fig2pos + .1 if year == 2008
replace fig2pos = fig2pos - .1 if year == 1992
replace fig2pos = fig2pos - .05 if year == 1996
replace fig2pos = fig2pos + .05 if year == 2004
replace fig2pos = fig2pos - .05 if year == 1988

twoway 	(connected eabs_kl_1984 year) (connected eabs_kl_1988 year) ///
				(connected eabs_kl_1992 year) (connected eabs_kl_1996 year) ///
				(connected eabs_kl_2000 year) (connected eabs_kl_2004 year) ///
				(connected eabs_kl_2008 year) (connected eabs_kl_2012 year) ///
				(scatter fig2pos x2015, msymbol(none) mlabel(year) 				///
				mlabs(small)	mlabpos(3) mlabgap(-2)) || if year>=1984 							///
				|| , title("End-Heuristic model") xtitle("") 	///
				ytitle("") xlabel(1984(4)2012 2014, angle(30)) legend(off) 	scale(1.3)					/// 
				plotregion(lwidth(none)) name(fig4kl)

* display all four graphs
* graph combine fig4lbt fig4a fig4c fig4kl

clear

********************************************************************************
* Table 2
********************************************************************************

/*
Table 2: Deviations in absolute forecasting error from election-year forecasting error as func-
tion of data vintage, measured as the number of years since the election. OLS without con-
stant. Standard errors, clustered on election, in parentheses. * p < .05; ** p < .01; *** p < .001
*/

use "data.dta"

*******************
* Lewis-Beck & Tien
*******************

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

* Model

* keep only year and prediction errors
keep year eabs_lbt_v* diff_eabs_lbt_v*

*reshape to long format
reshape long eabs_lbt_v diff_eabs_lbt_v, i(year) j(vintage)

drop if eabs_lbt_v==.

gen lag=vintage-year

sort lag

reg diff_eabs_lbt_v lag if diff_eabs_lbt_v!=0, noconstant cluster(year)
estimates store tab4lbt

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

* Model

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
estimates store tab4a

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

* Model

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
estimates store tab4c

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

* Model

* preserve data because dropping variables and reshaping data
* preserve

* keep only year and prediction errors
keep year eabs_kl_v* diff_eabs_kl_v*

*reshape to long format
reshape long eabs_kl_v diff_eabs_kl_v, i(year) j(vintage)

drop if eabs_kl_v==.

gen lag=vintage-year

sort lag

reg diff_eabs_kl_v lag if diff_eabs_kl_v!=0, noconstant cluster(year)
estimates store tab4kl

******************
* Regression table
******************

esttab tab4*, nonumbers ///
	mtitles("Lewis-Beck \& Tien" "Abramowitz" "Campbell" "End-heuristic") ///
	varlabels(lag "Vintage Number" _cons "Intercept") varwidth(20) se ///
	r2 obslast

clear

********************************************************************************
* Table 3
********************************************************************************

/*
Table 3: Mean Errors across models and vintages.
*/

use "data.dta"

*********************
* Lewis-Beck and Tien
*********************

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

* Model

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

* Errors

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

* Errors

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
		
* Errors

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

************************************
* Final table
************************************

mat list ErrorsLBT
mat list ErrorsA
mat list ErrorsC
mat list ErrorsKL			

* Matrices were then manually assembled into a table.

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

use "data.dta"

*******************
* Lewis-Beck & Tien
*******************

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

* Plot

reg differ_rtext year
estimates store difflbt
di 4 * _b[year]

tw (scatter differ_rtext year, msymbol(circle) mcolor(black)) ///
	(function y=_b[_cons]+_b[year]*x, range(1984 2012) lcolor(black) lwidth(medthick)) ///
								 || if year >=1984, ///
									yline(0) title("Lewis-Beck and Tien's core model", size(medlarge)) ///
									xtitle("") ytitle("") xlabel(1984(4)2012) ///
									legend(off) scale(1.5) name(fig5lbt)


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


* Plot

reg differ_rtext year
estimates store diffla
di 4 * _b[year]

tw (scatter differ_rtext year, msymbol(circle) mcolor(black)) || ///
	(function y=_b[_cons]+_b[year]*x, range(1984 2012) lcolor(black) lpattern(dash) lwidth(medthick)) || if year >=1984, ///
									yline(0) title("Abramowitz's Time for Change model", size(medlarge)) ///
									xtitle("") ytitle("") xlabel(1984(4)2012) ///
									legend(off) scale(1.5)  name(fig5a)
									
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

* Plot

reg differ_rtext year
estimates store difflc
di 4 * _b[year]

tw (scatter differ_rtext year, msymbol(circle) mcolor(black)) ///
	(function y=_b[_cons]+_b[year]*x, range(1984 2012) lcolor(black) lpattern(dash) lwidth(medthick)) ///
									|| if year >=1984, ///
									yline(0) title("Campbell's Trial-Heat model", size(medlarge)) ///
									xtitle("") ytitle("") xlabel(1984(4)2012) scale(1.5) ///
									legend(off) name(fig5c)

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

* Plot

reg differ_rt year
estimates store diffkl
di 4*_b[year]

twoway (scatter differ_rt year, msymbol(circle) mcolor(black)) ///
	(function y=_b[_cons]+_b[year]*x, range(1984 2012) lcolor(black) lwidth(medthick)) ///
								 || if year >=1984, ///
									yline(0) title("End-heuristic model", size(medlarge)) ///
									xtitle("") ytitle("") xlabel(1984(4)2012) ///
									legend(off) scale(1.5) name(fig5kl)
							
* display all four graphs
* graph combine fig5lbt fig5a fig5c fig5kl							

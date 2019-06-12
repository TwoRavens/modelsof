capture log close 
log using transition.log, replace


***************************************************
***  Are coups good for democracy? 		***
***  						***
*** 	author: jgw				***
***		date created: 8.12.15		***
***		last updated: 8.17.15		***
***						***
***   	using files:				***
***		GWFtscs2015.dta			***
***		leader.dta			***
***		powell_thyne_coups_final.txt	***
***						***
***************************************************

*****************************************************************************************
*											*
* \copyright   2015 Joseph Wright \\							*
*											*
* This research is funded by the National Science Foundation BCS-0904463		*
*											*
* This program is free software: you can redistribute it and/or modify			*
*    it under the terms of the GNU General Public License as published by		*
*    the Free Software Foundation, version 3. \\					*
*											*
* This program is distributed in the hope that it will be useful,			*
*   but WITHOUT ANY WARRANTY; without even the implied warranty of			*
*   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the			*
*   GNU General Public License for more details.\\					*
*											*
* See  http://www.gnu.org/licenses/ for a copy of the GNU General Public License. 	*    
* 											*
*****************************************************************************************


*****************************************
*** Create coups and regimes data set ***
*****************************************
	set more off
	cd "C:\Users\jwright\Documents\My Dropbox\Research\Coups\DFGW\Data files\annual data analysis"
	use GWFtscs2015, clear
	sort cow year
	merge cow year using leader  /* this data contains on leader name, duration */
	tab _merge
	rename _merge merge1
	sort cow year
	save temp, replace
	
	* Coups * 
		global cut = 1
		insheet using http://www.uky.edu/~clthyn2/coup_data/powell_thyne_coups_final.txt, clear
		rename ccode cowcode
		rename country pt_country
		* 1st coup in Yemen (ccode=680) 1968 is South Yemen but the second coup in August is actually in N/All-Yemen *
		recode cow (679=678)
		recode cow (680=678) if year==1968 & month==8
		gen  p = "/"
		egen d = concat(day p month p year)
		gen date  = date(d, "DMY")
		gen coupA = coup==1
		gen coupS = coup==2
		drop p d
		sort cow year
		merge cow year using GWFtscs2015
		gen enddate = date(gwf_enddate, "DMY")
		tab _merge 
		* no coups in Oman or East Germany *
		recode coup* (.=0) 
		gen gwf_endmonth = month(enddate)
		gen gwf_endday = day(enddate)

		* drop coups that occur in same calendar year as collapse but in a later month *
		recode coup* (1=0) (2=0) if gwf_endmonth< month & gwf_fail==1 
		* list coups in PT that occur in same month as GWF regime collapse *
		list gwf_case gwf_fail_type year month day coupA coupS gwf_enddate if gwf_fail==1 & coup~=0 & coup~=.& gwf_endmonth==month, noobs clean
		* window around GWF regime collapse event *
		gen hi = gwf_endday + $cut
		gen lo = gwf_endday - $cut
		* drop coups that occur in same calendar year & month but later in the month *
		list gwf_case gwf_fail_type year month day coupA coupS gwf_enddate if gwf_endmonth==month & gwf_fail==1 & day>(gwf_endday + $cut )
		recode coup* (1=0) (2=0) if gwf_endmonth==month & gwf_fail==1 & day>(gwf_endday + $cut)
		* list coup in same month but before regime collapse event *
		list gwf_case gwf_fail_type year month day coupA coupS gwf_enddate if gwf_fail==1 & coup~=0 & coup~=. & gwf_endmonth==month & day<lo, noobs clean
		* flag coups that are the same event as regime collapse
		list gwf_case gwf_fail_type year month day coupA coupS gwf_enddate if gwf_fail==1 & coup~=0 & coup~=.& gwf_endmonth==month & day<=(gwf_endday + $cut ), noobs clean
		gen same_event = (gwf_endmonth==month) & (day>=lo & day<=hi) &  gwf_fail==1 & coup~=0 & coup~=.
		tab same
		* create a set of coup variables that exclude regime collapse coups *
		local c = "coup coupA coupS"
		foreach l of local c {
			gen n`l' = `l'
			replace n`l' = 0 if same==1
		}

		* Monthly *
		egen sumsame = sum(same), by(cow month year)
		tab same sumsame,m  /* these are all the same months */
		drop sumsame
		egen sumcoup = sum(coup), by(cow month year)
		gen anycoup = sumcoup>0 if sumcoup~=.
		egen sumcoupA = sum(coupA), by(cow month year)
		gen anycoupA = sumcoupA>0 if sumcoup~=.
		egen sumcoupS = sum(coupS), by(cow month year)
		gen anycoupS = sumcoupS>0 if sumcoup~=.
		egen nsumcoup = sum(ncoup), by(cow month year)
		gen nanycoup = nsumcoup>0 if nsumcoup~=.
		egen nsumcoupA = sum(ncoupA), by(cow month year)
		gen nanycoupA = nsumcoupA>0 if nsumcoup~=.
		egen nsumcoupS = sum(ncoupS), by(cow month year)
		gen nanycoupS = nsumcoupS>0 if nsumcoup~=.
		egen tag = tag(cow month year)
		keep if tag==1
		keep cow month year sum* any* nsum* nany* pt_country same gwf_enddate
		sort cow year month

		*Yearly*
		local var  = "sumcoup anycoup sumcoupA anycoupA sumcoupS anycoupS nsumcoup nanycoup nsumcoupA nanycoupA nsumcoupS nanycoupS"
		foreach l of local var {
			rename `l' x`l'
		}
		egen sumsame = sum(same), by(cow year)
		tab same sumsame
		recode sumsame (1=0) if same==0   			/* these are years where a coup occurs some month prior to regime collapse */
		egen sumcoup = sum(xsumcoup), by(cow year)
		gen anycoup = sumcoup>0 if sumcoup~=.
		egen sumcoupA = sum(xsumcoupA), by(cow year)
		gen anycoupA = sumcoupA>0 if sumcoup~=.
		egen sumcoupS = sum(xsumcoupS), by(cow year)
		gen anycoupS = sumcoupS>0 if sumcoup~=.
		egen nsumcoup = sum(xnsumcoup), by(cow year)
		gen nanycoup = nsumcoup>0 if nsumcoup~=.
		egen nsumcoupA = sum(xnsumcoupA), by(cow year)
		gen nanycoupA = nsumcoupA>0 if nsumcoup~=.
		egen nsumcoupS = sum(xnsumcoupS), by(cow year)
		gen nanycoupS = nsumcoupS>0 if nsumcoup~=.
		drop same
		rename sumsame same_event
		egen tag = tag(cow year)
		keep if tag==1
		keep cow year sum* any* nsum* nany* pt_country same
		local var  = "sumcoup anycoup sumcoupA anycoupA sumcoupS anycoupS nsumcoup nanycoup nsumcoupA nanycoupA nsumcoupS nanycoupS"
		foreach l of local var {
			rename `l' pt_`l'
		}
		sort cow year

 		merge cow year using temp
		tab _merge 
		rename _merge merge2
		recode pt_sum* pt_any* pt_n* same (.=0) if year>1949

		* Variable construction *
		gen gdem = gwf_fail_subs==1 if gwf_fail_subs~=.
		replace gdem =1 if (cow==365 & year==1991) | (cow==265 & year==1990)
		gen gdict = gwf_fail_subs>1 if gwf_fail_subs~=.
		replace gdict =0 if (cow==365 & year==1991) | (cow==265 & year==1990)
		
		gen period = year<=1955
		replace period=2 if year<=1960 & year>1955
		replace period=3 if year<=1965 & year>1960
		replace period=4 if year<=1970 & year>1965
		replace period=5 if year<=1975 & year>1970
		replace period=6 if year<=1980 & year>1975
		replace period=7 if year<=1985 & year>1980
		replace period=8 if year<=1990 & year>1985
		replace period=9 if year<=1995 & year>1990
		replace period=10 if year<=2000 & year>1995
		replace period=11 if year<=2005 & year>2000
		replace period=12 if year<=2010 & year>2005
		replace period=13 if year>2010

		gen gtime = gwf_duration
		replace gtime = gtime-63 if cow==530 & gtime>90 /*Ethiopia monarchy begin in 1918*/
		replace gtime = gtime-38 if cow==550 & gtime>30 /*SAfrica NP begin in 1948*/
		replace gtime = gtime-177 if cow==698 & gtime>200 /*Oman monarchy begin in 1918*/
		replace gtime = gtime-100 if cow==530 & gtime>99 /*Nepal monarchy begin in 1946*/
		gen gtime2 = gtime^2
		gen gtime3 = gtime^3
		gen ld  = ln(ldr_duration)  /* only from 1950-2010 */
		gen gmfail = gdem
		recode gmfail (0=-1) if gdict==1
		tsset cow year
		recode gwf_fail_type (5=3) if gwf_case=="Argentina 55-58" & year==1958  /* this is an election, not a coup */
	
		* All coup events* 
		tssmooth ma coupMA_ma = pt_anycoup, window(2 1 0)  /* this marks any coup event in current year (prior to regime collapse or at regime collapse) and prior two years */
		gen coupMA = coupMA_ma>0 if coupMA_ma~=.
		tssmooth ma coupMS_ma = pt_anycoupS, window(2 1 0)  /* this marks any successful coup event in current year (prior to regime collapse or at regime collapse) and prior two years */
		gen coupMS = coupMS_ma>0 if coupMS_ma~=.	
		* Coup events excluding regime collapse events *
		tssmooth ma ncoupMA_ma = pt_nanycoup, window(2 1 0)  /* this marks any coup event in current year (prior to regime collapse or at regime collapse) and prior two years */
		gen ncoupMA = ncoupMA_ma>0 if ncoupMA_ma~=.
		tssmooth ma ncoupMS_ma = pt_nanycoupS, window(2 1 0)  /* this marks any successful coup event in current year (prior to regime collapse or at regime collapse) and prior two years */
		gen ncoupMS = ncoupMS_ma>0 if ncoupMS_ma~=.
		recode same (1=0) if ncoupMA==1
		
		* cold war and post-cold war coups *
		drop if year<1950
		local i = "coupMA coupMS ncoupMS ncoupMA"
		foreach t of local i {
			gen pcw`t' = `t'
			replace pcw`t'=0 if year<1990
			gen cw`t' = `t'
			replace cw`t'=0 if year>1989
		}
		tsset cow year
		sort cow year
		save temp2015, replace

******************************************
*** Intro summary statistic: 1950-2015 ***
******************************************
	use temp2015, clear
	list gwf_case year gwf_enddat if gwf_fail_type==5 & pt_anycoupS==0 & gmfail==-1, clean  
	/* DR & CAR are dating issues with PT and not differences in coding */
	/* Panama 1982 & Georgia 1992 reflect differences in coding rules for coups */
	replace pt_anycoupS = 1 if (cow==42 & year==1962) | (cow==482 & year==1965)  /* DR and CAR different dating */

	* tab every code by whether there was regime collapse in the current or subsquent 2 yrs *
	drop if case==.
	tsset caseid year
	tssmooth ma MSgfail = gwf_fail, window(0 1 2)
	tssmooth ma MSgdem = gdem, window(0 1 2)
	tssmooth ma MSgdict = gdict, window(0 1 2)
	local c = "gfail gdem gdict"
	foreach i of local c {
		replace MS`i'=MS`i'>0 if MS`i'~=.
	}
	tab MSgfail MSgdem
	tab MSgfail MSgdict
	tab MSgdem MSgdict
	gen MSgmfail =MSgdem
	replace MSgmfail = -1 if MSgdict==1
	
	* Successul coups *
	tab MSgmfail if pt_anycoupS==1
	tab MSgmfail if pt_anycoupS==1 & year<1990 & gwf_fail~=.
	tab MSgmfail if pt_anycoupS==1 & year>1989 & gwf_fail~=. 
	
	* All coup attempts *
	tab MSgmfail if pt_anycoup==1
	tab MSgmfail if pt_anycoup==1 & year<1990 & gwf_fail~=.
	tab MSgmfail if pt_anycoup==1 & year>1989 & gwf_fail~=. 

*************************
*** Failed coup stats ***
*************************
	* Statistic on coup failures *
	use temp2015, clear
	gen totalattempts = pt_sumcoup - pt_sumcoupS if gwf_duration~=.
	* 1950-2015 *
	tab totalattempts if gwf_duration~=. & totalattempts>0  /* 248 + 2*20 + 3*2 + 4*2 = 288+ 14 = 302 */
	tab pt_sumcoupS if gwf_duration~=. & pt_sumcoupS>0 /* 140 + 2*5 = 150 */
	* 1950-1989 *
	tab totalattempts if gwf_duration~=. & totalattempts>0 & year<1990  /* 202 + 2*18 + 3*2 + 4*1 = 202 + 46 = 248 */
	tab pt_sumcoupS if gwf_duration~=. & pt_sumcoupS>0&  year<1990 /* 120 + 2*5 = 130 */
	* 1990-2015 *
	tab totalattempts if gwf_duration~=. & totalattempts>0 & year>1989  /* 46 + 2*2 + 4*1 = 46 + 8 = 54*/
	tab pt_sumcoupS if gwf_duration~=. & pt_sumcoupS>0&  year>1989 /* 20 */
	
	* Failed coups and regime failure *
	use temp2015, clear
	drop if caseid==.
	tsset caseid year
	tssmooth ma fail2 = pt_anycoupA, window(2 1 0)
	replace fail2 =1 if fail2>0 & fail2~=.
	tab  gmfail if pt_anycoupA==1
	tab  gmfail if fail2==1	

*******************************************************************
**** GWF autocracies and types of regime transition: 1950-2015 ****
*******************************************************************
	*** Regime-case FE specifications ***
 		use temp2015, clear
		* successful coups *
		xi:  reg gwf_fail i.case i.year gtime* ld cwcoupMS pcwcoupMS, cluster(caseid)
		est store fe1
		xi:  reg gdem i.case i.year gtime* ld cwcoupMS pcwcoupMS if gdict==0, cluster(caseid)
		est store fe2
		xi:  reg gdict i.case i.year gtime* ld cwcoupMS pcwcoupMS if gdem==0, cluster(caseid)
		est store fe3
		* any coup attempt *
		xi:  reg gwf_fail i.case i.year gtime* ld cwcoupMA pcwcoupMA, cluster(caseid)
		est store fe4
		xi:  reg gdem i.case i.year gtime* ld cwcoupMA pcwcoupMA  if gdict==0, cluster(caseid)
		est store fe5
		xi:  reg gdict i.case i.year gtime* ld cwcoupMA pcwcoupMA  if gdem==0, cluster(caseid)
		est store fe6		
 
		* FE plot *
 		label var ld "Leader tenure"
		label var cwcoupMA "{bf:Pre-1990 coup}"
		label var pcwcoupMA "{bf:Post-1989 coup}"
		label var cwcoupMS "{bf:Pre-1990 coup}"
		label var pcwcoupMS "{bf:Post-1989 coup}"
		coefplot (fe2, msymbol(+))  (fe3, msymbol(T)), title("Successful coup")   /*
		*/ scheme(lean2) drop(_cons gtime* _Iyear* _Icase*) xlab(-.1 (.1) .4) xline(0, lpattern(dash)) grid(glcolor(gs15)) mfcolor(white) /*
		*/ order(cwcoupMS pcwcoupMS ld) ysize(2) xsize(3.5)  mlabel format(%9.2f) mlabposition(4) mlabgap(*1) /*
		*/ legend(label(3 "Democratization") label(6 "Autocratic transition") pos(6) ring(1.5) col(3))  /*
		*/ levels(95 90) xtitle("  Coefficient estimate", height(6))  saving (t1, replace) 
		coefplot (fe5, msymbol(+))  (fe6, msymbol(T))    , title("Any coup attempt" )   /*
		*/ scheme(lean2) drop(_cons gtime* _Iyear* _Icase*) xlab(-.1 (.1) .4) xline(0, lpattern(dash)) grid(glcolor(gs15)) mfcolor(white) /*
		*/ order(cwcoupMA pcwcoupMA ld) ysize(2) xsize(3.5)  mlabel format(%9.2f) mlabposition(4) mlabgap(*1) /*
		*/ legend(label(3 "Democratization") label(6 "Autocratic transition")  pos(6) ring(1.5) col(3))  /*
		*/ levels(95 90) xtitle("  Coefficient estimate", height(6))  saving (t2, replace) 
		graph combine t1.gph t2.gph,  xsize(8) ysize(4) graphregion(color(white)) scheme(lean2)
		graph export "C:\Users\jwright\Documents\My Dropbox\Research\Coups\DFGW\Manuscript files\golden\transition-fe.pdf", as(pdf) replace

****************************
*** Reported in Appendix ***
****************************

	*** Simple selction models ***
		use temp2015, clear
		drop if case==.
		tsset caseid year
		tssmooth ma MSgfail = gwf_fail, window(0 1 2)
		tssmooth ma MSgdem = gdem, window(0 1 2)
		tssmooth ma MSgdict = gdict, window(0 1 2)
		local c = "gfail gdem gdict"
		foreach i of local c {
			replace MS`i'=MS`i'>0 if MS`i'~=.
		}
		tab MSgfail MSgdem
		tab MSgfail MSgdict
		tab MSgdem MSgdict
		gen MSgmfail =MSgdem
		replace MSgmfail = -1 if MSgdict==1
		
		label define labmfail -1 "Autocratic transition" 0 "No change" 1 "Democratization"
		label values MSgmfail labmfail
		label values gmfail labmfail
		gen n =1

		* Success *
		tab MSgmfail if pt_anycoupS==1 & year<1990 & gwf_fail~=.
		tab MSgmfail if pt_anycoupS==1 & year>1989 & gwf_fail~=.
		egen maxcw = total(n) if pt_anycoupS==1 & gmfail~=. & gwf_fail~=. & year<1990, by(MSgmfail)
		egen maxpcw = total(n) if pt_anycoupS==1 & gmfail~=. & gwf_fail~=. & year>1989, by(MSgmfail)
		graph bar (mean) maxcw, over(MSgmfail) blabel(total, pos(outside) size(medlarge)) ytitle("Frequency") /*
		*/ scheme(lean2) ylab(0 (20) 80,glcolor(gs15)) saving(t1, replace) title(1950-1989)
		graph bar (mean) maxpcw, over(MSgmfail) blabel(total, pos(outside) size(medlarge)) ytitle("") /*
		*/ scheme(lean2) ylab(0 (20) 80,glcolor(gs15)) saving(t2, replace) title(1990-2015)
		graph combine t1.gph t2.gph, xsize(8) col(2)  graphregion(color(white)) 
		graph export "C:\Users\jwright\Documents\My Dropbox\Research\Coups\DFGW\Manuscript files\golden\selection-tab-success.pdf", as(pdf) replace
		drop max*
		
		* Attempt *
		tab MSgmfail if pt_anycoup==1 & year<1990 & gwf_fail~=.
		tab MSgmfail if pt_anycoup==1 & year>1989 & gwf_fail~=.
		egen maxcw = total(n) if pt_anycoup==1 & gmfail~=. & gwf_fail~=. & year<1990, by(MSgmfail)
		egen maxpcw = total(n) if pt_anycoup==1 & gmfail~=. & gwf_fail~=. & year>1989, by(MSgmfail)
		graph bar (mean) maxcw, over(MSgmfail) blabel(total, pos(inside) size(medlarge)) ytitle("Frequency") /*
		*/ scheme(lean2) ylab(0 (30) 120,glcolor(gs15)) saving(t1, replace) title(1950-1989)
		graph bar (mean) maxpcw, over(MSgmfail) blabel(total, pos(inside) size(medlarge)) ytitle("") /*
		*/ scheme(lean2) ylab(0 (30) 120,glcolor(gs15)) saving(t2, replace) title(1990-2015)
		graph combine t1.gph t2.gph, xsize(8) col(2)  graphregion(color(white))  
		graph export "C:\Users\jwright\Documents\My Dropbox\Research\Coups\DFGW\Manuscript files\golden\selection-tab-attempt.pdf", as(pdf) replace
	
	* By time period instead of interactions *
		use temp2015, clear
		xi: qui: reg gdem i.case i.year gtime* ld  coupMS if year<1990 & gdict==0, cluster(caseid)
		lincom coupMS
		xi: qui: reg gdem i.case i.year gtime* ld  coupMS if year>1989 & gdict==0, cluster(caseid)
		lincom coupMS
		xi: qui: reg gdem i.case gtime* ld  coupMS if year>1989 & gdict==0, cluster(caseid)
		lincom coupMS
		xi: qui: reg gdict i.case i.year gtime* ld  coupMS if year<1990 & gdem==0, cluster(caseid)
		lincom coupMS
		xi: qui: reg gdict i.case i.year gtime* ld  coupMS if year>1989 & gdem==0, cluster(caseid)
		lincom coupMS
		xi: qui: reg gdict i.case gtime* ld  coupMS if year>1989 & gdem==0, cluster(caseid)
		lincom coupMS
		
	* Unclustered errors makes no difference in coefficent estimates but lowers the se estimates *
		use temp2015, clear
		qui:xi:reg gdem i.case i.year gtime* ld cwcoupMS pcwcoupMS if gdict==0, cluster(caseid)
		lincom cwcoupMS 
		lincom pcwcoupMS
		qui:xi:reg gdem i.case i.year gtime* ld cwcoupMS pcwcoupMS if gdict==0 
		lincom cwcoupMS 
		lincom pcwcoupMS
		qui:xi:reg gdict i.case i.year gtime* ld cwcoupMS pcwcoupMS if gdem==0, cluster(caseid)
		lincom cwcoupMS 
		lincom pcwcoupMS
		qui:xi:reg gdict i.case i.year gtime* ld cwcoupMS pcwcoupMS if gdem==0 
		lincom cwcoupMS 
		lincom pcwcoupMS
	
	* Number of regimes, countries that don't collapse during sample period *
		use temp2015, clear
		qui:xi:  reg gwf_fail i.case i.year gtime* ld cwcoupMS pcwcoupMS, cluster(caseid)
		egen casetag=tag(caseid) if e(sample)==1
		egen max_dem= max(gdem) if e(sample)==1, by(caseid)
		egen max_dict= max(gdict) if e(sample)==1, by(caseid)
		tab max_dem if casetag==1  /* 61% don't have democratic transition */
		tab max_dict if casetag==1 /* 58% don't have autocratic transition */

	* Non-linear FE tests, condition on case- and year- means *
		use temp2015, clear
		drop if caseid ==.
		tsset cow year
		local c = "ld gtime gtime2 gtime3 cwcoupMS pcwcoupMS"
		qui:reg gdem `c' `g'  if gdict==0
		gen s = e(sample)
		foreach i of local c {
			egen m_`i' = mean(`i') if s==1, by(caseid)
 			egen ym_`i' = mean(`i') if s==1, by(period)
		}
 		logit gdem ym_* m_* `c' if gdict==0, cluster(caseid)
		est store nl1
		use temp2015, clear
		drop if caseid ==.
		tsset cow year
		local c = "ld gtime gtime2 gtime3 cwcoupMS pcwcoupMS"
		qui:reg gdict `c' `g'  if gdem==0
		gen s = e(sample)
		foreach i of local c {
			egen m_`i' = mean(`i') if s==1, by(caseid)
 			egen ym_`i' = mean(`i') if s==1, by(period)
		}		
 		logit gdict  ym_* m_* `c' if gdem==0, cluster(caseid)
		est store nl2
		use temp2015, clear
		drop if caseid ==.
		tsset cow year
		local c = "ld gtime gtime2 gtime3 cwcoupMA pcwcoupMA"
		qui:reg gdem `c' `g'  if gdict==0
		gen s = e(sample)
		foreach i of local c {
			egen m_`i' = mean(`i') if s==1, by(caseid)
 			egen ym_`i' = mean(`i') if s==1, by(period)
		}
 		logit gdem ym_* m_* `c' if gdict==0, cluster(caseid)
		est store nl3
		use temp2015, clear
		drop if caseid ==.
		tsset cow year
		local c = "ld gtime gtime2 gtime3 cwcoupMA pcwcoupMA"
		qui:reg gdict `c' `g'  if gdem==0
		gen s = e(sample)
		foreach i of local c {
			egen m_`i' = mean(`i') if s==1, by(caseid)
 			egen ym_`i' = mean(`i') if s==1, by(period)
		}		
 		logit gdict  ym_* m_* `c' if gdem==0, cluster(caseid)
		est store nl4
		
	* non-linear with regime-case fe and cold war dummy *
		use temp2015, clear
		gen pcw = year>1989
		xi:  xtlogit gwf_fail pcw ld pcwcoupMS cwcoupMS, fe i(caseid)  /* post-cold war estimate is not correct here */
		xi:  xtlogit gdem  pcw ld pcwcoupMS cwcoupMS if gdict==0, fe i(caseid)
		xi:  xtlogit gdict pcw ld pcwcoupMS cwcoupMS if gdem==0, fe i(caseid)

	* Use country FE *
		use temp2015, clear
		* successful coups *
		xi:  reg gdem i.cow i.year gtime* ld cwcoupMS pcwcoupMS if gdict==0, cluster(caseid)
		est store cfe1
		xi:  reg gdict i.cow i.year gtime* ld cwcoupMS pcwcoupMS if gdem==0, cluster(caseid)
		est store cfe2
		* any coup attempt *
		xi:  reg gdem i.cow i.year gtime* ld cwcoupMA pcwcoupMA  if gdict==0, cluster(caseid)
		est store cfe3
		xi:  reg gdict i.cow i.year gtime* ld cwcoupMA pcwcoupMA  if gdem==0, cluster(caseid)
		est store cfe4		
 
		* FE plot *
 		label var ld "Leader tenure"
		label var cwcoupMA "{bf:Pre-1990 coup}"
		label var pcwcoupMA "{bf:Post-1989 coup}"
		label var cwcoupMS "{bf:Pre-1990 coup}"
		label var pcwcoupMS "{bf:Post-1989 coup}"
		label var gwf_mil "Military regime"
		coefplot (cfe1, msymbol(+))  (cfe2, msymbol(T)), title("Successful coup")   /*
		*/ scheme(lean2) drop(_cons gtime* _Iyear* _Ic* _Ig*) xlab(-.1 (.1) .4) xline(0, lpattern(dash)) grid(glcolor(gs15)) mfcolor(white) /*
		*/ order(cwcoupMS pcwcoupMS ld) ysize(2) xsize(3.5)  mlabel format(%9.2f) mlabposition(4) mlabgap(*1) /*
		*/ legend(label(3 "Democratization") label(6 "Autocratic transition") pos(6) ring(1.5) col(3))  /*
		*/ levels(95 90) xtitle("  Coefficient estimate", height(6))  saving (t1, replace) 
		coefplot (cfe3, msymbol(+))  (cfe4, msymbol(T)), title("Any coup attempt" )   /*
		*/ scheme(lean2) drop(_cons gtime* _Iyear* _Ic* _Ig*) xlab(-.1 (.1) .4) xline(0, lpattern(dash)) grid(glcolor(gs15)) mfcolor(white) /*
		*/ order(cwcoupMA pcwcoupMA ld) ysize(2) xsize(3.5)  mlabel format(%9.2f) mlabposition(4) mlabgap(*1) /*
		*/ legend(label(3 "Democratization") label(6 "Autocratic transition")  pos(6) ring(1.5) col(3))  /*
		*/ levels(95 90) xtitle("  Coefficient estimate", height(6))  saving (t2, replace) 
		graph combine t1.gph t2.gph,  xsize(8) ysize(4) graphregion(color(white)) scheme(lean2)
		graph export "C:\Users\jwright\Documents\My Dropbox\Research\Coups\DFGW\Manuscript files\golden\transition-country-fe.pdf", as(pdf) replace
		
	* Statistic on post-Cold War regimes within countries *
		use temp2015, clear
		qui: reg gdem i.cow i.year gtime* ld gwf_mil cwcoupMS pcwcoupMS, cluster(caseid)
		egen casetag =tag(caseid) if e(sample)==1
		egen ccount = sum(casetag) if e(sample)==1, by(cow)
		egen cowtag  = tag(cow) if ccount~=.
		tab ccount if cowtag==1

	* Show that autocratic transition is more likely than dem. after a successful coup, excluding regime collapse events that are coups *
		* treat coups (explanatory variable) as noncoups but keep associated regime collapse events *
		use temp2015, clear
		drop if caseid==.		 
		gen pcw = year>1989
		gen pcwXcoup = pcw*ncoupMS
		local c = "ld cwncoupMS pcwncoupMS"     /* using *ncoup* instead of *coup* */
		qui:reg gdem `c' if gdict==0
		gen s = e(sample)
		sum year if e(sample)
		foreach i of local c {
			egen m_`i' = mean(`i') if s==1, by(caseid)
			egen y_`i' = mean(`i') if s==1, by(period)
		}
		tsset caseid year
 		logit gdem gtime* m_* y_* `c' if gdict==0, cluster(caseid)
 		est store gl1
		use temp2015, clear
		drop if caseid==.		 
		gen pcw = year>1989
		gen pcwXcoup = pcw*ncoupMS
		local c = "ld cwncoupMS pcwncoupMS"     /* using *ncoup* instead of *coup* */
		qui:reg gdict `c' if gdem==0
		gen s = e(sample)
		sum year if e(sample)
		foreach i of local c {
			egen m_`i' = mean(`i') if s==1, by(caseid)
			egen y_`i' = mean(`i') if s==1, by(period)
		}
		tsset caseid year
  		logit gdict gtime* m_* y_* `c' if gdem==0, cluster(caseid)
  		est store gl2
		xi: qui: reg gdem i.caseid i.year gtime* ld cwncoupMS pcwncoupMS if gdict==0, cluster(caseid)
		lincom cwncoupMS
		lincom pcwncoupMS
		xi: qui: reg gdict i.caseid i.year gtime* ld cwncoupMS pcwncoupMS if gdem==0, cluster(caseid)
 		lincom cwncoupMS
		lincom pcwncoupMS
		
		* RE model with unit- and time-means and clustered errors *
		gllamm gdict m_* y_* `c' if gdem==0, fam(bin) link(logit) i(caseid) cluster(caseid)
		
		* treat coups (explanatory variable) as noncoups AND drop associated regime collapse events *
		use temp2015, clear
		drop if caseid==.		 
		gen pcw = year>1989
		gen pcwXcoup = pcw*ncoupMS
		local c = "ld cwncoupMS pcwncoupMS"    		/* using *ncoup* instead of *coup* */
		qui: reg gdem `c' if same==0 & gdict==0		/* dropping same event regime collapses */
		gen s = e(sample)
		sum year if e(sample)
		foreach i of local c {
			egen m_`i' = mean(`i') if s==1, by(caseid)
			egen y_`i' = mean(`i') if s==1, by(year)
		}
		tsset caseid year
 		logit gdem m_* y_* gtime* `c' if gdict==0, cluster(caseid)
		est store gl3
		use temp2015, clear
		drop if caseid==.		 
		gen pcw = year>1989
		gen pcwXcoup = pcw*ncoupMS
		local c = "ld cwncoupMS pcwncoupMS"    		/* using *ncoup* instead of *coup* */
		qui: reg gdict `c' if same==0 & gdem==0		/* dropping same event regime collapses */
		gen s = e(sample)
		sum year if e(sample)
		foreach i of local c {
			egen m_`i' = mean(`i') if s==1, by(caseid)
			egen y_`i' = mean(`i') if s==1, by(year)
		}
		tsset caseid year
  		logit gdict m_* y_* gtime* `c' if gdem==0, cluster(caseid)
		est store gl4
		
		* treat coups (explanatory variable) as noncoups AND drop regimes (ie all regime-year) associated w. coup regime collapse events *
		use temp2015, clear
		drop if caseid==.	
		egen maxsame = max(same), by(caseid)
		gen pcw = year>1989
		gen pcwXcoup = pcw*ncoupMS
		local c = "ld cwncoupMS pcwncoupMS"    			/* using *ncoup* instead of *coup* */
		qui:reg gdem `c' if maxsame==0 	& gdict==0		/* dropping regimes with coup regime collapses */
		gen s = e(sample)
		sum year if e(sample)
		foreach i of local c {
			egen m_`i' = mean(`i') if s==1, by(caseid)
			egen y_`i' = mean(`i') if s==1, by(year)
		}
		tsset caseid year
 		logit gdem gtime* m_* y_* `c' if gdict==0, cluster(caseid)
		est store gl5
		use temp2015, clear
		drop if caseid==.	
		egen maxsame = max(same), by(caseid)
		gen pcw = year>1989
		gen pcwXcoup = pcw*ncoupMS
		local c = "ld cwncoupMS pcwncoupMS"    			/* using *ncoup* instead of *coup* */
		qui:reg gdict `c' if maxsame==0 & gdem==0		/* dropping regimes with coup regime collapses */
		gen s = e(sample)
		sum year if e(sample)
		foreach i of local c {
			egen m_`i' = mean(`i') if s==1, by(caseid)
			egen y_`i' = mean(`i') if s==1, by(year)
		}
		tsset caseid year
  		logit gdict gtime* m_* y_*  `c' if gdem==0, cluster(caseid)
		est store gl6
		
***************************
*** Tables for appendix ***
***************************
 estout fe1 fe2 fe3 fe4 fe5 fe6 using A1.tex, cells(b(star  fmt(%9.3f)) se(par fmt(%9.2f))) stats(ll r2 N) style(tex) replace label starlevels(+ 0.10 * 0.05 ** 0.01)
 estout nl1 nl3 nl2 nl4 using A2.tex, cells(b(star  fmt(%9.3f)) se(par fmt(%9.2f))) stats(ll r2 N) style(tex) replace label starlevels(+ 0.10 * 0.05 ** 0.01)
 estout gl1 gl2 gl3 gl4 gl5 gl6 using A3.tex, cells(b(star  fmt(%9.3f)) se(par fmt(%9.2f))) stats(ll r2 N) style(tex) replace label starlevels(+ 0.10 * 0.05 ** 0.01)

 

********************** The end ***************************
 
log close

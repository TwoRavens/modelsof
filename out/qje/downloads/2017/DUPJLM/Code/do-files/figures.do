*this file contains the description of figures which we use in the paper

**************************************************
**************************************************
*figures using the main database
**************************************************
**************************************************

run hazard_by_group.do

set more off
use "oursample.dta",clear
keep if uibase>uibase70

*we use only age groups betwen 25-49
keep if age>=25  & age<50


*generating indicators for missing variables
for any qeduc linc2002 linc2003 occlastjob1dig  : cap drop X_mis
for any qeduc linc2002 linc2003 occlastjob1dig  : gen X_mis= X==.
for any qeduc linc2002 linc2003 occlastjob1dig  : recode X .=0

* Creating some useful dummy variable
tab beguispell_month, gen(beguispell_month)
tab beguispell_day, gen(beguispell_day)
tab qeduc, gen(qeduc)
tab occlastjob1dig, gen(occlastjob1dig)
gen county=int(loc/100)
tab county, gen(county)


*define control variables 
global X qeduc2 qeduc3 age age2 length_nobenef linc2002 linc2003 sex ///
		beguispell_day2-beguispell_day31 occlastjob1dig2-occlastjob1dig10 ///
		qeduc_mis linc2002_mis linc2003_mis occlastjob1dig_mis county2-county20


**************************************************
*main results
**************************************************


	preserve
		keep if after~=.
		*figure 3a
		hazard_by_group d15durnoemp, byvar(after)  weekly xline(97.5 277.5 367.5, lp(dash))  scale(15)
		graph export haztotnocont.png, replace	
		graph export haztotnocont.ps, replace	orientation(landscape) pagesize(letter) tmargin(.5) lmargin(.5) logo(off)
		*figure 3b
		hazard_by_group d15durnoemp, byvar(after)  weekly xline(97.5 277.5 367.5 , lp(dash) )  scale(15) survivor(1)
		graph export survtotnocont.png, replace	
		graph export survtotnocont.ps, replace	orientation(landscape) pagesize(letter) tmargin(.5) lmargin(.5) logo(off)

		*figure 4a
		hazard_by_group d15durnoemp, byvar(after)  weekly xline(97.5 277.5 367.5 , lp(dash))  scale(15) controls($X)
		graph export haztotcont.png, replace 	
		graph export haztotcont.ps, replace orientation(landscape) pagesize(letter) tmargin(.5) lmargin(.5) logo(off)
		*figure 4b
		keep if reempbon1tier==0&train==0 
		hazard_by_group d15durnoemp , byvar(after)  weekly xline(97.5 277.5 367.5 , lp(dash))  scale(15) controls($X)
		graph export hazrescont.png, replace 
		graph export hazrescont.ps, replace orientation(landscape) pagesize(letter) tmargin(.5) lmargin(.5) logo(off)
		

	restore
	
*********************************************************
*generate the figures for interrupted time series analyzis	
*********************************************************
* Create the key hazard variables
gen hazard210_270=0 if durnoemp>=210
	replace hazard210_270=1 if durnoemp<270&durnoemp>=210 
gen hazard270_330=0 if durnoemp>=270
	replace hazard270_330=1 if durnoemp<330&durnoemp>=270 
gen hazard30_90=0 if durnoemp>=30
	replace hazard30_90=1 if durnoemp<90&durnoemp>=30 
gen hazard90_150=0 if durnoemp>=90
	replace hazard90_150=1 if durnoemp<150&durnoemp>=90 
	
	*** No control, all sample, level
preserve
	display(qofd(td(1Nov2005)))
	gen qofbeguispell=qofd(beguispell+61)

	gen event=.
	for any b se: gen X210_270=.
	for any b se: gen X270_330=.

	for any b se: gen X30_90=.
	for any b se: gen X90_150=.


	keep if qofbeguispell>=178 & qofbeguispell<=190
	gen qofd=month(beguispell)

	foreach i of varlist hazard210_270 hazard270_330 hazard30_90 hazard90_150{
		gen after`i'=beguispell>td(01nov2005)

		reg `i' i.qofd  after`i'
		replace after`i'=0
		predict xb`i'
		su xb`i'
		replace `i'=`i'-xb`i'+r(mean)
	}

	local qtr=178
	quietly while `qtr'<=190 {
		replace event=`qtr' in `qtr'

		foreach i in 30_90 90_150 210_270 270_330 {
			reg hazard`i' if qofbeguispell==`qtr'
			replace b`i'=_b[_cons] in `qtr'
			replace se`i'=_se[_cons] in `qtr'
		}
		local qtr=`qtr'+1
	}

	foreach i in 30_90 90_150 210_270 270_330 {
		gen plusb`i'=b`i'+1.96*se`i'
		gen minusb`i'=b`i'-1.96*se`i'
	}

	replace event=event-183
label def numbers -6 "-7" -5 "-6" -4 "-5" -3 "-4" -2 "-3" -1 "-2" 0 "-1" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "6" 7 "7"
 label values event numbers
*figure 5a
 twoway connected b270_330 event, lcolor(black)mcolor(black) || ///
	       connected plusb270_330 event, lpattern("..")lcolor(black)mcolor(black)msize(tiny) || ///
	       connected minusb270_330 event, lpattern("..")lcolor(black)mcolor(black)msize(tiny) || ///
	       connected b210_270 event, lcolor(red)mcolor(red) lpattern(dash)msymbol(S) || ///
	       connected plusb210_270 event, lpattern("..")lcolor(red)mcolor(red)msize(tiny) || ///
	       connected minusb210_270 event, lpattern("..")lcolor(red)mcolor(red)msize(tiny) ///
		xline(0.5, lp("..")) xlab(-5(1)0 1(1)7,labgap(*5) valuelabel)  ///
		 legend(order(4 1) label(1 "hazard at 270-330 days") label(4 "hazard at 210-270 days") ///
		 region(lcolor(white)) ) ///
		 ytitle("Seasonally adjusted hazard rate") xtitle("Quarter") scheme(sj)  graphregion(color(white)) ///
		 bgcolor(white)  ysize(7.5) xsize(10)
	cd
	graph export transfer/eventlevel_totnocont270.png, replace 
	graph export transfer/eventlevel_totnocont270.ps, replace orientation(landscape) pagesize(letter) tmargin(.5) lmargin(.5) logo(off)

*figure 5b
	twoway connected b90_150 event, lcolor(black)mcolor(black) || ///
	       connected plusb90_150 event, lpattern("..")lcolor(black)mcolor(black)msize(tiny) || ///
	       connected minusb90_150 event, lpattern("..")lcolor(black)mcolor(black)msize(tiny) || ///
	       connected b30_90 event, lcolor(red) lpattern(dash) mcolor(red)msymbol(S) || ///
	       connected plusb30_90 event, lpattern("..")lcolor(red)mcolor(red)msize(tiny) || ///
	       connected minusb30_90 event, lpattern("..")lcolor(red)mcolor(red)msize(tiny) ///
		xline(0.5, lp("..")) xlab(-5(1)0 1(1)7,labgap(*5) valuelabel)  ///
		legend(order(1 4) label(1 "hazard at 90-150 days") label(4 "hazard at 30-90 days")  region(lcolor(white))) ///
		 ytitle("Seasonally adjusted hazard rate") xtitle("Quarter") scheme(sj)  graphregion(color(white)) bgcolor(white) ///
		 ysize(7.5) xsize(10) 
	cd
	graph export transfer/eventlevel_totnocont90.png, replace 
	graph export transfer/eventlevel_totnocont90.ps, replace orientation(landscape) pagesize(letter) tmargin(.5) lmargin(.5) logo(off)

restore


 
****************************************
*selection on observables (figure 10)
****************************************


gen durnoemp2=durnoemp
replace durnoemp2=540 if durnoemp>540

cap drop diff
for any diff bef_s aft_s: gen X=0  
local boots=1
tempvar temp
gen `temp'=_n
egen dur =group(`temp') if after!=. & uibase>uibase70 & age>=25 & age<50
quietly while `boots'<=2000 {
	preserve
	keep if after!=.
	keep if uibase>uibase70
	keep if age>=25 & age<50
	bsample , strata(after)
	quietly reg durnoemp2 $X if after==0
	cap drop edur
	predict edur
	foreach i of numlist 1/36 {
 	   su edur if after==0 & d15>=`i'
	   scalar bef_s`i'=r(mean)
	   su edur if after==1 & d15>=`i'
	   scalar aft_s`i'=r(mean)
	}
	restore
	foreach i of numlist 1/36{
	    replace diff=diff+1 if bef_s`i'>aft_s`i' & dur== `i'
	}
	local boots=`boots'+1
}	
preserve
	keep if after!=.
	keep if uibase>uibase70
	keep if age>=25 & age<50
	quietly reg durnoemp2 $X if after==0
	cap drop edur
	predict edur
	quietly foreach i of numlist 1/36 {
		   su edur if after==0 & d15>=`i'
		   
		   replace bef_s=r(mean) if dur== `i'
		   su edur if after==1 & d15>=`i'
		   replace aft_s=r(mean) if dur== `i'
		}
	replace dur = . if dur>36
	replace dur = dur * 15
	keep if dur<.
	twoway  (connected bef_s dur , color(blue) msymbol(S)) (connected aft_s dur , color(red) lpattern(dash) ) ///
		(rcap aft_s bef_s dur if  diff<101 & aft_s>=bef_s, lcolor(red) lwi(*1.9)) ///
		(rcap aft_s bef_s dur if   diff>1900 & aft_s<=bef_s, lcolor(green) lwi(*1.9) lpa(dash)) , ///
		xline(97.5 277.5 367.5,  lwidth(*.6) ) ylabel(285(10)315) ///
		ytitle("expected nonemployment duration") xtitle("number of days elapsed since UI claim") ///
		legend(label( 1 before) label(2 after) order(1 2) ) graphr(color(white))  scale(.8) ysize(7) xsize(10)
	graph export selection_exp_nonemp.ps, replace orientation(landscape) pagesize(letter) tmargin(.5) lmargin(.5) logo(off)

restore


*************************************
*figure A-6
*************************************

gen duruiua=end_ui_ua-beguispell
replace  duruiua=durnoemp  if duruiua> durnoem
cap drop d15duruiua
gen d15duruiua=int((duruiua+2)/15)

hazard_by_group d15duruiua, byvar(after)  weekly xline(97.5 277.5 367.5, lp(dash))  ///
	scale(15) ylabel(0(0.05)0.3) 

		graph export hazduruiua.png, replace 
		graph export hazduruiua.ps, replace orientation(landscape) pagesize(letter) tmargin(.5) lmargin(.5) logo(off)


*************************************
*figure A-7
*************************************
	*** Placebo Checks

	*figure A-7 panel a

	preserve 
		gen before=0 if  beguispell>=td(15jan2004) & beguispell<td(15oct2004)
		replace before=1 if beguispell>=td(15jan2005) & beguispell<td(15oct2005)
		label define before 1 "1 year before" 0 "2 years before"
		label values before before
		keep if before~=.
		cd
		hazard_by_group d15durnoemp, byvar(before)  weekly xline(97.5 277.5 367.5)  scale(15) 
		graph export haztotnocont_placebo.png, replace 	
		graph export haztotnocont_placebo.ps, replace orientation(landscape) pagesize(letter) tmargin(.5) lmargin(.5) logo(off)	
		keep if age<45
		hazard_by_group d15durnoemp, byvar(before)  weekly xline(97.5 277.5 367.5)  scale(15) 

	restore

	*figure A-7 panel b

	preserve 
		gen afterplacebo=0 if  beguispell>=td(15jan2006) & beguispell<td(15oct2006)
		replace afterplacebo=1 if beguispell>=td(15jan2007) & beguispell<td(15oct2007)
		label define afterplacebo 1 "2 years after" 0 "1 year after"
		label values afterplacebo afterplacebo
		keep if afterplacebo~=.
		hazard_by_group d15durnoemp, byvar(afterplacebo)  weekly xline(97.5 277.5 367.5)  scale(15) maxdur(27)
		graph export haztotnocont_afterplacebo.png, replace 
		graph export haztotnocont_afterplacebo.ps, replace orientation(landscape) pagesize(letter) tmargin(.5) lmargin(.5) logo(off)	
	restore


************************************************
************************************************
*recall-figures using the alternative sample
************************************************
************************************************
use recall.dta
keep if uibase70<meanincome
cap drop before
gen before=1-after

for any reemp_haz* recal_prob*: cap drop X
gen reemp_haz_before=.
gen reemp_haz_before_norecall=.

gen recal_prob_before=.
gen reemp_haz_after=.
gen reemp_haz_after_norecall=.

gen recal_prob_after=.

quietly  foreach i of numlist 0/36 {
    foreach j of varlist before after {
	tempvar temp
	gen `temp'=`i'==m_durnoemp2 if m_durnoemp2>=`i' & `j'==1
	su `temp'
	local ii=`i'+1
	replace reemp_haz_`j'=r(mean) in `ii'
	tempvar temp
	gen `temp'=`i'==m_durnoemp2 & recall==0 if m_durnoemp2>=`i' & `j'==1 
	su `temp'
	local ii=`i'+1
	replace reemp_haz_`j'_norecall=r(mean) in `ii'

	su recall if `i'==m_durnoemp2 & `j'==1
	replace recal_prob_`j'=r(mean) in `ii'
	
    }
}
cap drop tstat tstat_norecall
gen tstat=.
gen tstat_norecall=.

quietly foreach i of numlist 0/36 {
	local ii=`i'+1
	tempvar temp
	gen `temp'=`i'==m_durnoemp2 if m_durnoemp2>=`i' 
	ta `temp' after if m_durnoemp2>=`i' , mis
	reg `temp' after  if m_durnoemp2>=`i'
	replace tstat=_b[after]/_se[after] in `ii'
 	reg `temp' after  if m_durnoemp2>=`i' & recall==0
	replace tstat_norecall=_b[after]/_se[after] in `ii'


}

*************************************
*figure A-4a
*************************************

cap drop time
gen time= (_n-1)*30+15 if _n<21
twoway (connected reemp_haz_before time if time>16, color(blue) msymbol(S) ) ///
	(connected reemp_haz_after  time if time>16,color(red) lpattern(dash)  )  ///
	(rcap reemp_haz_after  reemp_haz_before time if tstat>1.96 & reemp_haz_before<reemp_haz_after,lwi(*1.9)) ///
	(rcap reemp_haz_after  reemp_haz_before time if tstat<-1.96 & reemp_haz_before-reemp_haz_after ///
	,lcolor(red) lwi(*1.9) lpa(dash) ) ,  xline(90 270 360) title("") ///
	legend(label(1 before) label(2 after) order(1 2)) title(reemployment hazards) ///
	  xtitle(Number of days since UI claim) xlabel(0(200)600) ylabel(0(0.03)0.15) graphregion(color(white)) 
graph export "reemphazard.ps", replace

*************************************
*figure A-4b
*************************************

twoway (connected reemp_haz_before_norecall time if time>16, color(blue) msymbol(S) ) ///
	(connected reemp_haz_after_norecall  time if time>16 ,color(red) lpattern(dash)  )  ///
	(rcap reemp_haz_after_norecall  reemp_haz_before_norecall time if tstat>1.96 & reemp_haz_before_norecall<reemp_haz_after_norecall,lwi(*1.9)) ///
	(rcap reemp_haz_after_norecall  reemp_haz_before_norecall time if tstat<-1.96 & reemp_haz_before_norecall-reemp_haz_after_norecall ///
	,lcolor(red) lwi(*1.9) lpa(dash) ) ,  xline(90 270 360) title("") ///
	legend(label(1 before) label(2 after) order(1 2)) title(reemployment hazards) ///
	  xtitle(Number of days since UI claim) xlabel(0(200)600) ylabel(0(0.03)0.15) graphregion(color(white)) 
graph export "reemphazard_norecall.ps", replace



*************************************
*figure A-5
*************************************

for any reemp_haz* recal_prob*: cap drop X
gen reemp_haz_before_recall=.
gen reemp_haz_before_norecall=.

gen reemp_haz_after_recall=.
gen reemp_haz_after_norecall=.

 foreach i of numlist 0/36 {
    foreach j of varlist before after {
	tempvar temp
	gen `temp'=`i'==m_durnoemp2 & recall==1 if m_durnoemp2>=`i' & `j'==1 
	su `temp'
	local ii=`i'+1
	replace reemp_haz_`j'_recall=r(mean) in `ii'
	tempvar temp
	gen `temp'=`i'==m_durnoemp2 &  recall==0 if m_durnoemp2>=`i' & `j'==1 
	su `temp'
	replace reemp_haz_`j'_norecall=r(mean) in `ii'
	
    }
}

cap drop time
gen time= (_n-1)*30+15 if _n<21
twoway (connected reemp_haz_before_recall time if time>16, color(blue) msymbol(S) ) ///
	(connected reemp_haz_before_norecall  time if time>16,color(blue) lpattern(dash) msymbol(S) )  ///
	(connected reemp_haz_after_recall time if time>16, color(red) msymbol(T) ) ///
	(connected reemp_haz_after_norecall  time if time>16,color(red) lpattern(dash) msymbol(T)    ///
	,  xline(90 270 360) title("") ///
	legend(label(1 "before - recall") label(2 "before - new job") label(3 "after - recall") ///
	label(4 "after - new job") ) title(reemployment hazards) ///
	  xtitle(Number of days since UI claim) xlabel(0(200)600) ylabel(0(0.03)0.12) graphregion(color(white)) )
graph export "reemphazard_both_v1.ps", replace
















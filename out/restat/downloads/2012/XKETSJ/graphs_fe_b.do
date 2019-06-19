
*GRAPHS OF CHARTER OUTCOMES & YEARS BEFORE & AFTER START, BY GRADE
*DEMEANED TO REMOVE INDIVIDUAL FIXED EFFECT AND ADJUSTED FOR GRADE-YEAR EFFECTS, FREE-LUNCH STATUS, IMMIGRATION, MIGRANT


clear
set mem 6G
set more off


use /work/s/simberman/lusd/charter1/lusd_data_b.dta, clear

*DROP STUDENTS WHO ATTENDED G&T CHARTER
drop if ever_magnet_chart == 1

*GENERATE NON-STRUCTURAL SWITCHES EXCLUDING CHARTER SCHOOL SWITCHES
gen nonstruc_nochart = nonstructural
replace nonstruc_nochart = 0 if charter == 1 | l.charter == 1

*IDENTIFY YEAR STUDENTS ENTER & LEAVE A CHARTER OR HAVE NONSTRUCTURAL SWITCH FOR FIRST TIME - LIMIT TO STUDENTS WHO ARE IN lusd IN YEAR PRIOR TO ENTRY
  xtset (id) year
  foreach type in "charter" "convert_zoned" "startup_unzoned" "nonstruc_nochart" {
    gen `type'_enter = `type' == 1 & l.`type' == 0  
    gen `type'_exit = `type' == 0 & l.`type' == 1

    gen temp = year if `type'_enter == 1
    egen `type'_enteryear = min(temp), by(id)
    drop temp

    gen temp = year if `type'_exit == 1
    egen `type'_exityear = min(temp), by(id)
    drop temp
  }
 


*IDENTIFY TIME TO ENTRY INTO CHARTER
foreach type in "charter" "convert_zoned" "startup_unzoned" "nonstruc_nochart"{
  gen `type'_timetoentry = year - `type'_enteryear
  gen `type'_timetoexit = year - `type'_exityear

}

save /work/s/simberman/lusd/charter1/graph_temp.dta, replace

keep if year >= 1998
keep if stanford_math_sd != . & stanford_read_sd != . & stanford_lang_sd != .
tab year, gen(year_)

drop *_11 *_12

foreach var of varlist stanford_math_sd stanford_read_sd stanford_lang_sd {
  xtreg `var' freelunch redlunch othecon recent_immig migrant grade_* year_* gradeyear_* structural* nonstructural* outofdist* , cluster(schoolid) fe nonest
  predict `var'_resid, e
}

postfile graphs_fe str40(graphtype var charttype) int(sincechart) str40(statname) float(stat N) using /work/s/simberman/lusd/postfiles/graphs_fe.dta, replace

*GENERATE CONFIDENCE INTERVALS ON MEANS
foreach type in "charter" "convert_zoned" "startup_unzoned" "nonstruc_nochart"{
  foreach var of varlist stanford_math_sd_resid stanford_read_sd_resid stanford_lang_sd_resid {
      forvalues sincechart =  -5/5 {
      	qui ci `var' if `type'_timetoentry == `sincechart'
	post graphs_fe ("entry") ("`var'") ("`type'") (`sincechart') ("mean") (r(mean)) (r(N))
	post graphs_fe ("entry") ("`var'") ("`type'") (`sincechart') ("ub") (r(ub)) (r(N))
	post graphs_fe ("entry") ("`var'") ("`type'") (`sincechart') ("lb") (r(lb)) (r(N))

      	qui ci `var' if `type'_timetoexit == `sincechart'
	post graphs_fe ("exit") ("`var'") ("`type'") (`sincechart') ("mean") (r(mean)) (r(N))
	post graphs_fe ("exit") ("`var'") ("`type'") (`sincechart') ("ub") (r(ub)) (r(N))
	post graphs_fe ("exit") ("`var'") ("`type'") (`sincechart') ("lb") (r(lb)) (r(N))
     }
  }
}



*BASE

use /work/s/simberman/lusd/charter1/graph_temp.dta, clear
sort id year
drop *_12

tab year, gen(year_)

foreach var of varlist infrac  perc_attn{
  xtreg `var' freelunch redlunch othecon recent_immig migrant grade_* year_* gradeyear_* structural* nonstructural* outofdist* , cluster(schoolid) fe nonest
  predict `var'_resid, e
}



*GENERATE CONFIDENCE INTERVALS ON MEANS
foreach type in "charter" "convert_zoned" "startup_unzoned" "nonstruc_nochart"{
  foreach var of varlist infractions_resid perc_attn_resid{
      forvalues sincechart =  -5/5 {
      	ci `var' if `type'_timetoentry == `sincechart'
	post graphs_fe ("entry") ("`var'") ("`type'") (`sincechart') ("mean") (r(mean)) (r(N))
	post graphs_fe ("entry") ("`var'") ("`type'") (`sincechart') ("ub") (r(ub)) (r(N))
	post graphs_fe ("entry") ("`var'") ("`type'") (`sincechart') ("lb") (r(lb)) (r(N))

      	ci `var' if `type'_timetoexit == `sincechart'
	post graphs_fe ("exit") ("`var'") ("`type'") (`sincechart') ("mean") (r(mean)) (r(N))
	post graphs_fe ("exit") ("`var'") ("`type'") (`sincechart') ("ub") (r(ub)) (r(N))
	post graphs_fe ("exit") ("`var'") ("`type'") (`sincechart') ("lb") (r(lb)) (r(N))
     }
  }
}

	
 postclose graphs_fe
*/



*TESTGRAPH

use /work/s/simberman/lusd/postfiles/graphs_fe.dta, clear
drop if var == "infractions_resid"
drop if var == "perc_attn_resid"

replace var = "Math" if var == "stanford_math_sd_resid"
replace var = "Reading" if var == "stanford_read_sd_resid"
replace var = "Language" if var == "stanford_lang_sd_resid"

replace charttype = "Conversion" if charttype == "convert_zoned"
replace charttype = "Startup" if charttype == "startup_unzoned"
drop if charttype != "Conversion" & charttype != "Startup"
gen charttypenum = 1 if charttype == "Startup"
replace charttypenum = 2 if charttype == "Conversion"
label define charts 1 "Startup" 2 "Conversion"
label values charttypenum charts

replace graphtype = "Charter Entry" if graphtype == "entry"
replace graphtype = "Charter Exit" if graphtype == "exit"


gen testtype = .
replace testtype = 1 if var == "Math"
replace testtype = 2 if var == "Reading"
replace testtype = 3 if var == "Language"

label define tests 1 "Math" 2 "Reading" 3 "Language"
label values testtype tests

sort testtype charttype sincechart

# delimit ;

*ENTRY;

twoway   
  (connected stat sincechart if  statname == "mean", 
	     lcolor(black) lpattern(solid) msymbol(circle) mcolor(black)) 
  (connected stat sincechart if  statname == "lb", 
	     lcolor(black) lpattern(dot) msymbol(none) mcolor(black)) 
  (connected stat sincechart if  statname == "ub", 
	     lcolor(black) lpattern(dot) msymbol(none) mcolor(black)) 
    if graphtype == "Charter Entry",
    by(charttypenum testtype, cols(3) title("Figure 4: Test Scores Before and After Charter Entry", size(medium)) legend(off)
    note ("Graph shows residuals from a regression of test scores on observables included in the baseline" 
	  "model excluding charter status.  All variables are demeaned within students to remove the"
	  "individual fixed effect."))
    ytitle(Standard Deviations from Grade-Year Mean, size(medsmall) margin(medium)) 
    xtitle(Years Before and After, size(medsmall) margin(medium))
    yscale(range(-.2 .2))
    ylabel(-.2(.1).2)
    xscale(range(-5 5))
    xlabel(-5(1)5)
    xline(-1, lwidth(medium) lcolor(black) lpattern(tight_dot) extend) 
    saving(/work/s/simberman/lusd/charter1/graphs/chart_test_entry_fe.gph, replace)

;

*EXIT;
twoway   
  (connected stat sincechart if  statname == "mean", 
	     lcolor(black) lpattern(solid) msymbol(circle) mcolor(black)) 
  (connected stat sincechart if  statname == "lb", 
	     lcolor(black) lpattern(dot) msymbol(none) mcolor(black)) 
  (connected stat sincechart if  statname == "ub", 
	     lcolor(black) lpattern(dot) msymbol(none) mcolor(black)) 
    if graphtype == "Charter Exit",
    by(charttypenum testtype, cols(3) title("Figure 6: Test Scores Before and After Charter Exit", size(medium)) legend(off)
    note ("Graph shows residuals from a regression of test scores on observables included in the baseline" 
	  "model excluding charter status.  All variables are demeaned within students to remove the"
	  "individual fixed effect."))
    ytitle(Standard Deviations from Grade-Year Mean, size(medsmall) margin(medium)) 
    xtitle(Years Before and After, size(medsmall) margin(medium))
    yscale(range(-.2 .2))
    ylabel(-.2(.1).2)
    xscale(range(-5 5))
    xlabel(-5(1)5)
    xline(-1, lwidth(medium) lcolor(black) lpattern(tight_dot) extend) 
    saving(/work/s/simberman/lusd/charter1/graphs/chart_test_exit_fe.gph, replace)

;

   
# delimit cr

*INFRAC & ATTEND

use /work/s/simberman/lusd/postfiles/graphs_fe.dta, clear
drop if var == "stanford_math_sd_resid"
drop if var == "stanford_read_sd_resid"
drop if var == "stanford_lang_sd_resid"


replace var = "Disciplinary Infractions" if var == "infractions_resid"
replace var = "Attendance Rate" if var == "perc_attn_resid"


replace charttype = "Conversion" if charttype == "convert_zoned"
replace charttype = "Startup" if charttype == "startup_unzoned"
drop if charttype != "Conversion" & charttype != "Startup"
gen charttypenum = 1 if charttype == "Startup"
replace charttypenum = 2 if charttype == "Conversion"
label define charts 1 "Startup" 2 "Conversion"
label values charttypenum charts


replace graphtype = "Charter Entry" if graphtype == "entry"
replace graphtype = "Charter Exit" if graphtype == "exit"


gen testtype = .
replace testtype = 1 if var == "Disciplinary Infractions"
replace testtype = 2 if var == "Attendance Rate"

label define tests 1 "Disciplinary Infractions" 2 "Attendance Rate"
label values testtype tests

sort testtype charttype sincechart

# delimit ;

*ENTRY;

twoway   
  (connected stat sincechart if  statname == "mean", 
	     lcolor(black) lpattern(solid) msymbol(circle) mcolor(black)) 
  (connected stat sincechart if  statname == "lb", 
	     lcolor(black) lpattern(dot) msymbol(none) mcolor(black)) 
  (connected stat sincechart if  statname == "ub", 
	     lcolor(black) lpattern(dot) msymbol(none) mcolor(black)) 
    if graphtype == "Charter Entry",
    by(charttypenum testtype, cols(2) title("Figure 5: Discipline & Attendance by Before and After Charter Entry", 
	  size(medium)) note("") legend(off)  
	  note ("Graph shows residuals from a regression of test scores on observables included in the baseline" 
	  "model excluding charter status.  All variables are demeaned within students to remove the"
	  "individual fixed effect."))
    ytitle(Disciplinary Infractions & Attendance Rate, size(medsmall) margin(medium)) 
    xtitle(Years Before and After , size(medsmall) margin(medium))
    yscale(range(-2 2))
    ylabel(-2(1)2)
    xscale(range(-5 5))
    xlabel(-5(1)5)
    xline(-1, lwidth(medium) lcolor(black) lpattern(tight_dot) extend) 
    saving(/work/s/simberman/lusd/charter1/graphs/chart_base_entry_fe.gph, replace)
;


*EXIT;

twoway   
  (connected stat sincechart if  statname == "mean", 
	     lcolor(black) lpattern(solid) msymbol(circle) mcolor(black)) 
  (connected stat sincechart if  statname == "lb", 
	     lcolor(black) lpattern(dot) msymbol(none) mcolor(black)) 
  (connected stat sincechart if  statname == "ub", 
	     lcolor(black) lpattern(dot) msymbol(none) mcolor(black)) 
    if graphtype == "Charter Exit",
    by(charttypenum testtype, cols(2) title("Figure 7: Discipline & Attendance by Before and After Charter Exit", 
	  size(medium)) note("") legend(off)  
	  note ("Graph shows residuals from a regression of test scores on observables included in the baseline" 
	  "model excluding charter status.  All variables are demeaned within students to remove the"
	  "individual fixed effect."))
    ytitle(Disciplinary Infractions & Attendance Rate, size(medsmall) margin(medium)) 
    xtitle(Years Before and After , size(medsmall) margin(medium))
    yscale(range(-2 2))
    ylabel(-2(1)2)
    xscale(range(-5 5))
    xlabel(-5(1)5)
    xline(-1, lwidth(medium) lcolor(black) lpattern(tight_dot) extend) 
    saving(/work/s/simberman/lusd/charter1/graphs/chart_base_exit_fe.gph, replace)
;

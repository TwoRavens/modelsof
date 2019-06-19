clear
set more 1
set mem 20m
set matsize 800

clear
use ${DTA}\LAData_finance
cap gen one=1

capture log close
log using ${logs}\LAchangeregs, replace text

*Enrollment variables
* Table 2
local enrolllist="lnenrwh lnenrwh_all fracprivwh lnenroll"
*local enrolllist2="lnenrwh112 lnenrwh112_all fracprivwh112 lnenroll112"

*lagged birth variables
local birthvars="lnbirthwh lnbirthbl lnbirthto birthperwh"

*av vars
* Table 3
local avlist "lnav lnppav lnav_real lnav_nr"

*pprevvars
* Table 4
local pprevlist1="pprevtot pprevloc" 
local pprevlist2="pprevnl pprevst_psf pprevfed_esea pprevnl_oth" 

*teacher vars
* Table 5
*local teachlist="strat stratbl stratwh fracblteach teachall_expavg teachall_edavg"
local teachlist="ppexpcurr pptransport tsrat tsratgapwhavg stratgapwhavg"

foreach var in `pprevlist1' `pprevlist2' `enrolllist' `birthvars' `avlist' `teachlist' {

	gen x=`var' if year==1965
	gen y=`var' if year==1970
	egen x1=mean(x), by(fipscnty)
	egen y1=mean(y), by(fipscnty)
	gen ch`var'1=y1-x1
	drop x x1 y y1

	gen x=`var' if year==1963|year==1964|year==1965
	gen y=`var' if year==1970|year==1971|year==1972
	egen x1=mean(x), by(fipscnty)
	egen y1=mean(y), by(fipscnty)
	gen ch`var'2=y1-x1
	drop x x1 y y1

	gen x=`var' if year==1964
	gen y=`var' if year==1961
	egen x1=mean(x), by(fipscnty)
	egen y1=mean(y), by(fipscnty)
	gen ch`var'pre1=y1-x1
	drop x x1 y y1

	gen x=`var' if year==1964
	gen y=`var' if year==1960
	egen x1=max(x), by(fipscnty)
	egen y1=max(y), by(fipscnty)
	gen ch`var'pre2=y1-x1
	drop x x1 y y1

	}

*Main results

*control specifciations
*Control sets
global census "percapinc6 perplumb6 perinclt30006 lnpop6 perurban6"
*starting Expenditure
global fincont "initexp"

local year=1961


*Main specifications for all variables*******************************************
qui reg one fracbl fracti $census $fincont if year==1961
est store spec0
foreach var in `enrolllist' `avlist' `pprevlist1' `pprevlist2' `teachlist' {
	local spec=1
	display "`year'"
	reg ch`var'1 fracbl if year==`year'
	est store _`spec'`var'
	local spec=`spec'+1

	reg ch`var'1 fracbl fracti1966 if year==`year'
	est store _`spec'`var'
	local spec=`spec'+1

	reg ch`var'1 fracbl fracti1966 $census $fincont if year==`year'
	est store _`spec'`var'
	*local spec=`spec'+1

	est restore spec0	
	outreg2 [spec0] using $OUTREG/all`var', replace excel
		forval i=1/`spec' {
			cap outreg2 [_`i'`var'] using $OUTREG/all`var', append excel
			}	
	*erase $OUTREG/all`var'.txt
	}

**Additional enrollment regressions
*with lagged births and pre-trend change
local spec=`spec'+1
display "with lagged births"
reg chlnenrwh1 fracbl fracti1966 $census $fincont chlnbirthwh1 if year==`year'
est store _`spec'lnenrwh
		
reg chlnenrwh_all1 fracbl fracti1966 $census $fincont chlnbirthwh1 if year==`year'
est store _`spec'lnenrwh_all1

reg chlnenroll1 fracbl fracti1966 $census $fincont chlnbirthto1 if year==`year'
est store _`spec'lnenroll

foreach var in lnenrwh lnenrwh_all lnenroll {
	outreg2 [_`spec'`var'] using $OUTREG/all`var', append excel
	}



clear
set more 1
set mem 20m
set matsize 800

clear
use ${DTA}\LAData_finance
cap gen one=1

capture log close
log using Y:\deseg1\logs\LAregs_pre, replace text

egen x=mean(fracbl), by(year)
replace fracbl=fracbl-x
drop x

*Placebo list
local placebo "lnenrwh lnenrwh_all fracprivwh lnenroll lnav lnppav lnav_real lnav_nr pprevtot pprevloc pprevst_psf pprevnl_oth ppexpcurr tsrat pptransport"

foreach var in `placebo' {

	gen x=`var' if year==1960
	gen y=`var' if year==1964
	egen x1=mean(x), by(fipscnty)
	egen y1=mean(y), by(fipscnty)
	gen ch`var'1=y1-x1
	drop x x1 y y1

	}

*Main results

*control specifciations
*Control sets
global census "percapinc6 perplumb6 perinclt30006 lnpop6 perurban6"
*starting Expenditure
global fincont "ppexpcurr"

local year=1960

*Main specifications for all variables*******************************************
qui reg one fracbl fracti $census $fincont if year==`year'
est store spec0
foreach var in `placebo' {
	cap reg ch`var'1 fracbl fracti1966 $census $fincont if year==`year'
	*cap reg ch`var'1 fracbl $census $fincont if year==`year'
	*cap reg ch`var'1 fracbl if year==`year'
	cap est store _`var'
	}

est restore spec0	
outreg2 [spec0] using $OUTREG/pre_table, replace excel
foreach var in `placebo' {
	cap outreg2 [_`var'] using $OUTREG/pre_table, append excel
			}	
	erase ${OUTREG}/pre_table.txt
	

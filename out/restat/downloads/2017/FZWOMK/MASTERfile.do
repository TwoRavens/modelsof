clear
version 14.2
set more off

capture: log close
clear
log using MASTERfile, replace

*global data ="[your path]"

*ssc install ttesttable
*ssc install spmap

*-----------------------------------------------------------
*Prepare datasets 
*-----------------------------------------------------------
do "$data\Prepare.do"

*-----------------------------------------------------------
*Descriptive (Figures 1, 2, 3 and Table 1)
*-----------------------------------------------------------
do "$data\Summstats.do"

*------------------------------------------------------
*Baseline estimations (Tables 2, 3, 5)
*------------------------------------------------------
do "$data\Baseline.do"

*-----------------------------------------------------------
*Robustness and validation (Tables 6, 7 ,8) 
*-----------------------------------------------------------
do "$data\Robustness.do"

*----------------------------------------------------------------
*Online appendix (Figure A.1, Tables A.1-A.2, B.1-B.4)
*----------------------------------------------------------------
do "$data\Onlineappendix.do"

*----------------------------------------------------------------
* Mayor selection (Table 4, Table A.3)
*----------------------------------------------------------------
*do "$data\Mayorselection.do"

log close

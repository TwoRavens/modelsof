*******************************************************
* Table A1: Summary Statistics on Industry-Year Cells *
*******************************************************
global x "$masterpath/datafiles/"
global z "$masterpath/outfiles/appendix/"

capture log close
clear
set mem 1300m
log using ${z}appendixtableA1.log, replace
!gunzip ${x}merge_educ_man7090.dta.gz
use ${x}merge_educ_man7090.dta, clear
gen lemp=ln(emp_cps)
*replace lowincemp=1 if lowincemp==0
gen llowincemp=log(lowincemp)
gen lhigh=log(highincemp)
gen lpiinv100=ln(piinv79*100)
gen lrpiship79=log(rpiship79)
keep if year>=1983

sum lemp llowincemp lhigh lpiinv100 tfp579 expmod79 penmod79 lrpiship79 educ
log close
!gzip ${x}merge_educ_man7090.dta
exit

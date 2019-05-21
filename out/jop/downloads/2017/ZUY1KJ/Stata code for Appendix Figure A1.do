***** 
*** Reassessing Public Support for a Female President
*** Stata code for Appendix replication Figure A1
*** Prepared by Yoshikuni Ono
*** Date 2017/2/27
*****

** Summary statistics for creating Figure A1: Percentage of Respondents Selecting a Number of Items

* Change file pathname is needed
use "PATHNAME/JoP_Stata_data.dta"

gen all_c = q27_c if q27_c > -1
gen all_t = q27_t if q27_t > -1

tab all_c
tab all_t

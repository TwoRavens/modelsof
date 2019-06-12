
* All code run in Stata/SE 15.1 for Windows (64-bit x86-64)

* Set your working directory.
* cd ""

* Open "table A4.dta" and then run this.
use "table A4.dta", clear


* ********* SUPPLEMENT
* Table A4
ivpoisson gmm stcdc const_length_ln const_age_ln (new_adopted_ln = complexity totalsize leg_limit ), multiplicative
ivpoisson gmm stcdc const_length_ln const_age_ln (new_adopted_ln = complexity totalsize leg_limit ) judges_partisan totalcases ideo_distance sessionlength_total, multiplicative

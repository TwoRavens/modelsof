*2005-07 

save "../../CAMS/CAMS0507_indiv_forFE.dta"

*select 2005 variables
keep HHID PN GENDER trans05 z05 JWGTR

*reshaping data
rename trans05 trans
rename z05 z
rename JWGTR waveweight

generate time=2005

save "../../CAMS/CAMS0507_05_indiv_FE.dta"
 
use "../../CAMS/CAMS0507_indiv_forFE.dta"

*select 2007 variables
keep HHID PN GENDER trans07 z07 JWGTR

*reshaping data
rename trans07 trans
rename z07 z
rename JWGTR waveweight

generate time=2007

save "../../CAMS/CAMS0507_07_indiv_FE.dta"


*2007-09

use use "../../CAMS/CAMS0709_indiv_forFE.dta"

*select 2007 variables
keep HHID PN GENDER trans07 z07 KWGTR

*reshaping data
rename trans07 trans
rename z07 z
rename KWGTR waveweight

generate time=2007

save "../../CAMS/CAMS0709_07_indiv_FE.dta"

use "../../CAMS/CAMS0709_indiv_forFE.dta"

*select 2009 variables
keep HHID PN GENDER trans09 z09 KWGTR

*reshaping data
rename trans09 trans
rename z09 z
rename KWGTR waveweight

generate time=2009

save "../../CAMS/CAMS0709_09_indiv_FE.dta"


*2009-11

use "../../CAMS/CAMS0911_indiv_forFE.dta"

*select 2009 variables
keep HHID PN GENDER trans09 z09 LWGTR

*reshaping data
rename trans09 trans
rename z09 z
rename LWGTR waveweight

generate time=2009

save "../../CAMS/CAMS0911_09_indiv_FE.dta"

use "../../CAMS/CAMS0911_indiv_forFE.dta"

*select 2011 variables
keep HHID PN GENDER trans11 z11 LWGTR

*reshaping data
rename trans11 trans
rename z11 z
rename LWGTR waveweight

generate time=2011

save "../../CAMS/CAMS0911_11_indiv_FE.dta"


*2011-13

use "../../CAMS/CAMS1113_indiv_forFE.dta"

*select 2011 variables
keep HHID PN GENDER trans11 z11 MWGTR

*reshaping data
rename trans11 trans
rename z11 z
rename MWGTR waveweight

generate time=2011

save "../../CAMS/CAMS1113_11_indiv_FE.dta"

use "../../CAMS/CAMS1113_indiv_forFE.dta"

*select 2013 variables
keep HHID PN GENDER trans13 z13 MWGTR

*reshaping data
rename trans13 trans
rename z13 z
rename MWGTR waveweight

generate time=2013

save "../../CAMS/CAMS1113_13_indiv_FE.dta"


*merge all files

use "../../CAMS/CAMS0507_05_indiv_FE.dta"

append using "../../CAMS/CAMS0507_07_indiv_FE.dta"

append using "../../CAMS/CAMS0709_07_indiv_FE.dta"

append using "../../CAMS/CAMS0709_09_indiv_FE.dta"

append using "../../CAMS/CAMS0911_09_indiv_FE.dta"

append using "../../CAMS/CAMS0911_11_indiv_FE.dta"

append using "../../CAMS/CAMS1113_11_indiv_FE.dta"

append using "../../CAMS/CAMS1113_13_indiv_FE.dta"

save "../../CAMS/CAMS_indiv_FE.dta"

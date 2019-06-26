***Table 1 replication***

set mem 100m

use "F:\Data\PeaceScience2012\groupduration.dta", clear

xtset ccode

xtlogit fail2 ln_mil milXrival rivalryt_1 ln_gdpt_1 ln_pop democt_1 milregimet_1 sponsored ter rc sq coldwar post911 numgroups t t2 t3, fe

xtlogit fail2 ln_econ econXrival rivalryt_1 ln_gdpt_1 ln_pop democt_1 milregimet_1 sponsored ter rc sq coldwar post911 numgroups t t2 t3, fe

xtlogit fail2 ln_def defXrival rivalryt_1 ln_gdpt_1 ln_pop democ milregime sponsored ter rc sq coldwar post911 numgroups t t2 t3 if year >1993, fe

xtlogit fail2 ln_totalt_1 totXrival rivalryt_1 ln_gdpt_1 ln_pop democ milregime sponsored ter rc sq coldwar post911 numgroups t t2 t3, fe

xtlogit fail2 ln_milpct_1 milpcXrival rivalryt_1 ln_gdpt_1 ln_pop democ milregime sponsored ter rc sq coldwar post911 numgroups t t2 t3, fe

xtlogit fail2 ln_econpct_1 econpcXrival rivalryt_1 ln_gdpt_1 ln_pop democ milregime sponsored ter rc sq coldwar post911 numgroups t t2 t3, fe

xtlogit fail2 ln_totalpct_1 totpcXrival rivalryt_1 ln_gdpt_1 ln_pop democ milregime sponsored ter rc sq coldwar post911 numgroups t t2 t3, fe

***Figure 2***

twoway histogram ln_milpct_1, color(*.5) || kdensity ln_milpct_1

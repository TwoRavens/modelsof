clear
clear matrix
set more off
set mem 5000m 
set matsize 500 
capture log close




set more off

use /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/cohorts_87_92_tempcost1.dta, clear


*** eligible versus non-eligible

gen byear=year(fodtaar)
tab byear

keep if byear>=1987 & byear<=1993


gen mageb_25_40=1 if mageb>=25 & mageb<=40
replace mageb_25_40=0 if mageb<25 | mageb>40







***background variables

gen citz_mor=1 if mstatborg==0
replace citz_mor=0 if mstatborgb!=0 & mstatborgb!=.

gen citz_far=1 if fstatborgb==0
replace citz_far=0 if fstatborgb!=0 & fstatborg!=.

foreach c in mor far {
gen string_nus2000_`c'=string(`c'_nus2000_birth)
gen nivaa=substr(string_nus2000_`c', 1,1)
destring nivaa, gen(nivaa_n)
drop nivaa
rename nivaa_n nivaa
gen `c'_coll=1 if nivaa>=6 & nivaa<9
replace `c'_coll=0 if nivaa<6 & nivaa>0

gen `c'_HSC=1 if nivaa>=4 & nivaa<=5
replace `c'_HSC=0 if nivaa<4 & nivaa>0 | nivaa>5 & nivaa<9

gen `c'_dropout=1 if nivaa<=3 & nivaa>0
replace `c'_dropout=0 if nivaa>3 & nivaa<9


drop nivaa 
drop string_nus2000_`c'

}



keep if mageb_25_40==1

replace disp_faminc2010=disp_faminc2010/6

bysort eligible: sum mageb citz_mor mor_dropout mor_HSC mor_coll fageb citz_far far_dropout far_HSC far_coll marcfyb disp_faminc2010




*no kids sample:



*drop if dead

use doeds_dato foedselsdato tilland_dato tilland lnr statsborgerskap using "/ssb/ovibos/h1/kvs/wk24/alle_lnr_g2010m12d31.dta", clear
gen edod=date(doeds_dato,"YMD")
gen efodtaar=date(foedselsdato," YMD")


gen etilland_dato=date(tilland_dato, "YMD")
gen tilland_year=year(etilland_dato)
gen year_dod=year(edod)
gen b_year=year(efodtaar)


destring, replace
gen year_sinc_arrival=2010-tilland_year
tab year_sinc_arrival
gen citz=1 if statsborgerskap==0
replace citz=0 if statsborgerskap!=0 & statsborgerskap!=.

gen dod=0
replace dod=1 if year_dod!=.
tab dod

keep lnr citz year_sinc_arrival dod

save  /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/dod.dta,replace






****


set more off
use lnr fodtaar kjonn antbarn using "/ssb/ovibos/h1/kvs/wk24/slektsfil_g1967g2006.dta", clear

gen efodtaar=date(fodtaar,"YMD")
format efodtaar %td
drop fodtaar
rename efodtaar fodtaar

destring, replace force
duplicates drop
drop if lnr==.
drop if lnr==0

gen b_year=year(fodtaar)
gen age_2010=2010-b_year
tab age_2010



keep if age_2010>=42 & age_2010<=63

*drop if dod

sort lnr

merge 1:1 lnr using /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/dod.dta
drop if _merge==2

tab dod
drop if dod==1
drop dod

drop _merge


keep lnr antbarn  b_year age_2010 kjonn citz year_sinc_arrival
duplicates drop
sort lnr
save /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/nokids_sample.dta, replace

*****add on info for 2007, 2008, 2009, 2010:
forvalues t=2007/2009 {
use lnr mor_lnr far_lnr fodselsaar using "/ssb/ovibos/h1/kvs/wk24/alle_lnr_g`t'm12d31.dta", clear
destring, replace force
duplicates drop
drop if lnr==.
drop if lnr==0
drop if mor_lnr==0
drop if far_lnr==0


keep if fodselsaar==`t'
gen barn`t'=1

drop lnr

preserve
keep mor_lnr  barn`t'

duplicates drop

rename mor_lnr lnr

sort lnr

merge 1:1 lnr using /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/nokids_sample.dta

drop if _merge==1

drop _merge
sort lnr
save /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/nokids_sample.dta, replace

restore

keep far_lnr barn`t'
duplicates drop
rename far_lnr lnr 

merge 1:1 lnr using /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/nokids_sample.dta

drop if _merge==1

drop _merge

save /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/nokids_sample.dta, replace
}

set more off
forvalues t=2010/2010 {
use lnr mor_lnr far_lnr foedselsdato  using "/ssb/ovibos/h1/kvs/wk24/alle_lnr_g`t'm12d31.dta", clear
gen efodtaar=date(foedselsdato,"YMD")
format efodtaar %td
drop foedselsdato
rename efodtaar foedselsdato

destring, replace force
duplicates drop
drop if lnr==.
drop if lnr==0
drop if mor_lnr==0
drop if far_lnr==0

gen fodselsaar=year(foedselsdato)

keep if fodselsaar==`t'
gen barn`t'=1

drop lnr

preserve
keep mor_lnr  barn`t'

duplicates drop

rename mor_lnr lnr

sort lnr

merge 1:1 lnr using /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/nokids_sample.dta

drop if _merge==1

drop _merge
sort lnr
save /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/nokids_sample.dta, replace

restore

keep far_lnr barn`t'
duplicates drop
rename far_lnr lnr 

merge 1:1 lnr using /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/nokids_sample.dta

drop if _merge==1

drop _merge

save /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/nokids_sample.dta, replace
}







*de i alder 42-63 i 2010 med barn og ikke barn

use /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/nokids_sample.dta, clear
gen nkids2010=0
replace barn2008=0 if barn2008==.
replace barn2009=0 if barn2009==.
replace barn2010=0 if barn2010==.
replace barn2007=0 if barn2007==.
sum lnr
tab barn2007
tab barn2008
tab barn2009
tab barn2010

gen barn20072010=barn2007+barn2008+barn2009+barn2010
tab barn20072010 
tab age_2010 if barn20072010==1 & kjonn==2 

replace antbarn=0 if antbarn==.
tab antbarn
sum lnr
replace nkids2010=antbarn+barn20072010

gen child2010=0
replace child2010=1 if nkids2010>0

bys kjonn: tab child2010



keep if year_sinc_arrival>=50
keep if child2010==0
sort lnr

save /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/nokids_sample.dta, replace

*Merge inn disposable inc.

use sivilstand ekt_lnr lnr using "/ssb/ovibos/h1/kvs/wk24/alle_lnr_g2010m12d31.dta", clear
destring, replace
gen marrcoh=.

replace marrcoh=1 if (sivilstand==1 | sivilstand==2 | sivilstand==5) 
replace marrcoh=0 if marrcoh==. & sivilstand!=. 

tab marrcoh
keep lnr marrcoh ekt_lnr

sort lnr

merge 1:1 lnr using /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/nokids_sample.dta
drop if _merge==1

drop _merge

sort lnr
save /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/nokids_sample.dta,replace

clear
 
use "/ssb/ovibos/h1/kvs/wk24/income/disp_g2010.dta"


destring, replace force

duplicates drop

bys lnr: gen n=_n
bys lnr: gen N=_N
drop if N>1
drop n N


gen benefits2010=(mat_pay+ch_allow+fam_allow+benefits)

*arbeids inntekt hvert aar fra skattefilene

gen arbinntekt2010=lonn 


*skatt: income tax
gen skatt=iskatt

keep arbinntekt benefits skatt lnr

sort lnr

merge 1:1 lnr using /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/nokids_sample.dta


drop if _merge==1
drop _merge


gen disp_inc_2010=arbinntekt2010+benefits2010-skatt2010
replace disp_inc_2010=0 if disp_inc_2010<0

sort lnr

save /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/nokids_sample.dta, replace



use lnr bu_nus2000 statborg using /ssb/ovibos/h1/kvs/wk24/bu_g2010.dta,clear


destring, replace force
drop if lnr==0
bys lnr: gen n=_n
bys lnr: gen N=_N
tab N
drop if N>1
drop n N





sort lnr
merge 1:m lnr using /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/nokids_sample.dta

drop if _merge==1

drop _merge

sort lnr

save /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/nokids_sample.dta,replace

use sivilstand lnr using "/ssb/ovibos/h1/kvs/wk24/alle_lnr_g2010m12d31.dta", clear

destring, replace force

sort lnr

merge 1:1 lnr using /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/nokids_sample.dta

drop if _merge==1
drop _merge

gen marr=1 if sivilstand==2 
replace marr=0 if marr==. & sivilstand!=. 
tab marr



gen citz=1 if statborg==0
replace citz=0 if statborg!=0 & statborg!=.


*utdanning:



gen string_nus2000=string(bu_nus2000)
gen nivaa=substr(string_nus2000, 1,1)
destring nivaa, gen(nivaa_n)
drop nivaa
rename nivaa_n nivaa
gen coll=1 if nivaa>=6 & nivaa<9
replace coll=0 if nivaa<6 & nivaa>0

gen HSC=1 if nivaa>=4 & nivaa<=5
replace HSC=0 if nivaa<4 & nivaa>0 | nivaa>5 & nivaa<9

gen dropout=1 if nivaa<=3 & nivaa>0
replace dropout=0 if nivaa>3 & nivaa<9


drop nivaa 
drop string_nus2000




sort lnr
save /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/nokids_sample.dta, replace


use /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/nokids_sample.dta,clear

bysort kjonn: sum age citz dropout HSC coll marr disp_inc_2010







log close

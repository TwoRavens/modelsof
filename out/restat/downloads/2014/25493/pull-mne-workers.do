clear
capture log close
cd "$root"

log using "JPP/brazspil/logs/%stata/%1setup/pull-mne-workers.log", replace

* PULL MNE SWITCHERS
use "JPP/brazspil/data/rais-draw-natl.dta"
keep if ano>1995
sort identificad ano
merge identificad ano using "JPP/brazspil/data/cnpj/aggcnpj-secex-fdi-match.dta"
tab _merge
keep if _merge==3
drop _merge
compress

gen cnae2d = int(clas_cnae_95/1000)
drop if cnae2d==. | cnae2d==95 | cnae2d==99

* Keep only plants with data for at least 2 periods
tempfile repeat
keep identificad ano
duplicates drop
duplicates tag identificad, gen(tagestab)
replace tagestab=tagestab+1
tab tagestab
drop if tagestab==1
drop tagestab
sort identificad ano
save `repeat'

use "JPP/brazspil/data/rais-draw-natl.dta"
keep if ano>1995
sort identificad ano
merge identificad ano using "JPP/brazspil/data/cnpj/aggcnpj-secex-fdi-match.dta"
tab _merge
keep if _merge==3
drop _merge
compress

gen cnae2d = int(clas_cnae_95/1000)
drop if cnae2d==. | cnae2d==95 | cnae2d==99

sort identificad ano
merge identificad ano using `repeat'
tab _merge
keep if _merge==3
drop _merge

* Keep only workers employed for at least 2 periods
sort wid ano
duplicates tag wid, gen(tagwid)
replace tagwid=tagwid+1
tab tagwid
drop if tagwid==1
drop tagwid

gen idadesq = idade*idade
rename temp_empr tenure
format tenure %10.2f
xtile tengrp=tenure, nq(2)
tab tengrp, gen(_ten)
gen numprodsq=numprod*numprod
gen numdestsq=numdest*numdest
gen higheduc = indhigh+indgrad
gen highocc = indwhit+indprof
gen lowocc = indsklb+indunsklb
preserve

* Worker Effect
tempfile worker
tsset wid ano
xi: xtreg lnwage tenure idade idadesq indhigh indgrad indsklb indwhit indprof p_indadol p_indnasc p_indearly p_indpeak p_indlate p_indhigh p_indgrad p_indfem p_indsklb p_indwhit p_indprof p_tenure p_lnsize export numprod numprodsq numdest numdestsq fdi i.ano, fe i(wid) cluster(identificad) nonest
predict u_ind, u
predict e_ind, e
keep wid u_ind
drop if u_ind==.
duplicates drop
xtile indwage=u_ind, nq(2)
gen highwageind=(indwage==2)
gen lowwageind=(indwage==1)
sort wid
save `worker'

restore, preserve
tempfile estab
* Establishment Effect
iis identificad
xi: xtreg lnwage tenure idade idadesq indhigh indgrad indfem indbraz indsklb indwhit indprof p_indadol p_indnasc p_indearly p_indpeak p_indlate p_indhigh p_indgrad p_indfem p_indsklb p_indwhit p_indprof p_tenure p_lnsize export numprod numprodsq numdest numdestsq fdi i.ano, fe i(identificad) cluster(identificad)
predict u_est, u
predict e_est, e
keep identificad u_est
drop if u_est==.
duplicates drop
xtile estwage=u_est, nq(2)
gen highwageest=(estwage==2)
gen lowwageest=(estwage==1)
sort identificad
save `estab'

restore, preserve
sort wid
merge wid using `worker'
tab _merge
drop _merge
sort identificad
merge identificad using `estab'
tab _merge
drop _merge

** Identify displaced workers
gen switchout=(emp_em_31_12==0)

tab caus_desl_tc 
tab caus_desl_tc switchout
tab caus_desl_tc fdi
sort wid ano
save "JPP/brazspil/data/all-workers.dta", replace

* Keep Only Switchers
drop if caus_desl_tc==5|caus_desl_tc==6|caus_desl_tc==7|caus_desl_tc==8|caus_desl_tc==9
sort wid
by wid: egen switcher = max(switchout)
keep if switcher==1
drop switcher

* Cause of Switch
tab caus_desl_tc
tab fdi
tab switchout
tab caus_desl_tc fdi
tab caus_desl_tc switchout
tab switchout fdi

gen layoff=(switchout==1 & caus_desl_tc==1|caus_desl_tc==2)
tab layoff
tab layoff fdi

gen quit=(switchout==1 & caus_desl_tc==3|caus_desl_tc==4)
tab quit
tab quit fdi

*** Domestic v. MNE Switcher
* MNE Switcher
gen mneswitcher = (fdi==1 & switchout==1)
tsset wid ano
by wid: egen _mnesw = max(mneswitcher)
replace mneswitcher=1 if l5.mneswitcher==1
replace mneswitcher=1 if l4.mneswitcher==1
replace mneswitcher=1 if l3.mneswitcher==1
replace mneswitcher=1 if l2.mneswitcher==1
replace mneswitcher=1 if l.mneswitcher==1

* High-Wage MNE Switcher
gen hwmneswitcher = (fdi==1 & switchout==1 & highwageest==1)
tsset wid ano
by wid: egen _hwmnesw = max(hwmneswitcher)
replace hwmneswitcher=1 if l5.hwmneswitcher==1
replace hwmneswitcher=1 if l4.hwmneswitcher==1
replace hwmneswitcher=1 if l3.hwmneswitcher==1
replace hwmneswitcher=1 if l2.hwmneswitcher==1
replace hwmneswitcher=1 if l.hwmneswitcher==1

* Low-Wage MNE Switcher
gen lwmneswitcher = (fdi==1 & switchout==1 & highwageest==0)
tsset wid ano
by wid: egen _lwmnesw = max(lwmneswitcher)
replace lwmneswitcher=1 if l5.lwmneswitcher==1
replace lwmneswitcher=1 if l4.lwmneswitcher==1
replace lwmneswitcher=1 if l3.lwmneswitcher==1
replace lwmneswitcher=1 if l2.lwmneswitcher==1
replace lwmneswitcher=1 if l.lwmneswitcher==1

* Exporter MNE Switcher
gen expmneswitcher = (fdi==1 & switchout==1 & export==1)
tsset wid ano
by wid: egen _expmnesw = max(expmneswitcher)
replace expmneswitcher=1 if l5.expmneswitcher==1
replace expmneswitcher=1 if l4.expmneswitcher==1
replace expmneswitcher=1 if l3.expmneswitcher==1
replace expmneswitcher=1 if l2.expmneswitcher==1
replace expmneswitcher=1 if l.expmneswitcher==1

* Non-Exporter MNE Switcher
gen nemneswitcher = (fdi==1 & switchout==1 & export==0)
tsset wid ano
by wid: egen _nemnesw = max(nemneswitcher)
replace nemneswitcher=1 if l5.nemneswitcher==1
replace nemneswitcher=1 if l4.nemneswitcher==1
replace nemneswitcher=1 if l3.nemneswitcher==1
replace nemneswitcher=1 if l2.nemneswitcher==1
replace nemneswitcher=1 if l.nemneswitcher==1

* Domestic Switcher
by wid: egen maxfdi = max(fdi)
gen domswitcher = (switchout==1 & maxfdi==0)
tsset wid ano
by wid: egen _domsw = max(domswitcher)
replace domswitcher=1 if l5.domswitcher==1
replace domswitcher=1 if l4.domswitcher==1
replace domswitcher=1 if l3.domswitcher==1
replace domswitcher=1 if l2.domswitcher==1
replace domswitcher=1 if l.domswitcher==1

* High-Wage Domestic Switcher
gen hwdomswitcher = (switchout==1 & maxfdi==0 & highwageest==1)
tsset wid ano
by wid: egen _hwdomsw = max(hwdomswitcher)
replace hwdomswitcher=1 if l5.hwdomswitcher==1
replace hwdomswitcher=1 if l4.hwdomswitcher==1
replace hwdomswitcher=1 if l3.hwdomswitcher==1
replace hwdomswitcher=1 if l2.hwdomswitcher==1
replace hwdomswitcher=1 if l.hwdomswitcher==1

* Low-Wage Domestic Switcher
gen lwdomswitcher = (switchout==1 & maxfdi==0 & highwageest==0)
tsset wid ano
by wid: egen _lwdomsw = max(lwdomswitcher)
replace lwdomswitcher=1 if l5.lwdomswitcher==1
replace lwdomswitcher=1 if l4.lwdomswitcher==1
replace lwdomswitcher=1 if l3.lwdomswitcher==1
replace lwdomswitcher=1 if l2.lwdomswitcher==1
replace lwdomswitcher=1 if l.lwdomswitcher==1

* Exporter Domestic Switcher
gen expdomswitcher = (switchout==1 & maxfdi==0 & export==1)
tsset wid ano
by wid: egen _expdomsw = max(expdomswitcher)
replace expdomswitcher=1 if l5.expdomswitcher==1
replace expdomswitcher=1 if l4.expdomswitcher==1
replace expdomswitcher=1 if l3.expdomswitcher==1
replace expdomswitcher=1 if l2.expdomswitcher==1
replace expdomswitcher=1 if l.expdomswitcher==1

* Non-Exporter Domestic Switcher
gen nedomswitcher = (switchout==1 & maxfdi==0 & export==0)
tsset wid ano
by wid: egen _nedomsw = max(nedomswitcher)
replace nedomswitcher=1 if l5.nedomswitcher==1
replace nedomswitcher=1 if l4.nedomswitcher==1
replace nedomswitcher=1 if l3.nedomswitcher==1
replace nedomswitcher=1 if l2.nedomswitcher==1
replace nedomswitcher=1 if l.nedomswitcher==1

foreach var in layoff quit _ten1 _ten2 lowwageind highwageind indprim higheduc highocc lowocc {
*** Domestic v. MNE Switcher
* MNE Switcher
gen `var'_mneswitcher = (`var'==1 & fdi==1 & switchout==1)
tsset wid ano
replace `var'_mneswitcher=1 if l5.`var'_mneswitcher==1
replace `var'_mneswitcher=1 if l4.`var'_mneswitcher==1
replace `var'_mneswitcher=1 if l3.`var'_mneswitcher==1
replace `var'_mneswitcher=1 if l2.`var'_mneswitcher==1
replace `var'_mneswitcher=1 if l.`var'_mneswitcher==1

* High-Wage MNE Switcher
gen `var'_hwmneswitcher = (`var'==1 & fdi==1 & switchout==1 & highwageest==1)
tsset wid ano
replace `var'_hwmneswitcher=1 if l5.`var'_hwmneswitcher==1
replace `var'_hwmneswitcher=1 if l4.`var'_hwmneswitcher==1
replace `var'_hwmneswitcher=1 if l3.`var'_hwmneswitcher==1
replace `var'_hwmneswitcher=1 if l2.`var'_hwmneswitcher==1
replace `var'_hwmneswitcher=1 if l.`var'_hwmneswitcher==1

* Low-Wage MNE Switcher
gen `var'_lwmneswitcher = (`var'==1 & fdi==1 & switchout==1 & highwageest==0)
tsset wid ano
replace `var'_lwmneswitcher=1 if l5.`var'_lwmneswitcher==1
replace `var'_lwmneswitcher=1 if l4.`var'_lwmneswitcher==1
replace `var'_lwmneswitcher=1 if l3.`var'_lwmneswitcher==1
replace `var'_lwmneswitcher=1 if l2.`var'_lwmneswitcher==1
replace `var'_lwmneswitcher=1 if l.`var'_lwmneswitcher==1

* Exporter MNE Switcher
gen `var'_expmneswitcher = (`var'==1 & fdi==1 & switchout==1 & export==1)
tsset wid ano
replace `var'_expmneswitcher=1 if l5.`var'_expmneswitcher==1
replace `var'_expmneswitcher=1 if l4.`var'_expmneswitcher==1
replace `var'_expmneswitcher=1 if l3.`var'_expmneswitcher==1
replace `var'_expmneswitcher=1 if l2.`var'_expmneswitcher==1
replace `var'_expmneswitcher=1 if l.`var'_expmneswitcher==1

* Non-Exporter MNE Switcher
gen `var'_nemneswitcher = (`var'==1 & fdi==1 & switchout==1 & export==0)
tsset wid ano
replace `var'_nemneswitcher=1 if l5.`var'_nemneswitcher==1
replace `var'_nemneswitcher=1 if l4.`var'_nemneswitcher==1
replace `var'_nemneswitcher=1 if l3.`var'_nemneswitcher==1
replace `var'_nemneswitcher=1 if l2.`var'_nemneswitcher==1
replace `var'_nemneswitcher=1 if l.`var'_nemneswitcher==1

* Domestic Switcher
gen `var'_domswitcher = (`var'==1 & switchout==1 & maxfdi==0)
tsset wid ano
replace `var'_domswitcher=1 if l5.`var'_domswitcher==1
replace `var'_domswitcher=1 if l4.`var'_domswitcher==1
replace `var'_domswitcher=1 if l3.`var'_domswitcher==1
replace `var'_domswitcher=1 if l2.`var'_domswitcher==1
replace `var'_domswitcher=1 if l.`var'_domswitcher==1

* High-Wage Domestic Switcher
gen `var'_hwdomswitcher = (`var'==1 & switchout==1 & maxfdi==0 & highwageest==1)
tsset wid ano
replace `var'_hwdomswitcher=1 if l5.`var'_hwdomswitcher==1
replace `var'_hwdomswitcher=1 if l4.`var'_hwdomswitcher==1
replace `var'_hwdomswitcher=1 if l3.`var'_hwdomswitcher==1
replace `var'_hwdomswitcher=1 if l2.`var'_hwdomswitcher==1
replace `var'_hwdomswitcher=1 if l.`var'_hwdomswitcher==1

* Low-Wage Domestic Switcher
gen `var'_lwdomswitcher = (`var'==1 & switchout==1 & maxfdi==0 & highwageest==0)
tsset wid ano
replace `var'_lwdomswitcher=1 if l5.`var'_lwdomswitcher==1
replace `var'_lwdomswitcher=1 if l4.`var'_lwdomswitcher==1
replace `var'_lwdomswitcher=1 if l3.`var'_lwdomswitcher==1
replace `var'_lwdomswitcher=1 if l2.`var'_lwdomswitcher==1
replace `var'_lwdomswitcher=1 if l.`var'_lwdomswitcher==1

* Exporter Domestic Switcher
gen `var'_expdomswitcher = (`var'==1 & switchout==1 & maxfdi==0 & export==1)
tsset wid ano
replace `var'_expdomswitcher=1 if l5.`var'_expdomswitcher==1
replace `var'_expdomswitcher=1 if l4.`var'_expdomswitcher==1
replace `var'_expdomswitcher=1 if l3.`var'_expdomswitcher==1
replace `var'_expdomswitcher=1 if l2.`var'_expdomswitcher==1
replace `var'_expdomswitcher=1 if l.`var'_expdomswitcher==1

* Non-Exporter Domestic Switcher
gen `var'_nedomswitcher = (`var'==1 & switchout==1 & maxfdi==0 & export==0)
tsset wid ano
replace `var'_nedomswitcher=1 if l5.`var'_nedomswitcher==1
replace `var'_nedomswitcher=1 if l4.`var'_nedomswitcher==1
replace `var'_nedomswitcher=1 if l3.`var'_nedomswitcher==1
replace `var'_nedomswitcher=1 if l2.`var'_nedomswitcher==1
replace `var'_nedomswitcher=1 if l.`var'_nedomswitcher==1
}

sort wid ano
save "JPP/brazspil/data/switchers.dta", replace

* Firms Hiring Former MNE Workers
tsset wid ano
gen hiremne = (fdi==0 & mneswitcher==1)
gen hirehwmne = (fdi==0 & hwmneswitcher==1)
gen hirelwmne = (fdi==0 & lwmneswitcher==1)
gen hireexpmne = (fdi==0 & expmneswitcher==1)
gen hirenemne = (fdi==0 & nemneswitcher==1)

foreach var in layoff quit _ten1 _ten2 lowwageind highwageind indprim higheduc highocc lowocc {
 gen `var'_hiremne = (fdi==0 & `var'_mneswitcher==1)
 gen `var'_hirehwmne = (fdi==0 & `var'_hwmneswitcher==1)
 gen `var'_hirelwmne = (fdi==0 & `var'_lwmneswitcher==1)
 gen `var'_hireexpmne = (fdi==0 & `var'_expmneswitcher==1)
 gen `var'_hirenemne = (fdi==0 & `var'_nemneswitcher==1)
}

sort identificad ano
by identificad ano: egen totalmne = sum(hiremne)
by identificad ano: egen totalhwmne = sum(hirehwmne)
by identificad ano: egen totallwmne = sum(hirelwmne)
by identificad ano: egen totalexpmne = sum(hireexpmne)
by identificad ano: egen totalnemne = sum(hirenemne)

foreach var in layoff quit _ten1 _ten2 lowwageind highwageind indprim higheduc highocc lowocc {
 by identificad ano: egen `var'_totalmne = sum(`var'_hiremne)
 by identificad ano: egen `var'_totalhwmne = sum(`var'_hirehwmne)
 by identificad ano: egen `var'_totallwmne = sum(`var'_hirelwmne)
 by identificad ano: egen `var'_totalexpmne = sum(`var'_hireexpmne)
 by identificad ano: egen `var'_totalnemne = sum(`var'_hirenemne)
}

keep identificad ano fdi totalmne totalhwmne totallwmne totalexpmne totalnemne *_totalmne *_totalhwmne *_totallwmne *_totalexpmne *_totalnemne
duplicates drop

* Only Domestic Firms Hiring Former MNE Workers
drop if fdi==1
drop fdi
sort identificad ano
save "JPP/brazspil/data/hiremne.dta", replace

* Firms Hiring Other Domestic Workers
use "JPP/brazspil/data/switchers.dta"
tsset wid ano
gen hiredom = (fdi==0 & domswitcher==1)
gen hirehwdom = (fdi==0 & hwdomswitcher==1)
gen hirelwdom = (fdi==0 & lwdomswitcher==1)
gen hireexpdom = (fdi==0 & expdomswitcher==1)
gen hirenedom = (fdi==0 & nedomswitcher==1)

foreach var in layoff quit _ten1 _ten2 lowwageind highwageind indprim higheduc highocc lowocc {
 gen `var'_hiredom = (fdi==0 & `var'_domswitcher==1)
 gen `var'_hirehwdom = (fdi==0 & `var'_hwdomswitcher==1)
 gen `var'_hirelwdom = (fdi==0 & `var'_lwdomswitcher==1)
 gen `var'_hireexpdom = (fdi==0 & `var'_expdomswitcher==1)
 gen `var'_hirenedom = (fdi==0 & `var'_nedomswitcher==1)
}

sort identificad ano
by identificad ano: egen totaldom = sum(hiredom)
by identificad ano: egen totalhwdom = sum(hirehwdom)
by identificad ano: egen totallwdom = sum(hirelwdom)
by identificad ano: egen totalexpdom = sum(hireexpdom)
by identificad ano: egen totalnedom = sum(hirenedom)

foreach var in layoff quit _ten1 _ten2 lowwageind highwageind indprim higheduc highocc lowocc {
 by identificad ano: egen `var'_totaldom = sum(`var'_hiredom)
 by identificad ano: egen `var'_totalhwdom = sum(`var'_hirehwdom)
 by identificad ano: egen `var'_totallwdom = sum(`var'_hirelwdom)
 by identificad ano: egen `var'_totalexpdom = sum(`var'_hireexpdom)
 by identificad ano: egen `var'_totalnedom = sum(`var'_hirenedom)
}

keep identificad ano fdi totaldom totalhwdom totallwdom totalexpdom totalnedom *_totaldom *_totalhwdom *_totallwdom *_totalexpdom *_totalnedom
duplicates drop

* Only Domestic Firms Hiring Other Domestic Workers
drop if fdi==1
drop fdi
sort identificad ano
save "JPP/brazspil/data/hiredom.dta", replace

* Find Employment in Domestic Firms Hiring Former MNE Workers & Other Domestic Workers
use "JPP/brazspil/data/all-workers.dta"
sort identificad ano
merge identificad ano using "JPP/brazspil/data/hiremne.dta"
tab _merge
drop _merge
replace totalmne=0 if totalmne==.
replace totalhwmne=0 if totalhwmne==.
replace totallwmne=0 if totallwmne==.
replace totalexpmne=0 if totalexpmne==.
replace totalnemne=0 if totalnemne==.

foreach var in layoff quit _ten1 _ten2 lowwageind highwageind indprim higheduc highocc lowocc {
 replace `var'_totalmne=0 if `var'_totalmne==.
 replace `var'_totalhwmne=0 if `var'_totalhwmne==.
 replace `var'_totallwmne=0 if `var'_totallwmne==.
 replace `var'_totalexpmne=0 if `var'_totalexpmne==.
 replace `var'_totalnemne=0 if `var'_totalnemne==.
}
 
sort identificad ano
merge identificad ano using "JPP/brazspil/data/hiredom.dta"
tab _merge
drop _merge
replace totaldom=0 if totaldom==.
replace totalhwdom=0 if totalhwdom==.
replace totallwdom=0 if totallwdom==.
replace totalexpdom=0 if totalexpdom==.
replace totalnedom=0 if totalnedom==.

foreach var in layoff quit _ten1 _ten2 lowwageind highwageind indprim higheduc highocc lowocc {
 replace `var'_totaldom=0 if `var'_totaldom==.
 replace `var'_totalhwdom=0 if `var'_totalhwdom==.
 replace `var'_totallwdom=0 if `var'_totallwdom==.
 replace `var'_totalexpdom=0 if `var'_totalexpdom==.
 replace `var'_totalnedom=0 if `var'_totalnedom==.
}

* Keep only Firms Hiring Former MNE Workers & Other Domestic Workers
sort identificad
by identificad: egen maxhire = max(totaldom+totalmne)
keep if maxhire>0
drop maxhire

* Keep only Incumbent Workers
sort wid
by wid: egen switcher=max(switchout)
drop if switcher==1
drop switcher

* Keep only Incumbent Domestic Workers
drop if fdi==1
drop fdi

* Keep only Balanced
duplicates tag wid identificad, gen(tag)
keep if tag==5
drop tag

sort identificad ano
by identificad ano: egen emp = count(wid)

sort identificad ano
compress
save "JPP/brazspil/data/wid/aggcnpj-workers.dta", replace

clear
log close
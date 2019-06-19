clear
capture log close
cd "$root"

log using "JPP/brazspil/logs/%stata/%1setup/prep-auxil-metro.log", replace

** FIRM-LEVEL AGGREGATES
foreach let in a b c d e f g h i j {
 use "JPP/brazspil/data/rais-draw-metro.dta"
 keep identificad
 duplicates drop
 
 sort identificad
 joinby identificad using "rais/base-agg/cnpj/aggcnpj_`let'.dta"
 sort identificad ano
 compress
 save "JPP/brazspil/data/cnpj/aggcnpj_`let'-metro.dta", replace
}

use "JPP/brazspil/data/cnpj/aggcnpj_a-metro.dta"
foreach let in b c d e f g h i j {
 append using "JPP/brazspil/data/cnpj/aggcnpj_`let'-metro.dta"
}

sort identificad ano
compress
save "JPP/brazspil/data/cnpj/aggcnpj-metro.dta", replace

use "JPP/brazspil/data/cnpj/aggcnpj-metro.dta", replace

* GENERATE FIRM-ID
gen double firmid=int(identificad/1000000)
format firmid %10.0g

* WAGE AND TENURE VARIABLE RESETTING
foreach var in rem_dezembro temp_empr sum_rem_dezembro {
  replace `var' = subinstr(`var',".","",.)
  replace `var' = subinstr(`var',",",".",.)
  gen _`var' = real(`var')
  drop `var'
  rename _`var' `var'
  }

* INDICATORS COMPARABLE TO WORKER-LEVEL INDICATORS
drop indprim_alt indhigh_alt
replace indgrad = indgrad+indscoll
drop indscoll
replace indprof = indprof+indtech
drop indtech
drop n_municipio indchild indretir indprjob

rename mod_subs_ibge p_subsector
rename mod_clas_cnae_95 p_cnae
replace p_cnae=int(p_cnae/10)
rename n_pis p_size
xtile largefirm=p_size,nq(2)
rename temp_empr tenure
format tenure %10.2f

foreach var in rem_dezembro sum_rem_dezembro tenure indyouth indadol indnasc indearly indpeak indlate indprim indhigh indgrad indfem indprof indwhit indsklb indunsklb {
 rename `var' p_`var'
}

* MERGE EXPORTER STATUS
sort firmid ano
merge firmid ano using "JPP/brazhetw/secex/exp-firms.dta"
tab _merge
drop if _merge==2
drop _merge
replace export=0 if export==. & ano>1989
replace valor=0 if valor==. & ano>1989
replace numprod=0 if numprod==. & ano>1989
replace numdest=0 if numdest==. & ano>1989
replace ev_export=0 if ev_export==. & ano>1989
replace ev_export98=0 if ev_export98==. & ano>1989
replace export90=0 if export90==. & ano>1989
replace exp_switchout=0 if exp_switchout==. & ano>1990
replace exp_switchin=0 if exp_switchin==. & ano>1990
replace exp_continue=0 if exp_continue==. & ano>1990
replace m_export=0 if m_export==. & ano>1989

sort firmid
by firmid: egen _ev_export = max(ev_export)
replace ev_export=_ev_export if ano<1990
drop _ev_export
sort firmid
by firmid: egen _ev_export98 = max(ev_export98)
replace ev_export98=_ev_export98 if ano<1990
drop _ev_export98
sort firmid
by firmid: egen _export90 = max(export90)
replace export90=_export90 if ano<1990
drop _export90
sort firmid
by firmid: egen _m_export = max(m_export)
replace m_export=_m_export if ano<1990
drop _m_export

compress
sort identificad ano
order identificad firmid p_cnae p_subsector ano
save "JPP/brazspil/data/cnpj/aggcnpj-secex-match-metro.dta", replace

* MERGE FDI DATA
sort identificad ano
merge identificad ano using "JPP/brazspil/auxil/fdi.dta"
tab _merge
drop if _merge==2
drop _merge fdi
rename fdi_cc fdi
replace fdi=0 if fdi==. & ano>1995
sort identificad ano
compress
save "JPP/brazspil/data/cnpj/aggcnpj-secex-fdi-match-metro.dta", replace

* MERGE PIA DATA
sort firmid ano
merge firmid ano using "JPP/brazhetw/auxil/pia.dta"
tab _merge
drop if _merge==2
drop _merge
compress

* MERGE UNION DATA
rename p_cnae cnae
sort cnae ano
merge cnae ano using "JPP/brazspil/auxil/union.dta"
tab _merge
drop if _merge==2
drop _merge
order identificad firmid cnae p_subsector ano
compress

* MERGE COMPARATIVE ADVANTAGE DATA
sort cnae ano
merge cnae ano using "JPP/brazspil/auxil/compadv.dta"
tab _merge
drop if _merge==2
drop _merge
compress

* MERGE SECTOR COVARIATES
sort cnae ano
merge cnae ano using "JPP/brazspil/auxil/cnae-agg.dta"
tab _merge
drop if _merge==2
drop _merge
compress

sort identificad ano
compress
save "JPP/brazspil/data/cnpj/aggcnpj-secex-fdi-match-metro.dta", replace

* GENERATE AVERAGE ANNUAL WAGE VARIABLE
sort ano
merge ano using "JPP/brazspil/auxil/minwage.dta"
tab _merge
drop _merge
compress

* Average Monthly Minimum Wage in Reais*Average Monthly Wage in Minimum Wages*Months Worked in Year
gen p_wage = minwage*p_rem_dezembro*12
label var p_wage "December Firm-Average Wages"
gen p_lnwage = log(p_wage)
label var p_lnwage "Log December Firm-Average Wages"

gen s_wage = minwage*s_rem_dezembro*12
label var s_wage "December Sector-Average Wages"
gen s_lnwage = log(s_wage)
label var s_lnwage "Log December Sector-Average Wages"

drop minwage

tsset identificad ano
by identificad: gen p_lnwage_gr = p_lnwage-l.p_lnwage
gen p_lnsize = log(p_size)
by identificad: gen emp_gr = p_lnsize-l.p_lnsize
gen ml1 = (emp_gr<-.3 &emp_gr~=.)
gen ml2 = (emp_gr<-.5 &emp_gr~=.)

sort identificad ano
compress
save "JPP/brazspil/data/cnpj/aggcnpj-secex-fdi-match-metro.dta", replace

clear
log close
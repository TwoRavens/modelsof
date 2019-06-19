cap log close


use  "$data\final_data.dta", clear 
drop if owner_new4==1

log using "$logs/table8.txt", text replace


/* programs */
run "$dofiles/tests.ado"
run "$dofiles/robust_hausman.ado"

/* Variables */
local variables1 = "sales employ fixas numcomp3 owner_new1 owner_new2 owner_new3 owner_new4 owner_new5 exp_prc_sales" 
local variables2 = "constrqA constrqB constrqD constrqE constrqF constrqG constrqH constrqJ constrqK constrqL constrqM constrqN constrqO constrqP constrqC constrqALL15" 
local variables3 = "labunsec age labunsec_age Q2_3perm_full_empR Q2_3part_tm_empR perfqH  perfqI  perfqJ_winsor  perfqG  perfqW_winsor" 
local variables5 = "sm_ma sm_fa sm_ta sm_my sm_fy sm_ty trt_sch_enr trt_sch_enrf trt_sch_enrm life_expf life_expm life_exp nmigr alc_beer alc_sprt alc_tot alc_wine"

replace gdppc_market = log(gdppc_market/1000)

egen obs = count(year), by(country prod2DIG sizeb year)
foreach var of local variables2 {
   cap drop BI_`var'
   egen m =mean(`var'), by(country prod2DIG sizeb year)
   gen BI_`var' = (m*obs - `var')/(obs - 1)
   drop m
  }

local variables4 = "BI_constrqA BI_constrqB BI_constrqD BI_constrqE BI_constrqF BI_constrqG BI_constrqH BI_constrqJ BI_constrqK BI_constrqL BI_constrqM BI_constrqN BI_constrqO BI_constrqP BI_constrqC BI_constrqALL15"


/* For models */

global PARS     = "logE logA " 
global PARS2    = "logE logA owner_new1 owner_new2 owner_new5" 
global ENDOGEN  = "logE logA owner_new1 owner_new2 owner_new5 logExp" 
global EXOGEN   = "BI_constrqB BI_constrqC BI_constrqD BI_constrqF BI_constrqG BI_constrqK BI_constrqM  BI_constrqN BI_constrqP" 
global EXOGEN2  = "sm_ta sm_ty trt_sch_enr life_exp nmigr alc_tot gdppc_market health_gdp educ_gdp" 
global EXOGEN3  = "trt_sch_enr alc_tot gdppc_market" 
global DUMMIES  = "sect1-sect2  sect4-sect7 i.year i.country" 
global INDUSTRY = "sect1-sect2  sect4-sect7" 

global INSTRUMENTS    = "labunsec labunsec2 age labunsec_age Q2_3perm_full_empR Q2_3part_tm_empR citytown perfqH perfqI" 
global INSTRB   = "labunsec_1 labunsec_2 labunsec_3 labunsec_age_1 labunsec_age_2 labunsec_age_3 age Q2_3perm_full_empR citytown perfqH perfqI" 



egen clstr = group(country prod2DIG sizeb year)
egen re    = group(country year)

/* Create more flexible instruments */
local i = 1 
while `i' <= 3 { 
        foreach var of global INSTRUMENTS { 
                gen `var'_`i' = 0 
                replace `var'_`i' = `var' if regmac == `i' 
        } 
        local i = `i' + 1 
} 
/*

gen x = 1

foreach var of global INSTRB {
replace x = 0 if `var' ==.
}

foreach var of varlist trt_sch_enr gdppc_market health_gdp{
replace x = 0 if `var' ==.
}

keep if x == 1
*/

egen x = rmiss($INSTRB trt_sch_enr gdppc_market health_gdp)
keep if x == 0

* NO FE, NO COVARIATES, NO GDP

xi: ivreg2 logS ($ENDOGEN = $INSTRB) numcomp3 $EXOGEN , ffirst robust cluster(clstr) 
outreg2 $ENDOGEN numcomp3 $EXOGEN using "$tables/table8a", replace bdec(3)  addstat("R-squared", e(r2)) se bracket label excel

foreach var of global EXOGEN{ 
  xi: ivreg2 logS ($ENDOGEN = $INSTRB) numcomp3 `var', ffirst robust cluster(clstr) 
  outreg2 $ENDOGEN numcomp3 `var' using "$tables/table8a", append bdec(3)  addstat("R-squared", e(r2)) se bracket label excel
local i = `i'+1
} 


* FE, NO COVARIATES, NO GDP

xi: ivreg2 logS ($ENDOGEN = $INSTRB) numcomp3 $EXOGEN $DUMMIES, ffirst robust cluster(clstr) 
outreg2 $ENDOGEN numcomp3 $EXOGEN using "$tables/table8b", replace bdec(3)  addstat("R-squared", e(r2)) se bracket label excel

foreach var of global EXOGEN{ 
  xi: ivreg2 logS ($ENDOGEN = $INSTRB) numcomp3 `var' $DUMMIES, ffirst robust cluster(clstr) 
  outreg2 $ENDOGEN numcomp3 `var' using "$tables/table8b", append bdec(3)  addstat("R-squared", e(r2)) se bracket label  excel
local i = `i'+1
} 


* COVARIATES, NO FE, NO GDP

xi: ivreg2 logS ($ENDOGEN = $INSTRB) numcomp3 $EXOGEN trt_sch_enr health_gdp, ffirst robust cluster(clstr) 
outreg2 $ENDOGEN numcomp3 $EXOGEN trt_sch_enr health_gdp using "$tables/table8c", replace bdec(3)  addstat("R-squared", e(r2)) se bracket label  excel

foreach var of global EXOGEN{ 
  xi: ivreg2 logS ($ENDOGEN = $INSTRB) numcomp3 `var' trt_sch_enr health_gdp, ffirst robust cluster(clstr) 
  outreg2 $ENDOGEN numcomp3 `var' trt_sch_enr  health_gdp using "$tables/table8c", append bdec(3)  addstat("R-squared", e(r2)) se bracket label excel
local i = `i'+1
} 

* COVARIATES & GDP, NO FE

xi: ivreg2 logS ($ENDOGEN = $INSTRB) numcomp3 $EXOGEN trt_sch_enr health_gdp  gdppc_market, ffirst robust cluster(clstr) 
outreg2 $ENDOGEN numcomp3 $EXOGEN trt_sch_enr  health_gdp  gdppc_market using "$tables/table8d", replace bdec(3)  addstat("R-squared", e(r2)) se bracket label  excel

foreach var of global EXOGEN{ 
  xi: ivreg2 logS ($ENDOGEN = $INSTRB) numcomp3 `var' trt_sch_enr health_gdp  gdppc_market, ffirst robust cluster(clstr) 
  outreg2 $ENDOGEN numcomp3 `var' trt_sch_enr  health_gdp gdppc_market using "$tables/table8d", append bdec(3)  addstat("R-squared", e(r2)) se bracket label excel
local i = `i'+1
} 

log close

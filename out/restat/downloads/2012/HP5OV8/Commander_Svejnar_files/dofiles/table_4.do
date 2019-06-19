/*use of the consolidated database with panel dummy*/
use  "data/final_data.dta", clear 
drop if owner_new4==1

/* programs */
run "dofiles/tests.ado"
run "dofiles/robust_hausman.ado"

log using "$logs/table4.txt", text replace


/* Variables */
local variables1 = "sales employ fixas numcomp3 owner_new1 owner_new2 owner_new3 owner_new4 owner_new5 exp_prc_sales" 
local variables2 = "constrqA constrqB constrqD constrqE constrqF constrqG constrqH constrqJ constrqK constrqL constrqM constrqN constrqO constrqP constrqC constrqALL15"
local variables3 = "labunsec age labunsec_age Q2_3perm_full_empR Q2_3part_tm_empR perfqH  perfqI  perfqJ_winsor  perfqG  perfqW_winsor"

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
global EXOGEN2  = "numcomp3 BI_constrqB BI_constrqD BI_constrqF BI_constrqG BI_constrqK BI_constrqM" 
global DUMMIES  = "sect1-sect2  sect4-sect7 i.year i.country" 
global INDUSTRY = "sect1-sect2  sect4-sect7" 

global INSTRUMENTS    = "labunsec labunsec2 age labunsec_age Q2_3perm_full_empR Q2_3part_tm_empR citytown perfqH perfqI" 
global INSTRB   = "labunsec_1 labunsec_2 labunsec_3 labunsec_age_1 labunsec_age_2 labunsec_age_3 age Q2_3perm_full_empR citytown perfqH perfqI" 


egen clstr = group(country prod2DIG sizeb year)

/* Create more flexible instruments */
local i = 1 
while `i' <= 3 { 
        foreach var of global INSTRUMENTS { 
                gen `var'_`i' = 0 
                replace `var'_`i' = `var' if regmac == `i' 
        } 
        local i = `i' + 1 
} 


/* regressions with constraints */

tempfile m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 m13


xi: ivreg2 logS ($ENDOGEN = $INSTRB) numcomp3 $EXOGEN $DUMMIES, ffirst robust cluster(clstr) 
outreg2 $ENDOGEN numcomp3 $EXOGEN using "$tables/table4", replace bdec(3) se aster(se) bracket label 
tests, column(model1) file(`m1') df(1) insts($INSTRB) exog(numcomp3 $EXOGEN $DUMMIES) cluster(clstr)

local i = 2 
foreach var of global EXOGEN{ 
  xi: ivreg2 logS ($ENDOGEN = $INSTRB) numcomp3 `var' $DUMMIES, ffirst robust cluster(clstr) 
  outreg2 $ENDOGEN numcomp3 `var' using "$tables/table4", append bdec(3) se aster(se) bracket label
  tests, column(model`i') file(`m`i'') df(1) insts($INSTRB) exog(numcomp3 `var' $DUMMIES) cluster(clstr)

local i = `i'+1
} 

xi: ivreg2 logS ($ENDOGEN = $INSTRB) numcomp3 BI_constrqALL15 $DUMMIES, ffirst robust cluster(clstr) 
outreg2 $ENDOGEN numcomp3 BI_constrqALL15 using "$tables/table4", append bdec(3) se aster(se) bracket label
tests, column(model11) file(`m11') df(1) insts($INSTRB) exog(numcomp3 BI_constrqALL15 $DUMMIES) cluster(clstr)

xi: ivreg2 logS ($ENDOGEN = $INSTRB) numcomp3 $EXOGEN $DUMMIES, ffirst robust cluster(clstr) 
outreg2 $ENDOGEN numcomp3 $EXOGEN using "$tables/table4", append bdec(3) se aster(se) bracket label 
tests, column(model12) file(`m12') df(1) insts($INSTRB) exog(numcomp3 $EXOGEN $DUMMIES) cluster(clstr)



preserve

/* F and J Tests */
use `m1', clear

forvalues i =2(1)12{
 merge variable using `m`i''
 drop _m
 sort variable
}

order variable
outsheet using "$tables/table4_tests.csv", replace comma
restore


/*OLS*/

gen x = 1

foreach var of global INSTRB {
replace x = 0 if `var' ==.
}

keep if x == 1


xi: regress logS $ENDOGEN numcomp3 $EXOGEN $DUMMIES, robust cluster(clstr) 
outreg2 $ENDOGEN numcomp3 $EXOGEN using "$tables/tableA4", replace bdec(3) se aster(se) bracket label 

foreach var of global EXOGEN{ 
xi: regress logS $ENDOGEN numcomp3 `var' $DUMMIES, robust cluster(clstr) 
outreg2 $ENDOGEN numcomp3 `var' using "$tables/tableA4", append bdec(3) se aster(se) bracket label      
} 

xi: regress logS $ENDOGEN numcomp3 BI_constrqALL15 $DUMMIES, robust cluster(clstr) 
outreg2 $ENDOGEN numcomp3 BI_constrqALL15 using "$tables/tableA4", append bdec(3) se aster(se) bracket label      

xi: regress logS $ENDOGEN numcomp3 $EXOGEN $DUMMIES, robust cluster(clstr) 
outreg2 $ENDOGEN numcomp3 $EXOGEN using "$tables/tableA4", append bdec(3) se aster(se) bracket label sortvar($ENDOGEN numcomp3 $EXOGEN)

log close


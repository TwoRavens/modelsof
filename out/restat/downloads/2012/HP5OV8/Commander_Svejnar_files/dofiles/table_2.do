cap log close

/*use of the consolidated database with panel dummy*/
use  "$data/final_data.dta", clear 

drop if owner_new4==1 /* drop observations with "other" owners */

/* programs */
run "$dofiles/tests.ado"
run "$dofiles/robust_hausman.ado"

log using "$logs/table2.txt", text replace

/* Variables */
local variables1 = "sales employ fixas numcomp3 owner_new1 owner_new2 owner_new3 owner_new4 owner_new5 exp_prc_sales" 
local variables2 = "constrqA constrqB constrqD constrqE constrqF constrqG constrqH constrqJ constrqK constrqL constrqM constrqN constrqO constrqP constrqC constrqALL15" 
local variables3 = "labunsec age labunsec_age Q2_3perm_full_empR Q2_3part_tm_empR perfqH  perfqI  perfqJ_winsor  perfqG  perfqW_winsor" 
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
 

                                                                                  
/* regressions without constraints */
tempfile m1 m2 m3 m4 m5 m6 m7 m8

xi: ivreg2 logS ($PARS = $INSTRB) $DUMMIES, ffirst robust cluster(clstr)

outreg2 $PARS using "$tables/table2", replace bdec(3) se aster(se) bracket label
tests, column(model1) file(`m1') df(5) insts($INSTRB) exog($DUMMIES) cluster(clstr)

xi: ivreg2 logS ($PARS logExp = $INSTRB) $DUMMIES, ffirst robust cluster(clstr) 
outreg2 $PARS logExp using "$tables/table2", append bdec(3) se aster(se) bracket label
tests, column(model2) file(`m2') df(4) insts($INSTRB) exog($DUMMIES) cluster(clstr)

xi: ivreg2 logS ($PARS = $INSTRB) numcomp3 $DUMMIES, ffirst robust cluster(clstr) 
outreg2 $PARS numcomp3 using "$tables/table2", append bdec(3) se aster(se) bracket label
tests, column(model3) file(`m3') df(5) insts($INSTRB) exog(numcomp3 $DUMMIES) cluster(clstr)

xi: ivreg2 logS ($PARS logExp = $INSTRB) numcomp3 $DUMMIES, ffirst robust cluster(clstr) 
outreg2 $PARS logExp numcomp3 using "$tables/table2", append bdec(3) se aster(se) bracket label  
tests, column(model4) file(`m4') df(4) insts($INSTRB) exog(numcomp3 $DUMMIES) cluster(clstr)

xi: ivreg2 logS ($PARS2 = $INSTRB) $DUMMIES, ffirst robust cluster(clstr) 
outreg2 $PARS2 using "$tables/table2", append bdec(3) se aster(se) bracket label  
tests, column(model5) file(`m5') df(2) insts($INSTRB) exog($DUMMIES) cluster(clstr)

xi: ivreg2 logS ($ENDOGEN = $INSTRB) $DUMMIES, ffirst robust cluster(clstr) 
outreg2 $ENDOGEN using "$tables/table2", append bdec(3) se aster(se) bracket label
tests, column(model6) file(`m6') df(1) insts($INSTRB) exog($DUMMIES) cluster(clstr)

xi: ivreg2 logS ($PARS2 = $INSTRB) numcomp3 $DUMMIES , ffirst robust cluster(clstr)
outreg2 $PARS2 numcomp3 using "$tables/table2", append bdec(3) se aster(se) bracket label  
tests, column(model7) file(`m7') df(2) insts($INSTRB) exog(numcomp3 $DUMMIES) cluster(clstr)

xi: ivreg2 logS ($ENDOGEN = $INSTRB) numcomp3 $DUMMIES, ffirst robust cluster(clstr) 
outreg2 $ENDOGEN numcomp3 using "$tables/table2", append bdec(3) se aster(se) bracket label sortvar(logE logA logExp numcomp3 owner_new1 owner_new2 owner_new5)
tests, column(model8) file(`m8') df(1) insts($INSTRB) exog(numcomp3 $DUMMIES) cluster(clstr)


/* F and J Tests */
preserve
use `m1', clear

forvalues i =2(1)8{
 merge variable using `m`i''
 drop _m
 sort variable
}

order variable

outsheet using "$tables/table2_tests.csv", replace comma
restore

/*OLS version of table 2 */
gen x = 1

foreach var of global INSTRB {
        replace x = 0 if `var' ==.
        }
        
keep if x == 1

/* OLS regressions */

xi: regress logS $PARS $DUMMIES, robust cluster(clstr) 
outreg2 $PARS using "$tables/table2_ols", replace bdec(3) se aster(se) bracket label

xi: regress logS $PARS logExp $DUMMIES, robust cluster(clstr) 
outreg2 $PARS logExp using "$tables/table2_ols", append bdec(3) se aster(se) bracket label  

xi: regress logS $PARS numcomp3 $DUMMIES, robust cluster(clstr) 
outreg2 $PARS numcomp3 using "$tables/table2_ols", append bdec(3) se aster(se) bracket label

xi: regress logS $PARS logExp numcomp3 $DUMMIES, robust cluster(clstr) 
outreg2 $PARS logExp numcomp3 using "$tables/table2_ols", append bdec(3) se aster(se) bracket label   
        
xi: regress logS $PARS2 $DUMMIES, robust cluster(clstr) 
outreg2 $PARS2 using "$tables/table2_ols", append bdec(3) se aster(se) bracket label  

xi: regress logS $ENDOGEN $DUMMIES, robust cluster(clstr) 
outreg2 $ENDOGEN using "$tables/table2_ols", append bdec(3) se aster(se) bracket label

xi: regress logS $PARS2 numcomp3 $DUMMIES, robust cluster(clstr) 
outreg2 $PARS2 numcomp3 using "$tables/table2_ols", append bdec(3) se aster(se) bracket label  

xi: regress logS $ENDOGEN numcomp3 $DUMMIES, robust cluster(clstr) 
outreg2 $ENDOGEN numcomp3 using "$tables/table2_ols", append bdec(3) se aster(se) bracket label

log close


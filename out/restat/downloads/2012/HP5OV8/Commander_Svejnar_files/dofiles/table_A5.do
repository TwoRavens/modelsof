/*use of the consolidated database with panel dummy*/
use  "$data/final_data.dta", clear 
drop if owner_new4==1

/* programs */
run "$dofiles/tests.ado"
run "$dofiles/robust_hausman.ado"

log using "$logs/tableA5.txt", text replace


/* Variables */
local variables1 = "sales employ fixas numcomp3 owner_new1 owner_new2 owner_new3 owner_new4 owner_new5 exp_prc_sales" 
local variables2 = "constrqA constrqB constrqD constrqE constrqF constrqG constrqH constrqJ constrqK constrqL constrqM constrqN constrqO constrqP constrqC constrqALL15" 
local variables3 = "labunsec age labunsec_age Q2_3perm_full_empR Q2_3part_tm_empR perfqH  perfqI  perfqJ_winsor  perfqG  perfqW_winsor" 
local variables2 = "constrqA constrqB constrqD constrqE constrqF constrqG constrqH constrqJ constrqK constrqL constrqM constrqN constrqO constrqP constrqC constrqALL15"
local variables3 = "labunsec age labunsec_age Q2_3perm_full_empR Q2_3part_tm_empR perfqH  perfqI  perfqJ_winsor  perfqG  perfqW_winsor"

gen rm = constrqALL15
egen sdc = rowsd(`variables2')

egen obs = count(year), by(country prod2DIG sizeb year)
foreach var of local variables2 {
   cap drop BI_`var'
   gen BI_`var' = (`var' - rm)/sdc
  }
  

local variables4 = "BI_constrqA BI_constrqB BI_constrqD BI_constrqE BI_constrqF BI_constrqG BI_constrqH BI_constrqJ BI_constrqK BI_constrqL BI_constrqM BI_constrqN BI_constrqO BI_constrqP BI_constrqC BI_constrqALL15"


/* For models */

global PARS     = "logE logA " 
global PARS2    = "logE logA owner_new1 owner_new2 owner_new5" 
global ENDOGEN  = "logE logA owner_new1 owner_new2 owner_new5 logExp" 
global EXOGEN   = "BI_constrqB BI_constrqC BI_constrqD BI_constrqF BI_constrqG BI_constrqK BI_constrqM  BI_constrqN BI_constrqP" 
global EXOGEN2  = "numcomp3 BI_constrqB BI_constrqD BI_constrqF BI_constrqG BI_constrqK BI_constrqM" 
global DUMMIES  = "sect1-sect2  sect4-sect7 i.year i.country" 

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




/* regressions with constraints */

tempfile m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12


xi: ivreg2 logS ($ENDOGEN = $INSTRB) numcomp3 rm $EXOGEN, ffirst robust cluster(clstr) 
outreg2 $ENDOGEN numcomp3 rm $EXOGEN using "$tables/tableA5", replace bdec(3) se aster(se) bracket label 
tests, column(model1) file(`m1') df(1) insts($INSTRB) exog(numcomp3 rm $EXOGEN $DUMMIES) cluster(clstr)

local i = 2 
foreach var of global EXOGEN{ 
  xi: ivreg2 logS ($ENDOGEN = $INSTRB) numcomp3 rm `var', ffirst robust cluster(clstr) 
  outreg2 $ENDOGEN numcomp3 rm `var' using "$tables/tableA5", append bdec(3) se aster(se) bracket label
  tests, column(model`i') file(`m`i'') df(1) insts($INSTRB) exog(numcomp3 rm `var' $DUMMIES) cluster(clstr)

local i = `i'+1
} 

xi: ivreg2 logS ($ENDOGEN = $INSTRB) numcomp3 rm, ffirst robust cluster(clstr) 
outreg2 $ENDOGEN numcomp3 rm using "$tables/tableA5", append bdec(3) se aster(se) bracket label
tests, column(model11) file(`m11') df(1) insts($INSTRB) exog(numcomp3 rm $DUMMIES) cluster(clstr)

xi: ivreg2 logS ($ENDOGEN = $INSTRB) numcomp3 rm $EXOGEN, ffirst robust cluster(clstr) 
outreg2 $ENDOGEN numcomp3 rm $EXOGEN using "$tables/tableA5", append bdec(3) se aster(se) bracket label 
tests, column(model12) file(`m12') df(1) insts($INSTRB) exog(numcomp3 rm $EXOGEN $DUMMIES) cluster(clstr)


preserve

/* F and J Tests */
use `m1', clear

forvalues i =2(1)12{
 merge variable using `m`i''
 drop _m
 sort variable
}

order variable

outsheet using "$tables/tableA5_tests.csv", replace comma
restore


log close


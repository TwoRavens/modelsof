clear
clear matrix
cap log close
set mem 650m
set more 1
set matsize 800

** To replicate the published results use the package st0030_2.pkg for ivreg2. See http://www.stata-journal.com/software/sj5-4. **

version 10

log using Table_1_and_2_appendix.log,replace 

use data_Table_1_and_2_appendix.dta


tab state, gen(dstate)

global pol yy governor st_leg tci tei
global year yearr*
global state dstate*


/**********************
** Generate Table 1 **
**********************/
gen rhs=sigma
gen iv=sigmalag2
label var rhs "tax measure"


reg sdrcnd rhs $state
outreg using Table_1_appendix.txt, replace se bdec(4) coefastr 3aster bracket 
estimates store Table_11


ivreg2 sdrcnd (rhs = $pol $year) $state
outreg using Table_1_appendix.txt, append se bdec(4) coefastr 3aster bracket 
estimates store Table_12


ivreg2 sdrcnd (rhs = iv) $state
outreg using Table_1_appendix.txt, append se bdec(4) coefastr 3aster bracket 
estimates store Table_13

ivreg2 sdrcnd (u_rate rhs = iv u_ratelag1) $state
outreg using Table_1_appendix.txt, append se bdec(4) coefastr 3aster bracket 
estimates store Table_14

drop rhs iv

gen rhs=mu
gen iv=mulag2
label var rhs "tax measure"

reg sdrcnd rhs $state
outreg using Table_1_appendix.txt, append se bdec(4) coefastr 3aster bracket 
estimates store Table_15


ivreg2 sdrcnd (rhs = $pol $year) $state
outreg using Table_1_appendix.txt, append se bdec(4) coefastr 3aster bracket 
estimates store Table_16


ivreg2 sdrcnd (rhs = iv) $state
outreg using Table_1_appendix.txt, append se bdec(4) coefastr 3aster bracket 
estimates store Table_17

ivreg2 sdrcnd (u_rate rhs = iv u_ratelag1) $state
outreg using Table_1_appendix.txt, append se bdec(4) coefastr 3aster bracket 
estimates store Table_18

drop rhs iv

estout Table_1* using Table1_appendix.out, style(tex)  keep (rhs u_rate _cons)  cells(b(star fmt(%9.4f)) se(par))  ///
starlevels(* 0.10 ** 0.05 *** 0.01) legend label collabels(, none) prehead(\begin{tabular}{l*{@M}{r}}) postfoot(\end{tabular}) replace


/**********************
** Generate Table 2 **
**********************/

gen rhs=sigma
gen iv=sigmalag2
label var rhs "tax measure"


reg mrcnd rhs $state
outreg using Table_2_appendix.txt, replace se bdec(4) coefastr 3aster bracket 
estimates store Table_21


ivreg2 mrcnd (rhs = $pol $year) $state
outreg using Table_2_appendix.txt, append se bdec(4) coefastr 3aster bracket 
estimates store Table_22


ivreg2 mrcnd (rhs = iv) $state
outreg using Table_2_appendix.txt, append se bdec(4) coefastr 3aster bracket 
estimates store Table_23

ivreg2 mrcnd (u_rate rhs = iv u_ratelag1) $state
outreg using Table_2_appendix.txt, append se bdec(4) coefastr 3aster bracket 
estimates store Table_24

drop rhs iv

gen rhs=mu
gen iv=mulag2
label var rhs "tax measure"


reg mrcnd rhs $state
outreg using Table_2_appendix.txt, append se bdec(4) coefastr 3aster bracket 
estimates store Table_25


ivreg2 mrcnd (rhs = $pol $year) $state
outreg using Table_2_appendix.txt, append se bdec(4) coefastr 3aster bracket 
estimates store Table_26


ivreg2 mrcnd (rhs = iv) $state
outreg using Table_2_appendix.txt, append se bdec(4) coefastr 3aster bracket 
estimates store Table_27

ivreg2 mrcnd (u_rate rhs = iv u_ratelag1) $state
outreg using Table_2_appendix.txt, append se bdec(4) coefastr 3aster bracket 
estimates store Table_28

drop rhs iv

estout Table_2* using Table2_appendix.out, style(tex)  keep (rhs u_rate _cons)  cells(b(star fmt(%9.4f)) se(par))  ///
starlevels(* 0.10 ** 0.05 *** 0.01) legend label collabels(, none) prehead(\begin{tabular}{l*{@M}{r}}) postfoot(\end{tabular}) replace


cap log close
clear all

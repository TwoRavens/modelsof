clear
clear matrix
cap log close
set mem 650m
set more 1
set matsize 800

** To replicate the published results use the package st0030_2.pkg for ivreg2. See http://www.stata-journal.com/software/sj5-4. **

version 10

log using Table_3_and_4.log,replace 

use data.dta

tab state, gen(dstate)


global pol yy governor st_leg tci tei
global year yearr*
global state dstate*

/**********************
** Generate Table 3 **
**********************/
gen rhs=sigma
gen iv=sigmalag2
label var rhs "tax measure"

reg sdrcnd rhs
estimates store Table_31
outreg using Table_3.txt, replace se bdec(4) coefastr 3aster bracket 

reg sdrcnd rhs $state
outreg using Table_3.txt, append se bdec(4) coefastr 3aster bracket 
estimates store Table_32


ivreg2 sdrcnd (rhs = $pol $year) $state
outreg using Table_3.txt, append se bdec(4) coefastr 3aster bracket 
estimates store Table_33



ivreg2 sdrcnd (rhs = iv) $state
outreg using Table_3.txt, append se bdec(4) coefastr 3aster bracket 
estimates store Table_34

ivreg2 sdrcnd (u_rate rhs = iv u_ratelag1) $state
outreg using Table_3.txt, append se bdec(4) coefastr 3aster bracket 
estimates store Table_35

drop rhs iv

gen rhs=mu
gen iv=mulag2
label var rhs "tax measure"

reg sdrcnd rhs
estimates store Table_36
outreg using Table_3.txt, append se bdec(4) coefastr 3aster bracket 


reg sdrcnd rhs $state
outreg using Table_3.txt, append se bdec(4) coefastr 3aster bracket 
estimates store Table_37


ivreg2 sdrcnd (rhs = $pol $year) $state
outreg using Table_3.txt, append se bdec(4) coefastr 3aster bracket 
estimates store Table_38



ivreg2 sdrcnd (rhs = iv) $state
outreg using Table_3.txt, append se bdec(4) coefastr 3aster bracket 
estimates store Table_39

ivreg2 sdrcnd (u_rate rhs = iv u_ratelag1) $state
outreg using Table_3.txt, append se bdec(4) coefastr 3aster bracket 
estimates store Table_310

drop rhs iv

estout Table_3* using Table3.out, style(tex)  keep (rhs u_rate _cons)  cells(b(star fmt(%9.4f)) se(par))  ///
starlevels(* 0.10 ** 0.05 *** 0.01) legend label collabels(, none) prehead(\begin{tabular}{l*{@M}{r}}) postfoot(\end{tabular}) replace


/**********************
** Generate Table 4 **
**********************/

gen rhs=sigma
gen iv=sigmalag2
label var rhs "tax measure"

reg mrcnd rhs
estimates store Table_41
outreg using Table_4.txt, replace se bdec(4) coefastr 3aster bracket 


reg mrcnd rhs $state
outreg using Table_4.txt, append se bdec(4) coefastr 3aster bracket 
estimates store Table_42


ivreg2 mrcnd (rhs = $pol $year) $state
outreg using Table_4.txt, append se bdec(4) coefastr 3aster bracket 
estimates store Table_43



ivreg2 mrcnd (rhs = iv) $state
outreg using Table_4.txt, append se bdec(4) coefastr 3aster bracket 
estimates store Table_44

ivreg2 mrcnd (u_rate rhs = iv u_ratelag1) $state
outreg using Table_4.txt, append se bdec(4) coefastr 3aster bracket 
estimates store Table_45

drop rhs iv

gen rhs=mu
gen iv=mulag2
label var rhs "tax measure"

reg mrcnd rhs
estimates store Table_46
outreg using Table_4.txt, append se bdec(4) coefastr 3aster bracket 

reg mrcnd rhs $state
outreg using Table_4.txt, append se bdec(4) coefastr 3aster bracket 
estimates store Table_47


ivreg2 mrcnd (rhs = $pol $year) $state
outreg using Table_4.txt, append se bdec(4) coefastr 3aster bracket 
estimates store Table_48


ivreg2 mrcnd (rhs = iv) $state
outreg using Table_4.txt, append se bdec(4) coefastr 3aster bracket 
estimates store Table_49

ivreg2 mrcnd (u_rate rhs = iv u_ratelag1) $state
outreg using Table_4.txt, append se bdec(4) coefastr 3aster bracket 
estimates store Table_410

drop rhs iv

estout Table_4* using Table4.out, style(tex)  keep (rhs u_rate _cons)  cells(b(star fmt(%9.4f)) se(par))  ///
starlevels(* 0.10 ** 0.05 *** 0.01) legend label collabels(, none) prehead(\begin{tabular}{l*{@M}{r}}) postfoot(\end{tabular}) replace



cap log close
clear all

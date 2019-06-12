*** Political values and Partisanship ****

clear all
capture log close
set more off, perm 
cd "/Users/aneundorf/Dropbox/Paper_Geoff/Graphs/"




*** Figure of CMP data and Coeffients: Issue-based partisan updating


save "Data_coef.dta", replace
use "Data_coef.dta", clear

*drop same
gen same =0
replace same =1 if ideo1==direction 

** Labels

label def partylbl1 2 "None" 1 "Tories" 3 "Labour"
label value party1 partylbl1
tab party1

label def ideolbl 1 "Rightist" 2 "Centrist" 3 "Leftist"
label value ideo1 ideolbl
tab ideo1

lab def dirlbl1 1 "Right/Tories" 2 "Cent/None" 3 "Left/Labour"
lab val direction dirlbl1

lab def typlbl 1"Cross-lagged coef." 0 "Stability coef."
lab val type typlbl

lab def dvlbl 1"DV: Core values" 2"DV: Partisanship"
lab val dv dvlbl



* Period: 1991-2007: CONSISTENCY
replace direction = direction + 0.2 if dv ==2

twoway bar coef direction if same==1 & dv==1 & type==1 & time==0, barw(0.2) bc(black)  || ///
rcap ci_up ci_low direction if same==1 & dv==1 & type==1 & time==0 || ///
bar coef direction if same==1 & dv==2 & type==1 & time==0, barw(0.2)  || ///
rcap ci_up ci_low direction if same==1 & dv==2 & type==1 & time==0, ///
title("Estimated cross-lagged effects") ///
ylabel(-0.5(1)5.5) ///
 ytitle("Estimated Coefficients""(Incl. 95% C.I.)", size(medlarge)) yline(0) xlabel(1(1)3, valuelabel)  xtitle("") ///
 legend( off) ///
 	scheme(s1mono) col(1)  xsize(6) ysize(9) /// 
 	name(coef_cross, replace)
 	
 	
 	twoway bar coef direction if same==1 & dv==1 & type==0 & time==0, barw(0.2) bc(black) || ///
rcap ci_up ci_low direction if same==1 & dv==1 & type==0 & time==0|| ///
bar coef direction if same==1 & dv==2 & type==0 & time==0, barw(0.2)  || ///
rcap ci_up ci_low direction if same==1 & dv==2 & type==0 & time==0 & time==0, ///
title("Estimated stability coef.") ///
ylabel(-0.5(1)5.5) ///
 ytitle("Estimated Coefficients""(Incl. 95% C.I.)", size(medlarge)) yline(0) xlabel(1(1)3, valuelabel)  xtitle("") ///
 legend( order(1 3) row(1) lab(1 "DV: Core values") lab(3 "DV: Partisanship") region(lc(white))) ///
 	scheme(s1mono) col(1)  xsize(6) ysize(9) /// 
 	name(coef_stable, replace)

 
graph combine  coef_cross coef_stable, scheme(s1mono) cols(1) xsize(8) ysize(8) ///
name(coef_CONSISTENT, replace) 
*title("Ideological/Partisan Consistency")  ///

	graph export "Coef_CONSISTENT.pdf", width(1000) replace
	
	
	
	* Period: 1991-2007: INCONSISTENCY
*replace direction = direction + 0.2 if dv ==2

gen diff = 0 
replace diff = 1 if ideo1==1 & direction==3
replace diff = 1 if ideo1==3 & direction==1
replace diff = 1 if party1==1 & direction==3
replace diff = 1 if party1==3 & direction==1

gen direct_diff = direction
recode direct_diff (2=.) (3=2)

lab def dirlbl2 1 "Right/Tories (at t)" 2 "Left/Labour (at t)"
lab val direct_diff dirlbl2

replace direct_diff = direct_diff + 0.2 if dv ==2


twoway bar coef direct_diff if diff==1 & dv==1 & type==1 & time==0, barw(0.2) bc(black)  || ///
rcap ci_up ci_low direct_diff  if diff==1 & dv==1 & type==1 & time==0 || ///
bar coef direct_diff  if diff==1 & dv==2 & type==1 & time==0, barw(0.2)  || ///
rcap ci_up ci_low direct_diff  if diff==1 & dv==2 & type==1 & time==0, ///
title("Estimated cross-lagged effects") ///
ylabel(-5.5(1)0.5) ///
 ytitle("Estimated Coefficients""(Incl. 95% C.I.)", size(medlarge)) yline(0) xlabel(1(1)2.3, valuelabel)  xtitle("") ///
 legend( off) ///
 	scheme(s1mono) col(1)  xsize(6) ysize(9) /// 
 	name(coef_cross_diff, replace)
 	
 	
 	twoway bar coef direct_diff  if diff==1 & dv==1 & type==0 & time==0, barw(0.2) bc(black) || ///
rcap ci_up ci_low direct_diff  if diff ==1 & dv==1 & type==0 & time==0 || ///
bar coef direct_diff  if diff ==1 & dv==2 & type==0 & time==0, barw(0.2)  || ///
rcap ci_up ci_low direct_diff  if diff ==1 & dv==2 & type==0 & time==0, ///
title("Estimated stability coef.") ///
ylabel(-5.5(1)0.5) ///
 ytitle("Estimated Coefficients""(Incl. 95% C.I.)", size(medlarge)) yline(0) xlabel(1(1)2.3, valuelabel)  xtitle("") ///
 legend( order(1 3) row(1) lab(1 "DV: Core values") lab(3 "DV: Partisanship") region(lc(white))) ///
 	scheme(s1mono) col(1)  xsize(6) ysize(9) /// 
 	name(coef_stable_diff, replace)

 
graph combine  coef_cross_diff coef_stable_diff, scheme(s1mono) cols(1) xsize(6) ysize(9) ///
title("Ideological/Partisan Inconsistency")  ///
 name(coef_INCONSISTENT, replace)
	graph export "Coef_Diff.png", width(1000) replace




* Period: 1991-1995: CONSISTENCY
*replace direction = direction + 0.2 if dv ==2

twoway bar coef direction if same==1 & dv==1 & type==1 & time==1, barw(0.2) bc(black)  || ///
rcap ci_up ci_low direction if same==1 & dv==1 & type==1 & time==1 || ///
bar coef direction if same==1 & dv==2 & type==1 & time==1, barw(0.2)  || ///
rcap ci_up ci_low direction if same==1 & dv==2 & type==1 & time==1, ///
title("Estimated cross-lagged effects") ///
ylabel(-0.5(1)6.5) ///
 ytitle("Estimated Coefficients""(Incl. 95% C.I.)", size(medlarge)) yline(0) xlabel(1(1)3, valuelabel)  xtitle("") ///
 legend( off) ///
 	scheme(s1mono) col(1)  xsize(6) ysize(9) /// 
 	name(coef_cross91, replace)
 	
 	
 	twoway bar coef direction if same==1 & dv==1 & type==0 & time==1, barw(0.2) bc(black) || ///
rcap ci_up ci_low direction if same==1 & dv==1 & type==0 & time==1 || ///
bar coef direction if same==1 & dv==2 & type==0 & time==1, barw(0.2)  || ///
rcap ci_up ci_low direction if same==1 & dv==2 & type==0 & time==1 , ///
title("Estimated stability coef.") ///
ylabel(-0.5(1)6.5) ///
 ytitle("Estimated Coefficients""(Incl. 95% C.I.)", size(medlarge)) yline(0) xlabel(1(1)3, valuelabel)  xtitle("") ///
 legend( order(1 3) row(1) lab(1 "DV: Core values") lab(3 "DV: Partisanship") region(lc(white))) ///
 	scheme(s1mono) col(1)  xsize(6) ysize(9) /// 
 	name(coef_stable91, replace)

 
graph combine  coef_cross91  coef_stable91, scheme(s1mono) cols(1) xsize(6) ysize(9) ///
title("Period: 1991-1995")  ///
 name(coef_1991, replace)
	graph export "Coef_CONS_1991-95.png", width(1000) replace
	
	
	* Period: 1997-2007: CONSISTENCY
*replace direction = direction + 0.2 if dv ==2

twoway bar coef direction if same==1 & dv==1 & type==1 & time==2, barw(0.2) bc(black)  || ///
rcap ci_up ci_low direction if same==1 & dv==1 & type==1 & time==2 || ///
bar coef direction if same==1 & dv==2 & type==1 & time==2, barw(0.2)  || ///
rcap ci_up ci_low direction if same==1 & dv==2 & type==1 & time==2, ///
title("Estimated cross-lagged effects") ///
ylabel(-0.5(1)6.5) ///
 ytitle("Estimated Coefficients""(Incl. 95% C.I.)", size(medlarge)) yline(0) xlabel(1(1)3, valuelabel)  xtitle("") ///
 legend( off) ///
 	scheme(s1mono) col(1)  xsize(6) ysize(9) /// 
 	name(coef_cross97, replace)
 	
 	
 	twoway bar coef direction if same==1 & dv==1 & type==0 & time==2, barw(0.2) bc(black) || ///
rcap ci_up ci_low direction if same==1 & dv==1 & type==0 & time==2 || ///
bar coef direction if same==1 & dv==2 & type==0 & time==2, barw(0.2)  || ///
rcap ci_up ci_low direction if same==1 & dv==2 & type==0 & time==2, ///
title("Estimated stability coef.") ///
ylabel(-0.5(1)6.5) ///
 ytitle("Estimated Coefficients""(Incl. 95% C.I.)", size(medlarge)) yline(0) xlabel(1(1)3, valuelabel)  xtitle("") ///
 legend( order(1 3) row(1) lab(1 "DV: Core values") lab(3 "DV: Partisanship") region(lc(white))) ///
 	scheme(s1mono) col(1)  xsize(6) ysize(9) /// 
 	name(coef_stable97, replace)

 
graph combine  coef_cross97 coef_stable97, scheme(s1mono) cols(1) xsize(6) ysize(9) ///
title("Period: 1997-2007")  ///
 name(coef_1997, replace)
	graph export "Coef_CONS_1997-07.png", width(1000) replace

** Combine both time periods

graph combine coef_1991  coef_1997, scheme(s1mono) cols(2) xsize(9) ysize(6) ///
 name(coef_Combine, replace)
	graph export "Coef_CONS_Combine.png", width(1000) replace
	
*-----------------------------------------------------------------------------
*----- New period graphs

*clear all
*save "Data_coef_period.dta", replace
use "Data_coef_period.dta", clear


*drop same
gen same_ideo =0
replace same_ideo =1 if ideol==party1 

gen same_pid =0
replace same_pid =1 if ideol1==party

gen same_stab_ideo =0
replace same_stab_ideo =1 if ideol==ideol1 

gen same_stab_pid =0
replace same_stab_pid =1 if party1==party
** Labels

label def partylbl1 2 "None" 1 "Tories" 3 "Labour"
label value party1 partylbl1
label value party partylbl1
tab party1

label def ideolbl 1 "Rightist" 2 "Centrist" 3 "Leftist"
label value ideol1 ideolbl
label value ideol ideolbl
tab ideol1


*replace direction = direction + 0.2 if time ==2
replace party1 = party1 + 0.2 if time ==2
replace ideol1 = ideol1 + 0.2 if time ==2

** cross-lagged effects
twoway bar coef party1 if same_ideo==1 & time==1, barw(0.2) bc(black)  || ///
rcap ci_up ci_low party1 if same_ideo==1  & time==1 || ///
bar coef party1 if same_ideo==1 & time==2, barw(0.2) || ///
rcap ci_up ci_low party1 if same_ideo==1 & time==2 , ///
title("DV: Core values") ///
ylabel(-0.8(0.4)1.6) ///
 ytitle("Estimated Coefficients""(Incl. 95% C.I.)", size(medlarge)) yline(0) ///
 xlabel(1(1)3, valuelabel)  xtitle("Partisanship (t-1)") ///
 legend( off) ///
 	scheme(s1mono) col(1)  xsize(6) ysize(9) /// s
 	name(coef_cross_val, replace)
	
twoway bar coef ideol1 if same_pid==1 & time==1, barw(0.2) bc(black)  || ///
rcap ci_up ci_low ideol1 if same_pid==1  & time==1 || ///
bar coef ideol1 if same_pid==1 & time==2, barw(0.2) || ///
rcap ci_up ci_low ideol1 if same_pid==1 & time==2 , ///
title("DV: Partisanship") ///
ylabel(-0.8(0.4)1.6) ///
 ytitle("Estimated Coefficients""(Incl. 95% C.I.)", size(medlarge)) yline(0) ///
 xlabel(1(1)3, valuelabel)  xtitle("Core values (t-1)") ///
 	scheme(s1mono) col(1)  xsize(6) ysize(9) /// 
	 legend( order(1 3) row(1) lab(1 "1991-1995") lab(3 "1997-2007") region(lc(white))) ///
name(coef_cross_pid, replace)
 
 
 graph combine  coef_cross_val coef_cross_pid, scheme(s1mono) cols(1) xsize(6) ysize(9) ///
title("Estimated cross-lagged effects")  ///
 name(coef_cross, replace)
 
 
* Stability 
twoway bar coef ideol1 if same_stab_ideo==1 & time==1, barw(0.2) bc(black)  || ///
rcap ci_up ci_low ideol1 if same_stab_ideo==1  & time==1 || ///
bar coef ideol1 if same_stab_ideo==1 & time==2, barw(0.2) || ///
rcap ci_up ci_low ideol1 if same_stab_ideo==1 & time==2 , ///
title("DV: Core values") ///
ylabel(0(1)7) ///
 ytitle("Estimated Coefficients""(Incl. 95% C.I.)", size(medlarge)) yline(0) ///
 xlabel(1(1)3, valuelabel)  xtitle("Core values (t-1)") ///
 legend( off) ///
 	scheme(s1mono) col(1)  xsize(6) ysize(9) /// s
 	name(coef_stable_val, replace)
	
twoway bar coef party1 if same_stab_pid==1 & time==1, barw(0.2) bc(black)  || ///
rcap ci_up ci_low party1 if same_stab_pid==1  & time==1 || ///
bar coef party1 if same_stab_pid==1 & time==2, barw(0.2) || ///
rcap ci_up ci_low party1 if same_stab_pid==1 & time==2 , ///
title("DV: Partisanship") ///
ylabel(0(1)7) ///
 ytitle("Estimated Coefficients""(Incl. 95% C.I.)", size(medlarge)) yline(0) xlabel(1(1)3, valuelabel) ///
 xtitle("Partisanship (t-1)") ///
	 legend( order(1 3) row(1) lab(1 "1991-1995") lab(3 "1997-2007") region(lc(white))) ///
 	scheme(s1mono) col(1)  xsize(6) ysize(9) /// 
 	name(coef_stable_pid, replace)
 
 
 graph combine  coef_stable_val coef_stable_pid, scheme(s1mono) cols(1) xsize(6) ysize(9) ///
title("Estimated stability coef.")  ///
 name(coef_stable, replace)
 
 ** Combine both time periods

graph combine coef_cross  coef_stable, scheme(s1mono) cols(2) xsize(9) ysize(6) 
	graph export "Coef_period.png", width(1000) replace
	

	****----------------AGE CONDITIONAL -------------------------		
*** Figure of CMP data and Coeffients: Issue-based partisan updating
clear all
save "Data_coef_age.dta", replace
use "Data_coef_age.dta", clear

** Labels


/* Education
Ideo	
1	centre
2	right
3	left
	
	
PID	
1	Labour
2	Tory
3	none
*/

recode party1 (1=3) (2=1) (3=2)
recode ideo1 (1=2) (2=1) (3=3)

*drop same
gen same =0
replace same =1 if ideo1==direction 

gen same_ideo =0
replace same_ideo =1 if ideo1==direction 

gen same_pid =0
replace same_pid =1 if party1==direction 

label def partylbl_educ 2 "None" 1 "Tories" 3 "Labour"
label value party1 partylbl_educ
tab party1

label def ideolbl_educ 1 "Rightist" 2 "Centrist" 3 "Leftist"
label value ideo1 ideolbl_educ
tab ideo1

*lab def dirlbl1 1 "Right/Tories" 2 "Cent/None" 3 "Left/Labour"
lab val direction dirlbl1

*lab def typlbl 1"Cross-lagged coef." 0 "Stability coef."
lab val type typlbl

*lab def dvlbl 1"DV: Ideology" 2"DV: Partisanship"
lab val dv dvlbl



* Period: 1991-2007: Education conditional
rename age educ
replace educ = educ + 2 if dv ==2

* cross-lagged: Right/Tories
twoway bar coef educ if same==1 & dv==1 & type==1 & direction ==1, barw(2) bc(black)  || ///
rcap ci_up ci_low educ if same==1 & dv==1 & type==1 & direction ==1 || ///
bar coef educ if same==1 & dv==2 & type==1 & direction ==1 , barw(2)  || ///
rcap ci_up ci_low educ if same==1 & dv==2  & type==1 & direction ==1, ///
title("Cross-lagged effects:" "Right values & Conservative PID") ///
ylabel(-1.5(2)5.5) ///
 ytitle("Estimated Coefficients""(Incl. 95% C.I.)", size(medsmall)) yline(0) xlabel(15(10)65, valuelabel)  xtitle("Age") ///
 legend( off) ///
 	scheme(s1mono) col(1)  xsize(6) ysize(9) /// 
 	name(coef_cross_educ_right, replace)
 	
* Cross-lagged: Left/Labour 
 twoway bar coef educ if same==1 & dv==1 & type==1 & direction ==3, barw(2) bc(black)  || ///
rcap ci_up ci_low educ if same==1 & dv==1 & type==1 & direction ==3 || ///
bar coef educ if same==1 & dv==2 & type==1 & direction ==3 , barw(2)  || ///
rcap ci_up ci_low educ if same==1 & dv==2  & type==1 & direction ==3, ///
title("Cross-lagged effects:" "Left values & Labour PID") ///
ylabel(-1.5(2)5.5) ///
 ytitle("Estimated Coefficients""(Incl. 95% C.I.)", size(medsmall)) yline(0) xlabel(15(10)65, valuelabel)  xtitle("Age") ///
 legend( off) ///
 	scheme(s1mono) col(1)  xsize(6) ysize(9) /// 
 	name(coef_cross_educ_left, replace)	


* STABILITY: Right 	
twoway bar coef educ if same==1 & dv==1 & type==0 & direction ==1, barw(2) bc(black)  || ///
rcap ci_up ci_low educ if same==1 & dv==1 & type==0 & direction ==1 || ///
bar coef educ if same==1 & dv==2 & type==0 & direction ==1 , barw(2)  || ///
rcap ci_up ci_low educ if same==1 & dv==2  & type==0 & direction ==1, ///
title("Stability Coef.:" "Right values & Conservative PID") ///
ylabel(-1.5(2)5.5) ///
 ytitle("Estimated Coefficients""(Incl. 95% C.I.)", size(medsmall)) yline(0) xlabel(15(10)65, valuelabel)  xtitle("Age") ///
 legend( order(1 3) row(1) lab(1 "DV: Core values") lab(3 "DV: Partisanship") region(lc(white))) ///
 	scheme(s1mono) col(1)  xsize(6) ysize(9) /// 
 	name(coef_stab_educ_right, replace)
 	
* Stability: Left/Labour 
twoway bar coef educ if same==1 & dv==1 & type==0 & direction ==3, barw(2) bc(black)  || ///
rcap ci_up ci_low educ if same==1 & dv==1 & type==0 & direction ==3 || ///
bar coef educ if same_pid==1 & dv==2 & type==0 & direction ==3 , barw(2)  || ///
rcap ci_up ci_low educ if same_pid==1 & dv==2  & type==0 & direction ==3, ///
title("Stability Coef.:" "Left values & Labour PID") ///
ylabel(-1.5(2)5.5) ///
 ytitle("Estimated Coefficients""(Incl. 95% C.I.)", size(medsmall)) yline(0) xlabel(15(10)65, valuelabel)  xtitle("Age") ///
 legend( order(1 3) row(1) lab(1 "DV: Core values") lab(3 "DV: Partisanship") region(lc(white))) ///
 	scheme(s1mono) col(1)  xsize(6) ysize(9) /// 
 	name(coef_stab_educ_left, replace)	


 
graph combine  coef_cross_educ_left coef_cross_educ_right coef_stab_educ_left  coef_stab_educ_right , ///
scheme(s1mono) cols(2) xsize(8) ysize(6)
*title("Ideological/Partisan Consistency")  ///
	graph export "Coef_Age.png", width(1000) replace
		
****----------------EDUCATION CONDITIONAL -------------------------		
*** Figure of CMP data and Coeffients: Issue-based partisan updating

save "Data_coef_educ.dta", replace
use "Data_coef_educ.dta", clear

** Labels


/* Education
Ideo	  
1	left
2	centre
3	right
PID	
1	None
2	Labour
3	Tory		

*/

recode party1 (1=2) (2=3) (3=1)
recode ideo1 (1=3) (2=2) (3=1)

*drop same
gen same =0
replace same =1 if ideo1==direction 

gen same_ideo =0
replace same_ideo =1 if ideo1==direction 

gen same_pid =0
replace same_pid =1 if party1==direction 

label def partylbl_educ 2 "None" 1 "Tories" 3 "Labour"
label value party1 partylbl_educ
tab party1

label def ideolbl_educ 1 "Rightist" 2 "Centrist" 3 "Leftist"
label value ideo1 ideolbl_educ
tab ideo1

*lab def dirlbl1 1 "Right/Tories" 2 "Cent/None" 3 "Left/Labour"
lab val direction dirlbl1

*lab def typlbl 1"Cross-lagged coef." 0 "Stability coef."
lab val type typlbl

*lab def dvlbl 1"DV: Ideology" 2"DV: Partisanship"
lab val dv dvlbl

lab def educlbl1 1"No qual" 6"Degree"
lab val educ educlbl1

* Period: 1991-2007: Education conditional
replace educ = educ + 0.2 if dv ==2

* cross-lagged: Right/Tories
twoway bar coef educ if same==1 & dv==1 & type==1 & direction ==1, barw(0.2) bc(black)  || ///
rcap ci_up ci_low educ if same==1 & dv==1 & type==1 & direction ==1 || ///
bar coef educ if same==1 & dv==2 & type==1 & direction ==1 , barw(0.2)  || ///
rcap ci_up ci_low educ if same==1 & dv==2  & type==1 & direction ==1, ///
title("Cross-lagged effects:" "Right values & Conservative PID") ///
ylabel(-1.5(2)5.5) ///
 ytitle("Estimated Coefficients""(Incl. 95% C.I.)", size(medsmall)) yline(0) xlabel(1(1)6, valuelabel)  xtitle("Education") ///
 legend( off) ///
 	scheme(s1mono) col(1)  xsize(6) ysize(9) /// 
 	name(coef_cross_educ_right, replace)
 	
* Cross-lagged: Left/Labour 
 twoway bar coef educ if same==1 & dv==1 & type==1 & direction ==3, barw(0.2) bc(black)  || ///
rcap ci_up ci_low educ if same==1 & dv==1 & type==1 & direction ==3 || ///
bar coef educ if same==1 & dv==2 & type==1 & direction ==3 , barw(0.2)  || ///
rcap ci_up ci_low educ if same==1 & dv==2  & type==1 & direction ==3, ///
title("Cross-lagged effects:" "Left values & Labour PID") ///
ylabel(-1.5(2)5.5) ///
 ytitle("Estimated Coefficients""(Incl. 95% C.I.)", size(medsmall)) yline(0) xlabel(1(1)6, valuelabel)  xtitle("Education") ///
 legend( off) ///
 	scheme(s1mono) col(1)  xsize(6) ysize(9) /// 
 	name(coef_cross_educ_left, replace)	


* STABILITY: Right 	
twoway bar coef educ if same==1 & dv==1 & type==0 & direction ==1, barw(0.2) bc(black)  || ///
rcap ci_up ci_low educ if same==1 & dv==1 & type==0 & direction ==1 || ///
bar coef educ if same==1 & dv==2 & type==0 & direction ==1 , barw(0.2)  || ///
rcap ci_up ci_low educ if same==1 & dv==2  & type==0 & direction ==1, ///
title("Stability Coef.:" "Right values & Conservative PID") ///
ylabel(-1.5(2)5.5) ///
 ytitle("Estimated Coefficients""(Incl. 95% C.I.)", size(medsmall)) yline(0) xlabel(1(1)6, valuelabel)  xtitle("Education") ///
 legend( order(1 3) row(1) lab(1 "DV: Core values") lab(3 "DV: Partisanship") region(lc(white))) ///
 	scheme(s1mono) col(1)  xsize(6) ysize(9) /// 
 	name(coef_stab_educ_right, replace)
 	
* Stability: Left/Labour 
twoway bar coef educ if same==1 & dv==1 & type==0 & direction ==3, barw(0.2) bc(black)  || ///
rcap ci_up ci_low educ if same==1 & dv==1 & type==0 & direction ==3 || ///
bar coef educ if same_pid==1 & dv==2 & type==0 & direction ==3 , barw(0.2)  || ///
rcap ci_up ci_low educ if same_pid==1 & dv==2  & type==0 & direction ==3, ///
title("Stability Coef.:" "Left values & Labour PID") ///
ylabel(-1.5(2)5.5) ///
 ytitle("Estimated Coefficients""(Incl. 95% C.I.)", size(medsmall)) yline(0) xlabel(1(1)6, valuelabel)  xtitle("Education") ///
 legend( order(1 3) row(1) lab(1 "DV: Core values") lab(3 "DV: Partisanship") region(lc(white))) ///
 	scheme(s1mono) col(1)  xsize(6) ysize(9) /// 
 	name(coef_stab_educ_left, replace)	


 
graph combine  coef_cross_educ_left coef_cross_educ_right coef_stab_educ_left  coef_stab_educ_right , ///
scheme(s1mono) cols(2) xsize(8) ysize(6) ///
name(coef_education, replace)
*title("Ideological/Partisan Consistency")  ///
	graph export "Coef_Education.png", width(1000) replace

	
	
****----------------SOC CLASS CONDITIONAL -------------------------		
*** Figure of CMP data and Coeffients: Issue-based partisan updating
clear all

save "Data_coef_socclass.dta", replace
use "Data_coef_socclass.dta", clear

** Labels


/* Soc Class
Ideo	
1	centre
2	left
3	right	
PID	
1	Tories
2	None
3	Labour
*/


recode party1 (1=1) (2=2) (3=3)
recode ideo1 (1=2) (2=3) (3=1)

*drop same
gen same =0
replace same =1 if ideo1==direction 

gen same_ideo =0
replace same_ideo =1 if ideo1==direction 

gen same_pid =0
replace same_pid =1 if party1==direction 

label def partylbl_educ 2 "None" 1 "Tories" 3 "Labour"
label value party1 partylbl_educ
tab party1

label def ideolbl_educ 1 "Rightist" 2 "Centrist" 3 "Leftist"
label value ideo1 ideolbl_educ
tab ideo1

*lab def dirlbl1 1 "Right/Tories" 2 "Cent/None" 3 "Left/Labour"
lab val direction dirlbl1

*lab def typlbl 1"Cross-lagged coef." 0 "Stability coef."
lab val type typlbl

*lab def dvlbl 1"DV: Ideology" 2"DV: Partisanship"
lab val dv dvlbl


drop if education ==4
recode educ (5=4) (6=5)
lab def classlbl6 2"Interm." 3"Self-empl." 4"Techn." 5"Man. workers" 1 "Service"
*lab def classlbl1  5"Manual workers" 1 "Service"
lab val education classlbl6

* Period: 1991-2007: Education conditional
replace educ = educ + 0.2 if dv ==2

* cross-lagged: Right/Tories
twoway bar coef educ if same==1 & dv==1 & type==1 & direction ==1, barw(0.2) bc(black)  || ///
rcap ci_up ci_low educ if same==1 & dv==1 & type==1 & direction ==1 || ///
bar coef educ if same==1 & dv==2 & type==1 & direction ==1 , barw(0.2)  || ///
rcap ci_up ci_low educ if same==1 & dv==2  & type==1 & direction ==1, ///
title("Cross-lagged effects:" "Right values & Conservative PID") ///
ylabel(-1.5(2)5.5) ///
 ytitle("Estimated Coefficients""(Incl. 95% C.I.)", size(medsmall)) yline(0) xlabel(1(1)5, valuelabel)  xtitle("Social Class") ///
 legend( off) ///
 	scheme(s1mono) col(1)  xsize(6) ysize(9) /// 
 	name(coef_cross_educ_right, replace)
 	
* Cross-lagged: Left/Labour 
 twoway bar coef educ if same==1 & dv==1 & type==1 & direction ==3, barw(0.2) bc(black)  || ///
rcap ci_up ci_low educ if same==1 & dv==1 & type==1 & direction ==3 || ///
bar coef educ if same==1 & dv==2 & type==1 & direction ==3 , barw(0.2)  || ///
rcap ci_up ci_low educ if same==1 & dv==2  & type==1 & direction ==3, ///
title("Cross-lagged effects:" "Left values & Labour PID") ///
ylabel(-1.5(2)5.5) ///
 ytitle("Estimated Coefficients""(Incl. 95% C.I.)", size(medsmall)) yline(0) xlabel(1(1)5, valuelabel)  xtitle("Social Class") ///
 legend( off) ///
 	scheme(s1mono) col(1)  xsize(6) ysize(9) /// 
 	name(coef_cross_educ_left, replace)	


* STABILITY: Right 	
twoway bar coef educ if same==1 & dv==1 & type==0 & direction ==1, barw(0.2) bc(black)  || ///
rcap ci_up ci_low educ if same==1 & dv==1 & type==0 & direction ==1 || ///
bar coef educ if same_pid==1 & dv==2 & type==0 & direction ==1 , barw(0.2)  || ///
rcap ci_up ci_low educ if same_pid==1 & dv==2  & type==0 & direction ==1, ///
title("Stability Coef.:" "Right values & Conservative PID") ///
ylabel(-1.5(2)5.5) ///
 ytitle("Estimated Coefficients""(Incl. 95% C.I.)", size(medsmall)) yline(0) xlabel(1(1)5, valuelabel)  xtitle("Social Class") ///
 legend( order(1 3) row(1) lab(1 "DV: Core values") lab(3 "DV: Partisanship") region(lc(white))) ///
 	scheme(s1mono) col(1)  xsize(6) ysize(9) /// 
 	name(coef_stab_educ_right, replace)
 	
* Stability: Left/Labour 
twoway bar coef educ if same==1 & dv==1 & type==0 & direction ==3, barw(0.2) bc(black)  || ///
rcap ci_up ci_low educ if same==1 & dv==1 & type==0 & direction ==3 || ///
bar coef educ if same_pid==1 & dv==2 & type==0 & direction ==3 , barw(0.2)  || ///
rcap ci_up ci_low educ if same_pid==1 & dv==2  & type==0 & direction ==3, ///
title("Stability Coef.:" "Left values & Labour PID") ///
ylabel(-1.5(2)5.5) ///
 ytitle("Estimated Coefficients""(Incl. 95% C.I.)", size(medsmall)) yline(0) xlabel(1(1)5, valuelabel)  xtitle("Social Class") ///
 legend( order(1 3) row(1) lab(1 "DV: Core values") lab(3 "DV: Partisanship") region(lc(white))) ///
 	scheme(s1mono) col(1)  xsize(6) ysize(9) /// 
 	name(coef_stab_educ_left, replace)	


 
graph combine   coef_cross_educ_left coef_cross_educ_right  coef_stab_educ_left coef_stab_educ_right, ///
scheme(s1mono) cols(2) xsize(8) ysize(6) ///
name(coef_education, replace)
*title("Ideological/Partisan Consistency")  ///
	graph export "Coef_Socclass.png", width(1000) replace
	
	
	
	****----------------INCOME CONDITIONAL -------------------------		
*** Figure of CMP data and Coeffients: Issue-based partisan updating
clear all

save "Data_coef_income.dta", replace
use "Data_coef_income.dta", clear

** Labels of latent classes
/* Income
Ideo	
1	right 
2	centre
3	left
PID	
1	Labour
2	None
3	Tories
*/


recode ideo1  (1=1) (2=2) (3=3)
recode party1 (1=3) (2=2) (3=1)

*drop same
gen same =0
replace same =1 if ideo1==direction 

gen same_ideo =0
replace same_ideo =1 if ideo1==direction 

gen same_pid =0
replace same_pid =1 if party1==direction 

label def partylbl_educ 2 "None" 1 "Tories" 3 "Labour"
label value party1 partylbl_educ
tab party1

label def ideolbl_educ 1 "Rightist" 2 "Centrist" 3 "Leftist"
label value ideo1 ideolbl_educ
tab ideo1

*lab def dirlbl1 1 "Right/Tories" 2 "Cent/None" 3 "Left/Labour"
lab val direction dirlbl1

*lab def typlbl 1"Cross-lagged coef." 0 "Stability coef."
lab val type typlbl

*lab def dvlbl 1"DV: Ideology" 2"DV: Partisanship"
lab val dv dvlbl


lab def inclbl 1 "Bottom-20%" 5"Top-20%"
lab val education inclbl

* Period: 1991-2007: Education conditional
replace educ = educ + 0.2 if dv ==2

* cross-lagged: Right/Tories
twoway bar coef educ if same==1 & dv==1 & type==1 & direction ==1, barw(0.2) bc(black)  || ///
rcap ci_up ci_low educ if same==1 & dv==1 & type==1 & direction ==1 || ///
bar coef educ if same==1 & dv==2 & type==1 & direction ==1 , barw(0.2)  || ///
rcap ci_up ci_low educ if same==1 & dv==2  & type==1 & direction ==1, ///
title("Cross-lagged effects:" "Right values & Conservative PID") ///
ylabel(-1.5(2)5.5) ///
 ytitle("Estimated Coefficients""(Incl. 95% C.I.)", size(medsmall)) yline(0) xlabel(1(1)5, valuelabel)  xtitle("Income quintiles") ///
 legend( off) ///
 	scheme(s1mono) col(1)  xsize(6) ysize(9) /// 
 	name(coef_cross_educ_right, replace)
 	
* Cross-lagged: Left/Labour 
 twoway bar coef educ if same==1 & dv==1 & type==1 & direction ==3, barw(0.2) bc(black)  || ///
rcap ci_up ci_low educ if same==1 & dv==1 & type==1 & direction ==3 || ///
bar coef educ if same==1 & dv==2 & type==1 & direction ==3 , barw(0.2)  || ///
rcap ci_up ci_low educ if same==1 & dv==2  & type==1 & direction ==3, ///
title("Cross-lagged effects:" "Left values & Labour PID") ///
ylabel(-1.5(2)5.5) ///
 ytitle("Estimated Coefficients""(Incl. 95% C.I.)", size(medsmall)) yline(0) xlabel(1(1)5, valuelabel)  xtitle("Income quintiles") ///
 legend( off) ///
 	scheme(s1mono) col(1)  xsize(6) ysize(9) /// 
 	name(coef_cross_educ_left, replace)	


* STABILITY: Right 	
twoway bar coef educ if same==1 & dv==1 & type==0 & direction ==1, barw(0.2) bc(black)  || ///
rcap ci_up ci_low educ if same==1 & dv==1 & type==0 & direction ==1 || ///
bar coef educ if same_pid==1 & dv==2 & type==0 & direction ==1 , barw(0.2)  || ///
rcap ci_up ci_low educ if same_pid==1 & dv==2  & type==0 & direction ==1, ///
title("Stability Coef.:" "Right values & Conservative PID") ///
ylabel(-1.5(2)5.5) ///
 ytitle("Estimated Coefficients""(Incl. 95% C.I.)", size(medsmall)) yline(0) xlabel(1(1)5, valuelabel)  xtitle("Income quintiles") ///
 legend( order(1 3) row(1) lab(1 "DV: Core values") lab(3 "DV: Partisanship") region(lc(white))) ///
 	scheme(s1mono) col(1)  xsize(6) ysize(9) /// 
 	name(coef_stab_educ_right, replace)
 	
* Stability: Left/Labour 
twoway bar coef educ if same==1 & dv==1 & type==0 & direction ==3, barw(0.2) bc(black)  || ///
rcap ci_up ci_low educ if same==1 & dv==1 & type==0 & direction ==3 || ///
bar coef educ if same_pid==1 & dv==2 & type==0 & direction ==3 , barw(0.2)  || ///
rcap ci_up ci_low educ if same_pid==1 & dv==2  & type==0 & direction ==3, ///
title("Stability Coef.:" "Left values & Labour PID") ///
ylabel(-1.5(2)5.5) ///
 ytitle("Estimated Coefficients""(Incl. 95% C.I.)", size(medsmall)) yline(0) xlabel(1(1)5, valuelabel)  xtitle("Income quintiles") ///
 legend( order(1 3) row(1) lab(1 "DV: Core values") lab(3 "DV: Partisanship") region(lc(white))) ///
 	scheme(s1mono) col(1)  xsize(6) ysize(9) /// 
 	name(coef_stab_educ_left, replace)	


 
graph combine   coef_cross_educ_left coef_cross_educ_right  coef_stab_educ_left coef_stab_educ_right, ///
scheme(s1mono) cols(2) xsize(8) ysize(6) ///
name(coef_education, replace)
*title("Ideological/Partisan Consistency")  ///
	graph export "Coef_Income.png", width(1000) replace


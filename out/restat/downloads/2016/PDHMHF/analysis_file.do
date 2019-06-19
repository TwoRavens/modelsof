log using "log_analysis_final_do.smcl", replace

clear all
set more off
pause on
program drop _all
set matsize 800


use "dyad_ready"




egen nightcombo=group(x_night y_night)


set more off


/********** Table 4: Main effect of Treatment on Collaboration**********/


** column 1 **
set more off
xi: ngreg any_coapplicant same_room if same_night==1 , id(x_participant_id y_participant_id) symmetric group(nightcombo)
estimates save dyad0.ster, replace

** column 2 **

xi: ngreg any_coapplicant same_room dum_1 dum_2 if same_night==1 , id(x_participant_id y_participant_id) symmetric group(nightcombo)
estimates save dyad1.ster, replace

** column 3 **

xi: ngreg any_coapplicant same_room onepostdoc bothpostdoc one_female both_female same_inst both_longwood one_imager both_imager ///
same_clinicalarea previouscoauthor dum_1 dum_2 if same_night==1  , id(x_participant_id y_participant_id) symmetric group(nightcombo)
estimates save dyad2.ster, replace

***table
estimates drop _all
forvalues n=0(1)2 { 
estimates use dyad`n'.ster
eststo
}


#delimit ;
esttab *, keep(same_room onepostdoc bothpostdoc one_female both_female same_inst both_longwood one_imager both_imager ///
same_clinicalarea previouscoauthor _cons)
varwidth(25) nonumber noobs nogaps nodep label b(%5.4f) se(%5.4f) star(+ 0.10 * 0.05 ** 0.01) 
compress scalars("r2 R2"  "N Nb. of Obs.") sfmt(%10.3fc %10.0fc)
mlabels("(1)" "(2)" "(3)" "(4)" "(5)")  
indicate("Night fixed effects =dum_1")
eqlabels(none);

esttab * using dyad_regs_main.rtf, keep(same_room onepostdoc bothpostdoc one_female both_female same_inst both_longwood one_imager both_imager ///
same_clinicalarea previouscoauthor  _cons)
varwidth(25) nonumber noobs nogaps nodep label b(%5.4f) se(%5.4f) star(+ 0.10 * 0.05 ** 0.01) 
compress scalars("r2 R2"  "N Nb. of Obs.") sfmt(%10.3fc %10.0fc)
mlabels("(1)" "(2)" "(3)" "(4)" "(5)")  
indicate("Night fixed effects =dum_1") 
eqlabels(none) replace;

#delimit cr


/********** Table A2. Main effect of Treatment on Collaboration – Estimated with Probit **********/


probit any_coapplicant same_room if same_night==1 , r 
estpost margins, dydx(*)
estimates save p_dyad0.ster, replace

** Main table column 2 **

probit any_coapplicant same_room dum_1 dum_2 if same_night==1 , r
estpost margins, dydx(*)
estimates save p_dyad1.ster, replace

** Main table column 3 **

xi: probit any_coapplicant same_room onepostdoc bothpostdoc one_female both_female same_inst both_longwood one_imager both_imager ///
same_clinicalarea previouscoauthor dum_1 dum_2 if same_night==1  , r
estpost margins, dydx(*)
estimates save p_dyad2.ster, replace


estimates drop _all
forvalues n=0(1)2 { 
estimates use p_dyad`n'.ster
eststo
}

#delimit ;

esttab *, keep(same_room onepostdoc bothpostdoc one_female both_female same_inst both_longwood one_imager both_imager ///
same_clinicalarea previouscoauthor  )
varwidth(25) nonumber noobs nogaps nodep label b(%5.4f) se(%5.4f) star(+ 0.10 * 0.05 ** 0.01) 
compress scalars("r2 R2"  "N Nb. of Obs.") sfmt(%10.3fc %10.0fc)
mlabels("(1)" "(2)" "(3)" "(4)" "(5)")  
indicate("Night fixed effects =dum_1") 
eqlabels(none) replace;

esttab * using dyad_regs_main.rtf, keep(same_room onepostdoc bothpostdoc one_female both_female same_inst both_longwood one_imager both_imager ///
same_clinicalarea previouscoauthor  )
varwidth(25) nonumber noobs nogaps nodep label b(%5.4f) se(%5.4f) star(+ 0.10 * 0.05 ** 0.01) 
compress scalars("r2 R2"  "N Nb. of Obs.") sfmt(%10.3fc %10.0fc)
mlabels("(1)" "(2)" "(3)" "(4)" "(5)")  
indicate("Night fixed effects =dum_1") 
eqlabels(none) replace;

#delimit cr


/************* Table 5. Treatment and Interactions with Measures of Distance **************************/


eststo clear

ngreg any_coapplicant same_room dum_1 dum_2 onepostdoc same_room_X_onepostdoc bothpostdoc same_room_X_bothpostdoc ///
if same_night==1 , id(x_participant_id y_participant_id) symmetric group(nightcombo) 
estimates save dyad_interactparts1.ster, replace
eststo

ngreg any_coapplicant same_room dum_1 dum_2 one_female same_room_X_one_female both_female same_room_X_both_female ///
if same_night==1 , id(x_participant_id y_participant_id) symmetric group(nightcombo) 
estimates save dyad_interactparts2.ster, replace
eststo

ngreg any_coapplicant same_room dum_1 dum_2 same_inst same_room_X_same_inst ///
if same_night==1 ,  id(x_participant_id y_participant_id) symmetric group(nightcombo) 
estimates save dyad_interactparts3.ster, replace
eststo

ngreg any_coapplicant same_room dum_1 dum_2 both_longwood same_room_X_both_longwood ///
if same_night==1 ,  id(x_participant_id y_participant_id) symmetric group(nightcombo)
estimates save dyad_interactparts4.ster, replace
eststo

ngreg any_coapplicant same_room dum_1 dum_2 one_imager same_room_X_one_imager both_imager same_room_X_both_imager ///
if same_night==1 ,  id(x_participant_id y_participant_id) symmetric group(nightcombo) 
estimates save dyad_interactparts5.ster, replace
eststo

ngreg any_coapplicant same_room dum_1 dum_2 same_clinicalarea same_room_X_same_clinicalarea ///
if same_night==1 ,  id(x_participant_id y_participant_id) symmetric group(nightcombo) 
estimates save dyad_interactparts6.ster, replace
eststo

ngreg any_coapplicant same_room dum_1 dum_2 previouscoauthor same_room_X_previouscoau ///
if same_night==1 ,   id(x_participant_id y_participant_id) symmetric group(nightcombo)
estimates save dyad_interactparts7.ster, replace
eststo

ngreg any_coapplicant same_room dum_1 dum_2 onepostdoc same_room_X_onepostdoc bothpostdoc same_room_X_bothpostdoc ///
one_female same_room_X_one_female both_female same_room_X_both_female ///
same_inst same_room_X_same_inst both_longwood same_room_X_both_longwood ///
one_imager same_room_X_one_imager both_imager same_room_X_both_imager same_clinicalarea same_room_X_same_clinicalarea ///
previouscoauthor same_room_X_previouscoau ///
if same_night==1 , id(x_participant_id y_participant_id) symmetric group(nightcombo)
estimates save dyad_interactpartsall.ster, replace
eststo


#delimit ;

esttab * /*using dyad_regs_interactparts.rtf*/,  keep(same_room onepostdoc same_room_X_onepostdoc bothpostdoc same_room_X_bothpostdoc ///
one_female same_room_X_one_female both_female same_room_X_both_female ///
same_inst same_room_X_same_inst both_longwood same_room_X_both_longwood ////
one_imager same_room_X_one_imager both_imager same_room_X_both_imager same_clinicalarea same_room_X_same_clinicalarea ///
previouscoauthor same_room_X_previouscoau  /* _cons*/)
varwidth(25) modelwidth(5) nonumber noobs nogaps nodep label b(%5.4f) se(%5.4f) star(+ 0.10 * 0.05 ** 0.01) 
compress scalars("r2 R2"  "N Nb. of Obs.") sfmt(%10.3fc %10.0fc) 
mlabels("(1)" "(2)" "(3)" "(4)" "(5)" "(6)" "(7)" "(8)")  
indicate("Night fixed effects =dum_1") 
eqlabels(none) replace;

#delimit cr



/*************  Table A3. Treatment and Interactions with Measures of Distance – Estimated with Probit **************************/



probit any_coapplicant same_room dum_1 dum_2 onepostdoc same_room_X_onepostdoc bothpostdoc same_room_X_bothpostdoc ///
if same_night==1 , r 
estpost margins, dydx(*)
estimates save pdyad_interactparts1.ster, replace

probit any_coapplicant same_room dum_1 dum_2 one_female same_room_X_one_female both_female same_room_X_both_female ///
if same_night==1 , r 
estpost margins, dydx(*)
estimates save pdyad_interactparts2.ster, replace

probit any_coapplicant same_room dum_1 dum_2 same_inst same_room_X_same_inst ///
if same_night==1 , r 
estpost margins, dydx(*)
estimates save pdyad_interactparts3.ster, replace

probit any_coapplicant same_room dum_1 dum_2 both_longwood same_room_X_both_longwood ///
if same_night==1 , r 
estpost margins, dydx(*)
estimates save pdyad_interactparts4.ster, replace

probit any_coapplicant same_room dum_1 dum_2 one_imager same_room_X_one_imager both_imager same_room_X_both_imager ///
if same_night==1 , r 
estpost margins, dydx(*)
estimates save pdyad_interactparts5.ster, replace

probit any_coapplicant same_room dum_1 dum_2 same_clinicalarea same_room_X_same_clinicalarea ///
if same_night==1 , r 
estpost margins, dydx(*)
estimates save pdyad_interactparts6.ster, replace

probit any_coapplicant same_room dum_1 dum_2 previouscoauthor same_room_X_previouscoau ///
if same_night==1 , r 
estpost margins, dydx(*)
estimates save pdyad_interactparts7.ster, replace

probit any_coapplicant same_room dum_1 dum_2 onepostdoc same_room_X_onepostdoc bothpostdoc same_room_X_bothpostdoc ///
one_female same_room_X_one_female both_female same_room_X_both_female ///
same_inst same_room_X_same_inst both_longwood same_room_X_both_longwood ///
one_imager same_room_X_one_imager both_imager same_room_X_both_imager same_clinicalarea same_room_X_same_clinicalarea ///
previouscoauthor same_room_X_previouscoau ///
if same_night==1 , r
estpost margins, dydx(*)
estimates save pdyad_interactpartsall.ster, replace


estimates drop _all
forvalues n=1(1)7 { 
estimates use dyad_interactparts`n'.ster
eststo
}
estimates use dyad_interactpartsall.ster
eststo

#delimit ;

esttab * using dyad_regs_interactparts.rtf,  keep(same_room onepostdoc same_room_X_onepostdoc bothpostdoc same_room_X_bothpostdoc ///
one_female same_room_X_one_female both_female same_room_X_both_female ///
same_inst same_room_X_same_inst both_longwood same_room_X_both_longwood ////
one_imager same_room_X_one_imager both_imager same_room_X_both_imager same_clinicalarea same_room_X_same_clinicalarea ///
previouscoauthor same_room_X_previouscoau  /* _cons*/)
varwidth(25) modelwidth(5) nonumber noobs nogaps nodep label b(%5.4f) se(%5.4f) star(+ 0.10 * 0.05 ** 0.01) 
compress scalars("r2 R2"  "N Nb. of Obs.") sfmt(%10.3fc %10.0fc) 
mlabels("(1)" "(2)" "(3)" "(4)" "(5)" "(6)" "(7)" "(8)")  
indicate("Night fixed effects =dum_1") 
eqlabels(none) replace;

#delimit cr




estimates drop _all
eststo clear
forvalues n=1(1)7 { 
estimates use pdyad_interactparts`n'.ster
eststo
}
estimates use pdyad_interactpartsall.ster
eststo

#delimit ;

esttab * using pdyad_regs_interactparts.rtf,  keep(same_room onepostdoc same_room_X_onepostdoc bothpostdoc same_room_X_bothpostdoc ///
one_female same_room_X_one_female both_female same_room_X_both_female ///
same_inst same_room_X_same_inst both_longwood same_room_X_both_longwood ////
one_imager same_room_X_one_imager both_imager same_room_X_both_imager same_clinicalarea same_room_X_same_clinicalarea ///
previouscoauthor same_room_X_previouscoau  /* _cons*/)
varwidth(25) modelwidth(5) nonumber noobs nogaps nodep label b(%5.4f) se(%5.4f) star(+ 0.10 * 0.05 ** 0.01) 
compress scalars("r2 R2"  "N Nb. of Obs.") sfmt(%10.3fc %10.0fc) 
mlabels("(1)" "(2)" "(3)" "(4)" "(5)" "(6)" "(7)" "(8)")  
indicate("Night fixed effects =dum_1") 
eqlabels(none) replace;

#delimit cr


capture log close











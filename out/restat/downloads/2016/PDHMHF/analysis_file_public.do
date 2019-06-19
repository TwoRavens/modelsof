

clear
use dyad_ready_public

egen nightcombo=group(x_night y_night)


set more off


/********** Table 4: Main effect of Treatment on Collaboration**********/

/*******ngreg is an ado file written by Marcel Fafchamps ******/
/******* it can be download https://web.stanford.edu/~fafchamp/resources.html *********/

** column 1 **
set more off
xi: ngreg any_coapplicant same_room if same_night==1 , id(x_participantidnum y_participantidnum) symmetric group(nightcombo)
estimates save dyad0.ster, replace

** column 2 **

xi: ngreg any_coapplicant same_room dum_1 dum_2 if same_night==1 , id(x_participantidnum y_participantidnum) symmetric group(nightcombo)
estimates save dyad1.ster, replace


***table
estimates drop _all
forvalues n=0(1)1 { 
estimates use dyad`n'.ster
eststo
}


#delimit ;
esttab *, keep(same_room ///
 _cons)
varwidth(25) nonumber noobs nogaps nodep label b(%5.4f) se(%5.4f) star(+ 0.10 * 0.05 ** 0.01) 
compress scalars("r2 R2"  "N Nb. of Obs.") sfmt(%10.3fc %10.0fc)
mlabels("(1)" "(2)" "(3)" "(4)" "(5)")  
indicate("Night fixed effects =dum_1")
eqlabels(none);

esttab * using dyad_regs_main_public.rtf, keep(same_room  ///
  _cons)
varwidth(25) nonumber noobs nogaps nodep label b(%5.4f) se(%5.4f) star(+ 0.10 * 0.05 ** 0.01) 
compress scalars("r2 R2"  "N Nb. of Obs.") sfmt(%10.3fc %10.0fc)
mlabels("(1)" "(2)" "(3)" "(4)" "(5)")  
indicate("Night fixed effects =dum_1") 
eqlabels(none) replace;






/********** Table A2. Main effect of Treatment on Collaboration – Estimated with Probit **********/

** Table A2 column 1 **
probit any_coapplicant same_room if same_night==1 , r 
estpost margins, dydx(*)
estimates save p_dyad0.ster, replace

** Table A2 column 2 **

probit any_coapplicant same_room dum_1 dum_2 if same_night==1 , r
estpost margins, dydx(*)
estimates save p_dyad1.ster, replace



estimates drop _all
forvalues n=0(1)1 { 
estimates use p_dyad`n'.ster
eststo
}

#delimit ;

esttab *, keep(same_room   )
varwidth(25) nonumber noobs nogaps nodep label b(%5.4f) se(%5.4f) star(+ 0.10 * 0.05 ** 0.01) 
compress scalars("r2 R2"  "N Nb. of Obs.") sfmt(%10.3fc %10.0fc)
mlabels("(1)" "(2)" "(3)" "(4)" "(5)")  
indicate("Night fixed effects =dum_1") 
eqlabels(none) replace;

esttab * using dyad_regs_main.rtf, keep(same_room  )
varwidth(25) nonumber noobs nogaps nodep label b(%5.4f) se(%5.4f) star(+ 0.10 * 0.05 ** 0.01) 
compress scalars("r2 R2"  "N Nb. of Obs.") sfmt(%10.3fc %10.0fc)
mlabels("(1)" "(2)" "(3)" "(4)" "(5)")  
indicate("Night fixed effects =dum_1") 
eqlabels(none) replace;

#delimit cr








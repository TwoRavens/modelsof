
****Testing Racial Priming Theory - Product-Review condition vs. Implicit Condition

**Table A8 - Effects of Implicit Condition on Trump Job Approval and Approval of Trump Handling Crime: Click on Table_A8.rtf for Regression output **
#delimit ;
set more off;
eststo: oprobit trumpap4  i.condition3##c.racresent i.condition3##c.oldfash;
eststo: oprobit trumpcrap4  i.condition3##c.racresent i.condition3##c.oldfash;

esttab using Table_A8.rtf, replace se nobaselevels onecell;

eststo clear;


**Figure A9 - Predicted Probabilities of Trump Job Approval for Implicit and Control Condition**
*Probability of Strongly Disapprove*
#delimit ;
set more off;
oprobit trumpap4  i.condition3##c.racresent i.condition3##c.oldfash;
margins condition3, at(racresent=(0(.0625)1)) predict(outcome(0));

#delimit ;
marginsplot, x(racresent) recast(line) recastci(rline) title("Strongly Disapprove", color(black) size(3.5)) graphregion(color(white))
xtitle("Racial Resentment", size(3)  margin(zero) height(0)) ytitle(`"Probability of Strongly Disapprove"' `"of Trump Job as President"', size(2))
plot1opts(lcolor(black) lpat(longdash)) plot2opts(lcolor(black) lpat(solid)) 
ci1opts(lcolor(black) lpat(dot)) ci2opts(lcolor(black) lpat(shortdash)) 
xlabel(0(.0625)1, ang(45) labsize(2))
ylabel(0(.1)1, axis(1) nogrid labsize(1.5))
xsca(titlegap(4)) ysca(titlegap(4))
subtitle(, bfcolor(white) lcolor(white))
legend(order(3 "Control Condition Probability" 4 "Implicit Condition Probability" 1 "Control Condition 95% CI" 2 "Implicit Condition 95% CI") size(small))
graphregion(color(white))
name(gen_strdisap_racprim_predprob_ci);

*Probability of Somewhat Disapprove*
#delimit ;
set more off;
oprobit trumpap4  i.condition3##c.racresent i.condition3##c.oldfash;
margins condition3, at(racresent=(0(.0625)1)) predict(outcome(#2));

#delimit ;
marginsplot, x(racresent) recast(line) recastci(rline) title("Somewhat Disapprove", color(black) size(3.5)) graphregion(color(white))
xtitle("Racial Resentment", size(3)  margin(zero) height(0)) ytitle(`"Probability of Somewhat Disapprove"' `"of Trump Job as President"', size(2))
plot1opts(lcolor(black) lpat(longdash)) plot2opts(lcolor(black) lpat(solid)) 
ci1opts(lcolor(black) lpat(dot)) ci2opts(lcolor(black) lpat(shortdash)) 
xlabel(0(.0625)1, ang(45) labsize(2))
ylabel(0(.1)1, axis(1) nogrid labsize(1.5))
xsca(titlegap(4)) ysca(titlegap(4))
subtitle(, bfcolor(white) lcolor(white))
graphregion(color(white))
name(gen_somdisap_racprim_predprob_ci);

*Probability of Somewhat Approve*
#delimit ;
set more off;
oprobit trumpap4  i.condition3##c.racresent i.condition3##c.oldfash;
margins condition3, at(racresent=(0(.0625)1)) predict(outcome(#3));

#delimit ;
marginsplot, x(racresent) recast(line) recastci(rline) title("Somewhat Approve", color(black) size(3.5)) graphregion(color(white))
xtitle("Racial Resentment", size(3)  margin(zero) height(0)) ytitle(`"Probability of Somewhat Approve"' `"of Trump Job as President"', size(2))
plot1opts(lcolor(black) lpat(longdash)) plot2opts(lcolor(black) lpat(solid)) 
ci1opts(lcolor(black) lpat(dot)) ci2opts(lcolor(black) lpat(shortdash)) 
xlabel(0(.0625)1, ang(45) labsize(2))
ylabel(0(.1)1, axis(1) nogrid labsize(1.5))
xsca(titlegap(4)) ysca(titlegap(4))
subtitle(, bfcolor(white) lcolor(white))
graphregion(color(white))
name(gen_somapp_racprim_predprob_ci);

*Probability of Strongly Approve*
#delimit ;
set more off;
oprobit trumpap4  i.condition3##c.racresent i.condition3##c.oldfash;
margins condition3, at(racresent=(0(.0625)1)) predict(outcome(#4));

#delimit ;
marginsplot, x(racresent) recast(line) recastci(rline) title("Strongly Approve", color(black) size(3.5)) graphregion(color(white))
xtitle("Racial Resentment", size(3)  margin(zero) height(0)) ytitle(`"Probability of Strongly Approve"' `"of Trump Job as President"', size(2))
plot1opts(lcolor(black) lpat(longdash)) plot2opts(lcolor(black) lpat(solid)) 
ci1opts(lcolor(black) lpat(dot)) ci2opts(lcolor(black) lpat(shortdash)) 
xlabel(0(.0625)1, ang(45) labsize(2))
ylabel(0(.1)1, axis(1) nogrid labsize(1.5))
xsca(titlegap(4)) ysca(titlegap(4))
subtitle(, bfcolor(white) lcolor(white))
graphregion(color(white))
name(gen_strapp_racprim_predprob_ci);

#delimit ;
findit grc1leg;

*** Click on grc1leg from http://www.stata.com/users/vwiggins to install grcleg package ***

#delimit ;
grc1leg gen_strdisap_racprim_predprob_ci gen_somdisap_racprim_predprob_ci gen_somapp_racprim_predprob_ci gen_strapp_racprim_predprob_ci, imargin(small) graphregion(color(white)); 

#delimit ;
graph export Figure_A9.png, replace height(5000);

**Figure A10 - Predicted Probabilities of Approval of Trump Handling Crime for Implicit and Control Condition**
*Probability of Strongly Disapprove*
#delimit ;
set more off;
oprobit trumpcrap4  i.condition3##c.racresent i.condition3##c.oldfash;
margins condition3, at(racresent=(0(.0625)1)) predict(outcome(0));

#delimit ;
marginsplot, x(racresent) recast(line) recastci(rline) title("Strongly Disapprove", color(black) size(3.5)) graphregion(color(white))
xtitle("Racial Resentment", size(3)  margin(zero) height(0)) ytitle(`"Probability of Strongly Disapprove"' `"of Trump Handling Crime"', size(2))
plot1opts(lcolor(black) lpat(longdash)) plot2opts(lcolor(black) lpat(solid)) 
ci1opts(lcolor(black) lpat(dot)) ci2opts(lcolor(black) lpat(shortdash)) 
xlabel(0(.0625)1, ang(45) labsize(2))
ylabel(0(.1)1, axis(1) nogrid labsize(1.5))
xsca(titlegap(4)) ysca(titlegap(4))
subtitle(, bfcolor(white) lcolor(white))
legend(order(3 "Control Condition Probability" 4 "Implicit Condition Probability" 1 "Control Condition 95% CI" 2 "Implicit Condition 95% CI") size(small))
graphregion(color(white))
name(crm_strdisap_racprim_predprob_ci);

*Probability of Somewhat Disapprove*
#delimit ;
set more off;
oprobit trumpcrap4  i.condition3##c.racresent i.condition3##c.oldfash;
margins condition3, at(racresent=(0(.0625)1)) predict(outcome(#2));

#delimit ;
marginsplot, x(racresent) recast(line) recastci(rline) title("Somewhat Disapprove", color(black) size(3.5)) graphregion(color(white))
xtitle("Racial Resentment", size(3)  margin(zero) height(0)) ytitle(`"Probability of Somewhat Disapprove"' `"of Trump Handling Crime"', size(2))
plot1opts(lcolor(black) lpat(longdash)) plot2opts(lcolor(black) lpat(solid)) 
ci1opts(lcolor(black) lpat(dot)) ci2opts(lcolor(black) lpat(shortdash)) 
xlabel(0(.0625)1, ang(45) labsize(2))
ylabel(0(.1)1, axis(1) nogrid labsize(1.5))
xsca(titlegap(4)) ysca(titlegap(4))
subtitle(, bfcolor(white) lcolor(white))
graphregion(color(white))
name(crm_somdisap_racprim_predprob_ci);

*Probability of Somewhat Approve*
#delimit ;
set more off;
oprobit trumpcrap4  i.condition3##c.racresent i.condition3##c.oldfash;
margins condition3, at(racresent=(0(.0625)1)) predict(outcome(#3));

#delimit ;
marginsplot, x(racresent) recast(line) recastci(rline) title("Somewhat Approve", color(black) size(3.5)) graphregion(color(white))
xtitle("Racial Resentment", size(3)  margin(zero) height(0)) ytitle(`"Probability of Somewhat Approve"' `"of Trump Job Handling Crime"', size(2))
plot1opts(lcolor(black) lpat(longdash)) plot2opts(lcolor(black) lpat(solid)) 
ci1opts(lcolor(black) lpat(dot)) ci2opts(lcolor(black) lpat(shortdash)) 
xlabel(0(.0625)1, ang(45) labsize(2))
ylabel(0(.1)1, axis(1) nogrid labsize(1.5))
xsca(titlegap(4)) ysca(titlegap(4))
subtitle(, bfcolor(white) lcolor(white))
graphregion(color(white))
name(crm_somapp_racprim_predprob_ci);

*Probability of Strongly Approve*
#delimit ;
set more off;
oprobit trumpcrap4  i.condition3##c.racresent i.condition3##c.oldfash;
margins condition3, at(racresent=(0(.0625)1)) predict(outcome(#4));

#delimit ;
marginsplot, x(racresent) recast(line) recastci(rline) title("Strongly Approve", color(black) size(3.5)) graphregion(color(white))
xtitle("Racial Resentment", size(3)  margin(zero) height(0)) ytitle(`"Probability of Strongly Approve"' `"of Trump Handling Crime"', size(2))
plot1opts(lcolor(black) lpat(longdash)) plot2opts(lcolor(black) lpat(solid)) 
ci1opts(lcolor(black) lpat(dot)) ci2opts(lcolor(black) lpat(shortdash)) 
xlabel(0(.0625)1, ang(45) labsize(2))
ylabel(0(.1)1, axis(1) nogrid labsize(1.5))
xsca(titlegap(4)) ysca(titlegap(4))
subtitle(, bfcolor(white) lcolor(white))
graphregion(color(white))
name(crm_strapp_racprim_predprob_ci);


#delimit ;
grc1leg crm_strdisap_racprim_predprob_ci crm_somdisap_racprim_predprob_ci crm_somapp_racprim_predprob_ci crm_strapp_racprim_predprob_ci, imargin(small) graphregion(color(white)); 

#delimit ;
graph export Figure_A10.png, replace height(5000);


**Figure A11 - Crime Approval Predicted Probabilities Ryan Condition v. Implicit Condition**
*Probability of Strongly Disapprove*

#delimit ;
set more off;
oprobit trumpcrap4  i.condition1##c.racresent i.condition1##c.oldfash;
margins i(1,3) condition1, at(racresent=(0(.0625)1)) predict(outcome(0));
***The code i(1,3) tells stata only to show the predicted margins for the implicit condition and the Ryan condition

#delimit ;
marginsplot, x(racresent) recast(line) recastci(rline) title("Strongly Disapprove", color(black) size(3.5)) graphregion(color(white))
xtitle("Racial Resentment", size(3) margin(zero) height(0)) ytitle(`"Probibility of Strongly Disapproves"' `"of Trump Handling Crime"', size(2))
plot1opts(lcolor(black) lpat(longdash)) plot2opts(lcolor(black) lpat(solid)) 
ci1opts(lcolor(black) lpat(dot)) ci2opts(lcolor(black) lpat(shortdash)) 
xlabel(0(.0625)1, ang(45) labsize(2))
ylabel(0(.10)1, axis(1) nogrid labsize(2))
xsca(titlegap(4)) ysca(titlegap(4))
subtitle(, bfcolor(white) lcolor(white))
legend(order( 3 "Implicit Condition Probability" 4 "Ryan Condition Probability" 1 "Implicit Condition 95% CI" 2 "Ryan Condition 95% CI") r(2) size(small))
name(crm_strdisapp_predprob);


*Probability of Somewhat Disapprove*
#delimit ;
set more off;
oprobit trumpcrap4 i.condition1##c.racresent i.condition1##c.oldfash;
margins i(1,3) condition1, at(racresent=(0(.0625)1)) predict(outcome(#2));
***The code i(1,3) tells stata only to show the predicted margins for the implicit condition and the Ryan condition

#delimit ;
marginsplot, x(racresent) recast(line) recastci(rline) title("Somewhat Disapprove", color(black) size(3.5)) graphregion(color(white))
xtitle("Racial Resentment", size(3) margin(zero) height(0)) ytitle(`"Probibility of Somewhat Disapproves"' `"of Trump Handling Crime"', size(2))
plot1opts(lcolor(black) lpat(longdash)) plot2opts(lcolor(black) lpat(solid)) 
ci1opts(lcolor(black) lpat(dot)) ci2opts(lcolor(black) lpat(shortdash)) 
xlabel(0(.0625)1, ang(45) labsize(2))
ylabel(0(.10)1, axis(1) nogrid labsize(2))
xsca(titlegap(4)) ysca(titlegap(4))
subtitle(, bfcolor(white) lcolor(white))
name(crm_somdisapp_predprob);


*Probability of Somewhat Approve*
#delimit ;
set more off;
oprobit trumpcrap4  i.condition1##c.racresent i.condition1##c.oldfash;
margins i(1,3) condition1, at(racresent=(0(.0625)1)) predict(outcome(#3));
***The code i(1,3) tells stata only to show the predicted margins for the implicit condition and the Ryan condition

#delimit ;
marginsplot, x(racresent) recast(line) recastci(rline) title("Somewhat Approve", color(black) size(3.5)) graphregion(color(white))
xtitle("Racial Resentment", size(3) margin(zero) height(0)) ytitle(`"Probibility of Somewhat Approves"' `"of Trump Handling Crime"', size(2))
plot1opts(lcolor(black) lpat(longdash)) plot2opts(lcolor(black) lpat(solid)) 
ci1opts(lcolor(black) lpat(dot)) ci2opts(lcolor(black) lpat(shortdash)) 
xlabel(0(.0625)1, ang(45) labsize(2))
ylabel(0(.10)1, axis(1) nogrid labsize(2))
xsca(titlegap(4)) ysca(titlegap(4))
subtitle(, bfcolor(white) lcolor(white))
name(crm_somapp_predprob);

*Probability of Strongly Approve*
#delimit ;
set more off;
oprobit trumpcrap4  i.condition1##c.racresent i.condition1##c.oldfash;
margins i(1,3) condition1, at(racresent=(0(.0625)1)) predict(outcome(#4));
***The code i(1,3) tells stata only to show the predicted margins for the implicit condition and the Ryan condition

#delimit ;
marginsplot, x(racresent) recast(line) recastci(rline) title("Strongly Approve", color(black) size(3.5)) graphregion(color(white))
xtitle("Racial Resentment", size(3) margin(zero) height(0)) ytitle(`"Probibility of Strongly Approves"' `"of Trump Handling Crime"', size(2))
plot1opts(lcolor(black) lpat(longdash)) plot2opts(lcolor(black) lpat(solid)) 
ci1opts(lcolor(black) lpat(dot)) ci2opts(lcolor(black) lpat(shortdash)) 
xlabel(0(.0625)1, ang(45) labsize(2))
ylabel(0(.10)1, axis(1) nogrid labsize(2))
xsca(titlegap(4)) ysca(titlegap(4))
subtitle(, bfcolor(white) lcolor(white))
name(crm_strapp_predprob);

#delimit ;
grc1leg crm_strdisapp_predprob crm_somdisapp_predprob crm_somapp_predprob crm_strapp_predprob, imargin(small) graphregion(color(white)); 

#delimit ;
graph export Figure_A11.png, replace height(5000);

**Figure A12 - Crime Approval Predicted Probabilities Sanders Condition v. Implicit Condition**
*Probability of Strongly Disapprove*

#delimit ;
set more off;
oprobit trumpcrap4  i.condition1##c.racresent i.condition1##c.oldfash;
margins i(1,2) condition1, at(racresent=(0(.0625)1)) predict(outcome(0));
***The code i(1,2) tells stata only to show the predicted margins for the implicit condition and the Sanders condition

#delimit ;
marginsplot, x(racresent) recast(line) recastci(rline) title("Strongly Disapprove", color(black) size(3.5)) graphregion(color(white))
xtitle("Racial Resentment", size(3) margin(zero) height(0)) ytitle(`"Probibility of Strongly Disapproves"' `"of Trump Handling Crime"', size(2))
plot1opts(lcolor(black) lpat(longdash)) plot2opts(lcolor(black) lpat(solid)) 
ci1opts(lcolor(black) lpat(dot)) ci2opts(lcolor(black) lpat(shortdash)) 
xlabel(0(.0625)1, ang(45) labsize(2))
ylabel(0(.10)1, axis(1) nogrid labsize(2))
xsca(titlegap(4)) ysca(titlegap(4))
subtitle(, bfcolor(white) lcolor(white))
legend(order( 3 "Implicit Condition Probability" 4 "Sanders Condition Probability" 1 "Implicit Condition 95% CI" 2 "Sanders Condition 95% CI") r(2) size(small))
name(crm_strdisapp_predprob2);


*Probability of Somewhat Disapprove*
#delimit ;
set more off;
oprobit trumpcrap4 i.condition1##c.racresent i.condition1##c.oldfash;
margins i(1,2) condition1, at(racresent=(0(.0625)1)) predict(outcome(#2));
***The code i(1,2) tells stata only to show the predicted margins for the implicit condition and the Sanders condition

#delimit ;
marginsplot, x(racresent) recast(line) recastci(rline) title("Somewhat Disapprove", color(black) size(3.5)) graphregion(color(white))
xtitle("Racial Resentment", size(3) margin(zero) height(0)) ytitle(`"Probibility of Somewhat Disapproves"' `"of Trump Handling Crime"', size(2))
plot1opts(lcolor(black) lpat(longdash)) plot2opts(lcolor(black) lpat(solid)) 
ci1opts(lcolor(black) lpat(dot)) ci2opts(lcolor(black) lpat(shortdash)) 
xlabel(0(.0625)1, ang(45) labsize(2))
ylabel(0(.10)1, axis(1) nogrid labsize(2))
xsca(titlegap(4)) ysca(titlegap(4))
subtitle(, bfcolor(white) lcolor(white))
name(crm_somdisapp_predprob2);


*Probability of Somewhat Approve*
#delimit ;
set more off;
oprobit trumpcrap4  i.condition1##c.racresent i.condition1##c.oldfash;
margins i(1,2) condition1, at(racresent=(0(.0625)1)) predict(outcome(#3));
***The code i(1,2) tells stata only to show the predicted margins for the implicit condition and the Sanders condition

#delimit ;
marginsplot, x(racresent) recast(line) recastci(rline) title("Somewhat Approve", color(black) size(3.5)) graphregion(color(white))
xtitle("Racial Resentment", size(3) margin(zero) height(0)) ytitle(`"Probibility of Somewhat Approves"' `"of Trump Handling Crime"', size(2))
plot1opts(lcolor(black) lpat(longdash)) plot2opts(lcolor(black) lpat(solid)) 
ci1opts(lcolor(black) lpat(dot)) ci2opts(lcolor(black) lpat(shortdash)) 
xlabel(0(.0625)1, ang(45) labsize(2))
ylabel(0(.10)1, axis(1) nogrid labsize(2))
xsca(titlegap(4)) ysca(titlegap(4))
subtitle(, bfcolor(white) lcolor(white))
name(crm_somapp_predprob2);

*Probability of Strongly Approve*
#delimit ;
set more off;
oprobit trumpcrap4  i.condition1##c.racresent i.condition1##c.oldfash;
margins i(1,2) condition1, at(racresent=(0(.0625)1)) predict(outcome(#4));
***The code i(1,2) tells stata only to show the predicted margins for the implicit condition and the Sanders condition

#delimit ;
marginsplot, x(racresent) recast(line) recastci(rline) title("Strongly Approve", color(black) size(3.5)) graphregion(color(white))
xtitle("Racial Resentment", size(3) margin(zero) height(0)) ytitle(`"Probibility of Strongly Approves"' `"of Trump Handling Crime"', size(2))
plot1opts(lcolor(black) lpat(longdash)) plot2opts(lcolor(black) lpat(solid)) 
ci1opts(lcolor(black) lpat(dot)) ci2opts(lcolor(black) lpat(shortdash)) 
xlabel(0(.0625)1, ang(45) labsize(2))
ylabel(0(.10)1, axis(1) nogrid labsize(2))
xsca(titlegap(4)) ysca(titlegap(4))
subtitle(, bfcolor(white) lcolor(white))
name(crm_strapp_predprob2);

#delimit ;
grc1leg crm_strdisapp_predprob2 crm_somdisapp_predprob2 crm_somapp_predprob2 crm_strapp_predprob2, imargin(small) graphregion(color(white)); 

#delimit ;
graph export Figure_A12.png, replace height(5000);



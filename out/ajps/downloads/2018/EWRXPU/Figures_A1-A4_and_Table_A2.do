***Figures A1 - A4 Including Both Interactions***

****Figure A1 - Marginal Effects of Each Politician Condition on Trump Feeling Thermometer****
#delimit ;
set more off;
reg trumpft1 i.condition1##c.racresent i.condition1##c.oldfash;
margins r.condition1, at(racresent=(0(.0625)1));

#delimit ;
marginsplot, x(racresent) bydimension(condition1, elab(1 "Carson Condition" 2 "Sanders Condition" 3 "Obama Condition" 4 "Ryan Condition")) 
by(,iyaxes ixaxes) recast(line) recastci(rline) yline(0) byopt(r(2) title(""))
xtitle("Racial Resentment", size(3) margin(zero) height(0)) 
ytitle("Marginal Effect of Explicit Politician Condition" "on Trump Feeling Thermometer", size(3))
title("")
plot1opts(lcolor(black)) ci1opts(lcolor(black) lpat(dot))
xlabel(0(.0625)1, ang(45) labsize(2))
ylabel(-40(10)30, axis(1) nogrid labsize(2))
xsca(titlegap(4)) ysca(titlegap(4))
legend(on)
legend(order(2 "Marginal Effect" 1 "95% CI") size(small))
scheme(s1mono) plotregion(style(none)) subtitle(, nobox fcolor(white))
name(trumpft_marg_eff);

#delimit ;
graph export Figure_A1.png, replace height(5000);



****Figure A2 - Marginal Effects of Each Politician Condition on Clinton Feeling Thermometer****
#delimit ;
set more off;
reg clintonft1 i.condition1##c.racresent i.condition1##c.oldfash;
margins r.condition1, at(racresent=(0(.0625)1));

#delimit ;
marginsplot, x(racresent) bydimension(condition1, elab(1 "Carson Condition" 2 "Sanders Condition" 3 "Obama Condition" 4 "Ryan Condition")) 
by(,iyaxes ixaxes) recast(line) recastci(rline) yline(0) byopt(r(2) title(""))
xtitle("Racial Resentment", size(3) margin(zero) height(0)) 
ytitle("Marginal Effect of Explicit Politician Condition" "on Clinton Feeling Thermometer", size(3))
title("")
plot1opts(lcolor(black)) ci1opts(lcolor(black) lpat(dot))
xlabel(0(.0625)1, ang(45) labsize(2))
ylabel(-40(10)30, axis(1) nogrid labsize(2))
xsca(titlegap(4)) ysca(titlegap(4))
legend(on)
legend(order(2 "Marginal Effect" 1 "95% CI") size(small))
scheme(s1mono) plotregion(style(none)) subtitle(, nobox fcolor(white))
name(clintonft_marg_eff);

#delimit ;
graph export Figure_A2.png, replace height(5000);

****Figure A3 - Marginal Effects of Each Politician Condition on Difference in Trump/Clinton Feeling Thermometers****
#delimit ;
set more off;
reg trumvclinft i.condition1##c.racresent i.condition1##c.oldfash;
margins r.condition1, at(racresent=(0(.0625)1));

#delimit ;
marginsplot, x(racresent) bydimension(condition1, elab(1 "Carson Condition" 2 "Sanders Condition" 3 "Obama Condition" 4 "Ryan Condition")) 
by(,iyaxes ixaxes) recast(line) recastci(rline) yline(0) byopt(r(2) title(""))
xtitle("Racial Resentment", size(3) margin(zero) height(0)) 
ytitle("Marginal Effect of Explicit Politician Condition" "on Difference in Trump/Clinton Feeling Thermometers", size(3))
title("")
plot1opts(lcolor(black)) ci1opts(lcolor(black) lpat(dot))
xlabel(0(.0625)1, ang(45) labsize(2))
ylabel(-60(20)40, axis(1) nogrid labsize(2))
xsca(titlegap(4)) ysca(titlegap(4))
legend(on)
legend(order(2 "Marginal Effect" 1 "95% CI") size(small))
scheme(s1mono) plotregion(style(none)) subtitle(, nobox fcolor(white))
name(trumvclinft_marg_eff);

#delimit ;
graph export Figure_A3.png, replace height(5000);

***Figure A4 - Predicted Probabilities of Voting for Trump for Each Politician Condition across Racial Resentment***

**Carson Condition
#delimit ;
set more off;
probit trumvote i.condition1##c.racresent i.condition1##c.oldfash;
margins i(1,2) condition1, at(racresent=(0(.0625)1));
****The code "i(1,2)" tells stata to only show the predicted margins for the Control condition and Carson condition
****This allows us to plot each politician condition against the control condition on separate graphs for ease of readability

#delimit ;
marginsplot, x(racresent) recast(line) recastci(rline) title("Carson Condition", size(3) nospan color(black)) noci
xtitle("") 
ytitle("")
plot1opts(lcolor(black) lpat(shortdash)) plot2opts(lcolor(black))
xlabel(0(.0625)1, ang(45) labsize(2))
ylabel(0(.1).8, axis(1) nogrid labsize(2))
xsca(titlegap(4)) ysca(titlegap(4))
legend(order(1 "Implicit" 2 "Carson") size(small))
graphregion(color(white))
name(carson_trumvote_pred_prob);

**Sanders Condition
#delimit ;
set more off;
probit trumvote i.condition1##c.racresent i.condition1##c.oldfash;
margins i(1,3) condition1, at(racresent=(0(.0625)1));
****The code "i(1,3)" tells stata to only show the predicted margins for the Control condition and Sanders condition

#delimit ;
marginsplot, x(racresent) recast(line) recastci(rline) title("Sanders Condition", size(3) nospan color(black)) noci
xtitle("") 
ytitle("")
plot1opts(lcolor(black) lpat(shortdash)) plot2opts(lcolor(black))
xlabel(0(.0625)1, ang(45) labsize(2))
ylabel(0(.1).8, axis(1) nogrid labsize(2))
xsca(titlegap(4)) ysca(titlegap(4))
legend(order(1 "Implicit" 2 "Sanders") size(small))
graphregion(color(white))
name(sanders_trumvote_pred_prob);

**Obama Condition
#delimit ;
set more off;
probit trumvote i.condition1##c.racresent i.condition1##c.oldfash;
margins i(1,4) condition1, at(racresent=(0(.0625)1));
****The code "i(1,4)" tells stata to only show the predicted margins for the Control condition and Obama condition

#delimit ;
marginsplot, x(racresent) recast(line) recastci(rline) title("Obama Condition", size(3) nospan color(black)) noci
xtitle("") 
ytitle("")
plot1opts(lcolor(black) lpat(shortdash)) plot2opts(lcolor(black))
xlabel(0(.0625)1, ang(45) labsize(2))
ylabel(0(.1).8, axis(1) nogrid labsize(2))
xsca(titlegap(4)) ysca(titlegap(4))
legend(order(1 "Implicit" 2 "Obama") size(small))
graphregion(color(white))
name(obama_trumvote_pred_prob);

**Ryan Condition
#delimit ;
set more off;
probit trumvote i.condition1##c.racresent i.condition1##c.oldfash;
margins i(1,5) condition1, at(racresent=(0(.0625)1));
****The code "i(1,5)" tells stata to only show the predicted margins for the Control condition and Ryan condition

#delimit ;
marginsplot, x(racresent) recast(line) recastci(rline) title("Ryan Condition", size(3) nospan color(black)) noci
xtitle("") 
ytitle("")
plot1opts(lcolor(black) lpat(shortdash)) plot2opts(lcolor(black))
xlabel(0(.0625)1, ang(45) labsize(2))
ylabel(0(.1).8, axis(1) nogrid labsize(2))
xsca(titlegap(4)) ysca(titlegap(4))
legend(order(1 "Implicit" 2 "Ryan") size(small))
graphregion(color(white))
name(ryan_trumvote_pred_prob);

#delimit ;
graph combine  carson_trumvote_pred_prob sanders_trumvote_pred_prob obama_trumvote_pred_prob ryan_trumvote_pred_prob, imargin(medsmall) graphregion(color(white)) r(2) l1(Probability of Voting for Trump, size(3) ring(0)) b1(Racial Resentment, size(3)) ; 

#delimit ;
graph export Figure_A4.png, replace height(5000);


***Table A2 Click Table_A2.rtf to view Regression output ***
#delimit ;
set more off;
eststo: reg trumpft1 i.condition1##c.racresent i.condition1##c.oldfash;
eststo: reg clintonft1 i.condition1##c.racresent i.condition1##c.oldfash;
eststo: reg trumvclinft i.condition1##c.racresent i.condition1##c.oldfash;
eststo: probit trumvote i.condition1##c.racresent i.condition1##c.oldfash;
esttab using Table_A2.rtf, replace se nobaselevels onecell;
eststo clear;




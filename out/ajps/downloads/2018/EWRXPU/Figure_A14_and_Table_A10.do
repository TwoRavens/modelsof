**High School or Less vs. Some College or More Variable ***
gen educ2=educ
recode educ2 (1=1) (2=1) (3=1) (4=2) (5=2) (6=2)
tab educ2
tab educ

***Table A10 - Effects of the Explicit Politician Condition in Study 1 Conditioned on Education Click on Table_A10.rtf to view Regression output ****
findit eststo
#delimit ;
set more off;
eststo: reg trumpft1 i.condition2##c.racresent##i.educ2 i.condition2##c.oldfash##i.educ2;
eststo: reg clintonft1 i.condition2##c.racresent##i.educ2 i.condition2##c.oldfash##i.educ2;
eststo: reg trumvclinft i.condition2##c.racresent##i.educ2 i.condition2##c.oldfash##i.educ2;
eststo: probit trumvote  i.condition2##c.racresent##i.educ2 i.condition2##c.oldfash##i.educ2;
esttab using Table_A10.rtf, replace se nobaselevels onecell;
eststo clear;


***Figure A14 - Marginal Effects of the Explicit Politician Condition in Study 1 Conditioned on Education***
***Trump Feeling Therm Marginal Effects ***
#delimit ;
set more off;
reg trumpft1 i.condition2##c.racresent##i.educ2 i.condition2##c.oldfash##i.educ2;
margins r.condition2, at(racresent=(0(.0625)1)) over(educ2);

#delimit ;
marginsplot, x(racresent) bydim(educ2, elab(1 "High School or Less" 2 "Some College or More")) recast(line) recastci(rline) yline(0) byopt(r(1) title("Trump Feeling Thermometer", size(3.75)))
xtitle("Racial Resentment", size(3) margin(zero) height(0)) 
ytitle("Marginal Effect of Explicit Politician Condition" "on Trump Feeling Thermometer", size(2.5))
plot1opts(lcolor(black)) ci1opts(lcolor(black) lpat(dot))
xlabel(0(.0625)1, ang(45) labsize(1.5))
ylabel(-100(20)50, axis(1) nogrid labsize(1.5))
xsca(titlegap(4)) ysca(titlegap(4))
legend(on)
legend(order(2 "Marginal Effect" 1 "95% CI") size(vsmall) symxsize(*.5) colgap(*.5) keygap(*.5))
scheme(s1mono) plotregion(style(none)) subtitle(, nobox fcolor(white))
graphregion(color(white))
name (trumpft_marg_eff_triple);

***Clinton Feeling Therm Marginal Effects***
#delimit ;
set more off;
reg clintonft1 i.condition2##c.racresent##i.educ2 i.condition2##c.oldfash##i.educ2;
margins r.condition2, at(racresent=(0(.0625)1)) over(educ2);

#delimit ;
marginsplot, x(racresent) bydim(educ2, elab(1 "High School or Less" 2 "Some College or More")) recast(line) recastci(rline) yline(0) byopt(r(1) title("Clinton Feeling Thermometer", size(3.75)))
xtitle("Racial Resentment", size(3) margin(zero) height(0)) 
ytitle("Marginal Effect of Explicit Politician Condition" "on Clinton Feeling Thermometer", size(2.5))
plot1opts(lcolor(black)) ci1opts(lcolor(black) lpat(dot))
xlabel(0(.0625)1, ang(45) labsize(1.5))
ylabel(-100(20)50, axis(1) nogrid labsize(1.5))
xsca(titlegap(4)) ysca(titlegap(4))
legend(on)
legend(order(2 "Marginal Effect" 1 "95% CI") size(vsmall) symxsize(*.5) colgap(*.5) keygap(*.5))
scheme(s1mono) plotregion(style(none)) subtitle(, nobox fcolor(white))
graphregion(color(white))
name (clintonft_marg_eff_triple);

***Trump vs. Clinton Feeling Therm Marginal Effects***
#delimit ;
set more off;
reg trumvclinft i.condition2##c.racresent##i.educ2 i.condition2##c.oldfash##i.educ2;
margins r.condition2, at(racresent=(0(.0625)1)) over(educ2);

#delimit ;
marginsplot, x(racresent) bydim(educ2, elab(1 "High School or Less" 2 "Some College or More")) recast(line) recastci(rline) yline(0) byopt(r(1) title("Difference in Trump/Clinton Feeling Thermometers", size(3.75)))
xtitle("Racial Resentment", size(3) margin(zero) height(0)) 
ytitle("Marginal Effect of Explicit Politician Condition on" "Difference in Trump/Clinton Feeling Thermometers", size(2.5))
plot1opts(lcolor(black)) ci1opts(lcolor(black) lpat(dot))
xlabel(0(.0625)1, ang(45) labsize(1.5))
ylabel(-100(20)50, axis(1) nogrid labsize(1.5))
xsca(titlegap(4)) ysca(titlegap(4))
legend(on)
legend(order(2 "Marginal Effect" 1 "95% CI") size(vsmall) symxsize(*.5) colgap(*.5) keygap(*.5))
scheme(s1mono) plotregion(style(none)) subtitle(, nobox fcolor(white))
graphregion(color(white))
name (trumvclinft_marg_eff_triple);

***Vote for Trump Predicted Probabilities**
#delimit ;
set more off;
probit trumvote i.condition2##c.racresent##i.educ2 i.condition2##c.oldfash##i.educ2;
margins condition2, at(racresent=(0(.0625)1)) over(educ2);

#delimit ;
marginsplot, x(racresent) bydim(educ2, elab(1 "High School or Less" 2 "Some College or More")) recast(line) noci byopt(r(1) title("Vote for Trump", size(3.75)))
xtitle("Racial Resentment", size(3) margin(zero) height(0)) 
ytitle("Probability of Voting for Trump", size(2.5))
plot1opts(lcolor(black) lpat(shortdash)) plot2opts(lcolor(black) lpat(solid))
xlabel(0(.0625)1, ang(45) labsize(1.5))
ylabel(0(.1).8, axis(1) nogrid labsize(1.5))
xsca(titlegap(4)) ysca(titlegap(4))
legend(order(1 "Implicit" 2 "Explicit Politician") size(vsmall) symxsize(*.5) colgap(*.5) keygap(*.5))
graphregion(color(white))
scheme(s1mono) plotregion(style(none)) subtitle(, nobox fcolor(white))
name(trumvote_pred_prob_triple);

**Combine graphs into one figure**
#delimit ;
graph combine trumpft_marg_eff_triple clintonft_marg_eff_triple trumvclinft_marg_eff_triple trumvote_pred_prob_triple, imargin(medsmall) graphregion(color(white))
scheme(s1mono) plotregion(style(none)) subtitle(, nobox fcolor(white)); 

#delimit ;
graph export Figure_A14.png, replace height(5000);





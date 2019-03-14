***Figure 1 - The effects of the politician condition on candidate evaluations***


*********Across Racial Resentment**************
***Trump Feeling Therm Marginal Effects***
#delimit ;
set more off;
reg trumpft1 i.condition2##c.racresent i.condition2##c.oldfash;
margins r.condition2, at(racresent=(0(.0625)1));

#delimit ;
marginsplot, x(racresent) recast(line) recastci(rline) yline(0) byopt(r(1) title(""))
xtitle("Racial Resentment", size(3) margin(zero) height(0)) 
ytitle("Marginal Effect of Explicit Politician Condition" "on Trump Feeling Thermometer", size(2.5))
title("Trump Feeling Thermometer", size(3) nospan color(black))
plot1opts(lcolor(black)) ci1opts(lcolor(black) lpat(dot))
xlabel(0(.0625)1, ang(45) labsize(1.5))
ylabel(-40(10)40, axis(1) nogrid labsize(1.5))
xsca(titlegap(4)) ysca(titlegap(4))
legend(on)
legend(order(2 "Marginal Effect" 1 "95% CI") size(small))
graphregion(color(white))
name(trumpft_marg_eff);




***Clinton Feeling Therm Marginal Effects***
#delimit ;
set more off;
reg clintonft1 i.condition2##c.racresent i.condition2##c.oldfash;
margins r.condition2, at(racresent=(0(.0625)1));

#delimit ;
marginsplot, x(racresent) recast(line) recastci(rline) yline(0) byopt(r(1) title(""))
xtitle("Racial Resentment", size(3) margin(zero) height(0)) 
ytitle("Marginal Effect of Explicit Politician Condition" "on Clinton Feeling Thermometer", size(2.5))
title("Clinton Feeling Thermometer", size(3) nospan color(black))
plot1opts(lcolor(black)) ci1opts(lcolor(black) lpat(dot))
xlabel(0(.0625)1, ang(45) labsize(1.5))
ylabel(-40(10)40, axis(1) nogrid labsize(1.5))
xsca(titlegap(4)) ysca(titlegap(4))
legend(on)
legend(order(2 "Marginal Effect" 1 "95% CI") size(small))
graphregion(color(white))
name (clintonft_marg_eff);

***Trump vs. Clinton Feeling Therm Marginal Effects***
#delimit ;
set more off;
reg trumvclinft i.condition2##c.racresent i.condition2##c.oldfash;
margins r.condition2, at(racresent=(0(.0625)1));

#delimit ;
marginsplot, x(racresent) recast(line) recastci(rline) yline(0) byopt(r(1) title(""))
xtitle("Racial Resentment", size(3) margin(zero) height(0)) 
ytitle("Marginal Effect of Explicit Politician Condition on" "Difference in Trump/Clinton Feeling Thermometers", size(2.5))
title("Difference in Trump/Clinton Feeling Thermometers", size(3) nospan color(black))
plot1opts(lcolor(black)) ci1opts(lcolor(black) lpat(dot))
xlabel(0(.0625)1, ang(45) labsize(1.5))
ylabel(-40(10)40, axis(1) nogrid labsize(1.5))
xsca(titlegap(4)) ysca(titlegap(4))
legend(on)
legend(order(2 "Marginal Effect" 1 "95% CI") size(small))
graphregion(color(white))
name (trumvclinft_marg_eff);

***Vote for Trump Predicted Probabilities**
#delimit ;
set more off;
probit trumvote i.condition2##c.racresent i.condition2##c.oldfash;
margins condition2, at(racresent=(0(.0625)1));

#delimit ;
marginsplot, x(racresent) recast(line) recastci(rline) title("Vote for Trump", size(3) nospan color(black)) noci
xtitle("Racial Resentment", size(3) margin(zero) height(0)) 
ytitle("Probability of Voting for Trump", size(2.5))
plot1opts(lcolor(black) lpat(shortdash)) plot2opts(lcolor(black))
xlabel(0(.0625)1, ang(45) labsize(1.5))
ylabel(0(.1).8, axis(1) nogrid labsize(1.5))
xsca(titlegap(4)) ysca(titlegap(4))
legend(order(1 "Implicit" 2 "Explicit Politician") size(small))
graphregion(color(white))
name(trumvote_pred_prob);

**Combine graphs into one figure**
#delimit ;
graph combine trumpft_marg_eff clintonft_marg_eff trumvclinft_marg_eff trumvote_pred_prob, imargin(medsmall) graphregion(color(white)); 

#delimit ;
graph export Figure_1.png, replace height(5000);



***Table 1 - Click on Table_1.rtf to see the full table of Regression resutls****
findit eststo
*** Click st0085_1  to install  st0085_1/_eststo package ***
#delimit ;
set more off;
eststo: reg trumpft1 i.condition2##c.racresent i.condition2##c.oldfash;
eststo: reg clintonft1 i.condition2##c.racresent i.condition2##c.oldfash;
eststo: reg trumvclinft i.condition2##c.racresent i.condition2##c.oldfash;
eststo: probit trumvote  i.condition2##c.racresent i.condition2##c.oldfash;
eststo: probit abtrace1 i.condition2##c.racresent i.condition2##c.oldfash;
esttab using Table_1.rtf, replace se nobaselevels onecell;
eststo clear;







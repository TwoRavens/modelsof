**Table 4 Click Table_4.rtf to view the Regression output***
#delimit ;
set more off;
eststo: reg gileval i.condition1##c.racresent i.condition1##c.oldfash;
eststo: probit abtrace1 i.condition1##c.racresent i.condition1##c.oldfash;
esttab using Table_4.rtf, replace se nobaselevels onecell;
eststo clear;


***Figure 4: Gillespie Evaluations Across Racial Resentment ***
#delimit ;
set more off;
reg gileval i.condition1##c.racresent i.condition1##c.oldfash;
margins r.condition1, at(racresent=(0(.0625)1));

#delimit ;
marginsplot, x(racresent) recast(line) recastci(rline) yline(0) byopt(r(1) title(""))
xtitle("Racial Resentment", size(3) margin(zero) height(0)) 
ytitle("Marginal Effect of Explicit Politician Condition" "on Gillespie Evaluations", size(2.5))
title("", size(3) nospan color(black))
plot1opts(lcolor(black)) ci1opts(lcolor(black) lpat(dot))
xlabel(0(.0625)1, ang(45) labsize(1.5))
ylabel(-.2(.05).1, axis(1) nogrid labsize(1.5))
xsca(titlegap(4)) ysca(titlegap(4))
legend(on)
legend(order(2 "Marginal Effect" 1 "95% CI") size(small))
graphregion(color(white));

#delimit ;
graph export Fig_4_Gillespie_Eval_Marg_eff.png, replace height(5000);



***Figure 5: Thinks Tweet is About Race****
**Across Racial Resentment
#delimit ;
set more off;
probit abtrace1 i.condition1##c.racresent i.condition1##c.oldfash;
margins condition1, at(racresent=(0(.0625)1));

#delimit ;
marginsplot, x(racresent) recast(line) recastci(rline) title("", size(3) color(black))
xtitle("Racial Resentment", size(3) margin(zero) height(0)) 
ytitle("Probability of Thinking the Tweet is About Race", size(3))
plot1opts(lcolor(black) lpat(longdash)) plot2opts(lcolor(black))
ci1opts(lcolor(black) lpat(shortdash)) ci2opts(lcolor(black) lpat(dot))
xlabel(0(.0625)1, ang(45) labsize(2))
ylabel(0(.1)1, axis(1) nogrid labsize(2))
xsca(titlegap(4)) ysca(titlegap(4))
legend(order(3 "Implicit" 4 "Explicit Politician" 1 "Implicit 95% CIs" 2 "Explicit Politician 95% CIs") size(small) r(2))
graphregion(color(white));

#delimit ;
graph export Fig_5_Gillespie_Tweet_Abtrace.png, replace height(5000);









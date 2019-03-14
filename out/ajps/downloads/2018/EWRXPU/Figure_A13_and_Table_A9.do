**Figure A13**
**Gillespie Evaluations Among those interested in politics**
#delimit ;
set more off;
reg gileval i.condition1##c.racresent i.condition1##c.oldfash if pretreat>.5;
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
graphregion(color(white))
name(gillespie_interested);



***Gillespie Evaluations among those not interested in politics
#delimit ;
set more off;
reg gileval i.condition1##c.racresent i.condition1##c.oldfash if pretreat<=.5;
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
graphregion(color(white))
name(gillespie_not_interested);

#delimit ;
graph combine gillespie_interested gillespie_not_interested, xsize(10) ysize(5) iscale(1.1)  imargin(small) graphregion(color(white)); 


#delimit ;
graph export Figure_A13.png, replace height(5000);



**Table A9 Click Table_A9.rtf to view Regression output***
#delimit ;
set more off;
eststo: reg gileval i.condition1##c.racresent i.condition1##c.oldfash if pretreat>.5;
eststo: reg gileval i.condition1##c.racresent i.condition1##c.oldfash if pretreat<=.5;
esttab using Table_A9.rtf, replace se nobaselevels onecell;
eststo clear;

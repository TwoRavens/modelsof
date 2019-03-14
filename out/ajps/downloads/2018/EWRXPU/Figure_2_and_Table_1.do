***Figure 2 - Predicted Probabilities of Thinking Trump's Ad is About Race, Including Both Interaction***

#delimit ;
set more off;
probit abtrace1 i.condition2##c.racresent i.condition2##c.oldfash;
margins condition2, at(racresent=(0(.0625)1));

#delimit ;
marginsplot, x(racresent) recast(line) recastci(rline) title("")
xtitle("Racial Resentment", size(3) margin(zero) height(0)) 
ytitle("Probability of Thinking the Ad is About Race", size(3))
plot1opts(lcolor(black) lpat(longdash)) plot2opts(lcolor(black))
ci1opts(lcolor(black) lpat(dash)) ci2opts(lcolor(black) lpat(dot))
xlabel(0(.125)1, ang(45) labsize(2))
ylabel(0(.1)1, axis(1) nogrid labsize(2))
xsca(titlegap(4)) ysca(titlegap(4))
legend(order(3 "Implicit" 4 "Explicit Politician" 1 "Implicit 95% CIs" 2 "Explicit Politician 95% CIs") size(small) r(2))
graphregion(color(white));

#delimit ;
graph export Figure_2.png, replace height(5000);



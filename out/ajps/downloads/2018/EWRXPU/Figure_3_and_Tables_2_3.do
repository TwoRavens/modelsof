
**** Table 2 - Effects of Sanders and Ryan Condition on Trump Job Approval and Approval of Trump Handling Crime****
*** Click on Table_2.rtf to view Regression output ***
****baseline is implicit condition****
#delimit ;
set more off;
eststo: oprobit trumpcrap4  i.condition1##c.racresent i.condition1##c.oldfash;
eststo: oprobit trumpap4  i.condition1##c.racresent i.condition1##c.oldfash;
eststo: probit abtrace1  i.condition1##c.racresent i.condition1##c.oldfash;
esttab using Table_2.rtf, replace se nobaselevels onecell;
eststo clear;

**Table 3 - Estimated Effect of Experimental Conditions on Probability of Strongly Disapprove of Trump Handling Crime and Job Approval***
#delimit ;
set more off;
oprobit trumpcrap4  i.condition1##c.racresent i.condition1##c.oldfash;
margins condition1, at(racresent=(0(.0625)1)) predict(outcome(0));
*** Probablities for implicit appeal condition are _at#condition1 [1 1] (least resentful) *** 
*** Probablities for implicit appeal condition are _at#condition1 [17 1] (most resentful) *** 
*** Probablities for ryan condition are _at#condition1 [1 3] (least resentful) *** 
*** Probablities for ryan condition are _at#condition1 [17 3] (most resentful) *** 
*** Probablities for sanders condition are _at#condition1 [1 2] (least resentful) *** 
*** Probablities for sanders condition are _at#condition1 [17 2] (most resentful) *** 



#delimit ;
set more off;
oprobit trumpap4  i.condition1##c.racresent i.condition1##c.oldfash;
margins condition1, at(racresent=(0(.0625)1)) predict(outcome(0));
*** Probablities for implicit appeal condition are _at#condition1 [1 1] (least resentful) *** 
*** Probablities for implicit appeal condition are _at#condition1 [17 1] (most resentful) *** 
*** Probablities for ryan condition are _at#condition1 [1 3] (least resentful) *** 
*** Probablities for ryan condition are _at#condition1 [17 3] (most resentful) *** 
*** Probablities for sanders condition are _at#condition1 [1 2] (least resentful) *** 
*** Probablities for sanders condition are _at#condition1 [17 2] (most resentful) *** 

***** Figure 3 - Predicted Probabilities of Thinking Trump's Tweet is About Race *****

**Predicted Probabilities with Sanders Condition and Implicit Condition on one graph**
#delimit ;
set more off;
probit abtrace1  i.condition1##c.racresent i.condition1##c.oldfash;
margins i(1/2) condition1, at(racresent=(0(.0625)1));
****The code "i(1/2)" tells stata to only show the predicted margins for the implicit condition and Sanders condition
****This allows us to plot the Sanders and Implicit Condition on one graph and the Ryan and Implicit conditions on a separate graph

#delimit ;
marginsplot, x(racresent) recast(line) recastci(rline) title("Sanders Condition", size(4) color(black))
xtitle("Racial Resentment", size(3) margin(zero) height(0)) 
ytitle("Probability of Thinking the Tweet is About Race", size(3))
plot1opts(lcolor(black) lpat(longdash)) plot2opts(lcolor(black))
ci1opts(lcolor(black) lpat(shortdash)) ci2opts(lcolor(black) lpat(dot))
xlabel(0(.0625)1, ang(45) labsize(2))
ylabel(0(.1)1, axis(1) nogrid labsize(2))
xsca(titlegap(4)) ysca(titlegap(4))
legend(order(3 "Implicit Condition" 4 "Sanders Condition" 1 "Implicit 95% CIs" 2 "Sanders 95% CIs" ) size(vsmall) symxsize(7) r(2))
graphregion(color(white))
name(sanders_tweet_abtrace);

**Predicted Probabilities with Ryan Condition and Implicit Condition on one graph**
#delimit ;
set more off;
probit abtrace1  i.condition1##c.racresent i.condition1##c.oldfash;
margins i(1,3) condition1, at(racresent=(0(.0625)1));
****The code "i(1,3)" tells stata to only show the predicted margins for the implicit condition and Ryan condition

#delimit ;
marginsplot, x(racresent) recast(line) recastci(rline) title("Ryan Condition", size(4) color(black))
ytitle("", size(3))
xtitle("Racial Resentment", size(3) margin(zero) height(0)) 
plot1opts(lcolor(black) lpat(longdash)) plot2opts(lcolor(black))
ci1opts(lcolor(black) lpat(shortdash)) ci2opts(lcolor(black) lpat(dot))
xlabel(0(.0625)1, ang(45) labsize(2))
ylabel(0(.1)1, nogrid labsize(2))
xsca(titlegap(4)) 
legend(order(3 "Implicit Condition" 4 "Ryan Condition" 1 "Implicit 95% CIs" 2 "Ryan 95% CIs") size(vsmall) symxsize(7) r(2))
graphregion(color(white))
name(ryan_tweet_abtrace);


**Combine the Sanders and Ryan graphs
#delimit ;
graph combine sanders_tweet_abtrace ryan_tweet_abtrace, xsize(10) ysize(5) iscale(1.1)  imargin(small) graphregion(color(white)); 


#delimit ;
graph export Figure_3.png, replace height(5000);



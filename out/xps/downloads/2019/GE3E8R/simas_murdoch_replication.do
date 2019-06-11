**Trait Ratings in Table 1 and Values for Figure 3 in Main Text**
reg integ1 i.oppositeparty##i.mckinleywom 
reg integ2 i.oppositeparty##i.mckinleywom 
reg changeinteg i.oppositeparty##i.mckinleywom 
margins, dydx(mckinleywom) at(oppositeparty=(0(1)1))

reg able1 i.oppositeparty##i.mckinleywom 
reg able2 i.oppositeparty##i.mckinleywom 
reg changeable i.oppositeparty##i.mckinleywom 
margins, dydx(mckinleywom) at(oppositeparty=(0(1)1))

reg perf1 i.oppositeparty##i.mckinleywom 
reg perf2 i.oppositeparty##i.mckinleywom 
reg changeperf i.oppositeparty##i.mckinleywom 
margins, dydx(mckinleywom) at(oppositeparty=(0(1)1))


**Change in Ratings by Candidate Sex and Party -- Table A5 in the Appendix**
reg changeinteg i.oppositeparty##i.mckinleywom if mckinleydem==1
reg changeable i.oppositeparty##i.mckinleywom if mckinleydem==1
reg changeperf i.oppositeparty##i.mckinleywom if mckinleydem==1

reg changeinteg i.oppositeparty##i.mckinleywom if mckinleydem==0
reg changeable i.oppositeparty##i.mckinleywom if mckinleydem==0
reg changeperf i.oppositeparty##i.mckinleywom if mckinleydem==0


**Vote Choice Model Table A6 in the Appendix and Values for Figure 4 in the Main Text**
logit vote2 i.oppositeparty##i.mckinleywom##i.vote1
margins, dydx(mckinleywom) at(oppositeparty=(0(1)1) vote1=(0(1)1))

**Models from Table A7 in the Appendix and Values for Figures 5 and 6 in the Main Text**
ologit lied i.oppositeparty##i.mckinleywom
margins, dydx(mckinleywom) at(oppositeparty=(0(1)1))

ologit nopenalty i.oppositeparty##i.mckinleywom
margins, dydx(mckinleywom) at(oppositeparty=(0(1)1))

**2nd Vote by Subject Sex and PID -- Table A8 in the Appendix**
ttest vote2 if demsubject==1 & femalesubject==1 & vote1==0, by(mckinleywom)
ttest vote2 if demsubject==0 & femalesubject==1 & vote1==0, by(mckinleywom)
ttest vote2 if demsubject==1 & femalesubject==0 & vote1==0, by(mckinleywom)
ttest vote2 if demsubject==0 & femalesubject==0 & vote1==0, by(mckinleywom)

**To reproduce figures, use simas_murdoch_figures.dta**
**Figure 3**
twoway (scatter axis plot, mcolor(black)) (rspike lb ub axis, lcolor(black) horizontal)if figure==3, ylabel(.5(.5)3.5, nogrid) xline(0, lpattern(dash) lcolor(gs8)) xlabel(-.5(.5).5, nogrid) by(, legend(off)) by(oppparty)

**Figure 4**
twoway (scatter plot axis, mcolor(black)) (rspike lb ub axis, lcolor(black) vertical) if figure==4, yline(0, lpattern(dash) lcolor(gs8)) ylabel(, nogrid) xlabel(, nogrid) legend(off)

**Figure 5**
twoway (scatter plot axis, mcolor(black)) (rspike lb ub axis, lcolor(black) vertical) if figure==5, yline(0, lpattern(dash) lcolor(gs8)) ylabel(, nogrid) xlabel(, nogrid) by(, legend(off)) by(oppparty)

**Figure 6**
twoway (scatter plot axis, mcolor(black)) (rspike lb ub axis, lcolor(black) vertical) if figure==6, yline(0, lpattern(dash) lcolor(gs8)) ylabel(, nogrid) xlabel(, nogrid) by(, legend(off)) by(oppparty)

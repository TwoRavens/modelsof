*Name: Martin Vinæs Larsen*
*Date: June 2018*
*Article: "Is the Relationship between Political Responsibility and Electoral Accountability Causal, Adaptive and Policy-specific?"*
*Reproduces: Table 2 (Logistic regression models), Figure 2 (Tests key hypotheses without to much modeling) and Figure 5 (Shows effects on different policy outcomes). 
*Data: 09rep.dta (survey data from the 2009 Danish municipal election survey)*
*Version 15.1*
*Dependencies: blindschemes, estout*

*opening 2009 municipal election survey data
use "09rep", clear

*Figure 2*

preserve
replace unemp=unemp*4

*censoring sample so that it matches up with later analyses
logit borg_vote c.unemp##c.treat c.elderly c.housing c.admin, vce(cluster muni)
keep if e(sample)==1

*calculating conditional probabilities
bysort treat unemp: egen means=mean(borg_vote)

*running simple model
reg borg_vote (c.unemp)##treat, vce(cluster muni)

*drawing control panel of figure
margins, at(unemp=(0(1)4) treat==0) 
marginsplot, nodraw scheme(plotplain) level(95) saving(a, replace) ylab(0(0.25)0.75, labsize(vlarge  )) recast(line) recastci(rline) ///
ciopts(lpattern(solid) lcolor(black*0.8)) plotopts(lwidth(thick)) xoverhangs ///
xlab(0 `" "Very" "Dissatisfied" "' 1 "Dissatisfied" 2 "Neither" 3 "Satisfied" 4 `" "Very" "Satisfied" "' ,labsize(vlarge) nogrid) ///
title(Control,  size(vlarge) ring(0)  margin(medium) pos(1) color(black*0.6)) legend(off) ///
addplot(scatter means unemp if treat==0, msym(O) msize(large) ylab(0(0.2)0.7, labsize(vlarge  ))) ///
 ytitle("Probability of voting for mayoral party", size(vlarge)) xtitle( " " "Unemployment services", size(vlarge))

 *drawing control treatment of figure
 margins, at(unemp=(0(1)4) treat==1)
marginsplot, nodraw scheme(plotplain) level(95) saving(b, replace) ylab(0(0.25)0.75, labsize(vlarge  )) recast(line) recastci(rline) ///
ciopts(lpattern(solid) lcolor(black*0.8) ) plotopts(lwidth(thick)) xoverhangs ///
xlab(0 `" "Very" "Dissatisfied" "' 1 "Dissatisfied" 2 "Neither" 3 "Satisfied" 4 `" "Very" "Satisfied" "' ,labsize(vlarge) nogrid) ///
title(Treatment, size(vlarge) ring(0)  margin(medium) pos(1) color(black*0.6)) legend(off) ///
addplot(scatter means unemp if treat==1, msym(O) msize(large) ylab(0(0.2)0.7, labsize(vlarge)) ///
|| scatteri 0.0773438 0 .3522018 4, recast(line) lpattern(dash) lwidth(medthick)) ///
 ytitle("Probability of voting for mayoral party", size(vlarge  )) xtitle(" " "Unemployment services", size(vlarge  ))

*combining panels and drawing plot
graph combine a.gph b.gph, xsize(9) scheme(plotplain) 
graph export "figure2.eps", replace
restore

*removing auxilliary files
erase "a.gph"
erase "b.gph"

**Table 2**

*Storing estimates for table 2
*model 1
eststo a: logit borg_vote (c.unemp)##treat c.admin c.elderly c.housing, vce(cluster muni)
margins, dydx(unemp) at(treat=(0 1)) post
test _b[2._at]==_b[1bn._at] 
local a=(_b[1bn._at])
local b=_b[2._at]
local c=r(p)
local d=(_se[1bn._at])
local e=_se[2._at]
est restore a
estadd scalar p=`c', replace
estadd scalar t=`a', replace
estadd scalar c=`b', replace
estadd scalar t_se=`d', replace
estadd scalar c_se=`e', replace
estadd scalar dif=`b'-`a', replace

*model 2
eststo b: logit borg_vote (c.unemp)##treat c.admin c.housing c.elderly i.localmed i.educ i.employment c.age, vce(cluster muni)
margins, dydx(unemp) at(treat=(0 1)) post
test _b[2._at]==_b[1bn._at] 
local a=(_b[1bn._at])
local b=_b[2._at]
local c=r(p)
local d=(_se[1bn._at])
local e=_se[2._at]
est restore b
estadd scalar p=`c', replace
estadd scalar t=`a', replace
estadd scalar c=`b', replace
estadd scalar t_se=`d', replace
estadd scalar c_se=`e', replace
estadd scalar dif=`b'-`a', replace

*model 3
eststo c: logit borg_vote (c.unemp)##treat  c.admin c.housing c.elderly ft_vote i.gov_may c.ideology i.localmed i.educ i.employment c.age, vce(cluster muni)
margins, dydx(unemp) at(treat=(0 1)) post
test _b[2._at]==_b[1bn._at] 
local a=(_b[1bn._at])
local b=_b[2._at]
local c=r(p)
local d=(_se[1bn._at])
local e=_se[2._at]
est restore c
estadd scalar p=`c', replace
estadd scalar t=`a', replace
estadd scalar c=`b', replace
estadd scalar t_se=`d', replace
estadd scalar c_se=`e', replace
estadd scalar dif=`b'-`a', replace

*model 4
eststo d: logit borg_vote (c.unemp)##treat  c.admin c.housing c.elderly ft_vote i.gov_may c.ideology i.localmed i.educ i.employment c.age logindv kvindpol govmayor govsupport logindb, vce(cluster muni)
margins, dydx(unemp) at(treat=(0 1)) post
test _b[2._at]==_b[1bn._at] 
local a=(_b[1bn._at])
local b=_b[2._at]
local c=r(p)
local d=(_se[1bn._at])
local e=_se[2._at]
est restore d
estadd scalar p=`c', replace
estadd scalar t=`a', replace
estadd scalar c=`b', replace
estadd scalar t_se=`d', replace
estadd scalar c_se=`e', replace
estadd scalar dif=`b'-`a', replace

*Compiling and exporting table 2
la var borg_vote "%borg"
esttab a b c d using "table2.tex", replace se label nomtitles b(%9.2f) title(Logistic regression of probability of voting for the mayoral party} \footnotesize \label{table:models) ///
keep(unemp_perf 1.treatment 1.treatment#c.unemp_perf elderly housing administration) indicate("\hline Sociodemographic controls=age" "Political controls=ideology" "Municipal level variables=govsupport",labels("$\checkmark$" " ") ) ///
varlabel(unemp_perf "Unemployment performance" 1.treatment "Treatment" 1.treatment#c.unemp_perf "Treatment * Unemployment performance" elderly "Elderly performance" housing "Housing performance" administration "Administration controls municipality") ///
stats(t t_se c c_se dif p r2_p ll N, layout (@ (@) @ (@) @ @ @ @ @) labels("AME (Control)" " " "AME (Treatment)" " " "Difference (T-C)" "\hspace{0.1in} \textit{p-value of difference}" "\hline Pseudo R$^2$" "Log likelihood " "Observations" ) fmt(%8.2f %8.2f %8.2f %8.2f %8.2f %8.2f %8.2f  %8.0f %8.0f)) ///
addnotes("Robust standard errors clustered on municipality in parentheses." "\sym{+} \(p<0.10\), \sym{*} \(p<0.05\)") star(+  0.1 * 0.05) nonotes


*Figure 5*

*creating new dataset to store estimates
tempfile data
postfile results nr b1 b2 se1 se2 p p2 using `data', replace

*Store estimates of effect of different policy areas in new dataset
local z1 "(c.elderly c.unemp_perf c.housing c.ideology)##c.treat c.admin ft_vote i.gov_may  i.localmed  i.educ i.employment c.age logindv kvindpol govmayor govsupport logindb, vce(cluster muni)"
foreach x in 2 3 4 5{
logit borg_vote `z1'
if `x' ==2 {
margins, dydx(unemp_perf elderly) at(treat=(0 1)) post coeflegend
local t="unemp_perf"
}
if `x'==3 {
margins, dydx(elderly unemp_perf) at(treat=(0 1)) post coeflegend
local t="elderly"
}
if `x'==4 {
margins, dydx(housing unemp_perf) at(treat=(0 1)) post coeflegend
local t="housing"
}
if `x'==5 {
margins, dydx(ideology unemp_perf) at(treat=(0 1)) post coeflegend
local t="ideology"
}
test _b[`t':1bn._at]=_b[`t':2._at]
local test=r(p)
if `x'>2{
test _b[`t':1bn._at]-_b[`t':2._at]=_b[unemp_perf:1bn._at]-_b[unemp_perf:2._at]
}
local test2=r(p)
post results (`x') (_b[`t':2._at]) (_b[`t':1bn._at]) (_se[`t':2._at]) (_se[`t':1bn._at]) (`test') (`test2')
}
postclose results

*opening datafile with stored estimates
use `data', clear
*re-organizing stored data
reshape long b se, i(nr) j(treat) 
xtset nr treat 
gen dif=b-l.b
replace dif=dif*-1

*storing numbers to put on graph
foreach x in 2 3 4 5 {
su dif if nr==`x'
local d: di %8.2f r(mean) 
su p if nr==`x' & treat==1
local p: di %8.2f r(mean)
local descrip`x'=subinstr("d=`d', p=`p'", " ", "",. )
}

*generating confidence intervals around estimates
gen ub1=b+1.96*se
gen lb1=b-1.96*se
gen ub2=b+1.64*se
gen lb2=b-1.64*se

*small adjustments to make graph more visually appealing
replace nr=nr+0.15 if treat==1
replace nr=nr-0.15 if treat==2

*drawing extra lines.
local plot1="scatteri -.05 1.85 -.05 2.15, recast(line) lpattern(solid) lcolor(black) ||"
local plot2="scatteri -.05 1.85 -.025 1.85, recast(line) lpattern(solid) lcolor(black) ||"
local plot3="scatteri -.05 2.15 0.02 2.15, recast(line) lpattern(solid) lcolor(black) ||"
local plot4="scatteri -.06 2.85 -.06 3.15, recast(line) lpattern(solid) lcolor(black) ||"
local plot5="scatteri -.06 2.85 -.02 2.85, recast(line) lpattern(solid) lcolor(black) ||"
local plot6="scatteri -.06 3.15 -0.035 3.15, recast(line) lpattern(solid) lcolor(black) ||"
local plot7="scatteri .25 3.85 .25 4.15, recast(line) lpattern(solid) lcolor(black) ||"
local plot8="scatteri .25 3.85 .19 3.85, recast(line) lpattern(solid) lcolor(black) ||"
local plot9="scatteri .25 4.15 .2 4.15, recast(line) lpattern(solid) lcolor(black) ||"
local plot10="scatteri .25 4.85 .25 5.15, recast(line) lpattern(solid) lcolor(black) ||"
local plot11="scatteri .25 4.85 .17 4.85, recast(line) lpattern(solid) lcolor(black) ||"
local plot12="scatteri .25 5.15 .2 5.15, recast(line) lpattern(solid) lcolor(black) ||"

*drawing figure
twoway  ///
`plot1' `plot2' `plot3' `plot4' `plot5' `plot6' `plot7' `plot8' `plot9'  `plot10' `plot11' `plot12' ///
 rspike ub1 lb1 nr,  lwidth(medthick)  xsize(7) lcolor(black) || ///
 rspike  ub2 lb2 nr,  lwidth(thick)   lcolor(black)  ///
|| scatter  b nr if treat==1, scheme(plotplain) mcolor(black) msym(o) msize(vlarge)   ///
|| scatter  b nr  if treat==2, mcolor(white) msym(o) mlwidth(medthick)  mlcolor(black) msize(vlarge) ///
  ylabel(-0.2(0.1)0.4, labsize(medlarge)) ytitle("AME on Support for Mayoral Party", size(medlarge)) ///
  yline(0, lpattern(dash)) ytick(-0.2(0.1)0.4) ymtick(-0.2(0.05)0.4) ///
  xlabel(5 `" " " "Ideology" "' 4 `" " " "Housing" "' 3 `" " " "Elderly" "' 2  `" " " "Unemployment" "', notick nogrid angle(0) labsize(medlarge)) xtitle(" ") xtick(1.5(1)5.5) ///
  legend(style(background) color(none) cols(1) position(4) bmargin(tiny) ///
order(15 16)  label(15 "Treatment") label(16 "Control") size(medlarge)) ///
text(-0.075 2 "`descrip2'", size(medlarge)) text(-0.085 3 "`descrip3'", size(medlarge)) text(.28 4 "`descrip4'" , size(medlarge)) text(.28 5 "`descrip5'", size(medlarge))

*exporting figure
graph export "figure5.eps", replace


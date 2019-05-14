*APSR replication files
*Title: When Do Citizens Respond Politically to the Local Economy? Evidence from Registry Data on Local Housing Markets
*Authors: Frederik Hjorth, Martin Vinæs Larsen, Peter Thisted Dinesen and Kim Mannemar Sønderskov.

*FILE PURPOSE: Produces Tables and Figures for Precinct Level Analysis (except Figure 4) and the Appendix Table E1.
*VERSION: STATA 15.1
*REQUIRED PACKAGES: plotplain, esttab

*opening data
use "replidata.dta", clear


*time series analysis
xtset valgstedid eleccount

*******************
***Standard model:*
*******************
tempvar cont 
gen `cont'=1 ///empty variable used to make esttab function indicate work

*sets up the models
local z1=", vce(cluster valgstedid)" //bivariate
local z2="i.year  , vce(cluster valgstedid)" //year
local z3="i.year `cont' ,  fe vce(cluster valgstedid)" //DiD
local z4="c.unemprate c.medianinc c.grow  i.year `cont', fe vce(cluster valgstedid)" //DiD+econ


*standard set of models
foreach x in 1 2 3 4{
qui eststo m1`x': xtreg incs c.hp_1yr `z`x''
qui margins, dydx(hp_1yr) saving(m1`x', replace) noestimcheck
}

*TABLE 1
esttab m11 m12 m13 m14 using table1.tex, keep(hp_1yr grow medianinc unemprate) replace ///
star("*" 0.05) se nomtitles b(%9.3f) indicate("\hline Year FE=2007.year " " Precinct FE=__000000" , labels("$\checkmark$" " ")) ///
label stats(N rmse, fmt(%8.0f %8.3f %8.3f)  label( "Observations" "RMSE"))  title(Estimated effects of housing prices on  electoral support for governing parties.} \label{predv)



**************
***Placebo:***
**************

foreach x in 1 2 3 4{
qui eststo placebo`x': xtreg l.inc c.hp_2yr `z`x''
 margins, dydx(hp_2yr) saving(placebo`x', replace) noestimcheck
}

*Figure 1
preserve
use m11.dta, clear
append using m12.dta
append using m13.dta
append using m14.dta
append using placebo1.dta
append using placebo2.dta
append using placebo3.dta
append using placebo4.dta

gen model=_n
replace model=model-4 if _n >4
replace model=model+0.1 if _n >4
replace model=model-0.1 if _n <5
gen dv=0
replace dv=1 if _n>4

gen _ci_lb2=-_se*1.64+_margin
gen _ci_ub2=_se*1.64+_margin

twoway rspike _ci_lb _ci_ub model,  lcolor(black)  || ///
rspike _ci_lb2 _ci_ub2 model, scheme(plotplain) lcolor(black) lwidth(thick) || ///
scatter _margin model if dv==0, msym(O) msize(large) mlwidth(medthick) mlcolor(black) mfcolor(black) || ///
scatter _margin model if dv==1, msym(O) msize(large) mlwidth(medthick) mlcolor(black) mfcolor(white)  ///
yline(0) ylab(-0.05(0.05)0.15,  labsize(medlarge)) xtitle(" ") ///
xlab(1 "Bivariate" 2 "+ Year FE" 3 "+ Precinct FE" 4 "+ Controls", labsize(medlarge) nogrid) ///
ytitle("Effect size", size(medlarge)) xlines(5.75) /// 
legend( order(3 4) label(3 "t") label(4 "t-1") size(medlarge) pos(4)) xsize(7) 

graph export "figure2.eps", replace
restore

******************
***Interaction:***
******************

*examining distribution of interaction and saving percentiles.
su logntrades, d
local i=0
foreach x in 25 50 75 {
local i=1+`i'
local p`i'=r(p`x')
}

*running models and storing estimates for graph
foreach x in 1 2 3 4{
 eststo m5`x': xtreg inc c.hp_1yr##c.logntrades   `z`x''
 margins, dydx(hp_1yr) at(logntrades=(`p1' `p2' `p3')) level(95) saving(margin`x', replace) noestimcheck
}

*Table 2
esttab m51 m52 m53 m54 using table2.tex, keep(hp_1yr c.hp_1yr#c.logntrades logntrades unemprate grow medianinc) replace ///
star("*" 0.05) se nomtitles b(%9.3f) indicate("\hline Precinct FE=__000000" " Year FE = 2007.year" , labels("$\checkmark$" " ")) ///
label stats(N rmse, fmt(%8.0f %8.3f )  label( "Observations" "RMSE"))  title(Estimated effects of housing price across number of trades.} \label{table:econactivity)


*Figure 3
preserve
use margin1, clear
append using margin2
append using margin3
append using margin4
gen model=_n
replace model=model+2 if _n >3
replace model=model+2 if _n >6
replace model=model+2 if _n >9
gen _ci_lb2=-_se*1.64+_margin
gen _ci_ub2=_se*1.64+_margin
drop if _at==2
twoway rspike _ci_lb _ci_ub model,  lcolor(black)  || ///
rspike _ci_lb2 _ci_ub2 model, scheme(plotplain) lcolor(black) lwidth(thick) || ///
scatter _margin model if _at==1, msym(O) msize(large) mlwidth(medthick) mlcolor(black) mfcolor(white) ||  ///
scatter _margin model if _at==3, msym(O) msize(large) mlwidth(medthick) mlcolor(black) mfcolor(black)  ///
ylab(-0.05(0.05)0.2,  labsize(medlarge)) xtitle(" ")    ///
xlab(2 "Bivariate" 7 "+ Year FE" 12 "+ Precinct FE" 17 "+ Controls",labsize(medlarge) nogrid) ///
ytitle("Effect on Support for the Governing Parties" "across number of trades", size(medlarge)) ylines(0) ///
legend( order (4 3)  label(3 "At the 25th percentile") label(4 "At the 75th percentile") size(medlarge) pos(4) ) xsize(7)
graph export "figure3.eps", replace
restore



*****************
***Robustness:***
*****************

*storing estimates for different models.

*two year housing prices
qui eststo m24: xtreg incs c.hp_2yr `z4'
qui eststo n24: xtreg incs c.hp_2yr##c.logntrades `z4'


*first differenced controls
local z4="c.unemprate_fd c.grow c.medianinc_fd i.year `cont', fe " //
qui eststo m34: xtreg incs c.hp_1yr `z4'
qui eststo n34: xtreg incs c.hp_1yr##c.logntrades `z4'

*first differenced model
local z4="c.unemprate_fd c.grow c.medianinc_fd i.year `cont', vce(cluster valgstedid)" //
preserve
gen logn2=logntrades-l.logntrades
drop logntrades
rename logn2 logntrades
qui eststo m44: xtreg d_inc  c.hp_1yr `z4' 
eststo n44: xtreg d_inc  c.hp_1yr##c.logntrades `z4' 
restore


*positive negative
local z4="c.unemprate c.grow c.medianinc i.year `cont', fe vce(cluster valgstedid)" //DiD+econ

qui eststo m64: xtreg incs  c.hp_1yrpos c.hp_1yrneg   `z4'
qui eststo n64: xtreg incs  (c.hp_1yrpos c.hp_1yrneg)##c.logntrades   `z4'


*lagged dv instead of FE
local z4="c.unemprate c.grow c.medianinc i.year l.inc, re vce(cluster valgstedid)" //

qui eststo m74: xtreg incs c.hp_1yr `z4'
qui eststo n74: xtreg incs c.hp_1yr##c.logntrades `z4'


*prime minister
local z4="c.unemprate c.grow c.medianinc i.year `cont', fe vce(cluster valgstedid)" //
qui eststo m84: xtreg pm c.hp_1yr `z4'
qui eststo n84: xtreg pm c.hp_1yr##c.logntrades `z4'



*Joint Appendixtable E1 (large)
esttab m24 n24  m34 n34 m44 n44 m74 n74 m64 n64 m84 n84 using tablee1.tex, replace substitute({table} {sidewaystable})  ///
keep(hp_1yr hp_2yr hp_1yrposchange hp_1yrnegchange logntrades c.hp_1yr#c.logntrades c.hp_2yr#c.logntrades c.hp_1yrposchange#c.logntrades c.hp_1yrnegchange#c.logntrades grow medianinc unemprate medianinc_fd unemprate_fd L.incsupport) /// 
order(hp_1yr hp_2yr hp_1yrposchange hp_1yrnegchange logntrades c.hp_1yr#c.logntrades c.hp_2yr#c.logntrades c.hp_1yrposchange#c.logntrades c.hp_1yrnegchange#c.logntrades medianinc grow unemprate medianinc_fd unemprate_fd L.incsupport) /// 
star("*" 0.05) se nomtitles b(%9.3f) indicate("\hline Precinct FE=__000000" " Year FE = 2007.year" , labels("$\checkmark$" " ")) ///
label stats(N rmse, fmt(%8.0f %8.3f %8.3f)  label( "Observations" "RMSE"))  title(Robustness checks of the Precinct-level data.} \footnotesize \label{apdxprerobust) ///
addnotes("Models 5 and 6 have a first-differenced version of the dependent variable, models 11 and 12 have support for the prime minister party as the dependent variable") nogaps


**Creating table 3 using estimates stored above
foreach v in 1 2 {
foreach x in 2 3 4 7 6 8  {
foreach z in b se {
if `v'==1 {
estimates restore m`x'4

if `x'==2{
local `v'`x'`z'=(_`z'[hp_2yr])
}
if `x'==6{
local `v'`x'`z'a=(_`z'[hp_1yrposchange])
local `v'`x'`z'b=(_`z'[hp_1yrnegchange])

}
if `x' !=6 & `x'!=2 {
local `v'`x'`z'=(_`z'[hp_1yr])
}
}

if `v'==2 { 
estimates restore n`x'4

if `x'==2{
local `v'`x'`z'=_`z'[c.hp_2yr#c.logntrades]
}
if `x'==6{
local `v'`x'`z'a=_`z'[c.hp_1yrposchange#c.logntrades]
local `v'`x'`z'b=_`z'[c.hp_1yrnegchange#c.logntrades]

}
if `x' !=6 & `x'!=2 {
local `v'`x'`z'=_`z'[c.hp_1yr#c.logntrades]
}
}

}
}
}
file open anyname using table3.txt, write text replace
file write anyname  _newline  _col(0)  "\begin{table}[htbp] \footnotesize \centering \caption{Robustness of the Average Effect and the Interaction Term} \label{robustness} \begin{tabular}{l*{3}{c}}\hline\hline"
file write anyname _newline _col(0) "&Average Effect & Interaction Term \\  \hline "
foreach x in 2 3 4 7 6 8  {
if `x'==2 {
local t="Two year change" 
}
if `x'==3 {
local t="First Differenced Controls" 
}
if `x'==4 {
local t="First Differenced DV" 
}
if `x'==7 {
local t="Lagged DV" 
}
if `x'==8 {
local t="Prime Minister" 
}
if `x'==6 {
file write anyname _newline "Positive changes &"_tab %9.2f (`1`x'ba') "* &" _tab %9.2f  (`2`x'ba')  "* \\"
file write anyname _newline " &" _tab %9.2f "(" (`1`x'sea') ")" " &" _tab %9.2f  "(" (`2`x'sea') ")"  " \\"
file write anyname _newline "Negative changes&"_tab %9.2f (`1`x'bb') " &" _tab %9.2f  (`2`x'bb')  "* \\"
file write anyname _newline " &" _tab %9.2f  "(" (`1`x'seb') ")" " &" _tab %9.2f  "(" (`2`x'seb') ")" " \\"
}
if `x'!=6 {
file write anyname _newline " `t' &"_tab %9.2f (`1`x'b') "* &" _tab %9.2f  (`2`x'b')  "* \\"
file write anyname _newline " &" _tab  "(" %9.2f  (`1`x'se') ")" " &" _tab %9.2f "(" (`2`x'se') ")"  " \\"
}
}
file write anyname _newline _col(0) "\hline"
file write anyname _newline "Year FE &"_tab %9.2f "\checkmark &" _tab  "\checkmark  \\"
file write anyname _newline "Precinct FE &"_tab %9.2f "\checkmark &" _tab  "\checkmark  \\"
file write anyname _newline "Economic Controls &"_tab  "\checkmark &" _tab  "\checkmark  \\"
file write anyname _newline _col(0) "\hline \hline"
file write anyname _newline _col(0) "\multicolumn{3}{l}{See Appendix \ref{app_robustpred} for the full models} \\"
file write anyname _newline _col(0) "\multicolumn{3}{l}{*p<0.05}"
file write anyname _newline _col(0) "\end{tabular}"
file write anyname _newline _col(0) "\end{table}"
file close anyname




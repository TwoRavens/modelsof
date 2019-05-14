*APSR replication files
*Title: When Do Citizens Respond Politically to the Local Economy? Evidence from Registry Data on Local Housing Markets
*Authors: Frederik Hjorth, Martin Vinæs Larsen, Peter Thisted Dinesen and Kim Mannemar Sønderskov.


*FILE PURPOSE: Produces Figure 4 and all graphs and tables from the Appendix except Table E1 (see other replication file).
*VERSION: STATA 15.1
*REQUIRED PACKAGES: plotplain, esttab


*opening data
use "replidata.dta", clear

*generating extra variable needed for analysis
tsset  valgstedid eleccount
gen diftrades=logntrades-l.logntrades

*time series analysis
xtset valgstedid year

****************************
***Descriptive Statistics:**
****************************

*Table C1
preserve
replace voters=log(voters)
la var voters "Log(voters)"
la var diftrades "Change in Log(Trades)"
drop zipy eleccount valgstedid muni zip pop year lvprice o
foreach x in a b c v {
replace `x'=`x'*100
}
la var calc "Estimated vote returns"
order incs pm a b c v d_inc, first
file open anyname using tablec1.txt, write text replace
file write anyname  _newline  _col(0)  "\begin{table}[htbp] \footnotesize \centering \caption{Descriptive statistics, Precinct-level data} \label{desall} \begin{tabular}{l*{10}{c}}\hline\hline"
file write anyname _newline _col(0) "&Mean & SD & Min& Max& n \\  \hline "
foreach x of varlist * {
su `x' , d
file write anyname _newline (`"`: var label `x''"') "  &" _tab %9.2f  (r(mean)) " &" _tab %9.2f (r(sd)) " &" _tab %9.2f  (r(min)) " &" _tab %9.2f  (r(max)) " &" _tab %9.0f  (r(N)) " \\"
}
file write anyname _newline _col(0) "\hline\hline \\"
file write anyname _newline _col(0) "\multi-column{6}{l}{$\Delta$ signifies year over year change; the word ``changes'' election over election change.}"
file write anyname _newline _col(0) "\end{tabular}"
file write anyname _newline _col(0) "\end{table}"
file close anyname
restore

*Figure C1
hist hp_1yr, scheme(plotplain) width(0.5) freq ylabel(0(10)120) lcolor(black*0.8) ///
xtitle(Changes in Housing prices (%), size(medlarge))  ///
ytitle(Frequency, size(medlarge)) ylab(,labsize(medlarge)) xlab(,labsize(medlarge) nogrid)
graph export "figurec1.eps", replace


*****************************
***Party-specific analysis***
*****************************
preserve
keep hp_1yr unemprate medianinc grow incs year valgstedid a b c v logntrades
gen incA=0
replace incA=1 if  year==2015 
gen inc1=(a+b)*100
gen inc0=(c+v)*100
egen group= group(valgstedid year)
reshape long inc, i(group) j(party)
egen party_valgsted= group(party valgsted)
qui eststo partyspec: reghdfe inc c.hp_1yr##c.incA##c.party c.unemprate c.grow c.medianinc , absorb(valgstedid year) vce(cluster party_valgsted)

la var incA "Left-wing Incumbent"
la var party "Left-wing Support"


*table D1
esttab partyspec using tabled1.tex, keep(hp_1yr c.hp_1yr#c.incA c.hp_1yr#c.party c.incA#c.party c.hp_1yr#c.incA#c.party unemprate medianinc grow) replace ///
star("*" 0.05) se nomtitles b(%9.3f) addnotes(Model includes year and precinct fixed effects.) ///
label stats(N, fmt(%8.0f )  label( "Observations"))  title(Party Specific Analysis.} \label{partyspecifictab)


*Figure 4
tempfile margin1
margins, dydx(hp_1yr) at(incA=(0 1) party=(0 1)) noestimcheck saving(`margin1', replace)
use `margin1', clear
gen _ci_lb2=-_se*1.64+_margin
gen _ci_ub2=_se*1.64+_margin
gen id=_n
recode id (1=4) (2=3) (3=2) (4=1) //making sure left-wingers are on the left of the graph
replace id=id+0.5 if id >2
replace id=id+0.1 if id ==1 | id==3.5
replace id=id-0.1 if id ==2 | id==4.5
twoway rspike _ci_lb _ci_ub id,  lcolor(black)  || ///
rspike _ci_lb2 _ci_ub2 id, scheme(plotplain) lcolor(black) lwidth(thick) || ///
scatter _margin id if _at3==0, msym(O) msize(large) mlwidth(medthick) mlcolor(black) mfcolor(white) ||  ///
scatter _margin id if _at3==1, msym(O) msize(large) mlwidth(medthick) mlcolor(black) mfcolor(black)  ///
ylab(-0.1(0.05)0.15,  labsize(medlarge)) xtitle(" ")   ///
xlab(0.5 " " 1.5 "Left-Wing in Office" 4 "Right-Wing in Office" 5 " ",labsize(medlarge) nogrid) ///
ytitle("Party Specific Effects on Electoral Support ", size(medlarge)) ylines(0) ///
legend( order (4 3) title(Support for)  size(medlarge)  label(3 "Right-wing coalition") label(4 "Left-wing coalition")  pos(4) ) xsize(7)
graph export "figure4.eps", replace
restore



******************
***Lag structure**
******************
tempvar hp cont
gen `hp'=.
gen `cont'=1
foreach x in _lag1 _lag2 _lag3 _1yr  _lag5 _lag6 _lag7 _2yr { 
replace `hp'=hp`x'
eststo `x': qui xtreg inc `hp'  i.year c.grow medianinc unemprate `cont' , fe vce(cluster valgstedid)
}

*Table F1
esttab  _lag1 _lag2 _lag3 _1yr  _lag5 _lag6 _lag7 _2yr using tablef1.tex, keep(__000000 unemprate grow medianinc) replace ///
star("*" 0.05) se b(%9.3f) indicate("\hline Precinct FE=__000001" " Year FE = 2007.year" , labels("$\checkmark$" " ")) ///
label stats(N rmse, fmt(%8.0f %8.3f )  label( "Observations" "RMSE"))  title(Models with different definitions of the change in housing price variable} \footnotesize \label{lagmodels) ///
 varlabel(__000000 "$\Delta$ housing price") mtitle("1 QTR" "2 QTR" "3 QTR" "1 YRS" "5 QTR" "6 QTR" "7 QTR" "2 YRS") ///
 addnote("Model (1) measures changes from one quarter before the election, model (2) two quarters before the election and so on.")


**********************************
***Correlation with Interaction***
**********************************

tsset  valgstedid eleccount
scatter  hp_1yr logntrades || fpfitci hp_1yr logntrades, scheme(plotplain) ytitle(Change in Housing Prices, size(medlarge)) ///
xtitle("Log(Trades)", size(medlarge)) legend(off) ylab(,labsize(medlarge)) xlab(,labsize(medlarge)) name(abs, replace)

scatter  hp_1yr diftrades || fpfitci hp_1yr diftrades, scheme(plotplain)  ytitle(Change in Housing Prices, size(medlarge))  ///
xtitle("Change in Log(Trades)", size(medlarge)) legend(off) ylab(,labsize(medlarge)) xlab(-2.5(1.25)2.5,labsize(medlarge)) name(dif, replace)

*Figure H1
graph combine  abs dif, scheme(plotplain) xsize(7) 
graph export "figurh1.eps", replace

*correlations reported in manuscript
pwcorr hp_1yr diftrades logntrades, obs sig

******************************
***Interaction (HMX style):***
******************************

*sets up models
local z1=", vce(cluster valgstedid)" //bivariate
local z2="i.year  , vce(cluster valgstedid)" //year
local z3="i.year,  fe vce(cluster valgstedid)" //DiD
local z4="c.unemprate c.grow c.medianinc i.year, fe vce(cluster valgstedid)" //DiD+econ

*calculating terciles
reg incs hp_1yr c.unemprate c.medianinc i.year `cont' logntrades
ta logntrades if e(sample)==1
gen terciles=0
replace terciles =1 if logntrades > 3.091043
replace terciles =2 if logntrades >  4.043051

*calcularing median of tercile
tabstat logntrades, stats(p50) by(terciles)
*generating new variale that is distance to median of tercile
gen logntrades_dif= (logntrades-2.197225) if tercile==0
replace logntrades_dif= (logntrades-3.583519) if tercile==1
replace logntrades_dif= (logntrades-4.543295) if tercile==2

*estim
foreach x in 1 2 3 4{
xtreg inc (c.logntrades_dif c.hp_1yr c.hp_1yr#c.logntrades_dif)##tercile   `z`x''
 margins, dydx(hp_1yr) at(terciles=(0 1 2)) level(95) saving(margin`x', replace) noestimcheck
}



*Figure J1
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
twoway rspike _ci_lb _ci_ub model,  lcolor(black)  || ///
rspike _ci_lb2 _ci_ub2 model, scheme(plotplain) lcolor(black) lwidth(thick) || ///
scatter _margin model if _at==1, msym(O) msize(large) mlwidth(medthick) mlcolor(black) mfcolor(white) ||  ///
scatter _margin model if _at==2, msym(O) msize(large) mlwidth(medthick) mlcolor(black) mfcolor(black*0.4) ||  ///
scatter _margin model if _at==3, msym(O) msize(large) mlwidth(medthick) mlcolor(black) mfcolor(black)  ///
ylab(-0.1(0.1)0.3,  labsize(medlarge)) xtitle(" ")    ///
xlab(2 "Bivariate" 7 "+ Year FE" 12 "+ Precinct FE" 17 "+ Controls",labsize(medlarge) nogrid) ///
ytitle("Effect on Support for the Governing Parties" "across number of trades", size(medlarge)) ylines(0) ///
legend( order (5 4 3)  label(3 "Lowest Tercile") label(4 "Middle Tercile") label(5 "Top Tercile")  pos(4) ) xsize(7)
graph export "figurej1.eps", replace
restore





**********************************
***Additional Interactions********
**********************************
replace voters=log(voters)
la var voters "Log(voters)"
eststo a: xtreg inc (c.hp_1yr)##(c.logntrades c.voters) i.year grow medianinc unemprate `cont', fe

eststo b:  xtreg inc (c.hp_1yr c.unemprate)##(c.logntrades) i.year grow medianinc `cont', fe

*result reported in main tex
su logntrades, d
local a=r(p75)
local b=r(p25)
margins, dydx(unemprate) at(logntrades=(`b' `a'))

*Table I1
esttab a b using tablei1.tex, keep(hp_1yr c.hp_1yr#c.logntrades c.unemprate#c.logntrades c.hp_1yr#c.voters voters logntrades unemprate grow medianinc) replace ///
star("*" 0.05) se nomtitles b(%9.3f) indicate("\hline Precinct FE=__000001" " Year FE = 2007.year" , labels("$\checkmark$" " ")) ///
label stats(N rmse, fmt(%8.0f %8.3f )  label( "Observations" "RMSE"))  title(Some additional interactions} \footnotesize \label{addinter)


***********************************
***Does Results vary by Estimates**
***********************************


eststo a: xtreg inc hp_1yr i.year medianinc grow unemprate `cont' if calc==0, fe
eststo b:  xtreg inc (c.hp_1yr)##(c.logntrades) i.year grow medianinc unemprate `cont' if calc==0, fe

*Table J1
esttab a b using tablej1.tex, keep(hp_1yr c.hp_1yr#c.logntrades logntrades unemprate grow medianinc) replace ///
star("*" 0.05) se nomtitles b(%9.3f) indicate("\hline Precinct FE=__000001" " Year FE = 2007.year" , labels("$\checkmark$" " ")) ///
label stats(N rmse, fmt(%8.0f %8.3f )  label( "Observations" "RMSE"))  title(Main results excluding amalgamated precincts} \footnotesize \label{calculated)








* GENERAL INFO
	* Project: Do Men and Women Have Different Policy Preferences in Africa? Determinants and Implications of Gender Gaps in Policy Prioritization
	* Created by: Amanda Robinson
	* Date created: December 2014
	* Updated by: Jessica Gottlieb, Guy Grossman
* DO FILE INFO
	* This .do file conducts all analyses and produces figures and tables for the published article.

********************************************************************************
clear
qui: do "ANALYSES/AB/GGR_DatasetConstruction.do"
********************************************************************************

************************************
* Seemingly unrelated regression
* pooled with country fixed effects
************************************
set more off
use "ANALYSES/AB/GGR_FinalData.dta", clear

global outcomes Economy Poverty Infrastructure Health Water Education Agriculture Violence Rights  Services  None
global main Economy Poverty  Health  Water
global min_controls count2
global full_controls age urban primary count2

* Using SVY/SUEST
svyset URBRUR [pweight=Withinwt], strata(REGION) singleunit(certainty)
svydescribe

foreach y in $outcomes {
svy: reg `y' female $min_controls i.ccodecow i.ROUND, dof(5) 
est sto `y'
}

suest $outcomes, cformat(%9.3f)
test female

*create regression table
esttab Economy Poverty Infrastructure Water Agriculture using "Drafts/Tables/suest_main1.tex", star(* 0.10 ** 0.05 *** 0.01) se b(3) se(3) r2(2) label booktabs alignment(D{.}{.}{-1}) replace ///
	keep(female $min_controls) stats(N,layout("\multicolumn{1}{c}{@}") labels("Observations") f(0)) ///
	title(Impact of Gender on the Likelihood of Policy Domain Prioritization\label{tab:suest1})  ///
	nonotes ///
	addnote("Pooled seemingly unrelated regression analyses with country fixed effects." "Standard errors are in parentheses. $^* p<0.10$, $^{**} p<0.05$, $^{***} p<0.01$")
esttab Violence Health Rights  Education Services using "Drafts/Tables/suest_main2.tex", star(* 0.10 ** 0.05 *** 0.01) se b(3) se(3) r2(2)   label booktabs alignment(D{.}{.}{-1}) replace ///
	keep(female $min_controls) stats(N,layout("\multicolumn{1}{c}{@}") labels("Observations") f(0)) ///
	title(Impact of Gender on the Likelihood of Policy Domain Prioritization\label{tab:suest2})  ///
	nonotes ///
	sub("Social/Political Rights" "Rights") ///
	addnote("Pooled seemingly unrelated regression analyses with country fixed effects." "Standard errors are in parentheses. $^* p<0.10$, $^{**} p<0.05$, $^{***} p<0.01$")

*graph coef plot
preserve
parmest, label format(estimate min95 max95 p %8.2f ) norestore 
keep if  parm=="female"
gen ids=_n

gen outcome =1 if eq=="Economy"
replace outcome =2 if eq=="Poverty"
replace outcome =3 if eq=="Infrastructure"
replace outcome =4 if eq=="Health"
replace outcome =5 if eq=="Water"
replace outcome =6 if eq=="Education"
replace outcome =7 if eq=="Agriculture"
replace outcome =8 if eq=="Violence"
replace outcome =9 if eq=="Rights"
replace outcome =10 if eq=="Services"

lab define outcomes 1 "Economy" 2 "Poverty" 3 "Infrastructure" 4 "Health" 5 "Water" 6 "Education" 7 "Agriculture" 8 "Violence" 9 "Rights" 10 "Services", modify
lab value outcome outcomes

twoway (rspike min95 max95 outcome, hor lc(black) lw(thin) ) ///
	(scatter outcome estimate , msize(medsmall) ms(O) mc(black)) ///
	, ///
	legend(off) ///
	scheme(s2mono) graphregion(fcolor(white)) ///
	yscale(rev) ///
	ylabel(#12, angle(horizontal) valuelabel labs(2.2) nogrid) ///
	xlabel(#6, labs(2.2)) ///
	xline(0, lpattern(shortdash)) ///
    xtitle("Impact of Gender (Female) on Likelihood of Policy Domain Prioritization" "SUR Pooled OLS Analysis with Country Fixed Effects, 95% CIs" , size(2.2)) ytitle("")
graph save "DATA/Afrobarometer/Graphs/suest_main", replace
graph export "Drafts/Figures/suest_main.pdf", replace
restore

*graph predicted probabilities
postfile pp str15 var str15 female pp pp_se pooled str15 sample str15 controls using "DATA/Afrobarometer/Graphs/pp.dta", replace
foreach y in $outcomes {
est restore `y'
qui: margins, at(female=(0 1)) atmeans 
matrix A=r(table)
post pp ("`y'") ("Men") (A[1,1]) (A[2,1]) (1) ("Pooled") ("Min")
post pp ("`y'") ("Women") (A[1,2]) (A[2,2]) (1) ("Pooled") ("Min")
}
postclose pp

preserve
use "DATA/Afrobarometer/Graphs/pp.dta", clear
gen min95=pp-(pp_se*1.96)
gen max95=pp+(pp_se*1.96)
gen id=_n
gen axis=id*-1
sort axis
sencode var, gen(outcome)
replace outcome=outcome + 0.25 if female=="Men"

twoway (rspike min95 max95 outcome if female=="Men" & sample=="Pooled" & controls=="Min", hor lc(black) lw(thin)) ///
	(scatter outcome pp if female=="Men" & sample=="Pooled" & controls=="Min", msize(medsmall) ms(O) mfc(white) mlc(black)) ///
	(rspike min95 max95 outcome if female=="Women" & sample=="Pooled" & controls=="Min", hor lc(black) lw(thin)) ///
	(scatter outcome pp if female=="Women" & sample=="Pooled" & controls=="Min", msize(medsmall) ms(O) mc(black)) ///
, ///
	legend(order(2 "Men" 4 "Women") size (vsmall) row(2) region(lw(none) fc(none)) ring(0) pos(5) ) ///
	scheme(s2mono) graphregion(fcolor(white)) ///
	ylabel(#10, angle(horizontal) valuelabel labs(2.2) nogrid) ///
	xlabel(#6, labs(2.2)) ///
    xtitle("Predicted Probability of Policy Domain Prioritization" "SUR Pooled OLS Analysis with Country Fixed Effects, 95% CIs", size(2.2)) ytitle("")
graph save "DATA/Afrobarometer/Graphs/pooled_pp", replace
graph export "Drafts/Figures/suest_pp.pdf", replace
restore


*********************************************
			* Multi-Level Models *
*********************************************

use "ANALYSES/AB/GGR_FinalData.dta", clear
set more off
global ivs femploy vulA muslimshare 
global controls age urban  
global shortlist1 Water Infrastructure 
global shortlist2 Poverty

*Run analysis of  interactions 
set more off
foreach var of varlist  $shortlist1 $shortlist2 {
mixed `var' i.female##i.employment##c.femploy i.female##i.edgap##c.vulA i.female##i.muslim i.female##c.age i.female##i.urban i.female##c.muslimshare i.female##c.gdp i.ROUND [pw=Withinwt] || country: 
estimates store `var'
}

*graph predicted rate of prioritization by gender, individualIVs, and country IVs
set more off
foreach y in  $shortlist1 $shortlist2{
estimates res `y'
estimates esample: `y' female muslim employment edgap muslimshare femploy vulA $controls gdp ROUND, replace

qui: margins, by(female employment) atmeans vsquish
marginsplot, plotdimension(female) noci  ///
		plot1opts(msymbol(S) mcolor(black) lcolor(black))  /// marker for first line
		plot2opts(msymbol(O) mcolor(gs10) lcolor(gs10)) /// marker for second line
		ytitle ("Predicted Rate of `y' Prioritization",size(small)) title("") ///
		graphregion(fcolor(white) ilcolor(white) lcolor(white)) scale(1.2) name(`y'_pei, replace) ///
		legend (order (1 "Male" 2 "Female") region(lcolor(white)))

qui: margins, at(female=(0 1) employment=(0 1) femploy=(.07(.1).57)) atmeans vsquish
marginsplot, plotdimension(female employment) noci  ///
		plot1opts(msymbol(S) mcolor(black) lcolor(black))  /// marker for first line
		plot2opts(msymbol(O) mcolor(black) lcolor(black))  /// marker for second line
		plot3opts(msymbol(S) mcolor(gs10) lcolor(gs10)) /// marker for third line
		plot4opts(msymbol(O) mcolor(gs10) lcolor(gs10)) /// marker for fourth line
		ytitle ("Predicted Rate of `y' Prioritization",size(small)) title("") ///
		graphregion(fcolor(white) ilcolor(white) lcolor(white)) scale(1.2) name(`y'_pec, replace) ///
		legend (order (1 "Male, unemployed" 2 "Male, employed" 3 "Female, unemployed" 4 "Female, employed") region(lcolor(white)))

qui: margins, by(female edgap) atmeans vsquish
marginsplot, plotdimension(female) noci  ///
		plot1opts(msymbol(S) mcolor(black) lcolor(black))  /// marker for first line
		plot2opts(msymbol(O) mcolor(gs10) lcolor(gs10)) /// marker for second line
		ytitle ("Predicted Rate of `y' Prioritization",size(small)) title("") ///
		graphregion(fcolor(white) ilcolor(white) lcolor(white)) scale(1.2) name(`y'_pvi, replace) ///
		legend (order (1 "Male" 2 "Female") region(lcolor(white)))

qui: margins, at(female=(0 1) edgap=(0 1) vulA=(-1.6(.2)1.2)) atmeans vsquish
marginsplot, plotdimension(female edgap) noci  ///
		plot1opts(msymbol(S) mcolor(black) lcolor(black))  /// marker for first line
		plot2opts(msymbol(O) mcolor(black) lcolor(black))  /// marker for second line
		plot3opts(msymbol(S) mcolor(gs10) lcolor(gs10)) /// marker for third line
		plot4opts(msymbol(O) mcolor(gs10) lcolor(gs10)) /// marker for fourth line
		ytitle ("Predicted Rate of `y' Prioritization",size(small)) title("") ///
		graphregion(fcolor(white) ilcolor(white) lcolor(white)) scale(1.2) name(`y'_pvc, replace) ///
		legend (order (1 "Male, not vulnerable" 2 "Male, vulnerable" 3 "Female, not vulnerable" 4 "Female, vulnerable") region(lcolor(white)))
		
graph combine `y'_pei `y'_pvi `y'_pec `y'_pvc, title("`y'", color(black)) col(2) graphregion(fcolor(white) ilcolor(white) lcolor(white)) ycommon scale(.7)
graph export "Drafts/Figures/`y'_PP.pdf", replace
}

*graph marginal effects of gender by individual and country IVs (done over two loops to remove zero line for poverty)
set more off
foreach y in $shortlist1 {
estimates res `y'
estimates esample: `y' female muslim employment edgap muslimshare femploy vulA $controls gdp ROUND, replace

qui: margins, dydx(female) by(employment) atmeans vsquish 
marginsplot, recast(scatter) yline(0, lcolor(red)) title("") xtitle("Employed") ///
	ytitle ("Marginal Effect of Female on the Pr(`y' Prioritization)",size(small)) ylabel(, nogrid) ///
	plot1opts(msymbol(O) mcolor(black) lcolor(black) msize(small)) ciopts(lcolor(black)recast(. rcap))   ///
	graphregion(fcolor(white) ilcolor(white) lcolor(white))  ///
	xscale(range(-0.5 1.5)) xlabel(0 1) name(`y'_ei, replace) ///
	legend (off)
	
qui: margins, dydx(female) at(femploy=(.07(.1).57)) atmeans vsquish 
marginsplot, recast(scatter) yline(0, lcolor(red)) title("") xtitle("Share female employment") ///
	ytitle ("Marginal Effect of Female on the Pr(`y' Prioritization)",size(small)) ylabel(, nogrid) ///
	plot1opts(msymbol(O) mcolor(black) lcolor(black) msize(small)) ciopts(lcolor(black)recast(. rcap))   ///
	graphregion(fcolor(white) ilcolor(white) lcolor(white)) name(`y'_ec, replace)  ///
	legend (off) 

qui: margins, dydx(female) by(edgap) atmeans vsquish 
marginsplot, recast(scatter) yline(0, lcolor(red)) title("") xtitle("Vulnerability (Education Gap w/ Avg. Male)") ///
	ytitle ("Marginal Effect of Female on the Pr(`y' Prioritization)",size(small)) ylabel(, nogrid) ///
	plot1opts(msymbol(O) mcolor(black) lcolor(black) msize(small)) ciopts(lcolor(black)recast(. rcap))   ///
	graphregion(fcolor(white) ilcolor(white) lcolor(white)) xscale(range(-0.5 1.5))  name(`y'_vi, replace) ///
	legend (off)
	
qui: margins, dydx(female) at(vulA=(-1.6(.2)1.6)) atmeans vsquish 
marginsplot, recast(scatter) yline(0, lcolor(red)) title("") xtitle("Vulnerability Index") ///
	ytitle ("Marginal Effect of Female on the Pr(`y' Prioritization)",size(small)) ylabel(, nogrid) ///
	plot1opts(msymbol(O) mcolor(black) lcolor(black) msize(small)) ciopts(lcolor(black)recast(. rcap))   ///
	graphregion(fcolor(white) ilcolor(white) lcolor(white)) name(`y'_vc, replace)	///
	legend(off) 

graph combine `y'_ei `y'_vi `y'_ec `y'_vc, title("`y'", color(black)) /// 
col(2) graphregion(fcolor(white) ilcolor(white) lcolor(white)) scale(.7) ycommon
graph export "Drafts/Figures/`y'ME.pdf", replace
*graph drop _all
}	

set more off
foreach y in $shortlist2 {
estimates res `y'
estimates esample: `y' female muslim employment edgap muslimshare femploy vulA $controls gdp ROUND, replace

qui: margins, dydx(female) by(employment) atmeans vsquish 
marginsplot, recast(scatter)  title("") xtitle("Employed") ///
	ytitle ("Marginal Effect of Female on the Pr(`y' Prioritization)",size(small)) ylabel(, nogrid) ///
	plot1opts(msymbol(O) mcolor(black) lcolor(black) msize(small)) ciopts(lcolor(black)recast(. rcap))   ///
	graphregion(fcolor(white) ilcolor(white) lcolor(white))  ///
	xscale(range(-0.5 1.5)) xlabel(0 1) name(`y'_ei, replace) ///
	legend (off)
	
qui: margins, dydx(female) at(femploy=(.07(.1).57)) atmeans vsquish 
marginsplot, recast(scatter)  title("") xtitle("Share female employment") ///
	ytitle ("Marginal Effect of Female on the Pr(`y' Prioritization)",size(small)) ylabel(, nogrid) ///
	plot1opts(msymbol(O) mcolor(black) lcolor(black) msize(small)) ciopts(lcolor(black)recast(. rcap))   ///
	graphregion(fcolor(white) ilcolor(white) lcolor(white)) name(`y'_ec, replace)  ///
	legend (off) 

qui: margins, dydx(female) by(edgap) atmeans vsquish 
marginsplot, recast(scatter)  title("") xtitle("Vulnerability (Education Gap w/ Avg. Male)") ///
	ytitle ("Marginal Effect of Female on the Pr(`y' Prioritization)",size(small)) ylabel(, nogrid) ///
	plot1opts(msymbol(O) mcolor(black) lcolor(black) msize(small)) ciopts(lcolor(black)recast(. rcap))   ///
	graphregion(fcolor(white) ilcolor(white) lcolor(white)) xscale(range(-0.5 1.5))  name(`y'_vi, replace) ///
	legend (off)
	
qui: margins, dydx(female) at(vulA=(-1.6(.2)1.6)) atmeans vsquish 
marginsplot, recast(scatter)  title("") xtitle("Vulnerability Index") ///
	ytitle ("Marginal Effect of Female on the Pr(`y' Prioritization)",size(small)) ylabel(, nogrid) ///
	plot1opts(msymbol(O) mcolor(black) lcolor(black) msize(small)) ciopts(lcolor(black)recast(. rcap))   ///
	graphregion(fcolor(white) ilcolor(white) lcolor(white)) name(`y'_vc, replace)	///
	legend(off) 

graph combine `y'_ei `y'_vi `y'_ec `y'_vc, title("`y'", color(black)) /// 
col(2) graphregion(fcolor(white) ilcolor(white) lcolor(white)) scale(.7) ycommon
graph export "Drafts/Figures/`y'ME.pdf", replace
*graph drop _all
}	

*control for individual level poverty
set more off
foreach var of varlist  $shortlist {
mixed `var'  i.female##i.employment##c.femploy i.female##i.edgap##c.vulA i.female##i.muslim i.female##c.age i.female##i.urban i.female##c.muslimshare i.female##c.gdp i.ROUND i.female##c.wealthA [pw=Withinwt] || country: 
estimates store `var'_pov
}

*Produce regression table
esttab Infrastructure Infrastructure_pov  /// 
	using "Drafts/Tables/inf.tex", star(* 0.10 ** 0.05 *** 0.01) se b(3) se(3) r2(2) label booktabs alignment(D{.}{.}{-1}) replace ///
	stats(N N_clust,layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}") labels("Observations (Individual)" "Observations (Country)") f(0))  ///
	title(Impact of Individual and Country Characteristics on Gender Gaps in Policy Domain Prioritization (Top 3) \label{tab:mlminf})  ///
	drop(lnsig_e: lns1_1_1:) eqlab(, none) ///
	varlabels (1.muslim Muslim 1.female#1.muslim "Female $\times$ Muslim" 1.employment Employed 1.female#1.employment "Female $\times$ Employed" /// 
	1.employment#c.femploy "Employed $\times$ Share female employment" 1.edgap "Education Gap w/ Avg. Male" 1.female#1.edgap "Female $\times$ Education Gap" ///
	1.muslimshare "Share muslim" 1.female#1.muslimshare "Female $\times$ Share muslim" c.femploy "Share female employment" /// 
	1.female#c.femploy "Female $\times$ Share female employment" 1.female#1.employment#c.femploy "Female $\times$ Employed $\times$ Share female employment" ///
	vulA "Vulnerability Index" 1.female#c.vulA "Female $\times$ Vulnerability" 1.female#1.edgap#c.vulA "Female $\times$ Education gap $\times$ Vulnerability" /// 
	1.urban "Urban" 1.female#1.urban "Female $\times$ Urban" 1.Round "Round 5" 1.edgap#c.vulA "Education gap $\times$ Vulnerability" ///
	_cons Constant) ///
	nonotes  nobaselevels  nogaps ///
	sub("\begin{tabular}" "\scalebox{0.7}{\begin{tabular}" "\end{tabular}" "\end{tabular}}" "\multicolumn{1}{c}{N}" "Observations") ///
	addnote("Multi-level models in which individuals are nested within countries." "$^* p<0.10$, $^{**} p<0.05$, $^{***} p<0.01$")

esttab Water Water_pov  /// 
	using "Drafts/Tables/water.tex", star(* 0.10 ** 0.05 *** 0.01) se b(3) se(3) r2(2) label booktabs alignment(D{.}{.}{-1}) replace ///
	stats(N N_clust,layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}") labels("Observations (Individual)" "Observations (Country)") f(0))  ///
	title(Impact of Individual and Country Characteristics on Gender Gaps in Policy Domain Prioritization (Top 3) \label{tab:mlmwater})  ///
	drop(lnsig_e: lns1_1_1:) eqlab(, none) ///
	varlabels (1.muslim Muslim 1.female#1.muslim "Female $\times$ Muslim" 1.employment Employed 1.female#1.employment "Female $\times$ Employed" /// 
	1.employment#c.femploy "Employed $\times$ Share female employment" 1.edgap "Education Gap w/ Avg. Male" 1.female#1.edgap "Female $\times$ Education Gap" ///
	1.muslimshare "Share muslim" 1.female#1.muslimshare "Female $\times$ Share muslim" c.femploy "Share female employment" /// 
	1.female#c.femploy "Female $\times$ Share female employment" 1.female#1.employment#c.femploy "Female $\times$ Employed $\times$ Share female employment" ///
	vulA "Vulnerability Index" 1.female#c.vulA "Female $\times$ Vulnerability" 1.female#1.edgap#c.vulA "Female $\times$ Education gap $\times$ Vulnerability" /// 
	1.urban "Urban" 1.female#1.urban "Female $\times$ Urban" 1.Round "Round 5" 1.edgap#c.vulA "Education gap $\times$ Vulnerability" ///
	_cons Constant) ///
	nonotes  nobaselevels  nogaps ///
	sub("\begin{tabular}" "\scalebox{0.7}{\begin{tabular}" "\end{tabular}" "\end{tabular}}" "\multicolumn{1}{c}{N}" "Observations") ///
	addnote("Multi-level models in which individuals are nested within countries." "$^* p<0.10$, $^{**} p<0.05$, $^{***} p<0.01$")

	
	esttab Poverty Poverty_pov  /// 
	using "Drafts/Tables/pov.tex", star(* 0.10 ** 0.05 *** 0.01) se b(3) se(3) r2(2) label booktabs alignment(D{.}{.}{-1}) replace ///
	stats(N N_clust,layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}") labels("Observations (Individual)" "Observations (Country)") f(0))  ///
	title(Impact of Individual and Country Characteristics on Gender Gaps in Policy Domain Prioritization (Top 3) \label{tab:mlmpov})  ///
	drop(lnsig_e: lns1_1_1:) eqlab(, none) ///
	varlabels (1.muslim Muslim 1.female#1.muslim "Female $\times$ Muslim" 1.employment Employed 1.female#1.employment "Female $\times$ Employed" /// 
	1.employment#c.femploy "Employed $\times$ Share female employment" 1.edgap "Education Gap w/ Avg. Male" 1.female#1.edgap "Female $\times$ Education Gap" ///
	1.muslimshare "Share muslim" 1.female#1.muslimshare "Female $\times$ Share muslim" c.femploy "Share female employment" /// 
	1.female#c.femploy "Female $\times$ Share female employment" 1.female#1.employment#c.femploy "Female $\times$ Employed $\times$ Share female employment" ///
	vulA "Vulnerability Index" 1.female#c.vulA "Female $\times$ Vulnerability" 1.female#1.edgap#c.vulA "Female $\times$ Education gap $\times$ Vulnerability" /// 
	1.urban "Urban" 1.female#1.urban "Female $\times$ Urban" 1.Round "Round 5" 1.edgap#c.vulA "Education gap $\times$ Vulnerability" ///
	_cons Constant) ///
	nonotes  nobaselevels  nogaps ///
	sub("\begin{tabular}" "\scalebox{0.7}{\begin{tabular}" "\end{tabular}" "\end{tabular}}" "\multicolumn{1}{c}{N}" "Observations") ///
	addnote("Multi-level models in which individuals are nested within countries." "$^* p<0.10$, $^{**} p<0.05$, $^{***} p<0.01$")

	
	esttab Economy Economy_pov  /// 
	using "Drafts/Tables/econ.tex", star(* 0.10 ** 0.05 *** 0.01) se b(3) se(3) r2(2) label booktabs alignment(D{.}{.}{-1}) replace ///
	stats(N N_clust,layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}") labels("Observations (Individual)" "Observations (Country)") f(0))  ///
	title(Impact of Individual and Country Characteristics on Gender Gaps in Policy Domain Prioritization (Top 3) \label{tab:mlmecon})  ///
	drop(lnsig_e: lns1_1_1:) eqlab(, none) ///
	varlabels (1.muslim Muslim 1.female#1.muslim "Female $\times$ Muslim" 1.employment Employed 1.female#1.employment "Female $\times$ Employed" /// 
	1.employment#c.femploy "Employed $\times$ Share female employment" 1.edgap "Education Gap w/ Avg. Male" 1.female#1.edgap "Female $\times$ Education Gap" ///
	1.muslimshare "Share muslim" 1.female#1.muslimshare "Female $\times$ Share muslim" c.femploy "Share female employment" /// 
	1.female#c.femploy "Female $\times$ Share female employment" 1.female#1.employment#c.femploy "Female $\times$ Employed $\times$ Share female employment" ///
	vulA "Vulnerability Index" 1.female#c.vulA "Female $\times$ Vulnerability" 1.female#1.edgap#c.vulA "Female $\times$ Education gap $\times$ Vulnerability" /// 
	1.urban "Urban" 1.female#1.urban "Female $\times$ Urban" 1.Round "Round 5" 1.edgap#c.vulA "Education gap $\times$ Vulnerability" ///
	_cons Constant) ///
	nonotes  nobaselevels  nogaps ///
	sub("\begin{tabular}" "\scalebox{0.7}{\begin{tabular}" "\end{tabular}" "\end{tabular}}" "\multicolumn{1}{c}{N}" "Observations") ///
	addnote("Multi-level models in which individuals are nested within countries." "$^* p<0.10$, $^{**} p<0.05$, $^{***} p<0.01$")

	
******************************** Additional Analyses and Appendix Material *****************************************	
	
	
****************************************************
* Alternatie DV: 1st Priority 
****************************************************

set more off
use "ANALYSES/AB/GGR_FinalData.dta", clear
rename economy1 poverty1 agriculture1 infrastructure1 education1 water1 health1 rights1 violence1 services1, proper
global outcomes Economy1 Poverty1 Agriculture1 Infrastructure1 Education1 Water1 Health1 Rights1 Violence1 Services1 None

global min_controls count2
global full_controls age urban primary count2

* Using SVY/SUEST
svyset URBRUR [pweight=Withinwt], strata(REGION) singleunit(certainty)
svydescribe

foreach y in $outcomes {
svy: reg `y' female $min_controls i.ccodecow i.ROUND, dof(5) 
est sto `y'
}

suest $outcomes, cformat(%9.3f)
test female

*graph coef plot
preserve
parmest, label format(estimate min95 max95 p %8.2f ) norestore 
keep if  parm=="female"
gen ids=_n

gen outcome =1 if eq=="Economy1"
replace outcome =2 if eq=="Poverty1"
replace outcome =3 if eq=="Infrastructure1"
replace outcome =4 if eq=="Health1"
replace outcome =5 if eq=="Water1"
replace outcome =6 if eq=="Education1"
replace outcome =7 if eq=="Agriculture1"
replace outcome =8 if eq=="Violence1"
replace outcome =9 if eq=="Rights1"
replace outcome =10 if eq=="Services1"

lab define outcomes 1 "Economy" 2 "Poverty" 3 "Infrastructure" 4 "Health" 5 "Water" 6 "Education" 7 "Agriculture" 8 "Violence" 9 "Rights" 10 "Services", modify
lab value outcome outcomes

twoway (rspike min95 max95 outcome, hor lc(black) lw(thin) ) ///
	(scatter outcome estimate , msize(medsmall) ms(O) mc(black)) ///
	, ///
	legend(off) ///
	scheme(s2mono) graphregion(fcolor(white)) ///
	yscale(rev) ///
	ylabel(#12, angle(horizontal) valuelabel labs(2.2) nogrid) ///
	xlabel(#6, labs(2.2)) ///
	xline(0, lpattern(shortdash)) ///
    xtitle("Impact of Gender (Female) on Likelihood of Policy Domain Top Prioritization" "SUR Pooled OLS Analysis with Country Fixed Effects, 95% CIs" , size(2.2)) ytitle("")
graph save "DATA/Afrobarometer/Graphs/suest_main_top1", replace
graph export "Drafts/Figures/suest_main_top1.pdf", replace
restore

*graph predicted probabilities
tempfile pp_top1
postfile pp1 str15 var str15 female pp pp_se pooled str15 sample str15 controls using `pp_top1', replace
foreach y in $outcomes {
est restore `y'
qui: margins, at(female=(0 1)) atmeans 
matrix A=r(table)
post pp1 ("`y'") ("Men") (A[1,1]) (A[2,1]) (1) ("Pooled") ("Min")
post pp1 ("`y'") ("Women") (A[1,2]) (A[2,2]) (1) ("Pooled") ("Min")
}
postclose pp1

preserve
use `pp_top1', clear
gen min95=pp-(1.96*pp_se)
gen max95=pp+1.96*pp_se
gen id=_n
gen axis=id*-1
sort axis
sencode var, gen(outcome)
replace outcome=outcome + 0.25 if female=="Men"

twoway (rspike min95 max95 outcome if female=="Men" & sample=="Pooled" & controls=="Min", hor lc(black) lw(thin)) ///
	(scatter outcome pp if female=="Men" & sample=="Pooled" & controls=="Min", msize(medsmall) ms(O) mfc(white) mlc(black)) ///
	(rspike min95 max95 outcome if female=="Women" & sample=="Pooled" & controls=="Min", hor lc(black) lw(thin)) ///
	(scatter outcome pp if female=="Women" & sample=="Pooled" & controls=="Min", msize(medsmall) ms(O) mc(black)) ///
, ///
	legend(order(2 "Men" 4 "Women") size (vsmall) row(2) region(lw(none) fc(none)) ring(0) pos(5) ) ///
	scheme(s2mono) graphregion(fcolor(white)) ///
	ylabel(#10, angle(horizontal) valuelabel labs(2.2) nogrid) ///
	xlabel(#6, labs(2.2)) ///
    xtitle("Predicted Probability of Policy Domain Prioritization" "SUR Pooled OLS Analysis with Country Fixed Effects, 95% CIs", size(2.2)) ytitle("")
graph save "DATA/Afrobarometer/Graphs/pooled_pp_top1", replace
graph export "Drafts/Figures/suest_pp_top1.pdf", replace
restore

**** Analyses ***
use "ANALYSES/AB/GGR_FinalData.dta", clear
set more off
global ivs femploy vulA muslimshare 
global controls age urban  
rename water1 poverty1 infrastructure1, proper
global shortlist1 Water1 Infrastructure1
global shortlist2 Poverty1

*Run analysis of  interactions 
set more off
foreach var of varlist  $shortlist1 $shortlist2 {
mixed `var' i.female##i.employment##c.femploy i.female##i.edgap##c.vulA i.female##i.muslim i.female##c.age i.female##i.urban i.female##c.muslimshare i.female##c.gdp i.ROUND [pw=Withinwt] || country: 
estimates store `var'
}

set more off
foreach y in $shortlist1 {
estimates res `y'
estimates esample: `y' female muslim employment edgap muslimshare femploy vulA $controls gdp ROUND, replace

qui: margins, dydx(female) by(employment) atmeans vsquish 
marginsplot, recast(scatter) yline(0, lcolor(red)) title("") xtitle("Employed") ///
	ytitle ("Marginal Effect of Female on the Pr(`y' Prioritization)",size(small)) ylabel(, nogrid) ///
	plot1opts(msymbol(O) mcolor(black) lcolor(black) msize(small)) ciopts(lcolor(black)recast(. rcap))   ///
	graphregion(fcolor(white) ilcolor(white) lcolor(white))  ///
	xscale(range(-0.5 1.5)) xlabel(0 1) name(`y'_ei, replace) ///
	legend (off)
	
qui: margins, dydx(female) at(femploy=(.07(.1).57)) atmeans vsquish 
marginsplot, recast(scatter) yline(0, lcolor(red)) title("") xtitle("Share female employment") ///
	ytitle ("Marginal Effect of Female on the Pr(`y' Prioritization)",size(small)) ylabel(, nogrid) ///
	plot1opts(msymbol(O) mcolor(black) lcolor(black) msize(small)) ciopts(lcolor(black)recast(. rcap))   ///
	graphregion(fcolor(white) ilcolor(white) lcolor(white)) name(`y'_ec, replace)  ///
	legend (off) 

qui: margins, dydx(female) by(edgap) atmeans vsquish 
marginsplot, recast(scatter) yline(0, lcolor(red)) title("") xtitle("Vulnerability (Education Gap w/ Avg. Male)") ///
	ytitle ("Marginal Effect of Female on the Pr(`y' Prioritization)",size(small)) ylabel(, nogrid) ///
	plot1opts(msymbol(O) mcolor(black) lcolor(black) msize(small)) ciopts(lcolor(black)recast(. rcap))   ///
	graphregion(fcolor(white) ilcolor(white) lcolor(white)) xscale(range(-0.5 1.5))  name(`y'_vi, replace) ///
	legend (off)
	
qui: margins, dydx(female) at(vulA=(-1.6(.2)1.6)) atmeans vsquish 
marginsplot, recast(scatter) yline(0, lcolor(red)) title("") xtitle("Vulnerability Index") ///
	ytitle ("Marginal Effect of Female on the Pr(`y' Prioritization)",size(small)) ylabel(, nogrid) ///
	plot1opts(msymbol(O) mcolor(black) lcolor(black) msize(small)) ciopts(lcolor(black)recast(. rcap))   ///
	graphregion(fcolor(white) ilcolor(white) lcolor(white)) name(`y'_vc, replace)	///
	legend(off) 
graph combine `y'_ei `y'_vi `y'_ec `y'_vc, title("`y'", color(black)) /// 
col(2) graphregion(fcolor(white) ilcolor(white) lcolor(white)) scale(.7) ycommon
graph export "Drafts/Figures/`y'ME_top1.pdf", replace
}

set more off
foreach y in $shortlist2 {
estimates res `y'
estimates esample: `y' female muslim employment edgap muslimshare femploy vulA $controls gdp ROUND, replace

qui: margins, dydx(female) by(employment) atmeans vsquish 
marginsplot, recast(scatter)  title("") xtitle("Employed") ///
	ytitle ("Marginal Effect of Female on the Pr(`y' Prioritization)",size(small)) ylabel(, nogrid) ///
	plot1opts(msymbol(O) mcolor(black) lcolor(black) msize(small)) ciopts(lcolor(black)recast(. rcap))   ///
	graphregion(fcolor(white) ilcolor(white) lcolor(white))  ///
	xscale(range(-0.5 1.5)) xlabel(0 1) name(`y'_ei, replace) ///
	legend (off)
	
qui: margins, dydx(female) at(femploy=(.07(.1).57)) atmeans vsquish 
marginsplot, recast(scatter)  title("") xtitle("Share female employment") ///
	ytitle ("Marginal Effect of Female on the Pr(`y' Prioritization)",size(small)) ylabel(, nogrid) ///
	plot1opts(msymbol(O) mcolor(black) lcolor(black) msize(small)) ciopts(lcolor(black)recast(. rcap))   ///
	graphregion(fcolor(white) ilcolor(white) lcolor(white)) name(`y'_ec, replace)  ///
	legend (off) 

qui: margins, dydx(female) by(edgap) atmeans vsquish 
marginsplot, recast(scatter)  title("") xtitle("Vulnerability (Education Gap w/ Avg. Male)") ///
	ytitle ("Marginal Effect of Female on the Pr(`y' Prioritization)",size(small)) ylabel(, nogrid) ///
	plot1opts(msymbol(O) mcolor(black) lcolor(black) msize(small)) ciopts(lcolor(black)recast(. rcap))   ///
	graphregion(fcolor(white) ilcolor(white) lcolor(white)) xscale(range(-0.5 1.5))  name(`y'_vi, replace) ///
	legend (off)
	
qui: margins, dydx(female) at(vulA=(-1.6(.2)1.6)) atmeans vsquish 
marginsplot, recast(scatter)  title("") xtitle("Vulnerability Index") ///
	ytitle ("Marginal Effect of Female on the Pr(`y' Prioritization)",size(small)) ylabel(, nogrid) ///
	plot1opts(msymbol(O) mcolor(black) lcolor(black) msize(small)) ciopts(lcolor(black)recast(. rcap))   ///
	graphregion(fcolor(white) ilcolor(white) lcolor(white)) name(`y'_vc, replace)	///
	legend(off) 
	
graph combine `y'_ei `y'_vi `y'_ec `y'_vc, title("`y'", color(black)) /// 
col(2) graphregion(fcolor(white) ilcolor(white) lcolor(white)) scale(.7) ycommon
graph export "Drafts/Figures/`y'ME_top1.pdf", replace
}



****************************************************
* Alternatie DV: Count
****************************************************

set more off
use "ANALYSES/AB/GGR_FinalData.dta", clear
rename economy_N poverty_N agriculture_N infrastructure_N education_N water_N health_N rights_N violence_N services_N, proper
global outcomes Economy_N Poverty_N Agriculture_N Infrastructure_N Education_N Water_N Health_N Rights_N Violence_N Services_N 
global min_controls count2
global full_controls age urban primary count2

* Using SVY/SUEST
svyset URBRUR [pweight=Withinwt], strata(REGION) singleunit(certainty)
svydescribe

foreach y in $outcomes {
svy: reg `y' female $min_controls i.ccodecow i.ROUND, dof(5) 
est sto `y'
}

suest $outcomes, cformat(%9.3f)
test female

*graph coef plot
preserve
parmest, label format(estimate min95 max95 p %8.2f ) norestore 
keep if  parm=="female"
gen ids=_n

gen outcome =1 if eq=="Economy_N"
replace outcome =2 if eq=="Poverty_N"
replace outcome =3 if eq=="Infrastructure_N"
replace outcome =4 if eq=="Health_N"
replace outcome =5 if eq=="Water_N"
replace outcome =6 if eq=="Education_N"
replace outcome =7 if eq=="Agriculture_N"
replace outcome =8 if eq=="Violence_N"
replace outcome =9 if eq=="Rights_N"
replace outcome =10 if eq=="Services_N"

lab define outcomes 1 "Economy" 2 "Poverty" 3 "Infrastructure" 4 "Health" 5 "Water" 6 "Education" 7 "Agriculture" 8 "Violence" 9 "Rights" 10 "Services", modify
lab value outcome outcomes

twoway (rspike min95 max95 outcome, hor lc(black) lw(thin) ) ///
	(scatter outcome estimate , msize(medsmall) ms(O) mc(black)) ///
	, ///
	legend(off) ///
	scheme(s2mono) graphregion(fcolor(white)) ///
	yscale(rev) ///
	ylabel(#12, angle(horizontal) valuelabel labs(2.2) nogrid) ///
	xlabel(#6, labs(2.2)) ///
	xline(0, lpattern(shortdash)) ///
    xtitle("Impact of Gender (Female) on Count of Policy Domain Prioritization" "SUR Pooled OLS Analysis with Country Fixed Effects, 95% CIs" , size(2.2)) ytitle("")
graph save "DATA/Afrobarometer/Graphs/suest_main_N", replace
graph export "Drafts/Figures/suest_main_N.pdf", replace
restore

*graph predicted probabilities
tempfile pp_N
postfile pp_N str15 var str15 female pp pp_se pooled str15 sample str15 controls using `pp_N', replace
foreach y in $outcomes {
est restore `y'
qui: margins, at(female=(0 1)) atmeans 
matrix A=r(table)
post pp_N ("`y'") ("Men") (A[1,1]) (A[2,1]) (1) ("Pooled") ("Min")
post pp_N ("`y'") ("Women") (A[1,2]) (A[2,2]) (1) ("Pooled") ("Min")
}
postclose pp_N

preserve
use `pp_N', clear
gen min95=pp-(1.96*pp_se)
gen max95=pp+(1.96*pp_se)
gen id=_n
gen axis=id*-1
sort axis
sencode var, gen(outcome)
replace outcome=outcome + 0.25 if female=="Men"

twoway (rspike min95 max95 outcome if female=="Men" & sample=="Pooled" & controls=="Min", hor lc(black) lw(thin)) ///
	(scatter outcome pp if female=="Men" & sample=="Pooled" & controls=="Min", msize(medsmall) ms(O) mfc(white) mlc(black)) ///
	(rspike min95 max95 outcome if female=="Women" & sample=="Pooled" & controls=="Min", hor lc(black) lw(thin)) ///
	(scatter outcome pp if female=="Women" & sample=="Pooled" & controls=="Min", msize(medsmall) ms(O) mc(black)) ///
, ///
	legend(order(2 "Men" 4 "Women") size (vsmall) row(2) region(lw(none) fc(none)) ring(0) pos(5) ) ///
	scheme(s2mono) graphregion(fcolor(white)) ///
	ylabel(#10, angle(horizontal) valuelabel labs(2.2) nogrid) ///
	xlabel(#6, labs(2.2)) ///
    xtitle("Predicted Count of Policy Domain Prioritization" "SUR Pooled OLS Analysis with Country Fixed Effects, 95% CIs", size(2.2)) ytitle("")
graph save "DATA/Afrobarometer/Graphs/pooled_pp_N", replace
graph export "Drafts/Figures/suest_pp_N.pdf", replace
restore

*** Analyses ***

use "ANALYSES/AB/GGR_FinalData.dta", clear
set more off
global ivs femploy vulA muslimshare 
global controls age urban  
rename water_N poverty_N infrastructure_N, proper
global shortlist1 Water_N Infrastructure_N
global shortlist2 Poverty_N

*Run analysis of  interactions 
set more off
foreach var of varlist  $shortlist1 $shortlist2 {
mixed `var' i.female##i.employment##c.femploy i.female##i.edgap##c.vulA i.female##i.muslim i.female##c.age i.female##i.urban i.female##c.muslimshare i.female##c.gdp i.ROUND [pw=Withinwt] || country: 
estimates store `var'
}

set more off
foreach y in $shortlist1 {
estimates res `y'
estimates esample: `y' female muslim employment edgap muslimshare femploy vulA $controls gdp ROUND, replace

qui: margins, dydx(female) by(employment) atmeans vsquish 
marginsplot, recast(scatter) yline(0, lcolor(red)) title("") xtitle("Employed") ///
	ytitle ("Marginal Effect of Female on the Pr(`y' Prioritization)",size(small)) ylabel(, nogrid) ///
	plot1opts(msymbol(O) mcolor(black) lcolor(black) msize(small)) ciopts(lcolor(black)recast(. rcap))   ///
	graphregion(fcolor(white) ilcolor(white) lcolor(white))  ///
	xscale(range(-0.5 1.5)) xlabel(0 1) name(`y'_ei, replace) ///
	legend (off)
	
qui: margins, dydx(female) at(femploy=(.07(.1).57)) atmeans vsquish 
marginsplot, recast(scatter) yline(0, lcolor(red)) title("") xtitle("Share female employment") ///
	ytitle ("Marginal Effect of Female on the Pr(`y' Prioritization)",size(small)) ylabel(, nogrid) ///
	plot1opts(msymbol(O) mcolor(black) lcolor(black) msize(small)) ciopts(lcolor(black)recast(. rcap))   ///
	graphregion(fcolor(white) ilcolor(white) lcolor(white)) name(`y'_ec, replace)  ///
	legend (off) 

qui: margins, dydx(female) by(edgap) atmeans vsquish 
marginsplot, recast(scatter) yline(0, lcolor(red)) title("") xtitle("Vulnerability (Education Gap w/ Avg. Male)") ///
	ytitle ("Marginal Effect of Female on the Pr(`y' Prioritization)",size(small)) ylabel(, nogrid) ///
	plot1opts(msymbol(O) mcolor(black) lcolor(black) msize(small)) ciopts(lcolor(black)recast(. rcap))   ///
	graphregion(fcolor(white) ilcolor(white) lcolor(white)) xscale(range(-0.5 1.5))  name(`y'_vi, replace) ///
	legend (off)
	
qui: margins, dydx(female) at(vulA=(-1.6(.2)1.6)) atmeans vsquish 
marginsplot, recast(scatter) yline(0, lcolor(red)) title("") xtitle("Vulnerability Index") ///
	ytitle ("Marginal Effect of Female on the Pr(`y' Prioritization)",size(small)) ylabel(, nogrid) ///
	plot1opts(msymbol(O) mcolor(black) lcolor(black) msize(small)) ciopts(lcolor(black)recast(. rcap))   ///
	graphregion(fcolor(white) ilcolor(white) lcolor(white)) name(`y'_vc, replace)	///
	legend(off) 
graph combine `y'_ei `y'_vi `y'_ec `y'_vc, title("`y'", color(black)) /// 
col(2) graphregion(fcolor(white) ilcolor(white) lcolor(white)) scale(.7) ycommon
graph export "Drafts/Figures/`y'ME_count.pdf", replace
}

set more off
foreach y in $shortlist2 {
estimates res `y'
estimates esample: `y' female muslim employment edgap muslimshare femploy vulA $controls gdp ROUND, replace

qui: margins, dydx(female) by(employment) atmeans vsquish 
marginsplot, recast(scatter)  title("") xtitle("Employed") ///
	ytitle ("Marginal Effect of Female on the Pr(`y' Prioritization)",size(small)) ylabel(, nogrid) ///
	plot1opts(msymbol(O) mcolor(black) lcolor(black) msize(small)) ciopts(lcolor(black)recast(. rcap))   ///
	graphregion(fcolor(white) ilcolor(white) lcolor(white))  ///
	xscale(range(-0.5 1.5)) xlabel(0 1) name(`y'_ei, replace) ///
	legend (off)
	
qui: margins, dydx(female) at(femploy=(.07(.1).57)) atmeans vsquish 
marginsplot, recast(scatter)  title("") xtitle("Share female employment") ///
	ytitle ("Marginal Effect of Female on the Pr(`y' Prioritization)",size(small)) ylabel(, nogrid) ///
	plot1opts(msymbol(O) mcolor(black) lcolor(black) msize(small)) ciopts(lcolor(black)recast(. rcap))   ///
	graphregion(fcolor(white) ilcolor(white) lcolor(white)) name(`y'_ec, replace)  ///
	legend (off) 

qui: margins, dydx(female) by(edgap) atmeans vsquish 
marginsplot, recast(scatter)  title("") xtitle("Vulnerability (Education Gap w/ Avg. Male)") ///
	ytitle ("Marginal Effect of Female on the Pr(`y' Prioritization)",size(small)) ylabel(, nogrid) ///
	plot1opts(msymbol(O) mcolor(black) lcolor(black) msize(small)) ciopts(lcolor(black)recast(. rcap))   ///
	graphregion(fcolor(white) ilcolor(white) lcolor(white)) xscale(range(-0.5 1.5))  name(`y'_vi, replace) ///
	legend (off)
	
qui: margins, dydx(female) at(vulA=(-1.6(.2)1.6)) atmeans vsquish 
marginsplot, recast(scatter)  title("") xtitle("Vulnerability Index") ///
	ytitle ("Marginal Effect of Female on the Pr(`y' Prioritization)",size(small)) ylabel(, nogrid) ///
	plot1opts(msymbol(O) mcolor(black) lcolor(black) msize(small)) ciopts(lcolor(black)recast(. rcap))   ///
	graphregion(fcolor(white) ilcolor(white) lcolor(white)) name(`y'_vc, replace)	///
	legend(off) 
	
graph combine `y'_ei `y'_vi `y'_ec `y'_vc, title("`y'", color(black)) /// 
col(2) graphregion(fcolor(white) ilcolor(white) lcolor(white)) scale(.7) ycommon
graph export "Drafts/Figures/`y'ME_count.pdf", replace
}






****************************************************
* Alternative Measure of Female Employment: Ratio
****************************************************

use "ANALYSES/AB/GGR_FinalData.dta", clear
set more off
global ivs emp_ratio vulA muslimshare 
global controls age urban  
global shortlist Water Economy Poverty Infrastructure

twoway (scatter emp_ratio femploy if ctag==1) ///
		(lfit emp_ratio femploy if ctag==1), ///
		ytitle (Ratio of Female/Male Share Employed)  ///
		legend(off) ///
		scheme(s2mono) graphregion(fcolor(white)) 
graph save "DATA/Afrobarometer/Graphs/emp_measures", replace
graph export "Drafts/Figures/emp_measures.pdf", replace

set more off
foreach var of varlist  $shortlist {
mixed `var' i.female##i.employment##c.emp_ratio i.female##i.edgap##c.vulA i.female##i.muslim i.female##c.age i.female##i.urban i.female##c.muslimshare i.female##c.gdp i.ROUND [pw=Withinwt] || country: 
estimates store `var'
}


*graph marginal effects of gender by individual and country IVs
**NB: To produce the poverty graph without the red line, need to take poverty out of foreach loop and delete code for yline
set more off
foreach y in $shortlist {
estimates res `y'
estimates esample: `y' female muslim employment edgap muslimshare emp_ratio vulA $controls gdp ROUND, replace

qui: margins, dydx(female) by(employment) atmeans vsquish 
marginsplot, recast(scatter) yline(0, lcolor(red)) title("") xtitle("Employed") ///
	ytitle ("Marginal Effect of Female on the Pr(`y' Prioritization)",size(small)) ylabel(, nogrid) ///
	plot1opts(msymbol(O) mcolor(black) lcolor(black) msize(small)) ciopts(lcolor(black)recast(. rcap))   ///
	graphregion(fcolor(white) ilcolor(white) lcolor(white))  ///
	xscale(range(-0.5 1.5)) xlabel(0 1) name(`y'_ei, replace) ///
	legend (off)
	
qui: margins, dydx(female) at(emp_ratio=(.3(.1)1)) atmeans vsquish 
marginsplot, recast(scatter) yline(0, lcolor(red)) title("") xtitle("Ratio F/M employment") ///
	ytitle ("Marginal Effect of Female on the Pr(`y' Prioritization)",size(small)) ylabel(, nogrid) ///
	plot1opts(msymbol(O) mcolor(black) lcolor(black) msize(small)) ciopts(lcolor(black)recast(. rcap))   ///
	graphregion(fcolor(white) ilcolor(white) lcolor(white)) name(`y'_ec, replace)  ///
	legend (off) 

qui: margins, dydx(female) by(edgap) atmeans vsquish 
marginsplot, recast(scatter) yline(0, lcolor(red)) title("") xtitle("Vulnerability (Education Gap w/ Avg. Male)") ///
	ytitle ("Marginal Effect of Female on the Pr(`y' Prioritization)",size(small)) ylabel(, nogrid) ///
	plot1opts(msymbol(O) mcolor(black) lcolor(black) msize(small)) ciopts(lcolor(black)recast(. rcap))   ///
	graphregion(fcolor(white) ilcolor(white) lcolor(white)) xscale(range(-0.5 1.5))  name(`y'_vi, replace) ///
	legend (off)
	
qui: margins, dydx(female) at(vulA=(-1.6(.2)1.6)) atmeans vsquish 
marginsplot, recast(scatter) yline(0, lcolor(red)) title("") xtitle("Vulnerability Index") ///
	ytitle ("Marginal Effect of Female on the Pr(`y' Prioritization)",size(small)) ylabel(, nogrid) ///
	plot1opts(msymbol(O) mcolor(black) lcolor(black) msize(small)) ciopts(lcolor(black)recast(. rcap))   ///
	graphregion(fcolor(white) ilcolor(white) lcolor(white)) name(`y'_vc, replace)	///
	legend(off) 

graph combine `y'_ei `y'_vi `y'_ec `y'_vc, title("`y'", color(black)) /// 
col(2) graphregion(fcolor(white) ilcolor(white) lcolor(white)) scale(.7) ycommon
graph export "Drafts/Figures/`y'ME_ratio.pdf", replace
*graph drop _all
}


****************************************************
* Create Summary Stats Table
****************************************************	
	

use "ANALYSES/AB/GGR_FinalData.dta", clear
global outcomes Economy Poverty Infrastructure Health Agriculture Water Education Violence Rights  Services
global main Infrastructure Poverty  Water
global min_controls count2
global full_controls age urban primary count2

set more off
svyset urbrur [pweight=Withinwt], strata(region) singleunit(certainty)


*Summary stats, by gender
set more off
lab def female 0 "Male" 1 "Female", modify
lab val female female

* Incorporating survey weights
foreach y in $outcomes{
svy: mean `y' if female==0
est store `y'F
svy: mean `y' if female==1
est store `y'M
}


preserve
set more off
global tflist ""
global modseq=0
foreach y in $outcomes{
global modseq=$modseq+1
tempfile tfcur
parmby "svy: mean `y',over(female)", ylabel ev(_N _N_subp) es(N) format(estimate min95 max95 p %8.3f ) idn($modseq) saving(`"`tfcur'"',replace) flist(tflist)
}
drop _all
append using $tflist
describe
sort idnum parmseq
by idnum parmseq:list parm estimate min95 max95 p es_1 ev_1,noobs

gen ids=_n
gen outcome =1 if parm=="Economy"
replace outcome =2 if parm=="Poverty"
replace outcome =3 if parm=="Infrastructure"
replace outcome =4 if parm=="Health"
replace outcome =5 if parm=="Agriculture"
replace outcome =6 if parm=="Water"
replace outcome =7 if parm=="Education"
replace outcome =8 if parm=="Violence"
replace outcome =9 if parm=="Rights"
replace outcome =10 if parm=="Services"

lab value outcome outcomes

keep parmseq idnum eq estimate es_1 ev_1
reshape wide estimate es_1 ev_1, i(idnum ) j(parmseq)
drop  idnum es_11 es_12
move eq estimate1
gen Diff= estimate1-estimate2
format Diff %8.3f
move  estimate2 ev_11
move  Diff ev_11
ren eq Policy
ren estimate1 Male
ren estimate2 Female
ren ev_11 N1
ren ev_12 N2
dataout, save("Drafts/Tables/summ_weights.tex") tex replace
restore


*latex table
foreach v of varlist $outcomes $min_controls {
	label variable `v' `"\hspace{0.1cm} `: variable label `v''"'
	}
estpost su $outcomes $min_controls if female==0
est store A
estpost su $outcomes $min_controls if female==1
est store B
estpost su $outcomes $min_controls
est store C
esttab A B C using "Drafts/Tables/summ.tex", replace ///
		refcat(Economy "\emph{Policy Priorities}" age "\emph{Controls}", nolabel) ///
		mtitle("\textbf{Men}" "\textbf{Women}" "\textbf{Overall}") ///
		stats(N, fmt(%18.0g) labels("\midrule Observations")) ///
		cells(mean(fmt(2))) label booktabs nonum f collabels(none) gaps plain
foreach v of varlist $outcomes $min_controls {
	label variable `v' `"\hspace{0.1cm} `: variable label `v''"'
	}

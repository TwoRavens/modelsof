
***************************************************************************************************************************************
********** Replication Script for "Do Authoritarians Vote for Authoritarians? Evidence from Latin America *****************************
********** By Mollie Cohen and Amy Erica Smith
********** Forthcoming, Research and Politics
********** Questions? Please email amyericas@gmail.com
***************************************************************************************************************************************

********** This paper utilizes data from the 2012 AmericasBarometer, which may be obtained from www.americasbarometer.org.
use "AmericasBarometer Merged 2012 v50.0 English.dta", clear
*** INSERT WORKING DIRECTORY HERE:
cd ""
log using "Replication log.smcl", replace

***************************************************************************************************************************************
*************************************** DATA SETUP AND VARIABLE CODING **************************************************************** 

********* Limit the analysis to Latin America and recode the Dominican Republic to make loops easier
drop if pais > 21 // THE US AND CANADA WILL BE BROUGHT BACK IN FOR THE FIRST FIGURE
recode pais 21=18
	lab def pais 18 "Dom. Rep.", modify
xtset pais

********* Code authoritarian parenting battery
recode ab1 (1=0) (2=1) (3=.5), g(ab1r)
recode ab2 (1=1) (2=0) (3=.5), g(ab2r)
recode ab5 (1=0) (2=1) (3=.5), g(ab5r)
egen authoritarianism = rowmean(ab1r ab2r ab5r)
tab1 authoritarianism
lab var authoritarianism "Authoritarian Parenting"

*********************************************** Coding for authoritarian candidates
********* Coding "t-1" authoritarian candidates and elections. See supplemental material for more details.
* Vote for candidate promoting mano dura policies (t-1)
gen manodura=0 if pais == 2 | pais == 3 | pais == 4
	replace manodura=1 if inlist(vb3, 206, 203, 301, 406)
* Vote for civil rights violating candidates at t-1 
gen authcand=0 if pais == 5 | pais == 9 | pais == 11 | pais == 16 | pais == 10 | pais == 17
	replace authcand=1 if inlist(vb3,  502, 901, 1101, 1102, 1601, 1002, 1701)
* Combination of BOTH mano dura and infringement on civil rights
gen sumauthtmin=0 if manodura < . | authcand < .
	replace sumauthtmin=1 if manodura==1 | authcand==1
	lab var sumauthtmin "Voted for Any Authoritarian Candidate t-1"
gen sumauthcountrypast = (pais == 2 | pais == 3 | pais == 4 | pais == 5 | pais == 9 | pais == 11 | pais == 16 )
	lab var sumauthcountrypast "Country with Authoritarian Candidate t-1"
* Vote for Right Wing Authoritarian Leader
gen rwaleader=0 if pais == 2 | pais == 3 | pais == 4 | pais == 11
	replace rwaleader=1 if inlist(vb3, 206, 203, 301, 406, 1102)
	lab var rwaleader "Voted RWA Candidate t-1"
* Vote for Left Wing Authoritarian Leader
gen lwaleader=0 if pais == 5 | pais == 9 | pais == 11 | pais == 16 | pais == 10 | pais == 17
	replace lwaleader=1 if inlist(vb3,  502, 901, 1101, 1601, 1002, 1701)
	lab var lwaleader "Voted LWA Candidate t-1"
g lwacountrypast = (pais == 5 | pais == 9 | pais == 11 | pais == 16 | pais == 10 | pais == 17)
*******************************************************

********* Coding "t+1" authoritarian candidates and elections. See supplemental material for more details.
/* Fujimori and MD candidate in El Salvador were in opposition, so can't be analyzed on VB20 */
gen sumauthfutincumbent = 0
	replace sumauthfutincumbent = inlist(pais, 1, 4, 5, 9, 10, 16)
	lab var sumauthfutincumbent "Country with Authoritarian Incumbent t+1"
**** Coding incumbent ideology, combined with authoritarianism (based on ideology of high-knowledge supporters)
/* Given differential item functioning, in some countries there are so few supporters with knowledge scores of 3  
that we also use supporters with knowledge scores of 2. */
egen knowledge = anycount(gi1 gi4 gi7r1), values(1)
	g highknowledge = 1 if knowledge == 3
	sort pais
	by pais: egen numhighknowledge = count(highknowledge) 
	drop highknowledge
egen incumbentideology = mean(l1) if vb20 == 2 & (knowledge == 2 | knowledge == 3), by(pais)
		egen incumbentideology2 = mean(l1) if vb20 == 2 & knowledge == 3, by(pais)
		replace incumbentideology = incumbentideology2 if numhighknowledge >= 10
		drop knowledge incumbentideology2 numhighknowledge
	egen incumideol = mean(incumbentideology), by(pais)
		replace incumbentideology = incumideol
		drop incumideol
egen countryideology = mean(l1), by(pais)
	egen ci = mean(countryideology), by(pais)
	replace countryideology = ci
	drop ci
g incumbentideology_diff = incumbentideology - countryideology
recode incumbentideology_diff (-10/0 = 0) (.0000001/10 = 1), g(rightwingincumbent) 
g future_rw_auth = rightwingincumbent == 1 & sumauthfutincumbent == 1
g future_rw_nonauth = rightwingincumbent == 1 & sumauthfutincumbent == 0
g future_lw_auth = rightwingincumbent == 0 & sumauthfutincumbent == 1
g future_lw_nonauth = rightwingincumbent == 0 & sumauthfutincumbent == 0
*********************************************** end coding of authoritarian candidates

********************** Controls and correlates of authoritarian parenting
recode l1 (1/3 = 1) (4/10 .a .b .= 0) , g(leftist)
recode l1 (8/10 = 1) (1/7 .a .b .= 0), g(rightist)
lab var leftist "Leftist"
lab var rightist "Rightist"

factor ros2r ros3r ros4r ros6r
	predict statist

replace mil5 = 4-mil5
replace q5a = 6-q5a
replace ing4 = (ing4-1)/6
replace PSA5 = PSA5/100
replace quintall = (quintall-1)/4
replace edr = edr/3
replace colorr = (colorr-1)/10

***************************************************************************************************************************************
***************************************************************************************************************************************
**************************************************************** ANALYSIS *************************************************************

********* FIGURE 1. LEVELS OF AUTHORITARIANISM: Bring US and Canada data back
preserve
	use "C:\Users\aesmith2\Dropbox\Work\Data\LAPOP\Multiple country datasets\2012\AmericasBarometer Merged 2012 v50.0 English.dta", clear
	******* Code authoritarian parenting battery
	recode ab1 (1=0) (2=1) (3=.5), g(ab1r)
	recode ab2 (1=1) (2=0) (3=.5), g(ab2r)
	recode ab5 (1=0) (2=1) (3=.5), g(ab5r)
	egen authoritarianism = rowmean(ab1r ab2r ab5r)
	replace authoritarianism = authoritarianism*100
	drop if pais > 21 & pais < 40
	lp_comparative authoritarianism pais, eng date(ʺ2012ʺ) version(Merged v50.0)
restore

********* FIGURE 2. CONVERGENT VALIDATION
foreach var in statist rightist w14a gen1 vb50 prot3r vol207 vol205 ing4 PSA5 mil5 e5 e15 e14 tol d6 d8 q5a {
	pcorr authoritarian `var' i.pais
	matrix a = (r(p_corr))'
	svmat a, names(v)
	forvalues i = 2/35 {
		capture drop v`i'
	}
	rename v1 corrs_`var'
}
preserve
	keep corrs*
	drop in 2/29256
	xpose, varname clear
	egen variable = ends(_varname), punct(corrs_) tail
	replace variable = "Support for Social Welfare" in 1
	replace variable = "Rightist" in 2
	replace variable = "Anti-Abortion" in 3
	replace variable = "Gender Inegalitarianism" in 4
	replace variable = "Support Women Leaders" in 5
	replace variable = "Protested" in 6
	replace variable = "Spanking Approval" in 7
	replace variable = "Torture Approval" in 8
	replace variable = "Support for Democracy" in 9
	replace variable = "Support for Political System" in 10
	replace variable = "National Pride" in 11
	replace variable = "Approve Legal Protest" in 12
	replace variable = "Approve Protest Blocking Roads" in 13
	replace variable = "Approve Protest Siezing Property" in 14
	replace variable = "Political Tolerance" in 15
	replace variable = "Support for Gay Marriage" in 16
	replace variable = "Support State Media Restrictions" in 17
	replace variable = "Church Attendance" in 18
	g significant = (variable != "Support for Democracy")
	drop _varname
	sort v1
	sencode variable, replace
	save corrs.dta, replace
graph twoway (scatter v1 variable if significant == 1, mcolor(black) msymbol(O)) ///
	(scatter v1 variable if significant == 0, mcolor(gs10) msymbol(T)), ///
	xlabel(1(1)18, valuelabel angle(70) labsize(small)) xtitle("") yline(0, lcolor(gs10)) ///
	ytitle("Partial Correlation between Variable" "and Authoritarian Parenting", margin(medium)) ysize(6.5) ///
	legend(off) graphregion(lcolor(black) fcolor(white)) ///
	note("Estimates represent partial correlation coefficients, after accounting" ///
	"for country fixed effects. Black circles represent coefficients that are" ///
	"statistically significant at p<.05. Analysis limited to Latin America." ///
	"Source: AmericasBarometer by LAPOP 2012.", span) 
restore
drop corrs*
erase corrs.dta
	
********* Table 1. RETROSPECTIVE VOTE CHOICE FOR right-wing and left-wing AUTHORITARIAN CANDIDATEs
eststo clear
foreach dv in sumauthtmin lwaleader rwaleader {
	svy: logit `dv' authoritarianism mujer edr quintall colorr i.pais
	eststo
	svy: logit `dv' authoritarianism rightist ing4 PSA5 mujer edr quintall colorr i.pais 
	eststo
}
esttab, b(3) se(3) nopar nogaps star(* .05) keep(authoritarianism authoritarianism rightist ing4 PSA5 mujer edr quintall colorr _cons)


******* Figure 3. Does authoritarianism matter differently for rightists and nonrightists?
global results
eststo clear
foreach dv in lwaleader rwaleader {
	svy: logit `dv' c.authoritarianism##c.rightist ing4 PSA5 mujer edr quintall colorr i.pais 
		est sto `dv'results
	forvalues i = 1/2 {
		est restore `dv'results
		tempvar a
			g `a' = `i'-1			
		margins if rightist == `a', at((mean) _all authoritarianism=(0 .17 .33 .5 .67 .83 1)) post
			parmest, saving(`dv'_`a', replace) idstr(`dv'_`a') flist(results)
		drop `a'
	}
}
preserve
	clear
	append using $results
	egen rightist = seq(), f(0) t(1) block(7)
	egen leadertype = seq(), f(1) t(2) block(14)
		lab def leadertype 1 "Left-Wing Authoritarian Candidate" 2 "Right-Wing Authoritarian Candidate"
		lab val leadertype leadertype
	egen authoritarianism = seq(), f(0) t(6) block(1)
		replace authoritarianism = authoritarianism/6
	graph twoway (line estimate authoritarianism if leadertype == 1 & rightist == 0, lcolor(black)) ///
			(rspike min95 max95 authoritarianism if leadertype == 1 & rightist == 0, lcolor(black)) ///
			(line estimate authoritarianism if leadertype == 1 & rightist == 1, lcolor(gs8) lwidth(thick) lpattern(longdash)) ///
			(rspike min95 max95 authoritarianism if leadertype == 1 & rightist == 1, lcolor(black)), ///
		graphregion(fcolor(white) lcolor(white)) legend(off) title("Left-Wing Authoritarian Candidates", color(black) size(medlarge)) ///
		ytitle("Predicted Probability of Reporting" "Retrospective Vote for an Authoritarian Candidate", margin(small) size(medlarge)) ///
		ylabel(0(.1).5) xtitle("") ///
		text(.32 .8 "Rightists") text(.5 .8 "Non-Rightists") name(lwacands, replace)
	graph twoway (line estimate authoritarianism if leadertype == 2 & rightist == 0, lcolor(black)) ///
			(rspike min95 max95 authoritarianism if leadertype == 2 & rightist == 0, lcolor(black)) ///
			(line estimate authoritarianism if leadertype == 2 & rightist == 1, lcolor(gs8) lwidth(thick) lpattern(longdash)) ///
			(rspike min95 max95 authoritarianism if leadertype == 2 & rightist == 1, lcolor(black)), ///
		graphregion(fcolor(white) lcolor(white)) legend(off) title("Right-Wing Authoritarian Candidates", color(black) size(medlarge)) ///
		ytitle("") ylabel(0(.1).5, nolabel notick gmax) xtitle("") ///
		text(.35 .5 "Rightists") text(.15 .5 "Non-Rightists") name(rwacands, replace)
restore
graph combine lwacands rwacands, col(2) ///
	graphregion(fcolor(white) lcolor(black)) xsize(6.5) title("Authoritarianism", color(black) ring(1) pos(6) size(medium)) ///
	note("Coefficients and 95% confidence intervals for predicted probabilities from model controlling for support for democracy, " ///
	"support for political system, gender, education, wealth, and skin color. Source: AmericasBarometer 2012, v.50", span margin(small))
rm lwaleader___000000.dta
rm lwaleader___000001.dta
rm rwaleader___000002.dta
rm rwaleader___000003.dta


******* Figure 4. Future voting behavior
preserve
label save pais using paislabel.do, replace
global results ""
forvalues i = 1/18 {
	svy: mlogit vb20 authoritarianism mujer ed quintall colorr if pais == `i', baseoutcome(2) 
	parmest, format(estimate min90 max90 %8.2f) level(90) label saving(coeffs`i'.dta, replace) flist(results) idnum(`i')
}
clear
append using $results
drop if parm != "authoritarianism"
sencode eq, replace
	lab def eq 1 "Abstain" 2 "Opposition Vote" 3 "Blank/Null", modify
	lab val eq eq
sort eq estimate
egen xvar = seq(), f(1) t(18)
rename idnum pais
	do paislabel.do
	lab val pais pais
	decode pais, g(pais_neworder)
sencode pais_neworder if eq == 1, g(paiseq1)
graph twoway (scatter paiseq1 estimate if eq == 1, msymbol(O) mcolor(black)) ///
			(rspike min90 max90 paiseq1 if eq == 1, lcolor(black) horizontal), ///
		ylabel(1(1)18, valuelabel angle(horizontal)) ytitle("") ///
		xlabel(, format(%9.1f)) xtitle("") xline(0, lcolor(gs10)) title("Abstain", color(black) size(medium)) ///
		graphregion(fcolor(white) lcolor(white)) legend(off) name(abstain, replace)
sencode pais_neworder if eq == 2, g(paiseq2)
graph twoway (scatter paiseq2 estimate if eq == 2, msymbol(O) mcolor(black)) ///
			(rspike min90 max90 paiseq2 if eq == 2, lcolor(black) horizontal), ///
		ylabel(1(1)18, valuelabel angle(horizontal)) ytitle("") ///
		xlabel(, format(%9.1f)) xtitle("") xline(0, lcolor(gs10))  title("Opposition Vote", color(black) size(medium)) ///
		graphregion(fcolor(white) lcolor(white)) legend(off) name(opposition, replace)
sencode pais_neworder if eq == 3, g(paiseq3)
graph twoway (scatter paiseq3 estimate if eq == 3, msymbol(O) mcolor(black)) ///
			(rspike min90 max90 paiseq3 if eq == 3, lcolor(black) horizontal), ///
		ylabel(1(1)18, valuelabel angle(horizontal)) ytitle("") ///
		xlabel(, format(%9.1f)) xtitle("") xline(0, lcolor(gs10)) title("Blank/Null Vote", color(black) size(medium)) ///
		graphregion(fcolor(white) lcolor(white)) legend(off) name(blanknull, replace)
restore
graph combine abstain opposition blanknull, col(3) ysize(3) ///
	graphregion(fcolor(white) lcolor(black)) ///
	title("The Impact of Authoritarianism on Vote Choice 'If Election Were This Week':" ///
		"Results from Multinomial Logistic Regression Models within Each Country", size(medium) color(black)) ///
	note("Baseline category is vote for the incumbent. Coefficients and 90% confidence intervals for authoritarian parenting attitudes" ///
	"from model controlling for gender, education, wealth, and skin color. Source: AmericasBarometer 2012, v.50", span)
forvalues i = 1/18 {
	rm coeffs`i'.dta
}
rm paislabel.do

	
***************************************************************************************************************************************
****************************** in-text discussion *************************************************************************************
******** Predicted probs for education
logit sumauthtmin authoritarianism mujer edr quintall colorr i.pais
	margins, at((mean) _all edr=(0 .33 .67 1))
logit lwaleader authoritarianism mujer edr quintall colorr i.pais
	margins, at((mean) _all edr=(0 .33 .67 1))
logit rwaleader authoritarianism mujer edr quintall colorr i.pais
	margins, at((mean) _all edr=(0 .33 .67 1))

***************************************************************************************************************************************
****************************** Supplemental Information *******************************************************************************
********* Table A1. non-response on authoritarian battery
estimates clear
foreach var in ab1 ab2 ab5 {
	forvalues i = 1/18 {
		svy: tab `var' if pais == `i' & ab1 < .c, missing 
		estimates store `var'_country`i'
	}
	svy: tab `var' if ab1 < .c, missing 
	estimates store `var'_countryall
}
estimates table ab1_*
estimates table ab2_*
estimates table ab5_*

********* Table A2. alpha coefficients from authoritarianism battery
tempname memhold
tempfile results
postfile `memhold' country alpha using `results', replace
forvalues i = 1/18 {
	alpha ab1r ab2r ab5r if pais == `i'  
		scalar alpha_country`i' = r(alpha)
	post `memhold' (`i') (`=scalar(alpha_country`i')')
}
alpha ab1r ab2r ab5r 
	scalar alpha_countryall = r(alpha)
	post `memhold' (20) (`=scalar(alpha_countryall)')
postclose `memhold'
preserve
	append using `results'
	lab def pais 20 "Entire Region", modify
	lab val country pais
	tabstat alpha, by(country)
restore
scalar drop _all


******** Table A5. RETROSPECTIVE VOTE CHOICE model: one institutional authoritarianism measure at a time
eststo clear
foreach dv in sumauthtmin lwaleader rwaleader {
	svy: logit `dv' authoritarianism rightist ing4 mujer edr quintall colorr i.pais
	eststo
	svy: logit `dv' authoritarianism rightist PSA5 mujer edr quintall colorr i.pais 
	eststo
}
esttab, b(3) se(3) nopar nogaps star(* .05) keep(authoritarianism rightist ing4 PSA5 mujer edr quintall colorr _cons)

******** Table A6. RETROSPECTIVE VOTE CHOICE model interacting authoritarianism with a dummy for a country with an LWA candidate
eststo clear
svy: logit sumauthtmin c.authoritarianism##c.lwacountrypast c.rightist##c.lwacountrypast c.ing4##c.lwacountrypast c.PSA5##c.lwacountrypast ///
	mujer edr quintall colorr i.pais
eststo
esttab, b(3) se(3) nogaps nopar wide star(* .05) ///
	keep(authoritarianism rightist ing4 PSA5 ///
	c.rightist#c.lwacountrypast c.authoritarianism#c.lwacountrypast c.ing4#c.lwacountrypast c.PSA5#c.lwacountrypast lwacountrypast ///
	mujer edr quintall colorr _cons)

******** Table A7. RETROSPECTIVE VOTE CHOICE model: interacting authoritarianism with rightism
eststo clear
foreach dv in lwaleader rwaleader {
	svy: logit `dv' c.authoritarianism##c.rightist ing4 PSA5 mujer edr quintall colorr i.pais 
	eststo
}
esttab, b(3) se(3) nogaps nopar star(+ .10 * .05) ///
	keep(authoritarianism rightist c.authoritarianism#c.rightist ing4 PSA5 ///
	mujer edr quintall colorr _cons)

******* Figure A1 (Alternate Figure 3). Tripartite Interaction
global results
cd "C:\Users\aesmith2\Dropbox\Work\research in progress\Under review_authoritarian masses and elites\Final version"
eststo clear
foreach dv in lwaleader rwaleader {
	svy: logit `dv' c.authoritarianism##c.rightist c.authoritarianism##c.leftist ing4 PSA5 mujer edr quintall colorr i.pais 
		est sto `dv'results
	forvalues i = 0/1 {
		est restore `dv'results
		margins if rightist == `i' & leftist == 0, at((mean) _all authoritarianism=(0 .17 .33 .5 .67 .83 1)) post
		parmest, saving(`dv'_rightist`i'_leftist0, replace) idstr(`dv'_rightist`i'_leftist0) flist(results)
		}
	est restore `dv'results
	margins if rightist == 0 & leftist == 1, at((mean) _all authoritarianism=(0 .17 .33 .5 .67 .83 1)) post
	parmest, saving(`dv'_rightist0_leftist1, replace) idstr(`dv'_rightist0_leftist1) flist(results)
}
preserve
	clear
	append using $results
	egen ideology = seq(), f(0) t(2) block(7)
		recode ideology (0=1) (1=0)
		lab def ideology 0 "Rightist" 1 "Center/None" 2 "Leftist"
		lab val ideology ideology
	egen leadertype = seq(), f(1) t(2) block(21)
		lab def leadertype 1 "Left-Wing Authoritarian Candidate" 2 "Right-Wing Authoritarian Candidate"
		lab val leadertype leadertype
	egen authoritarianism = seq(), f(0) t(6) block(1)
		replace authoritarianism = authoritarianism/6
	graph twoway (rcap min95 max95 authoritarianism if leadertype == 1 & ideology == 0, lcolor(gs12)) ///
			(rcap min95 max95 authoritarianism if leadertype == 1 & ideology == 2, lcolor(gs12)) ///
			(line estimate authoritarianism if leadertype == 1 & ideology == 1, lcolor(gs8) lpattern(longdash)) ///
			(line estimate authoritarianism if leadertype == 1 & ideology == 2, lcolor(gs8) lwidth(thick) lpattern(longdash_dot)) ///
			(line estimate authoritarianism if leadertype == 1 & ideology == 0, lcolor(black)) , ///
		graphregion(fcolor(white) lcolor(white)) legend(off) title("Left-Wing Authoritarian Candidates", color(black) size(medlarge)) ///
		ytitle("Predicted Probability of Reporting" "Retrospective Vote for an Authoritarian Candidate", margin(small) size(medlarge)) ///
		ylabel(0(.1).8, gmax) xtitle("") ///
		text(.32 .8 "Rightists") text(.62 .8 "Leftists") text(.48 .2 "None/Centrist") ///
		name(lwacands, replace)
	graph twoway (rcap min95 max95 authoritarianism if leadertype == 2 & ideology == 0, lcolor(gs12)) ///
			(rcap min95 max95 authoritarianism if leadertype == 2 & ideology == 2, lcolor(gs12)) ///
			(line estimate authoritarianism if leadertype == 2 & ideology == 1, lcolor(gs8) lpattern(longdash)) ///
			(line estimate authoritarianism if leadertype == 2 & ideology == 2, lcolor(gs8) lwidth(thick) lpattern(longdash_dot)) ///
			(line estimate authoritarianism if leadertype == 2 & ideology == 0, lcolor(black)), ///
		graphregion(fcolor(white) lcolor(white)) legend(off) title("Right-Wing Authoritarian Candidates", color(black) size(medlarge)) ///
		ytitle("") ylabel(0(.1).8, nolabel notick gmax) xtitle("") ///
		text(.35 .5 "Rightists") text(.1 .5 "Leftists") text(.25 .7 "None/Centrist") ///
		name(rwacands, replace)
restore
graph combine lwacands rwacands, col(2) ///
	graphregion(fcolor(white) lcolor(black)) xsize(6.5) title("Authoritarianism", color(black) ring(1) pos(6) size(medium)) ///
	note("Coefficients and 95% confidence intervals for predicted probabilities from model controlling for support for democracy, " ///
	"support for political system, gender, education, wealth, and skin color. Source: AmericasBarometer 2012, v.50", span margin(small))
foreach dv in lwaleader rwaleader {
	rm `dv'_rightist0_leftist0.dta
	rm `dv'_rightist1_leftist0.dta
	rm `dv'_rightist0_leftist1.dta
}
	
******* Table A8. Does authoritarianism predict future support for authoritarian incumbents?
preserve
recode sumauthfutincumbent (1=0) if pais == 1 //remove Mexico from the measure, since in Mexico the incumbent wasn't going to run again.
eststo clear
svy: mlogit vb20 authoritarianism rightist ing4 mujer edr quintall colorr i.pais if sumauthfutincumbent == 1
eststo
svy: mlogit vb20 authoritarianism rightist PSA5 mujer edr quintall colorr i.pais if sumauthfutincumbent == 1
eststo
esttab, b(3) se(3) nogaps nopar star(* .05) unstack ///
	keep(authoritarianism rightist ing4 PSA5 mujer edr quintall colorr _cons)
restore

******* Tables A9-A12. Full models from prospective vote choice analysis with groups of countries
eststo clear
foreach countrytype in future_lw_nonauth future_rw_nonauth future_lw_auth future_rw_auth {
	svy: mlogit vb20 authoritarianism mujer edr quintall colorr i.pais if `countrytype' == 1, baseoutcome(2)
	eststo
}
esttab, b(3) se(3) nopar nogaps star(+ .10 * .05) keep(authoritarianism authoritarianism mujer edr quintall colorr _cons)

log close

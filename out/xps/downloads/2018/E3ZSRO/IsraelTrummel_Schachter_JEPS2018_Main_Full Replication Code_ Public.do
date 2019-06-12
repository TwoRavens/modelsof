/*
Replication Code for Article:
Does Shared Social Disadvantage Cause Black-Latino Political Commonality?
To Be Published in JEPS
Authors: Mackenzie Israel-Trummel and Ariela Schachter
contact: mackisr@ou.edu or ariela@wustl.edu

Code last updated: 3/2/2018
*/

/* Note: this do-file uses the following ado files: outreg2 and grc1leg. 
You will need to install them prior to running the do-file. */


/* Set your local file path here */
use IsraelTrummel_Schachter_JEPS2018_main.dta, replace

**Format Variables Used in Main Text and Appendix Analyses**
**Treatment Variables**
tab asm_treatment
gen asm_treat=.
replace asm_treat=1 if asm_treatment=="Placebo"
replace asm_treat=2 if asm_treatment=="Black"
replace asm_treat=3 if asm_treatment=="Latino"
replace asm_treat=4 if asm_treatment=="BlackLatino"

lab def asm_treat_lbl 1"Placebo" 2"Black" 3"Latino" 4"BlackLatino"
lab val asm_treat asm_treat_lbl

gen politicized=0
replace politicized=. if asm_treat==.
replace politicized=1 if asm_pol==1

gen domain=.
replace domain=1 if asm_domain=="education"
replace domain=2 if asm_domain=="housing"
lab def domain_lbl 1"education" 2"housing"
lab val domain domain_lbl

gen treat_by_pol=.
replace treat_by_pol=1 if asm_treat==1&politicized==0
replace treat_by_pol=2 if asm_treat==1&politicized==1
replace treat_by_pol=3 if asm_treat==2&politicized==0
replace treat_by_pol=4 if asm_treat==2&politicized==1
replace treat_by_pol=5 if asm_treat==3&politicized==0
replace treat_by_pol=6 if asm_treat==3&politicized==1
replace treat_by_pol=7 if asm_treat==4&politicized==0
replace treat_by_pol=8 if asm_treat==4&politicized==1
lab def treat_by_pol_lbl 1"Placebo, Non-politicized" 2"Placebo, Politicized" ///
3"Black, Non-politicized" 4"Black, Politicized" ///
5"Latino, Non-politicized" 6"Latino, Politicized" ///
7"Black&Latino, Non-politicized" 8"Black&Latino, Politicized"
lab val treat_by_pol treat_by_pol_lbl
drop if asm_treat==.

**Dependent Variable**
gen lat_pol_common=.
replace lat_pol_common=com_pol_1 if outgroup1=="Latinos"
replace lat_pol_common=com_pol_2 if outgroup2=="Latinos"
replace lat_pol_common=lat_pol_common+1

**Control/Moderator Variables**
**education**
gen coldeg=0
replace coldeg=1 if educat=="colgrad"
replace coldeg=. if educat==""
**interest in news**
gen highnewsint=0
replace highnewsint=1 if newsint==1
replace highnewsint=. if newsint==.
**linkedfate**
gen linkedfate=0
replace linkedfate=1 if cleanfate==1
replace linkedfate=. if cleanfate==.
**experienced discrimination**
gen exp_discrim=0
replace exp_discrim=1 if experdisc==1
replace exp_discrim=. if experdisc==.

**adding in exposure variables**
**1: state level: new destinations: SC, AL, TN, DE, AK, SD, NV, GA, KY, NC, 
**WY, ID, IN, MS; traditional dest: CA, NY, NJ, FL, TX, IL, MA; all else: non.
gen destination=3
replace destination=1 if state==39|state==1|state==41|state==7|state==4|state==40|state==27|state==9|state==16|state==32
replace destination =2 if state==5|state==31|state==29|state==8|state==42|state==12|state==20
lab def dest_lbl 1"New" 2"Traditional" 3"Other"
lab val destination dest_lbl
**definitions come from: http://www.migrationpolicy.org/article/immigrants-new-destination-states

**create categorical measure of exposure to Latinos**
gen latinopct_abovemean=0
replace latinopct_abovemean =1 if latinopct>15
replace latinopct_abovemean =. if latinopct==.
**create categorical measure of exposure to Whites**
gen whitepct_abovemean=0
replace whitepct_abovemean =1 if whitepct>41.5
replace whitepct_abovemean =. if whitepct==.

*******************************************************
**Figure 1: Treatment Effects on Latino Political Commonality**
/*NOTE: Run entire set of code to produce each figure, it temporarily collapses 
        the data into group means for graphing. The 'preserve' and 'restore' 
		commands prevent you from erasing the underlying data */
		
set more off
preserve
local varname lat_pol_common
local group1 asm_treat
collapse (mean) y= `varname' (semean) se_y=`varname', by(`group1')

sort `group1' 
gen x= _n

gen yu = y + 1.96*se_y
gen yl = y - 1.96*se_y

label define x 1"Placebo" 2"Black" 3"Latino" 4"Black Latino" 
			  
label value x x
local varname lat_pol_common
local group1 asm_treat
twoway (scatter y x , msymbol(S) msize(medium) mcolor(black)) ///
       (rcap yu yl x, lcolor(black)), scheme(lean1) ///
       xlabel(none) xtitle("") b2("{it:Treatment}") ///
	   ytitle("Mean Latino Commonality") ylabel(1(.5)4) xsc(range(1(.1)4.3)) ///
	   text(1 1 "Placebo", place(e)) ///
	   text(1 2 "Black", place(e)) ///
	   text(1 2.9 "Latino", place(e)) ///
	   text(1 3.8 "Black Latino", place(e)) ///
       legend(off)  

graph export replicate_fig1.pdf, as(pdf) replace

restore

**Table 1. OLS Estimates of Treatment Effects on Latino Political Commonality, Coefficients and (SEs)
set more off
reg lat_pol_common ib1.asm_treat i.politicized ib1.domain
outreg2 using replicate_table1.doc, stats (coef se) paren(se) dec(3) symbol(***,**,*,+) alpha(0.001, 0.01, 0.05, 0.10) replace word
reg lat_pol_common ib1.treat_by_pol ib1.domain
outreg2 using replicate_table1.doc, stats (coef se) paren(se) dec(3) symbol(***,**,*,+) alpha(0.001, 0.01, 0.05, 0.10) append word
reg lat_pol_common ib1.treat_by_pol if domain==1
outreg2 using replicate_table1.doc, stats (coef se) paren(se) dec(3) symbol(***,**,*,+) alpha(0.001, 0.01, 0.05, 0.10) append word
reg lat_pol_common ib1.treat_by_pol if domain==2
outreg2 using replicate_table1.doc, stats (coef se) paren(se) dec(3) symbol(***,**,*,+) alpha(0.001, 0.01, 0.05, 0.10) append word

***Figure 2. Political Messages and Treatment Effects on Latino Political Commonality
/*NOTE: Run entire set of code to produce each figure, it temporarily collapses 
        the data into group means for graphing. The 'preserve' and 'restore' 
		commands prevent you from erasing the underlying data */
		
preserve
local varname lat_pol_common
local group1 asm_treat
local group2 politicized
collapse (mean) y= `varname' (semean) se_y=`varname', by(`group1' `group2')

sort `group1' `group2'
gen x= _n
replace x= _n+2 if _n>=3
replace x=_n+4 if _n>=5
replace x= _n+6 if _n>=7


gen yu = y + 1.96*se_y
gen yl = y - 1.96*se_y

separate y, by(`group2')
separate yu, by(`group2')
separate yl, by(`group2')

label define x 1"Non-politicized" 2"Politicized" 

label value x x
local varname lat_pol_common
local group1 asm_treat
local group2 politicized
twoway (scatter y0 x , msymbol(S) msize(medium) mcolor(orange)) ///
       (rcap yu0 yl0 x, lcolor(orange))  ///
       (scatter y1 x , msymbol(O) msize(medium) mcolor(blue)) ///
       (rcap yu1 yl1 x, lcolor(blue)), scheme(lean1) ///
       xlabel(none) xtitle("") b2("{it:Treatment}") ///
	   ytitle("Mean Latino Commonality") ylabel(1(.5)4) ///
	   text(1 1 "Placebo", place(e)) ///
	   text(1 5 "Black", place(e)) ///
	   text(1 9 "Latino", place(e)) ///
	   text(1 12 "BlackLatino", place(e)) ///
       legend(order(1 "Non-politicized" 3 "Politicized") position(12) row(1) ring(0))	   

	   graph export replicate_fig2.pdf, as(pdf) replace

restore

***Appendix 2 Tables and Figures***
**Table A1: OLD Estimates of Treatment Effects with Controls, Coefficients and (SEs)**
set more off
reg lat_pol_common ib1.treat_by_pol coldeg highnewsint ///
    linkedfate exp_discrim ib3.destination latinopct_abovemean ///
	whitepct_abovemean if domain==1
outreg2 using appendix_a1_replicate.doc, stats (coef se) paren(se) dec(3) symbol(***,**,*,+) alpha(0.001, 0.01, 0.05, 0.10) replace word
reg lat_pol_common ib1.treat_by_pol coldeg highnewsint ///
    linkedfate exp_discrim ib3.destination latinopct_abovemean ///
	whitepct_abovemean if domain==2
outreg2 using appendix_a1_replicate.doc, stats (coef se) paren(se) dec(3) symbol(***,**,*,+) alpha(0.001, 0.01, 0.05, 0.10) append word

**Table A2: Commonality by Moderators, Means and (SDs) with Bivariate Tests for Differences
foreach var of varlist coldeg  linkedfate exp_discrim destination latinopct_abovemean whitepct_abovemean {
mean lat_pol_common, over(`var')
estat sd
reg lat_pol_common i.`var'
}	

**Figures A1 - A6**
**first, label vars for graphing**
lab def coldeg_lbl 0"Less than college degree" 1"College degree+"
lab val coldeg coldeg_lbl
lab def linked_lbl 0"No linked fate" 1"Linked fate"
lab val linkedfate linked_lbl
lab def exp_lbl 0"No discrimination" 1"Experienced discrimination"
lab val exp_discrim exp_lbl
lab def latinopct_lbl 0"% Latino below average" 1"% Latino above average"
lab def whitepct_lbl 0"%White below average" 1"%White above average"
lab val latinopct_abovemean latinopct_lbl
lab val whitepct_abovemean whitepct_lbl 

**Then make the graphs**
foreach var of varlist coldeg linkedfate exp_discrim latinopct_abovemean whitepct_abovemean {
set more off
quietly reg lat_pol_common ib1.treat_by_pol##i.`var' if domain==1
quietly margins treat_by_pol, over(`var')
marginsplot, recast(scatter) scheme(lean1) ///
ytitle("Predicted Latino Commonality") xtitle("Treatment") ///
title("Domain: Education", span) xlabel(,labsize(vsmall)angle(45)) ///
ylabel(1(.5)4) ///
plot1opts(msymbol(T) mcolor(blue) lcolor(blue)) ///
plot2opts(msymbol(S) mcolor(orange) lcolor(orange)) ///
ci1opts(lcolor(blue)) ///
ci2opts(lcolor(orange)) 
graph save `var'_education.gph, replace
quietly reg lat_pol_common ib1.treat_by_pol##i.`var' if domain==2
quietly margins treat_by_pol, over(`var')
marginsplot, recast(scatter) scheme(lean1) ///
ytitle("Predicted Latino Commonality") xtitle("Treatment") ///
title("Domain: Housing", span) xlabel(,labsize(vsmall)angle(45)) ///
ylabel(1(.5)4) ///
plot1opts(msymbol(T) mcolor(blue) lcolor(blue)) ///
plot2opts(msymbol(S) mcolor(orange) lcolor(orange)) ///
ci1opts(lcolor(blue)) ///
ci2opts(lcolor(orange)) 
graph save `var'_housing.gph, replace

grc1leg `var'_education.gph `var'_housing.gph, scheme(lean1) altshrink
graph export `var'_moderator_replicate.pdf, replace
}

set more off
quietly reg lat_pol_common ib1.treat_by_pol##i.destination if domain==1
quietly margins treat_by_pol, over(destination)
marginsplot, recast(scatter) scheme(lean1) ///
ytitle("Predicted Latino Commonality") xtitle("Treatment") ///
title("Domain: Education", span) xlabel(,labsize(vsmall)angle(45)) ///
ylabel(1(.5)4) ///
plot1opts(msymbol(T) mcolor(blue) lcolor(blue)) ///
plot2opts(msymbol(S) mcolor(orange) lcolor(orange)) ///
plot3opts(msymbol(D) mcolor(green) lcolor(orange)) ///
ci1opts(lcolor(blue)) ///
ci2opts(lcolor(orange)) ///
ci3opts(lcolor(green))
graph save destination_education.gph, replace
quietly reg lat_pol_common ib1.treat_by_pol##i.destination if domain==2
quietly margins treat_by_pol, over(destination)
marginsplot, recast(scatter) scheme(lean1) ///
ytitle("Predicted Latino Commonality") xtitle("Treatment") ///
title("Domain: Housing", span) xlabel(,labsize(vsmall)angle(45)) ///
ylabel(1(.5)4) ///
plot1opts(msymbol(T) mcolor(blue) lcolor(blue)) ///
plot2opts(msymbol(S) mcolor(orange) lcolor(orange)) ///
plot3opts(msymbol(D) mcolor(green) lcolor(orange)) ///
ci1opts(lcolor(blue)) ///
ci2opts(lcolor(orange)) ///
ci3opts(lcolor(green))
graph save destination_housing.gph, replace

grc1leg destination_education.gph destination_housing.gph, scheme(lean1) altshrink
graph export destination_moderator_replicate.pdf, replace

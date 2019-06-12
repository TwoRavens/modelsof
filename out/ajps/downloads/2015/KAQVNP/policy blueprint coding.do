/* 

%READ THIS FIRST%

This syntax file is for use in replicating the analyses in Alan M. Jacobs and J. Scott Matthews, "Policy Attitudes in Institutional 
Context: Rules, Uncertainty and the Mass Politics of Investment," American Journal of Political Science, n.d., and in the paper's
supporting information. This file creates the variables used in the analysis of the "Policy Blueprint" experiment. To 
replicate these analyses, see the file "analytics.do". For further information, see "readme.txt".


The following commands open the data file and create the "support index", the main dependent variable analyzed in the "Policy Blueprint" 
experiment. The variable is used in regressions reported in Table 2 and in the supporting information. */

set more off
use "policy blueprint data.dta", clear

for any supp wtp idea \ any 6 7 8: gen X=abs(qY-4)/3
for any supp wtp idea \ any 6 7 8: tab qY X, missing
gen index=(supp+wtp+idea)/3

/* The following commands create variables indicating levels of the "insitutional", "timing" and "incentive-based rhetoric" factors. 
These variables are used in regressions reported in Table 2 and in the supporting information. Note that these variables collapse 
together levels of an orthogonal factor, cost length, not analyzed in the present paper. For further information about the cost-length 
factor, see footnote 1 in the supporting information and "Codebook policy blueprint study.doc". */

gen t5=experiment1
recode t5 1/3 7/9 13/15=1 else=0

gen countarg=experiment1
recode countarg 1 7 13 4 10 16 19 21 23 25 27 29=1 3 9 15 6 12 18 31 32 33=0 else=2

gen integ=countarg
recode integ 2=1 else=0

gen cntrl=countarg
recode cntrl 0=1 else=0

gen capac=countarg
recode capac 2=0

gen actor=experiment1
recode actor 1/6 19 20 25 26 31=0 7/12 21 22 27 28 32=1 13/18 23 24 29 30 33=2

gen lg=actor
recode lg 2=0

gen ac=actor
recode ac 1=0 2=1

/* The following commands generate the measures of institutional confidence discussed in the "Institutional effects" subsection of the 
"Policy Blueprint Experiment" section of the paper and reported in the supporting information. Note that the order in which the four 
dimensions of confidence and three institutions were presented to respondents was randomized across subjects. For details regarding 
these questions, see the supporting information. */

gen wastelg=.
for any 1 2 3: replace wastelg=q24_X if q24_q27_X=="Local governments"

gen specllg=.
for any 1 2 3: replace specllg=q25_X if q24_q27_X=="Local governments"

gen breaklg=.
for any 1 2 3: replace breaklg=q26_X if q24_q27_X=="Local governments"

gen exprtlg=.
for any 1 2 3: replace exprtlg=q27_X if q24_q27_X=="Local governments"

gen wasteco=.
for any 1 2 3: replace wasteco=q24_X if q24_q27_X=="The U.S. Congress"

gen speclco=.
for any 1 2 3: replace speclco=q25_X if q24_q27_X=="The U.S. Congress"

gen breakco=.
for any 1 2 3: replace breakco=q26_X if q24_q27_X=="The U.S. Congress"

gen exprtco=.
for any 1 2 3: replace exprtco=q27_X if q24_q27_X=="The U.S. Congress"

gen wasteml=.
for any 1 2 3: replace wasteml=q24_X if q24_q27_X=="The military"

gen speclml=.
for any 1 2 3: replace speclml=q25_X if q24_q27_X=="The military"

gen breakml=.
for any 1 2 3: replace breakml=q26_X if q24_q27_X=="The military"

gen exprtml=.
for any 1 2 3: replace exprtml=q27_X if q24_q27_X=="The military"

for var wastelg-exprtml: replace X=(X-1)/10
foreach i of var wastelg-exprtml {
	sum `i'
	replace `i'=r(mean) if `i'==.
	}

for any lg co ml: egen trust_X=rowmean(wasteX-exprtX)
for any lg co ml \ any "Local government" "Congress" "Military": la var trust_X "Pol trust, all dims, Y"

/* The following commands generate measures of the covariates analyzed in the paper and supporting information, including
the measure of "anti-government sentiment" (the variable named "lessgov", below). Note that the variable named "drivmins" -- 
the measure of "driving time" analyzed in the supporting information (Table A1) -- is truncated at the 99th percentile of
valid responses, that is, at 540 minutes. */

gen lessgov=q2
recode lessgov 2=0
sum lessgov
replace lessgov=r(mean) if lessgov==.
replace lessgov=1 if lessgov>.5

gen nepcurr=(abs(q5-5))/4
sum nepcurr
replace nepcurr=r(mean) if nepcurr==.
 
gen drivmins=q15
replace drivmins=q14*60 if q15==.
replace drivmins=540 if drivmins>540 & drivmins~=. 
sum drivmins
replace drivmins=r(mean) if drivmins==. & q12==1
replace drivmins=0 if drivmins==. & q12==2
sum drivmins
replace drivmins=r(mean) if drivmins==.

gen ln_drivmins=ln(drivmins)

for any 21 22x 22y 23 \ any 3 1 4 3: gen qX_=(qX==Y)
egen pk=rowtotal(q21_ q22x_ q22y_ q23_)
replace pk=pk/4

gen woman=gender-1

gen rpid=(pid7>=5 & pid7<=7)
gen dpid=(pid7>=1 & pid7<=3)

gen black=race==2

gen inc=(income-1)/13
replace inc=. if inc>1
sum inc
replace inc=r(mean) if inc==.

gen degree=(educ>=5 & educ<=6)

/* These commands create interactions between the institutional factor and both the experimental factors and the covariates. */

for any t5 cntrl capac lessgov pk inc degree black drivmins ln_drivmins woman: gen lg_X=lg*X
for any t5 cntrl capac lessgov pk inc degree black drivmins ln_drivmins woman: gen ac_X=ac*X

/* These statements apply labels to all variables included in regression analyses reported in tables in the paper and 
the supporting information. */

global index="Support Index"
global t5="5-year Timing"
global cntrl="Rhetorical Control"
global capac="Capacity Uncertainty"
global lg="Loc. Govt."
global ac="Army Corps"
global lessgov="Anti-Govt."
global pk="Political knowledge"
global inc="Income"
global degree="University degree"
global black="African-American"
global drivmins="Driving Time"
global ln_drivmins="Logged Driving Time"
global woman="Woman"
global nepcurr="National Economic Perception"
global rpid="Republican Party Identification"
global dpid="Democratic Party Identification"

foreach i in index t5 cntrl capac lg ac lessgov pk inc degree black drivmins ln_drivmins woman nepcurr rpid dpid {
	la var `i' "$`i'"
}

foreach i in lg ac {
	foreach x in t5 cntrl capac lessgov pk inc degree black drivmins ln_drivmins woman {
		la var `i'_`x' "$`i' * $`x'"
	}
}

/* This command defines a global macro that is used in specifying certain regressions in "analytics.do". */

global x "lg ac lessgov lg_lessgov ac_lessgov"

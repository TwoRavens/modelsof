/* 

%READ THIS FIRST%

This syntax file is for use in replicating the analyses in Alan M. Jacobs and J. Scott Matthews, "Policy Attitudes in Institutional 
Context: Rules, Uncertainty and the Mass Politics of Investment," American Journal of Political Science, n.d., and in the paper's
supporting information. This file creates the variables used in the analysis of the "Institutional Vignette" experiments. To 
these replicate analyses, see the file "analytics.do". For further information, see "readme.txt".


The following commands open the data file and create the "social investment support" measure, the main dependent variable analyzed in 
the "Institutional Vignette" studies. The variable is used in regressions reported in Tables 3 and 4 and in the supporting information. */*/

set more off
use "institutional vignette data.dta", clear

forvalues i=1/6 {
	gen m4q`i'_=(abs(m4q`i'-4))/3
	}

egen wtp=rowmean(m4q1_-m4q6_) if wave==0

gen wtpfirst2=mod4
recode wtpfirst2 1 16=1 2 17=2 3 19=3 4 22=4 5 26=5 6 18=6 7 20=7 8 23=8 9 27=9 /*
*/10 21=10 11 24=11 12 28=12 13 25=13 14 29=14 15 30=15 

egen wtp21=rowmean(m4q1_ m4q2_) if wtpfirst2==1 & wave==1
egen wtp22=rowmean(m4q1_ m4q3_) if wtpfirst2==2 & wave==1
egen wtp23=rowmean(m4q1_ m4q4_) if wtpfirst2==3 & wave==1
egen wtp24=rowmean(m4q1_ m4q5_) if wtpfirst2==4 & wave==1
egen wtp25=rowmean(m4q1_ m4q6_) if wtpfirst2==5 & wave==1
egen wtp26=rowmean(m4q2_ m4q3_) if wtpfirst2==6 & wave==1
egen wtp27=rowmean(m4q2_ m4q4_) if wtpfirst2==7 & wave==1
egen wtp28=rowmean(m4q2_ m4q5_) if wtpfirst2==8 & wave==1
egen wtp29=rowmean(m4q2_ m4q6_) if wtpfirst2==9 & wave==1
egen wtp210=rowmean(m4q3_ m4q4_) if wtpfirst2==10 & wave==1
egen wtp211=rowmean(m4q3_ m4q5_) if wtpfirst2==11 & wave==1
egen wtp212=rowmean(m4q3_ m4q6_) if wtpfirst2==12 & wave==1
egen wtp213=rowmean(m4q4_ m4q5_) if wtpfirst2==13 & wave==1
egen wtp214=rowmean(m4q4_ m4q6_) if wtpfirst2==14 & wave==1
egen wtp215=rowmean(m4q5_ m4q6_) if wtpfirst2==15 & wave==1

forv i=1/15 {
	replace wtp=wtp2`i' if wtpfirst2==`i' & wave==1
	}

drop wtp21-wtp215

/* The following commands create variables indicating levels of the "electoral insulation" and "constraint" factors. 
These variables are used in regressions reported in Tables 3 and 4, and in the supporting information. */

gen inshi=mod2_treatment
recode inshi 2=1 else=0

gen cnsthi=mod2_treatment
recode cnsthi 5=1 else=0

/* The following commands generate the "political-uncertainty index" analyzed in regressions in Table 5 and in the 
supporting information. */

for any m7q2 m7q3 m7q4: gen X_=(abs(X-10))/10
for any m7q1 m7q5 m7q6: gen X_=X/10
alpha m7q4_ m7q1_ m7q5_ m7q6_, g(all_cert)
gen spnd_uncert=abs(all_cert-1)

/* The following commands generate measures of the covariates analyzed in the paper and supporting information, including
the measure of "anti-government sentiment" (the variable named "lessgov", below).  */

for any 1 2 3 4 5 6 \ any 1 2 2 2 2 5: gen m6qX_=m6qX==Y
for any 1 2 3 4 5 6: replace m6qX_=. if mod4_order==.
egen pkscale=rowtotal(m6q1_-m6q6_)
replace pkscale=. if m6q1_==.

gen lessgov=m1q1
recode lessgov 2=0

gen woman=gender==2

gen degree=(educ>=5 & educ~=.)

gen black=(race==2)

for any m1q2 m1q3 \ any egal pep: gen Y=X \ replace Y=abs(Y-5)/4 \ tab X Y
gen egalr=abs(egal-1)

gen income=faminc
sum income if income<16
replace income=r(mean) if (income>16 & income~=.)
replace income=(income-1)/15

/* These commands create interactions between, on the one hand, the constraint and electoral-insulation factors and, 
on the other hand, the covariates. */

for any lessgov pkscale income degree black woman: gen cnsthi_X=cnsthi*X
for any lessgov: gen inshi_X=inshi*X

/* These statements apply labels to all variables included in regression analyses reported in tables in the paper and 
the supporting information. Note that the syntax below adds to the using dataset five empty (i.e., missing for all cases) 
variables with the same names as variables in the Policy Blueprint study. These allow labels to be applied to the 
variables comprising model (1) in Table A4 using the OUTREG2 package. */

global wtp="Social Investment Support"
global inshi="High Electoral Insulation"
global cnsthi="High Constraint"
global spnd_uncert="Political-uncertainty Index"
global egalr="Egalitarianism"
global lessgov="Anti-Govt."
global pkscale="Political knowledge"
global income="Income"
global degree="University degree"
global black="African-American"
global woman="Woman"
global pep="Personal Economic Perception"
global lg="Loc. Govt."
global ac="Army Corps"
global nepcurr="National Economic Perception"
global rpid="Republican Party Identification"
global dpid="Democratic Party Identification"

for any lg ac nepcurr rpid dpid lg_lessgov ac_lessgov: gen X=.

foreach i in lg ac nepcurr rpid dpid {
	la var `i' "$`i'"
}

foreach i in lg ac {
	foreach x in lessgov {
		la var `i'_`x' "$`i' * $`x'"
	}
}

foreach i in wtp inshi cnsthi spnd_uncert egalr lessgov pkscale income degree black woman pep {
	la var `i' "$`i'"
}

foreach x in lessgov pkscale income degree black woman {
	la var cnsthi_`x' "$cnsthi * $`x'"
}

la var inshi_lessgov "$inshi * $lessgov"





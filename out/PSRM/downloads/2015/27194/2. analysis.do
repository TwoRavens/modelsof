****************************************
* Political Science Research and Methods
* Replication material for the article "The Role of Party Identification in Spatial Models of Voting Choice"
*
* Romain Lachat
* Universitat Pompeu Fabra, Barcelona
* mail@romain-lachat.ch
*
* This syntax contains the commands to replicate the papers' tables and graphs, based on the recoded and merged file
* of the 1994 to 2006 Dutch election studies.
* The syntax file "1. recode.do" creates this merged file, starting from the original datasets of the corresponding
* election studies.
****************************************

cd "c:\data\"

clear
set mem 400m
use nlstacked


***************************
** Data for Table A1
** (descriptive statistics)
***************************

*NB: in the model replications including sophistication, this variable will be centred (see below, commands for Table A3)
quietly regress util idyes idown prox2_iss1 prox2_iss2 prox2_iss3 prox2_iss4 prox2_iss5 prox2_iss6 if year==1994 [pweight=weighti], cluster(id)
su util idyes idown soph prox2_iss1 prox2_iss2 prox2_iss3 prox2_iss4 prox2_iss5 prox2_iss6 if year==1994 & e(sample) [iweight=weighti]
quietly regress util idyes idown prox2_iss1 prox2_iss3 prox2_iss4 prox2_iss5 prox2_iss6 prox2_iss7 prox2_iss8 if year==1998 [pweight=weighti], cluster(id)
su util idyes idown soph prox2_iss1 prox2_iss3 prox2_iss4 prox2_iss5 prox2_iss6 prox2_iss7 prox2_iss8 if year==1998 & e(sample)  [iweight=weighti]
quietly regress util idyes idown prox2_iss1 prox2_iss2 prox2_iss3 prox2_iss4 prox2_iss5 prox2_iss6 prox2_iss7 if year==2002 [pweight=weighti], cluster(id)
su util idyes idown soph prox2_iss1 prox2_iss2 prox2_iss3 prox2_iss4 prox2_iss5 prox2_iss6 prox2_iss7 if year==2002 & e(sample)  [iweight=weighti]
quietly regress util idyes idown prox2_iss1 prox2_iss2 prox2_iss3 prox2_iss4 prox2_iss5 prox2_iss6 prox2_iss7 if year==2006 [pweight=weighti], cluster(id)
su util idyes idown soph prox2_iss1 prox2_iss2 prox2_iss3 prox2_iss4 prox2_iss5 prox2_iss6 prox2_iss7 if year==2006 & e(sample)  [iweight=weighti]



**********************************
** Regression results for Table A2
**********************************
#delimit ;
regress util idyes idown
prox2_iss1 idyes_prox2_iss1 idown_prox2_iss1 
prox2_iss2 idyes_prox2_iss2 idown_prox2_iss2 
prox2_iss3 idyes_prox2_iss3 idown_prox2_iss3 
prox2_iss4 idyes_prox2_iss4 idown_prox2_iss4 
prox2_iss5 idyes_prox2_iss5 idown_prox2_iss5 
prox2_iss6 idyes_prox2_iss6 idown_prox2_iss6 if year==1994 [pweight=weighti], cluster(id); #delimit cr
#delimit ;
regress util idyes idown
prox2_iss1 idyes_prox2_iss1 idown_prox2_iss1 
prox2_iss3 idyes_prox2_iss3 idown_prox2_iss3 
prox2_iss4 idyes_prox2_iss4 idown_prox2_iss4 
prox2_iss5 idyes_prox2_iss5 idown_prox2_iss5 
prox2_iss6 idyes_prox2_iss6 idown_prox2_iss6 
prox2_iss7 idyes_prox2_iss7 idown_prox2_iss7 
prox2_iss8 idyes_prox2_iss8 idown_prox2_iss8 if year==1998 [pweight=weighti], cluster(id) ; #delimit cr
#delimit ;
regress util idyes idown
prox2_iss1 idyes_prox2_iss1 idown_prox2_iss1 
prox2_iss2 idyes_prox2_iss2 idown_prox2_iss2 
prox2_iss3 idyes_prox2_iss3 idown_prox2_iss3 
prox2_iss4 idyes_prox2_iss4 idown_prox2_iss4 
prox2_iss5 idyes_prox2_iss5 idown_prox2_iss5 
prox2_iss6 idyes_prox2_iss6 idown_prox2_iss6 
prox2_iss7 idyes_prox2_iss7 idown_prox2_iss7 if year==2002 [pweight=weighti], cluster(id) ; #delimit cr
#delimit ;
regress util idyes idown
prox2_iss1 idyes_prox2_iss1 idown_prox2_iss1 
prox2_iss2 idyes_prox2_iss2 idown_prox2_iss2 
prox2_iss3 idyes_prox2_iss3 idown_prox2_iss3 
prox2_iss4 idyes_prox2_iss4 idown_prox2_iss4 
prox2_iss5 idyes_prox2_iss5 idown_prox2_iss5 
prox2_iss6 idyes_prox2_iss6 idown_prox2_iss6 
prox2_iss7 idyes_prox2_iss7 idown_prox2_iss7 if year==2006 [pweight=weighti], cluster(id) ; #delimit cr



**************************************************************
** Figure 1: Predicted party utilities by voter-party distance
** and party identification, 2006 election
**
** NB: after estimating the corresponding model, new 
**     observations are temporarily added to the dataset, with
**     the combinations of values to be used in the graph. The
**     model predictions are then computed for these additional
**     observations and are plotted in Figure 1
**************************************************************
preserve
set obs 78000
#delimit ;
regress util idyes idown
prox2_iss1 idyes_prox2_iss1 idown_prox2_iss1 
prox2_iss2 idyes_prox2_iss2 idown_prox2_iss2 
prox2_iss3 idyes_prox2_iss3 idown_prox2_iss3 
prox2_iss4 idyes_prox2_iss4 idown_prox2_iss4 
prox2_iss5 idyes_prox2_iss5 idown_prox2_iss5 
prox2_iss6 idyes_prox2_iss6 idown_prox2_iss6 
prox2_iss7 idyes_prox2_iss7 idown_prox2_iss7 if year==2006 [pweight=weighti], cluster(id) ; #delimit cr
local j 77000
foreach d of numlist 0 .15 .37 .59 {
	replace idyes=0 in `j'
	replace idown=0 in `j'
	forvalues i=1/7 {
		replace prox2_iss`i'=`d' in `j'
	}
	local ++j
	replace idyes=1 in `j'
	replace idown=0 in `j'
	forvalues i=1/7 {
		replace prox2_iss`i'=`d' in `j'
	}
	local ++j
	replace idyes=1 in `j'
	replace idown=1 in `j'
	forvalues i=1/7 {
		replace prox2_iss`i'=`d' in `j'
	}
	local ++j
}
for num 1/7: replace idyes_prox2_issX=idyes*prox2_issX in 77000/78000 \ replace idown_prox2_issX=idown*prox2_issX in 77000/78000
predict yhat, 
predict stderr, stdp 
g yhat_lo=yhat-1.95*stderr
g yhat_hi=yhat+1.95*stderr
keep in 77000/78000
#delimit ;
twoway
(rarea yhat_lo yhat_hi prox2_iss1 if idyes==0, color(gs8))
(rarea yhat_lo yhat_hi prox2_iss1 if idyes==1 & idown==0, color(gs8))
(rarea yhat_lo yhat_hi prox2_iss1 if idyes==1 & idown==1, color(gs8))
(line yhat prox2_iss1 if idyes==0, lc(black) lp(solid) lw(medthick))
(line yhat prox2_iss1 if idyes==1 & idown==0, lc(black) lp(dash) lw(medthick))
(line yhat prox2_iss1 if idyes==1 & idown==1, lc(black) lp(shortdash) lw(medthick)),
legend(order(4 "Nonidentifier" 5 "Identifier: other party" 6 "Identifier: own party" 2 "95% CI") row(2))
ytitle("Predicted party utility") xtitle("Voter-party distance (on all issues)") graphregion(color(white))
; #delimit cr
graph export "Figure 1.eps", as(eps) preview(on) replace
restore



**************************************************************
** Table 1: predicted utilities when issue distances equal 0
** Figures 2-5: Impact of party identification, issue by issue
**
** NB: The following commands save the estimated parameters and
**     the associated standard errors of the regression models.
**     For each election, the model is estimated three times,
**     by changing the reference category for party 
**     identification (non-identifiers, own identifiers, other
**     identifiers). The intercept of each model corresponds to
**     the predicted party utility when all distances are equal
**     to 0 (results presented in Table 1). The coefficients and 
**     standard error for each issue are saved in new
**     variables and later used to plot figures 2 to 4
**************************************************************
preserve
g _year=.
g _iss=.
g _type=.
g _beta=.
g _stderr=.

local i 1
quietly regress util idyes idown prox2_iss1 idyes_prox2_iss1 idown_prox2_iss1 prox2_iss2 idyes_prox2_iss2 idown_prox2_iss2 prox2_iss3 idyes_prox2_iss3 idown_prox2_iss3 prox2_iss4 idyes_prox2_iss4 idown_prox2_iss4 prox2_iss5 idyes_prox2_iss5 idown_prox2_iss5 prox2_iss6 idyes_prox2_iss6 idown_prox2_iss6 if year==1994 [pweight=weighti], cluster(id)
matrix params=e(b)
matrix V=e(V)
local row 3
foreach iss of numlist 1/6 0 {
	quietly replace _year=1994 in `i'
	quietly replace _iss=`iss' in `i'
	quietly replace _type=1 in `i'
	quietly replace _beta=params[1,`row'] in `i'
	quietly replace _stderr=V[`row',`row']^.5 in `i'
	local row=`row'+3
	local ++i
}
quietly regress util idnone idother prox2_iss1 idnone_prox2_iss1 idother_prox2_iss1 prox2_iss2 idnone_prox2_iss2 idother_prox2_iss2 prox2_iss3 idnone_prox2_iss3 idother_prox2_iss3 prox2_iss4 idnone_prox2_iss4 idother_prox2_iss4 prox2_iss5 idnone_prox2_iss5 idother_prox2_iss5 prox2_iss6 idnone_prox2_iss6 idother_prox2_iss6 if year==1994 [pweight=weighti], cluster(id)
matrix params=e(b)
matrix V=e(V)
local row 3
foreach iss of numlist 1/6 0 {
	quietly replace _year=1994 in `i'
	quietly replace _iss=`iss' in `i'
	quietly replace _type=2 in `i'
	quietly replace _beta=params[1,`row'] in `i'
	quietly replace _stderr=V[`row',`row']^.5 in `i'
	local row=`row'+3
	local ++i
}
quietly regress util idnone idown prox2_iss1 idnone_prox2_iss1 idown_prox2_iss1 prox2_iss2 idnone_prox2_iss2 idown_prox2_iss2 prox2_iss3 idnone_prox2_iss3 idown_prox2_iss3 prox2_iss4 idnone_prox2_iss4 idown_prox2_iss4 prox2_iss5 idnone_prox2_iss5 idown_prox2_iss5 prox2_iss6 idnone_prox2_iss6 idown_prox2_iss6 if year==1994 [pweight=weighti], cluster(id)
matrix params=e(b)
matrix V=e(V)
local row 3
foreach iss of numlist 1/6 0 {
	quietly replace _year=1994 in `i'
	quietly replace _iss=`iss' in `i'
	quietly replace _type=3 in `i'
	quietly replace _beta=params[1,`row'] in `i'
	quietly replace _stderr=V[`row',`row']^.5 in `i'
	local row=`row'+3
	local ++i
}

quietly regress util idyes idown prox2_iss1 idyes_prox2_iss1 idown_prox2_iss1 prox2_iss3 idyes_prox2_iss3 idown_prox2_iss3 prox2_iss4 idyes_prox2_iss4 idown_prox2_iss4 prox2_iss5 idyes_prox2_iss5 idown_prox2_iss5 prox2_iss6 idyes_prox2_iss6 idown_prox2_iss6 prox2_iss7 idyes_prox2_iss7 idown_prox2_iss7 prox2_iss8 idyes_prox2_iss8 idown_prox2_iss8 if year==1998 [pweight=weighti], cluster(id)
matrix params=e(b)
matrix V=e(V)
local row 3
foreach iss of numlist 1 3/8 0 {
	quietly replace _year=1998 in `i'
	quietly replace _iss=`iss' in `i'
	quietly replace _type=1 in `i'
	quietly replace _beta=params[1,`row'] in `i'
	quietly replace _stderr=V[`row',`row']^.5 in `i'
	local row=`row'+3
	local ++i
}
quietly regress util idnone idother prox2_iss1 idnone_prox2_iss1 idother_prox2_iss1 prox2_iss3 idnone_prox2_iss3 idother_prox2_iss3 prox2_iss4 idnone_prox2_iss4 idother_prox2_iss4 prox2_iss5 idnone_prox2_iss5 idother_prox2_iss5 prox2_iss6 idnone_prox2_iss6 idother_prox2_iss6 prox2_iss7 idnone_prox2_iss7 idother_prox2_iss7 prox2_iss8 idnone_prox2_iss8 idother_prox2_iss8 if year==1998 [pweight=weighti], cluster(id)
matrix params=e(b)
matrix V=e(V)
local row 3
foreach iss of numlist 1 3/8 0 {
	quietly replace _year=1998 in `i'
	quietly replace _iss=`iss' in `i'
	quietly replace _type=2 in `i'
	quietly replace _beta=params[1,`row'] in `i'
	quietly replace _stderr=V[`row',`row']^.5 in `i'
	local row=`row'+3
	local ++i
}
quietly regress util idnone idown prox2_iss1 idnone_prox2_iss1 idown_prox2_iss1 prox2_iss3 idnone_prox2_iss3 idown_prox2_iss3 prox2_iss4 idnone_prox2_iss4 idown_prox2_iss4 prox2_iss5 idnone_prox2_iss5 idown_prox2_iss5 prox2_iss6 idnone_prox2_iss6 idown_prox2_iss6 prox2_iss7 idnone_prox2_iss7 idown_prox2_iss7 prox2_iss8 idnone_prox2_iss8 idown_prox2_iss8 if year==1998 [pweight=weighti], cluster(id)
matrix params=e(b)
matrix V=e(V)
local row 3
foreach iss of numlist 1 3/8 0 {
	quietly replace _year=1998 in `i'
	quietly replace _iss=`iss' in `i'
	quietly replace _type=3 in `i'
	quietly replace _beta=params[1,`row'] in `i'
	quietly replace _stderr=V[`row',`row']^.5 in `i'
	local row=`row'+3
	local ++i
}

quietly regress util idyes idown prox2_iss1 idyes_prox2_iss1 idown_prox2_iss1 prox2_iss2 idyes_prox2_iss2 idown_prox2_iss2 prox2_iss3 idyes_prox2_iss3 idown_prox2_iss3 prox2_iss4 idyes_prox2_iss4 idown_prox2_iss4 prox2_iss5 idyes_prox2_iss5 idown_prox2_iss5 prox2_iss6 idyes_prox2_iss6 idown_prox2_iss6 prox2_iss7 idyes_prox2_iss7 idown_prox2_iss7 if year==2002 [pweight=weighti], cluster(id)
matrix params=e(b)
matrix V=e(V)
local row 3
foreach iss of numlist 1/7 0 {
	quietly replace _year=2002 in `i'
	quietly replace _iss=`iss' in `i'
	quietly replace _type=1 in `i'
	quietly replace _beta=params[1,`row'] in `i'
	quietly replace _stderr=V[`row',`row']^.5 in `i'
	local row=`row'+3
	local ++i
}
quietly regress util idnone idother prox2_iss1 idnone_prox2_iss1 idother_prox2_iss1 prox2_iss2 idnone_prox2_iss2 idother_prox2_iss2 prox2_iss3 idnone_prox2_iss3 idother_prox2_iss3 prox2_iss4 idnone_prox2_iss4 idother_prox2_iss4 prox2_iss5 idnone_prox2_iss5 idother_prox2_iss5 prox2_iss6 idnone_prox2_iss6 idother_prox2_iss6 prox2_iss7 idnone_prox2_iss7 idother_prox2_iss7 if year==2002 [pweight=weighti], cluster(id)
matrix params=e(b)
matrix V=e(V)
local row 3
foreach iss of numlist 1/7 0 {
	quietly replace _year=2002 in `i'
	quietly replace _iss=`iss' in `i'
	quietly replace _type=2 in `i'
	quietly replace _beta=params[1,`row'] in `i'
	quietly replace _stderr=V[`row',`row']^.5 in `i'
	local row=`row'+3
	local ++i
}
quietly regress util idnone idown prox2_iss1 idnone_prox2_iss1 idown_prox2_iss1 prox2_iss2 idnone_prox2_iss2 idown_prox2_iss2 prox2_iss3 idnone_prox2_iss3 idown_prox2_iss3 prox2_iss4 idnone_prox2_iss4 idown_prox2_iss4 prox2_iss5 idnone_prox2_iss5 idown_prox2_iss5 prox2_iss6 idnone_prox2_iss6 idown_prox2_iss6 prox2_iss7 idnone_prox2_iss7 idown_prox2_iss7 if year==2002 [pweight=weighti], cluster(id)
matrix params=e(b)
matrix V=e(V)
local row 3
foreach iss of numlist 1/7 0 {
	quietly replace _year=2002 in `i'
	quietly replace _iss=`iss' in `i'
	quietly replace _type=3 in `i'
	quietly replace _beta=params[1,`row'] in `i'
	quietly replace _stderr=V[`row',`row']^.5 in `i'
	local row=`row'+3
	local ++i
}

quietly regress util idyes idown prox2_iss1 idyes_prox2_iss1 idown_prox2_iss1 prox2_iss2 idyes_prox2_iss2 idown_prox2_iss2 prox2_iss3 idyes_prox2_iss3 idown_prox2_iss3 prox2_iss4 idyes_prox2_iss4 idown_prox2_iss4 prox2_iss5 idyes_prox2_iss5 idown_prox2_iss5 prox2_iss6 idyes_prox2_iss6 idown_prox2_iss6 prox2_iss7 idyes_prox2_iss7 idown_prox2_iss7 if year==2006 [pweight=weighti], cluster(id)
matrix params=e(b)
matrix V=e(V)
local row 3
foreach iss of numlist 1/7 0 {
	quietly replace _year=2006 in `i'
	quietly replace _iss=`iss' in `i'
	quietly replace _type=1 in `i'
	quietly replace _beta=params[1,`row'] in `i'
	quietly replace _stderr=V[`row',`row']^.5 in `i'
	local row=`row'+3
	local ++i
}
quietly regress util idnone idother prox2_iss1 idnone_prox2_iss1 idother_prox2_iss1 prox2_iss2 idnone_prox2_iss2 idother_prox2_iss2 prox2_iss3 idnone_prox2_iss3 idother_prox2_iss3 prox2_iss4 idnone_prox2_iss4 idother_prox2_iss4 prox2_iss5 idnone_prox2_iss5 idother_prox2_iss5 prox2_iss6 idnone_prox2_iss6 idother_prox2_iss6 prox2_iss7 idnone_prox2_iss7 idother_prox2_iss7 if year==2006 [pweight=weighti], cluster(id)
matrix params=e(b)
matrix V=e(V)
local row 3
foreach iss of numlist 1/7 0 {
	quietly replace _year=2006 in `i'
	quietly replace _iss=`iss' in `i'
	quietly replace _type=2 in `i'
	quietly replace _beta=params[1,`row'] in `i'
	quietly replace _stderr=V[`row',`row']^.5 in `i'
	local row=`row'+3
	local ++i
}
quietly regress util idnone idown prox2_iss1 idnone_prox2_iss1 idown_prox2_iss1 prox2_iss2 idnone_prox2_iss2 idown_prox2_iss2 prox2_iss3 idnone_prox2_iss3 idown_prox2_iss3 prox2_iss4 idnone_prox2_iss4 idown_prox2_iss4 prox2_iss5 idnone_prox2_iss5 idown_prox2_iss5 prox2_iss6 idnone_prox2_iss6 idown_prox2_iss6 prox2_iss7 idnone_prox2_iss7 idown_prox2_iss7 if year==2006 [pweight=weighti], cluster(id)
matrix params=e(b)
matrix V=e(V)
local row 3
foreach iss of numlist 1/7 0 {
	quietly replace _year=2006 in `i'
	quietly replace _iss=`iss' in `i'
	quietly replace _type=3 in `i'
	quietly replace _beta=params[1,`row'] in `i'
	quietly replace _stderr=V[`row',`row']^.5 in `i'
	local row=`row'+3
	local ++i
}

keep _year-_stderr
for any year iss type beta stderr: rename _X X
drop if year==.
la de type 1"non identifier" 2"identifier: own party" 3"identifier: other party"
la val type type

* create a separate variable for the intercept
g intercept=beta if iss==0
g intercept_ub=intercept+1.96*stderr
g intercept_lb=intercept-1.96*stderr
replace beta=. if iss==0
replace iss=. if iss==0


* 95% confidence intervals for the effects of issue distances
g beta_ub=beta+1.96*stderr
g beta_lb=beta-1.96*stderr


* change the order of issues (to have common issues on top)
replace iss=(iss*-1)+9
la de iss 8 Euthanasia 7 Crime 6"Income differences" 5"Nuclear plants" 4"Ethnic minorities" 3"European unification" 2"Asylum seekers" 1"Social benefits"
la val iss iss

g iss1998=iss
replace iss1998=7 if iss1998==8


* variable for y-axis
g iss_type=iss
replace iss_type=iss_type+.15 if type==1
replace iss_type=iss_type-.15 if type==3

g iss1998_type=iss1998
replace iss1998_type=iss1998_type+.15 if type==1
replace iss1998_type=iss1998_type-.15 if type==3

* variable for x-axis
g beta_year=((year-1994)/4)+beta
g beta_ub_year=((year-1994)/4)+beta_ub
g beta_lb_year=((year-1994)/4)+beta_lb


* Data for Table 1: Predicted party utilities when all issue distances are equal to 0
list year type intercept stderr if iss==., sep(3)

* Figure 2: Impact of issue distances on party utilities, 1994 election
#delimit ;
twoway
(scatter iss_type beta if type==1 & year==1994, ms(Oh) mc(black) msize(medium))
(rspike beta_lb beta_ub iss_type if type==1 & year==1994, horizontal lc(black) lp(solid) lw(medthick))
(scatter iss_type beta if type==2 & year==1994, ms(D) mc(black) msize(medium))
(rspike beta_lb beta_ub iss_type if type==2 & year==1994, horizontal lc(black) lp(dash) lw(medthick))
(scatter iss_type beta if type==3 & year==1994, ms(X) mc(black) msize(medium))
(rspike beta_lb beta_ub iss_type if type==3 & year==1994, horizontal lc(black) lp(vshortdash) lw(medthick))
(connected type type if type==4, ms(Oh) mc(black) msize(medium) lc(black) lp(solid) lw(medthick))
(connected type type if type==4, ms(D) mc(black) msize(medium) lc(black) lp(dash) lw(medthick))
(connected type type if type==4, ms(X) mc(black) msize(medium) lc(black) lp(vshortdash) lw(medthick))
, ylab(8 "Euthanasia" 7 "Crime" 6 "Income differences" 5"Nuclear plants" 4"Ethnic minorities" 3"European unification", angle(horizontal))
ytitle("")
xlab(-.4(.2).2) xscale(range(-.5 .3))
xline(0, lp(dash) lc(black))
legend(textfirst col(1) keygap(4) order(7 "Nonidentifier:" 8 "Identifier, own party:" 9 "Identifier, other party:"))
graphregion(fcolor(white) lcolor(white))
; #delimit cr
graph export "Figure 2.eps", as(eps) preview(on) replace

* Figure 3: Impact of issue distances on party utilities, 1998 election
#delimit ;
twoway
(scatter iss1998_type beta if type==1 & year==1998, ms(Oh) mc(black) msize(medium))
(rspike beta_lb beta_ub iss1998_type if type==1 & year==1998, horizontal lc(black) lp(solid) lw(medthick))
(scatter iss1998_type beta if type==2 & year==1998, ms(D) mc(black) msize(medium))
(rspike beta_lb beta_ub iss1998_type if type==2 & year==1998, horizontal lc(black) lp(dash) lw(medthick))
(scatter iss1998_type beta if type==3 & year==1998, ms(X) mc(black) msize(medium))
(rspike beta_lb beta_ub iss1998_type if type==3 & year==1998, horizontal lc(black) lp(vshortdash) lw(medthick))
(connected type type if type==4, ms(Oh) mc(black) msize(medium) lc(black) lp(solid) lw(medthick))
(connected type type if type==4, ms(D) mc(black) msize(medium) lc(black) lp(dash) lw(medthick))
(connected type type if type==4, ms(X) mc(black) msize(medium) lc(black) lp(vshortdash) lw(medthick))
, ylab(7 "Euthanasia" 6"Income differences" 5"Nuclear plants" 4"Ethnic minorities" 3"European unification" 2"Asylum seekers" 1"Social benefits", angle(horizontal))
ytitle("")
xlab(-.4(.2).2) xscale(range(-.5 .3))
xline(0, lp(dash) lc(black))
legend(textfirst col(1) keygap(4) order(7 "Nonidentifier:" 8 "Identifier, own party:" 9 "Identifier, other party:"))
graphregion(fcolor(white) lcolor(white))
; #delimit cr
graph export "Figure 3.eps", as(eps) preview(on) replace

* Figure 4: Impact of issue distances on party utilities, 2002 election
#delimit ;
twoway
(scatter iss_type beta if type==1 & year==2002, ms(Oh) mc(black) msize(medium))
(rspike beta_lb beta_ub iss_type if type==1 & year==2002, horizontal lc(black) lp(solid) lw(medthick))
(scatter iss_type beta if type==2 & year==2002, ms(D) mc(black) msize(medium))
(rspike beta_lb beta_ub iss_type if type==2 & year==2002, horizontal lc(black) lp(dash) lw(medthick))
(scatter iss_type beta if type==3 & year==2002, ms(X) mc(black) msize(medium))
(rspike beta_lb beta_ub iss_type if type==3 & year==2002, horizontal lc(black) lp(vshortdash) lw(medthick))
(connected type type if type==4, ms(Oh) mc(black) msize(medium) lc(black) lp(solid) lw(medthick))
(connected type type if type==4, ms(D) mc(black) msize(medium) lc(black) lp(dash) lw(medthick))
(connected type type if type==4, ms(X) mc(black) msize(medium) lc(black) lp(vshortdash) lw(medthick))
, ylab(8"Euthanasia" 7"Crime" 6"Income differences" 5"Nuclear plants" 4"Ethnic minorities" 3"European unification" 2"Asylum seekers", angle(horizontal))
ytitle("")
xlab(-.4(.2).2) xscale(range(-.5 .3))
xline(0, lp(dash) lc(black))
legend(textfirst col(1) keygap(4) order(7 "Nonidentifier:" 8 "Identifier, own party:" 9 "Identifier, other party:"))
graphregion(fcolor(white) lcolor(white))
; #delimit cr
graph export "Figure 4.eps", as(eps) preview(on) replace

* Figure 5: Impact of issue distances on party utilities, 2006 election
#delimit ;
twoway
(scatter iss_type beta if type==1 & year==2006, ms(Oh) mc(black) msize(medium))
(rspike beta_lb beta_ub iss_type if type==1 & year==2006, horizontal lc(black) lp(solid) lw(medthick))
(scatter iss_type beta if type==2 & year==2006, ms(D) mc(black) msize(medium))
(rspike beta_lb beta_ub iss_type if type==2 & year==2006, horizontal lc(black) lp(dash) lw(medthick))
(scatter iss_type beta if type==3 & year==2006, ms(X) mc(black) msize(medium))
(rspike beta_lb beta_ub iss_type if type==3 & year==2006, horizontal lc(black) lp(vshortdash) lw(medthick))
(connected type type if type==4, ms(Oh) mc(black) msize(medium) lc(black) lp(solid) lw(medthick))
(connected type type if type==4, ms(D) mc(black) msize(medium) lc(black) lp(dash) lw(medthick))
(connected type type if type==4, ms(X) mc(black) msize(medium) lc(black) lp(vshortdash) lw(medthick))
, ylab(8"Euthanasia" 7"Crime" 6"Income differences" 5"Nuclear plants" 4"Ethnic minorities" 3"European unification" 2"Asylum seekers", angle(horizontal))
ytitle("")
xlab(-.4(.2).2) xscale(range(-.5 .3))
xline(0, lp(dash) lc(black))
legend(textfirst col(1) keygap(4) order(7 "Nonidentifier:" 8 "Identifier, own party:" 9 "Identifier, other party:"))
graphregion(fcolor(white) lcolor(white))
; #delimit cr
graph export "Figure 5.eps", as(eps) preview(on) replace

restore



*****************************************************************
** Table 2: regression models based on the overall issue distance
*****************************************************************


* Compute the overall issue distance (sum of squared distances)
g prox2=.
replace prox2=(prox2_iss1 + prox2_iss2 + prox2_iss3 + prox2_iss4 + prox2_iss5 + prox2_iss6) if year==1994
replace prox2=(prox2_iss1 + prox2_iss3 + prox2_iss4 + prox2_iss5 + prox2_iss6 + prox2_iss7 + prox2_iss8) if year==1998
replace prox2=(prox2_iss1 + prox2_iss2 + prox2_iss3 + prox2_iss4 + prox2_iss5 + prox2_iss6 + prox2_iss7) if year==2002
replace prox2=(prox2_iss1 + prox2_iss2 + prox2_iss3 + prox2_iss4 + prox2_iss5 + prox2_iss6 + prox2_iss7) if year==2006

g idyes_prox2=idyes*prox2
g idown_prox2=idown*prox2


* Model 1
regress util       idown prox2                         if year==1994 [pweight=weighti], cluster(id)
regress util       idown prox2                         if year==1998 [pweight=weighti], cluster(id)
regress util       idown prox2                         if year==2002 [pweight=weighti], cluster(id)
regress util       idown prox2                         if year==2006 [pweight=weighti], cluster(id)

* Model 2
regress util       idown prox2             idown_prox2 if year==1994 [pweight=weighti], cluster(id)
regress util       idown prox2             idown_prox2 if year==1998 [pweight=weighti], cluster(id)
regress util       idown prox2             idown_prox2 if year==2002 [pweight=weighti], cluster(id)
regress util       idown prox2             idown_prox2 if year==2006 [pweight=weighti], cluster(id)

* Model 3
regress util idyes idown prox2 idyes_prox2 idown_prox2 if year==1994 [pweight=weighti], cluster(id)
regress util idyes idown prox2 idyes_prox2 idown_prox2 if year==1998 [pweight=weighti], cluster(id)
regress util idyes idown prox2 idyes_prox2 idown_prox2 if year==2002 [pweight=weighti], cluster(id)
regress util idyes idown prox2 idyes_prox2 idown_prox2 if year==2006 [pweight=weighti], cluster(id)




******************************************************************
** Table A3: Replication, model including political sophistication
******************************************************************

* Political sophistication is centred for each election
quietly regress util idyes idown soph prox2_iss1 prox2_iss2 prox2_iss3 prox2_iss4 prox2_iss5 prox2_iss6 if year==1994 [pweight=weighti], cluster(id)
quietly su soph if e(sample) [iweight=weighti]
replace soph=soph-`r(mean)' if year==1994 & e(sample)
quietly regress util idyes idown soph prox2_iss1 prox2_iss3 prox2_iss4 prox2_iss5 prox2_iss6 prox2_iss7 prox2_iss8 if year==1998 [pweight=weighti], cluster(id)
quietly su soph if e(sample) [iweight=weighti]
replace soph=soph-`r(mean)' if year==1998 & e(sample)
quietly regress util idyes idown soph prox2_iss1 prox2_iss2 prox2_iss3 prox2_iss4 prox2_iss5 prox2_iss6 prox2_iss7 if year==2002 [pweight=weighti], cluster(id)
quietly su soph if e(sample) [iweight=weighti]
replace soph=soph-`r(mean)' if year==2002 & e(sample)
quietly regress util idyes idown soph prox2_iss1 prox2_iss2 prox2_iss3 prox2_iss4 prox2_iss5 prox2_iss6 prox2_iss7 if year==2006 [pweight=weighti], cluster(id)
quietly su soph if e(sample) [iweight=weighti]
replace soph=soph-`r(mean)' if year==2006 & e(sample)


* Interactions sophistication x issue distances
for var prox2_iss1-prox2_iss8: g soph_X=X*soph

* Interactions sophistication x party identification
for var idown idyes: g soph_X=X*soph

* Interactions sophistication x issue distance x party identification
for var prox2_iss1-prox2_iss8: g soph_idown_X=soph*X*idown \ g soph_idyes_X=soph*X*idyes


* Regression model, 1994 election
#delimit ;
regress util idyes idown soph soph_idyes soph_idown
prox2_iss1 idyes_prox2_iss1 idown_prox2_iss1 soph_prox2_iss1 soph_idyes_prox2_iss1 soph_idown_prox2_iss1
prox2_iss2 idyes_prox2_iss2 idown_prox2_iss2 soph_prox2_iss2 soph_idyes_prox2_iss2 soph_idown_prox2_iss2
prox2_iss3 idyes_prox2_iss3 idown_prox2_iss3 soph_prox2_iss3 soph_idyes_prox2_iss3 soph_idown_prox2_iss3 
prox2_iss4 idyes_prox2_iss4 idown_prox2_iss4 soph_prox2_iss4 soph_idyes_prox2_iss4 soph_idown_prox2_iss4
prox2_iss5 idyes_prox2_iss5 idown_prox2_iss5 soph_prox2_iss5 soph_idyes_prox2_iss5 soph_idown_prox2_iss5
prox2_iss6 idyes_prox2_iss6 idown_prox2_iss6 soph_prox2_iss6 soph_idyes_prox2_iss6 soph_idown_prox2_iss6
if year==1994 [pweight=weighti], cluster(id); #delimit cr

* Regression model, 1998 election
#delimit ;
regress util idyes idown soph soph_idyes soph_idown
prox2_iss1 idyes_prox2_iss1 idown_prox2_iss1 soph_prox2_iss1 soph_idyes_prox2_iss1 soph_idown_prox2_iss1
prox2_iss3 idyes_prox2_iss3 idown_prox2_iss3 soph_prox2_iss3 soph_idyes_prox2_iss3 soph_idown_prox2_iss3
prox2_iss4 idyes_prox2_iss4 idown_prox2_iss4 soph_prox2_iss4 soph_idyes_prox2_iss4 soph_idown_prox2_iss4
prox2_iss5 idyes_prox2_iss5 idown_prox2_iss5 soph_prox2_iss5 soph_idyes_prox2_iss5 soph_idown_prox2_iss5
prox2_iss6 idyes_prox2_iss6 idown_prox2_iss6 soph_prox2_iss6 soph_idyes_prox2_iss6 soph_idown_prox2_iss6
prox2_iss7 idyes_prox2_iss7 idown_prox2_iss7 soph_prox2_iss7 soph_idyes_prox2_iss7 soph_idown_prox2_iss7
prox2_iss8 idyes_prox2_iss8 idown_prox2_iss8 soph_prox2_iss8 soph_idyes_prox2_iss8 soph_idown_prox2_iss8
if year==1998 [pweight=weighti], cluster(id) ; #delimit cr

* Regression model, 2002 election
#delimit ;
regress util idyes idown soph soph_idyes soph_idown
prox2_iss1 idyes_prox2_iss1 idown_prox2_iss1 soph_prox2_iss1 soph_idyes_prox2_iss1 soph_idown_prox2_iss1
prox2_iss2 idyes_prox2_iss2 idown_prox2_iss2 soph_prox2_iss2 soph_idyes_prox2_iss2 soph_idown_prox2_iss2
prox2_iss3 idyes_prox2_iss3 idown_prox2_iss3 soph_prox2_iss3 soph_idyes_prox2_iss3 soph_idown_prox2_iss3
prox2_iss4 idyes_prox2_iss4 idown_prox2_iss4 soph_prox2_iss4 soph_idyes_prox2_iss4 soph_idown_prox2_iss4
prox2_iss5 idyes_prox2_iss5 idown_prox2_iss5 soph_prox2_iss5 soph_idyes_prox2_iss5 soph_idown_prox2_iss5
prox2_iss6 idyes_prox2_iss6 idown_prox2_iss6 soph_prox2_iss6 soph_idyes_prox2_iss6 soph_idown_prox2_iss6
prox2_iss7 idyes_prox2_iss7 idown_prox2_iss7 soph_prox2_iss7 soph_idyes_prox2_iss7 soph_idown_prox2_iss7
if year==2002 [pweight=weighti], cluster(id) ; #delimit cr

* Regression model, 2006 election
#delimit ;
regress util idyes idown soph soph_idyes soph_idown
prox2_iss1 idyes_prox2_iss1 idown_prox2_iss1 soph_prox2_iss1 soph_idyes_prox2_iss1 soph_idown_prox2_iss1
prox2_iss2 idyes_prox2_iss2 idown_prox2_iss2 soph_prox2_iss2 soph_idyes_prox2_iss2 soph_idown_prox2_iss2
prox2_iss3 idyes_prox2_iss3 idown_prox2_iss3 soph_prox2_iss3 soph_idyes_prox2_iss3 soph_idown_prox2_iss3
prox2_iss4 idyes_prox2_iss4 idown_prox2_iss4 soph_prox2_iss4 soph_idyes_prox2_iss4 soph_idown_prox2_iss4
prox2_iss5 idyes_prox2_iss5 idown_prox2_iss5 soph_prox2_iss5 soph_idyes_prox2_iss5 soph_idown_prox2_iss5
prox2_iss6 idyes_prox2_iss6 idown_prox2_iss6 soph_prox2_iss6 soph_idyes_prox2_iss6 soph_idown_prox2_iss6
prox2_iss7 idyes_prox2_iss7 idown_prox2_iss7 soph_prox2_iss7 soph_idyes_prox2_iss7 soph_idown_prox2_iss7
if year==2006 [pweight=weighti], cluster(id) ; #delimit cr




*********************************************************************
** Table A4: Replication, model based on linear voter-party distances
*********************************************************************

* Regression model, 1994 election
#delimit ;
regress util idyes idown
prox_iss1 idyes_prox_iss1 idown_prox_iss1 
prox_iss2 idyes_prox_iss2 idown_prox_iss2 
prox_iss3 idyes_prox_iss3 idown_prox_iss3 
prox_iss4 idyes_prox_iss4 idown_prox_iss4 
prox_iss5 idyes_prox_iss5 idown_prox_iss5 
prox_iss6 idyes_prox_iss6 idown_prox_iss6 if year==1994 [pweight=weighti], cluster(id); #delimit cr

* Regression model, 1998 election
#delimit ;
regress util idyes idown
prox_iss1 idyes_prox_iss1 idown_prox_iss1 
prox_iss3 idyes_prox_iss3 idown_prox_iss3 
prox_iss4 idyes_prox_iss4 idown_prox_iss4 
prox_iss5 idyes_prox_iss5 idown_prox_iss5 
prox_iss6 idyes_prox_iss6 idown_prox_iss6 
prox_iss7 idyes_prox_iss7 idown_prox_iss7 
prox_iss8 idyes_prox_iss8 idown_prox_iss8 if year==1998 [pweight=weighti], cluster(id) ; #delimit cr

* Regression model, 2002 election
#delimit ;
regress util idyes idown
prox_iss1 idyes_prox_iss1 idown_prox_iss1 
prox_iss2 idyes_prox_iss2 idown_prox_iss2 
prox_iss3 idyes_prox_iss3 idown_prox_iss3 
prox_iss4 idyes_prox_iss4 idown_prox_iss4 
prox_iss5 idyes_prox_iss5 idown_prox_iss5 
prox_iss6 idyes_prox_iss6 idown_prox_iss6 
prox_iss7 idyes_prox_iss7 idown_prox_iss7 if year==2002 [pweight=weighti], cluster(id) ; #delimit cr

* Regression model, 2006 election
#delimit ;
regress util idyes idown
prox_iss1 idyes_prox_iss1 idown_prox_iss1 
prox_iss2 idyes_prox_iss2 idown_prox_iss2 
prox_iss3 idyes_prox_iss3 idown_prox_iss3 
prox_iss4 idyes_prox_iss4 idown_prox_iss4 
prox_iss5 idyes_prox_iss5 idown_prox_iss5 
prox_iss6 idyes_prox_iss6 idown_prox_iss6 
prox_iss7 idyes_prox_iss7 idown_prox_iss7 if year==2006 [pweight=weighti], cluster(id) ; #delimit cr




**************************************************************************
** Table A5: Replication, model based on average perceived party positions
**************************************************************************

* Regression model, 1994 election
#delimit ;
regress util idyes idown
prox2m_iss1 idyes_prox2m_iss1 idown_prox2m_iss1 
prox2m_iss2 idyes_prox2m_iss2 idown_prox2m_iss2 
prox2m_iss3 idyes_prox2m_iss3 idown_prox2m_iss3 
prox2m_iss4 idyes_prox2m_iss4 idown_prox2m_iss4 
prox2m_iss5 idyes_prox2m_iss5 idown_prox2m_iss5 
prox2m_iss6 idyes_prox2m_iss6 idown_prox2m_iss6 if year==1994 [pweight=weighti], cluster(id); #delimit cr

* Regression model, 1998 election
#delimit ;
regress util idyes idown
prox2m_iss1 idyes_prox2m_iss1 idown_prox2m_iss1 
prox2m_iss3 idyes_prox2m_iss3 idown_prox2m_iss3 
prox2m_iss4 idyes_prox2m_iss4 idown_prox2m_iss4 
prox2m_iss5 idyes_prox2m_iss5 idown_prox2m_iss5 
prox2m_iss6 idyes_prox2m_iss6 idown_prox2m_iss6 
prox2m_iss7 idyes_prox2m_iss7 idown_prox2m_iss7 
prox2m_iss8 idyes_prox2m_iss8 idown_prox2m_iss8 if year==1998 [pweight=weighti], cluster(id) ; #delimit cr

* Regression model, 2002 election
#delimit ;
regress util idyes idown
prox2m_iss1 idyes_prox2m_iss1 idown_prox2m_iss1 
prox2m_iss2 idyes_prox2m_iss2 idown_prox2m_iss2 
prox2m_iss3 idyes_prox2m_iss3 idown_prox2m_iss3 
prox2m_iss4 idyes_prox2m_iss4 idown_prox2m_iss4 
prox2m_iss5 idyes_prox2m_iss5 idown_prox2m_iss5 
prox2m_iss6 idyes_prox2m_iss6 idown_prox2m_iss6 
prox2m_iss7 idyes_prox2m_iss7 idown_prox2m_iss7 if year==2002 [pweight=weighti], cluster(id) ; #delimit cr

* Regression model, 2006 election
#delimit ;
regress util idyes idown
prox2m_iss1 idyes_prox2m_iss1 idown_prox2m_iss1 
prox2m_iss2 idyes_prox2m_iss2 idown_prox2m_iss2 
prox2m_iss3 idyes_prox2m_iss3 idown_prox2m_iss3 
prox2m_iss4 idyes_prox2m_iss4 idown_prox2m_iss4 
prox2m_iss5 idyes_prox2m_iss5 idown_prox2m_iss5 
prox2m_iss6 idyes_prox2m_iss6 idown_prox2m_iss6 
prox2m_iss7 idyes_prox2m_iss7 idown_prox2m_iss7 if year==2006 [pweight=weighti], cluster(id) ; #delimit cr




*******************************************************
** Table A6: Replication, model including valence terms
*******************************************************

* Regression model, 1994 election
#delimit ;
regress util vvd d66 cda idyes idown
prox2_iss1 idyes_prox2_iss1 idown_prox2_iss1 
prox2_iss2 idyes_prox2_iss2 idown_prox2_iss2 
prox2_iss3 idyes_prox2_iss3 idown_prox2_iss3 
prox2_iss4 idyes_prox2_iss4 idown_prox2_iss4 
prox2_iss5 idyes_prox2_iss5 idown_prox2_iss5 
prox2_iss6 idyes_prox2_iss6 idown_prox2_iss6 if year==1994 [pweight=weighti], cluster(id) ; #delimit cr

* Regression model, 1998 election
#delimit ;
regress util vvd d66 gl cda gpv idyes idown
prox2_iss1 idyes_prox2_iss1 idown_prox2_iss1 
prox2_iss3 idyes_prox2_iss3 idown_prox2_iss3 
prox2_iss4 idyes_prox2_iss4 idown_prox2_iss4 
prox2_iss5 idyes_prox2_iss5 idown_prox2_iss5 
prox2_iss6 idyes_prox2_iss6 idown_prox2_iss6 
prox2_iss7 idyes_prox2_iss7 idown_prox2_iss7 
prox2_iss8 idyes_prox2_iss8 idown_prox2_iss8 if year==1998 [pweight=weighti], cluster(id) ; #delimit cr

* Regression model, 2002 election
#delimit ;
regress util vvd d66 cda lpf idyes idown
prox2_iss1 idyes_prox2_iss1 idown_prox2_iss1 
prox2_iss2 idyes_prox2_iss2 idown_prox2_iss2 
prox2_iss3 idyes_prox2_iss3 idown_prox2_iss3 
prox2_iss4 idyes_prox2_iss4 idown_prox2_iss4 
prox2_iss5 idyes_prox2_iss5 idown_prox2_iss5 
prox2_iss6 idyes_prox2_iss6 idown_prox2_iss6 
prox2_iss7 idyes_prox2_iss7 idown_prox2_iss7 if year==2002 [pweight=weighti], cluster(id) ; #delimit cr

* Regression model, 2006 election
#delimit ;
regress util vvd cda sp christenunie idyes idown
prox2_iss1 idyes_prox2_iss1 idown_prox2_iss1 
prox2_iss2 idyes_prox2_iss2 idown_prox2_iss2 
prox2_iss3 idyes_prox2_iss3 idown_prox2_iss3 
prox2_iss4 idyes_prox2_iss4 idown_prox2_iss4 
prox2_iss5 idyes_prox2_iss5 idown_prox2_iss5 
prox2_iss6 idyes_prox2_iss6 idown_prox2_iss6 
prox2_iss7 idyes_prox2_iss7 idown_prox2_iss7 if year==2006 [pweight=weighti], cluster(id) ; #delimit cr




***************************************************************
** Table A7: Replication, models with sociodemographic controls
***************************************************************

* Define samples for computing y-hats
quietly regress util vvd d66 cda idyes idown prox2_iss1 idyes_prox2_iss1 idown_prox2_iss1 prox2_iss2 idyes_prox2_iss2 idown_prox2_iss2 prox2_iss3 idyes_prox2_iss3 idown_prox2_iss3 prox2_iss4 idyes_prox2_iss4 idown_prox2_iss4 prox2_iss5 idyes_prox2_iss5 idown_prox2_iss5 prox2_iss6 idyes_prox2_iss6 idown_prox2_iss6 if year==1994 [pweight=weighti], cluster(id)
g sample1994=e(sample)
quietly regress util vvd d66 gl cda gpv idyes idown prox2_iss1 idyes_prox2_iss1 idown_prox2_iss1 prox2_iss3 idyes_prox2_iss3 idown_prox2_iss3 prox2_iss4 idyes_prox2_iss4 idown_prox2_iss4 prox2_iss5 idyes_prox2_iss5 idown_prox2_iss5 prox2_iss6 idyes_prox2_iss6 idown_prox2_iss6 prox2_iss7 idyes_prox2_iss7 idown_prox2_iss7 prox2_iss8 idyes_prox2_iss8 idown_prox2_iss8 if year==1998 [pweight=weighti], cluster(id)
g sample1998=e(sample)
quietly regress util vvd d66 cda lpf idyes idown prox2_iss1 idyes_prox2_iss1 idown_prox2_iss1 prox2_iss2 idyes_prox2_iss2 idown_prox2_iss2 prox2_iss3 idyes_prox2_iss3 idown_prox2_iss3 prox2_iss4 idyes_prox2_iss4 idown_prox2_iss4 prox2_iss5 idyes_prox2_iss5 idown_prox2_iss5 prox2_iss6 idyes_prox2_iss6 idown_prox2_iss6 prox2_iss7 idyes_prox2_iss7 idown_prox2_iss7 if year==2002 [pweight=weighti], cluster(id) 
g sample2002=e(sample)
quietly regress util vvd cda sp christenunie idyes idown prox2_iss1 idyes_prox2_iss1 idown_prox2_iss1 prox2_iss2 idyes_prox2_iss2 idown_prox2_iss2 prox2_iss3 idyes_prox2_iss3 idown_prox2_iss3 prox2_iss4 idyes_prox2_iss4 idown_prox2_iss4 prox2_iss5 idyes_prox2_iss5 idown_prox2_iss5 prox2_iss6 idyes_prox2_iss6 idown_prox2_iss6 prox2_iss7 idyes_prox2_iss7 idown_prox2_iss7 if year==2006 [pweight=weighti], cluster(id)
g sample2006=e(sample)


* Compute y-hats
for any pvda vvd d66 cda: regress util age gender class1 class2 class4 class5 relig1 relig2 relig3 religiosity if sample1994==1 & X==1 \ predict yhat_1994_X
for any pvda vvd d66 gl cda gpv: regress util age gender class1 class2 class4 class5 relig1 relig2 relig3 religiosity if sample1998==1 & X==1 \ predict yhat_1998_X
for any pvda vvd d66 cda lpf: regress util age gender class1 class2 class4 class5 relig1 relig2 relig3 religiosity if sample2002==1 & X==1 \ predict yhat_2002_X
for any pvda vvd cda sp christenunie: regress util age gender class1 class2 class4 class5 relig1 relig2 relig3 religiosity if sample2006==1 & X==1 \ predict yhat_2006_X
foreach y of varlist yhat_1994_pvda-yhat_2006_christenunie {
	su `y'
	replace `y'=`y'-`r(mean)'
}
g yhat=.
for any pvda vvd d66 cda: replace yhat=yhat_1994_X if X==1 & year==1994
for any pvda vvd d66 gl cda gpv: replace yhat=yhat_1998_X if X==1 & year==1998
for any pvda vvd d66 cda lpf: replace yhat=yhat_2002_X if X==1 & year==2002
for any pvda vvd cda sp christenunie: replace yhat=yhat_2006_X if X==1 & year==2006
drop yhat_1994_pvda-yhat_2006_christenunie


* Regression model, 1994 election
#delimit ;
regress util yhat idyes idown
prox2_iss1 idyes_prox2_iss1 idown_prox2_iss1 
prox2_iss2 idyes_prox2_iss2 idown_prox2_iss2 
prox2_iss3 idyes_prox2_iss3 idown_prox2_iss3 
prox2_iss4 idyes_prox2_iss4 idown_prox2_iss4 
prox2_iss5 idyes_prox2_iss5 idown_prox2_iss5 
prox2_iss6 idyes_prox2_iss6 idown_prox2_iss6 if year==1994 [pweight=weighti], cluster(id) ; #delimit cr

* Regression model, 1998 election
#delimit ;
regress util yhat idyes idown
prox2_iss1 idyes_prox2_iss1 idown_prox2_iss1 
prox2_iss3 idyes_prox2_iss3 idown_prox2_iss3 
prox2_iss4 idyes_prox2_iss4 idown_prox2_iss4 
prox2_iss5 idyes_prox2_iss5 idown_prox2_iss5 
prox2_iss6 idyes_prox2_iss6 idown_prox2_iss6 
prox2_iss7 idyes_prox2_iss7 idown_prox2_iss7 
prox2_iss8 idyes_prox2_iss8 idown_prox2_iss8 if year==1998 [pweight=weighti], cluster(id) ; #delimit cr

* Regression model, 2002 election
#delimit ;
regress util yhat idyes idown
prox2_iss1 idyes_prox2_iss1 idown_prox2_iss1 
prox2_iss2 idyes_prox2_iss2 idown_prox2_iss2 
prox2_iss3 idyes_prox2_iss3 idown_prox2_iss3 
prox2_iss4 idyes_prox2_iss4 idown_prox2_iss4 
prox2_iss5 idyes_prox2_iss5 idown_prox2_iss5 
prox2_iss6 idyes_prox2_iss6 idown_prox2_iss6 
prox2_iss7 idyes_prox2_iss7 idown_prox2_iss7 if year==2002 [pweight=weighti], cluster(id); #delimit cr

* Regression model, 2006 election
#delimit ;
regress util yhat idyes idown
prox2_iss1 idyes_prox2_iss1 idown_prox2_iss1 
prox2_iss2 idyes_prox2_iss2 idown_prox2_iss2 
prox2_iss3 idyes_prox2_iss3 idown_prox2_iss3 
prox2_iss4 idyes_prox2_iss4 idown_prox2_iss4 
prox2_iss5 idyes_prox2_iss5 idown_prox2_iss5 
prox2_iss6 idyes_prox2_iss6 idown_prox2_iss6 
prox2_iss7 idyes_prox2_iss7 idown_prox2_iss7 if year==2006 [pweight=weighti], cluster(id) ; #delimit cr




***************************************************
** Table A8: Replication, ordered logit regressions
***************************************************

* Regression model, 1994 election
#delimit ;
ologit util idyes idown
prox2_iss1 idyes_prox2_iss1 idown_prox2_iss1 
prox2_iss2 idyes_prox2_iss2 idown_prox2_iss2 
prox2_iss3 idyes_prox2_iss3 idown_prox2_iss3 
prox2_iss4 idyes_prox2_iss4 idown_prox2_iss4 
prox2_iss5 idyes_prox2_iss5 idown_prox2_iss5 
prox2_iss6 idyes_prox2_iss6 idown_prox2_iss6 if year==1994 [pweight=weighti], cluster(id); #delimit cr

* Regression model, 1998 election
#delimit ;
ologit util idyes idown
prox2_iss1 idyes_prox2_iss1 idown_prox2_iss1 
prox2_iss3 idyes_prox2_iss3 idown_prox2_iss3 
prox2_iss4 idyes_prox2_iss4 idown_prox2_iss4 
prox2_iss5 idyes_prox2_iss5 idown_prox2_iss5 
prox2_iss6 idyes_prox2_iss6 idown_prox2_iss6 
prox2_iss7 idyes_prox2_iss7 idown_prox2_iss7 
prox2_iss8 idyes_prox2_iss8 idown_prox2_iss8 if year==1998 [pweight=weighti], cluster(id) ; #delimit cr

* Regression model, 2002 election
#delimit ;
ologit util idyes idown
prox2_iss1 idyes_prox2_iss1 idown_prox2_iss1 
prox2_iss2 idyes_prox2_iss2 idown_prox2_iss2 
prox2_iss3 idyes_prox2_iss3 idown_prox2_iss3 
prox2_iss4 idyes_prox2_iss4 idown_prox2_iss4 
prox2_iss5 idyes_prox2_iss5 idown_prox2_iss5 
prox2_iss6 idyes_prox2_iss6 idown_prox2_iss6 
prox2_iss7 idyes_prox2_iss7 idown_prox2_iss7 if year==2002 [pweight=weighti], cluster(id) ; #delimit cr

* Regression model, 2006 election
#delimit ;
ologit util idyes idown
prox2_iss1 idyes_prox2_iss1 idown_prox2_iss1 
prox2_iss2 idyes_prox2_iss2 idown_prox2_iss2 
prox2_iss3 idyes_prox2_iss3 idown_prox2_iss3 
prox2_iss4 idyes_prox2_iss4 idown_prox2_iss4 
prox2_iss5 idyes_prox2_iss5 idown_prox2_iss5 
prox2_iss6 idyes_prox2_iss6 idown_prox2_iss6 
prox2_iss7 idyes_prox2_iss7 idown_prox2_iss7 if year==2006 [pweight=weighti], cluster(id) level(99.9) ; #delimit cr


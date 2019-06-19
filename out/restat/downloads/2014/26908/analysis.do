*****************************************
* analysis.do
*
*	Input files: chileexpmt_final.dta
*				 chileexpmt_withadmindata_final.dta
*
* 	This do-file produces Tables 1-6, Appendix Table B.1 and Table B.2
* 	for the paper "Investing in schooling in Chile: The role of information about financial aid 
*	for higher education"
*
*	In general, variables from baseline are named b_* or B_*
* 	while variables from follow-up are named fu_* or FU_*
*	Parent survey variables are named *_padre
*
*	Note: to run this file, you need to install stata command file "sampsi"
*****************************************
cap log close
set more off

**********************************************
* SET UP IMPORTANT GLOBALS FOR THE ANALYSIS
**********************************************
* change the results and data settings below to a folder on your computer that contains the data/where you want
* to store results
global data="\data"
mkdir "\output"
global output="\output"

global se="robust cluster(id)"	/* id=anonymized school level identifier*/
global fe="i.b_scorestratum"	/* b_scorestratum=stratification variable based on 2007 school-level SIMCE ave score */


**********************************************
* 1. DEFINE PROGRAMS
**********************************************
* program to perform joint tests and capture output
cap program drop testab
program define testab
	test A B
	local F1=r(F)
	local p1=r(p)
	test A=B
	local F2=r(F)
	local p2=r(p)
	global addstat="addstat(Joint test F, `F1', Joint test p, `p1', Test 2 F, `F2', Test 2 p, `p2')"
end

* program to test for the minimum detectable effect size of impact estimates over difft outcomes
cap program drop mde
program define mde
	cap drop sample
	gen sample=1 if e(sample)
	sum $y if sample==1 & C==1	/*get mean + s.d. of outcome for control group*/
	local controlmean=r(mean)
	local test_sd=r(sd)
	loneway $y id if C==1 & sample==1
	local rho=r(rho)			
	egen uniq=group(id) if C==0 & e(sample)
	sum uniq
	local clusters=r(max)
	local i =0.01
	while `i'<=0.25 {
		local treatmean=`controlmean'+`i'*`test_sd'							/*build the impact estimate for different effect sizes*/
		sampsi `controlmean' `treatmean', sd(`test_sd') alpha(.5) power(.8) /* what is the assoc. sample size required to find a significant impact of this size?*/
	
		di "****For MDE size `i' and variable $y, THIS is the number of obs per cluster required: ****"
		sampclus, numclus(`clusters') rho(`rho')
		local i = `i'+0.02
	}
	di "************ ACTUAL SAMPLE SIZES AND NUM CLUSTERS FROM EXPMENT **********************"
	count if e(sample) & A==1
	count if e(sample) & B==1
	di "Actual number of clusters is: `clusters'"
	drop uniq
end

* program to produce main results Tables 3, 5 and 6 
cap program drop mainresults
program define mainresults
	**********************
	* Table 3: OLS (ITT) and IV regressions for main outcomes, Student Treatment vs Family treatments vs Controls
	**********************
	* 1. student vs family vs control : OLS, full sample
	xi: reg $y A B $x $fe, $se
	sum $y if e(sample) & C==1
	testab
	outreg2 using "$output\mainresults_replication.out", bdec(4) $which $addstat
	global which="append"

	* 2. student vs family vs control: IV, full sample
	gen tempwatch=watch		/*for those with no "watch" response, set watch=0*/
	replace watch=0 if watch==. & b_studentpresent==1
	tab watch
	xi: ivregress 2sls $y A (watch=B) $x $fe, $se
	sum $y if e(sample) & C==1
	local s=r(mean)
	test A watch 
	local F1=r(chi2)
	local p1=r(p)
	test A=watch
	local F2=r(chi2)
	local p2=r(p)
	outreg2 using "$output\mainresults_replication.out", bdec(4) append addstat(Control group mean, `s', Test A watch F, `F1', Test A watch p, `p1', Test A=watch F, `F2', Test A=watch p, `p2')
	replace watch=tempwatch
	drop tempwatch

	**********************
	* Tables 5 and 6: OLS (ITT) regressions for combined "Any exposure" treatment, and grade interactions
	**********************
	* 3. any exposure vs none
	xi: reg $y T $x $fe, $se
	sum $y if C==1 & e(sample)
	local s=r(mean)
	outreg2 using "$output\mainresults_replication.out", bdec(3) $which addstat(Control group mean, `s')

	* 4. any exposure vs none for different grade groups
	xi: reg $y Tlo Tmed Thi medgrade higrade $x $fe, $se
	test Tlo=Tmed
	local p1=r(p)
	test Tmed=Thi
	local p2=r(p)
	test Tlo=Thi
	local p3=r(p)
	sum $y if C==1 & e(sample)
	local s = r(mean)
	outreg2 using "$output\mainresults_replication.out", bdec(4) $which addstat(Control group mean, `s', Tlo vs Tmed, `p1', Thi vs Tmed, `p2', Tlo vs Thi, `p3')
end


log using "$output\analysis.log", replace

**********************************************
* 2. Open main analysis dataset: contains cleaned up variables for sample of students present at baseline
* who gave in consent forms
**********************************************
use "$data\chileexpmt_final.dta", clear

* create treatment variable for the IV spec
gen watch=1 if FU_dvdanywatch==1 & studentpresent==1
replace watch=0 if FU_dvdanywatch==0 & studentpresent==1
replace watch=0 if (A==1|C==1) & studentpresent==1
tab watch studentpresent, mi
lab var watch "=1 student present at follow up is in B group and reported watching the DVD" 

preserve
* repeat for admin data
use "$data\chileexpmt_withadmindata_final.dta", clear
gen watch=1 if fu_dvdanywatch==1 & studentpresent==1
replace watch=0 if fu_dvdanywatch==0 & studentpresent==1
replace watch=0 if (A==1|C==1) & studentpresent==1
tab watch studentpresent, mi
save "$data\admindata_chile_final.dta", replace
restore


**********************************************
* 3. Table 1 attrition 
**********************************************
tab1 full A B C T
drop if presentbline==0
* drop individuals who were not present at bline/who did not provide consent forms

* DISTRIBUTION OF SAMPLE
* num of students at baseline and FU, by group
tab1 T A B C if b_studentpresent==1
tab1 T A B C if studentpresent==1

* num schools in baseline and at FU
codebook id if b_studentpresent==1
codebook id if studentpresent==1

* num schools by group at baseline and FU
codebook id if A==1
codebook id if B==1
codebook id if C==1
codebook id if T==1

codebook id if A==1& studentpresent==1
codebook id if B==1& studentpresent==1
codebook id if C==1& studentpresent==1
codebook id if T==1& studentpresent==1

* use these to construct parental survey response rates at baseline and FU
tab b_grupo if b_parentpresent==1, mi
tab b_grupo if parentpresent==1, mi

* MATCH RATES WITH ADMIN DATA
* conditional on school having attendance data, kids is matched?
foreach y of varlist hasjundata hassepdata B_grade7_school_missing {
		tab T `y'
		tab b_grupo `y'
		xi: reg `y' T $fe , $se
		xi: reg `y' A B $fe, $se		
}

* complete the table using the admininstrative matched data
preserve
use "$data\admindata_chile_final.dta", clear
count
foreach one of varlist T A B C {
	tab `one' if merge_withgrades==3
	tab `one' if merge_withsimce==3
	tab `one' if merge_withenrol==3
	}
tab merge_withgrades
tab merge_withenrol
sum 
restore

****************************
* 4. Table 2: summstats and balance tests
****************************
* sample for summstats = student sample present at baseline 
* sample for admindata = student sample present at baseline who have matched admin data

* means of individual level variables
foreach one of varlist full T A B C {
	tabstat age female B_momed_st B_momed_st_missing ///
		lograd medgrad higrad B_grade7_school_missing B_dvd B_dvdwork ///
		B_beyondhs B_where_college B_where_tp ///
		B_sclships B_loans B_family B_noidea ///
		hasjundata jun_anyabs jun_abstot ///
		if A!=. & b_studentpresent==1 & `one'==1,statistics(mean sd n) columns(s)
}

* means of school level vars
sort id
foreach one of varlist full T A B C {
	tabstat pvtsubs b_ive school_has admindata  /// 
	if id!=id[_n-1] & `one'==1,statistics(mean sd n) columns(s) 
}

global which="replace"

matrix pvalsT =[0]
matrix pvalsA=[0]
matrix pvalsB=[0]
matrix pvalsAorB=[0]


foreach one of varlist age fem B_momed_st B_momed_st_missing ///
	lograde medgrade higrade B_grade7_school_missing  B_dvd ///
	B_beyondhs B_where_college B_where_tp B_sclships B_loans B_family B_noidea ///
	hasjun jun_anyabs jun_abstot {	

		qui xi: reg `one' T, $se
		test T
		matrix pvalsT=[pvalsT\r(p)]
		
		qui xi: reg `one' A B , $se
		test A
		matrix pvalsA=[pvalsA\r(p)]
		test B
		matrix pvalsB=[pvalsB\r(p)]
		test A=B
		matrix pvalsAorB=[pvalsAorB\r(p)]
	}

sort id

foreach one of varlist pvtsubs b_ive school_has_hs admindata {
	qui xi: reg `one' T if id!=id[_n-1], r
	test T
	matrix pvalsT=[pvalsT\r(p)]
	
	qui xi: reg `one' A B  if id!=id[_n-1], r
	test A
	matrix pvalsA=[pvalsA\r(p)]
	test B
	matrix pvalsB=[pvalsB\r(p)]
	test A=B
	matrix pvalsAorB=[pvalsAorB\r(p)]
}

local names pvalsT pvalsA pvalsB pvalsAorB

foreach one of local names {
	matrix rownames `one' = `one' age fem B_momed_st B_momed_st_missing ///
	lograde medgrade higrade B_grade7_school_missing  B_dvd ///
	B_beyondhs B_where_college B_where_tp B_sclships B_loans B_family B_noidea ///
	hasjun jun_anyabs jun_abstot ///
	pvtsubs b_ive school_has_hs admindata 
}
svmat pvalsT
svmat pvalsA
svmat pvalsB
svmat pvalsAorB

outsheet pvalsT pvalsA1 pvalsB pvalsAorB  using "$output\pvals_temp.out" if pvalsT!=., replace
drop pvalsT1 pvalsA1 pvalsB1 pvalsAorB


**********************************************
* 5. Appendix Table B.2: ITEM NON-RESPONSE for the analysis sample
* who are present at follow up and answer the in-class survey questions
**********************************************
global y = "beyondhs where_college where_tp sclships loans family noidea"
global which="replace"
global which1="replace"
global addstat=""

preserve
keep if studentpresent==1

foreach one of global y {
	gen tempB_`one'missing=0 if B_`one'!=.
	replace tempB_`one'missing=1 if B_`one'==.
	gen tempFU_`one'missing=0 if FU_`one'!=. 
	replace tempFU_`one'missing=1 if FU_`one'==. 
}

foreach one of global y {
	reg tempB_`one'missing T, $se
	outreg2 T using "$output\itemnonresponseT.out", bdec(3) $which 
	global which="append"
	reg tempFU_`one'missing T, $se
	outreg2 T using "$output\itemnonresponseT.out", bdec(3) $which 

	reg tempB_`one'missing A B , $se
	testab
	outreg2 using "$output\itemnonresponseAB.out", bdec(3) $which1 $addstat
	global which1="append"
	reg tempFU_`one'missing A B , $se
	testab
	outreg2 using "$output\itemnonresponseAB.out", bdec(3) $which1 $addstat
	}
 
drop temp*missing
restore


**********************************************
* 6. Tables 3, 5 and 7: Effects on Behavior, Expectations and Information
* for Any Exposure (A+B) and for separate treatment groups (A, B)
**********************************************
ren sep_anyabs FU_sep_anyabs 
ren sep_abstot FU_sep_abstot
ren jun_anyabs B_sep_anyabslag
ren jun_abstot B_sep_abstotlag

* outcomes with baseline values
global y1="sep_anyabs sep_abstot sclships loans family noidea beyondhs where_college where_tp"
* outcomes without baseline values
global y2="dvdknowledgescore"
global yall = "$y1 $y2"

global fe = "i.b_scorestratum"
global x="B_grade7_school_missing"
global which="replace"
global which1="replace"

* Behavior and Expectations
foreach one of global yall {
	global y ="FU_`one'"
	mainresults
}

* Compute min detectable differences in effect sizes of behavioral impacts for A-B 
foreach y of varlist FU_sep_anyabs FU_sep_abstot {
	global y = "`y'"
	xi: reg $y A B B_grade7_school_missing $fe, $se
	mde
}

* aside, as a check: compute poisson regression for total abs data
xi: poisson FU_sep_abstot A B B_grade7_school_missing $fe, $se
xi: poisson FU_sep_abstot T $fe, $se
outreg2 using "$output\poisson1.out", replace
xi: poisson FU_sep_abstot Tlo Tmed Thi medgrade higrade B_grade7_school_missing $fe, $se
outreg2 using "$output\poisson1.out", append

* main results for behaviors captured in matched admin data
global se="r cluster(id)"
global fe="i.b_scorestratum"
global which="append"
global x="b_grade7_school_missing"
global y3="score tp_hg sh_hg"

preserve
use "$data\admindata_chile_final.dta", clear
* estimate for all kids with score info
global y ="score"
mainresults
mde

* estimate for sample of kids in schools with contining high schools
keep if school_has_hs==1
foreach one of global y3 {
	global y = "`one'"
	mainresults
}

* now compute the mde size for outcomes
foreach one of global y3 {
	cap drop sample
	global y ="`one'"
	xi: reg $y A B $fe, $se
	mde
}
restore

* admin data: now estimate for sample of kids in schools that terminate in grade 8 i.e. they have to change
preserve
use "$data\admindata_chile_final.dta", clear
drop if school_has_hs==1
foreach one of global y3 {
	global y = "`one'"
	mainresults
}

* now compute the mde size for outcomes
foreach one of global y3 {
	cap drop sample
	global y ="`one'"
	xi: reg $y A B $fe, $se
	mde
}
restore

**********************************************
* Table 4:
* Student information/knowledge about financial aid: full sample and by grade group
* Parent information/knowledge: full sample and by grade group, with Heckman selection correction
* for parental survey non-response
**********************************************
local x = "B_grade7_school_missing"

* STUDENT INFO OUTCOMES
xi: reg FU_dvdknowledgescore A B `x' $fe, $se 
sum FU_dvdknowledgescore if e(sample) & C==1
testab
outreg2 using "$output\inforesults_replication.out", bdec(4) append $addstat
xi: reg FU_dvdknowledgescore A B `x' $fe if higrade==1, $se
sum FU_dvdknowledgescore if e(sample) & C==1
testab
outreg2 using "$output\inforesults_replication.out", bdec(4) append $addstat
xi: reg FU_dvdknowledgescore A B  `x' $fe if medgrade==1, $se
sum FU_dvdknowledgescore if e(sample) & C==1
testab
outreg2 using "$output\inforesults_replication.out", bdec(4) append $addstat
xi: reg FU_dvdknowledgescore A B  `x' $fe if lograde==1, $se
sum FU_dvdknowledgescore if e(sample) & C==1
testab
outreg2 using "$output\inforesults_replication.out", bdec(4) append $addstat

* PARENT INFO OUTCOMES
xi: reg B_dvdknowledgescore_padre A B $fe if b_studentpresent==1, $se
sum B_dvdknowledgescore_padre  if C==1 & e(sample)
testab
outreg2 using "$output\inforesults_replication.out", bdec(3) $which $addstat

xi: heckman B_dvdknowledgescore_padre  A B $fe if b_studentpresent==1, select(b_parentpresent = A B $fe hassle2 hassle3) twostep vce(boot)
sum B_dvdknowledgescore_padre if C==1 & e(sample)
local s=r(mean)
local lambda=e(lambda)
local selambda=e(selambda)
test A B
local F1=r(chi2)
local p1=r(p)
test A=B
local F2=r(chi2)
local p2=r(p)
outreg2 using "$output\inforesults_replication.out", bdec(3) $which addstat(Mean of outcome for Control group, `s', Joint test F, `F1', Joint test p, `p1', Test 2 F, `F2', Test 2 p, `p2', Lambda, `lambda', se lambda, `selambda')

xi: heckman B_dvdknowledgescore_padre A B $fe if b_studentpresent==1 & higrade==1, select(b_parentpresent = A B $fe hassle2 hassle3) twostep vce(boot)
sum B_dvdknowledgescore_padre if C==1 & e(sample)
local s=r(mean)
local lambda=e(lambda)
local selambda=e(selambda)
test A B
local F1=r(chi2)
local p1=r(p)
test A-B=0
local F2=r(chi2)
local p2=r(p)
outreg2 using "$output\inforesults_replication.out", bdec(3) $which addstat(Mean of outcome for Control group, `s', Joint test F, `F1', Joint test p, `p1', Test 2 F, `F2', Test 2 p, `p2', Lambda, `lambda', se lambda, `selambda')

xi: heckman B_dvdknowledgescore_padre A B $fe if b_studentpresent==1 & medgrade==1, select(b_parentpresent = A B $fe hassle2 hassle3) twostep vce(boot)
sum B_dvdknowledgescore_padre if C==1 & e(sample)
local s=r(mean)
local lambda=e(lambda)
local selambda=e(selambda)
test A B
local F1=r(chi2)
local p1=r(p)
test A-B=0
local F2=r(chi2)
local p2=r(p)
outreg2 using "$output\inforesults_replication.out", bdec(3) $which addstat(Mean of outcome for Control group, `s', Joint test F, `F1', Joint test p, `p1', Test 2 F, `F2', Test 2 p, `p2', Lambda, `lambda', se lambda, `selambda')

xi: heckman B_dvdknowledgescore_padre A B $fe if b_studentpresent==1 & lograde==1, select(b_parentpresent = A B $fe hassle2 hassle3) twostep vce(boot)
sum B_dvdknowledgescore_padre if C==1 & e(sample)
local s=r(mean)
local lambda=e(lambda)
local selambda=e(selambda)
test A B
local F1=r(chi2)
local p1=r(p)
test A-B=0
local F2=r(chi2)
local p2=r(p)
outreg2 using "$output\inforesults_replication.out", bdec(3) $which addstat(Mean of outcome for Control group, `s', Joint test F, `F1', Joint test p, `p1', Test 2 F, `F2', Test 2 p, `p2', Lambda, `lambda', se lambda, `selambda')


**********************************************
* SUMMARY STATISTICS USED IN SECTIONS OF THE PAPER
**********************************************
* what fraction of parents and kids watch the DVD?
sum FU_dvdanywatch if studentpresent==1
tab FU_dvdnumtimes FU_dvdanywatch if studentpresent==1
sum FU_dvdnumtimes FU_dvdanywatch if studentpresent==1 & FU_dvdnumtimes<30, det	/* n=30 is likely an outlier/typo for 3*/
tab FU_whowatch if FU_dvdanywatch==1
* 68% of kids watch with their parents

* who do kids watch with?
tab FU_whowatch gradegrp if B==1 &studentpresent==1, col

* relationship between pr(watching), num times watched, watched with parents, and grade types
tabstat FU_dvdanywatch FU_dvdnumtimes FU_dvdwatch_padre if B==1 &studentpresent==1, by(gradegrp)
table gradegrp, c(n FU_dvdanywatch mean FU_dvdanywatch) format(%8.1gc) center row col missing sc stubwidth(35)
table gradegrp, c(n FU_dvdnumtimes mean FU_dvdnumtimes) format(%8.1gc) center row col missing sc stubwidth(35)
table gradegrp, c(n FU_dvdwatch_padre mean FU_dvdwatch_padre) format(%8.1gc) center row col missing sc stubwidth(35)


**********************************************
* Appendix Table B.1: Absenteeism among control group students on follow-up and non-follow-up days
**********************************************
clear
clear matrix
set mem 800m
use "$data\chileexpmt_final.dta", clear

* Discrepancy between roster attendance data and our records of student attendance on visit days
gen b_wrongabsent=1 if b_roster_attendance==0 & b_studentpresent==0
replace b_wrongabsent=1 if b_roster_attendance==1 & b_studentpresent==1
replace b_wrongabsent=0 if b_roster_attendance==1 & b_studentpresent==0
replace b_wrongabsent=0 if b_roster_attendance==0 & b_studentpresent==1
replace b_wrongabsent=0 if b_roster_attendance<0
ren b_wrongabsent B_wrongabsent

preserve 
drop if dayofvisit1==. /*missing data on day of visit*/
codebook id
keep if admindata==1 & attendance_data==1	/*keep students with reported attendance data from the school*/
keep if C==1 & b_studentpresent==1	/*keep control group students present at baseline*/
gen sweets=1 if super8=="2"
egen nums8=sum(sweets), by(id)
egen allstud=sum(b_studentpresent), by(id)
gen sweetrate=nums8/allstud
assert sweetrate<=1

keep attendday* b_scorestratum dayofvisit1 dayofvisit2 folioalumnos id sweetrate b_studentpresent presentbline B_wrongabsent
compress
reshape long attendday, i(folioalumnos) j(day)

* In 2009: school starts mar 4, day 63; teacher strike started oct 23 2009, day 296
gen badday=0 if day>=63 & day<=296
* keep all of mar april, may and june ago sept oct
* drop all weekends
local i = 66
while `i' <= 290 {	
	replace badday=1 if day==`i'
	replace badday=1 if day==`i'+1
	local i = `i' + 7
	}
* drop the july 13 - july 24: winter break
replace badday=1 if day >=192&day<=207

* create the baseline and follow up day dummies
gen bday=1 if dayofvisit1==day
replace bday=0 if dayofvisit1!=day & dayofvisit1!=.

gen fuday=1 if dayofvisit2==day
replace fuday=0 if dayofvisit2!=day & dayofvisit2!=.

replace badday=0 if bday==1
replace badday=0 if fuday==1

* restrict sample to kids with correct attendance data on the day of our visit
keep if B_wrongabsent!=1

xi: reg attendday fuday $fe if day>=239&day<=338, r cluster(folioalumnos)
outreg2 using "$output\admindataquality_replication.out", replace
gen inter=sweetrate*fuday
xi: reg attendday fuday sweetrate inter $fe if day>=239&day<=338, r cluster(folioalumnos)
outreg2 using "$output\admindataquality_replication.out", append 

xi: areg attendday fuday $fe if day>=239&day<=338, absorb(day) r cluster(folioalumnos)
outreg2 using "$output\admindataquality_replication.out", append 
xi: areg attendday fuday sweetrate inter $fe if day>=239&day<=338, absorb(day) r cluster(folioalumnos)
outreg2 using "$output\admindataquality_replication.out", append 

xi: areg attendday fuday $fe if day>=239&day<=338, absorb(folioalumnos) r 
outreg2 using "$output\admindataquality_replication.out", append 
xi: areg attendday fuday sweetrate inter $fe if day>=239&day<=338, absorb(folioalumnos) r 
outreg2 using "$output\admindataquality_replication.out", append 

xi: areg attendday fuday i.day $fe if day>=239&day<=338, absorb(folioalumnos) r 
outreg2 using "$output\admindataquality_replication.out", append 
xi: areg attendday fuday i.day sweetrate inter $fe if day>=239&day<=338, absorb(folioalumnos) r 
outreg2 using "$output\admindataquality_replication.out", append 

* check that results are robust to restricting to students who showed up at our baseline
keep if presentbline==1
xi: reg attendday fuday $fe if day>=239&day<=338, r cluster(folioalumnos)
outreg2 using "$output\admindataquality_replication.out", append
xi: reg attendday fuday sweetrate inter $fe if day>=239&day<=338, r cluster(folioalumnos)
outreg2 using "$output\admindataquality_replication.out", append 

xi: areg attendday fuday $fe if day>=239&day<=338, absorb(day) r cluster(folioalumnos)
outreg2 using "$output\admindataquality_replication.out", append 
xi: areg attendday fuday sweetrate inter $fe if day>=239&day<=338, absorb(day) r cluster(folioalumnos)
outreg2 using "$output\admindataquality_replication.out", append 

xi: areg attendday fuday $fe if day>=239&day<=338, absorb(folioalumnos) r 
outreg2 using "$output\admindataquality_replication.out", append 
xi: areg attendday fuday sweetrate inter $fe if day>=239&day<=338, absorb(folioalumnos) r 
outreg2 using "$output\admindataquality_replication.out", append 

xi: areg attendday fuday i.day $fe if day>=239&day<=338, absorb(folioalumnos) r 
outreg2 using "$output\admindataquality_replication.out", append 
xi: areg attendday fuday i.day sweetrate inter $fe if day>=239&day<=338, absorb(folioalumnos) r 
outreg2 using "$output\admindataquality_replication.out", append 

clear

log close
exit


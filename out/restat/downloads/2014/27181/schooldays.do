*****Stata program to create the tables and figures in Carlsson, Dahl, Ockert and Rooth, "The Effect of Schooling On Cognitive Skills"
*****Published in the Review of Economics and Statistics
*****Program last revised August 2014

*****IMPORTANT NOTE: The data used in this paper requires getting the necessary permissions from an Ethical Review Board and working with Statistics Sweden and the Swedish Military Archives
*****Details on how to get access to this data is explained in the online readme file
*****Details on the raw datasets which have been merged together to create the data used in this program can also be found in the readme file

clear all
set matsize 11000

cd "~/Dropbox/schooldays/paper/final submission to ReStat"
*insert name of merged dataset here
use mergeddata.dta

*create folder for tables and figures
global out "./tables"
global figures "./figures"

**********************************************************************************
**************************** Sample Selection ************************************
**********************************************************************************

* limit sample to observations with nonmissing measures of cognitive test scores, known enlistment testing center, natives, 1962-1965 and 1968-1976 cohorts, and those who take tests when 18
* -for an unknown reason, the military did not keep the components of the cognitive test scores for 1966 and 1967 cohorts
* -schools were shut down for a two month strike in 1989, so eliminate those months
* -noncitizens not required to enlist, so focus on natives

gen nonmisstest = (rpg1t>0 & rpg2t>0 & rpg3t>0 & rpg4t>0) & (rpg1t!=. & rpg2t!=. & rpg3t!=. & rpg4t!=.)
gen native = fodl==162 & fodl_father==162 & fodl_mother==162
gen strike = inst_yr==1989 & (inst_mo==11|inst_mo==12)
gen take18 = birth_yr + 18 == inst_yr

gen usecase1 = nonmisstest & pg_cogn>0 & prvk<=6 & native & !strike & take18 & birth_yr>=1962 & birth_yr<=1976 & birth_yr~=1966 & birth_yr~=1967

*For later analysis, distinguish between students in academic track versus compulsory and technical tracks
*Main estimation sample is usecase==1

gen usecase=usecase1 & school_cat==12 & (school_prg!=25) & (edu03>=12)
gen usecase9=usecase1 & school_cat==9 & edu03>=9
gen usecase11=usecase1 & school_cat==11 & school_prg!=11 & edu03>=11

**********************************************************************************
**************************** Create Variables ************************************
**********************************************************************************

*Divide total days relative to 18th birthday and number of school days by 100

replace totdays=totdays/100
replace numofschooldays=numofschooldays/100 

* cognitive skills standardized to be mean 0, std dev 1
* for sample of all test takers with valid test scores on all 4 tests

egen rpg1t_std=std(rpg1t) if nonmisstest
egen rpg2t_std=std(rpg2t) if nonmisstest
egen rpg3t_std=std(rpg3t) if nonmisstest
egen rpg4t_std=std(rpg4t) if nonmisstest
egen rpg24t_std=std(rpg2t + rpg4t) if nonmisstest
egen rpg13t_std=std(rpg1t + rpg3t) if nonmisstest

* birth variable

gen bweek=week(birthdate)

*family size

gen fsize=familysize
replace fsize=5 if familysize>=5 & familysize!=.
replace fsize=99 if familysize==.

*mom and dad age

gen age_mom=inst_yr-fodelsearmor
gen age_dad=inst_yr-fodelsearfar

gen agemom_miss=age_mom==.
gen agedad_miss=age_dad==.

replace age_mom=0 if agemom_miss
replace age_dad=0 if agedad_miss

gen age_mom2=age_mom^2
gen age_dad2=age_dad^2

rename edu_mother edu_mom
rename edu_father edu_dad

replace edu_mom=99 if edu_mom==.
replace edu_dad=99 if edu_dad==.

* grades in math and Swedish

rename grades grades_math
replace grades_math=99 if grades_math==.

rename grades_sv grades_swedish
replace grades_swedish=99 if grades_swedish==.

* academic track (school program) and enlistment office

gen newschool_prg=school_prg
replace newschool_prg=24 if newschool_prg==26

* create a set of binary indicators based on background characteristics

gen lninc80f=ln(inc80_f) if inc80_f>0
replace lninc80f=10.99338 if lninc80f==.
gen inc80f_miss=inc80_f==0

gen grades_math_high=grades_math>=4 & grades_math<=5
gen grades_math_miss=grades_math==99
replace grades_math_high=.563943 if grades_math_miss==1

gen grades_swedish_high=grades_swedish>=4 & grades_swedish<=5
gen grades_swedish_miss=grades_swedish==99
replace grades_swedish_high=.5562219 if grades_swedish_miss==1

gen grades_miss=grades_math_miss==1 | grades_swedish_miss==1

gen edu_mom_high=edu_mom>=12
gen edu_mom_miss=edu_mom==99
replace edu_mom_high=.4747232 if edu_mom_miss==1

gen edu_dad_high=edu_dad>=12
gen edu_dad_miss=edu_dad==99
replace edu_dad_high=.5954468 if edu_dad_miss==1

centile inc80_f if usecase
gen inc80_high=inc80_f>=73700 & inc80_f!=.

**************************************************************************
**************************** Analysis ************************************
**************************************************************************

global condvars "i.birth_yr i.bweek i.newschool_prg#i.prvk#i.inst_yr"
global controls "lninc80f inc80f_miss i.fsize age_mom* agemom_miss age_dad* agedad_miss i.edu_mom i.edu_dad i.grades_math i.grades_swedish"

*******************************************************************
***** Figures 1 and 2 - Distribution of Age and School Days *******
*******************************************************************

preserve

set scheme s2mono
replace totdays=totdays*100
replace numofschooldays=numofschooldays*100

histogram totdays if usecase, name(totdays, replace) xtitle("Age in days")
graph export $figures/totdays.eps, replace
histogram numofschooldays if usecase, name(numofschooldays, replace) xtitle("Number of school days")
graph export $figures/numofschooldays.eps, replace

restore

************************************************************
***** Figure 3 - Age (school days + non-school days) *******
************************************************************

preserve

areg rpg1t_std totdays $condvars $controls if usecase, absorb(bsat)
gen b1=_b[totdays]
gen se1=_se[totdays]
estimates store rpg1t
areg rpg2t_std totdays $condvars $controls if usecase, absorb(bsat)
gen b2=_b[totdays]
gen se2=_se[totdays]
estimates store rpg2t
areg rpg3t_std totdays $condvars $controls if usecase, absorb(bsat)
gen b3=_b[totdays]
gen se3=_se[totdays]
estimates store rpg3t
areg rpg4t_std totdays $condvars $controls if usecase, absorb(bsat)
gen b4=_b[totdays]
gen se4=_se[totdays]
estimates store rpg4t

estimates title:"Age (school days + non-school days)"
estimates title
estimates table rpg2t rpg4t rpg3t rpg1t, keep(totdays) b(%4.3f) se(%4.3f)

keep b1 b2 b3 b4 se1 se2 se3 se4
collapse b1 b2 b3 b4 se1 se2 se3 se4, fast

gen i=_n
reshape long b se, i(i) j(j)
gen upper=b+1.96*se
gen lower=b-1.96*se

gen id=1*(j==2)+2*(j==4)+3*(j==3)+4*(j==1)

eclplot b upper lower id, eplottype(bar) xlabel(1 "Synonyms" 2 "Tech Comp" 3 "Spatial" 4 "Logic") xtitle("") ytitle("Coefficient")
graph export $figures/return-totdays.eps, replace

restore

*****************************************************************************************
***** Appendix Figures A2. and A.3 - Season of Birth, Characteristics, and Grades *******
*****************************************************************************************

preserve

replace inc80_f=. if inc80f_miss==1
replace edu_mom=. if edu_mom_miss==1
replace edu_dad=. if edu_dad_miss==1
replace grades_swedish=. if grades_swedish_miss==1
replace grades_math=. if grades_math_miss==1

sum inc80_f edu_mom edu_dad grades_swedish grades_math

collapse (median) inc80_f (mean) edu_mom edu_dad grades_swedish grades_math, by(birth_mo) fast

twoway connected inc80_f birth_mo, name(inc80_f, replace) xlabel(1(1)12) xtitle("Birth month") ytitle(Median father's earnings)
graph export $figures/inc80_f.eps, replace
twoway connected edu_mom birth_mo, name(edu_mom, replace) xlabel(1(1)12) xtitle("Birth month") ytitle(Average mother's education)
graph export $figures/edu_mom.eps, replace
twoway connected edu_dad birth_mo, name(edu_dad, replace) xlabel(1(1)12) xtitle("Birth month") ytitle(Average father's education)
graph export $figures/edu_dad.eps, replace
twoway connected grades_swedish birth_mo, name(grades_swedish, replace) xlabel(1(1)12) xtitle("Birth month") ytitle(Average Swedish grades)
graph export $figures/grades_swedish.eps, replace
twoway connected grades_math birth_mo, name(grades_math, replace) xlabel(1(1)12) xtitle("Birth month") ytitle(Average math grades)
graph export $figures/grades_math.eps, replace

restore

**********************************************************************
***** Table 1 - Cognitive Tests and Background Characteristics *******
**********************************************************************

log using $out/table1, text replace

format rpg1t_std rpg2t_std rpg3t_std rpg4t_std %3.2f

bys grades_math_high: sum rpg2t_std rpg4t_std rpg3t_std rpg1t_std if usecase & grades_miss==0, format
bys grades_swedish_high: sum rpg2t_std rpg4t_std rpg3t_std rpg1t_std if usecase & grades_miss==0, format
bys edu_mom_high: sum rpg2t_std rpg4t_std rpg3t_std rpg1t_std if usecase, format
bys edu_dad_high: sum rpg2t_std rpg4t_std rpg3t_std rpg1t_std if usecase, format
bys inc80_high: sum rpg2t_std rpg4t_std rpg3t_std rpg1t_std if usecase, format

log close

**********************************************
***** Table 2 - Conditional Randomness *******
**********************************************

preserve

replace totdays=totdays*100
replace numofschooldays=numofschooldays*100

log using $out/table2, text replace

global characteristics "grades_math_high grades_swedish_high edu_mom_high edu_dad_high inc80_high"
global characteristics_miss "grades_math_miss grades_swedish_miss edu_mom_miss edu_dad_miss"

foreach lhs of varlist totdays schooldays {
  di "no controls"
  quietly reg `lhs' $characteristics $characteristics_miss if usecase
  estimates store nocontrols
  testparm $characteristics $characteristics_miss

  di "all"
  quietly areg `lhs' $characteristics $characteristics_miss i.birth_yr i.bweek i.newschool_prg#i.prvk#i.birth_yr if usecase, absorb(bsat)
  estimates store all
  testparm $characteristics $characteristics_miss

  estimates title:"`lhs'"
  estimates title
  estimates table nocontrols all, keep($characteristics $characteristics_miss) b(%4.3f) se(%4.3f)
  estimates table nocontrols all, keep($characteristics $characteristics_miss) star(.10 .05 .01)
}

log close

restore

************************************
***** Table 3 - Main results *******
************************************

log using $out/table3, text replace

areg rpg1t_std numofschooldays totdays $condvars $controls if usecase, absorb(bsat)
estimates store rpg1t
testparm $controls
areg rpg2t_std numofschooldays totdays $condvars $controls if usecase, absorb(bsat)
estimates store rpg2t
testparm $controls
areg rpg3t_std numofschooldays totdays $condvars $controls if usecase, absorb(bsat)
estimates store rpg3t
testparm $controls
areg rpg4t_std numofschooldays totdays $condvars $controls if usecase, absorb(bsat)
estimates store rpg4t
testparm $controls

estimates title:"Table 3 - Main Results"
estimates title
estimates table rpg2t rpg4t rpg3t rpg1t, keep(numofschooldays totdays) b(%4.3f) se(%4.3f) p(%3.2f)
estimates table rpg2t rpg4t rpg3t rpg1t, keep(numofschooldays totdays) star(.10 .05 .01)

log close

********************************************
***** Table 4 - Failure to condition *******
********************************************

log using $out/table4, text replace

reg rpg1t_std numofschooldays totdays $controls if usecase
estimates store rpg1t
reg rpg2t_std numofschooldays totdays $controls if usecase
estimates store rpg2t
reg rpg3t_std numofschooldays totdays $controls if usecase
estimates store rpg3t
reg rpg4t_std numofschooldays totdays $controls if usecase
estimates store rpg4t

estimates title:"Appendix Table 1 - Failure to condition"
estimates title
estimates table rpg2t rpg4t rpg3t rpg1t, keep(numofschooldays totdays) b(%4.3f) se(%4.3f) p(%3.2f)
estimates table rpg2t rpg4t rpg3t rpg1t, keep(numofschooldays totdays) star(.10 .05 .01)

log close

**********************************
***** Table 5 - Robustness *******
**********************************

log using $out/table5, text replace

*A. Combined tests
global condvars "i.birth_yr i.bweek i.newschool_prg#i.prvk#i.inst_yr"
global controls "lninc80f inc80f_miss i.fsize age_mom* agemom_miss age_dad* agedad_miss i.edu_mom i.edu_dad i.grades_math i.grades_swedish"
areg rpg24t_std numofschooldays totdays $condvars $controls if usecase, absorb(bsat)
areg rpg13t_std numofschooldays totdays $condvars $controls if usecase, absorb(bsat)

*B. No control vars
global condvars "i.birth_yr i.bweek i.newschool_prg#i.prvk#i.inst_yr"
global controls "lninc80f inc80f_miss i.fsize age_mom* agemom_miss age_dad* agedad_miss i.edu_mom i.edu_dad i.grades_math i.grades_swedish"
areg rpg24t_std numofschooldays totdays $condvars if usecase, absorb(bsat)
areg rpg13t_std numofschooldays totdays $condvars if usecase, absorb(bsat)

*C. Allow for nonlinearity
gen numofschooldays2=numofschooldays^2
gen totdays2=totdays^2
global condvars "i.birth_yr i.bweek i.newschool_prg#i.prvk#i.inst_yr"
global controls "lninc80f inc80f_miss i.fsize age_mom* agemom_miss age_dad* agedad_miss i.edu_mom i.edu_dad i.grades_math i.grades_swedish"
areg rpg24t_std numofschooldays numofschooldays2 totdays totdays2 $condvars $controls if usecase, absorb(bsat)
areg rpg13t_std numofschooldays numofschooldays2 totdays totdays2 $condvars $controls if usecase, absorb(bsat)

*D. Condition on 365 birthday dummies (i.doy)
global condvars "i.birth_yr i.doy i.newschool_prg#i.prvk#i.inst_yr"
global controls "lninc80f inc80f_miss i.fsize age_mom* agemom_miss age_dad* agedad_miss i.edu_mom i.edu_dad i.grades_math i.grades_swedish"
areg rpg24t_std numofschooldays totdays $condvars $controls if usecase, absorb(bsat)
areg rpg13t_std numofschooldays totdays $condvars $controls if usecase, absorb(bsat)

*E. Municipality dummies
global condvars "i.birth_yr i.bweek i.newschool_prg#i.prvk#i.inst_yr"
global controls "lninc80f inc80f_miss i.fsize age_mom* agemom_miss age_dad* agedad_miss i.edu_mom i.edu_dad i.grades_math i.grades_swedish"
areg rpg24t_std numofschooldays totdays $condvars $controls if usecase, absorb(municipality)
areg rpg13t_std numofschooldays totdays $condvars $controls if usecase, absorb(municipality)

*F. Use only the two prvk's who clearly don't condition on expected graduation, and exclude expected graduation conditioning vars
global condvars "i.birth_yr i.bweek"
global controls "lninc80f inc80f_miss i.fsize age_mom* agemom_miss age_dad* agedad_miss i.edu_mom i.edu_dad i.grades_math i.grades_swedish"
areg rpg24t_std numofschooldays totdays $condvars $controls if usecase & (prvk==4 | prvk==6), absorb(bsat)
areg rpg13t_std numofschooldays totdays $condvars $controls if usecase & (prvk==4 | prvk==6), absorb(bsat)

*G. Within 6 months
global condvars "i.birth_yr i.bweek i.newschool_prg#i.prvk#i.inst_yr"
global controls "lninc80f inc80f_miss i.fsize age_mom* agemom_miss age_dad* agedad_miss i.edu_mom i.edu_dad i.grades_math i.grades_swedish"
areg rpg24t_std numofschooldays totdays $condvars $controls if usecase & totdays<=1.80, absorb(bsat)
areg rpg13t_std numofschooldays totdays $condvars $controls if usecase & totdays<=1.80, absorb(bsat)

log close

*************************************
***** Table 6 - Heterogeneity *******
*************************************

log using $out/table6, text replace

*A. Math grades
areg rpg24t_std c.numofschooldays#i.grades_math_high c.totdays#i.grades_math_high $condvars $controls if usecase & grades_miss==0, absorb(bsat)
test i0.grades_math_high#c.numofschooldays=i1.grades_math_high#c.numofschooldays
test i0.grades_math_high#c.totdays=i1.grades_math_high#c.totdays
areg rpg13t_std c.numofschooldays#i.grades_math_high c.totdays#i.grades_math_high $condvars $controls if usecase & grades_miss==0, absorb(bsat)
test i0.grades_math_high#c.numofschooldays=i1.grades_math_high#c.numofschooldays
test i0.grades_math_high#c.totdays=i1.grades_math_high#c.totdays

*B. Swedish grades
areg rpg24t_std c.numofschooldays#i.grades_swedish_high c.totdays#i.grades_swedish_high $condvars $controls if usecase & grades_miss==0, absorb(bsat)
test i0.grades_swedish_high#c.numofschooldays=i1.grades_swedish_high#c.numofschooldays
test i0.grades_swedish_high#c.totdays=i1.grades_swedish_high#c.totdays
areg rpg13t_std c.numofschooldays#i.grades_swedish_high c.totdays#i.grades_swedish_high $condvars $controls if usecase & grades_miss==0, absorb(bsat)
test i0.grades_swedish_high#c.numofschooldays=i1.grades_swedish_high#c.numofschooldays
test i0.grades_swedish_high#c.totdays=i1.grades_swedish_high#c.totdays

*C. Mom's education
areg rpg24t_std c.numofschooldays#i.edu_mom_high c.totdays#i.edu_mom_high $condvars $controls if usecase & edu_mom_miss==0, absorb(bsat)
test i0.edu_mom_high#c.numofschooldays=i1.edu_mom_high#c.numofschooldays
test i0.edu_mom_high#c.totdays=i1.edu_mom_high#c.totdays
areg rpg13t_std c.numofschooldays#i.edu_mom_high c.totdays#i.edu_mom_high $condvars $controls if usecase & edu_mom_miss==0, absorb(bsat)
test i0.edu_mom_high#c.numofschooldays=i1.edu_mom_high#c.numofschooldays
test i0.edu_mom_high#c.totdays=i1.edu_mom_high#c.totdays

*D. Dad's education
areg rpg24t_std c.numofschooldays#i.edu_dad_high c.totdays#i.edu_dad_high $condvars $controls if usecase & edu_dad_miss==0, absorb(bsat)
test i0.edu_dad_high#c.numofschooldays=i1.edu_dad_high#c.numofschooldays
test i0.edu_dad_high#c.totdays=i1.edu_dad_high#c.totdays
areg rpg13t_std c.numofschooldays#i.edu_dad_high c.totdays#i.edu_dad_high $condvars $controls if usecase & edu_dad_miss==0, absorb(bsat)
test i0.edu_dad_high#c.numofschooldays=i1.edu_dad_high#c.numofschooldays
test i0.edu_dad_high#c.totdays=i1.edu_dad_high#c.totdays

*E. Family income (Dad's earnings)
areg rpg24t_std c.numofschooldays#i.inc80_high c.totdays#i.inc80_high $condvars $controls if usecase, absorb(bsat)
test i0.inc80_high#c.numofschooldays=i1.inc80_high#c.numofschooldays
test i0.inc80_high#c.totdays=i1.inc80_high#c.totdays
areg rpg13t_std c.numofschooldays#i.inc80_high c.totdays#i.inc80_high $condvars $controls if usecase, absorb(bsat)
test i0.inc80_high#c.numofschooldays=i1.inc80_high#c.numofschooldays
test i0.inc80_high#c.totdays=i1.inc80_high#c.totdays

log close

**********************************************
***** Appendix Tables A.1, A.2 and A.3 *******
**********************************************

log using $out/apptables, text replace

*Appendix Table A.1

replace newschool_prg=999 if newschool_prg==-99 
replace newschool_prg=99 if newschool_prg==-9 
replace newschool_prg=98 if newschool_prg==-8

sum grades_math_high if grades_miss==0 & usecase
sum grades_swedish_high if grades_miss==0 & usecase
sum edu_mom_high if edu_mom_miss!=1 & usecase
sum edu_dad_high if edu_dad_miss!=1 & usecase
sum inc80_f if usecase
sum fsize if fsize!=99 & usecase
sum rpg2t_std rpg4t_std rpg3t_std rpg1t_std if usecase

sum grades_math_high if grades_miss==0 & usecase11
sum grades_swedish_high if grades_miss==0 & usecase11
sum edu_mom_high if edu_mom_miss!=1 & usecase11
sum edu_dad_high if edu_dad_miss!=1 & usecase11
sum inc80_f if usecase11
sum fsize if fsize!=99 & usecase11
sum rpg2t_std rpg4t_std rpg3t_std rpg1t_std if usecase11

sum grades_math_high if grades_miss==0 & usecase9
sum grades_swedish_high if grades_miss==0 & usecase9
sum edu_mom_high if edu_mom_miss!=1 & usecase9
sum edu_dad_high if edu_dad_miss!=1 & usecase9
sum inc80_f if usecase9
sum fsize if fsize!=99 & usecase9
sum rpg2t_std rpg4t_std rpg3t_std rpg1t_std if usecase9

*Appendix Table A.2

areg rpg1t_std totdays $condvars $controls if usecase, absorb(bsat)
estimates store rpg1t
testparm $controls
areg rpg2t_std totdays $condvars $controls if usecase, absorb(bsat)
estimates store rpg2t
testparm $controls
areg rpg3t_std totdays $condvars $controls if usecase, absorb(bsat)
estimates store rpg3t
testparm $controls
areg rpg4t_std totdays $condvars $controls if usecase, absorb(bsat)
estimates store rpg4t
testparm $controls

estimates title:"App Table 2 - academic track"
estimates title
estimates table rpg2t rpg4t rpg3t rpg1t, keep(totdays) b(%4.3f) se(%4.3f) p(%3.2f)

areg rpg1t_std totdays $condvars $controls if usecase11, absorb(bsat)
estimates store rpg1t
testparm $controls
areg rpg2t_std totdays $condvars $controls if usecase11, absorb(bsat)
estimates store rpg2t
testparm $controls
areg rpg3t_std totdays $condvars $controls if usecase11, absorb(bsat)
estimates store rpg3t
testparm $controls
areg rpg4t_std totdays $condvars $controls if usecase11, absorb(bsat)
estimates store rpg4t
testparm $controls

estimates title:"App Table 2 - vocational track"
estimates title
estimates table rpg2t rpg4t rpg3t rpg1t, keep(totdays) b(%4.3f) se(%4.3f) p(%3.2f)

areg rpg1t_std totdays $condvars $controls if usecase9, absorb(bsat)
estimates store rpg1t
testparm $controls
areg rpg2t_std totdays $condvars $controls if usecase9, absorb(bsat)
estimates store rpg2t
testparm $controls
areg rpg3t_std totdays $condvars $controls if usecase9, absorb(bsat)
estimates store rpg3t
testparm $controls
areg rpg4t_std totdays $condvars $controls if usecase9, absorb(bsat)
estimates store rpg4t
testparm $controls

estimates title:"App Table 2 - 9th grade"
estimates title
estimates table rpg2t rpg4t rpg3t rpg1t, keep(totdays) b(%4.3f) se(%4.3f) p(%3.2f)

*Appendix Table A.3

*Median cutpoints
centile hstd hsexp hspcedu
gen hstdhigh=hstd>=7.46067 & hstd!=.
gen hsexphigh=hsexp>=14.798 & hsexp!=.
gen hspceduhigh=hspcedu>=.937 & hspcedu!=.
replace hstdhigh=. if hstd==.
replace hsexphigh=. if hsexp==.
replace hspceduhigh=. if hspcedu==.

areg rpg24t_std c.numofschooldays#i.hstdhigh c.totdays#i.hstdhigh $condvars $controls if usecase, absorb(bsat)
areg rpg13t_std c.numofschooldays#i.hstdhigh c.totdays#i.hstdhigh $condvars $controls if usecase, absorb(bsat)

areg rpg24t_std c.numofschooldays#i.hsexphigh c.totdays#i.hsexphigh $condvars $controls if usecase, absorb(bsat)
areg rpg13t_std c.numofschooldays#i.hsexphigh c.totdays#i.hsexphigh $condvars $controls if usecase, absorb(bsat)

areg rpg24t_std c.numofschooldays#i.hspceduhigh c.totdays#i.hspceduhigh $condvars $controls if usecase, absorb(bsat)

log close

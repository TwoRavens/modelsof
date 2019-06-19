cd C:\DataFiles\Research-Papers\Immigration\Kato\REStatPublicFiles\Tables\Tab10
*Rename directory according to own folder name.
clear
set more off
capture log close
log using Tab10_CaseStudyReg.log, text replace

set mem 500m
set matsize 3000

/*************************************************************************
Takao Kato & Chad Sparber
"Quotas and Quality: The Effect of H-1B Visa Restrictions 
   on the Pool of Prospective Undergraduate Students from Abroad"

Stata do-file for Table 10: Case Study of Applicants to a Highly-Selective University
Data Source: Case Study

This file regresses Case Study SAT score & GPA data on whether H-1B policies were binding.

Assume 1st binding year: 2004 (Australia 2005)

Data aggregated to country*time level. 
 Non-SAT Takers dropped. Permanent US Residents and Dual US Citizens Dropped.

Regressions are weighted by number of applications (multiplied by a constant). 
*******************************************************************************/






use CaseStudyPublicData.dta, clear

gen lnm=ln(math)
label var lnm "ln(Math)"
gen lnv=ln(verbal)
label var lnv "ln(Verbal)"
gen lns=ln(sat)
label var lns "ln(SAT)"
gen lngpa=ln(gpa)
label var lngpa "ln(GPA)"

sum

tab year, gen(dy)
tab origin, gen(dc)







/*************************************
Run Regressions
*************************************/
areg math bind dy*  [aw=weight], absorb(origin) cluster(origin)
outreg bind using Tab10_CaseStudyReg.xls, se bdec(3) 3aster replace

areg verbal bind dy*  [aw=weight], absorb(origin) cluster(origin)
outreg bind using Tab10_CaseStudyReg.xls, se bdec(3) 3aster append

areg sat bind dy*  [aw=weight], absorb(origin) cluster(origin)
outreg bind using Tab10_CaseStudyReg.xls, se bdec(3) 3aster append

areg gpa bind dy*  [aw=weight], absorb(origin) cluster(origin)
outreg bind using Tab10_CaseStudyReg.xls, se bdec(3) 3aster append





areg lnm bind dy*  [aw=weight], absorb(origin) cluster(origin)
outreg bind using Tab10_CaseStudyReg.xls, se bdec(3) 3aster append

areg lnv bind dy*  [aw=weight], absorb(origin) cluster(origin)
outreg bind using Tab10_CaseStudyReg.xls, se bdec(3) 3aster append

areg lns bind dy*  [aw=weight], absorb(origin) cluster(origin)
outreg bind using Tab10_CaseStudyReg.xls, se bdec(3) 3aster append

areg lngpa bind dy*  [aw=weight], absorb(origin) cluster(origin)
outreg bind using Tab10_CaseStudyReg.xls, se bdec(3) 3aster append





capture log close

exit

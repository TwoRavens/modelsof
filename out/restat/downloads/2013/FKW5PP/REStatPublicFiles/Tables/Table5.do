cd C:\DataFiles\Research-Papers\Immigration\Kato\REStatPublicFiles\Tables
*Rename directory according to own folder name.
clear
set more off
capture log close
log using Table5.log, text replace

set mem 500m
set matsize 3000

/*************************************************************************
Takao Kato & Chad Sparber
"Quotas and Quality: The Effect of H-1B Visa Restrictions 
   on the Pool of Prospective Undergraduate Students from Abroad"

Stata do-file for Table 5
This file regresses SAT score & GPA data on whether H-1B policies were binding.
Time dummies are SAT Date
Regressions test varied dates for the timing of binding H-1B policy.

SAT Data Acquisition and Defined Binding Dates available in:
C:\DataFiles\Research-Papers\Immigration\Kato\REStatPublicFiles\CleanedSAT

Sample Includes:
       AltSource |     Drop
   Baccalaureate |       Keep
          Branch |     Drop
CommunityCollege |     Drop
     InCB_NotUSN |     Drop
   International |     Drop
          IntlCC |     Drop
 IntlProprietary |     Drop
     LiberalArts |       Keep
         Masters |       Keep
         Medical |     Drop
     NonAcademic |     Drop
           Other |     Drop
     Proprietary |     Drop
        Research |       Keep
       Specialty |     Drop
    TwoYrPrivate |     Drop
        USAbroad |     Drop

Drop unranked schools among these 4 types
*******************************************************************************/





/*************************************
SET UP DATA
*************************************/
use C:\DataFiles\Research-Papers\Immigration\Kato\REStatPublicFiles\CleanedSAT\CleanSAT.dta, clear

*Table Years of Test Taken
tab latsty

*Select School Types
drop if type=="AltSource"
drop if type=="Branch"
drop if type=="CommunityCollege"
drop if type=="InCB_NotUSN"
drop if type=="International"
drop if type=="IntlCC"
drop if type=="IntlProprietary"
drop if type=="Medical"
drop if type=="NonAcademic"
drop if type=="Other"
drop if type=="Proprietary"
drop if type=="Specialty"
drop if type=="TwoYrPrivate"
drop if type=="USAbroad"

*Drop Unranked, Big 4 Type
drop if gentier==4
save temp-a.dta, replace





/*************************************
Aggregate, Create Aggregate Dummies, 
and Generate ln(dependent variables)
*************************************/
gen obs=1
collapse (sum) obs weight, by(latsty latstm satdate typenum gentier genfund bea frgnadd)
sort  latsty latstm satdate typenum gentier genfund bea frgnadd
save temp-b.dta, replace

use temp-a.dta, clear
tab race, gen(drace)
tab mothed, gen(dmoth)
tab fathed, gen(dfath)
collapse (mean) math verbal sat bind aid athlete female drace* advanced dmoth* dfath* [aw=weight], by(latsty latstm satdate typenum gentier genfund bea frgnadd)
sort  latsty latstm satdate typenum gentier genfund bea frgnadd
merge latsty latstm satdate typenum gentier genfund bea frgnadd using temp-b.dta
tab _merge
drop _merge
erase temp-a.dta
erase temp-b.dta

tab bind
tab satdate, gen(dy)
 local ys=r(r)
egen school=group(typenum gentier genfund bea)
quietly tab school, gen(dschool)
 local schools=r(r)
egen id=group(typenum gentier genfund bea frgnadd)

gen lnm = ln(math)
gen lnv = ln(verbal)
gen lns = ln(sat)

label var lnm "ln(Math)"
label var lnv "ln(Verbal)"
label var lns "ln(SAT)"

label var bind "Bound by H-1B Visa Cap?"






/*************************************
SET UP CONTROLS
*************************************/
*Year Controls
global t dy2-dy`ys'





/*************************************
DEFINE REGRESSSION PROGRAM
*************************************/
capture program drop regs
program define regs

areg `1' bind $t [aw=weight], absorb(id) cluster(id)
outreg bind using Table5`3'.xls, se bdec(3) 3aster `2'

end





/*************************************
DO REGRESSIONS FOR TABLE 5,
NOTE REDEFINED POLICY DATES.
*************************************/


/*************************************
Columns 1-3: 
Baseline assumes exam date in month 
 AFTER policy change reflects knowledge 
 of new policy.
**************************************/
regs math replace
regs verbal append
regs sat append

regs lnm replace LOG
regs lnv append LOG
regs lns append LOG




/*************************************
Column 4:
Assume exam date in month OF policy 
 change relects knowledge of new policy.
**************************************/
drop bind
gen bind=1

*Canada & Mexico:
replace bind=0 if frgnadd==100 
replace bind=0 if frgnadd==375

*All Countries at early dates:
replace bind=0 if (latstm==10 | latstm==11 | latstm==12) & latsty==2000
replace bind=0 if latsty==2001 | latsty==2002
replace bind=0 if latstm<10 & latsty==2003

*Chile and Singapore:
replace bind=0 if frgnadd==115 & latsty>=2003 
replace bind=0 if frgnadd==505 & latsty>=2003 

*Australia:
replace bind=0 if frgnadd==020 & latstm>=5 & latsty==2005
replace bind=0 if frgnadd==020 & latsty>=2006

replace bind=. if latsty==.
label var bind "Bound by H-1B Visa Cap?"

regs sat append
regs lns append LOG




/*************************************
Column 5:
Assume exam date in TWO MONTHS AFTER 
 policy change relects knowledge 
 of new policy.
**************************************/
drop bind
gen bind=1

*Canada & Mexico:
replace bind=0 if frgnadd==100 
replace bind=0 if frgnadd==375

*All Countries at early dates:
replace bind=0 if (latstm==12) & latsty==2000
replace bind=0 if latsty==2001 | latsty==2002
replace bind=0 if latstm<12 & latsty==2003

*Chile and Singapore:
replace bind=0 if frgnadd==115 & latsty>=2003 
replace bind=0 if frgnadd==505 & latsty>=2003 

*Australia:
replace bind=0 if frgnadd==020 & latstm>=7 & latsty==2005
replace bind=0 if frgnadd==020 & latsty>=2006

replace bind=. if latsty==.
label var bind "Bound by H-1B Visa Cap?"

regs sat append
regs lns append LOG




/*************************************
Column 6:
Assume people apply to matriculate in 
 fall of year following SAT Exam Date.
 e.g., Exam in Sep 02 - Dec 02: Matriculate Fall 2003
       Exam in Jan 03 - Jun 03: Matriculate Fall 2004
 A Policy Change in October 2003 would 
 then affect those who took the exam 
 ANYTIME in 2003 and beyond.
**************************************/
drop bind
gen bind=1

*Canada & Mexico:
replace bind=0 if frgnadd==100 
replace bind=0 if frgnadd==375

*All Countries at early dates:
replace bind=0 if (latstm==11 | latstm==12) & latsty==2000
replace bind=0 if latsty>=2000 & latsty<=2002

*Chile and Singapore:
replace bind=0 if frgnadd==115 & latsty>=2003 
replace bind=0 if frgnadd==505 & latsty>=2003 

*Australia:
replace bind=0 if frgnadd==020 & latsty>=2005

replace bind=. if latsty==.
label var bind "Bound by H-1B Visa Cap?"

regs sat append
regs lns append LOG























capture log close

exit

cd C:\DataFiles\Research-Papers\Immigration\Kato\REStatPublicFiles\Tables
*Rename directory according to own folder name.
clear
set more off
capture log close
log using Table9.log, text replace

set mem 500m
set matsize 3000

/*************************************************************************
Takao Kato & Chad Sparber
"Quotas and Quality: The Effect of H-1B Visa Restrictions 
   on the Pool of Prospective Undergraduate Students from Abroad"

Stata do-file for Table 5
This file regresses % of people with SAT score reports falling into each quintile
                    on whether H-1B policies were binding.
Time dummies are SAT Date

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

Quintiles determined by percentiles on satdates through 2002-2003 schoolyear, 
 when cap was unambiguously non-binding for all.

March and April dropped because few observations those months.
*******************************************************************************/





/*************************************
SET UP DATA 
 & CREATE APPLICATIONS PER APPLICANT
*************************************/
use C:\DataFiles\Research-Papers\Immigration\Kato\REStatPublicFiles\CleanedSAT\CleanSAT.dta, clear
drop if latstm==3 | latstm==4
tab latstm

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

*ID Quintiles
forvalues i=20(20)100 {
local qt0=0
local j=`i'/20
local k=`j'-1
centile sat if satdate<=200304, centile(`i')
local qt`j'=r(c_1)
di `qt`j''

gen quint`j'=0
replace quint`j'=weight if sat>`qt`k'' & sat<=`qt`j''
}

sum quint*

forvalues i=1(1)5 {
sum sat if quint`i'!=0
}

sort satmap
save temp-a.dta, replace
gen appsent=1
collapse (sum) appsent, by(satmap)
sort satmap
merge satmap using temp-a.dta
tab _merge
drop _merge
save temp-a.dta, replace





/*************************************
Aggregate & Create Aggregate Dummies
*************************************/
gen obs=1
collapse (sum) obs weight quint*, by(latsty latstm satdate typenum gentier genfund bea frgnadd)
forvalues i=1(1)5 {
gen q`i'actshare = quint`i'/weight
}
sort typenum gentier genfund bea frgnadd
save temp-c.dta, replace

collapse (mean) weight, by(typenum gentier genfund bea frgnadd)
rename weight apps_prebind
sort typenum gentier genfund bea frgnadd
merge typenum gentier genfund bea frgnadd using temp-c.dta
tab _merge

drop _merge
erase temp-c.dta

forvalues i=1(1)5 {
gen q`i'normshare = quint`i'/apps_prebind
}
sort  latsty latstm satdate typenum gentier genfund bea frgnadd
save temp-b.dta, replace

use temp-a.dta, clear
collapse (mean) bind aid athlete female appsent [aw=weight], by(latsty latstm satdate typenum gentier genfund bea frgnadd)
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

label var bind "Bound by H-1B Visa Cap?"

forvalues i=1(1)5 {
label var q`i'actshare "Q`i' Share of Apps"
label var q`i'normshare "Q`i' Normalized Share of Apps"
}

label var appsent "Avg Apps/Person"





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

areg q1`1'share bind `2' $t , absorb(id) cluster(id)
outreg bind `2' using Table9.xls, se bdec(3) 3aster `3' ti("5th Quint is Highest Ability")

areg q2`1'share bind `2' $t , absorb(id) cluster(id)
outreg bind `2' using Table9.xls, se bdec(3) 3aster append

areg q3`1'share bind `2' $t , absorb(id) cluster(id)
outreg bind `2' using Table9.xls, se bdec(3) 3aster append

areg q4`1'share bind `2' $t , absorb(id) cluster(id)
outreg bind `2' using Table9.xls, se bdec(3) 3aster append

areg q5`1'share bind `2' $t , absorb(id) cluster(id)
outreg bind `2' using Table9.xls, se bdec(3) 3aster append

end





/*************************************
DO REGRESSIONS
*************************************/

*Row 1: Y=Actual Share; No Controls
regs act " " replace

*Row 2: Y=Normalized Share; No Controls
regs norm " " append

*Row 3: Y=Actual Share; Apps/Person Control
regs act "appsent" append

*Row 4: Y=Normalized Share; Apps/Person Control
regs norm "appsent" append



















capture log close

exit


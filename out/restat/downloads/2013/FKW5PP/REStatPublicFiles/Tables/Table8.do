cd C:\DataFiles\Research-Papers\Immigration\Kato\REStatPublicFiles\Tables
*Rename directory according to own folder name.
clear
set more off
capture log close
log using Table8.log, text replace

set mem 500m
set matsize 3000

/*************************************************************************
Takao Kato & Chad Sparber
"Quotas and Quality: The Effect of H-1B Visa Restrictions 
   on the Pool of Prospective Undergraduate Students from Abroad"

Stata do-file for Table 8
This file regresses demographic composition of SAT score reports on whether H-1B policies were binding.
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

label var female "% Female"
label var drace1 "% Asian"
label var drace2 "% Black"
label var drace3 "% Hispanic"
label var drace4 "% Other"
label var drace5 "% White"
label var aid "% Sure to Apply for Aid"
label var advanced "% Sure to Pursue Adv Deg"





/*************************************
DO REGRESSIONS FOR TABLE 8
*************************************/
areg female bind $t [aw=weight], absorb(id) cluster(id)
outreg bind using Table8.xls, se bdec(3) 3aster replace

areg drace1 bind $t [aw=weight], absorb(id) cluster(id)
outreg bind using Table8.xls, se bdec(3) 3aster append

areg drace2 bind $t [aw=weight], absorb(id) cluster(id)
outreg bind using Table8.xls, se bdec(3) 3aster append

areg drace3 bind $t [aw=weight], absorb(id) cluster(id)
outreg bind using Table8.xls, se bdec(3) 3aster append

areg drace5 bind $t [aw=weight], absorb(id) cluster(id)
outreg bind using Table8.xls, se bdec(3) 3aster append

areg advanced bind $t [aw=weight], absorb(id) cluster(id)
outreg bind using Table8.xls, se bdec(3) 3aster append

areg aid bind $t [aw=weight], absorb(id) cluster(id)
outreg bind using Table8.xls, se bdec(3) 3aster append



















capture log close

exit


cd C:\DataFiles\Research-Papers\Immigration\Kato\REStatPublicFiles\Tables
*Rename directory according to own folder name.
clear
set more off
capture log close
log using Table2_3_4.log, text replace

set mem 500m
set matsize 3000

/*************************************************************************
Takao Kato & Chad Sparber
"Quotas and Quality: The Effect of H-1B Visa Restrictions 
   on the Pool of Prospective Undergraduate Students from Abroad"

Stata do-file for Tables 2, 3, and 4
This file regresses SAT score & GPA data on whether H-1B policies were binding.
Time dummies are latest exam year

SAT Data Acquisition and Defined Binding Dates available in:
C:\DataFiles\Research-Papers\Immigration\Kato\REStatPublicFiles\CleanedSAT

Sample Includes Schools of Type:
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
Create Individual-Level dummies for
summarizing in Table 2.
*************************************/
tab race, gen(drace)
tab mothed, gen(dmoth)
tab fathed, gen(dfath)
tab type, gen(dtype)
tab gentier, gen(dtier)
tab genfund, gen(dfund)
tab bea, gen(dregion)

*CREATE TABLE 2
sum math verbal sat female athlete aid advanced bind drace* dmoth* dfath* dtype* dtier* dfund2 dregion*





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
tab latsty, gen(dy)
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

*Person Controls
global x1 aid athlete female drace1-drace4
global x2 advanced dmoth2-dmoth6 dfath2-dfath6

*School Controls
global s2 dschool2-dschool`schools'





/*************************************
DEFINE REGRESSSION PROGRAM
*************************************/
capture program drop regs
program define regs

areg `1' bind $s2 $t [aw=weight], absorb(frgnadd) cluster(frgnadd)
outreg bind $s2 using Table`3'.xls, se bdec(3) 3aster `2'

areg `1' bind $t [aw=weight], absorb(id) cluster(id)
outreg bind using Table`3'.xls, se bdec(3) 3aster append

areg `1' bind $x1 $x2 $t [aw=weight], absorb(id) cluster(id)
outreg bind $x1 $x2 using Table`3'.xls, se bdec(3) 3aster append

end





/*************************************
DO REGRESSIONS,
CREATE TABLES 3 & 4
*************************************/

*CREATE TABLE 3
regs math replace 3
regs verbal append 3
regs sat append 3


*CREATE TABLE 4
regs lnm replace 4
regs lnv append 4
regs lns append 4

















capture log close

exit


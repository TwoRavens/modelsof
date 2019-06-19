cd C:\DataFiles\Research-Papers\Immigration\Kato\REStatPublicFiles\Tables
*Rename directory according to own folder name.
clear
set more off
capture log close
log using Table7.log, text replace

set mem 500m
set matsize 3000

/*************************************************************************
Takao Kato & Chad Sparber
"Quotas and Quality: The Effect of H-1B Visa Restrictions 
   on the Pool of Prospective Undergraduate Students from Abroad"

Stata do-file for Table 7
This file regresses SAT score & GPA data on whether H-1B policies were binding.
Time dummies are SAT Date
Regressions explore differential effects based upon school type.

SAT Data Acquisition and Defined Binding Dates available in:
C:\DataFiles\Immigration\Kato\SAT\RawSAT_Data\CleanSAT.do
and C:\DataFiles\Immigration\Kato\SAT\RawSAT_Data\CutYr_AgFrgnadd.do

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


*Bind by Type:
tab typenum, gen(bindtype)
forvalues i=1(1)4 {
replace bindtype`i'=bindtype`i'*bind
}
label var bindtype1 Bind_Res
label var bindtype2 Bind_LibArt
label var bindtype3 Bind_Mast
label var bindtype4 Bind_Bacc


*Bind by Tier:
tab gentier, gen(bindtier)
forvalues i=1(1)3 {
replace bindtier`i'=bindtier`i'*bind
}
label var bindtier1 Bind_Top
label var bindtier2 Bind_Mid
label var bindtier3 Bind_Bot


*Bind by Top Tier Research
gen topres=0
replace topres=1 if typenum==1 & gentier==1
gen bind_topres=bind*topres






/*************************************
DO REGRESSIONS FOR TABLE 7
*************************************/
areg sat bindtype1-bindtype4 $t [aw=weight], absorb(id) cluster(id)
outreg bindtype1-bindtype4 using Table7.xls, se bdec(3) 3aster replace



areg sat bindtier1-bindtier3 $t [aw=weight], absorb(id) cluster(id)
outreg bindtier1-bindtier3 using Table7.xls, se bdec(3) 3aster append



areg sat bind bind_topres $t [aw=weight], absorb(id) cluster(id)
outreg bind bind_topres using Table7.xls, se bdec(3) 3aster append



















capture log close

exit


cd C:\DataFiles\Research-Papers\Immigration\Kato\REStatPublicFiles\Tables
*Rename directory according to own folder name.
clear
set more off
capture log close
log using Table6.log, text replace

set mem 500m
set matsize 3000

/*************************************************************************
Takao Kato & Chad Sparber
"Quotas and Quality: The Effect of H-1B Visa Restrictions 
   on the Pool of Prospective Undergraduate Students from Abroad"

Stata do-file for Table 6
This file regresses SAT score & GPA data on whether H-1B policies were binding.
Time dummies are SAT Date
Regressions account for macroeconomic conditions.


SAT Data Acquisition and Defined Binding Dates available in:
C:\DataFiles\Research-Papers\Immigration\Kato\REStatPublicFiles\CleanedSAT

Macroeconomic conditions data available in:
C:\DataFiles\Research-Papers\Immigration\Kato\REStatPublicFiles\Macro

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
Merge with Macroeconomic Information,
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




gen asia=0 
replace asia=1 if	 frgnadd==	1	   
replace asia=1 if	 frgnadd==	29	   
replace asia=1 if	 frgnadd==	40	   
replace asia=1 if	 frgnadd==	45	   
replace asia=1 if	 frgnadd==	63	   
replace asia=1 if	 frgnadd==	81	   
replace asia=1 if	 frgnadd==	208	   
replace asia=1 if	 frgnadd==	250	   
replace asia=1 if	 frgnadd==	260	   
replace asia=1 if	 frgnadd==	265	   
replace asia=1 if	 frgnadd==	270	   
replace asia=1 if	 frgnadd==	280	   
replace asia=1 if	 frgnadd==	300	   
replace asia=1 if	 frgnadd==	305	   
replace asia=1 if	 frgnadd==	307	   
replace asia=1 if	 frgnadd==	308	   
replace asia=1 if	 frgnadd==	315	   
replace asia=1 if	 frgnadd==	320	   
replace asia=1 if	 frgnadd==	323	   
replace asia=1 if	 frgnadd==	330	   
replace asia=1 if	 frgnadd==	360	   
replace asia=1 if	 frgnadd==	379	   
replace asia=1 if	 frgnadd==	387	   
replace asia=1 if	 frgnadd==	443	   
replace asia=1 if	 frgnadd==	445	   
replace asia=1 if	 frgnadd==	457	   
replace asia=1 if	 frgnadd==	465	   
replace asia=1 if	 frgnadd==	477	   
replace asia=1 if	 frgnadd==	484	   
replace asia=1 if	 frgnadd==	490	   
replace asia=1 if	 frgnadd==	505	   
replace asia=1 if	 frgnadd==	520	   
replace asia=1 if	 frgnadd==	545	   
replace asia=1 if	 frgnadd==	555	   
replace asia=1 if	 frgnadd==	556	   
replace asia=1 if	 frgnadd==	565	   
replace asia=1 if	 frgnadd==	584	   
replace asia=1 if	 frgnadd==	585	   
replace asia=1 if	 frgnadd==	591	   
replace asia=1 if	 frgnadd==	594	   
replace asia=1 if	 frgnadd==	605	   
replace asia=1 if	 frgnadd==	611	   
replace asia=1 if	 frgnadd==	623	 

gen oceania=0 
replace oceania=1 if	 frgnadd==	20	   
replace oceania=1 if	 frgnadd==	107	   
replace oceania=1 if	 frgnadd==	190	   
replace oceania=1 if	 frgnadd==	368	   
replace oceania=1 if	 frgnadd==	400	   
replace oceania=1 if	 frgnadd==	405	   
replace oceania=1 if	 frgnadd==	447	 




rename latsty year
tab year
sort year frgnadd
merge year frgnadd using C:\DataFiles\Research-Papers\Immigration\Kato\REStatPublicFiles\Macro\MacroConditions.dta
tab _merge
tab year if _m!=3
di "merge=1 implies SAT data exists, but IPUMS immigration data does not"
tab frgnadd if _m==1
di "merge=2 implies IPUMS migration data exists, but SAT data does not"
tab frgnadd if _m==2
drop _merge
rename year latsty
gen lngdpindex=ln(gdpindex)
label var lngdpindex "ln(Weighted US Industry GDP)"
gen bind_oecd = bind*oecd
label var bind_oecd "Bind*OECD"






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

areg sat bind `1' $t [aw=weight] `2' , absorb(id) cluster(id)
outreg  bind `1' using Table6.xls, se bdec(3) 3aster `3'

areg lns bind `1' $t [aw=weight] `2' , absorb(id) cluster(id)
outreg  bind `1' using Table6LOG.xls, se bdec(3) 3aster `3'

end





/*************************************
DO REGRESSIONS
*************************************/
*Col 1: Exclude China, India, Bulgaria, Romania
regs " " "if frgnadd!=260 & frgnadd!=457 & frgnadd!=85 & frgnadd!=483" replace


*Col 2: Exclude Canada
regs " " "if frgnadd!=100" append


*Col 3: Exclude Singapore
regs " " "if frgnadd!=505" append


*Col 4: Exclude Asian & Oceanic Countries
regs " " "if asia!=1 & oceania!=1" append


*Col 5: Control for Other Macro Conditions
regs "bind_oecd lngdpindex" " " append



















capture log close

exit


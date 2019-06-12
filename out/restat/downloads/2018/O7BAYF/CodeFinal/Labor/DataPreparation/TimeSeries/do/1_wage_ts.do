********************************************************************************************
*******This file creates aggregate log weekly wages of fulltime males for all survey years
********************************************************************************************

foreach year of glo years {

			use "$data/mar`year'.dta", clear

***Only keep earnings sample ages 25-64 and experience less than 49 years;
keep if agely>=25 & agely<=64
drop if exp>48

***drop female
drop if female==1

***Drop self-employed
drop if selfemp

***drop if not fulltime
drop if fulltime==0

***drop if weekly wage missing
assert hinc_ws==. if winc_ws==.
assert winc_ws==. if hinc_ws==.
drop if winc_ws==.

***gen log wage weekly
gen lnwinc=ln(winc_ws)

***gen log wage hourly
gen lnhinc=ln(hinc_ws)


***Copied from Acemoglu and Autor 2011
***Drop allocators 

if year <= 1975 {
	drop if allocated == 1
}

if year >= 1988 {
	drop if allocated == 1
	
}

if year <= 1987 & year >= 1976 {
	drop if allocated == 1
}
	
*** Create consistent education categories
if year<1991 {
  
  capture confirm numeric variable educomp
  if _rc!=0 {
     gen byte educomp= max(0,_grdhi-(grdcom==2)) 
  }
  
  * tab educomp (recoded grdcom is 6 and 7 in first year (different than acemoglu))
  assert educomp>=0 & educomp<=18 
  gen ed8 = educomp<=8
  gen ed9  = educomp==9
  gen ed10 = educomp==10
  gen ed11 = educomp==11
  gen edhsg = (educomp==12 & grdcom==1) | (educomp==12 & grdcom==7)
  gen edsmc = (educomp>=13 & educomp<=15) | (educomp==12 & grdcom==2) | (educomp==12 & grdcom==6)
  gen edclg = educomp==16 | educomp==17
  gen edgtc = educomp>17
}

if year>=1991 {
  gen ed8  = grdatn<=34
  gen ed9  = grdatn==35
  gen ed10 = grdatn==36
  gen ed11 = grdatn==37
  gen edhsg = grdatn== 38 | grdatn==39
  gen edsmc = grdatn>=40 & grdatn<=42
  gen edclg = grdatn==43
  gen edgtc = grdatn>=44
}



***assert that only in one category
assert ed8+ed9+ed10+ed11+edhsg+edsmc+edclg+edgtc==1

***gen dummy for high school drop outs (below 37 grdatn)
gen byte edhsd = ed8+ed9+ed10+ed11

***gen dummy for college graduate or more
gen byte edcom = edgtc+edclg



***generate eight-types
***generate two groups of experience
egen experience2=cut(exp), at(0,20,49)

***college or more aggreagted
egen educ4=group(edcom edsmc edhsg edhsd)

egen ltypes=group(educ4 experience2)



***generate two-types
***gen dummy for some college or more
gen byte edsomecom = edcom+edsmc

***gen dummy for high school graduate and drop out
gen byte edhsgohsd = edhsg+edhsd

***gen two types
egen ltypestwo=group(edsomecom edhsgohsd)



****collapse and save eight types time series
preserve

collapse (mean) lnwinc (firstnm) year [aw=wgt], by(ltypes)

save "$data/agg`year'.dta", replace
restore

****collapse and save two types time series
preserve

collapse (mean) lnwinc (firstnm) year [aw=wgt], by(ltypestwo)

save "$data/agg`year'_two_type.dta", replace
restore



}


***eight types
use "$data/agg62.dta", clear
			
foreach year of glo yearsbf {

			append using "$data/agg`year'.dta"

}

***drop 1961 (march CPS 62) as 62 (march CPS 63) does not exist, so 63-2008 ist the sample (march CPS 64-2009)  
drop if year==1961
sort year ltypes
save "$data/tswage.dta", replace


***two type
use "$data/agg62_two_type.dta", clear
			
foreach year of glo yearsbf {

			append using "$data/agg`year'_two_type.dta"

}

***drop 1961 (march CPS 62) as 62 (march CPS 63) does not exist, so 63-2008 ist the sample (march CPS 64-2009)  
drop if year==1961
sort year ltypes
save "$data/tswage_two_type.dta", replace





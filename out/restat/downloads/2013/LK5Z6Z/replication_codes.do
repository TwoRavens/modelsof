*** insert location of directory containing files in place of DIRECTORY here:
cd "DIRECTORY"

*Table 2

*momhs is dummy for mom with HS degree
*mommarried is dummy for mom married
*white is dummy for white
*poor is dummy for poor
*trend, t2, and t3 are birth trends (linear, squared, and cubed)
*Q2 Q3 Q4 are dummies for birth quarters 2, 3, and 4


*************************************************************************************************************************
*Note--when assembling these files for replication, we discovered that Notre Dame had erased from its servers			*
*the original files and code for Table 2.  We consequently recreated the data and code. The redone coefficients and		*
*and standard errors are generally quite close to those in the paper, but the sample sizes in 1970 and 1980 are 		*
*different (3932376 in 1970, and 2766112 in 1980) 																		*
*************************************************************************************************************************

clear
use 1960.dta
foreach var in poor mommarried white  momhs {
	reg `var' Q2 Q3 Q4 trend t2 t3, robust 
	}
	
	
use 1970.dta
foreach var in poor mommarried white  momhs {
	reg `var' Q2 Q3 Q4 trend t2 t3, robust 
	}

use 1980.dta
foreach var in poor mommarried white  momhs {
	reg `var' Q2 Q3 Q4 trend t2 t3, robust 
	}

	
	
*Table 3
*mombirth is average mothers age at birth
*momteen is fraction moms giving birth as teens
*momwork is fraction moms working
*mommar is fraction moms married
*white is fraction white
*momed is average mom's education
*momdrop is fraction mothers without a high-school diploma
*poverty is average cell family income as a percentof the poverty line
*ed is years of schooling
*dropout is fraction dropouts
*logw is wages, logged

use Census_60_80_Table3 /*DH-note to self; originally this was from "C:\Winter_Births\cens_60_80_v4.dta"*/

global mom "mombirth momteen momed momdrop momwork mommar white poverty"

quietly reg ed Q2 Q3 Q4 Y* S* age age2 [weight = pop80] if female==0 & momed!=. & yearb<=1955, 
estimates store ed1
quietly reg  ed Q2 Q3 Q4 $mom Y* S* age age2 [weight = pop80] if female==0 & momed!=. & yearb<=1955, 
estimates store ed2
suest ed1 ed2, robust
test [ed1_mean = ed2_mean]: Q2 Q3 Q4


quietly reg dropout Q2 Q3 Q4 Y* S* age age2 [weight = pop80] if female==0 & momed!=. & yearb<=1955
estimates store d1
quietly reg dropout Q2 Q3 Q4 $mom Y* S* age age2 [weight = pop80] if female==0 & momed!=. & yearb<=1955
estimates store d2
suest d1 d2, robust
test [d1_mean = d2_mean]: Q2 Q3 Q4


quietly reg logw Q2 Q3 Q4 Y* S* age age2 [weight = workpop] if female==0 & momed!=. & yearb<=1955
estimates store lw1
quietly reg logw Q2 Q3 Q4 $mom Y* S* age age2 [weight = workpop] if female==0 & momed!=. & yearb<=1955
estimates store lw2
suest lw1 lw2, robust
test [lw1_mean = lw2_mean]: Q2 Q3 Q4


*Figure 2
use figure2.dta
*monthtrend, mt2, mt3 are trends for month of birth
*births_perday are total births per day in a month for a given fips
*fips are county fips codes
*lmarried_perday is log of total births to married moms, per day, in a given fips/month 
*lsingle_perday  is log of total births to single moms, per day, in a given fips/monrth
*birthmon is month of birth (1 = jan, 2 = feb, etc)

foreach var in   lmarried lsingle  {
	quietly reg `var'_perday monthtrend mt2 mt3
	predict e_`var' if e(sample), residual 
		}

table birthmon, c(mean e_lmarried mean e_lsingle)




*Table 4
*caseid is respondent id number
*y95 and y 1988 dummies for year
*married is a dummy for married
*t, tsq and tcu are linear, squared, and third order month trends
*maend is a march/april birth dummy
*mjend is a may/june birth dummy
*jaend is a july/august birth dummy
*soend is a september/october birth dummy
*ndend is a november/december birth dummy
*wanted is a dummy for a wanted birth
*wgttry is respondent weight
*want2maend is an interaction of want and maend, and similarly for other want2 variables
*unwant2maend is an interaction of a dummy for unwanted (want==0) and maend, and similarly for other unwant2 variables
*_Imonend_2 is a february birth dummy (march is _3, april is _4, etc)
*want2_Imonend_2 is an interaction of an unwanted dummy (want==0) and _Imonend_2, and similarly for other want2_ variables


use NSFG_Table4.dta

**Column 1
dprobit marr _Imon* t tsq tcu y88 y95 [pw=wgttry] if wanted!=., r cluster(caseid)

**Columns 2 & 3 (first regression is for LR test)
quietly dprobit marr _Imon* wanted t tsq tcu y88 y95 [pw=wgttry] if wanted!=., r cluster(caseid)
est store restricted
dprobit marr wanted want*I* unwant*I* t tsq tcu y88 y95 [pw=wgttry] if wanted!=., r cluster(caseid)
est store interact
lrtest interact restricted, force stat

**Column 4
dprobit marr maend-ndend t tsq tcu y88 y95 [pw=wgttry] if wanted!=., r cluster(caseid)

**Columns 5 and 6 (first regression is for LR test)
quietly dprobit marr maend-ndend wanted t tsq tcu y88 y95 [pw=wgttry] if wanted!=., r cluster(caseid)
est store restricted
dprobit marr wanted want2ma-want2nd unwant2ma-unwant2nd t tsq tcu y88 y95 [pw=wgttry] if wanted!=., r cluster(caseid)
est store interactX
lrtest interactX restricted, force stat




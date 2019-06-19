cd C:\DataFiles\Research-Papers\Immigration\Kato\REStatPublicFiles\Fig1
*Rename directory according to own folder name.
clear
set more off
capture log close
log using Issuances&Enrollment.log, text replace


set mem 500m
set matsize 3000

/*************************************************************************
Takao Kato & Chad Sparber
"Quotas and Quality: The Effect of H-1B Visa Restrictions 
   on the Pool of Prospective Undergraduate Students from Abroad"

Stata do-file for Figure 1: Visa Issuances & Undergraduate Enrollment
Issuances Data Source: US State Department, 
  http://www.travel.state.gov/visa/statistics/nivstats/nivstats_4582.html
  Nonimmigrant Visa Issuances by Visa Class and by Nationality
  NIV Detail Table for FY 2006
Undergraduate Enrollment Data Source: Institute of International Education,
  International Students by Academic Level and Place of Origin
  (Table 2) for 2001/02 Academic Year.
Population Data Source: World Bank World Development Indicators

*******************************************************************************/

clear
insheet using h1b&enroll.csv, comma
gen lnh = ln( h1b_fy06)
gen lne=ln( enrolled_01_02)
gen lnp=ln( pop_2002)

keep if  lnh!=. & lne!=. & lnp!=.
*drop Canada, since most Canadians meeting H-1B criteria don't get H-1B visas 
drop if iso3=="CAN"



*Do Regression
reg lnh lne lnp


*Save Residuals, necessary for Clean Scatterplot
predict temp, resid
gen clean = temp + _b[lne]*lne

#delimit ;
scatter clean lne, 
  ti("ln(H-1B Issuances) and ln(Undergraduate Enrollment)") 
  subtitle("Cleaned of Effects from ln(Population)")
  yti("ln(H-1B Issuances, Fiscal Year 2006)")
  xti("ln(Undergraduate Enrollment, Academic Year 2001/02)")
  mlab(iso3)
  msymbol(i)
  mlabsize(tiny)
  xscale(range(2 11))
;
#delimit cr
graph save h1b&enroll, replace














capture log close

exit

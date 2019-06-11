**********************************************************************
**********************************************************************
**Leaders, Tenure, and the Politics of Sovereign Credit by P. Shea and J. Solis
**Replication file for results in International Interaction article (Stata v15)

**(Results for appendix in separate file (II_leader_app.do))
*****************************************************************
**



cd "C:\Users\Shea\Dropbox\Assassination\Work\Data\Analysis\"
use "leadexp_082317.dta", clear
set more off

**Setting the panel data
xtset ccode year 

*Debt figure quoted on page one. 
sum debtGDP if year==2012

********************************************************************************************
****Table 1 Main Results
********************************************************************************************



**Note: F1.Y effectively lags all X's 1 year.  


*Model 1
xtreg F1.avg_sp lnten democracy2   growth gdp_pc lngdp  avg_sp yr_*  , fe 
estimates store ec2

*M2
xtreg F1.iirating lnten democracy2  growth gdp_pc lngdp  iirating yr_*   , fe 
estimates store ec3

*M3
xtreg F1.ratio2 lnten democracy2   growth gdp_pc lngdp  ratio2 yr_*  if year>=1980  , fe 
estimates store ec1

*M4
xtreg F1.ratio2 lnten democracy2  pdgdp lngdppc lngdp2  ratio2 yr_*  if year<1980  , fe 
estimates store ec12

*M5
xtreg F1.ratio2 lnten democracy2  pdgdp lngdppc lngdp2 ratio2 yr_* , fe 
estimates store ec13

**Table Output**
*ssc install estout
estout ec2 ec3 ec1 ec12 ec13 , cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) ///
	eqlab("/lnsig2u" "ln($\sigma^2_u$)", none) ///
	starlevels( * 0.05  ) ///
stats( r2 aic N N_g, fmt(%9.2f %9.0f) labels("R-Squared" "AIC" "N" "Countries"))  style(tex) ///
legend label collabels(none) rename(lngdp2  lngdp pdgdp growth lngdppc gdp_pc )  ///
varlabels(_cons Constant) order(lnten avg_sp iirating ratio2) drop( yr_*) ///
mlabels ("Model 1"  ) ///
title("")






*Checking multicollinearity (re: fotenote 13) in S&P model (Note that vif command does not
*work with xtreg, so we manually including dummies for countries and year, models using xtreg and reg with manual dummies are similar (see below)

reg F1.avg_sp lnten democracy2   growth gdp_pc lngdp  avg_sp i.ccode yr_*
estat vif

*GDP has huge VIF score, so we drop it from model (coefficient and SE's for lnten does not change substantially)

reg F1.avg_sp lnten democracy2   growth  gdp_pc  avg_sp i.ccode yr_*
estat vif

*GDP per cap still has huge VIF score, so we drop it from model (coefficient and SE's for lnten does not change substantially)

reg F1.avg_sp lnten democracy2   growth  avg_sp i.ccode yr_*
estat vif

**Does not appear the collinearity affects inference on lnten (while lagged DV has large VIF score, we keep it in 
* the model for theoretical reasons. The appenidix reports results with no LDVs.

**********
**For comparison sake, here is table 1, but using the reg command and manual country dummies

*Model 1
reg F1.avg_sp lnten democracy2   growth gdp_pc lngdp  avg_sp yr_* i.ccode
estimates store ec2

*M2
reg F1.iirating lnten democracy2  growth gdp_pc lngdp  iirating yr_* i.ccode
estimates store ec3

*M3
reg F1.ratio2 lnten democracy2   growth gdp_pc lngdp  ratio2 yr_* i.ccode if year>=1980
estimates store ec1

*M4
reg F1.ratio2 lnten democracy2  pdgdp lngdppc lngdp2  ratio2 yr_* i.ccode if year<1980
estimates store ec12

*M5
reg F1.ratio2 lnten democracy2  pdgdp lngdppc lngdp2 ratio2 yr_* i.ccode 
estimates store ec13

estout ec2 ec3 ec1 ec12 ec13 , cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) ///
	eqlab("/lnsig2u" "ln($\sigma^2_u$)", none) ///
	starlevels( * 0.05  ) ///
stats( r2 aic N N_g, fmt(%9.2f %9.0f) labels("R-Squared" "AIC" "N" "Countries"))  style(tex) ///
legend label collabels(none) rename(lngdp2  lngdp pdgdp growth lngdppc gdp_pc )  ///
varlabels(_cons Constant) order(lnten avg_sp iirating ratio2) drop( yr_* *.ccode) ///
mlabels ("Model 1"  ) ///
title("")



*************************************************************************************************************
***Figure 1
**************************************************************************************************************

use "leadexp_082317.dta", clear
set more off
xtset ccode year



reg F1.ratio2 lnten democracy2  growth gdp_pc lngdp inflation ratio2 i.year i.ccode if year>=1980

*mcp lnten, at1(0(0.1)10) ci


margins, at( lnten=(0(0.1)10) democracy2 = (1)) atmeans noatlegend
estimates store ame


marginsplot, recast(line) recastci(rarea) ytitle("Predicted Bond Yields") title("") ///
graphregion(fcolor(white)) 



use "leadexp_082317.dta", clear
set more off
xtset ccode year


reg F1.avg_sp lnten democracy2   growth gdp_pc lngdp inflation avg_sp  i.year i.ccode


margins, at( lnten=(0(0.1)10) democracy2 = (1)) atmeans noatlegend

marginsplot, recast(line) recastci(rarea) ytitle("Predicted S&P Rating") title("") ///
graphregion(fcolor(white)) 



use "leadexp_082317.dta", clear
set more off
xtset ccode year



reg F1.iirating lnten democracy2   growth gdp_pc lngdp inflation iirating  i.year i.ccode 

margins, at( lnten=(0(0.1)10) democracy2 = (1)) atmeans noatlegend

marginsplot, recast(line) recastci(rarea) ytitle("Predicted II Rating") title("") ///
graphregion(fcolor(white)) 




**********************************************************************************************
**Assassination Analysis
******************************************************************************************


use "leadexp_082317.dta", clear
set more off
xtset ccode year


*Creating lags and lead before merging assassination data
gen lratio2 = l.ratio2
gen dratio2 = d.ratio2
gen fratio2 = f.ratio2


merge 1:m ccode year using "assassin_all_100116.dta"
drop if _m==2
drop _m


**Because of multiple leaders in some years, we need to fix tenure measure for 3 leaders in the assassination sample

replace lnten = ln(129) if leadername=="Juan Lindolfo Cuestas" & ccode==165 & year ==1897
replace lnten = ln(244) if leadername=="Muzaffar ad-Din" & ccode==630 & year == 1896
replace lnten = ln(120) if leadername=="Benavidez" & ccode==135 & year ==1933

*Mean centering Tenure for interpretation convenience
sum lnten
gen lnten2 = lnten - r(mean) 

*Creating interation term
gen suc_ten = success*lnten2


****************************
**Table 2
***************************

*Model 1
reg ratio2 success lnten2 suc_ten weapondum* lratio2,  cluster(ccode)
estimates store m1



*Prep for Model 2 (selection model)
replace attempt = 0 if attempt==. 


*Creating time splines (see https://www.prio.org/Data/Stata-Tools/ for btscs package). 
btscs attempt year ccode, g(ayrs)
gen a2 = ayrs*ayrs
gen a3 = ayrs*ayrs*ayrs

*First stage (reported in appendix)
probit attempt lnten2 democracy2 lngdp2 pdgdp lngdppc ayrs a2 a3

*Generate linear predictions
predict p2, xb

*Deriving mills inverse

gen mills2 = exp(-.5*p2^2)/(sqrt(2*_pi)*normprob(p2))

*Model 2 (Outcome stage of selection model)
reg ratio2 success lnten2 suc_ten  weapondum* lratio2 mills2,  cluster(ccode)
estimates store m2

*Model 3 (additional controls in outcome stage
reg ratio2 success lnten2 suc_ten l.democracy2 l.lngdp2 l.pdgdp l.lngdppc   weapondum* lratio2 mills2,  cluster(ccode)
estimates store m3

lab var mills2 "Mill's Ratio"
lab var pdgdp "Growth"
lab var lngdp2 "GDP"
lab var lngdppc  "GDP per cap"
lab var lnten2 "Leader Tenure"
lab var rdefault "Default"
lab var lratio "Bond Yield $_{t-1}$"
lab var democracy2 "Democracy"

lab var suc_ten "Success*Tenure"


*Table output
estout m1 m2 m3, cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) ///
	eqlab("/lnsig2u" "ln($\sigma^2_u$)", none) ///
	starlevels( * 0.05  ) ///
stats( r2 aic N, fmt(%9.2f %9.0f) labels("R-Squared" "AIC" "N"))  style(tex) ///
legend label collabels(none) varlabels(_cons Constant) order(success lnten2 suc_ten) drop(mills2 weapondum*) ///
mlabels ("Model 1"  ) ///
title("") 


*********************************************
***Figure 2
*********************************************




capture drop b2 b3 
capture drop suc_ten
gen suc_ten = success*lnten

reg ratio2 success lnten suc_ten  weapondum* lratio2 mills2,  cluster(ccode)
keep if e(sample)
matrix b=e(b)
matrix V=e(V)

scalar b1=b[1,1]
scalar b3=b[1,3]

scalar list b1 b3

gen b11 = b1
gen b33 = b3


scalar varb1=V[1,1]
scalar varb3=V[3,3]

scalar covb1b3=V[1,3]

scalar list b1 b3 varb1 varb3 covb1b3



capture drop MVZ
generate MVZ=((_n-1)/10)
replace MVZ=. if MVZ>10.12
gen conbx=b11+(b33*MVZ) if MVZ<=10.12
gen consx=sqrt(varb1+varb3*(MVZ^2)+2*covb1b3*MVZ) if MVZ<10.12
gen ax=1.96*consx
gen upperx=conbx+ax
gen lowerx=conbx-ax

gen yline=0

graph twoway (rarea upperx lowerx  MVZ)  ///
(line conbx  MVZ, clcolor(black)), ///
ytitle(Marginal Effect of Assassination Success) ///
xtitle("Leader Tenure") ///
graphregion(fcolor(white)) ///
legend(label(1 "95% Confidence Int") label(2 "Marginal Effect") order(1 2))


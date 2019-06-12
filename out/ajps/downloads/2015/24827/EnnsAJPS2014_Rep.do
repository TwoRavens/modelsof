**The following code replicates the analyses reported in:
**Enns, Peter K. 2014. ``The Public's Increasing Punitiveness and Its Influence on Mass Incarceration in the United States.'' \emph{American Journal of Political Science}.
**Stata Replication Data: Enns_AJPS2014rep.dta



pause on
***********************************
**Time Series Properties of DV
***********************************

**Incarceration Rate
dfuller d.incarrate, lags(1) reg
reg  d2.incarrate ld.incarrate ld2.incarrate
predict resdf, r
**dfuller assumes no autocorrelation
wntestq resdf
drop resdf

**************************
**Test of Cointegration
**************************

reg  d.incarrate punitiveness crimerate drugmortrate inequality

predict rescoint, r
dfuller rescoint
drop rescoint 

************************
**Correlation between rate of new federal setences and the public's support for being tough on crime
************************

cor  d.incarrate punitiveness 

*************************
**TABLE 1:
*************************

*Column 1:
reg  d2.incarrate ld.incarrate d.punitiveness l.punitiveness
predict res, r
wntestq res
drop res

*LRM
ivreg d.incarrate d.punitiveness punitiveness (d2.incarrate = ld.incarrate punitiveness l.punitiveness)

*Column 2:
reg  d2.incarrate ld.incarrate d.punitiveness l.punitiveness d.crimerate l.crimerate d.drugmortrate l.drugmortrate  d.inequality l.inequality
predict res, r
wntestq res
drop res

*LRM
ivreg d.incarrate d.punitiveness punitiveness d.crimerate crimerate d.drugmortrate drugmortrate d.inequality inequality (d2.incarrate = ld.incarrate punitiveness l.punitiveness crimerate l.crimerate drugmortrate l.drugmortrate inequality l.inequality)

*Column 3:
reg  d2.incarrate ld.incarrate d.punitiveness l.punitiveness d.crimerate l.crimerate d.drugmortrate l.drugmortrate  d.inequality l.inequality l.repstrength
predict res, r
wntestq res
drop res

*type q to continue
pause
****************************************
*LRM: See, e.g., Equation 9 in DeBoef and Keele 2008
****************************************

******************************
**Generate lagged variable for each predictor w/ long run effect
******************************
foreach x in punitiveness crimerate drugmortrate inequality repstrength {
gen l_`x' = l.`x'
}
gen ld_incarrate = ld.incarrate
*************

**Must include lagged values before differenced values, so correct elements of the vce are called
reg  d2.incarrate ld_incarrate l_punitiveness l_crimerate l_drugmortrate l_inequality l_repstrength d.punitiveness d.crimerate d.drugmortrate d.inequality 
matrix vcov =e(V)

*Generate datafile to save results:
tempname pfile
tempfile lrm_tab1col3_rep
postfile `pfile' str20(variable) lrm se_lrm t using "`lrm_tab1col3_rep'"

*gen local variable of value 1
local i = 1
*loop over variables for which we will calculate a long term effect
foreach x in l_punitiveness l_crimerate l_drugmortrate l_inequality l_repstrength {
*include a counter for the number of long term effects to be calculated (i.e., "foreach i in 1/3 {" indicates 3 long term effects

sum `x' if e(sample)
local lrm = _b[`x']/abs(_b[ld_incarrate])
local selrm = sqrt(((1/(_b[ld_incarrate]^2))*(_se[`x']^2))+((_b[`x']^2)/(_b[ld_incarrate]^4)*(_se[ld_incarrate]^2))-(2*(_b[`x']/(_b[ld_incarrate]^3))*(vcov[(`i'+1),1])))
*add 1 to i each loop, so appropriate element of vcov is identified.
local i = `i' + 1
post `pfile'  ("`x'") (`lrm') (`selrm') (`lrm'/`selrm') 
}

drop l_punitiveness l_crimerate l_drugmortrate l_inequality l_repstrength ld_incarrate 
postclose `pfile'
use "`lrm_tab1col3_rep'", clear
list variable lrm se_lrm t
********************************************
********************************************
********************************************
*type q to continue
*use "Enns_AJPS2014rep.dta", clear
pause

*************************************************************
**test joint significance of short term effects
reg  d2.incarrate ld.incarrate d.punitiveness l.punitiveness d.crimerate l.crimerate d.drugmortrate l.drugmortrate  d.inequality l.inequality l.repstrength
test d.punitiveness d.crimerate d.drugmortrate d.inequality 

**Column 4 (no short term effects)
reg  d2.incarrate ld.incarrate l.punitiveness l.crimerate l.drugmortrate  l.inequality l.repstrength


*type q to continue
pause
****************************************
*LRM: See, e.g., Equation 9 in DeBoef and Keele 2008
****************************************

******************************
**Generate lagged variable for each predictor w/ long run effect
******************************
foreach x in punitiveness crimerate drugmortrate inequality repstrength {
gen l_`x' = l.`x'
}
gen ld_incarrate = ld.incarrate
*************

**Must include lagged values before differenced values, so correct elements of the vce are called
reg  d2.incarrate ld_incarrate l_punitiveness l_crimerate l_drugmortrate l_inequality l_repstrength
matrix vcov =e(V)

*Generate datafile to save results:
tempname pfile
tempfile lrm_tab1col4_rep
postfile `pfile' str20(variable) lrm se_lrm t using "`lrm_tab1col4_rep'"

*gen local variable of value 1
local i = 1
*loop over variables for which we will calculate a long term effect
foreach x in l_punitiveness l_crimerate l_drugmortrate l_inequality l_repstrength {
*include a counter for the number of long term effects to be calculated (i.e., "foreach i in 1/3 {" indicates 3 long term effects

sum `x' if e(sample)
local lrm = _b[`x']/abs(_b[ld_incarrate])
local selrm = sqrt(((1/(_b[ld_incarrate]^2))*(_se[`x']^2))+((_b[`x']^2)/(_b[ld_incarrate]^4)*(_se[ld_incarrate]^2))-(2*(_b[`x']/(_b[ld_incarrate]^3))*(vcov[(`i'+1),1])))
*add 1 to i each loop, so appropriate element of vcov is identified.
local i = `i' + 1
post `pfile'  ("`x'") (`lrm') (`selrm') (`lrm'/`selrm') 
}

drop l_punitiveness l_crimerate l_drugmortrate l_inequality l_repstrength ld_incarrate 
postclose `pfile'
use "`lrm_tab1col4_rep'", clear
list variable lrm se_lrm t
********************************************************************
********************************************************************
********************************************************************

*type q to continue
*use "Enns_AJPS2014rep.dta", clear
pause

****************************
**Various specifications of Republican Strength variable reported in footnote
****************************

*Model 3, lagging Republican strength an additional year.
reg  d2.incarrate ld.incarrate d.punitiveness l.punitiveness d.crimerate l.crimerate d.drugmortrate l.drugmortrate  d.inequality l.inequality l2.repstrength
*Model 3 including differenced Republican strength
reg  d2.incarrate ld.incarrate d.punitiveness l.punitiveness d.crimerate l.crimerate d.drugmortrate l.drugmortrate  d.inequality l.inequality d.repstrength l.repstrength


****************************
****TABLE 2: Granger Test
****************************

var punitiveness conghear_crime d.incarrate rephmaj repsenmaj, exog(l.crimerate l.drugmortrate l.inequality) lags(1/2)
vargranger

****Bivariate VAR Analysis
var punitiveness conghear_crime, lags(1/2)
vargranger


***************
*** TABLE 2 ***
***************

*The data for Table 2 comes from Markus Brückner and Antonio Ciccone (2011): "Rain and the Democratic Window of Opportunity," Econometrica 79(3), 923-947. Their replication data and code is available at http://www.econometricsociety.org/suppmat.asp?id=306&vid=79&iid=3&aid=8 [Data and Programs - View the file (zip file format)]. 


***Dependent Variable: Change in Polity Scores

**Preparing the data and 2SLS results (the code in this subsection is taken straight from the do-file kindly provided by Markus Brückner and Antonio Ciccone together with their replication data): 

clear all
set mem 2000m
use database.dta, clear

tsset ccode year

*generate country fixed effects*
tab ccode, gen(Iccode)

*generate country time trend*
local i=1
while (`i'< 41){
quietly gen Iccyear`i' = Iccode`i'*year
label variable Iccyear`i' "Country-Specific Time Trend for Iccode`i'"
local i = `i' + 1
}

*generate time fixed effects*
tab year, gen(time)

*2SLS regression and Anderson-Rubin Wald test
ivreg2 polity_change Iccode* Iccyear* time* ( lgdp_l2 =  lgpcp_l2 ), cluster(ccode) partial(Iccode* Iccyear* time*) ffirst


**HL estimates

*restrict to identical sample
gen sample = 1 if e(sample) == 1
drop if sample != 1

*partial out fixed effects
reg polity_change Iccode* Iccyear* time*
predict res_polity, res
replace polity_change = res_polity
reg lgdp_l2 Iccode* Iccyear* time*
predict res_gdp, res
replace lgdp_l2 = res_gdp
reg lgpcp_l2 Iccode* Iccyear* time*
predict res_rain, res
replace lgpcp_l2 = res_rain

*HL estimate
HL_spcorr_p polity_change lgdp_l2 lgpcp_l2, lower(-30) upper(2) tolerance(0.0001)



***Dependent Variable: Change in Executive Constraints

**Preparing the data and 2SLS results (the code in this subsection is taken straight from the do-file kindly provided by Markus Brückner and Antonio Ciccone together with their replication data): 

clear all
set mem 2000m
use database.dta, clear

tsset ccode year

*generate country fixed effects*
tab ccode, gen(Iccode)

*generate country time trend*
local i=1
while (`i'< 41){
quietly gen Iccyear`i' = Iccode`i'*year
label variable Iccyear`i' "Country-Specific Time Trend for Iccode`i'"
local i = `i' + 1
}

*generate time fixed effects*
tab year, gen(time)

*2SLS regression and Anderson-Rubin Wald test
ivreg2 exconst_change Iccode* Iccyear* time* ( lgdp_l2 =  lgpcp_l2 ), cluster(ccode) partial(Iccode* Iccyear* time*) ffirst


**HL estimates

*restrict to identical sample
gen sample = 1 if e(sample) == 1
drop if sample != 1

*partial out fixed effects
reg exconst_change Iccode* Iccyear* time*
predict res_exconst, res
replace exconst_change = res_exconst
reg lgdp_l2 Iccode* Iccyear* time*
predict res_gdp, res
replace lgdp_l2 = res_gdp
reg lgpcp_l2 Iccode* Iccyear* time*
predict res_rain, res
replace lgpcp_l2 = res_rain

*HL estimate
HL_spcorr_p exconst_change lgdp_l2 lgpcp_l2, lower(-15) upper(4) tolerance(0.0001)



***Dependent Variable: Change in Political Competition

**Preparing the data and 2SLS results (the code in this subsection is taken straight from the do-file kindly provided by Markus Brückner and Antonio Ciccone together with their replication data): 

clear all
set mem 2000m
use database.dta, clear

tsset ccode year

*generate country fixed effects*
tab ccode, gen(Iccode)

*generate country time trend*
local i=1
while (`i'< 41){
quietly gen Iccyear`i' = Iccode`i'*year
label variable Iccyear`i' "Country-Specific Time Trend for Iccode`i'"
local i = `i' + 1
}

*generate time fixed effects*
tab year, gen(time)

*2SLS regression and Anderson-Rubin Wald test
ivreg2 polcomp_change Iccode* Iccyear* time* ( lgdp_l2 =  lgpcp_l2 ), cluster(ccode) partial(Iccode* Iccyear* time*) ffirst


**HL estimates

*restrict to identical sample
gen sample = 1 if e(sample) == 1
drop if sample != 1

*partial out fixed effects
reg polcomp_change Iccode* Iccyear* time*
predict res_polcomp, res
replace polcomp_change = res_polcomp
reg lgdp_l2 Iccode* Iccyear* time*
predict res_gdp, res
replace lgdp_l2 = res_gdp
reg lgpcp_l2 Iccode* Iccyear* time*
predict res_rain, res
replace lgpcp_l2 = res_rain

*HL estimate
HL_spcorr_p polcomp_change lgdp_l2 lgpcp_l2, lower(-20) upper(5) tolerance(0.0001)



***Dependent Variable: Change in Executive Recruitment

**Preparing the data and 2SLS results (the code in this subsection is taken straight from the do-file kindly provided by Markus Brückner and Antonio Ciccone together with their replication data): 

clear all
set mem 2000m
use database.dta, clear

tsset ccode year

*generate country fixed effects*
tab ccode, gen(Iccode)

*generate country time trend*
local i=1
while (`i'< 41){
quietly gen Iccyear`i' = Iccode`i'*year
label variable Iccyear`i' "Country-Specific Time Trend for Iccode`i'"
local i = `i' + 1
}

*generate time fixed effects*
tab year, gen(time)

*2SLS regression and Anderson-Rubin Wald test
ivreg2 exrec_change Iccode* Iccyear* time* ( lgdp_l2 =  lgpcp_l2 ), cluster(ccode) partial(Iccode* Iccyear* time*) ffirst


**HL estimates

*restrict to identical sample
gen sample = 1 if e(sample) == 1
drop if sample != 1

*partial out fixed effects
reg exrec_change Iccode* Iccyear* time*
predict res_exrec, res
replace exrec_change = res_exrec
reg lgdp_l2 Iccode* Iccyear* time*
predict res_gdp, res
replace lgdp_l2 = res_gdp
reg lgpcp_l2 Iccode* Iccyear* time*
predict res_rain, res
replace lgpcp_l2 = res_rain

*HL estimate
HL_spcorr_p exrec_change lgdp_l2 lgpcp_l2, lower(-13) upper(2) tolerance(0.0001)

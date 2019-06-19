**********************************************
* Johannes Rincke, Christian Traxler 
* "Enforcement Spillovers"
* Review of Economics and Statistics
*
* Date: 2010-04-29
*
**********************************************

cap clear
cap log close
cap clear matrix
set memory 500m
set matsize 800
set more off


cd "<plug in path to main directory here>"

use "Rincke_Traxler.dta"


************************
* First-stage
************************

*** See Table 3 in the paper

xtivreg2 registrations mobility T2-T5 (enforce=snow snow_altitude accidents) if outlets>0 & hh>=500 & geo_accuracy==0, fe i(gid) first robust cluster(gid)


************************
* Baseline estimations
************************

*** See Table 4 in the paper

xtreg registrations enforce mobility T2-T5  if outlets>0 & hh>=500 & geo_accuracy==0, fe i(gid) robust cluster(gid)
xtivreg2 registrations mobility T2-T5 (enforce=snow snow_altitude accidents) if outlets>0 & hh>=500 & geo_accuracy==0, fe i(gid) robust cluster(gid)


************************
* Refined estimations
************************

*** See Table 5 in the paper

xtivreg2 hc_registrations mobility T2-T5 (enforce=snow snow_altitude accidents) if hh>=500 & outlets>0 & geo_accuracy==0, fe i(gid) robust cluster(gid)
xtivreg2 hc_registrations mobility T2-T5 (enforce=snow snow_altitude accidents) if hh>=500 & hh<1000 & geo_accuracy==0, fe i(gid) robust cluster(gid)
xtivreg2 hc_registrations mobility T2-T5 (enforce=snow snow_altitude accidents) if hh>=500 & hh<1000 & same_house==1 & geo_accuracy==0, fe i(gid) robust cluster(gid)
xtivreg2 hc_registrations mobility T2-T5 (enforce=snow snow_altitude accidents) if hh>=500 & hh<1000 & same_house==1 & circle_50m==1 & geo_accuracy==0, fe i(gid) robust cluster(gid)



***********************
* APPENDIX
***********************


*** Appendix, Table 7 - Reduced form estimation for municipalities with zero enforcement

* indicator for municipalities witz zero enforcement
gen zero_enforce=0
label var zero_enforce    "indicator for municipalities without any enforcement in sample period"
local i=1
while `i'<=2380 {
 quietly: sum enforce if gid==`i'
 quietly: replace zero_enforce=1 if gid==`i' & r(sum)==0
 local i=`i'+1
}

* reduced form estimations on sample of municipalities with zero enforcement
xtreg registrations snow snow_altitude accidents mobility T2-T5 if outlets>0 & hh>=500 & geo_accuracy==0 & zero_enforce==1, fe i(gid) robust cluster(gid)
xtreg hc_registrations snow snow_altitude accidents mobility T2-T5 if outlets>0 & hh>=500 & geo_accuracy==0 & zero_enforce==1, fe i(gid) robust cluster(gid)



*** Appendix, Table 6 - Share of hard-copy form registrations 

*Note: instrument variables were rescaled for representation of first-stage regression (see note to Table 3 in the paper)
replace snow=snow*1000
replace snow_altitude=snow_altitude*1000
replace accidents=accidents*1000

gen hc_reg_share=hc_registrations/registrations
label var hc_reg_share     "share of hard-copy registrations"

xtreg hc_reg_share snow T2-T5 if hh>=500 & outlets>0 & geo_accuracy==0, fe i(gid) robust cluster(gid)
xtreg hc_reg_share snow snow_altitude T2-T5 if outlets>0 & hh>=500 & geo_accuracy==0, fe i(gid) robust cluster(gid)
xtreg hc_reg_share snow accidents T2-T5 if hh>=500 & outlets>0 & geo_accuracy==0, fe i(gid) robust cluster(gid)
xtreg hc_reg_share accidents T2-T5 if hh>=500 & outlets>0 & geo_accuracy==0, fe i(gid) robust cluster(gid)
xtreg hc_reg_share snow snow_altitude accidents T2-T5 if outlets>0 & hh>=500 & geo_accuracy==0, fe i(gid) robust cluster(gid)

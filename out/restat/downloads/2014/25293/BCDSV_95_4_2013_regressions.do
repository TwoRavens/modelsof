clear mata
clear matrix
clear
capture log close
program drop _all
macro drop _all
version 10.0
set mem 500m
set mat 2000
set more off

*here set your directory
cd "D:\BCDVS_95_4_2013\codes"

log using "BCDVS_95_4_2013regressions.log", replace
use "BCDVS_95_4_2013_estimation_data.dta", clear
xtset identif year


******************************************************************************
*******************  PRELIMINARY STATISTICS (table1)    **********************
*****************************************************************************

* we run the main regression to fix the sample size
reg tfpcorrectedoverklems tfpleadershipklems l.tecnogapklems ind_trend l.tradelib l.pmr l.compindex y_* dummy* if tfpcorrectedoverklems>-0.282 & tfpcorrectedoverklems<0.281 &   pcmpoolklems>0.5 & pcmpoolklems<3, cl(country)
estpost summarize tfpcorrectedoverklems tfpleadershipklems tecnogapklems rdklems3 HHS tradelib pmr compindex CPIequalw inst enf antitrust mergers enfocontrcost ruleoflaw _2 per403 per404 per505 if e(sample)
esttab . using BCDVS_95_4_2013tables, cells("mean sd min max") replace nonumbers label width(0.8\hsize) csv

reg LPgrowth labourproductivityleaderklems l.tecnogapklemsLP ind_trend l.tradelib l.pmr l.compindex y_* dummy* if LPgrowth>-0.282 & LPgrowth<0.281 &   pcmpoolklems>0.5 & pcmpoolklems<3, cl(country)
estpost summarize LPgrowth labourproductivityleaderklems tecnogapklemsLP if e(sample)
esttab . using BCDVS_95_4_2013tables, cells("mean sd min max") append nonumbers label width(0.8\hsize) csv



******************************************************************************
*******************  BASIC OLS REGRESSIONS  (table2)    **********************
******************************************************************************

*simple
gen samp=0
reg tfpcorrectedoverklems l.compindex y_* dummy* if tfpcorrectedoverklems>-0.282 & tfpcorrectedoverklems<0.281 &   pcmpoolklems>0.5 & pcmpoolklems<3, cl(country)
eststo table2_1
replace samp=1 if e(sample)
reg tfpcorrectedoverklems l.CPIequalw y_* dummy* if tfpcorrectedoverklems>-0.282 & tfpcorrectedoverklems<0.281 &   pcmpoolklems>0.5 & pcmpoolklems<3, cl(country)
eststo table2_2
reg LPgrowth  l.compindex y_* dummy* if LPgrowth>-0.282 & LPgrowth<0.281 &   pcmpoolklems>0.5 & pcmpoolklems<3, cl(country)
eststo table2_3

*with controls
reg tfpcorrectedoverklems tfpleadershipklems l.tecnogapklems ind_trend l.tradelib l.pmr l.compindex y_* dummy* if tfpcorrectedoverklems>-0.282 & tfpcorrectedoverklems<0.281 &   pcmpoolklems>0.5 & pcmpoolklems<3, cl(country)
eststo table2_4
reg tfpcorrectedoverklems tfpleadershipklems l.tecnogapklems ind_trend l.tradelib l.pmr l.CPIequalw y_* dummy* if tfpcorrectedoverklems>-0.282 & tfpcorrectedoverklems<0.281 &   pcmpoolklems>0.5 & pcmpoolklems<3, cl(country)
eststo table2_5
reg LPgrowth labourproductivityleaderklems l.tecnogapklemsLP ind_trend l.tradelib l.pmr l.compindex y_* dummy* if LPgrowth>-0.282 & LPgrowth<0.281 &   pcmpoolklems>0.5 & pcmpoolklems<3, cl(country)
eststo table2_6

esttab table2_1 table2_2 table2_3 table2_4 table2_5 table2_6 using "BCDVS_95_4_2013tables.csv", append label  nodepvar star(* 0.10 ** 0.05 *** 0.01) se r2 drop(y_* dummy*) compress csv

******************************************************************************
***************     OLS regressions with sub-indexes (table 3)    ************
******************************************************************************

reg tfpcorrectedoverklems tfpleadershipklems l.tecnogapklems ind_trend l.tradelib l.pmr l.inst y_* dummy* if tfpcorrectedoverklems>-0.282 & tfpcorrectedoverklems<0.281 &   pcmpoolklems>0.5 & pcmpoolklems<3 & l.compindex!=., cl(country)
eststo table3_1
reg tfpcorrectedoverklems tfpleadershipklems l.tecnogapklems ind_trend l.tradelib l.pmr l.enf y_* dummy* if tfpcorrectedoverklems>-0.282 & tfpcorrectedoverklems<0.281 &   pcmpoolklems>0.5 & pcmpoolklems<3, cl(country)
eststo table3_2
reg tfpcorrectedoverklems tfpleadershipklems l.tecnogapklems ind_trend l.tradelib l.pmr l.antitrust y_* dummy* if tfpcorrectedoverklems>-0.282 & tfpcorrectedoverklems<0.281 &   pcmpoolklems>0.5 & pcmpoolklems<3, cl(country)
eststo table3_3
reg tfpcorrectedoverklems tfpleadershipklems l.tecnogapklems ind_trend l.tradelib l.pmr l.mergers y_* dummy* if tfpcorrectedoverklems>-0.282 & tfpcorrectedoverklems<0.281 &   pcmpoolklems>0.5 & pcmpoolklems<3, cl(country)
eststo table3_4

esttab table3_1 table3_2 table3_3 table3_4 using "BCDVS_95_4_2013tables.csv", append label  nodepvar star(* 0.10 ** 0.05 *** 0.01) se r2 drop(y_* dummy*) compress csv


******************************************************************************
*******************          IV regressions (table 4)            *************
*******************     poltical variables as instruments        *************
******************************************************************************


ivreg2 tfpcorrectedoverklems tfpleadershipklems l.tecnogapklems ind_trend l.tradelib l.pmr  y_*  dummy*  ( l.compindex = l.per108 l.per403 l.per404 l.per505)  if tfpcorrectedoverklems>-0.282 & tfpcorrectedoverklems<0.281 &   pcmpoolklems>0.5 & pcmpoolklems<3, first
*ivendog
eststo table4_1
gen sample4_1=1 if e(sample)
ivreg2 tfpcorrectedoverklems tfpleadershipklems l.tecnogapklems ind_trend l.tradelib  y_*  dummy*  ( l.compindex l.pmr= l.per108  l.per403  l.per404 l.per505)  if tfpcorrectedoverklems>-0.282 & tfpcorrectedoverklems<0.281 &   pcmpoolklems>0.5 & pcmpoolklems<3, first
*ivendog
eststo table4_2
ivreg2 tfpcorrectedoverklems tfpleadershipklems l.tecnogapklems ind_trend l.tradelib l.pmr  y_*  dummy*  ( l.CPIequal = l.per108 l.per403 l.per404 l.per505)  if tfpcorrectedoverklems>-0.282 & tfpcorrectedoverklems<0.281 &   pcmpoolklems>0.5 & pcmpoolklems<3, first
*ivendog
eststo table4_3
ivreg2 tfpcorrectedoverklems tfpleadershipklems l.tecnogapklems ind_trend l.tradelib  y_*  dummy*  ( l.CPIequal l.pmr= l.per108  l.per403  l.per404 l.per505)  if tfpcorrectedoverklems>-0.282 & tfpcorrectedoverklems<0.281 &   pcmpoolklems>0.5 & pcmpoolklems<3, first
*ivendog
eststo table4_4
ivreg2 LPgrowth labourproductivityleaderklems l.tecnogapklemsLP ind_trend l.tradelib l.pmr  y_*  dummy*  ( l.compindex = l.per108 l.per403 l.per404 l.per505)  if LPgrowth>-0.282 & LPgrowth<0.281 &   pcmpoolklems>0.5 & pcmpoolklems<3, first
*ivendog
eststo table4_5
gen sample4_5=1 if e(sample)
ivreg2 LPgrowth labourproductivityleaderklems l.tecnogapklemsLP ind_trend l.tradelib y_*  dummy*  ( l.compindex l.pmr= l.per108  l.per403  l.per404 l.per505)  if LPgrowth>-0.282 & LPgrowth<0.281 &   pcmpoolklems>0.5 & pcmpoolklems<3, first
*ivendog
eststo table4_6

esttab table4_1 table4_2 table4_3 table4_4 table4_5 table4_6 using  "BCDVS_95_4_2013tables.csv", append label  nodepvar star(* 0.10 ** 0.05 *** 0.01) se  drop(y_* dummy*) compress csv


******************************************************************************
*******************   FIRST STAGE regressions (table 5)          *************
******************************************************************************

** FIRST STAGE (table 5)

reg compindex tfpleadershipklems l.tecnogapklems ind_trend l.tradelib l.pmr l.per108 l.per403 l.per404 l.per505 y_* dummy*  if sample4_1==1
eststo table5_1
reg compindex tfpleadershipklems l.tecnogapklems ind_trend l.tradelib l.per108 l.per403 l.per404 l.per505 y_*  dummy*  if sample4_1==1
eststo table5_2
*reg pmr tfpleadershipklems l.tecnogapklems ind_trend l.tradelib l.per108 l.per403 l.per404 l.per505 y_*  dummy*  if tfpcorrectedoverklems>-0.282 & tfpcorrectedoverklems<0.281 &   pcmpoolklems>0.5 & pcmpoolklems<3 & samp!=.
*eststo table5_3 (this is identical to 5_6)
reg CPIequalw tfpleadershipklems l.tecnogapklems ind_trend l.tradelib l.pmr l.per108 l.per403 l.per404 l.per505 y_*  dummy*  if sample4_1==1
eststo table5_4
reg CPIequalw tfpleadershipklems l.tecnogapklems ind_trend l.tradelib l.per108 l.per403 l.per404 l.per505 y_*  dummy*  if sample4_1==1
eststo table5_5
reg pmr tfpleadershipklems l.tecnogapklems ind_trend l.tradelib l.per108 l.per403 l.per404 l.per505 y_*  dummy*  if sample4_1==1
eststo table5_6
reg compindex labourproductivityleaderklems l.tecnogapklemsLP  ind_trend l.tradelib l.pmr l.per108 l.per403 l.per404 l.per505 y_*  dummy* if sample4_5==1
eststo table5_7
reg compindex labourproductivityleaderklems l.tecnogapklemsLP  ind_trend l.tradelib l.per108 l.per403 l.per404 l.per505 y_*  dummy* if sample4_5==1
eststo table5_8
reg pmr labourproductivityleaderklems l.tecnogapklemsLP ind_trend l.tradelib l.per108 l.per403 l.per404 l.per505  y_*  dummy*  if sample4_5==1
eststo table5_9

esttab table5_1 table5_2 table5_4 table5_5 table5_6 table5_7 table5_8 table5_9 using  "BCDVS_95_4_2013tables.csv", append label  nodepvar star(* 0.10 ** 0.05 *** 0.01) se  drop(y_* dummy*) compress csv



*************************************************************************************
*******************      Interactions Regressions (table 6)     **********************
*************************************************************************************


****************************************************************
*******************      LEGAL ORIGIN     **********************
****************************************************************


gen lo_eng=0
replace lo_eng=1 if iso_code=="Can" | iso_code=="UK" | iso_code=="USA"

gen lo_ger=0
replace lo_ger=1 if iso_code=="Cze" | iso_code=="Ger" | iso_code=="Hun" | iso_code=="Jap" 

gen lo_fr=0
replace lo_fr=1 if iso_code=="Fra" | iso_code=="Ita" | iso_code=="Net" | iso_code=="Spa" 

gen lo_nor=0
replace lo_nor=1 if iso_code=="Swe"

label var lo_eng "English legal origin"
label var lo_ger "German legal origin"
label var lo_fr  "French legal origin"
label var lo_nor "Nordic legal origin"


gen CPI_LOe=compindex*lo_eng
gen CPI_LOg=compindex*lo_ger
gen CPI_LOf=compindex*lo_fr
gen CPI_LOn=compindex*lo_nor


label var CPI_LOe "CPI aggregate LE English"
label var CPI_LOg "CPI aggregate LE German"
label var CPI_LOf "CPI aggregate LE French"
label var CPI_LOn "CPI aggregate LE Nordic"


reg tfpcorrectedoverklems tfpleadershipklems l.tecnogapklems ind_trend l.pmr l.tradelib l.CPI_LOe l.CPI_LOg l.CPI_LOf l.CPI_LOn lo_en lo_fr lo_nor y_* ind* if tfpcorrectedoverklems>-0.282 & tfpcorrectedoverklems<0.281 &   pcmpoolklems>0.5 & pcmpoolklems<3, cl(country)
eststo table6_lo_int

test l.CPI_LOe=l.CPI_LOg
test l.CPI_LOe=l.CPI_LOf
test l.CPI_LOe=l.CPI_LOn
test l.CPI_LOg=l.CPI_LOf
test l.CPI_LOg=l.CPI_LOn
test l.CPI_LOf=l.CPI_LOn



**************************************************************************
*******************   ENFORCEMENT of CONTRACTS (cost)  *******************
**************************************************************************

* enfocontr is not time varying, hence is not identified in the within-panel regression
* however we can use the dummy least square regression

label var enfocontrcost "Enforcement Cost"

gen low_enfc=0
replace low_enfc=1 if enfocontrcost<=16.2
replace low_enfc=. if enfocontrcost==.

gen mid_enfc=0
replace mid_enfc=1 if enfocontrcost<=22.7 & enfocontrcost>16.2
replace mid_enfc=. if enfocontrcost==.

gen high_enfc=0
replace high_enfc=1 if enfocontrcost>22.7
replace high_enfc=. if enfocontrcost==.


gen CPI_lec=compindex*low_enfc
gen CPI_mec=compindex*mid_enfc
gen CPI_hec=compindex*high_enfc

reg tfpcorrectedoverklems tfpleadershipklems l.tecnogapklems ind_trend l.pmr l.tradelib l.CPI_lec l.CPI_mec l.CPI_hec enfocontrcost y_* dummy* if tfpcorrectedoverklems>-0.282 & tfpcorrectedoverklems<0.281, cl(country)
eststo table6_enfc_int
* correct nobs

test l.CPI_lec=l.CPI_mec
test l.CPI_lec=l.CPI_hec 
test l.CPI_mec=l.CPI_hec 


****************************************************************
*******************      RULE OF LAW      **********************
****************************************************************

label var ruleoflaw "Rule of law"

egen l_rule2=pctile(rule), p(34) 
egen h_rule2=pctile(rule), p(67) 

gen low_ruleoflaw=0
replace low_ruleoflaw=1 if ruleoflaw<l_rule
gen mid_ruleoflaw=0
replace mid_ruleoflaw=1 if ruleoflaw>=l_rule &  ruleoflaw<h_rule
gen high_ruleoflaw=0
replace high_ruleoflaw=1 if ruleoflaw>=h_rule


gen CPI_lrl=compindex*high_rule
gen CPI_mrl=compindex*mid_rule
gen CPI_hrl=compindex*low_rule

reg tfpcorrectedoverklems tfpleadershipklems l.tecnogapklems ind_trend l.pmr l.tradelib  l.CPI_lrl l.CPI_mrl l.CPI_hrl ruleoflaw y_* dummy* if tfpcorrectedoverklems>-0.282 & tfpcorrectedoverklems<0.281 &   pcmpoolklems>0.5 & pcmpoolklems<3, cl(country)
eststo table6_ROL_int

test l.CPI_lrl=l.CPI_mrl 
test l.CPI_lrl=l.CPI_hrl 
test l.CPI_mrl=l.CPI_hrl 


****************************************************************
*******************      LEGAL SYSTEM     **********************
****************************************************************

gen legal_sys=_2
label var legal_sys "Legal system"

gen indep_judic=_2a
label var indep_judic "Judicail Independence"


egen l_legal=pctile(legal_sys), p(34) 
egen h_legal=pctile(legal_sys), p(67) 

gen low_legalsys=0
replace low_legalsys=1 if legal_sys<l_legal
gen mid_legalsys=0
replace mid_legalsys=1 if legal_sys>=l_legal &  legal_sys<h_legal
gen high_legalsys=0
replace high_legalsys=1 if legal_sys>=h_legal

gen CPI_lls=compindex*low_legal
gen CPI_mls=compindex*mid_legal
gen CPI_hls=compindex*high_legal

reg tfpcorrectedoverklems tfpleadershipklems l.tecnogapklems ind_trend l.pmr l.tradelib  l.CPI_lls l.CPI_mls l.CPI_hls legal_sys y_* dummy* if tfpcorrectedoverklems>-0.282 & tfpcorrectedoverklems<0.281 &   pcmpoolklems>0.5 & pcmpoolklems<3, cl(country)
eststo table6_LS_int

test l.CPI_lls=l.CPI_mls
test l.CPI_lls=l.CPI_hls 
test l.CPI_mls=l.CPI_hls 

****************************************************************
************ Just controls for institutions  *******************
****************************************************************


reg tfpcorrectedoverklems tfpleadershipklems l.tecnogapklems ind_trend l.pmr l.tradelib  l.compindex lo_eng lo_fr lo_nor enfocontrcost ruleoflaw legal_sys indep_judic y_* dummy* if tfpcorrectedoverklems>-0.282 & tfpcorrectedoverklems<0.281, cl(country)
eststo table6_over

****************************************************************
************  Manufacturing/services          ******************
****************************************************************


gen manufacturing=1 if isic<16
replace manufacturing=0 if manufacturing==.

gen services=1 if isic>15
replace services=0 if services==.

gen CPI_service=compindex*services
gen CPI_manufacturing=compindex*manufacturing 

xtset identif year
reg tfpcorrectedoverklems tfpleadershipklems l.tecnogapklems ind_trend l.pmr l.tradelib l.CPI_serv l.CPI_man y_* dummy* if tfpcorrectedoverklems>-0.282 & tfpcorrectedoverklems<0.281 &   pcmpoolklems>0.5 & pcmpoolklems<3, cl(country)
eststo table6_manserv

esttab table6_over table6_lo_int table6_enfc_int table6_ROL_int table6_LS_int table6_manserv using "BCDVS_95_4_2013tables.csv", append label  nodepvar star(* 0.10 ** 0.05 *** 0.01) se r2 drop(y_* dummy* ind_*) compress csv

log close




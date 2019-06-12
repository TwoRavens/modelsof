*** Use file "MX2014_CitizensClients_1.dta" ***

*** Table 3 (Basic Model) ***

* Column 1*
xtreg raeele2 post2010 [pw=weight_2010], fe vce(cl nuts3)
* Column 2 *
reg raeele2 post2010 local unempl ln_gdppc migration_rate [pw=weight_2010], vce(cl nuts3)
* Column 3 *
xtreg raeele2 post2010 local unempl ln_gdppc migration_rate [pw=weight_2010], fe vce(cl nuts3)
* Drop Athens Metropolitan Region from the sample *
replace regiond30=. if nuts3==30 
* Column 4 *
reg raeele2 post2010 local unempl ln_gdppc migration_rate regiond1-regiond48 [pw=weight_2010], vce(cl nuts3)
* Add Athens * 
replace regiond30=1 if nuts3==30
* Column 5 *
xtreg top2 post2010 [pw=weight_2010], fe vce(cl nuts3)
* Column 6 *
reg top2 post2010 local unempl ln_gdppc migration_rate [pw=weight_2010], vce(cl nuts3)
* Column 7 *
xtreg top2 post2010 local unempl ln_gdppc migration_rate [pw=weight_2010], fe vce(cl nuts3)
* Column 8 (drop Athens) *
replace regiond30=. if nuts3==30
reg top2 post2010 local unempl ln_gdppc migration_rate regiond1-regiond48 [pw=weight_2010], vce(cl nuts3)
* Add Athens * 
replace regiond30=1 if nuts3==30

*** Table 4 (Basic D-in-D model) ****

* Column 1 *
xtreg raeele2 post2010 highps_post2010 highps [pw=weight_2010], fe vce(cl nuts3)
* Column 2 *
reg raeele2 post2010 highps_post2010 highps local unempl ln_gdppc migration_rate incumbent_won [pw=weight_2010], vce(cl nuts3)
* Column 3 *
xtreg raeele2 post2010 highps_post2010 highps local unempl ln_gdppc migration_rate incumbent_won [pw=weight_2010], fe vce(cl nuts3)
* (drops Athens from the regression) * 
replace highps_post2010=. if nuts3==30&year==2010
replace highps_post2010=. if nuts3==30&year==2009 
* Column 4 * 
xtreg raeele2 post2010 highps_post2010 highps local unempl ln_gdppc migration_rate incumbent_won [pw=weight_2010], fe vce(cl nuts3)
* (restore Athens back to the sample) * 
replace highps_post2010=1 if nuts3==30&year==2010
replace highps_post2010=0 if nuts3==30&year==2009
* Column 5 *
xtreg top2 post2010 highps_post2010 highps [pw=weight_2010], fe vce(cl nuts3)
* Column 6 * 
reg top2 post2010 highps_post2010 highps local unempl ln_gdppc migration_rate incumbent_won [pw=weight_2010], vce(cl nuts3)
* Column 7 * 
xtreg top2 post2010 highps_post2010 highps local unempl ln_gdppc migration_rate incumbent_won [pw=weight_2010], fe vce(cl nuts3)
* Column 8 *
replace highps_post2010=. if nuts3==30&year==2010
replace highps_post2010=. if nuts3==30&year==2009 
* (drops Athens from the regression) * 
xtreg top2 post2010 highps_post2010 highps local unempl ln_gdppc migration_rate incumbent_won [pw=weight_2010], fe vce(cl nuts3)
* (restore Athens back to the sample) * 
replace highps_post2010=1 if nuts3==30&year==2010
replace highps_post2010=0 if nuts3==30&year==2009



*** Table 7 (D-in-D model: Large sample 2007-2012) ***

* Column 1 *
regress raeele post2010 highps_post2010 post2012 highps_post2012 post2009 highps_post2009 post2007 highps_post2007 post2006 local incumbent_won ln_gdppc migration_rate regiond1-regiond48 [pw=weight_2010], vce(cl nuts3)
* Column 2 *
replace regiond30=. if nuts3==30 
* (drops Athens) * 
regress raeele post2010 highps_post2010 post2012 highps_post2012 post2009 highps_post2009 post2007 highps_post2007 post2006 local incumbent_won ln_gdppc migration_rate regiond1-regiond48 [pw=weight_2010], vce(cl nuts3)
* (restores Athens) *
replace regiond30=1 if nuts3==30 
* Column 3 *
regress top_2 post2010 highps_post2010 post2012 highps_post2012 post2009 highps_post2009 post2007 highps_post2007 post2006 local ln_gdppc incumbent_won migration_rate regiond1-regiond48 [pw=weight_2010], vce(cl nuts3)
* Column 4 * 
replace regiond30=. if nuts3==30
* (drops Athens) *
regress top_2 post2010 highps_post2010 post2012 highps_post2012 post2009 highps_post2009 post2007 highps_post2007 post2006 local ln_gdppc incumbent_won migration_rate regiond1-regiond48 [pw=weight_2010], vce(cl nuts3)
* (restores Athens) *
replace regiond30=1 if nuts3==30
* Column 5 *
regress top_3b post2010 highps_post2010 post2012 highps_post2012 post2009 highps_post2009 post2007 highps_post2007 local ln_gdppc incumbent_won migration_rate regiond1-regiond48 [pw=weight_2010], vce(cl nuts3)
* Column 6 *
replace regiond30=. if nuts3==30
* (drops Athens) * 
regress top_3b post2010 highps_post2010 post2012 highps_post2012 post2009 highps_post2009 post2007 highps_post2007 local ln_gdppc incumbent_won migration_rate regiond1-regiond48 [pw=weight_2010], vce(cl nuts3)
* (restore Athens) *
replace regiond30=1 if nuts3==30


*** Table 8 (D-in-D model with Public Sector change) ****

replace regiond30=. if nuts3==30
* drop Athens *
replace highpsch_post2010=. if nuts3==30&year==2010
replace highpsch_post2010=. if nuts3==30&year==2009
* Column 1 *
xtreg top2 post2010 highpsch_post2010  [pw=weight_2010], fe vce(cl nuts3)
* Column 2 * 
xtreg top2 post2010 highpsch_post2010 local unempl ln_gdppc migration_rate incumbent_won [pw=weight_2010], fe vce(cl nuts3)
* restore Athens * 
replace highpsch_post2010=1 if nuts3==30&year==2010
replace highpsch_post2010=0 if nuts3==30&year==2009
* Column 3 * 
regress top_2 post2010 highpsch_post2010 post2012 highpsch_post2012 post2009 highpsch_post2009 post2007 highpsch_post2007 post2006 regiond1-regiond48 [pw=weight_2010] if year>=2007, vce(cl nuts3)
* Column 4 *
regress top_2 post2010 highpsch_post2010 post2012 post2009 post2007 post2006 highpsch_post2012 highpsch_post2009 highpsch_post2007 ln_gdppc migration_rate incumbent_won regiond1-regiond48 [pw=weight_2010], vce(cl nuts3)
* Column 5 * 
* restore Athens *
replace regiond30=1 if nuts3==30
regress top_2 post2010 highps_post2010 post2012 highps_post2012 post2009 highps_post2009 post2007 highps_post2007 post2006 local ln_gdppc incumbent_won migration_rate regiond1-regiond48 [pw=weight_2010], vce(cl nuts3)
* Column 6 *
replace regiond30=. if nuts3==30
regress top_3 post2010 highpsch_post2010 post2012 post2009 post2007 post2006 highpsch_post2012 highpsch_post2009 highpsch_post2007 regiond1-regiond48 [pw=weight_2010], vce(cl nuts3)
* Column 7 *
regress top_3 post2010 highpsch_post2010 post2012 post2009 post2007 post2006 highpsch_post2012 highpsch_post2009 highpsch_post2007 ln_gdppc migration_rate incumbent_won regiond1-regiond48 [pw=weight_2010], vce(cl nuts3)
* Column 8 *
regress top_3b post2010 highps_post2010 post2012 highps_post2012 post2009 highps_post2009 post2007 highps_post2007 local ln_gdppc incumbent_won migration_rate regiond1-regiond48 [pw=weight_2010], vce(cl nuts3)
* restore Athens * 
replace regiond30=1 if nuts3==30


*** Table 9 (D-in-D additional controls) 

* Column 1 *
reg pasok post2010 highps_post2010 pasok_origin pasok_joint [pw=weight_2010],  vce(cl nuts3)
* Column 2 *
reg pasok post2010 highps_post2010 highps pasok_origin pasok_joint local unempl ln_gdppc migration_rate incumbent_won [pw=weight_2010], vce(cl nuts3)
* Column 3 *
xtreg pasok post2010 highps_post2010 highps pasok_origin pasok_joint local unempl ln_gdppc migration_rate incumbent_won [pw=weight_2010], fe vce(cl nuts3)
* Column 4 *
reg nd post2010 highps_post2010 nd_origin nd_joint [pw=weight_2010] ,  vce(cl nuts3)
* Column 5 *
reg nd post2010 highps_post2010 highps nd_origin nd_joint local unempl ln_gdppc migration_rate [pw=weight_2010],  vce(cl nuts3)
* Column 6 *
reg nd post2010 highps_post2010 nd_origin nd_joint local unempl ln_gdppc migration_rate [pw=weight_2010],  vce(cl nuts3)
* Column 7 *
reg top2 post2010 highps_post2010 highps pasok_origin pasok_joint nd_origin nd_joint local unempl ln_gdppc migration_rate [pw=weight_2010], vce(cl nuts3)
* Column 8 *
xtreg top2 post2010 highps_post2010 highps pasok_origin pasok_joint nd_origin nd_joint local unempl ln_gdppc migration_rate  [pw=weight_2010], fe vce(cl nuts3)


*** Use file "MX2014_CitizensClients_2.dta" ***

*** Table 6 (Placebo Regressions 2002-2006) *** 

* drop Athens * 
replace regiond30=. if nuts3==30
* Column 1 (Pub. Sector level) *
regress raeele highps_post2006 year2006 highps_post2004 year2004 highps_post2002 unempl ln_gdppc incumbent_won regiond1-regiond48 , vce(cl nuts3)
* Column 2 (Pub. Sector level) *
regress top_2  highps_post2006 year2006  highps_post2004 year2004 highps_post2002 unempl ln_gdppc incumbent_won regiond1-regiond48, vce(cl nuts3)
* Column 3 (Pub. Sector growth) *
regress raeele  highpsch_post2006 year2006 highpsch_post2004 year2004 highpsch_post2002 unempl ln_gdppc incumbent_won regiond1-regiond48 [aw=weight], vce(cl nuts3)
* Column 4 (Pub. Sector growth) *
regress top_2 highpsch_post2006 year2006 highpsch_post2004 year2004 highpsch_post2002 unempl ln_gdppc incumbent_won regiond1-regiond48 [aw=weight], vce(cl nuts3)
* Column 5 *
regress raeele year2004 highps_post2004 highps_post2002 unempl ln_gdppc incumbent_won regiond1-regiond48 [aw=weight] if year<=2004, vce(cl nuts3)
* Column 6 *
regress top_2 year2004 highps_post2004 highps_post2002 unempl ln_gdppc incumbent_won regiond1-regiond48 [aw=weight] if year<=2004, vce(cl nuts3)
* Column 7 *
regress raeele year2004 highpsch_post2004 highpsch_post2002 unempl ln_gdppc incumbent_won regiond1-regiond48 [aw=weight] if year<=2004, vce(cl nuts3)
* Column 8 *
regress top_2 year2004 highpsch_post2004 highpsch_post2002 unempl ln_gdppc incumbent_won regiond1-regiond48 [aw=weight] if year<=2004, vce(cl nuts3)
* restore Athens *
replace regiond30=1 if nuts3==30


*** Use file "MX2014_CitizensClients_3.dta" ***

*** Table 5 (Continuous Intensity to Treatment) *** 

* Column 1 *
regress rae_dif year2010 lag_rae emp_pub, vce(cl nuts2)
* Column 2 *
reg rae_dif year2010 lag_rae emp_pub year2002-year2009, vce(cl nuts2)
* Column 3 *
regress rae_dif year2010 lag_rae emp_pub local unempl migration_rate, vce(cl nuts2)
* Column 4 *
xtreg rae_dif year2010 lag_rae emp_pub local unempl migration_rate if year >= 2009, vce(cl nuts2)
* Column 5 *
regress top2_dif year2010 lag_top2 emp_pub, vce(cl nuts2)
* Column 6 *
reg top2_dif year2010 lag_top2 emp_pub year2002-year2009, vce(cl nuts2)
* Column 7 *
regress top2_dif year2010 lag_top2 emp_pub local unempl migration_rate, vce(cl nuts2)
* Column 8 *
xtreg top2_dif year2010 lag_rae emp_pub local unempl migration_rate if year >= 2009, vce(cl nuts2)


*** Table A.1 *** 

gen highps_1998=highps*year1998
gen highps_2002=highps*year2002
gen highps_2004=highps*year2004
gen highps_2006=highps*year2006
gen highps_2007=highps*year2007
gen highps_2009=highps*year2009
gen highps_2010=highps*year2010

* Column 1 (Fragmentation) * 
regress raeele year2010 highps_2010 year2009 highps_2009 year2007 highps_2007 year2006 highps_2006 year2004 highps_2004 highps_2002 unempl incumbent_won migration_rate pasok_joint nd_joint regiond1-regiond13 [pw=weight], vce(cl nuts2)
* Column 2 (PASOK & ND vote-shares) *
regress top2 year2010 highps_2010 year2009 highps_2009 year2007 highps_2007 year2006 highps_2006 year2004 highps_2004 highps_2002 unempl incumbent_won migration_rate pasok_joint nd_joint regiond1-regiond13 [pw=weight], vce(cl nuts2)

drop highps_1998-highps_2010

*** End do file ***

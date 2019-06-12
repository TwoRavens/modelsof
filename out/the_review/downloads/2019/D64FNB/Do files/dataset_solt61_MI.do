capture clear
capture log close
clear matrix
clear mata
set maxvar 20000
*set memory 400m
*set more off
*set matsize 4000
set 


***path

cap cd "C:\Users\paul\Dropbox\Institutions\democracy_and_economic_outcomes\file_APSR\DataReplicationFiles\Data files"

cap cd "/Users/dorschm/Dropbox/Research/Institutions/democracy_and_economic_outcomes/file_APSR/DataReplicationFiles/Data files"

******original swiid 6.1 dataset

use "swiid6_1"

rename country cname

replace cname="Cape Verde" if cname=="Cabo Verde"
replace cname="Congo, Democratic Republic" if cname=="Congo, D.R."
replace cname="Cyprus (1975-)" if cname=="Cyprus"
replace cname="Cote d'Ivoire" if cname=="C√¥te D'Ivoire"
replace cname="Ethiopia (1993-)" if cname=="Ethiopia"
replace cname="France (1963-)" if cname=="France"
replace cname="Germany, West" if cname=="Germany" & year<1990
replace cname="Guinea-Bissau" if cname=="Guinea Bissau"
replace cname="Korea, South" if cname=="Korea"
replace cname="Laos" if cname=="Lao"
replace cname="Malaysia (1966-)" if cname=="Malaysia"
replace cname="Pakistan (-1970)" if cname=="Pakistan" & year<1971
replace cname="Pakistan (1971-)" if cname=="Pakistan" & year>1970
replace cname="USSR" if cname=="Soviet Union"
replace cname="St Kitts and Nevis" if cname=="Saint Kitts and Nevis"
replace cname="St Lucia" if cname=="Saint Lucia"
replace cname="St Vincent and the Grenadines" if cname=="Saint Vincent and the Grenadines"
replace cname="Sudan (-2011)" if cname=="Sudan" & year<2012
replace cname="Sudan (2012-)" if cname=="Sudan" & year>2011
replace cname="Vietnam" if cname=="Viet Nam"

mi passive : gen gini_disp2 = gini_disp*100
mi passive : gen gini_mkt2 = gini_mkt*100

mi passive : gen solt_ginet = gini_disp2
mi passive : gen solt_ginmar = gini_mkt2 

sort cname year

save "swiid6_1_merge.dta", replace



clear



*************merge with other data sources

use "BoixMillerRosato_Dem.dta"

rename ccode ccodecow

rename democracy boix_demo 

rename democracy_trans boix_trans

drop if ccodecow==.

	sort ccodecow year
	tsset ccodecow year

save "BoixMillerRosato_Dem_Merge.dta", replace

sort ccodecow year

save, replace

clear

use "QoG_std_ts_20dec13.dta"

sort ccodecow year

save, replace

clear

use  "BoixMillerRosato_Dem_Merge.dta"

merge ccodecow year using "QoG_std_ts_20dec13.dta"

drop if ccodecow==.

sort ccodecow year

drop _merge

drop if ccode==.

save "Boix_QoG_Merge.dta", replace


use  "HRV_Merge.dta"

sort ccodecow year

merge ccodecow year using "Boix_QoG_Merge.dta"

drop if ccodecow==.

sort ccodecow year

drop _merge

save "HRV_Boix_QoG_Merge.dta", replace




use "HRV_Boix_QoG_Merge"

sort cname year


drop if ccode==.

save "QoG_std_ts_20dec13_merge61.dta", replace


clear


use "swiid6_1_merge.dta"

merge cname year using "QoG_std_ts_20dec13_merge61.dta"

sort ccode year

drop if ccode==.

save "democratic_outcomes_MI2.dta", replace

sort ccode year

mi stset, clear

drop if ccode==.

sort ccode year

mi tsset ccode year
sort ccode year

save "democratic_outcomes_MI2.dta", replace


*******************5 and 10 years panel

gen fiveyears=1 if year==1955| year==1960| year==1965| year==1970| year==1975| year==1980| year==1985| year==1990| year==1995| year==2000| year==2005| year==2010

gen tenyears=1 if year==1955| year==1965| year==1975| year==1985| year==1995| year==2005

*******************construction des variables de democratization

****acemoglu & al (2015) democratization criteria

gen acemoglu_demo=1 if p_polity2>0 & p_polity2!=. & (fh_status==2 | fh_status==1)

replace acemoglu_demo=0 if (p_polity2<=0 & p_polity2!=.) | fh_status==3

replace acemoglu_demo=1 if p_polity2>0 & p_polity2!=. & fh_status==. & chga_demo==1

replace acemoglu_demo=1 if (fh_status==2 | fh_status==1) & p_polity2==. & chga_demo==1
 
replace acemoglu_demo=0 if p_polity2>0  & fh_status==. & chga_demo==0

replace acemoglu_demo=0 if (fh_status==2 | fh_status==1 | fh_status==.) & p_polity2==. & chga_demo==0

**** switch to autocracy **********

gen acemoglu_auto=1 if p_polity2<=0 & p_polity2!=. & fh_status==3

replace acemoglu_auto=0 if (p_polity2>0 & p_polity2!=.) | (fh_status==2 | fh_status==1)

replace acemoglu_auto=1 if p_polity2<=0 & fh_status==. & chga_demo==0

replace acemoglu_auto=1 if fh_status==3 & p_polity2==. & chga_demo==0
 
replace acemoglu_auto=0 if p_polity2<=0 & fh_status==. & chga_demo==1

replace acemoglu_auto=0 if fh_status==3 & p_polity2==. & chga_demo==1


****acemoglu & al (2015) democratization index, more restrictive


gen acemoglu_demo2=1 if p_polity2>4 & (fh_status==2 | fh_status==1)

replace acemoglu_demo2=0 if (p_polity2<=4 & p_polity2!=.) | fh_status==3

replace acemoglu_demo2=1 if p_polity2>4 &  p_polity2!=.  & fh_status==. & chga_demo==1

replace acemoglu_demo2=1 if (fh_status==2 | fh_status==1) & p_polity2==. & chga_demo==1
 
replace acemoglu_demo2=0 if p_polity2>4 & fh_status==. & chga_demo==0

replace acemoglu_demo2=0 if (fh_status==2 | fh_status==1 | fh_status==.) & p_polity2==. & chga_demo==0


sort ccode year

*****Democratization index using the Polity2 

gen demo=1 if p_polity2>0 & p_polity2!=.

replace demo=0 if p_polity2<=0 & p_polity2!=.

gen demo2=1 if p_polity2>4 & p_polity2!=.

replace demo2=0 if p_polity2<=4 & p_polity2!=.



****************************************************redistribution variable  

mi passive : gen redist = solt_ginmar - solt_ginet


*******************simple interaction with inequality

mi passive : gen acemoglu_demo_Lginet = acemoglu_demo*l.solt_ginet

mi passive : gen acemoglu_demo_L5ginet = acemoglu_demo*l5.solt_ginet


**************GDP variables

gen log_gdp = log(pwt_rgdpch)

gen log_gdp_wdi = log(wdi_gdpc)





***************define the initial inequality degree

**** at the moment of democratization

 mi passive : gen pre_demo_ineg_0 = solt_ginet if acemoglu_demo==1 & L.acemoglu_demo==0

 mi passive : replace pre_demo_ineg_0 = L.pre_demo_ineg_0 if acemoglu_demo!=0

 mi passive : replace pre_demo_ineg_0 = solt_ginet if pre_demo_ineg_0 == .

 
******one year before

mi passive : gen pre_demo_ineg = solt_ginet if acemoglu_demo==0 & F.acemoglu_demo==1

 mi passive : replace pre_demo_ineg = L.pre_demo_ineg if acemoglu_demo!=0

 mi passive : replace pre_demo_ineg = solt_ginet if pre_demo_ineg == . 

***by taking the degree of inequality 5 ans before democratization or if not available, 4, 3, 2, 1 or 0 years before

mi passive : gen pre_demo_ineg_best = L5.solt_ginet if acemoglu_demo==0 & F.acemoglu_demo==1
mi passive : replace pre_demo_ineg_best = L4.solt_ginet if acemoglu_demo==0 & F.acemoglu_demo==1 & L5.solt_ginet==.
mi passive : replace pre_demo_ineg_best = L3.solt_ginet if acemoglu_demo==0 & F.acemoglu_demo==1 & L5.solt_ginet==. & L4.solt_ginet==.
mi passive : replace pre_demo_ineg_best = L2.solt_ginet if acemoglu_demo==0 & F.acemoglu_demo==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==.
mi passive : replace pre_demo_ineg_best = L.solt_ginet if acemoglu_demo==0 & F.acemoglu_demo==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==.
mi passive : replace pre_demo_ineg_best = solt_ginet if acemoglu_demo==0 & F.acemoglu_demo==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==. & L.solt_ginet==.
mi passive : replace pre_demo_ineg_best = F.solt_ginet if acemoglu_demo==0 & F.acemoglu_demo==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==. & L.solt_ginet==. & solt_ginet==.

mi passive : replace pre_demo_ineg_best = L.pre_demo_ineg_best if acemoglu_demo!=0

mi passive : replace pre_demo_ineg_best = solt_ginet if pre_demo_ineg_best == .





****generating the change ten years after democratization

mi passive : gen post_demo_ineg_best = F5.solt_ginet if acemoglu_demo==0 & F.acemoglu_demo==1
mi passive : replace post_demo_ineg_best = F4.solt_ginet if acemoglu_demo==0 & F.acemoglu_demo==1 & F5.solt_ginet==.
mi passive : replace post_demo_ineg_best = F3.solt_ginet if acemoglu_demo==0 & F.acemoglu_demo==1 & F5.solt_ginet==. & F4.solt_ginet==.
mi passive : replace post_demo_ineg_best = F2.solt_ginet if acemoglu_demo==0 & F.acemoglu_demo==1 & F5.solt_ginet==. & F4.solt_ginet==. & F3.solt_ginet==.
mi passive : replace post_demo_ineg_best = F.solt_ginet if acemoglu_demo==0 & F.acemoglu_demo==1 & F5.solt_ginet==. & F4.solt_ginet==. & F3.solt_ginet==. & F2.solt_ginet==.
mi passive : replace post_demo_ineg_best = solt_ginet if acemoglu_demo==0 & F.acemoglu_demo==1 & F5.solt_ginet==. & F4.solt_ginet==. & F3.solt_ginet==. & F2.solt_ginet==. & F.solt_ginet==.


mi passive : replace post_demo_ineg_best = F.post_demo_ineg_best if acemoglu_demo!=0

mi passive : replace post_demo_ineg_best = solt_ginet if post_demo_ineg_best == .

mi passive : generate change_ineq = post_demo_ineg_best-pre_demo_ineg_best



mi passive : gen post10_demo_ineg_best = F10.solt_ginet if acemoglu_demo==0 & F.acemoglu_demo==1
mi passive : replace post10_demo_ineg_best = F9.solt_ginet if acemoglu_demo==0 & F.acemoglu_demo==1 & F10.solt_ginet==.
mi passive : replace post10_demo_ineg_best = F8.solt_ginet if acemoglu_demo==0 & F.acemoglu_demo==1 & F10.solt_ginet==. & F9.solt_ginet==.
mi passive : replace post10_demo_ineg_best = F7.solt_ginet if acemoglu_demo==0 & F.acemoglu_demo==1 & F10.solt_ginet==. & F9.solt_ginet==. & F8.solt_ginet==.
mi passive : replace post10_demo_ineg_best = F6.solt_ginet if acemoglu_demo==0 & F.acemoglu_demo==1 & F10.solt_ginet==. & F9.solt_ginet==. & F8.solt_ginet==. & F7.solt_ginet==.
mi passive : replace post10_demo_ineg_best = post_demo_ineg_best if acemoglu_demo==0 & F.acemoglu_demo==1 & F10.solt_ginet==. & F9.solt_ginet==. & F8.solt_ginet==. & F7.solt_ginet==. & F6.solt_ginet==.


mi passive : replace post10_demo_ineg_best = F.post10_demo_ineg_best if acemoglu_demo!=0

mi passive : generate change10_ineq = post10_demo_ineg_best-pre_demo_ineg_best



************for market gini

mi passive : gen pre_demo_ineg_bestMar = L5.solt_ginmar if acemoglu_demo==0 & F.acemoglu_demo==1
mi passive : replace pre_demo_ineg_bestMar = L4.solt_ginmar if acemoglu_demo==0 & F.acemoglu_demo==1 & L5.solt_ginmar==.
mi passive : replace pre_demo_ineg_bestMar = L3.solt_ginmar if acemoglu_demo==0 & F.acemoglu_demo==1 & L5.solt_ginmar==. & L4.solt_ginmar==.
mi passive : replace pre_demo_ineg_bestMar = L2.solt_ginmar if acemoglu_demo==0 & F.acemoglu_demo==1 & L5.solt_ginmar==. & L4.solt_ginmar==. & L3.solt_ginmar==.
mi passive : replace pre_demo_ineg_bestMar = L.solt_ginmar if acemoglu_demo==0 & F.acemoglu_demo==1 & L5.solt_ginmar==. & L4.solt_ginmar==. & L3.solt_ginmar==. & L2.solt_ginmar==.
mi passive : replace pre_demo_ineg_bestMar = solt_ginmar if acemoglu_demo==0 & F.acemoglu_demo==1 & L5.solt_ginmar==. & L4.solt_ginmar==. & L3.solt_ginmar==. & L2.solt_ginmar==. & L.solt_ginmar==.
mi passive : replace pre_demo_ineg_bestMar = F.solt_ginmar if acemoglu_demo==0 & F.acemoglu_demo==1 & L5.solt_ginmar==. & L4.solt_ginmar==. & L3.solt_ginmar==. & L2.solt_ginmar==. & L.solt_ginmar==. & solt_ginmar==.

mi passive : replace pre_demo_ineg_bestMar = L.pre_demo_ineg_bestMar if acemoglu_demo!=0

mi passive : replace pre_demo_ineg_bestMar = solt_ginmar if pre_demo_ineg_bestMar == .




****generate the ten years change for market gini

mi passive : gen post_demo_ineg_bestMar = F5.solt_ginmar if acemoglu_demo==0 & F.acemoglu_demo==1
mi passive : replace post_demo_ineg_bestMar = F4.solt_ginmar if acemoglu_demo==0 & F.acemoglu_demo==1 & F5.solt_ginmar==.
mi passive : replace post_demo_ineg_bestMar = F3.solt_ginmar if acemoglu_demo==0 & F.acemoglu_demo==1 & F5.solt_ginmar==. & F4.solt_ginmar==.
mi passive : replace post_demo_ineg_bestMar = F2.solt_ginmar if acemoglu_demo==0 & F.acemoglu_demo==1 & F5.solt_ginmar==. & F4.solt_ginmar==. & F3.solt_ginmar==.
mi passive : replace post_demo_ineg_bestMar = F.solt_ginmar if acemoglu_demo==0 & F.acemoglu_demo==1 & F5.solt_ginmar==. & F4.solt_ginmar==. & F3.solt_ginmar==. & F2.solt_ginmar==.
mi passive : replace post_demo_ineg_bestMar = solt_ginmar if acemoglu_demo==0 & F.acemoglu_demo==1 & F5.solt_ginmar==. & F4.solt_ginmar==. & F3.solt_ginmar==. & F2.solt_ginmar==. & F.solt_ginmar==.


mi passive : replace post_demo_ineg_bestMar = F.post_demo_ineg_bestMar if acemoglu_demo!=0

mi passive : replace post_demo_ineg_bestMar = solt_ginmar if post_demo_ineg_bestMar == .

mi passive : generate change_ineqMar = post_demo_ineg_bestMar-pre_demo_ineg_bestMar



mi passive : gen post10_demo_ineg_bestMar = F10.solt_ginmar if acemoglu_demo==0 & F.acemoglu_demo==1
mi passive : replace post10_demo_ineg_bestMar = F9.solt_ginmar if acemoglu_demo==0 & F.acemoglu_demo==1 & F10.solt_ginmar==.
mi passive : replace post10_demo_ineg_bestMar = F8.solt_ginmar if acemoglu_demo==0 & F.acemoglu_demo==1 & F10.solt_ginmar==. & F9.solt_ginmar==.
mi passive : replace post10_demo_ineg_bestMar = F7.solt_ginmar if acemoglu_demo==0 & F.acemoglu_demo==1 & F10.solt_ginmar==. & F9.solt_ginmar==. & F8.solt_ginmar==.
mi passive : replace post10_demo_ineg_bestMar = F6.solt_ginmar if acemoglu_demo==0 & F.acemoglu_demo==1 & F10.solt_ginmar==. & F9.solt_ginmar==. & F8.solt_ginmar==. & F7.solt_ginmar==.
mi passive : replace post10_demo_ineg_bestMar = post_demo_ineg_bestMar if acemoglu_demo==0 & F.acemoglu_demo==1 & F10.solt_ginmar==. & F9.solt_ginmar==. & F8.solt_ginmar==. & F7.solt_ginmar==. & F6.solt_ginmar==.


mi passive : replace post10_demo_ineg_bestMar = F.post10_demo_ineg_bestMar if acemoglu_demo!=0

mi passive : generate change10_ineqMar = post10_demo_ineg_bestMar-pre_demo_ineg_bestMar

mi passive : generate PCchange10_ineqMar = ((post10_demo_ineg_bestMar-pre_demo_ineg_bestMar)/pre_demo_ineg_bestMar)*100



*********using the more simple democratization criteria based on the Polity2

mi passive : gen pre_p_demo_ineg_best = L5.solt_ginet if demo==0 & F.demo==1
mi passive : replace pre_p_demo_ineg_best = L4.solt_ginet if demo==0 & F.demo==1 & L5.solt_ginet==.
mi passive : replace pre_p_demo_ineg_best = L3.solt_ginet if demo==0 & F.demo==1 & L5.solt_ginet==. & L4.solt_ginet==.
mi passive : replace pre_p_demo_ineg_best = L2.solt_ginet if demo==0 & F.demo==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==.
mi passive : replace pre_p_demo_ineg_best = L.solt_ginet if demo==0 & F.demo==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==.
mi passive : replace pre_p_demo_ineg_best = solt_ginet if demo==0 & F.demo==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==. & L.solt_ginet==.
mi passive : replace pre_p_demo_ineg_best = F.solt_ginet if demo==0 & F.demo==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==. & L.solt_ginet==. & solt_ginet==.

mi passive : replace pre_p_demo_ineg_best = L.pre_p_demo_ineg_best if demo!=0

mi passive : replace pre_p_demo_ineg_best = solt_ginet if pre_p_demo_ineg_best == .



*** with the boix indicator

mi passive : gen pre_demo_ineg_boix = L5.solt_ginet if boix_demo==0 & F.boix_demo==1
mi passive : replace pre_demo_ineg_boix = L4.solt_ginet if boix_demo==0 & F.boix_demo==1 & L5.solt_ginet==.
mi passive : replace pre_demo_ineg_boix = L3.solt_ginet if boix_demo==0 & F.boix_demo==1 & L5.solt_ginet==. & L4.solt_ginet==.
mi passive : replace pre_demo_ineg_boix = L2.solt_ginet if boix_demo==0 & F.boix_demo==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==.
mi passive : replace pre_demo_ineg_boix = L.solt_ginet if boix_demo==0 & F.boix_demo==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==.
mi passive : replace pre_demo_ineg_boix = solt_ginet if boix_demo==0 & F.boix_demo==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==. & L.solt_ginet==.
mi passive : replace pre_demo_ineg_boix = F.solt_ginet if boix_demo==0 & F.boix_demo==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==. & L.solt_ginet==. & solt_ginet==.

mi passive : replace pre_demo_ineg_boix = L.pre_demo_ineg_boix if boix_demo!=0
mi passive : replace pre_demo_ineg_boix = solt_ginet if pre_demo_ineg_boix == .



********  interaction with democratic reversals  *********

mi passive : gen pre_auto_ineg_best = L5.solt_ginet if acemoglu_auto==0 & F.acemoglu_auto==1
mi passive : replace pre_auto_ineg_best = L4.solt_ginet if acemoglu_auto==0 & F.acemoglu_auto==1 & L5.solt_ginet==.
mi passive : replace pre_auto_ineg_best = L3.solt_ginet if acemoglu_auto==0 & F.acemoglu_auto==1 & L5.solt_ginet==. & L4.solt_ginet==.
mi passive : replace pre_auto_ineg_best = L2.solt_ginet if acemoglu_auto==0 & F.acemoglu_auto==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==.
mi passive : replace pre_auto_ineg_best = L.solt_ginet if acemoglu_auto==0 & F.acemoglu_auto==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==.
mi passive : replace pre_auto_ineg_best = solt_ginet if acemoglu_auto==0 & F.acemoglu_auto==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==. & L.solt_ginet==.
mi passive : replace pre_auto_ineg_best = F.solt_ginet if acemoglu_auto==0 & F.acemoglu_auto==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==. & L.solt_ginet==. & solt_ginet==.

mi passive : replace pre_auto_ineg_best = L.pre_auto_ineg_best if acemoglu_auto!=0

mi passive : replace pre_auto_ineg_best = solt_ginet if pre_auto_ineg_best == .



****using the more simple Polity2 indicator with a more restrictive critéria

mi passive : gen pre_demo2_ineg = L5.solt_ginet if demo2==0 & F.demo2==1
mi passive : replace pre_demo2_ineg = L4.solt_ginet if demo2==0 & F.demo2==1 & L5.solt_ginet==.
mi passive : replace pre_demo2_ineg = L3.solt_ginet if demo2==0 & F.demo2==1 & L5.solt_ginet==. & L4.solt_ginet==.
mi passive : replace pre_demo2_ineg = L2.solt_ginet if demo2==0 & F.demo2==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==.
mi passive : replace pre_demo2_ineg = L.solt_ginet if demo2==0 & F.demo2==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==.
mi passive : replace pre_demo2_ineg = solt_ginet if demo2==0 & F.demo2==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==. & L.solt_ginet==.
mi passive : replace pre_demo2_ineg = F.solt_ginet if demo2==0 & F.demo2==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==. & L.solt_ginet==. & solt_ginet==.

mi passive : replace pre_demo2_ineg = L.pre_demo2_ineg if demo2!=0
mi passive : replace pre_demo2_ineg = solt_ginet if pre_demo2_ineg == .

mi passive: gen demo2_pre_demo2_ineg = demo2*pre_demo2_ineg



******with the CHGA index

mi passive : gen pre_chga_ineg = L5.solt_ginet if chga_demo==0 & F.chga_demo==1
mi passive : replace pre_chga_ineg = L4.solt_ginet if chga_demo==0 & F.chga_demo==1 & L5.solt_ginet==.
mi passive : replace pre_chga_ineg = L3.solt_ginet if chga_demo==0 & F.chga_demo==1 & L5.solt_ginet==. & L4.solt_ginet==.
mi passive : replace pre_chga_ineg = L2.solt_ginet if chga_demo==0 & F.chga_demo==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==.
mi passive : replace pre_chga_ineg = L.solt_ginet if chga_demo==0 & F.chga_demo==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==.
mi passive : replace pre_chga_ineg = solt_ginet if chga_demo==0 & F.chga_demo==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==. & L.solt_ginet==.
mi passive : replace pre_chga_ineg = F.solt_ginet if chga_demo==0 & F.chga_demo==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==. & L.solt_ginet==. & solt_ginet==.

mi passive : replace pre_chga_ineg = L.pre_chga_ineg if chga_demo!=0
mi passive : replace pre_chga_ineg = solt_ginet if pre_chga_ineg == .


***** generating a placebo with civil war *******

generate civil_war2 = 0 if  ucdp_type3!=.
replace civil_war2 = 1 if ucdp_type3 == 2
replace civil_war2 = 1 if ucdp_type3 == 3

generate civil_war3 = 0
replace civil_war3 = 1 if ucdp_type3 == 3

mi passive : gen pre_civil_ineg_best = L5.solt_ginet if civil_war2==0 & F.civil_war2==1
mi passive : replace pre_civil_ineg_best = L4.solt_ginet if civil_war2==0 & F.civil_war2==1 & L5.solt_ginet==.
mi passive : replace pre_civil_ineg_best = L3.solt_ginet if civil_war2==0 & F.civil_war2==1 & L5.solt_ginet==. & L4.solt_ginet==.
mi passive : replace pre_civil_ineg_best = L2.solt_ginet if civil_war2==0 & F.civil_war2==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==.
mi passive : replace pre_civil_ineg_best = L.solt_ginet if civil_war2==0 & F.civil_war2==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==.
mi passive : replace pre_civil_ineg_best = solt_ginet if civil_war2==0 & F.civil_war2==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==. & L.solt_ginet==.
mi passive : replace pre_civil_ineg_best = F.solt_ginet if civil_war2==0 & F.civil_war2==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==. & L.solt_ginet==. & solt_ginet==.

mi passive : replace pre_civil_ineg_best = L.pre_civil_ineg_best if civil_war2!=0

mi passive : replace pre_civil_ineg_best = solt_ginet if pre_civil_ineg_best == .

** with more severe threshold for defining civil war **

mi passive : gen pre_civil3_ineg_best = L5.solt_ginet if civil_war3==0 & F.civil_war3==1
mi passive : replace pre_civil3_ineg_best = L4.solt_ginet if civil_war3==0 & F.civil_war3==1 & L5.solt_ginet==.
mi passive : replace pre_civil3_ineg_best = L3.solt_ginet if civil_war3==0 & F.civil_war3==1 & L5.solt_ginet==. & L4.solt_ginet==.
mi passive : replace pre_civil3_ineg_best = L2.solt_ginet if civil_war3==0 & F.civil_war3==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==.
mi passive : replace pre_civil3_ineg_best = L.solt_ginet if civil_war3==0 & F.civil_war3==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==.
mi passive : replace pre_civil3_ineg_best = solt_ginet if civil_war3==0 & F.civil_war3==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==. & L.solt_ginet==.
mi passive : replace pre_civil3_ineg_best = F.solt_ginet if civil_war3==0 & F.civil_war3==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==. & L.solt_ginet==. & solt_ginet==.

mi passive : replace pre_civil3_ineg_best = L.pre_civil3_ineg_best if civil_war3!=0

mi passive : replace pre_civil3_ineg_best = solt_ginet if pre_civil3_ineg_best == .

**** generating placebo with leads  *****

generate plac_lead5 = L5.acemoglu_demo
generate plac_lead10 = L10.acemoglu_demo
generate plac_lead15 = L15.acemoglu_demo


mi passive : gen pre_lead5_ineg_best = L5.solt_ginet if plac_lead5==0 & F.plac_lead5==1
mi passive : replace pre_lead5_ineg_best = L4.solt_ginet if plac_lead5==0 & F.plac_lead5==1 & L5.solt_ginet==.
mi passive : replace pre_lead5_ineg_best = L3.solt_ginet if plac_lead5==0 & F.plac_lead5==1 & L5.solt_ginet==. & L4.solt_ginet==.
mi passive : replace pre_lead5_ineg_best = L2.solt_ginet if plac_lead5==0 & F.plac_lead5==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==.
mi passive : replace pre_lead5_ineg_best = L.solt_ginet if plac_lead5==0 & F.plac_lead5==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==.
mi passive : replace pre_lead5_ineg_best = solt_ginet if plac_lead5==0 & F.plac_lead5==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==. & L.solt_ginet==.
mi passive : replace pre_lead5_ineg_best = F.solt_ginet if plac_lead5==0 & F.plac_lead5==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==. & L.solt_ginet==. & solt_ginet==.

mi passive : replace pre_lead5_ineg_best = L.pre_lead5_ineg_best if plac_lead5!=0
mi passive : replace pre_lead5_ineg_best = solt_ginet if pre_lead5_ineg_best == .


mi passive : gen pre_lead10_ineg_best = L5.solt_ginet if plac_lead10==0 & F.plac_lead10==1
mi passive : replace pre_lead10_ineg_best = L4.solt_ginet if plac_lead10==0 & F.plac_lead10==1 & L5.solt_ginet==.
mi passive : replace pre_lead10_ineg_best = L3.solt_ginet if plac_lead10==0 & F.plac_lead10==1 & L5.solt_ginet==. & L4.solt_ginet==.
mi passive : replace pre_lead10_ineg_best = L2.solt_ginet if plac_lead10==0 & F.plac_lead10==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==.
mi passive : replace pre_lead10_ineg_best = L.solt_ginet if plac_lead10==0 & F.plac_lead10==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==.
mi passive : replace pre_lead10_ineg_best = solt_ginet if plac_lead10==0 & F.plac_lead10==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==. & L.solt_ginet==.
mi passive : replace pre_lead10_ineg_best = F.solt_ginet if plac_lead10==0 & F.plac_lead10==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==. & L.solt_ginet==. & solt_ginet==.

mi passive : replace pre_lead10_ineg_best = L.pre_lead10_ineg_best if plac_lead10!=0
mi passive : replace pre_lead10_ineg_best = solt_ginet if pre_lead10_ineg_best == .


mi passive : gen pre_lead15_ineg_best = L5.solt_ginet if plac_lead15==0 & F.plac_lead15==1
mi passive : replace pre_lead15_ineg_best = L4.solt_ginet if plac_lead15==0 & F.plac_lead15==1 & L5.solt_ginet==.
mi passive : replace pre_lead15_ineg_best = L3.solt_ginet if plac_lead15==0 & F.plac_lead15==1 & L5.solt_ginet==. & L4.solt_ginet==.
mi passive : replace pre_lead15_ineg_best = L2.solt_ginet if plac_lead15==0 & F.plac_lead15==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==.
mi passive : replace pre_lead15_ineg_best = L.solt_ginet if plac_lead15==0 & F.plac_lead15==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==.
mi passive : replace pre_lead15_ineg_best = solt_ginet if plac_lead15==0 & F.plac_lead15==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==. & L.solt_ginet==.
mi passive : replace pre_lead15_ineg_best = F.solt_ginet if plac_lead15==0 & F.plac_lead15==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==. & L.solt_ginet==. & solt_ginet==.

mi passive : replace pre_lead15_ineg_best = L.pre_lead15_ineg_best if plac_lead15!=0
mi passive : replace pre_lead15_ineg_best = solt_ginet if pre_lead15_ineg_best == .



**** using fixed inequality levels in the interactions

mi passive : gen acemoglu_pre_demo_ineg_0 = acemoglu_demo*pre_demo_ineg_0

mi passive : gen acemoglu_pre_demo_ineg_best = acemoglu_demo*pre_demo_ineg_best

mi passive: gen p_demo_pre_ineg_best = demo*pre_p_demo_ineg_best

mi passive : gen acemoglu2_ineg_best = acemoglu_demo2*pre_demo_ineg_best

mi passive : gen acemoglu_pre_auto_ineg_best = acemoglu_auto*pre_auto_ineg_best

mi passive : gen boix_demo_pre_demo_ineg = pre_demo_ineg_boix*boix_demo

mi passive : gen acemoglu_pre_ineg_bestMar = acemoglu_demo*pre_demo_ineg_bestMar

mi passive : gen  chga_pre_chga_ineg = chga_demo*pre_chga_ineg 

mi passive : gen demo_pre_demo_ineg = demo*pre_demo_ineg

mi passive:  gen ginet_polity2 = L.solt_ginet*p_polity2


***code regions


** The regions: 1. Eastern Europe and post Soviet Union, 2. latin America, 3. North Africa and Middle East, 4. Sub-Saharan Africa, 
** 5. Western Europe and North America, 6. East Asia, 7. South-East Asia, 8. South Asia, 9. The Pacific, and 10. The Caribbean.



********************************* regional variables 
 

bys ht_region year : egen region_civilwar = mean(civil_war2) 
bys ht_region year : egen region_civilwar3 = mean(civil_war3) 

sort ccode year

 
save "democratic_outcomes_MI2.dta", replace

*******merge with the "fiscal capacity" dataset

clear

use "tax_data_RPC_v2.1_2013.dta"

rename cowcode  ccodecow

drop imfcode trccode uncode country

sort ccodecow  year

save tax.dta, replace

clear

use "democratic_outcomes_MI2.dta"

drop _merge

sort ccodecow year

merge ccodecow year using "tax.dta"

drop _merge

drop if ccode==.

sort ccode year

save "democratic_outcomes_MI2.dta", replace



******USSR and Warsaw pact dummies

	/* The original signatories to the Warsaw Treaty Organization were the Soviet Union, Albania, Poland, 
	Czechoslovakia, Hungary, Bulgaria, Romania, and the German Democratic Republic. */
	
	/* Former Soviet Union countries: Russia, Ukraine, Uzbekistan, Kazakhstan, Belarus, Azerbaijan, Georgia, Tajikistan,
	Moldova, Kyrgyzstan, Lithaunia, Turkmensitan, Armenia, Latvia, Estonia */
	
	generate warsaw = 0 
	replace warsaw = 1 if ccode == 8
	replace warsaw = 1 if ccode == 100
	replace warsaw = 1 if ccode == 200
	replace warsaw = 1 if ccode == 203
	replace warsaw = 1 if ccode == 278
	replace warsaw = 1 if ccode == 348
	replace warsaw = 1 if ccode == 616
	replace warsaw = 1 if ccode == 642
	replace warsaw = 1 if ccode == 810
	
	generate ussr = 0
	replace ussr = 1 if ccode == 51
	replace ussr = 1 if ccode == 31
	replace ussr = 1 if ccode == 112
	replace ussr = 1 if ccode == 233
	replace ussr = 1 if ccode == 268
	replace ussr = 1 if ccode == 398
	replace ussr = 1 if ccode == 417
	replace ussr = 1 if ccode == 428
	replace ussr = 1 if ccode == 440
	replace ussr = 1 if ccode == 498
	replace ussr = 1 if ccode == 643
	replace ussr = 1 if ccode == 762
	replace ussr = 1 if ccode == 795
	replace ussr = 1 if ccode == 804
	replace ussr = 1 if ccode == 860




**************************  Generating regime type dummies ****************************************
/* wr_regtype
(1) Indirect military
(2) Military
(3) Military-Personal
(4) Monarchy
(5) Oligarchy
(6) Party
(7) Party-Military
(8) Party-Military-Personal
(9) Party-Personal
(10) Personal
*/

/* wr_nonautocracy
(1) Democracy
(2) Foreign-Occupied
(3) Not-Independent
(4) Provisional
(5) Warlord
(6) Warlord/Foreign-occupied
*/

***  Here we code as 0 even if wr_regtype is missing, essentially assuming that missing are nonautocracy  ***

gen military = 0 if acemoglu_demo !=.
replace military = 1 if wr_regtype == 1 & acemoglu_demo == 0
replace military = 1 if wr_regtype == 2 & acemoglu_demo == 0 
replace military = 1 if wr_regtype == 3 & acemoglu_demo == 0 


gen monarchy = 0 if acemoglu_demo !=.
replace monarchy =1 if wr_regtype == 4 & acemoglu_demo == 0
replace monarchy =1 if wr_regtype == 5 & acemoglu_demo == 0

gen party = 0 if acemoglu_demo!=.
replace party =1 if wr_regtype == 6 & acemoglu_demo == 0
replace party =1 if wr_regtype == 7 & acemoglu_demo == 0
replace party =1 if wr_regtype == 8 & acemoglu_demo == 0
replace party =1 if wr_regtype == 9 & acemoglu_demo == 0

gen personal =0 if acemoglu_demo !=.
replace personal = 1 if wr_regtype == 10 & acemoglu_demo == 0

*military monarchy party

mi passive: gen acemoglu_demo_military = acemoglu_demo*L.military
mi passive: gen acemoglu_demo_monarchy = acemoglu_demo*L.monarchy
mi passive: gen acemoglu_demo_party = acemoglu_demo*L.party
mi passive: gen acemoglu_demo_personal = acemoglu_demo*L.personal

save "democratic_outcomes_MI2.dta", replace

  
clear

*******use the machine learning indicator of krieger

use "Krieger_machine_learning_EJPE.dta"

gen ccodealp = iso

replace ccodealp="BWA" if iso=="BOT"
replace ccodealp="CMR" if iso=="CAM"
replace ccodealp="COG" if iso=="KON"
replace ccodealp="CSK" if iso=="CSR"
replace ccodealp="DNK" if iso=="DEN"
replace ccodealp="EGY" if iso=="EYP"
replace ccodealp="DEU" if iso=="GER"
replace ccodealp="GRC" if iso=="GRE"
replace ccodealp="IRL" if iso=="IRE"
replace ccodealp="LVA" if iso=="LAT"
replace ccodealp="LBN" if iso=="LEB"
replace ccodealp="LBY" if iso=="LYB"
replace ccodealp="SYC" if iso=="SEY"
replace ccodealp="SVN" if iso=="SLO"
replace ccodealp="TWN" if iso=="ROC"
replace ccodealp="SUN" if iso=="USR"
replace ccodealp="ZMB" if iso=="ZAM"

sort ccodealp year

drop iso

save "Krieger_EJPE_merge.dta", replace

clear

use "democratic_outcomes_MI2.dta"



sort ccodealp year

merge ccodealp year using "Krieger_EJPE_merge.dta"

drop _merge
drop if ccode==.

sort ccode year

gen demo_machine = 1 if svmdi>=0.50 & svmdi!=.
replace demo_machine = 0 if svmdi<0.5 & svmdi!=.

mi passive : gen pre_demo_ineg_b_m = L5.solt_ginet if demo_machine==0 & F.demo_machine==1
mi passive : replace pre_demo_ineg_b_m = L4.solt_ginet if demo_machine==0 & F.demo_machine==1 & L5.solt_ginet==.
mi passive : replace pre_demo_ineg_b_m = L3.solt_ginet if demo_machine==0 & F.demo_machine==1 & L5.solt_ginet==. & L4.solt_ginet==.
mi passive : replace pre_demo_ineg_b_m = L2.solt_ginet if demo_machine==0 & F.demo_machine==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==.
mi passive : replace pre_demo_ineg_b_m = L.solt_ginet if demo_machine==0 & F.demo_machine==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==.
mi passive : replace pre_demo_ineg_b_m = solt_ginet if demo_machine==0 & F.demo_machine==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==. & L.solt_ginet==.
mi passive : replace pre_demo_ineg_b_m = F.solt_ginet if demo_machine==0 & F.demo_machine==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==. & L.solt_ginet==. & solt_ginet==.

mi passive : replace pre_demo_ineg_b_m = L.pre_demo_ineg_b_m if demo_machine!=0

mi passive : replace pre_demo_ineg_b_m = solt_ginet if pre_demo_ineg_b_m == .

mi passive : gen demo_machine_pre_ineg_b_m = demo_machine*pre_demo_ineg_b_m

mi passive : gen svmdi_L5ginet = svmdi*L5.solt_ginet

gen demo_machine2 = 1 if svmdi>=0.75 & svmdi!=.
replace demo_machine2 = 0 if svmdi<0.75 & svmdi!=.

mi passive : gen pre_demo_ineg_b_m2 = L5.solt_ginet if demo_machine2==0 & F.demo_machine2==1
mi passive : replace pre_demo_ineg_b_m2 = L4.solt_ginet if demo_machine2==0 & F.demo_machine2==1 & L5.solt_ginet==.
mi passive : replace pre_demo_ineg_b_m2 = L3.solt_ginet if demo_machine2==0 & F.demo_machine2==1 & L5.solt_ginet==. & L4.solt_ginet==.
mi passive : replace pre_demo_ineg_b_m2 = L2.solt_ginet if demo_machine2==0 & F.demo_machine2==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==.
mi passive : replace pre_demo_ineg_b_m2 = L.solt_ginet if demo_machine2==0 & F.demo_machine2==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==.
mi passive : replace pre_demo_ineg_b_m2 = solt_ginet if demo_machine2==0 & F.demo_machine2==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==. & L.solt_ginet==.
mi passive : replace pre_demo_ineg_b_m2 = F.solt_ginet if demo_machine2==0 & F.demo_machine2==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==. & L.solt_ginet==. & solt_ginet==.

mi passive : replace pre_demo_ineg_b_m2 = L.pre_demo_ineg_b_m2 if demo_machine2!=0

mi passive : replace pre_demo_ineg_b_m2 = solt_ginet if pre_demo_ineg_b_m2 == .

mi passive : gen demo_machine2_pre_ineg_b_m2 = demo_machine2*pre_demo_ineg_b_m2


mi passive : gen demo_machine_lginet = demo_machine*L.solt_ginet


sort ccode year

save "democratic_outcomes_MI2.dta", replace

save "final_dataset_MI.dta", replace





 

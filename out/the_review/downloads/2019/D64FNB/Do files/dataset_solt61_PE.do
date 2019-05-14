capture clear
capture log close
*set memory 400m
*set more off
set matsize 4000
set 


********path

cap cd "C:\Users\paul\Dropbox\Institutions\democracy_and_economic_outcomes\file_APSR\DataReplicationFiles\Data files"

cap cd "/Users/dorschm/Dropbox/Research/Institutions/democracy_and_economic_outcomes/file_APSR/DataReplicationFiles/Data files"


*****merge median imputed data with other data sources

use "solt_61_median_2.dta"
sort cname year
save, replace
clear

use "QoG_std_ts_20dec13"

rename solt_ginet solt_ginet2
rename solt_ginmar solt_ginmar2
rename solt_redist solt_redist2

sort cname year
 

merge cname year using "solt_61_median_2.dta"

rename median_gini_disp solt_ginet 
rename median_gini_mkt solt_ginmar

gen solt_redist = solt_ginmar - solt_ginet

drop _merge
drop if ccode==.

sort ccode year

tsset ccode year

save "democratic_outcomes_median_2.dta", replace
clear

***************merge with BOIX

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

use "democratic_outcomes_median_2.dta"

sort ccodecow year


merge ccodecow year using "BoixMillerRosato_Dem_Merge.dta"


sort ccode year

drop _merge

drop if ccode==.

save "democratic_outcomes_median_2.dta", replace


******************* 5 and 1O years panel

gen fiveyears=1 if year==1955| year==1960| year==1965| year==1970| year==1975| year==1980| year==1985| year==1990| year==1995| year==2000| year==2005| year==2010

gen tenyears=1 if year==1955| year==1965| year==1975| year==1985| year==1995| year==2005



*******************democratization variables

****acemoglu & al (2015) index

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


****acemoglu & al (2015) with a more restrictive criteria


gen acemoglu_demo2=1 if p_polity2>4 & (fh_status==2 | fh_status==1)

replace acemoglu_demo2=0 if (p_polity2<=4 & p_polity2!=.) | fh_status==3

replace acemoglu_demo2=1 if p_polity2>4 &  p_polity2!=.  & fh_status==. & chga_demo==1

replace acemoglu_demo2=1 if (fh_status==2 | fh_status==1) & p_polity2==. & chga_demo==1
 
replace acemoglu_demo2=0 if p_polity2>4 & fh_status==. & chga_demo==0

replace acemoglu_demo2=0 if (fh_status==2 | fh_status==1 | fh_status==.) & p_polity2==. & chga_demo==0



*****other democracy indicators using the Polity2 index 


gen demo=1 if p_polity2>0 & p_polity2!=.

replace demo=0 if p_polity2<=0 & p_polity2!=.

gen demo2=1 if p_polity2>4 & p_polity2!=.

replace demo2=0 if p_polity2<=4 & p_polity2!=.


****************************************************redistribution variable 

gen redist = solt_ginmar - solt_ginet


*******************simple interaction with inequality


gen acemoglu_demo_Lginet = acemoglu_demo*l.solt_ginet

gen acemoglu_demo_L5ginet = acemoglu_demo*l5.solt_ginet


************** GDP variables 

gen log_gdp = log(pwt_rgdpch)

gen log_gdp_wdi = log(wdi_gdpc)





***************Define the initial degree of income inequality

**** inegality at the time of democratization

gen pre_demo_ineg_0 = solt_ginet if acemoglu_demo==1 & L.acemoglu_demo==0

replace pre_demo_ineg_0 = L.pre_demo_ineg_0 if acemoglu_demo!=0

replace pre_demo_ineg_0 = solt_ginet if pre_demo_ineg_0 == .

****1 an avant democratization

gen pre_demo_ineg = solt_ginet if acemoglu_demo==0 & F.acemoglu_demo==1

replace pre_demo_ineg = L.pre_demo_ineg if acemoglu_demo!=0

replace pre_demo_ineg = solt_ginet if pre_demo_ineg == .


******* generating the inequality level before democratization taking inequality 5 years before or, if not available, 4, 3, 2, 1 or 0 years before

gen pre_demo_ineg_best = L5.solt_ginet if acemoglu_demo==0 & F.acemoglu_demo==1
replace pre_demo_ineg_best = L4.solt_ginet if acemoglu_demo==0 & F.acemoglu_demo==1 & L5.solt_ginet==.
replace pre_demo_ineg_best = L3.solt_ginet if acemoglu_demo==0 & F.acemoglu_demo==1 & L5.solt_ginet==. & L4.solt_ginet==.
replace pre_demo_ineg_best = L2.solt_ginet if acemoglu_demo==0 & F.acemoglu_demo==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==.
replace pre_demo_ineg_best = L.solt_ginet if acemoglu_demo==0 & F.acemoglu_demo==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==.
replace pre_demo_ineg_best = solt_ginet if acemoglu_demo==0 & F.acemoglu_demo==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==. & L.solt_ginet==.
replace pre_demo_ineg_best = F.solt_ginet if acemoglu_demo==0 & F.acemoglu_demo==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==. & L.solt_ginet==. & solt_ginet==.

replace pre_demo_ineg_best = L.pre_demo_ineg_best if acemoglu_demo!=0

replace pre_demo_ineg_best = solt_ginet if pre_demo_ineg_best == .



******generating ten years change

gen post_demo_ineg_best = F5.solt_ginet if acemoglu_demo==0 & F.acemoglu_demo==1
replace post_demo_ineg_best = F4.solt_ginet if acemoglu_demo==0 & F.acemoglu_demo==1 & F5.solt_ginet==.
replace post_demo_ineg_best = F3.solt_ginet if acemoglu_demo==0 & F.acemoglu_demo==1 & F5.solt_ginet==. & F4.solt_ginet==.
replace post_demo_ineg_best = F2.solt_ginet if acemoglu_demo==0 & F.acemoglu_demo==1 & F5.solt_ginet==. & F4.solt_ginet==. & F3.solt_ginet==.
replace post_demo_ineg_best = F.solt_ginet if acemoglu_demo==0 & F.acemoglu_demo==1 & F5.solt_ginet==. & F4.solt_ginet==. & F3.solt_ginet==. & F2.solt_ginet==.
replace post_demo_ineg_best = solt_ginet if acemoglu_demo==0 & F.acemoglu_demo==1 & F5.solt_ginet==. & F4.solt_ginet==. & F3.solt_ginet==. & F2.solt_ginet==. & F.solt_ginet==.


replace post_demo_ineg_best = F.post_demo_ineg_best if acemoglu_demo!=0

replace post_demo_ineg_best = solt_ginet if post_demo_ineg_best == .

generate change_ineq = post_demo_ineg_best-pre_demo_ineg_best


gen post10_demo_ineg_best = F10.solt_ginet if acemoglu_demo==0 & F.acemoglu_demo==1
replace post10_demo_ineg_best = F9.solt_ginet if acemoglu_demo==0 & F.acemoglu_demo==1 & F10.solt_ginet==.
replace post10_demo_ineg_best = F8.solt_ginet if acemoglu_demo==0 & F.acemoglu_demo==1 & F10.solt_ginet==. & F9.solt_ginet==.
replace post10_demo_ineg_best = F7.solt_ginet if acemoglu_demo==0 & F.acemoglu_demo==1 & F10.solt_ginet==. & F9.solt_ginet==. & F8.solt_ginet==.
replace post10_demo_ineg_best = F6.solt_ginet if acemoglu_demo==0 & F.acemoglu_demo==1 & F10.solt_ginet==. & F9.solt_ginet==. & F8.solt_ginet==. & F7.solt_ginet==.
replace post10_demo_ineg_best = post_demo_ineg_best if acemoglu_demo==0 & F.acemoglu_demo==1 & F10.solt_ginet==. & F9.solt_ginet==. & F8.solt_ginet==. & F7.solt_ginet==. & F6.solt_ginet==.


replace post10_demo_ineg_best = F.post10_demo_ineg_best if acemoglu_demo!=0

generate change10_ineq = post10_demo_ineg_best-pre_demo_ineg_best



******* generating the market inequality level before democratization taking inequality 5 years before or, if not, 4, 3, 2, 1 or 0 years before

gen pre_demo_ineg_bestMar = L5.solt_ginmar if acemoglu_demo==0 & F.acemoglu_demo==1
replace pre_demo_ineg_bestMar = L4.solt_ginmar if acemoglu_demo==0 & F.acemoglu_demo==1 & L5.solt_ginmar==.
replace pre_demo_ineg_bestMar = L3.solt_ginmar if acemoglu_demo==0 & F.acemoglu_demo==1 & L5.solt_ginmar==. & L4.solt_ginmar==.
replace pre_demo_ineg_bestMar = L2.solt_ginmar if acemoglu_demo==0 & F.acemoglu_demo==1 & L5.solt_ginmar==. & L4.solt_ginmar==. & L3.solt_ginmar==.
replace pre_demo_ineg_bestMar = L.solt_ginmar if acemoglu_demo==0 & F.acemoglu_demo==1 & L5.solt_ginmar==. & L4.solt_ginmar==. & L3.solt_ginmar==. & L2.solt_ginmar==.
replace pre_demo_ineg_bestMar = solt_ginmar if acemoglu_demo==0 & F.acemoglu_demo==1 & L5.solt_ginmar==. & L4.solt_ginmar==. & L3.solt_ginmar==. & L2.solt_ginmar==. & L.solt_ginmar==.
replace pre_demo_ineg_bestMar = F.solt_ginmar if acemoglu_demo==0 & F.acemoglu_demo==1 & L5.solt_ginmar==. & L4.solt_ginmar==. & L3.solt_ginmar==. & L2.solt_ginmar==. & L.solt_ginmar==. & solt_ginmar==.

replace pre_demo_ineg_bestMar = L.pre_demo_ineg_bestMar if acemoglu_demo!=0

replace pre_demo_ineg_bestMar = solt_ginmar if pre_demo_ineg_bestMar == .

****generate ten years change

gen post_demo_ineg_bestMar = F5.solt_ginmar if acemoglu_demo==0 & F.acemoglu_demo==1
replace post_demo_ineg_bestMar = F4.solt_ginmar if acemoglu_demo==0 & F.acemoglu_demo==1 & F5.solt_ginmar==.
replace post_demo_ineg_bestMar = F3.solt_ginmar if acemoglu_demo==0 & F.acemoglu_demo==1 & F5.solt_ginmar==. & F4.solt_ginmar==.
replace post_demo_ineg_bestMar = F2.solt_ginmar if acemoglu_demo==0 & F.acemoglu_demo==1 & F5.solt_ginmar==. & F4.solt_ginmar==. & F3.solt_ginmar==.
replace post_demo_ineg_bestMar = F.solt_ginmar if acemoglu_demo==0 & F.acemoglu_demo==1 & F5.solt_ginmar==. & F4.solt_ginmar==. & F3.solt_ginmar==. & F2.solt_ginmar==.
replace post_demo_ineg_bestMar = solt_ginmar if acemoglu_demo==0 & F.acemoglu_demo==1 & F5.solt_ginmar==. & F4.solt_ginmar==. & F3.solt_ginmar==. & F2.solt_ginmar==. & F.solt_ginmar==.


replace post_demo_ineg_bestMar = F.post_demo_ineg_bestMar if acemoglu_demo!=0

replace post_demo_ineg_bestMar = solt_ginmar if post_demo_ineg_bestMar == .

generate change_ineqMar = post_demo_ineg_bestMar-pre_demo_ineg_bestMar


gen post10_demo_ineg_bestMar = F10.solt_ginmar if acemoglu_demo==0 & F.acemoglu_demo==1
replace post10_demo_ineg_bestMar = F9.solt_ginmar if acemoglu_demo==0 & F.acemoglu_demo==1 & F10.solt_ginmar==.
replace post10_demo_ineg_bestMar = F8.solt_ginmar if acemoglu_demo==0 & F.acemoglu_demo==1 & F10.solt_ginmar==. & F9.solt_ginmar==.
replace post10_demo_ineg_bestMar = F7.solt_ginmar if acemoglu_demo==0 & F.acemoglu_demo==1 & F10.solt_ginmar==. & F9.solt_ginmar==. & F8.solt_ginmar==.
replace post10_demo_ineg_bestMar = F6.solt_ginmar if acemoglu_demo==0 & F.acemoglu_demo==1 & F10.solt_ginmar==. & F9.solt_ginmar==. & F8.solt_ginmar==. & F7.solt_ginmar==.
replace post10_demo_ineg_bestMar = post_demo_ineg_bestMar if acemoglu_demo==0 & F.acemoglu_demo==1 & F10.solt_ginmar==. & F9.solt_ginmar==. & F8.solt_ginmar==. & F7.solt_ginmar==. & F6.solt_ginmar==.


replace post10_demo_ineg_bestMar = F.post10_demo_ineg_bestMar if acemoglu_demo!=0

generate change10_ineqMar = post10_demo_ineg_bestMar-pre_demo_ineg_bestMar

generate PCchange10_ineqMar = ((post10_demo_ineg_bestMar-pre_demo_ineg_bestMar)/pre_demo_ineg_bestMar)*100


********** generating the inequality level before democratization taking inequality 5 years before or, if not, 4, 3, 2, 1 or 0 years before using the simple polity2 indicator


gen pre_p_demo_ineg_best = L5.solt_ginet if demo==0 & F.demo==1
replace pre_p_demo_ineg_best = L4.solt_ginet if demo==0 & F.demo==1 & L5.solt_ginet==.
 replace pre_p_demo_ineg_best = L3.solt_ginet if demo==0 & F.demo==1 & L5.solt_ginet==. & L4.solt_ginet==.
 replace pre_p_demo_ineg_best = L2.solt_ginet if demo==0 & F.demo==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==.
 replace pre_p_demo_ineg_best = L.solt_ginet if demo==0 & F.demo==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==.
 replace pre_p_demo_ineg_best = solt_ginet if demo==0 & F.demo==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==. & L.solt_ginet==.
 replace pre_p_demo_ineg_best = F.solt_ginet if demo==0 & F.demo==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==. & L.solt_ginet==. & solt_ginet==.

 replace pre_p_demo_ineg_best = L.pre_p_demo_ineg_best if demo!=0

 replace pre_p_demo_ineg_best = solt_ginet if pre_p_demo_ineg_best == .



*** with the boix indicator

gen pre_demo_ineg_boix = L5.solt_ginet if boix_demo==0 & F.boix_demo==1
replace pre_demo_ineg_boix = L4.solt_ginet if boix_demo==0 & F.boix_demo==1 & L5.solt_ginet==.
replace pre_demo_ineg_boix = L3.solt_ginet if boix_demo==0 & F.boix_demo==1 & L5.solt_ginet==. & L4.solt_ginet==.
replace pre_demo_ineg_boix = L2.solt_ginet if boix_demo==0 & F.boix_demo==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==.
replace pre_demo_ineg_boix = L.solt_ginet if boix_demo==0 & F.boix_demo==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==.
replace pre_demo_ineg_boix = solt_ginet if boix_demo==0 & F.boix_demo==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==. & L.solt_ginet==.
replace pre_demo_ineg_boix = F.solt_ginet if boix_demo==0 & F.boix_demo==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==. & L.solt_ginet==. & solt_ginet==.

replace pre_demo_ineg_boix = L.pre_demo_ineg_boix if boix_demo!=0

replace pre_demo_ineg_boix = solt_ginet if pre_demo_ineg_boix == .



********  for democratic reversals using the acemoglu democratization indicator  *********

gen pre_auto_ineg_best = L5.solt_ginet if acemoglu_auto==0 & F.acemoglu_auto==1
replace pre_auto_ineg_best = L4.solt_ginet if acemoglu_auto==0 & F.acemoglu_auto==1 & L5.solt_ginet==.
replace pre_auto_ineg_best = L3.solt_ginet if acemoglu_auto==0 & F.acemoglu_auto==1 & L5.solt_ginet==. & L4.solt_ginet==.
replace pre_auto_ineg_best = L2.solt_ginet if acemoglu_auto==0 & F.acemoglu_auto==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==.
replace pre_auto_ineg_best = L.solt_ginet if acemoglu_auto==0 & F.acemoglu_auto==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==.
replace pre_auto_ineg_best = solt_ginet if acemoglu_auto==0 & F.acemoglu_auto==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==. & L.solt_ginet==.
replace pre_auto_ineg_best = F.solt_ginet if acemoglu_auto==0 & F.acemoglu_auto==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==. & L.solt_ginet==. & solt_ginet==.

replace pre_auto_ineg_best = L.pre_auto_ineg_best if acemoglu_auto!=0

replace pre_auto_ineg_best = solt_ginet if pre_auto_ineg_best == .



*************** for alternative democracy indicators  ***

****with the polity 2 - more restrictive criteria

gen pre_demo2_ineg = L5.solt_ginet if demo2==0 & F.demo2==1
replace pre_demo2_ineg = L4.solt_ginet if demo2==0 & F.demo2==1 & L5.solt_ginet==.
replace pre_demo2_ineg = L3.solt_ginet if demo2==0 & F.demo2==1 & L5.solt_ginet==. & L4.solt_ginet==.
replace pre_demo2_ineg = L2.solt_ginet if demo2==0 & F.demo2==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==.
replace pre_demo2_ineg = L.solt_ginet if demo2==0 & F.demo2==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==.
replace pre_demo2_ineg = solt_ginet if demo2==0 & F.demo2==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==. & L.solt_ginet==.
replace pre_demo2_ineg = F.solt_ginet if demo2==0 & F.demo2==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==. & L.solt_ginet==. & solt_ginet==.

replace pre_demo2_ineg = L.pre_demo2_ineg if demo2!=0
replace pre_demo2_ineg = solt_ginet if pre_demo2_ineg == .

*******with the CHGA indicator

gen pre_chga_ineg = L5.solt_ginet if chga_demo==0 & F.chga_demo==1
replace pre_chga_ineg = L4.solt_ginet if chga_demo==0 & F.chga_demo==1 & L5.solt_ginet==.
replace pre_chga_ineg = L3.solt_ginet if chga_demo==0 & F.chga_demo==1 & L5.solt_ginet==. & L4.solt_ginet==.
replace pre_chga_ineg = L2.solt_ginet if chga_demo==0 & F.chga_demo==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==.
replace pre_chga_ineg = L.solt_ginet if chga_demo==0 & F.chga_demo==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==.
replace pre_chga_ineg = solt_ginet if chga_demo==0 & F.chga_demo==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==. & L.solt_ginet==.
replace pre_chga_ineg = F.solt_ginet if chga_demo==0 & F.chga_demo==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==. & L.solt_ginet==. & solt_ginet==.

replace pre_chga_ineg = L.pre_demo2_ineg if chga_demo!=0
replace pre_chga_ineg = solt_ginet if pre_chga_ineg == .


***** generating a placebo with civil war *******

generate civil_war2 = 0 if  ucdp_type3!=.
replace civil_war2 = 1 if ucdp_type3 == 2
replace civil_war2 = 1 if ucdp_type3 == 3

generate civil_war3 = 0
replace civil_war3 = 1 if ucdp_type3 == 3

gen pre_civil_ineg_best = L5.solt_ginet if civil_war2==0 & F.civil_war2==1
replace pre_civil_ineg_best = L4.solt_ginet if civil_war2==0 & F.civil_war2==1 & L5.solt_ginet==.
replace pre_civil_ineg_best = L3.solt_ginet if civil_war2==0 & F.civil_war2==1 & L5.solt_ginet==. & L4.solt_ginet==.
replace pre_civil_ineg_best = L2.solt_ginet if civil_war2==0 & F.civil_war2==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==.
replace pre_civil_ineg_best = L.solt_ginet if civil_war2==0 & F.civil_war2==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==.
replace pre_civil_ineg_best = solt_ginet if civil_war2==0 & F.civil_war2==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==. & L.solt_ginet==.
replace pre_civil_ineg_best = F.solt_ginet if civil_war2==0 & F.civil_war2==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==. & L.solt_ginet==. & solt_ginet==.

replace pre_civil_ineg_best = L.pre_civil_ineg_best if civil_war2!=0

replace pre_civil_ineg_best = solt_ginet if pre_civil_ineg_best == .

** with more severe threshold for defining civil war **


gen pre_civil3_ineg_best = L5.solt_ginet if civil_war3==0 & F.civil_war3==1
replace pre_civil3_ineg_best = L4.solt_ginet if civil_war3==0 & F.civil_war3==1 & L5.solt_ginet==.
replace pre_civil3_ineg_best = L3.solt_ginet if civil_war3==0 & F.civil_war3==1 & L5.solt_ginet==. & L4.solt_ginet==.
replace pre_civil3_ineg_best = L2.solt_ginet if civil_war3==0 & F.civil_war3==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==.
replace pre_civil3_ineg_best = L.solt_ginet if civil_war3==0 & F.civil_war3==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==.
replace pre_civil3_ineg_best = solt_ginet if civil_war3==0 & F.civil_war3==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==. & L.solt_ginet==.
replace pre_civil3_ineg_best = F.solt_ginet if civil_war3==0 & F.civil_war3==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==. & L.solt_ginet==. & solt_ginet==.

replace pre_civil3_ineg_best = L.pre_civil3_ineg_best if civil_war3!=0

replace pre_civil3_ineg_best = solt_ginet if pre_civil3_ineg_best == .

**** generating placebo with leads  *****

generate plac_lead5 = L5.acemoglu_demo
generate plac_lead10 = L10.acemoglu_demo
generate plac_lead15 = L15.acemoglu_demo


gen pre_lead5_ineg_best = L5.solt_ginet if plac_lead5==0 & F.plac_lead5==1
replace pre_lead5_ineg_best = L4.solt_ginet if plac_lead5==0 & F.plac_lead5==1 & L5.solt_ginet==.
replace pre_lead5_ineg_best = L3.solt_ginet if plac_lead5==0 & F.plac_lead5==1 & L5.solt_ginet==. & L4.solt_ginet==.
replace pre_lead5_ineg_best = L2.solt_ginet if plac_lead5==0 & F.plac_lead5==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==.
replace pre_lead5_ineg_best = L.solt_ginet if plac_lead5==0 & F.plac_lead5==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==.
replace pre_lead5_ineg_best = solt_ginet if plac_lead5==0 & F.plac_lead5==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==. & L.solt_ginet==.
replace pre_lead5_ineg_best = F.solt_ginet if plac_lead5==0 & F.plac_lead5==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==. & L.solt_ginet==. & solt_ginet==.

replace pre_lead5_ineg_best = L.pre_lead5_ineg_best if plac_lead5!=0
replace pre_lead5_ineg_best = solt_ginet if pre_lead5_ineg_best == .


gen pre_lead10_ineg_best = L5.solt_ginet if plac_lead10==0 & F.plac_lead10==1
replace pre_lead10_ineg_best = L4.solt_ginet if plac_lead10==0 & F.plac_lead10==1 & L5.solt_ginet==.
replace pre_lead10_ineg_best = L3.solt_ginet if plac_lead10==0 & F.plac_lead10==1 & L5.solt_ginet==. & L4.solt_ginet==.
replace pre_lead10_ineg_best = L2.solt_ginet if plac_lead10==0 & F.plac_lead10==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==.
replace pre_lead10_ineg_best = L.solt_ginet if plac_lead10==0 & F.plac_lead10==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==.
replace pre_lead10_ineg_best = solt_ginet if plac_lead10==0 & F.plac_lead10==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==. & L.solt_ginet==.
replace pre_lead10_ineg_best = F.solt_ginet if plac_lead10==0 & F.plac_lead10==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==. & L.solt_ginet==. & solt_ginet==.

replace pre_lead10_ineg_best = L.pre_lead10_ineg_best if plac_lead10!=0
replace pre_lead10_ineg_best = solt_ginet if pre_lead10_ineg_best == .


gen pre_lead15_ineg_best = L5.solt_ginet if plac_lead15==0 & F.plac_lead15==1
replace pre_lead15_ineg_best = L4.solt_ginet if plac_lead15==0 & F.plac_lead15==1 & L5.solt_ginet==.
replace pre_lead15_ineg_best = L3.solt_ginet if plac_lead15==0 & F.plac_lead15==1 & L5.solt_ginet==. & L4.solt_ginet==.
replace pre_lead15_ineg_best = L2.solt_ginet if plac_lead15==0 & F.plac_lead15==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==.
replace pre_lead15_ineg_best = L.solt_ginet if plac_lead15==0 & F.plac_lead15==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==.
replace pre_lead15_ineg_best = solt_ginet if plac_lead15==0 & F.plac_lead15==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==. & L.solt_ginet==.
replace pre_lead15_ineg_best = F.solt_ginet if plac_lead15==0 & F.plac_lead15==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==. & L.solt_ginet==. & solt_ginet==.

replace pre_lead15_ineg_best = L.pre_lead15_ineg_best if plac_lead15!=0
replace pre_lead15_ineg_best = solt_ginet if pre_lead15_ineg_best == .



********** generate interaction with the fixed income inequality degree 

gen acemoglu_demo_pre_demo_ineg_0 = acemoglu_demo*pre_demo_ineg_0

gen acemoglu_demo_pre_demo_ineg_best = acemoglu_demo*pre_demo_ineg_best

gen acemoglu_demo2_ineg_best = acemoglu_demo2*pre_demo_ineg_best

gen acemoglu_auto_pre_demo_ineg_best = acemoglu_auto*pre_auto_ineg_best

gen p_demo_pre_ineg_best = demo*pre_p_demo_ineg_best

gen boix_demo_pre_demo_ineg = pre_demo_ineg_boix*boix_demo

gen acemoglu_demo_pre_ineg_bestMar = acemoglu_demo*pre_demo_ineg_bestMar

gen  chga_pre_chga_ineg=chga_demo*pre_chga_ineg 

gen demo_pre_demo_ineg = demo*pre_demo_ineg

xi: gen ginet_polity2 = L.solt_ginet*p_polity2


*******************************************************************
*********************************generate instruments - democratization episode in the region -Acemoglu et al index of democratization
*******************************************************************

gen demo_initial = acemoglu_demo if acemoglu_demo!=. & L.acemoglu_demo==.

replace demo_initial = L.demo_initial if L.demo_initial!=.
 
forvalues i = 1/100 {
    replace demo_initial = F.demo_initial if demo_initial==.
local i=`i'+1
} 
*}

bys ht_region year : egen n_non_demo = sum(demo_initial==0) 

bys ht_region year : egen n_demo = sum(demo_initial==1)

bys ht_region year demo_initial : egen sum_d = sum(acemoglu_demo==1)


gen neighbour_demo = (1/(n_non_demo - 1))*(sum_d  - acemoglu_demo) if demo_initial==0
replace neighbour_demo = (1/(n_demo - 1))*(sum_d  - acemoglu_demo) if demo_initial==1

bys ht_region year: egen region_neighbour_demo = mean(neighbour_demo)

bys ht_region year: egen region_acemoglu_demo = mean(acemoglu_demo)

xtline region_neighbour_demo, overlay i(ht_region) t(year)

scatter neighbour_demo acemoglu_demo

xi: xtreg  acemoglu_demo neighbour_demo i.year, fe

sort ccode year

*********************************generate instruments - democratization episode in the region using the polity variable
*******************************************************************


gen p_demo_initial = demo if demo!=. & L.demo==.

replace p_demo_initial = L.p_demo_initial if L.p_demo_initial!=.
 
forvalues i = 1/100 {
    replace p_demo_initial = F.p_demo_initial if p_demo_initial==.
local i=`i'+1
} 
*}

bys ht_region year : egen p_n_non_demo = sum(p_demo_initial==0) 

bys ht_region year : egen p_n_demo = sum(p_demo_initial==1)

bys ht_region year p_demo_initial : egen p_sum_d = sum(demo==1)


gen p_neighbour_demo = (1/(p_n_non_demo - 1))*(p_sum_d  - demo) if p_demo_initial==0
replace p_neighbour_demo = (1/(p_n_demo - 1))*(p_sum_d  - demo) if p_demo_initial==1

bys ht_region year: egen p_region_neighbour_demo = mean(p_neighbour_demo)

bys ht_region year: egen region_p_demo = mean(demo)

xi: xtreg  demo p_neighbour_demo i.year, fe

sort ccode year

**********with the more restrictive criteria

gen p_demo_initial2 = demo2 if demo2!=. & L.demo2==.

replace p_demo_initial2 = L.p_demo_initial2 if L.p_demo_initial2!=.
 
forvalues i = 1/100 {
    replace p_demo_initial2 = F.p_demo_initial2 if p_demo_initial2==.
local i=`i'+1
} 
*}

bys ht_region year : egen p_n_non_demo2 = sum(p_demo_initial2==0) 

bys ht_region year : egen p_n_demo2 = sum(p_demo_initial2==1)

bys ht_region year p_demo_initial2 : egen p_sum_d2 = sum(demo2==1)


gen p_neighbour_demo2 = (1/(p_n_non_demo2 - 1))*(p_sum_d2  - demo2) if p_demo_initial2==0
replace p_neighbour_demo2 = (1/(p_n_demo2 - 1))*(p_sum_d2  - demo2) if p_demo_initial2==1

bys ht_region year: egen p_region_neighbour_demo2 = mean(p_neighbour_demo2)

bys ht_region year: egen region_p_demo2 = mean(demo2)

xi: xtreg  demo2 p_neighbour_demo2 i.year, fe

sort ccode year


********for the Acemoglu_demo et al index using a more restrictive criteria


gen demo_initial2 = acemoglu_demo2 if acemoglu_demo2!=. & L.acemoglu_demo2==.

replace demo_initial2 = L.demo_initial2 if L.demo_initial2!=.
 
forvalues i = 1/100 {
    replace demo_initial2 = F.demo_initial2 if demo_initial2==.
local i=`i'+1
} 
*}

bys ht_region year : egen n_non_demo2 = sum(demo_initial2==0) 

bys ht_region year : egen n_demo2 = sum(demo_initial2==1)

bys ht_region year demo_initial2 : egen sum_d2 = sum(acemoglu_demo2==1)


gen neighbour_demo2 = (1/(n_non_demo2 - 1))*(sum_d2  - acemoglu_demo2) if demo_initial2==0
replace neighbour_demo2 = (1/(n_demo2 - 1))*(sum_d2  - acemoglu_demo2) if demo_initial2==1

bys ht_region year: egen region_neighbour_demo2 = mean(neighbour_demo2)

bys ht_region year: egen region_acemoglu_demo2 = mean(acemoglu_demo2)

xtline region_neighbour_demo2, overlay i(ht_region) t(year)

scatter neighbour_demo2 acemoglu_demo2

xi: xtreg  acemoglu_demo2 neighbour_demo2 i.year, fe

sort ccode year

**********************for the CHGA index of democratization


gen demo_initial3 = chga_demo if chga_demo!=. & L.chga_demo==.

replace demo_initial3 = L.demo_initial3 if L.demo_initial3!=.
 
forvalues i = 1/100 {
    replace demo_initial3 = F.demo_initial3 if demo_initial3==.
local i=`i'+1
} 
*}

bys ht_region year : egen n_non_demo3 = sum(demo_initial3==0) 

bys ht_region year : egen n_demo3 = sum(demo_initial3==1)

bys ht_region year demo_initial3 : egen sum_d3 = sum(chga_demo==1)


gen neighbour_demo3 = (1/(n_non_demo3 - 1))*(sum_d3  - chga_demo) if demo_initial3==0
replace neighbour_demo3 = (1/(n_demo3 - 1))*(sum_d3  - chga_demo) if demo_initial3==1

bys ht_region year: egen region_neighbour_demo3 = mean(neighbour_demo3)

bys ht_region year: egen region_acemoglu_demo3 = mean(chga_demo)

xtline region_neighbour_demo3, overlay i(ht_region) t(year)

scatter neighbour_demo3 chga_demo

xi: xtreg  chga_demo neighbour_demo3 i.year, fe

sort ccode year



**** For the boix indicator of democratization ****


gen demo_initial_boix = boix_demo if boix_demo!=. & L.boix_demo==.

replace demo_initial_boix = L.demo_initial_boix if L.demo_initial_boix!=.
 
forvalues i = 1/100 {
    replace demo_initial_boix = F.demo_initial_boix if demo_initial_boix==.
local i=`i'+1
} 
*}

bys ht_region year : egen n_non_demo_boix = sum(demo_initial_boix==0) 

bys ht_region year : egen n_demo_boix = sum(demo_initial_boix==1)

bys ht_region year demo_initial_boix : egen sum_d_boix = sum(boix_demo==1)


gen neighbour_demo_boix = (1/(n_non_demo_boix - 1))*(sum_d_boix  - boix_demo) if demo_initial_boix==0
replace neighbour_demo_boix = (1/(n_demo_boix - 1))*(sum_d_boix  - boix_demo) if demo_initial_boix==1

bys ht_region year: egen region_neighbour_demo_boix = mean(neighbour_demo_boix)

bys ht_region year: egen region_boix_demo = mean(boix_demo)

xtline region_neighbour_demo_boix, overlay i(ht_region) t(year)

scatter neighbour_demo_boix boix_demo

xi: xtreg  boix_demo neighbour_demo_boix i.year, fe

sort ccode year


******code regions

** The regions: 1. Eastern Europe and post Soviet Union, 2. latin America, 3. North Africa and Middle East, 4. Sub-Saharan Africa, 
** 5. Western Europe and North America, 6. East Asia, 7. South-East Asia, 8. South Asia, 9. The Pacific, and 10. The Caribbean.




******generate the interactions for the instruments

gen neighbour_demo_Lginet = neighbour_demo*L.solt_ginet

gen neighbour_demo_pre_ineg_bestMar = neighbour_demo*pre_demo_ineg_bestMar 

gen neighbour_demo_pre_ineg_best = neighbour_demo*pre_demo_ineg_best

******interaction using the other democratization indicators

****acemoglu et al with more restrictive criteria

gen neighbour_demo_pre_ineg_best2 = neighbour_demo2*pre_demo_ineg_best

****CHGA

gen neighbour_demo_pre_ineg_best3 = neighbour_demo3*pre_chga_ineg

****demo - polity2 - binary

gen neighbour_demo_pre_ineg_best4 = p_neighbour_demo*pre_demo_ineg_best

***boix

gen neighbour_demo_pre_ineg_best5 = neighbour_demo_boix*pre_demo_ineg_boix


***other

gen neighbour_demo_pre_ineg_0 = neighbour_demo*pre_demo_ineg_0

gen neighbour_auto_pre_ineg_best = neighbour_demo*pre_auto_ineg_best




*******************************************************************
********************************* regional inequality levels 
*******************************************************************


bys ht_region year : egen region_ginet = mean(solt_ginet) 

bys ht_region year : egen region_ginmar = mean(solt_ginmar) 

bys ht_region year : egen region_civilwar = mean(civil_war2) 

bys ht_region year : egen region_civilwar3 = mean(civil_war3) 


sort ccode year

 
save "democratic_outcomes_median_2.dta", replace

*******merge with the "fiscal capacity" dataset

clear

use "tax_data_RPC_v2.1_2013.dta"

rename cowcode  ccodecow

drop imfcode trccode uncode country

sort ccodecow  year

save tax.dta, replace

clear

use "democratic_outcomes_median_2.dta"

sort ccodecow year

merge ccodecow year using "tax.dta"

drop _merge

drop if ccode==.

sort ccode year

save "democratic_outcomes_median_2.dta", replace



**** Easterline inequality IV *****

	gen Ineq_IV = 0 if ccode != .
*	replace  Ineq_IV =  if ccode == 4  					/* Afghanistan */
*	replace  Ineq_IV =  if ccode == 8  					/* Albania */
	replace  Ineq_IV = 0.0404 if ccode == 12  					/* Algeria */
*	replace  Ineq_IV =  if ccode ==  20 					/* Andorra */
*	replace  Ineq_IV =  if ccode ==  24 					/* Angola */
*	replace  Ineq_IV =  if ccode == 28  					/* Antigua and Barbuda */
	replace  Ineq_IV =0.2895  if ccode == 32 				 	/* Argentina */
	replace  Ineq_IV = 0.1120 if ccode == 51  					/*Armenia */
	replace  Ineq_IV = 0.1347 if ccode == 36  					/* Australia */
	replace  Ineq_IV = 0.4380 if ccode ==  40 					/* Austria */
	replace  Ineq_IV = 0.0877 if ccode ==  31 					/* Azerbaijan  */
*	replace  Ineq_IV =  if ccode == 44  					/* Bahamas */
*	replace  Ineq_IV =  if ccode ==  48 					/* Bahrain */
	replace  Ineq_IV = 0.1280  if ccode == 50					  	/*Bangladesh */
*	replace  Ineq_IV =  if ccode ==  52 					/* Barbados */
	replace  Ineq_IV = 0.4833  if ccode == 112  					/*Belarus */
	replace  Ineq_IV = 0.4392 if ccode ==  56 					/* Belgium */
*	replace  Ineq_IV =  if ccode ==  84 					/*  Belize */
*	replace  Ineq_IV =  if ccode == 204						 /*Benin */
*	replace  Ineq_IV =   if ccode ==  64 					/* Bhutan */
	replace  Ineq_IV = -0.1195 if ccode == 68  					/*Bolivia */
	replace  Ineq_IV = 0.5281  if ccode ==  70 					/* Boznia and Herzegovina */
	replace  Ineq_IV = 0.0088 if ccode ==  72 					/* Botswana */
	replace  Ineq_IV = -0.0491 if ccode == 76 						/* Brazil */
*	replace  Ineq_IV =  if ccode == 96  					/* Brunei */
	replace  Ineq_IV = 0.4086  if ccode == 100		  				/*Bulgaria */
	replace  Ineq_IV = 0.0000 if ccode == 854  					/* Burkina Faso */
	replace  Ineq_IV = 0.0110 if ccode == 108 					/*Burundi */
	replace  Ineq_IV = -0.0201  if ccode == 116  					/* Cambodia */
*	replace  Ineq_IV =  if ccode == 120  					/*Cameroon  */
	replace  Ineq_IV = 0.1019  if ccode ==  124 					/* Canada */
*	replace  Ineq_IV =  if ccode == 132					 	 /* Cape Verde */
	replace  Ineq_IV = -0.0407  if ccode == 140 					/* Central African Republic */
	replace  Ineq_IV = 0.0000  if ccode ==  148 					/* Chad */
	replace  Ineq_IV = 0.2481  if ccode == 152					 	/* Chile */
	replace  Ineq_IV = 0.0850  if ccode == 156  					/* China */
	replace  Ineq_IV = -0.0946 if ccode == 170  					/* Colombia */
*	replace  Ineq_IV =  if ccode == 174 					/* Comoros */
*	replace  Ineq_IV =  if ccode == 178 					/* Congo */
	replace  Ineq_IV = -0.1385  if ccode == 188  					/* Costa Rica */
*	replace  Ineq_IV =  if ccode == 191					 	/* Croatia */
*	replace  Ineq_IV =  if ccode == 192  					/* Cuba */
*	replace  Ineq_IV =  if ccode == 196 					/* Cyprus */
	replace  Ineq_IV = 0.4749  if ccode == 200					 	/* Czechoslovakia */
	replace  Ineq_IV = 0.4749 if ccode == 203  					/* Czech Republic  */
	replace  Ineq_IV = 0.4419  if ccode == 208  					/* Denmark */
*	replace  Ineq_IV =  if ccode ==  262 					/* Djibouti */
*	replace  Ineq_IV =  if ccode == 212   					/* Domenica  */
	replace  Ineq_IV = -0.2175  if ccode == 214 					/* Dominican Reupublic */
	replace  Ineq_IV = -0.0257  if ccode == 218   					/* Ecuador */
	replace  Ineq_IV =  0.0000 if ccode ==  818 					/* Egypt */
	replace  Ineq_IV =  -0.0138 if ccode == 222 					/* El Salvador */
*	replace  Ineq_IV =  if ccode == 226   					/* Equatorial Guinea */
*	replace  Ineq_IV =  if ccode == 232   					/* Eritrea */
	replace  Ineq_IV = 0.3529  if ccode == 233 					/* Estonia */
	replace  Ineq_IV = 0.1664 if ccode ==  230 					/* Ethiopia (-1992) */
	replace  Ineq_IV = 0.1664 if ccode == 231   					/* Ethiopia (1993-) */
	replace  Ineq_IV = -0.0961 if ccode == 242					 	/* Fiji */
	replace  Ineq_IV = 0.026 if ccode == 246   					/* Finland */
	replace  Ineq_IV = 0.4375 if ccode ==  250 					/* France */
	replace  Ineq_IV = -0.2017 if ccode ==  266 					/* Gabon */
	replace  Ineq_IV = 0.0000 if ccode == 270   					/* Gambia */
	replace  Ineq_IV = 0.3854 if ccode ==  268 					/* Georgia */
	replace  Ineq_IV =  0.4452 if ccode ==  276 					/* Germany */
	replace  Ineq_IV = -0.0078 if ccode == 288 					/* Ghana */
	replace  Ineq_IV = 0.2231 if ccode == 300   					/* Greece */
*	replace  Ineq_IV =  if ccode == 308 					/* Grenada */
	replace  Ineq_IV = -0.3314  if ccode == 320					    /* Guatemala */
	replace  Ineq_IV = -0.0035  if ccode == 324  					/* Guinea */
*	replace  Ineq_IV =   if ccode == 624 					/* Guniea-Bissau */
	replace  Ineq_IV = -0.0997  if ccode == 328  					/* Guyana */
*	replace  Ineq_IV =   if ccode == 332					 	/* Haiti */
	replace  Ineq_IV = -0.1246 if ccode == 340 					/* Honduras */
	replace  Ineq_IV = 0.4383 if ccode == 348 					/* Hungary */
*	replace  Ineq_IV =  if ccode ==   352					/* Iceland */
	replace  Ineq_IV = -0.0045 if ccode ==   356 					/* India */
	replace  Ineq_IV = -0.0428 if ccode == 384  					/* Ivory Coast  */
	replace  Ineq_IV = -0.0045 if ccode == 360 					/* Indonesia */
*	replace  Ineq_IV =  if ccode == 364  					/* Iran */
	replace  Ineq_IV = 0.1628  if ccode ==  368 					/* Iraq */
	replace  Ineq_IV = 0.1005  if ccode ==  372 					/* Ireland */
	replace  Ineq_IV = 0.2877 if ccode ==  376 					/* Israel */
	replace  Ineq_IV =  0.3287 if ccode ==  380 					/* Italy */
	replace  Ineq_IV = -0.3926 if ccode == 388  					/* Jamaica */
	replace  Ineq_IV =  0.2908 if ccode ==  392 					/* Japan */
	replace  Ineq_IV = 0.0071 if ccode ==  400 					/* Jordan */
	replace  Ineq_IV = 0.0129  if ccode ==  398 					/* Kazakhstan */
	replace  Ineq_IV = 0.1298 if ccode == 404 					/* Kenya */
*	replace  Ineq_IV =  if ccode ==  408 					/* Korea, North */
	replace  Ineq_IV = 0.2493  if ccode ==  410 					/* Korea, South */
*	replace  Ineq_IV =  if ccode == 414  					/* Kuwait */
	replace  Ineq_IV = 0.0104  if ccode ==  417 					/* Kyrgystan */
	replace  Ineq_IV = -0.0497  if ccode == 418   					/* Laos */
	replace  Ineq_IV = 0.4253  if ccode == 428 					/* Latvia */
	replace  Ineq_IV = 0.1190 if ccode ==  422 					/* Lebanon */
	replace  Ineq_IV = 0.1342 if ccode == 426 					/* Lesotho */
*	replace  Ineq_IV =  if ccode ==  430  					/* Liberia */
*	replace  Ineq_IV =  if ccode == 434   					/* Libya  */
	replace  Ineq_IV = 0.4986  if ccode == 440 					/* Lithuania */
*	replace  Ineq_IV =  if ccode ==  442 					/* Luxembourg */
	replace  Ineq_IV = 0.1828 if ccode == 807 					/* Macedonia */
	replace  Ineq_IV = -0.0544 if ccode == 450					 	/* Madagascar */
	replace  Ineq_IV =  -0.0889 if ccode ==  458 					/* Malaysia */
*	replace  Ineq_IV =  if ccode == 454 					/* Malawai */
*	replace  Ineq_IV =  if ccode ==  462 					/* Maldives */
	replace  Ineq_IV = 0 if ccode == 466 					/* Mali */
*	replace  Ineq_IV =  if ccode == 470   					/* Malta */
	replace  Ineq_IV = 0 if ccode ==  478 					/* Mauritania */
*	replace  Ineq_IV =  if ccode ==  480 					/* Mautitius */
	replace  Ineq_IV = 0.0047  if ccode == 484					 	/* Mexico */
	replace  Ineq_IV = 0.1976 if ccode == 498 					/* Moldova */
	replace  Ineq_IV = 0 if ccode == 496					 	/* Mongolia  */
*	replace  Ineq_IV =  if ccode == 504   					/* Morocco */
*	replace  Ineq_IV =  if ccode == 508   					/* Mozambique */
	replace  Ineq_IV = 0.0212  if ccode ==  104 					/* Myanmar */
*	replace  Ineq_IV =  if ccode == 516   					/* Namibia */
	replace  Ineq_IV = 0.0776  if ccode == 524 					/* Nepal */
	replace  Ineq_IV = 0.3398 if ccode == 528  					/* Netherlands */
	replace  Ineq_IV = 0.1234 if ccode ==  554 					/* New Zealand */
	replace  Ineq_IV = -0.1593  if ccode == 558					 	/* Nicaragua */
	replace  Ineq_IV = 0 if ccode == 562					 	/* Niger */
	replace  Ineq_IV = -0.0048 if ccode == 566 					/* Nigeria */
	replace  Ineq_IV = 0.0535 if ccode ==  578 					/* Norway */
*	replace  Ineq_IV =   if ccode == 512   					/* Oman */
	replace  Ineq_IV = 0.1462  if ccode == 586 					/* Pakistan */
	replace  Ineq_IV = -0.1036 if ccode == 591 					/* Panama */
	replace  Ineq_IV =  -0.0431 if ccode ==  598 					/* Papa New Guinea */
	replace  Ineq_IV = -0.1519 if ccode == 600					 	/* Paraguay  */
	replace  Ineq_IV = -0.0979 if ccode == 604 					/* Peru */
	replace  Ineq_IV = -0.2045 if ccode == 608					 	/* Philipines */
	replace  Ineq_IV = 0.3491 if ccode == 616 					/* Poland */
	replace  Ineq_IV = 0.3409  if ccode == 620   					/* Portugal */
*	replace  Ineq_IV =  if ccode == 634   					/* Qatar */
	replace  Ineq_IV = 0.3268  if ccode == 642 					/* Romania  */
	replace  Ineq_IV = 0.3002 if ccode == 643 					/* Russia */
	replace  Ineq_IV = -0.0027  if ccode == 646   					/* Rwanda */
*	replace  Ineq_IV =  if ccode == 678 					/* Sao Tome and Principe */
*	replace  Ineq_IV =  if ccode == 682   					/* Saudi Arabia */
	replace  Ineq_IV = 0  if ccode == 686 					/* Senegal */
	replace  Ineq_IV = 0.3944 if ccode == 688 					/* Serbia */
	replace  Ineq_IV = -0.0096 if ccode == 694					 	/* Sierra Leone */
*	replace  Ineq_IV =   if ccode == 702   					/* Singapore */
*	replace  Ineq_IV =  if ccode == 703   					/* Slovakia */
	replace  Ineq_IV = 0.4173  if ccode == 705   					/* Slovenia */
*	replace  Ineq_IV =  if ccode == 706   					/* Somolia */
	replace  Ineq_IV = 0.1088 if ccode == 710 					/* South Africa */
	replace  Ineq_IV = 0.0649 if ccode == 724   					/* Spain */
	replace  Ineq_IV = -0.0565 if ccode == 144 					/* Sri Lanka */
	replace  Ineq_IV = -0.0025 if ccode == 736 					/* Sudan */
	replace  Ineq_IV =  -0.1921 if ccode == 740					 	/* Suriname */
	replace  Ineq_IV = 0.0719 if ccode ==  748 					/* Swaziland */
	replace  Ineq_IV = 0.1777 if ccode == 752   					/* Sweden */
	replace  Ineq_IV =  0.5439 if ccode == 756   					/* Switzerland */
*	replace  Ineq_IV =  if ccode == 760   					/* Syria */
*	replace  Ineq_IV =  if ccode == 158 					/* Taiwan */
*	replace  Ineq_IV =  if ccode == 762   					/* Tajikistan */
	replace  Ineq_IV = 0.0671  if ccode == 834   					/* Tanzania */
	replace  Ineq_IV = -0.0054  if ccode == 764 					/* Thailand */
*	replace  Ineq_IV =  if ccode == 994   					/* Tibet */
*	replace  Ineq_IV =  if ccode == 780   					/* Trinidad and Tobago */
	replace  Ineq_IV = 0.1173  if ccode == 788   					/* Tunisia */
	replace  Ineq_IV = 0.1601 if ccode == 792 					/* Turkey */
	replace  Ineq_IV = 0 if ccode == 795   					/* Turkmenistan */
	replace  Ineq_IV = -0.1508 if ccode == 800 					/* Uganda */
	replace  Ineq_IV = 0.3094 if ccode == 804 					/* Ukraine */
*	replace  Ineq_IV =  if ccode == 784   					/* UAE */
	replace  Ineq_IV = 0.3385  if ccode == 826   					/* UK */
	replace  Ineq_IV = 0.3830  if ccode == 840   					/* USA */
	replace  Ineq_IV = 0.5775 if ccode == 858 					/* Uruguay */
*	replace  Ineq_IV =   if ccode == 860   					/* Uzbekistan */
	replace  Ineq_IV = -0.0544  if ccode == 862   					/* Venezuala */
	replace  Ineq_IV = -0.0786  if ccode == 704   					/* Vietnam */
*	replace  Ineq_IV =  if ccode == 887   					/* Yemen */
*	replace  Ineq_IV =  if ccode == 890 					/* Yugoslavia */
	replace  Ineq_IV = 0.0508  if ccode == 894 					/* Zambia */
	replace  Ineq_IV = 0  if ccode ==  716 					/* Zimbabwe */
	

generate neighbour_demo_Ineq_IV = neighbour_demo*Ineq_IV
generate acemoglu_demo_Ineq_IV = acemoglu_demo*Ineq_IV


gen Inequality_IV = (1-Ineq_IV)*50
drop acemoglu_demo_Ineq_IV
gen acemoglu_demo_Ineq_IV = acemoglu_demo*Inequality_IV


*****USSR and Warsaw pact dummies

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

xi: gen acemoglu_demo_military = acemoglu_demo*L.military
xi: gen acemoglu_demo_monarchy = acemoglu_demo*L.monarchy
xi: gen acemoglu_demo_party = acemoglu_demo*L.party
xi: gen acemoglu_demo_personal = acemoglu_demo*L.personal


sort ccodealp year

save "democratic_outcomes_median_2.dta", replace


***************machine learning democratization indicator of Krieger  
clear

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

use "democratic_outcomes_median_2.dta"

sort ccodealp year

merge ccodealp year using "Krieger_EJPE_merge.dta"

drop _merge
drop if ccode==.

sort ccode year

gen demo_machine = 1 if svmdi>=0.50 & svmdi!=.
replace demo_machine = 0 if svmdi<0.5 & svmdi!=.

gen pre_demo_ineg_b_m = L5.solt_ginet if demo_machine==0 & F.demo_machine==1
replace pre_demo_ineg_b_m = L4.solt_ginet if demo_machine==0 & F.demo_machine==1 & L5.solt_ginet==.
replace pre_demo_ineg_b_m = L3.solt_ginet if demo_machine==0 & F.demo_machine==1 & L5.solt_ginet==. & L4.solt_ginet==.
replace pre_demo_ineg_b_m = L2.solt_ginet if demo_machine==0 & F.demo_machine==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==.
replace pre_demo_ineg_b_m = L.solt_ginet if demo_machine==0 & F.demo_machine==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==.
replace pre_demo_ineg_b_m = solt_ginet if demo_machine==0 & F.demo_machine==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==. & L.solt_ginet==.
replace pre_demo_ineg_b_m = F.solt_ginet if demo_machine==0 & F.demo_machine==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==. & L.solt_ginet==. & solt_ginet==.

replace pre_demo_ineg_b_m = L.pre_demo_ineg_b_m if demo_machine!=0

replace pre_demo_ineg_b_m = solt_ginet if pre_demo_ineg_b_m == .

gen demo_machine_pre_demo_ineg_b_m = demo_machine*pre_demo_ineg_b_m

xi: gen svmdi_ginet = svmdi*L.solt_ginet

gen demo_machine2 = 1 if svmdi>=0.75 & svmdi!=.
replace demo_machine2 = 0 if svmdi<0.75 & svmdi!=.

gen pre_demo_ineg_b_m2 = L5.solt_ginet if demo_machine2==0 & F.demo_machine2==1
replace pre_demo_ineg_b_m2 = L4.solt_ginet if demo_machine2==0 & F.demo_machine2==1 & L5.solt_ginet==.
replace pre_demo_ineg_b_m2 = L3.solt_ginet if demo_machine2==0 & F.demo_machine2==1 & L5.solt_ginet==. & L4.solt_ginet==.
replace pre_demo_ineg_b_m2 = L2.solt_ginet if demo_machine2==0 & F.demo_machine2==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==.
replace pre_demo_ineg_b_m2 = L.solt_ginet if demo_machine2==0 & F.demo_machine2==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==.
replace pre_demo_ineg_b_m2 = solt_ginet if demo_machine2==0 & F.demo_machine2==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==. & L.solt_ginet==.
replace pre_demo_ineg_b_m2 = F.solt_ginet if demo_machine2==0 & F.demo_machine2==1 & L5.solt_ginet==. & L4.solt_ginet==. & L3.solt_ginet==. & L2.solt_ginet==. & L.solt_ginet==. & solt_ginet==.

replace pre_demo_ineg_b_m2 = L.pre_demo_ineg_b_m2 if demo_machine2!=0

replace pre_demo_ineg_b_m2 = solt_ginet if pre_demo_ineg_b_m2 == .

gen demo_machine_pre_demo_ineg_b_m2 = demo_machine2*pre_demo_ineg_b_m2


gen demo_machine_lginet = demo_machine*L.solt_ginet


*******************************************************************
*********************************generate instruments - democratization episode in the region - with machine learning indicator
*******************************************************************

gen demo_initial_m = demo_machine if demo_machine!=. & L.demo_machine==.

replace demo_initial_m = L.demo_initial_m if L.demo_initial_m!=.
 
forvalues i = 1/100 {
    replace demo_initial_m = F.demo_initial_m if demo_initial_m==.
local i=`i'+1
} 
*}

bys ht_region year : egen n_non_demo_m = sum(demo_initial_m==0) 

bys ht_region year : egen n_demo_m = sum(demo_initial_m==1)

bys ht_region year demo_initial_m : egen sum_d_m = sum(demo_machine==1)


gen neighbour_demo_m = (1/(n_non_demo_m - 1))*(sum_d_m  - demo_machine) if demo_initial_m==0
replace neighbour_demo_m = (1/(n_demo_m - 1))*(sum_d_m  - demo_machine) if demo_initial_m==1

bys ht_region year: egen region_neighbour_demo_m = mean(neighbour_demo_m)

bys ht_region year: egen region_demo_machine = mean(demo_machine)

xtline region_neighbour_demo, overlay i(ht_region) t(year)

scatter neighbour_demo acemoglu_demo

xi: xtreg  acemoglu_demo neighbour_demo i.year, fe


gen neighbour_d_m_pre_demo_ineg_b_m = neighbour_demo_m*pre_demo_ineg_b_m



sort ccode year



*** generating the inequality deciles for calculating the L-R effect ****

reg solt_ginet L.solt_ginet L.acemoglu_demo L.log_gdp
generate sumstat1 = e(sample)

reg solt_ginet L.solt_ginet L2.solt_ginet L3.solt_ginet L4.solt_ginet L.acemoglu_demo L.log_gdp
generate sumstat = e(sample)

summarize solt_ginet if sumstat == 1, detail

reg solt_ginet L5.acemoglu_auto L5.log_gdp
generate sumstat2 = e(sample)

summarize solt_ginet if acemoglu_demo == 1 & L.acemoglu_demo == 0 & sumstat ==1, detail 
*gen ginet10a = 26.92412  
*gen ginet90a =  59.16246  
*gen ginet50a = 44.37265

gen ginet10a = 31.31563  
gen ginet90a =  51.25771

gen ginet5a = 27.71866  
gen ginet95a =  53.06852

gen ginet1a = 25.69917  
gen ginet99a =  56.43519

 


summarize solt_ginet if acemoglu_demo == 0 & sumstat == 1, detail
gen ginet50_auto = 40.41065 

summarize solt_ginmar if  acemoglu_demo == 1 & L.acemoglu_demo == 0 & sumstat ==1, detail 
gen ginmar10a = 30.37066 
*gen ginmar50a = 48.18761 
gen ginmar90a =  56.49869 

summarize solt_ginmar if acemoglu_demo == 0 & sumstat == 1, detail
gen ginmar50_auto = 43.23914  


summarize solt_ginet if acemoglu_auto == 1 & L.acemoglu_auto == 0 & sumstat2 ==1, detail 
gen ginet10b = 25.1792  
gen ginet90b = 59.0531   


sort ccode year

save "democratic_outcomes_median_2.dta", replace


********variable lag for the LSDV estimator

gen Lacemoglu_demo = L.acemoglu_demo
gen Lacemoglu_demo_pre_demo_ineg = L.acemoglu_demo_pre_demo_ineg_best
gen Llog_gdp = L.log_gdp
gen Lsolt_ginet = L.solt_ginet
gen Lneighbour_demo_pre_ineg_best = L.neighbour_demo_pre_ineg_best
gen Lneighbour_demo = L.neighbour_demo
gen L6neighbour_demo = L6.neighbour_demo


save "democratic_outcomes_median_2.dta", replace


save "final_dataset_PE.dta", replace




 

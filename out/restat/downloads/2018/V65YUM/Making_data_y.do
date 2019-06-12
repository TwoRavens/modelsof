********************************************************************************
* Making_data.do
* October, 2014
*
* This constructs the data for dependent variables
* this do file must be run after making_data_xz.do
* 
********************************************************************************

********************
* I. Preliminaries *
********************

clear
cap clear matrix
set more off, permanently


* log file
cap log close
log using log/making-data-y.log, replace


**********************************
* 1. Industry_ipums
**********************************
use "src/county_match3_old.dta", clear
rename state st_name
rename county cnty_name
rename countyid_new countyid
drop if countyid == 2201130 & trim(cnty_name)=="Vermilion" /* extra misspelled copy of Vermillion LA */
drop if countyid==.
keep statea countya countyid st_name cnty_name
compress
merge 1:m statea countya using dta/temp


keep if _merge==3 /* for now we need the non-city counties */
drop _merge

* make missing countyid countyid=0 (really, non-city areas)
replace countyid=0 if countyid==.


* IV.2 Construct "area," which, for now = county except in NYC.  
* (May want to add other multi-county cities later)
   /* NYC will be sum of "five" counties (which is its real definition post-1920 or so)
      - This merges Brooklyn and New York which were separate cities pre-1900
	  - 3600060 is a merge of Bronx and New York counties, which were also once separate */
gen area = countyid
replace area = 3600060 if countyid==3600060|countyid==3600470|countyid==3600810|countyid==3600850
rename st_name state

collapse (sum)clerks* (sum)skilled* (sum)wageworkers*, by(year area statea state ind1950), [pw=perwt]

egen total=rsum(clerks_*lit skilled_*lit wageworkers_*lit)
egen literate=rsum(*_lit)
gen lit_share=literate/total

gen lit_share_salaried=clerks_lit/(clerks_lit+clerks_notlit)
gen lit_share_wageearners=(skilled_lit+wageworkers_lit)/(skilled_lit+wageworkers_lit+skilled_notlit+wageworkers_notlit)

egen total_urban=rsum(*_urban)
egen lit_urban=rsum(*_lit_urban)

gen lit_share_urban=lit_urban/total_urban
gen lit_share_salaried_urban=clerks_lit_urban/(clerks_lit_urban+clerks_notlit_urban)
gen lit_share_wageearners_urban=(skilled_lit_urban+wageworkers_lit_urban)/(skilled_lit_urban+wageworkers_lit_urban+skilled_notlit_urban+wageworkers_notlit_urban)

keep *_share* year area statea state ind1950
save dta/literacy_byindustry_ipums,  replace




***********************************
* Industries Final (from read_city_data which saves the excels to stata data)
***********************************
use dta/county-city-new.dta, clear

gen st_ab=""
replace st_ab="AL" if st_name=="Alabama"
replace st_ab="AK" if st_name=="Alaska"
replace st_ab="AZ" if st_name=="Arizona"
replace st_ab="AR" if st_name=="Arkansas"
replace st_ab="CA" if st_name=="California"
replace st_ab="CO" if st_name=="Colorado"
replace st_ab="CT" if st_name=="Connecticut"
replace st_ab="DE" if st_name=="Delaware"
replace st_ab="DC" if st_name=="District Of Columbia"
replace st_ab="FL" if st_name=="Florida"
replace st_ab="GA" if st_name=="Georgia"
replace st_ab="HI" if st_name=="Hawaii"
replace st_ab="ID" if st_name=="Idaho"
replace st_ab="IL" if st_name=="Illinois"
replace st_ab="IN" if st_name=="Indiana"
replace st_ab="IA" if st_name=="Iowa"
replace st_ab="KS" if st_name=="Kansas"
replace st_ab="KY" if st_name=="Kentucky"
replace st_ab="LA" if st_name=="Louisiana"
replace st_ab="ME" if st_name=="Maine"
replace st_ab="MD" if st_name=="Maryland"
replace st_ab="MA" if st_name=="Massachusetts"
replace st_ab="MI" if st_name=="Michigan"
replace st_ab="MN" if st_name=="Minnesota"
replace st_ab="MS" if st_name=="Mississippi"
replace st_ab="MO" if st_name=="Missouri"
replace st_ab="MT" if st_name=="Montana"
replace st_ab="NE" if st_name=="Nebraska"
replace st_ab="NV" if st_name=="Nevada"
replace st_ab="NH" if st_name=="New Hampshire"
replace st_ab="NJ" if st_name=="New Jersey"
replace st_ab="NM" if st_name=="New Mexico"
replace st_ab="NY" if st_name=="New York"
replace st_ab="NC" if st_name=="North Carolina"
replace st_ab="ND" if st_name=="North Dakota"
replace st_ab="OH" if st_name=="Ohio"
replace st_ab="OK" if st_name=="Oklahoma"
replace st_ab="OR" if st_name=="Oregon"
replace st_ab="PA" if st_name=="Pennsylvania"
replace st_ab="RI" if st_name=="Rhode Island"
replace st_ab="SC" if st_name=="South Carolina"
replace st_ab="SD" if st_name=="South Dakota"
replace st_ab="TN" if st_name=="Tennessee"
replace st_ab="TX" if st_name=="Texas"
replace st_ab="UT" if st_name=="Utah"
replace st_ab="VT" if st_name=="Vermont"
replace st_ab="VA" if st_name=="Virginia"
replace st_ab="WA" if st_name=="Washington"
replace st_ab="WV" if st_name=="West Virginia"
replace st_ab="WI" if st_name=="Wisconsin"
replace st_ab="WY" if st_name=="Wyoming"

label define city_lbl 6390 "Schenectady, NY", modify
replace countyid=600730 if countyid==600740 & cnty_name=="San Diego"
replace countyid=800310 if countyid==800320 & cnty_name=="Arapahoe"
replace countyid=1200570 if countyid==1200580 & cnty_name=="Hillsborough"
replace countyid=1301210 if countyid==1301220 & cnty_name=="Fulton"
replace countyid=1550035 if countyid==1500030 & cnty_name=="Honolulu"
replace countyid=2300050 if countyid==2300020 & cnty_name=="Cumberland"
replace countyid=2700370 if countyid==2700200 & cnty_name=="Dakota"
replace countyid=2700530 if countyid==2700200 & cnty_name=="Hennepin"
replace countyid=3400130 if countyid==3400140 & cnty_name=="Essex"
replace countyid=3400390 if countyid==3400140 & cnty_name=="Union"
replace countyid=4000370 if countyid==4000380 & cnty_name=="Creek"
replace countyid=4001430 if countyid==4000380 & cnty_name=="Tulsa"
replace countyid=4001110 if countyid==4000380 & cnty_name=="Okmulgee"
replace countyid=4100510 if countyid==4100060 & cnty_name=="Multnomah"
replace countyid=4700650 if countyid==4700660 & cnty_name=="Hamilton"
replace countyid=4801410 if countyid==4801100 & cnty_name=="El Paso"
decode city , generate(city_st)
rename city citycode
drop if city_st=="Wilkinsburg, PA"
drop if city_st=="Cohoes, NY"
drop if city_st=="Lebanon, PA"
drop if city_st=="Vallejo, CA"
save dta/county-city-new2.dta,   replace

use dta/county-city-new.dta", clear

gen st_ab=""
replace st_ab="AL" if st_name=="Alabama"
replace st_ab="AK" if st_name=="Alaska"
replace st_ab="AZ" if st_name=="Arizona"
replace st_ab="AR" if st_name=="Arkansas"
replace st_ab="CA" if st_name=="California"
replace st_ab="CO" if st_name=="Colorado"
replace st_ab="CT" if st_name=="Connecticut"
replace st_ab="DE" if st_name=="Delaware"
replace st_ab="DC" if st_name=="District Of Columbia"
replace st_ab="FL" if st_name=="Florida"
replace st_ab="GA" if st_name=="Georgia"
replace st_ab="HI" if st_name=="Hawaii"
replace st_ab="ID" if st_name=="Idaho"
replace st_ab="IL" if st_name=="Illinois"
replace st_ab="IN" if st_name=="Indiana"
replace st_ab="IA" if st_name=="Iowa"
replace st_ab="KS" if st_name=="Kansas"
replace st_ab="KY" if st_name=="Kentucky"
replace st_ab="LA" if st_name=="Louisiana"
replace st_ab="ME" if st_name=="Maine"
replace st_ab="MD" if st_name=="Maryland"
replace st_ab="MA" if st_name=="Massachusetts"
replace st_ab="MI" if st_name=="Michigan"
replace st_ab="MN" if st_name=="Minnesota"
replace st_ab="MS" if st_name=="Mississippi"
replace st_ab="MO" if st_name=="Missouri"
replace st_ab="MT" if st_name=="Montana"
replace st_ab="NE" if st_name=="Nebraska"
replace st_ab="NV" if st_name=="Nevada"
replace st_ab="NH" if st_name=="New Hampshire"
replace st_ab="NJ" if st_name=="New Jersey"
replace st_ab="NM" if st_name=="New Mexico"
replace st_ab="NY" if st_name=="New York"
replace st_ab="NC" if st_name=="North Carolina"
replace st_ab="ND" if st_name=="North Dakota"
replace st_ab="OH" if st_name=="Ohio"
replace st_ab="OK" if st_name=="Oklahoma"
replace st_ab="OR" if st_name=="Oregon"
replace st_ab="PA" if st_name=="Pennsylvania"
replace st_ab="RI" if st_name=="Rhode Island"
replace st_ab="SC" if st_name=="South Carolina"
replace st_ab="SD" if st_name=="South Dakota"
replace st_ab="TN" if st_name=="Tennessee"
replace st_ab="TX" if st_name=="Texas"
replace st_ab="UT" if st_name=="Utah"
replace st_ab="VT" if st_name=="Vermont"
replace st_ab="VA" if st_name=="Virginia"
replace st_ab="WA" if st_name=="Washington"
replace st_ab="WV" if st_name=="West Virginia"
replace st_ab="WI" if st_name=="Wisconsin"
replace st_ab="WY" if st_name=="Wyoming"
replace countyid=600730 if countyid==600740 & cnty_name=="San Diego"
replace countyid=800310 if countyid==800320 & cnty_name=="Arapahoe"
replace countyid=1200570 if countyid==1200580 & cnty_name=="Hillsborough"
replace countyid=1301210 if countyid==1301220 & cnty_name=="Fulton"
replace countyid=1550035 if countyid==1500030 & cnty_name=="Honolulu"
replace countyid=2300050 if countyid==2300020 & cnty_name=="Cumberland"
replace countyid=2700370 if countyid==2700200 & cnty_name=="Dakota"
replace countyid=2700530 if countyid==2700200 & cnty_name=="Hennepin"
replace countyid=3400130 if countyid==3400140 & cnty_name=="Essex"
replace countyid=3400390 if countyid==3400140 & cnty_name=="Union"
replace countyid=4000370 if countyid==4000380 & cnty_name=="Creek"
replace countyid=4001430 if countyid==4000380 & cnty_name=="Tulsa"
replace countyid=4001110 if countyid==4000380 & cnty_name=="Okmulgee"
replace countyid=4100510 if countyid==4100060 & cnty_name=="Multnomah"
replace countyid=4700650 if countyid==4700660 & cnty_name=="Hamilton"
replace countyid=4801410 if countyid==4801100 & cnty_name=="El Paso"
keep countyid st_ab cnty_name
collapse (mean)countyid, by(st_ab cnty_name)
save dta/countycodes,    replace
clear

***
import excel using "src/1860-Census-Industry-County-rev.xls", sheet(Sheet1) firstrow
drop if County==""
replace State="LA" if State=="Louisiana"
replace State="AL" if State=="alabama"
replace State="AR" if State=="arkansas"
replace State="CA" if State=="california"
replace State="CO" if State=="colorado"
replace State="CT" if State=="connecticut"
replace State="DE" if State=="delaware"
replace State="FL" if State=="florida"
replace State="GA" if State=="georgia"
replace State="IL" if State=="illinois" | State=="illionois"
replace State="IN" if State=="indiana"
replace State="IA" if State=="iowa"
replace State="KS" if State=="kansas"
replace State="KY" if State=="kentucky"
replace State="ME" if State=="maine"
replace State="MD" if State=="maryland"
replace State="MA" if State=="massachusetts"
replace State="MI" if State=="michigan"
replace State="MN" if State=="minnesota"
replace State="MO" if State=="missouri"
replace State="NE" if State=="nebraska"
replace State="NH" if State=="new hampshire"
replace State="NJ" if State=="new jersey"
replace State="NY" if State=="new york"
replace State="OH" if State=="ohio"
replace State="OR" if State=="oregon"
replace State="PA" if State=="pennsylvania"
replace State="RI" if State=="rhode island"
replace State="SC" if State=="south carolina"
replace State="TN" if State=="tennessee"
replace State="TX" if State=="texas"
replace State="UT" if State=="utah"
replace State="VA" if State=="virginia"
replace State="WA" if State=="washington"
replace State="DC" if State=="washington DC"
replace State="WV" if State=="west virginia"
replace State="WI" if State=="wisconsin"

replace Industry=trim(Industry)
drop if Numberofest==.
rename Numberofestablishment Numberofestablishments
rename Capitalinvested Capital
rename Costofrawmaterial Valueofmaterials
rename Numberofhandsemployedmale wageearners_av_males
rename Numberofhandsemployedfemale wageearners_av_females
rename Annualcostoflabor expenses_wageearners
rename Annualvalueofproducts Valueofproducts
drop K
replace Valueofmaterials=0 if Valueofmaterials==.
replace wageearners_av_males=0 if wageearners_av_males==.
replace wageearners_av_females=0 if wageearners_av_females==.
replace expenses_wageearners=0 if expenses_wageearners==.
gen wageearners_av_total=wageearners_av_males+wageearners_av_females
gen Valueaddedbymanufacture=Valueofproducts-Valueofmaterials
gen year=1860
gen d_county=1
gen d_city=1
save dta/1860final,   replace
clear

import excel using "src/1870-Census-Industry-County-rev2.xls", sheet("Planilla a rellenar") firstrow
drop if County==""
drop J K
replace State="LA" if State=="Louisiana"
replace State="AL" if State=="Alabama"
replace State="AR" if State=="Arkansas"
replace State="CA" if State=="California"
replace State="CO" if State=="Colorado"
replace State="CT" if State=="Connecticut"
replace State="DE" if State=="Delaware"
replace State="FL" if State=="Florida"
replace State="GA" if State=="Georgia"
replace State="IL" if State=="Illinois"
replace State="IN" if State=="Indiana"
replace State="IA" if State=="Iowa"
replace State="KS" if State=="Kansas"
replace State="KY" if State=="Kentucky"
replace State="ME" if State=="Maine"
replace State="MD" if State=="Maryland"
replace State="MA" if State=="Massachusetts"
replace State="MI" if State=="Michigan"
replace State="MN" if State=="Minnesota"
replace State="MO" if State=="Missouri"
replace State="NE" if State=="Nebraska"
replace State="NH" if State=="New Hampshire"
replace State="NJ" if State=="New Jersey"
replace State="NY" if State=="New York"
replace State="OH" if State=="Ohio"
replace State="OR" if State=="Oregon"
replace State="PA" if State=="Pennsylvania"
replace State="RI" if State=="Rhode Island"
replace State="SC" if State=="South Carolina"
replace State="TN" if State=="Tennessee"
replace State="TX" if State=="Texas"
replace State="UT" if State=="Utah"
replace State="VA" if State=="Virginia"
replace State="WA" if State=="Washington"
replace State="WV" if State=="West Virginia"
replace State="WI" if State=="Wisconsin"
replace Industry=trim(Industry)
rename Numberofestablishment Numberofestablishments
rename Handsemployed wageearners_av_total
rename Wages expenses_wageearners
rename Materials Valueofmaterials
rename Products Valueofproducts
gen Valueaddedbymanufacture=Valueofproducts-Valueofmaterials
drop L-IV
gen year=1870
gen d_county=1
gen d_city=1
save dta/1870final,   replace
append using dta/1860final

rename County cnty_name
rename State st_ab

replace cnty_name="Allegheny" if cnty_name=="Alleghyeny"
replace cnty_name="Galveston" if cnty_name=="Galveston "
replace cnty_name="Hamilton" if cnty_name=="Halminton" | cnty_name=="Halmilton"
replace cnty_name="Hennepin" if cnty_name=="Hennepein"
replace cnty_name="Jefferson" if cnty_name=="Jeferson"
replace cnty_name="Schenectady" if cnty_name=="Shenectady"
replace cnty_name="St Clair" if cnty_name=="St. Clair" | cnty_name=="St.Clair"
replace cnty_name="St Joseph" if cnty_name=="St. Joseph" | cnty_name=="St.Joseph" | cnty_name=="Saint Joseph"
replace cnty_name="St Louis" if cnty_name=="St. Louis" | cnty_name=="St.Louis"





merge m:1 cnty_name st_ab using dta/countycodes.dta
drop if _merge==2
drop _merge
replace countyid=1100010 if cnty_name=="Territory of Washington" & st_ab=="DC"
replace countyid=1100010 if cnty_name=="Washington" & st_ab=="DC"
replace countyid=3600470 if cnty_name=="Kings" & st_ab=="NY"
replace countyid=3600610 if cnty_name=="New York" & st_ab=="NY"
replace countyid=5300650 if cnty_name=="Stevens" & st_ab=="WA"

save dta/industry_by_county,   replace
clear

forval i=1/96 {
import excel using "src/1880-Census-Industry-City.xls", sheet("Hoja`i'") firstrow
rename Noofestablishments Numberofestablishments
cap drop K
rename Males wageearners_av_males
rename Females wageearners_av_females
rename Children wageearners_av_under16
rename Totalamountpaidinwagesdurin expenses_wageearners
  if `i'>1 {
    append using dta/1880final
      }
  save dta/1880final,   replace
  clear
}
  
import excel using "src/1880-Census-Industry-City.xls", sheet(Final) firstrow 
rename Noofestablishments Numberofestablishments
cap drop K
rename Males wageearners_av_males
rename Females wageearners_av_females
rename Children wageearners_av_under16
rename Totalamountpaidinwagesdurin expenses_wageearners 
  append using dta/1880final
 save dta/1880final,   replace
 clear
 
 forval i=2/4{
 import excel using "src/1880-Census-Industry-City.xls", sheet("Sheet`i'") firstrow
rename Noofestablishments Numberofestablishments
cap drop K
rename Males wageearners_av_males
rename Females wageearners_av_females
rename Children wageearners_av_under16
rename Totalamountpaidinwagesdurin expenses_wageearners
 append using dta/1880final
 save dta/1880final,   replace
 clear
 }

use dta/1880final
gen Valueaddedbymanufacture=Valueofproducts-Valueofmaterials
egen wageearners_av_total=rsum(wageearners_*)
gen year=1880
drop if City==""
gen city=substr(City,1,strpos(City,",")-1)
gen state=trim(substr(City,strpos(City,",")+1,length(City)))
replace city="Brooklyn" if city=="Brookly"
replace city="Pittsburgh" if city=="Pittsburg"
replace city="Terre Haute" if city=="Terre Hante"
replace city="Wheeling" if city=="Whecling"
replace state="AR" if state=="AK"
replace state="CT" if state=="CN"
replace state="KS" if state=="KN"
drop City
replace Industry=trim(Industry)
gen d_county=0
gen d_city=1
save dta/1880final,   replace
clear

/* 1890final is in source */
use "src/1890final", clear
save dta/1890final,   replace


clear
import excel using "src/1900-rev.xlsx", sheet("ALABAMA") firstrow
rename CapitalTotal Capital
rename Land Capital_land
rename Buildings Capital_buildings
rename Machinerytools Capital_mne
rename Cashandsundries Capital_cash
rename Propietorsandfirmmembers proprietors
rename Salariedofficers officers
rename Salariessalariedofficials expenses_officials
rename Averagenumberofwageearners wageearners_av_total
rename Wages expenses_wageearners
rename Averagemens wageearners_av_male
rename Averagewomen wageearners_av_female
rename Averagechildren wageearners_av_under16
rename Wagesmen expenses_wageearners_male
rename Wageswomen expenses_wageearners_female
rename Wageschildren expenses_wageearners_under16
rename Totalmiscellaneousexpenses expenses_miscellaneous
rename Rentsofwork expenses_workrent
rename Taxesnotincluded expenses_taxes
rename Rentofoffices expenses_rent
rename Contractrwork expenses_contractwork
rename Total Valueofmaterials
rename Principlematerials expenses_materials_other
rename Fuelandrentofpower expenses_fuelandpower
rename Valueofproductsincluding Valueofproducts
foreach var of varlist Numberofestablishments-Valueofproducts{
replace `var'=0 if `var'==.
}
drop if Industry==""|City==""
gen year=1900
gen city=substr(City,1,strpos(City,",")-1)
  gen state=trim(substr(City,strpos(City,",")+1,length(City)))
replace city="Brooklyn" if city=="Brookly"
replace city="Pittsburgh" if city=="Pittsburg"
replace city="Terre Haute" if city=="Terre Hante"
replace city="Wheeling" if city=="Whecling"
  replace state="AR" if state=="AK"
  replace state="IA" if state=="IO"
  replace state="CT" if state=="CN"
  replace state="KS" if state=="KN"
  drop City
  replace Industry=trim(Industry)
save dta/1900final,   replace
clear

foreach x in ARKANSAS CALIFORNIA COLORADO CONNECTICUT DELAWARE DC FLORIDA GEORGIA ILLINOIS INDIANA IOWA KANSAS KENTUCKY LOUISIANA MAINE MARYLAND MASSACHUSETTS MICHIGAN MINNESOTA MISSOURI MONTANA NEBRASKA NEWHAMPSHIRE NEWJERSEY NEWYORK NORTHCAROLINA OHIO OREGON PENNSYLVANIA RHODEISLAND SOUTHCAROLINA TENNESSEE TEXAS UTAH VIRGINIA WASHINGTON WESTVIRGINIA WISCONSIN{
  import excel using "src/1900-rev.xlsx", sheet("`x'") firstrow
rename CapitalTotal Capital
rename Land Capital_land
rename Buildings Capital_buildings
rename Machinerytools Capital_mne
rename Cashandsundries Capital_cash
rename Propietorsandfirmmembers proprietors
rename Salariedofficers officers
rename Salariessalariedofficials expenses_officials
rename Averagenumberofwageearners wageearners_av_total
rename Wages expenses_wageearners
rename Averagemens wageearners_av_male
rename Averagewomen wageearners_av_female
rename Averagechildren wageearners_av_under16
rename Wagesmen expenses_wageearners_male
rename Wageswomen expenses_wageearners_female
rename Wageschildren expenses_wageearners_under16
rename Totalmiscellaneousexpenses expenses_miscellaneous
rename Rentsofwork expenses_workrent
rename Taxesnotincluded expenses_taxes
rename Rentofoffices expenses_rent
rename Contractrwork expenses_contractwork
rename Total Valueofmaterials
rename Principlematerials expenses_materials_other
rename Fuelandrentofpower expenses_fuelandpower
rename Valueofproductsincluding Valueofproducts
foreach var of varlist Numberofestablishments-Valueofproducts{
replace `var'=0 if `var'==.
}
drop if Industry==""|City==""
gen year=1900
gen city=substr(City,1,strpos(City,",")-1)
  gen state=trim(substr(City,strpos(City,",")+1,length(City)))
replace city="Brooklyn" if city=="Brookly"
replace city="Pittsburgh" if city=="Pittsburg"
replace city="Terre Haute" if city=="Terre Hante"
replace city="Wheeling" if city=="Whecling"
  replace state="AR" if state=="AK"
  replace state="IA" if state=="IO"
  replace state="CT" if state=="CN"
  replace state="KS" if state=="KN"
  drop City
  replace Industry=trim(Industry)
  append using dta/1900final
save dta/1900final,   replace
clear
}   

use dta/1900final, clear
drop AC-AO AP-BM
gen personsinindustry_total=proprietors+officers+wageearners_av_total
egen expenses_total=rsum(expenses_wageearners_*)
replace expenses_total=expenses_total+expenses_miscellaneous
gen Valueaddedbymanufacture=Valueofproducts-Valueofmaterials
replace Industry="All other industries" if Industry=="All  other  industries"
replace Industry="All industries" if Industry=="All Industries"
replace Industry="All industries" if Industry=="All industries"
replace Industry="All other industries" if Industry=="All other   industries"
replace Industry="All other industries" if Industry=="All other  industries"
replace Industry="All other industries" if Industry=="All other Industries"
replace Industry="All other industries" if Industry=="all other industries"
replace Industry="All industries" if Industry=="all total industries"
replace Industry="Awnings, tents sails and canvas covers   " if Industry=="Awnings tents and sails"
replace Industry="Awnings, tents sails and canvas covers   " if Industry=="Awnings, tents and sails"
replace Industry="Awnings, tents sails and canvas covers   " if Industry=="Awnings, tents, and  sails"
replace Industry="Awnings, tents sails and canvas covers   " if Industry=="Awnings, tents, and sails"
replace Industry="Babbitt metal and solder" if Industry=="Babbit metal and solder"
replace Industry="Baking powders, yeast, and other leavening compounds " if Industry=="Baking and yeast  powders"
replace Industry="Baking powders, yeast, and other leavening compounds " if Industry=="Baking and yeast powders"
replace Industry="Baskets and rattan and willow ware, not including furniture" if Industry=="Baskets, and rattan and willow ware"
replace Industry="Bicycle and tricycle repairing" if Industry=="Bicycle  and tricycle repairing"
replace Industry="Bicycle and tricycle repairing" if Industry=="Bicycle and  tricycle  repairing"
replace Industry="Bicycle and tricycle repairing" if Industry=="Bicycle and Tricycle repairing"
replace Industry="Bicycle and tricycle repairing" if Industry=="Bicycle and tricycle reparing"
replace Industry="Bicycle and tricycle repairing" if Industry=="Bicycle and tricylce repairing"
replace Industry="Bicycles and tricycles" if Industry=="Bicycles andtricycles"
replace Industry="Blacking, stains, and dressings" if Industry=="Blacking"
replace Industry="Blacksmithing (wheelwrignting)" if Industry=="Blacksmithing  and  wheel wrighting"
replace Industry="Blacksmithing (wheelwrignting)" if Industry=="Blacksmithing (wheelwrighting)"
replace Industry="Blacksmithing (wheelwrignting)" if Industry=="Blacksmithing and  wheel wrighting"
replace Industry="Blacksmithing (wheelwrignting)" if Industry=="Blacksmithing and wheel wrighting"
replace Industry="Blacksmithing (wheelwrignting)" if Industry=="Blacksmithing and Wheelwrighting"
replace Industry="Blacksmithing (wheelwrignting)" if Industry=="Blacksmithing and wheelwrighting"
replace Industry="Bluing" if Industry=="Bluing"
replace Industry="Bluing" if Industry=="bluing"
replace Industry="Bookbinding and blank-book making" if Industry=="Bookbinding and blank book making"
replace Industry="Boot and shoe cut stock, not made in boot and shoe factories" if Industry=="Boot and shoe cut stock"
replace Industry="Boot and shoes uppers" if Industry=="Boot and shoe uppers"
replace Industry="Boots and shoes, including custom work and repairing" if Industry=="Boot and shoes, custom work"
replace Industry="Boot and shoes, factory product" if Industry=="Boot and shoes, factory products"
replace Industry="Boots and shoes, including custom work and repairing" if Industry=="Boots and  shoes,  custom work  and repairing"
replace Industry="Boots and shoes, including custom work and repairing" if Industry=="Boots and  shoes, custom work and repairing"
replace Industry="Boot and shoes uppers" if Industry=="Boots and shoe uppers"
replace Industry="Boots and shoes, including custom work and repairing" if Industry=="Boots and shoes custom work  and repairing"
replace Industry="Boot and shoes, factory product" if Industry=="Boots and shoes factory product"
replace Industry="Boot and shoes, factory product" if Industry=="Boots and shoes,  factory products"
replace Industry="Boots and shoes, including custom work and repairing" if Industry=="Boots and Shoes, custom work and repairing"
replace Industry="Boots and shoes, including custom work and repairing" if Industry=="Boots and shoes, custom work and repairing"
replace Industry="Boots and shoes, including custom work and repairing" if Industry=="Boots and shoes, custom work and repairing."
replace Industry="Boot and shoes, factory product" if Industry=="Boots and shoes, factory product"
replace Industry="Bottling" if Industry=="Botling"
replace Industry="Boxes, wooden, except cigar boxes " if Industry=="Boxes  wooden packing"
replace Industry="Boxes, wooden, except cigar boxes " if Industry=="Boxes wooden packing"
replace Industry="Boxes, fancy and paper" if Industry=="Boxes, fancy  and paper"
replace Industry="Boxes, wooden, except cigar boxes " if Industry=="Boxes, wooden packing"
replace Industry="Boxes, cigar" if Industry=="Boxes,cigar"
replace Industry="Brass and copper, rolled" if Industry=="Brass"
replace Industry="Brass castings" if Industry=="Brass casting and brass finishing"
replace Industry="Brass castings" if Industry=="Brass castings and brass finishing"
replace Industry="Brass castings" if Industry=="Brass castings and brass finishings"
replace Industry="Brass ware" if Industry=="Brassware"
replace Industry="Bread and other bakery products" if Industry=="Bread and  other  bakery products"
replace Industry="Bread and other bakery products" if Industry=="Bread and  other bakery products"
replace Industry="Brick and tile" if Industry=="Brick and  tile"
replace Industry="Brooms and brushes" if Industry=="Brooms  and brushes"
replace Industry="Carpets and rugs, other than rag" if Industry=="Carperts, wood"
replace Industry="Carpets and rugs, rag" if Industry=="Carpets rag"
replace Industry="Carpets and rugs, rag" if Industry=="Carpets, rag"
replace Industry="Carpets and rugs, other than rag" if Industry=="Carpets, wood"
replace Industry="Carpets and rugs, other than rag" if Industry=="carpets, wood"
replace Industry="Carriages, wagons, sleighs, and sleds" if Industry=="Carriage nd wagon materials"
replace Industry="Carriages, wagons, sleighs, and sleds" if Industry=="Carriages  and  wagons"
replace Industry="Carriages, wagons, sleighs, and sleds" if Industry=="Carriages and  wagons"
replace Industry="Carriages, wagons, sleighs, and sleds" if Industry=="Carriages and wagons"
replace Industry="Carriages, wagons, sleighs, and sleds" if Industry=="Carriaggonses  and  w"
replace Industry="Carriages, wagons, sleighs, and sleds" if Industry=="Carrieages  and wagons"
replace Industry="Car and general construction and repairs, steam-railroad repair shops" if Industry=="Cars  and  general  shop construction and  repairs   by  steam railroad companies"
replace Industry="Cars, steam and electric railroad, not built in railroad repair shops" if Industry=="Cars , steam  railroad, not  including operations  of  railroad companies"
replace Industry="Car and general construction and repairs, steam-railroad repair shops" if Industry=="Cars and  general  shop construction and  repairs  by steam railroad  companies"
replace Industry="Car and general construction and repairs, steam-railroad repair shops" if Industry=="Cars and  general shop construction and repairs  by railroad companies"
replace Industry="Car and general construction and repairs, steam-railroad repair shops" if Industry=="Cars and general  sho construction and  repairs  by  steam railroad companies"
replace Industry="Car and general construction and repairs, steam-railroad repair shops" if Industry=="Cars and general  shop   construction and repairs by street  railroad companies"
replace Industry="Car and general construction and repairs, steam-railroad repair shops" if Industry=="Cars and general shop constructin and repairs by steam rairoad companies"
replace Industry="Car and general construction and repairs, steam-railroad repair shops" if Industry=="Cars and general shop construction and reapirs by steam railroad companies"
replace Industry="Car and general construction and repairs, steam-railroad repair shops" if Industry=="Cars and general shop construction and repairs by  steam railroad companies"
replace Industry="Car and general construction and repairs, steam-railroad repair shops" if Industry=="Cars and general shop construction and repairs by steam railroad companies"
replace Industry="Car and general construction and repairs, steam-railroad repair shops" if Industry=="Cars and general shop construction and repairs by steam railroad companies."
replace Industry="Cars, steam and electric railroad, not built in railroad repair shops" if Industry=="Cars, steam railroad, not including operations of railroad companies"
replace Industry="Cars, steam and electric railroad, not built in railroad repair shops" if Industry=="Cars, steam rairlroad, not incluiding operations of railroad companies"
replace Industry="Cars, steam and electric railroad, not built in railroad repair shops" if Industry=="Cars, street railroad, not  including operations  of  railroad companies"
replace Industry="Cheese and butter (factory)     " if Industry=="Cheese and  butter, urban dairy products"
replace Industry="Cheese and butter (factory)     " if Industry=="Cheese and butter urban dairy products"
replace Industry="Cheese and butter (factory)     " if Industry=="Cheese and butter, urban dairy products"
replace Industry="Cheese and butter (factory)     " if Industry=="cheese and butter, urban dairy products"
replace Industry="Cheese and butter (factory)     " if Industry=="Cheese butter and condesed milk factory   product"
replace Industry="Cheese and butter (factory)     " if Industry=="Cheese, and butter, urban dairy products"
replace Industry="Cheese and butter (factory)     " if Industry=="Cheese, butter, and  condensed milk, factory product"
replace Industry="Cheese and butter (factory)     " if Industry=="Cheese, butter, and condensed milk, factory product"
replace Industry="Chemicals, not elsewhere classified" if Industry=="Chemical"
replace Industry="Chemicals, not elsewhere classified" if Industry=="Chemicals"
replace Industry="China firing and decorating, not done in potteries" if Industry=="China decorating"
replace Industry="Cleaning and polishing preparations    ," if Industry=="Cleansing  and polishing preparations"
replace Industry="Cleaning and polishing preparations    ," if Industry=="Cleansing and polishing preparations"
replace Industry="Clocks, clock movements, time-recording devices, and stamps" if Industry=="Clocks"
replace Industry="Clothing women's, dressmaking" if Industry=="Clohting, women's, dressmaking"
replace Industry="Clothing women's, factory product" if Industry=="Clohting, women's, factory product"
replace Industry="Cloth sponging and refinishing  " if Industry=="Cloth, sponing and refinishing"
replace Industry="Clothing men's, factory products buttonholes" if Industry=="Clothing  mens  factory  product  buttonholes"
replace Industry="Clothing women's, factory product" if Industry=="Clothing  womens factory  product"
replace Industry="Clothing men's, factory products" if Industry=="Clothing men's factory product"
replace Industry="Clothing men's, factory products" if Industry=="clothing men's factory product"
replace Industry="Clothing men's, factory products buttonholes" if Industry=="Clothing men's factory products buttonholes"
replace Industry="Clothing men's, factory products" if Industry=="Clothing men's, factory product"
replace Industry="Clothing men's, custom work and repairing" if Industry=="Clothing mens  custom work and repairing"
replace Industry="Clothing women's, factory product" if Industry=="Clothing women  factory   products"
replace Industry="Clothing women's, dressmaking" if Industry=="Clothing womens  dressmaking"
replace Industry="Clothing women's, factory product" if Industry=="Clothing womens  factory  product"
replace Industry="Clothing women's, dressmaking" if Industry=="Clothing womens dressmaking"
replace Industry="Clothing men's, factory products" if Industry=="Clothing, men s factory product"
replace Industry="Clothing men's, custom work and repairing" if Industry=="Clothing, men's custom work and repairing"
replace Industry="Clothing men's, factory products" if Industry=="Clothing, men's factory product"
replace Industry="Clothing men's, custom work and repairing" if Industry=="Clothing, men's, custom work and repair"
replace Industry="Clothing men's, custom work and repairing" if Industry=="Clothing, men's, custom work and repairing"
replace Industry="Clothing men's, factory products" if Industry=="Clothing, men's, factory product"
replace Industry="Clothing men's, custom work and repairing" if Industry=="Clothing, men¥s, custom work and repairing"
replace Industry="Clothing men's, factory products" if Industry=="Clothing, men¥s, factory  products"
replace Industry="Clothing men's, custom work and repairing" if Industry=="Clothing, mens custom  work and  repairing"
replace Industry="Clothing men's, custom work and repairing" if Industry=="Clothing, mens,  custom work  and repairing"
replace Industry="Clothing women's, dressmaking" if Industry=="Clothing, women s  dressmaking"
replace Industry="Clothing women's, factory product" if Industry=="Clothing, women's factory product"
replace Industry="Clothing women's, factory product" if Industry=="clothing, women's factory product"
replace Industry="Clothing women's, dressmaking" if Industry=="Clothing, women's, dressmaking"
replace Industry="Clothing women's, factory product" if Industry=="Clothing, women's, factory product"
replace Industry="Clothing women's, factory product" if Industry=="Clothing, womens factory  product"
replace Industry="Coffee and spice, roasting and grinding" if Industry=="Coffee and  spice,  roasting  and  grinding"
replace Industry="Coffee and spice, roasting and grinding" if Industry=="Coffee and  spice, roasting  and  grinding and  uphos"
replace Industry="Coffee and spice, roasting and grinding" if Industry=="Coffee and spice roasting and  grinding"
replace Industry="Coffins, burial cases, and undertakers' goods" if Industry=="Coffins, burial cases, and undertaker's goods"
replace Industry="Cork cutting" if Industry=="Cork, cutting"
replace Industry="Corsets and allied garments" if Industry=="Corsets"
replace Industry="Waste    " if Industry=="Cotton waste"
replace Industry="Cutlery (not including silver and plated cutlery) and edge tools" if Industry=="Cutlery and edge tools"
replace Industry="Druggists' preparations" if Industry=="drug grinding"
replace Industry="Druggists' preparations" if Industry=="Druggests' preparations, not including prescriptions"
replace Industry="Druggists' preparations" if Industry=="Druggists' preparations, not including prescriptions"
replace Industry="Druggists' preparations" if Industry=="Druggists' preparations, not including prescriptions."
replace Industry="Dyeing and cleaning" if Industry=="Dyeing and  cleaning"
replace Industry="Dyeing and cleaning" if Industry=="Dyeing and cleanings"
replace Industry="Electrical construction and repairs" if Industry=="Elecrical construccion and repairs"
replace Industry="Electrical construction and repairs" if Industry=="Electircal  construction and repairs"
replace Industry="Electrical construction and repairs" if Industry=="Electircal construction and repairs"
replace Industry="Electrical construction and repairs" if Industry=="Electrical  construction  and repairs"
replace Industry="Electrical construction and repairs" if Industry=="Electrical  construction and  repairs"
replace Industry="Electrical construction and repairs" if Industry=="Electrical  construction and repairs"
replace Industry="Electrical machinery, apparatus, and supplies" if Industry=="Electrical apparatus  and  supplies"
replace Industry="Electrical machinery, apparatus, and supplies" if Industry=="Electrical apparatus  and supplies"
replace Industry="Electrical machinery, apparatus, and supplies" if Industry=="Electrical apparatus and supplies"
replace Industry="Electrical construction and repairs" if Industry=="Electrical construction  and  repairs"
replace Industry="Electrical construction and repairs" if Industry=="Electrical construction and  repairs"
replace Industry="Electrical construction and repairs" if Industry=="Electrical construction and repairs"
replace Industry="Electrical construction and repairs" if Industry=="electrical construction and repairs"
replace Industry="Electrical construction and repairs" if Industry=="Electrical construction anf repairs"
replace Industry="Electrical construction and repairs" if Industry=="Electrical contruction and repairs"
replace Industry="Electrical construction and repairs" if Industry=="Electricial construciton and repairs"
replace Industry="Electrical construction and repairs" if Industry=="Electroical construccion and repairs"
replace Industry="Engraving (other than steel, copperplate, or wood), chasing, etching, and die-sinking" if Industry=="Engraving  and  diesinking"
replace Industry="Engraving (other than steel, copperplate, or wood), chasing, etching, and die-sinking" if Industry=="Engraving and diesinking"
replace Industry="Engraving, steel and copperplate, and plate printing" if Industry=="Engraving, steel, including plate printing"
replace Industry="Fancy and miscellaneous articles, not elsewhere classified" if Industry=="Fancy articles  not  elsewhere  specified"
replace Industry="Fancy and miscellaneous articles, not elsewhere classified" if Industry=="Fancy articles, not  elsewhere  specified"
replace Industry="Fancy and miscellaneous articles, not elsewhere classified" if Industry=="Fancy articles, not elsewhere specified"
replace Industry="Fish, canning and preserving" if Industry=="Fish , canning and preserving"
replace Industry="Flavoring extracts and flavoring sirups   " if Industry=="Flavoring extracts"
replace Industry="Flour and other grist-mill products    " if Industry=="Floruring and  grist  mill  products"
replace Industry="Flour and other grist-mill products    " if Industry=="Flouring  and  grist  mill products"
replace Industry="Flour and other grist-mill products    " if Industry=="Flouring  and  grist mill products"
replace Industry="Flour and other grist-mill products    " if Industry=="Flouring  and grist  mill products"
replace Industry="Flour and other grist-mill products    " if Industry=="Flouring and  grist  mill products"
replace Industry="Flour and other grist-mill products    " if Industry=="Flouring and grist  mill products"
replace Industry="Flour and other grist-mill products    " if Industry=="Flouring and grist mill producs"
replace Industry="Flour and other grist-mill products    " if Industry=="Flouring and grist mill products"
replace Industry="Flour and other grist-mill products    " if Industry=="Flouring anda  grist mill products"
replace Industry="Food preparations, not elsewhere classified   " if Industry=="Food preparations"
replace Industry="Foundry and machine-shop products, not elsewhere classified" if Industry=="Foundry and  machine shop products"
replace Industry="Foundry and machine-shop products, not elsewhere classified" if Industry=="Foundry and machine-shop products"
replace Industry="Foundry and machine-shop products, not elsewhere classified" if Industry=="Foundry and machine shop products"
replace Industry="Fruits and vegetables, canned and preserved" if Industry=="Fruits and vegetables, canning and preserving"
replace Industry="Fur goods       " if Industry=="Fur  goods"
replace Industry="Hats, fur-felt       " if Industry=="Fur  hats"
replace Industry="Hats, fur-felt       " if Industry=="Fur haat"
replace Industry="Hats, fur-felt       " if Industry=="Fur hats"
replace Industry="Hats, fur-felt       " if Industry=="fur hats"
replace Industry="Furniture" if Industry=="Furniture  cabinetmaking  repairing  and  upholstering"
replace Industry="Furniture" if Industry=="Furniture  cabinetmaking repairing and upholstering"
replace Industry="Furniture, factory products" if Industry=="Furniture  factory  product"
replace Industry="Furniture, factory products" if Industry=="Furniture  factory product"
replace Industry="Furniture" if Industry=="Furniture cabinemaking repairing and upholstering"
replace Industry="Furniture" if Industry=="Furniture Cabinetmaking  repairing"
replace Industry="Furniture" if Industry=="Furniture cabinetmaking  repairing and  upholstering"
replace Industry="Furniture" if Industry=="Furniture cabinetmaking  repairing and upholstering"
replace Industry="Furniture" if Industry=="Furniture cabinetmaking repairing and upholstering"
replace Industry="Furniture" if Industry=="Furniture cabinetmaking repairing and upholtering"
replace Industry="Furniture" if Industry=="Furniture cabinetmaking, repairing  and upholstering"
replace Industry="Furniture" if Industry=="Furniture cabinetmaking, repairing, and upholstering"
replace Industry="Furniture, factory products" if Industry=="Furniture factory product"
replace Industry="Furniture" if Industry=="Furniture, cabietmaking, repairing,  and  uphostering"
replace Industry="Furniture" if Industry=="Furniture, cabinetmaking, repairing and upholstering"
replace Industry="Furniture" if Industry=="Furniture, cabinetmaking, repairing and upholstering."
replace Industry="Furniture" if Industry=="Furniture, cabinetmaking, repairing, and  upholstering"
replace Industry="Furniture" if Industry=="Furniture, cabinetmaking, repairing, and upholstering"
replace Industry="Furniture" if Industry=="furniture, cabinetmaking, repairing, and upholstering"
replace Industry="Furniture" if Industry=="Furniture, cabinetmaking, repairing, and upholstering."
replace Industry="Furniture" if Industry=="Furniture, cabinetmaking, reparing, and upholstering"
replace Industry="Furniture" if Industry=="Furniture, Factory   product"
replace Industry="Furniture" if Industry=="Furniture, factory product"
replace Industry="Gas and electric fixtures; lamps, lanterns, and reflectors  " if Industry=="Gas and   lamp  fixtures"
replace Industry="Gas and electric fixtures; lamps, lanterns, and reflectors  " if Industry=="Gas and lamp  fixtures"
replace Industry="Gas and electric fixtures; lamps, lanterns, and reflectors  " if Industry=="Gas and lamp fixtures"
replace Industry="Gas, manufactured, illuminating and heating   " if Industry=="Gas, illuminating and heating"
replace Industry="Glass, cut, stained and ornamented" if Industry=="Glass, cutting, staining, and ornamenting"
replace Industry="Gold and silver leaf and foil" if Industry=="Gold and  silver leaf an  foll"
replace Industry="Gold, silver, and platinum, reducing and refining, not from the ore        " if Industry=="Gold and silver reducing  and  refining  not from the ore"
replace Industry="Grease and tallow, not including lubricating greases" if Industry=="Grease and tallow"
replace Industry="Hair work" if Industry=="Hairwork"
replace Industry="Hand stamps and stencils and brands    " if Industry=="Hand stamps"
replace Industry="Hardware" if Industry=="hardware"
replace Industry="Hardware, saddlery" if Industry=="Hardware  saddlery"
replace Industry="Hats and caps, except wool hats" if Industry=="Hats and  caps  not including  fur  hats and wool hats"
replace Industry="Hats and caps, except wool hats" if Industry=="Hats and  caps not  including fur hats  and  wool hats"
replace Industry="Hats and caps, except wool hats" if Industry=="Hats and caps not including fur hats and wool hats"
replace Industry="Hats and caps, except wool hats" if Industry=="Hats and caps, not including fur hats and wool hats"
replace Industry="Hosiery and knit goods" if Industry=="Hoslery and  kint goods"
replace Industry="Ice, artificial    " if Industry=="Ice  manufactured"
replace Industry="Ice, artificial    " if Industry=="Ice n manufactured"
replace Industry="Ice, artificial    " if Industry=="Ice, manufactured"
replace Industry="Iron forging" if Industry=="Iron and  steel  forgings"
replace Industry="Iron forging" if Industry=="Iron and steel forgings"
replace Industry="Iron work, achitectural and ornamental" if Industry=="Iron work architectural and ornamental"
replace Industry="Iron work, achitectural and ornamental" if Industry=="Iron work, architectural and ornamental"
replace Industry="Iron work, achitectural and ornamental" if Industry=="Ironwork, architectural and ornamental"
replace Industry="Ivory, shell, and bone work, not including buttons, combs, or hairpins" if Industry=="Ivory and bone work"
replace Industry="Kaolin and ground earths" if Industry=="Kaolin and other  earth grinding"
replace Industry="Kaolin and ground earths" if Industry=="Kaolin and other earth grinding"
replace Industry="Kindiling wood" if Industry=="Kindling wood"
replace Industry="Lapidary work -         " if Industry=="Lapidary work"
replace Industry="Lasts and related products " if Industry=="Lasts"
replace Industry="Smelting and refining, lead " if Industry=="Lead, smelting and refining"
replace Industry="Leather tanned" if Industry=="Leather  tanned  curried  and  finished"
replace Industry="Leather goods, not elsewhere classified " if Industry=="Leather goods"
replace Industry="Leather tanned" if Industry=="Leather, tanned, curried and finished"
replace Industry="Lumber and timber products, not elsewhere classified " if Industry=="Limber and timber products"
replace Industry="Lime " if Industry=="Lime  and  coment"
replace Industry="Lock- and gun smithing" if Industry=="Lime and  gu smithing"
replace Industry="Lime " if Industry=="Lime and cement"
replace Industry="Liquors,  malt" if Industry=="Liquers, malt"
replace Industry="Liquors,  malt" if Industry=="Liquors   malt"
replace Industry="Liquors,  malt" if Industry=="Liquors  malt"
replace Industry="Liquors,  malt" if Industry=="Liquors malt"
replace Industry="Liquors,  malt" if Industry=="Liquors, malt"
replace Industry="Lithographing " if Industry=="Lithographing and engraving"
replace Industry="Lock- and gun smithing" if Industry=="Lock and gun smithing"
replace Industry="Lock- and gun smithing" if Industry=="Lock and gunsmithing"
replace Industry="Looking-glass and picture frames" if Industry=="Looking-glass and picure frames"
replace Industry="Lumber and timber products, not elsewhere classified " if Industry=="Lumber  and timber  products"
replace Industry="Lumber and timber products, not elsewhere classified " if Industry=="Lumber  and timber products"
replace Industry="Lumber and timber products, not elsewhere classified " if Industry=="Lumber and  timber products"
replace Industry="Lumber and timber products, not elsewhere classified " if Industry=="Lumber and timber  products"
replace Industry="Lumber and timber products, not elsewhere classified " if Industry=="Lumber and timber products"
replace Industry="Lumber, planed" if Industry=="Lumber planing  mill products including sash, doors  and  blinds"
replace Industry="Lumber, planed" if Industry=="Lumber planing mill products  including sash doors and  blinds"
replace Industry="Lumber, planed" if Industry=="Lumber, planing  mill products, including sash, doors, and blinds"
replace Industry="Lumber, planed" if Industry=="Lumber, planing and mill products including sash, doors, and blinds"
replace Industry="Lumber, planed" if Industry=="Lumber, planing mil products, including sash, doors,  and  blinds"
replace Industry="Lumber, planed" if Industry=="Lumber, planing mill products, including sash doors and  blinds"
replace Industry="Lumber, planed" if Industry=="Lumber, planing mill products, including sash, doors, and blinds"
replace Industry="Lumber, planed" if Industry=="Lumber, planing mill products, including sash, doors, and blinds."
replace Industry="Lumber, planed" if Industry=="Lumber, planing mill products, including sash, doors, book and job"
replace Industry="Lumber, planed" if Industry=="Lumber,planed"
replace Industry="Lumber, planed" if Industry=="Lumet  planing mill products, including sash doors and  blinds"
replace Industry="Marble, granite, slate, and other stone products " if Industry=="Marbe and  stone  work"
replace Industry="Marble, granite, slate, and other stone products " if Industry=="Marbie and stone work"
replace Industry="Marble, granite, slate, and other stone products " if Industry=="Marble   and stone work"
replace Industry="Marble, granite, slate, and other stone products " if Industry=="Marble  and  stone  work"
replace Industry="Marble, granite, slate, and other stone products " if Industry=="Marble and  stone work"
replace Industry="Marble, granite, slate, and other stone products " if Industry=="Marble and stone  work"
replace Industry="Marble, granite, slate, and other stone products " if Industry=="Marble and stone work"
replace Industry="Masonry, brick and stone" if Industry=="Masonry  custom work"
replace Industry="Masonry, brick and stone" if Industry=="Masonry brick  and  stone"
replace Industry="Masonry, brick and stone" if Industry=="Masonry brick and  stone"
replace Industry="Mattresses and spring bed" if Industry=="Mattresses and  spring beds"
replace Industry="Mattresses and spring bed" if Industry=="Mattresses and spring beds"
replace Industry="Millinery, custom work" if Industry=="Millenery  custom work"
replace Industry="Millinery, custom work" if Industry=="Millinery"
replace Industry="Millinery, custom work" if Industry=="Millinery custom  work"
replace Industry="Mirrors, framed and unframed " if Industry=="Mirrors"
replace Industry="Models and patterns, not including paper patterns " if Industry=="Models and patterns"
replace Industry="Monuments and tombstones" if Industry=="Monumentes  and tombstones"
replace Industry="Monuments and tombstones" if Industry=="Monuments and  tombstones"
replace Industry="Mucilage, paste, and other adhesives, except glue and rubber cement        " if Industry=="Mucilage  and paste"
replace Industry="Mucilage, paste, and other adhesives, except glue and rubber cement        " if Industry=="Mucilage and paste"
replace Industry="Musical instruments and parts and materials, not elsewhere classified     " if Industry=="Musical  instruments  and  materials  not  specified"
replace Industry="Musical instruments and parts and materials, not elsewhere classified     " if Industry=="Musical  instruments and  materials, not specified"
replace Industry="Musical instruments and parts and materials, not elsewhere classified     " if Industry=="Musical instruments and materials, not specified"
replace Industry="Musical instrument, organ and materials" if Industry=="Musical instruments organs  and  materials"
replace Industry="Musical instrument, organ and materials" if Industry=="Musical instruments, organs and materials"
replace Industry="Musical instruments, piano and materials" if Industry=="Musical instruments, pianos and materials"
replace Industry="Oil, not elsewhere specified" if Industry=="Oil not elsewhere specified"
replace Industry="Oil, not elsewhere specified" if Industry=="oil not elsewhere specified"
replace Industry="Oil, cake, and meal, cottonseed " if Industry=="Oil, cottonseed and cake"
replace Industry="Oil, not elsewhere specified" if Industry=="Oil, not elsewhere  specified"
replace Industry="Oil, not elsewhere specified" if Industry=="Oil, not elsewhere especified"
replace Industry="Oil, not elsewhere specified" if Industry=="oil, not elsewhere specified"
replace Industry="Optical goods" if Industry=="Optical  goods"
replace Industry="Oysters, canning and preserving" if Industry=="Oysters, canningand preserving"
replace Industry="Paintings and paperhangings" if Industry=="Painting, house, sign, etc"
replace Industry="Paintings and paperhangings" if Industry=="Painting, house, sign, etc."
replace Industry="Paintings and paperhangings" if Industry=="Paintings, house, sign, etc"
replace Industry="Paints and varnishes" if Industry=="Paints"
replace Industry="Paperhangings" if Industry=="Paper  hanging"
replace Industry="Paper and wood pulp" if Industry=="Paper and  wood  pulp"
replace Industry="Paperhangings" if Industry=="Paper hanging"
replace Industry="Paperhangings" if Industry=="paper hanging"
replace Industry="Paperhangings" if Industry=="Paper hangings"
replace Industry="Paperhangings" if Industry=="paper hangings"
replace Industry="Paperhangings" if Industry=="Paperhanging"
replace Industry="Paperhangings" if Industry=="Paperhanging and Paperhangings"
replace Industry="Paper and wood pulp" if Industry=="Papers and wood pulp"
replace Industry="Paperhangings" if Industry=="Papers hanging"
replace Industry="Patent or proprietary medicines and compounds " if Industry=="Patent  medicines  and  compounds"
replace Industry="Patent or proprietary medicines and compounds " if Industry=="Patent medicines"
replace Industry="Patent or proprietary medicines and compounds " if Industry=="Patent medicines  and  compounds"
replace Industry="Patent or proprietary medicines and compounds " if Industry=="Patent medicines  and compounds"
replace Industry="Patent or proprietary medicines and compounds " if Industry=="Patent medicines and compounds"
replace Industry="Patent or proprietary medicines and compounds " if Industry=="Patente  medicines and  compounds"
replace Industry="Paving materials: asphalt, tar, crushed slag, and mixtures " if Industry=="Paving  and paving materials"
replace Industry="Paving materials: asphalt, tar, crushed slag, and mixtures " if Industry=="Paving and  paving materials"
replace Industry="Paving materials: asphalt, tar, crushed slag, and mixtures " if Industry=="Paving and paving  materials"
replace Industry="Paving materials: asphalt, tar, crushed slag, and mixtures " if Industry=="Paving and paving materials"
replace Industry="Perfumes, cosmetics, and other toilet preparations " if Industry=="Perfumery and  cosmetics"
replace Industry="Perfumes, cosmetics, and other toilet preparations " if Industry=="Perfumery and cosmetics"
replace Industry="Perfumes, cosmetics, and other toilet preparations " if Industry=="perfumery and cosmetics"
replace Industry="Photographing" if Industry=="Photogaphy"
replace Industry="Photographing" if Industry=="Photograhy"
replace Industry="Photographic apparatus and materials " if Industry=="Photographic apparatus"
replace Industry="Photographic apparatus and materials " if Industry=="Photographic materials"
replace Industry="Photographic apparatus and materials " if Industry=="photographic materials"
replace Industry="Photographing" if Industry=="Photography"
replace Industry="Photolithographing and engraving" if Industry=="Photolithographin and photoengraving"
replace Industry="Photolithographing and engraving" if Industry=="Photolithographing and Photoengraving"
replace Industry="Photolithographing and engraving" if Industry=="Photolithographing and photoengraving"
replace Industry="Pickles, preserves, and sauces" if Industry=="Pickles preserves and sauces"
replace Industry="Pipes (tobacco) " if Industry=="Pipes, tobacco"
replace Industry="Plastering and stuccowork" if Industry=="Plasstering and stuccowork"
replace Industry="Plastering and stuccowork" if Industry=="Plastering  and stuccowork"
replace Industry="Plastering and stuccowork" if Industry=="Plastering and  stuccowork"
replace Industry="Plumbers' supplies, not including pipe or vitreous-china sanitary ware    " if Industry=="Plumbers  supplies"
replace Industry="Plumbers' supplies, not including pipe or vitreous-china sanitary ware    " if Industry=="Plumbers supplies"
replace Industry="Plumbers' supplies, not including pipe or vitreous-china sanitary ware    " if Industry=="Plumbers suppllies"
replace Industry="Plumbing and gasfitting" if Industry=="Plumbing  and  gas  ans steam  fitting"
replace Industry="Plumbing and gasfitting" if Industry=="Plumbing ,  and  gas  and steam fitting"
replace Industry="Plumbing and gasfitting" if Industry=="Plumbing and  gas and steam fiting"
replace Industry="Plumbing and gasfitting" if Industry=="Plumbing and gas  and steam fitting"
replace Industry="Plumbing and gasfitting" if Industry=="Plumbing and gas and steam fitting"
replace Industry="Plumbing and gasfitting" if Industry=="Plumbing and gas ans  steam  fitting"
replace Industry="Plumbing and gasfitting" if Industry=="Plumbing, and gas  and  steam fitting"
replace Industry="Plumbing and gasfitting" if Industry=="Plumbing, and gas and steam fiting"
replace Industry="Plumbing and gasfitting" if Industry=="Plumbing, and gas and steam fitting"
replace Industry="Pottery, terra cotta, and fire-clay products" if Industry=="Pottery"
replace Industry="Pottery, terra cotta, and fire-clay products" if Industry=="Pottery terra cotta and fire clay products"
replace Industry="Printing and publishing, newspaper and periodical" if Industry=="Printing  and  publishing newspapers  and periodicals"
replace Industry="Printing and publishing, book and job " if Industry=="Printing and publishing book and  job"
replace Industry="Printing and publishing, newspaper and periodical" if Industry=="Printing and publishing newspapers and  periodicals"
replace Industry="Printing and publishing, book and job " if Industry=="Printing and publishing, book and job  and job"
replace Industry="Printing and publishing, newspaper and periodical" if Industry=="Printing and publishing, newspapers and periodicals"
replace Industry="Pumps (hand and power) and pumping equipment" if Industry=="Pumps, not including steam pumps"
replace Industry="Paperhangings" if Industry=="Puper  hanging"
replace Industry="Regalia, badges, and emblems" if Industry=="Regalia  and society banners  and emblema"
replace Industry="Roofing, built-up and roll; asphalt shingles; roof coatings other than paint    " if Industry=="Roofing  and  roofing  materials"
replace Industry="Roofing, built-up and roll; asphalt shingles; roof coatings other than paint    " if Industry=="Roofing  and  roofing materials"
replace Industry="Roofing, built-up and roll; asphalt shingles; roof coatings other than paint    " if Industry=="Roofing  and roofing materials"
replace Industry="Roofing, built-up and roll; asphalt shingles; roof coatings other than paint    " if Industry=="Roofing and  roofing materials"
replace Industry="Roofing, built-up and roll; asphalt shingles; roof coatings other than paint    " if Industry=="Roofing and roofing  materials"
replace Industry="Roofing, built-up and roll; asphalt shingles; roof coatings other than paint    " if Industry=="Roofing and roofing materials"
replace Industry="Rubber goods other than tires, inner tubes, and boots and shoes" if Industry=="Rubber  and elastic goods"
replace Industry="Rubber goods other than tires, inner tubes, and boots and shoes" if Industry=="Rubber and  elastic goods"
replace Industry="Rubber goods other than tires, inner tubes, and boots and shoes" if Industry=="Rubber and  eleastic  goods"
replace Industry="Rubber goods other than tires, inner tubes, and boots and shoes" if Industry=="Rubber and elastic goods"
replace Industry="Saddlery and harness" if Industry=="Saddlery  and harness"
replace Industry="Safes, doors, and vaults, fire-proof" if Industry=="Safes and vaults"
replace Industry="Sausage, meat puddings, headcheese, etc, and sausage casings, not made in meat-packing establishments" if Industry=="Sausage"
replace Industry="Sewing-machine repairing" if Industry=="Sewing machine repairing"
replace Industry="Sewing-machine repairing" if Industry=="Sewingmachi repairing"
replace Industry="Ship and boat building, wooden" if Industry=="Ship  and boat  building, wooden"
replace Industry="Ship and boat building, wooden" if Industry=="Ship  and boat building wooden"
replace Industry="Ship and boat building, wooden" if Industry=="Ship and  boat  building,  wooden"
replace Industry="Ship and boat building, wooden" if Industry=="Ship and boat building,  wooden"
replace Industry="Ship and boat building, wooden" if Industry=="Ship and boat bulding, wooden"
replace Industry="Show-cases" if Industry=="Show cases"
replace Industry="Slaughtering and meat-packing, wholesale" if Industry=="Slaughtering  and meat packing wholesale"
replace Industry="Slaughtering and meat-packing, wholesale" if Industry=="Slaughtering and  meat  packing, wholesale"
replace Industry="Slaughtering and meat-packing, wholesale" if Industry=="Slaughtering and meat  packing, wholesale"
replace Industry="Slaughtering and meat-packing, wholesale" if Industry=="Slaughtering and meat packing, wholesale"
replace Industry="Slaughtering, wholesale, not including meat packing" if Industry=="Slaughtering, wholesale, notincluding meat pakcing"
replace Industry="Smelting and refining, metals other than gold, silver, or platinum, not from the ore" if Industry=="Smelting  and refining not from the ore"
replace Industry="Soap and candles" if Industry=="Soap  and candles"
replace Industry="Soap and candles" if Industry=="Soap and candle"
replace Industry="Sporting and athletic goods, not including firearm or ammuniton" if Industry=="Sporting  goods"
replace Industry="Springs, steel, car, and carriage" if Industry=="Spring  steel,  car  and   carriage"
replace Industry="Stamped ware, enameled ware, and metal stamping, enameling, japanning, and lacquering" if Industry=="Stamped ware"
replace Industry="Stationery goods, not elsewhere classified " if Industry=="Stationary goods, not elsewhere specified"
replace Industry="Steam fittings and steam and hot-water heating apparatus" if Industry=="Steam fittings and heating apparatus"
replace Industry="Steam and other packing, pipe and boiler covering, and gaskets, not elsewhere classified " if Industry=="Steam packing"
replace Industry="Stereotyping and electrotyping, not done in printing establishments" if Industry=="Stereotyping and electrotyping"
replace Industry="Sugar and molasses, refined" if Industry=="Sugar and molasses, refining"
replace Industry="Surgical and orthopedic appliances, including artificial limbs" if Industry=="Surgical appliances"
replace Industry="tin and terne plate" if Industry=="Ti and terne plate"
replace Industry="Tinware, copperware, and sheet-iron ware" if Industry=="Ti smithin, coppersmithin,  and   sheet-iron  working"
replace Industry="Tinware, copperware, and sheet-iron ware" if Industry=="Tinsmeithing coppersmithing and sheet ion workingr"
replace Industry="Tinware, copperware, and sheet-iron ware" if Industry=="Tinsmeithing coppersmithing and sheet iron working"
replace Industry="Tinware, copperware, and sheet-iron ware" if Industry=="Tinsmething coppersmithing and sheet-iron  working"
replace Industry="Tinware, copperware, and sheet-iron ware" if Industry=="Tinsmithing  coppersmithing and  sheet iron working"
replace Industry="Tinware, copperware, and sheet-iron ware" if Industry=="Tinsmithing  coppersmithing and  sheet-iron  working"
replace Industry="Tinware, copperware, and sheet-iron ware" if Industry=="Tinsmithing coppersmithing  and sheet iron working"
replace Industry="Tinware, copperware, and sheet-iron ware" if Industry=="Tinsmithing coppersmithing and  ssheet iron working"
replace Industry="Tinware, copperware, and sheet-iron ware" if Industry=="Tinsmithing coppersmithing and sheet iron  working"
replace Industry="Tinware, copperware, and sheet-iron ware" if Industry=="Tinsmithing coppersmithing and sheet iron working"
replace Industry="Tinware, copperware, and sheet-iron ware" if Industry=="Tinsmithing coppersmithing, and sheet-iron working"
replace Industry="Tinware, copperware, and sheet-iron ware" if Industry=="Tinsmithing, coppersmithinf, and  sheet-iron working"
replace Industry="Tinware, copperware, and sheet-iron ware" if Industry=="Tinsmithing, coppersmithing and  sheet-iron working"
replace Industry="Tinware, copperware, and sheet-iron ware" if Industry=="Tinsmithing, coppersmithing, and sheet-iron working"
replace Industry="Tinware, copperware, and sheet-iron ware" if Industry=="Tinsmithing, coppersmithing, and sheet-iron working."
replace Industry="Tobacco: chewing and smoking, and snuff  " if Industry=="Tobacc. Chewing, smoking  and"
replace Industry="Tobacco: chewing and smoking, and snuff  " if Industry=="Tobacco  chewing smoking and snuff"
replace Industry="Tobacco, stemming and rehandling" if Industry=="Tobacco  stemming an rehandling"
replace Industry="Tobacco, cigars and cigarrettes" if Industry=="Tobacco cigars  and  cigarettes"
replace Industry="Tobacco: chewing and smoking, and snuff  " if Industry=="Tobacco, chewing, smoking, and snuff"
replace Industry="Tobacco, cigars and cigarrettes" if Industry=="Tobacco, cigars and cigaretes"
replace Industry="Tobacco, cigars and cigarrettes" if Industry=="Tobacco, cigars and cigarettes"
replace Industry="Tobacco, stemming and rehandling" if Industry=="Tobacco, stemming and rehanling"
replace Industry="Tobacco, cigars and cigarrettes" if Industry=="Tobaccoo cigars  and  cigarette"
replace Industry="Tobacco, cigars and cigarrettes" if Industry=="Tobbacco cigars  and cigarettes"
replace Industry="Tools, not including edge tools, machine tools, files, or saws" if Industry=="Tools not elsewhere  secified"
replace Industry="Tools, not including edge tools, machine tools, files, or saws" if Industry=="Tools not elsewhere specified"
replace Industry="Tools, not including edge tools, machine tools, files, or saws" if Industry=="Tools not elsewhere specifled"
replace Industry="Tools, not including edge tools, machine tools, files, or saws" if Industry=="Tools, not elsewher specified"
replace Industry="Tools, not including edge tools, machine tools, files, or saws" if Industry=="Tools, not elsewhere specified"
replace Industry="Toys (not including children's wheel goods or sleds), games, and playground equipment   " if Industry=="Toys and games"
replace Industry="Trunks, suitcases, and bags " if Industry=="Trunks and   valises"
replace Industry="Trunks, suitcases, and bags " if Industry=="Trunks and  valises"
replace Industry="Trunks, suitcases, and bags " if Industry=="Trunks and valieses"
replace Industry="Trunks, suitcases, and bags " if Industry=="Trunks and valises"
replace Industry="Typewriter repairing" if Industry=="Typerwriter repairing"
replace Industry="Typewriter repairing" if Industry=="Typewriter   repairing"
replace Industry="Typewriter repairing" if Industry=="Typewriter repairing"
replace Industry="Typewriter repairing" if Industry=="typewriter repairing"
replace Industry="Typewriters and parts     " if Industry=="Typewriters and supplies"
replace Industry="Typewriter repairing" if Industry=="Typewriters repairing"
replace Industry="Umbrellas, parasols, and canes     " if Industry=="Umbrellas and canes"
replace Industry="Washing machines, wringers, driers, and ironing machines for household use" if Industry=="Washing  machines and  clothes wringers"
replace Industry="Watch and clock repairing" if Industry=="Watch  clock  and jewelry repairing"
replace Industry="Watch and clock repairing" if Industry=="Watch clock  and  jewelry repairing"
replace Industry="Watch and clock repairing" if Industry=="Watch clock and  jewelry repairing"
replace Industry="Watch and clock repairing" if Industry=="Watch clock and jewelry  repairing"
replace Industry="Watch and clock repairing" if Industry=="Watch clock and jewelry repairing"
replace Industry="Watch and clock repairing" if Industry=="Watch, clock and jewelry repairing"
replace Industry="Watch and clock repairing" if Industry=="Watch, clock and jewerly repairing"
replace Industry="Watch and clock repairing" if Industry=="Watch, clock and jewlelry repairing"
replace Industry="Watch and clock repairing" if Industry=="Watch, clock,  and jewelry repairing"
replace Industry="Watch and clock repairing" if Industry=="Watch, clock, and jewelry  repairing"
replace Industry="Watch and clock repairing" if Industry=="Watch, clock, and jewelry repairing"
replace Industry="Watch and clock repairing" if Industry=="Watch, clock, and jewelry reparing"
replace Industry="Watch and clock repairing" if Industry=="Watch, clock, and jewlry reparing"
replace Industry="Watch and clock repairing" if Industry=="Watch, clock,and jewelry repairing"
replace Industry="Windmills and windmill towers   " if Industry=="Windmills"
replace Industry="Window shades and fixtures       " if Industry=="Window shades"
replace Industry="Wirework   " if Industry=="Wirework  including wire rope and  cable"
replace Industry="Wirework   " if Industry=="Wirework, including  wire  rope  and cable"
replace Industry="Wirework   " if Industry=="Wirework, including wire rope and cable"
replace Industry="Wood turned and shaped and other wooden goods, not elsewhere classified      " if Industry=="Wood turned  and  carved"
replace Industry="Wood turned and shaped and other wooden goods, not elsewhere classified      " if Industry=="Wood, turned and carved"
replace Industry="Wood turned and shaped and other wooden goods, not elsewhere classified      " if Industry=="Woodenware not  elsewhere  specifled"
replace Industry="Worsted goods    " if Industry=="worsted goods"
replace Industry=trim(Industry)
gen d_county=1
gen d_city=1
save dta/1900final,   replace
clear


forval i=1/109{
  import excel using "src/1910 Census Industry-City2.xls", sheet("Hoja`i'") firstrow
  rename Total personsinindustry_total
  rename Proprietorsandfirmmember proprietors
  rename Salariedofficerssuperint salariedofficers
  rename Male clerks_male
  rename Female clerks_female
  rename I wageearners_av_total
  rename J wageearners_av_male
  rename K wageearners_av_female
  rename Under16 wageearners_av_under16
  rename M wageearners_dec15_total
  rename N wageearners_dec15_adult_male
  rename O wageearners_dec15_adult_female
  rename P wageearners_dec15_under16_male
  rename Q wageearners_dec15_under16_female
  rename T expenses_total
  rename Officials expenses_officers
  rename Clerks expenses_clerks
  rename Wageearners expenses_wageearners
  rename Fuelandrentofpowe expenses_fuelandpower
  rename Other expenses_materials_other
  gen Valueofmaterials=expenses_materials_other+expenses_fuelandpower
  gen clerks=clerks_male+clerks_female
  rename Rentoffactory expenses_rent
  rename Taxesincluding expenses_taxes
  rename Contractwork expenses_contractwork
  rename AC expenses_other
  if `i'>1{
  append using dta/1910final
  }
  save dta/1910final,   replace
  clear
  }

  use dta/1910final
  drop AF-AP
    gen year=1910
  drop if City==""
  gen city=substr(City,1,strpos(City,",")-1)
  gen state=trim(substr(City,strpos(City,",")+1,length(City)))
  replace city="Houston" if city=="Houson"
  replace city="Johnstown" if city=="Johstown"
  replace city="Pittsburgh" if city=="Pittsburg"
  replace city="Wilkesbarre" if city=="Wilkesbare"
  replace state="AR" if state=="AK"
  replace state="CT" if state=="CN"
  replace state="KS" if state=="KN"
  drop City
  egen officers=rsum(salariedofficers clerks)
  egen expenses_officials=rsum(expenses_officers expenses_clerks)
  replace Industry=trim(Industry)
  gen d_county=1
  gen d_city=1
  save dta/1910final,   replace
  clear

  import excel using "src/1920-Census-Industry-City-rev.xls", sheet("Hoja1") firstrow 
  rename Total personsinindustry_total
  rename Proprietorsandfirmmember proprietors
  rename Salariedofficerssuperint salariedofficers
  rename Male clerks_male
  rename Female clerks_female
  rename I wageearners_av_total
  rename J wageearners_dec15_total
  rename K wageearners_dec15_adult_male
  rename L wageearners_dec15_adult_female
  rename M wageearners_dec15_under16_male
  rename N wageearners_dec15_under16_female
  rename Officials expenses_officers
  rename Clerks expenses_clerks
  rename Wageearners expenses_wageearners
  rename Fuelandrentofpowe expenses_fuelandpower
  rename Materials expenses_materials_main
  gen Valueofmaterials=expenses_materials_main+expenses_fuelandpower
  gen clerks=clerks_male+clerks_female
  egen officers=rsum(salariedofficers clerks)
  egen expenses_officials=rsum(expenses_officers expenses_clerks)
  rename Rentoffactory expenses_rent
  rename Taxesincluding expenses_taxes
  rename Contractwork expenses_contractwork
  gen year=1920
  gen city=trim(substr(City,1,strpos(City,",")-1))
  gen state=trim(substr(City,strpos(City,",")+1,length(City)))
  replace state="AR" if state=="AK"
  replace state="CT" if state=="CN"
  replace state="KS" if state=="KN"
  drop if state=="Porto Rico"
  drop City
  replace Industry=trim(Industry)
  gen d_county=1
  gen d_city=1
  save dta/1920final,   replace
  clear

  import excel using "src/1930-Census-Industry-City.xls", sheet(Sheet1) firstrow
  rename Salariedofficersandemployees officers
  rename Wageearnersaveragefortheye wageearners_av_total
  rename Horsepowerratedcapacityofp Primaryhorsepower
  rename Electricmotorsdrivenbyp Electricmotors
  rename Salaries expenses_officials
  rename Wages expenses_wageearners
  rename Costofmaterialsandcontainers expenses_materials_main
  rename Costoffuelandpurchasedelect expenses_fuelandpower
  gen Valueofmaterials=expenses_materials_main+expenses_fuelandpower
  gen personsinindustry_total=officers+wageearners_av_total
  drop O-T 
  gen year=1930
  gen city=trim(substr(City,1,strpos(City,",")-1))
  gen state=trim(substr(City,strpos(City,",")+1,length(City)))
  replace state="CT" if state=="CN"
  replace state="PA" if state=="PN"
  drop City
  replace Industry=trim(Industry)
  gen d_county=1
  gen d_city=1
  save dta/1930final,   replace
  clear
  
  import excel using "src/1940-Census-Industry-City-rev2.xls", sheet("ALABAMA") firstrow
  rename Propietorsandfirmmembers proprietors
  rename Salariedofficersofcorporation salariedofficers
  rename Wageearnersaveragenumber wageearners_av_total
  rename Salariedemployees clerks
  rename Salariesofofficersof expenses_officers
  rename Salariesofemployees expenses_clerks
  rename Wages expenses_wageearners
  rename Costofmaterialssuppliesfue Valueofmaterials
  save dta/1940final,   replace
  clear
  
  foreach x in CALIFORNIA COLORADO CONNECTICUT DELAWARE DC FLORIDA GEORGIA ILLINOIS INDIANA IOWA KANSAS KENTUCKY LOUISIANA MARYLAND MASSACHUSETTS MICHIGAN MINNESOTA MISSOURI NEWJERSEY NEWYORK NORTHCAROLINA OHIO OKLAHOMA OREGON PENNSYLVANIA RHODEISLAND TENNESSEE TEXAS VIRGINIA WASHINGTON WISCONSIN{
  import excel using "src/1940-Census-Industry-City-rev2.xls", sheet("`x'") firstrow
  rename Propietorsandfirmmembers proprietors
  rename Salariedofficersofcorporation salariedofficers
  rename Wageearnersaveragenumber wageearners_av_total
  rename Salariedemployees clerks
  rename Salariesofofficersof expenses_officers
  rename Salariesofemployees expenses_clerks
  rename Wages expenses_wageearners
  rename Costofmaterialssuppliesfue Valueofmaterials
  append using dta/1940final
  save dta/1940final,   replace
  clear
  }
 
 
  use dta/1940final
  gen year=1940
  drop N-AP
  drop if City==""
  drop if Industry=="Total"
  drop if Industry=="All industries, total"
  gen city=trim(substr(City,1,strpos(City,",")-1))
  gen state=trim(substr(City,strpos(City,",")+1,length(City)))
  drop City
  replace Industry=trim(Industry)
  egen officers=rsum(salariedofficers clerks)
  egen expenses_officials=rsum(expenses_officers expenses_clerks)
  gen personsinindustry_total=officers+wageearners_av_total+proprietors
  gen d_county=1
  gen d_city=1
  save dta/1940final,   replace
  clear 
  
  use dta/1940final
  append using dta/1880final
  append using dta/1890final
  append using dta/1900final
  append using dta/1910final
  append using dta/1920final
  append using dta/1930final
  save dta/industry_by_city,   replace
 
  
  
  replace Industry="Automobiles, including bodies and parts" if Industry=="Automobiles,including bodies and parts"
  replace Industry="Bags, other than paper" if Industry=="Bags, other than paper, not made in textile mills" | Industry=="Bags,other than paper"|Industry=="Bags, other than paper"
  replace Industry="Belting and hose, leather" if Industry=="Belting and hose ,leather"
  replace Industry="Boots and shoes, including cut stock and findings" if Industry=="Boots and shoes,including out stock and fidings" 
  replace Industry="Boxes, fancy and paper" if Industry=="Boxes, faney and paper"|Industry=="Boxes,fancy and paper"
  replace Industry="Boxes,cigar" if Industry=="Boxes, cigar" & year~=1900
  replace Industry="Bread and other bakery products" if Industry=="Bread and other bakery product"|Industry=="Brean and other bakery products"
  replace Industry="Butter, cheese and condensed milk" if Industry=="Butter,cheese and condensed"
  replace Industry="Carpets and rugs, other than rag" if Industry=="Carpets and rugs,othes than rag"
  replace Industry="Carpets and rugs, rag" if Industry=="Carpets,rag"
  replace Industry="Carriages and wagons" if Industry=="Carriages and wwaggons"
  replace Industry="Carriages and wagons and materials" if Industry=="Carriages and wagons  and materials"|Industry=="Carriages and wagonsand materoals"|Industry=="Carrieages and wagons and materials"
  replace Industry="Cars and general shop" if Industry=="Cars and general chop"
  replace Industry="Cars and general shop construction" if Industry=="Cars and general shop construction and" | Industry=="Cars and general shop contruction"
  replace Industry="Clothing, men's" if Industry=="Clothing men"|Industry=="Clothing, mens"|Industry=="Clothings mens"
  replace Industry="Clothing, men's, including shirts" if Industry=="Clothing ,mens including shirts"| Industry=="Clothing mens including shirts"
  replace Industry="Clothing, women's" if Industry=="Clothing women"|Industry=="Clothing, womens"|Industry=="Clothings womens"
  replace Industry="Confectionery" if Industry=="Confectionary"
  replace Industry="Cooperage and wooden goods" if Industry=="Cooperage and wooden"|Industry=="Cooperageand wooden good"
  replace Industry="Copper, tin, and sheet-iron products" if Industry=="Copper ,tin,and sheet-iron products"|Industry=="Copper, tin , and sheet-iron products"|Industry=="Copper,tin and sheet iron products"|Industry=="Copper,tin and sheet-iron products"|Industry=="Copper,tin and shoot-iron products"|Industry=="Copper,tin,and sheet-iron products"|Industry=="Copper,tiu and sheet-iron products"
  replace Industry="Cork, cutting" if Industry=="Cork cutting" & year~=1900
  replace Industry="Dentistry, mechanical" if Industry=="Dentistry mechanical"
  replace Industry="Flour and other grist-mill products" if Industry=="Flour -mill and gristmill products"|Industry=="Flour-mill and gristmiil products"|Industry=="Flour-mill and gristmill products"
  replace Industry="Foundry and machine-shop products, not elsewhere classified" if Industry=="Foundery and machine"|Industry=="Foundery and machine-shop products, not elsewhere classified"
  replace Industry="Foundry and machine-shop products" if (Industry=="Foundry and machine shop products"|Industry=="Foundry andd machine-shop products") & year~=1900
  replace Industry="Furniture and refrigerators" if Industry=="Furniture and refrigeratos"
  replace Industry="Gas and electric fixtures; lamps, lanterns, and reflectors" if Industry=="Gas and electrc fictures and lamps and reflectors"|Industry=="Gas and electric fixtures and lamps"|Industry=="Gas and electric fixtures and lamps and reflectorors"|Industry=="Gas and electric fixtures and lamps and reflectors"
  replace Industry="Gloves and mittens, leather" if Industry=="Gloves and mittens leather"|Industry=="Gloves and mittens,leather"
  replace Industry="Hats and caps, except felt, straw and wool" if Industry=="Hats and caps.other than felt,straw,and wool"
  replace Industry="Hats, fur-felt" if Industry=="Hats,fur-felt"
  replace Industry="Hosiery and knit goods" if Industry=="Hostery and knit goods"
  replace Industry="Ice, manufactured" if Industry=="Ice,manufactured"
  replace Industry="Ink, printing" if Industry=="Ink,priting"
  replace Industry="Instruments, professional and scientific" if Industry=="Instruments,profressional and scientific"
  replace Industry="Iron and steel; steel works and rolling" if Industry=="Iron and steel,steel works and rolling"
  replace Industry="Iron railings, wrought" if Industry=="Iron railing, wrought"
  replace Industry="Iron work, architectural and ornamental" if (Industry=="Iron work, achitectural and ornamental"|Industry=="Iron work,architectural and ornamental") & year~=1900
  replace Industry="Kindling wood" if (Industry=="Kindiling wood" | Industry=="Knidling goods") & year~=1900
  replace Industry="Lapidary work" if Industry=="Lapidary work -" & year~=1900
  replace Industry="Leather tanned" if Industry=="Leather ,tanned"|Industry=="Leather,tanned"
  replace Industry="Leather tanned, curried, and finished" if Industry=="Leather, tanned,curried,and finished"|Industry=="Leather,tanned,curried and finished"|Industry=="Leather,tanner,curried"
  replace Industry="Liquors, malt" if (Industry=="Liquors,  malt"|Industry=="Liquors,malt") & year~=1900
  replace Industry="Looking-glass and picture frames" if Industry=="Looking glass and picture frames"|Industry=="looking glassand picture frames"
  replace Industry="Lumber,planed" if Industry=="Lumber, planed" & year~=1900
  replace Industry="Mattresses and spring beds" if (Industry=="Matiresses and spring beds"|Industry=="Matresses and spring beds"|Industry=="Mattresses and spring bed") & year~=1900
  replace Industry="Mineral and soda water" if Industry=="Mineral and soda waters"
  replace Industry="Musical instruments, piano and materials" if Industry=="Musical instruments,pianos and materials"
  replace Industry="Musical instruments, pianos and organs and materials" if Industry=="Musical instruments,pianos and organs and materials"
  replace Industry="Paper goods, not elsewhere classified" if Industry=="Paper goods,not elsewhere specifled"
  replace Industry="Patent medicines and compounds" if Industry=="Patent medicines and compounds and druggists preparations"
  replace Industry="Peanuts, grading, roasting, cleaning and shelling" if Industry=="Peants ,grading,roasting,cleaning and shelling"
  replace Industry="Printing and publishing" if Industry=="Priting and publishing"
  replace Industry="Sash, doors and blinds" if Industry=="Sash, doors and blinds"
  replace Industry="Slaughtering and meat packing" if Industry=="Slaughtering and meat packinn"|Industry=="Slaughtering and ment packing"
  replace Industry="Stoves and furnaces" if Industry=="Stoves and furnaces,"|Industry=="Stoves and furnases"
  replace Industry="Tobacco manufactures" if Industry=="Tobacco manifactures"|Industry=="Tobacco manufastures"
  replace Industry="Tobacco, cigars and cigarrettes" if Industry=="Tobacco,vigars and cigarettes"
  replace Industry="Windows, blinds and shades" if Industry=="Windows, blinds and shades"
  replace Industry="Wood turned and carved" if Industry=="Wood.turned and carved"
  replace Industry="Woolen, worsted" if Industry=="Woolen,worsted" |Industry=="Woolesn,worsted"
  replace Industry="Paperhangings" if Industry=="paperhangings"
  replace Industry="Printing materials" if Industry=="printing materials"
  
  replace Industry=trim(Industry)
  save dta/industry_by_city,   replace
  
  replace state="KS" if state=="Kans."
  replace state="OR" if state=="Oreg"
  
  rename state st_ab


replace city="Cincinnati" if city=="Cincinatti"
replace city="Huntington" if city=="Huntingon"
replace city="Kansas City" if city=="Kansas Citiy"
replace st_ab="AL" if city=="Mobile"
replace city="Philadelphia" if city=="Philadephia"
replace city="Scranton" if city=="Scraton"
replace st_ab="NY" if city=="Troy"
replace city="Wilkes-Barre" if city=="Wilkesbarre" | city=="Wilkes-barre"
replace city="Worcester" if city=="Worchester"

gen comma=", "
gen city_st = city + comma + st_ab
merge m:1 city_st using dta/county-city-new2
tab _merge
drop if _merge==2
drop if Industry==""
drop _merge 
*goodcityproxy maxcityct minshrcty maxshrcty avail*
replace countyid=3600610 if city_st=="Brooklyn, NY" | city_st=="New York, NY"
append using dta/industry_by_county


gen statea=string(floor(countyid/10000))
replace statea="0"+statea if countyid<1000000
gen countya=string(countyid)
replace countya="0"+countya if countyid<1000000
replace countya=substr(countya,4,4)
sort statea countya
merge m:1 statea countya using "src/county_match3_old"
tab _merge
drop if _merge==2
drop _merge
replace countyid_new=3600060 if cnty_name=="Kings" & st_ab=="NY"
replace countyid_new=3600060 if cnty_name=="Queens" & st_ab=="NY"
replace countyid_new=3600060 if cnty_name=="Richmond" & st_ab=="NY"

drop if countyid_new==.

*To make sure that industries are comparable across time, we include only those with less than 3 observations
*drop if Numberofestablishments<3
save dta/industries_final,   replace

erase dta/county-city-new2.dta




**********************************
* 3. Industry_ipums
**********************************
clear
import excel using "src/Listofindustries-withagg.xls", sheet(1860) firstrow
gen year=1860
save dta/industrycodes,   replace
clear

foreach x in 1870 1880 1890 1900 1910 1920 1930 1940{
import excel using "src/Listofindustries-withagg.xls", sheet(`x') firstrow
gen year=`x'
append using dta/industrycodes
replace Industry=trim(Industry)
keep Industry Industry_official industry_code_* year
save dta/industrycodes,   replace
clear
}


use dta/industrycodes, clear
rowsort(industry_code_*), generate(ind_code_1-ind_code_31)
drop industry_code_*
sort Industry year
save dta/industrycodes,   replace


use dta/industries_final, clear  
drop if Industry=="Total"
drop if Industry=="All industries"
sort Industry year
merge Industry year using dta/industrycodes
tab _merge
drop if _merge==2
drop _merge
*var for no manuf.
drop if ind_code_1==100|ind_code_1==200|ind_code_1==300|ind_code_1==400|ind_code_1==500|ind_code_1==600|ind_code_1==700|ind_code_1==800|ind_code_1==900|ind_code_1==1000|ind_code_1==1100|ind_code_1==1200|ind_code_1==1300|ind_code_1==1400|ind_code_1==1500|ind_code_1==1600|ind_code_1==1700|ind_code_1==1800|ind_code_1==1900|ind_code_1==2000
drop if ind_code_1==9999
gen industry_unified=.
save dta/industries_final2,   replace
clear

local i=1
while `i'<150{
use dta/industries_final2, clear
egen minx=min(ind_code_1) if industry_unified==.
egen min=mean(minx)
sum min
drop minx
replace	industry_unified=`i' if (ind_code_1==min|ind_code_2==min|ind_code_3==min|ind_code_4==min|ind_code_5==min|ind_code_6==min|ind_code_7==min|ind_code_8==min|ind_code_9==min|ind_code_10==min|ind_code_11==min|ind_code_12==min|ind_code_13==min|ind_code_14==min|ind_code_15==min|ind_code_16==min|ind_code_17==min|ind_code_18==min|ind_code_19==min|ind_code_20==min|ind_code_21==min|ind_code_22==min|ind_code_23==min|ind_code_24==min|ind_code_25==min|ind_code_26==min|ind_code_27==min|ind_code_28==min|ind_code_29==min|ind_code_30==min|ind_code_31==min) & industry_unified==.
rename min fmin
local x=2
while `x'<32{
egen min=min(ind_code_`x') if industry_unified==`i'
egen min1=mean(min)
sum min1
drop min
if min1~=.{
replace	industry_unified=`i' if (ind_code_1==min1|ind_code_2==min1|ind_code_3==min1|ind_code_4==min1|ind_code_5==min1|ind_code_6==min1|ind_code_7==min1|ind_code_8==min1|ind_code_9==min1|ind_code_10==min1|ind_code_11==min1|ind_code_12==min1|ind_code_13==min1|ind_code_14==min1|ind_code_15==min1|ind_code_16==min1|ind_code_17==min1|ind_code_18==min1|ind_code_19==min1|ind_code_20==min1|ind_code_21==min1|ind_code_22==min1|ind_code_23==min1|ind_code_24==min1|ind_code_25==min1|ind_code_26==min1|ind_code_27==min1|ind_code_28==min1|ind_code_29==min1|ind_code_30==min1|ind_code_31==min1) & industry_unified==.
local j=2
while `j'<20{
local k=`j'-1
egen min=min(ind_code_`x') if industry_unified==`i' & ind_code_`x'>min`k'
egen min`j'=mean(min)
drop min
if min`j'~=.{
sum min`j'
replace	industry_unified=`i' if (ind_code_1==min`j'|ind_code_2==min`j'|ind_code_3==min`j'|ind_code_4==min`j'|ind_code_5==min`j'|ind_code_6==min`j'|ind_code_7==min`j'|ind_code_8==min`j'|ind_code_9==min`j'|ind_code_10==min`j'|ind_code_11==min`j'|ind_code_12==min`j'|ind_code_13==min`j'|ind_code_14==min`j'|ind_code_15==min`j'|ind_code_16==min`j'|ind_code_17==min`j'|ind_code_18==min`j'|ind_code_19==min`j'|ind_code_20==min`j'|ind_code_21==min`j'|ind_code_22==min`j'|ind_code_23==min`j'|ind_code_24==min`j'|ind_code_25==min`j'|ind_code_26==min`j'|ind_code_27==min`j'|ind_code_28==min`j'|ind_code_29==min`j'|ind_code_30==min`j'|ind_code_31==min`j') & industry_unified==.
local j=`j'+1
}
else{
local j=20
}
}
drop min*
local x=`x'+1
}
else{
drop min1
local x=32
}
}
egen minx=min(ind_code_1) if industry_unified==`i' & ind_code_1>fmin
egen min=mean(minx)
sum min
drop minx
if min~=.{
replace	industry_unified=`i' if (ind_code_1==min|ind_code_2==min|ind_code_3==min|ind_code_4==min|ind_code_5==min|ind_code_6==min|ind_code_7==min|ind_code_8==min|ind_code_9==min|ind_code_10==min|ind_code_11==min|ind_code_12==min|ind_code_13==min|ind_code_14==min|ind_code_15==min|ind_code_16==min|ind_code_17==min|ind_code_18==min|ind_code_19==min|ind_code_20==min|ind_code_21==min|ind_code_22==min|ind_code_23==min|ind_code_24==min|ind_code_25==min|ind_code_26==min|ind_code_27==min|ind_code_28==min|ind_code_29==min|ind_code_30==min|ind_code_31==min) & industry_unified==.
rename min fmin2
local x=2
while `x'<32{
egen min=min(ind_code_`x') if industry_unified==`i' & ind_code_`x'>fmin
egen min1=mean(min)
sum min1
drop min
if min1~=.{
replace	industry_unified=`i' if (ind_code_1==min1|ind_code_2==min1|ind_code_3==min1|ind_code_4==min1|ind_code_5==min1|ind_code_6==min1|ind_code_7==min1|ind_code_8==min1|ind_code_9==min1|ind_code_10==min1|ind_code_11==min1|ind_code_12==min1|ind_code_13==min1|ind_code_14==min1|ind_code_15==min1|ind_code_16==min1|ind_code_17==min1|ind_code_18==min1|ind_code_19==min1|ind_code_20==min1|ind_code_21==min1|ind_code_22==min1|ind_code_23==min1|ind_code_24==min1|ind_code_25==min1|ind_code_26==min1|ind_code_27==min1|ind_code_28==min1|ind_code_29==min1|ind_code_30==min1|ind_code_31==min1) & industry_unified==.
local j=2
while `j'<20{
local k=`j'-1
egen min=min(ind_code_`x') if industry_unified==`i' & ind_code_`x'>min`k'
egen min`j'=mean(min)
drop min
if min`j'~=.{
sum min`j'
replace	industry_unified=`i' if (ind_code_1==min`j'|ind_code_2==min`j'|ind_code_3==min`j'|ind_code_4==min`j'|ind_code_5==min`j'|ind_code_6==min`j'|ind_code_7==min`j'|ind_code_8==min`j'|ind_code_9==min`j'|ind_code_10==min`j'|ind_code_11==min`j'|ind_code_12==min`j'|ind_code_13==min`j'|ind_code_14==min`j'|ind_code_15==min`j'|ind_code_16==min`j'|ind_code_17==min`j'|ind_code_18==min`j'|ind_code_19==min`j'|ind_code_20==min`j'|ind_code_21==min`j'|ind_code_22==min`j'|ind_code_23==min`j'|ind_code_24==min`j'|ind_code_25==min`j'|ind_code_26==min`j'|ind_code_27==min`j'|ind_code_28==min`j'|ind_code_29==min`j'|ind_code_30==min`j'|ind_code_31==min`j') & industry_unified==.
local j=`j'+1
}
else{
local j=20
}
}
drop min*
local x=`x'+1
}
else{
drop min1
local x=32
}
}
local m=2
while `m'<20{
egen minx=min(ind_code_1) if industry_unified==`i' & ind_code_1>fmin`m'
egen min=mean(minx)
sum min
drop minx
if min~=.{
replace	industry_unified=`i' if (ind_code_1==min|ind_code_2==min|ind_code_3==min|ind_code_4==min|ind_code_5==min|ind_code_6==min|ind_code_7==min|ind_code_8==min|ind_code_9==min|ind_code_10==min|ind_code_11==min|ind_code_12==min|ind_code_13==min|ind_code_14==min|ind_code_15==min|ind_code_16==min|ind_code_17==min|ind_code_18==min|ind_code_19==min|ind_code_20==min|ind_code_21==min|ind_code_22==min|ind_code_23==min|ind_code_24==min|ind_code_25==min|ind_code_26==min|ind_code_27==min|ind_code_28==min|ind_code_29==min|ind_code_30==min|ind_code_31==min) & industry_unified==.
local n=`m'+1
rename min fmin`n'
local x=2
while `x'<32{
egen min=min(ind_code_`x') if industry_unified==`i' & ind_code_`x'>fmin`m'
egen min1=mean(min)
sum min1
drop min
if min1~=.{
replace	industry_unified=`i' if (ind_code_1==min1|ind_code_2==min1|ind_code_3==min1|ind_code_4==min1|ind_code_5==min1|ind_code_6==min1|ind_code_7==min1|ind_code_8==min1|ind_code_9==min1|ind_code_10==min1|ind_code_11==min1|ind_code_12==min1|ind_code_13==min1|ind_code_14==min1|ind_code_15==min1|ind_code_16==min1|ind_code_17==min1|ind_code_18==min1|ind_code_19==min1|ind_code_20==min1|ind_code_21==min1|ind_code_22==min1|ind_code_23==min1|ind_code_24==min1|ind_code_25==min1|ind_code_26==min1|ind_code_27==min1|ind_code_28==min1|ind_code_29==min1|ind_code_30==min1|ind_code_31==min1) & industry_unified==.
local j=2
while `j'<20{
local k=`j'-1
egen min=min(ind_code_`x') if industry_unified==`i' & ind_code_`x'>min`k'
egen min`j'=mean(min)
drop min
if min`j'~=.{
sum min`j'
replace	industry_unified=`i' if (ind_code_1==min`j'|ind_code_2==min`j'|ind_code_3==min`j'|ind_code_4==min`j'|ind_code_5==min`j'|ind_code_6==min`j'|ind_code_7==min`j'|ind_code_8==min`j'|ind_code_9==min`j'|ind_code_10==min`j'|ind_code_11==min`j'|ind_code_12==min`j'|ind_code_13==min`j'|ind_code_14==min`j'|ind_code_15==min`j'|ind_code_16==min`j'|ind_code_17==min`j'|ind_code_18==min`j'|ind_code_19==min`j'|ind_code_20==min`j'|ind_code_21==min`j'|ind_code_22==min`j'|ind_code_23==min`j'|ind_code_24==min`j'|ind_code_25==min`j'|ind_code_26==min`j'|ind_code_27==min`j'|ind_code_28==min`j'|ind_code_29==min`j'|ind_code_30==min`j'|ind_code_31==min`j') & industry_unified==.
local j=`j'+1
}
else{
local j=20
}
}
drop min*
local x=`x'+1
}
else{
drop min1
local x=32
}
}
local m=`m'+1
}
else{
drop min
local m=20
}
}
}
else{
drop min
}



drop fmin*
tab industry_unified
replace Industry_official=trim(Industry_official)
save dta/industries_final2,   replace
local i=`i'+1
}
clear

import excel using "src/SM_Checked_TableVIIIB-1870.xls", sheet("1860") firstrow
egen Industry_official=concat(Industry1 Industry2 Industry3), punct(" ")
replace Industry_official=trim(Industry_official)
rename Establishments Numberofestablishments
rename EmpAll wageearners_av_total
rename EmpMales wageearners_av_males
rename EmpFemales wageearners_av_females
gen expenses_wages=real(Wages)
rename Materials Valueofmaterials
rename Products Valueofproducts
gen Valueaddedbymanufacture=Valueofproducts-Valueofmaterials
keep Industry_official Numberof wageearners_* expenses_* Value* Capital
gen year=1860
save dta/industry_aggregates,   replace
clear

import excel using "src/SM_Checked_TableVIIIB-1870.xls", sheet(1870) firstrow
egen Industry_official=concat(Industry1 Industry2 Industry3), punct(" ")
replace Industry_official=trim(Industry_official)
gen year=1870
rename Establishments Numberofestablishments
rename EmpAll wageearners_av_total
rename EmpMales wageearners_av_males
rename EmpFemales wageearners_av_females
rename Wages expenses_wages
rename Materials Valueofmaterials
rename Products Valueofproducts
rename EmpYouth wageearners_av_under16
gen Valueaddedbymanufacture=Valueofproducts-Valueofmaterials
keep Industry_official Numberof wageearners_* expenses_* Value* year Capital
append using dta/industry_aggregates
save dta/industry_aggregates,   replace
clear

import excel using "src/SM_Checked_Table1-1900-rev.xls", sheet(1880) firstrow
gen year=1880
rename Industry Industry_official
rename Establishments Numberofestablishments
rename OfficialsNumber officers
rename OfficialsSalaries expenses_officialsandclerks
rename WageWrkrsNumber wageearners_av_total
rename WageWrkrsMen wageearners_av_males
rename WageWrkrsWomen wageearners_av_females
rename WageWrkrsWages expenses_wages
rename Materials Valueofmaterials
rename Products Valueofproducts
rename WageWrkrsChildren wageearners_av_under16
gen Valueaddedbymanufacture=Valueofproducts-Valueofmaterials
keep Industry_official Numberof wageearners_* expenses_* Value* officers year Capital
append using dta/industry_aggregates
save dta/industry_aggregates,   replace
clear

import excel using "src/SM_Checked_Table1-1900-rev.xls", sheet(1890) firstrow
gen year=1890
rename Industry Industry_official
rename Establishments Numberofestablishments
rename OfficialsNumber officers
rename OfficialsSalaries expenses_officialsandclerks
rename WageWrkrsNumber wageearners_av_total
rename WageWrkrsMen wageearners_av_males
rename WageWrkrsWomen wageearners_av_females
rename WageWrkrsWages expenses_wages
rename Materials Valueofmaterials
rename Products Valueofproducts
rename WageWrkrsChildren wageearners_av_under16
gen Valueaddedbymanufacture=Valueofproducts-Valueofmaterials
keep Industry_official Numberof wageearners_* expenses_* Value* officers year Capital
append using dta/industry_aggregates
save dta/industry_aggregates,   replace
clear

import excel using "src/SM_Checked_Table1-1900-rev.xls", sheet(1900) firstrow
gen year=1900
rename Industry Industry_official
rename Establishments Numberofestablishments
rename OfficialsNumber officers
rename OfficialsSalaries expenses_officialsandclerks
rename WageWrkrsNumber wageearners_av_total
rename WageWrkrsMen wageearners_av_males
rename WageWrkrsWomen wageearners_av_females
rename WageWrkrsWages expenses_wages
rename Materials Valueofmaterials
rename Products Valueofproducts
rename WageWrkrsChildren wageearners_av_under16
gen Valueaddedbymanufacture=Valueofproducts-Valueofmaterials
keep Industry_official Numberof wageearners_* expenses_* Value* officers year Capital
append using dta/industry_aggregates
save dta/industry_aggregates,   replace
clear

import excel using "src/SM_Checked_Table1-1910.xls", sheet(1909) firstrow
gen year=1910
rename Industry Industry_official
rename Establishments Numberofestablishments
rename Proprieters proprietors
rename Salaried officers
rename Salaries expenses_officialsandclerks
rename WageWrkrs wageearners_av_total
rename Wages expenses_wages
rename Costs expenses_miscellaneous
rename Products Valueofproducts
rename ValueAdded Valueaddedbymanufacture
gen Valueofmaterials=Valueofproducts-Valueaddedbymanufacture
keep Industry_official Numberof wageearners_* expenses_* Value* propri officers year Capital
append using dta/industry_aggregates
save dta/industry_aggregates,   replace
clear

import excel using "src/SM_Checked_Table52-1920.xls", sheet("Checked Data ") firstrow
gen year=1920
rename Industry1 Industry_official
rename Establishments Numberofestablishments
rename Proprieters proprietors
rename Officials officers
rename WagesOfficials expenses_officialsandclerks
rename MaleClerks clerks_males
rename FemaleClkers clerks_females
rename WageWrkrs wageearners_av_total
rename WageWrkrsMale wageearners_av_males
rename WageWrkrsFemale wageearners_av_females
rename WageWrkrsYouth wageearners_av_under16
rename WagesWageWrkrs expenses_wages
rename Contract expenses_contract
rename Rent expenses_rent
rename Taxes expenses_taxes
rename MaterialsTot Valueofmaterials
rename Materials expenses_materials_main
rename Fuel expenses_fuelandpower
rename Products Valueofproducts
rename ValueAdded Valueaddedbymanufacture
rename Horsepwoer Horsepower
keep Industry_official Numberof wageearners_* expenses_* Value* propri officers clerks_* Horsepower year Capital
append using dta/industry_aggregates
save dta/industry_aggregates,   replace
clear

import excel "src/SM_Checked_Table1-1930.xls", sheet("Checked") firstrow
gen year=1930
rename Industry1 Industry_official
rename Establishments Numberofestablishments
rename Emp personsinindustry_total
rename EmpMale personsinindustry_males
gen personsinindustry_females=real(EmpFemale)
gen proprietors=real(Proprieters)
rename Officers officers
rename WagesOfficers expenses_officialsandclerks
rename OfficersMale clerks_males
gen clerks_females=real(OfficersFemale)
rename WageWrkrs wageearners_av_total
rename WageWrkrsMale wageearners_av_males
gen wageearners_av_females=real(WageWrkrsFemale)
rename Horsepower horsepower
gen Horsepower=real(horsepower)
rename WagesWageWrkrs expenses_wages
rename MaterialsTotal Valueofmaterials
rename Materials expenses_materials_main
rename Fuel expenses_fuelandpower
rename Products Valueofproducts
rename ValueAdded Valueaddedbymanufacture
keep Industry_official Numberof wageearners_* expenses_* Value* propri officers clerks_* persons* Horsepower year
append using dta/industry_aggregates
save dta/industry_aggregates,   replace
clear

import excel using "src/SM_Checked_Table5-1940.xls", sheet("Sheet1") firstrow
gen year=1940
rename Industry Industry_official
rename Establishments Numberofestablishments
rename Emp personsinindustry_total
rename Proprieters proprietors
rename Officers officers
rename WagesOfficers expenses_officialsandclerks
rename WageWrkrs wageearners_av_total
rename WagesWagewrkrs expenses_wages
rename MaterialsTotal Valueofmaterials
rename Materials expenses_materials_main
rename Fuel expenses_fuelandpower
rename Electricity expenses_electricity
rename Contract expenses_contract
rename Products Valueofproducts
rename ValueAdded Valueaddedbymanufacture
keep Industry_official Numberof wageearners_* expenses_* Value* propri officers persons* year
append using dta/industry_aggregates

replace Industry_official=trim(Industry_official)
drop if Industry_official==""|Industry_official=="All industries"|Industry_official=="Differences"|Industry=="All industries, total"|Industry_official=="Difference"
foreach var of varlist Numberofestablishments-Valueaddedbymanufacture personsinindustry_males-expenses_miscellaneous{
rename `var' `var'_agg
}

save dta/industry_aggregates,   replace
clear

import excel using "src/Match IPUMS industry.xlsx", sheet(Sheet1) firstrow
reshape long industry_code, i(ind1950 Industry_name_IPUMS) j(number)
drop if industry_code==.
drop number
rename industry_code ind_code
save dta/ipums_industry,   replace

use dta/industries_final2
forvalues x=1/31{
rename ind_code_`x' ind_code
merge m:1 ind_code using dta/ipums_industry
drop if _merge==2
rename ind1950 ind1950_`x'
rename ind_code ind_code_`x'
drop _merge
save dta/industries_final2,   replace
}

use dta/industries_final2, clear
replace ind1950_1=317 if Industry_official=="Artificial stone" & year==1910
replace ind1950_1=317 if Industry_official=="Artificial stone products" & year==1920
replace ind1950_1=469 if Industry_official=="Axle grease" & year==1890
replace ind1950_1=469 if Industry_official=="Axle grease" & year==1900
replace ind1950_1=449 if Industry_official=="Bagging" & year==1860
replace ind1950_1=449 if Industry_official=="Bagging, flax, hemp, and jute" & year==1870
replace ind1950_1=449 if Industry_official=="Bags" & year==1860
replace ind1950_1=449 if Industry_official=="Bags, other than paper" & year==1880
replace ind1950_1=449 if Industry_official=="Bags, other than paper" & year==1890
replace ind1950_1=449 if Industry_official=="Bags, other than paper" & year==1900
replace ind1950_1=449 if Industry_official=="Bags, other than paper" & year==1910
replace ind1950_1=449 if Industry_official=="Bags, other than paper, not including bags made in textile mills" & year==1920
replace ind1950_1=449 if Industry_official=="Bags, other than paper, not made in textile mills" & year==1930
replace ind1950_1=379 if Industry_official=="Bicycles and tricycles" & year==1900
replace ind1950_1=379 if Industry_official=="Bicycles, motorcycles, and parts" & year==1910
replace ind1950_1=437 if Industry_official=="Bleaching and dyeing" & year==1870
replace ind1950_1=488 if Industry_official=="Boot and shoe findings" & year==1890
replace ind1950_1=488 if Industry_official=="Boot and shoe findings" & year==1900
replace ind1950_1=488 if Industry_official=="Boots and shoes, custom work and repairing" & year==1890
replace ind1950_1=488 if Industry_official=="Boots and shoes, custom work and repairing" & year==1900
replace ind1950_1=488 if Industry_official=="Boots and shoes, factory product" & year==1890
replace ind1950_1=488 if Industry_official=="Boots and shoes, factory product" & year==1900
replace ind1950_1=488 if Industry_official=="Boots and shoes, not including rubber boots and shoes" & year==1920
replace ind1950_1=478 if Industry_official=="Boots and shoes, rubber" & year==1910
replace ind1950_1=457 if Industry_official=="Boxes packing" & year==1860
replace ind1950_1=457 if Industry_official=="Boxes, paper, not elsewhere classifled" & year==1930
replace ind1950_1=318 if Industry_official=="Brick" & year==1860
replace ind1950_1=318 if Industry_official=="Brick" & year==1870
replace ind1950_1=318 if Industry_official=="Brick and tile" & year==1880
replace ind1950_1=318 if Industry_official=="Brick and tile" & year==1890
replace ind1950_1=318 if Industry_official=="Brick and tile" & year==1900
replace ind1950_1=318 if Industry_official=="Brick and tile" & year==1910
replace ind1950_1=318 if Industry_official=="Brick and tile, terra-cotta, and fire-clay products, building brick" & year==1920
replace ind1950_1=318 if Industry_official=="Brick and tile, terra-cotta, and fire-clay products, except building bricks and terra-cotta products" & year==1920
replace ind1950_1=318 if Industry_official=="Brick and tile, terra-cotta, and fire-clay products, fire brick" & year==1920
replace ind1950_1=318 if Industry_official=="Brick and tile, terra-cotta, and fire-clay products, stove lining and terra-cotta products" & year==1920
replace ind1950_1=318 if Industry_official=="Brick and tile, terra-cotta, and fire-clay products, terra-cotta products" & year==1920
replace ind1950_1=318 if Industry_official=="Brick and tile, terra-cotta, and fireclay products" & year==1920
replace ind1950_1=379 if Industry_official=="Carriage and wagon materials" & year==1890
replace ind1950_1=379 if Industry_official=="Carriage and wagon materials" & year==1900
replace ind1950_1=379 if Industry_official=="Carriages and wagons" & year==1890
replace ind1950_1=379 if Industry_official=="Carriages and wagons" & year==1900
replace ind1950_1=477 if Industry_official=="Charcoal and coke" & year==1870
replace ind1950_1=469 if Industry_official=="Chemicals" & year==1890
replace ind1950_1=318 if Industry_official=="Clay products (other than pottery) and nonclay refractories" & year==1930
replace ind1950_1=417 if Industry_official=="Confectionery and ice cream" & year==1920
replace ind1950_1=347 if Industry_official=="Copper, tin, and sheet-iron products" & year==1910
replace ind1950_1=446 if Industry_official=="Cotton goods, including cotton small wares" & year==1910
replace ind1950_1=346 if Industry_official=="Cutlery and tools, not elsewhere specified" & year==1910
replace ind1950_1=468 if Industry_official=="Dye-woods and dye-stuffs" & year==1860
replace ind1950_1=437 if Industry_official=="Dyeing and bleaching" & year==1860
replace ind1950_1=437 if Industry_official=="Dyeing and cleaning" & year==1880
replace ind1950_1=437 if Industry_official=="Dyeing and cleaning" & year==1890
replace ind1950_1=437 if Industry_official=="Dyeing and cleaning" & year==1900
replace ind1950_1=437 if Industry_official=="Dyeing and finishing textiles" & year==1880
replace ind1950_1=437 if Industry_official=="Dyeing and finishing textiles" & year==1890
replace ind1950_1=437 if Industry_official=="Dyeing and finishing textiles" & year==1900
replace ind1950_1=437 if Industry_official=="Dyeing and finishing textiles" & year==1910
replace ind1950_1=437 if Industry_official=="Dyeing and finishing textiles" & year==1930
replace ind1950_1=437 if Industry_official=="Dyeing and finishing textiles, exclusive of that done in textile mills" & year==1920
replace ind1950_1=468 if Industry_official=="Dyestuffs and extracts" & year==1890
replace ind1950_1=468 if Industry_official=="Dyestuffs and extracts" & year==1900
replace ind1950_1=367 if Industry_official=="Electrical machinery, apparatus, and supplies" & year==1930
replace ind1950_1=459 if Industry_official=="Engraving" & year==1870
replace ind1950_1=459 if Industry_official=="Engraving and stencil-cutting" & year==1870
replace ind1950_1=419 if Industry_official=="Food preparations" & year==1870
replace ind1950_1=419 if Industry_official=="Food preparations, not elsewhere classified, all other food preparations" & year==1920
replace ind1950_1=419 if Industry_official=="Food preparations, not elsewhere classified, all other food preparations except macaroni, vermicelli and noodles" & year==1920
replace ind1950_1=419 if Industry_official=="Food preparations, not elsewhere classified, breadstuff preparations , macaroni, vermicelli and noodles" & year==1920
replace ind1950_1=419 if Industry_official=="Food preparations, not elsewhere classified, breadstuff preparations, cereals, and breakfast foods" & year==1920
replace ind1950_1=419 if Industry_official=="Food preparations, not elsewhere classified, breadstuff preparations, cereals, and breakfast foods.      Macaroni, vermicelli and noodles" & year==1920
replace ind1950_1=419 if Industry_official=="Food preparations, not elsewhere classified, except  breadstuff preparations , macaroni, vermicelli and noodles, meat products, not elsewhere specified, peanut butter and sweetening sirups" & year==1920
replace ind1950_1=419 if Industry_official=="Food preparations, not elsewhere classified, except breadstuff preparations, cereals, and breakfast foods" & year==1920
replace ind1950_1=419 if Industry_official=="Food preparations, not elsewhere classified, except breadstuff preparations, cereals, and breakfast foods, for animals and fowls" & year==1920
replace ind1950_1=419 if Industry_official=="Food preparations, not elsewhere classified, except breadstuff preparations, cereals, and breakfast foods, for human consumption" & year==1920
replace ind1950_1=419 if Industry_official=="Food preparations, not elsewhere classified, except breadstuff preparations, cereals, and breakfast foods, macaroni, vermicelli and noodles, peanut butter and sweetening sirups" & year==1920
replace ind1950_1=419 if Industry_official=="Food preparations, not elsewhere classified, except breadstuff preparations, cereals, and breakfast foods, macaroni, vermicelli and noodles, peanut butter and sweetening sirups-for animals and fowls" & year==1920
replace ind1950_1=419 if Industry_official=="Food preparations, not elsewhere classified, except breadstuff preparations, cereals, and breakfast foods, macaroni, vermicelli and noodles, peanut butter and sweetening sirups-for human consumption" & year==1920
replace ind1950_1=419 if Industry_official=="Food preparations, not elsewhere classified, except breadstuff preparations, cereals, and breakfast foods-for animals and fowls" & year==1920
replace ind1950_1=419 if Industry_official=="Food preparations, not elsewhere classified, except breadstuff preparations, cereals, and breakfast foods-for human consumption" & year==1920
replace ind1950_1=419 if Industry_official=="Food preparations, not elsewhere classified, except macaroni, vermicelli and noodles" & year==1920
replace ind1950_1=419 if Industry_official=="Food preparations, not elsewhere classified, except macaroni, vermicelli and noodles and peanut butter and sweetening sirups-for animals and fowls" & year==1920
replace ind1950_1=419 if Industry_official=="Food preparations, not elsewhere classified, except macaroni, vermicelli and noodles and peanut butter and sweetening sirups-for human consumption" & year==1920
replace ind1950_1=419 if Industry_official=="Food preparations, not elsewhere classified, except macaroni, vermicelli and noodles-for human consumption" & year==1920
replace ind1950_1=419 if Industry_official=="Food preparations, not elsewhere classified, except macaroni, vermicelli and noodles-for human consumption-for animals and fowls" & year==1920
replace ind1950_1=419 if Industry_official=="Food preparations, not elsewhere classified, except peanut butter and syrup" & year==1920
replace ind1950_1=419 if Industry_official=="Food preparations, not elsewhere classified, macaroni, vermicelli and noodles" & year==1920
replace ind1950_1=419 if Industry_official=="Food preparations, not elsewhere classified, meat products, not elsewhere specified" & year==1920
replace ind1950_1=419 if Industry_official=="Food preparations, not elsewhere classified, peanut butter and sweetening sirups" & year==1920
replace ind1950_1=419 if Industry_official=="Food preparations, not elsewhere specified" & year==1920
replace ind1950_1=358 if Industry_official=="Foundry and machine-shop products, not elsewhere classified" & year==1930
replace ind1950_1=358 if Industry_official=="Foundry and machineshop products" & year==1910
replace ind1950_1=309 if Industry_official=="Furniture and refrigerators" & year==1910
replace ind1950_1=448 if Industry_official=="Gloves and mittens" & year==1870
replace ind1950_1=448 if Industry_official=="Gloves and mittens" & year==1890
replace ind1950_1=448 if Industry_official=="Gloves and mittens" & year==1900
replace ind1950_1=449 if Industry_official=="House-furnishing goods, not elsewhere specified" & year==1880
replace ind1950_1=449 if Industry_official=="House-furnishing goods, not elsewhere specified" & year==1910
replace ind1950_1=336 if Industry_official=="Iron and steel: Steel works and rolling mills" & year==1930
replace ind1950_1=336 if Industry_official=="Iron forged, rolled, and wrought" & year==1860
replace ind1950_1=347 if Industry_official=="Jewelry" & year==1860
replace ind1950_1=347 if Industry_official=="Jewelry" & year==1930
replace ind1950_1=489 if Industry_official=="Leather goods" & year==1880
replace ind1950_1=489 if Industry_official=="Leather goods" & year==1890
replace ind1950_1=489 if Industry_official=="Leather goods" & year==1900
replace ind1950_1=489 if Industry_official=="Leather goods, not elsewhere classified" & year==1930
replace ind1950_1=489 if Industry_official=="Leather goods, not elsewhere specified" & year==1920
replace ind1950_1=459 if Industry_official=="Lithographing and engraving" & year==1890
replace ind1950_1=307 if Industry_official=="Lumber and timber products" & year==1890
replace ind1950_1=307 if Industry_official=="Lumber and timber products" & year==1900
replace ind1950_1=307 if Industry_official=="Lumber and timber products" & year==1910
replace ind1950_1=307 if Industry_official=="Lumber and timber products" & year==1920
replace ind1950_1=307 if Industry_official=="Lumber and timber products, not elsewhere classified" & year==1930
replace ind1950_1=307 if Industry_official=="Lumber, planing mill products, including sash, doors, and blinds" & year==1890
replace ind1950_1=318 if Industry_official=="Masonry, brick and stone" & year==1870
replace ind1950_1=318 if Industry_official=="Masonry, brick and stone" & year==1880
replace ind1950_1=318 if Industry_official=="Masonry, brick and stone" & year==1890
replace ind1950_1=318 if Industry_official=="Masonry, brick and stone" & year==1900
replace ind1950_1=448 if Industry_official=="Millinery and dressmaking" & year==1860
replace ind1950_1=448 if Industry_official=="Millinery goods" & year==1860
replace ind1950_1=338 if Industry_official=="Nonferrous-metal alloys and products, not including aluminum products" & year==1930
replace ind1950_1=456 if Industry_official=="Paper" & year==1860
replace ind1950_1=456 if Industry_official=="Paper" & year==1890
replace ind1950_1=456 if Industry_official=="Paper (not specified)" & year==1870
replace ind1950_1=456 if Industry_official=="Paper and wood pulp" & year==1880
replace ind1950_1=456 if Industry_official=="Paper and wood pulp" & year==1900
replace ind1950_1=456 if Industry_official=="Paper and wood pulp" & year==1910
replace ind1950_1=456 if Industry_official=="Paper and wood pulp" & year==1920
replace ind1950_1=458 if Industry_official=="Paper goods, not elsewhere classified" & year==1930
replace ind1950_1=458 if Industry_official=="Paper goods, not elsewhere specified" & year==1890
replace ind1950_1=458 if Industry_official=="Paper goods, not elsewhere specified" & year==1900
replace ind1950_1=458 if Industry_official=="Paper goods, not elsewhere specified" & year==1910
replace ind1950_1=458 if Industry_official=="Paper goods, not elsewhere specified" & year==1920
replace ind1950_1=319 if Industry_official=="Pottery" & year==1920
replace ind1950_1=319 if Industry_official=="Pottery, terra cotta, and fire-clay products" & year==1890
replace ind1950_1=319 if Industry_official=="Pottery, terra cotta, and fire-clay products" & year==1900
replace ind1950_1=319 if Industry_official=="Pottery, terra-cotta and fire-clay products" & year==1910
replace ind1950_1=459 if Industry_official=="Printing materials" & year==1880
replace ind1950_1=459 if Industry_official=="Printing materials" & year==1920
replace ind1950_1=459 if Industry_official=="Printing materials, not including type or ink" & year==1930
replace ind1950_1=406 if Industry_official=="Provisions" & year==1860
replace ind1950_1=478 if Industry_official=="Rubber and elastic goods" & year==1890
replace ind1950_1=478 if Industry_official=="Rubber and elastic goods" & year==1900
replace ind1950_1=478 if Industry_official=="Rubber goods, not elsewhere specified" & year==1910
replace ind1950_1=439 if Industry_official=="Silk and fancy goods, fringes, and trimmings" & year==1860
replace ind1950_1=338 if Industry_official=="Silversmithing" & year==1880
replace ind1950_1=317 if Industry_official=="Stucco and stucco work" & year==1860
replace ind1950_1=338 if Industry_official=="Tinsmithing, coppersmithing, and sheet-iron working" & year==1890
replace ind1950_1=338 if Industry_official=="Tinsmithing, coppersmithing, and sheet-iron working" & year==1900
replace ind1950_1=357 if Industry_official=="Typewriters and supplies" & year==1890
replace ind1950_1=357 if Industry_official=="Typewriters and supplies" & year==1900
replace ind1950_1=357 if Industry_official=="Typewriters and supplies" & year==1910
replace ind1950_1=357 if Industry_official=="Typewriters and supplies" & year==1920
replace ind1950_1=448 if Industry_official=="Woolen, worsted, felt goods, and wool hats" & year==1910


drop ind1950_2-ind1950_31
rename ind1950_1 ind1950
save dta/industries_final2,  replace


use dta/industries_final2, clear
rename countyid_new area
merge m:1 year area ind1950 using dta/literacy_byindustry_ipums
drop if _merge==2
drop _merge

merge m:1 Industry_official year using dta/industry_aggregates
drop if _merge==2
drop if _merge==1 & Industry_official~=""
drop _merge

gen double panel_var=area*1000+industry_unified

fillin panel_var year

foreach var of varlist Numberofestablishments wageearners_av_total Capital Valueofproducts{
replace `var'=0 if _fillin==1
}

replace area=floor(panel_var/1000) if _fillin==1
replace industry_unified=panel_var-(1000*area) if _fillin==1
replace statea=string(floor(area/10000)) if _fillin==1
replace statea="0"+string(floor(area/10000)) if floor(area/10000)<100 & _fillin==1
rename _fillin wasnotanindustry

foreach var of varlist *_agg{
bysort industry_unified year: egen max=max(`var')
replace `var'=max
drop max
}


bysort area year: egen total_y_city=sum(Valueofproducts)
bysort area year: egen total_l_city=sum(wageearners_av_total)
bysort area year: egen total_k_city=sum(Capital)
bysort area year: egen total_n_city=sum(Numberofestablishments)

drop if industry_unified==148

gen share_y=Valueofproducts/total_y_city
gen share_l=wageearners_av_total/total_l_city
gen share_k=Capital/total_k_city
gen share_n=Numberofestablishments/total_n_city

gen kl_1860=(Capital_agg/wageearners_av_total_agg) if year==1860 & Capital_agg/wageearners_av_total_agg~=.
bysort industry_unified: egen kl_mean=mean(Capital_agg/wageearners_av_total_agg)
gen hl_1890=(officers_agg/wageearners_av_total_agg) if year==1890 & officers_agg/wageearners_av_total_agg~=.
bysort industry_unified: egen hl_mean=mean(officers_agg/wageearners_av_total_agg)
bysort industry_unified: egen kl_industry=mean(kl_1860)
bysort industry_unified: egen hl_industry=mean(hl_1890)
gen high_kl=kl_industry>600 if kl_industry~=.
gen high_hl=hl_industry>0.11 if hl_industry~=.
gen high_kl_mean=kl_mean>600 if kl_mean~=.
gen high_hl_mean=hl_mean>0.15 if hl_mean~=.
drop kl_1860 hl_1890
rename kl_industry kl_1860
rename hl_industry hl_1890
rename kl_mean kl_mean_agg
rename hl_mean hl_mean_agg
save dta/industries_final3,   replace

drop if Numberofestablishments==0

save dta/industries_final3_no0s,   replace

use dta/industries_final2, clear
rename countyid_new area
merge m:1 year area ind1950 using dta/literacy_byindustry_ipums
drop if _merge==2
drop _merge
foreach x of varlist lit_share*{
replace `x'=`x'*Numberofestablishments
}

collapse (sum)Numberofestablishments-Valueaddedbymanufacture (sum)officers-wageearners_av_under16 (sum)RentedK-Electricmotors (sum)lit_share*, by(year area statea state Industry_official industry_unified)

merge m:1 Industry_official year using dta/industry_aggregates
drop if _merge==2
drop if _merge==1 & Industry_official~=""
drop _merge

collapse (sum)Numberofestablishments-Valueaddedbymanufacture (sum)officers-wageearners_av_under16 (sum)RentedK-Electricmotors (sum)lit_share* (sum)*_agg, by(year area statea state industry_unified)
foreach x of varlist lit_share*{
replace `x'=`x'/Numberofestablishments
}
gen double panel_var=area*1000+industry_unified

fillin panel_var year

foreach var of varlist Numberofestablishments wageearners_av_total Capital Valueofproducts{
replace `var'=0 if _fillin==1
}

replace area=floor(panel_var/1000) if _fillin==1
replace industry_unified=panel_var-(1000*area) if _fillin==1
replace statea=string(floor(area/10000)) if _fillin==1
replace statea="0"+string(floor(area/10000)) if floor(area/10000)<100 & _fillin==1
rename _fillin wasnotanindustry

foreach var of varlist *_agg{
bysort industry_unified year: egen max=max(`var')
replace `var'=max
drop max
}


bysort area year: egen total_y_city=sum(Valueofproducts)
bysort area year: egen total_l_city=sum(wageearners_av_total)
bysort area year: egen total_k_city=sum(Capital)
bysort area year: egen total_n_city=sum(Numberofestablishments)

drop if industry_unified==148

gen share_y=Valueofproducts/total_y_city
gen share_l=wageearners_av_total/total_l_city
gen share_k=Capital/total_k_city
gen share_n=Numberofestablishments/total_n_city

gen kl_1860=(Capital_agg/wageearners_av_total_agg) if year==1860 & Capital_agg/wageearners_av_total_agg~=.
bysort industry_unified: egen kl_mean=mean(Capital_agg/wageearners_av_total_agg)
gen hl_1890=(officers_agg/wageearners_av_total_agg) if year==1890 & officers_agg/wageearners_av_total_agg~=.
bysort industry_unified: egen hl_mean=mean(officers_agg/wageearners_av_total_agg)
bysort industry_unified: egen kl_industry=mean(kl_1860)
bysort industry_unified: egen hl_industry=mean(hl_1890)
gen high_kl=kl_industry>600 if kl_industry~=.
gen high_hl=hl_industry>0.11 if hl_industry~=.
gen high_kl_mean=kl_mean>600 if kl_mean~=.
gen high_hl_mean=hl_mean>0.15 if hl_mean~=.
drop kl_1860 hl_1890
rename kl_industry kl_1860
rename hl_industry hl_1890
rename kl_mean kl_mean_agg
rename hl_mean hl_mean_agg
save dta/industries_final3_collapsed,   replace

drop if Numberofestablishments==0

save dta/industries_final3_no0s_collapsed,   replace

cap log close

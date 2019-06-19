cd "C:\Users\jedwab\Desktop\Regressions_for_Ghana"

* This do-file ("construction_data_ghana") creates the main data set we use for the regressions on Ghana: "ghana1.dta"
* The Web Appendix describes in more details the sources used for each variable
* The do-file "regressions_ghana.do" in the same folder then allows us to recreate the tables and some of the figures for Ghana

********************************************************************************************

******************************************************************
* CREATION OF THE GRID DATA SET (2091 CELLS OF 0.1 x 0.1 DEGREE) * 
******************************************************************

* The GIS file for the grid cells is available in the folder "GIS_Files_for_Ghana\Grid Cells"
* The file contains the list of 2,091 grid cells 
clear
insheet using "Grid_0.1x0.1_Ghana.csv", delimiter(",")
count
labe var gridcell "Grid cell"
label var area_sqkm "Grid cell area (sq km)"
sort gridcell
save ghana1, replace
desc

******************************************************
* PANEL STRUCTURE OF THE DATA: CREATION OF THE YEARS *
******************************************************

* We create the panel structure of the data by multiplying the cells by the years
* The 8 years for which we have data are 1891, 1901, 1931, 1948, 1960, 1970, 1984 and 2000
* The csv file lists the 8 years
clear
insheet using "years.csv", delimiter(",")
count
ren v1 year 
save years, replace

use ghana1, clear
cross using years
label var year "Census year"
save ghana1, replace
tab year
count
desc 
* The data set has 2,091 grid cells x 8 years = 16,728 total observations

*******************************************
* INFORMATION ON COASTAL AND BORDER CELLS *
*******************************************

* We create two dummies for whether the cell is a coastal cell or a cell bordering another country. 
* The GIS file for the coastal cells is available in the folder "GIS_Files_for_Ghana\Geography\Coast"
* sea.csv was created in GIS by selecting the cells bordering the sea
clear
insheet using "sea.csv", delimiter(",")
count
sort gridcell
save sea, replace

use ghana1, clear
sort gridcell
merge gridcell using sea
tab _m
drop _m
label var sea "Coastal grid cell dummy"
* The border cells are the cells whose area is strictly lower than 121 sq km (i.e., the cells that are not squares) and that are not coastal
gen border = (area_sqkm <= 121)
replace border = 0 if sea == 1
tab border sea
label var border "Border grid cell dummy"
sort gridcell
save ghana1, replace
desc

*********************************************************
* INFORMATION ON ETHNIC GROUPS, PROVINCES AND DISTRICTS * 
*********************************************************

* The GIS files for the ethnic groups, provinces and districts are available in the folder "GIS_Files_for_Ghana\Ethnic Groups, Provinces and Districts"
* The csv file shows the ethnic group to which the cells mostly belong (here defined in terms of area)
* We use the ethnic group boundaries of Nunn (2011) 
clear
insheet using "ethnic_groups.csv", delimiter(",")
ren v1 gridcell
ren v2 ethnic
count
codebook ethnic
* 34 ethnic groups
sort gridcell
save ethnic_group, replace

* The csv file shows the province to which the cells mostly belong (here defined in terms of area)
* We use the provincial boundaries (N = 10) for the year 2000
clear
insheet using "provinces.csv", delimiter(",")
ren v1 gridcell
ren v2 province_2000
count
codebook province
* 10 provinces
sort gridcell
save province, replace

* The csv file shows the district to which the cells mostly belong (here defined in terms of area)
* We use the district boundaries (N = 109) for the year 2000
clear
insheet using "districts.csv", delimiter(",")
ren v1 gridcell
ren v2 district_2000
count
codebook district
* 109 districts
sort gridcell
save district, replace

* We merge the main data set and the province, district and ethnic group data sets
use ghana1, clear
sort gridcell
merge gridcell using ethnic_group
tab _m
drop _m
sort gridcell
merge gridcell using province
tab _m
drop _m
sort gridcell
merge gridcell using district
tab _m
* Two grid cells do not have a district when using the GIS map
* This is due to spatial inconsistencies between the grid map and the district map
* We verify using GIS which district these cells belong to 
replace district_2000 = "Bawku West" if gridcell == "AE4"
replace district_2000 = "Ketu" if gridcell == "AT52"
codebook district
* We verify that there are still 109 districts
* There are 110 districts in the GIS file, but one "tiny" district is not the "main" district of any cell 
drop _m
label var ethnic "Dominant ethnic group in the cell (N = 34) (based on Murdock map)"
label var province_2000 "Province (N = 10), Boundaries for the year 2000"
label var district_2000 "District (N = 109), Boundaries for the year 2000"
sort gridcell
save ghana1, replace

******************************************************
* INFORMATION ON EXISTING AND PLACEBO RAILROAD LINES *
******************************************************

* The GIS files for the existing and placebo railroad lines are available in the folders "GIS_Files_for_Ghana\Railroads\Built" and "GIS_Files_for_Ghana\Railroads\Placebo"
* We use GIS to obtain the Euclidean distance (km) to the existing railroad lines in 1898-1918 and 1918-1931
clear
insheet using "dist2railroad31.csv"
sort gridcell
count
save dist2railroad31, replace

use ghana1, clear
sort gridcell
merge gridcell using dist2railroad31
tab _m
drop _m
label var dist2line18 "Euclidean distance (km) to an existing railroad line in 1918"
label var dist2west18 "Euclidean distance (km) to the Western line in 1918"
label var dist2east18 "Euclidean distance (km) to the Eastern line in 1918"
label var dist2line1823 "Euclidean distance (km) to a railroad line built in 1918-1923"
label var dist2line2331 "Euclidean distance (km) to a railroad line built in 1923-1931"
label var dist2linepost18 "Euclidean distance (km) to a railroad line built in 1918-1956"
* We create the railroad dummies using the Euclidean distance to a railroad line (1918)
* We create the dummies for each 0-10 km segment until 80 km, and then for 0-20 km, 0-30 km and 0-40 km
gen rail18_10= (dist2line18>0 & dist2line18<=10)
gen rail18_1020= (dist2line18>10 & dist2line18<=20)
gen rail18_2030= (dist2line18>20 & dist2line18<=30)
gen rail18_3040= (dist2line18>30 & dist2line18<=40)
gen rail18_4050= (dist2line18>40 & dist2line18<=50)
gen rail18_5060= (dist2line18>50 & dist2line18<=60)
gen rail18_6070= (dist2line18>60 & dist2line18<=70)
gen rail18_7080= (dist2line18>70 & dist2line18<=80)
gen rail18_20= (dist2line18<=20)
gen rail18_30= (dist2line18<=30)
gen rail18_40= (dist2line18<=40)
gen rail1856_10 = (dist2linepost18 <= 10)
replace rail1856_10 = 0 if rail18_10 == 1
label var rail18_10 "Cell less than 10 km from a railroad line in 1918" 
label var rail18_1020 "Cell 10-20 km from a railroad line in 1918" 
label var rail18_2030 "Cell 20-30 km from a railroad line in 1918" 
label var rail18_3040 "Cell 30-40 km from a railroad line in 1918" 
label var rail18_4050 "Cell 40-50 km from a railroad line in 1918" 
label var rail18_5060 "Cell 50-60 km from a railroad line in 1918" 
label var rail18_6070 "Cell 60-70 km from a railroad line in 1918" 
label var rail18_7080 "Cell 70-80 km from a railroad line in 1918" 
label var rail18_20 "Cell less than 20 km from a railroad line in 1918" 
label var rail18_30 "Cell less than 30 km from a railroad line in 1918" 
label var rail18_40 "Cell less than 40 km from a railroad line in 1918" 
label var rail1856_10 "Cell less than 10 km from a railroad line built in 1918-1956" 
* We create the railroad dummies (0-10, 0-20, 0-30, 0-40 km) using the Euclidean distance to the Western line (1918) only
gen rail18w_10= (dist2west18<=10)
gen rail18w_20= (dist2west18<=20)
gen rail18w_30= (dist2west18<=30)
gen rail18w_40= (dist2west18<=40)
label var rail18w_10 "Cell less than 10 km from the Western line in 1918" 
label var rail18w_20 "Cell less than 20 km from the Western line in 1918" 
label var rail18w_30 "Cell less than 30 km from the Western line in 1918" 
label var rail18w_40 "Cell less than 40 km from the Western line in 1918" 
* We create the placebo railroad dummies (0-10, 0-20, 0-30 and 0-40 km) for the lines that were not built early enough to affect cocoa production in 1927
* Tafo-Kumasi was indeed built between 1918 and 1923
* Huni Valley-Kade was indeed built between 1923 and 1931
gen tk_10= (dist2line1823<=10)
gen tk_20= (dist2line1823<=20)
gen tk_30= (dist2line1823<=30)
gen tk_40= (dist2line1823<=40)
gen hvk_10= (dist2line2331<=10)
gen hvk_20= (dist2line2331<=20)
gen hvk_30= (dist2line2331<=30)
gen hvk_40= (dist2line2331<=40)
label var tk_10 "Cell less than 10 km from the Tafo-Kumasi placebo line" 
label var tk_20 "Cell less than 20 km from the Tafo-Kumasi placebo line" 
label var tk_30 "Cell less than 30 km from the Tafo-Kumasi placebo line" 
label var tk_40 "Cell less than 40 km from the Tafo-Kumasi placebo line" 
label var hvk_10 "Cell less than 10 km from the Huni Valley-Kade placebo line" 
label var hvk_20 "Cell less than 20 km from the Huni Valley-Kade placebo line" 
label var hvk_30 "Cell less than 30 km from the Huni Valley-Kade placebo line" 
label var hvk_40 "Cell less than 40 km from the Huni Valley-Kade placebo line" 
sort gridcell
save ghana1, replace

* Euclidean distance (km) to the placebo railroad lines that were planned but not built
clear
insheet using "dist2placebo.csv"
sort gridcell
save dist2placebo, replace

use ghana1, clear
sort gridcell
merge gridcell using dist2placebo
tab _m
drop _m
label var dist2ccpk "Euclidean distance (km) to Cape Coast-Kumasi placebo line"
label var dist2sok "Euclidean distance (km) to Saltpond-Kumasi placebo line"
label var dist2aok "Euclidean distance (km) to Accra-Kumasi placebo line"
label var dist2apamok "Euclidean distance (km) to Apam-Kumasi placebo line"
label var dist2kpong "Euclidean distance (km) to Accra-Kpong placebo line"

* We create the placebo railroad dummies (0-10, 0-20, 0-30 and 0-40 km) for the lines that were planned but not built
* Cape Coast-Kumasi 1873
gen ccpk_10= (dist2ccpk<=10)
gen ccpk_20= (dist2ccpk<=20)
gen ccpk_30= (dist2ccpk<=30)
gen ccpk_40= (dist2ccpk<=40)
label var ccpk_10 "Cell less than 10 km from the Cape Coast-Kumasi placebo line" 
label var ccpk_20 "Cell less than 20 km from the Cape Coast-Kumasi placebo line" 
label var ccpk_30 "Cell less than 30 km from the Cape Coast-Kumasi placebo line" 
label var ccpk_40 "Cell less than 40 km from the Cape Coast-Kumasi placebo line" 
* Saltpond-(Oda)-Kumasi 1893
gen sok_10= (dist2sok<=10)
gen sok_20= (dist2sok<=20)
gen sok_30= (dist2sok<=30)
gen sok_40= (dist2sok<=40)
label var sok_10 "Cell less than 10 km from the Saltpond-Kumasi placebo line" 
label var sok_20 "Cell less than 20 km from the Saltpond-Kumasi placebo line" 
label var sok_30 "Cell less than 30 km from the Saltpond-Kumasi placebo line" 
label var sok_40 "Cell less than 40 km from the Saltpond-Kumasi placebo line" 
* Accra-(Oda)-Kumasi 1897
gen aok_10= (dist2aok<=10)
gen aok_20= (dist2aok<=20)
gen aok_30= (dist2aok<=30)
gen aok_40= (dist2aok<=40)
label var aok_10 "Cell less than 10 km from the Accra-Kumasi placebo line" 
label var aok_20 "Cell less than 20 km from the Accra-Kumasi placebo line" 
label var aok_30 "Cell less than 30 km from the Accra-Kumasi placebo line" 
label var aok_40 "Cell less than 40 km from the Accra-Kumasi placebo line" 
* Apam-(Oda)-Kumasi 1897
gen apamok_10= (dist2apamok<=10)
gen apamok_20= (dist2apamok<=20)
gen apamok_30= (dist2apamok<=30)
gen apamok_40= (dist2apamok<=40)
label var apamok_10 "Cell less than 10 km from the Apam-Kumasi placebo line" 
label var apamok_20 "Cell less than 20 km from the Apam-Kumasi placebo line" 
label var apamok_30 "Cell less than 30 km from the Apam-Kumasi placebo line" 
label var apamok_40 "Cell less than 40 km from the Apam-Kumasi placebo line" 
* Accra-Kpong 1898
gen kpong_10= (dist2kpong<=10)
gen kpong_20= (dist2kpong<=20)
gen kpong_30= (dist2kpong<=30)
gen kpong_40= (dist2kpong<=40)
label var kpong_10 "Cell less than 10 km from the Accra-Kpong placebo line" 
label var kpong_20 "Cell less than 20 km from the Accra-Kpong placebo line" 
label var kpong_30 "Cell less than 30 km from the Accra-Kpong placebo line" 
label var kpong_40 "Cell less than 40 km from the Accra-Kpong placebo line" 
* Placebo (whether not built early enough or planned but not built)
gen placebo_10 = (ccpk_10 == 1 | sok_10 == 1 | apamok_10 == 1 | aok_10 == 1 | kpong_10 == 1 | tk_10 == 1 | hvk_10 == 1)
gen placebo_20 = (ccpk_20 == 1 | sok_20 == 1 | apamok_20 == 1 | aok_20 == 1 | kpong_20 == 1 | tk_20 == 1 | hvk_20 == 1)
gen placebo_30 = (ccpk_30 == 1 | sok_30 == 1 | apamok_30 == 1 | aok_30 == 1 | kpong_30 == 1 | tk_30 == 1 | hvk_30 == 1)
gen placebo_40 = (ccpk_40 == 1 | sok_40 == 1 | apamok_40 == 1 | aok_40 == 1 | kpong_40 == 1 | tk_40 == 1 | hvk_40 == 1)
label var placebo_10 "Cell less than 10 km from any placebo line" 
label var placebo_20 "Cell less than 20 km from any placebo line"
label var placebo_30 "Cell less than 30 km from any placebo line" 
label var placebo_40 "Cell less than 40 km from any placebo line" 
sort gridcell
save ghana1, replace

************************************
* INFORMATION ON RAILROAD STATIONS *
************************************

* The GIS file for the railroad stations is available in the folder "GIS_Files_for_Ghana\Railroads\Stations"
* We use GIS to obtain the Euclidean distance (km) to the railroad stations
clear
insheet using "distance2stat.csv"
sort gridcell
save distance2stat, replace

use ghana1, clear
sort gridcell 
merge gridcell using distance2stat
tab _m
drop _m 
label var dist2stat18 "Euclidean distance (km) to a railroad station in 1918"
gen railstat18_10= (dist2stat18>0 & dist2stat18<=10)
gen railstat18_20= (dist2stat18<=20)
gen railstat18_40= (dist2stat18<=40)
label var railstat18_10 "Cell less than 10 km from a railroad station in 1918" 
label var railstat18_20 "Cell less than 20 km from a railroad station in 1918" 
label var railstat18_40 "Cell less than 40 km from a railroad station in 1918" 
sort gridcell
save ghana1, replace

**********************************
* IV STRAIGHT LINES FOR RAILROAD *
**********************************

* The GIS file for the IV straight lines is available in the folder "GIS_Files_for_Ghana\Railroads\IV Straight Lines"
clear
insheet using "dist2iv.csv"
sort gridcell
save dist2iv, replace

clear
insheet using "neighbors.csv"
sort gridcell
save neighbors, replace

use ghana1, clear
sort gridcell 
merge gridcell using dist2iv
tab _m
drop _m 
label var dist2iv "Euclidean distance (km) to an IV straight line"
gen iv_40 = (dist2iv <= 40)
label var iv_40 "Cell less than 40 km from an IV straight line" 
* These cells are the cells containing a railway node within the forest area, our main: Sekondi, Tarkwa, Obuasi, Kumasi and Accra
gen iv_node = (gridcell == "AG60" | gridcell == "S53" | gridcell == "P62" | gridcell == "S66" | gridcell == "S49") 
* We also create a specific dummy for Kumasi
gen kumasi = (gridcell == "S49")
label var kumasi "Dummy equal to one if the cell contains Kumasi"
label var iv_node "Dummy equal to one if the cell contains a node used to build the IV straight lines"
* We also create a dummy equal to one for the neighbors of these nodes
* We will test if results are robust to dropping to neighbors
sort gridcell
merge gridcell using neighbors
tab _m
drop _m
replace iv_node_neighbor = 0 if iv_node_neighbor == .
label var iv_node_neighbor "Dummy equal to one if cell neighboring a node used for the IV straight lines"
sort gridcell
save ghana1, replace

****************************************
* INFORMATION ON COCOA PRODUCTION 1927 *
****************************************

* The GIS file for cocoa production is available in the folder "GIS_Files_for_Ghana\Cocoa\Production"
* We use an administrative map of cocoa production in 1927
* The map shows red dots for the production (100 tons) transported by rail
* The map shows green dots for the production (100 tons) transported by road

clear
insheet using "cocoa_production_1927.csv"
gen cocoarail_prod27 = numred*100
gen cocoaroad_prod27 = numgree*100
gen cocoa_prod27 = cocoarail_prod + cocoaroad_prod 
keep gridcell cocoa_prod27
sort gridcell
save cocoa_production_1927, replace

***

use ghana1, clear
sort gridcell
merge gridcell using cocoa_production_1927
label var cocoa_prod27 "Cell cocoa production (tons) in 1927"
tab _m
drop _m
save ghana1, replace

****************************************************************
* INFORMATION ON COCOA PRODUCTION BROUGHT TO RAILROAD STATIONS *
****************************************************************

* We obtained a list of railroad stations in 1918 and how many tons of cocoa production were brought to the station then 
clear
insheet using "cocoastat.csv"
sort gridcell
save cocoastat, replace

use ghana1, clear
sort gridcell 
merge gridcell using cocoastat
tab _m
drop _m 
replace railstat_yn18 = 0 if railstat_yn18 == .
label var railstat_yn18 "Dummy equal to one if the cell contains a railroad station in 1918"
replace cocoastat_18 = 0 if cocoastat_18 == .
label var cocoastat "Cocoa tonnages brought to the railroad station in 1918"
replace railstat_yn18 = 0 if year == 1901
replace cocoastat = 0 if year == 1901
save ghana1, replace

****************************************************
* INFORMATION ON COCOA SUITABILITY AND FOREST AREA *
****************************************************

* The two GIS maps of cocoa suitability are available in the folder "GIS_Files_for_Ghana\Cocoa"
* We use as our main source of information an administrative map of cocoa soils 
* We correct this administrative map using another adminsitrative map showing thebareas suitable for cocoa exports
* Indeed, the first map is not precise enough about which areas are suitable for cocoa exports or no
* This allows us to create various measures of soil suitability

* This csv file has the information on cocoa soils (the first map, hence our main source of information)
* It shows the grid cell areas (sq km) of various types of cocoa soils:
* Ochrosols (these are the best cocoa soils): class 1, class 2, class 3, unsuitable
* Intergrades (these are intermediary cocoa soils)
* Oxysols (these are the worse cocoa soils)
* "Area" is the total area of these soils
clear
insheet using "cocoasoil.csv"
foreach X of varlist class3-intergrade {
gen area_`X' = area if `X' == 1
}
collapse (sum) area area_class3-area_intergrade, by(gridcell)
drop if gridcell == ""
sort gridcell
save cocoasoil, replace

* This csv file has the information on suitability for cocoa exports (the second map)
* Some areas are considered as unsuited for the cultivation of cocoa, no matter the cocoa soils 
clear
insheet using "area_unsuited.csv"
ren description gridcell
keep gridcell area_unsuited
sort gridcell
save cocoasoil2, replace

* We merge the information from the two maps to create our measures of soil suitability
use ghana1, clear
sort gridcell
merge gridcell using cocoasoil
tab _m
drop _m
sort gridcell
merge gridcell using cocoasoil2
tab _m
drop _m
replace area = 0 if area == .
foreach X in class3 class2 class1 unsuitable oxysol intergrade unsuited {
replace area_`X' = 0 if area_`X' == .
}
* For the first map only, we verify that the total area of cocoa soils does not exceed the total area of the cell
* The share is always lower than 1, so we did not make any mistake
gen share_cocoa = area/area_sqkm
sum share_cocoa, d
* We then correct this share using the share of soils unsuited for cocoa cultivation
* First, we verify that the area of unsuited areas does not exceed the area of the cell
replace area_unsuited = area_sqkm if area_unsuited > area_sqkm
foreach X in class3 class2 class1 unsuitable oxysol intergrade unsuited {
gen share_`X' = area_`X'/area_sqkm
replace share_`X' = 0 if share_`X' == .
}
ren share_unsuitable share_unsuit
ren share_intergrade share_inter
label var share_cocoa "Share of grid area = cocoa soil"
label var share_class1 "a. Share of grid area = Ochrosols First Class"
label var share_class2 "b. Share of grid area = Ochrosols Second Class"
label var share_class3 "c. Share of grid area = Ochrosols Third Class"
label var share_unsuit "d. Share of grid area = Ochrosols Unsuitable"
label var share_oxysol "e. Share of grid area = Oxysols"
label var share_inter "f. Share of grid area = Intergrade"
label var share_unsuited "g. Share of grid area = Unsuited (new definition)"
* We create the new share of soils suitable for cocoa cultivation by correcting the main share using the share of unsuited soils
gen share_cocoa_new = share_cocoa-share_unsuited
sum share_cocoa_new, d
* We make sure the share is not lower than 0 or higher than 1
replace share_cocoa_new = 0 if share_cocoa_new < 0
replace share_cocoa_new = 1 if share_cocoa_new > 1
* We create the variables we will be using in our analysis: three dummies (and the shares) for whether the soils of cell are suitable, highly suitable or very highly suitable for cocoa cultivation
* "Suitable": A cell is defined as suitable for cocoa production if it contains cocoa soils. 
gen suitable = (share_cocoa_new > 0 & share_cocoa_new != 0)
* "Highly suitable": A cell is highly suitable if more than 50% of its area consists of forest ochrosols, the best cocoa soils.
gen highsuit = (share_class1+share_class2+share_class3+share_unsuit >= 0.50)
* "Very highly suitable": A cell is very highly suitable if more than 50% of its area consists of class 1 and class 2 ochrosols.
gen vhighsuit = (share_class1+share_class2 >= 0.50)
tab suitable highsuit
gen share_highsuit = (share_class1+share_class2+share_class3+share_unsuit)
sum share_highsuit, d
gen share_vhighsuit = (share_class1+share_class2)
sum share_vhighsuit, d
drop share_cocoa-share_unsuited
ren share_cocoa_new share_suitable
drop area area_cl* area_ox* area_uns* area_inter* 
label var suitable "Dummy equal to one if the cell share of cocoa soils > 0%"
label var highsuit "Dummy equal to one if the cell share of highly suitable soils > 50%"
label var vhighsuit "Dummy equal to one if the cell share of very highly suitable soils > 50%"
label var share_suitable "Cell share of cocoa soils (%)"
label var share_highsuit "Cell share of highly suitable cocoa soils (%)"
label var share_vhighsuit "Cell share of very highly suitable cocoa soils (%)"
order gridcell-railstat_yn18 suitable highsuit vhighsuit share_suitable share_high share_vhigh
sort gridcell 
save ghana1, replace

***************************************************************
*** URBAN AND TOTAL POPULATION DATA FOR THE COLONIAL PERIOD ***
***************************************************************

************************************************************
* INFORMATION ON CITIES IN 1891, 1901, 1931, 1948 AND 1960 *
************************************************************

* The GIS file of the cities is available in the folder "GIS_Files_for_Ghana\Population\Cities_1891_1960"
* We use various gazetteers to recreate a list of all the cities larger than 1,000 inhabitants for the following years: 1891, 1901, 1931, 1948 and 1960  
* We add the city population data to the grid data set
clear
insheet using "cities_1891_1960.csv", delimiter(",")
drop if name == ""
count
* We have 1372 localities with at least 1,000 inhabitants at one point in 1891, 1901, 1931, 1948 or 1960
gen id_city = _n
reshape long pop, i(id_city) j(year)
gen upop_1_2 = (pop >= 1000 & pop < 2000)
gen upop_2_3 = (pop >= 2000 & pop < 3000)
gen upop_3_4 = (pop >= 3000 & pop < 4000)
gen upop_4_5 = (pop >= 4000 & pop < 5000)
gen upop_5_10 = (pop >=5000 & pop < 10000)
gen upop_10_20 = (pop >= 10000 & pop < 20000)
gen upop_20_50 = (pop >= 20000 & pop < 50000)
gen upop_50_100 = (pop >= 50000 & pop < 100000)
gen upop_100_200 = (pop >= 100000 & pop < 200000)
gen upop_200_500 = (pop >= 200000 & pop < 500000)
count if gridcell == ""
codebook name if gridcell == ""
* There are only 23 cities out of 1,372 cities for which we could not find the geographical coordinates
sum pop* if gridcell == "" & year == 1960, d
* However, their population is generally very small, so the fact that we do not include them in our analysis is unlikely to influence our estimates
collapse (sum) pop (sum) upop_*, by(gridcell year)
ren pop upop
replace upop = round(upop)
label var upop "Grid cell urban population (inhabitants)"
drop if gridcell == ""
sort gridcell year
save urbandata_1891_1960, replace 
codebook gridcell
* There are 627 cells with total urban population larger than 0 in 1891-1960

use ghana1, clear
sort gridcell year
merge gridcell year using urbandata_1891_1960
tab _m
drop _m
sort gridcell
save ghana1, replace

****************************************************
* INFORMATION ON TOTAL POPULATION IN 1901 AND 1931 *
****************************************************

* The GIS files for total population are available in the folder "GIS_Files_for_Ghana\Population\Population_1901" and "GIS_Files_for_Ghana\Population\Population_1931"
* For the year 1901, we use the gazetter of the 1901 census and the geographical index to the gazetteer that was published in 1908 to obtain the location of different types of localities 
* This allows us to reconstruct the rural population and the total population of each cell. However, we can only do that for the South of the country, as the census was not exhaustive
clear
insheet using "popcensus_1901.csv"
* These are the different types of localities for which we know the total number in each cell
ren num_lt ltowns08
ren num_t towns08
ren num_hct headchief08
ren num_lv lvillages08
ren num_v villages08
ren map1908yn map08_yn
keep gridcell ltowns towns head lvill vill map*
label var ltowns08 "Number of large towns in 1901"
label var towns08 "Number of towns (>500) in 1901"
label var headchief08 "Number of head chief towns in 1901"
label var lvillages08 "Number of large villages (100-500) in 1901"
label var villages08 "Number of villages (<100) in 1901"
label var map08_yn "Information available on total  population from 1901 census: yes/no"
foreach X of varlist ltowns08-villages08 {
replace `X' = . if map08_yn == 0
}
sort gridcell
save popcensus_1901, replace

* For the year 1931, we have a census map showing all the towns and villages in the country
* We have digitized this map in GIS and obtained the number of villages and towns for each cell
* This allows us to reconstruct the rural population and the total population of each cell, for the whole country this time
clear
insheet using "popcensus_1931.csv"
* city1000 is the number of cities above 1,000 inhabitants. It comes from our data set of cities
* If we have the number of towns above 500 and the number of cities above 1,000, we can obtain the number of towns between 500 and 1000 inhabitants
gen num_500_1000 =  town500map_1931 - city1000
tab num_500_1000
* There a few mistakes, but mostly by one
* We treat them as exogenous measurement errors and treat them as 0s
replace num_500_1000 = 0 if num_500_1000 < 0
* We know the mean population of the places between 500 and 1000 according to the census report
* We thus multiply their number by their mean population to reconstruct the total population in places between 500 and 1000
gen pop_500_1000 = num_500_1000 * 680.4
* We then know the number of villages below 500, and their average population according to the census report
gen pop_0_500 = villages*200
collapse (sum) pop*, by(gridcell)
sort gridcell
save popcensus_1931, replace

***

use ghana1, clear
sort gridcell 
merge gridcell using popcensus_1931
tab _m 
drop _m
sort gridcell
merge gridcell using popcensus_1901
tab _m
drop _m
** We first create the rural population for the year 1931
* The total population of localities between 0 and 500 and localities between 500 and 1,000 gives the total rural population
gen rpop1931 = pop_0_500 + pop_500_1000
drop pop_0_500 pop_500_1000
** We then create the rural population for the year 1901
* We first recreate the total population of places between 500 and 1000 inhabitants 
* We know from the census report that the "towns" have a population of at least 500 inhabitants 
* The large towns and the head chief towns are larger than 500 too
* Adding the towns, large towns and head chief towns gives us all the towns above 500
* If we thus know the number of towns above 1,000, we can recreate the number of towns between 500 and 1000
egen num_1000_1901 = rsum(upop_1_2-upop_200_500) if map08_yn == 1
drop upop_1_2-upop_200_500
gen num_500_1000_1901 = (ltowns08+headchief08+towns08) - num_1000_1901 if map08_yn == 1
* There are a few mistakes in the sense that there are negative numbers
* But it is true mostly by 1 town, so we treat them as exogenous measurement errors and treat them as 0s
tab num_500_1000_1901 if year == 1901
replace num_500_1000_1901 = 0 if num_500_1000_1901 < 0 & map08_yn == 1
* We know the mean population of villages and larger villages from the census report
* This way we can recreate the total population of places between 0 and 500 inhabitants 
gen pop_0_500_1901 = villages08*43.75 + lvillages08*209.90
* We know the mean population of places between 0 and 500 inhabitants from the census report
* We thus recreate the total population of places between 500 and 1000 inhabitants 
gen pop_500_1000_1901 = num_500_1000_1901 * 720.46
* The rural population is the total population of places between 0 and 1,000 inhabitants
gen rpop1901 = pop_0_500_1901 + pop_500_1000_1901
drop num_1000_1901
gen rpop = rpop1901 if year == 1901
replace rpop = rpop1931 if year == 1931
ren rpop1931 rpop_1931
ren rpop1901 rpop_1901
drop num_500* pop_0* pop_500* ltowns08-villages08
label var rpop_1931 "Cell rural population in 1931"
label var rpop_1901 "Cell rural population in 1901"
label var rpop "Cell rural population"
sort gridcell
save ghana1, replace 

***********************************************************************
* CLEANING OF THE POPULATION DATA FOR 1891, 1901, 1931, 1948 AND 1960 *
***********************************************************************

use ghana1, clear
replace upop = 0 if upop == . & year >= 1891 & year <= 1960
gen upop91 = upop if year == 1891
bysort gridcell: egen upop_1891 = max(upop91)
drop upop91
label var upop_1891 "Cell urban population in 1891"
gen upop01 = upop if year == 1901
bysort gridcell: egen upop_1901 = max(upop01)
drop upop01
label var upop_1901 "Cell urban population in 1901"
gen upop31 = upop if year == 1931
bysort gridcell: egen upop_1931 = max(upop31)
drop upop31
label var upop_1931 "Cell urban population in 1931"
gen upop48 = upop if year == 1948
bysort gridcell: egen upop_1948 = max(upop48)
drop upop48
label var upop_1948 "Cell urban population in 1948"
gen upop60 = upop if year == 1960
bysort gridcell: egen upop_1960 = max(upop60)
drop upop60
label var upop_1960 "Cell urban population in 1960"
gen pop = upop+rpop
gen pop31 = pop if year == 1931
bysort gridcell: egen pop_1931 = max(pop31)
drop pop31
label var pop_1931 "Cell population in 1931"
label var pop "Cell population"
save ghana1, replace

********************************************************************
*** URBAN AND TOTAL POPULATION DATA FOR THE POST-COLONIAL PERIOD ***
********************************************************************

***************************************************************************
* INFORMATION ON URBAN, TOTAL AND RURAL POPULATION IN 1970, 1984 and 2000 * 
***************************************************************************

* We use the main data set of the 2000 Facility Census of Ghana, which shows the list of localities in the country and their population for the census years 1970, 1984 and 2000
* DATA SET FOR WHICH WE DO NOT OWN THE COPYRIGHT (the word document "Copyright".doc in the folder "Regressions for Ghana" describes how we got access to the data and how you can yourself access the data): This data set was given to us by the Ghanaian Statistical Services: http://www.statsghana.gov.gh/. Our contact then was Dr Grace Bediako, who was the Government Statistician. Dr Grace Bediako has since then left GSS. You can talk to the person who has replaced her by contacting the Data Service Unit at GSS.
* We do not include the primary data set of the facility census among the replication files. 
* Instead, we have included the list of localities with their population in 1970, 1984 and 2000 and the gridcell they belong to. This should help you understand how we create the data.

* The data set has 88,920 localities. The problem is that the infrastructure census did not give us the geographical coordinates. 
* We thus had to obtain the geographical coordinates ourselves.

* (1) For 8,407 of them, we easily found the geographical coordinates using GeoNet and were thus able to know the cell they belong to. 
* This data set is called "pop_1970_2000_a.csv".

* (2) For the other localities, we could not find easily the geographical coordinates. 
* But we know their enumeration area in 2000 (N = 27,305), and the geographical coordinates of the centroid of the enumeration area (EA). 
* Given that these EAs are small, most of them belong to one gridcell only. However, we know the area of each EA in each cell. We can thus use the population of each EA and the share of each EA in each cell to reconstruct the population of each cell for these specific localities.
* This data set is called "pop_1970_2000_b.csv"
* This second data set is thus subject to measurement errors. However, we assume that these measurement errors are exogenous. Additonally, the localities of the second data set only account for 3.9% of the total urban population. The first data set thus accounts for 96.1% of total population. This minimizes measurement errors. 

* (1) pop_1970_2000_a - data set of localities for which we know the exact geographical coordinates
clear
insheet using "popcensus_1970_2000_a.csv"
count
* 8,407 localities
collapse (sum) population2000 population1984 population1970 upopulation2000 upopulation1984 upopulation1970, by(gridcell)
ren population2000 pop2000_1
ren population1984 pop1984_1
ren population1970 pop1970_1
ren upopulation2000 upop2000_1
ren upopulation1984 upop1984_1
ren upopulation1970 upop1970_1
sort gridcell
save popcensus_1970_2000_a, replace
collapse (sum) pop2000_1 upop2000_1
* upop2000_1 = 12,357,138

* (2) pop_1970_2000_b - data set of localities for which we use the geographical coordinates of the enumeration area
clear
insheet using "popcensus_1970_2000_b.csv"
count
* 27,305 EAs
* The data is at the EA-gridcell level.
* Since we know the gridcell, we can reconstruct the total population of these localities for each gridcell  
collapse (sum) pop2000-upop1970, by(gridcell)
ren pop2000 pop2000_2
ren pop1984 pop1984_2
ren pop1970 pop1970_2
ren upop2000 upop2000_2
ren upop1984 upop1984_2
ren upop1970 upop1970_2
sort gridcell
save popcensus_1970_2000_b, replace
collapse (sum) pop2000_2 upop2000_2 
* upop2000_2 = 506,983 (3.9% of total urban population)

* We merge this information with the main data set 
use ghana1, clear
keep if year >= 1970
keep gridcell year
sort gridcell
sort gridcell
merge gridcell using popcensus_1970_2000_a
tab _m
drop _m
sort gridcell
merge gridcell using popcensus_1970_2000_b
tab _m
drop _m
gen pop_1 = pop1970_1 if year == 1970
replace pop_1 = pop1984_1 if year == 1984
replace pop_1 = pop2000_1 if year == 2000
replace pop_1 = 0 if pop_1 == .
gen pop_2 = pop1970_2 if year == 1970
replace pop_2 = pop1984_2 if year == 1984
replace pop_2 = pop2000_2 if year == 2000
replace pop_2 = 0 if pop_2 == .
gen upop_1 = upop1970_1 if year == 1970
replace upop_1 = upop1984_1 if year == 1984
replace upop_1 = upop2000_1 if year == 2000
replace upop_1 = 0 if upop_1 == .
gen upop_2 = upop1970_2 if year == 1970
replace upop_2 = upop1984_2 if year == 1984
replace upop_2 = upop2000_2 if year == 2000
replace upop_2 = 0 if upop_2 == .
gen pop = pop_1+pop_2
gen upop = upop_1+upop_2
keep gridcell year pop upop 
sort gridcell year
save popcensus_1970_2000, replace

* We merge this additional information with the main data set and create a few more variables
use ghana1, clear
replace upop = . if year >= 1970
sort gridcell year
merge gridcell year using popcensus_1970_2000, update
tab _m
drop _m
gen pop70 = pop if year == 1970
bysort gridcell: egen pop_1970 = max(pop70)
drop pop70
label var pop_1970 "Cell population in 1970"
gen upop70 = upop if year == 1970
bysort gridcell: egen upop_1970 = max(upop70)
drop upop70
label var upop_1970 "Cell urban population in 1970"
gen rpop_1970 = pop_1970-upop_1970
label var rpop_1970 "Cell rural population in 1970"
gen pop84 = pop if year == 1984
bysort gridcell: egen pop_1984 = max(pop84)
drop pop84
label var pop_1984 "Cell population in 1984"
gen upop84 = upop if year == 1984
bysort gridcell: egen upop_1984 = max(upop84)
drop upop84
label var upop_1984 "Cell urban population in 2000"
gen pop00 = pop if year == 2000
bysort gridcell: egen pop_2000 = max(pop00)
drop pop00
label var pop_2000 "Cell population in 1984"
gen upop00 = upop if year == 2000
bysort gridcell: egen upop_2000 = max(upop00)
drop upop00
label var upop_2000 "Cell urban population in 2000"
gen rpop_2000 = pop_2000-upop_2000
label var rpop_2000 "Cell rural population in 2000"
save ghana1, replace

* We use the information from the population census in 2000 and obtain the total urban population of each cell for different city thresholds
* We use 1666, 10000, 2000, 5000, 15000 and 20000
* These measures are available in the dta "upop_other_thresholds"
use ghana1, clear
sort gridcell
merge gridcell using upop_other_thresholds
tab _m
drop _m
label var upop1666_2000 "Cell urban population in 2000, for cities larger than 1,666 inh."
label var upop10000_2000 "Cell urban population in 2000, for cities larger than 10,000 inh."
label var upop15000_2000 "Cell urban population in 2000, for cities larger than 15,000 inh."
label var upop20000_2000 "Cell urban population in 2000, for cities larger than 20,000 inh."
label var upop5000_2000 "Cell urban population in 2000, for cities larger than 5,000 inh."
label var upop2000_2000 "Cell urban population in 2000, for cities larger than 2,000 inh."
sort gridcell
save ghana1, replace

****************************************************************
* ADDITIONAL INFORMATION ON COCOA, POPULATION AND THE CONTROLS *
****************************************************************

use ghana1, clear

* We create a few more dependent variables that we will use in the analysis
* Creation of the urbanization rate, which we also use as a dependent variable
gen urbrate = upop/pop*100
* If the urbanization is missing, it is actually equal to 0
replace urbrate = 0 if urbrate == .
label var urbrate "Urbanization rate (%)"
* Creation of the urbanization rate for the year 1901, for the cells for which total population is not missing
gen urbrate01 = upop_1901/(upop_1901+rpop_1901)*100
replace urbrate01 = 0 if urbrate01 == . & map08_yn == 1
label var urbrate01 "Urbanization rate (%) in 1901"
* Creation of the log of urban population (we add 1 urban inhabitant because the urban population is equal to 0 for many observations)
gen lupop = log(upop+1)
label var lupop "Log of (urban population + 1 urban inhabitant)"
* Creation of the log of total population (we add 1 inhabitant because the total population is equal to 0 for a few observations)
gen lpop = log(pop+1)
label var lpop "Log of (total population + 1 inhabitant)"
* Creation of the log of cocoa production (we add 1 ton of production because the cocoa production is equal to 0 for many observations)
gen lcocoaprod = log(cocoa_prod27+1)
label var lcocoaprod "Log of (cocoa production + 1 ton of cocoa production)"
* We create dummies for whether there is a city in the cell
gen city_yn = (upop>= 1000 & upop != 0)
gen city_yn_1901 = (upop_1901>= 1000 & upop_1901 != 0)
gen city_yn_1891 = (upop_1891>= 1000 & upop_1891 != 0)
label var city_yn "Dummy equal to one if there is a city in the cell"
label var city_yn_1901 "Dummy equal to one if there is a city in the cell in 1901"
label var city_yn_1891 "Dummy equal to one if there is a city in the cell in 1891"

* We create a few more variables of interest that we will need for the analysis of general equilibrium effects
* The "Forest" variable defines the main sample of 554 cells we use in our main analysis
gen forest = (suitable == 1 & map08_yn == 1)
label var forest "Dummy equal to one if the cell belongs to the forest sample (554 cells)"
gen coastal = sea 
replace coastal = 0 if year == 1901
gen coastal_forest = 0
replace coastal_forest = coastal if forest ==1
gen coastal_rest = 0
replace coastal_rest = coastal if forest ==0
label var coastal "Dummy equal to one if the cell is along the coast"
label var coastal_forest "Dummy equal to one if the cell is along the coast in the forest area"
label var coastal_rest "Dummy equal to one if the cell is along the coast in the non-forest area"
gen city_1901 = (upop_1901 >= 1000 & upop_1901 != .)
gen city_1901_forest = 0
replace city_1901_forest = city_1901 if forest ==1
gen city_1901_rest = 0
replace city_1901_rest = city_1901 if forest ==0
label var city_1901 "Dummy equal to one if the cell has a city in 1901"
label var city_1901_forest "Dummy equal to one if the cell has a city and is in the forest area in 1901"
label var city_1901_rest "Dummy equal to one if the cell has a city and is in the forest area in 1901"

save ghana1, replace

**********************************************************
* ADDITIONAL INFORMATION FROM THE POPULATION CENSUS 2000 *
**********************************************************

* We use the main data set of the 2000 Population and Housing Census of Ghana at the individual level (10% sample)
* DATA SET FOR WHICH WE DO NOT OWN THE COPYRIGHT (the word document "Copyright".doc in the folder "Regressions for Ghana" describes how we got access to the data and how you can yourself access the data): This data set was given to us by the Ghanaian Statistical Services: http://www.statsghana.gov.gh/. Our contact then was Dr Grace Bediako, who was the Government Statistician. Dr Grace Bediako has since then left GSS. You can talk to the person who has replaced her by contacting the Data Service Unit at GSS.
* We do not include the primary data set of the facility census among the replication files. 
* Instead, we have included a data set with the total number of individuals with different characteristics by gridcell.

* These commands show how you can recreate from the raw data (pop_all1.dta) the data sets that we include among the replication files ("popcensus_2000.dta").
* The data set is at the individual level. We know the enumeration area of the individual, and the percentage share of the enumeration area (EA) in the gridcell. 
* We thus recreate the data at the grid cell level using the all the sub-units of different EAs that belong to a same grid cell 
*use pop_all1, clear
*sum prop_in_grid
* This variable describes to what extent the information from a same individual level can be used for multiple cells. 
* For a same individual, he can be entirely in one cell (prop_in_grid = 1) or across several cells (prop_in_grid < 1 for several cells). 
*bysort gridcell: egen cell_pop = sum(prop_in_grid)
*drop if cell_pop < 10
* This is the number of observations we have for each cell
*codebook gridcell
* We create three measures of housing infrastructure
*gen solid_walls = (walls == 4 | walls == 5 | walls == 6 | walls == 7)
*replace solid_walls = . if walls == .
*gen solid_floor = (floor == 2 | floor == 3 | floor == 4 | floor == 5 | floor == 7 | floor == 8 )
*replace solid_floor = . if floor == . 
*gen solid_roof = (roof == 4 | roof == 5 | roof == 6 | roof == 7 | roof == 8)
*replace solid_roof = . if roof == .
* We create one ,easure of water access
*gen good_water = (water ==  1 | water == 2 | water == 3) 
*replace good_water = . if water == .
* We create one measure of literacy (English or Ghanaian language) - for 25+ individuals only
*gen literate = (literacy >= 2 & literacy != 0) 
*replace literate = . if literacy == .
*replace literate = . if age < 25
* We create four measures of ducation (highest level of schooling attending/attended) - for 25+ individuals only
* = Some education
*gen educyn = (education == 2 | education == 3)
*replace educyn = . if age < 25
* = At least primary school
*gen educ_prim = (educlevel >= 2 & educlevel <= 7 & educlevel != .) 
*replace educ_prim = . if educlevel == .
*replace educ_prim = . if age < 25
* = At least junior secondary school (JSS)
*gen educ_jss = (educlevel >= 3 & educlevel <= 7 & educlevel != .) 
*replace educ_jss = . if educlevel == .
*replace educ_jss = . if age < 25
* = At least senior secondary school (SSS)
*gen educ_sss = (educlevel >= 4 & educlevel <= 7 & educlevel != .) 
*replace educ_sss = . if educlevel == .
*replace educ_sss = . if age < 25
* We create the number of adults older than 25 year-old
*gen adult25 = (age >= 25)
*replace adult25 = . if age == .
* We create the employment numbers variables 
* This 25-+ person has a job, in industry or services
*replace industry = . if age < 25
*gen job = (industry >= 1 & industry <= 99)
*gen indu = (industry >= 8 & industry <= 45)
*gen serv = (industry >= 50 & industry <= 99)
*gen induserv = (indu == 1 | serv == 1)
*replace job = . if industry == . 
*replace induserv = . if industry == .
* We multiply each variable by the weight of each individual in each cell 
*foreach X of varlist test solid_walls-induserv {
*replace `X' = `X' * prop_in_grid
*}
* We collpase the information at the cell level
*collapse (sum) prop_in_grid manufserv induserv job, by(gridcell)
*drop if gridcell == ""
* We drop the few cells for which we do not have enough observations
*ren prop_in_grid population
*save popcensus_2000, replace

* Our main data set shows the total number of individuals with different characteristics by gridcell.
* There are cells for which we have no population. This is due to the fact that some cells have no population and also the fact that there are measurement errors in the localization of the localities the individuals belong to.
use popcensus_2000, clear
* Shares of inhabitants with solid walls, solid roof, solid floor and access to improved water source in the total population of the cell according to the population census
* Population is the population in the cell according to the census. Since we use the 10% sample, the population is actually equal to 10 times this figure 
foreach X of varlist solid_walls solid_roof solid_floor good_water {
gen `X'_sh = `X' / population * 100
*sum `X'_sh, d
}
drop population solid_walls solid_roof solid_floor good_water
* We do not need this population variable
label var solid_walls_sh "Share of inhabitants (%) living in a residence with solid walls"
label var solid_floor_sh "Share of inhabitants (%) living in a residence with a solid floor"
label var solid_roof_sh "Share of inhabitants (%) living in a residence with a solid roof"
label var good_water_sh "Share of inhabitants (%) living in a residence with access to improved water"
* Shares of adults aged 25 or over that are literate, have ever been to school, and have finished primary schooling, junionr secondary schooling (jss) and senior secondary schooling (sss)
* Adult25 is the number of adults aged 25 or over in the cell according to the census. Since we use the 10% sample, the adult population is actually equal to 10 times this figure 
foreach X of varlist literate educyn educ_prim educ_jss educ_sss {
gen `X'_sh = `X' / adult25 * 100
*sum `X'_sh, d
}
drop adult25 literate educyn educ_prim educ_jss educ_sss
* We do not need this population variable
label var literate_sh "Share of adults 25 or over (%) that are literate"
label var educyn_sh "Share of adults 25 or over (%) that ever been to school"
label var educ_prim_sh "Share of adults 25 or over (%) that have at least completed primary school"
label var educ_jss_sh "Share of adults 25 or over (%) that have at least completed junior secondary school"
label var educ_sss_sh "Share of adults 25 or over (%) that have at least completed senior secondary school"
* Employment shares in the industrial and service sectors for working adults aged 25 or over
* Job is the number of workers in the cell according to the census. Since we use the 10% sample, the working population is actually equal to 10 times this figure 
foreach X of varlist induserv {
gen `X'_sh = `X' / job * 100
*sum `X'_sh, d
}
drop job induserv 
* We do not need these variables 
label var induserv_sh "Employment share of industry and services (%) for adults aged 25 or over"
sort gridcell
save popcensus_2000_all, replace

use ghana1, clear
sort gridcell
merge gridcell using popcensus_2000_all
tab _m
drop _m
save ghana1, replace

*************************
* INFORMATION ON MINING *
*************************

* The GIS file for mining is available in the folder "GIS_Files_for_Ghana\Mining"
* We create two controls for mining production:
* mincell: one dummy equal to one if there is a mine in the cell in 1931
* minvalue31_std: value of mining production in the cell in 1931
* We use these controls because mining was also a driver of urban growth during the colonial and post-colonial period

use mining1931, clear
sort gridcell
save mining1931, replace

use ghana1, clear
sort gridcell
merge gridcell using mining1931
tab _m
drop _m
gen mincell31 = (min_prod > 0)
label var mincell31 "Dummy equal to one if the cell contains a mine in 1931"
ren min_prod minprod31
label var minprod31 "Mineral production in 1931 (see type)" 
ren min_value minvalue31
label var minvalue31 "Total mineral value (2000$) in 1931 (mineral production x price for each type)" 
ren min_type mintype31
label var mintype31 "Type of mineral production (diamond, gold, manganese) in 1931" 
sort gridcell
save ghana1, replace
tab year

************
* ALTITUDE *
************

* The GIS file for altitude is available in the folder "GIS_Files_for_Ghana\Geography\Altitude"
* We create in GIS two controlling variables for altitude
* alt_mean: mean altitude (m)
* alt_sd: standard deviation of altitude (m), which we use as a proxy for ruggedness

clear
insheet using altitude.csv
ren descri gridcell
keep gridcell alt_mean alt_sd
label var alt_mean "Altitude: mean (meters)"
label var alt_sd "Altitude: standard deviation (meters)"
sort gridcell
save altitude, replace

***

use ghana1, clear
sort gridcell
merge gridcell using altitude
tab _m
drop _m
sort gridcell
save ghana1, replace
tab year

************
* RAINFALL *
************

* The GIS file for rainfall is available in the folder "GIS_Files_for_Ghana\Geography\rainfall"
* We create in GIS one controlling variable for rainfall
* av_yr_prec: mean precipitations

clear
insheet using rainfall_gridcell.csv
ren descri gridcell
ren avannualprec190060 av_yr_prec 
keep gridcell av_yr_prec
sum av_yr_prec, d
label var av_yr_prec "Annual average precipitations (mms) in 1900-60"
sort gridcell
save rainfall, replace

***

use ghana1, clear
sort gridcell
merge gridcell using rainfall
tab _m
drop _m
sort gridcell
save ghana1, replace
tab year

********************************************
* LONGITUDE / LATITUDE / DISTANCE TO COAST *
********************************************

* The GIS file for coastal cells is available in the folder "GIS_Files_for_Ghana\Geography\Coastal"
* We create in GIS several controlling variables 
* Euclidean distance (km) to the coast
* Longitude and latitude of the cell centroid
* We obtained the longitude and latitude of the cell centroid of each cell using the GIS file of the cell grid available in "GIS_Files_for_Ghana\Grid Cells"

clear
insheet using dist2coast.csv
ren origine gridcell
ren distance_resu dist2coast
keep gridcell dist2coast
label var dist2coast "Euclidean distance (km) to a coastal cell"
sort gridcell
save dist2coast, replace

***

clear
insheet using centroid_coord.csv
ren descri gridcell
ren long_centroid longitude
ren lat_centroid latitude
keep gridcell longitude latitude
label var longitude "Longitude (degrees) of the grid cell centroid"
label var latitude "Latitude (degrees) of the grid cell centroid"
sort gridcell
save longlat, replace

***

use ghana1, clear
sort gridcell
merge gridcell using dist2coast
tab _m
drop _m
sort gridcell
merge gridcell using longlat
tab _m
drop _m
* We create a fourth order polynomial in longitude and latitude 
gen long1 = longitude
gen long2 = longitude*longitude
gen long3 = longitude*longitude*longitude
gen long4 = longitude*longitude*longitude*longitude
gen lat1 = latitude
gen lat2 = latitude*latitude
gen lat3 = latitude*latitude*latitude
gen lat4 = latitude*latitude*latitude*latitude
label var long1 "Longitude"
label var long2 "Longitude x Longitude"
label var long3 "Longitude x Longitude x Longitude"
label var long4 "Longitude x Longitude x Longitude x Longitude"
label var lat1 "Latitude"
label var lat2 "Latitude x Latitude"
label var lat3 "Latitude x Latitude x Latitude"
label var lat4 "Latitude x Latitude x Latitude x Latitude"
sort gridcell
save ghana1, replace
tab year

*************************************
* DISTANCE TO PORT / STARTING POINTS *
*************************************

* We create in GIS several controlling variables 
* Euclidean distance (km) to a main port in 1901
* Euclidean distance (km) to a port in 1901
* Euclidean distance (km) to Accra
* Euclidean distance (km) to Kumasi
* Euclidean distance (km) to Aburi

* The GIS files for the two main ports or any port are available in "GIS_Files_for_Ghana\Other_Transportation_Networks\Port_1901"
clear
insheet using dist2port.csv
ren origine gridcell
ren distance_resu dist2port
keep gridcell dist2port
label var dist2port "Euclidean distance (km) to main port in 1901 (Accra, Sekondi-Takoradi)"
sort gridcell
save dist2port, replace
clear
insheet using dist2port1901.csv
ren origine gridcell
ren distance_resu dist2port_any
keep gridcell dist2port
label var dist2port "Euclidean distance (km) to a port in 1901"
sort gridcell
save dist2port_any, replace

* The GIS files for Accra, Kumasi and Aburi are available in "GIS_Files_for_Ghana\Geography\Accra_Kumasi_Aburi"
clear
insheet using dist2accra.csv
ren origine gridcell
ren distance_resu dist2accra
keep gridcell dist2accra
label var dist2accra "Euclidean distance (km) to Accra"
sort gridcell
save dist2accra, replace
clear
insheet using dist2kumasi.csv
ren origine gridcell
ren distance_resu dist2kumasi
keep gridcell dist2kumasi
label var dist2kumasi "Euclidean distance (km) to Kumasi"
sort gridcell
save dist2kumasi, replace
clear
insheet using dist2aburi.csv
ren origine gridcell
ren distance_resu dist2aburi
keep gridcell dist2aburi
label var dist2aburi "Euclidean distance (km) to Aburi"
sort gridcell
save dist2aburi, replace

use ghana1, clear
sort gridcell
merge gridcell using dist2accra
tab _m
drop _m
sort gridcell
merge gridcell using dist2kumasi
tab _m
drop _m
sort gridcell
merge gridcell using dist2aburi
tab _m
drop _m
sort gridcell
merge gridcell using dist2port
tab _m
drop _m
sort gridcell
merge gridcell using dist2port_any
tab _m
drop _m
save ghana1, replace
tab year

************************************************
* INFORMATION ON OTHER TRANSPORTATION NETWORKS *
************************************************

* We also have some data on other transportation networks: rivers, trade routes in 1850, roads in 1901, 1931, 1960 and 2000
* We add this data to the main data set
* We create these variables in GIS

*************************
* INFORMATION ON RIVERS *
*************************

* The GIS files for the rivers is available in "GIS_Files_for_Ghana\Other_Transportation_Networks\Rivers"
* We create the following controlling variable:
* Euclidean distance (km) to a navigable river
clear
insheet using "rivers.csv", delimiter(",")
label var dist2river "Euclidean distance (km) to a river"
sort gridcell
save dist2river, replace

use ghana1, clear
sort gridcell 
merge gridcell using dist2river
tab _m
drop _m 
save ghana1, replace

************************************
* INFORMATION ON TRADE ROUTES 1850 *
************************************

* The GIS file for the tarde routes in 1850 is available in "GIS_Files_for_Ghana\Other_Transportation_Networks\Historical_Routes_1850"
* We create the following controlling variable:
* We obtain in GIS a map of historical trade routes in 1850 (these routes were old slave routes)
clear
insheet using trade_routes1850_cells.csv
ren descri gridcell
gen traderoute = 1
label var traderoute "Cell crossed by an old slave trade route (c.1850)"
bysort gridcell: keep if _n == 1
keep gridcell traderoute
sort gridcell
save trade_routes1850, replace

***

use ghana1, clear
sort gridcell
merge gridcell using trade_routes1850
replace traderoute = 0 if traderoute == .
tab _m
drop _m
sort gridcell
save ghana1, replace

**************************************
* INFORMATION ON ROADS 1901 AND 1931 *
**************************************

* The GIS files for the roads in 1901-1931 are available in "GIS_Files_for_Ghana\Other_Transportation_Networks\Roads\Roads_1901_1931_1960_2000\1901-1931"
clear
insheet using "roads_1901_1931.csv"
sort gridcell
save roads_1901_1931, replace

use ghana1, clear
sort gridcell 
merge gridcell using roads_1901_1931
tab _m
drop _m 
label var class3_1901 "Cell contains a class 3 road in 1901"
label var class1_1931 "Cell contains a class 1 road in 1931"
label var class2_1931 "Cell contains a class 2 road in 1931"
label var class3_1931 "Cell contains a class 3 road in 1931"
sort gridcell
save ghana1, replace

**************************************
* INFORMATION ON ROADS 1960 AND 2000 *
**************************************

* The GIS files for the roads in 1960-2000 are available in "GIS_Files_for_Ghana\Other_Transportation_Networks\Roads\Roads_1901_1931_1960_2000\1960-2000"
clear
insheet using "roads_1960_2000.csv"
sort gridcell
save roads_1960_2000, replace

use ghana1, clear
sort gridcell 
merge gridcell using roads_1960_2000
tab _m
drop _m 
label var paved_1960 "Cell contains a paved road in 1960"
label var improved_1960 "Cell contains an improved road in 1960"
label var earthern_1960 "Cell contains a dirt road in 1960"
label var paved_2000 "Cell contains a paved road in 2000"
label var improved_2000 "Cell contains an improved road in 2000"
label var earthern_2000 "Cell contains a dirt road in 2000"
sort gridcell
save ghana1, replace

***********************************************************
* ADDITIONAL INFORMATION ON OTHER TRANSPORTATION NETWORKS *
***********************************************************

* In GIS, we obtain the Euclidean distance of the cell centroid to the various alternative transportation networks 
clear
insheet using "distance_other_transp.csv"
keep gridcell dist2traderoute dist2class3_1901 dist2paved_2000 dist2improved_2000 dist2class* *_1960
sort gridcell
save distance_other_transp, replace

use ghana1, clear
sort gridcell 
merge gridcell using distance_other_transp
tab _m
drop _m 
label var dist2traderoute "Euclidean distance (km) to a trade route in 1850"
label var dist2class3_1901 "Euclidean distance (km) to a class 3 road in 1901"
label var dist2class3_1931 "Euclidean distance (km) to a class 3 road in 1931"
label var dist2class2_1931 "Euclidean distance (km) to a class 2 road in 1931"
label var dist2class1_1931 "Euclidean distance (km) to a class 1 road in 1931"
label var dist2paved_1960 "Euclidean distance (km) to a paved road in 1960"
label var dist2improved_1960 "Euclidean distance (km) to an improved road in 1960"
label var dist2paved_2000 "Euclidean distance (km) to a paved road in 2000"
label var dist2improved_2000 "Euclidean distance (km) to an improved road in 2000"
* We then create various dummies we will be using when studying general equilibrium effects
gen route1850 = (dist2traderoute <= 10)
replace route1850= 0 if year == 1901
gen route1850_forest = 0
replace route1850_forest = route1850 if forest ==1
gen route1850_rest = 0
replace route1850_rest = route1850 if forest ==0
gen route1901 = (dist2class3_1901 <= 10)
replace route1901= 0 if year == 1901
gen route1901_forest = 0
replace route1901_forest = route1901 if forest ==1
gen route1901_rest = 0
replace route1901_rest = route1901 if forest ==0
label var route1850 "Cell within 10 km from a trade route in 1850"
label var route1850_forest "Cell within 10 km from a trade route in the forest area in 1850"
label var route1850_res "Cell within 10 km from a trade route in the non-forest area in 1850"
label var route1901 "Cell within 10 km from a class 3 road in 1901"
label var route1901_forest "Cell within 10 km from a class 3 road in the forest area in 1901"
label var route1901_res "Cell within 10 km from a class 3 road in the non-forest area in 1901"
* We also need these variables for the analysis of long-term urban growth
gen paved_2000_10 = (dist2paved_2000 <= 10)
gen improved_2000_10 = (dist2improved_2000 <= 10)
gen paved_1960_10 = (dist2paved_1960 <= 10)
gen improved_1960_10 = (dist2improved_1960 <= 10)
gen class3_1901_10 = (dist2class3_1901 <= 10)
gen class3_1931_10 = (dist2class3_1931 <= 10)
gen class2_1931_10 = (dist2class2_1931 <= 10)
gen class1_1931_10 = (dist2class1_1931 <= 10)
gen dist2traderoute10 = (dist2traderoute <= 10)              
label var paved_2000_10 "Cell within 10 km from a paved road in 2000"
label var improved_2000_10 "Cell within 10 km from an improved road in 2000"
label var paved_1960_10 "Cell within 10 km from a paved road in 1960"
label var improved_1960_10 "Cell within 10 km from an improved road in 1960"
label var class3_1901_10 "Cell within 10 km from a class 3 road in 1901"
label var class3_1931_10 "Cell within 10 km from a class 3 road in 1931"
label var class2_1931_10 "Cell within 10 km from a class 2 road in 1931"
label var class1_1931_10 "Cell within 10 km from a class 1 road in 1931"
label var dist2traderoute10 "Cell within 10 km from a trade route in 1850"
sort gridcell
save ghana1, replace

****************************************************
* INFORMATION ON NON-TRANSPORTATION INFRASTRUCTURE *
****************************************************

* We also have some data on non-transportation infrastructure, schools and health centers mostly, in 1901, 1931 and 2000
* We add this data to the main grid data set

**************************************************
* INFORMATION ON INFRASTRUCTURE IN 1901 AND 1931 *
**************************************************

* The GIS files for the schools, health centers and churches are available in "GIS_Files_for_Ghana\Infrastructure\Colonial"
* We have data on schools, health centers and churches in 1901 and 1931
clear
insheet using "schools_1901.csv"
collapse (sum) gvt nongvt, by(gridcell)
sort gridcell
save schools_1901, replace

clear
insheet using "schools_1931.csv"
collapse (sum) gvt nongvt, by(gridcell)
sort gridcell
save schools_1931, replace

clear
insheet using "health_1901_1931.csv"
collapse (max) eurohosp_1901-afrihosp_1931, by(gridcell)
sort gridcell
save health_centers_1901_1931, replace

clear
insheet using "church.csv"
sort gridcell
save church_1901_1931, replace

***

use ghana1, clear
sort gridcell
merge gridcell using schools_1901
tab _m
drop _m
sort gridcell
merge gridcell using schools_1931
tab _m
drop _m
sort gridcell
merge gridcell using health_centers_1901_1931
tab _m
drop _m
sort gridcell
merge gridcell using church_1901_1931
tab _m
drop _m
foreach X of varlist gvt1901-afrihosp_1931 church* {
replace `X' = 0 if `X' == .
}
label var gvt1901 "Number of government schools in the cell in 1901"
label var gvt1931 "Number of government schools in the cell in 1931"
label var nongvt1901 "Number of non-government schools in the cell in 1901"
label var nongvt1931 "Number of non-government schools in the cell in 1931"
label var eurohosp_1901 "Number of European hospitals in the cell in 1901"
label var afrihosp_1901 "Number of African hospitals in the cell in 1901"
label var afridisp_1901 "Number of African dispensaries in the cell in 1901"
label var eurohosp_1931 "Number of European hospitals in the cell in 1931"
label var afrihosp_1931 "Number of African hospitals in the cell in 1931"
label var afridisp_1931 "Number of African dispensaries in the cell in 1931"
gen school1901 = gvt1901+nongvt1901 
gen school1931 = gvt1931+nongvt1931 
label var school1901 "Number of schools in the cell in 1901"
label var school1931 "Number of schools in the cell in 1931"
gen hosp_1931 = (afrihosp_1931 == 1 | eurohosp_1931 == 1)
gen hosp_1901 = (afrihosp_1901 == 1 | eurohosp_1901 == 1)
label var hosp_1931 "Dummy equal to one if there is a hospital in the cell in 1931"
label var hosp_1901 "Dummy equal to one if there is a hospital in the cell in 1901"
label var church_num1901 "Number of churches in the cell in 1901"
label var church_num1931 "Number of churches in the cell in 1931"
label var church_yn1901 "Dummy equal to one if there is a church in the cell in 1901"
label var church_yn1931 "Dummy equal to one if there is a church in the cell in 1931"
gen school1901_yn = (school1901 >= 1 & school1901 != .)
gen school1931_yn = (school1931 >= 1 & school1931 != .)
label var school1901_yn "Dummy equal to one if there is a school in the cell in 1901"
label var school1931_yn "Dummy equal to one if there is a school in the cell in 1931"
sort gridcell
save ghana1, replace
tab year

*******************************************
* INFRASTRUCTURE 2000 *
*******************************************

* We use the main data set of the 2000 Facility Census of Ghana, which shows the list of localities in the country and their infrastructure for the census year 2000
* DATA SET FOR WHICH WE DO NOT OWN THE COPYRIGHT (the word document "Copyright".doc in the folder "Regressions for Ghana" describes how we got access to the data and how you can yourself access the data): This data set was given to us by the Ghanaian Statistical Services: http://www.statsghana.gov.gh/. Our contact then was Dr Grace Bediako, who was the Government Statistician. Dr Grace Bediako has since then left GSS. You can talk to the person who has replaced her by contacting the Data Service Unit at GSS.
* We do not include the primary data set of the facility census among the replication files. 
* Instead, we have included the list of localities with their infrastructure 2000 and the gridcell they belong to. This should help you understand how we create the data.

* (1) For 8,407 of them, we easily found the geographical coordinates (using GeoNet) and were thus able to obtain the cell they belong to. 
* This data set is called infra_2000_a

* (2) For the other localities, we could not find easily the geographical coordinates. 
* But we know their enumeration area (N = 27,305), and the geographical coordinates of the centroid of the enumeration area (EA). 
* Given that these EAs are small, most of them belong to one gridcell only. However, we know the area of each EA in each cell. We can thus use the population of each EA and the share of each EA in each cell to reconstruct the population of each cell for these specific localities.
* This data set is called infra_2000_b
* This second data set is thus subject to measurement errors. However, we assume these errors are exogenous. Additonally, the localities of the second data set only account for 3.9% of total population. The first data set thus accounts for 96.1% of total population. This minimizes measurement errors. 

* (1) infra_2000_a - data set of localities for which we know the exact geographical coordinates
clear
insheet using "infra_2000_a.csv"
count
* 8,407 localities
collapse (sum) *_num, by(gridcell)
foreach X in post tel hosp clinic primary jss sss {
ren `X'_num  `X'_num_1
}
sort gridcell
save infra_2000_a, replace

* (2) infra_2000_b - data set of localities for which we use the geographical coordinates of the enumeration area
clear
insheet using "infra_2000_b.csv"
count
* 27,305 EAs
* The data is at the EA-gridcell level.
* Since we know the gridcell, we can reconstruct the total population of these localities for each gridcell  
collapse (sum) *_num, by(gridcell)
foreach X in post tel hosp clinic primary jss sss {
ren `X'_num  `X'_num_2
}
sort gridcell
sort gridcell
save infra_2000_b, replace

* We merge this information with the main data base
use ghana1, clear
keep if year == 2000
keep gridcell year pop
sort gridcell
sort gridcell
merge gridcell using infra_2000_a
tab _m
drop _m
sort gridcell
merge gridcell using infra_2000_b
tab _m
drop _m
foreach X in post tel hosp clinic primary jss sss {
gen `X'_num = `X'_num_1 + `X'_num_2
}
keep gridcell year *_num pop
collapse (sum) *_num pop, by(gridcell)
count
foreach X in post tel hosp clinic primary jss sss {
gen `X'_sh = `X'_num/pop*100
}
keep gridcell *_sh
sort gridcell
save infra_2000_all, replace

use ghana1, clear
sort gridcell 
merge gridcell using infra_2000_all
tab _m
drop _m 
label var post_sh "Share of inhabitants (%) less than 5 km from a post office"
label var tel_sh "Share of inhabitants (%) less than 5 km from a telephone"
label var hosp_sh "Share of inhabitants (%) less than 5 km from a hospital"
label var clinic_sh "Share of inhabitants (%) less than 5 km from a clinic"
label var primary_sh "Share of inhabitants (%) less than 5 km from a primary school"
label var jss_sh "Share of inhabitants (%) less than 5 km from a junior secondary school"
label var sss_sh "Share of inhabitants (%) less than 5 km from a senior secondary school"
sort gridcell
save ghana1, replace

****************
* NIGHT LIGHTS *
****************

* The GIS files for satellite night lights is available in "GIS_Files_for_Ghana\Night_Lights"
* We create this data set using the raw night light data at the pixel level
clear
insheet using "night_lights.csv"
* We have one observation that is out of the sample 
* It is unlikely to affect the estimates, we leave it as it is
sort gridcell
save lights, replace

use ghana1, clear
sort gridcell 
merge gridcell using lights
tab _m
drop _m 
label var avmean "Average night light intensity in the cell (from 0 to 55)"
save ghana1, replace

**********************************
* REORGANIZATION OF THE DATA SET *
**********************************

* We make sure the data is properly organized and all the variables are properly labeled
use ghana1, clear
order gridcell year longitude latitude long1-long4 lat1-lat4 area_sqkm ethnic province district rail18_10 rail18_20 rail18_30 rail18_40 rail18_1020-rail18_7080 rail18w* rail1856 railstat* tk* hvk* ccpk* sok* apamok* aok* kpong* placebo* iv_40 iv_node iv_node_neighbor dist2line18 dist2east18 dist2west18 dist2line1823 dist2line2331 dist2linepost18 dist2stat* dist2apam dist2aok dist2ccp dist2sok dist2kpong dist2iv cocoa_prod27 cocoastat_18 upop upop_1891-upop_1960 upop_1970 upop_1984 upop_2000 upop1666-upop20000 upop5000_2000 upop2000_2000 rpop rpop_1901 rpop_1931 rpop_1970 rpop_2000 pop pop_1931 pop_1970 pop_1984 pop_2000 urbrate urbrate01 lcocoaprod lupop lpop avmean2000 induserv_sh map08_yn kumasi forest city_yn city_yn_1891 city_yn_1901 city_1901 city_1901_forest city_1901_rest coastal coastal_forest coastal_rest route1850 route1850_forest route1850_rest route1901 route1901_forest route1901_rest mincell31 minvalue31 mintype31 minprod31 suitable highsuit vhighsuit share_suitable share_highsuit share_vhighsuit alt_mean alt_sd av_yr_prec border sea dist2coast dist2port dist2port_any dist2river dist2accra dist2kumasi dist2aburi traderoute-class3_1931 paved_1960 improved_1960 earthern_1960 paved_2000 improved_2000 earthern_2000 dist2traderoute10 class3_1901_10 class1_1931_10 class2_1931_10 class3_1931_10 improved_1960_10 paved_1960_10 improved_2000_10 paved_2000_10 dist2traderoute-dist2improved_2000 school1901* school1931* gvt1901* gvt1931* nongvt1901* nongvt1931* hosp_1931 hosp_1901 eurohosp* afrihosp* afridisp* church*1901* church*1931* primary_sh jss_sh sss_sh clinic_sh hosp_sh post_sh tel_sh solid* good_water* literate* educ* 
*desc
save ghana1, replace
* "ghana1.dta" is the data set we use for the regressions
* use "regressions_ghana.do" to recreate all the tables and some of the figures

*********************************************************

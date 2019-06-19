cd "C:\Users\jedwab\Desktop\Regressions_for_Africa"
* This determines the folder used for the analysis 


********************************
* DATA CONSTRUCTION FOR AFRICA *
********************************

* This do-file ("data_construction_africa.do") creates the main data set for the regressions on Africa: "africa1.dta"
* This data set was built independently of the Ghana data set. 

********************************************************************************************


*********************************************************************
* CREATION OF THE GRID DATA SET (194,000 CELLS OF 0.1 x 0.1 DEGREE) * 
*********************************************************************

* We first create the main grid data set

* The GIS file for the grid cells is available in the folder "GIS_Files_for_Africa\Grid Cells"
* The csv file contains the list of 194,000 grid cells and the country they belong to
clear
insheet using "gridcell.csv"
label var gridcell "Grid cell"
label var country "Country (N = 39)"
label var longitude "Longitude"
label var latitude "Latitude"
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
save africa1, replace

*******************************************
* INFORMATION ON COASTAL AND RIVER ACCESS * 
*******************************************

* The GIS files for the coast and the navigable rivers are available in the folders "GIS_Files_for_Africa\Geography\Coast" and "GIS_Files_for_Africa\Geography\Rivers"
* We create various variables measuring coastal access and river access
clear
insheet using "coast_river.csv"
sort country gridcell
save coast_river, replace

use africa1, clear
sort country gridcell
merge country gridcell using coast_river 
tab _m
drop _m
label var dist2coast "Euclidean distance to the coast (km)"
label var dist2river "Euclidean distance to navigable river (km)"
gen coast_10 = (dist2coast >= 0 & dist2coast <= 10)
gen river_10 = (dist2river >= 0 & dist2river <= 10)
label var coast_10 "Dummy equal to one if cell within 10 km from the coast"
label var river_10 "Dummy equal to one if cell within 10 km from a navigable river coast"
sort gridcell
save africa1, replace

**********************************************
* INFORMATION ON ETHNIC GROUPS AND DISTRICTS * 
**********************************************

* The GIS file for the ethnic groups is available in the folder "GIS_Files_for_Africa\Ethnic Groups and Districts\Ethnic_Groups"
* The csv file shows the ethnic group to which the cells mainly belong (here defined in terms of area)
* We use the ethnic group boundaries of Murdock
clear
insheet using "ethnic.csv"
ren v1 gridcell
ren v2 ethnic
codebook ethnic
* 755 ethnic groups
sort gridcell
save ethnic, replace

* The csv file shows the district to which the cells mainly belong (here defined in terms of area)
* We use the district boundaries (N = 109) for the year 2000
clear
insheet using "district.csv"
ren v1 gridcell
ren v2 country
ren v3 district 
codebook district 
* 2,304 districts
sort country gridcell
save district, replace

use africa1, clear
sort gridcell
merge gridcell using ethnic, update
tab _m
drop if _m == 2
drop _m
sort country gridcell
merge country gridcell using district, update
tab _m
drop if _m == 2
drop _m
ren district district2000
codebook ethnic district2000
label var ethnic "Dominant ethnic group (N = 755) in the cell"
label var district2000 "Dominant district (N = 2,304) in the cell"
sort gridcell
save africa1, replace

****************************
* INFORMATION ON RAILROADS *
****************************

* The GIS file for the railroads is available in the folder "GIS_Files_for_Africa\Railroads\Built"
* We create the variables measuring railroad access
clear
insheet using "railroads.csv"
sort country gridcell
save railroads, replace

use africa1, clear
sort country gridcell
merge country gridcell using railroads
tab _m
drop _m
gen rail60_10 = (dist2rail60 >= 0 & dist2rail60 <= 10)
gen rail60_1020 = (dist2rail60 > 10 & dist2rail60 <= 20)
gen rail60_2030 = (dist2rail60 > 20 & dist2rail60 <= 30)
gen rail60_3040 = (dist2rail60 > 30 & dist2rail60 <= 40)
gen rail60_4050 = (dist2rail60 > 40 & dist2rail60 <= 50)
gen rail60_5060 = (dist2rail60 > 50 & dist2rail60 <= 60)
label var dist2rail60 "Euclidean distance (km) to a railroad line in 1960"
label var rail60_10 "Cell within 10 km from a railroad line in 1960"
label var rail60_1020 "Cell within 10-20 km from a railroad line in 1960"
label var rail60_2030 "Cell within 20-30 km from a railroad line in 1960"
label var rail60_3040 "Cell within 30-40 km from a railroad line in 1960"
label var rail60_4050 "Cell within 40-50 km from a railroad line in 1960"
label var rail60_5060 "Cell within 50-60 km from a railroad line in 1960"
gen rail60mil_10 = (dist2rail60mil >= 0 & dist2rail60mil <= 10)
gen rail60min_10 = (dist2rail60min >= 0 & dist2rail60min <= 10)
egen rail60miln_10 = rmax(rail60mil_10 rail60min_10)
gen rail60ot_10 = (rail60_10 == 1 & rail60miln_10 == 0)
label var dist2rail60mil "Euclidean distance (km) to a railroad line in 1960 built for military domination"
label var dist2rail60min "Euclidean distance (km) to a railroad line in 1960 built for mining"
label var rail60mil_10 "Cell within 10 km from a line in 1960 built for military domination"
label var rail60min_10 "Cell within 10 km from a line in 1960 built for mining"
label var rail60miln_10 "Cell within 10 km from a line in 1960 built for military domination or mining"
label var rail60miln_10 "Cell within 10 km from a line in 1960 built for other reasons"
sort gridcell
save africa1, replace

********************************
* INFORMATION ON PLACEBO LINES *
********************************

* The GIS file for the placebo railroads is available in the folder "GIS_Files_for_Africa\Railroads\Placebo"
* We create the variables measuring placebo railroad access
clear
insheet using "placebo.csv"
sort country gridcell
save placebo, replace

use africa1, clear
sort country gridcell
merge country gridcell using placebo
tab _m
drop _m
label var dist2placebo16 "Euclidean distance (km) to a placebo line in 1916"
label var dist2placebo22 "Euclidean distance (km) to a placebo line in 1922"
gen railplac16_10 = (dist2placebo16 >= 0 & dist2placebo16 <= 10)
gen railplac22_10 = (dist2placebo22 >= 0 & dist2placebo22 <= 10)
egen railplac1622_10 = rmax(railplac16_10 railplac22_10)
label var railplac16_10 "Cell within 10 km from a placebo line in 1916"
label var railplac22_10 "Cell within 10 km from a placebo line in 1922"
label var railplac1622_10 "Cell within 10 km from a placebo line in 1916-1922"
sort gridcell
save africa1, replace

***************************************
* INFORMATION ON RAILROAD CONNECTIONS *
***************************************

* We also create a variable with the year of connection of each railroad cell during the 1890-1960 period
* We recreated this variable in GIS using the GIS file in the folder "GIS_Files_for_Africa\Railroads\Built"
clear
insheet using "year_reached.csv"
sort country gridcell
save year_reached, replace

use africa1, clear
sort country gridcell
merge country gridcell using year_reached
tab _m
drop if _m == 2
drop _m
replace year_reach = 0 if year_reached == .
label var year_reached "Year the cell was connected to a railroad line in 1960 (0 if not)"
gen pre1918 = (year_reached <= 1918 & year_reached != 0)
gen period1845 = (year_reached > 1918 & year_reached <= 1945 & year_reached != 0)
gen post1945 = (year_reached > 1945 & year_reached != 0)
label var pre1918 "Dummy equal to one if the cell was connected before 1918"
label var period1845 "Dummy equal to one if the cell was connected between 1918 and 1945"
label var post1945 "Dummy equal to one if the cell was connected after 1945"
sort gridcell
save africa1, replace

*********************************
* INFORMATION ON NODES AND EMST *
*********************************

* The GIS files for the nodes and Euclidean Minimum Spanning Tree (EMST) network that was created using standard GIS tools are available in the folder "C:\Users\jedwab\Desktop\GIS_Files_for_Africa\Railroads\EMST_Lines" 
clear
insheet using "dist2emst.csv"
sort country gridcell
save dist2emst, replace

* We also created a dummy equal to one if the cell contained a node or a neighboring cell
clear
insheet using "nodes_and_neighbors.csv"
sort gridcell
save nodes_and_neighbors, replace

use africa1, clear
sort country gridcell
merge country gridcell using dist2emst
tab _m
drop if _m == 2
drop _m
gen iv_emst = (dist2emst <= 40)
label var dist2emst "Euclidean distance to the Euclidean Minimum Spanning Tree (EMST)"
label var iv_emst "Dummy equal to one if the cell is less than 40 km from the EMST"
sort gridcell
merge gridcell using nodes_and_neighbors
tab _m
drop if _m == 2
drop _m
replace node_neighbor = 0 if node_neighbor == .
label var node_neighbor "Dummy equal to one if the cell is a node or a neighbor of a node"
sort gridcell
save africa1, replace

*************************
* INFORMATION ON CITIES *
*************************

* The GIS files of the cities larger than 10,000 inhabitants (population = 0 is below 10,000) in 1890 and 1900 are available in the folder "GIS_Files_for_Africa\Cities"
* Please note that we do not have enough information of the cities of Nigeria in 1890
* The GIS files of the cities larger than 10,000 inhabitants for 6 countries in 1960, 1970, 1980, 1990, 2000 and 2010 are available in the same folder
* DATA FOR WHICH WE DO NOT HAVE COPYRIGHT (the word document COPYRIGHT.DOC in the folder "Regressions for Africa" describes how we got access to the data and you can yourself access the data): For the 33 other African countries, we use the GIS data base from Africapolis (2010) and Africapolis (2012). This data does not belong us but we received the authorization to use their data. However, we are not allowed to show the GIS data for these 33 countries. Some of the data is available online at: http://www.e-geopolis.eu/rubrique69.html. The e-mail address at which the team of Geopolis (and thus Africapolis) can be contacted is: contact@e-geopolis.fr

* The csv file "cities_africa.csv" has the list of localities larger than 10,000 inhabitants at one point and their population for each year (when it is larger than 10,000 inhabitants)
* Since this raw data set contains the information for which we do not have the copyright, we did not include it among our replication files
* Here are the commands that allow us to recreate the data from the raw file.
*clear
*insheet using "cities_africa.csv"
* We recreate total urban population for each cell
*collapse (sum) pop*, by(country gridcell)
*sort country gridcell
*save cities, replace

use africa1, clear
sort country gridcell
merge country gridcell using cities
tab _m
* There is no urban population in the cells with no _m = 1
drop _m
foreach X of varlist pop1890_10-pop2010_10 {
replace `X' = 0 if `X' == .
}
foreach X of numlist 1890 1900 1960 1970 1980 1990 2000 2010 {
label var pop`X'_10 "Total urban population (localities > 10,000 inh.) of the cell in `X'" 
}
gen city_yn1890 = (pop1890_10 >= 10000)
gen city_yn1900 = (pop1900_10 >= 10000)
gen city_yn1960 = (pop1960_10 >= 10000)
gen city_yn2010 = (pop2010_10 >= 10000)
foreach X of numlist 1890 1900 1960 2010 {
label var city_yn`X' "Dummy equal to one if there is a city in the cell in `X'" 
}
sort gridcell
save africa1, replace

* We also created the urban population in 1960 and 2010 using other thresholds than 10,000
* For the year 1960:
clear
insheet using "cities_cutoffs_1960.csv"
sort country gridcell
save cities_cutoffs_1960, replace
* For the year 2010:
clear
insheet using "cities_cutoffs_2010.csv"
sort country gridcell
save cities_cutoffs_2010, replace
* We merge the data sets
use africa1, clear
sort country gridcell
merge country gridcell using cities_cutoffs_1960
tab _m
drop _m
foreach X of varlist pop1960_15-pop1960_50 {
replace `X' = 0 if `X' == .
}
foreach X of numlist 15 20 22 50 {
label var pop1960_`X' "Total urban population (localities > `X',000 inh.) of the cell in 1960" 
}
label var pop1960_17322 "Total urban population (localities > 17,322 inh.) of the cell in 1960" 
save africa1, replace

use africa1, clear
sort country gridcell
merge country gridcell using cities_cutoffs_2010
tab _m
drop _m

foreach X of varlist pop2010_15-pop2010_83 {
replace `X' = 0 if `X' == .
}
foreach X of numlist 15 20 50 83 {
label var pop2010_`X' "Total urban population (localities > `X',000 inh.) of the cell in 2010" 
}
label var pop2010_31763 "Total urban population (localities > 31,763 inh.) of the cell in 2010" 
sort gridcell
save africa1, replace

***********************************************************************
* INFORMATION ON THE FIRST LARGEST, SECOND LARGEST AND CAPITAL CITIES *
***********************************************************************

* We create the variables measuring whether the cell contains the largest city, the second largest city or the capital city of each country, as well as the Euclidean distances to these cities
clear
insheet using "first_second_capital.csv"
sort country gridcell
save first_second_capital, replace

use africa1, clear
sort country gridcell
merge country gridcell using first_second_capital
tab _m
drop _m
label var first "The cell contains the first largest city of the country"
label var second "The cell contains the second largest city of the country"
label var capital "The cell contains the capital city of the country"
label var dist2first "Euclidean distance (km) to the first largest city"
label var dist2second "Euclidean distance (km) to the second largest city"
label var dist2capital "Euclidean distance (km) to the capital city"
sort gridcell
save africa1, replace

****************************
* INFORMATION ON ALTITUDE *
****************************

* The GIS file for the altitude measure is available in the folder "Geography\Altitude"
* We create various measures of altitude (the mean of altitude) and ruggedness (the standard deviation of altitude) at the cell level
clear
insheet using "altitude.csv"
sort country gridcell
save altitude, replace

use africa1, clear
sort country gridcell
merge country gridcell using altitude
tab _m
drop _m
label var alt_mean "Mean altitude (m)"
label var alt_std "Standard deviation of altitude (m)"
sort gridcell
save africa1, replace

***************************
* INFORMATION ON RAINFALL *
***************************

* The GIS file for the rainfall measure is available in the folder "Geography\Rainfall"
* We create a measure of rainfall at the cell level
* The rainfall measure is the average of annual precipitations (mm) in 1900-1960.
clear
insheet using "rainfall.csv"
sort country gridcell
save rainfall, replace

use africa1, clear
sort country gridcell
merge country gridcell using rainfall
tab _m
drop _m
label var prec_mean "Average annual precipitations (mm) in 1900-1960"
sort gridcell
save africa1, replace

***********************************
* INFORMATION ON SOIL SUITABILITY *
***********************************

* The GIS file for the soil suitability measure is available in the folder "Geography\Soil Suitability"
* We create various measures of soil suitability at the cell level
clear
insheet using "soil_suitability.csv"
sort country gridcell
save suitability, replace

use africa1, clear
sort country gridcell
merge country gridcell using suitability
tab _m
drop _m
label var class1 "Share of class 1 soils in the cell"
label var class2 "Share of class 2 soils in the cell"
label var class3 "Share of class 3 soils in the cell"
label var undetermined "Share of undetermined soils in the cell"
label var water "Share of water bodies in the cell"
label var sparseveg "Share of sparsely vegetated soils in the cell"
sort gridcell
save africa1, replace

************************
* INFORMATION ON MINES *
************************

* We create a dummy equal to one if a 0-10 km railroad cell contains an open or closed mine 
* The data was created manually in excel
clear
insheet using "mines_africa.csv"
sort gridcell
save mines_africa, replace

use africa1, clear
sort gridcell
merge gridcell using mines_africa
tab _m
drop _m
replace mine = 0 if mine == .
label var mine "Dummy equal to one if there is a mine in the 0-10 km railroad cell"
save africa1, replace

************************
* INFORMATION ON ROADS *
************************

* The GIS data set of roads in 2000 is available in the folder "C:\Users\jedwab\Desktop\GIS_Files_for_Africa\Roads"
* We create various measures of road access in 2000
* In particular, we know the location of paved roads and improved roads in 2000
clear
insheet using "roads.csv"
sort country gridcell
save roads_africa, replace

use africa1, clear
sort country gridcell
merge country gridcell using roads_africa
tab _m
drop _m
label var dist2paved "Euclidean distance (km) to a paved road in 2000"
label var dist2impr "Euclidean distance (km) to an improved road in 2000"
gen paved_10 = (dist2paved >= 0 & dist2paved <= 10)
gen impr_10 = (dist2impr >= 0 & dist2impr <= 10)
label var paved_10 "Cell within 10 km from a paved road in 2000"
label var impr_10 "Cell within 10 km from an improved road in 2000"
sort country gridcell
save africa1, replace

*******************************
* INFORMATION ON NIGHT LIGHTS *
*******************************

* The GIS data set of night lights in 2010 is available in the folder "GIS_Files_for_Africa\Lights"
* We recreate the mean night light intensity for each cell in 2010
clear
insheet using "lights.csv"
sort country gridcell
save lights_africa, replace

use africa1, clear
sort country gridcell
merge country gridcell using lights_africa
tab _m
drop _m
label var mean2010 "Mean night light intensity in 2010 (0-63)"
sort country gridcell
save africa1, replace

*** "africa1.dta" is the main data set that we use for the analysis on Africa ***
*** "regressions_for_africa.do" is the do-file that allows us to recreate the results, the tables and some of the figures ***


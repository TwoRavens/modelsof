cd "C:\Users\jedwab\Desktop\Regressions_for_Africa"
* This determines the folder used for the analysis 


**************************
* REGRESSIONS FOR AFRICA *
**************************

*** "africa1.dta" is the main data set that we use for the analysis on Africa ***
*** This data set was created using the do-file "data_construction_africa.do"
*** "regressions_for_africa.do" is the do-file that allows us to recreate the results, the tables and some of the figures ***

*************************************************************************************************


*************************************
* TABLE 3 IDENTIFICATION STRATEGIES *
*************************************

use africa1, clear
* We drop the largest city, the second largest city and the caputal city of each country, as these ciies may have grown for political reasons.
drop if first == 1 | second == 1 | capital == 1
* We then create the standard scores of urban population in 1900 and 1960
egen pop1960_10std = std(pop1960_10)
egen pop1900_10std = std(pop1900_10)

*** PANEL D: DEPENDENT VARIABLE = URBAN POPULATION (Z-SCORE) IN 1960, AFRICA ***

* COLUMN (1): OLS (with the four rail dummies, but we only show the effect of the 0-10 rail dummy, because there are no effects beyond)
xi: reg pop1960_10std rail60_10 rail60_1020 rail60_2030 rail60_3040 pop1900_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg i.country, robust cluster(district2000)
outreg2 rail60_10 rail60_1020 rail60_2030 rail60_3040 using table3d.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) replace

* COLUMN (2): 755 ETHNIC GROUP FIXED EFFECTS
xi: areg pop1960_10std rail60_10 pop1900_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water i.country class1 class2 class3 water undetermined sparseveg i.country, absorb(ethnic) robust cluster(district2000)
outreg2 rail60_10 using table3d.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* COLUMN (3): 2.304 DISTRICT FIXED EFFECTS (2000)
xi: areg pop1960_10std rail60_10 pop1900_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water i.country class1 class2 class3 water undetermined sparseveg i.country, absorb(district2000) robust cluster(district2000)
outreg2 rail60_10 using table3d.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* COLUMN (4): FIRST, SECOND, THIRD AND FOURTH ORDER POLYNOMIAL IN LONGITUDE AND LATITUDE 
xi: areg pop1960_10std rail60_10 pop1900_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water long1 long2 long3 long4 lat1 lat2 lat3 lat4 class1 class2 class3 water undetermined sparseveg, absorb(country) robust cluster(district2000)
outreg2 rail60_10 using table3d.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* COLUMN (5): LINE BUILT FOR MINING OR MILITARY DOMINATION (EXCLUDING MINE)
areg pop1960_10std rail60miln_10 pop1900_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg if mine == 0, absorb(country) robust cluster(district2000)
outreg2 rail60miln_10 using table3d.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* COLUMN (6): PLACEBO LINES 0-10 KM (1916 AND 1922)
areg pop1960_10std railplac1622_10 pop1900_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg, absorb(country) robust cluster(district2000)
outreg2 railplac1622_10 using table3d.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* COLUMN (7): USING THE PLACEBO LINES 0-10 KM AS A CONTROL GROUP
areg pop1960_10std rail60_10 pop1900_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg if (rail60_10 == 1 | railplac1622_10 == 1), absorb(country) robust cluster(district2000)
outreg2 rail60_10 using table3d.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* COLUMN (8): IV, EXCLUDING THE NODES 
* change z-score before

use africa1, clear
* We drop the largest city, the second largest city and the capital city of each country, as these cities may have grown for political reasons.
* We also drop the existing cities in 1900
* This allows us to drop the nodes used to construct the Euclidean Minimum Spanning Tree network
drop if first == 1 | second == 1 | capital == 1 | city_yn1900 == 1
* We then create the standard scores of urban population in 1900 and 1960
egen pop1960_10std = std(pop1960_10)
egen pop1900_10std = std(pop1900_10)

xi: ivreg2 pop1960_10std (rail60_10 = iv_emst) coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg i.country, robust cluster(district2000) first
outreg2 rail60_10 using table3d.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

******************************************************************
* TABLE 7: COLONIAL RAILROADS AND URBAN GROWTH, AFRICA 1900-2010 *
******************************************************************

use africa1, clear
* We drop the largest city, the second largest city and the caputal city of each country, as these ciies may have grown for political reasons.
drop if first == 1 | second == 1 | capital == 1
* We then create the standard scores of urban population in 1900, 1960 and 2010
egen pop2010_10std = std(pop2010_10)
egen pop1960_10std = std(pop1960_10)
egen pop1900_10std = std(pop1900_10)
egen city_yn2010std = std(city_yn2010)

* COLUMN (1): BASELINE REGRESSION
reg pop2010_10std rail60_10 rail60_1020 rail60_2030 rail60_3040 pop1900_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg, robust cluster(district2000)
outreg2 rail60_10 rail60_1020 rail60_2030 rail60_3040 pop1900_10std using table7.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) replace

* COLUMN (2): EFFECT DEPENDING ON PERIOD OF "CONNECTION" 
reg pop2010_10std rail60_10 rail60_1020 rail60_2030 rail60_3040 pre1918 period1845 pop1900_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg, robust cluster(district2000)
outreg2 rail60_10 rail60_1020 rail60_2030 rail60_3040 pre1918 period1845 pop1900_10std using table7.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* COLUMN (3): ALSO CONTROLLING FOR ROADS IN 2000
reg pop2010_10std rail60_10 rail60_1020 rail60_2030 rail60_3040 pre1918 period1845 paved_10 impr_10 pop1900_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg, robust cluster(district2000)
outreg2 rail60_10 rail60_1020 rail60_2030 rail60_3040 pre1918 period1845 paved_10 impr_10 pop1900_10std using table7.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* COLUMN (4): ALSO CONTROLLING FOR URBAN POPULATION IN 1960
reg pop2010_10std rail60_10 rail60_1020 rail60_2030 rail60_3040 pre1918 period1845 pop1960_10std paved_10 impr_10 pop1900_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg, robust cluster(district2000)
outreg2 rail60_10 rail60_1020 rail60_2030 rail60_3040 pre1918 period1845 paved_10 impr_10 pop1960_10std pop1900_10std using table7.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* COLUMN (5): CITY 1/0
reg city_yn2010std rail60_10 rail60_1020 rail60_2030 rail60_3040 pre1918 period1845 pop1960_10std paved_10 impr_10 pop1900_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg, robust cluster(district2000)
outreg2 rail60_10 rail60_1020 rail60_2030 rail60_3040 pre1918 period1845 paved_10 impr_10 pop1960_10std pop1900_10std using table7.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* COLUMN (6): NIGHT LIGHTS, ALSO CONTROLLING FOR URBAN POPULATION IN 2010
reg mean2010 rail60_10 rail60_1020 rail60_2030 rail60_3040 pre1918 period1845 pop1960_10std paved_10 impr_10 pop1900_10std pop2010_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg, robust cluster(district2000)
outreg2 rail60_10 rail60_1020 rail60_2030 rail60_3040 pre1918 period1845 paved_10 impr_10 pop1960_10std pop1900_10std pop2010_10std using table7.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

************
* FIGURE 5 *
************

* We first obtain the coefficients for each period. 
use africa1, clear
* We drop the largest city, the second largest city and the caputal city of each country, as these ciies may have grown for political reasons.
drop if first == 1 | second == 1 | capital == 1
* We then create the standard scores of urban population in all years
egen pop2010_10std = std(pop2010_10)
egen pop2000_10std = std(pop2000_10)
egen pop1990_10std = std(pop1990_10)
egen pop1980_10std = std(pop1980_10)
egen pop1970_10std = std(pop1970_10)
egen pop1960_10std = std(pop1960_10)
egen pop1900_10std = std(pop1900_10)
egen pop1890_10std = std(pop1890_10)

* We exclude Nigeria for the 1890-1900 period, as we do not have enough information on its cities in 1890.
areg pop1900_10std rail60_10 rail60_1020 rail60_2030 rail60_3040 pop1890_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water if country != "Nigeria", absorb(country) robust cluster(country)
outreg2 rail60_10 rail60_1020 rail60_2030 rail60_3040 pop*_10std using figure5_af.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) replace

areg pop1960_10std rail60_10 rail60_1020 rail60_2030 rail60_3040 pop1900_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water, absorb(country) robust cluster(country)
outreg2 rail60_10 rail60_1020 rail60_2030 rail60_3040 pop*_10std using figure5_af.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

areg pop1970_10std rail60_10 rail60_1020 rail60_2030 rail60_3040 pop1960_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water, absorb(country) robust cluster(country)
outreg2 rail60_10 rail60_1020 rail60_2030 rail60_3040 pop*_10std using figure5_af.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

areg pop1980_10std rail60_10 rail60_1020 rail60_2030 rail60_3040 pop1970_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water, absorb(country) robust cluster(country)
outreg2 rail60_10 rail60_1020 rail60_2030 rail60_3040 pop*_10std using figure5_af.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

areg pop1990_10std rail60_10 rail60_1020 rail60_2030 rail60_3040 pop1980_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water, absorb(country) robust cluster(country)
outreg2 rail60_10 rail60_1020 rail60_2030 rail60_3040 pop*_10std using figure5_af.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

areg pop2000_10std rail60_10 rail60_1020 rail60_2030 rail60_3040 pop1990_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water, absorb(country) robust cluster(country)
outreg2 rail60_10 rail60_1020 rail60_2030 rail60_3040 pop*_10std using figure5_af.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

areg pop2010_10std rail60_10 rail60_1020 rail60_2030 rail60_3040 pop2000_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water, absorb(country) robust cluster(country)
outreg2 rail60_10 rail60_1020 rail60_2030 rail60_3040 pop*_10std using figure5_af.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* Using figure5_af.xls, we create "data_for_figure_5.xls" using excel
* This excel file shows the coefficient of the 0-10 km dummy and the coefficient of Ut-1
clear
import excel "data_for_figure_5.xls", sheet("stata") firstrow
* select the effects for Africa only
keep if af10 != .
replace yearnum = 2 if yearnum == 4
replace yearnum = 3 if yearnum == 5
replace yearnum = 4 if yearnum == 6
replace yearnum = 5 if yearnum == 7
replace yearnum = 6 if yearnum == 8
replace yearnum = 7 if yearnum == 9
* We first create the figure as best as possible
twoway (line af10 yearnum, lcolor(gs7) lwidth(medthick)) (connected aflag yearnum, yaxis(2) mcolor(gs9) msize(medium) msymbol(circle) lcolor(gs9) lwidth(medthick) lpattern(dash)) (connected af10 yearnum, mcolor(black) msize(medlarge) msymbol(circle) lcolor(black) lwidth(thick) lpattern(solid)), ytitle(Railroad Effect) ytitle(, size(large) margin(small)) ylabel(0(0.2)0.40) ymtick(0(0.2)0.40, nolabels) xtitle(.) xtitle(, size(zero)) xlabel(1(1)7) legend(order(1 "Coefficient of Railroad 0-10 km" 2 "Coefficient of Ut-1") rows(1) span) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
graph export figure5_af.png, replace width(2620) height(1908)
* We then use graph editor to improve the figure on Africa
* We then use paint to create one figure out of the figure on Ghana and the figure on Africa

************
* FIGURE 6 *
************

* We run the main regression, country by country, for the countries that received a railroad by 1960
* We obtain the coefficient of the 0-10 km railroad dummy for each country and report it manually in the excel file "africa_urbanization.xls" 
* The excel file already contains the urbanization rate of each country (defined using the 10,000 populatio threshold) in 1900 and 1960
* We then use this excel file to recreate Figure 6

** Angola **

use africa1, clear
keep if country == "Angola"
* We drop the largest city, the second largest city and the caputal city of each country, as these ciies may have grown for political reasons.
drop if first == 1 | second == 1 | capital == 1
* We then create the standard scores of urban population in 1900 and 1960
egen pop1960_10std = std(pop1960_10)
egen pop1900_10std = std(pop1900_10)
* Angola did not have cities in 1900, so we do not control for pop1900_10std
reg pop1960_10std rail60_10 coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg, robust cluster(district2000)

** Benin **

use africa1, clear
keep if country == "Benin"
* We drop the largest city, the second largest city and the caputal city of each country, as these ciies may have grown for political reasons.
drop if first == 1 | second == 1 | capital == 1
* We then create the standard scores of urban population in 1900 and 1960
egen pop1960_10std = std(pop1960_10)
egen pop1900_10std = std(pop1900_10)
reg pop1960_10std rail60_10 pop1900_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg, robust cluster(district2000)

** Botswana **

use africa1, clear
keep if country == "Botswana"
* We drop the largest city, the second largest city and the caputal city of each country, as these ciies may have grown for political reasons.
drop if first == 1 | second == 1 | capital == 1
* We then create the standard scores of urban population in 1900 and 1960
egen pop1960_10std = std(pop1960_10)
egen pop1900_10std = std(pop1900_10)
reg pop1960_10std rail60_10 pop1900_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg, robust cluster(district2000)

** Burkina-Faso **

use africa1, clear
keep if country == "Burkina"
* We drop the largest city, the second largest city and the caputal city of each country, as these ciies may have grown for political reasons.
drop if first == 1 | second == 1 | capital == 1
* We then create the standard scores of urban population in 1900 and 1960
egen pop1960_10std = std(pop1960_10)
egen pop1900_10std = std(pop1900_10)
* Burkina did not have cities in 1900, so we do not control for pop1900_10std
reg pop1960_10std rail60_10 coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg, robust cluster(district2000)

** Cameroon **

use africa1, clear
keep if country == "Cameroon"
* We drop the largest city, the second largest city and the caputal city of each country, as these ciies may have grown for political reasons.
drop if first == 1 | second == 1 | capital == 1
* We then create the standard scores of urban population in 1900 and 1960
egen pop1960_10std = std(pop1960_10)
egen pop1900_10std = std(pop1900_10)
reg pop1960_10std rail60_10 pop1900_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg, robust cluster(district2000)

** Congo **

use africa1, clear
keep if country == "Congo"
* We drop the largest city, the second largest city and the caputal city of each country, as these ciies may have grown for political reasons.
drop if first == 1 | second == 1 | capital == 1
* We then create the standard scores of urban population in 1900 and 1960
egen pop1960_10std = std(pop1960_10)
egen pop1900_10std = std(pop1900_10)
* Congo did not have cities in 1900, so we do not control for pop1900_10std
reg pop1960_10std rail60_10 coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg, robust cluster(district2000)

** Eritrea **

use africa1, clear
keep if country == "Eritrea"
* We drop the largest city, the second largest city and the caputal city of each country, as these ciies may have grown for political reasons.
drop if first == 1 | second == 1 | capital == 1
* We then create the standard scores of urban population in 1900 and 1960
egen pop1960_10std = std(pop1960_10)
egen pop1900_10std = std(pop1900_10)
reg pop1960_10std rail60_10 pop1900_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg, robust cluster(district2000)

** Ethiopia **

use africa1, clear
keep if country == "Ethiopia"
* We drop the largest city, the second largest city and the caputal city of each country, as these ciies may have grown for political reasons.
drop if first == 1 | second == 1 | capital == 1
* We then create the standard scores of urban population in 1900 and 1960
egen pop1960_10std = std(pop1960_10)
egen pop1900_10std = std(pop1900_10)
reg pop1960_10std rail60_10 pop1900_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg, robust cluster(district2000)

** Ghana **

use africa1, clear
keep if country == "Ghana"
* We drop the largest city, the second largest city and the caputal city of each country, as these ciies may have grown for political reasons.
drop if first == 1 | second == 1 | capital == 1
* We then create the standard scores of urban population in 1900 and 1960
egen pop1960_10std = std(pop1960_10)
egen pop1900_10std = std(pop1900_10)
reg pop1960_10std rail60_10 pop1900_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg, robust cluster(district2000)

** Guinea **

use africa1, clear
keep if country == "Guinea"
* We drop the largest city, the second largest city and the caputal city of each country, as these ciies may have grown for political reasons.
drop if first == 1 | second == 1 | capital == 1
* We then create the standard scores of urban population in 1900 and 1960
egen pop1960_10std = std(pop1960_10)
egen pop1900_10std = std(pop1900_10)
reg pop1960_10std rail60_10 pop1900_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg, robust cluster(district2000)

** Ivory Coast **

use africa1, clear
keep if country == "Ivory Coast"
* We drop the largest city, the second largest city and the caputal city of each country, as these ciies may have grown for political reasons.
drop if first == 1 | second == 1 | capital == 1
* We then create the standard scores of urban population in 1900 and 1960
egen pop1960_10std = std(pop1960_10)
egen pop1900_10std = std(pop1900_10)
* Ivory Coast did not have cities in 1900, so we do not control for pop1900_10std
reg pop1960_10std rail60_10 coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg, robust cluster(district2000)

** Kenya **

use africa1, clear
keep if country == "Kenya"
* We drop the largest city, the second largest city and the caputal city of each country, as these ciies may have grown for political reasons.
drop if first == 1 | second == 1 | capital == 1
* We then create the standard scores of urban population in 1900 and 1960
egen pop1960_10std = std(pop1960_10)
egen pop1900_10std = std(pop1900_10)
* Kenya did not have cities in 1900, so we do not control for pop1900_10std
reg pop1960_10std rail60_10 coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg, robust cluster(district2000)

** Malawi **

use africa1, clear
keep if country == "Malawi"
* We drop the largest city, the second largest city and the caputal city of each country, as these ciies may have grown for political reasons.
drop if first == 1 | second == 1 | capital == 1
* We then create the standard scores of urban population in 1900 and 1960
egen pop1960_10std = std(pop1960_10)
egen pop1900_10std = std(pop1900_10)
* Malawi did not have cities in 1900, so we do not control for pop1900_10std
reg pop1960_10std rail60_10 coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg, robust cluster(district2000)

** Mali **

use africa1, clear
keep if country == "Mali"
* We drop the largest city, the second largest city and the caputal city of each country, as these ciies may have grown for political reasons.
drop if first == 1 | second == 1 | capital == 1
* We then create the standard scores of urban population in 1900 and 1960
egen pop1960_10std = std(pop1960_10)
egen pop1900_10std = std(pop1900_10)
* Mali did not have cities in 1900, so we do not control for pop1900_10std
reg pop1960_10std rail60_10 coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg, robust cluster(district2000)

** Mozambique **

use africa1, clear
keep if country == "Mozambique"
* We drop the largest city, the second largest city and the caputal city of each country, as these ciies may have grown for political reasons.
drop if first == 1 | second == 1 | capital == 1
* We then create the standard scores of urban population in 1900 and 1960
egen pop1960_10std = std(pop1960_10)
egen pop1900_10std = std(pop1900_10)
* Mozambique did not have cities in 1900, so we do not control for pop1900_10std
reg pop1960_10std rail60_10 coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg, robust cluster(district2000)

** Nigeria **

use africa1, clear
keep if country == "Nigeria"
* We drop the largest city, the second largest city and the caputal city of each country, as these ciies may have grown for political reasons.
drop if first == 1 | second == 1 | capital == 1
* We then create the standard scores of urban population in 1900 and 1960
egen pop1960_10std = std(pop1960_10)
egen pop1900_10std = std(pop1900_10)
reg pop1960_10std rail60_10 pop1900_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg, robust cluster(district2000)

** Senegal **

use africa1, clear
keep if country == "Senegal"
* We drop the largest city, the second largest city and the caputal city of each country, as these ciies may have grown for political reasons.
drop if first == 1 | second == 1 | capital == 1
* We then create the standard scores of urban population in 1900 and 1960
egen pop1960_10std = std(pop1960_10)
egen pop1900_10std = std(pop1900_10)
reg pop1960_10std rail60_10 pop1900_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg, robust cluster(district2000)

** Sierra Leone **

use africa1, clear
keep if country == "Sierra Leone"
* We drop the largest city, the second largest city and the caputal city of each country, as these ciies may have grown for political reasons.
drop if first == 1 | second == 1 | capital == 1
* We then create the standard scores of urban population in 1900 and 1960
egen pop1960_10std = std(pop1960_10)
egen pop1900_10std = std(pop1900_10)
* Sierra Leone did not have cities in 1900, so we do not control for pop1900_10std
reg pop1960_10std rail60_10 coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg, robust cluster(district2000)

** Somalia **

use africa1, clear
keep if country == "Somalia"
* We drop the largest city, the second largest city and the caputal city of each country, as these ciies may have grown for political reasons.
drop if first == 1 | second == 1 | capital == 1
* We then create the standard scores of urban population in 1900 and 1960
egen pop1960_10std = std(pop1960_10)
egen pop1900_10std = std(pop1900_10)
reg pop1960_10std rail60_10 pop1900_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg, robust cluster(district2000)

** Sudan **

use africa1, clear
keep if country == "Sudan"
* We drop the largest city, the second largest city and the caputal city of each country, as these ciies may have grown for political reasons.
drop if first == 1 | second == 1 | capital == 1
* We then create the standard scores of urban population in 1900 and 1960
egen pop1960_10std = std(pop1960_10)
egen pop1900_10std = std(pop1900_10)
reg pop1960_10std rail60_10 pop1900_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg, robust cluster(district2000)

** Tanzania **

use africa1, clear
keep if country == "Tanzania"
* We drop the largest city, the second largest city and the caputal city of each country, as these ciies may have grown for political reasons.
drop if first == 1 | second == 1 | capital == 1
* We then create the standard scores of urban population in 1900 and 1960
egen pop1960_10std = std(pop1960_10)
egen pop1900_10std = std(pop1900_10)
reg pop1960_10std rail60_10 pop1900_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg, robust cluster(district2000)

** Togo **

use africa1, clear
keep if country == "Togo"
* We drop the largest city, the second largest city and the caputal city of each country, as these ciies may have grown for political reasons.
drop if first == 1 | second == 1 | capital == 1
* We then create the standard scores of urban population in 1900 and 1960
egen pop1960_10std = std(pop1960_10)
egen pop1900_10std = std(pop1900_10)
* Togo did not have cities in 1900, so we do not control for pop1900_10std
reg pop1960_10std rail60_10 coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg, robust cluster(district2000)

** Uganda **

use africa1, clear
keep if country == "Uganda"
* We drop the largest city, the second largest city and the caputal city of each country, as these ciies may have grown for political reasons.
drop if first == 1 | second == 1 | capital == 1
* We then create the standard scores of urban population in 1900 and 1960
egen pop1960_10std = std(pop1960_10)
egen pop1900_10std = std(pop1900_10)
* Uganda did not have cities in 1900, so we do not control for pop1900_10std
reg pop1960_10std rail60_10 coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg, robust cluster(district2000)

** Zaire **

use africa1, clear
keep if country == "Zaire"
* We drop the largest city, the second largest city and the caputal city of each country, as these ciies may have grown for political reasons.
drop if first == 1 | second == 1 | capital == 1
* We then create the standard scores of urban population in 1900 and 1960
egen pop1960_10std = std(pop1960_10)
egen pop1900_10std = std(pop1900_10)
* Zaire did not have cities in 1900, so we do not control for pop1900_10std
reg pop1960_10std rail60_10 coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg, robust cluster(district2000)

** Zambia **

use africa1, clear
keep if country == "Zambia"
* We drop the largest city, the second largest city and the caputal city of each country, as these ciies may have grown for political reasons.
drop if first == 1 | second == 1 | capital == 1
* We then create the standard scores of urban population in 1900 and 1960
egen pop1960_10std = std(pop1960_10)
egen pop1900_10std = std(pop1900_10)
* Zambia did not have cities in 1900, so we do not control for pop1900_10std
reg pop1960_10std rail60_10 coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg, robust cluster(district2000)

** Zimbabwe **

use africa1, clear
keep if country == "Zimbabwe"
* We drop the largest city, the second largest city and the caputal city of each country, as these ciies may have grown for political reasons.
drop if first == 1 | second == 1 | capital == 1
* We then create the standard scores of urban population in 1900 and 1960
egen pop1960_10std = std(pop1960_10)
egen pop1900_10std = std(pop1900_10)
* Zimbabwe did not have cities in 1900, so we do not control for pop1900_10std
reg pop1960_10std rail60_10 coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg, robust cluster(district2000)

* We now create Figure 6 *

clear
import excel "africa_urbanization.xls", sheet("Feuil1") firstrow clear
label var country "Country"
label var upop1900_10 "Total urban population of the country in 1900"
label var upop1960_10 "Total urban population of the country in 1960"
label var pop1900 "Total population of the country in 1900"
label var pop1960 "Total population of the country in 1960"
label var urbrate1900 "Urbanization rate (%) of the country in 1900"
label var urbrate1960 "Urbanization rate (%) of the country in 1960"
label var chg_urbrate "Change in the urbanization rate between 1900 and 1960"
label var rail_yn "Dummy equal to one if the country has received a railroad between 1900 and 1960"
label var rail_effect "0-10 km railroad effect (estimated using the main regression)"
twoway (scatter chg_urbrate rail_effect if rail_yn == 1, mcolor(black) msize(medium) msymbol(circle) mlabel(country) mlabsize(medsmall) mlabcolor(black)) (lfit chg_urbrate rail_effect if rail_yn == 1), ytitle(Change in Urbanization Rate (Pct. Points)) xtitle(Country-Specific Railroad Effect (0-10 km)) legend(off)
* The graph is manually edited using graph editor
graph export figure6d.png, replace width(2620) height(1908)

******************
* WEB APPENDICES *
******************

********************************************************************************************************************************
* WEB APPENDIX TABLE 13: COLONIAL RAILROADS AND URBAN GROWTH, IDENTIFICATION AND GENERAL EQUILIBRIUM EFFECTS, AFRICA 1900-1960 *
********************************************************************************************************************************

use africa1, clear
* We drop the largest city, the second largest city and the caputal city of each country, as these ciies may have grown for political reasons.
drop if first == 1 | second == 1 | capital == 1
* We then create the standard scores of urban population in 1900 and 1960
egen pop1960_10std = std(pop1960_10)
egen pop1900_10std = std(pop1900_10)
egen city_yn1960std = std(city_yn1960)

* (1) Military
areg pop1960_10std rail60mil_10 pop1900_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg, absorb(country) robust cluster(district2000)
outreg2 rail60mil_10 using table_A13.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) replace

* (2) Mining (excluding the mines)
areg pop1960_10std rail60min_10 pop1900_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg if mine == 0, absorb(country) robust cluster(district2000)
outreg2 rail60min_10 using table_A13.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (3) Other lines
areg pop1960_10std rail60ot_10 pop1900_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg, absorb(country) robust cluster(district2000)
outreg2 rail60ot_10 using table_A13.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (4) Placebo 1916
areg pop1960_10std railplac16_10 pop1900_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg, absorb(country) robust cluster(district2000)
outreg2 railplac16_10 using table_A13.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (5) Placebo 1922
areg pop1960_10std railplac22_10 pop1900_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg, absorb(country) robust cluster(district2000)
outreg2 railplac22_10 using table_A13.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (6) Placebo 1916 as the control group
areg pop1960_10std rail60_10 pop1900_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg if (rail60_10 == 1 | railplac16_10 == 1), absorb(country) robust cluster(district2000)
outreg2 rail60_10 using table_A13.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (7) Placebo 1922 as the control group
areg pop1960_10std rail60_10 pop1900_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg if (rail60_10 == 1 | railplac22_10 == 1), absorb(country) robust cluster(district2000)
outreg2 rail60_10 using table_A13.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (8) OLS City 1/0
xi: reg city_yn1960std rail60_10 coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg i.country if country != "Ghana", robust cluster(district2000)
outreg2 rail60_10 using table_A13.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

** Test of the general equilibrium effects **

* X km, Drop if Rail < X km = 1

use africa1, clear
* We drop the largest city, the second largest city and the caputal city of each country, as these ciies may have grown for political reasons.
drop if first == 1 | second == 1 | capital == 1
* We then create the standard scores of urban population in 1900 and 1960
egen pop1960_10std = std(pop1960_10)
egen pop1900_10std = std(pop1900_10)

* (9) 10-20 km
drop if rail60_10 == 1
xi: reg pop1960_10std rail60_1020 pop1900_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg i.country, robust cluster(district2000)
outreg2 rail60_1020 using table_A13.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (10) 20-30 km
drop if rail60_1020 == 1
xi: reg pop1960_10std rail60_2030 pop1900_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg i.country, robust cluster(district2000)
outreg2 rail60_2030 using table_A13.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (11) 30-40 km
drop if rail60_2030 == 1
xi: reg pop1960_10std rail60_3040 pop1900_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg i.country, robust cluster(district2000)
outreg2 rail60_3040 using table_A13.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (12) 40-50 km
drop if rail60_3040 == 1
xi: reg pop1960_10std rail60_4050 pop1900_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg i.country, robust cluster(district2000)
outreg2 rail60_4050 using table_A13.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (13) 50-60 km
drop if rail60_4050 == 1
xi: reg pop1960_10std rail60_5060 pop1900_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg i.country, robust cluster(district2000)
outreg2 rail60_5060 using table_A13.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* Other cells with a city or access to transportation before the rail *

use africa1, clear
* We drop the largest city, the second largest city and the caputal city of each country, as these ciies may have grown for political reasons.
drop if first == 1 | second == 1 | capital == 1
* We then create the standard scores of urban population in 1900 and 1960
egen pop1960_10std = std(pop1960_10)
egen pop1900_10std = std(pop1900_10)
drop if rail60_10 == 1

* (14) City 1900
xi: reg pop1960_10std rail60_10 rail60_1020 rail60_2030 rail60_3040 city_yn1900 pop1900_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg i.country, robust cluster(district2000)
outreg2  city_yn1900 using table_A13.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (15) City 1890 (Excludes Nigeria because no information on these cities)
xi: reg pop1960_10std rail60_10 rail60_1020 rail60_2030 rail60_3040 city_yn1890 pop1900_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg i.country if country != "Nigeria", robust cluster(district2000)
outreg2  city_yn1890 using table_A13.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (16) Coastal
xi: reg pop1960_10std rail60_10 rail60_1020 rail60_2030 rail60_3040 pop1900_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg i.country, robust cluster(district2000)
outreg2 coast_10 using table_A13.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

*********************************************************************************
* WEB APPENDIX TABLE 14: ROBUSTNESS AND SPECIFICATION CHECKS, AFRICA, 1900-1960 *
*********************************************************************************

use africa1, clear
* We drop the largest city, the second largest city and the caputal city of each country, as these ciies may have grown for political reasons.
drop if first == 1 | second == 1 | capital == 1
* We then create the standard scores of urban population in 1900 and 1960
egen pop1960_10std = std(pop1960_10)
egen pop1900_10std = std(pop1900_10)

* (1) Baseline 
xi: reg pop1960_10std rail60_10 pop1900_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg i.country, robust cluster(district2000)
outreg2 rail60_10 using table_A14.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) replace

* (2) No controls
xi: reg pop1960_10std rail60_10 pop1900_10std i.country, robust cluster(district2000)
outreg2 rail60_10 using table_A14.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (3) No nodes and no neihbors - change standardization

use africa1, clear
* We drop the largest city, the second largest city and the caputal city of each country, as these ciies may have grown for political reasons.
drop if first == 1 | second == 1 | capital == 1
drop if node_neighbor == 1
* We then create the standard scores of urban population in 1900 and 1960
egen pop1960_10std = std(pop1960_10)
egen pop1900_10std = std(pop1900_10)

xi: reg pop1960_10std rail60_10 pop1900_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg i.country, robust cluster(district2000)
outreg2 rail60_10 using table_A14.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (4) Distance (expressed in 100 km)

use africa1, clear
* We drop the largest city, the second largest city and the caputal city of each country, as these ciies may have grown for political reasons.
drop if first == 1 | second == 1 | capital == 1
* We then create the standard scores of urban population in 1900 and 1960
egen pop1960_10std = std(pop1960_10)
egen pop1900_10std = std(pop1900_10)

replace dist2rail60 = dist2rail60/100
xi: reg pop1960_10std dist2rail60 pop1900_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg i.country, robust cluster(district2000)
outreg2 dist2rail60 using table_A14.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (5) Panel 

use africa1, clear
* We drop the largest city, the second largest city and the caputal city of each country, as these ciies may have grown for political reasons.
drop if first == 1 | second == 1 | capital == 1
* We then create the standard scores of urban population in 1900 and 1960
egen pop1960_10std = std(pop1960_10)
egen pop1900_10std = std(pop1900_10)
save africa2, replace 

use africa1, clear
* We drop the largest city, the second largest city and the caputal city of each country, as these ciies may have grown for political reasons.
drop if first == 1 | second == 1 | capital == 1
* We then create the standard scores of urban population in 1900 and 1960
egen pop1960_10std = std(pop1960_10)
egen pop1900_10std = std(pop1900_10)
gen year = 1900
append using africa2
replace year = 1960 if year == .
gen upop = pop1960_10std if year == 1960
replace upop = pop1900_10std if year == 1900
gen gridcell2 = country+gridcell
replace rail60_10 = 0 if year == 1900

xi: areg upop rail60_10 i.country*i.year i.year|coast_10 i.year|dist2coast i.year|river_10 i.year|dist2river i.year|first i.year|second i.year|capital i.year|dist2first i.year|dist2capital i.year|dist2second i.year|alt_mean i.year|alt_std i.year|prec_mean i.year|water i.year|class1 i.year|class2 i.year|class3 i.year|water i.year|undetermined i.year|sparseveg i.country, absorb(gridcell2) robust cluster(district2000)
outreg2 rail60_10 using table_A14.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (6) Change

use africa1, clear
* We drop the largest city, the second largest city and the caputal city of each country, as these ciies may have grown for political reasons.
drop if first == 1 | second == 1 | capital == 1
* We then create the standard scores of urban population in 1900 and 1960
egen pop1960_10std = std(pop1960_10)
egen pop1900_10std = std(pop1900_10)


bysort gridcell: gen pop_1960_std_chg =  pop1960_10std - pop1900_10std
xi: reg pop_1960_std_chg rail60_10 coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg i.country, robust cluster(district2000)
outreg2 rail60_10 using table_A14.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (7) Normalization
foreach X in pop1960_10 pop1900_10 {
egen `X'_av = mean(`X')
gen `X'_bh = `X'/`X'_av
}
xi: reg pop1960_10_bh rail60_10 pop1900_10_bh coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg i.country, robust cluster(district2000)
outreg2 rail60_10 using table_A14.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (8) Change normalization, Black and Henderson (1999)
bysort gridcell: gen pop1960_10_bh_chg = pop1960_10_bh - pop1900_10_bh
xi: reg pop1960_10_bh_chg rail60_10 coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg i.country, robust cluster(district2000)
outreg2 rail60_10 using table_A14.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (9) Log
foreach X in pop1960_10 pop1900_10 {
gen l`X' = log(`X'+1)
}
xi: reg lpop1960_10 rail60_10 lpop1900_10 coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg i.country, robust cluster(district2000)
outreg2 rail60_10 using table_A14.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (10) Log-Log
gen ldist2rail60 = log(dist2rail60)
xi: reg lpop1960_10 ldist2rail60 lpop1900_10 coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg i.country, robust cluster(district2000)
outreg2 ldist2rail60 using table_A14.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (11) SE clustered at the country level
xi: reg pop1960_10std rail60_10 pop1900_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg i.country, robust cluster(country)
outreg2 rail60_10 using table_A14.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (12) Conley SE (100 km)
*run gls_sptl.005.do
*gls_sptl pop1960_10std rail60_10 : pop1900_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg _Icountry_2-_Icountry_39, sptlcoef(1) crdlst(latitude longitude) cut(100) 
* This regression takes a long time
* We report the coefficient manually in the table

***************************************************************************
* WEB APPENDIX TABLE 15: USE OF VARIOUS CITY THRESHOLDS, AFRICA 1900-2010 *
***************************************************************************

use africa1, clear
* We drop the largest city, the second largest city and the caputal city of each country, as these ciies may have grown for political reasons.
drop if first == 1 | second == 1 | capital == 1
* We then create the standard scores of urban population in 1900 and 1960
egen pop1960_10std = std(pop1960_10)
egen pop1900_10std = std(pop1900_10)
egen pop1960_17322std = std(pop1960_17322)
egen pop1960_22std = std(pop1960_22)
egen pop1960_15std = std(pop1960_15)
egen pop1960_20std = std(pop1960_20)
egen pop1960_50std = std(pop1960_50)
egen pop2010_10std = std(pop2010_10)
egen pop2010_31763std = std(pop2010_31763)
egen pop2010_83std = std(pop2010_83)
egen pop2010_15std = std(pop2010_15)
egen pop2010_20std = std(pop2010_20)
egen pop2010_50std = std(pop2010_50)

*** Panel A: Dependent Variable: Urban Population (Z-Score) in 1960 ***

* (1) 10,000
xi: reg pop1960_10std rail60_10 pop1900_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg i.country, robust cluster(district2000)
outreg2 rail60_10 using table_A15.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) replace

* (2) 17,322
xi: reg pop1960_17322std rail60_10 pop1900_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg i.country, robust cluster(district2000)
outreg2 rail60_10 using table_A15.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (3) 22,000
xi: reg pop1960_22std rail60_10 pop1900_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg i.country, robust cluster(district2000)
outreg2 rail60_10 using table_A15.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (4) 15,000
xi: reg pop1960_15std rail60_10 pop1900_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg i.country, robust cluster(district2000)
outreg2 rail60_10 using table_A15.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (5) 20,000
xi: reg pop1960_20std rail60_10 pop1900_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg i.country, robust cluster(district2000)
outreg2 rail60_10 using table_A15.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (6) 50,000
xi: reg pop1960_50std rail60_10 pop1900_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg i.country, robust cluster(district2000)
outreg2 rail60_10 using table_A15.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

*** Panel B: Dependent Variable: Urban Population (Z-Score) in 2010 ***

* (1) 10,000
xi: reg pop2010_10std rail60_10 pop1900_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg i.country, robust cluster(district2000)
outreg2 rail60_10 using table_A15.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (2) 31,763
xi: reg pop2010_31763std rail60_10 pop1900_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg i.country, robust cluster(district2000)
outreg2 rail60_10 using table_A15.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (3) 83,000
xi: reg pop2010_83std rail60_10 pop1900_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg i.country, robust cluster(district2000)
outreg2 rail60_10 using table_A15.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (4) 15,000
xi: reg pop2010_15std rail60_10 pop1900_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg i.country, robust cluster(district2000)
outreg2 rail60_10 using table_A15.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (5) 20,000
xi: reg pop2010_20std rail60_10 pop1900_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg i.country, robust cluster(district2000)
outreg2 rail60_10 using table_A15.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (6) 50,000
xi: reg pop2010_50std rail60_10 pop1900_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg i.country, robust cluster(district2000)
outreg2 rail60_10 using table_A15.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

**********************************************************************************************
* WEB APPENDIX TABLE 16: WEB APPENDIX TABLE 16: IDENTIFICATION STRATEGIES, AFRICA, 1900-2010 *
**********************************************************************************************

use africa1, clear
* We drop the largest city, the second largest city and the caputal city of each country, as these ciies may have grown for political reasons.
drop if first == 1 | second == 1 | capital == 1
* We then create the standard scores of urban population in 1900, 1960 and 2010
egen pop2010_10std = std(pop2010_10)
egen pop1960_10std = std(pop1960_10)
egen pop1900_10std = std(pop1900_10)
egen city_yn2010std = std(city_yn2010)

* (1) Baseline
xi: reg pop2010_10std rail60_10 rail60_1020 rail60_2030 rail60_3040 pop1900_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg i.country, robust cluster(district2000)
outreg2 rail60_10 using table_A16.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) replace

* (2) Ethnic group FE
xi: areg pop2010_10std rail60_10 pop1900_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water i.country class1 class2 class3 water undetermined sparseveg i.country, absorb(ethnic) robust cluster(district2000)
outreg2 rail60_10 using table_A16.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (3) District FE
xi: areg pop2010_10std rail60_10 pop1900_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water i.country class1 class2 class3 water undetermined sparseveg i.country, absorb(district2000) robust cluster(district2000)
outreg2 rail60_10 using table_A16.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

*  (4) Fourth order poynomial in longituden and latitude
xi: areg pop2010_10std rail60_10 pop1900_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water long1 long2 long3 long4 lat1 lat2 lat3 lat4 class1 class2 class3 water undetermined sparseveg, absorb(country) robust cluster(district2000)
outreg2 rail60_10 using table_A16.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (5) Military or mining line (excluding the mines)
areg pop2010_10std rail60miln_10 pop1900_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg if mine == 0, absorb(country) robust cluster(district2000)
outreg2 rail60miln_10 using table_A16.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (6) Placebo 1916 or 1922
areg pop2010_10std railplac1622_10 pop1900_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg, absorb(country) robust cluster(district2000)
outreg2 railplac1622_10 using table_A16.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (7) Placebo 1916 or 1922 as a control group
areg pop2010_10std rail60_10 pop1900_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg if (rail60_10 == 1 | railplac1622_10 == 1), absorb(country) robust cluster(district2000)
outreg2 rail60_10 using table_A16.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (8) IV - EMST (dropping the EMST nodes)

use africa1, clear
* We drop the largest city, the second largest city and the capital city of each country, as these cities may have grown for political reasons.
* We also drop the existing cities in 1900
* This allows us to drop the nodes used to construct the Euclidean Minimum Spanning Tree network
drop if first == 1 | second == 1 | capital == 1 | city_yn1900 == 1
* We then create the standard scores of urban population in 1900 and 1960
egen pop2010_10std = std(pop2010_10)
egen pop1960_10std = std(pop1960_10)
egen pop1900_10std = std(pop1900_10)

xi: ivreg2 pop2010_10std (rail60_10 = iv_emst) coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg i.country, robust cluster(district2000) first
outreg2 rail60_10 using table_A16.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (9) City 1/0 

use africa1, clear
* We drop the largest city, the second largest city and the caputal city of each country, as these ciies may have grown for political reasons.
drop if first == 1 | second == 1 | capital == 1
* We then create the standard scores of urban population in 1900, 1960 and 2010
egen pop2010_10std = std(pop2010_10)
egen pop1960_10std = std(pop1960_10)
egen pop1900_10std = std(pop1900_10)
egen city_yn2010std = std(city_yn2010)

xi: reg city_yn2010std rail60_10 rail60_1020 rail60_2030 rail60_3040 pop1900_10std coast_10 dist2coast river_10 dist2river first second capital dist2first dist2capital dist2second alt_mean alt_std prec_mean water class1 class2 class3 water undetermined sparseveg i.country, robust cluster(district2000)
outreg2 rail60_10 using table_A16.xls, se nocons coefastr bdec(2) adjr2 noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

************************************************************************************************
* WEB APPENDIX TABLE 17: WEB APPENDIX TABLE 17: SIZE DISTRIBUTION OF CITIES, AFRICA, 1960-2010 *
************************************************************************************************

* See the Readme File in the folder "Tables\Web Appendix Tables\TableA17"

*************************************************************************
* WEB APPENDIX FIGURE 8:  *
*************************************************************************

clear
import excel "africa_ge.xlsx", sheet("stata") firstrow

* Web Appendix Figure 8 - left figure
twoway (connected bairoch_pcgnp year, mcolor(black) msize(medlarge) msymbol(circle) lcolor(black) lwidth(medthick) lpattern(solid)) (connected wr_bwa year, mcolor(gs9) msize(medium) msymbol(square) lcolor(gs9) lwidth(medthick) lpattern(solid)), ytitle(Base 100 in 1890) graphregion(fcolor(white) lcolor(white))
graph export figure_A8left.png, replace width(2620) height(1908)
* We then use graph editor to edit the figure

* Web Appendix Figure 8 - right figure
twoway (connected num_cities year, mcolor(black) msize(medlarge) msymbol(circle) lcolor(black) lwidth(medthick) lpattern(solid)) (connected urbanrate year, yaxis(2) mcolor(gs9) msize(medium) msymbol(square) lcolor(gs9) lwidth(medthick) lpattern(solid)), ytitle(Number of Cities (Loc. > 10,000 Inh.)) legend(order(1 "Number of Cities" 2 "Urbanization Rate (%)")) graphregion(fcolor(white) lcolor(white))
graph export figure_A8right.png, replace width(2620) height(1908)
* We then use graph editor to edit the figure

* We then use paint to merge the two figures and create Web Appendix Figure 8

*************************************************************************
* WEB APPENDIX FIGURE 9: RAIL EFFECTS FOR EACH PERIOD, AFRICA 1891-2000 *
*************************************************************************

use africa1, clear
* We drop the largest city, the second largest city and the caputal city of each country, as these ciies may have grown for political reasons.
drop if first == 1 | second == 1 | capital == 1
* We then create the standard scores of urban population for all years
egen pop2010_10std = std(pop2010_10)
egen pop2000_10std = std(pop2000_10)
egen pop1990_10std = std(pop1990_10)
egen pop1980_10std = std(pop1980_10)
egen pop1970_10std = std(pop1970_10)
egen pop1960_10std = std(pop1960_10)
egen pop1900_10std = std(pop1900_10)
save africa2, replace

use africa1, clear
* We drop the largest city, the second largest city and the caputal city of each country, as these ciies may have grown for political reasons.
drop if first == 1 | second == 1 | capital == 1
egen pop1890_10std = std(pop1890_10)
gen year = 1890
gen upop = pop1890_10std if year == 1890
* add 1900 *
append using africa2
replace year = 1900 if year == .
replace upop = pop1900_10std if year == 1900
* add 1960 *
append using africa2
replace year = 1960 if year == .
replace upop = pop1960_10std if year == 1960
* add 1970 *
append using africa2
replace year = 1970 if year == .
replace upop = pop1970_10std if year == 1970
* add 1980 *
append using africa2
replace year = 1980 if year == .
replace upop = pop1980_10std if year == 1980
* add 1990 *
append using africa2
replace year = 1990 if year == .
replace upop = pop1990_10std if year == 1990
* add 2000 *
append using africa2
replace year = 2000 if year == .
replace upop = pop2000_10std if year == 2000
* add 2010 *
append using africa2
replace year = 2010 if year == .
replace upop = pop2010_10std if year == 2010
gen gridcell2 = country+gridcell
sort gridcell2 year
bysort gridcell2: gen upop_lag = upop[_n-1]
bysort gridcell2: gen upop_chg = upop-upop_lag

foreach X in 1890 1900 1960 1970 1980 1990 2000 2010 {
gen rail18_10_`X' = 0
replace rail18_10_`X' = (dist2rail60>0 & dist2rail60<=10) if year == `X'
gen rail18_1020_`X' = 0
replace rail18_1020_`X' = (dist2rail60>10 & dist2rail60<=20) if year == `X'
gen rail18_2030_`X' = 0
replace rail18_2030_`X' = (dist2rail60>20 & dist2rail60<=30) if year == `X'
gen rail18_3040_`X' = 0
replace rail18_3040_`X' = (dist2rail60>30 & dist2rail60<=40) if year == `X'
}

set matsize 800
xi: areg upop_chg rail18_10_1900 rail18_1020_1900 rail18_2030_1900 rail18_3040_1900 rail18_10_1960 rail18_1020_1960 rail18_2030_1960 rail18_3040_1960 rail18_10_1970 rail18_1020_1970 rail18_2030_1970 rail18_3040_1970 rail18_10_1980 rail18_1020_1980 rail18_2030_1980 rail18_3040_1980 rail18_10_1990 rail18_1020_1990 rail18_2030_1990 rail18_3040_1990 rail18_10_2000 rail18_1020_2000 rail18_2030_2000 rail18_3040_2000 i.year i.year|coast_10 i.year|dist2coast i.year|river_10 i.year|dist2river i.year|first i.year|second i.year|capital i.year|dist2first i.year|dist2capital i.year|dist2second i.year|alt_mean i.year|alt_std i.year|prec_mean i.year|water i.country*i.year if country != "Nigeria", absorb(gridcell2) robust cluster(district2000) 
* We manually export the coefficients of the 0-10 km railroad dummy in the excel file "data_for_figure_A9.xlsx"
* The excel file also shows the coefficients of the 0-10 km railroad dummy for the main regression without cell fixed effects (see Figure 5 in this do-file)

* We now recreate the figure in stata 
* Note that 2010 is the omitted year for thew panel regression with cell fixed effects
clear
import excel "data_for_figure_A9.xlsx", sheet("Sheet1") firstrow
drop if year == .
twoway (connected af10 year, lcolor(black) lwidth(medthick)) (connected af10_FE year, lcolor(gs9) lwidth(medthick) lpattern(dash)), ytitle(Railroad Effect) ytitle(, size(large) margin(small)) ylabel(0(0.2)0.40) ymtick(0(0.2)0.40, nolabels) xtitle(.) xtitle(, size(zero)) xlabel(1(1)7) legend(order(1 "Railroad 0-10 km" 2 "Railroad 0-10 km (Regression with Cell FE)") rows(1) span) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
* We edit the graph manually using graph editor
graph export figure_A9.png, replace width(2620) height(1908)

*******************************************************************************************************************
* WEB APPENDIX FIGURE 10: KERNEL DISTRIBUTION OF THE YEAR OF CONNECTION FOR THE 0-10 KM RAILROAD CELLS, 1890-1960 *
*******************************************************************************************************************

use africa1, clear
twoway (kdensity year_reached) if year_reached != 0, ytitle(Density) xline(1918 1945, lwidth(medium) lpattern(dash) lcolor(black)) legend(off)
* We edit the graph manually using graph editor
graph export figure_A10.png, replace width(2620) height(1908)















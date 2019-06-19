cd "C:\Users\jedwab\Desktop\Regressions_for_Ghana"

*****************************************************************************************************************

* The main data set "ghana1.dta" was created using the do-file "construction_data_ghana.dta" in the same folder
* This do-file ("regressions_ghana.do") allows us to recreate Tables 1-6, Figures 5-6, Web Appendix Tables 1-11, Web Appendix Figure 4 and the results for Footnote 13 
* The do-file recreates all the tables in excel. We then manually create the tables in tex. 

****************************************************************************
* TABLE 1: SUMMARY STATISTICS (MEAN) FOR TREATED AND CONTROL CELLS IN 1931 *
****************************************************************************

use ghana1, clear
* We keep one cross-section, 1931 
keep if year == 1931 
* We restrict the sample to the "forest" (the suitable cells for which we also have total population data in 1901)
keep if suitable == 1 & map08_yn == 1
count
* 554 cells
* We then create the z-scores of the population variables
egen rpop_1901std = std(rpop_1901) if year == 1931
egen upop_1901std = std(upop_1901) if year == 1931
* We also create the z-score of the value of mineral production
egen minvalue31_std = std(minvalue31) if year == 1931

* We create this table manually because we have to use the information from different commands
* Columns (1)-(4): We first obtain the mean of each controlling variable. 
* Columns (2)-(4): We then test for each column whether the cells (10+; 10-20; Placebo) are significantly different from the 0-10 km cells of column (1). 

*** MEANS OF THE CONTROLLING VARIABLES ***

* COLUMN (1): 0-10 km (mean)

set matsize 800

sum mincell upop_1901std rpop_1901std share_suit share_highsuit share_vhighsuit alt_mean alt_sd av_yr_prec border sea dist2coast dist2port dist2river dist2accra dist2kumasi dist2aburi minvalue31_std if rail18_10 == 1

* COLUMN (2): 10-+ km (mean)

sum mincell upop_1901std rpop_1901std share_suit share_highsuit share_vhighsuit alt_mean alt_sd av_yr_prec border sea dist2coast dist2port dist2river dist2accra dist2kumasi dist2aburi minvalue31_std if rail18_10 != 1

* COLUMN (3): 10-20 km (mean)

sum mincell upop_1901std rpop_1901std share_suit share_highsuit share_vhighsuit alt_mean alt_sd av_yr_prec border sea dist2coast dist2port dist2river dist2accra dist2kumasi dist2aburi minvalue31_std if rail18_1020 == 1

* COLUMN (4): Placebo 0-10 km (mean)

sum mincell upop_1901std rpop_1901std share_suit share_highsuit share_vhighsuit alt_mean alt_sd av_yr_prec border sea dist2coast dist2port dist2river dist2accra dist2kumasi dist2aburi minvalue31_std if placebo_10 == 1

*** TESTS OF SIGNIFICANT DIFFERENCES ***

* COLUMN (2): Tests of whether the 10-+ km cells are significantly different from the 0-10 km cells

reg mincell rail18_10, robust
outreg2 rail18_10 using table1_stars.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) replace

foreach X of varlist upop_1901std rpop_1901std share_suit share_highsuit share_vhighsuit alt_mean alt_sd av_yr_prec border sea dist2coast dist2port dist2river dist2accra dist2kumasi dist2aburi minvalue31_std {
reg `X' rail18_10, robust
outreg2 rail18_10 using table1_stars.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append
}

* COLUMN (3): Tests of whether the 10-20 km cells are significantly different from the 0-10 km cells

reg mincell rail18_10 if rail18_10 == 1 | rail18_1020 == 1, robust
outreg2 rail18_10 using table1_stars.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

foreach X of varlist upop_1901std rpop_1901std share_suit share_highsuit share_vhighsuit alt_mean alt_sd av_yr_prec border sea dist2coast dist2port dist2river dist2accra dist2kumasi dist2aburi minvalue31_std {
reg `X' rail18_10 if rail18_10 == 1 | rail18_1020 == 1, robust
outreg2 rail18_10 using table1_stars.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append
}

* COLUMN (4): Tests of whether the 10-20 km cells are significantly different from the 0-10 km cells

reg mincell rail18_10 if rail18_10 == 1 | placebo_10 == 1, robust
outreg2 rail18_10 using table1_stars.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

foreach X of varlist upop_1901std rpop_1901std share_suit share_highsuit share_vhighsuit alt_mean alt_sd av_yr_prec border sea dist2coast dist2port dist2river dist2accra dist2kumasi dist2aburi minvalue31_std {
reg `X' rail18_10 if rail18_10 == 1 | placebo_10 == 1, robust
outreg2 rail18_10 using table1_stars.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors clustered at the district level in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append
}

*******************************************************************
* TABLE 2: COLONIAL RAILROADS AND ECONOMIC DEVELOPMENT, 1901-1931 *
*******************************************************************

use ghana1, clear
* We keep one cross-section, 1931 
keep if year == 1931 
* We restrict the sample to the "forest" (the suitable cells for which we also have total population data in 1901)
keep if suitable == 1 & map08_yn == 1
count
* 554 cells
* We then create the z-scores of the production variables, the population variables and the value of mineral production
foreach X in cocoa_prod27 cocoastat_18 upop_1931 upop_1901 rpop_1931 rpop_1901 city_yn minvalue31    {
egen `X'_std = std(`X') 
}

* Column (1): Cocoa Prod. 1927 
xi: reg cocoa_prod27_std rail18_10 rail18_1020 rail18_2030 rail18_3040 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 rail18_1020 rail18_2030 rail18_3040 rpop_1901_std upop_1901_std using table2.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) replace

* Column (2): Rural Pop. 1931
xi: reg rpop_1931_std rail18_10 rail18_1020 rail18_2030 rail18_3040 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 rail18_1020 rail18_2030 rail18_3040 upop_1901_std rpop_1901_std using table2.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* Column (3): Rural Pop. 1931, including Cocoa Prod. 1927 and Cocoa at Rail Station 1918 (and a dummy equal to one if the cell contains a railroad station in 1918)
xi: reg rpop_1931_std rail18_10 rail18_1020 rail18_2030 rail18_3040 minvalue31_std railstat_yn18 cocoa_prod27_std cocoastat_18_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 rail18_1020 rail18_2030 rail18_3040 upop_1901_std rpop_1901_std cocoa_prod27_std cocoastat_18_std using table2.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* Column (4): Urban Pop. 1931 
xi: reg upop_1931_std rail18_10 rail18_1020 rail18_2030 rail18_3040 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 rail18_1020 rail18_2030 rail18_3040 upop_1901_std rpop_1901_std using table2.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* Column (5): Urban Pop. 1931, including Cocoa Prod. 1927 and Cocoa at Rail Station 1918 (and a dummy equal to one if the cell contains a railroad station in 1918)
xi: reg upop_1931_std rail18_10 rail18_1020 rail18_2030 rail18_3040 minvalue31_std railstat_yn18 cocoastat_18_std cocoa_prod27_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 rail18_1020 rail18_2030 rail18_3040 cocoa_prod27_std cocoastat_18_std upop_1901_std rpop_1901_std using table2.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* Column (6): City 1/0 1931
xi: reg city_yn_std rail18_10 rail18_1020 rail18_2030 rail18_3040 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 rail18_1020 rail18_2030 rail18_3040 upop_1901_std rpop_1901_std using table2.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* Column (7): Urb.Rate 1931, also controlling for Urb.Rate 1901 (the urbanization rate of the cell in 1901)
xi: reg urbrate rail18_10 rail18_1020 rail18_2030 rail18_3040 minvalue31_std border sea urbrate01 upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 rail18_1020 rail18_2030 rail18_3040 upop_1901_std rpop_1901_std using table2.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

**********************************************************************
* TABLE 3: IDENTIFICATION STRATEGIES, 1901-1931-2000 
**********************************************************************

*** PANEL A: DEPENDENT VARIABLE: COCOA PRODUCTION (Z-SCORE) IN 1927, GHANA ***

use ghana1, clear
* We keep one cross-section, 1931 
keep if year == 1931 
* We restrict the sample to the "forest" (the suitable cells for which we also have total population data in 1901)
keep if suitable == 1 & map08_yn == 1
count
* 554 cells
* We then create the z-scores of the production variables, the population variables and the value of mineral production
foreach X in cocoa_prod27 cocoastat_18 upop_1931 upop_1901 rpop_1931 rpop_1901 city_yn minvalue31    {
egen `X'_std = std(`X') 
}

* COLUMN (1): OLS
xi: reg cocoa_prod27_std rail18_40 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_40 using table3.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) replace

* COLUMN (2): ETHNIC GROUP FIXED EFFECTS (i.ethnic)
xi: reg cocoa_prod27_std rail18_40 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec i.ethnic, robust cluster(district_2000)
outreg2 rail18_40 using table3.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* COLUMN (3): DISTRICT GROUP FIXED EFFECTS (i.district)
xi: reg cocoa_prod27_std rail18_40 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec i.district, robust cluster(district_2000)
outreg2 rail18_40 using table3.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* COLUMN (4): FIRST, SECOND, THIRD AND FOURTH ORDER POLYNOMIAL IN LONGITUDE AND LATITUE (long1 long2 long3 long4 lat1 lat2 lat3 lat4)
xi: reg cocoa_prod27_std rail18_40 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec long1 long2 long3 long4 lat1 lat2 lat3 lat4, robust cluster(district_2000)
outreg2 rail18_40 using table3.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* COLUMN (5): WESTERN LINE, BECAUSE BUILT FOR MINING AND MILITARY DOMINATION 
xi: reg cocoa_prod27_std rail18w_40 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18w_40 using table3.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* COLUMN (6): PLACEBO LINES (40 km) - NO EFFECT
xi: reg cocoa_prod27_std placebo_40 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 placebo_40 using table3.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* COLUMN (7): USING THE PLACEBO LINES (0-40 km) AS A CONTROL GROUP
xi: reg cocoa_prod27_std rail18_40 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec if (dist2line18<=40 | placebo_40 == 1), robust cluster(district_2000)
outreg2 rail18_40 using table3.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* COLUMN (8): IV (effect of instrument in first stage = 0.69***; Kleibergen-Paap rk Wald F statistic = 164)

use ghana1, clear
* We keep one cross-section, 1931 
keep if year == 1931 
* We restrict the sample to the "forest" (the suitable cells for which we also have total population data in 1901)
keep if suitable == 1 & map08_yn == 1
count
* 554 cells
* We drop the 3 IV nodes of the forest: Tarkwa, Obuasi and Kumasi
drop if iv_node == 1
* We then create the z-scores of the production variables, the population variables and the value of mineral production
foreach X in cocoa_prod27 cocoastat_18 upop_1931 upop_1901 rpop_1931 rpop_1901 city_yn minvalue31    {
egen `X'_std = std(`X') 
}

xi: ivreg2 cocoa_prod27_std (rail18_40 = iv_40) minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000) first
outreg2 rail18_40 using table3.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

*** PANEL B: DEPENDENT VARIABLE: URBAN POPULATION (Z-SCORE) IN 1927, GHANA ***

use ghana1, clear
* We keep one cross-section, 1931 
keep if year == 1931 
* We restrict the sample to the "forest" (the suitable cells for which we also have total population data in 1901)
keep if suitable == 1 & map08_yn == 1
count
* 554 cells
* We then create the z-scores of the production variables, the population variables and the value of mineral production
foreach X in cocoa_prod27 cocoastat_18 upop_1931 upop_1901 rpop_1931 rpop_1901 city_yn minvalue31    {
egen `X'_std = std(`X') 
}

* COLUMN (1): OLS
xi: reg upop_1931_std rail18_10 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 using table3.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* COLUMN (2): ETHNIC GROUP FIXED EFFECTS (i.ethnic)
xi: reg upop_1931_std rail18_10 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec i.ethnic, robust cluster(district_2000)
outreg2 rail18_10 using table3.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* COLUMN (3): DISTRICT GROUP FIXED EFFECTS (i.district)
xi: reg upop_1931_std rail18_10 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec i.district, robust cluster(district_2000)
outreg2 rail18_10 using table3.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* COLUMN (4): FIRST, SECOND, THIRD AND FOURTH ORDER POLYNOMIAL IN LONGITUDE AND LATITUE (long1 long2 long3 long4 lat1 lat2 lat3 lat4)
xi: reg upop_1931_std rail18_10 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec long1 long2 long3 long4 lat1 lat2 lat3 lat4, robust cluster(district_2000)
outreg2 rail18_10 using table3.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* COLUMN (5): WESTERN LINE, BECAUSE BUILT FOR MINING AND MILITARY DOMINATION 
xi: reg upop_1931_std rail18w_10 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18w_10 using table3.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* COLUMN (6): PLACEBO LINES (10 km) - NO EFFECT
xi: reg upop_1931_std placebo_10 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 placebo_10 using table3.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* COLUMN (7): USING THE PLACEBO LINES (0-10 km) AS A CONTROL GROUP
xi: reg upop_1931_std rail18_10 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec if (dist2line18<=10 | placebo_10 == 1), robust cluster(district_2000)
outreg2 rail18_10 using table3.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* COLUMN (8): IV (effect of instrument in first stage = 0.17***; Kleibergen-Paap rk Wald F statistic = 20)

use ghana1, clear
* We keep one cross-section, 1931 
keep if year == 1931 
* We restrict the sample to the "forest" (the suitable cells for which we also have total population data in 1901)
keep if suitable == 1 & map08_yn == 1
count
* 554 cells
* We drop the 3 IV nodes of the forest: Tarkwa, Obuasi and Kumasi
drop if iv_node == 1
* We then create the z-scores of the production variables, the population variables and the value of mineral production
foreach X in cocoa_prod27 cocoastat_18 upop_1931 upop_1901 rpop_1931 rpop_1901 city_yn minvalue31    {
egen `X'_std = std(`X') 
}

xi: ivreg2 upop_1931_std (rail18_10 = iv_40) minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000) first
outreg2 rail18_10 using table3.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

*** PANEL C: DEPENDENT VARIABLE: URBAN POPULATION (Z-SCORE) IN 2000, GHANA ***

use ghana1, clear
* We keep one cross-section, 2000
keep if year == 2000 
* We restrict the sample to the "forest" (the suitable cells for which we also have total population data in 1901)
keep if suitable == 1 & map08_yn == 1
* We drop the city of Kumasi that has been growing a lot for political reasons in the post-independence period
drop if gridcell == "S49"
count
* 553 cells
* We then create the z-scores of the production variables, the population variables and the value of mineral production
foreach X in cocoa_prod27 cocoastat_18 upop_2000 upop_1931 upop_1901 rpop_1931 rpop_1901 city_yn minvalue31    {
egen `X'_std = std(`X') 
}

* COLUMN (1): OLS
xi: reg upop_2000_std rail18_10 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 using table3.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* COLUMN (2): ETHNIC GROUP FIXED EFFECTS (i.ethnic)
xi: reg upop_2000_std rail18_10 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec i.ethnic, robust cluster(district_2000)
outreg2 rail18_10 using table3.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* COLUMN (3): DISTRICT GROUP FIXED EFFECTS (i.district)
xi: reg upop_2000_std rail18_10 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec i.district, robust cluster(district_2000)
outreg2 rail18_10 using table3.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* COLUMN (4): FIRST, SECOND, THIRD AND FOURTH ORDER POLYNOMIAL IN LONGITUDE AND LATITUE (long1 long2 long3 long4 lat1 lat2 lat3 lat4)
xi: reg upop_2000_std rail18_10 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec long1 long2 long3 long4 lat1 lat2 lat3 lat4, robust cluster(district_2000)
outreg2 rail18_10 using table3.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* COLUMN (5): WESTERN LINE, BECAUSE BUILT FOR MINING AND MILITARY DOMINATION 
xi: reg upop_2000_std rail18w_10 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18w_10 using table3.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* COLUMN (6): PLACEBO LINES (40 km) - NO EFFECT
xi: reg upop_2000_std placebo_10 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 placebo_10 using table3.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* COLUMN (7): USING THE PLACEBO LINES (0-10 km) AS A CONTROL GROUP
xi: reg upop_2000_std rail18_10 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec if (dist2line18<=10 | placebo_10 == 1), robust cluster(district_2000)
outreg2 rail18_10 using table3.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

use ghana1, clear
* We keep one cross-section, 2000
keep if year == 2000 
* We restrict the sample to the "forest" (the suitable cells for which we also have total population data in 1901)
keep if suitable == 1 & map08_yn == 1
* We drop the city of Kumasi that has been growing a lot for political reasons in the post-independence period
drop if gridcell == "S49"
* We drop the other 2 IV nodes of the forest: Tarkwa and Obuasi 
drop if iv_node == 1
count
* 551 cells
* We then create the z-scores of the production variables, the population variables and the value of mineral production
foreach X in cocoa_prod27 cocoastat_18 upop_2000 upop_1931 upop_1901 rpop_1931 rpop_1901 city_yn minvalue31    {
egen `X'_std = std(`X') 
}

* COLUMN (8): IV (effect of instrument in first stage = 0.17***; Kleibergen-Paap rk Wald F statistic = 20)
xi: ivreg2 upop_2000_std (rail18_10 = iv_40) minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000) first
outreg2 rail18_10 using table3.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

*** PANEL D: WE USE THE AFRICA SAMPLE. SEE THE FOLDER: "REGRESSIONS FOR GHANA" ***

*********************************************
*** TABLE 4 : HISTORICAL FACTORS ***
*********************************************

use ghana1, clear
* We keep one cross-section, 1931 
keep if year == 1931 
* We restrict the sample to the "forest" (the suitable cells for which we also have total population data in 1901)
keep if suitable == 1 & map08_yn == 1
count
* 554 cells
* We then create the z-scores of the production variables, the population variables and the value of mineral production
foreach X in cocoa_prod27 cocoastat_18 upop_1931 upop_1901 rpop_1931 rpop_1901 city_yn minvalue31    {
egen `X'_std = std(`X') 
}

*** Means ***

* We use the means of the variables and show them in the lower panel of Table 4
sum school1931 hosp_1931 church_num1931 class1_1931

*** PANEL A: RAILROADS AND HISTORICAL FACTORS 1931 ***

* COLUMN (1): N.Schools 1931
xi: reg school1931 rail18_10 rail18_1020 rail18_2030 rail18_3040 school1901 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 rail18_1020 rail18_2030 rail18_3040 using table4.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) replace

* COLUMN (2): Hospital 1/0 1931 
xi: reg hosp_1931 rail18_10 rail18_1020 rail18_2030 rail18_3040 hosp_1901 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 rail18_1020 rail18_2030 rail18_3040 using table4.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* COLUMN (3): N.Churches 1931 
xi: reg church_num1931 rail18_10 rail18_1020 rail18_2030 rail18_3040 church_num1901 minvalue31_std  border sea upop_1901_std rpop_1901_std mincell dist2accra dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 rail18_1020 rail18_2030 rail18_3040 using table4.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* COLUMN (4): Class 1 Road 1/0 1931 
xi: reg class1_1931 rail18_10 rail18_1020 rail18_2030 rail18_3040 class3_1901 minvalue31_std  border sea upop_1901_std rpop_1901_std mincell dist2accra dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 rail18_1020 rail18_2030 rail18_3040 using table4.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

*** PANEL B: RAILROADS AND HISTORICAL FACTORS 1931, CONDITIONED ON POPULATION IN 1931 ***

* COLUMN (1): N.Schools 1931, also including z-scores of the ubran and rural populations in 1931 (upop_1931_std rpop_1931_std)
xi: reg school1931 rail18_10 rail18_1020 rail18_2030 rail18_3040 school1901 upop_1931_std rpop_1931_std minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 rail18_1020 rail18_2030 rail18_3040 using table4.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* COLUMN (2): Hospital 1/0 1931, also including z-scores of the ubran and rural populations in 1931 (upop_1931_std rpop_1931_std)
xi: reg hosp_1931 rail18_10 rail18_1020 rail18_2030 rail18_3040 upop_1931_std rpop_1931_std minvalue31_std hosp_1901 border sea upop_1901_std rpop_1901_std mincell dist2accra dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 rail18_1020 rail18_2030 rail18_3040 using table4.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* COLUMN (3): N.Churches 1931, also including z-scores of the ubran and rural populations in 1931 (upop_1931_std rpop_1931_std)
xi: reg church_num1931 rail18_10 rail18_1020 rail18_2030 rail18_3040 upop_1931_std rpop_1931_std minvalue31_std  church_num1901 border sea upop_1901_std rpop_1901_std mincell dist2accra dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 rail18_1020 rail18_2030 rail18_3040 using table4.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* COLUMN (4): Class 1 Road 1/0 1931, also including z-scores of the ubran and rural populations in 1931 (upop_1931_std rpop_1931_std)
xi: reg class1_1931 rail18_10 rail18_1020 rail18_2030 rail18_3040 upop_1931_std rpop_1931_std class3_1901 minvalue31_std  border sea upop_1901_std rpop_1901_std mincell dist2accra dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 rail18_1020 rail18_2030 rail18_3040 using table4.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

***************************************************************
* TABLE 5: COLONIAL RAILROADS AND GENERAL EQUILIBRIUM EFFECTS *
***************************************************************

use ghana1, clear
* We keep one cross-section, 1931 
keep if year == 1931 
* We restrict the sample to the "forest" (the suitable cells for which we also have total population data in 1901)
keep if suitable == 1 & map08_yn == 1
count
* 554 cells
* We then create the z-scores of the production variables, the population variables and the value of mineral production
foreach X in cocoa_prod27 cocoastat_18 upop_1931 upop_1901 rpop_1931 rpop_1901 city_yn minvalue31    {
egen `X'_std = std(`X') 
}

* COLUMNS (1)-(8): EFFECT OF RAIL 1918, X KM VS. RAIL 1918, > X KM

* COLUMN (1): X = 0-10 km
xi: reg upop_1931_std rail18_10 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_* using table5.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) replace

* COLUMN (2): X = 10-20 km
drop if rail18_10 == 1
xi: reg upop_1931_std rail18_1020 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_* using table5.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* COLUMN (3): X = 20-30 km
drop if rail18_1020 == 1
xi: reg upop_1931_std rail18_2030 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_* using table5.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* COLUMN (4): X = 30-40 km
drop if rail18_2030 == 1
xi: reg upop_1931_std rail18_3040 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_* using table5.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* COLUMN (5): X = 40-50 km
drop if rail18_3040 == 1
xi: reg upop_1931_std rail18_4050 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_* using table5.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* COLUMN (6): X = 50-60 km
drop if rail18_4050 == 1
xi: reg upop_1931_std rail18_5060 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_* using table5.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* COLUMN (7): X = 60-70 km
drop if rail18_5060 == 1
xi: reg upop_1931_std rail18_6070 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_* using table5.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* COLUMN (8): X = 70-80 km
drop if rail18_6070 == 1
xi: reg upop_1931_std rail18_7080 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_* using table5.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* COLUMNS (9)-(12): EFFECT OF PRE-RAIL DUMMY, FOREST AND PRE-RAIL DUMMY, NON-FOREST 

use ghana1, clear
* We keep one cross-section, 1931 
keep if year == 1931 
* We do not restrict the sample to the "forest" (the suitable cells for which we also have total population data in 1901)
count
* 2091 cells

* We then create the z-scores of the production variables, the population variables and the value of mineral production
foreach X in cocoa_prod27 cocoastat_18 upop_1931 upop_1901 rpop_1931 rpop_1901 city_yn minvalue31    {
egen `X'_std = std(`X') 
}

* We drop the 0-10 railroad cells, in order to compare the cells with a city or access to transportation in 1901 to the other cells
drop if rail18_10 == 1

* COLUMN (9): City 1901
xi: reg upop_1931_std rail18_10 rail18_1020 rail18_2030 rail18_3040 city_1901_forest city_1901_rest minvalue31_std border sea upop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 rail18_1020 rail18_2030 rail18_3040 city_1901_forest city_1901_rest upop_1901_std using table5.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* COLUMN (10): Coastal
xi: reg upop_1931_std rail18_10 rail18_1020 rail18_2030 rail18_3040 coastal_forest coastal_rest minvalue31_std border upop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 rail18_1020 rail18_2030 rail18_3040 coastal_forest coastal_rest upop_1901_std using table5.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* COLUMN (11): Route 1850
xi: reg upop_1931_std rail18_10 rail18_1020 rail18_2030 rail18_3040 route1850_forest route1850_rest minvalue31_std sea border upop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 rail18_1020 rail18_2030 rail18_3040 *_forest *_rest upop_1901_std using table5.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* COLUMN (12): Route 1900
xi: reg upop_1931_std rail18_10 rail18_1020 rail18_2030 rail18_3040 route1901_forest route1901_rest minvalue31_std sea border upop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 rail18_1020 rail18_2030 rail18_3040 *_forest *_rest upop_1901_std using table5.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

***********************************************************
* TABLE 6: COLONIAL RAILROADS AND URBAN GROWTH, 1901-2000 *
***********************************************************

use ghana1, clear
* We keep one cross-section, 2000
keep if year == 2000 
* We restrict the sample to the "forest" (the suitable cells for which we also have total population data in 1901)
keep if suitable == 1 & map08_yn == 1
* We drop the city of Kumasi that has been growing a lot for political reasons in the post-independence period
drop if gridcell == "S49"
count
* 553 cells
* We then create the z-scores of the production variables, the population variables and the value of mineral production
foreach X in cocoa_prod27 cocoastat_18 upop_2000 upop_1960 rpop_2000 rpop_1970 upop_1931 upop_1901 rpop_1931 rpop_1901 city_yn minvalue31    {
egen `X'_std = std(`X') 
}

* COLUMN (1): BASELINE REGRESSION
xi: reg upop_2000_std rail18_10 rail18_1020 rail18_2030 rail18_3040 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 rail18_1020 rail18_2030 rail18_3040 using table6.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) replace

* COLUMN (2): ALSO CONTROLLING FOR ROADS IN 2000 (paved_98_10 improved_98_10)
xi: reg upop_2000_std rail18_10 rail18_1020 rail18_2030 rail18_3040 paved_2000_10 improved_2000_10 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 rail18_1020 rail18_2030 rail18_3040 paved_2000_10 improved_2000_10 using table6.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* COLUMN (3): ALSO CONTROLLING FOR POPULATION IN 1931 (upop_1931_std rpop_1931_std)
xi: reg upop_2000_std rail18_10 rail18_1020 rail18_2030 rail18_3040 upop_1931_std rpop_1931_std minvalue31_std paved_2000_10 improved_2000_10 border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 rail18_1020 rail18_2030 rail18_3040 paved_2000_10 improved_2000_10 upop_1931_std rpop_1931_std using table6.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

*  COLUMN (4): ALSO CONTROLLING FOR HISTORICAL FACTORS IN 1901 AND 1931
xi: reg upop_2000_std rail18_10 rail18_1020 rail18_2030 rail18_3040 upop_1931_std rpop_1931_std minvalue31_std paved_2000_10 improved_2000_10 class3_1901_10 class3_1931_10 class2_1931_10 class1_1931_10 church_yn1931 church_num1931 church_yn1901 church_num1901 hosp_1901 hosp_1931 school1901 school1931 school1901_yn school1931_yn border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 rail18_1020 rail18_2030 rail18_3040 paved_2000_10 improved_2000_10 upop_1931_std rpop_1931_std using table6.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

*  COLUMN (5): ALSO CONTROLLING FOR POPULATION IN 1960
xi: reg upop_2000_std rail18_10 rail18_1020 rail18_2030 rail18_3040 upop_1931_std rpop_1931_std minvalue31_std paved_2000_10 improved_2000_10 upop_1960_std rpop_1970_std class3_1901_10 class3_1931_10 class2_1931_10 class1_1931_10 church_yn1931 church_num1931 church_yn1901 church_num1901 hosp_1901 hosp_1931 school1901 school1931 school1901_yn school1931_yn border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 rail18_1020 rail18_2030 rail18_3040 paved_2000_10 improved_2000_10 upop_1931_std rpop_1931_std upop_1960_std rpop_1970_std using table6.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

*  COLUMN (6): ALSO CONTROLLING FOR CONTEMPORARY FACTORS TODAY (2000)
xi: reg upop_2000_std rail18_10 rail18_1020 rail18_2030 rail18_3040 upop_1931_std rpop_1931_std minvalue31_std paved_2000_10 improved_2000_10 upop_1960_std rpop_1970_std jss_sh sss_sh clinic_sh hosp_sh post_sh solid_walls_sh primary_sh tel_sh solid_roof_sh solid_floor_sh good_water_sh literate_sh educyn_sh educ_prim_sh educ_jss_sh educ_sss_sh class3_1901_10 class3_1931_10 class2_1931_10 class1_1931_10 church_yn1931 church_num1931 church_yn1901 church_num1901 hosp_1901 hosp_1931 school1901 school1931 school1901_yn school1931_yn border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 rail18_1020 rail18_2030 rail18_3040 paved_2000_10 improved_2000_10 upop_1931_std rpop_1931_std upop_1960_std rpop_1970_std using table6.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* COLUMN (7): NIGHT LIGHTS (2000) AS DEPENDENT VARIABLE
xi: reg avmean rail18_10 rail18_1020 rail18_2030 rail18_3040 upop_1931_std rpop_1931_std minvalue31_std paved_2000_10 improved_2000_10 upop_2000_std rpop_2000_std upop_1960_std rpop_1970_std jss_sh sss_sh clinic_sh hosp_sh post_sh solid_walls_sh primary_sh tel_sh solid_roof_sh solid_floor_sh good_water_sh literate_sh educyn_sh educ_prim_sh educ_jss_sh educ_sss_sh class3_1901_10 class3_1931_10 class2_1931_10 class1_1931_10 church_yn1931 church_num1931 church_yn1901 church_num1901 hosp_1901 hosp_1931 school1901 school1931 school1901_yn school1931_yn border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 rail18_1020 rail18_2030 rail18_3040 paved_2000_10 improved_2000_10 upop_1931_std rpop_1931_std upop_1960_std rpop_1970_std upop_2000_std rpop_2000_std using table6.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* COLUMN (8): INDUSTRY AND SERVICES
xi: reg induserv_sh rail18_10 rail18_1020 rail18_2030 rail18_3040 upop_1931_std rpop_1931_std minvalue31_std paved_2000_10 improved_2000_10 upop_2000_std rpop_2000_std upop_1960_std rpop_1970_std jss_sh sss_sh clinic_sh hosp_sh post_sh solid_walls_sh primary_sh tel_sh solid_roof_sh solid_floor_sh good_water_sh literate_sh educyn_sh educ_prim_sh educ_jss_sh educ_sss_sh class3_1901_10 class3_1931_10 class2_1931_10 class1_1931_10 church_yn1931 church_num1931 church_yn1901 church_num1901 hosp_1901 hosp_1931 school1901 school1931 school1901_yn school1931_yn border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 rail18_1020 rail18_2030 rail18_3040 paved_2000_10 improved_2000_10 upop_1931_std rpop_1931_std upop_1960_std rpop_1970_std upop_2000_std rpop_2000_std using table6.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

**********************************************************************
* FIGURE 5: EFFECTS OF COLONIAL RAILROADS FOR EACH PERIOD, 1891-2000 *
**********************************************************************

* We first obtain the coefficients for each period. 
use ghana1, clear
* We keep one cross-section, 2000
keep if year == 2000 
* We restrict the sample to the "forest" (the suitable cells for which we also have total population data in 1901)
keep if suitable == 1 & map08_yn == 1
count
* 554 cells
* We then create the z-scores of the production variables, the population variables and the value of mineral production
foreach X in cocoa_prod27 cocoastat_18 upop_2000 upop_1984 upop_1970 upop_1960 upop_1948 rpop_2000 rpop_1970 upop_1931 upop_1901 upop_1891 rpop_1931 rpop_1901 city_yn minvalue31    {
egen `X'_std = std(`X') 
}

xi: reg upop_1901_std rail18_10 rail18_1020 rail18_2030 rail18_3040 border sea upop_1891_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(gridcell)
outreg2 rail18_10 rail18_1020 rail18_2030 rail18_3040 upop_*_std using figure5_gh.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) replace

xi: reg upop_1931_std rail18_10 rail18_1020 rail18_2030 rail18_3040 border sea upop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(gridcell)
outreg2 rail18_10 rail18_1020 rail18_2030 rail18_3040 upop_*_std using figure5_gh.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

xi: reg upop_1948_std rail18_10 rail18_1020 rail18_2030 rail18_3040 border sea upop_1931_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(gridcell)
outreg2 rail18_10 rail18_1020 rail18_2030 rail18_3040 upop_*_std using figure5_gh.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

xi: reg upop_1960_std rail18_10 rail18_1020 rail18_2030 rail18_3040 border sea upop_1948_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(gridcell)
outreg2 rail18_10 rail18_1020 rail18_2030 rail18_3040 upop_*_std using figure5_gh.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

xi: reg upop_1970_std rail18_10 rail18_1020 rail18_2030 rail18_3040 border sea upop_1960_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(gridcell)
outreg2 rail18_10 rail18_1020 rail18_2030 rail18_3040 upop_*_std using figure5_gh.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

xi: reg upop_1984_std rail18_10 rail18_1020 rail18_2030 rail18_3040 border sea upop_1970_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(gridcell)
outreg2 rail18_10 rail18_1020 rail18_2030 rail18_3040 upop_*_std using figure5_gh.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

xi: reg upop_2000_std rail18_10 rail18_1020 rail18_2030 rail18_3040 border sea upop_1984_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(gridcell)
outreg2 rail18_10 rail18_1020 rail18_2030 rail18_3040 upop_*_std using figure5_gh.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* Using figure5_gh.xls, we create "data_for_figure_5_gh.xls" using excel
* This excel file shows the coefficient of the 0-10 km dummy and the coefficient of Ut-1
clear
import excel "data_for_figure_5.xls", sheet("stata") firstrow
* select the effects for Ghana only
keep if gh10 != .
replace yearnum = 7 if yearnum == 8
* We first create the figure as good as possible
twoway (line gh10 yearnum, lcolor(gs7) lwidth(medthick)) (connected ghlag yearnum, yaxis(2) mcolor(gs9) msize(medium) msymbol(circle) lcolor(gs9) lwidth(medthick) lpattern(dash)) (connected gh10 yearnum, mcolor(black) msize(medlarge) msymbol(circle) lcolor(black) lwidth(thick) lpattern(solid)), ytitle(Railroad Effect) ytitle(, size(large) margin(small)) ylabel(-0.20(0.2)0.85) ymtick(-0.20(0.1)0.85, nolabels) xtitle(.) xtitle(, size(zero)) xlabel(1(1)7) legend(order(1 "Coefficient of Railroad 0-10 km" 2 "Coefficient of Ut-1") rows(1) span) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
graph export figure5_gh.png, replace width(5240) height(3816)
* We then use graph editor to improve the figure on Ghana
* We then use paint to create one figure out of the figure on Ghana and the figure on Africa

*****************************************************************************
* FIGURE 6: AGGREGATE URBANIZATION AND INCOME PATTERNS IN AFRICA, 1891-2000 *
*****************************************************************************

* We import an excel data set showing the number of cities (above 1,000 inhabitants) and the urbanization of the forest area and Ghana as a whole
* The excel data set also shows per capita GDP (base 100 in 1891) and total and cocoa exports per capita (in constant 2000USD)
clear
import excel "agg_patterns_gh.xlsx", sheet("Sheet1") firstrow clear

* Figure 6.a on "Urbanization (Forest)"
twoway (connected numcities_forest year, mcolor(black) msize(medlarge) msymbol(circle) lcolor(black) lwidth(medthick) lpattern(solid)) (connected urbrate_forest year, yaxis(2) mcolor(black) msize(medium) msymbol(square) lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(Number of Cities) legend(order(1 "Number of Cities" 2 "Urbanization Rate")) graphregion(fcolor(white) lcolor(white)) title(a. Urbanization (Forest))
graph export figure6a.png, replace width(2620) height(1908)
* We then use graph editor to edit the figure 

* Figure 6.b on "Urbanization (Ghana)"
twoway (connected numcities_ghana year, mcolor(black) msize(medlarge) msymbol(circle) lcolor(black) lwidth(medthick) lpattern(solid)) (connected urbrate_ghana year, yaxis(2) mcolor(black) msize(medium) msymbol(square) lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(Number of Cities) legend(order(1 "Number of Cities" 2 "Urbanization Rate")) graphregion(fcolor(white) lcolor(white)) title(b. Urbanization (Ghana))
graph export figure6b.png, replace width(2620) height(1908)
* We then use graph editor to edit the figure 

* Figure 6.c on "Income (Ghana)"
twoway (connected pcgdp year, mcolor(black) msize(medlarge) msymbol(circle) lcolor(black) lwidth(medthick) lpattern(solid)) (connected exportspc year, yaxis(2) mcolor(gs6) msize(medium) msymbol(square) lcolor(gs6) lwidth(medthick) lpattern(solid)) (line cocoaexportspc year, yaxis(2) lcolor(gs6) lwidth(medthick) lpattern(dash)), ytitle(pcGDP (Base 100 in 1891)) legend(order(1 "pcGDP" 2 "Exports (pc)" 3 "Cocoa Exports (pc)") rows(1)) graphregion(fcolor(white) lcolor(white)) title(c. Income (Ghana))
graph export figure6c.png, replace width(2620) height(1908)
* We then use graph editor to edit the figure 

*****************************************************************************************************

**************************************************************
***                    WEB APPENDICES                      ***
**************************************************************

* This do-file helps to create the web appendix tables

*********************************************************************
* WEB APPENDIX TABLE 1: IDENTIFICATION STRATEGIES, GHANA, 1901-1931 *
*********************************************************************

use ghana1, clear
* We keep one cross-section, 1931 
keep if year == 1931 
* We restrict the sample to the "forest" (the suitable cells for which we also have total population data in 1901)
keep if suitable == 1 & map08_yn == 1
count
* 554 cells
* We then create the z-scores of the production variables, the population variables and the value of mineral production
foreach X in cocoa_prod27 cocoastat_18 upop_1931 upop_1901 rpop_1931 rpop_1901 pop_1931 city_yn minvalue31    {
egen `X'_std = std(`X') 
}

*** PANEL A: DEPENDENT VARIABLE = RURAL POPULATION (Z-SCORE) IN 1931 ***

* COLUMN (1): BASELINE
xi: reg rpop_1931_std rail18_30 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_30 using table_A1.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) replace

* COLUMN (2): ETHNIC GROUP FE
xi: reg rpop_1931_std rail18_30 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec i.ethnic, robust cluster(district_2000)
outreg2 rail18_30 using table_A1.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* COLUMN (3): DISTRICT FE
xi: reg rpop_1931_std rail18_30 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec i.district, robust cluster(district_2000)
outreg2 rail18_30 using table_A1.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* COLUMN (4): FOURTH ORDER POLYNOMIAL IN LONGITUDE AND LATITUDE
xi: reg rpop_1931_std rail18_30 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec long1 long2 long3 long4 lat1 lat2 lat3 lat4, robust cluster(district_2000)
outreg2 rail18_30 using table_A1.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* COLUMN (5): MINING AND MILITARY LINES (WESTERN LINE)
xi: reg rpop_1931_std rail18w_30 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18w_30 using table_A1.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* COLUMN (6): PLACEBO (0-30 KM)
xi: reg rpop_1931_std placebo_30 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 placebo_30 using table_A1.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* COLUMN (7): PLACEBO LINES AS CONTROL
xi: reg rpop_1931_std rail18_30 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec if (dist2line18<=30 | placebo_30 == 1), robust cluster(district_2000)
outreg2 rail18_30 using table_A1.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

use ghana1, clear
* We keep one cross-section, 1931 
keep if year == 1931 
* We restrict the sample to the "forest" (the suitable cells for which we also have total population data in 1901)
keep if suitable == 1 & map08_yn == 1
count
* 554 cells
* We drop the 3 IV nodes of the forest: Tarkwa, Obuasi and Kumasi
drop if iv_node == 1
* We then create the z-scores of the production variables, the population variables and the value of mineral production
foreach X in cocoa_prod27 cocoastat_18 upop_1931 upop_1901 rpop_1931 rpop_1901 city_yn minvalue31    {
egen `X'_std = std(`X') 
}

* COLUMN (8): IV
xi: ivreg2 rpop_1931_std (rail18_30 = iv_40) minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000) first
outreg2 rail18_30 using table_A1.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

*** PANEL B: DEPENDENT VARIABLE = TOTAL POPULATION (Z-SCORE) IN 1931 ***

use ghana1, clear
* We keep one cross-section, 1931 
keep if year == 1931 
* We restrict the sample to the "forest" (the suitable cells for which we also have total population data in 1901)
keep if suitable == 1 & map08_yn == 1
count
* 554 cells
* We then create the z-scores of the production variables, the population variables and the value of mineral production
foreach X in cocoa_prod27 cocoastat_18 upop_1931 upop_1901 rpop_1931 rpop_1901 pop_1931 city_yn minvalue31    {
egen `X'_std = std(`X') 
}

* COLUMN (1): BASELINE
xi: reg pop_1931_std rail18_20 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_20 using table_A1.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* COLUMN (2): ETHNIC GROUP FE
xi: reg pop_1931_std rail18_20 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec i.ethnic, robust cluster(district_2000)
outreg2 rail18_20 using table_A1.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* COLUMN (3): DISTRICT FE
xi: reg pop_1931_std rail18_20 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec i.district, robust cluster(district_2000)
outreg2 rail18_20 using table_A1.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* COLUMN (4): FOURTH ORDER POLYNOMIAL IN LONGITUDE AND LATITUDE
xi: reg pop_1931_std rail18_20 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec long1 long2 long3 long4 lat1 lat2 lat3 lat4, robust cluster(district_2000)
outreg2 rail18_20 using table_A1.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* COLUMN (5): MINING AND MILITARY LINES (WESTERN LINE)
xi: reg pop_1931_std rail18w_20 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18w_20 using table_A1.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* COLUMN (6): PLACEBO (0-20 KM)
xi: reg pop_1931_std placebo_20 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 placebo_20 using table_A1.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* COLUMN (7): PLACEBO LINES AS CONTROL
xi: reg pop_1931_std rail18_20 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec if (dist2line18<=20 | placebo_20 == 1), robust cluster(district_2000)
outreg2 rail18_20 using table_A1.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

use ghana1, clear
* We keep one cross-section, 1931 
keep if year == 1931 
* We restrict the sample to the "forest" (the suitable cells for which we also have total population data in 1901)
keep if suitable == 1 & map08_yn == 1
count
* 554 cells
* We drop the 3 IV nodes of the forest: Tarkwa, Obuasi and Kumasi
drop if iv_node == 1
* We then create the z-scores of the production variables, the population variables and the value of mineral production
foreach X in cocoa_prod27 cocoastat_18 pop_1931 upop_1931 upop_1901 rpop_1931 rpop_1901 city_yn minvalue31    {
egen `X'_std = std(`X') 
}

* COLUMN (8): IV
xi: ivreg2 pop_1931_std (rail18_20 = iv_40) minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000) first
outreg2 rail18_20 using table_A1.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

*************************************************************************
* WEB APPENDIX TABLE 2: NON-EFFECTS FOR PLACEBO LINES, GHANA, 1901-1931 *
*************************************************************************

use ghana1, clear
* We keep one cross-section, 1931 
keep if year == 1931 
* We restrict the sample to the "forest" (the suitable cells for which we also have total population data in 1901)
keep if suitable == 1 & map08_yn == 1
count
* 554 cells
* We then create the z-scores of the production variables, the population variables and the value of mineral production
foreach X in cocoa_prod27 cocoastat_18 upop_1931 upop_1901 rpop_1931 rpop_1901 pop_1931 city_yn minvalue31    {
egen `X'_std = std(`X') 
}

*** Panel A: Dependent Variable = Cocoa Production (Z-Score) in 1927 ***
* Placebo 0-40 km 

xi: reg cocoa_prod27_std ccpk_40 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 ccpk_40 using table_A2.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) replace

foreach X of varlist sok_40 apamok_40 aok_40 kpong_40 tk_40 hvk_40 {
xi: reg cocoa_prod27_std `X' minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 `X' using table_A2.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append
}

*** Panel B: Dependent Variable = Cocoa Production (Z-Score) in 1927 ***
* Placebo 0-40 km, Drop if Rail 0-40 km = 1

foreach X of varlist ccpk_40 sok_40 apamok_40 aok_40 kpong_40 tk_40 hvk_40 {
xi: reg cocoa_prod27_std `X' minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec if dist2line18 > 40, robust cluster(district_2000)
outreg2 `X' using table_A2.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append
}

*** Panel C: Dependent Variable = Total Population (Z-Score) in 1931 ***
* Placebo 0-20 km

xi: reg pop_1931_std ccpk_20 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 ccpk_20 using table_A2.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

foreach X of varlist sok_20 apamok_20 aok_20 kpong_20 tk_20 hvk_20 {
xi: reg pop_1931_std `X' minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 `X' using table_A2.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append
}

*** Panel D: Dependent Variable = Total Population (Z-Score) in 1931 ***
* Placebo 0-20 km, Drop if Rail 0-20 km = 1

foreach X of varlist ccpk_20 sok_20 apamok_20 aok_20 kpong_20 tk_20 hvk_20 {
xi: reg pop_1931_std `X' minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec if dist2line18 > 20, robust cluster(district_2000)
outreg2 `X' using table_A2.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append
}

*** Panel E: Dependent Variable = Urban Population (Z-Score) in 1931 ***
* Placebo 0-10 km

xi: reg upop_1931_std ccpk_10 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 ccpk_10 using table_A2.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

foreach X of varlist sok_10 apamok_10 aok_10 kpong_10 tk_10 hvk_10 {
xi: reg upop_1931_std `X' minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 `X' using table_A2.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append
}

*** Panel E: Dependent Variable = Urban Population (Z-Score) in 1931 ***
* Placebo 0-10 km, Drop if Rail 0-10 km = 1

foreach X of varlist ccpk_10 sok_10 apamok_10 aok_10 kpong_10 tk_10 hvk_10 {
xi: reg upop_1931_std `X' minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec if dist2line18 > 10, robust cluster(district_2000)
outreg2 `X' using table_A2.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append
}

*******************************************************************************
* WEB APPENDIX TABLE 3: ROBUSTNESS AND SPECIFICATION CHECKS, GHANA, 1901-1931 *
*******************************************************************************

*** Panel A: Dependent Variable = Cocoa Production (Z) in 1927 ***

use ghana1, clear
* We keep one cross-section, 1931 
keep if year == 1931 
* We restrict the sample to the "forest" (the suitable cells for which we also have total population data in 1901)
keep if suitable == 1 & map08_yn == 1
count
* 554 cells
* We then create the z-scores of the production variables, the population variables and the value of mineral production
foreach X in cocoa_prod27 cocoastat_18 upop_1931 upop_1901 rpop_1931 rpop_1901 pop_1931 city_yn minvalue31    {
egen `X'_std = std(`X') 
}

* (0) Baseline
xi: reg cocoa_prod27_std rail18_40 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_40 using table_A3.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) replace

* (i) No controls
xi: reg cocoa_prod27_std rail18_40 minvalue31_std upop_1901_std rpop_1901_std, robust cluster(district_2000)
outreg2 rail18_40 using table_A3.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (ii) Full sample (standardization to be changed) - we cannot control for rpop_1901_std

use ghana1, clear
* We keep one cross-section, 1931 
keep if year == 1931 
* We then create the z-scores of the production variables, the population variables and the value of mineral production
foreach X in cocoa_prod27 cocoastat_18 upop_1931 upop_1901 rpop_1931 rpop_1901 pop_1931 city_yn minvalue31    {
egen `X'_std = std(`X') 
}

xi: reg cocoa_prod27_std rail18_40 minvalue31_std border sea upop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_40 using table_A3.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (iii) No nodes

use ghana1, clear
* We keep one cross-section, 1931 
keep if year == 1931 
* We restrict the sample to the "forest" (the suitable cells for which we also have total population data in 1901)
keep if suitable == 1 & map08_yn == 1
drop if iv_node == 1
* We then create the z-scores of the production variables, the population variables and the value of mineral production
foreach X in cocoa_prod27 cocoastat_18 upop_1931 upop_1901 rpop_1931 rpop_1901 pop_1931 city_yn minvalue31    {
egen `X'_std = std(`X') 
}

xi: reg cocoa_prod27_std rail18_40 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_40 using table_A3.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (iv) No nodes and no neighbors

use ghana1, clear
* We keep one cross-section, 1931 
keep if year == 1931 
* We restrict the sample to the "forest" (the suitable cells for which we also have total population data in 1901)
keep if suitable == 1 & map08_yn == 1
drop if iv_node == 1
drop if iv_node_neighbor == 1
* We then create the z-scores of the production variables, the population variables and the value of mineral production
foreach X in cocoa_prod27 cocoastat_18 upop_1931 upop_1901 rpop_1931 rpop_1901 pop_1931 city_yn minvalue31    {
egen `X'_std = std(`X') 
}

xi: reg cocoa_prod27_std rail18_40 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_40 using table_A3.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (v) Rail station  

use ghana1, clear
* We keep one cross-section, 1931 
keep if year == 1931 
* We restrict the sample to the "forest" (the suitable cells for which we also have total population data in 1901)
keep if suitable == 1 & map08_yn == 1
count
* 554 cells
* We then create the z-scores of the production variables, the population variables and the value of mineral production
foreach X in cocoa_prod27 cocoastat_18 upop_1931 upop_1901 rpop_1931 rpop_1901 pop_1931 city_yn minvalue31    {
egen `X'_std = std(`X') 
}

xi: reg cocoa_prod27_std railstat18_40 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 railstat18_40 using table_A3.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (vi) Distance
xi: reg cocoa_prod27_std dist2line18 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 dist2line18 using table_A3.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (vii) Change
* Production was equal to 0 in 1901, so the change variable is equal to the variable in 1931
xi: reg cocoa_prod27_std rail18_40 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_40 using table_A3.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (viii) Panel 

use ghana1, clear
* We keep one cross-section, 1931 
keep if year == 1901 | year == 1931  
* We restrict the sample to the "forest" (the suitable cells for which we also have total population data in 1901)
keep if suitable == 1 & map08_yn == 1
* We create the data in a panel format
gen cocoaprod = cocoa_prod27 if year == 1931
replace cocoaprod = 0 if year == 1901
egen upop_1901_std = std(upop_1901)
egen rpop_1901_std = std(rpop_1901)
foreach X in cocoaprod rpop upop pop {
egen `X'_std_01 = std(`X') if year == 1901
egen `X'_std_31 = std(`X') if year == 1931
gen `X'_std = .
replace `X'_std = `X'_std_01 if year == 1901
replace `X'_std = `X'_std_31 if year == 1931
} 
replace cocoaprod_std = 1 if year == 1901
egen minvalue31_std = std(minvalue31)
replace rail18_40 = 0 if year == 1901

xi: areg cocoaprod_std rail18_40 i.year|minvalue31_std i.year*border i.year*sea i.year*upop_1901_std i.year*rpop_1901_std i.year*mincell i.year*dist2accra i.year*dist2river i.year*dist2kumasi i.year*dist2aburi i.year*share_suit i.year*share_highsuit i.year*share_vhighsuit i.year*alt_mean i.year*alt_sd i.year*dist2coast i.year*dist2port_any i.year*av_yr_prec, absorb(gridcell) robust cluster(district_2000)
outreg2 rail18_40 using table_A3.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (ix) Normalization 

use ghana1, clear
* We keep one cross-section, 1931 
keep if year == 1931 
* We restrict the sample to the "forest" (the suitable cells for which we also have total population data in 1901)
keep if suitable == 1 & map08_yn == 1
count
* 554 cells
* We then normalize production variables, the population variables and the value of mineral production
foreach X in upop_1931 upop_1901 rpop_1931 rpop_1901 cocoa_prod27 {
egen `X'_av = mean(`X')
gen `X'_bh = `X'/`X'_av
}
egen minvalue31_std = std(minvalue31)

xi: reg cocoa_prod27_bh rail18_40 minvalue31_std border sea upop_1901_bh rpop_1901_bh mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_40 using table_A3.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (x) Normalization Black and Henderson (1999)
* Production was equal to 0 in 1901, so the change variable is equal to the variable in 1931
xi: reg cocoa_prod27_bh rail18_40 minvalue31_std border sea upop_1901_bh rpop_1901_bh mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_40 using table_A3.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (xi) Log
* We add one ton/inhabitant to cell to account for 0s
gen lcocoa_prod27 = log(cocoa_prod27+1)
gen lupop_1901 = log(upop_1901+1)
gen lrpop_1901 = log(rpop_1901+1)
xi: reg lcocoa_prod27 rail18_40 border sea lupop_1901 lrpop_1901 mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_40 using table_A3.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (xii) Log-log
gen ldist2line18 = log(dist2line18+1)
xi: reg lcocoa_prod27 ldist2line18 border sea lupop_1901 lrpop_1901 mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 ldist2line18 using table_A3.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (xiii) Conley SE (100 km)

use ghana1, clear
* We keep one cross-section, 1931 
keep if year == 1931 
* We restrict the sample to the "forest" (the suitable cells for which we also have total population data in 1901)
keep if suitable == 1 & map08_yn == 1
count
* 554 cells
* We then create the z-scores of the production variables, the population variables and the value of mineral production
foreach X in cocoa_prod27 cocoastat_18 upop_1931 upop_1901 rpop_1931 rpop_1901 pop_1931 city_yn minvalue31    {
egen `X'_std = std(`X') 
}
run gls_sptl.005.do
gls_sptl cocoa_prod27_std rail18_40 : minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, sptlcoef(1) crdlst(latitude longitude) cut(100) 

*** Panel B: Panel B: Dependent Variable = Total Population (Z) in 1931 ***

use ghana1, clear
* We keep one cross-section, 1931 
keep if year == 1931 
* We restrict the sample to the "forest" (the suitable cells for which we also have total population data in 1901)
keep if suitable == 1 & map08_yn == 1
count
* 554 cells
* We then create the z-scores of the production variables, the population variables and the value of mineral production
foreach X in cocoa_prod27 cocoastat_18 upop_1931 upop_1901 rpop_1931 rpop_1901 pop_1931 city_yn minvalue31    {
egen `X'_std = std(`X') 
}

* (0) Baseline
xi: reg pop_1931_std rail18_20 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_20 using table_A3.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (i) No controls
xi: reg pop_1931_std rail18_20 minvalue31_std upop_1901_std rpop_1901_std, robust cluster(district_2000)
outreg2 rail18_20 using table_A3.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (ii) Full sample (standardization to be changed) - we cannot control for rpop_1901_std

use ghana1, clear
* We keep one cross-section, 1931 
keep if year == 1931 
* We then create the z-scores of the production variables, the population variables and the value of mineral production
foreach X in cocoa_prod27 cocoastat_18 upop_1931 upop_1901 rpop_1931 rpop_1901 pop_1931 city_yn minvalue31    {
egen `X'_std = std(`X') 
}

xi: reg pop_1931_std rail18_20 minvalue31_std border sea upop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_20 using table_A3.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (iii) No nodes

use ghana1, clear
* We keep one cross-section, 1931 
keep if year == 1931 
* We restrict the sample to the "forest" (the suitable cells for which we also have total population data in 1901)
keep if suitable == 1 & map08_yn == 1
drop if iv_node == 1
* We then create the z-scores of the production variables, the population variables and the value of mineral production
foreach X in cocoa_prod27 cocoastat_18 upop_1931 upop_1901 rpop_1931 rpop_1901 pop_1931 city_yn minvalue31    {
egen `X'_std = std(`X') 
}

xi: reg pop_1931_std rail18_20 minvalue31_std border sea upop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_20 using table_A3.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (iv) No nodes and no neighbors

use ghana1, clear
* We keep one cross-section, 1931 
keep if year == 1931 
* We restrict the sample to the "forest" (the suitable cells for which we also have total population data in 1901)
keep if suitable == 1 & map08_yn == 1
drop if iv_node == 1
drop if iv_node_neighbor == 1
* We then create the z-scores of the production variables, the population variables and the value of mineral production
foreach X in cocoa_prod27 cocoastat_18 upop_1931 upop_1901 rpop_1931 rpop_1901 pop_1931 city_yn minvalue31    {
egen `X'_std = std(`X') 
}

xi: reg pop_1931_std rail18_20 minvalue31_std border sea upop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_20 using table_A3.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (v) Rail station  

use ghana1, clear
* We keep one cross-section, 1931 
keep if year == 1931 
* We restrict the sample to the "forest" (the suitable cells for which we also have total population data in 1901)
keep if suitable == 1 & map08_yn == 1
count
* 554 cells
* We then create the z-scores of the production variables, the population variables and the value of mineral production
gen pop_1901 = upop_1901+rpop_1901
foreach X in cocoa_prod27 cocoastat_18 upop_1931 upop_1901 rpop_1931 rpop_1901 pop_1931 pop_1901 city_yn minvalue31    {
egen `X'_std = std(`X') 
}

xi: reg pop_1931_std railstat18_20 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 railstat18_20 using table_A3.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (vi) Distance
xi: reg pop_1931_std dist2line18 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 dist2line18 using table_A3.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (vii) Change
sort gridcell year
bysort gridcell: gen pop_1931_std_chg = pop_1931_std - pop_1901_std
xi: reg pop_1931_std_chg rail18_20 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_20 using table_A3.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (viii) Panel 

use ghana1, clear
* We keep one cross-section, 1931 
keep if year == 1901 | year == 1931  
* We restrict the sample to the "forest" (the suitable cells for which we also have total population data in 1901)
keep if suitable == 1 & map08_yn == 1
* We create the data in a panel format
gen cocoaprod = cocoa_prod27 if year == 1931
replace cocoaprod = 0 if year == 1901
egen upop_1901_std = std(upop_1901)
egen rpop_1901_std = std(rpop_1901)
foreach X in cocoaprod rpop upop pop {
egen `X'_std_01 = std(`X') if year == 1901
egen `X'_std_31 = std(`X') if year == 1931
gen `X'_std = .
replace `X'_std = `X'_std_01 if year == 1901
replace `X'_std = `X'_std_31 if year == 1931
} 
replace cocoaprod_std = 1 if year == 1901
egen minvalue31_std = std(minvalue31)
replace rail18_20 = 0 if year == 1901

xi: areg pop_std rail18_20 i.year|minvalue31_std i.year*border i.year*sea i.year*upop_1901_std i.year*rpop_1901_std i.year*mincell i.year*dist2accra i.year*dist2river i.year*dist2kumasi i.year*dist2aburi i.year*share_suit i.year*share_highsuit i.year*share_vhighsuit i.year*alt_mean i.year*alt_sd i.year*dist2coast i.year*dist2port_any i.year*av_yr_prec, absorb(gridcell) robust cluster(district_2000)
outreg2 rail18_20 using table_A3.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (ix) Normalization 

use ghana1, clear
* We keep one cross-section, 1931 
keep if year == 1931 
* We restrict the sample to the "forest" (the suitable cells for which we also have total population data in 1901)
keep if suitable == 1 & map08_yn == 1
count
* 554 cells
* We then normalize production variables, the population variables and the value of mineral production
gen pop_1901 = upop_1901+rpop_1901
foreach X in upop_1931 upop_1901 rpop_1931 rpop_1901 pop_1931 pop_1901 cocoa_prod27 {
egen `X'_av = mean(`X')
gen `X'_bh = `X'/`X'_av
}
egen minvalue31_std = std(minvalue31)

xi: reg pop_1931_bh rail18_20 minvalue31_std border sea upop_1901_bh rpop_1901_bh mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_20 using table_A3.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (x) Normalization Black and Henderson (1999)
bysort gridcell: gen pop_bh_chg = pop_1931_bh - pop_1901_bh
xi: reg pop_bh_chg rail18_20 minvalue31_std border sea upop_1901_bh rpop_1901_bh mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_20 using table_A3.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (xi) Log
* We add one ton/inhabitant to cell to account for 0s
gen lcocoa_prod27 = log(cocoa_prod27+1)
gen lupop_1901 = log(upop_1901+1)
gen lrpop_1901 = log(rpop_1901+1)
gen lpop_1931 = log(pop_1931+1)
xi: reg lpop_1931 rail18_20 border sea lupop_1901 lrpop_1901 mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_20 using table_A3.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (xii) Log-log
gen ldist2line18 = log(dist2line18+1)
xi: reg lpop_1931 ldist2line18 border sea lupop_1901 lrpop_1901 mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 ldist2line18 using table_A3.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (xiii) Conley SE (100 km)

use ghana1, clear
* We keep one cross-section, 1931 
keep if year == 1931 
* We restrict the sample to the "forest" (the suitable cells for which we also have total population data in 1901)
keep if suitable == 1 & map08_yn == 1
count
* 554 cells
* We then create the z-scores of the production variables, the population variables and the value of mineral production
foreach X in cocoa_prod27 cocoastat_18 upop_1931 upop_1901 rpop_1931 rpop_1901 pop_1931 city_yn minvalue31    {
egen `X'_std = std(`X') 
}
run gls_sptl.005.do
gls_sptl pop_1931_std rail18_20 : minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, sptlcoef(1) crdlst(latitude longitude) cut(100) 

*** Panel C: Dependent Variable = Urban Population (Z) in 1931 ***

use ghana1, clear
* We keep one cross-section, 1931 
keep if year == 1931 
* We restrict the sample to the "forest" (the suitable cells for which we also have total population data in 1901)
keep if suitable == 1 & map08_yn == 1
count
* 554 cells
* We then create the z-scores of the production variables, the population variables and the value of mineral production
foreach X in cocoa_prod27 cocoastat_18 upop_1931 upop_1901 rpop_1931 rpop_1901 pop_1931 city_yn minvalue31    {
egen `X'_std = std(`X') 
}

* (0) Baseline
xi: reg upop_1931_std rail18_10 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 using table_A3.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (i) No controls
xi: reg upop_1931_std rail18_10 minvalue31_std upop_1901_std rpop_1901_std, robust cluster(district_2000)
outreg2 rail18_10 using table_A3.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (ii) Full sample (standardization to be changed) - we cannot control for rpop_1901_std

use ghana1, clear
* We keep one cross-section, 1931 
keep if year == 1931 
* We then create the z-scores of the production variables, the population variables and the value of mineral production
foreach X in cocoa_prod27 cocoastat_18 upop_1931 upop_1901 rpop_1931 rpop_1901 pop_1931 city_yn minvalue31    {
egen `X'_std = std(`X') 
}

xi: reg upop_1931_std rail18_10 minvalue31_std border sea upop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 using table_A3.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (iii) No nodes

use ghana1, clear
* We keep one cross-section, 1931 
keep if year == 1931 
* We restrict the sample to the "forest" (the suitable cells for which we also have total population data in 1901)
keep if suitable == 1 & map08_yn == 1
drop if iv_node == 1
* We then create the z-scores of the production variables, the population variables and the value of mineral production
foreach X in cocoa_prod27 cocoastat_18 upop_1931 upop_1901 rpop_1931 rpop_1901 pop_1931 city_yn minvalue31    {
egen `X'_std = std(`X') 
}

xi: reg upop_1931_std rail18_10 minvalue31_std border sea upop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 using table_A3.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (iv) No nodes and no neighbors

use ghana1, clear
* We keep one cross-section, 1931 
keep if year == 1931 
* We restrict the sample to the "forest" (the suitable cells for which we also have total population data in 1901)
keep if suitable == 1 & map08_yn == 1
drop if iv_node == 1
drop if iv_node_neighbor == 1
* We then create the z-scores of the production variables, the population variables and the value of mineral production
foreach X in cocoa_prod27 cocoastat_18 upop_1931 upop_1901 rpop_1931 rpop_1901 pop_1931 city_yn minvalue31    {
egen `X'_std = std(`X') 
}

xi: reg upop_1931_std rail18_10 minvalue31_std border sea upop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 using table_A3.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (v) Rail station  

use ghana1, clear
* We keep one cross-section, 1931 
keep if year == 1931 
* We restrict the sample to the "forest" (the suitable cells for which we also have total population data in 1901)
keep if suitable == 1 & map08_yn == 1
count
* 554 cells
* We then create the z-scores of the production variables, the population variables and the value of mineral production
gen pop_1901 = upop_1901+rpop_1901
foreach X in cocoa_prod27 cocoastat_18 upop_1931 upop_1901 rpop_1931 rpop_1901 pop_1931 pop_1901 city_yn minvalue31    {
egen `X'_std = std(`X') 
}

xi: reg upop_1931_std railstat18_10 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 railstat18_10 using table_A3.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (vi) Distance
xi: reg upop_1931_std dist2line18 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 dist2line18 using table_A3.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (vii) Change
sort gridcell year
bysort gridcell: gen upop_1931_std_chg = upop_1931_std - upop_1901_std
xi: reg upop_1931_std_chg rail18_10 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 using table_A3.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (viii) Panel 

use ghana1, clear
* We keep one cross-section, 1931 
keep if year == 1901 | year == 1931  
* We restrict the sample to the "forest" (the suitable cells for which we also have total population data in 1901)
keep if suitable == 1 & map08_yn == 1
* We create the data in a panel format
gen cocoaprod = cocoa_prod27 if year == 1931
replace cocoaprod = 0 if year == 1901
egen upop_1901_std = std(upop_1901)
egen rpop_1901_std = std(rpop_1901)
foreach X in cocoaprod rpop upop pop {
egen `X'_std_01 = std(`X') if year == 1901
egen `X'_std_31 = std(`X') if year == 1931
gen `X'_std = .
replace `X'_std = `X'_std_01 if year == 1901
replace `X'_std = `X'_std_31 if year == 1931
} 
replace cocoaprod_std = 1 if year == 1901
egen minvalue31_std = std(minvalue31)
replace rail18_10 = 0 if year == 1901

xi: areg upop_std rail18_10 i.year|minvalue31_std i.year*border i.year*sea i.year*upop_1901_std i.year*rpop_1901_std i.year*mincell i.year*dist2accra i.year*dist2river i.year*dist2kumasi i.year*dist2aburi i.year*share_suit i.year*share_highsuit i.year*share_vhighsuit i.year*alt_mean i.year*alt_sd i.year*dist2coast i.year*dist2port_any i.year*av_yr_prec, absorb(gridcell) robust cluster(district_2000)
outreg2 rail18_10 using table_A3.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (ix) Normalization 

use ghana1, clear
* We keep one cross-section, 1931 
keep if year == 1931 
* We restrict the sample to the "forest" (the suitable cells for which we also have total population data in 1901)
keep if suitable == 1 & map08_yn == 1
count
* 554 cells
* We then normalize production variables, the population variables and the value of mineral production
gen pop_1901 = upop_1901+rpop_1901
foreach X in upop_1931 upop_1901 rpop_1931 rpop_1901 pop_1931 pop_1901 cocoa_prod27 {
egen `X'_av = mean(`X')
gen `X'_bh = `X'/`X'_av
}
egen minvalue31_std = std(minvalue31)

xi: reg upop_1931_bh rail18_10 minvalue31_std border sea upop_1901_bh rpop_1901_bh mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 using table_A3.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (x) Normalization Black and Henderson (1999)
bysort gridcell: gen upop_bh_chg = upop_1931_bh - upop_1901_bh
xi: reg upop_bh_chg rail18_10 minvalue31_std border sea upop_1901_bh rpop_1901_bh mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 using table_A3.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (xi) Log
* We add one ton/inhabitant to cell to account for 0s
gen lcocoa_prod27 = log(cocoa_prod27+1)
gen lupop_1901 = log(upop_1901+1)
gen lrpop_1901 = log(rpop_1901+1)
gen lupop_1931 = log(upop_1931+1)
xi: reg lupop_1931 rail18_10 border sea lupop_1901 lrpop_1901 mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 using table_A3.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (xii) Log-log
gen ldist2line18 = log(dist2line18+1)
xi: reg lupop_1931 ldist2line18 border sea lupop_1901 lrpop_1901 mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 ldist2line18 using table_A3.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (xiii) Conley SE (100 km)

use ghana1, clear
* We keep one cross-section, 1931 
keep if year == 1931 
* We restrict the sample to the "forest" (the suitable cells for which we also have total population data in 1901)
keep if suitable == 1 & map08_yn == 1
count
* 554 cells
* We then create the z-scores of the production variables, the population variables and the value of mineral production
foreach X in cocoa_prod27 cocoastat_18 upop_1931 upop_1901 rpop_1931 rpop_1901 pop_1931 city_yn minvalue31    {
egen `X'_std = std(`X') 
}
run gls_sptl.005.do
gls_sptl upop_1931_std rail18_10 : minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, sptlcoef(1) crdlst(latitude longitude) cut(100) 

*******************************************************************************************************
* WEB APPENDIX TABLE 4: RAILROADS AND ANTHROPOMETRIC OUTCOMES FOR GHANAIAN SOLDIERS, GHANA, 1867-1937 *
*******************************************************************************************************

* We use the data set of Moradi (2009). See the replication files of this paper for details.
* The data set gcr.csv contains our variables of interest 
clear
insheet using "gcr.csv"
label var gridcell "Gridcell of Birth"
label var age_years "Age in Years"
label var ht_cm "Height in cm"
label var ethnic3 "Ethnic Group"
label var ww1 "Was Recruited during World War 1"
label var ww2 "Was Recruited during World War 2"
label var farmer "Was a Farmer Before Being Recruited"
label var literate "Is Literate"
label var yob "Year of Birth"
sort gridcell 
save gcr, replace

use ghana1, clear
* We keep one cross-section, 1931 
keep if year == 1931 
* We restrict the sample to the "forest" (the suitable cells for which we also have total population data in 1901)
keep if suitable == 1 & map08_yn == 1
count
* 554 cells
* We then create the z-scores of the production variables, the population variables and the value of mineral production
foreach X in cocoa_prod27 cocoastat_18 upop_1931 upop_1901 rpop_1931 rpop_1901 pop_1931 city_yn minvalue31    {
egen `X'_std = std(`X') 
}
* We merge the data set with the soldier height data set 
sort gridcell 
merge gridcell using gcr
tab _m 
drop if _m == 1
* These are the cells for which we have no soldiers 
drop if _m == 2
* These are the soldiers that are not in the forest sample
keep if _m == 3
drop _m
codebook gridcell
* We have 6,605 soldiers accross 308 gridcells (< 554 suitable cells)
drop if yob == .
* We drop the observations for which the year of birth is missing
gen post18 = (yob >= 1918)
* We create this dummy to compare the recuits born along the lines before and after 1918
keep if age_years >= 18
* We only focus on soldiers who have stopped growing, i.e. the soldiers aged 18 or more 
gen ww = (ww1 == 1 | ww2 == 1)
* We create a World War (ww) dummy, since the recruitment process of soliders was probably different in those years
* We include various controls: 
* ethnic3: ethnic group of the soldier (N = 8)
* farmer: whether the soldier was a farmer before
* literate: whether the soldier knows how to read and write
* age_years: age of the soldier in years

xi: reg ht_cm i.rail18_10*i.post18 i.ethnic3 i.farmer i.literate i.ww i.age_years minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 _Irail18_10_1 _Ipost18_1 _IraiXpos_1_1 using table_A4.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) replace

**********************************************************************************************************
* WEB APPENDIX TABLE 5: COLONIAL RAILROADS, POPULATION GROWTH AND CONTEMPORARY FACTORS, GHANA, 1901-2000 *
**********************************************************************************************************

use ghana1, clear
* We keep one cross-section, 2000
keep if year == 2000 
* We restrict the sample to the "forest" (the suitable cells for which we also have total population data in 1901)
keep if suitable == 1 & map08_yn == 1
* We drop the city of Kumasi that has been growing a lot for political reasons in the post-independence period
drop if gridcell == "S49"
count
* 553 cells
* We then create the z-scores of the production variables, the population variables and the value of mineral production
foreach X in cocoa_prod27 cocoastat_18 pop_2000 upop_2000 rpop_2000 upop_1931 upop_1901 rpop_1931 rpop_1901 city_yn minvalue31    {
egen `X'_std = std(`X') 
}

*** Panel A: Railroads and contemporary factors in 2000 ***

* (1) Rural Population 2000
xi: reg rpop_2000_std rail18_10 rail18_1020 rail18_2030 rail18_3040 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 rail18_1020 rail18_2030 rail18_3040 using table_A5.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) replace

* (2) Urban Population 2000
xi: reg upop_2000_std rail18_10 rail18_1020 rail18_2030 rail18_3040 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 rail18_1020 rail18_2030 rail18_3040 using table_A5.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (3) Total Population 2000
xi: reg pop_2000_std rail18_10 rail18_1020 rail18_2030 rail18_3040 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 rail18_1020 rail18_2030 rail18_3040 using table_A5.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (4) Urbanization Rate (%) 2000, while controlling for the urbanization rate in 1901
gen urbrate00 = upop_2000/pop_2000*100
replace urbrate00 = 0 if urbrate00 == .
sum urbrate00
xi: reg urbrate00 rail18_10 rail18_1020 rail18_2030 rail18_3040 urbrate01 minvalue31_std border sea mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 rail18_1020 rail18_2030 rail18_3040 using table_A5.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (5) Paved or Improved Road 2000
gen pavimproved_2000 = (paved_2000 == 1 | improved_2000 == 1)
replace pavimproved_2000 = pavimproved_2000*100
* expressed in %
sum pavimproved_2000
xi: reg pavimproved_2000 rail18_10 rail18_1020 rail18_2030 rail18_3040 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 rail18_1020 rail18_2030 rail18_3040 using table_A5.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (6) Secondary School (%)
gen jsss_sh = (jss_sh+sss_sh)/2
* We take the average of the two measures
sum jsss_sh
xi: reg sss_sh rail18_10 rail18_1020 rail18_2030 rail18_3040 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 rail18_1020 rail18_2030 rail18_3040 using table_A5.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (7) Health Clinic (%)
sum clinic_sh
xi: reg clinic_sh rail18_10 rail18_1020 rail18_2030 rail18_3040 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 rail18_1020 rail18_2030 rail18_3040 using table_A5.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (8) Hospital (%)
sum hosp_sh
xi: reg hosp_sh rail18_10 rail18_1020 rail18_2030 rail18_3040 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 rail18_1020 rail18_2030 rail18_3040 using table_A5.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

*** Panel B: Railroads and contemporary factors in 2000, conditioned on population in 2000 ***

* (5) Paved or Improved Road
xi: reg pavimproved_2000 rail18_10 rail18_1020 rail18_2030 rail18_3040 upop_2000_std rpop_2000_std minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 rail18_1020 rail18_2030 rail18_3040 using table_A5.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (6) Senior Secondary School (%)
xi: reg sss_sh rail18_10 rail18_1020 rail18_2030 rail18_3040 upop_2000_std rpop_2000_std minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 rail18_1020 rail18_2030 rail18_3040 using table_A5.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (7) Health Clinic (%)
xi: reg clinic_sh rail18_10 rail18_1020 rail18_2030 rail18_3040 upop_2000_std rpop_2000_std minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 rail18_1020 rail18_2030 rail18_3040 using table_A5.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (8) Hospital (%)
xi: reg hosp_sh rail18_10 rail18_1020 rail18_2030 rail18_3040 upop_2000_std rpop_2000_std minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 rail18_1020 rail18_2030 rail18_3040 using table_A5.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

*******************************************************************************
* WEB APPENDIX TABLE 6: ROBUSTNESS AND SPECIFICATION CHECKS, GHANA, 1901-2000 *
*******************************************************************************

use ghana1, clear
* We keep one cross-section, 1931 
keep if year == 2000
* We restrict the sample to the "forest" (the suitable cells for which we also have total population data in 1901)
keep if suitable == 1 & map08_yn == 1
* We drop the city of Kumasi that has been growing a lot for political reasons in the post-independence period
drop if gridcell == "S49"
* We then create the z-scores of the production variables, the population variables and the value of mineral production
foreach X in cocoa_prod27 cocoastat_18 upop_2000 upop_1931 upop_1901 rpop_1931 rpop_1901 pop_1931 city_yn minvalue31    {
egen `X'_std = std(`X') 
}

* (0) Baseline
xi: reg upop_2000_std rail18_10 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 using table_A6.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (i) No controls
xi: reg upop_2000_std rail18_10 minvalue31_std upop_1901_std rpop_1901_std, robust cluster(district_2000)
outreg2 rail18_10 using table_A6.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (ii) Full sample (standardization to be changed) - we cannot control for rpop_1901_std

use ghana1, clear
* We keep one cross-section, 1931 
keep if year == 2000 
* We then create the z-scores of the production variables, the population variables and the value of mineral production
foreach X in cocoa_prod27 cocoastat_18 upop_2000 upop_1931 upop_1901 rpop_1931 rpop_1901 pop_1931 city_yn minvalue31    {
egen `X'_std = std(`X') 
}

xi: reg upop_2000_std rail18_10 minvalue31_std border sea upop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 using table_A6.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (iii) No nodes

use ghana1, clear
* We keep one cross-section, 1931 
keep if year == 2000
* We restrict the sample to the "forest" (the suitable cells for which we also have total population data in 1901)
keep if suitable == 1 & map08_yn == 1
* We drop the city of Kumasi that has been growing a lot for political reasons in the post-independence period
drop if gridcell == "S49"
drop if iv_node == 1
* We then create the z-scores of the production variables, the population variables and the value of mineral production
foreach X in cocoa_prod27 cocoastat_18 upop_2000 upop_1931 upop_1901 rpop_1931 rpop_1901 pop_1931 city_yn minvalue31    {
egen `X'_std = std(`X') 
}

xi: reg upop_2000_std rail18_10 minvalue31_std border sea upop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 using table_A6.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (iv) No nodes and no neighbors

use ghana1, clear
* We keep one cross-section, 1931 
keep if year == 2000
* We restrict the sample to the "forest" (the suitable cells for which we also have total population data in 1901)
keep if suitable == 1 & map08_yn == 1
* We drop the city of Kumasi that has been growing a lot for political reasons in the post-independence period
drop if gridcell == "S49"
drop if iv_node == 1
drop if iv_node_neighbor == 1
* We then create the z-scores of the production variables, the population variables and the value of mineral production
foreach X in cocoa_prod27 cocoastat_18 upop_2000 upop_1931 upop_1901 rpop_1931 rpop_1901 pop_1931 city_yn minvalue31    {
egen `X'_std = std(`X') 
}

xi: reg upop_2000_std rail18_10 minvalue31_std border sea upop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 using table_A6.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (v) Rail station  

use ghana1, clear
* We keep one cross-section, 1931 
keep if year == 2000
* We restrict the sample to the "forest" (the suitable cells for which we also have total population data in 1901)
keep if suitable == 1 & map08_yn == 1
* We drop the city of Kumasi that has been growing a lot for political reasons in the post-independence period
drop if gridcell == "S49"
* We then create the z-scores of the production variables, the population variables and the value of mineral production
foreach X in cocoa_prod27 cocoastat_18 upop_2000 upop_1931 upop_1901 rpop_1931 rpop_1901 pop_1931 city_yn minvalue31    {
egen `X'_std = std(`X') 
}

xi: reg upop_2000_std railstat18_10 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 railstat18_10 using table_A6.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (vi) Distance
xi: reg upop_2000_std dist2line18 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 dist2line18 using table_A6.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (vii) Change
sort gridcell year
bysort gridcell: gen upop_2000_std_chg = upop_2000_std - upop_1901_std
xi: reg upop_2000_std_chg rail18_10 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 using table_A6.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (viii) Panel 

use ghana1, clear
keep if year == 1901 | year == 2000 
* We restrict the sample to the "forest" (the suitable cells for which we also have total population data in 1901)
keep if suitable == 1 & map08_yn == 1
* We create the data in a panel format
egen upop_1901_std = std(upop_1901)
egen rpop_1901_std = std(rpop_1901)
foreach X in rpop upop pop {
egen `X'_std_01 = std(`X') if year == 1901
egen `X'_std_00 = std(`X') if year == 2000
gen `X'_std = .
replace `X'_std = `X'_std_01 if year == 1901
replace `X'_std = `X'_std_00 if year == 2000
} 
egen minvalue31_std = std(minvalue31)
replace rail18_10 = 0 if year == 1901

xi: areg upop_std rail18_10 i.year|minvalue31_std i.year*border i.year*sea i.year*rpop_1901_std i.year*mincell i.year*dist2accra i.year*dist2river i.year*dist2kumasi i.year*dist2aburi i.year*share_suit i.year*share_highsuit i.year*share_vhighsuit i.year*alt_mean i.year*alt_sd i.year*dist2coast i.year*dist2port_any i.year*av_yr_prec, absorb(gridcell) robust cluster(district_2000)
outreg2 rail18_10 using table_A6.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (ix) Normalization 

use ghana1, clear
* We keep one cross-section, 1931 
keep if year == 2000 
* We restrict the sample to the "forest" (the suitable cells for which we also have total population data in 1901)
keep if suitable == 1 & map08_yn == 1
count
* 554 cells
* We then normalize production variables, the population variables and the value of mineral production
gen pop_1901 = upop_1901+rpop_1901
foreach X in upop_1931 upop_2000 upop_1901 rpop_1931 rpop_1901 pop_1931 pop_1901 cocoa_prod27 {
egen `X'_av = mean(`X')
gen `X'_bh = `X'/`X'_av
}
egen minvalue31_std = std(minvalue31)

xi: reg upop_2000_bh rail18_10 minvalue31_std border sea upop_1901_bh rpop_1901_bh mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 using table_A6.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (x) Normalization Black and Henderson (1999)
bysort gridcell: gen upop_bh_chg = upop_2000_bh - upop_1901_bh
xi: reg upop_bh_chg rail18_10 minvalue31_std border sea upop_1901_bh rpop_1901_bh mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 using table_A6.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (xi) Log
* We add one ton/inhabitant to cell to account for 0s
gen lcocoa_prod27 = log(cocoa_prod27+1)
gen lupop_1901 = log(upop_1901+1)
gen lrpop_1901 = log(rpop_1901+1)
gen lupop_2000 = log(upop_2000+1)
xi: reg lupop_2000 rail18_10 border sea lupop_1901 lrpop_1901 mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 using table_A6.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (xii) Log-log
gen ldist2line18 = log(dist2line18+1)
xi: reg lupop_2000 ldist2line18 border sea lupop_1901 lrpop_1901 mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 ldist2line18 using table_A6.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (xiii) Conley SE (100 km)

use ghana1, clear
* We keep one cross-section, 2000 
keep if year == 2000 
* We restrict the sample to the "forest" (the suitable cells for which we also have total population data in 1901)
keep if suitable == 1 & map08_yn == 1
count
* 554 cells
* We then create the z-scores of the production variables, the population variables and the value of mineral production
foreach X in cocoa_prod27 cocoastat_18 upop_2000 upop_1931 upop_1901 rpop_1931 rpop_1901 pop_1931 city_yn minvalue31    {
egen `X'_std = std(`X') 
}
run gls_sptl.005.do
gls_sptl upop_2000_std rail18_10 : minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, sptlcoef(1) crdlst(latitude longitude) cut(100) 

*********************************************************************************************
* WEB APPENDIX TABLE 7: SENSITIVITY OF RESULTS TO VARIOUS CITY THRESHOLDS, GHANA, 1901-2000 *
*********************************************************************************************

use ghana1, clear
* We keep one cross-section, 1931 
keep if year == 2000
* We restrict the sample to the "forest" (the suitable cells for which we also have total population data in 1901)
keep if suitable == 1 & map08_yn == 1
* We drop the city of Kumasi that has been growing a lot for political reasons in the post-independence period
drop if gridcell == "S49"
* We then create the z-scores of the production variables, the population variables and the value of mineral production
foreach X in upop10000_2000 upop15000_2000 upop20000_2000 upop1666_2000 upop5000_2000 upop2000_2000 upop_2000 upop_1931 upop_1901 rpop_1931 rpop_1901 pop_1931 city_yn minvalue31    {
egen `X'_std = std(`X') 
}

* (1) Baseline
xi: reg upop_2000_std rail18_10 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 using table_A7.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) replace

* (2) 1666
xi: reg upop1666_2000_std rail18_10 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 using table_A7.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (3) 10,000
xi: reg upop10000_2000_std rail18_10 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 using table_A7.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (4) 2,000
xi: reg upop2000_2000_std rail18_10 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 using table_A7.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (5) 5,000
xi: reg upop5000_2000_std rail18_10 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 using table_A7.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (6) 15,000
xi: reg upop15000_2000_std rail18_10 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 using table_A7.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (7) 20,000
xi: reg upop20000_2000_std rail18_10 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 using table_A7.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

***********************************************************************
* WEB APPENDIX TABLE 8: SIZE DISTRIBUTION OF CITIES, GHANA, 1960-2000 *
***********************************************************************

* See the word document in the folder "Tables\Web Appendix Tables\TableA8"

****************************************************************************
* WEB APPENDIX TABLE 9: IDENTIFICATION STRATEGIES, ROADS, GHANA, 1901-2000 *
****************************************************************************

use ghana1, clear
* We keep one cross-section, 1931 
keep if year == 2000
* We restrict the sample to the "forest" (the suitable cells for which we also have total population data in 1901)
keep if suitable == 1 & map08_yn == 1
* We drop the city of Kumasi that has been growing a lot for political reasons in the post-independence period
drop if gridcell == "S49"
* We then create the z-scores of the production variables, the population variables and the value of mineral production
foreach X in upop_2000 upop_1931 upop_1901 rpop_1931 rpop_1901 pop_1931 city_yn minvalue31    {
egen `X'_std = std(`X') 
}

* (1): OLS
xi: reg upop_2000_std rail18_10 paved_2000_10 improved_2000_10 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000) 
outreg2 rail18_10 paved_2000_10 improved_2000_10 using table_A9.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) replace

* (2): ETHNIC GROUP FE
xi: reg upop_2000_std rail18_10 paved_2000_10 improved_2000_10 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec i.ethnic, robust cluster(district_2000) 
outreg2 rail18_10 paved_2000_10 improved_2000_10 using table_A9.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (3): DISTRICT FE
xi: reg upop_2000_std rail18_10 paved_2000_10 improved_2000_10 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec i.district_2000, robust cluster(district_2000) 
outreg2 rail18_10 paved_2000_10 improved_2000_10 using table_A9.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (4): FOURTH ORDER POLYNOMIAL IN LONGITUDE AND LATITUDE
xi: reg upop_2000_std rail18_10 paved_2000_10 improved_2000_10 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec long1 long2 long3 long4 lat1 lat2 lat3 lat4, robust cluster(district_2000) 
outreg2 rail18_10 paved_2000_10 improved_2000_10 using table_A9.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (5) IV: Straight Lines for Railroads & Roads 1931 for Roads 
xi: ivreg2 upop_2000_std (rail18_10 paved_2000_10 = iv_40 class1_1931_10 class2_1931_10) improved_2000_10 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000) first
outreg2 rail18_10 paved_2000_10 improved_2000_10 using table_A9.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (5) 1st Stage for rail18_10 
xi: reg rail18_10 iv_40 class1_1931_10 class2_1931_10 improved_2000_10 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000) 
outreg2 iv_40 class1_1931_10 class2_1931_10 using table_A9.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (5) 1st Stage for paved_2000_10 
xi: reg paved_2000_10 iv_40 class1_1931_10 class2_1931_10 improved_2000_10 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000) 
outreg2 iv_40 class1_1931_10 class2_1931_10 using table_A9.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (6) IV: Straight Lines for Railroads & Routes 1850 for Roads 
xi: ivreg2 upop_2000_std (rail18_10 paved_2000_10 = iv_40 dist2traderoute10) improved_2000_10 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000) first
outreg2 rail18_10 paved_2000_10 improved_2000_10 using table_A9.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (6) 1st Stage for rail18_10 
xi: reg rail18_10 iv_40 dist2traderoute10 improved_2000_10 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000) 
outreg2 iv_40 dist2traderoute10 using table_A9.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (6) 1st Stage for paved_2000_10 
xi: reg paved_2000_10 iv_40 dist2traderoute10 improved_2000_10 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000) 
outreg2 iv_40 dist2traderoute10 using table_A9.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (7) IV: Straight Lines for Railroads & Roads 1931 + Routes 1850 for Roads
xi: ivreg2 upop_2000_std (rail18_10 paved_2000_10 = iv_40 dist2traderoute10 class1_1931_10 class2_1931_10) improved_2000_10 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000) first
outreg2 rail18_10 paved_2000_10 improved_2000_10 using table_A9.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (7) 1st Stage for rail18_10 
xi: reg rail18_10 iv_40 dist2traderoute10 class1_1931_10 class2_1931_10 improved_2000_10 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000) 
outreg2 iv_40 dist2traderoute10 class1_1931_10 class2_1931_10 using table_A9.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (7) 1st Stage for paved_2000_10 
xi: reg paved_2000_10 iv_40 dist2traderoute10 class1_1931_10 class2_1931_10 improved_2000_10 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000) 
outreg2 iv_40 dist2traderoute10 class1_1931_10 class2_1931_10 using table_A9.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

************************************************************************
* WEB APPENDIX TABLE 10: RAILROADS, ROADS AND CITIES, GHANA, 1901-2000 *
************************************************************************

** 1901-1931 **

use ghana1, clear
* We keep one cross-section, 1931 
keep if year == 1931
* We restrict the sample to the "forest" (the suitable cells for which we also have total population data in 1901)
keep if suitable == 1 & map08_yn == 1
* We then create the z-scores of the production variables, the population variables and the value of mineral production
foreach X in upop_2000 upop_1931 upop_1901 rpop_1931 rpop_1901 pop_1931 city_yn minvalue31    {
egen `X'_std = std(`X') 
}

* (1) Urban Pop. 1931
xi: reg upop_1931_std rail18_10 rail18_1020 rail18_2030 rail18_3040 rail1856_10 class1_1931_10 class2_1931_10 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 rail18_10 rail18_1020 rail1856_10 class1_1931_10 class2_1931_10 using table_A10.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) replace

* (2) City 1/0 1931
xi: reg city_yn_std rail18_10 rail18_1020 rail18_2030 rail18_3040 rail1856_10 class1_1931_10 class2_1931_10 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 rail18_10 rail18_1020 rail1856_10 class1_1931_10 class2_1931_10 using table_A10.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

** 1931-1960 **

use ghana1, clear
* We keep one cross-section, 1931 
keep if year == 1960
* We restrict the sample to the "forest" (the suitable cells for which we also have total population data in 1901)
keep if suitable == 1 & map08_yn == 1
* We then create the z-scores of the production variables, the population variables and the value of mineral production
foreach X in upop_2000 upop_1960 upop_1931 upop_1901 rpop_1931 rpop_1901 pop_1931 city_yn minvalue31    {
egen `X'_std = std(`X') 
}

* (3) Urban Pop. 1960
xi: reg upop_1960_std rail18_10 rail18_1020 rail18_2030 rail18_3040 upop_1931_std rpop_1931_std rail1856_10 paved_1960_10 improved_1960_10 class1_1931_10 class2_1931_10 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 rail18_10 rail18_1020 rail1856_10 class1_1931_10 class2_1931_10 paved_1960_10 improved_1960_10 using table_A10.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (4) City 1/0 1960
xi: reg city_yn_std rail18_10 rail18_1020 rail18_2030 rail18_3040 upop_1931_std rpop_1931_std rail1856_10 paved_1960_10 improved_1960_10 class1_1931_10 class2_1931_10 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 rail18_10 rail18_1020 rail1856_10 class1_1931_10 class2_1931_10 paved_1960_10 improved_1960_10 using table_A10.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append


** 1960-2000 **

use ghana1, clear
* We keep one cross-section, 1931 
keep if year == 1960
* We restrict the sample to the "forest" (the suitable cells for which we also have total population data in 1901)
keep if suitable == 1 & map08_yn == 1
* We drop the city of Kumasi that has been growing a lot for political reasons in the post-independence period
drop if gridcell == "S49"
* We then create the z-scores of the production variables, the population variables and the value of mineral production
foreach X in upop_2000 rpop_1970 upop_1960 upop_1931 upop_1901 rpop_1931 rpop_1901 pop_1931 city_yn minvalue31    {
egen `X'_std = std(`X') 
}

* (5) Urban Pop. 1960
xi: reg upop_2000_std rail18_10 rail18_1020 rail18_2030 rail18_3040 upop_1960_std rpop_1970_std upop_1931_std rpop_1931_std rail1856_10 paved_1960_10 improved_1960_10 paved_2000_10 improved_2000_10 class1_1931_10 class2_1931_10 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 rail18_10 rail18_1020 rail1856_10 class1_1931_10 class2_1931_10 paved_1960_10 improved_1960_10 paved_2000_10 improved_2000_10 using table_A10.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (6) Urban Pop. 1960
xi: reg city_yn_std rail18_10 rail18_1020 rail18_2030 rail18_3040 upop_1960_std rpop_1970_std upop_1931_std rpop_1931_std rail1856_10 paved_1960_10 improved_1960_10 paved_2000_10 improved_2000_10 class1_1931_10 class2_1931_10 minvalue31_std border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 rail18_10 rail18_1020 rail1856_10 class1_1931_10 class2_1931_10 paved_1960_10 improved_1960_10 paved_2000_10 improved_2000_10 using table_A10.xls, se nocons coefastr adjr2 bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

***************************************************************************
* WEB APPENDIX TABLE 11: ROBUSTNESS FOR PATH DEPENDENCE, GHANA, 1901-2000 *
***************************************************************************

use ghana1, clear
keep if year == 2000
* We restrict the sample to the "forest" (the suitable cells for which we also have total population data in 1901)
keep if suitable == 1 & map08_yn == 1
* We drop the city of Kumasi that has been growing a lot for political reasons in the post-independence period
drop if gridcell == "S49"
* We then create the z-scores of the production variables, the population variables and the value of mineral production
foreach X in cocoastat_18 upop_2000 rpop_1970 upop_1960 upop_1931 upop_1901 rpop_1931 rpop_1901 pop_1931 city_yn minvalue31    {
egen `X'_std = std(`X') 
}

* (1) Main
xi: reg upop_2000_std rail18_10 rail18_1020 rail18_2030 rail18_3040 upop_1931_std rpop_1931_std minvalue31_std paved_2000_10 improved_2000_10 border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 rail18_1020 rail18_2030 rail18_3040 paved_2000_10 improved_2000_10 upop_1931_std rpop_1931_std using table_A11.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) replace

* (2) Also controlling for historical factors in 1901 1931
xi: reg upop_2000_std rail18_10 rail18_1020 rail18_2030 rail18_3040 upop_1931_std rpop_1931_std minvalue31_std paved_2000_10 improved_2000_10 class3_1901_10 class3_1931_10 class2_1931_10 class1_1931_10 church_yn1931 church_num1931 church_yn1901 church_num1901 hosp_1901 hosp_1931 school1901 school1931 school1901_yn school1931_yn border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 rail18_1020 rail18_2030 rail18_3040 paved_2000_10 improved_2000_10 upop_1931_std rpop_1931_std using table_A11.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (3) Also controlling for historical factors squared in 1901 1931
foreach X of varlist church_num1931 church_num1901 school1901 school1931 {
gen `X'_sq = `X'*`X'
}
xi: reg upop_2000_std rail18_10 rail18_1020 rail18_2030 rail18_3040 upop_1931_std rpop_1931_std minvalue31_std paved_2000_10 improved_2000_10 *sq class3_1901_10 class3_1931_10 class2_1931_10 class1_1931_10 church_yn1931 church_num1931 church_yn1901 church_num1901 hosp_1901 hosp_1931 school1901 school1931 school1901_yn school1931_yn border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 rail18_1020 rail18_2030 rail18_3040 paved_2000_10 improved_2000_10 upop_1931_std rpop_1931_std using table_A11.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (4) Also controlling for historical factors interacted in 1901 1931
set matsize 800
set emptycells drop
* interactions of dummies with human capital + interactions for road dummies
reg upop_2000_std rail18_10 rail18_1020 rail18_2030 rail18_3040 upop_1931_std rpop_1931_std school1931_sq church_num1931_sq i.hosp_1901##i.school1901_yn##i.church_yn1901 i.hosp_1931##i.school1931_yn##i.church_yn1931 i.class3_1931_10##i.class2_1931_10##i.class1_1931_10 minvalue31_std paved_2000_10 improved_2000_10 class3_1901_10 class3_1931_10 class2_1931_10 class1_1931_10 church_yn1931 church_num1931 church_yn1901 church_num1901 hosp_1901 hosp_1931 school1901 school1931 school1901_yn school1931_yn border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 rail18_1020 rail18_2030 rail18_3040 paved_2000_10 improved_2000_10 upop_1931_std rpop_1931_std using table_A11.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

* (5) Also controlling for cocoa production in 1931, cocoa at rail station in 1918 and a dummy equal to one if the cell contains a rail station in 1918
reg upop_2000_std rail18_10 rail18_1020 rail18_2030 rail18_3040 upop_1931_std rpop_1931_std cocoa_prod27 cocoastat_18_std railstat_yn18 school1931_sq church_num1931_sq i.hosp_1901##i.school1901_yn##i.church_yn1901 i.hosp_1931##i.school1931_yn##i.church_yn1931 i.class3_1931_10##i.class2_1931_10##i.class1_1931_10 minvalue31_std paved_2000_10 improved_2000_10 class3_1901_10 class3_1931_10 class2_1931_10 class1_1931_10 church_yn1931 church_num1931 church_yn1901 church_num1901 hosp_1901 hosp_1931 school1901 school1931 school1901_yn school1931_yn border sea upop_1901_std rpop_1901_std mincell dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)
outreg2 rail18_10 rail18_1020 rail18_2030 rail18_3040 paved_2000_10 improved_2000_10 upop_1931_std rpop_1931_std using table_A11.xls, se nocons coefastr bdec(2) noni nolabel bracket title(Effect, "") nonotes addnote("", Robust standard errors in parentheses, * significant at 10%; ** significant at 5%; *** significant at 1%) append

**********************************************************************
* WEB APPENDIX FIGURE 4: RAILROAD EFFECTS FOR EACH PERIOD, 1891-2000 *
**********************************************************************

use ghana1, clear
keep if map08_yn == 1 & suitable == 1
* We create the four railroad dummies for each year
foreach X in 1891 1901 1931 1948 1960 1970 1984  2000 {
gen rail18_10_`X' = 0
replace rail18_10_`X' = (dist2line18>0 & dist2line18<=10) if year == `X'
gen rail18_1020_`X' = 0
replace rail18_1020_`X' = (dist2line18>10 & dist2line18<=20) if year == `X'
gen rail18_2030_`X' = 0
replace rail18_2030_`X' = (dist2line18>20 & dist2line18<=30) if year == `X'
gen rail18_3040_`X' = 0
replace rail18_3040_`X' = (dist2line18>30 & dist2line18<=40) if year == `X'
}
* We create the standardized value of the urban population for each year
egen zupop1891 = std(upop) if year == 1891
egen zupop1901 = std(upop) if year == 1901
egen zupop1931 = std(upop) if year == 1931
egen zupop1948 = std(upop) if year == 1948
egen zupop1960 = std(upop) if year == 1960
egen zupop1970 = std(upop) if year == 1970
egen zupop1984 = std(upop) if year == 1984
egen zupop2000 = std(upop) if year == 2000
gen zupop = 0
replace zupop = zupop1891 if year == 1891
replace zupop = zupop1901 if year == 1901
replace zupop = zupop1931 if year == 1931
replace zupop = zupop1948 if year == 1948
replace zupop = zupop1960 if year == 1960
replace zupop = zupop1970 if year == 1970
replace zupop = zupop1984 if year == 1984
replace zupop = zupop2000 if year == 2000
* We create the controls
egen upop_1901_std = std(upop_1901)
egen rpop_1901_std = std(upop_1901)
egen minvalue31_std = std(minvalue31)
* We create the lag of the dependent variable
sort gridcell year
bysort gridcell: gen zupop_lag = zupop[_n-1]
* We create a new dependent variable, the change in the z-score of urban population
* We do so to avoid the dynamic panel bias of Nickell (1981)
sort gridcell year
bysort gridcell: gen zupop_chg = zupop-zupop_lag

* The baseline regression is the same as for Figure 5

* Railroad 0-10 km (Regression with Cell FE)
* We omit the year 2000
xi: areg zupop_chg rail18_10_1901 rail18_1020_1901 rail18_2030_1901 rail18_3040_1901 rail18_10_1931 rail18_1020_1931 rail18_2030_1931 rail18_3040_1931 rail18_10_1948 rail18_1020_1948 rail18_2030_1948 rail18_3040_1948 rail18_10_1960 rail18_1020_1960 rail18_2030_1960 rail18_3040_1960 rail18_10_1970 rail18_1020_1970 rail18_2030_1970 rail18_3040_1970 rail18_10_1984 rail18_1020_1984 rail18_2030_1984 rail18_3040_1984 i.year i.year*border i.year*sea i.year*rpop_1901_std i.year*mincell i.year*dist2accra i.year*dist2river i.year*dist2kumasi i.year*dist2aburi i.year*share_suit i.year*share_highsuit i.year*share_vhighsuit i.year*alt_mean i.year*alt_sd i.year*dist2coast i.year*dist2port_any i.year*av_yr_prec, absorb(gridcell) robust cluster(district_2000)
* We export these coefficients manually in the excel file "Figure_4_Coefficients"

* Railroad 0-10 km (Regression with Cell FE and Cell-Specific Linear Trend)
* We omit the years 1901 and 2000
xi: areg zupop_chg rail18_10_1901 rail18_1020_1901 rail18_2030_1901 rail18_3040_1901 rail18_10_1931 rail18_1020_1931 rail18_2030_1931 rail18_3040_1931 rail18_10_1948 rail18_1020_1948 rail18_2030_1948 rail18_3040_1948 rail18_10_1960 rail18_1020_1960 rail18_2030_1960 rail18_3040_1960 rail18_10_1970 rail18_1020_1970 rail18_2030_1970 rail18_3040_1970 rail18_10_1984 rail18_1020_1984 rail18_2030_1984 rail18_3040_1984 i.year i.gridcell|year, absorb(gridcell) robust cluster(district_2000)
* We export these coefficients manually in the excel file "Figure_4_Coefficients"

* Using Figure_4_Coefficients.xls, we create "data_for_figure_A4_gh.xls" using excel
* This excel file shows the coefficient of the 0-10 km dummy and the coefficient of Ut-1
clear
import excel "data_for_figure_A4_gh.xls", sheet("stata") firstrow
* select the effects for Ghana only
keep if gh10 != .
replace yearnum = 7 if yearnum == 8
* We first create the figure as best as possible
twoway (connected gh10 yearnum, mcolor(black) msize(medlarge) msymbol(circle) lcolor(black) lwidth(thick) lpattern(solid))(line gh10_fe yearnum, lcolor(gs10) lwidth(medthick) lpattern(solid))(connected gh10_trend yearnum, mcolor(black) msize(medlarge) msymbol(circle) lcolor(black) lwidth(medthick) lpattern(dash)), xtitle(.) xtitle(, size(zero)) xlabel(1(1)7) legend(order(1 "Railroad 0-10 km" 2 "Railroad 0-10 km (Regression with Cell FE)" 3 "Railroad 0-10 km (Regression with Cell FE and Cell-Specific Linear Trend)") rows(2) span) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
graph export figure_A4.png, replace width(5240) height(3816)
* We first use graph editor to improve the figure 

***********************************************
* FOOTNOTE 13: TEST PARALLEL TRENDS 1891-1901 *
***********************************************

use ghana1, clear
keep if year == 1931
* We restrict the sample to the "forest" (the suitable cells for which we also have total population data in 1901)
keep if suitable == 1 & map08_yn == 1
* We then create the z-scores of the production variables, the population variables and the value of mineral production
foreach X in cocoastat_18 upop_2000 rpop_1970 upop_1960 upop_1931 upop_1901 upop_1891 rpop_1931 rpop_1901 pop_1931 city_yn minvalue31    {
egen `X'_std = std(`X') 
}

* we do not include rpop_1901_std (since we only have the rural population for the end year of the regression, hence 1901)
xi: reg upop_1901_std rail18_10 rail18_1020 rail18_2030 rail18_3040 upop_1891_std minvalue31_std mincell border sea dist2accra dist2river dist2kumasi dist2aburi share_suit share_highsuit share_vhighsuit alt_mean alt_sd dist2coast dist2port_any av_yr_prec, robust cluster(district_2000)






/************** Generate Relevant Dataset ***************/
clear all
set mem 100m
set more off
global datain  "C:\JECDynamics\Data\"
global dataout "C:\JECDynamics\Results\"
global datatmp "C:\JECDynamics\Temp\"
global fig  "C:\JECDynamics\Figures\"

/* Load data on future and spot corn prices for New York and Chicago. The original commodity prices were in bushels (56 lbs) and they have to be converted 
in 100 lbs to be consistent with Porter's JEC transportation rate (GR). Variable GR comes from JS2.xls (multiplied by 100 to avoid problems with 
double precision values). The file JS2.xls is the original Porter dataset. The other variables come from Coleman's Transport Prices Chicago-NY.xls. 
We have used columns Z-AB. Since the weeks in Coleman have one week lead to those in Porter, we have copied the data with one week lag. In this way 
All Railroads and JEC are comparable.
*/
use "${datain}Commodityprices.dta", clear
replace GPN=(GPN*23.438/13.125)/100 /* Spot corn price New York */
replace GP1N=(GP1N*23.438/13.125)/100 /* Future corn price delivery within the month New York */
replace GPC=(GPC*23.438/13.125)/100 /* Spot corn price Chicago */

*Convert dates into weeks
gen double t=date(date, "DMY", 1899)
gen yrstr=substr(date,8,2)
gen year=real(yrstr) /* calendar years */
egen tmp=min(t)
replace t=t-tmp
replace t=1+(t/7) /* t=1 first wk january 1878, t=T last wk December 1887 */
egen minyr=min(year)
gen W=(year-minyr)*52
gen wk=t-W /* Calendar wks (two years have 53 wks) */
sort t 
keep t wk year GPN GP1N GPC
save "${datatmp}tmp.dta", replace /* This dataset will be used below */

use "${datain}Trasportationsrate.dta", clear
* Similarly to the commodity prices, the non-JEC transportation rates were in measured in bushels and they have to be converted 
* in 100 lbs to be consistent with Porter's JEC transportation rate (GR).
replace GRAll=round(GRAll*23.438/13.125) /* All Railroads */
gen PR=(GR==GRAll) /* Cheating dummy when JEC differs from All Railroads */
replace GRLR=(GRLR*23.438/13.125)/100
replace GRLC=(GRLC*23.438/13.125)/100
replace GR=GR/100 /* From cents to dollars */
replace GRAll=GRAll/100
*Convert dates into weeks
gen double t=date(date, "DMY", 1899)
egen tmp=min(t)
replace t=t-tmp
replace t=1+(t/7)
gen yrstr=substr(date,8,2)
gen year=real(yrstr)
egen minyr=min(year)
gen W=(year-minyr)*52
gen wk=t-W
sort t 
merge t, using "${datatmp}tmp.dta" /* Temporary file created above */
keep t GPN GP1N GPC GR GRLR GRLC GRAll PR year wk
save "${datain}Datageneration1.dta", replace

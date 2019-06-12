cap log close

/*******************************************************************************
This code replicates the tables and figures from Palmer and Schneer (JOP 2016).

To run this file:
	Place the .dta files and this .do file in the same folder
	Set the local path macro to the right folder
	Run in Stata
	The results are output as csv files
	In some cases, multiple csv files combine to form one table from the paper
	Each table has a clear label in the code -- to find code for a specific table 
	if it is out of order, just search the text (for example, search ``table 5''
	to find table 5 and ``table A5'' to find appendix table 5).
*******************************************************************************/

*Install ado files
*Pacakges required: estout, rdrobust, parmest, scheme_tufte, labutil, eclplot
ssc install estout
net install rdrobust, from(http://www-personal.umich.edu/~cattaneo/software/rdrobust/stata) replace
//net install st0366.pkg
ssc install parmest
ssc install scheme_tufte
ssc install labutil
ssc install eclplot

clear all
set more off

*Set folder path
local path "~/Desktop/replication"
cd "`path'"
log using "cap_gains_replication.log"

cap mkdir "tables"
cap mkdir "figures"

*Define specificatinos
local spec1 (everwon = treatment) margin
local spec2 `spec1' margin_2
local spec3 `spec2' margin_3
local spec4 `spec3' margin_4
local spec5 (everwon = treatment) c.margin c.margin#treatment
local spec6 `spec5' c.margin_2 c.margin_2#treatment
local spec7 `spec6' c.margin_3 c.margin_3#treatment
local spec8 `spec7' c.margin_4 c.margin_4#treatment

*Define control variables
local covariates west south midwest age female dem

*Define bandwidths
local nval1 = 0.5
local nval2 = 0.2
local nval3 = 0.1
local nval4 = 0.05

*Define notes
local SEnote "Standard errors are clustered at the state-year level."
local polynote "Results are presented for model with quadratic polynomial."

***Summary Tables

******************************************************
******************************************************
******************************************************
***Table 1:                                        ***
***Senators and Governors who Served on Boards     ***
******************************************************
******************************************************
******************************************************

*Summary Table listing Compensation, Boards Served Upon, and Boards Per Year for Senators


foreach item in "senate" "governor"{

*Load Data and restrict based on relevant criteria
tempfile temp temp1
use "`item'_boards_final", clear
keep if first_election==1 & board0==1 & eligible0==1 & everwon==1

*Merge compensation data
*Only interested in 2011 numbers
*SEC data not available before 2005, and some other missingness as well
merge 1:1 directorid using "compensation"
drop if _merge==2
drop _merge

*Create counter variable; prepare to calculate averages by collapsing data
gen N = 1
gen board_years_mean = board0_years
gen on_board_2011 = (emp0_2011~=. & emp0_2011 ~=0)

save `temp', replace

*Sum across boards for all members
collapse (sum) board0_years eligible0_years N total_sec_all_boards2011 n_boards2011 emp0_2011 on_board_2011 (mean) total_boards_alltime
gen party= "All"

save `temp1', replace

use `temp', clear

*Sum across boards by party
collapse (sum) board0_years eligible0_years N total_sec_all_boards2011 n_boards2011 emp0_2011 on_board_2011 (mean) total_boards_alltime ,by(dem_rep_oth)

gen party = "D" if dem_rep_oth==1
replace party= "R" if dem_rep_oth==2
replace party = "Other" if party==""
drop dem_rep_oth
append using `temp1'

*calculate averages
replace total_sec_all_boards2011 = total_sec_all_boards2011 / n_boards2011 * (emp0_2011/on_board_2011)

gen boards_per_year = board0_years / eligible0_years

drop n_boards2011 on_board_2011 emp0_2011 board0_years eligible0_years
order party

*prepare to output as table
xpose, clear varname

if "`item'"=="senate"{
rename (v1 v2 v3) (D R All)
}
else{
rename (v1 v2 v3 v4) (D R Other All)
}
drop in 1

gen Outcome = "Boards per Year" if _varname =="boards_per_year"
replace Outcome = "Compensation (2011)" if _varname == "total_sec_all_boards2011"
replace Outcome = "Distinct Boards Served Upon (Ever)" if _varname == "total_boards_alltime"
replace Outcome = "N" if _varname == "N"

drop _varname

order Outcome

outsheet using "tables/table1_`item'.csv", comma replace

}




******************************************************
******************************************************
******************************************************
***Table 2:                                        ***
***Senator and Governor Board Summary Statistics   ***
******************************************************
******************************************************
******************************************************

*Summary table displaying data for winners versus losers
*Across all in sample

foreach item in "senate" "governor"{

use "`item'_boards_final", clear

*Include eligible and ineligible members for summary table 
*since trying to provide full overview of data
keep if first_election

*collapse to calculate overall means
gen N=1
gen board0_eligible = (board0 & eligible0)
gen board0_years_eligible = board0_years if eligible0

collapse (sum) N board0_eligible board0_years_eligible eligible0 eligible0_years,by(everwon)

gen boards_per_year_eligible = board0_years_eligible/eligible0_years
gen on_board_eligible = board0_eligible/eligible0
keep everwon N boards_per_year_eligible on_board_eligible board0_years_eligible eligible0
order everwon N eligible0 on_board_eligible board0_years_eligible boards_per_year_eligible
xpose, clear varname

outsheet using "tables/table2_`item'.csv", comma replace
}


*****RD Related Tables

***********************************************************************************
***********************************************************************************
***********************************************************************************
***Table 3:                                                                     ***
***Fuzzy Regression Discontinuity: Effects of Holding Office on Board Service   ***
***********************************************************************************
***********************************************************************************
***********************************************************************************


*Combined Gov/Senate tables for main results
local J = 1

*loop over outcome variables
foreach outcome in "d_board0" "d_board0_ave"{

*loop over senator and governor data
foreach item in "senate" "governor"{

use "`item'_boards_final", clear
keep if first_election & eligible0==1

gen margin= vote_g_pct_2p-.5
gen margin_2=margin^2
gen treatment = (margin>=0)

gen dem = (dem_rep_oth==1)

*RD regression w/ out bandwidth restrictions
ivregress 2sls `outcome' `spec2', cluster(state_year)
estimates store m`item'

*RD regression w/ covariates
ivregress 2sls `outcome' `spec2' `covariates', cluster(state_year)
estimates store mc`item'
}
esttab msenate mcsenate mgovernor mcgovernor using "tables/table3_`outcome'.csv", keep(everwon) indicate("Controls=female") star(* 0.10 ** 0.05 *** 0.01) r2 se label compress ///
addnotes("`SEnote'" "`polynote'") mgroups("Senators" "Governors", pattern(1 0 1 0)) ///
title("Fuzzy Regression Discontinuity: Effect of Holding Office on `outcome'") nomtitles replace
}


foreach item in "senate" "governor"{

*Local Linear RD
*Automated bandwidth selection
use "`item'_boards_final", clear
keep if first_election & eligible0==1

gen margin= vote_g_pct_2p-.5
gen treatment = (margin>=0)

matrix R = J(4,5,0)
local n = 1

foreach outcome of varlist d_board0 d_board0_ave{

foreach bw in "CCT" "IK"{

rdrobust `outcome' margin, fuzzy(everwon) bwselect(`bw')
matrix R[`n',1] = e(tau_F_cl)
matrix R[`n',2] = e(se_F_cl)
matrix R[`n',3] = e(pv_F_cl)
matrix R[`n',4] = e(N)
matrix R[`n',5] = e(h_bw)
local n = `n' + 1
}
}

clear
svmat R
rename (R1 R2 R3 R4 R5) (beta se p_val N bw)
gen outcome = "Pr(Board)" if _n<=2
replace outcome = "Boards per Year" if _n>2
gen bw_method = "CCT" if inlist(_n,1,3)
replace bw_method = "IK" if inlist(_n,2,4)
order outcome bw_method

outsheet using "tables/table3and4loclinear_`item'.csv", comma replace
}


***********************************************************************************
***********************************************************************************
***********************************************************************************
***Table 4:                                                                     ***
***Fuzzy Regression Discontinuity: Effect of Holding Office on Board Service    ***
***                                                                             ***
***Table A3:                                                                    ***
***Fuzzy Regression Discontinuity: Effect of Holding Office on Board Service    ***
***with Year Fixed Effects                                                      ***
***                                                                             ***
***Table A4:                                                                    ***
***Fuzzy Regression Discontinuity: Effect of Holding Office on Board Service    ***
***Controlling for Party                                                        ***
***********************************************************************************
***********************************************************************************
***********************************************************************************

*RD Regression across all bandwidths, for senators and governors
*and for both outcome variables

*Also, including (for Appendix) year dummies and controlling for party
foreach item in "senate" "governor"{

use "`item'_boards_final", clear
keep if first_election & eligible0==1

gen margin= vote_g_pct_2p-.5
gen margin_2=margin^2
gen treatment = (margin>=0)
gen dem = (dem_rep_oth==1)

foreach outcome in "d_board0" "d_board0_ave"{

local N = 1
foreach n of numlist .5 .2 .1 .05{
ivregress 2sls `outcome' `spec2' if abs(margin)<=`n', cluster(state_year)
estimates store bw`N'

xi: ivregress 2sls `outcome' `spec2' i.year if abs(margin)<=`n', cluster(state_year)
estimates store fe`N'

xi: ivregress 2sls `outcome' `spec2' dem if abs(margin)<=`n', cluster(state_year)
estimates store dem`N'

local N = `N' + 1
}
esttab bw* using "tables/table4_`outcome'_`item'.csv", keep(everwon) star(* 0.10 ** 0.05 *** 0.01) r2 se label compress ///
addnotes("`SEnote'" "`polynote'") mtitles("Bandwidth = $\pm .5$" "Bandwidth = $\pm .2$" "Bandwidth = .1" "Bandwidth = $\pm .05$")  ///
title("Fuzzy Regression Discontinuity: Effect of Service on `outcome'")  replace

esttab fe* using "tables/tableA3_`outcome'_`item'.csv", keep(everwon) star(* 0.10 ** 0.05 *** 0.01) r2 se label compress ///
addnotes("`SEnote'" "`polynote'") mtitles("Bandwidth = $\pm .5$" "Bandwidth = $\pm .2$" "Bandwidth = .1" "Bandwidth = $\pm .05$")  ///
title("Fuzzy Regression Discontinuity: Effect of Service on `outcome' with Year Fixed Effects")  replace

esttab dem* using "tables/tableA4_`outcome'_`item'.csv", keep(everwon) star(* 0.10 ** 0.05 *** 0.01) r2 se label compress ///
addnotes("`SEnote'" "`polynote'") mtitles("Bandwidth = $\pm .5$" "Bandwidth = $\pm .2$" "Bandwidth = .1" "Bandwidth = $\pm .05$") ///
title("Fuzzy Regression Discontinuity: Effect of Service on `outcome' Controlling for Party")  replace

estimates clear
}
}


*Prepare data for subsequent tables concerned with sample selection
*Includes:
*Results for term limited governors
*Results looking at only elections that occurred after 1992
*Results looking at outcomes only in the first two years after leaving office (year_departed_office_1 for gov and year_left_senate for Sen)

local file1 "governor_boards_final"
local file2 "senate_boards_final"

local yearleft1 "year_departed_office_1"
local yearleft2 "year_left_senate"

tempfile select1 select2

forvalues n=1/2{
use "`file`n''", clear
set more off
gen margin= vote_g_pct_2p-.5
gen margin_2=margin^2
gen margin_3=margin^3
gen margin_4=margin^4
gen treatment = (margin>=0)
gen dem = (dem_rep_oth==1)


*determine service for 2 years after leaving office only
*Different possibilities include years 5/6 for losing governor candidates (B)
*years 9/10 for lsoing governor candidates (D)
*and years 7/8 for losing senate candidates (C)

gen bd2b_temp = 0

gen bd2c_temp = 0

gen bd2d_temp = 0

forvalues yr = 2000(1)2013{

*count board service only for relevant years
replace bd2b_temp = bd2b_temp + emp0_`yr' if `yearleft`n''<. & `yearleft`n''>=2000 & (`yearleft`n'' ==`yr' | `yearleft`n'' +1 == `yr')
replace bd2b_temp = bd2b_temp + emp0_`yr' if `yearleft`n'' == . & year+4>=2000 & (year + 4 ==`yr' | year+ 5 == `yr')

replace bd2c_temp = bd2c_temp + emp0_`yr' if `yearleft`n''<. & `yearleft`n''>=2000 & (`yearleft`n'' ==`yr' | `yearleft`n'' +1 == `yr')
replace bd2c_temp = bd2c_temp + emp0_`yr' if `yearleft`n'' == . & year+6>=2000 & (year + 6 ==`yr' | year+ 7 == `yr')

replace bd2d_temp = bd2d_temp + emp0_`yr' if `yearleft`n''<. & `yearleft`n''>=2000 & (`yearleft`n'' ==`yr' | `yearleft`n'' +1 == `yr')
replace bd2d_temp = bd2d_temp + emp0_`yr' if `yearleft`n'' == . & year+8>=2000 & (year + 8 ==`yr' | year+ 9 == `yr')
}

replace bd2b_temp = . if  ((`yearleft`n''<2000 | `yearleft`n''+1 <2000 ) | (`yearleft`n''==. & (year +4 <2000 | year +5 <2000)))
replace bd2c_temp = . if ((`yearleft`n''<2000 | `yearleft`n''+1 <2000 ) | (`yearleft`n''==. & (year +6 <2000 | year +7 <2000)))
replace bd2d_temp = . if  ((`yearleft`n''<2000 | `yearleft`n''+1 <2000 ) | (`yearleft`n''==. & (year +8 <2000 | year +9 <2000)))

gen bd2b0_temp = bd2b_temp
gen bd2c0_temp = bd2c_temp
gen bd2d0_temp = bd2d_temp

*For instances where data on relevant years is not available, count candidates in election as missing
gen notmissingb = 1
gen notmissingc = 1
gen notmissingd = 1

bysort state year: replace notmissingb = 0 if bd2b_temp ==. | (_n==1 & bd2b_temp[_n+1]==.) |(_n==2 & bd2b_temp[_n-1]==.)
bysort state year: replace notmissingc = 0 if bd2c_temp ==. | (_n==1 & bd2c_temp[_n+1]==.) |(_n==2 & bd2c_temp[_n-1]==.)
bysort state year: replace notmissingd = 0 if bd2d_temp ==. | (_n==1 & bd2d_temp[_n+1]==.) |(_n==2 & bd2d_temp[_n-1]==.)

replace bd2b_temp = . if notmissingb == 0
replace bd2c_temp = . if notmissingc == 0
replace bd2d_temp = . if notmissingd == 0
drop notmissing*

foreach item in "bd2b" "bd2c" "bd2d" {
local yrs = real(substr("`item'",3,1))

gen `item' = 1 if `item'_temp>0 & `item'_temp<.
replace `item' = 0 if `item'_temp==0

gen `item'_ave = `item'_temp/`yrs'

gen `item'0 = 1 if `item'0_temp > 0 & `item'0_temp<.
replace `item'0 = 0 if `item'0_temp==0
gen `item'_ave0 = `item'0_temp/`yrs'

}
drop *temp

save `select`n'', replace
}


*Conditions to restrict sample
local cond1 "first_election & eligible0==1 & term_limit>0"
local cond2 "first_election & eligible0==1 & year>=1992"
local cond3 "first_election & eligible0==1"
local cond4 "in_sample_pairs & eligible0==1"

local office1 "Gov"
local office2 "Sen"

local out1 "TL"
local out2 "P92"
local out3 "SEL"
local out4 "ISP"

***********************************************************************************
***********************************************************************************
***********************************************************************************
***Table 5:                                                                     ***
***Effect of Holding Office as Governor on                                      ***
***Board Service (Fuzzy RDD), First-Time Candidate Pairs and Two Year Windows   ***
***********************************************************************************
***********************************************************************************
***********************************************************************************

*RD with 2 year windows for governors

local K = 1
use `select`K'', clear

local J = 0
foreach outcome of varlist bd2b bd2d bd2b_ave bd2d_ave {
local J = `J' +1
local N = 1
forvalues z = 1(1)4{
ivregress 2sls `outcome' `spec2' if abs(margin)<=`nval`z'' & `cond4', cluster(state_year)
estimates store _est`N'

local N = `N' + 1
}
esttab _est* using "tables/table5`outcome'.csv", keep(everwon) star(* 0.10 ** 0.05 *** 0.01) r2 se label compress ///
addnotes("`SEnote'" "`polynote'") mtitles("Bandwidth = $\pm .5$" "Bandwidth = $\pm .2$" "Bandwidth = .1" "Bandwidth = $\pm .05$")  ///
title("Fuzzy Regression Discontinuity: Effect of Service as `office`K'' on Board Service | 2 Years Out), First-Time Candidate Pairs")  replace
estimates clear
}



***********************************************************************************
***********************************************************************************
***********************************************************************************
***Table A5:                                                                    ***
***Additional Sample Selection Checks: Effect of Holding Office as Governor on  ***
***Board Service (Fuzzy RDD), First-Time Candidate Pairs                        ***
***********************************************************************************
***********************************************************************************
***********************************************************************************

local K = 1
use `select`K'', clear

local J = 0
foreach outcome of varlist d_board0 d_board0_ave {
local J = `J' +1
local N = 1
forvalues z = 1(1)4{
ivregress 2sls `outcome' `spec2' if abs(margin)<=`nval`z'' & `cond4', cluster(state_year)
estimates store _est`N'

local N = `N' + 1
}
esttab _est* using "tables/tableA5`outcome'.csv", keep(everwon) star(* 0.10 ** 0.05 *** 0.01) r2 se label compress ///
addnotes("`SEnote'" "`polynote'") mtitles("Bandwidth = $\pm .5$" "Bandwidth = $\pm .2$" "Bandwidth = .1" "Bandwidth = $\pm .05$")  ///
title("Fuzzy Regression Discontinuity: Effect of Service as `office`K'' on Board Service, First-Time Candidate Pairs")  replace
estimates clear
}

***********************************************************************************
***********************************************************************************
***********************************************************************************
***Table A6:                                                                    ***
***Additional Sample Selection Checks: Effect of Holding Office as Governor on  ***
***Board Service (Fuzzy RDD), States with Term Limits for Governor              ***
***********************************************************************************
***********************************************************************************
***********************************************************************************

local K = 1
use `select`K'', clear

local J = 0
foreach outcome of varlist d_board0 d_board0_ave {
local J = `J' +1
local N = 1
forvalues z = 1(1)4{
ivregress 2sls `outcome' `spec2' if abs(margin)<=`nval`z'' & `cond1', cluster(state_year)
estimates store _est`N'

local N = `N' + 1
}
esttab _est* using "tables/tableA6`outcome'.csv", keep(everwon) star(* 0.10 ** 0.05 *** 0.01) r2 se label compress ///
addnotes("`SEnote'" "`polynote'") mtitles("Bandwidth = $\pm .5$" "Bandwidth = $\pm .2$" "Bandwidth = .1" "Bandwidth = $\pm .05$")  ///
title("Fuzzy Regression Discontinuity: Effect of Service as `office`K'' on Board Service, First-Time Candidate Pairs")  replace
estimates clear
}



***********************************************************************************
***********************************************************************************
***********************************************************************************
***Table A7:                                                                    ***
***Additional Sample Selection Checks: Effect of Holding Office as Governor on  ***
***Board Service (Fuzzy RDD), Post 1992 Elections                               ***
***********************************************************************************
***********************************************************************************
***********************************************************************************


forvalues K = 1/2{

use `select`K'', clear
local J = 0
foreach outcome of varlist d_board0 d_board0_ave {
local J = `J' +1
local N = 1
forvalues z = 1(1)4{
ivregress 2sls `outcome' `spec2' if abs(margin)<=`nval`z'' & `cond2', cluster(state_year)
estimates store _est`N'

local N = `N' + 1
}
esttab _est* using "tables/tableA7_`office`K''_`outcome'.csv", keep(everwon) star(* 0.10 ** 0.05 *** 0.01) r2 se label compress ///
addnotes("`SEnote'" "`polynote'") mtitles("Bandwidth = $\pm .5$" "Bandwidth = $\pm .2$" "Bandwidth = .1" "Bandwidth = $\pm .05$")  ///
title("Fuzzy Regression Discontinuity: Effect of Service as `office`K'' on Board Service, Post-1992 Elections")  replace
estimates clear
}
}


***********************************************************************************
***********************************************************************************
***********************************************************************************
***Table A8:                                                                    ***
***Additional Sample Selection Checks: Effect of Holding Office on Board        ***
***Service (Fuzzy RDD), First 2 Years Eligible for Winners, Years 5/6 for          ***
***Losing Governors and Years 7/8 for Losing Senators                              ***
***********************************************************************************
***********************************************************************************
***********************************************************************************


*RD For Governors
local K = 1
use `select`K'', clear

local J = 0
foreach outcome of varlist bd2b bd2b_ave  {
local J = `J' +1
local N = 1
forvalues z = 1(1)4{
ivregress 2sls `outcome'0 `spec2' if abs(margin)<=`nval`z'' & `cond3', cluster(state_year)
estimates store _est`N'

local N = `N' + 1
}
esttab _est* using "tables/tableA8_`outcome'_governor.csv", keep(everwon) star(* 0.10 ** 0.05 *** 0.01) r2 se label compress ///
addnotes("`SEnote'" "`polynote'") mtitles("Bandwidth = $\pm .5$" "Bandwidth = $\pm .2$" "Bandwidth = .1" "Bandwidth = $\pm .05$")  ///
title("Fuzzy Regression Discontinuity: Effect of Service as `office`K'' on Board Service | 2 Years Out), First-Time Candidate Pairs") replace
estimates clear
}

*RD for Senators
local K = 2
use `select`K'', clear

local J = 0
foreach outcome of varlist bd2c bd2c_ave {
local J = `J' +1
local N = 1
forvalues z = 1(1)4{
ivregress 2sls `outcome'0 `spec2' if abs(margin)<=`nval`z'' & `cond3', cluster(state_year)
estimates store _est`N'

local N = `N' + 1
}
esttab _est* using "tables/tableA8_`outcome'_senator.csv", keep(everwon) star(* 0.10 ** 0.05 *** 0.01) r2 se label compress ///
addnotes("`SEnote'" "`polynote'") mtitles("Bandwidth = $\pm .5$" "Bandwidth = $\pm .2$" "Bandwidth = .1" "Bandwidth = $\pm .05$")  ///
title("Fuzzy Regression Discontinuity: Effect of Service as `office`K'' on Board Service | 2 Years Out), First-Time Candidate Pairs") replace
estimates clear
}


***********************************************************************************
***********************************************************************************
***********************************************************************************
***Table A9:                                                                    ***
***Placebo Tests: Regression Discontinuity with Pre-Determined Outcome          ***
***Variables For Governor Matched Pair Analysis                                 ***
***********************************************************************************
***********************************************************************************
***********************************************************************************

local K = 1
matrix H = J(9,3,0)
local s = 1

*Loop over control variables for placebo test
foreach var in "north" "midwest" "south" "west" "age" "female" "dem" "year" "in_inc_party" {
use `select`K'', clear

ivregress 2sls `var' `spec2' if abs(margin)<=`nval4' & `cond4', cluster(state_year)
parmest, fast
keep if parm == "everwon"
matrix H[`s',1] = estimate[1]
matrix H[`s',2] = min95[1]
matrix H[`s',3] = max95[1]
local s = `s' + 1
}

*output table
foreach var in "north" "midwest" "south" "west" "age" "female" "dem" "year" "in_inc_party" {
gen `var'=.
}
keep north midwest south west age female dem year in_inc_party
xpose, varname clear
drop v1

svmat H
rename _varname varname
outsheet using "tables/tableA9.csv", comma replace

***********************************************************************************
***********************************************************************************
***********************************************************************************
***Table A10:                                                                   ***
***Placebo Tests: Regression Discontinuity with Pre-Determined Outcome          ***
***Variables For Senators and For Governors                                     ***
***********************************************************************************
***********************************************************************************
***********************************************************************************



forvalues K = 1/2{

matrix H = J(8,3,0)
local n = 1

foreach var in "north" "midwest" "south" "west" "age" "female" "dem" "in_inc_party" {
use `file`K'', clear
keep if first_election & eligible0==1
gen margin= vote_g_pct_2p-.5
gen margin_2=margin^2

gen treatment = (margin>=0)
gen dem = dem_rep_oth==1


ivregress 2sls `var' `spec2' if eligible0 & abs(margin)<=`nval4', cluster(state_year)

parmest, fast
keep if parm == "everwon"
matrix H[`n',1] = estimate[1]
matrix H[`n',2] = min95[1]
matrix H[`n',3] = max95[1]
local n = `n' + 1
}

foreach var in north midwest south west age female dem in_inc_party {
gen `var'=.
}
keep north midwest south west age female dem in_inc_party 
xpose, varname clear
drop v1

svmat H
rename _varname varname
outsheet using "tables/tableA10_`office`K''.csv", comma replace

}


***********************************************************************************
***********************************************************************************
***********************************************************************************
***Table A11:                                                                   ***
***Placebo Tests: Regression Discontinuity with different cut-offs, Pr(Board)   ***
***********************************************************************************
***********************************************************************************
***********************************************************************************

forvalues K = 1/2{

tempfile results
tempname hold

postfile `hold' threshold estimate stderr min95 max95 using `results'


forvalues n=-.1(.05).1{
local k = round(100*(`n' + .5))
use `file`K'', clear

gen margin= vote_g_pct_2p-.5 - `n'
gen margin_2=margin^2

gen treatment = (margin>=0)

keep if first_election & everwon_`k' == treatment

reg d_board0 everwon_`k' margin margin_2 if eligible0 & abs(margin)<=`nval3', cluster(state_year)

parmest, fast
keep if strpos(parm,"everwon")
keep estimate stderr min95 max95
gen threshold = `n'

post `hold' (threshold) (estimate) (stderr) (min95) (max95) 
}

postclose `hold'

use `results', clear

outsheet using "tables/tableA11_`office`K''.csv", comma replace

}


***********************************************************************************
***********************************************************************************
***********************************************************************************
***Table A12:                                                                   ***
***Probit, Fuzzy Regression Discontinuity (First Election): Effect of Service   ***
***as Governor on Pr(Board), Bandwidth = ±0.5                                   ***
***********************************************************************************
***********************************************************************************
***********************************************************************************

*Combined Gov/ Senate tables for main results
local J = 1

forvalues K=1(1)2{
foreach outcome in "d_board0" "d_board0_ave"{
use `file`K'', clear
keep if first_election & eligible0==1
gen margin= vote_g_pct_2p-.5
gen margin_2=margin^2
gen margin_3=margin^3
gen margin_4=margin^4
gen treatment = (margin>=0)

gen dem = (dem_rep_oth==1)
label var dem "Democrat"

label var everwon "In Office"
*Probit

if `J' ==1{
ivprobit d_board0 `spec2', cluster(state_year)
margins, dydx(_all) pred(pr) post
estimates store ivp1_`K'
ivprobit d_board0 `spec2' `covariates', cluster(state_year)
margins, dydx(_all) pred(pr) post
estimates store ivp2_`K'
}
}
}

esttab ivp1_2 ivp2_2 ivp1_1 ivp2_1 using "tables/tableA12.csv",  keep(everwon) indicate("Controls=female") star(* 0.10 ** 0.05 *** 0.01) pr2 se label compress ///
addnotes("`SEnote'" "`polynote'") mgroups("Senators" "Governors", pattern(1 0 1 0)) ///
title("Probit, Fuzzy Regression Discontinuity (First Election): Effect of Service on Pr(Board), Bandwidth = $\pm 0.5$") nomtitles replace
estimates clear




***********************************************************************************
***********************************************************************************
***********************************************************************************
***Table A1 & Table A2                                                          ***
***Fuzzy Regression Discontinuity (First Election):                             ***
***Effect of Holding Office on Pr(Board)                                        ***
***********************************************************************************
***********************************************************************************
***********************************************************************************

*Set up full set of regressions

local olabel1 "Pr(Board)"
local olabel2 "Boards per Year"

local table1 "tables/tableA1"
local table2 "tables/tableA2"

local file1 "senate_boards_final"
local file2 "governor_boards_final"

local yearleft1 "year_left_senate" 
local yearleft2 "year_departed_office_1"

local panel1 "panelA"
local panel2 "panelB"
local panel3 "panelC"
local panel4 "panelD"

local j = 1

foreach outcome in "d_board0" "d_board0_ave"{
local P = 1

foreach bandwidth of numlist .5 .2{

forvalues N = 1/2{

use `file`N'', clear

keep if first_election & eligible0==1

gen margin= vote_g_pct_2p-.5
gen margin_2=margin^2
gen margin_3=margin^3
gen margin_4=margin^4
gen treatment = (margin>=0)


label var treatment "In Office"

local out = 10*`bandwidth'
forvalues n=1(1)8{
ivregress 2sls `outcome' `spec`n'' if abs(margin)<=(`bandwidth'), cluster(state_year)
estimates store rega_`n'
}
di `out'
esttab rega_* using "`table`j''_`out'_`panel`P''.csv",  indicate("Linear=margin" "Quadratic=margin_2" "Cubic=margin_3" "Quartic=margin_4" "Separate Fit=1.treatment#c.margin*") ///
addnotes("`SEnote'") ///
keep(everwon) star(* 0.10 ** 0.05 *** 0.01) r2 se label compress title("Fuzzy Regression Discontinuity (First Election): Effect of Service on `olabel`j'', Bandwidth = $\pm`bandwidth'$ \label{full`out'`j'}") nomtitles replace
estimates clear
local P = 1 + `P'
}
}
local j= `j' + 1


}


***********************************************************************************
***********************************************************************************
***********************************************************************************
***Figure 1:                                                                    ***
***Time to First Board Position After Leaving Office                            ***
***********************************************************************************
***********************************************************************************
***********************************************************************************

local plot1 = `"line first_board_share year_diff if year_diff<=10, xlabel(0(5)10) yscale(range(0 1)) ylabel(0(.2)1) legend(off) scheme(s1mono) ytitle(Share Joining First Board) xtitle(Years After Leaving Office) text(.05 9  "Senators",size(vsmall))"'
local plot2 = `"graph addplot line first_board_share year_diff if year_diff<=10, lpattern(dash) text(.12 4  "Governors",size(vsmall))"'

forvalues n = 1/2{

use `file`n'', clear
keep if first_election == 1 & eligible0==1 & everwon==1 & `yearleft`n''>=2000
keep year name emp0* everwon `yearleft`n''

reshape long emp0_, i(year name everwon `yearleft`n'') j(boardyear)
rename year electionyear
rename emp0_ boards

gen year_diff = boardyear - `yearleft`n'' if everwon ==1
replace year_diff = boardyear - electionyear if everwon ==0

egen id = group(name)

gen on_board = (boards>0)
replace on_board = . if boards==.

drop if year_diff<0

bysort `yearleft`n'' name (year_diff): gen rtboard = sum(on_board)
bysort `yearleft`n'' name (year_diff): gen n = _n

gen first_board = (n==1 & on_board==1) | (n~=1 & rtboard == 1 & rtboard[_n-1]==0)
drop rtboard n
gen n = 1 if boards!=.
gen N = 1 

collapse (sum) first_board N, by(year_diff)
egen on_board_tot = total(first_board)

gen first_board_share = first_board / on_board_tot

`plot`n''

}

graph export "figures/figure1.pdf", replace



***********************************************************************************
***********************************************************************************
***********************************************************************************
***Figure 2  & 3                                                                ***
***Senators/Governors                                                           ***
***********************************************************************************
***********************************************************************************
***********************************************************************************

local file1 "senate_boards_final"
local file2 "governor_boards_final"

local fig1 "figure2"
local fig2 "figure3"


local K = 1
forvalues n = 1/2{

use `file`n'', clear
keep if first_election & eligible0==1 
gen margin= vote_g_pct_2p-.5
gen margin_2=margin^2
gen treatment = (margin>=0)

tempfile rdd_graph2
save `rdd_graph2', replace

local bandwidth = .2
local step = .4
gen pct_round = .
forvalues n=0(`step')100{
replace pct_round= (`n'/100)-.5 if margin>=(`n'/100)-.5 & margin<(`n'/100)-.5+`step'/100
}
gen n = 1
collapse (sum) d_board0 d_board0_years_sum eligible0_years n, by(pct_round)
gen d_board0_ave= d_board0_years_sum/eligible0_years

gen d_board0_share = d_board0 / n

keep if abs(pct_round)<= `bandwidth'
twoway (scatter d_board0_ave pct_round if pct_round<0 [fweight = n], mcolor(gray) msize(vsmall)) (scatter d_board0_ave pct_round if pct_round>=0 [fweight = n], mcolor(black) msize(vsmall)), ytitle(Board Seats per Year) xtitle(Margin over/under Threshold) legend(off) scheme(s1mono) xline(0)


tempfile rdd_graph

save `rdd_graph', replace

use `rdd_graph2', clear

ivregress 2sls d_board0_ave `spec2', cluster(state_year)

predict yhat
predict yhat_se, stdp
gen lci = yhat - 1.96*yhat_se
gen uci = yhat + 1.96*yhat_se

keep if abs(margin)<=`bandwidth'

graph addplot (lowess yhat margin if margin<0, lcolor(red) lwidth(.5)) (lowess lci margin if margin<0, lpattern(dash) lcolor(red) lwidth(.5)) (lowess uci margin if margin<0, lpattern(dash) lcolor(red) lwidth(.5)) (lowess yhat margin if margin>=0, lcolor(red) lwidth(.5)) (lowess lci margin if margin>=0, lpattern(dash) lcolor(red) lwidth(.5)) (lowess uci margin if margin>=0, lpattern(dash) lcolor(red) lwidth(.5))

graph export "figures/`fig`K''a.pdf", replace

*Pr(Board) RDD Plot

use `rdd_graph', clear

twoway (scatter d_board0_share pct_round if pct_round<0 [fweight = n], mcolor(gray) msize(vsmall)) (scatter d_board0_share pct_round if pct_round>=0 [fweight = n], mcolor(black) msize(vsmall)), ytitle(Pr(Board)) xtitle(Margin over/under Threshold) legend(off) scheme(s1mono) xline(0)

use `rdd_graph2', clear

ivregress 2sls d_board0 `spec2' , cluster(state_year)

predict yhat
predict yhat_se, stdp
gen lci = yhat - 1.96*yhat_se
gen uci = yhat + 1.96*yhat_se

keep if abs(margin)<=`bandwidth'

graph addplot (lowess yhat margin if margin<0, lcolor(red) lwidth(.5)) (lowess lci margin if margin<0, lpattern(dash) lcolor(red) lwidth(.5)) (lowess uci margin if margin<0, lpattern(dash) lcolor(red) lwidth(.5)) (lowess yhat margin if margin>=0, lcolor(red) lwidth(.5)) (lowess lci margin if margin>=0, lpattern(dash) lcolor(red) lwidth(.5)) (lowess uci margin if margin>=0, lpattern(dash) lcolor(red) lwidth(.5))

graph export "figures/`fig`K''b.pdf", replace

local K = `K' + 1
}



***********************************************************************************
***********************************************************************************
***********************************************************************************
***Figure 4                                                                     ***
***Committee Memberships and Board Service Among Senators                       ***
***********************************************************************************
***********************************************************************************
***********************************************************************************


use sen_covariates_final, clear


*Determinants of board service


tempfile committees0 committees1 leaders0 leaders1 wealth0 wealth1 lost0 lost1 employ0 employ1 term0 term1 id0 id1


*Committees

reg d_board0 committee_3* committee_4* year_left_senate, robust
parmest, label escal(N r2) ylabel list(parm estimate min* max* p) saving(`committees0', replace)

reg d_board0_ave committee_3* committee_4* year_left_senate, robust
parmest, label ylabel escal(N r2) list(parm estimate min* max* p) saving(`committees1', replace)

*Export image
use `committees0', clear 
encode parm, gen(parmn)

drop if parm=="_cons" | parm=="o.committee_434" |parm=="year_left_senate"
gsort -estimate
gen n =_n
replace parmn = n
drop n

labmask parmn, values(label)

eclplot estimate min95 max95 parmn, hori ytitle("") estopts(msymbol(O)) xtitle("Pr(Board)",size("small")) xlabel(-1(1)1,labsize(small)) ylabel(#19,labsize(small)) xline(0) ytitle("") scheme("tufte")
graph export "figures/figure4.pdf", replace


****Remaining Regressions to construct Appendix Tables

use sen_covariates_final, clear

*Leaders

reg d_board0 committee_chair committee_rm party_leader, robust
parmest, label ylabel escal(N r2) list(parm estimate min* max* p) saving(`leaders0', replace)

reg d_board0_ave committee_chair committee_rm party_leader, robust
parmest, label ylabel escal(N r2) list(parm estimate min* max* p) saving(`leaders1', replace)

*Wealth when leaving office
reg d_board0 wealth_std, robust
parmest, label escal(N r2) ylabel list(parm estimate min* max* p) saving(`wealth0', replace)

reg d_board0_ave wealth_std, robust
parmest, label escal(N r2) ylabel list(parm estimate min* max* p) saving(`wealth1', replace)

*Lost Re-Election
reg d_board0 left_lost_reelection, robust
parmest, label escal(N r2) ylabel list(parm estimate min* max* p) saving(`lost0', replace)
reg d_board0_ave left_lost_reelection, robust
parmest, label escal(N r2) ylabel list(parm estimate min* max* p) saving(`lost1', replace)

*Past Employment
reg d_board0 job4 job11 military, robust
parmest, label escal(N r2) ylabel list(parm estimate min* max* p) saving(`employ0', replace)
reg d_board0_ave job4 job11, robust
parmest, label escal(N r2) ylabel list(parm estimate min* max* p) saving(`employ1', replace)

*Time in office
reg d_board0 time_in_office_std, robust
parmest, label escal(N r2) ylabel list(parm estimate min* max* p) saving(`term0', replace)
reg d_board0_ave time_in_office_std, robust
parmest, label escal(N r2) ylabel list(parm estimate min* max* p) saving(`term1', replace)

*Ideology
reg d_board0 dwnom1_std dwnom2_std, robust
parmest, label escal(N r2) ylabel list(parm estimate min* max* p) saving(`id0', replace)
reg d_board0_ave dwnom1_std dwnom2_std, robust
parmest, label escal(N r2) ylabel list(parm estimate min* max* p) saving(`id1', replace)



***********************************************************************************
***********************************************************************************
***********************************************************************************
***Figure A.1                                                                   ***
***Senator Characteristics and Board Service among Senators                     ***
***********************************************************************************
***********************************************************************************
***********************************************************************************

use `leaders0', clear
append using `term0'
append using  `lost0'
append using `id0'
append using `wealth0'
append using `employ0'

drop if parm=="_cons"

gen parmn = _n
labmask parmn, values(label)

count
local N = r(N)

eclplot estimate min95 max95 parmn, hori ytitle("") estopts(msymbol(O)) xtitle("Pr(Board)",size("small")) ylabel(#`N',labsize(small)) xlabel(-1(.5)1,labsize(small))  xline(0) ytitle("") scheme("tufte")
graph export "figures/figureA1.pdf", replace


***********************************************************************************
***********************************************************************************
***********************************************************************************
***Table A13 & Table A14                                                        ***
***Senator Characteristics and Board Service                                    ***
***********************************************************************************
***********************************************************************************
***********************************************************************************



use `committees0', clear
append using `committees1'
append using `leaders0'
append using `leaders1'
append using `wealth0'
append using `wealth1'
append using `lost0'
append using `lost1'
append using `employ0'
append using `employ1'
append using `term0'
append using `term1'
append using `id0'
append using `id1'
drop if parm=="year_left_senate" | parm == "_cons" | strpos(parm,"o.c")

rename parm variable

export delimited "tables/tableA13.csv" if strpos(variable,"committee_3") | strpos(variable,"committee_4"), replace
export delimited "tables/tableA14.csv" if !(strpos(variable,"committee_3") | strpos(variable,"committee_4")), replace





***********************************************************************************
***********************************************************************************
***********************************************************************************
***Table 6:                                                                     ***
***Finance/Banking Committees and Sector Specific Board Service                 ***
***********************************************************************************
***********************************************************************************
***********************************************************************************

use sen_covariates_final, clear

gen finance = (committee_314 | committee_336)

gen n = 1

replace party = "D" if dem_rep_oth==1
replace party = "R" if dem_rep_oth==2

tempfile sectors_merged finance1

save `sectors_merged', replace

collapse (sum) bank_finance_years board0_bank_finance board0_other1 eligible0_years n, by(finance party)

save `finance1', replace

use `sectors_merged', clear

collapse (sum) bank_finance_years board0_bank_finance board0_other1 eligible0_years n, by(finance)

gen party = "All"

append using `finance1'

gen board_share = board0_other1/n

gen finance_board_share = board0_bank_finance / n

keep finance board_share finance_board_share n party

outsheet using "tables/table6.csv", comma replace


***********************************************************************************
***********************************************************************************
***********************************************************************************
***Table A15:                                                                   ***
***Intelligence Committee and Sector Specific Board Service                     ***
***********************************************************************************
***********************************************************************************
***********************************************************************************


*Intelligence 
use `sectors_merged', clear

gen intelligence = (committee_432)

collapse (sum) aerospace_defence_years board0_aerospace_defence tech_years board0_tech board0_other2 eligible0_years n, by(intelligence party)

tempfile intel1
save `intel1', replace

use `sectors_merged', clear
gen intelligence = (committee_432)

collapse (sum) aerospace_defence_years board0_aerospace_defence tech_years board0_tech board0_other2 eligible0_years n, by(intelligence)

gen party = "All"

append using `intel1'


gen board_share = board0_other2/n

gen aerospace_defence_board_share = board0_aerospace_defence / n

gen tech_board_share = board0_tech / n


keep intelligence board_share aerospace_defence_board_share  tech_board_share n party

outsheet using "tables/tableA15.csv", comma replace



***********************************************************************************
***********************************************************************************
***********************************************************************************
***Table D1:                                                                    ***
***Financial Legislation and Board Service                                      ***
***********************************************************************************
***********************************************************************************
***********************************************************************************

*Tarp and Dodd Frank case study

use `sectors_merged', clear

merge 1:1 id using "tarp_dodd"
keep if _merge==1 |_merge==3

save `sectors_merged', replace

collapse (sum) bank_finance_years board0_bank_finance board0_other1 eligible0_years n, by(tarp party)

tempfile tarp

save `tarp', replace

use `sectors_merged', clear
collapse (sum) bank_finance_years board0_bank_finance board0_other1 eligible0_years n, by(tarp)
gen party = "All"

append using `tarp'

gen share_bank_fin_board = board0_bank_finance / n

gen share_other_board = board0_other1 /n

drop if tarp==.
order party
sort party tarp
outsheet using "tables/tableD1_tarp.csv", comma replace


use `sectors_merged', clear

collapse (sum) bank_finance_years board0_bank_finance board0_other1 eligible0_years n, by(dodd party)

tempfile dodd
save `dodd', replace

use `sectors_merged', clear

collapse (sum) board0_bank_finance board0_other1 n, by(dodd)
gen party = "All"
append using `dodd'

gen share_bank_fin_board = board0_bank_finance / n

gen share_other_board = board0_other1 /n

drop if dodd==.
order party
sort party dodd
outsheet using "tables/tableD1_dodd.csv", comma replace

*Repeal Glass-Steagel

use `sectors_merged', clear

collapse (sum) board0_bank_finance board0_other1 n, by(repgs party)

tempfile repgs
save `repgs', replace

use `sectors_merged', clear

collapse (sum) board0_bank_finance board0_other1 n, by(repgs)
gen party = "All"
append using `repgs'

gen share_bank_fin_board = board0_bank_finance / n

gen share_other_board = board0_other1 /n

drop if repgs==. | repgs==9
order party
sort party repgs
outsheet using "tables/tableD1_repgs.csv", comma replace

********************************************************************************
********************************************************************************
********************************************************************************
***Table B1:                                                                 ***
***BoardEx Matches                                                           ***
********************************************************************************
********************************************************************************
********************************************************************************
use senate_boards_final, clear
gen n = 1
gen in_database = directorid!=.
collapse (sum) n, by(in_database everwon)
reshape wide n, i(in_database) j(everwon)
ren n0 sen_losers
ren n1 sen_winners
gen cat = "In BoardEx" if in_database==1
replace cat = "Not in BoardEx" if cat==""
tempfile t
save `t'

use governor_boards_final, clear
gen n = 1
gen in_database = directorid!=.
collapse (sum) n, by(in_database everwon)
reshape wide n, i(in_database) j(everwon)
ren n0 gov_losers
ren n1 gov_winners
gen cat = "In BoardEx" if in_database==1
replace cat = "Not in BoardEx" if cat==""
merge 1:1 cat using `t', nogen
gsort -in_database
drop in_database
order cat sen_win sen_los gov_win gov_los
outsheet using "tables/tableB1_boardex_matches.csv", comma replace

log close

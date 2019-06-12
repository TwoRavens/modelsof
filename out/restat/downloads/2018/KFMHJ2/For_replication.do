
** Replication file for "Racial Sorting and the Emergence of Segregation in American Cities" ***

/* Allison Shertzer, 6/8/18

Note:  we are using census data extracts from Ancestry.com in this paper. However, the now-available 
IPUMS releases of these data are cleaner and we encourage scholars who want to do related work to use 
their version.
*/

/* Files

all_hexagon_iv.dta:  main hexagon-level dataset
sumstat.do:  produces summary statistics
estimation_sample_merged.dta:  spatial data for hexagons used in Conley standard error estimation
spatial_subsamples.dta:  neighbors dataset needed to get spatial subsample estimates in Table 2
all_hexagon_iv_south:  main hexagon-level dataset but with instrument constructed using southern states inflows only
all_hexagon_iv_coho:  main hexagon-level dataset but with instrumented constructed without birth cohorts
x_gmm.ado and x_ols.ado: files to get Conley standard errors
For_replication_simulation.do:  makes counterfactual segregation indices for Table 6
Table 6 for Replication:  demonstrates how to take the output from the For_replication_simulation.do
file and turn it into Table 6
*/

* Table 1. Summary Statistics of Hexagonal Panel Dataset

do sumstat.do

* Table 2. Baseline OLS and IV Results

* OLS Panel

use all_hexagon_iv.dta, clear

reg whitediff10 blackdiff10 i.city_cd if year == 1910, robust
outreg2 blackdiff10 using results.xls, replace
reg whitediff20 blackdiff20 i.city_cd if year == 1920, robust
outreg2 blackdiff20 using results.xls, append
reg whitediff30 blackdiff30 i.city_cd if year == 1930, robust
outreg2 blackdiff30 using results.xls, append

* IV Results Panel: main sample and first stage

use all_hexagon_iv.dta, clear

ivregress2 liml whitediff10 (blackdiff10 = IV_black10) i.city_cd if year == 1910, first
est restore first
outreg2 using resultsiv.xls, cttop(first) replace
est restore second
estat firststage
local fstat `r(mineig)'
outreg2 using resultsiv.xls, cttop(second) excel adds (IV F-stat, `fstat') append
ivregress2 liml whitediff20 (blackdiff20 = IV_black20) i.city_cd if year == 1920, first
est restore first
outreg2 using resultsiv.xls, cttop(first) append
est restore second
estat firststage
local fstat `r(mineig)'
outreg2 using resultsiv.xls, cttop(second) excel adds (IV F-stat, `fstat') append
ivregress2 liml whitediff30 (blackdiff30 = IV_black30) i.city_cd if year == 1930, first
est restore first
outreg2 using resultsiv.xls, cttop(first) append
est restore second
estat firststage
local fstat `r(mineig)'
outreg2 using resultsiv.xls, cttop(second) excel adds (IV F-stat, `fstat') append

* IV Results: Conley GMM spatial standard errors 

* 1910

use all_hexagon_iv.dta, clear
keep if year == 1910
gen merge_var = 10000*city_cd + hexagonID
sort merge_var
merge 1:1 merge_var using estimation_sample_merged.dta
drop _merge

gen cutoff1 = 10000
gen cutoff2 = 10000
gen const = 1

xi i.city_cd
x_gmm x_meters y_meters cutoff1 cutoff2 whitediff10 const _Icity_cd_2-_Icity_cd_11 blackdiff10 const _Icity_cd_2-_Icity_cd_11 IV_black10 , xreg(12) inst(12) coord(2)

* 1920

use all_hexagon_iv.dta, clear
keep if year == 1920
gen merge_var = 10000*city_cd + hexagonID
sort merge_var
merge 1:1 merge_var using estimation_sample_merged.dta
drop _merge

gen cutoff1 = 10000
gen cutoff2 = 10000
gen const = 1

xi i.city_cd
x_gmm x_meters y_meters cutoff1 cutoff2 whitediff20 const _Icity_cd_2-_Icity_cd_11 blackdiff20 const _Icity_cd_2-_Icity_cd_11 IV_black20 , xreg(12) inst(12) coord(2)

* 1930

use all_hexagon_iv.dta, clear
keep if year == 1930
gen merge_var = 10000*city_cd + hexagonID
sort merge_var
merge 1:1 merge_var using estimation_sample_merged.dta
drop _merge

gen cutoff1 = 10000
gen cutoff2 = 10000
gen const = 1

xi i.city_cd
x_gmm x_meters y_meters cutoff1 cutoff2 whitediff30 const _Icity_cd_2-_Icity_cd_11 blackdiff30 const _Icity_cd_2-_Icity_cd_11 IV_black30 , xreg(12) inst(12) coord(2)

* IV Results: Spatial Subsample

/* The values reported in the paper are the average coefficient from 100 subsample regressions.
The spatial subsample standard errors are generated using 25 percent spatially independent subsamples
 bootstrapped 100 times.  */

* 1910

forvalues i = 1(1)100 {

use spatial_subsamples, replace
keep if sample == `i'
sort merge_var
save temp, replace

use all_hexagon_iv.dta, clear

keep if year == 1910
gen merge_var = 10000*city_cd + hexagonID
sort merge_var
merge 1:1 merge_var using temp
keep if _merge == 3

ivregress 2sls whitediff10 i.city_cd (blackdiff10 = IV_black10)

outreg2 using resultsiv_subsmaple_1910.xls, noparen noaster replace

}

*1920

forvalues i = 1(1)100 {

use spatial_subsamples, replace
keep if sample == `i'
sort merge_var
save temp, replace

use all_hexagon_iv.dta, clear

keep if year == 1920
gen merge_var = 10000*city_cd + hexagonID
sort merge_var
merge 1:1 merge_var using temp
keep if _merge == 3

ivregress 2sls whitediff20 i.city_cd (blackdiff20 = IV_black20)

outreg2 using resultsiv_subsmaple_1920.xls, noparen noaster append

}

* 1930

forvalues i = 1(1)100 {

use spatial_subsamples, replace
keep if sample == `i'
sort merge_var
save temp, replace

use all_hexagon_iv.dta, clear

keep if year == 1930
gen merge_var = 10000*city_cd + hexagonID
sort merge_var
merge 1:1 merge_var using temp
keep if _merge == 3

ivregress 2sls whitediff30 i.city_cd (blackdiff30 = IV_black30)

outreg2 using resultsiv_subsmaple_1930.xls, noparen noaster append

}

* Table 3. White Flight Robustness Checks (IV)

/* This code produces the coefficients reported in the paper. To get the Conley standard errors,
modify the code from Table 2 as needed. */

* Baseline

use all_hexagon_iv.dta, clear

ivregress2 liml whitediff10 (blackdiff10 = IV_black10) i.city_cd if year == 1910, first
est restore first
outreg2 using resultsiv.xls, cttop(first) append
est restore second
estat firststage
local fstat `r(mineig)'
outreg2 using resultsiv.xls, cttop(second) excel adds (IV F-stat, `fstat') append
ivregress2 liml whitediff20 (blackdiff20 = IV_black20) i.city_cd if year == 1920, first
est restore first
outreg2 using resultsiv.xls, cttop(first) append
est restore second
estat firststage
local fstat `r(mineig)'
outreg2 using resultsiv.xls, cttop(second) excel adds (IV F-stat, `fstat') append
ivregress2 liml whitediff30 (blackdiff30 = IV_black30) i.city_cd if year == 1930, first
est restore first
outreg2 using resultsiv.xls, cttop(first) append
est restore second
estat firststage
local fstat `r(mineig)'
outreg2 using resultsiv.xls, cttop(second) excel adds (IV F-stat, `fstat') append

* black percent in 1900

ivregress2 liml whitediff10 blackpct00 i.city_cd (blackdiff10 = IV_black10) i.city_cd if year == 1910, first
est restore first
outreg2 using resultsiv.xls, cttop(first) append
est restore second
estat firststage
local fstat `r(mineig)'
outreg2 using resultsiv.xls, cttop(second) excel adds (IV F-stat, `fstat') append
ivregress2 liml whitediff20 blackpct00 i.city_cd (blackdiff20 = IV_black20) i.city_cd if year == 1920, first
est restore first
outreg2 using resultsiv.xls, cttop(first) append
est restore second
estat firststage
local fstat `r(mineig)'
outreg2 using resultsiv.xls, cttop(second) excel adds (IV F-stat, `fstat') append
ivregress2 liml whitediff30  blackpct00 i.city_cd (blackdiff30 = IV_black30 ) i.city_cd if year == 1930, first
est restore first
outreg2 using resultsiv.xls, cttop(first) append
est restore second
estat firststage
local fstat `r(mineig)'
outreg2 using resultsiv.xls, cttop(second) excel adds (IV F-stat, `fstat') append

* number of blacks in 1900

ivregress2 liml whitediff10 black00 i.city_cd (blackdiff10 = IV_black10) i.city_cd if year == 1910, first
est restore first
outreg2 using resultsiv.xls, cttop(first) append
est restore second
estat firststage
local fstat `r(mineig)'
outreg2 using resultsiv.xls, cttop(second) excel adds (IV F-stat, `fstat') append
ivregress2 liml whitediff20 black00 i.city_cd (blackdiff20 = IV_black20) i.city_cd if year == 1920, first
est restore first
outreg2 using resultsiv.xls, cttop(first) append
est restore second
estat firststage
local fstat `r(mineig)'
outreg2 using resultsiv.xls, cttop(second) excel adds (IV F-stat, `fstat') append
ivregress2 liml whitediff30  black00 i.city_cd (blackdiff30 = IV_black30 ) i.city_cd if year == 1930, first
est restore first
outreg2 using resultsiv.xls, cttop(first) append
est restore second
estat firststage
local fstat `r(mineig)'
outreg2 using resultsiv.xls, cttop(second) excel adds (IV F-stat, `fstat') append

* percent black in 1900 and pre-trend in white population

ivregress2 liml whitediff20 whitediff10 blackpct00 i.city_cd (blackdiff20 = IV_black20 ) i.city_cd if year == 1920, first
est restore first
outreg2 using resultsiv.xls, cttop(first) append
est restore second
estat firststage
local fstat `r(mineig)'
outreg2 using resultsiv.xls, cttop(second) excel adds (IV F-stat, `fstat') append
ivregress2 liml whitediff30 whitediff20 blackpct00 i.city_cd (blackdiff30 = IV_black30 ) i.city_cd if year == 1930, first
est restore first
outreg2 using resultsiv.xls, cttop(first) append
est restore second
estat firststage
local fstat `r(mineig)'
outreg2 using resultsiv.xls, cttop(second) excel adds (IV F-stat, `fstat') append

* Southern states IV 

use all_hexagon_iv_south.dta, clear

replace blackdiff10 = southern_blackdiff10
replace blackdiff20 = southern_blackdiff20
replace blackdiff30 = southern_blackdiff30

ivregress2 liml whitediff10 (blackdiff10 = IV_black10) i.city_cd if year == 1910, first
est restore first
outreg2 using resultsiv.xls, cttop(first) append
est restore second
estat firststage
local fstat `r(mineig)'
outreg2 using resultsiv.xls, cttop(second) excel adds (IV F-stat, `fstat') append
ivregress2 liml whitediff20 (blackdiff20 = IV_black20) i.city_cd if year == 1920, first
est restore first
outreg2 using resultsiv.xls, cttop(first) append
est restore second
estat firststage
local fstat `r(mineig)'
outreg2 using resultsiv.xls, cttop(second) excel adds (IV F-stat, `fstat') append
ivregress2 liml whitediff30 (blackdiff30 = IV_black30) i.city_cd if year == 1930, first
est restore first
outreg2 using resultsiv.xls, cttop(first) append
est restore second
estat firststage
local fstat `r(mineig)'
outreg2 using resultsiv.xls, cttop(second) excel adds (IV F-stat, `fstat') append

* IV with no birth cohorts

use all_hexagon_iv_noco.dta, clear

ivregress2 liml whitediff10 (blackdiff10 = IV_black10) i.city_cd if year == 1910, first
est restore first
outreg2 using resultsiv.xls, cttop(first) append
est restore second
estat firststage
local fstat `r(mineig)'
outreg2 using resultsiv.xls, cttop(second) excel adds (IV F-stat, `fstat') append
ivregress2 liml whitediff20 (blackdiff20 = IV_black20) i.city_cd if year == 1920, first
est restore first
outreg2 using resultsiv.xls, cttop(first) append
est restore second
estat firststage
local fstat `r(mineig)'
outreg2 using resultsiv.xls, cttop(second) excel adds (IV F-stat, `fstat') append
ivregress2 liml whitediff30 (blackdiff30 = IV_black30) i.city_cd if year == 1930, first
est restore first
outreg2 using resultsiv.xls, cttop(first) append
est restore second
estat firststage
local fstat `r(mineig)'
outreg2 using resultsiv.xls, cttop(second) excel adds (IV F-stat, `fstat') append

* Baseline IV with heads of household only

use all_hexagon_iv.dta, clear

ivregress2 liml whiteheaddiff10 i.city_cd (blackheaddiff10 = IV_black10) i.city_cd if year == 1910, first
est restore first
outreg2 using resultsiv.xls, cttop(first) append
est restore second
estat firststage
local fstat `r(mineig)'
outreg2 using resultsiv.xls, cttop(second) excel adds (IV F-stat, `fstat') append
ivregress2 liml whiteheaddiff20 i.city_cd (blackheaddiff20 = IV_black20) i.city_cd if year == 1920, first
est restore first
outreg2 using resultsiv.xls, cttop(first) append
est restore second
estat firststage
local fstat `r(mineig)'
outreg2 using resultsiv.xls, cttop(second) excel adds (IV F-stat, `fstat') append
ivregress2 liml whiteheaddiff30 i.city_cd (blackheaddiff30 = IV_black30) i.city_cd if year == 1930, first
est restore first
outreg2 using resultsiv.xls, cttop(first) append
est restore second
estat firststage
local fstat `r(mineig)'
outreg2 using resultsiv.xls, cttop(second) excel adds (IV F-stat, `fstat') append

* Baseline IV by Subgroup

/* This code produces the coefficients reported in the paper. To get the Conley standard errors,
modify the code from Table 2 as needed. */

use all_hexagon_iv.dta, clear

ivregress2 liml white3rddiff10 blackpct00 i.city_cd (blackdiff10 = IV_black10) i.city_cd if year == 1910, first
est restore first
outreg2 using resultsiv.xls, cttop(first) append
est restore second
estat firststage
local fstat `r(mineig)'
outreg2 using resultsiv.xls, cttop(second) excel adds (IV F-stat, `fstat') append
ivregress2 liml white3rddiff20  i.city_cd (blackdiff20 = IV_black20 ) i.city_cd if year == 1920, first
est restore first
outreg2 using resultsiv.xls, cttop(first) append
est restore second
estat firststage
local fstat `r(mineig)'
outreg2 using resultsiv.xls, cttop(second) excel adds (IV F-stat, `fstat') append
ivregress2 liml white3rddiff30  i.city_cd (blackdiff30 = IV_black30) i.city_cd if year == 1930, first
est restore first
outreg2 using resultsiv.xls, cttop(first) append
est restore second
estat firststage
local fstat `r(mineig)'
outreg2 using resultsiv.xls, cttop(second) excel adds (IV F-stat, `fstat') append

ivregress2 liml forborndiff10 i.city_cd (blackdiff10 = IV_black10 ) i.city_cd if year == 1910, first
est restore first
outreg2 using resultsiv.xls, cttop(first) append
est restore second
estat firststage
local fstat `r(mineig)'
outreg2 using resultsiv.xls, cttop(second) excel adds (IV F-stat, `fstat') append
ivregress2 liml forborndiff20 i.city_cd (blackdiff20 = IV_black20 ) i.city_cd if year == 1920, first
est restore first
outreg2 using resultsiv.xls, cttop(first) append
est restore second
estat firststage
local fstat `r(mineig)'
outreg2 using resultsiv.xls, cttop(second) excel adds (IV F-stat, `fstat') append
ivregress2 liml forborndiff30 i.city_cd (blackdiff30 = IV_black30 ) i.city_cd if year == 1930, first
est restore first
outreg2 using resultsiv.xls, cttop(first) append
est restore second
estat firststage
local fstat `r(mineig)'
outreg2 using resultsiv.xls, cttop(second) excel adds (IV F-stat, `fstat') append

ivregress2 liml fforborndiff10  i.city_cd (blackdiff10 = IV_black10 ) i.city_cd if year == 1910, first
est restore first
outreg2 using resultsiv.xls, cttop(first) append
est restore second
estat firststage
local fstat `r(mineig)'
outreg2 using resultsiv.xls, cttop(second) excel adds (IV F-stat, `fstat') append
ivregress2 liml fforborndiff20  i.city_cd (blackdiff20 = IV_black20 ) i.city_cd if year == 1920, first
est restore first
outreg2 using resultsiv.xls, cttop(first) append
est restore second
estat firststage
local fstat `r(mineig)'
outreg2 using resultsiv.xls, cttop(second) excel adds (IV F-stat, `fstat') append
ivregress2 liml fforborndiff30  i.city_cd (blackdiff30 = IV_black30 ) i.city_cd if year == 1930, first
est restore first
outreg2 using resultsiv.xls, cttop(first) append
est restore second
estat firststage
local fstat `r(mineig)'
outreg2 using resultsiv.xls, cttop(second) excel adds (IV F-stat, `fstat') append


* Table 5. White Flight by Neighborhood Black Share (1920s)

use all_hexagon_iv.dta, clear

/* To get the coefficient and standard error (LIML reported in paper, not Conley), just run 

ivregress2 liml whitediff30 blackpct00 (blackdiff30 = IV_black30) i.city_cd

for each part of the blackpct20 distribution:  all, 0-5, 5-10, 10-20, >20
*/

* to get rows 3-6, run the following:

mat distrib = J(8,5,.)

** full sample
use all_hexagon_iv.dta, clear

keep if year==1930

local j = 1

ivregress2 liml whitediff30 blackpct00 (blackdiff30 = IV_black30) i.city_cd

mat beta=e(b)
svmat double beta

forvalues i=1(1)14 {

egen all_beta`i' = max(beta`i')
drop beta`i'
rename all_beta`i' beta`i'

}

gen adjust = 0

* city fixed effect 2 is in beta4

forvalues i = 2(1)11 {
local k = `i'+2

replace adjust = beta14 + beta`k' if city_cd==`i'

}

replace adjust = beta14 if city_cd==1

gen implied_white = adjust + blackdiff30*beta1 + blackpct00*beta2

predict predicted_white

summ white20
mat distrib[1,`j']=r(mean)
summ black20
mat distrib[2,`j']=r(mean)
summ blackdiff30
mat distrib[3,`j']=r(mean)
summ implied_white
mat distrib[4,`j']=r(mean)

** 0-5%
use all_hexagon_iv.dta, clear

keep if year==1930
keep if blackpct20<5 

local j = 2

ivregress2 liml whitediff30 blackpct00 (blackdiff30 = IV_black30) i.city_cd
mat beta=e(b)
svmat double beta

forvalues i=1(1)14 {

egen all_beta`i' = max(beta`i')
drop beta`i'
rename all_beta`i' beta`i'

}

gen adjust = 0

* city fixed effect 2 is in beta4

forvalues i = 2(1)11 {
local k = `i'+2

replace adjust = beta14 + beta`k' if city_cd==`i'

}

replace adjust = beta14 if city_cd==1

gen implied_white = adjust + blackdiff30*beta1 + blackpct00*beta2

summ white20
mat distrib[1,`j']=r(mean)
summ black20
mat distrib[2,`j']=r(mean)
summ blackdiff30
mat distrib[3,`j']=r(mean)
summ implied_white
mat distrib[4,`j']=r(mean)

** 5-10% (has no Manhattan)

use all_hexagon_iv.dta, clear

keep if year==1930
keep if blackpct20>=5 & blackpct20<10

local j = 3

ivregress2 liml whitediff30 blackpct00 (blackdiff30 = IV_black30) i.city_cd

mat beta=e(b)
svmat double beta

* city_cd 8 is not estimated here, constant now in 13

forvalues i=1(1)13 {

egen all_beta`i' = max(beta`i')
drop beta`i'
rename all_beta`i' beta`i'

}

gen adjust = 0

* city fixed effect 2 is in beta4

forvalues i = 2(1)7 {
local k = `i'+2

replace adjust = beta13 + beta`k' if city_cd==`i'

}

forvalues i = 9(1)11 {
local k = `i'+1

replace adjust = beta13 + beta`k' if city_cd==`i'

}

replace adjust = beta13 if city_cd==1 | city_cd==8

gen implied_white = adjust + blackdiff30*beta1 + blackpct00*beta2

summ white20
mat distrib[1,`j']=r(mean)
summ black20
mat distrib[2,`j']=r(mean)
summ blackdiff30
mat distrib[3,`j']=r(mean)
summ implied_white
mat distrib[4,`j']=r(mean)

** 10-20% (no Manhattan)

use all_hexagon_iv.dta, clear

keep if year==1930
keep if blackpct20>=10 & blackpct20<20

local j = 4

ivregress2 liml whitediff30 blackpct00 (blackdiff30 = IV_black30) i.city_cd

mat beta=e(b)
svmat double beta

* city_cd 8 is not estimated here, constant now in 13

forvalues i=1(1)13 {

egen all_beta`i' = max(beta`i')
drop beta`i'
rename all_beta`i' beta`i'

}

gen adjust = 0

* city fixed effect 2 is in beta4

forvalues i = 2(1)7 {
local k = `i'+2

replace adjust = beta13 + beta`k' if city_cd==`i'

}

forvalues i = 9(1)11 {
local k = `i'+1

replace adjust = beta13 + beta`k' if city_cd==`i'

}

replace adjust = beta13 if city_cd==1 | city_cd==8

gen implied_white = adjust + blackdiff30*beta1 + blackpct00*beta2

summ white20
mat distrib[1,`j']=r(mean)
summ black20
mat distrib[2,`j']=r(mean)
summ blackdiff30
mat distrib[3,`j']=r(mean)
summ implied_white
mat distrib[4,`j']=r(mean)

** <20%

use all_hexagon_iv.dta, clear

keep if year==1930
keep if blackpct20>=20

local j = 5

ivregress2 liml whitediff30 blackpct00 (blackdiff30 = IV_black30) i.city_cd

mat beta=e(b)
svmat double beta

* city_cd 8 is not estimated here, constant now in 13

forvalues i=1(1)13 {

egen all_beta`i' = max(beta`i')
drop beta`i'
rename all_beta`i' beta`i'

}

gen adjust = 0

* city fixed effect 2 is in beta4

forvalues i = 2(1)7 {
local k = `i'+2

replace adjust = beta13 + beta`k' if city_cd==`i'

}

forvalues i = 9(1)11 {
local k = `i'+1

replace adjust = beta13 + beta`k' if city_cd==`i'

}

replace adjust = beta13 if city_cd==1 | city_cd==8

gen implied_white = adjust + blackdiff30*beta1 + blackpct00*beta2

summ white20
mat distrib[1,`j']=r(mean)
summ black20
mat distrib[2,`j']=r(mean)
summ blackdiff30
mat distrib[3,`j']=r(mean)
summ implied_white
mat distrib[4,`j']=r(mean)

drop _all
svmat distrib
outsheet distrib* using distrib.xls, replace

* to get row 7, divide row 6 by row 3

* To get Table 6, see "For_replication_simulation.do" and "Table 6 for Replication"





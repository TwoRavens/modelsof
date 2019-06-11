* This file replicates all results in Henderson, Squires, Storeygard, and Weil "The Global Spatial Distribution of Economic Activity: Nature, History, and the Role of Trade"
* Quarterly Journal of Economics
* Code by Cindy Shen, Nick Reynolds, Patrick Mayer, Tim Squires, and Adam Storeygard 

* each of these is self-contained:
* Figure 4
* Table 1
* Table 2
* Figures 1, 2a, 2b
* Figure 3 + urban/GDP analogs
* Figure 7 (+ urban/GDP analogs)
* Table 6

* each of these is self-contained:
* spatial autocorrelation
* Table C1: intensive/extensive
* Table C2: intensive/extensive
* Figure C1
* Tobit
* Figure 8 (+ urb/GDP analogs)
* Table 7
* Gennaioli et al. subnational lights vs GDPpc vs pop

* all these require calculating the sample splits:
* Figures 5a, 5b, 5c
* Table 3 - creates new variables
* Table 4 - creates new variables
* Figure 6
* Table A1/A2
* SD
* Table 5, C3 - creates new variables, takes ~36 hours

* Conley (commented out; takes days)

set logtype text
capture log close
log using replog.txt, replace
set matsize 5000
version 12
clear all
set more off
set rmsg on
ssc install egen_inequal

cd D:\proj\hssw\final\replication\

**********
* Figure 4
**********

insheet using inputdata\LiteracyRatesGlobalLongRun.csv, comma clear
drop if year==.
rename * lit*
rename lityear year
reshape long lit, i(year) j(country) string
gen Country = proper(country)
drop country
replace Country = "Great Britain" if Country=="Greatbritain"
replace Country = "USA" if Country=="Usa"
append using inputdata\indialiteracy.dta

gen early = 1
replace early = 0 if Country=="Brazil" | Country=="India" | Country=="Mexico" | Country=="Peru"
rename Country country
drop if country=="World"
append using inputdata\freight.dta
replace country = "World" if lit==.
encode country, gen(cnum)
lab var lit "Adult literacy rate (%)"
save literacyfreight, replace

use literacyfreight, clear
lab var globalrealfreightindex "Freight Index"
xtset cnum year
keep if globalrealfreightindex<. | lit<.
preserve

* 4b
keep if early==0 | country=="World"
xtset cnum year
twoway ///
(connected lit year if country=="Brazil", lpattern(solid) lcolor(black) msymbol(circle) mcolor(black)) ///
(connected lit year if country=="India", lpattern(dash) lcolor(black) msymbol(diamond) mcolor(black)) ///
(connected lit year if country=="Mexico", lpattern(shortdash) lcolor(black) msymbol(square) mcolor(black)) ///
(connected lit year if country=="Peru", lpattern(dot) lcolor(black) msymbol(circle_hollow) mcolor(black)) ///
(scatter globalrealfreightindex year if country=="World" & year~=1917 & year~=1942 & year~=1937, yaxis(2) lcolor(black) msymbol(X) mcolor(black)) ///
, xlabel(1880(20)2000) ysize(3) xsize(5) ///
legend(position(3) cols(1) symysize(3) symxsize(10) size(3) ///
order(1 "Brazil" 2 "India" 3 "Mexico" 4 "Peru" 5 "Freight Index"))
graph export "output/fig4b.eps", replace

* 4a
restore
keep if early==1 | country=="World"
xtset cnum year
twoway ///
(connected lit year if country=="Argentina", lpattern(solid) lcolor(black) msymbol(circle) mcolor(black)) ///
(connected lit year if country=="Belgium", lpattern(dash) lcolor(black) msymbol(diamond) mcolor(black)) ///
(connected lit year if country=="Chile", lpattern(shortdash) lcolor(black) msymbol(square) mcolor(black)) ///
(connected lit year if country=="France", lpattern(dash_dot_dot) lcolor(black) msymbol(circle_hollow) mcolor(black)) ///
(connected lit year if country=="Germany", lpattern(dot) lcolor(black)  msymbol(square_hollow) mcolor(black)) ///
(connected lit year if country=="Great Britain", lpattern(solid) lcolor(gs7) msymbol(circle) mcolor(gs7)) ///
(connected lit year if country=="Ireland", lpattern(dash) lcolor(gs7) msymbol(diamond) mcolor(gs7)) ///
(connected lit year if country=="Italy", lpattern(shortdash) lcolor(gs7) msymbol(square) mcolor(gs7)) ///
(connected lit year if country=="Netherlands", lpattern(dash_dot_dot) lcolor(gs7) msymbol(circle_hollow) mcolor(gs7)) ///
(connected lit year if country=="Poland", lpattern(dot) lcolor(gs7) msymbol(square_hollow) mcolor(gs7)) ///
(connected lit year if country=="Russia", lpattern(solid) lcolor(gs12) msymbol(circle) mcolor(gs12)) ///
(connected lit year if country=="Spain", lpattern(dash) lcolor(gs12) msymbol(diamond) mcolor(gs12)) ///
(connected lit year if country=="Sweden", lpattern(shortdash) lcolor(gs12) msymbol(square) mcolor(gs12)) ///
(connected lit year if country=="USA", lpattern(dash_dot_dot) lcolor(gs12) msymbol(circle_hollow) mcolor(gs12)) ///
(scatter globalrealfreightindex year if country=="World" & year~=1917 & year~=1942 & year~=1937, yaxis(2) lcolor(black) msymbol(X) mcolor(black)) ///
, xlabel(1500(100)2000) ysize(3) xsize(5) ///
legend(position(3) cols(1) symysize(3) symxsize(10) size(3) ///
order(1 "Argentina" 2 "Belgium" 3 "Chile" 4 "France" 5 "Germany" ///
6 "Great Britain" 7 "Ireland" 8 "Italy" 9 "Netherlands" 10 "Poland" ///
11 "Russia" 12 "Spain" 13 "Sweden" 14 "USA" 15 "Freight Index"))
graph export "output/fig4a.eps", replace

*********************************************
* Merge national level variables together:
*********************************************

* http://www.barrolee.com/data/BL_v2.1/BL2013_MF1599_v2.1.dta
* https://scholar.harvard.edu/files/shleifer/files/data_and_online_appendix.xlsx
* https://scholar.harvard.edu/files/shleifer/files/regions_data_web_july2012.xls
* https://esa.un.org/unpd/wup/CD-ROM/WUP2014_XLS_CD_FILES/WUP2014-F03-Urban_Population.xls
* https://esa.un.org/unpd/wup/CD-ROM/WUP2014_XLS_CD_FILES/WUP2014-F05-Total_Population.xls
* https://esa.un.org/unpd/wup/CD-ROM/WUP2014_XLS_CD_FILES/WUP2014-F00-Locations.xls
* http://api.worldbank.org/v2/en/indicator/AG.LND.TOTL.K2?downloadformat=excel

*Gennaioli et al. (2013):
import excel inputdata\regions_data_web_july2012.xls, sheet("Table02Data") firstrow clear
gen pop = round(exp(POPij),1)
egen WeightedEduGini = inequal(YearsEd), by(CodeNum) weights(pop) index(gini)
collapse WeightedEduGini, by(Code)
rename Code countrycode
replace countrycode = "ROU" if countrycode=="ROM"
replace countrycode = "COD" if countrycode=="ZAR"
save ginitmp, replace

* United Nations (2014) Urban and total populations and country codes:
import excel inputdata\WUP2014-F03-Urban_Population.xls, sheet("DATA") cellrange(A17:Y290) firstrow clear
rename E urbanpop1950
keep CountryCode urbanpop1950
save urbanpoptmp, replace
import excel inputdata\WUP2014-F05-Total_Population.xls, sheet("DATA") cellrange(A17:Y290) firstrow clear
rename E pop1950
rename Q pop2010
keep CountryCode pop1950 pop2010
save totalpoptmp, replace
import excel inputdata\WUP2014-F00-Locations.xls, sheet("DATA") cellrange(A17:U290) firstrow clear
rename Code CountryCode 
rename Alphacode iso3 
keep CountryCode iso3
save codestmp, replace

* Barro and Lee (2010):
use inputdata\BL2013_MF1599_v2.1.dta, clear
keep if year==1950
rename yr_sch yr_sch1950
keep WBcode yr_sch1950
replace WBcode = "MDA" if WBcode=="ROM"
save barroleetmp, replace

* Land area from World Development Indicators:
import excel inputdata\API_AG.LND.TOTL.K2_DS2_en_excel_v2.xls, sheet("Data") cellrange(A4:BI268) firstrow clear
keep CountryCode BC
rename CountryCode countrycode 
rename BC areasqkm
save areatmp, replace

* Merge UN (2014) data together with country codes:
use codestmp, clear
erase codestmp.dta
merge 1:1 CountryCode using urbanpoptmp
drop _merge
erase urbanpoptmp.dta
merge 1:1 CountryCode using totalpoptmp
drop _merge
erase totalpoptmp.dta
drop if iso3==""
* merge South Sudan into Sudan:
replace iso3 = "SDN" if iso3=="SSD"
collapse (sum) urbanpop1950 pop1950 pop2010, by(iso3)
gen urbanization1950 = 100*urbanpop1950/pop1950
keep iso3 urbanization1950 pop2010
save popdatatmp, replace

* merge all national data:
use inputdata\maddison_and_codes, clear
gen iso3 = countrycode
merge m:1 iso3 using popdatatmp
erase popdatatmp.dta
drop if _merge==2
drop _merge
gen WBcode = iso3
merge m:1 WBcode using barroleetmp
erase barroleetmp.dta
drop if _merge==2
drop _merge WBcode
merge m:1 countrycode using ginitmp
erase ginitmp.dta
drop if _merge==2
drop _merge
merge m:1 countrycode using areatmp
erase areatmp.dta
drop if _merge==2
drop _merge iso3
lab var yr_sch1950 "Years avg educ in pop over 15 in 1950, Barro & Lee (2010)"
lab var urbanization1950 "Urbanization rate 1950, %, WUP 2014"
lab var pop2010 "Total population 2010, thousands, WUP 2014"
lab var countrycode "3-letter country code"
lab var hsswname "Country name"
lab var WeightedEduGini "Gini of Gennaioli et al. (2013) years of education measure across regions"
lab var areasqkm "landarea, square kilometers"
save natvars, replace

**********************
* Build full dataset:
**********************

use inputdata\data1_12slim, clear
merge m:1 natlarge using natvars
drop _merge

* create new variables
gen x3 = round(4*x - 1,3)
gen y3 = round(4*y - 1,3)
egen long clust = group(x3 y3)
drop x3 y3
gen lat = abs(y + 0.125)
gen byte harbor25 = harbordist<25
gen byte river25 = riv<25
gen byte lake25 = lakebigdist<25
tabulate natlarge, generate(nats)
tabulate ecosystems, generate(biomes)
gen byte biomes2_3 = biomes2 + biomes3
gen byte biomes7_9 = biomes7 + biomes9

gen rad2010clip_pl_c = rad_nogf_cl2010 / num_land_pixel
gen lrad2010clip_pl_c = log(rad2010clip_pl_c)
replace lrad2010clip_pl_c = log(0.0033995) if rad2010clip_pl_c==0

* continent dummies:
gen byte africa=0
replace africa=1 if natlarge>290
gen byte asia=0
replace asia=1 if natlarge<290 & natlarge>149
gen byte europe=0
replace europe=1 if natlarge<150 & natlarge>100
gen byte namerica=0
replace namerica=1 if natlarge>49 & natlarge<100
gen byte oceania=0
replace oceania=1 if natlarge>21 & natlarge<47
gen byte samerica=0
replace samerica=1 if natlarge<20 & natlarge>0
gen byte newworld=0
replace newworld=1 if samerica==1 | namerica==1 | oceania==1
* Fiji, New Caledonia, Papua New Guinea, Solomon Islands, Vanuatu (all oceania except AUS, NZL, WSM)
replace newworld=0 if natlarge==25 | natlarge==40 | natlarge==44 | natlarge==31 | natlarge==38
* gen newworld2=0
*replace newworld2=1 if samerica==1 | namerica==1 | natlarge==23 | natlarge==35
gen byte oldworld=0
replace oldworld=1 if europe==1 | asia==1 | africa==1
gen byte oldworld2=0
replace oldworld2=1 if europe==1 | asia==1

* label new variables:
label var clust "id of 3x3 block"
label var lat "abs(latitude)"
lab var harbor25 "1(within 25km of natural harbor)
lab var river25 "1(within 25km of navigable river)
lab var lake25 "1(within 25km of big lake (area>5000 sq km))
label var biomes1 "tropical moist forest"
label var biomes2_3 "tropical dry forest"
label var biomes4 "temperate broadleaf"
label var biomes5 "temperate conifer"
label var biomes6 "boreal forest"
label var biomes7_9 "tropical grassland"
label var biomes8 "temperate grassland"
label var biomes10 "montane grassland"
label var biomes11 "tundra"
label var biomes12 "Mediterranean forest"
label var biomes13 "desert"
label var biomes14 "mangroves"
label var biomes2 "tropical dry broad forest"
label var biomes3 "tropical dry conifer forest"
label var biomes7 "savanna"
label var biomes9 "flooded savanna"

* rescale rugged distc elv
replace elv = elv/1000
replace rugged = rugged/1000
replace distc = distc/1000
label variable elv "Elevation, km above sea level"
label variable rugged "Ruggedness (000s of index)"
label var distc "Distance to the nearest coast, 000s km"

capture rename urbanization1950 urb1950
capture rename gdp_percap_1950_madd gdp1950
capture gen ln_gdp1950 = ln(gdp1950)
egen tag = tag(natlarge)

***************************
* Basic model covariates: *
***************************

global agriculture "biomes1 biomes2_3 biomes4 biomes5 biomes6 biomes7_9 biomes8 biomes10 biomes11 biomes12 biomes14 tmp precip growday landsuit lat elv"
global trade "coastal distc harbor25 river25 lake25"
global base "rugged malariaecol"

foreach x of var lrad2010clip_pl_c $agriculture $trade $base {
	drop if `x' == .
}
compress
save data1_regs, replace

* check binary variables:
foreach v of varlist onriv harbor25 river25 lake25 coastal biomes1 biomes2 biomes3 biomes4 biomes5 biomes6 biomes7 biomes8 biomes9 biomes10 biomes11 biomes12 biomes13 biomes14 biomes2_3 biomes7_9 africa asia europe namerica oceania samerica oldworld newworld {
	local lab: variable label `v'
	scatter y x if `v'==1, msize(vtiny) ylabel(-60(15)75) xlabel(-180(30)180) title(`v': `lab')
	capture graph export checkmaps/`v'check.pdf, replace
}

* Basic model covariates: 
* Base covariates: malaria index, ruggedness
* AG (the original): biome dummies, growing days, land suitability, abs latitude, prec, temp, elevation
* Trade: coastal, harbor25, river 25, lake25, distc

***********************************************************************
***  TABLE 1. Summary statistics and baseline regression results   ****
***********************************************************************

global biomes biomes1 biomes2_3 biomes4 biomes5 biomes6 biomes7_9 biomes8 biomes10 biomes11 biomes12 biomes14

global ag_sum biomes1 biomes2_3 biomes4 biomes5 biomes6 biomes7_9 biomes8 biomes10 biomes11 biomes12 biomes14 biomes13 tmp precip growday landsuit lat elv 

* summary statistics
estpost sum lrad2010clip_pl_c $base $ag_sum $trade
matrix mean = e(mean)
matrix sd = e(sd)
matrix min = e(min)
matrix max = e(max)


* No FEs:
* run regression and get shapley values:
rego lrad2010clip_pl_c  rugged \ malariaecol \ $biomes \ tmp \ precip \ growday \ landsuit \ lat \ elv \ coastal \ distc \ harbor25 \ river25 ///
	\ lake25 , force vce(cluster clust)
* record coefficients, SEs and shapley values:
matrix no_fe_b = e(b)
matrix no_fe_se = (_se[rugged])
foreach var of varlist malariaecol $agriculture $trade {
	matrix no_fe_se = (no_fe_se, _se[`var'])
}
matrix no_fe_shapley = e(shapley)
* name matrix columns:
matrix colnames no_fe_se  = rugged malariaecol $agriculture $trade
matrix colnames no_fe_shapley = rugged  malariaecol  biomes1  tmp  precip  growday  landsuit  lat  elv  coastal  distc harbor25  river25  lake25  ///

scalar no_fe_N = e(N)
scalar no_fe_r2 = e(r2)

*create matrix of stars
matrix no_fe_stars = (abs(_b[rugged]/_se[rugged]) > invttail(`e(df_r)',0.1/2)) + ///
					(abs(_b[rugged]/_se[rugged]) > invttail(`e(df_r)',0.05/2)) + ///
					(abs(_b[rugged]/_se[rugged]) > invttail(`e(df_r)',0.01/2))
foreach var of varlist malariaecol $agriculture $trade {
	local foo = (abs(_b[`var']/_se[`var']) > invttail(`e(df_r)',0.1/2)) + ///
				(abs(_b[`var']/_se[`var']) > invttail(`e(df_r)',0.05/2)) + ///
				(abs(_b[`var']/_se[`var']) > invttail(`e(df_r)',0.01/2))
						
	matrix no_fe_stars = (no_fe_stars, `foo')
}	
matrix colnames no_fe_stars  = rugged malariaecol $agriculture $trade


*W/ Fixed-effects
* run regression and get shapley values:
rego lrad2010clip_pl_c   rugged \ malariaecol \ $biomes \ tmp \ precip \ growday \ landsuit \ lat \ elv \ coastal \ distc \ harbor25 \ river25 ///
	\ lake25  \ nats*, force vce(cluster clust)
estimates store fe

estimates restore fe
	
estadd matrix no_fe_stars = no_fe_stars, replace

estadd matrix no_fe_b = no_fe_b, replace
estadd  matrix no_fe_se = no_fe_se, replace
estadd  matrix no_fe_shapley = no_fe_shapley, replace
estadd scalar no_fe_N = no_fe_N, replace
estadd scalar no_fe_r2 = no_fe_r2, replace
	
estadd matrix mean = mean, replace
estadd matrix sd = sd, replace
estadd matrix min = min, replace
estadd matrix max = max, replace

matrix b = e(b)
estadd matrix fe_b = b, replace

matrix fe_se = (_se[rugged])
foreach var of varlist malariaecol $agriculture $trade {
	display `"`var'"'
	matrix fe_se = (fe_se, _se[`var'])
}
matrix colnames fe_se  = rugged malariaecol $agriculture $trade
matrix fe_shapley = e(shapley)
matrix colnames fe_shapley = rugged  malariaecol  biomes1  tmp  precip  growday  landsuit  lat  elv  coastal  distc harbor25  river25  lake25 countryFEs ///
		
estadd matrix fe_shapley = fe_shapley, replace
estadd matrix fe_se = fe_se		, replace

scalar fe_N = e(N)
scalar fe_r2 = e(r2)
estadd scalar fe_N = fe_N, replace
estadd scalar fe_r2 = fe_r2, replace
		
*create matrix of stars
matrix fe_stars = (abs(_b[rugged]/_se[rugged]) > invttail(`e(df_r)',0.1/2)) + ///
								(abs(_b[rugged]/_se[rugged]) > invttail(`e(df_r)',0.05/2)) + ///
								(abs(_b[rugged]/_se[rugged]) > invttail(`e(df_r)',0.01/2))
foreach var of varlist malariaecol $agriculture $trade {
	local foo = (abs(_b[`var']/_se[`var']) > invttail(`e(df_r)',0.1/2)) + ///
						(abs(_b[`var']/_se[`var']) > invttail(`e(df_r)',0.05/2)) + ///
						(abs(_b[`var']/_se[`var']) > invttail(`e(df_r)',0.01/2))
	matrix fe_stars = (fe_stars, `foo')
}					

matrix colnames fe_stars  = rugged malariaecol $agriculture $trade
estadd matrix fe_stars = fe_stars, replace
estadd scalar foo = ., replace
	
matrix list e(no_fe_stars)
	
esttab using "output/table1.tex", cells( (mean(fmt(a3)) min(fmt(a3)) no_fe_b(fmt(a3)) & no_fe_stars no_fe_shapley(fmt(a3))  ///
	fe_b(fmt(a3)) & fe_stars fe_shapley(fmt(a3))) (sd(fmt(a3) par) max(fmt(a3)) no_fe_se(fmt(a3) par) . fe_se(fmt(a3) par) .)) ///
	keep(lrad2010clip_pl_c $base $ag_sum $trade)  ///
	stats(N foo no_fe_N foo fe_N foo foo no_fe_r2 foo fe_r2, layout("@ @ @ @ @ " "@ @ @ @ @") labels("Number of observations" ///
	 "R-squared" "foo" )) ///
	 mlabels(none) collabels("mean, (sd)" "min - max" "No FEs - b" "No FEs - Shapley" "W/ FEs - b" "W/ FEs - Shapley") incelldelimiter("star") ///
	 refcat(lrad2010clip_pl_c "\textbf{Dependent variable}" rugged "\textbf{Base covariates}" biomes1 "\textbf{Agriculture covariates}" ///
	 coastal "\textbf{Trade covariates}", nolabel)  replace  nonumbers style(tex) title("Table 1: Summary Statistics and Baseline Regression Results") ///
	 varlabels(lrad2010clip_pl_c "ln(light/land pixels)" rugged "ruggedness (000s)" malariaecol "malaria index" biomes1 "tropical moist forest" biomes2_3 ///
	 "tropical dry forest" biomes4 "temperate broadleaf" biomes5 "temperate conifer" biomes6 "boreal forest" biomes7_9 "tropical grassland" ///
	 biomes8 "temperate grassland" biomes10 "montane grassland" biomes11 "tundra" biomes12 "Mediterranean forest" biomes14 "mangroves" biomes13 "desert" ///
	tmp "temperature (deg. C)" precip "precipitation (mm/month)" growday "growing days" landsuit "land suitability" lat "abs(latitude)" elv "elevation (km)" ///
	coastal "coast" distc "distance to coast (000s km)" harbor25 "harbor $<$ 25km" river25 "river $<$ 25km" lake25 "lake $<$ 25km") ///
	 substitute("\begin{tabular}{l*{1}{cccccc}}"  "\begin{adjustbox}{max width=\textwidth} \begin{tabular}{l*{6}{c}}" ///
	 "\end{tabular}" "\end{tabular} \end{adjustbox}" ///
	 "&  mean, (sd)&   min - max&  No FEs - b&No FEs - Shapley&  W/ FEs - b&W/ FEs - Shapley" ///
	 "& \multicolumn{2}{c}{\underline{Summary Statistics}} & \multicolumn{2}{c}{\underline{Regression w/out FEs} } & \multicolumn{2}{c}{\underline{Regression w/ FEs}} \\          &  mean, (sd)&   min, max&  Coefficient & Shapley &  Coefficient& Shapley" ///
	 "star&" "&" "star1" "*" "star0" "" "star2" "**" "star3" "***" ".&" "&" ".\" "\" "\caption" "\caption*")
*/			 
**************************************
****** Table 2: R2 and Shapley *******
**************************************
use data1_regs, clear

*set up matrix to fill
matrix table2 = J(11,2,.)

*Panel A has R-squared for different versions of regresion

*And fill w/ R^2
* All variables, both margins
*w/out FE
reg lrad2010clip_pl_c rugged malariaecol $agriculture $trade
matrix table2[2,1] = e(r2)

*w/ FE
reg lrad2010clip_pl_c rugged malariaecol $agriculture $trade nats*
matrix table2[2,2] = e(r2)

* Base variables (malaria, ruggedness)
reg lrad2010clip_pl_c rugged malariaecol
matrix table2[3,1] = e(r2)

reg lrad2010clip_pl_c rugged malariaecol nats*
matrix table2[3,2] = e(r2)

* Agriculture variables, both margins (plus base)
reg lrad2010clip_pl_c rugged malariaecol $agriculture
matrix table2[4,1] = e(r2)

reg lrad2010clip_pl_c rugged malariaecol $agriculture nats*
matrix table2[4,2] = e(r2)

* Trade variables, both margins (plus base) 
reg lrad2010clip_pl_c rugged malariaecol $trade
matrix table2[5,1] = e(r2)

reg lrad2010clip_pl_c rugged malariaecol $trade nats*
matrix table2[5,2] = e(r2)

*Just country FEs
reg lrad2010clip_pl_c  nats*
matrix table2[6,2] = e(r2)

*Panel B has Shapley values for groups of variables
	
rego lrad2010clip_pl_c  $base \ $agriculture \ $trade, force
matrix no_fe_shapley =e(shapley)
matrix table2[8,1] = no_fe_shapley[1,1]
matrix table2[9,1] = no_fe_shapley[1,2]
matrix table2[10,1] = no_fe_shapley[1,3]

* ~7 minutes
rego lrad2010clip_pl_c  $base \ $agriculture \ $trade \ nats*, force
matrix fe_shapley =e(shapley)
matrix table2[8,2] = fe_shapley[1,1]
matrix table2[9,2] = fe_shapley[1,2]
matrix table2[10,2] = fe_shapley[1,3]
matrix table2[11,2] = fe_shapley[1,4]		
	 
matrix list table2

local tmp: di %9.0fc _N
frmttable using output/table2, statmat(table2) rtitles("\textbf{Panel A - R-squared}" \ "(1) All variables (N = `tmp')"  ///
\ "(2) Base variables (malaria, ruggedness)" \ "(3) Agriculture variables (plus base)" \ ///
"(4) Trade variables (plus base)" \ "(5) Country fixed effects"  \ "\textbf{Panel B - Shapley values}" \ "(1) Base" \ "(2) Agriculture" \ ///
"(3) Trade" \ "(4) Country FEs" ) ///
	ctitles("" , "(1)" , "(2)" \ "" , "No country FEs" , "With country FEs" ) ///
	title("Table 2: R-squared and Shapley values from regressions predicting ln(light/land pixels)") sdec(3) spacebef("110110000110000") replace tex frag
		
********************************************************************************
******** Figure 1, 2a and 2b - maps of predicted lights w/ and w/ out FEs ******
********************************************************************************
use data1_regs, clear

*Demean each separately

*Figure 2a. Demeaned predicted lights without fixed effects
reg lrad2010clip_pl_c  rugged malariaecol $agriculture $trade

predict predlights_noFE

egen mean_pred_noFE = mean(predlights_noFE)
gen dmpredlights_noFE = predlights_noFE - mean_pred_noFE

outsheet x y dmpredlights_noFE using output/dm_predlights_noFE.csv, comma nolabel replace 

xi: reg lrad2010clip_pl_c  rugged malariaecol $agriculture $trade i.natlarge

* change country dummies to 0
foreach x of var _Inatlarge_* {
	replace `x' = 0
}

predict predlights_FE

egen mean_pred_FE = mean(predlights_FE)
gen dmpredlights_FE = predlights_FE - mean_pred_FE

outsheet x y dmpredlights_FE using output/dm_predlights_FE.csv, comma nolabel replace 

*Figure 1. Demeaned lights
egen mean_lrad2010clip_pl_c = mean(lrad2010clip_pl_c)
gen dm_lrad2010clip_pl_c = lrad2010clip_pl_c - mean_lrad2010clip_pl_c

outsheet x y dm_lrad2010clip_pl_c using output/dm_lights.csv, comma nolabel replace 

*Figure 2b. Demeaned predicted lights with fixed effects
reg lrad2010clip_pl_c   nats*

predict resid_fe_only, resid

egen mean_resid_fe_only = mean(resid_fe_only)
gen dm_resid_fe_only = resid_fe_only - mean_resid_fe_only

outsheet x y resid_fe_only using output/dm_resid_fe.csv, comma nolabel replace 

******************************************************************************************************************************************************		
************* Figure 3: Difference in average residual of coastal/river and interior cells, by country plotted against average yrs schooling in 1950 *
******************************************************************************************************************************************************

use data1_regs, clear
*Run main regression equation from paper
reg lrad2010clip_pl_c $base $agriculture $trade nats*

*store residuals
predict res_lrad2010clip_pl_c, residual

*generate coast/river dummy
gen byte coast_onriv = coastal
replace coast_onriv = 1 if onriv == 1

*see which countries are still all "coastal"
tabstat coastal coast_onriv, by(natlarge) 

*Calculate weighted and unweighted average of residuals for each country, separately for river/coastal and interior cells
*unweighted average
bys natlarge : egen cr_a_foo = mean(res_lrad2010clip_pl_c) if coast_onriv == 1
bys natlarge : egen ir_a_foo = mean(res_lrad2010clip_pl_c) if coast_onriv == 0
			
bys natlarge : egen cr_a_resid = mean(cr_a_foo)
bys natlarge : egen ir_a_resid = mean(ir_a_foo)
gen diff_cir_resid =  cr_a_resid -  ir_a_resid 
				
*weighted average (by number of land pixels)
bys natlarge : egen foo_numer = total(num_land_pixels*res_lrad2010clip_pl_c) if coast_onriv == 1
bys natlarge : egen foo_denom = total(num_land_pixels)  if coast_onriv == 1
gen cr_wa_foo = foo_numer / foo_denom  if coast_onriv == 1
bys natlarge : egen cr_wa_resid = mean(cr_wa_foo)

drop foo*
		
bys natlarge coast_onriv : egen foo_numer = total(num_land_pixels*res_lrad2010clip_pl_c) if coast_onriv == 0
bys natlarge coast_onriv : egen foo_denom = total(num_land_pixels)  if coast_onriv == 0
gen ir_wa_foo = foo_numer / foo_denom  if coast_onriv == 0
bys natlarge : egen ir_wa_resid = mean(ir_wa_foo)
	
drop foo* *_foo

*Then plot the differences in residuals for each country by each "cutting variable"

*Education, Fig 3
twoway scatter diff_cir_res yr_sch1950 if tag, mlabel(countrycode)  mlabsize(vsmall) msize(small) || lfit diff_cir_res yr_sch1950 if tag , legend(off) xtitle("Average years of schooling in 1950") ///
		ytitle("Difference between avg. residual for" "gridsquares on coast/river and in interior")
	graph export "output/coast_int_unw_educ.eps", replace

*Urbanization, analog
twoway scatter diff_cir_res urb1950 if tag, mlabel(countrycode) mlabsize(vsmall) msize(small) || lfit diff_cir_res urb1950 if tag , legend(off) ///
		xtitle("Urbanization rate in 1950") ///
		ytitle("Difference between avg. residual for" "gridsquares on coast/river and in interior")
	graph export "output/coast_int_unw_urb.eps", replace

*GDP per capita analog
twoway scatter diff_cir_res ln_gdp1950 if tag, mlabel(countrycode)  mlabsize(vsmall) msize(small) || ///
lfit diff_cir_res ln_gdp1950 if tag , legend(off) ///
		xtitle("Log of GDP per capita in 1950") xscale(r(10.5)) ///
		ytitle("Difference between avg. residual for" "gridsquares on coast/river and in interior") ///
		title("Difference between average coastal/river and " "average interior residuals, by GDP per capita in 1950") ///
		subtitle("unweighted avg.")
	graph export "output/coast_int_unw_gdp.eps", replace

***************************************************************************************************************************************************************
********** Figure 7:  Spatial Gini in lights by grid cell by years of schooling 1950 *****************************************************************
***************************************************************************************************************************************************************
use data1_regs, clear
*Calculate light Ginis for (max{3.05,radiance2010land})
*This allows me to compare to predicted lights from main HSSW regression

*Function that calculates gini of variable by another
capture program drop gini_by
program define gini_by
	syntax varlist, by(varlist)
	foreach var of varlist `varlist'{
		gen gini_`var' = .
		levelsof `by', local(bylevels)
		foreach group in `bylevels' {
				capture fastgini `var' if `by' == `group'
				if _rc == 0 {
					replace gini_`var' = r(gini)  if `by' == `group'
				}
		}
		capture replace gini_`var' = . if `by' == .
		capture replace gini_`var' = . if `by' == ""
	}
end	

*Calculate true Gini

sum  rad2010clip_pl_c

gini_by rad2010clip_pl_c, by(natlarge)

*W/ FEs
reg lrad2010clip_pl_c $base $agriculture $trade nats*
predict lrad2010clip_pl_c_hat_fe, xb
gen hat_fe_rad2010clip_pl_c = exp(lrad2010clip_pl_c_hat_fe)

*And calculate Gini of predicted lights for each country
gini_by hat_fe_rad2010clip_pl_c, by(natlarge)

*Graph true Gini by ed, urb, gdp
*Educ
twoway scatter gini_rad2010clip_pl_c yr_sch1950 if tag,  mlabel(countrycode) mlabsize(vsmall) msize(small) || lfit gini_rad2010clip_pl_c yr_sch1950 if tag , ///
					legend(off) xtitle("Average years of schooling in 1950") ///
					ytitle("Gini coefficient of lights") // title("Gini coefficient of lights, by education in 1950")
					graph export "output/gini_by_educ.eps", replace

*Urb
twoway scatter gini_rad2010clip_pl_c urb1950 if tag, mlabel(countrycode) mlabsize(vsmall) msize(small) msize(small) || lfit gini_rad2010clip_pl_c urb1950 if tag , ///
					legend(off) xtitle("Urbanization rate in 1950") ///
					ytitle("Gini coefficient of lights") // title("Gini coefficient of lights, by urbanization rate in 1950")
					graph export "output/gini_by_urb.eps", replace

*GDP
twoway scatter gini_rad2010clip_pl_c ln_gdp1950 if tag, mlabel(countrycode) mlabsize(vsmall) || lfit gini_rad2010clip_pl_c ln_gdp1950 if tag , ///
					legend(off) xtitle("Log of GDP per capita in 1950") ///
					ytitle("Gini coefficient of lights") // title("Gini coefficient of lights, by GDP per capita in 1950")
					graph export "output/gini_by_gdp.eps", replace					

**************************************************************************		
******************* Table 6: Lights Gini *********************************
**************************************************************************

*Regression of Gini of lights by grid cell on Ed, Urb, and GDP 1950.  
*First calculate land area of each country
bys natlarge: egen cntry_area = total(land)
gen ln_cntry_area = ln(cntry_area)
*pop2010 is missing for a few cells of some countries
bys natlarge: egen foo_pop2010 = mean(pop2010)
compare pop2010 foo_pop2010
replace pop2010 = foo_pop2010
drop foo_pop2010
gen ln_pop2010 = ln(pop2010)

*For each of these, do three regression: (i) by itself, (ii) with gini of predicted lights, and 
*(iii) with gini of predicted lights, ln(area), and ln(population).
*Program that changes name of variable in stored estimation results
capture program drop change_name_coef
program define change_name_coef, eclass
	local var `1'
	local new_name `2'
	local colnames: colnames b
	local new_colnames ""
	display `"`colnames'"'
	foreach name in `colnames' 	{
		if strrpos(`"`name'"', `"`var'"') == 0 {
				local new_colnames `"`new_colnames' `name'"'
		}
		else {
				local new_colnames `"`new_colnames' `new_name'"'
		}
	}
	display `"`new_colnames'"'
		
	matrix colnames b = `new_colnames'
	matrix colnames V = `new_colnames'
	matrix rownames V = `new_colnames'

	ereturn post b V
end

capture gen ln_gdp1950 = ln(gdp1950)
foreach var of varlist yr_sch1950 urb1950 ln_gdp1950 {
	reg gini_rad2010clip_pl_c `var' if tag, robust
	eststo `var'_gini_1
	
	reg gini_rad2010clip_pl_c `var' gini_hat_fe_rad2010clip_pl_c if tag, robust
	eststo `var'_gini_2
	
	reg gini_rad2010clip_pl_c `var' gini_hat_fe_rad2010clip_pl_c ln_cntry_area  ln_pop2010 if tag, robust
	eststo `var'_gini_3

}
		
esttab *_gini_*		using "output/table6.tex" , se  r2 replace ///
varlabels(gini_hat_fe_rad2010clip_pl_c "Gini of predicted lights" ln_cntry_area "ln(land area)" ///
	ln_pop2010 "ln(population in 2010)" yr_sch1950 "Education 1950" urb1950 "Urbanization 1950" ///
	ln_gdp1950 "ln(GDP per cap. 1950)" _cons "constant") ///
	nomtitles star(* 0.10 ** 0.05 *** 0.01) ///
	order(yr_sch1950 urb1950 ln_gdp1950) ///
	substitute("\begin{tabular}{l*{9}{c}}"  "\begin{table}[htbp]\centering \def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \caption*{Table 6: Gini coefficient of lights} \begin{adjustbox}{max width=\textwidth} \begin{tabular}{l*{9}{c}}" ///
"\end{tabular}" "\end{tabular} \end{adjustbox} \end{table}")

********************************************************************************
********Online Appendix/not shown***********************************************
********************************************************************************

use data1_regs, clear

* Spatial correlation of RHS vars
*For each Variable in local list it creates all the neighbors with the name `x'_`direction'
*generates a variable z_* which is the value of the neighbors `x'
global list lrad2010clip_pl_c $base $agriculture $trade

gen row = 301-4*y
gen col = 721+4*x
recast int row col
generate colminusrow = col - row           
generate colplusrow = col + row 

foreach x of var $list {
	by col (row), sort: generate `x'_s = `x'[_n-1] if row[_n-1]==row+1
	by col (row), sort: generate `x'_n = `x'[_n+1] if row[_n+1]==row-1
	by row (col), sort: generate `x'_w = `x'[_n-1] if col[_n-1]==col-1
	by row (col), sort: generate `x'_e = `x'[_n+1] if col[_n+1]==col+1

	by colminusrow (x), sort: generate `x'_nw = `x'[_n-1] if row[_n-1]==row-1 & col[_n-1]==col-1
	by colminusrow (x), sort: generate `x'_se = `x'[_n+1] if row[_n+1]==row+1 & col[_n+1]==col+1
	by colplusrow (x), sort: generate `x'_sw = `x'[_n-1] if row[_n-1]==row+1 & col[_n-1]==col-1
	by colplusrow (x), sort: generate `x'_ne = `x'[_n+1] if row[_n+1]==row-1 & col[_n+1]==col+1

	* move the westernmost two columns to the east side and calculate the edges:
	replace col = 1441 if col==1
	replace col = 1442 if col==2

	by col (row), sort: replace `x'_s = `x'[_n-1] if row[_n-1]==row+1 & (col==1440 | col==1441)
	by col (row), sort: replace `x'_n = `x'[_n+1] if row[_n+1]==row-1 & (col==1440 | col==1441)
	by row (col), sort: replace `x'_w = `x'[_n-1] if col[_n-1]==col-1 & (col==1440 | col==1441)
	by row (col), sort: replace `x'_e = `x'[_n+1] if col[_n+1]==col+1 & (col==1440 | col==1441)

	by colminusrow (x), sort: replace `x'_nw = `x'[_n-1] if row[_n-1]==row-1 & col[_n-1]==col-1 & (col==1440 | col==1441)
	by colminusrow (x), sort: replace `x'_se = `x'[_n+1] if row[_n+1]==row+1 & col[_n+1]==col+1 & (col==1440 | col==1441)
	by colplusrow (x), sort: replace `x'_sw = `x'[_n-1] if row[_n-1]==row+1 & col[_n-1]==col-1 & (col==1440 | col==1441)
	by colplusrow (x), sort: replace `x'_ne = `x'[_n+1] if row[_n+1]==row-1 & col[_n+1]==col+1 & (col==1440 | col==1441)
}
drop col row colminusrow colplusrow

*compute the average value of all neighbors
foreach x of var $list {
	egen `x'_nbavgR = rowmean(`x'_n `x'_s `x'_e `x'_w) // neighbor average (Rook)
	egen `x'_nbavgQ = rowmean(`x'_n `x'_s `x'_e `x'_w `x'_ne `x'_nw `x'_se `x'_sw) // neighbor average (Queen)
	drop `x'_n `x'_s `x'_e `x'_w `x'_ne `x'_nw `x'_se `x'_sw
}

* Pairwise correlations

matrix spatial = J(25, 2, .)

gen rooksample = 1
foreach x of var $list{
	replace rooksample = 1 if `x'==. | `x'_nbavgR==.
}

set more off
*Rook
local i = 1
foreach x of var $list {
	corr `x' `x'_nbavgR if rooksample==1
	matrix spatial[`i', 1] = r(rho)
	local i = `i' + 1
}

*Queen
gen queensample = 1
foreach x of var $list{
	replace queensample = 1 if `x'==. | `x'_nbavgQ==.
}

local i = 1
foreach x of var $list {
	corr `x' `x'_nbavgQ if queensample==1
	matrix spatial[`i', 2] = r(rho)
	local i = `i' + 1
}

matrix colnames spatial = rook queen

matrix rownames spatial = lrad2010clip_pl_c rugged malariaecol biomes1 biomes2_3 biomes4 biomes5 biomes6 biomes7_9 biomes8 biomes10 biomes11 biomes12 biomes14 tmp precip growday landsuit lat elv coastal distc harbor25 river25 lake25

outtable using "output/SpatialAutoCorr", mat(spatial) caption("Spatial autocorrelation") replace nobox f(%9.3f %9.3f)

********************************************************************************
****Appendix Table C1: R-sq for intensive and extensive margins**********
****Appendix Table C2: Coefficients for intensive and extensive margins**
********************************************************************************
use data1_regs, clear
quietly sum lrad2010clip_pl_c

gen lit = 1
replace lit = 0 if lrad2010clip_pl_c == r(min)

eststo clear
*FE*
*Both margins
reg lrad2010clip_pl_c $base $agriculture $trade i.natlarge, vce(cluster clust)
matrix r2_FE = (e(r2))

*Extensive margin, LPM
reg lit $base $agriculture $trade i.natlarge, vce(cluster clust)
matrix r2_FE = (r2_FE \ e(r2))
eststo

*Intensive margin, OLS
reg lrad2010clip_pl_c $base $agriculture $trade i.natlarge if lit == 1, vce(cluster clust)
matrix r2_FE = (r2_FE \ e(r2))
eststo

*Country FE, extensive margin
reg lit i.natlarge, vce(cluster clust)
matrix r2_FE = (r2_FE \ e(r2))
 
*Country FE, intensive margin
reg lrad2010clip_pl_c i.natlarge if lit == 1, vce(cluster clust)
matrix r2_FE = (r2_FE \ e(r2))

*Base, both margins
reg lrad2010clip_pl_c $base i.natlarge, vce(cluster clust)
matrix r2_FE = (r2_FE \ e(r2))

*Base and Agriculture, both margins
reg lrad2010clip_pl_c $base $agriculture i.natlarge, vce(cluster clust)
matrix r2_FE = (r2_FE \ e(r2))

*Base and Trade, both margins
reg lrad2010clip_pl_c $base $trade i.natlarge, vce(cluster clust)
matrix r2_FE = (r2_FE \ e(r2))

*******************no FE********************************************************

*Both margins
reg lrad2010clip_pl_c $base $agriculture $trade , vce(cluster clust)
matrix r2_noFE = (e(r2))

*Extensive margin, LPM
reg lit $base $agriculture $trade , vce(cluster clust)
matrix r2_noFE = (r2_noFE \ e(r2))
eststo

*Intensive margin, OLS
reg lrad2010clip_pl_c $base $agriculture $trade  if lit == 1, vce(cluster clust)
matrix r2_noFE = (r2_noFE \ e(r2))
eststo

*Country FE, extensive margin
reg lit , vce(cluster clust)
matrix r2_noFE = (r2_noFE \ e(r2))
 
*Country FE, intensive margin
reg lrad2010clip_pl_c  if lit == 1, vce(cluster clust)
matrix r2_noFE = (r2_noFE \ e(r2))

*Base, both margins
reg lrad2010clip_pl_c $base , vce(cluster clust)
matrix r2_noFE = (r2_noFE \ e(r2))

*Base and Agriculture, both margins
reg lrad2010clip_pl_c $base $agriculture , vce(cluster clust)
matrix r2_noFE = (r2_noFE \ e(r2))

*Base and Trade, both margins
reg lrad2010clip_pl_c $base $trade , vce(cluster clust)
matrix r2_noFE = (r2_noFE \ e(r2))

**************combine***********************************************************
matrix r2 = (r2_noFE, r2_FE)
matrix rownames r2 = "Both margins" "Extensive margin, LPM" "Intensive margin, OLS" "Country FE, extensive margin" "Country FE, intensive margin" "Base, both margins" "Agriculture, both margins" "Trade, both margins"
matrix colnames r2 = "No FE" "FE"
esttab matrix(r2,fmt(%9.3f)) using "output/AppendixTC1.tex", replace ///
 title("Table C1. Intensive and Extensive Margin R-squared") ///
 substitute("0.000" "" "r2" "" "\caption" "\caption*" "{l*{1}{c}}" "{l*{1}{c}{c}}")

esttab using "output/AppendixTC2.tex", title("Table C2. Intensive and Extensive Margin Coefficients") ///
replace drop(*natlarge* _cons) nogaps nonumbers se star(* 0.10 ** 0.05 *** 0.01) ///
mtitles("Extensive - no FEs" "Intensive - FEs" "Extensive - FEs" "Intensive - FEs") ///
varlabels(rugged "ruggedness (000s)" malariaecol "malaria index" biomes1 "tropical moist forest" biomes2_3 ///
 "tropical dry forest" biomes4 "temperate broadleaf" biomes5 "temperate conifer" ///
 biomes6 "boreal forest" biomes7_9 "tropical grassland" biomes8 "temperate grassland" ///
 biomes10 "montane grassland" biomes11 "tundra" biomes12 "Mediterranean forest" ///
 biomes14 "mangroves" biomes13 "desert" tmp "temperature (deg. C)" ///
 precip "precipitation (mm/month)" growday "growing days" landsuit "land suitability" ///
 lat "abs(latitude)" elv "elevation (km)" coastal "coast" distc "distance to coast (000s km)" ///
 harbor25 "harbor $<$ 25km" river25 "river $<$ 25km" lake25 "lake $<$ 25km") ///
 substitute("&\multicolumn{1}{c}{Extensive - no FEs}&\multicolumn{1}{c}{Intensive - FEs}&\multicolumn{1}{c}{Extensive - FEs}&\multicolumn{1}{c}{Intensive - FEs}\\" ///
 "&\multicolumn{2}{c}{\underline{no country FEs}} & \multicolumn{2}{c}{\underline{w/country FEs} } \\   &  Extensive &   Intensive &  Extensive &   Intensive \\" /// 
 "\caption" "\caption*")

********************************************************************************
*******See Table 5 in main body************************************************
*****Appendix Table C3: Full differential coefficient results************
********************************************************************************

********************************************************************************
*Appendix Figure C1:  distribution of lights in lit grid squares
********************************************************************************
use data1_regs, clear
sum lrad2010clip_pl_c
scalar min_0 = r(min)

sum lrad2010clip_pl_c if lrad2010clip_pl_c > min_0

local N = r(N)
local mean = round(r(mean), .001)
local sd = round(r(sd), .001)
local mini = round(r(min), .001)
local maxi = round(r(max), .001)

*title("Log nonzero lights in 2010" ) 
twoway hist lrad2010clip_pl_c if lrad2010clip_pl_c > min_0, ///
xtitle("ln(light/land ratio)") ytitle("Density") ///
caption(`"Obs: `N'; Mean: `mean'; SD: `sd'; Min: `mini'; Max `maxi'"', size(small))

graph export "output/AppendixFC1.eps", replace

********************************************************************************
*Tobit ***********************************************************************
********************************************************************************
global allx $base $agriculture $trade
use data1_regs, clear
eststo clear
qui sum lrad2010clip_pl_c
local lightmin = r(min)
display(`lightmin')
tobit lrad2010clip_pl_c $allx, ll(`lightmin') vce(cluster clust)
eststo NoFE
xi: tobit lrad2010clip_pl_c $allx i.natlarge, ll(`lightmin') vce(cluster clust)
eststo FE

esttab using "output/tobit.tex", drop(*natlarge*) title("Tobit Regressions") star(* 0.10 ** 0.05 *** 0.01) replace nogaps

********************************************************************************
*******Figure 8: Education Gini by Education in 1950****************************
********************************************************************************

use natvars, clear	
keep WeightedEduGini yr_sch1950 urbanization1950 countrycode gdp_percap_1950_madd pop2010 areasqkm
*graph
reg WeightedEduGini yr_sch1950
local r2: display %5.4f e(r2)
mat b = e(b)
mat ste = e(V)
local slope: display %5.4f b[1,1]
local stderr: display %5.4f sqrt(ste[1,1])
twoway (scatter WeightedEduGini yr_sch1950, mlabel(countrycode) msize(small) mlabs(vsmall)) (lfit WeightedEduGini yr_sch1950), ///
ytitle("Regional education gini") xtitle("Years of schooling in 1950") ///
legend(off) note(Slope = `slope'; Standard error = `stderr'; R-squared = `r2') // title("Population-weighted regional education gini" "by education in 1950")
graph export "output/EduGini_by_Edu1950.eps", replace

reg WeightedEduGini urbanization1950, robust
local r2: display %5.4f e(r2)
mat b = e(b)
mat ste = e(V)
local slope: display %5.4f b[1,1]
local stderr: display %5.4f sqrt(ste[1,1])
twoway (scatter WeightedEduGini urbanization1950, mlabel(countrycode) msize(small) mlabs(vsmall)) (lfit WeightedEduGini urbanization1950), ///
ytitle("Regional education gini") xtitle("Urbanization in 1950") ///
legend(off) note(Slope = `slope'; Standard error = `stderr'; R-squared = `r2') // title("Population-weighted regional education gini" "by urbanization in 1950")
graph export "output/EduGini_by_Urb1950.eps", replace

gen l_gdp_percap_1950_madd = ln(gdp_percap_1950_madd)

reg WeightedEduGini l_gdp_percap_1950_madd, robust
local r2: display %5.4f e(r2)
mat b = e(b)
mat ste = e(V)
local slope: display %5.4f b[1,1]
local stderr: display %5.4f sqrt(ste[1,1])
twoway (scatter WeightedEduGini l_gdp_percap_1950_madd, mlabel(countrycode) msize(small) mlabs(vsmall)) (lfit WeightedEduGini l_gdp_percap_1950_madd), ///
ytitle("Regional education gini") xtitle("ln(GDP per capita) in 1950") ///
legend(off) note(Slope = `slope'; Standard error = `stderr'; R-squared = `r2') // title("Population-weighted regional education gini" "by GDP per capita in 1950")
graph export "output/EduGini_by_Gdp1950.eps", replace

********************************************************************************
*******Table 7: Education Ginis*************************************************
********************************************************************************

gen l_areasqkm = ln(areasqkm)
gen l_pop2010 = ln(pop2010)

label variable yr_sch1950 "Years of schooling in 1950"
label variable urbanization1950 "Urbanization in 1950"
label variable l_gdp_percap_1950_madd "Log GDP per capita in 1950"
label variable l_areasqkm "Log area (sq km)"
label variable l_pop2010 "Log population in 2010"

eststo clear
eststo: reg WeightedEduGini yr_sch1950, robust
eststo: reg WeightedEduGini yr_sch1950 l_areasqkm l_pop2010, robust

eststo: reg WeightedEduGini urbanization1950, robust
eststo: reg WeightedEduGini urbanization1950 l_areasqkm l_pop2010, robust

eststo: reg WeightedEduGini l_gdp_percap_1950_madd, robust
eststo: reg WeightedEduGini l_gdp_percap_1950_madd l_areasqkm l_pop2010, robust

esttab using "output/table7.tex", star(* 0.10 ** 0.05 *** 0.01) ///
se r2 order(yr_sch1950 urbanization1950 l_gdp_percap_1950_madd l_areasqkm l_pop2010) ///
label title(Table 7: Education Ginis) nomtitles substitute("\caption{Table 7: Education Ginis}" "\caption*{Table 7: Education Ginis}") replace compress

********************************************************
* Gennaioli et al. subnational lights vs GDPpc vs pop *
********************************************************

import excel inputdata\data_and_online_appendix.xlsx, sheet("Data Regional Level") firstrow clear
gen CodeRegion = Code + Region
encode CodeRegion, gen(regid)
* keep only the most recent year:
bysort regid (year): keep if _n==_N
* check that all regions within a country have the same year:
table Code, c(sd year)
* drop East and West Germany:
drop if Code=="DDR" | Code=="BRD" 

rename Code CountryCode
rename LnPopulationdensity lnpopdens

* no lights available for VEN because latest income data before 1992:
drop if year<1992
* no lights available for BGD:
drop if CountryCode=="BGD"
* no other missing/zero lights:
sum year Regionallights

gen lnlightdens = ln(Regionallights)
* note that this is actually regional, not national:
gen lngdppc = ln(GDPpcCountry)

keep Country CountryCode Region regid year lnlightdens lnpopdens lngdppc 

foreach i of varlist lnlightdens lnpopdens lngdppc {
	quietly: xi: reg `i' i.CountryCode
	predict `i'_netcountry, residuals
}

reg lnlightdens lnpopdens lngdppc
reg lnlightdens lnpopdens 
reg lnlightdens lngdppc
reg lnlightdens_netcountry lnpopdens_netcountry lngdppc_netcountry
reg lnlightdens_netcountry lnpopdens_netcountry 
reg lnlightdens_netcountry lngdppc_netcountry

*************************************************************
****************Figure 5a, 5b: Durlauf Johnson splits********
*************************************************************
use data1_regs, clear

capture program drop cuts_fe
*create SSR plots and store cutoffs
*Education in 1950
cuts_fe yr_sch1950, varname("Education in 1950") folder("output")
local yr_sch1950_rank_cut = r(rank_cut_fe)

*Urbanization in 1950
cuts_fe urb1950, varname("Urbanization in 1950") folder("output")
local urb1950_rank_cut = r(rank_cut_fe)

*GDP per capita in 1950
cuts_fe gdp1950, varname("GDP per capita in 1950") folder("output")
local gdp1950_rank_cut = r(rank_cut_fe)

*Store locals in matrix
matrix rank_cuts = [ `yr_sch1950_rank_cut' ,  `urb1950_rank_cut' , `gdp1950_rank_cut']

*And pull them back out
local yr_sch1950_rank_cut = rank_cuts[1,1]
local urb1950_rank_cut = rank_cuts[1,2]
local gdp1950_rank_cut = rank_cuts[1,3]

* permanent variables created: foreach var of varlist yr_sch1950 urb1950 gdp1950 { `var'_low_fe }
foreach var of varlist yr_sch1950 urb1950 gdp1950 {
	gen byte `var'_low_fe = (`var' <= ``var'_rank_cut')
	replace `var'_low_fe = . if `var' == .
	gen byte `var'_hi_fe = abs(1-`var'_low_fe)
	foreach dep_var of varlist rugged malariaecol $agriculture $trade{
		gen `dep_var'_`var'_hi = `dep_var'*`var'_hi_fe
	}
}
gen yr_sch1950_rank_cut = `yr_sch1950_rank_cut'
gen urb1950_rank_cut = `urb1950_rank_cut'
gen gdp1950_rank_cut = `gdp1950_rank_cut'
compress
save data1_dj, replace

*************************************************************************************	
******** Table 3:  R^2 and Shapley values for above and below cutoff ****************
*************************************************************************************
use data1_dj, clear
sum yr_sch1950_rank_cut 
local yr_sch1950_rank_cut = r(mean)
sum urb1950_rank_cut 
local urb1950_rank_cut = r(mean)
sum gdp1950_rank_cut
local gdp1950_rank_cut = r(mean)

*get country and observation counts for each of the cutoff categories

foreach i in yr_sch1950 urb1950 gdp1950 {
	preserve
	drop if `i' == .
	qui sum if `i' <= ``i'_rank_cut'
	scalar `i'_n_lo = round(r(N))
	qui sum if `i' > ``i'_rank_cut'
	scalar `i'_n_hi = round(r(N))
	keep natlarge `i'
	duplicates drop
	qui sum if `i' <= ``i'_rank_cut'
	scalar `i'_country_lo = round(r(N))
	qui sum if `i' > ``i'_rank_cut'
	scalar `i'_country_hi = round(r(N))
	restore
}
*set matrix to fill
matrix table3 = J(27,11,.)

*and loop through and fill
local col = 1		
foreach var of varlist yr_sch1950 urb1950 gdp1950 {
	matrix fe_shapley_lo = J(1, 4, .)

	local row = 1
	local hi_col = `col'
	local lo_col = `col' + 2
	local diff_col = `col' + 1
	
	*PANEL A - R-squared comparisions*
	**Both margins
		
	*Skip 4 rows for panel title and group and and country and obs

	matrix table3[`row',`lo_col'] = `var'_country_lo
	matrix table3[`row'+1,`lo_col'] = `var'_n_lo

	matrix table3[`row',`hi_col'] = `var'_country_hi
	matrix table3[`row'+1,`hi_col'] = `var'_n_hi
	local row = `row' + 4

	*Base
	  reg lrad2010clip_pl_c rugged malariaecol nats* if  `var'_low_fe == 0
	  matrix table3[`row',`hi_col'] = e(r2)
	  reg lrad2010clip_pl_c rugged malariaecol nats* if  `var'_low_fe == 1
	  matrix table3[`row',`lo_col'] = e(r2)
	local row = `row' + 1

	*Agriculture plus base
	  reg lrad2010clip_pl_c rugged malariaecol $agriculture nats* if  `var'_low_fe == 0
	  matrix table3[`row',`hi_col'] = e(r2)
	  reg lrad2010clip_pl_c rugged malariaecol $agriculture nats* if  `var'_low_fe == 1
	  matrix table3[`row',`lo_col'] = e(r2)
	local ag_diff = table3[`row',`hi_col'] - table3[`row',`lo_col']
	local row = `row' + 1

	*Trade plus base
	  reg lrad2010clip_pl_c rugged malariaecol $trade nats* if  `var'_low_fe == 0
	  matrix table3[`row',`hi_col'] = e(r2)
	  reg lrad2010clip_pl_c rugged malariaecol $trade nats* if  `var'_low_fe == 1
	  matrix table3[`row',`lo_col'] = e(r2)

	local tr_diff = table3[`row',`hi_col'] - table3[`row',`lo_col']
	local diff = `ag_diff' - `tr_diff'

	local row = `row' + 1
	matrix table3[`row', `diff_col'] = `diff'

	local row = `row' + 1
	matrix list table3

	*PANEL B - Shapley values*
	*skip row for blank and another for 2 for titles
	local row = `row' + 3

	*Record shapley values
	*Some biomes do not appear in one of the samples and rego does not autoexclude
	local ag_low ""
	local ag_high ""
	foreach agvar of varlist $agriculture {
		sum `agvar' if `var'_low_fe == 0
		if r(mean) != 0 & r(mean) != 1 {
			local ag_high `"`ag_high' `agvar'"'
		}
		sum `agvar' if `var'_low_fe == 1
		if r(mean) != 0 & r(mean) != 1 {
			local ag_low `"`ag_low' `agvar'"'
		}	
	}
	display `"`ag_high'"'
	display `"`ag_low'"'
	
	*High
	preserve 
		keep if `var'_low_fe == 0
		foreach v of varlist  nats*    {
			sum `v',  meanonly
			if r(mean)==0 {
				drop `v'
			}
		}
		rego lrad2010clip_pl_c  $base \ `ag_high' \ $trade \ nats* if `var'_low_fe == 0, force 
		matrix fe_shapley_hi =e(shapley)
	restore
		
	*Low
	preserve
		keep if `var'_low_fe == 1
		foreach v of varlist  nats*    {
			sum `v',  meanonly
			if r(mean)==0 {
				drop `v'
			}
		}
		rego lrad2010clip_pl_c  $base \ `ag_low' \ $trade \ nats* if `var'_low_fe == 1, force
		matrix fe_shapley_lo =e(shapley)
	restore

	matrix table3[`row',`hi_col'] = fe_shapley_hi[1,1]
	matrix table3[`row',`lo_col'] = fe_shapley_lo[1,1]
	local row = `row' + 1
	
	matrix table3[`row',`hi_col'] = fe_shapley_hi[1,2]
	matrix table3[`row',`lo_col'] = fe_shapley_lo[1,2]
	local row = `row' + 1
	
	matrix table3[`row',`hi_col'] = fe_shapley_hi[1,3]
	matrix table3[`row',`lo_col'] = fe_shapley_lo[1,3]
	local row = `row' + 1
	
	matrix table3[`row',`hi_col'] = fe_shapley_hi[1,4]					
	matrix table3[`row',`lo_col'] = fe_shapley_lo[1,4]
	local row = `row' + 1

	*PANEL C - Old/New World*
	*skip row for blank and another for 2 for titles
	local row = `row' + 3
	
	**Both margins, new world
	
	*Base
	  reg lrad2010clip_pl_c rugged malariaecol nats* if  `var'_low_fe == 0 & newworld == 1
	  matrix table3[`row',`hi_col'] = e(r2)

	  reg lrad2010clip_pl_c rugged malariaecol nats* if  `var'_low_fe == 1 & newworld == 1
	  matrix table3[`row',`lo_col'] = e(r2)
	local row = `row' + 1

	*Agriculture plus base
	  reg lrad2010clip_pl_c rugged malariaecol $agriculture nats* if  `var'_low_fe == 0 & newworld == 1
	  matrix table3[`row',`hi_col'] = e(r2)

	  reg lrad2010clip_pl_c rugged malariaecol $agriculture nats* if  `var'_low_fe == 1 & newworld == 1
	  matrix table3[`row',`lo_col'] = e(r2)
	local ag_diff = table3[`row',`hi_col'] - table3[`row',`lo_col']

	local row = `row' + 1

	*Trade plus base
	  reg lrad2010clip_pl_c rugged malariaecol $trade nats* if  `var'_low_fe == 0 & newworld == 1
	  matrix table3[`row',`hi_col'] = e(r2)


	  reg lrad2010clip_pl_c rugged malariaecol $trade nats* if  `var'_low_fe == 1 & newworld == 1
	  matrix table3[`row',`lo_col'] = e(r2)
	
	
	local tr_diff = table3[`row',`hi_col'] - table3[`row',`lo_col']
	local diff = `ag_diff' - `tr_diff'

	local row = `row' + 1
	matrix table3[`row', `diff_col'] = `diff'

	local row = `row' + 1
	matrix list table3

	**Both margins, old world

	*Skip row for panel title
	local row = `row' + 1
	
	*Base
	  reg lrad2010clip_pl_c rugged malariaecol nats* if  `var'_low_fe == 0 & oldworld == 1
	  matrix table3[`row',`hi_col'] = e(r2)

	  reg lrad2010clip_pl_c rugged malariaecol nats* if  `var'_low_fe == 1 & oldworld == 1
	  matrix table3[`row',`lo_col'] = e(r2)
	local row = `row' + 1

	*Agriculture plus base
	  reg lrad2010clip_pl_c rugged malariaecol $agriculture nats* if  `var'_low_fe == 0 & oldworld == 1
	  matrix table3[`row',`hi_col'] = e(r2)

	  reg lrad2010clip_pl_c rugged malariaecol $agriculture nats* if  `var'_low_fe == 1 & oldworld == 1
	  matrix table3[`row',`lo_col'] = e(r2)
	local ag_diff = table3[`row',`hi_col'] - table3[`row',`lo_col']

	local row = `row' + 1

	*Trade plus base
	  reg lrad2010clip_pl_c rugged malariaecol $trade nats* if  `var'_low_fe == 0 & oldworld == 1
	  matrix table3[`row',`hi_col'] = e(r2)

	  reg lrad2010clip_pl_c rugged malariaecol $trade nats* if  `var'_low_fe == 1 & oldworld == 1
	  matrix table3[`row',`lo_col'] = e(r2)
	
	local tr_diff = table3[`row',`hi_col'] - table3[`row',`lo_col']
	local diff = `ag_diff' - `tr_diff'

	local row = `row' + 1

	matrix table3[`row', `diff_col'] = `diff'

	local col = `col' + 4

}
matrix list table3

*And pull them back out
sum yr_sch1950_rank_cut 
local yr_sch1950_rank_cut = r(mean)
sum urb1950_rank_cut 
local urb1950_rank_cut = r(mean)
sum gdp1950_rank_cut
local gdp1950_rank_cut = r(mean)
	
matrix list table3

frmttable using output/table3, statmat(table3) ///
rtitles("Countries" \ "Observations" \ "\underline{\textbf{Panel A - $ R^2$}}" ///
\ "\textbf{ Full Sample}" \ "Base + FE" \ "   Agriculture + base + FE"  \ "Trade + base + FE" \ ///
"   High - Low double differential" \ "" \ "\underline{\textbf{Panel B - Shapley Values}}" ///
\"\textbf{ Full Sample}" \ "   Base" \ "   Agriculture" \"   Trade" \ "Country FEs" \ "" \ ///
"\underline{\textbf{Panel C - $ R^2$, Hemispheres}}" \ "\textbf{ New World}" \ "   Base + FE" \ ///
"   Agriculture + base + FE"  \ "   Trade + base + FE" \ "   High - Low double differential" \ ///
"\textbf{ Old World}" \ "Base + FE" \ "   Agriculture + base + FE"  \ "   Trade + base + FE" \ ///
"   High - Low double differential") ctitles("" , "\underline{Education}" , "" , "" , "", ///
"\underline{Urbanization}" , "" , "" , "", "\underline{GDP per capita}" , "" , "" \ ///
"" , "High" , "" , "Low" , "", "High" , "" , "Low" , "", "High" , "" , "Low" ) ///
sdec(3) multicol(1,2,3; 1,6,3; 1,10,3) replace tex frag ///
pretext("\begin{table}[htbp]\centering \def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \caption*{Table 3: R-squared differentials of trade and agriculture variables in regression predicting ln(light/land pixels) for high/low education and urbanization countries} \begin{adjustbox}{max width=\textwidth}}") ///
posttext(" \end{adjustbox} \end{table}") ///
note("The cutoffs for education, urbanization, and GDP per capita are, respectively: `:di %9.2f `yr_sch1950_rank_cut'' years of schooling, `:di %9.2f `urb1950_rank_cut'' percent urbanized, and `:di %9.0fc `gdp1950_rank_cut'' dollars (2005 PPP).")

**************************************************************************************************************************
*****Table 4.  Using the DJ split.   Show main effect and interaction, only with FE. six columns, **************
***** i.e. education, urbanization, and GDP1950 splits. ******************************************************************
**************************************************************************************************************************
use data1_dj, clear
sum yr_sch1950_rank_cut 
local yr_sch1950_rank_cut = r(mean)
sum urb1950_rank_cut 
local urb1950_rank_cut = r(mean)
sum gdp1950_rank_cut
local gdp1950_rank_cut = r(mean)

capture program drop change_coef
program define change_coef, eclass
	local var `1'
	local colnames: colnames b
	local new_colnames ""
	display `"`colnames'"'
	foreach name in `colnames' 	{
		if strpos(`"`name'"', `"_`var'_hi"') == 0 {
				local new_colnames `"`new_colnames' foo"'
		}
		else {
			local new = subinstr(`"`name'"', `"_`var'_hi"', "", .)
				local new_colnames `"`new_colnames' `new'"'
		}
	}
	display `"`new_colnames'"'
		
	
	matrix colnames b = `new_colnames'
	matrix colnames V = `new_colnames'
	matrix rownames V = `new_colnames'

	ereturn post b V
end

*Loop through different ways of splitting
foreach var of varlist yr_sch1950 urb1950 gdp1950 {	
	*loop though dependent variables and create interaction terms
	local new_dep_vars ""
	foreach dep_var of varlist rugged malariaecol $agriculture $trade{
		local new_dep_vars `"`new_dep_vars' `dep_var' `dep_var'_`var'_hi "'
		}
	*then run regression	
	xi: reg lrad2010clip_pl_c `new_dep_vars' i.natlarge, robust cluster(clust)
	*store estimates
	eststo `var'_main
	*rename variable and coefficient matrix, so that interactions are named after variable, and main effects are named foo
	matrix b = e(b)
	matrix V = e(V)

	change_coef `var'

	eststo `var'_int
}

esttab yr_sch1950* urb1950* gdp1950* using "output/table4", se  drop(foo *_hi *_Inat* _cons o.biomes11) tex ///
mtitles("Educ - Main effect" "Educ - Interaction" "Urb - Main effect" "Urb - Interaction" ///
"GDP - Main effect" "GDP - Interaction") nonumbers replace star(* 0.10 ** 0.05 *** 0.01) ///
varlabels(rugged "ruggedness (000s)" malariaecol "malaria index" biomes1 "tropical moist forest" biomes2_3 ///
 "tropical dry forest" biomes4 "temperate broadleaf" biomes5 "temperate conifer" ///
 biomes6 "boreal forest" biomes7_9 "tropical grassland" biomes8 "temperate grassland" ///
 biomes10 "montane grassland" biomes11 "tundra" biomes12 "Mediterranean forest" ///
 biomes14 "mangroves" biomes13 "desert" tmp "temperature (deg. C)" ///
 precip "precipitation (mm/month)" growday "growing days" landsuit "land suitability" ///
 lat "abs(latitude)" elv "elevation (km)" coastal "coast" distc "distance to coast (000s km)" ///
 harbor25 "harbor $<$ 25km" river25 "river $<$ 25km" lake25 "lake $<$ 25km") ///
 refcat(lrad2010clip_pl_c "\textbf{Dependent variable}" rugged "\textbf{Base covariates}" ///
 biomes1 "\textbf{Agriculture covariates}" coastal "\textbf{Trade covariates}", nolabel) ///
 substitute("\begin{tabular}{l*{6}{c}}"  "\begin{table}[htbp]\centering \caption*{Table 4: Regression results allowing interactions between geographic variables and early agglomerator dummy} \begin{adjustbox}{max width=\textwidth} \begin{tabular}{l*{6}{c}}" ///
 "\end{tabular}" "\end{tabular} \end{adjustbox} \end{table}" ///
 "&\multicolumn{1}{c}{Educ - Main effect}&\multicolumn{1}{c}{Educ - Interaction}&\multicolumn{1}{c}{Urb - Main effect}&\multicolumn{1}{c}{Urb - Interaction}&\multicolumn{1}{c}{GDP - Main effect}&\multicolumn{1}{c}{GDP - Interaction}\\" ///
 "&\multicolumn{2}{c}{\underline{Education}} & \multicolumn{2}{c}{\underline{Urbanization} } & \multicolumn{2}{c}{\underline{GDP per capita}} \\   &  Main effect&   Interaction&  Main effect &  Interaction&  Main effect & Interaction \\" ///
 "&           0         &" "&	 	&" "&         (.)         &" "&	 	&" "&         (.)         \\" "&                   \\" ///
 "&           0         \\" "&                   \\")
	
**************************************************************************************************************************************************
***** Figure 6:  difference in fitted values for Africa and Europe for early develop vs. late develop (education split). ******
**************************************************************************************************************************************************
use data1_dj, clear
*Restore estimates from table 4 - education split
*Ie. the regression with individual interactions with a dummy variable for high/low education
est restore yr_sch1950_main
xi i.natlarge

* change country dummies to 0
foreach x of var _Inatlarge_* {
	replace `x' = 0
}

*Set early ag and all interactions to 0
gen yr_sch1950_hi_fe_foo = yr_sch1950_hi_fe
replace yr_sch1950_hi_fe = 0
foreach dep_var of varlist rugged malariaecol $agriculture $trade {
	gen `dep_var'_yr_sch1950_hi_foo = `dep_var'_yr_sch1950_hi
	replace `dep_var'_yr_sch1950_hi = 0
}
*Then make predictions
predict predict_lo, xb

*Set early ag and all interactions to 1
replace yr_sch1950_hi_fe = 1
foreach dep_var of varlist rugged malariaecol $agriculture $trade{
	replace `dep_var'_yr_sch1950_hi = `dep_var'
}
*Then make predictions
predict predict_hi, xb

*restore correct value of dummy and all interaction
replace yr_sch1950_hi_fe = yr_sch1950_hi_fe_foo
foreach dep_var of varlist rugged malariaecol $agriculture $trade{
	replace `dep_var'_yr_sch1950_hi = `dep_var'_yr_sch1950_hi_foo
}

*And calculate differences in fitted values
gen diff_pred_hi_lo = predict_hi - predict_lo

*Demean
egen mean_diff_pred_hi_lo = mean(diff_pred_hi_lo)
gen dem_diff_pred_hi_lo = diff_pred_hi_lo - mean_diff

*Output to csv that can be used to make map
outsheet x y dem_diff_pred_hi_lo using output/diff_predict_hi_lo.csv, comma nolabel replace 

drop predict_hi predict_lo diff_pred_hi_lo mean_diff_pred_hi_lo dem_diff_pred_hi_lo 
foreach dep_var of varlist rugged malariaecol $agriculture $trade{
	drop `dep_var'_yr_sch1950_hi_foo
}

********************************************************************************
*******Appendix*****************************************************************
********************************************************************************

********************************************************************************
*******Appendix Table A1: DJ Splits*******************************************************
********************************************************************************
use data1_dj, clear
sum yr_sch1950_rank_cut 
local yr_sch1950_rank_cut = r(mean)
sum urb1950_rank_cut 
local urb1950_rank_cut = r(mean)
sum gdp1950_rank_cut
local gdp1950_rank_cut = r(mean)

collapse yr_sch1950 urb1950 gdp1950, by(hsswname)
drop if hsswname == ""

foreach var of varlist yr_sch1950 urb1950 gdp1950 {
	gen `var'_hi_fe = 0
	replace `var'_hi_fe = 1 if `var' > ``var'_rank_cut'
	replace `var'_hi_fe = . if `var' == .		
}

mkmat yr_sch1950 urb1950 gdp1950 yr_sch1950_hi_fe urb1950_hi_fe gdp1950_hi_fe, ///
matrix(datamatrix) rownames(hsswname)

sum yr_sch1950
matrix summatrix = (r(mean), r(sd), r(min), r(max))

sum urb1950
matrix summatrix = (summatrix \ r(mean), r(sd), r(min), r(max))

sum gdp1950
matrix summatrix = (summatrix \ r(mean), r(sd), r(min), r(max))

matrix colnames summatrix = "Mean" "SD" "Min" "Max"
matrix rownames summatrix = "Years_of_Schooling_in_1950" "Urbanization_in_1950" "GDP_per_capita_in_1950"

matrix colnames datamatrix = "Educ" "Urban" "GDPpc" "Higheduc" "Highurban" "HighGDPpc"

outtable using "output/AppendixA1", mat(summatrix) replace caption("Table A1: Summary Statistics") nobox f(%9.2f %9.2f %9.2f %9.2f)
outtable using "output/AppendixA2", mat(datamatrix) replace caption("Table A2: 1950 values by Country") nobox longtable  f(%2.1f %2.1f %6.0fc %1.0f %1.0f %1.0f)

********************************************************************************
*Standard deviations************************************************************
********************************************************************************
use data1_dj, clear

*split sample into low edu and high edu groups, partial out FE for each group
*cutoff: yr_sch1950_hi_fe

matrix StdDev = J(25,4,.)
local i = 1

foreach var of varlist lrad2010clip_pl_c $allx {

	gen `var'_net = 0

	*Country FE
	*High Edu
	quietly reg `var' i.natlarge if yr_sch1950_hi_fe == 1
	quietly predict `var'_net_1 if yr_sch1950_hi_fe == 1, re 

	*Low Edu
	quietly reg `var' i.natlarge if yr_sch1950_hi_fe == 0
	quietly predict `var'_net_0 if yr_sch1950_hi_fe == 0, re

	replace `var'_net = `var'_net_1 if yr_sch1950_hi_fe == 1
	replace `var'_net = `var'_net_0 if yr_sch1950_hi_fe == 0

	*matrix high
	qui sum `var'_net if yr_sch1950_hi_fe == 1
	matrix StdDev[`i', 1] = r(sd)
	*matrix low
	qui sum `var'_net if yr_sch1950_hi_fe == 0
	matrix StdDev[`i', 2] = r(sd)

	*All
	quietly reg `var' i.natlarge
	quietly predict `var'_net_all, re

	*matrix all
	qui sum `var'_net_all
	matrix StdDev[`i', 4] = r(sd)

	*matrix diff
	matrix StdDev[`i', 3] = (StdDev[`i', 1] - StdDev[`i', 2])/StdDev[`i', 4]


	local i = `i' + 1
}

matrix rownames StdDev = "lrad2010clip_pl_c" "rugged" "malariaecol" ///
"biomes1" "biomes2_3" "biomes4" "biomes5" "biomes6" "biomes7_9" "biomes8" "biomes10" "biomes11" "biomes12" "biomes14" "tmp" "precip" "growday" "landsuit" "lat" "elv" ///
"coastal" "harbor25" "river25" "lake25" "distc"
matrix colnames StdDev = "HighFE" "LowFE" "NormalizedDiff" "All"
matlist StdDev

outtable using "output/sd", mat(StdDev) caption("Standard Deviations by Education") replace f(%9.2f %9.2f %9.2f %9.2f)

*********************************************************************************************************************************
***********************Table 5: differential marginal effects  ***************************
*********************************************************************************************************************************
use data1_dj, clear
*3 columns (Ed, urb, GDP, all with FEs).
*Two panels: discrete and continuous. 
*Show only alpha and gamma and above cut dummy coefficients. 

*Define nonlinear least squares diff me program
capture program drop nldiffme
program nldiffme
	syntax varlist if, at(name) base(varlist) ag(varlist) trade(varlist) diffvar(varlist) [fe(varlist)]
	*Set dep and ind vars
	local depvar `varlist'
	display `"`depvar'"'

	*Start retrieving coefficients and building estimating equation
	local i = 1

	*First alpha and gamma
	tempname alpha
	scalar `alpha' = `at'[1,`i']
	local i = `i' + 1
	display `alpha'
	
	tempname gamma
	scalar `gamma' = `at'[1, `i']
	local i = `i' + 1
	display `gamma'

	*Then one on diffvar
	tempname b_`diffvar'
	scalar `b_`diffvar'' = `at'[1, `i']
	local i = `i' + 1
	display `b_`diffvar''

	*Then one coefficient per depvar
	tempvar base_part
	generate double `base_part' = 0 `if'
	foreach var of varlist `base' {
			tempname b_`var'
			scalar `b_`var'' = `at'[1, `i']
			local i = `i' + 1
			replace `base_part' = `base_part' + `b_`var''*`var' `if'
	}
				display "base_part"

	tempvar ag_part
	generate double `ag_part' = 0
	foreach var of varlist `ag' {
			tempname b_`var'
			scalar `b_`var'' = `at'[1, `i']
			local i = `i' + 1
			replace `ag_part' = `ag_part' + (1+`alpha'*`diffvar')*( `b_`var''*`var') `if'
	}
	sum `ag_part'
	display "ag_part"

	tempvar trade_part
	generate double `trade_part' = 0 `if'
	foreach var of varlist `trade' {
			tempname b_`var'
			scalar `b_`var'' = `at'[1, `i']
			local i = `i' + 1
			replace `trade_part' = `trade_part' + (1+`gamma'*`diffvar')*( `b_`var''*`var') `if'
	}
	sum `trade_part'
	display "trade_part"

	*And finally FE coeffs

	tempvar fe_part 
	generate double `fe_part' = 0 `if'
	if missing("`fe'") {
		display "No FE"
		tempname b_constant
		scalar `b_constant' = `at'[1, `i']
		local i = `i' + 1
		replace `fe_part' = `b_constant'
	}
	else {
		foreach var of varlist `fe'{
				tempname b_`var'
				scalar `b_`var'' = `at'[1, `i']
				local i = `i' + 1
				replace `fe_part' = `b_`var''*`var' `if'

		}
	}
		display "fe"
	display `"	`depvar' = `base_part' + `ag_part' + `trade_part' + `fe_part' `if'"'
	sum `trade_part'
	replace `depvar' = `b_`diffvar''*`diffvar' + `base_part' + `ag_part' + `trade_part' + `fe_part' `if'
end
			
*Loop through different ways of splitting
capture drop early_ag
gen early_ag = .
foreach cut_var of varlist yr_sch1950 urb1950 gdp1950 {	
	replace early_ag = `cut_var'_hi_fe
	
	preserve
	replace gdp1950 = ln(gdp1950)
	sum `cut_var'
	drop if `cut_var' == .

	*create fixed effects
	xi i.natlarge, prefix(cnt_) noomit
	
	*pooled ols - to get initial guess of all coefficients
	*dummy
	local params_dummy = "alpha gamma"
	local param_init_dummy = ""
	reg lrad2010clip_pl_c early_ag rugged malariaecol $agriculture $trade cnt_*, noconstant robust cluster(clust)
	foreach var of varlist early_ag rugged malariaecol $agriculture $trade  cnt_* {
		local b_`var'_dummy = _b[`var']
		local varvalue = string(_b[`var'])
		local params_dummy `"`params_dummy'"' `" `var'"'
		local param_init_dummy `"`param_init_dummy'"' `" `var' "'  `"`varvalue' "' 
	}
	display `"`params_dummy'"'
	display `"`param_init_dummy'"'

	*NLS, w/ dummy variable for early ag
		
	nl diffme @ lrad2010clip_pl_c , base($base) ag($agriculture) trade($trade) diffvar(early_ag) fe(cnt_*) ///
		parameters(`"`params_dummy'"') initial(`"`param_init_dummy'"') noconstant vce(cluster clust)
	
	matrix params_`cut_var'_dummycol = e(b)
	eststo `cut_var'_diff_coef_dummy
	
	restore
	
}

capture drop early_ag
esttab *_diff_coef_* using "output/table5", se  keep("alpha: _cons" "gamma: _cons") ///
	tex replace nomtitles star(* 0.10 ** 0.05 *** 0.01) ///	
	substitute("\begin{tabular}{l*{3}{c}}"  "\caption*{Table 5: Differential Coefficient Results} \begin{adjustbox}{max width=\textwidth} \begin{tabular}{l*{3}{c}}" ///
	 "\end{tabular}" "\end{tabular} \end{adjustbox}" ///
	 "&\multicolumn{1}{c}{(1)}" "&\multicolumn{1}{c}{\underline{Education}} & " ///
	 "&\multicolumn{1}{c}{(2)}"  "\multicolumn{1}{c}{\underline{Urbanization} } & " ///
	 "&\multicolumn{1}{c}{(3)}"  "\multicolumn{1}{c}{\underline{GDP per capita}} \\")

esttab *_diff_coef_* using "output/AppendixTC3b.tex", se ///
	tex replace nomtitles star(* 0.10 ** 0.05 *** 0.01) ///
	substitute("\begin{tabular}{l*{3}{c}}"  "\caption*{Table C3. Full Nonlinear Differential Coefficient Results} \begin{adjustbox}{max width=\textwidth} \begin{tabular}{l*{3}{c}}" ///
	 "\end{tabular}" "\end{tabular} \end{adjustbox}" ///
	 "&\multicolumn{1}{c}{(1)}" "&\multicolumn{1}{c}{\underline{Education}} & " ///
	 "&\multicolumn{1}{c}{(2)}"  "\multicolumn{1}{c}{\underline{Urbanization} } & " ///
	 "&\multicolumn{1}{c}{(3)}"  "\multicolumn{1}{c}{\underline{GDP per capita}} \\")

matrix params_store_horiz = (params_yr_sch1950_dummycol[1,1..27]\  params_urb1950_dummycol[1,1..27]\ params_gdp1950_dummycol[1,1..27])
matrix params_store = params_store_horiz'
qrowname params_store
matrix rownames params_store = `r(eq)'
matrix colnames params_store = EducDummy UrbDummy GDPDummy

esttab matrix(params_store,fmt(%9.3g)) using "output/AppendixTC33col.tex", replace star(* 0.10 ** 0.05 *** 0.01) ///
	varlabels(rugged "ruggedness (000s)" malariaecol "malaria index" biomes1 "tropical moist forest" biomes2_3 ///
	"tropical dry forest" biomes4 "temperate broadleaf" biomes5 "temperate conifer" ///
	biomes6 "boreal forest" biomes7_9 "tropical grassland" biomes8 "temperate grassland" ///
	biomes10 "montane grassland" biomes11 "tundra" biomes12 "Mediterranean forest" ///
	biomes14 "mangroves" biomes13 "desert" tmp "temperature (deg. C)" ///
	precip "precipitation (mm/month)" growday "growing days" landsuit "land suitability" ///
	lat "abs(latitude)" elv "elevation (km)" coastal "coast" distc "distance to coast (000s km)" ///
	harbor25 "harbor $<$ 25km" river25 "river $<$ 25km" lake25 "lake $<$ 25km") ///
	substitute("\begin{tabular}{l*{3}{c}}"  ///
	 "\caption*{Table C3. Full Nonlinear Differential Coefficient Results} \begin{adjustbox}{max width=\textwidth} \begin{tabular}{l*{3}{c}}" ///
	 "\end{tabular}" "\end{tabular} \end{adjustbox}" ///
	 "&\multicolumn{1}{c}{(1)}" "&\multicolumn{1}{c}{\underline{Education}} & " ///
	 "&\multicolumn{1}{c}{(2)}"  "\multicolumn{1}{c}{\underline{Urbanization} } & " ///
	 "&\multicolumn{1}{c}{(3)}"  "\multicolumn{1}{c}{\underline{GDP per capita}} \\")
	  
*/
log close /*
********************************************************************************
*Conley SE**********************************************************************
********************************************************************************
use data1_regs, clear
preserve
replace x = 179.99 if x == -180
gen const = 1
gen year = 1
gen idcell = _n

eststo clear
ols_spatial_HAC lrad2010clip_pl_c $allx const, lat(y) lon(x) t(year) p(idcell) dist(30) lag(0) disp
eststo
ols_spatial_HAC lrad2010clip_pl_c $allx nats*, lat(y) lon(x) t(year) p(idcell) dist(30) lag(0) disp
eststo

esttab using "output/conley.tex", replace star(* 0.10 ** 0.05 *** 0.01) compress title("Conley SE")
restore

log close

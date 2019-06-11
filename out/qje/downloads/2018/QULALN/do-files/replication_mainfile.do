
/*==============================================================================
================================================================================

REPLICATION PACKAGE: RELIGIOUS COMPETITION AND REALLOCATION:
THE POLITICAL ECONOMY OF SECULARIZATION IN THE PROTESTANT REFORMATION
================================================================================

- AUTHORS: DAVIDE CANTONI, JEREMIAH DITTMAR & NOAM YUCHTMAN 
(hat tip to Lukas Kondmann for preparing and verifying this replication package)

- LAST UPDATE: 2018/03/07 

- INPUTS: 

- STRUCTURE: This program replicates the figures of our paper grouped by datasets used:
	PART 1: Figures which use town_level_data.dta => Figures 1, 3, 8, 9, 10, 11, 12 & 13 
	PART 2: Figures which use student_data_RAG.dta => Figures 4, 5, 6, 7, A1 & Table 3 
	PART 3: Figures which use markettown_data_1480-1600.dta => Figures 9 & 10

	
- PREPARATION: This do file relies on several user written commands. If you have not done so 
already, please install the necessary commands: mmerge, grc1leg and eststo

================================================================================
==============================================================================*/

clear all
set more off
global path "/Users/davidecantoni/Dropbox/Kondmann Cantoni RA Arbeit/Replication Package Reformation/Package"
	/* PLEASE UPDATE PATH */ 
set scheme s1color

/*==============================================================================
                                    PART 1
==============================================================================*/

/*==============================================================================
ROADMAP PART 1: Figures & Tables which use: town_level_data.dta
- OUTPUT: Figures 1, 3, 8, 11, 12 & 13
- STRUCTURE: The figures in this section result from various aggregation levels
			 of town data. Hence, the subsections are organized by the aggregation
			 levels used: 
	PART 1.1: Figure 1 & 8: Collapse by(year) 
	PART 1.2: Figure 3,11 & 12: Collapse by(year ever_protestant) 
	PART 1.3: Figure 13: Collapse by(year holder1500*)
	PART 1.4: Figure 9 & 10: 
==============================================================================*/


/*===================               PART 1.1             =======================
==============================================================================*/


/* 	FIGURE 1 & 8

	- figure 1 graphs the cumulative construction in Germany from 1475-1600 
		from two perspectives: 
			A: Secular sector vs. religious sector construction 
			B: Construction in the secular sector by subsectors 
	- figure 8 analyzes (smoothed) religious and secular construction data
		in (eventually) Protestant vs (remaining) Catholic territories	 */

/* 	FIGURE 1  */
		
* import data
use "$path/data/town_level_data.dta", clear

* sum building data for each year 
collapse (sum) build_count_*, by(year)

* cumulative construction by subsector 
local buildtype "Church Administrative Economic Private Military Welfare Other"
forvalues x = 1(1)7 {
	local y: word `x' of `buildtype'
	gen cum_build1475_`x' = sum(build_count_`x') if year >= 1475
	lab var cum_build1475_`x' "Cumulative Construction `y'"
}

* aggregate cumulative construction for secular sector 
egen cum_build1475_nonchurch = rowtotal(cum_build1475_2-cum_build1475_7)

* graph == baseline "church" versus "secular"
#delimit ;
line cum_build1475_1 cum_build1475_nonchurch cum_build1475_nonchurch year if year >= 1475,
lcolor(dknavy white red*1.25) lpattern(dash solid solid) lwidth(thick thick thick)
subtitle("A. Secular and Church Construction") xtitle("") ytitle("Cumulative Construction Starts")
xline(1517, lcolor(black) lwidth(thin))
ylabel(, angle(0)) xlabel(1475(25)1600)
legend(label(1 "Church") label(2 "") label(3 "Secular") 
rows(3) order(3 1 2) region(lwidth( none)));
#delimit cr
graph rename Graph g_allchurchsec, replace

* graph == components of "secular"
#delimit ;
line 
cum_build1475_2 cum_build1475_3 
cum_build1475_4 cum_build1475_5 cum_build1475_6 cum_build1475_7 
year if year >= 1475,
lcolor(red*1.5 dknavy  red*1.25 gray dkynavy*0.7 gray*0.6) lpattern(solid dash dotdash dash dash dash) 
lwidth(thick thick thick thick thick thick)
subtitle("B. Secular Construction by Type") xtitle("")
xline(1517, lcolor(black) lwidth(thin))
ylabel(0(175)700, angle(0)) xlabel(1475(25)1600)
legend(
	label(1 "Administrative") label(2 "Economic")
	label(3 "Palaces") label(4 "Military") 
	label(5 "Welfare") label(6 "Other") 
	rows(3)  order(1 3 2 4 5 6) region(lwidth( none)) 
	);
#delimit cr
graph rename Graph g_sectypes, replace

graph combine g_allchurchsec g_sectypes, ysize(3.5)
graph export "$path/figures/figure1.pdf", as(pdf) replace


/* 	FIGURE 8  */

*** Set-up data 
	
* import data
use "$path/data/town_level_data.dta", clear


*** Protestant Territories 

preserve

* Keep only Protestant territories
keep if ever_protestant == 1
egen group = group(markettownid)

* collapse to aggregate annual level data
collapse (max) group (sum) build_count*, by(year)

* composite construction 
egen build_nonchurch = rowtotal(build_count_2-build_count_7)

* construction per town 
gen build_count_1_pertown = build_count_1 / group
gen build_nonchurch_pertown = build_nonchurch  / group

* shares of construction by subsector 
local buildtype "Church Administrative Economic Private Military Welfare Other"
forvalues x = 1(1)7 {
	local y: word `x' of `buildtype'
	gen shr_build_`x' = build_count_`x' / build_count_all
	lab var shr_build_`x' "`y'"
}

* set time series
tsset year

* smoothing with 11-year moving average 
tssmooth ma build_count_1_pertown_ma11 = build_count_1_pertown, window(5 1 5)
lab var build_count_1_pertown_ma11 "Church Building"
tssmooth ma build_nonchurch_pertown_ma11 = build_nonchurch_pertown, window(5 1 5) 
lab var build_nonchurch_pertown_ma11 "Non-Church Building"

* graph Protestant territories
#delimit ;
twoway 
(line build_count_1_pertown_ma11 year if year >= 1475, lcolor(dknavy) lwidth(thick) lpattern(dash))
(line build_nonchurch_pertown_ma11 year if year >= 1475, lcolor(red*1.25) lwidth(thick)),
title("Protestant Territories") xtitle("") ytitle("Construction Starts per Town")
xlabel(1475(25)1600) ylabel(,angle(0)) 
xline(1518, lcolor(gray) lwidth(thin))
legend(
	label(1 "Church Building") 
	label(2 "Secular Building")
	rows(1))
scheme(s1color);
#delimit cr

graph rename Graph g_protestant11_pertown, replace


*** Catholic Territories (Analogue to Protestant territories)

restore

keep if ever_protestant == 0
egen group = group(markettownid)

* collapse to aggregate annual level data
collapse (max) group (sum) build_count*, by(year)

* composite construction 
egen build_nonchurch = rowtotal(build_count_2-build_count_7)

* construction per town 
gen build_count_1_pertown = build_count_1 / group
gen build_nonchurch_pertown = build_nonchurch  / group


* shares of construction by subsector
local buildtype "Church Administrative Economic Private Military Welfare Other"
forvalues x = 1(1)7 {
	local y: word `x' of `buildtype'
	gen shr_build_`x' = build_count_`x' / build_count_all
	lab var shr_build_`x' "`y'"
}

* set time series
tsset year

* smoothing with 11-year moving average 
tssmooth ma build_count_1_pertown_ma11 = build_count_1_pertown, window(5 1 5)
lab var build_count_1_pertown_ma11 "Church Building"
tssmooth ma build_nonchurch_pertown_ma11 = build_nonchurch_pertown, window(5 1 5) 
lab var build_nonchurch_pertown_ma11 "Non-Church Building"

* graph Catholic territories
#delimit ;
twoway 
(line build_count_1_pertown_ma11 year if year >= 1475, lcolor(dknavy) lwidth(thick) lpattern(dash))
(line build_nonchurch_pertown_ma11 year if year >= 1475, lcolor(red*1.25) lwidth(thick)),
title("Catholic Territories") xtitle("") ytitle("Construction Starts per Town")
xlabel(1475(25)1600) ylabel(,angle(0)) 
xline(1518, lcolor(gray) lwidth(thin))
legend(
	label(1 "Church Building") 
	label(2 "Secular Building")
	rows(1))
scheme(s1color);
#delimit cr

graph rename Graph g_catholic11_pertown, replace

* combine graphs
graph combine g_protestant11_pertown g_catholic11_pertown, ysize(3) ycommon
graph export "$path/figures/figure8.pdf", as(pdf) replace





/*===================               PART 1.2             =======================
==============================================================================*/

/* figure 3, figure 12 & figure 11

	- figure 3 compares average numbers of monasteries within 25 km of towns for 
		Catholic and Protestant territories  
	- figure 12 shows the share of construction starts in a specific town/city 
		by sector (religion vs. secular) for Protestant towns, 
		Protestant cities (subset of towns), Catholic towns & Catholic cities 
	- figure 11 graphs cumulative secular construction activity by purpose
		(Administrative, Economic, Palace, Military,...) in eventually
		Protestant territories
	*/

*** import combined monastery data, town data & denomination (holder) data 

use "$path/data/town_level_data.dta", clear

* preserve data to return to this point for figure 11
preserve 

*** prepare data for Figure 3 & 12 

* aggregate data for same year & same value of ever_protestant (0 or 1) 
#delimit ;
collapse 
(sum) cities towns build_count_secular_town 
build_count_secular_cities build_count_church_town build_count_church_cities 
(mean) monasteries25_openclose, by(year ever_protestant)
;
#delimit cr


/* 	FIGURE 3  */

#delimit ;
twoway 
(line monasteries25 year if year >= 1475 & year <= 1600 & ever_pro==0, sort lcolor(dknavy) lwidth(thick) lp(dash))
(line monasteries25 year if year >= 1475 & year <= 1600 & ever_pro==1, sort lwidth(thick) lcolor(red*1.25)), 
xtitle(Year) 
ytitle(Average Number of Monasteries) 
xlabel(1475(25)1600) ylabel(,angle(0)) 
xline(1517, lcolor(black) lwidth(thin))
legend(label(1 "Catholic Territories") label(2 "Protestant Territories") style(column))
scheme(s1color) ;
#delimit cr
graph export "$path/figures/figure3.pdf", as(pdf) replace


/* 	FIGURE 12  */

*** prepare smoothed construction share data 

* generate shares of construction starts per town/city 
gen build_count_secular_t_per = build_count_secular_town / towns
gen build_count_secular_c_per = build_count_secular_cities / cities 
gen build_count_church_t_per = build_count_church_town  / towns
gen build_count_church_c_per = build_count_church_cities / cities

* define list of variables for smoothing loop below
#delimit ;
local list "build_count_secular_town build_count_secular_cities 
build_count_church_town build_count_church_cities
build_count_secular_t_per build_count_secular_c_per 
build_count_church_t_per build_count_church_c_per" ;
#delimit cr

* set as time series
tsset ever_protestant year

* smoothing of shares (11 year average)
foreach j in `list' {
	tssmooth ma `j'_ma = `j', window(5 1 5)
}

*** Graphs per location type and denomination 

* protestant towns
#delimit ;
twoway 
(line build_count_church_t_per_ma year if year >= 1475 & ever_protestant == 1, lcolor(dknavy) lwidth(thick) lpattern(dash))
(line build_count_secular_t_per_ma year if year >= 1475 & ever_protestant == 1, lcolor(red*1.25) lwidth(thick)),
title("Protestant Towns") xtitle("") ytitle("Construction Starts")
xlabel(1475(25)1600) ylabel(,angle(0)) 
xline(1518, lcolor(gray) lwidth(thin))
legend(
	label(1 "Church Building") 
	label(2 "Secular Building")
	rows(1))
scheme(s1color);
#delimit cr
graph rename Graph g_towns_prot, replace

* catholic towns
#delimit ;
twoway 
(line build_count_church_t_per_ma year if year >= 1475 & ever_protestant == 0, lcolor(dknavy) lwidth(thick) lpattern(dash))
(line build_count_secular_t_per_ma year if year >= 1475 & ever_protestant == 0, lcolor(red*1.25) lwidth(thick)),
title("Catholic Towns") xtitle("") ytitle("Construction Starts")
xlabel(1475(25)1600) ylabel(,angle(0)) 
xline(1518, lcolor(gray) lwidth(thin))
legend(
	label(1 "Church Building") 
	label(2 "Secular Building")
	rows(1))
scheme(s1color);
#delimit cr
graph rename Graph g_towns_cath, replace

* protestant cities
#delimit ;
twoway 
(line build_count_church_c_per_ma year if year >= 1475 & ever_protestant == 1, lcolor(dknavy) lwidth(thick) lpattern(dash))
(line build_count_secular_c_per_ma year if year >= 1475 & ever_protestant == 1, lcolor(red*1.25) lwidth(thick)),
title("Protestant Cities") xtitle("") ytitle("Construction Starts")
xlabel(1475(25)1600) ylabel(,angle(0)) 
xline(1518, lcolor(gray) lwidth(thin))
legend(
	label(1 "Church Building") 
	label(2 "Secular Building")
	rows(1))
scheme(s1color);
#delimit cr
graph rename Graph g_cities_prot, replace

* catholic cities
#delimit ;
twoway 
(line build_count_church_c_per_ma year if year >= 1475 & ever_protestant == 0, lcolor(dknavy) lwidth(thick) lpattern(dash))
(line build_count_secular_c_per_ma year if year >= 1475 & ever_protestant == 0, lcolor(red*1.25) lwidth(thick)),
title("Catholic Cities") xtitle("") ytitle("Construction Starts")
xlabel(1475(25)1600) ylabel(,angle(0)) 
xline(1518, lcolor(gray) lwidth(thin))
legend(
	label(1 "Church Building") 
	label(2 "Secular Building")
	rows(1))
scheme(s1color);
#delimit cr
graph rename Graph g_cities_cath, replace

* combine graphs 
grc1leg g_towns_prot g_cities_prot g_towns_cath g_cities_cath

* export graph
#delimit ;
graph export "$path/figures/figure12.pdf", 
as(pdf) replace;
#delimit cr

graph close _all

/* 	FIGURE 11  */

* return to combined monastery data, town data & denomination data
restore 

* aggregate data by year ever_protestant
collapse (sum) build_count_*, by(year ever_protestant)

* set as time series
tsset ever_protestant year

* generate cumulative construction numbers starting from 1475 by purpose
local buildtype "Church Administrative Economic Private Military Welfare Other"
forvalues x = 1(1)7 {
	local y: word `x' of `buildtype'
	by ever_protestant: gen cum_build1475_`x' = sum(build_count_`x') if year >= 1475
	lab var cum_build1475_`x' "Cumulative Construction `y'"
}

* graph & export figure 11
#delimit ;
line 
cum_build1475_2 cum_build1475_3 
cum_build1475_4 cum_build1475_5 cum_build1475_6 cum_build1475_7 
year if year >= 1475 & ever_protestant == 1,
lcolor(red*1.5 dknavy  red*1.25 gray dkynavy*0.7 gray*0.6) 
lpattern(solid dash dotdash dash dash dash) 
lwidth(thick thick thick thick thick thick)
xtitle("") ytitle("Cumulative Construction Starts")
xline(1517, lcolor(black) lwidth(thin))
ylabel(, angle(0)) xlabel(1475(25)1600)
legend(
	label(1 "Administrative") label(2 "Economic")
	label(3 "Palaces") label(4 "Military") 
	label(5 "Welfare") label(6 "Other") 
	rows(3)  order(1 3 2 4 5 6) 
	);
#delimit cr
graph rename Graph g_prot, replace
graph export "$path/figures/figure11.pdf", replace



/*===================               PART 1.3             =======================
==============================================================================*/

/* 	FIGURE 13
	
	figure 13 plots monastery closures and construction starts in three case studies 
	of eventually Protestant territories: Brandenburg, Duchy of Saxony and Wurttemberg */

* data
use "$path/data/town_level_data.dta", clear

* collapse to aggregate annual level data
#delimit 
collapse 
(sum) build_count* 
(mean) monasteries25_1500 monasteries_closed25 
, by(year holder1500*) ;
#delimit cr

* composite construction 
egen build_nonchurch = rowtotal(build_count_2-build_count_7)

* set time series
tsset holder1500_id year

* smoothing 
tssmooth ma build_count_nonchurch_ma11 = build_nonchurch, window(5 1 5)
lab var build_count_nonchurch_ma11 "Non-Church Building"
tssmooth ma build_count_1_ma11 = build_count_1, window(5 1 5)
lab var build_count_1_ma11 "Church Building"

gen shr_closed25 = monasteries_closed25 / monasteries25_1500

* graph == duchy of saxony
#delimit ;
twoway 
(line build_count_1_ma11 year if year >= 1475 & year <= 1595 & holder1500_id == 17, lcolor(dknavy) lwidth(thick) lpattern(dash))
(line build_count_nonchurch_ma11 year if year >= 1475 & year <= 1595 & holder1500_id == 17, lcolor(red*1.25) lwidth(thick))
(line shr_closed25 year if year >= 1475 & holder1500_id == 17, lcolor(blue) lwidth(medthick) yaxis(2))
,
title("Duchy of Saxony") xtitle("") ytitle("Construction Starts") ytitle("Monastery Closures (Share)", axis(2))
ylabel(0(1)4, angle(0)) ylabel(, angle(0) axis(2)) 
yscale(range(0 4) axis(1))
xlabel(1475(25)1600)
xline(1518, lcolor(gray) lwidth(thin)) 
xline(1539, lcolor(red) ) 
legend(order(1 2 3) 
	label(1 "Church Construction") 
	label(2 "Secular Construction")
	label(3 "Monastery Closures")
	rows(3) symxsize(6))
scheme(s1color);
#delimit cr
graph rename Graph g_ducalsaxony, replace

* graph == wurttemberg
#delimit ;
twoway 
(line build_count_1_ma11 year if year >= 1475 & year <= 1595 & holder1500_id == 19, lcolor(dknavy) lwidth(thick) lpattern(dash))
(line build_count_nonchurch_ma11 year if year >= 1475 & year <= 1595 & holder1500_id == 19, lcolor(red*1.25) lwidth(thick))
(line shr_closed25 year if year >= 1475 & holder1500_id == 19, lcolor(blue) lwidth(medthick) yaxis(2))
,
title("Wurttemberg") xtitle("") ytitle("Construction Starts") ytitle("Monastery Closures (Share)", axis(2))
ylabel(0(1)4, angle(0)) ylabel(, angle(0) axis(2)) 
yscale(range(0 4) axis(1))
xlabel(1475(25)1600)
xline(1518, lcolor(gray) lwidth(thin)) 
xline(1535, lcolor(red) ) 
legend(order(1 2 3) 
	label(1 "Church Construction") 
	label(2 "Secular Construction")
	label(3 "Monastery Closures")
	rows(3) symxsize(6))
scheme(s1color);
#delimit cr
graph rename Graph g_wurttemberg, replace

* graph == brandenburg
#delimit ;
twoway 
(line build_count_1_ma11 year if year >= 1475 & year <= 1595 & holder1500_id == 21, lcolor(dknavy) lwidth(thick) lpattern(dash))
(line build_count_nonchurch_ma11 year if year >= 1475 & year <= 1595 &  holder1500_id == 21, lcolor(red*1.25) lwidth(thick))
(line shr_closed25 year if year >= 1475 & holder1500_id == 21, lcolor(blue) lwidth(medthick) yaxis(2))
,
title("Brandenburg") xtitle("") ytitle("Construction Starts") ytitle("Monastery Closures (Share)", axis(2))
ylabel(0(1)3, angle(0)) ylabel(, angle(0) axis(2)) 
yscale(range(0 3) axis(1))
xlabel(1475(25)1600)
xline(1518, lcolor(gray) lwidth(thin)) xline(1535, lcolor(red) ) 
legend(order(1 2 3) 
	label(1 "Church Construction") 
	label(2 "Secular Construction")
	label(3 "Monastery Closures")
	rows(3) symxsize(6))
scheme(s1color);
#delimit cr
graph rename Graph g_brandburg, replace

* combine graphs
grc1leg g_brandburg g_ducalsaxony g_wurttemberg , rows(3) scheme(s1color) 
graph rename Graph g_combine, replace
graph display g_combine, ysize(9)

* export 
#delimit ;
graph export "$path/figures/figure13.pdf", 
as(pdf) replace ;
#delimit cr




/*===================               PART 1.4             =======================
==============================================================================*/


/* 	FIGURE 9 & 10

	- figure 9 graphs effects of the reformation on construction events in Protestant 
		territories relative to Catholic territories in three subpanels:
			A: Church construction (baseline vs. control for pretreatment outcomes)
			B: Secular construction (baseline vs. control for pretreatment outcomes)
			C: Palace, Administrative (baseline vs. control for pretreatment outcomes)
			
	- figure 10 compares levels of secular and religious construction 
		in eventually-Protestant regions: 
			A: relative to regions that remain Catholic and 
			are on the border with Protestant regions (high religious competition)
			B: relative to regions that remain Catholic and 
			are not on the border with Protestant regions (low religious competition)
*/

*** import town data and set up tempfile 


use "$path/data/town_level_data.dta" , clear

* collapse to city-decade
#delimit ;
collapse (sum) build_count*, 
by(markettown* decade holder1500* ever_pro* monasteries25_1500 markets1470 building1400_1470 deg_d150_last10_1470) ;
#delimit cr

lab var build_count_1   "Count: Clerical Building Projects"
lab var build_count_2   "Count: Administrative Building Projects"
lab var build_count_3   "Count: Economic Building Projects"
lab var build_count_4   "Count: Private Building Projects"
lab var build_count_5   "Count: Military Building Projects"
lab var build_count_6   "Count: Welfare Building Projects"
lab var build_count_7   "Count: Other Building Projects"
lab var build_count_all "Count: Total Number of Building Projects"


forvalues x = 1(1)7 {
	gen build_any_`x' = build_count_`x' != 0 & build_count_`x' != .
}
forvalues x = 1(1)7 {
	gen build_shr_`x' = build_count_`x' / build_count_all
}

*** regression variables 

* decade FE
forvalues x = 1470(10)1590 {
	gen dec`x' = decade == `x'
}

* protestant-decade interactions
forvalues x = 1470(10)1590 {
	gen prot_x_dec`x' = (decade == `x' & ever_protestant==1)
}
gen prot_trend = ever_protestant * decade

* building
forvalues x = 1470(10)1590 {
	gen build1470_x_dec`x' = dec`x' * building1400_1470
}

* markets
forvalues x = 1470(10)1590 {
	gen markets1470_x_dec`x' = dec`x' * markets1470
}

* students as of 1470
forvalues x = 1470(10)1590 {
	gen students150_1470_x_dec`x' = dec`x' * deg_d150_last10_1470
}

gen build_any_secular = build_count_all - build_count_1 > 0
gen build_any = build_count_all > 0

gen towns = 1

tempfile town_construction_decade
save `town_construction_decade'




*** Use town data (incl. border distances) & merge with construction_decade
				  
use "$path/data/town_level_data.dta" , clear

keep markettownid bord* ever_protestant* indicator*
ren ever_protestant ever_protestant_euratlas
duplicates drop markettownid, force

merge 1:m markettownid using `town_construction_decade'

tempfile tempdata
save `tempdata', replace


/* Figures 9 & 10 */


*** prepare construction data 

* run supplementary do-file that defines the program prepare_collapse_data
do "$path/do-files/collapse_and_prepare_data.do"

* define variables and collapse (program in external file)
prepare_collapse_data

* post-reformation indicator
gen post = decade >= 1520

* define time interactions (time periods for confidence intervals)
gen post_x_prot = post * ever_protestant
gen pre1510_x_prot = ever_protestant * decade < 1510
gen postearly_x_prot = ever_protestant * (decade >= 1520 & decade <= 1550 )
gen postlate_x_prot = ever_protestant * (decade >= 1550)

* label interactions 
lab var post_x_prot "Protestant * Post-1520"
lab var postearly_x_prot "Protestant * 1520-1549"
lab var postlate_x_prot "Protestant * 1550-1599"
lab var pre1510_x_prot "Protestant * Pre-1510"


*** regressions figure 9

eststo clear

* Run supplementary do-file that defines reg_n_graph_construction & reg_n_rick_n_graph_construction
do "$path/do-files/programs_regression_construction.do"


* run program, 1,3: church construction

reg_n_graph_construction   		build_count_church, startyear(1480) color("dknavy") ///
		yrange("-4 2") ylabel("-4(2)2") ytick("-4(1)2") top(2) graphname("col1")
reg_n_rick_n_graph_construction build_count_church, dependent_var_short("build_chu") color("dknavy") yrange("-4 2") ///
		ylabel("-4(2)2") ytick("-4(1)2") top(2) ytitle("Point estimate / C.I.") ///
		graphsubtitle("II. Control for Pretreatment Outcomes") graphname("col3")


* run program, 4,6: secular construction

reg_n_graph_construction        build_count_secular, startyear(1480) color("red*1.25") ///
		yrange("-2 4") ylabel("-2(2)6") ytick("-2(1)4") top(6) graphname("col4")
reg_n_rick_n_graph_construction build_count_secular, dependent_var_short("build_sec") color("red*1.25") yrange("-2 4") ///
		ylabel("-2(2)6") ytick("-2(1)4") top(6) ytitle("Point estimate / C.I.") ///
		graphsubtitle("II. Control for Pretreatment Outcomes") graphname("col6")


* run program, 7,9: administrative and palace construction

reg_n_graph_construction  		build_count_public, startyear(1480) color("red*1.25") ///
		yrange("-2 4") ylabel("-2(2)4") ytick("-2(1)4") top(4) graphname("col7")
reg_n_rick_n_graph_construction build_count_public, dependent_var_short("build_pub") color("red*1.25") yrange("-2 4") ///
		ylabel("-2(2)4") ytick("-2(1)4") top(4) ytitle("Point estimate / C.I.") ///
		graphsubtitle("II. Control for Pretreatment Outcomes") graphname("col9")


* combine sub-graphs

graph combine col7 col9, ///
	subtitle("C. Palace, Administrative, and Military Construction") rows(1) scheme(s1color) ycommon
graph rename Graph g_state, replace
	window manage close graph
	
graph combine col1 col3, ///
	subtitle("A. Church Construction") rows(1) scheme(s1color) ycommon
graph rename Graph g_church, replace
	window manage close graph
	
graph combine col4 col6, ///
	subtitle("B. Secular Construction") rows(1) scheme(s1color) ycommon
graph rename Graph g_secular, replace
	window manage close graph
	
* save final graph
graph combine g_church g_secular g_state, rows(3) xsize(3) imargin(zero) scheme(s1color)
graph export "$path/figures/figure9.pdf", as(pdf) replace


*** return to original data, prepare data: close to border	

* only use observations close border
use `tempdata', clear
keep if (ever_protestant == 1 | bord_near_rel_diffE == 1 ) &  bord_near_rel_unkE == 0

* execute program prepare_collapse_data
prepare_collapse_data 

* graphs for close to border (church vs. secular)
reg_n_rick_n_graph_construction build_count_church, dependent_var_short("build_chu") color("dknavy") yrange("-3 3") ///
		ylabel("-3(1)3") ytick("-3(1)3") top(3) ytitle("Point estimate / C.I.") ///
		graphsubtitle("Church Construction") graphname("g_near_church")
reg_n_rick_n_graph_construction build_count_secular, dependent_var_short("build_sec") color("red*1.25") yrange("-3 3") ///
		ylabel("-3(1)3") ytick("-3(1)3") top(3) ytitle("Point estimate / C.I.") ///
		graphsubtitle("Secular Construction") graphname("g_near_secular")

* combine close to border graphs 
graph combine g_near_church g_near_secular, rows(1) ysize(3) scheme(s1color) title("A. Catholic Border Towns: High Competition") 
graph rename Graph g_near_border, replace
window manage close graph


*** return to original data, prepare data: far from border

* only use observations far from border
use `tempdata', clear
keep if (ever_protestant == 1 | bord_near_rel_diffE == 0 ) &  bord_near_rel_unkE == 0

* prepare data (program in external file)
prepare_collapse_data 

* graphs for far from border (church vs. secular)
reg_n_rick_n_graph_construction build_count_church, dependent_var_short("build_chu") color("dknavy") yrange("-3 3") ///
		ylabel("-3(1)3") ytick("-3(1)3") top(3) ytitle("Point estimate / C.I.") ///
		graphsubtitle("Church Construction") graphname("g_far_church")
reg_n_rick_n_graph_construction build_count_secular, dependent_var_short("build_sec") color("red*1.25") yrange("-3 3") ///
		ylabel("-3(1)3") ytick("-3(1)3") top(3) ytitle("Point estimate / C.I.") ///
		graphsubtitle("Secular Construction") graphname("g_far_secular")

* combine far from border graphs
graph combine g_far_church g_far_secular, rows(1) ysize(3) scheme(s1color) title("B. Catholic Towns Not on Border: Low Competition")
graph rename Graph g_far_border, replace
window manage close graph

* combine all graphs and export figure
graph combine  g_near_border g_far_border , rows(2) ysize(6) scheme(s1color)
graph export "$path/figures/figure10.pdf", as(pdf) replace




/*==============================================================================
                                    PART 2
==============================================================================*/

/*==============================================================================
ROADMAP PART 2: Figures & tables which use: student_data_RAG.dta

- OUTPUT: Figures 4, 5, 6, 7 & summary statistics for table 3

- STRUCTURE: The first subsection includes all graphs which are directly built
	upon the RAG data "student_data_RAG.dta". 
	The second subsection reshapes this dataset into a panel version 
	to combine it with our own degree data for 1550-1600 for figure 6 
	PART 2.1: Figures 4, 5, 7 & summary statistics for table 3
	PART 2.2: Figure 6 & A1
==============================================================================*/



/*===================               PART 2.1             =======================
==============================================================================*/

/* figure 4, figure 5, figure 7 & table 3

	- figure 4 plots how many students pursued a religious or secular career
		after graduating from (eventually) Protestant universities
		vs. after graduating from Catholic universities 
	- figure 5 analyzes the effect of the Reformation on careers of students in the
		religious (A) vs. administrative (B) sector 
	- figure 7 analyzes the effect of the Reformation on university degrees obtained
		in theology (A) vs. law and/or arts (B) 
	- table 3 compares the sector of occupation (church vs. administrative job) 	
		for students with respect to their field of study
	*/



*** import and prepare RAG student data 

* import student data
use "$path/data/student_data_RAG.dta", clear

* 	some cleaning
duplicates drop

replace deg_year0 = deg_year1 if deg_year0 == . & deg_year1<.
replace deg_year0 = deg_year2 if deg_year0 == . & deg_year1 == . & deg_year2<.

* save data to return to this point later for table 3 
preserve 

/* 	FIGURE 4 */

*** Prepare data for figure 4 

* year = year in which student got first degree
gen year = deg_year0

* collapse to year-religion cells
collapse (sum) job0_church job0_secular, by(year deg_uni0_prot)

*** generate shares & smooth 

* set as time series
tsset deg_uni0_prot year

* job counts == moving average 
tssmooth ma job0_church_ma = job0_church, window(5 1 5)
tssmooth ma job0_secular_ma = job0_secular, window(5 1 5)
lab var job0_church_ma  "Church"
lab var job0_secular_ma  "Secular"

* job shares
gen share_church = job0_church / (job0_church + job0_secular)
gen share_secular = job0_secular / (job0_church + job0_secular)
lab var share_church "Share Church"
lab var share_secular "Share Secular"

* smoothing: job shares = moving average
tssmooth ma share_church_ma = share_church, window(5 1 5)
tssmooth ma share_secular_ma = share_secular, window(5 1 5)
lab var share_church_ma  "Church"
lab var share_secular_ma  "Secular"

* graph == share Protestant
#delimit ;
twoway
(line share_church_ma year if year >=  1475 & year <= 1545  & deg_uni0_prot == 1, lcolor(dknavy) lwidth(thick) lpattern(dash))
(line share_secular_ma year if year >=  1475 & year <= 1545 & deg_uni0_prot == 1, lcolor(red*1.25) lwidth(thick)),
title("Protestant Universities")
xtitle("") ytitle("Share of First Jobs")
xlabel(1475(25)1550) ylabel(,angle(0)) 
xline(1517, lwidth(thin) lcolor(black))
legend(label(1 "Church") label(2 "Secular") )
scheme(s1color);
#delimit cr
graph rename Graph g_protestant_share, replace
window manage close graph

* graph == share Catholic
#delimit ;
twoway
(line share_church_ma year if year >=  1475 & year <= 1545  & deg_uni0_prot == 0, lcolor(dknavy) lwidth(thick) lpattern(dash))
(line share_secular_ma year if year >=  1475 & year <= 1545 & deg_uni0_prot == 0, lcolor(red*1.25) lwidth(thick)),
title("Catholic Universities")
xtitle("") ytitle("Share of First Jobs")
xlabel(1475(25)1550) ylabel(,angle(0)) 
xline(1517, lwidth(thin) lcolor(black))
legend(label(1 "Church") label(2 "Secular") )
scheme(s1color);
#delimit cr
graph rename Graph g_catholic_share, replace
window manage close graph

* combine and export
graph combine g_protestant_share g_catholic_share, ycommon
graph export "$path/figures/figure4.pdf", as(pdf) replace
window manage close graph



/* 	TABLE 3 */


restore
	
*** 	restrict to german universities

* set up list of german universities
local unilist Basel Erfurt Frankfurt Freiburg Greifswald  Heidelberg Ingolstadt Köln Leipzig Mainz Marburg Rostock Trier Tübingen Wittenberg Würzburg

* define indicator as 1 if university is in list of german universities
gen ind_german_uni = 0
foreach j in `unilist' {
	forvalues k = 0(1)11 {
		replace ind_german_uni = 1 if deg_uni`k' == "`j'"
	}
}
* disregard data from non-german universities
keep if ind_german_uni == 1


*** summarize data for table 3

* generate indicator if student obtained at least one degree in law or arts
egen deg_artlaw = rowmax(deg_art deg_law)
lab var deg_artlaw "Indicator: Graduate with Arts or Law Degree"

* 1 == church jobs by theology degree
prtest ind_churchjob_ever if deg_year0 >= 1480 & deg_year0 <= 1550, by(deg_the) level(95)

* 2 == church jobs by arts-or-law degree
prtest ind_churchjob_ever if deg_year0 >= 1480 & deg_year0 <= 1550, by(deg_artlaw) level(95)

* 3 == admin jobs by arts-or-law degree
prtest ind_adminjob_ever if deg_year0 >= 1480 & deg_year0 <= 1550, by(deg_artlaw) level(95)

* 4 == admin jobs by theology degree
prtest ind_adminjob_ever if deg_year0 >= 1480 & deg_year0 <= 1550, by(deg_the) level(95)


/* 	Figure 5 & Figure 7 */

*** generate variables for regressions


* 	dependant variable for figure 5 
gen job0_sector_public = max(job0_sector4,job0_sector5)
lab var job0_sector_public "Indicator, first job: Public (admin or milit)"

* 	limit scope to 1480-1550

keep if deg_year0>=1480 & deg_year0<1550


*  decades and university*decade cells (for clustering)

gen decade = 10 * floor(deg_year0 / 10)

gen  uni_X_dec = uni_id * 10000 + decade


* 	interactions of decades with explanatory variables 

gen deg_uni_prot = deg_uni0_prot

forvalues x = 1480(10)1540 {
	gen dec`x' = decade == `x'
}

forvalues x = 1480(10)1540 {
	gen prot_uni_x_dec`x' = dec`x' * deg_uni_prot
}

* 	controls for diff-in-diff

gen prot_uni_x_dec1520post = max(prot_uni_x_dec1520, prot_uni_x_dec1530 , prot_uni_x_dec1540)
gen prot_uni_x_dec1500pre = max(prot_uni_x_dec1480 , prot_uni_x_dec1490, prot_uni_x_dec1500)


*** define program for regressions and graphs in figures 5 & 7 (for jobs & degrees)

* run program that defines reg_n_graph for degree & job data in external file 
do "$path/do-files/program_regression_degrees_jobs.do" 
	
* => consult external do file for details

*** execute program and build figure 5 & 7

* Figure 5 
reg_n_graph_degrees_jobs		job0_church, color("dknavy") graphtitle("A. First Job: Church") ///
				graphname("g_job_church_prepost")
reg_n_graph_degrees_jobs 	job0_sector_public, color("red*1.25") graphtitle("B. First Job: Administrative") ///
				graphname("g_job_public_prepost")

graph combine g_job_church_prepost g_job_public_prepost, ycommon ysize(3) scheme(s1color)
graph export "$path/figures/figure5.pdf", replace

* Figure 7: Theology vs.arts and/or law degree
reg_n_graph_degrees_jobs		deg_the, color("dknavy") graphtitle("A. Degree: Theology") ///
				graphname("g_theology_prepost")
reg_n_graph_degrees_jobs		deg_artlaw, color("red*1.25") graphtitle("B. Degree: Law and/or Arts") ///
				graphname("g_lawarts_prepost")
				
graph combine g_theology_prepost g_lawarts_prepost, ycommon ysize(3)  scheme(s1color)
graph export "$path/figures/figure7.pdf", replace



/*===================               PART 2.2             =======================
==============================================================================*/

/* FIGURE 6 & APPENDIX FIGURE A1

	- figure 6 plots the share of obtained degrees by sector comparing Catholic 
		and (eventually) Protestant universities from 1475-1600
	- for this purpose, the RAG data (1475 - 1550) is reshaped and combined with 
		our own degree data (1550 - 1600) to allow for a more in-depth analysis 
	- figure A1 graphs overall trends in the number of secular and theol. degrees 
		based on the combined degree data from RAG and our own collection.  
		*/
		
*** prepare data 

* reshape student_data_RAG to student_data_RAG_panel in external file

do "$path/do-files/reshape_students.do"

clear

* import new data
use "$path/data/student_data_RAG_panel.dta", clear

* clean up
#delimit ;
drop if 
deg_uni == "" 
| deg_uni == "Angers" |  deg_uni == "Avignon" |        
deg_uni == "Bologna" | deg_uni == "Bourges" | deg_uni == "Bratislava" |     
deg_uni == "Cambridge" | deg_uni == "Canterbury" | deg_uni == "Dôle" |          
deg_uni == "Ferrara" | deg_uni == "Florenz" | deg_uni == "Fünfkirchen" |   
deg_uni == "Italien" | deg_uni == "Jena" | deg_uni == "Kopenhagen" |     
deg_uni == "Lucca" | deg_uni == "Montpellier" | deg_uni == "Neapel" | 
deg_uni == "Orléans" |  deg_uni == "Oxford" |  deg_uni == "Padua" |
deg_uni == "Paris" |  deg_uni == "Parma" |  deg_uni == "Pavia" |
deg_uni == "Perugia" |  deg_uni == "Pisa" | deg_uni == "Poitiers" |
deg_uni == "Rom" |  deg_uni == "Siena" | deg_uni == "St. Andrews" |
deg_uni == "Toulouse" | deg_uni == "Turin" | deg_uni == "Uppsala" |
deg_uni == "Valence" ;
#delimit cr
	
* code last degree-granting university
gen deg_uni_prot = 0
replace deg_uni_prot=1 if deg_uni==`"Basel"'
replace deg_uni_prot=1 if deg_uni==`"Tübingen"'
replace deg_uni_prot=1 if deg_uni==`"Wittenberg"'
replace deg_uni_prot=1 if deg_uni==`"Greifswald"'
replace deg_uni_prot=1 if deg_uni==`"Leipzig"'
replace deg_uni_prot=1 if deg_uni==`"Frankfurt"'
replace deg_uni_prot=1 if deg_uni==`"Heidelberg"'
replace deg_uni_prot=1 if deg_uni==`"Rostock"'	
replace deg_uni_prot=1 if deg_uni==`"Marburg"'
	
* identify german universities
local unilist Basel Erfurt Frankfurt Freiburg Greifswald  Heidelberg Ingolstadt Köln Leipzig Mainz Marburg Rostock Trier Tübingen Wittenberg Würzburg

* create a variable which is == 1 if the university of the student was German 
gen german_uni = 0
foreach j in `unilist' {
		replace german_uni = 1 if deg_uni == "`j'"
}

* drop all observations without a German uni 
egen ind_german_uni = max(german_uni), by(student_id)
keep if ind_german_uni == 1
drop german_uni


* dummy if university was cologne (this is only relevant for figure A1)
gen ind_uni_cologne = 0
replace ind_uni_cologne = 1 if deg_uni==`"Köln"' | deg_uni==`"Koeln"'


*** aggregate data

* collapse by year, deg_uni_prot & ind_uni_cologne
#delimit ;
collapse (sum)
deg_art_bac deg_art_lic deg_art_mag deg_art_doc 
deg_law_bac deg_law_lic deg_law_mag deg_law_doc 
deg_med_bac deg_med_lic deg_med_mag deg_med_doc 
deg_the_bac deg_the_lic deg_the_mag deg_the_doc,
by(year deg_uni_prot ind_uni_cologne) ;
#delimit cr

* deg_art == number of total art degrees by year 
egen deg_art = rowtotal(deg_art_bac deg_art_lic deg_art_mag deg_art_doc)
lab var deg_art "Arts"

* deg_law == number of total law degrees by year 
egen deg_law = rowtotal(deg_law_bac deg_law_lic deg_law_mag deg_law_doc) 
lab var deg_law "Law"

* deg_med == number of total medicine degrees by year 
egen deg_med = rowtotal(deg_med_bac deg_med_lic deg_med_mag deg_med_doc)
lab var deg_med "Medicine"

* the == number of total theology degrees by year 
egen deg_the = rowtotal(deg_the_bac deg_the_lic deg_the_mag deg_the_doc)
lab var deg_the "Theology"

* secular == number of total secular degrees (art, law, med) by year 
gen deg_sec = deg_art + deg_law + deg_med

* generate total number of degrees per year to set up shares
egen total = rowtotal(deg_art deg_law deg_med deg_the)

*** merge old data (1480-1550) with new data (1550-1600)

* label source 
gen source = "RAG"

* restrict RAG data to < 1550
keep if year<=1550

* restrict only on variables needed 
keep year deg_uni_prot deg_art deg_law deg_med deg_the deg_sec ind_uni_cologne total 

* merge with prepared degree data 1550-1600
append using "$path/data/degrees_data_1550-1600.dta"

* save as tempfile 
tempfile degrees_postcollapse
save `degrees_postcollapse', replace

*** Generate shares and moving averages across 1550 break

* transform year-prot-cologne cells into year-prot cells 
#delimit ;
collapse (sum)
deg_art deg_law deg_med deg_the total,
by(year deg_uni_prot) ;
#delimit cr


* share of total degrees
gen shr_art = deg_art / total
gen shr_law = deg_law / total
gen shr_med = deg_med / total
gen shr_the = deg_the / total
gen shr_sec = shr_art + shr_law + shr_med
lab var shr_art "Art"
lab var shr_law "Law"
lab var shr_med "Medicine"
lab var shr_the "Theology"
lab var shr_sec "Secular (Art, Law, Med)"

* time series smooth
tsset deg_uni_prot year

tssmooth ma shr_the_ma = shr_the, window(5 1 5)
tssmooth ma shr_sec_ma = shr_sec, window(5 1 5)

* labels
lab var shr_the_ma "Theology"
lab var shr_sec_ma "Secular"

/* FIGURE 6 */

*** graph overall: (law & arts) vs. theology degrees, shares 

* Protestant universities 
#delimit ;
twoway
(line shr_sec_ma  year if year >= 1475 & year <= 1595 & deg_uni_prot == 1, 
	 lcolor(red*1.25) lwidth(thick) yaxis(1))
(line shr_the_ma year if year >= 1475 & year <= 1595 & deg_uni_prot == 1, 
	lcolor(dknavy) lpattern(dash) lwidth(thick) yaxis(2))
, xtitle("") 
title("Protestant Universities")
ytitle("Secular")
xline(1517, lcolor(red*1.5) lwidth(thin))
yline(0(0.025)0.20, lcolor(gray*0.1) lwidth(thin) axis(2))
ylabel(0(0.025)0.20, axis(2) angle(0))
ylabel(0.8(0.05)1, axis(1) angle(0))
xscale(range(1540 1600))
xlabel(1475(25)1600)
yscale(range(0.8 1) axis(1))
yscale(range(0 0.15) axis(2))
legend(order(1 2) rows(1) symxsize(5)) scheme(s1color) ;
#delimit cr
graph rename Graph g_protestant, replace

* Catholic universities 
#delimit ;
twoway
(line shr_sec_ma  year if year >= 1475 & year <= 1595 & deg_uni_prot == 0, 
	lcolor(red*1.25) lwidth(thick) yaxis(1))
(line shr_the_ma year if year >= 1475 & year <= 1595 & deg_uni_prot == 0, 
	lcolor(dknavy) lpattern(dash) lwidth(thick) yaxis(2))
, xtitle("") 
title("Catholic Universities")
ytitle("Secular")
xline(1517, lcolor(red*1.5) lwidth(thin))
yline(0(0.025)0.20, lcolor(gray*0.1) lwidth(thin) axis(2))
ylabel(0(0.025)0.20, axis(2) angle(0))
ylabel(0.8(0.05)1, axis(1) angle(0))
xscale(range(1475 1600))
xlabel(1475(25)1600)
yscale(range(0.8 1) axis(1))
yscale(range(0 0.15) axis(2))
legend(order(1 2) rows(1) symxsize(5)) scheme(s1color) ;
#delimit cr
graph rename Graph g_catholic, replace

* combine and export 
graph combine g_protestant g_catholic, ysize(3) scheme(s1mono)

graph export "$path/figures/figure6.pdf", as(pdf) replace



/* FIGURE A1 */

clear 
use `degrees_postcollapse'

*** PANEL A: All Universities 

* draw graphs for both types of universities (Pro/Cat) together
collapse (sum) deg_the deg_sec, by(year)


* generate moving averages of absolute degree numbers
tsset year
tssmooth ma deg_the_ma_cross = deg_the, window(5 1 5)
tssmooth ma deg_sec_ma_cross = deg_sec, window(5 1 5)
lab var deg_sec_ma_cross "Secular"
lab var deg_the_ma_cross "Theology"

* graph
#delimit ;
twoway
(line deg_the year if year >= 1475 & year <= 1600, lcolor(dknavy) lwidth(thin))
(line deg_the_ma_cross year if year >= 1475 & year <= 1595, lcolor(red*1.25) lwidth(thick))
,
title("Theology Degrees") 
xtitle("") ytitle("Degrees")
xlabel(1475(25)1600) ylabel(,angle(0)) 
xline(1517, lwidth(thin) lcolor(black))
legend(label(1 "Degrees") label(2 "Moving Average") symxsize(5))
scheme(s1color);
#delimit cr
graph rename Graph g_the_cross, replace

#delimit ;
twoway
(line deg_sec year if year >= 1475 & year <= 1600, lcolor(dknavy) lwidth(thin))
(line deg_sec_ma_cross year if year >= 1475 & year <= 1595, lcolor(red*1.25) lwidth(thick))
,
title("Secular Degrees") 
xtitle("") ytitle("Degrees")
xlabel(1475(25)1600) ylabel(,angle(0)) 
xline(1517, lwidth(thin) lcolor(black))
legend(label(1 "Degrees") label(2 "Moving Average") symxsize(5))
scheme(s1color);
#delimit cr
graph rename Graph g_sec_cross, replace

* export
graph combine g_sec_cross g_the_cross, title("Panel A: All Universities")
grc1leg g_sec_cross g_the_cross, title("Panel A: All Universities")
graph rename g_test, replace

*** PANEL B: All universities excluding cologne (no data available after 1550)
clear 
use `degrees_postcollapse'

* exclude cologne 
drop if ind_uni_cologne == 1

* draw graphs for both types of universities (Pro/Cat) together
collapse (sum) deg_the deg_sec, by(year)

* generate moving averages of absolute degree numbers
tsset year
tssmooth ma deg_the_ma_cross = deg_the, window(5 1 5)
tssmooth ma deg_sec_ma_cross = deg_sec, window(5 1 5)
lab var deg_sec_ma_cross "Secular"
lab var deg_the_ma_cross "Theology"

* graph

#delimit ;
twoway
(line deg_the year if year >= 1475 & year <= 1600, lcolor(dknavy) lwidth(thin))
(line deg_the_ma_cross year if year >= 1475 & year <= 1595, lcolor(red*1.25) lwidth(thick))
,
title("Theology Degrees") 
xtitle("") ytitle("Degrees")
xlabel(1475(25)1600) ylabel(,angle(0)) 
xline(1517, lwidth(thin) lcolor(black))
legend(label(1 "Degrees") label(2 "Moving Average") symxsize(5))
scheme(s1color);
#delimit cr
graph rename Graph g_the_cross, replace

#delimit ;
twoway
(line deg_sec year if year >= 1475 & year <= 1600, lcolor(dknavy) lwidth(thin))
(line deg_sec_ma_cross year if year >= 1475 & year <= 1595, lcolor(red*1.25) lwidth(thick))
,
title("Secular Degrees") 
xtitle("") ytitle("Degrees")
xlabel(1475(25)1600) ylabel(,angle(0)) 
xline(1517, lwidth(thin) lcolor(black))
legend(label(1 "Degrees") label(2 "Moving Average") symxsize(5))
scheme(s1color);
#delimit cr
graph rename Graph g_sec_cross, replace

* export
graph combine g_sec_cross g_the_cross, title("Panel B: Exclude Cologne")
grc1leg g_sec_cross g_the_cross, title("Panel B: Exclude Cologne")
graph rename g_test2, replace

*** PANEL C: Protestant Universities
clear 
use `degrees_postcollapse'

* restrict to Protestant Universities
keep if deg_uni_prot == 1

* draw graphs for both types of universities (Pro/Cat) together
collapse (sum) deg_the deg_sec, by(year)

* generate moving averages of absolute degree numbers
tsset year
tssmooth ma deg_the_ma_cross = deg_the, window(5 1 5)
tssmooth ma deg_sec_ma_cross = deg_sec, window(5 1 5)
lab var deg_sec_ma_cross "Secular"
lab var deg_the_ma_cross "Theology"

* graph 
#delimit ;
twoway
(line deg_the year if year >= 1475 & year <= 1600, lcolor(dknavy) lwidth(thin))
(line deg_the_ma_cross year if year >= 1475 & year <= 1595, lcolor(red*1.25) lwidth(thick))
,
title("Theology Degrees") 
xtitle("") ytitle("Degrees")
xlabel(1475(25)1600) ylabel(,angle(0)) 
xline(1517, lwidth(thin) lcolor(black))
legend(label(1 "Degrees") label(2 "Moving Average") symxsize(5))
scheme(s1color);
#delimit cr
graph rename Graph g_the_cross, replace

#delimit ;
twoway
(line deg_sec year if year >= 1475 & year <= 1600, lcolor(dknavy) lwidth(thin))
(line deg_sec_ma_cross year if year >= 1475 & year <= 1595, lcolor(red*1.25) lwidth(thick))
,
title("Secular Degrees") 
xtitle("") ytitle("Degrees")
xlabel(1475(25)1600) ylabel(,angle(0)) 
xline(1517, lwidth(thin) lcolor(black))
legend(label(1 "Degrees") label(2 "Moving Average") symxsize(5))
scheme(s1color);
#delimit cr
graph rename Graph g_sec_cross, replace

* export
graph combine g_sec_cross g_the_cross, title("Panel C: Protestant Universities") ysize(6) 
grc1leg g_sec_cross g_the_cross, title("Panel C: Protestant Universities") 
graph rename g_test3, replace

* final graph == for appendix
grc1leg g_test g_test2 g_test3, rows(3) name(graph_combine, replace)
graph display graph_combine, ysize(8)
graph export "$path/figures/figureA1.pdf", as(pdf) replace




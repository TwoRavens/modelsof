/*
	Project: The growing importance of social skills in the labor market (2017)
	Author: David Deming
	Date Created: April 2017
	
	Description: Runs the Census and ACS analysis and creates:
		Figures 1, 3, 4, 5, A1, A2, A3, A4
		Tables A1, A5, A6
*/


version 14
clear all
set more off


**** Define macros ****

global topdir "YOURFILEPATH/Deming_2017_SocialSkills_Replication"
local dodir "${topdir}/Do"

local rawdir "${topdir}/Data/census-acs/raw"
local cleandir "${topdir}/Data/census-acs/clean"
local collapdir "${topdir}/Data/census-acs/collapsed" 
local occdir "${topdir}/Data/census-acs/xwalk_occ"
local inddir "${topdir}/Data/census-acs/xwalk_ind"

local onetdir "${topdir}/Data/onet"
local txtdir "${topdir}/Data/onet/text_files"
local dotdir "${topdir}/Data/dot"

local nlsydir "${topdir}/Data/nlsy"
local import79dir "${topdir}/Data/nlsy/import/nlsy79"
local import97dir "${topdir}/Data/nlsy/import/nlsy97"
local name79 "socskills_nlsy79_final"			/* Name of NLSY79 extract */
local name97 "socskills_nlsy97_final"			/* Name of NLSY97 extract */
local afqtadj "${topdir}/Data/nlsy/altonjietal2012"

local figdir "${topdir}/Results/figures"
local tabdir "${topdir}/Results/tables"


**********************************************************************
****Figure 1: Employment Change in Cognitive Occupation, 2000-2012****
**********************************************************************

** Create data set of occupation titles
import delimited "`occdir'/occ1990dd_titles.csv", clear
save "`occdir'/occ1990dd_titles.dta", replace

** Consolidate cognitive occupation codes in 2000 and 2012 data

foreach y in 2000 2012 {

	use "`cleandir'/`y'.dta", clear
	
	* Managers
	replace occ1990dd=2 if (occ1990dd>=4 & occ1990dd<=22) & (occ1990dd!=7)
	
	* Accounting / Finance
	replace occ1990dd=3 if occ1990dd==7 | (occ1990dd>=23 & occ1990dd<=25)
	
	* Business support
	replace occ1990dd=4 if occ1990dd>=26 & occ1990dd<=37
	
	* Architects: Leave as is (occ1990dd==43)
	
	* Engineers
	replace occ1990dd=59 if occ1990dd>=44 & occ1990dd<=59
	
	* Computer science, programming, tech support
	replace occ1990dd=64 if occ1990dd==229 | occ1990dd==233
	
	* Operations & systems researchers/analysts: Leave as is (occ1990dd==65)
	
	* Math/stats/actuaries
	replace occ1990dd=68 if occ1990dd==66
	
	* Physical scientists
	replace occ1990dd=76 if occ1990dd>=69 & occ1990dd<=76
	
	* Biological Scientists
	replace occ1990dd=78 if occ1990dd==77 | occ1990dd==79
	
	* Medical scientists: Leave as is (occ1990dd==83)
	
	* Dentists: Leave as is (occ1990dd==85)
	
	* Physicians
	replace occ1990dd=84 if occ1990dd==86 | occ1990dd==87 | occ1990dd==88 | occ1990dd==97	
	
	* Health and occupational therapists
	replace occ1990dd=105 if occ1990dd==89 | (occ1990dd>=98 & occ1990dd<=104)
	
	* Registered nurse & licensed practical nurse
	replace occ1990dd=95 if occ1990dd==207
	
	* Pharmacists: Leave as is (occ1990dd==96)
	
	* Physicians' assistant: Leave as is (occ1990dd==106)
	
	* College instructors: Leave as is (occ1990dd==154)
	
	* Teachers, librarians & archivists
	replace occ1990dd=160 if (occ1990dd>=155 & occ1990dd<=159) | occ1990dd==164 | occ1990dd==165
	
	* Social workers, counselors and clergy
	replace occ1990dd=177 if  occ1990dd==163 | occ1990dd==174 | occ1990dd==175 | occ1990dd==176
	
	* Economists & survey researchers: Leave as is (occ1990dd==166)
	
	* Social scientists & urban planners
	replace occ1990dd=169 if occ1990dd==167	| occ1990dd==173
	
	* Lawyers & judges: Leave as is (occ1990dd==178)
	
	* Writers, editors and reporters
	replace occ1990dd=183 if occ1990dd==184 | occ1990dd==195
	
	* Arts, entertainment & sports
	replace occ1990dd=194 if (occ1990dd>=185 & occ1990dd<=193) 	| occ1990dd==198 | occ1990dd==199
	
	* Marketing, advertising & PR: Leave as is (occ1990dd==197)
	
	* Health technicians
	replace occ1990dd=208 if occ1990dd==203 | occ1990dd==205 | occ1990dd==206
	
	* Dental hygienists: Leave as is (occ1990dd==204) 
	
	* Health technicians: Leave as is (occ1990dd==208)
	
	* Technicians
	replace occ1990dd=214 if occ1990dd==223 | occ1990dd==224 | occ1990dd==228 | occ1990dd==235
	
	* Drafters & surveyors
	replace occ1990dd=217 if occ1990dd==218

	* Airline occupations
	replace occ1990dd=227 if occ1990dd==226
	
	* Legal assistants & paralegals: Leave as is (occ1990dd==234)

	
	** Collapse and calculate occupation shares

	* Collapse labor supply by consolidated occupations
	collapse (rawsum) lswt, by(occ1990dd)
	
	* Calculate labor supply in each occupation
	egen t=sum(lswt)
	gen occ_share`y'=lswt/t
	
	* Save data
	keep occ1990dd occ_share`y'
	save "`collapdir'/occshare`y'_cog_occs.dta", replace
}

** Combine data across years & further cleaning

* Merge 2000 & 2012 cognitive occupation shares
use "`collapdir'/occshare2012_cog_occs.dta", clear
merge 1:1 occ1990dd using "`collapdir'/occshare2000_cog_occs.dta", keep(1 3) nogen

* Change in occupation share
gen share00_12=100*(occ_share2012-occ_share2000)

* Indicator for STEM occupations
gen stem=(occ1990dd>=43 & occ1990dd<=83) | (occ1990dd>=214 & occ1990dd<=235)
replace stem=0 if occ1990dd==234

* Merge in occupation titles
merge 1:1 occ1990dd using "`occdir'/occ1990dd_titles.dta", keep(1 3) nogen

* Drop non-cognitive occupations
drop if occ1990dd>235

* Adjust titles for combined occupations
rename occ1990dd occ
replace title="Managers (All)" if occ==2
replace title="Accounting and Finance" if occ==3
replace title="Other Business Support" if occ==4
replace title="Engineers (All)" if occ==59
replace title="Comp. Sci./Programming/Tech Support" if occ==64
replace title="Operations Researchers" if occ==65
replace title="Math/Stats/Actuaries" if occ==68
replace title="Physical Scientists" if occ==76
replace title="Physicians" if occ==84
replace title="Nurses" if occ==95
replace title="Health Therapists" if occ==105
replace title="College Instructors" if occ==154
replace title="Teachers (K-12)" if occ==160
replace title="Economists & Survey Researchers" if occ==166
replace title="Social Scientists and Urban Planners" if occ==169
replace title="Social Workers, Counselors & Clergy" if occ==177
replace title="Lawyers & Judges" if occ==178
replace title="Writers, Editors & Reporters" if occ==183
replace title="Arts & Entertainment, Athletes" if occ==194
replace title="Marketing, Advertising & PR" if occ==197
replace title="Health Technicians" if occ==208
replace title="Engineering and Science Technicians" if occ==214
replace title="Drafters and Surveyors" if occ==217
replace title="Pilots/Air Traffic Control" if occ==227
replace title="Legal Assistants & Paralegals" if occ==234
replace title=proper(title)

****Figure 1 - Change in Relative Employment for Cognitive Occupations, 2000-12****

graph hbar (mean) share00_12 if stem==1, over(title, sort(share00_12) ///
	descending label(labsize(vsmall))) bar(1, fcolor(navy)) ///
	title("STEM Occupations", size(small)) ytitle("") ///
	ylabel(-.2(0.2)0.6, labsize(vsmall) tlength(tiny)) ///
	graphregion(color(white) margin(vsmall)) name(prof_stem) nodraw
	
graph hbar (mean) share00_12 if stem==0, over(title, sort(share00_12) ///
	descending label(labsize(vsmall))) bar(1, fcolor(navy)) ///
	title("All Other Managerial or Professional Occupations", size(small)) ///
	ytitle("") ylabel(-.2(0.2)0.6, labsize(vsmall) tlength(tiny)) ///
	graphregion(color(white) margin(vsmall)) name(prof_notstem) nodraw
	
graph combine prof_stem prof_notstem, rows(2) cols(1) graphregion(color(white) margin(small)) ///
	title("Change in Relative Employment for Cognitive Occupations, 2000-2012", ///
	size(small)) subtitle("100 x Change in Employment Share", size(vsmall))  ///
	note("Source: 2000 Census and 2011-2013 ACS", size(vsmall)) ycommon ysize(10) xsize(8)

graph save "`figdir'/fig1.gph", replace
graph export "`figdir'/fig1.pdf", replace


*****************************************
****Figure 3 & Figure A2: ALM Updates****
*****************************************

foreach year in 1980 1990 2000 2006 2009 2012 {
	
	** Set up
	
	use "`cleandir'/`year'.dta", clear

	* Exclude anyone for whom the task measures are missing
	drop if taskmerge == 0

	* Determine mean task content of each sex-education-industry cell
	collapse (rawsum) lswt (mean) math_onet1998 socskills_onet1998 service_onet1998 ///
		routine_onet1998 math_dot77 dcp_dot77 routine_dot77 [aweight=lswt], by(sex edu_bin ind6090)

	** Overall centiles	
		
	* 1980 percentile cutoffs
	
	if `year'==1980 {
		preserve
	
		* Compute percentiles of each task variable across the sex-education-industry cells
		local statlist ""
		foreach task in "math_onet1998" "socskills_onet1998" "service_onet1998" "routine_onet1998" ///
			"math_dot77" "dcp_dot77" "routine_dot77" {
			forvalues j = 1/99 {
				local statlist "`statlist' (p`j') `task'_p`j'=`task'"
			}
		}
		collapse `statlist' [aweight=lswt]

		* Store percentile values for 1980 distribution in macros
		foreach task in "math_onet1998" "socskills_onet1998" "service_onet1998" "routine_onet1998" ///
			"math_dot77" "dcp_dot77" "routine_dot77" {
			forvalues j = 1/99 {
				quietly sum `task'_p`j', meanonly
				local `task'80_p`j' = r(mean)
			}
		}
		restore
	}
		
	* Determine each cell's counterfactual 1980 percentile
	foreach task in "math_onet1998" "socskills_onet1998" "service_onet1998" "routine_onet1998" ///
		"math_dot77" "dcp_dot77" "routine_dot77" {
		gen `task'_centile = 0
		forvalues j = 1/99 {
			replace `task'_centile = `j' if `task' >= ``task'80_p`j''
		}
	}
	
	* Save mean centiles
	preserve
	collapse *centile [aweight=lswt]
	gen year = `year'
	save "`collapdir'/centiles_`year'.dta", replace
	restore

}

** Append centiles for all years to create single data set for each sex group
use "`collapdir'/centiles_1980.dta", clear
append using "`collapdir'/centiles_1990.dta"
append using "`collapdir'/centiles_2000.dta"
append using "`collapdir'/centiles_2006.dta"
append using "`collapdir'/centiles_2009.dta"
append using "`collapdir'/centiles_2012.dta"
save "`collapdir'/centiles.dta", replace

****Figure 3 - Worker Tasks in the U.S. Economy, 1980-2012****	

use "`collapdir'/centiles.dta", clear
twoway connected math_onet1998_centile socskills_onet1998_centile routine_onet1998_centile year, ///
	title("Worker Tasks in the U.S. Economy, 1980-2012", size(medium)) ///
	subtitle("Update of Autor, Levy, and Murnane (2003) Figure 1", size(medsmall)) ///
	note("Occupational Task Intensity based on 1998 O*NET", size(small)) ///
	caption("Sources: 1980-2000 Census, 2005-2013 ACS", size(vsmall)) xtitle("") ///
	ytitle("Mean Task Input in Percentiles of 1980 Distribution", size(small)) yscale(range(35 65)) ylabel(35(10)65) ///
	legend(rows(1) label(1 "Nonroutine Analytical") label(2 "Social Skills") label(3 "Routine") ///
	size(small)) msymbol(Oh Dh Sh) msize(medsmall medsmallmedsmall) clcolor(navy maroon dkorange) ///
	mcolor(navy maroon dkorange) graphregion(color(white) margin(small))
graph save "`figdir'/fig3.gph", replace		
graph export "`figdir'/fig3.pdf", replace	

****Figure A2 - Comparison of DOT and O*NET Task Measures****

use "`collapdir'/centiles.dta", clear
twoway connected math_dot77_centile math_onet1998_centile routine_dot77_centile ///
	routine_onet1998_centile dcp_dot77_centile socskills_onet1998_centile year, ///
	title("Comparison of DOT and O*NET Task Measures", size(medium)) ///
	subtitle("Update of Autor, Levy, and Murnane (2003) Figure 1", size(medsmall)) ///
	note("Occupational Task Intensities based on 1977 DOT and 1998 O*NET", size(small)) ///
	caption("Sources: 1980-2000 Census, 2005-2013 ACS", size(vsmall)) xtitle("") ///
	ytitle("Mean Task Input in Percentiles of 1980 Distribution", size(small)) yscale(range(35 65)) ylabel(35(10)65) ///
	legend(rows(3) label(1 "Math (DOT)") label(2 "Math (ONET)") label(3 "Routine (DOT)") ///
	label(4 "Routine (ONET)") label(5 "DCP (DOT)") label(6 "Social Skills (ONET)") size(small)) ///
	msymbol(Oh O Sh S Th T) msize(medsmall medsmall medsmall medsmall medsmall medsmall) ///
	clcolor(navy navy dkorange dkorange maroon maroon) mcolor(navy navy dkorange dkorange maroon maroon) ///
	lpattern(dash solid dash solid dash solid) graphregion(color(white) margin(small))
graph save "`figdir'/figA2.gph", replace
graph export "`figdir'/figA2.pdf", replace


******************************************************************************
****Figure 4 & Figure 5: Changes in Employment and Wages by Task Intensity****
******************************************************************************

** Task categories based on 1980 labor supply

use "`cleandir'/1980.dta", clear
	
* Drop occupations with no ONET data
drop if onetmerge==1

* Collapse to the mean of hourly wages, education & ONET variables, by 1990dd occupation
collapse (rawsum) lswt (mean) math_onet1998 socskills_onet1998 [aw=lswt], by(occ1990dd)

* Calculate percentiles of ONET variables in 1980, weighted by labor supply
foreach x in math socskills {
xtile `x'_pct = `x'_onet1998 [aweight=lswt], nq(100)
}	
* Define 4 occupation categories: Above vs. below median in social skill & math
gen taskcat=1 if socskills_pct>50 & math_pct>50
replace taskcat=2 if socskills_pct>50 & math_pct<=50
replace taskcat=3 if socskills_pct<=50 & math_pct>50
replace taskcat=4 if socskills_pct<=50 & math_pct<=50

* Save task categories
keep occ1990dd taskcat
save "`collapdir'/taskcat1980.dta", replace

** Employment and wages by task category & year

foreach y in 1980 1990 2000 2006 2009 2012 {

	use "`cleandir'/`y'.dta", clear
	
	* Drop occupations with no ONET data
	drop if onetmerge==1

	* Merge in task categories
	merge m:1 occ1990dd using "`collapdir'/taskcat1980.dta", nogen

	* Collapse employment and wages by task category
	collapse (rawsum) lswt (mean) hrwage [aw=lswt], by(taskcat)
	
	* Employment shares
	egen totls=total(lswt)
	gen empshr=lswt/totls
	drop totls lswt

	* Reshape wide
	gen year=`y'
	reshape wide empshr hrwage, i(year) j(taskcat)
	
	* Save yearly data
	save "`collapdir'/employ_wage_taskcat_`y'.dta", replace
}

** Append all years
use "`collapdir'/employ_wage_taskcat_1980.dta", clear
append using "`collapdir'/employ_wage_taskcat_1990.dta" "`collapdir'/employ_wage_taskcat_2000.dta" ///
	"`collapdir'/employ_wage_taskcat_2006.dta" "`collapdir'/employ_wage_taskcat_2012.dta"

** Employment share relative to 1980 (Level change)
forvalues y=1/4 {
	gen temp=empshr`y' if year==1980
	egen empshr1980=max(temp)
	replace empshr`y'=empshr`y'-empshr1980
	drop temp empshr1980
}

** Wages relatives to 1980 (Percent change)
forvalues y=1/4 {
	gen temp=hrwage`y' if year==1980
	egen hrwage1980=max(temp)
	replace hrwage`y'=(hrwage`y'-hrwage1980)/hrwage1980
	drop temp hrwage1980
}

* Save appended data for all year
save "`collapdir'/employ_wage_taskcat.dta", replace

****Figure 4 - Relative Changes in Employment Share by Occupation Task Intensity****

twoway connected empshr1 empshr2 empshr3 empshr4 year, ///
	title("Relative Changes in Employment Share by Occupation Task Intensity", size(medium)) ///
	subtitle("1980 to 2012", size(medsmall)) ///
	note("Occupational Task Intensities based on 1998 O*NET", size(small)) ///
	caption("Sources: 1980-2000 Census, 2005-2013 ACS", size(vsmall)) xtitle("") ytitle("")  ///
	legend(rows(2) label(1 "High Social, High Math") label(2 "High Social, Low Math") ///
	label(3 "Low Social, High Math") label(4 "Low Social, Low Math") size(small)) ///
	ylabel(-.05(.05).05) msymbol(Oh Dh Th Sh) msize(medsmall medsmall medsmall medsmall) ///
	clcolor(navy maroon forest_green dkorange) mcolor(navy maroon forest_green dkorange) ///
	graphregion(color(white) margin(small))
graph save "`figdir'/fig4.gph", replace
graph export "`figdir'/fig4.pdf", replace

****Figure 5 - Relative Change in Real Hourly Wages by Occupation Task Intensity****

twoway connected hrwage1 hrwage2 hrwage3 hrwage4 year, ///
	title("Relative Change in Real Hourly Wages by Occupation Task Intensity", size(medium)) ///
	subtitle("1980 to 2012", size(medsmall)) ///
	note("Occupational Task Intensities based on 1998 O*NET", size(small)) ///
	caption("Sources: 1980-2000 Census, 2005-2013 ACS", size(vsmall)) xtitle("") ytitle("")  ///
	legend(rows(2) label(1 "High Social, High Math") label(2 "High Social, Low Math") ///
	label(3 "Low Social, High Math") label(4 "Low Social, Low Math") size(small)) ///
	msymbol(Oh Dh Th Sh) msize(medsmall medsmall medsmall medsmall) ///
	clcolor(navy maroon forest_green dkorange) mcolor(navy maroon forest_green dkorange) ///
	graphregion(color(white) margin(small))
graph save "`figdir'/fig5.gph", replace
graph export "`figdir'/fig5.pdf", replace


****************************************
****Figure A1, Figure A3 & Figure A4****
****************************************

** Calculate share of employment in each 1990dd occupation in 1980 & 2012
foreach d in 1980 2012 {
	use "`cleandir'/`d'.dta", clear
	* Collapse labor supply by occupation
	collapse (rawsum) lswt, by(occ1990dd)
	* Calculate share of labor supply in each occupation
	egen t=total(lswt)
	gen occ_share`d'=lswt/t
	keep occ1990dd occ_share`d'
	save "`collapdir'/occshare`d'.dta", replace
}

* Calculate median wage in each 1990dd occupation in 1980 & 2012
foreach d in 1980 2012 {
	use "`cleandir'/`d'.dta", clear
	collapse (p50) ln_medwage=ln_hrwage [aw=lswt], by(occ1990dd)
	rename ln_medwage ln_medwage`d'
	save "`collapdir'/medwage`d'.dta", replace
}

** Collapse 1980 Census data and create task centiles

* Use 1980 Census as base year for percentiles
use "`cleandir'/1980.dta", clear

* Drop occupations with no ONET data
drop if onetmerge==1

* Collapse to the mean of hourly wages, education & ONET variables, by 1990dd occupation
collapse (rawsum) lswt (mean) ln_hrwage math_onet1998 socskills_onet1998 ///
	coord_onet1998 interact_onet1998 [aw=lswt], by(occ1990dd)

* Calculate percentiles of ONET variables in 1980, weighted by labor supply
foreach x in ln_hrwage math_onet1998 socskills_onet1998 coord_onet1998 interact_onet1998 {
	xtile `x'_pct = `x' [aweight=lswt], nq(100)
}	

** Merge in employment shares & wages and calculate changes over time

* Merge in employment shares for 1990-2012
foreach y in 1980 2012 {
	merge 1:1 occ1990dd using "`collapdir'/occshare`y'.dta", keep(master match) nogen
	merge 1:1 occ1990dd using "`collapdir'/medwage`y'.dta", keep(master match) nogen
}

* Calculate changes in employment shares and median wages from 1980 to 2012
gen share80_12=100*(occ_share2012-occ_share1980)
gen wage80_12=(ln_medwage2012-ln_medwage1980)

** Smoothed relationships between wage percentile, task percentile & employment/wage changes

* Lowess regression of ONET social skills measures on 1980 wage distribution
foreach x in socskills interact coord {
	lowess `x'_onet1998_pct ln_hrwage_pct, bwidth(0.8) gen(`x'_wage) nograph
}

* Lowess regression of change in employment shares 1980-2012 on 1980 wage distribution,
*	for each possible combination of high and low ONET social skills & math
lowess share80_12 ln_hrwage_pct if math_onet1998_pct>50 & socskills_onet1998_pct>50, ///
	bwidth(1) gen(hiMATHhiSS1) nograph
lowess share80_12 ln_hrwage_pct if math_onet1998_pct<=50 & socskills_onet1998_pct>50, ///
	bwidth(1) gen(loMATHhiSS1) nograph
lowess share80_12 ln_hrwage_pct if math_onet1998_pct>50 & socskills_onet1998_pct<=50, ///
	bwidth(1) gen(hiMATHloSS1) nograph	
lowess share80_12 ln_hrwage_pct if math_onet1998_pct<=50 & socskills_onet1998_pct<=50, ///
	bwidth(1) gen(loMATHloSS1) nograph

* Lowess regression of change in median real log hourly wage 1980-2012 on 1980 wage distribution,
*	for each possible combination of high and low ONET social skills & math
lowess wage80_12 ln_hrwage_pct if math_onet1998_pct>50 & socskills_onet1998_pct>50, ///
	bwidth(1) gen(hiMATHhiSS2) nograph
lowess wage80_12 ln_hrwage_pct if math_onet1998_pct<=50 & socskills_onet1998_pct>50, ///
	bwidth(1) gen(loMATHhiSS2) nograph
lowess wage80_12 ln_hrwage_pct if math_onet1998_pct>50 & socskills_onet1998_pct<=50, ///
	bwidth(1) gen(hiMATHloSS2) nograph
lowess wage80_12 ln_hrwage_pct if math_onet1998_pct<=50 & socskills_onet1998_pct<=50, ///
	bwidth(1) gen(loMATHloSS2) nograph

****Figure A1 - Social Skills Measure Robust to Alternative Definitions****

* Graph alternative social skills against 1980 wage distribution
sort ln_hrwage_pct
tw scatter socskills_wage interact_wage coord_wage ln_hrwage_pct, connect(l l l) legend(rows(1) ///
	label(1 "Social Skills") label(2 "Interaction") label(3 "Coordinate") size(small)) msymbol(Oh Dh Th) ///
	msize(medsmall medsmall medsmall)  ylabel(30(10)80) ///
	l1title("Occupation's Task Intensity Percentile", size(small)) ///
	ytitle("") xtitle("Occupation's Percentile in 1980 Wage Distribution", size(small)) ///
	title("Social Skills Measure Robust to Alternative Definitions", size(medium)) ///
	subtitle("Task Composition of Occupations by 1980 Wage Percentile", size(medsmall)) ///
	note("Occupational Task Intensity based on 1998 O*NET", size(small)) ///
	caption("Sources: 1980 Census", size(vsmall)) ///
	graphregion(color(white) margin(small))
graph save "`figdir'/figA1.gph", replace
graph export "`figdir'/figA1.pdf", replace

****Figure A3 - Smoothed Changes in Employment by Occupational Task Intensity****

* Graph change in employment shares 1980-2012 against 1980 wage distribution
tw scatter hiMATHhiSS1 loMATHhiSS1 hiMATHloSS1 loMATHloSS1 ln_hrwage_pct, connect(l l l l) legend(rows(2) ///
	label(1 "High Social, High Math") label(2 "High Social, Low Math") label(3 "Low Social, High Math") ///
	label(4 "Low Social, Low Math") size(small)) msymbol(Oh Dh Th Sh) ///
	msize(medsmall medsmall medsmall medsmall) ylabel(-0.2(.1)0.3) ///
	l1title("100 x Change in Employment Share", size(small)) ytitle("") ///
	xtitle("Occupation's Percentile in 1980 Wage Distribution", size(small)) ///
	title("Smoothed Changes in Employment by Occupational Task Intensity", size(medium)) ///
	subtitle("1980-2012", size(medsmall)) note("Occupational Task Intensity based on 1998 O*NET", size(small)) ///
	caption("Sources: 1980 Census, 2011-2013 ACS", size(vsmall)) ///
	graphregion(color(white) margin(small))
graph save "`figdir'/figA3.gph", replace
graph export "`figdir'/figA3.pdf", replace

****Figure A4 - Smoothed Changes in Median Wages by Occupational Task Intensity****

* Graph change in median wage 1980-2012 against wage distribution
tw scatter hiMATHhiSS2 loMATHhiSS2 hiMATHloSS2 loMATHloSS2 ln_hrwage_pct, connect(l l l l) legend(rows(2) ///
	label(1 "High Social, High Math") label(2 "High Social, Low Math") label(3 "Low Social, High Math") ///
	label(4 "Low Social, Low Math") size(small)) msymbol(Oh Dh Th Sh) msize(medsmall medsmall medsmall medsmall) ///
	ylabel(-0.2(.1)0.4) l1title("Change in Median Real Log Hourly Wage", size(small)) ytitle("") ///
	xtitle("Occupation's Percentile in 1980 Wage Distribution", size(small)) ///
	title("Smoothed Changes in Median Wages by Occupational Task Intensity", size(medium)) ///
	subtitle("1980-2012", size(medsmall)) note("Occupational Task Intensity based on 1998 O*NET", size(small)) ///
	caption("Sources: 1980 Census, 2011-2013 ACS", size(vsmall)) ///
	graphregion(color(white) margin(small))
graph save "`figdir'/figA4.gph", replace
graph export "`figdir'/figA4.pdf", replace


****************
****Table A1****
****************

** Weight ONET 1998 & DOT 1977 by Census 1980

* Use 1980 data and drop if missing task data
use "`cleandir'/1980.dta", clear
drop if taskmerge==0

* Collapse by occ1990dd
collapse (rawsum) lswt (mean) ln_hrwage math_dot77 dcp_dot77 sts_dot77 finger_dot77 ///
	ehf_dot77 require_social_onet1998-interact_onet1998 [aw=lswt], by(occ1990dd)

* Turn ONET variables into percentiles
foreach var of varlist require_social_onet1998-interact_onet1998 {
	xtile `var'_pct=`var' [aw=lswt], nq(100)
	replace `var'_pct=`var'_pct/10
}	

* Set working directory
cd "`tabdir'"
	
****Table A1 - Correlation between Routine and Social Skill Task Intensity****

reg routine_onet1998_pct socskills_onet1998_pct service_onet1998_pct ln_hrwage [aw=lswt] ///
	if math_dot77!=., vce(cluster occ1990dd)
outreg2 using tableA1, alpha(0.01, 0.05, 0.10) bracket excel dec(3) replace

reg routine_onet1998_pct socskills_onet1998_pct service_onet1998_pct ///
	math_onet1998_pct number_facility_onet1998_pct reason_onet1998_pct ///
	info_use_onet1998_pct require_social_onet1998_pct coord_onet1998_pct ///
	interact_onet1998_pct math_dot77 dcp_dot77 sts_dot77 finger_dot77 ehf_dot77 ///
	ln_hrwage [aw=lswt], vce(cluster occ1990dd)
outreg2 using tableA1, alpha(0.01, 0.05, 0.10) bracket excel dec(3)


**********************
****Tables A5 & A6****
**********************

* Append 1980, 1990, 2000 & 2012 data
use "`cleandir'/1980.dta", clear
append using "`cleandir'/1990.dta" "`cleandir'/2000.dta" "`cleandir'/2012.dta"
compress

* Drop if ONET variables are missing and drop unnecessary variables
drop if onetmerge==1
drop occ occ1990 ind onetmerge ehf_dot77-routine_dot77 

* Rename variables
foreach x in require_social number_facility math routine socskills service ///
	reason info_use coord interact {
	rename `x'_onet1998 `x'_onet	
}
rename occ1990dd occ
rename ind6090 ind

* Consolidate years for 2012 data
replace year=2012 if year==2011 | year==2012 | year==2013

* Collapse by year, gender, education, occupation & industry
collapse (mean) ln_hrwage require_social_onet-interact_onet (rawsum) lswt ///
	[aw=lswt], by(year sex edu_bin occ ind)

* Reshape wide
reshape wide lswt ln_hrwage, i(sex edu_bin occ ind) j(year)

* Log labor supply
foreach y in 1980 1990 2000 2012 {
	gen ln_lswt`y'=ln(lswt`y')
}

* Interaction between math & social skills ONET task content
gen math_soc=math_onet*socskills_onet

* Create gender x education x industry fixed effects
egen all_FE=group(sex edu_bin ind)

* Indicator for gender-educ-occ-ind cell having non-missing data on labor supply
*	for all periods
gen sample=ln_lswt1980!=. & ln_lswt1990!=. & ln_lswt2000!=. & ln_lswt2012!=.

* Indicator for management occupations
gen manage=.
foreach x in 4 7 8 9 13 14 15 18 22 243 303 413 414 415 433 448 450 470 473 ///
	494 503 558 628 803 {
	replace manage=1 if occ==`x'
}
replace manage=0 if manage!=1

* Indicators for health & education occupations
gen health=(occ>=83 & occ<=106) | (occ>=203 & occ<=208)
gen educ=(occ>=154 & occ<=165)

* Save data
save "`cleandir'/1980_2012_app_tables.dta", replace

* Set working directory
cd "`tabdir'"

**** Table A5 - Changes in Employment by Occupation Task Intensity in the Census/ACS****

areg ln_lswt2012 math_onet socskills_onet ln_lswt1980 if sample==1, ///
	absorb(all_FE) vce(cluster occ)
outreg2 using tableA5, alpha(0.01, 0.05, 0.10) bracket excel dec(3) replace

areg ln_lswt2012 math_onet socskills_onet math_soc ln_lswt1980 if sample==1, ///
	absorb(all_FE) vce(cluster occ)
outreg2 using tableA5, alpha(0.01, 0.05, 0.10) bracket excel dec(3)

areg ln_lswt2012 math_onet socskills_onet math_soc routine_onet service_onet ///
	require_social_onet number_facility_onet reason_onet info_use_onet ///
	coord_onet interact_onet ln_lswt1980 if sample==1, absorb(all_FE) vce(cluster occ)
outreg2 using tableA5, alpha(0.01, 0.05, 0.10) bracket excel dec(3)

areg ln_lswt1990 math_onet socskills_onet math_soc routine_onet service_onet ///
	require_social_onet number_facility_onet reason_onet info_use_onet ///
	coord_onet interact_onet ln_lswt1980 if sample==1, absorb(all_FE) vce(cluster occ)
outreg2 using tableA5, alpha(0.01, 0.05, 0.10) bracket excel dec(3)

areg ln_lswt2000 math_onet socskills_onet math_soc routine_onet service_onet ///
	require_social_onet number_facility_onet reason_onet info_use_onet ///
	coord_onet interact_onet ln_lswt1990 if sample==1, absorb(all_FE) vce(cluster occ)
outreg2 using tableA5, alpha(0.01, 0.05, 0.10) bracket excel dec(3)

areg ln_lswt2012 math_onet socskills_onet math_soc routine_onet service_onet ///
	require_social_onet number_facility_onet reason_onet info_use_onet ///
	coord_onet interact_onet ln_lswt2000 if sample==1, absorb(all_FE) vce(cluster occ)
outreg2 using tableA5, alpha(0.01, 0.05, 0.10) bracket excel dec(3)

areg ln_lswt2012 math_onet socskills_onet math_soc  routine_onet service_onet ///
	require_social_onet number_facility_onet reason_onet info_use_onet ///
	coord_onet interact_onet ln_lswt2000 if sample==1 & manage==0 & health==0 ///
	& educ==0, absorb(all_FE) vce(cluster occ)
outreg2 using tableA5, alpha(0.01, 0.05, 0.10) bracket excel dec(3)

**** Table A6 - Changes in Wages by Occupation Task Intensity in the Census/ACS****

areg ln_hrwage2012 math_onet socskills_onet ln_hrwage1980 if sample==1, ///
	absorb(all_FE) vce(cluster occ)
outreg2 using tableA6, alpha(0.01, 0.05, 0.10) bracket excel dec(4) rdec(3) replace

areg ln_hrwage2012 math_onet socskills_onet math_soc ln_hrwage1980 if sample==1, ///
	absorb(all_FE) vce(cluster occ)
outreg2 using tableA6, alpha(0.01, 0.05, 0.10) bracket excel dec(4) rdec(3)

areg ln_hrwage2012 math_onet socskills_onet math_soc routine_onet service_onet ///
	require_social_onet number_facility_onet reason_onet info_use_onet ///
	coord_onet interact_onet ln_hrwage1980 if sample==1, absorb(all_FE) vce(cluster occ)
outreg2 using tableA6, alpha(0.01, 0.05, 0.10) bracket excel dec(4) rdec(3)

areg ln_hrwage1990 math_onet socskills_onet math_soc routine_onet service_onet ///
	require_social_onet number_facility_onet reason_onet info_use_onet ///
	coord_onet interact_onet ln_hrwage1980 if sample==1, absorb(all_FE) vce(cluster occ)
outreg2 using tableA6, alpha(0.01, 0.05, 0.10) bracket excel dec(4) rdec(3)

areg ln_hrwage2000 math_onet socskills_onet math_soc routine_onet service_onet ///
	require_social_onet number_facility_onet reason_onet info_use_onet ///
	coord_onet interact_onet ln_hrwage1990 if sample==1, absorb(all_FE) vce(cluster occ)
outreg2 using tableA6, alpha(0.01, 0.05, 0.10) bracket excel dec(4) rdec(3)

areg ln_hrwage2012 math_onet socskills_onet math_soc routine_onet service_onet ///
	require_social_onet number_facility_onet reason_onet info_use_onet ///
	coord_onet interact_onet ln_hrwage2000 if sample==1, absorb(all_FE) vce(cluster occ)
outreg2 using tableA6, alpha(0.01, 0.05, 0.10) bracket excel dec(4) rdec(3)

areg ln_hrwage2012 math_onet socskills_onet math_soc  routine_onet service_onet ///
	require_social_onet number_facility_onet reason_onet info_use_onet ///
	coord_onet interact_onet ln_hrwage2000 if sample==1 & manage==0 & health==0 ///
	& educ==0, absorb(all_FE) vce(cluster occ)
outreg2 using tableA6, alpha(0.01, 0.05, 0.10) bracket excel dec(4) rdec(3)



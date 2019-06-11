/*
	graphs_level.do
	
	Create graphs used in the publication, other than CHK/AKM-style results.
	
*/

discard
clear all
version 11
set more off

* Directories
cap cd "<mainfolder>"
global currfolder <inputdatafolder>

global yrfirst = 1981 		// First year for major analysis
global yrlast = 2013 		// Last year in the dataset

* Output folder
global outfolder ./data/decomp_mmnts/data_qje
cap mkdir ${outfolder}

* Outside data, used below
global outsidedata ${currfolder}/outsidedata.csv

* PCE for 1959-2013
matrix pcemat = (                                                     17.262,  17.546, ///
   17.730,  17.939, 18.148, 18.414, 18.681, 19.155, 19.637,  20.402,  21.326,  22.325, ///
   23.273,  24.070, 25.367, 28.008, 30.347, 32.012, 34.091,  36.479,  39.713,  43.977, ///
   47.907,  50.552, 52.728, 54.723, 56.660, 57.886, 59.649,  61.973,  64.641,  67.439, ///
   69.651,  71.493, 73.278, 74.802, 76.355, 77.979, 79.326,  79.934,  81.109,  83.128, ///
   84.731,  85.872, 87.573, 89.703, 92.260, 94.728, 97.099, 100.063, 100.000, 101.654, ///
  104.086, 106.009, 107.211, 109.105)
  
* Nominal minimum wage 1947-2013
matrix minwg = ///
   (0.40,0.40,0.40,0.40,0.75,0.75,0.75,0.75,0.75,1.00,1.00,1.00,1.00,1.00, ///
   1.00,1.15,1.15,1.25,1.25,1.25,1.25,1.40,1.60,1.60,1.60,1.60,1.60,1.60, ///
   2.00,2.10,2.10,2.30,2.65,2.90,3.10,3.35,3.35,3.35,3.35,3.35,3.35,3.35, ///
   3.35,3.35,3.80,4.25,4.25,4.25,4.25,4.25,4.75,5.15,5.15,5.15,5.15,5.15, ///
   5.15,5.15,5.15,5.15,5.15,5.85,6.55,7.25,7.25,7.25,7.25)

* CPI-U-RS, as used by Piketty and Saez, 1978-2014
*  http://www.bls.gov/cpi/cpiurs.htm
matrix cpiursmat = (                                        104.4, 114.3, ///
	127.1, 139.2, 147.6, 153.8, 160.2, 165.7, 168.7, 174.4, 180.8, 188.6, ///
	197.9, 205.1, 210.3, 215.5, 220.0, 225.3, 231.4, 236.4, 239.6, 244.7, ///
	253.0, 260.1, 264.3, 270.2, 277.5, 286.9, 296.2, 304.6, 316.3, 315.2, ///
	320.3, 330.4, 337.3, 342.2, 347.8)



*********************************************************************************************
* Read summary stats from SAS

insheet using "${currfolder}/ssaout/datatotals.csv", clear

* Save the results
save "${outfolder}/datatotals", replace


*********************************************************************************************
* Read in percentile data

insheet using "${currfolder}/ssaout/meansall.csv", clear

* Set up years for counterfactual
gen byear = substr(year,2,strpos(year,"w")-2) if strpos(year,"b")
gen wyear = substr(year,strpos(year,"w")+1,.) if strpos(year,"b")
replace year = "" if strpos(year,"b")
destring year, replace

* Some variables are the same as those with a at the end
replace currvar="countppl" if currvar=="countppla"
replace byvar="countppl" if byvar=="countppla"

* Rename so vars are all in simpler format
foreach varname of varlist res_* {
	local newname = word(subinstr("`varname'","_"," ",.),-1)
	rename `varname' `newname'
}

* Minempl as string can make some things easier
tostring minempl, replace

* Save the results
save "${outfolder}/mmnts_all", replace


*********************************************************************************************
* Read in data on the fraction of earnings to the top percentile

insheet using "${currfolder}/ssaout/fractoppctl.csv", clear
save "${outfolder}/fractoppctl", replace


*********************************************************************************************
* Read in firm absolute size vs wage data

insheet using "${currfolder}/ssaout/threshall.csv", clear

* Rename so vars are all in simpler format
foreach varname of varlist res_* {
	local newname = word(subinstr("`varname'","_"," ",.),-1)
	rename `varname' `newname'
}

* Save
save "${outfolder}/threshall", replace


*********************************************************************************************
* Read in top employee data

insheet using "${currfolder}/ssaout/topemplall.csv", clear

* Rename so vars are all in format pXX or rankXX
foreach varname of varlist firm_wage* {
	local newname = word(subinstr("`varname'","_wage"," ",.),-1)
	rename `varname' `newname'
}

* Save
save "${outfolder}/topemplall", replace


*********************************************************************************************
* Read in general inequality data

insheet using "${currfolder}/ssaout/ineqall.csv", clear

* Rename so vars don't have res_ in front of them
foreach varname of varlist res_* {
	local newname = word(subinstr("`varname'","_"," ",1),-1)
	rename `varname' `newname'
}

* Remove all labels
foreach varname of varlist * {
	lab var `varname' ""
}

* Minempl as string can make some things easier
tostring minempl, replace

* Save
save "${outfolder}/ineqall", replace


*********************************************************************************************
* Program to create any line graph

cap program drop anylinegraph
program define anylinegraph, nclass

	syntax, varsgraphed(string) xtitle(string) ytitle(string) ///
		[ legendpos(namelist) donotzeroline legendtext(string asis) smallmarkers ///
		 xlabel(string asis) yscale(string) ylabel(string) xscale(string) ]
	
	* Default legendpos is topleft
	local legendposnum = cond("`legendpos'"=="bottomright",5,11)
	
	* Only use scale options if they are given as arguments
	foreach curropt in yscale xscale {
		local `curropt'text 
		if "``curropt''"!="" {
			local `curropt'text `curropt'(``curropt'')
		}
	}
	
	* Lists for graphs
	local colorlist maroon navy forest_green dkorange teal cranberry lavender khaki sienna
	local patternlist solid dash dot solid dash dot solid dash dot
	local mslist O D S T + X Oh Dh Sh
	
	if "`smallmarkers'"=="smallmarkers" {
		local colorlist maroon maroon navy navy forest_green forest_green
		local mslist Oh i Dh i Sh i
		local patternlist solid dash solid dash solid dash
		local msizetext msize(medsmall medsmall medsmall medsmall medsmall medsmall)
		local lwidthlist medium medthick medium medthick medium medthick
	}
	
	* Extra-dark line at zero
	local zerolinetext = cond("`donotzeroline'"=="", ///
		"yline(0, lstyle(grid) lcolor(gs10) lwidth(*1))","")
	
	* Create the graphs
	scatter `varsgraphed', ///
		c(l l l l l l l l l) lpattern(`patternlist') ///
		ms(`mslist') mcolor(`colorlist') lcolor(`colorlist') ///
		legend(size(3) pos(`legendposnum') ring(0) cols(1) colgap(3) ///
			keygap(1) symysize(1) symxsize(5) order(`legendtext') ) ///
		xtitle("`xtitle'", size(3.9)) ytitle("`ytitle'", size(3.7)) ///
		graphregion(color(white)) bgcolor(white) ///
		`yscaletext' `xscaletext' `zerolinetext' ///
		xlabel(`xlabel', labsize(3.7)) ylabel(`ylabel', labsize(3.7)) ///
		`msizetext' lwidth(`lwidthlist')

end // END of program define anylinegraph, nclass


*********************************************************************************************
*********************************************************************************************
*********************************************************************************************

*********************************************************
* END OF PROGRAMS, START OF CREATION OF GRAPHS AND TABLES
*********************************************************

*********************************************************************************************
*********************************************************************************************
*********************************************************************************************

*********************************************************************************************
* Percentiles of indv income distribution and firm size distribution
*  Figure I

foreach keeppctl in 100 1 {
	
	use "${outfolder}/mmnts_all", clear
	keep if descrip=="pctlindv" & minempl=="20" ///
		& inlist(year, ${yrfirst}, ${yrlast}) & keeppctl==`keeppctl'
	
	* Get it in the right shape, and scale properly
	keep year p*
	reshape long p, i(year) j(pctl)
	replace p = exp(p)/cond(`keeppctl'==100,1000,1000000)
	reshape wide p, i(pctl) j(year)
	destring pctl, replace
	sort pctl
	
	* Make sure labels and scales are correct
	if `keeppctl'==100 {
		local ytitlescale Thousands
		local yscale r(2.31 495)
		local ylabel 3 10 30 100 300
	}
	if `keeppctl'==1 {
		replace pctl = 99 + pctl/100
		local ytitlescale Millions
		local yscale r(.136 5.63)
		local ylabel .2 .5 1 2 5
	}
	
	anylinegraph, varsgraphed(p${yrfirst} p${yrlast} pctl) ///
		legendtext(2 "${yrlast}" 1 "${yrfirst}") ///
		xtitle(Percentile of Indv Log Earnings) ///
		ytitle(Indv Log Earnings (`ytitlescale')) yscale(log `yscale') ///
		ylabel(`ylabel') donotzeroline

}


*********************************************************************************************
* Variance decomposition
*  Figure II

foreach minempl in 20 2010000 10000 {

	use "${outfolder}/ineqall", clear
	keep if minempl=="`minempl'" & currsample=="ft"
	foreach vname in varfirm var varinrt {
		qui reg `vname' year
		predict pred_`vname'
	}
	
	anylinegraph, ///
		varsgraphed(varfirm pred_varfirm var pred_var varinrt pred_varinrt year) ///
		xtitle(Year) ytitle(Variance of Log(Earnings)) ///
		legendtext(3 "Total Variance" 5 "Within-Firm" 1 "Between-Firm") ///
		xscale(r(1978 2013)) xlabel(1980(10)2010) ///
		donotzeroline smallmarkers
		
}


*********************************************************************************************
* Graph of percentiles over time
*  Figure III

foreach currvar in indv_totwage firm_logwgmnjob indvoverfirm {
	
	use ${outfolder}/mmnts_all, clear
	qui keep if byvar=="indv_totwage" & minempl=="20" ///
		& inlist(currvar,"indv_totwage","firm_logwgmnjob") ///
		& inrange(year,${yrfirst},${yrlast}) & aggtype=="mean" ///
		& keeppctl==100 & descrip=="indvstat"
			
	* Create indvoverfirm values, and keep if correct currvar
	gen varorder = (currvar=="firm_logwgmnjob")*1 + (currvar=="indv_totwage")*2
	expand varorder, gen(newobs)
	replace varorder=3 if newobs
	replace currvar="indvoverfirm" if newobs
	sort year keeppctl varorder
	forvalues numval = 1/100 {
		qui by year keeppctl: replace p`numval' = p`numval'[_n-1] - p`numval'[_n-2] if _n==3
	}
	keep if currvar=="`currvar'"

	sort year
	foreach pvar in 99 90 50 25 {

		* Normalize to base year
		gen p`pvar'_base = p`pvar'[1]
		replace p`pvar' = p`pvar' - p`pvar'_base
		drop p`pvar'_base
		
	}

	anylinegraph, xtitle("Year") ytitle("Change Since ${yrfirst}") ///
		legendtext(1 "99 %ile" 2 "90 %ile" 3 "50 %ile" 4 "25 %ile") ///
		varsgraphed(p99 p90 p50 p25 year) yscale(r(-.2 .65)) ylabel(-.2(.2).6) ///
		xscale(r(${yrfirst} ${yrlast})) xlabel(1980(5)2010)

}


********************************************************************************************
* Counerfactual JMP decomposition
*  Figures IV and A.20

* Read data
use ${outfolder}/mmnts_all, clear
keep if (descrip=="jmpcfact100_indv" & minempl=="20") | ///
	( inlist(year,1981,2013) & byvar=="indv_totwage" & currvar=="indv_totwage" ///
		& descrip=="indvstat" & keeppctl==100 & aggtype=="mean")
gen syear = string(year) if !missing(year)
replace syear = "b" + byear + "w" + wyear if syear==""
keep syear p*
reshape long p, i(syear) j(pctl)
reshape wide p, i(pctl) j(syear) s

* Create change variables needed
foreach vname in p2013 pb1981w1981 pb1981w2013 pb2013w1981 pb2013w2013 {
	replace `vname' = `vname' - p1981
}
gen diff2013 = pb2013w2013 - p2013

anylinegraph, varsgraphed(pb1981w1981 diff2013 pctl) ///
	xlabel(0(20)100) xtitle(Percentile) ytitle(Log Difference: Estimated - Actual) ///
	legendtext(1 "1981" 2 "2013")

anylinegraph, varsgraphed(pb2013w1981 p2013 pb1981w2013 pctl) ///
	xlabel(0(20)100) xtitle(Percentile) ytitle(Log Change from 1981) ///
	legendtext(2 "Full 2013" 1 "Between-Firm Changes Only" 3 "Within-Firm Changes Only")


********************************************************************************************
* Change in within-Firm Distributions:
*  Figures VI, A.10

local rankvals rank1 rank5 rank10 rank25 rank50 p90 p50 p10

foreach subg in size100999 size10004999 size50009999 size10000 {

	use "${outfolder}/topemplall", clear
	keep if subg=="`subg'" & useanon=="execmax"
	
	* Adjust to difference since first year for first set
	foreach vname in `rankvals' {
		gen `vname'_base = `vname'[`=${yrfirst}-1978+1']
		replace `vname' = `vname' - `vname'_base
		drop `vname'_base
	}
	
	anylinegraph, varsgraphed(`rankvals' year) ///
		xtitle(Year) ytitle("Log Change Since 1981") ///
		legendtext(1 "Highest-Paid Empl" 2 "5th-Highest Paid" 3 "10th-Highest Paid" ///
			4 "25th-Highest Paid" 5 "50th-Highest Paid" 6 "90th %ile at Firm" ///
			7 "Median at Firm" 8 "10th %ile at Firm") ///
		yscale(r(-.22 1.5)) ylabel(0 .5 1 1.5) ///
		xscale(r(1978 2013)) xlabel(1980(10)2010) ///
		`donotzeroline'
		
}


********************************************************************************************
* Figures using CPS data

* Note that <${outfolder}/data/cps`yr'> files are single-year extracts from
*  CPS ASEC data via IPUMS (Flood et al., 2015), selecting based on the survey year
*  so that year t+1 provides information about year t.


*************
* Firm size wage premium by education
*  Figure VII

clear
gen year = .
tempfile allwagepremtemp
save "`allwagepremtemp'"

foreach regtype in hsless somecollmore {

	* Run the regressions
	local firstyr 1987
	local lastyr 2013
	forvalues yr = `firstyr'/`lastyr' {

		* Read the data for the correct year
		use ./data/cps/cps`=`yr'+1', clear
		
		* Standardize firm size codes
		gen firmsizestd = firmsize
		qui replace firmsizestd = 1 if inrange(firmsize,1,6)
		qui replace firmsizestd = 7 if inrange(firmsize,7,8)
		
		* Adjust for inflation to 2013 values
		foreach vname in inctot incwage {
			replace `vname' = `vname' * pcemat[1,`=2013-1959+1'] / pcemat[1,`=`yr'-1959+1']
		}
		
		* Use log wage
		gen logwage = log(incwage)
		
		* Limit to full-time with same age as the rest of the paper
		*  Also limit to same industries as our paper
		keep if inrange(age, 20, 60) & 0<incwage & incwage<9999999 ///
			& uhrsworkly>=35 & wkswork1>=40 & uhrsworkly!=999 ///
			& wtsupp>0 & !missing(wtsupp) ///
			& !inrange(ind1990,842,860) & !inrange(ind1990,900,960)
		
		local regif_hsless educ<=073
		local regif_somecollmore educ>=080
		qui reg logwage i.firmsizestd if `regif_`regtype'' [pw=wtsupp], r
		
		matrix myresults = e(b)
		forvalues i=2/3 {
			local regb_`yr'_`i' = myresults[1,`i']
		}
	}

	* Put results into a data set
	clear
	set obs `=`lastyr'-`firstyr'+1'
	gen year = _n + `firstyr' - 1
	forvalues i=2/3 {
		gen regb_`i' = .
		forvalues yr = `firstyr'/`lastyr' {
			replace regb_`i' = `regb_`yr'_`i'' if year==`yr'
		}
	}
	
	* Create the graph
	local colorlist maroon navy
	scatter regb_3 regb_2 year, ///
		c(l l) lpattern(solid dash) ms(O D) mcolor(`colorlist') lcolor(`colorlist') ///
		legend( size(3) ring(0) colgap(3) keygap(1) symysize(1) symxsize(5) cols(1) pos(2) ///
			order(1 "1k+" 2 "100 - 1k") ) ///
		xtitle("Year", size(3.9)) ///
		ytitle("Difference in Mean Log Earnings", size(3.7)) ///
		xscale(r(1987 2013)) xlabel(1990(5)2010, labsize(3.7)) ///
		yscale(r(0 .4)) ylabel(0(.1).4, labsize(3.7)) ///
		yline(0, lstyle(grid) lcolor(gs10) lwidth(*1)) ///
		graphregion(color(white)) bgcolor(white)
	
}

*************
* Comparing SSA vs CPS data
*  Figure A.2

* Temporary file for saving overall distribution data
clear
gen year = .
tempfile cpsdistrdata
save "`cpsdistrdata'"

* Read in and merge data
forvalues yr = 1978/2013 {
	use ./data/cps/cps`=`yr'+1', clear
	
	* Limit to full-time with same age as the rest of the paper
	*  Also limit to same industries as our paper
	keep if inrange(age, 20, 60) & 0<incwage & incwage<9999999 ///
		& minwg[1,`=`yr'-1947+1']*13*40<=incwage ///
		& wtsupp>0 & !missing(wtsupp) ///
		& !inrange(ind1990,842,860) & !inrange(ind1990,900,960)
	
	gen wage = log(incwage * `=pcemat[1,`=2013-1959+1'] / pcemat[1,`=`yr'-1959+1']')
	
	* Get summary statistics
	collapse (sd) cpssd=wage [w=wtsupp]
	gen cpsvar = cpssd^2
	drop cpssd
	gen year = `yr'

	append using "`cpsdistrdata'"
	save "`cpsdistrdata'", replace
}

use "${outfolder}/ineqall", clear
keep if minempl=="0" & currsample=="ft"
replace mean = exp(mean)
keep year var
merge 1:1 year using "`cpsdistrdata'", nogen
save "`cpsdistrdata'", replace

* Create graphs - levels and slopes
foreach graphtype in level change {
	use "`cpsdistrdata'", clear
	
	if "`graphtype'"=="level" {
		local ytitle Variance of Log(Earnings)
		local zeroline 
	}
	if "`graphtype'"=="change" {
		local ytitle Change in Variance of Log(Earnings)
		foreach vname in var cpsvar {
			egen var81 = mean(cond(year==1981,`vname',.))
			replace `vname' = `vname' - var81
			drop var81
		}
		local zeroline yline(0, lstyle(grid) lcolor(gs10) lwidth(*1))
	}
	
	* Create the graph
	local colorlist maroon navy
	scatter var cpsvar year, ///
		c(l l) lpattern(solid dash) ms(O D) mcolor(`colorlist') lcolor(`colorlist') ///
		legend( size(3) ring(0) colgap(3) keygap(1) symysize(1) symxsize(5) cols(1) pos(11) ///
			order(1 "SSA" 2 "CPS") ) ///
		xtitle("Year", size(3.9)) ///
		ytitle("`ytitle'", size(3.7)) ///
		xscale(r(1980 2013)) xlabel(1980(10)2010, labsize(3.7)) ///
		ylabel(, labsize(3.7)) ///
		`zeroline' ///
		graphregion(color(white)) bgcolor(white)

}

*************
* CDF of earnings based on CPS data
*  Figure A.3

foreach yr in 1981 2013 {

	use ./data/cps/cps`=`yr'+1', clear
	
	* Limit to full-time with same age as the rest of the paper
	*  Also limit to same industries as our paper
	keep if inrange(age, 20, 60) & 0<incwage & incwage<9999999 ///
		& minwg[1,`=`yr'-1947+1']*13*40<=incwage ///
		& wtsupp>0 & !missing(wtsupp) ///
		& !inrange(ind1990,842,860) & !inrange(ind1990,900,960)
	
	gen wage`yr' = log(incwage * `=pcemat[1,`=2013-1959+1'] / pcemat[1,`=`yr'-1959+1']')

	sort wage`yr'
	gen pctl = ceil(_n/_N*100)
	collapse (min) wage`yr', by(pctl)
	replace wage`yr' = exp(wage`yr')/1000
	
	tempfile wagejmp`yr'
	save "`wagejmp`yr''"

}

use "`wagejmp1981'", clear
merge 1:1 pctl using "`wagejmp2013'", nogen

local colorlist maroon navy
scatter wage1981 wage2013 pctl, ///
	c(l l) lpattern(solid dash) ms(O D) mcolor(`colorlist') lcolor(`colorlist') ///
	legend( size(3) ring(0) colgap(3) keygap(1) symysize(1) symxsize(5) cols(1) pos(11) ///
		order(1 "1981" 2 "2013") ) ///
	xtitle("Percentile of Indv Total Earnings", size(3.9)) ///
	xlabel(, labsize(3.7)) ///
	yscale(log) ///
	ylabel(3 10 30 100 300, labsize(3.7)) ///
	graphregion(color(white)) bgcolor(white)

*************
* Occupational segregation
*  Figure A.13

* Temporary file for data
clear
gen year = .
tempfile occsegtemp
save "`occsegtemp'"

forvalues yr = 1978/2013 {

	* Read the data for the correct year
	use ./data/cps/cps`=`yr'+1', clear
	
	* Limit to full-time with same age as the rest of the paper
	*  Also limit to same industries as our paper
	*  And exclude those with missing industries or occupations
	keep if inrange(age, 20, 60) & 0<incwage & incwage<9999999 ///
		& uhrsworkly>=35 & wkswork1>=40 & uhrsworkly!=999 ///
		& wtsupp>0 & !missing(wtsupp) ///
		& !inrange(ind1990,842,860) & !inrange(ind1990,900,960) ///
		& ind1990!=0 & occ1990!=0
	
	* Calculate HHI for this year, and put in the file
	bys ind1990: egen sumwgt = sum(wtsupp)
	collapse (mean) sumwgt (sum) wtsupp, by(ind1990 occ1990)
	gen indoccsharesq = (wtsupp / sumwgt)^2
	collapse (sum) hhi=indoccsharesq wtsupp, by(ind1990)
	collapse (median) hhimed=hhi [w=wtsupp]
	gen year = `yr'
	append using "`occsegtemp'"
	save "`occsegtemp'", replace

}

* Introducing skips
use "`occsegtemp'", clear
foreach yr in 1981 1982 2001 2002 2011 2012  {
	egen hhimed_`yr' = mean(cond(year==`yr',hhimed,.))
}
foreach yr in 2011 2001 1981 {
	replace hhimed = hhimed - (hhimed_`=`yr'+1' - hhimed_`yr') if year>`yr'
}

* Normalize, multiply by 10k, and split into parts
replace hhimed = hhimed - hhimed_1981
replace hhimed = hhimed * 10000
gen hhimed_part1 = hhimed if inrange(year,0,1981)
gen hhimed_part2 = hhimed if inrange(year,1982,2001)
gen hhimed_part3 = hhimed if inrange(year,2002,2011)
gen hhimed_part4 = hhimed if inrange(year,2012,99999)

* Create the graph
local colorlist maroon navy forest_green dkorange
sort year
scatter hhimed_part* year, ///
	c(l l l l) lpattern(solid dash dot solid) ms(O D S T) mcolor(`colorlist') lcolor(`colorlist') ///
	xtitle("Year", size(3.9)) ///
	ytitle("Median Occupational HHI within Industries", size(3.7)) ///
	xscale(r(1978 2013)) xlabel(1980(10)2010, labsize(3.7)) ///
	ylabel(, labsize(3.7)) ///
	graphregion(color(white)) bgcolor(white) ///
	legend(off)


********************************************************************************************
* Regressions to understand top pay dynamics
*  Figure VIII

* Read in outside data.
* S&P 500 data is from CRSP WRDS, downloaded 2015-11-05 from:
*  https://wrds-web.wharton.upenn.edu/wrds/ds/crsp/stock_a/stkmktix.cfm
*  It is restricted to the closing value on the last day recorded each year
* GDP data is from the BEA, downloaded 2015-11-04 from:
*  http://www.bea.gov/national/index.htm#gdp
*  Using annual GDP in contemporary dollars
* Unemployment data is from the BLS, downloaded 2015-11-04 from:
*  http://data.bls.gov/timeseries/LNU04000000?years_option=all_years&periods_option=specific_periods&periods=Annual+Data
insheet using "${outsidedata}", clear
keep year spindx gdp unempl

* Adjust for inflation
qui replace spindx = spindx * pcemat[1,2013-1959+1]/pcemat[1,year-1959+1]
qui replace gdp = gdp * pcemat[1,2013-1959+1]/pcemat[1,year-1959+1]

* Look for change over time
*  Note that S&P growth should be change in the index from last year to this year
*  GDP growth could be defined either from last year to this year, or this year to next year
*  but we choose this year to next year as that seems more relevant in this setting.
sort year
gen changelogsp = log(spindx/spindx[_n-1])
gen lagchangelogsp = changelogsp[_n-1]
gen changeloggdp = log(gdp[_n+1]/gdp)

* Clean data and save for merging
keep year year lagchangelogsp changeloggdp unempl
keep if inrange(year,1978,${yrlast})
tempfile outsidedatatemp
save "`outsidedatatemp'"

*************
* Read top employee data, merge outside data, and put into correct shape

use "${outfolder}/topemplall", clear
keep if useanon=="execmax"
keep year subg nobs rank1 rank2 rank3 rank4 rank5 rank10 rank25 rank50 ///
	rank100 rank500

* Reshape for easier use
foreach vname of varlist rank* {
	rename `vname' logwage`vname'
}
reshape long logwage, i(year subg) j(place) s

* Change over time
sort subg place year
by subg place: gen changelogwage = logwage - logwage[_n-1]

* Merge on outside data, and keep data where we observe change
merge m:1 year using "`outsidedatatemp'", nogen
keep if inrange(year,1979,2013)

* Save data for later use
tempfile topemplwithoutsidetemp
save "`topemplwithoutsidetemp'"


*************
* Over time: regressions of top earners vs SP500

* Temporary file for regression data
clear
gen subg=""
tempfile regouttemp
save "`regouttemp'"

* Read in data for regressions
use "`topemplwithoutsidetemp'", clear

* Run the regressions
foreach currsize in 100999 10004999 50009999 10000 {
foreach val in 500 100 50 25 10 5 4 3 2 1 {

	qui reg changelogwage lagchangelogsp unempl changeloggdp ///
		if subg=="size`currsize'" & place=="rank`val'", r
	local regb = _b[lagchangelogsp]
	
	* Put regression data in the file
	preserve
		clear
		qui set obs 1
		gen subg="size`currsize'"
		gen val = `val'
		gen result = `regb'
		
		qui append using "`regouttemp'"
		qui save "`regouttemp'", replace
	restore
	
}
}

* Get correct data ready
use "`regouttemp'", clear
reshape wide result, i(val) j(subg) s
local xlabel 
local valiter 1
gen valiter = 1
foreach val in 500 100 50 25 10 5 4 3 2 1 {
	local xlabel `"`xlabel' `valiter' "`val'""'
	replace valiter = `valiter' if val==`val'
	local valiter = `valiter'+1
}

* Make the graph
anylinegraph, varsgraphed(resultsize100999 resultsize10004999 ///
	resultsize50009999 resultsize10000 valiter) ///
	xtitle("Rank Within Firm") ytitle("Regression Coefficient") ///
	xlabel(`xlabel') ///
	legendtext(4 "10k+" 3 "5k - 10k" 2 "1k - 5k" 1 "100 - 1k")


********************************************************************************************
* Comparing SSA totals to other records

*************
* Total income
*  Figure A.1.a

* Income data is from FRED, downloaded 2016-04-04 from
*  https://research.stlouisfed.org/fred2/series/A576RC1
*  "Compensation of Employees, Received: Wage and Salary Disbursements"

insheet using "${outsidedata}", clear
keep year fredcomp
keep if inrange(year,1978,2013)
tempfile totinctemp
save "`totinctemp'"

use "${outfolder}/datatotals", clear
keep year totinc
merge 1:1 year using "`totinctemp'", nogen

replace fredcomp = fredcomp/1000
replace totinc = totinc/(10^12)
replace fredcomp = fredcomp * pcemat[1,2013-1959+1] / pcemat[1,year-1959+1]

sort year
anylinegraph, varsgraphed(fredcomp totinc year) ///
	xtitle(Year) ytitle("Total Income (Trillions of 2013 Dollars)") ///
	legendtext(1 "NIPA" 2 "SSA total") ///
	xscale(r(1978 2013)) xlabel(1980(10)2010)


*************
* Total employment
*  Figure A.1.b

* From CPS via BLS, series LNS12000000, extracted 2016-04-04
*  and then averaged over the year

insheet using "${outsidedata}", clear
keep year totemplcps
keep if inrange(year,1978,2013)
tempfile cpsempltemp
save "`cpsempltemp'"

use "${outfolder}/datatotals", clear
keep year numindv
merge 1:1 year using "`cpsempltemp'", nogen

replace totemplcps = totemplcps/1000
replace numindv = numindv/(10^6)

sort year
anylinegraph, varsgraphed(numindv totemplcps year) ///
	xtitle(Year) ytitle("Total Employment (Millions)") ///
	legendtext(1 "SSA individuals" 2 "CPS total employment") ///
	xscale(r(1978 2013)) xlabel(1980(10)2010)


*************
* Number of firms
*  Figure A.1.c

* From Census, extracted 2016-04-04 from:
*  - us_state_totals_1988-2006.xls
*  - us_state_totals_2007-2013.xls
* Downloaded from:
*  https://www.census.gov/econ/susb/historical_data.html

insheet using "${outsidedata}", clear
keep year censusnumfirm
keep if inrange(year,1978,2013)
tempfile firmnumtemp
save "`firmnumtemp'", replace

use "${outfolder}/datatotals", clear
keep year numfirm
merge 1:1 year using "`firmnumtemp'", nogen

replace censusnumfirm = censusnumfirm/(10^6)
replace numfirm = numfirm/(10^6)

sort year
anylinegraph, varsgraphed(censusnumfirm numfirm year) ///
	xtitle(Year) ytitle("Number of Firms (Millions)") ///
	legendtext(1 "SSA firms" 2 "Census firms") ///
	xscale(r(1978 2013)) xlabel(1980(10)2010)


*********************************************************************************************
* Percentiles of firm size distribution
*  Figure A.6

foreach currvar in firmsize indvsize {

	use "${outfolder}/mmnts_all", clear
	keep if descrip=="pctl`currvar'" & currvar=="countppl" & minempl=="0" ///
		& inlist(year, ${yrfirst}, ${yrlast}) & keeppctl==100

	* Get it in the right shape with right observations
	keep year p*
	reshape long p, i(year) j(pctl)
	reshape wide p, i(pctl) j(year)
	destring pctl, replace
	sort pctl
	if "`currvar'"=="indvsize" {
		keep if pctl<98
	}
	
	* Titles and labels
	local xtitle_firmsize Percentile of Number of Employees
	local ytitle_firmsize Number of Employees
	local yscale_firmsize r(.591 327)
	local ylabel_firmsize 1 3 10 30 100 300
	local xtitle_indvsize Individual Percentile of Firm Size
	local ytitle_indvsize Firm Size
	local yscale_indvsize r(1 10000)
	local ylabel_indvsize `"1 "1" 10 "10" 100 "100" 1000 "1000" 10000 "10{superscript:4}" 100000 "10{superscript:5}""'

	anylinegraph, varsgraphed(p${yrfirst} p${yrlast} pctl) ///
		legendtext(2 "${yrlast}" 1 "${yrfirst}") ///
		xtitle("`xtitle_`currvar''") ///
		ytitle("`ytitle_`currvar''") ///
		yscale(log `yscale_`currvar'') ///
		ylabel(`"`ylabel_`currvar''"') donotzeroline
	
}


********************************************************************************************
* Comparing SSA numbers vs. Piketty and Saez numbers
*  Figure A.7

* P&S numbers are from <TabFig2014prel.xls>, sheet "Table B3",
*  downloaded from http://eml.berkeley.edu/~saez/
*  on 2016-04-04
insheet using "${outsidedata}", clear
keep year ps_*
foreach vname of varlist ps_* {
	* Adjust for inflation with the PCE, not the CPI
	replace `vname' = `vname' * cpiursmat[1,year-1978+1] / cpiursmat[1,2013-1978+1] * ///
		pcemat[1,2013-1959+1] / pcemat[1,year-1959+1]
}
keep if inrange(year,1978,2011)
tempfile psdatatemp
save "`psdatatemp'"

use "${outfolder}/ineqall", clear
keep if minempl=="20" & currsample=="ft"
keep year p90 p95 p995 p999
merge 1:1 year using "`psdatatemp'", nogen keep(match)

local pctltxt_p90 90
local pctltxt_p95 95
local pctltxt_p995 99.5
local pctltxt_p999 99.9
foreach currstat in p90 p95 p995 p999 {
	replace `currstat' = `currstat'/1000
	replace ps_`currstat' = ps_`currstat'/1000
	anylinegraph, varsgraphed(`currstat' ps_`currstat' year) ///
		legendtext(1 "SSA" 2 "Piketty & Saez") donotzeroline ///
		xtitle(Year) ///
		ytitle("`pctltxt_`currstat'' Percentile of Earnings (Thousands)")
}


********************************************************************************************
* Look at firm statistics by size grouping
*  Figure A.8

foreach currsizecat in 3 4 5 6 7 8 9 10 11 {

	use ${outfolder}/threshall, clear
	keep if inlist(aggtype,"p10","p25","p50","p75","p90")
	keep year aggtype p`currsizecat'
	rename p`currsizecat' wage
	
	* Make each variable show change in this percentile since 1981
	bys aggtype: egen wagefirstyr = max(cond(year==1981,wage,.))
	replace wage = wage - wagefirstyr
	keep year aggtype wage
	reshape wide wage, i(year) j(aggtype) s	
	
	anylinegraph, varsgraphed(wagep10 wagep25 wagep50 wagep75 wagep90 year) ///
		legendtext(1 "10th %ile" 2 "25th %ile" 3 "50th %ile" 4 "75th %ile" 5 "90th %ile") ///
		xscale(r(1978 2013)) xlabel(1980(10)2010) xtitle("Year") ///
		ytitle("Log Change in Indv Pctls Since 1981") ///
		yscale(r(-.4 .5)) ylabel(-.4(.2).4)
	
}


********************************************************************************************
* Levels of within-firm percentiles by firm size
*  Figure A.9

foreach currpctl in 10 50 90 {

	use "${outfolder}/topemplall", clear
	keep if useanon=="1" & inlist(subg,"size100999","size10004999","size50009999","size10000")
	keep year subg p`currpctl'
	replace p`currpctl' = exp(p`currpctl') / 1000
	reshape wide p`currpctl', i(year) j(subg) s
	
	anylinegraph, varsgraphed(p`currpctl'size100999 p`currpctl'size10004999 p`currpctl'size50009999 p`currpctl'size10000 year) ///
		legendtext(1 "100-1k" 2 "1k-5k" 3 "5k-10k" 4 "10k+") ///
		xscale(r(1978 2013)) xlabel(1980(10)2010) xtitle("Year") ///
		yscale(log) ytitle("Wage at Within-Firm `currpctl'th Pctl (Thousands)") ///
		donotzeroline legendpos(bottomright)
}


********************************************************************************************
* Change in inequality for coworkers across all percentiles between 1981 and 2013
*  Figures A.11 and A.12

foreach keeppctl in 100 1 {

	* Get correct data
	use ${outfolder}/mmnts_all, clear
	
	qui keep if inlist(currvar,"indv_totwage","firm_logwgmnjob") & byvar=="indv_totwage" ///
		& minempl=="20" & keeppctl==`keeppctl' & byweight=="1" & descrip=="indvstat" ///
		& inlist(year,1981,2013) & aggtype=="mean"
	
	* Make sure the order is byvar, then currvar - then get difference
	gen varorder = (currvar!="indv_totwage")
	sort varorder year
	foreach pvar of varlist p* {
		qui by varorder: replace `pvar' = `pvar' - `pvar'[_n-1] if _n==2
	}
	qui by varorder: keep if _n==2
	set obs 3
	replace currvar = "diff" if _n==3
	foreach pvar of varlist p* {
		qui replace `pvar' = `pvar'[1] - `pvar'[2] if _n==3
	}
	
	keep currvar p*
	reshape long p, i(currvar) j(pctl)
	reshape wide p, i(pctl) j(currvar) s

	destring pctl, replace
	sort pctl
	
	local currxlabel 0(20)100
	if `keeppctl'==1 {
		replace pctl = 99 + pctl/100
		local currxlabel 99(.2)100
	}
	
	anylinegraph, varsgraphed(pfirm_logwgmnjob pindv_totwage pdiff pctl) xlabel(`currxlabel') ///
		xtitle("Percentile of Indv Total Earnings") ///
		ytitle("Log Change, 1981-2013") ///
		legendtext(2 "Indv Total Earnings" 1 "Avg of Log Earnings at Firm" ///
			3 "Indv Earnings/Firm Average")
	
}


********************************************************************************************
* Summary stats
*  Table I

use "${outfolder}/mmnts_all", clear
keep if inlist(year,1981,2013) & minempl=="20" ///
	& keeppctl==100 & inlist(aggtype,"min")
keep year byvar currvar descrip byweight p11 p26 p51 p76 p91
gen anlev = "Firm" if inlist(descrip,"pctlfirmsize","pctlfirm","pctlfirmwgt")
replace anlev = "Indiv." if anlev==""
gen vardescrip = "Employees" if currvar=="countppl"
replace vardescrip = "Earnings" if descrip=="pctlindv"
replace vardescrip = "Earnings/Firm Avg" if descrip=="pctlinrt"
replace vardescrip = "Earnings (Unwgt)" if descrip=="pctlfirm"
replace vardescrip = "Earnings (Wgted)" if descrip=="pctlfirmwgt"
sort year anlev vardescrip
foreach pval in 11 26 51 76 91 {
	replace p`pval' = exp(p`pval') if strpos(vardescrip, "Earn")
	replace p`pval' = p`pval'/1000 if strpos(vardescrip, "Earn") & descrip!="pctlinrt"
	format p`pval' %9.3g
	rename p`pval' p`=`pval'-1'
}
lab var year Year
li year anlev vardescrip p10 p25 p50 p75 p90

	
********************************************************************************************
* Robustness checks on variance decomposition
*  Tables II, A.3, and A.4

use ${outfolder}/ineqall, clear
keep if inlist(year,1981,2013) & inlist(minempl,"0","20","2010000","10000") & ///
	(currsample=="ft" | inlist(substr(currsample,1,4),"dmn_","oth_","sgw_","sgp_"))
keep year minempl currsample var varinrt
gen varfirm = var - varinrt
drop varinrt
rename var vartot
reshape wide var*, i(minempl currsample) j(year)
gen varincrease = vartot2013 - vartot1981
gen varfracbetween = (varfirm2013 - varfirm1981)/varincrease
format var* %9.3f
gen descrip = ""
replace descrip = "Baseline sample" if currsample=="ft" & minempl=="20"
replace descrip = "Any number of empl" if currsample=="ft" & minempl=="0"
replace descrip = "20-10k workers" if currsample=="ft" & minempl=="2010000"
replace descrip = "10k+ workers" if currsample=="ft" & minempl=="10000"
replace descrip = "Demean: county" if currsample=="dmn_cnty"
replace descrip = "Demean: state" if currsample=="dmn_geo"
replace descrip = "Demean: 2-digit SIC" if currsample=="dmn_ind2"
replace descrip = "Demean: 3-digit SIC" if currsample=="dmn_ind3"
replace descrip = "Demean: 4-digit SIC" if currsample=="dmn_ind4"
replace descrip = "Demean: gender" if currsample=="dmn_male"
replace descrip = "Demean: census region" if currsample=="dmn_regn"
replace descrip = "Demean: firm size category" if currsample=="dmn_thrsh"
replace descrip = "Demean: person year of birth" if currsample=="dmn_yob"
replace descrip = "Avg 5-year earnings" if currsample=="oth_avg5yr"
replace descrip = "Age 20-29" if currsample=="sgp_age20s"
replace descrip = "Age 30-39" if currsample=="sgp_age30s"
replace descrip = "Age 40-49" if currsample=="sgp_age40s"
replace descrip = "Age 50-60" if currsample=="sgp_age50s"
replace descrip = "Min earn = 1040 x min wage" if currsample=="sgp_mw1040"
replace descrip = "Min earn = 2080 x min wage" if currsample=="sgp_mw2080"
replace descrip = "Min earn = 260 x min wage" if currsample=="sgp_mw260"
replace descrip = "Min earn based on 2013 min wage" if currsample=="sgp_mwyr13"
replace descrip = "Excluding top 1%" if currsample=="sgp_n1a"
replace descrip = "Excluding top 1% in each firm" if currsample=="sgp_n1f"
replace descrip = "Excluding top 5%" if currsample=="sgp_n5a"
replace descrip = "Excluding top 5% in each firm" if currsample=="sgp_n5f"
replace descrip = "Excluding top-paid person in each firm" if currsample=="sgp_nr1"
replace descrip = "Excluding 5 top-paid people in each firm" if currsample=="sgp_nr5"
replace descrip = "Continuing firms only" if currsample=="sgw_cntfrm"
replace descrip = "Midwest" if currsample=="sgw_regMW"
replace descrip = "Northeast" if currsample=="sgw_regNE"
replace descrip = "South" if currsample=="sgw_regSO"
replace descrip = "West" if currsample=="sgw_regWE"
replace descrip = "Size: 0-10" if currsample=="sgw_tsh1"
replace descrip = "Size: 5k-10k" if currsample=="sgw_tsh10"
replace descrip = "Size: 10k+" if currsample=="sgw_tsh11"
replace descrip = "Size: 10-20" if currsample=="sgw_tsh2"
replace descrip = "Size: 20-50" if currsample=="sgw_tsh3"
replace descrip = "Size: 50-100" if currsample=="sgw_tsh4"
replace descrip = "Size: 100-200" if currsample=="sgw_tsh5"
replace descrip = "Size: 200-500" if currsample=="sgw_tsh6"
replace descrip = "Size: 500-1k" if currsample=="sgw_tsh7"
replace descrip = "Size: 1k-2k" if currsample=="sgw_tsh8"
replace descrip = "Size: 2k-5k" if currsample=="sgw_tsh9"
replace descrip = "Women only" if currsample=="sgp_sexf"
replace descrip = "Men only" if currsample=="sgp_sexm"
replace descrip = "Manufacturing" if currsample=="sgw_indD"
replace descrip = "Utilities" if currsample=="sgw_indE"
replace descrip = "FIRE" if currsample=="sgw_indH"
replace descrip = "Services" if currsample=="sgw_indI"
replace descrip = "Trade" if currsample=="sgw_indFG"
replace descrip = "Ag/Mining/Construct/Oth" if currsample=="sgw_indABCJ"
drop if inlist(currsample,"sgw_indA","sgw_indB","sgw_indC","sgw_indJ","sgw_indF","sgw_indG")

* Select variables and look at tables
gen ismain= inlist(currsample,"ft","dmn_cnty","dmn_ind4","dmn_male","dmn_yob", ///
	"sgp_age20s","sgp_age30s","sgp_age40s","sgp_age50s") & minempl!="0"
li descrip var*
li descrip var* if ismain


********************************************************************************************
* Fraction of income to top 1% that is going to top people at firms
*  Table A.1

use ${outfolder}/fractoppctl, clear
keep if minempl==20 & distrpctl==99
foreach vname of varlist res_fractop* {
	replace `vname' = round(`vname' / res_fracallinpctl * 100,1)
}
keep year *rank1 *rank5 *p99
reshape long res_, i(year) j(place) s
reshape wide res_, i(place) j(year)
li


********************************************************************************************
* Fraction of top 0.1% who are top at their firms
*  Table A.2

use ${outfolder}/mmnts_all, clear
keep if currvar=="isfirmtop1" & minempl=="20"
egen tot100 = rowtotal(p1-p100)
egen tot10 = rowtotal(p91-p100)
replace tot10 = tot10*10
keep year keeppctl tot100 tot10
reshape long tot, i(year keeppctl) j(frac)
reshape wide tot, i(keeppctl frac) j(year)
gen pctpop = keeppctl * frac / 100
drop if pctpop==10
li pctpop tot1981 tot2013

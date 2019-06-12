/********************************
DOES A POSITIVE ECONOMIC SHOCK REDUCE NON-MARITAL BIRTHS AMONG THE NON-COLLEGE 
EDUCATED? EVIDENCE FROM THE FRACKING BOOM

Melissa Kearney & Riley Wilson
Start Date May 17, 2016

This do file runs all of the analysis needed for the above paper.
********************************/
clear all
set more off
set matsize 5000
/*set globals
Before running, set these globals to the directory on your computer
*/
//Where data is located
global data ""
//Where Vital Stats data is located
global vsdata ""
//Where State will output tables
global output ""


global popcontrols15_17 "fmsexratio1517 lnhpi m1517sharenhblack m1517sharehisp m1517sharenhother f1517sharenhblack f1517sharehisp f1517sharenhother"

global popcontrols18_34 "fmsexratio1834 lnhpi m1834sharenhblack m1834sharehisp m1834sharenhother f1834sharenhblack f1834sharehisp f1834sharenhother f1834_sharelshs f1834_sharescoll f1834_sharecoll m1834_sharelshs m1834_sharescoll m1834_sharecoll"
global popcontrols35_44 "fmsexratio3544 lnhpi m3544sharenhblack m3544sharehisp m3544sharenhother f3544sharenhblack f3544sharehisp f3544sharenhother f3544_sharelshs f3544_sharescoll f3544_sharecoll m3544_sharelshs m3544_sharescoll m3544_sharecoll"

ssc install outreg2 
ssc install reghdfe
ssc install spmap
/////////////////////////////////////
/************************************

TABLES AND FIGURES

*************************************/

////////////////////////

*********TABLES*********

////////////////////////
/******************************
Table 1. SUMMARY STATISTICS FOR ANALYSIS SAMPLE PUBLIC USE MICRODATA AREAS, YEAR 2000 (PRE-FRACKING BOOM)
******************************/
cd $output
cap log close
log using table1_sumstatlog.log, replace
cd $data
use analysissamp_alldata, clear
keep if year>=1999 & year<=2012
keep if year == 2000
	
cd $output
cap file close sumstat
file open sumstat using table1new_sumstat_puma.txt, write replace
file write sumstat _tab "Non-Fracking" _tab "Fracking" _tab "Difference" _n
file write sumstat _n _tab "Birth and Marriage Characteristics" _n
foreach var in totbr18_34 sharenmar18_34 marbr18_34 nmarbr18_34 fallnevmar18_34 fallmarried18_34 falldiv18_34 fallcohab18_34 {
	file write sumstat "`var'"
	reg `var' fracking [aw = totb2000] ,
	file write sumstat _tab %7.1f (_b[_cons]) _tab %7.1f (_b[fracking]+_b[_cons]) _tab %7.1f (_b[fracking])
	test fracking = 0
	local p = r(p)
	if `p'<.01 {
		file write sumstat "***"
	}
	if `p'>=.01 & `p'<.05 {
		file write sumstat "**"
	}
	if `p'>=.05 & `p'<.1 {
		file write sumstat "*"
	}
	file write sumstat _n
}	

file write sumstat _n _tab "Labor Market  Characteristics" _n
foreach var in m_lscollearn_pw2010 f_lscollearn_pw2010 m_collearn_pw2010 f_collearn_pw2010   {
	file write sumstat "`var'"
	reg `var' fracking [aw = totb2000] ,
	file write sumstat _tab %7.1f (_b[_cons]) _tab %7.1f (_b[fracking]+_b[_cons]) _tab %7.1f (_b[fracking])
	test fracking = 0
	local p = r(p)
	if `p'<.01 {
		file write sumstat "***"
	}
	if `p'>=.01 & `p'<.05 {
		file write sumstat "**"
	}
	if `p'>=.05 & `p'<.1 {
		file write sumstat "*"
	}
	file write sumstat _n
}
file write sumstat _n _tab "County Population Characteristics" _n
foreach var in share1834white m1834_sharecoll f1834_sharecoll {
	file write sumstat "`var'"
	reg `var' fracking [aw = totb2000] ,
	file write sumstat _tab %7.1f (_b[_cons]) _tab %7.1f (_b[fracking]+_b[_cons]) _tab %7.1f (_b[fracking])
	test fracking = 0
	local p = r(p)
	if `p'<.01 {
		file write sumstat "***"
	}
	if `p'>=.01 & `p'<.05 {
		file write sumstat "**"
	}
	if `p'>=.05 & `p'<.1 {
		file write sumstat "*"
	}
	file write sumstat _n
}
file write sumstat _n
file write sumstat "Number of Counties"
foreach f in nonfracking fracking {
	qui count if `f' == 1 
	file write sumstat _tab %7.0fc (r(N))
}

file close sumstat

log close

/*************************************
Table 2. EFFECT OF PUMA-LEVEL SIMULATED NEW PRODUCTION ON LABOR MARKET MEASURES, 1997-2012
*************************************/
cd $output
cap log close
log using table2_labormarketlog.log, replace
cd $data
use analysissamp_alldata, clear

xtset stpuma year

reghdfe lnm_allearn_pw2010 simnewvalue_capita $popcontrols18_34 if year<=2012 , absorb(stpuma st_yr) vce(cluster stpuma)
	gen m_regsamp = e(sample) == 1
reghdfe lnf_allearn_pw2010 simnewvalue_capita $popcontrols18_34 if year<=2012 , absorb(stpuma st_yr) vce(cluster stpuma)
	gen f_regsamp = e(sample) == 1
		
cd $output
cap erase table2_lm.txt
//Cty and Year WT
foreach ed in all lscoll coll {
	foreach g in m f {
		foreach outcome in earn_pw2010 othearn_pw2010 jobpop {
			reghdfe ln`g'_`ed'`outcome' simnewvalue_capita $popcontrols18_34 [aw = totb2000] if m_regsamp == 1 & year<=2012 , absorb(stpuma st_yr) vce(cluster stpuma)
			testparm simnewvalue_capita
			local f = r(F)
			qui sum `g'_`ed'`outcome' [aw = totb2000] if e(sample) == 1
			local dmean = r(mean)
			outreg2 using table2_lm.txt, excel dec(3) keep(simnewvalue_capita) nor2 addstat("F-statistic", `f', "Dependent Means (in levels)", `dmean') ctitle(`g', `outcome')
		}
	}
}
log close		

/*******************************
Table 3. Reduced Form Effect of Simulated Fracking Production on Birth Outcomes for Women, 18-34
*******************************/
cd $output
cap log close
log using table3_rfbirthslog.log, replace
cd $data
use analysissamp_alldata, clear
	
foreach t in tot mar nmar {
	gen `t'share = (`t'lscollb18_34/`t'b18_34)
}
//What share of births were to LS COLL women?
sum totshare [aw = totb2000] if year == 2000, de
sum marshare [aw = totb2000] if year == 2000, de
sum nmarshare [aw = totb2000] if year == 2000, de

xtset stpuma year
	
cd $output
cap erase table3_rfbirth.txt
//Wieght by births to 18-34 yr olds in 2000
foreach outcome in sharenmar18_34 totbr18_34 marbr18_34 nmarbr18_34 {
	reghdfe `outcome' simnewvalue_capita $popcontrols18_34 [aw = totb2000] if year<=2012, absorb(stpuma st_yr) vce(cluster stpuma)
	qui sum `outcome' [aw = totb2000] if e(sample) == 1
	outreg2 using table3_rfbirth.txt, excel dec(2) nor2 keep(simnewvalue_capita) addstat("Dependent Means (in levels)", r(mean)) ctitle(`outcome')
}

//Check for statistical differences
dis "CHECK FOR STATISTICALLY SIGNIFICANT DIFFERENCES"
cd $data
use analysissamp_alldata, clear
gen allbr18_34m1 = marbr18_34
gen allbr18_34m0 = nmarbr18_34
reshape long allbr18_34m, i(stpuma year) j(marrate)
foreach var of varlist simnewvalue_capita $popcontrols18_34 {
	gen mar_`var' = marrate*`var'
}
egen stpuma_mar = group(stpuma marrate)
egen st_yr_mar = group(st_yr marrate)
reghdfe allbr18_34m mar_* simnewvalue_capita $popcontrols18_34 [aw = totb2000] if year<=2012, absorb(stpuma_mar st_yr_mar) vce(cluster stpuma_mar)
	
log close	
	
/*************************
Table 4. Reduced Form Effect of Simulated Fracking Production on Marriage Outcomes for Women Age 18 to 34
*************************/
cd $output
cap log close
log using table4_rfmarstlog.log, replace
cd $data
use analysissamp_alldata, clear

xtset stpuma year

cd $output
cap erase table4_rfmarst.txt
foreach outcome in fallnevmar18_34 fallmarried18_34 fallmarthisyr18_34 falldiv18_34 fallcohab18_34  {
	reghdfe `outcome' simnewvalue_capita $popcontrols18_34 [aw = totb2000] , absorb(stpuma st_yr) vce(cluster stpuma)
	qui sum `outcome' if e(sample) == 1
	outreg2 using table4_rfmarst.txt, excel dec(2) nocons nor2 keep(simnewvalue_capita) addstat("Dependent Mean", r(mean)) ctitle("`outcome'")
}	

log close

/***************************
Table 5. Reduced Form Effect of Simulated New Production by Baseline Non-Marital Birth Share for Women Age 18 to 34
***************************/
cd $output
cap log close
log using table5_cutoffs.log, replace
cd $data
use analysissamp_alldata, clear

xtset stpuma year

bys stpuma: egen nmshare2000 = max(sharenmar18_34*(year == 2000))

sum nmshare2000 if year == 2000, de
local p50 = r(p50)
local p25 = r(p25)

cd $output
cap erase table5_bypreexposure.txt
foreach g in "nmshare2000>" "nmshare2000<=" {
	foreach outcome in marbr18_34 nmarbr18_34 fallnevmar18_34 {
		reghdfe `outcome' simnewvalue_capita $popcontrols18_34 [aw = totb2000] if `g' `p50'  & year<=2012, absorb(stpuma st_yr) vce(cluster stpuma)
		qui sum `outcome' [aw = totb2000] if e(sample) == 1
		outreg2 using table5_bypreexposure.txt, excel dec(2) nor2 keep(simnewvalue_capita) addstat("Dependent Mean", r(mean)) ctitle(`outcome')
	}
}	

//Test for Statistical Significance
//Across group, within marital status
cd $data
use analysissamp_alldata, clear
replace fallmarthisyr18_34 = . if year == 2000
replace ihsfallmarthisyr18_34 = . if year == 2000

xtset stpuma year

bys stpuma: egen nmshare2000 = max(sharenmar18_34*(year == 2000))

sum nmshare2000 if year == 2000, de
local p50 = r(p50)
gen belowmedian = nmshare2000<=`p50'
foreach var of varlist simnewvalue_capita $popcontrols18_34 {
	gen bm_`var' = belowmedian*`var'
}
egen stpuma_bm = group(stpuma belowmedian)
egen st_yr_bm = group(st_yr belowmedian)
reghdfe marbr18_34 bm_* simnewvalue_capita $popcontrols18_34 [aw = totb2000] if year<=2012, absorb(stpuma_bm st_yr_bm) vce(cluster stpuma_bm)
reghdfe nmarbr18_34 bm_* simnewvalue_capita $popcontrols18_34 [aw = totb2000] if year<=2012, absorb(stpuma_bm st_yr_bm) vce(cluster stpuma_bm)
	
//Within Group, across marital status
cd $data
use analysissamp_alldata, clear
replace fallmarthisyr18_34 = . if year == 2000
replace ihsfallmarthisyr18_34 = . if year == 2000

xtset stpuma year

bys stpuma: egen nmshare2000 = max(sharenmar18_34*(year == 2000))

sum nmshare2000 if year == 2000, de
local p50 = r(p50)
gen belowmedian = nmshare2000<=`p50'
gen allbr18_34m1 = marbr18_34
gen allbr18_34m0 = nmarbr18_34
reshape long allbr18_34m, i(stpuma year) j(marrate)
foreach var of varlist simnewvalue_capita $popcontrols18_34 {
	gen mar_`var' = marrate*`var'
}
egen stpuma_mar = group(stpuma marrate)
egen st_yr_mar = group(st_yr marrate)
reghdfe allbr18_34m mar_* simnewvalue_capita $popcontrols18_34 [aw = totb2000] if belowmedian == 0 & year<=2012, absorb(stpuma_mar st_yr_mar) vce(cluster stpuma_mar)
reghdfe allbr18_34m mar_* simnewvalue_capita $popcontrols18_34 [aw = totb2000] if belowmedian == 1 & year<=2012, absorb(stpuma_mar st_yr_mar) vce(cluster stpuma_mar)
	
log close


/******************************
Table 6. Long Difference Reduced Form Effect of Simulated Total Production on Long Run Birth and Marriage Outcomes for Women 18 to 34
******************************/
cd $output
cap log close 
log using table6_longdiffmarstlog.log, replace
cd $data
use analysissamp_alldata, clear
keep if year>=2000
gen t = simnewvalue_capita if year>=2000 & year<=2011
bys stpuma: egen newsimtot00_11 = sum(t)
drop t 
keep if inlist(year,2000,2011)
foreach var in marbr18_34 nmarbr18_34 fallnevmar18_34 fallmarried18_34  falldiv18_34 fallcohab18_34 {
	gen t2000`var' = ihs`var' if year == 2000
	bys stpuma: egen y2000ihs`var' = max(t2000`var')
	gen ldiff_ihs`var' = ihs`var'-y2000ihs`var'
	drop t2000*
}
foreach var in marbr18_34 nmarbr18_34 fallnevmar18_34 fallmarried18_34  falldiv18_34 fallcohab18_34 {
	gen t2000`var' = `var' if year == 2000
	bys stpuma: egen y2000`var' = max(t2000`var')
	gen ldiff_`var' = `var' - y2000`var'
	drop t2000*
}
foreach var of varlist $popcontrols18_34 {
	gen t2000`var' = `var' if year == 2000
	bys stpuma: egen y2000`var' = max(t2000`var')
	gen ldiffcont_`var' = `var' - y2000`var'
	drop t2000*
}

cd $output
cap erase table6_longdiff.txt
foreach outcome in marbr18_34 nmarbr18_34 fallnevmar18_34 fallmarried18_34  falldiv18_34 fallcohab18_34 {
	reghdfe ldiff_`outcome' newsimtot00_11 ldiffcont_* [aw = totb2000] if year==2011, absorb(stfips) vce(robust)
	qui sum y2000`outcome' [aw = totb2000] if e(sample) == 1
	outreg2 using table6_longdiff.txt, excel dec(3) nor2 keep(newsimtot00_11) addstat("Dependent Means in 2000 (in levels)", r(mean)) ctitle(`outcome')
}

//Check for statistical differences
dis "CHECK FOR STATISTICALLY SIGNIFICANT DIFFERENCES"
cd $data
use analysissamp_alldata, clear
keep if year>=2000
gen t = simnewvalue_capita if year>=2000 & year<=2011
bys stpuma: egen newsimtot00_11 = sum(t)
drop t 
keep if inlist(year,2000,2011)
foreach var in marbr18_34 nmarbr18_34 fallnevmar18_34 fallmarried18_34  falldiv18_34 fallcohab18_34 {
	gen t2000`var' = ihs`var' if year == 2000
	bys stpuma: egen y2000ihs`var' = max(t2000`var')
	gen ldiff_ihs`var' = ihs`var'-y2000ihs`var'
	drop t2000*
}
foreach var in marbr18_34 nmarbr18_34 fallnevmar18_34 fallmarried18_34  falldiv18_34 fallcohab18_34 {
	gen t2000`var' = `var' if year == 2000
	bys stpuma: egen y2000`var' = max(t2000`var')
	gen ldiff_`var' = `var' - y2000`var'
	drop t2000*
}
foreach var of varlist $popcontrols18_34 {
	gen t2000`var' = `var' if year == 2000
	bys stpuma: egen y2000`var' = max(t2000`var')
	gen ldiffcont_`var' = `var' - y2000`var'
	drop t2000*
}
gen ldiff_allbr18_34m1 = ldiff_marbr18_34
gen ldiff_allbr18_34m0 = ldiff_nmarbr18_34
reshape long ldiff_allbr18_34m, i(stpuma year) j(marrate)
foreach var of varlist newsimtot00_11 ldiffcont_*  {
	gen mar_`var' = marrate*`var'
}
egen st_mar = group(stfips marrate)
reghdfe ldiff_allbr18_34m mar_* newsimtot00_11 ldiffcont_* [aw = totb2000] if year==2011, absorb(st_mar) vce(robust)


log close

/**************************
Table 7. Reduced Form Effects for Non-College and College Educated Women Separately
**************************/
cd $output
cap log close
log using table7_byeduclog.log, replace
cd $data
use analysissamp_alldata, clear

xtset stpuma year

cd $output
cap erase table7_rfbyeduc.txt
//Wieght by births to 18-34 yr olds in 2000
foreach outcome in marbr18_34 nmarbr18_34 fallnevmar18_34 fallmarried18_34  fallmarthisyr18_34 falldiv18_34 fallcohab18_34  ///
	marlscollbr18_34 nmarlscollbr18_34 flscollnevmar18_34 flscollmarried18_34 flscollmarthisyr18_34 flscolldiv18_34 flscollcohab18_34 ///
	marcollbr18_34 nmarcollbr18_34 fcollnevmar18_34 fcollmarried18_34 fcollmarthisyr18_34 fcolldiv18_34 fcollcohab18_34  {
	reghdfe `outcome' simnewvalue_capita $popcontrols18_34 [aw = totb2000] if year<=2012 & noedstate == 0, absorb(stpuma st_yr) vce(cluster stpuma)
	qui sum `outcome' [aw = totb2000] if e(sample) == 1
	sleep 1000
	outreg2 using table7_rfbyeduc.txt, excel dec(2) nor2 keep(simnewvalue_capita) addstat("Dependent Means (in levels)", r(mean)) ctitle(`outcome')
}
	
//Statistical significance
cd $data
use analysissamp_alldata, clear

xtset stpuma year
gen allmarbr18_34m1 = marlscollbr18_34
gen allmarbr18_34m0 = marcollbr18_34
gen allnmarbr18_34m1 = nmarlscollbr18_34
gen allnmarbr18_34m0 = nmarcollbr18_34
reshape long allmarbr18_34m allnmarbr18_34m, i(stpuma year) j(lscoll)
foreach var of varlist simnewvalue_capita $popcontrols18_34 {
	gen lscoll_`var' = lscoll*`var'
}
egen stpuma_lc = group(stpuma lscoll)
egen st_yr_lc = group(st_yr lscoll)
reghdfe allmarbr18_34m lscoll_* simnewvalue_capita $popcontrols18_34 [aw = totb2000] if year<=2012 & noedstate == 0, absorb(stpuma_lc st_yr_lc) vce(cluster stpuma_lc)
reghdfe allnmarbr18_34m lscoll_* simnewvalue_capita $popcontrols18_34 [aw = totb2000] if year<=2012 & noedstate == 0, absorb(stpuma_lc st_yr_lc) vce(cluster stpuma_lc)

log close

/*******************************
Table 8. Comparison to the Appalachian Coal Boom Context
*******************************/
cd $output
cap log close
log using table8_blackcomparisonlog.log, replace
cd $data
use ff_pumablackcoalannualdata, clear
gen t = totb18_34 if year == 1970
bys stpuma: egen totb1970 = max(t)
drop t

reghdfe ihssharenmar18_34 fmsexratio18_34 r3m1834shareblack r3m1834shareother r3f1834shareblack r3f1834shareother (lnbeaearnpw2010 = lcoalvalue) [aw = totb1970], absorb(stpuma st_yr) vce(cluster stpuma)
gen esamp = e(sample) == 1
bys stpuma: egen maxesamp = max(esamp)
count if maxesamp == 1 & year == 1980
	
cd $output 
cap erase table8_blackcomparison.txt
foreach outcome in sharenmar18_34 marbr18_34 nmarbr18_34   {
	reghdfe ln`outcome' fmsexratio18_34 r3m1834shareblack r3m1834shareother r3f1834shareblack r3f1834shareother (lnbeaearnpw2010 = lcoalvalue) [aw = totb1970] if esamp == 1, absorb(stpuma st_yr) vce(cluster stpuma)
	qui sum `outcome' [aw = totb1970] if e(sample) == 1
	local mean = r(mean)
	sleep 500
	outreg2 using table8_blackcomparison.txt,  excel dec(2) nor2 keep(lnbeaearnpw2010) addstat("Dependent Mean", `mean') ctitle("Earnigs PC,`outcome'")
}
foreach outcome in fsharenevmar1534 {
	reghdfe ln`outcome' fmsexratio18_34 r3m1834shareblack r3m1834shareother r3f1834shareblack r3f1834shareother (lnbeaearnpw2010 = lcoalvalue) [aw = totb1970] , absorb(stpuma st_yr) vce(cluster stpuma)
	qui sum `outcome' [aw = totb1970] if e(sample) == 1
	local mean = r(mean)
	gen sharesamp = e(sample) == 1
	sleep 500
	outreg2 using table8_blackcomparison.txt,  excel dec(2) nor2 keep(lnbeaearnpw2010) addstat("Dependent Mean", `mean') ctitle("Earnings PC,`outcome'")
}
//First Stage F-stats
reghdfe lnbeaearnpw2010 lcoalvalue fmsexratio18_34 r3m1834shareblack r3m1834shareother r3f1834shareblack r3f1834shareother  if esamp == 1, absorb(stpuma st_yr) vce(cluster stpuma)
testparm lcoalvalue

reghdfe lnbeaearnpw2010 lcoalvalue fmsexratio18_34 r3m1834shareblack r3m1834shareother r3f1834shareblack r3f1834shareother if sharesamp == 1, absorb(stpuma st_yr) vce(cluster stpuma)
testparm lcoalvalue


cd $data
use analysissamp_alldata, clear
gen fmsexratio18_34 = r3fpop1834/r3mpop1834
drop if year==2013

	reghdfe ihssharenmar18_34 fmsexratio18_34 lnhpi r3m1834shareblack r3m1834shareother r3f1834shareblack r3f1834shareother (ihsbeaearnpw2010 = simnewvalue_capita ) [aw = totb2000]  if year<=2012 & bakkpuma == 0, absorb(stpuma st_yr) vce(cluster stpuma)
	
	gen regsamp = e(sample) == 1
	bys stpuma: egen maxregsamp = max(regsamp)
	tab maxregsamp if year == 2000
		
cd $output
foreach outcome in sharenmar18_34 marbr18_34 nmarbr18_34  {
	reghdfe ln`outcome' fmsexratio18_34 lnhpi r3m1834shareblack r3m1834shareother r3f1834shareblack r3f1834shareother (lnbeaearnpw2010 = simnewvalue_capita) [aw = totb2000] if year<=2012 & bakkpuma == 0, absorb(stpuma st_yr) vce(cluster stpuma)
	qui sum `outcome' [aw = totb2000] if e(sample) == 1
	local mean = r(mean)
	sleep 500
	outreg2 using table8_blackcomparison.txt,  excel dec(2) nor2 keep(lnbeaearnpw2010) addstat("Dependent Mean", `mean')ctitle("Earnings PC, `outcome'")
}
foreach outcome in fsharenevmar1534 {
	reghdfe ln`outcome' fmsexratio18_34 lnhpi r3m1834shareblack r3m1834shareother r3f1834shareblack r3f1834shareother (lnbeaearnpw2010 = simnewvalue_capita) [aw = totb2000]  if bakkpuma == 0, absorb(stpuma st_yr) vce(cluster stpuma)
	qui sum `outcome' [aw = totb2000] if e(sample) == 1
	local mean = r(mean)
	gen sharesamp = e(sample) == 1
	sleep 500
	outreg2 using table8_blackcomparison.txt,  excel dec(2) nor2 keep(lnbeaearnpw2010) addstat("Dependent Mean", `mean')ctitle("Earnings PC, `outcome'")
}	
	
//First Stage F-statistics
reghdfe lnbeaearnpw2010 simnewvalue_capita fmsexratio18_34 lnhpi r3m1834shareblack r3m1834shareother r3f1834shareblack r3f1834shareother if year<=2012 & bakkpuma == 0 [aw = totb2000], absorb(stpuma st_yr) vce(cluster stpuma)
testparm simnewvalue_capita

reghdfe lnbeaearnpw2010 simnewvalue_capita fmsexratio18_34 lnhpi r3m1834shareblack r3m1834shareother r3f1834shareblack r3f1834shareother  if sharesamp == 1 & bakkpuma == 0 [aw = totb2000], absorb(stpuma st_yr) vce(cluster stpuma)
testparm simnewvalue_capita


//NOW report what the values would be if we look solely at counties in Appalachia
cd $data
use analysissamp_alldata, clear
gen fmsexratio18_34 = r3fpop1834/r3mpop1834
gen lnr3fpop1834 = ln(r3fpop1834) 
drop if year==2013
keep if inlist(stfips,21,42,54)
	reghdfe ihssharenmar18_34 fmsexratio18_34 r3m1834shareblack r3m1834shareother r3f1834shareblack r3f1834shareother (lnbeaearnpw2010 = simnewvalue_capita) [aw = totb2000] if year<=2012 & bakkpuma == 0, absorb(stpuma st_yr) vce(cluster stpuma)
	
	gen regsamp = e(sample) == 1
	bys stpuma: egen maxregsamp = max(regsamp)
	tab maxregsamp if year == 2000
cd $output
cap erase table_coalfrack_app.txt
foreach outcome in sharenmar18_34 marbr18_34 nmarbr18_34  {
	reghdfe ihs`outcome' fmsexratio18_34 r3m1834shareblack r3m1834shareother r3f1834shareblack r3f1834shareother (lnbeaearnpw2010 = simnewvalue_capita) [aw = totb2000]  if year<=2012 & bakkpuma == 0, absorb(stpuma st_yr) vce(cluster stpuma)
	qui sum `outcome' if e(sample) == 1
	local mean = r(mean)
	sleep 500
	outreg2 using table_coalfrack_app.txt,  excel dec(2) nor2 keep(lnbeaearnpw2010) addstat("Dependent Mean", `mean')ctitle("Earnings PC, `outcome'")
}
foreach outcome in fsharenevmar1534 {
	reghdfe ihs`outcome' fmsexratio18_34 r3m1834shareblack r3m1834shareother r3f1834shareblack r3f1834shareother (lnbeaearnpw2010 = simnewvalue_capita) [aw = totb2000]  if bakkpuma == 0, absorb(stpuma st_yr) vce(cluster stpuma)
	qui sum `outcome' if e(sample) == 1
	local mean = r(mean)
	sleep 500
	outreg2 using table_coalfrack_app.txt,  excel dec(2) nor2 keep(lnbeaearnpw2010) addstat("Dependent Mean", `mean')ctitle("Earnings PC, `outcome'")
}

log close


/*****************************
Figure 1. Total Oil and Gas Production from Wells During First Year Production, 2000-2012
*****************************/

cd $data
use cty_totnewprod00_12, clear

gen group = 0
replace group = 1 if newtot00_12 >0 & newtot00_12<=.1
replace group = 2 if newtot00_12 >.1 & newtot00_12<=1
replace group = 3 if newtot00_12 >1 & newtot00_12 <=10
replace group = 4 if newtot00_12 >10 & newtot00_12 <=100
replace group = 5 if newtot00_12 >100 & newtot00_12 ~= .
cd $data
cd shapefiles
merge 1:m ctyfips using ctyborder
drop if _m ==2 //borders
cd $data
cd shapefiles
spmap group using countycoord.dta if ~inlist(STATEFP, "02","15"), id(_ID) ///
	line(data(shalepcoord.dta) size(medthick)) ///
	clmethod(custom) clbreaks(-1 0 1 2 3 4 5) fcolor(white navy*.3 navy*.6 navy*.9 navy*1.2 navy*1.5) ///
	ocolor(gray*.6 navy*.6 navy*.9 navy*1.2 navy*1.5 navy*2) legend(size(*1.4) label(2 "No New Production") label(3 "<$100 p.c.") ///
	label(4 "$100-1K") label(5 "$1K-10K") label(6 "$10K-100K") label(7 "Over $100K p.c.")) ///
	title("New Production from 2000-2012 by County", size(medlarge))

cd $output 
graph save cty_newactprodtreatment, replace
graph export cty_newactprodtreatment.png, replace

///////////////////////////////////////
/*************************************

APPENDIX TABLES AND FIGURES

**************************************/
///////////////////////////////////////

/******************************
Table A1. Summary Statistics for Fracking Public Use Microdata Areas (PUMA)
******************************/
cd $data
use analysissamp_alldata, clear
replace simnewvalue_capita = simnewvalue_capita*1000
cd $output
cap file close sumstat
file open sumstat using tablea2_fracksumstat.txt, write replace
file write sumstat _tab "Year" _n
file write sumstat _tab "2004" _tab "2005" _tab "2006" _tab "2007" _tab "2008" _tab "2009" _tab "2010" _tab "2011" _tab "2012" _n
file write sumstat "# PUMA with Simulated New Production" 
forval yr = 2004/2012 {
	count if simnewvalue_capita >0 & year == `yr'
	file write sumstat _tab %7.0f (r(N))
}
file write sumstat _n
file write sumstat _tab "Simulated New Production Value by Percentile (2010$ per Capita)" _n
file write sumstat "10th"
forval yr = 2004/2012 {
	qui sum simnewvalue_capita if simnewvalue_capita >0 & year == `yr' , de
	file write sumstat _tab %7.2f (r(p10))
}
file write sumstat _n
file write sumstat "50th"
forval yr = 2004/2012 {
	qui sum simnewvalue_capita if simnewvalue_capita >0 & year == `yr', de
	file write sumstat _tab %7.2f (r(p50))
}
file write sumstat _n
file write sumstat "90th"
forval yr = 2004/2012 {
	qui sum simnewvalue_capita if simnewvalue_capita >0 & year == `yr', de
	file write sumstat _tab %7.2f (r(p90))
}

file write sumstat _n _n
file write sumstat "Mean"
forval yr = 2004/2012 {
	qui sum simnewvalue_capita if simnewvalue_capita >0 & year == `yr', de
	file write sumstat _tab %7.2f (r(mean))
}
file write sumstat _n
file write sumstat "Mean Among Top 10%"
forval yr = 2004/2012 {
	qui sum simnewvalue_capita if simnewvalue_capita >0 & year == `yr', de
	qui sum simnewvalue_capita if simnewvalue_capita >0 & year == `yr' & simnewvalue_capita>r(p90), de
	file write sumstat _tab %7.2f (r(mean))
}
file write sumstat _n
file close sumstat

/*******************
//SAME TABLE, BUT ACTUAL NEW PRODUCTION RATHER THAN SIMULATED NEW PRODUCTION

cd $data
use analysissamp_alldata, clear
replace newvalue2010_capita = newvalue2010_capita*1000
cd $output
cap file close sumstat
file open sumstat using tablea2_actfracksumstat.txt, write replace
file write sumstat _tab "Year" _n
file write sumstat _tab "2004" _tab "2005" _tab "2006" _tab "2007" _tab "2008" _tab "2009" _tab "2010" _tab "2011" _tab "2012" _n
file write sumstat "# PUMA with Simulated New Production" 
forval yr = 2004/2012 {
	count if newvalue2010_capita >0 & year == `yr'
	file write sumstat _tab %7.0f (r(N))
}
file write sumstat _n
file write sumstat _tab "Simulated New Production Value by Percentile (2010$ per Capita)" _n
file write sumstat "10th"
forval yr = 2004/2012 {
	qui sum newvalue2010_capita if newvalue2010_capita >0 & year == `yr' , de
	file write sumstat _tab %7.2f (r(p10))
}
file write sumstat _n
file write sumstat "50th"
forval yr = 2004/2012 {
	qui sum newvalue2010_capita if newvalue2010_capita >0 & year == `yr', de
	file write sumstat _tab %7.2f (r(p50))
}
file write sumstat _n
file write sumstat "90th"
forval yr = 2004/2012 {
	qui sum newvalue2010_capita if newvalue2010_capita >0 & year == `yr', de
	file write sumstat _tab %7.2f (r(p90))
}
file write sumstat _n
file write sumstat "Mean"
forval yr = 2004/2012 {
	qui sum newvalue2010_capita if newvalue2010_capita >0 & year == `yr', de
	file write sumstat _tab %7.2f (r(mean))
}
file write sumstat _n
file write sumstat "Mean Among Top 10%"
forval yr = 2004/2012 {
	qui sum newvalue2010_capita if newvalue2010_capita >0 & year == `yr', de
	qui sum newvalue2010_capita if newvalue2010_capita >0 & year == `yr' & newvalue2010_capita>r(p90), de
	file write sumstat _tab %7.2f (r(mean))
}
file write sumstat _n
file close sumstat
*/

/*******************************
Table A2. Robustness and Specification Sensitivity, Women Age 18 to 34
*******************************/
cd $output
cap log close
log using tablea2_robustlog.log, replace
cd $data
use analysissamp_alldata, clear

egen play_yr = group(inp_* year)

cd $output
cap erase tablea2_robust.txt
foreach outcome in marbr18_34 nmarbr18_34 {
//Baseline
	reghdfe `outcome' simnewvalue_capita  $popcontrols18_34 [aw = totb2000] if year<=2012, absorb(stpuma st_yr) vce(cluster stpuma)
	qui sum `outcome' [aw = totb2000] if e(sample) == 1
	outreg2 using tablea2_robust.txt, excel dec(3) nor2 keep(simnewvalue_capita) addstat("Dependent Means (in levels)", r(mean)) ctitle("Baseline, `outcome'")
//Remove Sex Ratio and House Price Controls
	reghdfe `outcome' simnewvalue_capita m1834sharenhblack m1834sharehisp m1834sharenhother f1834sharenhblack f1834sharehisp f1834sharenhother f1834_sharelshs f1834_sharescoll f1834_sharecoll m1834_sharelshs m1834_sharescoll m1834_sharecoll [aw = totb2000] if year<=2012, absorb(stpuma st_yr) vce(cluster stpuma)
	qui sum `outcome' [aw = totb2000] if e(sample) == 1
	outreg2 using tablea2_robust.txt, excel dec(3) nor2 keep(simnewvalue_capita) addstat("Dependent Means (in levels)", r(mean)) ctitle("Role of sex ratio and house price, `outcome'")
//Do not weight
	reghdfe `outcome' simnewvalue_capita  $popcontrols18_34 if year<=2012, absorb(stpuma st_yr) vce(cluster stpuma)
	qui sum `outcome' [aw = totb2000] if e(sample) == 1
	outreg2 using tablea2_robust.txt, excel dec(3) nor2 keep(simnewvalue_capita) addstat("Dependent Means (in levels)", r(mean)) ctitle("No Weights, `outcome'")
//Year Effects
	reghdfe `outcome' simnewvalue_capita  $popcontrols18_34 [aw = totb2000] if year<=2012, absorb(stpuma year) vce(cluster stpuma)
	qui sum `outcome' [aw = totb2000] if e(sample) == 1
	outreg2 using tablea2_robust.txt, excel dec(3) nor2 keep(simnewvalue_capita) addstat("Dependent Means (in levels)", r(mean)) ctitle("Year FE, `outcome'")

//Play by Year Effects
	reghdfe `outcome' simnewvalue_capita  $popcontrols18_34 [aw = totb2000] if year<=2012, absorb(stpuma play_yr) vce(cluster stpuma) keepsingletons
	qui sum `outcome' [aw = totb2000] if e(sample) == 1
	outreg2 using tablea2_robust.txt, excel dec(3) nor2 keep(simnewvalue_capita) addstat("Dependent Means (in levels)", r(mean)) ctitle("Play by Year, `outcome'")

//Natural Log of Outcome
	reghdfe ln`outcome' simnewvalue_capita  $popcontrols18_34 [aw = totb2000] if year<=2012, absorb(stpuma st_yr) vce(cluster stpuma)
	qui sum `outcome' [aw = totb2000] if e(sample) == 1
	outreg2 using tablea2_robust.txt, excel dec(3) nor2 keep(simnewvalue_capita) addstat("Dependent Means (in levels)", r(mean)) ctitle("Ln, `outcome'")
}

log close

/***************************************
Table A3. Heterogeneity by Demographics, Women age 18 to 34 (Unless Otherwise Specified)
***************************************/
cd $data
use analysissamp_alldata, clear
xtset stpuma year
	
cd $output
cap erase tablea3_groupheterogeneity.txt
//Wieght by births to 18-34 yr olds in 2000
foreach outcome in 35_44 nhwhite18_34 nhblack18_34 hisp18_34 nhother18_34 {
	reghdfe marbr`outcome' simnewvalue_capita $popcontrols18_34 [aw = totb2000] if year<=2012, absorb(stpuma st_yr) vce(cluster stpuma)
	qui sum marb`outcome' [aw = totb2000] if e(sample) == 1
	local lmean = r(mean)
	qui sum marbr`outcome' [aw = totb2000] if e(sample) == 1
	outreg2 using tablea3_groupheterogeneity.txt, excel dec(2) nor2 keep(simnewvalue_capita) addstat("Number of Births", `lmean', "Dependent Means (in levels)", r(mean)) ctitle(`outcome')
}
foreach outcome in marfb marnfb {
	reghdfe `outcome'r18_34 simnewvalue_capita $popcontrols18_34 [aw = totb2000] if year<=2012, absorb(stpuma st_yr) vce(cluster stpuma)
	qui sum `outcome'18_34 [aw = totb2000] if e(sample) == 1
	local lmean = r(mean)
	qui sum `outcome'r18_34 [aw = totb2000] if e(sample) == 1
	outreg2 using tablea3_groupheterogeneity.txt, excel dec(2) nor2 keep(simnewvalue_capita) addstat("Number of Births", `lmean', "Dependent Means (in levels)", r(mean)) ctitle(`outcome')
}
foreach outcome in 35_44 nhwhite18_34 nhblack18_34 hisp18_34 nhother18_34 {
	reghdfe nmarbr`outcome' simnewvalue_capita $popcontrols18_34 [aw = totb2000] if year<=2012, absorb(stpuma st_yr) vce(cluster stpuma)
	qui sum nmarb`outcome' [aw = totb2000] if e(sample) == 1
	local lmean = r(mean)
	qui sum nmarbr`outcome' [aw = totb2000] if e(sample) == 1
	outreg2 using tablea3_groupheterogeneity.txt, excel dec(2) nor2 keep(simnewvalue_capita) addstat("Number of Births", `lmean', "Dependent Means (in levels)", r(mean)) ctitle(`outcome')
}
foreach outcome in nmarfb nmarnfb {
	reghdfe `outcome'r18_34 simnewvalue_capita $popcontrols18_34 [aw = totb2000] if year<=2012, absorb(stpuma st_yr) vce(cluster stpuma)
	qui sum `outcome'18_34 [aw = totb2000] if e(sample) == 1
	local lmean = r(mean)
	qui sum `outcome'r18_34 [aw = totb2000] if e(sample) == 1
	outreg2 using tablea3_groupheterogeneity.txt, excel dec(2) nor2 keep(simnewvalue_capita) addstat("Number of Births", `lmean', "Dependent Means (in levels)", r(mean)) ctitle(`outcome')
}

/*******************************
Table A4. Reduced Form Impact of Actual New Production on Birth and Marriage Outcomes for Non-College Women Age 18 to 34
*******************************/
cd $output
cap log close 
log using tablea4_actualprodlog.log, replace
cd $data
use analysissamp_alldata, clear

xtset stpuma year

cd $output
cap erase tablea4_actualprod.txt
//Wieght by births to 18-34 yr olds in 2000
foreach outcome in marbr18_34 nmarbr18_34 fallnevmar18_34 fallmarried18_34 fallmarthisyr18_34 falldiv18_34  fallcohab18_34  {
	reghdfe `outcome' $popcontrols18_34 newvalue2010_capita [aw = totb2000] if year<=2012, absorb(stpuma st_yr) vce(cluster stpuma)
	qui sum `outcome' [aw = totb2000] if e(sample) == 1
	outreg2 using tablea4_actualprod.txt, excel dec(3) nor2 keep(newvalue2010_capita) addstat("Dependent Means (in levels)", r(mean)) ctitle(`outcome')
}


reghdfe newvalue2010_capita simnewvalue_capita $popcontrols18_34 [aw = totb2000] if year<=2012, absorb(stpuma st_yr) vce(cluster stpuma)
	
//Check for statistical differences
dis "CHECK FOR STATISTICALLY SIGNIFICANT DIFFERENCES"
cd $data
use analysissamp_alldata, clear
gen allbr18_34m1 = marbr18_34
gen allbr18_34m0 = nmarbr18_34
reshape long allbr18_34m, i(stpuma year) j(marrate)
foreach var of varlist newvalue2010_capita $popcontrols18_34 {
	gen mar_`var' = marrate*`var'
}
egen stpuma_mar = group(stpuma marrate)
egen st_yr_mar = group(st_yr marrate)
reghdfe allbr18_34m mar_* newvalue2010_capita $popcontrols18_34 [aw = totb2000] if year<=2012, absorb(stpuma_mar st_yr_mar) vce(cluster stpuma_mar)
	

log close

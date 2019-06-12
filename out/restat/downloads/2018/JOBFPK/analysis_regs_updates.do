clear all
set more off
set matsize 11000
set maxvar 25000


**Aaron Flaaen
**July 25, 2013
**Last Updated: August 5, 2017
**This File Conducts Analysis Surrounding 2011 March Tohoku Event
**-------------------------------------------------------------------------

cd $dir

**------------------------------------------------------------------------
**Step 1: Prep Data
**--------------------------------------------------------------------------
/*
*use analysisdata_manuf.dta, clear
!gunzip analysisdata_manufU.dta.gz
use analysisdata_manufU.dta, clear
!gzip analysisdata_manufU.dta
replace jexp = 0 if jexp==.

**1.1 Ensure that the multinational flags are consistent
bys firmid: egen maxflagfor = max(flag_for_mult)
by firmid: egen maxflagus = max(flag_us_mult)
by firmid: egen maxflagjpn = max(japan)

replace flag_for_mult = maxflagfor
replace flag_us_mult = maxflagus
replace japan = maxflagjpn
drop maxflagjpn maxflagus maxflagfor



**1.2 Bring in USGS information
*sort firmid
*merge firmid using usgs_add.dta
*tab _m
*drop if _m==2
*drop _m

**Port Information
*sort firmid
*merge firmid using jpn_ports_indicator.dta
*tab _m
*drop if _m==2
*drop _m

**1.3 Restrict to Relevant Sample: Only Other Multinationals
replace flag_for_mult = 1 if japan==1
drop if flag_for_mult==0 & flag_us_mult==0 


**1.4 Create Relevant Variables for Analysis 

**Create GIS-based indicators
*replace mmimaxind = 0 if mmimaxind==.
*replace mmimax = 0 if mmimax==.

*gen geoeffect = 0
*replace geoeffect = 1 if mmimaxind>6

*gen geoeffect2 = 0
*replace geoeffect2 = 1 if mmimax>6

*replace ratioport = 0 if ratioport==.
*gen ports1 = 0
*replace ports1 = 1 if ratioport>0.10

*gen ports2 = 0
*replace ports2=1 if ratioport>0.20

*gen ports3 = 0
*replace ports3=1 if ratioport>0.3

**Calculate Exposure to Japanese Imports in Year 2010
bys firmid year: egen annjimp_int = sum(jimp_int)
bys firmid year: egen annnjimp_int = sum(njimp_int)
gen exposure_2010 =  annjimp_int/((pay*1000)+ annjimp_int+annnjimp_int) if year==2010

**Ensure that we have one value of exposure per firm
bys firmid: egen expmin = min(exposure_2010)
drop exposure_2010
rename expmin exposure_2010

**Make sure each firm has all observations
bys firmid: gen dup = _N
*drop if dup<xx

**Generate Categorical Exposure variable
gen exposed = 0
replace exposed = 1 if exposure_2010>0.05


***Create the Kernel Density Picture
kdensity exposure_2010 if japan==1, n(100) gen(jpn_x jpn_d)

kdensity exposure_2010 if japan==0 & (flag_us_mult==1 | flag_for_mult==1), n(XXX) gen(njpn_x njpn_d)
keep jpn_x jpn_d njpn_x njpn_d
duplicates drop
twoway line njpn_d njpn_x || line jpn_d jpn_x

*************************************************************




**Calculate Total Intermediate Input Imports
gen imp_int = njimp_int + jimp_int

**Three digit industry
gen naics3 = substr(naics_code,1,3)
egen numnaics = group(naics3)

gen lexposure_2010 = log(exposure_2010)

*gen lfirmid = length(firmid)
*replace firmid = firmid + "0000" if lfirmid==6
*drop lfirmid



**--------------------------------------------------------------------------
**Step 2: Remove Linear Trend
**--------------------------------------------------------------------------

**Generate Monthvar, and Time-Set the Data
gen monthvar = xxx
forvalues i = 2(1)12 {
	replace monthvar = xxx + `i' - 1 if month==`i' & year==2009
}
forvalues i = 1(1)12 {
	replace monthvar = xxx + `i' - 1 if month==`i' & year==2010
}
	
forvalues i = 1(1)12 {
	replace monthvar = xxx + `i' - 1 if month==`i' & year==2011
}
forvalues i = 1(1)12 {
	replace monthvar = xxx + `i' - 1 if month==`i' & year==2012
}


egen numfirm = group(firmid)
tsset numfirm monthvar, monthly

**Remove Unit-Specific Trend for some variables
foreach var of varlist naexp jimp_int njimp_int imp_int jexp {

	qui xi: reg `var' c.monthvar##i.numfirm if monthvar<XXX & numfirm<XXX
	qui predict `var'_pred if numfirm<XXX
	replace `var'_pred = . if numfirm>=XXX

	qui sum numfirm
	local ubound = floor(`r(max)'/1000)*10

	forvalues j = 5(5)`ubound' {
		local i = `j'*100
		local k = (`j'+5)*100
		di "`i'"
	
		qui xi: reg `var' c.monthvar##i.numfirm if monthvar<xxx & numfirm>=`i' & numfirm<`k'
		qui predict `var'_`j'_pred if numfirm>=`i' & numfirm<`k'
		replace `var'_`j'_pred = . if numfirm<`i' & numfirm>=`k'
		replace `var'_pred = `var'_`j'_pred if `var'_pred==.
		drop `var'_`j'_pred
	}

	gen `var'_resid = `var' - `var'_pred
}

**Removing Linear Trend: Seems to screw up values that are always zero
bys firmid: egen maximp_int = max(imp_int)
replace imp_int_resid = 0 if maximp_int==0
bys firmid: egen maxjimp_int = max(jimp_int)
replace jimp_int_resid = 0 if maxjimp_int==0
bys firmid: egen maxnjimp_int = max(njimp_int)
replace njimp_int_resid = 0 if maxnjimp_int==0
bys firmid: egen maxnaexp = max(naexp)
replace naexp_resid = 0 if maxnaexp==0
bys firmid: egen maxjexp = max(jexp)
replace jexp_resid = 0 if maxjexp==0
drop maximp_int maxnaexp maxnjimp_int maxjexp



*save analysis_manuf_temp.dta, replace
save analysis_manuf_tempU.dta, replace


use analysis_manuf_tempU.dta, clear



**--------------------------------------------------------------------------
**Step 5: Full Sample in Levels
**--------------------------------------------------------------------------
*use analysis_manuf_temp.dta, clear
use analysis_manuf_tempU.dta, clear


**Step 5.1 Make sure we have the right sample

**Drop if no Japanese affiliates in 3-digit industry (??????)
bys naics3: egen maxjapan = max(japan)
drop if maxjapan==0
drop maxjapan


drop numfirm
egen numfirm = group(firmid)
tsset numfirm monthvar, monthly

**Make sure each firm has all observations (Can't do this now)
drop dup
bys firmid: gen dup = _N
**drop if dup<XX


**Step 5.2 Do the Re-weighting
gen presample = 0
replace presample = 1 if monthvar==xxx | monthvar==xxx | monthvar==xxx
bys firmid presample: egen presamp_naexp = mean(naexp)
bys firmid presample: egen presamp_imp = mean(imp_int)
bys firmid presample: egen presamp_njimp = mean(njimp_int)
replace presamp_imp = . if presample==0
replace presamp_naexp = . if presample==0
replace presamp_njimp = . if presample==0
bys firmid: egen presamp_naexp2 = min(presamp_naexp)
bys firmid: egen presamp_imp2 = min(presamp_imp)
bys firmid: egen presamp_njimp2 = min(presamp_njimp)
drop presamp_naexp
rename presamp_naexp2 presamp_naexp
drop presamp_imp
rename presamp_imp2 presamp_imp
drop presamp_njimp
rename presamp_njimp2 presamp_njimp

**Just using the probit
probit japan i.numnaics presamp_imp presamp_naexp
predict jpnhat

gen jpnhat3 = jpnhat / (1-jpnhat)
replace jpnhat3 = 1 if japan==1

**Create Industry Dummies
xi i.numnaics
rename _Inumnaics_3 numnaics_3
rename _Inumnaics_4 numnaics_4
//rename _Inumnaics_6 numnaics_6
forvalues i = 9(1)22 {
	rename _Inumnaics_`i' numnaics_`i'
}


/*
version 12.1
**Generate Test of Differences in Pre-sample characteristics
**Currently not sure how to output this information
pstest presamp_imp presamp_naexp presamp_njimp numnaics_*, treated(japan) mweight(jpnhat3)
*/
/*
matrix PRESHOCK = J(2,2,1)
matrix PRESHOCK_SUPPORT = J(2,5,1)
preserve

** JPN Multinationals **************
keep if japan==1 & presample==1
esum njimp_int, sType("mean") firmident("firmid") tvsident("njimp_int")
matrix temp = r(sumout)
matrix temp2 = r(sumout2)
matrix PRESHOCK[1,1] = temp[1,3]
matrix PRESHOCK_SUPPORT[1,4] = temp2[1,1]
matrix PRESHOCK_SUPPORT[1,1] = temp[1,5]

esum jexp, sType("mean") firmident("firmid") tvsident("jexp")
matrix temp = r(sumout)
matrix temp2 = r(sumout2)
matrix PRESHOCK[2,1] = temp[1,3]
matrix PRESHOCK_SUPPORT[2,4] = temp2[1,1]
matrix PRESHOCK_SUPPORT[2,1] = temp[1,5]

restore
preserve
** Non-JPN Multinationals **************
keep if japan==0 & presample==1

sum njimp_int [aweight=jpnhat3]
matrix PRESHOCK[1,2] = r(mean)

esum njimp_int, sType("mean") firmident("firmid") tvsident("njimp_int")
matrix temp = r(sumout)
matrix temp2 = r(sumout2)
matrix PRESHOCK_SUPPORT[1,5] = temp2[1,1]
matrix PRESHOCK_SUPPORT[1,2] = temp[1,5]

sum jexp [aweight=jpnhat3]
matrix PRESHOCK[2,2] = r(mean)

esum jexp, sType("mean") firmident("firmid") tvsident("jexp")
matrix temp = r(sumout)
matrix temp2 = r(sumout2)
matrix PRESHOCK_SUPPORT[2,5] = temp2[1,1]
matrix PRESHOCK_SUPPORT[2,2] = temp[1,5]


restore
*/
** JPN Multinationals **************

sum naexp  if japan==1 & presample==1
sum imp_int  if japan==1 & presample==1
sum jexp if japan==1 & presample==1
sum njimp_int if japan==1 & presample==1


** Non-JPN Multinationals **************
sum naexp  if japan==0 & presample==1
sum imp_int  if japan==0 & presample==1
sum jexp if japan==0 & presample==1
sum njimp_int if japan==0 & presample==1

**Step 5.3 Run the Regressions

**Create Indicator Variables for Regressions
xi i.monthvar*i.japan
forvalues j = xxx(1)xxx {
	rename _Imonthvar_`j' monthvar_`j'
	rename _ImonXjap_`j'_1 monXjap_`j'
}

tsset numfirm monthvar, monthly
gen naexp_dhs = 2*(naexp-l.naexp)/(naexp+l.naexp)
gen naexp_resid_dhs = 2*(naexp_resid-l.naexp_resid)/(naexp_resid+l.naexp_resid)
gen imp_int_dhs = 2*(imp_int-l.imp_int)/(imp_int+l.imp_int)
gen imp_int_resid_dhs = 2*(imp_int_resid-l.imp_int_resid)/(imp_int_resid+l.imp_int_resid)

/*
capture erase ../Tables/regs_base_update.txt  

**Not Re-weighting (Through 2011)
areg imp_int_resid monthvar_595-monthvar_623 monXjap_595-monXjap_623 if monthvar<xxx, absorb(numfirm) vce(cluster numfirm)
outreg2 using ../Tables/regs_base_update.txt, noparen noaster addtext(Fixed Effects, Firm, Clustering, Firm, Sample, Mult-2009-2011)
areg jimp_int_resid monthvar_595-monthvar_623 monXjap_595-monXjap_623 if monthvar<xxx, absorb(numfirm) vce(cluster numfirm)
outreg2 using ../Tables/regs_base_update.txt, noparen noaster addtext(Fixed Effects, Firm, Clustering, Firm, Sample, Mult-2009-2011)
areg naexp_resid monthvar_595-monthvar_623 monXjap_595-monXjap_623 if monthvar<xxx, absorb(numfirm) vce(cluster numfirm)
outreg2 using ../Tables/regs_base_update.txt, noparen noaster addtext(Fixed Effects, Firm, Clustering, Firm, Sample, Mult-2009-2011)
areg njimp_int_resid monthvar_595-monthvar_623 monXjap_595-monXjap_623 if monthvar<xxx, absorb(numfirm) vce(cluster numfirm)
outreg2 using ../Tables/regs_base_update.txt, noparen noaster addtext(Fixed Effects, Firm, Clustering, Firm, Sample, Mult-2009-2011)
areg jexp_resid monthvar_595-monthvar_623 monXjap_595-monXjap_623 if monthvar<xxx absorb(numfirm) vce(cluster numfirm)
outreg2 using ../Tables/regs_base_update.txt, noparen noaster addtext(Fixed Effects, Firm, Clustering, Firm, Sample, Mult-2009-2011)

**Reweighting (Through 2011)
areg imp_int_resid monthvar_595-monthvar_623 monXjap_595-monXjap_623 if monthvar<xxx [aweight=jpnhat3], absorb(numfirm) vce(cluster numfirm)
outreg2 using ../Tables/regs_base_update.txt, noparen noaster addtext(Fixed Effects, Firm, Clustering, Firm, Sample, Mult-reweight-2009-2011)
areg jimp_int_resid monthvar_595-monthvar_623 monXjap_595-monXjap_623 if monthvar<xxx [aweight=jpnhat3], absorb(numfirm) vce(cluster numfirm)
outreg2 using ../Tables/regs_base_update.txt, noparen noaster addtext(Fixed Effects, Firm, Clustering, Firm, Sample, Mult-reweight-2009-2011)
areg naexp_resid monthvar_595-monthvar_623 monXjap_595-monXjap_623 if monthvar<xxx [aweight=jpnhat3], absorb(numfirm) vce(cluster numfirm)
outreg2 using ../Tables/regs_base_update.txt, noparen noaster addtext(Fixed Effects, Firm, Clustering, Firm, Sample, Mult-reweight-2009-2011)
areg njimp_int_resid monthvar_595-monthvar_623 monXjap_595-monXjap_623 if monthvar<xxx [aweight=jpnhat3], absorb(numfirm) vce(cluster numfirm)
outreg2 using ../Tables/regs_base_update.txt, noparen noaster addtext(Fixed Effects, Firm, Clustering, Firm, Sample, Mult-reweight-2009-2011)
areg jexp_resid monthvar_595-monthvar_623 monXjap_595-monXjap_623 if monthvar<xxx [aweight=jpnhat3], absorb(numfirm) vce(cluster numfirm)
outreg2 using ../Tables/regs_base_update.txt, noparen noaster addtext(Fixed Effects, Firm, Clustering, Firm, Sample, Mult-reweight-2009-2011)


**Not Re-weighting (Through 2012)
areg imp_int_resid monthvar_595-monthvar_635 monXjap_595-monXjap_635, absorb(numfirm) vce(cluster numfirm)
outreg2 using ../Tables/regs_base_update.txt, noparen noaster addtext(Fixed Effects, Firm, Clustering, Firm, Sample, Mult-2009-2012)
areg jimp_int_resid monthvar_595-monthvar_635 monXjap_595-monXjap_635, absorb(numfirm) vce(cluster numfirm)
outreg2 using ../Tables/regs_base_update.txt, noparen noaster addtext(Fixed Effects, Firm, Clustering, Firm, Sample, Mult-2009-2012)
areg naexp_resid monthvar_595-monthvar_635 monXjap_595-monXjap_635, absorb(numfirm) vce(cluster numfirm)
outreg2 using ../Tables/regs_base_update.txt, noparen noaster addtext(Fixed Effects, Firm, Clustering, Firm, Sample, Mult-2009-2012)
areg njimp_int_resid monthvar_595-monthvar_635 monXjap_595-monXjap_635, absorb(numfirm) vce(cluster numfirm)
outreg2 using ../Tables/regs_base_update.txt, noparen noaster addtext(Fixed Effects, Firm, Clustering, Firm, Sample, Mult-2009-2012)
areg jexp_resid monthvar_595-monthvar_635 monXjap_595-monXjap_635, absorb(numfirm) vce(cluster numfirm)
outreg2 using ../Tables/regs_base_update.txt,  noparen noaster addtext(Fixed Effects, Firm, Clustering, Firm, Sample, Mult-2009-2012)

**Reweighting (Through 2012)
areg imp_int_resid monthvar_595-monthvar_635 monXjap_595-monXjap_635 [aweight=jpnhat3], absorb(numfirm) vce(cluster numfirm)
outreg2 using ../Tables/regs_base_update.txt, noparen noaster addtext(Fixed Effects, Firm, Clustering, Firm, Sample, Mult-reweight-2009-2012)
areg jimp_int_resid monthvar_595-monthvar_635 monXjap_595-monXjap_635 [aweight=jpnhat3], absorb(numfirm) vce(cluster numfirm)
outreg2 using ../Tables/regs_base_update.txt, noparen noaster addtext(Fixed Effects, Firm, Clustering, Firm, Sample, Mult-reweight-2009-2012)
areg naexp_resid monthvar_595-monthvar_635 monXjap_595-monXjap_635 [aweight=jpnhat3], absorb(numfirm) vce(cluster numfirm)
outreg2 using ../Tables/regs_base_update.txt, noparen noaster addtext(Fixed Effects, Firm, Clustering, Firm, Sample, Mult-reweight-2009-2012)
areg njimp_int_resid monthvar_595-monthvar_635 monXjap_595-monXjap_635 [aweight=jpnhat3], absorb(numfirm) vce(cluster numfirm)
outreg2 using ../Tables/regs_base_update.txt, noparen noaster addtext(Fixed Effects, Firm, Clustering, Firm, Sample, Mult-reweight-2009-2012)
areg jexp_resid monthvar_595-monthvar_635 monXjap_595-monXjap_635 [aweight=jpnhat3], absorb(numfirm) vce(cluster numfirm)
outreg2 using ../Tables/regs_base_update.txt, noparen noaster addtext(Fixed Effects, Firm, Clustering, Firm, Sample, Mult-reweight-2009-2012)


preserve
clear
import delimited /.txt
export excel using ".", sheet("T1_regs") sheetmodify firstrow(variables)
restore



*/

*****************************************************************
**Quarterly Versions of These Regressions
*****************************************************************
*/
*use analysis_manuf_temp.dta, clear
use analysis_manuf_tempU.dta, clear


**Step 5.1 Make sure we have the right sample

**Drop if no Japanese affiliates in 3-digit industry (??????)
bys naics3: egen maxjapan = max(japan)
drop if maxjapan==0
drop maxjapan


drop numfirm
egen numfirm = group(firmid)
tsset numfirm monthvar, monthly

**Make sure each firm has all observations (Can't do this now)
drop dup
bys firmid: gen dup = _N
**drop if dup<XX


**Step 5.2 Do the Re-weighting
gen presample = 0
replace presample = 1 if monthvar==xxx | monthvar==xxx | monthvar==xxx
bys firmid presample: egen presamp_naexp = mean(naexp)
bys firmid presample: egen presamp_imp = mean(imp_int)
bys firmid presample: egen presamp_njimp = mean(njimp_int)
replace presamp_imp = . if presample==0
replace presamp_naexp = . if presample==0
replace presamp_njimp = . if presample==0
bys firmid: egen presamp_naexp2 = min(presamp_naexp)
bys firmid: egen presamp_imp2 = min(presamp_imp)
bys firmid: egen presamp_njimp2 = min(presamp_njimp)
drop presamp_naexp
rename presamp_naexp2 presamp_naexp
drop presamp_imp
rename presamp_imp2 presamp_imp
drop presamp_njimp
rename presamp_njimp2 presamp_njimp

**Just using the probit
probit japan i.numnaics presamp_imp presamp_naexp
predict jpnhat

gen jpnhat3 = jpnhat / (1-jpnhat)
replace jpnhat3 = 1 if japan==1

**Create Industry Dummies
xi i.numnaics
rename _Inumnaics_3 numnaics_3
rename _Inumnaics_4 numnaics_4
//rename _Inumnaics_6 numnaics_6
forvalues i = 9(1)22 {
	rename _Inumnaics_`i' numnaics_`i'
}


/*
version 12.1
**Generate Test of Differences in Pre-sample characteristics
**Currently not sure how to output this information
pstest presamp_imp presamp_naexp presamp_njimp numnaics_*, treated(japan) mweight(jpnhat3)
*/
/*
matrix PRESHOCK = J(2,2,1)
matrix PRESHOCK_SUPPORT = J(2,5,1)
preserve

** JPN Multinationals **************
keep if japan==1 & presample==1
esum njimp_int, sType("mean") firmident("firmid") tvsident("njimp_int")
matrix temp = r(sumout)
matrix temp2 = r(sumout2)
matrix PRESHOCK[1,1] = temp[1,3]
matrix PRESHOCK_SUPPORT[1,4] = temp2[1,1]
matrix PRESHOCK_SUPPORT[1,1] = temp[1,5]

esum jexp, sType("mean") firmident("firmid") tvsident("jexp")
matrix temp = r(sumout)
matrix temp2 = r(sumout2)
matrix PRESHOCK[2,1] = temp[1,3]
matrix PRESHOCK_SUPPORT[2,4] = temp2[1,1]
matrix PRESHOCK_SUPPORT[2,1] = temp[1,5]

restore
preserve
** Non-JPN Multinationals **************
keep if japan==0 & presample==1

sum njimp_int [aweight=jpnhat3]
matrix PRESHOCK[1,2] = r(mean)

esum njimp_int, sType("mean") firmident("firmid") tvsident("njimp_int")
matrix temp = r(sumout)
matrix temp2 = r(sumout2)
matrix PRESHOCK_SUPPORT[1,5] = temp2[1,1]
matrix PRESHOCK_SUPPORT[1,2] = temp[1,5]

sum jexp [aweight=jpnhat3]
matrix PRESHOCK[2,2] = r(mean)

esum jexp, sType("mean") firmident("firmid") tvsident("jexp")
matrix temp = r(sumout)
matrix temp2 = r(sumout2)
matrix PRESHOCK_SUPPORT[2,5] = temp2[1,1]
matrix PRESHOCK_SUPPORT[2,2] = temp[1,5]


restore
*/
bys firmid presample: egen presamp_naexp_sum = sum(naexp)
bys firmid presample: egen presamp_imp_sum = sum(imp_int)
bys firmid presample: egen presamp_njimp_sum = sum(njimp_int)
** JPN Multinationals **************

sum presamp_naexp_sum  if japan==1 & presample==1
sum presamp_imp_sum  if japan==1 & presample==1
*sum jexp if japan==1 & presample==1
*sum njimp_int if japan==1 & presample==1


** Non-JPN Multinationals **************
sum presamp_naexp_sum  if japan==0 & presample==1
sum presamp_imp_sum  if japan==0 & presample==1
*sum jexp if japan==0 & presample==1
*sum njimp_int if japan==0 & presample==1






**Step 5.3 Run the Regressions
**Collapse by quarter
gen quarter =1
replace quarter = 2 if month==4 | month==5 | month==6
replace quarter = 3 if month==7 | month==8 | month==9
replace quarter = 4 if month==10 | month==11 | month==12

gen qtime = 196
replace qtime = 197 if quarter==2 & year==2009
replace qtime = 198 if quarter==3 & year==2009
replace qtime = 199 if quarter==4 & year==2009
replace qtime = 200 if quarter==1 & year==2010
replace qtime = 201 if quarter==2 & year==2010
replace qtime = 202 if quarter==3 & year==2010
replace qtime = 203 if quarter==4 & year==2010
replace qtime = 204 if quarter==1 & year==2011
replace qtime = 205 if quarter==2 & year==2011
replace qtime = 206 if quarter==3 & year==2011
replace qtime = 207 if quarter==4 & year==2011
replace qtime = 208 if quarter==1 & year==2012
replace qtime = 209 if quarter==2 & year==2012
replace qtime = 210 if quarter==3 & year==2012
replace qtime = 211 if quarter==4 & year==2012

collapse (sum) naexp naexp_resid imp_int imp_int_resid jimp_int jimp_int_resid njimp_int njimp_int_resid (first) jpnhat3 ,by(firmid qtime japan numfirm)
tsset numfirm qtime, quarterly

xi i.qtime*i.japan
forvalues j = 197(1)211 {
	rename _Iqtime_`j' qtime_`j'
	rename _IqtiXjap_`j'_1 qtiXjap_`j'
}



cd ../Code/disclosure/output/

capture erase regs_qbase_update.txt  

**Not Re-weighting (Through 2011)
areg imp_int_resid qtime_197-qtime_207 qtiXjap_197-qtiXjap_207 if qtime<208, absorb(numfirm) vce(cluster numfirm)
outreg2 using ../Tables/regs_qbase_update.txt, noparen noaster addtext(Fixed Effects, Firm, Clustering, Firm, Sample, Mult-2009-2011)
areg jimp_int_resid qtime_197-qtime_207 qtiXjap_197-qtiXjap_207 if qtime<208, absorb(numfirm) vce(cluster numfirm)
outreg2 using ../Tables/regs_qbase_update.txt, noparen noaster addtext(Fixed Effects, Firm, Clustering, Firm, Sample, Mult-2009-2011)
areg naexp_resid qtime_197-qtime_207 qtiXjap_197-qtiXjap_207 if qtime<208, absorb(numfirm) vce(cluster numfirm)
outreg2 using ../Tables/regs_qbase_update.txt, noparen noaster addtext(Fixed Effects, Firm, Clustering, Firm, Sample, Mult-2009-2011)
areg njimp_int_resid qtime_197-qtime_207 qtiXjap_197-qtiXjap_207 if qtime<208, absorb(numfirm) vce(cluster numfirm)
outreg2 using ../Tables/regs_qbase_update.txt, noparen noaster addtext(Fixed Effects, Firm, Clustering, Firm, Sample, Mult-2009-2011)
*areg jexp_resid qtime_197-qtime_207 qtiXjap_197-qtiXjap_207 if qtime<208, absorb(numfirm) vce(cluster numfirm)
*outreg2 using ../Tables/regs_qbase_update.txt, noparen noaster addtext(Fixed Effects, Firm, Clustering, Firm, Sample, Mult-2009-2011)

**Reweighting (Through 2011)
areg imp_int_resid qtime_197-qtime_207 qtiXjap_197-qtiXjap_207 if qtime<208 [aweight=jpnhat3], absorb(numfirm) vce(cluster numfirm)
outreg2 using ../Tables/regs_qbase_update.txt, noparen noaster addtext(Fixed Effects, Firm, Clustering, Firm, Sample, Mult-reweight-2009-2011)
areg jimp_int_resid qtime_197-qtime_207 qtiXjap_197-qtiXjap_207 if qtime<208 [aweight=jpnhat3], absorb(numfirm) vce(cluster numfirm)
outreg2 using ../Tables/regs_qbase_update.txt, noparen noaster addtext(Fixed Effects, Firm, Clustering, Firm, Sample, Mult-reweight-2009-2011)
areg naexp_resid qtime_197-qtime_207 qtiXjap_197-qtiXjap_207 if qtime<208 [aweight=jpnhat3], absorb(numfirm) vce(cluster numfirm)
outreg2 using ../Tables/regs_qbase_update.txt, noparen noaster addtext(Fixed Effects, Firm, Clustering, Firm, Sample, Mult-reweight-2009-2011)
areg njimp_int_resid qtime_197-qtime_207 qtiXjap_197-qtiXjap_207 if qtime<208 [aweight=jpnhat3], absorb(numfirm) vce(cluster numfirm)
outreg2 using ../Tables/regs_qbase_update.txt, noparen noaster addtext(Fixed Effects, Firm, Clustering, Firm, Sample, Mult-reweight-2009-2011)
*areg jexp_resid qtime_197-qtime_207 qtiXjap_197-qtiXjap_207 if qtime<208 [aweight=jpnhat3], absorb(numfirm) vce(cluster numfirm)
*outreg2 using ../Tables/regs_qbase_update.txt, noparen noaster addtext(Fixed Effects, Firm, Clustering, Firm, Sample, Mult-reweight-2009-2011)


**Not Re-weighting (Through 2012)
areg imp_int_resid qtime_197-qtime_211 qtiXjap_197-qtiXjap_211 , absorb(numfirm) vce(cluster numfirm)
outreg2 using ../Tables/regs_qbase_update.txt, noparen noaster addtext(Fixed Effects, Firm, Clustering, Firm, Sample, Mult-2009-2012)
areg jimp_int_resid qtime_197-qtime_211 qtiXjap_197-qtiXjap_211 , absorb(numfirm) vce(cluster numfirm)
outreg2 using ../Tables/regs_qbase_update.txt, noparen noaster addtext(Fixed Effects, Firm, Clustering, Firm, Sample, Mult-2009-2012)
areg naexp_resid qtime_197-qtime_211 qtiXjap_197-qtiXjap_211 , absorb(numfirm) vce(cluster numfirm)
outreg2 using ../Tables/regs_qbase_update.txt, noparen noaster addtext(Fixed Effects, Firm, Clustering, Firm, Sample, Mult-2009-2012)
areg njimp_int_resid qtime_197-qtime_211 qtiXjap_197-qtiXjap_211 , absorb(numfirm) vce(cluster numfirm)
outreg2 using ../Tables/regs_qbase_update.txt, noparen noaster addtext(Fixed Effects, Firm, Clustering, Firm, Sample, Mult-2009-2012)
*areg jexp_resid qtime_197-qtime_211 qtiXjap_197-qtiXjap_211 , absorb(numfirm) vce(cluster numfirm)
*outreg2 using ../Tables/regs_qbase_update.txt,  noparen noaster addtext(Fixed Effects, Firm, Clustering, Firm, Sample, Mult-2009-2012)

**Reweighting (Through 2012)
*areg imp_int_resid qtime_197-qtime_211 qtiXjap_197-qtiXjap_211 [aweight=jpnhat3], absorb(numfirm) vce(cluster numfirm)
*outreg2 using ../Tables/regs_qbase_update.txt, noparen noaster addtext(Fixed Effects, Firm, Clustering, Firm, Sample, Mult-reweight-2009-2012)
*areg jimp_int_resid qtime_197-qtime_211 qtiXjap_197-qtiXjap_211 [aweight=jpnhat3], absorb(numfirm) vce(cluster numfirm)
*outreg2 using ../Tables/regs_qbase_update.txt, noparen noaster addtext(Fixed Effects, Firm, Clustering, Firm, Sample, Mult-reweight-2009-2012)
areg naexp_resid qtime_197-qtime_211 qtiXjap_197-qtiXjap_211  [aweight=jpnhat3], absorb(numfirm) vce(cluster numfirm)
outreg2 using regs_qbase_update.txt, noparen noaster addtext(Fixed Effects, Firm, Clustering, Firm, Sample, Mult-reweight-2009-2012)
*areg njimp_int_resid qtime_197-qtime_211 qtiXjap_197-qtiXjap_211  [aweight=jpnhat3], absorb(numfirm) vce(cluster numfirm)
*outreg2 using ../Tables/regs_qbase_update.txt, noparen noaster addtext(Fixed Effects, Firm, Clustering, Firm, Sample, Mult-reweight-2009-2012)
*areg jexp_resid qtime_197-qtime_211 qtiXjap_197-qtiXjap_211  [aweight=jpnhat3], absorb(numfirm) vce(cluster numfirm)
*outreg2 using ../Tables/regs_qbase_update.txt, noparen noaster addtext(Fixed Effects, Firm, Clustering, Firm, Sample, Mult-reweight-2009-2012)


preserve
clear
import delimited regs_qbase_update.txt
export excel using "regs_qbase_update", sheet("Q_regs") sheetmodify firstrow(variables)
restore




**Supports for Regressions
matrix REGJPN_FIRM = J(11,3,1)
matrix REGJPN_CR = J(11,2,1)

local count = 1
forvalues j = 197(1)207 {
	
	matrix REGJPN_FIRM[`count',1] = `j'
	preserve
	keep if qtime==`j'
	keep if japan==1
	esum naexp_resid, sType("mean") firmident("firmid") tvsident("naexp")
	matrix temp = r(sumout)
	matrix temp2 = r(sumout2)
	matrix REGJPN_CR[`count',1] = temp2[1,1]
	matrix REGJPN_FIRM[`count',2] = temp[1,5]
	
		
	restore
	
	preserve
	keep if qtime==`j'
	keep if japan==0
	esum naexp_resid, sType("mean") firmident("firmid") tvsident("naexp")
	matrix temp = r(sumout)
	matrix temp2 = r(sumout2)
	matrix REGJPN_CR[`count',2] = temp2[1,1]
	matrix REGJPN_FIRM[`count',3] = temp[1,5]
	
	
	
	restore
	
	local count = `count'+1
	
}



**Output Results: Support
*************************

**Regressions
drop _all
svmat REGJPN_FIRM
rename REGJPN_FIRM1 monthvar
rename REGJPN_FIRM2 NAEXP_JPN_FIRM
rename REGJPN_FIRM3 NAEXP_NONJPN_FIRM

gen blank = ""
svmat REGJPN_CR
rename REGJPN_CR1 NAEXP_JPN_CR
rename REGJPN_CR2 NAEXP_NONJPN_CR


export excel using "../support/regs_qbase_update_support", sheet("Q_regs_base") firstrow(variables) replace






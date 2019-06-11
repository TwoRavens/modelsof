/*
	decomp_mmnts.do
	
	Run most analyses, besides CHK/AKM-style results.
	
*/

clear all
macro drop _all
set more off

* Directories
cap cd "<statadir>"
global outfolder = "<outfolder>"

global yrfirst = 1978 		// First year in the dataset
global yrlast = 2013 		// Last year in the dataset

matrix pcemat = (                                                     17.262,  17.546, ///
   17.730,  17.939, 18.148, 18.414, 18.681, 19.155, 19.637,  20.402,  21.326,  22.325, ///
   23.273,  24.070, 25.367, 28.008, 30.347, 32.012, 34.091,  36.479,  39.713,  43.977, ///
   47.907,  50.552, 52.728, 54.723, 56.660, 57.886, 59.649,  61.973,  64.641,  67.439, ///
   69.651,  71.493, 73.278, 74.802, 76.355, 77.979, 79.326,  79.934,  81.109,  83.128, ///
   84.731,  85.872, 87.573, 89.703, 92.260, 94.728, 97.099, 100.063, 100.000, 101.654, ///
  104.086, 106.009, 107.211)
global pcefirstyr 1959

matrix minwg = /* Nominal minimum wage 1947-2013
*/ (0.40,0.40,0.40,0.40,0.75,0.75,0.75,0.75,0.75,1.00,1.00,1.00,1.00,1.00, /*
*/ 1.00,1.15,1.15,1.25,1.25,1.25,1.25,1.40,1.60,1.60,1.60,1.60,1.60,1.60, /*
*/ 2.00,2.10,2.10,2.30,2.65,2.90,3.10,3.35,3.35,3.35,3.35,3.35,3.35,3.35, /*
*/ 3.35,3.35,3.80,4.25,4.25,4.25,4.25,4.25,4.75,5.15,5.15,5.15,5.15,5.15, /*
*/ 5.15,5.15,5.15,5.15,5.15,5.85,6.55,7.25,7.25,7.25,7.25)
global minwgfirstyr 1947


* Set this to 0 for actual run, 1 if currently testing code
*  istest==1 allows code to be run on smaller data sets, faster, etc,
*  but will return INCORRECT results - must be set to 0 before running
*  for actual analysis
global istest = 1


******************************************************************************
******************************************************************************
******************************************************************************
* Code to read in data sets

cap program drop myuse
program define myuse, nclass

	syntax , anlev(string) yr(string) usevars(string) ///
		[ clear keepnonftage usecounty ]
	
	* Clear memory if requested
	`clear'
	
	* Read in data requested.
	* NOTE: Make sure to include only needed vars, and drop for nonftage
	local extrausevars indcode
	if "`keepnonftage'"!="keepnonftage" & substr("`anlev'",1,4)=="indv" {
		local extrausevars `extrausevars' indv_totwage yob
	}
	if "`usecounty'"!="usecounty" {
		local extrausevars `extrausevars' geo
	}
	use `usevars' `extrausevars' using "./data/decomp`anlev'_data_`yr'"
	
	* Drop if no people working there - eg a firm with only part-time workers
	drop if missing(countppl) | countppl==0
	
	* Drop observations in education or public admin
	qui drop if (9000 <= indcode & indcode <= 9899) | (8200 <= indcode & indcode <= 8299)
	
	* Unless otherwise requested, drop obs that are less than full-time
	*  Note that wage is already in 2013 terms
	*  To compare to min wage in other years than 2013, 
	*  must adjust min wage from those years for inflation
	if "`keepnonftage'"!="keepnonftage" & substr("`anlev'",1,4)=="indv" & "`anlev'"!="indv5yr" {
		qui keep if (indv_totwage >= minwg[1,`=`yr'-${minwgfirstyr}+1'] * 13 * 40 * ///
				pcemat[1,`=2013-${pcefirstyr}+1'] / pcemat[1,`=`yr'-${pcefirstyr}+1']) ///
			& inrange(`yr'-yob,20,60)
	}
	if "`keepnonftage'"!="keepnonftage" & "`anlev'"=="indv5yr" {
		qui keep if (indv_totwage5yr/5 >= minwg[1,`=`yr'-${minwgfirstyr}+1'] * 13 * 40 * ///
				pcemat[1,`=2013-${pcefirstyr}+1'] / pcemat[1,`=`yr'-${pcefirstyr}+1']) ///
			& inrange(`yr'-yob,20,60) & inrange(`yr'-4-yob,20,60)
	}
	
	if "`usecounty'"!="usecounty" {
		qui replace geo = substr(geo,1,2)
	}
			
	* Get rid of variables that were not requested
	keep `usevars'

end // END of program define myuse, nclass


******************************************************************************
******************************************************************************
******************************************************************************
* Program to anonymize top values of variables, as needed
*  Can Winsorize, or set to average within that cell
*  If no pval is specified, assume 99.999

* Max nominal pay (thousands of dollars) in execucomp for each year, 1992-2014
*  Code for this data:
*   gen pay=    salary+bonus+rstkgrnt+opt_exer_val+ltip
*   replace pay=salary+bonus+stock_awards_fv+opt_exer_val+noneq_incent if year>=2006
*   collapse (max) pay, by(year)
matrix execmax = (        67444.5,  203010.6, 117470.4, ///
	 65580.2, 102448.8,  230465.2,  655412.1, 234133.4, ///
	706076.9, 174613.3,  194947.9,  154754.9, 230551.7, ///
	294180.7, 302116.7,  555529.6,  212941.5, 105951.0, ///
	135832.7, 377980.0, 2277447.0, 3299678.0, 119604.8)

cap program drop myanontop
program define myanontop, nclass

	syntax varlist, [ p(real 99.999) winsor arithmean geomean execmax execmaxyr(integer 0)]
	
	* Must use exactly one anonymization type: winsor, arithmean, or geomean
	if ("`geomean'"=="geomean")+("`winsor'"=="winsor") ///
			+("`arithmean'"=="arithmean")+("`execmax'"=="execmax") > 1 {
		di as error "Error: must use no more than one of options winsor, arithmean, geomean, or execmax"
		error 198
	}
	
	* If nothing selected, default to geomean
	if ("`geomean'"=="geomean")+("`winsor'"=="winsor") ///
			+("`arithmean'"=="arithmean")+("`execmax'"=="execmax") == 0 {
		local geomean geomean
	}
	
	foreach wvar of varlist `varlist' {
	
		* Find correct percentile (used in all methods)
		_pctile `wvar' if !missing(`wvar'), p(`p')
		local pctlval = r(r1)

		* Winsorize
		if "`winsor'"=="winsor" {
			replace `wvar' = r(r1) if `wvar' > `pctlval' & !missing(`wvar')
		}

		* Set to arithmetic mean
		if "`arithmean'"=="arithmean" {
			egen double `wvar'topmean = mean(`wvar') if `wvar' > `pctlval' & !missing(`wvar')
			replace `wvar' = `wvar'topmean if `wvar' > `pctlval' & !missing(`wvar')
			drop `wvar'topmean
		}

		* Set to geometric mean
		if "`geomean'"=="geomean" {
			gen marktochange = (`wvar' > `pctlval' & !missing(`wvar'))
			replace `wvar' = log(`wvar') if marktochange
			egen double `wvar'topmean = mean(`wvar') if marktochange
			replace `wvar' = exp(`wvar'topmean) if marktochange
			drop `wvar'topmean marktochange
		}
		
		* Set to max of real execucomp data, where possible.
		*  For years with no execucomp data, set to average of max from first 3 years.
		if "`execmax'"=="execmax" {
			if `execmaxyr'>=1992 {
				local topinc = 1000 * execmax[1,`=`execmaxyr'-1992+1'] * ///
					pcemat[1,`=2013-${pcefirstyr}+1'] / pcemat[1,`=`execmaxyr'-${pcefirstyr}+1']
			}
			else {
				local topinc = 1000 * pcemat[1,`=2013-${pcefirstyr}+1'] / 3 * ( ///
					  execmax[1,`=1992-1992+1']/pcemat[1,`=1992-${pcefirstyr}+1'] ///
					+ execmax[1,`=1993-1992+1']/pcemat[1,`=1993-${pcefirstyr}+1'] ///
					+ execmax[1,`=1994-1992+1']/pcemat[1,`=1994-${pcefirstyr}+1'] )
			}
			replace `wvar' = `topinc' if `wvar'>`topinc' & !missing(`wvar')
		}
	}
	
end // END of program define myanontop, nclass


******************************************************************************
******************************************************************************
******************************************************************************
* Program to analyze listed variables by another variable, exporting results.

cap program drop mycollapseexport
program define mycollapseexport, nclass

	syntax varlist, by(string) outfile(string asis) descrip(string) ///
		 [ logfirst byweight(string) anweight(string) ///
			ifby(string asis) ifan(string asis) aggtypelist(namelist) ///
			yrtext(integer 9999) minempltext(string) ///
			keeppctl(real 100) bythresh(string) ]
		
	* Defaults for string arguments
	local default_byweight 1
	local default_anweight 1
	local default_aggtypelist mean
	local default_ifby 1
	local default_ifan 1
	local default_minempltext 9999
	foreach currarg in byweight anweight aggtypelist ifby ifan minempltext {
		if "``currarg''"=="" {
			local `currarg' `default_`currarg''
		}
	}
	
	* Preserve data to restore at the end if needed
	tempfile mycetemp
	save "`mycetemp'", replace
	
	foreach weightvar in `byweight' `anweight' {
		local `weightvar'text `weightvar'
		if "``weightvar''"=="1" {
			local `weightvar'text 
		}
	}
	local ifvarlist
	foreach currvar of varlist * {
		if strpos("`ifby'","`currvar'") | strpos("`ifan'","`currvar'") {
			local ifvarlist `ifvarlist' `currvar'
		}
	}
	keep `varlist' `by' `ifvarlist' `byweighttext' `anweighttext'
	
	* Put by variable into groups
	********************
	* Put by variable into percentiles
	*  We could use pctile, but this is used for more control and speed
	if `"`bydata'"' == "" & "`bythresh'"=="" {
		
		* Drop those observations here that aren't needed
		*  If done below, they can cause problems
		keep if `ifby'
		
		* Also drop observations with missing byvar
		drop if missing(`by')
		
		* Make sure ties are broken randomly
		gen temprandvar = runiform()
		sort `by' temprandvar
		drop temprandvar
		
		* Create percentile variable
		egen sumnumempl = sum(`byweight')
		if `keeppctl' < 99.9 {	// For robustness, test against 99.9, not keeppctl==100
			gen currsumwgt = sum(`byweight')
			drop if currsumwgt/sumnumempl <= 1 - `keeppctl'/100
			drop sumnumempl currsumwgt
			egen sumnumempl = sum(`byweight')
		}
		gen currsumwgt = sum(`byweight')
		gen sortvar = min(ceil( (currsumwgt/sumnumempl) *100),100)
		drop sumnumempl
	}
	* By variable into groups based on thresholds
	if "`bythresh'"=="125" {
		keep if `ifby'
		drop if missing(`by')
		gen sortvar = 1
		local threshlist 10 20 50 100 200 500 1000 2000 5000 10000
		if ${istest} {
			local threshlist 10 20 50 75 100 150 200 300 400 500
		}
		foreach currthresh in `threshlist' {
			replace sortvar = sortvar+1 if `by'>=`currthresh'
		}
	}
	********************
	
	* If requested, put varlist variables into logs
	if "`logfirst'"=="logfirst" {
		foreach currvar of varlist `varlist' {
			replace `currvar' = log(`currvar')
		}
	}
	
	* Find mean and number of observations, to be used later.
	*  Use same restriction as the actual analysis: both ifby and ifan.
	foreach currvar of varlist `varlist' {
		qui sum `currvar' [w=`anweight'] if `ifby' & `ifan'
		local nobs_`currvar' = r(N)
		local mean_`currvar' = r(mean)
		local sd_`currvar' = r(sd)
	}
	
	* Collapse to one observation per aggtype for each variable
	local collapselistall
	foreach aggtype in `aggtypelist' {
		local collapselist "(`aggtype')"
		foreach currvar of varlist `varlist' {
			local collapselist "`collapselist' res_p`aggtype'_`currvar' = `currvar'"
		}
		local collapselistall "`collapselistall' `collapselist'"
	}		
	collapse `collapselistall' [iw=`anweight'] if `ifby' & `ifan', by(sortvar)
	
	*  Reshape to be correct shape for appending to the output data set.
	reshape long res_p, i(sortvar) j(currvar) s
	reshape wide res_p, i(currvar) j(sortvar)
	
	* Separate out aggtype and currvar
	gen aggtype = substr(currvar, 1, strpos(currvar,"_")-1)
	qui replace currvar = substr(currvar, strpos(currvar,"_")+1,.)
	
	* Add on data on observations and the mean
	qui gen res_nobs = .
	qui gen res_mean = .
	qui gen res_sd = .
	foreach currvar in `varlist' {
		qui replace res_nobs = `nobs_`currvar'' if currvar=="`currvar'"
		qui replace res_mean = `mean_`currvar'' if currvar=="`currvar'"
		qui replace res_sd = `sd_`currvar'' if currvar=="`currvar'"
	}

	* Add info about how this data set was run
	gen year = "`yrtext'"
	gen byvar = "`by'"
	gen byweight = "`byweight'"
	gen anweight = "`anweight'"
	gen ifby = "`ifby'"
	gen ifan = "`ifan'"
	gen keeppctl = "`keeppctl'"
	gen log = "`logfirst'"
	gen descrip = "`descrip'"
	gen minempl = "`minempltext'"
	append using `outfile'
	sort year byvar currvar descrip byweight anweight ifby ifan keeppctl log aggtype minempl
	save `outfile', replace

	* Go back to the original data set
	use "`mycetemp'", clear
		
end // END of program define mycollapseexport, nclass




******************************************************************************
******************************************************************************
******************************************************************************

* END OF PROGRAMS, BEGINNING OF ANALYSIS

******************************************************************************
******************************************************************************
******************************************************************************


* Size definitions
local currif_size0 countppl>=0
local currif_size20 countppl>=20
local currif_size10000 countppl>=10000
local currif_size2010000 20<=countppl & countppl<10000
local currif_size100999 100<= countppl & countppl < 1000
local currif_size10004999 1000<= countppl & countppl < 5000
local currif_size50009999 5000<= countppl & countppl < 10000
local threshlist 10 20 50 100 200 500 1000 2000 5000 10000
if ${istest} {
	local currif_size10000 countppl >= 100
	local currif_size10004999 100<= countppl & countppl < 600
	local currif_size50009999 200<= countppl & countppl < 700
	local threshlist 10 20 50 75 100 150 200 300 400 500
}
*  Census regions
local sampleres_regNE inlist(real(substr(geo,1,2)), 11,12,13,14,15,16,21,22,23)
local sampleres_regMW inlist(real(substr(geo,1,2)),31,32,33,35,36,41,42,43,45,46,47,48)
local sampleres_regSO inlist(real(substr(geo,1,2)),50,51,52,53,55,56,57,58,90,61,63,64,65,71,72,73,74)
local sampleres_regWE inlist(real(substr(geo,1,2)),81,82,83,84,85,86,87,88,91,92,93,02,26)
* Demographics
local sampleres_sexm male==1
local sampleres_sexf male==0
* Dropping by earnings
local sampleres_nr1 firm_wagerank1-indv_totwage>.01
local sampleres_nr5 firm_wagerank5-indv_totwage>.01
local sampleres_n1f firm_wagep99-indv_totwage>.01
local sampleres_n5f firm_wagep95-indv_totwage>.01
local sampleres_n1a overallp99-indv_totwage>.01
local sampleres_n5a overallp95-indv_totwage>.01
* Keeping only continuing firms
local sampleres_cntfrm 1 // Sample selection done above this point
* Industries
local sampleres_indD 2000 <= indcode & indcode <= 3999
local sampleres_indE 4000 <= indcode & indcode <= 4999
local sampleres_indH 6000 <= indcode & indcode <= 6799
local sampleres_indI 7000 <= indcode & indcode <= 8999
local sampleres_indFG 5000 <= indcode & indcode <= 5999
local sampleres_indABCJ (0100 <= indcode & indcode <= 1799) | (9100 <= indcode & indcode <= 9999)


******************************************************************************
* Overall inequality statistics

* Temporary file for overall inequality data
clear
tempfile ineqtemp
gen year = .
save "`ineqtemp'"
clear

* Which statistics to look at?
local statlist N Var

* Variance decomposition - robustness checks
foreach yr in 1981 2013 {
	
	* Sample restrictions that vary by year
	foreach minhr in 260 1040 2080 {
		local sampleres_mw`minhr' indv_totwage >= minwg[1,`=`yr'-${minwgfirstyr}+1'] * `minhr' * ///
			pcemat[1,`=2013-${pcefirstyr}+1'] / pcemat[1,`=`yr'-${pcefirstyr}+1']
	}
	local sampleres_mwyr13 indv_totwage >= minwg[1,`=2013-${minwgfirstyr}+1'] * 520
	local sampleres_age20s inrange(`yr'-yob,20,29)
	local sampleres_age30s inrange(`yr'-yob,30,39)
	local sampleres_age40s inrange(`yr'-yob,40,49)
	local sampleres_age50s inrange(`yr'-yob,50,60)
	
	* Run through all samples needed
	*  NOTE: sgp = subgroup - part of firm; sgw = subgroup - whole firms; dmn = demean by variables; oth = other
	local currsamplelist ///
		sgw_indD sgw_indE sgw_indH sgw_indI sgw_indFG sgw_indABCJ /// Industries
		oth_avg5yr /// Averaging over 5 years
		sgw_cntfrm /// Continuing firms
		sgp_nr1 sgp_nr5 sgp_n1f sgp_n5f sgp_n1a sgp_n5a /// No X: no top Y, no top Y pct in firm, or overall
		sgp_mwyr13 sgp_mw260 sgp_mw1040 sgp_mw2080 /// Different min earnings thresholds
		sgp_age20s sgp_age30s sgp_age40s sgp_age50s sgp_sexm sgp_sexf /// Demographics
		sgw_tsh1 sgw_tsh2 sgw_tsh3 sgw_tsh4 sgw_tsh5 sgw_tsh6 sgw_tsh7 sgw_tsh8 sgw_tsh9 sgw_tsh10 sgw_tsh11  /// Narrow earnings bins
		dmn_ind2 dmn_ind3 dmn_ind4 dmn_male dmn_yob dmn_geo dmn_cnty dmn_thrsh dmn_regn /// Demeaning
		sgw_regNE sgw_regMW sgw_regSO sgw_regWE // Regions
	local minempl 20
	foreach currsample in `currsamplelist' {
	
		di "Current: `yr' `currsample'"
		
		* Subsamples containing whole firms, as usually defined
		if substr("`currsample'",1,4)=="sgw_" {
			local subgtxt = substr("`currsample'",5,.)
			local minemplfull `minempl'
			if substr("`currsample'",1,7)=="sgw_tsh" {
				local currthresh = substr("`currsample'",8,.)
				local minsize = cond(`currthresh'>1, word("`threshlist'",`=`currthresh'-1'), "0")
				local maxsize = cond(wordcount("`threshlist'")>=`currthresh', word("`threshlist'",`currthresh'), "10^10")
				local sampleres_`subgtxt' `minsize' <= countppl & countppl <`maxsize'
				local minemplfull 0
			}
			qui myuse, anlev(indv) yr(`yr') clear usevars(indv_totwage firm_logwgmnjob countppl indcode geo ein)
			if "`currsample'"=="sgw_cntfrm" {
				preserve
					qui myuse, anlev(firm) yr(`=cond(`yr'==1981,2013,1981)') clear usevars(ein countppl)
					rename countppl countppl_otheryr
					qui keep if (`currif_size`minemplfull'')
					tempfile otheryrtemp
					save "`otheryrtemp'"
				restore
				qui merge m:1 ein using "`otheryrtemp'", nogen keep(match)
			}
			drop ein
			qui gen logwage = log(indv_totwage)
			qui gen infmlog = logwage - firm_logwgmnjob
			qui keep if (`currif_size`minemplfull'')
			qui keep if (`sampleres_`subgtxt'')
			qui myanontop logwage infmlog indv_totwage, arithmean
		}
		
		* Subsamples that DO NOT contain whole firms
		if substr("`currsample'",1,4)=="sgp_" {
			local subgtxt = substr("`currsample'",5,.)
			local extrakeepvars
			if substr("`currsample'",1,6)=="sgp_mw" {
				local extrakeepvars yob
			}
			if substr("`currsample'",1,7)=="sgp_age" {
				local extrakeepvars yob
			}
			if substr("`currsample'",1,7)=="sgp_sex" {
				local extrakeepvars male
			}			
			qui myuse, anlev(indv100p) yr(`yr') clear usevars(ein indv_totwage countppl geo `extrakeepvars') ///
				`=cond(substr("`currsample'",1,6)=="sgp_mw","keepnonftage","")'
			`=cond(substr("`currsample'",1,6)=="sgp_mw","keep if inrange(`yr'-yob,20,60)","")'
			sort ein indv_totwage
			if inlist("`subgtxt'","nr1","nr5","n1f","n5f","n1a","n5a") {
				local newvarcode_nr1 by ein: gen firm_wagerank1 = indv_totwage[_N+1-1]
				local newvarcode_nr5 by ein: gen firm_wagerank5 = indv_totwage[_N+1-5]
				local newvarcode_n1f by ein: egen firm_wagep99 = pctile(indv_totwage), p(99)
				local newvarcode_n5f by ein: egen firm_wagep95 = pctile(indv_totwage), p(95)
				local newvarcode_n1a         egen overallp99 = pctile(indv_totwage), p(99)
				local newvarcode_n5a         egen overallp95 = pctile(indv_totwage), p(95)
				`newvarcode_`subgtxt''
			}
			qui keep if (`currif_size`minempl'') & (`sampleres_`subgtxt'')
			qui gen logwage = log(indv_totwage)
			bys ein: egen firmwage = mean(logwage)
			gen infmlog = logwage - firmwage
			keep logwage infmlog
			qui myanontop logwage infmlog, arithmean
		}		
		
		* Demeaning variables
		if substr("`currsample'",1,4)=="dmn_" {
			local demeanvartxt = substr("`currsample'",5,.)
			local demeanvarkeep_male male
			local demeanvarkeep_yob yob
			local demeanvarkeep_ind2 indcode
			local demeanvarkeep_ind3 indcode
			local demeanvarkeep_ind4 indcode
			local demeanvarkeep_geo geo
			local demeanvarkeep_cnty geo
			local demeanvarkeep_regn geo
			local demeanvarkeep_thrsh 
			local demeanvar `demeanvarkeep_`demeanvartxt''
			local demeanvarval `demeanvarkeep_`demeanvartxt''
			qui myuse, anlev(indv100p) yr(`yr') clear usevars(indv_totwage countppl ein ///
				`demeanvar') ///
				`=cond("`demeanvartxt'"=="cnty","usecounty","")'
			if substr("`currsample'",1,7)=="dmn_ind" {
				local indlen = substr("`currsample'",8,1)
				replace indcode = real(substr(string(indcode),1,`indlen'))
			}
			if "`currsample'"=="dmn_regn" {
				gen georeg = ""
				foreach currreg in NE MW SO WE {
					replace georeg = "`currreg'" if `sampleres_reg`currreg''
				}
				replace geo = georeg
			}
			if "`currsample'"=="dmn_thrsh" {
				local demeanvarval threshval
				gen threshval = 1
				foreach currthresh in `threshlist' {
					replace threshval = threshval+1 if countppl>=`currthresh'
				}
			}
			qui keep if (`currif_size`minempl'')
			drop countppl
			gen logwage = log(indv_totwage)
			drop indv_totwage
			bys `demeanvarval': egen groupwage = mean(logwage)
			replace logwage = logwage - groupwage
			drop `demeanvarval' groupwage
			bys ein: egen firmwagediff = mean(logwage)
			gen infmlog = logwage - firmwagediff
			drop ein firmwagediff
		}
		
		* Averaging over 5 years
		if "`currsample'"=="oth_avg5yr" {
			local yrfor5 = cond(`yr'==1981,1985,2013)
			qui myuse, anlev(indv5yr) yr(`yrfor5') clear usevars(indv_totwage5yr countppl firm_avglogwage5yr)
			qui keep if (`currif_size`minempl'')
			drop countppl
			gen logwage = log(indv_totwage5yr/5)
			qui gen infmlog = logwage - (firm_avglogwage5yr - log(5))
			qui myanontop logwage infmlog indv_totwage, arithmean			
		}

		* Summary variables
		qui sum logwage, d
		foreach currstat in `statlist' {
			local res_m`minempl'_s`currsample'_`currstat' = r(`currstat')
		}
		
		* Variance of the ratio
		qui sum infmlog
		local res_m`minempl'_s`currsample'_varinrt = r(Var)
		
		* Save the results
		clear
		qui set obs 1
		gen year = `yr'
		gen minempl = "`minempl'"
		gen currsample = "`currsample'"
		foreach currstat in `statlist' {
			gen res_`currstat' = `res_m`minempl'_s`currsample'_`currstat''
		}
		gen res_varinrt = `res_m`minempl'_s`currsample'_varinrt'
		
		qui append using "`ineqtemp'"
		qui save "`ineqtemp'", replace
		
	}
	
}

* Main values to look at each year
local minempllist 0 20 2010000 10000
local statlist N mean Var
local pctllist .90 .95 .995 .999
local pctllistnodot =subinstr("`pctllist'",".","",.)
forvalues yr = $yrfirst/$yrlast {
foreach minempl in `minempllist' {

	di "Current: `yr' `minempl'"
		
	* Create individual variables
	qui myuse, anlev(indv) yr(`yr') clear ///
		usevars(indv_totwage firm_logwgmnjob countppl indcode)	
	
	qui gen logwage = log(indv_totwage)
	qui gen infmlog = logwage - firm_logwgmnjob
	qui keep if (`currif_size`minempl'')
	qui myanontop logwage infmlog indv_totwage, arithmean
	drop firm_logwgmnjob countppl

	* Summary variables
	qui sum logwage, d
	foreach currstat in `statlist' {
		local res_m`minempl'_`currstat' = r(`currstat')
	}
	
	* Percentiles
	sort indv_totwage
	qui sum indv_totwage
	foreach pval in `pctllist' {
		local ptext = subinstr("`pval'",".","",.)
		local res_m`minempl'_p`ptext' = indv_totwage[`=round(r(N)*`pval')']
	}
	
	* Variance of the ratio.  Note that the firm value is based on only full-time
	*  employees, so though we calculate the ratio for everyone, that number isn't
	*  as meaningful.
	qui sum infmlog
	local res_m`minempl'_varinrt = r(Var)
		
	* Also look at firm variance.
	qui myuse, anlev(firm) yr(`yr') usevars(firm_logwgmnjob countppl) clear		
	qui myanontop firm_logwgmnjob, arithmean

	qui sum firm_logwgmnjob if `currif_size`minempl'' [fw=countppl]
	local res_m`minempl'_varfirm = r(Var)
		
	* Save the results
	clear
	qui set obs 1
	gen year = `yr'
	gen minempl = "`minempl'"
	gen currsample = "ft"
	foreach currstat in `statlist' {
		gen res_`currstat' = `res_m`minempl'_`currstat''
	}
	foreach currp in `pctllistnodot' {
		gen res_p`currp' = `res_m`minempl'_p`currp''
	}
	gen res_varinrt = `res_m`minempl'_varinrt'
	qui gen res_varfirm = `res_m`minempl'_varfirm'
	qui append using "`ineqtemp'"
	qui save "`ineqtemp'", replace
		
}
}

use "`ineqtemp'", clear
sort year minempl currsample
format res_* %12.0g
outsheet year minempl currsample res_* ///
	using "${outfolder}/ineqall.csv", replace delim(",")


******************************************************************************
* Looking at top employees

* Temporary file for overall top employee data
clear
tempfile topempltemp
gen year = .
gen subg = ""
gen useanon = ""
save "`topempltemp'"
clear

local pvals 10 50 90 95 96 97 98 99
local rankvals 1 2 3 4 5 10 25 50 100 500

forvalues yr = $yrfirst/$yrlast {
foreach numtype in p rank {
foreach useanon in 1 execmax {

	local usevars 
	foreach currval in ``numtype'vals' {
		local usevars `usevars' firm_wage`numtype'`currval'
	}
	
	myuse, anlev(firm) yr(`yr') usevars(countppl indcode `usevars') clear
		
	* Take logs to get geometric mean
	foreach cvar of varlist firm_wage* {
		qui replace `cvar' = log(`cvar')
	}
	
	* Anonymize as requested
	if "`useanon'"=="execmax" {
		qui myanontop firm_wage*, execmax execmaxyr(`yr')
	}
	if "`useanon'"=="1" {
		qui myanontop firm_wage*, arithmean
	}
	
	foreach subg in size100999 size10004999 size50009999 size10000 {
		
		preserve
		
			collapse (count) countppl (mean) firm_wage`numtype'* if `currif_`subg''

			gen year = `yr'
			gen subg = "`subg'"
			gen useanon = "`useanon'"
			rename countppl nobs
			
			* Must merge rather than appending because rank/pctl runs
			*  create different variables
			qui merge 1:1 year subg useanon using "`topempltemp'", nogen
			save "`topempltemp'", replace
		
		restore	
	}
}
}
}


use "`topempltemp'", clear
sort year subg useanon
format firm_wage* %12.0g
outsheet year subg useanon nobs firm_wage* ///
	using "${outfolder}/topemplall.csv", replace delim(",")


******************************************************************************
* Firm size vs. other measures

* Temporary file for use in threshold data
clear
tempfile threshdatatemp
gen currvar = ""
save "`threshdatatemp'"
clear

local minempl 20

forvalues yr = $yrfirst/$yrlast {

	myuse, anlev(indv) yr(`yr') clear ///
		usevars( countppl indv_totwage )
	
	* Anonymize analysis variables
	myanontop indv_totwage
	
	local allif countppl>=`minempl'
	
	mycollapseexport indv_totwage, ///
		logfirst by(countppl) ///
		ifby(`allif') ifan(`allif') ///
		outfile("`threshdatatemp'") descrip(threshstat) ///
		yrtext(`yr') minempltext(`minempl') ///
		bythresh(125) aggtypelist(p10 p25 p50 p75 p90)
	
}

use "`threshdatatemp'", clear
local ordervars year byvar currvar descrip byweight anweight ifby ifan keeppctl log aggtype minempl
sort `ordervars'
format res_* %12.0g
outsheet `ordervars' res_* ///
	using "${outfolder}/threshall.csv", replace delim(",")


******************************************************************************
* Temporary file for use in percentile data

clear
tempfile alldatatemp
gen currvar = ""
save "`alldatatemp'"
clear


******************************************************************************
* Find data for percentile graphs

* Old JMP analysis
forvalues yr = 1981/2013 {

	myuse, anlev(indv) yr(`yr') usevars( countppl indv_totwage ///
		firm_logwgmnjob firm_wagerank1) clear
		
	* It might speed it up to sort first, so future sorts are faster
	sort indv_totwage

	* Various other variables to be used of firm wage for individuals
	gen isfirmtop1 = (firm_wagerank1-indv_totwage<.01) if !missing(firm_wagerank1)
	gen countppla = countppl
	drop firm_wagerank1
	
	* Use exponent so the averaging is done without logging
	replace firm_logwgmnjob = exp(firm_logwgmnjob)
	
	* Anonymize analysis variables
	myanontop indv_totwage firm_logwgmnjob countppla

	local minempl 20
	foreach keeppctl in 1 100 {
	
		* Main old JMP analysis
		mycollapseexport indv_totwage firm_logwgmnjob, ///
			logfirst by(indv_totwage) ///
			ifby(countppl>=`minempl') ifan(countppl>=`minempl') ///
			outfile("`alldatatemp'") descrip(indvstat) ///
			yrtext(`yr') minempltext(`minempl') keeppctl(`keeppctl')
		
		* By income, what fraction are top at their firm?
		mycollapseexport isfirmtop1, ///
			by(indv_totwage) ///
			ifby(countppl>=`minempl') ifan(countppl>=`minempl') ///
			outfile("`alldatatemp'") descrip(indvstat) ///
			yrtext(`yr') minempltext(`minempl') keeppctl(`keeppctl')
	}	
}

* Summary statistics
foreach yr in 1981 2013 {
foreach minempl in 0 20 {
foreach currbyvar in indv inrt firm firmwgt indvsize firmsize {

	local weight 1
	local keeppctllist 1 100
	if "`currbyvar'"=="indv" {
		myuse, anlev(indv) yr(`yr') usevars(indv_totwage countppl) clear
		replace indv_totwage = log(indv_totwage)
		local andatavar indv_totwage
	}
	if "`currbyvar'"=="inrt" {
		myuse, anlev(indv) yr(`yr') usevars(indv_totwage firm_logwgmnjob countppl) clear
		gen indvoverfirm = log(indv_totwage) - firm_logwgmnjob
		local andatavar indvoverfirm
		drop indv_totwage firm_logwgmnjob
	}
	if "`currbyvar'"=="firm" {
		myuse, anlev(firm) yr(`yr') usevars(firm_logwgmnjob countppl) clear
		local andatavar firm_logwgmnjob
	}
	if "`currbyvar'"=="firmwgt" {
		myuse, anlev(firm) yr(`yr') usevars(firm_logwgmnjob countppl) clear
		local andatavar firm_logwgmnjob
		local weight countppl
		myanontop countppl, arithmean
	}
	if "`currbyvar'"=="indvsize" {
		myuse, anlev(indv) yr(`yr') usevars(countppl) clear
		gen countppla = countppl
		local andatavar countppla
		local keeppctllist 100
	}
	if "`currbyvar'"=="firmsize" {
		myuse, anlev(firm) yr(`yr') usevars(countppl) clear
		gen countppla = countppl
		local andatavar countppla
	}
	
	myanontop `andatavar', arithmean
	
	foreach keeppctl in `keeppctllist' {
		mycollapseexport `andatavar', ///
			by(`andatavar') ///
			ifby(countppl>=`minempl') ifan(countppl>=`minempl') ///
			outfile("`alldatatemp'") descrip(pctl`currbyvar') ///
			yrtext(`yr') minempltext(`minempl') keeppctl(`keeppctl') ///
			aggtypelist(min) byweight(`weight')
	}
	
}

}
}


******************************************************************************
* JMP Counterfactual

local period1 1981
local period2 2013
local numwithin 500
if ${istest} {
	local numwithin 100
}
local numbetween 100
local minempl 20

foreach period in `period1' `period2' {

	myuse, anlev(indv100p) yr(`period') usevars(indv_totwage firm_logwgmnjob countppl) clear
	gen logwage = log(indv_totwage)
	qui keep if countppl>=`minempl'
	drop countppl indv_totwage
	local firmsortvar firm_logwgmnjob
		
	* Put people into buckets by firm wage
	gen randvar = runiform()
	sort `firmsortvar' randvar
	gen firmcat = min(max(ceil(_n/_N*`numbetween'),1),`numbetween')
	drop `firmsortvar' randvar
	
	* Find average within and between quantiles
	gen randvar = runiform()
	sort firmcat logwage randvar
	bys firmcat: gen indvcat = min(max(ceil(_n/_N*`numwithin'),1),`numwithin')
	bys firmcat: egen catmean`period' = mean(logwage)
	gen withinquantdiff`period' = logwage-catmean`period'
	drop logwage randvar
	collapse withinquantdiff`period' catmean`period', by(firmcat indvcat)
	
	* Save the results
	tempfile jmpdecomptemp_`period'
	save "`jmpdecomptemp_`period''"

}
use "`jmpdecomptemp_`period1''"
merge 1:1 firmcat indvcat using "`jmpdecomptemp_`period2''", nogen

foreach catyr in `period1' `period2' {
foreach withinyr in `period1' `period2' {
preserve
	gen res_p = catmean`catyr' + withinquantdiff`withinyr'
	sort res_p
	gen currpctl = min(max(ceil(_n/_N*100),1),100)
	collapse res_p, by(currpctl)
	gen year = "b`catyr'w`withinyr'"
	reshape wide res_p, i(year) j(currpctl)
	gen descrip = "jmpcfact`numbetween'_indv"
	gen keeppctl = "100"
	gen byvar = "indv_totwage"
	gen currvar = "indv_totwage"
	gen log = "logfirst"
	gen aggtype = "mean"
	gen minempl = "`minempl'"
	
	append using "`alldatatemp'"
	save "`alldatatemp'", replace

restore
}
}


******************************************************************************
* Output percentile files

use "`alldatatemp'", clear
sort year byvar currvar descrip byweight anweight ifby ifan keeppctl log aggtype minempl
format res_* %12.0g
outsheet year byvar currvar descrip byweight anweight ifby ifan keeppctl log aggtype minempl res_* ///
	using "${outfolder}/meansall.csv", replace delim(",")


******************************************************************************
* Share of income in top 1% to top at firms

* Temporary file for share data
set more off
clear
gen year = .
tempfile fractoptemp
save "`fractoptemp'"
clear

foreach yr in 1981 2013 {

	* Parameters used
	local minempl 20
	local distrpctl 99

	* Get some firm stats to merge on
	qui myuse, anlev(firm) yr(`yr') usevars(firm_wagerank50 countppl ein) clear
	qui keep if `currif_size`minempl''
	tempfile firmstattemp
	save "`firmstattemp'"

	* Prep individual file
	qui myuse, anlev(indv) yr(`yr') usevars(indv_totwage countppl ein ///
		firm_wagerank1 firm_wagerank5 firm_wagep99) clear
	qui keep if `currif_size`minempl''
	qui merge m:1 ein using "`firmstattemp'", keep(matched) nogen
	drop ein
	
	* Total earnings
	qui sum indv_totwage
	local totearn = r(sum)
	
	* Fraction to top X%
	_pctile indv_totwage, p(`distrpctl')
	local overallpctl = r(r1)
	qui sum indv_totwage if indv_totwage>`overallpctl'
	local fracallinpctl = r(sum)/ `totearn'
	
	* Fraction to people within firms at various places
	local firmplacelist rank1 rank5 p99
	foreach firmplace in `firmplacelist' {
		qui sum indv_totwage if indv_totwage>`overallpctl' & (firm_wage`firmplace' - indv_totwage<.01)
		local fractop`firmplace' = r(sum) / `totearn'
	}
	
	* Save to a temporary file
	clear
	set obs 1
	gen year = `yr'
	gen minempl = "`minempl'"
	gen distrpctl = `distrpctl'
	gen res_fracallinpctl = `fracallinpctl'
	foreach firmplace in `firmplacelist' {
		gen res_fractop`firmplace' = `fractop`firmplace''
	}
	append using "`fractoptemp'"
	save "`fractoptemp'", replace

}

* Save to a permanent file
use "`fractoptemp'", clear
sort year minempl distrpctl
format res_* %12.0g
outsheet year minempl distrpctl res_* ///
	using "${outfolder}/fractoppctl.csv", replace delim(",")

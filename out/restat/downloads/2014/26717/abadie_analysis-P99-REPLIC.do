clear
clear matrix
set mem 350m
set maxvar 32767


set more off

capture log close

 local measure "Killed"
 
 local Dtail = "P99"

 local tail = 99

log using abadie_`measure'_`Dtail'.log, replace


* Prepare Horizontal Axis in a Dataset used to merge all the event studies.
* ------------------------------------------------------------------------
clear
local numberofperiodsbefore = (1999-1960)+1
local numberofperiodsafter = (2008-1968)+1
local totalperiods = `numberofperiodsbefore' + `numberofperiodsafter'
set obs `totalperiods'
gen YearsFromLD=_n
replace YearsFromLD= YearsFromLD-(2008-1968+1)
sort YearsFromLD
save P`tail'_YearsFromLD.dta,replace


* Abadie estimates of the impact of large disasters

 use disaster_macro.dta
 sort ifscode year
 save disaster_macro.dta, replace
 
keep country ifscode wbcode year
sort wbcode year
save countrynames.dta, replace

* ------------------------------------------------------
use  data_GDP_regressionsV2.dta
sort wbcode year
save data_GDP_regressionsV2.dta, replace
* -------------------------------------------------------

* Education Data Interpolation
use data_GDP_regressionsV2.dta, clear
by  wbcode: ipolate educ year, gen(ieduc) epolate
replace ieduc=1   if ieduc<=0   & ieduc !=.
replace ieduc=100 if ieduc>=100 & ieduc !=.

* POL2 data extrapolation
gen POL204=POL2 if year==2004
egen maxPOL204=max(POL204), by( wbcode)
replace POL2=maxPOL204 if year>2004 & year<=2008

* Take absolute value of latitude
gen abs_lat=abs(lat)

* Add extra years of GDP percap PPP-adjusted
sort wbcode year

merge  wbcode year using gdp_ppp_PWT.dta
drop if _merge==2
drop _merge
sort wbcode year
replace  rgdpl=. if year==2004
replace  rgdpch=. if year==2004
replace  rgdpl=rgdpl[_n-1]*(gdppppcteci[_n]/gdppppcteci[_n-1]) if year>=2004 & year<=2007
replace  rgdpch=rgdpch[_n-1]*(gdppppcteci[_n]/gdppppcteci[_n-1]) if year>=2004 & year<=2007
gsort wbcode -year
replace  rgdpl = rgdpl[_n-1]*(gdppppcteci[_n]/gdppppcteci[_n-1]) if year>=1950 & year<=2007 & rgdpl ==. & gdppppcteci !=.
replace  rgdpch=rgdpch[_n-1]*(gdppppcteci[_n]/gdppppcteci[_n-1]) if year>=1950 & year<=2007 & rgdpch==. & gdppppcteci !=.
replace  gdppppcteci=gdppppcteci[_n-1]*(rgdpch[_n]/rgdpch[_n-1]) if year>=1950 & year<=2007 & gdppppcteci==. & rgdpch !=.

* Add Capital stock series
sort wbcode year
merge wbcode year using data_capital_stock.dta
drop if _merge==2
drop _merge

sort wbcode year
save data_GDP_regressionsV2b.dta, replace

* ------------------------------------------------------
* Read in the Countries Selected For Analysis. 

   use large_disasters`Dtail'.dta, clear

keep year ifscode wbcode
gen LargeDisaster = 1

  sort  wbcode year
  merge wbcode year using data_GDP_regressionsV2b.dta
  tab _merge
  drop _merge
  sort  wbcode year
  merge  wbcode year using countrynames.dta

 sort wbcode year
replace LargeDisaster = 0 if LargeDisaster == .

 egen sumLargeDisaster=sum(LargeDisaster), by(wbcode)

gen LargeDisasterCountry=(sumLargeDisaster>=1)
gen donor               =(sumLargeDisaster==0)

qui noi display "List of selected large disaster including multiple event per country"
list year wbcode LargeDisaster if LargeDisaster==1, sep(0)

* many of the biggest large disasters occur in same country
* identify countries with multiple disasters and pick the first.
* drop country's data after the 2nd disaster 
* ------------------------------------------

tab sumLargeDisaster
sort wbcode LargeDisaster year
by wbcode LargeDisaster: gen LargeDisasterOrder = _n
sort wbcode  year

gen  Year1stLargeDisaster=year if  LargeDisasterCountry==1 &  LargeDisaster==1 & LargeDisasterOrder==1
egen Year1stLargeDisasterFullColumn=max(Year1stLargeDisaster), by ( wbcode )

gen Year2ndLargeDisaster=year if  sumLargeDisaster>=2 &  LargeDisaster==1 & LargeDisasterOrder==2
egen Year2ndLargeDisasterFullColumn=max(Year2ndLargeDisaster), by ( wbcode )
drop if sumLargeDisaster>=2 & year>=Year2ndLargeDisasterFullColumn

drop if year>=2005
drop if year<=1967

* Identify relevant years for each country to give synth routine a balanced panel
* --------------------------------------------------------------------------------
egen InitialYear=min(year), by ( wbcode )
egen   FinalYear=max(year), by ( wbcode )

quietly{
noi display "List of selected large disasters"
noi display "Only first disaster from disaster prone countries"
}
list country year wbcode LargeDisaster if LargeDisaster==1, sep(0)

local    depvarlist  "gdppppcteci"
local  indepvarlist  "topen capital_sm landarea pop ieduc abs_lat POL2"
local  abadievarlist "`depvarlist' `indepvarlist'" 

gen HasAllRequiredData = 1

foreach var of local abadievarlist {

	gen ppseudo_`var' = `var'
	replace ppseudo_`var' = . if year >=  Year1stLargeDisasterFullColumn
	egen MaxDataOn_`var' = max(ppseudo_`var'), by (wbcode)
    gen HasDataOn_`var' = (MaxDataOn_`var' !=.)
    replace HasAllRequiredData = HasAllRequiredData*(HasDataOn_`var'==1)

}

drop if LargeDisasterCountry==1 & HasAllRequiredData==0

quietly{
noi di
noi di "Final list of selected large disasters"
noi di "Only first disaster from disaster prone countries"
noi di "Only large disasters occuring in countries that have all required data for analysis"
noi di "-----------------------------------------------------------------------------------"
noi list country year wbcode LargeDisaster if LargeDisaster==1, sep(0) nolab
noi di
count if LargeDisasterCountry==1 & HasAllRequiredData==1 & year== Year1stLargeDisasterFullColumn
local N_LD = r(N)
noi di "There are " `N_LD' " large disasters ready for event study analysis"
}


* ---------------------
* Abadie Style Analysis
* ---------------------
encode wbcode, generate(myid)
save dataforabadie_`measure'_`Dtail'.dta , replace
preserve
keep year wbcode myid country
keep if  year==1968
save countrynames_`measure'_`Dtail'.dta , replace
restore

mkmat myid year InitialYear FinalYear if LargeDisaster==1, matrix(LD)

preserve
clear
svmat LD
save LD_`measure'_`Dtail'.dta, replace
restore

forvalues ld = 1 / `N_LD' {

	use  dataforabadie_`measure'_`Dtail'.dta, clear
	drop if year>=2005
	drop if year<=1967

	local mytrunit = LD[`ld',1]
	local mytryear = LD[`ld',2]
    local myinyear = LD[`ld',3]
	local myfiyear = LD[`ld',4]

	drop if donor==0 & myid != `mytrunit'
	drop if myid==.

    keep if year>= `myinyear'
	keep if year<= `myfiyear'
	
	* make balanced panel
	* -------------------

	gen ones=1
	egen howmanyperiods=sum(ones), by (myid)
	drop if howmanyperiods < `myfiyear'-`myinyear'+1
      
	local    depvarlist  "gdppppcteci"
	local  indepvarlist  "topen capital_sm landarea pop ieduc abs_lat POL2"
	local  abadievarlist "`depvarlist' `indepvarlist'" 

	gen HasAllRequiredVariables = 1
	foreach var of local abadievarlist {
		 gen pseudo_`var' = `var'
		 replace pseudo_`var' = . if year >= `mytryear'
		 egen MaxVariable_`var' = max (pseudo_`var'), by (wbcode)
	     gen HasVariable_`var' = (MaxVariable_`var' !=.)
      	 replace HasAllRequiredVariables = HasAllRequiredVariables*(HasVariable_`var'==1)
	}

	drop if donor==1 & HasAllRequiredVariables==0

	local endofMSPE = 1969 + floor((`mytryear'-1969)/2)
	local MSPEyears = `endofMSPE' - 1969 + 1
    local mydepvarlist = "gdppccteus"
	gen HasAllRequiredDepVariables = 1	

	foreach mydepvar of local mydepvarlist {
       	drop ones
		gen ones=0
		replace ones =1 if `mydepvar' != . & donor==1 & year>=1969 & year<=`endofMSPE'
		egen sumones = sum(ones), by (wbcode)
     	replace HasAllRequiredDepVariables = HasAllRequiredDepVariables*(sumones==`MSPEyears')
	}

	list year wbcode if donor==1 & HasAllRequiredDepVariables==0
	drop if donor==1 & HasAllRequiredDepVariables==0
	
	* Declare the dataset as panel:
	* -----------------------------

 	 tsset myid year

    local    depvarlist "gdppccteus"
	local  indepvarlist "topen capital_sm landarea pop ieduc abs_lat POL2"
	
	di "---------------------------------"
	di "event study # " `ld' " for myid="  `mytrunit'
	di "matching from 1969 to "`endofMSPE'
	di "---------------------------------"
	list wbcode if donor==0

	* Compute treatment effects
	* -------------------------

	save DataForMatlab_`measure'_`Dtail'_`ld'.dta, replace
	preserve
		keep myid
		duplicates drop
		list, sep(0) nolab
		save placebosfor_`measure'_P`tail'_`ld'_MATRIX.dta, replace  /* includes treated unit */
		drop if myid==`mytrunit'
		save placebosfor_`measure'_P`tail'_`ld'_LIST.dta, replace   /*  does not include treated unit, only placebos for it */
	restore
  	foreach depvar of local depvarlist {

		di "=========="
		di "ld=`ld'"
		di "depvar=`depvar'"
		di "indepvarlist=`indepvarlist'"
		di "mytrunit=`mytrunit'"
		di "mytryear=`mytryear'" 
		di "endofMSPE=`endofMSPE'" 
		di "=========="

  		synth `depvar' `indepvarlist' `depvar'(1969(1)`endofMSPE'), nested trunit(`mytrunit') trperiod(`mytryear') keep(P`tail'_`measure'_`depvar'_`ld') replace
		

		
		use placebosfor_`measure'_P`tail'_`ld'_MATRIX, clear
		mkmat  myid , matrix(placebosfor_`measure'_P`tail'_`ld'_MATRIX)
		
		use placebosfor_`measure'_P`tail'_`ld'_LIST, clear
		mkmat  myid , matrix(placebosfor_`measure'_P`tail'_`ld'_LIST)
			
       	use DataForMatlab_`measure'_`Dtail'_`ld'.dta, clear
	
	    local NPlacebos = rowsof(placebosfor_`measure'_P`tail'_`ld'_LIST)

		forvalues p = 1/`NPlacebos'{

			local num = placebosfor_`measure'_P`tail'_`ld'_LIST[`p',1]
			synth `depvar' `indepvarlist' `depvar'(1969(1)`endofMSPE'), trunit(`num') trperiod(`mytryear') keep(P`tail'_`measure'_`depvar'_`ld'_`num') replace
		}
  	}


	* Export Data for Excel Graphs
	* ----------------------------

    local    depvarlist "gdppccteus"
	local  indepvarlist "topen capital_sm landarea pop ieduc abs_lat POL2"
  
	* Rename Synth Output for all Dependent Variables
	* -----------------------------------------------
	
  	foreach depvar of local depvarlist {

		forvalues p = 0/`NPlacebos'{
			if `p'==0 {
				local num = 0
			}
			else {
				local num = placebosfor_`measure'_P`tail'_`ld'_LIST[`p',1]
			}

			di "`depvar'"
			di `ld'
			if `num'==0 {
				use P`tail'_`measure'_gdppccteus_`ld'.dta      , clear
			}
			else        {
				use P`tail'_`measure'_gdppccteus_`ld'_`num'.dta, clear
			}
	  		drop _Co_Number _W_Weight
  			rename  _Y_treated   `depvar'_`mytrunit'_PL`num'
	  		rename  _Y_synthetic `depvar'_`mytrunit'_PL`num'_synth
  			rename _time year
  			drop if year==.
  			gen tretyear_`mytrunit'=`mytryear'
			gen YearsFromLD = year-tretyear_`mytrunit'
      	    gen  `depvar'_`mytrunit'_PL`num'atT0   =     `depvar'_`mytrunit'_PL`num' if YearsFromLD==0
	     	egen `depvar'_`mytrunit'_PL`num'atT0_F = max(`depvar'_`mytrunit'_PL`num'atT0) 
	        gen  `depvar'_`mytrunit'_PL`num'_100 = (`depvar'_`mytrunit'_PL`num'/`depvar'_`mytrunit'_PL`num'atT0_F)
      	    gen  `depvar'_`mytrunit'_PL`num'synth_100 = (`depvar'_`mytrunit'_PL`num'_synth/`depvar'_`mytrunit'_PL`num'atT0_F)
  			sort YearsFromLD
	    	save P`tail'_`measure'_`depvar'_formerge_`ld'_`num'.dta , replace

		}
  	}
	

	* Merge All Placebos
	* --------------------------------------------
	use  P`tail'_YearsFromLD.dta , clear
	local depvarlist "gdppccteus"

	
	foreach depvar of local depvarlist {
		
		forvalues p = 0/`NPlacebos'{
		
			if `p'==0 {
				local num = 0
			}
			else {
				local num = placebosfor_`measure'_P`tail'_`ld'_LIST[`p',1]
			}
			
	  		merge YearsFromLD using P`tail'_`measure'_`depvar'_formerge_`ld'_`num'.dta 
			
    		drop _merge
    		sort YearsFromLD

		}
  	}
  
  	save           `disastersPATH'\synthresults_merged_`ld'_`Dtail'.dta, replace
  	outsheet using `disastersPATH'\synthresults_merged_`ld'_`Dtail'.out, replace

	clear


}


* Collapse  All Results to be read by graph & significance do-files
* -----------------------------------------------------------------

use  P`tail'_YearsFromLD.dta,replace
save synthresults_merged_`measure'_`Dtail'.dta, replace
 
  local    depvarlist "gdppccteus"

  forvalues ld = 1 / `N_LD' {

		preserve
	    use placebosfor_`measure'_P`tail'_`ld'_LIST, clear
		mkmat  myid , matrix(placebosfor_`measure'_P`tail'_`ld'_LIST)
		local NPlacebos = rowsof(placebosfor_`measure'_P`tail'_`ld'_LIST)
		restore

		local mytrunit = LD[`ld',1]
		local mytryear = LD[`ld',2]
     	local myinyear = LD[`ld',3]
		local myfiyear = LD[`ld',4]

 		merge YearsFromLD using synthresults_merged_`ld'_`Dtail'.dta
 		drop _merge

 		foreach depvar of local depvarlist {

			forvalues p = 0/`NPlacebos'{

				if `p'==0 {
					local num = 0
				}
				else {
					 local num = placebosfor_`measure'_P`tail'_`ld'_LIST[`p',1]
				}
		
 			gen diff_`depvar'_`mytrunit'_PL`num'          =      `depvar'_`mytrunit'_PL`num' - `depvar'_`mytrunit'_PL`num'_synth             	
			gen diff_`depvar'_`mytrunit'_PL`num'atT0      = diff_`depvar'_`mytrunit'_PL`num'  if YearsFromLD==0
		    egen diff_`depvar'_`mytrunit'_PL`num'atT0_F = max(diff_`depvar'_`mytrunit'_PL`num'atT0) 
            gen diff_100_`depvar'_`mytrunit'_PL`num'      =    (diff_`depvar'_`mytrunit'_PL`num'/diff_`depvar'_`mytrunit'_PL`num'atT0_F)

			}
 		}
 		sort YearsFromLD

}

save           synthresults_merged_`measure'_`Dtail'.dta, replace
outsheet using synthresults_merged_`measure'_`Dtail'.out, replace

log close


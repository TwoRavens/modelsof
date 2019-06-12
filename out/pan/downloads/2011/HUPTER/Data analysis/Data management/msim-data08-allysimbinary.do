
* Open log 
**********
capture log close
log using "Data analysis\Data management\msim-data08-allysimbinary.log", replace


* ***********************************************************************************************************
* Generates component variables for calculation of similarity measures based on binary alliance relationships
* ***********************************************************************************************************

* Programme:	msim-data08-allysimbinary.do
* Project:		Measuring similarity
* Author:		Frank Haege, Department of Politics and Administration, University of Limerick
* Contact:		frank.haege@ul.ie

* Description
*************
* This do-file generates the component variables for the calculation of various similarity measures based on binary alliance relationships.
* In the process, the yearly socio-matrices of binary alliance relationships are transformed into undirected dyadic datasets.


* Set up Stata
**************
version 11
clear all
macro drop _all
set linesize 80
set more off


* Generate datasets with component variables for calculation of similarity measures for individual years
********************************************************************************************************

foreach year of numlist 1816/2000 {

	
	* Generate a dataset for the respective year
	********************************************
	
	* Load dataset of the respective year
	use "Datasets\Derived\Individual years\Alliances\Binary\msim-data04b-allybinary-`year'.dta", clear
	
	* Generate temporary filename
	tempname sim
	
	* Define variables and generate dataset
	postfile `sim' /*
		*/ year nobs tnobs str3 cabb1 str3 cabb2 s1 s2 /*
		*/ ss1 ss2 m1 m2 var1 var2 /*
		*/ ssdmv1 ssdmv2 spdmv ssdmv sad sadw sadwm ssd ssdw ssdwm /*
		*/ mt ssdmt1 ssdmt2 spdmt /*
		*/ using "Datasets\Derived\Individual years\Alliances\Binary\Similarity\msim-data08-allysimbinary-`year'.dta", replace
	
	
	* Loop through all country pairs in the respective year
	*******************************************************
	
	* Generate country abbreviation list for loop through country variables
	unab varlist : _all
	local cabblist : subinstr local varlist "year cabb ccode matcap " ""
	
	* Loop through all possible combinations of country pairs
	foreach country1 of local cabblist {
		foreach country2 of local cabblist {
			
			* Generate component variables for calculation of similarity
			************************************************************
			
			* Generate year variable
			local year = `year'
			
			* Generate possible total number of observations
			qui describe
			local tnobs = r(N)
			
			* Generate country abbreviation variables
			local cabb1 `country1'
			local cabb2 `country2'
			
			* Generate non-missing value indicator
			generate nonmiss = 0
			replace nonmiss = 1 if `cabb1' ~= . & `cabb2' ~= .
			
			* Generate number of non-missing observations
			qui sum nonmiss
			local nobs = r(sum)
			
			* Generate sum of variable values: sum(X)
			qui sum `cabb1' if nonmiss == 1
			local s1 = r(sum)
			qui sum `cabb2' if nonmiss == 1
			local s2 = r(sum)
			
			* Generate sum of squared values of variables: sum(X^2)
			generate ss1 = `cabb1'^2 if nonmiss == 1
			qui sum ss1
			local ss1 = r(sum)
			generate ss2 = `cabb2'^2 if nonmiss == 1
			qui sum ss2
			local ss2 = r(sum)
			
			* Generate mean of variable values: [sum(X)]/N
			local m1 = `s1'/`nobs'
			local m2 = `s2'/`nobs'
			
			* Generate sum of absolute differences: sum[abs(X-Y)]
			generate sad = abs(`cabb1'-`cabb2') if nonmiss == 1
			qui sum sad
			local sad = r(sum)
			
			* Generate sum of weighted absolute differences: sum[weight*abs(X-Y)]
			generate sadw = matcap*abs(`cabb1'-`cabb2') if nonmiss == 1
			qui sum sadw
			local sadw = r(sum)
			
			* Generate weighted sum of maximum absolute difference: sum[weight*1]
			generate sadwm = matcap if nonmiss == 1
			qui sum sadwm
			local sadwm = r(sum)
			
			* Generate sum of squared differences: sum[(X-Y)^2]
			generate ssd = (`cabb1'-`cabb2')^2 if nonmiss == 1
			qui sum ssd
			local ssd = r(sum)
			
			* Generate sum of weighted squared differences: sum[weight*(X-Y)^2]
			generate ssdw = matcap*((`cabb1'-`cabb2')^2) if nonmiss == 1
			qui sum ssdw
			local ssdw = r(sum)
			
			* Generate sum of weighted maximum squared difference: sum[(weight*1)^2]
			generate ssdwm = matcap if nonmiss == 1
			qui sum ssdwm
			local ssdwm = r(sum)
			
			* Generate variances: sum[(X-Y)^2]/N
			generate var1 = (`cabb1'-`m1')^2 if nonmiss == 1
			qui sum var1
			local var1 = r(sum)/`nobs'
			generate var2 = (`cabb2'-`m2')^2 if nonmiss == 1
			qui sum var2
			local var2 = r(sum)/`nobs'
			
			
			* Generate additional component variables for the calculation of Cohen's kappa
			******************************************************************************
			
			* Generate sum of squared deviations from the variable mean: sum[(X-Xmean)^2]
			generate ssdmv1 = (`cabb1'-`m1')^2 if nonmiss == 1
			qui sum ssdmv1
			local ssdmv1 = r(sum)
			generate ssdmv2 = (`cabb2'-`m2')^2 if nonmiss == 1
			qui sum ssdmv2
			local ssdmv2 = r(sum)
			
			* Generate sum of products of deviations from the variable means: sum[(X-Xmean)*(Y-Ymean)]
			generate spdmv = (`cabb1'-`m1')*(`cabb2'-`m2') if nonmiss == 1
			qui sum spdmv
			local spdmv = r(sum)
			
			* Generate sum of squared differences in variable means: sum[(Xmean-Ymean)^2]
			local ssdmv = `nobs' * (`m1'-`m2')^2
			
			
			* Generate additional component variables for the calculation of Scott's pi
			***************************************************************************
			
			* Generate total mean: sum[(X+Y)]/(2*N)
			generate mt = `cabb1'+`cabb2' if nonmiss == 1
			qui sum mt
			local mt = r(sum)/(2*`nobs')
			
			* Generate sum of squared deviations from the total mean: sum[(X-Mean)^2]
			generate ssdmt1 = (`cabb1'-`mt')^2 if nonmiss == 1
			qui sum ssdmt1
			local ssdmt1 = r(sum)
			generate ssdmt2 = (`cabb2'-`mt')^2 if nonmiss == 1
			qui sum ssdmt2
			local ssdmt2 = r(sum)
			
			* Generate sum of products of deviations from the total mean: sum[(X-Mean)*(Y-Mean)]
			generate spdmt = (`cabb1'-`mt')*(`cabb2'-`mt') if nonmiss == 1
			qui sum spdmt
			local spdmt = r(sum)
			
			
			* Save newly generated variables to file
			****************************************
			
			* Post new variable values into a row of the dataset
			post `sim' (`year') (`nobs') (`tnobs') ("`cabb1'") ("`cabb2'") (`s1') (`s2') /*
					*/ (`ss1') (`ss2') (`m1') (`m2') (`var1') (`var2') /*
					*/ (`ssdmv1') (`ssdmv2') (`spdmv') (`ssdmv') (`sad') (`sadw') (`sadwm') (`ssd') (`ssdw') (`ssdwm') /*
					*/ (`mt') (`ssdmt1') (`ssdmt2') (`spdmt') 
		
			* Drop auxiliary variables
			drop nonmiss-spdmt
	
		}
	}
	
	* Close the dataset
	postclose `sim'
	

	* Label variables
	*****************

	* Load dataset
	use "Datasets\Derived\Individual years\Alliances\Binary\Similarity\msim-data08-allysimbinary-`year'.dta", clear
	
	* Label variables
	label var year "Year"
	label var nobs "No. non-missing observations"
	label var tnobs "Total no. observations"
	label var cabb1 "Country 1"
	label var cabb2 "Country 2"
	label var s1 "Sum Var1"
	label var s2 "Sum Var2"
	label var ss1 "Sum squares Var1"
	label var ss2 "Sum squares Var2"
	label var m1 "Mean Var1"
	label var m2 "Mean Var2"
	label var var1 "Variance Var1"
	label var var2 "Variance Var2"
	label var ssdmv1 "SSD from var mean Var1"
	label var ssdmv2 "SSD from var mean Var2"
	label var spdmv "SPD from var means"
	label var ssdmv "SSD of var means"
	label var sad "SAD"
	label var ssd "SSD"
	label var sadw "SAD (weighted)"
	label var sadwm "Max SAD (weighted)"
	label var ssdw "SSD (weighted)"
	label var ssdwm "Max SSD (weighted)"
	label var mt "Total mean"
	label var ssdmt1 "SSD from total mean Var1"
	label var ssdmt2 "SSD from total mean Var2"
	label var spdmt "SPD from total mean"

	* Save dataset with labeled variables
	compress
	save "Datasets\Derived\Individual years\Alliances\Binary\Similarity\msim-data08-allysimbinary-`year'.dta", replace
	
}


* Exit do-file
log close
exit

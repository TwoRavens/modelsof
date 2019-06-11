****************************************************
***      Yusaku Horiuchi and Asher Mayerson      ***
***      "The Opportunity Cost of Conflict"      ***
***          Version: December 20, 2014          *** 
****************************************************

clear
set more off
set graph on
set more off

global data qog_std_ts_20Dec13
global cname "Israel"
global ccode 376
global outcome wdi_gdpc
global varname "Per Capita GDP"
global predictors wdi_exp wdi_imp pwt_openk pwt_csg pwt_isg bl_asy15mf 

global x $predictors $outcome 
global synthopt nested

capture mkdir _tempdata
capture mkdir _gph
capture mkdir _eps

capture log close
set logtype text
log using Horiuchi-Mayerson_PSRM.txt, replace

***************************************************
* Part 0: Make a Subset of Original Data          *
*         Note Run this only if you want to make  *
*         the smaller dataset using the original. *
***************************************************

capture program drop mysynth0
program define mysynth0
	use $data
	keep cname ccode year $outcome $predictors
	save Horiuchi-Mayerson_PSRM, replace
end
* mysynth0


************************
* Part 1: Prepare Data *
************************

capture program drop mysynth1
program define mysynth1

	clear
	set more off

	* Use QoG data (Subset)
	
	use Horiuchi-Mayerson_PSRM
	
	* Select year
	
	keep if year>=`1' & year<=`3'

	* Predictors are averaged from `1' (1980) to `2'-1 (1999), a year before the intervention
	
	foreach i of varlist $predictors{
		egen `i'_mean=mean(`i'*(year>=`1' & year<=(`2'-1))), by(ccode)
		replace `i'=`i'_mean
		drop `i'_mean
	}
		
	* Select OECD countries + $cname

	gen oecd=0
	replace oecd=1 if cname=="Austria"  /* 1961 */
	replace oecd=1 if cname=="Belgium"  /* 1961 */
	replace oecd=1 if cname=="Canada"  /* 1961 */
	replace oecd=1 if cname=="Denmark"  /* 1961 */
	replace oecd=1 if cname=="France (1963-)"  /* 1961 */
	replace oecd=1 if cname=="Germany"  /* 1961 */
	replace oecd=1 if cname=="Greece"  /* 1961 */
	replace oecd=1 if cname=="Iceland"  /* 1961 */
	replace oecd=1 if cname=="Ireland"  /* 1961 */
	replace oecd=1 if cname=="Luxembourg"  /* 1961 */
	replace oecd=1 if cname=="Netherlands"  /* 1961 */
	replace oecd=1 if cname=="Norway"  /* 1961 */
	replace oecd=1 if cname=="Portugal"  /* 1961 */
	replace oecd=1 if cname=="Spain"  /* 1961 */
	replace oecd=1 if cname=="Sweden"  /* 1961 */
	replace oecd=1 if cname=="Switzerland"  /* 1961 */
	replace oecd=1 if cname=="Turkey"  /* 1961 */
	replace oecd=1 if cname=="United Kingdom"  /* 1961 */
	replace oecd=1 if cname=="United States"  /* 1961 */
	replace oecd=1 if cname=="Italy"  /* 1962 */
	replace oecd=1 if cname=="Japan"  /* 1964 */
	replace oecd=1 if cname=="Finland"  /* 1969 */
	replace oecd=1 if cname=="Australia"  /* 1971 */
	replace oecd=1 if cname=="New Zealand"  /* 1973 */
	replace oecd=1 if cname=="Mexico"  /* 1994 */
	replace oecd=1 if cname=="Czech Republic"  /* 1995 */
	replace oecd=1 if cname=="Hungary"  /* 1996 */
	replace oecd=1 if cname=="Korea, South"  /* 1996 */
	replace oecd=1 if cname=="Poland"  /* 1996 */
	replace oecd=1 if cname=="Slovakia"  /* 2000 */
	replace oecd=1 if cname=="Chile"  /* 2010 */
	replace oecd=1 if cname=="Estonia"  /* 2010 */
	replace oecd=1 if cname=="Israel"  /* 2010 */
	replace oecd=1 if cname=="Slovenia"  /* 2010 */

	keep if oecd==1 | ccode==$ccode
	drop oecd
	
	* Select countries with "similar" level of per capita GDP 
	
	egen temp=mean($outcome * (year>=`1' & year<=(`2'-1) ) ), by(ccode)
	sum temp if cname=="$cname"
	keep if temp<1.50*r(mean) & temp>0.50*r(mean)
	drop temp

	* Drop countries with missing values in $outcome

	local obs=`3'-`1'+1
	egen temp=count($outcome), by(ccode)
	keep if temp==`obs'
	drop temp
		
	* Save data for analysis
	
	if "`4'"==""{
		save _tempdata/data_`1'_`2'_`3'_all, replace
	}
	else if "`4'"!=""{
		drop if ccode==`4'
		save _tempdata/data_`1'_`2'_`3'_except`4', replace
	}	
	
end

* 1: Start Year
* 2: Intervention Year
* 3: End Year
* 4: with or without leave-one-out

mysynth1 1980 2000 2005
mysynth1 1980 2000 2005 36
mysynth1 1980 2000 2005 56
mysynth1 1980 2000 2005 300
mysynth1 1980 2000 2005 410
mysynth1 1980 2000 2005 554
mysynth1 1980 1993 2000
mysynth1 1980 2000 2010

*********************************************************
* Part 2: Main Graph + In-Time Placebos + Leave-One-Out *
*********************************************************
	
capture program drop mysynth2
program define mysynth2

	use _tempdata/data_`1'_`2'_`3'_`4', clear
		
	synth $outcome $x, tru($ccode) trp(`2') keep(_tempdata/synth_`1'_`2'_`3'_`4', replace) $synthopt
	
	use _tempdata/synth_`1'_`2'_`3'_`4', clear
	gen diff_0=_Y_treated-_Y_synthetic

	#delimit;
		twoway
		(line _Y_treated   _time, lcolor(gs0))
		(line _Y_synthetic _time, lcolor(gs12))
		,
		legend(off)
		xline(`2', lpattern(dash))
		xlab(`1' `2' `3')
		title("`5'")
		xtitle("Year")
		ytitle("$varname")
		saving(_gph/Figure1_`1'_`2'_`3'_`4'_`6', replace);
	#delimit cr

end

* 1: Start Year
* 2: Intervention Year
* 3: End Year
* 4: with or without leave-one-out* 
* 5: Graph Title
* 6: File Name Addition (only for the main analysis) 

mysynth2 1980 2000 2005 "all" "" a
mysynth2 1980 2000 2005 "all" "Without Leave-One-Out" b
mysynth2 1980 2000 2005 "except36" "Leave-One-Out (Australia)"
mysynth2 1980 2000 2005 "except56" "Leave-One-Out (Belgium)"
mysynth2 1980 2000 2005 "except300" "Leave-One-Out (Greece)"
mysynth2 1980 2000 2005 "except410" "Leave-One-Out (South Korea)"
mysynth2 1980 2000 2005 "except554" "Leave-One-Out (New Zealand)"
mysynth2 1980 1993 2000 "all"
mysynth2 1980 2000 2010 "all"

**********************************
* Part 3: In-Space Placebo Study *
**********************************

capture program drop mysynth3
program define mysynth3

 	use _tempdata/synth_`1'_`2'_`3'_`4', clear
	gen diff_0=_Y_treated-_Y_synthetic
	keep _time diff_0
	drop if _time==.
	sort _time
	save _tempdata/temp_placebo, replace

	use _tempdata/data_`1'_`2'_`3'_`4', clear

	egen countryid=group(ccode)
	sum countryid
	global num=r(max)
	tsset countryid year

	sort countryid
	outsheet countryid cname using _tempdata/temp_id.csv if countryid~=countryid[_n-1], comm replace
	
	save _tempdata/temp_all, replace

	global linecommand " "

	local i=1
	while `i'<=$num{
		di "`i'"
		quietly{
			use _tempdata/temp_all, clear
	
			qui synth $outcome $x, tru(`i') trp(`2') keep(_tempdata/temp_synth, replace) $synthopt

			local x=trace(e(RMSPE))

			n di "*****************"
			n di "CCODE = " `i'
			n di "RMSPE = " `x'
			n di "*****************"

			use _tempdata/temp_synth, clear	
			gen diff_`i'=_Y_treated-_Y_synthetic
			keep _time diff_`i'
			drop if _time==.
			sort _time
			save _tempdata/temp_synth, replace		
			use _tempdata/temp_placebo, clear
			merge 1:1 _time using _tempdata/temp_synth
			drop _merge
			global linecommand "$linecommand (line diff_`i' _time, lcolor(gs12 ..))"
			save _tempdata/temp_placebo, replace

		}	
		local i=`i'+1
	}

	// GRAPH 1 //
	
	use _tempdata/temp_placebo, clear

	#delimit;
		twoway
		$linecommand
		(line diff_0 _time, lcolor(gs0))
		,
		xline(`2', lpattern(dash))
		xlab(`1' `2' `3')
		xtitle("Year")
		ytitle("Gap in $varname")
		legend(off)
		saving(_gph/Figure2_`1'_`2'_`3'_`4', replace);
	#delimit cr

	// GRAPH 2 //
	
	reshape long diff_, i(_time) j(x)
	sort x _time
	
	gen after=(_time>`2')
	
	gen SPE=((diff_)^2)
	egen MSPE=mean(SPE), by(x after)

	sort x after
	keep if after~=after[_n-1]
	keep x after MSPE
	gen ratio=ln(MSPE/MSPE[_n-1]) if x==x[_n-1]
	
	keep if ratio~=.
	sort x
	rename x countryid
	sort countryid
	save _tempdata/temp, replace
	insheet using _tempdata/temp_id.csv, comma clear
	sort countryid
	merge 1:1 countryid using _tempdata/temp
	drop if countryid==0
	drop _merge
	sort ratio

	drop if ratio==.

	gsort -ratio
	gen rank=_n
	
	sum rank if cname=="$cname"
	local temp1=r(mean)
	sum rank
	local temp2=r(max)
	local temp3=r(min)

	#delimit;
	tw 	(scatter ratio rank if cname=="$cname", mlabel(cname) mlabpo(1))  
		(scatter ratio rank if cname~="$cname", msymbol(oh))
		, 
		legend(off) 
		ytitle("Post-Treatment MSPE / Pre-Treatment MSPE (in log)")
		xtitle("Rank (Largest to Smallest)")
		xlab(`temp1' `temp2' `temp3') 
		saving(_gph/Figure3_`1'_`2'_`3'_`4', replace)
		;
	#delimit cr

	capture erase _tempdata/temp_all.dta
	capture erase _tempdata/temp_placebo.dta
	capture erase _tempdata/temp.dta
	capture erase _tempdata/temp_synth.dta
	capture erase _tempdata/temp_id.csv
	
end

* 1: Start Year
* 2: Intervention Year
* 3: End Year
* 4: with or without leave-one-out

mysynth3 1980 2000 2005 "all"

***********************************************
* Part 4: Format Figures and Save them in EPS *
***********************************************

clear

graph use _gph/Figure1_1980_2000_2005_all_a.gph
graph display, ysize(5) xsize(5) scheme(s2color)
graph export _eps/Figure1.eps, replace

graph combine _gph/Figure2_1980_2000_2005_all.gph _gph/Figure3_1980_2000_2005_all.gph, cols(2)
graph display, ysize(5) xsize(5) scheme(s2color)
graph export _eps/FigureA1.eps, replace

graph use _gph/Figure1_1980_1993_2000_all_.gph
graph display, ysize(5) xsize(5) scheme(s2color)
graph export _eps/FigureA2.eps, replace

#delimit;
graph combine 
	_gph/Figure1_1980_2000_2005_all_b.gph
	_gph/Figure1_1980_2000_2005_except36_.gph
	_gph/Figure1_1980_2000_2005_except56_.gph
	_gph/Figure1_1980_2000_2005_except300_.gph
	_gph/Figure1_1980_2000_2005_except410_.gph
	_gph/Figure1_1980_2000_2005_except554_.gph
	, ycomm cols(2);
#delimit cr
graph display, ysize(6) xsize(5) scheme(s2color) scale(0.8)
graph export _eps/FigureA3.eps, replace

graph use _gph/Figure1_1980_2000_2010_all_.gph
graph display, ysize(5) xsize(5) scheme(s2color)
graph export _eps/FigureA4.eps, replace

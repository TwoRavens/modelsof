*******************************************************************************
*** Description: 	This document provides the code for reproducing the 	***
***					tables in Study 2 of the paper, "Compulsory Voting		***
***					and PartiesÕ Vote Seeking Strategies," which is			***
***					authored by Shane P. Singh and appears in the American	***
***					Journal of Political Science. 							***
***					It also provides the for reproducing the tables and		***
***					figures associated with Study 2 in the appendix.		***
*******************************************************************************



**************
**************
*Set the Version and Install Any Needed User-Written Commands                                                                                                                                  
**************
**************
version 13.1
ssc install synth //*Install the "Synthetic control methods for comparative case studies" package, authored by Jens Hainmueller, Alberto Abadie, and Alexis Diamond



**************
**************
*Reopen the Varieties of Democracy Version 7 Data, which First Needs to be Prepared in "V-Dem Preparation.do"                                                                                                                         
**************
**************
use "V-Dem_AJPS_Replication.dta", clear

	
	
**************
**************
*Remove Observations Missing Data on the Programmatism Scale                                                                                                                      
**************
**************	
drop if v2psprlnks_0_10 == .



**************
**************
*Set Temporal Range to be the Same as That for Thailand in Study 1                                                                                                                    
**************
**************	
drop if year>=2014 //*Thailand is not observed past 2013 in Study 1.
drop if year <1972 //*Thailand is not observed before 1973 in Study 1. Year 1972 drops out below after the creation of the change in programmatism variable. 

	

	
**************
**************
*Remove Observations Flagged by V-Dem                                                                                                                       
**************
**************
drop if v2psprlnks_nr <=3 & year >=2013 //*A cautionary note in the Version 7 codebook says not to use point estimates for country-variable-years with three or fewer (<=3) ratings for the period 2013-2016.

	
	
**************
**************
*Remove Observations for Country-Years with Compulsory Voting (aside from Thailand)                                                                                                                       
**************
**************	
tabulate country, gen(countrydummy)
gen CV_ever = .
foreach x of varlist countrydummy* {
	sum v2elcomvot_any  if `x' == 1 
	replace CV_ever =  r(mean) if `x' == 1
	}
drop if CV_ever > 0 & country ~= "Thailand"
drop if CV_ever == . 
drop CV_ever countrydummy*



**************
**************
*Create a Variable that Captures the Change in Programmatism                                                                                                                      
**************
**************	
sort cntrynum year
bysort cntrynum: gen lag_v2psprlnks_0_10 = v2psprlnks_0_10[_n-1] 
gen delta_v2psprlnks_0_10 = v2psprlnks_0_10 - lag_v2psprlnks_0_10
keep if delta_v2psprlnks_0_10 ~= . //*remove observations that are missing on this measure 


	
**************
**************
*Remove All Donor Countries That Are Not Observed for the Same Years as Thailand                                                                                                                   
**************
**************	
bysort cntrynum: egen sum  = sum(year) 
summarize sum
drop if sum ~= r(max)
drop sum




**************
**************
*Declare the Data to be Time-Series Cross-Sectional                                                                                                             
**************
**************	
tsset cntrynum year



**************
**************
*Save Thailand's Identifying Number Into Memory to Be Called Up Later                                                                                                           
**************
**************
sum cntrynum if country ==  "Thailand" 
global Thailand_Number_A = r(max)




**************
**************
*Figure 2 (and Appendix Section 7, Table A4: Synthetic Control Donor Countries and Weights)
**************
**************
		
		                                                                                                           
**************
**************
cd "synthetic control files" //*set working directory to a folder to store files that will be called back later. You need to create this folder first. Be sure to create it within the folder in which you have stored the data files. 

synth v2psprlnks_0_10  v2psprlnks_0_10  delta_v2psprlnks_0_10  /// *The weights shown in Table A4 are listed with this command.
				, 	trunit($Thailand_Number_A) trperiod(1997)  ///
					keep(v2psprlnks_0_10_synthetic_Thai, replace)

preserve
use "v2psprlnks_0_10_synthetic_Thai.dta", clear
					
twoway line _Y_treated _time, lcolor(black) lwidth(medthick) || line _Y_synthetic _time, lcolor(gs9) ///
		|| pci 2 1996 6 1996, lcolor(red) lwidth(medthin) /// use pci too because xline and yline go under other graphics
		|| pci 2 2001 6 2001, lcolor(blue) lwidth(medthin) /// use pci too because xline and yline go under other graphics
		, ///
		xline(1996,  lcolor(red) lwidth(medthin)) ///
		xline(2001,  lcolor(blue) lwidth(medthin)) ///
		legend(on order(1 "Thailand" 2 "Synthetic Thailand") rows(2) size(vsmall) ring(0) position(11) rowgap(zero) colgap(zero) keygap(zero) bmargin(zero) region(margin(zero) lwidth(medium))) ///
		xtitle(Year, size(medsmall)) ytitle(Level of Programmatism, size(medsmall)) ///
		xsize(4.5) scheme(s1mono) 	///
		ylabel(, labsize(small)) ///
		xlabel(, labsize(small)) ///
		text(2.2 1995.5 "Last Thai Election Before CV", orient(vertical) align(baseline) size(tiny)) ///
		text(2.2 2000.5 "First Thai Election After CV    ", orient(vertical) align(baseline) size(tiny))
		

restore
	
	
	
**************
**************
*Evidence for Claim Made in the Footnotes: "As is common (e.g., Fowler 2013; Heersink, Peterson, and Jenkins 2017), results are substantively insensitive to the incorporation of other variables into the weighting algorithm."
**************
**************	
*Match on level and trend in partiesÕ programmatic vote seeking tactics, as done in Figure 2.
synth v2psprlnks_0_10  v2psprlnks_0_10  delta_v2psprlnks_0_10  /// 
				, 	trunit($Thailand_Number_A) trperiod(1997)  ///
					figure 		
		
*incorporate federalism
synth v2psprlnks_0_10  v2psprlnks_0_10  delta_v2psprlnks_0_10 federal  /// 
				, 	trunit($Thailand_Number_A) trperiod(1997)  ///
					figure 
					
*incorporate Latin dummy
synth v2psprlnks_0_10  v2psprlnks_0_10  delta_v2psprlnks_0_10 latin  /// 
				, 	trunit($Thailand_Number_A) trperiod(1997)  ///
					figure 

*incorporate rule of law
synth v2psprlnks_0_10  v2psprlnks_0_10  delta_v2psprlnks_0_10 v2cltrnslw  /// 
				, 	trunit($Thailand_Number_A) trperiod(1997)  ///
					figure 
					
					
*incorporate federalism, Latin dummy, and rule of law					
synth v2psprlnks_0_10  v2psprlnks_0_10  delta_v2psprlnks_0_10 federal latin v2cltrnslw  /// 
				, 	trunit($Thailand_Number_A) trperiod(1997)  ///
					figure 
					
					
					
**************
**************
*Evidence for Claim Made in the Text: "In the post-intervention period, the level of programmatism averages 3.81 in Synthetic Thailand, and in real Thailand it averages 6.01."
**************
**************
preserve
use "v2psprlnks_0_10_synthetic_Thai.dta", clear
sum _Y_treated  if _time>1997	
sum _Y_synthetic  if _time>1997	
restore
	
	
**************
**************
*Figure 3                                                                                                            
**************
**************	
preserve
use "v2psprlnks_0_10_synthetic_Thai.dta", clear
		
gen tr_effect = _Y_treated - _Y_synthetic 

twoway line tr_effect _time, lcolor(black) lwidth(medthick) ///
		|| pci -3 1996 3 1996, lcolor(red) lwidth(medthin) /// 
		|| pci -3 2001 3 2001, lcolor(blue) lwidth(medthin) /// 
		, ///
		xline(1996,  lcolor(red) lwidth(medthin)) ///
		xline(2001,  lcolor(blue) lwidth(medthin)) ///
		yline(0, 	 lcolor(gs9) lwidth(thin)) ///
		legend(off) ///
		xtitle(Year, size(medsmall)) ytitle("Gap in Level of Programmatism" "Between Thailand and Synthetic Thailand", size(medsmall)) ///
		xsize(4.5) scheme(s1mono) 	///
		ylabel(-3(1)3, labsize(small)) ///
		xlabel(, labsize(small)) ///
		text(-2.45 1995.5 "Last Thai Election Before CV", orient(vertical) align(baseline) size(tiny)) ///
		text(-2.45 2000.5 "First Thai Election After CV   ", orient(vertical) align(baseline) size(tiny))

restore



**************
**************
*Figure 4                                                                                                           
**************
**************	
*cd "synthetic control files" //*Execute this line if you are jumping into the code at this point.
encode country, gen(cntrynum_temp) //*Create a new numerical country identifier, as the current identifier is not sequential due to the above dropping of the countries with missing data.
sum cntrynum_temp  if country == "Thailand" //*Recover Thailand's number to use later in the graph code.
global Thailand_Number_B = r(max)
tsset cntrynum_temp year //*Declare the data to be time-series cross-sectional.
sum cntrynum_temp
global Total_Number_Thai =  r(max) //*Recover number of included countries to use later in the graph code.
global Total_Number_Plus1_Thai = $Total_Number_Thai + 1 //*Recover number of included countries + 1 to use later in the graph legend code.

*Loop through the synthetic control routine, assigning each country to (falsely) be the treated country.
forval i=1/$Total_Number_Thai{
synth v2psprlnks_0_10  v2psprlnks_0_10  delta_v2psprlnks_0_10  /// 
				, 	trunit(`i') trperiod(1997)  ///
					keep(v2psprlnks_0_10_synthetic_Thai_`i', replace)
matrix RMSPE =  e(RMSPE)
scalar RMSPE = RMSPE[1,1] //*Get the root mean squared prediction error.

preserve
use v2psprlnks_0_10_synthetic_Thai_`i', clear
gen RMSPE_`i' = RMSPE
gen MPSE_`i' = RMSPE_`i'^2  //*Get the mean squared prediction error.
save v2psprlnks_0_10_synthetic_Thai_`i', replace
restore
}

drop cntrynum_temp		
drop lag_v2psprlnks_0_10 delta_v2psprlnks_0_10


*Loop through all saved datasets and create the treatment effects. Also drop missing observations.
preserve
forval i=1/$Total_Number_Thai{
use v2psprlnks_0_10_synthetic_Thai_`i', clear
gen tr_effect_`i' = _Y_treated - _Y_synthetic
keep _time tr_effect_`i'  RMSPE_`i' MPSE_`i'
drop if missing(_time)
save v2psprlnks_0_10_synthetic_Thai_`i', replace
}
restore

		
*cd "synthetic control files" //*Execute this line if you are jumping into the code at this point.
*Load the first dataset and merge all of the additional datasets from the placebo analyses.
preserve
use v2psprlnks_0_10_synthetic_Thai_1, clear
forval i=2/$Total_Number_Thai{
merge 1:1 _time using v2psprlnks_0_10_synthetic_Thai_`i', nogenerate
}


*Discard placebo cases with MSPE more than two times higher than Thailand's.
sum MPSE_$Thailand_Number_B 
global threshold_2 = r(max)*2

forval i=1/$Total_Number_Thai{
replace tr_effect_`i' = . if MPSE_`i' > $threshold_2
}


*Create graph of the gaps for all placebo cases, with Thailand's gap overlayed.
local lp

forval i=1/$Total_Number_Thai {
   local lp `lp' line tr_effect_`i' _time, lcolor(gs14) ||
}

sum _time //*get the minimum and maximum year for the plot
global min = r(min)
global max = r(max)

twoway `lp' || line tr_effect_$Thailand_Number_B _time, lcolor(black) lwidth(medthick)  ///
		|| pci -3 1996 3 1996, lcolor(red) lwidth(medthin) /// 
		|| pci -3 2001 3 2001, lcolor(blue) lwidth(medthin) /// 
		|| pci  0 $min 0 $max, lcolor(gs9) lwidth(thin) /// 
		, ///
		xline(1996,  lcolor(red) lwidth(medthin)) ///
		xline(2001,  lcolor(blue) lwidth(medthin)) ///
		yline(0, 	 lcolor(gs9) lwidth(thin)) ///
		legend(on order($Total_Number_Plus1_Thai "Thailand" 1 "Other Countries") rows(2) size(vsmall) ring(0) position(7) rowgap(zero) colgap(zero) keygap(zero) bmargin(zero) region(margin(zero) lwidth(medium))) ///
		xtitle(Year, size(medsmall)) ytitle("Gap in Level of Programmatism" "Between Country{subscript:{it:j}} and Synthetic Country{subscript:{it:j}}", size(medsmall)) ///
		xsize(4.5) scheme(s1mono) 	///
		ylabel(-3(1)3, labsize(small)) ///
		xlabel(, labsize(small)) ///
		text(-2.45 1995.5 "Last Thai Election Before CV", orient(vertical) align(baseline) size(tiny)) ///
		text(-2.45 2000.5 "First Thai Election After CV     ", orient(vertical) align(baseline) size(tiny)) ///
		name(Thailand_with_placebos, replace)

		
restore
		

	
				
**************************************************************************************************
**************************************************************************************************
*Unless Otherwise Indicated, All Code Below Pertains to 
*Appendix Section 6, Figure A4: Programmatism Gaps for Treated and Placebo Countries
**************************************************************************************************
**************************************************************************************************					


**************
**************
*Reset the Working Directory                                                                                                                               
**************
**************
cd ".."

				
****************************
****************************
*First, Create the Upper-Right Panel (Japan)                                                                                                                     
****************************
****************************				
						
**************
**************
*Reopen the Varieties of Democracy Version 7 Data, which First Needs to be Prepared in "V-Dem Preparation.do"                                                                                                                         
**************
**************
use "V-Dem_AJPS_Replication.dta", clear
				
				
				
**************
**************
*Remove Observations Missing Data on the Programmatism Scale                                                                                                                      
**************
**************	
drop if v2psprlnks_0_10 == .



**************
**************
*Set Temporal Range to be the Same as That for Thailand the Analyses Depicted in Figures 2-4                                                                                                                  
**************
**************	
drop if year>=2014 
drop if year <1972  

	
	
**************
**************
*Remove Observations Flagged by V-Dem                                                                                                                       
**************
**************
drop if v2psprlnks_nr <=3 & year >=2013 //*A cautionary note in the Version 7 codebook says not to use point estimates for country-variable-years with three or fewer (<=3) ratings for the period 2013-2016.

	
	
**************
**************
*Remove Observations for Country-Years with a Parallel Electoral System (aside from Japan)                                                                                                                   
**************
**************	
tabulate country, gen(countrydummy)
gen parallel_ever = .
gen parallel = 0 
replace parallel = 1 if v2elloelsy == 5 //*v2elloelsy is an indicator from V-Dem that classifies countries by their lower chamber electoral systems
replace parallel = . if v2elloelsy == .
foreach x of varlist countrydummy* {
	sum parallel  if `x' == 1 
	replace parallel_ever =  r(mean) if `x' == 1
	}
drop if parallel_ever > 0 & country ~= "Japan"
drop if parallel_ever == .
drop  parallel parallel_ever countrydummy*



**************
**************
*Create a Variable that Captures the Change in Programmatism                                                                                                                      
**************
**************	
sort cntrynum year
bysort cntrynum: gen lag_v2psprlnks_0_10 = v2psprlnks_0_10[_n-1] 
gen delta_v2psprlnks_0_10 = v2psprlnks_0_10 - lag_v2psprlnks_0_10
keep if delta_v2psprlnks_0_10 ~= . //*remove observations that are missing on this measure 


	
**************
**************
*Remove All Donor Countries That Are Not Observed for the Same Years as Japan                                                                                                                   
**************
**************	
bysort cntrynum: egen sum  = sum(year) 
summarize sum
drop if sum ~= r(max)
drop sum




**************
**************
*Declare the Data to be Time-Series Cross-Sectional                                                                                                             
**************
**************	
tsset cntrynum year



**************
**************
*Create the Graph                                                                                                         
**************
**************	
cd "synthetic control files" 
encode country, gen(cntrynum_temp) //*Create a new numerical country identifier, as the current identifier is not sequential due to the above dropping of the countries with missing data.
sum cntrynum_temp  if country == "Japan" //*Recover Japan's number to use later in the graph code.
global Japan_Number_B = r(max)
tsset cntrynum_temp year //*Declare the data to be time-series cross-sectional.
sum cntrynum_temp
global Total_Number_Jap =  r(max) //*Recover number of included countries to use later in the graph code.
global Total_Number_Plus1_Jap = $Total_Number_Jap + 1 //*Recover number of included countries + 1 to use later in the graph legend code.

*Loop through the synthetic control routine, assigning each country to (falsely) be the treated country.
forval i=1/$Total_Number_Jap{
synth v2psprlnks_0_10  v2psprlnks_0_10  delta_v2psprlnks_0_10  /// 
				, 	trunit(`i') trperiod(1994)  ///
					keep(v2psprlnks_0_10_synthetic_Jap_`i', replace)
matrix RMSPE =  e(RMSPE)
scalar RMSPE = RMSPE[1,1] //*Get the root mean squared prediction error.

preserve
use v2psprlnks_0_10_synthetic_Jap_`i', clear
gen RMSPE_`i' = RMSPE
gen MPSE_`i' = RMSPE_`i'^2  //*Get the mean squared prediction error.
save v2psprlnks_0_10_synthetic_Jap_`i', replace
restore
}

drop cntrynum_temp		
drop lag_v2psprlnks_0_10 delta_v2psprlnks_0_10


*Loop through all saved datasets and create the treatment effects. Also drop missing observations.
preserve
forval i=1/$Total_Number_Jap{
use v2psprlnks_0_10_synthetic_Jap_`i', clear
gen tr_effect_`i' = _Y_treated - _Y_synthetic
keep _time tr_effect_`i'  RMSPE_`i' MPSE_`i'
drop if missing(_time)
save v2psprlnks_0_10_synthetic_Jap_`i', replace
}
restore

		
*cd "synthetic control files" //*Execute this line if you are jumping into the code at this point.
*Load the first dataset and merge all of the additional datasets from the placebo analyses.
preserve
use v2psprlnks_0_10_synthetic_Jap_1, clear
forval i=2/$Total_Number_Jap{
merge 1:1 _time using v2psprlnks_0_10_synthetic_Jap_`i', nogenerate
}


*Discard placebo cases with MSPE more than two times higher than Japan's.
sum MPSE_$Japan_Number_B 
global threshold_2 = r(max)*2

forval i=1/$Total_Number_Jap{
replace tr_effect_`i' = . if MPSE_`i' > $threshold_2
}


*Create graph of the gaps for all placebo cases, with Japan's gap overlayed.
local lp

forval i=1/$Total_Number_Jap {
   local lp `lp' line tr_effect_`i' _time, lcolor(gs14) ||
}

sum _time //*get the minimum and maximum year for the plot
global min = r(min)
global max = r(max)

twoway `lp' || line tr_effect_$Japan_Number_B _time, lcolor(black) lwidth(medthick)  ///
		|| pci -3 1993 3 1993, lcolor(red) lwidth(medthin) /// 
		|| pci -3 1996 3 1996, lcolor(blue) lwidth(medthin) /// 
		|| pci  0 $min 0 $max, lcolor(gs9) lwidth(thin) /// 
		, ///
		xline(1993,  lcolor(red) lwidth(medthin)) ///
		xline(1996,  lcolor(blue) lwidth(medthin)) ///
		yline(0, 	 lcolor(gs9) lwidth(thin)) ///
		legend(on order($Total_Number_Plus1_Jap "Japan" 1 "Other Countries") rows(2) size(vsmall) ring(0) position(7) rowgap(zero) colgap(zero) keygap(zero) bmargin(zero) region(margin(zero) lwidth(medium))) ///
		xtitle(Year, size(medsmall)) ytitle("Gap in Level of Programmatism" "Between Country{subscript:{it:j}} and Synthetic Country{subscript:{it:j}}", size(medsmall)) ///
		xsize(4.5) scheme(s1mono) 	///
		ylabel(-3(1)3, labsize(small)) ///
		xlabel(, labsize(small)) ///
		text(-2.05 1992.5 "Last Japanese Election Before Parallel System", orient(vertical) align(baseline) size(tiny)) ///
		text(-2.05 1995.5 "First Japanese Election After Parallel System   ", orient(vertical) align(baseline) size(tiny)) ///
		name(Japan_with_placebos, replace)

		
restore
		




	
				
****************************
****************************
*Next, Create the Lower-Left Panel (Philippines)                                                                                                                     
****************************
****************************				


**************
**************
*Reset the Working Directory                                                                                                                               
**************
**************
cd ".."

			
**************
**************
*Reopen the Varieties of Democracy Version 7 Data, which First Needs to be Prepared in "V-Dem Preparation.do"                                                                                                                         
**************
**************
use "V-Dem_AJPS_Replication.dta", clear
				
				
				
**************
**************
*Remove Observations Missing Data on the Programmatism Scale                                                                                                                      
**************
**************	
drop if v2psprlnks_0_10 == .



**************
**************
*Set Temporal Range to Have a Max of 2013, as in the Analyses of Thailand, and a Min of 1987, the Year Following the People Power Revolution                                                                                                          
**************
**************	
drop if year>=2014 
drop if year <1987 //*first House of Representatives elections since 1969, and the first election since the People Power Revolution that overthrew president Ferdinand Marcos and brought Corazon Aquino to power.

	
	
**************
**************
*Remove Observations Flagged by V-Dem                                                                                                                       
**************
**************
drop if v2psprlnks_nr <=3 & year >=2013 //*A cautionary note in the Version 7 codebook says not to use point estimates for country-variable-years with three or fewer (<=3) ratings for the period 2013-2016.

	
	
**************
**************
*Remove Observations for Country-Years with a Parallel Electoral System (aside from the Philippines)                                                                                                                     
**************
**************	
tabulate country, gen(countrydummy)
gen parallel_ever = .
gen parallel = 0 
replace parallel = 1 if v2elloelsy == 5 //*v2elloelsy is an indicator from V-Dem that classifies countries by their lower chamber electoral systems
replace parallel = . if v2elloelsy == .
foreach x of varlist countrydummy* {
	sum parallel  if `x' == 1 
	replace parallel_ever =  r(mean) if `x' == 1
	}
drop if parallel_ever > 0 & country ~= "Philippines"
drop if parallel_ever == .
drop  parallel parallel_ever countrydummy*



**************
**************
*Create a Variable that Captures the Change in Programmatism                                                                                                                      
**************
**************	
sort cntrynum year
bysort cntrynum: gen lag_v2psprlnks_0_10 = v2psprlnks_0_10[_n-1] 
gen delta_v2psprlnks_0_10 = v2psprlnks_0_10 - lag_v2psprlnks_0_10
keep if delta_v2psprlnks_0_10 ~= . //*remove observations that are missing on this measure 


	
**************
**************
*Remove All Donor Countries That Are Not Observed for the Same Years as Philippines                                                                                                                   
**************
**************	
bysort cntrynum: egen sum  = sum(year) 
summarize sum
drop if sum ~= r(max)
drop sum




**************
**************
*Declare the Data to be Time-Series Cross-Sectional                                                                                                             
**************
**************	
tsset cntrynum year



**************
**************
*Create the Graph                                                                                                         
**************
**************	
cd "synthetic control files" 
encode country, gen(cntrynum_temp) //*Create a new numerical country identifier, as the current identifier is not sequential due to the above dropping of the countries with missing data.
sum cntrynum_temp  if country == "Philippines" //*Recover Philippines's number to use later in the graph code.
global Philippines_Number_B = r(max)
tsset cntrynum_temp year //*Declare the data to be time-series cross-sectional.
sum cntrynum_temp
global Total_Number_Phil =  r(max) //*Recover number of included countries to use later in the graph code.
global Total_Number_Plus1_Phil = $Total_Number_Phil + 1 //*Recover number of included countries + 1 to use later in the graph legend code.

*Loop through the synthetic control routine, assigning each country to (falsely) be the treated country.
forval i=1/$Total_Number_Phil{
synth v2psprlnks_0_10  v2psprlnks_0_10  delta_v2psprlnks_0_10  /// 
				, 	trunit(`i') trperiod(1998)  ///
					keep(v2psprlnks_0_10_synthetic_Phil_`i', replace)
matrix RMSPE =  e(RMSPE)
scalar RMSPE = RMSPE[1,1] //*Get the root mean squared prediction error.

preserve
use v2psprlnks_0_10_synthetic_Phil_`i', clear
gen RMSPE_`i' = RMSPE
gen MPSE_`i' = RMSPE_`i'^2  //*Get the mean squared prediction error.
save v2psprlnks_0_10_synthetic_Phil_`i', replace
restore
}

drop cntrynum_temp		
drop lag_v2psprlnks_0_10 delta_v2psprlnks_0_10


*Loop through all saved datasets and create the treatment effects. Also drop missing observations.
preserve
forval i=1/$Total_Number_Phil{
use v2psprlnks_0_10_synthetic_Phil_`i', clear
gen tr_effect_`i' = _Y_treated - _Y_synthetic
keep _time tr_effect_`i'  RMSPE_`i' MPSE_`i'
drop if missing(_time)
save v2psprlnks_0_10_synthetic_Phil_`i', replace
}
restore

		
*cd "synthetic control files" //*Execute this line if you are jumping into the code at this point.
*Load the first dataset and merge all of the additional datasets from the placebo analyses.
preserve
use v2psprlnks_0_10_synthetic_Phil_1, clear
forval i=2/$Total_Number_Phil{
merge 1:1 _time using v2psprlnks_0_10_synthetic_Phil_`i', nogenerate
}


*Discard placebo cases with MSPE more than two times higher than Philippines's.
sum MPSE_$Philippines_Number_B 
global threshold_2 = r(max)*2

forval i=1/$Total_Number_Phil{
replace tr_effect_`i' = . if MPSE_`i' > $threshold_2
}


*Create graph of the gaps for all placebo cases, with Philippines's gap overlayed.
local lp

forval i=1/$Total_Number_Phil {
   local lp `lp' line tr_effect_`i' _time, lcolor(gs14) ||
}

sum _time //*get the minimum and maximum year for the plot
global min = r(min)
global max = r(max)

twoway `lp' || line tr_effect_$Philippines_Number_B _time, lcolor(black) lwidth(medthick)  ///
		|| pci -3 1998 3 1998, lcolor(red) lwidth(medthin) /// 
		|| pci -3 2001 3 2001, lcolor(blue) lwidth(medthin) /// 
		|| pci  0 $min 0 $max, lcolor(gs9) lwidth(thin) /// 
		, ///
		xline(1998,  lcolor(red) lwidth(medthin)) ///
		xline(2001,  lcolor(blue) lwidth(medthin)) ///
		yline(0, 	 lcolor(gs9) lwidth(thin)) ///
		legend(on order($Total_Number_Plus1_Phil "Philippines" 1 "Other Countries") rows(2) size(vsmall) ring(0) position(7) rowgap(zero) colgap(zero) keygap(zero) bmargin(zero) region(margin(zero) lwidth(medium))) ///
		xtitle(Year, size(medsmall)) ytitle("Gap in Level of Programmatism" "Between Country{subscript:{it:j}} and Synthetic Country{subscript:{it:j}}", size(medsmall)) ///
		xsize(4.5) scheme(s1mono) 	///
		ylabel(-3(1)3, labsize(small)) ///
		xlabel(, labsize(small)) ///
		text(-2.1 1997.6 "Last Filipino Election Before Parallel System", orient(vertical) align(baseline) size(tiny)) ///
		text(-2.1 2000.6 "First Filipino Election After Parallel System   ", orient(vertical) align(baseline) size(tiny)) ///
		name(Philippines_with_placebos, replace)

		
restore
		




****************************
****************************
*Next, Create the Lower-Right Panel (Taiwan)                                                                                                                     
****************************
****************************				
		
**************
**************
*Reset the Working Directory                                                                                                                               
**************
**************
cd ".."

			
**************
**************
*Reopen the Varieties of Democracy Version 7 Data, which First Needs to be Prepared in "V-Dem Preparation.do"                                                                                                                         
**************
**************
use "V-Dem_AJPS_Replication.dta", clear
			
				
**************
**************
*Remove Observations Missing Data on the Programmatism Scale                                                                                                                      
**************
**************	
drop if v2psprlnks_0_10 == .



**************
**************
*Set Temporal Range to be the Same as That for Thailand the Analyses Depicted in Figures 2-4                                                                                                                  
**************
**************	
drop if year>=2014 
drop if year <1972  

	
	
**************
**************
*Remove Observations Flagged by V-Dem                                                                                                                       
**************
**************
drop if v2psprlnks_nr <=3 & year >=2013 //*A cautionary note in the Version 7 codebook says not to use point estimates for country-variable-years with three or fewer (<=3) ratings for the period 2013-2016.

	
	
**************
**************
*Remove Observations for Country-Years with a Parallel Electoral System (aside from Taiwan)                                                                                                                     
**************
**************	
tabulate country, gen(countrydummy)
gen parallel_ever = .
gen parallel = 0 
replace parallel = 1 if v2elloelsy == 5 //*v2elloelsy is an indicator from V-Dem that classifies countries by their lower chamber electoral systems
replace parallel = . if v2elloelsy == .
foreach x of varlist countrydummy* {
	sum parallel  if `x' == 1 
	replace parallel_ever =  r(mean) if `x' == 1
	}
drop if parallel_ever > 0 & country ~= "Taiwan"
drop if parallel_ever == .
drop  parallel parallel_ever countrydummy*



**************
**************
*Create a Variable that Captures the Change in Programmatism                                                                                                                      
**************
**************	
sort cntrynum year
bysort cntrynum: gen lag_v2psprlnks_0_10 = v2psprlnks_0_10[_n-1] 
gen delta_v2psprlnks_0_10 = v2psprlnks_0_10 - lag_v2psprlnks_0_10
keep if delta_v2psprlnks_0_10 ~= . //*remove observations that are missing on this measure 


	
**************
**************
*Remove All Donor Countries That Are Not Observed for the Same Years as Taiwan                                                                                                                   
**************
**************	
bysort cntrynum: egen sum  = sum(year) 
summarize sum
drop if sum ~= r(max)
drop sum




**************
**************
*Declare the Data to be Time-Series Cross-Sectional                                                                                                             
**************
**************	
tsset cntrynum year



**************
**************
*Create the Graph                                                                                                         
**************
**************	
cd "synthetic control files" 
encode country, gen(cntrynum_temp) //*Create a new numerical country identifier, as the current identifier is not sequential due to the above dropping of the countries with missing data.
sum cntrynum_temp  if country == "Taiwan" //*Recover Taiwan's number to use later in the graph code.
global Taiwan_Number_B = r(max)
tsset cntrynum_temp year //*Declare the data to be time-series cross-sectional.
sum cntrynum_temp
global Total_Number_Taiw =  r(max) //*Recover number of included countries to use later in the graph code.
global Total_Number_Plus1_Taiw = $Total_Number_Taiw + 1 //*Recover number of included countries + 1 to use later in the graph legend code.

*Loop through the synthetic control routine, assigning each country to (falsely) be the treated country.
forval i=1/$Total_Number_Taiw{
synth v2psprlnks_0_10  v2psprlnks_0_10  delta_v2psprlnks_0_10  /// 
				, 	trunit(`i') trperiod(2005)  ///
					keep(v2psprlnks_0_10_synthetic_Taiw_`i', replace)
matrix RMSPE =  e(RMSPE)
scalar RMSPE = RMSPE[1,1] //*Get the root mean squared prediction error.

preserve
use v2psprlnks_0_10_synthetic_Taiw_`i', clear
gen RMSPE_`i' = RMSPE
gen MPSE_`i' = RMSPE_`i'^2  //*Get the mean squared prediction error.
save v2psprlnks_0_10_synthetic_Taiw_`i', replace
restore
}

drop cntrynum_temp		
drop lag_v2psprlnks_0_10 delta_v2psprlnks_0_10


*Loop through all saved datasets and create the treatment effects. Also drop missing observations.
preserve
forval i=1/$Total_Number_Taiw{
use v2psprlnks_0_10_synthetic_Taiw_`i', clear
gen tr_effect_`i' = _Y_treated - _Y_synthetic
keep _time tr_effect_`i'  RMSPE_`i' MPSE_`i'
drop if missing(_time)
save v2psprlnks_0_10_synthetic_Taiw_`i', replace
}
restore

		
*cd "synthetic control files" //*Execute this line if you are jumping into the code at this point.
*Load the first dataset and merge all of the additional datasets from the placebo analyses.
preserve
use v2psprlnks_0_10_synthetic_Taiw_1, clear
forval i=2/$Total_Number_Taiw{
merge 1:1 _time using v2psprlnks_0_10_synthetic_Taiw_`i', nogenerate
}


*Discard placebo cases with MSPE more than two times higher than Taiwan's.
sum MPSE_$Taiwan_Number_B 
global threshold_2 = r(max)*2

forval i=1/$Total_Number_Taiw{
replace tr_effect_`i' = . if MPSE_`i' > $threshold_2
}


*Create graph of the gaps for all placebo cases, with Taiwan's gap overlayed.
local lp

forval i=1/$Total_Number_Taiw {
   local lp `lp' line tr_effect_`i' _time, lcolor(gs14) ||
}

sum _time //*get the minimum and maximum year for the plot
global min = r(min)
global max = r(max)

twoway `lp' || line tr_effect_$Taiwan_Number_B _time, lcolor(black) lwidth(medthick)  ///
		|| pci -3 2004 3 2004, lcolor(red) lwidth(medthin) /// 
		|| pci -3 2008 3 2008, lcolor(blue) lwidth(medthin) /// 
		|| pci  0 $min 0 $max, lcolor(gs9) lwidth(thin) /// 
		, ///
		xline(2004,  lcolor(red) lwidth(medthin)) ///
		xline(2008,  lcolor(blue) lwidth(medthin)) ///
		yline(0, 	 lcolor(gs9) lwidth(thin)) ///
		legend(on order($Total_Number_Plus1_Taiw "Taiwan" 1 "Other Countries") rows(2) size(vsmall) ring(0) position(7) rowgap(zero) colgap(zero) keygap(zero) bmargin(zero) region(margin(zero) lwidth(medium))) ///
		xtitle(Year, size(medsmall)) ytitle("Gap in Level of Programmatism" "Between Country{subscript:{it:j}} and Synthetic Country{subscript:{it:j}}", size(medsmall)) ///
		xsize(4.5) scheme(s1mono) 	///
		ylabel(-3(1)3, labsize(small)) ///
		xlabel(, labsize(small)) ///
		text(-2.05 2003.5 "Last Taiwanese Election Before Parallel System", orient(vertical) align(baseline) size(tiny)) ///
		text(-2.05 2007.5 "First Taiwanese Election After Parallel System   ", orient(vertical) align(baseline) size(tiny)) ///
		name(Taiwan_with_placebos, replace)

		
restore
		


		
		

****************************
****************************
*Next, Combine the Four Panels to Create Figure A4                                                                                                                 
****************************
****************************				
graph combine  ///
Thailand_with_placebos ///
Japan_with_placebos ///
Philippines_with_placebos ///
Taiwan_with_placebos ///
	, rows(2) xcommon scale(.8) graphregion(margin(zero)) scheme(s1mono)  
	
*the following lines make some aesthetic adjustments with graph editor	
gr_edit .plotregion1.graph1.legend.plotregion1.label[1].style.editstyle size(small) editcopy
gr_edit .plotregion1.graph1.legend.plotregion1.label[2].style.editstyle size(small) editcopy
gr_edit .plotregion1.graph1.plotregion1.textbox1.yoffset = 1.1
gr_edit .plotregion1.graph1.plotregion1.textbox2.yoffset = 1.1
gr_edit .plotregion1.graph1.plotregion1.textbox1.style.editstyle vertical(top) editcopy
gr_edit .plotregion1.graph1.plotregion1.textbox2.style.editstyle vertical(top) editcopy

gr_edit .plotregion1.graph2.legend.plotregion1.label[1].style.editstyle size(small) editcopy
gr_edit .plotregion1.graph2.legend.plotregion1.label[2].style.editstyle size(small) editcopy
gr_edit .plotregion1.graph2.plotregion1.textbox1.yoffset = 1.6
gr_edit .plotregion1.graph2.plotregion1.textbox2.yoffset = 1.6
gr_edit .plotregion1.graph2.plotregion1.textbox1.style.editstyle vertical(top) editcopy
gr_edit .plotregion1.graph2.plotregion1.textbox2.style.editstyle vertical(top) editcopy

gr_edit .plotregion1.graph3.legend.plotregion1.label[1].style.editstyle size(small) editcopy
gr_edit .plotregion1.graph3.legend.plotregion1.label[2].style.editstyle size(small) editcopy
gr_edit .plotregion1.graph3.plotregion1.textbox1.yoffset = 1.35
gr_edit .plotregion1.graph3.plotregion1.textbox2.yoffset = 1.35
gr_edit .plotregion1.graph3.plotregion1.textbox1.style.editstyle vertical(top) editcopy
gr_edit .plotregion1.graph3.plotregion1.textbox2.style.editstyle vertical(top) editcopy

gr_edit .plotregion1.graph4.legend.plotregion1.label[1].style.editstyle size(small) editcopy
gr_edit .plotregion1.graph4.legend.plotregion1.label[2].style.editstyle size(small) editcopy
gr_edit .plotregion1.graph4.plotregion1.textbox1.yoffset = 1.8
gr_edit .plotregion1.graph4.plotregion1.textbox2.yoffset = 1.8
gr_edit .plotregion1.graph4.plotregion1.textbox1.style.editstyle vertical(top) editcopy
gr_edit .plotregion1.graph4.plotregion1.textbox2.style.editstyle vertical(top) editcopy


			
		
				
**************************************************************************************************
**************************************************************************************************
*All Code Below Pertains to 
*Appendix Section 8: Difference-in-Differences Analysis of the Introduction of Compulsory Voting and Programmatism in Thailand
**************************************************************************************************
**************************************************************************************************					
					

**************
**************
*Reset the Working Directory                                                                                                                               
**************
**************
cd ".."

			
**************
**************
*Reopen the Varieties of Democracy Version 7 Data, which First Needs to be Prepared in "V-Dem Preparation.do"                                                                                                                         
**************
**************
use "V-Dem_AJPS_Replication.dta", clear
			
	
	
**************
**************
*Remove Observations Flagged by V-Dem                                                                                                                       
**************
**************
drop if v2psprlnks_nr <=3 & year >=2013 //*A cautionary note in the Version 7 codebook says not to use point estimates for country-variable-years with three or fewer (<=3) ratings for the period 2013-2016.



**************
**************
*Exclude Years in Which a Country Was Deemed Not Free or Not Assessed by Freedom House
**************
**************
drop if  e_fh_status_numeric==3 
drop if  e_fh_status_numeric==.
	

	
**************
**************
*Remove Observations for Country-Years with Compulsory Voting (aside from Thailand)                                                                                                                      
**************
**************	
tabulate country, gen(countrydummy)
gen CV_ever = .
foreach x of varlist countrydummy* {
	sum v2elcomvot_any  if `x' == 1 
	replace CV_ever =  r(mean) if `x' == 1
	}
drop if CV_ever > 0 & country ~= "Thailand"
drop if CV_ever == . 
drop CV_ever countrydummy*



**************
**************
*Create Country-Specific Time Trends
**************
**************
encode country, gen(cntrynum_temp) //*Create a new numerical country identifier, as the current identifier is not sequential due to the above dropping of the countries without data on the vote buying measure. 
sum cntrynum_temp
global total_number =  r(max) //*Recover number of included countries to use below.

sum year if year >=1972 & year<=2015 //*Restrict the range to years on which data are available for each variable that will appear in the models.
gen time = (year - r(min))/(r(max) - r(min))
forvalues i = 1/$total_number {
gen cntrynum_temp`i' = cntrynum_temp == `i'
gen trend`i' = time*cntrynum_temp`i'
}





****
*Fixed effects models, using both OLS with interactions and fixed effects approach (both give same estimates)
****
gen treated  = 0
replace treated = 1 if  country == "Thailand" 

gen post = 0
replace post = 1 if year >= 1997

*Table A5
xtreg v2psprlnks_0_10  		c.treated#c.post  c.GDP_percap_dol_Taiw##c.GDP_percap_dol_Taiw c.e_polity2##c.e_polity2 v2cltrnslw  majoritarian_filled presidential i.year trend* if v2elcomvot~=.,  i(cntrynum) fe cl(cntrynum) //*Use "if v2elcomvot~=." because comparable cross-national models in Study 1 excluded observations without information on compulsory voting.
estimates table, b(%9.3f) se(%9.3f)  stats(N N_g r2_w)

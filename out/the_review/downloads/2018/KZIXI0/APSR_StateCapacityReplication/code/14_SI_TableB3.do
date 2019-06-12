

	******************************************************************
	**
	**
	**		NAME:		Francisco Garfias
	**		DATE: 		November 28, 2017
	**		PROYJECT: 	Elite Competition and State Capacity 
	**					Development: Theory and Evidence from 
	**					Post-Revolutionary Mexico
	**
	**		DETAILS: 	This code prepares Table B.3: Crop 
	**					Suitability (1961-1990) and Present-Day 
	**					Production (2013), Part 1
	**					
	** 
	**
	**				
	**		Version: 	Stata MP 12.1
	**
	******************************************************************
	
	



		

			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* Prepare data
*-------------------------------------------------------------------------------


local datadir $data
use "`datadir'Suit_Planted2013.dta", clear




		


			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* Table B.3: Crop Suitability (1961-1990) and Present-Day Production (2013) Pt.1
*-------------------------------------------------------------------------------


* Clear
eststo clear
local clear
set more off

* Loop over crops
local suit1 "suit_wheat suit_maize suit_rice suit_sugarcane suit_banana" 
local suit2 "suit_barley suit_cacao suit_coffee suit_cotton" 
local count=0
local crops "wheat maize rice sugarcane banana" 

foreach crop in `crops' {
local count=`count'+1

reg sharesemb_sample_`crop' suit_`crop', r
eststo: reg logprod_`crop' suit_`crop' if e(sample)==1, r
egen logprod_`crop'_mean=mean(logprod_`crop') if e(sample)==1
egen logprod_`crop'_sd=sd(logprod_`crop') if e(sample)==1
qui sum logprod_`crop'_mean
estadd scalar mean=`r(mean)': est`count'
qui sum logprod_`crop'_sd
estadd scalar sd=`r(mean)': est`count'
drop logprod_`crop'_mean logprod_`crop'_sd

local count=`count'+1
eststo: reg logprod_`crop' logarea `suit1' `suit2' if e(sample)==1, r
egen logprod_`crop'_mean=mean(logprod_`crop') if e(sample)==1
egen logprod_`crop'_sd=sd(logprod_`crop') if e(sample)==1
qui sum logprod_`crop'_mean
estadd scalar mean=`r(mean)': est`count'
qui sum logprod_`crop'_sd
estadd scalar sd=`r(mean)': est`count'
drop logprod_`crop'_mean logprod_`crop'_sd

}


*Fragment
#delimit;
local tablesdir $tables;
esttab using "`tablesdir'14_TableB3.tex",
b(a2) replace keep(logarea `suit1' `suit2')  order(logarea `suit1' `suit2') 
gaps compress se bookt nodepvars star(* 0.10 ** 0.05 *** 0.01) fragment label 
mtitles("Wheat" "Wheat" "Maize" "Maize" "Rice" "Rice" "Sugar" "Sugar" 
	"Banana" "Banana")
stats(mean sd r2 N, 
labels("Mean of DV" "SD of DV" "R sq." "\specialcell{Number of\\municipios}")); 
#delimit cr
drop _est_*

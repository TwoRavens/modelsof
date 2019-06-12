/* NHTSAalysis.do */
* Note that low-income is below $25k income, which most closely approximates the bottom quartile. You can see this by doing tab HHIncome [aw=wth]

clear matrix
clear mata
clear all
set more off

global FigureGroups = "All LowIncome FoodDesert Urban UrbanLowIncome UrbanFD LowIncomeFDNoCar" // types of households for use in figures

** For text: mean and median travel distances and times.
use $Externals/Calculations/NHTS/NHTSTrips.dta, clear, if GroceryTrip==1&HHIncome!=.
gen lnHHIncome=ln(HHIncome)
sum trvl_min, detail
sum trpmiles, detail

reg trvl_min lnHHIncome htppopdn [pw=wttrdfin] if T_Auto==1
reg trpmiles lnHHIncome htppopdn [pw=wttrdfin] if T_Auto==1


/* GRAPH 1: TRIP DISTANCE BY DEMOGRAPHIC GROUP */
*** First get household population shares
use $Externals/Calculations/NHTS/NHTSHouseholds.dta, replace
gen All = 1

gen N=1
foreach var in N {
	foreach group in $FigureGroups {
		gen `var'_`group' = `var' if `group'==1
	}
}


collapse (sum) N* [aw=wthhfin]
gen n=1
drop N
reshape long N_,i(n) j(group) string
sum N_ if group=="All"
gen PopShare = N_/r(mean)
keep group PopShare
save $Externals/Calculations/NHTS/NHTSGroups.dta, replace


use $Externals/Calculations/NHTS/NHTSTrips.dta, clear, if GroceryTrip==1&HHIncome!=.
gen All = 1

gen Medtrpmiles = trpmiles
gen NTrips = 1

foreach var in T_Auto trpmiles Medtrpmiles NTrips {
	foreach group in $FigureGroups {
		gen `var'_`group' = `var' if `group'==1
	}
}


collapse (sum) NTrips* (median) Medtrpmiles* (mean) T_Auto* trpmiles* [aw=wttrdfin]


gen n=1
drop NTrips T_Auto trpmiles Medtrpmiles
reshape long NTrips_ T_Auto_ trpmiles_ Medtrpmiles_,i(n) j(group) string

** Merge the household populations shares
merge 1:1 group using $Externals/Calculations/NHTS/NHTSGroups.dta, nogen keep(match master) keepusing(PopShare)


gen Order = .
replace Order = 1 if group=="All"
replace Order = 2 if group=="LowIncome"
replace Order = 3 if group=="FoodDesert"
replace Order = 4 if group=="Urban" 
replace Order = 5 if group=="UrbanLowIncome"
replace Order = 6 if group=="UrbanFD"
replace Order = 7 if group=="LowIncomeFDNoCar"
sort Order

sum NTrips_ if group=="All"
gen TripShare = NTrips_/r(mean)

encode group, gen(Group)
save $Externals/Calculations/NHTS/NHTSGroups.dta, replace

use $Externals/Calculations/NHTS/NHTSGroups.dta, replace

/* Mean distance and share of the population */
twoway (bar PopShare Order, fcolor(gs13) lcolor(dknavy) lwidth(medthick) ) ///
	(scatter trpmiles Order, mcolor(maroon) msymbol(diamond) msize(large) yaxis(2)), /// 
	xlabel(1 "All" 2 "Poor" 3 `""Food" "desert""' 4 "Urban" 5 `""Urban &" "poor""' 6 `""Urban &" "food" "desert""' 7 `""Poor," "food desert," "& no car""') ///
	xtitle("") ytitle("Mean one-way trip distance (miles)", axis(2)) ///
		ytitle("Share of population") yscale(range(0 6)  axis(2)) ylabel(0(1)7, axis(2)) yscale(range(0 1)) ylabel(0(0.2)1) ///
			graphregion(color(white) lwidth(medium)) ///
		legend(label(1 "Population share") label(2 "Distance"))
			
graph export "Output/StylizedFacts/Figures/TripMiles.pdf", as(pdf) replace


/* Median distance and auto share */
twoway (bar T_Auto Order, fcolor(gs13) lcolor(dknavy) lwidth(medthick)) ///
	(scatter Medtrpmiles Order, mcolor(maroon) msymbol(diamond) msize(large) yaxis(2)), /// 
	xlabel(1 "All" 2 "Poor" 3 `""Food" "desert""' 4 "Urban" 5 `""Urban &" "poor""' 6 `""Urban &" "food" "desert""' 7 `""Poor," "food desert," "& no car""') ///
	xtitle("") ytitle("Median one-way trip distance (miles)", axis(2)) ///
		ytitle("Share of trips made by car") yscale(range(0 3) axis(2)) ylabel(0(1)4, axis(2)) yscale(range(0 1)) ylabel(0(0.2)1) ///
			graphregion(color(white) lwidth(medium)) ///
		legend(label(1 "Auto share") label(2 "Distance"))
			
graph export "Output/StylizedFacts/Figures/TripMiles1.pdf", as(pdf) replace


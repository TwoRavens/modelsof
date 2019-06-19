* Do file to import and clean 2011 census data (by SA1)

* December 2013

clear

set more off


*1. import census csv files, change names and clean

global files Age Bedrooms Childcare Children DwellingStructure DwellingType Education Employment English Gender HouseholdType Income Indig Internet LandlordType Mortgage Occupation Rent Schooling Student Tenure Vehicles 

*

foreach xx of global files {
	
	import excel using OrigData/Census2011/SA1/`xx'_SA1.xls, clear
	drop A
	drop if _n<=3
	drop if _n==2
	drop if _n> = 13341
	export excel using OrigData/Census2011/SA1/`xx'_SA1_clean.xls, replace
	
	clear
	
	import excel using OrigData/Census2011/SA1/`xx'_SA1_clean.xls, firstrow allstring 

	label variable A "SA1" 
	
	foreach var of varlist _all   {
        local x : variable label `var'
        local new_name = strtoname(abbrev("`x'",32))
        rename `var' `new_name'
		}
		
	dropmiss, force
	drop if SA1=="Total"
	destring, replace
	label data `xx'
	save OrigData/Census2011/SA1/`xx'_SA1.dta, replace
	
	clear
}



*2. calculate average income for each SA1

* imported imputed income values from ABS: http://www.abs.gov.au/websitedbs/censushome.nsf/home/factsheetsuid?opendocument&navpos=450

use OrigData/Census2011/SA1/Income_SA1.dta, clear


	rename Negative_income Inc_1
	rename Nil_income Inc_2
	rename  _1__199___1__10_399_ Inc_3
	rename _200__299___10_400__15_599_ Inc_4
	rename _300__399___15_600__20_799_ Inc_5
	rename _400__599___20_800__31_199_ Inc_6
	rename _600__799___31_200__41_599_ Inc_7
	rename _800__999___41_600__51_999_ Inc_8
	rename _1_000__1_249___52_000__64_999_ Inc_9
	rename _1_250__1_499___65_000__77_999_ Inc_10
	rename _1_500__1_999___78_000__103_999_ Inc_11
	rename _2_000_or_more___104_000_or_more Inc_12

	gen val_inc1 = Inc_1 * (-101)
	gen val_inc2 = Inc_2 *0 
	gen val_inc3 = Inc_3 *80
	gen val_inc4 = Inc_4 *263
	gen val_inc5 = Inc_5 *349
	gen val_inc6 = Inc_6 *487
	gen val_inc7 = Inc_7 *698
	gen val_inc8 = Inc_8 *896
	gen val_inc9 = Inc_9 *1107
	gen val_inc10 = Inc_10 *1363
	gen val_inc11 = Inc_11 *1695
	gen val_inc12 = Inc_12 *2579

	egen N_inc = rowtotal(Inc_*)

	egen Total_val_inc = rowtotal(val_*)

	* find the median 
	gen N_median = N_inc/2
	gen N_75perc = 0.75*N_inc
	
	gen median_income = 0
	gen perc75_income = 0
	egen row_sum1 = rowtotal(Inc_1 Inc_2)
	
	
	forval x = 1(1)10{
		local y = `x' + 1 
		local z = `x' + 2
		egen row_sum`y' = rowtotal(row_sum`x' Inc_`z')
		replace median_income = (val_inc`y')/Inc_`y' if N_median > row_sum`x' & N_median < row_sum`y'
		replace perc75_income = (val_inc`y')/Inc_`y' if N_75perc > row_sum`x' & N_75perc < row_sum`y'
		}
		
	
	gen av_income = Total_val_inc/N_inc

	label variable av_income "Mean weekly income (SA1)"
	label variable median_income "Median weekly income (SA1)"
	label variable perc75_income "75th percentile weekly income (SA1)"
	
	keep SA1 av_income median_income perc75_income

save OrigData/Census2011/SA1/AverageIncome_SA1.dta, replace

*3. construct average age variable (note that this ignores right censoring at 100 years)

use OrigData/Census2011/SA1/Age_SA1.dta, clear
	capture drop Total
	gen av_age=.
	egen Total =rowtotal(_*)

	mata:  
		yearsall=(0..100)'
		ages=st_data(.,2..102)
		Total = st_data(.,104)
		Calc_av=((ages*yearsall):/Total)
		st_store(.,("av_age"),Calc_av)
	end

	keep SA1 av_age

save OrigData/Census2011/SA1/AverageAge_SA1.dta, replace

* 4. construct proportion of homes with no children
 
use OrigData/Census2011/SA1/Children_SA1.dta, clear
 	capture drop Total

	egen Total=rowtotal(*_children One_child)
	gen PNoChildren = No_children/Total
	gen PChildren = 1- PNoChildren
	label variable PChildren "Proportion of households with children"
	 
	keep SA1 PChildren 
 
save OrigData/Census2011/SA1/PChildren_SA1.dta, replace

 * 5. construct proportion of houses that are separate

use OrigData/Census2011/SA1/DwellingStructure_SA1.dta, clear

	gen PSeparateHouse = Separate_house/(Total-Not_stated-Not_applicable)
 
	keep SA1 PSeparateHouse 
 
save OrigData/Census2011/SA1/PSeparateHouse_SA1.dta, replace
 
 * 6. construct proporiton working full time
 
use OrigData/Census2011/SA1/Employment_SA1.dta, clear

	gen PFullTime = Employed__worked_full_time/(Total-Not_stated - Not_applicable)
 
	keep SA1 PFullTime
 
save OrigData/Census2011/SA1/PFullTime_SA1.dta, replace
 
 * 7. construct proportion non family households
  
use OrigData/Census2011/SA1/HouseholdType_SA1.dta, clear

	gen PNonFamily = Non_family_household/(Total-Not_applicable)
 
	keep SA1 PNonFamily
 
save OrigData/Census2011/SA1/PNonFamily_SA1.dta, replace
 
 * 8. proportion professionals 
 
use  OrigData/Census2011/SA1/Occupation_SA1.dta, clear
	capture drop Total

	egen Total = rowtotal(Managers Professionals Technicians Community Clerical Sales Machinery Labourers)
	gen PProf = Professionals/Total
 
	keep SA1 PProf
 
save OrigData/Census2011/SA1/PProf_SA1.dta, replace
 
 * 9. number of students
use  OrigData/Census2011/SA1/Student_SA1.dta, clear
	gen NStudents=Total

	keep SA1 NStudents

save OrigData/Census2011/SA1/NStudents_SA1.dta, replace

 * 10. tenure
use  OrigData/Census2011/SA1/Tenure_SA1.dta, clear
	capture drop Total
	egen Total = rowtotal( Owned_outright Owned_with_a_mortgage Being_purchased_under_a_rent_buy Rented Being_occupied_rent_free Being_occupied_under_a_life_tenu Other_tenure_type)

	gen POwnedOutright= Owned_outright/Total
	gen PRented = Rented/Total
	  
	keep POwnedOutright PRented SA1
  
save OrigData/Census2011/SA1/POwnership_SA1.dta, replace
 
 * 11 vehicles
 
use  OrigData/Census2011/SA1/Vehicles_SA1.dta, clear
	capture drop Total
	egen Total = rowtotal(  No_motor_vehicles One_motor_vehicle Two_motor_vehicles Three_motor_vehicles  Four_or_more_motor_vehicles)

	gen PTwoVehicles = Two_motor_vehicles/Total
	gen PNoVehicles = No_motor/Total
	gen PThreeMoreVehicles = (Three_motor_vehicles+Four_or_more_motor_vehicles)/Total
	 
	keep P* SA1
 
save OrigData/Census2011/SA1/PVehicles_SA1.dta, replace

 
 * 12 bedrooms
 
 use  OrigData/Census2011/SA1/Bedrooms_SA1.dta, clear

	capture drop Total
	egen Total = rowtotal(  None One_bedroom Two_bedrooms Three_bedrooms Four_bedrooms Five_bedrooms Six_bedrooms)

	gen POne_bedroom = One_bedroom/Total 
	gen PTwo_bedrooms = Two_bedrooms/Total 
	gen PThree_bedrooms = Three_bedrooms/Total
	gen PFour_bedrooms = Four_bedrooms/Total
	gen PFive_bedrooms = Five_bedrooms/Total
	gen PSix_bedrooms = Six_bedrooms/Total
	gen PFiveormorebedrooms = PFive_bedrooms+ PSix_bedrooms
 
	rename None room_0
	rename One room_1
	rename Two room_2
	rename Three room_3
	rename Four room_4
	rename Five room_5
	rename Six room_6
	
	gen val_room1 = room_1 *1
	gen val_room2 = room_2 *2 
	gen val_room3 = room_3 *3
	gen val_room4 = room_4 *4
	gen val_room5 = room_5 *5
	gen val_room6 = room_6 *6

	egen N_room = rowtotal(room_0-room_6)

	egen Total_val_room = rowtotal(val_*)
	gen av_rooms = Total_val_room/N_room

	* find the median 
	gen N_median = N_room/2
	gen N_75perc = 0.75*N_room
	
	gen median_rooms = 0
	gen perc75_rooms = 0
	
	egen row_sum1 = rowtotal(room_0 room_1)
	
	
	forval x = 1(1)5{
		local y = `x' + 1 
		egen row_sum`y' = rowtotal(row_sum`x' room_`y')
		replace median_rooms = (val_room`y')/room_`y' if N_median > row_sum`x' & N_median < row_sum`y'
		replace perc75_rooms = (val_room`y')/room_`y' if N_75perc > row_sum`x' & N_75perc < row_sum`y'
		}
		
	label variable av_rooms "Mean bedrooms"
	label variable median_rooms "Median bedrooms"
	label variable perc75_rooms "75th percentile bedrooms"
 
 
	keep P* SA1 median_rooms av_rooms perc75_rooms
 
 save OrigData/Census2011/SA1/PBedrooms_SA1.dta, replace

 
**************************************************************

global files1 AverageIncome AverageAge PChildren PSeparateHouse PFullTime PNonFamily PProf NStudents POwnership PVehicles PBedrooms


*. merge census dta files

foreach xx of global files1 {
	
	merge 1:1 SA1 using OrigData/Census2011/SA1/`xx'_SA1.dta, nogenerate
	
	erase OrigData/Census2011/SA1/`xx'_SA1.dta
	}


sort SA1
save Data/Census11_SA1.dta, replace


**********************************************************************

* merge with account numbers

clear 

insheet using OrigData/census_SA1_match.csv, comma

	rename sa1 SA1
	rename party_code account_number
	rename occupationdimensionscore SES_occupation
	rename educationdimensionscore  SES_education
	rename householdincomedimensionscore SES_income
	rename householdincomebasedonfamilieswi SES_incomechildren

	drop retailer_id

	sort SA1

	
	
	merge m:1 SA1 using Data/Census11_SA1.dta
	drop if _merge ==2
	drop _merge

	sort account_number

save Data/CustomerCensusSA1.dta, replace








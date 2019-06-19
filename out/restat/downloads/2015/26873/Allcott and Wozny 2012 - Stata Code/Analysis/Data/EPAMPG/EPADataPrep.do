/* EPADataPrep.do */
/* Allcott and Wozny */
/* This prepares the EPA fuel economy dataset. */

/* EPA 1985-2008 */
insheet using Data/EPAMPG/EPAMPG.csv, comma names clear double /* Have to import as double to get Liters right */

rename year ModelYear
rename newmake Make
rename newmodel Model
destring displ, replace force
destring cylinders, replace force 
recast int cylinders
gen int Liters = displ*10
rename cylinders Cylinders
rename comb08 MPGA /* Actual MPG based on 2008 ratings */
rename combined MPGE /* Expected MPG based on ratings at the time */
replace MPGE = MPGA if ModelYear >= 2008 /* combined = 0 for all vehicles in 2008 and later. */
rename vclass VClass
rename drive Drive

** Drive
replace Drive = "AWD" if Drive=="4-Wheel or All-Wheel Drive"|Drive=="All-Wheel Drive"|Drive=="4-Wheel Drive"|Drive=="Part-time 4-Wheel Drive"
replace Drive = "FWD" if Drive=="Front-Wheel Drive"
replace Drive = "RWD" if Drive=="Rear-Wheel Drive" | Drive=="Rear-wheel drive"
** Make it 2WD or 4WD
replace Drive = "2WD" if Drive=="FWD"|Drive=="RWD"|Drive=="2-Wheel Drive"
replace Drive = "4WD" if Drive=="AWD"


rename fueltype FuelType
replace FuelType = "Gas" if FuelType == "Regular"|FuelType=="Premium"|FuelType=="Gasoline or E85"|FuelType=="Gasoline or natural gas"|FuelType=="Gasoline or propane"|FuelType=="Premium or E85"


/* Clean Names: do this before collapsing */
do Data/EPAMPG/CleanEPANames.do

/* Fuel Economy by Transmission Type */
gen Manual = cond(substr(trany,1,4)=="Manu",1,0)
gen GPMA_Manual = cond(Manual==1,1/MPGA,.)
gen GPMA_Auto = cond(Manual==0,1/MPGA,.)
gen GPME_Manual = cond(Manual==1,1/MPGE,.)
gen GPME_Auto = cond(Manual==0,1/MPGE,.)


/* VClass */
** Make the EPA VClass consistent **
replace VClass=proper(trim(VClass))
replace VClass="SPV" if strpos(VClass,"Special Purpose")==1
replace VClass="SUV" if strpos(VClass,"Sport Utility Vehicle")==1
replace VClass="Standard Pickup" if (strpos(VClass,"Standard Pickup")==1|strpos(VClass,"Standrad Pickup")==1)
replace VClass="Small Pickup" if strpos(VClass,"Small Pickup")==1
replace VClass="Van" if strpos(VClass,"Van")==1
replace VClass="Minivan" if strpos(VClass,"Minivan")==1
replace VClass="Compact" if strpos(VClass,"Compact")==1
replace VClass="Compact" if (strpos(VClass,"Small Station Wagons")==1|strpos(VClass,"Small Wagon")==1)
replace VClass="Minicompact" if strpos(VClass,"Minicompact")==1
replace VClass="Subcompact" if strpos(VClass,"Subcompact")==1
replace VClass="Mid-Size" if (strpos(VClass,"Midsize")==1|strpos(VClass,"Mid-Size")==1)
replace VClass="Large" if strpos(VClass,"Large")==1
replace VClass="Two-Seater" if strpos(VClass,"Two Seater")==1
replace VClass="Pickup" if VClass=="Small Pickup" | VClass=="Standard Pickup"

gen VClassNum = -1
replace VClassNum = 1 if VClass=="Two-Seater"
replace VClassNum = 2 if VClass=="Minicompact"
replace VClassNum = 3 if VClass=="Subcompact"
replace VClassNum = 4 if VClass=="Compact"
replace VClassNum = 5 if VClass=="Mid-Size"
replace VClassNum = 6 if VClass=="Large"
replace VClassNum = 7 if VClass=="SUV"
replace VClassNum = 8 if VClass=="Pickup"
replace VClassNum = 9 if VClass=="Minivan"
replace VClassNum = 10 if VClass=="Van"
replace VClassNum = 11 if VClass=="SPV"


/* Collapse */
** First drop "cargo" and "chassis cab" 
* We do not want to include in the estimation anything that is a cargo van or a chassis cab, and while we eliminate these BodyStyles, we also do not want the MPG ratings for these vehicles collapsed into MPG ratings for other included vehicles.
drop if strpos(OModel,"Cab/Chassis")!=0|strpos(OModel,"Cab Chassis")!=0|strpos(OModel,"Chassis Cab")!=0|strpos(OModel,"cargo")!=0|strpos(OModel,"Cargo")!=0|strpos(OModel,"Postal")!=0
* Drop Usps Ford explorer and electric:
drop if Model=="Ford Explorer" & (strpos(OModel,"Usps")!=0|strpos(OModel,"Electric")!=0)

* collapse (mean) GPMA_Manual GPMA_Auto GPME_Manual GPME_Auto, by(Make Model Submodel Cylinders Liters Drive FuelType ModelYear VClass)
* Collapse to get one value of VClass for each vehicle. In about 100 cases, the EPA has two different submodels (e.g. Cabriolet) that we do not distinguish for MPG purposes. We want to get one value of VClass and GPM for those.
collapse (mean) GPMA_Manual GPMA_Auto GPME_Manual GPME_Auto VClassNum, by(Make Model Submodel Cylinders Liters Drive FuelType ModelYear)


/* Label VClass */
gen VClass = round(VClassNum)
drop VClassNum

capture label drop ClassLabel
label define ClassLabel 1 "Two-Seater" 2 "Minicompact" 3 "Subcompact" 4 "Compact" 5 "Mid-Size" 6 "Large" 7 "SUV" 8 "Pickup" 9 "Minivan" 10 "Van" 11 "SPV" -1 "Missing"
label values VClass ClassLabel
tab VClass


/* Order, sort, and save */
order Make Model Submodel Cylinders Liters Drive FuelType ModelYear VClass
sort Model Submodel Cylinders Liters Drive FuelType ModelYear
save Data/EPAMPG/EPAMPG.dta, replace


*

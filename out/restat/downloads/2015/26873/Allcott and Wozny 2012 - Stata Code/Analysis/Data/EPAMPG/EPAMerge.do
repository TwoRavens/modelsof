/* EPAMerge.do */
/* Allcott and Wozny */
/* This file merges EPA MPG data onto the VIN prefixes. There is an intermediate match of EPA data
onto Polk NVPP model names, which are then matched to VINS. 
We also clean up some model names and the vehicles classes */


clear all
capture log close
log using EPAMerge.log, replace


/* First insheet the matchups file */
insheet using Data/Matchups/Matchups.csv, comma names clear
rename make Make
rename model Model
rename trim Trim
rename bodystyle BodyStyle
rename modelyear ModelYear

rename wardsmodel1 WardsModel1
rename wardssubmodel1 WardsSubmodel1
rename wardsmodel2 WardsModel2
rename wardssubmodel2 WardsSubmodel2

rename epamodel1 EPAModel1
rename epasubmodel1 EPASubmodel1
rename epamodel2 EPAModel2
rename epasubmodel2 EPASubmodel2
rename unrated Unrated 

capture tostring WardsSubmodel1 WardsSubmodel2 EPASubmodel1 EPASubmodel2, replace force

foreach var in WardsSubmodel1 WardsSubmodel2 EPASubmodel1 EPASubmodel2 {
replace `var' = "" if `var'=="."
}

gen Submodel = EPASubmodel1

sort Make Model Trim BodyStyle ModelYear
save Data/Matchups/Matchups.dta, replace



/* Create the NVPP-Prefix match file */
include Data/Matchups/NVPPToPrefix.do

/* Merge EPA data onto Polk NVPP file.  Note that this is not the "master file" but we will
   later merge the NVPP names to the master (Prefix) names. */
use Data/Quantities/PolkRegistrations.dta, clear


/* Merge Matchup Names - Get the EPA Model and EPA Submodel*/
sort Make Model Trim BodyStyle ModelYear
merge Make Model Trim BodyStyle ModelYear using Data/Matchups/Matchups.dta,nokeep keep(EPAModel? EPASubmodel? Submodel Unrated)
drop _merge

rename Model PolkModel
rename Submodel PolkSubmodel
replace Unrated = 0 if Unrated == .
gen OriginalLiters = Liters

/* Note that the liter designations are different in many cases because of rounding of the CC figure.
Address this by allowing EPA data to merge in with +/- 0.1 Liters  */
* This generates a dataset in triplicate with Liters = 0, -0.1, and +0.1. (Note that "Liters" is really 10*Liters.)
tempfile AutoQMPG
save `AutoQMPG', replace
replace Liters = Liters+1
gen P1 = 1
append using `AutoQMPG'
replace Liters = Liters-1 if P1==.
append using `AutoQMPG'
drop P1


*** EPA MPG
** First define the merge variables for the rounds of merging, ranging from most disaggregated to least
* A and B are most disaggregated. B will be used to merge with missing Drive
* C, E, and E: Compromise on Submodel, then Model Year, then both
global A "Model Submodel Cylinders Liters Drive FuelType ModelYear"
global B "Model Submodel Cylinders Liters Drive FuelType ModelYear"
global C "Model Cylinders Liters Drive FuelType ModelYear"
global D "Model Submodel Cylinders Liters Drive FuelType"
global E "Model Cylinders Liters Drive FuelType"

* Then compromise on drive, then submodel and drive
global F "Model Submodel Cylinders Liters FuelType ModelYear"
global G "Model Cylinders Liters FuelType ModelYear"

* Then liters, and submodel and liters
global H "Model Submodel Cylinders Drive FuelType ModelYear"
global I "Model Cylinders Drive FuelType ModelYear"

* Then the above 2 plus model year:
global J "Model Cylinders Liters FuelType"
global K "Model Cylinders Drive FuelType"

* Then liters and drive, and liters and submodel and drive
global L "Model Submodel Cylinders FuelType ModelYear"
global M "Model Cylinders FuelType ModelYear"

* Then really aggregated levels
global N "Model Cylinders ModelYear"
global O "Model Cylinders FuelType"
global P "Model FuelType ModelYear"
global Q "Model FuelType"
global R "Model Cylinders"
global S "Model ModelYear"
global T "Model"


tempfile Temp
tempfile TempUsing
tempfile TempEPA_2WD
tempfile TempEPA_4WD


/* Generate temporary EPA_2WD and EPA_4WD datasets */
* This allows drive to be missing, as it often is in MY 1984.
save `Temp', replace

use Data/EPAMPG/EPAMPG.dta, clear
replace Drive = "2WD" if Drive==""
sort Model Submodel Cylinders Liters Drive FuelType ModelYear
save `TempEPA_2WD',replace
use Data/EPAMPG/EPAMPG.dta, clear
replace Drive = "4WD" if Drive==""
sort Model Submodel Cylinders Liters Drive FuelType ModelYear
save `TempEPA_4WD',replace

use `Temp',clear

/* Then Merge */
* Note that we have to do a special version of update here so that we don't update some of the transmission types when we already have some merged in. e.g. it will merge manual transmission at a very disaggregated level, but then merge automatic at a more aggregated level. We just want to leave the automatic empty if there is a good match.
global EPAVars "GPMA_Auto GPMA_Manual GPME_Auto GPME_Manual VClass"

forvalues m = 1/2 {
	gen MergeSuccessIter`m' = .
	local MergeSuccessIter = 1
	rename EPAModel`m' Model
	rename EPASubmodel`m' Submodel
	/* First merge at A separately to get the proper vehicle class at disaggregated level. Later will not collapse EPAMPG by vehicle class. */
			sort $A
			merge $A using Data/EPAMPG/EPAMPG.dta, nokeep keep($EPAVars) update /* The update option means that the imported VClass will only replace missing observations if the first model name didn't have a VClass */
			*gen use`m' = cond(_merge==3,1,0) /* This is observations in both datasets. Since A is the first merge, there is no update there. */
			replace MergeSuccessIter`m' = `MergeSuccessIter' if _merge==3
			drop _merge
			local MergeSuccessIter = `MergeSuccessIter' + 1

			** Some EPA vehicles have missing Drive. Merge at the A-level except allowing missing Drives in EPA to be 2WD, then 4WD
			* First try to merge assuming missing EPA drives are 2WD
			sort $B
			merge $B using `TempEPA_2WD', nokeep keep($EPAVars) update /* The update option means that the imported VClass will only replace missing observations if the first model name didn't have a VClass */
			replace MergeSuccessIter`m' = `MergeSuccessIter' if _merge==4
			drop _merge
			* Merge assuming missing EPA Drives are 4WD
			sort $B
			merge $B using `TempEPA_4WD', nokeep keep($EPAVars) update /* The update option means that the imported VClass will only replace missing observations if the first model name didn't have a VClass */
			replace MergeSuccessIter`m' = `MergeSuccessIter' if _merge==4
			drop _merge
			local MergeSuccessIter = `MergeSuccessIter' + 1
			
			* Generate the EPA variables to be kept
			foreach var in $EPAVars {
				gen `var'_Keep = `var'
			}
			
		
	** Then merge with less disaggregation to progressively "fill in holes."
	foreach s in C D E F G H I J K L M N O P Q R S T {
		** Merge at most disaggregated
		save `Temp', replace

		use Data/EPAMPG/EPAMPG.dta, clear
		collapse (mean) $EPAVars, by($`s')
		sort $`s'
		save `TempUsing', replace

		use `Temp', clear
		sort $`s'
		merge $`s' using `TempUsing', nokeep keep($EPAVars) update /* The update option means that the imported VClass will only replace missing observations if the first model name didn't have a VClass */

		* Replace the EPA variables to be kept if ALL of the EPA GPM variables (other than class) are missing. This is like the "update" option, but it only updates any of them if they are _all_ missing.
		foreach var in $EPAVars {
				*Only replace MergeSuccessIter if there was an update to any of the MPG variables and if they were all previously empty.
			replace MergeSuccessIter`m' = `MergeSuccessIter' if _merge==4 & GPMA_Auto_Keep == . & GPMA_Manual_Keep == . & GPME_Auto_Keep == . & GPME_Manual_Keep == .
			replace `var'_Keep = `var' if MergeSuccessIter`m' == `MergeSuccessIter'
		}
		drop _merge
		local MergeSuccessIter = `MergeSuccessIter' + 1
	}

	* Rename the variables to be kept as `var'_EPA`m' to correspond to the EPA model number (1 or 2) that it matched to.
	foreach var in $EPAVars {
		rename `var'_Keep `var'_EPA`m'
		drop `var'
	}
	drop Model Submodel
} 


/* Generate the use`m' variable */
gen use1 = 0
gen use2 = 0
** If one of the m's merged with more than 2 levels of disaggregation better, use that instead of the average.
replace use1 = 1 if MergeSuccessIter1 < MergeSuccessIter2 - 2 & MergeSuccessIter1!=. & MergeSuccessIter2!=.
replace use2 = 1 if MergeSuccessIter2 < MergeSuccessIter1 - 2 & MergeSuccessIter1!=. & MergeSuccessIter2!=.
** If one of the m's merged at the most disaggregated level, including with missing Drive, then use that one instead of the average.
replace use1 = 1 if MergeSuccessIter1 == 1 & MergeSuccessIter2!=1
replace use2 = 1 if MergeSuccessIter2 == 1 & MergeSuccessIter1!=1
replace use1 = 1 if MergeSuccessIter1 == 2 & MergeSuccessIter2 > 2
replace use2 = 1 if MergeSuccessIter2 == 2 & MergeSuccessIter1 > 2

** Create mean of GPMs matched in for the first and second EPA model names. 
foreach var in $EPAVars {
	egen `var' = rowmean(`var'_EPA*)
    ** If one of the m's merged with the A level of disaggregation, use that one instead of the average.
    forvalues m = 1/2 {
    	replace `var' = `var'_EPA`m' if use`m'==1
    }

}


** Keep track of how successful the merge was and then drop use`m'
egen MergeSuccessIter = rowmean(MergeSuccessIter*)
forvalues m = 1/2 {
	replace MergeSuccessIter = MergeSuccessIter`m' if use`m'==1
	drop use`m'
}

drop GPMA_Auto_* GPMA_Manual_* GPME_Auto_* GPME_Manual_* VClass_*

rename PolkModel Model
rename PolkSubmodel Submodel

/* Manual recoding of SPV class.  Note these are NVPP make & model names. */
replace VClass=7 if Make=="Acura" & Model=="Slx" & VClass==11
replace VClass=6 if Make=="Amc/Eagle" & Model=="Eagle" & VClass==11
replace VClass=7 if Make=="Chevrolet" & Model=="Tracker" & VClass==11
replace VClass=9 if Make=="Chevrolet" & Model=="Venture" & VClass==11
replace VClass=7 if Make=="Chevrolet/Gmc" & Model=="Blazer/Jimmy" & VClass==11
replace VClass=7 if Make=="Chevrolet/Gmc" & Model=="Blazer/Yukon" & VClass==11
replace VClass=9 if Make=="Chevrolet/Gmc" & Model=="Lumina Apv" & VClass==11
replace VClass=8 if Make=="Chevrolet/Gmc" & Model=="Luv" & VClass==11
replace VClass=10 if Make=="Chevrolet/Gmc" & Model=="P Series" & VClass==11
replace VClass=8 if Make=="Chevrolet/Gmc" & Model=="S Series/Sonoma" & VClass==11
replace VClass=7 if Make=="Chevrolet/Gmc" & Model=="Tahoe/Yukon" & VClass==11
replace VClass=9 if Make=="Chrysler" & Model=="Town & Country" & VClass==11
replace VClass=7 if Make=="Daihatsu" & Model=="Rocky" & VClass==11
replace VClass=8 if Make=="Dodge" & Model=="D50" & VClass==11
replace VClass=8 if Make=="Dodge" & Model=="Dakota" & VClass==11
replace VClass=7 if Make=="Dodge" & Model=="Durango" & VClass==11
replace VClass=7 if Make=="Dodge" & Model=="Raider" & VClass==11
replace VClass=9 if Make=="Dodge/Plymouth" & Model=="Caravan/Voyager"
replace VClass=8 if Make=="Dodge/Plymouth" & Model=="D Series" & VClass==11
replace VClass=8 if Make=="Dodge/Plymouth" & Model=="D50/Arrow (Pickup)" & VClass==11
replace VClass=9 if Make=="Dodge/Plymouth" & Model=="Grand Caravan/Voyager" & VClass==11
replace VClass=7 if Make=="Dodge/Plymouth" & Model=="Ramcharger/Trailduster" & VClass==11
replace VClass=7 if Make=="Ford" & Model=="Bronco"
replace VClass=7 if Make=="Ford" & Model=="Bronco Ii" & VClass==11
replace VClass=8 if Make=="Ford" & Model=="Courier" & VClass==11
replace VClass=7 if Make=="Ford" & Model=="Expedition" & VClass==11
replace VClass=7 if Make=="Ford" & Model=="Explorer" & VClass==11
replace VClass=8 if Make=="Ford" & Model=="F Series" & VClass==11
replace VClass=8 if Make=="Ford" & Model=="Ranger" & VClass==11
replace VClass=9 if Make=="Ford" & Model=="Windstar" & VClass==11
replace VClass=7 if Make=="Geo" & Model=="Tracker" & VClass==11
replace VClass=7 if Make=="Honda" & Model=="Crv" & VClass==11
replace VClass=7 if Make=="Honda" & Model=="Passport" & VClass==11
replace VClass=7 if Make=="Infiniti" & Model=="Qx4" & VClass==11
replace VClass=7 if Make=="Isuzu" & Model=="Amigo" & VClass==11
replace VClass=7 if Make=="Isuzu" & Model=="Rodeo" & VClass==11
replace VClass=7 if Make=="Isuzu" & Model=="Trooper" & VClass==11
replace VClass=7 if Make=="Isuzu" & Model=="Trooper Ii" & VClass==11
replace VClass=7 if Make=="Jeep" & Model=="Cherokee" & VClass==11
replace VClass=8 if Make=="Jeep" & Model=="Cj Scrambler" & VClass==11
replace VClass=8 if Make=="Jeep" & Model=="Cj Series"
replace VClass=7 if Make=="Jeep" & Model=="Grand Cherokee" & VClass==11
replace VClass=7 if Make=="Jeep" & Model=="Grand Wagoneer" & VClass==11
replace VClass=7 if Make=="Jeep" & Model=="Wagoneer" & VClass==11
replace VClass=7 if Make=="Jeep" & Model=="Wrangler" & VClass==11
replace VClass=7 if Make=="Kia" & Model=="Sportage" & VClass==11
replace VClass=8 if Make=="Land Rover" & Model=="Defender 110" & VClass==11
replace VClass=8 if Make=="Land Rover" & Model=="Defender 90" & VClass==11
replace VClass=7 if Make=="Land Rover" & Model=="Discovery" & VClass==11
replace VClass=7 if Make=="Land Rover" & Model=="Range Rover" & VClass==11
replace VClass=7 if Make=="Lexus" & Model=="Lx 450" & VClass==11
replace VClass=7 if Make=="Lincoln" & Model=="Navigator" & VClass==11
replace VClass=8 if Make=="Mazda" & Model=="B Series" & VClass==11
replace VClass=9 if Make=="Mazda" & Model=="Mpv" & VClass==11
replace VClass=7 if Make=="Mazda" & Model=="Navajo" & VClass==11
replace VClass=7 if Make=="Mercedes-Benz" & Model=="M Class" & VClass==11
replace VClass=7 if Make=="Mercury" & Model=="Mountaineer" & VClass==11
replace VClass=9 if Make=="Mercury" & Model=="Villager" & VClass==11
replace VClass=7 if Make=="Mitsubishi" & Model=="Montero" & VClass==11
replace VClass=8 if Make=="Nissan/Datsun" & Model=="620" & VClass==11
replace VClass=7 if Make=="Nissan/Datsun" & Model=="Axxess" & VClass==11
replace VClass=7 if Make=="Nissan/Datsun" & Model=="Pathfinder" & VClass==11
replace VClass=8 if Make=="Nissan/Datsun" & Model=="Pickup" & VClass==11
replace VClass=9 if Make=="Nissan/Datsun" & Model=="Quest" & VClass==11
replace VClass=7 if Make=="Oldsmobile" & Model=="Bravada" & VClass==11
replace VClass=9 if Make=="Oldsmobile" & Model=="Silhouette" & VClass==11
replace VClass=9 if Make=="Pontiac" & Model=="Trans Sport" & VClass==11
replace VClass=7 if Make=="Porsche" & Model=="Cayenne" & VClass==11
replace VClass=8 if Make=="Subaru" & Model=="Brat" & VClass==11
replace VClass=7 if Make=="Subaru" & Model=="Forester" & VClass==11
replace VClass=3 if Make=="Subaru" & Model=="Justy" & VClass==11
replace VClass=3 if Make=="Subaru" & Model=="Loyale" & VClass==11
replace VClass=3 if Make=="Subaru" & Model=="Xt" & VClass==11
replace VClass=7 if Make=="Suzuki" & Model=="Samurai" & VClass==11
replace VClass=7 if Make=="Suzuki" & Model=="Sidekick" & VClass==11
replace VClass=7 if Make=="Toyota" & Model=="4Runner" & VClass==11
replace VClass=7 if Make=="Toyota" & Model=="Land Cruiser"
replace VClass=8 if Make=="Toyota" & Model=="Pickup" & VClass==11
replace VClass=7 if Make=="Toyota" & Model=="Rav4" & VClass==11
replace VClass=9 if Make=="Toyota" & Model=="Sienna" & VClass==11
replace VClass=7 if Make=="Amc/Eagle" & Model=="Cherokee" & VClass==11
replace VClass=7 if Make=="Amc/Eagle" & Model=="Jeep" & VClass==11
replace VClass=7 if Make=="Amc/Eagle" & Model=="Wagoneer" & VClass==11
replace VClass=7 if Make=="Amc/Eagle" & Model=="Wrangler" & VClass==11
replace VClass=8 if Make=="Chevrolet" & Model=="'S'Truck" & VClass==11
replace VClass=7 if Make=="Chevrolet" & Model=="Blazer" & VClass==11
replace VClass=8 if Make=="Chevrolet" & Model=="C10" & VClass==11
replace VClass=8 if Make=="Chevrolet" & Model=="C1500" & VClass==11
replace VClass=8 if Make=="Chevrolet" & Model=="C2500" & VClass==11
replace VClass=8 if Make=="Chevrolet" & Model=="Colorado" & VClass==11
replace VClass=8 if Make=="Chevrolet" & Model=="K10" & VClass==11
replace VClass=8 if Make=="Chevrolet" & Model=="K1500" & VClass==11
replace VClass=8 if Make=="Chevrolet" & Model=="K2500" & VClass==11
replace VClass=9 if Make=="Chevrolet" & Model=="Lumina Apv" & VClass==11
replace VClass=7 if Make=="Chevrolet" & Model=="R10 Conv" & VClass==11
replace VClass=7 if Make=="Chevrolet" & Model=="R1500" & VClass==11
replace VClass=7 if Make=="Chevrolet" & Model=="R2500" & VClass==11
replace VClass=8 if Make=="Chevrolet" & Model=="S10" & VClass==11
replace VClass=7 if Make=="Chevrolet" & Model=="Tahoe C1500" & VClass==11
replace VClass=7 if Make=="Chevrolet" & Model=="Tahoe K1500" & VClass==11
replace VClass=7 if Make=="Chevrolet" & Model=="V10 Conv" & VClass==11
replace VClass=7 if Make=="Chevrolet" & Model=="V1500" & VClass==11
replace VClass=7 if Make=="Chevrolet" & Model=="V20 Conv" & VClass==11
replace VClass=7 if Make=="Chevrolet" & Model=="V2500" & VClass==11
replace VClass=9 if Make=="Chevrolet" & Model=="Venture" & VClass==11
replace VClass=9 if Make=="Chrysler" & Model=="Town & Country" & VClass==11
replace VClass=7 if Make=="Daihatsu" & Model=="Rocky" & VClass==11
replace VClass=9 if Make=="Dodge" & Model=="Caravan" & VClass==11
replace VClass=3 if Make=="Dodge" & Model=="Colt" & VClass==11
replace VClass=8 if Make=="Dodge" & Model=="D200" & VClass==11
replace VClass=8 if Make=="Dodge" & Model=="D300" & VClass==11
replace VClass=8 if Make=="Dodge" & Model=="Dakota" & VClass==11
replace VClass=8 if Make=="Dodge" & Model=="Mini Ram" & VClass==11
replace VClass=7 if Make=="Dodge" & Model=="Ramcharger" & VClass==11
replace VClass=10 if Make=="Dodge" & Model=="Royal" & VClass==11
replace VClass=7 if Make=="Honda" & Model=="Cr-V" & VClass==11
replace VClass=7 if Make=="Honda" & Model=="Passport" & VClass==11
replace VClass=7 if Make=="Isuzu" & Model=="Rodeo" & VClass==11
replace VClass=7 if Make=="Isuzu" & Model=="Trooper" & VClass==11
replace VClass=7 if Make=="Jeep" & Model=="Cherokee" & VClass==11
replace VClass=7 if Make=="Jeep" & Model=="Grand Cherokee" & VClass==11
replace VClass=7 if Make=="Jeep" & Model=="Wagoneer" & VClass==11
replace VClass=7 if Make=="Jeep" & Model=="Wrangler" & VClass==11
replace VClass=7 if Make=="Jeep" & Model=="Wrangler/Yj" & VClass==11
replace VClass=7 if Make=="Kia" & Model=="Sportage" & VClass==11
replace VClass=7 if Make=="Land Rover" & Model=="Range Rover" & VClass==11
replace VClass=7 if Make=="Lexus" & Model=="Lx450" & VClass==11
replace VClass=7 if Make=="Lexus" & Model=="Lx470" & VClass==11
replace VClass=7 if Make=="Mazda" & Model=="Navajo" & VClass==11
replace VClass=7 if Make=="Mercedes-Benz" & Model=="Ml320" & VClass==11
replace VClass=9 if Make=="Mercury" & Model=="Villager" & VClass==11
replace VClass=7 if Make=="Mitsubishi" & Model=="Montero" & VClass==11
replace VClass=7 if Make=="Mitsubishi" & Model=="Monterosport" & VClass==11
replace VClass=8 if Make=="Nissan" & Model=="D21" & VClass==11
replace VClass=7 if Make=="Nissan" & Model=="Pathfinder" & VClass==11
replace VClass=9 if Make=="Nissan" & Model=="Quest" & VClass==11
replace VClass=9 if Make=="Oldsmobile" & Model=="Silhouette" & VClass==11
replace VClass=3 if Make=="Plymouth" & Model=="Colt" & VClass==11
replace VClass=9 if Make=="Plymouth" & Model=="Voyager" & VClass==11
replace VClass=9 if Make=="Pontiac" & Model=="Trans Sport" & VClass==11
replace VClass=7 if Make=="Porsche" & Model=="Che Cayenne" & VClass==11
replace VClass=3 if Make=="Subaru" & Model=="Brat" & VClass==11
replace VClass=3 if Make=="Subaru" & Model=="Dl" & VClass==11
replace VClass=7 if Make=="Subaru" & Model=="Forester" & VClass==11
replace VClass=3 if Make=="Subaru" & Model=="Gl" & VClass==11
replace VClass=3 if Make=="Subaru" & Model=="Gl-10" & VClass==11
replace VClass=7 if Make=="Suzuki" & Model=="Jimny" & VClass==11
replace VClass=7 if Make=="Suzuki" & Model=="Samurai" & VClass==11
replace VClass=7 if Make=="Suzuki" & Model=="Sidekick" & VClass==11
replace VClass=7 if Make=="Suzuki" & Model=="Sidekick(U.S.)" & VClass==11
replace VClass=7 if Make=="Toyota" & Model=="4 Runner" & VClass==11
replace VClass=8 if Make=="Toyota" & Model=="Cab/Chassis" & VClass==11
replace VClass=8 if Make=="Toyota" & Model=="Halfton Pickup" & VClass==11
replace VClass=7 if Make=="Toyota" & Model=="Landcruiser" & VClass==11
replace VClass=7 if Make=="Toyota" & Model=="Landcruiser S/W" & VClass==11
replace VClass=8 if Make=="Toyota" & Model=="Long Bed 1 Ton" & VClass==11
replace VClass=7 if Make=="Toyota" & Model=="Rav4" & VClass==11
replace VClass=8 if Make=="Toyota" & Model=="Xtracab" & VClass==11

tab VClass
replace VClass=round(VClass,1)
replace VClass=. if VClass==11

/* Collapse observations where Polk tried two different Litres */
egen Group = group(Make Model Submodel Trim Cylinders Drive FuelType BodyStyle ModelYear), missing
sort Make Model Submodel Trim Cylinders Drive FuelType BodyStyle ModelYear Liters OriginalLiters
gen flag = cond(Group==Group[_n-1] & (Liters==Liters[_n-1]|Liters==Liters[_n-1]+1) & (OriginalLiters==OriginalLiters[_n-1]|OriginalLiters==OriginalLiters[_n-1]+1|OriginalLiters==OriginalLiters[_n-1]-1),1,0)
	* This is old code. It is in error because it will collapse across vehicles with true liter differences of 0.2. The mistakes in Polk are typically of 0.1 Liters.
	* sort Make Model Submodel Trim Cylinders Drive FuelType BodyStyle ModelYear Liters
	* gen flag = cond(Group==Group[_n-1] & (Liters==Liters[_n-1]|Liters==Liters[_n-1]+1),1,0)
replace Liters = Liters[_n-1] if flag == 1
replace Liters = Liters+1 /* This gets us to the original Liters rating if we did the append with different liters above. Now we can collapse over these values. */
* drop flag

** Within each {Group Liters}, we want to keep the data that merged at the best level of aggregation
bysort Group Liters: egen BestMergeSuccessIter = min(MergeSuccessIter)
drop if MergeSuccessIter!=BestMergeSuccessIter

** Then collapse across all observations that are tied for best
	* Note that there is no reason to collapse over submodel because we can't merge on it later. A submodel change always is accompanied by a Group change.
collapse (mean) PctManual GPM* VClass MergeSuccessIter Unrated (sum) reg*, by(Make Model ModelYear Trim Cylinders Liters FuelType BodyStyle Drive)

/* Diagnostic */
gen RoundingFlag = (VClass>6 & floor(VClass)~=VClass)
list Make Model if RoundingFlag

replace VClass = round(VClass,1)
replace VClass = . if VClass==11



** First, fully populate the PctManual field. If missing, then replace with PctManual from similar vehicles. 
	* Define similar vehicles in decreasing similarity, as above.
		* First sacrifice on one variable
global A "Make Model Cylinders Liters FuelType BodyStyle ModelYear Trim"
global B "Make Model Cylinders Liters FuelType BodyStyle ModelYear"
global C "Make Model Cylinders Liters FuelType BodyStyle Trim"
global D "Make Model Cylinders Liters FuelType ModelYear Trim"
global E "Make Model Cylinders Liters BodyStyle ModelYear Trim"
global F "Make Model Cylinders FuelType BodyStyle ModelYear Trim"
global G "Make Model Liters FuelType BodyStyle ModelYear Trim"

		* Then on two
global H "Make Model Cylinders Liters FuelType BodyStyle"
global I "Make Model Cylinders Liters FuelType Trim"
global J "Make Model Cylinders Liters ModelYear Trim"
global K "Make Model Cylinders BodyStyle ModelYear Trim"
global L "Make Model FuelType BodyStyle ModelYear Trim"

		* Then on more
global M "Make Model Cylinders Liters ModelYear"
global N "Make Model Liters ModelYear"
global O "Make Model Cylinders ModelYear"

global P "Make Model Liters"
global Q "Make Model Cylinders"
global R "Make Model ModelYear"
global S "Make Model"
global T "Make ModelYear"
global U "Make"
	
foreach s in A B C D E F G H I J K L M N O P Q R S T U {
	bysort $`s': egen AvPctManual = mean(PctManual) 
	replace PctManual = AvPctManual if PctManual == .
	drop AvPctManual
}
sum PctManual
replace PctManual = r(mean) if PctManual==.



/* Generate MPG depending on the transmission */
foreach f in A E {
	* If either Manual or Auto missing, then use the non-missing
gen GPM`f' = GPM`f'_Auto if GPM`f'_Manual == .
replace GPM`f' = GPM`f'_Manual if GPM`f'_Auto == .

	*Otherwise, weight by PctManual.
replace GPM`f' = PctManual*GPM`f'_Manual + (1-PctManual)*GPM`f'_Auto if GPM`f'_Manual!=. & GPM`f'_Auto!=.

}

* Note we could keep PctManual if we needed it for anything else....
drop PctManual GPMA_* GPME_*

/* Merge to CarID just to get make and model names from the prefix file. */
sort Make Model ModelYear Trim Cylinders Liters FuelType BodyStyle Drive
merge Make Model ModelYear Trim Cylinders Liters FuelType BodyStyle Drive using Data/Matchups/NVPPToPrefix, keep(CarID)
tab _merge

/* There were EPA records that did not match the NVPP.  In practice, these aren't a big problem - most of these
   were just "experiments" with different liters, so in fact they are already matched.  That is, we have already
   have a match for nearly every CarID */
keep if _merge==3
drop _merge


/* Merge in Prefix file model names */
rename Make NVPPMake
rename Model NVPPModel
sort CarID
merge CarID using Data/Matchups/IDToNames, keep(Make Model)
tab _merge
tab CarID if _merge<3, m
drop if _merge<3
drop _merge

/* Recode VClass manually when there are multiple values, or when it is missing */
* This code is now for the Prefix file model names, which we later use in AutoPQX.dta
replace VClass=7 if Make=="Amc/Eagle" & Model=="Cherokee"
replace VClass=7 if Make=="Amc/Eagle" & Model=="Summit"
replace VClass=2 if Make=="Audi" & Model=="Tt"
replace VClass=5 if Make=="Bentley" & Model=="Continental"
replace VClass=4 if Make=="Bmw" & Model=="M3"
replace VClass=8 if Make=="Chevrolet" & Model=="'S'Truck"
replace VClass=7 if Make=="Chevrolet" & Model=="Blazer"
replace VClass=8 if Make=="Chevrolet" & Model=="C1500"
replace VClass=8 if Make=="Chevrolet" & Model=="C2500"
replace VClass=8 if Make=="Chevrolet" & Model=="K1500"
replace VClass=8 if Make=="Chevrolet" & Model=="K2500"
replace VClass=7 if Make=="Chevrolet" & Model=="R1500"
replace VClass=7 if Make=="Chevrolet" & Model=="R2500"
replace VClass=7 if Make=="Chevrolet" & Model=="V1500"
replace VClass=7 if Make=="Chevrolet" & Model=="V2500"
replace VClass=5 if Make=="Chrysler" & Model=="Lebaron"
replace VClass=4 if Make=="Chrysler" & Model=="Pt Cruiser"
replace VClass=9 if Make=="Chrysler" & Model=="Town & Country"
replace VClass=5 if Make=="Dodge" & Model=="600"
replace VClass=3 if Make=="Dodge" & Model=="Colt"
replace VClass=8 if Make=="Dodge" & Model=="D150"
replace VClass=8 if Make=="Dodge" & Model=="D200"
replace VClass=8 if Make=="Dodge" & Model=="D300"
replace VClass=8 if Make=="Dodge" & Model=="Dakota"
replace VClass=5 if Make=="Dodge" & Model=="Lancer"
replace VClass=4 if Make=="Ford" & Model=="Escort"
replace VClass=7 if Make=="Ford" & Model=="Explorer"
replace VClass=8 if Make=="Ford" & Model=="Lgt Convtnl 'F'"
replace VClass=8 if Make=="Ford" & Model=="Ranger"
replace VClass=3 if Make=="Ford" & Model=="Thunderbird"
replace VClass=3 if Make=="Geo" & Model=="Metro"
replace VClass=5 if Make=="Honda" & Model=="Accord"
replace VClass=4 if Make=="Honda" & Model=="Civic"
replace VClass=7 if Make=="Honda" & Model=="Cr-V"
replace VClass=7 if Make=="Honda" & Model=="Passport"
replace VClass=5 if Make=="Infiniti" & Model=="G35"
replace VClass=5 if Make=="Infiniti" & Model=="M45"
replace VClass=7 if Make=="Isuzu" & Model=="Rodeo"
replace VClass=6 if Make=="Jaguar" & Model=="Xj"
replace VClass=6 if Make=="Jaguar" & Model=="Xjr"
replace VClass=6 if Make=="Jaguar" & Model=="Xjrs"
replace VClass=6 if Make=="Jaguar" & Model=="Xjs"
replace VClass=7 if Make=="Jeep" & Model=="Cherokee"
replace VClass=7 if Make=="Jeep" & Model=="Wrangler/Tj"
replace VClass=7 if Make=="Land Rover" & Model=="Discovery"
replace VClass=7 if Make=="Land Rover" & Model=="Range Rover"
replace VClass=3 if Make=="Maserati" & Model=="M138"
replace VClass=9 if Make=="Mazda" & Model=="5"
replace VClass=9 if Make=="Mazda" & Model=="Wagon"
replace VClass=3 if Make=="Mercedes-Benz" & Model=="300"
replace VClass=3 if Make=="Mercedes-Benz" & Model=="380"
replace VClass=4 if Make=="Mercedes-Benz" & Model=="400"
replace VClass=4 if Make=="Mercedes-Benz" & Model=="500"
replace VClass=4 if Make=="Mercedes-Benz" & Model=="560"
replace VClass=3 if Make=="Mercedes-Benz" & Model=="E320"
replace VClass=4 if Make=="Mercedes-Benz" & Model=="S500"
replace VClass=4 if Make=="Mercedes-Benz" & Model=="S600"
replace VClass=2 if Make=="Mini" & Model=="Min Cooper"
replace VClass=7 if Make=="Mitsubishi" & Model=="Monterosport"
replace VClass=3 if Make=="Nissan" & Model=="300Zx"
replace VClass=5 if Make=="Nissan" & Model=="Altima"
replace VClass=8 if Make=="Nissan" & Model=="D21"
replace VClass=8 if Make=="Nissan" & Model=="Frontier"
replace VClass=7 if Make=="Nissan" & Model=="Pathfinder"
replace VClass=4 if Make=="Nissan" & Model=="Sentra"
replace VClass=4 if Make=="Nissan" & Model=="Stanza"
replace VClass=3 if Make=="Plymouth" & Model=="Colt"
replace VClass=6 if Make=="Pontiac" & Model=="Bonneville"
replace VClass=9 if Make=="Pontiac" & Model=="Trans Sport"
replace VClass=2 if Make=="Porsche" & Model=="928"
replace VClass=4 if Make=="Saab" & Model=="900"
replace VClass=2 if Make=="Saab" & Model=="93"
replace VClass=8 if Make=="Subaru" & Model=="Brat"
replace VClass=3 if Make=="Subaru" & Model=="Dl"
replace VClass=3 if Make=="Subaru" & Model=="Gl"
replace VClass=5 if Make=="Subaru" & Model=="Legacy"
replace VClass=2 if Make=="Subaru" & Model=="Xt"
replace VClass=7 if Make=="Toyota" & Model=="4 Runner"
replace VClass=5 if Make=="Toyota" & Model=="Camry Solara"
replace VClass=10 if Make=="Volkswagen" & Model=="Eurovan"
replace VClass=3 if Make=="Volkswagen" & Model=="Golf"
replace VClass=5 if Make=="Volvo" & Model=="V70"
replace VClass=5 if Make=="Volvo" & Model=="Xc70"
replace VClass=9 if Make=="Dodge" & Model=="Caravan"
replace VClass=8 if Make=="Ford" & Model=="Ranger Super"
replace VClass=7 if Make=="Jeep" & Model=="Wrangler Se"
replace VClass=9 if Make=="Mazda" & Model=="Mpv"
replace VClass=7 if Make=="Mercury" & Model=="Mountaineer"
replace VClass=7 if Make=="Oldsmobile" & Model=="Bravada"
replace VClass=9 if Make=="Plymouth" & Model=="Voyager"
replace VClass=7 if Make=="Isuzu" & Model=="Amigo"
replace VClass=7 if Make=="Mitsubishi" & Model=="Montero"

replace VClass=4 if Make=="Alfa Romeo" & Model=="164" & VClass==.
replace VClass=2 if Make=="Alfa Romeo" & Model=="8C Competizione" & VClass==.
replace VClass=4 if Make=="Amc/Eagle" & Model=="Concord" & VClass==.
replace VClass=7 if Make=="Amc/Eagle" & Model=="Jeep" & VClass==.
replace VClass=7 if Make=="Amc/Eagle" & Model=="Jeep Truck (Can)" & VClass==.
replace VClass=3 if Make=="Amc/Eagle" & Model=="Spirit" & VClass==.
replace VClass=7 if Make=="Amc/Eagle" & Model=="Wagoneer (Canada)" & VClass==.
replace VClass=5 if Make=="Bmw" & Model=="325" & VClass==.
replace VClass=5 if Make=="Bmw" & Model=="325/325E" & VClass==.
replace VClass=5 if Make=="Bmw" & Model=="325E" & VClass==.
replace VClass=5 if Make=="Bmw" & Model=="533I" & VClass==.
replace VClass=3 if Make=="Bmw" & Model=="633Csi" & VClass==.
replace VClass=3 if Make=="Bmw" & Model=="635Csia/L6" & VClass==.
replace VClass=6 if Make=="Bmw" & Model=="733I" & VClass==.
replace VClass=6 if Make=="Bmw" & Model=="L7" & VClass==.
replace VClass=7 if Make=="Bmw" & Model=="X6" & VClass==.
replace VClass=4 if Make=="Cadillac" & Model=="60 Special" & VClass==.
replace VClass=8 if Make=="Chevrolet" & Model=="3500" & VClass==.
replace VClass=8 if Make=="Chevrolet" & Model=="4000" & VClass==.
replace VClass=8 if Make=="Chevrolet" & Model=="G/P" & VClass==.
replace VClass=8 if Make=="Chevrolet" & Model=="V10 Conv" & VClass==.
replace VClass=5 if Make=="Chrysler" & Model=="Cordoba" & VClass==.
replace VClass=5 if Make=="Chrysler" & Model=="E Class" & VClass==.
replace VClass=5 if Make=="Dodge" & Model=="400" & VClass==.
replace VClass=2 if Make=="Dodge" & Model=="Challngr(Sub-Cpt)" & VClass==.
replace VClass=5 if Make=="Dodge" & Model=="Mirada" & VClass==.
replace VClass=7 if Make=="Dodge" & Model=="Nitro" & VClass==.
replace VClass=2 if Make=="Dodge" & Model=="Rampage" & VClass==.
replace VClass=2 if Make=="Dodge" & Model=="Royal" & VClass==.
replace VClass=10 if Make=="Dodge" & Model=="Sprinter" & VClass==.
replace VClass=2 if Make=="Ferrari" & Model=="599 Gtb" & VClass==.
replace VClass=2 if Make=="Ferrari" & Model=="612Scaglietti" & VClass==.
replace VClass=2 if Make=="Ferrari" & Model=="F131" & VClass==.
replace VClass=2 if Make=="Ferrari" & Model=="F575Superamerica" & VClass==.
replace VClass=8 if Make=="Ford" & Model=="Courier" & VClass==.
replace VClass=7 if Make=="Ford" & Model=="Excursion" & VClass==.
replace VClass=4 if Make=="Ford" & Model=="Fairmont" & VClass==.
replace VClass=7 if Make=="Jeep" & Model=="Wranglerunlimited" & VClass==.
replace VClass=5 if Make=="Lexus" & Model=="Gs460" & VClass==.
replace VClass=6 if Make=="Lexus" & Model=="Is-F" & VClass==.
replace VClass=7 if Make=="Lexus" & Model=="Lx570" & VClass==.
replace VClass=7 if Make=="Lexus" & Model=="Rx350" & VClass==.
replace VClass=7 if Make=="Lincoln" & Model=="Navigator L" & VClass==.
replace VClass=3 if Make=="Maserati" & Model=="Biturbo" & VClass==.
replace VClass=6 if Make=="Mazda" & Model=="929" & VClass==.
replace VClass=7 if Make=="Mazda" & Model=="Navajo" & VClass==.
replace VClass=2 if Make=="Mazda" & Model=="Rx7" & VClass==.
replace VClass=2 if Make=="Mercedes-Benz" & Model=="C55Amg" & VClass==.
replace VClass=2 if Make=="Mercedes-Benz" & Model=="C63Amg" & VClass==.
replace VClass=7 if Make=="Mercedes-Benz" & Model=="Gl450" & VClass==.
replace VClass=7 if Make=="Mercedes-Benz" & Model=="Gl550" & VClass==.
replace VClass=7 if Make=="Mercedes-Benz" & Model=="Ml55" & VClass==.
replace VClass=2 if Make=="Mercedes-Benz" & Model=="Slr" & VClass==.
replace VClass=4 if Make=="Mercury" & Model=="Zephyr" & VClass==.
replace VClass=2 if Make=="Nissan" & Model=="280Zx" & VClass==.
replace VClass=2 if Make=="Nissan" & Model=="300Zx (Canada)" & VClass==.
replace VClass=2 if Make=="Nissan" & Model=="Micra (Canada)" & VClass==.
replace VClass=2 if Make=="Nissan" & Model=="Pulsar Nx (Can)" & VClass==.
replace VClass=7 if Make=="Nissan" & Model=="Rogue" & VClass==.
replace VClass=4 if Make=="Nissan" & Model=="Sentra (Canada)" & VClass==.
replace VClass=4 if Make=="Oldsmobile" & Model=="Omega-X Body" & VClass==.
replace VClass=3 if Make=="Plymouth" & Model=="Sapporo" & VClass==.
replace VClass=2 if Make=="Plymouth" & Model=="Scamp" & VClass==.
replace VClass=9 if Make=="Plymouth" & Model=="Voyager Pb Series" & VClass==.
replace VClass=6 if Make=="Pontiac" & Model=="G8" & VClass==.
replace VClass=4 if Make=="Pontiac" & Model=="J2000" & VClass==.
replace VClass=4 if Make=="Pontiac" & Model=="Phoenix-X Body" & VClass==.
replace VClass=3 if Make=="Suzuki" & Model=="Sa310" & VClass==.
replace VClass=7 if Make=="Suzuki" & Model=="Sidekick" & VClass==.
replace VClass=7 if Make=="Suzuki" & Model=="Sidekick(U.S.)" & VClass==.
replace VClass=7 if Make=="Toyota" & Model=="Landcruiser" & VClass==.
replace VClass=8 if Make=="Toyota" & Model=="Long Bed Dlx" & VClass==.
replace VClass=8 if Make=="Toyota" & Model=="Short Bed Sr5" & VClass==.
replace VClass=8 if Make=="Toyota" & Model=="Short Bed Std" & VClass==.
replace VClass=8 if Make=="Toyota" & Model=="Shrt Bd Xtrcb Dlx" & VClass==.
replace VClass=8 if Make=="Toyota" & Model=="Shrt Bd Xtrcb Sr5" & VClass==.
replace VClass=3 if Make=="Toyota" & Model=="Starlet" & VClass==.
replace VClass=2 if Make=="Tvr" & Model=="Tvr" & VClass==.
replace VClass=4 if Make=="Volvo" & Model=="V40" & VClass==.
replace VClass=6 if Make=="Volvo" & Model=="242" & VClass==.

replace VClass=6 if Make=="Ford" & Model=="Taurus" & VClass==.
replace VClass=9 if Make=="Dodge" & Model=="Caravan" & VClass==.
replace VClass=7 if Make=="Bmw" & Model=="X6" & VClass==.
replace VClass=8 if Make=="Mitsubishi" & Model=="Raider" & VClass==.

/* Recode some vans as minivans - EPA did not break this out before 1998. */
replace VClass = 9 if Model=="Aerostar"
replace VClass = 9 if Model=="Previa"
* Wikipedia calls this a minivan
replace VClass = 9 if Make=="Toyota" & Model=="Van Wagon"

* All other vans are vans, including the Vanagon, which Wikipedia calls a Van. Also the Mazda MPV, a minivan, has model name "Van," so this is correct also to have the Model name "Van" classified as a minivan.

/* Several other mis-classifications */
** The Suzuki Jimny is miscoded as a van.
replace VClass = 7 if Model=="Jimny"
replace VClass = 8 if Make =="Toyota" & (Model=="Pickup 4 X 4"|Model=="Halfton Pickup"|Model=="Long Bed 3/4 Tn")

replace VClass = 8 if Make == "Toyota" & (Model=="Xtracab"|Model=="Xtracab 4 X 4")
replace VClass = 8 if Model == "S10"

/* For all other vehicles, get VClass if there is disagreement across model years. */
sort Make Model VClass
by Make Model: egen MinClass = min(VClass)
by Make Model: egen MaxClass = max(VClass)
replace VClass = MaxClass if MinClass==MaxClass-1 & MaxClass<=6
replace MinClass = MaxClass if MinClass==MaxClass-1 & MaxClass<=6
replace VClass = MinClass if VClass==. & MinClass==MaxClass
by Make Model: gen firstrec = (_n==1)
gen SameClass = (MinClass==MaxClass)
list Make Model MinClass MaxClass if SameClass==0 & firstrec
list Make Model if MinClass==. & firstrec
drop SameClass firstrec MinClass MaxClass


/* Get the best guess at GPM for each CarID */
/* We want to collapse while weighting by quantity to get the quantity-weighted average GPM. */
egen Quantity = rowmean(reg2003 reg2004 reg2005 reg2006 reg2007 reg2008)
* In some VINs, NVPP model is missing, so _some_ of the observations here within a CarID couldn't be matched, while others could. Want to ignore these in the collapse and only weight observations where a match was even possible. This adds a few observations, in particular in AMC/Eagle.
	* Add the latter condition because in a couple of cases we are able to match missing NVPP names to an actual model in the Matchups.csv file.
replace Quantity = . if NVPPModel=="" & (GPMA==.&GPME==.)

*********************

foreach var in GPMA GPME VClass MergeSuccessIter {
		* The first five merges are very precise, compromising only on model year and submodel. After this, we compromise on Drive, which begins to introduce measurement error.
	replace `var' = . if MergeSuccessIter > 5
	replace `var' = . if ModelYear<1984
	replace `var' = . if Unrated==1
	replace `var' = . if FuelType!="Gas"
}
gen N = 1
gen NGPM = cond(GPMA!=.,1,0)
* Note that we can collapse with aw=Quantity because all row here have > 0 quantity
collapse (sum) N NGPM (mean) GPMA GPME VClass Unrated MergeSuccessIter [aw=Quantity], by(CarID ModelYear)

/* Drop observations with poor matches to MPG */
* Drop observations where very few had proper MPG matches. 
	* There are about 984 that are dropped because they match less than 10%, including most of which match zero percent. These are largely heavy trucks that are Unrated, or poor matches with MergeSuccessIter>5 because they have strange Cylinders/Liters or are special editions.
gen PctWithinCarIDwithGPM = NGPM/N
drop NGPM N

foreach var in GPMA GPME VClass {
	replace `var' = . if PctWithinCarIDwithGPM < 0.1

	* Also drop the observations where more than 10% were Unrated - these were typically vehicles too large to count as Light Duty Vehicles.
		* Another 1150 or so vehicles are dropped because they are Unrated.
	replace `var' = . if Unrated>.1
}

** In 5 cases, a CarID ends up with a non-integer VClass. In these cases, round - they are close to an integer, appears that there are simply several mis-classifications.
replace VClass=round(VClass) if VClass!=round(VClass)

capture label drop ClassLabel
label define ClassLabel 1 "Two-Seater" 2 "Minicompact" 3 "Subcompact" 4 "Compact" 5 "Mid-Size" 6 "Large" 7 "SUV" 8 "Pickup" 9 "Minivan" 10 "Van" 11 "SPV" -1 "Missing"
label values VClass ClassLabel
tab VClass

gen InEPA=1
sort CarID ModelYear
save Data/EPAMPG/EPAByID, replace

log close
set more on

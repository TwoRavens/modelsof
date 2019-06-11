/* NHTSDataPrep.do */
* Note: the NHTS uses the Census definition of urban/rural; see page 11 of DerivedVariables.pdf
* Census definition is available from https://www.census.gov/geo/reference/urban-rural.html.

/* Define a program to prep NHTS vars needed in both Trip and Household files */
clear programs
program define PrepNHTSVars

** Merge Census tract information
merge m:1 houseid using $Externals/Calculations/NHTS/NHTSCTracts.dta, keepusing(gisjoin) keep(match master) nogen
merge m:1 gisjoin using $Externals/Calculations/Geographic/Tr_Data.dta, keepusing(TractMedIncome) keep(match master) nogen

** TractMedIncomeGroups
gen TractMedIncome_Group = round(TractMedIncome/10000)
replace TractMedIncome_Group=3 if TractMedIncome_Group<3
replace TractMedIncome_Group=8 if TractMedIncome_Group>8
replace TractMedIncome_Group=TractMedIncome_Group*10

** Food desert designations
merge m:1 gisjoin using $Externals/Calculations/Geographic/TracttoZip.dta, keepusing(zip_code) keep(match master) nogen
gen year = 2008 // 71% of trips in 2008, 29% in 2009. ZBP is as of March 10 of each year. It takes perhaps two quarters for expenditures to shift to entrant stores. So we use 2008.

merge m:1 zip_code year using $Externals/Calculations/StoreEntryExit/ZipCodeBusinessPatterns.dta, keep(match master) keepusing(est_LargeGroc est_SuperClub) nogen // Only a handful of observations unmatched from master
gen byte FoodDesert = cond(est_LargeGroc+est_SuperClub==0,1,0)

drop year

** Household income groups
gen HHIncome = .
replace HHIncome = 2.5 if hhfaminc==1
replace HHIncome = 7.5 if hhfaminc==2
replace HHIncome = 12.5 if hhfaminc==3
replace HHIncome = 17.5 if hhfaminc==4
replace HHIncome = 22.5 if hhfaminc==5
replace HHIncome = 27.5 if hhfaminc==6
replace HHIncome = 32.5 if hhfaminc==7
replace HHIncome = 37.5 if hhfaminc==8
replace HHIncome = 42.5 if hhfaminc==9
replace HHIncome = 47.5 if hhfaminc==10
replace HHIncome = 52.5 if hhfaminc==11
replace HHIncome = 57.5 if hhfaminc==12
replace HHIncome = 62.5 if hhfaminc==13
replace HHIncome = 67.5 if hhfaminc==14
replace HHIncome = 72.5 if hhfaminc==15
replace HHIncome = 77.5 if hhfaminc==16
replace HHIncome = 90 if hhfaminc==17
replace HHIncome = 150 if hhfaminc==18

gen HHIncome_Group = floor(HHIncome/10)*10+5 if HHIncome<90
replace HHIncome_Group = 90 if HHIncome==90
replace HHIncome_Group = 100 if HHIncome==150

** 
replace htppopdn = htppopdn/1000

**
gen Urban = cond(urbrur==1,1,0) if urbrur!=-9

** 
gen NoCar= cond(hhvehcnt==0,1,0)

**
gen byte Dense = cond(htppopdn>=7,1,0) // Gets everything with more than 4,000 people per square mile.
gen byte LowIncome = cond(HHIncome<25,1,0)
gen byte DenseLowIncome = Dense*LowIncome
gen byte DenseLowIncomeNoCar = DenseLowIncome*NoCar
gen byte LowIncomeFD = LowIncome*FoodDesert
gen byte LowIncomeFDNoCar = LowIncome*FoodDesert*NoCar

gen byte UrbanLowIncome = Urban*LowIncome
gen byte UrbanFD = Urban*FoodDesert
gen byte UrbanNoCar = Urban*NoCar
gen byte UrbanLowIncomeFD = Urban*LowIncome*FoodDesert
gen byte UrbanLowIncomeFDNoCar = Urban*LowIncome*FoodDesert*NoCar
gen byte UrbanFDNoCar = Urban*FoodDesert*NoCar

gen byte FoodDesertNoCar = FoodDesert*NoCar

end



/* CENSUS TRACTS */
insheet using $Externals/Data/NHTS/hhct.csv, comma names clear
tostring hhstfips,gen(stateFIPS)
replace stateFIPS="0"+stateFIPS if length(stateFIPS)==1
tostring hhcntyfp,gen(countyFIPS)
replace countyFIPS="00"+countyFIPS if length(countyFIPS)==1
replace countyFIPS="0"+countyFIPS if length(countyFIPS)==2
tostring hhct,gen(CTract)
replace CTract="000"+CTract if length(CTract)==3
replace CTract="00"+CTract if length(CTract)==4
replace CTract="0"+CTract if length(CTract)==5
gen gisjoin = "G"+stateFIPS+"0"+countyFIPS+"0"+CTract
saveold $Externals/Calculations/NHTS/NHTSCTracts.dta, replace


/* HOUSEHOLDS */
insheet using $Externals/Data/NHTS/HHV2PUB.csv, comma names clear
keep wthhfin hhfaminc htppopdn hhvehcnt houseid urbrur
foreach var in hhfaminc htppopdn hhvehcnt {
	replace `var' = . if `var'<0
}
PrepNHTSVars


sum Urban [aw=wthhfin]
bysort Urban: sum NoCar [aw=wthhfin]
saveold $Externals/Calculations/NHTS/NHTSHouseholds.dta, replace

/* TRIPS FILE */
	* whyto = trip purpose
	* trpmiles 
	* educ: categorical education variable
	* hbhur: urban/rural 
	* urban: urban/rural (use this one?)
	* hbppopdn: Pop density per square mile of block group
	* hbppopdn: Census tract pop density
	* hhfaminc: income
	* hh_race
	* houseid: house id number
	* trpmiles: Calculated trip distance converted into miles
	* trptrans: transportation mode used on trip
	* trvlcmin: Calculated travel time
	* trvl_min: derived trip time - minutes. Not clear but I think I will use this instead of trvlcmin; they are the same in almost all cases anyway.
	* wttrdfin: final trip weight
	
insheet using $Externals/Data/NHTS/DAYV2PUB.csv, comma names clear

** Replace with missing if negative
foreach var in trvlcmin trvl_min trpmiles trptrans hhfaminc whyto whyfrom htppopdn {
	replace `var' = . if `var'<0
}


** Drop non-valid trips
** Valid trip indicator: don't use trips over 50 miles or over 120 minutes
gen valid = (trpmiles<50&trvl_min<120)
replace valid = 0 if inlist(trptrans,12,13,15,21) // take out airplane and Amtrak/inter city train and city-to-city bus and charter-tour bus
drop if valid==0


PrepNHTSVars

** To and from
gen FromHome = (whyfrom==1)
gen ToHome = (whyto==1)
gen ToORFromHome = FromHome+ToHome

*sort houseid personid travday tdtrpnum
*gen CombinedTrip = cond(ToHome==0|(FromHome[_n-1]==0&personid==personid[_n-1]&tdtrpnum==tdtrpnum[_n-1]),1,0)

gen GroceryTrip = (whyto==41|whyfrom==41)

bysort houseid personid travday: egen Maxtrpmiles=max(trpmiles)


gen T_Auto = (inlist(trptrans,1,2,3,4,5,6,7,8))
gen T_Public = (inlist(trptrans,9,10,11,12,13,14,15,16,17,18,20))
gen T_WalkBike = (inlist(trptrans,22,23))
*gen T_Taxi = (inlist(trptrans,19))
*gen T_Other = (inlist(trptrans,21,24,97)) // Airplane, disability transit, and other

* Keep only trips where we have all variables
*keep if trvl_min!=.&trpmiles!=.&trptrans!=.&hhfaminc!=.

compress
saveold $Externals/Calculations/NHTS/NHTSTrips.dta, replace


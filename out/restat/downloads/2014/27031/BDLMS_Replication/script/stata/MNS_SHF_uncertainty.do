
* REPLICATE MENDELSOHN NORDHAUS SHAW (MNS) 1994 + SCHLENKER HANEMANN FISHER (SHF) 2005 AND THEN EVALUATE ACROSS ENSEMBLE

clear all
set more off
set mem 100m

* INSERT DIRECTORY WHERE REPLICATION FILE WAS UNZIPPED INTO QUOTATION MARKS:
cd ""
cd data/MNS_SHF/

* Prepare data.  Data files are from SHF replication, available on AER website
insheet using censusData.csv, comma clear
save censusData, replace
insheet using cityAndCountyData.csv, comma clear
save cityAndCountyData, replace
insheet using MNSdata.csv, comma clear
drop if fips==.
merge 1:1 fips using censusData
keep if _merge==3
drop _merge
merge 1:1 fips using cityAndCountyData
keep if _merge==3
drop _merge
des, s //so same # of obs as MNS

* Generate irrigated indicator and urban indicator
* From SHF:  irrigated is if >20% of cropland is irrigated; urban is if popdensity > 400 people per sq mile
* Following their matlab code for creating these variables
gen pop1982 = (population1980 + population1984)/2
gen popdens = pop1982/countyarea1982/0.00156 //last number converts acres to square miles
gen urban = popdens>400 | pop1982>200000
tab urban  //matches SHF
gen irrpct = irrigharvcropland1982/harvestedcropland1982 if irrigharvcropland1982~=(-1000) & harvestedcropland1982~=(-1000)
gen repl = (irrigharvcropland1982==(-1000) | harvestedcropland1982==(-1000))
forvalues i = 1987(5)1997 {  //replacing the 1982 value with later census data if 1982 missing
	replace irrpct = irrigharvcropland`i'/harvestedcropland`i' if repl==1 & irrigharvcropland`i'~=(-1000) & harvestedcropland`i'~=(-1000)
	replace repl = 0 if repl==1 & irrigharvcropland`i'!=(-1000) & harvestedcropland`i'~=(-1000)
	}
gen upr=0
forvalues i = 1982(5)1997 {  //replacing the remainder of the missings with a slighly different irrigation measure
	gen upr1 = harvcroplandinirrigfarm`i'/harvestedcropland`i' 
	replace upr = upr1 if upr1>upr & harvcroplandinirrigfarm`i'~=(-1000) & harvestedcropland`i'~=(-1000)
	drop upr1
	}
replace irrpct = upr if repl==1	
gen irrigated = (irrpct>0.2 )
tab irrigated if urban==0
gen dryrural = (irrigated==0 & urban==0)  //we have 5 counties that are classified differently

* do a similar thing for crop sales, because missing some in 1982
gen cropsales=cropsales1982
capture drop repl
gen repl = (cropsales1982==(-1000))
forvalues i = 1987(5)1997 {
	replace cropsales = cropsales`i' if repl==1 & cropsales`i'~=(-1000)
	replace repl=0 if repl==1 & cropsales`i'~=(-1000)
	}
replace cropsales=. if cropsales==(-1000)

*same for farmland. just using 1987 fixes it
gen farmland = farmland1982
replace farmland = farmland1987 if farmland1982==(-1000)
count if farmland<0

* MNS demean the climate variables and generate squared variables off the demeaned
foreach var of varlist jantemp- octprec {
	gen `var'_raw = `var'
	summ `var'
	replace `var' = `var' - `r(mean)'
	gen `var'sq = `var'*`var'
	}

drop upr repl
gen pctcropland= totalcropland1982/ countyarea1982  //MNS weights are % of land in crops
gen populationdensitysq = populationdensity*populationdensity
outsheet using mns_sample.csv, comma replace //write out a csv copy to use to eval climate changes
save mns_full, replace

* Slim down the dataset for running the bootstrap
keep farmval1982 jantemp* aprtemp* jultemp* octtemp* janprec* aprprec* julprec* octprec* ///
	incomepercapita populationdensity populationdensitysq latitude altitude salinity floodprone ///
	wetland soilerosion slopelength sand clay moisturecapacity permeability dryrural pctcropland ///
	cropsales farmland totalcropland1982
drop *_raw
save bootdataall, replace
keep if dryrural==1
save bootdatadry, replace

* Now run bootstrap, full sample (MNS). Reg in Col 4 of Table 3 of their paper (crop revenue weights)
set seed 42
cap postutil clear
postfile boot runum jantemp jantempsq aprtemp aprtempsq jultemp jultempsq octtemp octtempsq janprec janprecsq aprprec ///
	aprprecsq julprec julprecsq octprec octprecsq using boot_mns, replace
forvalues i = 1/1000 {
	use bootdataall, clear
	bsample	
	qui reg farmval1982 jantemp* aprtemp* jultemp* octtemp* janprec* aprprec* julprec* octprec* ///
		incomepercapita populationdensity populationdensitysq latitude altitude salinity floodprone ///
		wetland soilerosion slopelength sand clay moisturecapacity permeability	[aweight=cropsales]
	post boot (`i') (_b[jantemp]) (_b[jantempsq]) (_b[aprtemp]) (_b[aprtempsq]) (_b[jultemp]) (_b[jultempsq]) (_b[octtemp]) ///
		(_b[octtempsq]) (_b[janprec]) (_b[janprecsq]) (_b[aprprec]) (_b[aprprecsq]) (_b[julprec]) (_b[julprecsq]) ///
		(_b[octprec]) (_b[octprecsq])
	}
postclose boot
use boot_mns, clear
outsheet using boot_mns.csv, comma replace

* Run bootstrap on dryland sample (SHF). Reg in Col 2 of Table 3 of MNS, restricted to non-irrigated non-urban counties (cropland weights)
set seed 42
cap postutil clear
postfile boot runum jantemp jantempsq aprtemp aprtempsq jultemp jultempsq octtemp octtempsq janprec janprecsq aprprec ///
	aprprecsq julprec julprecsq octprec octprecsq using boot_shf, replace
forvalues i = 1/1000 {
	use bootdatadry, clear
	bsample	
	qui reg farmval1982 jantemp* aprtemp* jultemp* octtemp* janprec* aprprec* julprec* octprec* ///
		incomepercapita populationdensity populationdensitysq latitude altitude salinity floodprone ///
		wetland soilerosion slopelength sand clay moisturecapacity permeability	[aweight=totalcropland1982]
	post boot (`i') (_b[jantemp]) (_b[jantempsq]) (_b[aprtemp]) (_b[aprtempsq]) (_b[jultemp]) (_b[jultempsq]) (_b[octtemp]) ///
		(_b[octtempsq]) (_b[janprec]) (_b[janprecsq]) (_b[aprprec]) (_b[aprprecsq]) (_b[julprec]) (_b[julprecsq]) ///
		(_b[octprec]) (_b[octprecsq])
	}
postclose boot
use boot_shf,clear
outsheet using boot_shf.csv, comma replace




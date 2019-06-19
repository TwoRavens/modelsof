/* DataPrep.do */
/* This prepares the data for the Allcott and Wozny (2010) analysis. */
/* It first imports original data from our various sources: NHTS data, CPI, gas prices, auction price data,
JDPA PIN data, and Polk. 
Some initial data prep is done as part of these, and the data are organized
at the level of CarID, which is our "j". 
Data are then merged by CarID.
We then have a dataset called AutoPQX.dta.
*/

/* Notes:
Liters is an integer, Liters*10 (i.e. it ranges from 20 to 60 or so intead of 2.0 to 6.0
Drive is "2WD" and "4WD"
*/

/* DATA INPUT AND SAVE AS .DTA FILES */
/* CPI Deflators */
** Using CPI excluding energy
set more off
clear
insheet using Data/CPI/CUSR0000SA0LE.txt, tab clear
rename v2 Year
rename v3 period
rename v4 value
gen Month = real(substr(period,2,2))
sum value if Month==7&Year==2005
local July2005 = r(mean)
gen CPIDeflator = `July2005'/value
keep Year Month CPIDeflator
sort Year Month
save Data/CPI/MonthlyCPI.dta, replace


/* Gasoline Prices */
include Data/GetGasPrice.do

/* VMT from NHTS */
include Data/NHTS/VMTDataPrep.do

/* Polk vs. NHTS quantity adjustment */
* This adjusts Polk quantities to account for the fact that there are fewer old vehicles observed in NHTS. It does not make a large difference, plus it introduces additional complexity, and so we choose not to do it.
* include Data/NHTS/NHTSQAdjust.do

/* Make sure the Polk matching files are updated (this defines CarID). */
cd Data/Matchups
do MakeVinPrefix
cd ../..

/* This is an older version of the code that does not become part of the merged dataset,
    but the output is still used to match EPA data to Polk data. */
do Data/Quantities/PolkDataPrep

/* EPA MPG */
include Data/EPAMPG/EPADataPrep.do

/* Quantities */
cd Data/Quantities
do PolkQuantities
cd ../..

/* Prices (JD Power) */
cd Data/JDPower
do JDPPrices
do JDPPricesUsed
cd ../..

/* Attributes (Wards) */
cd Data/Attributes/Wards
do WardsDataPrep
do WardsAttributes
cd ../../..

** Import Green Attributes
insheet using Data/Attributes/GreenVehicles.csv, comma names clear case
sort Make Model FuelType Trim
save Data/Attributes/GreenVehicles.dta, replace

drop if Trim != ""
sort Make Model FuelType
save Data/Attributes/GreenVehiclesNoTrim.dta, replace


/* Merge EPA data first to NVPP, then to prefix. */
do Data/EPAMPG/EPAMerge

/* Predict survival probabilities */
* This must be done after EPAMerge because it uses Data/EPAMPG/EPAByID. These survival probabilities are used by GetGI.do 
cd Data/Quantities
include CalcSurvProb.do
cd ../..


/* Prices (Manheim) */
/* This needs to be done on a server with 12GB RAM.  If running DataPrep.do on a local machine, make sure
   Autos/Data/Matchups/Prefix810.dta and /IDToNames.dta are up-to-date on the server, run
   Autos/Data/Manheim/AuctionPrices.do, then copy Autos/Data/Manheim/AuctionPrices.dta back
   to the local machine.  Also requires Data/NHTS/OdometerEstimates.ster and
   Data/EPAMPG/EPAByID.dta */
/* */
cd Data/Manheim
do AuctionPrices
cd ../..
*/


/* MERGE */
/* At this point, the merge should be very easy: just match by CarID (and ModelYear, Year, and Month). */
clear all
set mem 2000m
capture log close
log using DataPrep_merge.log, replace

/* Start with monthly data (prices), then merge yearly, then ModelYear level.  End with Prefix names. */

/* Prices (Manheim) */
use Data/Manheim/AuctionPrices
keep CarID ModelYear Year Month AdjPrice PredPrice MeanPrice AnnPredPrice AnnMeanPrice ManheimObs InManheim MeanMiles

/* Prices (JD Power) */
sort CarID ModelYear Year Month
merge CarID ModelYear Year Month using Data/JDPower/JDPPrices, keep(JDPPrice JDPAdjPrice JDPSales InJDP) unique
tab _merge
drop _merge

/* Prices (JD Power Used) */
sort CarID ModelYear Year Month
merge CarID ModelYear Year Month using Data/JDPower/JDPUsedPrices, keep(JDPUsedPrice JDPUsedSales veh_odometer InUsedJDP) unique
/* could be overlap with above */
tab _merge
drop _merge

/* Quantities */
sort CarID ModelYear Year Month
merge CarID ModelYear Year Month using Data/Quantities/PolkQuantities.dta, unique
tab _merge
drop _merge

/* Attributes (Wards) */
sort CarID ModelYear Year Month
merge CarID ModelYear using Data/Attributes/Wards/WardsByPrefix, keep(HP Weight Wheelbase MPGCity MPGHwy MSRP Torque Traction ABS Stability Truck InWards) uniqusing
tab _merge
drop _merge

/* MPG */
sort CarID ModelYear
merge CarID ModelYear using Data/EPAMPG/EPAByID, keep(GPMA GPME VClass InEPA MergeSuccessIter Unrated PctWithinCarIDwithGPM) uniqusing
tab _merge
drop _merge
rename GPMA GPM

/* Prefix names */
sort CarID ModelYear
merge CarID ModelYear using Data/Matchups/IDToNames, uniqusing
tab _merge
drop _merge
/* Drop a few variables we don't need */
drop BodyType TransCode AltFuel SpecialVehType StartMY EndMY

** Green Vehicles
sort Make Model FuelType Trim
merge Make Model FuelType Trim using Data/Attributes/GreenVehicles, keep(Green_YahooRank)
tab _merge
drop _merge

sort Make Model FuelType
merge Make Model FuelType using Data/Attributes/GreenVehiclesNoTrim, keep(Green_YahooRank) update
tab _merge
drop _merge

gen Green_Hybrid = cond(strpos(Trim,"Hybrid")!=0,1,.)

gen Age = Year - ModelYear
*drop if Age<0

/* Fill in quantities of Age<0 vehicles */
gsort + CarID ModelYear - Year Month
by CarID ModelYear: replace Quantity = Quantity[_n-1] if Year<ModelYear

replace InPolk=0 if InPolk==.
replace InManheim=0 if InManheim==.
replace InJDP=0 if InJDP==.
replace InUsedJDP=0 if InUsedJDP==.
replace InWards=0 if InWards==.
replace InEPA=0 if InEPA==.
/* Diagnostic */
tab InPolk InManheim
tab InPolk InJDP
tab InPolk InUsedJDP
tab InManheim InUsedJDP
tab InManheim InUsedJDP if Age>=1
tab InPolk InWards
tab InPolk InEPA

/* Age adjustment factor to MPG from Greene et al. (2007) */
gen UnadjGPM = GPM
replace GPM = 1/(1/GPM - 0.07*(Age+(Month-1)/12))

/* Generate a single Price variable, and get weights from number of observations */
gen Price = MeanPrice if Age>=1
replace Price = JDPPrice if Age<=0
replace AdjPrice = JDPAdjPrice if Age<=0
replace PredPrice = JDPPrice if Age<=0
gen AnnPrice = AnnMeanPrice if Age>=1
replace AnnPrice = JDPAdjPrice if Age<=0 & Month==7
gen NumObs = ManheimObs if Age>=1
replace NumObs = JDPSales if Age<=0
drop ManheimObs JDPSales
sum NumObs if Age<=0
sum NumObs if Age>=1
/* Save all of 1999-2008.  */
drop if Year<=1998 | Year>=2009
sort CarID ModelYear Year Month
order CarID ModelYear Year Month Age Price AdjPrice MeanPrice Quantity GPM GPME VClass Make Model Trim BodyStyle FuelType DriveWheels Liters Cylinder PolkWheelbase ShippingWeight CubicInches HP Weight Wheelbase MSRP Torque Traction ABS Stability InPolk InManheim InJDP InWards InEPA


/* OTHER DATASET CONSTRUCTION */
/* Get different versions of G and append them to AutoPQX */
save AutoPQX.dta,replace

log close

/* Construction of G now takes place in a separate file.  This makes it easier to reconstruct AutoPQXG with
   a new set of "G" variables without reconstructing the rest of the dataset. */
do DataPrepG.do


/* Get exotic list */
include GetExoticList.do 

use AutoPQXG.dta, clear
sort Make Model
merge Make Model using ExoticList.dta, nokeep keep(Exotic)
drop _merge
save AutoPQXG.dta,replace
*

**************************************************************************************************************
*			Full Analysis File for Replication of RESTAT MS15560 											 *
*																											 *
*			Note: This file gives the code to replicate all tables in the paper. 							 *
*				  It also gives the code for Figures 6 & 7, which rely on estimation results.				 *
*				  There is a separate do file available for the bootstrap analysis for quantile				 *
*				  estimates discussed in the text and used in Figure 4.  									 *
**************************************************************************************************************

clear
clear matrix 
set more off
set matsize 5000


**************************************************************************************************************
*			Load the data and do initial data cleaning steps							 					 *
**************************************************************************************************************
// Note: see ReedMe file for data access agreement

// The raw dataset for this project was a pull of the company auction records for all make-model-modelyear
// car combinations that were produced in multiple countries as identified by the country code in the first
// digit of the VIN number

cd  //REDACTED// 
use multiJap_full


// In this step we limit the dataset to only the cars assembled in the US and Japan and create countried dums
keep if country == "U" | country == "J" 

gen jap = (country == "J")
gen usa = (country == "U")

// Calculate date variables
tostring auction_date, replace
gen auc_date = date(auction_date, "YMD")
format auc_date %td
gen year = year(auc_date)		
gen month = month(auc_date)
drop auction_date

// Calculate the age of the car
drop if model_year < 1951	//7 observations with model_year = 0 dropped 
gen age = year - model_year
drop if age < 0	// 7,793 observations deteled
gen voldjap = (jap == 1 & model_year <= 2001) // Dummy for older jap models

// Create a dummies to denote whether car was a dealer vs. fleet/lease car
gen dealer = 0 if category == "FLEET/LEASE"
replace dealer = 1 if category == "DEALER"

// Limiting this analysis to fleet/lease vs. dealer and dropping factory cars
drop if dealer==.

// Create variable with total reconditioning charges
gen ecr_tot = ecr_labor + ecr_parts
replace ecr_tot =. if ecr_tot > 50000	//This drops 2 outliers

// Create variable that denotes arbitration
gen arbitrated = 0 if flag_arb != ""
replace arbitrated = 1 if flag_arb == "Y"
gen notarb = 1-arbitrated

// Generate fixed effects with different groupings
drop if make ==""
drop if model ==""
drop if body ==""
drop if model_year ==.
drop if year ==.
drop if auction ==""
drop if dealer ==.
egen carid = group(make model body model_year)
egen carid1 = group(make model body model_year year)
egen carid2 = group(make model body model_year year auction)
egen carid3 = group(make model body model_year year auction dealer)


/* Generate Lights -- "WORST" LIGHT DOMINATES WHEN MORE THAN ONE LIGHT COLOR LISTED*/
/* Note that we have light data for about half of the sample -- starting in 2005 */
gen red = 0 if light_green != "."
gen yellow = 0 if light_green !="."
replace yellow = 1 if light_yellow == "Y" & light_red == "N"
replace red = 1 if light_red == "Y"
gen green = 0 if red == 1 | yellow == 1
replace green = 1 if red ==0 & yellow == 0


// Generate feature dummies
/* NOTE: before 2006, features are reported as missing with the "." sign.
From 2006 to 2008, options are reported with different symbols (letters, numbers),
or the cell is blank, which we intepret as that feature not being present
*/
foreach f in airbag ac airbag_side climate_control power_locks power_sunroof power_windows wipers antilock power_steering radio defrost tilt	{
gen f_`f'=0 if `f'~="."
replace f_`f'=1 if `f'~=""&`f'~="."
}

// Create auction dummies
quietly tab auction, gen(aucdum)

// Replace miles to be in terms of 1,000s and drop top and bottom 1% outliers
replace miles = miles/1000
drop if miles <= 1 
drop if miles > 250
gen miles2 = miles*miles
gen miles3 = miles*miles*miles

// Create interaction between age and miles polynomial  
gen agem = age*miles
gen agem2 = age*miles2
gen agem3 = age*miles3

// Fixing a small number of observations missing the state of the auction
replace state = "CA" if auction == //REDACTED FOR CONFIDENTIALITY//
replace state = "FL" if auction == //REDACTED FOR CONFIDENTIALITY//
replace state = "KY" if auction == //REDACTED FOR CONFIDENTIALITY//
replace state = "TX" if auction == //REDACTED FOR CONFIDENTIALITY//
replace state = "FL" if auction == //REDACTED FOR CONFIDENTIALITY//
replace state = "IL" if auction == //REDACTED FOR CONFIDENTIALITY//
replace auction = //REDACTED FOR CONFIDENTIALITY// if auction == //REDACTED FOR CONFIDENTIALITY// &/*
*/ (title_state == "FL" | title_state == "GA")
replace auction = //REDACTED FOR CONFIDENTIALITY// if auction == //REDACTED FOR CONFIDENTIALITY// &/*
*/ (title_state == "CA" | title_state == "NV" | title_state == "AZ")
replace state = "CA" if auction == //REDACTED FOR CONFIDENTIALITY//

// Create a dummy for western states (AZ, CA, CO, HI, NV, NM, OR, UT, and WA)
gen western = (state=="AZ"|state=="CA"|state=="CO"|state=="HI"|state=="NV"|state=="NM"|state=="OR"|state=="UT"|state=="WA") 
replace western =. if state==""

// Create the natural log of sale price
gen lprice = ln(price_sale) if price_sale > 0


// Variables denoting inspection was done
gen conditionreport = (condition != .)	// presence of a condition report
gen inspection = (inspect_date != 0)    // inspection date on file
gen ecr = (ecr_date != 0)				// estimated conditioning expense date on file

// Key make indicators 
gen honda = (make == "HONDA")
gen toyota = (make == "TOYOTA")

// Defining the light under which the car ran
/* Note: the definition here is the it was a "green light" if only a green light
and no other lights are recorded in the data */
gen light_overall = light_green + light_yellow + light_red
gen light_exists = (light_overall != "NNN" & light_overal != "...")
gen green_new = 0 if year >= 2006 & light_overall != "..." & light_overall != "NNN"
replace green_new = 1 if year >= 2006 & light_overall == "YNN"

// Generate a condition variable
/* Note: the condition variable is present for most fleet/lease cars*/
gen condgood_new = (condition >= 3)
replace condgood_new =. if condition ==.

// Variable to denote sold vs unsold cars
gen sold = (flag_sold == "Y")
gen unsold = (flag_sold == "N")

// Create a variable with the percent of each make/model/model_year/body, age and auction combo from each country
foreach j in jap usa {
	bys carid2: egen per_`j' = mean(`j')  
}

// Limit the analysis to make/model/model_year/body, age and auction combinations with at least 5% assembled in each country			
drop if per_jap < 0.05 | per_jap > 0.95

// Limit to cases where we have at least 20 observations within cartype3 (includes seller type)
gen temp2 = 1	
bys carid3: egen num3 = count(temp2)
drop temp2
drop if num3 < 20 | num3 ==.

// Limit to cars that are 0 - 15 years old
drop if age >= 15
drop if age < 0

// Drop observations with extremely low sale price or positive sale price without a sale
drop if price_sale <= 100 & sold == 1
drop if price_sale > 0 & sold == 0		//These are likely cars that were post-auction negotiations or arbitrations
replace price_sale =. if sold == 0

// There are a small numbers of car makes with very small representation in the sample, we drop (likely VIN errors)
drop if make == "CHEVROLET" | make == "GEO" | make == "ISUZU" | make == "INFINITI"

// Save the cleaned and reduced final regression dataset
save regdataset_final.dta, replace

*********************************************************
*********************************************************
*				Summary Stats
*				    TABLE 1 
*********************************************************
*********************************************************


// Means relevant to full sample
sum model_year miles age honda toyota dealer western sold jap 
sum model_year miles age honda toyota dealer western sold jap if jap == 0
sum model_year miles age honda toyota dealer western sold jap if jap == 1

// Means relevant to SOLD Cars all seller types
sum price_sale if sold == 1
sum price_sale if sold == 1 & jap == 0
sum price_sale if sold == 1 & jap == 1
sum arbitrated if sold == 1
sum arbitrated if sold == 1 & jap == 0
sum arbitrated if sold == 1	& jap == 1

// Means relevant to FLEET/LEASE CARS
sum ecr_tot if dealer == 0 & inspection == 1
sum ecr_tot if dealer == 0 & inspection == 1 & jap == 0
sum ecr_tot if dealer == 0 & inspection == 1 & jap == 1

sum condgood_new if dealer == 0 & inspection == 1
sum condgood_new if dealer == 0 & inspection == 1 & jap == 0
sum condgood_new if dealer == 0 & inspection == 1 & jap == 1

sum green_new if dealer == 0 & inspection == 1
sum green_new if dealer == 0 & inspection == 1 & jap == 0
sum green_new if dealer == 0 & inspection == 1 & jap == 1


*********************************************************
*********************************************************




*********************************************************
*********************************************************
*				Main Price Regressions
*				    TABLE 2 
*********************************************************
*********************************************************

// Table 2 Column 1
//ABSORB MAKE-MODEL-BODY-MODEL YEAR - AUCTION YEAR (NOT AUCTION LOCATION)
areg price_sale jap miles miles2 miles3 agem*, absorb(carid1) cluster(carid3)
sum price_sale if e(sample)

// Table 2 Column 2
// ADD AUCTION LOCATION TO THE FE
areg price_sale jap miles miles2 miles3 agem*, absorb(carid2) cluster(carid3)
sum price_sale if e(sample)


// Table 2 Column 3
// ADD AUCTION LOCATION TO THE FE, AND SELLER TYPE AS CONTROL 
areg price_sale jap miles miles2 miles3 agem* dealer, absorb(carid2) cluster(carid3)
sum price_sale if e(sample)

// Table 2 Column 4
// ADD AUCTION LOCATION AND SELLER TYPE TO THE FE
areg price_sale jap miles miles2 miles3 agem*, absorb(carid3) cluster(carid3)
sum price_sale if e(sample)

// Table 2 Column 5
// LOG WITH FULL SPECICATION
areg lprice jap miles miles2 miles3 agem*, absorb(carid3) cluster(carid3)
sum price_sale if e(sample)

// Table 2 Column 6
// ADD CONTROL FOR JAPANESE CARS ASSEMBLED PRIOR TO 2001 
areg price_sale jap voldjap miles miles2 miles3 agem*, absorb(carid3) cluster(carid3)
sum price_sale if e(sample)

// Table 2 Column 7
// LOG WITH FULL SPECICATION AND CONTROL FOR JAPANESE ASSEMBLED PRIOR TO 2001 
areg lprice jap voldjap miles miles2 miles3 agem*, absorb(carid3) cluster(carid3)
sum price_sale if e(sample)

******************************************************
******************************************************
******************************************************



********************************************************
*********************************************************
*				Quality Metrics Regressions
*				    TABLE 3 
*********************************************************
*********************************************************

// Table 3 Column 1 -- Sold
areg sold jap miles miles2 miles3 agem*, absorb(carid3) cluster(carid3)
sum sold if e(sample)

// Table 3 Column 2 -- Arbitrated 
areg notarb jap miles miles2 miles3 agem* if sold == 1, absorb(carid3) cluster(carid3)
sum notarb if e(sample)

// Table 3 Column 3 -- Estimated Conditioning Expenses 
areg ecr_tot jap  miles miles2 miles3 agem* if dealer == 0 & inspection ==1, absorb(carid3) cluster(carid3)
sum ecr_tot if e(sample)

// Table 3 Column 4 -- Condition Good 
areg condgood_new jap  miles miles2 miles3 agem* if dealer == 0, absorb(carid3) cluster(carid3)
sum condgood_new if e(sample)

// Table 3 Column 5 -- Green Light 
areg green_new jap  miles miles2 miles3 agem* if year >= 2006 & dealer == 0, absorb(carid3) cluster(carid3)
sum green_new if e(sample)

***************************************************************************
**************************************************************************


*********************************************************
*********************************************************
*				Robustness Checks
*				    TABLE 4 
*********************************************************
*********************************************************


// SEPARATE BY DEALER TYPES 

// Table 4 Column 1 -- FLEET/LEASE
areg price_sale jap miles miles2 miles3 agem* if dealer == 0, absorb(carid3) cluster(carid3)
sum price_sale if e(sample)

// Table 4 Column 2 -- FlEET/LEASE WITH LOG
areg lprice jap miles miles2 miles3 agem* if dealer == 0, absorb(carid3) cluster(carid3)
sum price_sale if e(sample)


// Table 4 Column 3 -- DEALER
areg price_sale jap miles miles2 miles3 agem* if dealer == 1, absorb(carid3) cluster(carid3)
sum price_sale if e(sample)

// Table 4 Column 4 -- DEALER WITH LOG 
areg lprice jap miles miles2 miles3 agem* if dealer == 1, absorb(carid3) cluster(carid3)
sum price_sale if e(sample)

/* EXCLUDE WARD OUTLIERS */
*  THESE OUTLIERS WERE IDENTIFIED FROM DATABASE OF WARDS PRODUCTION (DESCRIBED IN TEXT)

#delimit ;
gen ward_outlier =(((make_model=="HONDA_CIVIC"&model_year==1997)|(make_model=="HONDA_CIVIC"&model_year==1993))|
((make_model=="HONDA_ACCORD"&model_year==1990))|
((make_model=="HONDA_ACCORD 4C"&model_year==2001))|
((make_model=="HONDA_CIVIC"&model_year==1987))|
((make_model=="HONDA_CIVIC"&model_year==1998))|
((make_model=="HONDA_CIVIC"&model_year==2000))|
((make_model=="TOYOTA_CAMRY 4C"&model_year==2006)));


gen ward_man_overlap =((model_year==1988 & make == "HONDA" &model=="ACCORD")|
(model_year==1989 & make == "HONDA" &model=="ACCORD")|
(model_year==1990 & make == "HONDA" &model=="ACCORD")|
(model_year==1991 & make == "HONDA" &model=="ACCORD")|
(model_year==1992 & make == "HONDA" &model=="ACCORD")|
(model_year==1993 & make == "HONDA" &model=="ACCORD")|
(model_year==1994 & make == "HONDA" &model=="ACCORD")|
(model_year==1995 & make == "HONDA" &model=="ACCORD 4C")|
(model_year==1997 & make == "HONDA" &model=="ACCORD 4C")|
(model_year==1999 & make == "HONDA" &model=="ACCORD 4C")|
(model_year==2000 & make == "HONDA" &model=="ACCORD 4C")|
(model_year==2001 & make == "HONDA" &model=="ACCORD 4C")|
(model_year==2002 & make == "HONDA" &model=="ACCORD 4C")|
(model_year==2003 & make == "HONDA" &model=="ACCORD 4C")|
(model_year==2004 & make == "HONDA" &model=="ACCORD 4C")|
(model_year==2005 & make == "HONDA" &model=="ACCORD 4C")|
(model_year==2006 & make == "HONDA" &model=="ACCORD 4C")|
(model_year==1991 & make == "HONDA" &model=="CIVIC")|
(model_year==1992 & make == "HONDA" &model=="CIVIC")|
(model_year==1993 & make == "HONDA" &model=="CIVIC")|
(model_year==1994 & make == "HONDA" &model=="CIVIC")|
(model_year==1995 & make == "HONDA" &model=="CIVIC")|
(model_year==1997 & make == "HONDA" &model=="CIVIC")|
(model_year==1998 & make == "HONDA" &model=="CIVIC")|
(model_year==1999 & make == "HONDA" &model=="CIVIC")|
(model_year==2000 & make == "HONDA" &model=="CIVIC")|
(model_year==2001 & make == "HONDA" &model=="CIVIC")|
(model_year==2002 & make == "HONDA" &model=="CIVIC")|
(model_year==2003 & make == "HONDA" &model=="CIVIC")|
(model_year==1994 & make == "NISSAN" &model=="SENTRA")|
(model_year==1989 & make == "TOYOTA" &model=="CAMRY 4C")|
(model_year==1990 & make == "TOYOTA" &model=="CAMRY 4C")|
(model_year==1991 & make == "TOYOTA" &model=="CAMRY 4C")|
(model_year==1992 & make == "TOYOTA" &model=="CAMRY 4C")|
(model_year==1993 & make == "TOYOTA" &model=="CAMRY 4C")|
(model_year==1994 & make == "TOYOTA" &model=="CAMRY 4C")|
(model_year==1995 & make == "TOYOTA" &model=="CAMRY 4C")|
(model_year==1996 & make == "TOYOTA" &model=="CAMRY 4C")|
(model_year==1997 & make == "TOYOTA" &model=="CAMRY 4C")|
(model_year==1998 & make == "TOYOTA" &model=="CAMRY 4C")|
(model_year==1999 & make == "TOYOTA" &model=="CAMRY 4C")|
(model_year==2000 & make == "TOYOTA" &model=="CAMRY 4C")|
(model_year==2001 & make == "TOYOTA" &model=="CAMRY 4C")|
(model_year==2002 & make == "TOYOTA" &model=="CAMRY 4C")|
(model_year==2003 & make == "TOYOTA" &model=="CAMRY 4C")|
(model_year==2004 & make == "TOYOTA" &model=="CAMRY 4C")|
(model_year==2005 & make == "TOYOTA" &model=="CAMRY 4C")|
(model_year==2006 & make == "TOYOTA" &model=="CAMRY 4C")|
(model_year==1989 & make == "TOYOTA" &model=="COROLLA")|
(model_year==1991 & make == "TOYOTA" &model=="COROLLA")|
(model_year==1992 & make == "TOYOTA" &model=="COROLLA")|
(model_year==1993 & make == "TOYOTA" &model=="COROLLA")|
(model_year==1994 & make == "TOYOTA" &model=="COROLLA")|
(model_year==1995 & make == "TOYOTA" &model=="COROLLA")|
(model_year==2003 & make == "TOYOTA" &model=="COROLLA")|
(model_year==2004 & make == "TOYOTA" &model=="COROLLA")|
(model_year==2005 & make == "TOYOTA" &model=="COROLLA")|
(model_year==2006 & make == "TOYOTA" &model=="COROLLA"));

#delimit cr


// Table 4 Column 5 -- WARDS EXCLUDED 
areg price_sale jap miles miles2 miles3 agem* if ward_outlier==0 & ward_man_overlap==1, absorb(carid3) cluster(carid3)
sum price_sale if e(sample)

// Table 4 Column 6 -- WARDS EXCLUDED WITH LOG 
areg lprice jap miles miles2 miles3 agem* if ward_outlier==0 & ward_man_overlap==1, absorb(carid3) cluster(carid3)
sum lprice if e(sample)

// Table 4 Column 7 -- QUALITY-MEASURES CONTROLS 
areg price_sale jap miles miles2 miles3 agem* ecr_tot condgood_new if dealer == 0 & inspection == 1, absorb(carid3) cluster(carid3)
sum price_sale if e(sample)

// Table 4 Column 8 -- QUALITY-MEASURES CONTROLS WITH LOG
areg lprice jap miles miles2 miles3 agem* ecr_tot condgood_new if dealer == 0 & inspection == 1, absorb(carid3) cluster(carid3)
sum lprice if e(sample)

// Table 4 Column 9 -- CONTROLLING FOR FEATURES
areg price_sale jap miles miles2 miles3 agem* f_*, absorb(carid3) cluster(carid3)
sum price_sale if e(sample)

// Table 4 Column 10 -- CONTROLLING FOR FEATURES WITH LOG
areg lprice jap miles miles2 miles3 agem* f_*, absorb(carid3) cluster(carid3)
sum lprice if e(sample)



*********************************************************
*********************************************************
*				Toyota and Honda
*				    TABLE 5 
*********************************************************
*********************************************************

//   PANEL A -- TOYOTA 
// Column 1: Toyota Overall -- price
areg price_sale jap miles miles2 miles3 agem* if make == "TOYOTA", absorb(carid3) cluster(carid3)
sum price_sale if e(sample)

// Column 2: Toyota Overall -- log
areg lprice jap miles miles2 miles3 agem* if make == "TOYOTA", absorb(carid3) cluster(carid3)
sum price_sale if e(sample)

// Column 3: Toyota Dealer -- price 
areg price_sale jap miles miles2 miles3 agem* if make == "TOYOTA" & dealer == 1, absorb(carid3) cluster(carid3)
sum price_sale if e(sample)

// Column 4: Toyota Dealer -- log
areg lprice jap miles miles2 miles3 agem* if make == "TOYOTA" & dealer == 1, absorb(carid3) cluster(carid3)
sum price_sale if e(sample)

// Column 5: Toyota Fleet/Lease -- price 
areg price_sale jap miles miles2 miles3 agem* if make == "TOYOTA" & dealer == 0, absorb(carid3) cluster(carid3)
sum price_sale if e(sample)

// Column 6: Toyota Fleet/Lease -- log
areg lprice jap miles miles2 miles3 agem* if make == "TOYOTA" & dealer == 0, absorb(carid3) cluster(carid3)
sum price_sale if e(sample)


//   PANEL B -- HONDA
// Column 1: HONDA Overall -- price
areg price_sale jap miles miles2 miles3 agem* if make == "HONDA", absorb(carid3) cluster(carid3)
sum price_sale if e(sample)

// Column 2: HONDA Overall -- log
areg lprice jap miles miles2 miles3 agem* if make == "HONDA", absorb(carid3) cluster(carid3)
sum price_sale if e(sample)

// Column 3: HONDA Dealer -- price 
areg price_sale jap miles miles2 miles3 agem* if make == "HONDA" & dealer == 1, absorb(carid3) cluster(carid3)
sum price_sale if e(sample)

// Column 4: HONDA Dealer -- log
areg lprice jap miles miles2 miles3 agem* if make == "HONDA" & dealer == 1, absorb(carid3) cluster(carid3)
sum price_sale if e(sample)

// Column 5: HONDA Fleet/Lease -- price 
areg price_sale jap miles miles2 miles3 agem* if make == "HONDA" & dealer == 0, absorb(carid3) cluster(carid3)
sum price_sale if e(sample)

// Column 6: HONDA Fleet/Lease -- log
areg lprice jap miles miles2 miles3 agem* if make == "HONDA" & dealer == 0, absorb(carid3) cluster(carid3)
sum price_sale if e(sample)

*******************************************************************************************************
*******************************************************************************************************
*******************************************************************************************************


*********************************************************
*********************************************************
*				Toyota and Honda with Model-year Split
*				    TABLE 6 
*********************************************************
*********************************************************

//   PANEL A -- TOYOTA 
// Column 1: Toyota Overall -- price
areg price_sale jap voldjap miles miles2 miles3 agem* if make == "TOYOTA", absorb(carid3) cluster(carid3)
sum price_sale if e(sample)

// Column 2: Toyota Overall -- log
areg lprice jap voldjap miles miles2 miles3 agem* if make == "TOYOTA", absorb(carid3) cluster(carid3)
sum price_sale if e(sample)

// Column 3:  Toyota Overall -- log With Feature Controls
areg lprice jap voldjap miles miles2 miles3 agem* f_* if make == "TOYOTA", absorb(carid3) cluster(carid3)
sum price_sale if e(sample)

// Column 4: Toyota Dealer -- price 
areg price_sale jap voldjap miles miles2 miles3 agem* if make == "TOYOTA" & dealer == 1, absorb(carid3) cluster(carid3)
sum price_sale if e(sample)

// Column 5: Toyota Dealer -- log
areg lprice jap voldjap miles miles2 miles3 agem* if make == "TOYOTA" & dealer == 1, absorb(carid3) cluster(carid3)
sum price_sale if e(sample)

// Column 6:  Toyota Dealer -- log With Feature Controls
areg lprice jap voldjap miles miles2 miles3 agem* f_* if make == "TOYOTA" & dealer == 1, absorb(carid3) cluster(carid3)
sum price_sale if e(sample)

// Column 7: Toyota Fleet/Lease -- price 
areg price_sale jap voldjap miles miles2 miles3 agem* if make == "TOYOTA" & dealer == 0, absorb(carid3) cluster(carid3)
sum price_sale if e(sample)

// Column 8: Toyota Fleet/Lease -- log
areg lprice jap voldjap miles miles2 miles3 agem* if make == "TOYOTA" & dealer == 0, absorb(carid3) cluster(carid3)
sum price_sale if e(sample)

// Column 9:  Toyota Fleet/Lease -- log With Feature Controls
areg lprice jap voldjap miles miles2 miles3 agem* f_* if make == "TOYOTA" & dealer == 0, absorb(carid3) cluster(carid3)
sum price_sale if e(sample)

//   PANEL B -- HONDA
// Column 1: HONDA Overall -- price
areg price_sale jap voldjap miles miles2 miles3 agem* if make == "HONDA", absorb(carid3) cluster(carid3)
sum price_sale if e(sample)

// Column 2: HONDA Overall -- log
areg lprice jap voldjap miles miles2 miles3 agem* if make == "HONDA", absorb(carid3) cluster(carid3)
sum price_sale if e(sample)

// Column 3: HONDA Overall -- log With Feature Controls
areg lprice jap voldjap miles miles2 miles3 agem* f_* if make == "HONDA", absorb(carid3) cluster(carid3)
sum price_sale if e(sample)

// Column 4: HONDA Dealer -- price 
areg price_sale jap voldjap miles miles2 miles3 agem* if make == "HONDA" & dealer == 1, absorb(carid3) cluster(carid3)
sum price_sale if e(sample)

// Column 5: HONDA Dealer -- log
areg lprice jap voldjap miles miles2 miles3 agem* if make == "HONDA" & dealer == 1, absorb(carid3) cluster(carid3)
sum price_sale if e(sample)

// Column 6: HONDA Dealer -- log With Feature Controls
areg lprice jap voldjap miles miles2 miles3 agem* f_* if make == "HONDA" & dealer == 1, absorb(carid3) cluster(carid3)
sum price_sale if e(sample)

// Column 7: HONDA Fleet/Lease -- price 
areg price_sale jap voldjap miles miles2 miles3 agem* if make == "HONDA" & dealer == 0, absorb(carid3) cluster(carid3)
sum price_sale if e(sample)

// Column 8: HONDA Fleet/Lease -- log
areg lprice jap voldjap miles miles2 miles3 agem* if make == "HONDA" & dealer == 0, absorb(carid3) cluster(carid3)
sum price_sale if e(sample)

// Column 9: HONDA Fleet/Lease -- log With Feature Controls
areg lprice jap voldjap miles miles2 miles3 agem* f_* if make == "HONDA" & dealer == 0, absorb(carid3) cluster(carid3)
sum price_sale if e(sample)

*******************************************************************************************************
*******************************************************************************************************
*******************************************************************************************************


*********************************************************
*********************************************************
*				Toyota and Honda over time Quality Measures
*				    TABLE 7 
*********************************************************
*********************************************************

// PANEL A -- TOYOTA 
// Column 1 -- Sold 
areg sold jap voldjap miles miles2 miles3 agem* if make == "TOYOTA", absorb(carid3) cluster(carid3)
sum sold if e(sample)

// Column 2 -- Arbitrated 
areg notarb jap voldjap miles miles2 miles3 agem* if sold == 1 & make == "TOYOTA", absorb(carid3) cluster(carid3)
sum notarb if e(sample)

// Column 3 -- Estimated Conditioning Expenses 
areg ecr_tot jap voldjap miles miles2 miles3 agem* if dealer == 0 & inspection ==1 & make == "TOYOTA", absorb(carid3) cluster(carid3)
sum ecr_tot if e(sample)

// Column 4 -- Condition Good 
areg condgood_new jap voldjap miles miles2 miles3 agem* if dealer == 0 & make == "TOYOTA", absorb(carid3) cluster(carid3)
sum condgood_new if e(sample)

// Column 5 -- Green Light 
areg green_new jap voldjap miles miles2 miles3 agem* if year >= 2006 & dealer == 0 & make == "TOYOTA", absorb(carid3) cluster(carid3)
sum green_new if e(sample)

// PANEL B -- HONDA
// Column 1 -- Sold 
areg sold jap voldjap miles miles2 miles3 agem* if make == "HONDA", absorb(carid3) cluster(carid3)
sum sold if e(sample)

// Column 2 -- Arbitrated 
areg notarb jap voldjap miles miles2 miles3 agem* if sold == 1 & make == "HONDA", absorb(carid3) cluster(carid3)
sum notarb if e(sample)

// Column 3 -- Estimated Conditioning Expenses 
areg ecr_tot jap voldjap miles miles2 miles3 agem* if dealer == 0 & inspection ==1 & make == "HONDA", absorb(carid3) cluster(carid3)
sum ecr_tot if e(sample)

// Column 4 -- Condition Good 
areg condgood_new jap voldjap miles miles2 miles3 agem* if dealer == 0 & make == "HONDA", absorb(carid3) cluster(carid3)
sum condgood_new if e(sample)

// Column 5 -- Green Light 
areg green_new jap voldjap miles miles2 miles3 agem* if year >= 2006 & dealer == 0 & make == "HONDA", absorb(carid3) cluster(carid3)
sum green_new if e(sample)

*******************************************************************************************************
*******************************************************************************************************
*******************************************************************************************************

*********************************************************
*********************************************************
*			Estimation Results for Figures 6 & 7
*			Note: code for figures relying on regression	 
*********************************************************

// Create interaction between japanese assembly and model year
forvalues j = 1989(1)2007 {
	gen japmody`j' = (jap == 1 & model_year == `j')
}

// Create an interaction between japanese assembly and age
forvalues t = 0(1)14 {
	gen japage`t' = (jap == 1 & age == `t')
}
// FIGURE 6 PRICE DIFFS BY COUNTRY OF ASSEMBLY AND MODEL YEAR
/* Note: Figure 6 plots the estimated coefficient on the "japmody" dummy variables
         along with theri 95% confidence interval from the regressions below.  */
// Panel A. Full Sample
areg lprice japmody* miles miles2 miles3 agem* if model_year >= 1990 & model_year <= 2007, absorb(carid3) cluster(carid3)
// Panel B. Toyota
areg lprice japmody* miles miles2 miles3 agem* if model_year >= 1990 & model_year <= 2007 & make == "TOYOTA" & model == "CAMRY 4C", absorb(carid3) cluster(carid3)
// Panel C. Honda
areg lprice japmody* miles miles2 miles3 agem* if model_year >= 1990 & model_year <= 2007 & make == "HONDA" & (model == "ACCORD 4C"|model == "ACCORD"), absorb(carid3) cluster(carid3)



// FIGURE 7 ESTIMATED JAPANESE VS US RESALE DIFFERENCES BY MODEL YEAR AND AGE
// Panel A. Toyota Camry 4C
/* Note: the elements of the graph are the regression coefficients of the "japage" variables in the 
		 regressions in this loop. */
forvalues t = 1993(1)2004 {
	areg lprice japage1-japage14 miles miles2 miles3 if make == "TOYOTA" & model == "CAMRY 4C" & model_year == `t' & age > 0, absorb(carid2) cluster(carid2)
}

// Panel B. Honda Accord 4C
/* Note: the elements of the graph are the regression coefficients of the "japage" variables in the 
		 regressions in these two loops. */
forvalues t = 1989(1)1995 {
	areg lprice japage1-japage14 miles miles2 miles3 if make == "HONDA" & (model == "ACCORD 4C"|model == "ACCORD") & model_year == `t' & age > 0, absorb(carid2) cluster(carid2)
}

foreach t in 1997 1999 2000 2001 2002 2003 2004 {
	areg lprice japage1-japage14 miles miles2 miles3 if make == "HONDA" & (model == "ACCORD 4C"|model == "ACCORD") & model_year == `t' & age > 0, absorb(carid2) cluster(carid2)
}

*******************************************************************************************************
*******************************************************************************************************
*******************************************************************************************************

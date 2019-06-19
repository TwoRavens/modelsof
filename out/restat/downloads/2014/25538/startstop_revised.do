
clear 
set more off
set memory 4g
set matsize 3000

global RES ""

cap log close
log using $RES\startstop_revised_limited.txt, t replace

*version 8

/*------------------------------------------------------------------------*
| This program takes the start and stop dates of production and matches   |
| to the incentive data.  Since the incentives data begin with the first  |
| incentive, this will essentially add observations to each model-year    |
| that correspond to the weeks between first availability and the first   | 
| incentive.  We will assume incentives are available on the date of last |
| availability, so the stop dates of production will be less useful.      |
*-------------------------------------------------------------------------*
| THE PROGRAM CREATES THE MAIN CASHBACK REGRESSION DATASET.               |
*------------------------------------------------------------------------*/

	use $RES\incentives_terms_revised_limited, clear
		keep acode model modelyear manufacturer
		duplicates drop
		sort modelyear model
		save $RES\tempA, replace
		
insheet using $RES\startstop.csv, clear
	drop v*
	replace start="" if start=="0"
	replace stop ="" if stop =="0"

	sort model modelyear 
	gen start2 = date(start,"MD20Y")
	gen stop2  = date(stop,"MD20Y")
	drop start stop
	rename start2 start
	rename stop2 stop

	/*-------------------------------------------------*
	| Step 1: impute and/or guess missing start dates. |
	*-------------------------------------------------*/

	gen t1 = start

	sort model modelyear 
		replace t1 = stop[_n-1]    if t1==. & model==model[_n-1] & modelyear == modelyear[_n-1]+1	
		replace t1 = t1[_n-1]+365  if t1==. & model==model[_n-1] & modelyear == modelyear[_n-1]+1	

	gsort model -modelyear
		replace t1 = t1[_n-1]-365  if t1==. & model==model[_n-1] & modelyear == modelyear[_n-1]-1	

	sort model modelyear  	
	
	gen imputed = t1 != start	
	replace start = t1
	gen guessed = start==.	
	replace start = mdy(8,1,modelyear-1) if start==.		
		
	keep modelyear model start stop imputed guessed
	


drop stop
egen modelyearid = group(model modelyear)
sort modelyear model
save $RES\tester, replace

merge 1:m modelyear model using $RES\tempA
	drop if _merge==1
	drop _merge
	save $RES\tester, replace
des



 	/*--------------------------------------------------------------------*
	| Now creating every combination of week and modelyears.  I then drop 
	| combinations that exist before the start date of the model year.    
	| There are still "too many" observations, but only on the back end 
	| and I will fix that momentarily.                                    
	*--------------------------------------------------------------------*
	| I also bring in gasoline prices via the dataset x12_convert
	*---------------------------------------------------------------------*/

	gen sorter = 1
		sort sorter 
		compress
		save $RES\temp1, replace
		des

	**** Getting the Regional Gasoline Prices (and a full set of OBS) ****

	use $RES\x12_convert, clear
		keep if year>2000 & year<2007
		keep if reg>0 
		rename gasprice	gasprice_r
		rename dsgp     	dsgp_r
		drop seas*
		sort date
		save $RES\tempX, replace

	**** Getting the National Gasoline Price + National Input Costs ****

	use $RES\x12_convert, clear
		keep if year>1999 & year<2007
		keep if reg==0
		rename gasprice	gasprice_n
		rename dsgp		dsgp_n
		rename dsfp		dsfp_n
		rename dsep		dsep_n
		drop reg seas* 
		sort date year
		save $RES\tempXb, replace

	insheet using $RES\x12_out_costfactors.csv, clear
		keep date parts_d11 steel_d11 hardware_d11
		replace date=date+1
		gen year = year(date)
		keep if year<=2006
		keep if year>=2002
		*drop year
		rename parts_d11 parts
		rename steel_d11 steel
		rename hardware_d11 hardware	
		sort date year

		merge 1:1 date year using $RES\tempXb
			tab _merge
			keep if _merge==3
			drop _merge
			sort date
		
		merge 1:m date using $RES\tempX
			tab _merge
			*keep if _merge==3
			drop _merge

		sort reg date

		gen sorter = 1
		sort sorter
		des


	**** Creating Every Combination of Week and Model-Modelyear ****

	joinby sorter using $RES\temp1
		des
		*NOTE: #OBS SHOULD EQUAL PRODUCT OF #OBS IN TWO INPUT DATASETS

tab year modelyear

		drop if start > date /*there seem to be a lot of vehicles that start being sold in the same year as their model year*/

tab year modelyear

		drop sorter

	sort reg date model modelyear
	save $RES\temp1, replace

	/*---------------------------------------------------------------------*
	| The incentives data have one observation per region-ACODE for
	| every week in the data, over 2003-2006.  Some of these are "bad"
	| observations.  I drop _merge==1 obs; these occur before the date
	| of first manufacture.  To eliminate incentives after an acode is no
	| longer available I drop observations two years after the date of 
	| first manufacture.  I also drop observations after the date of the last
	| incentive.  Of course, I drop observations with _merge==2, I'm not 
	| sure why there are any of these.   
	*---------------------------------------------------------------------*/	

	**** Regional Incentives are here ****

	use $RES\incentives_terms_revised_limited if regional, clear

		rename meaninc meaninc_r
		rename maxinc maxinc_r
		rename medinc medinc_r
		
		rename meanincp meanpinc_r
		rename meanincc meancinc_r
		rename meanincd meandinc_r
		
		rename meanregonly meaninc_r2		
		rename maxregonly maxinc_r2
		rename medregonly medinc_r2
		
		#delimit ;
			keep acode model modelyear region date 
			meaninc_r maxinc_r medinc_r
			meanpinc_r meancinc_r meandinc_r
			meaninc_r2 maxinc_r2 medinc_r2
			mean60_r max60_r med60_r mean36_r max36_r med36_r
			mean60_r2 max60_r2 med60_r2 mean36_r2 max36_r2 med36_r2 oneending onestarting;
		#delimit cr

		
		sort acode date region  		
		save $RES\temp2, replace

	**** Merging with National Incentives ****

	use $RES\incentives_terms_revised_limited if national, clear
		rename meaninc meaninc_n
		rename maxinc maxinc_n
		rename medinc medinc_n
		
		rename meanincp meanpinc_n
		rename meanincc meancinc_n
		rename meanincd meandinc_n
		
		rename meanr60 mean60_n
		rename meanr36 mean36_n
		rename maxr60 max60_n
		rename maxr36 max36_n
		rename medr60 med60_n
		rename medr36 med36_n

		#delimit ;
			keep acode model modelyear date 
			meaninc_n maxinc_n medinc_n 
			meanpinc_n meancinc_n meandinc_n 
			mean60_n mean36_n max60_n max36_n med60_n med36_n ;
		#delimit cr

		sort acode date 
		merge 1:m acode date using $RES\temp2
			drop _merge	
		sort acode date region
		save $RES\temp2, replace

*sum m*

	**** Merging with the Manufacturing Start Dates and Gasoline Prices ****		
	
	gen year = year(date)
	tab year modelyear
	sort region date model modelyear
	
	gen reg = 0
	replace reg=1 if region=="ECA"
	replace reg=2 if region=="MWA"
	replace reg=3 if region=="GCA"
	replace reg=4 if region=="RMA"
	replace reg=5 if region=="WCA"
	sort reg date acode 

	merge m:1 reg date acode using $RES\temp1
		/*------------------------------------------*
		| 	If the ob is in using only then it's	|
		|		just filling in missing dates.		|
		|	I'm thinking that most of the obs that 	|
		|		are only in the master data are		|
		|		the large vehicles with no mpg data	|
		*------------------------------------------*/

		*tab _merge
		drop if _merge==1
		drop _merge

		drop if date > start + 2*365.25

		replace meaninc_r   =0 if meaninc_r==.
		replace maxinc_r   =0 if maxinc_r==.
		replace medinc_r   =0 if medinc_r==.
		
		replace meanpinc_r =0 if meanpinc_r==.
		replace meancinc_r =0 if meancinc_r==.
		replace meandinc_r =0 if meandinc_r==.
		
		replace meaninc_r2   =0 if meaninc_r2==.
		replace maxinc_r2   =0 if maxinc_r2==.
		replace medinc_r2   =0 if medinc_r2==.

		replace meaninc_n   =0 if meaninc_n==.
		replace maxinc_n   =0 if maxinc_n==.
		replace medinc_n   =0 if medinc_n==.
		
		replace meanpinc_n =0 if meanpinc_n==.
		replace meancinc_n =0 if meancinc_n==.
		replace meandinc_n =0 if meandinc_n==.

		by acode date, sort: egen temp2 = mean(meaninc_r)
		by acode, sort: egen maxdate = max(date) if temp2>0
		by acode, sort: egen maxmaxdate = max(maxdate)
		keep if date <= maxmaxdate
		drop temp2 maxdate maxmaxdate /*imputed guessed*/ 

	tab year modelyear

sum m*


**** Bringing vehicle attributes back in ****

		sort modelyear model
		save $RES\temp2, replace
		use $RES\incentives_terms_revised_limited if national, clear
		
		#delimit ;
			keep modelyear model acode mpg msrp vehicletype vehiclesegment manufacturer 
				division variation trim bodytype hp curbweightlbs numpassenger
				passvolumecuft wheelbasein clearancein turningradiusfeet
				tractioncontroldummy stabilitycontroldummy sideairbagdummy rearairbagdummy
				drivercrashtest passcrashtest cylindercountstandard2 cylindertype 
				cylindernumber variation1 doors;
		#delimit cr
	
		rename vehiclesegment segment
		duplicates drop
		sort acode
		merge 1:m acode using $RES\temp2
			drop _merge

*sum m*


	/*--------------------------------------------------------------------*
	| Prices change over the lifecycle of the product.  We control direct
	| for this using polynomials in the age of the modelyear model.  
	| create the basic variables here.  Trend = 1,2,3... over the cycle.  
	| Ptrend = 1/T, 2/T, ... over the cycle, where T is the # of obs per  
	| model modelyear.  This basically puts the trends in as a percentage 
	| of the lifetime and might be more accurate.  
	*--------------------------------------------------------------------*
	| I do this differently for modelyear=2003... we pick up their obs
	| midway through the lifecycle.
	*--------------------------------------------------------------------*/

	gen trend1 =  int((date-start)/7)
	by acode, sort: egen nweeks = count(year)
	gen ptrend1 = trend1/nweeks 
	drop nweeks

	gen  trend2 =  trend1^2
	gen  trend3 =  trend1^3
	gen  trend4 =  trend1^4

	gen ptrend2 = ptrend1^2
	gen ptrend3 = ptrend1^3
	gen ptrend4 = ptrend1^4

	/*-----------------------------------------------------------*
	| Putting the cashback incentives into real Jan 2006 dollars |
	*-----------------------------------------------------------*/

	sort year month
	merge m:1 year month using $RES\cpi_noenergy
		*tab _merge
		keep if _merge==3
		drop _merge
	sort year month
	merge m:1 year month using $RES\cpi
		keep if _merge==3
		drop _merge

	gen meaninc_r_noenergy   = meaninc_r    / cpi_adjuster_noenergy
	gen meaninc_r_real = meaninc_r / cpi_adjuster
	gen msrp_noenergy            = msrp    / cpi_adjuster_noenergy
	gen msrp_real			= msrp / cpi_adjuster


	/*--------------------------------------------------*
	| Generating a time trend that counts through the sample |
	*---------------------------------------------*/

	sort date
	save $RES\temp1, replace
	keep date
	duplicates drop
	gen t1 = _n / _N
	gen t2 = t1^2
	gen t3 = t1^3
	gen t4 = t1^4
	sort date
	merge 1:m date using $RES\temp1
		*tab _merge
		drop _merge



save $RES\startstop2_revised_limited, replace


*/
log close

erase $RES\tempA.dta
erase $RES\temp1.dta
erase $RES\temp2.dta
erase $RES\tempX.dta
erase $RES\tempXb.dta
erase $RES\tester.dta

*run regs_prep_restatfinal next


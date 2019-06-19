/* NestedLogit.do */

/* Runs nested logit model. */

# delimit cr

set more off

clear all
set mem 34g
set matsize 11000
set maxvar 15000

cap ssc install ivreg2
cap ssc install ranktest

local outfilename = "MakeTablesNL"
local primarycode = "1000000006025024100110"

capture file close outfile
capture log close
log using "Estimation/`outfilename'.log", replace

* Set to 0 to estimate a different sigma for each nest, set to 1 to constrain sigma to be the same
local onesigma=1
local useblp=0
local BLPInst1 = "BLP_InFirm BLP_InCont BLP_OutCont"

/* Get gas price trends for tests of sensitivity to large vs small and upward vs downward changes. */
use Data/GasPrices/SpotGasPrice
sort Year Month
gen GasPriceDown = (GasPrice<GasPrice[_n-1])
gen GasPriceBigChange = (abs(GasPrice-GasPrice[_n-1])>=0.1)
keep Year Month GasPriceDown GasPriceBigChange
sort Year Month
tempfile GasPriceChange
save `GasPriceChange'
clear all

/*  Parameter matrix: each row is a separate regression.  Each column
    corresponds to a parameter:
    First 8 parameters affect vehicles included in the dataset:
    min age, max age, min year, max year, min MY, max MY, min class, max class,
    a set of codes affecting the computation of G (See GetGI.do for details), and
    a code for special specification (described in comments below)
*/

local params1 =" 1,15,1999,2008.167,1950,2008,1, 9,1000000006025024100110,6" /* grouping, model X age in month FE */
local params2 =" 1,15,1999,2008.167,1950,2008,1, 9,1000000006025024100110,1" /* reduced form, used */
local params3 =" 1,15,2004,2008.167,1950,2008,1, 9,1000000006025024100110,1" /* reduced form, used - late period */
local params4 ="-1,15,2004,2008.167,1950,2008,1, 9,1000000006025024100110,1" /* reduced form, incl. new */
local params5 =" 1,15,2004,2008.167,1950,2008,1, 9,1000000006025024100110,0" /* NL, used */
local params6 ="-1,15,2004,2008.167,1950,2008,1, 9,1000000006025024100110,0" /* NL, incl new */
local params7 =" 1,15,2004,2008.167,1950,2008,1, 9,1000000006025024100110,2" /* logit */
local params8 =" 1,15,2004,2008.167,1950,2008,1, 9,1000000006025024100110,3" /* NL OLS */
/* Logit alternate structure */
local params9 =" 1,15,2004,2008.167,1950,2008,1, 9,1000000006025024100110,30" /* 2 level NL - Class, Age */
local params10=" 1,15,2004,2008.167,1950,2008,1, 9,1000000006025024100110,35" /* 3 level NL - Class, Age, Luxury */
/* more alternates */
local params11=" 1,15,2004,2008.167,1950,2008,1, 9,1000000006025024100110,21" /* nest=Firm */
local params12=" 1,15,2004,2008.167,1950,2008,1, 9,1000000006025024100110,22" /* nest=HP */
local params13=" 1,15,2004,2008.167,1950,2008,1, 9,1000000006025024100110,23" /* nest=MPG */
local params14=" 1,15,2004,2008.167,1950,2008,1, 9,1000000006025024100110,24" /* nest=Weight */
local params15=" 1,15,2004,2008.167,1950,2008,1, 9,1000000006025024100110,36" /* nest1=VClass, nest2=Firm */
local params16=" 1,15,2004,2008.167,1950,2008,1, 9,1000000006025024100110,37" /* nest1=VClass, nest2=HP */
local params17=" 1,15,2004,2008.167,1950,2008,1, 9,1000000006025024100110,38" /* nest1=VClass, nest2=MPG */
local params18=" 1,15,2004,2008.167,1950,2008,1, 9,1000000006025024100110,39" /* nest1=VClass, nest2=Weight */
local params19=" 1,15,2004,2008.167,1950,2008,1, 9,1000000006025024100110,31" /* nest1=Age   , nest2=VClass */
local params20=" 1,15,2004,2008.167,1950,2008,1, 9,1000000006025024100110,32" /* nest1=VClass, nest2=LuxSports */
local params21=" 1,15,2004,2008.167,1950,2008,1, 9,1000000006025024100110,33" /* nest1=VClass, nest2=LuxP85 */
local params22=" 1,15,2004,2008.167,1950,2008,1, 9,1000000006025024100110,4" /* NL, ctrl for nest dummies */
local params23=" 1,15,2004,2008.167,1950,2008,1, 9,1000000006025024100110,5" /* RF, ctrl for nest dummies */

local maxrow=100
local row=0
while `row'<=`maxrow' {
    local `row++'
    local lineok=0
    while `lineok'==0 {
        if "`params`row''"=="" local row=`row'+1
        else local lineok=1
        if `row'>`maxrow' local lineok=1
        if `row'>`maxrow' continue
    }
    if `row'>`maxrow' continue
    di "Row `row': `params`row''"
    forvalues i=1/9 {
        local comma=strpos("`params`row''",",")
        local param`i'=substr("`params`row''",1,`comma'-1)
        local params`row'=substr("`params`row''",`comma'+1,99999)
    }
    local param10 = "`params`row''"
    local minage=real("`param1'")
    local maxage=real("`param2'")
    local mintime=real("`param3'")
    local maxtime=real("`param4'")
    local minmy=real("`param5'")
    local maxmy=real("`param6'")
    local minclass=real("`param7'")
    local maxclass=real("`param8'")
    local gcode="`param9'"
    local specialcode=real("`param10'")

		local jaavgpm = real(substr("`gcode'",2,1))
		local gaspricelag = real(substr("`gcode'",3,2))
		local testmeanreversionconstant = real(substr("`gcode'",5,1))
		local meanreversionconstant = (-1) *real(substr("`gcode'",6,2))/100 /* meanreversionconstant is between 0 and-1*/
		local r = real(substr("`gcode'",9,2)) / 100 /* r is defined to be between 0 and 1 */
    local lifetime = real(substr("`gcode'",12,2))
    local timehorizon = real(substr("`gcode'",15,2))
    local usesurv = real(substr("`gcode'",17,1))
    local m = real(substr("`gcode'",18,2)) * 1000
    local usefutures = real(substr("`gcode'",20,1))
    local usepredictedfutures = real(substr("`gcode'",21,1))
    local adjustintensive = real(substr("`gcode'",22,1))
		local primary = cond("`gcode'" == "`primarycode'" ,1,0) /*Indicator for primary specification */

    if `maxage'==0 & `useblp'==1 local BLPInst = "`BLPInst1'"
    else local BLPInst = ""

    * load data set and choose a subset
    use AutoPQXG, replace

    /* Drop exotics.  Note that we should do this _before_ calculating GroupShare since we don't consider
    these to be good substitutes for other vehicles in its VClass. */
		sort Make Model
		merge m:1 Make Model using ExoticList.dta, assert(match)
		if `specialcode'~=10 drop if Exotic
		gen LuxSports = 0
		replace LuxSports = 1 if SportsCar
		replace LuxSports = 2 if DomesticLuxury
		replace LuxSports = 3 if ForeignLuxury
		replace LuxSports = 4 if ForeignHighLuxury
		* Simplify luxury nest
		replace LuxSports = 1 if LuxSports > 0
		drop Exotic ForeignHighLuxury ForeignLuxury SportsCar DomesticLuxury LuxlnP85 _merge

		/* Drop green cars or hybrids, for those specifications */
    if `specialcode'==8 keep if Green_Hybrid==.
    if `specialcode'==9 keep if Green_YahooRank==.

    /* Use JDP used data instead of Manheim */
		if `specialcode'==12 | `specialcode'==13 {
				keep if (Price<. & JDPUsedPrice<.) | Age<=0
		}
		if `specialcode'==13 | `specialcode'==14 {
		    replace Price = JDPUsedPrice if Age>=1
		    replace NumObs = JDPUsedSales if Age>=1
		}

		/* Keep only vehicles with characteristics data */
    if `specialcode'==11 | `specialcode'==16 {
    		drop if Liters<=0 | Liters==.
    		drop if PolkWheelbase<=0 | PolkWheelbase==.
    		drop if ShippingWeight<=0 | ShippingWeight==.
    }

    /* Conserve memory - drop text descriptions associated with CarID */
    drop Model Trim BodyStyle FuelType DriveWheels InPolk InManheim InJDP InWards InEPA 

    /* Conserve even more memory! */
    drop Cylinder Continent Country  MPGCity MPGHwy MSRP Truck AnnPrice AnnMeanPrice AnnPredPrice PredPrice JDPPrice JDPAdjPrice AdjPrice MeanPrice
    capture drop G0

    rename G`gcode' GasCost
    rename GInst`gcode' G0
    rename I`gcode' I
    
    if `adjustintensive'>0 {
    		if `specialcode'==15 replace GasCost = GasCost + I
    		else replace Price = Price + I
    }
    if "`gcode'" ~= "`primarycode'" {
        rename G`primarycode' GasCostPrimary
        rename GInst`primarycode' G0Primary
        rename I`primarycode' IPrimary
    }

    /* Conserve memory - drop other G variables */
    drop G1* GInst* I1*

    /* Use BLP rule to divide a CarID into generations based on characteristics.  An alternate CarID is created. */
    /* Presumably characteristics of the same CarID and ModelYear should not change over time.  In case they do,
       perform this test only for the month of January and the youngest age observed in the dataset.  */
    sort Month CarID Age ModelYear
    /* Liters and GPM seem like the best characteristics to use that are avaialble outside of the Wards data. */
		by Month CarID Age: gen BigChange = (abs(Liters-Liters[_n-1])/Liters[_n-1]>=.1) & Liters!=. & Liters[_n-1]!=. if _n>1
    by Month CarID Age: replace BigChange = 1 if abs(GPM-GPM[_n-1])/GPM[_n-1]>=.1 & GPM!=. & GPM[_n-1]!=. & _n>1
    gen GenNum = 1
    by Month CarID Age: replace GenNum = GenNum[_n-1] + BigChange if _n>1
    sort CarID ModelYear Age Month
    by CarID ModelYear: replace GenNum = GenNum[1]
    by CarID: egen NumGens = max(GenNum)
    by CarID: gen firstrec=(_n==1)
    tab NumGens if firstrec
    drop NumGens firstrec
    egen CarGenID = group(CarID GenNum)
    replace CarID = CarGenID

    gen Time = Year + (Month-1)/12
    keep if Time>=`mintime' & Time<=`maxtime'
    drop Time
    gen int Time = (Year-1999)*12 + Month-1
    

		/* ExtraDisp - control in regression and display in results / ExtraCtrl - control but do not display */
		local ExtraDisp=""
		local ExtraCtrl=""

	egen FEGroup = group(CarID Age Month)
	xtset FEGroup Time

    /* When summing quantities by year, make sure we don't add up across months. */
    bysort CarID ModelYear Year: gen AnnualQuantity = Quantity * (_n==1)

    /* Compute market shares and within-group market shares BEFORE dropping any data. */
    gen lnShare = ln(Quantity)

	gen MPG = 1/UnadjGPM
	xtile MPGNest = MPG, nquantiles(10)
	xtile HPNest = HP, nquantiles(10)
	xtile WeightNest = Weight, nquantiles(10)

    if `specialcode'>=30 & `specialcode'<=39 {
    		if `specialcode'==30 | `specialcode'==30.1 {
    				local nest1var = "VClass"
    				local nest2var = "AgeNest"
    		}
    		else if `specialcode'==31 | `specialcode'==31.1 {
    				local nest1var = "AgeNest"
    				local nest2var = "VClass"
    		}
    		else if `specialcode'==32 | `specialcode'==32.1 {
    				local nest1var = "VClass"
    				local nest2var = "LuxSports"
    		}
    		else if `specialcode'==33 | `specialcode'==33.1 {
    				local nest1var = "VClass"
    				local nest2var = "LuxP85"
    		}
    		else if `specialcode'==35 | `specialcode'==35.1 {
    				local nest1var = "VClass"
    				local nest2var = "AgeNest"
    				local nest3var = "LuxSports"
    		}
    		else if `specialcode'==36 {
    				local nest1var = "VClass"
    				local nest2var = "Firm"
    		}
    		else if `specialcode'==37 {
    				local nest1var = "VClass"
    				local nest2var = "HPNest"
    		}
    		else if `specialcode'==38 {
    				local nest1var = "VClass"
    				local nest2var = "MPGNest"
    		}
    		else if `specialcode'==39 {
    				local nest1var = "VClass"
    				local nest2var = "WeightNest"
    		}
		    * Create age nest variable
  		  recode Age (0/4 = 1) (5/10 = 2) (nonm = 3), gen(AgeNest)
				
				if `specialcode'~=35 & `specialcode'~=35.1 {
		        sort Year `nest1var' `nest2var'
				    by Year `nest1var': egen Nest1Q = total(AnnualQuantity)
				    by Year `nest1var' `nest2var': egen Nest2Q = total(AnnualQuantity)
				    gen lnNestShare1 = ln(Nest1Q)
				    gen lnNestShare2 = ln(Nest2Q)
				    local GroupShareList = "lnNestShare1 lnNestShare2"
				    egen gr1 = group(`nest1var')
				    qui sum gr1
				    local n1 = r(max)
				    egen gr2 = group(`nest2var')
				    qui sum gr2
				    local n2 = r(max)
				    qui sum Time
				    local maxt = r(max)
				    forvalues i=1/`n1' {
				    	forvalues j=1/`n2' {
				    		forvalues t=0/`maxt' {
				    			if `i'>1 | `j'>1 | `t'>=12 gen G`i'_`j'T`t'=(gr1==`i'&gr2==`j'&Time==`t')
				    		}
				    	}
				    }
				    *xi i.`nest1var'*i.`nest2var'*i.Time, prefix(_GT)
				}
				else {
		        sort Year `nest1var' `nest2var' `nest3var'
				    by Year `nest1var': egen Nest1Q = total(AnnualQuantity)
				    by Year `nest1var' `nest2var': egen Nest2Q = total(AnnualQuantity)
				    by Year `nest1var' `nest2var' `nest3var': egen Nest3Q = total(AnnualQuantity)
				    gen lnNestShare1 = ln(Nest1Q)
				    gen lnNestShare2 = ln(Nest2Q)
				    gen lnNestShare3 = ln(Nest3Q)
				    local GroupShareList = "lnNestShare1 lnNestShare2 lnNestShare3"
				    egen gr1 = group(`nest1var')
				    qui sum gr1
				    local n1 = r(max)
				    egen gr2 = group(`nest2var')
				    qui sum gr2
				    local n2 = r(max)
				    egen gr3 = group(`nest3var')
				    qui sum gr3
				    local n3 = r(max)
				    qui sum Time
				    local maxt = r(max)
				    forvalues i=1/`n1' {
				    	forvalues j=1/`n2' {
					    	forvalues k=1/`n3' {
					    		forvalues t=0/`maxt' {
					    			if `i'>1 | `j'>1 | `k'>1 | `t'>=12 gen G`i'_`j'_`k'T`t'=(gr1==`i'&gr2==`j'&gr3==`k'&Time==`t')
					    		}
					    	}
					    }
				    }
				    *xi i.`nest1var'*i.`nest2var'*i.`nest3var'*i.Time, prefix(_GT)
				}
		}
		else {
		    * Find group shares.  Use VClass as only nest in base specification.
				if `specialcode'==21 local groupvar = "Firm"
				else if `specialcode'==22 local groupvar = "HPNest"
				else if `specialcode'==23 local groupvar = "MPGNest"
				else if `specialcode'==24 local groupvar = "WeightNest"
				else local groupvar = "VClass"
		    sort Year `groupvar'
		    by Year `groupvar': egen GroupTotalQ = total(AnnualQuantity)
		    * GroupShare is the total market share of all cars in the group
		    * QInGroup is the market share of a car within its group
		    gen lnGroupShare = ln(GroupTotalQ)
		    gen lnQInGroup = ln(Quantity) - ln(GroupTotalQ)
		    local GroupShareList = "lnGroupShare"
		    egen gr1 = group(`groupvar')
		    qui sum gr1
		    local n1 = r(max)
		    qui sum Time
		    local maxt = r(max)
		    forvalues i=1/`n1' {
	    		forvalues t=0/`maxt' {
	    			if `i'>1 | `t'>=12 gen G`i'_`j'T`t'=(gr1==`i'&Time==`t')
	    		}
		    }
		    *xi i.`groupvar'*i.Time, prefix(_GT)
		}
		if `specialcode'==40 | `specialcode'==41 {
				qui sum VClass
				local minclass = r(min)
				local maxclass = r(max)
				forvalues i=`minclass'/`maxclass' {
						if `i'>`minclass' gen ClassTrend`i' = (VClass==`i')*Time
						if `specialcode'==41 gen ClassTrendSq`i' = (VClass==`i')*Time^2
				}
				local ExtraCtrl = "ClassTrend*"
				if `specialcode'==41 local ExtraCtrl = "ClassTrend* ClassTrendSq*"
		}
		
    /* We don't know true quantities for MY2008 vehicles. */
    replace Quantity = . if ModelYear==2008

    /* Keep only the observations that will be used in the nested logit estimation */
    keep if Age>=`minage' & Age<=`maxage'
    keep if ModelYear>=`minmy' & ModelYear<=`maxmy'
    keep if VClass>=`minclass' & VClass<=`maxclass'

    sort FEGroup Time
    gen HavePrice = (Price < .)
    gen HavePosQ = (Quantity < . & Quantity>0)
    gen HaveG = (GasCost < .)
    gen HaveClass = (VClass>0 & VClass<.)
    gen HaveInst = (G0<.)
    gen ObsValidNL = (HavePrice & HavePosQ & HaveG & HaveClass & HaveInst & NumObs>0)
    by FEGroup: egen NumValidObsNL = total(ObsValidNL)

    keep if NumValidObsNL>=2 & ObsValidNL
    sort FEGroup

    /* Reweight so that new vehicles match 1 year old vehicles. */
    if `maxage'>0 {
				forvalues yr=1999/2008 {
				    sum NumObs if Age==0 & Year==`yr'
				    local mean0 = r(mean)
				    sum NumObs if Age==1 & Year==`yr'
				    local mean1 = r(mean)
				    replace NumObs = NumObs * `mean1'/`mean0' if Age<=0 & Year==`yr'
				}
    }

    tab Year
    drop NumValidObsNL
    sort FEGroup Time

		xi i.Time, prefix(_T)
		* Drop first 11 time dummies to avoid collinearities
		if `specialcode'~=6 {
			qui sum Time
			forvalues i=1/11 {
					local t=`i'+r(min)
					drop _TTime_`t'
			}
		}
		local MYdummies = ""
		xi i.ModelYear, prefix(_MY)

		local IN = ""
		if `specialcode'==6 {
			local numbins=2
			local agebinsize=0
			local timebinsize=0
			xtile MPGBin = MPG, nquantiles(`numbins')
			forvalues i=1/`numbins' {
					sum MPG if MPGBin==`i'
			}
			if `agebinsize'==0 gen AgeBin=1
			else gen AgeBin = floor((Age+1)/`agebinsize')
			if `timebinsize'==0 gen TimeBin=Time
			local ExtraCtrl="_T*"

			qui sum MPGBin
			local mmin=r(min)
			local mmax=r(max)
			qui sum AgeBin
			local amin = r(min)
			local amax = r(max)
			qui sum TimeBin
			local tmin = r(min)+12
			local tmax = r(max)
			qui gen InstGroup=.
			local in=0
			forvalues m=`mmin'/`mmax' {
				forvalues a=`amin'/`amax' {
					forvalues t=`tmin'/`tmax' {
						if `m'>`mmin' | `a'>`amin' {
							local in=`in'+1
							gen _IN`m'_`a'_`t'= (MPGBin==`m' & AgeBin==`a' & TimeBin==`t')
						}
					}
				}
			}
			local IN = "_IN*"
		}
		gen lnShareMPG = lnShare*MPG
		gen lnShareAge = lnShare*Age
		gen lnShareMPGAge = lnShare*MPG*Age
		gen G0MPG = G0*MPG
		gen G0Age = G0*Age
		gen G0MPGAge = G0*MPG*Age
		drop MPG
		
		/* Demean */
		sort FEGroup
		by FEGroup: egen TotalObs = total(NumObs)
		foreach var of varlist Price GasCost _T* _MY* `GroupShareList' lnShare lnShareMPG lnShareAge lnShareMPGAge G0 G0MPG G0Age G0MPGAge `ExtraDisp' `ExtraCtrl' `IN' {
				by FEGroup: egen WeightedSum`var' = total(NumObs*`var')
				gen DM`var' = `var' - WeightedSum`var'/TotalObs
				replace `var' = DM`var'
				drop WeightedSum`var' DM`var'
		}
		
		local outvar = "GasCost lnShare `ExtraDisp'"
		local outvar1 = "G0 GasCost"
		if `specialcode'==1 | `specialcode'==1.1 local outvar = "GasCost"
		if `specialcode'==2 | `specialcode'==2.1 local outvar = "GasCost lnShare"
		if `specialcode'==2 | `specialcode'==2.1 local outvar1 = "G0 GasCost"
		if `specialcode'<0 local outvar = "GasCost"
		if `specialcode'==5 | `specialcode'==6 local outvar = "GasCost"
		if `specialcode'==4 local outvar = "GasCost `GroupShareList'"
	
		if `row'==1 local rep = "replace"
		else local rep = "append"

		/* Set level of clustering */
		if `specialcode'<=-1000 egen ClVar = group(CarID ModelYear)
		else egen ClVar = group(CarID Age)

		/* PERFORM ESTIMATION */
		if (`specialcode'==0 | `specialcode'>3) & `specialcode'==floor(`specialcode') & `specialcode'~=4 & `specialcode'~=5 & `specialcode'~=6 {
				ivreg2 Price GasCost (lnShare = G0) `ExtraDisp' `ExtraCtrl' _MY* G*T*  [aw=NumObs], r first cl(ClVar)
		}
		if (`specialcode'==0.1 | `specialcode'>3) & `specialcode'~=floor(`specialcode') {
				ivreg2 Price GasCost (lnShare = G0 _MY*) `GroupShareList' `ExtraDisp' `ExtraCtrl' G*T*  [aw=NumObs], r first cl(ClVar)
		}
		if `specialcode'==1 reg Price GasCost _MY* G*T*  [aw=NumObs], r cl(ClVar)
		if `specialcode'==1.1 reg Price GasCost G*T*  [aw=NumObs], r cl(ClVar)
		if `specialcode'==2 ivreg2 Price GasCost (lnShare = G0) _MY* G*T*  [aw=NumObs], r first cl(ClVar)
		if `specialcode'==2.1 ivreg2 Price GasCost (lnShare = G0 _MY*) G*T*  [aw=NumObs], r first cl(ClVar)
		if `specialcode'==3 reg Price GasCost lnShare _MY* G*T*  [aw=NumObs], r cl(ClVar)
		if `specialcode'==3.1 reg Price GasCost lnShare G*T*  [aw=NumObs], r cl(ClVar)
		if `specialcode'==4 {
				tab VClass
				tab Time
				tab ModelYear
				ivreg2 Price GasCost (lnShare = G0) `GroupShareList' `ExtraDisp' `ExtraCtrl' _MY* _T* [aw=NumObs], r first cl(ClVar)
		}
		if `specialcode'==5 {
				tab VClass
				tab Time
				tab ModelYear
				reg Price GasCost `ExtraDisp' `ExtraCtrl' _MY* _T* [aw=NumObs], r cl(ClVar)
		}
		if `specialcode'==6 ivreg2 Price (GasCost = _IN*) `ExtraCtrl' [aw=NumObs], r cl(ClVar) first
		local k=e(df_m)

		/* Get number of FE groups */
		egen GroupNum = group(FEGroup)
		qui sum GroupNum
		local NumFEGroup = r(max)
		drop GroupNum

		/* Output results */
		matrix a=e(first)
		local fshare=a[3,1]
		local widstat = e(widstat)
		if `specialcode'==1 | `specialcode'==3 | `specialcode'<0 | `specialcode'==4 | `specialcode'==5 local widstat=0
		if `specialcode'==1.1 | `specialcode'==3.1 local widstat=0
		
		outreg `outvar' using "Estimation/`outfilename'.txt", noparen noaster se bdec(3) `rep' ///
			addstat("specialcode",`specialcode',"widstat",`widstat',"NumFEGroup",`NumFEGroup',"K",`k')

		/* First stage */
		if `specialcode'==0 | `specialcode'==2 | (`specialcode'>3 & `specialcode'<=17 & `specialcode'~=4 & `specialcode'~=5 & `specialcode'~=6) | (`specialcode'>=30 & `specialcode'<=39) {
				replace G0 = G0 / 1000000
				replace GasCost = GasCost / 1000000
				reg lnShare `outvar1' _MY* _T*  [aw=NumObs], r cl(ClVar)
				test G0
				local fexclinst = r(F)
				outreg `outvar1' using "Estimation/`outfilename'1stage.txt", noparen noaster se bdec(3) `rep' ///
						addstat("specialcode",`specialcode',"fexclinst",`fexclinst')
		}
		else {
				/* use a placeholder */
				reg G0 G0
				outreg G0 using "Estimation/`outfilename'1stage.txt", noparen noaster se bdec(3) `rep'
		}				
}

log close

set more on

/* MakeTables */

# delimit cr

set more off

clear all
set mem 6g
set matsize 5000
set maxvar 7000

local outfilename = "MakeTable5Mart"
local primarycode = "1000000006025024100110"

capture file close outfile
capture log close
log using "Estimation/`outfilename'.log", replace

* Set to 0 to estimate a different sigma for each nest, set to 1 to constrain sigma to be the same
local onesigma=1
local useblp=0
local BLPInst1 = "BLP_InFirm BLP_InCont BLP_OutCont"
local pointest = 0

/* Get gas price trends for tests of sensitivity to large vs small and upward vs downward changes. */
use Data/GasPrices/SpotGasPrice
sort Year Month
gen GasPriceDown = (GasPrice<GasPrice[_n-1])
gen GasPriceBigChange = (abs(GasPrice-GasPrice[_n-1])>=0.1)
gen GasPriceHigh = (GasPrice>2.50)
gen g_0=(GasPrice<2)
gen g_1=(GasPrice>=2 & GasPrice<=2.50)
gen g_2=(GasPrice>=2.50 & GasPrice<=3.00)
gen g_3=(GasPrice>=3.00)
keep Year Month GasPriceDown GasPriceBigChange GasPriceHigh g_*
sort Year Month
tempfile GasPriceChange
save `GasPriceChange'
clear all

/*  Parameter matrix: each row is a separate regression.  Each column
    corresponds to a parameter:
-    First 8 parameters affect vehicles included in the dataset:
    min age, max age, min year, max year, min MY, max MY, min class, max class,
    a set of codes affecting the computation of G (See GetGI.do for details), and
    a code for special specification (described in comments below)
*/

/* Transaction-weighted */
local params1 =" 1,15,1999,2008.167,1950,2008,1, 9,1000000006025024100000, 20, 0,0" /* All ages */
local params2 =" 1, 3,1999,2008.167,1950,2008,1, 9,1000000006025024100000, 20, 0,0" /* Age 1-3 */
local params3 =" 4, 6,1999,2008.167,1950,2008,1, 9,1000000006025024100000, 20, 0,0" /* Age 4-6 */
local params4 =" 7,10,1999,2008.167,1950,2008,1, 9,1000000006025024100000, 20, 0,0" /* Age 7-10 */
local params5 ="11,15,1999,2008.167,1950,2008,1, 9,1000000006025024100000, 20, 0,0" /* Age 11-15 */

/* NHTS survival probabilities */
local params6 =" 1,15,1999,2008.167,1950,2008,1, 9,1000400006025024100000, 20, 0,0" /* All ages */
local params7 =" 1, 3,1999,2008.167,1950,2008,1, 9,1000400006025024100000, 20, 0,0" /* Age 1-3 (NHTS) */
local params8 =" 4, 6,1999,2008.167,1950,2008,1, 9,1000400006025024100000, 20, 0,0" /* Age 4-6 (NHTS) */
local params9 =" 7,10,1999,2008.167,1950,2008,1, 9,1000400006025024100000, 20, 0,0" /* Age 7-10 (NHTS) */
local params10="11,15,1999,2008.167,1950,2008,1, 9,1000400006025024100000, 20, 0,0" /* Age 11-15 (NHTS) */

/* JDP sample / prices */
local params11=" 1,15,1999,2008.167,1950,2008,1, 9,1000000006025024100000, 20,14,0" /* All ages */
local params12=" 1, 3,1999,2008.167,1950,2008,1, 9,1000000006025024100000, 20,14,0" /* Age 1-3, JDP sample / prices */
local params13=" 4, 6,1999,2008.167,1950,2008,1, 9,1000000006025024100000, 20,14,0" /* Age 4-6, JDP sample / prices */
local params14=" 7,10,1999,2008.167,1950,2008,1, 9,1000000006025024100000, 20,14,0" /* Age 7-10, JDP sample / prices */
local params15="11,15,1999,2008.167,1950,2008,1, 9,1000000006025024100000, 20,14,0" /* Age 11-15, JDP sample / prices */

/* Equal weight */
local params16=" 1,15,1999,2008.167,1950,2008,1, 9,1000000006025024100000, 20,61,0" /* Equal weights */
local params17=" 1, 3,1999,2008.167,1950,2008,1, 9,1000000006025024100000, 20,61,0" /* Age 1-3, equal weights */
local params18=" 4, 6,1999,2008.167,1950,2008,1, 9,1000000006025024100000, 20,61,0" /* Age 4-6, equal weights */
local params19=" 7,10,1999,2008.167,1950,2008,1, 9,1000000006025024100000, 20,61,0" /* Age 7-10, equal weights */
local params20="11,15,1999,2008.167,1950,2008,1, 9,1000000006025024100000, 20,61,0" /* Age 11-15, equal weights */

local maxrow=73
local row=0

	
/******************************************************************/
/*********************** GROUPING ESTIMATOR ***********************/
/******************************************************************/
while `row'<=`maxrow' {
    local row=`row'+1
    if `row'>=91 & `row'<=97 local pointest=1
    if `row'>=98 local pointest=0
    local lineok=0
    while `lineok'==0 {
        if "`params`row''"=="" local row=`row'+1
        else local lineok=1
        if `row'>`maxrow' local lineok=1
        if `row'>`maxrow' continue
    }
    if `row'>`maxrow' continue
    di "Row `row': `params`row''"
    forvalues i=1/11 {
        local comma=strpos("`params`row''",",")
        local param`i'=substr("`params`row''",1,`comma'-1)
        local params`row'=substr("`params`row''",`comma'+1,99999)
    }
    local param12 = "`params`row''"
    local minage=real("`param1'")
    local maxage=real("`param2'")
    local mintime=real("`param3'")
    local maxtime=real("`param4'")
    local minmy=real("`param5'")
    local maxmy=real("`param6'")
    local minclass=real("`param7'")
    local maxclass=real("`param8'")
    local gcode="`param9'"
    local bincode=real("`param10'")
    local specialcode=real("`param11'")
    local etainv=real("`param12'")

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
		qui replace LuxSports = 1 if SportsCar
		qui replace LuxSports = 2 if DomesticLuxury
		qui replace LuxSports = 3 if ForeignLuxury
		qui replace LuxSports = 4 if ForeignHighLuxury
		drop Exotic ForeignHighLuxury ForeignLuxury SportsCar DomesticLuxury LuxlnP85 _merge

		/* Drop SUVs / pickups */
		if `specialcode'==6 drop if VClass==7
		if `specialcode'==7 drop if VClass==8
		
		/* Drop green cars or hybrids, for those specifications */
    if `specialcode'==8 keep if Green_Hybrid==.
    if `specialcode'==9 keep if Green_YahooRank==.

    /* Use JDP used data instead of Manheim */
		if `specialcode'==12 | `specialcode'==13 | `specialcode'==22.1 | `specialcode'==22.2 {
				keep if (Price<. & JDPUsedPrice<.) | Age<=0
		}
		if `specialcode'==13 | `specialcode'==14 | `specialcode'==22.2 | `specialcode'==51.1 {
		    qui replace Price = JDPUsedPrice if Age>=1
		    qui replace NumObs = JDPUsedSales if Age>=1
		}
		/* Use JDP Prices but Manheim weights */
		if `specialcode'==13.1 {
		    qui replace Price = JDPUsedPrice if Age>=1
		}
		/* Use Manheim Prices but JDP weights */
		if `specialcode'==13.2 {
		    qui replace NumObs = JDPUsedSales if Age>=1
		}

		/* Keep only vehicles with characteristics data (Prefix) */
    if `specialcode'==11 | `specialcode'==16 {
    		drop if Liters<=0 | Liters==.
    		drop if PolkWheelbase<=0 | PolkWheelbase==.
    		drop if ShippingWeight<=0 | ShippingWeight==.
    }

		/* Keep only vehicles with characteristics data (Wards) */
    if (`specialcode'>=11.1 & `specialcode'<=11.9) | `specialcode'==16.1 {
    		foreach var in HP Wheelbase Weight Torque ABS {
		    		drop if `var'<=0 | `var'==.
		    }
    }

		egen FirmID = group(Firm)
    egen Nameplate = group(Make Model)
    /* Conserve memory - drop text descriptions associated with CarID */
    drop Make Model Trim BodyStyle FuelType DriveWheels InPolk InManheim InJDP InWards InEPA Firm
    drop Cylinder Continent Country  MPGCity MPGHwy Truck AnnPrice AnnMeanPrice AnnPredPrice PredPrice JDPPrice JDPAdjPrice AdjPrice MeanPrice
    capture drop G0

    rename G`gcode' GasCost
    rename GInst`gcode' G0
    rename I`gcode' I
    
    if `adjustintensive'>0 {
    		if `specialcode'==0 | `specialcode'==15.1 qui replace Price = Price - I
    		if `specialcode'==15 qui replace GasCost = GasCost - I
    		if `specialcode'==15.1 qui replace GasCost = G`primarycode'
    }
    if "`gcode'" ~= "`primarycode'" {
        rename G`primarycode' GasCostPrimary
        rename GInst`primarycode' G0Primary
        rename I`primarycode' IPrimary
    }

    if `specialcode'>4 & `specialcode'<6 {
        rename G1001000006025024100000 GasCost1
        rename G1002000006025024100000 GasCost2
        rename G1003000006025024100000 GasCost3
        rename G1004000006025024100000 GasCost4
    }
    if `specialcode'>5 & `specialcode'<6 {
    		local maxlag = round((`specialcode'-5)*10,1)
    		if (`specialcode'-5)-`maxlag'*0.1==0.01 {
	    			gen GasCostAvg = Gascost
		    		forvalues i=1/`maxlag' {
		    				qui replace GasCostAvg = GasCostAvg + GasCost`i'
		    		}
		    		qui replace GasCostAvg = GasCostAvg / (`maxlag'+1)
				}
				else {    			
		    		gen GasCostAvg = 0
		    		forvalues i=1/`maxlag' {
		    				qui replace GasCostAvg = GasCostAvg + GasCost`i'
		    		}
		    		qui replace GasCostAvg = GasCostAvg / (`maxlag')
		    	}
		}
		
    /* Conserve memory - drop other G variables */
    drop G1* GInst* I1*

		gen OrigCarID = CarID
    /* Use BLP rule t`o divide a CarID into generations based on characteristics.  An alternate CarID is created. */
    /* Presumably characteristics of the same CarID and ModelYear should not change over time.  In case they do,
       perform this test only for the month of January and the youngest age observed in the dataset.  */
    sort Month CarID Age ModelYear
    /* Liters and GPM seem like the best characteristics to use that are avaialble outside of the Wards data. */
		by Month CarID Age: gen BigChange = (abs(Liters-Liters[_n-1])/Liters[_n-1]>=.1) & Liters!=. & Liters[_n-1]!=. if _n>1
    qui by Month CarID Age: replace BigChange = 1 if abs(GPM-GPM[_n-1])/GPM[_n-1]>=.1 & GPM!=. & GPM[_n-1]!=. & _n>1
    gen GenNum = 1
    qui by Month CarID Age: replace GenNum = GenNum[_n-1] + BigChange if _n>1
    sort CarID ModelYear Age Month
    qui by CarID ModelYear: replace GenNum = GenNum[1]
    by CarID: egen NumGens = max(GenNum)
    by CarID: gen firstrec=(_n==1)
    tab NumGens if firstrec
    drop NumGens firstrec
    egen CarGenID = group(CarID GenNum)
    qui replace CarID = CarGenID

    gen Time = Year + (Month-1)/12
    keep if Time>=`mintime' & Time<=`maxtime'
    drop Time
    gen int Time = (Year-1999)*12 + Month-1

		egen FEGroup = group(CarID Age)
		
    /* When summing quantities by year, make sure we don't add up across months. */
    bysort CarID ModelYear Year: gen AnnualQuantity = Quantity * (_n==1)

    gen lnShare = ln(Quantity)

    * Find group shares.  Use VClass as only nest.
    local groupvar = "VClass"
    sort Year `groupvar'
    by Year `groupvar': egen GroupTotalQ = total(AnnualQuantity)
    * GroupShare is the total market share of all cars in the group
    * QInGroup is the market share of a car within its group
    gen lnGroupShare = ln(GroupTotalQ)
    gen lnQInGroup = ln(Quantity) - ln(GroupTotalQ)
    local GroupShareList = "lnGroupShare"
		
    /* We don't know true quantities for MY2008 vehicles. */
    qui replace Quantity = . if ModelYear==2008

		/* Characteristics on LHS */
		if `specialcode'==31.1 qui replace Price = 10^6*ln(Liters)
		if `specialcode'==31.2 qui replace Price = 10^6*ln(PolkWheelbase)
		if `specialcode'==31.3 qui replace Price = 10^6*ln(ShippingWeight)
		if `specialcode'==32.1 qui replace Price = 10^6*ln(HP)
		if `specialcode'==32.2 qui replace Price = 10^6*ln(Weight)
		if `specialcode'==32.3 qui replace Price = 10^6*ln(Wheelbase)
		if `specialcode'==32.4 qui replace Price = MSRP
		if `specialcode'==32.5 qui replace Price = 10^6*ln(Torque)
		if `specialcode'==32.6 qui replace Price = 100*Traction
		if `specialcode'==32.7 qui replace Price = 100*ABS
		if `specialcode'==32.8 qui replace Price = 100*Stability
	
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
				    qui replace NumObs = NumObs * `mean1'/`mean0' if Age<=0 & Year==`yr'
				}
    }

    tab Year
    drop NumValidObsNL
    sort FEGroup Time

		xi i.Time, prefix(_T)
		
		local ExtraCtrl="_T* Mo*MPG*"
		if `maxtime'-`mintime'<1 local ExtraCtrl=""
		local ExtraG = ""

		/* Nested Logit */
		if `etainv'~=0 local ExtraCtrl="`ExtraCtrl' lnGroupShare"
				
    /* Horse race */
    if `specialcode'==4 {
				gen DeltaGasCost = GasCost - GasCostPrimary
				qui replace GasCost = GasCostPrimary
				local ExtraG = "DeltaGasCost"
    }
    if `specialcode'==4.1 {
				gen DeltaG1 = GasCost - GasCost1
				local ExtraG = "DeltaG1"
				forvalues i=1/5 {
						local i1=`i'+1
						gen DeltaG`i1'= GasCost`i'-GasCost`i1'
						local ExtraG = "`ExtraG' DeltaG`i1'"
				}
    }
    if `specialcode'==4.2 {
				forvalues i=1/6 {
						gen DeltaG`i'= GasCost-GasCost`i'
						local ExtraG = "`ExtraG' DeltaG`i'"
				}
    }
    if `specialcode'==4.3 {
				forvalues i=1/6 {
						local ExtraG = "`ExtraG' GasCost`i'"
				}
    }
    if `specialcode'==4.4 {
    		qui replace GasCost = GasCost1
				forvalues i=2/6 {
						local ExtraG = "`ExtraG' GasCost`i'"
				}
    }
    if `specialcode'==4.5 {
				forvalues i=2/6 {
						local ExtraG = "`ExtraG' GasCost`i'"
				}
    }
    if `specialcode'==4.6 {
				gen DeltaG1 = GasCost - GasCost1
				local ExtraG = ""
				forvalues i=1/5 {
						local i1=`i'+1
						gen DeltaG`i1'= GasCost`i'-GasCost`i1'
						local ExtraG = "`ExtraG' DeltaG`i1'"
				}
    }
    if `specialcode'==4.7 {
				qui replace GasCost = GasCost - GasCost1
				local ExtraG = ""
				forvalues i=1/5 {
						local i1=`i'+1
						gen DeltaG`i1'= GasCost`i'-GasCost`i1'
						local ExtraG = "`ExtraG' DeltaG`i1'"
				}
    }
    /*
    if `specialcode'==5 {
        foreach i in 1 2 3 4 {
            gen DeltaGasCost`i' = GasCost`i' - GasCost
            local ExtraDisp = "`ExtraDisp' DeltaGasCost`i'"
        }
    }
    */
    if `specialcode'>5 & `specialcode'<6 {
    		if `specialcode'*10-floor(`specialcode'*10)==0 {
						gen DeltaGasCost = GasCostAvg - GasCost
						local ExtraG = "DeltaGasCost"
				}
				else {
						qui replace GasCost = GasCostAvg
				}
    }

		/* Control for characteristics */
    if `specialcode'==11 {
    		gen lnLiters = ln(Liters)
    		gen lnWheelbase = ln(PolkWheelbase)
    		gen lnWeight = ln(ShippingWeight)
    		local ExtraCtrl = "`ExtraCtrl' lnLiters lnWheelbase lnWeight"
    }
    if `specialcode'==11.1 {
    		gen lnHP = ln(HP)
    		local ExtraCtrl = "`ExtraCtrl' lnHP"
    }
    if `specialcode'==11.2 {
    		gen lnHP = ln(HP)
    		gen lnWeight = ln(Weight)
    		local ExtraCtrl = "`ExtraCtrl' lnHP lnWeight"
    }
    if `specialcode'==11.3 {
    		gen lnHP = ln(HP)
    		gen lnWeight = ln(Weight)
    		gen lnWheelbase = ln(Wheelbase)
    		local ExtraCtrl = "`ExtraCtrl' lnHP lnWeight lnWheelbase"
    }
    if `specialcode'==11.4 {
    		gen lnHP = ln(HP)
    		gen lnWeight = ln(Weight)
    		gen lnWheelbase = ln(Wheelbase)
    		gen lnTorque = ln(Torque)
    		local ExtraCtrl = "`ExtraCtrl' lnHP lnWeight lnWheelbase lnTorque Traction ABS Stability"
    }
    
    if `specialcode'==7.1 {
    		forvalues cl=1/9 {
    				gen Class`cl'Time = (VClass==`cl')*Time
    		}
    		local ExtraCtrl = "`ExtraCtrl' Class8Time"
    }
    if `specialcode'==7.2 {
    		forvalues cl=1/9 {
    				gen Class`cl'Time = (VClass==`cl')*Time
    		}
    		local ExtraCtrl = "`ExtraCtrl' Class7Time Class8Time"
    }
    if `specialcode'==7.3 {
    		forvalues cl=1/9 {
    				gen Class`cl'Time = (VClass==`cl')*Time
    		}
    		* Exclude subcompacts
    		drop Class3Time
    		local ExtraCtrl = "`ExtraCtrl' Class*Time"
    }
    		
    if `specialcode'>=17 & `specialcode'<=19.1 {
    		sort Year Month
    		merge Year Month using `GasPriceChange', uniqusing nokeep
				assert _merge==3
				drop _merge
				if `specialcode'==17 {
						gen G_g_Down = (GasCost * GasPriceDown)
						local ExtraG = "`ExtraG' G_g_Down"
				}
				if `specialcode'==18 {
						gen G_g_BigChange = (GasCost * GasPriceBigChange)
						local ExtraG = "`ExtraG' G_g_BigChange"
				}
				if `specialcode'==19 {
						gen G_g_High = (GasCost * GasPriceHigh)
						local ExtraG = "`ExtraG' G_g_High"
				}
				if `specialcode'==19.1 {
						forvalues i=1/3 {
								gen G_g_`i' = (GasCost * g_`i')
								local ExtraG = "`ExtraG' G_g_`i'"
						}
				}
		}
		if `specialcode'==20 {
				gen G_pre04 = GasCost * (Year<2004)
				local ExtraG = "`ExtraG' G_pre04"
				qui replace GasCost = GasCost * (Year>=2004)
		}
		if `specialcode'==21 {
				gen G_pre05 = GasCost * (Year<2005)
				local ExtraG = "`ExtraG' G_pre05"
				qui replace GasCost = GasCost * (Year>=2005)
		}
		if `specialcode'==22 | `specialcode'==22.1 | `specialcode'==22.2 {
				gen G_pre04 = GasCost * (Year<2004)
				gen G_post0308 = GasCost * (Year==2008 & Month>3)
				local ExtraG = "`ExtraG' G_pre04 G_post0308"
				qui replace GasCost = GasCost * (Year>=2004 & (Year<2008 | Month<=3))
		}
		if `specialcode'==23 {
				gen G_pre05 = GasCost * (Year<2005)
				gen G_post0308 = GasCost * (Year==2008 & Month>3)
				local ExtraG = "`ExtraG' G_pre05 G_post0308"
				qui replace GasCost = GasCost * (Year>=2005 & (Year<2008 | Month<=3))
		}
		if `specialcode'==60 {
				gen AgeBin = floor((Age+1)/2)
				xi i.Year*i.AgeBin, prefix(_YA)
				local ExtraCtrl = "_YA*"
				local ExtraInst = "m_YA*"
				drop AgeBin
		}
		if `specialcode'==61 {
				qui replace NumObs=1
		}
		if `specialcode'==62 {
				xtile MPGBin = MPG, nquantiles(2)
				xi i.Time*i.MPGBin, prefix(_TM)
				local ExtraCtrl = "_TM*"
				local ExtraInst = "m_TM*"
				drop MPGBin
		}
		if `specialcode'==63 {
				xi i.Time*i.VClass, prefix(_CT)
				local ExtraCtrl = "`ExtraCtrl' _CT*"
		}
		/* lnShare on LHS */		
		*if `specialcode'==30 qui replace Price = 10^6*lnShare

		/* Grouping estimator prep */
		gen MPG = 1/UnadjGPM
		if `bincode'>0 {
				local timebinsize = floor(`bincode'/1000)
				local numbins = floor((`bincode'-1000*`timebinsize')/10)
				local agebinsize = `bincode' - 1000*`timebinsize' - 10*`numbins'
		}
		else {
				local timebinsize = floor(-`bincode'/1000)
				local numbins = floor((-`bincode'-1000*`timebinsize')/10)
				local agebinsize = -`bincode' - 1000*`timebinsize' - 10*`numbins'
		}
		di "Time bin size: `timebinsize'.  MPG bins: `numbins'.  Age bin size: `agebinsize'."
		if `numbins'==0 egen MPGBin = group(VClass)
		else xtile MPGBin = MPG, nquantiles(`numbins')
		forvalues i=1/`numbins' {
				sum MPG if MPGBin==`i'
		}
		if `agebinsize'==0 gen AgeBin=1
		else gen AgeBin = floor((Age+1)/`agebinsize')
		if `timebinsize'==0 gen TimeBin=Time
		else {
				gen TimeBin = floor((Time-1)/`timebinsize')+1
				drop _T*
				rename Time OrigTime
				rename TimeBin Time
				xi i.Time, prefix(_T)
				rename Time TimeBin 
				rename OrigTime Time
		}
		
		forvalues i=1/11 {
			forvalues j=2/`numbins' {
				gen Mo`i'MPG`j' = (Month==`i' & MPGBin==`j')
			}
		}

		sort FEGroup ModelYear
		by FEGroup: gen WithinGroupAge = ModelYear-ModelYear[1]

		if floor(`specialcode')==1 | floor(`specialcode')==2 {
				local ctrlcode=floor(`specialcode'*1000)/1000
				local ctrlbincode=round(10^6*(`specialcode'-`ctrlcode'),1)
				local ctrlnumbins = floor(`ctrlbincode'/10)
				local ctrlagebinsize = `ctrlbincode' - 10*`ctrlnumbins'
				di "Ctrl code: `ctrlcode'"
				di "Ctrl MPG bins: `ctrlnumbins'.  Age bin size: `ctrlagebinsize'."
				if `ctrlnumbins'>0 xtile CMPGBin = MPG, nquantiles(`ctrlnumbins')
				forvalues i=1/`ctrlnumbins' {
						sum MPG if CMPGBin==`i'
				}
				if `ctrlagebinsize'==0 gen CAgeBin=1
				else gen CAgeBin = floor((Age+1)/`ctrlagebinsize')
				
				if `ctrlcode'==1 {
						xi i.WithinGroupAge, prefix(_W)
						local ExtraCtrl = "`ExtraCtrl' _W*"
						local ExtraInst = "`ExtraInst' m_W*"
				}
				if `ctrlcode'==1.2 {
						egen WGA_MY = group(WithinGroupAge ModelYear)
						xi i.WGA_MY, prefix(_WMY)
						local ExtraCtrl = "`ExtraCtrl' _WMY*"
						local ExtraInst = "`ExtraInst' m_WMY*"
				}
				if `ctrlcode'==1.3 {
						egen MPG_WGA = group(CMPGBin WithinGroupAge)
						xi i.MPG_WGA, prefix(_MW)
						local ExtraCtrl = "`ExtraCtrl' _MW*"
						local ExtraInst = "`ExtraInst' m_MW*"
				}
				if `ctrlcode'==1.34 {
						egen MPG_A_WGA = group(CMPGBin CAgeBin WithinGroupAge)
						xi i.MPG_A_WGA, prefix(_MAW)
						local ExtraCtrl = "`ExtraCtrl' _MAW*"
						local ExtraInst = "`ExtraInst' m_MAW*"
				}
				if `ctrlcode'==2 {
						xi i.ModelYear, prefix(_MY)
						local ExtraCtrl = "`ExtraCtrl' _MY*"
						local ExtraInst = "`ExtraInst' m_MY*"
				}
				if `ctrlcode'==2.3 {
						gen MYmod = ModelYear
						qui replace MYmod = 1990 if MYmod<1990
						egen MY_MPG = group(MYmod CMPGBin)
						xi i.MY_MPG, prefix(_MYM)
						local ExtraCtrl = "`ExtraCtrl' _MYM*"
						local ExtraInst = "`ExtraInst' m_MYM*"
				}
				if `ctrlcode'==1.323 {
						egen MPG_WGA = group(CMPGBin WithinGroupAge)
						xi i.MPG_WGA, prefix(_MW)
						egen MY_MPG = group(ModelYear CMPGBin)
						xi i.MY_MPG, prefix(_MYM)
						local ExtraCtrl = "`ExtraCtrl' _MW* _MYM*"
						local ExtraInst = "`ExtraInst' m_MW* m_MYM*"
				}
		}
				
		if `specialcode'==51 | `specialcode'==51.1 {
				xi i.AgeBin, prefix(_A)
				local ExtraCtrl = "`ExtraCtrl' _A*"
				local ExtraInst = "`ExtraInst' m_A*"
		}
		if `specialcode'==52 {
				qui sum AgeBin
				local minage = r(min)
				local maxage = r(max)
				forvalues i=1/`numbins' {
						forvalues j=`minage'/`maxage' {
								qui sum MPGBin if MPGBin==`i'
								local numinbin=r(N)
*								if (`i'>1 | `j'>`minage') & `numinbin'>0 gen _MPG`i'Age`j'=(MPGBin==`i'&AgeBin==`j')
								if (`j'>`minage') & `numinbin'>0 gen _MPG`i'Age`j'=(MPGBin==`i'&AgeBin==`j')
						}
				}
				local ExtraCtrl = "`ExtraCtrl' _MPG*Age*"
				local ExtraInst = "`ExtraInst' m_MPG*Age*"
		}

		/* Grouping estimator */
		if `specialcode'==40 {
				egen InstGroup = group(MPGBin AgeBin FirmID TimeBin)
				xi i.InstGroup, prefix(_IN)
		}
		else {
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
		}

		/* Demean */
		sort FEGroup
		by FEGroup: egen TotalObs = total(NumObs)
		foreach var of varlist Price GasCost `ExtraDisp' `ExtraCtrl' `ExtraG' _IN* {
				by FEGroup: egen WeightedSum`var' = total(NumObs*`var')
				gen DM`var' = `var' - WeightedSum`var'/TotalObs
				qui replace `var' = DM`var'
				drop WeightedSum`var' DM`var'
		}
		drop TotalObs
										
		if `row'==1 local rep = "replace"
		else local rep = "append"

		/* Set level of clustering */
		if `specialcode'==0.1 gen ClVar = CarID
		else if `specialcode'==0.2 egen ClVar = group(Nameplate Age)
		else egen ClVar = group(CarID Age)

		/* Generate collapsed dataset for unit root test */
		if `row'==1 {
				di "** Generating collapsed dataset**"
				preserve
				reg GasCost _IN* `ExtraCtrl' [aw=NumObs]
				predict GHat, xb
				reg Price `ExtraCtrl' [aw=NumObs]
				predict PRPrice, r
				reg GHat `ExtraCtrl' [aw=NumObs]
				predict PRGHat, r
				reg PRPrice PRGHat [aw=NumObs]
				sort MPGBin Time
				by MPGBin Time: egen TotalObs = total(NumObs)
				foreach var of varlist PRPrice PRGHat Price GasCost GHat {
					by MPGBin Time: egen sum = total(`var')
					replace `var'=sum/TotalObs
					drop sum
				}
				by MPGBin Time: keep if _n==1
				save AutoPQXG_Collapsed, replace
				restore
		}

		/* PERFORM ESTIMATION */
		if `specialcode'==41 | `specialcode'==41.5 {
			di "reg Price GasCost `ExtraCtrl' [aw=NumObs], r cl(ClVar)"
			reg Price GasCost `ExtraCtrl' [aw=NumObs], r cl(ClVar)
		}
		else {
			di "ivreg Price (GasCost `ExtraG' = _IN*) `ExtraCtrl' [aw=NumObs], r cl(ClVar) first"
			ivreg Price (GasCost `ExtraG' = _IN*) `ExtraCtrl' [aw=NumObs], r cl(ClVar) first
		}
		local outvar = "GasCost `ExtraG'"

		local k=e(df_m)

		/* Get number of FE groups */
		egen GroupNum = group(FEGroup)
		qui sum GroupNum
		local NumFEGroup = r(max)
		drop GroupNum

		/* Output results */
    capture outreg `outvar' using "Estimation/`outfilename'.txt", noparen noaster se bdec(3) `rep' ///
        addstat("bincode",`bincode',"specialcode",`specialcode',"NumFEGroup",`NumFEGroup',"K",`k')

}

log close

set more on 

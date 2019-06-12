clear all
cap log close
set more off 
set matsize 5000


**********************************************************************************************************
**********************************************************************************************************
************** Table 3. : Drone Strikes and Terrorist Violence: 2FE & 2FESL Estimates ********************
**********************************************************************************************************
************** Weekly FE w/out spatial lag ***************************************************************
**********************************************************************************************************
foreach p in incident lethty eldatk{
use JohnstonSarbahiDroneMasterData, replace
keep if year>2006
xtset id week
qui tab week, g (week)

**** This is for 2007 to 2011
display as error "The DEPENDENT VARIABLE IS `p'"
dis as text "FE w/time var & id"
qui reg `p'_a100k uav_a id2-id7 week2-week247, robust
est table, keep(uav_a _cons) se t p stats(r2)
estat ic
}

**********************************************************************************************************
********************  FE w/spatial lag *******************************************************************
**********************************************************************************************************
foreach p in incident lethty eldatk{
use JohnstonSarbahiDroneMasterData, replace

keep if year>2006
xtset id week
qui tab week, g (week)

**** This is for 2007 to 2011
display as error "The DEPENDENT VARIABLE IS `p'"
dis as text "FE w/time var & id, DV & SP Lags"
qui reg `p'_a100k uav_a `p'_n75_100k id2-id7 week2-week247, robust
est table, keep(uav_a _cons) se p t stats(r2)
estat ic
}


***********************************************************************************************************
************* Table 4: Militant Leaders Killed and Militant Violence: *************************************
************* 2FE & 2FESL Estimates ***********************************************************************
***********************************************************************************************************
************** Weekly FE w/out spatial lag ***************************************************************
**********************************************************************************************************

set more off 
foreach p in incident lethty eldatk{
use JohnstonSarbahiDroneMasterData, replace
keep if year>2006
xtset id week
qui tab week, g (week)
**** This is for 2007 to 2011
display as error "The DEPENDENT VARIABLE IS `p'"
dis as text "FE w/time var & id"
qui reg `p'_a100k uav_a  leaderskia_a id2-id7 week2-week247, robust
est table, keep(uav_a  leaderskia_a  _cons) se p t stats(r2)
estat ic
}
**********************************************************************************************************
********************* FE w/spatial lag *******************************************************************
**********************************************************************************************************

set more off 
foreach p in incident lethty eldatk{
use JohnstonSarbahiDroneMasterData, replace
keep if year>2006
xtset id week
qui tab week, g (week)
*g uavhvi= uav_a* leaderskia_a
**** This is for 2007 to 2011
**** UAV measure is binary
display as error "The DEPENDENT VARIABLE IS `p'"
dis as text "FE w/time var & id & SP Lags"
qui reg `p'_a100k uav_a  leaderskia_a `p'_n75_100k id2-id7 week2-week247, robust
outreg2 using "$tabs/Table4_Col_4-6.doc", keep(uav_a leaderskia_a) 
est table, keep(uav_a  leaderskia_a  _cons) se p t
estat ic
}



***********************************************************************************************************
************* Table 5: Drone Strikes and Neighborhood Militant Violence ***********************************
************* NOTE: We do not have figures for 'Attacks on Tribal Elders' beyond FATA *********************
***********************************************************************************************************
set more off 
foreach p in incident lethty {
forvalues z=25(25)150{
use JohnstonSarbahiDroneMasterData, replace

keep if year>2006
xtset id week
qui tab week, g (week)
**** This is for 2007 to 2011
display as error "The RADIUS IS `z'"
display as error "The DEPENDENT VARIABLE IS `p'"
qui reg `p'_n`z'_100k uav_a L.`p'_n`z'_100k id2-id7 week2-week247, robust
est table, keep(uav_a _cons) se p t stats(r2)
estat ic
}
}



***********************************************************************************************************
************* Table 6: The Duration of the Effect of Drone Strikes ****************************************
***********************************************************************************************************

set more off 
foreach p in incident lethty eldatk{
use JohnstonSarbahiDroneMasterData, replace

keep if year>2006
xtset id week
qui tab week, g (week)
**** This is for 2007 to 2011
**** UAV measure is binary
display as error "The DEPENDENT VARIABLE IS `p'"
dis as text "FE w/time var & id, DV & SP Lags"
qui reg `p'_a100k uav_a L.uav_a L2.uav_a L3.uav_a L4.uav_a L5.uav_a `p'_n75_100k L.`p'_a100k id2-id7 week2-week247, robust
est table, keep(uav_a L.uav_a L2.uav_a L3.uav_a L4.uav_a L5.uav_a _cons) se p t stats(r2)
estat ic
}


***********************************************************************************************************
************* ROBUSTNESS CHECKS ***************************************************************************
***********************************************************************************************************

**********************************************************************************************************
********************  Table A-1: Drone Strikes and Terrorist Militant Violence: 2008-2011*****************
**********************************************************************************************************
foreach p in incident lethty eldatk{
use JohnstonSarbahiDroneMasterData, replace

keep if year>2007
xtset id week
qui tab week, g (week)

**** This is for 2008 to 2011
display as error "The DEPENDENT VARIABLE IS `p'"
dis as text "FE w/time var & id, DV & SP Lags"
qui reg `p'_a100k uav_a `p'_n75_100k id2-id7 week2-week195, robust
est table, keep(uav_a _cons) se p t stats(r2)
estat ic
}


**********************************************************************************************************
********************  Table A-2: Drone Strikes and Terrorist Militant Violence: 2004-2011*****************
**********************************************************************************************************

foreach p in incident lethty eldatk{
use JohnstonSarbahiDroneMasterData, replace

xtset id week
qui tab week, g (week)
**** This is for 2004 to 2011
display as error "The DEPENDENT VARIABLE IS `p'"
dis as text "FE w/time var & id, DV & SP Lags"
qui reg `p'_a100k uav_a `p'_n75_100k id2-id7 week2-week403, robust
est table, keep(uav_a _cons) se p t stats(r2)
estat ic
}

**********************************************************************************************************
*******  Table A-3: Negative Binomial Estimates of Drone Strikes and Militant Violence: 2007-2011*********
**********************************************************************************************************
set more off 

foreach p in incident lethty {
use JohnstonSarbahiDroneMasterData, replace

keep if year>2006
xtset id week
qui tab week, g (week)
**** This is for 2007 to 2011
display as error "The DEPENDENT VARIABLE IS `p'"
qui nbreg `p'_a uav_a `p'_n L.`p'_a id2-id7 week2-week247, robust
est table, keep(uav_a _cons) se p t
estat ic
}

**********************************************************************************************************
************** Table B-2: Drone Strikes and Terrorist Violence: North & South Waziristan *****************
**********************************************************************************************************
**************************************** N. Waziristan ***************************************************
**********************************************************************************************************
foreach p in incident lethty eldatk{
use JohnstonSarbahiDroneMasterData, replace

keep if year>2006
xtset id week
qui tab week, g (week)
keep if id==120530
**** This is for 2007 to 2011
**** UAV measure is binary
**** FE w/time var & id, DV & SP Lags
display as error "The DEPENDENT VARIABLE IS `p'"
qui reg `p'_a100k uav_a `p'_n75_100k, robust
est table, keep(uav_a _cons) se p t stats(r2)
estat ic
}

**********************************************************************************************************
*************************************** S. Waziristan ****************************************************
**********************************************************************************************************
 foreach p in incident lethty eldatk{
use JohnstonSarbahiDroneMasterData, replace

keep if year>2006
xtset id week
qui tab week, g (week)
keep if id==120594
**** This is for 2007 to 2011
**** UAV measure is binary
**** FE w/time var & id & SP Lags
display as error "The DEPENDENT VARIABLE IS `p'"
dis as text "FE w/time var & id, DV & SP Lags"
qui reg `p'_a100k uav_a `p'_n75_100k, robust
est table, keep(uav_a _cons) se p t stats(r2)
estat ic
}

log close

* Have an A1 day! 

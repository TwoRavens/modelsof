/* 
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
DO-FILE DESCRIPTION

Jeroen Sabbe, last updated 19 May 10
last updated 9 Jan 17

This do-file takes the uccgroups file (containing approx 100 detailed commodity groups) and aggregates all the appropriate
commodity groups to aggregated expenditure groups

Input: 
uccgroups`yearshort'.dta: contains expenditures on certain commodity groups (=sum of relevant UCC codes), but still at a very disaggregate level.
Eg variable "alcohome" contains UCCs beer at home+wine at home+whisky at home+other alco beverages at home 
(assumed stored at location specified in local "outputpath")

Outputs:
exp3comm`yearshort'.dta: contains expenditures on aggregated expenditure groups

--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
*/

clear
*-------------------------------USER INPUT!!!------------------------------------
set mem 50m
set maxvar 32767
local yearlong = "2003"		// USER INPUT!! Year must contain exactly 4 digits (eg "2005")
local yearshort=substr("`yearlong'",3,2)
local inputpath C:/CodesPublishedVersion/CEX3/DIARY`yearshort'
local outputpath C:/CodesPublishedVersion/CEX3/`yearlong'

* -------------------------------
* Generate the commodity groups
* -------------------------------
cd `inputpath'
use uccgroups`yearshort'.dta
cd `outputpath'
save exp3comm`yearshort'.dta, replace

* FOOD (=food and nonalcoholic beverages)
gen food=cereal+bakery+beef+pork+othmeat+poultry+seafood+eggs+milkprod+othdairy+frshfrut+frshveg+procfrut+procveg+sweets+fatoils+nonalbev+prepared+snacks+condiments
* we only consider food consumed at home, we do not consider foodaway!

* NONDURABLES
gen nond=alcohome+alcoaway+tobacco+clothmen+clothboy+clothwom+clothgrl+clothinf+clothmake+clothacc+footwear+reading+stationery+schoolsupp+cleanprod+gardensupp+hhtextil+ndhousware+medical+perscare+audvis+recreagoods+petgoods+vehexp

*SERVICES
gen serv=utilities+mediabills+repair+insurance+postal+gasoline+vehexp+pubtrans+medcarsrv+perscarsrv+recreat+homeserv+rentalserv+membshfees+schoolfees+othfees+petserv+careserv

/*
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
NOTE: we only focus on a very restricted set of commodities! So we do NOT look at these uccgroups:
FINANCIAL ASSETS: capitimp, investsave
GIFTS & FORCED PAYMENTS: gifts, alimony
HOUSING: mortgage, propbuy, improvwork, improvmat, rent, lodging
TAXES (except indirect tax which is included in the commodity prices) & HEALTH INSURANCE: proptax, cartax, healthins
APPLIANCES: hhappl, mediaappl
EQUIPMENT: homeequip, grdnequip, cleanequip, medequip, diyequip, recreaeqp, othequip
OTHER DURABLE CONSUMER GOODS: furniture, homedeco, dinnerware
VEHICLE PURCHASES: vehicles
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
*/


* ------------------------------------------------------------------------
* convert to yearly data + generate total expenditure + expenditure shares
* ------------------------------------------------------------------------
local commlist "food nond serv"
local sharelist "foodshare nondshare servshare"

foreach comm of local commlist{
replace `comm'=`comm'*26 			// calc YEARLY expenditures per commodity: from 2-week expenditures to 52-week expenditures
}

egen totexp=rowtotal(`commlist')	// calc total yearly expenditures for the selected commodities

foreach comm of local commlist{
gen `comm'share=`comm'/totexp		// calc share of each commodity
}

* -----------------------------------
* KEEP NEEDED VARs AND SAVE
* -----------------------------------
keep cuid `commlist' totexp `sharelist'
order cuid `commlist' totexp `sharelist'
save exp3comm`yearshort', replace

*log close

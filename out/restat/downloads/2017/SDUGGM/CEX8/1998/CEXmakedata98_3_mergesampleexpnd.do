/* 
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
DO-FILE DESCRIPTION

Jeroen Sabbe, last updated 19 May 10
last updated 10 Jan 17

This do-file merges the fmlydsample file and the exp8comm file: it links the household characteristics to the expenditure data.
Next, data are deseasonalised to eliminate seasonal effects due to the very short diary period (2 weeks)

Inputs: 
fmlydsample`yearshort'.dta and exp8comm`yearshort'.dta
(assumed stored at location specified in local "inputpath")

Output:
CEX`yearshort'`hhtype'.dta: one file for each year and for each hhtype (sing, coup, fam)

--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
*/


clear
*-------------------------------USER INPUT!!!------------------------------------
local yearlong = "1998"		// USER INPUT!! Year must contain exactly 4 digits (eg "2005")
local yearshort=substr("`yearlong'",3,2)
local inputpath C:/CodesPublishedVersion/CEX8/`yearlong'
local outputpath C:/CodesPublishedVersion/CEX8/`yearlong'

local hhtypelist "fam"
local commlist "foodhome foodaway vices clothing hhenergy gasoline nondur serv"
local sharelist "foodhomeshare foodawayshare vicesshare clothingshare hhenergyshare gasolineshare nondurshare servshare"
local dscommlist "dsfoodhome dsfoodaway dsvices dsclothing dshhenergy dsgasoline dsnondur dsserv"

foreach hhtype of local hhtypelist{
* -----------------------------------
* Merge fmlydsample and exp8comm data
* -----------------------------------
cd `inputpath'
use mergemembd`yearshort'`hhtype'.dta, clear
merge cuid using exp8comm`yearshort', sort
keep if _merge==3

* -------------
* Deseasonalize
* -------------
foreach comm of local commlist{
gen ds`comm'=.		// will contain yearly deseasonalised expenditures
xi: reg `comm' i.strtmnth
predict r, resid
egen mean`comm'=mean(`comm')
replace ds`comm'=r+mean`comm'		//dsfood = deseasonalised food
replace ds`comm'=0 if ds`comm'<0
drop r
}
egen dstotexp=rowtotal(`dscommlist')	// calc total yearly deseasonalised expenditures
foreach comm of local commlist{
gen ds`comm'share=ds`comm'/dstotexp		// calc share of each commodity
}
drop _I*

drop `commlist' totexp mean* backup `sharelist'	// we only move on with deseasonalised data
order cuid dsfoodhome dsfoodaway dsvices dsclothing dshhenergy dsgasoline dsnondur dsserv dstotexp

count if dsfoodhome<=0
count if dsfoodaway<=0
count if dsvices<=0
count if dsclothing<=0
count if dshhenergy<=0
count if dsgasoline<=0
count if dsnondur<=0
count if dsserv<=0

count
drop if dsfoodhome<=0
count
drop if dsfoodaway<=0
count
drop if dsvices<=0
count
drop if dsclothing<=0
count
drop if dshhenergy<=0
count
drop if dsgasoline<=0
count
drop if dsnondur<=0
count
drop if dsserv<=0
count
drop if dstotexp<=0
count

drop _merge strtmnth refpersonwage spousewage ds*share



cd `outputpath'
save CEX`yearshort'`hhtype'.dta, replace	// this is the file that should be used as an input for the Matlab m-files
outfile using CEX`yearshort'`hhtype'.txt,w replace

}

*log close

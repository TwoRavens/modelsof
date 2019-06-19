/* 
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
DO-FILE DESCRIPTION

Jeroen Sabbe, last updated 19 May 10
last updated 9 Jan 17

This do-file merges the fmlydsample file and the exp3comm file: it links the household characteristics to the expenditure data.
Next, data are deseasonalised to eliminate seasonal effects due to the very short diary period (2 weeks)

Inputs: 
fmlydsample`yearshort'.dta and exp3comm`yearshort'.dta
(assumed stored at location specified in local "inputpath")

Output:
CEX`yearshort'`hhtype'.dta: one file for each year and for each hhtype (sing, coup, fam)

--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
*/


clear
*-------------------------------USER INPUT!!!------------------------------------
local yearlong = "2007"		// USER INPUT!! Year must contain exactly 4 digits (eg "2005")
local yearshort=substr("`yearlong'",3,2)
local inputpath C:/CodesPublishedVersion/CEX3/`yearlong'
local outputpath C:/CodesPublishedVersion/CEX3/`yearlong'

local hhtypelist "fam"
local commlist "food nond serv"
local sharelist "foodshare nondshare servshare"
local dscommlist "dsfood dsnond dsserv"

foreach hhtype of local hhtypelist{
* -----------------------------------
* Merge fmlydsample and exp3comm data
* -----------------------------------
cd `inputpath'
use mergemembd`yearshort'`hhtype'.dta, clear
merge cuid using exp3comm`yearshort', sort
keep if _merge==3

* -------------
* Deseasonalize
* -------------

foreach comm of local commlist{
gen ds`comm'=.		// will contain yearly deseasonalised expenditures
xi: reg `comm' i.strtmnth
predict r, residuals
egen mean`comm'=mean(`comm')
replace ds`comm'=mean`comm'+r		//eg dsfood = deseasonalised food
replace ds`comm'=0 if ds`comm'<0
*drop if ds`comm'<0
count
drop r
}
egen dstotexp=rowtotal(`dscommlist')	// calc total yearly deseasonalised expenditures
foreach comm of local commlist{
gen ds`comm'share=ds`comm'/dstotexp		// calc share of each commodity
}
drop _I*

drop `commlist' `sharelist'	mean* totexp // we only move on with deseasonalised data
drop _merge strtmnth refpersonwage spousewage ds*share
order cuid dsfood dsnond dsserv dstotexp

cd `outputpath'
save CEX`yearshort'`hhtype'.dta, replace	// this is the file that should be used as an input for the Matlab m-files
outfile using CEX`yearshort'`hhtype'.txt,w replace

}

*log close

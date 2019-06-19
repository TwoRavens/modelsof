/* 
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
DO-FILE DESCRIPTION

Jeroen Sabbe, last updated 19 May 10
last updated 10 Jan 17

This do-file merges the fmlydsample file and the exp3comm file: it links the household characteristics to the expenditure data.
This data set is not deseasonalised

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
local yearlong = "1998"		// USER INPUT!! Year must contain exactly 4 digits (eg "2005")
local yearshort=substr("`yearlong'",3,2)
local inputpath C:/CodesPublishedVersion/CEX3/`yearlong'
local outputpath C:/CodesPublishedVersion/CEX3seas/`yearlong'

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

*Graphs to show effects of deseasonalising on mean exp per month and on mean share per month
*------------------------------------
foreach comm of local commlist{
bysort strtmnth: egen month`comm'=mean(`comm')
bysort strtmnth: egen dsmonth`comm'=mean(ds`comm')
}
bysort strtmnth: egen monthtotexp=mean(totexp)
bysort strtmnth: egen dsmonthtotexp=mean(dstotexp)
sort strtmnth

line monthtotexp dsmonthtotexp strtmnth
graph save graphCEX`yearshort'`hhtype'totexp, replace

line monthfood dsmonthfood monthnond dsmonthnond monthserv dsmonthserv strtmnth
graph save graphCEX`yearshort'`hhtype', replace

foreach comm of local commlist{
bysort strtmnth: egen month`comm'share=mean(`comm'share)
bysort strtmnth: egen dsmonth`comm'share=mean(ds`comm'share)
}
sort strtmnth
line monthfoodshare dsmonthfoodshare monthnondshare dsmonthnondshare monthservshare dsmonthservshare strtmnth
graph save graphCEX`yearshort'`hhtype'shares, replace

drop month* dsmonth*

drop ds* mean* `sharelist'	// we only move on with nondeseasonalised data
drop _merge strtmnth refpersonwage spousewage

order cuid `commlist' totexp
drop if totexp<=0
*order cuid dsfood dsnond dsserv dstotexp
*drop if dstotexp<=0

cd `outputpath'
save CEX`yearshort'`hhtype'.dta, replace	// this is the file that should be used as an input for the Matlab m-files
outfile using CEX`yearshort'`hhtype'.txt,w replace

}

*log close

clear
*-------------------------------USER INPUT!!!------------------------------------
set mem 50m
set maxvar 32767
local yearlong = "1999"		// USER INPUT!! Year must contain exactly 4 digits (eg "2005")
local yearshort=substr("`yearlong'",3,2)
local inputpath C:/CodesPublishedVersion/CEX8/DIARY`yearshort'
local outputpath C:/CodesPublishedVersion/CEX8/`yearlong'

* -------------------------------------------------------------------
* Make fmlydsample`yearshort', the file that will contain the restricted sample
* -------------------------------------------------------------------
local hhtypelist "fam"

foreach hhtype of local hhtypelist{

cd `inputpath'
use membd`yearshort'

drop if newid/2==(int(newid/2)) // rely on first week data
gen cuid=int(newid/10)	// in the early years of CEX, the variable cuid did not exist so we need to create it.

cd `outputpath'
save membdcuid`yearshort'`hhtype'.dta, replace
use membdcuid`yearshort'`hhtype'.dta
}

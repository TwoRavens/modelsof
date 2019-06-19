clear
*-------------------------------USER INPUT!!!------------------------------------
local yearlong = "1999"		// USER INPUT!! Year must contain exactly 4 digits (eg "2005")
local yearshort=substr("`yearlong'",3,2)
local inputpath C:/CodesPublishedVersion/CEX3/`yearlong'
local outputpath C:/CodesPublishedVersion/CEX3/`yearlong'

local hhtypelist "fam"

foreach hhtype of local hhtypelist{
* -----------------------------------
* Merge fmlydsample and membd data
* -----------------------------------
cd `inputpath'
use fmlydsample`yearshort'`hhtype'.dta, clear

merge 1:m cuid using membdcuid`yearshort'`hhtype', keepusing(age wagex cu_code1) force 
keep if _merge==3

drop _merge 

sort cuid

bysort cuid: gen count=_n
bysort cuid: gen backup=_N

reshape wide age cu_code1 wagex, i(cuid) j(count)

sum backup
local top=r(max)
numlist "1/`top'"

local samlist `r(numlist)'

gen children=0
gen adults=0
gen refpersonwage=wagex1 if cu_code11=="1"
gen spousewage=wagex1 if cu_code11=="2"

foreach type of local samlist{
replace children=children+1 if age`type'<14 & missing(age`type')==0
replace adults=adults+1 if age`type'>=14 & missing(age`type')==0
replace refpersonwage=wagex`type' if cu_code1`type'=="1"
replace spousewage=wagex`type' if cu_code1`type'=="2"
drop age`type' wagex`type' cu_code1`type'
}

sort cuid

cd `outputpath'
save mergemembd`yearshort'`hhtype'.dta, replace	// this is the file that should be used as an input for the Matlab m-files
outfile using mergemembd`yearshort'`hhtype'.txt,w replace
}
*log close

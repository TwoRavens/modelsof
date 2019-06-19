/* ImportNYMEXtxt.do */
/* This imports the NYMEX txt data from www.price-data.com */
/* Hunt Allcott. 6-30-2009 */

** Get Month name
* F G H J K M N Q U V X Z
if `m'==1 {
local fm="F"
}
if `m'==2 {
local fm="G"
}
if `m'==3 {
local fm="H"
}
if `m'==4 {
local fm="J"
}
if `m'==5 {
local fm="K"
}
if `m'==6 {
local fm="M"
}
if `m'==7 {
local fm="N"
}
if `m'==8 {
local fm="Q"
}
if `m'==9 {
local fm="U"
}
if `m'==10 {
local fm="V"
}
if `m'==11 {
local fm="X"
}
if `m'==12 {
local fm="Z"
}

	if `y' > 9 {
	insheet using Data/OilFutures/NYMEX/CL`y'`fm'.txt,clear
	if `y'<50 {
	gen fYear = 20`y'
	}
	if `y'>50 {
	gen fYear = 19`y'
	}
	}
	if `y'<=9 {
	insheet using Data/OilFutures/NYMEX/CL0`y'`fm'.txt,clear
	gen fYear = 200`y'	
	}
	gen Month = real(substr(date,1,2))
	gen day = real(substr(date,4,2))
	gen Year = real(substr(date,7,4))
	gen fMonth=`m'
	rename close fprice_ny
	keep Month day Year fYear fMonth fprice_ny
	append using Data/OilFutures/NYMEX/NYMEXData.dta
	save Data/OilFutures/NYMEX/NYMEXData.dta, replace
	


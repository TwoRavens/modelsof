set more off
pause off

local ph0 "C:\RESTAT\"
local hs88hs02 "`ph0'hs88hs02"
cd "`ph0'"



#delimit ;
global ppp "
AFG
AGO
ALB
ARE
ARG
ARM
ATG
AUS
AZE
BDI
BEN
BFA
BGD
BHR
BHS
BIH
BLR
BLZ
BMU
BOL
BRA
BRB
BRN
BTN
BWA
CAF
CAN
CHE
CHL
CHN
CIV
CMR
COD
COG
COL
COM
CPV
CRI
CUB
DJI
DMA
DOM
DZA
ECU
EGY
ETH
FJI
GAB
GEO
GHA
GIN
GMB
GNB
GNQ
GRD
GTM
GUY
HKG
HND
HRV
HTI
IDN
IND
IRN
ISL
ISR
JOR
JPN
KAZ
KEN
KGZ
KHM
KNA
KOR
KOS
KWT
LAO
LBN
LCA
LKA
LSO
MAC
MAR
MDA
MDG
MDV
MEX
MKD
MLI
MMR
MNE
MNG
MOZ
MRT
MUS
MWI
MYS
MYT
NAM
NER
NGA
NIC
NOR
NPL
NZL
OMN
PAK
PAN
PER
PHL
PNG
PRY
PYF
QAT
RUS
RWA
SAU
SDN
SER
SEN
SGP
SLB
SLV
SUR
SWZ
SYC
SYR
TCD
TGO
TON
TTO
TUN
TUR
TWN
TZA
UGA
UKR
URY
USA
UZB
VCT
VEN
VNM
VUT
YEM
ZAF
ZMB
ZWE
";

#delimit cr
foreach p of global ppp {

clear
set obs 1
gen year=.
cap append using "tar_`p'_2007.dta"
cap append using "tar_`p'_2008.dta"
cap append using "tar_`p'_2009.dta"
display "***************************************************************************`p'"
*CONVERT HS 2002 CODE TO HS88
rename hs6 hs02 
sort hs02
merge hs02 using `hs88hs02'
tab _m 
keep if _m==3
drop _m
drop hs02 
rename hs88 hs6
collapse  totarif, by( ccode pcode year hs6 reporter partner)
order  ccode pcode hs6 year totarif
tab year
display "missing pcodes inherited from original ITC files"
drop if pcode==""
gen MFN=.
gen yrtrf=year
replace year=2008 if year==2007
cap append using "mfn2_`p'.dta"
display "no changes made would suggest mfn file is empty"
replace partner=0 if pcode==""
gen totarif2=totarif
replace totarif2=MFN if pcode==""
replace yrtr=year if pcode==""
replace pcode="WLD" if pcode==""
display "check duplicates in tariff files"
sort year ccode pcode hs6
qui by  year ccode pcode hs6: gen check=_N
tab check
drop check MFN
tab year
gen a=year if pcode~="WLD"
egen min=min(a)
egen max=max(a)
drop a
egen a=rmean(min max)
drop min max

gen b=year if pcode=="WLD"
egen min=min(b)
egen max=max(b)
drop b
egen b=rmean(min max)
drop min max

drop if year==.
sort year ccode pcode hs6
preserve

clear 
set obs 1
gen year=.
gen ccode=""
gen pcode=""
gen hs6=""
gen trade=.
cap append using "trade_`p'.dta"
drop if pcode=="EUN"
sort year ccode pcode hs6 
save tempH0, replace

restore
merge year ccode pcode hs6 using tempH0
tab _m
drop if _m==1
egen var=mean(trade)
if var==. {
		
		drop reporter partner a _m var
		save "TT_`p'.dta", replace	
}
else {
drop if year==.
drop if trade==.
display "delete trade in year for which tariffs are not available"
egen c=mean(a)
egen d=mean(b)
drop if _m==2&year~=c&c~=2008.5&pcode~="WLD"
drop if _m==2&year~=d&d~=2008.5&pcode=="WLD"
drop a b c d var
drop reporter partner
display "drop if pcode==ccode"
drop if pcode==ccode
drop _m
display "drop if pcode is European Union"
drop if pcode=="EUN"
display "veryify existence of duplicates"
sort  ccode pcode hs6 year
qui by  ccode pcode hs6 year: gen check=_N
tab check
drop check 
save "TT_`p'.dta", replace
}

}

erase tempH0.dta


************ THE CASE OF EUN

use "tar_EUN_2008.dta", clear
append using "tar_EUN_2009.dta"
*CONVERT HS 2002 CODE TO HS88
rename hs6 hs02 
sort hs02
merge hs02 using `hs88hs02'
tab _m 
keep if _m==3
drop _m
drop hs02 
rename hs88 hs6
collapse  totarif, by( ccode pcode year hs6 reporter partner)
order  ccode pcode hs6 year totarif
tab year
display "missing pcodes inherited from original ITC files"
drop if pcode==""
gen MFN=.
gen yrtrf=year
replace year=2008 if year==2007
cap append using "mfn2_EUN.dta"
display "no changes made would suggest mfn file is empty"
replace partner=0 if pcode==""
gen totarif2=totarif
replace totarif2=MFN if pcode==""
replace yrtr=year if pcode==""
replace pcode="WLD" if pcode==""
display "check duplicates in tariff files"
sort year ccode pcode hs6
qui by  year ccode pcode hs6: gen check=_N
tab check
drop check MFN
tab year
gen a=year if pcode~="WLD"
egen min=min(a)
egen max=max(a)
drop a
egen a=rmean(min max)
drop min max

gen b=year if pcode=="WLD"
egen min=min(b)
egen max=max(b)
drop b
egen b=rmean(min max)
drop min max

drop if year==.
sort year ccode pcode hs6
save tempH0, replace

clear
set obs 1
gen year=.
save "TT_EUN.dta", replace

*****************************

#delimit ;
global ppp "
AUT
BEL  
DEU 
DNK 
ESP 
FIN 
FRA
GBR 
GRC
IRL 
ITA 
NLD 
PRT 
SWE
CZE
POL
HUN
SVK
ROM
BGR
SVN
CYP
EST
LVA
LTU
MLT
LUX
";
#delimit cr
foreach p of global ppp {

use "trade_`p'.dta"
display "***************************************************************************`p'"
rename ccode ccodeold
gen ccode="EUN"
sort year ccode pcode hs6
merge year ccode pcode hs6 using tempH0
tab _m
drop if _m==2
drop if trade==.

gen y =0
replace y=1 if pcode=="AUT"
replace y=1 if pcode=="BEL"
replace y=1 if pcode=="BLX"
replace y=1 if pcode=="DEU" 
replace y=1 if pcode=="DNK" 
replace y=1 if pcode=="ESP" 
replace y=1 if pcode=="FIN" 
replace y=1 if pcode=="FRA" 
replace y=1 if pcode=="GBR" 
replace y=1 if pcode=="GRC" 
replace y=1 if pcode=="IRL" 
replace y=1 if pcode=="ITA" 
replace y=1 if pcode=="NLD" 
replace y=1 if pcode=="PRT" 
replace y=1 if pcode=="SWE"
replace y=1 if pcode=="CZE"
replace y=1 if pcode=="POL"
replace y=1 if pcode=="HUN"
replace y=1 if pcode=="SVK"
replace y=1 if pcode=="ROM"
replace y=1 if pcode=="BGR"
replace y=1 if pcode=="SVN"
replace y=1 if pcode=="CYP"
replace y=1 if pcode=="EST"
replace y=1 if pcode=="LVA"
replace y=1 if pcode=="LTU"
replace y=1 if pcode=="MLT"
replace y=1 if pcode=="LUX"

************************************MAKE SURE INTRA_EU TARIFFS ARE 0 
tab _m if y==1
sum totarif totarif2 if y==1
replace totarif=0 if y==1
replace totarif2=0 if y==1


display "delete trade in year for which tariffs are not available"
egen c=mean(a)
egen d=mean(b)
drop if _m==1&year~=c&c~=2008.5&pcode~="WLD"
drop if _m==1&year~=d&d~=2008.5&pcode=="WLD"
drop a b c d 
drop reporter partner

display "drop if pcode==ccode"
drop if pcode==ccode
drop _m
display "drop if pcode is European Union"
drop if pcode=="EUN"
display "veryify existence of duplicates"
sort  ccode pcode hs6 year
qui by  ccode pcode hs6 year: gen check=_N
tab check
drop check 

append using "TT_EUN.dta"
save "TT_EUN.dta", replace

}

use "TT_EUN.dta", clear
drop if year==.
******************************DROP INTRA-EU TRADE
drop if y==1
drop y ccode
rename ccodeold ccode
sort ccode
save "TT_EUN.dta", replace

erase tempH0.dta

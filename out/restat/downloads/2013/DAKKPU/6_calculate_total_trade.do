set more off
pause off

cd "C:\RESTAT"

clear
set obs 1
gen year=.
save temp, replace


clear
set obs 1
gen year=.
save "total trade.dta", replace


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
EUN
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

use temp, clear
cap append using "trade_`p'.dta"
egen test=mean(year)
display "***************************************************************************`p'"
if test==. {
	display "*********************************************no trade data"	
}
else {
keep if year==2008
drop test
gen wld_dummy=(pcode=="WLD")
collapse  (sum) trade, by(ccode wld_dummy year)
sort ccode year wld_dummy
append using "total trade.dta", 
save "total trade.dta", replace
}
}



use "TT_EUN.dta", clear
replace ccode="EUN"
keep if year==2008
gen wld_dummy=(pcode=="WLD")
collapse  (sum) trade, by(ccode wld_dummy year)
replace ccode="EUNtest"
sort ccode year wld_dummy
append using "total trade.dta", 
save "total trade.dta", replace


use "total trade.dta", clear
drop if ccode==""
drop year
reshape wide trade, i(ccode) j(wld_dummy)
rename trade1 MFNtrade
rename trade0 BILtrade
sort ccode
save "total trade.dta", replace

erase temp.dta




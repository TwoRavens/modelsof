
clear
set mem 3000000

set more off
pause off

local ph0 "C:\RESTAT\"
local SA "SA.dta"
local countrynames "countrynames"
tempfile temp1 
tempfile temp2
tempfile SA_MFN
tempfile SA_BIL

cd `ph0'


********************
*MFN
********************

clear
set obs 1
gen year=.
save `SA_MFN', replace


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
BIH
BLR
BLZ
BMU
BOL
BRA
BRN
BWA
CAN
CHE
CHL
CHN
CIV
CMR
COD
COL
COM
CPV
CRI
CUB
DJI
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
GRD
GTM
GUY
HKG
HND
HRV
HTI
IND
IRN
ISL
ISR
JPN
KAZ
KEN
KGZ
KNA
KOR
KOS
KWT
LAO
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
MNE
MNG
MUS
MWI
MYS
MYT
NAM
NER
NGA
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
SEN
SER
SGP
SLB
SLV
SUR
SWZ
TGO
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
VEN
VUT
ZAF
ZMB
ZWE
";

#delimit cr
foreach p of global ppp {
display "**************** country `p' *****"
use mfn_`p'.dta, clear
append using `SA_MFN'
save `SA_MFN', replace
}

use `SA_MFN', clear
drop if year==.

rename MFN mfn

keep rev ccode year mfn ntlc 
reshape wide rev mfn, i(ccode ntlc) j(year)

gen a=( rev2008== rev2009)
replace a=1 if  rev2008==""| rev2009==""
tab ccode if a==0
egen b=mean(a), by(ccode)
tab ccode if b~=1
drop if b~=1
drop a b  rev2008 rev2009

rename mfn2008 mfnsa2008
rename mfn2009 mfnsa2009
collapse mfnsa2008 mfnsa2009, by(ccode)
sort ccode
save `SA_MFN', replace

********************
*BILATERAL 
********************


clear
set obs 1
gen year=.
save `SA_BIL', replace


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

clear
set obs 1
gen year=.
cap append using "tar_`p'_2007.dta"
cap append using "tar_`p'_2008.dta"
cap append using "tar_`p'_2009.dta"
display "***************************************************************************`p'"
drop reporter partner
drop if year==.
collapse totarif, by(ccode year)
reshape wide totarif, i(ccode) j(year)
cap gen totarif2007=.
cap gen totarif2008=.
cap gen totarif2009=.
rename totarif2007 bilsa2007
rename totarif2008 bilsa2008
rename totarif2009 bilsa2009
sort ccode
append using `SA_BIL'
save `SA_BIL', replace
}


use `SA_BIL', clear
drop if ccode==""
drop year
order  ccode bilsa2007 bilsa2008 bilsa2009 
sort ccode
save `SA_BIL', replace

use `SA_BIL', clear
merge ccode using `SA_MFN'
tab _m
drop _m
replace ccode="ZAF" if ccode=="SAF"
replace ccode="SER" if ccode=="SRB"
sort ccode
merge ccode using `countrynames'
tab _m
keep if _m==3
drop _m  
order ccode name
sort ccode
save `SA', replace












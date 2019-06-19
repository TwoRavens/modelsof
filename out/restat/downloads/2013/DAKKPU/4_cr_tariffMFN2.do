set more off
pause off

cd "C:\RESTAT\"

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
		use mfn_`p'.dta, clear
		drop if flag==1
		if ccode=="IND"|ccode=="JPN" {
		collapse MFN, by(ccode hs6 hs88 year)
		}
		else {
		}
		drop hs6
		rename hs88 hs6
		collapse MFN, by(year ccode hs6)
		save "mfn2_`p'.dta",replace
		}
	


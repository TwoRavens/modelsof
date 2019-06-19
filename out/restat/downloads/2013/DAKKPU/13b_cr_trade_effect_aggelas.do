set more off
pause off

local ph0 "C:\RESTAT\"
local Elast_data_shaped "`ph0'Elast_data_shaped"

cd `ph0'


clear
set obs 1
gen year=.
save "TRADE EFFECT_AE.dta", replace


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

use "TT_`p'.dta", clear
display "***************************************************************************`p'"
drop if year==.
if ccode=="" {
	display "*********************************************no data"	
}
else {
sort ccode hs6
tab  year yrtrf
tab year
egen a=mean(yrtrf), by(year)
replace yrtrf=a if yrtrf==.
drop a
tab  year yrtrf
sum

sort ccode hs6
merge ccode hs6 using `Elast_data_shaped'
display "********************************************************ELASTICITY AVAILABLE IF _M==3*
tab _m
egen xx=mean( meanelas), by (hs6 )
replace  OK_elas_fit=xx if  OK_elas_fit==.
drop if _merge==2
replace OK_elas_fit=-3 if OK_elas_fit==.
drop if trade==.
drop  xx _merge meanelas 
sort ccode year
ren  OK_elas_fit elas
gen wld_dummy=0
replace wld_dummy=1 if pcode=="WLD"

gen t=totarif
replace t=totarif2 if pcode=="WLD"

gen t2=t
replace t2=0.000001 if t2==0
egen sx=sum(t2), by(ccode year wld_dummy)
drop if sx==0
drop t2 sx


display "*********************************************COUNT OF MISSING TARIFF RELATIVE TO AVAILABLE DATA***************************
tab ccode
tab ccode if t==.

egen tt=rsum(t)

drop  totarif totarif2  yrtrf yrtr t

drop if tt==.
drop if elas==.

egen max=max(year)
egen min=min(year)
if min==max {
		gen a=1
		collapse a, by(ccode)
		drop a
		gen wld_dummy=0
		gen sector="AG" 
		save temp, replace
		replace sector="MF"
		append using temp
		save temp, replace
}
else {
reshape wide  tt elas trade, i( ccode pcode hs6 wld_dummy) j(year)
drop  trade2009
rename  trade2008 trade
drop elas2009
rename elas2008 elas
gen effect=( tt2009- tt2008)* trade* elas
replace effect=-trade  if  effect<- trade

*COMMAND FOR THE EUN FILE
tab ccode
gen var="`p'"
replace ccode="EUN" if var=="EUN"
tab ccode
drop var

gen sector="AG"
replace sector="MF" if hs6>"249999"

collapse (sum)  effect, by( ccode wld_dummy sector)
}
append using "TRADE EFFECT_AE.dta"
save "TRADE EFFECT_AE.dta", replace
}
}

use "TRADE EFFECT_AE.dta", clear
drop if ccode==""
drop year
save temp2, replace
collapse (sum) effect, by(ccode wld_dummy)
gen sector="ALL"
append using temp2
reshape wide effect, i(ccode sector) j(wld_dummy)
rename effect0 BILeffect
rename effect1 MFNeffect
gen order=1 if sector=="ALL"
replace order =2 if sector=="MF"
replace order =3 if sector=="AG"
sort order ccode
save "TRADE EFFECT_AE.dta", replace

erase temp.dta
erase temp2.dta

set more off
pause off

cd "C:\RESTAT\"

clear
set obs 1
gen year=.
save "TRADEEFFECT", replace


#delimit ;
global ppp "
ARG
AUS
BRA
CAN
CHL
CHN
COL
EUN
IDN
IND
JPN
MEX
PER
TUR
USA
";

#delimit cr
foreach p of global ppp {

use "temp3`p'.dta", clear
display "**********************************************************************************`p'"
	gen year=2009
	order year ccode pcode  hs88  duty trade
	rename  duty ADduty
	rename trade trade2
	tab yrtr
	drop  nomencode yrtr hs_digits case_id 
	sort ccode pcode year hs6 hs_code hs88
	qui by ccode pcode year hs6 hs_code hs88: gen check=_N
	display "*************************************************duplicate trade"
	tab check
	drop check
	gen sector="AG"
	replace sector="MF" if hs6>"249999"
	replace sector="" if hs6==""
	collapse   ADduty trade2, by(ccode pcode year hs6 hs_code hs88 sector)
	preserve
	
	egen tradeeffect=sum(trade), by(sector)
	collapse tradeeffect, by(ccode sector)
	gen var="all"
	sort ccode
	append using "TRADEEFFECT"
	save "TRADEEFFECT", replace

	restore
	drop hs6
	display "*************************************************drop if hs88==""***********"
	drop if hs88==""
	rename hs88 hs6
	drop sector
	gen sector="AG"
	replace sector="MF" if hs6>"249999"
	replace sector="" if hs6==""
	preserve
	
	egen tradeeffect=sum(trade), by(sector)
	collapse tradeeffect, by(ccode sector)
	gen var="H0"
	sort ccode
	append using "TRADEEFFECT"
	save "TRADEEFFECT", replace
	
	restore
	drop sector
	sort ccode pcode year hs6 
	qui by ccode pcode year hs6: gen check=_N
	tab check
	drop check
	collapse   ADduty (sum)  trade2, by(ccode pcode year hs6)
	replace ADduty=ADduty/100
	replace trade2=trade2/1000
	sort ccode pcode hs6
	preserve

	use "trade_`p'.dta", clear
	keep if year==2008
	tab yrtr 
	keep  ccode pcode hs6 trade
	sort ccode pcode hs6
	save temp, replace

	restore
	merge ccode pcode hs6 using temp
	tab _m
	drop if _m==2
	drop _m
	gen trade1=trade-trade2
	sum trade1
	replace trade1=0 if trade1<0
	drop trade
	gen flag2=1 if ccode=="ARG"
	replace flag2=1 if ccode=="BRA"
	replace flag2=1 if ccode=="IND"
	replace flag2=1 if ccode=="TUR"
	drop if ADduty==.&flag2==.
	reshape long trade, i( year ccode pcode hs6 ADduty flag2) j(flag)
	replace  ADduty=. if   flag==1
	rename trade trade2
	sort ccode pcode year hs6 
	save "final`p'", replace
}

	use "TRADEEFFECT", clear
	collapse (sum) tradeeffect, by(ccode var)
	gen sector="ALL"
	append using "TRADEEFFECT"
	drop year
	drop if ccode==""
	reshape wide  tradeeffect, i(ccode sector) j(var) s
	gen a=( tradeeffectH0== tradeeffectall)
	tab ccode if a==1	
	drop a
	rename tradeeffectall tradeeffect
	drop if sector==""
	sort ccode sector
	save "TRADEEFFECT", replace


clear
set obs 1
gen ccode="EUN"
gen varAUT=1
gen varBEL=1
gen varDEU=1 
gen varDNK=1 
gen varESP=1 
gen varFIN=1 
gen varFRA=1
gen varGBR=1 
gen varGRC=1
gen varIRL=1 
gen varITA=1 
gen varNLD=1
gen varPRT=1 
gen varSWE=1
gen varCZE=1
gen varPOL=1
gen varHUN=1
gen varSVK=1
gen varROM=1
gen varBGR=1
gen varSVN=1
gen varCYP=1
gen varEST=1
gen varLVA=1
gen varLTU=1
gen varMLT=1
gen varLUX=1
sort ccode
save temp, replace

use "finalEUN.dta", clear
sort ccode
tab ccode
merge ccode using temp
tab _m
drop _m
reshape long var, i( year ccode  pcode hs6 ADduty trade2 flag2) j(test) s
drop ccode
replace trade2=trade2/27
rename test ccode
drop var
order year ccode
sort ccode pcode year hs6 
save "finalEUN", replace



erase temp.dta

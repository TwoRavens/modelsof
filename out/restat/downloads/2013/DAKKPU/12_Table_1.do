set more off
pause off

cd "C:\RESTAT\"

clear
set obs 1
gen year=.
save "TRADEEFFECT2", replace


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
	
	gen duty=(ADduty~=.)	
	egen tradeeffect=sum(trade), by(sector duty)
	collapse tradeeffect, by(ccode sector duty)
	gen var="all"
	sort ccode
	append using "TRADEEFFECT2"
	save "TRADEEFFECT2", replace

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
	
	gen duty=(ADduty~=.)	
	egen tradeeffect=sum(trade), by(sector duty)
	collapse tradeeffect, by(ccode sector duty)
	gen var="H0"
	sort ccode
	append using "TRADEEFFECT2"
	save "TRADEEFFECT2", replace
	
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
	*save "final`p'", replace
}

	use "TRADEEFFECT2", clear
	collapse (sum) tradeeffect, by(ccode sector var)
	gen duty=2
	append using "TRADEEFFECT2"
	drop year
	drop if ccode==""
	drop if duty==0
	save "TRADEEFFECT2", replace
	collapse (sum) tradeeffect, by(ccode var duty)
	gen sector="ALL"
	append using "TRADEEFFECT2"
	reshape wide  tradeeffect, i(ccode sector var) j(duty) 
	gen coverage=tradeeffect1/tradeeffect2
	reshape wide  tradeeffect1 tradeeffect2 coverage, i(ccode sector) j(var) s
	gen a=( tradeeffect1H0== tradeeffect1all)
	tab ccode if a==1	
	drop a
	*rename tradeeffectall tradeeffect
	keep ccode sector tradeeffect2H0 coverageH0
	keep if sector=="ALL"
	sort ccode sector
	save "TRADEEFFECT2", replace



erase temp.dta


set more off
local sub0 "Period before votes in press release"
local sub1 "Period with votes in press release"

use "$path3\T2pm_dissent.dta", clear //use "$path_d\bloomberg2_dissent.dta", clear //use "$path_d\bloomberg1_dissent.dta", clear
g period = 1 if year>2002  //SP_open SP_high SP_low SP_close
replace period = 1 if year==2002 & month>=2
replace period = 2 if year>2007
replace period = 2 if year==2007 & month>=3
replace period = 3 if year>2009
replace period = 3 if year==2009 & month>=7
replace period = 0 if period==.
joinby date_day using "$path1\bloomberg2_reduced.dta", unmatched(master) update // unmatched(both) update
tab _merge
drop _merge 
drop if year<${year_min}
sum date_FOMC //replace SP_close = S_P500_p if SP_close==. //g S_P500_p_exreturn00 = vs2_S_P500_p_exreturn //g NASDAQ_p_exreturn00 = vs2_NASDAQ_p_exreturn
local dF1=r(min)
local dF2=r(max)
sum window
local w1 = r(min)
local w1_1 = `w1'+1
local w2 = r(max) 
egen date_BS2 = group(date_BS)
tsset date_BS2 //g VIX_lag = L.VIX_p //g dif_VIX = VIX_p-VIX_lag //reg VIX_p VIX_lag //predict var_p0 //g dif2_VIX = VIX_p-var_p0 //drop var_p0

sort date_day
local W3_L=-1 
local W3_H=0
local W4_L=0  
local W4_H=1
quietly {
forv Wn=3/4 {
local WS=2
foreach var of varlist SP_open { //S_P500_p SP_close
g var0=ln(`var') if window==`W`Wn'_L'
g var1=ln(`var') if window==`W`Wn'_H'
bysort date_FOMC: egen var00=mean(var0)
bysort date_FOMC: egen var11=mean(var1)
g `var'_CR=var11-var00 if window==0
replace `var'_CR=ln(SP_close)-ln(SP_open) if `var'_CR==. & window==0
drop var0 var1 var00 var11
g var0 = ${TBill_rfree} if window>=`W`Wn'_L' & window<=`W`Wn'_H'
bysort date_FOMC: egen var1 = mean(var0)
replace var1 = 0 if var1==.
g `var'_CER = `var'_CR - (`Wn'-2)*ln(1+0.01*var1)/262 if window==0
replace `var'_CR=`var'_CR*(262/`WS')
replace `var'_CER=`var'_CER*(262/`WS')
drop var0 var1
}
if `Wn'==4 {
g SP1_CR = SP_open_CR if window==0 
g SP1_CER = SP1_CR-ln(1+0.01*max(0,${TBill_rfree}))
}
foreach var of varlist SP*CR SP*CER { 
rename `var' `var'_`Wn'
}
}
}
bysort date_FOMC: egen var0=mean(SP_open_CR_3)
replace var0=0 if var0==.
g var00=-(SP1_CR_4-SP_open_CR_4) if SP1_CR_4<. //g var00=-(SP1_CR_4-SP_open_CR_4) if SP1_CR_4<. //-min(0,SP1_CR_4-SP_open_CR_4) if SP1_CR_4<. //-2 or -
bysort date_FOMC: egen var_dif=mean(var00)
g SP1_CR = var0+SP_open_CR_4 if window==0 
replace SP1_CR = var0+var_dif if window==-1 
replace SP1_CR = 0 if window==-2
drop var0 var00 
bysort date_FOMC: egen var0 = mean(SP_open_CER_3)
replace var0=0 if var0==.
g SP1_CER = var0+SP_open_CER_4 if window==0 
replace SP1_CER = var0+var_dif if window==-1 
replace SP1_CER = 0 if window==-2
drop var0 var_dif
save "$path3\data_temp.dta", replace

use "$path3\data_temp.dta", clear
keep if FOMC_public==0 
collapse (mean) SP1_CR SP1_CER, by(window1 dissent) 
replace window1=window1+1
drop if window1>1  | window1<-1
xtset dissent window1
label variable dissent "dissent"
label def dissent_l 0 "Unanimity" 1 "Dissent"
label values dissent dissent_l
label variable SP1_CR "S&P returns"
label variable SP1_CER "S&P excess returns"
xtline SP1_CR SP1_CER, byopts(title("")) byopts(note("")) lp("l" "_...") lwidth(medthick medthick) xlabel(-1(1)1) xtick(-1(1)1) /// 
ylabel(0(0.10)1) ytick(0(0.05)1) legend(cols(2) span forcesize) xtitle("Day from FOMC decision") ytitle("Cumulative Returns")
graph export "$path_g\sp500_crcer_pub0.emf", replace  

use "$path3\data_temp.dta", clear
keep if FOMC_public==1 
collapse (mean) SP1_CR SP1_CER, by(window1 dissent)  //collapse (mean) SP1_CR SP1_CER, by(window1 dissent) 
replace window1=window1+1
drop if window1>1  | window1<-1
replace SP1_CR=0.620 if dissent==0 & window1==1
replace SP1_CER=0.603 if dissent==0 & window1==1
xtset dissent window1
label variable dissent "dissent"
label def dissent_l 0 "Unanimity" 1 "Dissent"
label values dissent dissent_l
label variable SP1_CR "S&P returns"
label variable SP1_CER "S&P excess returns"
xtline SP1_CR SP1_CER, byopts(title("")) byopts(note("")) lp("l" "_...") lwidth(medthick medthick) xlabel(-1(1)1) xtick(-1(1)1) /// 
ylabel(0(0.10)0.6) ytick(0(0.05)0.6) legend(cols(2) span  forcesize) xtitle("Day from FOMC decision") ytitle("Cumulative Returns")
graph export "$path_g\sp500_crcer_pub1.emf", replace  

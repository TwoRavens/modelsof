*Contractionary Devaluation Risk: Evidence from the Free Silver Movement, 1878-1900
*Colin Weiss (colin.r.weiss@frb.gov)
*For use with Stata 14
*This program generates the impulse response functions using local projection techniques and performs a granger causality analysis on the silver shocks*
*It makes use of two commands that are not pre-installed on Stata: ivreg2 and regsave.*

clear
*Set your directory*
global root "C:\Users\m1crw01\Downloads"
*Insert preferred directory above*

global temp "$root\temp"
*Install ivreg2 and regsave
ssc install ivreg2
ssc install regsave

*Load in the data*
use "$root\devaluationrisk_monthlydata.dta"

tsset date
*Table 6 (Granger Causality)*
*Column 1 (All events)*
qui var IP_Smooth_Change General_Inflation Expect_Depreciation Silver_HPR, lags(1/6)
vargranger
*Column 2(Summer of 1893 Events=0)
replace Silver_HPR=0 if date>tm(1893m6) & date<tm(1893m11)
qui var IP_Smooth_Change General_Inflation Expect_Depreciation Silver_HPR, lags(1/6)
vargranger
*Column 3(Summer of 1893 Events dropped)
replace Silver_HPR=. if date>tm(1893m6) & date<tm(1893m11)
qui var IP_Smooth_Change General_Inflation Expect_Depreciation Silver_HPR, lags(1/6)
vargranger
*Column 4(Summer of 1893 and August 1896 and November 1896 dropped)
replace Silver_HPR=. if date==tm(1896m8) | date==tm(1896m11)
qui var IP_Smooth_Change General_Inflation Expect_Depreciation Silver_HPR, lags(1/6)
vargranger

*Re-load the data*
use "$root\devaluationrisk_monthlydata.dta", clear
tsset date

*Currency risk premium IRF*
*First regression, h=0, separate to create file for IRF, all other horizions append to this file
qui ivreg2 Expect_Depreciation Silver_HPR L(1/6).Expect_Depreciation L(1/6).Price_Level L(1/6).MRIP_Smooth date, level(90) bw(auto)
regsave Silver_HPR using "$root\currencyriskirf.dta", ci level(90) replace

*All other forecast horizions, h=[1,24]
forvalues i=1/24 {
qui ivreg2 F(`i').Expect_Depreciation Silver_HPR L(1/6).Expect_Depreciation L(1/6).Price_Level L(1/6).MRIP_Smooth date, level(90) bw(auto)
regsave Silver_HPR using "$root\currencyriskirf.dta", ci level(90) append
}
************************************************************************
*Industrial Production IRF*
*First regression, h=0, separate to create file for IRF, all other horizions append to this file
qui ivreg2 MRIP_Smooth Silver_HPR L(1/6).Expect_Depreciation L(1/6).Price_Level L(1/6).MRIP_Smooth date, level(90) bw(auto)
regsave Silver_HPR using "$root\IPirf.dta", ci level(90) replace

*All other forecast horizions, h=[1,24]
forvalues i=1/24 {
qui ivreg2 F(`i').MRIP_Smooth Silver_HPR L(1/6).Expect_Depreciation L(1/6).Price_Level L(1/6).MRIP_Smooth date, level(90) bw(auto)
regsave Silver_HPR using "$root\IPirf.dta", ci level(90) append
}
***************************************************************************************
*Pig Iron Production IRF*
*First regression, h=0, separate to create file for IRF, all other horizions append to this file
qui ivreg2 Pig_Iron Silver_HPR L(1/6).Expect_Depreciation L(1/6).Price_Level L(1/6).Pig_Iron date, level(90) bw(auto)
regsave Silver_HPR using "$root\Ironirf.dta", ci level(90) replace

*All other forecast horizions, h=[1,24]
forvalues i=1/24 {
qui ivreg2 F(`i').Pig_Iron Silver_HPR L(1/6).Expect_Depreciation L(1/6).Price_Level L(1/6).Pig_Iron date, level(90) bw(auto)
regsave Silver_HPR using "$root\Ironirf.dta", ci level(90) append
}

*****************************************************************************************
*Factory Employment IRF* 
*First regression, h=0, separate to create file for IRF, all other horizions append to this file
qui ivreg2 Fact_Emp Silver_HPR L(1/6).Expect_Depreciation L(1/6).Price_Level L(1/6).Fact_Emp date, level(90) bw(auto)
regsave Silver_HPR using "$root\Factoryirf.dta", ci level(90) replace

*All other forecast horizions, h=[1,24]
forvalues i=1/24 {
qui ivreg2 F(`i').Factory_Emp Silver_HPR L(1/6).Expect_Depreciation L(1/6).Price_Level L(1/6).Fact_Emp date, level(90) bw(auto)
regsave Silver_HPR using "$root\Factoryirf.dta", ci level(90) append
}
**************************************************************************************
*Net Gold Inflows
*Generate month dummies for seasonal adjustment
gen date2=dofm(date)
gen month=month(date2)
drop date2

*Generate cumulative net inflows
*One month ahead
gen cumulative_gold1=Net_Gold+F.Net_Gold
forvalues i=2/24 {
local j = `i'-1
gen cumulative_gold`i'=.
replace cumulative_gold`i'=cumulative_gold`j'+Net_Gold[_n+`i']

}
*First_Regression h=0*
qui xi: ivreg2 Net_Gold Silver_HPR L(1/6).Net_Gold i.month, level(90) bw(auto)
regsave Silver_HPR using "$root\Goldirf.dta", ci level(90) replace

*All other forecast horizons, h=[1,24]
forvalues i=1/24 {
qui xi: ivreg2 cumulative_gold`i' Silver_HPR L(1/6).Net_Gold i.month, level(90) bw(auto)
regsave Silver_HPR using "$root\Goldirf.dta", ci level(90) append
}

****************************************************************************************
*External Instruments IRF for Industrial Production
*First_Regression h=0*
qui ivreg2 MRIP_Smooth L(1/6).Expect_Depreciation L(1/6).Price_Level L(1/6).MRIP_Smooth (Expect_Depreciation=L(3).Silver_HPR), level(90) bw(auto)
regsave Expect_Depreciation using "$root\ExtInstirf.dta", ci level(90) replace

*All other forecast horizons, h=[1,24]
forvalues i=1/24 {
qui ivreg2 F(`i').MRIP_Smooth L(1/6).Expect_Depreciation L(1/6).Price_Level L(1/6).MRIP_Smooth (Expect_Depreciation=L(3).Silver_HPR), level(90) bw(auto)
regsave Expect_Depreciation using "$root\ExtInstirf.dta", ci level(90) append
}
*********************************************************************************************
*Industrial Production IRF Robustness Checks*
*Summer of 1893 Events=0*
replace Silver_HPR=0 if date>tm(1893m6) & date<tm(1893m11)
*First regression, h=0, separate to create file for IRF, all other horizions append to this file
qui ivreg2 MRIP_Smooth Silver_HPR L(1/6).Expect_Depreciation L(1/6).Price_Level L(1/6).MRIP_Smooth date, level(90) bw(auto)
regsave Silver_HPR using "$root\IPirf2.dta", ci level(90) replace

*All other forecast horizions, h=[1,24]
forvalues i=1/24 {
qui ivreg2 F(`i').MRIP_Smooth Silver_HPR L(1/6).Expect_Depreciation L(1/6).Price_Level L(1/6).MRIP_Smooth date, level(90) bw(auto)
regsave Silver_HPR using "$root\IPirf2.dta", ci level(90) append
}


*Drop Summer of 1893 and August 1896 and November 1896*
replace Silver_HPR=. if date>tm(1893m6) & date<tm(1893m11)
replace Silver_HPR=. if date==tm(1896m8) | date==tm(1896m11)
*First regression, h=0, separate to create file for IRF, all other horizions append to this file
qui ivreg2 MRIP_Smooth Silver_HPR L(1/6).Expect_Depreciation L(1/6).Price_Level L(1/6).MRIP_Smooth date, level(90) bw(auto)
regsave Silver_HPR using "$root\IPirf3.dta", ci level(90) replace

*All other forecast horizions, h=[1,24]
forvalues i=1/24 {
qui ivreg2 F(`i').MRIP_Smooth Silver_HPR L(1/6).Expect_Depreciation L(1/6).Price_Level L(1/6).MRIP_Smooth date, level(90) bw(auto)
regsave Silver_HPR using "$root\IPirf3.dta", ci level(90) append
}

